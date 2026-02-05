-- DDL Export
-- Server: 10.254.33.21
-- Database: Franchisee
-- Exported: 2026-02-05T11:26:55.437530

USE Franchisee;
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
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__3F466844] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Calc_Franchisee
-- --------------------------------------------------
CREATE Procedure [dbo].[Calc_Franchisee](@fydate as varchar(25),@tdate as varchar(25))                      
as                      
--------------------------------------ABLCM-----------------------------------------------------------------------                      
            
/*select costcode,costname into #bse from anand.account_ab.dbo.costmast c, anand.account_ab.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/          
Set Nocount on           
    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #bse1                 
from AngelBSECM.account_ab.dbo.ledger l  ,AngelBSECM.account_ab.dbo.vmast v  , AngelBSECM.account_ab.dbo.ledger2 l2                
left outer join AngelBSECM.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, AngelBSECM.account_ab.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ABLCM' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and        
 costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname               
        
/*                      
select l2.cltcode , acname=isnull(a.acname,''), branchcode,costcode, Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end)                      
into #bse1                      
from anand.account_ab.dbo.ledger l , anand.account_ab.dbo.ledger2 l2                         
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode=  a.cltcode                         
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode in (select costcode from #bse)                       
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ABLCM' and flag<>'X')                      
and vdt >= @fydate                       
and vdt <= @tdate and a.accat <> 4                          
group by l2.Cltcode , a.acname, branchcode,costcode                      
*/              
                      
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_bsecm                      
select code=cltcode,particulars=acname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #bse1            
/*a                      
left outer join                      
#bse b                      
on a.costcode=b.costcode                      
order by a.costcode                      
*/              
                      
-------------------------------------ACDLCM------------------------------------------------------------------------                      
/*select costcode,costname into #nse from anand1.account.dbo.costmast c, anand1.account.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/              
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #nse1                    
from AngelNseCM.account.dbo.ledger l  ,AngelNseCM.account.dbo.vmast v  , AngelNseCM.account.dbo.ledger2 l2                
left outer join AngelNseCM.account.dbo.acmast a  on l2.cltcode = a.cltcode, AngelNseCM.account.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLCM' and flag<>'X' union select '520012')            
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype       
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname               
                         
                           
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_nsecm                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #nse1             
             
-------------------------------------ACDLFO------------------------------------------------------------------------                      
/*select costcode,costname into #fo from angelfo.accountfo.dbo.costmast c, angelfo.accountfo.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
 */              
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #fo1                    
from  angelfo.accountfo.dbo.ledger l  , angelfo.accountfo.dbo.vmast v  ,  angelfo.accountfo.dbo.ledger2 l2                
left outer join  angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode,  angelfo.accountfo.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname              
/*                     
select l2.cltcode , acname=isnull(a.acname,''), branchcode,costcode, Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end)                      
into #fo1                      
from angelfo.accountfo.dbo.ledger l , angelfo.accountfo.dbo.ledger2 l2                         
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode=  a.cltcode                         
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode in (select costcode from #fo)                       
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X')                      
and vdt >= @fydate                       
and vdt <= @tdate and a.accat <> 4                          
group by l2.Cltcode , a.acname, branchcode,costcode                      
*/                      
                    
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_nsefo                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #fo1                   
                      
-------------------------------------ACPLMCX------------------------------------------------------------------------                      
/*select costcode,costname into #mcx from angelcommodity.accountmcdx.dbo.costmast c, angelcommodity.accountmcdx.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #mcx1                    
from angelcommodity.accountmcdx.dbo.ledger l  ,angelcommodity.accountmcdx.dbo.vmast v  , angelcommodity.accountmcdx.dbo.ledger2 l2                
left outer join angelcommodity.accountmcdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountmcdx.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCX' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname                    
                      
delete from Franchisee_mcdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
Insert into Franchisee_mcdx                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #mcx1                    
                      
-------------------------------------ACPLNCDX------------------------------------------------------------------------                      
/*select costcode,costname into #ncx from angelcommodity.accountncdx.dbo.costmast c, angelcommodity.accountncdx.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #ncx1                    
from angelcommodity.accountncdx.dbo.ledger l  ,angelcommodity.accountncdx.dbo.vmast v  , angelcommodity.accountncdx.dbo.ledger2 l2                
left outer join angelcommodity.accountncdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountncdx.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname                      
                      
delete from Franchisee_ncdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_ncdx                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #ncx1    
    
    
exec Franch_Income_summary1 @tdate,'I'    
exec Franch_Income_summary1 @tdate,'E'    
exec Franch_Income_summary1 @tdate,'O'    
exec Franch_Income_summary1 @tdate,'N'    
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Calc_Franchisee_23122022
-- --------------------------------------------------
Create Procedure [dbo].[Calc_Franchisee_23122022](@fydate as varchar(25),@tdate as varchar(25))                      
as                      
--------------------------------------ABLCM-----------------------------------------------------------------------                      
            
/*select costcode,costname into #bse from anand.account_ab.dbo.costmast c, anand.account_ab.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/          
Set Nocount on           
    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #bse1                 
from anand.account_ab.dbo.ledger l  ,anand.account_ab.dbo.vmast v  , anand.account_ab.dbo.ledger2 l2                
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, anand.account_ab.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ABLCM' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and        
 costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname               
        
/*                      
select l2.cltcode , acname=isnull(a.acname,''), branchcode,costcode, Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end)                      
into #bse1                      
from anand.account_ab.dbo.ledger l , anand.account_ab.dbo.ledger2 l2                         
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode=  a.cltcode                         
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode in (select costcode from #bse)                       
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ABLCM' and flag<>'X')                      
and vdt >= @fydate                       
and vdt <= @tdate and a.accat <> 4                          
group by l2.Cltcode , a.acname, branchcode,costcode                      
*/              
                      
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_bsecm                      
select code=cltcode,particulars=acname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #bse1            
/*a                      
left outer join                      
#bse b                      
on a.costcode=b.costcode                      
order by a.costcode                      
*/              
                      
-------------------------------------ACDLCM------------------------------------------------------------------------                      
/*select costcode,costname into #nse from anand1.account.dbo.costmast c, anand1.account.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/              
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #nse1                    
from anand1.account.dbo.ledger l  ,anand1.account.dbo.vmast v  , anand1.account.dbo.ledger2 l2                
left outer join anand1.account.dbo.acmast a  on l2.cltcode = a.cltcode, anand1.account.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLCM' and flag<>'X' union select '520012')            
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype       
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname               
                         
                           
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_nsecm                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #nse1             
             
-------------------------------------ACDLFO------------------------------------------------------------------------                      
/*select costcode,costname into #fo from angelfo.accountfo.dbo.costmast c, angelfo.accountfo.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
 */              
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #fo1                    
from  angelfo.accountfo.dbo.ledger l  , angelfo.accountfo.dbo.vmast v  ,  angelfo.accountfo.dbo.ledger2 l2                
left outer join  angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode,  angelfo.accountfo.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname              
/*                     
select l2.cltcode , acname=isnull(a.acname,''), branchcode,costcode, Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end)                      
into #fo1                      
from angelfo.accountfo.dbo.ledger l , angelfo.accountfo.dbo.ledger2 l2                         
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode=  a.cltcode                         
where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode in (select costcode from #fo)                       
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X')                      
and vdt >= @fydate                       
and vdt <= @tdate and a.accat <> 4                          
group by l2.Cltcode , a.acname, branchcode,costcode                      
*/                      
                    
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_nsefo                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #fo1                   
                      
-------------------------------------ACPLMCX------------------------------------------------------------------------                      
/*select costcode,costname into #mcx from angelcommodity.accountmcdx.dbo.costmast c, angelcommodity.accountmcdx.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #mcx1                    
from angelcommodity.accountmcdx.dbo.ledger l  ,angelcommodity.accountmcdx.dbo.vmast v  , angelcommodity.accountmcdx.dbo.ledger2 l2                
left outer join angelcommodity.accountmcdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountmcdx.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCX' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname                    
                      
delete from Franchisee_mcdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
Insert into Franchisee_mcdx                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #mcx1                    
                      
-------------------------------------ACPLNCDX------------------------------------------------------------------------                      
/*select costcode,costname into #ncx from angelcommodity.accountncdx.dbo.costmast c, angelcommodity.accountncdx.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname                       
in (select ftag from Franchisee_Mast (nolock))                      
*/                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname               
into #ncx1                    
from angelcommodity.accountncdx.dbo.ledger l  ,angelcommodity.accountncdx.dbo.vmast v  , angelcommodity.accountncdx.dbo.ledger2 l2                
left outer join angelcommodity.accountncdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountncdx.dbo.costmast c                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18               
and l2.cltcode in (select code from Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX' and flag<>'X' union select '520012')               
And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype               
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname in(select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                   
group by l2.cltcode,a.longname,costname                      
                      
delete from Franchisee_ncdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                      
Insert into Franchisee_ncdx                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                      
from #ncx1    
    
    
exec Franch_Income_summary1 @tdate,'I'    
exec Franch_Income_summary1 @tdate,'E'    
exec Franch_Income_summary1 @tdate,'O'    
exec Franch_Income_summary1 @tdate,'N'    
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.franch_final_cal
-- --------------------------------------------------

    
CREATE proc [dbo].[franch_final_cal]( @tmonth as int,@tyear as int)      
as        
        
set nocount on     
       
select particulars,                   
ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                                      
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                                      
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                                       
and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                                       
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                                       
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                                       
                  
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,                   
                  
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end,

ABLBSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ABLBSX),0) when sum(ABLBSX)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ABLBSX),0) else round(sum(ABLBSX),0) end,


                  
flag,branch,tmonth,tyear--,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode                              
into #file2                             
from dbo.Franch_final1(nolock)                                       
where   tmonth=@tmonth and tyear=@tyear     and flag in ('I_B2B','I_B2C','E','O')            
group by particulars,flag,branch,tmonth,tyear--,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode      
    


    
      
        
select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear        
into #all        
from #file2        
group by flag,branch,tmonth,tyear        
    
    
select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear        
into #I_B2C        
from #file2       
where flag='I_B2C'     
group by flag,branch,tmonth,tyear      
    

select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear  
into #OPERATIONAL_EXPENSES 
from  #file2 where flag='O'
group by flag,branch,tmonth,tyear  

    
          
select ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0))  ,ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))    
,flag='I_B2B',a.branch,a.tmonth,a.tyear        
into #I_B2B        
from  #all a        
left outer join        
(select * from  #all where flag in ('E')) b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
where a.flag in ('I_B2B')        
group by a.branch,a.tmonth,a.tyear        
        
select particular='NET INCOME',ABLCM=sum(isnull(a.ABLCM,0)+isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)+isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)+isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)+isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)+isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)+isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)+isnull(b.ACDLNSX,0)) ,ABLBSX=sum(isnull(a.ABLBSX,0)+isnull(b.ABLBSX,0))        
, a.branch,a.tmonth,a.tyear,flag='net_income' into #netincome from        
(select * from  #I_B2B where flag ='I_B2B')a        
left outer join        
(select * from  #all where flag ='I_B2c')b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
group by a.branch,a.tmonth,a.tyear        
        
        
       
      
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2b_incomepercent) +'% (B2B)'+ b.fname ,ABLCM=a.ABLCM*(b.b2b_incomepercent/100)         
,ACDLCM=a.ACDLCM*(b.b2b_incomepercent/100),ACDLFO=a.ACDLFO*(b.b2b_incomepercent/100),        
ACPLNCDX=a.ACPLNCDX*(b.b2b_incomepercent/100),ACPLMCX=a.ACPLMCX*(b.b2b_incomepercent/100),        
ACPLMCD=a.ACPLMCD*(b.b2b_incomepercent/100),ACDLNSX=a.ACDLNSX*(b.b2b_incomepercent/100),

ABLBSX=a.ABLBSX*(b.b2b_incomepercent/100)

,branch,tmonth,tyear,flag='b2b_franch_share'        
 into #b2b_franch_share        
 from        
(select * from #I_B2B where flag ='I_B2B') a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag       
        
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2c_incomepercent) +'% (B2C)'+ b.fname,ABLCM=a.ABLCM*(b.b2c_incomepercent/100)         
,ACDLCM=a.ACDLCM*(b.b2c_incomepercent/100),ACDLFO=a.ACDLFO*(b.b2c_incomepercent/100),        
ACPLNCDX=a.ACPLNCDX*(b.b2c_incomepercent/100),ACPLMCX=a.ACPLMCX*(b.b2c_incomepercent/100),        
ACPLMCD=a.ACPLMCD*(b.b2c_incomepercent/100),ACDLNSX=a.ACDLNSX*(b.b2c_incomepercent/100),
ABLBSX=a.ABLBSX*(b.b2c_incomepercent/100)
,branch,tmonth,tyear,flag='b2c_franch_share'         
into #b2c_franch_share
 from        
(select * from #I_B2C) a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag        
        
        
 select particular='Total Franchisee share',ABLCM=sum(isnull(a.ABLCM,0)+isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)+isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)+isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)+isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)+isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)+isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)+isnull(b.ACDLNSX,0)),
ABLBSX=sum(isnull(a.ABLBSX,0)+isnull(b.ABLBSX,0))
        
, a.branch,a.tmonth,a.tyear,flag='total_franch_share'         
into #total_franch_share         
from #b2c_franch_share a,#b2b_franch_share b    
where a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear 
group by a.branch,a.tmonth,a.tyear        
        
        


         
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.expenseshare) +'%'+b.fname,ABLCM=a.ABLCM*(b.expenseshare/100)         
,ACDLCM=a.ACDLCM*(b.expenseshare/100),ACDLFO=a.ACDLFO*(b.expenseshare/100),        
ACPLNCDX=a.ACPLNCDX*(b.expenseshare/100),ACPLMCX=a.ACPLMCX*(b.expenseshare/100),        
ACPLMCD=a.ACPLMCD*(b.expenseshare/100),ACDLNSX=a.ACDLNSX*(b.expenseshare/100),

ABLBSX=a.ABLBSX*(b.expenseshare/100)
,branch,tmonth,tyear,flag='expense_franch_share'         
into #expense_franch_share from        
(select * from #OPERATIONAL_EXPENSES) a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag    
        
        
 select particular='Net Profit/(Loss)',ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0)),ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))   
, a.branch,a.tmonth,a.tyear,flag='net_pf_loss'         
into #net_pf_loss         
from #total_franch_share a,#expense_franch_share b   
where  a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear 
group by a.branch,a.tmonth,a.tyear      
      

      
select particular='JV to be passed Profit/(Loss)',ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0)) ,ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))        
 ,a.branch,a.tmonth,a.tyear ,flag='jv_pf_loss'       
into #jv_pf_loss      
from  #net_pf_loss a        
left outer join        
(select * from dbo.Franch_final1(nolock)                                       
where  tmonth=@tmonth and tyear=@tyear  and flag in ('N')) b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
group by a.branch,a.tmonth,a.tyear        
        
delete from franch_final2 where tmonth=@tmonth and tyear=@tyear      
      
insert into franch_final2  
select  particular='Operational Expense',ABLCM,ACDLCM,ACDLFO,ACPLNCDX,ACPLMCX,ACPLMCD,ACDLNSX,ABLBSX,branch,tmonth,tyear,flag from #OPERATIONAL_EXPENSES
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
       
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.franch_final_cal_BSXTEST
-- --------------------------------------------------

    
CREATE proc [dbo].[franch_final_cal_BSXTEST]( @tmonth as int,@tyear as int)      
as        
        
set nocount on     
       
select particulars,                   
ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                                      
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                                      
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                                       
and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                                       
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                                       
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                       
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                                       
                  
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,                   
                  
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end,

ABLBSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                       
and flag='O' then round(-sum(ABLBSX),0) when sum(ABLBSX)<0 and flag in ('I_B2B','I_B2C')                                      
then round(-sum(ABLBSX),0) else round(sum(ABLBSX),0) end,


                  
flag,branch,tmonth,tyear--,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode                              
into #file2                             
from dbo.Franch_final1(nolock)                                       
where   tmonth=@tmonth and tyear=@tyear     and flag in ('I_B2B','I_B2C','E','O')            
group by particulars,flag,branch,tmonth,tyear--,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode      
    


    
      
        
select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear        
into #all        
from #file2        
group by flag,branch,tmonth,tyear        
    
    
select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear        
into #I_B2C        
from #file2       
where flag='I_B2C'     
group by flag,branch,tmonth,tyear      
    

select ABLCM=sum(ABLCM),ACDLCM=sum(ACDLCM),ACDLFO=sum(ACDLFO),ACPLNCDX=sum(ACPLNCDX),ACPLMCX=sum(ACPLMCX),        
ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),ABLBSX=sum(ABLBSX),flag,branch,tmonth,tyear  
into #OPERATIONAL_EXPENSES 
from  #file2 where flag='O'
group by flag,branch,tmonth,tyear  

    
          
select ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0))  ,ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))    
,flag='I_B2B',a.branch,a.tmonth,a.tyear        
into #I_B2B        
from  #all a        
left outer join        
(select * from  #all where flag in ('E')) b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
where a.flag in ('I_B2B')        
group by a.branch,a.tmonth,a.tyear        
        
select particular='NET INCOME',ABLCM=sum(isnull(a.ABLCM,0)+isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)+isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)+isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)+isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)+isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)+isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)+isnull(b.ACDLNSX,0)) ,ABLBSX=sum(isnull(a.ABLBSX,0)+isnull(b.ABLBSX,0))        
, a.branch,a.tmonth,a.tyear,flag='net_income' into #netincome from        
(select * from  #I_B2B where flag ='I_B2B')a        
left outer join        
(select * from  #all where flag ='I_B2c')b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
group by a.branch,a.tmonth,a.tyear        
        
        
       
      
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2b_incomepercent) +'% (B2B)'+ b.fname ,ABLCM=a.ABLCM*(b.b2b_incomepercent/100)         
,ACDLCM=a.ACDLCM*(b.b2b_incomepercent/100),ACDLFO=a.ACDLFO*(b.b2b_incomepercent/100),        
ACPLNCDX=a.ACPLNCDX*(b.b2b_incomepercent/100),ACPLMCX=a.ACPLMCX*(b.b2b_incomepercent/100),        
ACPLMCD=a.ACPLMCD*(b.b2b_incomepercent/100),ACDLNSX=a.ACDLNSX*(b.b2b_incomepercent/100),

ABLBSX=a.ABLBSX*(b.b2b_incomepercent/100)

,branch,tmonth,tyear,flag='b2b_franch_share'        
 into #b2b_franch_share        
 from        
(select * from #I_B2B where flag ='I_B2B') a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag       
        
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.b2c_incomepercent) +'% (B2C)'+ b.fname,ABLCM=a.ABLCM*(b.b2c_incomepercent/100)         
,ACDLCM=a.ACDLCM*(b.b2c_incomepercent/100),ACDLFO=a.ACDLFO*(b.b2c_incomepercent/100),        
ACPLNCDX=a.ACPLNCDX*(b.b2c_incomepercent/100),ACPLMCX=a.ACPLMCX*(b.b2c_incomepercent/100),        
ACPLMCD=a.ACPLMCD*(b.b2c_incomepercent/100),ACDLNSX=a.ACDLNSX*(b.b2c_incomepercent/100),
ABLBSX=a.ABLBSX*(b.b2c_incomepercent/100)
,branch,tmonth,tyear,flag='b2c_franch_share'         
into #b2c_franch_share
 from        
(select * from #I_B2C) a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag        
        
        
 select particular='Total Franchisee share',ABLCM=sum(isnull(a.ABLCM,0)+isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)+isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)+isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)+isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)+isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)+isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)+isnull(b.ACDLNSX,0)),
ABLBSX=sum(isnull(a.ABLBSX,0)+isnull(b.ABLBSX,0))
        
, a.branch,a.tmonth,a.tyear,flag='total_franch_share'         
into #total_franch_share         
from #b2c_franch_share a,#b2b_franch_share b    
where a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear 
group by a.branch,a.tmonth,a.tyear        
        
        


         
        
select particular='Franchisees Share @ '+ convert(varchar(11),b.expenseshare) +'%'+b.fname,ABLCM=a.ABLCM*(b.expenseshare/100)         
,ACDLCM=a.ACDLCM*(b.expenseshare/100),ACDLFO=a.ACDLFO*(b.expenseshare/100),        
ACPLNCDX=a.ACPLNCDX*(b.expenseshare/100),ACPLMCX=a.ACPLMCX*(b.expenseshare/100),        
ACPLMCD=a.ACPLMCD*(b.expenseshare/100),ACDLNSX=a.ACDLNSX*(b.expenseshare/100),

ABLBSX=a.ABLBSX*(b.expenseshare/100)
,branch,tmonth,tyear,flag='expense_franch_share'         
into #expense_franch_share from        
(select * from #OPERATIONAL_EXPENSES) a        
left outer join        
(select * from franchisee_mast  )b        
on a.branch=b.ftag    
        
        
 select particular='Net Profit/(Loss)',ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0)),ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))   
, a.branch,a.tmonth,a.tyear,flag='net_pf_loss'         
into #net_pf_loss         
from #total_franch_share a,#expense_franch_share b   
where  a.branch=b.branch  and a.tmonth=b.tmonth and a.tyear=b.tyear 
group by a.branch,a.tmonth,a.tyear      
      

      
select particular='JV to be passed Profit/(Loss)',ABLCM=sum(isnull(a.ABLCM,0)-isnull(b.ABLCM,0)),ACDLCM=sum(isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)),        
ACDLFO=sum(isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)),ACPLNCDX=sum(isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0))        
,ACPLMCX=sum(isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)),        
ACPLMCD=sum(isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)),ACDLNSX=sum(isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0)) ,ABLBSX=sum(isnull(a.ABLBSX,0)-isnull(b.ABLBSX,0))        
 ,a.branch,a.tmonth,a.tyear ,flag='jv_pf_loss'       
into #jv_pf_loss      
from  #net_pf_loss a        
left outer join        
(select * from dbo.Franch_final1(nolock)                                       
where  tmonth=@tmonth and tyear=@tyear  and flag in ('N')) b        
on a.branch=b.branch and a.tmonth=b.tmonth and a.tyear=b.tyear        
group by a.branch,a.tmonth,a.tyear        
        
delete from franch_final2 where tmonth=@tmonth and tyear=@tyear      
      
insert into franch_final2  
select  particular='Operational Expense',ABLCM,ACDLCM,ACDLFO,ACPLNCDX,ACPLMCX,ACPLMCD,ACDLNSX,branch,tmonth,tyear,flag from #OPERATIONAL_EXPENSES
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
       
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franch_gl_marked
-- --------------------------------------------------
 CREATE Procedure Franch_gl_marked(@coname as varchar(8))          
as          
          
declare @nou as int          
select @nou=count(distinct updt) from Franchisee_glcode_Mast          
          
if @nou>1           
 begin          
 declare @ndt as datetime          
 select @ndt=max(updt) from mis.remisior.dbo.Franchisee_glcode_Mast          
 select a.*,grpId=isnull(b.grpId,0) from         
 (select *,status=case when updt=@ndt then 'NEW' else 'OLD' end from dbo.Franchisee_glcode_Mast with (nolock) where segment=@coname and code<>'520012') a         
 left outer join        
 Grp_code_map b        
 on a.Id=b.GlmastCodeId        
 end          
else          
 begin          
 select a.*,grpId=isnull(b.grpId,0) from        
(select *,status='OLD' from Franchisee_glcode_Mast with (nolock) where segment=@coname and code<>'520012') a          
 left outer join        
 Grp_code_map b        
 on a.Id=b.GlmastCodeId        
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_BSECM
-- --------------------------------------------------
CREATE procedure Franchisee_calc_BSECM(@tdate as varchar(25))          
as          
          
Set nocount On          
          
Set transaction isolation level read uncommitted          
          
select * into #file1 from AngelBSECM.inhouse.dbo.tempbse           
          
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                         
into #bse2                           
from AngelBSECM.account_ab.dbo.vmast v  , #file1 l2                          
left outer join AngelBSECM.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, AngelBSECM.account_ab.dbo.costmast c                                
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                  
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                             
group by l2.cltcode,a.longname,costname             
          
          
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                
Insert into Franchisee_bsecm                                
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                
from #bse2             
 union      
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ABLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)     
UNION      
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ABLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
      
         
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_BSECM_23122022
-- --------------------------------------------------
Create procedure [dbo].[Franchisee_calc_BSECM_23122022](@tdate as varchar(25))          
as          
          
Set nocount On          
          
Set transaction isolation level read uncommitted          
          
select * into #file1 from anand.inhouse.dbo.tempbse           
          
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                         
into #bse2                           
from anand.account_ab.dbo.vmast v  , #file1 l2                          
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, anand.account_ab.dbo.costmast c                                
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                  
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                             
group by l2.cltcode,a.longname,costname             
          
          
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                
Insert into Franchisee_bsecm                                
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                
from #bse2             
 union      
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ABLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)     
UNION      
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ABLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
      
         
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_BSX
-- --------------------------------------------------

       
CREATE procedure [dbo].[Franchisee_calc_BSX](@fydate as varchar(25),@tdate as varchar(25))                      
as                      
                      
Set nocount On                 
          
--declare @fydate as varchar(25),@tdate as varchar(25)               
--          
--set @fydate='01 apr 2009'          
--set @tdate='31 aug 2009 23:59'          
                      
Set transaction isolation level read uncommitted                      
                      
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from ANGELCOMMODITY.AccountCurBFO.dbo.ledger l  , ANGELCOMMODITY.AccountCurBFO.dbo.ledger2 l2                                                        
Where l.vdt >= @fydate and l.vdt <= @tdate  and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ABLBSX' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                      
                    
--select * into #file1 from anand1.account.dbo.angel_tempnse                       
                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                     
into #bsx1                                       
from angelcommodity.AccountCurBFO.dbo.vmast v  , #file1 l2                                      
left outer join ANGELCOMMODITY.AccountCurBFO.dbo.acmast a  on l2.cltcode = a.cltcode, ANGELCOMMODITY.AccountCurBFO.dbo.costmast c                                            
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                              
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                         
group by l2.cltcode,a.longname,costname                         
                      
                      
delete from Franchisee_BSX where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                          
Insert into Franchisee_BSX             
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #bsx1             
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLBSX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLBSX'    and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                
                               
                      
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_MCD
-- --------------------------------------------------
          
CREATE procedure [dbo].[Franchisee_calc_MCD](@fydate as varchar(25),@tdate as varchar(25))                      
as                      
                      
Set nocount On                      
                      
Set transaction isolation level read uncommitted                      
                      
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from angelcommodity.accountmcdxcds.dbo.ledger l  , angelcommodity.accountmcdxcds.dbo.ledger2 l2                                                        
Where l.vdt >= @fydate and l.vdt <= @tdate  and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCD' and code<>'99890'  and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                      
                    
--select * into #file1 from anand1.account.dbo.angel_tempnse                       
                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                     
into #mcd1                                       
from angelcommodity.accountmcdxcds.dbo.vmast v  , #file1 l2                                      
left outer join angelcommodity.accountmcdxcds.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountmcdxcds.dbo.costmast c                                            
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                              
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                         
group by l2.cltcode,a.longname,costname                         
                      
                      
delete from Franchisee_MCD where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                          
Insert into Franchisee_MCD                                          
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #mcd1             
union            
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
UNION            
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD'   and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                    
                               
                      
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_MCDX
-- --------------------------------------------------
CREATE procedure [dbo].[Franchisee_calc_MCDX](@fydate as varchar(25),@tdate as varchar(25))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                    
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                   
into #file1                   
from angelcommodity.accountmcdx.dbo.ledger l  , angelcommodity.accountmcdx.dbo.ledger2 l2                                                      
Where l.vdt >= @fydate and l.vdt <= @tdate  and l2.vtype <> 18                                   
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCX' and flag<>'X' and code<>'99890' union select '520012')                                   
and l.vtyp = l2.vtype                                   
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                    
                  
--select * into #file1 from anand1.account.dbo.angel_tempnse                     
                    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #mcx1                                     
from angelcommodity.accountmcdx.dbo.vmast v  , #file1 l2                                    
left outer join angelcommodity.accountmcdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountmcdx.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
                    
delete from Franchisee_mcdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                          
Insert into Franchisee_mcdx                                        
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                        
from #mcx1                           
union            
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLMCX'     and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
UNION            
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLMCX'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
                    
            
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_NCDX
-- --------------------------------------------------
           
CREATE procedure [dbo].[Franchisee_calc_NCDX](@fydate as varchar(25),@tdate as varchar(25))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                    
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                   
into #file1                   
from angelcommodity.accountncdx.dbo.ledger l  , angelcommodity.accountncdx.dbo.ledger2 l2                                                      
Where l.vdt >= @fydate and l.vdt <= @tdate  and l2.vtype <> 18                                   
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX' and code<>'99890' and flag<>'X' union select '520012')                                   
and l.vtyp = l2.vtype                                   
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                    
                  
--select * into #file1 from anand1.account.dbo.angel_tempnse                     
                    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #ncx1                                     
from angelcommodity.accountncdx.dbo.vmast v  , #file1 l2                                    
left outer join angelcommodity.accountncdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountncdx.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
                    
delete from Franchisee_ncdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                        
Insert into Franchisee_ncdx                                        
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                        
from #ncx1                
union            
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLNCDX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
UNION            
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)              
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLNCDX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                 
                             
                    
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_NSECM
-- --------------------------------------------------

CREATE procedure [dbo].[Franchisee_calc_NSECM](@tdate as varchar(25))            
as            
            
Set nocount On            
            
Set transaction isolation level read uncommitted            
            
select * into #file1 from AngelNseCM.inhouse.dbo.angel_tempnse             
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                           
into #nse2                             
from AngelNseCM.account.dbo.vmast v  , #file1 l2                            
left outer join AngelNseCM.account.dbo.acmast a  on l2.cltcode = a.cltcode, AngelNseCM.account.dbo.costmast c                                  
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                    
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                               
group by l2.cltcode,a.longname,costname               
            
            
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                  
Insert into Franchisee_nsecm                                  
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                  
from #nse2        
union      
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)     
UNION      
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)           
            
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_NSECM_23122022
-- --------------------------------------------------

Create procedure [dbo].[Franchisee_calc_NSECM_23122022](@tdate as varchar(25))            
as            
            
Set nocount On            
            
Set transaction isolation level read uncommitted            
            
select * into #file1 from anand1.inhouse.dbo.angel_tempnse             
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                           
into #nse2                             
from anand1.account.dbo.vmast v  , #file1 l2                            
left outer join anand1.account.dbo.acmast a  on l2.cltcode = a.cltcode, anand1.account.dbo.costmast c                                  
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                    
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                               
group by l2.cltcode,a.longname,costname               
            
            
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                  
Insert into Franchisee_nsecm                                  
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                  
from #nse2        
union      
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)     
UNION      
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)           
            
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_NSEFO
-- --------------------------------------------------
Create procedure Franchisee_calc_NSEFO(@fydate as varchar(25),@tdate as varchar(25))    
as    
    
Set nocount On    
    
Set transaction isolation level read uncommitted    
    
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode   
into #file1   
from angelfo.accountfo.dbo.ledger l  , angelfo.accountfo.dbo.ledger2 l2                                      
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18                   
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X' union select '520012')                   
and l.vtyp = l2.vtype                   
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno    
  
--select * into #file1 from anand1.account.dbo.angel_tempnse     
    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                   
into #fo1                     
from angelfo.accountfo.dbo.vmast v  , #file1 l2                    
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode, angelfo.accountfo.dbo.costmast c                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and            
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                       
group by l2.cltcode,a.longname,costname       
    
    
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                        
Insert into Franchisee_nsefo                        
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                        
from #fo1       
    
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_calc_NSX
-- --------------------------------------------------
       
CREATE procedure Franchisee_calc_NSX(@fydate as varchar(25),@tdate as varchar(25))                      
as                      
                      
Set nocount On                 
          
--declare @fydate as varchar(25),@tdate as varchar(25)               
--          
--set @fydate='01 apr 2009'          
--set @tdate='31 aug 2009 23:59'          
                      
Set transaction isolation level read uncommitted                      
                      
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from Angelfo.accountcurfo.dbo.ledger l  , Angelfo.accountcurfo.dbo.ledger2 l2                                                        
Where l.vdt >= @fydate and l.vdt <= @tdate  and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACDLNSX' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                      
                    
--select * into #file1 from anand1.account.dbo.angel_tempnse                       
                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                     
into #nsx1                                       
from angelcommodity.accountmcdxcds.dbo.vmast v  , #file1 l2                                      
left outer join Angelfo.accountcurfo.dbo.acmast a  on l2.cltcode = a.cltcode, Angelfo.accountcurfo.dbo.costmast c                                            
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                              
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                         
group by l2.cltcode,a.longname,costname                         
                      
                      
delete from Franchisee_NSX where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                          
Insert into Franchisee_NSX             
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #nsx1             
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLNSX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLNSX'    and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                
                               
                      
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchisee_jvfile
-- --------------------------------------------------
CREATE Procedure [dbo].[Franchisee_jvfile](@tmonth as int,@tyear as int,@seg as varchar(10))                  
as                  
Set transaction isolation level read uncommitted                  
              
set Nocount On              
select  ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                             
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag='I'                            
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                            
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                             
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag='I'  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                            
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                             
and flag='I'  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                             
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                             
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag='I'  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                             
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                             
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag='I'  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                             
flag,branch,tmonth,tyear                          
into #file                    
from dbo.Franch_final1(nolock)                             
where tmonth=@tmonth and tyear=@tyear                       
group by particulars,flag,branch,tmonth,tyear        
          
        
                
select ABLCM=sum(ABLCM),                        
ACDLCM= sum(ACDLCM),                        
ACDLFO=sum(ACDLFO),                         
ACPLNCDX=sum(ACPLNCDX),                         
ACPLMCX=sum(ACPLMCX),                         
flag,branch,tmonth,tyear                  
into #file1                         
from #file                  
group by flag,branch,tmonth,tyear                  
                  
select * into #income from #file1 where flag in ('I_B2C','I_B2B')                  
select * into #expense from #file1 where flag='E'                  
                  
select ablcm=a.ablcm-isnull(b.ablcm,0),                                
acdlcm=a.acdlcm-isnull(b.acdlcm,0),acdlfo=a.acdlfo-isnull(b.acdlfo,0),                                
acplncdx=a.acplncdx-isnull(b.acplncdx,0),acplmcx=a.acplmcx-isnull(b.acplmcx,0),branch=isnull(a.branch,b.branch) ,              
acplmcd=abs(a.acplmcd)-isnull(b.acplmcd,0),              
acdlnsx=abs(a.acdlnsx)-isnull(b.acdlnsx,0)                          
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                              
into #net                                
from #income a                  
left outer join                         
#expense b on a.branch=b.branch                   
                  
select ftag,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare   
into #mast   
from Franchisee_mast (nolock) where todate>=getDate()                                
                              
select ablcm=a.ablcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                                
acdlcm=a.acdlcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acdlfo=a.acdlfo*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),               
acplncdx=a.acplncdx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acplmcx=a.acplmcx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),              
acplmcd=a.acplmcd*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),              
acdlnsx=a.acdlnsx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100) ,                                
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                
into #franchshare                                
from #net a                                
left outer join                                
#mast b                                
on a.branch=b.ftag                    
                  
select * into #OtherExpense from #file1 where flag='O'                  
                  
