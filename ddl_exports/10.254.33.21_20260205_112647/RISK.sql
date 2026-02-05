-- DDL Export
-- Server: 10.254.33.21
-- Database: RISK
-- Exported: 2026-02-05T11:27:14.946970

USE RISK;
GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_AngelUserbranch_NotInUse
-- --------------------------------------------------
create FUNCTION [dbo].[Fn_AngelUserbranch_NotInUse](@UserName varchar(15))     
RETURNS @tbl TABLE (client varchar(15) NOT NULL) AS    
BEGIN    

 declare @user  varchar(15)    
 declare @code  varchar(15)    
 select @user=access_to,@code=access_code from risk.dbo.user_login(nolock) where username='REGION'
 declare @str as varchar(200)

 set @str=' '

 if @user='BROKER'    
 BEGIN    
	INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock)    
 END    
 if @user='MIXED'    
 BEGIN
/*
	declare @seqno as int,@alv as varchar(25)
	set @seqno = 0
	while (select count(1) from risk.dbo.access_level (nolock) where access_level_Active=1 and access_level_seq >= @seqno) > 0
	begin
		set @str=''
		select @alv=access_level_value from risk.dbo.access_level (nolock) where access_level_Active=1 group by access_level_value having min(access_level_seq) = @seqno
		select @seqno=min(access_level_seq) from risk.dbo.access_level (nolock) where access_level_Active=1 and access_level_seq > @seqno
		set @str = ' select client from general.dbo.vw_rms_client_vertical(nolock) where '+@alv+'=(select '+@alv+' from risk.dbo.Vw_MixedGrpMaster (nolock) where Mixed_Mast_cd='''+@code+''' )'
		insert into @tbl exec(@str)
	end
*/
	INSERT into @tbl select client from Vw_MixedAccessClient where Mixed_Mast_cd=@code

 END
 ELSE
 BEGIN
/*
	set @str=''
    	set @str = ' select client from general.dbo.vw_rms_client_vertical(nolock) where '+@user+'='''+@code+''''
	insert into @tbl exec(@str)
*/
	INSERT into @tbl select client from Vw_MixedAccessClient where Mixed_Mast_cd=@code

 END

RETURN
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_MixedUserClient
-- --------------------------------------------------
CREATE FUNCTION [dbo].[Fn_MixedUserClient](@UserName varchar(15))       
RETURNS @tbl TABLE (client varchar(15) NOT NULL) AS      
BEGIN      
 declare @user  varchar(15)      
 declare @code  varchar(15)      
 select @user=access_to,@code=access_code from risk.dbo.user_login(nolock) where username=@UserName      
 if @user='BROKER'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock)      
 END      
 if @user='ZONE'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  Zone = @code      
 END      
 if @user='REGION'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  region = @code      
 END      
 if @user='BRANCH'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  branch = @code      
 END      
 if @user='SB'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  SB = @code      
 END      
   if @user='ZONEMAST'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where exists (select Zone_cd from risk.dbo.zoneMaster_grp where Zone_mast_cd=@code)      
  END      
 if @user='RGMAST'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  exists (select Region_cd from risk.dbo.RegionMaster_grp where Region_mast_cd=@code)      
 END      
 if @user='BR-MAST'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  exists (select Branch_cd from risk.dbo.BranchMaster_grp where branch_mast_cd=@code)      
 END      
 if @user='SBMAST'      
 BEGIN      
  INSERT into @tbl select client from general.dbo.vw_rms_client_vertical(nolock) where  exists (select Sb_cd from risk.dbo.SBMaster_grp where SB_mast_cd=@code)      
 END    
 if @user='MIXED'      
 BEGIN      
  INSERT into @tbl select client from risk.dbo.Vw_MixedAccessClient where Mixed_Mast_cd=@code  
 END      
      
RETURN      
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_MixedUserSB
-- --------------------------------------------------

CREATE FUNCTION [dbo].[Fn_MixedUserSB](@UserName varchar(15),@Rpt_Level as varchar(10),@Rpt_code as varchar(25))         
RETURNS @tbl TABLE (code varchar(15) NOT NULL) AS        
BEGIN        
 declare @user  varchar(15)        
 declare @code  varchar(15)        

select @user=access_to,@code=access_code from risk.dbo.user_login(nolock) where username=@UserName        

if (select count(1) from access_level (nolock) where access_level_seq <= 400 and access_level_value =@Rpt_Level) >= 1
begin
	 if @user='BROKER'        
	 BEGIN        
	  INSERT into @tbl select distinct code=branch from general.dbo.vw_rms_branch_vertical(nolock)        
	 END        
	 if @user='ZONE'        
	 BEGIN        
	  INSERT into @tbl select distinct code=branch   from general.dbo.vw_rms_branch_vertical(nolock) where  Zone = @code        
	 END        
	 if @user='REGION'        
	 BEGIN        
	  INSERT into @tbl select distinct code=branch   from general.dbo.vw_rms_branch_vertical(nolock) where  region = @code        
	 END        
	 if @user='BRANCH'        
	 BEGIN        
	  INSERT into @tbl select distinct code=branch   from general.dbo.vw_rms_branch_vertical(nolock) where  branch = @code        
	 END        
    if @user='ZONEMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.branch  from general.dbo.vw_rms_branch_vertical a (nolock) where exists (select Zone_cd from risk.dbo.zoneMaster_grp b (nolock) where Zone_mast_cd=@code and a.Zone=b.zone_Cd)        
	  END        
	 if @user='RGMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.branch  from general.dbo.vw_rms_branch_vertical a (nolock) where  exists (select Region_cd from risk.dbo.RegionMaster_grp b (nolock) where Region_mast_cd=@code and a.region=b.Region_cd)        
	 END        
	 if @user='BR-MAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.branch  from general.dbo.vw_rms_branch_vertical a (nolock) where  exists (select Branch_cd from risk.dbo.BranchMaster_grp b (nolock) where branch_mast_cd=@code and a.branch=b.Branch_cd)        
	 END        
	 if @user='MIXED'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb from risk.dbo.Vw_MixedAccessSB where Mixed_Mast_cd=@code    
	 END        
END
        
if (select count(1) from access_level (nolock) where access_level_seq > 400 and access_level_seq <= 700 and access_level_value =@Rpt_Level) >= 1
BEGIN
	if @user='BROKER'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb from general.dbo.vw_rms_sb_vertical(nolock)        
	 END        
	 if @user='ZONE'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb   from general.dbo.vw_rms_sb_vertical(nolock) where  Zone = @code        
	 END        
	 if @user='REGION'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb   from general.dbo.vw_rms_sb_vertical(nolock) where  region = @code        
	 END        
	 if @user='BRANCH'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb   from general.dbo.vw_rms_sb_vertical(nolock) where  branch = @code        
	 END        
    if @user='ZONEMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.sb  from general.dbo.vw_rms_sb_vertical a (nolock) where exists (select Zone_cd from risk.dbo.zoneMaster_grp b (nolock) where Zone_mast_cd=@code and a.Zone=b.zone_Cd)        
	  END        
	 if @user='RGMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.sb  from general.dbo.vw_rms_sb_vertical a (nolock) where  exists (select Region_cd from risk.dbo.RegionMaster_grp b (nolock) where Region_mast_cd=@code and a.region=b.Region_cd)        
	 END        
	 if @user='BR-MAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.sb  from general.dbo.vw_rms_sb_vertical a (nolock) where  exists (select Branch_cd from risk.dbo.BranchMaster_grp b (nolock) where branch_mast_cd=@code and a.branch=b.Branch_cd)        
	 END        
	 if @user='SB'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb  from general.dbo.vw_rms_sb_vertical(nolock) where  SB = @code        
	 END        
	 if @user='SBMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.sb  from general.dbo.vw_rms_sb_vertical a (nolock) where  exists (select Sb_cd from risk.dbo.SBMaster_grp b (nolock) where SB_mast_cd=@code and a.sb=b.Sb_cd)        
	 END      
	 if @user='MIXED'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb from risk.dbo.Vw_MixedAccessSB where Mixed_Mast_cd=@code    
	 END        
END

if (select count(1) from access_level (nolock) where access_level_seq > 700 and access_level_value =@Rpt_Level) >= 1
begin
	if @user='BROKER'        
	 BEGIN        
	  INSERT into @tbl select distinct code=CLIENT from general.dbo.vw_rms_client_vertical(nolock) WHERE CLIENT LIKE @Rpt_code       
	 END        
	 if @user='ZONE'        
	 BEGIN        
	  INSERT into @tbl select distinct code=CLIENT   from general.dbo.vw_rms_client_vertical(nolock) where  Zone = @code AND CLIENT LIKE @Rpt_code       
	 END        
	 if @user='REGION'        
	 BEGIN        
	  INSERT into @tbl select distinct code=CLIENT   from general.dbo.vw_rms_client_vertical(nolock) where  region = @code  AND CLIENT LIKE @Rpt_code      
	 END        
	 if @user='BRANCH'        
	 BEGIN        
	  INSERT into @tbl select distinct code=CLIENT   from general.dbo.vw_rms_client_vertical(nolock) where  branch = @code  AND CLIENT LIKE @Rpt_code      
	 END        
    if @user='ZONEMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.CLIENT  from general.dbo.vw_rms_client_vertical a (nolock) where exists (select Zone_cd from risk.dbo.zoneMaster_grp b (nolock) where Zone_mast_cd=@code and a.Zone=b.zone_Cd) AND CLIENT LIKE @Rpt_code       
	  END        
	 if @user='RGMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.CLIENT  from general.dbo.vw_rms_client_vertical a (nolock) where  exists (select Region_cd from risk.dbo.RegionMaster_grp b (nolock) where Region_mast_cd=@code and a.region=b.Region_cd) AND CLIENT LIKE @Rpt_code       
	 END        
	 if @user='BR-MAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.CLIENT  from general.dbo.vw_rms_client_vertical a (nolock) where  exists (select Branch_cd from risk.dbo.BranchMaster_grp b (nolock) where branch_mast_cd=@code and a.branch=b.Branch_cd) AND CLIENT LIKE @Rpt_code       
	 END        
	 if @user='SB'        
	 BEGIN        
	  INSERT into @tbl select distinct code=sb  from general.dbo.vw_rms_client_vertical(nolock) where  SB = @code AND CLIENT LIKE @Rpt_code       
	 END        
	 if @user='SBMAST'        
	 BEGIN        
	  INSERT into @tbl select distinct code=a.CLIENT  from general.dbo.vw_rms_client_vertical a (nolock) where  exists (select Sb_cd from risk.dbo.SBMaster_grp b (nolock) where SB_mast_cd=@code and a.sb=b.Sb_cd) AND CLIENT LIKE @Rpt_code       
	 END      
	 if @user='CLIENT'        
	 BEGIN        
	  INSERT into @tbl select distinct code=client  from general.dbo.vw_rms_client_vertical(nolock) where  client=@rpt_code 
	 END        
/*
	 if @user='FAMILY'        
	 BEGIN        
	  INSERT into @tbl select distinct code=client  from general.dbo.vw_rms_client_vertical a (nolock) where FAMILY=@code AND CLIENT LIKE @Rpt_code       
	 END      
*/
/*
	 if @user='CLI-GRP'        
	 BEGIN        
	  INSERT into @tbl select distinct a.sb  from general.dbo.vw_rms_sb_vertical a (nolock) where  exists (select Sb_cd from risk.dbo.SBMaster_grp b (nolock) where SB_mast_cd=@code and a.sb=b.Sb_cd)        
	 END      
*/
	 
END


RETURN        
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.SplitStringToResultSet
-- --------------------------------------------------

