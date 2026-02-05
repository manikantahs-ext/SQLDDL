-- DDL Export
-- Server: 10.253.78.163
-- Database: testdb
-- Exported: 2026-02-05T12:32:32.183438

USE testdb;
GO

-- --------------------------------------------------
-- CHECK dbo.CashFlows
-- --------------------------------------------------
ALTER TABLE [dbo].[CashFlows] ADD CONSTRAINT [CK__CashFlows__time___562142A9] CHECK ([time_period] >= 0)

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.RA_VendorMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[RA_VendorMaster] ADD CONSTRAINT [FK__RA_Vendor__RefNo__381A7992] FOREIGN KEY ([RefNo]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Tbl_Test1
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_Test1] ADD CONSTRAINT [FK_Tbl_Test1_Tbl_Test2] FOREIGN KEY ([SB]) REFERENCES [dbo].[Tbl_Test2] ([SB])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorAddress_ContactDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorAddress_ContactDetails] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__1100AC71] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorAllDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorAllDocumentDetails] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__0F1863FF] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorBankMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorBankMaster] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__058EF9C5] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorCreationVerificationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorCreationVerificationMaster] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__77CAEA53] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorDirectors_PartnersDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorDirectors_PartnersDetails] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__4C21723F] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorDirectors_PartnersDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorDirectors_PartnersDocumentDetails] ADD CONSTRAINT [FK__tbl_Vendo__Partn__4EFDDEEA] FOREIGN KEY ([PartnersId]) REFERENCES [dbo].[tbl_VendorDirectors_PartnersDetails] ([PartnersId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorDirectors_PartnersDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorDirectors_PartnersDocumentDetails] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__4FF20323] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VendorGST_Details
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorGST_Details] ADD CONSTRAINT [FK__tbl_Vendo__Vendo__01BE68E1] FOREIGN KEY ([VendorMasterId]) REFERENCES [dbo].[tbl_VendorGeneralDetails] ([VendorMasterId])

GO

-- --------------------------------------------------
-- FUNCTION dbo.Cmonth
-- --------------------------------------------------

create function Cmonth(@mnth as int)
returns varchar(10)
as
BEGIN
declare @mnthname as varchar(10)
select @mnthname =
Case 
when @mnth=1 then 'January'
when @mnth=2 then 'February'
when @mnth=3 then 'March'
when @mnth=4 then 'April'
when @mnth=5 then 'May'
when @mnth=6 then 'June'
when @mnth=7 then 'July'
when @mnth=8 then 'August'
when @mnth=9 then 'September'
when @mnth=10 then 'October'
when @mnth=11 then 'November'
when @mnth=12 then 'December'
end
return @mnthname 
end

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
-- FUNCTION dbo.NPV
-- --------------------------------------------------
CREATE Function NPV(@rate as decimal(6,4),@Productid as int,@mnth as varchar(2), @yr as varchar(4),@username as varchar(10))  
RETURNS money   
as  
BEGIN   
DECLARE @resultsum DECIMAL (12,4)  
DECLARE @this_time_period int  
DECLARE @this_amount DECIMAL (12,4)  
--DECLARE @rate DECIMAL (6,4)  
--DECLARE @my_project_id CHAR(15)  
--set @my_project_id='TEST'  
set @rate=@rate/100  
  
DECLARE CashFlows CURSOR   
  FOR SELECT time_period, amount  
      FROM NPV_EMR  
    WHERE policycode =@Productid and [month]=@mnth and [year]=@yr  and username=@username
    ORDER BY time_period ASC   
  FOR READ ONLY  
  
SET @resultsum=0.0  
--@resultsum  
  
OPEN CashFlows   
  
 FETCH NEXT FROM CashFlows  
    INTO @this_time_period, @this_amount  
WHILE @@FETCH_STATUS = 0  
BEGIN  
--print @resultsum  
 SET @resultsum= @resultsum+ (@this_amount/POWER((1.0 + @rate), @this_time_period))  
 --END WHILE  
-- @resultsum now has the answer!  
--print @resultsum  
 FETCH NEXT FROM CashFlows  
    INTO @this_time_period, @this_amount  
END   
  
CLOSE CashFlows  
DEALLOCATE CashFlows   
return @resultsum  
END

GO

-- --------------------------------------------------
-- INDEX dbo.ecn_reg
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_client_code] ON [dbo].[ecn_reg] ([client_code])

GO

-- --------------------------------------------------
-- INDEX dbo.ecn_reg_branch
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_client_code] ON [dbo].[ecn_reg_branch] ([client_code])

GO

-- --------------------------------------------------
-- INDEX dbo.ecn_reg_GENERATE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_missingcltcode_ecn] ON [dbo].[ecn_reg_GENERATE] ([CLIENT_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.NPV_FromTo_month
-- --------------------------------------------------
CREATE CLUSTERED INDEX [mnthYear] ON [dbo].[NPV_FromTo_month] ([mnth], [myear])

GO

-- --------------------------------------------------
-- INDEX dbo.policytable
-- --------------------------------------------------
CREATE CLUSTERED INDEX [plytype_mnthYear] ON [dbo].[policytable] ([PolicyType], [Month], [Year])

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.Tradeanywhere_master
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Client_code] ON [dbo].[Tradeanywhere_master] ([Client_code])

GO

-- --------------------------------------------------
-- INDEX dbo.Tradeanywhere_master_newver
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Client_code] ON [dbo].[Tradeanywhere_master_newver] ([Client_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CashFlows
-- --------------------------------------------------
ALTER TABLE [dbo].[CashFlows] ADD CONSTRAINT [PK__CashFlows__552D1E70] PRIMARY KEY ([project_id], [time_period])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.chq_entry
-- --------------------------------------------------
ALTER TABLE [dbo].[chq_entry] ADD CONSTRAINT [PK_chq_entry] PRIMARY KEY ([AppNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.NPV_product_master
-- --------------------------------------------------
ALTER TABLE [dbo].[NPV_product_master] ADD CONSTRAINT [PK_NPV_product_master] PRIMARY KEY ([PolicyCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B6129FB09AD] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_CRMS_InsuranceSelectedColumnsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_CRMS_InsuranceSelectedColumnsDetails] ADD CONSTRAINT [PK__tbl_CRMS__1AA1420FC2F80E79] PRIMARY KEY ([ColumnId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_Test1
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_Test1] ADD CONSTRAINT [PK_Tbl_Test1] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_Test2
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_Test2] ADD CONSTRAINT [PK_Tbl_Test2] PRIMARY KEY ([SB])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VendorAllDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorAllDocumentDetails] ADD CONSTRAINT [PK__tbl_Vend__7CDA1D73635BFCDD] PRIMARY KEY ([VendorDocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VendorDirectors_PartnersDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorDirectors_PartnersDetails] ADD CONSTRAINT [PK__tbl_Vend__A6A986D25D852DD7] PRIMARY KEY ([PartnersId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VendorDirectors_PartnersDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorDirectors_PartnersDocumentDetails] ADD CONSTRAINT [PK__tbl_Vend__5DB5D817D711ECBF] PRIMARY KEY ([PartnersDocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VendorGeneralDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VendorGeneralDetails] ADD CONSTRAINT [PK__tbl_Vend__5198E0BFC6CE173A] PRIMARY KEY ([VendorMasterId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserDetp
-- --------------------------------------------------
ALTER TABLE [dbo].[UserDetp] ADD CONSTRAINT [PK_UserDetp] PRIMARY KEY ([DeptId])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.approval_rpt
-- --------------------------------------------------
CREATE proc [dbo].[approval_rpt]     
as    
set nocount on    
-- chnaged by Mohan dtd 12072019

select b.branch_cd,b.sub_broker,a.client_code
--,a.name
,b.long_name as name
,mail_id=upper(a.mail_id),a.tel_no,    
a.reg_date,a.path,A.PATH2 from ecn_reg_branch a (nolock)  join     
AngelNseCM.msajag.dbo.client_details b on a.client_code=b.party_code where a.reg_status<>''     
and a.status='NO' and a.mail_id<>'' --and a.client_code='jir052'--order by reg_date     
    
union all select b.branch_cd,b.sub_broker,a.client_code
--,a.name
,b.long_name as name
,mail_id=upper(a.mail_id),a.tel_no,    
a.reg_date,a.path,A.PATH2 from ecn_RDreg_branch a (nolock)  join     
AngelNseCM.msajag.dbo.client_details b on a.client_code=b.party_code where a.reg_status<>''     
and a.status='NO'  and a.mail_id<>'' order by reg_date    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM_CLT2
-- --------------------------------------------------
CREATE procedure ARM_CLT2                
as                          
                          
set nocount on                          
/*declare @tdate as varchar(25)                              
set @tdate = convert(varchar(11),getdate())                          
declare @acdate as varchar(25)                            
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')                               
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'                              
*/                      
            
/*                
select party_code,deposit=(debit*-1)+(APPR*.90)                    
into #aa                    
from intranet.risk.dbo.collection_client_details                     
*/         
   
            
select  party_code,deposit=((abl+acdl-cash_deposit)*-1),        
hold=(case when appr > 0 then APPR*.90 else appr*1.10 end)
,Collval=convert(money,0)        
into #aa            
from intranet.risk.dbo.collection_client_details    
--where party_code='A20894'                 

--select * from #aa            
--update #aa set deposit=deposit+hold        
        
declare @tdate as datetime            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.fomarh             
            
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from             
(            
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.fomarh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
            
---------------------------------------------- MCX            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.mcdx_marh            
             
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from             
(            
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.mcdx_marh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
            
            
---------------------------------------------- NCDEX            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.ncdx_marh            
             
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from             
(            
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.ncdx_marh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
      
--update #aa set deposit=case when abs(deposit)>hold then deposit else deposit+hold end      
update #aa set deposit=case when deposit<0 and abs(deposit)>hold+Collval then deposit   
--when deposit < 0 and abs(deposit)<=hold then deposit+hold  
else deposit+hold+Collval end       
  
---select * from #aa where party_code='jp04'                
                
--drop table #fo1                
select *                       
into #fo1                        
from #aa where                        
party_code in (select client_Code from Tradeanywhere_master )                        
order by party_code                      
--select * from #fo1                
--select * from #fo1 where party_code='A13410'                
                
select *                           
into #fo2                      
from Tradeanywhere_master                      
where client_code not in                            
(select party_code from #fo1 )                      
--select * from #fo2                
--select * from #fo2 where client_code='A13410'                
                       
select party_code,deposit                          
--into ARM_CLT                            
into #temp                
from #fo1                          
union                          
select client_code,0 from #fo2                      
order by party_code                 
                
--select * from #temp                
--select * from #temp where party_code='A13410'                
                
--drop table #temp1                
--select party_code,deposit=(debit*-1)+(APPR*.90)                  
select party_code,deposit          
into #temp1                   
--from intranet.risk.dbo.collection_client_details             
from #aa          
where party_code                
in (          
select party_code from genodinlimit.dbo.tbl_newclientdetails_hist where products_allowed='tradeanywhere'          
and party_Code not in (select party_code from Tradeanywhere_master)          
)                
       
          
          
          
          
--select * from intranet.risk.dbo.collection_client_details   where party_code='A13410'                
--select party_code from genodinlimit.dbo.tbl_newclientdetails where products_allowed='tradeanywhere'                
--and party_code='A13410'                
                
drop table ARM_CLT1                
--*******old table name ARM_CLT should delete while ARM_CLT1 get active****                
select * into ARM_CLT1 from #temp                
union                
select * from #temp1                  
--where party_code='A13410'              
                
                
--SELECT * FROM #amr_clt WHERE PARTY_CODE in                 
--('A13410','A14624','A6096','A9853','G4760','JAIP895','N7869','PTM0285','R10026','R13844')                
                
--SELECT * FROM #amr_clt WHERE PARTY_CODE='A13410'                
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM_CLT2_BACK
-- --------------------------------------------------
CREATE procedure ARM_CLT2_BACK                
as                          
                          
set nocount on                          
/*declare @tdate as varchar(25)                              
set @tdate = convert(varchar(11),getdate())                          
declare @acdate as varchar(25)                            
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')                               
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'                              
*/                      
            
/*                
select party_code,deposit=(debit*-1)+(APPR*.90)                    
into #aa                    
from intranet.risk.dbo.collection_client_details                     
*/         
   
            
select  party_code,deposit=((abl+acdl-cash_deposit)*-1),        
hold=(case when appr > 0 then APPR*.90 else appr*1.10 end)        
into #aa            
from intranet.risk.dbo.collection_client_details                     
            
--update #aa set deposit=deposit+hold        
        
declare @tdate as datetime            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.fomarh             
            
update #aa set deposit=deposit+ledgeramount from             
(            
select clCode,ledgeramount=ledgeramount+cash_coll+non_cash from intranet.risk.dbo.fomarh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
            
---------------------------------------------- MCX            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.mcdx_marh            
             
update #aa set deposit=deposit+ledgeramount from             
(            
select clCode,ledgeramount=ledgeramount+cash_coll+non_cash from intranet.risk.dbo.mcdx_marh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
            
            
---------------------------------------------- NCDEX            
Select @tdate=max(sauda_Date) from intranet.risk.dbo.ncdx_marh            
             
update #aa set deposit=deposit+ledgeramount from             
(            
select clCode,ledgeramount=ledgeramount+cash_coll+non_cash from intranet.risk.dbo.ncdx_marh            
where sauda_Date = @tdate) b            
where #aa.party_Code=b.clcode            
      
--update #aa set deposit=case when abs(deposit)>hold then deposit else deposit+hold end      
update #aa set deposit=case when deposit<0 and abs(deposit)>hold then deposit   
--when deposit < 0 and abs(deposit)<=hold then deposit+hold  
else deposit+hold end       
  
---select * from #aa where party_code='jp04'                
                
--drop table #fo1                
select *                       
into #fo1                        
from #aa where                        
party_code in (select client_Code from Tradeanywhere_master )                        
order by party_code                      
--select * from #fo1                
--select * from #fo1 where party_code='A13410'                
                
select *                           
into #fo2                      
from Tradeanywhere_master                      
where client_code not in                            
(select party_code from #fo1 )                      
--select * from #fo2                
--select * from #fo2 where client_code='A13410'                
                       
select party_code,deposit                          
--into ARM_CLT                            
into #temp                
from #fo1                          
union                          
select client_code,0 from #fo2                      
order by party_code                 
                
--select * from #temp                
--select * from #temp where party_code='A13410'                
                
--drop table #temp1                
--select party_code,deposit=(debit*-1)+(APPR*.90)                  
select party_code,deposit          
into #temp1                   
--from intranet.risk.dbo.collection_client_details             
from #aa          
where party_code                
in (          
select party_code from genodinlimit.dbo.tbl_newclientdetails_hist where products_allowed='tradeanywhere'          
and party_Code not in (select party_code from Tradeanywhere_master)          
)                
       
          
          
          
          
--select * from intranet.risk.dbo.collection_client_details   where party_code='A13410'                
--select party_code from genodinlimit.dbo.tbl_newclientdetails where products_allowed='tradeanywhere'                
--and party_code='A13410'                
                
drop table ARM_CLT1                
--*******old table name ARM_CLT should delete while ARM_CLT1 get active****                
select * into ARM_CLT1 from #temp                
union                
select * from #temp1                  
--where party_code='A13410'              
                
                
--SELECT * FROM #amr_clt WHERE PARTY_CODE in                 
--('A13410','A14624','A6096','A9853','G4760','JAIP895','N7869','PTM0285','R10026','R13844')                
                
--SELECT * FROM #amr_clt WHERE PARTY_CODE='A13410'                
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM_CLT3
-- --------------------------------------------------
CREATE procedure ARM_CLT3 (@server as varchar(20))                 
as                            
                            
set nocount on                            
/*declare @tdate as varchar(25)                                
set @tdate = convert(varchar(11),getdate())                            
declare @acdate as varchar(25)                              
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')                                 
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'                                
*/                        
              
/*                  
select party_code,deposit=(debit*-1)+(APPR*.90)                      
into #aa                      
from intranet.risk.dbo.collection_client_details                       
*/           
     
              
select  party_code,deposit=((abl+acdl-cash_deposit)*-1),          
hold=(case when appr > 0 then APPR*.90 else appr*1.10 end)  
,Collval=convert(money,0)          
into #aa              
from intranet.risk.dbo.collection_client_details      
--where party_code='A20894'                   
  
--select * from #aa              
--update #aa set deposit=deposit+hold          
          
declare @tdate as datetime              
Select @tdate=max(sauda_Date) from intranet.risk.dbo.fomarh               
              
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from               
(              
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.fomarh              
where sauda_Date = @tdate) b              
where #aa.party_Code=b.clcode              
              
---------------------------------------------- MCX              
Select @tdate=max(sauda_Date) from intranet.risk.dbo.mcdx_marh              
               
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from               
(              
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.mcdx_marh              
where sauda_Date = @tdate) b              
where #aa.party_Code=b.clcode              
              
              
---------------------------------------------- NCDEX              
Select @tdate=max(sauda_Date) from intranet.risk.dbo.ncdx_marh              
               
update #aa set deposit=deposit+ledgeramount,Collval=Collval+Coll from               
(              
select clCode,ledgeramount=ledgeramount,Coll=cash_coll+non_cash from intranet.risk.dbo.ncdx_marh              
where sauda_Date = @tdate) b              
where #aa.party_Code=b.clcode              
        
--update #aa set deposit=case when abs(deposit)>hold then deposit else deposit+hold end        
update #aa set deposit=case when deposit<0 and abs(deposit)>hold+Collval then deposit     
--when deposit < 0 and abs(deposit)<=hold then deposit+hold    
else deposit+hold+Collval end         
    
---select * from #aa where party_code='jp04'                  
                  
--drop table #fo1                  
select *                         
into #fo1                          
from #aa where                          
party_code in (select client_Code from Tradeanywhere_master )                          
order by party_code                        
--select * from #fo1                  
--select * from #fo1 where party_code='A13410'                  
                  
select *                             
into #fo2                        
from Tradeanywhere_master                        
where client_code not in                              
(select party_code from #fo1 )                        
--select * from #fo2                  
--select * from #fo2 where client_code='A13410'                  
                         
select party_code,deposit                            
--into ARM_CLT                              
into #temp                  
from #fo1                            
union                            
select client_code,0 from #fo2                        
order by party_code      
                  
--select * from #temp                  
--select * from #temp where party_code='A13410'                  
                  
--drop table #temp1                  
--select party_code,deposit=(debit*-1)+(APPR*.90)                    
select party_code,deposit            
into #temp1                     
--from intranet.risk.dbo.collection_client_details               
from #aa            
where party_code                  
in (            
select party_code from genodinlimit.dbo.tbl_newclientdetails_hist where products_allowed='tradeanywhere' and server=@server           
and party_Code not in (select party_code from Tradeanywhere_master)            
)                  
         
            
            
            
            
--select * from intranet.risk.dbo.collection_client_details   where party_code='A13410'                  
--select party_code from genodinlimit.dbo.tbl_newclientdetails where products_allowed='tradeanywhere'                  
--and party_code='A13410'                  
                  
drop table ARM_CLT1                  
--*******old table name ARM_CLT should delete while ARM_CLT1 get active****                  
select * into ARM_CLT1 from #temp                  
union                  
select * from #temp1                    
--where party_code='A13410'                
                  
                  
--SELECT * FROM #amr_clt WHERE PARTY_CODE in                   
--('A13410','A14624','A6096','A9853','G4760','JAIP895','N7869','PTM0285','R10026','R13844')                  
                  
--SELECT * FROM #amr_clt WHERE PARTY_CODE='A13410'                  
                  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM_Legder
-- --------------------------------------------------
CREATE procedure ARM_Legder    
as        
        
set nocount on        
/*declare @tdate as varchar(25)            
set @tdate = convert(varchar(11),getdate())        
declare @acdate as varchar(25)          
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')             
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'            
*/    
    
/*select party_code,deposit=ISNULL(a.CASH_DEPOSIT,0)+b.cash_coll+(abl+acdl+(b.LEDGERAMOUNT*-1))*-1+b.non_cash+(APPR*.90)    
into #aa    
from intranet.risk.dbo.collection_client_details a    
left outer join intranet.risk.dbo.FOMARH b    
on a.party_code=b.clcode    
where sauda_Date = (select max(sauda_date) from intranet.risk.dbo.FOMARH)    
--and party_code='za41'    
*/  
--  DROP TABLE #AA
select party_code,deposit=(debit*-1)+(APPR*.90)  
into #aa  
from intranet.risk.dbo.collection_client_details   
    
--SELECT * FROM #AA WHERE PARTY_CODE='ZA41'
select *     
into #fo1      
from #aa where      
party_code in (select client_Code from Tradeanywhere_master )      
order by party_code    
    
select *         
into #fo2    
from Tradeanywhere_master    
where client_code not in          
(select party_code from #fo1 )    
    
drop table ARM_CLT        
select party_code,deposit        
into ARM_CLT          
from #fo1        
union        
select client_code,0 from #fo2    
order by party_code    
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM1_new
-- --------------------------------------------------

CREATE procedure [dbo].[ARM1_new]    
as    
    
set nocount on    
declare @tdate as varchar(25)        
set @tdate = convert(varchar(11),getdate())    
declare @acdate as varchar(25)      
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')         
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'        
    
select cltcode,balance=sum(case when drcr='D' then vamt else -vamt end)     
into #abl_ARM    
from AngelBSECM.account_ab.dbo.ledger     
where vdt >=@acdate  and vdt <=@tdate +' 23:59:59'     
group by cltcode  ---71804    
    
  
select cltcode,balance=sum(case when drcr='D' then vamt else -vamt end)     
into #acdl_ARM    
from AngelNseCM.inhouse.dbo.ledger     
where vdt >=@acdate  and vdt <=@tdate      
group by cltcode  ---29005    
   
select clcode,Balance=net  
into #fo_ARM  
from intranet.risk.dbo.fomarh  
where sauda_date in (select max(sauda_date) from intranet.risk.dbo.fomarh)

select * into #fo1  
from #fo_arm where  
clcode in (select client_Code from Tradeanywhere_master)   ---169  
---group by clcode  ----120    
    
select cltcode=ISNULL(a.cltcode,B.CLTCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance,0))    
into #ARM_AA    
from #abl_ARM a FULL OUTER JOIN #acdl_ARM b    
ON a.cltcode=b.cltcode     
order by ISNULL(a.cltcode,B.CLTCODE)   --97  '85179  
    
    
--select cltcode=ISNULL(a.cltcode,B.CLCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance,0))    
---into #ARM_BB    
---from #ARM_AA a FULL OUTER JOIN #FO_ARM b    
--ON a.cltcode=b.clcode    
--order by ISNULL(a.cltcode,B.CLCODE)    
  
  
select cltcode=ISNULL(a.cltcode,B.CLCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance*-1,0))    
into #ARM_BB    
from #ARM_AA a FULL OUTER JOIN #FO1 b    
ON a.cltcode=b.clcode    
order by ISNULL(a.cltcode,B.CLCODE)  --85188  
  
    
SELECT *     
INTO #ARM1    
FROM #ARM_BB    
WHERE CLTCODE    
IN (SELECT CLIENT_CODE FROM TRADEANYWHERE_MASTER) ---262  ,457  
    
select *     
into #ARM_CC      
from tradeanywhere_master       
where client_code not in      
(select cltcode from #ARM1 )  ---150  ,177  
    
   
drop table ARM_CLT    
select cltcode,balance    
into ARM_CLT      
from #ARM1    
union    
select client_code,0 from #ARM_CC  ----634  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ARM1_new1
-- --------------------------------------------------

CREATE procedure [dbo].[ARM1_new1]    
as    
    
set nocount on    
declare @tdate as varchar(25)        
set @tdate = convert(varchar(11),getdate())    
declare @acdate as varchar(25)      
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')         
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'        
    
select cltcode,balance=sum(case when drcr='D' then vamt else -vamt end)     
into #abl_ARM    
from AngelBSECM.account_ab.dbo.ledger     
where vdt >=@acdate  and vdt <=@tdate +' 23:59:59'     
group by cltcode  ---71804    
    
  
select cltcode,balance=sum(case when drcr='D' then vamt else -vamt end)     
into #acdl_ARM    
from AngelNseCM.inhouse.dbo.ledger     
where vdt >=@acdate  and vdt <=@tdate      
group by cltcode  ---29005    

select clcode,Balance=net  
into #fo_ARM  
from intranet.risk.dbo.fomarh  
where sauda_date in (select max(sauda_date) from intranet.risk.dbo.fomarh)
   
select * into #fo1  
from #fo_arm where  
clcode in (select client_Code from Tradeanywhere_master)   ---169  
---group by clcode  ----120    
    
select cltcode=ISNULL(a.cltcode,B.CLTCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance,0))    
into #ARM_AA    
from #abl_ARM a FULL OUTER JOIN #acdl_ARM b    
ON a.cltcode=b.cltcode     
order by ISNULL(a.cltcode,B.CLTCODE)   --97  '85179  
    
    
--select cltcode=ISNULL(a.cltcode,B.CLCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance,0))    
---into #ARM_BB    
---from #ARM_AA a FULL OUTER JOIN #FO_ARM b    
--ON a.cltcode=b.clcode    
--order by ISNULL(a.cltcode,B.CLCODE)    
  
  
select cltcode=ISNULL(a.cltcode,B.CLCODE),balance=(ISNULL(a.balance,0)+ISNULL(b.balance,0))    
into #ARM_BB    
from #ARM_AA a FULL OUTER JOIN #FO1 b    
ON a.cltcode=b.clcode    
order by ISNULL(a.cltcode,B.CLCODE)  --85188  
  
    
SELECT *     
INTO #ARM1    
FROM #ARM_BB    
WHERE CLTCODE    
IN (SELECT CLIENT_CODE FROM TRADEANYWHERE_MASTER) ---262  ,457  
    
select *     
into #ARM_CC      
from tradeanywhere_master       
where client_code not in      
(select cltcode from #ARM1 )  ---150  ,177  
    
   
drop table ARM_CLT    
select cltcode,balance    
into ARM_CLT      
from #ARM1    
union    
select client_code,0 from #ARM_CC  ----634  
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BEN_new
-- --------------------------------------------------
CREATE procedure BEN_new    
as    
set nocount on     
  
/*select [Client Code]=a.party_Code,[DPID]=a.accno,[ISIN]=b.isin,[Quantity]=sum(a.qty)    
into #holding_ben    
from angeldemat.bsedb.dbo.multiisin b    
left outer join    
intranet.risk.dbo.holding a     
on a.scrip_cd=b.scrip_cd    
group by a.party_code,a.accno,b.isin    
having a.accno<>''     
order by party_code    
*/
select [Client Code]=a.party_Code,[DPID]=a.accno,[ISIN]=isnull(b.isin,a.isin)
,[Quantity]=sum(a.qty)    
into #holding_ben    
from angeldemat.bsedb.dbo.multiisin b    
full outer join    
intranet.risk.dbo.holding a     
on a.scrip_cd=b.scrip_cd    
group by a.party_code,a.accno,b.isin ,a.isin    
having a.accno<>''     
order by party_code 
    
select * into #clt_BEN    
from #holding_ben    
where [client code]  in (select client_Code from Tradeanywhere_master)    
order by [client code]    
    
select * into #HCT    
from tradeanywhere_master       
where client_code not in      
(select [client code] from #holding_ben )    
    
drop table clt_Ben    
select * into clt_BEN    
from #clt_BEN  where ISIN<>''  
--union    
--select Client_code,'0','0','0' from #HCT    
    
--select * from clt_BEN    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BEN_new2
-- --------------------------------------------------
CREATE procedure BEN_new2              
as              
set nocount on               
            
/*select [Client Code]=a.party_Code,[DPID]=a.accno,[ISIN]=b.isin,[Quantity]=sum(a.qty)              
into #holding_ben              
from angeldemat.bsedb.dbo.multiisin b              
left outer join              
intranet.risk.dbo.holding a               
on a.scrip_cd=b.scrip_cd              
group by a.party_code,a.accno,b.isin              
having a.accno<>''               
order by party_code              
*/          
select [Client Code]=a.party_Code,[DPID]=ltrim(rtrim(replace(a.accno,char(9),''))),[ISIN]=isnull(b.isin,a.isin)          
,[Quantity]=sum(a.qty)              
into #holding_ben              
from angeldemat.bsedb.dbo.multiisin b              
full outer join              
intranet.risk.dbo.holding a               
on a.scrip_cd=b.scrip_cd              
group by a.party_code,a.accno,b.isin ,a.isin              
having a.accno<>''               
order by party_code           
              
select * into #clt_BEN              
from #holding_ben              
where [client code]  in (select client_Code from Tradeanywhere_master_newver)              
order by [client code]              
 --select * from #clt_BEN             

select distinct cnt=count(isin),[client code],isin into #cnt 
from #clt_BEN  group by [client code],isin          
--from Tradeanywhere_master_newver                 
--where client_code not in                
--(select [client code] from #holding_ben )
   
drop table clt_Ben    
select distinct a.[client code],dpid=case when b.cnt>1 then '1' else min(dpid) end,
a.isin,quantity=sum(quantity) into clt_Ben from  #clt_BEN a join #cnt b on a.[client code]=b.[client code]
and a.isin=b.isin 
--where a.isin='INE012A01025'
group by a.[client code],a.isin,b.cnt
    
--select [client code],dpid=case when dpid='1203320000000051' then '1' else dpid end,    
--isin,quantity into #temp    
--from #clt_BEN     
--    
--    
--select distinct [client code],dpid=min(dpid),isin,quantity=sum(quantity)     
--into #final from #temp     
--group by [client code],isin order by [client code],isin                 
              
--drop table clt_Ben              
--select * into clt_BEN              
--from #final  where ISIN<>''            
             
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP_new
-- --------------------------------------------------
CREATE procedure [dbo].[CDP_new]  
as  
  
set nocount on  
  
select cm_cd,cm_blsavingcd   
into #CDP  
from ABCSOORACLEMDLW.synergy.dbo.client_master with(nolock) 
where cm_schedule='49843750' and cm_blsavingcd <> ''  
  
drop table Clt_CDP  
  
select *   
into CLT_CDP  
from #CDP  
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP_new31122012
-- --------------------------------------------------
create procedure CDP_new31122012  
as  
  
set nocount on  
  
select cm_cd,cm_blsavingcd   
into #CDP  
from DpBackoffice.AcerCross.dbo.client_master  
where cm_schedule='49843750' and cm_blsavingcd <> ''  
  
drop table Clt_CDP  
  
select *   
into CLT_CDP  
from #CDP  
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP1_new
-- --------------------------------------------------
CREATE procedure [dbo].[CDP1_new]    
as    
    
set nocount on    
    
select cm_cd,cm_blsavingcd     
into #CDP    
from ABCSOORACLEMDLW.synergy.dbo.client_master    
where cm_schedule='49843750' and cm_blsavingcd <> ''    
    
select *     
into #aa  
from #CDP    
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  ---145  
  
select *   
into #bb  
from Tradeanywhere_master    
where client_code not in  
(select cm_blsavingcd from #aa)   ---270  
  
  
drop table CDP_CLT  
Select cm_blsavingcd,cm_cd  
into CDP_CLT  
from #aa  
union  
select client_code,'0' from #bb    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP1_new31122012
-- --------------------------------------------------
CREATE procedure CDP1_new31122012    
as    
    
set nocount on    
    
select cm_cd,cm_blsavingcd     
into #CDP    
from DpBackoffice.AcerCross.dbo.client_master    
where cm_schedule='49843750' and cm_blsavingcd <> ''    
    
select *     
into #aa  
from #CDP    
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  ---145  
  
select *   
into #bb  
from Tradeanywhere_master    
where client_code not in  
(select cm_blsavingcd from #aa)   ---270  
  
  
drop table CDP_CLT  
Select cm_blsavingcd,cm_cd  
into CDP_CLT  
from #aa  
union  
select client_code,'0' from #bb    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP2_new
-- --------------------------------------------------
CREATE procedure [dbo].[CDP2_new]
as      
      
set nocount on      
      
select cm_cd,cm_blsavingcd       
into #CDP      
from ABCSOORACLEMDLW.synergy.dbo.client_master      
where cm_schedule='49843750' and cm_blsavingcd <> ''      
      
select *       
into #aa    
from #CDP      
where cm_blsavingcd in (select client_Code from Tradeanywhere_master_newver)  ---145    
    
select *     
into #bb    
from Tradeanywhere_master_newver      
where client_code not in    
(select cm_blsavingcd from #aa)   ---270    
    
    
drop table CDP_CLT    
Select cm_blsavingcd,cm_cd    
into CDP_CLT    
from #aa    
union    
select client_code,'0' from #bb      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDP2_new31122012
-- --------------------------------------------------
CREATE procedure CDP2_new31122012      
as      
      
set nocount on      
      
select cm_cd,cm_blsavingcd       
into #CDP      
from DpBackoffice.AcerCross.dbo.client_master      
where cm_schedule='49843750' and cm_blsavingcd <> ''      
      
select *       
into #aa    
from #CDP      
where cm_blsavingcd in (select client_Code from Tradeanywhere_master_newver)  ---145    
    
select *     
into #bb    
from Tradeanywhere_master_newver      
where client_code not in    
(select cm_blsavingcd from #aa)   ---270    
    
    
drop table CDP_CLT    
Select cm_blsavingcd,cm_cd    
into CDP_CLT    
from #aa    
union    
select client_code,'0' from #bb      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cl_combine
-- --------------------------------------------------
CREATE procedure [dbo].[cl_combine]
as        
set nocount on         

        
---Matching client Summary client code with new client code entry 
--drop table #cl
select * into #cl from 
(
select client_code  from Tradeanywhere_master 
union all
select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere'
)a


select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #abl_cl        
from AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
and party_code in (select client_Code from #cl)        

--select * from #abl_cl   where party_code='s8999'

update #abl_cl set fax=convert(varchar(11),getdate(),103) 
where party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')

--select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #abl_cl        
--from intranet.risk.dbo.bse_client1 c1, intranet.risk.dbo.bse_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)    
        
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #acdl_cl        
from AngelNseCM.msajag.dbo.client1 c1, AngelNseCM.msajag.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
and party_code in (select client_Code from #cl)        

update #acdl_cl set fax=convert(varchar(11),getdate(),103) 
where party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')
--select * from #acdl_cl where party_code='s8999'  
--select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #acdl_cl        
--from intranet.risk.dbo.nse_client1 c1, intranet.risk.dbo.nse_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
        
  
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #fo_cl        
from angelfo.nsefo.dbo.client1 c1, angelfo.nsefo.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
and party_code in (select client_Code from #cl)        
        
update #fo_cl set fax=convert(varchar(11),getdate(),103) 
where party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')
  
--select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #fo_cl        
--from intranet.risk.dbo.fo_client1 c1, intranet.risk.dbo.fo_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
        
        
select * into #b1 from #acdl_cl where party_code not in        
(select party_code from #abl_cl)        
        
select * into #fo1 from #fo_cl where party_code not in        
(select party_code from #abl_cl        
union        
select party_code from #acdl_cl        
)        
        
        
select * into #aa from #abl_cl        
union        
select * from #b1        
union        
select * from #fo1         
        
select * into #bb        
--from tradeanywhere_master         
from #cl
where client_code not in        
(select party_code from #aa )  ----147        
        
drop table cl_trade        
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,        
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,        
cl_category='Online',profile='PROFILE1'        
into CL_Trade        
from #aa        
union        
select client_code,'TEST ID ',client_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cl_combine1
-- --------------------------------------------------
CREATE procedure [dbo].[cl_combine1]              
as                      
set nocount on                       
              
                      
---Matching client Summary client code with new client code entry               
--drop table #cl              
Set transaction isolation  level read uncommitted        
select * into #cl from               
(              
select client_code,Profile=Profile_code  from Tradeanywhere_master (nolock)              
union all              
select party_code, Profile = (select NSECM+BSECM+NSEFO from genodinlimit.dbo.diet_SegmentValue where total = Segment_Allowed_code )   from GenOdinLimit.dbo.diet_cli_all(nolock)              
where Products_Allowed='TradeAnywhere' and server = '172.31.15.13'             
)a              
          
              
/*select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,                      
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                      
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                       
email ,branch_cd,sub_broker,family,profile                      
into #abl_cl                      
from AngelBSECM.bsedb_ab.dbo.client1 c1            
join AngelBSECM.bsedb_ab.dbo.client2 c2 on c1.cl_code=c2.cl_Code                      
join #cl c3 on c1.cl_code=c3.client_code            
            
              
update #abl_cl set fax=convert(varchar(11),getdate(),103)               
where party_code in (select party_code from GenOdinLimit.dbo.tbl_Clianywhere (nolock)              
where Products_Allowed='tradeanywhere')              
              
--drop table #acdl_cl            
*/                      
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                      
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                      
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                       
email ,branch_cd,sub_broker,family ,profile                     
into #acdl_cl                      
from AngelNseCM.msajag.dbo.client_details c1            
join #cl c3 on c1.cl_code=c3.client_code            
               
update #acdl_cl set fax=convert(varchar(11),getdate(),103)               
where party_code in (select party_code from         
GenOdinLimit.dbo.diet_cli_all where Products_Allowed='TradeAnywhere' and server = '172.31.15.13')              
          
        
/*select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                      
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                      
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                       
email ,branch_cd,sub_broker,family ,profile                     
into #fo_cl                      
from angelfo.nsefo.dbo.client1 c1            
join angelfo.nsefo.dbo.client2 c2 on c1.cl_code=c2.cl_Code                      
join #cl c3 on c1.cl_code=c3.client_code            
                      
update #fo_cl set fax=convert(varchar(11),getdate(),103)               
where party_code in (select party_code from         
GenOdinLimit.dbo.tbl_Clianywhere where Products_Allowed='tradeanywhere')              
                
select * into #b1 from #acdl_cl where party_code not in                      
(select party_code from #abl_cl)                      
                      
select * into #fo1 from #fo_cl where party_code not in                      
(select party_code from #abl_cl                      
union                      
select party_code from #acdl_cl                      
)                      
                      
                      
select * into #aa from #abl_cl                      
union                      
select * from #b1                      
union                      
select * from #fo1                       
*/        
                      
select * into #bb                      
from #cl              
where client_code not in                      
--(select party_code from #aa )  ----147        
(select distinct party_code from #acdl_cl )                       
        
                      
drop table cl_trade                      
select distinct party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,                      
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,                      
cl_category='Online',profile            
into CL_Trade                      
--from #aa              
from #acdl_cl        
union all                     
select distinct client_code,'TEST ID ',client_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb                      
           
                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cl_combine2
-- --------------------------------------------------
CREATE procedure [dbo].[cl_combine2]  (@server as varchar(20))                                  
as                                            
set nocount on                                             
                                    
                                            
---Matching client Summary client code with new client code entry                                     
--drop table #cl -- SELECT * FROM #acdl_cl  WHERE STATUS='A'                                
Set transaction isolation  level read uncommitted                              
select * into #cl from                                     
(                                    
select client_code,Profile=Profile_code,status='M'  from Tradeanywhere_master_newver (nolock)                                    
union all                                    
select party_code, Profile = (select NSECM+BSECM+NSEFO from genodinlimit.dbo.diet_SegmentValue where total = Segment_Allowed_code ),status='A'   from GenOdinLimit.dbo.diet_cli_all(nolock)                                    
where Products_Allowed='TradeAnywhere' and server =@server                              
)a                                    
                                
                                         
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                                            
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                                            
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager=ltrim(rtrim(Mobile_Pager)),                                             
email ,branch_cd,sub_broker,family ,profile ,pan_gir_no,c3.status                                       
into #acdl_cl                                            
from AngelNseCM.msajag.dbo.client_details c1                                  
join #cl c3 on c1.cl_code=c3.client_code                                  
                                     
update #acdl_cl set fax=convert(varchar(11),getdate(),103)                                    
where party_code in (select party_code from                               
 GenOdinLimit.dbo.diet_cli_all_hist where Products_Allowed='TradeAnywhere' and server = @server)                                                       
                                            
                                            
                                      
select * into #bb                                            
from #cl                                    
where client_code not in                                            
--(select party_code from #aa )  ----147                              
(select distinct party_code from #acdl_cl )                                             
                              
                                            
drop table cl_trade                                            
select distinct party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,                                            
L_nation,L_zip,L_phoneR,L_phoneO,Fax,mobile_pager=replace(ltrim(rtrim(mobile_pager)),char(9),''),email,branch_cd,pan_gir_no, family,                                           
cl_category='Online',profile,status--=case when fax like '%/%' then 'A' ELSE 'M' END                                
into CL_Trade                                            
--from #aa                                    
from #acdl_cl                              
union all                                           
select distinct client_code,'TEST ID ',client_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','','M' from #bb                                            
                                 
                                            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.clcd_trade
-- --------------------------------------------------
CREATE procedure [dbo].[clcd_trade]  
as  
  
set nocount on  
set transaction isolation level read uncommitted   
  
  
select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,          
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),          
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,           
email ,branch_cd,sub_broker,family          
into #abl_cl          
from AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2 where c1.cl_code=c2.cl_Code          
and party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')         
  
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,          
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),          
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,           
email ,branch_cd,sub_broker,family          
into #acdl_cl          
from AngelNseCM.msajag.dbo.client1 c1, AngelNseCM.msajag.dbo.client2 c2 where c1.cl_code=c2.cl_Code          
and party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')         
  
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,          
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),          
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,           
email ,branch_cd,sub_broker,family          
into #fo_cl          
from angelfo.nsefo.dbo.client1 c1, angelfo.nsefo.dbo.client2 c2 where c1.cl_code=c2.cl_Code          
and party_code in (select party_code from mis.GenOdinLimit.dbo.tbl_NewClientDetails where Products_Allowed='tradeanywhere')         
  
select * into #b1 from #acdl_cl where party_code not in          
(select party_code from #abl_cl)          
  
select * into #fo1 from #fo_cl where party_code not in          
(select party_code from #abl_cl          
union          
select party_code from #acdl_cl          
)          
  
select * into #aa from #abl_cl          
union          
select * from #b1          
union          
select * from #fo1           
  
select *   
into #bb          
from mis.GenOdinLimit.dbo.tbl_NewClientDetails  
where party_code not in          
(select party_code from #aa ) and Products_Allowed='tradeanywhere' ----147          
  
          
  
TRUNCATE table cl_EBROK  
  
  
insert into CL_EBROK  
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,          
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,          
cl_category='Online',profile='PROFILE1'          
--into CL_EBROK   
from #aa          
union          
select party_code,'TEST ID ',party_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb          
          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.clcd_trade1
-- --------------------------------------------------
CREATE procedure [dbo].[clcd_trade1]            
as            
            
set nocount on            
set transaction isolation level read uncommitted             
            
            
select t1.party_Code,short_name,long_name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #abl_cl                  
from AngelBSECM.bsedb_ab.dbo.client1 c1        
join AngelBSECM.bsedb_ab.dbo.client2 c2         
on c1.cl_code=c2.cl_Code          
join GenOdinLimit.dbo.tbl_Clianywhere t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                   
        
        
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #acdl_cl                    
from AngelNseCM.msajag.dbo.client1 c1 join AngelNseCM.msajag.dbo.client2 c2         
on c1.cl_code=c2.cl_Code                    
join GenOdinLimit.dbo.tbl_Clianywhere t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                   
        
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #fo_cl                    
from angelfo.nsefo.dbo.client1 c1 join angelfo.nsefo.dbo.client2 c2 on c1.cl_code=c2.cl_Code                    
join GenOdinLimit.dbo.tbl_Clianywhere t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                   
        
select * into #b1 from #acdl_cl where party_code not in                    
(select party_code from #abl_cl)                    
            
select * into #fo1 from #fo_cl where party_code not in                    
(select party_code from #abl_cl                    
union                    
select party_code from #acdl_cl                    
)                    
            
select * into #aa from #abl_cl                    
union                    
select * from #b1                    
union                    
select * from #fo1                     
        
            
select *             
into #bb                    
from GenOdinLimit.dbo.tbl_Clianywhere            
where party_code not in                    
(select party_code from #aa ) and Products_Allowed='tradeanywhere' ----147                    
            
                    
            
TRUNCATE table cl_EBROK1           
            
            
insert into CL_EBROK1           
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,                    
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,                    
cl_category='Online',profile=segment_allowed_code        
--into CL_EBROK1             
from #aa          
union                    
select party_code,'TEST ID ',party_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb                    
                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.clcd_trade1_new
-- --------------------------------------------------
CREATE procedure [dbo].[clcd_trade1_new] (@server as varchar(25))                        
as                        
                        
set nocount on                        
set transaction isolation level read uncommitted                         
                
          
                        
select t1.party_Code,short_name,long_name,l_address1,L_address2,L_Address3,                                
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                                
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                                 
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code = (select NSECM+BSECM+NSEFO from genodinlimit.dbo.diet_SegmentValue where total = Segment_Allowed_code )                                                                         
into #abl_cl                              
from AngelBSECM.bsedb_ab.dbo.client1 c1                    
join AngelBSECM.bsedb_ab.dbo.client2 c2                     
on c1.cl_code=c2.cl_Code                      
join GenOdinLimit.dbo.diet_cli_all t1                     
on c1.cl_code=t1.party_code                     
where Products_Allowed='TradeAnywhere' and server=@server               
          
        
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                                
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                                
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                                 
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code = (select NSECM+BSECM+NSEFO from genodinlimit.dbo.diet_SegmentValue where total = Segment_Allowed_code )                                                                         
into #acdl_cl                                
from AngelNseCM.msajag.dbo.client1 c1 join AngelNseCM.msajag.dbo.client2 c2                     
on c1.cl_code=c2.cl_Code                                
join GenOdinLimit.dbo.diet_cli_all t1                     
on c1.cl_code=t1.party_code                     
where Products_Allowed='TradeAnywhere' and server=@server                                          
                    
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                                
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                                
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                                 
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code  = (select NSECM+BSECM+NSEFO from genodinlimit.dbo.diet_SegmentValue where total = Segment_Allowed_code )                                                                         
into #fo_cl                                
from angelfo.nsefo.dbo.client1 c1 join angelfo.nsefo.dbo.client2 c2 on c1.cl_code=c2.cl_Code                                
join GenOdinLimit.dbo.diet_cli_all t1                     
on c1.cl_code=t1.party_code                     
where Products_Allowed='TradeAnywhere'  and server=@server   
                    
select * into #b1 from #acdl_cl where party_code not in                                
(select party_code from #abl_cl)                                
                        
select * into #fo1 from #fo_cl where party_code not in                                
(select party_code from #abl_cl                                
union                                
select party_code from #acdl_cl                                
)                                
                        
select * into #aa from #abl_cl                                
union                                
select * from #b1                                
union                                
select * from #fo1                                 
                    
                        
select *                  
into #bb                                
from GenOdinLimit.dbo.diet_cli_all                        
where party_code not in                                
(select party_code from #aa ) and Products_Allowed='TradeAnywhere' and server=@server        ----147                                
                     
                                
                        
TRUNCATE table cl_EBROK1        
                       
insert into CL_EBROK1                     
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,                                
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,                                
cl_category='Online',profile=segment_allowed_code                    
--into CL_EBROK1                         
from #aa                      
union                                
select party_code,'TEST ID ',party_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb                                
                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.clcd_trade2_anywhere
-- --------------------------------------------------
CREATE procedure [dbo].[clcd_trade2_anywhere]           
as            
            
set nocount on            
set transaction isolation level read uncommitted             
            
            
select t1.party_Code,short_name,long_name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #abl_cl                  
from AngelBSECM.bsedb_ab.dbo.client1 c1        
join AngelBSECM.bsedb_ab.dbo.client2 c2         
on c1.cl_code=c2.cl_Code          
join mis.GenOdinLimit.dbo.diet_cli_all t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                  
        
        
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax=convert(varchar(11),getdate(),103),Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #acdl_cl                    
from AngelNseCM.msajag.dbo.client1 c1 join AngelNseCM.msajag.dbo.client2 c2         
on c1.cl_code=c2.cl_Code                    
join mis.GenOdinLimit.dbo.diet_cli_all t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                   
        
select t1.party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,                    
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),                    
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,                     
c1.email ,branch_cd,sub_broker,family,Segment_Allowed_code                    
into #fo_cl                    
from angelfo.nsefo.dbo.client1 c1 join angelfo.nsefo.dbo.client2 c2 on c1.cl_code=c2.cl_Code                    
join mis.GenOdinLimit.dbo.diet_cli_all t1         
on c1.cl_code=t1.party_code         
where Products_Allowed='tradeanywhere'                   
        
select * into #b1 from #acdl_cl where party_code not in                    
(select party_code from #abl_cl)                    
            
select * into #fo1 from #fo_cl where party_code not in                    
(select party_code from #abl_cl                    
union                    
select party_code from #acdl_cl                    
)                    
            
select * into #aa from #abl_cl                    
union                    
select * from #b1                    
union                    
select * from #fo1                     
        
            
select *             
into #bb                    
from mis.GenOdinLimit.dbo.diet_cli_all            
where party_code not in                    
(select party_code from #aa ) and Products_Allowed='tradeanywhere' ----147                    
            
Truncate table cl_EBROK1_new    
            
insert into mis.testdb.dbo.cl_EBROK1_new    
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,                    
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,                    
cl_category='Online',profile=segment_allowed_code        
--into CL_EBROK1             
from #aa          
union                    
select party_code,'TEST ID ',party_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb                    
                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLF1_new
-- --------------------------------------------------
CREATE procedure CLF1_new
as

set nocount on

SELECT * 
INTO #CC1
FROM clean_limits
WHERE CL_CODE
IN (SELECT CLIENT_CODE FROM TRADEANYWHERE_MASTER) 

select * 
into #CC2  
from tradeanywhere_master   
where client_code not in  
(select cl_code from #CC1 )  ---150

DROP TABLE CLF_CLT  
select cl_code,CLEAN_LIMITS
into CLF_CLT  
from #CC1
union
select client_code,0 from #CC2

set nocount oFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLF2_new
-- --------------------------------------------------
CREATE procedure CLF2_new  
as  
  
set nocount on  
  
SELECT *   
INTO #CC1  
FROM clean_limits  
WHERE CL_CODE  
IN (SELECT CLIENT_CODE FROM TRADEANYWHERE_MASTER_newver)   
  
select *   
into #CC2    
from tradeanywhere_master_newver     
where client_code not in    
(select cl_code from #CC1 )  ---150  
  
DROP TABLE CLF_CLT    
select cl_code,CLEAN_LIMITS  
into CLF_CLT    
from #CC1  
union  
select client_code,0 from #CC2  
  
set nocount oFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.client_new
-- --------------------------------------------------
CREATE procedure [dbo].[client_new]( @dt as varchar(11),@branch as varchar(11),@coname as varchar(10))
as

set nocount on
/*declare @tdate as varchar(25)    
set @tdate = convert(varchar(11),getdate())

declare @dt as varchar(25)
set @dt='May  1 2005'
declare @branch as varchar(25)
set @branch='ho'
*/
declare @tdate as varchar(25)    
set @tdate = convert(varchar(11),getdate())
/*select @tdate = convert(varchar(11),getdate()),@dt='May  1 2005',@branch='ho'*/

declare @acdate as varchar(25)  
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')     
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'    
--print @acdate 

--declare @actdate as varchar(25)    
--select @actdate='Mar 31 '+(case when substring(@tdate,1,3) in ('Jan','Feb','Mar')     
--then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)+1) end)+' 00:00:00'  

--select distinct cltcode into #notrade from ledger where vdt >=@tdate+' 00:00:00' and vtyp = 15

if upper(@coname)='ACDLCM'
BEGIN

	select party_code,short_name,branch_cd,sub_broker 
	into #acdlcm1
	from AngelNseCM.msajag.dbo.client1 a,AngelNseCM.msajag.dbo.client2 b where a.cl_code=b.cl_code and branch_cd=@branch

	select distinct cltcode into #acdlcm2 from AngelNseCM.account.dbo.ledger where vdt >=@dt and vtyp = 15
	--drop table #acdlcm2
	select CONAME=@CONAME,party_code,short_name,branch_cd,sub_broker,balance=sum(case when drcr='D' then vamt else -vamt end) ,
	last_trx_date=max(vdt)
	from AngelNseCM.account.dbo.ledger a , #acdlcm1 b 
	where a.cltcode=b.party_code and a.cltcode not in (select cltcode from #acdlcm2)
	and vdt >=@acdate  and vdt <= @tdate  
	group by party_code,short_name,branch_cd,sub_broker
	having sum(case when drcr='D' then vamt else -vamt end) <> 0
	order by sub_broker,party_code
end 

if upper(@coname)='ABLCM'
BEGIN
	select party_code,short_name,branch_cd,sub_broker 
	into #ablcm1
	from AngelBSECM.msajag.dbo.client1 a,AngelBSECM.msajag.dbo.client2 b where a.cl_code=b.cl_code and branch_cd='ho'
--@branch
--declare @dt as varchar(25)
--set @dt='May  1 2005'

	select distinct cltcode into #ablcm2 from AngelBSECM.account_ab.dbo.ledger where vdt >=@dt and vtyp = 15

	select CONAME=@CONAME,party_code,short_name,branch_cd,sub_broker,balance=sum(case when drcr='D' then vamt else -vamt end) ,
	last_trx_date=max(vdt)
	from AngelBSECM.account_ab.dbo.ledger a ,#ablcm1 b 
	where a.cltcode=b.party_code and a.cltcode not in (select cltcode from #ablcm2)
	and vdt >=@acdate  and vdt <= @tdate  
	group by party_code,short_name,branch_cd,sub_broker
	having sum(case when drcr='D' then vamt else -vamt end) <> 0
	order by sub_broker,party_code
END

if upper(@coname)='ACDLFO'
BEGIN

	select party_code,short_name,branch_cd,sub_broker 
	into #acdlfo1
	from angelfo.msajag.dbo.client1 a,angelfo.msajag.dbo.client2 b where a.cl_code=b.cl_code and branch_cd=@branch

	select distinct cltcode into #acdlfo2 from angelfo.accountfo.dbo.ledger where vdt >=@dt and vtyp = 15

	select CONAME=@CONAME,party_code,short_name,branch_cd,sub_broker,balance=sum(case when drcr='D' then vamt else -vamt end) ,
	last_trx_date=max(vdt)
	from angelfo.accountfo.dbo.ledger a ,#acdlfo1 b 
	where a.cltcode=b.party_code and a.cltcode not in (select cltcode from #acdlfo2)
	and vdt >=@acdate  and vdt <= @tdate  
	group by party_code,short_name,branch_cd,sub_broker
	having sum(case when drcr='D' then vamt else -vamt end) <> 0
	order by sub_broker,party_code

END

if upper(@coname)='ACPLNCDX'
BEGIN

	select party_code,short_name,branch_cd,sub_broker 
	into #ncdx1
	from angelcommodity.ncdx.dbo.client1 a,angelcommodity.ncdx.dbo.client2 b where a.cl_code=b.cl_code and branch_cd=@branch

	select distinct cltcode into #ncdx2 from angelcommodity.accountncdx.dbo.ledger where vdt >=@dt and vtyp = 15

	select CONAME=@CONAME,party_code,short_name,branch_cd,sub_broker,balance=sum(case when drcr='D' then vamt else -vamt end) ,
	last_trx_date=max(vdt)
	from angelcommodity.accountncdx.dbo.ledger a ,#ncdx1 b 
	where a.cltcode=b.party_code and a.cltcode not in (select cltcode from #ncdx2)
	and vdt >=@acdate  and vdt <= @tdate  
	group by party_code,short_name,branch_cd,sub_broker
	having sum(case when drcr='D' then vamt else -vamt end) <> 0
	order by sub_broker,party_code

END


if upper(@coname)='ACPLMCX'
BEGIN

	select party_code,short_name,branch_cd,sub_broker 
	into #mcdx1
	from angelcommodity.mcdx.dbo.client1 a,angelcommodity.mcdx.dbo.client2 b where a.cl_code=b.cl_code and branch_cd=@branch

	select distinct cltcode into #mcdx2 from angelcommodity.accountmcdx.dbo.ledger where vdt >=@dt and vtyp = 15

	select CONAME=@CONAME,party_code,short_name,branch_cd,sub_broker,balance=sum(case when drcr='D' then vamt else -vamt end) ,
	last_trx_date=max(vdt)
	from angelcommodity.accountmcdx.dbo.ledger a ,#mcdx1 b 
	where a.cltcode=b.party_code and a.cltcode not in (select cltcode from #mcdx2)
	and vdt >=@acdate  and vdt <= @tdate  
	group by party_code,short_name,branch_cd,sub_broker
	having sum(case when drcr='D' then vamt else -vamt end) <> 0
	order by sub_broker,party_code


END



set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.clilabel
-- --------------------------------------------------

CREATE procedure [dbo].[clilabel](@actdate as varchar(11), @sbcode as varchar(10), @brcode as varchar(10))
as

set nocount on

select distinct party_code into #ablcli from AngelBSECM.bsedb_Ab.dbo.cmbillvalan where sauda_date >= @actdate 

select  pclcurname=ltrim(rtrim(c2.party_code))+' '+c1.long_name, padd1=l_address1,padd2=l_address2,
padd3=l_address3,padd4=l_city+' '+l_state,padd5=l_zip,c2.party_code
into #report1
from AngelBSECM.bsedb_Ab.dbo.client1 c1, 
(select cl_code,party_code from AngelBSECM.bsedb_Ab.dbo.client2 where party_code in (select party_code from #ablcli))c2 
where c1.cl_code=c2.cl_code 


select distinct party_code into #acdlcli from AngelNseCM.msajag.dbo.cmbillvalan where sauda_date >= @actdate

select  pclcurname=ltrim(rtrim(c2.party_code))+' '+c1.long_name, padd1=l_address1,padd2=l_address2,
padd3=l_address3,padd4=l_city+' '+l_state,padd5=l_zip,c2.party_code
 into #report2 from AngelNseCM.msajag.dbo.client1 c1, 
(select cl_code,party_code from AngelNseCM.msajag.dbo.client2 where party_code in (select party_code from #acdlcli))c2 
where c1.cl_code=c2.cl_code 


select distinct party_code into #focli from angelfo.nsefo.dbo.fobillvalan where sauda_date >= @actdate

select  pclcurname=ltrim(rtrim(c2.party_code))+' '+c1.long_name, padd1=l_address1,padd2=l_address2,
padd3=l_address3,padd4=l_city+' '+l_state,padd5=l_zip,c2.party_code
 into #report3 from angelfo.nsefo.dbo.client1 c1, 
(select cl_code,party_code from angelfo.nsefo.dbo.client2 where party_code in (select party_code from #focli))c2 
where c1.cl_code=c2.cl_code 



select distinct party_code into #ncdxcli from angelcommodity.ncdx.dbo.fobillvalan where sauda_date >= @actdate

select  pclcurname=ltrim(rtrim(c2.party_code))+' '+c1.long_name, padd1=l_address1,padd2=l_address2,
padd3=l_address3,padd4=l_city+' '+l_state,padd5=l_zip,c2.party_code
 into #report4 from angelcommodity.ncdx.dbo.client1 c1, 
(select cl_code,party_code from angelcommodity.ncdx.dbo.client2 where party_code in (select party_code from #ncdxcli))c2 
where c1.cl_code=c2.cl_code 



select distinct party_code into #mcdxcli from angelcommodity.mcdx.dbo.fobillvalan where sauda_date >= @actdate

select  pclcurname=ltrim(rtrim(c2.party_code))+' '+c1.long_name, padd1=l_address1,padd2=l_address2,
padd3=l_address3,padd4=l_city+' '+l_state,padd5=l_zip,c2.party_code
 into #report5 from angelcommodity.mcdx.dbo.client1 c1, 
(select cl_code,party_code from angelcommodity.mcdx.dbo.client2 where party_code in (select party_code from #mcdxcli))c2 
where c1.cl_code=c2.cl_code 



select * into #finlabel from #report1

insert into #finlabel 
select * from #report2 where party_code not in (select party_code from #report1)
 
insert into #finlabel 
select * from #report3 where party_code not in (select party_code from #finlabel)

insert into #finlabel 
select * from #report4 where party_code not in (select party_code from #finlabel)

insert into #finlabel 
select * from #report5 where party_code not in (select party_code from #finlabel)

select * from #finlabel a, (select * from intranet.risk.dbo.finmast where sbtag=@brcode and subgroup=@sbcode)b 
where a.party_code=b.party_Code

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Convert_YahooToSify_mail
-- --------------------------------------------------
CREATE procedure Convert_YahooToSify_mail                    
as                    
  
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp                     
              
declare @tag varchar(12),@email varchar(200),@mess as varchar(4000),                       
@name as varchar(100)                        
                 
                  
set @mess='Dear Customer,  
  
As we are facing issue to get your Contract Notes delivered on your Yahoo ID, due to technical error from Yahoo Domain, we are converting your Sify email ID which is generated by Angel as your primary ID and your Yahoo ID will be your secondary ID, you wi
ll be receiving Contract Notes on both this IDs.  
  
'             
                      
DECLARE sentECN_invite CURSOR FOR                                                                       
select  partycode,email      
from Convert_YahooToSify(nolock) where Sent='N' and email<>''      
                             
                                                                      
OPEN sentECN_invite                                                                      
                                                                      
FETCH NEXT FROM sentECN_invite                                                                       
INTO @tag,@email      
                                                                      
WHILE @@FETCH_STATUS = 0                                                                      
BEGIN                         
                      
            
                 
 exec intranet.msdb.dbo.sp_send_dbmail                 
 @recipients = @email,                           
-- @cc = 'Pramita.Poojary@angeltrade.com',           
  @profile_name = 'angelecn',                  
 --@from = 'angelecn@angeltrade.com',               
 @subject = 'Your Sify ID',                           
 @body=@mess                        
      
   update Convert_YahooToSify set sent='Y' where partycode=@tag      
        
 FETCH NEXT FROM sentECN_invite                                                                       
 INTO @tag,@email      
                                
      
END                      
                      
                                            
                                         
                                                        
CLOSE sentECN_invite                                                          
DEALLOCATE sentECN_invite

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ConvertToNonEcn
-- --------------------------------------------------
CREATE proc [dbo].[ConvertToNonEcn]                                      
as    
begin    
set nocount on                               
/*                        
DECLARE @STR AS VARCHAR(5000)                                  
SET @STR=''                                  
                                    
declare @fdate varchar(11),@tdate varchar(11),@nod int                                      
select @nod=nod from Nod_bounce_NECN (nolock)                                      
--set @fdate=getdate()-@nod                                      
--set @tdate=getdate()-1                                      
drop table temp__date                                  
                                  
SET @STR=@STR + 'select top '+CONVERT(VARCHAR(1),@NOD)+' SAUDA_DATE into temp__date from remisior.dbo.comb_co where'                                   
SET @STR=@STR + ' segment=''ABLCM'' and sauda_date<getdate()  order by sauda_date desc'                                  
EXEC(@STR)                                  
                                  
select @fdate=min(sauda_date) from  temp__date                                  
select @tdate=max(sauda_date) from  temp__date                                  
                                  
--print @nod                                      
--print @fdate                                      
--print @tdate                                      
                                      
/*select distinct clientcode,DocumentDate into #con from testexcel.dbo.Upload_excel_test                                      
where DocumentDate>=@fdate+' 00:00:00' and DocumentDate<=@tdate+' 23:59:59'                                      
*/                                  
                                  
/*select distinct clientcode=client_code,DocumentDate=document_date                                   
into #con                                   
from [196.1.115.169].esigner.dbo.History_Sent_Log                                  
where document_date>=@fdate+' 00:00:00' and document_date<=@tdate+' 23:59:59' and document_state='Bounced'                                     
*/                            
                            
select  distinct DocumentDate=convert(varchar(11),Bo_bounceDate),bo_email                            
into #cona                            
from [196.1.115.169\esigner2005].esigner.dbo.TBLBOUNCE_LOG_ALL                            
where Bo_bounceDate>=@fdate                            
and Bo_bounceDate<=@tdate+' 23:59:59'                            
                            
select  distinct varclientcode,varemail,varaltemail,DateDocumentDate=convert(varchar(11),DateDocumentDate)                             
into #send                            
from [196.1.115.169\esigner2005].esigner.dbo.tblDmatSentLog (nolock)                            
where varDocumentType='Contract Note'                            
and DateDocumentDate>=@fdate                            
and DateDocumentDate<=@tdate+' 23:59:59'                            
                            
select distinct clientcode=b.varclientcode,a.DocumentDate                             
into #con                            
from #cona a join                             
#send b                            
on a.bo_email=b.varemail                            
and DocumentDate=DateDocumentDate                            
                            
                                  
select clientcode into #ff from #con                                      
group by clientcode having count(clientcode)>=@nod                                      
                                      
insert into client_details_ConvertedToNonECN                                      
select party_code,email,repatriat_bank_ac_no,unmarkeddate=getdate() ,status=0,updatedby='system',updatedon=getdate()                                      
--into client_details_ConvertedToNonECN                                      
from AngelNseCM.msajag.dbo.client_details where party_code in                                    
(                                      
select clientcode from #ff                                      
)                         
                                      
insert into client_brok_details_ConvertedToNonECN            
select cl_code,exchange,segment,print_options,unmarkeddate=getdate()                                       
 --into client_brok_details_ConvertedToNonECN                                      
from AngelNseCM.msajag.dbo.client_brok_details where cl_code in                                      
(                                      
select clientcode from #ff                                      
)  
old concept                              
*/                        
/*===================Added By Rozina=========================*/                        
                    
/* Last concept  comment on 14 march by amit  
declare @currdate as datetime                  
set   @currdate=getdate()                  
                      
select  distinct DocumentDate=convert(varchar(11),Bo_bounceDate),bo_email                          
into #con_30                         
from [196.1.115.169\esigner2005].esigner.dbo.TBLBOUNCE_LOG_ALL                          
where Bo_bounceDate>=convert(varchar(11),@currdate-30)                        
and Bo_bounceDate<=convert(varchar(11),@currdate)+' 23:59:59'     
and bo_email<>''                         
                        
select  distinct varclientcode as clientcode,varemail,varaltemail,      
DateDocumentDate=convert(varchar(11),DateDocumentDate)                           
into #send_30                          
from [196.1.115.169\esigner2005].esigner.dbo.tblDmatSentLog with (nolock)                
where varDocumentType='Contract Note'                          
and DateDocumentDate>=convert(varchar(11),@currdate-30)                        
and DateDocumentDate<=convert(varchar(11),@currdate)+' 23:59:59'        
and varemail<>''                     
               
select distinct a.*,BounceDate=space(11),updatedon=convert(datetime,'jan 01 1900')                      
into #con                        
from #send_30 a                        
join                        
#con_30 b                        
on a.varemail=b.bo_email                        
                        
update #con set BounceDate=b.DocumentDate from #con_30 b where #con.varemail=b.bo_email and                         
#con.DateDocumentDate=b.DocumentDate                        
                      
select party_code,updatedon=max(updatedon) into #ww from client_details_ConvertedToNonECN group by party_code                      
              
update #con set updatedon=b.updatedon from #ww b where #con.clientcode=b.party_code                       
                      
--amit                      
--SELECT                                              
--RN = ROW_NUMBER()  OVER (PARTITION BY clientcode ORDER BY clientcode,convert(datetime,BounceDate)),                         
--    clientcode,BounceDate  into #ff_1                                            
--FROM #con  where BounceDate>=updatedon             
          
SELECT                                              
RN = ROW_NUMBER()  OVER (PARTITION BY clientcode ORDER BY clientcode,convert(datetime,BounceDate)),                         
    clientcode,BounceDate  into #ff_1                                            
FROM #con  where BounceDate>=updatedon and BounceDate<>''                     
                       
/*                      
drop table #ff1                      
select count(*) from #ff_11                      
select top 5 * from #qq                      
select distinct * from #ff                      
select * from #qq where clientcode='m710'                      
*/                       
                      
declare @mdt as varchar(11)                    
select  @mdt=max(convert(datetime,DateDocumentDate)) from #con                       
                    
--amit                      
--select * into #ff from #ff_1 where ((rn=1 and rn=2 and rn=3) and BounceDate<>'') and (BounceDate<>'' and rn>=3 )                            
--and convert(datetime,bouncedate)=@mdt             
          
select * into #ff from #ff_1 where  rn>=3                      
and convert(datetime,bouncedate)=@mdt                     
                          
select party_code,email,repatriat_bank_ac_no,unmarkeddate=@currdate ,status=0,updatedby='system',                      
updatedon=@currdate into #ff1                        
from AngelNseCM.msajag.dbo.client_details a with (nolock)  join #ff b                        
on a.party_code=b.clientcode                        
where  a.repatriat_bank_ac_no like 'ECN%'                         
              
insert into client_details_ConvertedToNonECN                                      
select * from #ff1               
                                      
insert into client_brok_details_ConvertedToNonECN                                      
select cl_code,exchange,segment,print_options,unmarkeddate=@currdate                                       
 --into client_brok_details_ConvertedToNonECN                                      
from AngelNseCM.msajag.dbo.client_brok_details a with (nolock)                        
join                        
#ff1 b                        
on a.cl_code=b.party_code */  
set nocount off  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ConvertToNonEcn_13102010
-- --------------------------------------------------
CREATE proc ConvertToNonEcn_13102010               
as             
/*  
DECLARE @STR AS VARCHAR(5000)            
SET @STR=''            
              
declare @fdate varchar(11),@tdate varchar(11),@nod int                
select @nod=nod from Nod_bounce_NECN (nolock)                
--set @fdate=getdate()-@nod                
--set @tdate=getdate()-1                
drop table temp__date            
            
SET @STR=@STR + 'select top '+CONVERT(VARCHAR(1),@NOD)+' SAUDA_DATE into temp__date from remisior.dbo.comb_co where'             
SET @STR=@STR + ' segment=''ABLCM'' and sauda_date<getdate()  order by sauda_date desc'            
EXEC(@STR)            
            
select @fdate=min(sauda_date) from  temp__date            
select @tdate=max(sauda_date) from  temp__date            
            
--print @nod                
--print @fdate                
--print @tdate                
                
/*select distinct clientcode,DocumentDate into #con from testexcel.dbo.Upload_excel_test                
where DocumentDate>=@fdate+' 00:00:00' and DocumentDate<=@tdate+' 23:59:59'                
*/            
            
/*select distinct clientcode=client_code,DocumentDate=document_date             
into #con             
from [196.1.115.169].esigner.dbo.History_Sent_Log            
where document_date>=@fdate+' 00:00:00' and document_date<=@tdate+' 23:59:59' and document_state='Bounced'               
*/      
      
select  distinct DocumentDate=convert(varchar(11),Bo_bounceDate),bo_email      
into #cona      
from [196.1.115.169\esigner2005].esigner.dbo.TBLBOUNCE_LOG_ALL      
where Bo_bounceDate>=@fdate      
and Bo_bounceDate<=@tdate+' 23:59:59'      
      
select  distinct varclientcode,varemail,varaltemail,DateDocumentDate=convert(varchar(11),DateDocumentDate)       
into #send      
from [196.1.115.169\esigner2005].esigner.dbo.tblDmatSentLog (nolock)      
where varDocumentType='Contract Note'      
and DateDocumentDate>=@fdate      
and DateDocumentDate<=@tdate+' 23:59:59'      
      
select distinct clientcode=b.varclientcode,a.DocumentDate       
into #con      
from #cona a join       
#send b      
on a.bo_email=b.varemail      
and DocumentDate=DateDocumentDate      
      
            
select clientcode into #ff from #con                
group by clientcode having count(clientcode)>=@nod                
                
insert into client_details_ConvertedToNonECN                
select party_code,email,repatriat_bank_ac_no,unmarkeddate=getdate() ,status=0,updatedby='system',updatedon=getdate()                
--into client_details_ConvertedToNonECN                
from anand1.msajag.dbo.client_details where party_code in                
(                
select clientcode from #ff                
)                
                
insert into client_brok_details_ConvertedToNonECN                
select cl_code,exchange,segment,print_options,unmarkeddate=getdate()                 
 --into client_brok_details_ConvertedToNonECN                
from anand1.msajag.dbo.client_brok_details where cl_code in                
(                
select clientcode from #ff                
)        
*/  
/*===================Added By Rozina=========================*/  
  
select  distinct DocumentDate=convert(varchar(11),Bo_bounceDate),bo_email    
into #con_30   
from [196.1.115.169\esigner2005].esigner.dbo.TBLBOUNCE_LOG_ALL    
where Bo_bounceDate>=convert(varchar(11),getdate()-30)  
and Bo_bounceDate<=convert(varchar(11),getdate())+' 23:59:59'    
  
select  distinct varclientcode as clientcode,varemail,varaltemail,DateDocumentDate=convert(varchar(11),DateDocumentDate)     
into #send_30    
from [196.1.115.169\esigner2005].esigner.dbo.tblDmatSentLog with (nolock)    
where varDocumentType='Contract Note'    
and DateDocumentDate>=convert(varchar(11),getdate()-30)  
and DateDocumentDate<=convert(varchar(11),getdate())+' 23:59:59'  
  
select distinct a.*,BounceDate=space(11)   
into #con  
from #send_30 a  
join  
#con_30 b  
on a.varemail=b.bo_email  
  
update #con set BounceDate=b.DocumentDate from #con_30 b where #con.varemail=b.bo_email and   
#con.DateDocumentDate=b.DocumentDate  
  
SELECT                        
RN = ROW_NUMBER()  OVER (PARTITION BY clientcode ORDER BY clientcode,convert(datetime,BounceDate) desc),       clientcode,BounceDate into #ff_1                      
FROM #con    
  
select * into #ff from #ff_1 where (rn in(1,2,3) and BounceDate<>'') and rn=3  
    
select party_code,email,repatriat_bank_ac_no,unmarkeddate=getdate() ,status=0,updatedby='system',updatedon=getdate() into #ff1  
from anand1.msajag.dbo.client_details a with (nolock)  join #ff b  
on a.party_code=b.clientcode  
where  a.repatriat_bank_ac_no like 'ECN%'   
  
  
insert into client_details_ConvertedToNonECN                
select * from #ff1                
                
insert into client_brok_details_ConvertedToNonECN                
select cl_code,exchange,segment,print_options,unmarkeddate=getdate()                 
 --into client_brok_details_ConvertedToNonECN                
from anand1.msajag.dbo.client_brok_details a with (nolock)  
join  
#ff1 b  
on a.cl_code=b.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_AMC_CHARGE
-- --------------------------------------------------
CREATE Proc DP_AMC_CHARGE(@access_to as varchar(10),@access_code as varchar(12))
as
Set transaction isolation level read uncommitted
select distinct Branch=branch_cd,[Sub Broker]=sub_broker,Name=client_name,[Kyc Code]=pcode,[DP ID]=CM_CD
,[Ledger Balance]=totbal,[DP Balance]=DpBal,[AMC Charge]=amc,[B2C/B2B]=typ
 from AMC_ON_Next(nolock)
order by branch,[Sub Broker]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_DebitBal
-- --------------------------------------------------
CREATE Proc DP_DebitBal(@access_to as varchar(10),@access_code as varchar(12))  
as  
Set transaction isolation level read uncommitted  
select distinct Branch=branch_cd,[Sub Broker]=sub_broker,Name=client_name,[Kyc Code]=pcode,[DP ID]=CM_CD  
,[Ledger Balance]=totbal,[DP Balance]=DpBal,[B2C/B2B]=typ  
 from temp_Debithold(nolock)  
order by branch,[Sub Broker]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DP_ZeroHold
-- --------------------------------------------------
CREATE Proc DP_ZeroHold(@access_to as varchar(10),@access_code as varchar(12))
as
Set transaction isolation level read uncommitted
select Branch=branch_cd,[Sub Broker]=sub_broker,Name=client_name,[Kyc Code]=pcode,[DP ID]=CM_CD
,[Last Transaction On]=substring(last_trans_date,7,2)+'/'+substring(last_trans_date,5,2)+'/'+substring(last_trans_date,1,4),[Ledger Balance]=totbal,[DP Balance]=DpBal,[B2C/B2B]=typ
 from temp_zerohold(nolock)
order by branch,[Sub Broker]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPH_new
-- --------------------------------------------------
CREATE procedure [dbo].[DPH_new]  
as  
  
set nocount on  
select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos   
into #dp  
from ABCSOORACLEMDLW.synergy.dbo.holding,  
ABCSOORACLEMDLW.synergy.dbo.client_master   
where cm_cd = hld_ac_code   
and cm_poaforpayin = 'Y'    
and hld_ac_type ='11' -- '11' for FreeHolding  
  
drop table Clt_dPH  
select *   
into CLT_DPH  
from #dp  
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPH_new31122012
-- --------------------------------------------------
CREATE procedure DPH_new31122012  
as  
  
set nocount on  
select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos   
into #dp  
from DpBackoffice.AcerCross.dbo.holding,  
DpBackoffice.AcerCross.dbo.client_master   
where cm_cd = hld_ac_code   
and cm_poaforpayin = 'Y'    
and hld_ac_type ='11' -- '11' for FreeHolding  
  
drop table Clt_dPH  
select *   
into CLT_DPH  
from #dp  
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPH1_new
-- --------------------------------------------------
CREATE procedure [dbo].[DPH1_new]          
as          
          
set nocount on          
select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos           
into #dp          
from ABCSOORACLEMDLW.synergy.dbo.holding,          
ABCSOORACLEMDLW.synergy.dbo.client_master           
where cm_cd = hld_ac_code           
--and cm_poaforpayin = 'Y'    
and cm_cd in (select DISTINCT CCH_CMCD from ABCSOORACLEMDLW.synergy.dbo.client_checklist where cch_check = 'D05')            
and hld_ac_type ='11' -- '11' for FreeHolding          
          
select *           
into #aa        
from #dp          
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  ---697        
        
select *         
into #bb        
from Tradeanywhere_master          
where client_code not in        
(select cm_blsavingcd from #aa)   ---384        
        
drop table dph_clt        
Select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos         
--into DPH_CLT        
from #aa        
--union        
--select client_code,'0','0',0 from #bb        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPH1_new_09012013
-- --------------------------------------------------
CREATE procedure DPH1_new_09012013          
as          
          
set nocount on          
select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos           
into #dp          
from DpBackoffice.AcerCross.dbo.holding,          
DpBackoffice.AcerCross.dbo.client_master           
where cm_cd = hld_ac_code           
--and cm_poaforpayin = 'Y'    
and cm_cd in (select DISTINCT CCH_CMCD from DpBackoffice.AcerCross.dbo.client_checklist where cch_check = 'D05')            
and hld_ac_type ='11' -- '11' for FreeHolding          
          
select *           
into #aa        
from #dp          
where cm_blsavingcd in (select client_Code from Tradeanywhere_master)  ---697        
        
select *         
into #bb        
from Tradeanywhere_master          
where client_code not in        
(select cm_blsavingcd from #aa)   ---384        
        
drop table dph_clt        
Select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos         
--into DPH_CLT        
from #aa        
--union        
--select client_code,'0','0',0 from #bb        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DPH2_new
-- --------------------------------------------------
CREATE procedure DPH2_new          
as          
          
set nocount on          
select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos=convert(int,hld_ac_pos)           
into #dp          
from DpBackoffice.AcerCross.dbo.holding,          
DpBackoffice.AcerCross.dbo.client_master           
where cm_cd = hld_ac_code           
--and cm_poaforpayin = 'Y'    
and cm_cd in (select DISTINCT CCH_CMCD from DpBackoffice.AcerCross.dbo.client_checklist where cch_check = 'D05')            
and hld_ac_type ='11' -- '11' for FreeHolding          
          
select *           
into #aa        
from #dp          
where cm_blsavingcd in (select client_Code from Tradeanywhere_master_newver)  ---697        
        
select *         
into #bb        
from Tradeanywhere_master_newver          
where client_code not in        
(select cm_blsavingcd from #aa)   ---384        
        
drop table dph_clt        
Select cm_blsavingcd,hld_ac_code,hld_isin_code,hld_ac_pos=convert(int,hld_ac_pos)         
into DPH_CLT        
from #aa        
--union        
--select client_code,'0','0',0 from #bb        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecn_nonecn_DETAILS
-- --------------------------------------------------
CREATE procedure ecn_nonecn_DETAILS (@fdate varchar(11),@tdate varchar(11),@flag varchar(3),@USER AS VARCHAR(11),@code AS VARCHAR(10))      
as      
set nocount on      
if @flag='A'      
begin      
---ecn      
 IF @USER='BROKER'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New'   
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end    
 IF @USER='BRANCH'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd= @code  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end   
 IF @USER='BRMAST'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end   
 IF @USER='REGION'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end  
IF @USER='RGMAST'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd IN 
(select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end
IF @USER='ZONE'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd IN 
(select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end      
IF @USER='ZNMAST'         
BEGIN     
select a.reg_no,b.branch_cd,b.sub_broker,party_code=a.client_code,b.short_name       
from ecn_reg   a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.client_code=b.party_code      
where reg_status='New' and b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)  
and Entered_ON>=@fdate+' 00:00:00'     
and Entered_ON<=@tdate+' 23:59:59'      
end   
end      
if @flag='B'      
begin      
---nonecn     
 IF @USER='BROKER'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'      
END  
 IF @USER='BRANCH'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  and b.branch_cd= @code    
END  
 IF @USER='BRMAST'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  and b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)  
END  
 IF @USER='REGION'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  and b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)  
END 
IF @USER='RGMAST'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  
and b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)  
END  
IF @USER='ZONE'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  
and b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)  
END
IF @USER='ZNMAST'         
BEGIN    
select reg_no=a.repatriat_bank_ac_no,b.branch_cd,b.sub_broker,a.party_code,b.short_name from      
client_details_ConvertedToNonECN a (nolock) left outer join intranet.risk.dbo.client_details b       
on a.party_code=b.party_code      
where  a.unmarkeddate>=@fdate+' 00:00:00' and a.unmarkeddate<=@tdate+' 23:59:59'  
and b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)  
END
end      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecn_nonecn_levelwise_report
-- --------------------------------------------------
CREATE procedure ecn_nonecn_levelwise_report (@FromDate varchar(25),@ToDate varchar(25),@USER AS VARCHAR(11),@code AS VARCHAR(10))          
as          
set nocount on           
select Entered_ON=convert(varchar(11),a.Entered_ON),Cnt=count(1)       
,b.branch_cd        
into #file1           
from ecn_reg a      
,intranet.risk.dbo.client_details b      
where reg_status='New'       
and a.client_code=b.party_code          
and entered_on>=@FromDate        
and entered_on<=@ToDate        
group by  convert(varchar(11),Entered_ON) ,    
b.branch_cd      
          
      
select unmarkeddate=convert(varchar(11),a.unmarkeddate),Ncnt=count(*) ,b.branch_cd      
into #file2           
from client_details_ConvertedToNonECN  a,intranet.risk.dbo.client_details b      
 where unmarkeddate>=@FromDate       
 and a.party_code=b.party_code       
and unmarkeddate<=@ToDate and a.repatriat_bank_ac_no<>''        
group by convert(varchar(11),unmarkeddate) ,b.branch_cd       
      
          
select date1=convert(datetime,isnull(a.Entered_ON,unmarkeddate)),      
cnt=isnull(a.cnt,'0'),ncnt=isnull(b.Ncnt,'0'),ecnbranch=a.branch_cd,nonbranch=b.branch_cd      
into #final      
from #file1 a  full outer join           
#file2 b on a.Entered_ON=b.unmarkeddate       
and b.branch_cd=a.branch_cd         
order by date1        
      
select date1,cnt,ncnt,branch=case when cnt=0 then nonbranch else ecnbranch end INTO #FINAL1 from #final       
      
      
      
IF @USER='BRANCH'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch=@code  GROUP BY DATE1     
END      
      
IF @USER='BRMAST'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code) GROUP BY DATE1        
END      
      
      
      
IF @USER='REGION'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code) GROUP BY DATE1        
END      
      
 IF @USER='RGMAST'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code) GROUP BY DATE1        
END  
      
 IF @USER='ZONE'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code) GROUP BY DATE1        
END 
      
 IF @USER='ZNMAST'       
BEGIN      
SELECT date1,cnt=SUM(CNT),ncnt=SUM(ncnt) FROM #FINAL1 WHERE branch IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code) GROUP BY DATE1        
END       
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecn_nonecn_report
-- --------------------------------------------------
CREATE procedure ecn_nonecn_report (@FromDate varchar(25),@ToDate varchar(25))  
as  
set nocount on  
  
select Entered_ON=convert(varchar(11),Entered_ON),Cnt=count(1) 
 into #file1   
from ecn_reg where reg_status='New'   
and entered_on>=@Fromdate
and entered_on<=@Todate
group by   convert(varchar(11),Entered_ON)
  
select unmarkeddate=convert(varchar(11),unmarkeddate),Ncnt=count(*) into #file2   
from client_details_ConvertedToNonECN   where unmarkeddate>=@Fromdate
and unmarkeddate<=@Todate and repatriat_bank_ac_no<>''
group by convert(varchar(11),unmarkeddate)
  
select date1=convert(datetime,isnull(a.Entered_ON,unmarkeddate)),cnt=isnull(a.cnt,'0'),ncnt=isnull(b.Ncnt,'0') from #file1 a full outer join   
#file2 b on a.Entered_ON=b.unmarkeddate   
order by date1
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecnbranch_pa
-- --------------------------------------------------
CREATE procedure  ecnbranch_pa (@FromDate varchar(11),@ToDate varchar(11))              
as              
set nocount on             
           
select distinct type='Pending',count1=ISNULL(sum(case when status='NO'                   
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch (NOLOCK)      
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                      
union all            
select distinct type='Approved',count1=ISNULL(sum(case when status='YES'                   
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch (NOLOCK)      
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' 
union all            
select distinct type='Rejected',count1=ISNULL(sum(case when status='REJECTED'                   
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch (NOLOCK)      
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'     
      
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecnbranch_pa1
-- --------------------------------------------------
CREATE procedure  DBO.ecnbranch_pa1 (@FromDate varchar(11),@ToDate varchar(11),@USER AS VARCHAR(11),@code AS VARCHAR(10))                        
as                        
set nocount on                       
IF @USER='BROKER'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'           
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'          
END        
        
IF @USER='BRANCH'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch a (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                 
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code            
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code          
END        
             
IF @USER='BRMAST'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                    
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)     
END           
        
IF @USER='REGION'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)          
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)         
END   
IF @USER='SB'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch a (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                 
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.SUB_BROKER=@code                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.SUB_BROKER=@code            
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.SUB_BROKER=@code          
END        
             
IF @USER='SBMAST'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND b.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)                    
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)                   
END  
IF @USER='RGMAST'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)          
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)         
END  
IF @USER='ZONE'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)          
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)         
END 
IF @USER='ZNMAST'               
BEGIN                      
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                             
 then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)                               
union all                      
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch  A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code                
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)          
union all                      
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                             
and reg_status='New' then 1 else 0 end),0)  from ecn_reg_branch   A (nolock)        
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code               
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  
b.branch_cd IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)         
END                                
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ECNbranch_Report_time
-- --------------------------------------------------
CREATE procedure  ECNbranch_Report_time (@type varchar(25),@FromDate varchar(11),@ToDate varchar(11))            
as            
set nocount on   
if @type='Approved'  
begin  
select * from ecn_reg_branch where  status='YES'                 
and reg_status='New' and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'     
end  
if @type='Pending'  
begin  
select * from ecn_reg_branch where  status='NO'                 
and reg_status='New' and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'     
end  
if @type='Rejected'  
begin  
select * from ecn_reg_branch where  status='REJECTED'                 
and reg_status='New' and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'     
end
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ECNbranch_Report_time1
-- --------------------------------------------------
CREATE procedure  [dbo].[ECNbranch_Report_time1] (@type varchar(25),@FromDate varchar(11),@ToDate varchar(11),@USER AS VARCHAR(11),@code AS VARCHAR(10))                                    
as                                    
set nocount on                       
                       
if @USER='BROKER'                       
BEGIN                       
if @type='Approved'                          
begin                          
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE         
                            
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK)  JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  a.status='NO'                                         
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select distinct  a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                 
  
    
     
ON A.CLIENT_CODE=B.PARTY_CODE  join Reject_Remark c (nolock) on a.client_code=c.party_code where  a.status='REJECTED'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' and c.reason not like 'MISTAKE FOR OUR END%'                             
end                      
END                      
                       
if @USER='BRANCH'                       
BEGIN                       
if @type='Approved'                          
begin                            
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@CODE  ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE         
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD=@CODE                                            
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD=@CODE                                            
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' and c.reason not like 'MISTAKE FOR OUR END%'                             
end                      
END                       
             
if @USER='BRMAST'                       
BEGIN                       
if @type='Approved'                          
begin                       
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)     ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                             
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                                                  
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                      
end                          
if @type='Rejected'                          
begin                          
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code) and c.reason not like 'MISTAKE FOR OUR E
ND%'                                           
    
     
                   
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'                             
end                      
END                       
                      
if @USER='REGION'                       
BEGIN                       
if @type='Approved'                          
begin                         
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code) ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                            
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                                           
and  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select distinct a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                  
  
    
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                                    
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  and c.reason not like 'MISTAKE FOR OUR END%'                            
end     
END       
      
if @USER='SB'                  
BEGIN                       
if @type='Approved'                          
begin                            
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' AND B.SUB_BROKER=@CODE  ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE         
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.SUB_BROKER=@CODE                                            
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.SUB_BROKER=@CODE                                            
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' and c.reason not like 'MISTAKE FOR OUR END%'                             
end                      
END                       
                      
if @USER='SBMAST'                       
BEGIN                       
if @type='Approved'                          
begin                       
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'AND B.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)     ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                             
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)                                                  
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                      
end                          
if @type='Rejected'                          
begin                          
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.SUB_BROKER IN (SELECT SUB_BROKER FROM intranet.risk.dbo.sb_master WHERE sbmast_cd=@code)             
                   
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' and c.reason not like 'MISTAKE FOR OUR END%'                             
end                      
END   

if @USER='RGMAST'                       
BEGIN                       
if @type='Approved'                          
begin                         
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' 
AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code) ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                            
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND 
B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)                                           
and  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select distinct a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                  
  
    
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  
A.status='REJECTED'  AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_region_group_branches where RGMAST_CODE=@code)                                    
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  
and c.reason not like 'MISTAKE FOR OUR END%'                            
end     
END     
if @USER='ZONE'                       
BEGIN                       
if @type='Approved'                          
begin                         
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' 
AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code) ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                            
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND 
B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)                                           
and  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select distinct a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                  
  
    
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  
A.status='REJECTED'  AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_CODE=@code)                                    
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  
and c.reason not like 'MISTAKE FOR OUR END%'                            
end     
END        

if @USER='ZNMAST'                       
BEGIN                       
if @type='Approved'                          
begin                         
select a.*,reg1=convert(datetime,c.reg_date,103) from        
(select a.*,b.branch_cd,b.repatriat_bank_ac_no--,reg1=convert(datetime,c.reg_date,103)         
from ecn_reg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                         
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' 
AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code) ) a         
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                            
end                          
if @type='Pending'                          
begin                          
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_reg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                      
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND 
B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)                                           
and  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                             
end                          
if @type='Rejected'                          
begin                          
select distinct a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_reg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                  
  
    
ON A.CLIENT_CODE=B.PARTY_CODE join Reject_Remark c (nolock) on a.client_code=c.party_code where  
A.status='REJECTED'  AND B.BRANCH_CD  IN (select BRANCH_CODE from risk.dbo.vw_zone_group_branches where ZONE_MAST_CODE=@code)                                    
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  
and c.reason not like 'MISTAKE FOR OUR END%'                            
end     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ecndeact_pa1
-- --------------------------------------------------
CREATE procedure  ecndeact_pa1 (@FromDate varchar(11),@ToDate varchar(11),@USER AS VARCHAR(11),@code AS VARCHAR(10))                    
as                    
set nocount on                   
IF @USER='BROKER'           
BEGIN                  
select distinct type='Pending',count1=ISNULL(sum(case when status='NO'                         
 then 1 else 0 end),0)  from ecn_Dreg_branch            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                           
union all                  
select distinct type='Approved',count1=ISNULL(sum(case when status='YES'                         
and reg_status=1 then 1 else 0 end),0)  from ecn_Dreg_branch            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'       
union all                  
select distinct type='Rejected',count1=ISNULL(sum(case when status='REJECTED'                         
and reg_status='New' then 1 else 0 end),0)  from ecn_Dreg_branch            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'      
END    
    
IF @USER='BRANCH'           
BEGIN                  
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                         
 then 1 else 0 end),0)  from ecn_Dreg_branch a (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code             
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code                           
union all                  
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                         
and reg_status=1 then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code        
union all                  
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                         
and reg_status='New' then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@code      
END    
         
IF @USER='BRMAST'           
BEGIN                  
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                         
 then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                           
union all                  
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                         
and reg_status=1 then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                
union all                  
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                         
and reg_status='New' then 1 else 0 end),0)  from ecn_Dreg_branch   A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code           
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  AND b.branch_cd IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)               
END       
    
IF @USER='REGION'           
BEGIN                  
select distinct type='Pending',count1=ISNULL(sum(case when a.status='NO'                         
 then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00' and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                           
union all                  
select distinct type='Approved',count1=ISNULL(sum(case when a.status='YES'                         
and reg_status=1 then 1 else 0 end),0)  from ecn_Dreg_branch  A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code            
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)      
union all                  
select distinct type='Rejected',count1=ISNULL(sum(case when a.status='REJECTED'                         
and reg_status='New' then 1 else 0 end),0)  from ecn_Dreg_branch   A (nolock)    
LEFT OUTER JOIN intranet.risk.dbo.client_details b ON a.client_code=b.party_code           
where  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'  and  b.branch_cd IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)     
END         
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ECNDEACT_Report_time1
-- --------------------------------------------------
CREATE procedure  [dbo].[ECNDEACT_Report_time1] (@type varchar(25),@FromDate varchar(11),@ToDate varchar(11),@USER AS VARCHAR(11),@code AS VARCHAR(10))                              
as                              
set nocount on                 
                 
if @USER='BROKER'                 
BEGIN                 
if @type='Approved'                    
begin                    
select a.*,reg1=convert(datetime,c.reg_date,103) from  
(select a.*,b.branch_cd,repatriat_bank_ac_no=a.ecnno--,reg1=convert(datetime,c.reg_date,103)   
from ecn_Dreg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                   
and a.REG_STATUS=1 and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'  ) a   
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE   
                      
end                    
if @type='Pending'                    
begin                    
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_Dreg_branch A (NOLOCK)  JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE  where  a.status='NO'                                   
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                       
end                    
if @type='Rejected'                    
begin                    
select distinct  a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_Dreg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE  join rejected_Decn c (nolock) on a.client_code=c.party_code where  a.status='REJECTED'                                   
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'                        
end                
END                
                 
if @USER='BRANCH'                 
BEGIN                 
if @type='Approved'                    
begin                      
select a.*,reg1=convert(datetime,c.reg_date,103) from  
(select a.*,b.branch_cd,repatriat_bank_ac_no=a.ecnno--,reg1=convert(datetime,c.reg_date,103)   
from ecn_Dreg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                   
and a.REG_STATUS=1 and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD=@CODE  ) a   
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE   
end                    
if @type='Pending'                    
begin                    
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_Dreg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD=@CODE                                      
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                       
end                    
if @type='Rejected'                    
begin                    
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_Dreg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE join rejected_Decn c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD=@CODE                                      
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'                       
end                
END                 
                
if @USER='BRMAST'                 
BEGIN                 
if @type='Approved'                    
begin                 
select a.*,reg1=convert(datetime,c.reg_date,103) from  
(select a.*,b.branch_cd,repatriat_bank_ac_no=a.ecnno--,reg1=convert(datetime,c.reg_date,103)   
from ecn_Dreg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                   
and a.REG_STATUS=1 and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)     ) a   
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                       
end                    
if @type='Pending'                    
begin                    
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_Dreg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                                            
 and reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                
end                    
if @type='Rejected'                    
begin                    
select a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_Dreg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE join rejected_Decn c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD IN (SELECT BRANCH_CD FROM intranet.risk.dbo.BRANCH_MASTER WHERE BRMAST_cD=@code)                                        
             
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'                       
end                
END                 
                
if @USER='REGION'                 
BEGIN                 
if @type='Approved'                    
begin                   
select a.*,reg1=convert(datetime,c.reg_date,103) from  
(select a.*,b.branch_cd,repatriat_bank_ac_no=a.ecnno--,reg1=convert(datetime,c.reg_date,103)   
from ecn_Dreg_branch A (NOLOCK) JOIN AngelNseCM.msajag.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE where  a.status='YES'                                   
and a.REG_STATUS=1 and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00' AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code) ) a   
 join (select distinct client_code,reg_date from ecn_reg (nolock) ) c on  A.CLIENT_CODE=c.CLIENT_CODE                      
end                    
if @type='Pending'                    
begin                    
select *,tatdate=datediff(day,reg_date,getdate()) from ecn_Dreg_branch A (NOLOCK) JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE  where  A.status='NO'  AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                                     
and  reg_date >=@FromDate+' 00:00:000' and reg_date <=@ToDate+' 23:59:00'                       
end                    
if @type='Rejected'                    
begin                    
select distinct a.access_code,a.reg_date,b.branch_cd,a.client_code,a.name,a.reg_status,a.status,a.mail_id,a.tel_no,reason=isnull(c.reason,'-'),a.entered_on from ecn_Dreg_branch A (NOLOCK) LEFT OUTER JOIN intranet.risk.dbo.client_details b                
ON A.CLIENT_CODE=B.PARTY_CODE join rejected_Decn c (nolock) on a.client_code=c.party_code where  A.status='REJECTED'  AND B.BRANCH_CD  IN (SELECT CODE FROM intranet.risk.dbo.REGION WHERE REG_CODE=@code)                              
and a.REG_STATUS='New' and a.reg_date >=@FromDate+' 00:00:000' and a.reg_date <=@ToDate+' 23:59:00'                       
end                
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.filter_ecn
-- --------------------------------------------------
CREATE proc [dbo].[filter_ecn] (@code as varchar(30),@access as varchar(30),@party_code as varchar(30),@fdate as varchar(25),@tdate as varchar(25))                      
as                      
set nocount on                      
if @access='BROKER'                      
BEGIN              
select distinct A.REF_nO,entered_on=convert(varchar(25),A.entered_on),a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'                    
--and a.client_code=@party_code                      
END                      
IF @access='BRANCH'                       
begin             
select distinct A.REF_nO,entered_on=convert(varchar(25),A.entered_on),a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code            
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'                     
  and c.branch_cd=@code --and a.client_code=@party_code                      
end                      
IF @access='BRMAST'                       
begin                      
select distinct A.REF_nO,A.entered_on,a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code                   
join intranet.risk.dbo.branch_master d on c.branch_cd=d.branch_cd                       
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'            
and d.brmast_cd=@code-- and a.client_code=@party_code                      
end                   
IF @access='REGION'                       
begin                      
select distinct A.REF_nO,A.entered_on,a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code             
join intranet.risk.dbo.region d on c.branch_cd=d.code                
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'            
and  d.reg_code=@code --and a.client_code=@party_code                      
end        
IF @access='RGMAST'                       
begin                      
select distinct A.REF_nO,A.entered_on,a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code             
join intranet.risk.dbo.region d on c.branch_cd=d.code JOIN intranet.risk.dbo.region_master E ON D.reg_code=E.region_cd               
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'            
and  E.rgmast_cd=@code --and a.client_code=@party_code                      
end                      
IF @access='SBMAST'                       
begin                      
select distinct A.REF_nO,A.entered_on,a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code            
 join intranet.risk.dbo.sb_master d  on c.sub_broker=d.sub_broker    
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'            
and  d.sbmast_cd=@code --and a.client_code=@party_code                      
end                      
IF @access='SB'                     
begin                      
select distinct A.REF_nO,A.entered_on,a.client_code,a.name,b.reg_date             
from ecn_reg_branch a join (select * from ecn_reg(nolock) where flag=1) b on a.client_code=b.client_code             
left outer join  AngelNseCM.msajag.dbo.client_details c on a.client_code=c.party_code            
where isnull(a.ref_no,'')<>''             
and a.entered_on>=convert(datetime,@fdate,103)             
and a.entered_on<=convert(datetime,@tdate,103)+ ' 23:59:59'            
and  c.sub_broker=@code --and a.client_code=@party_code                      
end                      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FNO_LEDGER
-- --------------------------------------------------
CREATE procedure FNO_LEDGER  
as        
set nocount on        
      
  
select party_code,Inst_type,Symbol,        
date1=REPLACE(convert(varchar(11),Expirydate,113),' ','-'),        
Stkprice=rtrim(ltrim(str(Strike_price,10,2))),Opttype=Option_type,        
case       
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))='FUT' then         
LTRIM(RTRIM(str(sum(pqty-sqty),10)))+'|0'+'|'+LTRIM(RTRIM(str(sum((cmclosing*pqty)-(cmclosing*sqty)),18,2)))+'|0.00'         
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))='FUT'         
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|0.00|'+ LTRIM(RTRIM(str(abs(sum((cmclosing*pqty)-(cmclosing*sqty))),18,2)))         
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))<>'FUT'         
then LTRIM(RTRIM(str(sum(pqty-sqty),10)))+ '|0'+'|'+LTRIM(RTRIM(str(sum((prate*pqty)-(srate*sqty)),18,2)))+'|0.00'         
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))<>'FUT'         
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10)))+'|0.00|'+ LTRIM(RTRIM(str(abs(sum((prate*pqty)-(srate*sqty))),18,2)))   
end as [Buy Qty|Sell Qty|Buy Amount|Sell Amount]        
into #FNO        
from ANGELFO.NSEFO.DBO.fobillvalan A, TRADEANYWHERE_MASTER B WHERE A.PARTY_CODE=B.CLIENT_CODE and       
sauda_date in (select max(sauda_date) from ANGELFO.NSEFO.DBO.fobillvalan)      
--sauda_date ='Dec 16 2005 23:59:00'         
group by party_code,inst_type,symbol,expirydate,Strike_price,Option_type         
having sum(pqty-sqty) <> 0        
      
      
select *        
into #aa      
from #FNO       
where party_code in (select client_Code from Tradeanywhere_master)  ---83      
      
select *       
into #bb      
from Tradeanywhere_master        
where client_code not in      
(select party_code from #aa)   ---387      
      
drop table FNO_CLT      
Select Party_code,Trading_Account='MAR',Inst_type,Symbol,date1,Stkprice,Opttype,[Buy Qty|Sell Qty|Buy Amount|Sell Amount]      
--into FNO_CLT      
from #aa      
union      
select Client_code,'MAR','0','0','0','0','0','0' from #bb      
        
--drop table clt_fno         
--select * from clt_fno         
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FNO_LEDGER2
-- --------------------------------------------------
CREATE procedure FNO_LEDGER2  
as        
set nocount on        
      
  
select party_code,Inst_type,Symbol,        
date1=REPLACE(convert(varchar(11),Expirydate,113),' ','-'),        
Stkprice=rtrim(ltrim(str(Strike_price,10,2))),Opttype=Option_type,        
case       
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))='FUT' then         
LTRIM(RTRIM(str(sum(pqty-sqty),10)))+'|0'+'|'+LTRIM(RTRIM(str(sum((cmclosing*pqty)-(cmclosing*sqty)),18,2)))+'|0.00'         
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))='FUT'         
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|0.00|'+ LTRIM(RTRIM(str(abs(sum((cmclosing*pqty)-(cmclosing*sqty))),18,2)))         
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))<>'FUT'         
then LTRIM(RTRIM(str(sum(pqty-sqty),10)))+ '|0'+'|'+LTRIM(RTRIM(str(sum((prate*pqty)-(srate*sqty)),18,2)))+'|0.00'         
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))<>'FUT'         
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10)))+'|0.00|'+ LTRIM(RTRIM(str(abs(sum((prate*pqty)-(srate*sqty))),18,2)))   
end as [Buy Qty|Sell Qty|Buy Amount|Sell Amount]        
into #FNO        
from ANGELFO.NSEFO.DBO.fobillvalan A, TRADEANYWHERE_MASTER_newver B WHERE A.PARTY_CODE=B.CLIENT_CODE and       
sauda_date in (select max(sauda_date) from ANGELFO.NSEFO.DBO.fobillvalan)      
--sauda_date ='Dec 16 2005 23:59:00'         
group by party_code,inst_type,symbol,expirydate,Strike_price,Option_type         
having sum(pqty-sqty) <> 0        
      
      
select *        
into #aa      
from #FNO       
where party_code in (select client_Code from Tradeanywhere_master_newver)  ---83      
      
select *       
into #bb      
from Tradeanywhere_master_newver        
where client_code not in      
(select party_code from #aa)   ---387      
      
drop table FNO_CLT      
Select Party_code,Trading_Account='MAR',Inst_type,Symbol,date1,Stkprice,Opttype,[Buy Qty|Sell Qty|Buy Amount|Sell Amount]      
into FNO_CLT      
from #aa      
union      
select Client_code,'MAR','0','0','0','0','0','0' from #bb      
        
--drop table clt_fno         
--select * from clt_fno         
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FNO_new
-- --------------------------------------------------
CREATE procedure FNO_new
as
set nocount on

select party_code,Inst_type,Symbol,
date1=REPLACE(convert(varchar(11),Expirydate,113),' ','-'),
Stkprice=rtrim(ltrim(str(Strike_price,10,2))),Opttype=Option_type,
case when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))='FUT' then 
LTRIM(RTRIM(str(sum(pqty-sqty),10))) +'|'+LTRIM(RTRIM(str(sum((cmclosing*pqty)-(cmclosing*sqty)),18,2)))+'|0|0.00' 
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))='FUT' 
then '0|0.00|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|'+ LTRIM(RTRIM(str(abs(sum((cmclosing*pqty)-(cmclosing*sqty))),18,2))) 
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))<>'FUT' 
then LTRIM(RTRIM(str(sum(pqty-sqty),10))) +'|'+LTRIM(RTRIM(str(sum((prate*pqty)-(srate*sqty)),18,2)))+'|0|0.00' 
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))<>'FUT' 
then '0|0.00|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|'+ LTRIM(RTRIM(str(abs(sum((prate*pqty)-(srate*sqty))),18,2))) 
end as [Buy Qty|Sell Qty|Buy Amount|Sell Amount]
into #FNO
from ANGELFO.NSEFO.DBO.fobillvalan A, intranet.mis.dbo.odinuserinfo B, intranet.mis.dbo.odindealer c 
WHERE b.tag=c.brcd and A.PARTY_cODE=B.PCODE and sauda_date ='Dec 16 2005 23:59:00' 
group by party_code,b.tag,inst_type,symbol,expirydate,Strike_price,Option_type,c.dealercd 
having sum(pqty-sqty) <> 0

--drop table #fno1
--drop table #bb
select * into #bb  
from tradeanywhere_master   
where client_code not in  
(select party_code from #fno ) ---387

--select * from #bb  
--select * from #fno1  
drop table clt_fno 
select Party_code,Inst_type,Symbol,date1,Stkprice,Opttype,[Buy Qty|Sell Qty|Buy Amount|Sell Amount] 
into clt_fno 
from #fno
union
select Client_code,'0','0','0','0','0','0' from #bb

--drop table clt_fno 
--select * from clt_fno 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FNO1_new
-- --------------------------------------------------
CREATE procedure FNO1_new
as      
set nocount on      
    
select party_code,Inst_type,Symbol,      
date1=REPLACE(convert(varchar(11),Expirydate,113),' ','-'),      
Stkprice=rtrim(ltrim(str(Strike_price,10,2))),Opttype=Option_type,      
case     
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))='FUT' then       
LTRIM(RTRIM(str(sum(pqty-sqty),10)))+'|0'+'|'+LTRIM(RTRIM(str(sum((cmclosing*pqty)-(cmclosing*sqty)),18,2)))+'|0.00'       
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))='FUT'       
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|0.00|'+ LTRIM(RTRIM(str(abs(sum((cmclosing*pqty)-(cmclosing*sqty))),18,2)))       
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))<>'FUT'       
then LTRIM(RTRIM(str(sum(pqty-sqty),10)))+ '|0'+'|'+LTRIM(RTRIM(str(sum((prate*pqty)-(srate*sqty)),18,2)))+'|0.00'       
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))<>'FUT'       
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10)))+'|0.00|'+ LTRIM(RTRIM(str(abs(sum((prate*pqty)-(srate*sqty))),18,2))) 
end as [Buy Qty|Sell Qty|Buy Amount|Sell Amount]      
into #FNO      
from ANGELFO.NSEFO.DBO.fobillvalan A, intranet.mis.dbo.odinuserinfo B, intranet.mis.dbo.odindealer c       
WHERE b.tag=c.brcd and A.PARTY_cODE=B.PCODE and     
sauda_date in (select max(sauda_date) from ANGELFO.NSEFO.DBO.fobillvalan)    
--sauda_date ='Dec 16 2005 23:59:00'       
group by party_code,b.tag,inst_type,symbol,expirydate,Strike_price,Option_type,c.dealercd       
having sum(pqty-sqty) <> 0      
    
    
select *      
into #aa    
from #FNO     
where party_code in (select client_Code from Tradeanywhere_master)  ---83    
    
select *     
into #bb    
from Tradeanywhere_master      
where client_code not in    
(select party_code from #aa)   ---387    
    
drop table FNO_CLT    
Select Party_code,Trading_Account='MAR',Inst_type,Symbol,date1,Stkprice,Opttype,[Buy Qty|Sell Qty|Buy Amount|Sell Amount]    
into FNO_CLT    
from #aa    
union    
select Client_code,'MAR','0','0','0','0','0','0' from #bb    
      
--drop table clt_fno       
--select * from clt_fno       
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FNO1_new_a
-- --------------------------------------------------
CREATE procedure FNO1_new_a
as      
set nocount on      
    
select party_code,Inst_type,Symbol,      
date1=REPLACE(convert(varchar(11),Expirydate,113),' ','-'),      
Stkprice=rtrim(ltrim(str(Strike_price,10,2))),Opttype=Option_type,      
case     
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))='FUT' then       
LTRIM(RTRIM(str(sum(pqty-sqty),10)))+'|0'+'|'+LTRIM(RTRIM(str(sum((cmclosing*pqty)-(cmclosing*sqty)),18,2)))+'|0.00'       
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))='FUT'       
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10))) +'|0.00|'+ LTRIM(RTRIM(str(abs(sum((cmclosing*pqty)-(cmclosing*sqty))),18,2)))       
when sum(pqty-sqty) > 0 and upper(substring(inst_type,1,2))<>'FUT'       
then LTRIM(RTRIM(str(sum(pqty-sqty),10)))+ '|0'+'|'+LTRIM(RTRIM(str(sum((prate*pqty)-(srate*sqty)),18,2)))+'|0.00'       
when sum(pqty-sqty) <= 0 and upper(substring(inst_type,1,2))<>'FUT'       
then '0|'+LTRIM(RTRIM(str(abs(sum(pqty-sqty)),10)))+'|0.00|'+ LTRIM(RTRIM(str(abs(sum((prate*pqty)-(srate*sqty))),18,2))) 
end as [Buy Qty|Sell Qty|Buy Amount|Sell Amount]      
into #FNO      
from ANGELFO.NSEFO.DBO.fobillvalan A, intranet.mis.dbo.odinuserinfo B, intranet.mis.dbo.odindealer c       
WHERE b.tag=c.brcd and A.PARTY_cODE=B.PCODE and     
sauda_date in (select max(sauda_date) from ANGELFO.NSEFO.DBO.fobillvalan)    
--sauda_date ='Dec 16 2005 23:59:00'       
group by party_code,b.tag,inst_type,symbol,expirydate,Strike_price,Option_type,c.dealercd       
having sum(pqty-sqty) <> 0      
    
    
select *      
into #aa    
from #FNO     
where party_code in (select client_Code from Tradeanywhere_master)  ---83    
    
select *     
into #bb    
from Tradeanywhere_master      
where client_code not in    
(select party_code from #aa)   ---387    
    
drop table FNO_CLT    
Select Party_code,Trading_Account='MAR',Inst_type,Symbol,date1,Stkprice,Opttype,[Buy Qty|Sell Qty|Buy Amount|Sell Amount]    
into FNO_CLT    
from #aa    
union    
select Client_code,'MAR','0','0','0','0','0','0' from #bb    
      
--drop table clt_fno       
--select * from clt_fno       
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetEcnLastNo
-- --------------------------------------------------
CREATE procedure GetEcnLastNo
as
declare @ecnno  int
select @ecnno=max(ecnno) from getecnno 
--print @ecnno
insert into GetEcnNO select @ecnno+1
select ecnno=@ecnno+1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Getsb_bday
-- --------------------------------------------------
CREATE procedure Getsb_bday  
as  
declare @sbreg  int  
select @sbreg=max(sbreg) from getsbbday
--print @ecnno  
insert into getsbbday select @sbreg+1  
select sbreg=@sbreg+1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Last7DAys_bounce_QA
-- --------------------------------------------------
Create Procedure Last7DAys_bounce_QA(@Access_to as varchar(8),@Access_code as varchar(8))
as
declare @tdate as varchar(11),@tdate1 as varchar(11),@tdate2 as varchar(11)                        
select @tdate=max(sauda_date) from remisior.dbo.comb_co                      
select @tdate1=max(sauda_date)-7 from remisior.dbo.comb_co
select @tdate2=max(sauda_date)-1 from remisior.dbo.comb_co
                      
select distinct client_code,client_name,client_email,DocumentDate=document_date                           
into #con2                           
from [196.1.115.169].esigner.dbo.History_Sent_Log                          
where document_date>=convert(varchar(11),@tdate)+' 00:00:00'                       
and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'                          


select distinct client_code,client_name,client_email,DocumentDate=document_date                           
into #con3                           
from [196.1.115.169].esigner.dbo.History_Sent_Log                          
where document_date>=convert(varchar(11),@tdate1)+' 00:00:00'                       
and document_date<=convert(varchar(11),@tdate2)+' 23:59:59' and document_state='Bounced'  

   
delete from #con2 where client_code in (select Client_code from #con3)             

--select * from Temp_ECNBounce_MAIL_BR                
select branch_cd,sub_broker,client_code,client_name,client_email, mobile_pager,res_phone=res_phone1                  
from #con2 a                      
left outer join                      
(select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details) b             on a.client_code=b.party_code                      
order by branch_cd,sub_broker,client_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Ledger_new
-- --------------------------------------------------

CREATE procedure [dbo].[Ledger_new](@segment as varchar(11))
as
set nocount on
--declare @segment as varchar(11)
--set @segment='ABLCM'
--print @segment

declare @acdate as varchar(25)  
select @acdate='Apr 1 '+ (case when substring(CONVERT(VARCHAR(11),GETDATE()),1,3) in ('Jan','Feb','Mar')     
then convert(varchar(4),substring(CONVERT(VARCHAR(11),GETDATE()),8,4)-1) else convert(varchar(4),substring(CONVERT(VARCHAR(11),GETDATE()),8,4)) end)+' 00:00:00'    
--PRINT @ACDATE

if @segment='ABLCM'
begin 	
	SELECT CLTCODE, Segment=@segment,Amount=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)
	FROM AngelBSECM.ACCOUNT_aB.DBO.LEDGER 
	WHERE (cltcode like '27%' or cltcode = '02015' or cltcode like '03%')
	AND VDT>=@ACDATE AND VDT <= GETDATE() GROUP BY CLTCODE
end

if @segment='ACDLCM'
begin 	
	SELECT CLTCODE, Segment=@segment,Amount=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)
	FROM AngelNseCM.inhouse.dbo.LEDGER 
	WHERE (cltcode like '27%' or cltcode = '02015' or cltcode like '03%')
	AND VDT>=@ACDATE AND VDT <= GETDATE() GROUP BY CLTCODE
end

if @segment='ACDLFO'
begin 	
	SELECT CLTCODE, Segment=@segment,Amount=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)
	FROM angelfo.inhouse.dbo.LEDGER 
	WHERE (cltcode like '27%' or cltcode = '02015' or cltcode like '03%')
	AND VDT>=@ACDATE AND VDT <= GETDATE() GROUP BY CLTCODE
end

if @segment='MCDX'
begin 	

	SELECT CLTCODE, Segment='MCDX',Amount=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)
	FROM angelcommodity.accountmcdx.dbo.LEDGER 
	WHERE (cltcode like '27%' or cltcode = '02015' or cltcode like '03%')
	AND VDT>=@ACDATE AND VDT <= GETDATE() GROUP BY CLTCODE
end

if @segment='NCDX'
begin 	
	SELECT CLTCODE, Segment=@segment,Amount=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)
	FROM angelcommodity.accountncdx.dbo.LEDGER 
	WHERE (cltcode like '27%' or cltcode = '02015' or cltcode like '03%')
	AND VDT>=@ACDATE AND VDT <= GETDATE() GROUP BY CLTCODE
end

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NOL_1
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[NOL_1](@NOL AS INT,@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))  
AS  
  
SET NOCOUNT ON  
  
SELECT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,NOL=COUNT(DISTINCT LOCATION)  
 FROM (  

SELECT DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID  FROM BSEDB_aB.DBO.MIS_TO WHERE COMPANY='ABLCM' 
--SELECT  DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID FROM AngelBSECM.BSEDB_aB.DBO.CMBILLVALAN   
AND SAUDA_dATE >=@FDATE+' 00:00:00' AND SAUDA_DATE <=@TDATE+' 23:59:59'  

)A LEFT OUTER JOIN  
(SELECT BOLT_NO,LOCATION FROM BOLT_MASTER WHERE SEGMENT='ABLCM') B   
ON A.TERMINAL_ID=B.BOLT_NO   
GROUP BY BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME  
HAVING COUNT(DISTINCT LOCATION) > @NOL  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NOL_1a
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[NOL_1a](@coname as varchar(10),@NOL AS INT,@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))  
AS  
  
SET NOCOUNT ON  
  
SELECT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,NOL=COUNT(DISTINCT LOCATION)  
 FROM (  

SELECT DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID  FROM intranet.BSEDB_aB.DBO.MIS_TO WHERE COMPANY=@coname
--SELECT  DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID FROM AngelBSECM.BSEDB_aB.DBO.CMBILLVALAN   
AND SAUDA_dATE >=@FDATE+' 00:00:00' AND SAUDA_DATE <=@TDATE+' 23:59:59'  

)A LEFT OUTER JOIN  
(SELECT BOLT_NO,LOCATION FROM BOLT_MASTER WHERE SEGMENT=@coname) B   
ON A.TERMINAL_ID=B.BOLT_NO   
GROUP BY BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME  
HAVING COUNT(DISTINCT LOCATION) > @NOL  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NOL_2
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[NOL_2](@NOL AS INT,@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))

AS

 

SET NOCOUNT ON

 

SELECT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,NOL=COUNT(DISTINCT LOCATION)

 FROM (

SELECT  DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID FROM AngelBSECM.BSEDB_aB.DBO.CMBILLVALAN 

WHERE SAUDA_dATE >=@FDATE+' 00:00:00' AND SAUDA_DATE <=@TDATE+' 23:59:59'

)A LEFT OUTER JOIN

(SELECT BOLT_NO,LOCATION FROM BOLT_MASTER WHERE SEGMENT='ABLCM') B 

ON A.TERMINAL_ID=B.BOLT_NO 

GROUP BY BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME

HAVING COUNT(DISTINCT LOCATION) > @NOL

 

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NOL_2a
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[NOL_2a](@coname as varchar(10),@pcode as varchar(25),@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))    
AS    
    
SET NOCOUNT ON    
  
SELECT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,LOCATION  
FROM (    
--SELECT  DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID FROM AngelBSECM.BSEDB_aB.DBO.CMBILLVALAN     
SELECT DISTINCT BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,TERMINAL_ID  FROM intranet.BSEDB_aB.DBO.MIS_TO WHERE COMPANY=@coname
AND SAUDA_dATE >=@FDATE+' 00:00:00' AND SAUDA_DATE <=@TDATE+' 23:59:59'  and party_code=@pcode  
)A LEFT OUTER JOIN    
(SELECT BOLT_NO,LOCATION FROM BOLT_MASTER WHERE SEGMENT=@coname) B     
ON A.TERMINAL_ID=B.BOLT_NO     
GROUP BY BRANCH_CD,SUB_bROKER,PARTY_CODE,PARTY_NAME,location  
order by location  
  
   
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NOL_3a
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[NOL_3a](@coname as varchar(10),@pcode as varchar(25), @loca as varchar(25),@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))  
---CREATE PROCEDURE NOL_3a(@coname as varchar(10),@pcode as varchar(25), @loca as varchar(25),@FDATE AS VARCHAR(25),@TDATE AS VARCHAR(25))  
AS  
  
SET NOCOUNT ON  

declare @str1 as varchar(1000)

set @str1 = ''
set @str1 = @str1 + ' SELECT a.*,b.location FROM (  SELECT  sauda_date,sett_no,sett_type,Party_code,PArty_name,Scrip_cd,Scrip_name,'
set @str1 = @str1 + ' Pqty=Pqtytrd+Pqtydel, Prate=(case when Pqtytrd+Pqtydel > 0 then (Pamtdel+pamttrd)/(Pqtytrd+Pqtydel) else 0 end),'
set @str1 = @str1 + ' Pamt=Pamtdel+pamttrd, Sqty=Sqtytrd+Sqtydel, Srate=(case when Sqtytrd+Sqtydel > 0 then (Samtdel+Samttrd)/(Sqtytrd+Sqtydel) else 0 end),'

if @coname='ABLCM' 
BEGIN
	set @str1 = @str1 + ' Samt=Samtdel+Samttrd, terminal_id FROM AngelBSECM.BSEDB_aB.DBO.CMBILLVALAN   '
END

if @coname='ACDLCM' 
BEGIN
	set @str1 = @str1 + ' Samt=Samtdel+Samttrd, terminal_id FROM AngelNseCM.msajag.DBO.CMBILLVALAN   '
END

set @str1 = @str1 + ' where SAUDA_dATE >='''+@FDATE+ ' 00:00:00'' AND SAUDA_DATE <='''+@TDATE+' 23:59:59''  and party_code='''+@pcode+''' )A ,'
set @str1 = @str1 + ' (SELECT BOLT_NO,LOCATION FROM BOLT_MASTER WHERE SEGMENT='''+@coname+''' and location='''+@loca+''') B   '
set @str1 = @str1 + ' where A.TERMINAL_ID=B.BOLT_NO   order by terminal_id, scrip_cd'

--print @str1

exec(@str1) 
SET NOCOUNT OFF

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
-- PROCEDURE dbo.report_ecncli
-- --------------------------------------------------
CREATE PROCEDURE REPORT_ECNCLI (@CODE AS VARCHAR(25))
AS
Set Nocount on   
select name='ECN Registered',reg_date from ecn_reg a where client_code=@CODE
union all
select name='ECN to NON-ECN',unmarkeddate=ISNULL(max(unmarkeddate),'') from client_details_ConvertedToNonECN 
where party_code=@CODE 
and repatriat_bank_ac_no<>'' 
UNION ALL
select name='Restored',updatedon=ISNULL(max(updatedon),'') from client_details_ConvertedToNonECN 
where party_code=@CODE 
and repatriat_bank_ac_no<>'' AND STATUS=1
Set Nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_bounce_ECN
-- --------------------------------------------------
CREATE Proc Rpt_bounce_ECN(@access_to as varchar(11),@access_code as varchar(10),@fdate as varchar(11),@tdate as varchar(11))  
as  
select top 0 client_code,client_name,client_email,DocumentDate=document_date into #con2   
from [196.1.115.169].esigner.dbo.History_Sent_Log  
  
Set Nocount On  
  
if @access_to='BROKER'  
BEGIN  
 insert into #con2       
 select distinct client_code,client_name,client_email,DocumentDate=document_date  
 from [196.1.115.169].esigner.dbo.History_Sent_Log                      
 where document_date>=convert(varchar(11),@fdate)+' 00:00:00'                   
 and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'    
  
 select [DocumentDate]=convert(varchar(11),DocumentDate),Branch=branch_cd,[Sub-Broker]=sub_broker,Client=client_code,Name=client_name, Email=client_email,[Mobile No.]=mobile_pager,[Res. Phone]=res_phone1   from #con2 a                  
 left outer join                  
 (select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details ) b            on a.client_code=b.party_code                  
 order by branch_cd,sub_broker,client_code                       
END  
if @access_to='REGION'  
BEGIN  
 insert into #con2       
 select distinct client_code,client_name,client_email,DocumentDate=document_date    
 from [196.1.115.169].esigner.dbo.History_Sent_Log                      
 where document_date>=convert(varchar(11),@fdate)+' 00:00:00'                   
 and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'                      
  
   
 select [DocumentDate]=convert(varchar(11),DocumentDate),Branch=branch_cd,[Sub-Broker]=sub_broker,Client=client_code,Name=client_name, Email=client_email,[Mobile No.]=mobile_pager,[Res. Phone]=res_phone1   from #con2 a                  
 left outer join                  
 (select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details ) b            on a.client_code=b.party_code  
 where   branch_cd in (select code from intranet.risk.dbo.region where reg_code=@access_code)                
 order by branch_cd,sub_broker,client_code                       
  
END  
if @access_to='BRMAST'  
BEGIN  
 insert into #con2       
 select distinct client_code,client_name,client_email,DocumentDate=document_date    
 from [196.1.115.169].esigner.dbo.History_Sent_Log                      
 where document_date>=convert(varchar(11),@fdate)+' 00:00:00'                   
 and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'    
  
 select [DocumentDate]=convert(varchar(11),DocumentDate),Branch=branch_cd,[Sub-Broker]=sub_broker,Client=client_code,Name=client_name, Email=client_email,[Mobile No.]=mobile_pager,[Res. Phone]=res_phone1   from #con2 a                  
 left outer join                  
 (select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details ) b            on a.client_code=b.party_code  
 where   branch_cd in (select branch_cd from intranet.risk.dbo.branch_master where BrMast_cd=@access_code)                
 order by branch_cd,sub_broker,client_code                        
END  
if @access_to='BRANCH'  
BEGIN  
 insert into #con2       
 select distinct client_code,client_name,client_email,DocumentDate=document_date    
 from [196.1.115.169].esigner.dbo.History_Sent_Log                      
 where document_date>=convert(varchar(11),@fdate)+' 00:00:00'                   
 and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'   
  
 select [DocumentDate]=convert(varchar(11),DocumentDate),Branch=branch_cd,[Sub-Broker]=sub_broker,Client=client_code,Name=client_name, Email=client_email,[Mobile No.]=mobile_pager,[Res. Phone]=res_phone1   from #con2 a                  
 left outer join                  
 (select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details ) b            on a.client_code=b.party_code  
 where   branch_cd=@access_code    
 order by branch_cd,sub_broker,client_code           
END  
             
   
  
Set Nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Send_EBROK_invalide_details
-- --------------------------------------------------
CREATE Procedure Send_EBROK_invalide_details  
as  

DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp   

Set Nocount On  
  
declare @tag varchar(12),@email varchar(200),@rec int,@mess as varchar(1500),@mess2 as varchar(1300),@ctr as int,  
@name as varchar(100)    
set @ctr=0  
set @mess2='  
  
This is with reference to "Circular No: - AGC/0809/253  Dated – 27/09/2008  Sub - ECN and Mobile Number Compulsory for E – Broking Clients". Copy of Circular attached for reference.  
  
  
Please find Enclosed the List of E-Broking Clients who have either not registered for ECN and/or their mobile number in not registered with us.  
  
  
To avoid the inconvenience for your clients , we advise you to take this seriously and help your client in updating the information at the earliest.  
  
  
Please take note of the following:-  
  
  
·         In case of those clients who have not registered for ECN and their Mobile Number is not registered with us, the client requires to fill up the ECN Consent Form and submit the same to the respective Branch / Sub Broker.  
  
  
·         In case of those clients who want to update their Email id and/or their Mobile Number require to fill up the Account Modification Form and submit the same to the respective Branch / Sub Broker.  
  
  
Attachments:-   
  
·         ECN Consent Form.pdf  
  
·         Account Modification Form.pdf  
  
·         List of Clients who have either not registered for ECN and/or their mobile number in not registered with us  
   
  
Regards,  
   
  
CSO – E-Broking'  
  
DECLARE email_EBROK_cursor CURSOR FOR                                                   
select  branch,ManagerName,email from EBROK_BR_EMAIL(nolock)                                          
                                                  
OPEN email_EBROK_cursor                                                  
                                                  
FETCH NEXT FROM email_EBROK_cursor                                                   
INTO @tag,@name,@email  
                                                  
WHILE @@FETCH_STATUS = 0                                                  
BEGIN     
  
select @rec=count(1) from temp_ebrok_email where branch_cd=@tag and status=0  
if @rec > 0  
BEGIN  
 declare @s as varchar(1000),@s1 as varchar(1000)  
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +  
 'bcp  " select ''''BRANCH,SB,CLIENT,NAME,ECN,EMAIL,MOBILE'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+Party_code+'''',''''+short_name+'''',''''+ECN+'''',''''+email+'''',''''+mobile from mis.testdb.dbo.temp_ebrok_email where branch_cd='''''+@tag+'''''  " queryout D:\upload1\EBROK_MAIL\clientlist_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                              
 set @s1= @s+''''                                                    
 exec(@s1)  
  
 declare @attach as varchar(500)  
 set @attach='d:\upload1\EBROK_MAIL\clientlist_'+@tag+'.CSV;d:\upload1\EBROK_MAIL\Account Modification Form.pdf;d:\upload1\EBROK_MAIL\ECN Consent Form.pdf;d:\upload1\EBROK_MAIL\Circular No - AGC-0809-253.pdf'  
  
 declare @str as varchar(200)  , @result as int  
 set @str='declare @result as int'  
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\EBROK_MAIL\clientlist_'+@tag+'.CSV'', NO_OUTPUT'  
 set @str=@str+' select Result=@result '     
  
 --declare @ss  table (status int)                                
 ---insert into @ss  exec(@str)  
 create table #ffb (status int)  
 insert into #ffb  exec(@str)  
 select @result=status from #ffb  
 --print @result  
  
set @mess='Dear '+replace(@name,',','/')+@mess2  
  
 if @result=0  
 begin  
 exec intranet.msdb.dbo.sp_send_dbmail                 
@profile_name = 'productsupport',
  --@from='productsupport@angeltrade.com',  
  @recipients =@email,  
     @blind_copy_recipients ='George@angeltrade.com,amit.ghodekar@angeltrade.com',  
  @subject='ECN and Mobile Number Compulsory for E-Broking Clients',--@type='text/html',  
  @importance ='HIGH',  
  @file_attachments =@attach,  
  @body =@mess  
  --print 'File send '+@tag  
  update temp_ebrok_email set status=1 where branch_cd=@tag  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\EBROK_MAIL\clientlist_'+@tag+'.CSV'''        
  exec(@str)  
     set @ctr=1       
 end  
 drop table #ffb  
  
END  
  
 FETCH NEXT FROM email_EBROK_cursor                                                   
 INTO @tag,@name,@email                            
                                                  
END                         
                                    
CLOSE email_EBROK_cursor                                      
DEALLOCATE email_EBROK_cursor    
print @ctr   
if @ctr=1  
BEGIN  
select mess='Mail Send Successfully'  
END  
if @ctr=0  
BEGIN  
select mess='Mail Has Been Already Send'  
END  
  
Set Nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_AMC_NEXT_MAIL
-- --------------------------------------------------
      
CREATE procedure Sent_AMC_NEXT_MAIL                   
as                    
                         
select * into #AMC_ON_Next from DPBACKOFFICE.acercross.dbo.AMC_ON_Next      
      
drop table AMC_ON_Next      
      
select b.branch_cd,b.sub_broker,b.client_name,a.*,typ=space(3)       
into AMC_ON_Next      
from #AMC_ON_Next a      
left outer join      
(select branch_cd,sub_broker,party_code,client_name=short_name from intranet.risk.dbo.client_details) b      
on a.pcode=b.party_code      
--where b.branch_cd is not null      
order by branch_cd      
      
update AMC_ON_Next set typ='B2C' from remisior.dbo.b2c_sb b      
where AMC_ON_Next.sub_broker=b.b2c_sb      
      
update AMC_ON_Next set typ='B2B' where typ=''  AND branch_cd is not null          
      
                    
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                    
@mess2 as varchar(1300),@ctr as int,                      
@name as varchar(100)                        
set @ctr=0                      
set @mess2='                  
    
Please find the list of clients mapped under your branch. These clients will be debited for collection of AMC charges in the next month.    
    
You are requested to ensure timely collection of AMC charges from these clients.     
    
For any further clarification, please contact the DP Team at CSO.    
    
Regards,    
    
DP Ops Team.    
'                      
                      
DECLARE email_DP_cursor CURSOR FOR                                                                       
select top 15  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                
from NonECN_MAIL_addr(nolock) --where branch='AHD'                  
order by branch                                                             
                                                                      
OPEN email_DP_cursor                                                                      
                                                                      
FETCH NEXT FROM email_DP_cursor                                                                       
INTO @tag,@name,@email,@remail                      
                                                                      
WHILE @@FETCH_STATUS = 0                                                                      
BEGIN                         
                      
select @rec=count(1) from AMC_ON_Next where branch_cd=@tag                     
if @rec > 0                      
BEGIN                      
 declare @s as varchar(1000),@s1 as varchar(1000)                      
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance,AMC Charge'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+pcode+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal)+'''',''''+convert(varchar(15),AMC) from mis.testdb.dbo.AMC_ON_Next where branch_cd='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\DPAMC_'+@tag+'.CSV -c -Sintranet -U sa -Pnirwan612'        
                                          
 set @s1= @s+''''                                                                        
 exec(@s1)                      
                      
 declare @attach as varchar(500)                      
 set @attach='D:\upload1\ECN\Bounce_file\DPAMC_'+@tag+'.CSV;'                      
                      
 declare @str as varchar(200)  , @result as int                      
set @str='declare @result as int'                     
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\DPAMC_'+@tag+'.CSV'', NO_OUTPUT'                      
 set @str=@str+' select Result=@result '                         
                      
 --declare @ss  table (status int)                                 
 ---insert into @ss  exec(@str)                      
 create table #ffb (status int)                
 insert into #ffb  exec(@str)           select @result=status from #ffb                      
 --print @result                      
                      
set @mess='Dear '+replace(@name,',','/')+@mess2                      
                      
 if @result=0                      
 begin                      
 EXEC master.dbo.xp_smtp_sendmail @from='CSO@angeltrade.com',                      
  @to='shweta.tiwari@angeltrade.com',                      
  --@cc=@remail,                      
  --@bcc='shweta.tiwari@angeltrade.com',                      
  @subject='Collection of DP AMC ',--@type='text/html',                      
  @priority='HIGH',                      
  @attachments=@attach,                      
  @server='angelmail.angelbroking.com',                      
  @message=@mess                      
  --print 'File send '+@tag                      
                    
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\DPAMC_'+@tag+'.CSV'''                            
  exec(@str)                      
  set @ctr=1                           
 end                      
 drop table #ffb                      
                      
END                      
                      
 FETCH NEXT FROM email_DP_cursor                                                                       
 INTO @tag,@name,@email,@remail                                                
                                                                      
END                                             
                                                        
CLOSE email_DP_cursor                                                          
DEALLOCATE email_DP_cursor           
                   
select @rec=count(1) from mis.testdb.dbo.AMC_ON_Next where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)                  
if @rec>0        
BEGIN        
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+pcode+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal) from mis.testdb.dbo.AMC_ON_Next where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)  " queryout D:\upload1\ECN\Bounce_file\DPAMC_NotSend.CSV -c -Sintranet -Usa -Pnirwan612'                                                
 set @s1= @s+''''                                                                        
 exec(@s1)             
                      
 --declare @attach as varchar(500)                      
 set @attach='D:\upload1\ECN\Bounce_file\DPAMC_NotSend.CSV;'                      
                      
 --declare @str as varchar(200)  , @result as int                      
 set @str='declare @result as int'                      
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\DPAMC_NotSend.CSV'', NO_OUTPUT'                      
 set @str=@str+' select Result=@result '                         
                      
 --declare @ss  table (status int)                                                    
 ---insert into @ss  exec(@str)                      
 create table #ffb1 (status int)                    
 --truncate table #ffb                   
                   
 insert into #ffb1  exec(@str)                      
 select @result=status from #ffb1                      
 --print @result                      
                      
 set @mess='Dear ALL            
            
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for Above subject, So do the needfull to update concerned branch person email ID.            
'                     
                      
 if @result=0                      
 begin                      
  EXEC master.dbo.xp_smtp_sendmail @from='Soft@angeltrade.com',                   
  --@to=@email,                      
  @to='shweta.tiwari@angeltrade.com',                      
  @subject='Collection of DP AMC ',--@type='text/html',                      
  @priority='HIGH',                      
  @attachments=@attach,                      
  @server='angelmail.angelbroking.com',                      
  @message=@mess               
  --print 'File send '+@tag                      
                    
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\DPAMC_NotSend.CSV'''                            
  exec(@str)                      
     --set @ctr=1                           
 end                      
 drop table #ffb1                     
 END        
                 
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_Bounce_EcnMail
-- --------------------------------------------------
CREATE procedure Sent_Bounce_EcnMail                                        
as                                        
  
DECLARE @rc INT                   
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                   
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                  
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp
                                           
declare @tdate as varchar(11)                                          
select @tdate=max(sauda_date) from remisior.dbo.comb_co                                        
                                        
select distinct client_code,client_name,client_email,DocumentDate=document_date                                             
into #con2                                             
from [196.1.115.169].esigner.dbo.History_Sent_Log                                            
where document_date>=convert(varchar(11),@tdate)+' 00:00:00'                                         
and document_date<=convert(varchar(11),@tdate)+' 23:59:59' and document_state='Bounced'                                            
                                  
drop table Temp_ECNBounce_MAIL_BR                                        
--select * from Temp_ECNBounce_MAIL_BR                                  
select branch_cd,sub_broker,client_code,client_name,client_email, mobile_pager,res_phone=res_phone1                                        
into Temp_ECNBounce_MAIL_BR                                        
from #con2 a                                        
left outer join                                        
(select party_code,sub_broker,branch_cd,mobile_pager,res_phone1 from intranet.risk.dbo.client_details) b                                    
on a.client_code=b.party_code                                        
order by branch_cd,sub_broker,client_code                                        
                      
insert into intranet.sms.dbo.sms(to_no,message,date,time,flag,ampm,purpose)                      
--select mobile_pager,str='Dear Customer, Electronic Contract Note sent to your email id '+client_email+' has bounced back. For assistance please contact feedback@angeltrade.com',              
--select mobile_pager,str='Dear Customer, ECN sent on '+client_email+' has bounced,correct the id in 10 days or sify id will be made your default id.Call 022-28355000 for help. -Angel',              
select mobile_pager,str='Dear Client,ECN sent on '+client_email+' has bounced,please correct within 7days or else Sify id will be mapped.Angel Helpdesk 28355000. -Angel',    
convert(varchar(11),getdate(),103),substring(convert(varchar(25),getdate()),13,5)                      
,'P',reverse(substring(reverse(getdate()),1,2)),'ECN BOUNCE'                       
from Temp_ECNBounce_MAIL_BR where              
len(mobile_pager)=10 and mobile_pager like '9%'                
      
insert into ECNBOUNCE_SMS_log select client_code,mobile_pager,'Feb 25 2009',getdate() from Temp_ECNBounce_MAIL_BR     
where len(mobile_pager)=10 and mobile_pager like '9%'                
     
       
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                                        
@mess2 as varchar(1300),@ctr as int,                                          
@name as varchar(100)                                            
set @ctr=0                                          
set @mess2='                                      
                                        
Kindly see the attached list of ECN reports sent to the respective clients of your branch, which was bounced and did not get delivered to the client successfully.                                        
                                        
Request you’ll to kindly get in touch with your respective clients and check if the email id updated with us is incorrect or the client’s mailbox is full.                                        
                                        
If a new email id is submitted from the client other than the email id updated with us, kindly ensure that a new ECN letter is signed from the client for the same.                                        
                                        
Do revert on the same at the earliest on kyc.cso@angeltrade.com in case of any clarifications.                                        
              
Regards,                                        
                                        
ECN CSO                                        
'                                          
                                          
DECLARE email_EBROK_cursor CURSOR FOR                                                                                           
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                                    
from NonECN_MAIL_addr(nolock) --where branch='AHD'                                      
order by branch                                                                                 
                                                                                          
OPEN email_EBROK_cursor                                                                                          
                                                                            
FETCH NEXT FROM email_EBROK_cursor                                                                                
INTO @tag,@name,@email,@remail                              
                                                                                          
WHILE @@FETCH_STATUS = 0                                                                                          
BEGIN                                             
                                          
select @rec=count(1) from Temp_ECNBounce_MAIL_BR where branch_cd=@tag                                         
if @rec > 0                                          
BEGIN                                          
 declare @s as varchar(1000),@s1 as varchar(1000)                                          
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,EMAIL'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_code+'''',''''+client_name+'''',''''+client_email from mis.testdb.dbo.Temp_ECNBou
nce_MAIL_BR where branch_cd='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                          
 set @s1= @s+''''                           
 exec(@s1)                                          
                                          
 declare @attach as varchar(500)                                          
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV;'                                    
                                          
 declare @str as varchar(200)  , @result as int                                          
 set @str='declare @result as int'                                         
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'', NO_OUTPUT'                                          
 set @str=@str+' select Result=@result '                                             
                                          
 --declare @ss  table (status int)                                                     
 ---insert into @ss  exec(@str)                                          
 create table #ffb (status int)                                          
 insert into #ffb  exec(@str)           select @result=status from #ffb                                          
 --print @result                                          
                                          
set @mess='Dear '+replace(@name,',','/')+@mess2                                          
                                          
 if @result=0                                          
 begin                                          
 EXEC intranet.msdb.dbo.sp_send_dbmail
  @profile_name = 'ECNCSO', 
  --@from='ECNCSO@angeltrade.com',                                          
  @recipients = @email,                                          
  @copy_recipients = @remail,     
  @blind_copy_recipients = 'Deepak.Redekar@angeltrade.com;Pramita.Poojary@angeltrade.com',                                          
  @subject='ECN Bounce Mail Client',--@type='text/html',                                          
  @importance ='HIGH',                                          
  @file_attachments =@attach,                                          
  --@server='angelmail.angelbroking.com',                                          
  @body =@mess                                          
  --print 'File send '+@tag                                          
                                        
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'''                                     
  exec(@str)                                          
  set @ctr=1                                               
 end                                          
 drop table #ffb                                          
                                          
END                                          
                                          
 FETCH NEXT FROM email_EBROK_cursor                                                                                           
 INTO @tag,@name,@email,@remail                                                                    
                                                                                          
END                               
                                                                            
CLOSE email_EBROK_cursor                                                                              
DEALLOCATE email_EBROK_cursor                    
----------------------Mail To QA----                        
select @rec=count(1) from Temp_ECNBounce_MAIL_BR                         
if @rec > 0                                          
BEGIN                 
set @tag='ALL'                             
 --declare @s as varchar(1000),@s1 as varchar(1000)                                          
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,EMAIL,MOBILE,Residence Phone'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_code+'''',''''+client_name+'''',''''+client_email+'''',''
''+mobile_pager+'''',''''+res_phone from mis.testdb.dbo.Temp_ECNBounce_MAIL_BR   " queryout D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                                    
 set @s1= @s+''''                     
 exec(@s1)                                          
                                          
 --declare @attach as varchar(500)                                          
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV;'                                    
                            
-- declare @str as varchar(200)  , @result as int                                          
 set @str='declare @result as int'                                         
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'', NO_OUTPUT'                                          
 set @str=@str+' select Result=@result '                                             
                                          
 --declare @ss  table (status int)                                                     
 ---insert into @ss  exec(@str)                                          
 create table #ffbq (status int)                                          
 insert into #ffbq  exec(@str)           select @result=status from #ffbq                                          
 --print @result                                          
                                          
set @mess='Dear All'+@mess2                                          
                                          
 if @result=0                                          
 begin                                          
 EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'ECNCSO',
  --@from='ECNCSO@angeltrade.com',                                          
  @recipients = 'kyc.cso@angeltrade.com;Feedback@angeltrade.com;cosdespatch@angeltrade.com;Deepak.Redekar@angeltrade.com;Pramita.Poojary@angeltrade.com;virajm.patil@angeltrade.com',                                          
  @copy_recipients ='Santanu.Syam@angeltrade.com;Alpesh.Porwal@angeltrade.com',                                          
  @blind_copy_recipients ='shweta.tiwari@angeltrade.com',                                          
  @subject='ECN Bounce Mail Client',--@type='text/html',                                          
  @importance ='HIGH',                                          
  @file_attachments =@attach,                                          
  --@server='angelmail.angelbroking.com',                                          
  @body =@mess                                          
  --print 'File send '+@tag                                          
                       
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'''                                                
  exec(@str)                                          
  set @ctr=1                                               
 end                                          
 drop table #ffbq                                       
                                          
 END                          
                        
-----------------------------------------Mail when branch id not found                                            
select @rec=count(1) from mis.testdb.dbo.Temp_ECNBounce_MAIL_BR where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)                                      
if @rec>0                            
BEGIN                            
--declare @s as varchar(1000),@s1 as varchar(1000)                                          
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,EMAIL'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_code+'''',''''+client_name+'''',''''+client_email from mis.testdb.dbo.Temp_ECNBou
nce_MAIL_BR  where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)  " queryout D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV -c -Sintranet -Usa -Pnirwan612'                                                                    
 set @s1= @s+''''                                                                                            
 exec(@s1)                                    
                                          
 --declare @attach as varchar(500)                                          
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV;'                                          
                                          
 --declare @str as varchar(200)  , @result as int                                          
 set @str='declare @result as int'                                          
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV'', NO_OUTPUT'                                          
 set @str=@str+' select Result=@result '                                             
                                          
 --declare @ss  table (status int)                                                                        
 ---insert into @ss  exec(@str)                                          
 create table #ffb1 (status int)                                        
 --truncate table #ffb                                       
                                       
 insert into #ffb1                          
 exec(@str)                                          
 select @result=status from #ffb1                                          
 --print @result                          
                                          
 set @mess='Dear ALL                                
                                
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for ecn bounce of client, So do the needfull to update concerned branch person email ID.                                
'                                         
                                          
 if @result=0                                          
 begin                                          
  EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'ECNCSO', 
  --@from='Soft@angeltrade.com',                                     
  @recipients  = 'Deepak.Redekar@angeltrade.com;sachin.jadhav@angeltrade.com;ECNCSO@angeltrade.com;shweta.tiwari@angeltrade.com',                                          
  @subject='ECN Bounce Mail Not Alerted',--@type='text/html',                                          
  @importance ='HIGH',                                          
  @file_attachments =@attach,                                          
  --@server='angelmail.angelbroking.com',                                          
  @body =@mess                                          
  --print 'File send '+@tag                                          
                     
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV'''                                                
  exec(@str)                                          
     --set @ctr=1                                               
 end                                          
 drop table #ffb1                                         
 END                            
                                     
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_DP_DebitBAl_MAIL
-- --------------------------------------------------
CREATE procedure Sent_DP_DebitBAl_MAIL                 
as                  
                       
select * into #temp_Debithold from DPBACKOFFICE.acercross.dbo.temp_Debithold    
    
drop table temp_Debithold    
    
select b.branch_cd,b.sub_broker,b.client_name,a.*,typ=space(3)     
into temp_Debithold    
from #temp_Debithold a    
left outer join    
(select branch_cd,sub_broker,party_code,client_name=short_name from intranet.risk.dbo.client_details) b    
on a.pcode=b.party_code    
--where b.branch_cd is not null    
order by branch_cd    
    
update temp_Debithold set typ='B2C' from remisior.dbo.b2c_sb b    
where temp_Debithold.sub_broker=b.b2c_sb    
    
update temp_Debithold set typ='B2B' where typ='' AND ISNULL(branch_cd,'')<>''
    
                  
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                  
@mess2 as varchar(1300),@ctr as int,                    
@name as varchar(100)                      
set @ctr=0                    
set @mess2='                
            
  
Please find the list of clients mapped under your branch with holdings in their BO account and consolidated debit ledger balance.  
  
You are requested to ensure the recovery of DP charges from these clients before the release of shares.   
  
For any further clarification, please contact the DP Team at CSO.  
  
Regards,  
  
DP Ops Team.  
   
'                    
                    
DECLARE email_EBROK_cursor CURSOR FOR                                                                     
select top 5  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')              
from NonECN_MAIL_addr(nolock) --where branch='AHD'                
order by branch                                                           
                                                                    
OPEN email_EBROK_cursor                                                                    
                                                                    
FETCH NEXT FROM email_EBROK_cursor                                                                     
INTO @tag,@name,@email,@remail                    
                                                                    
WHILE @@FETCH_STATUS = 0                                                                    
BEGIN                       
                    
select @rec=count(1) from temp_Debithold where branch_cd=@tag                   
if @rec > 0                    
BEGIN                    
 declare @s as varchar(1000),@s1 as varchar(1000)                    
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+pcode+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal) from mis.testdb.dbo.temp_Debithold where branch_cd='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\DebitBalance_'+@tag+'.CSV -c -Sintranet -U sa -Pnirwan612'                                              
 set @s1= @s+''''                                                                      
 exec(@s1)                    
                    
 declare @attach as varchar(500)                    
 set @attach='D:\upload1\ECN\Bounce_file\DebitBalance_'+@tag+'.CSV;'                    
                    
 declare @str as varchar(200)  , @result as int                    
set @str='declare @result as int'                   
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\DebitBalance_'+@tag+'.CSV'', NO_OUTPUT'                    
 set @str=@str+' select Result=@result '                       
                    
 --declare @ss  table (status int)                               
 ---insert into @ss  exec(@str)                    
 create table #ffb (status int)                    
 insert into #ffb  exec(@str)           select @result=status from #ffb    
 --print @result                    
                    
set @mess='Dear '+replace(@name,',','/')+@mess2                    
                    
 if @result=0                    
 begin                    
 EXEC master.dbo.xp_smtp_sendmail @from='CSO@angeltrade.com',                    
  @to='shweta.tiwari@angeltrade.com',                    
  --@cc=@remail,                    
  --@bcc='shweta.tiwari@angeltrade.com',                    
  @subject='Clients List with DP Holdings and Debit balances',--@type='text/html',                    
  @priority='HIGH',                    
  @attachments=@attach,                    
  @server='angelmail.angelbroking.com',                    
  @message=@mess                    
  --print 'File send '+@tag                    
                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\DebitBalance_'+@tag+'.CSV'''                          
  exec(@str)                    
  set @ctr=1                         
 end                    
 drop table #ffb                    
                    
END                    
                    
 FETCH NEXT FROM email_EBROK_cursor                                                                     
 INTO @tag,@name,@email,@remail                                              
                                                                    
END                                           
                                                      
CLOSE email_EBROK_cursor                                                        
DEALLOCATE email_EBROK_cursor         
                 
select @rec=count(1) from mis.testdb.dbo.temp_Debithold where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)                
if @rec>0      
BEGIN      
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+pcode+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal) from mis.testdb.dbo.temp_Debithold where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)  " queryout D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_NotSend.CSV -c -Sintranet -Usa -Pnirwan612'                                              
 set @s1= @s+''''                                                                      
 exec(@s1)           
                    
 --declare @attach as varchar(500)                    
 set @attach='D:\upload1\ECN\Bounce_file\DebitBalance_NotSend.CSV;'                    
                    
 --declare @str as varchar(200)  , @result as int                    
 set @str='declare @result as int'                    
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\DebitBalance_NotSend.CSV'', NO_OUTPUT'                    
 set @str=@str+' select Result=@result '                       
                    
 --declare @ss  table (status int)                                                  
 ---insert into @ss  exec(@str)                    
 create table #ffb1 (status int)                  
 --truncate table #ffb                 
                 
 insert into #ffb1  exec(@str)                    
 select @result=status from #ffb1                    
 --print @result                    
                    
 set @mess='Dear ALL          
          
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for Above subject, So do the needfull to update concerned branch person email ID.          
'                   
                    
 if @result=0                    
 begin                    
  EXEC master.dbo.xp_smtp_sendmail @from='Soft@angeltrade.com',                 
  --@to=@email,                    
  @to='shweta.tiwari@angeltrade.com',                    
  @subject='Clients List with DP Holdings and Debit balances',--@type='text/html',                    
  @priority='HIGH',                    
  @attachments=@attach,                    
  @server='angelmail.angelbroking.com',                    
  @message=@mess                    
  --print 'File send '+@tag                    
                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\DebitBalance_NotSend.CSV'''                          
  exec(@str)                    
     --set @ctr=1                         
 end                    
 drop table #ffb1                   
 END      
               
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_DP_ZeroHold_MAIL
-- --------------------------------------------------
CREATE procedure Sent_DP_ZeroHold_MAIL               
as                
                     
select * into #temp_zerohold from DPBACKOFFICE.acercross.dbo.temp_zerohold  
  
drop table temp_zerohold  
  
select b.branch_cd,b.sub_broker,b.client_name,a.*,typ=space(3)   
into temp_zerohold  
from #temp_zerohold a  
left outer join  
(select branch_cd,sub_broker,party_code,client_name=short_name from intranet.risk.dbo.client_details) b  
on a.pcode=b.party_code  
--where b.branch_cd is not null  
order by branch_cd  
  
update temp_zerohold set typ='B2C' from remisior.dbo.b2c_sb b  
where temp_zerohold.sub_broker=b.b2c_sb  
  
update temp_zerohold set typ='B2B' where typ='' AND ISNULL(branch_cd,'')<>''
  
                
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                
@mess2 as varchar(1300),@ctr as int,                  
@name as varchar(100)                    
set @ctr=0                  
set @mess2='              
                
Please Find the attached list of clients mapped under your branch with no holdings in their BO account. Also, there has been no transaction in these accounts for the past six months.  
  
You are requested to follow – up with these clients for collection of AMC charges. In case, client wish to close his BO account, please ensure that AMC charges are recovered along with account closure form.  
  
For any further clarification, please contact the DP Team at CSO.  
  
Regards,  
  
DP Ops Team.  
             
'                  
                  
DECLARE email_EBROK_cursor CURSOR FOR                                                                   
select top 15  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')            
from NonECN_MAIL_addr(nolock) --where branch='AHD'              
order by branch                                                         
                                                                  
OPEN email_EBROK_cursor                                                                  
                                                                  
FETCH NEXT FROM email_EBROK_cursor                                                                   
INTO @tag,@name,@email,@remail                  
                                                                  
WHILE @@FETCH_STATUS = 0                                                                  
BEGIN                     
                  
select @rec=count(1) from temp_zerohold where branch_cd=@tag                 
if @rec > 0                  
BEGIN                  
 declare @s as varchar(1000),@s1 as varchar(1000)                  
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+p
code+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal) from mis.testdb.dbo.temp_zerohold where branch_cd='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_'+@tag+'.CSV -c -Sintranet -U
sa -Pnirwan612'                                            
 set @s1= @s+''''                                                                    
 exec(@s1)                  
                  
 declare @attach as varchar(500)                  
 set @attach='D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_'+@tag+'.CSV;'                  
                  
 declare @str as varchar(200)  , @result as int                  
set @str='declare @result as int'                 
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_'+@tag+'.CSV'', NO_OUTPUT'                  
 set @str=@str+' select Result=@result '                     
                  
 --declare @ss  table (status int)                             
 ---insert into @ss  exec(@str)                  
 create table #ffb (status int)                  
 insert into #ffb  exec(@str)           select @result=status from #ffb                  
 --print @result                  
                  
set @mess='Dear '+replace(@name,',','/')+@mess2                  
                  
 if @result=0                  
 begin                  
 EXEC master.dbo.xp_smtp_sendmail @from='CSO@angeltrade.com',                  
  @to='shweta.tiwari@angeltrade.com',                  
  --@cc=@remail,                  
  --@bcc='shweta.tiwari@angeltrade.com',                  
  @subject='Clients List with zero DP Holdings and No Transaction',--@type='text/html',                  
  @priority='HIGH',                  
  @attachments=@attach,                  
  @server='angelmail.angelbroking.com',                  
  @message=@mess                  
  --print 'File send '+@tag                  
                
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_'+@tag+'.CSV'''                        
  exec(@str)                  
  set @ctr=1                       
 end                  
 drop table #ffb                  
                  
END                  
                  
 FETCH NEXT FROM email_EBROK_cursor                                                                   
 INTO @tag,@name,@email,@remail                                            
                                                                  
END                                         
                                                    
CLOSE email_EBROK_cursor                                                      
DEALLOCATE email_EBROK_cursor       
               
select @rec=count(1) from mis.testdb.dbo.temp_zerohold where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)              
if @rec>0    
BEGIN    
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,Sub-broker,NAME,DP ID,KYC Code,B2B/B2C,Total Ledger Balanec,Dp Ledger Balance'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_name+'''',''''+cm_cd+'''',''''+p
code+'''',''''+typ+'''',''''+convert(varchar(15),Totbal)+'''',''''+convert(varchar(15),dpbal) from mis.testdb.dbo.temp_zerohold where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)  " queryout D:\upload1\ECN\Bounce_file\ZeroHolding
_NoTransaction_NotSend.CSV -c -Sintranet -Usa -Pnirwan612'                                            
 set @s1= @s+''''                                                                    
 exec(@s1)         
                  
 --declare @attach as varchar(500)                  
 set @attach='D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_NotSend.CSV;'                  
                  
 --declare @str as varchar(200)  , @result as int                  
 set @str='declare @result as int'                  
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_NotSend.CSV'', NO_OUTPUT'                  
 set @str=@str+' select Result=@result '                     
                  
 --declare @ss  table (status int)                                                
 ---insert into @ss  exec(@str)                  
 create table #ffb1 (status int)                
 --truncate table #ffb               
               
 insert into #ffb1  exec(@str)                  
 select @result=status from #ffb1                  
 --print @result                  
                  
 set @mess='Dear ALL        
        
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for Above subject, So do the needfull to update concerned branch person email ID.        
'                 
                  
 if @result=0                  
 begin                  
  EXEC master.dbo.xp_smtp_sendmail @from='Soft@angeltrade.com',               
  --@to=@email,                  
  @to='shweta.tiwari@angeltrade.com',                  
  @subject='Clients List with zero DP Holdings and No Transaction',--@type='text/html',                  
  @priority='HIGH',                  
  @attachments=@attach,                  
  @server='angelmail.angelbroking.com',                  
  @message=@mess                  
  --print 'File send '+@tag                  
                
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\ZeroHolding_NoTransaction_NotSend.CSV'''                        
  exec(@str)                  
     --set @ctr=1                       
 end                  
 drop table #ffb1                 
 END    
             
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_EcnMail_ALL_2Chk_Bounce
-- --------------------------------------------------
CREATE procedure Sent_EcnMail_ALL_2Chk_Bounce                    
as                    
     
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp
              
declare @tag varchar(12),@email varchar(200),@mess as varchar(4000),                       
@name as varchar(100)                        
              
set @mess='Dear Customer,  
  
We are pleased to inform you that we have activated the ECN (Electronic Contract Notes) facility on your account with us and you will receive all your Contract Notes via e-mail with immediate effect.  
  
This will enable you to have instant and anytime access of your transactions.  
  
We request you to keep adequate space in your Inbox to avoid any mail bounce.  
   
Assuring you of our personalized services at all times.  
      
'             
                      
DECLARE sentECN_Promo CURSOR FOR                                                                       
select  party_code,email      
from SentMail_ECN_ALL(nolock) where flag='N'      
                             
                                                                      
OPEN sentECN_Promo                                                                      
                                                                      
FETCH NEXT FROM sentECN_Promo                                                                       
INTO @tag,@email      
                                                                      
WHILE @@FETCH_STATUS = 0                                                                      
BEGIN                         

 exec intranet.msdb.dbo.sp_send_dbmail                   
 @recipients  = @email,                           
-- @cc = 'Pramita.Poojary@angeltrade.com',  
 @profile_name = 'angelecn',         
 --@from = 'angelecn@angeltrade.com',               
 --@type='text/html',                  
 @subject = 'Electronic Contract Notes',                           
 --@attachments = 'd:/upload/ecn_form/E-statement(upload).pdf',      
 @body =@mess                        
      
 update SentMail_ECN_ALL set flag='Y' where party_code=@tag      
        
 FETCH NEXT FROM sentECN_Promo                                                                       
 INTO @tag,@email      

END                                                             
CLOSE sentECN_Promo                                                          
DEALLOCATE sentECN_Promo

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_EcnMail_Invite
-- --------------------------------------------------
CREATE procedure Sent_EcnMail_Invite                  
as                  
        
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp            
            
declare @tag varchar(12),@email varchar(200),@mess as varchar(4000),                     
@name as varchar(100)                      
               
                
set @mess='<html><body><p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">Dear    
Customer,<o:p></o:p></span></p>    
    
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">We value your association with Angel. It has always been our vision to provide best value for money to our investors through innovative products, trading /investment strategies
  
, state of art technology and personalized service.    
<o:p></o:p></span></p>    
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">Angel’s    
priority has always been to provide you with a hassle free trading experience.    
Bearing the same in mind we have taken the following new initiatives:<o:p></o:p></span>    
<br>    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]>    
<span style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore>·<span    
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">Electronic    
contract notes and MTM statements.     
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span    
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore>·<span    
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">Online    
DP statements. <o:p></o:p></span>    
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span    
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore>·<span    
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">Online    
Quarterly ledgers. <o:p></o:p></span>    
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span    
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore>·<span    
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">Automatic    
trade confirmation through SMS. <o:p></o:p></span>    
    
<p class=MsoNormal><b><i><span style=font-size:14.0pt;font-family:"Garamond","serif">ECN    
is the fastest and the simplest way to get your Contract notes, bills and    
margin statements. With the contract notes in electronic form, your important    
communications would be just a mouse click away.&nbsp;<o:p></o:p></span></i></b></p>    
    
    
    
<p class=MsoNormal><b><i><span style=font-size:14.0pt;font-family:"Garamond","serif";color:"red">    
“Activate your account now for ECN”<o:p></o:p></span></i></b></p>    
    
    
    
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">It    
is requested that you fill in the attached mandate ECN form and submit the same    
to our nearest Angel branch or send in a scanned copy of the same to us at <a    
href="mailto:ecn.cso@angeltrade.com">ecn.cso@angeltrade.com</a> and avail the    
convenient facility of Electronic statements and be confident of not missing the    
essential communications from Angel.<o:p></o:p></span></p>    
    
    
    
<p class=MsoNormal><b><span style=font-size:12.0pt;font-family:"Garamond","serif">Thanking    
You,<o:p></o:p></span></b><br>    
<b><span style=font-size:12.0pt;font-family:"Garamond","serif">Yours    
Sincerely,<o:p></o:p></span></b>    
    
<br>    
    
<p class=MsoNormal><b><span style=font-size:12.0pt;font-family:"Garamond","serif">Operation    
Team<o:p></o:p></span></b>    
<br>    
<b><span style=font-size:12.0pt;font-family:"Garamond","serif">Angel    
Broking</span></b><span style=color:#1F497D><o:p></o:p></span>    
'           
                    
DECLARE sentECN_invite CURSOR FOR                                                                     
select party_code,email    
from SentMail_ECN(nolock) where Sent='N'    
                           
                                                                    
OPEN sentECN_invite                                                                    
                                                                    
FETCH NEXT FROM sentECN_invite                                                                     
INTO @tag,@email    
                                                                    
WHILE @@FETCH_STATUS = 0                                                                    
BEGIN                       
                    
          
               
 exec intranet.msdb.dbo.sp_send_dbmail                 
 @recipients  = @email,                         
 @copy_recipients  = 'Pramita.Poojary@angeltrade.com', 
 @profile_name ='ECNCSO',        
 --@from = 'ECN.CSO@angeltrade.com',             
 @body_format ='html',                
 @subject = 'Activate your account for ECN',                         
 @file_attachments  = 'd:/upload/ecn_form/E-statement(upload).pdf',    
 @body =@mess                      
    
   update SentMail_ECN set sent='Y' where party_code=@tag    
      
 FETCH NEXT FROM sentECN_invite                                                                     
 INTO @tag,@email    
                              
    
END                    
                    
                                          
                                       
                                                      
CLOSE sentECN_invite                                                        
DEALLOCATE sentECN_invite

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_lowBrok_DispatchStatus_mail
-- --------------------------------------------------
CREATE procedure Sent_lowBrok_DispatchStatus_mail                                  
as                                
                                     
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp                             
     
drop table LOw_brok_cli_DispatchStatus_mail                                
--select * from LOw_brok_cli_DispatchStatus_mail          
  
select branch_cd,sub_broker,a.party_code,Pod_no,Client_name,Dispatch_dt,Ecn_reg=case when repatriat_bank_ac_no like 'ECN%' Then 'Yes'  
else 'NO' end  
Into LOw_brok_cli_DispatchStatus_mail  
from intranet.misc.dbo.LOw_brok_cli_DispatchStatus_mail a  
left outer join  
intranet.risk.dbo.client_details b  
on a.party_code=b.party_code  
where a.party_code is not null  
order by branch_cd                            
                                       
                       
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                                
@mess2 as varchar(1300),@ctr as int,                                  
@name as varchar(100)                                    
set @ctr=0                                  
set @mess2='  
              
Please find attached list of the client for your branch, to whom letters have been dispatched it contain POD NO also and the same is dispatch through MID WAY Courier. Please call these customers on the phone to ensure that they are reminded of the require
ment to sign the registration forms and quickly submit it to the branch, for onward delivery to CSO.  
  
  
  
Regards,  
Deepak Redekar- Manager Operations   
Tel :( 022)-30837400 Extn 423                               
'                                  
                                  
DECLARE Dispatch_ECN_low CURSOR FOR                                                                                   
select top 5 branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                            
from NonECN_MAIL_addr(nolock) --where branch='AHD'                              
order by branch                                                                         
                                                                                  
OPEN Dispatch_ECN_low                                                                                  
                                                                                  
FETCH NEXT FROM Dispatch_ECN_low                                                                        
INTO @tag,@name,@email,@remail                      
                                                                                  
WHILE @@FETCH_STATUS = 0                                                                                  
BEGIN                                     
                                  
select @rec=count(1) from LOw_brok_cli_DispatchStatus_mail where branch_cd=@tag                                 
if @rec > 0                                  
BEGIN                                  
 declare @s as varchar(1000),@s1 as varchar(1000)                                  
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,POD NO,DISPATCH DATE,ECN REG STATUS'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+party_code+'''',''''+client_name+'''',''''+pod_no+'''',''''+dispatch_dt+'''',''''+Ecn_reg from mis.testdb.dbo.LOw_brok_cli_DispatchStatus_mail where branch_cd='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\LowBrok_dispatch__'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                    
              
 set @s1= @s+''''                   
 exec(@s1)                                  
                                  
 declare @attach as varchar(500)                                  
 set @attach='D:\upload1\ECN\Bounce_file\LowBrok_dispatch__'+@tag+'.CSV;'                            
                                  
 declare @str as varchar(200)  , @result as int                                  
 set @str='declare @result as int'                                 
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\LowBrok_dispatch__'+@tag+'.CSV'', NO_OUTPUT'                                  
 set @str=@str+' select Result=@result '                                     
                                  
 --declare @ss  table (status int)                                             
 ---insert into @ss  exec(@str)                                  
 create table #ffb (status int)                                  
 insert into #ffb  exec(@str)           select @result=status from #ffb                                  
 --print @result                                  
                                  
set @mess='Dear '+replace(@name,',','/')+@mess2                                  
                                  
 if @result=0                                  
 begin                                  
EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'ECNCSO',
  --@from='ECNCSO@angeltrade.com',                                  
  @recipients='shweta.tiwari@angeltrade.com',--@email,                                  
  --@cc=@remail,                                  
  @blind_copy_recipients='Deepak.Redekar@angeltrade.com',                                  
  @subject='Low Brok, ECN Dispatch Status',--@type='text/html',                                  
  @importance='HIGH',                                  
  @file_attachments=@attach,                                  
  @body=@mess                                  
  --print 'File send '+@tag                                  
                          
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\LowBrok_dispatch__'+@tag+'.CSV'''                                        
  exec(@str)                                  
  set @ctr=1                                       
 end                                  
 drop table #ffb                                  
                                  
END                                  
                                  
 FETCH NEXT FROM Dispatch_ECN_low                                                                                   
 INTO @tag,@name,@email,@remail                                                            
                                                                                  
END                                                         
                                                                    
CLOSE Dispatch_ECN_low                                                                      
DEALLOCATE Dispatch_ECN_low            
  
               
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sent_sifyMail_Invite
-- --------------------------------------------------
CREATE procedure Sent_sifyMail_Invite                            
as                            
 
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp                             
                      
declare @tag varchar(12),@email varchar(200),@mess as varchar(6000),                               
@name as varchar(100)                                
                         
                          
set @mess='<html><body><p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">Dear              
Customer,<o:p></o:p></span></p>              
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">Welcome to the Angel Family.              
<o:p></o:p></span></p>              
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">At the outset we would like           
to thank you for choosing Angel as your preferred retail stock broking partner.           
It has always been our Vision, to provide best value for money to our investors through           
innovative products, trading / investment strategies, state-of-the art technology, and           
personalized service. We would like to take this opportunity to reiterate our commitment to offer you           
world class services backed by the highest standards of quality.<o:p></o:p></span>              
<br>            
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">          
Bearing the same in mind we have taken the following new initiatives:            
<o:p></o:p></span>              
<br> <b>           
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]>              
<span style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore><span              
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">•  Electronic contract notes and MTM statements.             
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span              
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore><span              
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">•  Online DP statements. <o:p></o:p></span>              
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span              
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore><span              
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">•  Online Quarterly ledgers. <o:p></o:p></span>              
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<![if !supportLists]><span              
style=font-size:14.0pt;font-family:Symbol><span style=mso-list:Ignore><span              
style=font:7.0pt "Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              
</span></span></span><![endif]><span style=font-size:14.0pt;font-family:"Garamond","serif">•  Automatic trade confirmation through SMS.<o:p></o:p></span>              
 </b>              
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">To ensure secure           
delivery of the above statements, Angel has tied up with Sifymail to create an additional email id           
account for each of our esteemed clients. Henceforth these online statements would be delivered to you           
on your Sifymail ID.&nbsp;<o:p></o:p></span></p>                
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">          
This will ensure timely and secured delivery of important communications to you and avoid varied           
reasons of non-delivery of important communications from Angel.&nbsp;<o:p></o:p></span></p>            
<b>              
<p class=MsoNormal><b><span style=font-size:14.0pt;font-family:"Garamond","serif">              
*This Sifymail ID is an additional email ID generated for you to receive all important communications           
from Angel and you need not sign any ECN mandate form afresh for the same.<o:p></o:p></span></b></p></b>              
<i><p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">You are welcome to call           
our Centralized Helpdesk on (022) 2835 5000 or write to the Quality Assurance cell at           
feedback@angeltrade.com<o:p></o:p></span></p></i>              
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">          
We are sure that you will benefit from your Association with Angel.<o:p></o:p></span></p>          
<p class=MsoNormal><span style=font-size:14.0pt;font-family:"Garamond","serif">Looking forward to a           
long term and fruitful relationship and assuring you our best attention.<o:p></o:p></span><br><br><br>              
<span style=font-size:14.0pt;font-family:"Garamond","serif">Regards,<o:p></o:p></span>             
<br><br>             
<span style=font-size:14.0pt;font-family:"Garamond","serif">Angel              
Broking.</span><br><span style=font-size:14.0pt;font-family:"Garamond","serif">Operations              
Department</span>              
<br>'                     
                              
DECLARE sentECN_invite CURSOR FOR                                                                               
select party_code=ltrim(rtrim(party_code)),email    
from sentmail_sify (nolock) where sent='N' and  pdf='Y'            
                                     
                                                                              
OPEN sentECN_invite                                                                              
                                                                              
FETCH NEXT FROM sentECN_invite                                                                               
INTO @tag,@email              
                                                                              
WHILE @@FETCH_STATUS = 0                                                                              
BEGIN                                 
                              
     declare @attach as varchar(50)          
     set @attach='d:/upload1/ECN/sify/sifymail/'+@tag+'.pdf'          
                         
 exec intranet.msdb.dbo.sp_send_dbmail                 
 @recipients  = @email,                                   
 --@cc = 'Pramita.Poojary@angeltrade.com', 
 @profile_name = 'angelecn',                  
 --@from = 'Angelecn@angeltrade.com',                       
 @body_format ='text/html',                          
 @subject = 'ECN Welcome Letter',                                   
 @file_attachments  =@attach,          
 @body =@mess                                
              
   update sentmail_sify set sent='Y' where party_code=@tag              
                
 FETCH NEXT FROM sentECN_invite                                                                               
 INTO @tag,@email              
              
END                              
CLOSE sentECN_invite                                                                  
DEALLOCATE sentECN_invite

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
-- PROCEDURE dbo.sp_SMTPMail
-- --------------------------------------------------


Create Procedure sp_SMTPMail

	@SenderName varchar(100),
	@SenderAddress varchar(100),
	@RecipientName varchar(100),
	@RecipientAddress varchar(100),
	@Subject varchar(200),
	@Body varchar(8000),
	@MailServer varchar(100) = 'localhost'

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
-- PROCEDURE dbo.sp_tables_info_rowset_64
-- --------------------------------------------------
create procedure sp_tables_info_rowset_64

@table_name sysname, 

@table_schema sysname = null, 

@table_type nvarchar(255) = null 

as

declare @Result int set @Result = 0

exec @Result = sp_tables_info_rowset @table_name, @table_schema, @table_type

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
-- PROCEDURE dbo.spx_BindGrid_BranchMail
-- --------------------------------------------------

CREATE  PROC spx_BindGrid_BranchMail  
AS  
SELECT ltrim(rtrim(branch)) AS branch ,BM,BM_mail,RGM ,RGM_mail FROM mis.testdb.dbo.NonECN_MAIL_addr ORDER BY branch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_FetchDiykycPOAData
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Spx_FetchDiykycPOAData]  
(  
 @FromDate DATETIME,  
 @ToDate DATETIME  
)  
AS  
BEGIN  
  
 SELECT DISTINCT  
  ISNULL(I.Fld_Application_No,'') AS Application_No,  
  ISNULL(I.Fld_Panno,'') AS PAN,  
  ISNULL(I.Fld_Client_Name,'') AS Party_Name,  
  ISNULL(IR.party_code,'') AS Party_Code,  
  ISNULL(I.Fld_Application_No,'') AS KYC_Application_ID,  
  ISNULL(P.First_Name,'')   AS First_Name,  
  ISNULL(P.Middle_Name,'')   AS Middle_Name,  
  ISNULL(P.Last_Name,'')   AS Last_Name,  
  ISNULL(I.Fld_Panno,'') AS PAN_No,  
  ISNULL(A.Address1,'')   AS Address1,  
  ISNULL(A.Address2,'')   AS Address2,  
  ISNULL(A.Address3,'')   AS Address3,  
  CASE ISNULL(CT.Description,'') WHEN '' THEN CI.City ELSE CT.Description END AS City,  
  CAST(ISNULL(A.Pin_Code,'') AS FLOAT)  AS Pincode,  
  CAST(ISNULL(CI.Mobile_No,'') AS FLOAT)  AS Mobile,  
  ''   AS Tel_Res,  
  ISNULL(CI.Email_Id,'')  AS Email_Id,  
  ISNULL(S.State_Name,'')   AS State,  
  ISNULL(CP.DPID,'')   AS DPID,  
  ISNULL(CA.AppointmentDate,'')  AS Appointment_Date,  
  CASE ISNULL(CA.AppointmentTime,'') WHEN '8AM-12PM' THEN '1'   
             WHEN '8AM to 12PM' THEN '1'   
             WHEN '8-12' THEN '1'  
             WHEN '12PM-4PM' THEN '2'  
             WHEN '12PM to 4PM' THEN '2'  
             WHEN '12-16' THEN '2'  
             WHEN '4PM-8PM' THEN '3'  
             WHEN '4PM to 8PM' THEN '3'  
             WHEN '16-20' THEN '3'  
  END AS Appointment_Time  
  
 FROM   
 ABVSKYCMIS.KYC.dbo.TBL_KYC_INWARD I With(nolock)   
 LEFT JOIN ABVSKYCMIS.KYC.dbo.Client_InwardRegister IR With(noLock) ON I.Fld_Application_No = IR.Fld_Application_No  
 left join [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_ClientInfo CI WITH(NOLOCK) on 'W' + CI.Application_No = I.Fld_Application_No  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_ClientAppointment CA WITH(NOLOCK) ON I.Fld_Application_No = 'W' + CA.ApplicationNo  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_PersonalInfo P WITH(NOLOCK) ON CI.DiykycId = P.DiykycId  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_AddressInfo A WITH(NOLOCK) ON CI.DiykycId = A.DiykycId  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.DiyKyc_TradingPreferences CP WITH(NOLOCK) ON CI.DiykycId = CP.DiykycId  
 LEFT JOIN [KYC1DB].AngelbrokingWebDb.Dbo.StateMaster S WITH(NOLOCK) ON S.State_Id = A.State  
 LEFT JOIN [KYC1DB].AngelbrokingWebDb.Dbo.CityMaster1 CT WITH(NOLOCK) ON CT.CityId = A.City  
 WHERE   
 CAST(CA.CreatedDate AS DATE) BETWEEN @FromDate AND @ToDate  
 --CAST(ISNULL(CA.CreatedDate,GETDATE()) AS DATE) BETWEEN ISNULL(@FromDate,GETDATE()) AND ISNULL(@ToDate,GETDATE())  
 --CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_FetchDiykycPOAData_TEST
-- --------------------------------------------------
--exec Spx_FetchDiykycPOAData_TEST '2018-09-20','2018-09-21'  
CREATE PROCEDURE [dbo].[Spx_FetchDiykycPOAData_TEST]  
(  
 @FromDate DATETIME,  
 @ToDate DATETIME  
)  
AS  
BEGIN  
  
 SELECT DISTINCT  
  ISNULL(I.Fld_Application_No,'') AS Application_No,  
  ISNULL(I.Fld_Panno,'') AS PAN,  
  ISNULL(I.Fld_Client_Name,'') AS Party_Name,  
  ISNULL(IR.party_code,'') AS Party_Code,  
  ISNULL(I.Fld_Application_No,'') AS KYC_Application_ID,  
  ISNULL(H.First_Name,'')   AS First_Name,  
  ISNULL(H.Middle_Name,'')   AS Middle_Name,  
  ISNULL(H.Last_Name,'')   AS Last_Name,  
  ISNULL(I.Fld_Panno,'') AS PAN_No,  
  ISNULL(H.Address1,'')   AS Address1,  
  ISNULL(H.Address2,'')   AS Address2,  
  ISNULL(H.Address3,'')   AS Address3,  
  ISNULL(H.City,'') AS City,  
  ISNULL(H.PinCode,'') AS Pincode,  
  ISNULL(H.Mobile,'') AS Mobile,  
  --CASE ISNULL(CT.Description,'') WHEN '' THEN CI.City ELSE CT.Description END AS City,  
  --CAST(ISNULL(A.Pin_Code,'') AS FLOAT)  AS Pincode,  
  --CAST(ISNULL(CI.Mobile_No,'') AS FLOAT)  AS Mobile,  
  ''   AS Tel_Res,  
  ISNULL(H.Email_Id,'')  AS Email_Id,  
  ISNULL(S.State,'')   AS State,  
  --ISNULL(CP.DPID,'')   AS DPID,  
  --ISNULL(CA.AppointmentDate,'')  AS Appointment_Date,  
  CASE ISNULL(CA.AppointmentTime,'') WHEN '8AM-12PM' THEN '1'   
             WHEN '12PM-4PM' THEN '2'  
             WHEN '8AM to 12PM' THEN '1'   
             WHEN '12PM to 4PM' THEN '2'  
             WHEN '4PM-8PM' THEN '3'  
             WHEN '4PM to 8PM' THEN '3'  
  END AS Appointment_Time  
  
 FROM   
 ABVSKYCMIS.KYC.dbo.TBL_KYC_INWARD I With(nolock)   
 LEFT JOIN ABVSKYCMIS.KYC.dbo.Client_InwardRegister IR With(noLock) ON I.Fld_Application_No = IR.Fld_Application_No  
 LEFT JOIN ABVSKYCMIS.KYC_CI.dbo.KYC_Holder_T H WITH(NOLOCK) ON IR.Party_Code = H.Client_Code  
 --left join [172.31.16.173].AngelbrokingDiykyc.Dbo.Diykyc_ClientInfo CI WITH(NOLOCK) on 'W' + CI.Application_No = I.Fld_Application_No  
 LEFT JOIN [kyc1db].AngelbrokingDiykyc.Dbo.Diykyc_ClientAppointment CA WITH(NOLOCK) ON I.Fld_Application_No = 'W' + CA.ApplicationNo  
 LEFT JOIN ABVSKYCMIS.KYC_CI.dbo.TBL_STATECITY_MASTER S on H.City = S.City  
 --LEFT JOIN [172.31.16.173].AngelbrokingDiykyc.Dbo.Diykyc_PersonalInfo P WITH(NOLOCK) ON CI.DiykycId = P.DiykycId  
 --LEFT JOIN [172.31.16.173].AngelbrokingDiykyc.Dbo.Diykyc_AddressInfo A WITH(NOLOCK) ON CI.DiykycId = A.DiykycId  
 --LEFT JOIN [172.31.16.173].AngelbrokingDiykyc.Dbo.DiyKyc_TradingPreferences CP WITH(NOLOCK) ON CI.DiykycId = CP.DiykycId  
 --LEFT JOIN [172.31.16.173].AngelbrokingWebDb.Dbo.StateMaster S WITH(NOLOCK) ON S.State_Id = A.State  
 --LEFT JOIN [172.31.16.173].AngelbrokingWebDb.Dbo.CityMaster1 CT WITH(NOLOCK) ON CT.CityId = A.City  
 WHERE   
 CAST(CA.CreatedDate AS DATE) BETWEEN @FromDate AND @ToDate  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_getBranch_BranchMail_MailAddr
-- --------------------------------------------------

  
CREATE  PROC spx_getBranch_BranchMail_MailAddr    
AS    
--SELECT ltrim(rtrim(BRANCH_CODE)), ltrim(rtrim(BRANCH_CODE)) +'-'+BRANCH  AS Branch from intranet.risk.dbo.branches     
--ORDER BY branch_code    
--where branch_code not in (select branch from mis.testdb.dbo.NonECN_MAIL_addr )   
  
  
select * from intranet.risk.dbo.branches where branch_code not in (select branch from mis.testdb.dbo.NonECN_MAIL_addr )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetDataForDpCrystalReport
-- --------------------------------------------------
  
        
--Select * from tbl_Nbfc_SynergyDataForDp        
-- exec Spx_GetDataForDpCrystalReport 'S121848'        
CREATE proc [dbo].[Spx_GetDataForDpCrystalReport]        
(        
  @Party_code varchar(25)        
)         
as        
        
Truncate table tbl_Nbfc_SynergyDataForDp_CrystalReport        
Insert into tbl_Nbfc_SynergyDataForDp_CrystalReport        
(        
Party_code,        
CurrentCode,        
CATEGORY,        
OCCUPATION,        
STATUS,        
SUB_TYPE,        
DP_INT_REFNO,        
POA_ID,        
POA_NAME,        
CLOSURE_DATE,        
TITLE,        
FIRST_HOLD_NAME,        
SALUTATION,        
CONTACT_PERSON,        
FIRST_HOLD_ADD1,        
FIRST_HOLD_ADD2,        
FIRST_HOLD_ADD3,        
FIRST_HOLD_PIN,        
FIRST_HOLD_CNTRY,        
FIRST_HOLD_STATE,        
FIRST_HOLD_PHONE,        
FIRST_HOLD_FAX,        
EMAIL_ADD,        
FOREIGN_ADDR1,        
FOREIGN_ADDR2,        
FOREIGN_ADDR3,        
FOREIGN_CITY,        
FOREIGN_STATE,        
FOREIGN_CNTRY,        
FOREIGN_ZIP,        
FOREIGN_PHONE,        
FOREIGN_FAX,        
SECOND_HOLD_NAME,        
THIRD_HOLD_NAME,        
ITPAN,        
TAX_DEDUCT,        
BANK_MICR,        
MICR_CODE,        
BANK_ACCNO,        
BANK_NAME,        
BANK_ADD1,        
BANK_ADD2,        
BANK_ADD3,        
BANK_ADD4,        
BANK_STATE,        
BANK_CNTRY,        
BANK_ZIP,        
SEBI_REG_NO,        
RBI_REFNO,        
RBI_APP_DT,        
NOMI_GUARD_NAME,        
NOMI_GUARD_ADD1,        
NOMI_GUARD_ADD2,        
MINOR_BIRTH_DATE,        
CM_ID,        
CH_ID,        
TRADING_ID,        
GROUP_ID,        
EXCHANGE_ID,        
PROD_NO,        
ACTIVE_STATUS,        
CHANGE_REASON,        
BRANCH_CODE,        
GROUP_CODE,        
FAMILY_CODE,        
TEMPLATE_CODE,        
NISE_PARTY_CODE,        
MAILING_FLAG,        
DISPATCH_MODE,        
BILLING_FREQ,        
PRINT_DATE,        
LETTER_NO,        
FILE_REF_NO,        
ACTIVE_DATE,        
FIRST_HOLD_ADD4,        
BENEF_STATUS,        
INTRO_ID,        
SHORT_NAME,        
CLIENT_CODE,        
CLIENT_CITY_CODE,        
BENEF_ACCNO,        
PURCHASE_WAIVER,        
TYPE,        
DP_ID,        
BO_DOB,        
BO_SEX,        
BO_NATIONALITY,        
NO_STMT_CODE,        
CLOSE_REASON,        
CLOSE_INITIATE,        
CLOSE_REQ_DATE,        
CLOSE_APPROVAL_DATE,        
BO_SUSPENSION_FLAG,        
BO_SUSPENSION_DATE,        
BO_SUSPENSION_REASON,        
BO_SUSPENSION_INITIATE,        
PROFESSION_CODE,        
LIFE_STYLE_CODE,        
GEOGRAPH_CODE,        
EDUCATION_CODE,        
INCOME_CODE,        
STAFF_FLAG,        
STAFF_CODE,        
ELECTRONIC_DIVIDEND,        
ELECTRONIC_CONF,        
DIVIDEND_CURRENCY,        
BO_BANK_CODE,        
BO_BRANCH_NO,        
DIVIDEND_ACCOUNT_NO,        
BO_CURRENCY,        
BANK_ACCOUNT_TYPE,        
BANK_ACC_TYPE,        
BANK_PIN,        
DIVIDEND_BRANCH_NO,        
DIVIDEND_ACC_CURRENCY,        
DIVIDEND_BANK_AC_TYPE,        
PURPOSE_ADDITIONAL_NAME,        
SETUP_DATE,        
POA_START_DATE,        
POA_END_DATE,        
POA_ENABLED,        
POA_TYPE,        
LANG_CODE,        
ITPAN_CIRCLE,        
SECOND_HOLD_ITPAN,        
THIRD_HOLD_ITPAN,        
FIRST_HOLD_FNAME,        
ADDITIONAL_PURPOSE_CODE,        
ADDITIONAL_HOLDER_NAME,        
ADDITIONAL_SETUP_DATE,        
FAX_INDEMNITY,        
EMAIL_FLAG,        
FIRST_HOLD_MOBILE,        
FIRST_SMS_FLAG,        
SMART_REMARKS,        
FIRST_HOLD_PAN,        
POA_VER,        
DpApplicationNO         
        
)        
        
Select         
Party_code,        
CurrentCode,        
CATEGORY,        
OCCUPATION,        
STATUS,        
SUB_TYPE,        
DP_INT_REFNO,        
POA_ID,        
POA_NAME,        
CLOSURE_DATE,        
TITLE,        
FIRST_HOLD_NAME,        
SALUTATION,        
CONTACT_PERSON,        
isnull(FIRST_HOLD_ADD1,''),        
isnull(FIRST_HOLD_ADD2,''),        
isnull(FIRST_HOLD_ADD3,''),        
isnull(FIRST_HOLD_PIN,''),        
isnull(FIRST_HOLD_CNTRY,''),        
isnull(FIRST_HOLD_STATE,''),        
FIRST_HOLD_PHONE,        
FIRST_HOLD_FAX,        
EMAIL_ADD,        
isnull(FOREIGN_ADDR1,''),        
isnull(FOREIGN_ADDR2,''),        
isnull(FOREIGN_ADDR3,''),      
FOREIGN_CITY,        
FOREIGN_STATE,        
FOREIGN_CNTRY,        
FOREIGN_ZIP,        
FOREIGN_PHONE,        
FOREIGN_FAX,        
SECOND_HOLD_NAME,        
THIRD_HOLD_NAME,        
ITPAN,        
TAX_DEDUCT,        
BANK_MICR,        
MICR_CODE,        
BANK_ACCNO,        
BANK_NAME,        
BANK_ADD1,        
BANK_ADD2,        
BANK_ADD3,        
BANK_ADD4,        
BANK_STATE,        
BANK_CNTRY,        
BANK_ZIP,        
SEBI_REG_NO,        
RBI_REFNO,        
RBI_APP_DT,        
isnull(NOMI_GUARD_NAME,''),        
isnull(NOMI_GUARD_ADD1,''),        
isnull(NOMI_GUARD_ADD2,''),        
MINOR_BIRTH_DATE,        
CM_ID,        
CH_ID,        
TRADING_ID,        
GROUP_ID,        
EXCHANGE_ID,        
PROD_NO,        
ACTIVE_STATUS,        
CHANGE_REASON,        
BRANCH_CODE,        
GROUP_CODE,        
FAMILY_CODE,        
TEMPLATE_CODE,        
NISE_PARTY_CODE,        
MAILING_FLAG,        
DISPATCH_MODE,        
BILLING_FREQ,        
PRINT_DATE,        
LETTER_NO,        
FILE_REF_NO,        
ACTIVE_DATE,        
isnull(FIRST_HOLD_ADD4,''),        
BENEF_STATUS,        
INTRO_ID,        
SHORT_NAME,        
CLIENT_CODE,        
CLIENT_CITY_CODE,        
BENEF_ACCNO,        
PURCHASE_WAIVER,        
TYPE,        
DP_ID,        
CONVERT(varchar(15),BO_DOB,103),         
BO_SEX,        
BO_NATIONALITY,        
NO_STMT_CODE,        
CLOSE_REASON,        
CLOSE_INITIATE,        
CLOSE_REQ_DATE,        
CLOSE_APPROVAL_DATE,        
BO_SUSPENSION_FLAG,        
BO_SUSPENSION_DATE,        
BO_SUSPENSION_REASON,        
BO_SUSPENSION_INITIATE,        
PROFESSION_CODE,        
LIFE_STYLE_CODE,        
GEOGRAPH_CODE,        
EDUCATION_CODE,        
INCOME_CODE,        
STAFF_FLAG,        
STAFF_CODE,        
ELECTRONIC_DIVIDEND,        
ELECTRONIC_CONF,        
DIVIDEND_CURRENCY,        
BO_BANK_CODE,        
BO_BRANCH_NO,        
DIVIDEND_ACCOUNT_NO,        
BO_CURRENCY,        
BANK_ACCOUNT_TYPE,        
BANK_ACC_TYPE,        
BANK_PIN,        
DIVIDEND_BRANCH_NO,        
DIVIDEND_ACC_CURRENCY,        
DIVIDEND_BANK_AC_TYPE,        
PURPOSE_ADDITIONAL_NAME,        
SETUP_DATE,        
POA_START_DATE,        
POA_END_DATE,        
POA_ENABLED,        
POA_TYPE,        
LANG_CODE,        
ITPAN_CIRCLE,        
SECOND_HOLD_ITPAN,        
THIRD_HOLD_ITPAN,        
FIRST_HOLD_FNAME,        
ADDITIONAL_PURPOSE_CODE,        
ADDITIONAL_HOLDER_NAME,        
ADDITIONAL_SETUP_DATE,        
FAX_INDEMNITY,        
EMAIL_FLAG,        
FIRST_HOLD_MOBILE,        
FIRST_SMS_FLAG,        
SMART_REMARKS,        
FIRST_HOLD_PAN,        
POA_VER,        
DpApplicationNO        
       
from ABVSKYCMIS.kyc.dbo.tbl_Nbfc_SynergyDataForDp with(Nolock)        
where party_code=@party_code      
      
Update ABVSKYCMIS.kyc.dbo.tbl_NbfcData_PdfGeneration Set       
DpFlag='Y',      
DpGenDate=GETDATE()      
where Party_code=@Party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetDataForNbfcDp_6
-- --------------------------------------------------
  
  
  
  
CREATE Proc [dbo].[Spx_GetDataForNbfcDp_6]    
as    
    
select RowId,b.Party_code from ABVSKYCMIS.kyc.dbo.tbl_Nbfc_SynergyDataForDp a with(nolock)    
inner join ABVSKYCMIS.kyc.dbo.tbl_NbfcData_PdfGeneration b with(nolock)    
on a.party_code=b.Party_code    
where  ActiveInactive='A' and Isnull(DpFlag,'')=''  and lot=3  
AND RowId>7100   
order by party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_INSERTUPDATEBRANCH_MAIL
-- --------------------------------------------------


--SELECT *  FROM MIS.TESTDB.DBO.NONECN_MAIL_ADDR  
  
CREATE  PROC SPX_INSERTUPDATEBRANCH_MAIL  
@BRANCH VARCHAR(100),  
@BRMANAGER VARCHAR(100),  
@BRMGRID NVARCHAR(1000),  
@RMGR VARCHAR(100),  
@RMGR_ID NVARCHAR(1000)  
  
AS  
  
DECLARE @COUNT INT   
SELECT @COUNT = COUNT(BRANCH) FROM MIS.TESTDB.DBO.NONECN_MAIL_ADDR WHERE BRANCH =@BRANCH  
IF @COUNT<1  
BEGIN  
 INSERT INTO MIS.TESTDB.DBO.NONECN_MAIL_ADDR VALUES(@BRANCH,@BRMANAGER,@BRMGRID,@RMGR,@RMGR_ID)  
 SELECT 'ADDED SUCCESSFULLY.'  
END  
ELSE  
 BEGIN  
 UPDATE MIS.TESTDB.DBO.NONECN_MAIL_ADDR SET BM=@BRMANAGER,BM_MAIL=@BRMGRID,RGM=@RMGR,RGM_MAIL=@RMGR_ID
 WHERE BRANCH=@BRANCH  
 SELECT 'UPDATED SUCCESSFULLY.'  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_INSERTUPDATEECNBCCMAIL
-- --------------------------------------------------
  
  
CREATE PROCEDURE SPX_INSERTUPDATEECNBCCMAIL  
  
(  
@CLIENTCODE VARCHAR(20),  
@BCC_MAIL VARCHAR(200)  
)  
  
AS  
  
DECLARE @COUNT AS INT   
  
SELECT @COUNT = COUNT(*) FROM TBL_ECNREFERENCE WHERE CLIENT_CODE = @CLIENTCODE  
  
IF (@COUNT > 0)  
BEGIN  
UPDATE TBL_ECNREFERENCE SET BCC_MAIL = @BCC_MAIL WHERE CLIENT_CODE = @CLIENTCODE  
END  
  
ELSE   
BEGIN   
INSERT INTO TBL_ECNREFERENCE (CLIENT_CODE, BCC_MAIL ) VALUES (@CLIENTCODE, @BCC_MAIL)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Temp_Nov1007_PledgeAllocation
-- --------------------------------------------------


CREATE procedure Temp_Nov1007_PledgeAllocation(@scrip varchar(25))
as                
SET NOCOUNT ON                
                
DECLARE                 
@pcode  varchar(10),                            
@lbal money,
@Scode  varchar(25),                            
@CLIQTY  INT,
@SRATE MONEY,
@PQTY  MONEY,
@RQTY INT,
@MBAL MONEY,
@MQTY INT,
@mcl varchar(10),
@msco varchar(25),
@revPqty int              

--update nse_debit set revPqty=0

DECLARE error_cursor CURSOR FOR                 
select a.cltcode,
--led_balance=convert(money,led_balance),
led_balance=(case when b.AfterBalance=999999999999 then convert(money,led_balance) else b.AfterBalance end),
scrip_cd,qty=convert(int,qty),pledge=convert(money,pqty),
rate_share=convert(money,rate_Share),revPQty
--select sum(revPqty)
from nse_debit a (nolock) ,
(select cltcode,AfterBalance=min(afterbalance) from nse_debit (nolock) group by cltcode) b
where a.cltcode=b.cltcode and
Max_qty<>0 AND convert(money,pledge) > 0 
and scrip_cd =@scrip
order by scrip_Cd,led_balance desc,a.cltcode



         
OPEN error_cursor                
                
FETCH NEXT FROM error_cursor                 
INTO @PCODE,@LBAL,@SCODE,@CLIQTY,@PQTY,@SRATE,@RQTY 

set @MBAL = @lbal
set @MQTY = @pqty
set @mcl = @pcode
set @msco = @scode


WHILE @@FETCH_STATUS = 0                
BEGIN                
	set @revPqty = 0

  	IF (@mcl <> @pcode) 
	begin
		set @mbal = @lbal
	end


  	IF @msco <> @scode
	begin
		set @MQTY = @pqty
	end


 	if (@cliqty*@srate)*2 > @mbal
	begin
		set @revPqty = (convert(int,@mbal/(@srate/2)))
	end
	else
	begin
		set @revPqty = @cliqty
	end
	
	set @mbal=@mbal-(@revPQty*(@srate/2))	
	set @mqty =@mqty - @revPqty
	
	update nse_debit set revPqty = @revpqty,AfterBalance=@mbal where cltcode=@pcode and scrip_cd=@scode 
                
                
	FETCH NEXT FROM error_cursor                 
	INTO @PCODE,@LBAL,@SCODE,@CLIQTY,@PQTY,@SRATE,@RQTY 

END               
                
CLOSE error_cursor                
DEALLOCATE error_cursor                

print @scrip

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Temp_Nov1007_ScripAllocation
-- --------------------------------------------------
CREATE procedure Temp_Nov1007_ScripAllocation
as                
SET NOCOUNT ON                
                
DECLARE @Scode  varchar(25)

update nse_debit set revPqty=0
update nse_debit set AfterBalance =999999999999

DECLARE errora_cursor CURSOR FOR                 
select distinct scrip_Cd from nse_debit where scrip_Cd is not null order by scrip_cd

OPEN errora_cursor                
                
FETCH NEXT FROM errora_cursor INTO @SCODE

WHILE @@FETCH_STATUS = 0                
BEGIN                
	exec Temp_Nov1007_PledgeAllocation @scode
	FETCH NEXT FROM errora_cursor INTO @SCODE
END               
                
CLOSE errora_cursor
DEALLOCATE errora_cursor

GO

-- --------------------------------------------------
-- PROCEDURE dbo.tradecl_new
-- --------------------------------------------------
CREATE procedure [dbo].[tradecl_new]        
as        
set nocount on         
        
select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #abl_cl        
from AngelBSECM.bsedb_ab.dbo.client1 c1, AngelBSECM.bsedb_ab.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
and party_code in (select client_Code from Tradeanywhere_master)        
  
  
--select party_Code,short_name,long_name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #abl_cl        
--from intranet.risk.dbo.bse_client1 c1, intranet.risk.dbo.bse_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)    
        
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #acdl_cl        
from AngelNseCM.msajag.dbo.client1 c1, AngelNseCM.msajag.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
and party_code in (select client_Code from Tradeanywhere_master)        
  
--select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #acdl_cl        
--from intranet.risk.dbo.nse_client1 c1, intranet.risk.dbo.nse_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
        
  
select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
email ,branch_cd,sub_broker,family        
into #fo_cl        
from angelfo.nsefo.dbo.client1 c1, angelfo.nsefo.dbo.client2 c2 where c1.cl_code=c2.cl_Code        
and party_code in (select client_Code from Tradeanywhere_master)        
        
  
--select party_Code,short_name,Long_Name,l_address1,L_address2,L_Address3,        
--L_city, L_state, L_nation, L_zip,L_phoneR=COALESCE(res_phone1,res_phone2),        
--L_phoneO=COALESCE(off_phone1,off_phone2),Fax,Mobile_Pager,         
--email ,branch_cd,sub_broker,family        
--into #fo_cl        
--from intranet.risk.dbo.fo_client1 c1, intranet.risk.dbo.fo_client2 c2 where c1.cl_code=c2.cl_Code        
--and party_code in (select client_Code from Tradeanywhere_master)        
        
        
select * into #b1 from #acdl_cl where party_code not in        
(select party_code from #abl_cl)        
        
select * into #fo1 from #fo_cl where party_code not in        
(select party_code from #abl_cl        
union        
select party_code from #acdl_cl        
)        
        
        
select * into #aa from #abl_cl        
union        
select * from #b1        
union        
select * from #fo1         
        
select * into #bb        
from tradeanywhere_master         
where client_code not in        
(select party_code from #aa )  ----147        
        
drop table cl_trade        
select party_code,short_name,Long_name,l_address1,l_address2,L_Address3,L_city,L_state,        
L_nation,L_zip,L_phoneR,L_phoneO,Fax,Mobile_Pager,email,branch_cd,sub_broker,family,        
cl_category='Online',profile='001'        
into CL_Trade        
from #aa        
union        
select client_code,'TEST ID ',client_code,'ACME PLAZA','','','','','','','','','','','','ACM','ACM','','','' from #bb        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_ECNREg
-- --------------------------------------------------
CREATE Procedure [dbo].[upd_ECNREg]
as
 update ecn_reg set flag=1 where client_code in (select client_code from AngelNseCM.msajag.dbo.ecn_reg_client )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_ECNUnREg
-- --------------------------------------------------
CREATE Procedure [dbo].[upd_ECNUnREg]  
as  
update ecn_Dreg_branch set reg_status=1 where client_code in (select client_code from AngelNseCM.msajag.dbo.ecn_Unreg_client )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.updtdt
-- --------------------------------------------------
create procedure updtdt(@tdate as varchar(11))
as

update t2tdate set tdate = @tdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AutoInsertECNList
-- --------------------------------------------------
CREATE proc [dbo].[usp_AutoInsertECNList]

AS
BEGIN
Select Distinct repatriat_bank,repatriat_bank_ac_no,Print_Options,c.Cl_code,Min(active_date) Active_date into #clineta from AngelNseCM.Msajag.dbo.client_brok_details D, AngelNseCM.Msajag.dbo.Client_details c where
c.cl_code =d.cl_code and active_date >getdate()-15 and print_options ='0'  and InActive_From >getdate()
Group by repatriat_bank,repatriat_bank_ac_no,Print_Options,c.Cl_code


insert into ecn_reg_branch 
select getdate(),b.email,0,b.Party_code,b.short_name,'New','E57112',getdate(),'CSO','BROKER','YES','','','' from AngelNseCM.msajag.dbo.client_details b left outer join tbl_EcnReference c on b.party_code = c.client_code 
left outer join ecn_reg_branch d on b.party_code=d.client_code 
where b.party_code
in(
select cl_code from #clineta
) and d.client_code is null

----------- 2 Stage

INSERT INTO ECN_REG_GENERATE 
select Client_code from ecn_reg_branch Where Reg_Date between dateadd(MINUTE,-5, getdate()) and getdate()


insert into ecn_reg 
select reg_date=GETDATE(),a.mail_id,a.tel_no,b.client_code,flag='0',reg_no='ECN'+convert(varchar,b.ecn_no),reg_status='New',entered_by='E57112',entered_on=GETDATE() from ecn_reg_branch a 
join ECN_REG_GENERATE b on a.client_code=b.client_code  where a.client_code in (select Client_code from ecn_reg_branch Where Reg_Date between dateadd(MINUTE,-5, getdate()) and getdate())




insert into ECN_REG_GENERATE_hist --where client_code='R372822'
select * from ECN_REG_GENERATE where client_code in(
select  Client_code from ecn_reg_branch Where Reg_Date between dateadd(MINUTE,-5, getdate()) and getdate())


delete from ECN_REG_GENERATE where client_code in(
select  Client_code from ecn_reg_branch Where Reg_Date between dateadd(MINUTE,-5, getdate()) and getdate())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FETCH_FILETYPE_DETAILS
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_FETCH_FILETYPE_DETAILS]
	@FILETYPE INT
AS
BEGIN

	SELECT
		 TFT_ID AS "FILE_TYPE_ID"
		,TFT_FILE_TYPE AS "FILE_TYPE"
		,TFT_TABLE_NAME AS "TABLE_NAME"
		,TFT_UPLOAD_PATH AS "FILE_UPLOAD_PATH"
	FROM
		TESTFILE_TYPES
	WHERE
		TFT_ID = @FILETYPE;

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FetchDiykycPOADataDirect
-- --------------------------------------------------
--EXEC USP_FetchDiykycPOADataDirect 'W3494767'  
  
CREATE PROCEDURE [dbo].[USP_FetchDiykycPOADataDirect]  
  
(  
  
 @Application_No VARCHAR(510)  
  
)  
  
AS  
  
BEGIN  
  
  
  
 SELECT DISTINCT  
  
  ISNULL('W' + CI.Application_No,'')  AS Application_No,  
  
  ISNULL(CD.Pancard_No,'') AS PAN,  
  
  ISNULL(CI.Name,'') AS Party_Name,    
  
  ISNULL(CIR.Party_Code,'')   AS Party_Code,  
  
  ISNULL('W' + CI.Application_No,'')   AS KYC_Application_ID,  
  
  ISNULL(P.First_Name,'')   AS First_Name,  
  
  ISNULL(P.Middle_Name,'')   AS Middle_Name,  
  
  ISNULL(P.Last_Name,'')   AS Last_Name,  
  
  ISNULL(CD.Pancard_No,'')   AS PAN_No,  
  
  ISNULL(A.Address1,'')   AS Address1,  
  
  ISNULL(A.Address2,'')   AS Address2,  
  
  ISNULL(A.Address3,'')   AS Address3,  
  
  ISNULL(CT.Description,'')   AS City,  
  
  CAST(ISNULL(A.Pin_Code,'') AS FLOAT)  AS Pincode,  
  
  CAST(ISNULL(CI.Mobile_No,'') AS FLOAT)  AS Mobile,  
  
  ''   AS Tel_Res,  
  
  ISNULL(CI.Email_Id,'')  AS Email_Id,  
  
  ISNULL(S.State_Name,'')   AS State,  
  
  ISNULL(CP.DPID,'')   AS DPID,  
  
  ISNULL(C.AppointmentDate,'')  AS Appointment_Date,  
  
  CASE ISNULL(C.AppointmentTime,'') WHEN '8AM-12PM' THEN '1'   
  
            WHEN '12PM-4PM' THEN '2'  
  
            WHEN '4PM-8PM' THEN '3'  
  
  END AS Appointment_Time  
  
  --CAST(ISNULL(C.AppointmentTime,'')   AS Appointment_Time  
  
   
  
 FROM   
  
 [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_ClientInfo CI WITH(NOLOCK)  
  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_ClientAppointment C WITH(NOLOCK) ON CI.DiykycId = C.DiykycId  
  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_ClientDetails CD WITH(NOLOCK) ON CI.DiykycId = CD.DiykycId   
  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_PersonalInfo P WITH(NOLOCK) ON CI.DiykycId = P.DiykycId  
  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.Diykyc_AddressInfo A WITH(NOLOCK) ON CI.DiykycId = A.DiykycId  
  
 LEFT JOIN [KYC1DB].AngelbrokingDiykyc.Dbo.DiyKyc_TradingPreferences CP WITH(NOLOCK) ON CI.DiykycId = CP.DiykycId  
  
 LEFT JOIN [KYC1DB].AngelbrokingWebDb.Dbo.StateMaster S WITH(NOLOCK) ON S.State_Id = A.State  
  
 LEFT JOIN [KYC1DB].AngelbrokingWebDb.Dbo.CityMaster1 CT WITH(NOLOCK) ON CT.CityId = A.City  
  
 LEFT JOIN ABVSKYCMIS.KYC.Dbo.Client_InwardRegister CIR WITH(NOLOCK) ON 'W' + CI.Application_No = CIR.Fld_Application_No  
  
 WHERE   
  
 ISNULL('W' + CI.Application_No,'')  = @Application_No;  
  
 --CAST(C.CreatedDate AS DATE) BETWEEN @FromDate AND @ToDate  
  
 --CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FetchDiykycPOADataDirect_Test
-- --------------------------------------------------
--EXEC USP_FetchDiykycPOADataDirect_Test 'AB0275797'  
CREATE PROCEDURE [dbo].[USP_FetchDiykycPOADataDirect_Test]  
(  
 @Application_No VARCHAR(510)  
)  
AS  
BEGIN  
  
Create table #TempDiyData(   
Application_No varchar(100), First_Name varchar(100),   
Middle_Name varchar(100), Last_Name varchar(100), Address1 varchar(100), Address2 varchar(100), Address3 varchar(100),  
City varchar(100), Pincode varchar(100), Mobile varchar(100), Tel_Res varchar(100), Email_Id varchar(100), State varchar(100), DPID varchar(100),   
Appointment_Date varchar(100), Appointment_Time varchar(100))  
  
insert into #TempDiyData(  
 Application_No,First_Name,Middle_Name,Last_Name,Address1,Address2,Address3,City,Pincode,Mobile,Tel_Res,Email_Id,State,  
 DPID,Appointment_Date,Appointment_Time)   
 exec [kyc1db].AngelbrokingDiykyc.Dbo.spx_DiyKyc_POADataDirect  @Application_No  
  
 SELECT   
  ISNULL(I.Fld_Application_No,'') AS Application_No,  
  ISNULL(I.Fld_Panno,'') AS PAN,  
  ISNULL(I.Fld_Client_Name,'') AS Party_Name,  
  IR.Party_Code,  
  ISNULL(I.Fld_Application_No,'') AS KYC_Application_ID,  
   CI.First_Name,  
  CI.Middle_Name,  
  CI.Last_Name,  
  ISNULL(I.Fld_Panno,'') AS PAN_No,  
    
  CI.Address1,  
  CI.Address2,  
  CI.Address3,  
  CI.City,  
    
  CAST(ISNULL(CI.Pincode,'') AS FLOAT)  AS Pincode,  
  CAST(ISNULL(CI.Mobile,'') AS FLOAT)  AS Mobile,  
  ''   AS Tel_Res,  
  ISNULL(CI.Email_Id,'')  AS Email_Id,  
  CI.State,  
  CI.DPID,  
  CI.Appointment_Date,  
  CI.Appointment_Time  
 FROM   
 ABVSKYCMIS.KYC.dbo.TBL_KYC_INWARD I With(nolock)   
 LEFT JOIN ABVSKYCMIS.KYC.dbo.Client_InwardRegister IR With(noLock) ON I.Fld_Application_No = IR.Fld_Application_No  
 left join #TempDiyData CI WITH(NOLOCK) on  CI.Application_No = I.Fld_Application_No  
   
 WHERE   
 I.Fld_Application_No = @Application_No  
   
  
  
  
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FIND_STMT_BYKEYWORD_IN_USP
-- --------------------------------------------------
/**********************************************************************************        
CREATED BY: RAJENDRA VERMA        
DATE: 22/10/2010        
PURPOSE: USE TO GET ALL STATEMENTS IN STORE PROCEDURE        
   WHICH CONTAINS KEY_TO_SEARCH PARAMETER FOR DEFINED DATABASE @DBNAME       
   AND OPTIONAL PARAMETER STORE PROCEDURE       
        
MODIFIED BY: PROGRAMMER NAME        
DATED: DD/MM/YYYY        
REASON: REASON TO CHANGE STORE PROCEDURE        
**********************************************************************************/        
        
CREATE PROCEDURE USP_FIND_STMT_BYKEYWORD_IN_USP     
(        
  @DBNAME VARCHAR(500),        
  @KEY_TO_SEARCH VARCHAR(500),    
  @KEY_SP_NAME VARCHAR(500) = NULL        
)        
        
AS        
BEGIN        
        
 SET NOCOUNT ON   
-- DECLARE @DBNAME VARCHAR(500),@KEY_TO_SEARCH VARCHAR(500),@KEY_SP_NAME VARCHAR(500) = NULL    
-- SET @DBNAME='RISK'        
-- SET @KEY_TO_SEARCH=''  
-- SET  @KEY_SP_NAME VARCHAR(500) = NULL   
  
 /*****************************************************************        
 USE TO STORE PARTICULAR SP CONTAIN IN WHILE LOOP      
 ***************************************************************/      
 CREATE TABLE #TEMP    
 (     
 SP_CONTAIN VARCHAR(MAX)      
 )      
    
 /*****************************************************************        
 USE TO STORE FINAL RESULT TO DISPLAY        
 ***************************************************************/        
 CREATE TABLE #TEMP_RESULT        
 (        
 SRNO INT IDENTITY(1,1),        
 SP_NAME VARCHAR(MAX),        
 SQL_STATEMENT VARCHAR(MAX)        
 )        
    
 /*****************************************************************        
 USE TO STORE SP NAMES WHICH CONTAIN KEYWORD TO SEARCH        
 ***************************************************************/        
 CREATE TABLE #TEMP_SPNAME        
 (        
 SRNO INT IDENTITY(1,1),        
 SP_NAME VARCHAR(MAX)        
 )        
    
 /*****************************************************************        
 USE TO STORE SP CONTAIN ALONG WITH IT'S NAME        
 ***************************************************************/        
 CREATE TABLE #TEMP_SP_CONTAIN        
 (        
 SRNO INT IDENTITY(1,1),        
 SP_NAME VARCHAR(MAX),        
 SP_CONTAIN VARCHAR(MAX)        
 )        
    
 SET @KEY_TO_SEARCH  = '%' + @KEY_TO_SEARCH + '%'                  
    
 DECLARE @STR AS VARCHAR(1000)                
 SET @STR=''                
    
 IF @DBNAME <>''                
 BEGIN                
  SET @DBNAME=@DBNAME+'.DBO.'                
 END                
 ELSE                
 BEGIN                
  SET @DBNAME=DB_NAME()+'.DBO.'                
 END                
    
 SET @STR = 'SELECT DISTINCT O.NAME FROM ' + @DBNAME + 'SYSCOMMENTS  C '                 
 SET @STR = @STR + ' JOIN ' + @DBNAME +'SYSOBJECTS O ON O.ID = C.ID '    
 SET @STR = @STR + ' WHERE O.XTYPE IN (''P'')  AND C.TEXT LIKE ''' + @KEY_TO_SEARCH + ''''     
 IF ISNULL(@KEY_SP_NAME,'') <> ''                
 BEGIN    
  SET @STR = @STR + '  AND O.NAME LIKE ''' + @KEY_SP_NAME + ''''                  
 END    
    
 INSERT INTO #TEMP_SPNAME EXEC(@STR)        
    
 DECLARE @SP_COUNT INT        
 DECLARE @SP_SEARCH_NAME VARCHAR(MAX)      
    
 DECLARE @COUNT INT       
 SET @COUNT = 1       
    
 SET @SP_COUNT = (SELECT COUNT(*) FROM #TEMP_SPNAME)        
    
 /*****************************************************************        
 USE TO GET PARTICULAR STATEMENT FROM EACH STORE PROCEDURE        
 ***************************************************************/        
 IF (@SP_COUNT > 0)        
 BEGIN        
    
 WHILE( @COUNT <= @SP_COUNT )        
 BEGIN        
    
  SET @SP_SEARCH_NAME = (SELECT SP_NAME FROM #TEMP_SPNAME A WHERE A.SRNO = @COUNT)    
  INSERT INTO #TEMP EXEC SP_HELPTEXT @SP_SEARCH_NAME    
  INSERT INTO #TEMP_SP_CONTAIN SELECT @SP_SEARCH_NAME,SP_CONTAIN FROM #TEMP    
  TRUNCATE TABLE #TEMP      
    
 SET @COUNT = @COUNT + 1      
    
 END        
    
 END        
    
 INSERT INTO #TEMP_RESULT     
  SELECT SP_NAME,SP_CONTAIN     
 FROM #TEMP_SP_CONTAIN     
 WHERE SP_CONTAIN LIKE @KEY_TO_SEARCH        
    
 SELECT * FROM #TEMP_RESULT        
     
 DROP TABLE #TEMP   
 DROP TABLE #TEMP_RESULT  
 DROP TABLE #TEMP_SPNAME  
 DROP TABLE #TEMP_SP_CONTAIN  
 SET NOCOUNT OFF          
    
END

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
 ----print @dbname          
          
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '           
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '           
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''            
 --print @str          
  exec(@str)          
set nocount off

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
-- PROCEDURE dbo.USP_FusionVendorMaster_Insert_Other
-- --------------------------------------------------

CREATE PROCEDURE USP_FusionVendorMaster_Insert_Other
AS
BEGIN
----==== Generate the Vendor general details for create new vendor

SELECT 
83 'OrgId', 
'AOL' 'LEGACY_VENDOR_NUM',
TradeName+'-'+PanNo 'VENDOR_CODE',
TradeName 'Supplier_Alais_Name',
TradeName [Site Alternate Name],
TVGD.VendorNumber Site_Address_Name,  -- 
TVGD.VendorNumber VENDOR_SITE_CODE,   -- 
'RA-REMISIER' VENDOR_TYPE_LOOKUP_CODE,
'' ADDRESS_LINE1,     -- Branch
VACD.AddressLine1 'ADDRESS_LINE2', 
VACD.AddressLine2 'ADDRESS_LINE3', 
VACD.Landmark 'ADDRESS_LINE4', 
VACD.PinCode 'POSTAL_CODE',  
VACD.CITY, 
VACD.STATE, 
'IN' 'COUNTRY_CODE',
'Immediate' 'PAYMENT_TERMS',
'RTGS/NEFT' 'PAYMENT_METHOD_LOOKUP_CODE',
'Y' PAY_SITE_FLAG, 
'Y' PURCHASING_SITE_FLAG, 
'A' STATUS,
'131-351504-99999999-9999-999-999-999-99999-99999-9999-999' 'PREPAY_ACCOUNT',
'131-241105-99999999-9999-999-999-999-99999-99999-9999-999' 'LIABILITY_ACCOUNT',
'Remisier' [Attribute Context],
'' Attribute1,   --- Branch
'' Attribute2,  ---- Branch code
'' Attribute3,
VACD.City Attribute4,   
'' Attribute5,
'Y' 'HOLD_ALL_PAYMENTS_FLAG',
TVGD.PanNo PanNo,
'' as TANNO,      
'' as WARD_NO, 
'SEC. 194(H)' as SECTION_CODE,
'5' as DEFAULT_TDS_RATE,               
'' as LOWER_RATE,   
'Y' as CONFIRM_PAN_FLAG,            
CASE WHEN TVGD.Constitution= 'Individual' THEN 'INDIVIDUAL-IND'         
WHEN TVGD.Constitution= 'Proprietorship' THEN 'PROPRIETORSHIP'             
WHEN TVGD.Constitution= 'Proprietor' THEN 'PROPRIETORSHIP'    
WHEN TVGD.Constitution= 'Propritorship' THEN 'PROPRIETORSHIP'           
WHEN TVGD.Constitution= 'Corporate' THEN 'COMPANY-IND'      
WHEN TVGD.Constitution= 'Pvt Ltd' THEN 'COMPANY-IND'      
WHEN TVGD.Constitution= 'Public Ltd' THEN 'COMPANY-IND'     
WHEN TVGD.Constitution= 'Partnership' THEN 'PARTNERSHIP'   
END 'TDS_VENDOR_TYPE_LOOKUP_CODE',
'' as SERVICE_TAX_REGN_NO,   
'' as SERIVCE_TYPE,         
'' as SERVICE_TAX_CATEGORY,           
'' as CONTACT_NAME_FIRST_NAME,  
'' as CONTACT_MIDDLE_NAME,     
'' as CONTACT_LAST_NAME,  
'' as JOB_TITLE,                
'' as AREA_CODE,  
'' as PHONE,   
'' as PHONE_EXTENSION,  
 VACD.EmailId as EMAIL,
'' as FAX_CODE,  
'' as SITE_FAX,  
VBM.BankName as Bank_Name,
'HEADOFFICE'  as BANK_ADDRESS_LINE1,              
'' as BANK_ADDRESS_LINE2,  
'' as BANK_ADDRESS_LINE3,          
'' as BANK_CITY,   
'' as BANK_STATE,    
'' as BANK_POSTAL_CODE,     
'' as BANK_COUNTRY_CODE,  
VBM.Branch as BRANCH_NAME,           
VBM.BankAddress AS BRANCH_ADDRESS_LINE1,      
'' as BRANCH_ADDRESS_LINE2,    
'' as BRANCH_ADDRESS_LINE3,   
'' as BRANCH_CITY,   
'' as BRANCH_STATE,     
'' as BRANCH_POSTAL_CODE,  
'' as BRANCH_COUNTRY_CODE,              
VBM.BankAccountNo as BANK_ACCOUNT_NUM,                
VBM.IFSC_Code as Ifsc_Code,   
'' as MICR_NUMBER,
'I' AS Flag INTO #VendorDetails

FROM tbl_VendorGeneralDetails TVGD WITH(NOLOCK)
JOIN tbl_VendorAddress_ContactDetails VACD WITH(NOLOCK)
ON TVGD.VendorMasterId = VACD.VendorMasterId
JOIN tbl_VendorBankMaster VBM WITH(NOLOCK)
ON TVGD.VendorMasterId = VBM.VendorMasterId

---------=========== Generate the Fusion data for insert into the Vendor Master


SELECT ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE) 'SR_NO',*  INTO #OracleVendorDetails  
FROM(          
SELECT DISTINCT  
CASE flag            
  WHEN 'I' THEN 'CREATE'              
  WHEN 'U' THEN 'UPDATE'            
  ELSE NULL             
END as Flag            
,VENDOR_SITE_CODE 'VENDOR_CODE'
, NN.vendor_number 'vendor_number'            
,[Site Alternate Name]            
, CASE WHEN TDS_VENDOR_TYPE_LOOKUP_CODE='INDIVIDUAL-IND' THEN 'INDIVIDUAL'       
 WHEN TDS_VENDOR_TYPE_LOOKUP_CODE='COMPANY-IND' THEN 'Corporation'      
 WHEN TDS_VENDOR_TYPE_LOOKUP_CODE='PROPRIETORSHIP' THEN 'INDIVIDUAL'      
ELSE TDS_VENDOR_TYPE_LOOKUP_CODE END 'TDS_VENDOR_TYPE_LOOKUP_CODE'            
,VENDOR_TYPE_LOOKUP_CODE            
,CASE WHEN flag='U' THEN '' ELSE 'SPEND_AUTHORIZED' END  'SPEND_AUTHORIZED'          
,Supplier_Alais_Name            
,'Y' 'UsewithholdingTax'          
, CASE WHEN TDS_VENDOR_TYPE_LOOKUP_CODE='COMPANY-IND' THEN 'TDS 194H - COM BRK (C) - 2%'          
ELSE 'TDS 194H - COM BRK (NC) - 2%'          
END 'TDS_VENDOR_TYPE_LOOKUP_CODE_1'  
,TANNO            
,'Vendor_Legacy_Code'  'Vendor_Legacy_Code'          
,Attribute1            
,Attribute2            
,Attribute3            
,Attribute4            
,Attribute5            
,ADDRESS_LINE1 'AddressName'          
,'IN' 'COUNTRYCODE_1'           
,ADDRESS_LINE1            
,ADDRESS_LINE2            
,ADDRESS_LINE3            
,ADDRESS_LINE4            
, CASE WHEN ISNULL(CITY ,'')='' THEN 'DUMMY-CITY' ELSE CITY END 'CITY'          
, CASE WHEN ISNULL(STATE ,'')='' THEN 'DUMMY-STATE' ELSE STATE END 'STATE'           
,COUNTRY_CODE            
, CASE WHEN ISNULL(POSTAL_CODE,'')='' THEN 'DUMMY-PIN' ELSE POSTAL_CODE END 'POSTAL_CODE'            
,PHONE            
,PHONE_EXTENSION            
,FAX_CODE            
,SITE_FAX            
,PAY_SITE_FLAG          
,'Angel One Limited'  AS ProcurementBU          
,Site_Address_Name            
,VENDOR_SITE_CODE  'VENDOR_SITE_CODE'          
,HOLD_ALL_PAYMENTS_FLAG            
,PAYMENT_TERMS            
,'Angel One Limited' AS ClientBU          
,'Angel One Limited' AS BilltoBU          
,'131-241105-99999999-9999-999-999-999-99999-99999-9999-999'  AS LiabilityDistribution          
,'131-351504-99999999-9999-999-999-999-99999-99999-9999-999'  AS PrepaymentDistribution          
,CASE WHEN LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE))=''  THEN LEFT(VENDOR_CODE,CHARINDEX('-', VENDOR_CODE)-1)          
ELSE  LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE)-1) END 'FirstName'           
,CONTACT_MIDDLE_NAME            
, CASE WHEN SUBSTRING(VENDOR_CODE,LEN(LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE)+1)),LEN(VENDOR_CODE) - LEN(LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE))) - LEN(RIGHT(VENDOR_CODE,CHARINDEX('-', (REVERSE(VENDOR_CODE)))+1)))='' THEN 'DUMMY'            
ELSE SUBSTRING(VENDOR_CODE,LEN(LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE)+1)),LEN(VENDOR_CODE) - LEN(LEFT(VENDOR_CODE,CHARINDEX(' ', VENDOR_CODE))) - LEN(RIGHT(VENDOR_CODE,CHARINDEX('-', (REVERSE(VENDOR_CODE)))+1)))          
END 'LastName'          
,JOB_TITLE            
,AREA_CODE     
,'Angel One Limited' AS  BusinessUnitName          
,PAYMENT_METHOD_LOOKUP_CODE            
,EMAIL            
,Bank_Name            
,BRANCH_NAME            
,BANK_ACCOUNT_NUM                 
,PAY_SITE_FLAG  'PAY_SITE_FLAG_1'           
, convert(varchar(30), cast( GETDATE() as date),111) 'StartDate'          
,'' 'EndDate'          
,BRANCH_COUNTRY_CODE            
,Bank_Name  'Bank_Name1'          
,BRANCH_NAME 'BRANCH_NAME_1'           
,Ifsc_Code            
,PanNo            
,TANNO  'TANNO1'           
,COUNTRY_CODE 'COUNTRY_CODE_1'          
FROM          
  #VendorDetails MM WITH(NOLOCK)          
  LEFT JOIN [MIS].sb_comp.dbo.VENDOR_MAPPING NN WITH(NOLOCK)        
  ON MM.VENDOR_SITE_CODE = NN.vendor_name AND NN.Segment='Other'       
  ) AA          
  
-------- Final Data :- Insert Data in the Vendor Master for generate the vendor Template Report -----

 CREATE TABLE #Batch          
(BatchID varchar(50))          
INSERT into #Batch values(replace(replace(getdate(),' ','_'),'__','_'))           

    
DECLARE @MAXPayeeIdentifier NVARCHAR(20) = (SELECT DISTINCT MAX([*Payee Identifier]) FROM [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master WITH(NOLOCK) )          
        
DECLARE @BatchIdDate VARCHAR(30) = (SELECT DISTINCT TOP 1 SUBSTRING([Batch ID],1,11) [Batch ID] FROM [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master WITH(NOLOCK) ORDER BY [Batch ID] DESC)        
  
Declare @CurrentDay NVARCHAR(50) = (SELECT REPLACE(CONVERT(CHAR(10), GETDATE(), 103), '/', '')) 

--- Remove from the Vendor master
       
DELETE FROM [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master

----- New Insert

INSERT INTO [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master (            
[Batch ID]            
,[Import Action *]            
,[Supplier Name*]            
,[Supplier Number]            
,[Alternate Name]            
,[Tax Organization Type]            
,[Supplier Type]            
,[Business Relationship*]            
,[Alias]            
,[Use withholding tax]          
,[Withholding Tax Group]            
,[Tax Registration Number]            
,[ATTRIBUTE_CATEGORY]            
,[ATTRIBUTE1]            
,[ATTRIBUTE2]            
,[ATTRIBUTE3]            
,[ATTRIBUTE4]            
,[ATTRIBUTE5]            
,[Address Name *]          
,[Country]            
,[Address Line 1]            
,[Address Line 2]            
,[Address Line 3]            
,[Address Line 4]            
,[City]            
,[State]            
,[County]            
,[Postal code]            
,[Phone]            
,[Phone Extension]            
,[Fax Area Code]            
,[Fax]            
,[Pay]          
,[Procurement BU*]            
,[Address Name]            
,[Supplier Site*]            
,[Payment Hold By]            
,[Payment Terms]            
,[Client BU*]            
,[Bill-to BU]            
,[Liability Distribution]            
,[Prepayment Distribution]            
,[First Name]            
,[Middle Name]            
,[Last Name]            
,[Job Title]            
,[Mobile Area Code]                  
,[*Import Batch Identifier]          
,[*Payee Identifier]          
,[*Payee Bank Account Identifier]             
,[Business Unit Name]            
,[Payment Method Code]            
,[Remit Advice Email]            
,[**Bank Name]            
,[**Branch Name]            
,[*Account Number]                
,[*Payee Bank Account Assignment Identifier]          
,[*Primary Flag]           
,[Account Assignment Start Date]          
,[Account Assignment End Date]              
,[*Country]            
,[*Bank Name]            
,[*Branch Name]            
,[Branch Number]            
,GLOBAL_ATTRIBUTE4            
,GLOBAL_ATTRIBUTE5           
,[Account Currency Code]          
) 
          
SELECT           
(select BatchId from #Batch) 'BatchId1' ,          
flag            
,VENDOR_CODE            
,vendor_number            
,[Site Alternate Name]            
, TDS_VENDOR_TYPE_LOOKUP_CODE            
,VENDOR_TYPE_LOOKUP_CODE            
,SPEND_AUTHORIZED          
,Supplier_Alais_Name            
,UsewithholdingTax          
, TDS_VENDOR_TYPE_LOOKUP_CODE_1          
,TANNO            
,Vendor_Legacy_Code          
,Attribute1            
,Attribute2            
,Attribute3            
,Attribute4            
,Attribute5           
,VENDOR_SITE_CODE          
,COUNTRYCODE_1           
,ADDRESS_LINE1            
,ADDRESS_LINE2            
,ADDRESS_LINE3            
,ADDRESS_LINE4            
,CITY            
,STATE         
,COUNTRY_CODE            
,POSTAL_CODE            
,PHONE            
,PHONE_EXTENSION            
,FAX_CODE            
,SITE_FAX            
,PAY_SITE_FLAG          
,ProcurementBU          
,Site_Address_Name            
,VENDOR_SITE_CODE          
,HOLD_ALL_PAYMENTS_FLAG            
,PAYMENT_TERMS            
,ClientBU          
,BilltoBU          
,LiabilityDistribution          
,PrepaymentDistribution          
,FirstName           
,CONTACT_MIDDLE_NAME            
,LastName          
,JOB_TITLE            
,AREA_CODE            
,(select BatchId from #Batch) 'BatchId2'          
, CASE WHEN ISNULL(@MAXPayeeIdentifier,'')='' OR (select SUBSTRING(BatchId,1,11) from #Batch) <>  @BatchIdDate  THEN  (CAST(@CurrentDay as varchar(20)) +''+ cast((ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE)) as varchar(20)))          
ELSE (cast(@MAXPayeeIdentifier as bigint) + (ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE)) ) END 'SR1'           
, CASE WHEN ISNULL(@MAXPayeeIdentifier,'')='' OR (select SUBSTRING(BatchId,1,11) from #Batch) <>  @BatchIdDate  THEN  (CAST(@CurrentDay as varchar(20)) +''+ cast((ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE)) as varchar(20)))          
ELSE (cast(@MAXPayeeIdentifier as bigint) +(ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE))) END 'SR2'           
,BusinessUnitName          
,PAYMENT_METHOD_LOOKUP_CODE            
,EMAIL            
,Bank_Name            
,BRANCH_NAME            
,BANK_ACCOUNT_NUM            
, CASE WHEN ISNULL(@MAXPayeeIdentifier,'')='' OR (select SUBSTRING(BatchId,1,11) from #Batch) <>  @BatchIdDate  THEN  (CAST(@CurrentDay as varchar(20)) +''+ cast((ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE)) as varchar(20)))          
ELSE (cast(@MAXPayeeIdentifier as bigint) +(ROW_NUMBER() OVER(ORDER BY VENDOR_SITE_CODE))) END 'SR3'          
,PAY_SITE_FLAG_1           
,StartDate          
,EndDate              
,BRANCH_COUNTRY_CODE            
,Bank_Name1          
,BRANCH_NAME_1           
,Ifsc_Code            
,PanNo            
,TANNO1          
,COUNTRY_CODE_1        
FROM #OracleVendorDetails

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateOracleVendorCreationProcessTemplateReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GenerateOracleVendorCreationProcessTemplateReport] 
AS  
BEGIN  
  
--SupplierImport:  
  
SELECT case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *], [Supplier Name*],[Supplier Name New],[Supplier Number],[Alternate Name],[Tax Organization Type],[Supplier Type],[Inactive Date],[Business Relationship*],[Parent Supplier],Alias,[D-U-N-S Number],[One-time supplier],[Customer Number],SIC,[National Insurance Number],[Corporate Web Site],[Chief Executive Title],[Chief Executive Name],[Business Classifications Not Applicable],[Taxpayer Country],[Taxpayer ID],[Federal reportable],[Federal Income Tax Type],[State reportable],[Tax Reporting Name],[Name Control],[Tax Verification Date],[Use withholding tax],[Withholding Tax Group],[Vat Code],GLOBAL_ATTRIBUTE4 [Tax Registration Number],[Auto Tax Calc Override],[Payment Method],[Delivery Channel],[Bank Instruction 1],[Bank Instruction 2],[Bank Instruction],[Settlement Priority],[Payment Text Message 1],[Payment Text Message 2],[Payment Text Message 3],[Bank Charge Bearer],[Payment Reason],[Payment Reason Comments],[Payment Format],ATTRIBUTE_CATEGORY,'' ATTRIBUTE1,'' ATTRIBUTE2,'' ATTRIBUTE3,GLOBAL_ATTRIBUTE4 ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_TIMESTAMP1,ATTRIBUTE_TIMESTAMP2,ATTRIBUTE_TIMESTAMP3,ATTRIBUTE_TIMESTAMP4,ATTRIBUTE_TIMESTAMP5,ATTRIBUTE_TIMESTAMP6,ATTRIBUTE_TIMESTAMP7,ATTRIBUTE_TIMESTAMP8,ATTRIBUTE_TIMESTAMP9,ATTRIBUTE_TIMESTAMP10,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,GLOBAL_ATTRIBUTE_CATEGORY,GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,GLOBAL_ATTRIBUTE6,GLOBAL_ATTRIBUTE7,GLOBAL_ATTRIBUTE8,GLOBAL_ATTRIBUTE9,GLOBAL_ATTRIBUTE10,GLOBAL_ATTRIBUTE11,GLOBAL_ATTRIBUTE12,GLOBAL_ATTRIBUTE13,GLOBAL_ATTRIBUTE14,GLOBAL_ATTRIBUTE15,GLOBAL_ATTRIBUTE16,GLOBAL_ATTRIBUTE17,GLOBAL_ATTRIBUTE18,GLOBAL_ATTRIBUTE19,GLOBAL_ATTRIBUTE20,GLOBAL_ATTRIBUTE_DATE1,GLOBAL_ATTRIBUTE_DATE2,GLOBAL_ATTRIBUTE_DATE3,GLOBAL_ATTRIBUTE_DATE4,GLOBAL_ATTRIBUTE_DATE5,GLOBAL_ATTRIBUTE_DATE6,GLOBAL_ATTRIBUTE_DATE7,GLOBAL_ATTRIBUTE_DATE8,GLOBAL_ATTRIBUTE_DATE9,GLOBAL_ATTRIBUTE_DATE10,GLOBAL_ATTRIBUTE_TIMESTAMP1,GLOBAL_ATTRIBUTE_TIMESTAMP2,GLOBAL_ATTRIBUTE_TIMESTAMP3,GLOBAL_ATTRIBUTE_TIMESTAMP4,GLOBAL_ATTRIBUTE_TIMESTAMP5,GLOBAL_ATTRIBUTE_TIMESTAMP6,GLOBAL_ATTRIBUTE_TIMESTAMP7,GLOBAL_ATTRIBUTE_TIMESTAMP8,GLOBAL_ATTRIBUTE_TIMESTAMP9,GLOBAL_ATTRIBUTE_TIMESTAMP10,GLOBAL_ATTRIBUTE_NUMBER1,GLOBAL_ATTRIBUTE_NUMBER2,GLOBAL_ATTRIBUTE_NUMBER3,GLOBAL_ATTRIBUTE_NUMBER4,GLOBAL_ATTRIBUTE_NUMBER5,GLOBAL_ATTRIBUTE_NUMBER6,GLOBAL_ATTRIBUTE_NUMBER7,GLOBAL_ATTRIBUTE_NUMBER8,GLOBAL_ATTRIBUTE_NUMBER9,GLOBAL_ATTRIBUTE_NUMBER10,[Batch ID],[Registry ID],[Payee Service Level],[Pay Each Document Alone],[Delivery Method],[Remittance E-mail],[Remittance Fax],[DataFox ID], 'END' as 'END' from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm --- WHERE ISNULL([Supplier Number],'')<>''
    
  
--SupplierAddress:  
  
SELECT case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *], [Supplier Name*],[Address Name *],[Address Name New],[Country],[Address Line 1],REPLACE([Address Line 2],',',' ') [Address Line 2],REPLACE([Address Line 3],',',' ') [Address Line 3],REPLACE([Address Line 4],',',' ') [Address Line 4],[Phonetic Address Line],[Address Element Attribute 1],[Address Element Attribute 2],[Address Element Attribute 3],[Address Element Attribute 4],[Address Element Attribute 5],[Building],[Floor Number],[City],[State],[Province],[County],[Postal code],[Postal Plus 4 code],[Addressee],[Global Location Number],[Language],[Inactive Date],[Phone Country Code],[Phone Area Code],[Phone],[Phone Extension],[Fax Country Code],[Fax Area Code],[Fax],[RFQ Or Bidding],[Ordering],[Pay],''[ATTRIBUTE_CATEGORY],'' [ATTRIBUTE1],'' [ATTRIBUTE2],'' [ATTRIBUTE3],'' [ATTRIBUTE4],[ATTRIBUTE5],[ATTRIBUTE6],[ATTRIBUTE7],[ATTRIBUTE8],[ATTRIBUTE9],[ATTRIBUTE10],[ATTRIBUTE11],[ATTRIBUTE12],[ATTRIBUTE13],[ATTRIBUTE14],[ATTRIBUTE15],[ATTRIBUTE16],[ATTRIBUTE17],[ATTRIBUTE18],[ATTRIBUTE19],[ATTRIBUTE20],[ATTRIBUTE21],[ATTRIBUTE22],[ATTRIBUTE23],[ATTRIBUTE24],[ATTRIBUTE25],[ATTRIBUTE26],[ATTRIBUTE27],[ATTRIBUTE28],[ATTRIBUTE29],[ATTRIBUTE30],[ATTRIBUTE_NUMBER1],[ATTRIBUTE_NUMBER2],[ATTRIBUTE_NUMBER3],[ATTRIBUTE_NUMBER4],[ATTRIBUTE_NUMBER5],[ATTRIBUTE_NUMBER6],[ATTRIBUTE_NUMBER7],[ATTRIBUTE_NUMBER8],[ATTRIBUTE_NUMBER9],[ATTRIBUTE_NUMBER10],[ATTRIBUTE_NUMBER11],[ATTRIBUTE_NUMBER12],[ATTRIBUTE_DATE1],[ATTRIBUTE_DATE2],[ATTRIBUTE_DATE3],[ATTRIBUTE_DATE4],[ATTRIBUTE_DATE5],[ATTRIBUTE_DATE6],[ATTRIBUTE_DATE7],[ATTRIBUTE_DATE8],[ATTRIBUTE_DATE9],[ATTRIBUTE_DATE10],[ATTRIBUTE_DATE11],[ATTRIBUTE_DATE12],[E-Mail],[Batch ID],'','','','','','','','','','','','','','','','', 'END' as 'END' from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm ---WHERE ISNULL([Supplier Number],'')<>''  
    
  
--SupplierSiteImport:  
--1. PozSupplierSitesInt  
  
SELECT case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *],[Supplier Name*],[Procurement BU*],[Address Name],[Supplier Site*],[Supplier Site New],[Inactive Date],'N'[Sourcing only],'Y'[Purchasing],'Y'[Procurement card],[Pay],[Primary Pay],'N' [Income tax reporting site],[Alternate Site Name],[Customer Number],[B2B Communication Method],[B2B Supplier Site Code],[Communication Method],[E-Mail],[Fax Country Code],[Fax Area Code],[Fax],[Hold all new purchasing documents],[Hold Reason],[Carrier],[Mode of Transport],[Service Level],[Freight Terms],[Pay on receipt],[FOB],[Country of Origin],[Buyer Managed Transportation],[Pay on use],[Aging Onset Point],[Aging Period Days],[Consumption Advice Frequency],[Consumption Advice Summary],[Default Pay Site],[Invoice Summary Level],[Gapless invoice numbering],[Selling Company Identifier],[Create debit memo from return],[Ship-to Exception Action],[Receipt Routing],[Over-receipt Tolerance],[Over-receipt Action],[Early Receipt Tolerance in Days],[Late Receipt Tolerance in Days],[Allow Substitute Receipts],[Allow unordered receipts],[Receipt Date Exception],[Invoice Currency],[Invoice Amount Limit],[Invoice Match Option],[Match Approval Level],[Payment Currency],[Payment Priority],[Pay Group],[Quantity Tolerances],[Amount Tolerance],[Hold All Invoices],[Hold Unmatched Invoices],[Hold Unvalidated Invoices],''[Payment Hold By],[Payment Hold Date],[Payment Hold Reason],'' [Payment Terms],[Terms Date Basis],[Pay Date Basis],[Bank Charge Deduction Type],[Always Take Discount],[Exclude Freight From Discount],[Exclude Tax From Discount],[Create Interest Invoices],[Vat Code],[Tax Registration Number],'REM-DEFAULT'[Payment Method],[Delivery Channel],[Bank Instruction 1],[Bank Instruction 2],[Bank Instruction],[Settlement Priority],[Payment Text Message 1],[Payment Text Message 2],[Payment Text Message 3],[Bank Charge Bearer],[Payment Reason],[Payment Reason Comments],[Delivery Method],[Remittance E-Mail],[Remittance Fax],'Remisier'[ATTRIBUTE_CATEGORY],[ATTRIBUTE1],'' [ATTRIBUTE2],'' [ATTRIBUTE3],'' [ATTRIBUTE4],[ATTRIBUTE5],[ATTRIBUTE6],[ATTRIBUTE7],[ATTRIBUTE8],[ATTRIBUTE9],[ATTRIBUTE10],[ATTRIBUTE11],[ATTRIBUTE12],[ATTRIBUTE13],[ATTRIBUTE14],[ATTRIBUTE15],[ATTRIBUTE16],[ATTRIBUTE17],[ATTRIBUTE18],[ATTRIBUTE19],[ATTRIBUTE20],[ATTRIBUTE_DATE1],[ATTRIBUTE_DATE2],[ATTRIBUTE_DATE3],[ATTRIBUTE_DATE4],[ATTRIBUTE_DATE5],[ATTRIBUTE_DATE6],[ATTRIBUTE_DATE7],[ATTRIBUTE_DATE8],[ATTRIBUTE_DATE9],[ATTRIBUTE_DATE10],[ATTRIBUTE_TIMESTAMP1],[ATTRIBUTE_TIMESTAMP2],[ATTRIBUTE_TIMESTAMP3],[ATTRIBUTE_TIMESTAMP4],[ATTRIBUTE_TIMESTAMP5],[ATTRIBUTE_TIMESTAMP6],[ATTRIBUTE_TIMESTAMP7],[ATTRIBUTE_TIMESTAMP8],[ATTRIBUTE_TIMESTAMP9],[ATTRIBUTE_TIMESTAMP10],[ATTRIBUTE_NUMBER1],[ATTRIBUTE_NUMBER2],[ATTRIBUTE_NUMBER3],[ATTRIBUTE_NUMBER4],[ATTRIBUTE_NUMBER5],[ATTRIBUTE_NUMBER6],[ATTRIBUTE_NUMBER7],[ATTRIBUTE_NUMBER8],[ATTRIBUTE_NUMBER9],[ATTRIBUTE_NUMBER10],[GLOBAL_ATTRIBUTE_CATEGORY],[GLOBAL_ATTRIBUTE1],[GLOBAL_ATTRIBUTE2],[GLOBAL_ATTRIBUTE3],'' [GLOBAL_ATTRIBUTE4],[GLOBAL_ATTRIBUTE5],[GLOBAL_ATTRIBUTE6],[GLOBAL_ATTRIBUTE7],[GLOBAL_ATTRIBUTE8],[GLOBAL_ATTRIBUTE9],[GLOBAL_ATTRIBUTE10],[GLOBAL_ATTRIBUTE11],[GLOBAL_ATTRIBUTE12],[GLOBAL_ATTRIBUTE13],[GLOBAL_ATTRIBUTE14],[GLOBAL_ATTRIBUTE15],[GLOBAL_ATTRIBUTE16],[GLOBAL_ATTRIBUTE17],[GLOBAL_ATTRIBUTE18],[GLOBAL_ATTRIBUTE19],[GLOBAL_ATTRIBUTE20],[GLOBAL_ATTRIBUTE_DATE1],[GLOBAL_ATTRIBUTE_DATE2],[GLOBAL_ATTRIBUTE_DATE3],[GLOBAL_ATTRIBUTE_DATE4],[GLOBAL_ATTRIBUTE_DATE5],[GLOBAL_ATTRIBUTE_DATE6],[GLOBAL_ATTRIBUTE_DATE7],[GLOBAL_ATTRIBUTE_DATE8],[GLOBAL_ATTRIBUTE_DATE9],[GLOBAL_ATTRIBUTE_DATE10],[GLOBAL_ATTRIBUTE_TIMESTAMP1],[GLOBAL_ATTRIBUTE_TIMESTAMP2],[GLOBAL_ATTRIBUTE_TIMESTAMP3],[GLOBAL_ATTRIBUTE_TIMESTAMP4],[GLOBAL_ATTRIBUTE_TIMESTAMP5],[GLOBAL_ATTRIBUTE_TIMESTAMP6],[GLOBAL_ATTRIBUTE_TIMESTAMP7],[GLOBAL_ATTRIBUTE_TIMESTAMP8],[GLOBAL_ATTRIBUTE_TIMESTAMP9],[GLOBAL_ATTRIBUTE_TIMESTAMP10],[GLOBAL_ATTRIBUTE_NUMBER1],[GLOBAL_ATTRIBUTE_NUMBER2],[GLOBAL_ATTRIBUTE_NUMBER3],[GLOBAL_ATTRIBUTE_NUMBER4],[GLOBAL_ATTRIBUTE_NUMBER5],[GLOBAL_ATTRIBUTE_NUMBER6],[GLOBAL_ATTRIBUTE_NUMBER7],[GLOBAL_ATTRIBUTE_NUMBER8],[GLOBAL_ATTRIBUTE_NUMBER9],[GLOBAL_ATTRIBUTE_NUMBER10],[Required Acknowledgement],[Acknowledge Within Days],[Invoice Channel],[Batch ID],[Payee Service Level],[Pay Each Document Alone], '' [Override B2B Communication for Special Handling Orders], 'END' as 'END' from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm ---WHERE ISNULL([Supplier Number],'')<>''  
  
  
--2. PozSupThirdPartyInt:  
  
-- create blank     
select [Batch ID],case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *],[Supplier Name*],[Supplier Site*],[Procurement BU*],[Default],[Remit-to Supplier*],[Address Name*],[From Date],[To Date],[Description], 'END' as 'END' from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm ---WHERE ISNULL([Batch ID],'')=''  
  
--SupplierSiteAssignement:  
  
SELECT case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *],[Supplier Name*],[Supplier Site*],[Procurement BU*],[Client BU*],[Bill-to BU],[Ship-to Location],[Bill-to Location],[Use Withholding Tax],[Withholding Tax Group],[Liability Distribution],[Prepayment Distribution],[Bills Payable Distribution],[Distribution Set],[Inactive Date],[Batch ID], 'END' as 'END' from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm --- WHERE ISNULL([Supplier Number],'')<>''  
  
--SupplierContacts:  
  
--1. PozSupContactsInt:  
---not to create  select case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *],[Supplier Name*],[Prefix],[First Name],[First Name New],[Middle Name],[Last Name],[Last Name New],[Job Title],[Administrative Contact],[E-Mail],[E-Mail New],[Phone Country Code],[Phone Area Code],[Phone],[Phone Extension],[Fax Country Code],[Fax Area Code],[Fax],[Mobile Country Code],[Mobile Area Code],[Mobile],[Inactive Date],''[ATTRIBUTE_CATEGORY],'' [ATTRIBUTE1],'' [ATTRIBUTE2],'' [ATTRIBUTE3],'' [ATTRIBUTE4],[ATTRIBUTE5],[ATTRIBUTE6],[ATTRIBUTE7],[ATTRIBUTE8],[ATTRIBUTE9],[ATTRIBUTE10],[ATTRIBUTE11],[ATTRIBUTE12],[ATTRIBUTE13],[ATTRIBUTE14],[ATTRIBUTE15],[ATTRIBUTE16],[ATTRIBUTE17],[ATTRIBUTE18],[ATTRIBUTE19],[ATTRIBUTE20],[ATTRIBUTE21],[ATTRIBUTE22],[ATTRIBUTE23],[ATTRIBUTE24],[ATTRIBUTE25],[ATTRIBUTE26],[ATTRIBUTE27],[ATTRIBUTE28],[ATTRIBUTE29],[ATTRIBUTE30],[ATTRIBUTE_NUMBER1],[ATTRIBUTE_NUMBER2],[ATTRIBUTE_NUMBER3],[ATTRIBUTE_NUMBER4],[ATTRIBUTE_NUMBER5],[ATTRIBUTE_NUMBER6],[ATTRIBUTE_NUMBER7],[ATTRIBUTE_NUMBER8],[ATTRIBUTE_NUMBER9],[ATTRIBUTE_NUMBER10],[ATTRIBUTE_NUMBER11],[ATTRIBUTE_NUMBER12],[ATTRIBUTE_DATE1],[ATTRIBUTE_DATE2],[ATTRIBUTE_DATE3],[ATTRIBUTE_DATE4],[ATTRIBUTE_DATE5],[ATTRIBUTE_DATE6],[ATTRIBUTE_DATE7],[ATTRIBUTE_DATE8],[ATTRIBUTE_DATE9],[ATTRIBUTE_DATE10],[ATTRIBUTE_DATE11],[ATTRIBUTE_DATE12],[Batch ID],[User Account Action],[Role 1],[Role 2],[Role 3],[Role 4],[Role 5], 'END' as 'END' from OracleVendorMaster.dbo.Vendor_Master vm  
  
--2. PozSupContactAddressesInt  
  
---not to create  select case when [Import Action *] = 'I' THEN 'CREATE' WHEN [Import Action *] = 'U' THEN 'UPDATE' ELSE [Import Action *] END AS [Import Action *],[Supplier Name*],[Address Name *],[First Name],[Last Name],[E-Mail],[Batch ID], 'END' as 'END' from OracleVendorMaster.dbo.Vendor_Master vm  
  
--SupplierbankAccount:  
  
--1. IbyTempPmtInstrUses:  
  
SELECT [*Import Batch Identifier],[*Payee Identifier],[*Payee Bank Account Identifier],[*Payee Bank Account Assignment Identifier],[*Primary Flag],[Account Assignment Start Date],[Account Assignment End Date] from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm 
--WHERE ISNULL([Supplier Number],'')<>''  
  
--2. IbyTempExtBankAccts:  
SELECT [*Import Batch Identifier],[*Payee Identifier],[*Payee Bank Account Identifier],[**Bank Name],REPLACE([**Branch Name],',',' ') [**Branch Name],[*Account Country Code],[Account Name],[*Account Number],[Account Currency Code],[Allow International Payments],[Account Start Date],[Account End Date],[IBAN],[Check Digits],[Account Alternate Name],[Account Type Code],[Account Suffix],[Account Description],[Agency Location Code],[Exchange Rate Agreement Number],[Exchange Rate Agreement Type],[Exchange Rate],[Secondary Account Reference],[Attribute Category],[Attribute 1],[Attribute 2],[Attribute 3],[Attribute 4],[Attribute 5],[Attribute 6],[Attribute 7],[Attribute 8],[Attribute 9],[Attribute 10],[Attribute 11],[Attribute 12],[Attribute 13],[Attribute 14],[Attribute 15] from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm ---WHERE ISNULL([Supplier Number],'')<>''  
  
--3. IbyTempExtPayees:  
SELECT [*Import Batch Identifier] , [*Payee Identifier] , [Business Unit Name] , [Supplier Number] , [Supplier Site*] , [*Pay Each Document Alone] , [Payment Method Code] , [Delivery Channel Code] , [Settlement Priority] , [Remit Delivery Method] , [Remit Advice Email] , [Remit Advice Fax] , [Bank Instructions 1] , [Bank Instructions 2] , [Bank Instruction Details] , [Payment Reason Code] , [Payment Reason Comments] , [Payment Message1] , [Payment Message2] , [Payment Message3] , [Bank Charge Bearer Code] from [ABCSOORACLEMDLW].OracleVendorMaster.dbo.Vendor_Master vm ---WHERE ISNULL([Supplier Number],'')<>''  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetAndSaveCRMS_InsuranceCompanyColumnSelectionDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetAndSaveCRMS_InsuranceCompanyColumnSelectionDetails  
@CompanyName VARCHAR(25)='',@ColumnId bigint=0 ,@IsUpdate bit=0,@IsReport bit=0
AS  
BEGIN  

IF(@IsUpdate=1)
BEGIN
UPDATE tbl_CRMS_InsuranceSelectedColumnsDetails SET IsSelected=1,SelectedDate=GETDATE()
WHERE ColumnId=@ColumnId
END
ELSE IF(@IsReport=1)
BEGIN

DECLARE @cols nvarchar(max),@tableName VARCHAR(225)=''
SELECT @cols =  STRING_AGG(QUOTENAME(ColumnName), ', ')
FROM (SELECT DISTINCT ColumnName FROM tbl_CRMS_InsuranceSelectedColumnsDetails CD
WHERE IsSelected=1 AND CompanyName=@CompanyName) AS d;

SET @tableName = (SELECT TOP 1 TableName FROM tbl_CRMS_InsuranceSelectedColumnsDetails CD
WHERE IsSelected=1 AND CompanyName=@CompanyName)

EXEC('
SELECT '+@cols+' FROM '+@tableName+'
')

END
ELSE
BEGIN
SELECT ColumnId,ColumnName,TableName,CompanyName,IsSelected  
FROM tbl_CRMS_InsuranceSelectedColumnsDetails WITH(NOLOCK)  
WHERE CompanyName = @CompanyName  
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetAngel_CRMS_InsuranceAndTableDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetAngel_CRMS_InsuranceAndTableDetails     
@tableName VARCHAR(355)='',@IsCompanyDetails bit=0    
AS    
BEGIN    
    
IF(@IsCompanyDetails=1)    
BEGIN    
    
SELECT ROW_NUMBER() OVER(ORDER BY Company) 'SRNo' ,* FROM (    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Care' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Care_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(Business_Type,'')<>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Reliance' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Reliance_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(PolicyNo,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Tata' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Tata_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(POLNUM,'')<>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'ICICI' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_ICICI_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(Policy_Number,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'ICICI_Lomboard' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_ICICI_Lomboard_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(POL_NUM,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Apollo' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Apollo_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(POLICY_NUMBER,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Niva_Bupa' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Niva_Bupa_InsuranceDetails WITH(NOLOCK)     
WHERE ISNULL(Application_Number,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'HDFC' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_HDFC_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(APPLICATION_NO,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Go_Digit' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Go_Digit_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(Policy_Number,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'Cigna' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Cigna_InsuranceDetails WITH(NOLOCK)    
WHERE ISNULL(Policy_Number,'') <>''    
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'ERGO' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Ergo_InsuranceDetails WITH(NOLOCK)     
WHERE ISNULL(Policy_No,'')<>''      
UNION    
SELECT CONVERT(VARCHAR(10),MAX(UploadedDate),103) 'UploadedDate',    
'BAJAJ' 'Company',COUNT(*) 'TotalRecords'    
FROM tbl_Angel_CRMS_Bajaj_InsuranceDetails WITH(NOLOCK)     
WHERE ISNULL(Policy_Number,'')<>''    
    
)AA    
    
    
END    
ELSE    
BEGIN    
IF(@tableName<>'')    
BEGIN    
SELECT NAME FROM sys.tables WHERE NAME =  @tableName    
END    
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetAngelCRMS_InsurancePolicyDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetAngelCRMS_InsurancePolicyDetails @PolicyNo VARCHAR(55)=''
AS
BEGIN
SELECT ISNULL(Policy_Number,'') 'PolicyNo',ISNULL(Application_No,'') 'ApplicationNo',ISNULL(Product_Code,'') 'ProductCode',
ISNULL(Product_Name,'') 'ProductName',ISNULL(SumInsured,0) 'SumInsured',
ISNULL(Customer_Name,'') 'CustomerName',
ISNULL(Email,'') 'Email',ISNULL(Mobile_Number,'') 'MobileNo',ISNULL(Gender,'') 'Gender',
ISNULL(PAN_Number,'') 'PanNo' 
FROM tbl_Angel_CRMS_ICICI_InsuranceDetails WITH(NOLOCK)
WHERE ISNULL(Policy_Number,'')=@PolicyNo
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetBankDetailsUsingIFSCCode
-- --------------------------------------------------

CREATE PROCEDURE USP_GetBankDetailsUsingIFSCCode @IFSCCode  VARCHAR(18)        
AS        
BEGIN        
SELECT TOP 1 Bank_Name,Branch_Name,Branch_Address,Micr_Code       
 FROM [INTRANET].[RISK].dbo.RTGS_MASTER WITH(NOLOCK)         
WHERE Ifsc_Code= @IFSCCode        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetRA_VendorOnBoardingDetails
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetRA_VendorOnBoardingDetails    
AS    
BEGIN    
SELECT     
SBVM.VendorMasterId,SBVM.VendorNumber,SBVM.TradeName,SBVM.IndividualName_Prop_sole,SBVM.Constitution,
SBVM.TotalDirectors,SBVM.PanNo 'PanNo',SBVM.DateOfIncorporation,SBVM.CreatedBy,
CONVERT(VARCHAR(10),SBVM.CreationDate,103) 'CreationDate', 
IIF(SBVM.IsPanDocumentUploaded=1,'Uploaded','Not Uploaded') 'IsPanDocumentUploaded',
CONVERT(VARCHAR(10),SBVM.PanDocumentUploadedDate,103) 'PanDocumentUploadedDate',
IsFinalSubmit,CONVERT(VARCHAR(10),FinalSubmittionDate,103) 'FinalSubmittionDate',

VACD.AddType,VACD.AddressLine1,VACD.AddressLine2,VACD.Landmark,VACD.City,VACD.State,VACD.Country,VACD.PinCode,
VACD.Std,VACD.Phone,VACD.MobileNo,VACD.EmailId,
IIF(VACD.IsAddressDocUploaded=1,'Uploaded','Not Uploaded') 'IsAddressDocUploaded',
CONVERT(VARCHAR(10),VACD.AddressDocUploadedDate,103) 'AddressDocUploadedDate',
IIF(VACD.IsAggrementDocUploaded=1,'Uploaded','Not Uploaded') 'IsAggrementDocUploaded',
CONVERT(VARCHAR(10),VACD.AggrementDocUploadedDate,103) 'AggrementDocUploadedDate',
IIF(VACD.IsMOA_DocUploaded=1,'Uploaded','Not Uploaded') 'IsMOA_DocUploaded',
CONVERT(VARCHAR(10),VACD.MOA_DocUploadedDate,103) 'MOA_DocUploadedDate',
IIF(VACD.IsIncorporationCertificateDocUploaded=1,'Uploaded','Not Uploaded') 'IsIncorporationCertificateDocUploaded',
CONVERT(VARCHAR(10),VACD.IncorporationCertificateDocUploadedDate,103) 'IncorporationCertificateDocUploadedDate',
VBM.BankAccountNo,VBM.IFSC_Code,VBM.MICR_No,VBM.BankName,VBM.Branch,VBM.NameInBank,
VBM.BankAddress,VBM.City 'BankCity',VBM.State 'BankState',VBM.PinCode 'BankPinCode',VBM.AccountType,
IIF(VBM.IsCancelChequeDocUploaded=1,'Uploaded','Not Uploaded') IsCancelChequeDocUploaded,
CONVERT(VARCHAR(10),VBM.CancelChequeDocUploadedDate,103) 'CancelChequeDocUploadedDate',
VGSTD.PanNo 'GstPanNo' ,VGSTD.TradeName 'GstTradeName',VGSTD.GSTIN,
CONVERT(VARCHAR(10),VGSTD.GSTRegDate,103) 'GSTRegDate',
VGSTD.FullAddress 'GstAddress',VGSTD.State 'GstState',VGSTD.PinCode 'GstPinCode',
IIF(VGSTD.IsGstCertificateDocumentUpload=1,'Uploaded','Not Uploaded') IsGstCertificateDocumentUpload,
CONVERT(VARCHAR(10),GstCertificateDocUploadedDate,103) GstCertificateDocUploadedDate

    
FROM tbl_VendorGeneralDetails SBVM WITH(NOLOCK)    
LEFT JOIN tbl_VendorAddress_ContactDetails VACD WITH(NOLOCK)    
ON SBVM.VendorMasterId = VACD.VendorMasterId    
LEFT JOIN tbl_VendorBankMaster VBM WITH(NOLOCK)    
ON SBVM.VendorMasterId = VBM.VendorMasterId    
LEFT JOIN tbl_VendorGST_Details VGSTD WITH(NOLOCK)    
ON SBVM.VendorMasterId = VGSTD.VendorMasterId   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetVendorMasterDirector_PartnersDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetVendorMasterDirector_PartnersDetails @PanNo VARCHAR(15)=''    
AS    
BEGIN    
SELECT
VDPD.PartnersId,SBVM.VendorMasterId,SBVM.PanNo,SBVM.TotalDirectors,
VDPD.Type,VDPD.Name 'PartnersName',VDPD.PanNo 'PartnersPanNo',
VDPD.RatioPercentage 'PartnersSharingPercentage',VDPD.Gender,
VDPD.AddressLine1 'PartnersAddressLine1',VDPD.AddressLine2 'PartnersAddressLine2',
VDPD.Landmark 'PartnersLandmark',VDPD.City 'PartnersCity',VDPD.State 'PartnersState',VDPD.PinCode 'PartnersPinCode'
,VDPD.Std 'PartnersStd',VDPD.PhoneNo,VDPD.MobileNo 'PartnersMobileNo',VDPD.EmailId 'PartnersEmailId',
IIF(VDPD.IsPanDocumentUploaded=1,'Uploaded','Not Uploaded') 'IsPanDocumentUploaded',
CONVERT(VARCHAR(10),PanDocUploadedDate,103) 'PanDocUploadedDate',
IIF(VDPD.IsAddressDocumentUploaded=1,'Uploaded','Not Uploaded') 'IsAddressDocumentUploaded',
CONVERT(VARCHAR(10),VDPD.AddressDocUploadedDate,103) 'AddressDocUploadedDate',
EntryBy,CONVERT(VARCHAR(10),EntryDate,103) 'EntryDate'

FROM tbl_VendorGeneralDetails SBVM WITH(NOLOCK)  
JOIN tbl_VendorDirectors_PartnersDetails VDPD WITH(NOLOCK)    
ON SBVM.VendorMasterId = VDPD.VendorMasterId    
WHERE SBVM.PanNo=@PanNo    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_nbfcledger_mail
-- --------------------------------------------------
CREATE proc usp_nbfcledger_mail                      
as     

DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp              
                                          
declare @mess as varchar(4000),                                                          
@clcode as varchar(50),@name as varchar(100),@email as varchar(100)                                                                                                        
                      
set @mess='Dear Sir/Madam,<br><br><br>                          
We are enclosing a copy of your ledger accounts, Since inception of your account till 31st March 2009.<br><br>                          
In case, you notice any discrepancy in the Statement or if the balance as per your books is different from the above, please inform us within 30 days, failing which it will be assumed that you confirm the Ledger balance as correct.                        
  
<br><br>        
We request you to note that we have set up a dedicated helpdesk to look into any queries you may have. You may write to us at Marginfunding@angeltrade.com or call on 022-67078503.                 
<br>                          
<br>                          
<br>                        
<br>                          
<br>                          
<br>                                          
                          
Thanks & Regards,                          
<br>                          
<br>                          
<br>                         
Margin Funding Team                          
<br>                                           
'                              
                          
                              
DECLARE email_nbfc_cursor CURSOR FOR                         
select distinct clientcode,name,emailid from MARGINFIN.accountnbfc.dbo.totalnbfc where email=1  and flag='N'                                                                                                                                                   
  
                   
      
                    
                                                                                     
OPEN email_nbfc_cursor                                                                                         
FETCH NEXT FROM email_nbfc_cursor                                                                                                             
INTO @clcode,@name,@email                                       
WHILE @@FETCH_STATUS = 0                                                                                                            
BEGIN                       
                                                                                 
                      
declare @attach as varchar(500)                                         
set @attach='\\196.1.115.136\d$\upload1\Preetam\file___D__t2h_ledger_'+@clcode+'.pdf;'                              
--set @attach='\\196.1.115.136\d$\NBFCLedger.pdf;'        
      
                      
 exec intranet.msdb.dbo.sp_send_dbmail                 
@recipients  = @email,                       
--@cc= @remail,                      
--@TO = 'preetam.patil@angeltrade.com',                       
@blind_copy_recipients = 'Vishal.Rao@angeltrade.com;preetam.patil@angeltrade.com',
@profile_name = 'Marginfunding',                      
--@from =' Marginfunding@angeltrade.com',                                
@body_format ='html',                                                          
@subject = 'Sub: Statement of Account of Margin Funding Facility',                            
@file_attachments =@attach,                                                                       
@body =@mess                                                            
                                                        
update   MARGINFIN.accountnbfc.dbo.totalnbfc set flag='Y'    where clientcode=@clcode      
      
FETCH NEXT FROM email_nbfc_cursor                                                                                                             INTO @clcode,@name,@email                       
END                     
CLOSE email_nbfc_cursor                                                                                                
DEALLOCATE email_nbfc_cursor

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_one
-- --------------------------------------------------
CREATE procedure usp_one(@fdate as varchar(12),@tdate as varchar(12))  
as  
delete from utd_Qualityfeedback
declare @total as varchar(15),@one as varchar(15),@two as varchar(15),@three as varchar(15),@four as varchar(15),@five as varchar(15),@six as varchar(15) 

------------------------------------------Question one
select @total=count(*) from  udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <=@tdate + ' 23:59'  
print @total  
  
select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  stands_apart like '%Personalized services of Angel Branches and Channel partners%'  
print @one  
  
select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  stands_apart like '%State of the art technology with its web-enabled back office and trading platform%'  
print @two  
  
select @Three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  stands_apart like '%Retail focused research and advisory%'  
print @three  
  
  
select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  stands_apart like '%Cost effectiveness of our services and products%'  
print @four  
  
  
select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  stands_apart not in ('Personalized services of Angel Branches and Channel partners','State of the art technology with its web-enabled back office and trading platform','Retail focused research and advisory','Cost effectiveness of our services and products')  
print @five  
  
insert into utd_Qualityfeedback
(questions,Total,optioin_1,option_2,option_3,option_4,option_5)
values ('1',@total,@one,@two,@three,@four,@five)
------------------------------------------------------------------------------End one

   
------------------second question---------------------------------
--declare @one varchar(10)
select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%Broking%'  
print @one  
--Declare @two varchar(10)
select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%E-Broking%'  
print @two  

--declare @three varchar(10)
select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%Commodities Broking%'  
print @three 

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%Active Based Broking%'  
print @four 

select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%Portfolio Advisory%'  
print @five 

select @six=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  currentlyusing_products like '%DP/Demat%'  
print @six 


insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4,option_5,option_6)
values ('3',@total,@one,@two,@three,@four,@five,@six)

---------------------------------------------------------------------End if second question

-----------------------------start third question

select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  overall_experience = 'Excellent'  
print @one

select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  overall_experience = 'Very Good'  
print @two

select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  overall_experience = 'Good'  
print @three

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  overall_experience = 'Above Average'  
print @four

select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  overall_experience = 'Average'  
print @five

insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4,option_5)
values ('4',@total,@one,@two,@three,@four,@five)

-------------------------end if third question

----------------start four

select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  angel_associatedwith like '%Innovative Products and Services%'  
print @one

select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  angel_associatedwith like '%Best value for money services%'  
print @two

select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  angel_associatedwith like '%Broking house for Retail Investors%'  
print @three

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  angel_associatedwith like '%High quality research and Investment advice%'  
print @four



insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4)
values ('6',@total,@one,@two,@three,@four)

--------------end four
------------start five 7

select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  hearing_angelthrough like '%Friend/Relative%'  
print @one 

select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  hearing_angelthrough like '%Banners/Posters/Leaflets%'  
print @two 

select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  hearing_angelthrough like '%News Ad%'  
print @three 

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  hearing_angelthrough like '%CNBC/NDTV%'  
print @four

select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  hearing_angelthrough not in  ('Friend/Relative','Banners/Posters/Leaflets','News Ad','CNBC/NDTV')   
print @five

insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4,option_5)
values ('7',@total,@one,@two,@three,@four,@five)
------------end five 7
-----------start six 8


select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  relevant_tagline like '%Much Beyond Broking%'   
print @one


select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  relevant_tagline like '%Present and Future of Innovative Broking services%'   
print @two

select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  relevant_tagline like '%World Class Services%'   
print @three

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  relevant_tagline like '%E-Broking Redefined%'   
print @four


select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  relevant_tagline not in  ('Much Beyond Broking','Present and Future of Innovative Broking services','World Class Services','E-Broking Redefined')   
print @five



insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4,option_5)
values ('8',@total,@one,@two,@three,@four,@five)
-----------end six 8
----------start seven 9

select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  invertor_rating = 'Excellent'  
print @one

select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and   invertor_rating = 'Very Good'  
print @two

select @three=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and   invertor_rating = 'Good'  
print @three

select @four=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and   invertor_rating = 'Above Average'  
print @four

select @five=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and   invertor_rating = 'Average'  
print @five

insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2,option_3,option_4,option_5)
values ('9',@total,@one,@two,@three,@four,@five)

----------end seven 9

------------start eight 10

select @one=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  aware_qlty_assurance like '%Y%'  
print @one

select @two=count(*) from udt_qualityfeedbackform where entrydate >=@fdate + ' 00:00' and entrydate <@tdate + ' 23:59'   
and  aware_qlty_assurance like '%N%'  
print @two

insert into utd_Qualityfeedback (questions,Total,optioin_1,option_2)
values ('10',@total,@one,@two)

------------start eight 10

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveVendorOnBoardingBankDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveVendorOnBoardingBankDetails      
(        
@PanNo VARCHAR(15)='',         
@IFSC_Code varchar(25) ='',     
@BankName varchar(355)='',      
@Branch varchar(455)='',     
@AccountType varchar(15)='',      
@BankAccountNo varchar(25)='',      
@NameInBank varchar(255)='',     
@MICR_No varchar(25) ='',      
@BankAddress varchar(455)='',      
@City varchar(255)='',      
@State varchar(255)='',      
@PinCode varchar(15)='',    
@DocumentName VARCHAR(255)='',  
@DocumentExtension VARCHAR(10)='',  
@DocumentFile Image=null,  
@EntryBy varchar(25) =''      
)      
AS      
BEGIN      
DECLARE @VendorMasterId bigint=0      
SET @VendorMasterId = (SELECT VendorMasterId FROM tbl_VendorGeneralDetails WHERE PanNo =@PanNo)      
      
IF NOT EXISTS(SELECT * FROM tbl_VendorBankMaster WHERE VendorMasterId=@VendorMasterId)      
BEGIN      
INSERT INTO tbl_VendorBankMaster VALUES(      
@VendorMasterId,@BankAccountNo,@IFSC_Code,@MICR_No,@BankName,@Branch,@NameInBank,@BankAddress,      
@City,@State,@PinCode,@AccountType,'','','','','','',  
IIF(@DocumentName<>'',1,0), IIF(@DocumentName<>'',getdate(),''),'',@EntryBy,GETDATE(),'','',''      
)      
  
IF(@DocumentName<>'')  
BEGIN  
UPDATE VADD SET BankCancelChequeDocumentName=@DocumentName,  
BankCancelChequeDocumentExtension = @DocumentExtension,BankCancelChequeDocumentFile = @DocumentFile  
FROM tbl_VendorAllDocumentDetails VADD  
WHERE VendorMasterId = @VendorMasterId  
END  
       
END       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveVendorOnBoardingDirectorPartnersDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveVendorOnBoardingDirectorPartnersDetails        
(        
@PanNo VARCHAR(15)='',      
@Type varchar(25)='',        
@Name varchar(355)='',        
@PartnersPanNo varchar(15)='',        
@RatioPercentage int=0,     
@Gender VARCHAR(10)='',
@AddressLine1 varchar(355)='',        
@AddressLine2 varchar(355)='',        
@Landmark VARCHAR(255)='',      
@City varchar(155)='',        
@State varchar(155)='',        
@PinCode varchar(15)='',        
@Std varchar(10)='',      
@PhoneNo VARCHAR(15)='',
@MobileNo varchar(15)='',        
@EmailId varchar(355)='',     
@PanDocumentName VARCHAR(255)='',    
@PanDocumentExtension VARCHAR(10)='',    
@PanDocumentFile Image = null,    
@AddressDocumentName VARCHAR(255)='',    
@AddressDocumentExtension VARCHAR(10)='',    
@AddressDocumentFile Image = null,    
@EntryBy varchar(25)=''        
)        
AS        
BEGIN        
        
DECLARE @VendorMasterId bigint=0 ,@PartnersId bigint=0       
SET @VendorMasterId = (SELECT VendorMasterId FROM tbl_VendorGeneralDetails WHERE PanNo=@PanNo)        
        
DECLARE @TotalDirectorPartners int=0        
SET @TotalDirectorPartners = (SELECT TotalDirectors FROM tbl_VendorGeneralDetails WHERE VendorMasterId=@VendorMasterId)        
        
DECLARE @EnteredDirectorPartners int=0        
SET @EnteredDirectorPartners =(SELECT count(*) FROM tbl_VendorDirectors_PartnersDetails WHERE VendorMasterId=@VendorMasterId)        
        
IF(@TotalDirectorPartners>@EnteredDirectorPartners)        
BEGIN        
        
INSERT INTO tbl_VendorDirectors_PartnersDetails VALUES(        
@VendorMasterId,@Type,@Name,@PartnersPanNo,@RatioPercentage,@Gender,@AddressLine1,@AddressLine2,@Landmark,@City,@State,@PinCode,@Std,@PhoneNo,@MobileNo,@EmailId,@EntryBy,GETDATE(),'','',    
IIF(@PanDocumentName<>'',1,0),IIF(@PanDocumentName<>'',GETDATE(),'')    
,'',IIF(@AddressDocumentName <>'',1,0),IIF(@AddressDocumentName<>'',GETDATE(),''),'','','',''        
)      
    
SET @PartnersId = (SELECT SCOPE_IDENTITY())    
    
INSERT INTO tbl_VendorDirectors_PartnersDocumentDetails    
VALUES(@PartnersId,@VendorMasterId,@PanDocumentName,@PanDocumentExtension,@PanDocumentFile,@AddressDocumentName,@AddressDocumentExtension,@AddressDocumentFile)    
END        
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveVendorOnBoardingFinalSubmittion
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveVendorOnBoardingFinalSubmittion @PanNo VARCHAR(15)=''
AS
BEGIN

IF NOT EXISTS(SELECT * FROM tbl_VendorGeneralDetails WHERE PanNo = @PanNo AND IsFinalSubmit=1)
BEGIN

UPDATE tbl_VendorGeneralDetails SET IsFinalSubmit=1, FinalSubmittionDate = GETDATE()
WHERE PanNo = @PanNo
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveVendorOnBoardingGeneral_AddressDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveVendorOnBoardingGeneral_AddressDetails      
(      
@TradeName varchar(455) ='',      
@IndividualName_Prop_sole varchar(455)='',      
@Constitution varchar(55)='',      
@TotalDirectors int=0,      
@PanNo varchar(15)='',      
@DateOfIncorporation VARCHAR(10)='',      
@AddressLine1 varchar(355) ='',      
@AddressLine2 varchar(355) ='',      
@Landmark varchar(255) ='',      
@City varchar(255) ='',      
@State varchar(155) ='',      
@country VARCHAR(155)='',      
@PinCode varchar(15) ='',      
@Std varchar(10) ='',      
@Phone VARCHAR(15)='',  
@MobileNo varchar(25) ='',      
@EmailId varchar(255) ='',    
@PanDocumentName VARCHAR(255)='',  
@PanDocumentExtension VARCHAR(10)='',  
@PanDocumentFile Image=null,  
@AddressDocumentName VARCHAR(255)='',  
@AddressDocumentExtension VARCHAR(10)='',  
@AddressDocumentFile Image=null,  
@AggrementDocumentName VARCHAR(255)='',  
@AggrementDocumentExtension VARCHAR(10)='',  
@AggrementDocumentFile Image=null,  
@MOA_DocumentName VARCHAR(255)='',  
@MOA_DocumentExtension VARCHAR(10)='',  
@MOA_DocumentFile Image=null,  
@InCorporationCertificateDocumentName VARCHAR(255)='',  
@InCorporationCertificateDocumentExtension VARCHAR(10)='',  
@InCorporationCertificateDocumentFile Image=null,  
@CreatedBy varchar(25)=''      
)      
As      
BEGIN      
IF NOT EXISTS(SELECT * FROM tbl_VendorGeneralDetails WHERE PanNo=@PanNo)      
BEGIN      
      
SET @DateOfIncorporation = CONVERT(date,@DateOfIncorporation,103)      
DECLARE @VendorMasterId bigint=0      
      
INSERT INTO [tbl_VendorGeneralDetails] VALUES(      
'',@TradeName,@IndividualName_Prop_sole,@Constitution,@TotalDirectors,@PanNo,@DateOfIncorporation,'','',@CreatedBy,GETDATE(),'','',  
IIF(@PanDocumentName<>'',1,0),IIF(@PanDocumentName<>'',GETDATE(),0),'','','',0,''      
)      
      
SET @VendorMasterId = (SELECT SCOPE_IDENTITY())      
      
INSERT INTO [tbl_VendorAddress_ContactDetails] VALUES(      
@VendorMasterId,'OFF',@AddressLine1,@AddressLine2,@Landmark,@City,@State,@country,@PinCode,@Std,@Phone,@MobileNo,'',@EmailId,@CreatedBy,GETDATE(),'','',  
IIF(@AddressDocumentName<>'',1,0),IIF(@AddressDocumentName<>'',getdate(),''),  
IIF(@AggrementDocumentName <>'',1,0),IIF(@AggrementDocumentName <>'',getdate(),''),  
IIF(@MOA_DocumentName <>'',1,0),IIF(@MOA_DocumentName <>'',GETDATE(),''),  
IIF(@InCorporationCertificateDocumentName <>'',1,0),IIF(@InCorporationCertificateDocumentName <>'',GETDATE(),''),  
'','','',''  
)      
  
  
END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveVendorOnBoardingGstDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveVendorOnBoardingGstDetails
@PanNo VARCHAR(15)='', 
@GstTradeName varchar(355) NULL,    
@GSTPanNo varchar(15) NULL,    
@GSTIN varchar(55) NULL,    
@GSTRegDate datetime NULL,    
@GstFullAddress varchar(455) NULL,    
@GstState varchar(155) NULL,    
@GstPinCode varchar(15) NULL,    
@GstCertificateDocName VARCHAR(255)='',
@GstCertificateDocExtension VARCHAR(10)='',
@GstCertificateFile Image=null,
@EntryBy VARCHAR(25)=''
AS
BEGIN

    
DECLARE @VendorMasterId bigint=0    
SET @VendorMasterId = (SELECT VendorMasterId FROM tbl_VendorGeneralDetails WHERE PanNo =@PanNo)    
    
IF NOT EXISTS(SELECT * FROM tbl_VendorGST_Details WHERE VendorMasterId =@VendorMasterId)
BEGIN
INSERT INTO [tbl_VendorGST_Details] VALUES(    
@VendorMasterId,@GSTPanNo,@GstTradeName,@GSTIN,@GSTRegDate,@GstFullAddress,@GstState,@GstPinCode,@EntryBy,GETDATE(),'',
IIF(@GstCertificateDocName<>'',1,0),IIF(@GstCertificateDocName<>'',getdate(),''),'','','',''    
)   

IF(@GstCertificateDocName<>'')
BEGIN
UPDATE VADD SET GstCertificateDocumentName=@GstCertificateDocName,
GstCertificateDocumentExtension = @GstCertificateDocExtension,GstCertificateDocumentFile = @GstCertificateFile
FROM tbl_VendorAllDocumentDetails VADD
WHERE VendorMasterId = @VendorMasterId
END

END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sent
-- --------------------------------------------------
CREATE procedure usp_sent(@server varchar(20))                              
as                              
   
DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp 
                            
declare @pcode varchar(12),@email varchar(200),@Product varchar(200),@name varchar(200),@lname varchar(200),@str as varchar(800),@str3 as varchar(1000),  @str1 as varchar(5000),@str2 as varchar(1000)                                
                           
set @str=''                                                                       
set @str1=''                           
set @str2=''            
set @str3=''            
set  @str = @str + '<html><head>'                                    
set @str = @str + '</head>'            
set @str= @str + '<body>'            
set @str= @str + '<table width=''80'' border=''0'' align=''center'' cellpadding=''0'' cellspacing=''0'' > '            
--set @str= @str + '</table></td></tr>'            
set @str= @str + '<tr><td valign=''top''><table width=''900'' border=''0'' align=''center'' cellpadding=''0'' cellspacing=''0'' > '            
            
set @str= @str + '<tr><td class=date><div align=right>Date : ' +convert(varchar(11),getdate())+'</div></td></tr>'            
set @str= @str + '<tr><td><p align=''justify'' class=date>Dear <strong>'             
set @str3= @str3 + '</strong>,<br/><br/>'            
set @str3= @str3 + 'This is to inform you that the requested client codes have been created in their</strong></a><br />'            
set @str3= @str3 + 'respective products and the password has been dispatched on their registered email address. <br /><br />'            
set @str3= @str3 + 'The client codes are as follows: </td></tr></table>'            
set @str3= @str3 + '<br/><table width=300><tr><td>Client Code</td><td>Product</td>'            
set @str2= @str2 + '</tr></table><br/><table><tr><td colspan=2></td></tr><tr><td><span class=date>Incase of any doubts or queries regarding the same, please feel free to revert back on <a href=''mailto:Etrading@angeltrade.com'' class=date><strong>etrading
  
@angeltrade.com</strong></a></span></td></tr>'            
set @str2 = @str2 + '<br/>'    
set @str2 = @str2 + '<tr><td>Regards, </td></tr>'            
set @str2 = @str2 + '<tr><td>ETrading </td></tr>'            
--set @str2 = @str2 + '<td width=''40%'' height=''25'' align=''center'' valign=''middle'' ><div align=''center''></div></td>'            
set @str2 = @str2 + '</table>'            
--set @str2 = @str2 + '</table></td></tr></table></td></tr></table>'            
set @str2 = @str2 + '</body>'            
set @str2 = @str2 + '</html>'            
              
--print @str                              
DECLARE sentECN_invite CURSOR FOR             
                                                                               
select party_code,products_allowed,b.email,b.emp_name  from diet_cli_all a            
left outer join            
intranet.risk.dbo.emp_info b            
on a.usercode=b.emp_no            
where  server = @server and eflag = 'Y'            
order by usercode            
            
/*select * from #file1  order by email */             
                                       
declare @vemail as varchar(60),@ctr as int              
set @vemail=''           
set @lname=''            
set @ctr=0                   
            
OPEN sentECN_invite                                                                                
                                                                                
FETCH NEXT FROM sentECN_invite                                                                                 
INTO @pcode,@Product,@email ,@name              
                                                                                
WHILE @@FETCH_STATUS = 0                                                                                
BEGIN                  
                      
if @vemail<>@email and @ctr=0                              
BEGIN            
--set @str1=''            
set @str1 = @str1 + '<tr><td><p align=''justify''class=date><strong>'+@pcode+'</td><td>'+@Product+'</td>'            
END            
if @vemail=@email                            
BEGIN            
  set @str1 = @str1 + '<tr><td><p align=''justify''class=date><strong>'+@pcode+'</td><td>'+@Product+'</td>'             
END             
if @vemail<>@email and @ctr>0                                 
BEGIN            
print 'EMAIL'              
 declare @mess as varchar(8000)            
 set @mess=@str+@lname+@str3+@str1+@str2                   
                
 exec intranet.msdb.dbo.sp_send_dbmail                             
 @recipients  = @vemail,             
--@TO = 'Deepali.Mahadik@angeltrade.com',                                      
 @blind_copy_recipients  = 'Deepali.Mahadik@angeltrade.com,ritul@angeltrade.com,prafull.surti@angeltrade.com',               
 @profile_name = 'Etrading',
 --@from = 'Etrading@angeltrade.com',                    
@body_format ='html',                            
 @subject = 'Confirmation of Client Code Activation',                                     
 @body =@mess                 
                    
set @str1=''            
set @str1 = @str1 + '<tr><td><p align=''justify''class=date><strong>'+@pcode+'</td><td>'+@Product+'</td>'        
--set @str1 = @str1 + '<tr><td colspan=2><strong>'+@pcode+'</td><td>'+@Product+'</td>'          
END             
 set @ctr=1                            
set @vemail=@email           
set @lname=@name           
                  
FETCH NEXT FROM sentECN_invite                                                                                 
INTO @pcode,@Product,@email,@name                 
                                          
                
END            
--declare @mess as varchar(6000)            
 set @mess=@str+@name+@str3+@str1+@str2                
                
 exec intranet.msdb.dbo.sp_send_dbmail                             
 @recipients  = @email,              
 --@TO =  'Deepali.Mahadik@angeltrade.com',                                        
 @blind_copy_recipients  = 'Deepali.Mahadik@angeltrade.com,ritul@angeltrade.com,prafull.surti@angeltrade.com',              
 @profile_name = 'Etrading',
 --@from = 'Etrading@angeltrade.com',                         
 @body_format ='html',                            
 @subject = 'Confirmation of Client Code Activation',                                     
 @body =@mess                                                                                      
CLOSE sentECN_invite                                                                    
DEALLOCATE sentECN_invite

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sent_BGMail_new1
-- --------------------------------------------------
CREATE procedure usp_Sent_BGMail_new1                                   
as           
            
declare @cntstr int           
declare @dispatch_date as varchar(25)         
set @dispatch_date = (select max( convert(varchar(11),dispatch_Date,13))as dispatch_Date from intranet.nsecourier.dbo.delivered)      
print @dispatch_date      
  
  
--select convert(varchar(11),@dispatch_date,103) as dispatch_date          
select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) into #con2 from intranet.nsecourier.dbo.hist_temp_offlinemaster  a          
inner join (select Client_Code=client_code,Name=client_name,          
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),          
Delivered from intranet.nsecourier.dbo.delivered where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b           
on a.cl_code=b.client_code  order by Dispatch_Date          
      
--print @dispatch_date      
      
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                
into #con1 from NonECN_MAIL_addr(nolock) --where branch='XS1'                                    
where branch in (select branch from #con2) order by branch       
      
select * from #con1          
      
drop table usp_sent_branch            
select * into usp_sent_branch from #con1          
          
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                                      
@mess2 as varchar(1300),@ctr as int,                                        
@name as varchar(100)                                          
set @ctr=0                                        
set @mess2='          
      
Dear Sir,<br><br><br>      
Please find the MIS report of the Welcome kits dispatched for forms inwarded as on .<br>      
In case of any clarification on the same please do revert back to me.The MIS mentioned above is also available in the RM Welcome Kit Link for your reference:      
<br>      
http://196.1.115.136/ ->KYC ->Status Repot ->Welcome Kit Report      
<br>      
<br>      
<br>      
<br>      
<br>      
<br>      
<br>      
      
Regards,      
<br>      
<br>      
      
Moshin Agwan      
<br>      
Asst.Manager KYC(CSO)      
<br>      
(Mob.9869342967)      
'          
      
          
DECLARE email_EBROK_cursor CURSOR FOR                                                                                         
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                
from NonECN_MAIL_addr(nolock) --where branch='XS1'                                    
order by branch                                                                               
                                                                 
OPEN email_EBROK_cursor                                                                     
FETCH NEXT FROM email_EBROK_cursor                                                                                         
INTO @tag,@name,@email,@remail                      
WHILE @@FETCH_STATUS = 0                                                                                        
BEGIN           
select @rec=count(1) from usp_sent_branch where branch=@tag                   
if @rec > 0                                        
BEGIN                                        
declare @s as varchar(1000),@s1 as varchar(1000)                                        
--//set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch       
  
   
--//where Branch='''''+@tag+'''''  " queryout D:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                        
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from intranet.nsecourier.dbo.usp_sent_branch" queryout '+'\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\Branch_record\'+@tag+'.csv -c -Smis -Usa -Pnirwan612'                  
    
set @s1= @s+''''                 
--print @s1          
exec(@s1)          
          
          
----------//          
          
declare @attach as varchar(500)                     
set @attach='D:\upload1\Branch_record\'+@tag+'.CSV;'          
declare @str as varchar(200)  , @result as int                                
set @str='declare @result as int'                                       
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\Branch_record\'+@tag+'.CSV'', NO_OUTPUT'                                        
set @str=@str+' select Result=@result '           
--print @str                         
          
--declare @ss  table (status int)                                         
---insert into @ss  exec(@str)                                        
          
create table #ffb (status int)                                        
insert into #ffb  exec(@str)          select @result=status from #ffb                 
                                  
          
 --print @result                                        
                                
          
set @mess='Dear '+replace(@name,',','/')+@mess2                               
if @result=0                                    
begin                                       
--//EXEC master.dbo.xp_smtp_sendmail @from='ECNCSO@angeltrade.com',                                        
                       
/*          
 --// @to=@email,                                        
 @to='preetam.patil@angeltrade.com',                                        
 -- @cc=@remail,                                        
  --//@bcc='Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com,shweta.tiwari@angeltrade.com',                                        
  @subject='ECN Bounce Mail Client',--@type='text/html',                                        
  @priority='HIGH',                                        
  @attachments=@attach,                                        
  --//@server='angelmail.angelbroking.com',                                        
  @message=@mess            
*/          
          
exec mis.master.dbo.xp_smtp_sendmail               
@TO =  'preetam.patil@angeltrade.com',               
@from ='preetam.patil@angeltrade.com',            
@type='text/html',                                      
@subject = 'Bank Guarantee Expiring in next 15 days',        
 @attachments=@attach,                                                   
@server = 'angelmail.angelbroking.com',                                              
@message=@mess                                        
          
  --print 'File send '+@tag                                                                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\Branch_record\'+@tag+'.CSV'''                                              
  exec(@str)                                        
  set @ctr=1                                             
 end                                        
          
drop table #ffb                                       
END                     
          
FETCH NEXT FROM email_EBROK_cursor                                                                                         
INTO @tag,@name,@email,@remail               
END                                                                   
CLOSE email_EBROK_cursor                                                                            
DEALLOCATE email_EBROK_cursor               
                
          
----------------------Mail To QA----                      
select @rec=count(1) from usp_sent_branch                      
if @rec > 0                                        
BEGIN               
set @tag='ALL'                           
          
--declare @s as varchar(1000),@s1 as varchar(1000)                                        
--//set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch       
 
   
     
--//where Branch='''''+@tag+'''''  " queryout D:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                        
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from intranet.nsecourier.dbo.usp_sent_branch" queryout '+'\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\Branch_record\'+@tag+'.csv -c -Smis -Usa -Pnirwan612'                  
          
set @s1= @s+''''          
exec(@s1)             
          
                              
--declare @attach as varchar(500)                                        
          
set @attach='D:\upload1\Branch_record\'+@tag+'.CSV;'                                  
          
-- declare @str as varchar(200)  , @result as int                                        
set @str='declare @result as int'                                       
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\Branch_record\'+@tag+'.CSV'', NO_OUTPUT'                                        
set @str=@str+' select Result=@result '                                           
--declare @ss  table (status int)                                                   
--\\insert into @ss  exec(@str)                                        
           
create table #ffbq (status int)                                  insert into #ffbq  exec(@str)           select @result=status from #ffbq                                        
          
--print @result                                        
                                 
set @mess='Dear All'+@mess2                                      
                
if @result=0                                       
begin                                        
--//EXEC master.dbo.xp_smtp_sendmail @from='ECNCSO@angeltrade.com',                                        
          
--//@to='kyc.cso@angeltrade.com,Feedback@angeltrade.com,cosdespatch@angeltrade.com,Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com',                                        
/*          
@to='preetam.patil@angeltrade.com',                                        
--//@cc='Santanu.Syam@angeltrade.com,Alpesh.Porwal@angeltrade.com',                                        
--//@bcc='shweta.tiwari@angeltrade.com',                                        
@subject='ECN Bounce Mail Client',--@type='text/html',                                        
@priority='HIGH',                                        
@attachments=@attach,                                        
--//@server='angelmail.angelbroking.com',                                        
@message=@mess                                        
          
--print 'File send '+@tag                                        
*/          
exec mis.master.dbo.xp_smtp_sendmail            
@TO =  'preetam.patil@angeltrade.com',               
@from ='preetam.patil@angeltrade.com',            
@type='text/html',                                      
@subject = 'Bank Guarantee Expiring in next 15 days',        
@attachments=@attach,                                              
@server = 'angelmail.angelbroking.com',                                              
@message=@mess            
          
set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\Branch_record\'+@tag+'.CSV'''                                              
exec(@str)                                        
set @ctr=1                                             
end                                        
          
drop table #ffbq                                     
END                        
---------------------------------------Mail when branch id not found                                          
select @rec=count(1) from usp_sent_branch where branch not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)   
if @rec>0                          
BEGIN                          
--declare @s as varchar(1000),@s1 as varchar(1000)                                        
          
--//set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch     
   
    
--//where Branch='''''+@tag+'''''  " queryout D:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                        
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from intranet.nsecourier.dbo.usp_sent_branch" queryout '+'\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\Branch_record\'+@tag+'.csv -c -Smis -Usa -Pnirwan612'                  
set @s1= @s+''''                            
exec(@s1)                                  
          
                 
 --declare @attach as varchar(500)                                        
          
set @attach='D:\upload1\Branch_record\'+@tag+'.CSV;'                                        
                                    
--declare @str as varchar(200)  , @result as int                                        
          
set @str='declare @result as int'                                        
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\Branch_record\'+@tag+'.CSV'', NO_OUTPUT'                                        
set @str=@str+' select Result=@result '                                    
                                     
 --declare @ss  table (status int)                                                                      
 ---insert into @ss  exec(@str)                                        
          
 create table #ffb1 (status int)                                      
 --truncate table #ffb                                     
          
          
 insert into #ffb1              
 exec(@str)                                        
 select @result=status from #ffb1                                        
 --print @result                        
          
set @mess='Dear ALL                              
          
                            
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for ecn bounce of client, So do the needfull to update concerned branch person email ID.                              
'                                       
if @result=0                                        
 begin                                        
--//EXEC master.dbo.xp_smtp_sendmail @from='Soft@angeltrade.com',                                     
          
/*          
--//@to=@email,                                        
@to='preetam.patil@angeltrade.com',          
--//@to='Deepak.Redekar@angeltrade.com,sachin.jadhav@angeltrade.com,ECNCSO@angeltrade.com,shweta.tiwari@angeltrade.com',                                        
--//@subject='ECN Bounce Mail Not Alerted',--@type='text/html',                                        
@priority='HIGH',                                        
@attachments=@attach,                                        
--//@server='angelmail.angelbroking.com',                                        
@message=@mess                                        
          
--print 'File send '+@tag                                                  
*/          
exec mis.master.dbo.xp_smtp_sendmail            
@TO =  'preetam.patil@angeltrade.com',               
@from ='preetam.patil@angeltrade.com',            
@type='text/html',                                      
@subject = 'Bank Guarantee Expiring in next 15 days',           
 @attachments=@attach,                                           
@server = 'angelmail.angelbroking.com',                                              
@message=@mess            
          
set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\Branch_record\'+@tag+'.CSV'''                      
exec(@str)                                        
          
--set @ctr=1                                             
end                                        
          
drop table #ffb1                                       
END                          
          
                                
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sent_Bounce_EcnMail_new
-- --------------------------------------------------
CREATE procedure usp_Sent_Bounce_EcnMail_new                                
    
as   

DECLARE @rc INT                     
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                     
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                    
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp
                             
declare @fld_date as varchar(11)                                  
    
select @fld_date=max(fld_date) from intranet.nsecourier.dbo.Tbl_Delivered_Branch                                
select distinct fld_clcode,fld_clname,fld_Branch,fld_sbcode,fld_date,fld_Reason,fld_Br_Remark   
into #con  from intranet.nsecourier.dbo.Tbl_Delivered_Branch   
where fld_delivery_date >= convert(varchar(11),@fld_date)+' 00:00:00' and fld_delivery_date <= convert(varchar(11),@fld_date)+' 00:00:00'           
    
drop table Temp_branchdetails  
--select * from Temp_ECNBounce_MAIL_BR                          
select  fld_clcode,fld_clname,fld_Branch,fld_sbcode,fld_date,fld_Reason,fld_Br_Remark                             
into Temp_branchdetails                              
from #con2                       

declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                                
@mess2 as varchar(1300),@ctr as int,                                  
@name as varchar(100)                                    
set @ctr=0                                  
    
set @mess2='Dear Sir,  
  
   
  
Please find the MIS report of the Welcome kits dispatched for forms inwarded as on 12/12/2008.In case of any clarification on the same please do revert back to me.  
  
 The MIS mentioned above is also available in the RM Welcome Kit Link for your reference: http://196.1.115.136/ ->KYC ->Status Repot ->Welcome Kit Report                    
    
                                
    
Regards,  
  
   
  
Mohsin Agwan   
  
Asst . Manager KYC (CSO)  
  
(Mob: 9869342967)  
  
                                
    
'                                  

DECLARE email_EBROK_cursor CURSOR FOR                                                                                   
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                            
from NonECN_MAIL_addr(nolock) --where branch='AHD'                              
order by branch                                                                         

OPEN email_EBROK_cursor                                                                                  
FETCH NEXT FROM email_EBROK_cursor                                                                                   
INTO @tag,@name,@email,@remail                      

WHILE @@FETCH_STATUS = 0                                                                                  
BEGIN                                     
select @rec=count(1) from Temp_branchdetails where fld_Branch=@tag                                 
    
if @rec > 0                                  
BEGIN                                  
 declare @s as varchar(1000),@s1 as varchar(1000)                                  
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  "  select client_code +'''',''''+fld_clName+'''',''''+fld_Branch+'''',''''+fld_sbcode+'''',''''+fld_date+'''',fld_Br_Remark''''+client_email from mis.testdb.dbo.Temp_branchdetails  
 where fld_Branch='''''+@tag+'''''  " queryout D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                  
    
 set @s1= @s+''''                   
    
 exec(@s1)                                  
 declare @attach as varchar(500)                                  
    
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV;'                            
 declare @str as varchar(200)  , @result as int                                  
    
 set @str='declare @result as int'                                 
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'', NO_OUTPUT'                                  
 set @str=@str+' select Result=@result '                                     
    
 --declare @ss  table (status int)                                             
    
 ---insert into @ss  exec(@str)                                  
    
 create table #ffb (status int)                                  
    
 insert into #ffb  exec(@str)           select @result=status from #ffb                                  
    
 --print @result                                  
set @mess='Dear '+replace(@name,',','/')+@mess2                                  

 if @result=0                                  
 begin                                  
 EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'ECNCSO',
  --@from='ECNCSO@angeltrade.com',                                  
  @recipients =@email,                                  
  @copy_recipients =@remail,                                  
  @blind_copy_recipients ='Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com,shweta.tiwari@angeltrade.com',                                  
  @subject='ECN Bounce Mail Client',--@type='text/html',                                  
  @importance ='HIGH',                                  
  @file_attachments =@attach,                                  
  @body =@mess                                  
    
  --print 'File send '+@tag                                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'''                                        
    
  exec(@str)                                  
    
  set @ctr=1                                       
    
 end                                  
    
 drop table #ffb                                  
END                                  
 FETCH NEXT FROM email_EBROK_cursor                                                                                   
 INTO @tag,@name,@email,@remail                                                            
END                                                         
     
CLOSE email_EBROK_cursor                                                                      
    
DEALLOCATE email_EBROK_cursor                 
    
----------------------Mail To QA----                
    
select @rec=count(1) from Temp_ECNBounce_MAIL_BR                 
    
if @rec > 0                                  
    
BEGIN         
set @tag='ALL'        
 --declare @s as varchar(1000),@s1 as varchar(1000)                                  
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,EMAIL,MOBILE,Residence Phone'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_code+'''',''''+client_name+'''',''''+client_email+'''','' 
    
''+mobile_pager+'''',''''+res_phone from mis.testdb.dbo.Temp_ECNBounce_MAIL_BR   " queryout D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV -c -Sintranet -Usa -Pnirwan612'                                                            
 set @s1= @s+''''             
 exec(@s1)                                  
    
 --declare @attach as varchar(500)                                  
    
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV;'                            
-- declare @str as varchar(200)  , @result as int                                  
    
 set @str='declare @result as int'                                 
    
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'', NO_OUTPUT'                                  
    
 set @str=@str+' select Result=@result '                                     
 --declare @ss  table (status int)                                             
    
 ---insert into @ss  exec(@str)                                  
    
 create table #ffbq (status int)                                  
    
 insert into #ffbq  exec(@str)           select @result=status from #ffbq                                  
    
 --print @result                                  
set @mess='Dear All'+@mess2                                  
 if @result=0                                  
    
 begin                                  
    
EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'ECNCSO',
  --@from='ECNCSO@angeltrade.com',                                  
  @recipients='kyc.cso@angeltrade.com,Feedback@angeltrade.com,cosdespatch@angeltrade.com,Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com',                                  
  @copy_recipients='Santanu.Syam@angeltrade.com,Alpesh.Porwal@angeltrade.com',                                  
  @blind_copy_recipients='shweta.tiwari@angeltrade.com',                                  
  @subject='ECN Bounce Mail Client',--@type='text/html',                                  
  @importance='HIGH',                                  
  @file_attachments=@attach,                                  
  @body=@mess                                  
  --print 'File send '+@tag                                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_'+@tag+'.CSV'''                                        
  exec(@str)                                  
  set @ctr=1                                       
 end                                  
 drop table #ffbq                               
 END                  
    
-----------------------------------------Mail when branch id not found                                    
    
select @rec=count(1) from mis.testdb.dbo.Temp_ECNBounce_MAIL_BR where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)                              
    
if @rec>0                    
    
BEGIN                    
--declare @s as varchar(1000),@s1 as varchar(1000)                                  
    
 set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select ''''BRANCH,sub-broker,CLIENT,NAME,EMAIL'''' union all  select branch_cd+'''',''''+sub_broker+'''',''''+client_code+'''',''''+client_name+'''',''''+client_email from mis.testdb.dbo.Temp_ECNBounce_MAIL_BR where branch_cd not in (select branch from  mis.testdb.dbo.NonECN_MAIL_addr)  " queryout D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV -c -Sintranet -Usa -Pnirwan612'                                                            
 set @s1= @s+''''                                                                                    
 exec(@s1)                            
    
 --declare @attach as varchar(500)                                  
    
 set @attach='D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV;'                                  
 --declare @str as varchar(200)  , @result as int                                  
    
 set @str='declare @result as int'                                  
    
 set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV'', NO_OUTPUT'                                  
    
 set @str=@str+' select Result=@result '                                     
    
                                  
    
 --declare @ss  table (status int)                                                                
    
 ---insert into @ss  exec(@str)                                  
    
 create table #ffb1 (status int)                                
    
 --truncate table #ffb                               
    
                               
    
 insert into #ffb1                  
    
 exec(@str)                                  
    
 select @result=status from #ffb1                                  
    
 --print @result                  
    
                                  
    
 set @mess='Dear ALL                        
    
                        
    
Please find the attached file in which branches email ID are not found, Since email could not be sent to branches for ecn bounce of client, So do the needfull to update concerned branch person email ID.'                                     
 if @result=0                                  
    
 begin                                  
    
EXEC intranet.msdb.dbo.sp_send_dbmail 
  @profile_name = 'intranet',
  --@from='Soft@angeltrade.com',                               
  --@to=@email,                                  
  @recipients ='Deepak.Redekar@angeltrade.com,sachin.jadhav@angeltrade.com,ECNCSO@angeltrade.com,shweta.tiwari@angeltrade.com',                                  
  @subject='ECN Bounce Mail Not Alerted',--@type='text/html',                                  
  @importance ='HIGH',                                  
  @file_attachments =@attach,                                  
  @body =@mess                                  
  --print 'File send '+@tag                                                  
  set @str='exec MASTER.dbo.xp_cmdshell ''del D:\upload1\ECN\Bounce_file\BounceList_NotSend.CSV'''                                        
    
  exec(@str)                                                                       
 end                                  
    
 drop table #ffb1                                 
    
 END                    
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sent_mismail
-- --------------------------------------------------
  
  
--select * from NonECN_MAIL_addr where BM_mail like '%Hiren.Shah@angeltrade.com%'  
  
CREATE proc usp_sent_mismail                              
as                              
             
set nocount on            
DECLARE @rc INT                                 
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                                 
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                                
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp             
                                   
declare @dispatch_date as varchar(25)                                     
set @dispatch_date = (select max(convert(varchar(11),dispatch_Date,121)) as dispatch_Date from intranet.nsecourier.dbo.delivered where inbunch='NO')                                  
                          
declare @cntstr int                             
select  @cntstr=count(*) From mis_date where senddate=@dispatch_date                           
insert into  mis_date values(@dispatch_date)                         
if @cntstr=0                             
begin       
                           
select  distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) into #con2                              
 from intranet.nsecourier.dbo.hist_temp_offlinemaster  a                                      
inner join (select Client_Code=client_code,Name=client_name,                                      
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),                                      
Delivered from intranet.nsecourier.dbo.delivered where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b                                       
on a.cl_code=b.client_code  order by Dispatch_Date                                      
                              
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')                                            
into #con1 from NonECN_MAIL_addr(nolock) --where branch='XS1'                                                                
where branch in (select branch from #con2) order by branch       
                            
                                
                              
                              
declare @tag varchar(12),@email varchar(200),@remail varchar(450),@rec int,@mess as varchar(4000),                                                                  
@name as varchar(100)                                                                                                                  
                              
set @mess='Dear Sir/Madam,<br><br><br>                                  
Please find the Attached file containing MIS report of the Welcome kits dispatched .<br><br>                                  
In case of any clarification on the same please do revert back to me.The MIS mentioned is also available in the RM Welcome Kit Link for your reference:                                  
<b>                                  
http://196.1.115.136/ ->KYC ->Status Repot ->Welcome Kit Report    </b>                              
<br>                                  
<br>                                  
<br>                                  
<br>                                  
<br>                                  
<br>                                  
<br>                                  
                                  
Regards,                                  
<br>                                  
<br>                                  
                                  
Kyc Team                                 
<br>                                  
Welcome Kit Dept.                                  
<br>                                  
TEL: 022 30837400 (EXTN: 501/503)                                  
'                                      
                                  
                                      
DECLARE email_EBROK_cursor CURSOR FOR  select distinct branch from  #con2                                                                                                                                             
OPEN email_EBROK_cursor                                                                            
FETCH NEXT FROM email_EBROK_cursor                                                                                                     
INTO @tag                                               
WHILE @@FETCH_STATUS = 0                                                                                         
BEGIN                               
                                      
select @rec=count(1) from #con1  where branch=@tag                                               
if @rec > 0                                                                    
BEGIN                                     
select distinct @email=replace(BM_mail,'/',','),@remail='virajm.patil@angeltrade.com;farid.sarang@angeltrade.com;mohsin.agwan@angeltrade.com;'+replace(rgm_mail,'/',';')   from  #con1 where branch=@tag                          
end                               
else                              
begin                               
set @email='kyc.wk@angelbroking.com'                        
set @remail='kyc.wk@angelbroking.com;kycdespatch@angelbroking.com;dis@angelbroking.com;Rajdeep.Basu@Angelbroking.com;amit.s@angelbroking.com'                         
end                               
                              
declare @str12 as varchar(500)                              
truncate table con3                                
insert into con3 values('ClientCode','Name','Company','Pod','Branch','SbCode','DispatchDate','Delivered','InvokeDate')                               
insert into  con3 select * from  #con2 where branch=@tag                              
                              
                              
declare @s as varchar(1000),@s1 as varchar(1000)                                                    
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from mis.testdb.dbo.con3" queryout '+'\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\Branch_record\'+@tag+'.csv -c -Smis -Usa -Pnirwan612'                                              
set @s1= @s+''''                                                        
exec(@s1)                                                              
                                            
                              
                              
declare @attach as varchar(500)                                                 
set @attach='\\INHOUSEALLAPP-FS.angelone.in\d$\upload1\Branch_record\'+@tag+'.CSV'                                      
              
 exec intranet.msdb.dbo.sp_send_dbmail                                         
@recipients = @email,                               
@copy_recipients = @remail,                              
--@TO = 'preetam.patil@angeltrade.com',                               
@blind_copy_recipients= 'kyc.wk@angelbroking.com',                              
@profile_name = 'kyc.cso',            
--@from ='Vijayg.Gurav@angeltrade.com',                                        
@body_format ='html',                                                                  
@subject = 'Welcome Kit MIS',                                    
@file_attachments =@attach,                                                                               
@body=@mess                                                                    
                                                                
                                    
FETCH NEXT FROM email_EBROK_cursor                                                                                                                     
INTO @tag                                       
END                                                                                               
CLOSE email_EBROK_cursor                                                                                                        
DEALLOCATE email_EBROK_cursor           
          
      
end        
      
set nocount off

GO

-- --------------------------------------------------
-- TABLE dbo.aa
-- --------------------------------------------------
CREATE TABLE [dbo].[aa]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [L_address2] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(15) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abl_ben
-- --------------------------------------------------
CREATE TABLE [dbo].[abl_ben]
(
    [Client Code] VARCHAR(10) NULL,
    [DPID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Quantity] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abl_cl
-- --------------------------------------------------
CREATE TABLE [dbo].[abl_cl]
(
    [Client Code] VARCHAR(10) NULL,
    [DPID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Quantity] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abl1
-- --------------------------------------------------
CREATE TABLE [dbo].[abl1]
(
    [cltcode] VARCHAR(10) NOT NULL,
    [balance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AMC
-- --------------------------------------------------
CREATE TABLE [dbo].[AMC]
(
    [Name] VARCHAR(255) NULL,
    [Tel] VARCHAR(255) NULL,
    [Add1] VARCHAR(255) NULL,
    [Add2] VARCHAR(255) NULL,
    [Add3] VARCHAR(255) NULL,
    [Add4] VARCHAR(255) NULL,
    [Add5] VARCHAR(255) NULL,
    [Add6] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AMC_ON_Next
-- --------------------------------------------------
CREATE TABLE [dbo].[AMC_ON_Next]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [client_name] VARCHAR(21) NULL,
    [cm_cd] CHAR(16) NULL,
    [pcode] CHAR(20) NULL,
    [cm_opendate] DATETIME NULL,
    [clsdate] CHAR(8) NULL,
    [cm_chgsscheme] CHAR(10) NULL,
    [lastOne] DATETIME NULL,
    [Totbal] MONEY NULL,
    [DPbal] MONEY NULL,
    [AMC] MONEY NULL,
    [typ] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARM_CLT
-- --------------------------------------------------
CREATE TABLE [dbo].[ARM_CLT]
(
    [party_code] VARCHAR(50) NULL,
    [deposit] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARM_CLT1
-- --------------------------------------------------
CREATE TABLE [dbo].[ARM_CLT1]
(
    [party_code] VARCHAR(50) NULL,
    [deposit] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ass
-- --------------------------------------------------
CREATE TABLE [dbo].[ass]
(
    [General Practice:-] VARCHAR(255) NULL,
    [Contact No.] VARCHAR(255) NULL,
    [add1] VARCHAR(255) NULL,
    [add2] VARCHAR(255) NULL,
    [add3] VARCHAR(255) NULL,
    [add4] VARCHAR(255) NULL,
    [add5] VARCHAR(255) NULL,
    [add6] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bolt
-- --------------------------------------------------
CREATE TABLE [dbo].[bolt]
(
    [srno] NUMERIC(18, 0) NOT NULL,
    [Segment] VARCHAR(50) NULL,
    [Bolt_no] MONEY NULL,
    [Client_name] VARCHAR(50) NULL,
    [Personto] VARCHAR(50) NULL,
    [Locatioon] VARCHAR(50) NULL,
    [Telephone] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bolt$
-- --------------------------------------------------
CREATE TABLE [dbo].[Bolt$]
(
    [F1] FLOAT NULL,
    [F2] NVARCHAR(255) NULL,
    [F3] FLOAT NULL,
    [ANGEL BROKING LTD#(CLG#NO#612)] NVARCHAR(255) NULL,
    [F5] NVARCHAR(255) NULL,
    [F6] NVARCHAR(255) NULL,
    [F7] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bolt_master
-- --------------------------------------------------
CREATE TABLE [dbo].[bolt_master]
(
    [Srno] NUMERIC(18, 0) NOT NULL,
    [segment] VARCHAR(50) NULL,
    [Bolt_no] VARCHAR(50) NULL,
    [Client_name] VARCHAR(50) NULL,
    [Personto] VARCHAR(50) NULL,
    [Location] VARCHAR(50) NULL,
    [telephone] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bolt_master1
-- --------------------------------------------------
CREATE TABLE [dbo].[bolt_master1]
(
    [Srno] NUMERIC(18, 0) NOT NULL,
    [segment] VARCHAR(50) NULL,
    [Bolt_no] VARCHAR(50) NULL,
    [Client_name] VARCHAR(50) NULL,
    [Personto] VARCHAR(50) NULL,
    [Location] VARCHAR(50) NULL,
    [telephone] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bolt1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bolt1]
(
    [srno] FLOAT NULL,
    [segment] NVARCHAR(255) NULL,
    [bolt_no] FLOAT NULL,
    [Client_name] NVARCHAR(255) NULL,
    [Personto] NVARCHAR(255) NULL,
    [Location] NVARCHAR(255) NULL,
    [Telephone] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bolt1_master
-- --------------------------------------------------
CREATE TABLE [dbo].[Bolt1_master]
(
    [Srno] NUMERIC(18, 0) NULL,
    [Segment] NVARCHAR(255) NULL,
    [Bolt_no] MONEY NULL,
    [Client_name] NVARCHAR(255) NULL,
    [Personto] NVARCHAR(255) NULL,
    [Location] NVARCHAR(255) NULL,
    [Telephone] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bolt1_master1
-- --------------------------------------------------
CREATE TABLE [dbo].[bolt1_master1]
(
    [Srno] NUMERIC(18, 0) NOT NULL,
    [segment] VARCHAR(50) NULL,
    [Bolt_no] VARCHAR(50) NULL,
    [Client_name] VARCHAR(50) NULL,
    [Personto] VARCHAR(50) NULL,
    [Location] VARCHAR(50) NULL,
    [telephone] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.boltfile_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[boltfile_temp]
(
    [Trdr] VARCHAR(25) NULL,
    [Alias] VARCHAR(50) NULL,
    [UT] VARCHAR(10) NULL,
    [CD] VARCHAR(10) NULL,
    [CR] VARCHAR(10) NULL,
    [Active] VARCHAR(10) NULL,
    [OL] VARCHAR(10) NULL,
    [BT] VARCHAR(10) NULL,
    [AVM] VARCHAR(10) NULL,
    [SL] VARCHAR(10) NULL,
    [6A7A] VARCHAR(10) NULL,
    [MQ] VARCHAR(10) NULL,
    [CREG] VARCHAR(10) NULL,
    [Auc] VARCHAR(10) NULL,
    [ClRec] VARCHAR(10) NULL,
    [Quote] VARCHAR(10) NULL,
    [BlockDeal] VARCHAR(10) NULL,
    [SetGBL] VARCHAR(10) NULL,
    [SetSBL] VARCHAR(10) NULL,
    [GLBuy] VARCHAR(15) NULL,
    [GLSell] VARCHAR(15) NULL,
    [NetVal] VARCHAR(15) NULL,
    [DefBuy] VARCHAR(15) NULL,
    [DefSell] VARCHAR(15) NULL,
    [MaxQty] VARCHAR(15) NULL,
    [MaxVal] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Book1
-- --------------------------------------------------
CREATE TABLE [dbo].[Book1]
(
    [SUB_BROKERS] VARCHAR(150) NULL,
    [TAG] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BR_tradeanywhere_LimitMargin
-- --------------------------------------------------
CREATE TABLE [dbo].[BR_tradeanywhere_LimitMargin]
(
    [branch_cd] VARCHAR(10) NULL,
    [cheque_limit] CHAR(1) NULL,
    [non_apr_shares] FLOAT NULL,
    [Entered_by] VARCHAR(10) NULL,
    [Entered_on] DATETIME NULL,
    [Entered_ip] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.c#
-- --------------------------------------------------
CREATE TABLE [dbo].[c#]
(
    [party_code] CHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [branch_cd] VARCHAR(3) NULL,
    [sub_broker] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CashFlows
-- --------------------------------------------------
CREATE TABLE [dbo].[CashFlows]
(
    [project_id] CHAR(15) NOT NULL,
    [time_period] INT NOT NULL,
    [amount] DECIMAL(12, 4) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CDP_CLT
-- --------------------------------------------------
CREATE TABLE [dbo].[CDP_CLT]
(
    [cm_blsavingcd] VARCHAR(50) NULL,
    [cm_cd] VARCHAR(16) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.chq_entry
-- --------------------------------------------------
CREATE TABLE [dbo].[chq_entry]
(
    [AppNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Branch_Cd] VARCHAR(60) NOT NULL,
    [Exchange] VARCHAR(15) NOT NULL,
    [BankName] VARCHAR(150) NULL,
    [New_Bank] VARCHAR(1) NULL,
    [New_BankName] VARCHAR(150) NULL,
    [Client_Code] VARCHAR(15) NOT NULL,
    [Client_Name] VARCHAR(60) NOT NULL,
    [Mode] VARCHAR(15) NOT NULL,
    [Mode_No] VARCHAR(15) NOT NULL,
    [MICR] VARCHAR(33) NULL,
    [Account_No] VARCHAR(33) NULL,
    [Amount] VARCHAR(15) NOT NULL,
    [Scan1] IMAGE NULL,
    [Scan2] IMAGE NULL,
    [Status] VARCHAR(15) NOT NULL,
    [Remarks] VARCHAR(150) NULL,
    [Narrations] VARCHAR(150) NULL,
    [mkrdt] VARCHAR(8) NULL,
    [mkrid] VARCHAR(15) NULL,
    [Client_Bank] VARCHAR(150) NULL,
    [EntryDate] VARCHAR(8) NULL,
    [Bank_Cd] VARCHAR(15) NULL,
    [chkrdt] VARCHAR(8) NULL,
    [flag] CHAR(1) NULL DEFAULT 'N',
    [Umkrdt] VARCHAR(8) NULL,
    [Umkrid] VARCHAR(15) NULL,
    [mkrtime] VARCHAR(15) NULL,
    [Umkrtime] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CL_EBROK
-- --------------------------------------------------
CREATE TABLE [dbo].[CL_EBROK]
(
    [party_code] VARCHAR(100) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [L_phoneR] VARCHAR(15) NULL,
    [L_phoneO] VARCHAR(15) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL,
    [cl_category] VARCHAR(6) NOT NULL,
    [profile] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CL_EBROK1
-- --------------------------------------------------
CREATE TABLE [dbo].[CL_EBROK1]
(
    [party_code] VARCHAR(100) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [L_phoneR] VARCHAR(15) NULL,
    [L_phoneO] VARCHAR(15) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL,
    [cl_category] VARCHAR(6) NOT NULL,
    [profile] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_EBROK1_new
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_EBROK1_new]
(
    [party_code] VARCHAR(100) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [L_phoneR] VARCHAR(15) NULL,
    [L_phoneO] VARCHAR(15) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL,
    [cl_category] VARCHAR(6) NOT NULL,
    [profile] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CL_Trade
-- --------------------------------------------------
CREATE TABLE [dbo].[CL_Trade]
(
    [party_code] VARCHAR(100) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [L_phoneR] VARCHAR(15) NULL,
    [L_phoneO] VARCHAR(15) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL,
    [cl_category] VARCHAR(6) NOT NULL,
    [profile] VARCHAR(8) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Clean_limits
-- --------------------------------------------------
CREATE TABLE [dbo].[Clean_limits]
(
    [Cl_code] VARCHAR(50) NULL,
    [Clean_limits] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLF_CLT
-- --------------------------------------------------
CREATE TABLE [dbo].[CLF_CLT]
(
    [cl_code] VARCHAR(50) NULL,
    [CLEAN_LIMITS] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLI_tradeanywhere_LimitMargin
-- --------------------------------------------------
CREATE TABLE [dbo].[CLI_tradeanywhere_LimitMargin]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [cheque_limit] CHAR(1) NULL,
    [non_apr_shares] FLOAT NULL,
    [Entered_by] VARCHAR(10) NULL,
    [Entered_on] DATETIME NULL,
    [Entered_ip] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_brok_details_ConvertedToNonECN
-- --------------------------------------------------
CREATE TABLE [dbo].[client_brok_details_ConvertedToNonECN]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [exchange] VARCHAR(3) NOT NULL,
    [segment] VARCHAR(7) NOT NULL,
    [print_options] TINYINT NULL,
    [unmarkeddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_brok_details_ConvertedToNonECN_14102010
-- --------------------------------------------------
CREATE TABLE [dbo].[client_brok_details_ConvertedToNonECN_14102010]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [exchange] VARCHAR(3) NOT NULL,
    [segment] VARCHAR(7) NOT NULL,
    [print_options] TINYINT NULL,
    [unmarkeddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details_ConvertedToNonECN
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details_ConvertedToNonECN]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [unmarkeddate] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [updatedby] VARCHAR(6) NOT NULL,
    [updatedon] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details_ConvertedToNonECN_14102010
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details_ConvertedToNonECN_14102010]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [unmarkeddate] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [updatedby] VARCHAR(6) NOT NULL,
    [updatedon] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details_ConvertedToNonECN_2122010
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details_ConvertedToNonECN_2122010]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [unmarkeddate] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [updatedby] VARCHAR(6) NOT NULL,
    [updatedon] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details_ConvertedToNonECN_gn
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details_ConvertedToNonECN_gn]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [unmarkeddate] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [updatedby] VARCHAR(6) NOT NULL,
    [updatedon] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details_ConvertedToNonECN_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details_ConvertedToNonECN_temp]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [unmarkeddate] DATETIME NOT NULL,
    [status] INT NOT NULL,
    [updatedby] VARCHAR(6) NOT NULL,
    [updatedon] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_shift
-- --------------------------------------------------
CREATE TABLE [dbo].[client_shift]
(
    [srno] INT NULL,
    [Segment] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [party_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(25) NULL,
    [sub_Broker] VARCHAR(25) NULL,
    [new_party_code] VARCHAR(25) NULL,
    [new_br] VARCHAR(25) NULL,
    [new_sb] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clientbse
-- --------------------------------------------------
CREATE TABLE [dbo].[clientbse]
(
    [Party_Code] VARCHAR(8000) NULL,
    [Party_Name] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clientemail
-- --------------------------------------------------
CREATE TABLE [dbo].[clientemail]
(
    [SrNo] INT NOT NULL,
    [Name] VARCHAR(50) NULL,
    [emailid] VARCHAR(50) NULL,
    [upd_dt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLT_ARM
-- --------------------------------------------------
CREATE TABLE [dbo].[CLT_ARM]
(
    [Cltcode] VARCHAR(50) NULL,
    [balance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clt_BEN
-- --------------------------------------------------
CREATE TABLE [dbo].[clt_BEN]
(
    [Client Code] VARCHAR(10) NULL,
    [DPID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Quantity] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLT_DPH
-- --------------------------------------------------
CREATE TABLE [dbo].[CLT_DPH]
(
    [cm_blsavingcd] CHAR(20) NULL,
    [hld_ac_code] CHAR(16) NOT NULL,
    [hld_isin_code] CHAR(12) NOT NULL,
    [hld_ac_pos] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.con3
-- --------------------------------------------------
CREATE TABLE [dbo].[con3]
(
    [Client_Code] VARCHAR(100) NOT NULL,
    [Name] VARCHAR(200) NULL,
    [Company] VARCHAR(100) NULL,
    [pod] VARCHAR(100) NOT NULL,
    [Branch] VARCHAR(100) NULL,
    [Sub_Broker] VARCHAR(20) NULL,
    [Dispatch_Date] VARCHAR(12) NULL,
    [Delivered] VARCHAR(100) NOT NULL,
    [InvokeDate] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Convert_YahooToSify
-- --------------------------------------------------
CREATE TABLE [dbo].[Convert_YahooToSify]
(
    [partycode] VARCHAR(255) NULL,
    [email] VARCHAR(50) NULL,
    [Sent] VARCHAR(1) NOT NULL,
    [updt] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.diwali
-- --------------------------------------------------
CREATE TABLE [dbo].[diwali]
(
    [Col001] CHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.doctor
-- --------------------------------------------------
CREATE TABLE [dbo].[doctor]
(
    [name] NVARCHAR(255) NULL,
    [MAILING_ADD_1] NVARCHAR(255) NULL,
    [MAILING_ADD_2] NVARCHAR(255) NULL,
    [MAILING_ADD_3] NVARCHAR(255) NULL,
    [MAILING_CITY] NVARCHAR(255) NULL,
    [MAILING_PIN] NVARCHAR(255) NULL,
    [MAILING_PHONE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EBROK_BR_EMAIL
-- --------------------------------------------------
CREATE TABLE [dbo].[EBROK_BR_EMAIL]
(
    [branch] VARCHAR(15) NULL,
    [ManagerName] VARCHAR(100) NULL,
    [email] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_Dreg_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_Dreg_branch]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(200) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(200) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ECNNO] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_Dreg_branch_03012012
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_Dreg_branch_03012012]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ECNNO] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_Dreg_branch_log
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_Dreg_branch_log]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ECNNO] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_Dreg_branchtemp
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_Dreg_branchtemp]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ECNNO] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_RDreg_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_RDreg_branch]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_21NOV2008
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_21NOV2008]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_24102008
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_24102008]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_bak_17mar2011
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_bak_17mar2011]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(100) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch_05122018
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch_05122018]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch_16Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch_16Mar2019]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(100) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch_22Mar2019
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch_22Mar2019]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(100) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch_23032019
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch_23032019]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(100) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_branch01Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_branch01Mar2019_Renamed_By_DBA]
(
    [reg_date] DATETIME NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [name] VARCHAR(100) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [access_code] VARCHAR(30) NULL,
    [access_to] VARCHAR(20) NULL,
    [status] VARCHAR(10) NULL,
    [path] VARCHAR(300) NULL,
    [path2] VARCHAR(300) NULL,
    [ref_no] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_changemail
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_changemail]
(
    [client_code] VARCHAR(10) NULL,
    [mail_id] VARCHAR(45) NULL,
    [flag] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_GENERATE
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_GENERATE]
(
    [CLIENT_CODE] VARCHAR(10) NULL,
    [ECN_NO] INT IDENTITY(44774,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ECN_REG_GENERATE_27may2021
-- --------------------------------------------------
CREATE TABLE [dbo].[ECN_REG_GENERATE_27may2021]
(
    [CLIENT_CODE] VARCHAR(10) NULL,
    [ECN_NO] INT IDENTITY(44774,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ECN_REG_GENERATE_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ECN_REG_GENERATE_hist]
(
    [client_code] VARCHAR(10) NULL,
    [ecn_no] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ECN_REG_GENERATE_test
-- --------------------------------------------------
CREATE TABLE [dbo].[ECN_REG_GENERATE_test]
(
    [CLIENT_CODE] VARCHAR(10) NULL,
    [ECN_NO] INT IDENTITY(44774,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_log
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_log]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] VARCHAR(11) NULL,
    [log_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_pswd
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_pswd]
(
    [client_code] VARCHAR(10) NULL,
    [mail_id] VARCHAR(45) NULL,
    [flag] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_rashmi
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_rashmi]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_rashmi1
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_rashmi1]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg_triglog
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg_triglog]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL,
    [actiontype] VARCHAR(8) NULL,
    [actionDate] DATETIME NOT NULL,
    [HOST] VARCHAR(20) NULL,
    [IPAddress] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecn_reg23032011
-- --------------------------------------------------
CREATE TABLE [dbo].[ecn_reg23032011]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(50) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ECNBOUNCE_SMS_log
-- --------------------------------------------------
CREATE TABLE [dbo].[ECNBOUNCE_SMS_log]
(
    [Party_code] VARCHAR(15) NULL,
    [Mobile_pager] VARCHAR(14) NULL,
    [Bounce_date] DATETIME NULL,
    [Sent_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecnCodes
-- --------------------------------------------------
CREATE TABLE [dbo].[ecnCodes]
(
    [Column 0] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ecnreg_pswd_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[ecnreg_pswd_temp]
(
    [client_code] VARCHAR(10) NULL,
    [mail_id] VARCHAR(45) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ECNTEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[ECNTEMP]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fo pending
-- --------------------------------------------------
CREATE TABLE [dbo].[Fo pending]
(
    [ClientCode] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo3
-- --------------------------------------------------
CREATE TABLE [dbo].[fo3]
(
    [party_Code] CHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [long_name] VARCHAR(50) NOT NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [L_address2] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(15) NULL,
    [L_nation] VARCHAR(15) NULL,
    [L_zip] VARCHAR(10) NULL,
    [Fax] VARCHAR(15) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [email] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(3) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [family] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GENESIS_1
-- --------------------------------------------------
CREATE TABLE [dbo].[GENESIS_1]
(
    [party_Code] VARCHAR(10) NULL,
    [ori_path] VARCHAR(1000) NULL,
    [ori_size] VARCHAR(100) NULL,
    [conv_path] VARCHAR(1000) NULL,
    [conv_size] VARCHAR(100) NULL,
    [updated_date] DATETIME NULL,
    [folder] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GetEcnNO
-- --------------------------------------------------
CREATE TABLE [dbo].[GetEcnNO]
(
    [EcnNo] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.getsbbday
-- --------------------------------------------------
CREATE TABLE [dbo].[getsbbday]
(
    [sbreg] NUMERIC(25, 3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HOLIDAY_MASTER_MAKER
-- --------------------------------------------------
CREATE TABLE [dbo].[HOLIDAY_MASTER_MAKER]
(
    [Holiday_Date] DATETIME NOT NULL,
    [Holiday_Name] VARCHAR(60) NOT NULL,
    [Status] CHAR(1) NOT NULL,
    [Maker_Id] VARCHAR(15) NOT NULL,
    [Maker_Date] DATETIME NOT NULL,
    [Checker_Id] VARCHAR(15) NULL,
    [Checker_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.jitu
-- --------------------------------------------------
CREATE TABLE [dbo].[jitu]
(
    [DATE] VARCHAR(255) NULL,
    [DEAL_no] VARCHAR(100) NULL,
    [SETT_NO] VARCHAR(255) NULL,
    [party_name] VARCHAR(255) NULL,
    [SCRIP] VARCHAR(255) NULL,
    [S_P] VARCHAR(255) NULL,
    [QTY] INT NULL,
    [RATE] MONEY NULL,
    [NET_amt] MONEY NULL,
    [CHRGS] MONEY NULL,
    [CLID] VARCHAR(100) NULL,
    [DPID] VARCHAR(255) NULL,
    [SETT_DATE] DATETIME NULL,
    [DP_NAME] VARCHAR(255) NULL,
    [SB_ACC] VARCHAR(100) NULL,
    [BASIS] VARCHAR(255) NULL,
    [LOCATION] VARCHAR(255) NULL,
    [TYPE] VARCHAR(255) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KARUNA
-- --------------------------------------------------
CREATE TABLE [dbo].[KARUNA]
(
    [s_no] NUMERIC(18, 0) NULL,
    [client_code] VARCHAR(50) NULL,
    [client_name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.lastebrokInitdate
-- --------------------------------------------------
CREATE TABLE [dbo].[lastebrokInitdate]
(
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.location
-- --------------------------------------------------
CREATE TABLE [dbo].[location]
(
    [location] VARCHAR(50) NULL,
    [last_uploaded] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LOw_brok_cli_DispatchStatus_mail
-- --------------------------------------------------
CREATE TABLE [dbo].[LOw_brok_cli_DispatchStatus_mail]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(15) NULL,
    [Pod_no] VARCHAR(20) NULL,
    [Client_name] VARCHAR(100) NULL,
    [Dispatch_dt] VARCHAR(25) NULL,
    [Ecn_reg] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mail_table
-- --------------------------------------------------
CREATE TABLE [dbo].[mail_table]
(
    [sender] VARCHAR(100) NULL,
    [subject] VARCHAR(2000) NULL,
    [received] DATETIME NULL,
    [read_unread] VARCHAR(50) NULL,
    [message] VARCHAR(8000) NULL,
    [Attachments] VARCHAR(8000) NULL,
    [cc] VARCHAR(8000) NULL,
    [bcc] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mail_table2
-- --------------------------------------------------
CREATE TABLE [dbo].[mail_table2]
(
    [sender_name] VARCHAR(200) NULL,
    [subject] VARCHAR(300) NULL,
    [sent] VARCHAR(50) NULL,
    [message] VARCHAR(5000) NULL,
    [cc] VARCHAR(1000) NULL,
    [bcc] VARCHAR(1000) NULL,
    [Attachments] VARCHAR(500) NULL,
    [read_unread] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MappingClientOfAP_NCXSegment_05012026
-- --------------------------------------------------
CREATE TABLE [dbo].[MappingClientOfAP_NCXSegment_05012026]
(
    [sr_No] VARCHAR(50) NULL,
    [Member_Id] VARCHAR(50) NULL,
    [Member_Name] VARCHAR(MAX) NULL,
    [AP_Code] NVARCHAR(50) NULL,
    [AP_Name] VARCHAR(MAX) NULL,
    [AP_PAN] NVARCHAR(50) NULL,
    [Client_Code] NVARCHAR(50) NULL,
    [Client_Name] VARCHAR(MAX) NULL,
    [Client_PAN] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MappingClientsOfAuthorizedPerson_NCXSegmentData_01122025
-- --------------------------------------------------
CREATE TABLE [dbo].[MappingClientsOfAuthorizedPerson_NCXSegmentData_01122025]
(
    [Sr_No] VARCHAR(50) NULL,
    [Member_Id] VARCHAR(50) NULL,
    [Member_Name] VARCHAR(MAX) NULL,
    [AP_Code] NVARCHAR(50) NULL,
    [AP_Name] VARCHAR(MAX) NULL,
    [AP_PAN] NVARCHAR(50) NULL,
    [Client_Code] NVARCHAR(50) NULL,
    [Client_Name] VARCHAR(MAX) NULL,
    [Client_PAN] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Master_bolt
-- --------------------------------------------------
CREATE TABLE [dbo].[Master_bolt]
(
    [Srno] NUMERIC(18, 0) NULL,
    [Segment] NVARCHAR(255) NULL,
    [Bolt_no] MONEY NULL,
    [Client_name] NVARCHAR(255) NULL,
    [Personto] NVARCHAR(255) NULL,
    [Location] NVARCHAR(255) NULL,
    [Telephone] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Master_Doctor
-- --------------------------------------------------
CREATE TABLE [dbo].[Master_Doctor]
(
    [TITLE] VARCHAR(500) NULL,
    [F_NAME] VARCHAR(500) NULL,
    [M_NAME] VARCHAR(500) NULL,
    [L_NAME] VARCHAR(500) NULL,
    [ADDRESS_1] VARCHAR(500) NULL,
    [ADDRESS_2] VARCHAR(500) NULL,
    [ADDRESS_3] VARCHAR(500) NULL,
    [CITY] VARCHAR(500) NULL,
    [PIN] VARCHAR(500) NULL,
    [PHONE] VARCHAR(500) NULL,
    [FAX] VARCHAR(500) NULL,
    [MOBILE] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_12
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_12]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] VARCHAR(255) NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL,
    [Col026] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_date
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_date]
(
    [senddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MUMBAI
-- --------------------------------------------------
CREATE TABLE [dbo].[MUMBAI]
(
    [SBCODE] NVARCHAR(255) NULL,
    [NAME OF SB] NVARCHAR(255) NULL,
    [ADDRESS 1] NVARCHAR(255) NULL,
    [ADDRESS2] NVARCHAR(255) NULL,
    [CITY] NVARCHAR(255) NULL,
    [PIN CODE] VARCHAR(10) NULL,
    [PHONE NO] VARCHAR(20) NULL,
    [PHONE ] VARCHAR(20) NULL,
    [PHONE1] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Nod_bounce_NECN
-- --------------------------------------------------
CREATE TABLE [dbo].[Nod_bounce_NECN]
(
    [Nod] INT NULL,
    [ModifiedBy] VARCHAR(15) NULL,
    [ModifiedOn] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Nod_bounce_NECN_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Nod_bounce_NECN_hist]
(
    [Nod] INT NULL,
    [ModifiedBy] VARCHAR(15) NULL,
    [ModifiedOn] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NonECN_MAIL_addr
-- --------------------------------------------------
CREATE TABLE [dbo].[NonECN_MAIL_addr]
(
    [branch] VARCHAR(12) NULL,
    [BM] VARCHAR(70) NULL,
    [BM_mail] VARCHAR(120) NULL,
    [RGM] VARCHAR(70) NULL,
    [RGM_mail] VARCHAR(120) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPV_FromTo_month
-- --------------------------------------------------
CREATE TABLE [dbo].[NPV_FromTo_month]
(
    [mnth] INT NULL,
    [myear] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPV_product_master
-- --------------------------------------------------
CREATE TABLE [dbo].[NPV_product_master]
(
    [PolicyCode] INT IDENTITY(1,1) NOT NULL,
    [PolicyType] VARCHAR(200) NULL,
    [NPV_2_3] MONEY NULL,
    [NPV_4_5] MONEY NULL,
    [NPV_6onwards] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPV_Setup
-- --------------------------------------------------
CREATE TABLE [dbo].[NPV_Setup]
(
    [RenSuccRatio] FLOAT NULL,
    [DescountingFact_month] FLOAT NULL,
    [DescountingFact_yr] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPV_TEMP_product_master
-- --------------------------------------------------
CREATE TABLE [dbo].[NPV_TEMP_product_master]
(
    [PolicyCode] INT NOT NULL,
    [PolicyType] VARCHAR(200) NULL,
    [NPV_2_3] MONEY NULL,
    [NPV_4_5] MONEY NULL,
    [NPV_6onwards] MONEY NULL,
    [username] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_debit
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_debit]
(
    [cltcode] VARCHAR(255) NULL,
    [led_balance] VARCHAR(255) NULL,
    [scrip_cd] VARCHAR(255) NULL,
    [series] VARCHAR(255) NULL,
    [qty] VARCHAR(255) NULL,
    [holding] VARCHAR(255) NULL,
    [pledge] VARCHAR(255) NULL,
    [pqty] VARCHAR(255) NULL,
    [pvalue] VARCHAR(255) NULL,
    [Rate_Share] VARCHAR(255) NULL,
    [Pledable.Qty] VARCHAR(255) NULL,
    [Max_Qty] VARCHAR(255) NULL,
    [Value] VARCHAR(255) NULL,
    [Balance] VARCHAR(255) NULL,
    [Pled_Balance] VARCHAR(255) NULL,
    [aa] VARCHAR(255) NULL,
    [revPQty] INT NULL,
    [AfterBalance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_isin
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_isin]
(
    [Symbol] VARCHAR(15) NULL,
    [Name] VARCHAR(50) NULL,
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ODIN_LIMITS
-- --------------------------------------------------
CREATE TABLE [dbo].[ODIN_LIMITS]
(
    [OpCode] VARCHAR(100) NULL,
    [UserCode] VARCHAR(100) NULL,
    [Group_Id] VARCHAR(100) NULL,
    [Deposit] VARCHAR(100) NULL,
    [Code] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Series] VARCHAR(100) NULL,
    [SGroup] VARCHAR(100) NULL,
    [Periodicity] VARCHAR(100) NULL,
    [Instrument_Name] VARCHAR(100) NULL,
    [Expiry] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Gross_Expo_Mult] VARCHAR(100) NULL,
    [GE_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Expo_Multi] VARCHAR(100) NULL,
    [Net_Purchase_Premium_in_000s] VARCHAR(100) NULL,
    [Net_Sale_Expo_Multi] VARCHAR(100) NULL,
    [NSE_Write_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Pos_Multi] VARCHAR(100) NULL,
    [NP_Limit_in_000s] VARCHAR(100) NULL,
    [Turnover_Multi] VARCHAR(100) NULL,
    [TurnOver_Limit_in_000s] VARCHAR(100) NULL,
    [Pending_Order_Multi] VARCHAR(100) NULL,
    [Pending_Order_Limit_in_000s] VARCHAR(100) NULL,
    [MTM_Loss_Multi] VARCHAR(100) NULL,
    [MTM_Limit_in_000s] VARCHAR(100) NULL,
    [Margin_Limit_Multi] VARCHAR(100) NULL,
    [Margin_Limit_in_000s] VARCHAR(100) NULL,
    [NQ_Limit] VARCHAR(100) NULL,
    [Max_Order_Value] VARCHAR(100) NULL,
    [Max_Order_Qty] VARCHAR(100) NULL,
    [Retain_Multi] VARCHAR(100) NULL,
    [Inclu_MTM] VARCHAR(100) NULL,
    [Inclu_Net_Premium] VARCHAR(100) NULL,
    [Gross_Net] VARCHAR(100) NULL,
    [location] VARCHAR(100) NULL,
    [udatetime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.odin_limits_member
-- --------------------------------------------------
CREATE TABLE [dbo].[odin_limits_member]
(
    [OpCode] VARCHAR(100) NULL,
    [UserCode] VARCHAR(100) NULL,
    [Group_Id] VARCHAR(100) NULL,
    [Deposit] VARCHAR(100) NULL,
    [Code] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Series] VARCHAR(100) NULL,
    [SGroup] VARCHAR(100) NULL,
    [Periodicity] VARCHAR(100) NULL,
    [Instrument_Name] VARCHAR(100) NULL,
    [Expiry] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Gross_Expo_Mult] VARCHAR(100) NULL,
    [GE_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Expo_Multi] VARCHAR(100) NULL,
    [Net_Purchase_Premium_in_000s] VARCHAR(100) NULL,
    [Net_Sale_Expo_Multi] VARCHAR(100) NULL,
    [NSE_Write_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Pos_Multi] VARCHAR(100) NULL,
    [NP_Limit_in_000s] VARCHAR(100) NULL,
    [Turnover_Multi] VARCHAR(100) NULL,
    [TurnOver_Limit_in_000s] VARCHAR(100) NULL,
    [Pending_Order_Multi] VARCHAR(100) NULL,
    [Pending_Order_Limit_in_000s] VARCHAR(100) NULL,
    [MTM_Loss_Multi] VARCHAR(100) NULL,
    [MTM_Limit_in_000s] VARCHAR(100) NULL,
    [Margin_Limit_Multi] VARCHAR(100) NULL,
    [Margin_Limit_in_000s] VARCHAR(100) NULL,
    [NQ_Limit] VARCHAR(100) NULL,
    [Max_Order_Value] VARCHAR(100) NULL,
    [Max_Order_Qty] VARCHAR(100) NULL,
    [Retain_Multi] VARCHAR(100) NULL,
    [Inclu_MTM] VARCHAR(100) NULL,
    [Inclu_Net_Premium] VARCHAR(100) NULL,
    [Gross_Net] VARCHAR(100) NULL,
    [location] VARCHAR(100) NULL,
    [udatetime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.odin_limits_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[odin_limits_temp]
(
    [OpCode] VARCHAR(100) NULL,
    [UserCode] VARCHAR(100) NULL,
    [Group_Id] VARCHAR(100) NULL,
    [Deposit] VARCHAR(100) NULL,
    [Code] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Series] VARCHAR(100) NULL,
    [SGroup] VARCHAR(100) NULL,
    [Periodicity] VARCHAR(100) NULL,
    [Instrument_Name] VARCHAR(100) NULL,
    [Expiry] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Gross_Expo_Mult] VARCHAR(100) NULL,
    [GE_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Expo_Multi] VARCHAR(100) NULL,
    [Net_Purchase_Premium_in_000s] VARCHAR(100) NULL,
    [Net_Sale_Expo_Multi] VARCHAR(100) NULL,
    [NSE_Write_Limit_in_000s] VARCHAR(100) NULL,
    [Net_Pos_Multi] VARCHAR(100) NULL,
    [NP_Limit_in_000s] VARCHAR(100) NULL,
    [Turnover_Multi] VARCHAR(100) NULL,
    [TurnOver_Limit_in_000s] VARCHAR(100) NULL,
    [Pending_Order_Multi] VARCHAR(100) NULL,
    [Pending_Order_Limit_in_000s] VARCHAR(100) NULL,
    [MTM_Loss_Multi] VARCHAR(100) NULL,
    [MTM_Limit_in_000s] VARCHAR(100) NULL,
    [Margin_Limit_Multi] VARCHAR(100) NULL,
    [Margin_Limit_in_000s] VARCHAR(100) NULL,
    [NQ_Limit] VARCHAR(100) NULL,
    [Max_Order_Value] VARCHAR(100) NULL,
    [Max_Order_Qty] VARCHAR(100) NULL,
    [Retain_Multi] VARCHAR(100) NULL,
    [Inclu_MTM] VARCHAR(100) NULL,
    [Inclu_Net_Premium] VARCHAR(100) NULL,
    [Gross_Net] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ofm
-- --------------------------------------------------
CREATE TABLE [dbo].[ofm]
(
    [sb tag] NVARCHAR(255) NULL,
    [name of sb] NVARCHAR(255) NULL,
    [add1] NVARCHAR(255) NULL,
    [add2] NVARCHAR(255) NULL,
    [city] NVARCHAR(255) NULL,
    [pin] VARCHAR(10) NULL,
    [ph1] FLOAT NOT NULL,
    [ph1a] FLOAT NOT NULL,
    [ph2] NVARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OUT_OF_MUMBAI
-- --------------------------------------------------
CREATE TABLE [dbo].[OUT_OF_MUMBAI]
(
    [SB TAG] NVARCHAR(255) NULL,
    [NAME OF SB] NVARCHAR(255) NULL,
    [ADD1] NVARCHAR(255) NULL,
    [ADD2] NVARCHAR(255) NULL,
    [CITY] NVARCHAR(255) NULL,
    [PIN] FLOAT NULL,
    [PH 1] FLOAT NULL,
    [PH2] FLOAT NULL,
    [PH3] NVARCHAR(255) NULL,
    [F10] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PARSOLI
-- --------------------------------------------------
CREATE TABLE [dbo].[PARSOLI]
(
    [s_no] NUMERIC(18, 0) NULL,
    [client_code] VARCHAR(50) NULL,
    [client_name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.periodicity
-- --------------------------------------------------
CREATE TABLE [dbo].[periodicity]
(
    [perioducity] VARCHAR(100) NULL,
    [Value] INT NULL,
    [mode] VARCHAR(25) NULL,
    [value_limit] MONEY NULL,
    [qty_limit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.policy_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[policy_upload]
(
    [PolicyType] VARCHAR(100) NULL,
    [Payterm] VARCHAR(100) NULL,
    [Sum] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.policytable
-- --------------------------------------------------
CREATE TABLE [dbo].[policytable]
(
    [PolicyType] VARCHAR(100) NULL,
    [Payterm] INT NULL,
    [Sum] MONEY NULL,
    [Month] VARCHAR(50) NULL,
    [Year] VARCHAR(50) NULL,
    [UploadedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RA_VendorMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[RA_VendorMaster]
(
    [RefNo] BIGINT NULL,
    [RATAG] VARCHAR(55) NULL,
    [Branch] VARCHAR(55) NULL,
    [TradeName] VARCHAR(455) NULL,
    [OrgType] VARCHAR(2) NULL,
    [NoOfPartners] INT NULL,
    [PanNo] VARCHAR(15) NULL,
    [TagGeneratedDate] DATETIME NULL,
    [RA_Status] VARCHAR(25) NULL,
    [CreatedBy] VARCHAR(25) NULL,
    [CreatedDate] DATETIME NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL,
    [Category] VARCHAR(15) NULL,
    [IsActive] VARCHAR(15) NULL,
    [IsActiveDate] DATETIME NULL,
    [Remarks] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rejected_Decn
-- --------------------------------------------------
CREATE TABLE [dbo].[rejected_Decn]
(
    [Party_code] VARCHAR(15) NULL,
    [Reason] VARCHAR(500) NULL,
    [RejectedOn] DATETIME NULL,
    [RejectedBy] VARCHAR(12) NULL,
    [status] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rejected_ecn
-- --------------------------------------------------
CREATE TABLE [dbo].[rejected_ecn]
(
    [Party_code] VARCHAR(15) NULL,
    [Reason] VARCHAR(500) NULL,
    [RejectedOn] DATETIME NULL,
    [RejectedBy] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Report
-- --------------------------------------------------
CREATE TABLE [dbo].[Report]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [TelNo] NVARCHAR(50) NULL,
    [MobileNo] NVARCHAR(50) NULL,
    [Location] VARCHAR(50) NULL,
    [Email] VARCHAR(50) NULL,
    [reg_datetime] DATETIME NULL,
    [Remark] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Restore_NECN
-- --------------------------------------------------
CREATE TABLE [dbo].[Restore_NECN]
(
    [Party_code] VARCHAR(15) NULL,
    [Reason] VARCHAR(250) NULL,
    [RestoredOn] DATETIME NULL,
    [RestoredBy] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_email
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_email]
(
    [sbcode] VARCHAR(15) NULL,
    [email] VARCHAR(80) NULL,
    [Branch] VARCHAR(12) NULL,
    [BrEmail] VARCHAR(120) NULL,
    [Sent] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_tradeanywhere_LimitMargin
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_tradeanywhere_LimitMargin]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [cheque_limit] CHAR(1) NULL,
    [non_apr_shares] FLOAT NULL,
    [Entered_by] VARCHAR(10) NULL,
    [Entered_on] DATETIME NULL,
    [Entered_ip] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip_alert
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip_alert]
(
    [qty_limit] MONEY NULL,
    [value_limit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sector_Analyst
-- --------------------------------------------------
CREATE TABLE [dbo].[Sector_Analyst]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [AnalystName] VARCHAR(50) NULL,
    [Sector1] VARCHAR(50) NULL,
    [Sector2] VARCHAR(50) NULL,
    [Sector3] VARCHAR(50) NULL,
    [Sector4] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SentMail_ECN
-- --------------------------------------------------
CREATE TABLE [dbo].[SentMail_ECN]
(
    [party_code] VARCHAR(10) NOT NULL,
    [Sent] VARCHAR(1) NOT NULL,
    [email] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SentMail_ECN_ALL
-- --------------------------------------------------
CREATE TABLE [dbo].[SentMail_ECN_ALL]
(
    [party_code] VARCHAR(10) NOT NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [email] VARCHAR(50) NULL,
    [flag] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sentmail_sify
-- --------------------------------------------------
CREATE TABLE [dbo].[sentmail_sify]
(
    [party_code] VARCHAR(10) NOT NULL,
    [email] VARCHAR(50) NULL,
    [sent] VARCHAR(1) NOT NULL,
    [pdf] VARCHAR(1) NOT NULL,
    [email_date] DATETIME NOT NULL,
    [status] VARCHAR(20) NULL,
    [html] VARCHAR(1) NULL,
    [pdf_date] DATETIME NULL,
    [html_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sentmail_sify1
-- --------------------------------------------------
CREATE TABLE [dbo].[sentmail_sify1]
(
    [party_code] VARCHAR(20) NULL,
    [email] VARCHAR(200) NULL,
    [status] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sify_Return_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[Sify_Return_fin]
(
    [party_code] VARCHAR(15) NULL,
    [Udate] DATETIME NULL,
    [Status] VARCHAR(40) NULL,
    [UploadDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SUMMARY_super_22012007164
-- --------------------------------------------------
CREATE TABLE [dbo].[SUMMARY_super_22012007164]
(
    [ClientCode] VARCHAR(8000) NULL,
    [Clientlockstatus] VARCHAR(8000) NULL,
    [PasswordLock] VARCHAR(8000) NULL,
    [Source] VARCHAR(8000) NULL,
    [LoggedInSource] VARCHAR(8000) NULL,
    [LoginID] VARCHAR(8000) NULL,
    [Branch] VARCHAR(8000) NULL,
    [SuspensionStatus] VARCHAR(8000) NULL,
    [ProfileCode] VARCHAR(8000) NULL,
    [ClientType] VARCHAR(8000) NULL,
    [ClientCategory] VARCHAR(8000) NULL,
    [PrimaryDealer] VARCHAR(8000) NULL,
    [ClienTStatus] VARCHAR(8000) NULL,
    [ClientName] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sureshT
-- --------------------------------------------------
CREATE TABLE [dbo].[sureshT]
(
    [sub_Broker] VARCHAR(50) NULL,
    [pclcurname] VARCHAR(200) NULL,
    [padd1] VARCHAR(200) NULL,
    [padd2] VARCHAR(200) NULL,
    [padd3] VARCHAR(200) NULL,
    [padd4] VARCHAR(200) NULL,
    [padd5] VARCHAR(200) NULL,
    [Col008] VARCHAR(10) NULL,
    [Col009] VARCHAR(10) NULL,
    [Col010] VARCHAR(10) NULL
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
-- TABLE dbo.t2tdate
-- --------------------------------------------------
CREATE TABLE [dbo].[t2tdate]
(
    [tdate] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TASNEEM
-- --------------------------------------------------
CREATE TABLE [dbo].[TASNEEM]
(
    [SBCODE] VARCHAR(255) NULL,
    [type] VARCHAR(255) NULL,
    [name] VARCHAR(255) NULL,
    [address] VARCHAR(255) NULL,
    [CITY] VARCHAR(255) NULL,
    [pin] VARCHAR(10) NULL,
    [address1] VARCHAR(20) NULL,
    [state] VARCHAR(20) NULL,
    [ph1] VARCHAR(255) NULL,
    [ph] VARCHAR(50) NULL,
    [fax] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Apollo_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Apollo_InsuranceDetails]
(
    [POLICY_TYPE] NVARCHAR(MAX) NULL,
    [PRODUCT_CODE] NVARCHAR(MAX) NULL,
    [POLICY_NUMBER] NVARCHAR(MAX) NULL,
    [AGENT_NAME] NVARCHAR(MAX) NULL,
    [AGENT_CODE] NVARCHAR(MAX) NULL,
    [CHANNEL_CODE] NVARCHAR(MAX) NULL,
    [BRANCH] NVARCHAR(MAX) NULL,
    [POLICY_HOLDER_NAME] NVARCHAR(MAX) NULL,
    [START_DATE] NVARCHAR(MAX) NULL,
    [EXPIRY_DATE] NVARCHAR(MAX) NULL,
    [ENTRY_DATE] NVARCHAR(MAX) NULL,
    [ENDORSEMENT_DATE] NVARCHAR(MAX) NULL,
    [PREMIUM] NVARCHAR(MAX) NULL,
    [SERVICE_TAX] NVARCHAR(MAX) NULL,
    [TOTAL_PREMIUM] NVARCHAR(MAX) NULL,
    [STATUS] NVARCHAR(MAX) NULL,
    [BRANCH_CODE] NVARCHAR(MAX) NULL,
    [Application_No_] NVARCHAR(MAX) NULL,
    [Zone] NVARCHAR(MAX) NULL,
    [Region2] NVARCHAR(MAX) NULL,
    [Rel] NVARCHAR(MAX) NULL,
    [Branch_Login] NVARCHAR(MAX) NULL,
    [Renewal] NVARCHAR(MAX) NULL,
    [Product_Name] NVARCHAR(MAX) NULL,
    [NOP] NVARCHAR(MAX) NULL,
    [SUM_Insured] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Bajaj_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Bajaj_InsuranceDetails]
(
    [Rid_T_Date] NVARCHAR(MAX) NULL,
    [Rid_T_Month] NVARCHAR(MAX) NULL,
    [Partner_Id] NVARCHAR(MAX) NULL,
    [Old_Policy_No] NVARCHAR(MAX) NULL,
    [Prev_Insurer_Name] NVARCHAR(MAX) NULL,
    [Ren_Roll_Nb_Flag] NVARCHAR(MAX) NULL,
    [Policy_Number] NVARCHAR(MAX) NULL,
    [Version] NVARCHAR(MAX) NULL,
    [Policy_Status] NVARCHAR(MAX) NULL,
    [Policy_Issue_Date] NVARCHAR(MAX) NULL,
    [Risk_Inc_Date] NVARCHAR(MAX) NULL,
    [Risk_Expiry_Date] NVARCHAR(MAX) NULL,
    [T_Date_Desc] NVARCHAR(MAX) NULL,
    [Imd_Desc] NVARCHAR(MAX) NULL,
    [Sub_Imd] NVARCHAR(MAX) NULL,
    [Office_Loc_Id] NVARCHAR(MAX) NULL,
    [Location_Desc] NVARCHAR(MAX) NULL,
    [Product_Id] NVARCHAR(MAX) NULL,
    [Product_Desc] NVARCHAR(MAX) NULL,
    [Partner_Desc] NVARCHAR(MAX) NULL,
    [Line_Of_Business] NVARCHAR(MAX) NULL,
    [Loader_Flag] NVARCHAR(MAX) NULL,
    [Loan_Acc_No] NVARCHAR(MAX) NULL,
    [Partner_City] NVARCHAR(MAX) NULL,
    [Partner_Dob] NVARCHAR(MAX) NULL,
    [Partner_Pin_Code] NVARCHAR(MAX) NULL,
    [Partner_Region] NVARCHAR(MAX) NULL,
    [Pay_Method] NVARCHAR(MAX) NULL,
    [Old_Policy_No_1] NVARCHAR(MAX) NULL,
    [Od_Prem] NVARCHAR(MAX) NULL,
    [Tp_Prem] NVARCHAR(MAX) NULL,
    [NCB_Percent] NVARCHAR(MAX) NULL,
    [Regn_No] NVARCHAR(MAX) NULL,
    [Vehicle_Age] NVARCHAR(MAX) NULL,
    [Vehicle_Gvw] NVARCHAR(MAX) NULL,
    [Sum_Insured] NVARCHAR(MAX) NULL,
    [Gross_Premium] NVARCHAR(MAX) NULL,
    [Net_Premium] NVARCHAR(MAX) NULL,
    [Username] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Care_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Care_InsuranceDetails]
(
    [Product] NVARCHAR(MAX) NULL,
    [Sub_Package] NVARCHAR(MAX) NULL,
    [Business_Type] NVARCHAR(MAX) NULL,
    [Sub_Business_Type] NVARCHAR(MAX) NULL,
    [Vertical] NVARCHAR(MAX) NULL,
    [Sub_Vertical] NVARCHAR(MAX) NULL,
    [RHICLBranch_Name] NVARCHAR(MAX) NULL,
    [RHICL_RM_Name] NVARCHAR(MAX) NULL,
    [Proposal_No] NVARCHAR(MAX) NULL,
    [Login_Date] NVARCHAR(MAX) NULL,
    [Policy_No] NVARCHAR(MAX) NULL,
    [Tenure_GWP] NVARCHAR(MAX) NULL,
    [Total_GWP] NVARCHAR(MAX) NULL,
    [Service_Tax] NVARCHAR(MAX) NULL,
    [Payment_Amount__Login_] NVARCHAR(MAX) NULL,
    [Policy_Start_Date] NVARCHAR(MAX) NULL,
    [Issuance_Date] NVARCHAR(MAX) NULL,
    [Policy_End_Date] NVARCHAR(MAX) NULL,
    [Policy_tenure] NVARCHAR(MAX) NULL,
    [Cancel_Decline_Date] NVARCHAR(MAX) NULL,
    [Cancel__Decline_Reason] NVARCHAR(MAX) NULL,
    [Process_Status_Description] NVARCHAR(MAX) NULL,
    [Final_Status] NVARCHAR(MAX) NULL,
    [Final_Sub_Status] NVARCHAR(MAX) NULL,
    [Customer_Name] NVARCHAR(MAX) NULL,
    [Partner_Code] NVARCHAR(MAX) NULL,
    [Partner_RM_Code] NVARCHAR(MAX) NULL,
    [Partner_Branch_Code] NVARCHAR(MAX) NULL,
    [Mode_Of_Payment] NVARCHAR(MAX) NULL,
    [Sum_Assured] NVARCHAR(MAX) NULL,
    [Loan_No] NVARCHAR(MAX) NULL,
    [Child_Code] NVARCHAR(MAX) NULL,
    [Child_Name] NVARCHAR(MAX) NULL,
    [Month] NVARCHAR(MAX) NULL,
    [Receipt_No] NVARCHAR(MAX) NULL,
    [SmartSelect_Flag] NVARCHAR(MAX) NULL,
    [Customer_Account_No] NVARCHAR(MAX) NULL,
    [Latest_Receipt_Date] NVARCHAR(MAX) NULL,
    [Transaction_Date] NVARCHAR(MAX) NULL,
    [SP_Code] NVARCHAR(MAX) NULL,
    [SP_Name] NVARCHAR(MAX) NULL,
    [Bank_Unique_code] NVARCHAR(MAX) NULL,
    [Sub_Package_Code] NVARCHAR(MAX) NULL,
    [Reciept_date] NVARCHAR(MAX) NULL,
    [Endorsement_Reason] NVARCHAR(MAX) NULL,
    [Endorsement_Date] NVARCHAR(MAX) NULL,
    [Franchise_code] NVARCHAR(MAX) NULL,
    [Previous_Policy_No] NVARCHAR(MAX) NULL,
    [Previous_Policy_Insurer] NVARCHAR(MAX) NULL,
    [Billing_Frequency] NVARCHAR(MAX) NULL,
    [Product_Category] NVARCHAR(MAX) NULL,
    [Product_Code] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Cigna_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Cigna_InsuranceDetails]
(
    [Agent_Code] NVARCHAR(MAX) NULL,
    [Agent_Name] NVARCHAR(MAX) NULL,
    [Policy_Number] NVARCHAR(MAX) NULL,
    [Proposal_No] NVARCHAR(MAX) NULL,
    [Proposal_Login_Date] NVARCHAR(MAX) NULL,
    [Sub_Plan_Name] NVARCHAR(MAX) NULL,
    [Inward_Type] NVARCHAR(MAX) NULL,
    [Policy_Type] NVARCHAR(MAX) NULL,
    [Mode_Of_Payment] NVARCHAR(MAX) NULL,
    [Received_Amount] NVARCHAR(MAX) NULL,
    [Premium_Amount] NVARCHAR(MAX) NULL,
    [Sum_Insured] NVARCHAR(MAX) NULL,
    [Policy_Term] NVARCHAR(MAX) NULL,
    [Proposer_Name] NVARCHAR(MAX) NULL,
    [No_Of_Insured] NVARCHAR(MAX) NULL,
    [Decision_Date] NVARCHAR(MAX) NULL,
    [Issue_Date] NVARCHAR(MAX) NULL,
    [Policy_Start_Date] NVARCHAR(MAX) NULL,
    [Policy_End_Date] NVARCHAR(MAX) NULL,
    [Zone_Type] NVARCHAR(MAX) NULL,
    [Policy_Servicing_Branch] NVARCHAR(MAX) NULL,
    [Login_Location] NVARCHAR(MAX) NULL,
    [Agency_Manager] NVARCHAR(MAX) NULL,
    [Reference_Code_A] NVARCHAR(MAX) NULL,
    [Reference_Code_B] NVARCHAR(MAX) NULL,
    [Partner_Branch_Id] NVARCHAR(MAX) NULL,
    [Partner_Branch_Desc] NVARCHAR(MAX) NULL,
    [Partner_Vertical_Code] NVARCHAR(MAX) NULL,
    [Partner_Vertical_Name] NVARCHAR(MAX) NULL,
    [STP_NSTP] NVARCHAR(MAX) NULL,
    [Zone] NVARCHAR(MAX) NULL,
    [Issuance_Status] NVARCHAR(MAX) NULL,
    [Pending_Status] NVARCHAR(MAX) NULL,
    [Broker_Name] NVARCHAR(MAX) NULL,
    [Premium_In_Lacs] NVARCHAR(MAX) NULL,
    [Anp_Premium] NVARCHAR(MAX) NULL,
    [Critical_Illness_Ride] NVARCHAR(MAX) NULL,
    [Critical_Illness_Add_On_Cover] NVARCHAR(MAX) NULL,
    [Critical_Illness_Add_On_Cover_Pro_Health_Cash] NVARCHAR(MAX) NULL,
    [Prohealth_Cash_Day_Care_Treatment] NVARCHAR(MAX) NULL,
    [Critical_Illness_Add_On_Cover_Pro_Health] NVARCHAR(MAX) NULL,
    [Nach_Status] NVARCHAR(MAX) NULL,
    [Nach_Registration] NVARCHAR(MAX) NULL,
    [Online_Offline_Policy_Flag] NVARCHAR(MAX) NULL,
    [Sub_Intermediary_Pan_Number] NVARCHAR(MAX) NULL,
    [Sub_Intermediary_Pan_Name] NVARCHAR(MAX) NULL,
    [CBB_Attached_Y_N_] NVARCHAR(MAX) NULL,
    [HMB_Value] NVARCHAR(MAX) NULL,
    [Portability_Y_N_] NVARCHAR(MAX) NULL,
    [Month_Of_Proposal_Login] NVARCHAR(MAX) NULL,
    [Sol_Id] NVARCHAR(MAX) NULL,
    [Broker_Branch] NVARCHAR(MAX) NULL,
    [State_Name] NVARCHAR(MAX) NULL,
    [Ba_Number] NVARCHAR(MAX) NULL,
    [Cancel_Reject_Reason] NVARCHAR(MAX) NULL,
    [New_Bucket] NVARCHAR(MAX) NULL,
    [Business_Source_Code] NVARCHAR(MAX) NULL,
    [Recurring_Payment_Method] NVARCHAR(MAX) NULL,
    [Actual_Premium] NVARCHAR(MAX) NULL,
    [GST] NVARCHAR(MAX) NULL,
    [Life_Time_Global_SI] NVARCHAR(MAX) NULL,
    [pan_no] NVARCHAR(MAX) NULL,
    [primaryemailid] NVARCHAR(MAX) NULL,
    [mobilenumber] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Ergo_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Ergo_InsuranceDetails]
(
    [Policy_No] NVARCHAR(MAX) NULL,
    [Endorsement_No] NVARCHAR(MAX) NULL,
    [Previous_Policy_No] NVARCHAR(MAX) NULL,
    [Finance_LOB] NVARCHAR(MAX) NULL,
    [Product_Name] NVARCHAR(MAX) NULL,
    [Booked_Date] NVARCHAR(MAX) NULL,
    [Endorsement_Date] NVARCHAR(MAX) NULL,
    [POL_POLICY_TYPE] NVARCHAR(MAX) NULL,
    [MULTI_TAG] NVARCHAR(MAX) NULL,
    [Start_Date] NVARCHAR(MAX) NULL,
    [End_Date] NVARCHAR(MAX) NULL,
    [Reporting_Date] NVARCHAR(MAX) NULL,
    [Pol_Issue_Date] NVARCHAR(MAX) NULL,
    [Agent_Code] NVARCHAR(MAX) NULL,
    [Agent_Name] NVARCHAR(MAX) NULL,
    [Branch_Name] NVARCHAR(MAX) NULL,
    [State_Name] NVARCHAR(MAX) NULL,
    [Zone] NVARCHAR(MAX) NULL,
    [Endorsement_Type] NVARCHAR(MAX) NULL,
    [Business_Type] NVARCHAR(MAX) NULL,
    [Our_Share_GWP] NVARCHAR(MAX) NULL,
    [Total_GWP] NVARCHAR(MAX) NULL,
    [Share__] NVARCHAR(MAX) NULL,
    [Sum_Insured] NVARCHAR(MAX) NULL,
    [OD] NVARCHAR(MAX) NULL,
    [TP] NVARCHAR(MAX) NULL,
    [SSE_Name] NVARCHAR(MAX) NULL,
    [Vertical] NVARCHAR(MAX) NULL,
    [Sub_Vertical] NVARCHAR(MAX) NULL,
    [Zero_Dep_Flag] NVARCHAR(MAX) NULL,
    [Emergency_Flag] NVARCHAR(MAX) NULL,
    [LG_Code] NVARCHAR(MAX) NULL,
    [Customer_Name] NVARCHAR(MAX) NULL,
    [User_ID] NVARCHAR(MAX) NULL,
    [NCB] NVARCHAR(MAX) NULL,
    [POL_ENDORSEMENT_REASON] NVARCHAR(MAX) NULL,
    [POL_POSP_CODE] NVARCHAR(MAX) NULL,
    [POL_POSP_NAME] NVARCHAR(MAX) NULL,
    [POL_VC_PAN_CARD] NVARCHAR(MAX) NULL,
    [POL_MOT_MANUFACTURER_YEAR] NVARCHAR(MAX) NULL,
    [POL_MOT_MODEL_NAME] NVARCHAR(MAX) NULL,
    [POL_MOT_VEH_REGISTRATION_NUM] NVARCHAR(MAX) NULL,
    [POL_MOT_MANUFACTURER_NAME] NVARCHAR(MAX) NULL,
    [Mot_Registration_Date] NVARCHAR(MAX) NULL,
    [CHASSIS_NUM] NVARCHAR(MAX) NULL,
    [ENGINE_NUM] NVARCHAR(MAX) NULL,
    [CUST_EMAIL] NVARCHAR(MAX) NULL,
    [POL_FUEL_TYPE] NVARCHAR(MAX) NULL,
    [POL_GROSS_VEH_WT] NVARCHAR(MAX) NULL,
    [CUST_MOBILE_NUMBER] NVARCHAR(MAX) NULL,
    [POL_DISCOUNT_FLAG] NVARCHAR(MAX) NULL,
    [RTO_Location] NVARCHAR(MAX) NULL,
    [POL_EMI_OPTED] NVARCHAR(MAX) NULL,
    [POL_PAYMENT_INSTRUMENT_NO] NVARCHAR(MAX) NULL,
    [KYC_ID_] NVARCHAR(MAX) NULL,
    [User_Id_] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Go_Digit_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Go_Digit_InsuranceDetails]
(
    [Imd_Code] NVARCHAR(MAX) NULL,
    [Imd_Name] NVARCHAR(MAX) NULL,
    [Policy_Number] NVARCHAR(MAX) NULL,
    [Imd_Channel] NVARCHAR(MAX) NULL,
    [Imd_Channel_Irda] NVARCHAR(MAX) NULL,
    [Mph_Name] NVARCHAR(MAX) NULL,
    [Version_No] NVARCHAR(MAX) NULL,
    [Endorsement_Ind] NVARCHAR(MAX) NULL,
    [Endorse_Reasons] NVARCHAR(MAX) NULL,
    [cancel_reason] NVARCHAR(MAX) NULL,
    [Trans_Date] NVARCHAR(MAX) NULL,
    [endorse_effective_date] NVARCHAR(MAX) NULL,
    [Policy_Status] NVARCHAR(MAX) NULL,
    [Status] NVARCHAR(MAX) NULL,
    [Risk_Inc_Date] NVARCHAR(MAX) NULL,
    [Risk_Exp_Date] NVARCHAR(MAX) NULL,
    [Office_Code] NVARCHAR(MAX) NULL,
    [Office_Name] NVARCHAR(MAX) NULL,
    [Office_Gst_Number] NVARCHAR(MAX) NULL,
    [Zone] NVARCHAR(MAX) NULL,
    [User_Id] NVARCHAR(MAX) NULL,
    [User_Name] NVARCHAR(MAX) NULL,
    [Issue_Source] NVARCHAR(MAX) NULL,
    [Product_Code] NVARCHAR(MAX) NULL,
    [Product_Name] NVARCHAR(MAX) NULL,
    [Product_Lob] NVARCHAR(MAX) NULL,
    [Insured_Person] NVARCHAR(MAX) NULL,
    [Policy_Holder] NVARCHAR(MAX) NULL,
    [Ph_Pincode] NVARCHAR(MAX) NULL,
    [Ph_State_Code] NVARCHAR(MAX) NULL,
    [ip_state_code] NVARCHAR(MAX) NULL,
    [ip_pincode] NVARCHAR(MAX) NULL,
    [Ph_Gst_Number] NVARCHAR(MAX) NULL,
    [Vehicle_Make] NVARCHAR(MAX) NULL,
    [Vehicle_Model] NVARCHAR(MAX) NULL,
    [Vehicle_Subtype] NVARCHAR(MAX) NULL,
    [Engine_No] NVARCHAR(MAX) NULL,
    [Chassis_No] NVARCHAR(MAX) NULL,
    [Veh_Reg_No] NVARCHAR(MAX) NULL,
    [Trv_Mode] NVARCHAR(MAX) NULL,
    [Trv_Origin_City] NVARCHAR(MAX) NULL,
    [Trv_Destination_City] NVARCHAR(MAX) NULL,
    [Veh_Reg_Date] NVARCHAR(MAX) NULL,
    [vehicle_manf_year] NVARCHAR(MAX) NULL,
    [Veh_Age] NVARCHAR(MAX) NULL,
    [Veh_Gvw] NVARCHAR(MAX) NULL,
    [Veh_Seating] NVARCHAR(MAX) NULL,
    [Veh_Wheels] NVARCHAR(MAX) NULL,
    [Veh_Type] NVARCHAR(MAX) NULL,
    [Vehicle_Code] NVARCHAR(MAX) NULL,
    [Veh_Permit] NVARCHAR(MAX) NULL,
    [Prev_Insurer] NVARCHAR(MAX) NULL,
    [Prev_Policy_No] NVARCHAR(MAX) NULL,
    [Prev_Policy_Expiry] NVARCHAR(MAX) NULL,
    [Curr_Ncb] NVARCHAR(MAX) NULL,
    [Prev_Ncb] NVARCHAR(MAX) NULL,
    [Comm_Disc_Amt] NVARCHAR(MAX) NULL,
    [Comm_Disc_Rate] NVARCHAR(MAX) NULL,
    [Discount] NVARCHAR(MAX) NULL,
    [Pp_Cd_Rate] NVARCHAR(MAX) NULL,
    [Fuel_Type] NVARCHAR(MAX) NULL,
    [Invoice_No] NVARCHAR(MAX) NULL,
    [Receipt_No] NVARCHAR(MAX) NULL,
    [Policy_Type] NVARCHAR(MAX) NULL,
    [Booking_ID___Plan_ID] NVARCHAR(MAX) NULL,
    [Loan_Acc_Number] NVARCHAR(MAX) NULL,
    [Policy_Number_1] NVARCHAR(MAX) NULL,
    [Float_Type] NVARCHAR(MAX) NULL,
    [Technical_Premium] NVARCHAR(MAX) NULL,
    [Sum_Insured] NVARCHAR(MAX) NULL,
    [Gross_Premium] NVARCHAR(MAX) NULL,
    [Igst] NVARCHAR(MAX) NULL,
    [Cgst] NVARCHAR(MAX) NULL,
    [Sgst] NVARCHAR(MAX) NULL,
    [Utgst] NVARCHAR(MAX) NULL,
    [Cess] NVARCHAR(MAX) NULL,
    [Net_Premium] NVARCHAR(MAX) NULL,
    [Od_Premium] NVARCHAR(MAX) NULL,
    [Tp_Premium] NVARCHAR(MAX) NULL,
    [Od_Add_On_Premium] NVARCHAR(MAX) NULL,
    [Net_Premium_Collected] NVARCHAR(MAX) NULL,
    [erf_amt] NVARCHAR(MAX) NULL,
    [terrorism_premium_collected] NVARCHAR(MAX) NULL,
    [Product_Package] NVARCHAR(MAX) NULL,
    [Fleet_Number] NVARCHAR(MAX) NULL,
    [Policy_Issue_Date] NVARCHAR(MAX) NULL,
    [Customer_Account_Id] NVARCHAR(MAX) NULL,
    [Veh_Cc] NVARCHAR(MAX) NULL,
    [Veh_Use] NVARCHAR(MAX) NULL,
    [Veh_Segment] NVARCHAR(MAX) NULL,
    [Hypo_Party] NVARCHAR(MAX) NULL,
    [Webuser] NVARCHAR(MAX) NULL,
    [Status_64_Vb] NVARCHAR(MAX) NULL,
    [Policy_Count] NVARCHAR(MAX) NULL,
    [Master_Policy_No] NVARCHAR(MAX) NULL,
    [master_child_flag] NVARCHAR(MAX) NULL,
    [Term_Plan] NVARCHAR(MAX) NULL,
    [qs_cession_flag] NVARCHAR(MAX) NULL,
    [Coinsurance_Flag] NVARCHAR(MAX) NULL,
    [retained_share] NVARCHAR(MAX) NULL,
    [package_code] NVARCHAR(MAX) NULL,
    [product_hsn_code] NVARCHAR(MAX) NULL,
    [credit_office_code] NVARCHAR(MAX) NULL,
    [oem_disc1] NVARCHAR(MAX) NULL,
    [group_type] NVARCHAR(MAX) NULL,
    [tp_risk_exp_date] NVARCHAR(MAX) NULL,
    [partner_branch_code] NVARCHAR(MAX) NULL,
    [partner_branch_name] NVARCHAR(MAX) NULL,
    [partner_division_name] NVARCHAR(MAX) NULL,
    [QS_HEV_OD_PREMIUM] NVARCHAR(MAX) NULL,
    [QS_HEV_ODAD_PREMIUM] NVARCHAR(MAX) NULL,
    [QS__COVID_PREMIUM] NVARCHAR(MAX) NULL,
    [installment_frequency] NVARCHAR(MAX) NULL,
    [credit_imd_code1] NVARCHAR(MAX) NULL,
    [credit_imd_share1] NVARCHAR(MAX) NULL,
    [credit_imd_code2] NVARCHAR(MAX) NULL,
    [credit_imd_share2] NVARCHAR(MAX) NULL,
    [credit_imd_code3] NVARCHAR(MAX) NULL,
    [credit_imd_share3] NVARCHAR(MAX) NULL,
    [kyc_status] NVARCHAR(MAX) NULL,
    [ownership_sl_no] NVARCHAR(MAX) NULL,
    [Scheme] NVARCHAR(MAX) NULL,
    [Veh_Body_Type] NVARCHAR(MAX) NULL,
    [Gdd_Opted_Flag] NVARCHAR(MAX) NULL,
    [partner_customer_id] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_HDFC_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_HDFC_InsuranceDetails]
(
    [Payeecode] NVARCHAR(MAX) NULL,
    [PAYEE_NAME] NVARCHAR(MAX) NULL,
    [APPLICATION_NO] NVARCHAR(MAX) NULL,
    [Contract_Number] NVARCHAR(MAX) NULL,
    [Original_Issue_Date] NVARCHAR(MAX) NULL,
    [Proposal_Date] NVARCHAR(MAX) NULL,
    [Proposal_Received_Date] NVARCHAR(MAX) NULL,
    [Commencement_Date] NVARCHAR(MAX) NULL,
    [Original_Commencement_Date] NVARCHAR(MAX) NULL,
    [Premium_Due_Date] NVARCHAR(MAX) NULL,
    [Recpt_Flg] NVARCHAR(MAX) NULL,
    [FIRST_RECEIPT_DT] NVARCHAR(MAX) NULL,
    [FIN_YEAR_NO_LOGIN] NVARCHAR(MAX) NULL,
    [FIN_YEAR_NO_CONV] NVARCHAR(MAX) NULL,
    [PIPS] NVARCHAR(MAX) NULL,
    [Product_code] NVARCHAR(MAX) NULL,
    [Product_name] NVARCHAR(MAX) NULL,
    [Product_Type] NVARCHAR(MAX) NULL,
    [Plan_No] NVARCHAR(MAX) NULL,
    [Product_Sub_Type] NVARCHAR(MAX) NULL,
    [Policy_Status] NVARCHAR(MAX) NULL,
    [Policy_Status_Desc] NVARCHAR(MAX) NULL,
    [Contract_Branch_Code] NVARCHAR(MAX) NULL,
    [Contract_Branch_name] NVARCHAR(MAX) NULL,
    [Bank_assurance_number] NVARCHAR(MAX) NULL,
    [Billing_Frequency] NVARCHAR(MAX) NULL,
    [Billing_Channel] NVARCHAR(MAX) NULL,
    [SUM_ASSURED] NVARCHAR(MAX) NULL,
    [PREMIUM_without_Tax] NVARCHAR(MAX) NULL,
    [PREMIUM_AMT_WITH_TAX] NVARCHAR(MAX) NULL,
    [PREMIUM_PAYING_TERM] NVARCHAR(MAX) NULL,
    [POLICY_TERM] NVARCHAR(MAX) NULL,
    [API] NVARCHAR(MAX) NULL,
    [EPI] NVARCHAR(MAX) NULL,
    [Agent_Number] NVARCHAR(MAX) NULL,
    [AGNTNUM_1_TO_MANY] NVARCHAR(MAX) NULL,
    [Agent_Name] NVARCHAR(MAX) NULL,
    [CHANNEL] NVARCHAR(MAX) NULL,
    [SUB_CHANNEL] NVARCHAR(MAX) NULL,
    [LOB] NVARCHAR(MAX) NULL,
    [Contract_Owner_ID] NVARCHAR(MAX) NULL,
    [Contract_Owner_Name] NVARCHAR(MAX) NULL,
    [Contract_Owner_DOB] NVARCHAR(MAX) NULL,
    [Client_Gender] NVARCHAR(MAX) NULL,
    [LA_1_CLIENT_ID] NVARCHAR(MAX) NULL,
    [Life_Assured_1_Name] NVARCHAR(MAX) NULL,
    [LA_2_CLIENT_ID] NVARCHAR(MAX) NULL,
    [Life_Assured_2_Name] NVARCHAR(MAX) NULL,
    [NATIONALITY] NVARCHAR(MAX) NULL,
    [Salutation] NVARCHAR(MAX) NULL,
    [Occupation_code] NVARCHAR(MAX) NULL,
    [Occupation] NVARCHAR(MAX) NULL,
    [Nominee_ID_1] NVARCHAR(MAX) NULL,
    [Nominee_Relation_1] NVARCHAR(MAX) NULL,
    [Nominee_Relation_Des_1] NVARCHAR(MAX) NULL,
    [Nominee_Name_1] NVARCHAR(MAX) NULL,
    [Nominee_Gender_1] NVARCHAR(MAX) NULL,
    [Nominee_DOB_1] NVARCHAR(MAX) NULL,
    [Nominee_ID_2] NVARCHAR(MAX) NULL,
    [Nominee_Relation_2] NVARCHAR(MAX) NULL,
    [Nominee_Relation_Des_2] NVARCHAR(MAX) NULL,
    [Nominee_Name_2] NVARCHAR(MAX) NULL,
    [Nominee_Gender_2] NVARCHAR(MAX) NULL,
    [Nominee_DOB_2] NVARCHAR(MAX) NULL,
    [Nominee_ID_3] NVARCHAR(MAX) NULL,
    [Nominee_Relation_3] NVARCHAR(MAX) NULL,
    [Nominee_Relation_Des_3] NVARCHAR(MAX) NULL,
    [Nominee_Name_3] NVARCHAR(MAX) NULL,
    [Nominee_Gender_3] NVARCHAR(MAX) NULL,
    [Nominee_DOB_3] NVARCHAR(MAX) NULL,
    [Client_Address_Line_1] NVARCHAR(MAX) NULL,
    [Client_Address_Line_2] NVARCHAR(MAX) NULL,
    [Client_Address_Line_3] NVARCHAR(MAX) NULL,
    [Client_Address_Line_4] NVARCHAR(MAX) NULL,
    [Client_Address_Line_5] NVARCHAR(MAX) NULL,
    [Client_Pin_Code] NVARCHAR(MAX) NULL,
    [Phone_no] NVARCHAR(MAX) NULL,
    [Mobile_No] NVARCHAR(MAX) NULL,
    [Phone1] NVARCHAR(MAX) NULL,
    [Phone2] NVARCHAR(MAX) NULL,
    [E_mailid] NVARCHAR(MAX) NULL,
    [ZPANNO] NVARCHAR(MAX) NULL,
    [ZFOSFLD] NVARCHAR(MAX) NULL,
    [ZTELFLD] NVARCHAR(MAX) NULL,
    [ZCHNFLD] NVARCHAR(MAX) NULL,
    [ZBRNFLD] NVARCHAR(MAX) NULL,
    [IACODE] NVARCHAR(MAX) NULL,
    [LGCODE] NVARCHAR(MAX) NULL,
    [RELATIONSHIP_CODE] NVARCHAR(MAX) NULL,
    [RELATIONSHIP_NAME] NVARCHAR(MAX) NULL,
    [AGENT_TYPE] NVARCHAR(MAX) NULL,
    [PARTNER_CUSTOMER_ID] NVARCHAR(MAX) NULL,
    [ZBANCNUM] NVARCHAR(MAX) NULL,
    [NRI_FLAG] NVARCHAR(MAX) NULL,
    [Payer_Name] NVARCHAR(MAX) NULL,
    [Payer_Sex] NVARCHAR(MAX) NULL,
    [Payer_DOB] NVARCHAR(MAX) NULL,
    [Payer_Client_Address_Line_1] NVARCHAR(MAX) NULL,
    [Payer_Client_Address_Line_2] NVARCHAR(MAX) NULL,
    [Payer_Client_Address_Line_3] NVARCHAR(MAX) NULL,
    [Payer_Client_Address_Line_4] NVARCHAR(MAX) NULL,
    [Payer_Client_Address_Line_5] NVARCHAR(MAX) NULL,
    [Payer_Client_Pin_Code] NVARCHAR(MAX) NULL,
    [Payer_Phone_no] NVARCHAR(MAX) NULL,
    [Payer_Mobile_No] NVARCHAR(MAX) NULL,
    [Payer_Phone1] NVARCHAR(MAX) NULL,
    [Payer_Phone2] NVARCHAR(MAX) NULL,
    [Payer_E_mailid] NVARCHAR(MAX) NULL,
    [Payer_PAN_NO] NVARCHAR(MAX) NULL,
    [Annual_Income] NVARCHAR(MAX) NULL,
    [RISK_CESSATION_DATE] NVARCHAR(MAX) NULL,
    [LEAD_ACCOUNT_NUM] NVARCHAR(MAX) NULL,
    [SRC] NVARCHAR(MAX) NULL,
    [LA_1_DOB] NVARCHAR(MAX) NULL,
    [LA_2_DOB] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_ICICI_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_ICICI_InsuranceDetails]
(
    [Policy_Number] NVARCHAR(MAX) NULL,
    [Application_No] NVARCHAR(MAX) NULL,
    [Policy_Status] NVARCHAR(MAX) NULL,
    [ICICI_Branch_Code] NVARCHAR(MAX) NULL,
    [Billing_Frequency] NVARCHAR(MAX) NULL,
    [Policy_Term] NVARCHAR(MAX) NULL,
    [PREM_PAY_TERM] NVARCHAR(MAX) NULL,
    [ProposalAcceptDate] NVARCHAR(MAX) NULL,
    [FirstIssuanceDate] NVARCHAR(MAX) NULL,
    [RiskCommencementDate] NVARCHAR(MAX) NULL,
    [Product_Code] NVARCHAR(MAX) NULL,
    [Product_Name] NVARCHAR(MAX) NULL,
    [ChequeNo] NVARCHAR(MAX) NULL,
    [Cheque_Date] NVARCHAR(MAX) NULL,
    [BankName] NVARCHAR(MAX) NULL,
    [Billing_Channel] NVARCHAR(MAX) NULL,
    [PayMode] NVARCHAR(MAX) NULL,
    [BasicPlanPremium] NVARCHAR(MAX) NULL,
    [SumInsured] NVARCHAR(MAX) NULL,
    [RiderName01] NVARCHAR(MAX) NULL,
    [BasicPlanPremium__RC1_] NVARCHAR(MAX) NULL,
    [SumInsured__RC1_] NVARCHAR(MAX) NULL,
    [RiderName02] NVARCHAR(MAX) NULL,
    [BasicPlanPremium__RC2_] NVARCHAR(MAX) NULL,
    [SumInsured__RC2_] NVARCHAR(MAX) NULL,
    [RiderName03] NVARCHAR(MAX) NULL,
    [BasicPlanPremium__RC3_] NVARCHAR(MAX) NULL,
    [SumInsured__RC3_] NVARCHAR(MAX) NULL,
    [PLVC_CODE] NVARCHAR(MAX) NULL,
    [PLVC_RECEIVE_DATE] NVARCHAR(MAX) NULL,
    [POD_Number] NVARCHAR(MAX) NULL,
    [PolicyDispatchDate] NVARCHAR(MAX) NULL,
    [CustReceived_Date] NVARCHAR(MAX) NULL,
    [Dispatch_Description] NVARCHAR(MAX) NULL,
    [Cafos_Code] NVARCHAR(MAX) NULL,
    [CSR_Code] NVARCHAR(MAX) NULL,
    [SP_Code] NVARCHAR(MAX) NULL,
    [Customer_Name] NVARCHAR(MAX) NULL,
    [MaritialStatus] NVARCHAR(MAX) NULL,
    [Customer_Address_1] NVARCHAR(MAX) NULL,
    [Customer_Address_2] NVARCHAR(MAX) NULL,
    [ReidentialCity] NVARCHAR(MAX) NULL,
    [ResidentialRegion] NVARCHAR(MAX) NULL,
    [ResidentialState] NVARCHAR(MAX) NULL,
    [CustomerDOB] NVARCHAR(MAX) NULL,
    [Email] NVARCHAR(MAX) NULL,
    [Mobile_Number] NVARCHAR(MAX) NULL,
    [Gender] NVARCHAR(MAX) NULL,
    [PAN_Number] NVARCHAR(MAX) NULL,
    [PinCode] NVARCHAR(MAX) NULL,
    [LA_NAME] NVARCHAR(MAX) NULL,
    [LA_City] NVARCHAR(MAX) NULL,
    [LA_Gender] NVARCHAR(MAX) NULL,
    [LA_DOB] NVARCHAR(MAX) NULL,
    [LA_Address] NVARCHAR(MAX) NULL,
    [LA_EMAIL] NVARCHAR(MAX) NULL,
    [LA_Mobile] NVARCHAR(MAX) NULL,
    [LA_PIN_CODE] NVARCHAR(MAX) NULL,
    [LA_State] NVARCHAR(MAX) NULL,
    [Appointee_Name] NVARCHAR(MAX) NULL,
    [Nominee_1_DOB] NVARCHAR(MAX) NULL,
    [Nominee_1_Name] NVARCHAR(MAX) NULL,
    [Nominee_1_Relation] NVARCHAR(MAX) NULL,
    [Nominee_1__Share] NVARCHAR(MAX) NULL,
    [Nominee_2_DOB_] NVARCHAR(MAX) NULL,
    [Nominee_2_Name_] NVARCHAR(MAX) NULL,
    [Nominee_2_Relation_] NVARCHAR(MAX) NULL,
    [Nominee_2__Share_] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_ICICI_Lomboard_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_ICICI_Lomboard_InsuranceDetails]
(
    [Column0] NVARCHAR(MAX) NULL,
    [source_id] NVARCHAR(MAX) NULL,
    [PRODUCT_NAME] NVARCHAR(MAX) NULL,
    [PRODUCT_CODE] NVARCHAR(MAX) NULL,
    [product_class] NVARCHAR(MAX) NULL,
    [product_sub_class] NVARCHAR(MAX) NULL,
    [POL_DEAL_NUM] NVARCHAR(MAX) NULL,
    [POL_NUM] NVARCHAR(MAX) NULL,
    [POL_NUM_TXT] NVARCHAR(MAX) NULL,
    [OFFLINE_POL_NUM_TXT] NVARCHAR(MAX) NULL,
    [POL_COVERNOTE_TYPE] NVARCHAR(MAX) NULL,
    [TL_ID] NVARCHAR(MAX) NULL,
    [TL_NAME] NVARCHAR(MAX) NULL,
    [PBO_ID] NVARCHAR(MAX) NULL,
    [POL_ENDORSEMENT_NUM] NVARCHAR(MAX) NULL,
    [POL_ENDORSEMENT_TYPE] NVARCHAR(MAX) NULL,
    [POL_PRI_VVERTICAL_DESC] NVARCHAR(MAX) NULL,
    [POL_SEC_VVERTICAL_DESC] NVARCHAR(MAX) NULL,
    [POL_PRI_SSUB_VERTICAL_DESC] NVARCHAR(MAX) NULL,
    [POL_SEC_SSUB_VERTICAL_DESC] NVARCHAR(MAX) NULL,
    [BRANCH_NAME] NVARCHAR(MAX) NULL,
    [POL_START_DATE] NVARCHAR(MAX) NULL,
    [POL_ISSUE_DATE] NVARCHAR(MAX) NULL,
    [POL_ENDORSEMENT_DATE] NVARCHAR(MAX) NULL,
    [POL_END_DATE] NVARCHAR(MAX) NULL,
    [POL_REPORTING_DATE] NVARCHAR(MAX) NULL,
    [POL_CONVERSION_DATE] NVARCHAR(MAX) NULL,
    [POL_UNDERWRITING_YEAR] NVARCHAR(MAX) NULL,
    [POL_TOT_SUM_INSURED_AMT] NVARCHAR(MAX) NULL,
    [MOTOR_OD_PREMIUM_AMT] NVARCHAR(MAX) NULL,
    [MOTOR_TP_PREMIUM_AMT] NVARCHAR(MAX) NULL,
    [OUR_SHARE_SUMINSURED] NVARCHAR(MAX) NULL,
    [BASIC_PREMIUM_AMT] NVARCHAR(MAX) NULL,
    [TOT_PREMIUM_AMT] NVARCHAR(MAX) NULL,
    [POL_REFUND_TYPE] NVARCHAR(MAX) NULL,
    [POL_COVERNOTE_NUM] NVARCHAR(MAX) NULL,
    [TRAVEL_TRIP_CODE] NVARCHAR(MAX) NULL,
    [NETGWP] NVARCHAR(MAX) NULL,
    [POL_COVERNOTE_STATUS] NVARCHAR(MAX) NULL,
    [CUST_FULL_NAME] NVARCHAR(MAX) NULL,
    [POL_PAYMENT_STATUS] NVARCHAR(MAX) NULL,
    [POL_RM_CODE] NVARCHAR(MAX) NULL,
    [POL_RM_NAME] NVARCHAR(MAX) NULL,
    [POL_SEC_RM_CODE] NVARCHAR(MAX) NULL,
    [POL_SEC_RM_NAME] NVARCHAR(MAX) NULL,
    [TOT_LIABILITY_PREMIUM_AMT] NVARCHAR(MAX) NULL,
    [POL_SPECIAL_DISCOUNT_AMT] NVARCHAR(MAX) NULL,
    [MOTOR_REGISTRATION_NUM] NVARCHAR(MAX) NULL,
    [MOTOR_MANUFACTURER_NAME] NVARCHAR(MAX) NULL,
    [CUST_TYPE] NVARCHAR(MAX) NULL,
    [CUSTOMER_ID] NVARCHAR(MAX) NULL,
    [SOURCE_SYSTEM_OBJECTID] NVARCHAR(MAX) NULL,
    [AGENT_ID] NVARCHAR(MAX) NULL,
    [AMS_ID] NVARCHAR(MAX) NULL,
    [AGENT_FULL_NAME] NVARCHAR(MAX) NULL,
    [POL_ALT_CUST_ID] NVARCHAR(MAX) NULL,
    [POL_ALT_CUST_TYPE] NVARCHAR(MAX) NULL,
    [pol_financier_name] NVARCHAR(MAX) NULL,
    [pol_inward_num] NVARCHAR(MAX) NULL,
    [pol_prev_insurer_name] NVARCHAR(MAX) NULL,
    [pol_business_type] NVARCHAR(MAX) NULL,
    [motor_model_name] NVARCHAR(MAX) NULL,
    [pol_cancellation_type] NVARCHAR(MAX) NULL,
    [pol_region] NVARCHAR(MAX) NULL,
    [agent_group] NVARCHAR(MAX) NULL,
    [AGENT_CATEGORY_ID] NVARCHAR(MAX) NULL,
    [AGENT_CATEGORY_NAME] NVARCHAR(MAX) NULL,
    [AGENT_SUBCATEGORY_ID] NVARCHAR(MAX) NULL,
    [AGENT_SUBCATEGORY_NAME] NVARCHAR(MAX) NULL,
    [DEAL_BRANCH_STATE] NVARCHAR(MAX) NULL,
    [BRANCH_STATE] NVARCHAR(MAX) NULL,
    [SALES_OFFICER_EMP_NAME] NVARCHAR(MAX) NULL,
    [SALES_OFFICER_EMP_NUM] NVARCHAR(MAX) NULL,
    [CUST_PASSPORT_NUM] NVARCHAR(MAX) NULL,
    [POL_PASSPORT_NUM] NVARCHAR(MAX) NULL,
    [POL_PLAN_NAME] NVARCHAR(MAX) NULL,
    [LANNO] NVARCHAR(MAX) NULL,
    [ZERO_DEP_PREMIUM] NVARCHAR(MAX) NULL,
    [MOTOR_MANUFACTURER_YEAR] NVARCHAR(MAX) NULL,
    [POL_PREVIOUS_POLICY_NUM] NVARCHAR(MAX) NULL,
    [POL_OTC_FLAG] NVARCHAR(MAX) NULL,
    [VEHICLE_SUBCLASS] NVARCHAR(MAX) NULL,
    [POL_TENURE_DAYS] NVARCHAR(MAX) NULL,
    [POL_GVW] NVARCHAR(MAX) NULL,
    [POL_CARRYING_CAPACITY] NVARCHAR(MAX) NULL,
    [RTO_CLUSTER] NVARCHAR(MAX) NULL,
    [RTO_LOCATION] NVARCHAR(MAX) NULL,
    [POL_NCB_PERCENTAGE] NVARCHAR(MAX) NULL,
    [POL_SEASON] NVARCHAR(MAX) NULL,
    [POL_YEAR] NVARCHAR(MAX) NULL,
    [POL_CROP] NVARCHAR(MAX) NULL,
    [POL_DISTRICT] NVARCHAR(MAX) NULL,
    [POL_PAYEE_TYPE] NVARCHAR(MAX) NULL,
    [STATE_SHARE_PREMIUM] NVARCHAR(MAX) NULL,
    [CENTRAL_SHARE_PREMIUM] NVARCHAR(MAX) NULL,
    [COMBINED_SHARE_PREMIUM] NVARCHAR(MAX) NULL,
    [FARMER_SHARE_PREMIUM] NVARCHAR(MAX) NULL,
    [FARMER_SHARE_TOT_PREMIUM] NVARCHAR(MAX) NULL,
    [POL_BOOKING_STATE] NVARCHAR(MAX) NULL,
    [COMMISSION_VALUE] NVARCHAR(MAX) NULL,
    [HEALTH_TOT_LIVES_INSURED] NVARCHAR(MAX) NULL,
    [MOTOR_VEHICLE_USAGES] NVARCHAR(MAX) NULL,
    [CGST_AMOUNT] NVARCHAR(MAX) NULL,
    [CGST_RATE] NVARCHAR(MAX) NULL,
    [CREDIT_NOTE_FLAG] NVARCHAR(MAX) NULL,
    [CUSTOMER_GSTIN] NVARCHAR(MAX) NULL,
    [GST_CUST_STATECODE] NVARCHAR(MAX) NULL,
    [GST_CUST_STATENAME] NVARCHAR(MAX) NULL,
    [GST_EXEMPTION] NVARCHAR(MAX) NULL,
    [GST_IL_STATECODE] NVARCHAR(MAX) NULL,
    [GST_IL_STATENAME] NVARCHAR(MAX) NULL,
    [IGST_AMOUNT] NVARCHAR(MAX) NULL,
    [IGST_RATE] NVARCHAR(MAX) NULL,
    [IL_GSTIN] NVARCHAR(MAX) NULL,
    [INVOICE_GENERATION_APPLICABLE] NVARCHAR(MAX) NULL,
    [INVOICE_NO] NVARCHAR(MAX) NULL,
    [ORIGINAL_INVOICE_NUMBER] NVARCHAR(MAX) NULL,
    [SGST_AMOUNT] NVARCHAR(MAX) NULL,
    [SGST_RATE] NVARCHAR(MAX) NULL,
    [TXT_BASIS_OF_GST] NVARCHAR(MAX) NULL,
    [UGST_AMOUNT] NVARCHAR(MAX) NULL,
    [UGST_RATE] NVARCHAR(MAX) NULL,
    [SERVICE_TAX_RATE] NVARCHAR(MAX) NULL,
    [REGISTRATION_DT] NVARCHAR(MAX) NULL,
    [DWH_INSERT_DT] NVARCHAR(MAX) NULL,
    [OWNER_PA_PREMIUM] NVARCHAR(MAX) NULL,
    [MOTOR_ENGINE_NUM] NVARCHAR(MAX) NULL,
    [MOTOR_CHASSIS_NUM] NVARCHAR(MAX) NULL,
    [POL_ALTERNATE_RM_CODE] NVARCHAR(MAX) NULL,
    [POL_CHANNEL_NAME] NVARCHAR(MAX) NULL,
    [POL_PRIM_RM_CODE] NVARCHAR(MAX) NULL,
    [POL_CUSTOMER_REF_NO] NVARCHAR(MAX) NULL,
    [POL_SECONDARY_RM_CODE] NVARCHAR(MAX) NULL,
    [BANCA_FIELD_01] NVARCHAR(MAX) NULL,
    [BANCA_FIELD_02] NVARCHAR(MAX) NULL,
    [BANCA_FIELD_03] NVARCHAR(MAX) NULL,
    [AGENT_LICENSE_CODE] NVARCHAR(MAX) NULL,
    [AGENT_IT_PAN_NUM] NVARCHAR(MAX) NULL,
    [POL_ALTERNATE_RM_NAME] NVARCHAR(MAX) NULL,
    [VO_BRANCH_NAME] NVARCHAR(MAX) NULL,
    [INSURED_NAME] NVARCHAR(MAX) NULL,
    [VOLUNTRY_EX_PLAN] NVARCHAR(MAX) NULL,
    [VOLUNTRY_EX_PREMIUM] NVARCHAR(MAX) NULL,
    [NUM_RSA_PREMIUM] NVARCHAR(MAX) NULL,
    [PA_COVER_TENURE] NVARCHAR(MAX) NULL,
    [ALTERNATE_POLICY_NO] NVARCHAR(MAX) NULL,
    [MIGRATED_FLAG] NVARCHAR(MAX) NULL,
    [TRAN_NO] NVARCHAR(MAX) NULL,
    [MIG_POL_PRI_VVERTICAL_DESC] NVARCHAR(MAX) NULL,
    [MIG_POL_PRI_SSUB_VERTICAL_DESC] NVARCHAR(MAX) NULL,
    [MIG_BAGI_PRIMARY_CHANNEL] NVARCHAR(MAX) NULL,
    [MIG_BAGI_SECONDARY_CHANNEL] NVARCHAR(MAX) NULL,
    [MIG_SOURCE_SYSTEM] NVARCHAR(MAX) NULL,
    [CONTRACT_TYPE] NVARCHAR(MAX) NULL,
    [SUBMODE_FLAG] NVARCHAR(MAX) NULL,
    [CUST_RES_CITY] NVARCHAR(MAX) NULL,
    [CUST_RES_STATE] NVARCHAR(MAX) NULL,
    [REL_WITH_NOMINEE] NVARCHAR(MAX) NULL,
    [POL_FINANCER_NAME] NVARCHAR(MAX) NULL,
    [POL_FINANCER_BRANCH] NVARCHAR(MAX) NULL,
    [LT_YEAR_FLAG] NVARCHAR(MAX) NULL,
    [TOTAL_PREMIUM_RECEIVED] NVARCHAR(MAX) NULL,
    [TOTAL_OD_PREMIUM_RECEIVED] NVARCHAR(MAX) NULL,
    [TOTAL_TP_PREMIUM_RECEIVED] NVARCHAR(MAX) NULL,
    [ADVANCE_PREMIUM] NVARCHAR(MAX) NULL,
    [HLTH_PERSONAL_BANK_OFF] NVARCHAR(MAX) NULL,
    [VERTICAL_REPORTING_REV2] NVARCHAR(MAX) NULL,
    [Vertical_Category2] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Niva_Bupa_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Niva_Bupa_InsuranceDetails]
(
    [First_Name] NVARCHAR(MAX) NULL,
    [Last_Name] NVARCHAR(MAX) NULL,
    [Full_Name] NVARCHAR(MAX) NULL,
    [Application_Number] NVARCHAR(MAX) NULL,
    [Policy_Number] NVARCHAR(MAX) NULL,
    [Customer_ID] NVARCHAR(MAX) NULL,
    [DOB] NVARCHAR(MAX) NULL,
    [Plan_Type] NVARCHAR(MAX) NULL,
    [Product_ID] NVARCHAR(MAX) NULL,
    [Product_Genre] NVARCHAR(MAX) NULL,
    [Insured_Lives] NVARCHAR(MAX) NULL,
    [Insured_Count] NVARCHAR(MAX) NULL,
    [Logged_Premium] NVARCHAR(MAX) NULL,
    [Current_Status] NVARCHAR(MAX) NULL,
    [Issued_Premium] NVARCHAR(MAX) NULL,
    [Issued_Premium__Without_Taxes_] NVARCHAR(MAX) NULL,
    [Loading_Premium] NVARCHAR(MAX) NULL,
    [Sum_Assured] NVARCHAR(MAX) NULL,
    [Individual_Sum_Assured] NVARCHAR(MAX) NULL,
    [PA_SI] NVARCHAR(MAX) NULL,
    [Health_Assurance_Critical_Illness_Criticare_Sum_Assured] NVARCHAR(MAX) NULL,
    [Health_Assurance_Personal_Accident_Accident_Care_Sum_Assured] NVARCHAR(MAX) NULL,
    [Health_Assurance_Hospital_Cash_Hospicash_Sum_Assured] NVARCHAR(MAX) NULL,
    [Login_Branch] NVARCHAR(MAX) NULL,
    [Sales_Branch] NVARCHAR(MAX) NULL,
    [Zone] NVARCHAR(MAX) NULL,
    [Channel] NVARCHAR(MAX) NULL,
    [Sub_Channel] NVARCHAR(MAX) NULL,
    [Agent_Code] NVARCHAR(MAX) NULL,
    [Agent_Name] NVARCHAR(MAX) NULL,
    [Agent_Type] NVARCHAR(MAX) NULL,
    [Pa_Code] NVARCHAR(MAX) NULL,
    [Conversion_Date] NVARCHAR(MAX) NULL,
    [Agency_Manager_ID] NVARCHAR(MAX) NULL,
    [Agency_Manager_Name] NVARCHAR(MAX) NULL,
    [Logged_Date] NVARCHAR(MAX) NULL,
    [Logged_Month] NVARCHAR(MAX) NULL,
    [Issued_Date] NVARCHAR(MAX) NULL,
    [Issued_Month] NVARCHAR(MAX) NULL,
    [Maximus_Status] NVARCHAR(MAX) NULL,
    [Lead_Status] NVARCHAR(MAX) NULL,
    [Sales_Status] NVARCHAR(MAX) NULL,
    [Discrepancy_Status] NVARCHAR(MAX) NULL,
    [Current_Team] NVARCHAR(MAX) NULL,
    [Current_Status_Ageing] NVARCHAR(MAX) NULL,
    [Login_Ageing] NVARCHAR(MAX) NULL,
    [Designation] NVARCHAR(MAX) NULL,
    [Policy_Start_Date] NVARCHAR(MAX) NULL,
    [Policy_End_Date] NVARCHAR(MAX) NULL,
    [W_NB_APP_ID] NVARCHAR(MAX) NULL,
    [Is_Portability] NVARCHAR(MAX) NULL,
    [Is_Split] NVARCHAR(MAX) NULL,
    [Is_Upsell] NVARCHAR(MAX) NULL,
    [Uspell_Limit] NVARCHAR(MAX) NULL,
    [Plan_Name] NVARCHAR(MAX) NULL,
    [Renew_Now] NVARCHAR(MAX) NULL,
    [Whatsapp_Communication_for_Policy_Information] NVARCHAR(MAX) NULL,
    [Communication_Acknowledgement_Over_Ride_DND_] NVARCHAR(MAX) NULL,
    [Safe_Guard] NVARCHAR(MAX) NULL,
    [Annual_Aggregate_Deductible_Option] NVARCHAR(MAX) NULL,
    [Co_Payment] NVARCHAR(MAX) NULL,
    [Room_Type_Modification] NVARCHAR(MAX) NULL,
    [Preferred_Partner_Network] NVARCHAR(MAX) NULL,
    [PED_Modification] NVARCHAR(MAX) NULL,
    [Future_Ready] NVARCHAR(MAX) NULL,
    [Fast_Forward] NVARCHAR(MAX) NULL,
    [Borderless] NVARCHAR(MAX) NULL,
    [Well_Consult] NVARCHAR(MAX) NULL,
    [Cash_Bag] NVARCHAR(MAX) NULL,
    [Co_payment_for_Borderless] NVARCHAR(MAX) NULL,
    [Acute_Care] NVARCHAR(MAX) NULL,
    [Amount_in_Acute_Care_Best_Care_] NVARCHAR(MAX) NULL,
    [Disease_Management] NVARCHAR(MAX) NULL,
    [Customer_DOB] NVARCHAR(MAX) NULL,
    [Customer_City] NVARCHAR(MAX) NULL,
    [Customer_State] NVARCHAR(MAX) NULL,
    [TENURE] NVARCHAR(MAX) NULL,
    [Payment_term] NVARCHAR(MAX) NULL,
    [Temporal_Total_Disability] NVARCHAR(MAX) NULL,
    [TTD_Deductible_Options] NVARCHAR(MAX) NULL,
    [Specific_Disease_Wait_time_Modification] NVARCHAR(MAX) NULL,
    [Annual_Health_Check_up_] NVARCHAR(MAX) NULL,
    [Pre_Post_Enhancement] NVARCHAR(MAX) NULL,
    [Modern_Treatment_Enhancement] NVARCHAR(MAX) NULL,
    [Second_Medical_Opinion] NVARCHAR(MAX) NULL,
    [Unlock_Network_] NVARCHAR(MAX) NULL,
    [Borderless_with_SI] NVARCHAR(MAX) NULL,
    [Borderless_with_Copy] NVARCHAR(MAX) NULL,
    [Borderless_Specific_Illness_With_SI] NVARCHAR(MAX) NULL,
    [Borderless_Specific_Illness_With_Co_pay] NVARCHAR(MAX) NULL,
    [Cash_Bag_] NVARCHAR(MAX) NULL,
    [Annual_Health_Checkup] NVARCHAR(MAX) NULL,
    [ElderOne] NVARCHAR(MAX) NULL,
    [NivaBupaOne] NVARCHAR(MAX) NULL,
    [Specific_PED_modification] NVARCHAR(MAX) NULL,
    [HeadsUp] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Reliance_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Reliance_InsuranceDetails]
(
    [PolicyNo] NVARCHAR(MAX) NULL,
    [ProductName] NVARCHAR(MAX) NULL,
    [ProposalNo] NVARCHAR(MAX) NULL,
    [NameofPolicyHolder] NVARCHAR(MAX) NULL,
    [PassportNo] NVARCHAR(MAX) NULL,
    [Plan] NVARCHAR(MAX) NULL,
    [BranchName] NVARCHAR(MAX) NULL,
    [RegionName] NVARCHAR(MAX) NULL,
    [PolicyGenerationDate] NVARCHAR(MAX) NULL,
    [PolicyStartDate] NVARCHAR(MAX) NULL,
    [PolicyEndDate] NVARCHAR(MAX) NULL,
    [PreTaxAmount] NVARCHAR(MAX) NULL,
    [TaxAmount] NVARCHAR(MAX) NULL,
    [PostTaxAmount] NVARCHAR(MAX) NULL,
    [UserID] NVARCHAR(MAX) NULL,
    [IMDCode] NVARCHAR(MAX) NULL,
    [IMDName] NVARCHAR(MAX) NULL,
    [RMRCode] NVARCHAR(MAX) NULL,
    [RMRName] NVARCHAR(MAX) NULL,
    [SumInsured] NVARCHAR(MAX) NULL,
    [PayMode] NVARCHAR(MAX) NULL,
    [OTPStatus] NVARCHAR(MAX) NULL,
    [Status] NVARCHAR(MAX) NULL,
    [PaidStatus] NVARCHAR(MAX) NULL,
    [IntermediaryReferenceCode] NVARCHAR(MAX) NULL,
    [Remark] NVARCHAR(MAX) NULL,
    [CountryofEmployment] NVARCHAR(MAX) NULL,
    [SponsorName] NVARCHAR(MAX) NULL,
    [SMName] NVARCHAR(MAX) NULL,
    [SMCode] NVARCHAR(MAX) NULL,
    [MobileNo] NVARCHAR(MAX) NULL,
    [EmployeeNo] NVARCHAR(MAX) NULL,
    [DeptCode] NVARCHAR(MAX) NULL,
    [SubAssociateNumber] NVARCHAR(MAX) NULL,
    [BusinessType] NVARCHAR(MAX) NULL,
    [FuelType] NVARCHAR(MAX) NULL,
    [RegisterNo] NVARCHAR(MAX) NULL,
    [GVW] NVARCHAR(MAX) NULL,
    [DynamicFeild1] NVARCHAR(MAX) NULL,
    [DynamicFeild2] NVARCHAR(MAX) NULL,
    [DynamicFeild3] NVARCHAR(MAX) NULL,
    [DynamicFeild4] NVARCHAR(MAX) NULL,
    [DynamicFeild5] NVARCHAR(MAX) NULL,
    [ContractNumber] NVARCHAR(MAX) NULL,
    [IsCDT] NVARCHAR(MAX) NULL,
    [KYCStatus] NVARCHAR(MAX) NULL,
    [QCStatus] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Angel_CRMS_Tata_InsuranceDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Angel_CRMS_Tata_InsuranceDetails]
(
    [SUBMISSION_DATE] NVARCHAR(MAX) NULL,
    [SUBMISSION_MONTH] NVARCHAR(MAX) NULL,
    [ISSUANCE_DATE] NVARCHAR(MAX) NULL,
    [Issuance_MONTH] NVARCHAR(MAX) NULL,
    [POLNUM] NVARCHAR(MAX) NULL,
    [Broker_SP_Code] NVARCHAR(MAX) NULL,
    [Broker_Name] NVARCHAR(MAX) NULL,
    [CHANNEL] NVARCHAR(MAX) NULL,
    [CSO_STATUS] NVARCHAR(MAX) NULL,
    [CSO_REJECTION_REASON] NVARCHAR(MAX) NULL,
    [CUSTOMER_NAME] NVARCHAR(MAX) NULL,
    [SUM_ASSURED] NVARCHAR(MAX) NULL,
    [PRODUCT_TYPE] NVARCHAR(MAX) NULL,
    [PREMIUM_PAYING_TERM] NVARCHAR(MAX) NULL,
    [POLICY_TERM] NVARCHAR(MAX) NULL,
    [SERVICE_TAX] NVARCHAR(MAX) NULL,
    [SUBMITTED_NBP_excl_TAX] NVARCHAR(MAX) NULL,
    [SUBMITTED_WNBP_excl_TAX] NVARCHAR(MAX) NULL,
    [SUBMITTED_ANP_excl_TAX] NVARCHAR(MAX) NULL,
    [ISSUED_WNBP_excl_TAX] NVARCHAR(MAX) NULL,
    [ISSUED_WNBP_excl_TAX1] NVARCHAR(MAX) NULL,
    [ISSUED_ANP_excl_TAX] NVARCHAR(MAX) NULL,
    [PRODUCT_CODE] NVARCHAR(MAX) NULL,
    [PRODUCT_NAME] NVARCHAR(MAX) NULL,
    [MODE_OF_PREMIUM] NVARCHAR(MAX) NULL,
    [Branch_Scan_Date] NVARCHAR(MAX) NULL,
    [FirstUWDate] NVARCHAR(MAX) NULL,
    [PENDING_RAISED_DATE] NVARCHAR(MAX) NULL,
    [LAST_PENDING_DATED] NVARCHAR(MAX) NULL,
    [PENDING_RESOLVED_DATE] NVARCHAR(MAX) NULL,
    [UW_Decision_Date] NVARCHAR(MAX) NULL,
    [NTU_DATE] NVARCHAR(MAX) NULL,
    [FREELOOK_DATE] NVARCHAR(MAX) NULL,
    [POLICY_PSC_STATUS] NVARCHAR(MAX) NULL,
    [PIP_GENERATION_DATE] NVARCHAR(MAX) NULL,
    [PIP_PRINTED_DATE] NVARCHAR(MAX) NULL,
    [PIP_DISPATCH_DATE] NVARCHAR(MAX) NULL,
    [PIP_DELIVERY_DATE] NVARCHAR(MAX) NULL,
    [RTO_DATE] NVARCHAR(MAX) NULL,
    [RTO_REASON] NVARCHAR(MAX) NULL,
    [AWB_NUMBER] NVARCHAR(MAX) NULL,
    [MEDICAL_CODE] NVARCHAR(MAX) NULL,
    [Medical_SHOW_DATE] NVARCHAR(MAX) NULL,
    [MEDICAL_REMARKS] NVARCHAR(MAX) NULL,
    [Medical_APPOINTMENT_DATE] NVARCHAR(MAX) NULL,
    [SHOWNOSHOW_Status] NVARCHAR(MAX) NULL,
    [SubOffice_code] NVARCHAR(MAX) NULL,
    [Tata_AIA_LifeBranch] NVARCHAR(MAX) NULL,
    [Main_zone] NVARCHAR(MAX) NULL,
    [RM_EmpNo] NVARCHAR(MAX) NULL,
    [RM_Name] NVARCHAR(MAX) NULL,
    [SUP1_EMP_Code] NVARCHAR(MAX) NULL,
    [SUP1_EMP_NAME] NVARCHAR(MAX) NULL,
    [SUP2_EMP_Code] NVARCHAR(MAX) NULL,
    [SUP2_EMP_NAME] NVARCHAR(MAX) NULL,
    [SUP3_EMP_Code] NVARCHAR(MAX) NULL,
    [SUP3_EMP_NAME] NVARCHAR(MAX) NULL,
    [CLEARED] NVARCHAR(MAX) NULL,
    [Bounce] NVARCHAR(MAX) NULL,
    [AWAITING_CLEARANCE] NVARCHAR(MAX) NULL,
    [Cash] NVARCHAR(MAX) NULL,
    [PAYMENT_TYPE] NVARCHAR(MAX) NULL,
    [Representation_Case] NVARCHAR(MAX) NULL,
    [PREMIUM_SHORTAGE] NVARCHAR(MAX) NULL,
    [DST_status] NVARCHAR(MAX) NULL,
    [DST_Pending_Comments] NVARCHAR(MAX) NULL,
    [DST_Days] NVARCHAR(MAX) NULL,
    [DST_Ageing_Bucket] NVARCHAR(MAX) NULL,
    [Pending_Aging_bucket] NVARCHAR(MAX) NULL,
    [GENERIC_STATUS] NVARCHAR(MAX) NULL,
    [STATUS_DESCRIPTION] NVARCHAR(MAX) NULL,
    [NBFE_Status] NVARCHAR(MAX) NULL,
    [Olas_Status] NVARCHAR(MAX) NULL,
    [PENDING_REASON] NVARCHAR(MAX) NULL,
    [TELE_MER_FLAG] NVARCHAR(MAX) NULL,
    [TELE_FLAG_DESC] NVARCHAR(MAX) NULL,
    [TAT] NVARCHAR(MAX) NULL,
    [NBFE_DATE] NVARCHAR(MAX) NULL,
    [PREM_DUE_DT] NVARCHAR(MAX) NULL,
    [CIA_NO] NVARCHAR(MAX) NULL,
    [APP_ID] NVARCHAR(MAX) NULL,
    [CSO_Rejection_Date] NVARCHAR(MAX) NULL,
    [RM_Location] NVARCHAR(MAX) NULL,
    [RIDER_TAG] NVARCHAR(MAX) NULL,
    [ANP] NVARCHAR(MAX) NULL,
    [PSC_TYPE] NVARCHAR(MAX) NULL,
    [isFTR] NVARCHAR(MAX) NULL,
    [CURRENT_AUTOPAY] NVARCHAR(MAX) NULL,
    [FINAL_PROD_CATEGORY] NVARCHAR(MAX) NULL,
    [PROPOSER_NAME] NVARCHAR(MAX) NULL,
    [PROPOSER_ADDRESS] NVARCHAR(MAX) NULL,
    [PROPOSER_DOB] NVARCHAR(MAX) NULL,
    [PROPOSER_PAN] NVARCHAR(MAX) NULL,
    [INSURED_NAME] NVARCHAR(MAX) NULL,
    [INSURED_GENDER] NVARCHAR(MAX) NULL,
    [INSURED_ADDRESS] NVARCHAR(MAX) NULL,
    [INSURED_DOB] NVARCHAR(MAX) NULL,
    [INSURED_PAN] NVARCHAR(MAX) NULL,
    [CONTACT_NUMBER] NVARCHAR(MAX) NULL,
    [EMAIL] NVARCHAR(MAX) NULL,
    [NRI_FLAG] NVARCHAR(MAX) NULL,
    [INCOME_DECLARED] NVARCHAR(MAX) NULL,
    [POS_AGENT_PAN] NVARCHAR(MAX) NULL,
    [APPLICATION_NUMBER] NVARCHAR(MAX) NULL,
    [PREMIUM_EFFECTIVE_DATE] NVARCHAR(MAX) NULL,
    [PRODUCT_CATEGORY] NVARCHAR(MAX) NULL,
    [SOURCE_ID] NVARCHAR(MAX) NULL,
    [ENDORSEMENT_NO] NVARCHAR(MAX) NULL,
    [ENDORSEMENT_REASON] NVARCHAR(MAX) NULL,
    [RIDER_NAME_1] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_1] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_1] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_1] NVARCHAR(MAX) NULL,
    [RIDER_NAME_2] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_2] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_2] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_2] NVARCHAR(MAX) NULL,
    [RIDER_NAME_3] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_3] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_3] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_3] NVARCHAR(MAX) NULL,
    [RIDER_NAME_4] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_4] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_4] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_4] NVARCHAR(MAX) NULL,
    [RIDER_NAME_5] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_5] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_5] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_5] NVARCHAR(MAX) NULL,
    [RIDER_NAME_6] NVARCHAR(MAX) NULL,
    [RIDER_PREMIUM_6] NVARCHAR(MAX) NULL,
    [TAXES_ON_RIDER_PREMIUM_6] NVARCHAR(MAX) NULL,
    [RIDER_SUM_ASSURED_6] NVARCHAR(MAX) NULL,
    [Update_DateTime] NVARCHAR(MAX) NULL,
    [RIDER_CODE_1] NVARCHAR(MAX) NULL,
    [RIDER_CODE_2] NVARCHAR(MAX) NULL,
    [RIDER_CODE_3] NVARCHAR(MAX) NULL,
    [RIDER_CODE_4] NVARCHAR(MAX) NULL,
    [RIDER_CODE_5] NVARCHAR(MAX) NULL,
    [RIDER_CODE_6] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID02] NVARCHAR(MAX) NULL,
    [WNBP_RID02] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID03] NVARCHAR(MAX) NULL,
    [WNBP_RID03] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID04] NVARCHAR(MAX) NULL,
    [WNBP_RID04] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID05] NVARCHAR(MAX) NULL,
    [WNBP_RID05] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID06] NVARCHAR(MAX) NULL,
    [WNBP_RID06] NVARCHAR(MAX) NULL,
    [PROD_CODE_RID07] NVARCHAR(MAX) NULL,
    [WNBP_RID07] NVARCHAR(MAX) NULL,
    [BUSINESS_TYPE_ID] NVARCHAR(MAX) NULL,
    [Digital_booster_Flag] NVARCHAR(MAX) NULL,
    [Digital_Discount_flag] NVARCHAR(MAX) NULL,
    [AgtCode] NVARCHAR(MAX) NULL,
    [AgtName] NVARCHAR(MAX) NULL,
    [Company_Paid_Premium] NVARCHAR(MAX) NULL,
    [Partner_Code] NVARCHAR(MAX) NULL,
    [partner_Name] NVARCHAR(MAX) NULL,
    [Nominee_Name] NVARCHAR(MAX) NULL,
    [Nominee_DOB] NVARCHAR(MAX) NULL,
    [Nominee_Relation] NVARCHAR(MAX) NULL,
    [Code_1] NVARCHAR(MAX) NULL,
    [Code_2] NVARCHAR(MAX) NULL,
    [IRDA_LICENSED] NVARCHAR(MAX) NULL,
    [PAY_TYPE] NVARCHAR(MAX) NULL,
    [Rider_GST_1] NVARCHAR(MAX) NULL,
    [Rider_GST_2] NVARCHAR(MAX) NULL,
    [Rider_GST_3] NVARCHAR(MAX) NULL,
    [Rider_GST_4] NVARCHAR(MAX) NULL,
    [Rider_GST_5] NVARCHAR(MAX) NULL,
    [Rider_GST_6] NVARCHAR(MAX) NULL,
    [UploadedDate] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CRMS_InsuranceSelectedColumnsDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CRMS_InsuranceSelectedColumnsDetails]
(
    [ColumnId] BIGINT IDENTITY(1,1) NOT NULL,
    [ColumnName] VARCHAR(155) NULL,
    [TableName] VARCHAR(155) NULL,
    [CompanyName] VARCHAR(55) NULL,
    [IsSelected] BIT NULL,
    [SelectedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ECNCode
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ECNCode]
(
    [CODE ] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_EcnReference
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_EcnReference]
(
    [client_code] VARCHAR(20) NULL,
    [Bcc_Mail] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Nbfc_SynergyDataForDp_CrystalReport
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Nbfc_SynergyDataForDp_CrystalReport]
(
    [Party_code] VARCHAR(20) NULL,
    [CurrentCode] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(500) NULL,
    [OCCUPATION] VARCHAR(50) NULL,
    [STATUS] VARCHAR(100) NULL,
    [SUB_TYPE] VARCHAR(100) NULL,
    [DP_INT_REFNO] VARCHAR(100) NULL,
    [POA_ID] VARCHAR(100) NULL,
    [POA_NAME] VARCHAR(500) NULL,
    [CLOSURE_DATE] DATETIME NULL,
    [TITLE] VARCHAR(100) NULL,
    [FIRST_HOLD_NAME] VARCHAR(500) NULL,
    [SALUTATION] VARCHAR(100) NULL,
    [CONTACT_PERSON] VARCHAR(500) NULL,
    [FIRST_HOLD_ADD1] VARCHAR(500) NULL,
    [FIRST_HOLD_ADD2] VARCHAR(500) NULL,
    [FIRST_HOLD_ADD3] VARCHAR(500) NULL,
    [FIRST_HOLD_PIN] VARCHAR(100) NULL,
    [FIRST_HOLD_CNTRY] VARCHAR(100) NULL,
    [FIRST_HOLD_STATE] VARCHAR(100) NULL,
    [FIRST_HOLD_PHONE] VARCHAR(100) NULL,
    [FIRST_HOLD_FAX] VARCHAR(100) NULL,
    [EMAIL_ADD] VARCHAR(500) NULL,
    [FOREIGN_ADDR1] VARCHAR(500) NULL,
    [FOREIGN_ADDR2] VARCHAR(500) NULL,
    [FOREIGN_ADDR3] VARCHAR(500) NULL,
    [FOREIGN_CITY] VARCHAR(100) NULL,
    [FOREIGN_STATE] VARCHAR(100) NULL,
    [FOREIGN_CNTRY] VARCHAR(200) NULL,
    [FOREIGN_ZIP] VARCHAR(100) NULL,
    [FOREIGN_PHONE] VARCHAR(100) NULL,
    [FOREIGN_FAX] VARCHAR(100) NULL,
    [SECOND_HOLD_NAME] VARCHAR(500) NULL,
    [THIRD_HOLD_NAME] VARCHAR(500) NULL,
    [ITPAN] VARCHAR(20) NULL,
    [TAX_DEDUCT] VARCHAR(100) NULL,
    [BANK_MICR] VARCHAR(100) NULL,
    [MICR_CODE] VARCHAR(100) NULL,
    [BANK_ACCNO] VARCHAR(100) NULL,
    [BANK_NAME] VARCHAR(100) NULL,
    [BANK_ADD1] VARCHAR(100) NULL,
    [BANK_ADD2] VARCHAR(100) NULL,
    [BANK_ADD3] VARCHAR(100) NULL,
    [BANK_ADD4] VARCHAR(100) NULL,
    [BANK_STATE] VARCHAR(100) NULL,
    [BANK_CNTRY] VARCHAR(100) NULL,
    [BANK_ZIP] VARCHAR(100) NULL,
    [SEBI_REG_NO] VARCHAR(100) NULL,
    [RBI_REFNO] VARCHAR(100) NULL,
    [RBI_APP_DT] VARCHAR(100) NULL,
    [NOMI_GUARD_NAME] VARCHAR(500) NULL,
    [NOMI_GUARD_ADD1] VARCHAR(500) NULL,
    [NOMI_GUARD_ADD2] VARCHAR(500) NULL,
    [MINOR_BIRTH_DATE] DATETIME NULL,
    [CM_ID] VARCHAR(100) NULL,
    [CH_ID] VARCHAR(100) NULL,
    [TRADING_ID] VARCHAR(100) NULL,
    [GROUP_ID] VARCHAR(100) NULL,
    [EXCHANGE_ID] VARCHAR(100) NULL,
    [PROD_NO] VARCHAR(100) NULL,
    [ACTIVE_STATUS] VARCHAR(100) NULL,
    [CHANGE_REASON] VARCHAR(500) NULL,
    [BRANCH_CODE] VARCHAR(100) NULL,
    [GROUP_CODE] VARCHAR(100) NULL,
    [FAMILY_CODE] VARCHAR(100) NULL,
    [TEMPLATE_CODE] VARCHAR(100) NULL,
    [NISE_PARTY_CODE] VARCHAR(100) NULL,
    [MAILING_FLAG] VARCHAR(100) NULL,
    [DISPATCH_MODE] VARCHAR(100) NULL,
    [BILLING_FREQ] VARCHAR(100) NULL,
    [PRINT_DATE] VARCHAR(100) NULL,
    [LETTER_NO] VARCHAR(100) NULL,
    [FILE_REF_NO] VARCHAR(100) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [FIRST_HOLD_ADD4] VARCHAR(500) NULL,
    [BENEF_STATUS] VARCHAR(100) NULL,
    [INTRO_ID] VARCHAR(100) NULL,
    [SHORT_NAME] VARCHAR(500) NULL,
    [CLIENT_CODE] VARCHAR(100) NULL,
    [CLIENT_CITY_CODE] VARCHAR(100) NULL,
    [BENEF_ACCNO] VARCHAR(100) NULL,
    [PURCHASE_WAIVER] VARCHAR(100) NULL,
    [TYPE] VARCHAR(100) NULL,
    [DP_ID] VARCHAR(50) NULL,
    [BO_DOB] VARCHAR(15) NULL,
    [BO_SEX] VARCHAR(10) NULL,
    [BO_NATIONALITY] VARCHAR(100) NULL,
    [NO_STMT_CODE] VARCHAR(100) NULL,
    [CLOSE_REASON] VARCHAR(500) NULL,
    [CLOSE_INITIATE] VARCHAR(100) NULL,
    [CLOSE_REQ_DATE] DATETIME NULL,
    [CLOSE_APPROVAL_DATE] DATETIME NULL,
    [BO_SUSPENSION_FLAG] VARCHAR(100) NULL,
    [BO_SUSPENSION_DATE] DATETIME NULL,
    [BO_SUSPENSION_REASON] VARCHAR(500) NULL,
    [BO_SUSPENSION_INITIATE] VARCHAR(100) NULL,
    [PROFESSION_CODE] VARCHAR(100) NULL,
    [LIFE_STYLE_CODE] VARCHAR(100) NULL,
    [GEOGRAPH_CODE] VARCHAR(100) NULL,
    [EDUCATION_CODE] VARCHAR(100) NULL,
    [INCOME_CODE] VARCHAR(100) NULL,
    [STAFF_FLAG] VARCHAR(100) NULL,
    [STAFF_CODE] VARCHAR(100) NULL,
    [ELECTRONIC_DIVIDEND] VARCHAR(100) NULL,
    [ELECTRONIC_CONF] VARCHAR(100) NULL,
    [DIVIDEND_CURRENCY] VARCHAR(100) NULL,
    [BO_BANK_CODE] VARCHAR(100) NULL,
    [BO_BRANCH_NO] VARCHAR(100) NULL,
    [DIVIDEND_ACCOUNT_NO] VARCHAR(100) NULL,
    [BO_CURRENCY] VARCHAR(100) NULL,
    [BANK_ACCOUNT_TYPE] VARCHAR(100) NULL,
    [BANK_ACC_TYPE] VARCHAR(100) NULL,
    [BANK_PIN] VARCHAR(100) NULL,
    [DIVIDEND_BRANCH_NO] VARCHAR(100) NULL,
    [DIVIDEND_ACC_CURRENCY] VARCHAR(100) NULL,
    [DIVIDEND_BANK_AC_TYPE] VARCHAR(100) NULL,
    [PURPOSE_ADDITIONAL_NAME] VARCHAR(100) NULL,
    [SETUP_DATE] DATETIME NULL,
    [POA_START_DATE] DATETIME NULL,
    [POA_END_DATE] DATETIME NULL,
    [POA_ENABLED] VARCHAR(100) NULL,
    [POA_TYPE] VARCHAR(100) NULL,
    [LANG_CODE] VARCHAR(100) NULL,
    [ITPAN_CIRCLE] VARCHAR(100) NULL,
    [SECOND_HOLD_ITPAN] VARCHAR(20) NULL,
    [THIRD_HOLD_ITPAN] VARCHAR(20) NULL,
    [FIRST_HOLD_FNAME] VARCHAR(500) NULL,
    [ADDITIONAL_PURPOSE_CODE] VARCHAR(100) NULL,
    [ADDITIONAL_HOLDER_NAME] VARCHAR(500) NULL,
    [ADDITIONAL_SETUP_DATE] VARCHAR(100) NULL,
    [FAX_INDEMNITY] VARCHAR(100) NULL,
    [EMAIL_FLAG] VARCHAR(100) NULL,
    [FIRST_HOLD_MOBILE] VARCHAR(100) NULL,
    [FIRST_SMS_FLAG] VARCHAR(100) NULL,
    [SMART_REMARKS] VARCHAR(500) NULL,
    [FIRST_HOLD_PAN] VARCHAR(20) NULL,
    [POA_VER] VARCHAR(100) NULL,
    [DpApplicationNO] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NewECNCode
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NewECNCode]
(
    [reg_date] NVARCHAR(255) NULL,
    [mail_id] NVARCHAR(255) NULL,
    [tel_no] NVARCHAR(255) NULL,
    [client_code] NVARCHAR(255) NULL,
    [name] NVARCHAR(255) NULL,
    [reg_status] NVARCHAR(255) NULL,
    [entered_by] NVARCHAR(255) NULL,
    [entered_on] NVARCHAR(255) NULL,
    [access_code] NVARCHAR(255) NULL,
    [access_to] NVARCHAR(255) NULL,
    [status] NVARCHAR(255) NULL,
    [path] NVARCHAR(255) NULL,
    [path2] NVARCHAR(255) NULL,
    [ref_no] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_reactive
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_reactive]
(
    [party_code] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_test_emp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_test_emp]
(
    [Name] VARCHAR(50) NULL,
    [Gender] VARCHAR(50) NULL,
    [Age] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Test1
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Test1]
(
    [Id] INT NOT NULL,
    [SB] VARCHAR(20) NOT NULL,
    [Code] VARCHAR(50) NOT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [XMLData] XML NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Test2
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Test2]
(
    [SB] VARCHAR(20) NOT NULL,
    [Name] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorAddress_ContactDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorAddress_ContactDetails]
(
    [VendorMasterId] BIGINT NULL,
    [AddType] VARCHAR(5) NULL,
    [AddressLine1] VARCHAR(355) NULL,
    [AddressLine2] VARCHAR(355) NULL,
    [Landmark] VARCHAR(255) NULL,
    [City] VARCHAR(255) NULL,
    [State] VARCHAR(155) NULL,
    [Country] VARCHAR(155) NULL,
    [PinCode] VARCHAR(15) NULL,
    [Std] VARCHAR(10) NULL,
    [Phone] VARCHAR(15) NULL,
    [MobileNo] VARCHAR(25) NULL,
    [MobileNo2] VARCHAR(25) NULL,
    [EmailId] VARCHAR(255) NULL,
    [CreatedBy] VARCHAR(25) NULL,
    [CreationDate] DATE NULL,
    [Status] VARCHAR(455) NULL,
    [Remarks] VARCHAR(455) NULL,
    [IsAddressDocUploaded] BIT NULL,
    [AddressDocUploadedDate] DATETIME NULL,
    [IsAggrementDocUploaded] BIT NULL,
    [AggrementDocUploadedDate] DATETIME NULL,
    [IsMOA_DocUploaded] BIT NULL,
    [MOA_DocUploadedDate] DATETIME NULL,
    [IsIncorporationCertificateDocUploaded] BIT NULL,
    [IncorporationCertificateDocUploadedDate] DATETIME NULL,
    [OtherRemarks] VARCHAR(455) NULL,
    [ModificationType] VARCHAR(255) NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorAllDocumentDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorAllDocumentDetails]
(
    [VendorDocId] BIGINT IDENTITY(1,1) NOT NULL,
    [VendorMasterId] BIGINT NULL,
    [PanDocumentName] VARCHAR(255) NULL,
    [PanDocumentExtension] VARCHAR(10) NULL,
    [PanDocumentFile] IMAGE NULL,
    [AddressDocumentName] VARCHAR(255) NULL,
    [AddressDocumentExtension] VARCHAR(10) NULL,
    [AddressDocumentFile] IMAGE NULL,
    [AggrementDocumentName] VARCHAR(255) NULL,
    [AggrementDocumentExtension] VARCHAR(10) NULL,
    [AggrementDocumentFile] IMAGE NULL,
    [MOA_DocumentName] VARCHAR(255) NULL,
    [MOA_DocumentExtension] VARCHAR(10) NULL,
    [MOA_DocumentFile] IMAGE NULL,
    [IncorporationCertificateDocumentName] VARCHAR(255) NULL,
    [IncorporationCertificateDocumentExtension] VARCHAR(10) NULL,
    [IncorporationCertificateDocumentFile] IMAGE NULL,
    [BankCancelChequeDocumentName] VARCHAR(255) NULL,
    [BankCancelChequeDocumentExtension] VARCHAR(10) NULL,
    [BankCancelChequeDocumentFile] IMAGE NULL,
    [GstCertificateDocumentName] VARCHAR(255) NULL,
    [GstCertificateDocumentExtension] VARCHAR(10) NULL,
    [GstCertificateDocumentFile] IMAGE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorBankMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorBankMaster]
(
    [VendorMasterId] BIGINT NULL,
    [BankAccountNo] VARCHAR(25) NULL,
    [IFSC_Code] VARCHAR(25) NULL,
    [MICR_No] VARCHAR(45) NULL,
    [BankName] VARCHAR(355) NULL,
    [Branch] VARCHAR(455) NULL,
    [NameInBank] VARCHAR(255) NULL,
    [BankAddress] VARCHAR(455) NULL,
    [City] VARCHAR(255) NULL,
    [State] VARCHAR(255) NULL,
    [PinCode] VARCHAR(15) NULL,
    [AccountType] VARCHAR(15) NULL,
    [PayMode] VARCHAR(55) NULL,
    [Status] VARCHAR(15) NULL,
    [ActiveBy] VARCHAR(25) NULL,
    [ActiveDate] DATE NULL,
    [InActiveDate] DATE NULL,
    [Remarks] VARCHAR(455) NULL,
    [IsCancelChequeDocUploaded] BIT NULL,
    [CancelChequeDocUploadedDate] DATETIME NULL,
    [OtherRemarks] VARCHAR(455) NULL,
    [EntryBy] VARCHAR(25) NULL,
    [EntryDate] DATETIME NULL,
    [ModificationRemarks] VARCHAR(455) NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorCreationVerificationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorCreationVerificationMaster]
(
    [VendorMasterId] BIGINT NULL,
    [Status] VARCHAR(10) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [VerificationDate] DATETIME NULL,
    [VerifyBy] VARCHAR(25) NULL,
    [OtherRemarks] VARCHAR(MAX) NULL,
    [UpdationDate] DATETIME NULL,
    [UpdatedBy] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorDirectors_PartnersDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorDirectors_PartnersDetails]
(
    [PartnersId] BIGINT IDENTITY(1,1) NOT NULL,
    [VendorMasterId] BIGINT NULL,
    [Type] VARCHAR(25) NULL,
    [Name] VARCHAR(355) NULL,
    [PanNo] VARCHAR(15) NULL,
    [RatioPercentage] INT NULL,
    [Gender] VARCHAR(10) NULL,
    [AddressLine1] VARCHAR(355) NULL,
    [AddressLine2] VARCHAR(355) NULL,
    [Landmark] VARCHAR(255) NULL,
    [City] VARCHAR(155) NULL,
    [State] VARCHAR(155) NULL,
    [PinCode] VARCHAR(15) NULL,
    [Std] VARCHAR(10) NULL,
    [PhoneNo] VARCHAR(15) NULL,
    [MobileNo] VARCHAR(15) NULL,
    [EmailId] VARCHAR(355) NULL,
    [EntryBy] VARCHAR(25) NULL,
    [EntryDate] DATE NULL,
    [Status] VARCHAR(455) NULL,
    [Remarks] VARCHAR(455) NULL,
    [IsPanDocumentUploaded] BIT NULL,
    [PanDocUploadedDate] DATETIME NULL,
    [OtherRemarks] VARCHAR(455) NULL,
    [IsAddressDocumentUploaded] BIT NULL,
    [AddressDocUploadedDate] DATETIME NULL,
    [OtherRemarks2] VARCHAR(455) NULL,
    [ModificationType] VARCHAR(255) NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorDirectors_PartnersDocumentDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorDirectors_PartnersDocumentDetails]
(
    [PartnersDocId] BIGINT IDENTITY(1,1) NOT NULL,
    [PartnersId] BIGINT NULL,
    [VendorMasterId] BIGINT NULL,
    [PanDocumentName] VARCHAR(255) NULL,
    [PanDocumentExtension] VARCHAR(10) NULL,
    [PanDocumentFile] IMAGE NULL,
    [AddressDocumentName] VARCHAR(255) NULL,
    [AddressDocumentExtension] VARCHAR(10) NULL,
    [AddressDocumentFile] IMAGE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorGeneralDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorGeneralDetails]
(
    [VendorMasterId] BIGINT IDENTITY(1,1) NOT NULL,
    [VendorNumber] VARCHAR(35) NULL,
    [TradeName] VARCHAR(455) NULL,
    [IndividualName_Prop_sole] VARCHAR(455) NULL,
    [Constitution] VARCHAR(55) NULL,
    [TotalDirectors] INT NULL,
    [PanNo] VARCHAR(15) NULL,
    [DateOfIncorporation] DATETIME NULL,
    [IsActive] VARCHAR(15) NULL,
    [IsActiveDate] DATETIME NULL,
    [CreatedBy] VARCHAR(25) NULL,
    [CreationDate] DATETIME NULL,
    [Status] VARCHAR(455) NULL,
    [Remarks] VARCHAR(455) NULL,
    [IsPanDocumentUploaded] BIT NULL,
    [PanDocumentUploadedDate] DATETIME NULL,
    [OtherRemarks] VARCHAR(455) NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL,
    [IsFinalSubmit] BIT NULL,
    [FinalSubmittionDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VendorGST_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VendorGST_Details]
(
    [VendorMasterId] BIGINT NULL,
    [PanNo] VARCHAR(15) NULL,
    [TradeName] VARCHAR(355) NULL,
    [GSTIN] VARCHAR(55) NULL,
    [GSTRegDate] DATETIME NULL,
    [FullAddress] VARCHAR(455) NULL,
    [State] VARCHAR(155) NULL,
    [PinCode] VARCHAR(15) NULL,
    [EntryBy] VARCHAR(25) NULL,
    [EntryDate] DATE NULL,
    [Remarks] VARCHAR(455) NULL,
    [IsGstCertificateDocumentUpload] BIT NULL,
    [GstCertificateDocUploadedDate] DATETIME NULL,
    [OtherRemarks] VARCHAR(455) NULL,
    [ModificationType] VARCHAR(255) NULL,
    [ModifyBy] VARCHAR(25) NULL,
    [ModifyDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbrokslab
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbrokslab]
(
    [Code] VARCHAR(255) NULL,
    [Delivery_percent] MONEY NULL,
    [type] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbrokslab_bak
-- --------------------------------------------------
CREATE TABLE [dbo].[tbrokslab_bak]
(
    [Code] VARCHAR(255) NULL,
    [Delivery_percent] MONEY NULL,
    [type] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp__date
-- --------------------------------------------------
CREATE TABLE [dbo].[temp__date]
(
    [SAUDA_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Debithold
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Debithold]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [client_name] VARCHAR(21) NULL,
    [cm_cd] CHAR(16) NULL,
    [pcode] CHAR(20) NULL,
    [cm_opendate] DATETIME NULL,
    [clsdate] CHAR(8) NULL,
    [Totbal] MONEY NULL,
    [DPbal] MONEY NULL,
    [typ] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ebrok_email
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ebrok_email]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [ECN] VARCHAR(3) NOT NULL,
    [EMAIL] VARCHAR(3) NOT NULL,
    [mobile] VARCHAR(3) NOT NULL,
    [status] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_ECNBounce_MAIL_BR
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_ECNBounce_MAIL_BR]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [client_code] VARCHAR(200) NULL,
    [client_name] VARCHAR(800) NULL,
    [client_email] VARCHAR(400) NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [res_phone] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ecnreg
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ecnreg]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_email
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_email]
(
    [mess] TEXT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_mis_file1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_mis_file1]
(
    [sLoginId] VARCHAR(10) NULL,
    [nMarketSegmentId] INT NULL,
    [sUserDefinedExchangeName] VARCHAR(20) NULL,
    [nAmount] DECIMAL(18, 2) NULL,
    [nServiceCharge] DECIMAL(18, 2) NULL,
    [sDateTime] DATETIME NULL,
    [nTxnRefNo] VARCHAR(13) NULL,
    [sGroupId] VARCHAR(10) NULL,
    [nProcessFlag] INT NULL,
    [sBankId] VARCHAR(10) NULL,
    [sAgencyId] VARCHAR(20) NULL,
    [sBankRefNo] VARCHAR(20) NULL,
    [sFromAccNo] VARCHAR(16) NULL,
    [sToAccNo] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_zerohold
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_zerohold]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [client_name] VARCHAR(21) NULL,
    [pcode] CHAR(20) NULL,
    [last_trans_date] CHAR(8) NULL,
    [cm_cd] CHAR(16) NOT NULL,
    [cm_opendate] DATETIME NULL,
    [totbal] MONEY NULL,
    [Dpbal] MONEY NULL,
    [typ] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1mis
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1mis]
(
    [name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempAZ
-- --------------------------------------------------
CREATE TABLE [dbo].[tempAZ]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(10) NOT NULL,
    [User_id] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] VARCHAR(16) NULL,
    [MarketRate] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] NUMERIC(15, 7) NULL,
    [Amount] MONEY NULL,
    [Ins_chrg] MONEY NULL,
    [turn_tax] MONEY NULL,
    [other_chrg] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [Broker_chrg] MONEY NULL,
    [Service_tax] MONEY NULL,
    [Trade_amount] MONEY NULL,
    [Billflag] INT NULL,
    [sett_no] VARCHAR(7) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] NUMERIC(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [participantcode] CHAR(15) NULL,
    [status] CHAR(2) NULL,
    [pro_cli] VARCHAR(10) NULL,
    [cpid] VARCHAR(20) NULL,
    [instrument] VARCHAR(2) NULL,
    [bookType] VARCHAR(2) NULL,
    [branch_id] VARCHAR(10) NULL,
    [dummy1] VARCHAR(2) NULL,
    [dummy2] MONEY NULL,
    [tmark] CHAR(2) NULL,
    [Scheme] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempfile
-- --------------------------------------------------
CREATE TABLE [dbo].[tempfile]
(
    [date1] VARCHAR(8000) NULL,
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temptable
-- --------------------------------------------------
CREATE TABLE [dbo].[temptable]
(
    [reg_date] VARCHAR(11) NULL,
    [mail_id] VARCHAR(45) NULL,
    [tel_no] VARCHAR(30) NULL,
    [client_code] VARCHAR(10) NULL,
    [flag] NUMERIC(2, 0) NULL,
    [reg_no] VARCHAR(30) NULL,
    [reg_status] VARCHAR(5) NULL,
    [entered_by] VARCHAR(25) NULL,
    [entered_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test_clientemail
-- --------------------------------------------------
CREATE TABLE [dbo].[test_clientemail]
(
    [SrNo] INT NOT NULL,
    [Name] VARCHAR(50) NULL,
    [emailid] VARCHAR(50) NULL,
    [upd_dt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEST1
-- --------------------------------------------------
CREATE TABLE [dbo].[TEST1]
(
    [NAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.time_period
-- --------------------------------------------------
CREATE TABLE [dbo].[time_period]
(
    [time_period] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TMP_CASES_NOT_FOUND_IN_DIRECT_PUSH_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TMP_CASES_NOT_FOUND_IN_DIRECT_PUSH_DETAILS]
(
    [CreatedDate] DATE NULL,
    [TYPE] VARCHAR(12) NOT NULL,
    [Application_No] VARCHAR(15) NOT NULL,
    [PAN] VARCHAR(10) NOT NULL,
    [Party_Name] VARCHAR(100) NOT NULL,
    [Party_Code] VARCHAR(11) NOT NULL,
    [KYC_Application_ID] VARCHAR(15) NOT NULL,
    [First_Name] VARCHAR(100) NOT NULL,
    [Middle_Name] VARCHAR(100) NOT NULL,
    [Last_Name] VARCHAR(100) NOT NULL,
    [PAN_No] VARCHAR(10) NOT NULL,
    [Address1] VARCHAR(150) NOT NULL,
    [Address2] VARCHAR(150) NOT NULL,
    [Address3] VARCHAR(150) NOT NULL,
    [City] NVARCHAR(255) NULL,
    [Pincode] FLOAT NULL,
    [Mobile] FLOAT NULL,
    [Tel_Res] VARCHAR(1) NOT NULL,
    [Email_Id] VARCHAR(50) NOT NULL,
    [State] VARCHAR(50) NOT NULL,
    [DPID] VARCHAR(16) NOT NULL,
    [Appointment_Date] VARCHAR(50) NOT NULL,
    [Appointment_TimeM] VARCHAR(1) NULL,
    [Appointment_Time_1] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tradeanywhere_master
-- --------------------------------------------------
CREATE TABLE [dbo].[Tradeanywhere_master]
(
    [Client_code] VARCHAR(50) NULL,
    [Client_lock_st] VARCHAR(50) NULL,
    [Pwd_Lock_st] VARCHAR(50) NULL,
    [Source] VARCHAR(50) NULL,
    [Loggedin_Source] VARCHAR(50) NULL,
    [login_id] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [Suspended_st] VARCHAR(50) NULL,
    [Profile_code] VARCHAR(50) NULL,
    [ClientType] VARCHAR(50) NULL,
    [ClientCategory] VARCHAR(50) NULL,
    [PrimaryDealer] VARCHAR(50) NULL,
    [ClienTStatus] VARCHAR(50) NULL,
    [client_id] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tradeanywhere_master_newver
-- --------------------------------------------------
CREATE TABLE [dbo].[Tradeanywhere_master_newver]
(
    [Client_code] VARCHAR(50) NULL,
    [Client_lock_st] VARCHAR(50) NULL,
    [Pwd_Lock_st] VARCHAR(50) NULL,
    [Source] VARCHAR(50) NULL,
    [Loggedin_Source] VARCHAR(50) NULL,
    [login_id] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [Suspended_st] VARCHAR(50) NULL,
    [Profile_code] VARCHAR(50) NULL,
    [ClientType] VARCHAR(50) NULL,
    [ClientCategory] VARCHAR(50) NULL,
    [PrimaryDealer] VARCHAR(50) NULL,
    [ClienTStatus] VARCHAR(50) NULL,
    [client_id] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tradeanywhere_master1
-- --------------------------------------------------
CREATE TABLE [dbo].[tradeanywhere_master1]
(
    [Client_code] VARCHAR(50) NULL,
    [Client_lock_st] VARCHAR(50) NULL,
    [Pwd_Lock_st] VARCHAR(50) NULL,
    [Source] VARCHAR(50) NULL,
    [Loggedin_Source] VARCHAR(50) NULL,
    [login_id] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [Suspended_st] VARCHAR(50) NULL,
    [Profile_code] VARCHAR(50) NULL,
    [ClientType] VARCHAR(50) NULL,
    [ClientCategory] VARCHAR(50) NULL,
    [PrimaryDealer] VARCHAR(50) NULL,
    [ClienTStatus] VARCHAR(50) NULL,
    [client_id] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TradeAnywhereProcess
-- --------------------------------------------------
CREATE TABLE [dbo].[TradeAnywhereProcess]
(
    [ReportType] VARCHAR(50) NULL,
    [ProcessDateTime] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tt
-- --------------------------------------------------
CREATE TABLE [dbo].[tt]
(
    [SRNO] BIGINT NULL,
    [reg_date] DATETIME NOT NULL,
    [mail_id] NVARCHAR(255) NULL,
    [tel_no] NVARCHAR(255) NULL,
    [client_code] NVARCHAR(255) NULL,
    [name] NVARCHAR(255) NULL,
    [reg_status] NVARCHAR(255) NULL,
    [entered_by] NVARCHAR(255) NULL,
    [entered_on] DATETIME NOT NULL,
    [access_code] NVARCHAR(255) NULL,
    [access_to] NVARCHAR(255) NULL,
    [status] NVARCHAR(255) NULL,
    [path] NVARCHAR(255) NULL,
    [path2] NVARCHAR(255) NULL,
    [ref_no] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.udt_qualityfeedbackform
-- --------------------------------------------------
CREATE TABLE [dbo].[udt_qualityfeedbackform]
(
    [stands_apart] VARCHAR(300) NULL,
    [client_reason] VARCHAR(600) NULL,
    [currentlyusing_products] VARCHAR(200) NULL,
    [overall_experience] VARCHAR(25) NULL,
    [no_angelproducts] VARCHAR(600) NULL,
    [angel_associatedwith] VARCHAR(70) NULL,
    [hearing_angelthrough] VARCHAR(50) NULL,
    [relevant_tagline] VARCHAR(90) NULL,
    [invertor_rating] VARCHAR(50) NULL,
    [aware_qlty_assurance] CHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [contactno] VARCHAR(50) NULL,
    [branch] VARCHAR(50) NULL,
    [client_tag] VARCHAR(20) NULL,
    [entrydate] DATETIME NULL,
    [investor_rating_reason] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.udt_qualityfeedbackformcopy
-- --------------------------------------------------
CREATE TABLE [dbo].[udt_qualityfeedbackformcopy]
(
    [stands_apart] VARCHAR(300) NULL,
    [client_reason] VARCHAR(600) NULL,
    [currentlyusing_products] VARCHAR(200) NULL,
    [overall_experience] VARCHAR(25) NULL,
    [no_angelproducts] VARCHAR(600) NULL,
    [angel_associatedwith] VARCHAR(70) NULL,
    [hearing_angelthrough] VARCHAR(50) NULL,
    [relevant_tagline] VARCHAR(90) NULL,
    [invertor_rating] VARCHAR(50) NULL,
    [aware_qlty_assurance] CHAR(10) NULL,
    [name] VARCHAR(50) NULL,
    [contactno] VARCHAR(50) NULL,
    [branch] VARCHAR(50) NULL,
    [client_tag] VARCHAR(20) NULL,
    [entrydate] DATETIME NULL,
    [investor_rating_reason] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_master
-- --------------------------------------------------
CREATE TABLE [dbo].[user_master]
(
    [Valid] VARCHAR(50) NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
    [Add1] VARCHAR(50) NOT NULL,
    [Add2] VARCHAR(50) NOT NULL,
    [Add3] VARCHAR(50) NOT NULL,
    [City] VARCHAR(50) NOT NULL,
    [Pin] VARCHAR(50) NOT NULL,
    [State] VARCHAR(50) NOT NULL,
    [Tel_No] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserDetp
-- --------------------------------------------------
CREATE TABLE [dbo].[UserDetp]
(
    [DeptId] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.usp_sent_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[usp_sent_branch]
(
    [branch] VARCHAR(12) NULL,
    [BM] VARCHAR(70) NULL,
    [BM_mail] VARCHAR(8000) NULL,
    [rgm_mail] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.utd_Qualityfeedback
-- --------------------------------------------------
CREATE TABLE [dbo].[utd_Qualityfeedback]
(
    [questions] VARCHAR(50) NULL,
    [Total] VARCHAR(15) NULL,
    [optioin_1] VARCHAR(15) NULL,
    [option_2] VARCHAR(15) NULL,
    [option_3] VARCHAR(15) NULL,
    [option_4] VARCHAR(15) NULL,
    [option_5] VARCHAR(15) NULL,
    [option_6] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.utd_questionmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[utd_questionmaster]
(
    [question_no] NUMERIC(18, 0) NULL,
    [questonname] VARCHAR(200) NULL,
    [option1] VARCHAR(100) NULL,
    [OPTION2] VARCHAR(100) NULL,
    [OPTION3] VARCHAR(100) NULL,
    [OPTION4] VARCHAR(100) NULL,
    [option5] VARCHAR(100) NULL,
    [option6] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vinay
-- --------------------------------------------------
CREATE TABLE [dbo].[vinay]
(
    [Title] NVARCHAR(255) NULL,
    [Name ] NVARCHAR(255) NULL,
    [Address1] NVARCHAR(255) NULL,
    [Address2] NVARCHAR(255) NULL,
    [City] NVARCHAR(255) NULL,
    [Pincode] VARCHAR(25) NULL,
    [State] NVARCHAR(255) NULL,
    [F8] NVARCHAR(255) NULL,
    [F9] NVARCHAR(255) NULL,
    [F10] NVARCHAR(255) NULL,
    [F11] NVARCHAR(255) NULL,
    [F12] NVARCHAR(255) NULL,
    [F13] NVARCHAR(255) NULL,
    [F14] NVARCHAR(255) NULL,
    [F15] NVARCHAR(255) NULL,
    [F16] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.x1603
-- --------------------------------------------------
CREATE TABLE [dbo].[x1603]
(
    [code] NVARCHAR(255) NULL,
    [name] NVARCHAR(255) NULL,
    [scrip] NVARCHAR(255) NULL,
    [series] NVARCHAR(255) NULL,
    [dpid] FLOAT NULL,
    [cltid] FLOAT NULL,
    [isin] NVARCHAR(255) NULL,
    [settno] FLOAT NULL,
    [setttyp] NVARCHAR(255) NULL,
    [qty1] FLOAT NULL,
    [qty2] FLOAT NULL,
    [qty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xmumbai
-- --------------------------------------------------
CREATE TABLE [dbo].[xmumbai]
(
    [SBCODE] NVARCHAR(255) NULL,
    [NAME OF SB] NVARCHAR(255) NULL,
    [ADDRESS 1] NVARCHAR(255) NULL,
    [ADDRESS2] NVARCHAR(255) NULL,
    [CITY] NVARCHAR(255) NULL,
    [PIN CODE] VARCHAR(10) NULL,
    [PHONE NO] FLOAT NULL,
    [PHONE ] FLOAT NULL,
    [PHONE1] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xxx2402
-- --------------------------------------------------
CREATE TABLE [dbo].[xxx2402]
(
    [code] NVARCHAR(255) NULL,
    [name] NVARCHAR(255) NULL,
    [scrip] NVARCHAR(255) NULL,
    [series] NVARCHAR(255) NULL,
    [isin] NVARCHAR(255) NULL,
    [settno] FLOAT NULL,
    [setttyp] NVARCHAR(255) NULL,
    [qty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.T_ecn_reg
-- --------------------------------------------------
CREATE TRIGGER T_ecn_reg
ON  ecn_reg
for DELETE,UPDATE      
AS       
BEGIN      
 SET NOCOUNT ON      
 begin try    
 declare @srno int ,@actiontype varchar(8),@host varchar(20),@ipAddress varchar(20)          
           
 set @host = (select host_name())                
 set @ipAddress = (SELECT top 1 client_net_address FROM sys.dm_exec_connections             
 WHERE session_id = @@SPID)          
    
     
 if (select count(*) from inserted)>=1    
 begin     
 set @actiontype='updated'    
 end    
 else    
 begin       
   set @actiontype='deleted'    
 end      
  insert into ecn_reg_triglog  
  select reg_date,mail_id,tel_no,client_code,flag,reg_no,reg_status,entered_by,entered_on,  
  @actiontype,getdate(),@host,@ipAddress     
  from deleted with (nolock)         
 end try    
 begin catch    
  DECLARE @ErrorMessage NVARCHAR(4000);    
 SELECT @ErrorMessage = ERROR_MESSAGE();    
 RAISERROR (@ErrorMessage, 16, 1);    
    
  rollback transaction    
  end catch    
     
END

GO

-- --------------------------------------------------
-- VIEW dbo.NPV_EMR
-- --------------------------------------------------
CREATE view NPV_EMR  
as  
select A.POLICYCODE,TIME_PERIOD=TIME_PERIOD-1,month,year,username,  
amount=  
SUM(case   
when time_period <= CONVERt(INT,Payterm) and time_period <= 3 then CONVERt(MONEY,[sum])*npv_2_3  
when time_period <= CONVERt(INT,Payterm) and time_period > 3 and time_period <= 5 then CONVERt(MONEY,[sum])*npv_4_5  
when time_period <= CONVERt(INT,Payterm) and time_period > 5 then CONVERt(MONEY,[sum])*npv_6onwards  
else 0 end)*(d.renSuccRatio/100)  
from NPV_TEMP_product_master a, time_period b, policytable c, Npv_setup d  
where a.policyType=c.policytype  
--order by month,year,a.policyType,time_period,CONVERt(INT,Payterm)  
GROUP BY month,year,A.POLICYCODE,TIME_PERIOD,d.renSuccRatio,username

GO

-- --------------------------------------------------
-- VIEW dbo.Reject_LDate
-- --------------------------------------------------


CReate View Reject_LDate
as
select party_code,RDate=max(RejectedOn)
from rejected_ecn(nolock)
group by party_code

GO

-- --------------------------------------------------
-- VIEW dbo.Reject_Remark
-- --------------------------------------------------
CReate View Reject_Remark
as
select a.party_code,RejectedOn,Reason from Reject_LDate a (nolock)
left outer join
rejected_ecn b (nolock) 
on a.party_code=b.party_code and a.RDate=b.rejectedon

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_NotUpdECNClienMobile
-- --------------------------------------------------
  
CREATE View Vw_NotUpdECNClienMobile  
as  
select distinct a.* from  
(  
select client_code,  
(case when tel_no like '09%' then '9'+substring(tel_no,3,15) else tel_No end) as tel_no   
from ecn_reg where tel_no <> '' and (tel_no like '9%' or tel_no like '09%')   
and len(ltrim(rtrim((case when tel_no like '09%' then '9'+substring(tel_no,3,15) else tel_No end)))) = 10  
and flag=1  
) a left outer join  
(select partY_Code,mobile_pager=case when mobile_pager like '0%' then substring(mobile_pager,2,15) else mobile_pager end          
/*from mimansa.angelcs.dbo.angelclient1  where isnull(Mobilevalidatedby,'') <> '') b  */
from intranet.risk.dbo.client_details with (nolock)) b
on a.client_Code=b.party_Code and a.tel_no=b.mobile_pager  
where b.mobile_pager is null

GO