select ablcm=a.ablcm*isnull(b.ExpenseShare,0)/100,                                
acdlcm=a.acdlcm*isnull(b.ExpenseShare,0)/100,acdlfo=a.acdlfo*isnull(b.ExpenseShare,0)/100,                                
acplncdx=a.acplncdx*isnull(b.ExpenseShare,0)/100,acplmcx=a.acplmcx*isnull(b.ExpenseShare,0)/100,               
 acplmcd=a.acplmcd*isnull(b.ExpenseShare,0)/100,              
acdlnsx=a.acdlnsx*isnull(b.ExpenseShare,0)/100,                               
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                
into #ExpenseShare                                
from #OtherExpense a                                
left outer join                              
#mast b                                
on a.branch=b.ftag                 
                  
select ablcm=isnull(a.ablcm,0)-isnull(b.ablcm,0),                  
acdlcm=isnull(a.acdlcm,0)-isnull(b.acdlcm,0),acdlfo=isnull(a.acdlfo,0)-isnull(b.acdlfo,0),                  
acplncdx=isnull(a.acplncdx,0)-isnull(b.acplncdx,0),acplmcx=isnull(a.acplmcx,0)-isnull(b.acplmcx,0)                  
,branch=isnull(a.branch,b.branch)                   
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                  
into #netprofit                     
from #franchshare a                  
full outer join                   
#ExpenseShare b                  
on a.branch=b.branch                   
                  
select * into #brok from #file1 where flag='N'                   
                  
select ablcm=a.ablcm-isnull(b.ablcm,0),                  
acdlcm=a.acdlcm-isnull(b.acdlcm,0),acdlfo=a.acdlfo-isnull(b.acdlfo,0),                  
acplncdx=a.acplncdx-isnull(b.acplncdx,0),acplmcx=a.acplmcx-isnull(b.acplmcx,0),branch=isnull(a.branch,b.branch)                   
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                    
into #jv                  
from #netprofit a                  
join                   
#brok b on a.branch=b.branch                   
 drop table temp_final         
select *  into temp_final from                
(                
select code=ablcode,DRCR=case when ablcm<0 then 'D' else 'C' end ,amt=abs(ablcm),branch,tmonth,tyear,segment='ABLCM' from #jv a                  
join                  
(select ftag,ablcode from Franch_ledcode(nolock) where ablcode<>'')b                  
on a.branch=b.ftag                  
union                  
select code=acdlcode,DRCR=case when acdlcm<0 then 'D' else 'C' end ,amt=abs(acdlcm),branch,tmonth,tyear,segment='ACDLCM' from #jv a                  
join                  
(select ftag,acdlcode from Franch_ledcode(nolock) where acdlcode<>'')b                  
on a.branch=b.ftag                  
union                  
select code=acdlfocode,DRCR=case when acdlfo<0 then 'D' else 'C' end ,amt=abs(acdlfo),branch,tmonth,tyear,segment='ACDLFO' from #jv a                  
join                  
(select ftag,acdlfocode from Franch_ledcode(nolock) where acdlfocode<>'')b                  
on a.branch=b.ftag                  
union                  
select code=ncdxcode,DRCR=case when acplncdx<0 then 'D' else 'C' end ,amt=abs(acplncdx),branch,tmonth,tyear,segment='NCDX' from #jv a                  
join                  
(select ftag,ncdxcode from Franch_ledcode(nolock) where ncdxcode<>'')b                  
on a.branch=b.ftag                  
union                  
select code=mcdxcode,DRCR=case when acplmcx<0 then 'D' else 'C' end ,amt=abs(acplmcx),branch,tmonth,tyear,segment='MCDX' from #jv a                  
join                  
(select ftag,mcdxcode from Franch_ledcode(nolock) where mcdxcode<>'')b                  
on a.branch=b.ftag  ) a                
left outer join                 
(select ftag,fname from franchisee_mast (nolock) where todate>=getDate()) b                
on a.branch=b.ftag                
order by segment,branch        
      
select * from TEMP_final where segment=@seg AND DRCR='C'             
              
set Nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_BSECM
-- --------------------------------------------------
        
CREATE procedure [dbo].[Franchiseewise_calc_BSECM](@tdate as varchar(25),@ftag as varchar(11))              
as              
              
Set nocount On              
              
Set transaction isolation level read uncommitted              
              
select * into #file1 from AngelBSECM.inhouse.dbo.tempbse               
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                             
into #bse                               
from AngelBSECM.account_ab.dbo.vmast v  , #file1 l2                              
left outer join AngelBSECM.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, AngelBSECM.account_ab.dbo.costmast c                                    
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                      
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                 
group by l2.cltcode,a.longname,costname                 
              
              
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                   
Insert into Franchisee_bsecm                                    
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                    
from #bse         
 union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLCM' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLCM'   and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)              
              
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_BSECM_23122022
-- --------------------------------------------------
        
Create procedure [dbo].[Franchiseewise_calc_BSECM_23122022](@tdate as varchar(25),@ftag as varchar(11))              
as              
              
Set nocount On              
              
Set transaction isolation level read uncommitted              
              
select * into #file1 from anand.inhouse.dbo.tempbse               
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                             
into #bse                               
from anand.account_ab.dbo.vmast v  , #file1 l2                              
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, anand.account_ab.dbo.costmast c                                    
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                      
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                 
group by l2.cltcode,a.longname,costname                 
              
              
delete from Franchisee_bsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                   
Insert into Franchisee_bsecm                                    
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                    
from #bse         
 union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLCM' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ABLCM'   and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)              
              
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_MCD
-- --------------------------------------------------
      
CREATE procedure [dbo].[Franchiseewise_calc_MCD](@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                  
                  
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from angelcommodity.accountmcdxcds.dbo.ledger l  , angelcommodity.accountmcdxcds.dbo.ledger2 l2                                                        
Where l.vdt >=@fydate  and l.vdt <= @tdate + ' 23:59:59'and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCD' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                  
                  
                    
            
--select * into #file1 from anand.account_ab.dbo.tempbse                     
                    
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #mcd                                    
from angelcommodity.accountmcdxcds.dbo.vmast v  , #file1 l2                                    
left outer join AngelBSECM.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, AngelBSECM.account_ab.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
            
            
                    
delete from Franchisee_mcd where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                         
Insert into Franchisee_mcd                                          
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #mcd          
union        
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
       
UNION        
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
                  
                    
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_MCD_23122022
-- --------------------------------------------------
      
CREATE procedure [dbo].[Franchiseewise_calc_MCD_23122022](@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                  
                  
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from angelcommodity.accountmcdxcds.dbo.ledger l  , angelcommodity.accountmcdxcds.dbo.ledger2 l2                                                        
Where l.vdt >=@fydate  and l.vdt <= @tdate + ' 23:59:59'and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCD' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                  
                  
                    
            
--select * into #file1 from anand.account_ab.dbo.tempbse                     
                    
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #mcd                                    
from angelcommodity.accountmcdxcds.dbo.vmast v  , #file1 l2                                    
left outer join anand.account_ab.dbo.acmast a  on l2.cltcode = a.cltcode, anand.account_ab.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
            
            
                    
delete from Franchisee_mcd where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                         
Insert into Franchisee_mcd                                          
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #mcd          
union        
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
       
UNION        
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCD' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
                  
                    
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_MCDX
-- --------------------------------------------------
         
CREATE procedure [dbo].[Franchiseewise_calc_MCDX](@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                      
as                      
                      
Set nocount On                      
                      
Set transaction isolation level read uncommitted                      
                    
                    
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                       
into #file1                       
from angelcommodity.accountmcdx.dbo.ledger l  , angelcommodity.accountmcdx.dbo.ledger2 l2                                                          
Where l.vdt >= @fydate and l.vdt <= @tdate + ' 23:59:59' and l2.vtype <> 18                                       
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCX' and code<>'99890' and flag<>'X' union select '520012')                                       
and l.vtyp = l2.vtype                                       
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                    
                    
                      
--select * into #file1 from anand.account_ab.dbo.tempbse                       
                      
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                     
into #mcx                                      
from angelcommodity.accountmcdx.dbo.vmast v  , #file1 l2                                      
left outer join angelcommodity.accountmcdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountmcdx.dbo.costmast c                                            
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                              
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                         
group by l2.cltcode,a.longname,costname                         
                      
                      
delete from Franchisee_mcdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                           
Insert into Franchisee_mcdx                                            
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                            
from #mcx             
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCX'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from DBO.franchisee_b2b_b2c_brok where segment='ACPLMCX'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                
                      
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NCDX
-- --------------------------------------------------
        
CREATE procedure [dbo].[Franchiseewise_calc_NCDX](@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                  
                  
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from angelcommodity.accountncdx.dbo.ledger l  , angelcommodity.accountncdx.dbo.ledger2 l2                                                        
Where l.vdt >= @fydate and l.vdt <= @tdate + ' 23:59:59' and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                   
                  
                    
--select * into #file1 from anand.account_ab.dbo.tempbse                     
                    
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #ncx                                    
from angelcommodity.accountncdx.dbo.vmast v  , #file1 l2                                    
left outer join angelcommodity.accountncdx.dbo.acmast a  on l2.cltcode = a.cltcode, angelcommodity.accountncdx.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
                    
delete from Franchisee_ncdx where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                         
Insert into Franchisee_ncdx                                          
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #ncx         
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLNCDX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
           
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACPLNCDX'   and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
   
      
Set nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NSECM
-- --------------------------------------------------
     
CREATE procedure [dbo].[Franchiseewise_calc_NSECM](@tdate as varchar(25),@ftag as varchar(11))                
as                
                
Set nocount On                
                
Set transaction isolation level read uncommitted                
                
select *           
into #file1           
from AngelNseCM.inhouse.dbo.angel_tempnse                 
                
          
          
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                               
into #nse                                 
from AngelNseCM.account.dbo.vmast v  , #file1 l2                                
left outer join AngelNseCM.account.dbo.acmast a  on l2.cltcode = a.cltcode, AngelNseCM.account.dbo.costmast c                                      
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                        
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                   
group by l2.cltcode,a.longname,costname                   
                
                
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                     
Insert into Franchisee_nsecm                                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                      
from #nse          
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLCM' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)               
                
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NSECM_23122022
-- --------------------------------------------------
     
Create procedure [dbo].[Franchiseewise_calc_NSECM_23122022](@tdate as varchar(25),@ftag as varchar(11))                
as                
                
Set nocount On                
                
Set transaction isolation level read uncommitted                
                
select *           
into #file1           
from anand1.inhouse.dbo.angel_tempnse                 
                
          
          
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                               
into #nse                                 
from anand1.account.dbo.vmast v  , #file1 l2                                
left outer join anand1.account.dbo.acmast a  on l2.cltcode = a.cltcode, anand1.account.dbo.costmast c                                      
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                        
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                   
group by l2.cltcode,a.longname,costname                   
                
                
delete from Franchisee_nsecm where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                     
Insert into Franchisee_nsecm                                      
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                      
from #nse          
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLCM' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLCM'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)               
                
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NSEFO
-- --------------------------------------------------
           
CREATE procedure Franchiseewise_calc_NSEFO(@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                  
as                  
                  
Set nocount On                  
                  
Set transaction isolation level read uncommitted                  
                
                
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                   
into #file1                   
from angelfo.accountfo.dbo.ledger l  , angelfo.accountfo.dbo.ledger2 l2                                                      
Where l.vdt >= @fydate and l.vdt <= @tdate + ' 23:59:59' and l2.vtype <> 18                                   
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X' union select '520012')                                   
and l.vtyp = l2.vtype                                   
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                
                
                  
--select * into #file1 from anand.account_ab.dbo.tempbse                   
                  
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                 
into #fo                                  
from angelfo.accountfo.dbo.vmast v  , #file1 l2                                  
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode, angelfo.accountfo.dbo.costmast c                                        
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                          
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                     
group by l2.cltcode,a.longname,costname                     
                  
                  
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                       
Insert into Franchisee_nsefo                                        
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                        
from #fo         
union          
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from DBO.franchisee_b2b_b2c_brok where segment='ACDLFO' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
UNION          
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)            
from DBO.franchisee_b2b_b2c_brok where segment='ACDLFO'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                   
                             
                  
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NSEFO1
-- --------------------------------------------------
CREATE procedure Franchiseewise_calc_NSEFO1(@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))            
as            
            
Set nocount On            
            
Set transaction isolation level read uncommitted            
    
declare @costcode as varchar(3)  
select @costcode=costcode from angelfo.accountfo.dbo.costmast  where costname=@ftag  
          
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode             
into #file1             
from angelfo.accountfo.dbo.ledger l  , angelfo.accountfo.dbo.ledger2 l2                                                
Where l.vdt >= @fydate and l.vdt <= @tdate and l2.vtype <> 18                             
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACDLFO' and flag<>'X' union select '520012')                             
and l.vtyp = l2.vtype                             
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  
and costcode=@costcode          
          
            
--select * into #file1 from anand.account_ab.dbo.tempbse             
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                           
into #fo                            
from angelfo.accountfo.dbo.vmast v  , #file1 l2                            
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode, angelfo.accountfo.dbo.costmast c                                  
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                    
costname=@ftag and l2.costcode = c.costcode                               
group by l2.cltcode,a.longname,costname               
            
            
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                 
Insert into Franchisee_nsefo                                  
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                  
from #fo              
            
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Franchiseewise_calc_NSX
-- --------------------------------------------------
     
CREATE procedure Franchiseewise_calc_NSX(@fydate as varchar(25),@tdate as varchar(25),@ftag as varchar(11))                    
as                    
                    
Set nocount On                    
                    
Set transaction isolation level read uncommitted                    
                  
                  
select l2.cltcode ,l.vtyp,l2.drcr,camt,costcode                     
into #file1                     
from Angelfo.accountcurfo.dbo.ledger l  , Angelfo.accountcurfo.dbo.ledger2 l2                                                        
Where l.vdt >=@fydate  and l.vdt <= @tdate + ' 23:59:59' and l2.vtype <> 18                                     
and l2.cltcode IN(select code from Franchisee_glcode_Mast (nolock) where segment='ACPLMCD' and code<>'99890' and flag<>'X' union select '520012')                                     
and l.vtyp = l2.vtype                                     
and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno                  
                  
                    
            
--select * into #file1 from anand.account_ab.dbo.tempbse                     
                    
            
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                                   
into #nsx                                    
from Angelfo.accountcurfo.dbo.vmast v  , #file1 l2                                    
left outer join Angelfo.accountcurfo.dbo.acmast a  on l2.cltcode = a.cltcode, Angelfo.accountcurfo.dbo.costmast c                                          
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                            
costname in (select ftag from Franchisee_Mast (nolock) where ftag=@ftag ) and l2.costcode = c.costcode                                       
group by l2.cltcode,a.longname,costname                       
                    
            
            
                    
delete from Franchisee_NSX where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and branch=@ftag                                         
Insert into Franchisee_NSX                                          
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                          
from #nsx         
union        
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACDLNSX'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
       
UNION        
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)          
from DBO.franchisee_b2b_b2c_brok where segment='ACDLNSX' and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)    
                   
                    
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gross_bkg_b2b_b2c
-- --------------------------------------------------
CREATE procedure gross_bkg_b2b_b2c(@SEG AS VARCHAR(10),@fdate as varchar(25),@tdate as varchar(25))                
as                
                
set nocount on                
              
delete from  franchisee_b2b_b2c_brok  where segment=@seg  and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)   
              
        
select BRANCH,subbrokcode,segment,brok_earned=sum(brok_earned)                
into #file        
from MIS.REMISIOR.DBO.comb_sb                 
where sauda_date>=@fdate and sauda_date<=@tdate AND SEGMENT=@SEG          
and BRANCH in (select ftag from Franchisee_Mast (nolock))               
group by BRANCH,subbrokcode,segment        
        
--select sum(brok_earned) from #file where branch='AHD'        
              
insert into franchisee_b2b_b2c_brok              
select A.BRANCH,a.subbrokcode ,segment,                 
 b2b_brok_earned=isnull(case when b.b2c_sb is null then  a.brok_earned end,0) ,                 
b2c_brok_earned=isnull(case when b.b2c_sb is not null then  a.brok_earned end ,0)               
,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)   
 from                
#file a                
left outer join                 
mis.remisior.dbo.b2c_sb b                
on a.subbrokcode=b.b2c_sb                
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.gross_bkg_b2b_b2c_19122016
-- --------------------------------------------------

CREATE procedure [dbo].[gross_bkg_b2b_b2c_19122016](@SEG AS VARCHAR(10),@fdate as varchar(25),@tdate as varchar(25))                
as                
                
set nocount on                
              
delete from  franchisee_b2b_b2c_brok  where segment=@seg  and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)   
              
        
select BRANCH,subbrokcode,segment,brok_earned=sum(brok_earned)                
into #file        
from MIS.REMISIOR.DBO.comb_sb                 
where sauda_date>=@fdate and sauda_date<=@tdate AND SEGMENT=@SEG          
and BRANCH in (select ftag from Franchisee_Mast (nolock))               
group by BRANCH,subbrokcode,segment        
        
--select sum(brok_earned) from #file where branch='AHD'        
              
insert into franchisee_b2b_b2c_brok              
select A.BRANCH,a.subbrokcode ,segment,                 
 b2b_brok_earned=isnull(case when b.b2c_sb is null then  a.brok_earned end,0) ,                 
b2c_brok_earned=isnull(case when b.b2c_sb is not null then  a.brok_earned end ,0)               
,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)   
 from                
#file a                
left outer join                 
mis.remisior.dbo.b2c_sb b                
on a.subbrokcode=b.b2c_sb                
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franch_Income_summary1
-- --------------------------------------------------

CREATE Procedure [dbo].[new_Franch_Income_summary1](@tdate as varchar(25),@flag as varchar(6))                                              
as                                              
/*declare @tdate as varchar(25)                                              
Set @tdate='Dec 31 2007 00:00:00'                                              
declare @flag as varchar(1)                                              
Set @flag='O'                                              
  */                                           
                                            
Set Nocount on                                              
if @flag='N'                                              
BEGIN                      
 update Franchisee_glcode_Mast set flag='N' where code='520012'           
                   