/*---------------------------------------------------------------------------------            
Author      : Anand Sharan                                      
Create date : 17/Jan/2019                                      
Description : <Split The string using seperator>            
---------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[SplitStringToResultSet] (@value VARCHAR(MAX), @separator CHAR(1))    
RETURNS TABLE    
AS RETURN
WITH r AS (    
  SELECT value, CAST(NULL AS VARCHAR(MAX)) [x], 0 [no] FROM (SELECT RTRIM(cast(@value AS varchar(MAX))) [value]) AS j    
  UNION ALL    
  SELECT RIGHT(value, LEN(value) - CASE CHARINDEX(@separator, value) WHEN 0 THEN LEN(value) ELSE CHARINDEX(@separator, value) end) [value]    
  , LEFT(r.[value], CASE CHARINDEX(@separator, r.value) WHEN 0 THEN LEN(r.value) ELSE ABS(CHARINDEX(@separator, r.[value])-1) end ) [x]    
  , [no] + 1 [no]    
  FROM r   
  WHERE value > '')    
      
SELECT x [value], [no] FROM r WHERE x IS NOT NULL

GO

-- --------------------------------------------------
-- INDEX dbo.access_level
-- --------------------------------------------------
CREATE CLUSTERED INDEX [AccVal] ON [dbo].[access_level] ([Access_level_value])

GO

-- --------------------------------------------------
-- INDEX dbo.BranchMaster_Grp
-- --------------------------------------------------
CREATE CLUSTERED INDEX [BrMastCd] ON [dbo].[BranchMaster_Grp] ([Branch_Mast_cd])

GO

-- --------------------------------------------------
-- INDEX dbo.EXTRA_CAT_MAPPING_Harmony
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_EXTRA_CAT_MAPPING_Harmony_EMP_NO] ON [dbo].[EXTRA_CAT_MAPPING_Harmony] ([EMP_NO])

GO

-- --------------------------------------------------
-- INDEX dbo.RegionMaster_Grp
-- --------------------------------------------------
CREATE CLUSTERED INDEX [rgMastCd] ON [dbo].[RegionMaster_Grp] ([Region_Mast_cd])

GO

-- --------------------------------------------------
-- INDEX dbo.SBMaster_Grp
-- --------------------------------------------------
CREATE CLUSTERED INDEX [sbMastCd] ON [dbo].[SBMaster_Grp] ([SB_Mast_cd])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.menu_cat
-- --------------------------------------------------
ALTER TABLE [dbo].[menu_cat] ADD CONSTRAINT [PK_menu_cat] PRIMARY KEY ([cat_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.menu_item
-- --------------------------------------------------
ALTER TABLE [dbo].[menu_item] ADD CONSTRAINT [PK_menu_item] PRIMARY KEY ([menu_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MixedMaster_Grp
-- --------------------------------------------------
ALTER TABLE [dbo].[MixedMaster_Grp] ADD CONSTRAINT [PK_MixedMaster_Grp] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ZoneMaster_Grp
-- --------------------------------------------------
ALTER TABLE [dbo].[ZoneMaster_Grp] ADD CONSTRAINT [PK_ZoneMaster_Grp] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DEL_MENU_HARMONY
-- --------------------------------------------------
CREATE proc DEL_MENU_HARMONY
(@EMP_NO as varchar(20))
AS
DELETE FROM EXTRA_CAT_MAPPING_Harmony  WHERE EMP_NO=@EMP_NO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Gen_CompRisk_Summary
-- --------------------------------------------------
Create PRocedure [dbo].[Gen_CompRisk_Summary]
as
set nocount on

---------------------------------------- ZONE

truncate table Rpt_CompRisk_Zone 
insert into Rpt_CompRisk_Zone 
select b.dummy1 as Zone,
Ledger=sum(ledger),
NoDel_PL=sum(NoDel_PL),
Option_PL=sum(Option_PL),
Holding_App=sum(Holding_App),
Holding_NonApp=sum(Holding_NonApp),
Holding_Total=sum(Holding_Total),
PR_CurrPL=sum(PR_CurrPL),
PR_Derivatives=sum(PR_Derivatives),
PR_Commodities=sum(PR_Commodities),
PR_Currency=sum(PR_Currency),
PR_Cash_App=sum(PR_Cash_App),
PR_Cash_NonApp=sum(PR_Cash_NonApp),
PR_ProjRisk=sum(PR_ProjRisk),PR_PureRisk=sum(PR_PureRisk),
ES_Derivatives=sum(ES_Derivatives),ES_Commodities=sum(ES_Commodities),
ES_Currency=sum(ES_Currency),ES_Cash_App=sum(ES_Cash_App),ES_Cash_NonApp=sum(ES_Cash_NonApp),
ES_ProjRisk=sum(ES_ProjRisk),ES_PureRisk=sum(ES_PureRisk),Imargin=sum(Imargin),Deposit=sum(Deposit),Colleteral=sum(Colleteral)
from general.dbo.RMS_CompRisk_Cli a (nolock) , general.dbo.bo_region b (nolock) where a.branch_cd=b.branch_code
group by b.dummy1 


---------------------------------------- REGION
truncate table Rpt_CompRisk_Region
insert into Rpt_CompRisk_Region
select b.regioncode,description,
Ledger=sum(ledger),
NoDel_PL=sum(NoDel_PL),
Option_PL=sum(Option_PL),
Holding_App=sum(Holding_App),
Holding_NonApp=sum(Holding_NonApp),
Holding_Total=sum(Holding_Total),
PR_CurrPL=sum(PR_CurrPL),
PR_Derivatives=sum(PR_Derivatives),
PR_Commodities=sum(PR_Commodities),
PR_Currency=sum(PR_Currency),
PR_Cash_App=sum(PR_Cash_App),
PR_Cash_NonApp=sum(PR_Cash_NonApp),
PR_ProjRisk=sum(PR_ProjRisk),PR_PureRisk=sum(PR_PureRisk),
ES_Derivatives=sum(ES_Derivatives),ES_Commodities=sum(ES_Commodities),
ES_Currency=sum(ES_Currency),ES_Cash_App=sum(ES_Cash_App),ES_Cash_NonApp=sum(ES_Cash_NonApp),
ES_ProjRisk=sum(ES_ProjRisk),ES_PureRisk=sum(ES_PureRisk),Imargin=sum(Imargin),Deposit=sum(Deposit),Colleteral=sum(Colleteral)
from general.dbo.RMS_CompRisk_Cli a (nolock) , general.dbo.bo_region b (nolock) where a.branch_cd=b.branch_code
group by b.regioncode,description


---------------------------------------- BRANCH
truncate table Rpt_CompRisk_Branch
insert into Rpt_CompRisk_Branch

select branch_code,branch,
Ledger=sum(ledger),
NoDel_PL=sum(NoDel_PL),
Option_PL=sum(Option_PL),
Holding_App=sum(Holding_App),
Holding_NonApp=sum(Holding_NonApp),
Holding_Total=sum(Holding_Total),
PR_CurrPL=sum(PR_CurrPL),
PR_Derivatives=sum(PR_Derivatives),
PR_Commodities=sum(PR_Commodities),
PR_Currency=sum(PR_Currency),
PR_Cash_App=sum(PR_Cash_App),
PR_Cash_NonApp=sum(PR_Cash_NonApp),
PR_ProjRisk=sum(PR_ProjRisk),PR_PureRisk=sum(PR_PureRisk),
ES_Derivatives=sum(ES_Derivatives),ES_Commodities=sum(ES_Commodities),
ES_Currency=sum(ES_Currency),ES_Cash_App=sum(ES_Cash_App),ES_Cash_NonApp=sum(ES_Cash_NonApp),
ES_ProjRisk=sum(ES_ProjRisk),ES_PureRisk=sum(ES_PureRisk),Imargin=sum(Imargin),Deposit=sum(Deposit),Colleteral=sum(Colleteral)
from general.dbo.RMS_CompRisk_Cli a (nolock) , general.dbo.bo_branch b (nolock) where a.branch_cd=b.branch_code
group by branch_code,branch

---------------------------------------- SUBBROKER
truncate table Rpt_CompRisk_Subbroker
insert into Rpt_CompRisk_Subbroker
select branch_cd,a.sub_BRoker,sbname,
Ledger=sum(ledger),
NoDel_PL=sum(NoDel_PL),
Option_PL=sum(Option_PL),
Holding_App=sum(Holding_App),
Holding_NonApp=sum(Holding_NonApp),
Holding_Total=sum(Holding_Total),
PR_CurrPL=sum(PR_CurrPL),
PR_Derivatives=sum(PR_Derivatives),
PR_Commodities=sum(PR_Commodities),
PR_Currency=sum(PR_Currency),
PR_Cash_App=sum(PR_Cash_App),
PR_Cash_NonApp=sum(PR_Cash_NonApp),
PR_ProjRisk=sum(PR_ProjRisk),PR_PureRisk=sum(PR_PureRisk),
ES_Derivatives=sum(ES_Derivatives),ES_Commodities=sum(ES_Commodities),
ES_Currency=sum(ES_Currency),ES_Cash_App=sum(ES_Cash_App),ES_Cash_NonApp=sum(ES_Cash_NonApp),
ES_ProjRisk=sum(ES_ProjRisk),ES_PureRisk=sum(ES_PureRisk),Imargin=sum(Imargin),Deposit=sum(Deposit),Colleteral=sum(Colleteral)
from general.dbo.RMS_CompRisk_Cli a (nolock) , general.dbo.subgroup b (nolock) where a.sub_Broker=b.sub_Broker
group by branch_cd,a.sub_BRoker,sbname


set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Single_login
-- --------------------------------------------------
CREATE Procedure [dbo].[Get_Single_login](@username as varchar(16),@password as varchar(20))  
as  
select a.*,b.cat_name,
logindt=(case when login_inactive_date > getdate() then 1 else 0 end),
daydiff=datediff(day,getdate(),login_inactive_date)
from user_login a (nolock) , 
menu_cat b (nolock) where a.cat_code=b.cat_code and username=@username and userpassword=@password

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetFltLevel
-- --------------------------------------------------
CREATE procedure GetFltLevel(@Rpt_level as varchar(25),@access_to as varchar(25),@access_Code as varchar(25))                          
as                          
set nocount on                          
                          
                      
                          
                          
 --declare @access_Code as varchar(25),@access_to as varchar(25),@Rpt_level as varchar(25)                  
DECLARE @str as varchar(1000)                
/*                    
 set @access_to ='region'                          
set @access_Code ='mum'                          
set @Rpt_level ='region'                      
*/          
                          
                          
set @str=''                          
if @access_to ='BROKER'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from Vw_RMS_Client_Vertical '                          
End                        
else if @access_to ='BRMAST'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from Vw_RMS_Client_Vertical_BRMAST where '+@access_to+' = '''+@access_Code+''''                           
End                     
else if @access_to ='SBMAST'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from Vw_RMS_Client_Vertical_SBMAST where '+@access_to+' = '''+@access_Code+''''                           
End                    
else if @access_to ='ZONE'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from zone where '+@access_to+' = '''+@access_Code+''''                           
End                   
else if @access_to ='ZNMAST'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from zone where '+@access_to+' = '''+@access_Code+''''                           
End   
/*  commented by rashmi for change in view                
else if @access_to ='REGION'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+'_code as filter_val from vw_region_group_branches where '+@access_to+'_CODE = '''+@access_Code+''''                           
End        */  
  
