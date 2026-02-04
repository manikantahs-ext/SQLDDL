-- DDL Export
-- Server: 10.253.33.89
-- Database: Nsecourier
-- Exported: 2026-02-05T02:39:12.749068

USE Nsecourier;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fx_SumTwoValues
-- --------------------------------------------------
CREATE FUNCTION fx_SumTwoValues
( @Val1 int, @Val2 int )
RETURNS int
AS
BEGIN
  RETURN (@Val1+@Val2)
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.udf_Area
-- --------------------------------------------------
CREATE FUNCTION udf_Area (
        @Length float
      , @Width float
      )
    RETURNS float
AS BEGIN 
	RETURN @Length * @Width
END

GO

-- --------------------------------------------------
-- INDEX dbo.delb
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [delb_index] ON [dbo].[delb] ([client_code])

GO

-- --------------------------------------------------
-- INDEX dbo.delivered
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_client_code] ON [dbo].[delivered] ([client_code], [inbunch])

GO

-- --------------------------------------------------
-- INDEX dbo.delivered
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_dispatch_date] ON [dbo].[delivered] ([dispatch_date], [inbunch], [delivered], [branch_cd])

GO

-- --------------------------------------------------
-- INDEX dbo.hist_temp_offlinemaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_cl_code] ON [dbo].[hist_temp_offlinemaster] ([cl_code], [tdate])

GO

-- --------------------------------------------------
-- INDEX dbo.hist_temp_offlinemaster
-- --------------------------------------------------
CREATE CLUSTERED INDEX [tdate] ON [dbo].[hist_temp_offlinemaster] ([tdate])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_Delivered_Branch
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_fld_delivery_date] ON [dbo].[Tbl_Delivered_Branch] ([Fld_delivery_date], [fld_branch])

GO

-- --------------------------------------------------
-- INDEX dbo.temp_offlinemaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [tdate] ON [dbo].[temp_offlinemaster] ([tdate])

GO

-- --------------------------------------------------
-- INDEX dbo.TM
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ik] ON [dbo].[TM] ([pod])

GO

-- --------------------------------------------------
-- INDEX dbo.ttp
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [a] ON [dbo].[ttp] ([client_code])

GO

-- --------------------------------------------------
-- INDEX dbo.ttp
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [b] ON [dbo].[ttp] ([client_name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.login
-- --------------------------------------------------
ALTER TABLE [dbo].[login] ADD CONSTRAINT [PK_login] PRIMARY KEY ([name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Sheet1$
-- --------------------------------------------------
ALTER TABLE [dbo].[Sheet1$] ADD CONSTRAINT [PK__Sheet1$__7C2A14FE] PRIMARY KEY ([RowId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.temp_login
-- --------------------------------------------------
ALTER TABLE [dbo].[temp_login] ADD CONSTRAINT [PK_temp_login] PRIMARY KEY ([name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.undelivered
-- --------------------------------------------------
ALTER TABLE [dbo].[undelivered] ADD CONSTRAINT [PK_undelivered] PRIMARY KEY ([client_code])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a1
-- --------------------------------------------------
CREATE proc a1 (@name char(20),@value1 char(8) output)
as
select unique_code from login  where name=@name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a2
-- --------------------------------------------------
CREATE proc a2 (@name char(20),@value1 char(8) output)
as
select @value1=unique_code from login  where name=@name
select @value1
return 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a3
-- --------------------------------------------------
CREATE proc a3 @value1 char(10) output  
as  
  
select  @value1=count(*) from login 
select @value1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a33
-- --------------------------------------------------
CREATE proc a33 ( @a1 int,@a2 int,@a3 int output)
as



set @a3=@a1+@a2
return @a3

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a5
-- --------------------------------------------------
CREATE proc a5 (@name char(20))  
as  
select unique_code from login  where name=@name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a6
-- --------------------------------------------------
create proc a6(@name char(20),@uniq char(10),@pass char(10),@desig char(10))
as
insert into temp_login values (@name,@uniq,@pass,@desig)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.form_entry1
-- --------------------------------------------------
CREATE procedure form_entry1(@Dispatch_mode as varchar(25),@fdt as varchar(25),@tdt as varchar(25))                  
as                  
set nocount on                  
                  
if @Dispatch_mode='Hand Delivery'                   
begin                   
select convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,                  
Name,Telphone_no,                  
(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,                  
(case when fo='Y' then foqty else 0 end )as FO,(case when mcx='Y' then mcxqty else 0 end )as MCX,                  
(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,                  
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,                  
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate                   
from nsecourier.dbo.kyc_form_entry where Dispatch_Mode=@Dispatch_mode                  
and dispatch_date>=convert(varchar(11),convert(datetime,@fdt,103))               
and dispatch_date<=convert(varchar(11),convert(datetime,@tdt,103)) order by  dispatch_date              
end                   
else if @Dispatch_mode='Courier'                 
begin                   
select  convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,                  
Courier_Company,Delivery_mode,weight,pod,(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,                  
(case when fo='Y' then foqty else 0 end )as FO,(case when mcx='Y' then mcxqty else 0 end )as MCX,                  
(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,                  
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,                  
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate                   
from nsecourier.dbo.kyc_form_entry where Dispatch_Mode=@Dispatch_mode                  
and dispatch_date>=convert(varchar(11),convert(datetime,@fdt,103))              
and dispatch_date<=convert(varchar(11),convert(datetime,@tdt,103))  order by  dispatch_date             
end      
else if @Dispatch_mode='Combine Repart'    
begin    
select dispatch_mode as dispatch_mode,  Branch_cd as Branch ,
(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,                  
(case when fo='Y' then foqty else 0 end )as FO,(case when mcx='Y' then mcxqty else 0 end )as MCX,                  
(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,                  
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,                  
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO     
from nsecourier.dbo.kyc_form_entry where dispatch_date>='04/01/2008'               
and dispatch_date<='04/01/2008' order by dispatch_mode
end                 
else                
begin                   
select  convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,                  
Delivery_mode,weight,b.name as RecevierName,tel_no as ContactNumber,(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,                  
(case when fo='Y' then foqty else 0 end )as FO,(case when mcx='Y' then mcxqty else 0 end )as MCX,                  
(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,                  
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,         
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate                   
from nsecourier.dbo.kyc_form_entry a left outer join                 
 nsecourier.dbo.pod_entry b on pod=pod_no where                 
receive_dt>=convert(varchar(11),convert(datetime,@fdt,103))               
and receive_dt<=convert(varchar(11),convert(datetime,@tdt,103))           
end                   
                  
                  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InBunchBilling
-- --------------------------------------------------
create proc InBunchBilling
(@fdt as datetime,
@tdt as datetime)
as

select distinct cour_compn_name, bank_rate,dispatch_date into #temp
from delivered where inbunch = 'YES' order by bank_rate

select Company=cour_compn_name, Count=count(*),Rate= sum(bank_rate) from #temp
where dispatch_date >= @fdt and dispatch_date <= @tdt
group by cour_compn_name order by cour_compn_name

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_branch
-- --------------------------------------------------
CREATE proc inbunchbilling_branch       
(@fdt as datetime,            
@tdt as datetime)            
as            
            
select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,    
dispatch_date into #temp_branch from delivered where      
inbunch = 'YES' and dispatch_date >= @fdt and dispatch_date <= @tdt order by dispatch_date desc           
            
select branch_cd,count(*)count,Rate= sum(bank_rate)  from #temp_branch group by branch_cd            
            
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_branchwise
-- --------------------------------------------------
CREATE proc inbunchbilling_branchwise    
(@fdt as datetime,      
@tdt as datetime)      
as      
      
select distinct Branch_cd, bank_rate,dispatch_date into #temp      
from delivered where inbunch = 'YES' order by bank_rate      
      
select Branch=Branch_cd, Count=count(*),Rate= sum(bank_rate) from #temp      
where dispatch_date >= @fdt and dispatch_date <= @tdt and branch_cd is not null
group by Branch_cd order by Branch_cd      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_branchwise_new
-- --------------------------------------------------
CREATE proc inbunchbilling_branchwise_new            
(@fdt as datetime,                  
@tdt as datetime)  
                
as                  
                  
select distinct cour_compn_name,Branch_cd, bank_rate,dispatch_date into #temp                  
from delivered where inbunch = 'YES' and         
cour_compn_name <>'Lords Express' and cour_compn_name <>'other'             
and dispatch_date >=@fdt and dispatch_date <=@tdt  
and cour_compn_name <> 'Poonam Courier' and cour_compn_name <> 'MARUTI COURIER'   
order by bank_rate                  
                  
select distinct Branch=Branch_cd, Count=count(*),Rate= sum(bank_rate),Company=cour_compn_name from #temp                  
where dispatch_date >= @fdt and dispatch_date <= @tdt                       
group by Branch_cd,cour_compn_name order by Branch_cd           
    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courier
-- --------------------------------------------------
CREATE proc inbunchbilling_courier          
(@fdt as datetime,            
@tdt as datetime)            
as            
            
    
select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,    
dispatch_date into #temp_cour from delivered where      
inbunch = 'YES' and dispatch_date >= @fdt and dispatch_date <= @tdt order by dispatch_date desc           
            
select cour_compn_name,count(*)count,Rate= sum(bank_rate)  from #temp_cour group by cour_compn_name          
            
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courier_ind
-- --------------------------------------------------
CREATE proc inbunchbilling_courier_ind    
(@fdt as datetime,              
@tdt as datetime,      
@company as varchar(50))              
as              
              

select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,    
dispatch_date into #temp from delivered where      
inbunch = 'YES' and dispatch_date >= @fdt and dispatch_date <= @tdt
and cour_compn_name=@company order by dispatch_date,branch_cd,bank_rate 
              
select cour_compn_name,count(*)count,Rate= sum(bank_rate)  from #temp group by cour_compn_name                
              
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courierwise
-- --------------------------------------------------
CREATE proc inbunchbilling_courierwise    
(@fdt as datetime,      
@tdt as datetime)      
as      
      
select distinct cour_compn_name, bank_rate,dispatch_date into #temp      
from delivered where inbunch = 'YES' order by bank_rate      
      
select Company=cour_compn_name, Count=count(*),Rate= sum(bank_rate) from #temp      
where dispatch_date >= @fdt and dispatch_date <= @tdt      
group by cour_compn_name order by cour_compn_name      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courierwise_com
-- --------------------------------------------------
CREATE proc inbunchbilling_courierwise_com      
(@fdt as datetime,        
@tdt as datetime,
@company as varchar(50))        
as        
        
select distinct cour_compn_name, bank_rate,dispatch_date into #temp        
from delivered where inbunch = 'YES' and cour_compn_name=@company order by bank_rate        
        
select Company=cour_compn_name, Count=count(*),Rate= sum(bank_rate) from #temp        
where dispatch_date >= @fdt and dispatch_date <= @tdt and cour_compn_name=@company      
group by cour_compn_name order by cour_compn_name        
        
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courierwise_courier
-- --------------------------------------------------
CREATE proc inbunchbilling_courierwise_courier          
(@fdt as datetime,                  
@tdt as datetime,          
@company as varchar(50))          
as                  
                  
select distinct cour_compn_name,branch_cd, bank_rate,dispatch_date into #temp                  
from delivered where inbunch = 'YES' and cour_compn_name=@company and branch_cd is not null  
and dispatch_date >= @fdt and dispatch_date <= @tdt  order by bank_rate                  
                  
select Company=cour_compn_name, Count=count(*),Rate= sum(bank_rate) from #temp                  
where dispatch_date >= @fdt and dispatch_date <= @tdt  and cour_compn_name=@company group by cour_compn_name               
--group by cour_compn_name order by cour_compn_name                  
                  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.inbunchbilling_courierwise_new
-- --------------------------------------------------
CREATE proc inbunchbilling_courierwise_new            
(@fdt as datetime,              
@tdt as datetime)              
as              
              
select cour_compn_name, branch_cd, bank_rate,dispatch_date into #temp              
from delivered where inbunch = 'YES' and      
cour_compn_name <>'Lords Express' and cour_compn_name <>'other'       
and cour_compn_name <> 'Poonam Courier' and cour_compn_name <> 'MARUTI COURIER' and branch_cd is not null 
order by bank_rate              
              
select Company=cour_compn_name, Count=count(*),Rate= sum(bank_rate) from #temp              
where dispatch_date >= @fdt and dispatch_date <= @tdt              
group by cour_compn_name order by cour_compn_name              
              
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_delivered_details
-- --------------------------------------------------

-- exec insert_delivered_details 'V44644','292142','Balaji Courier','01/10/2011','01/10/2011','','' 
CREATE proc insert_delivered_details                                                 
(                                                                                
@client_code varchar(200),                                                                                
@pod varchar(20),                                                                                
@company varchar(100),                                                                                
@I_date varchar(11),                                                                        
@D_date varchar(11),                              
@wt varchar(50),                               
@wt1 varchar(50)                                      
)                                                                                
as                                                                                
declare @name varchar(100)                                                                                
declare @branch_cd varchar(20)                                                                                
declare @sb_code varchar(20)                                                                                
declare @cnt1 numeric(5)                                                                                
declare @cnt2 numeric(5)                                                                        
declare @cnt3 numeric(5)         
declare @cnt4 numeric(5)                                                                     
declare @flag1 numeric(1)                                                                                
declare @flag2 numeric(1)                                                                        
declare @flag3 numeric(1)      
declare @flag4 numeric(1)                                                                         
declare @str varchar(100)                              
declare @rt varchar(50)                            
declare @rt1 varchar(50)                          
declare @cost1 varchar(50)                            
declare @cost2 varchar(50)                           
                          
Set @client_code=ltrim(rtrim(@client_code))                                                                            
Set @pod=ltrim(rtrim(@pod))                                                                              
Set @company=ltrim(rtrim(@company))                                                                               
Set @I_date=ltrim(rtrim(@I_date))          
Set @D_date=ltrim(rtrim(@D_date))          
Set @wt=ltrim(rtrim(@wt))                            
Set @wt1=ltrim(rtrim(@wt1))          
                          
                                 
if(@company = 'Vichare Courier')                          
                     
                          
set @rt = (select lowerl from courier_rates(nolock) where company = 'Vichare Courier' and lowerl = @wt)                          
set @rt1 = (select upperl from courier_rates(nolock) where company = 'Vichare Courier' and upperl = @wt1)                          
                          
                          
if @rt1='100'                          
begin                          
set @cost1 = (select  rate from courier_rates(nolock)where company='Vichare Courier' and type='Next Day Delivery' and upperl=@rt1 )                          
end                        
                          
if @rt1='250'                          
begin            
set @cost2 = (select  rate from courier_rates(nolock)where company='Vichare Courier' and type='Next Day Delivery' and lowerl=@rt )                          
end                                
                                                                     
set @flag1 = 0                                                                    
set @flag2 = 0                                        
set @flag3 = 0        
set @flag4 = 0                                                                              
set @str =null                                                                         
                                                                   
select note='RECORD ADDED SUCCESSFULLY                                  ' into #temp                                                                
                                                                
 set @cnt4=(select count(company) from courier_rates(nolock) where company=ltrim(rtrim(@company)))      
 if @cnt4=0                                                                                
begin                                                                                
 set @str = 'Entered Company name '''+@company+''' is Wrong or Not Exist'                                                                                
 set @flag4 = 1                                                                 
 update #temp set note=@str                                                                
 select * from #temp                                                                
 return                                                                
end                                                   
                                                                
set @cnt2 = (select count(client_code) from delivered(nolock)where client_code=ltrim(rtrim(@client_code)))                                                               
if @cnt2>0                                                                            
 begin                                                                                
          
 set @str = 'KIT IS ALREADY DISPATCHED.'                                                
 set @flag2 = 1                                     
                        
 update #temp set note=@str                                                     
 select * from #temp              
                                                                 
 return                               
end                                                                     
                                                                
set @cnt1 = (select count(cl_code) from temp_offlinemaster(nolock)where convert(varchar(11),tdate,21) = convert(datetime,@I_date) and cl_code=ltrim(rtrim(@client_code)))                                                         
if @cnt1=0                                                                                
begin                                                                                
 set @str = 'CLIENT IS NOT INVOKED ON GIVEN DATE'                                                                                
 set @flag1 = 1                                                                
 update #temp set note=@str                                                                
 select * from #temp                                                                
 return                                                                
end                                                                                
                                                                   
                                                                      
set @cnt3 = (select count(pod) from delivered(nolock)where convert(varchar,pod)=convert(varchar,@pod) and cour_compn_name=@company)             
if @cnt3>0                                                                                
begin                                                                                
 set @str = 'POD No. ALREADY EXISTS. '                                                                                
 set @flag3 = 1                                                                 
 update #temp set note=@str                                                       
 select * from #temp                                                                
 return                                                                
end       
      
      
                                                                      
                                                                                
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0 and @flag4=0                                                                       
begin                                                                                
 select @branch_cd=branch_cd, @name=long_name, @sb_code=sub_broker from temp_offlinemaster(nolock)                                                                                
 where cl_code=@client_code          
                                                                              
 declare @type varchar(50)                                                                                
 declare @cost numeric(10,2)                                           
 declare @weight varchar(100)                                                                 
           
           
 set @type = (select top 1 type from courier_rates(nolock) where company=@company and default_flag=1 )                                                                        
 set @cost = (select top 1 rate from courier_rates(nolock) where company=@company and type=@type order by lowerl)                                                                                
 set @weight = convert(varchar,(select top 1 lowerl from courier_rates(nolock) where company=@company and type=@type order by lowerl)) + '-' +                                                                                
   convert(varchar,(select top 1 upperl from courier_rates(nolock) where company=@company and type=@type order by lowerl))                                  
          
--select @name as name, @branch_cd as branch_cd, @sb_code as sb_code into #temp                                                
--select * from #temp                                                
--return                                                
                                
if  @company='Mid Way Courier'                                                                            
begin                       
set @weight='0-250'                              
set @cost='12.50'                              
end                              
                             
if  @company='Professional Courier'                                                                            
begin                              
set @weight='0-250'                              
set @cost='15.00'                              
end                              
                          
if @company ='Vichare Courier'                          
begin                          
set @weight=@rt + @rt1                        
end                          
                        
                          
if @company ='Vichare Courier'                          
if @weight='0-100'                        
begin                        
set @cost='7.50'                        
end                              
                         
if @company ='Vichare Courier'                          
if @weight='0-250'                        
begin                        
set @cost='15.00'                        
end                    
                  
if @company ='Trackon Courier'                          
if @weight='0-250'                        
begin                        
set @cost='14.00'                        
end             
                       
 if @company ='ON DOT'                          
if @weight='0-250'                        
begin                        
set @cost='15.00'                        
END            
            
if @company='Shree Maruti Courier'            
 if @weight='0-250'                  
begin                        
set @cost='15.00'                        
END            
                               
 if @company='ZENS EXPRESS'            
 if @weight='0-250'                        
begin                        
set @cost='12.50'                        
END                        
                        
                          
/* if @rt1='100'                          
begin      insert into delivered values                                                                                
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,@company,@cost1,@branch_cd,'PEN','NO')                                                                          
end                          
                          
if @rt1='250'    begin                          
insert into delivered values                                                                                
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,@company,@cost2,@branch_cd,'PEN','NO')                                                                          
end                        
*/                          
          
                          
insert into delivered values                                                                                
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,ltrim(rtrim(@company)),@cost,@branch_cd,'PEN','NO')                                                                          
                              
delete from temp_offlinemaster where cl_code = @client_code                                                                          
                                                                 
 select * from #temp                                                            
 return                                                                
                                                                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_delivered_details_new
-- --------------------------------------------------
CREATE proc insert_delivered_details_new                    
(                                                  
@client_code varchar(20),                                                  
@pod varchar(20),                                                  
@company varchar(100),                                                  
@I_date varchar(11),                                          
@D_date varchar(11)          
)                                                  
as                                                  
declare @name varchar(100)                                                  
declare @branch_cd varchar(20)                                                  
declare @sb_code varchar(20)                                                  
declare @cnt1 numeric(5)                                                  
declare @cnt2 numeric(5)                                          
declare @cnt3 numeric(5)                                          
declare @flag1 numeric(1)                                                  
declare @flag2 numeric(1)                                          
declare @flag3 numeric(1)                                          
declare @str varchar(50)                                           
                                                  
set @flag1 = 0                                                  
set @flag2 = 0                                                  
set @flag3 = 0                                                  
set @str = ''                                               
                                     
select note='RECORD ADDED SUCCESSFULLY                                      ' into #temp                                  
                                  
                                  
                                  
set @cnt2 = (select count(client_code) from delivered(nolock)where client_code=@client_code)                                                  
if @cnt2>0                                                   
begin                                                  
 set @str = 'KIT IS ALREADY DISPATCHED. '                                  
 set @flag2 = 1                                   
 update #temp set note=@str                                  
 select * from #temp                                  
 return                                  
end                                       
                                  
set @cnt1 = (select count(cl_code) from temp_offlinemaster(nolock)where convert(varchar(11),tdate,21) = convert(datetime,@I_date) and cl_code=@client_code)                                                  
if @cnt1=0                                                  
begin                                                  
 set @str = 'CLIENT IS NOT INVOKED ON GIVEN DATE'                                                  
 set @flag1 = 1                                  
 update #temp set note=@str                                  
 select * from #temp                                  
 return                                  
end                                                  
                                     
                                        
set @cnt3 = (select count(pod) from delivered(nolock)where convert(varchar,pod)=convert(varchar,@pod) and cour_compn_name=@company)                                                  
if @cnt3>0                                                  
begin                                                  
 set @str = 'POD no. ALREADY EXISTS. '                                                  
 set @flag3 = 1                                   
 update #temp set note=@str                                  
 select * from #temp                                  
 return                                  
end                                                  
                                                  
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0                                          
begin                                                  
 select @branch_cd=branch_cd, @name=long_name, @sb_code=sub_broker from temp_offlinemaster(nolock)                                                  
 where cl_code=@client_code                                                  
 declare @type varchar(50)                                                  
 declare @cost numeric(10,2)                                                  
 declare @weight varchar(100)                                   
 set @type = (select distinct(type) from courier_rates(nolock)where company=@company and default_flag=1)                                          
 set @cost = (select top 1 rate from courier_rates(nolock)where company=@company and type=@type order by lowerl)                                                  
 set @weight = convert(varchar,(select top 1 lowerl from courier_rates(nolock)where company=@company and type=@type order by lowerl)) + '-' +                                                  
   convert(varchar,(select top 1 upperl from courier_rates(nolock)where company=@company and type=@type order by lowerl))                                                  
--select @name as name, @branch_cd as branch_cd, @sb_code as sb_code into #temp                  
--select * from #temp                  
--return                  
                                                 
 insert into delivered values                                                  
 (@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,@company,@cost,@branch_cd,'PEN','NO')                                            
 delete from temp_offlinemaster where cl_code = @client_code                                            
                                   
 select * from #temp                              
 return                                  
                                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_delivered_details1
-- --------------------------------------------------
CREATE proc insert_delivered_details1  
(                          
@client_code varchar(20),                          
@pod varchar(20),                          
@company varchar(100),                          
@I_date datetime,                  
@D_date datetime                  
)                          
as                          
declare @name varchar(100)                          
declare @branch_cd varchar(20)                          
declare @sb_code varchar(20)                          
declare @cnt1 numeric(5)                          
declare @cnt2 numeric(5)                  
declare @cnt3 numeric(5)                  
declare @flag1 numeric(1)                          
declare @flag2 numeric(1)                  
declare @flag3 numeric(1)                  
declare @str varchar(50)                   
                          
set @flag1 = 0                          
set @flag2 = 0                          
set @flag3 = 0                          
set @str = ''                       
             
select note='RECORD ADDED SUCCESSFULLY                                    ' into #temp          
          
          
          
set @cnt2 = (select count(client_code) from delivered1 where client_code=@client_code)                          
if @cnt2>0                           
begin                          
 set @str = 'KIT IS ALREADY DISPATCHED. '          
 set @flag2 = 1           
 update #temp set note=@str          
 select * from #temp          
 return          
end               
          
set @cnt1 = (select count(cl_code) from temp_offlinemaster1 where tdate like @I_date and cl_code=@client_code)                          
if @cnt1=0                          
begin                          
 set @str = 'CLIENT IS NOT INVOKED ON GIVEN DATE'                          
 set @flag1 = 1          
 --insert into #temp values(@str)          
 update #temp set note=@str          
 select * from #temp          
 return          
end                          
             
                
set @cnt3 = (select count(pod) from delivered1 where convert(varchar,pod)=convert(varchar,@pod) and cour_compn_name=@company)                          
if @cnt3>0                          
begin                          
 set @str = 'POD no. ALREADY EXISTS. '                          
 set @flag3 = 1           
 update #temp set note=@str          
 select * from #temp          
 return          
end                          
                          
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0                  
begin                          
 select @branch_cd=branch_cd, @name=long_name, @sb_code=sub_broker from temp_offlinemaster1                          
 where cl_code=@client_code                          
 declare @type varchar(50)                          
 declare @cost numeric(10,2)                          
 declare @weight varchar(100)                          
 set @type = (select distinct(type) from courier_rates where company=@company and default_flag=1)                          
 set @cost = (select top 1 rate from courier_rates where company=@company and type=@type order by lowerl)                          
 set @weight = convert(varchar,(select top 1 lowerl from courier_rates where company=@company and type=@type order by lowerl)) + '-' +                          
   convert(varchar,(select top 1 upperl from courier_rates where company=@company and type=@type order by lowerl))                          
 --declare @cid as numeric(30)                          
 --set @cid = (select max(courier_id)+1 from delivered)                          
 insert into delivered1 values                          
 (@client_code,@name,@sb_code,@D_date,@pod,'COURIER',@type,@weight,@company,@cost,@branch_cd,'NO','YES')                    
 delete from temp_offlinemaster1 where cl_code = @client_code                    
           
 select * from #temp          
 return          
          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_delivered_detailsfortest
-- --------------------------------------------------
CREATE proc insert_delivered_detailsfortest                                                    
(                                                                              
@client_code varchar(20),                                                                              
@pod varchar(20),                                                                              
@company varchar(100),                                                                              
@I_date varchar(11),                                                                      
@D_date varchar(11),                            
@wt varchar(50),                             
@wt1 varchar(50)                                    
)                                                                              
as                                                                              
declare @name varchar(100)                                                                              
declare @branch_cd varchar(20)                                                                              
declare @sb_code varchar(20)                                                                              
declare @cnt1 numeric(5)                                                                              
declare @cnt2 numeric(5)                                                                      
declare @cnt3 numeric(5)       
declare @cnt4 numeric(5)                                                                   
declare @flag1 numeric(1)                                                                              
declare @flag2 numeric(1)                                                                      
declare @flag3 numeric(1)    
declare @flag4 numeric(1)                                                                       
declare @str varchar(100)                            
declare @rt varchar(50)                          
declare @rt1 varchar(50)                        
declare @cost1 varchar(50)                          
declare @cost2 varchar(50)                         
                        
Set @client_code=ltrim(rtrim(@client_code))                                                                          
Set @pod=ltrim(rtrim(@pod))                                                                            
Set @company=ltrim(rtrim(@company))                                                                             
Set @I_date=ltrim(rtrim(@I_date))        
Set @D_date=ltrim(rtrim(@D_date))        
Set @wt=ltrim(rtrim(@wt))                          
Set @wt1=ltrim(rtrim(@wt1))        
                        
                               
if(@company = 'Vichare Courier')                        
/*                        
set @weight = convert(varchar,(select lowerl from courier_rates(nolock)where company=@company and lowerl=@wt order by lowerl)) + '-' +                                                                              
convert(varchar,(select upperl from courier_rates(nolock)where company=@company and upperl=@wt1 order by lowerl))                                                                              
*/                        
                        
                        
--set @rt = (Select * from courier_rates where company = 'Vichare Courier' and lowerl = @wt and upperl = @wt1)                        
                        
set @rt = (select lowerl from courier_rates(nolock) where company = 'Vichare Courier' and lowerl = @wt)                        
set @rt1 = (select upperl from courier_rates(nolock) where company = 'Vichare Courier' and upperl = @wt1)                        
                        
                        
if @rt1='100'                        
begin                        
set @cost1 = (select  rate from courier_rates(nolock)where company='Vichare Courier' and type='Next Day Delivery' and upperl=@rt1 )                        
end                        
                        
if @rt1='250'                        
begin          
set @cost2 = (select  rate from courier_rates(nolock)where company='Vichare Courier' and type='Next Day Delivery' and lowerl=@rt )                        
end                              
                                                                   
set @flag1 = 0                                                                  
set @flag2 = 0                                      
set @flag3 = 0      
set @flag4 = 0                                                                            
set @str =null                                                                       
                                                                 
select note='RECORD ADDED SUCCESSFULLY                                  ' into #temp                                                              
                                                              
 set @cnt4=(select count(company) from courier_rates(nolock) where company=ltrim(rtrim(@company)))    
 if @cnt4=0                                                                              
begin                                                                              
 set @str = 'Entered Company name '''+@company+''' is Wrong or Not Exist'                                                                              
 set @flag4 = 1                                                               
 update #temp set note=@str                                                              
 select * from #temp                                                              
 return                                                              
end                                                 
                                                              
set @cnt2 = (select count(client_code) from delivered(nolock)where client_code=ltrim(rtrim(@client_code)))                                                             
if @cnt2>0                                                                          
 begin                                                                              
        
 set @str = 'KIT IS ALREADY DISPATCHED.'                                              
 set @flag2 = 1                                   
                      
 update #temp set note=@str                                                   
 select * from #temp            
                                                               
 return                             
end                                                                   
                                                              
set @cnt1 = (select count(cl_code) from temp_offlinemaster(nolock)where convert(varchar(11),tdate,21) = convert(datetime,@I_date) and cl_code=ltrim(rtrim(@client_code)))                                                       
if @cnt1=0                                                                              
begin                                                                              
 set @str = 'CLIENT IS NOT INVOKED ON GIVEN DATE'                                                                              
 set @flag1 = 1                                                              
 update #temp set note=@str                                                              
 select * from #temp                                                              
 return                                                              
end                                                                              
                                                                 
                                                                    
set @cnt3 = (select count(pod) from delivered(nolock)where convert(varchar,pod)=convert(varchar,@pod) and cour_compn_name=@company)                                                                              
if @cnt3>0                                                                              
begin                                                                              
 set @str = 'POD No. ALREADY EXISTS. '                                                                              
 set @flag3 = 1                                                               
 update #temp set note=@str                                                     
 select * from #temp                                                              
 return                                                              
end     
    
    
                                                                    
                                                                              
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0 and @flag4=0                                                                     
begin                                                                              
 select @branch_cd=branch_cd, @name=long_name, @sb_code=sub_broker from temp_offlinemaster(nolock)                                                                              
 where cl_code=@client_code        
                                                                            
 declare @type varchar(50)                                                                              
 declare @cost numeric(10,2)                                         
 declare @weight varchar(100)                                                               
         
         
 set @type = (select top 1 type from courier_rates(nolock) where company=@company and default_flag=1 )                                                                      
 set @cost = (select top 1 rate from courier_rates(nolock) where company=@company and type=@type order by lowerl)                                                                              
 set @weight = convert(varchar,(select top 1 lowerl from courier_rates(nolock) where company=@company and type=@type order by lowerl)) + '-' +                                                                              
   convert(varchar,(select top 1 upperl from courier_rates(nolock) where company=@company and type=@type order by lowerl))                                
        
--select @name as name, @branch_cd as branch_cd, @sb_code as sb_code into #temp                                              
--select * from #temp                                              
--return                                              
                              
if  @company='Mid Way Courier'                                                                          
begin                     
set @weight='0-250'                            
set @cost='12.50'                            
end                            
                           
if  @company='Professional Courier'                                                                          
begin                            
set @weight='0-250'                            
set @cost='15.00'                            
end                            
                        
if @company ='Vichare Courier'                        
begin                        
set @weight=@rt + @rt1                      
end                        
                      
                        
if @company ='Vichare Courier'                        
if @weight='0-100'                      
begin                      
set @cost='7.50'                      
end                            
                       
if @company ='Vichare Courier'                        
if @weight='0-250'                      
begin                      
set @cost='15.00'                      
end                  
                
if @company ='Trackon Courier'                        
if @weight='0-250'                      
begin                      
set @cost='14.00'                      
end           
                     
 if @company ='ON DOT'                        
if @weight='0-250'                      
begin                      
set @cost='15.00'                      
END          
          
if @company='Shree Maruti Courier'          
 if @weight='0-250'                
begin                      
set @cost='15.00'                      
END          
                             
 if @company='ZENS EXPRESS'          
 if @weight='0-250'                      
begin                      
set @cost='12.50'                      
END                      
                      
                        
/* if @rt1='100'                        
begin      insert into delivered values                                                                              
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,@company,@cost1,@branch_cd,'PEN','NO')                                                                        
end                        
                        
if @rt1='250'    begin                        
insert into delivered values                                                                              
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,@company,@cost2,@branch_cd,'PEN','NO')                                                                        
end                      
*/                        
        
                        
insert into delivered values                                                                              
(@client_code,@name,@sb_code,convert(datetime,@D_date),@pod,'COURIER',@type,@weight,ltrim(rtrim(@company)),@cost,@branch_cd,'PEN','NO')                                                                        
                            
delete from temp_offlinemaster where cl_code = @client_code                                                                        
                                                               
 select * from #temp                                                          
 return                                                              
                                                              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_undelivered_details
-- --------------------------------------------------
CREATE proc insert_undelivered_details                     
(                                            
@client_code varchar(20),                                            
@rdate datetime,                          
@reason varchar(50)                          
)                                            
as                                            
declare @remark varchar(500)                                            
declare @branch_cd varchar(20)                                            
declare @action varchar(20)                            
declare @sb_code varchar(20)                                            
declare @name varchar(20)                          
declare @send_to varchar(30)                          
declare @cnt1 numeric(5)                                            
declare @cnt2 numeric(5)                                    
declare @cnt3 numeric(5)                                    
declare @cnt4 numeric(5)                                    
declare @flag1 numeric(1)                                            
declare @flag2 numeric(1)                                    
declare @flag3 numeric(1)                                    
declare @flag4 numeric(1)                                   
declare @str varchar(50)                                     
                                            
set @flag1 = 0                                            
set @flag2 = 0                                            
set @flag3 = 0                              
set @flag4 = 0                        
set @str = ''                                         
                               
select note='RECORD ADDED SUCCESSFULLY                                    ' into #temp                            
                            
          
set @cnt1 = (select count(client_code) from delivered(nolock)where client_code=@client_code)                                            
if @cnt1=0                                             
begin                                            
 set @str = 'KIT IS NOT DISPATCHED YET.'                            
 set @flag1 = 1                             
 update #temp set note=@str                            
 select note from #temp                            
 return                            
end                                 
                            
set @cnt2 = (select count(client_code) from undelivered(nolock)where client_code=@client_code)                                            
if @cnt2>0                                            
begin                                            
 set @str = 'KIT IS ALREADY RETURNED TO BRANCH OR SUB-BROKER.'                          
 set @flag2 = 1                            
 update #temp set note=@str                            
 select note from #temp                            
 return                            
end                                            
                          
set @cnt3 = (select count(pod) from delivered(nolock)where dispatch_date<=@rdate and client_code = @client_code)                          
if @cnt3=0                                            
begin                                            
 set @str = 'KIT CANNOT BE RETURNED BEFORE DISPATCH.'                       
 set @flag3 = 1                             
 update #temp set note=@str                            
 select note from #temp                            
 return                            
end                                            
          
set @cnt4 = (select count(*) from return_remarks(nolock)where reason = @reason)          
if @cnt4=0                                            
begin                                            
 set @str = 'INVALID STATUS.'          
 set @flag4 = 1                             
 update #temp set note=@str                            
 select note from #temp                            
 return                            
end            
                  
                                            
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0 and @flag4 = 0          
begin                                            
                          
 select @branch_cd=branch_cd, @name=client_name, @sb_code=sb_code from delivered(nolock)                          
 where client_code=@client_code                                            
                
if @branch_cd = 'ACM' or @branch_cd = 'HO'                          
begin                          
 set @action = 'SEND TO '+upper(@branch_cd)+'-'+upper(@sb_code)             
 set @send_to = (select top 1 name from risk.dbo.subbrokers(nolock)where sub_broker like '%'+@sb_code+'%')                          
end                          
else                          
begin                          
 set @action = 'SEND TO '+upper(@branch_cd)                
 set @send_to = (select top 1 branch from risk.dbo.branch_details(nolock)where branch_code like '%'+@branch_cd+'%')                          
end                          
                          
                          
set @remark = (select top 1 remark from return_remarks(nolock)where reason = @reason)                          
                          
 insert into undelivered values                                            
 (@client_code,@name,@sb_code,@branch_cd,@rdate,@reason,@action,@send_to,@remark,'YES','')                          
 update delivered set delivered = 'NO' where client_code = @client_code                  
                             
 select note from #temp                    
 return                           
                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insert_undelivered_details1
-- --------------------------------------------------
CREATE proc insert_undelivered_details1    
(                          
@client_code varchar(20),                          
@rdate datetime,        
@reason varchar(50)        
)                          
as                          
declare @remark varchar(500)                          
declare @branch_cd varchar(20)                          
declare @action varchar(20)          
declare @sb_code varchar(20)                          
declare @name varchar(20)        
declare @send_to varchar(30)        
declare @cnt1 numeric(5)                          
declare @cnt2 numeric(5)                  
declare @cnt3 numeric(5)                  
declare @flag1 numeric(1)                          
declare @flag2 numeric(1)                  
declare @flag3 numeric(1)                  
declare @str varchar(50)                   
                          
set @flag1 = 0                          
set @flag2 = 0                          
set @flag3 = 0                          
set @str = ''                       
             
select note='RECORD ADDED SUCCESSFULLY!!                                    ' into #temp          
          
         
set @cnt1 = (select count(client_code) from delivered1 where client_code=@client_code)                          
if @cnt1=0                           
begin                          
 set @str = 'KIT IS NOT DISPATCHED YET.'          
 set @flag1 = 1           
 update #temp set note=@str          
 select * from #temp          
 return          
end               
          
set @cnt2 = (select count(client_code) from undelivered1 where client_code=@client_code)                          
if @cnt2>0                          
begin                          
 set @str = 'KIT IS ALREADY RETURNED TO BRANCH OR SUB-BROKER.'        
 set @flag2 = 1          
 update #temp set note=@str          
 select * from #temp          
 return          
end                          
        
set @cnt3 = (select count(pod) from delivered1 where dispatch_date<=@rdate and client_code = @client_code)        
if @cnt3=0                          
begin                          
 set @str = 'KIT CANNOT BE RETURNED BEFORE DISPATCH.'        
 set @flag3 = 1           
 update #temp set note=@str          
 select * from #temp          
 return          
end                          
                          
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0                  
begin                          
        
 select @branch_cd=branch_cd, @name=client_name, @sb_code=sb_code from delivered1        
 where client_code=@client_code                          
        
if @branch_cd = 'ACM' or @branch_cd = 'HO'        
begin        
 set @action = 'SEND TO SUB-BROKER'        
 set @send_to = (select name from risk.dbo.subbrokers where sub_broker like '%'+@sb_code+'%')        
end        
else        
begin        
 set @action = 'SEND TO BRANCH'        
 set @send_to = (select branch from risk.dbo.branch_details where branch_code like '%'+@branch_cd+'%')        
end        
        
        
set @remark = (select remark from return_remarks where reason = @reason)        
        
 insert into undelivered1 values                          
 (@client_code,@name,@sb_code,@branch_cd,@rdate,@reason,@action,@send_to,@remark,'YES')        
update delivered1 set delivered = 'NO' where client_code = @client_code
           
 select * from #temp          
 return         
        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_balanceshit
-- --------------------------------------------------
create procedure kyc_balanceshit(@edt as varchar(25))
as
set nocount on 
	declare @dispatch_date datetime
--	declare @seg varchar(10)
--	declare @branch_cd varchar(10)
--	declare @to_dt datetime
--	declare @fr_dt datetime
--	declare @challan_no varchar(10)
	declare @rem_bal numeric(10)
	declare @curr_bal numeric(10)
	declare @disp_bal numeric(10)
	declare @remian_bal numeric(10)
	declare @openbal numeric(10)
	declare @rejbal numeric(10)
	--set @dispatch_date = '2007-07-09 00:00:00.000'
	--set @seg = 'BSE'
	--set @branch_cd = 'ACM'
	--set @r_fd = '2007-07-09 00:00:00.000'
	--set @r_td = '2007-07-09 00:00:00.000'
	
	
	DECLARE CURSOR1 CURSOR FOR
	
		select convert(int,bseqty) as disp_bal,dispatch_date from kyc_form_entry 
		where dispatch_date=@edt
	OPEN CURSOR1                        
	                          
	FETCH NEXT FROM CURSOR1                           
	INTO @disp_bal,@dispatch_date
	--,@Provision_amt  
	
	WHILE @@FETCH_STATUS = 0                          
	BEGIN 
	
	set @rem_bal=(select remain_bal from balance_form1)
	set @openbal=(select openbal from balance_form1 )
	set @rejbal=(select rejected from balance_form1 )
	
	
	if  @rem_bal> 0 
	begin 
	delete from balance_form1
	
	--insert into balance_form1
	--select top 1 edt=getdate(),a.receive_date,challan_no,remark,Openbal=@rem_bal,
	--rejected=@rejbal,dispatch_date=a.receive_date,@disp_bal,remian_bal=(Openbal-@rejbal-@disp_bal)
	--from balance_form a 
	--where  receive_date='nov 30 2007'
	
	--insert into balance_form1
	--select edt=getdate(),a.receive_date,challan_no,remark,Openbal=min(Openbal),
	--rejected=min(rejected),dispatch_date=a.receive_date,disp_bal=@disp_bal,min(remain_bal)
	--from balance_form a 
	--group by receive_date,challan_no,remark,dispatch_date
	
	
--	if @rejbal>0 
	--begin
--	insert into balance_form1
--	select top 1 edt=getdate(),a.receive_date,challan_no,remark,Openbal=@rem_bal,
	--rejected=0,dispatch_date=@dispatch_date,disp_bal=@disp_bal,remain_bal=@rem_bal-0-@disp_bal
--	from balance_form a 
	--group by receive_date,challan_no,remark,dispatch_date
--	end
--	if @rejbal=0
--	begin


	insert into balance_form1
	select top 1 edt=getdate(),a.receive_date,challan_no,remark,Openbal=@rem_bal,
	rejected=@rejbal,dispatch_date=@dispatch_date,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal
	from balance_form a 
	
--	end 
	
	insert into balance_form
	select * from balance_form1

	update balance_form1 set rejected=0	
	
	set @rem_bal=@openbal-@rejbal-@disp_bal
	set @rejbal=0
	
	end 
	
	if  @rem_bal<= 0 
	begin
	delete from balance_form1
	
	insert into balance_form1 
	select edt=getdate(),a.receive_date,challan_no,remark,Openbal,
	rejected,dispatch_date=a.receive_date,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal
	from recv_form a where receive_date=@edt
	
	insert into balance_form
	select * from balance_form1

	update balance_form1 set rejected=0	
	
	--set @rem_bal=@openbal-@rejbal-@disp_bal
	set @rejbal=0
	
	end 
	
	FETCH FROM CURSOR1                           
	INTO @disp_bal,@dispatch_date
	
	END
	close CURSOR1
	deallocate CURSOR1
	
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_bsebal
-- --------------------------------------------------
CREATE procedure kyc_bsebal (@edt as varchar(25),@seg as varchar(10))                            
as                            
set nocount on                            
declare @dispatch_date datetime                              
declare @remark2 varchar(20)                              
 declare @rem_bal numeric(10)                              
 declare @curr_bal numeric(10)                              
 declare @disp_bal numeric(10)                              
 declare @remian_bal numeric(10)                              
 declare @openbal numeric(10)                              
 declare @rejbal numeric(10)      
declare @challan_no varchar(38)    
declare @edt1 datetime                   
--declare @orgbal  numeric(10)                            
 --set @dispatch_date = '2007-07-09 00:00:00.000'                              
 --set @seg = 'BSE'                              
 --set @branch_cd = 'ACM'                              
 --set @r_fd = '2007-07-09 00:00:00.000'                              
 --set @r_td = '2007-07-09 00:00:00.000'                              
                               
 --set @orgbal = (select remain_bal from balance_form1 where segment=@seg)                          
 DECLARE CURSOR1 CURSOR FOR                              
                               
  select convert(int,bseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry(nolock)                               
  where dispatch_date=@edt  and BSE='y'  and status='10'                          
 OPEN CURSOR1                                                      
                                                         
 FETCH NEXT FROM CURSOR1                                                         
 INTO @disp_bal,@remark2,@dispatch_date                              
                               
 WHILE @@FETCH_STATUS = 0                                                        
 BEGIN                               
             print @disp_bal                
/*print @remark2              
print @dispatch_date  */              
              
 set @rem_bal=(select remain_bal from balance_form1(nolock) where segment=@seg)                              
 set @openbal=(select openbal from balance_form1(nolock)where segment=@seg)                              
 set @rejbal=(select rejected from balance_form1(nolock)where segment=@seg)     
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg)     
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                              
             
                               
 if  @rem_bal> 0                               
 begin                               
 delete from balance_form1  where segment=@seg                            
                               
            
print @openbal            
print @disp_bal               
print @rem_bal                      
--end                     
                            
                              
insert into balance_form1                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                              
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_qty=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                              
 from balance_form a (nolock)where segment=@seg                            
                               
                               
 insert into balance_form                              
 select * from balance_form1  where segment=@seg                            
                              
 update balance_form1 set rejected=0  where segment=@seg                               
                              
 set @rem_bal=@openbal-@rejbal-@disp_bal                              
 set @rejbal=0            
print @openbal            
print @disp_bal               
print @rem_bal                          
                              
 end               
                               
 if  @rem_bal<= 0                               
 begin                              
 delete from balance_form1 where segment=@seg                            
                               
 insert into balance_form1                               
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                              
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                              
 from recv_form_new a (nolock)where receive_date=@edt and segment=@seg                            
                               
 insert into balance_form                              
 select * from balance_form1 (nolock)where segment=@seg                            
                              
 update balance_form1 set rejected=0  where segment=@seg                               
                    
 set @rejbal=0                              
                               
 end                               
                               
 FETCH FROM CURSOR1                        
 INTO @disp_bal,@remark2,@dispatch_date                              
                               
 END             
            
                            
 close CURSOR1                              
 deallocate CURSOR1                              
                      
  --update kyc_form_entry set status='11'  where BSE='Y'                            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_bsebal_new
-- --------------------------------------------------
CREATE procedure kyc_bsebal_new(@edt as varchar(25),@seg as varchar(10))                          
as                          
set nocount on                          
declare @dispatch_date datetime                            
declare @remark2 varchar(20)                            
 declare @rem_bal numeric(10)                            
 declare @curr_bal numeric(10)                            
 declare @disp_bal numeric(10)                            
 declare @remian_bal numeric(10)                            
 declare @openbal numeric(10)                            
 declare @rejbal numeric(10)    
declare @challan_no varchar(38)  
declare @edt1 datetime                 
--declare @orgbal  numeric(10)                          
 --set @dispatch_date = '2007-07-09 00:00:00.000'                            
 --set @seg = 'BSE'                            
 --set @branch_cd = 'ACM'                            
 --set @r_fd = '2007-07-09 00:00:00.000'                            
 --set @r_td = '2007-07-09 00:00:00.000'                            
                             
 --set @orgbal = (select remain_bal from balance_form1 where segment=@seg)                        
 DECLARE CURSOR1 CURSOR FOR                            
                             
  select convert(int,bseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new(nolock)                             
  where dispatch_date=@edt  and BSE='y'  and status='10'                        
 OPEN CURSOR1                                                    
                                                       
 FETCH NEXT FROM CURSOR1                                                       
 INTO @disp_bal,@remark2,@dispatch_date                            
                             
 WHILE @@FETCH_STATUS = 0                                                      
 BEGIN                             
             print @disp_bal              
/*print @remark2            
print @dispatch_date  */            
            
 set @rem_bal=(select remain_bal from balance_form1_new(nolock) where segment=@seg)                            
 set @openbal=(select openbal from balance_form1_new(nolock)where segment=@seg)                            
 set @rejbal=(select rejected from balance_form1_new(nolock)where segment=@seg)   
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                            
           
                             
 if  @rem_bal> 0                             
 begin                             
 delete from balance_form1_new  where segment=@seg                          
                             
          
print @openbal          
print @disp_bal             
print @rem_bal                    
--end                   
                          
                            
insert into balance_form1_new              
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                            
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_qty=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                            
 from balance_form_new a (nolock)where segment=@seg                          
                             
                             
 insert into balance_form_new                            
 select * from balance_form1_new  where segment=@seg                          
                            
 update balance_form1_new set rejected=0  where segment=@seg                             
                            
 set @rem_bal=@openbal-@rejbal-@disp_bal                            
 set @rejbal=0          
print @openbal          
print @disp_bal             
print @rem_bal                        
                            
 end                             
                             
 if  @rem_bal<= 0                             
 begin                            
 delete from balance_form1_new where segment=@seg                          
                             
 insert into balance_form1_new                             
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                            
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                            
 from recv_form_new a (nolock)where receive_date=@edt and segment=@seg                          
                             
 insert into balance_form_new                            
 select * from balance_form1_new (nolock)where segment=@seg                          
                            
 update balance_form1_new set rejected=0  where segment=@seg                             
                  
 set @rejbal=0                            
                             
 end                             
                             
 FETCH FROM CURSOR1                      
 INTO @disp_bal,@remark2,@dispatch_date                            
                             
 END           
          
                          
 close CURSOR1                            
 deallocate CURSOR1                            
                    
  --update kyc_form_entry_new set status='11'  where BSE='Y'                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_bsebal_new1
-- --------------------------------------------------
CREATE procedure kyc_bsebal_new1(@edt as varchar(25),@seg as varchar(10))                                
as                                
set nocount on                                
declare @dispatch_date datetime                                  
declare @remark2 varchar(20)                                  
 declare @rem_bal numeric(10)                                  
 declare @curr_bal numeric(10)                                  
 declare @disp_bal numeric(10)                                  
 declare @remian_bal numeric(10)                                  
 declare @openbal numeric(10)                                  
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)
declare @edt1 datetime          
--declare @orgbal  numeric(10)                                
 --set @dispatch_date = '2007-07-09 00:00:00.000'                                  
 --set @seg = 'BSE'                                  
 --set @branch_cd = 'ACM'                                  
 --set @r_fd = '2007-07-09 00:00:00.000'                                  
 --set @r_td = '2007-07-09 00:00:00.000'                                  
                                   
 --set @orgbal = (select remain_bal from balance_form1 where segment=@seg)                              
 DECLARE CURSOR1 CURSOR FOR                                  
                                   
  select convert(int,bseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry(nolock)                                   
  where dispatch_date=@edt  and BSE='y'  and status='10'                              
 OPEN CURSOR1                                                          
                                                             
 FETCH NEXT FROM CURSOR1                                                             
 INTO @disp_bal,@remark2,@dispatch_date                                  
                                   
 WHILE @@FETCH_STATUS = 0                                                            
 BEGIN                                   
             print @disp_bal                    
/*print @remark2                  
print @dispatch_date  */                  
                  
 set @rem_bal=(select remain_bal from balance_form1(nolock) where segment=@seg)                                  
 set @openbal=(select openbal from balance_form1(nolock)where segment=@seg)                                  
 set @rejbal=(select rejected from balance_form1(nolock)where segment=@seg)                                  
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg) 

 --update balance_form set challan_no=@challan_no where edt=@edt1 and segment=@seg      
                                   
 if  @rem_bal> 0                                   
 begin                                   
 delete from balance_form1  where segment=@seg                                
                                   
                
print @openbal                
print @disp_bal                   
print @rem_bal                          
--end                         
                                
                                  
insert into balance_form1                    
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                                  
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_qty=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                                  
 from balance_form a (nolock)where segment=@seg   
                                   
                                   
 insert into balance_form                                  
 select * from balance_form1  where segment=@seg                                
                                  
 update balance_form1 set rejected=0  where segment=@seg                                   
                                  
 set @rem_bal=@openbal-@rejbal-@disp_bal                                  
 set @rejbal=0                
print @openbal                
print @disp_bal                   
print @rem_bal                              
                                  
 end                                   
           
 if  @rem_bal<= 0                                   
 begin                                  
 delete from balance_form1 where segment=@seg                                
                                   
 insert into balance_form1              
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,               
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                                  
 from recv_form a (nolock)where receive_date=@edt and segment=@seg                                
                                   
 insert into balance_form                                  
 select * from balance_form1 (nolock)where segment=@seg                                
                                  
 update balance_form1 set rejected=0  where segment=@seg                                   
                        
 set @rejbal=0                                  
                                   
 end                                   
                                   
 FETCH FROM CURSOR1                            
 INTO @disp_bal,@remark2,@dispatch_date                                  
                                   
 END                 
                
                                
 close CURSOR1                                  
 deallocate CURSOR1                                  
                          
  --update kyc_form_entry set status='11'  where BSE='Y'                                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_currencyderivatives_new
-- --------------------------------------------------
create procedure kyc_currencyderivatives_new(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)      
declare @challan_no varchar(38)    
declare @edt1 datetime                     
                                         
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,dpcoprateqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new                 
  where dispatch_date=@edt  and currencyderivatives='y' and status='10'      
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)                
 set @openbal=(select openbal from balance_form1_new where segment=@seg)                
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)     
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)     
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)       
    
               
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1_new  where segment=@seg              
                 
                
                
 insert into balance_form1_new                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form_new a    where segment=@seg              
                 
                 
 insert into balance_form_new                
 select * from balance_form1_new  where segment=@seg              
                
 update balance_form1_new set rejected=0 where segment=@seg                  
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1_new  where segment=@seg              
                 
 insert into balance_form1_new                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form_new a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form_new                
 select * from balance_form1_new where segment=@seg               
                
 update balance_form1_new set rejected=0 where segment=@seg                  
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1         
      
    --update kyc_form_entry_new set status='11' where dpcoprate='Y'          
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcommobal
-- --------------------------------------------------
CREATE procedure kyc_dpcommobal(@edt as varchar(25),@seg as varchar(10))      
as      
set nocount on      
      
declare @dispatch_date datetime        
 declare @rem_bal numeric(10)        
declare @remark2 varchar(20)      
 declare @curr_bal numeric(10)        
 declare @disp_bal numeric(10)        
 declare @remian_bal numeric(10)        
 declare @openbal numeric(10)        
 declare @rejbal numeric(10)        
         
         
 DECLARE CURSOR1 CURSOR FOR        
         
  select convert(int,dpcommoqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry         
  where dispatch_date=@edt  and dpcommo='y'      
 OPEN CURSOR1                                
                                   
 FETCH NEXT FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 WHILE @@FETCH_STATUS = 0                                  
 BEGIN         
         
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)        
 set @openbal=(select openbal from balance_form1 where segment=@seg)        
 set @rejbal=(select rejected from balance_form1 where segment=@seg)        
         
         
 if  @rem_bal> 0         
 begin         
 delete from balance_form1  where segment=@seg      
         
        
        
 insert into balance_form1        
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,        
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal        
 from balance_form a    where segment=@seg      
         
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0 where segment=@seg        
         
 set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 if  @rem_bal<= 0         
 begin        
 delete from balance_form1  where segment=@seg      
         
 insert into balance_form1         
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,        
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal        
 from recv_form a where receive_date=@edt and segment=@seg       
         
 insert into balance_form        
 select * from balance_form1 where segment=@seg       
        
 update balance_form1 set rejected=0 where segment=@seg        
         
 --set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 FETCH FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 END        
 close CURSOR1        
 deallocate CURSOR1        
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcommobal_new
-- --------------------------------------------------
CREATE procedure kyc_dpcommobal_new(@edt as varchar(25),@seg as varchar(10))            
as            
set nocount on            
            
declare @dispatch_date datetime              
 declare @rem_bal numeric(10)              
declare @remark2 varchar(20)            
 declare @curr_bal numeric(10)              
 declare @disp_bal numeric(10)              
 declare @remian_bal numeric(10)              
 declare @openbal numeric(10)              
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)  
declare @edt1 datetime                
               
               
 DECLARE CURSOR1 CURSOR FOR              
               
  select convert(int,dpcommoqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new               
  where dispatch_date=@edt  and dpcommo='y' and status='10'           
 OPEN CURSOR1                                      
                                         
 FETCH NEXT FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 WHILE @@FETCH_STATUS = 0                                        
 BEGIN               
               
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)              
 set @openbal=(select openbal from balance_form1_new where segment=@seg)              
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)  
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                   
               
               
 if  @rem_bal> 0               
 begin               
 delete from balance_form1_new  where segment=@seg            
               
              
              
 insert into balance_form1_new              
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,              
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal              
 from balance_form_new a    where segment=@seg            
               
               
 insert into balance_form_new             
 select * from balance_form1_new  where segment=@seg            
              
 update balance_form1_new set rejected=0 where segment=@seg              
               
 set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 if  @rem_bal<= 0               
 begin              
 delete from balance_form1_new  where segment=@seg            
               
 insert into balance_form1_new               
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,              
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal              
 from recv_form_new a where receive_date=@edt and segment=@seg             
               
 insert into balance_form_new              
 select * from balance_form1_new where segment=@seg             
              
 update balance_form1_new set rejected=0 where segment=@seg              
               
 --set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 FETCH FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 END              
 close CURSOR1              
 deallocate CURSOR1         
    
     --update kyc_form_entry_new set status='11' where dpcommo='Y'     
               
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcommobal_new1
-- --------------------------------------------------
CREATE procedure kyc_dpcommobal_new1(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)
declare @challan_no varchar(38)
declare @edt1 datetime                 
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,dpcommoqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and dpcommo='y' and status='10'             
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                
 set @openbal=(select openbal from balance_form1 where segment=@seg)                
 set @rejbal=(select rejected from balance_form1 where segment=@seg)
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                 
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1  where segment=@seg              
                 
                
                
 insert into balance_form1                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form a    where segment=@seg              
                 
                 
 insert into balance_form               
 select * from balance_form1  where segment=@seg              
                
 update balance_form1 set rejected=0 where segment=@seg                
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1  where segment=@seg              
                 
 insert into balance_form1                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form                
 select * from balance_form1 where segment=@seg               
                
 update balance_form1 set rejected=0 where segment=@seg                
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1           
      
     --update kyc_form_entry set status='11' where dpcommo='Y'       
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcopratebal
-- --------------------------------------------------
CREATE procedure kyc_dpcopratebal(@edt as varchar(25),@seg as varchar(10))      
as      
set nocount on      
      
declare @dispatch_date datetime        
 declare @rem_bal numeric(10)        
declare @remark2 varchar(20)      
 declare @curr_bal numeric(10)        
 declare @disp_bal numeric(10)        
 declare @remian_bal numeric(10)        
 declare @openbal numeric(10)        
 declare @rejbal numeric(10)        
         
         
 DECLARE CURSOR1 CURSOR FOR        
         
  select convert(int,dpcoprateqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry         
  where dispatch_date=@edt  and dpcoprate='y'      
 OPEN CURSOR1                                
                                   
 FETCH NEXT FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 WHILE @@FETCH_STATUS = 0                                  
 BEGIN         
         
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)        
 set @openbal=(select openbal from balance_form1 where segment=@seg)        
 set @rejbal=(select rejected from balance_form1 where segment=@seg)        
         
         
 if  @rem_bal> 0         
 begin         
 delete from balance_form1  where segment=@seg      
         
        
        
 insert into balance_form1        
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,        
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal        
 from balance_form a    where segment=@seg      
         
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0 where segment=@seg          
         
 set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 if  @rem_bal<= 0         
 begin        
 delete from balance_form1  where segment=@seg      
         
 insert into balance_form1         
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,        
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal        
 from recv_form a where receive_date=@edt and segment=@seg       
         
 insert into balance_form        
 select * from balance_form1 where segment=@seg       
        
 update balance_form1 set rejected=0 where segment=@seg          
         
 --set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 FETCH FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 END        
 close CURSOR1        
 deallocate CURSOR1        
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcopratebal_new
-- --------------------------------------------------
CREATE procedure kyc_dpcopratebal_new(@edt as varchar(25),@seg as varchar(10))            
as            
set nocount on            
            
declare @dispatch_date datetime              
 declare @rem_bal numeric(10)              
declare @remark2 varchar(20)            
 declare @curr_bal numeric(10)              
 declare @disp_bal numeric(10)              
 declare @remian_bal numeric(10)              
 declare @openbal numeric(10)              
 declare @rejbal numeric(10)    
declare @challan_no varchar(38)  
declare @edt1 datetime                   
                                       
               
               
 DECLARE CURSOR1 CURSOR FOR              
               
  select convert(int,dpcoprateqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new               
  where dispatch_date=@edt  and dpcoprate='y' and status='10'    
 OPEN CURSOR1                                      
                                         
 FETCH NEXT FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 WHILE @@FETCH_STATUS = 0                                        
 BEGIN               
               
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)              
 set @openbal=(select openbal from balance_form1_new where segment=@seg)              
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)   
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)     
  
             
               
               
 if  @rem_bal> 0               
 begin               
 delete from balance_form1_new  where segment=@seg            
               
              
              
 insert into balance_form1_new              
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,              
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal              
 from balance_form_new a    where segment=@seg            
               
               
 insert into balance_form_new              
 select * from balance_form1_new  where segment=@seg            
              
 update balance_form1_new set rejected=0 where segment=@seg                
               
 set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 if  @rem_bal<= 0               
 begin              
 delete from balance_form1_new  where segment=@seg            
               
 insert into balance_form1_new               
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,              
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal              
 from recv_form_new a where receive_date=@edt and segment=@seg             
               
 insert into balance_form_new              
 select * from balance_form1_new where segment=@seg             
              
 update balance_form1_new set rejected=0 where segment=@seg                
               
 --set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 FETCH FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 END              
 close CURSOR1              
 deallocate CURSOR1       
    
    --update kyc_form_entry_new set status='11' where dpcoprate='Y'        
               
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpcopratebal_new1
-- --------------------------------------------------
CREATE procedure kyc_dpcopratebal_new1(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)    
declare @challan_no varchar(38)
declare @edt1 datetime             
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,dpcoprateqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and dpcoprate='y' and status='10'      
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                
 set @openbal=(select openbal from balance_form1 where segment=@seg)                
 set @rejbal=(select rejected from balance_form1 where segment=@seg) 
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)               
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1  where segment=@seg              
                 
                
                
 insert into balance_form1                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form a    where segment=@seg              
                 
                 
 insert into balance_form                
 select * from balance_form1  where segment=@seg              
                
 update balance_form1 set rejected=0 where segment=@seg                  
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1  where segment=@seg              
                 
 insert into balance_form1                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form                
 select * from balance_form1 where segment=@seg               
                
 update balance_form1 set rejected=0 where segment=@seg                  
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1         
      
    --update kyc_form_entry set status='11' where dpcoprate='Y'          
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpindbal
-- --------------------------------------------------
CREATE procedure kyc_dpindbal(@edt as varchar(25),@seg as varchar(10))        
as        
set nocount on        
        
declare @dispatch_date datetime          
 declare @rem_bal numeric(10)          
declare @remark2 varchar(20)        
 declare @curr_bal numeric(10)          
 declare @disp_bal numeric(10)          
 declare @remian_bal numeric(10)          
 declare @openbal numeric(10)          
 declare @rejbal numeric(10)          
           
           
 DECLARE CURSOR1 CURSOR FOR          
           
  select convert(int,dpindqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry           
  where dispatch_date=@edt  and dpind='y'        
 OPEN CURSOR1                                  
                                     
 FETCH NEXT FROM CURSOR1                                     
 INTO @disp_bal,@remark2,@dispatch_date          
           
 WHILE @@FETCH_STATUS = 0                                    
 BEGIN           
           
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)          
 set @openbal=(select openbal from balance_form1 where segment=@seg)          
 set @rejbal=(select rejected from balance_form1 where segment=@seg)          
           
           
 if  @rem_bal> 0           
 begin           
 delete from balance_form1  where segment=@seg        
           
          
          
 insert into balance_form1          
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,          
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal          
 from balance_form a    where segment=@seg        
           
           
 insert into balance_form          
 select * from balance_form1  where segment=@seg        
          
 update balance_form1 set rejected=0 where segment=@seg           
           
 set @rem_bal=@openbal-@rejbal-@disp_bal          
 set @rejbal=0          
           
 end           
           
 if  @rem_bal<= 0           
 begin          
 delete from balance_form1  where segment=@seg        
           
 insert into balance_form1           
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,          
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal          
 from recv_form a where receive_date=@edt and segment=@seg         
           
 insert into balance_form          
 select * from balance_form1 where segment=@seg         
          
 update balance_form1 set rejected=0 where segment=@seg           
           
 --set @rem_bal=@openbal-@rejbal-@disp_bal          
 set @rejbal=0          
           
 end           
           
 FETCH FROM CURSOR1                                     
 INTO @disp_bal,@remark2,@dispatch_date          
           
 END          
 close CURSOR1          
 deallocate CURSOR1          
        

--select * from balance_form where segment=@seg and edt=@edt
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpindbal_NEW
-- --------------------------------------------------
CREATE procedure kyc_dpindbal_NEW(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)  
declare @edt1 datetime                   
                                  
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,dpindqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new                 
  where dispatch_date=@edt  and dpind='y' and status='10'              
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)                
 set @openbal=(select openbal from balance_form1_new where segment=@seg)                
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)                
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                       
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1_new  where segment=@seg              
                 
                
                
 insert into balance_form1_new                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form_new a    where segment=@seg              
                 
                 
 insert into balance_form_new               
 select * from balance_form1_new  where segment=@seg              
                
 update balance_form1_new set rejected=0 where segment=@seg                 
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1_new  where segment=@seg              
                 
 insert into balance_form1_new                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form_new a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form_new                
 select * from balance_form1_new where segment=@seg               
                
 update balance_form1_new set rejected=0 where segment=@seg                 
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1                
              
  --update kyc_form_entry_new set status='11' where dpind='Y'     
--select * from balance_form where segment=@seg and edt=@edt      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_dpindbal_NEW1
-- --------------------------------------------------
CREATE procedure kyc_dpindbal_NEW1(@edt as varchar(25),@seg as varchar(10))                
as                
set nocount on                
                
declare @dispatch_date datetime                  
 declare @rem_bal numeric(10)                  
declare @remark2 varchar(20)                
 declare @curr_bal numeric(10)                  
 declare @disp_bal numeric(10)                  
 declare @remian_bal numeric(10)                  
 declare @openbal numeric(10)                  
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)
declare @edt1 datetime                 
                   
                   
 DECLARE CURSOR1 CURSOR FOR                  
                   
  select convert(int,dpindqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                   
  where dispatch_date=@edt  and dpind='y' and status='10'                
 OPEN CURSOR1                                          
                                             
 FETCH NEXT FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 WHILE @@FETCH_STATUS = 0                                            
 BEGIN                   
                   
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                  
 set @openbal=(select openbal from balance_form1 where segment=@seg)                  
 set @rejbal=(select rejected from balance_form1 where segment=@seg) 
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                  
                   
                   
 if  @rem_bal> 0                   
 begin                   
 delete from balance_form1  where segment=@seg                
                   
                  
                  
 insert into balance_form1                  
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                  
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                  
 from balance_form a    where segment=@seg                
                   
                   
 insert into balance_form                 
 select * from balance_form1  where segment=@seg                
                  
 update balance_form1 set rejected=0 where segment=@seg                   
                   
 set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 if  @rem_bal<= 0                   
 begin                  
 delete from balance_form1  where segment=@seg                
                   
 insert into balance_form1                   
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                  
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                  
 from recv_form a where receive_date=@edt and segment=@seg                 
                   
 insert into balance_form                  
 select * from balance_form1 where segment=@seg                 
                  
 update balance_form1 set rejected=0 where segment=@seg                   
                   
 --set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 FETCH FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 END                  
 close CURSOR1                  
 deallocate CURSOR1                  
                
  --update kyc_form_entry set status='11' where dpind='Y'       
--select * from balance_form where segment=@seg and edt=@edt        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_fobal
-- --------------------------------------------------
CREATE procedure kyc_fobal(@edt as varchar(25),@seg as varchar(10))      
as      
set nocount on      
declare @dispatch_date datetime        
declare @remark2 varchar(20)        
 declare @rem_bal numeric(10)        
 declare @curr_bal numeric(10)        
 declare @disp_bal numeric(10)        
 declare @remian_bal numeric(10)        
 declare @openbal numeric(10)        
 declare @rejbal numeric(10)        
         
         
 DECLARE CURSOR1 CURSOR FOR        
         
  select convert(int,foqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry         
  where dispatch_date=@edt  and FO='y'      
 OPEN CURSOR1                                
                                   
 FETCH NEXT FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 WHILE @@FETCH_STATUS = 0                                  
 BEGIN         
         
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)        
 set @openbal=(select openbal from balance_form1 where segment=@seg)        
 set @rejbal=(select rejected from balance_form1 where segment=@seg)        
         
         
 if  @rem_bal> 0         
 begin         
 delete from balance_form1  where segment=@seg      
         
        
        
 insert into balance_form1        
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,        
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal        
 from balance_form a    where segment=@seg      
         
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0  where segment=@seg         
         
 set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 if  @rem_bal<= 0         
 begin        
 delete from balance_form1  where segment=@seg      
         
 insert into balance_form1         
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,        
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal        
 from recv_form a where receive_date=@edt and segment=@seg      
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0  where segment=@seg         
         
 set @rejbal=0        
         
 end         
         
 FETCH FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 END        
 close CURSOR1        
 deallocate CURSOR1        
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_fobal_new
-- --------------------------------------------------
CREATE procedure kyc_fobal_new(@edt as varchar(25),@seg as varchar(10))          
as          
set nocount on          
declare @dispatch_date datetime            
declare @remark2 varchar(20)            
 declare @rem_bal numeric(10)            
 declare @curr_bal numeric(10)            
 declare @disp_bal numeric(10)            
 declare @remian_bal numeric(10)            
 declare @openbal numeric(10)            
 declare @rejbal numeric(10) 
declare @challan_no varchar(38)
declare @edt1 datetime               
             
             
 DECLARE CURSOR1 CURSOR FOR            
             
  select convert(int,foqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new             
  where dispatch_date=@edt  and FO='y' and status='10'         
 OPEN CURSOR1                                    
                                       
 FETCH NEXT FROM CURSOR1                                       
 INTO @disp_bal,@remark2,@dispatch_date            
             
 WHILE @@FETCH_STATUS = 0                                      
 BEGIN             
             
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)            
 set @openbal=(select openbal from balance_form1_new where segment=@seg)            
 set @rejbal=(select rejected from balance_form1_new where segment=@seg) 
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)              
             
             
 if  @rem_bal> 0             
 begin             
 delete from balance_form1_new  where segment=@seg          
             
            
            
 insert into balance_form1_new            
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,            
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal            
 from balance_form_new a    where segment=@seg          
             
             
 insert into balance_form_new            
 select * from balance_form1_new  where segment=@seg          
            
 update balance_form1_new set rejected=0  where segment=@seg             
             
 set @rem_bal=@openbal-@rejbal-@disp_bal            
 set @rejbal=0            
             
 end             
             
 if  @rem_bal<= 0             
 begin            
 delete from balance_form1_new  where segment=@seg          
             
 insert into balance_form1_new             
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,            
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal            
 from recv_form_new a where receive_date=@edt and segment=@seg          
             
 insert into balance_form_new            
 select * from balance_form1_new  where segment=@seg          
            
 update balance_form1_new set rejected=0  where segment=@seg             
             
 set @rejbal=0            
             
 end             
             
 FETCH FROM CURSOR1                                       
 INTO @disp_bal,@remark2,@dispatch_date            
             
 END            
 close CURSOR1            
 deallocate CURSOR1     
  
--update kyc_form_entry_new set status='11' where FO='Y'         
             
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_fobal_new1
-- --------------------------------------------------
CREATE procedure kyc_fobal_new1(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
declare @dispatch_date datetime                
declare @remark2 varchar(20)                
 declare @rem_bal numeric(10)                
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)
declare @edt1 datetime                       
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,foqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and FO='y' and status='10'             
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                
 set @openbal=(select openbal from balance_form1 where segment=@seg)                
 set @rejbal=(select rejected from balance_form1 where segment=@seg)
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                 
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1  where segment=@seg              
                 
                
                
 insert into balance_form1                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form a    where segment=@seg              
                 
                 
 insert into balance_form                
 select * from balance_form1  where segment=@seg              
                
 update balance_form1 set rejected=0  where segment=@seg                 
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1  where segment=@seg              
                 
 insert into balance_form1                 
 select edt=getdate(),Segment,a.receive_date,challan_no=@challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form a where receive_date=@edt and segment=@seg              
                 
 insert into balance_form                
 select * from balance_form1  where segment=@seg              
                
 update balance_form1 set rejected=0  where segment=@seg                 
                 
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1         
      
--update kyc_form_entry set status='11' where FO='Y'             
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_MCXbal
-- --------------------------------------------------
CREATE procedure kyc_MCXbal(@edt as varchar(25),@seg as varchar(10))      
as      
set nocount on      
      
declare @dispatch_date datetime        
 declare @rem_bal numeric(10)        
declare @remark2 varchar(20)      
 declare @curr_bal numeric(10)        
 declare @disp_bal numeric(10)        
 declare @remian_bal numeric(10)        
 declare @openbal numeric(10)        
 declare @rejbal numeric(10)        
         
         
 DECLARE CURSOR1 CURSOR FOR        
         
  select convert(int,MCXqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry         
  where dispatch_date=@edt  and MCX='y'      
 OPEN CURSOR1                                
                                   
 FETCH NEXT FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 WHILE @@FETCH_STATUS = 0                                  
 BEGIN         
         
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)        
 set @openbal=(select openbal from balance_form1 where segment=@seg)        
 set @rejbal=(select rejected from balance_form1 where segment=@seg)        
         
         
 if  @rem_bal> 0         
 begin         
 delete from balance_form1  where segment=@seg      
         
        
        
 insert into balance_form1        
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,        
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal        
 from balance_form a    where segment=@seg      
         
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0  where segment=@seg           
         
 set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 if  @rem_bal<= 0         
 begin        
 delete from balance_form1  where segment=@seg      
         
 insert into balance_form1         
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,        
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal        
 from recv_form a where receive_date=@edt and segment=@seg       
         
 insert into balance_form        
 select * from balance_form1 where segment=@seg       
        
 update balance_form1 set rejected=0  where segment=@seg            
         
 --set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 FETCH FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 END        
 close CURSOR1        
 deallocate CURSOR1        
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_MCXbal_new
-- --------------------------------------------------
CREATE procedure kyc_MCXbal_new(@edt as varchar(25),@seg as varchar(10))            
as            
set nocount on            
            
declare @dispatch_date datetime              
 declare @rem_bal numeric(10)              
declare @remark2 varchar(20)            
 declare @curr_bal numeric(10)              
 declare @disp_bal numeric(10)              
 declare @remian_bal numeric(10)              
 declare @openbal numeric(10)              
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)  
declare @edt1 datetime         
             
               
               
 DECLARE CURSOR1 CURSOR FOR              
               
  select convert(int,MCXqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new               
  where dispatch_date=@edt  and MCX='y'  and status='10'          
 OPEN CURSOR1                                      
                                         
 FETCH NEXT FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 WHILE @@FETCH_STATUS = 0                                        
 BEGIN               
               
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)              
 set @openbal=(select openbal from balance_form1_new where segment=@seg)              
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)   
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                     
               
               
 if  @rem_bal> 0               
 begin               
 delete from balance_form1_new  where segment=@seg            
               
              
              
 insert into balance_form1_new              
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,              
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal              
 from balance_form_new a    where segment=@seg            
               
               
 insert into balance_form_new              
 select * from balance_form1_new  where segment=@seg            
              
 update balance_form1_new set rejected=0  where segment=@seg                 
               
 set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 if  @rem_bal<= 0               
 begin              
 delete from balance_form1_new  where segment=@seg            
               
 insert into balance_form1_new               
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,              
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal              
 from recv_form_new a where receive_date=@edt and segment=@seg             
               
 insert into balance_form_new              
 select * from balance_form1_new where segment=@seg             
              
 update balance_form1_new set rejected=0  where segment=@seg                  
               
 --set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 FETCH FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 END              
 close CURSOR1              
 deallocate CURSOR1         
    
--update kyc_form_entry_new set status='11' where MCX='Y'         
               
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_MCXbal_new1
-- --------------------------------------------------
CREATE procedure kyc_MCXbal_new1(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)                
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,MCXqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and MCX='y'  and status='10'            
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form where segment=@seg)                
 set @openbal=(select openbal from balance_form where segment=@seg)                
 set @rejbal=(select rejected from balance_form where segment=@seg)                
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form  where segment=@seg              
                 
                
                
 insert into balance_form                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form a  where segment=@seg              
                 
                 
 insert into balance_form                
 select * from balance_form  where segment=@seg              
                
 update balance_form set rejected=0  where segment=@seg                   
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form  where segment=@seg              
                 
 insert into balance_form                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form                
 select * from balance_form where segment=@seg               
                
 update balance_form set rejected=0  where segment=@seg                    
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1           
      
--update kyc_form_entry set status='11' where MCX='Y'           
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_MCXbal_new2
-- --------------------------------------------------
CREATE procedure kyc_MCXbal_new2(@edt as varchar(25),@seg as varchar(10))                
as                
set nocount on                
                
declare @dispatch_date datetime                  
declare @rem_bal numeric(10)                  
declare @remark2 varchar(20)                
declare @curr_bal numeric(10)                  
declare @disp_bal numeric(10)                  
declare @remian_bal numeric(10)                  
declare @openbal numeric(10)                  
declare @rejbal numeric(10)
declare @challan_no varchar(38)
declare @edt1 datetime                   
                   
                   
 DECLARE CURSOR1 CURSOR FOR                  
                   
  select convert(int,ncdxqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                   
  where dispatch_date=@edt  and ncdx='y' and status='10'        
 OPEN CURSOR1                                          
                                             
 FETCH NEXT FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 WHILE @@FETCH_STATUS = 0                                            
 BEGIN                   
                   
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                  
 set @openbal=(select openbal from balance_form1 where segment=@seg)                  
 set @rejbal=(select rejected from balance_form1 where segment=@seg) 
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                  
                   
                   
 if  @rem_bal> 0                   
 begin                   
 delete from balance_form1  where segment=@seg                
                   
                  
                  
 insert into balance_form1                  
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                  
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                  
 from balance_form a  where segment=@seg                
                   
                   
 insert into balance_form                  
 select * from balance_form1  where segment=@seg                
                  
 update balance_form1 set rejected=0 where segment=@seg                  
                   
 set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 if  @rem_bal<= 0                   
 begin                  
 delete from balance_form1  where segment=@seg                
                   
 insert into balance_form1                   
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                  
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                  
 from recv_form a where receive_date=@edt and segment=@seg                 
                   
 insert into balance_form                  
 select * from balance_form1 where segment=@seg                 
                  
 update balance_form1 set rejected=0  where segment=@seg                 
                   
 --set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 FETCH FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 END                  
 close CURSOR1                  
 deallocate CURSOR1             
        
--update kyc_form_entry set status='11' where NCDX='Y'              
                   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_mutualfund_new
-- --------------------------------------------------
CREATE procedure kyc_mutualfund_new(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)      
declare @challan_no varchar(38)    
declare @edt1 datetime                     
                                         
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,dpcoprateqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new                 
  where dispatch_date=@edt  and mutualfund='y' and status='10'      
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)                
 set @openbal=(select openbal from balance_form1_new where segment=@seg)                
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)     
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)     
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)       
    
               
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1_new  where segment=@seg              
                 
                
                
 insert into balance_form1_new                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form_new a    where segment=@seg              
                 
                 
 insert into balance_form_new                
 select * from balance_form1_new  where segment=@seg              
                
 update balance_form1_new set rejected=0 where segment=@seg                  
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1_new  where segment=@seg              
                 
 insert into balance_form1_new                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form_new a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form_new                
 select * from balance_form1_new where segment=@seg               
                
 update balance_form1_new set rejected=0 where segment=@seg                  
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1         
      
    --update kyc_form_entry_new set status='11' where dpcoprate='Y'          
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_ncdxbal
-- --------------------------------------------------
CREATE procedure kyc_ncdxbal(@edt as varchar(25),@seg as varchar(10))      
as      
set nocount on      
      
declare @dispatch_date datetime        
 declare @rem_bal numeric(10)        
declare @remark2 varchar(20)      
 declare @curr_bal numeric(10)        
 declare @disp_bal numeric(10)        
 declare @remian_bal numeric(10)        
 declare @openbal numeric(10)        
 declare @rejbal numeric(10)        
         
         
 DECLARE CURSOR1 CURSOR FOR        
         
  select convert(int,ncdxqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry         
  where dispatch_date=@edt  and ncdx='y'      
 OPEN CURSOR1                                
                                   
 FETCH NEXT FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 WHILE @@FETCH_STATUS = 0                                  
 BEGIN         
         
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)        
 set @openbal=(select openbal from balance_form1 where segment=@seg)        
 set @rejbal=(select rejected from balance_form1 where segment=@seg)        
         
         
 if  @rem_bal> 0         
 begin         
 delete from balance_form1  where segment=@seg      
         
        
        
 insert into balance_form1        
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no,remark1,Openbal=@rem_bal,        
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal        
 from balance_form a    where segment=@seg      
         
         
 insert into balance_form        
 select * from balance_form1  where segment=@seg      
        
 update balance_form1 set rejected=0 where segment=@seg        
         
 set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 if  @rem_bal<= 0         
 begin        
 delete from balance_form1  where segment=@seg      
         
 insert into balance_form1         
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,        
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal        
 from recv_form a where receive_date=@edt and segment=@seg       
         
 insert into balance_form        
 select * from balance_form1 where segment=@seg       
        
 update balance_form1 set rejected=0  where segment=@seg       
         
 --set @rem_bal=@openbal-@rejbal-@disp_bal        
 set @rejbal=0        
         
 end         
         
 FETCH FROM CURSOR1                                   
 INTO @disp_bal,@remark2,@dispatch_date        
         
 END        
 close CURSOR1        
 deallocate CURSOR1        
         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_ncdxbal_NEW
-- --------------------------------------------------
CREATE procedure kyc_ncdxbal_NEW(@edt as varchar(25),@seg as varchar(10))            
as            
set nocount on            
            
declare @dispatch_date datetime              
 declare @rem_bal numeric(10)              
declare @remark2 varchar(20)            
 declare @curr_bal numeric(10)              
 declare @disp_bal numeric(10)              
 declare @remian_bal numeric(10)              
 declare @openbal numeric(10)              
 declare @rejbal numeric(10)   
declare @challan_no varchar(38)  
declare @edt1 datetime                
               
               
 DECLARE CURSOR1 CURSOR FOR              
               
  select convert(int,ncdxqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new               
  where dispatch_date=@edt  and ncdx='y' and status='10'    
 OPEN CURSOR1                                      
                                         
 FETCH NEXT FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 WHILE @@FETCH_STATUS = 0                                        
 BEGIN               
               
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)              
 set @openbal=(select openbal from balance_form1_new where segment=@seg)              
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)  
 set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)   
 set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                 
               
               
 if  @rem_bal> 0               
 begin               
 delete from balance_form1_new  where segment=@seg            
               
              
              
 insert into balance_form1_new              
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,              
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal              
 from balance_form_new a    where segment=@seg            
               
               
 insert into balance_form_new              
 select * from balance_form1_new  where segment=@seg            
              
 update balance_form1_new set rejected=0 where segment=@seg              
               
 set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 if  @rem_bal<= 0               
 begin              
 delete from balance_form1_new  where segment=@seg            
               
 insert into balance_form1_new               
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,              
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal              
 from recv_form_new a where receive_date=@edt and segment=@seg             
               
 insert into balance_form_new              
 select * from balance_form1_new where segment=@seg             
              
 update balance_form1_new set rejected=0  where segment=@seg             
               
 --set @rem_bal=@openbal-@rejbal-@disp_bal              
 set @rejbal=0              
               
 end               
               
 FETCH FROM CURSOR1                                         
 INTO @disp_bal,@remark2,@dispatch_date              
               
 END              
 close CURSOR1              
 deallocate CURSOR1         
    
--update kyc_form_entry_new set status='11' where NCDX='Y'          
               
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_ncdxbal_NEW1
-- --------------------------------------------------
CREATE procedure kyc_ncdxbal_NEW1(@edt as varchar(25),@seg as varchar(10))              
as              
set nocount on              
              
declare @dispatch_date datetime                
 declare @rem_bal numeric(10)                
declare @remark2 varchar(20)              
 declare @curr_bal numeric(10)                
 declare @disp_bal numeric(10)                
 declare @remian_bal numeric(10)                
 declare @openbal numeric(10)                
 declare @rejbal numeric(10)  
declare @challan_no varchar(38)
declare @edt1 datetime               
                 
                 
 DECLARE CURSOR1 CURSOR FOR                
                 
  select convert(int,ncdxqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and ncdx='y' and status='10'      
 OPEN CURSOR1                                        
                                           
 FETCH NEXT FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 WHILE @@FETCH_STATUS = 0                                          
 BEGIN                 
                 
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                
 set @openbal=(select openbal from balance_form1 where segment=@seg)                
 set @rejbal=(select rejected from balance_form1 where segment=@seg)
 set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                 
                 
                 
 if  @rem_bal> 0                 
 begin                 
 delete from balance_form1  where segment=@seg              
                 
                
                
 insert into balance_form1                
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                
 from balance_form a    where segment=@seg              
                 
                 
 insert into balance_form                
 select * from balance_form1  where segment=@seg              
                
 update balance_form1 set rejected=0 where segment=@seg                
                 
 set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 if  @rem_bal<= 0                 
 begin                
 delete from balance_form1  where segment=@seg              
                 
 insert into balance_form1                 
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                
 from recv_form a where receive_date=@edt and segment=@seg               
                 
 insert into balance_form                
 select * from balance_form1 where segment=@seg               
                
 update balance_form1 set rejected=0  where segment=@seg               
                 
 --set @rem_bal=@openbal-@rejbal-@disp_bal                
 set @rejbal=0                
                 
 end                 
                 
 FETCH FROM CURSOR1                                           
 INTO @disp_bal,@remark2,@dispatch_date                
                 
 END                
 close CURSOR1                
 deallocate CURSOR1           
      
--update kyc_form_entry set status='11' where NCDX='Y'            
                 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_nsebal
-- --------------------------------------------------
CREATE procedure kyc_nsebal(@edt as varchar(25),@seg as varchar(10))                          
as                          
set nocount on                          
                          
declare @dispatch_date datetime                            
 declare @rem_bal numeric(10)                            
declare @remark2 varchar(20)                          
 declare @curr_bal numeric(10)                            
 declare @disp_bal numeric(10)                            
 declare @remian_bal numeric(10)                            
 declare @openbal numeric(10)                            
 declare @rejbal numeric(10)                
declare @challan_no varchar(38)              
--declare @edt1 datetime                
                           
                             
                             
 DECLARE CURSOR1 CURSOR FOR                            
                             
  select convert(int,nseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                             
  where dispatch_date=@edt  and NSE='y'  and  status='10'                        
 OPEN CURSOR1                                                    
                                                       
 FETCH NEXT FROM CURSOR1                                                       
 INTO @disp_bal,@remark2,@dispatch_date                            
                             
 WHILE @@FETCH_STATUS = 0                                                      
 BEGIN                             
                             
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                            
 set @openbal=(select openbal from balance_form1 where segment=@seg)                            
 set @rejbal=(select rejected from balance_form1 where segment=@seg)              
  set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg)               
 --set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                                       
                             
                             
 if  @rem_bal> 0                             
 begin                             
 delete from balance_form1  where segment=@seg                          
                             
                            
                            
 insert into balance_form1                            
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                            
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                            
 from balance_form a  where segment=@seg                          
                             
                             
 insert into balance_form                            
 select * from balance_form1  where segment=@seg                          
                            
 update balance_form1 set rejected=0  where segment=@seg                              
                             
 set @rem_bal=@openbal-@rejbal-@disp_bal                            
 set @rejbal=0                            
                             
 end                             
                             
 if  @rem_bal<= 0                             
 begin                            
 delete from balance_form1  where segment=@seg                          
                             
 insert into balance_form1                             
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                            
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                            
 from recv_form_new a where receive_date=@edt and segment=@seg                           
                             
 insert into balance_form                            
 select * from balance_form1 where segment=@seg                           
                            
 update balance_form1 set rejected=0 where segment=@seg                               
                            
 --set @rem_bal=@openbal-@rejbal-@disp_bal                            
 set @rejbal=0                            
                   
 end                             
                             
 FETCH FROM CURSOR1                                                       
 INTO @disp_bal,@remark2,@dispatch_date                            
                             
 END                            
 close CURSOR1                            
 deallocate CURSOR1                        
           
--update kyc_form_entry set status='11' where NSE='Y'                        
                             
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_nsebal_new
-- --------------------------------------------------
CREATE procedure kyc_nsebal_new(@edt as varchar(25),@seg as varchar(10))                        
as                        
set nocount on                        
                        
declare @dispatch_date datetime                          
 declare @rem_bal numeric(10)                          
declare @remark2 varchar(20)                        
 declare @curr_bal numeric(10)                          
 declare @disp_bal numeric(10)                          
 declare @remian_bal numeric(10)                          
 declare @openbal numeric(10)                          
 declare @rejbal numeric(10)              
declare @challan_no varchar(38)            
--declare @edt1 datetime              
                         
                           
                           
 DECLARE CURSOR1 CURSOR FOR                          
                           
  select convert(int,nseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry_new                           
  where dispatch_date=@edt  and NSE='y'  and  status='10'                      
 OPEN CURSOR1                                                  
                                                     
 FETCH NEXT FROM CURSOR1                                                     
 INTO @disp_bal,@remark2,@dispatch_date                          
                           
 WHILE @@FETCH_STATUS = 0                                                    
 BEGIN                           
                           
 set @rem_bal=(select remain_bal from balance_form1_new where segment=@seg)                          
 set @openbal=(select openbal from balance_form1_new where segment=@seg)                          
 set @rejbal=(select rejected from balance_form1_new where segment=@seg)            
  set @challan_no=(select challan_no from balance_form1_new(nolock)where segment=@seg)             
 --set @edt1=(select edt from balance_form1_new(nolock)where segment=@seg)                                     
                           
                           
 if  @rem_bal> 0                           
 begin                           
 delete from balance_form1_new  where segment=@seg                        
                           
                          
                          
 insert into balance_form1_new                          
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                          
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                          
 from balance_form_new a  where segment=@seg                        
                           
                           
 insert into balance_form_new                          
 select * from balance_form1_new  where segment=@seg                        
                          
 update balance_form1_new set rejected=0  where segment=@seg                            
                           
 set @rem_bal=@openbal-@rejbal-@disp_bal                          
 set @rejbal=0                          
                           
 end                           
                           
 if  @rem_bal<= 0                           
 begin                          
 delete from balance_form1_new  where segment=@seg                        
                           
 insert into balance_form1_new                           
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                          
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                          
 from recv_form_new a where receive_date=@edt and segment=@seg                         
                           
 insert into balance_form_new                          
 select * from balance_form1_new where segment=@seg                         
                          
 update balance_form1_new set rejected=0 where segment=@seg                             
                          
 --set @rem_bal=@openbal-@rejbal-@disp_bal                          
 set @rejbal=0                          
                 
 end                           
                           
 FETCH FROM CURSOR1                                                     
 INTO @disp_bal,@remark2,@dispatch_date                          
                           
 END                          
 close CURSOR1                          
 deallocate CURSOR1                      
         
--update kyc_form_entry_new set status='11' where NSE='Y'                      
                           
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.kyc_nsebal_new1
-- --------------------------------------------------
CREATE procedure kyc_nsebal_new1(@edt as varchar(25),@seg as varchar(10))                
as                
set nocount on                
                
declare @dispatch_date datetime                  
 declare @rem_bal numeric(10)                  
declare @remark2 varchar(20)                
 declare @curr_bal numeric(10)                  
 declare @disp_bal numeric(10)                  
 declare @remian_bal numeric(10)                  
 declare @openbal numeric(10)                  
 declare @rejbal numeric(10)
declare @challan_no varchar(38)
declare @edt1 datetime                         
                   
                   
 DECLARE CURSOR1 CURSOR FOR                  
                   
  select convert(int,nseqty) as disp_bal,remark as remark2,dispatch_date from kyc_form_entry                 
  where dispatch_date=@edt  and NSE='y'  and  status='10'              
 OPEN CURSOR1                                          
                                             
 FETCH NEXT FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 WHILE @@FETCH_STATUS = 0                                            
 BEGIN                   
                   
 set @rem_bal=(select remain_bal from balance_form1 where segment=@seg)                  
 set @openbal=(select openbal from balance_form1 where segment=@seg)                  
 set @rejbal=(select rejected from balance_form1 where segment=@seg)  
set @challan_no=(select challan_no from balance_form1(nolock)where segment=@seg) 
 set @edt1=(select edt from balance_form1(nolock)where segment=@seg)                 
                   
                   
 if  @rem_bal> 0                   
 begin                   
 delete from balance_form1  where segment=@seg                
                   
                  
                  
 insert into balance_form1               
 select top 1 edt=getdate(),Segment,receive_date=convert(datetime,@edt),challan_no=@challan_no,remark1,Openbal=@rem_bal,                  
 rejected=@rejbal,dispatch_date=@dispatch_date,remark2,disp_bal=@disp_bal,remain_bal=@rem_bal-@rejbal-@disp_bal                  
 from balance_form a    where segment=@seg                
                   
                   
 insert into balance_form                
 select * from balance_form1 where segment=@seg                
                  
 update balance_form1 set rejected=0  where segment=@seg                    
                   
 set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 if  @rem_bal<= 0                   
 begin                  
 delete from balance_form1  where segment=@seg                
                   
 insert into balance_form1  
 select edt=getdate(),Segment,a.receive_date,challan_no,remark,Openbal,                  
 rejected,dispatch_date=@dispatch_date,remark2=@remark2,disp_bal=@disp_bal,remian_bal=Openbal-rejected-@disp_bal                  
 from recv_form a where receive_date=@edt and segment=@seg                 
                   
 insert into balance_form  
 select * from balance_form1 where segment=@seg                 
                  
 update balance_form1 set rejected=0 where segment=@seg                     
                   
 --set @rem_bal=@openbal-@rejbal-@disp_bal                  
 set @rejbal=0                  
                   
 end                   
                   
 FETCH FROM CURSOR1                                             
 INTO @disp_bal,@remark2,@dispatch_date                  
                   
 END                  
 close CURSOR1                  
 deallocate CURSOR1              
          
--update kyc_form_entry_new set status='11' where NSE='Y'              
                   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mis_diversedispatch
-- --------------------------------------------------
CREATE procedure mis_diversedispatch(@fdate as varchar(11),@tdate as varchar(11))
as
-------datewise-----------
select convert(varchar(11),date,103) as Date,total=1,
Delivered=case when status ='DELIVERED' then convert(int,1) else convert(int,0) end,
Returned=case when status ='RETURNED' then convert(int,1) else convert(int,0) end,
Pending=case when status ='' or status ='Pending' or status is null then convert(int,1) else convert(int,0) end into #temp
 from mis_diverse_dispatch where date>=convert(datetime,@fdate,103) 
and date<=convert(datetime,@tdate,103)

------companywise---------
select company,total=1,
Delivered=case when status ='DELIVERED' then convert(int,1) else convert(int,0) end,
Returned=case when status ='RETURNED' then convert(int,1) else convert(int,0) end,
Pending=case when status ='' or status ='Pending' or status is null then convert(int,1) else convert(int,0) end into #temp1
 from mis_diverse_dispatch where date>=convert(datetime,@fdate,103) 
and date<=convert(datetime,@tdate,103)


select Date,sum(total) as [TotalDispatch],sum(Delivered) as Delivered,
sum(Returned) as Returned
,sum(Pending) as Pending
from #temp group by date


select Company,sum(total) as [TotalDispatch],sum(Delivered) as Delivered,
sum(Returned) as Returned,
sum(Pending) as Pending
from #temp1 group by company

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR
-- --------------------------------------------------
CREATE proc MIS_GENERATOR
(@FD as datetime,      
@TD as datetime)      
as      
      
  declare @temp_D as datetime      
  declare @dt_C as numeric(10)      
  declare @temp_C as numeric(10)      
      
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd      
  --set @TD = '2007-11-1 00:00:00.000'      
      
  declare @dis as numeric(10) -- No. of kits dispached      
  declare @del as numeric(10) -- No. of kits delivered      
  declare @ret as numeric(10) -- No. of kits returned      
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker      
      
  --print datediff(dy,@FD,@TD)      
      
  --set @temp_D = @FD      
      
  set @dt_C = datediff(dy,@FD,@TD)      
  set @temp_C = 0      
      
  truncate table TEMP_MIS      
      
  while @dt_C >= @temp_C      
  begin      
    set @temp_D = dateadd(dd,@temp_C,@FD)      
    set @temp_C = @temp_C + 1      
        
          
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered      
    where dispatch_date = @temp_D and inbunch = 'NO'     
          
    -- NO of kits dispatched      
    set @dis = (select count(*) from #temp)      
          
    -- NO of kits delivered      
    set @del = (select count(*) from delivery_ack where    
    client_code in(select client_code from #temp))      
      
    -- NO of kits returned      
    set @ret = (select count(*) from undelivered where    
    client_code in(select client_code from #temp))      
      
    -- NO of kits sent to branch / sub-broker      
    set @stb = (select count(*) from delivered       
    where delivered = 'YES' and inbunch = 'YES' and client_code in    
    (select client_code from #temp))      
      
    insert into TEMP_MIS      
    values(@temp_D,@dis,@del,@ret,@stb)      
    drop table #temp      
  end      
      
 select date=convert(varchar(12),date,103),dispatched,delivered,returned,inbunched from TEMP_MIS      
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE      
(@FD as datetime,          
@TD as datetime)          
as          
      
 select * into #temp from delivered          
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'      
      
      
      
select branch_cd,dispatched=count(*) into #t1 from #temp group by branch_cd -- Dispatched      
      
      
select branch_cd,delivered=count(*) into #t2 from #temp where client_code in      -- Delivered      
(select client_code from delivery_ack) group by branch_cd      
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd      
     
      
select branch_cd,returned=count(*) into #t3 from #temp where client_code in       -- Returned      
(select client_code from undelivered) group by branch_cd      
      
      
select branch_cd,inbunched=count(*) into #t4 from delivered                       -- SENT TO BRANCH      
where inbunch = 'YES' and delivered = 'YES' and client_code in      
(select client_code from #temp) group by branch_cd      
      
      
select a.branch_cd,      
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),      
delivered=(case when b.delivered is null then '0' else b.delivered end),      
returned=(case when c.returned is null then '0' else c.returned end),      
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)      
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd      
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d      
on a.branch_cd = d.branch_cd       
order by a.branch_cd      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_INDIVIDUAL
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_INDIVIDUAL
(@FD as datetime,        
@TD as datetime,  
@branch as varchar(50))        
as        
    
select * into #temp from delivered        
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd like '%'+ @branch + '%'  
    
  
select status=reason_undelivered,count=count(*) into #t from undelivered  
where client_code in(select client_code from #temp) group by reason_undelivered  
  
  
select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'  
union all  
select status=a.reason,count=(case when b.count is null then '0' else b.count end)  
from return_remarks a left outer join #t b on a.reason = b.status  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_INDIVIDUAL1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_INDIVIDUAL1
(@FD as datetime,        
@TD as datetime,  
@branch as varchar(50))        
as        
    
select * into #temp from delivered        
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd like '%'+ @branch + '%'  
    
  
select status=reason_undelivered,count=count(*) into #t from undelivered  
where client_code in(select client_code from #temp) group by reason_undelivered  
  
  
select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'  
union all  
select status=a.reason,count=(case when b.count is null then '0' else b.count end)  
from return_remarks a left outer join #t b on a.reason = b.status  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N                  
(@FD as datetime,                      
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                      
as                      
        
if @access_to = 'Branch'                  
begin        
 select * into temp from delivered (nolock)                     
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code          
        
 select * into temp1 from Tbl_Delivered_Branch (nolock)                     
    where fld_date >= @FD and fld_date <= @TD and fld_Branch = @access_code          
end        
else if @access_to = 'Region'        
begin        
 select * into temp from delivered (nolock)                     
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in        
 (select code from intranet.risk.dbo.region where reg_code = @access_code)        
        
 select * into temp1 from Tbl_Delivered_Branch (nolock)                     
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in        
 (select code from intranet.risk.dbo.region where reg_code = @access_code)          
end        
else if @access_to = 'Broker'        
begin        
 select * into temp from delivered (nolock)                      
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'        
        
 select * into temp1 from Tbl_Delivered_Branch (nolock)                      
    where fld_Date >= @FD and Fld_Date <= @TD         
end        
else if @access_to = 'Brmast'        
begin        
 select * into temp from delivered (nolock)                      
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in        
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)        
        
 select * into temp1 from Tbl_Delivered_Branch (nolock)                      
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in        
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)        
end        
else if @access_to = 'SB'        
begin        
 select * into temp from delivered (nolock)                      
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in        
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)        
         
 select * into temp1 from Tbl_Delivered_Branch (nolock)                      
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in        
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)        
end        
                  
select branch_cd,dispatched=count(*) into #t1 from temp group by branch_cd -- Dispatched                          
                  
select branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                  
(select client_code from delivery_ack) group by branch_cd                  
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                  
                 
                  
select fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch          
          
          
select branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                  
(select client_code from undelivered) group by branch_cd                  
                  
                  
select branch_cd,inbunched=count(*) into #t4 from delivered                       -- SENT TO BRANCH                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                  
(select client_code from temp) group by branch_cd                  
                  
drop table temp        
drop table temp1        
        
select a.branch_cd,                  
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                  
delivered=(case when b.delivered is null then '0' else b.delivered end),           
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                        
returned=(case when c.returned is null then '0' else c.returned end),                  
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)      
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                  
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                         
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch          
order by a.branch_cd                  
                  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis                                        
(@FD as datetime,                                            
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                            
as                                            
                              
if @access_to = 'Branch'                                        
begin                              
 select  * into temp from delivered (nolock)                                           
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                                
                              
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                           
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code                
----                
 select  * into br_temp from delivered (nolock)                                           
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd = @access_code                    
                
----                                
end                              
else if @access_to = 'Region'                              
begin                              
 select  * into temp from delivered (nolock)                                           
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                              
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                              
                              
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                           
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                              
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                  
-----                
select  * into br_temp from delivered (nolock)                                           
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                              
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                   
-----                
                              
end                              
else if @access_to = 'Broker'                              
begin                              
 select  * into temp from delivered (nolock)                                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                              
                              
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD                
-----                
 select  * into br_temp from delivered (nolock)                                            
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'                  
-----                
                               
end                              
else if @access_to = 'Brmast'                              
begin                              
 select  * into temp from delivered (nolock)                                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                              
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                              
                              
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                              
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                 
                
---                
 select  * into br_temp from delivered (nolock)                                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                              
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                   
                
---                             
end               
else if @access_to = 'SB'                              
begin                              
 select  * into temp from delivered (nolock)                                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                      
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                              
                               
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                              
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)                    
-----                
select  * into br_temp from delivered (nolock)                                            
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                              
(select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                            
------                
end                              
                                        
select  branch_cd,dispatched=count(*) into #t1 from temp     
group by branch_cd -- Dispatched                                                
                                        
select  branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                                        
(select  client_code from delivery_ack(nolock)) group by branch_cd                                        
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                                        
                                       
                                        
select  fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch                                
                                
                                
select  branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                               
(select client_code from undelivered(nolock)) group by branch_cd                                        
                                        
                                        
select  branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                                        
where inbunch = 'YES' and delivered = 'YES' and client_code in                                        
(select client_code from temp) group by branch_cd                  
        
        
        
                
select distinct branch_cd,Pending = count(*) into #br_temp from br_temp group by branch_cd                  
            
                         
                                        
drop table temp                              
drop table temp1                 
drop table br_temp                    
                           
                              
select a.branch_cd,                                        
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                        
delivered=(case when b.delivered is null then '0' else b.delivered end),                                 
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                              
returned=(case when c.returned is null then '0' else c.returned end),                                        
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                
Pending=(case when f.Pending is null then '0' else f.Pending end)                
                            
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                                        
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                                               
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch                   
left outer join #br_temp f on a.branch_cd = f.branch_cd             
order by a.branch_cd                                
                                        
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis_branch
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis_branch                                            
(@FD as datetime,                                                
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                                
as                                                
                                  
if @access_to = 'Branch'                                            
begin     
    
 select  * into temp_delivered from delivered (nolock)                                               
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='yes' and branch_cd = @access_code     
     
                                 
 select  * into temp from delivered (nolock)                                               
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                                    
                                  
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                               
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code                    
----                    
 select  * into br_temp from delivered (nolock)                                               
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd = @access_code                        
                    
----                                    
end                                  
else if @access_to = 'Region'                                  
begin     
    
 select  * into temp_delivered from delivered (nolock)                                               
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='yes' and branch_cd in                                  
 (select code from intranet.risk.dbo.region where reg_code = @access_code)         
                                 
 select  * into temp from delivered (nolock)                                               
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                  
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                                  
                                  
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                               
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                                  
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                      
-----                    
select  * into br_temp from delivered (nolock)                                               
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                                  
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                       
-----                    
                                  
end                                  
else if @access_to = 'Broker'                                  
begin       
 select  * into temp_delivered from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'  and delivered='YES'      
                               
 select  * into temp from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                                  
                                  
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD                    
-----                    
 select  * into br_temp from delivered (nolock)                                                
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'                      
-----                    
                   
end                                  
else if @access_to = 'Brmast'                                  
begin         
 select  * into temp_delivered from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and inbunch='YES'and branch_cd in                                  
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)          
                             
 select  * into temp from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                  
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                                  
                                  
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                                  
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                     
                    
---                    
 select  * into br_temp from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                  
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                       
                    
---                                 
end                   
else if @access_to = 'SB'                                  
begin       
    
 select  * into temp_delivered from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' and branch_cd in                          
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)        
                               
 select  * into temp from delivered (nolock)                                                
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                          
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                  
                                   
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                                  
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)                        
-----                    
select  * into br_temp from delivered (nolock)                                                
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                                  
(select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                
------                    
end                                  
                                            
select  branch_cd,dispatched=count(*) into #t1 from temp         
group by branch_cd -- Dispatched                                                    
           
select   branch_cd,delivered=count(*) into #t2 from temp_delivered group by branch_cd    
    
select  fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch                
                                     
                                          
                                           
                                            
                        
               
                                    
select  branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                                   
(select client_code from undelivered(nolock)) group by branch_cd                                            
                                            
                                            
select  branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                                            
where inbunch = 'YES' and delivered = 'YES' and client_code in                                            
(select client_code from temp) group by branch_cd                      
            
            
            
                    
select distinct branch_cd,Pending = count(*) into #br_temp from br_temp group by branch_cd                      
                
                             
                                            
drop table temp                                  
drop table temp1                     
drop table br_temp        
drop table temp_delivered      
                         
                               
                                  
select a.branch_cd,                                            
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                            
delivered=(case when b.delivered is null then '0' else b.delivered end),                                     
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                  
returned=(case when c.returned is null then '0' else c.returned end),                                            
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                    
Pending=(case when f.Pending is null then '0' else f.Pending end)                    
                                
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                                            
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                                                   
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch                       
left outer join #br_temp f on a.branch_cd = f.branch_cd                 
order by a.branch_cd                                    
                                            
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis_n
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis_n                                                    
(@FD as datetime,                                                        
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                                        
as           
        
IF EXISTS (Select id from Sysobjects where name = 'temp')                                                     
 Drop table temp      
IF EXISTS (Select id from Sysobjects where name = 'temp1')                                                     
 Drop table temp1    
IF EXISTS (Select id from Sysobjects where name = 'br_temp')                                                     
 Drop table br_temp    
IF EXISTS (Select id from Sysobjects where name = 'temp_delivered')                                                     
 Drop table temp_delivered    
                  
if @Access_to = 'Branch'                                                    
begin             
            
 select  * into temp_delivered from delivered (nolock)                                                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='yes' and branch_cd = @access_code             
             
                                         
 select  * into temp from delivered (nolock)                                                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                                            
                                          
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                       
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code                            
----                            
 select  * into br_temp from delivered (nolock)                                                       
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd = @access_code                                
                            
----                                            
end                                          
else if @access_to = 'Region'                                          
begin             
            
 select  * into temp_delivered from delivered (nolock)                                                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='yes' and branch_cd in                                          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                 
                                         
 select  * into temp from delivered (nolock)                                                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                                          
                                          
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                       
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                                          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                              
-----                            
select  * into br_temp from delivered (nolock)                                                       
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                                          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                               
-----                            
                                          
end                                          
else if @access_to = 'Broker'                       
begin               
 select  * into temp_delivered from delivered (nolock)                                           
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'  and delivered='YES'              
                                       
select  * into temp from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                                          
                                          
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                        
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD                            
-----                            
 select  * into br_temp from delivered (nolock)                                                        
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'                              
-----                            
                           
end                                          
else if @access_to = 'BRMAST'                                 
begin                 
 select  * into temp_delivered from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and inbunch='YES'and branch_cd in                                          
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                  
                                     
 select  * into temp from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                          
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                                          
                                          
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                        
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                                          
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                             
                            
---                            
 select  * into br_temp from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'and branch_cd in                                          
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                               
                            
---                                         
end                           
else if @access_to = 'SB'                                          
begin               
            
 select  * into temp_delivered from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' and branch_cd in                                  
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                
                                       
 select  * into temp from delivered (nolock)                                                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                  
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                          
                                           
 select  * into temp1 from Tbl_Delivered_Branch (nolock)                                                        
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                            
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)                                
-----                            
select  * into br_temp from delivered (nolock)                                                        
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                                          
(select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                        
------                       
end                                          
                                                    
select  branch_cd,dispatched=count(*) into #t1 from temp                 
group by branch_cd -- Dispatched                                                            
                   
select   branch_cd,delivered=count(*) into #t2 from temp_delivered group by branch_cd            
            
select  fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch           
      
-----NEW      
select  branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                                       
(select client_code from undelivered(nolock)) group by branch_cd                                                
                                                
                                                
select  branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                                                
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                
(select client_code from temp) group by branch_cd                        
                        
select distinct branch_cd,Pending = count(*) into #br_temp from br_temp group by branch_cd          
        
drop table temp                                      
drop table temp1                         
drop table br_temp       
Drop table temp_delivered         
                                   
select a.branch_cd,                                                
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                
delivered=(case when b.delivered is null then '0' else b.delivered end),                                         
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                      
returned=(case when c.returned is null then '0' else c.returned end),                                                
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                        
Pending=(case when f.Pending is null then '0' else f.Pending end)                        
                                    
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                                                
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                                                       
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch                           
left outer join #br_temp f on a.branch_cd = f.branch_cd                     
order by a.branch_cd                                        
                                                
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis_new
-- --------------------------------------------------


--exec MIS_GENERATOR_BRANCHWISE_N_Bmis_new '2007-10-1 00:00:00.000', '2007-11-1 00:00:00.000','Broker','CSO'

CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis_new                                                                
(@FD as datetime,                                                                    
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                                                    
as                       
                    
IF EXISTS (Select id from Sysobjects where name = 'temp')                                                                 
 Drop table temp                  
IF EXISTS (Select id from Sysobjects where name = 'Pen_rec')                                                                 
 Drop table Pen_rec                
IF EXISTS (Select id from Sysobjects where name = 'temp1')                                                                 
 Drop table temp1                
IF EXISTS (Select id from Sysobjects where name = 'temp_ret')                                                                 
 Drop table temp_ret          
IF EXISTS (Select id from Sysobjects where name = 't1')                                                                 
 Drop table t1            
IF EXISTS (Select id from Sysobjects where name = 't2')                                                                 
 Drop table t2                
IF EXISTS (Select id from Sysobjects where name = 't3')                                                                 
 Drop table t3             
IF EXISTS (Select id from Sysobjects where name = 't4')                                                                 
 Drop table t4                   
IF EXISTS (Select id from Sysobjects where name = 't5')                                                                 
 Drop table t5                             
          
IF EXISTS (Select id from Sysobjects where name = 'pen')                                                                 
 Drop table pen               
          
                              
if @Access_to = 'Branch'                                                                
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                    
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd = @access_code                              
                         
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
 and branch_cd = @access_code) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd = @access_code                                                                                                              
                                                                                  
 select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                                  
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                               
                    
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                               
                                
                                                                                  
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd          
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end        
      
---------      
      
--------      
      
else if @access_to = 'Broker'                                                      
begin             
         
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'       
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >=@FD and dispatch_date <=  @TD  and inbunch = 'NO' and delivered='PEN'       
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <= @TD  and delivered='BR' and inbunch='NO')b      
on a.fld_clcode=b.client_code             
      
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'                                              
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                      
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end       
--------      
-----        
          
          
else if @access_to = 'Region'                                                      
begin             
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                            
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                             
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in (select code from intranet.risk.dbo.region where reg_code = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                                                                     
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                               
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end           
    
else if @access_to = 'BRMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)                
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)                                      
          
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                      
                                       
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
    
else if @access_to = 'SBMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)             
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from Delivered where dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and sb_code in                                                      
(Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                                     
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                          
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered = 'YES' and  
sb_code in (Select sub_broker from risk.dbo.sb_master where sbmast_cd = @access_code) group by branch_cd                                                             
                                                                     
Select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
          
else if @access_to = 'SB'                           
begin            
          
select distinct * into temp from delivered(nolock)                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                          
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                          
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                                  
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                       
(select client_code from temp) group by branch_cd              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end                    
          
          
select a.branch_cd,                                                                                  
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                                          
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                                          
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                                
returned=(case when c.returned is null then '0' else c.returned end),                                                                                  
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                                  
Pending=(case when f.Pending is null then '0' else f.Pending end)                                    
                                                                                
from t1 a left outer join t2 b on a.branch_cd=b.branch_cd                                                                          
left outer join t3 c on a.branch_cd=c.branch_cd left outer join t4 d                                                                                   
on a.branch_cd = d.branch_cd left outer join t5 e on a.branch_cd = e.branch_cd                                                  
left outer join pen f on a.branch_cd = f.branch_cd                                                                         
order by a.branch_cd  
                                                                                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis_new_1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis_new_1                                                                
(@FD as varchar(25),                                                                    
@TD as varchar(25),
@access_to as varchar(15),
@access_code as varchar(15))                                                                    
as                       

set @FD=convert(datetime,@FD,103)
set @TD=convert(datetime,@TD,103)                 
   
IF EXISTS (Select id from Sysobjects where name = 'temp')                                                                 
 Drop table temp                  
IF EXISTS (Select id from Sysobjects where name = 'Pen_rec')                                                                 
 Drop table Pen_rec                
IF EXISTS (Select id from Sysobjects where name = 'temp1')                                                                 
 Drop table temp1                
IF EXISTS (Select id from Sysobjects where name = 'temp_ret')                                                                 
 Drop table temp_ret          
IF EXISTS (Select id from Sysobjects where name = 't1')                                                                 
 Drop table t1            
IF EXISTS (Select id from Sysobjects where name = 't2')                                                                 
 Drop table t2                
IF EXISTS (Select id from Sysobjects where name = 't3')                                                                 
 Drop table t3             
IF EXISTS (Select id from Sysobjects where name = 't4')                                                                 
 Drop table t4                   
IF EXISTS (Select id from Sysobjects where name = 't5')                                                                 
 Drop table t5                             
          
IF EXISTS (Select id from Sysobjects where name = 'pen')                                                                 
 Drop table pen               
          
                              
if @Access_to = 'Branch'                                                                
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                    
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd = @access_code                              
                         
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
 and branch_cd = @access_code) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd = @access_code                                                                                                              
                                                                                  
 select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                                  
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                               
                    
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                               
                                
                                                                                  
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd          
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end        
      
---------      
      
--------      
      
else if @access_to = 'Broker'                                                      
begin             
         
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'       
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >=@FD and dispatch_date <=  @TD  and inbunch = 'NO' and delivered='PEN'       
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <= @TD  and delivered='BR' and inbunch='NO')b      
on a.fld_clcode=b.client_code             
      
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'                                              
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                      
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end       
--------      
-----        
          
          
else if @access_to = 'Region'                                                      
begin             
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                            
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                             
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in (select code from intranet.risk.dbo.region where reg_code = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                                                                     
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                               
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end           
    
else if @access_to = 'BRMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                                      
          
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                      
                                       
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
    
else if @access_to = 'SBMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)             
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from Delivered where dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and sb_code in                                                      
(Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                                     
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                          
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered = 'YES' and  
sb_code in (Select sub_broker from risk.dbo.sb_master where sbmast_cd = @access_code) group by branch_cd                                                             
                                                                     
Select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
          
else if @access_to = 'SB'                           
begin            
          
select distinct * into temp from delivered(nolock)                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                          
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                          
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                                  
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                       
(select client_code from temp) group by branch_cd              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end                    
          
          
select a.branch_cd,                                                                                  
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                                          
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                                          
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                                
returned=(case when c.returned is null then '0' else c.returned end),                                                                                  
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                                  
Pending=(case when f.Pending is null then '0' else f.Pending end)                                    
                                                                                
from t1 a left outer join t2 b on a.branch_cd=b.branch_cd                                                                          
left outer join t3 c on a.branch_cd=c.branch_cd left outer join t4 d                                                                                   
on a.branch_cd = d.branch_cd left outer join t5 e on a.branch_cd = e.branch_cd                                                  
left outer join pen f on a.branch_cd = f.branch_cd                                                                         
order by a.branch_cd  
                                                                                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_Bmis_new1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_Bmis_new1                                                                
(@FD as datetime,                                                                    
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                                                    
as                       
                    
IF EXISTS (Select id from Sysobjects where name = 'temp')                                                                 
 Drop table temp                  
IF EXISTS (Select id from Sysobjects where name = 'Pen_rec')                                                                 
 Drop table Pen_rec                
IF EXISTS (Select id from Sysobjects where name = 'temp1')                                                                 
 Drop table temp1                
IF EXISTS (Select id from Sysobjects where name = 'temp_ret')                                                                 
 Drop table temp_ret          
IF EXISTS (Select id from Sysobjects where name = 't1')                                                                 
 Drop table t1            
IF EXISTS (Select id from Sysobjects where name = 't2')                                                                 
 Drop table t2                
IF EXISTS (Select id from Sysobjects where name = 't3')                                                                 
 Drop table t3             
IF EXISTS (Select id from Sysobjects where name = 't4')                                                                 
 Drop table t4                   
IF EXISTS (Select id from Sysobjects where name = 't5')                                                                 
 Drop table t5                             
          
IF EXISTS (Select id from Sysobjects where name = 'pen')                                                                 
 Drop table pen               
          
                              
if @Access_to = 'Branch'                                                                
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                    
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd = @access_code                              
                         
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
 and branch_cd = @access_code) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd = @access_code                                                                                                              
                                                                                  
 select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                                  
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                               
                    
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                               
                                
                                                                                  
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd          
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end        
      
---------      
      
--------      
      
else if @access_to = 'Broker'                                                      
begin             
         
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'       
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >=@FD and dispatch_date <=  @TD  and inbunch = 'NO' and delivered='PEN'       
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <= @TD  and delivered='BR' and inbunch='NO')b      
on a.fld_clcode=b.client_code             
      
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'                                              
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                      
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end       
--------      
-----        
          
          
else if @access_to = 'Region'                                                      
begin             
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                            
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                             
                  
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in (select code from intranet.risk.dbo.region where reg_code = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'  and branch_cd in                                                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                                                                     
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned           
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                               
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd              
          
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd                      
              
end           
    
else if @access_to = 'BRMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                                      
          
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                      
                                       
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
    
else if @access_to = 'SBMAST'                                             
begin           
          
select distinct * into temp from delivered(nolock)                                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                             
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)             
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from Delivered where dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and sb_code in                                                      
(Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and sb_code in                                                      
 (Select Sub_Broker from risk.dbo.sb_master where sbmast_cd = @access_code)                                     
                                                        
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                          
                                                                             
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered = 'YES' and  
sb_code in (Select sub_broker from risk.dbo.sb_master where sbmast_cd = @access_code) group by branch_cd                                                             
                                                                     
Select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                                  
(select client_code from temp) group by branch_cd                      
              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end           
          
          
else if @access_to = 'SB'                           
begin            
          
select distinct * into temp from delivered(nolock)                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                          
                               
            
select distinct * into Pen_rec from delivered(nolock)                                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                          
                  
select distinct * into  temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'                  
and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)) b                  
on a.fld_clcode=b.client_code                 
                                
select distinct * into temp_ret from delivered(nolock)                                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and branch_cd in                                              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                                                  
                                                                                          
select distinct branch_cd,dispatched=count(*) into t1 from temp group by branch_cd                                                                       
                                                                                  
select branch_cd,delivered=count(*) into t2  from delivered                                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by branch_cd                                                             
                                                                     
 select distinct branch_cd,deliveredBr = count(*) into t5 from temp1 group by branch_cd  -- Delivered to Branch                                                                          
                                                                                                                                            
select distinct branch_cd,returned=count(*) into t3 from temp_ret where client_code in       -- Returned                                                                                  
(select client_code from undelivered(nolock)) group by branch_cd                                                                                  
                                                                                  
                                                                                  
select distinct branch_cd,inbunched=count(*) into t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                       
(select client_code from temp) group by branch_cd              
select distinct branch_cd,Pending=count(*) into pen from Pen_rec group by branch_cd              
end                    
          
          
select a.branch_cd,                                                                                  
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                                          
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                                          
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                                
returned=(case when c.returned is null then '0' else c.returned end),                                                                                  
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                                  
Pending=(case when f.Pending is null then '0' else f.Pending end)                                    
                                                                                
from t1 a left outer join t2 b on a.branch_cd=b.branch_cd                                                                          
left outer join t3 c on a.branch_cd=c.branch_cd left outer join t4 d                                                                                   
on a.branch_cd = d.branch_cd left outer join t5 e on a.branch_cd = e.branch_cd                                                  
left outer join pen f on a.branch_cd = f.branch_cd                                                                         
order by a.branch_cd  
                                                                                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_br
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_br        
(@FD as datetime,                                    
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                                    
as                                    
                      
if @access_to = 'Branch'                                
begin                      
 select distinct * into temp from delivered (nolock)                                   
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                        
                      
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                                   
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code          
-----new pen        
 select distinct * into pending from delivered (nolock)                                   
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd = @access_code         
----- end pen               
end                      
else if @access_to = 'Region'                      
begin                      
 select distinct * into temp from delivered (nolock)                                   
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)        
        
 select distinct * into pending from delivered (nolock)                                   
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                        
                      
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                                   
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                      
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                        
end                      
else if @access_to = 'Broker'                      
begin                      
 select distinct * into temp from delivered (nolock)                                    
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                      
         
 select distinct * into pending from delivered (nolock)                                    
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='pen'           
        
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                                    
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD                       
end                      
else if @access_to = 'Brmast'                      
begin                      
 select distinct * into temp from delivered (nolock)                                    
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)           
        
 select distinct * into pending from delivered (nolock)                                    
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                     
                      
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                                    
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                      
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)                      
end                      
else if @access_to = 'SB'                      
begin                      
 select distinct * into temp from delivered (nolock)                                    
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in                      
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)        
        
 select distinct * into pending from delivered (nolock)                                    
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN' and branch_cd in                      
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)                        
                       
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                                    
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in                      
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)                      
end                      
                                
select branch_cd,dispatched=count(*) into #t1 from temp group by branch_cd -- Dispatched                                        
                                
select distinct branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                                
(select distinct client_code from delivery_ack(nolock)) group by branch_cd                                
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                                
                               
                                
select fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch                        
                        
                        
select branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                       
(select client_code from undelivered(nolock)) group by branch_cd          
        
                        
select branch_cd,delivered_pen=count(*) into #t_pen_branch from pending group by branch_cd       -- PENDING kits                       
--(select client_code from temp(nolock)) group by branch_cd           
                              
                                
                                
select distinct branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                                
where inbunch = 'YES' and delivered = 'YES' and client_code in                                
(select client_code from temp) group by branch_cd                      
                                
drop table temp           
drop table pending                   
drop table temp1                      
                      
select a.branch_cd,                                
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                
delivered=(case when b.delivered is null then '0' else b.delivered end),                         
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                      
returned=(case when c.returned is null then '0' else c.returned end),         
delivered_pen=(case when f.delivered_pen is null then '0' else f.delivered_pen end),                        
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)                    
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                                
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                                       
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch      
left outer join #t_pen_branch f on a.branch_cd=f.branch_cd    
order by a.branch_cd                        
                                
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_branch
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_branch       
(@FD as datetime,                            
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                            
as                            
              
if @access_to = 'Branch'                        
begin              
 select distinct * into temp from delivered (nolock)                           
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code                
              
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                           
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code                
end              
else if @access_to = 'Region'              
begin              
 select distinct * into temp from delivered (nolock)                           
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in              
 (select code from intranet.risk.dbo.region where reg_code = @access_code)              
              
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                           
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in              
 (select code from intranet.risk.dbo.region where reg_code = @access_code)                
end              
else if @access_to = 'Broker'              
begin              
 select distinct * into temp from delivered (nolock)                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'              
              
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD               
end              
else if @access_to = 'Brmast'              
begin              
 select distinct * into temp from delivered (nolock)                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in              
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)              
              
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in              
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)              
end              
else if @access_to = 'SB'              
begin              
 select distinct * into temp from delivered (nolock)                            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in              
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)              
               
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                            
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in              
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)              
end              
                        
select branch_cd,dispatched=count(*) into #t1 from temp group by branch_cd -- Dispatched                                
                        
select distinct branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                        
(select distinct client_code from delivery_ack(nolock)) group by branch_cd                        
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                        
                       
                        
select fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch                
                
                
select branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned               
(select client_code from undelivered(nolock)) group by branch_cd                        
                        
                        
select distinct branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                        
where inbunch = 'YES' and delivered = 'YES' and client_code in                        
(select client_code from temp) group by branch_cd              
                        
drop table temp              
drop table temp1              
              
select a.branch_cd,                        
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                        
delivered=(case when b.delivered is null then '0' else b.delivered end),                 
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                              
returned=(case when c.returned is null then '0' else c.returned end),                        
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)            
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                        
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                               
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch                
order by a.branch_cd                
                        
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N_new
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N_new                      
(@FD as datetime,                          
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                          
as                          
            
if @access_to = 'Branch'                      
begin            
 select distinct * into temp from delivered (nolock)                         
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code              
            
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                         
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch = @access_code              
end            
else if @access_to = 'Region'            
begin            
 select distinct * into temp from delivered (nolock)                         
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in            
 (select code from intranet.risk.dbo.region where reg_code = @access_code)            
            
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                         
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in            
 (select code from intranet.risk.dbo.region where reg_code = @access_code)              
end            
else if @access_to = 'Broker'            
begin            
 select distinct * into temp from delivered (nolock)                          
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'            
            
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                          
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD             
end            
else if @access_to = 'Brmast'            
begin            
 select distinct * into temp from delivered (nolock)                          
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in            
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)            
            
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                          
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in            
 (select branch_cd from intranet.risk.dbo.branch_master(nolock) where brmast_cd = @access_code)            
end            
else if @access_to = 'SB'            
begin            
 select distinct * into temp from delivered (nolock)                          
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in            
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)            
             
 select distinct * into temp1 from Tbl_Delivered_Branch (nolock)                          
    where fld_delivery_date >= @FD and fld_delivery_date <= @TD and fld_Branch in            
 (select branch_code from intranet.risk.dbo.subbrokers(nolock)where sub_broker = @access_code)            
end            
                      
select branch_cd,dispatched=count(*) into #t1 from temp group by branch_cd -- Dispatched                              
                      
select distinct branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                      
(select distinct client_code from delivery_ack(nolock)) group by branch_cd                      
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                      
                     
                      
select fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch              
              
              
select branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                      
(select client_code from undelivered(nolock)) group by branch_cd                      
                      
                      
select distinct branch_cd,inbunched=count(*) into #t4 from delivered(nolock) -- SENT TO BRANCH                      
where inbunch = 'YES' and delivered = 'YES' and client_code in                      
(select client_code from temp) group by branch_cd            
                      
drop table temp            
drop table temp1            
            
select a.branch_cd,                      
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                      
delivered=(case when b.delivered is null then '0' else b.delivered end),               
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                            
returned=(case when c.returned is null then '0' else c.returned end),                      
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)          
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                      
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                             
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch              
order by a.branch_cd              
                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_BRANCHWISE_N1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_BRANCHWISE_N1                   
(@FD as datetime,                        
@TD as datetime,@access_to as varchar(15),@access_code as varchar(15))                        
as                        
          
if @access_to = 'Branch'                    
begin          
 select * into temp from delivered (nolock)                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd = @access_code            
          
 select * into temp1 from Tbl_Delivered_Branch (nolock)                       
    where fld_date >= @FD and fld_date <= @TD and fld_Branch = @access_code            
end          
else if @access_to = 'Region'          
begin          
 select * into temp from delivered (nolock)                       
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)          
          
 select * into temp1 from Tbl_Delivered_Branch (nolock)                       
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in          
 (select code from intranet.risk.dbo.region where reg_code = @access_code)            
end          
else if @access_to = 'Broker'          
begin          
 select * into temp from delivered (nolock)                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'          
          
 select * into temp1 from Tbl_Delivered_Branch (nolock)                        
    where fld_Date >= @FD and Fld_Date <= @TD           
end          
else if @access_to = 'Brmast'          
begin          
 select * into temp from delivered (nolock)                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in          
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)          
          
 select * into temp1 from Tbl_Delivered_Branch (nolock)                        
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in          
 (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @access_code)          
end          
else if @access_to = 'SB'          
begin          
 select * into temp from delivered (nolock)                        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and branch_cd in          
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)          
           
 select * into temp1 from Tbl_Delivered_Branch (nolock)                        
    where fld_Date >= @FD and Fld_Date <= @TD and fld_Branch in          
 (select branch_code from intranet.risk.dbo.subbrokers where sub_broker = @access_code)          
end          
                    
select branch_cd,dispatched=count(*) into #t1 from temp group by branch_cd -- Dispatched                            
                    
select branch_cd,delivered=count(*) into #t2 from temp where client_code in      -- Delivered                    
(select client_code from delivery_ack) group by branch_cd                    
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by branch_cd                    
                   
                    
select fld_Branch,deliveredBr = count(*) into #t5 from temp1 group by Fld_Branch  -- Delivered to Branch            
            
            
select branch_cd,returned=count(*) into #t3 from temp where client_code in       -- Returned                    
(select client_code from undelivered) group by branch_cd                    
                    
                    
select branch_cd,inbunched=count(*) into #t4 from delivered                       -- SENT TO BRANCH                    
where inbunch = 'YES' and delivered = 'YES' and client_code in                    
(select client_code from temp) group by branch_cd                    
                    
drop table temp          
drop table temp1          
          
select a.branch_cd,                    
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                    
delivered=(case when b.delivered is null then '0' else b.delivered end),             
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                          
returned=(case when c.returned is null then '0' else c.returned end),                    
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)        
from #t1 a left outer join #t2 b on a.branch_cd=b.branch_cd                    
left outer join #t3 c on a.branch_cd=c.branch_cd left outer join #t4 d                           
on a.branch_cd = d.branch_cd left outer join #t5 e on a.branch_cd = e.Fld_Branch            
order by a.branch_cd                    
                    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE
-- --------------------------------------------------

CREATE proc MIS_GENERATOR_COURIERWISE      
(@FD as datetime,          
@TD as datetime)          
as          
          
  select * into #temp from delivered          
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'      
      
      
      
select cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched      
      
      
select cour_compn_name,delivered=count(*) into #t2 from #temp where client_code in      -- Delivered      
(select client_code from delivery_ack) group by cour_compn_name      
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by cour_compn_name     
      
      
select cour_compn_name,returned=count(*) into #t3 from #temp where client_code in       -- Returned      
(select client_code from undelivered) group by cour_compn_name      
      
      
select cour_compn_name,inbunched=count(*) into #t4 from delivered                       -- SENT TO BRANCH      
where inbunch = 'YES' and delivered = 'YES' and client_code in      
(select client_code from #temp) group by cour_compn_name      
      
      
select a.cour_compn_name,      
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),      
delivered=(case when b.delivered is null then '0' else b.delivered end),      
returned=(case when c.returned is null then '0' else c.returned end),      
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)      
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name      
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d      
on a.cour_compn_name = d.cour_compn_name order by a.cour_compn_name      
          
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_INDIVIDUAL
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_INDIVIDUAL  
(@FD as datetime,            
@TD as datetime,      
@courier as varchar(50))            
as            
            
  select * into #temp from delivered            
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and cour_compn_name like '%'+ @courier + '%'      
         
        
select status=reason_undelivered,count=count(*) into #t from undelivered      
where client_code in(select client_code from #temp) group by reason_undelivered      
      
      
select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'      
union all      
select status=a.reason,count=(case when b.count is null then '0' else b.count end)      
from return_remarks a left outer join #t b on a.reason = b.status      
      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_INDIVIDUAL1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_INDIVIDUAL1
(@FD as datetime,        
@TD as datetime,  
@courier as varchar(50))        
as        
        
  select * into #temp from delivered        
    where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and cour_compn_name like '%'+ @courier + '%'  
    
    
select status=reason_undelivered,count=count(*) into #t from undelivered  
where client_code in(select client_code from #temp) group by reason_undelivered  
  
  
select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'  
union all  
select status=a.reason,count=(case when b.count is null then '0' else b.count end)  
from return_remarks a left outer join #t b on a.reason = b.status  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N                                
(@FD as datetime,                                    
@TD as datetime)                                    
as                                    
                                    
  select distinct * into #temp from delivered                                    
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                     
                        
 select distinct * into #temp1 from Tbl_Delivered_Branch(nolock)                                    
    --where fld_Date >= @FD and Fld_Date <= @TD                         
 where fld_delivery_date >= @FD and fld_delivery_date <= @TD   
                     
                                
                                        
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched                                
                                
  -----new delivered  
select * into #t from delivered where dispatch_date >=@FD and dispatch_date <= @TD and inbunch ='no'   
and delivered='yes'   
select distinct cour_compn_name,delivered=count(*) into #t2 from #t where client_code in      -- Delivered                                
(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name    
-------   end delivered   
                          
--select distinct cour_compn_name,delivered=count(*) into #t2 from #temp where client_code in      -- Delivered                                
--(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name                                
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by cour_compn_name                               
                        
 select distinct fld_company,deliveredBr = count(*) into #t5 from #temp1 group by fld_company  -- Delivered to Branch                        
                                
                                
select distinct cour_compn_name,returned=count(*) into #t3 from #temp where client_code in       -- Returned                                
(select client_code from undelivered(nolock)) group by cour_compn_name                                
                                
                                
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                
where inbunch = 'YES' and delivered = 'YES' and client_code in                                
(select client_code from #temp) group by cour_compn_name                                
                                
                                
select a.cour_compn_name,                                
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                
delivered=(case when b.delivered is null then '0' else b.delivered end),                        
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                
returned=(case when c.returned is null then '0' else c.returned end),                                
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)                                
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                 
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.fld_company                        
order by a.cour_compn_name                                
                                    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis                                          
(@FD as datetime,                                              
@TD as datetime)                                              
as                                              
                                              
  select distinct * into #temp from delivered                                              
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'        
        
---        
select distinct * into #Pen_rec from delivered                                              
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'         
        
----                                   
                                  
 select distinct * into #temp1 from Tbl_Delivered_Branch(nolock)                                              
    --where fld_Date >= @FD and Fld_Date <= @TD                                   
 where fld_delivery_date >= @FD and fld_delivery_date <= @TD             
                               
                                          
                                                  
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched                                          
                                          
  -----new delivered            
select * into #t from delivered where dispatch_date >=@FD and dispatch_date <= @TD and inbunch ='no'             
and delivered='yes'             
select distinct cour_compn_name,delivered=count(*) into #t2 from #t where client_code in      -- Delivered                                          
(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name              
-------   end delivered             
                                    
--select distinct cour_compn_name,delivered=count(*) into #t2 from #temp where client_code in      -- Delivered                                          
--(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name                                          
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by cour_compn_name                                         
                                  
 select distinct fld_company,deliveredBr = count(*) into #t5 from #temp1 group by fld_company  -- Delivered to Branch                                  
                                          
                                          
select distinct cour_compn_name,returned=count(*) into #t3 from #temp where client_code in       -- Returned                                          
(select client_code from undelivered(nolock)) group by cour_compn_name                                          
                                          
                                          
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                          
where inbunch = 'YES' and delivered = 'YES' and client_code in                                          
(select client_code from #temp) group by cour_compn_name          
          
------ pending kits        
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec(nolock) group by cour_compn_name         
                        
------end kits                          
                                          
                                          
select a.cour_compn_name,                                          
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                          
delivered=(case when b.delivered is null then '0' else b.delivered end),                                  
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                          
returned=(case when c.returned is null then '0' else c.returned end),                                          
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),          
Pending=(case when f.Pending is null then '0' else f.Pending end)            
                                        
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                  
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                           
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.fld_company          
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                 
order by a.cour_compn_name                                          
                                              
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis_N
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis_N                                                                
(@FD as datetime,                                                                    
@TD as datetime)                                                                    
as                                                                    
                                                                    
select distinct * into #temp from delivered(nolock)                                                                   
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'      
union all      
select distinct * from delivered(nolock)                                                                   
where dispatch_date >= @FD and dispatch_date <= @TD and cour_compn_name ='angel broking ltd' and inbunch = 'YES'   
union all      
select distinct * from delivered(nolock)                                                                   
where dispatch_date >= @FD and dispatch_date <= @TD and cour_compn_name ='Dummy Courier' and inbunch = 'YES'      
                                 
                              
                             
 select distinct * into #Pen_rec from delivered(nolock)                                                                    
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'                               
       
select distinct * into  #temp1 from Tbl_Delivered_Branch a          
inner join          
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'          
) b          
on a.fld_clcode=b.client_code     
                           
--select * into #temp1 from delivered(nolock) where dispatch_date >=@FD                  
---and dispatch_date <=@TD and delivered='BR'and inbunch='no'                
              
select distinct * into #temp_ret from delivered(nolock)                                                                  
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'                                                  
                               
                                                                
                                                                        
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched                                                                
                                                                
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                            
                                                        
                                                   
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                        
                                                                
                                                                
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                                
(select client_code from undelivered(nolock)) group by cour_compn_name                                                                
                                                                
                                                                
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                
(select client_code from #temp) group by cour_compn_name                                
                                
------ pending kits                              
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name                               
        
------end kits                                                
                                                                
                                                                
select a.cour_compn_name,                                                                
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                            
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                        
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                              
returned=(case when c.returned is null then '0' else c.returned end),                                                                
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                
Pending=(case when f.Pending is null then '0' else f.Pending end)                  
                                                              
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                        
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                                 
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                                
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                       
order by a.cour_compn_name                                                                
                                                                    
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis                                                                      
(@FD as datetime,                                                                          
@TD as datetime,         
@Company as varchar(50))                                                                          
as                         

                                                   
select distinct * into #temp from delivered(nolock)                                                                         
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and cour_compn_name=@Company                            
                                 
                   

select distinct * into #Pen_rec from delivered(nolock)                                                                          
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and cour_compn_name=@Company      
      
      
select distinct * into  #temp1 from Tbl_Delivered_Branch a      
inner join      
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'      
and cour_compn_name=@company) b      
on a.fld_clcode=b.client_code     
                    
select distinct * into #temp_ret from delivered(nolock)                                                                        
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and cour_compn_name=@Company                                                   
                                     
                                                                      
                                                                              
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name                                                                      
                                                                      
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                          
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                                  
                                                              
                                                         
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                              
                                                                      
                                                                      
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                                      
(select client_code from undelivered(nolock)) group by cour_compn_name                                                                      
                                                                      
                                                                      
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                      
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                      
(select client_code from #temp) group by cour_compn_name                                      
                                      
------ pending kits                                    
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name                                     
                                                    
------end kits                                       
                                                                      
                                                                      
select a.cour_compn_name,                                                                      
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                              
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                              
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                    
returned=(case when c.returned is null then '0' else c.returned end),                                                                      
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                      
Pending=(case when f.Pending is null then '0' else f.Pending end)                        
                                                                    
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                              
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                                       
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                                      
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                             
order by a.cour_compn_name                                                                      
                                                                          
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis_new
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis_new                                                                           
(  
@fdate as varchar(25),                                                      
@tdate as varchar(25),           
@Company as varchar(50)  
)                                                                                
as                               
      
set @fdate=convert(datetime,@fdate,103)    
set @tdate=convert(datetime,@tdate,103)      
                                                      
select distinct * into #temp from delivered(nolock)                                                                               
where dispatch_date >= @fdate and dispatch_date <= @tdate and inbunch = 'NO' and cour_compn_name=@Company                                  
                                       
                         
      
select distinct * into #Pen_rec from delivered(nolock)                                                                                
 where dispatch_date >= @fdate and dispatch_date <= @tdate and inbunch = 'NO' and delivered='PEN'  and cour_compn_name=@Company            
            
            
select distinct * into  #temp1 from Tbl_Delivered_Branch a            
inner join            
(select distinct * from delivered where  dispatch_date >=@fdate and dispatch_date <=@tdate  and delivered='BR' and inbunch='no'            
and cour_compn_name=@company) b            
on a.fld_clcode=b.client_code           
                          
select distinct * into #temp_ret from delivered(nolock)                                                                              
where dispatch_date >= @fdate and dispatch_date <= @tdate and inbunch = 'NO' and delivered <>'BR' and cour_compn_name=@Company                                                         
                                           
                                                                            
                                                                                    
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name                                                                            
                                                                            
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                                
where dispatch_date >= @fdate and dispatch_date <= @tdate and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                                        
                                                                    
                                                               
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                                    
                                                                            
                                                                            
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                                            
(select client_code from undelivered(nolock)) group by cour_compn_name                                                                            
                                                                            
                                                                            
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                            
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                            
(select client_code from #temp) group by cour_compn_name                                            
                                            
------ pending kits                                          
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name                                           
       
------end kits                                             
                                                                            
                                                                            
select a.cour_compn_name,                                                                            
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                                    
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                                    
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                          
returned=(case when c.returned is null then '0' else c.returned end),                                                                            
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                            
Pending=(case when f.Pending is null then '0' else f.Pending end)                              
                                                                          
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                                    
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                                             
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                                            
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                                   
order by a.cour_compn_name                                                                            
                                                                                
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis_N_post
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis_N_post                                       
(@FD as datetime,                                                                  
@TD as datetime)                                                                  
as                                                                  
                                                                  
select distinct * into #temp from delivered(nolock)                                                                 
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and cour_compn_name='POSTAL SERVICES'  
  
         
                           
 select distinct * into #Pen_rec from delivered(nolock)                                                                  
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and cour_compn_name='POSTAL SERVICES'                           
                            
select * into #temp1 from delivered(nolock) where dispatch_date >=@FD                
and dispatch_date <=@TD and delivered='BR'and inbunch='no' and cour_compn_name='POSTAL SERVICES'             
            
select distinct * into #temp_ret from delivered(nolock)                                                                
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and cour_compn_name='POSTAL SERVICES'                                               
                             
                                                              
                                                                      
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name                                                              
                                                              
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                  
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                          
                                                      
                                                 
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                      
                                                              
                                                              
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                              
(select client_code from undelivered(nolock)) group by cour_compn_name                                                              
                                                              
                                                              
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                              
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                              
(select client_code from #temp) group by cour_compn_name                              
                              
------ pending kits                            
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name                             
                                            
------end kits                                              
                                                              
                                                              
select a.cour_compn_name,                                                              
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                      
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                      
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                            
returned=(case when c.returned is null then '0' else c.returned end),                                                              
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                              
Pending=(case when f.Pending is null then '0' else f.Pending end)                
                                                            
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                      
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                               
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                              
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                     
order by a.cour_compn_name                                                              
                                                                  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_Cmis_NEW
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_Cmis_NEW                                                                  
(@FD as varchar(25),                                                                      
@TD as varchar(25))                                                                      
as 

set @FD=convert(datetime,@FD,103)                                                                     
set @TD=convert(datetime,@TD,103)                                                                     
                                                                      
select distinct * into #temp from delivered(nolock)                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'        
union all        
select distinct * from delivered(nolock)                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and cour_compn_name ='angel broking ltd' and inbunch = 'YES'     
union all        
select distinct * from delivered(nolock)                                                                     
where dispatch_date >= @FD and dispatch_date <= @TD and cour_compn_name ='Dummy Courier' and inbunch = 'YES'        
                                   
                                
                               
 select distinct * into #Pen_rec from delivered(nolock)                                                                      
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'                                 
         
select distinct * into  #temp1 from Tbl_Delivered_Branch a            
inner join            
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'            
) b            
on a.fld_clcode=b.client_code       
                             
--select * into #temp1 from delivered(nolock) where dispatch_date >=@FD                    
---and dispatch_date <=@TD and delivered='BR'and inbunch='no'                  
                
select distinct * into #temp_ret from delivered(nolock)                                                                    
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR'                                                    
                                 
                                                                  
                                                                          
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched                                                                  
                                                                  
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                      
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                              
                                                          
                                                     
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                          
                                                                  
                                                                  
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                                  
(select client_code from undelivered(nolock)) group by cour_compn_name                                                                  
                                                                  
                                                                  
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                  
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                  
(select client_code from #temp) group by cour_compn_name                                  
                                  
------ pending kits                                
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name                                 
          
------end kits                                                  
                                                                  
                                                                  
select a.cour_compn_name,                                                                  
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                              
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                          
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                
returned=(case when c.returned is null then '0' else c.returned end),                                                                  
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                  
Pending=(case when f.Pending is null then '0' else f.Pending end)                    
                                                                
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                          
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                                   
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                                  
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                         
order by a.cour_compn_name                                                                  
                                                                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_COURIERWISE_N_courier
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_COURIERWISE_N_courier                                      
(@FD as datetime,                                          
@TD as datetime)                                          
as                                          
                                          
  select distinct * into #temp from delivered                                          
   where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'                               
                              
 select distinct * into #temp1 from Tbl_Delivered_Branch(nolock)                                          
    --where fld_Date >= @FD and Fld_Date <= @TD                               
 where fld_delivery_date >= @FD and fld_delivery_date <= @TD         
                           
                                      
                                              
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name -- Dispatched                                      
                                      
  -----new delivered        
select * into #t from delivered where dispatch_date >=@FD and dispatch_date <= @TD and inbunch ='no'         
and delivered='yes'         
select distinct cour_compn_name,delivered=count(*) into #t2 from #t where client_code in      -- Delivered                                      
(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name          
-------   end delivered         
                                
--select distinct cour_compn_name,delivered=count(*) into #t2 from #temp where client_code in      -- Delivered                                      
--(select distinct client_code from delivery_ack(nolock)) group by cour_compn_name                                      
--(select client_code from delivered (nolock) where delivered = 'YES' and inbunch = 'NO') group by cour_compn_name                                     
                              
 select distinct fld_company,deliveredBr = count(*) into #t5 from #temp1 group by fld_company  -- Delivered to Branch                              
                                      
                                      
select distinct cour_compn_name,returned=count(*) into #t3 from #temp where client_code in       -- Returned                                      
(select client_code from undelivered(nolock)) group by cour_compn_name       
      
  -----pending kits       
select * into #t_pen from delivered where dispatch_date >=@FD and dispatch_date <= @TD and inbunch ='no'         
and delivered='pen'         
select distinct cour_compn_name,delivered_pen=count(*) into #t_pen1 from #t_pen      -- pending kits                                  
group by cour_compn_name          
-------   end pending kits                         
                                      
                                      
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                      
where inbunch = 'YES' and delivered = 'YES' and client_code in                                      
(select client_code from #temp) group by cour_compn_name                                      
                                      
                                      
select a.cour_compn_name,                                      
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                      
delivered=(case when b.delivered is null then '0' else b.delivered end),                              
deliveredBr = (case when e.deliveredBr is null then '0' else e.deliveredBr end),                                      
returned=(case when c.returned is null then '0' else c.returned end),      
delivered_pen=(case when f.delivered_pen is null then '0' else f.delivered_pen end),                                    
inbunched=(case when d.inbunched is null then '0' else d.inbunched end)     
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                      
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d         
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.fld_company       
left outer join #t_pen1 f on a. cour_compn_name = f. cour_compn_name                      
order by a.cour_compn_name                                      
                                          
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE    
(@FD as datetime,            
@TD as datetime)            
as            
            
  declare @temp_D as datetime            
  declare @dt_C as numeric(10)            
  declare @temp_C as numeric(10)            
            
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd            
  --set @TD = '2007-11-1 00:00:00.000'            
            
  declare @dis as numeric(10) -- No. of kits dispached            
  declare @del as numeric(10) -- No. of kits delivered            
  declare @ret as numeric(10) -- No. of kits returned            
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker            
            
  --print datediff(dy,@FD,@TD)            
            
  --set @temp_D = @FD            
            
  set @dt_C = datediff(dy,@FD,@TD)            
  set @temp_C = 0            
            
  truncate table TEMP_MIS            
            
  while @dt_C >= @temp_C            
  begin            
    set @temp_D = dateadd(dd,@temp_C,@FD)            
    set @temp_C = @temp_C + 1            
              
                
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered            
    where dispatch_date = @temp_D and inbunch = 'NO'           
                
    -- NO of kits dispatched            
    set @dis = (select count(*) from #temp)            
                
    -- NO of kits delivered            
    set @del = (select count(*) from delivery_ack where          
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and       
    client_code in(select client_code from #temp))            
            
    -- NO of kits returned            
    set @ret = (select count(*) from undelivered where          
    client_code in(select client_code from #temp))            
            
    -- NO of kits sent to branch / sub-broker            
    set @stb = (select count(*) from delivered             
    where delivered = 'YES' and inbunch = 'YES' and client_code in          
    (select client_code from #temp))            
            
    insert into TEMP_MIS            
    values(@temp_D,@dis,@del,@ret,@stb)            
    drop table #temp            
  end            
            
 select date=convert(varchar(12),date,103),dispatched,delivered,returned,inbunched from TEMP_MIS            
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_INDIVIDUAL
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_INDIVIDUAL
(@FD as datetime)        

as        
        
  select * into #temp from delivered        
    where dispatch_date = @FD and inbunch = 'NO'
    
    
select status=reason_undelivered,count=count(*) into #t from undelivered  
where client_code in(select client_code from #temp) group by reason_undelivered  
  
  
select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'  
union all  
select status=a.reason,count=(case when b.count is null then '0' else b.count end)  
from return_remarks a left outer join #t b on a.reason = b.status  
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N              
(@FD as datetime,                      
@TD as datetime)                      
as                      
                      
  declare @temp_D as datetime                      
  declare @dt_C as numeric(10)                      
  declare @temp_C as numeric(10)                      
                      
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                      
  --set @TD = '2007-11-1 00:00:00.000'                      
                      
  declare @dis as numeric(10) -- No. of kits dispached                      
  declare @del as numeric(10) -- No. of kits delivered         
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                      
  declare @ret as numeric(10) -- No. of kits returned                      
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                      
                      
  --print datediff(dy,@FD,@TD)                      
                      
  --set @temp_D = @FD                      
                      
  set @dt_C = datediff(dy,@FD,@TD)                      
  set @temp_C = 0                      
                      
  truncate table TEMP_MIS                      
                      
  while @dt_C >= @temp_C                      
  begin                      
    set @temp_D = dateadd(dd,@temp_C,@FD)                      
    set @temp_C = @temp_C + 1                      
                        
                          
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                     
    where dispatch_date = @temp_D and inbunch = 'NO'         
        
 select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)       
    where fld_delivery_date = @temp_D         
                          
    -- NO of kits dispatched                      
    set @dis = (select count(*) from #temp)                      
                          
    -- NO of kits delivered to clients                      
    set @del = (select count(*) from delivery_ack(nolock) where                    
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and                 
    client_code in(select client_code from #temp))           
        
 -- NO of kits delivered to branch         
  set @delBr = (select count(*) from #temp1)        
                      
    -- NO of kits returned                      
    set @ret = (select count(*) from undelivered(nolock) where                    
    client_code in(select client_code from #temp))                      
                      
    -- NO of kits sent to branch / sub-broker                      
    set @stb = (select count(*) from delivered(nolock)                       
    where delivered = 'YES' and inbunch = 'YES' and client_code in                    
    (select client_code from #temp))                      
                      
    insert into TEMP_MIS                      
    values(@temp_D,@dis,@del,@ret,@stb,@delBr)                      
    drop table #temp        
 drop table #temp1                      
  end                      
                      
 select date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched from TEMP_MIS(nolock)                     
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_date
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N_date        
(@FD as datetime,                              
@TD as datetime)                              
as                              
                              
  declare @temp_D as datetime                              
  declare @dt_C as numeric(10)                              
  declare @temp_C as numeric(10)                              
                              
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                              
  --set @TD = '2007-11-1 00:00:00.000'                              
                              
  declare @dis as numeric(10) -- No. of kits dispached                              
  declare @del as numeric(10) -- No. of kits delivered                 
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                              
  declare @ret as numeric(10) -- No. of kits returned                             
  declare @pen as numeric (10)--- No.of kits pending        
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                         
                             
  --print datediff(dy,@FD,@TD)                              
                              
  --set @temp_D = @FD                              
                              
  set @dt_C = datediff(dy,@FD,@TD)                              
  set @temp_C = 0                              
                              
  truncate table TEMP_MIS                              
                              
  while @dt_C >= @temp_C                              
  begin                              
    set @temp_D = dateadd(dd,@temp_C,@FD)                              
    set @temp_C = @temp_C + 1                              
                                
                                  
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                             
    where dispatch_date = @temp_D and inbunch = 'NO'       
      
   --select client_code,dispatch_date,delivered,inbunch into #pen_temp from delivered(nolock)                             
    --where dispatch_date = @temp_D and inbunch = 'NO' and delivered='PEN'                 
                
 select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)               
    where fld_delivery_date = @temp_D
                                  
    -- NO of kits dispatched                              
    set @dis = (select count(*) from #temp)                              
                                  
    -- NO of kits delivered to clients                              
    set @del = (select count(*) from delivery_ack(nolock) where                            
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and                         
    client_code in(select client_code from #temp))                   
                
 -- NO of kits delivered to branch                 
  set @delBr = (select count(*) from #temp1)                
                              
    -- NO of kits returned                              
    set @ret = (select count(*) from undelivered(nolock) where                            
    client_code in(select client_code from #temp))                              
        
   --No of kits pending        
    set @pen =(select count(*)from delivered(nolock)        
    where delivered ='PEN' and client_code in        
    (select client_code from #temp))        
                              
    -- NO of kits sent to branch / sub-broker                              
    set @stb = (select count(*) from delivered(nolock)                               
    where delivered = 'YES' and inbunch = 'YES' and client_code in                            
    (select client_code from #temp))                              
                              
     insert into TEMP_MIS                          
    values(@temp_D,@dis,@del,@delBr,@ret,@pen,@stb)                          
    drop table #temp
 drop table #temp1                  
 --drop table #pen_temp                          
  end                          
                          
 select date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,pending,inbunched from TEMP_MIS(nolock)                         
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_datewise
-- --------------------------------------------------
create proc MIS_GENERATOR_DATEWISE_N_datewise     
(@FD as datetime,                            
@TD as datetime)                            
as                            
                            
  declare @temp_D as datetime                            
  declare @dt_C as numeric(10)                            
  declare @temp_C as numeric(10)                            
                            
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                            
  --set @TD = '2007-11-1 00:00:00.000'                            
                            
  declare @dis as numeric(10) -- No. of kits dispached                            
  declare @del as numeric(10) -- No. of kits delivered               
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                            
  declare @ret as numeric(10) -- No. of kits returned                           
  declare @pen as numeric (10)--- No.of kits pending      
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                       
                           
  --print datediff(dy,@FD,@TD)                            
                            
  --set @temp_D = @FD                            
                            
  set @dt_C = datediff(dy,@FD,@TD)                            
  set @temp_C = 0                            
                            
  truncate table TEMP_MIS                            
                            
  while @dt_C >= @temp_C                            
  begin                            
    set @temp_D = dateadd(dd,@temp_C,@FD)                            
    set @temp_C = @temp_C + 1                            
                              
                                
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                           
    where dispatch_date = @temp_D and inbunch = 'NO'     
    
   select client_code,dispatch_date,delivered,inbunch into #pen_temp from delivered(nolock)                           
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='PEN'               
              
 select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)             
    where fld_date = @temp_D               
                                
    -- NO of kits dispatched                            
    set @dis = (select count(*) from #temp)                            
                                
    -- NO of kits delivered to clients                            
    set @del = (select count(*) from delivery_ack(nolock) where                          
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and                       
    client_code in(select client_code from #temp))                 
              
 -- NO of kits delivered to branch               
  set @delBr = (select count(*) from #temp1)              
                            
    -- NO of kits returned                            
    set @ret = (select count(*) from undelivered(nolock) where                          
    client_code in(select client_code from #temp))                            
      
   --No of kits pending      
    set @pen =(select count(*)from delivered(nolock)      
    where delivered ='PEN' and client_code in      
    (select client_code from #pen_temp))      
                            
    -- NO of kits sent to branch / sub-broker                            
    set @stb = (select count(*) from delivered(nolock)                             
    where delivered = 'YES' and inbunch = 'YES' and client_code in                          
    (select client_code from #temp))                            
                            
     insert into TEMP_MIS                        
    values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                        
    drop table #temp          
 drop table #pen_temp                        
  end                        
                        
 select date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched from TEMP_MIS(nolock)                       
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_Dmis
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N_Dmis                  
(@FD as datetime,                                  
@TD as datetime)                                  
as                                  
                                  
  declare @temp_D as datetime                                  
  declare @dt_C as numeric(10)                                  
  declare @temp_C as numeric(10)                                  
                                  
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                  
  --set @TD = '2007-11-1 00:00:00.000'                                  
                                  
  declare @dis as numeric(10) -- No. of kits dispached                                  
  declare @del as numeric(10) -- No. of kits delivered                     
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                  
  declare @ret as numeric(10) -- No. of kits returned                                  
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                
  declare @pen as numeric(10) -- pending kits               
                                  
  --print datediff(dy,@FD,@TD)                                  
                                  
  --set @temp_D = @FD                                  
                                  
  set @dt_C = datediff(dy,@FD,@TD)                                  
  set @temp_C = 0                                  
                                  
  truncate table temp_mis_new                                  
                                  
  while @dt_C >= @temp_C                                  
  begin                                  
    set @temp_D = dateadd(dd,@temp_C,@FD)                                  
    set @temp_C = @temp_C + 1                                  
                                    
                                      
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                 
    where dispatch_date = @temp_D and inbunch = 'NO'            
--------            
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                 
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN'           
           
    --select client_code,dispatch_date,delivered,inbunch into pen_d_1 from delivered(nolock)                                 
    --where dispatch_date >=@FD and dispatch_date <=@TD and inbunch = 'NO' and Delivered='PEN'            
          
--------                        
                    
 select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                   
    where fld_delivery_date = @temp_D                     
                                      
    -- NO of kits dispatched                                  
    set @dis = (select count(*) from #temp)                                  
                                      
    -- NO of kits delivered to clients                                  
    set @del = (select count(*) from delivery_ack(nolock) where                                
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and                             
    client_code in(select client_code from #temp))                       
                    
 -- NO of kits delivered to branch                     
  set @delBr = (select count(*) from #temp1)                    
                                  
    -- NO of kits returned                                  
    set @ret = (select count(*) from undelivered(nolock) where                                
    client_code in(select client_code from #temp))                                  
                                  
    -- NO of kits sent to branch / sub-broker                                  
    set @stb = (select count(*) from delivered(nolock)                                   
    where delivered = 'YES' and inbunch = 'YES' and client_code in                                
    (select client_code from #temp))       
            
  ----------            
------pending kits             
   set @pen = (select count(*) from #pen_d )          
-----------                                 
                                  
    insert into temp_mis_new                                    
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                  
    drop table #temp                    
    drop table #temp1            
   drop table #pen_d           
   --drop table pen_d_1                                   
  end                                  
                                  
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                 
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_Dmis_n
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N_Dmis_n                                    
(@FD as datetime,                                                    
@TD as datetime)                                                    
as                                                    
                                                    
  declare @temp_D as datetime                                                    
  declare @dt_C as numeric(10)                                                    
  declare @temp_C as numeric(10)                                                    
                                                    
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                                    
  --set @TD = '2007-11-1 00:00:00.000'                                                    
                                                    
  declare @dis as numeric(10) -- No. of kits dispached                                                    
  declare @del as numeric(10) -- No. of kits delivered                                       
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                                    
  declare @ret as numeric(10) -- No. of kits returned                                                    
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                                  
  declare @pen as numeric(10) -- pending kits                                 
                                                    
  --print datediff(dy,@FD,@TD)                                                    
                                                    
  --set @temp_D = @FD                                                    
                                                    
  set @dt_C = datediff(dy,@FD,@TD)                                                    
  set @temp_C = 0                                                    
                                                    
  truncate table temp_mis_new                                                    
                                                    
  while @dt_C >= @temp_C                                                    
  begin                                                    
    set @temp_D = dateadd(dd,@temp_C,@FD)                                                    
    set @temp_C = @temp_C + 1                                                    
                                                      
    ------Dispatch query                                                  
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                                   
    where dispatch_date = @temp_D and inbunch = 'NO'                              
    ------- Delivered query                             
    select client_code,dispatch_date,delivered,inbunch into #temp_delivered from delivered(nolock)                                                   
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='YES'                                    
   ----------- Pending query            
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                                   
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN'                    
    -------- Branch query                          
          
    --//select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                                     
    --//where fld_delivery_date = @temp_D                   
      
--new      
select distinct * into  #temp1 from Tbl_Delivered_Branch a                  
inner join                  
(select distinct * from delivered where  dispatch_date >=@temp_D and dispatch_date <=@temp_D  and delivered='BR' and inbunch='no'                  
) b                  
on a.fld_clcode=b.client_code         
      
--end      
            
                
                                 
    -- NO of kits dispatched                                                    
    set @dis = (select count(*) from #temp)                                                    
                        
    -- NO of kits delivered to clients                                                    
    set @del = (select count(*) from #temp_delivered)                            
                                      
    -- NO of kits delivered to branch                                       
    set @delBr = (select count(*) from #temp1)                                      
                                                    
    -- NO of kits returned                                                    
    set @ret = (select count(*) from undelivered(nolock) where                                                  
    client_code in(select client_code from #temp where inbunch='NO' and delivered='NO'))                                
                                               
    -- NO of kits sent to branch / sub-broker                                               
    set @stb = (select count(*) from delivered(nolock)                                                     
    where delivered = 'YES' and inbunch = 'YES' and client_code in                                                  
    (select client_code from #temp))                         
                              
    --pending kits                               
   set @pen = (select count(*) from #pen_d )                            
            
                                                
    insert into temp_mis_new                                                      
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                                    
    drop table #temp                                      
    drop table #temp1                              
   drop table #pen_d                
   drop table #temp_delivered                                
   --drop table pen_d_1                                                     
  end                                                    
                                                    
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                                   
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_Dmis_new
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N_Dmis_new                                       
(@FD as varchar(25),                                                        
@TD as varchar(25))                                                        
as          
  
set @FD=convert(datetime,@FD,103)                                                
set @TD=convert(datetime,@TD,103)  
                                                        
  declare @temp_D as varchar(25)                                                        
  declare @dt_C as numeric(10)                                                        
  declare @temp_C as numeric(10)

set @temp_D=convert(datetime,@temp_D,103)                                                
                                                        
                                                        
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                                        
  --set @TD = '2007-11-1 00:00:00.000'                                                        
                                                        
  declare @dis as numeric(10) -- No. of kits dispached                                                        
  declare @del as numeric(10) -- No. of kits delivered                                           
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                                        
  declare @ret as numeric(10) -- No. of kits returned                                                        
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                                      
  declare @pen as numeric(10) -- pending kits                                     
                                                        
  --print datediff(dy,@FD,@TD)                                                        
                                                        
  --set @temp_D = @FD                                                        
                                                        
  set @dt_C = datediff(dy,@FD,@TD)                                                        
  set @temp_C = 0                                                        
                                                        
  truncate table temp_mis_new                                                        
                                                        
  while @dt_C >= @temp_C                                                        
  begin                                                        
    set @temp_D = dateadd(dd,@temp_C,@FD)                                                        
    set @temp_C = @temp_C + 1                                                        
                                                          
    ------Dispatch query                                                      
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO'                                  
    ------- Delivered query                                 
    select client_code,dispatch_date,delivered,inbunch into #temp_delivered from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='YES'                                        
   ----------- Pending query                
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN'                        
    -------- Branch query                              
              
    --//select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                                         
    --//where fld_delivery_date = @temp_D                       
          
--new          
select distinct * into  #temp1 from Tbl_Delivered_Branch a                      
inner join                      
(select distinct * from delivered where  dispatch_date >=@temp_D and dispatch_date <=@temp_D  and delivered='BR' and inbunch='no'                      
) b                      
on a.fld_clcode=b.client_code             
          
--end          
                
                    
                                     
    -- NO of kits dispatched                                                        
    set @dis = (select count(*) from #temp)                                                        
                            
    -- NO of kits delivered to clients                                                        
    set @del = (select count(*) from #temp_delivered)                                
                                          
    -- NO of kits delivered to branch                                           
    set @delBr = (select count(*) from #temp1)                                          
                                                        
    -- NO of kits returned                                                        
    set @ret = (select count(*) from undelivered(nolock) where                                                      
    client_code in(select client_code from #temp where inbunch='NO' and delivered='NO'))                                    
                                                   
    -- NO of kits sent to branch / sub-broker                                                   
    set @stb = (select count(*) from delivered(nolock)                                                         
    where delivered = 'YES' and inbunch = 'YES' and client_code in                                                      
    (select client_code from #temp))                             
                                  
    --pending kits                                   
   set @pen = (select count(*) from #pen_d )                                
                
                                                    
    insert into temp_mis_new                                                          
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                                        
    drop table #temp                                          
    drop table #temp1                                  
   drop table #pen_d                    
   drop table #temp_delivered                                    
   --drop table pen_d_1                                                         
  end                                                        
                                                        
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                                       
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_N_new
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_N_new          
(@FD as datetime,                  
@TD as datetime)                  
as                  
                  
  declare @temp_D as datetime                  
  declare @dt_C as numeric(10)                  
  declare @temp_C as numeric(10)                  
                  
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                  
  --set @TD = '2007-11-1 00:00:00.000'                  
                  
  declare @dis as numeric(10) -- No. of kits dispached                  
  declare @del as numeric(10) -- No. of kits delivered     
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                  
  declare @ret as numeric(10) -- No. of kits returned                  
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                  
                  
  --print datediff(dy,@FD,@TD)                  
                  
  --set @temp_D = @FD                  
                  
  set @dt_C = datediff(dy,@FD,@TD)                  
  set @temp_C = 0                  
                  
  truncate table TEMP_MIS                  
                  
  while @dt_C >= @temp_C                  
  begin                  
    set @temp_D = dateadd(dd,@temp_C,@FD)                  
    set @temp_C = @temp_C + 1                  
                    
                      
    select client_code,dispatch_date,delivered,inbunch,pod into #temp from delivered                  
    where dispatch_date = @temp_D and inbunch = 'NO'     
    
 select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch    
    where Fld_date = @temp_D     
                      
    -- NO of kits dispatched                  
    set @dis = (select count(*) from #temp)                  
                      
    -- NO of kits delivered to clients                  
    set @del = (select count(*) from delivery_ack where                
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and             
    client_code in(select client_code from #temp))       
    
 -- NO of kits delivered to branch     
  set @delBr = (select count(*) from #temp1)    
                  
    -- NO of kits returned                  
    set @ret = (select count(*) from undelivered where                
    client_code in(select client_code from #temp))                  
                  
    -- NO of kits sent to branch / sub-broker                  
    set @stb = (select count(*) from delivered                   
    where delivered = 'YES' and inbunch = 'YES' and client_code in                
    (select client_code from #temp))                  
                  
    insert into TEMP_MIS                  
    values(@temp_D,@dis,@del,@ret,@stb,@delBr)                  
    drop table #temp    
 drop table #temp1                  
  end                  
                  
 select date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched from TEMP_MIS                  
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_DATEWISE_new
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_DATEWISE_new     
(@FD as datetime,              
@TD as datetime)              
as              
              
  declare @temp_D as datetime              
  declare @dt_C as numeric(10)              
  declare @temp_C as numeric(10)              
              
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd              
  --set @TD = '2007-11-1 00:00:00.000'              
              
  declare @dis as numeric(10) -- No. of kits dispached              
  declare @del as numeric(10) -- No. of kits delivered              
  declare @ret as numeric(10) -- No. of kits returned              
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker              
              
  --print datediff(dy,@FD,@TD)              
              
  --set @temp_D = @FD              
              
  set @dt_C = datediff(dy,@FD,@TD)              
  set @temp_C = 0              
              
  truncate table TEMP_MIS              
              
  while @dt_C >= @temp_C              
  begin              
    set @temp_D = dateadd(dd,@temp_C,@FD)              
    set @temp_C = @temp_C + 1              
                
                  
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered              
    where dispatch_date = @temp_D and inbunch = 'NO'             
                  
    -- NO of kits dispatched              
    set @dis = (select count(*) from #temp)              
                  
    -- NO of kits delivered              
    set @del = (select count(*) from delivery_ack where            
 --set @del = (select count(*) from delivered (nolock) where delivered = 'YES' and inbunch = 'NO' and         
    client_code in(select client_code from #temp))              
              
    -- NO of kits returned              
    set @ret = (select count(*) from undelivered where            
    client_code in(select client_code from #temp))              
              
    -- NO of kits sent to branch / sub-broker              
    set @stb = (select count(*) from delivered               
    where delivered = 'YES' and inbunch = 'YES' and client_code in            
    (select client_code from #temp))              
              
    insert into TEMP_MIS              
    values(@temp_D,@dis,@del,@ret,@stb)              
    drop table #temp              
  end              
              
 select date=convert(varchar(12),date,103),dispatched,delivered,returned,inbunched from TEMP_MIS              
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR_MAIN
-- --------------------------------------------------
CREATE proc MIS_GENERATOR_MAIN
(@FD as datetime,        
@TD as datetime)
as        
        
select client_code,dispatch_date,delivered,inbunch into #temp from delivered
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO'

select status=reason_undelivered,count=count(*) into #t from undelivered
where client_code in(select client_code from #temp) group by reason_undelivered


select status='DELIVERED',count=count(*) from #temp where delivered = 'YES'
union all
select status=a.reason,count=(case when b.count is null then '0' else b.count end)
from return_remarks a left outer join #t b on a.reason = b.status

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIS_GENERATOR1
-- --------------------------------------------------
CREATE proc MIS_GENERATOR1    
(@FD as datetime,    
@TD as datetime)    
as    
    
  declare @temp_D as datetime    
  declare @dt_C as numeric(10)    
  declare @temp_C as numeric(10)    
    
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd    
  --set @TD = '2007-11-1 00:00:00.000'    
    
  declare @dis as numeric(10) -- No. of kits dispached    
  declare @del as numeric(10) -- No. of kits delivered    
  declare @ret as numeric(10) -- No. of kits returned    
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker    
    
  --print datediff(dy,@FD,@TD)    
    
  --set @temp_D = @FD    
    
  set @dt_C = datediff(dy,@FD,@TD)    
  set @temp_C = 0    
    
  truncate table TEMP_MIS    
    
  while @dt_C >= @temp_C    
  begin    
    set @temp_D = dateadd(dd,@temp_C,@FD)    
    set @temp_C = @temp_C + 1    
      
        
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered    
    where dispatch_date = @temp_D and inbunch = 'NO'   
        
    -- NO of kits dispatched    
    set @dis = (select count(*) from #temp)    
        
    -- NO of kits delivered    
    set @del = (select count(*) from delivery_ack where  
    client_code in(select client_code from #temp))    
    
    -- NO of kits returned    
    set @ret = (select count(*) from undelivered where  
    client_code in(select client_code from #temp))    
    
    -- NO of kits sent to branch / sub-broker    
    set @stb = (select count(*) from delivered     
    where delivered = 'YES' and inbunch = 'YES' and client_code in  
    (select client_code from #temp))    
    
    insert into TEMP_MIS    
    values(@temp_D,@dis,@del,@ret,@stb)    
    drop table #temp    
  end    
    
 select date=convert(varchar(12),date,103),dispatched,delivered,returned,inbunched from TEMP_MIS    
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Procname
-- --------------------------------------------------
CREATE proc [dbo].[Procname]
(                
@filename as varchar(100)                      
)                  
as    
declare @path as varchar(100)                            
declare @sql as varchar(1000)      
truncate table tbl_Vanishing_company    
/*set @path='d:\upload1\'+ @filename   */
set @path='I:\upload1\'+ @filename   
           
SET @SQL = 'insert into mis_diverse_dispatch select * FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [sheet1$]'' )'     
--print @SQL                    
exec (@sql)

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
-- PROCEDURE dbo.Sent_BGMail
-- --------------------------------------------------
CREATE procedure Sent_BGMail                         
as   
declare @cntstr int 
declare @dispatch_date as varchar(15)
select @dispatch_date=max(dispatch_Date) from delivered
--@fld_date =select max(dispatch_date)from delivered
--select  @cntstr =  count(*) from  MCDX_BG_15DayExpiry  
--print @cntstr  
  
--select  @cntstr =  count(*) Tbl_Delivered_Branch    
--print @cntstr  
  
--if @cntstr > 0   
                         
begin      
declare @fld_clcode varchar(12),@fld_clname varchar (200), @company varchar (200),@POD varchar (200),@fld_Branch varchar(200),@fld_sbcode varchar(200),@fld_date as varchar(12),@delivered as varchar(2000),@InvokeDate as varchar(400),
@mess as varchar(2000),@str as varchar(400),@mess1 as varchar(5000)      
        
        
set @mess = ''    
set @mess1 = ''    
set @mess = @mess + '<html><head>'                                  
set @mess = @mess + '</head>'          
set @mess= @mess + '<body>'          
      
set @mess= @mess + 'Dear Sir,<br><br>'                         
set @mess = @mess +'Below mentioned Bank Guarantee is likely to get expired in the next 15 days. '    
set @mess = @mess +'<br>Please do the needful to take the necessary action.'     
set @mess = @mess + '<br><br></p>'     
                             
set @mess = @mess +'<br><table width = ''850''  border=1 cellspacing=0 style="font-family:tahoma;font-size:10px;">'       
set @mess = @mess + '<tr><td><strong>CLIENT CODE</td><td><strong>CLIENT NAME</td><td><strong>COMPANY</td><td><strong>POD</td><td><strong>BRANCH CODE</td><td><strong>SUB BROKER CODE</td><td><strong>DISPATCH DATE</td><td><strong>DELIVERED</td><td><strong>INVOKE DATE</td></tr>'                 
set @mess1 = @mess1 + '</table><br><br>'                 
 
set @mess1 = @mess1 + 'This is an automated intimation email. Please do not reply.<br/><br/>'    
set @mess1 = @mess1 +'From <br>'    
set @mess1 = @mess1 +'Angel Broking <br>'    
set @mess1 = @mess1 +'Software Department <br>'    
set @mess1 = @mess1 +'Mumbai <br>'    
set @mess1 = @mess1 + '</body>'        
set @mess1 = @mess1 + '</html>'            

-- declare @pcode varchar(12),@bankcode varchar(200),@brcode varchar(200),@bgno varchar(200),@Amount varchar(200),@Idate as varchar(12),@R1date as varchar(12),@R2date as varchar(12),@Mdate as varchar(12),@mess as varchar(800),@str as varchar(400),@mess1  
 
--as varchar(400)      
                         
DECLARE sent_bgmail CURSOR FOR       
          
--select fld_clcode,fld_clname,fld_branch,fld_sbcode,fld_date,fld_reason,fld_br_remark
--from intranet.nsecourier.dbo.Tbl_Delivered_Branch   

select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) from hist_temp_offlinemaster  a(nolock)
 inner join (select Client_Code=client_code,Name=client_name,
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),
Delivered from delivered(nolock) where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b 
on a.cl_code=b.client_code  order by Dispatch_Date

 
--from test_1    
         
OPEN sent_bgmail                                                                              
                                                                              
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
    
    
WHILE @@FETCH_STATUS = 0                                                                              
BEGIN                
                    
set @mess = @mess+'<tr><td>'+@fld_clcode+'</td><td>'+@fld_clname+'</td><td>'+@company+'</td><td>'+@POD+'</td><td>'+@fld_Branch+'</td><td>'+@fld_sbcode+'</td><td>'+@fld_date+'</td><td>'+@delivered+'</td><td>'+@InvokeDate+'</td></tr>'                        
   
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
     
--print @pcode     
    
END     
       
set @mess=@mess+@mess1        
    
print @mess    
exec mis.master.dbo.xp_smtp_sendmail         
      
 @TO =  'Megha.Wangane@angeltrade.com',   
@from ='Megha.Wangane@angeltrade.com',
 @type='text/html',                          
 @subject = 'Bank Guarantee Expiring in next 15 days',                                   
 @server = 'angelmail.angelbroking.com',                                  
 @message=@mess         
                                                           
CLOSE sent_bgmail                                                                  
DEALLOCATE sent_bgmail   
  		
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_branch_upload
-- --------------------------------------------------

CREATE proc sp_branch_upload                             
(                                                          
@client_code varchar(20),                                                          
@disdate datetime,                                        
@reason varchar(50)                                        
)                                                          
as                                                          
declare @remark varchar(500)                                                          
declare @branch_cd varchar(20)                               
declare @sb_code varchar(20)                                                          
declare @name varchar(20)             
declare @pod varchar(50)             
declare @mode varchar(50)                                      
declare @company varchar(70)                                        
declare @cnt1 numeric(5)                                                          
declare @cnt2 numeric(5)                                                  
declare @cnt3 numeric(5)                                                  
declare @cnt4 numeric(5)                                                  
declare @flag1 numeric(1)                                                          
declare @flag2 numeric(1)                                                  
declare @flag3 numeric(1)                                                  
declare @flag4 numeric(1)                                                 
declare @str varchar(50)                                                   
                                                          
set @flag1 = 0                                                          
set @flag2 = 0                                                          
set @flag3 = 0                                            
set @flag4 = 0                                      
set @str = ''                                                       
                                
select note='RECORD ADDED SUCCESSFULLY                                    ' into #temp                                          
                                          
                        
set @cnt1 = (select count(client_code) from delivered(nolock)where client_code=@client_code)                                                          
if @cnt1=0                                                           
begin                                                          
set @str = 'KIT IS NOT DISPATCHED YET.'                                       
set @flag1 = 1                                           
update #temp set note=@str                                          
select note from #temp                                          
return                                          
end                                               
                                          
set @cnt2 = (select count(fld_clcode) from Tbl_Delivered_Branch(nolock)where fld_clcode=@client_code)                                                          
if @cnt2>0                                                          
begin                                                          
 set @str = 'KIT IS ALREADY DISPATCHED TO BRANCH.'                                        
                                    
 set @flag2 = 1                                       
 select note from #temp                                          
 return                                          
end                                                          
                                        
set @cnt3 = (select count(pod) from delivered(nolock)where client_code = @client_code)                                        
if @cnt3=0                                                          
begin                                                          
 set @str = 'KIT CANNOT BE RETURNED BEFORE DISPATCH.'            
                                 
 set @flag3 = 1                                           
update #temp set note=@str                      
 select note from #temp                                          
 return              
end                                                          
                        
set @cnt4 = (select count(*) from return_remarks(nolock)where reason = @reason)                        
if @cnt4=0                                                          
begin                                                          
 set @str = 'INVALID STATUS.'            
                    
 set @flag4 = 1                                           
update #temp set note=@str                             
 select note from #temp                                          
 return                                       
end                                                                  
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0 and @flag4 = 0                       
begin                                                          
                                        
 select @branch_cd=branch_cd, @name=client_name, @sb_code=sb_code,@pod=pod,@mode=surface_zone,@company=cour_compn_name from delivered(nolock)                                        
 where client_code=@client_code                                                          
                              
                          
                                        
set @remark = (select top 1 remark from return_remarks(nolock)where reason = @reason)                                        
                                        
 insert into Tbl_Delivered_Branch values                                                          
 (@client_code,@name,@pod,@company,@branch_cd,@sb_code,@reason,@mode,'0-250','8.00',convert(datetime,convert(varchar(11),getdate())),@disdate,'')                                        
            
 update delivered set delivered = 'BR' where client_code = @client_code                                     
                                           
 select note from #temp                                  
 return                                         
                                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_branch_upload_newm
-- --------------------------------------------------
CREATE proc sp_branch_upload_newm                               
(                                                            
@client_code varchar(20),                                                            
@disdate datetime,                                          
@reason varchar(50)                                          
)                                                            
as                                                            
declare @remark varchar(500)                                                            
declare @branch_cd varchar(20)                                 
declare @sb_code varchar(20)                                                            
declare @name varchar(20)               
declare @pod varchar(50)               
declare @mode varchar(50)                                        
declare @company varchar(70)                                          
declare @cnt1 numeric(5)                                                            
declare @cnt2 numeric(5)                                                    
declare @cnt3 numeric(5)                                                    
declare @cnt4 numeric(5)                                                    
declare @flag1 numeric(1)                                                            
declare @flag2 numeric(1)                                                    
declare @flag3 numeric(1)                                                    
declare @flag4 numeric(1)                                                   
declare @str varchar(50)                                                     
                                                            
set @flag1 = 0                                                            
set @flag2 = 0                                                            
set @flag3 = 0                                              
set @flag4 = 0                                        
set @str = ''                                                         
                                  
select note='RECORD ADDED SUCCESSFULLY                                    ' into #temp                                            
                                            
                          
set @cnt1 = (select count(client_code) from delivered(nolock)where client_code=@client_code)                                                            
if @cnt1=0                                                             
begin                                                            
set @str = 'KIT IS NOT DISPATCHED YET.'                                         
set @flag1 = 1                                             
update #temp set note=@str                                            
select note from #temp                                            
return                                            
end                                                 
                                            
set @cnt2 = (select count(fld_clcode) from Tbl_Delivered_Branch(nolock)where fld_clcode=@client_code)                                                            
if @cnt2>0                                                            
begin                                                            
 set @str = 'KIT IS ALREADY DISPATCHED TO BRANCH.'                                          
                                      
 set @flag2 = 1                                         
 select note from #temp                                            
 return                                            
end                                                            
                                          
set @cnt3 = (select count(pod) from delivered(nolock)where client_code = @client_code)                                          
if @cnt3=0                                                            
begin                                                            
 set @str = 'KIT CANNOT BE RETURNED BEFORE DISPATCH.'              
             
 set @flag3 = 1                                             
update #temp set note=@str                        
 select note from #temp                                            
 return                
end                                                            
                          
set @cnt4 = (select count(*) from return_remarks(nolock)where reason = @reason)                          
if @cnt4=0                                                            
begin                                                            
 set @str = 'INVALID STATUS.'              
                      
 set @flag4 = 1                                             
update #temp set note=@str                               
 select note from #temp                                            
 return                                         
end                                                                    
if @flag1 = 0 and @flag2 = 0 and @flag3 = 0 and @flag4 = 0                         
begin                                                            
                                          
 select @branch_cd=branch_cd, @name=client_name, @sb_code=sb_code,@pod=pod,@mode=surface_zone,@company=cour_compn_name from delivered(nolock)                                          
 where client_code=@client_code                                                            
                                
                            
                                          
set @remark = (select top 1 remark from return_remarks(nolock)where reason = @reason)                                          
                                          
 insert into Tbl_Delivered_Branch values                                                            
 (@client_code,@name,@pod,@company,@branch_cd,@sb_code,@reason,@mode,'0-250','8.00',convert(datetime,convert(varchar(11),getdate())),@disdate,'')                                          
              
 update delivered set delivered = 'BR' where client_code = @client_code                                       
                                             
 select note from #temp                                    
 return                                           
                                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_inbunchbilling_branch
-- --------------------------------------------------
CREATE proc sp_inbunchbilling_branch         
(@fdt as datetime,              
@tdt as datetime)              
as              
              
select convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,      
dispatch_date into #temp_branch from delivered where        
inbunch = 'YES' and dispatch_date >= @fdt and dispatch_date <= @tdt order by dispatch_date desc             
              
select branch_cd,count(*)count,Rate= sum(bank_rate)  from #temp_branch group by branch_cd              
              
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_inbunchbilling_branch_n
-- --------------------------------------------------
CREATE proc sp_inbunchbilling_branch_n           
(@fdt as varchar(15),                
@tdt as varchar(15))                
as                
                
select convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,        
dispatch_date into #temp_branch from delivered where          
inbunch = 'YES' and dispatch_date >= convert(datetime,@fdt,103) and dispatch_date <= convert(datetime,@tdt,103) order by dispatch_date desc               
                
select branch_cd,count(*)count,Rate= sum(bank_rate)  from #temp_branch group by branch_cd                
                
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_inbunchbilling_courier
-- --------------------------------------------------
CREATE proc sp_inbunchbilling_courier      
(@fdt as datetime,                  
@tdt as datetime)                  
as                  
                  
          
               
/*                  
select cour_compn_name,pod,count(*)count,Rate= sum(bank_rate) into #t from delivered where            
inbunch = 'YES' and dispatch_date >= '01/01/2009' and dispatch_date <= '01/31/2009' group by cour_compn_name,pod            
  
select distinct cour_compn_name,count(*)count,Rate=sum(rate) from #t group by cour_compn_name  
*/

select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,count(*)count,weight,bank_Rate,
convert(varchar(11),dispatch_date,103) as dispatch_date  into  #temp from  delivered where
inbunch = 'YES' 
and dispatch_date >= @fdt and dispatch_date <= @tdt group by pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,dispatch_date


select cour_compn_name,count(*)count,rate=sum(bank_rate) from #temp group by cour_compn_name 
                  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_inbunchbilling_courier_ind
-- --------------------------------------------------
CREATE proc sp_inbunchbilling_courier_ind            
(@fdt as datetime,                      
@tdt as datetime,              
@company as varchar(50))                      
as                      
                      
        
/*select cour_compn_name,count(*)count,Rate= sum(bank_rate)  from delivered where              
inbunch = 'YES' and dispatch_date >= @fdt and dispatch_date <= @tdt and cour_compn_name =@company group by cour_compn_name  
*/


select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,count(*)count,weight,bank_Rate,
convert(varchar(11),dispatch_date,103) as dispatch_date  into #temp from  delivered where
cour_compn_name =@company and inbunch = 'YES' 
and dispatch_date >= @fdt and dispatch_date <= @tdt group by pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,dispatch_date


select cour_compn_name,count(*)count,rate=sum(bank_rate) from #temp group by cour_compn_name 
                      
return                 
      
  



  
                      
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_inbunchbilling_courier_n
-- --------------------------------------------------
CREATE proc sp_inbunchbilling_courier_n                
(@fdt as varchar(15),                            
@tdt as varchar(15),
@company as varchar(50))                            
as                        
                            
/*                            
select cour_compn_name,pod,count(*)count,Rate= sum(bank_rate) into #t from delivered where                      
inbunch = 'YES' and dispatch_date >= '01/01/2009' and dispatch_date <= '01/31/2009' group by cour_compn_name,pod                          
select distinct cour_compn_name,count(*)count,Rate=sum(rate) from #t group by cour_compn_name            
*/         
        
select distinct convert(numeric,pod) as pod,branch_cd,cour_compn_name,surface_zone,count(*)count,weight,bank_Rate,          
convert(varchar(11),dispatch_date,103) as dispatch_date  into #temp from  delivered where          
inbunch = 'YES'  and dispatch_date >= convert(datetime,@fdt,103) and dispatch_date <= convert(datetime,@tdt,103) and cour_compn_name=@company group by pod,branch_cd,cour_compn_name,surface_zone,weight,bank_rate,dispatch_date            
order by dispatch_date
          
select cour_compn_name,count(*)count,rate=sum(bank_rate) from #temp group by cour_compn_name                               
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis_angel
-- --------------------------------------------------
CREATE proc sp_MIS_GENERATOR_COURIERWISE_N_Cmis_N_mis_angel                                                                 
(@FD as datetime,                                                                            
@TD as datetime,           
@Company as varchar(50))                                                                            
as                                                           

select distinct * into #temp from delivered(nolock)                                                                           
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'yes' and cour_compn_name=@Company                           

                                  
 select distinct * into #Pen_rec from delivered(nolock)                                                                            
 where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='PEN'  and cour_compn_name=@Company        
        
        
select distinct * into  #temp1 from Tbl_Delivered_Branch a        
inner join        
(select distinct * from delivered where  dispatch_date >=@FD and dispatch_date <=@TD  and delivered='BR' and inbunch='no'        
and cour_compn_name=@company) b        
on a.fld_clcode=b.client_code       
                      
select distinct * into #temp_ret from delivered(nolock)                                                                          
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered <>'BR' and cour_compn_name=@Company                                                     
                                       
                                                                        
                                                                                
select distinct cour_compn_name,dispatched=count(*) into #t1 from #temp group by cour_compn_name                                                                        
                                                                        
select cour_compn_name,delivered=count(*) into #t2  from delivered                                                                            
where dispatch_date >= @FD and dispatch_date <= @TD and inbunch = 'NO' and delivered='YES' group by cour_compn_name                                                    
                                                                
                                                           
 select distinct cour_compn_name,deliveredBr = count(*) into #t5 from #temp1 group by cour_compn_name  -- Delivered to Branch                                                                
                                                                        
                                                                        
select distinct cour_compn_name,returned=count(*) into #t3 from #temp_ret where client_code in       -- Returned                                                                        
(select client_code from undelivered(nolock)) group by cour_compn_name                                                                        
                                                                        
                                                                        
select distinct cour_compn_name,inbunched=count(*) into #t4 from delivered(nolock)                       -- SENT TO BRANCH                                                                        
where inbunch = 'YES' and delivered = 'YES' and client_code in                                                                        
(select client_code from #temp) group by cour_compn_name                                        
                                        
------ pending kits                                      
select distinct cour_compn_name,Pending=count(*) into #pen from #Pen_rec group by cour_compn_name       
                                                      
------end kits                                         
                                                                        
                                                                        
select a.cour_compn_name,                                                                        
dispatched=(case when a.dispatched is null then '0' else a.dispatched end),                                                                
delivered=(case when b.delivered is null then '0' else b.delivered end),                                                                
deliveredBr =(case when e.deliveredBr is null then '0' else e.deliveredBr end),                                                                      
returned=(case when c.returned is null then '0' else c.returned end),                                                                        
inbunched=(case when d.inbunched is null then '0' else d.inbunched end),                                        
Pending=(case when f.Pending is null then '0' else f.Pending end)                          
                                                                      
from #t1 a left outer join #t2 b on a.cour_compn_name=b.cour_compn_name                                                                
left outer join #t3 c on a.cour_compn_name=c.cour_compn_name left outer join #t4 d                                                                         
on a.cour_compn_name = d.cour_compn_name left outer join #t5 e on a.cour_compn_name = e.cour_compn_name                                        
left outer join #pen f on a.cour_compn_name = f.cour_compn_name                                                               
order by a.cour_compn_name                                                                        
                                                                            
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MIS_GENERATOR_DATEWISE_N_Dmis_n
-- --------------------------------------------------
CREATE proc sp_MIS_GENERATOR_DATEWISE_N_Dmis_n                                
(@FD as datetime,                                                
@TD as datetime,        
@Company as varchar(50))                                                  
as                                                
                                                
  declare @temp_D as datetime                                                
  declare @dt_C as numeric(10)                                                
  declare @temp_C as numeric(10)                                                
                                                
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                                
  --set @TD = '2007-11-1 00:00:00.000'                                                
                                                
  declare @dis as numeric(10) -- No. of kits dispached                                                
  declare @del as numeric(10) -- No. of kits delivered                                   
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                                
  declare @ret as numeric(10) -- No. of kits returned                                                
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                              
  declare @pen as numeric(10) -- pending kits                             
                                                
  --print datediff(dy,@FD,@TD)                                                
                                                
  --set @temp_D = @FD                                                
                                                
  set @dt_C = datediff(dy,@FD,@TD)                                                
  set @temp_C = 0                                                
                                                
  truncate table temp_mis_new                                                
                                                
  while @dt_C >= @temp_C                                                
  begin                                                
    set @temp_D = dateadd(dd,@temp_C,@FD)                                                
    set @temp_C = @temp_C + 1                                                
                                                  
    ------Dispatch query                                              
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'NO' and cour_compn_name=@Company                         
    ------- Delivered query                         
    select client_code,dispatch_date,delivered,inbunch into #temp_delivered from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='YES'  and cour_compn_name=@Company                                
   ----------- Pending query        
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN' and cour_compn_name=@Company                 
    -------- Branch query                      
  --  select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                                 
    --where fld_delivery_date = @temp_D  and fld_company=@Company            
        
 select distinct * into  #temp1 from Tbl_Delivered_Branch a                    
inner join                    
(select distinct * from delivered where  dispatch_date >=@temp_D and dispatch_date <=@temp_D  and delivered='BR' and inbunch='no'                    
) b                    
on a.fld_clcode=b.client_code  and  fld_company=@Company                        
                                                    
    -- NO of kits dispatched                                                
    set @dis = (select count(*) from #temp)                                                
                                                    
    -- NO of kits delivered to clients                                                
    set @del = (select count(*) from #temp_delivered)          
                                  
    -- NO of kits delivered to branch                                   
    set @delBr = (select count(*) from #temp1)                                  
                                                
    -- NO of kits returned                                                
    set @ret = (select count(*) from undelivered(nolock) where                                              
    client_code in(select client_code from #temp where inbunch='NO' and delivered='NO'))                            
                                           
    -- NO of kits sent to branch / sub-broker                                           
    set @stb = (select count(*) from delivered(nolock)                                                 
    where delivered = 'YES' and inbunch = 'YES' and client_code in                                              
    (select client_code from #temp))                     
                          
    --pending kits                           
   set @pen = (select count(*) from #pen_d )                        
        
                                            
    insert into temp_mis_new                                                  
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                                
    drop table #temp                                  
    drop table #temp1                          
   drop table #pen_d            
   drop table #temp_delivered                            
   --drop table pen_d_1                                                 
  end                                                
                                                
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                               
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MIS_GENERATOR_DATEWISE_N_Dmis_n_angel
-- --------------------------------------------------
CREATE proc sp_MIS_GENERATOR_DATEWISE_N_Dmis_n_angel                                
(@FD as datetime,                                                
@TD as datetime,        
@Company as varchar(50))                                                  
as                                                
                                                
  declare @temp_D as datetime                                                
  declare @dt_C as numeric(10)                                                
  declare @temp_C as numeric(10)                                                
                                                
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                                
  --set @TD = '2007-11-1 00:00:00.000'                                                
                                                
  declare @dis as numeric(10) -- No. of kits dispached                                                
  declare @del as numeric(10) -- No. of kits delivered                                   
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                                
  declare @ret as numeric(10) -- No. of kits returned                                                
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                              
  declare @pen as numeric(10) -- pending kits                             
                                                
  --print datediff(dy,@FD,@TD)                                                
                                                
  --set @temp_D = @FD                                                
                                                
  set @dt_C = datediff(dy,@FD,@TD)                                                
  set @temp_C = 0                                                
                                                
  truncate table temp_mis_new                                                
                                                
  while @dt_C >= @temp_C                                                
  begin                                                
    set @temp_D = dateadd(dd,@temp_C,@FD)                                                
    set @temp_C = @temp_C + 1                                                
                                                  
    ------Dispatch query                                              
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'yes' and cour_compn_name=@Company                         
    ------- Delivered query                         
    select client_code,dispatch_date,delivered,inbunch into #temp_delivered from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='YES'  and cour_compn_name=@Company                                
   ----------- Pending query        
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                               
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN' and cour_compn_name=@Company                 
    -------- Branch query                      
    select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                                 
    where fld_delivery_date = @temp_D  and fld_company=@Company            
        
            
                                                    
    -- NO of kits dispatched                                                
    set @dis = (select count(*) from #temp)                                                
                                                    
    -- NO of kits delivered to clients                                                
    set @del = (select count(*) from #temp_delivered)          
                                  
    -- NO of kits delivered to branch                                   
    set @delBr = (select count(*) from #temp1)                                  
                                                
    -- NO of kits returned                                                
    set @ret = (select count(*) from undelivered(nolock) where                                              
    client_code in(select client_code from #temp))                            
                                           
    -- NO of kits sent to branch / sub-broker                                           
    set @stb = (select count(*) from delivered(nolock)                                                 
    where delivered = 'YES' and inbunch = 'YES' and  cour_compn_name='angel broking ltd' and  client_code in                                              
    (select client_code from #temp))                     
                          
    --pending kits                           
   set @pen = (select count(*) from #pen_d )                        
        
                                            
    insert into temp_mis_new                                                  
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                                
    drop table #temp                                  
    drop table #temp1                          
   drop table #pen_d            
   drop table #temp_delivered                            
   --drop table pen_d_1                                                 
  end                                                
                                                
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                               
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MIS_GENERATOR_DATEWISE_N_Dmis_new
-- --------------------------------------------------
CREATE proc sp_MIS_GENERATOR_DATEWISE_N_Dmis_new                                       
(    
@FD as varchar(25),                                                        
@TD as varchar(25),                
@Company as varchar(50)     
)                                                          
as                     
      
set @FD=convert(datetime,@FD,103)      
set @TD=convert(datetime,@TD,103)                                         
                                                        
  declare @temp_D as datetime                                                        
  declare @dt_C as numeric(10)                                                        
  declare @temp_C as numeric(10)                                                        
                                                        
  --set @FD = '2007-10-1 00:00:00.000' -- yyyy-mm-dd                                                        
  --set @TD = '2007-11-1 00:00:00.000'                                                        
                                                        
  declare @dis as numeric(10) -- No. of kits dispached                                                        
  declare @del as numeric(10) -- No. of kits delivered                                           
  declare @delBr as numeric(10) -- No. of kits delivered to Branch                                                        
  declare @ret as numeric(10) -- No. of kits returned                                                        
  declare @stb as numeric(10) -- No. of kits send to branch / sub-broker                                      
  declare @pen as numeric(10) -- pending kits                                     
                                                        
  --print datediff(dy,@FD,@TD)                                                        
                                                        
  --set @temp_D = @FD                                                        
                                                        
  set @dt_C = datediff(dy,@FD,@TD)                                                        
  set @temp_C = 0                                                        
                                                        
  truncate table temp_mis_new                                                        
                                                        
  while @dt_C >= @temp_C                                                        
  begin                                                        
    set @temp_D = dateadd(dd,@temp_C,@FD)                                                        
    set @temp_C = @temp_C + 1                                                        
                                                          
    ------Dispatch query                                                      
    select client_code,dispatch_date,delivered,inbunch into #temp from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO' and cour_compn_name=@Company                                 
    ------- Delivered query                                 
    select client_code,dispatch_date,delivered,inbunch into #temp_delivered from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO' and delivered='YES'  and cour_compn_name=@Company                                        
   ----------- Pending query                
    select client_code,dispatch_date,delivered,inbunch into #pen_d from delivered(nolock)                                                       
    where dispatch_date = @temp_D and inbunch = 'NO' and Delivered='PEN' and cour_compn_name=@Company                         
    -------- Branch query                              
  --  select fld_Clcode,Fld_date into #temp1 from Tbl_Delivered_Branch(nolock)                                  
    --where fld_delivery_date = @temp_D  and fld_company=@Company               
                
 select distinct * into  #temp1 from Tbl_Delivered_Branch a                            
inner join                            
(select distinct * from delivered where  dispatch_date >=@temp_D and dispatch_date <=@temp_D  and delivered='BR' and inbunch='no'                            
) b                            
on a.fld_clcode=b.client_code  and  fld_company=@Company                                
                                                            
    -- NO of kits dispatched                                                        
    set @dis = (select count(*) from #temp)                                                        
                                                            
    -- NO of kits delivered to clients                                                        
    set @del = (select count(*) from #temp_delivered)                  
                                          
    -- NO of kits delivered to branch                                           
    set @delBr = (select count(*) from #temp1)                                          
                                                        
    -- NO of kits returned                                                        
    set @ret = (select count(*) from undelivered(nolock) where                                                      
    client_code in(select client_code from #temp where inbunch='NO' and delivered='NO'))                                    
                                                   
    -- NO of kits sent to branch / sub-broker                                                   
    set @stb = (select count(*) from delivered(nolock)                                                         
    where delivered = 'YES' and inbunch = 'YES' and client_code in                                                      
    (select client_code from #temp))                             
                                  
    --pending kits                                   
   set @pen = (select count(*) from #pen_d )                                
                
                                                    
    insert into temp_mis_new                                                          
 values(@temp_D,@dis,@del,@ret,@stb,@delBr,@pen)                                                        
    drop table #temp                                          
    drop table #temp1                                  
   drop table #pen_d                    
   drop table #temp_delivered                                    
   --drop table pen_d_1                                                         
  end                                                        
                                                        
 select distinct date=convert(varchar(12),date,103),dispatched,delivered,deliveredBr,returned,inbunched,pending from temp_mis_new(nolock)                                                       
 return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.temp_update
-- --------------------------------------------------
CREATE proc temp_update
(          
@client_code varchar(20)
)          
as          

 update delivered set          
 	surface_zone='Maharastra & Gujrat',weight='0-250',cour_compn_name='SHREE BALAJI COURIER',bank_rate=8
	where client_code = @client_code

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ack_delivered
-- --------------------------------------------------
CREATE proc usp_ack_delivered  
(  
@From_Date as varchar(11),  
@To_Date as varchar(11),  
@company as varchar(50),  
@access_to as varchar(15),  
@access_code as varchar(15)  
)  
as  
select branch_cd as BRANCH_CODE,sb_code AS SUB_CODE,client_code, client_name AS CLIENT_NAME,cour_compn_name AS COMPANY_NAME,  
convert(varchar(11),dispatch_date,103) as dispatch_Date,pod from delivered (nolock)   
where dispatch_date >= convert(datetime,@From_Date,103) and   
dispatch_date<=convert(datetime,@To_Date,103)  and   
cour_compn_name =@company order by dispatch_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_branch_clientwise_report
-- --------------------------------------------------
CREATE proc usp_branch_clientwise_report  
(  
@clcode as varchar(25),  
@access_to as varchar(25),  
@access_code as varchar(25)  
)  
  
as  
  
if @clcode <>''  
begin  
select b.fld_clcode as client_code,b.fld_clname as client_name,b.fld_branch as branch_cd,b.fld_sbcode as sub_code,
convert(varchar(11),a.dispatch_date,103)as dispatch_date,  
convert(varchar(11),b.fld_date,103) as Branch_date,a.pod as POD,b.fld_pod AS BranchPod,b.fld_company as company_name,b.fld_reason as reason 
from delivered   
a inner join (select * from Tbl_Delivered_Branch where fld_clcode=@clcode)b   
on a.client_code =b.fld_clcode where delivered='BR' and inbunch='no' order by fld_clcode  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_branch_datewise_report
-- --------------------------------------------------
CREATE proc usp_branch_datewise_report      
(      
@fdate as varchar(25),      
@tdate as varchar(25),      
@access_to as varchar(25),      
@access_code as varchar(25)      
)      
      
as      
      
if (@fdate <> '' and @tdate <> '')       
begin      
select b.fld_branch as branch_cd,b.fld_sbcode as sub_code,b.fld_clcode as client_code,b.fld_clname as client_name,a.delivered as dispatch_status,convert(varchar(11),a.dispatch_date,103)as dispatch_date,      
convert(varchar(11),b.fld_Date,103)as Delivery_Date,a.POD,B.fld_pod as BRANCHPOD,b.fld_company as company_name,b.fld_reason  as reason from delivered       
a inner join (select * from Tbl_Delivered_Branch where       
fld_delivery_date >=convert(datetime,@fdate,103)and      
fld_delivery_date <=convert(datetime,@tdate,103))b on a.client_code =b.fld_clcode      
where delivered='BR' and inbunch='no' order by fld_clcode, dispatch_date,fld_Date    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Branch_Dipatch
-- --------------------------------------------------
CREATE Proc Usp_Branch_Dipatch (@clCode as varchar(15),@clName as varchar(100),@date as datetime,@pod as varchar(15),    
@company as varchar(20),@branch as varchar(15),@sbcode as varchar(15),@reason as varchar(50),    
@zone as varchar(15),@weight as varchar(15),@rate as varchar(15))    
    
as    
    
insert into Tbl_Delivered_Branch values(@clCode,@clName,@pod,@company,@branch,@sbcode,@reason,@zone,@weight,@rate,convert(datetime,convert(varchar(11),getdate())),@date,'')    
    
update delivered set delivered = 'BR' where client_code = @clCode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Branch_Grid
-- --------------------------------------------------
CREATE Proc Usp_Branch_Grid(@cl_code as varchar(10),@date as varchar(11))        
as        
      
set @date = convert(varchar(11),convert(datetime,@date,103))      
        
if @date <> '' and @cl_code = ''        
begin        
 select client_code,client_name,convert(varchar(12),dispatch_date,103) as dispatch_date,pod,cour_compn_name,surface_zone,branch_cd,sb_code,weight,bank_rate from delivered where dispatch_date=@date and (delivered = 'PEN') order by client_code        
end        
else   
begin        
 select client_code,client_name,convert(varchar(12),dispatch_date,103) as dispatch_date,pod,cour_compn_name,surface_zone,branch_cd,sb_code,weight,bank_rate from delivered where Client_code=@cl_code and (delivered = 'PEN')        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_branch_report
-- --------------------------------------------------
CREATE proc usp_branch_report
(
@fdate as varchar(11),
@tdate as varchar(11),
@branch as varchar(20)
)
as
select Client_Code=client_code,Name=client_name,Company=cour_compn_name,pod=POD,Branch=branch_cd,
Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),Delivered into #temp from delivered 
where dispatch_date >= convert(datetime,@fdate,103) and 
dispatch_date <= convert(datetime,@tdate,103) and 
branch_cd =@branch and inbunch = 'NO' order by Dispatch_Date

select a.*,convert(varchar(11),b.tdate,103) as Invoke_Date from #temp a  
inner join  
(select distinct * from hist_temp_offlinemaster) b  
on a.client_code =b.cl_code  order by Dispatch_Date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_branch_upload_Data
-- --------------------------------------------------
CREATE proc usp_branch_upload_Data                                         
(                                                          
@filename as varchar(100),    
@server as varchar(25)    
)                                                            
as           
--truncate table tbl_temp_branchdata                            
--declare @filename as varchar(100)                                         
--set @filename='Test1.xls'                        
declare @path as varchar(200)                                                                      
declare @sql as varchar(1000)                                                
declare @sql1 as varchar(1000)                                              
--truncate table tbl_shortageApproved                        
set @path='\\'+@server+'\d$\upload1\RETURNED\'+@filename        
SET @SQL1 = 'insert into tbl_temp_branchdata select * FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [Sheet1$]'' )'                                               
--print @sql1                                
exec (@sql1)         

Exec usp_update_delivered_status

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_branchwise_report
-- --------------------------------------------------
CREATE proc USP_branchwise_report	
(
@access_to as varchar(15)
-----@access_code  as varchar(15)
)

as
if @Access_to = 'Branch'                                                            
begin  
select Branch_code from intranet.risk.dbo.branches order by Branch_code
end

if @Access_to = 'BRMAST'                                                            
begin 
select branch_cd as Branch_code from intranet.risk.dbo.branch_master  order by branch_cd
end

if @Access_to = 'REGION'                                                            
begin 
select branch_code from intranet.risk.dbo.branches  where branch_code in (select code from intranet.risk.dbo.REGION )order by branch_code
end

if @Access_to = 'SB'                                                            
begin 
select branch_code from intranet.risk.dbo.branches  where branch_code in (select branch_code from intranet.risk.dbo.SUBBROKERS)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_branchwise_report_new
-- --------------------------------------------------
CREATE proc usp_branchwise_report_new  
(  
@branch as varchar(50),  
@fdate as varchar(25),                  
@tdate as varchar(25), 
@access_code as varchar(50), 
@access_to as varchar(50)
  
)  
  
as   
  
select distinct branch_cd,sb_code,client_code,client_name,cour_compn_name AS company_name,pod,surface_zone,  
weight,bank_rate,convert(varchar(11),dispatch_date,103) as dispatch_date from delivered   
where  branch_cd=@branch and inbunch = 'no' and   
dispatch_date>=convert(datetime,@fdate,103) and   
dispatch_date<=convert(datetime,@tdate,103) order by dispatch_date desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_combine_report
-- --------------------------------------------------
CREATE proc Usp_combine_report(@fdt as varchar(11),@tdt as varchar(11),@type as varchar(11))
as 
--declare @fdt as varchar(11),@tdt as varchar(11),@type as varchar(11),
declare @str as varchar(1000)
--set @fdt='01/06/2008'
--set @tdt='03/06/2008'
set @fdt = convert(datetime,@fdt,103)                 
set @tdt = convert(datetime,@tdt,103)    
if @type='Combine Report'
begin
set @str='select Dispatch_date,dispatch_mode as dispatch_mode,remark,
(case when branch_cd in (''ACM'',''HO'',''XH'',''XR'') then branch_cd+''-''+sub_broker else branch_cd end) as br_sb,
BSEQTY,NSEQTY,FOQTY,MCXQTY, NCDXQTY,DPINDQTY,DPCOPRATEQTY,DPCOMMOQTY,BSE,NSE,FO,MCX,NCDX,DPIND, 
dpcoprate,dpcommo,Branch_cd as BRANCH, POD as POD,name as name,telphone_no as TelPhone_no,remark,id 
from nsecourier.dbo.kyc_form_entry_new(nolock)where dispatch_date>='''+@fdt+'''
and dispatch_date<='''+@tdt+''' order by dispatch_date'

end
exec (@str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Courier_Rpt
-- --------------------------------------------------
CREATE proc Usp_Courier_Rpt(@fdate as varchar(11),@tdate as varchar(11),@branch as varchar(20),
@subbroker as varchar(20),@mode as varchar(10))
as 

/*
declare @fdate as varchar(11),@tdate as varchar(11),@branch as varchar(20),@subbroker as varchar(20),@mode as varchar(10)
set @fdate = '14/11/2007'
set @tdate = '14/11/2007'
set @branch = 'ALL'
set @subbroker = 'ALL'
set @mode = 'U'
*/

declare @str as varchar(500)

set @fdate = convert(varchar(11),convert(datetime,@fdate,103))
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))

set @branch = (case when @branch = 'ALL' then 'like ''%%' else ' = '+''''+@branch+'' end)      
set @subbroker = (case when @subbroker = 'ALL' then 'like ''%%' else ' = '+''''+@subbroker+'' end)      

if @mode = 'D'
begin
set @str = 'select ctr=0,a.* from delivered a (nolock)  where a.branch_cd '+@branch+''' and a.sb_code '+@subbroker+''' and 
	a.dispatch_date >= '''+@fdate+''' and a.dispatch_date <= '''+@tdate+''+' 23:59:59'''
end 

if @mode = 'U'
begin
set @str = 'select ctr=0,a.* from undelivered a (nolock) where a.branch_cd '+@branch+''' and a.sb_code '+@subbroker+''' and
	 a.return_date >= '''+@fdate+''' and a.return_date <= '''+@tdate+''+' 23:59:59''' 
end

--print @str

exec (@str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_couriers_report
-- --------------------------------------------------
create proc usp_couriers_report                        
(                            
@fdt as varchar(20),                            
@tdt as  varchar(20),          
@type as varchar(70)                            
)                            
as                            
set nocount on                            
set transaction isolation level read uncommitted        

if @type='Combine Report'  
begin
select dispatch_date as Dispatch_date,dispatch_mode as dispatch_mode,
(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,
 BSEQTY,NSEQTY,FOQTY,MCXQTY, NCDXQTY,DPINDQTY,DPCOPRATEQTY,DPCOMMOQTY,BSE,NSE,FO,MCX,NCDX,DPIND,
 dpcoprate,dpcommo,Branch_cd as BRANCH, POD as POD,name as name,telphone_no as TelPhone_no,id 
 from nsecourier.dbo.kyc_form_entry_new(nolock)where dispatch_date>=convert(varchar(11),
 convert(datetime,'" & fdt & "',103))and dispatch_date<=convert(varchar(11),convert(datetime,'" & tdt & "',103))
 order by dispatch_date
end 

if @type='Hand Delivery'  
begin
select convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR')then branch_cd+'-'+sub_broker else branch_cd end) as br_sb, 
Name,Telphone_no,(case when bse='Y' then bseqty else 0 end )as BSE,
(case when nse='Y' then nseqty else 0 end )as NSE,(case when fo='Y' then foqty else 0 end )as FO,
(case when mcx='Y' then mcxqty else 0 end )as MCX,(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,
(case when dpind='Y' then dpindqty else 0 end )as DPIND,(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate
 from nsecourier.dbo.kyc_form_entry_new(nolock)where Dispatch_Mode='hand delivery'and
 dispatch_date>=convert(varchar(11),convert(datetime,'" & fdt & "',103))and
 dispatch_date<=convert(varchar(11),convert(datetime,'" & tdt & "',103)) order by  dispatch_date
end 

if @type='Courier'  
begin
select  convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,
Courier_Company,Delivery_mode,weight,pod,(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,(case when fo='Y' then foqty else 0 end )as FO,
(case when mcx='Y' then mcxqty else 0 end )as MCX,(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate
 from nsecourier.dbo.kyc_form_entry_new(nolock)where Dispatch_Mode='courier' and dispatch_date>=convert(varchar(11),convert(datetime,'" & fdt & "',103))and
 dispatch_date<=convert(varchar(11),convert(datetime,'" & tdt & "',103))order by  dispatch_date
end

if @type='Hand Delivery'                 
begin                 
select convert(varchar(11),dispatch_date) as dispatch_date,(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,                
Name,Telphone_no,                
(case when bse='Y' then bseqty else 0 end )as BSE,(case when nse='Y' then nseqty else 0 end )as NSE,                
(case when fo='Y' then foqty else 0 end )as FO,(case when mcx='Y' then mcxqty else 0 end )as MCX,                
(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,(case when dpind='Y' then dpindqty else 0 end )as DPIND,                
(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,                
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate                 
from nsecourier.dbo.kyc_form_entry_new where             
dispatch_date>=convert(varchar(11),convert(datetime,@fdt,103))             
and dispatch_date<=convert(varchar(11),convert(datetime,@tdt,103)) order by  dispatch_date            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_courierwise_data
-- --------------------------------------------------
create proc usp_courierwise_data
(
@fdate as varchar(25),
@tdate as varchar(25),
@Cour_company as varchar(50),
@access_to as varchar(25),
@access_code as varchar(25)
)
as

select Client_Code=client_code,Name=client_name,Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),Delivered from delivered where
dispatch_date >=convert(datetime,@fdate,103) and dispatch_date <=convert(datetime,@tdate,103) and cour_compn_name = @Cour_company and inbunch = 'NO' order by Dispatch_Date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_courierwise_report
-- --------------------------------------------------
CREATE proc usp_courierwise_report  
(  
@fdate as varchar(11),  
@tdate as varchar(11),  
@company as varchar(100)  
)  
  
as        
if @company='Angel Broking Ltd'            
begin  
select Client_Code=client_code,Name=client_name,Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,  
Dispatch_Date=convert(varchar(12),Dispatch_date,103),Delivered into #temp from delivered where   
dispatch_date >=convert(datetime,@fdate,103) and   
dispatch_date <=convert(datetime,@tdate,103) and cour_compn_name = @company and   
inbunch = 'yes' order by Dispatch_Date   
  
select a.*,convert(varchar(11),b.tdate,103) as Invoke_Date from #temp a  
inner join  
(select distinct * from hist_temp_offlinemaster) b  
on a.client_code =b.cl_code  order by Dispatch_Date  
  
end  
else  
begin  
select Client_Code=client_code,Name=client_name,Company=cour_compn_name,pod=POD,Branch=branch_cd,  
Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),Delivered into #temp1 from delivered where  
dispatch_date >=convert(datetime,@fdate,103) and   
dispatch_date <=convert(datetime,@tdate,103) and   
cour_compn_name =@company and inbunch = 'NO' order by Dispatch_Date  
  
  
select a.*,convert(varchar(11),b.tdate,103) as Invoke_Date from #temp1 a  
inner join  
(select distinct * from hist_temp_offlinemaster) b  
on a.client_code =b.cl_code   order by Dispatch_Date 
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_date_client_data
-- --------------------------------------------------
create proc usp_date_client_data
(
@fdate as varchar(25),
@tdate as varchar(25),
@client_code as varchar(25),
@access_to as varchar(25),
@access_code as varchar(25)
)

as 

if (@fdate <> '' and @tdate <> '')
begin
select b.fld_branch,b.fld_sbcode,b.fld_clcode,b.fld_clname,convert(varchar(11),a.dispatch_date,103)as dispatch_date,
convert(varchar(11),b.fld_delivery_date,103)as fld_delivery_date,b.fld_company,b.fld_reason 
from delivered a inner join (select * from Tbl_Delivered_Branch where
fld_delivery_date >=convert(datetime,@fdate,103)
and fld_delivery_date <=convert(datetime,@tdate,103))b on a.client_code =b.fld_clcode
where delivered='BR' and inbunch='no' order by fld_clcode
end

if @client_code <> ''
begin
select b.fld_branch,b.fld_sbcode,b.fld_clcode,b.fld_clname,convert(varchar(11),a.dispatch_date,103)as dispatch_date,
convert(varchar(11),b.fld_delivery_date,103)as fld_delivery_date,b.fld_company,b.fld_reason from 
delivered a inner join (select * from Tbl_Delivered_Branch where 
fld_clcode=@client_code )b on a.client_code =b.fld_clcode where delivered='BR' and 
inbunch='no' order by fld_clcode

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_datewise_report
-- --------------------------------------------------
CREATE proc usp_datewise_report  
(  
@date as varchar(11)  
)  
  
as  
  
select Client_Code=client_code,Name=client_name,Company=cour_compn_name,pod=POD,Branch=branch_cd,  
Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),Delivered into #temp from delivered where  
dispatch_date = convert(datetime,convert(datetime,@date,103) ,103) and inbunch = 'NO' order by Dispatch_Date  
  
select a.*,convert(varchar(11),b.tdate,103) as Invoke_Date from #temp a    
inner join    
(select distinct * from hist_temp_offlinemaster) b    
on a.client_code =b.cl_code  order by Dispatch_Date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_delb
-- --------------------------------------------------
create proc usp_delb
as

with a
as
(
select row_number()over( partition by client_code order by client_code) as rn,* from delb
)
delete from a where rn > 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Delete_Fetch_Records
-- --------------------------------------------------
CREATE Proc USP_Delete_Fetch_Records  
(  
@date as varchar(11)  
)  
as  
  
set @date = convert(datetime,@date,103)  
  
select * from hist_temp_offlinemaster  where tdate >= @date and tdate <= @date+' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Dispatch_Ack
-- --------------------------------------------------
CREATE Proc Usp_Dispatch_Ack(@clientcode as varchar(15))        
as        
set nocount on        
        
Begin tran        
insert into Delivery_ACK values(@clientcode,'YES')      
update undelivered set undelivered = 'NO' where client_code = @clientcode        
update delivered set delivered='YES' where client_code = @clientcode and inbunch = 'NO'       

commit

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Dispatch_Ack_branch
-- --------------------------------------------------
CREATE Proc Usp_Dispatch_Ack_branch(@clientcode as varchar(15))          
as          
set nocount on          
          
Begin tran          
insert into Delivery_ACK_branch values(@clientcode,'YES')        
--------------update undelivered set undelivered = 'NO' where client_code = @clientcode          
update delivered set delivered='YES' where client_code = @clientcode and inbunch = 'NO'         
commit

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Dispatch_Ack_new
-- --------------------------------------------------
CREATE Proc Usp_Dispatch_Ack_new(@clientcode as varchar(15))          
as          
set nocount on          
          
Begin tran          
insert into Delivery_ACK_new values(@clientcode,'YES')        
update delivered set delivered='YES' where client_code = @clientcode and inbunch = 'NO'         

commit

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Fast_Train
-- --------------------------------------------------
CREATE Proc USP_Fast_Train    
(  
@Kg as int,  
@gms as int,  
@company as varchar(50),  
@Type as varchar(50)  
  
)  
as  
  
declare @rate as money  
-- declare @Kg as int  
-- declare @gms int  
-- declare @Type varchar(50)  
declare @KgGms int  
  
/*  
set @Kg = 2  
set @gms = 500  
set @Type = 'BY TRAIN EAST ZONE'  
*/  
  
set @rate =   
case   
when @Type = 'BY TRAIN EAST ZONE' then 10  
when @Type = 'BY TRAIN WNS ZONE' then 9  
when @Type = 'BY AIR EAST ZONE' then 35  
when @Type = 'BY AIR WNS' then 30  
end  
  
set @KgGms = round(((@Kg*1000) + @gms),-3)
  
-- print @Kg*1000  
-- print @gms  
-- print @rate  
print @KgGms
--   
  
if @KgGms <= 20000  
  
begin  
select ((upperl/1000)*rate) as rate  from courier_rates(nolock) where company = @company and type = @Type and lowerl <= @KgGms and upperl >= @KgGms  
end   
  
else   
  
begin  
select ((@KgGms)/1000*rate) as rate  from courier_rates(nolock) where company = @company and type = @Type and lowerl <= @KgGms and upperl >= @KgGms  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_BillingBranchData
-- --------------------------------------------------
create proc Usp_Fetch_BillingBranchData
(
@fdate as varchar(25),
@tdate as varchar(25),
@access_to as varchar(15),
@access_code as varchar(15)
)
as 
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))            
--set @tdate = convert(varchar(11),convert(datetime,@fdate,103))+' 23:59:59'       


if @access_to ='BROKER'
begin
select branch_cd=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' AND  branch_cd like '%'       
group by branch_cd
end


if @access_to= 'BRANCH'                                                              
begin    
select branch_cd=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and branch_cd like 'ACM'
group by branch_cd      
end  


if @access_to='BRMAST'                                    
begin     

select branch_cd=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and
branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd=@access_code)                                                            
end           


if @access_to='REGION'                                    
begin                              
select branch_cd=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and        
branch_cd in(Select code from region(nolock)  where reg_Code=@access_code)                                                               
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_BillingCourierData
-- --------------------------------------------------
CREATE proc Usp_Fetch_BillingCourierData  
(  
@fdate as varchar(25),  
@tdate as varchar(25),  
@access_to as varchar(15),  
@access_code as varchar(15)  
)  
as   
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))              
--set @tdate = convert(varchar(11),convert(datetime,@fdate,103))+' 23:59:59'         
  
  
if @access_to ='BROKER'  
begin  
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' AND  branch_cd like '%'         
group by cour_compn_name    
end  
  
  
if @access_to= 'BRANCH'                                                                
begin      
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and branch_cd like @access_code
group by cour_compn_name      
end    
  
  
if @access_to='BRMAST'                                      
begin       
  
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and  
branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd=@access_code)                                                              
end             
  
  
if @access_to='REGION'                                      
begin                                
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and          
branch_cd in(Select code from region(nolock)  where reg_Code=@access_code)                                                                 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_BillingCourierlistData
-- --------------------------------------------------
CREATE proc Usp_Fetch_BillingCourierlistData      
(      
@fdate as varchar(25),      
@tdate as varchar(25),    
@access_to as varchar(15),      
@access_code as varchar(15),   
@Cour_company as varchar(50) 
)      
as       
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))                  
--set @tdate = convert(varchar(11),convert(datetime,@fdate,103))+' 23:59:59'             
      
      
if @access_to ='BROKER'      
begin   
--  
--declare @sql1 as varchar(1500)                    
--set @sql1=                    
--'select Cour_compn_name =''<a href=''''report.aspx?reportno=245&Company=''+ Cour_compn_name +''&fdate='+@fdate+'&tdate='+@tdate+'&access_code='+@access_code+'&access_to='+@access_to+'''''>''+ Cour_compn_name +''</a>''                
--,Count=count(*),RATE=sum(bank_rate) from delivered where      
--dispatch_date >= CONVERT(datetime,'''+@fdate+''',103) and dispatch_date <= convert(Datetime,'''+@tdate+''',103) and inbunch = ''NO'' and cour_compn_name like '''+@Cour_company+''' and branch_cd like ''%''  group by cour_compn_name'                     
--exec (@sql1)  
     
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where      
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and cour_compn_name=@Cour_company and branch_cd like '%'  group by cour_compn_name           
end      
      
      
if @access_to= 'BRANCH'                                                                    
begin          
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where      
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO'  and cour_compn_name=@Cour_company and branch_cd =@access_code  group by cour_compn_name           
end        
      
      
if @access_to='BRMAST'                                          
begin           
      
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where      
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and cour_compn_name=@Cour_company and       
branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd=@access_code)                                                                  
end                 
      
      
if @access_to='REGION'                                          
begin                                    
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where      
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and cour_compn_name=@Cour_company and           
branch_cd in(Select code from region(nolock)  where reg_Code=@access_code)                                                                     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_BillingCourierlistData_n
-- --------------------------------------------------
CREATE proc Usp_Fetch_BillingCourierlistData_n  
(  
@fdate as varchar(25),  
@tdate as varchar(25),  
@access_to as varchar(15),  
@access_code as varchar(15)  
)  
as   
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))              
--set @tdate = convert(varchar(11),convert(datetime,@fdate,103))+' 23:59:59'         
  
  
if @access_to ='BROKER'  
begin  
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and branch_cd like '%'  group by cour_compn_name       
end  
  
  
if @access_to= 'BRANCH'                                                                
begin      
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and branch_cd =@access_code  group by cour_compn_name       
end    
  
  
if @access_to='BRMAST'                                      
begin       
  
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO'and   
branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd=@access_code)                                                              
end             
  
  
if @access_to='REGION'                                      
begin                                
select COMPANY=cour_compn_name,Count=count(*),RATE=sum(bank_rate) from delivered where  
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and       
branch_cd in(Select code from region(nolock)  where reg_Code=@access_code)                                                                 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Fetch_BillingData
-- --------------------------------------------------
CREATE proc Usp_Fetch_BillingData                    
(                    
@fdate as varchar(25),                    
@tdate as varchar(25),         
@branch as varchar(25),   
@access_code as varchar(15),                   
@access_to as varchar(15)                    
        
)                    
as                     
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))                                
--set @tdate = convert(varchar(11),convert(datetime,@fdate,103))+' 23:59:59'                       
                    
                    
if @access_to ='BROKER'              
begin       
        
declare @sql1 as varchar(1500)                  
set @sql1=                  
'select branch_cd =''<a href=''''report.aspx?reportno=240&branch=''+ branch_cd +''&fdate='+@fdate+'&tdate='+@tdate+'&access_code='+@access_code+'&access_to='+@access_to+'''''>''+ branch_cd +''</a>''              
,Count=count(*),RATE=sum(bank_rate) from delivered where                    
dispatch_date >= CONVERT(datetime,'''+@fdate+''',103) and dispatch_date <= convert(Datetime,'''+@tdate+''',103) and inbunch = ''NO'' AND  branch_cd like rtrim('''+@branch+''')                   
group by branch_cd '                   
exec (@sql1)       
--                 
--select BRANCH=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where                    
--dispatch_date >= CONVERT(datetime,'01/11/2009',103) and dispatch_date <= convert(Datetime,'30/12/2009',103) and inbunch = 'NO' AND  branch_cd like rtrim('acm')                   
--group by branch_cd           
end                    
                         
if @access_to= 'BRANCH'                                                                                  
begin    
    
declare @sql2 as varchar(1500)                  
set @sql2=                  
'select branch_cd =''<a href=''''report.aspx?reportno=240&branch=''+ branch_cd +''&fdate='+@fdate+'&tdate='+@tdate+'&access_code='+@access_code+'&access_to='+@access_to+'''''>''+ branch_cd +''</a>''              
,Count=count(*),RATE=sum(bank_rate) from delivered where                    
dispatch_date >= CONVERT(datetime,'''+@fdate+''',103) and dispatch_date <= convert(Datetime,'''+@tdate+''',103) and inbunch = ''NO'' AND  branch_cd like rtrim('''+@access_code+''')                   
group by branch_cd '                         
exec (@sql2)      
--select BRANCH=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where                    
--dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and branch_cd = @access_code                  
--group by branch_cd                        
end                      
                    
                    
if @access_to='BRMAST'                                                        
begin                         
             
declare @sql3 as varchar(1500)                  
set @sql3=                  
'select branch_cd =''<a href=''''report.aspx?reportno=240&branch=''+ branch_cd +''&fdate='+@fdate+'&tdate='+@tdate+'&access_to='+@access_to+'&access_code='+@access_code+'''''>''+ branch_cd +''</a>''              
,Count=count(*),RATE=sum(bank_rate) from delivered where                    
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = ''NO'' and                    
branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd='''+@access_code+''')'                         
exec (@sql3)      
           
--select BRANCH=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where                    
--dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and                    
--branch_cd in (select branch_cd from branch_master(nolock)  where brMast_cd=@access_code)                                                                                
end                               
                    
                    
if @access_to='REGION'                                                        
begin       
    
declare @sql4 as varchar(1500)                  
set @sql4=                  
'select branch_cd =''<a href=''''report.aspx?reportno=240&branch=''+ branch_cd +''&fdate='+@fdate+'&tdate='+@tdate+'&access_code='+@access_code+'&access_to='+@access_to+'''''>''+ branch_cd +''</a>''              
,Count=count(*),RATE=sum(bank_rate) from delivered where                    
dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = ''NO'' and                            
branch_cd in(Select code from region(nolock)  where reg_Code='''+@access_code+''')'                         
exec (@sql4)             
                                               
--select BRANCH=branch_cd,Count=count(*),RATE=sum(bank_rate) from delivered where                    
--dispatch_date >= CONVERT(datetime,@fdate,103) and dispatch_date <= convert(Datetime,@tdate,103) and inbunch = 'NO' and                            
--branch_cd in(Select code from region(nolock)  where reg_Code=@access_code)                                                                                   
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
-- PROCEDURE dbo.Usp_GenerateDs
-- --------------------------------------------------

CREATE Proc Usp_GenerateDs (@FDate varchar(11),@TDate varchar(11),@Seg varchar(15))    
As    
    
Declare @Segment varchar(11),@Exchange varchar(15)    
    
Set @FDate = Convert(varchar(11),convert(datetime,@FDate,103))    
Set @TDate = Convert(varchar(11),convert(datetime,@TDate,103))+' 23:59:59'    
Declare @Str as varchar(500)
    
/*Set @Segment = Case When @Seg = 'NSE' or @Seg = 'BSE' then 'Capital' else 'FUTURES' end      
Set @Exchange = Case When @Seg = 'NSEFO' then 'NSE' When @Seg = 'BSEFO' then 'BSE' When @Seg = 'NCDX' then 'NCX' Else @Seg End    */

Set @Seg = Case When @Seg = 'NSEFO' then 'FO' Else @Seg End
    
Set @Str = 'Select distinct cl_code into #temp from hist_temp_offlinemaster (nolock) where tdate >='''+@FDate+''' and     
tdate <= '''+@TDate+''' and '+@Seg+' = ''NEW'';'

Set @Str = @Str+' Select Cl_Code from #temp a where Not Exists     
(Select Fld_PartyCode from Tbl_ScanDetails b (nolock) where a.cl_code=b.Fld_PartyCode)'   

--Print @Str
Exec(@Str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_hand_delivery
-- --------------------------------------------------
create proc usp_hand_delivery 
(
@fdt as varchar(50),
@tdt as varchar(50),
@type as varchar(20)
)
as set nocount on 
set transaction isolation level read uncommitted
select  convert(varchar(11),dispatch_date) as dispatch_date,
(case when branch_cd in ('ACM','HO','XH','XR') then branch_cd+'-'+sub_broker else branch_cd end) as br_sb,
Courier_Company,Delivery_mode,weight,pod,(case when bse='Y' then bseqty else 0 end )as BSE,
(case when nse='Y' then nseqty else 0 end )as NSE,(case when fo='Y' then foqty else 0 end )as FO,
(case when mcx='Y' then mcxqty else 0 end )as MCX,(case when ncdx='Y' then ncdxqty else 0 end )as NCDX,
(case when dpind='Y' then dpindqty else 0 end )as DPIND,(case when dpcoprate='Y' then dpcoprateqty else 0 end )as DPCOPRATE,
(case when dpcommo='Y' then dpcommoqty else 0 end )as DPCOMMO,Packet_rate as Courier_rate
 from nsecourier.dbo.kyc_form_entry_new(nolock)where Dispatch_Mode='courier' and 
dispatch_date>=convert(varchar(11),convert(datetime,'" & fdt & "',103))and
 dispatch_date<=convert(varchar(11),convert(datetime,'" & tdt & "',103))order by  dispatch_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Insert_ImageDetails
-- --------------------------------------------------
Create proc Usp_Insert_ImageDetails  
(  
@Fld_PartyCode varchar(20),  
@Fld_Segment varchar(5),  
@Fld_FileName varchar(50),  
@Fld_ImageType varchar(15)  
)  
as  
  
If not exists (Select * from Tbl_ScanDetails(nolock) where Fld_PartyCode = @Fld_PartyCode  
and Fld_Segments = @Fld_Segment and Fld_FileName = @Fld_ImageType)   
  
Begin  
  
 Insert into Tbl_ScanDetails values  
 (  
 @Fld_PartyCode, 
 @Fld_FileName, 
 @Fld_Segment,  
 @Fld_ImageType,  
 getdate()  
 )  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Invoke_details
-- --------------------------------------------------
CREATE proc Usp_Invoke_details          
as           
          
/*declare @date as varchar(11)          
set @date=(select convert(varchar(11),max(tdate),113) from temp_offlinemaster(nolock))          
          
select count(*)as count,tdate,max(updated_date)as updated_date from temp_offlinemaster(nolock)         
where tdate>=@date+' 00:00:00' and tdate<=@date+' 23:59:59' and nse+bse+fo+ncdx+mcx not like '%YES%'           
group by tdate */

declare @date as varchar(11)            
set @date=(select convert(varchar(11),max(tdate),113) from temp_offlinemaster(nolock))            
            
select count(*)as count,convert(varchar(11),tdate,103)as tdate,convert(varchar(11),max(updated_date),103)as updated_date from temp_offlinemaster(nolock)           
where tdate>=@date+' 00:00:00' and tdate<=@date+' 23:59:59' and nse+bse+fo+ncdx+mcx not like '%YES%'             
group by tdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Invoke_details_1
-- --------------------------------------------------
CREATE proc Usp_Invoke_details_1(@date as varchar(11))
as       
     
select count(*)as count,tdate,max(updated_date)as updated_date from temp_offlinemaster     
where tdate>=@date+' 00:00:00' and tdate<=@date+' 23:59:59'      
group by tdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Invoke_details1
-- --------------------------------------------------
create proc Usp_Invoke_details1      
as       
      
declare @date as varchar(11)      
set @date=(select convert(varchar(11),max(tdate),113) from temp_offlinemaster)      
      
select count(*)as count,tdate,max(updated_date)as updated_date from temp_offlinemaster     
where tdate>=@date+' 00:00:00' and tdate<=@date+' 23:59:59'      
group by tdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_InvokeDateReport
-- --------------------------------------------------
CREATE proc usp_InvokeDateReport    
(    
@FromDate varchar(20),    
@ToDate  varchar(20)    
)    
    
as    
    
select distinct cl_code ,branch_cd,sub_broker,long_name,convert(varchar(11),tdate,103) as Invoke_date into #t from   
hist_temp_offlinemaster(nolock) where tdate >= convert(datetime,@FromDate,103) and tdate <=  convert(datetime,@ToDate,103)     
    
select a.*,b.l_address1 as address1,b.l_address2 as address2, l_address3 as address3,b.l_zip as pincode, b.l_city,b.l_state,b.l_zip,b.mobile_pager as phone from #t a    
left outer join    
(select * from risk.dbo.client_details(nolock))b    
on a.cl_code=b.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Postal_Service
-- --------------------------------------------------
CREATE proc Usp_Postal_Service(@tdate as varchar(11))  
as  
set nocount on  
  
--set @fdate = convert(varchar(11),convert(datetime,@fdate,103))  
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))  
  
select a.client_code,a.pod,a.client_name,a.branch_cd,a.sb_code,b.l_city,b.l_zip from   
(select * from delivered where dispatch_date >= @tdate and dispatch_date <= @tdate+' 23:59:59'  
and cour_compn_name = 'Postal services')a  
inner join   
(select * from intranet.risk.dbo.client_details)b  
on a.client_code = b.party_code  
  
select @@rowcount as Count  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Send_Sms
-- --------------------------------------------------
CREATE proc [dbo].[Usp_Send_Sms](@fdate as varchar(11),@time as varchar(10),@val as varchar(10))          
as          
          
declare @fdate1 as varchar(11)          
declare @file as varchar(100)                      
declare @s as varchar(1000)                       
declare @s1 as varchar(1000)               
          
set @fdate1 = convert(varchar(11),convert(datetime,@fdate,103))              
          
-------------------------- To Find Valid Mobile Numbers----------------            
          
truncate table tbl_Kit_sms          
          
Insert into tbl_Kit_sms          
select right(b.Mobile_Pager,10) as MobileNumber,'Dear Customer,welcome to Angel Broking.Your welcome kit/DIS has been dispatched on  '+convert(varchar(11),dispatch_date)+' BY '+upper(cour_compn_name)+          
case when cour_compn_name = 'POSTAL SERVICE ' then ' REF NO '+pod else ' AWB NO '+pod end+'.Tel: '+          
case when cour_compn_name = 'SHREE BALAJI COURIER' then '02266910151/02232452677/02228383864'          
when cour_compn_name = 'ASKO EXPRESS COURIER' then '32680700/32937856'          
when cour_compn_name = 'VICHARE COURIER' then '02228224274/28392040/28392256'          
when cour_compn_name = 'POSTAL SERVICES' then '02230837400' end as Message          
--,'31/01/2008','4:20','A','PM'          
   
from                          
 (                          
 select client_code,convert(varchar(11),dispatch_date) as dispatch_date ,pod,cour_compn_name                          
 from NSECOURIER.DBO.delivered (nolock) where dispatch_date >= @fdate1 and dispatch_date          
 <= @fdate1+' 23:59:59' and inbunch = 'no'                      
 --and delivered='yes'                          
 ) a inner join                          
 (select * from intranet.risk.dbo.client_details with(nolock)) b                            
 on a.client_code = b.cl_code and b.Mobile_Pager <> '' and len(b.Mobile_Pager) = 10 and left(b.Mobile_Pager,1) <> '0'          
          
----------------------------- Inserting Into Sms Table --------------------          
        
INSERT INTO intranet.sms.dbo.SMS          
select MobileNumber,Message,@fdate,@time,'A',@val,'KYC – WK'  from tbl_Kit_sms          
        
------------------------------ To Generate File ---------------------------------          
          
truncate table tbl_Sms_file          
          
insert into tbl_Sms_file          
select MobileNumber+','+Message from tbl_Kit_sms where Message is not null         
          
/*set @file = 'D:\upload1\SMS\sms.xls'   */

set @file = 'I:\upload1\SMS\sms.xls' 
         
          
--print @file                  
                    
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT heading FROM INTRANET.Nsecourier.DBO.tbl_Sms_file" queryout '+@file+' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                      
set @s1= @s+''''                                                      
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Send_Sms_New
-- --------------------------------------------------
CREATE proc [dbo].[Usp_Send_Sms_New](@fdate as varchar(11),@time as varchar(10),@val as varchar(10))                                        
as                                        
                                        
declare @fdate1 as varchar(11)                                        
declare @file as varchar(100)                                                    
declare @s as varchar(1000)                                                     
declare @s1 as varchar(1000)                                             
                                        
set @fdate1 = convert(varchar(11),convert(datetime,@fdate,103))                                            
                                        
-------------------------- To Find Valid Mobile Numbers----------------                                          
                                        
truncate table tbl_Kit_sms                                        
                                        
Insert into tbl_Kit_sms                                        
select right(b.Mobile_Pager,10) as MobileNumber,'Dear Customer,welcome to Angel Broking.Your welcome kit/DIS has been dispatched on '+convert(varchar(11),dispatch_date)+' BY '+upper(cour_compn_name)+                                        
case when cour_compn_name = 'POSTAL SERVICE ' then ' REF NO '+pod else ' AWB NO '+pod end+'.Tel: '+                                        
case when cour_compn_name = 'SHREE BALAJI COURIER' then '02266910151/02232452677/02228383864'                                        
when cour_compn_name = 'ASKO EXPRESS COURIER' then '32680700/32937856'                                        
when cour_compn_name = 'VICHARE COURIER' then '02228224274/28392040/28392256'                                        
when cour_compn_name = 'POSTAL SERVICES' then '02230837400'                         
when cour_compn_name = 'MID WAY COURIER' then '9594969801 / 9594969805 / 9594969807'                   
when cour_compn_name = 'SAMARTH COURIER' then '9323053585/9326777042/02264174585'                      
when cour_compn_name = 'TRACKON COURIER ' then '02267022919 /02267022920 / 02228242658'                 
when cour_compn_name = 'PROFESSIONAL COURIER' then '02228224152/02228231413/02240258202'    
when cour_compn_name = 'Shree Maruti Courier' then '9533431180/9394431180'    
when cour_compn_name = 'On Dot' then '9989235084/9848750443'    
when cour_compn_name = 'ZENS EXPRESS' then '7498017774/02232684750/02232689282'
when cour_compn_name = 'DTDC COURIER' then '04064536453'
when cour_compn_name = 'FLIGHT DESPATCH COURIER' then '9849191707'end as Message            
                                       
--,'31/01/2008','4:20','A','PM'                                       
                                 
from                                                        
 (                                                        
 select client_code,convert(varchar(11),dispatch_date) as dispatch_date ,pod,cour_compn_name                                                        
 from NSECOURIER.DBO.delivered (nolock) where dispatch_date >= @fdate1 and dispatch_date                                        
 <= @fdate1+' 23:59:59' and inbunch = 'no'                                                    
 --and delivered='yes'                                                        
 ) a inner join                                                        
 (select * from intranet.risk.dbo.client_details (nolock)) b                                                          
 on a.client_code = b.cl_code and b.Mobile_Pager <> '' and len(b.Mobile_Pager) = 10 and left(b.Mobile_Pager,1) <> '0'                                        
                                        
----------------------------- Inserting Into Sms Table --------------------                                        
                                      
INSERT INTO intranet.sms.dbo.SMS                                        
select MobileNumber,Message,@fdate,@time,'A',@val,'KYC – WK' from tbl_Kit_sms                                        
                                      
------------------------------ To Generate File ---------------------------------                                        
                                  
truncate table tbl_Sms_file                                        
                                        
insert into tbl_Sms_file                                        
select MobileNumber+','+Message from tbl_Kit_sms where Message is not null                                       
                                                    
Select substring(heading,0,charindex(',',heading)) MobileNo,substring(heading,charindex(',',heading)+1,len(heading)) Message from tbl_Sms_file

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sent_BGMail
-- --------------------------------------------------
CREATE procedure usp_Sent_BGMail                         
as   
declare @cntstr int 
declare @dispatch_date as varchar(15)
select @dispatch_date=max(dispatch_Date) from delivered
--@fld_date =select max(dispatch_date)from delivered
--select  @cntstr =  count(*) from  MCDX_BG_15DayExpiry  
--print @cntstr  
  
--select  @cntstr =  count(*) Tbl_Delivered_Branch    
--print @cntstr  
  
--if @cntstr > 0   
                         
begin      
declare @fld_clcode varchar(12),@fld_clname varchar (200), @company varchar (200),@POD varchar (200),@fld_Branch varchar(200),@fld_sbcode varchar(200),@fld_date as varchar(12),@delivered as varchar(2000),@InvokeDate as varchar(400),
@mess as varchar(2000),@str as varchar(400),@mess1 as varchar(2000)      
        
        
set @mess = ''    
set @mess1 = ''    
set @mess = @mess + '<html><head>'                                  
set @mess = @mess + '</head>'          
set @mess= @mess + '<body>'          
      
set @mess= @mess + 'Dear Sir,<br><br>'                         
set @mess = @mess +'Below mentioned Bank Guarantee is likely to get expired in the next 15 days. '    
set @mess = @mess +'<br>Please do the needful to take the necessary action.'     
set @mess = @mess + '<br><br></p>'     
                             
set @mess = @mess +'<br><table width = ''950''  border=1 cellspacing=0 style="font-family:tahoma;font-size:10px;">'       
set @mess = @mess + '<tr><td><strong>CLIENT CODE</td><td><strong>CLIENT NAME</td><td><strong>COMPANY</td><td><strong>POD</td><td><strong>BRANCH CODE</td><td><strong>SUB BROKER CODE</td><td><strong>DISPATCH DATE</td><td><strong>DELIVERED</td><td><strong>INVOKE DATE</td></tr>'                 
set @mess1 = @mess1 + '</table><br>'
set @mess1 = @mess1 + ' The MIS mentioned above is also available in the RM Welcome Kit Link for your reference:<br/><br/>'    
set @mess1 = @mess1 +'Regards, <br>'    
set @mess1 = @mess1 +'Mohsin Agwan  <br>'    
set @mess1 = @mess1 +'Asst . Manager KYC (CSO)<br>'    
set @mess1 = @mess1 +'(Mob: 9869342967) <br>'    
set @mess1 = @mess1 + '</body>'        
set @mess1 = @mess1 + '</html>'            

-- declare @pcode varchar(12),@bankcode varchar(200),@brcode varchar(200),@bgno varchar(200),@Amount varchar(200),@Idate as varchar(12),@R1date as varchar(12),@R2date as varchar(12),@Mdate as varchar(12),@mess as varchar(800),@str as varchar(400),@mess1  
 
--as varchar(400)      
                         
DECLARE sent_bgmail CURSOR FOR       
          
--select fld_clcode,fld_clname,fld_branch,fld_sbcode,fld_date,fld_reason,fld_br_remark
--from intranet.nsecourier.dbo.Tbl_Delivered_Branch   

select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) from hist_temp_offlinemaster  a(nolock)
 inner join (select Client_Code=client_code,Name=client_name,
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),
Delivered from delivered(nolock) where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b 
on a.cl_code=b.client_code  order by Dispatch_Date

 
--from test_1    
         
OPEN sent_bgmail                                                                              
                                                                              
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
    
    
WHILE @@FETCH_STATUS = 0                                                                              
BEGIN                
                    
set @mess = @mess+'<tr><td>'+@fld_clcode+'</td><td>'+@fld_clname+'</td><td>'+@company+'</td><td>'+@POD+'</td><td>'+@fld_Branch+'</td><td>'+@fld_sbcode+'</td><td>'+@fld_date+'</td><td>'+@delivered+'</td><td>'+@InvokeDate+'</td></tr>'                        
   
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
     
--print @pcode     
    
END     
       
set @mess=@mess+''+@mess1        
    
print @mess 
print @mess1   
exec mis.master.dbo.xp_smtp_sendmail         
      
 @TO =  'Megha.Wangane@angeltrade.com',   
@from ='Megha.Wangane@angeltrade.com',
 @type='text/html',                          
 @subject = 'Bank Guarantee Expiring in next 15 days',                                   
 @server = 'angelmail.angelbroking.com',                                  
 @message=@mess 
                                                           
CLOSE sent_bgmail                                                                  
DEALLOCATE sent_bgmail   
  		
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sent_BGMail_new
-- --------------------------------------------------
create procedure usp_Sent_BGMail_new                         
as   
declare @cntstr int 
declare @dispatch_date as varchar(15)
select @dispatch_date=max(dispatch_Date) from delivered
--@fld_date =select max(dispatch_date)from delivered
--select  @cntstr =  count(*) from  MCDX_BG_15DayExpiry  
--print @cntstr  
  
--select  @cntstr =  count(*) Tbl_Delivered_Branch    
--print @cntstr  
  
--if @cntstr > 0   
                         
begin      
declare @fld_clcode varchar(12),@fld_clname varchar (200), @company varchar (200),@POD varchar (200),@fld_Branch varchar(200),@fld_sbcode varchar(200),@fld_date as varchar(12),@delivered as varchar(2000),@InvokeDate as varchar(400),
@mess as varchar(3000),@str as varchar(400),@mess1 as varchar(2000)      
        
        
set @mess = ''    
set @mess1 = ''    
set @mess = @mess + '<html><head>'                                  
set @mess = @mess + '</head>'          
set @mess= @mess + '<body>'          
      
set @mess= @mess + 'Dear Sir,<br><br>'                         
set @mess = @mess +'Below mentioned Bank Guarantee is likely to get expired in the next 15 days. '    
set @mess = @mess +'<br>Please do the needful to take the necessary action.'     
set @mess = @mess + '<br><br></p>'     
                             
set @mess = @mess +'<br><table width = ''800''  border=1 cellspacing=0 style=''font-family:tahoma;font-size:10px;''>'       
set @mess = @mess + '<tr><td><strong>CLIENT CODE</td><td><strong>CLIENT NAME</td><td><strong>COMPANY</td><td><strong>POD</td><td><strong>BRANCH CODE</td><td><strong>SUB BROKER CODE</td><td><strong>DISPATCH DATE</td><td><strong>DELIVERED</td><td><strong>INVOKE DATE</td></tr>'                 
set @mess1 = @mess1 + '</table><br>'
set @mess1 = @mess1 + ' The MIS mentioned above is also available in the RM Welcome Kit Link for your reference:<br/><br/>'    
set @mess1 = @mess1 +'Regards, <br>'    
set @mess1 = @mess1 +'Mohsin Agwan  <br>'    
set @mess1 = @mess1 +'Asst . Manager KYC (CSO)<br>'    
set @mess1 = @mess1 +'(Mob: 9869342967) <br>'    
set @mess1 = @mess1 + '</body>'        
set @mess1 = @mess1 + '</html>'            

-- declare @pcode varchar(12),@bankcode varchar(200),@brcode varchar(200),@bgno varchar(200),@Amount varchar(200),@Idate as varchar(12),@R1date as varchar(12),@R2date as varchar(12),@Mdate as varchar(12),@mess as varchar(800),@str as varchar(400),@mess1  
 
--as varchar(400)      
                         
DECLARE sent_bgmail CURSOR FOR    
   
          
--select fld_clcode,fld_clname,fld_branch,fld_sbcode,fld_date,fld_reason,fld_br_remark
--from intranet.nsecourier.dbo.Tbl_Delivered_Branch   

select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) from hist_temp_offlinemaster  a(nolock)
 inner join (select Client_Code=client_code,Name=client_name,
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),
Delivered from delivered(nolock) where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b 
on a.cl_code=b.client_code  order by Dispatch_Date

 
--from test_1    
         
OPEN sent_bgmail                                                                              
                                                                              
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
    
    
WHILE @@FETCH_STATUS = 0                                                                              
BEGIN                
                    
set @mess = @mess+'<tr><td>'+@fld_clcode+'</td><td>'+@fld_clname+'</td><td>'+@company+'</td><td>'+@POD+'</td><td>'+@fld_Branch+'</td><td>'+@fld_sbcode+'</td><td>'+@fld_date+'</td><td>'+@delivered+'</td><td>'+@InvokeDate+'</td></tr>'                        
   
FETCH NEXT FROM sent_bgmail    
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate
     
--print @pcode     
    
END     
       
set @mess=@mess+''+@mess1        
    
print @mess 
print @mess1   
exec mis.master.dbo.xp_smtp_sendmail         
      
 @TO =  'Megha.Wangane@angeltrade.com',   
@from ='Megha.Wangane@angeltrade.com',
 @type='text/html',                          
 @subject = 'Bank Guarantee Expiring in next 15 days',                                   
 @server = 'angelmail.angelbroking.com',                                  
 @message=@mess 
                                                           
CLOSE sent_bgmail                                                                  
DEALLOCATE sent_bgmail   
  		
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Sent_BGMail_new1
-- --------------------------------------------------
CREATE procedure [dbo].[usp_Sent_BGMail_new1]                           
as

DECLARE @rc INT                   

IF NOT EXISTS (SELECT * FROM msdb.sys.service_queues                   

WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                  

EXEC @rc = msdb.dbo.sysmail_start_sp   

     
declare @cntstr int   
declare @dispatch_date as varchar(15)  
select @dispatch_date=max(dispatch_Date) from delivered  
  
  
select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) into #con2 from hist_temp_offlinemaster  a(nolock)  
inner join (select Client_Code=client_code,Name=client_name,  
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),  
Delivered from delivered(nolock) where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b   
on a.cl_code=b.client_code  order by Dispatch_Date  
  
select * from #con2  
drop table usp_sent_branch  
  
  
select * into usp_sent_branch from #con2  
  
declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(1500),                              
@mess2 as varchar(1300),@ctr as int,                                
@name as varchar(100)                                  
set @ctr=0                                
set @mess2='     
  
Please find the MIS report of the Welcome kits dispatched for forms inwarded as on 12/12/2008.In case of any clarification on the same please do revert back to me.  
The MIS mentioned above is also available in the RM Welcome Kit Link for your reference: http://196.1.115.136/ ->KYC ->Status Repot ->Welcome Kit Report'  
  
DECLARE email_EBROK_cursor CURSOR FOR                                                                                 
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')        
from mis.testdb.dbo.NonECN_MAIL_addr with(nolock) --where branch='XS1'                            
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
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch  
where Branch='''''+@tag+'''''  " queryout I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                
set @s1= @s+''''         
--print @s1  
exec(@s1)  
  
  
----------//  
  
declare @attach as varchar(500)                                
/*set @attach='D:\upload1\Branch_record\BranchesData_'+@tag+'.CSV;' */ 
set @attach='I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV;'
declare @str as varchar(200)  , @result as int                        
set @str='declare @result as int'                               
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV'', NO_OUTPUT'                                
set @str=@str+' select Result=@result '   
--print @str                 
  
--declare @ss  table (status int)                                 
---insert into @ss  exec(@str)                                
  
create table #ffb (status int)                                
insert into #ffb  exec(@str)             
select @result=status from #ffb                                
  
 --print @result                                
                              
  
set @mess='Dear '+replace(@name,',','/')+@mess2                       
if @result=0                            
begin                               
EXEC msdb.dbo.sp_send_dbmail 
  @profile_name = 'ecncso',
--@from='ECNCSO@angeltrade.com',                                
  @recipients =@email,                                
  @copy_recipients =@remail,                                
  @blind_copy_recipients ='Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com,shweta.tiwari@angeltrade.com',                                
  @subject='ECN Bounce Mail Client',--@type='text/html',                                
  @importance ='HIGH',                                
  @file_attachments =@attach,                                
  --@server='angelmail.angelbroking.com',                                
  @body =@mess                                
  
  --print 'File send '+@tag                                                          
  set @str='exec MASTER.dbo.xp_cmdshell ''del I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV'''                                      
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
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch  
where Branch='''''+@tag+'''''  " queryout I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                
set @s1= @s+''''  
exec(@s1)     
  
                      
--declare @attach as varchar(500)                                
  
set @attach='I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV;'                          
  
-- declare @str as varchar(200)  , @result as int                                
set @str='declare @result as int'                               
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV'', NO_OUTPUT'                                
set @str=@str+' select Result=@result '                                   
--declare @ss  table (status int)                                           
--\\insert into @ss  exec(@str)                                
   
create table #ffbq (status int)                                
insert into #ffbq  exec(@str)           select @result=status from #ffbq                                
  
--print @result                                
                         
set @mess='Dear All'+@mess2                              
        
if @result=0                               
begin                                
EXEC msdb.dbo.sp_send_dbmail 
 @profile_name = 'ecncso',
--@from='ECNCSO@angeltrade.com',                                
@recipients ='kyc.cso@angeltrade.com,Feedback@angeltrade.com,cosdespatch@angeltrade.com,Deepak.Redekar@angeltrade.com,Pramita.Poojary@angeltrade.com',                                
@copy_recipients ='Santanu.Syam@angeltrade.com,Alpesh.Porwal@angeltrade.com',                                
@blind_copy_recipients ='shweta.tiwari@angeltrade.com',                                
@subject='ECN Bounce Mail Client',--@type='text/html',                                
@importance ='HIGH',                                
@file_attachments =@attach,                                
--@server='angelmail.angelbroking.com',                                
@body =@mess                                
  
--print 'File send '+@tag                                
  
set @str='exec MASTER.dbo.xp_cmdshell ''del I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV'''                                      
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
  
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' + 'bcp  " select Client_code+'''',''''+Name+'''',''''+Company+'''',''''+pod+'''',''''+Branch+'''',''''+Sub_Broker+'''',''''+Dispatch_Date+'''',''''+Delivered+'''',''''+InvokeDate from usp_sent_branch  
where Branch='''''+@tag+'''''  " queryout I:\upload1\Branch_record\BranchesData_'+@tag+'.CSV -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                
set @s1= @s+''''                    
exec(@s1)                          
  
         
 --declare @attach as varchar(500)                                
  
set @attach='I:\upload1\Branch_record\BranchesData_NotSend.CSV;'                                
                            
--declare @str as varchar(200)  , @result as int                                
  
set @str='declare @result as int'                                
set @str=@str+' exec @result=MASTER.dbo.xp_cmdshell ''dir I:\upload1\Branch_record\BranchesData_NotSend.CSV'', NO_OUTPUT'                                
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
EXEC msdb.dbo.sp_send_dbmail 
 @profile_name = 'intranet',
--@from='Soft@angeltrade.com',                             
--@to=@email,                                
@recipients ='Deepak.Redekar@angeltrade.com,sachin.jadhav@angeltrade.com,ECNCSO@angeltrade.com,shweta.tiwari@angeltrade.com',                                
@subject='ECN Bounce Mail Not Alerted',--@type='text/html',                                
@importance ='HIGH',                                
@file_attachments =@attach,                                
--@server='angelmail.angelbroking.com',                                
@body =@mess                                
  
--print 'File send '+@tag                                          
  
set @str='exec MASTER.dbo.xp_cmdshell ''del I:\upload1\Branch_record\BranchesData_NotSend.CSV'''                                      
exec(@str)                                
  
--set @ctr=1                                     
end                                
  
drop table #ffb1                               
END                  
  
                        
print @ctr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sent_branchreport
-- --------------------------------------------------
CREATE procedure usp_sent_branchreport                           
as     

declare @cntstr int 
declare @dispatch_date as varchar(15)

select @dispatch_date=max(dispatch_Date) from intranet.nsecourier.dbo.delivered


select distinct b.*,InvokeDate=convert(varchar(11),a.tdate,103) into #con2 from intranet.nsecourier.dbo.hist_temp_offlinemaster  a
inner join (select Client_Code=client_code,Name=client_name,
Company=cour_compn_name,pod=POD,Branch=branch_cd,Sub_Broker=sb_code,Dispatch_Date=convert(varchar(12),Dispatch_date,103),
Delivered from intranet.nsecourier.dbo.delivered where dispatch_date = convert(varchar(11),@dispatch_date,103) and inbunch = 'NO') b 
on a.cl_code=b.client_code  order by Dispatch_Date

select * from #con2
drop table usp_sent_branch
select * into usp_sent_branch from #con2
  
--//

declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@ctr as int,@name as varchar(100)  

DECLARE email_EBROK_cursor CURSOR FOR                                                                               
select  branch,BM,BM_mail=replace(BM_mail,'/',','),rgm_mail=replace(rgm_mail,'/',',')      
from mis.testdb.dbo.NonECN_MAIL_addr(nolock) --where branch='XS1'                          
order by branch                                                                     
                                                       
OPEN email_EBROK_cursor                                                           
FETCH NEXT FROM email_EBROK_cursor                                                                               
INTO @tag,@name,@email,@remail            
WHILE @@FETCH_STATUS = 0                                                                              

BEGIN 
select @rec=count(1) from usp_sent_branch where branch=@tag         
if @rec > 0                              

BEGIN 
declare @fld_clcode varchar(12),@fld_clname varchar (200), @company varchar (200),@POD varchar (200),@fld_Branch varchar(200),@fld_sbcode varchar(200),@fld_date as varchar(12),@delivered as varchar(2000),@InvokeDate as varchar(400),@mess as varchar(2000),@str as varchar(400),@mess1 as varchar(2000)        
          
        
set @mess = ''      
set @mess1 = ''      
set @mess = @mess + '<html><head>'                                    
set @mess = @mess + '</head>'            
set @mess= @mess + '<body>'            
        
set @mess= @mess + 'Dear Sir,<br><br>'                           
set @mess = @mess +'Below mentioned Bank Guarantee is likely to get expired in the next 15 days. '      
set @mess = @mess +'<br>Please do the needful to take the necessary action.'       
set @mess = @mess + '<br><br></p>'       
                               
set @mess = @mess +'<br><table width = ''950''  border=1 cellspacing=0 style="font-family:tahoma;font-size:10px;">'         
set @mess = @mess + '<tr><td><strong>CLIENT CODE</td><td><strong>CLIENT NAME</td><td><strong>COMPANY</td><td><strong>POD</td><td><strong>BRANCH CODE</td><td><strong>SUB BROKER CODE</td><td><strong>DISPATCH DATE</td><td><strong>DELIVERED</td><td><strong>INVOKE DATE</td></tr>'                   
set @mess1 = @mess1 + '</table><br>'  
set @mess1 = @mess1 + ' The MIS mentioned above is also available in the RM Welcome Kit Link for your reference:<br/><br/>'      
set @mess1 = @mess1 +'Regards, <br>'      
set @mess1 = @mess1 +'Mohsin Agwan  <br>'      
set @mess1 = @mess1 +'Asst . Manager KYC (CSO)<br>'      
set @mess1 = @mess1 +'(Mob: 9869342967) <br>'      
set @mess1 = @mess1 + '</body>'          
set @mess1 = @mess1 + '</html>'                                          

end

--OPEN email_EBROK_cursor
FETCH NEXT FROM email_EBROK_cursor      
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate  

WHILE @@FETCH_STATUS = 0                                                                                
BEGIN                  
                      
set @mess = @mess+'<tr><td>'+@fld_clcode+'</td><td>'+@fld_clname+'</td><td>'+@company+'</td><td>'+@POD+'</td><td>'+@fld_Branch+'</td><td>'+@fld_sbcode+'</td><td>'+@fld_date+'</td><td>'+@delivered+'</td><td>'+@InvokeDate+'</td></tr>'                       
   
     
FETCH NEXT FROM email_EBROK_cursor      
INTO @fld_clcode,@fld_clname,@company,@POD,@fld_Branch,@fld_sbcode,@fld_date,@delivered ,@InvokeDate         
END 

set @mess=@mess+''+@mess1          
      
print @mess   
print @mess1     
exec mis.master.dbo.xp_smtp_sendmail           
        
@TO =  'Megha.Wangane@angeltrade.com',     
@from ='Megha.Wangane@angeltrade.com',  
@type='text/html',                            
@subject = 'Bank Guarantee Expiring in next 15 days',                                     
@server = 'angelmail.angelbroking.com',                                    
@message=@mess   
                                                             
CLOSE email_EBROK_cursor                                                                    
DEALLOCATE email_EBROK_cursor     
      
end    


--//

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_surplus_dispatch
-- --------------------------------------------------
CREATE proc [dbo].[usp_surplus_dispatch]  
(                  
@filename as varchar(100)                        
)                    
as      
declare @path as varchar(100)                              
declare @sql as varchar(1000)        
--truncate table tbl_Vanishing_company      
/*set @path='d:\upload1\'+ @filename  */
set @path='I:\upload1\'+ @filename
              
SET @SQL = 'insert into mis_diverse_dispatch select * FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [sheet1$]'' )'       
--print @SQL                      
exec (@sql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_update_delivered_status
-- --------------------------------------------------
CREATE proc usp_update_delivered_status      
as      
select       
a.clientcode,      
b.cour_compn_name,      
convert(varchar(11),a.dispatchdate,103) as dispatch_date,      
a.reason,      
a.pod ,case when a.clientcode = b.client_code then  'KIT IS ALREADY DISPATCHED TO BRANCH.'      
else 'KIT IS NOT DISPATCHED YET' end as status,      
case when a.reason = c.reason then 'Active status' else 'Invalid Status' end as Invalidstatus into #temp      
from MIS.upload.dbo.tbl_temp_branchdata a        
left outer join intranet.nsecourier.dbo.delivered b on a.clientcode = b.client_code      
left outer join intranet.nsecourier.dbo.return_remarks c on a.reason = c.reason      
order by dispatch_Date  
      
UPDATE delivered      
SET delivered ='BR'        
FROM delivered INNER JOIN #temp      
ON delivered.client_code = #temp.clientcode     
    
delete from delivery_ack  where client_code in(select clientcode from #temp)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_update_delivered_status_new
-- --------------------------------------------------
CREATE proc usp_update_delivered_status_new    
as   
   
select               
a.clientcode,              
b.cour_compn_name,              
convert(varchar(11),a.dispatchdate,103) as dispatchdate,              
a.reason,              
a.pod ,case when a.clientcode = b.client_code then  'KIT IS ALREADY DISPATCHED TO BRANCH.'              
else 'KIT IS NOT DISPATCHED YET' end as status,              
case when a.reason = c.reason then 'Active status' else 'Invalid Status' end as Invalidstatus              
from mis.upload.dbo.tbl_temp_branchdata a                
left outer join intranet.nsecourier.dbo.delivered b on a.clientcode = b.client_code              
left outer join intranet.nsecourier.dbo.return_remarks c on a.reason = c.reason              
            
--declare @cnt2 as int            
--            
--set @cnt2 = (select count(*) from mis.upload.dbo.tbl_temp_branchdata where clientcode in (select fld_clcode from Tbl_Delivered_Branch))            
--if @cnt2 = 0                                                                          
--begin            
insert into Tbl_Delivered_Branch              
select b.client_code,b.client_name,a.pod,b.cour_compn_name,b.branch_cd,b.sb_code,              
a.reason,b.surface_zone,'0-250' as weight,'8.00' as rate,convert(datetime,a.dispatchdate,103) as branch_delivered_date,b.dispatch_date,''              
from              
mis.upload.dbo.tbl_temp_branchdata a inner join intranet.nsecourier.dbo.delivered b               
on a.clientcode = b.client_code where clientcode not in (select fld_clcode from Tbl_Delivered_Branch)       

--print @cnt2            
--end          
      
select               
a.clientcode,              
b.cour_compn_name,              
convert(varchar(11),a.dispatchdate,103) as dispatch_date,              
a.reason,              
a.pod ,case when a.clientcode = b.client_code then  'KIT IS ALREADY DISPATCHED TO BRANCH.'              
else 'KIT IS NOT DISPATCHED YET' end as status,              
case when a.reason = c.reason then 'Active status' else 'Invalid Status' end as Invalidstatus into #temp              
from MIS.upload.dbo.tbl_temp_branchdata a                
left outer join intranet.nsecourier.dbo.delivered b on a.clientcode = b.client_code              
left outer join intranet.nsecourier.dbo.return_remarks c on a.reason = c.reason              
order by dispatch_Date          
              
UPDATE delivered              
SET delivered ='BR'                
FROM delivered INNER JOIN #temp              
ON delivered.client_code = #temp.clientcode       
  
select clientcode,cour_compn_name as company,Dispatch_date,reason,pod,status,invalidstatus from #temp

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V_Desp_Qty_new2
-- --------------------------------------------------
CREATE  proc V_Desp_Qty_new2
as    
  
select * from     
(     
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='bse' order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='fo' order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='nse'order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='mcx'order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='ncdx'  order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='dpind'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='dpcoprate'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new(nolock) where segment='dpcommo'   order by edt desc
) x

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER
-- --------------------------------------------------
CREATE PROC V2_OFFLINE_CLIENTMASTER(                  
          @ModifyDate    VARCHAR(11),                  
          @ModifyType    VARCHAR(1),                  
          @FromPartyCode VARCHAR(10),                  
          @ToPartyCode   VARCHAR(10),                  
          @BranchCd      VARCHAR(10),                  
          @SubBroker     VARCHAR(10))                  
AS                                
/*                                
exec V2_Offline_ClientMaster_Test '20060217','I'                            
exec V2_Offline_ClientMaster_Test '20060406','u'                 
exec V2_Offline_ClientMaster '20070827','I','N11509','N11509','ALL','ALL'                 
*/                                
                  
  SET @ModifyDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ModifyDate,'/',''),'-',''),112),11)                  
  IF ISNULL(@FromPartyCode,'') = ''                  
      OR @FromPartyCode = '%'                  
    BEGIN                  
      SET @FromPartyCode = '0000000000'                  
    END                  
  IF ISNULL(@ToPartyCode,'') = ''                  
      OR @ToPartyCode = '%'                  
    BEGIN                  
      SET @ToPartyCode = 'ZZZZZZZZZZ'                  
    END                  
  IF ISNULL(@BranchCd,'ALL') = 'ALL'                  
    BEGIN                  
      SET @BranchCd = '%'                  
    END                  
  IF ISNULL(@SubBroker,'ALL') = 'ALL'                  
    BEGIN                  
      SET @SubBroker = '%'                  
    END                  
  IF @ModifyType = 'I'                  
    BEGIN                  
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED                
      SELECT   DISTINCT CD.CL_CODE,                
                        CD.PARTY_CODE,                
                        CD.LONG_NAME,                
                        CD.BRANCH_CD,                
                        CD.SUB_BROKER,                
                        CD.TRADER,                
                        IMP_STATUS = 'NEW',                
                        NSE = (SELECT ISNULL((ISNULL((              
         SELECT 'NEW' FROM anand1.msajag.dbo.CLIENT_BROK_DETAILS(NOLOCK)              
      --   WHERE LEFT(SYSTEMDATE,11) = @ModifyDate              
         WHERE LEFT(active_date,11) = @ModifyDate         
         AND CL_CODE = CD.CL_CODE              
         AND EXCHANGE = 'NSE'              
         AND SEGMENT = 'CAPITAL'              
         ),              
         (              
         SELECT 'YES'                
                    FROM   anand1.msajag.dbo.CLIENT_BROK_DETAILSE (NOLOCK)                
                   WHERE  E.EXCHANGE = 'NSE'                
                   AND E.SEGMENT = 'CAPITAL'                
                   AND E.CL_CODE = CD.CL_CODE         
       and E.Active_Date < @ModifyDate         
         ))),'NO')),              
                        BSE = (SELECT ISNULL((ISNULL((              
         SELECT 'NEW' FROM anand1.msajag.dbo.CLIENT_BROK_DETAILS(NOLOCK)              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate              
         WHERE LEFT(active_date,11) = @ModifyDate         
         AND CL_CODE = CD.CL_CODE              
         AND EXCHANGE = 'BSE'              
         AND SEGMENT = 'CAPITAL'              
         ),              
         (              
         SELECT 'YES'                
                    FROM   anand1.msajag.dbo.CLIENT_BROK_DETAILSE (NOLOCK)                
                   WHERE  E.EXCHANGE = 'BSE'                
                   AND E.SEGMENT = 'CAPITAL'                
                   AND E.CL_CODE = CD.CL_CODE              
     and E.Active_Date < @ModifyDate         
         ))),'NO')),              
                        FO = (SELECT ISNULL((ISNULL((              
         SELECT 'NEW' FROM anand1.msajag.dbo.CLIENT_BROK_DETAILS(NOLOCK)              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate              
         WHERE LEFT(active_date,11) = @ModifyDate         
         AND CL_CODE = CD.CL_CODE              
        AND EXCHANGE = 'NSE'              
         AND SEGMENT = 'FUTURES'              
         ),              
         (              
         SELECT 'YES'       
                    FROM   anand1.msajag.dbo.CLIENT_BROK_DETAILSE (NOLOCK)                
                   WHERE  E.EXCHANGE = 'NSE'                
                   AND E.SEGMENT = 'FUTURES'                
                   AND E.CL_CODE = CD.CL_CODE              
     and E.Active_Date < @ModifyDate         
         ))),'NO')),              
                        NCDX = (SELECT ISNULL((ISNULL((              
         SELECT 'NEW' FROM anand1.msajag.dbo.CLIENT_BROK_DETAILS(NOLOCK)              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate              
         WHERE LEFT(active_date,11) = @ModifyDate         
         AND CL_CODE = CD.CL_CODE              
         AND EXCHANGE = 'NCX'              
         AND SEGMENT = 'FUTURES'              
         ),              
         (              
         SELECT 'YES'                
                    FROM   anand1.msajag.dbo.CLIENT_BROK_DETAILSE (NOLOCK)                
                   WHERE  E.EXCHANGE = 'NCX'                
                   AND E.SEGMENT = 'FUTURES'                
                   AND E.CL_CODE = CD.CL_CODE        
     and E.Active_Date < @ModifyDate               
         ))),'NO')),              
                        MCX = (SELECT ISNULL((ISNULL((              
         SELECT 'NEW' FROM anand1.msajag.dbo.CLIENT_BROK_DETAILS(NOLOCK)              
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate              
         WHERE LEFT(active_date,11) = @ModifyDate         
         AND CL_CODE = CD.CL_CODE              
         AND EXCHANGE = 'MCX'              
         AND SEGMENT = 'FUTURES'              
         ),              
         (              
         SELECT 'YES'                
                    FROM   anand1.msajag.dbo.CLIENT_BROK_DETAILSE (NOLOCK)                
                   WHERE  E.EXCHANGE = 'MCX'                
                   AND E.SEGMENT = 'FUTURES'                
                   AND E.CL_CODE = CD.CL_CODE              
and E.Active_Date < @ModifyDate         
         ))),'NO'))                
      FROM     CLIENT_DETAILS CD (NOLOCK)                
               JOIN anand1.msajag.dbo.CLIENT_BROK_DETAILSCBD (NOLOCK)                
                 ON (CBD.CL_CODE = CD.CL_CODE)                
--      WHERE    LEFT(CBD.SYSTEMDATE,11) = @Modifydate                
         WHERE LEFT(CBD.active_date,11) = @ModifyDate         
        AND CBD.CL_CODE >= @FromPartyCode                
        AND CBD.CL_CODE <= @ToPartyCode                
        AND CD.BRANCH_CD = (CASE                 
                              WHEN @BranchCd = '%' THEN CD.BRANCH_CD                
                              ELSE @BranchCd                
                            END)                
        AND CD.SUB_BROKER = (CASE                 
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER                
                               ELSE @SubBroker                
                             END)     
and cd.long_name not like '%close%'  
      ORDER BY 2                
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER_new_close
-- --------------------------------------------------
CREATE PROC V2_OFFLINE_CLIENTMASTER_new_close(                                                                          
          @ModifyDate    VARCHAR(11),                                                                          
          @ModifyType    VARCHAR(1),                                                                          
          @FromPartyCode VARCHAR(10),                                                                          
          @ToPartyCode   VARCHAR(10),                                                                          
          @BranchCd      VARCHAR(10),                                                                          
          @SubBroker     VARCHAR(10))                                                                          
AS                                                
                                    
                                 
                       
/*                        
declare    @ModifyDate    VARCHAR(11)                                    
declare          @ModifyType    VARCHAR(1)                                    
declare   @FromPartyCode VARCHAR(10)                                    
declare          @ToPartyCode   VARCHAR(10)                                    
declare          @BranchCd      VARCHAR(10)                                    
declare          @SubBroker     VARCHAR(10)                                    
                                    
set @ModifyDate = 'Jul 02 2008'                                    
set @ModifyType = 'I'                                    
set @FromPartyCode = ''                                    
set @ToPartyCode = ''                                    
set @BranchCd = 'All'                                    
set @SubBroker = 'All'                                    
  */                              
                                    
                                                                            
/*                                                                                        
exec V2_Offline_ClientMaster_Test '20060217','I'                                                                                    
exec V2_Offline_ClientMaster_Test '20060406','u'                                                                         
exec V2_Offline_ClientMaster '20070827','I','N11509','N11509','ALL','ALL'                                                                         
*/                                                                                        
                                                                          
  SET @ModifyDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ModifyDate,'/',''),'-',''),112),11)                              
                            
--print @ModifyDate                                                                          
  IF ISNULL(@FromPartyCode,'') = ''                                                                          
      OR @FromPartyCode = '%'                                                                          
    BEGIN                                                                          
      SET @FromPartyCode = '0000000000'                                                                          
    END                                                                          
  IF ISNULL(@ToPartyCode,'') = ''                                                                          
      OR @ToPartyCode = '%'                                                                          
    BEGIN                                                                          
      SET @ToPartyCode = 'ZZZZZZZZZZ'                                                                          
    END                                                                          
  IF ISNULL(@BranchCd,'ALL') = 'ALL'                                                                          
    BEGIN              
      SET @BranchCd = '%'         
    END                                                                          
  IF ISNULL(@SubBroker,'ALL') = 'ALL'                                                                          
    BEGIN                                                                      
      SET @SubBroker = '%'                                                          
    END                       
  IF @ModifyType = 'I'                                                                          
    BEGIN                                                                      
      SET TRANSACTION  ISOLATION  LEVEL  READ  UNCOMMITTED                                                                        
      SELECT   DISTINCT CD.CL_CODE,                                                    
                        CD.PARTY_CODE,                              
                        CD.LONG_NAME,                                                                        
      CD.BRANCH_CD,                                                                        
                        CD.SUB_BROKER,                                                            
                        CD.TRADER,                                                                        
                   IMP_STATUS = 'NEW',                                                                        
                        NSE = (SELECT ISNULL((ISNULL((                                                                      
         SELECT 'NEW'  FROM AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS with(NOLOCK)                                                     
      --   WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                                                 
         AND CL_CODE = CD.CL_CODE                                                                      
    AND EXCHANGE = 'NSE'                                                                      
         AND SEGMENT = 'CAPITAL'                          
   and inactive_from > getdate()+365                          
                                                   
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                                 
         ),                                                                      
         (                                                                      
         SELECT 'YES'                                                                        
                    FROM   AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS E with(NOLOCK)                                                                        
                   WHERE  E.EXCHANGE = 'NSE'                        
     and E.inactive_from > getdate()+365                                                                          
                   AND E.SEGMENT = 'CAPITAL'                                                                        
                   AND E.CL_CODE = CD.CL_CODE                                                                 
       and E.Active_Date < @ModifyDate                           --and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ))),'NO')),                                                                      
                        BSE = (SELECT ISNULL((ISNULL((                                                                      
         SELECT 'NEW' FROM AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS with(NOLOCK)                                                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                      
         WHERE LEFT(active_date,11) = @ModifyDate                         
   and cbd.inactive_from > getdate()+365                                                               
         AND CL_CODE = CD.CL_CODE         
         AND EXCHANGE = 'BSE'                        
                                                             
    AND SEGMENT = 'CAPITAL'                            
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ),                                                          
         (                                                                
         SELECT 'YES'                                   
                    FROM   AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS E with(NOLOCK)                                                                        
  WHERE  E.EXCHANGE = 'BSE'                        
     and e.inactive_from > getdate()+365                                                                         
                   AND E.SEGMENT = 'CAPITAL'                                                               
                   AND E.CL_CODE = CD.CL_CODE                                                              
     and E.Active_Date < @ModifyDate                           
                                           
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ))),'NO')),                                                          
                        FO = (SELECT ISNULL((ISNULL((                                                                      
         SELECT 'NEW' FROM AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS with(NOLOCK)                                                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                      
         WHERE LEFT(active_date,11) = @ModifyDate                         
   and inactive_from > getdate()+365                                                                 
         AND CL_CODE = CD.CL_CODE                                                                      
         AND EXCHANGE = 'NSE'                                                                      
         AND SEGMENT = 'FUTURES'                                                                      
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ),                                                                      
         (                                                                      
         SELECT 'YES'                                                               
          FROM   AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS E with(NOLOCK)                                                                        
                   WHERE  E.EXCHANGE = 'NSE'                       
       and E.inactive_from > getdate()+365                                      
                   AND E.SEGMENT = 'FUTURES'                                                                        
                   AND E.CL_CODE = CD.CL_CODE                                                                      
     and E.Active_Date < @ModifyDate                                                                 
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ))),'NO')),                                                                      
NCDX = (SELECT ISNULL((ISNULL((                                                                      
         SELECT 'NEW' FROM AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS with(NOLOCK)                                                                      
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                 
         WHERE LEFT(active_date,11) = @ModifyDate                         
 and inactive_from > getdate()+365                                                              
         AND CL_CODE = CD.CL_CODE                                                                      
         AND EXCHANGE = 'NCX'                            
         AND SEGMENT = 'FUTURES'                                                          
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                         
         ),                                                                      
         (                                                                      
         SELECT 'YES'                       
                    FROM   AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS E with(NOLOCK)                                                                        
                   WHERE  E.EXCHANGE = 'NCX'                        
 and E.inactive_from > getdate()+365                                                                       
                   AND E.SEGMENT = 'FUTURES'                                                                        
                   AND E.CL_CODE = CD.CL_CODE                                                      
     and E.Active_Date < @ModifyDate                                                                       
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
   ))),'NO')),                                                                      
                        MCX = (SELECT ISNULL((ISNULL((                                                                      
         SELECT 'NEW' FROM AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS with(NOLOCK)                          
--         WHERE LEFT(SYSTEMDATE,11) = @ModifyDate                                                                      
         WHERE LEFT(active_date,11) = @ModifyDate                                                                 
         AND CL_CODE = CD.CL_CODE                          
   and inactive_from > getdate()+365                                                                      
         AND EXCHANGE = 'MCX'                                                                      
         AND SEGMENT = 'FUTURES'                                                                      
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ),                                                                      
         (                                                                      
         SELECT 'YES'                                
                    FROM   AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS E with(NOLOCK)                                                                        
                   WHERE  E.EXCHANGE = 'MCX'                        
   and inactive_from > getdate()+365                                                                          
                   AND E.SEGMENT = 'FUTURES'                                                                        
                   AND E.CL_CODE = CD.CL_CODE                                                     
and E.Active_Date < @ModifyDate                                                                 
--and cbd.cl_code not in (select cl_code from nsecourier.dbo.hist_temp_offlinemaster)                                                          
         ))),'NO'))                                                                        
  into #t    FROM     AngelNseCM.msajag.dbo.CLIENT_DETAILS CD with(NOLOCK)                                                                        
               JOIN AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS CBD with(NOLOCK)                                                                        
                 ON (CBD.CL_CODE = CD.CL_CODE)                           
--      WHERE    LEFT(CBD.SYSTEMDATE,11) = @Modifydate                                                                        
         WHERE LEFT(CBD.active_date,11) = @ModifyDate                         
  and cbd.inactive_from > getdate()+365                                                                 
        AND CBD.CL_CODE >= @FromPartyCode                                
        AND CBD.CL_CODE <= @ToPartyCode                                                            
        AND CD.BRANCH_CD = (CASE                                                                         
                       WHEN @BranchCd = '%' THEN CD.BRANCH_CD             
                              ELSE @BranchCd                                                                        
                            END)                                                                        
        AND CD.SUB_BROKER = (CASE                                  
                               WHEN @SubBroker = '%' THEN CD.SUB_BROKER                                                               
                       ELSE @SubBroker                                                                        
                             END)                                                      
and /*cd.long_name not like '%close%'                                                            
and*/ cd.party_code<>cd.introducer_id                                                             
/*and not exists                                         
(        select * from intranet.nsecourier.dbo.hist_temp_offlinemaster y where cbd.CL_CODE = y.cl_code                                        
) */                                                           
ORDER BY 2                                         
                                    
                                  
--  insert into intranet.nsecourier.dbo.temp_offlinemaster                                    
--  select *,@ModifyDate,getdate() from #t where                                    
--                                                
--  insert into intranet.nsecourier.dbo.Hist_temp_offlinemaster                                    
--  select *,@ModifyDate,getdate() from #t                                    
--                                     
                                                             
                                        
                    
/*select *,                                
case when nse = 'YES' then 1 else 0 end as nse1,                                
case when bse = 'YES' then 1 else 0 end as bse1,                                
case when fo = 'YES' then 1 else 0 end as fo1,                                
case when ncdx = 'YES' then 1 else 0 end as ncdx1,                                
case when mcx = 'YES' then 1 else 0 end as mcdx1                                
into #x from #t where long_name not like '%close%'                              
                                
select * into #y from #t where cl_code in                                   
(                                
select CL_CODE from #x                                  
group by CL_CODE                                 
having sum(nse1+bse1+fo1+ncdx1+mcdx1) = 0                                
)                   
-----            
   */     
select client_code into #c from intranet.nsecourier.dbo.delivered        
union all        
---select cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster        
select distinct cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster       
        
select * into #z from #y where cl_code not in (select client_code from #c)        
        
        
                
--select * from #y where cl_code not in (select client_code from intranet.nsecourier.dbo.delivered)         
--select * from #y where cl_code not in (select cl_code from intranet.nsecourier.dbo.hist_temp_offlinemaster)        
-------                        
                         
--insert into intranet.nsecourier.dbo.temp_offlinemaster   
insert into intranet.nsecourier.dbo.close_name                                  
select *,@ModifyDate,getdate() from #t where cl_code in                                   
(                                
select distinct cl_code from AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS where cl_code in                            
(select cl_code from #z) and Inactive_from =  '2049-12-31 00:00:00.000' and LEFT(active_date,11)=@ModifyDate                    
)           
          
---          
/*insert into intranet.nsecourier.dbo.temp_offlinemaster                                
select *,@ModifyDate,getdate() from #t where cl_code in                                   
(                                
select distinct cl_code from AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS where cl_code not in                            
(select distinct * from hist_temp_offlinemaster where cl_code not in           
(select cl_code from #t) and Inactive_from =  '2049-12-31 00:00:00.000' and LEFT(active_date,11)=@ModifyDate                    
)          
)          
----                      
                               
insert into intranet.nsecourier.dbo.Hist_temp_offlinemaster                                    
select *,@ModifyDate,getdate() from #t where cl_code in                                   
(                                
select distinct cl_code from AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS where cl_code in                                
(select cl_code from #z) and Inactive_from =  '2049-12-31 00:00:00.000' and LEFT(active_date,11)=@ModifyDate                                     
)                        
                    
insert into intranet.nsecourier.dbo.close_name                     
select *,@ModifyDate,getdate() from #t where long_name like '%close%'                      
             
                                
/*                                
select distinct cl_code from AngelNseCM.msajag.dbo.CLIENT_BROK_DETAILS where cl_code in                                
(select cl_code from #y) and Inactive_from <> '2049-12-31 00:00:00.000'                                
*/ */                               
                     
END

GO

-- --------------------------------------------------
-- TABLE dbo.1cl
-- --------------------------------------------------
CREATE TABLE [dbo].[1cl]
(
    [Client Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.'a-c date 22-01-2010 disp on 29-$'
-- --------------------------------------------------
CREATE TABLE [dbo].['a-c date 22-01-2010 disp on 29-$']
(
    [Client Code] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ack1
-- --------------------------------------------------
CREATE TABLE [dbo].[ack1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.address_client
-- --------------------------------------------------
CREATE TABLE [dbo].[address_client]
(
    [client_code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL,
    [Dispatch_date] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.asko_ad1
-- --------------------------------------------------
CREATE TABLE [dbo].[asko_ad1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.asko_details
-- --------------------------------------------------
CREATE TABLE [dbo].[asko_details]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.asko_new12
-- --------------------------------------------------
CREATE TABLE [dbo].[asko_new12]
(
    [Client Code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.asko_record
-- --------------------------------------------------
CREATE TABLE [dbo].[asko_record]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.asko1
-- --------------------------------------------------
CREATE TABLE [dbo].[asko1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Back_Ack
-- --------------------------------------------------
CREATE TABLE [dbo].[Back_Ack]
(
    [Client_Code] VARCHAR(15) NULL,
    [Delivered] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Backup
-- --------------------------------------------------
CREATE TABLE [dbo].[Backup]
(
    [edt] VARCHAR(255) NULL,
    [Segment] VARCHAR(255) NULL,
    [receive_date] VARCHAR(255) NULL,
    [challan_no] VARCHAR(255) NULL,
    [remark1] VARCHAR(255) NULL,
    [Openbal] VARCHAR(255) NULL,
    [rejected] VARCHAR(255) NULL,
    [dispatch_date] VARCHAR(255) NULL,
    [remark2] VARCHAR(255) NULL,
    [disp_qty] VARCHAR(255) NULL,
    [remain_bal] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.backup1feb
-- --------------------------------------------------
CREATE TABLE [dbo].[backup1feb]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAL
-- --------------------------------------------------
CREATE TABLE [dbo].[BAL]
(
    [Client_code] VARCHAR(8000) NULL,
    [weight] VARCHAR(8000) NULL,
    [bank_rate] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bal_new
-- --------------------------------------------------
CREATE TABLE [dbo].[bal_new]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bal_nse
-- --------------------------------------------------
CREATE TABLE [dbo].[bal_nse]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bal_old
-- --------------------------------------------------
CREATE TABLE [dbo].[bal_old]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bal_old_new
-- --------------------------------------------------
CREATE TABLE [dbo].[bal_old_new]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAL1
-- --------------------------------------------------
CREATE TABLE [dbo].[BAL1]
(
    [Client_code] VARCHAR(8000) NULL,
    [weight] VARCHAR(8000) NULL,
    [bank_rate] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BALAJI
-- --------------------------------------------------
CREATE TABLE [dbo].[BALAJI]
(
    [Client_code] VARCHAR(8000) NULL,
    [surface_zone] VARCHAR(8000) NULL,
    [cour_compn_name] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balaji_new
-- --------------------------------------------------
CREATE TABLE [dbo].[balaji_new]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balaji1
-- --------------------------------------------------
CREATE TABLE [dbo].[balaji1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance
-- --------------------------------------------------
CREATE TABLE [dbo].[balance]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form_new
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form_new]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form_old
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form_old]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form1
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form1]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form1_new
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form1_new]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(20) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.balance_form1_old
-- --------------------------------------------------
CREATE TABLE [dbo].[balance_form1_old]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Book1
-- --------------------------------------------------
CREATE TABLE [dbo].[Book1]
(
    [edt] VARCHAR(255) NULL,
    [Segment] VARCHAR(255) NULL,
    [receive_date] VARCHAR(255) NULL,
    [challan_no] VARCHAR(255) NULL,
    [remark1] VARCHAR(255) NULL,
    [Openbal] VARCHAR(255) NULL,
    [rejected] VARCHAR(255) NULL,
    [dispatch_date] VARCHAR(255) NULL,
    [remark2] VARCHAR(255) NULL,
    [disp_qty] VARCHAR(255) NULL,
    [remain_bal] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Book2
-- --------------------------------------------------
CREATE TABLE [dbo].[Book2]
(
    [SLF045] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Book21
-- --------------------------------------------------
CREATE TABLE [dbo].[Book21]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branch tag
-- --------------------------------------------------
CREATE TABLE [dbo].[branch tag]
(
    [ClientCode] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branch_back
-- --------------------------------------------------
CREATE TABLE [dbo].[branch_back]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branch_back1
-- --------------------------------------------------
CREATE TABLE [dbo].[branch_back1]
(
    [fld_Clcode] VARCHAR(15) NULL,
    [fld_Clname] VARCHAR(100) NULL,
    [fld_Pod] VARCHAR(15) NULL,
    [fld_company] VARCHAR(20) NULL,
    [fld_branch] VARCHAR(15) NULL,
    [fld_sbCode] VARCHAR(15) NULL,
    [fld_Reason] VARCHAR(20) NULL,
    [fld_zone] VARCHAR(50) NULL,
    [fld_weight] VARCHAR(10) NULL,
    [fld_rate] VARCHAR(15) NULL,
    [fld_date] DATETIME NULL,
    [Fld_delivery_date] DATETIME NULL,
    [fld_Br_Remark] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branchtag
-- --------------------------------------------------
CREATE TABLE [dbo].[branchtag]
(
    [ClientCode] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse
-- --------------------------------------------------
CREATE TABLE [dbo].[bse]
(
    [Ledger Code] VARCHAR(255) NULL,
    [Name Of Account] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Opening Balance] VARCHAR(255) NULL,
    [Debit during the month] VARCHAR(255) NULL,
    [Credit during the month] VARCHAR(255) NULL,
    [Closing Balance] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Remarks] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.c
-- --------------------------------------------------
CREATE TABLE [dbo].[c]
(
    [Client Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.check$
-- --------------------------------------------------
CREATE TABLE [dbo].[check$]
(
    [Client_Code1] VARCHAR(255) NULL,
    [dispatch_date1] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.check_code
-- --------------------------------------------------
CREATE TABLE [dbo].[check_code]
(
    [cl_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl
-- --------------------------------------------------
CREATE TABLE [dbo].[cl]
(
    [Client_Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CL­
-- --------------------------------------------------
CREATE TABLE [dbo].[CL­]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_1
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_code
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_code]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_code_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_code_temp]
(
    [cl_code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_code1
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_code1]
(
    [client_code] VARCHAR(8000) NULL,
    [Dispatch_date] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_mis_n
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_mis_n]
(
    [cli_code] VARCHAR(8000) NULL,
    [Original_Invock_Date] VARCHAR(8000) NULL,
    [Original_Dispatch_Date] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl_mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[cl_mismatch]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl1
-- --------------------------------------------------
CREATE TABLE [dbo].[cl1]
(
    [Client_Code] VARCHAR(255) NULL,
    [POD] VARCHAR(255) NULL,
    [pod1] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cl1$
-- --------------------------------------------------
CREATE TABLE [dbo].[cl1$]
(
    [Client_Code] NVARCHAR(255) NULL,
    [Invoke_date] NVARCHAR(255) NULL,
    [Dispatch_Date] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client$
-- --------------------------------------------------
CREATE TABLE [dbo].[client$]
(
    [client_code] NVARCHAR(255) NULL,
    [Status] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_br
-- --------------------------------------------------
CREATE TABLE [dbo].[client_br]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[client_branch]
(
    [Client Code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details]
(
    [client code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_offlinmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[client_offlinmaster]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_pod
-- --------------------------------------------------
CREATE TABLE [dbo].[client_pod]
(
    [client_code] VARCHAR(8000) NULL,
    [pod1] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_record
-- --------------------------------------------------
CREATE TABLE [dbo].[client_record]
(
    [sub_broker] VARCHAR(255) NULL,
    [party_code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_vichare
-- --------------------------------------------------
CREATE TABLE [dbo].[client_vichare]
(
    [Client Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clientadd
-- --------------------------------------------------
CREATE TABLE [dbo].[clientadd]
(
    [Client Code] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Sub Broker] VARCHAR(255) NULL,
    [Client Name] VARCHAR(255) NULL,
    [Invoke Date] VARCHAR(255) NULL,
    [ADDRESS 1] VARCHAR(255) NULL,
    [ADDRESS 2] VARCHAR(255) NULL,
    [ADDRESS 3] VARCHAR(255) NULL,
    [City] VARCHAR(255) NULL,
    [State] VARCHAR(255) NULL,
    [Pin Code] VARCHAR(255) NULL,
    [Phone] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cllient
-- --------------------------------------------------
CREATE TABLE [dbo].[cllient]
(
    [A123] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cllient1
-- --------------------------------------------------
CREATE TABLE [dbo].[cllient1]
(
    [client] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.close_name
-- --------------------------------------------------
CREATE TABLE [dbo].[close_name]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clx
-- --------------------------------------------------
CREATE TABLE [dbo].[clx]
(
    [client_code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.co
-- --------------------------------------------------
CREATE TABLE [dbo].[co]
(
    [client_code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.code
-- --------------------------------------------------
CREATE TABLE [dbo].[code]
(
    [Client Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cour_rates
-- --------------------------------------------------
CREATE TABLE [dbo].[cour_rates]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier
-- --------------------------------------------------
CREATE TABLE [dbo].[courier]
(
    [client code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_charge_rate
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_charge_rate]
(
    [courier_comp_name] VARCHAR(30) NOT NULL,
    [mode] VARCHAR(30) NULL,
    [indiazone] VARCHAR(50) NULL,
    [weight] VARCHAR(30) NULL,
    [packet_rate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_new
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_new]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_new_rates
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_new_rates]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rate
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rate]
(
    [weight] VARCHAR(8000) NULL,
    [bank_rate_change] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates_new
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates_new]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates1
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates1]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL,
    [srf] NUMERIC(2, 0) NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates2
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates2]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL,
    [srf] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_rates3
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_rates3]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL,
    [srf] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_tel
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_tel]
(
    [courier_name] VARCHAR(50) NULL,
    [Tel_no1] VARCHAR(15) NULL,
    [Tel_no2] VARCHAR(15) NULL,
    [Tel_no3] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.courier_tel_detail
-- --------------------------------------------------
CREATE TABLE [dbo].[courier_tel_detail]
(
    [courier_name] VARCHAR(50) NULL,
    [Tel_no1] NUMERIC(10, 0) NULL,
    [Tel_no2] NUMERIC(10, 0) NULL,
    [Tel_no3] NUMERIC(10, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data
-- --------------------------------------------------
CREATE TABLE [dbo].[data]
(
    [Client_Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data_invoke
-- --------------------------------------------------
CREATE TABLE [dbo].[data_invoke]
(
    [cl_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data_mismatch_invoke
-- --------------------------------------------------
CREATE TABLE [dbo].[data_mismatch_invoke]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data_mistmatch_31a
-- --------------------------------------------------
CREATE TABLE [dbo].[data_mistmatch_31a]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del
-- --------------------------------------------------
CREATE TABLE [dbo].[del]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del_new
-- --------------------------------------------------
CREATE TABLE [dbo].[del_new]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del_new1
-- --------------------------------------------------
CREATE TABLE [dbo].[del_new1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del1
-- --------------------------------------------------
CREATE TABLE [dbo].[del1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del12
-- --------------------------------------------------
CREATE TABLE [dbo].[del12]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delb
-- --------------------------------------------------
CREATE TABLE [dbo].[delb]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered_1
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered_1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered_new
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered_new]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered_record
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered_record]
(
    [client_code] VARCHAR(100) NOT NULL,
    [Delivered] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered_tricon
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered_tricon]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivered3
-- --------------------------------------------------
CREATE TABLE [dbo].[delivered3]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delivery_ACK
-- --------------------------------------------------
CREATE TABLE [dbo].[Delivery_ACK]
(
    [Client_Code] VARCHAR(15) NULL,
    [Delivered] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delivery_ACK_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[Delivery_ACK_branch]
(
    [Client_Code] VARCHAR(15) NULL,
    [Delivered] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delivery_ack_new
-- --------------------------------------------------
CREATE TABLE [dbo].[delivery_ack_new]
(
    [Client_Code] VARCHAR(15) NULL,
    [Delivered] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DeliveryStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[DeliveryStatus]
(
    [cl_code] VARCHAR(255) NULL,
    [delivered1] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.description_from_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[description_from_branch]
(
    [client_code] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(30) NULL,
    [action_description] VARCHAR(500) NULL,
    [description_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.file
-- --------------------------------------------------
CREATE TABLE [dbo].[file]
(
    [Party_Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.file1
-- --------------------------------------------------
CREATE TABLE [dbo].[file1]
(
    [Party_Code] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_record
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_record]
(
    [Code] VARCHAR(255) NULL,
    [Name Of Account] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Opening Balance] VARCHAR(255) NULL,
    [Debit during the month] VARCHAR(255) NULL,
    [Credit during the month] VARCHAR(255) NULL,
    [Closing Dr] VARCHAR(255) NULL,
    [Closing Cr] VARCHAR(255) NULL,
    [Closing Balance] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist
-- --------------------------------------------------
CREATE TABLE [dbo].[hist]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL,
    [BSEFO] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_data
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_data]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_delivered_32
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_delivered_32]
(
    [client_code] VARCHAR(30) NOT NULL,
    [client_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(10) NOT NULL,
    [del_mode] VARCHAR(50) NULL,
    [surface_zone] VARCHAR(40) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(50) NULL,
    [bank_rate] INT NULL,
    [branch_cd] VARCHAR(20) NULL,
    [delivered] VARCHAR(20) NOT NULL,
    [inbunch] VARCHAR(20) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_delivered_36
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_delivered_36]
(
    [client_code] VARCHAR(30) NOT NULL,
    [client_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(10) NOT NULL,
    [del_mode] VARCHAR(50) NULL,
    [surface_zone] VARCHAR(40) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(50) NULL,
    [bank_rate] INT NULL,
    [branch_cd] VARCHAR(20) NULL,
    [delivered] VARCHAR(20) NOT NULL,
    [inbunch] VARCHAR(20) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_delivery
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_delivery]
(
    [Client_Code] VARCHAR(15) NULL,
    [Delivered] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_mis_diverse_dispatch
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_mis_diverse_dispatch]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Date] DATETIME NULL,
    [Type] VARCHAR(11) NULL,
    [Brtag] VARCHAR(11) NULL,
    [Sbtag] VARCHAR(11) NULL,
    [Cl_code] VARCHAR(11) NULL,
    [Sender_name] VARCHAR(80) NULL,
    [Department] VARCHAR(50) NULL,
    [Remark] VARCHAR(100) NULL,
    [Company] VARCHAR(40) NULL,
    [Mode] VARCHAR(25) NULL,
    [Pod] INT NULL,
    [Weight] VARCHAR(50) NULL,
    [Rate] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_temp_offlinemaster
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_temp_offlinemaster]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_temp_offlinemaster_22_10_2008
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_temp_offlinemaster_22_10_2008]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_temp_offlinemaster_new
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_temp_offlinemaster_new]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hist_temp_offlinemaster1
-- --------------------------------------------------
CREATE TABLE [dbo].[hist_temp_offlinemaster1]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.inbunch_delivered
-- --------------------------------------------------
CREATE TABLE [dbo].[inbunch_delivered]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.invoke
-- --------------------------------------------------
CREATE TABLE [dbo].[invoke]
(
    [cli_code] VARCHAR(8000) NULL,
    [Original_Invock_Date] VARCHAR(8000) NULL,
    [Original_Dispatch_Date] VARCHAR(8000) NULL,
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL,
    [new] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.invoke_dis
-- --------------------------------------------------
CREATE TABLE [dbo].[invoke_dis]
(
    [cli_code] VARCHAR(8000) NULL,
    [Original_Invock_Date] VARCHAR(8000) NULL,
    [Original_Dispatch_Date] VARCHAR(8000) NULL,
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IT_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[IT_STATUS]
(
    [Status] VARCHAR(100) NULL,
    [mode] VARCHAR(100) NULL,
    [Level] VARCHAR(100) NULL,
    [Group1] VARCHAR(100) NULL,
    [category] VARCHAR(100) NULL,
    [Priority] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.june_data
-- --------------------------------------------------
CREATE TABLE [dbo].[june_data]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.june6
-- --------------------------------------------------
CREATE TABLE [dbo].[june6]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc]
(
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL,
    [new] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_bal
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_bal]
(
    [Segment] VARCHAR(9) NOT NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] NUMERIC(18, 0) NULL,
    [rejected] VARCHAR(10) NULL,
    [dispatch_date] VARCHAR(8) NULL,
    [Remark2] VARCHAR(10) NULL,
    [Disp_bal] VARCHAR(10) NULL,
    [Remain_bal] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_bal1
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_bal1]
(
    [edt] DATETIME NOT NULL,
    [Segment] VARCHAR(9) NOT NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] NUMERIC(18, 0) NULL,
    [rejected] VARCHAR(10) NULL,
    [dispatch_date] VARCHAR(8) NULL,
    [Remark2] VARCHAR(10) NULL,
    [Disp_bal] VARCHAR(10) NULL,
    [Remain_bal] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_bal2
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_bal2]
(
    [edt] DATETIME NOT NULL,
    [Segment] VARCHAR(9) NOT NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] NUMERIC(18, 0) NULL,
    [rejected] VARCHAR(10) NULL,
    [dispatch_date] VARCHAR(8) NULL,
    [Remark2] VARCHAR(10) NULL,
    [Disp_bal] VARCHAR(10) NULL,
    [Remain_bal] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_fo
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_fo]
(
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_form_entry
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_form_entry]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL,
    [parsel_cnt] VARCHAR(50) NULL,
    [status] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_form_entry_new
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_form_entry_new]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [MUTUALFUND] CHAR(1) NULL,
    [CURRENCYDERIVATIVES] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [MUTUALFUNDQTY] VARCHAR(50) NULL,
    [CURRENCYDERIVATIVESQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL,
    [parsel_cnt] VARCHAR(50) NULL,
    [status] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_form_entry_old
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_form_entry_old]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL,
    [parsel_cnt] VARCHAR(50) NULL,
    [status] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_form_entry1
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_form_entry1]
(
    [Entry_Date] DATETIME NULL,
    [Challan_no] CHAR(10) NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [DRCR] CHAR(1) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_old
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_old]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL,
    [parsel_cnt] VARCHAR(50) NULL,
    [status] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_entry
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_entry]
(
    [Entry_type] VARCHAR(50) NULL,
    [Receive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [MUTUALFUND] CHAR(1) NULL,
    [CURRENCY_DERIVATIVES] CHAR(1) NULL,
    [BSEQTY] NUMERIC(18, 0) NULL,
    [NSEQTY] NUMERIC(18, 0) NULL,
    [FOQTY] NUMERIC(18, 0) NULL,
    [MCXQTY] NUMERIC(18, 0) NULL,
    [NCDXQTY] NUMERIC(18, 0) NULL,
    [DPINDQTY] NUMERIC(18, 0) NULL,
    [DPCOPRATEQTY] NUMERIC(18, 0) NULL,
    [DPCOMMOQTY] NUMERIC(18, 0) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_entry_new
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_entry_new]
(
    [Entry_type] VARCHAR(50) NULL,
    [Receive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [MUTUALFUND] CHAR(1) NULL,
    [CURRENCYDERIVATIVES] CHAR(1) NULL,
    [BSEQTY] NUMERIC(18, 0) NULL,
    [NSEQTY] NUMERIC(18, 0) NULL,
    [FOQTY] NUMERIC(18, 0) NULL,
    [MCXQTY] NUMERIC(18, 0) NULL,
    [NCDXQTY] NUMERIC(18, 0) NULL,
    [DPINDQTY] NUMERIC(18, 0) NULL,
    [DPCOPRATEQTY] NUMERIC(18, 0) NULL,
    [DPCOMMOQTY] NUMERIC(18, 0) NULL,
    [MUTUALFUNDQTY] NUMERIC(18, 0) NULL,
    [CURRENCYDERIVATIVESQTY] NUMERIC(18, 0) NULL,
    [REMARK] VARCHAR(100) NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_entry_old
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_entry_old]
(
    [Entry_type] VARCHAR(50) NULL,
    [Receive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] NUMERIC(18, 0) NULL,
    [NSEQTY] NUMERIC(18, 0) NULL,
    [FOQTY] NUMERIC(18, 0) NULL,
    [MCXQTY] NUMERIC(18, 0) NULL,
    [NCDXQTY] NUMERIC(18, 0) NULL,
    [DPINDQTY] NUMERIC(18, 0) NULL,
    [DPCOPRATEQTY] NUMERIC(18, 0) NULL,
    [DPCOMMOQTY] NUMERIC(18, 0) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_entry_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_entry_temp]
(
    [Entry_type] VARCHAR(50) NULL,
    [Receive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] NUMERIC(18, 0) NULL,
    [NSEQTY] NUMERIC(18, 0) NULL,
    [FOQTY] NUMERIC(18, 0) NULL,
    [MCXQTY] NUMERIC(18, 0) NULL,
    [NCDXQTY] NUMERIC(18, 0) NULL,
    [DPINDQTY] NUMERIC(18, 0) NULL,
    [DPCOPRATEQTY] NUMERIC(18, 0) NULL,
    [DPCOMMOQTY] NUMERIC(18, 0) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_entry1
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_entry1]
(
    [Recive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc_receive_form
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc_receive_form]
(
    [Entry_type] VARCHAR(50) NULL,
    [Receive_Date] DATETIME NULL,
    [Challan_no] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] NUMERIC(5, 0) NULL,
    [NSEQTY] NUMERIC(5, 0) NULL,
    [FOQTY] NUMERIC(5, 0) NULL,
    [MCXQTY] NUMERIC(5, 0) NULL,
    [NCDXQTY] NUMERIC(5, 0) NULL,
    [DPINDQTY] NUMERIC(5, 0) NULL,
    [DPCOPRATEQTY] NUMERIC(5, 0) NULL,
    [DPCOMMOQTY] NUMERIC(5, 0) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc1
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc1]
(
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kyc2
-- --------------------------------------------------
CREATE TABLE [dbo].[kyc2]
(
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.login
-- --------------------------------------------------
CREATE TABLE [dbo].[login]
(
    [name] VARCHAR(40) NOT NULL,
    [unique_code] VARCHAR(40) NULL,
    [password] VARCHAR(40) NULL,
    [designation] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.m
-- --------------------------------------------------
CREATE TABLE [dbo].[m]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.m1
-- --------------------------------------------------
CREATE TABLE [dbo].[m1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.m2
-- --------------------------------------------------
CREATE TABLE [dbo].[m2]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.m21
-- --------------------------------------------------
CREATE TABLE [dbo].[m21]
(
    [Client Code] NVARCHAR(255) NULL,
    [POD] FLOAT NULL,
    [Courier_Company] NVARCHAR(255) NULL,
    [Invoke_Date(dd/mm/yyyy))] NVARCHAR(255) NULL,
    [Dispatch_Date1] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.maytest2
-- --------------------------------------------------
CREATE TABLE [dbo].[maytest2]
(
    [clientcode] VARCHAR(25) NULL,
    [Invokedate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_record
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_record]
(
    [Code] VARCHAR(255) NULL,
    [Name Of Account] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Opening Balance] VARCHAR(255) NULL,
    [Debit during the month] VARCHAR(255) NULL,
    [Credit during the month] VARCHAR(255) NULL,
    [Closing Dr] VARCHAR(255) NULL,
    [Closing Cr] VARCHAR(255) NULL,
    [Closing Balance] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Mis_Diverse_Dispatch
-- --------------------------------------------------
CREATE TABLE [dbo].[Mis_Diverse_Dispatch]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Date] VARCHAR(25) NULL,
    [Type] VARCHAR(11) NULL,
    [Brtag] VARCHAR(11) NULL,
    [Sbtag] VARCHAR(11) NULL,
    [Cl_code] VARCHAR(11) NULL,
    [Sender_name] VARCHAR(80) NULL,
    [Department] VARCHAR(50) NULL,
    [Remark] VARCHAR(100) NULL,
    [Company] VARCHAR(40) NULL,
    [Mode] VARCHAR(55) NULL,
    [Pod] VARCHAR(100) NULL,
    [Weight] VARCHAR(50) NULL,
    [Rate] FLOAT NULL,
    [Status] VARCHAR(50) NULL,
    [ReturnedDate] VARCHAR(15) NULL,
    [Reason] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_diverse_dispatch_new
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_diverse_dispatch_new]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [Date] VARCHAR(25) NULL,
    [Type] VARCHAR(11) NULL,
    [Brtag] VARCHAR(11) NULL,
    [Sbtag] VARCHAR(11) NULL,
    [Cl_code] VARCHAR(11) NULL,
    [Sender_name] VARCHAR(80) NULL,
    [Department] VARCHAR(50) NULL,
    [Remark] VARCHAR(100) NULL,
    [Company] VARCHAR(40) NULL,
    [Mode] VARCHAR(55) NULL,
    [Pod] VARCHAR(100) NULL,
    [Weight] VARCHAR(50) NULL,
    [Rate] FLOAT NULL,
    [Status] VARCHAR(50) NULL,
    [ReturnedDate] VARCHAR(15) NULL,
    [Reason] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_return
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_return]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_return_de
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_return_de]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_return1
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_return1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.misc1
-- --------------------------------------------------
CREATE TABLE [dbo].[misc1]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mismatch_data1
-- --------------------------------------------------
CREATE TABLE [dbo].[mismatch_data1]
(
    [client_code] VARCHAR(8000) NULL,
    [Col002] VARCHAR(8000) NULL,
    [Col003] VARCHAR(8000) NULL,
    [Col004] VARCHAR(8000) NULL,
    [Col005] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.misrecord$
-- --------------------------------------------------
CREATE TABLE [dbo].[misrecord$]
(
    [Client_CODE] NVARCHAR(255) NULL,
    [Dispatch_date] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mm
-- --------------------------------------------------
CREATE TABLE [dbo].[mm]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mumbai1
-- --------------------------------------------------
CREATE TABLE [dbo].[mumbai1]
(
    [Client Code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.myTEST
-- --------------------------------------------------
CREATE TABLE [dbo].[myTEST]
(
    [CL_CODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.n2
-- --------------------------------------------------
CREATE TABLE [dbo].[n2]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[ncdx]
(
    [Code] VARCHAR(255) NULL,
    [Name Of Account] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Opening Balance] VARCHAR(255) NULL,
    [Debit during the month] VARCHAR(255) NULL,
    [Credit during the month] VARCHAR(255) NULL,
    [Closing Dr] VARCHAR(255) NULL,
    [Closing Cr] VARCHAR(255) NULL,
    [Closing Balance] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new
-- --------------------------------------------------
CREATE TABLE [dbo].[new]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new_14
-- --------------------------------------------------
CREATE TABLE [dbo].[new_14]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new_delivered
-- --------------------------------------------------
CREATE TABLE [dbo].[new_delivered]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new_nse
-- --------------------------------------------------
CREATE TABLE [dbo].[new_nse]
(
    [Code] VARCHAR(255) NULL,
    [Name Of Account] VARCHAR(255) NULL,
    [Branch] VARCHAR(255) NULL,
    [Opening Balance] VARCHAR(255) NULL,
    [Debit during the month] VARCHAR(255) NULL,
    [Credit during the month] VARCHAR(255) NULL,
    [Closing Balance] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.new1
-- --------------------------------------------------
CREATE TABLE [dbo].[new1]
(
    [cl_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newclient
-- --------------------------------------------------
CREATE TABLE [dbo].[newclient]
(
    [PARTY CODE] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newdata
-- --------------------------------------------------
CREATE TABLE [dbo].[newdata]
(
    [client_code] VARCHAR(8000) NULL,
    [pod] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newx
-- --------------------------------------------------
CREATE TABLE [dbo].[newx]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_bal
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_bal]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse1
-- --------------------------------------------------
CREATE TABLE [dbo].[nse1]
(
    [Client Code] VARCHAR(8000) NULL,
    [Dispatch_date] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse2
-- --------------------------------------------------
CREATE TABLE [dbo].[nse2]
(
    [Client Code] VARCHAR(8000) NULL,
    [Inbunch] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.old_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[old_temp]
(
    [client_code] VARCHAR(30) NULL,
    [c_code] VARCHAR(30) NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pen
-- --------------------------------------------------
CREATE TABLE [dbo].[pen]
(
    [branch_cd] VARCHAR(100) NULL,
    [Pending] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pen_d_1
-- --------------------------------------------------
CREATE TABLE [dbo].[pen_d_1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [dispatch_date] DATETIME NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Pen_rec
-- --------------------------------------------------
CREATE TABLE [dbo].[Pen_rec]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pen1
-- --------------------------------------------------
CREATE TABLE [dbo].[pen1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POD_CH1
-- --------------------------------------------------
CREATE TABLE [dbo].[POD_CH1]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD1] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pod_change
-- --------------------------------------------------
CREATE TABLE [dbo].[pod_change]
(
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pod_changes1
-- --------------------------------------------------
CREATE TABLE [dbo].[pod_changes1]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pod_details
-- --------------------------------------------------
CREATE TABLE [dbo].[pod_details]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POD_entry
-- --------------------------------------------------
CREATE TABLE [dbo].[POD_entry]
(
    [Pod_no] VARCHAR(50) NULL,
    [Receive_dt] DATETIME NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Tel_no] VARCHAR(50) NULL,
    [pod_delivered] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.podchange
-- --------------------------------------------------
CREATE TABLE [dbo].[podchange]
(
    [Client Code] VARCHAR(8000) NULL,
    [POD] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.poddata$
-- --------------------------------------------------
CREATE TABLE [dbo].[poddata$]
(
    [Client Code] NVARCHAR(255) NULL,
    [Branch] NVARCHAR(255) NULL,
    [POD1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rachana
-- --------------------------------------------------
CREATE TABLE [dbo].[rachana]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.recv
-- --------------------------------------------------
CREATE TABLE [dbo].[recv]
(
    [receive_date] DATETIME NULL,
    [segment] VARCHAR(20) NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark] VARCHAR(100) NULL,
    [openbal] INT NOT NULL,
    [rejected] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.recv_form
-- --------------------------------------------------
CREATE TABLE [dbo].[recv_form]
(
    [receive_date] DATETIME NULL,
    [segment] VARCHAR(20) NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark] VARCHAR(100) NULL,
    [openbal] INT NULL,
    [rejected] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.recv_form_new
-- --------------------------------------------------
CREATE TABLE [dbo].[recv_form_new]
(
    [receive_date] DATETIME NULL,
    [segment] VARCHAR(20) NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark] VARCHAR(100) NULL,
    [openbal] INT NULL,
    [rejected] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.recv_form_old
-- --------------------------------------------------
CREATE TABLE [dbo].[recv_form_old]
(
    [receive_date] DATETIME NULL,
    [segment] VARCHAR(20) NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark] VARCHAR(100) NULL,
    [openbal] INT NULL,
    [rejected] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.return_remarks
-- --------------------------------------------------
CREATE TABLE [dbo].[return_remarks]
(
    [reason] VARCHAR(50) NULL,
    [remark] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.s
-- --------------------------------------------------
CREATE TABLE [dbo].[s]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL,
    [fld_Br_Remark] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SampleForTutorials
-- --------------------------------------------------
CREATE TABLE [dbo].[SampleForTutorials]
(
    [AutoID] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Address] VARCHAR(100) NULL,
    [Phone] VARCHAR(10) NULL,
    [City] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.segment_bal
-- --------------------------------------------------
CREATE TABLE [dbo].[segment_bal]
(
    [segment] VARCHAR(20) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [receive_remark] VARCHAR(100) NULL,
    [openbal] INT NULL,
    [rej_qty] INT NULL,
    [Dispatch_remark] VARCHAR(100) NULL,
    [Dispatch_qty] CHAR(1) NULL,
    [Remain_bal] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sheet1
-- --------------------------------------------------
CREATE TABLE [dbo].[Sheet1]
(
    [ClientCode] NVARCHAR(255) NULL,
    [POD] FLOAT NULL,
    [DispatchDate] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sheet1$
-- --------------------------------------------------
CREATE TABLE [dbo].[Sheet1$]
(
    [DATE] DATETIME NULL,
    [DOC_NO] FLOAT NULL,
    [CITY] NVARCHAR(255) NULL,
    [PARTY] NVARCHAR(255) NULL,
    [Courier name ] NVARCHAR(255) NULL,
    [RowId] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.shree balaji courier2
-- --------------------------------------------------
CREATE TABLE [dbo].[shree balaji courier2]
(
    [client code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.shree_bal
-- --------------------------------------------------
CREATE TABLE [dbo].[shree_bal]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.shree_mumbai
-- --------------------------------------------------
CREATE TABLE [dbo].[shree_mumbai]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.T
-- --------------------------------------------------
CREATE TABLE [dbo].[T]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t#
-- --------------------------------------------------
CREATE TABLE [dbo].[t#]
(
    [branch_cd] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t1
-- --------------------------------------------------
CREATE TABLE [dbo].[t1]
(
    [branch_cd] VARCHAR(100) NULL,
    [dispatched] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.T12
-- --------------------------------------------------
CREATE TABLE [dbo].[T12]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t2
-- --------------------------------------------------
CREATE TABLE [dbo].[t2]
(
    [branch_cd] VARCHAR(100) NULL,
    [delivered] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t3
-- --------------------------------------------------
CREATE TABLE [dbo].[t3]
(
    [branch_cd] VARCHAR(100) NULL,
    [returned] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t4
-- --------------------------------------------------
CREATE TABLE [dbo].[t4]
(
    [branch_cd] VARCHAR(100) NULL,
    [inbunched] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t5
-- --------------------------------------------------
CREATE TABLE [dbo].[t5]
(
    [branch_cd] VARCHAR(100) NULL,
    [deliveredBr] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Delivered_Branch
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Delivered_Branch]
(
    [fld_Clcode] VARCHAR(15) NULL,
    [fld_Clname] VARCHAR(100) NULL,
    [fld_Pod] VARCHAR(15) NULL,
    [fld_company] VARCHAR(20) NULL,
    [fld_branch] VARCHAR(15) NULL,
    [fld_sbCode] VARCHAR(15) NULL,
    [fld_Reason] VARCHAR(20) NULL,
    [fld_zone] VARCHAR(50) NULL,
    [fld_weight] VARCHAR(10) NULL,
    [fld_rate] VARCHAR(15) NULL,
    [fld_date] DATETIME NULL,
    [Fld_delivery_date] DATETIME NULL,
    [fld_Br_Remark] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Kit_sms
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Kit_sms]
(
    [MobileNumber] VARCHAR(20) NULL,
    [Message] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Reason
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Reason]
(
    [Id] VARCHAR(255) NULL,
    [REASONS] VARCHAR(255) NULL,
    [REMARK] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_ScanDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_ScanDetails]
(
    [Fld_Srno] INT IDENTITY(1,1) NOT NULL,
    [Fld_PartyCode] VARCHAR(30) NULL,
    [Fld_FileName] VARCHAR(30) NULL,
    [Fld_Segments] VARCHAR(15) NULL,
    [Fld_ImageType] VARCHAR(10) NULL,
    [Fld_EnteredDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Sms_file
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Sms_file]
(
    [Heading] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_temp_branchdata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_temp_branchdata]
(
    [client_code] VARCHAR(50) NULL,
    [Dispatch_Date] DATETIME NULL,
    [Reason] VARCHAR(300) NULL,
    [POD] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tem1
-- --------------------------------------------------
CREATE TABLE [dbo].[tem1]
(
    [edt] DATETIME NULL,
    [Segment] VARCHAR(10) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(50) NULL,
    [remark1] VARCHAR(100) NULL,
    [Openbal] VARCHAR(50) NULL,
    [rejected] INT NOT NULL,
    [dispatch_date] DATETIME NULL,
    [remark2] VARCHAR(100) NULL,
    [disp_qty] VARCHAR(50) NULL,
    [remain_bal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tem12
-- --------------------------------------------------
CREATE TABLE [dbo].[tem12]
(
    [Dispatch_Date] DATETIME NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Dispatch_Mode] VARCHAR(50) NULL,
    [Name] VARCHAR(50) NULL,
    [Telphone_no] VARCHAR(50) NULL,
    [POD] VARCHAR(50) NULL,
    [Delivery_Mode] VARCHAR(50) NULL,
    [Weight] VARCHAR(50) NULL,
    [Courier_Company] VARCHAR(50) NULL,
    [Packet_Rate] VARCHAR(50) NULL,
    [BSE] CHAR(1) NULL,
    [NSE] CHAR(1) NULL,
    [FO] CHAR(1) NULL,
    [MCX] CHAR(1) NULL,
    [NCDX] CHAR(1) NULL,
    [DPIND] CHAR(1) NULL,
    [DPCOPRATE] CHAR(1) NULL,
    [DPCOMMO] CHAR(1) NULL,
    [BSEQTY] VARCHAR(50) NULL,
    [NSEQTY] VARCHAR(50) NULL,
    [FOQTY] VARCHAR(50) NULL,
    [MCXQTY] VARCHAR(50) NULL,
    [NCDXQTY] VARCHAR(50) NULL,
    [DPINDQTY] VARCHAR(50) NULL,
    [DPCOPRATEQTY] VARCHAR(50) NULL,
    [DPCOMMOQTY] VARCHAR(50) NULL,
    [REMARK] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_1]
(
    [client] VARCHAR(255) NULL,
    [mcx] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_courier_rates
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_courier_rates]
(
    [company] VARCHAR(100) NULL,
    [type] VARCHAR(100) NULL,
    [lowerl] NUMERIC(10, 0) NULL,
    [upperl] NUMERIC(10, 0) NULL,
    [unit] VARCHAR(10) NULL,
    [rate] NUMERIC(10, 2) NULL,
    [default_flag] NUMERIC(2, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_DISPATCH_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_DISPATCH_STATUS]
(
    [client_code] VARCHAR(20) NULL,
    [pod] VARCHAR(20) NULL,
    [compnay] VARCHAR(50) NULL,
    [dispatch_date] VARCHAR(15) NULL,
    [status] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_hist_temp_offlinemaster14032013
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_hist_temp_offlinemaster14032013]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_login
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_login]
(
    [name] VARCHAR(40) NOT NULL,
    [unique_code] VARCHAR(40) NULL,
    [password] VARCHAR(40) NULL,
    [designation] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_MIS
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_MIS]
(
    [date] DATETIME NULL,
    [dispatched] NUMERIC(10, 0) NULL,
    [delivered] NUMERIC(10, 0) NULL,
    [returned] NUMERIC(10, 0) NULL,
    [inbunched] NUMERIC(10, 0) NULL,
    [deliveredBr] NUMERIC(9, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_MIS_BRANCHWISE
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_MIS_BRANCHWISE]
(
    [date] DATETIME NULL,
    [dispatched] NUMERIC(10, 0) NULL,
    [delivered] NUMERIC(10, 0) NULL,
    [returned] NUMERIC(10, 0) NULL,
    [inbunched] NUMERIC(10, 0) NULL,
    [branch] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_MIS_COURIERWISE
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_MIS_COURIERWISE]
(
    [date] DATETIME NULL,
    [dispatched] NUMERIC(10, 0) NULL,
    [delivered] NUMERIC(10, 0) NULL,
    [returned] NUMERIC(10, 0) NULL,
    [inbunched] NUMERIC(10, 0) NULL,
    [courier] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_mis_new
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_mis_new]
(
    [date] DATETIME NULL,
    [dispatched] NUMERIC(10, 0) NULL,
    [delivered] NUMERIC(10, 0) NULL,
    [returned] NUMERIC(10, 0) NULL,
    [inbunched] NUMERIC(10, 0) NULL,
    [deliveredBr] NUMERIC(9, 0) NULL,
    [Pending] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_MIS1
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_MIS1]
(
    [date] DATETIME NULL,
    [dispatched] NUMERIC(10, 0) NULL,
    [delivered] NUMERIC(10, 0) NULL,
    [returned] NUMERIC(10, 0) NULL,
    [inbunched] NUMERIC(10, 0) NULL,
    [deliveredBr] NUMERIC(9, 0) NULL,
    [Pending] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_offlinemaster
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_offlinemaster]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_offlinemaster_new
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_offlinemaster_new]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_offlinemaster_new1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_offlinemaster_new1]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_offlinemaster1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_offlinemaster1]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_offlinemaster2
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_offlinemaster2]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_old
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_old]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ret
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ret]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1]
(
    [fld_Clcode] VARCHAR(15) NULL,
    [fld_Clname] VARCHAR(100) NULL,
    [fld_Pod] VARCHAR(15) NULL,
    [fld_company] VARCHAR(20) NULL,
    [fld_branch] VARCHAR(15) NULL,
    [fld_sbCode] VARCHAR(15) NULL,
    [fld_Reason] VARCHAR(20) NULL,
    [fld_zone] VARCHAR(50) NULL,
    [fld_weight] VARCHAR(10) NULL,
    [fld_rate] VARCHAR(15) NULL,
    [fld_date] DATETIME NULL,
    [Fld_delivery_date] DATETIME NULL,
    [fld_Br_Remark] VARCHAR(150) NULL,
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp12
-- --------------------------------------------------
CREATE TABLE [dbo].[temp12]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp2
-- --------------------------------------------------
CREATE TABLE [dbo].[temp2]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp3
-- --------------------------------------------------
CREATE TABLE [dbo].[temp3]
(
    [cour_compn_name] VARCHAR(100) NULL,
    [dispatched] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp4
-- --------------------------------------------------
CREATE TABLE [dbo].[temp4]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempKYC
-- --------------------------------------------------
CREATE TABLE [dbo].[tempKYC]
(
    [entry_type] VARCHAR(100) NULL,
    [receive_date] DATETIME NULL,
    [challan_no] VARCHAR(100) NULL,
    [dispatch_date] DATETIME NULL,
    [branch_cd] VARCHAR(100) NULL,
    [open_bal] FLOAT NULL,
    [curr_bal] FLOAT NULL,
    [remain_bal] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temptbl
-- --------------------------------------------------
CREATE TABLE [dbo].[temptbl]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test
-- --------------------------------------------------
CREATE TABLE [dbo].[test]
(
    [weight] VARCHAR(8000) NULL,
    [bank_rate_change] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TM
-- --------------------------------------------------
CREATE TABLE [dbo].[TM]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tp
-- --------------------------------------------------
CREATE TABLE [dbo].[tp]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trycsv
-- --------------------------------------------------
CREATE TABLE [dbo].[trycsv]
(
    [a] CHAR(10) NULL,
    [b] CHAR(10) NULL,
    [c] CHAR(10) NULL,
    [d] CHAR(10) NULL,
    [e] CHAR(10) NULL,
    [f] CHAR(10) NULL,
    [g] CHAR(10) NULL,
    [h] CHAR(10) NULL,
    [i] CHAR(10) NULL,
    [j] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TT1
-- --------------------------------------------------
CREATE TABLE [dbo].[TT1]
(
    [cl_code] VARCHAR(30) NOT NULL,
    [party_code] VARCHAR(30) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(40) NULL,
    [sub_broker] VARCHAR(40) NULL,
    [trader] VARCHAR(40) NULL,
    [imp_status] VARCHAR(5) NULL,
    [NSE] VARCHAR(5) NULL,
    [BSE] VARCHAR(5) NULL,
    [FO] VARCHAR(5) NULL,
    [BSEFO] VARCHAR(5) NULL,
    [NCDX] VARCHAR(5) NULL,
    [MCX] VARCHAR(5) NULL,
    [MCD] VARCHAR(5) NULL,
    [NSX] VARCHAR(5) NULL,
    [tdate] DATETIME NULL,
    [updated_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ttp
-- --------------------------------------------------
CREATE TABLE [dbo].[ttp]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ttp_bkp
-- --------------------------------------------------
CREATE TABLE [dbo].[ttp_bkp]
(
    [client_code] VARCHAR(100) NOT NULL,
    [client_name] VARCHAR(200) NULL,
    [sb_code] VARCHAR(20) NULL,
    [dispatch_date] DATETIME NULL,
    [pod] VARCHAR(100) NOT NULL,
    [del_mode] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(200) NULL,
    [weight] VARCHAR(50) NULL,
    [cour_compn_name] VARCHAR(100) NULL,
    [bank_rate] NUMERIC(10, 2) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [delivered] VARCHAR(100) NOT NULL,
    [inbunch] VARCHAR(100) NOT NULL,
    [courier_id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ttt
-- --------------------------------------------------
CREATE TABLE [dbo].[ttt]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL,
    [fld_Br_Remark] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ty
-- --------------------------------------------------
CREATE TABLE [dbo].[ty]
(
    [empno] VARCHAR(1) NULL,
    [sal] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.und
-- --------------------------------------------------
CREATE TABLE [dbo].[und]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL,
    [fld_Br_Remark] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.undelivered
-- --------------------------------------------------
CREATE TABLE [dbo].[undelivered]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL,
    [fld_Br_Remark] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.undelivered_1
-- --------------------------------------------------
CREATE TABLE [dbo].[undelivered_1]
(
    [client_code] VARCHAR(100) NULL,
    [long_name] VARCHAR(100) NULL,
    [dispatch_date] DATETIME NULL,
    [POD] VARCHAR(50) NULL,
    [company] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [sb_code] VARCHAR(50) NULL,
    [weight] VARCHAR(50) NULL,
    [rate] VARCHAR(50) NULL,
    [Reason] VARCHAR(100) NULL,
    [id1] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.undelivered_new
-- --------------------------------------------------
CREATE TABLE [dbo].[undelivered_new]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.undelivered_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[undelivered_temp]
(
    [client_code] VARCHAR(100) NULL,
    [long_name] VARCHAR(100) NULL,
    [dispatch_date] DATETIME NULL,
    [POD] VARCHAR(50) NULL,
    [company] VARCHAR(100) NULL,
    [surface_zone] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [sb_code] VARCHAR(50) NULL,
    [weight] VARCHAR(50) NULL,
    [rate] VARCHAR(50) NULL,
    [Reason] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.undelivered1
-- --------------------------------------------------
CREATE TABLE [dbo].[undelivered1]
(
    [client_code] VARCHAR(100) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [sb_code] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(100) NULL,
    [return_date] DATETIME NULL,
    [reason_undelivered] VARCHAR(100) NULL,
    [action_taken] VARCHAR(100) NULL,
    [Send_to_branch] VARCHAR(100) NULL,
    [remark] VARCHAR(2000) NULL,
    [undelivered] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.up
-- --------------------------------------------------
CREATE TABLE [dbo].[up]
(
    [CLIENT CODE] VARCHAR(255) NULL,
    [DISPATCH DATE] VARCHAR(255) NULL,
    [REASONS] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ups
-- --------------------------------------------------
CREATE TABLE [dbo].[ups]
(
    [Server] NVARCHAR(255) NULL,
    [TCP COUNT 10:15 AM] FLOAT NULL,
    [TCP COUNT 03:15 PM] FLOAT NULL,
    [SURVILENCE COUNT 08:15 AM] FLOAT NULL,
    [REMARK] NVARCHAR(255) NULL,
    [Log Date] DATETIME NULL,
    [Entry By] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserTable
-- --------------------------------------------------
CREATE TABLE [dbo].[UserTable]
(
    [User_ID] INT IDENTITY(1,1) NOT NULL,
    [User_Name] VARCHAR(30) NULL,
    [Type] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.usp_sent_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[usp_sent_branch]
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
-- TABLE dbo.vichare
-- --------------------------------------------------
CREATE TABLE [dbo].[vichare]
(
    [Clientcode] VARCHAR(255) NULL,
    [POD] VARCHAR(255) NULL,
    [POD1] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vichare_cl
-- --------------------------------------------------
CREATE TABLE [dbo].[vichare_cl]
(
    [Client_Code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vichare_old
-- --------------------------------------------------
CREATE TABLE [dbo].[vichare_old]
(
    [client_code] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vichare2
-- --------------------------------------------------
CREATE TABLE [dbo].[vichare2]
(
    [Client_Code] VARCHAR(255) NULL,
    [POD] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.x
-- --------------------------------------------------
CREATE TABLE [dbo].[x]
(
    [MobileNumber] VARCHAR(20) NULL,
    [Message] VARCHAR(5000) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.abc
-- --------------------------------------------------
create trigger abc
 on
 usertable
 for insert
 as
 insert usertable values('','')

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_User_INSERT
-- --------------------------------------------------
CREATE TRIGGER tr_User_INSERT
ON UserTable
FOR INSERT
AS
PRINT GETDATE()

GO

-- --------------------------------------------------
-- TRIGGER dbo.trg_delb
-- --------------------------------------------------
create trigger trg_delb on delb
after delete
as
with a
as
(
select row_number() over( partition by client_code order by client_code) as rn,* from delb
)
delete from a where rn > 1

GO

-- --------------------------------------------------
-- VIEW dbo.V_Desp_Qty
-- --------------------------------------------------
CREATE View V_Desp_Qty  
as  
  
select * from   
(  
select top 1 (remain_bal),segment from balance_form_new where segment='bse'  order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='fo'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='nse'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='mcx'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='ncdx'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='dpind'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='dpcoprate'    order by remain_bal
union all  
select top 1 (remain_bal),segment from balance_form_new where segment='dpcommo'   order by remain_bal
) x

GO

-- --------------------------------------------------
-- VIEW dbo.V_Desp_Qty_new
-- --------------------------------------------------
CREATE View V_Desp_Qty_new    
as    
    
select * from     
(    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='bse' order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='fo'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='nse'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='mcx'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='ncdx'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpind'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpcoprate'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpcommo'   order by edt desc
) x

GO

-- --------------------------------------------------
-- VIEW dbo.V_Desp_Qty_new1
-- --------------------------------------------------
CREATE View V_Desp_Qty_new1  
as    
  
select * from     
(     
select top 1 edt,(remain_bal),segment from balance_form_new where segment='bse' order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='fo' order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='nse'order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='mcx'order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='ncdx'  order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpind'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpcoprate'    order by edt desc
union all    
select top 1 edt,(remain_bal),segment from balance_form_new where segment='dpcommo'   order by edt desc
) x

GO