END                       
        
                      
Set transaction isolation level read uncommitted         
---------------------------------------BSE---------------------------------------------------------------------------------                                           
                                              
select ABLCODE=code,particulars,ABLCM=amount,branch,tmonth,tyear                                               
into #bse                                              
from Franchisee_bsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast (nolock) where flag=@flag and segment='ABLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
    
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
                                
       
--------------------------------NSE----------------------------------------------------------------------------------------------      
                                             
select ACDLcode=Code,particulars,ACDLCM=amount,branch,tmonth,tyear                                              
into #nse                                              
from Franchisee_nsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)       
    
if @flag='E'    
Begin        
 insert into #nse      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520013' )      
      insert into #nse      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520011')                                             
END    
                                
select ACDLcode,particulars,ACDLCM=case when ACDLcode='520013'  then isnull(ACDLCM,0)-isnull(nsecm_ba,0)                                    
when ACDLcode='520011'  then isnull(ACDLCM,0)-isnull(nsecm_bp,0)                                    
else ACDLCM end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nse1                                    
from #nse  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
       
      
-----------------------------------------FO---------------------------------------------------------------------------      
                                             
select FoCode=Code,particulars,ACDLFO=amount,branch,tmonth,tyear                                               
into #fo                                              
from Franchisee_nsefo (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLFO')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
    
if @flag='E'    
Begin        
 insert into #fo      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520013' )      
       
 insert into #fo      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520011')                                          
END    
                                 
select FoCode,particulars,ACDLFO=case when FoCode='520013'   then isnull(ACDLFO,0)-isnull(nsefo_ba,0)                            
when FoCode='520011'   then isnull(ACDLFO,0)-isnull(nsefo_bp,0)                                   
else ACDLFO end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #fo1                                    
from #fo  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
                                             
 -----------------------------------------------MCDX-------------------------------------------------------------------------                                             
select MCXCode=Code,particulars,ACPLMCX=amount,branch,tmonth,tyear                                               
into #mcx                                               
from Franchisee_mcdx (nolock)                           
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
  
if @flag='E'    
Begin        
 insert into #mcx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520013' )      
       
 insert into #mcx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520011')                                           
END    
                                     
select MCXCode,particulars,ACPLMCX=case when MCXCode='520013'   then isnull(ACPLMCX,0)-isnull(mcdx_ba,0)                                   
when MCXCode='520011'   then isnull(ACPLMCX,0)-isnull(mcdx_bp,0)                                 
else ACPLMCX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcx1                                    
from #mcx  a                                           
full outer join             BKG_PAID b                                    
on a.branch=b.ftag                                    
       
---------------------------------------------------------NCDX------------------------------------------------------------------------------                                             
select NCXCode=Code,particulars,ACPLNCDX=amount,branch,tmonth,tyear                                              
into #ncx                                              
from Franchisee_ncdx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLNCDX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
      
if @flag='E'    
Begin        
 insert into #ncx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520013' )      
       
 insert into #ncx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520011')                                 
END    
                                    
select NCXCode,particulars,ACPLNCDX=case when NCXCode='520013'   then isnull(ACPLNCDX,0)-isnull(ncdx_ba,0)                                   
when NCXCode='520011'  then isnull(ACPLNCDX,0)-isnull(ncdx_bp,0)                                    
else ACPLNCDX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #ncx1                                    
from #ncx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                               
                   
                
                  
--------------------------------------------------MCD-----------------------------------------------------------------------                  
select MCDCode=Code,particulars,ACPLMCD=amount,branch,tmonth,tyear                                              
into #mcd                                              
from Franchisee_MCD (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCD')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
     
if @flag='E'    
Begin       
 insert into #mcd      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520013' )      
       
 insert into #mcd      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520011')      
END    
                                  
                                    
select MCDCode,particulars,ACPLMCD=case when MCDCode='520013'   then isnull(ACPLMCD,0)-isnull(mcd_ba,0)                                    
when MCDCode='520011'  then isnull(ACPLMCD,0)-isnull(mcd_bp,0)                                    
else ACPLMCD end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcd1                                    
from #mcd a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                     
                  
                  
------------------------------------------------------------NSX-------------------------------------------------------------------------------------------            
 select NSXCode=Code,particulars,ACDLNSX=amount,branch,tmonth,tyear                                              
into #nsx                                              
from Franchisee_nsx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLNSX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
      
if @flag='E'    
Begin        
 insert into #nsx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520013' )      
       
 insert into #nsx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520011')      
END                                  
                                    
select NSXCode,particulars,ACDLNSX=case when NSXCode='520013'   then isnull(ACDLNSX,0)-isnull(nsx_ba,0)                                    
when NSXCode='520011'   then isnull(ACDLNSX,0)-isnull(nsx_bp,0)                            
else ACDLNSX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nsx1                                    
from #nsx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                    
------------------------------------------bsx--------------------------
select BSXCode=Code,particulars,ABLBSX=amount,branch,tmonth,tyear                                              
into #bsx                                              
from Franchisee_bsx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ABLBSX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
      
if @flag='E'    
Begin        
 insert into #bsx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #bsx where BSXCode='520013' )      
       
 insert into #bsx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #bsx where BSXCode='520011')      
END                                  
                                    
select BSXCode,particulars,ABLBSX=case when BSXCode='520013'   then isnull(ABLBSX,0)-isnull(bsx_ba,0)                                    
when BSXCode='520011'   then isnull(ABLBSX,0)-isnull(bsx_bp,0)                            
else ABLBSX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #bsx1                                    
from #bsx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag  
                                       
/*select distinct particulars=isnull(isnull(isnull(isnull(a.particulars,b.particulars),c.particulars),d.particulars),e.particulars)                                              
,ABLCM=isnull(ABLCM,0),ACDLCM=isnull(ACDLCM,0)                                              
,ACDLFO=isnull(ACDLFO,0),ACPLNCDX=isnull(ACPLNCDX,0),ACPLMCX=isnull(ACPLMCX,0),flag=@flag                                              
,branch=isnull(isnull(isnull(isnull(a.branch,b.branch),c.branch),d.branch),e.branch)                                              
,tmonth=isnull(isnull(isnull(isnull(a.tmonth,b.tmonth),c.tmonth),d.tmonth),e.tmonth)                                              
,tyear=isnull(isnull(isnull(isnull(a.tyear,b.tyear),c.tyear),d.tyear),e.tyear)                                              
 from                                              
#bse a                                              
full outer join                                              
#nse b                                               
on a.particulars=b.particulars and a.branch=b.branch               
full outer join                                              
#fo c                                               
on a.particulars=c.particulars and a.branch=c.branch                                              
full outer join                                              
#mcx d                                               
on a.particulars=d.particulars and a.branch=d.branch                                              
full outer join                                              
#ncx e                                               
on a.particulars=e.particulars and a.branch=e.branch                                              
*/                                            
select a.* into #bse2  from #bse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ablcm') b                          
on a.ablcode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #nse2  from #nse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLCM') b                          
on a.AcdlCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #fo2  from #fo1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLFO') b                          
on a.Focode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #mcx2  from #mcx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='MCDX') b                          
on a.McxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #ncx2  from #ncx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='NCDX') b                          
on a.NcxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
               
select a.* into #mcd2  from #mcd1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACPLMCD') b                          
on a.McdCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                   
                  
                  
                  
select a.* into #nsx2  from #nsx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLNSX') b                          
on a.NsxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                    
                  
                  
select a.* into #bsx2  from #bsx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ABLBSX') b                          
on a.BSXCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                    
                  
                  
                  
                  
                                      
select top 0 * into #ff from Franch_final1                                              
insert into #ff (AblCode,particulars,ABLCM,branch,tmonth,tyear) select * from #bse2                          
insert into #ff (AcdlCode,particulars,ACDLCM,branch,tmonth,tyear) select * from #nse2                                             
insert into #ff (Focode,particulars,ACDLFO,branch,tmonth,tyear) select * from #fo2                                            
insert into #ff (McxCode,particulars,ACPLMCX,branch,tmonth,tyear) select * from #mcx2                                            
insert into #ff (NcdxCode,particulars,ACPLNCDX,branch,tmonth,tyear) select * from #ncx2                                           
insert into #ff (McdCode,particulars,ACPLMCD,branch,tmonth,tyear) select * from #mcd2                  
insert into #ff (NsxCode,particulars,ACDLNSX,branch,tmonth,tyear) select * from #nsx2                                        

insert into #ff (bsxCode,particulars,ABLBSX,branch,tmonth,tyear) select * from #bsx2   
  
                           
delete from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and flag=@flag                                             
Insert into Franch_final1                                  
select particular,                  
ablcm=case when segment='ABLCM' then amount else 0 end,                  
acdlcm=case when segment='ACDLCM' then amount else 0 end,                  
acdlfo=case when segment='ACDLFO' then amount else 0 end,                   
ncdx=case when segment='ACPLNCDX' then amount else 0 end,                    
mcx=case when segment='ACPLMCX' then amount else 0 end,               
mcd=case when segment='ACPLMCD' then amount else 0 end,                 
nsx=case when segment='ACDLNSX' then amount else 0 end,                    
                  
flag=type,branch=franchisee_code                              
,month,year,0,0,0,0,0,0,0  ,
bsx=case when segment='ABLBSX' then amount else 0 end,0
                    
from Franch_ExtraExpense WHERE month=datepart(mm,@tdate) and year=datepart(yy,@tdate) and TYPE=@flag                            
                        
--SELECT * FROM Franch_ExtraExpense                          
                                
Insert into Franch_final1                                              
select particulars,                                            
ablcm=sum(isnull(ablcm,0)),                                            
acdlcm=sum(isnull(acdlcm,0)),                                            
acdfo=sum(isnull(acdlfo,0)),                                            
acplncdx=sum(isnull(acplncdx,0)),                                          
acdplmcx=sum(isnull(acplmcx,0)),                  
                                         
acplmcd=sum(isnull(acplmcd,0)),                  
acdlnsx=sum(isnull(acdlnsx,0)),                                        
flag=@FLAG,                                              
branch,                                            
tmonth,                                            
tyear,                                        
AblCode=max(isnull(AblCode,'')),                                            
AcdlCode=max(isnull(AcdlCode,'')),                                            
Focode=max(isnull(Focode,'')),                                            
NcdxCode=max(isnull(NcdxCode,'')),                                          
McxCode=max(isnull(McxCode,'')) ,                   
 McdCode=max(isnull(McdCode,'')) ,                 
NsxCode=max(isnull(NsxCode,'')),                                        
ABLBSX =sum(isnull(ABLBSX,0)),
BsxCode=max(isnull(NsxCode,''))                                            
from #ff                                            
group by                                             
particulars,branch,tmonth,tyear            
        
if @flag='N'                                              
BEGIN                      
 if (select count(1) from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and ablcode='520012')=0        
 BEGIN        
 insert into Franch_final1        
 select particulars='BROKERAGE PAID TO FRANCHISEE',                                            
 ablcm=convert(money,0),                                            
 acdlcm=convert(money,0),                                            
 acdfo=convert(money,0),                                            
 acplncdx=convert(money,0),                                          
 acdplmcx=convert(money,0),                  
 acplmcd=convert(money,0),                  
 acdlnsx=convert(money,0),                                        
 flag='N',                                              
 branch=ftag,                                            
 tmonth=datepart(mm,@tdate),                                            
 tyear=datepart(yy,@tdate),                                        
 AblCode='520012',                                            
 AcdlCode='520012',                                            
 Focode='520012',                                            
 NcdxCode='520012',                                          
 McxCode='520012',                   
  McdCode='520012',                 
 NsxCode='520012'    ,
 ablbsx=convert(money,0), 
 bsxCode='520012'  
 from franchisee_mast  (nolock)        
 where todate>getdate()           
 END                                      
END                                             
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franch_Income_summary1_19122016
-- --------------------------------------------------


CREATE Procedure [dbo].[new_Franch_Income_summary1_19122016](@tdate as varchar(25),@flag as varchar(6))                                              
as                                              
/*declare @tdate as varchar(25)                                              
Set @tdate='Dec 31 2007 00:00:00'                                              
declare @flag as varchar(1)                                              
Set @flag='O'                                              
  */                                           
                                            
Set Nocount on                                              
if @flag='N'                                              
BEGIN                      
 update Franchisee_glcode_Mast set flag='N' where code='520012'           
                   
END                       
        
                      
Set transaction isolation level read uncommitted         
---------------------------------------BSE---------------------------------------------------------------------------------                                           
                                              
select ABLCODE=code,particulars,ABLCM=amount,branch,tmonth,tyear                                               
into #bse                                              
from Franchisee_bsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast (nolock) where flag=@flag and segment='ABLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
    
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
                                
       
--------------------------------NSE----------------------------------------------------------------------------------------------      
                                             
select ACDLcode=Code,particulars,ACDLCM=amount,branch,tmonth,tyear                                              
into #nse                                              
from Franchisee_nsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)       
    
if @flag='E'    
Begin        
 insert into #nse      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520013' )      
      insert into #nse      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520011')                                             
END    
                                
select ACDLcode,particulars,ACDLCM=case when ACDLcode='520013'  then isnull(ACDLCM,0)-isnull(nsecm_ba,0)                                    
when ACDLcode='520011'  then isnull(ACDLCM,0)-isnull(nsecm_bp,0)                                    
else ACDLCM end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nse1                                    
from #nse  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
       
      
-----------------------------------------FO---------------------------------------------------------------------------      
                                             
select FoCode=Code,particulars,ACDLFO=amount,branch,tmonth,tyear                                               
into #fo                                              
from Franchisee_nsefo (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLFO')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
    
if @flag='E'    
Begin        
 insert into #fo      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520013' )      
       
 insert into #fo      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520011')                                          
END    
                                 
select FoCode,particulars,ACDLFO=case when FoCode='520013'   then isnull(ACDLFO,0)-isnull(nsefo_ba,0)                            
when FoCode='520011'   then isnull(ACDLFO,0)-isnull(nsefo_bp,0)                                   
else ACDLFO end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #fo1                                    
from #fo  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
                                             
 -----------------------------------------------MCDX-------------------------------------------------------------------------                                             
select MCXCode=Code,particulars,ACPLMCX=amount,branch,tmonth,tyear                                               
into #mcx                                               
from Franchisee_mcdx (nolock)                           
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
  
if @flag='E'    
Begin        
 insert into #mcx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520013' )      
       
 insert into #mcx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520011')                                           
END    
                                     
select MCXCode,particulars,ACPLMCX=case when MCXCode='520013'   then isnull(ACPLMCX,0)-isnull(mcdx_ba,0)                                   
when MCXCode='520011'   then isnull(ACPLMCX,0)-isnull(mcdx_bp,0)                                 
else ACPLMCX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcx1                                    
from #mcx  a                                           
full outer join             BKG_PAID b                                    
on a.branch=b.ftag                                    
       
---------------------------------------------------------NCDX------------------------------------------------------------------------------                                             
select NCXCode=Code,particulars,ACPLNCDX=amount,branch,tmonth,tyear                                              
into #ncx                                              
from Franchisee_ncdx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLNCDX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
      
if @flag='E'    
Begin        
 insert into #ncx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520013' )      
       
 insert into #ncx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520011')                                 
END    
                                    
select NCXCode,particulars,ACPLNCDX=case when NCXCode='520013'   then isnull(ACPLNCDX,0)-isnull(ncdx_ba,0)                                   
when NCXCode='520011'  then isnull(ACPLNCDX,0)-isnull(ncdx_bp,0)                                    
else ACPLNCDX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #ncx1                                    
from #ncx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                               
                   
                
                  
--------------------------------------------------MCD-----------------------------------------------------------------------                  
select MCDCode=Code,particulars,ACPLMCD=amount,branch,tmonth,tyear                                              
into #mcd                                              
from Franchisee_MCD (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCD')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
     
if @flag='E'    
Begin       
 insert into #mcd      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520013' )      
       
 insert into #mcd      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520011')      
END    
                                  
                                    
select MCDCode,particulars,ACPLMCD=case when MCDCode='520013'   then isnull(ACPLMCD,0)-isnull(mcd_ba,0)                                    
when MCDCode='520011'  then isnull(ACPLMCD,0)-isnull(mcd_bp,0)                                    
else ACPLMCD end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcd1                                    
from #mcd a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                     
                  
                  
------------------------------------------------------------NSX-------------------------------------------------------------------------------------------            
 select NSXCode=Code,particulars,ACDLNSX=amount,branch,tmonth,tyear                                              
into #nsx                                              
from Franchisee_nsx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLNSX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
      
if @flag='E'    
Begin        
 insert into #nsx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520013' )      
       
 insert into #nsx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520011')      
END                                  
                                    
select NSXCode,particulars,ACDLNSX=case when NSXCode='520013'   then isnull(ACDLNSX,0)-isnull(nsx_ba,0)                                    
when NSXCode='520011'   then isnull(ACDLNSX,0)-isnull(nsx_bp,0)                            
else ACDLNSX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nsx1                                    
from #nsx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                    
                                       
/*select distinct particulars=isnull(isnull(isnull(isnull(a.particulars,b.particulars),c.particulars),d.particulars),e.particulars)                                              
,ABLCM=isnull(ABLCM,0),ACDLCM=isnull(ACDLCM,0)                                              
,ACDLFO=isnull(ACDLFO,0),ACPLNCDX=isnull(ACPLNCDX,0),ACPLMCX=isnull(ACPLMCX,0),flag=@flag                                              
,branch=isnull(isnull(isnull(isnull(a.branch,b.branch),c.branch),d.branch),e.branch)                                              
,tmonth=isnull(isnull(isnull(isnull(a.tmonth,b.tmonth),c.tmonth),d.tmonth),e.tmonth)                                              
,tyear=isnull(isnull(isnull(isnull(a.tyear,b.tyear),c.tyear),d.tyear),e.tyear)                                              
 from                                              
#bse a                                              
full outer join                                              
#nse b                                               
on a.particulars=b.particulars and a.branch=b.branch               
full outer join                                              
#fo c                                               
on a.particulars=c.particulars and a.branch=c.branch                                              
full outer join                                              
#mcx d                                               
on a.particulars=d.particulars and a.branch=d.branch                                              
full outer join                                              
#ncx e                                               
on a.particulars=e.particulars and a.branch=e.branch                                              
*/                                            
select a.* into #bse2  from #bse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ablcm') b                          
on a.ablcode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #nse2  from #nse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLCM') b                          
on a.AcdlCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #fo2  from #fo1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLFO') b                          
on a.Focode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #mcx2  from #mcx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='MCDX') b                          
on a.McxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #ncx2  from #ncx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='NCDX') b                          
on a.NcxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
               
select a.* into #mcd2  from #mcd1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACPLMCD') b                          
on a.McdCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                   
                  
                  
                  
select a.* into #nsx2  from #nsx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLNSX') b                          
on a.NsxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                    
                  
                                      
select top 0 * into #ff from Franch_final1                                              
insert into #ff (AblCode,particulars,ABLCM,branch,tmonth,tyear) select * from #bse2                          
insert into #ff (AcdlCode,particulars,ACDLCM,branch,tmonth,tyear) select * from #nse2                                             
insert into #ff (Focode,particulars,ACDLFO,branch,tmonth,tyear) select * from #fo2                                            
insert into #ff (McxCode,particulars,ACPLMCX,branch,tmonth,tyear) select * from #mcx2                                            
insert into #ff (NcdxCode,particulars,ACPLNCDX,branch,tmonth,tyear) select * from #ncx2                                           
insert into #ff (McdCode,particulars,ACPLMCD,branch,tmonth,tyear) select * from #mcd2                  
insert into #ff (NsxCode,particulars,ACDLNSX,branch,tmonth,tyear) select * from #nsx2                                        
                           
delete from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and flag=@flag                                             
Insert into Franch_final1                                  
select particular,                  
ablcm=case when segment='ABLCM' then amount else 0 end,                  
acdlcm=case when segment='ACDLCM' then amount else 0 end,                  
acdlfo=case when segment='ACDLFO' then amount else 0 end,                   
ncdx=case when segment='ACPLNCDX' then amount else 0 end,                    
mcx=case when segment='ACPLMCX' then amount else 0 end,               
mcd=case when segment='ACPLMCD' then amount else 0 end,                 
nsx=case when segment='ACDLNSX' then amount else 0 end,                    
                  
flag=type,branch=franchisee_code                              
,month,year,0,0,0,0,0,0,0                      
from Franch_ExtraExpense WHERE month=datepart(mm,@tdate) and year=datepart(yy,@tdate) and TYPE=@flag                            
                        
--SELECT * FROM Franch_ExtraExpense                          
                                
Insert into Franch_final1                                              
select particulars,                                            
ablcm=sum(isnull(ablcm,0)),                                            
acdlcm=sum(isnull(acdlcm,0)),                                            
acdfo=sum(isnull(acdlfo,0)),                                            
acplncdx=sum(isnull(acplncdx,0)),                                          
acdplmcx=sum(isnull(acplmcx,0)),                  
                                         
acplmcd=sum(isnull(acplmcd,0)),                  
acdlnsx=sum(isnull(acdlnsx,0)),                                        
flag=@FLAG,                                              
branch,                                            
tmonth,                                            
tyear,                                        
AblCode=max(isnull(AblCode,'')),                                            
AcdlCode=max(isnull(AcdlCode,'')),                                            
Focode=max(isnull(Focode,'')),                                            
NcdxCode=max(isnull(NcdxCode,'')),                                          
McxCode=max(isnull(McxCode,'')) ,                   
 McdCode=max(isnull(McdCode,'')) ,                 
NsxCode=max(isnull(NsxCode,''))                                        
                                          
from #ff                                            
group by                                             
particulars,branch,tmonth,tyear            
        
if @flag='N'                                              
BEGIN                      
 if (select count(1) from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and ablcode='520012')=0        
 BEGIN        
 insert into Franch_final1        
 select particulars='BROKERAGE PAID TO FRANCHISEE',                                            
 ablcm=convert(money,0),                                            
 acdlcm=convert(money,0),                                            
 acdfo=convert(money,0),                                            
 acplncdx=convert(money,0),                                          
 acdplmcx=convert(money,0),                  
 acplmcd=convert(money,0),                  
 acdlnsx=convert(money,0),                                        
 flag='N',                                              
 branch=ftag,                                            
 tmonth=datepart(mm,@tdate),                                            
 tyear=datepart(yy,@tdate),                                        
 AblCode='520012',                                            
 AcdlCode='520012',                                            
 Focode='520012',                                            
 NcdxCode='520012',                                          
 McxCode='520012',                   
  McdCode='520012',                 
 NsxCode='520012'      
 from franchisee_mast  (nolock)        
 where todate>getdate()           
 END                                      
END                                             
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franch_Income_summary1bsx
-- --------------------------------------------------

create Procedure [dbo].[new_Franch_Income_summary1bsx](@tdate as varchar(25),@flag as varchar(6))                                              
as                                              
/*declare @tdate as varchar(25)                                              
Set @tdate='Dec 31 2007 00:00:00'                                              
declare @flag as varchar(1)                                              
Set @flag='O'                                              
  */                                           
                                            
Set Nocount on                                              
if @flag='N'                                              
BEGIN                      
 update Franchisee_glcode_Mast set flag='N' where code='520012'           
                   
END                       
        
                      
Set transaction isolation level read uncommitted         
---------------------------------------BSE---------------------------------------------------------------------------------                                           
                                              
select ABLCODE=code,particulars,ABLCM=amount,branch,tmonth,tyear                                               
into #bse                                              
from Franchisee_bsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast (nolock) where flag=@flag and segment='ABLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)        
    
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
                                
       
--------------------------------NSE----------------------------------------------------------------------------------------------      
                                             
select ACDLcode=Code,particulars,ACDLCM=amount,branch,tmonth,tyear                                              
into #nse                                              
from Franchisee_nsecm (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLCM')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)       
    
if @flag='E'    
Begin        
 insert into #nse      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520013' )      
      insert into #nse      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nse where ACDLcode='520011')                                             
END    
                                
select ACDLcode,particulars,ACDLCM=case when ACDLcode='520013'  then isnull(ACDLCM,0)-isnull(nsecm_ba,0)                                    
when ACDLcode='520011'  then isnull(ACDLCM,0)-isnull(nsecm_bp,0)                                    
else ACDLCM end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nse1                                    
from #nse  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
       
      
-----------------------------------------FO---------------------------------------------------------------------------      
                                             
select FoCode=Code,particulars,ACDLFO=amount,branch,tmonth,tyear                                               
into #fo                                              
from Franchisee_nsefo (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLFO')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
    
if @flag='E'    
Begin        
 insert into #fo      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520013' )      
       
 insert into #fo      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #fo where FoCode='520011')                                          
END    
                                 
select FoCode,particulars,ACDLFO=case when FoCode='520013'   then isnull(ACDLFO,0)-isnull(nsefo_ba,0)                            
when FoCode='520011'   then isnull(ACDLFO,0)-isnull(nsefo_bp,0)                                   
else ACDLFO end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #fo1                                    
from #fo  a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                 
                                             
 -----------------------------------------------MCDX-------------------------------------------------------------------------                                             
select MCXCode=Code,particulars,ACPLMCX=amount,branch,tmonth,tyear                                               
into #mcx                                               
from Franchisee_mcdx (nolock)                           
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                                              
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
  
if @flag='E'    
Begin        
 insert into #mcx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520013' )      
       
 insert into #mcx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcx where mcxcode='520011')                                           
END    
                                     
select MCXCode,particulars,ACPLMCX=case when MCXCode='520013'   then isnull(ACPLMCX,0)-isnull(mcdx_ba,0)                                   
when MCXCode='520011'   then isnull(ACPLMCX,0)-isnull(mcdx_bp,0)                                 
else ACPLMCX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcx1                                    
from #mcx  a                                           
full outer join             BKG_PAID b                                    
on a.branch=b.ftag                                    
       
---------------------------------------------------------NCDX------------------------------------------------------------------------------                                             
select NCXCode=Code,particulars,ACPLNCDX=amount,branch,tmonth,tyear                                              
into #ncx                                              
from Franchisee_ncdx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLNCDX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)          
      
if @flag='E'    
Begin        
 insert into #ncx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520013' )      
       
 insert into #ncx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #ncx where NCXCode='520011')                                 
END    
                                    
select NCXCode,particulars,ACPLNCDX=case when NCXCode='520013'   then isnull(ACPLNCDX,0)-isnull(ncdx_ba,0)                                   
when NCXCode='520011'  then isnull(ACPLNCDX,0)-isnull(ncdx_bp,0)                                    
else ACPLNCDX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #ncx1                                    
from #ncx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                                               
                   
                
                  
--------------------------------------------------MCD-----------------------------------------------------------------------                  
select MCDCode=Code,particulars,ACPLMCD=amount,branch,tmonth,tyear                                              
into #mcd                                              
from Franchisee_MCD (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACPLMCD')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
     
if @flag='E'    
Begin       
 insert into #mcd      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520013' )      
       
 insert into #mcd      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #mcd where MCDCode='520011')      
END    
                                  
                                    
select MCDCode,particulars,ACPLMCD=case when MCDCode='520013'   then isnull(ACPLMCD,0)-isnull(mcd_ba,0)                                    
when MCDCode='520011'  then isnull(ACPLMCD,0)-isnull(mcd_bp,0)                                    
else ACPLMCD end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #mcd1                                    
from #mcd a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                     
                  
                  
------------------------------------------------------------NSX-------------------------------------------------------------------------------------------            
 select NSXCode=Code,particulars,ACDLNSX=amount,branch,tmonth,tyear                                              
into #nsx                                              
from Franchisee_nsx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ACDLNSX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
      
if @flag='E'    
Begin        
 insert into #nsx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520013' )      
       
 insert into #nsx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #nsx where NSXCode='520011')      
END                                  
                                    
select NSXCode,particulars,ACDLNSX=case when NSXCode='520013'   then isnull(ACDLNSX,0)-isnull(nsx_ba,0)                                    
when NSXCode='520011'   then isnull(ACDLNSX,0)-isnull(nsx_bp,0)                            
else ACDLNSX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #nsx1                                    
from #nsx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag                    
------------------------------------------bsx--------------------------
select BSXCode=Code,particulars,ABLBSX=amount,branch,tmonth,tyear                                              
into #bsx                                              
from Franchisee_bsx (nolock)                                               
where branch in(select ftag from Franchisee_mast (nolock) where todate>=@tdate)                               
and code in (select code from Franchisee_glcode_Mast where flag=@flag and segment='ABLBSX')                                              
and tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)         
      
if @flag='E'    
Begin        
 insert into #bsx      
 select 520013,'BROKERAGE ACCRUED BUT NOT DUE',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #bsx where BSXCode='520013' )      
       
 insert into #bsx      
 select 520011,'COMMISSION TO AUTHORISED PERSON',0,ftag,datepart(mm,convert(datetime,@tdate))      
 ,datepart(yy,convert(datetime,@tdate))      
 from BKG_PAID where todate>=@tdate and fromdate<=@tdate      
 and ftag not in (select branch from #bsx where BSXCode='520011')      
END                                  
                                    
select BSXCode,particulars,ABLBSX=case when BSXCode='520013'   then isnull(ABLBSX,0)-isnull(bsx_ba,0)                                    
when BSXCode='520011'   then isnull(ABLBSX,0)-isnull(bsx_bp,0)                            
else ABLBSX end                                    
,branch=isnull(branch,ftag),tmonth,tyear                                    
into #bsx1                                    
from #bsx a                                           
full outer join                                     
BKG_PAID b                                    
on a.branch=b.ftag  
                                       
/*select distinct particulars=isnull(isnull(isnull(isnull(a.particulars,b.particulars),c.particulars),d.particulars),e.particulars)                                              
,ABLCM=isnull(ABLCM,0),ACDLCM=isnull(ACDLCM,0)                                              
,ACDLFO=isnull(ACDLFO,0),ACPLNCDX=isnull(ACPLNCDX,0),ACPLMCX=isnull(ACPLMCX,0),flag=@flag                                              
,branch=isnull(isnull(isnull(isnull(a.branch,b.branch),c.branch),d.branch),e.branch)                                              
,tmonth=isnull(isnull(isnull(isnull(a.tmonth,b.tmonth),c.tmonth),d.tmonth),e.tmonth)                                              
,tyear=isnull(isnull(isnull(isnull(a.tyear,b.tyear),c.tyear),d.tyear),e.tyear)                                              
 from                                              
#bse a                                              
full outer join                                              
#nse b                                               
on a.particulars=b.particulars and a.branch=b.branch               
full outer join                                              
#fo c                                               
on a.particulars=c.particulars and a.branch=c.branch                                              
full outer join                                              
#mcx d                                               
on a.particulars=d.particulars and a.branch=d.branch                                              
full outer join                                              
#ncx e                                               
on a.particulars=e.particulars and a.branch=e.branch                                              
*/                                            
select a.* into #bse2  from #bse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ablcm') b                          
on a.ablcode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #nse2  from #nse1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLCM') b                          
on a.AcdlCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #fo2  from #fo1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLFO') b                          
on a.Focode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #mcx2  from #mcx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='MCDX') b                          
on a.McxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
                          
select a.* into #ncx2  from #ncx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='NCDX') b                          
on a.NcxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                          
               
select a.* into #mcd2  from #mcd1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACPLMCD') b                          
on a.McdCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                   
                  
                  
                  
select a.* into #nsx2  from #nsx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ACDLNSX') b                          
on a.NsxCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                    
                  
                  
select a.* into #bsx2  from #bsx1 a                          
left outer join                           
(select * from exclude_extra_expense where segment='ABLBSX') b                          
on a.BSXCode=b.code and a.branch=b.franchisee                          
where code is  null and franchisee  is  null                    
                  
                  
                  
                  
                                      
select top 0 * into #ff from Franch_final1                                              
insert into #ff (AblCode,particulars,ABLCM,branch,tmonth,tyear) select * from #bse2                          
insert into #ff (AcdlCode,particulars,ACDLCM,branch,tmonth,tyear) select * from #nse2                                             
insert into #ff (Focode,particulars,ACDLFO,branch,tmonth,tyear) select * from #fo2                                            
insert into #ff (McxCode,particulars,ACPLMCX,branch,tmonth,tyear) select * from #mcx2                                            
insert into #ff (NcdxCode,particulars,ACPLNCDX,branch,tmonth,tyear) select * from #ncx2                                           
insert into #ff (McdCode,particulars,ACPLMCD,branch,tmonth,tyear) select * from #mcd2                  
insert into #ff (NsxCode,particulars,ACDLNSX,branch,tmonth,tyear) select * from #nsx2                                        

insert into #ff (bsxCode,particulars,ABLBSX,branch,tmonth,tyear) select * from #bsx2   
  
                           
delete from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and flag=@flag                                             
Insert into Franch_final1                                  
select particular,                  
ablcm=case when segment='ABLCM' then amount else 0 end,                  
acdlcm=case when segment='ACDLCM' then amount else 0 end,                  
acdlfo=case when segment='ACDLFO' then amount else 0 end,                   
ncdx=case when segment='ACPLNCDX' then amount else 0 end,                    
mcx=case when segment='ACPLMCX' then amount else 0 end,               
mcd=case when segment='ACPLMCD' then amount else 0 end,                 
nsx=case when segment='ACDLNSX' then amount else 0 end,                    
                  
flag=type,branch=franchisee_code                              
,month,year,0,0,0,0,0,0,0  ,
bsx=case when segment='ABLBSX' then amount else 0 end,0
                    
from Franch_ExtraExpense WHERE month=datepart(mm,@tdate) and year=datepart(yy,@tdate) and TYPE=@flag                            
                        
--SELECT * FROM Franch_ExtraExpense                          
                                
Insert into Franch_final1                                              
select particulars,                                            
ablcm=sum(isnull(ablcm,0)),                                            
acdlcm=sum(isnull(acdlcm,0)),                                            
acdfo=sum(isnull(acdlfo,0)),                                            
acplncdx=sum(isnull(acplncdx,0)),                                          
acdplmcx=sum(isnull(acplmcx,0)),                  
                                         
acplmcd=sum(isnull(acplmcd,0)),                  
acdlnsx=sum(isnull(acdlnsx,0)),                                        
flag=@FLAG,                                              
branch,                                            
tmonth,                                            
tyear,                                        
AblCode=max(isnull(AblCode,'')),                                            
AcdlCode=max(isnull(AcdlCode,'')),                                            
Focode=max(isnull(Focode,'')),                                            
NcdxCode=max(isnull(NcdxCode,'')),                                          
McxCode=max(isnull(McxCode,'')) ,                   
 McdCode=max(isnull(McdCode,'')) ,                 
NsxCode=max(isnull(NsxCode,'')),                                        
ABLBSX =sum(isnull(ABLBSX,0)),
BsxCode=max(isnull(NsxCode,''))                                            
from #ff                                            
group by                                             
particulars,branch,tmonth,tyear            
        
if @flag='N'                                              
BEGIN                      
 if (select count(1) from Franch_final1 where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate) and ablcode='520012')=0        
 BEGIN        
 insert into Franch_final1        
 select particulars='BROKERAGE PAID TO FRANCHISEE',                                            
 ablcm=convert(money,0),                                            
 acdlcm=convert(money,0),                                            
 acdfo=convert(money,0),                                            
 acplncdx=convert(money,0),                                          
 acdplmcx=convert(money,0),                  
 acplmcd=convert(money,0),                  
 acdlnsx=convert(money,0),                                        
 flag='N',                                              
 branch=ftag,                                            
 tmonth=datepart(mm,@tdate),                                            
 tyear=datepart(yy,@tdate),                                        
 AblCode='520012',                                            
 AcdlCode='520012',                                            
 Focode='520012',                                            
 NcdxCode='520012',                                          
 McxCode='520012',                   
  McdCode='520012',                 
 NsxCode='520012'    ,
 ablbsx=convert(money,0), 
 bsxCode='520012'  
 from franchisee_mast  (nolock)        
 where todate>getdate()           
 END                                      
END                                             
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_franch_summary_rpt
-- --------------------------------------------------
  
CREATE procedure [dbo].[new_franch_summary_rpt](@branch as varchar(6),@tmonth as int,@tyear as int)                                
As                                
                        
set nocount on                                
            
--declare @branch as varchar(6),@tmonth as int,@tyear as int            
--set @branch='AHD'            
--set @tmonth=1            
--set @tyear=2008            
            
Set transaction isolation level read uncommitted                 
            
declare @tmonth1 as int,@tyear1 as int            
set @tmonth1= (select tmonth1=case when @tmonth=1 then 12 else @tmonth-1 end )             
set @tyear1=(select tyear1=case when @tmonth=1 then @tyear-1 else @tyear end)            
          
            
select particulars, ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                 
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in ('I_B2B','I_B2C')                               
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                                
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                                
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                                 
and flag in ('I_B2B','I_B2C') then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                                 
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                                 
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                                 
        
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in ('I_B2B','I_B2C')                             
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,           
          
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in ('I_B2B','I_B2C')                             
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end ,         
flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode                                 
into #file1                        
from dbo.Franch_final1(nolock)                                 
where branch=@branch and tmonth=@tmonth and tyear=@tyear                                 
group by particulars,flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode               
                 
----------------------------            
            
select particulars, ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                 
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in ('I_B2B','I_B2C')                               
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                                
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                                
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                                 
and flag in ('I_B2B','I_B2C') then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                                 
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                                 
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                 
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in ('I_B2B','I_B2C') then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                                 
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in ('I_B2B','I_B2C')                             
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,           
          
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in ('I_B2B','I_B2C')                             
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end ,         
flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode                                 
into #file2                        
from dbo.Franch_final1(nolock)                                 
where branch=@branch and tmonth=@tmonth1 and tyear=@tyear1                                 
group by particulars,flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode               
                 
            
-------------------------            
            
--SELECT A.BR,ABL=(ISNULL(A.ABL,0)-ISNULL(B.ABL,0)) FROM #FI2 A            
--LEFT OUTER JOIN            
 --#FI1 B            
--ON A.BR=B.BR            
            
SELECT A.particulars,ABLCM=case when a.ablcm=0 then 0 else (isnull(a.ablcm,0)-isnull(b.ablcm,0)) end,ACDLCM=case when a.ACDLCM=0 then 0 else (isnull(a.ACDLCM,0)-isnull(b.ACDLCM,0)) end,            
ACDLFO=case when a.ACDLFO=0 then 0 else (isnull(a.ACDLFO,0)-isnull(b.ACDLFO,0)) end,        
ACPLNCDX=case when a.ACPLNCDX=0 then 0 else (isnull(a.ACPLNCDX,0)-isnull(b.ACPLNCDX,0)) end,            
ACPLMCX=case when a.ACPLMCX=0 then 0 else (isnull(a.ACPLMCX,0)-isnull(b.ACPLMCX,0)) end,         
 ACPLMCD=case when a.ACPLMCD=0 then 0 else (isnull(a.ACPLMCD,0)-isnull(b.ACPLMCD,0)) end,            
ACDLNSX=case when a.ACDLNSX=0 then 0 else (isnull(a.ACDLNSX,0)-isnull(b.ACDLNSX,0)) end,         
a.flag,a.branch,a.tmonth,a.tyear,a.ABLCode,a.AcdlCode,a.FoCode,a.NcdxCode,a.McxCode,a.McdCode,a.NsxCode into #file3 from  #file1 a            
left outer join            
#file2 b            
on a.particulars=b.particulars            
            
---------------------------            
select                        
particulars=isnull(b.grpname,a.particulars),                        
ABLCM,                        
ACDLCM=convert(money,0),                        
ACDLFO=convert(money,0),                        
ACPLNCDX=convert(money,0),                        
ACPLMCX=convert(money,0),    
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),    
flag,branch,tmonth,tyear,                        
ABLCode,AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #bse                        
from                        
(select* from #file3 where flag='O' and ablcode <> '') a                         
left outer join (select * from GL_Grouping where segment='ABLCM') b                         
on a.ablcode=b.code                        
                        
----------------------------NSE                        
                        
                        
                        
select                        
particulars=isnull(b.grpname,a.particulars),                        
ABLCM=convert(money,0),                        
ACDLCM,                        
ACDLFO=convert(money,0),                        
ACPLNCDX=convert(money,0),                        
ACPLMCX=convert(money,0),    
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),      
flag,branch,tmonth,tyear,                        
ABLCode=space(10),AcdlCode,FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #nse                        
from                        
(select* from #file3 where flag='O' and acdlcode <> '') a                         
left outer join (select * from GL_Grouping where segment='ACDLCM') b                         
on a.acdlcode=b.code                        
                        
                        
----------------------------FO                        
select                        
particulars=isnull(b.grpname,a.particulars),                        
ABLCM=convert(money,0),                        
ACDLCM=convert(money,0),                        
ACDLFO,                        
ACPLNCDX=convert(money,0),                        
ACPLMCX=convert(money,0),    
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),      
flag,branch,tmonth,tyear,                        
ABLCode=space(10),AcdlCode=space(10),FoCode,NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #fo                        
from                        
(select* from #file3 where flag='O' and focode <> '') a                         
left outer join (select * from GL_Grouping where segment='ACDLFO') b                         
on a.FoCode=b.code                        
                        
----------------------------NCDX                        
select                        
particulars=isnull(b.grpname,a.particulars),                        
ABLCM=convert(money,0),                        
ACDLCM=convert(money,0),                        
ACDLFO=convert(money,0),                        
ACPLNCDX,                        
ACPLMCX=convert(money,0),    
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),      
flag,branch,tmonth,tyear,                        
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode,McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #ncx                        
from                        
(select* from #file3 where flag='O' and ncdxcode <> '') a                         
left outer join (select * from GL_Grouping where segment='ACPLNCDX') b                         
on a.NcdxCode=b.code                        
----------------------------MCDX                        
                        
select                        
particulars=isnull(b.grpname,a.particulars),                        
ABLCM=convert(money,0),                        
ACDLCM=convert(money,0),                        
ACDLFO=convert(money,0),                        
ACPLNCDX=convert(money,0),                        
ACPLMCX,    
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),      
flag,branch,tmonth,tyear,                        
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode,NsxCode=space(10),McdCode=space(10),b.grpid                      
into #mcx                        
from                        
(select* from #file3 where flag='O' and mcxcode <> '') a                         
left outer join (select * from GL_Grouping where segment='ACPLMCX') b                         
on a.McxCode=b.code                        
                        
        
-------------------------------------MCD          
          
          
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),        
ACPLMCX=convert(money,0),         
ACPLMCD,                      
ACDLNSX=convert(money,0)               
,flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode,b.grpid                      
into #mcd                      
from                      
(select* from #file1 where flag='O' and McdCode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACPLMCD') b                       
on a.McdCode=b.code           
          
--------------------------------------------NSX          
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX,          
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode,McdCode=space(10),b.grpid                      
into #nsx                      
from                      
(select* from #file1 where flag='O' and NsxCode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACDLNSX') b                       
on a.NsxCode=b.code          
          
         
        
                        
                        
select                         
particulars,ABLCM=sum(ablcm),ACDLCM=sum(Acdlcm),ACDLFO=sum(acdlfo),ACPLNCDX=sum(acplncdx),ACPLMCX=sum(acplmcx),        
 ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),                        
flag,branch,tmonth,tyear,ABLCode=max(ablcode),AcdlCode=max(acdlcode),FoCode=max(focode),NcdxCode=max(ncdxcode),                        
McxCode=max(mcxcode),McdCode=max(McdCode),NsxCode=max(NsxCode),grpid=isnull(grpid,0)                        
into #flago from                        
(                 
select * from #nsx                      
union            
select * from #mcd                      
union                
select * from #ncx                        
union                        
select * from #mcx                        
union                        
select * from #fo                        
union                        
select * from #nse                        
union                        
select * from #bse                        
) a                        
group by                         
particulars,flag,branch,tmonth,tyear,isnull(grpid,0)                        
                        
                        
select * from                        
(select*,grpid=0 from #file3 where flag<>'O'                         
union                        
select * from #flago                        
) a order by flag,particulars,grpid                        
                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franchisee_calc_NSEFO
-- --------------------------------------------------
    
CREATE procedure new_Franchisee_calc_NSEFO(@tdate as varchar(25))              
as              
              
Set nocount On              
              
Set transaction isolation level read uncommitted              
           
            
select   * into #file1           
from angelfo.inhouse.dbo.angel_tempfo               
              
select l2.cltcode , a.longname,Amount = sum(case when upper(l2.drcr) = 'D' then camt else -camt end), costname                             
into #fo1                               
from angelfo.accountfo.dbo.vmast v  , #file1 l2                              
left outer join angelfo.accountfo.dbo.acmast a  on l2.cltcode = a.cltcode, angelfo.accountfo.dbo.costmast c                                    
Where  l2.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and                      
costname in (select ftag from Franchisee_Mast (nolock)) and l2.costcode = c.costcode                                 
group by l2.cltcode,a.longname,costname                 
              
              
delete from Franchisee_nsefo where tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)                                  
Insert into Franchisee_nsefo                                  
select code=cltcode,particulars=longname,amount,branch=costname,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)                                  
from #fo1        
union      
select '99780','GROSS BROKERAGE B2B',B2B_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLFO'  and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)     
UNION      
select '99981','GROSS BROKERAGE B2C',B2C_BROK_EARNED,BRANCH,tmonth=datepart(mm,@tdate),tyear=datepart(yy,@tdate)        
from  DBO.franchisee_b2b_b2c_brok where segment='ACDLFO'   and  tmonth=datepart(mm,@tdate) and tyear=datepart(yy,@tdate)            
              
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franchisee_JV
-- --------------------------------------------------
CREATE Procedure [dbo].[new_Franchisee_JV](@tmonth as int,@tyear as int,@tag as varchar(10))                    
as                    
Set transaction isolation level read uncommitted   
  
                  
                
set Nocount On    
  
/*               
select  ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag  IN ('B2B','B2C')                              
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                              
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag  IN ('B2B','B2C')  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                              
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                               
and flag  IN ('B2B','B2C')  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                               
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag  IN ('B2B','B2C')  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                               
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag  IN ('B2B','B2C')  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                               
        
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                 
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag  IN ('B2B','B2C')                                
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,             
            
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                 
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag  IN ('B2B','B2C')                                
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end ,         
flag,branch,tmonth,tyear                            
into #file                      
from dbo.Franch_final1(nolock)                               
where tmonth=@tmonth and tyear=@tyear and branch like @tag                               
group by particulars,flag,branch,tmonth,tyear          
            
          
                  
select ABLCM=sum(ABLCM),                          
ACDLCM= sum(ACDLCM),                          
ACDLFO=sum(ACDLFO),                           
ACPLNCDX=sum(ACPLNCDX),                           
ACPLMCX=sum(ACPLMCX),          
ACPLMCD=sum(ACPLMCD),        
ACDLNSX=sum(ACDLNSX),                        
flag,branch,tmonth,tyear                    
into #file1                           
from #file                    
group by flag,branch,tmonth,tyear                    
                    
select * into #income from #file1 where flag in ('I_B2C','I_B2B')                      
select * into #expense from #file1 where flag='E'                    
                    
select ablcm=abs(a.ablcm)-isnull(b.ablcm,0),                    
acdlcm=abs(a.acdlcm)-isnull(b.acdlcm,0),acdlfo=abs(a.acdlfo)-isnull(b.acdlfo,0),                    
acplncdx=abs(a.acplncdx)-isnull(b.acplncdx,0),        
acplmcx=abs(a.acplmcx)-isnull(b.acplmcx,0),        
acplmcd=abs(a.acplmcd)-isnull(b.acplmcd,0),        
acdlnsx=abs(a.acdlnsx)-isnull(b.acdlnsx,0),        
branch=isnull(a.branch,b.branch)                     
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                      
into #net                    
from #income a                    
left outer join                     
#expense b on a.branch=b.branch                    
                    
select ftag,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare         
into #mast     
from Franchisee_mast (nolock) where todate>=getDate()                     
                    
select ablcm=a.ablcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                                      
acdlcm=a.acdlcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acdlfo=a.acdlfo*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                     
acplncdx=a.acplncdx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acplmcx=a.acplmcx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                    
acplmcd=a.acplmcd*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                    
acdlnsx=a.acdlnsx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100) ,                                      
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                      
into #franchshare                                      
from #net a                                      
left outer join                                      
#mast b                                      
on a.branch=b.ftag                       
                    
select * into #OtherExpense from #file1 where flag='O'                    
                    
select ablcm=a.ablcm*isnull(b.ExpenseShare,0)/100,                                      
acdlcm=a.acdlcm*isnull(b.ExpenseShare,0)/100,acdlfo=a.acdlfo*isnull(b.ExpenseShare,0)/100,                                      
acplncdx=a.acplncdx*isnull(b.ExpenseShare,0)/100,acplmcx=a.acplmcx*isnull(b.ExpenseShare,0)/100,                     
 acplmcd=a.acplmcd*isnull(b.ExpenseShare,0)/100,                    
acdlnsx=a.acdlnsx*isnull(b.ExpenseShare,0)/100,                                     
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                      
into #ExpenseShare                                      
from #OtherExpense a                                      
left outer join                                    
#mast b                                      
on a.branch=b.ftag                        
                    
select ablcm=isnull(a.ablcm,0)-isnull(b.ablcm,0),                    
acdlcm=isnull(a.acdlcm,0)-isnull(b.acdlcm,0),acdlfo=isnull(a.acdlfo,0)-isnull(b.acdlfo,0),                    
acplncdx=isnull(a.acplncdx,0)-isnull(b.acplncdx,0),acplmcx=isnull(a.acplmcx,0)-isnull(b.acplmcx,0),        
acplmcd=isnull(a.acplmcd,0)-isnull(b.acplmcd,0),        
acdlnsx=isnull(a.acdlnsx,0)-isnull(b.acdlnsx,0),        
branch=isnull(a.branch,b.branch)                     
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                    
into #netprofit                       
from #franchshare a                    
full outer join                     
#ExpenseShare b                    
on a.branch=b.branch                     
                    
select * into #brok from #file1 where flag='N'                     
                    
select ablcm=a.ablcm-isnull(b.ablcm,0),                    
acdlcm=a.acdlcm-isnull(b.acdlcm,0),acdlfo=a.acdlfo-isnull(b.acdlfo,0),                    
acplncdx=a.acplncdx-isnull(b.acplncdx,0),        
acplmcx=a.acplmcx-isnull(b.acplmcx,0),        
acplmcd=a.acplmcx-isnull(b.acplmcd,0),        
acdlnsx=a.acplmcx-isnull(b.acdlnsx,0),        
branch=isnull(a.branch,b.branch)                     
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                      
into #jv                    
from #netprofit a                    
join                     
#brok b on a.branch=b.branch      
  
*/      
  
  /*
declare @tmonth as int,@tyear as int,@tag as varchar(10)
set @tmonth=6
set @tyear=2010
set @tag='%'
*/
select * into #jv from franch_final2 where flag='jv_pf_loss'           
                    
select * from                  
(                  
select code=ablcode,DRCR=case when ablcm<0 then 'D' else 'C' end ,amt=abs(ablcm),branch,tmonth,tyear,segment='ABLCM' from #jv a                    
join                    
(select ftag,ablcode from MIS.REMISIOR.DBO.Franch_ledcode where ablcode<>'')b                    
on a.branch=b.ftag                    
union                    
select code=acdlcode,DRCR=case when acdlcm<0 then 'D' else 'C' end ,amt=abs(acdlcm),branch,tmonth,tyear,segment='ACDLCM' from #jv a                    
join                    
(select ftag,acdlcode from MIS.REMISIOR.DBO.Franch_ledcode where acdlcode<>'')b                    
on a.branch=b.ftag                    
union                    
select code=acdlfocode,DRCR=case when acdlfo<0 then 'D' else 'C' end ,amt=abs(acdlfo),branch,tmonth,tyear,segment='ACDLFO' from #jv a                    
join                    
(select ftag,acdlfocode from MIS.REMISIOR.DBO.Franch_ledcode where acdlfocode<>'')b                    
on a.branch=b.ftag                    
union                    
select code=ncdxcode,DRCR=case when acplncdx<0 then 'D' else 'C' end ,amt=abs(acplncdx),branch,tmonth,tyear,segment='NCDX' from #jv a                    
join                    
(select ftag,ncdxcode from MIS.REMISIOR.DBO.Franch_ledcode where ncdxcode<>'')b                    
on a.branch=b.ftag                    
union                    
select code=mcdxcode,DRCR=case when acplmcx<0 then 'D' else 'C' end ,amt=abs(acplmcx),branch,tmonth,tyear,segment='MCDX' from #jv a                    
join                    
(select ftag,mcdxcode from MIS.REMISIOR.DBO.Franch_ledcode where mcdxcode<>'')b                    
on a.branch=b.ftag          
union         
select code=mcdcode,DRCR=case when ACPLMCD<0 then 'D' else 'C' end ,amt=abs(ACPLMCD),branch,tmonth,tyear,segment='ACPLMCD' from #jv a                    
join                    
(select ftag,mcdcode from MIS.REMISIOR.DBO.Franch_ledcode where mcdcode<>'')b                    
on a.branch=b.ftag          
union         
select code=nsxcode,DRCR=case when ACDLNSX<0 then 'D' else 'C' end ,amt=abs(ACDLNSX),branch,tmonth,tyear,segment='ACDLNSX' from #jv a                    
join                    
(select ftag,nsxcode from MIS.REMISIOR.DBO.Franch_ledcode where nsxcode<>'')b                    
on a.branch=b.ftag         
        
        
) a                  
left outer join                   
(select ftag,fname from franchisee_mast (nolock) where todate>=getDate()) b                  
on a.branch=b.ftag    
where tmonth=@tmonth and tyear= @tyear             
order by segment,branch                 
                
set Nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Franchisee_PA
-- --------------------------------------------------

 CREATE Procedure [dbo].[new_Franchisee_PA](@tmonth as int,@tyear as int,@tag as varchar(10))                                    
as                                    
Set transaction isolation level read uncommitted                                    
    
/*                            
set Nocount On                                
select  ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                               
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in('B2B','B2C')                                              
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                                              
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                               
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in('B2B','B2C')  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                                              
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                                               
and flag in('B2B','B2C')  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                                               
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                               
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in('B2B','B2C')  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                                               
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                                               
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in('B2B','B2C')  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                                               
                  
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                           
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in('B2B','B2C')                                          
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,                       
                      
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                                           
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in('B2B','B2C')                                          
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end ,                  
                  
flag,branch,tmonth,tyear                                            
into #file                                      
from dbo.Franch_final1(nolock)                                               
where tmonth=@tmonth and tyear=@tyear and branch like '%'                                               
group by particulars,flag,branch,tmonth,tyear                          
                            
              
                         
select ABLCM=sum(ABLCM),                                          
ACDLCM= sum(ACDLCM),                                          
ACDLFO=sum(ACDLFO),                                           
ACPLNCDX=sum(ACPLNCDX),                                           
ACPLMCX=sum(ACPLMCX),                   
ACPLMCD=sum(ACPLMCD),                  
ACDLNSX=sum(ACDLNSX),                                           
flag,branch,tmonth,tyear                                    
into #file1                                           
from #file                                    
group by flag,branch,tmonth,tyear                                    
                                    
select * into #income from #file1 where flag in ('I_B2C','I_B2B')      
select * into #expense from #file1 where flag='E'                                    
                                    
select ablcm=a.ablcm-isnull(b.ablcm,0),                                    
acdlcm=a.acdlcm-isnull(b.acdlcm,0),acdlfo=a.acdlfo-isnull(b.acdlfo,0),                                    
acplncdx=a.acplncdx-isnull(b.acplncdx,0),acplmcx=a.acplmcx-isnull(b.acplmcx,0),branch=isnull(a.branch,b.branch) ,                  
acplmcd=abs(a.acplmcd)-isnull(b.acplmcd,0),                  
acdlnsx=abs(a.acdlnsx)-isnull(b.acdlnsx,0)                              
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                                  
into #net                                    
from #income a                      
left outer join                             
#expense b on a.branch=b.branch                                    
                                    
select ftag,B2B_IncomePercent,B2C_IncomePercent,ExpenseShare       
into #mast       
from Franchisee_mast (nolock) where todate>=getDate()                                    
                                  
select ablcm=a.ablcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                                    
acdlcm=a.acdlcm*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acdlfo=a.acdlfo*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                   
acplncdx=a.acplncdx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),acplmcx=a.acplmcx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                  
acplmcd=a.acplmcd*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100),                  
acdlnsx=a.acdlnsx*(isnull(b.B2B_IncomePercent,0)/100+isnull(b.B2C_IncomePercent,0)/100) ,                                    
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                    
into #franchshare                                    
from #net a                                    
left outer join                                    
#mast b                                    
on a.branch=b.ftag                                     
                                    
select * into #OtherExpense from #file1 where flag='O'                                    
                                    
select ablcm=a.ablcm*isnull(b.ExpenseShare,0)/100,                                    
acdlcm=a.acdlcm*isnull(b.ExpenseShare,0)/100,acdlfo=a.acdlfo*isnull(b.ExpenseShare,0)/100,                                    
acplncdx=a.acplncdx*isnull(b.ExpenseShare,0)/100,acplmcx=a.acplmcx*isnull(b.ExpenseShare,0)/100,                   
 acplmcd=a.acplmcd*isnull(b.ExpenseShare,0)/100,                  
acdlnsx=a.acdlnsx*isnull(b.ExpenseShare,0)/100,                                   
branch=isnull(a.branch,b.ftag) ,tmonth,tyear                                    
into #ExpenseShare                                    
from #OtherExpense a                                    
left outer join                                  
#mast b                                    
on a.branch=b.ftag                                     
                                    
select ablcm=isnull(a.ablcm,0)-isnull(b.ablcm,0),                                    
acdlcm=isnull(a.acdlcm,0)-isnull(b.acdlcm,0),acdlfo=isnull(a.acdlfo,0)-isnull(b.acdlfo,0),                                    
acplncdx=isnull(a.acplncdx,0)-isnull(b.acplncdx,0),acplmcx=isnull(a.acplmcx,0)-isnull(b.acplmcx,0) ,                  
acplmcd=isnull(a.acplmcd,0)-isnull(b.acplmcd,0),                  
acdlnsx=isnull(a.acdlnsx,0)-isnull(b.acdlnsx,0)                            
,branch=isnull(a.branch,b.branch)                                     
,tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                                    
into #netprofit                                       
from #franchshare a                                    
full outer join                                     
#ExpenseShare b                                    
on a.branch=b.branch                                     
                                    
select * into #brok from #file1 where flag='N'                                     
                                    
select ablcm=a.ablcm-isnull(b.ablcm,0),                                    
acdlcm=a.acdlcm-isnull(b.acdlcm,0),acdlfo=a.acdlfo-isnull(b.acdlfo,0),                                    
acplncdx=a.acplncdx-isnull(b.acplncdx,0),acplmcx=a.acplmcx-isnull(b.acplmcx,0),branch=isnull(a.branch,b.branch)                            
,                  
acplmcd=a.acplmcd-isnull(b.acplmcd,0),                  
acdlnsx=a.acdlnsx-isnull(b.acdlnsx,0),                  
tmonth=isnull(a.tmonth,b.tmonth),tyear=isnull(a.tyear,b.tyear)                                     
into #jv1                                   
from #netprofit a                                    
join                                     
#brok b on a.branch=b.branch                                     
--drop table #final                  
                
                
                
                
select ftag,ablcode into #code from MIS.REMISIOR.DBO.Franch_ledcode  where ablcode<>''                 
union                
select ftag,acdlcode from MIS.REMISIOR.DBO.Franch_ledcode where acdlcode<>''                 
union                
select ftag,acdlfocode from MIS.REMISIOR.DBO.Franch_ledcode  where acdlfocode<>''                
union                
select ftag,ncdxcode from MIS.REMISIOR.DBO.Franch_ledcode  where ncdxcode<>''                
union                
select ftag,mcdxcode from MIS.REMISIOR.DBO.Franch_ledcode  where mcdxcode<>''                
union                
select ftag,mcdcode from MIS.REMISIOR.DBO.Franch_ledcode  where mcdcode<>''                
union                
select ftag,nsxcode from MIS.REMISIOR.DBO.Franch_ledcode  where nsxcode<>''                
                        
                       
select distinct a.* into #final             
from                    
(select a.*,b.* from               
(            
select ABLCM=round(sum(ablcm),0,0),ACDLCM=round(sum(acdlcm),0,0),                    
ACDLFO=round(sum(acdlfo),0,0),NCDX=round(sum(acplncdx),0,0),MCDX=round(sum(acplmcx),0,0),                
ACPLMCD=round(sum(acplmcd),0,0),                
ACDLNSX=round(sum(acdlnsx),0,0),                
branch,tmonth,tyear,            
tot=round(sum(ABLCM+ACDLCM+ACDLFO+acplncdx+acplmcx+acplmcd+acdlnsx),0,0) from #jv1  group by  branch,tmonth,tyear ) a                
join               
(select ftag from #code)b              
on a.branch=b.ftag   )a              
left outer join              
(select ftag,fname from franchisee_mast (nolock) where todate>=getDate()) b                                
on a.branch=b.ftag                     
order by branch                           
                        
select * from #final a                     
left outer join                    
(select code,reg_code from intranet.risk.dbo.region ) b                    
on a.branch=b.code                    
 order by branch,reg_code      

*/    

select a.*,b.reg_code from 
(select *,tot=(ABLCM+ACDLCM+ACDLFO+ACPLNCDX+ACPLMCX+ACPLMCD+ACDLNSX)   
from franch_final2 where flag='jv_pf_loss')a
left outer join                    
(select code,reg_code from intranet.risk.dbo.region ) b                    
on a.branch=b.code                    
 order by branch,reg_code       
                             
set Nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Rpt_franch_summary
-- --------------------------------------------------
CREATE procedure [dbo].[new_Rpt_franch_summary](@branch as varchar(6),@tmonth as int,@tyear as int)                              
As                              
                      
set nocount on                              
Set transaction isolation level read uncommitted                               

/*declare @branch as varchar(6),@tmonth as int,@tyear as int                      
set @branch='ahd'                      
set @tmonth=9                      
set @tyear=2009   */                  
                    
                      
/*select particulars, ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag<>'N' and flag<>'E'                             
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                              
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag<>'N' and flag<>'E' then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                              
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                               
and flag<>'N' and flag<>'E' then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                               
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag<>'N' and flag<>'E' then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                               
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag<>'N' and flag<>'E' then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                               
flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode                               
into #file1                      
from dbo.Franch_final1(nolock)                               
where branch=@branch and tmonth=@tmonth and tyear=@tyear                               
group by particulars,flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode                              
*/            
select particulars,           
ABLCM=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ABLCM),0) when sum(ABLCM)<0 and flag in ('I_B2B','I_B2C')                              
then round(-sum(ABLCM),0) else round(sum(ABLCM),0) end ,                              
ACDLCM= case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACDLCM),0) when sum(ACDLCM)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLCM),0) else round(sum(ACDLCM),0) end,                              
ACDLFO=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O' then round(-sum(ACDLFO),0) when sum(ACDLFO)<0                               
and flag in ('I_B2B','I_B2C')  then round(-sum(ACDLFO),0) else round(sum(ACDLFO),0) end,                               
ACPLNCDX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLNCDX),0) when sum(ACPLNCDX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLNCDX),0) else round(sum(ACPLNCDX),0) end,                               
ACPLMCX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%' and flag='O'                               
then round(-sum(ACPLMCX),0) when sum(ACPLMCX)<0 and flag in ('I_B2B','I_B2C')  then round(-sum(ACPLMCX),0) else round(sum(ACPLMCX),0) end,                               
          