else if @access_to ='REGION'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+'_code as filter_val from vw_region where '+@access_to+'_CODE = '''+@access_Code+''''                           
End                   
           
else if @access_to ='RGMAST'                           
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+'_code as filter_val from vw_region_group_branches where '+@access_to+'_CODE = '''+@access_Code+''''                           
End                   
                      
Else                          
Begin                          
 set @str=@str + ' select distinct '+@Rpt_level+' as filter_val from Vw_RMS_Client_Vertical where '+@access_to+' = '''+@access_Code+''''                           
end                          
                          
 exec(@str)                          
                          
print @str                          
                          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INS_MENU_HARMONY
-- --------------------------------------------------
CREATE proc INS_MENU_HARMONY
(@EMP_NO as varchar(20),@Menu_NO as int,@Upd_by as varchar(20))
AS
INSERT INTO EXTRA_CAT_MAPPING_Harmony SELECT @EMP_NO,@Menu_NO,@Upd_by,getdate()

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Map_UnMap_Option
-- --------------------------------------------------
CREATE Procedure [dbo].[Map_UnMap_Option](@type as varchar(1),@catcode as int)  
as  
if @type='U'  
BEGIN  
 SELECT DISTINCT a.[menu_code], [Head], [Sub_Head], [menu_name]
 FROM [menu_item] a(nolock),cat_mapping b(nolock)  
 WHERE a.menu_code=b.menu_code and ([active] = 'Y') and cat_code=@catcode  
END  
if @type='M'  
BEGIN  
 SELECT DISTINCT a.[menu_code], [Head], [Sub_Head], [menu_name]  
 FROM [menu_item] a(nolock) left outer join (select * from cat_mapping(nolock) where cat_code=@catcode  ) b    
 on a.menu_code=b.menu_code where b.menu_code is null --and cat_code=@catcode  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_usp_access_level
-- --------------------------------------------------
CREATE PROCEDURE new_usp_access_level   
(@aceess_to as varchar(50))             
 as                       
set nocount on                       
set transaction isolation level read uncommitted                                
       
select Access_level_value,Access_level_name from access_level (nolock) where access_level_Code >=       
(select access_level_Code from access_level (nolock) where access_level_value=@aceess_to )      
and access_level_active=1  and access_level_code > 0 and  access_level_value<>'ZONE'   
order by access_level_Code 

set nocount off

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
-- PROCEDURE dbo.rebuild_index_24022022
-- --------------------------------------------------
  
  -- exec rebuild_index2 'AdventureWorksDW'  
  --  [rebuild_index_24022022]  'risk'

CREATE procedure [dbo].[rebuild_index_24022022]  
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
     
--EXEC (@command);      
PRINT N'Executed: ' + @command;      
select N'Executed: ' + @command;   
end  
  
        
-- Drop the temporary table.      
DROP TABLE #work_to_do;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_CompRiskBr
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_CompRiskBr](@region as varchar(10),@branch as varchar(10),@divby as int)        
as        
set  nocount on        
select         
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),        
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),        
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),        
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),        
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),        
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),        
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),     
Branch_cd,BrName=b.branch,
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),        
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),        
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),        
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),        
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),        
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),        
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),        
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby),  
RColor=(Case when sum(PR_PureRisk) < -50000 then 'pink' else '' end)      
from RMS_CompRisk_SB a (nolock),General.dbo.bo_branch b (nolock) where a.branch_Cd=b.branch_code     
and branch_Cd in (select branch_code from General.dbo.bo_Region (nolock) where branch_Code like @branch and regioncode like @region)    
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)        
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0       
group by Branch_cd,b.branch    
order by PR_PureRisk         
    
select         
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),        
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),        
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),        
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),        
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),        
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),        
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),     
Total1='',
Total='Total',
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),        
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),        
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),        
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),        
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),        
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),        
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),        
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)      
from RMS_CompRisk_SB a (nolock),General.dbo.bo_branch b (nolock) where a.branch_Cd=b.branch_code     
and branch_Cd in (select branch_code from General.dbo.bo_Region (nolock) where branch_Code like @branch and regioncode like @region)    
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)        
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0      
        
--select top 1 GenDate from RMS_CompRisk_Cli (nolock)        
        
set  nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_CompRiskCli
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_CompRiskCli](@branch as varchar(10),@subbroker as varchar(10),@divby as int)  
as  
set  nocount on  
select   
Branch_cd,Sub_Broker,Party_code,Party_Name,Ledger=convert(decimal(20,2),ledger/@divby),  
NoDel_PL=convert(decimal(20,2),NoDel_PL/@divby),  
Option_PL=convert(decimal(20,2),Option_PL/@divby),  
Holding_App=convert(decimal(20,2),Holding_App/@divby),  
Holding_NonApp=convert(decimal(20,2),Holding_NonApp/@divby),  
Holding_Total=convert(decimal(20,2),Holding_Total/@divby),  
PR_CurrPL=convert(decimal(20,2),PR_CurrPL/@divby),  
PR_Derivatives=convert(decimal(20,2),PR_Derivatives/@divby),  
PR_Commodities=convert(decimal(20,2),PR_Commodities/@divby),  
PR_Currency=convert(decimal(20,2),PR_Currency/@divby),  
PR_Cash_App=convert(decimal(20,2),PR_Cash_App/@divby),  
PR_Cash_NonApp=convert(decimal(20,2),PR_Cash_NonApp/@divby),  
PR_ProjRisk=convert(decimal(20,2),PR_ProjRisk/@divby),  
PR_PureRisk=convert(decimal(20,2),PR_PureRisk/@divby),  
Imargin=convert(decimal(20,2),(Imargin*-1)/@divby),  
Deposit=convert(decimal(20,2),Deposit/@divby),Colleteral=convert(decimal(20,2),Colleteral/@divby)  
from RMS_CompRisk_Cli (nolock) where branch_cd like @branch and sub_Broker like @subbroker   
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)  
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0 
order by PR_PureRisk   
  
select   
Total='Total',Ledger=convert(decimal(20,2),sum(ledger)/@divby),  
NoDel_PL=convert(decimal(20,2),sum(NoDel_PL)/@divby),  
Option_PL=convert(decimal(20,2),sum(Option_PL)/@divby),  
Holding_App=convert(decimal(20,2),sum(Holding_App)/@divby),  
Holding_NonApp=convert(decimal(20,2),sum(Holding_NonApp)/@divby),  
Holding_Total=convert(decimal(20,2),sum(Holding_Total)/@divby),  
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),  
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),  
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),  
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),  
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),  
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),  
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),  
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby),  
Imargin=convert(decimal(20,2),sum((Imargin*-1))/@divby),  
Deposit=convert(decimal(20,2),sum(Deposit)/@divby),Colleteral=convert(decimal(20,2),sum(Colleteral)/@divby)  
from RMS_CompRisk_Cli (nolock) where branch_cd like @branch and sub_Broker like @subbroker   
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)  
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0
  
select top 1 GenDate from RMS_CompRisk_Cli (nolock)  
  
set  nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_CompRiskRegion
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_CompRiskRegion](@zone as varchar(10),@region as varchar(10),@divby as int)      
as      
set  nocount on      
select       
regionCode,RegionName=b.description,  
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),      
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),      
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),      
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),      
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),      
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),      
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),   
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),      
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),      
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),      
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),      
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),      
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),      
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)    
from RMS_CompRisk_SB a (nolock),general.dbo.bo_Region b (nolock) where a.branch_Cd=b.branch_code   
and dummy1 like @zone and regioncode like @region --and branch_Code like @branch   
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)      
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0     
group by regionCode,b.description  
order by PR_PureRisk       
  
select       
Total='Total',  
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),      
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),      
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),      
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),      
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),      
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),      
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),   
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),      
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),      
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),      
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),      
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),      
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),      
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)    
from RMS_CompRisk_SB a (nolock),general.dbo.bo_Region b (nolock) where a.branch_Cd=b.branch_code   
and dummy1 like @zone and regioncode like @region --and branch_Code like @branch   
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0    
      
select top 1 GenDate from RMS_CompRisk_Cli (nolock)      
      
set  nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_CompRiskSB
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_CompRiskSB](@branch as varchar(10),@subbroker as varchar(10),@divby as int)      
as      
set  nocount on      
select       
Branch_cd,Sub_Broker,SBName,  
CliProjRisk=convert(decimal(20,2),CliProjRisk/@divby),      
CliPureRisk=convert(decimal(20,2),CliPureRisk/@divby),      
sb_ledger=convert(decimal(20,2),sb_ledger/@divby),      
sb_brokerage=convert(decimal(20,2),sb_brokerage/@divby),      
sb_cashcoll=convert(decimal(20,2),sb_cashcoll/@divby),      
sb_noncashcoll=convert(decimal(20,2),sb_noncashcoll/@divby),      
SB_Total=convert(decimal(20,2),SB_Total/@divby),   
PR_CurrPL=convert(decimal(20,2),PR_CurrPL/@divby),      
PR_Derivatives=convert(decimal(20,2),PR_Derivatives/@divby),      
PR_Commodities=convert(decimal(20,2),PR_Commodities/@divby),      
PR_Currency=convert(decimal(20,2),PR_Currency/@divby),      
PR_Cash_App=convert(decimal(20,2),PR_Cash_App/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),PR_Cash_NonApp/@divby),      
PR_ProjRisk=convert(decimal(20,2),PR_ProjRisk/@divby),      
PR_PureRisk=convert(decimal(20,2),PR_PureRisk/@divby)  
from RMS_CompRisk_SB (nolock) where branch_cd like @branch and sub_Broker like @subbroker       
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)      
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0     
order by PR_PureRisk       
      
  
select       
Total='Total',  
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),      
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),      
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),      
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),      
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),      
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),      
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),   
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),      
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),      
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),      
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),      
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),      
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),      
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)    
from RMS_CompRisk_SB (nolock) where branch_cd like @branch and sub_Broker like @subbroker       
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)      
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0    
      
select top 1 GenDate from RMS_CompRisk_Cli (nolock)      
      
set  nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_CompRiskZone
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_CompRiskZone](@zone as varchar(10),@divby as int)      
as      
set  nocount on      
select       
Zone=Dummy1,  
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),      
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),      
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),      
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),      
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),      
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),      
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),   
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),      
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),      
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),      
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),      
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),      
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),      
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)    
from RMS_CompRisk_SB a (nolock),general.dbo.bo_Region b (nolock) where a.branch_Cd=b.branch_code   
and dummy1 like @zone   
--and (PR_PureRisk < 0 or PR_ProjRisk < 0)      
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0     
group by dummy1  
order by PR_PureRisk       
  
select       
Total='Total',  
CliProjRisk=convert(decimal(20,2),sum(CliProjRisk)/@divby),      
CliPureRisk=convert(decimal(20,2),sum(CliPureRisk)/@divby),      
sb_ledger=convert(decimal(20,2),sum(sb_ledger)/@divby),      
sb_brokerage=convert(decimal(20,2),sum(sb_brokerage)/@divby),      
sb_cashcoll=convert(decimal(20,2),sum(sb_cashcoll)/@divby),      
sb_noncashcoll=convert(decimal(20,2),sum(sb_noncashcoll)/@divby),      
SB_Total=convert(decimal(20,2),sum(SB_Total)/@divby),   
PR_CurrPL=convert(decimal(20,2),sum(PR_CurrPL)/@divby),      
PR_Derivatives=convert(decimal(20,2),sum(PR_Derivatives)/@divby),      
PR_Commodities=convert(decimal(20,2),sum(PR_Commodities)/@divby),      
PR_Currency=convert(decimal(20,2),sum(PR_Currency)/@divby),      
PR_Cash_App=convert(decimal(20,2),sum(PR_Cash_App)/@divby),      
PR_Cash_NonApp=convert(decimal(20,2),sum(PR_Cash_NonApp)/@divby),      
PR_ProjRisk=convert(decimal(20,2),sum(PR_ProjRisk)/@divby),      
PR_PureRisk=convert(decimal(20,2),sum(PR_PureRisk)/@divby)    
from RMS_CompRisk_SB a (nolock),general.dbo.bo_Region b (nolock) where a.branch_Cd=b.branch_code   
and dummy1 like @zone   
and abs(PR_PureRisk)+abs(PR_ProjRisk) > 0    
      
select top 1 GenDate from RMS_CompRisk_Cli (nolock)      
      
set  nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_MargVio_Zone
-- --------------------------------------------------
CREATE proc [dbo].[Rpt_MargVio_Zone](@co_Code as varchar(10),@zone as varchar(10))  
as  
set nocount on  
declare @str varchar(5000)  
  
set @str = ''  
set @str = @str + ' select sauda_date,Zone=dummy1, imargin = sum(isnull(a.imargin,0)), '  
set @str = @str + ' shortage = sum(case when a.imargin > 0  and  a.shortage >0 then  isnull(a.shortage,0) else 0 end), '  
set @str = @str + ' net = sum(Isnull(a.net,0)), gross =sum((case when  a.shortage >0 then  isnull(a.shortage,0) else 0 end)/100000), '  
set @str = @str + ' gross1 =sum(isnull(a.shortage,0)/100000), exposure = sum(Isnull(a.exposure ,0)), '  
set @str = @str + ' cumm_short = sum(Isnull(a.cumm_short,0)), [Fut_Buy] = sum(Isnull([Fut_Buy],0)), [Fut_Sell] =sum(Isnull([Fut_Sell],0)), '  
set @str = @str + ' [Put_Sell] = sum(Isnull([opt_Put_Sell],0)), [Call_Sell] = sum(Isnull([opt_Call_Sell],0)), '  
--[Net Expo] =   sum(Isnull([Fut Buy],0) - Isnull([Fut Sell],0) + Isnull([Put Sell],0) - Isnull([Call Sell],0)),   
set @str = @str + ' Net_exposure=sum(isnull(Net_exposure,0)), Gross_exposure=sum(isnull(Gross_exposure,0)), '  
--[Gross Expo] =   sum(Isnull([Fut Buy],0) + Isnull([Fut Sell],0) + Isnull([Put Sell],0) + Isnull([Call Sell] ,0)),   
set @str = @str + ' MTM_Loss  = sum(Isnull(MTM_Loss,0)) '  
set @str = @str + ' from (select a.*,c.mtm_loss,b.dummy1 from GENERAL.DBO.'+@co_Code+'_marginviolation a (nolock), GENERAL.DBO.'+@co_Code+'_marh c (nolock), '  
set @str = @str + ' (select dummy1,branch_code from GENERAL.DBO.bo_region (nolock) where dummy1 like '''+@zone+''' ) b '  
set @str = @str + ' where a.clcode=c.clcode and a.sbtag=b.branch_code) a left outer join GENERAL.DBO.'+@co_Code+'_expo b (nolock)'  
set @str = @str + ' on a.clcode=b.party_code group by sauda_date,dummy1 '  

exec (@str)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_SB_NonCash_deposit
-- --------------------------------------------------
CREATE procedure [dbo].[Rpt_SB_NonCash_deposit](@access_to as varchar(10),@Access_code as varchar(10))
as  
select * from V_SB_NonCash_deposit order by [Sub-broker code]

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
-- PROCEDURE dbo.spFileDetails
-- --------------------------------------------------
/****** Object:  StoredProcedure [dbo].[spFileDetails]    Script Date: 03/28/2007 15:28:15 ******/
 
create PROCEDURE [dbo].[spFileDetails]
@Filename VARCHAR(100)

/*
spFileDetails 'c:\autoexec.bat'
*/
AS
DECLARE @hr INT,         --the HRESULT returned from 
       @objFileSystem INT,              --the FileSystem object
       @objFile INT,            --the File object
       @ErrorObject INT,        --the error object
       @ErrorMessage VARCHAR(255),--the potential error message
       @Path VARCHAR(100),--
       @ShortPath VARCHAR(100),
       @Type VARCHAR(100),
       @DateCreated datetime,
       @DateLastAccessed datetime,
       @DateLastModified datetime,
       @Attributes INT,
       @size INT



SET nocount ON

SELECT @hr=0,@errorMessage='opening the file system object '
EXEC @hr = sp_OACreate 'Scripting.FileSystemObject',
                                       @objFileSystem OUT
IF @hr=0 SELECT @errorMessage='accessing the file '''
                                       +@Filename+'''',
       @ErrorObject=@objFileSystem
IF @hr=0 EXEC @hr = sp_OAMethod @objFileSystem,
         'GetFile',  @objFile out,@Filename
IF @hr=0 
       SELECT @errorMessage='getting the attributes of '''
                                       +@Filename+'''',
       @ErrorObject=@objFile
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'Path', @path OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'ShortPath', @ShortPath OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'Type', @Type OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'DateCreated', @DateCreated OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'DateLastAccessed', @DateLastAccessed OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'DateLastModified', @DateLastModified OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'Attributes', @Attributes OUT
IF @hr=0 EXEC @hr = sp_OAGetProperty 
             @objFile, 'size', @size OUT


IF @hr<>0
       BEGIN
       DECLARE 
               @Source VARCHAR(255),
               @Description VARCHAR(255),
               @Helpfile VARCHAR(255),
               @HelpID INT
       
       EXECUTE sp_OAGetErrorInfo  @errorObject, 
               @source output,@Description output,
                               @Helpfile output,@HelpID output

       SELECT @ErrorMessage='Error whilst '
                               +@Errormessage+', '
                               +@Description
       RAISERROR (@ErrorMessage,16,1)
       END
EXEC sp_OADestroy @objFileSystem
EXEC sp_OADestroy @objFile
SELECT [Path]=  @Path,
       [ShortPath]=    @ShortPath,
       [Type]= @Type,
       [DateCreated]=  @DateCreated ,
       [DateLastAccessed]=     @DateLastAccessed,
       [DateLastModified]=     @DateLastModified,
       [Attributes]=   @Attributes,
       [size]= @size
RETURN @hr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_help_search
-- --------------------------------------------------
--DROP PROC stp_help_search
Create  PROCEDURE [dbo].[stp_help_search]  
 (  
 @fslike    [nvarchar](500),  
 @nxtype    [tinyint]= 0,  
 @fntype    [tinyint]= 0  
 )  
-- WITH ENCRYPTION  
 AS  
 BEGIN  
 SET NOCOUNT ON   
   DECLARE @xtype varchar(2)  
   DECLARE @fxlike varchar(100)  
   DECLARE @charindex NVARCHAR(2)  
    
   SET @fslike =REPLACE (@fslike,'[','')  
   SET @fslike =REPLACE (@fslike,']','')  
   SET @fslike =REPLACE (@fslike,'','')  
     
   SET @fslike =LTRIM(RTRIM(@fslike))  
  
   SET @xtype = case  
       when @nxtype = 0 then ''  
       when @nxtype = 1 then 'U'  
       when @nxtype = 11 then 'U'  
       when @nxtype = 2 then 'P'  
       when @nxtype = 5 then 'PK'  
       when @nxtype = 10 then 'F'  
       when @nxtype = 4 then 'D'  
   
       else ''  
       end;  
   SET @fxlike ='stp_help'  
  
   IF  @fntype = 0 and  @nxtype <> 11  
    BEGIN  -- FOR TABLES  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'U' )  OR [xtype]  =  @xtype)  
      AND upper([name])   NOT LIKE '%'+ upper(@fxlike) +'%'  
     ORDER BY [name] ASC  
       -- FOR STP  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'P')  OR [xtype]  =  @xtype)  
      AND [name]   NOT LIKE '%'+ @fxlike +'%'  
       --FOR VIEWS  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'V')  OR [xtype]  =  @xtype)  
      AND [name]   NOT LIKE '%'+ @fxlike +'%'  
       
     ORDER BY [name] ASC  
  
        
    END  
   ELSE  
    BEGIN   
     IF @nxtype = 11  
     begin  
     declare @tabname nvarchar(100), @tabdata nvarchar(500)  
  
     create table #trper   
     (  
     tabname nvarchar(100),  
     tabdata nvarchar(500)  
     )  
  
  
       
     insert into #trper SELECT  [name], ' select * from '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
     declare tableselect cursor for select * from #trper  
  
     open  tableselect  
     fetch next from tableselect into @tabname, @tabdata  
      while @@fetch_status = 0  
       begin  
        print ' '  
        print '-------------------------------------------------------------------------------------'  
        print @tabname  
        execute(@tabdata)  
        fetch next from tableselect into @tabname, @tabdata  
       end  
     close tableselect  
     deallocate tableselect  
      
     drop table #trper  
     end  
  
  
  
    ELSE IF @nxtype = 2 AND @fntype <> 20  
     SELECT 'GO  
 sp_helptext '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
      
    ELSE IF @nxtype = 1 AND @fntype = 20  
     SELECT 'GO  
 stp_help_select '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 1 AND @fntype = 100  
     SELECT 'GO  
 stp_help_anyTableScripGenerator '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 1 AND @fntype  =200  
     begin  
     truncate table table_Null_FinalStatus  
     SELECT 'GO  
 stp_help_whereclouse '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
     end  
    ELSE IF @nxtype = 1 AND @fntype = 22  
     SELECT 'GO  
 stp_help_PreviousDayScripMasterGenerator_stp '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 2 AND @fntype = 20  
     SELECT 'GO  
 stp_help_stpdoc '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
     ELSE  
        SELECT 'GO  
    sp_help '+ [name] FROM sysobjects  
       WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
        AND (@xtype   = ''  
         OR [xtype]  =  @xtype)  
        ORDER BY [name]  
  
    END  
  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_Single_login
-- --------------------------------------------------
CREATE Procedure [dbo].[Upd_Single_login](@username as varchar(16),@password as varchar(20))    
as    
update user_login set userpassword=@password,login_inactive_date=getdate()+30 where username=@username

GO

-- --------------------------------------------------
-- PROCEDURE dbo.userlogin
-- --------------------------------------------------
CREATE Proc userlogin  
as  
BEGIN  
Set nocount on
begin try 
--changes done by chirantan on 09 may 2012 due to issue of blank mails after server migration, backup proc name is userlogin_09052012  
  
--create table #temp (  
--Username varchar(100),[Person name] varchar(100),  
--[Access to] varchar(100),[Access code] varchar(100),  
--[Date] varchar(100),[Menu] varchar(100),  
--[No of Logins] varchar(100))  
  
truncate table userlogin_mail  
  
insert into userlogin_mail  
select Username='Username',[Person name]='Person name',[Access to]='Access to',[Access code]='Access code',  
[Date]='Date',[Menu]='Menu',[No of Logins]='No of Logins'  
  
insert into userlogin_mail  
select Username=convert(varchar,L.username), [Person name]=convert(varchar,U.person_name), [Access to]=convert(varchar,U.access_to),  
[Access code]=convert(varchar,U.Access_code),  
[Date]=convert(varchar(12), L.Access_date, 103),  
[Menu]=case  
when Report_No in (80,81,82,83,84) then 'Legal'  
when Report_No in (85,86,87,88,89) then 'Risk'  
when Report_No in (90,91,92,93,94) then 'Debit'  
when Report_No in (75,79,77,76,78) then 'All Clients'  
end,  
[No of Logins]=convert(varchar,count(*))  
from general.dbo.Log_Report L  
inner join risk.dbo.user_login U on L.username = U.username  
where L.Access_date BETWEEN CONVERT(VARCHAR(15),GETDATE()-1,106) + ' 00:00.000' AND CONVERT(VARCHAR(15),GETDATE()-1,106) + ' 23:59.000'  
and (Report_No between 75 and 94)  
group by L.username, U.person_name, U.access_to, U.Access_code, convert(varchar(12), L.Access_date, 103) ,Report_No  
order by convert(varchar(12), L.Access_date, 103), L.username  
  
Select * from userlogin_mail  
end try  
begin catch  
insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)  
select GETDATE(),'userlogin',ERROR_LINE(),ERROR_MESSAGE()  
  
DECLARE @ErrorMessage NVARCHAR(4000);  
SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());  
RAISERROR (@ErrorMessage , 16, 1);  
end catch;  
SEt nocount off 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.userlogin_09052012
-- --------------------------------------------------
CREATE Proc userlogin_09052012
as          
BEGIN          
create table #temp (          
Username varchar(100),[Person name] varchar(100),          
[Access to] varchar(100),[Access code] varchar(100),          
[Date] varchar(100),[Menu] varchar(100),          
[No of Logins] varchar(100))          
               
insert into #temp          
select Username='Username',[Person name]='Person name',[Access to]='Access to',[Access code]='Access code',          
[Date]='Date',[Menu]='Menu',[No of Logins]='No of Logins'           
          
          
insert into #temp          
select Username=convert(varchar,L.username), [Person name]=convert(varchar,U.person_name), [Access to]=convert(varchar,U.access_to),           
[Access code]=convert(varchar,U.Access_code),           
[Date]=convert(varchar(12), L.Access_date, 103),   
[Menu]=case   
when Report_No in (80,81,82,83,84) then 'Legal'  
when Report_No in (85,86,87,88,89) then 'Risk'  
when Report_No in (90,91,92,93,94) then 'Debit'  
when Report_No in (75,79,77,76,78) then 'All Clients'  
end,  
[No of Logins]=convert(varchar,count(*))           
from general.dbo.Log_Report L            
 inner join risk.dbo.user_login U on L.username = U.username  
where convert(varchar(12),L.Access_date,103) = convert(varchar(12),getdate()-1,103)       
and (Report_No between 75 and 94)  
group by L.username, U.person_name, U.access_to, U.Access_code, convert(varchar(12), L.Access_date, 103)     ,Report_No  
order by convert(varchar(12), L.Access_date, 103), L.username           
          
Select * from #temp          
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.userSBlogin
-- --------------------------------------------------
CREATE Proc userSBlogin
as
BEGIN
--create table #temp (
--Username varchar(100),
--[Date] varchar(100),[Menu] varchar(100),
--[No of Logins] varchar(100))

truncate table userSBlogin_mail

insert into userSBlogin_mail--#temp
select Username='Username',
[Date]='Date',[Menu]='Menu',[No of Logins]='No of Logins'

insert into userSBlogin_mail--#temp
select DISTINCT Username=convert(varchar,L.username),
[Date]=convert(varchar(12), L.Access_date, 103),
[Menu]=case
when Report_No in (103,104) then 'All Clients'
when Report_No in (109,110) then 'Debit'
when Report_No in (107,108) then 'Risk'
when Report_No in (105,106) then 'Legal'
end,
[No of Logins]=convert(varchar,count(*))
from general.dbo.Log_Report L with (nolock)
where L.Access_date BETWEEN CONVERT(VARCHAR(15),GETDATE()-1,106) + ' 00:00.000' AND CONVERT(VARCHAR(15),GETDATE()-1,106) + ' 23:59.000'
and (Report_No between 103 and 110)
group by L.username, convert(varchar(12), L.Access_date, 103),Report_No

Select * from userSBlogin_mail--#temp

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.userSBlogin_05092012
-- --------------------------------------------------
CREATE Proc userSBlogin_05092012  
as            
BEGIN            
 create table #temp (            
 Username varchar(100),            
 [Date] varchar(100),[Menu] varchar(100),            
 [No of Logins] varchar(100))            
                  
 insert into #temp            
 select Username='Username',            
 [Date]='Date',[Menu]='Menu',[No of Logins]='No of Logins'             
             
             
 insert into #temp            
 select DISTINCT Username=convert(varchar,L.username),   
 [Date]=convert(varchar(12), L.Access_date, 103),     
 [Menu]=case     
 when Report_No in (103,104) then 'All Clients'    
 when Report_No in (109,110) then 'Debit'    
 when Report_No in (107,108) then 'Risk'  
 when Report_No in (105,106) then 'Legal'    
 end,    
 [No of Logins]=convert(varchar,count(*))             
 from general.dbo.Log_Report L with (nolock)               
 where convert(varchar(12),L.Access_date,103) = convert(varchar(12),getdate()-1,103)         
 and (Report_No between 103 and 110)    
 group by L.username,  convert(varchar(12), L.Access_date, 103),Report_No    
             
             
 Select * from #temp            
             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_access_level
-- --------------------------------------------------
CREATE PROCEDURE usp_access_level 
(@aceess_to as varchar(50))           
 as                     
set nocount on                     
set transaction isolation level read uncommitted                              
     
select Access_level_value,Access_level_name from access_level (nolock) where access_level_Code >=     
(select access_level_Code from access_level (nolock) where access_level_value=@aceess_to )    
and access_level_active=1  and access_level_code > 0  
order by access_level_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_AMX_LoginAPI_NRMS_SquareOff
-- --------------------------------------------------


--exec Usp_AMX_LoginAPI_NRMS_SquareOff
create PROC [dbo].[Usp_AMX_LoginAPI_NRMS_SquareOff]            
AS       
Set nocount on                         
SET XACT_ABORT ON                                   
BEGIN TRY           
BEGIN 


   declare @CLIENTCODE AS VARCHAR(MAX) = ''            
   DECLARE @Object AS INT;            
   DECLARE @ResponseText AS VARCHAR(8000);            
   DECLARE @Body AS VARCHAR(8000) = ''            
   DECLARE @GROUPCODE AS VARCHAR(50)=''            
   DECLARE @IPO MONEY=0,@MF MONEY=0,@TRADINGAMT MONEY=0          
   declare @mdat as datetime  ,@mdat1 as datetime        
   declare @Cltcode1 varchar(50)='',@email1 varchar(100)='',@Amount1  money=0.00 ,@segment varchar(100)='' 
         
    --SELECT @GROUPCODE=A.tag FROM (SELECT TOP 1   tag   FROM [mis].dbo.odinclientinfo WHERE pcode = @CLIENTCODE AND  servermapped <> '192.168.3.186')A         
    --SET @Body = '{"[Transaction Code]" : "'+'108'+'","UserId" : "'+'CHIEF'+'","Password" : "'+'Angel@123'+'","SourceID":"'+3+'"
    --               "[UserType]" : "'+'1'+'","ClientLocalIP" : "'+'172.29.24.21'+'","ClientPublicIP" : "'+'172.29.16.4'+'",
    --               "MACaddress" : "'+'00:25:96:FF:FE:12:34:56'+'","SystemInfo" : "'+''+'","Location" : "'+''+'","AppID" : "'+''+'"}'  
                   
    SET @Body ='108|CHIEF|Angel@123|3|1|172.29.24.21|172.29.16.4|00:25:96:FF:FE:12:34:56|||||'               
          
          
    --SET @Body =null      
          
    EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;          
    EXEC sp_OAMethod @Object, 'open', NULL, 'POST','https://amxuat.angelbroking.com/CGI/Login', 'false'          
             
    EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'text/plain'          
    EXEC sp_OAMethod @Object, 'send', null, @body          
             
    EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT          
    --SELECT @ResponseText as [RESPONSE]          
     
    select   @ResponseText  as [RESPONSE]     into #tmp
    EXEC sp_OADestroy @Object     
               
    Create table #FinalData 
    (
    RowId int identity,
    Response_values varchar (max)
    )
    --declare @val as varchar(max)
    --select @val = [RESPONSE]  from  #tmp
    insert into #FinalData (Response_values)
    select *  from  dbo.Split(@ResponseText,'|')
            
    select Response_values from #FinalData where RowId='5'
    
END       
End try                                     
BEGIN CATCH                                        
                                    
  insert into cms.dbo.NCMS_ERROR(ErrTime,ErrObject,ErrLine,ErrMessage)                                              
  select GETDATE(),'Usp_AMX_LoginAPI_NRMS_SquareOff',ERROR_LINE(),ERROR_MESSAGE()                                              
                                    
End catch

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
-- PROCEDURE dbo.Usp_Omn_MemberBlockSegmentlist_12062023
-- --------------------------------------------------
   /*          
    CHANGE ID  :: 1                                                               
    MODIFIED BY  :: PRASHANT                              
    MODIFIED DATE :: SEP 11 2013                                                                                                                                        
    REASON   :: Wrongly block in NSECDS (ISSUE as on mail dated: SEP 10 2013 by Vikas Yevale )             
*/          
--exec [Usp_Omn_MemberBlockSegmentlist] 'ALL'            
CREATE  PROCEDURE [dbo].[Usp_Omn_MemberBlockSegmentlist_12062023]
(
	@SEGMENT  AS VARCHAR(20),
	@username as varchar(20)=null
)                            
AS                            
    SET NOCOUNT ON                            
    ----------------------------------------------------------------------------- CASE 1 
    
    --declare @SEGMENT  AS VARCHAR(20),@username as varchar(20)=null
    --set @SEGMENT='ALL'
    --set @username='E66460'
    
    truncate table Tbl_Omn_MemberSegmentList_test_12062023
                                                                                                                     
    DECLARE @DIFF_RATE AS MONEY,@STRIKE_PRICE_LIMIT AS MONEY --,@SEGMENT AS VARCHAR(20)                                                                                                                               
    SET @DIFF_RATE = 20                                                                                                                                
    SET @STRIKE_PRICE_LIMIT = 10000000 --250000000                                                                                                            
   -- SET @SEGMENT = 'NSE OPT'    
       
    SET @DIFF_RATE = @DIFF_RATE / 100      
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                            
                            
    IF @SEGMENT = 'EQUITY'                            
        OR @SEGMENT = 'ALL'                            
        OR @SEGMENT = 'EQUITY_COMMO'                            
      BEGIN         
        
          ----------------- FUTURE FILE                                                                                                                     
          SELECT TDATE=CONVERT(DATETIME, Substring(A.FNAME, 3, 2) + '/' + Substring(A.FNAME, 1, 2) + '/20' + Substring(A.FNAME, 5, 2)),                            
                 A.INST_TYPE,                            
                 A.SYMBOL,                            
                 EXP_DATE,                            
                 STRIKE_PRICE,                            
                 OPT_TYPE,                            
                 OPEN_INT=CC,                            
                 CLOSING_RATE=B.CLS                            
          INTO   #FILE2                            
          FROM   FOMD A (NOLOCK),                            
                 --FROM (SELECT * FROM FOMD_CUMM WHERE MFDATE='APR 22 2008') A,                                                                                                                      
                 (SELECT SCRIP,                            
                         CLS                            
                  FROM   MD (NOLOCK)                            
                  --SELECT SCRIP,CLS  FROM MDCUMM WHERE MFDATE='APR 22 2008'                                                                                                                      
                  UNION                            
                  SELECT SCRIP=SYMBOL,                            
                         CLS=NIFTY                            
                  FROM   SPOT_NIFTY (NOLOCK)                            
                  WHERE                            
                    TDATE = (SELECT Max(TDATE)                            
                             FROM   SPOT_NIFTY (NOLOCK))) B                            
          WHERE                  
            A.SYMBOL = B.SCRIP                            
            AND INST_TYPE LIKE 'FUT%'                            
            AND a.CLS * CC > @STRIKE_PRICE_LIMIT                            
           AND EXP_DATE <> CONVERT(DATETIME, Substring(A.FNAME, 3, 2) + '/' + Substring(A.FNAME, 1, 2) + '/20' + Substring(A.FNAME, 5, 2))                            
                         
          ----------------- OPTION FILE                                                                                                    
          SELECT TDATE=CONVERT(DATETIME, Substring(A.FNAME, 3, 2) + '/' + Substring(A.FNAME, 1, 2) + '/20' + Substring(A.FNAME, 5, 2)),                            
                 A.INST_TYPE,                            
                 A.SYMBOL,                            
                 EXP_DATE,                            
                 STRIKE_PRICE,            
                 OPT_TYPE,                            
                 OPEN_INT=CC,                            
   CLOSING_RATE=B.CLS                            
          INTO   #FILE1                            
          FROM   FOMD A (NOLOCK),                            
                 (SELECT SCRIP,                   
                         CLS                            
                  FROM   MD (NOLOCK)                            
    UNION                            
                  SELECT SCRIP=SYMBOL,                            
                         CLS=NIFTY                            
           FROM   SPOT_NIFTY (NOLOCK)                            
                  WHERE                            
                    TDATE = (SELECT Max(TDATE)                            
                             FROM   SPOT_NIFTY (NOLOCK))) B                            
          WHERE                            
            A.SYMBOL = B.SCRIP                           
            AND INST_TYPE LIKE 'OPT%'                            
            AND CC * ( CONVERT(MONEY, STRIKE_PRICE) + a.CLS ) > @STRIKE_PRICE_LIMIT                            
            AND CONVERT(MONEY, A.STRIKE_PRICE) >= B.CLS - ( B.CLS * @DIFF_RATE )                            
            AND CONVERT(MONEY, A.STRIKE_PRICE) <= B.CLS + ( B.CLS * @DIFF_RATE )                            
            AND EXP_DATE <> CONVERT(DATETIME, Substring(A.FNAME, 3, 2) + '/' + Substring(A.FNAME, 1, 2) + '/20' + Substring(A.FNAME, 5, 2))                            
                            
          SELECT INST_TYPE=B.INSTRUMENTNAME,                            
                 B.SYMBOL,                            
                 EXP_DATE=CONVERT(DATETIME, Substring(B.EXPIRY, 1, 11)),                            
                 STRIKE_PRICE=CONVERT(MONEY, B.STRIKEPRICE) / 100,                            
                 B.OPTIONTYPE                            
          INTO   #OPTFILE                            
          FROM   (SELECT *                            
                  FROM   MIS.UPLOAD.DBO.CONTRACTFILE_NEW WITH (NOLOCK)                            
                  WHERE                            
                   SYMBOL IS NOT NULL                            
                   AND INSTRUMENTNAME LIKE 'OPT%') B                            
                 LEFT OUTER JOIN #FILE1 A                            
                   ON A.INST_TYPE = B.INSTRUMENTNAME                            
                      AND A.SYMBOL = B.SYMBOL                            
                      AND A.EXP_DATE = CONVERT(DATETIME, Substring(B.EXPIRY, 1, 11))                            
                      AND A.STRIKE_PRICE = CONVERT(MONEY, B.STRIKEPRICE) / 100                            
                      AND A.OPT_TYPE = B.OPTIONTYPE                            
          --WHERE                            
            --A.TDATE IS NULL        
              
              
          SELECT INST_TYPE=B.INSTRUMENTNAME,                            
                 B.SYMBOL,                            
                 EXP_DATE=CONVERT(DATETIME, Substring(B.EXPIRY, 1, 11)),                           
                 STRIKE_PRICE=0,                            
                 OPTIONTYPE=' '                            
          INTO   #FUTFILE                            
          FROM   (SELECT *                            
                  FROM   MIS.UPLOAD.DBO.CONTRACTFILE_NEW WITH (NOLOCK)                            
                  WHERE                            
             SYMBOL IS NOT NULL                            
                   AND INSTRUMENTNAME LIKE 'FUT%') B                            
                 LEFT OUTER JOIN #FILE2 A                            
                   ON A.INST_TYPE = B.INSTRUMENTNAME                            
                      AND A.SYMBOL = B.SYMBOL                            
                      AND A.EXP_DATE = CONVERT(DATETIME, Substring(B.EXPIRY, 1, 11))                            
          --WHERE                            
            --A.TDATE IS NULL                            
                            
  
   /* Below line added by Manesh Mukherjee on 06/03/2014 PRMS id: 10151261 */      
  
   INSERT INTO #optfile   
   SELECT a.*   
   FROM   (SELECT inst_type,   
         symbol,   
         exp_date,   
         strike_price,   
         opt_type   
     FROM   fomd WITH (nolock)   
     WHERE  exp_date > Getdate() + 180   
         AND LEFT(inst_type, 3) = 'OPT') a   
       LEFT OUTER JOIN #optfile b   
        ON a.inst_type = b.inst_type   
           AND a.symbol = b.symbol   
           AND a.exp_date = b.exp_date   
           AND a.strike_price = b.strike_price   
           AND a.opt_type = b.optiontype   
   WHERE  b.symbol IS NULL   
                            
   INSERT INTO #futfile   
   SELECT a.*   
   FROM   (SELECT inst_type,   
         symbol,   
         exp_date,   
         strike_price,   
         opt_type   
     FROM   fomd WITH (nolock)   
     WHERE  exp_date > Getdate() + 180   
         AND LEFT(inst_type, 3) = 'FUT') a   
       LEFT OUTER JOIN #futfile b   
        ON a.inst_type = b.inst_type   
           AND a.symbol = b.symbol   
           AND a.exp_date = b.exp_date   
   WHERE  b.symbol IS NULL   
                     
   /* ABOVE line added by Manesh Mukherjee on 06/03/2014 PRMS id: 10151261 */                    
     
          --------------------NSE EQ                                                                                          
          SELECT TEMPLATENAME ='MEMBER',                            
                 [ADDITION/DELETION] ='1',                            
                 *,                            
           STAT = '1,,,'                            
          INTO   #NSE1                            
          --SELECT * FROM   #NSE1                                      
          FROM   (SELECT INSTRUMENTTYPE= 'NSE EQ',                            
           INSTRUMENTNAME = '',                            
                         SYMBOL,                            
                         SERIES /*= [GROUP] */,                            
                         EXPIRYDATE = '',                            
                         STRIKEPRICE = '',                            
               OPTIONTYPE = ''                            
                  FROM   VW_BLOCKSCRIPS_NSE S                            
                  WHERE                            
                   NOT EXISTS(SELECT SYMBOL,                            
 SERIES                            
                              FROM   MISC.DBO.PD301203 CP WITH(NOLOCK)                            
                              WHERE                            
                               PDDATE = (SELECT Max(PDDATE)                            
   FROM   MISC.DBO.PD301203 CP WITH(NOLOCK))                            
                               AND ( SERIES LIKE 'N%'                            
                                      OR SERIES LIKE 'W%' )                            
                               AND NET_TRDVAL > 25 * 10000000           
                  AND S.SYMBOL = CP.SYMBOL                            
                               AND S.SERIES = CP.SERIES)                            
                                
                 ) A                            
                
          -------------------BSE EQ                                                                                                              
          SELECT TEMPLATENAME ='MEMBER',                            
                 [ADDITION/DELETION] ='1',                            
                 *,                            
               STAT = '1,,,'                            
          INTO   #BSE1                            
          FROM   (                            
                            
                 SELECT INSTRUMENTTYPE= 'BSE EQ',                            
                        INSTRUMENTNAME = '',                            
                        BSESCRIPTNAME,                            
                        SCRIPGROUP AS SERIES,                            
                        EXPIRYDATE = '',                            
                        STRIKEPRICE = '',                            
               OPTIONTYPE = ''                            
                  FROM   VW_BLOCKSCRIPS_BSE SC WITH(NOLOCK)                            
                  WHERE                            
                   NOT EXISTS (SELECT SC_CODE                            
                               FROM   MISC.DBO.QE CP WITH(NOLOCK)                            
                               WHERE                           
                                PDDATE = (SELECT Max(PDDATE)                            
                          FROM   MISC.DBO.QE)                            
                                AND SC_CODE LIKE '9%'                            
                                AND NET_TURNOV > 25 * 10000000                            
                                AND SC.SCRIP_CD = CP.SC_CODE)                            
                                        
                 ) A                            
                        
          SELECT *                            
          INTO   #EQUITY                            
          FROM   (SELECT TEMP_NAME='MEMBER',                            
                         AD=1,                            
                         INST_TYPE='NSE OPT',                            
                         INST_NAME=INST_TYPE,                            
                         SYMBOL,                            
                         SERIES='',                            
                         EXPIRY=Replace(Replace(CONVERT(VARCHAR(11), EXP_DATE, 106), ' ', '-'), '-20', '-'),                            
                         STRIKE_PRICE=Ltrim(Rtrim(CONVERT(VARCHAR(10), CONVERT(MONEY, STRIKE_PRICE)))),                            
                         OPTIONTYPE,                            
                         STAT=',,2,'                            
                                   
                  FROM   #OPTFILE   
                                             
                  UNION ALL                            
                  SELECT TEMP_NAME='MEMBER',                            
                         AD=1,                            
                         INST_TYPE='NSE FUT',                          
                         INST_NAME=INST_TYPE,                            
                         SYMBOL,           
                         SERIES='',                            
                         EXPIRY=Replace(Replace(CONVERT(VARCHAR(11), EXP_DATE, 106), ' ', '-'), '-20', '-'),                            
                         STRIKE_PRICE='',                            
                         OPTIONTYPE,                            
                         STAT=',2,,'                          
                  FROM   #FUTFILE                           
                   
                  UNION ALL                            
       SELECT *                            
                  FROM   #NSE1                            
                  UNION ALL                            
                  SELECT *                            
                  FROM   #BSE1) A                            
      END                            
                            
    IF @SEGMENT = 'COMMODITIES'                            
        OR @SEGMENT = 'ALL'                            
        OR @SEGMENT = 'EQUITY_COMMO'                            
        OR @SEGMENT = 'CURRENCY_COMMO'                            
      BEGIN                            
                                                                                          
          -------------------------------------------------------------MCX                                                                                                        
  SELECT INSTRUMENT_TYPE = 'MCX FUT',                            
                 INSTRUMENTNAME = 'FUTCOM',                            
                 [COMMODITY SYMBOL],                            
                 SERIES = '',                            
                 [CONTRACT/EXPIRY MONTH]=Replace(Replace(Replace(CONVERT(VARCHAR(11), [CONTRACT/EXPIRY MONTH], 106), ' ', '-'), '-20', '-'), ' ', ''),                            
                 STRIKE_PRICE = '',                            
                 OPT_TYPE = ''                            
          INTO   #COMMMCX1                            
    FROM   MIS.UPLOAD.DBO.MCDX_BHAV_COPY WITH (NOLOCK)                            
          WHERE                            
            [OI(IN LOTS)] < 50        
                            
          SELECT INSTRUMENT_TYPE = 'MCX FUT',                            
                 INSTRUMENTNAME = 'FUTCOM',                            
                 C5 AS SYMBOL,                            
                 SERIES = '',                            
                 C10=CASE                            
                       WHEN C10 <> '' THEN Replace(Replace(Replace(CONVERT(VARCHAR(11), CONVERT(DATETIME, Substring(C10, 1, 2) + '/' + Substring(C10, 3, 3) + '/' + Substring(C10, 6, 10)), 106), ' ', '-'), '-20', '-'), ' ', '')                            



                       ELSE ''                            
                     END,                            
                 STRIKE_PRICE = '',                            
                 OPT_TYPE = ''                            
          INTO   #COMMMCX2 --,EXPDATE                                      
          FROM   MIS.UPLOAD.DBO.CONTRACTFILE_MCX A WITH (NOLOCK)                            
                 LEFT OUTER JOIN (SELECT SYM=[COMMODITY SYMBOL],                            
                                         EXPDATE=[CONTRACT/EXPIRY MONTH]                            
                                  FROM   MIS.UPLOAD.DBO.MCDX_BHAV_COPY WITH (NOLOCK)) B                            
                   ON A.C5 = B.SYM                            
                      AND CASE                            
        WHEN C10 <> '' THEN CONVERT(DATETIME, Substring(C10, 1, 2) + '/' + Substring(C10, 3, 3) + '/' + Substring(C10, 6, 10))                            
                            ELSE ''                            
                          END = B.EXPDATE                 
          WHERE                            
            EXPDATE IS NULL                            
         AND C1 = 'FUTCOM'      
                            
          --DROP TABLE #COMMN1                                                                                                      
          -------------------------------------------------------------NCDEX                                                               
          SELECT INSTRUMENT_TYPE = 'NCDEX FUT',                            
                 INSTRUMENTNAME = 'FUTCOM',                            
                 SYMBOL,                           
                 SERIES = '',                            
                 EXPIRY_DATE=Replace(Replace(CONVERT(VARCHAR(11), CONVERT(DATETIME, EXPIRY_DATE), 106), ' ', '-'), '-20', '-'),                            
                 STRIKEPRICE = '',                            
                 OPT_TYPE = '',                            
                 OPEN_INTEREST=Isnull(A.OPEN_INTEREST, 0) / CONVERT(INT, B.C12)                            
          INTO   #TTT                            
          FROM   MIS.UPLOAD.DBO.NCDEX_BHAV_COPY A WITH (NOLOCK)                            
                 LEFT OUTER JOIN MIS.UPLOAD.DBO.CONTRACTFILE_NCDEX B WITH (NOLOCK)                            
                   ON A.SYMBOL = B.C3                            
                      AND A.EXPIRY_DATE = CASE                            
WHEN C4 <> '' THEN CONVERT(DATETIME, C4)                            
                                            /*CONVERT(DATETIME,SUBSTRING(C4,1,2)+'/'+SUBSTRING(C4,4,3)+'/'+SUBSTRING(C4,8,10))*/                            
                                            ELSE ''                            
                                          END                            
                            where isnumeric(A.OPEN_INTEREST)=1 
          --WHERE A.SYMBOL='SLVPURAHM'                                              
          SELECT INSTRUMENT_TYPE,                            
                 INSTRUMENTNAME,                            
                 SYMBOL,                            
                 SERIES,                            
                 EXPIRY_DATE,                            
                 STRIKEPRICE,                            
                 OPT_TYPE         
          INTO   #COMMN1                            
          FROM   #TTT                            
          WHERE                            
            OPEN_INTEREST < 50                            
                            
          SELECT INSTRUMENT_TYPE = 'NCDEX FUT',                            
                 INSTRUMENTNAME = 'FUTCOM',                            
                 C3 AS SYMBOL,                            
                 SERIES = '',                            
                 C4 = CASE                            
                WHEN C4 <> '' THEN /*REPLACE(REPLACE(CONVERT(VARCHAR(11),CONVERT(DATETIME,SUBSTRING(C4,1,2)+'/'+SUBSTRING(C4,4,3)+'/'+SUBSTRING(C4,8,10)),106),' ','-'),'-2                                    
                                                                                     0                                      
                                                                                                                               '                                         
                                                                                             ,'-')*/ C4                            
                        ELSE ''                            
                      END,                            
                 STRIKE_PRICE ='',                            
                 OPT_TYPE =''                            
          INTO   #COMMN2                   
          FROM   MIS.UPLOAD.DBO.CONTRACTFILE_NCDEX A WITH (NOLOCK)                            
LEFT OUTER JOIN (SELECT SYM=SYMBOL,                            
                                         EXPIRY_DATE                            
                                  FROM   MIS.UPLOAD.DBO.NCDEX_BHAV_COPY WITH (NOLOCK)) B                            
                   ON A.C3 = B.SYM                            
                      AND CASE                            
                            WHEN C4 <> '' THEN CONVERT(DATETIME, C4)/*SUBSTRING(C4,1,2)+'/'+SUBSTRING(C4,4,3)+'/'+SUBSTRING(C4,8,10)*/                            
                            ELSE ''                            
                          END = B.EXPIRY_DATE                  
          WHERE                            
            EXPIRY_DATE IS NULL                            
                            
          --------------------------------------------MCX-SX----------------------------                                                                                      
          --SELECT INSTRUMENT_TYPE = 'MCXSX FUT',                                
          --       INSTRUMENTNAME = 'FUTCUR',                                
          SELECT INSTRUMENT_TYPE = case when substring(INSTRUMENT,1,3)='FUT' then 'MCXSX CUR FUT'  when substring(INSTRUMENT,1,3)='OPT' then 'MCXSX CUR OPT' else 'MCXSX CUR' end ,                  
                 INSTRUMENTNAME = Ltrim(Rtrim(INSTRUMENT)),                            
                 SYMBOL = PRODUCT,                            
                 SERIES = '',                            
                 [SERIES/EXPIRY]=Replace(Replace(Replace(CONVERT(VARCHAR(11), [EXPIRY], 106), ' ', '-'), '-20', '-'), ' ', ''),                            
     STRIKE_PRICE = CASE                            
                                  WHEN [STRIKE PRICE] IS NULL THEN '0000'                            
                                  ELSE CONVERT(VARCHAR(4), CONVERT (INT, [STRIKE PRICE] * 100))                            
                                END,                            
                 OPTION_TYPE = Isnull([OPTION TYPE], '')                            
          INTO   #COMMMCXSX1                         
          --FROM   MIS.UPLOAD.DBO.MCXSX_BHAV_COPY WITH (NOLOCK)                                
          FROM   MIS.UPLOAD.DBO.MCXSX_CP_F WITH (NOLOCK)                
          --FROM   [196.1.115.182].GENERAL.DBO.CP_MCXSX WITH (NOLOCK)                                
          WHERE            
    /* -- Commented by Manesh Mukherjee PRMS id: 10151263     
    (PRODUCT = 'USDINR' AND Round(Replace(Replace([OPEN INTEREST], '"', ''), '''', ''), 0) < 5000 )                
    OR                
    (PRODUCT <> 'USDINR' AND Round(Replace(Replace([OPEN INTEREST], '"', ''), '''', ''), 0) < 500 )                           
    */  
    Round(Replace(Replace([OPEN INTEREST], '"', ''), '''', ''), 0) < 500   
     
           ---- PRMS ID – 10151208                 
           --Round(Replace(Replace([OPEN INTEREST], '"', ''), '''', ''), 0) < 5000                            
                            
          SELECT INSTRUMENT_TYPE = case when substring(A.C1,1,3)='FUT' then 'MCXSX CUR FUT'  when substring(A.C1,1,3)='OPT' then 'MCXSX CUR OPT' else 'MCXSX CUR' end ,                            
                 INSTRUMENTNAME = A.C1,                            
                 SYMBOL=A.C5,                            
                 SERIES='',                            
                 EXPIRYDATE = Isnull(C10, ''),                            
                 STRIKEPRICE = CASE                     
                                 WHEN [C9] IS NULL THEN '0000'                            
                                 ELSE CONVERT(VARCHAR(4), convert(int,CONVERT (decimal(15,4), [C9])* 100))                          
                               END,                            
                 OPTIONTYPE = Isnull(A.C8, '')                     
          INTO   #COMMMCXSX2 -- DROP TABLE #COMMMCXSX2                              
          --SELECT *              
          FROM   MIS.UPLOAD.DBO.CONTRACTFILE_MCXSX A WITH(NOLOCK)                            
                 LEFT OUTER JOIN MIS.UPLOAD.DBO.MCXSX_CP_F B                            
                   ON Rtrim(Ltrim(A.C1)) = Rtrim(Ltrim(B.[INSTRUMENT]))                            
                      AND Rtrim(Ltrim(A.C5)) = Rtrim(Ltrim(B.PRODUCT))                            
                      AND A.C10 = Upper(Replace(CONVERT(VARCHAR, expiry, 106), ' ', ''))                            
                      AND Isnull(A.C8, '') = Isnull([OPTION TYPE], '')   
                      AND Isnull(CONVERT(VARCHAR, CONVERT(MONEY, C9)), '') = Isnull(CONVERT(VARCHAR, CONVERT(MONEY, [STRIKE PRICE])), '')                            
          WHERE                            
            expiry IS NULL                            
                            
          SELECT DISTINCT *                            
          INTO   #MCXSX3                            
          FROM   (SELECT *                           
                  FROM   #COMMMCXSX1                            
                  UNION ALL                            
                  SELECT *                            
              FROM   #COMMMCXSX2)A                            
                            
------------------------------------------------------- NSX -------------------------------------------------------------                                    
          SELECT INSTRUMENT_TYPE = 'NSECDS ' + LEFT(INSTRUMENT, 3),                            
                 INSTRUMENTNAME = INSTRUMENT,--= 'FUTCUR',                                    
                 [SYMBOL],                            
                 Series = '',                
                 CONTRACT_DATE AS EXPDATE,                            
                 AA            AS STRIKE_PRICE,                            
                 BB            AS OPTIONTYPE                            
          INTO   #NSX_BHAVCOPY -- DROP TABLE #NSX_BHAVCOPY                                    
    FROM   DBO.CP_NSX WITH (NOLOCK)                            
          WHERE                 
    /* -- Commented by Manesh Mukherjee PRMS id: 10151263                       
    ([SYMBOL] = 'USDINR' AND cc < 5000 )                
    OR                
    ([SYMBOL] <> 'USDINR' AND cc < 500 ) */                                    
    cc < 500   
         -- PRMS ID – 10151208                
           -- CC < 5000                            
                            
  SELECT INSTRUMENT_TYPE = 'NSECDS ' + LEFT(a.INSTRUMENT, 3),                            
                 --INSTRUMENTNAME = 'FUTCUR'                                    
                 INSTRUMENTNAME = A.INSTRUMENT,                            
                 A.SYMBOL,                            
                 SERIES,                            
                 EXPIRYDATE,                            
                 CONVERT(VARCHAR,CONVERT(DECIMAL(15,2),CONVERT(INT,STRIKEPRICE)/10000000.00)) AS STRIKEPRICE,                    
                 OPTIONTYPE                            
          INTO   #NSX_CONTRACTFILE -- DROP TABLE #NSX_CONTRACTFILE                                    
          FROM   MIS.UPLOAD.DBO.NSXBLOCKSCRIPT A WITH(NOLOCK)                            
                 LEFT OUTER JOIN DBO.CP_NSX B                            
                   ON Rtrim(Ltrim(A.INSTRUMENT)) = Rtrim(Ltrim(B.INSTRUMENT))                            
                      AND Rtrim(Ltrim(A.SYMBOL)) = Rtrim(Ltrim(B.[SYMBOL]))                            
                      AND A.EXPIRYDATE = B.CONTRACT_DATE                            
                      AND Rtrim(Ltrim(A.OPTIONTYPE)) = Rtrim(Ltrim(CASE                            
                                                                     WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN 'XX'                            
                                                                     ELSE B.BB                            
                                                                   END))                            
                      AND ( CASE                            
                              WHEN LEFT(A.INSTRUMENT, 3) = 'FUT' THEN '-1'                            
                              ELSE CONVERT(VARCHAR, CONVERT(MONEY, CONVERT(INT, STRIKEPRICE) / 10000000.00))                            
    END ) = CASE                            
                                      WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN '-1'                            
                                      /*CHANGE ID  :: 1*/          
                                      --ELSE Rtrim(B.AA)          
                                      ELSE CONVERT(VARCHAR, CONVERT(MONEY, B.AA))        
                              END                            
          WHERE                            
            CONTRACT_DATE IS NULL                            
                    
          SELECT DISTINCT *                            
          INTO   #NSX_BLK_FILE                            
          FROM   (SELECT *                            
                  FROM   #NSX_BHAVCOPY                            
                  UNION ALL                            
                  SELECT *                            
                  FROM   #NSX_CONTRACTFILE)A     

-------------------------------------------------------BSX---------------------------------------------

  --  SELECT INSTRUMENT_TYPE = 'BSECDS ' + LEFT(INSTRUMENT, 3),                            
  --               INSTRUMENTNAME = INSTRUMENT,--= 'FUTCUR',                                    
  --               [SYMBOL],                            
  --               Series = '',                
  --               CONTRACT_DATE AS EXPDATE,                            
  --               AA            AS STRIKE_PRICE,                            
  --               BB            AS OPTIONTYPE                            
  --        INTO   #BSX_BHAVCOPY -- DROP TABLE #NSX_BHAVCOPY                                    
  --  FROM   [196.1.115.182].GENERAL.DBO.CP_BSX WITH (NOLOCK)                            
  --        WHERE                 
  --  /* -- Commented by Manesh Mukherjee PRMS id: 10151263                       
  --  ([SYMBOL] = 'USDINR' AND cc < 5000 )                
  --  OR                
  --  ([SYMBOL] <> 'USDINR' AND cc < 500 ) */                                    
  --  cc < 500   
  --       -- PRMS ID – 10151208                
  --         -- CC < 5000                            
                            
  --SELECT INSTRUMENT_TYPE = 'BSECDS ' + LEFT(a.INSTRUMENT, 3),                            
  --               --INSTRUMENTNAME = 'FUTCUR'                                    
  --               INSTRUMENTNAME = A.INSTRUMENT,                            
  --               A.SYMBOL,                            
  --               SERIES,                            
  --               EXPIRYDATE,                            
  --               CONVERT(VARCHAR,CONVERT(DECIMAL(15,2),CONVERT(INT,STRIKEPRICE)/10000000.00)) AS STRIKEPRICE,                    
  --               OPTIONTYPE                            
  --        INTO   #BSX_CONTRACTFILE -- DROP TABLE #NSX_CONTRACTFILE                                    
  --        FROM   MIS.UPLOAD.DBO.BSXBLOCKSCRIPT A WITH(NOLOCK)                            
  --               LEFT OUTER JOIN [196.1.115.182].GENERAL.DBO.CP_BSX B                            
  --                 ON Rtrim(Ltrim(A.INSTRUMENT)) = Rtrim(Ltrim(B.INSTRUMENT))                            
  --              AND Rtrim(Ltrim(A.SYMBOL)) = Rtrim(Ltrim(B.[SYMBOL]))                            
  --                    AND A.EXPIRYDATE = B.CONTRACT_DATE                            
  --                    AND Rtrim(Ltrim(A.OPTIONTYPE)) = Rtrim(Ltrim(CASE                            
  --                                                                   WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN 'XX'                            
  --                                                                   ELSE B.BB                            
  --                                                                 END))                            
  --                    AND ( CASE                            
  --                            WHEN LEFT(A.INSTRUMENT, 3) = 'FUT' THEN '-1'                            
  --                            ELSE CONVERT(VARCHAR, CONVERT(MONEY, CONVERT(INT, STRIKEPRICE) / 10000000.00))                            
  --  END ) = CASE                            
  --                                    WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN '-1'                            
  --                                    /*CHANGE ID  :: 1*/          
  --                                    --ELSE Rtrim(B.AA)          
  --                                    ELSE CONVERT(VARCHAR, CONVERT(MONEY, B.AA))        
  --                            END                            
  --        WHERE                            
  --          CONTRACT_DATE IS NULL                            
                    
  --        SELECT DISTINCT *                            
  --        INTO   #BSX_BLK_FILE                            
  --        FROM   (SELECT *                            
  --                FROM   #BSX_BHAVCOPY                            
  --                UNION ALL                            
  --                SELECT *                            
  --                FROM   #BSX_CONTRACTFILE)A 
  
  
  ---New--
  --SELECT INSTRUMENT_TYPE = 'BSECDS ' + LEFT(INSTRUMENT, 3),          
  --               INSTRUMENTNAME = INSTRUMENT,--= 'FUTCUR',                                  
  --               [SYMBOL],          
  --               Series = '',          
  --               expirydate AS EXPDATE,          
  --               strike_price            AS STRIKE_PRICE,          
  --               isnull (option_type,'')            AS OPTIONTYPE          
  --        INTO   #BSX_BHAVCOPY -- DROP TABLE #NSX_BHAVCOPY                                  
  --        FROM   [196.1.115.182].GENERAL.DBO.CP_BSX WITH (NOLOCK)          
  --        WHERE      
  --        /* -- Commented by Manesh Mukherjee PRMS id: 10151263     
  --        ( [SYMBOL] = 'USDINR' AND cc < 5000 ) OR ( [SYMBOL] <> 'USDINR' AND cc < 500 ) */     open_interest < 500     
       
  --        -- PRMS ID – 10151208              
  --        -- CC < 5000                          
  --        SELECT INSTRUMENT_TYPE = 'BSECDS ' + LEFT(a.INSTRUMENT, 3),          
  --               --INSTRUMENTNAME = 'FUTCUR'                                  
  --               INSTRUMENTNAME = A.INSTRUMENT,          
  --               A.SYMBOL,          
  --               SERIES,          
  --               A.Expirydate,  
  --               CONVERT(VARCHAR, CONVERT(DECIMAL(15, 2), CONVERT(INT, STRIKEPRICE) / 10000000.00)) AS STRIKEPRICE,          
  --               OPTIONTYPE          
  --        INTO   #BSX_CONTRACTFILE -- DROP TABLE #BSX_CONTRACTFILE                                  
  --        FROM   MIS.UPLOAD.DBO.BSXBLOCKSCRIPT A WITH(NOLOCK)          
  --               LEFT OUTER JOIN [196.1.115.182].GENERAL.DBO.CP_BSX B          
  --                 ON Rtrim(Ltrim(A.INSTRUMENT)) = Rtrim(Ltrim(B.INSTRUMENT))          
  --                    AND Rtrim(Ltrim(A.SYMBOL)) = Rtrim(Ltrim(B.[SYMBOL]))          
  --                    AND A.Expirydate = B.expirydate          
  --                    AND Rtrim(Ltrim(A.OPTIONTYPE)) = Rtrim(Ltrim(CASE          
  --                                                                   WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN 'XX'          
  --                                                                   ELSE B.option_type          
  --                                                                 END))          
  --                    AND ( CASE          
  --                            WHEN LEFT(A.INSTRUMENT, 3) = 'FUT' THEN '-1'          
  --                            ELSE CONVERT(VARCHAR, CONVERT(MONEY, CONVERT(INT, STRIKEPRICE) / 10000000.00))          
  --                          END ) = CASE          
  --                                    WHEN LEFT(B.INSTRUMENT, 3) = 'FUT' THEN '-1'          
  --                                  /*CHANGE ID  :: 1*/          
  --                                    --ELSE Rtrim(B.AA)          
  --                                    ELSE CONVERT(VARCHAR, CONVERT(MONEY, B.strike_price))          
  --                                  END          
  --        WHERE  B.Expirydate IS NULL          
          
  --        SELECT DISTINCT *          
  --        INTO   #BSX_BLK_FILE          
  --        FROM   (SELECT *    
  --                FROM   #BSX_BHAVCOPY          
  --                UNION ALL          
  --                SELECT *          
  --                FROM   #BSX_CONTRACTFILE)A      
                    
  --              --  delete from #BSX_BLK_FILE where   OPTIONTYPE is null
  --                     update  #BSX_BLK_FILE
		--			  set   OPTIONTYPE= ''  
		--			  where   OPTIONTYPE is null 
					  
		--			  delete from #BSX_BLK_FILE where EXPDATE>='2099-03-26 00:00:00.000'       





-----------------------------------------END-------------------------------------------------------------                       
                            
          ------------------------------------------------------------COMMODITIES                                                                                                        
          SELECT TEMPLATENAME ='MEMBER',                            
         [ADDITION/DELETION] ='1',                            
                 *,                            
                 STAT =Rtrim(Ltrim(CASE  WHEN LEFT(a.INSTRUMENTNAME, 3) = 'FUT' THEN ',2,,'                            
                                         WHEN LEFT(a.INSTRUMENTNAME, 3) = 'OPT' then ',,2,'           
                                                                                               
                                         END))              
                             
                                            
          INTO   #COMMODITIES                            
          FROM   (SELECT *                            
                  FROM   #COMMMCX1                            
                  UNION ALL                            
                  SELECT *                            
                  FROM   #COMMMCX2                            
                  UNION ALL                            
                  SELECT INSTRUMENTNAME AS INSTRUMENTTYPE,                            
                         INSTRUMENTNAME = 'FUTCOM',                            
                         SYMBOL,                            
                         SERIES='',                            
                         EXPIRYDATE = EXP_DATE,                            
                         STRIKEPRICE = '',             
                         OPT_TYPE = ''                            
                  FROM   Block_scrips(NOLOCK)                            
                  WHERE                            
                    INSTRUMENTNAME = 'MCX FUT'                            
                    AND DELETE_STATUS <> 'Y'                            
                    AND EXP_DATE >= CONVERT(DATETIME, CONVERT(VARCHAR(11), Getdate()))                            
                  UNION ALL                            
                  SELECT *                            
                  FROM   #COMMN1                            
                  UNION ALL                            
                  SELECT *                            
                  FROM   #COMMN2                            
                  UNION ALL                            
                  SELECT INSTRUMENTNAME AS INSTRUMENTTYPE,                            
                         INSTRUMENTNAME = 'FUTCOM',                            
                         SYMBOL,                            
                         SERIES='',                            
                         EXPIRYDATE = EXP_DATE,                            
                         STRIKEPRICE = '',                            
                         OPT_TYPE = ''                            
                  FROM   Block_scrips(NOLOCK)                            
                  WHERE                            
                    INSTRUMENTNAME = 'NCDEX FUT'                            
                    AND DELETE_STATUS <> 'Y'                            
                    AND EXP_DATE >= CONVERT(DATETIME, CONVERT(VARCHAR(11), Getdate()))                            
        UNION ALL                            
                  SELECT *                            
                  FROM   #MCXSX3                            
                  WHERE                            
                    CONVERT(DATETIME, [SERIES/EXPIRY]) >= CONVERT(DATETIME, CONVERT(VARCHAR(11), Getdate(), 103), 103)                           
                  UNION ALL ----------------------------------                                    
                  SELECT *                            
                  FROM   #NSX_BLK_FILE                                        
                  WHERE CONVERT(DATETIME, EXPDATE) >= CONVERT(DATETIME, CONVERT(VARCHAR(11), Getdate(), 103), 103))A 
                  --changes on 25/04/2018  
                  --UNION ALL ----------------------------------    
                  --SELECT *                            
                  --FROM   #BSX_BLK_FILE                                        
                  --WHERE CONVERT(DATETIME, EXPDATE) >= CONVERT(DATETIME, CONVERT(VARCHAR(11), Getdate(), 103), 103))A                            
                  
                  -------END---------------------
    END             
                    
    IF @SEGMENT = 'EQUITY'                            
      BEGIN                            
          SELECT *          
          FROM   #EQUITY                            
      END                            
                            
    IF @SEGMENT = 'COMMODITIES'                            
        OR @SEGMENT = 'CURRENCY_COMMO'                            
      BEGIN                            
          SELECT  *
          FROM   #COMMODITIES                            
      END                            
                            
		IF @SEGMENT = 'ALL'
			begin 	
				  insert into Tbl_Omn_MemberSegmentList_test_12062023                         
				  SELECT TEMP_NAME,[AD],INST_TYPE,INST_NAME,[SYMBOL],SERIES,[EXPIRY],convert (numeric (18,2),case when STRIKE_PRICE='' then '0' else STRIKE_PRICE end) as STRIKE_PRICE,OPTIONTYPE,STAT                                                      
				  FROM   #EQUITY                            
				  UNION ALL                            
				  SELECT TEMPLATENAME,[ADDITION/DELETION],INSTRUMENT_TYPE,INSTRUMENTNAME,[COMMODITY SYMBOL],SERIES,[CONTRACT/EXPIRY MONTH],convert (numeric (18,2),case when STRIKE_PRICE='' then '0' else STRIKE_PRICE end) as STRIKE_PRICE,OPT_TYPE,STAT                
                  
				  FROM   #COMMODITIES                     
		          
					
					select case when @segment='NSE EQ' then 'NSE Restricted Scrip Basket' 
								when @segment='BSE EQ' then 'BSE Restricted Scrip Basket' 
								when @segment='MCX FUT' then 'MCX OPT Restricted Scrip Basket'
								when @segment='NCDEX FUT' then 'NCDEX OPT Restricted Scrip Basket' 
								when @segment='NSE OPT FUT' then 'NSE OPT FUT Restricted Scrip Basket' 
								when @segment='NSECDS OPT FUT' then 'NSECDS OPT FUT Restricted Scrip Basket' end 
					union all
					select INST_TYPE+'|'+SYMBOL +'|'+ replace (convert(varchar, EXPIRY, 106),' ','-') +'|'+ STRIKE_PRICE +'|'+ OPTIONTYPE
					from  Tbl_Omn_MemberSegmentList_test_12062023 where INST_TYPE=@SEGMENT
					
					
---------------------------Open the new strick Price-----------------------------------------------------------------
----------------------------Changes by Prashant P on 13 july 2023----------------------------------------------------										
					select a.*,b.CLS,b.CC into  #memberdata from Tbl_Omn_MemberSegmentList_test_12062023 a left join FOMD b 
					on a.SYMBOL=b.SYMBOL
					and a.EXPIRY=b.EXP_DATE
					and a.OPTIONTYPE=b.OPT_TYPE
					and a.STRIKE_PRICE=b.STRIKE_PRICE

				
					select *,(STRIKE_PRICE+CLS)*CC as Valumne  into #Omne_MnemberSegmentList from #memberdata

					insert into tbl_final_MemberSegment_List
					select *  from #Omne_MnemberSegmentList where Valumne < 2500000  or Valumne IS Null and INST_NAME in ('OPTIDX','OPTSTK','FUTIDX','FUTSTK') 
					union all 
					select * from #Omne_MnemberSegmentList where Valumne > 2500000 ---and EXPIRY >GETDATE()+180 order by EXPIRY desc

					
										 
					DECLARE @BCPCOMMAND1 VARCHAR(250)                                      
					declare @s2 as varchar(max)                              
					DECLARE @filename1 as varchar(100)              
					                                                  
					SET @FILENAME1 = '\\196.1.115.147\upload1\Member_LEAPS\MemnerSeg_List_'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.csv'                                                                                             
					--SET @FILENAME = '\\196.1.115.182\upload1\OmnesysFileFormat\CodeCreationFileFormat'+replace (convert (varchar(12),GETDATE(),103),'/','')+'.txt'                  
					                                                             
					                                 
					SET @BCPCOMMAND1 = 'BCP "select * from Risk.dbo.tbl_final_MemberSegment_List" QUERYOUT "'                              
					print(@BCPCOMMAND1)                        
					SET @BCPCOMMAND1 = @BCPCOMMAND1 + @FILENAME1 + '" -c -t, -SCSOKYC-6 -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                    
					EXEC MASTER..XP_CMDSHELL @BCPCOMMAND1 
					  
					
					insert into tbl_OMN_ProcessLog
					values(@username,getdate())
                   
           END
                            
    SET NOCOUNT OFF   
 
 
 select @@SERVERNAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_report_filter
-- --------------------------------------------------
CREATE PROCEDURE usp_report_filter        
(@access_to as varchar(15),@access_code as varchar(20),@rpt_level as varchar(15) )        
 as                 
set nocount on                 
set transaction isolation level read uncommitted          

if @access_to='BROKER'
begin

if @rpt_level='ZONE'
begin
select distinct(Zone_Mast_cd) as zone from ZoneMaster (nolock) 
end
else if @rpt_level='REGION'
begin
select distinct(REG_CODE)as reg_code from region (nolock) 
end
else if @rpt_level='BRMAST'
begin
select distinct(Branch_Mast_cd) as branchcode from BranchMaster_Grp (nolock) 
end
else if @rpt_level='SBMAST'
begin
Select distinct(SB_Mast_Cd) as Sbcode from SBMaster_Grp (nolock) 
end
--else if @rpt_level='SBFMLY'
--select 

--end
--else if @rpt_level='SB'
--begin
--select 'ALL' as filter
--end
else
begin 
Select 'ALL' as filter
end 
----------------------------------------------
end ---end of @access_to='BROKER'

else if @access_to='REGION'
begin
-----------------------------------------------------
if @rpt_level='REGION'
begin

Select Region_Mast_cd from RegionMaster where Region_Mast_cd=@access_code
end

else if @rpt_level='BRANCH'
begin

Select distinct(Branch_Mast_cd) from  BranchMaster where Branch_Mast_cd in
(select br_code from region where region=@access_to)
end

else 
begin
select 'ALL' as filter 
end
---------------------------------------------------
end       ---- end of @access_to='REGION'

else if @access_to='BRMAST'
begin
---------------------------------------------------------
if @rpt_level='BRANCH'
begin

select distinct(Branch_Mast_cd) as branchcode from BranchMaster (nolock) where Branch_Mast_cd in
(select branch_cd from BranchMaster_Grp (nolock) where Branch_Mast_cd=@access_code)
end 

else
begin 
select 'ALL' as filter 
end
-------------------------------------------
end ----end of @access_to='BRMAST'

else
begin 

select 'ALL' as filter 

end

GO

-- --------------------------------------------------
-- TABLE dbo.access_level
-- --------------------------------------------------
CREATE TABLE [dbo].[access_level]
(
    [Access_level_value] VARCHAR(25) NULL,
    [Access_level_name] VARCHAR(25) NULL,
    [Access_level_code] INT NULL,
    [Access_level_seq] INT NULL,
    [Access_level_Active] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BranchMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BranchMaster]
(
    [Branch_Mast_cd] VARCHAR(20) NULL,
    [Branch_Mast_name] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(12) NULL,
    [CreatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BranchMaster_Grp
-- --------------------------------------------------
CREATE TABLE [dbo].[BranchMaster_Grp]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Branch_Mast_cd] VARCHAR(20) NULL,
    [Branch_cd] VARCHAR(100) NULL,
    [Status] VARCHAR(1) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BranchMaster_Grp_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[BranchMaster_Grp_hist]
(
    [Id] INT NULL,
    [Branch_Mast_cd] VARCHAR(20) NULL,
    [Branch_cd] VARCHAR(100) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BrOwner
-- --------------------------------------------------
CREATE TABLE [dbo].[BrOwner]
(
    [BranchCode] VARCHAR(10) NULL,
    [BrOwner] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_mapping]
(
    [cat_code] INT NULL,
    [menu_code] INT NULL,
    [MappedBy] VARCHAR(50) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_mapping_20052014
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_mapping_20052014]
(
    [cat_code] INT NULL,
    [menu_code] INT NULL,
    [MappedBy] VARCHAR(50) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_mapping_harmony
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_mapping_harmony]
(
    [cat_code] INT NULL,
    [menu_code] INT NULL,
    [MappedBy] VARCHAR(50) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_mapping_harmony_10092016
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_mapping_harmony_10092016]
(
    [cat_code] INT NULL,
    [menu_code] INT NULL,
    [MappedBy] VARCHAR(50) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_mapping_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_mapping_HIST]
(
    [cat_code] INT NULL,
    [menu_code] INT NULL,
    [MappedBy] VARCHAR(50) NULL,
    [MappedOn] DATETIME NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.company
-- --------------------------------------------------
CREATE TABLE [dbo].[company]
(
    [Co_code] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Exchange] VARCHAR(25) NULL,
    [Co_Name] VARCHAR(100) NULL,
    [Co_Pan] VARCHAR(25) NULL,
    [BO_server] VARCHAR(25) NULL,
    [BO_Account_Db] VARCHAR(25) NULL,
    [BO_share_Db] VARCHAR(25) NULL,
    [BO_Active] INT NULL,
    [Incorporated_date] DATETIME NULL,
    [RetainLedgerDataConcluYear] INT NULL,
    [OffLineKYC] INT NULL,
    [DEMAT_Server] VARCHAR(25) NULL,
    [DEMAT_Db] VARCHAR(25) NULL,
    [COLLATERAL_Server] VARCHAR(25) NULL,
    [COLLATERAL_Db] VARCHAR(25) NULL,
    [CliDepositSeries] VARCHAR(10) NULL,
    [MTM_haircut] INT NULL,
    [Locked_On] DATETIME NULL,
    [Locked_upto] DATETIME NULL,
    [DefTrd_FutSlab] VARCHAR(6) NULL,
    [DefDel_Slab_OptPer] VARCHAR(6) NULL,
    [Calc_Remi] VARCHAR(1) NULL
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
-- TABLE dbo.emp_info
-- --------------------------------------------------
CREATE TABLE [dbo].[emp_info]
(
    [emp_no] VARCHAR(8) NULL,
    [Emp_name] VARCHAR(150) NULL,
    [email] VARCHAR(100) NULL,
    [Status] CHAR(1) NULL,
    [Level] VARCHAR(50) NULL,
    [CategoryDesc] VARCHAR(50) NULL,
    [Department] NVARCHAR(200) NULL,
    [Sub_Department] VARCHAR(150) NULL,
    [designation] VARCHAR(255) NULL,
    [CostCode] NVARCHAR(255) NULL,
    [JoinDate] DATETIME NULL,
    [SeparationDate] DATETIME NULL,
    [Sex] VARCHAR(1) NULL,
    [BirthDate] DATETIME NULL,
    [Address] VARCHAR(300) NULL,
    [Pin] VARCHAR(1) NOT NULL,
    [City] VARCHAR(50) NULL,
    [emp_region] VARCHAR(50) NULL,
    [acntno] VARCHAR(25) NULL,
    [state] VARCHAR(50) NULL,
    [Phone] VARCHAR(50) NULL,
    [Senior] VARCHAR(6) NULL,
    [Sr_name] VARCHAR(150) NULL,
    [Branch_cd] NVARCHAR(255) NULL,
    [company] NVARCHAR(50) NULL,
    [SBU] VARCHAR(50) NULL,
    [LOB] VARCHAR(100) NULL,
    [Zone] VARCHAR(50) NULL,
    [Region] VARCHAR(50) NULL,
    [Location] VARCHAR(50) NULL,
    [AttendanceLoc] VARCHAR(100) NULL,
    [LocAddress] VARCHAR(5000) NULL,
    [PANNO] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.emp_info_20_02_2010
-- --------------------------------------------------
CREATE TABLE [dbo].[emp_info_20_02_2010]
(
    [Emp_no] VARCHAR(7) NULL,
    [Emp_name] VARCHAR(25) NULL,
    [email] VARCHAR(30) NULL,
    [status] VARCHAR(1) NULL,
    [Department] VARCHAR(20) NULL,
    [designation] VARCHAR(15) NULL,
    [Senior] VARCHAR(7) NULL,
    [Sr_name] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.exclude_cat_mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[exclude_cat_mapping]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXTRA_CAT_MAPPING
-- --------------------------------------------------
CREATE TABLE [dbo].[EXTRA_CAT_MAPPING]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXTRA_CAT_MAPPING_Harmony
-- --------------------------------------------------
CREATE TABLE [dbo].[EXTRA_CAT_MAPPING_Harmony]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXTRA_CAT_MAPPING_HARMONY_BKP_30_Jan_2026
-- --------------------------------------------------
CREATE TABLE [dbo].[EXTRA_CAT_MAPPING_HARMONY_BKP_30_Jan_2026]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.extra_cat_mapping_harmony_jul20
-- --------------------------------------------------
CREATE TABLE [dbo].[extra_cat_mapping_harmony_jul20]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.extra_cat_mapping_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[extra_cat_mapping_hist]
(
    [EMP_NO] VARCHAR(10) NOT NULL,
    [MENU_CODE] INT NOT NULL,
    [MAPPED_BY] VARCHAR(10) NULL,
    [MAPPED_ON] DATETIME NULL,
    [DELETED_BY] VARCHAR(10) NULL,
    [DELETED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.get_menu_Extra_option_24Mar2015
-- --------------------------------------------------
CREATE TABLE [dbo].[get_menu_Extra_option_24Mar2015]
(
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NOT NULL,
    [cat_name] VARCHAR(1) NOT NULL,
    [cat_code] VARCHAR(1) NOT NULL,
    [access_code] VARCHAR(1) NOT NULL,
    [userid] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Harmony_V_Enterprise_Master_Deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[Harmony_V_Enterprise_Master_Deleted]
(
    [EmpNo] VARCHAR(100) NULL,
    [access_code] VARCHAR(500) NULL,
    [Role] VARCHAR(200) NULL,
    [Accesslevel] VARCHAR(100) NULL,
    [Fkid_tbl_Application_master] INT NULL,
    [APPTYPE] INT NULL,
    [Fkid_EHelpLineDepartmentMST] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.heading
-- --------------------------------------------------
CREATE TABLE [dbo].[heading]
(
    [HEAD] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ISMS_data$
-- --------------------------------------------------
CREATE TABLE [dbo].[ISMS_data$]
(
    [emp_no] NVARCHAR(255) NULL,
    [EMP_Name] NVARCHAR(255) NULL,
    [Department] NVARCHAR(255) NULL,
    [sub_department] NVARCHAR(255) NULL,
    [Designation] NVARCHAR(255) NULL,
    [CostCode] NVARCHAR(255) NULL,
    [Head] NVARCHAR(255) NULL,
    [Sub_head] NVARCHAR(255) NULL,
    [Menu_name] NVARCHAR(255) NULL,
    [Active/Inactive User] NVARCHAR(255) NULL,
    [Last access date] NVARCHAR(255) NULL,
    [no# of time link access in 90 days] NVARCHAR(255) NULL,
    [linkactive] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.login_logs
-- --------------------------------------------------
CREATE TABLE [dbo].[login_logs]
(
    [report_path] VARCHAR(200) NULL,
    [userid] INT NULL,
    [username] VARCHAR(12) NULL,
    [IP_Add] VARCHAR(100) NULL,
    [Access_datetime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_cat
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_cat]
(
    [cat_code] INT IDENTITY(1,1) NOT NULL,
    [cat_name] VARCHAR(40) NULL,
    [active] VARCHAR(1) NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_cat_20052014
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_cat_20052014]
(
    [cat_code] INT IDENTITY(1,1) NOT NULL,
    [cat_name] VARCHAR(40) NULL,
    [active] VARCHAR(1) NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_item
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_item]
(
    [menu_code] INT IDENTITY(1,1) NOT NULL,
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_item_18052015
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_item_18052015]
(
    [menu_code] INT IDENTITY(1,1) NOT NULL,
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_item_20052014
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_item_20052014]
(
    [menu_code] INT IDENTITY(1,1) NOT NULL,
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_item_23082017
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_item_23082017]
(
    [menu_code] INT IDENTITY(1,1) NOT NULL,
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.menu_item_24042015
-- --------------------------------------------------
CREATE TABLE [dbo].[menu_item_24042015]
(
    [menu_code] INT IDENTITY(1,1) NOT NULL,
    [Head] VARCHAR(100) NULL,
    [Sub_Head] VARCHAR(100) NULL,
    [menu_name] VARCHAR(100) NULL,
    [menu_url] VARCHAR(250) NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MixedMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[MixedMaster]
(
    [Mixed_Mast_cd] VARCHAR(20) NULL,
    [Mixed_Mast_name] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(12) NULL,
    [CreatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MixedMaster_Grp
-- --------------------------------------------------
CREATE TABLE [dbo].[MixedMaster_Grp]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Mixed_Mast_cd] VARCHAR(20) NULL,
    [Mixed_type] VARCHAR(100) NULL,
    [Mixed_cd] VARCHAR(100) NULL,
    [Status] VARCHAR(1) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MixedMaster_Grp_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[MixedMaster_Grp_hist]
(
    [Id] INT NULL,
    [Mixed_Mast_cd] VARCHAR(20) NULL,
    [Mixed_type] VARCHAR(100) NULL,
    [Mixed_cd] VARCHAR(100) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Region
-- --------------------------------------------------
CREATE TABLE [dbo].[Region]
(
    [Code] VARCHAR(255) NULL,
    [Name] VARCHAR(255) NULL,
    [FRANCHISEE] VARCHAR(255) NULL,
    [REG_CODE] VARCHAR(255) NULL,
    [REGION] VARCHAR(255) NULL,
    [ADMIN] VARCHAR(255) NULL,
    [regioncode] VARCHAR(10) NULL,
    [nbranchcode] VARCHAR(10) NULL,
    [ctcl_region] VARCHAR(25) NULL,
    [Zone] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RegionMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[RegionMaster]
(
    [Region_Mast_cd] VARCHAR(20) NULL,
    [Region_Mast_name] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(12) NULL,
    [CreatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RegionMaster_Grp
-- --------------------------------------------------
CREATE TABLE [dbo].[RegionMaster_Grp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Region_Mast_cd] VARCHAR(20) NULL,
    [Region_cd] VARCHAR(100) NULL,
    [Status] VARCHAR(1) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RegionMaster_Grp_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[RegionMaster_Grp_hist]
(
    [id] INT NULL,
    [Region_Mast_cd] VARCHAR(20) NULL,
    [Region_cd] VARCHAR(100) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_CompRisk_Cli
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_CompRisk_Cli]
(
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL,
    [PROJ_MTM_PL] MONEY NULL,
    [GenDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_CompRisk_SB
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_CompRisk_SB]
(
    [CliProjRisk] MONEY NULL,
    [CliPureRisk] MONEY NULL,
    [sb_ledger] MONEY NULL,
    [sb_brokerage] MONEY NULL,
    [sb_cashcoll] MONEY NULL,
    [sb_noncashcoll] MONEY NULL,
    [SB_Total] MONEY NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [SBName] VARCHAR(100) NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_PureRisk] MONEY NULL DEFAULT ((0)),
    [PR_ProjRisk] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rpt_CompRisk_Branch
-- --------------------------------------------------
CREATE TABLE [dbo].[Rpt_CompRisk_Branch]
(
    [branch_code] CHAR(6) NULL,
    [branch] CHAR(40) NULL,
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rpt_CompRisk_Region
-- --------------------------------------------------
CREATE TABLE [dbo].[Rpt_CompRisk_Region]
(
    [regioncode] VARCHAR(10) NULL,
    [description] VARCHAR(50) NULL,
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rpt_CompRisk_Subbroker
-- --------------------------------------------------
CREATE TABLE [dbo].[Rpt_CompRisk_Subbroker]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_BRoker] VARCHAR(10) NULL,
    [sbname] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rpt_CompRisk_Zone
-- --------------------------------------------------
CREATE TABLE [dbo].[Rpt_CompRisk_Zone]
(
    [Zone] VARCHAR(25) NULL,
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SBMaster]
(
    [SB_Mast_cd] VARCHAR(20) NULL,
    [SB_Mast_name] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(12) NULL,
    [CreatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBMaster_Grp
-- --------------------------------------------------
CREATE TABLE [dbo].[SBMaster_Grp]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [SB_Mast_cd] VARCHAR(20) NULL,
    [SB_cd] VARCHAR(100) NULL,
    [Status] VARCHAR(1) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBMaster_Grp_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[SBMaster_Grp_hist]
(
    [Id] INT NULL,
    [SB_Mast_cd] VARCHAR(20) NULL,
    [SB_cd] VARCHAR(100) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.session_log
-- --------------------------------------------------
CREATE TABLE [dbo].[session_log]
(
    [SessionDate] DATETIME NULL,
    [sessionid] INT NULL,
    [sessionVariable] VARCHAR(25) NULL,
    [sessionValue] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_login
-- --------------------------------------------------
CREATE TABLE [dbo].[user_login]
(
    [userid] INT IDENTITY(1,1) NOT NULL,
    [person_name] VARCHAR(100) NULL,
    [username] VARCHAR(20) NULL,
    [userpassword] VARCHAR(20) NULL,
    [usertype] VARCHAR(50) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [cat_code] INT NULL,
    [status] INT NULL,
    [last_login] DATETIME NULL,
    [NoOfTry] INT NULL DEFAULT ((0)),
    [NoOfLogin] INT NULL DEFAULT ((0)),
    [login_Activated] DATETIME NULL,
    [login_inactive_date] DATETIME NULL,
    [active] VARCHAR(10) NULL,
    [email] VARCHAR(100) NULL,
    [IP] VARCHAR(300) NULL,
    [IP_active] VARCHAR(10) NULL,
    [Gateway] VARCHAR(50) NULL,
    [Gateway_active] VARCHAR(50) NULL,
    [session_id] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(100) NULL,
    [CreatedOn] VARCHAR(50) NULL,
    [LastModifiedBy] VARCHAR(50) NULL,
    [LastModifiedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.USER_LOGIN_08102012
-- --------------------------------------------------
CREATE TABLE [dbo].[USER_LOGIN_08102012]
(
    [userid] INT IDENTITY(1,1) NOT NULL,
    [person_name] VARCHAR(100) NULL,
    [username] VARCHAR(20) NULL,
    [userpassword] VARCHAR(20) NULL,
    [usertype] VARCHAR(50) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [cat_code] INT NULL,
    [status] INT NULL,
    [last_login] DATETIME NULL,
    [NoOfTry] INT NULL,
    [NoOfLogin] INT NULL,
    [login_Activated] DATETIME NULL,
    [login_inactive_date] DATETIME NULL,
    [active] VARCHAR(10) NULL,
    [email] VARCHAR(100) NULL,
    [IP] VARCHAR(100) NULL,
    [IP_active] VARCHAR(10) NULL,
    [Gateway] VARCHAR(50) NULL,
    [Gateway_active] VARCHAR(50) NULL,
    [session_id] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(100) NULL,
    [CreatedOn] VARCHAR(50) NULL,
    [LastModifiedBy] VARCHAR(50) NULL,
    [LastModifiedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.usER_LOGIN_17022016
-- --------------------------------------------------
CREATE TABLE [dbo].[usER_LOGIN_17022016]
(
    [userid] INT IDENTITY(1,1) NOT NULL,
    [person_name] VARCHAR(100) NULL,
    [username] VARCHAR(20) NULL,
    [userpassword] VARCHAR(20) NULL,
    [usertype] VARCHAR(50) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [cat_code] INT NULL,
    [status] INT NULL,
    [last_login] DATETIME NULL,
    [NoOfTry] INT NULL,
    [NoOfLogin] INT NULL,
    [login_Activated] DATETIME NULL,
    [login_inactive_date] DATETIME NULL,
    [active] VARCHAR(10) NULL,
    [email] VARCHAR(100) NULL,
    [IP] VARCHAR(300) NULL,
    [IP_active] VARCHAR(10) NULL,
    [Gateway] VARCHAR(50) NULL,
    [Gateway_active] VARCHAR(50) NULL,
    [session_id] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(100) NULL,
    [CreatedOn] VARCHAR(50) NULL,
    [LastModifiedBy] VARCHAR(50) NULL,
    [LastModifiedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_login_20052014
-- --------------------------------------------------
CREATE TABLE [dbo].[user_login_20052014]
(
    [userid] INT IDENTITY(1,1) NOT NULL,
    [person_name] VARCHAR(100) NULL,
    [username] VARCHAR(20) NULL,
    [userpassword] VARCHAR(20) NULL,
    [usertype] VARCHAR(50) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [cat_code] INT NULL,
    [status] INT NULL,
    [last_login] DATETIME NULL,
    [NoOfTry] INT NULL,
    [NoOfLogin] INT NULL,
    [login_Activated] DATETIME NULL,
    [login_inactive_date] DATETIME NULL,
    [active] VARCHAR(10) NULL,
    [email] VARCHAR(100) NULL,
    [IP] VARCHAR(100) NULL,
    [IP_active] VARCHAR(10) NULL,
    [Gateway] VARCHAR(50) NULL,
    [Gateway_active] VARCHAR(50) NULL,
    [session_id] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(100) NULL,
    [CreatedOn] VARCHAR(50) NULL,
    [LastModifiedBy] VARCHAR(50) NULL,
    [LastModifiedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_login_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[user_login_hist]
(
    [userid] INT NOT NULL,
    [person_name] VARCHAR(100) NULL,
    [username] VARCHAR(20) NULL,
    [userpassword] VARCHAR(20) NULL,
    [usertype] VARCHAR(50) NULL,
    [access_to] VARCHAR(50) NULL,
    [access_code] VARCHAR(50) NULL,
    [cat_code] INT NULL,
    [status] INT NULL,
    [last_login] DATETIME NULL,
    [NoOfTry] INT NULL,
    [NoOfLogin] INT NULL,
    [login_Activated] DATETIME NULL,
    [login_inactive_date] DATETIME NULL,
    [active] VARCHAR(10) NULL,
    [email] VARCHAR(100) NULL,
    [IP] VARCHAR(100) NULL,
    [IP_active] VARCHAR(10) NULL,
    [Gateway] VARCHAR(50) NULL,
    [Gateway_active] VARCHAR(50) NULL,
    [session_id] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(100) NULL,
    [CreatedOn] VARCHAR(50) NULL,
    [LastModifiedBy] VARCHAR(50) NULL,
    [LastModifiedOn] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.userlogin_mail
-- --------------------------------------------------
CREATE TABLE [dbo].[userlogin_mail]
(
    [Username] VARCHAR(100) NULL,
    [Person name] VARCHAR(100) NULL,
    [Access to] VARCHAR(100) NULL,
    [Access code] VARCHAR(100) NULL,
    [Date] VARCHAR(100) NULL,
    [Menu] VARCHAR(100) NULL,
    [No of Logins] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.userSBlogin_mail
-- --------------------------------------------------
CREATE TABLE [dbo].[userSBlogin_mail]
(
    [Username] VARCHAR(100) NULL,
    [Date] VARCHAR(100) NULL,
    [Menu] VARCHAR(100) NULL,
    [No of Logins] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V_Enterprise_Master_19042017
-- --------------------------------------------------
CREATE TABLE [dbo].[V_Enterprise_Master_19042017]
(
    [EmpNo] VARCHAR(100) NULL,
    [access_code] VARCHAR(500) NULL,
    [Role] VARCHAR(200) NULL,
    [Accesslevel] VARCHAR(100) NULL,
    [Fkid_tbl_Application_master] INT NULL,
    [APPTYPE] INT NULL,
    [Fkid_EHelpLineDepartmentMST] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ZoneMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[ZoneMaster]
(
    [Zone_Mast_cd] VARCHAR(20) NULL,
    [Zone_Mast_name] VARCHAR(100) NULL,
    [CreatedBy] VARCHAR(12) NULL,
    [CreatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ZoneMaster_Grp
-- --------------------------------------------------
CREATE TABLE [dbo].[ZoneMaster_Grp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Zone_Mast_cd] VARCHAR(20) NULL,
    [Zone_cd] VARCHAR(100) NULL,
    [Status] VARCHAR(1) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ZoneMaster_Grp_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ZoneMaster_Grp_hist]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Zone_Mast_cd] VARCHAR(20) NULL,
    [Zone_cd] VARCHAR(100) NULL,
    [MappedBy] VARCHAR(12) NULL,
    [MappedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.get_menu_Extra_option
-- --------------------------------------------------
CREATE view get_menu_Extra_option    
as    
select  distinct        
m.Head,m.Sub_Head,m.menu_name,m.menu_url,m.seq_no,m.active,menu_desc=isnull(m.menu_desc,'')      
,'' as cat_name,'' as cat_code,'' as access_code,d.userid          
from menu_item m     
left outer join EXTRA_CAT_MAPPING x on X.menu_code=m.menu_code    
inner join user_login d on X.EMP_NO=convert(varchar,d.userid)

GO

-- --------------------------------------------------
-- VIEW dbo.get_menu_Extra_option_harmony
-- --------------------------------------------------
CREATE VIEW GET_MENU_EXTRA_OPTION_HARMONY  
AS    

SELECT  DISTINCT M.HEAD, M.SUB_HEAD, M.MENU_NAME, M.MENU_URL, M.SEQ_NO, M.ACTIVE, 
		MENU_DESC=ISNULL(M.MENU_DESC,''), '' AS CAT_NAME, '' AS CAT_CODE, '' AS ACCESS_CODE, X.EMP_NO          
FROM	MENU_ITEM M 
		INNER JOIN EXTRA_CAT_MAPPING_HARMONY X ON X.MENU_CODE=M.MENU_CODE    
WHERE	M.ACTIVE = 'Y'

GO

-- --------------------------------------------------
-- VIEW dbo.get_menu_option
-- --------------------------------------------------
CREATE view [dbo].[get_menu_option]    
as    
   
select  distinct  
m.Head,m.Sub_Head,m.menu_name,m.menu_url,m.seq_no,m.active,menu_desc=isnull(m.menu_desc,'')
,b.cat_name,a.cat_code,d.access_Code,d.userid    
from menu_item m, cat_mapping a, menu_cat b, user_login d    
where a.cat_code=b.cat_Code and a.menu_Code=m.menu_code    
and a.cat_Code=d.cat_code and m.active='Y' and b.active='Y'

GO

-- --------------------------------------------------
-- VIEW dbo.get_menu_option_harmony
-- --------------------------------------------------
CREATE view get_menu_option_harmony    

as    

  
select  distinct        

m.Head,m.Sub_Head,m.menu_name,m.menu_url,m.seq_no,m.active,menu_desc=isnull(m.menu_desc,'')      

,b.cat_name,a.cat_code    

from menu_item m, cat_mapping_harmony a, menu_cat b        

where a.cat_code=b.cat_Code and a.menu_Code=m.menu_code          

and a.cat_Code in (1,2,3,4,5,397) and m.active='Y' and b.active='Y'

GO

-- --------------------------------------------------
-- VIEW dbo.TEST
-- --------------------------------------------------
CREATE VIEW TEST
as
select a=''

GO

-- --------------------------------------------------
-- VIEW dbo.V_SB_NonCash_deposit
-- --------------------------------------------------
CREATE view [dbo].[V_SB_NonCash_deposit]      
as      
select       
Branch_Code as [Branch Code],      
a.Sub_Broker as [Sub-Broker Code],      
SB_name as [Sub-Broker Name],      
Scrip_code as [Scrip Code],      
SCripName as [Scrip Name],      
convert(decimal(10,0),Qty) as [Quantity],      
convert(decimal(15,2),ClsRate) as [Closing Rate],      
convert(decimal(15,2),CurrHoldVal) as [Holding Value]      
from general.dbo.V_SB_CurrHoldValue a, general.dbo.BO_Subgroup b,       
(select bsecode,SCripName=max(SCripName) from general.dbo.scrip_master (nolock) group by bsecode)c       
where a.sub_Broker=b.sub_Broker and a.scrip_Code=c.bsecode

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessBrMast
-- --------------------------------------------------
Create View Vw_MixedAccessBrMast
as
select Mixed_Mast_cd,b.BRANCH from risk.dbo.Vw_MixedGrpMaster (nolock) a join 
(select Branch_mast_cd,Branch_cd as [Branch] from BranchMaster_Grp (nolock) where status='Y') b on a.BRMAST=b.Branch_mast_Cd

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessClient
-- --------------------------------------------------
CREATE view Vw_MixedAccessClient  
as  
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,ZONE from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.zone=b.zone  
union   
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,ZONE from risk.dbo.Vw_MixedAccessZnMast (nolock)) b on a.zone=b.zone  
union
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,REGION from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.REGION=b.REGION  
union
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,REGION from risk.dbo.Vw_MixedAccessRgMast (nolock)) b on a.REGION=b.REGION  
union   
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,BRANCH from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.BRANCH=b.BRANCH  
union   
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,BRANCH from risk.dbo.Vw_MixedAccessBrMast (nolock)) b on a.BRANCH=b.BRANCH
union
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,SB from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.SB=b.SB  
union
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,SB from risk.dbo.Vw_MixedAccessSbMast (nolock)) b on a.SB=b.SB     
union
select Mixed_Mast_cd,a.client from general.dbo.vw_rms_client_vertical(nolock) a join (select Mixed_Mast_cd,CLIENT from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.CLIENT=b.CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessRgMast
-- --------------------------------------------------
Create View Vw_MixedAccessRgMast
as
select Mixed_Mast_cd,b.region from risk.dbo.Vw_MixedGrpMaster (nolock) a join 
(select region_mast_cd,region_cd as [region] from RegionMaster_Grp (nolock) where status='Y') b on a.RGMAST=b.region_mast_Cd

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessSB
-- --------------------------------------------------
CREATE view Vw_MixedAccessSB
as    
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,ZONE from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.zone=b.zone    
union     
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,ZONE from risk.dbo.Vw_MixedAccessZnMast (nolock)) b on a.zone=b.zone    
union  
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,REGION from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.REGION=b.REGION    
union  
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,REGION from risk.dbo.Vw_MixedAccessRgMast (nolock)) b on a.REGION=b.REGION    
union     
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,BRANCH from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.BRANCH=b.BRANCH    
union     
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,BRANCH from risk.dbo.Vw_MixedAccessBrMast (nolock)) b on a.BRANCH=b.BRANCH  
union  
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,SB from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.SB=b.SB    
union  
select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,SB from risk.dbo.Vw_MixedAccessSbMast (nolock)) b on a.SB=b.SB       
/*union  select distinct Mixed_Mast_cd,a.sb from general.dbo.vw_rms_sb_vertical(nolock) a join (select Mixed_Mast_cd,CLIENT from risk.dbo.Vw_MixedGrpMaster (nolock)) b on a.CLIENT=b.CLIENT   */

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessSbMast
-- --------------------------------------------------
Create View Vw_MixedAccessSbMast
as
select Mixed_Mast_cd,b.sb from risk.dbo.Vw_MixedGrpMaster (nolock) a join 
(select sb_mast_cd,sb_cd as [sb] from SBMaster_Grp (nolock) where status='Y') b on a.sbMAST=b.sb_mast_Cd

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedAccessZnMast
-- --------------------------------------------------
Create View Vw_MixedAccessZnMast
as
select Mixed_Mast_cd,b.Zone from risk.dbo.Vw_MixedGrpMaster (nolock) a join 
(select Zone_mast_cd,Zone_cd as [Zone] from ZoneMaster_Grp (nolock) where status='Y') b on a.ZnMAST=b.Zone_mast_Cd

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MixedGrpMaster
-- --------------------------------------------------
CREATE View Vw_MixedGrpMaster
as
select 
mixed_Mast_cd,
ZONE=max(case when mixed_type='ZONE' then Mixed_cd else '' end),
ZNMAST=max(case when mixed_type='ZNMAST' then Mixed_cd else '' end),
REGION=max(case when mixed_type='REGION' then Mixed_cd else '' end),
RGMAST=max(case when mixed_type='RGMAST' then Mixed_cd else '' end),
BRANCH=max(case when mixed_type='BRANCH' then Mixed_cd else '' end),
BRMAST=max(case when mixed_type='BRMAST' then Mixed_cd else '' end),
SB=max(case when mixed_type='SB' then Mixed_cd else '' end),
SBMAST=max(case when mixed_type='SBMAST' then Mixed_cd else '' end),
SBGRP=max(case when mixed_type='SBGRP' then Mixed_cd else '' end),
CLGRP=max(case when mixed_type='CLGRP' then Mixed_cd else '' end),
FAMILY=max(case when mixed_type='FAMILY' then Mixed_cd else '' end),
CLIENT=max(case when mixed_type='CLIENT' then Mixed_cd else '' end)
from risk.dbo.mixedMAster_grp (nolock) where status='Y' group by mixed_Mast_cd

GO

-- --------------------------------------------------
-- VIEW dbo.vw_region
-- --------------------------------------------------
CREATE view vw_region  
as        
/*reg_code is changed to region_code to solve level error by unnati on 20 april 2010*/      
select branch_code=a.code,Region_code=reg_code     
from region a (nolock)

GO