ACPLMCD=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACPLMCD),0) when sum(ACPLMCD)<0 and flag in ('I_B2B','I_B2C')                              
then round(-sum(ACPLMCD),0) else round(sum(ACPLMCD),0) end ,           
          
ACDLNSX=case when PARTICULARS LIKE '%PF EMPLOYEES SHARES A/C NO%'                               
and flag='O' then round(-sum(ACDLNSX),0) when sum(ACDLNSX)<0 and flag in ('I_B2B','I_B2C')                              
then round(-sum(ACDLNSX),0) else round(sum(ACDLNSX),0) end ,           
flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode                      
into #file1                      
from dbo.Franch_final1(nolock)                               
where branch=@branch and tmonth=@tmonth and tyear=@tyear      
group by particulars,flag,branch,tmonth,tyear,ABLCode,AcdlCode,FoCode,NcdxCode,McxCode,McdCode,NsxCode            
--order by flag                            
                      
/*Any changes in this SP sud be also done in SP of JV generation(SP name Franchisee_JV)*/                          
--select * from Franch_final1                       
--select * from Franch_final1 where flag='I'ablcode='51000035'                     
--select * from #file1 where flag='O' and ablcode='51000035'                     
----------------------------BSE                      
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM,                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),          
flag,branch,tmonth,tyear,                      
ABLCode,AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #bse                      
from                      
(select* from #file1 where flag='O' and ablcode <> '') a                       
left outer join (select * from GL_Grouping where segment='ABLCM') b                       
on a.ablcode=b.code                      
                      
----------------------------NSE                      
                      
                      
                      
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM,                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),          
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode,FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #nse                      
from                      
(select* from #file1 where flag='O' and acdlcode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACDLCM') b                       
on a.acdlcode=b.code                      
                      
                      
----------------------------FO                      
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO,                      
ACPLNCDX=convert(money,0),                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),          
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode,NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid                      
into #fo                      
from                      
(select* from #file1 where flag='O' and focode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACDLFO') b                       
on a.FoCode=b.code                      
                  
----------------------------NCDX                      
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX,                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),          
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode,McxCode=space(10),NsxCode=space(10),McdCode=space(10),b.grpid            
into #ncx                      
from                      
(select* from #file1 where flag='O' and ncdxcode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACPLNCDX') b                       
on a.NcdxCode=b.code               
----------------------------MCDX                      
                      
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),      
ACPLMCX,             
ACPLMCD=convert(money,0),                      
ACDLNSX=convert(money,0),                   
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode,NsxCode=space(10),McdCode=space(10),b.grpid                      
into #mcx                      
from                      
(select* from #file1 where flag='O' and mcxcode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACPLMCX') b                       
on a.McxCode=b.code                      
                      
  -------------------------------------MCD          
          
          
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),       
ACPLMCX=convert(money,0),            
ACPLMCD,                      
ACDLNSX=convert(money,0),                   
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode=space(10),McdCode,b.grpid                      
into #mcd                      
from                      
(select* from #file1 where flag='O' and McdCode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACPLMCD') b                       
on a.McdCode=b.code           
          
--------------------------------------------NSX          
select                      
particulars=isnull(b.grpname,a.particulars),                      
ABLCM=convert(money,0),                      
ACDLCM=convert(money,0),                      
ACDLFO=convert(money,0),                      
ACPLNCDX=convert(money,0),                      
ACPLMCX=convert(money,0),          
ACPLMCD=convert(money,0),                      
ACDLNSX,          
flag,branch,tmonth,tyear,                      
ABLCode=space(10),AcdlCode=space(10),FoCode=space(10),NcdxCode=space(10),McxCode=space(10),NsxCode,McdCode=space(10),b.grpid                      
into #nsx                      
from                      
(select* from #file1 where flag='O' and nSXcode <> '') a                       
left outer join (select * from GL_Grouping where segment='ACDLNSX') b                       
on a.NsxCode=b.code          
          
         
               
                      
select                       
particulars,ABLCM=sum(ablcm),ACDLCM=sum(Acdlcm),ACDLFO=sum(acdlfo),ACPLNCDX=sum(acplncdx),ACPLMCX=sum(acplmcx),        
 ACPLMCD=sum(ACPLMCD),ACDLNSX=sum(ACDLNSX),                     
flag,branch,tmonth,tyear,ABLCode=max(ablcode),AcdlCode=max(acdlcode),FoCode=max(focode),NcdxCode=max(ncdxcode),                      
McxCode=max(mcxcode),McdCode=max(McdCode),NsxCode=max(NsxCode),grpid=isnull(grpid,0)                      
into #flago         
from                      
(              
select * from #nsx                      
union            
select * from #mcd                      
union                    
select * from #ncx                      
union                      
select * from #mcx                      
union                      
select * from #fo                      
union                      
select * from #nse              
union                      
select * from #bse                      
) a                      
group by                       
particulars,flag,branch,tmonth,tyear,isnull(grpid,0)                      
                      
                      
select * from                      
(select*,grpid=0 from #file1 where flag<>'O'                       
union                      
select * from #flago                      
) a order by flag,particulars,grpid                     
                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Upd_Franchisee_glcode
-- --------------------------------------------------
CREATE Procedure [dbo].[new_Upd_Franchisee_glcode]                    
as                    
Set nocount on                
                    
--Insert into Franchisee_glcode_Mast                    
select code=cltcode,particulars=acname,flag='x',segment='ABLCM',updt=getDate()              
into #file1                     
from AngelBSECM.account_ab.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                   
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                   
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ABLCM')                    
                 
                    
--Insert into #file                    
select code=cltcode,particulars=acname,flag='x',segment='ACDLCM',updt=getDate()                
into #file2                     
from AngelNseCM.account.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                     
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLCM')                    
                 
                    
--Insert into Franchisee_glcode_Mast                
--Insert into #file                     
select code=cltcode,particulars=acname,flag='x',segment='ACDLFO',updt=getDate()                  
into #file3                     
from angelfo.accountfo.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%'   and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLFO')                    
                 
                    
--Insert into Franchisee_glcode_Mast                 
--Insert into #file                    
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCX',updt=getDate()                      
into #file4                  
from angelcommodity.accountmcdx.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'   and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCX')                    
                 
                    
--Insert into #file                      
select code=cltcode,particulars=acname,flag='x',segment='ACPLNCDX',updt=getDate()                
into #file5                        
from angelcommodity.accountncdx.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                     
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX')                    
    
    
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCD',updt=getDate()                
into #file6                        
from angelcommodity.accountmcdxcds.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCD')      
    
    
select code=cltcode,particulars=acname,flag='x',segment='ACDLNSX',updt=getDate()                
into #file7                       
from Angelfo.accountcurfo.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'   
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLNSX')      
            
select * into #file              
from          
(          
select * from #file1            
union                
select * from #file2         
union                
select * from #file3            
union                
select * from #file4            
union                
select * from #file5    
union                
select * from #file6           
union                
select * from #file7    
            
) a          
                    
update #file set updt=getDate()                  
insert into Franchisee_glcode_Mast select * from #file              
        
insert into Grp_code_map        
select id,0 from Franchisee_glcode_Mast where id not in (select glmastcodeid from Grp_code_map)        
      
update Franchisee_glcode_Mast set flag='N' where code='520012'                
Set nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_Upd_Franchisee_glcode_23122022
-- --------------------------------------------------
Create Procedure [dbo].[new_Upd_Franchisee_glcode_23122022]                    
as                    
Set nocount on                
                    
--Insert into Franchisee_glcode_Mast                    
select code=cltcode,particulars=acname,flag='x',segment='ABLCM',updt=getDate()              
into #file1                     
from anand.account_ab.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                   
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                   
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ABLCM')                    
                 
                    
--Insert into #file                    
select code=cltcode,particulars=acname,flag='x',segment='ACDLCM',updt=getDate()                
into #file2                     
from anand1.account.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                     
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLCM')                    
                 
                    
--Insert into Franchisee_glcode_Mast                
--Insert into #file                     
select code=cltcode,particulars=acname,flag='x',segment='ACDLFO',updt=getDate()                  
into #file3                     
from angelfo.accountfo.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%'   and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLFO')                    
                 
                    
--Insert into Franchisee_glcode_Mast                 
--Insert into #file                    
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCX',updt=getDate()                      
into #file4                  
from angelcommodity.accountmcdx.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'   and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCX')                    
                 
                    
--Insert into #file                      
select code=cltcode,particulars=acname,flag='x',segment='ACPLNCDX',updt=getDate()                
into #file5                        
from angelcommodity.accountncdx.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                     
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX')                    
    
    
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCD',updt=getDate()                
into #file6                        
from angelcommodity.accountmcdxcds.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'                    
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCD')      
    
    
select code=cltcode,particulars=acname,flag='x',segment='ACDLNSX',updt=getDate()                
into #file7                       
from Angelfo.accountcurfo.dbo.acmast where                    
isnumeric(cltcode)=1 and                     
cltcode not like '0%' and cltcode not like '1%' and                    
cltcode not like '21%' and cltcode not like '28%'                    
  and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                     
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '10%' and cltcode not like '40%'                  
and cltcode not like '41%' and cltcode not like '43%'                  
and cltcode not like '44%' and cltcode not like '45%'                  
and cltcode not like '46%' and cltcode not like '47%'                  
and cltcode not like '48%' and cltcode not like '8%'   
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLNSX')      
            
select * into #file              
from          
(          
select * from #file1            
union                
select * from #file2         
union                
select * from #file3            
union                
select * from #file4            
union                
select * from #file5    
union                
select * from #file6           
union                
select * from #file7    
            
) a          
                    
update #file set updt=getDate()                  
insert into Franchisee_glcode_Mast select * from #file              
        
insert into Grp_code_map        
select id,0 from Franchisee_glcode_Mast where id not in (select glmastcodeid from Grp_code_map)        
      
update Franchisee_glcode_Mast set flag='N' where code='520012'                
Set nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------

  -- exec rebuild_index2 'AdventureWorksDW'
CREATE procedure [dbo].[rebuild_index]
@database varchar(100)
as
declare @db_id  int
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
DECLARE @MAXROWID int;
DECLARE @MINROWID int;
DECLARE @CURRROWID int; 
DECLARE @ID int;    
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function    
-- and convert object and index IDs to names.    
Create table #work_to_do(id bigint primary key identity(1,1),objectid int,indexid int,partitionnum bigint,frag float )  

insert into #work_to_do(objectid,indexid,partitionnum,frag)
 select
object_id AS objectid,    
index_id AS indexid,    
partition_number AS partitionnum,    
avg_fragmentation_in_percent AS frag    
 FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')    
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0; 

  
   --select @ID =ID from #work_to_do 
  
  SELECT @MINROWID=MIN(ID),@MAXROWID=MAX(ID) FROM #work_to_do WITH(NOLOCK) ; 

  SET @CURRROWID=@MINROWID;  

WHILE (@CURRROWID<=@MAXROWID)
   BEGIN 
 
    SELECT  @objectid=objectid , @indexid=indexid  , @partitionnum=partitionnum , @frag=frag 
     FROM #work_to_do WHERE ID=@CURRROWID 
     set @CURRROWID=@CURRROWID+1   


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
select N'Executed: ' + @command; 
end

      
-- Drop the temporary table.    
DROP TABLE #work_to_do;

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
-- PROCEDURE dbo.Upd_Franchisee_glcode
-- --------------------------------------------------
        
          
          
CREATE Procedure [dbo].[Upd_Franchisee_glcode]                
as                
Set nocount on            
                
--Insert into Franchisee_glcode_Mast                
select code=cltcode,particulars=acname,flag='x',segment='ABLCM',updt=getDate()          
into #file1                 
from AngelBSECM.account_ab.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'               
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'               
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ABLCM')                
             
                
--Insert into #file                
select code=cltcode,particulars=acname,flag='x',segment='ACDLCM',updt=getDate()            
into #file2                 
from AngelNseCM.account.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLCM')                
             
                
--Insert into Franchisee_glcode_Mast            
--Insert into #file                 
select code=cltcode,particulars=acname,flag='x',segment='ACDLFO',updt=getDate()              
into #file3                 
from angelfo.accountfo.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLFO')                
             
                
--Insert into Franchisee_glcode_Mast             
--Insert into #file                
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCX',updt=getDate()                  
into #file4              
from angelcommodity.accountmcdx.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCX')                
             
                
--Insert into #file                  
select code=cltcode,particulars=acname,flag='x',segment='ACPLNCDX',updt=getDate()            
into #file5                    
from angelcommodity.accountncdx.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX')                
        
select * into #file          
from      
(      
select * from #file1        
union            
select * from #file2        
union            
select * from #file3        
union            
select * from #file4        
union            
select * from #file5        
) a      
                
update #file set updt=getDate()              
insert into Franchisee_glcode_Mast select * from #file          
    
insert into Grp_code_map    
select id,0 from Franchisee_glcode_Mast where id not in (select glmastcodeid from Grp_code_map)    
  
update Franchisee_glcode_Mast set flag='N' where code='520012'            
Set nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_Franchisee_glcode_23122022
-- --------------------------------------------------
        
          
          
Create Procedure [dbo].[Upd_Franchisee_glcode_23122022]                
as                
Set nocount on            
                
--Insert into Franchisee_glcode_Mast                
select code=cltcode,particulars=acname,flag='x',segment='ABLCM',updt=getDate()          
into #file1                 
from anand.account_ab.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'               
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'               
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ABLCM')                
             
                
--Insert into #file                
select code=cltcode,particulars=acname,flag='x',segment='ACDLCM',updt=getDate()            
into #file2                 
from anand1.account.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLCM')                
             
                
--Insert into Franchisee_glcode_Mast            
--Insert into #file                 
select code=cltcode,particulars=acname,flag='x',segment='ACDLFO',updt=getDate()              
into #file3                 
from angelfo.accountfo.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACDLFO')                
             
                
--Insert into Franchisee_glcode_Mast             
--Insert into #file                
select code=cltcode,particulars=acname,flag='x',segment='ACPLMCX',updt=getDate()                  
into #file4              
from angelcommodity.accountmcdx.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLMCX')                
             
                
--Insert into #file                  
select code=cltcode,particulars=acname,flag='x',segment='ACPLNCDX',updt=getDate()            
into #file5                    
from angelcommodity.accountncdx.dbo.acmast where                
isnumeric(cltcode)=1 and                 
cltcode not like '0%' and cltcode not like '1%' and cltcode not like '2%' and                
cltcode not like '21%' and cltcode not like '28%'                
and cltcode not like '26%' and cltcode not like '27%' and cltcode not like '29%' and cltcode not like '3%'                 
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '10%' and cltcode not like '40%'              
and cltcode not like '41%' and cltcode not like '43%'              
and cltcode not like '44%' and cltcode not like '45%'              
and cltcode not like '46%' and cltcode not like '47%'              
and cltcode not like '48%' and cltcode not like '8%'                
and cltcode not in (select code from dbo.Franchisee_glcode_Mast (nolock) where segment='ACPLNCDX')                
        
select * into #file          
from      
(      
select * from #file1        
union            
select * from #file2        
union            
select * from #file3        
union            
select * from #file4        
union            
select * from #file5        
) a      
                
update #file set updt=getDate()              
insert into Franchisee_glcode_Mast select * from #file          
    
insert into Grp_code_map    
select id,0 from Franchisee_glcode_Mast where id not in (select glmastcodeid from Grp_code_map)    
  
update Franchisee_glcode_Mast set flag='N' where code='520012'            
Set nocount Off

GO

-- --------------------------------------------------
-- TABLE dbo.BKG_PAID
-- --------------------------------------------------
CREATE TABLE [dbo].[BKG_PAID]
(
    [ftag] VARCHAR(50) NULL,
    [mcdx_bp] MONEY NULL,
    [mcdx_ba] MONEY NULL,
    [ncdx_bp] MONEY NULL,
    [ncdx_ba] MONEY NULL,
    [fromdate] DATETIME NULL,
    [todate] DATETIME NULL,
    [bsecm_bp] MONEY NULL,
    [bsecm_ba] MONEY NULL,
    [nsecm_bp] MONEY NULL,
    [nsecm_ba] MONEY NULL,
    [nsefo_bp] MONEY NULL,
    [nsefo_ba] MONEY NULL,
    [mcd_ba] MONEY NULL,
    [mcd_bp] MONEY NULL,
    [nsx_ba] MONEY NULL,
    [nsx_bp] MONEY NULL,
    [bsx_bp] MONEY NULL,
    [bsx_ba] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.day_defination_change
-- --------------------------------------------------
CREATE TABLE [dbo].[day_defination_change]
(
    [object_name] NVARCHAR(128) NOT NULL,
    [schema_name] NVARCHAR(128) NULL,
    [type_desc] NVARCHAR(60) NULL,
    [create_date] DATETIME NOT NULL,
    [modify_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.exclude_extra_expense
-- --------------------------------------------------
CREATE TABLE [dbo].[exclude_extra_expense]
(
    [Segment] VARCHAR(11) NULL,
    [Code] VARCHAR(12) NULL,
    [Franchisee] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_expense_grp
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_expense_grp]
(
    [ID] INT NOT NULL,
    [GrpName] VARCHAR(50) NULL,
    [Segment] VARCHAR(8) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_05112012
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_05112012]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_08112012
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_08112012]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_10052012
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_10052012]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_1apr2013
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_1apr2013]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_20122011
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_20122011]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ExtraExpense_6APR2013
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ExtraExpense_6APR2013]
(
    [particular] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [type] VARCHAR(6) NULL,
    [franchisee_code] VARCHAR(50) NULL,
    [month] INT NULL,
    [year] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_final1
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_final1]
(
    [particulars] VARCHAR(100) NULL,
    [ABLCM] MONEY NULL,
    [ACDLCM] MONEY NULL,
    [ACDLFO] MONEY NULL,
    [ACPLNCDX] MONEY NULL,
    [ACPLMCX] MONEY NULL,
    [ACPLMCD] MONEY NULL,
    [ACDLNSX] MONEY NULL,
    [flag] VARCHAR(6) NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL,
    [ABLCode] VARCHAR(12) NULL,
    [AcdlCode] VARCHAR(12) NULL,
    [FoCode] VARCHAR(12) NULL,
    [NcdxCode] VARCHAR(12) NULL,
    [McxCode] VARCHAR(12) NULL,
    [McdCode] VARCHAR(12) NULL,
    [NsxCode] VARCHAR(12) NULL,
    [ABLBSX] MONEY NULL,
    [BsxCode] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.franch_final2
-- --------------------------------------------------
CREATE TABLE [dbo].[franch_final2]
(
    [particular] VARCHAR(62) NULL,
    [ABLCM] FLOAT NULL,
    [ACDLCM] FLOAT NULL,
    [ACDLFO] FLOAT NULL,
    [ACPLNCDX] FLOAT NULL,
    [ACPLMCX] FLOAT NULL,
    [ACPLMCD] FLOAT NULL,
    [ACDLNSX] FLOAT NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL,
    [flag] VARCHAR(20) NOT NULL,
    [ABLBSX] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franch_ledcode
-- --------------------------------------------------
CREATE TABLE [dbo].[Franch_ledcode]
(
    [Ftag] VARCHAR(6) NULL,
    [AblCode] VARCHAR(14) NULL,
    [AcdlCode] VARCHAR(14) NULL,
    [AcdlFOCode] VARCHAR(14) NULL,
    [NcdxCode] VARCHAR(14) NULL,
    [McdxCode] VARCHAR(14) NULL,
    [McdCode] VARCHAR(14) NULL,
    [NsxCode] VARCHAR(14) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.franchise_lock
-- --------------------------------------------------
CREATE TABLE [dbo].[franchise_lock]
(
    [segment] VARCHAR(10) NULL,
    [month1] VARCHAR(13) NULL,
    [year1] VARCHAR(13) NULL,
    [locked_on] VARCHAR(25) NULL,
    [locked_by] VARCHAR(25) NULL
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
-- TABLE dbo.Franchisee_bsecm
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_bsecm]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_bsx
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_bsx]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_glcode_Mast
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_glcode_Mast]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Code] VARCHAR(12) NULL,
    [particulars] VARCHAR(50) NULL,
    [flag] VARCHAR(6) NULL,
    [Segment] VARCHAR(8) NULL,
    [updt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_glcode_Mast_15042011
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_glcode_Mast_15042011]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Code] VARCHAR(12) NULL,
    [particulars] VARCHAR(50) NULL,
    [flag] VARCHAR(6) NULL,
    [Segment] VARCHAR(8) NULL,
    [updt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_glcode_Mast_25042011
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_glcode_Mast_25042011]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Code] VARCHAR(12) NULL,
    [particulars] VARCHAR(50) NULL,
    [flag] VARCHAR(6) NULL,
    [Segment] VARCHAR(8) NULL,
    [updt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.franchisee_lock
-- --------------------------------------------------
CREATE TABLE [dbo].[franchisee_lock]
(
    [segment] VARCHAR(10) NULL,
    [month] NUMERIC(15, 7) NULL,
    [year] NUMERIC(15, 7) NULL,
    [locked_on] VARCHAR(13) NULL,
    [locked_by] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_Mast
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_Mast]
(
    [Ftag] VARCHAR(8) NOT NULL,
    [FName] VARCHAR(100) NULL,
    [B2B_IncomePercent] FLOAT NULL,
    [ExpenseShare] FLOAT NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [B2C_IncomePercent] REAL NULL,
    [Contact_person] VARCHAR(100) NULL,
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
-- TABLE dbo.FRANCHISEE_MAST_17062020
-- --------------------------------------------------
CREATE TABLE [dbo].[FRANCHISEE_MAST_17062020]
(
    [Ftag] VARCHAR(8) NOT NULL,
    [FName] VARCHAR(100) NULL,
    [B2B_IncomePercent] FLOAT NULL,
    [ExpenseShare] FLOAT NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [B2C_IncomePercent] REAL NULL,
    [Contact_person] VARCHAR(100) NULL,
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
-- TABLE dbo.FRANCHISEE_MAST_Bkp20May2021
-- --------------------------------------------------
CREATE TABLE [dbo].[FRANCHISEE_MAST_Bkp20May2021]
(
    [Ftag] VARCHAR(8) NOT NULL,
    [FName] VARCHAR(100) NULL,
    [B2B_IncomePercent] FLOAT NULL,
    [ExpenseShare] FLOAT NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [B2C_IncomePercent] REAL NULL,
    [Contact_person] VARCHAR(100) NULL,
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
-- TABLE dbo.Franchisee_MCD
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_MCD]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_mcdx]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_ncdx]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_nsecm
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_nsecm]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_nsefo]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_NSX
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_NSX]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchisee_registration_status
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchisee_registration_status]
(
    [Reg_status] VARCHAR(20) NULL,
    [Reg_status_val] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Franchiseewise_Status
-- --------------------------------------------------
CREATE TABLE [dbo].[Franchiseewise_Status]
(
    [Franchisee_tag] VARCHAR(8) NULL,
    [ABLCM_reg_status] VARCHAR(20) NULL,
    [ACDLCM_reg_status] VARCHAR(20) NULL,
    [ACDLFO_reg_status] VARCHAR(20) NULL,
    [ACPLNCDX_reg_status] VARCHAR(20) NULL,
    [ACPLMCX_reg_status] VARCHAR(20) NULL,
    [ACPLMCD_reg_status] VARCHAR(20) NULL,
    [ACDLNSX_reg_status] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GL_Grouping
-- --------------------------------------------------
CREATE TABLE [dbo].[GL_Grouping]
(
    [segment] VARCHAR(8) NULL,
    [grpid] INT NOT NULL,
    [id] INT NOT NULL,
    [grpname] VARCHAR(50) NULL,
    [code] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.grp_code_map
-- --------------------------------------------------
CREATE TABLE [dbo].[grp_code_map]
(
    [GlMastCodeId] INT NULL,
    [GrpId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new_FRANCHISEE_MAST
-- --------------------------------------------------
CREATE TABLE [dbo].[new_FRANCHISEE_MAST]
(
    [ftag] VARCHAR(16) NOT NULL,
    [fname] VARCHAR(38) NOT NULL
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
-- TABLE dbo.temp_Franchisee_bsecm
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Franchisee_bsecm]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Franchisee_mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Franchisee_mcdx]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Franchisee_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Franchisee_ncdx]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Franchisee_nsecm
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Franchisee_nsecm]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Franchisee_nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Franchisee_nsefo]
(
    [code] VARCHAR(10) NULL,
    [particulars] VARCHAR(100) NULL,
    [amount] MONEY NULL,
    [branch] CHAR(35) NULL,
    [tmonth] INT NULL,
    [tyear] INT NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.B2c_excl_franchisee
-- --------------------------------------------------
Create View [dbo].[B2c_excl_franchisee]  
as  
select b2c_sb from  mis.remisior.dbo.b2c_sb a  
left outer join  
(  
select sub_broker from intranet.risk.dbo.subbrokers where  branch_code in  
(  
select code from intranet.risk.dbo.region   
where franchisee='F'  
)  
) b  
on a.b2c_sb=b.sub_broker  
where b.sub_broker is null

GO

-- --------------------------------------------------
-- VIEW dbo.VW_Franchisee_Mast
-- --------------------------------------------------
create view  VW_Franchisee_Mast
as
 
select  Ftag, B2B_IncomePercent,B2C_IncomePercent,FromDate ,ToDate  from dbo.Franchisee_Mast with (nolock)

GO

