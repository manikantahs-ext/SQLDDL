-- DDL Export
-- Server: 10.253.33.89
-- Database: Account_Rent
-- Exported: 2026-02-05T02:38:27.098245

USE Account_Rent;
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
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.LeaseEntry
-- --------------------------------------------------
ALTER TABLE [dbo].[LeaseEntry] ADD CONSTRAINT [PK_LeaseEntry] PRIMARY KEY ([lno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B6107C12930] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

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
-- PROCEDURE dbo.SPUpdateLeaseEntry
-- --------------------------------------------------
CREATE proc SPUpdateLeaseEntry              
@lno int,               
@AgrDate varchar(100),              
@CmtDate varchar(100),              
@Expdate varchar(100),               
@Company varchar(50),               
@OrgDocs varchar(50),               
@XeroxDocs varchar(50),               
@Reg varchar(50),               
@Branch varchar(50),               
@IRent numeric(18,0),               
@DepMoney varchar(50),               
@AreaDocs varchar(50),               
@AreaType varchar(50),      
@AreaSite varchar(50),              
@Loc varchar(50),              
@Add1 varchar(50),               
@Add2 varchar(50),               
@Add3 varchar(50),               
@City varchar(25),               
@Pin varchar(50),               
@State varchar(50),               
@PeriodY varchar(50),              
@PeriodM varchar(50),               
@Remark varchar(100),              
@Status varchar(15),        
@StatusDate Varchar(20),  
@lock varchar(50),
@notice varchar(50)         
as              
--print @AgrDate        
begin            
update tbl_LeaseEntry set                
agr_dt = convert(datetime,@AgrDate,103),               
cmt_dt = convert(datetime,@CmtDate,103),              
exp_dt = convert(datetime,@Expdate,103),        
         
company = @Company,              
orig_docs = @OrgDocs,              
xerox_docs = @XeroxDocs,               
region = @Reg,               
branch = @Branch,               
ini_rent = @irent,               
deposit_money = @DepMoney,               
area_docs = @AreaDocs,        
area_type=@AreaType,           
area_site = @AreaSite,               
location = @Loc,               
add1= @Add1,               
add2 = @Add2,              
add3 = @Add3,              
city= @City,               
pin = @Pin,               
state = @State,               
period_years = @PeriodY,               
period_months = @PeriodM,               
remark = @Remark,        
status = @status,        
status_date = convert(datetime,@StatusDate,103),  
lock_period=@lock,
notice_period=@notice       
where lno=@lno       
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_agr_report
-- --------------------------------------------------
CREATE proc usp_agr_report          
(@type as varchar(50),@access_Code as Varchar(20),@access_to as varchar(20))          
as          
if(@type='AGREEMENT ENTRY')          
begin          
            
select[Agreement No]=lno,[Entry Date]=convert(varchar(11),entry_dt,103),[Agreement Date]=convert(varchar(11),agr_dt,103),      
[Start Date]=convert(varchar(11),cmt_dt,103),[Exp Date]=convert(varchar(11),exp_dt,103),
company=CASE WHEN company='ACDLCM'THEN 'NSECM' 
WHEN company='ACDLFO'THEN 'NSEFO'ELSE company END,orig_docs,xerox_docs,region,      
branch,ini_rent,deposit_money,area_docs,area_type,area_site,location,add1,add2,add3,city,pin,state,period_years,period_months,remark,user_id,status,Status_Date,lock_period,notice_period      
from  tbl_leaseentry         
end          
else if(@type='LICENSOR')          
begin          
select[Agreement No]=lno,[Sub No]=fld_subno,[Name]=fld_name,[Address]=fld_address,[Agr Type]=fld_agrtype,[Nature]=fld_nature,[GL Code]=fld_glcode,      
[Rent Amount]=fld_rentamt,[Dep Code]=fld_depcode,[Dep Amount]=fld_depamt,[Pan No]=fld_pan,[ST No]=fld_stno,Status=fld_status,  
[Inactive Date]=convert(varchar(11),fld_status_date,103),[Inactive Amt]=fld_depamt_inactive from tbl_licensor_details          
      
end          
else if(@type='AGREEMENT DETAILS')          
begin          
select [Agreement No]=lno,[Change No]=cno,[From Date]=convert(varchar(11),fdt,103),[To Date]=convert(varchar(11),tdt,103),[Change By]=chageby,Change,Amount,userid,[Entry Date]=convert(varchar(11),entrydate,103)    
from  tbl_agreementdetails      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findinJobs
-- --------------------------------------------------


Create Procedure usp_findinJobs(@Str as varchar(500))  
as  
select b.name,  
Case when b.enabled=1 then 'Active' else 'Deactive' end as Status,  
date_created,date_modified,a.step_id,a.step_name,a.command  
from msdb.dbo.sysjobsteps a, msdb.dbo.sysjobs b  
where command like '%'+@Str+'%'  
and a.job_id=b.job_id

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
-- PROCEDURE dbo.USP_getLeaseEntry
-- --------------------------------------------------
CREATE proc USP_getLeaseEntry(@LNO as varchar(10))          
as          
select entry_dt,agr_dt,cmt_dt,exp_dt,company,--=CASE WHEN COMPANY='ACDLCM'THEN'NSECM'
 --WHEN COMPANY='ACDLFO'THEN'NSEFO'ELSE COMPANY END,
orig_docs,          
xerox_docs,region,branch,ini_rent,deposit_money,area_docs,area_type,area_site,          
location,add1,add2,add3,city,pin,state,period_years,period_months,remark,user_id,status, isnull(Status_Date,'')Status_Date,lock_period,notice_period          
 from tbl_leaseentry (nolock) where lno=@LNO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETYEAR
-- --------------------------------------------------
CREATE PROC USP_GETYEAR
AS
BEGIN
 DECLARE @YEAR INT,@FDATE DATETIME
 DECLARE @TABLE TABLE
 (
 YEAR INT
 )

 SET @FDATE='2001-01-01 00:00:00.000'
 SET @YEAR=YEAR(@FDATE)  
    
 WHILE (@YEAR <=YEAR(GETDATE()))  
	 BEGIN                          

		INSERT INTO @TABLE 
		SELECT @YEAR
	                    
		SET @YEAR = @YEAR + 1                          
	                       
	 END     
 
 SELECT YEAR FROM @TABLE

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_licensor_details
-- --------------------------------------------------
CREATE proc usp_licensor_details        
@action varchar(20),          
@lno int,        
@subno varchar,        
@name varchar(50),        
@address varchar(200),    
@agrtype varchar(50),  
@nature varchar(50),  
@glcode numeric,        
@rentamt numeric,        
@depcode varchar(50),        
@depamt numeric,        
@pan varchar(50),        
@stno varchar(50),  
@status varchar(10)         
as        
if(@action='insert')    
begin        
insert into tbl_licensor_details values(@lno,@subno,@name,@address,@agrtype,@nature,@glcode,@rentamt,@depcode,@depamt,@pan,@stno,'ACTIVE','','0.00')        
end     
else if(@action='update')    
begin    
update tbl_licensor_details set     
fld_name=@name,    
fld_address=@address,  
fld_agrtype=@agrtype,  
fld_nature=@nature,  
fld_glcode=@glcode,    
fld_rentamt=@rentamt,    
fld_depcode=@depcode,    
fld_depamt=@depamt,    
fld_pan=@pan,    
fld_stno=@stno,
fld_status=@status where lno=@lno and fld_subno=@subno    
if (@status='INACTIVE')
BEGIN
update tbl_licensor_details set fld_status_date=getdate(),fld_depamt_inactive=@depamt,fld_depamt='0.00'
where lno=@lno and fld_subno=@subno    

END
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_max_agreement
-- --------------------------------------------------
CREATE procedure usp_max_agreement  
@lno varchar(50)  
as  
declare @maxcno as int  
declare @maxsrno as int  
select @maxcno= max(cno) from tbl_AgreementDetails where lno=@lno  
select @maxsrno=max(srno) from tbl_AgreementDetails where lno=@lno and cno=@maxcno  
select cno=cno+1,amount from tbl_AgreementDetails(nolock)where srno=@maxsrno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_lease
-- --------------------------------------------------
CREATE PROCEDURE  usp_mis_lease        
 ( @fdt as varchar(25),@tdt as varchar(25),@type as int,@segment as varchar(25),@region varchar(25),@branch varchar(25),@access_Code as Varchar(20),@access_to as varchar(20))                    
 as            
declare @str as varchar(8000)                   
                
if @type=1                
begin        
set @str='      
select * into #file1 from tbl_leaseentry where cmt_dt>=convert(datetime,'''+@fdt+''',103) and cmt_dt<=convert(datetime,'''+@tdt+''',103) and  company like '''+@segment+'''        
and region like '''+@region+''' and branch like '''+@branch+'''      
        
select[Agreement No]=''<a href=''''report.aspx?reportno=292&agno=''+convert(varchar(4),lno)+''&access_to='+@access_to+'&access_code='+@access_code+'''''>''+convert(varchar(4),lno)+''</a>'',          
[Start Date]=convert(varchar(11),cmt_dt,103),[Exp Date]=convert(varchar(11),exp_dt,103),
company=CASE WHEN company=''ACDLCM''THEN ''NSECM'' 
WHEN company=''ACDLFO''THEN ''NSEFO''ELSE company END,region,          
branch,ini_rent,deposit_money,area_docs,area_type,area_site,location,period_years,period_months,remark,status,lock_period,notice_period          
from #file1 order by lno'                   
exec (@str)   
end                  
 ----------------------------------------------------------------------       
if @type=2              
begin       
select lno into #file2 from tbl_leaseentry where  company like @segment and region like @region 
and branch like @branch      
  
select agrno,subno,[Change No],[From Date],[To Date],[Change By],Change,Amount into #file3 from V_agrdetails     
where convert(datetime,[from date],103)>=convert(datetime,@fdt,103) and convert(datetime,[from date],103)<=convert(datetime,@tdt,103) and agrno in(select lno from #file2)order by agrno    
  
select a.*,[Name]=b.fld_name,[GL Code]=b.fld_glcode,b.region,b.branch,
company=CASE WHEN c.company='ACDLCM'THEN 'NSECM' 
WHEN c.company='ACDLFO'THEN 'NSEFO'ELSE c.company END
from #file3 a  
inner join  
(select * from V_licensor_details)b  
on a.agrno=b.lno and a.subno=b.fld_subno  
inner join     
(select lno,company from tbl_leaseentry)c  
on a.agrno=c.lno order by a.agrno         
end        
----------------------------------------------------------------------------       
if @type=3        
begin        
Select * into #file4 from tbl_leaseentry where exp_dt>=convert(datetime,@fdt,103)and exp_dt<=convert(datetime,@tdt,103)        
and  company like @segment and region like @region and branch like @branch      
select[Agreement No]=lno,[Start Date]=convert(varchar(11),cmt_dt,103),[Exp Date]=convert(varchar(11),exp_dt,103),
company=CASE WHEN company='ACDLCM'THEN 'NSECM' 
WHEN company='ACDLFO'THEN 'NSEFO'ELSE company END,region,            
branch,ini_rent,deposit_money,area_docs,area_type,area_site,location,period_years,period_months,remark,status,lock_period,notice_period            
from #file4 order by lno                  
end        
        
--print(@str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_lease_range
-- --------------------------------------------------
CREATE PROCEDURE  usp_mis_lease_range            
( @fdt as varchar(25),    
@tdt as varchar(25),    
@type as int,    
@segment as varchar(25),    
@region varchar(25),    
@branch varchar(25),    
@from varchar(20),    
@to varchar(20),      
@access_Code as Varchar(20),    
@access_to as varchar(20))    
                      
as                
declare @str as varchar(8000)                       
           
if @type=4  
begin  
set @str='   
select a.lno,b.subno,[Name]=c.fld_name,b.[change no],b.amount,  
[GL Code]=c.fld_glcode,company=CASE WHEN a.company=''ACDLCM''THEN ''NSECM'' 
WHEN a.company=''ACDLFO''THEN ''NSEFO''ELSE a.company END,
a.region,a.branch --into #file1  
from tbl_leaseentry(nolock)a   
inner join  
(select * from V_agrdetails)b on  
a.cmt_dt>=convert(datetime,'''+@fdt+''',103) and a.cmt_dt<=convert(datetime,'''+@tdt+''',103) and  a.company like '''+@segment+'''            
and region like '''+@region+''' and branch like '''+@branch+'''and b.amount>=convert(numeric(18,2),'''+@from+''')and b.amount<=convert(numeric(18,2),'''+@to+''')and a.lno=b.agrno  
and b.[change no]in (select cno from V_agrdetails_lastchange where lno=convert(varchar,b.agrno)+convert(varchar,b.subno))  
inner join  
(select * from V_licensor_details)c  
on a.lno=c.lno       
order by a.lno'  
--select[Agreement No]=''<a href=''''report.aspx?reportno=292&agno=''+convert(varchar(4),lno)+''&access_to='+@access_to+'&access_code='+@access_code+'''''>''+convert(varchar(4),lno)+''</a>'',              
--subno,Name,[change no],amount,[GL Code],company,region,branch from #file1  
end     
---------------------------------------------  
if @type=5  
begin   
set @str='          
select * into #file2 from tbl_leaseentry where cmt_dt>=convert(datetime,'''+@fdt+''',103) and cmt_dt<=convert(datetime,'''+@tdt+''',103) and  company like '''+@segment+'''            
and region like '''+@region+''' and branch like '''+@branch+'''and deposit_money>=convert(numeric(18,2),'''+@from+''')and deposit_money<=convert(numeric(18,2),'''+@to+''')            
  
select [Agreement No]=''<a href=''''report.aspx?reportno=292&agno=''+convert(varchar(4),lno)+''&access_to='+@access_to+'&access_code='+@access_code+'''''>''+convert(varchar(4),lno)+''</a>'',              
[Start Date]=convert(varchar(11),cmt_dt,103),[Exp Date]=convert(varchar(11),exp_dt,103),
company=CASE WHEN company=''ACDLCM''THEN ''NSECM'' 
WHEN company=''ACDLFO''THEN ''NSEFO''ELSE company END,region,              
branch,ini_rent,deposit_money,area_docs,area_type,area_site,location,period_years,
period_months,remark,status,lock_period,notice_period  
from #file2 order by lno '        
end    
---------------------------------------------    
if @type=6                    
begin            
set @str='          
select * into #file3 from tbl_leaseentry where cmt_dt>=convert(datetime,'''+@fdt+''',103) and cmt_dt<=convert(datetime,'''+@tdt+''',103) and  company like '''+@segment+'''            
and region like '''+@region+''' and branch like '''+@branch+'''and area_site>=convert(numeric(18,2),'''+@from+''')and area_site<=convert(numeric(18,2),'''+@to+''')            
            
select[Agreement No]=''<a href=''''report.aspx?reportno=292&agno=''+convert(varchar(4),lno)+''&access_to='+@access_to+'&access_code='+@access_code+'''''>''+convert(varchar(4),lno)+''</a>'',              
[Start Date]=convert(varchar(11),cmt_dt,103),[Exp Date]=convert(varchar(11),exp_dt,103),
company=CASE WHEN company=''ACDLCM''THEN ''NSECM'' 
WHEN company=''ACDLFO''THEN ''NSEFO''ELSE company END,region,              
branch,ini_rent,deposit_money,area_docs,area_type,area_site,location,period_years,
period_months,remark,status,lock_period,notice_period              
from #file3 order by lno'                       
  
end      
-----------------------------------------------   
exec (@str)       
--print @str

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_licensor
-- --------------------------------------------------



CREATE proc usp_mis_licensor
(@agno as varchar(10),@access_to as varchar(20),@access_Code as Varchar(20))        
as
select[Agreement No]=lno,[Sub No]=fld_subno,[Name]=fld_name,[Address]=fld_address,[Agr Type]=fld_agrtype,[Nature]=fld_nature,[GL Code]=fld_glcode,    
[Rent Amount]=fld_rentamt,[Dep Code]=fld_depcode,[Dep Amount]=fld_depamt,[Pan No]=fld_pan,[ST No]=fld_stno from tbl_licensor_details(nolock) where lno=@agno



--select * from tbl_report where rpt_srno=292
--update tbl_report set rpt_username='inhouse',rpt_pswd='inh6014'where rpt_srno=292

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mis_rent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_mis_rent]      
(@search_param as varchar(50),@type as varchar(1))      
 as               
set nocount on               
set transaction isolation level read uncommitted                        
              
if @type=1      
begin      
select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status from leaseentry (nolock) where lno=@search_param and status='ACTIVE'    
end         
if @type=2      
begin      
      
 select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status from leaseentry (nolock) where licensor_name like @search_param and status='ACTIVE'     
end      
      
if @type=3      
begin      
      
 select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status  from leaseentry (nolock) where branch=@search_param and status='ACTIVE'        
end      
      
if @type=4      
begin      
      
 select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status  from leaseentry (nolock) where company=@search_param and status='ACTIVE'        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MIS_Rent_periodwise
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MIS_Rent_periodwise]      
 ( @fdt as datetime,@tdt as datetime,@type as int)          
 as               
set nocount on               
set transaction isolation level read uncommitted                        
      
if @type=1      
begin      
select * into #file1 from agreementdetails where tdt>=@fdt and tdt<=@tdt   
          
select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status from leaseentry (nolock) where lno in (select lno from #file1)        
end        
if @type=2      
begin      
      
select lno into #file2 from leaseentry where exp_dt>=@fdt and exp_dt<=@tdt      
      
select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],        
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,        
Branch,ini_rent [Initial Rent],deposit_money [Deposit Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],        
period_months [Period in Months],contact_no [Contact No.],Remark,Status from leaseentry (nolock) where lno in (select lno from #file2)        
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_monthly_rent
-- --------------------------------------------------
CREATE proc usp_monthly_rent        
@month varchar(20),        
@year varchar(20),      
@userid varchar(20)        
as        
begin        
declare @totaldays as varchar(20)         
declare @firstdt as varchar(20)         
declare @lastdt as varchar(20)          
set @totaldays= day(dateadd(d, -1, dateadd(m, 1, convert(datetime,@month +'/01/' +@year))))             
--select @totaldays        
set @firstdt='01/'+@month+'/'+@year        
set @lastdt=@totaldays+'/'+@month+'/'+@year        
--select @firstdt        
--select @lastdt        
truncate table tbl_monthly_rent      
  
select lno into #activeentry from tbl_leaseentry(nolock)where status='ACTIVE'  
select lnosub=convert(varchar,lno)+fld_subno into #activelicensor from tbl_licensor_details(nolock)where fld_status='ACTIVE'  
     
select * into #file from V_agrdetails where         
convert(datetime,[from date],103)<=convert(datetime,@firstdt,103)and convert(datetime,[to date],103)>=convert(datetime,@lastdt,103)   
and agrno in(select lno from #activeentry)and convert(varchar,agrno)+subno in(select lnosub from #activelicensor)  
insert into tbl_monthly_rent        
select lno=convert(varchar,agrno)+convert(varchar,subno),days=@totaldays,amount,month=@month,year=@year from #file        
      
---------------------------------------------------------------      
select * into #fileex       
from tbl_licensor_details(nolock)where lno in(select lno from tbl_leaseentry(nolock)where exp_dt>= convert(datetime,@firstdt,103)and exp_dt<=convert(datetime,@lastdt,103))   
and lno in(select lno from #activeentry)and convert(varchar,lno)+fld_subno in(select lnosub from #activelicensor)  
and convert(varchar,lno)+fld_subno not in (select lno from tbl_monthly_rent)      
      
select * into #fileex1       
from V_agrdetails_lastchange where lno in(select convert(varchar(10),lno)+fld_subno from #fileex)      
      
      
insert into tbl_monthly_rent      
select lno,days=day(tdt),amount=convert(numeric(10,2),(amount/@totaldays)*day(tdt)),month=@month,year=@year      
from #fileex1      
      
--------------------------------------------------------------------      
      
select * into #filestart from tbl_licensor_details(nolock)where lno in(select lno from tbl_leaseentry(nolock)where cmt_dt>= convert(datetime,@firstdt,103)      
and cmt_dt<=convert(datetime,@lastdt,103))and lno in(select lno from #activeentry)and convert(varchar,lno)+fld_subno in(select lnosub from #activelicensor)  
and convert(varchar,lno)+fld_subno not in (select lno from tbl_monthly_rent)      
      
select * into #filestart1 from tbl_agreementdetails where lno in(select convert(varchar(10),lno)+fld_subno from #filestart)      
and fdt>=convert(datetime,@firstdt,103)and fdt<=convert(datetime,@lastdt,103)      
      
insert into tbl_monthly_rent      
select lno,days=day(convert(datetime,@lastdt,103)-fdt),amount=convert(numeric(10,2),(amount/@totaldays)*day(convert(datetime,@lastdt,103)-fdt)),month=@month,year=@year from #filestart1      
      
------------------------------------------------------------------------      
      
select * into #filechange      
from tbl_agreementdetails where fdt>=convert(datetime,@firstdt,103)and fdt<=convert(datetime,@lastdt,103)   
and convert(numeric,ltrim(rtrim(replace(lno,substring(lno,len(lno),len(lno)),'')))) in(select lno from #activeentry)  
and lno in(select lnosub from #activelicensor)and lno not in (select lno from tbl_monthly_rent)and cno>1      
      
select lno,days=day(convert(datetime,@lastdt,103)-fdt),amount=amount/@totaldays*day(convert(datetime,@lastdt,103)-fdt),month=@month,year=@year into #filechange1       
from #filechange      
      
select a.* into #filechange2 from tbl_agreementdetails a    
inner join    
#filechange b    
on a.lno=b.lno and a.cno=b.cno-1     
    
insert into #filechange1      
select lno,days=day(tdt-convert(datetime,@firstdt,103)),amount=amount/@totaldays*day(tdt-convert(datetime,@firstdt,103)),month=@month,year=@year      
from #filechange2      
insert into tbl_monthly_rent      
select lno,days=sum(days),amount=sum(amount),month,year from #filechange1 group by lno,month,year      
      
-------------------------------------------------------------------------      
insert into tbl_monthly_rent_final select lno,days,amount,month,year from tbl_monthly_rent      
insert into tbl_rentmaster select distinct month, year,@userid,getdate()from tbl_monthly_rent      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_monthly_rent_revoke
-- --------------------------------------------------
CREATE proc usp_monthly_rent_revoke         
@month varchar(20),          
@year varchar(20),        
@userid varchar(20)          
as          
begin          
declare @totaldays as varchar(20)           
declare @firstdt as varchar(20)           
declare @lastdt as varchar(20)            
set @totaldays= day(dateadd(d, -1, dateadd(m, 1, convert(datetime,@month +'/01/' +@year))))               
--select @totaldays          
set @firstdt='01/'+@month+'/'+@year          
set @lastdt=@totaldays+'/'+@month+'/'+@year          
--select @firstdt          
--select @lastdt   

insert into tbl_rentmaster_log 
select month,year,generatedby,date from tbl_rentmaster where month=@month and year=@year
  
delete from  tbl_monthly_rent_final where month=@month and year=@year  
delete from  tbl_rentmaster where month=@month and year=@year  
truncate table tbl_monthly_rent        
    
select lno into #activeentry from tbl_leaseentry(nolock)where status='ACTIVE'    
select lnosub=convert(varchar,lno)+fld_subno into #activelicensor from tbl_licensor_details(nolock)where fld_status='ACTIVE'    
       
select * into #file from V_agrdetails where           
convert(datetime,[from date],103)<=convert(datetime,@firstdt,103)and convert(datetime,[to date],103)>=convert(datetime,@lastdt,103)     
and agrno in(select lno from #activeentry)and convert(varchar,agrno)+subno in(select lnosub from #activelicensor)    
insert into tbl_monthly_rent          
select lno=convert(varchar,agrno)+convert(varchar,subno),days=@totaldays,amount,month=@month,year=@year from #file          
        
---------------------------------------------------------------        
select * into #fileex         
from tbl_licensor_details(nolock)where lno in(select lno from tbl_leaseentry(nolock)where exp_dt>= convert(datetime,@firstdt,103)and exp_dt<=convert(datetime,@lastdt,103))     
and lno in(select lno from #activeentry)and convert(varchar,lno)+fld_subno in(select lnosub from #activelicensor)    
and convert(varchar,lno)+fld_subno not in (select lno from tbl_monthly_rent)        
        
select * into #fileex1         
from V_agrdetails_lastchange where lno in(select convert(varchar(10),lno)+fld_subno from #fileex)        
        
        
insert into tbl_monthly_rent        
select lno,days=day(tdt),amount=convert(numeric(10,2),(amount/@totaldays)*day(tdt)),month=@month,year=@year        
from #fileex1        
        
--------------------------------------------------------------------        
        
select * into #filestart from tbl_licensor_details(nolock)where lno in(select lno from tbl_leaseentry(nolock)where cmt_dt>= convert(datetime,@firstdt,103)        
and cmt_dt<=convert(datetime,@lastdt,103))and lno in(select lno from #activeentry)and convert(varchar,lno)+fld_subno in(select lnosub from #activelicensor)    
and convert(varchar,lno)+fld_subno not in (select lno from tbl_monthly_rent)        
        
select * into #filestart1 from tbl_agreementdetails where lno in(select convert(varchar(10),lno)+fld_subno from #filestart)        
and fdt>=convert(datetime,@firstdt,103)and fdt<=convert(datetime,@lastdt,103)        
        
insert into tbl_monthly_rent        
select lno,days=day(convert(datetime,@lastdt,103)-fdt),amount=convert(numeric(10,2),(amount/@totaldays)*day(convert(datetime,@lastdt,103)-fdt)),month=@month,year=@year from #filestart1        
        
------------------------------------------------------------------------        
        
select * into #filechange        
from tbl_agreementdetails where fdt>=convert(datetime,@firstdt,103)and fdt<=convert(datetime,@lastdt,103)     
and convert(numeric,ltrim(rtrim(replace(lno,substring(lno,len(lno),len(lno)),'')))) in(select lno from #activeentry)    
and lno in(select lnosub from #activelicensor)and lno not in (select lno from tbl_monthly_rent)and cno>1        
        
select lno,days=day(convert(datetime,@lastdt,103)-fdt),amount=amount/@totaldays*day(convert(datetime,@lastdt,103)-fdt),month=@month,year=@year into #filechange1         
from #filechange        
        
select a.* into #filechange2 from tbl_agreementdetails a      
inner join      
#filechange b      
on a.lno=b.lno and a.cno=b.cno-1       
      
insert into #filechange1        
select lno,days=day(tdt-convert(datetime,@firstdt,103)),amount=amount/@totaldays*day(tdt-convert(datetime,@firstdt,103)),month=@month,year=@year        
from #filechange2        
insert into tbl_monthly_rent        
select lno,days=sum(days),amount=sum(amount),month,year from #filechange1 group by lno,month,year        
        
-------------------------------------------------------------------------        
insert into tbl_monthly_rent_final select lno,days,amount,month,year from tbl_monthly_rent        
insert into tbl_rentmaster select distinct month, year,@userid,getdate()from tbl_monthly_rent        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_monthlyrent_rpt
-- --------------------------------------------------
  
CREATE proc usp_monthlyrent_rpt    
(@mm as varchar(5),@yy as varchar(10),@access_Code as Varchar(20),@access_to as varchar(20))    
as    
begin     
select a.lno,b.fld_name,a.days,a.amount,a.month,a.year,c.company,b.fld_glcode,b.branch into #file from tbl_monthly_rent_final(nolock)a  
inner join V_licensor_details b  
on a.month=@mm and a.year=@yy and  
convert(numeric,ltrim(rtrim(replace(a.lno,substring(a.lno,len(a.lno),len(a.lno)),''))))=b.lno and  
substring(a.lno,len(a.lno),len(a.lno))=b.fld_subno  
inner join tbl_leaseentry c  
on convert(numeric,ltrim(rtrim(replace(a.lno,substring(a.lno,len(a.lno),len(a.lno)),''))))=c.lno   
  
select a.Lno,Company=CASE WHEN a.company='ACDLCM'THEN 'NSECM' 
WHEN a.company='ACDLFO'THEN 'NSEFO'ELSE a.company END,
Name=a.fld_name,[GL Code]=a.fld_glcode,a.Branch,a.Amount,b.Month,a.Year,Days from #file a  
inner join tbl_month b  
on a.month=b.srno  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_prevamt
-- --------------------------------------------------
CREATE proc usp_prevamt
@no as bigint
as
begin
select * into #file1 from tbl_agreementdetails(nolock)where srno=@no

select amount from tbl_agreementdetails(nolock)where cno in 
(select cno=case when cno>1 then cno-1 else cno end from #file1 ) and lno in ((select lno from #file1 ) )

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_rentchange_alert
-- --------------------------------------------------
CREATE PROCEDURE usp_rentchange_alert         
           
 as             
set nocount on             
set transaction isolation level read uncommitted                      
            
select * into #file1 from agreementdetails where tdt<=getdate()+ 30      
      
      
select lno [Agr No.],licensor_name [Licensor Name],pan_no [Pan No.],st_no [ST. No.],convert(varchar(11),agr_dt,103) [Agreement Date],convert(varchar(11),cmt_dt,103)[Commencement Date],      
convert(varchar(11),exp_dt,103)[Expiry Date],Company,Region,      
Branch,ini_rent [Initial Rent],deposit_money [Deposite Amount],deposite_code [Deposit Code],Gl_code,Location,Add1,Add2,Add3,City,Pin,State,Period_years [Period in years],      
period_months [Period in Months],contact_no [Contact No.],Remark,Status from leaseentry (nolock) where lno in (select lno from #file1)

GO

-- --------------------------------------------------
-- TABLE dbo.AgreementDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[AgreementDetails]
(
    [lno] VARCHAR(50) NULL,
    [cno] NUMERIC(18, 0) NULL,
    [fdt] DATETIME NULL,
    [tdt] DATETIME NULL,
    [chageby] VARCHAR(50) NULL,
    [change] NUMERIC(18, 2) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [userid] VARCHAR(50) NULL,
    [entrydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LeaseEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[LeaseEntry]
(
    [lno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [licensor_name] VARCHAR(60) NULL,
    [pan_no] VARCHAR(15) NULL,
    [st_no] VARCHAR(15) NULL,
    [entry_dt] DATETIME NULL,
    [agr_dt] DATETIME NULL,
    [cmt_dt] DATETIME NULL,
    [exp_dt] DATETIME NULL,
    [company] VARCHAR(50) NULL,
    [orig_docs] VARCHAR(50) NULL,
    [xerox_docs] VARCHAR(50) NULL,
    [region] VARCHAR(50) NULL,
    [branch] VARCHAR(50) NULL,
    [ini_rent] NUMERIC(30, 2) NULL,
    [deposit_money] VARCHAR(50) NULL,
    [deposite_code] VARCHAR(20) NULL,
    [gl_code] NUMERIC(30, 0) NULL,
    [area_docs] VARCHAR(50) NULL,
    [area_site] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [add1] VARCHAR(50) NULL,
    [add2] VARCHAR(50) NULL,
    [add3] VARCHAR(50) NULL,
    [city] VARCHAR(25) NULL,
    [pin] VARCHAR(50) NULL,
    [state] VARCHAR(50) NULL,
    [period_years] VARCHAR(50) NULL,
    [period_months] VARCHAR(50) NULL,
    [contact_no] VARCHAR(50) NULL,
    [remark] VARCHAR(100) NULL,
    [user_id] VARCHAR(50) NULL,
    [status] VARCHAR(15) NULL,
    [Status_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newtemp
-- --------------------------------------------------
CREATE TABLE [dbo].[newtemp]
(
    [name1] VARCHAR(100) NULL
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
-- TABLE dbo.tbl_agreementdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_agreementdetails]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [lno] VARCHAR(50) NULL,
    [cno] NUMERIC(18, 0) NULL,
    [fdt] DATETIME NULL,
    [tdt] DATETIME NULL,
    [chageby] VARCHAR(50) NULL,
    [change] NUMERIC(18, 2) NULL,
    [amount] NUMERIC(18, 2) NULL,
    [userid] VARCHAR(50) NULL,
    [entrydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_expcode
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_expcode]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_month
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_month]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [month] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_monthly_rent
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_monthly_rent]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [lno] VARCHAR(50) NULL,
    [days] INT NULL,
    [amount] NUMERIC(18, 2) NULL,
    [month] VARCHAR(20) NULL,
    [year] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_monthly_rent_final
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_monthly_rent_final]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [lno] VARCHAR(50) NULL,
    [days] INT NULL,
    [amount] NUMERIC(18, 2) NULL,
    [month] VARCHAR(20) NULL,
    [year] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_payment_dtl
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_payment_dtl]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [lno] INT NULL,
    [subcode] CHAR(10) NULL,
    [fdt] DATETIME NULL,
    [tdt] DATETIME NULL,
    [jvdt] DATETIME NULL,
    [glcode] NUMERIC(18, 0) NOT NULL DEFAULT ((0)),
    [amount] NUMERIC(18, 2) NOT NULL DEFAULT ((0)),
    [tdscode] NUMERIC(18, 0) NOT NULL DEFAULT ((0)),
    [tdsrate] VARCHAR(50) NULL,
    [tdsamt] NUMERIC(18, 2) NOT NULL DEFAULT ((0)),
    [expcode] NUMERIC(18, 0) NOT NULL DEFAULT ((0)),
    [strate] VARCHAR(50) NULL,
    [stamt] NUMERIC(18, 2) NOT NULL DEFAULT ((0)),
    [sec] VARCHAR(50) NULL,
    [hec] VARCHAR(50) NULL,
    [grossamt] NUMERIC(18, 2) NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rentmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rentmaster]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [month] INT NULL,
    [year] INT NULL,
    [generatedby] VARCHAR(20) NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rentmaster_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rentmaster_log]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [month] INT NULL,
    [year] INT NULL,
    [generatedby] VARCHAR(20) NULL,
    [date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sub
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sub]
(
    [fld_srno] INT IDENTITY(1,1) NOT NULL,
    [fld_subno] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_testLS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_testLS]
(
    [fld1] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.te
-- --------------------------------------------------
CREATE TABLE [dbo].[te]
(
    [UserID] NVARCHAR(255) NULL,
    [UserName] NVARCHAR(255) NULL,
    [Tag] NVARCHAR(255) NULL,
    [Designation] NVARCHAR(255) NULL,
    [Department] NVARCHAR(255) NULL,
    [Access To] NVARCHAR(255) NULL,
    [Access Code] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Get_LastAccessDate
-- --------------------------------------------------

create view Get_LastAccessDate
as

select 
b.name,b.xtype,Created_on=b.crdate,
Last_user_Access_date=
(case when
--chk_date1=
(case when 
isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900')) end)

>
--chk_date1=

(case when 
isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900')) end)

then

(case when 
isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900')) end)

else 

(case when 
isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900')) end)
end
)
from sys.dm_db_index_usage_stats a, sysobjects b
where a.object_id =b.id

GO

-- --------------------------------------------------
-- VIEW dbo.V_agrdetails
-- --------------------------------------------------
CREATE view V_agrdetails
as
select srno,[agrno]=convert(numeric,ltrim(rtrim(replace(lno,substring(lno,len(lno),len(lno)),'')))),[subno]=substring(lno,len(lno),len(lno)),
[Change No]=cno,[From Date]=convert(varchar(11),fdt,103),[To Date]=convert(varchar(11),tdt,103),[Change By]=chageby,Change,Amount,userid,[Entry Date]=convert(varchar(11),entrydate,103)    
from tbl_agreementdetails(nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.V_agrdetails_lastchange
-- --------------------------------------------------
create view V_agrdetails_lastchange
as
select x.* from 
(select * from tbl_agreementdetails(nolock))x
inner join
(select lno,cno=max(cno) from tbl_agreementdetails(nolock) group by lno)y
on x.lno=y.lno and x.cno=y.cno

GO

-- --------------------------------------------------
-- VIEW dbo.V_licensor_details
-- --------------------------------------------------
CREATE view V_licensor_details as  
select a.fld_srno,a.lno,a.fld_subno,a.fld_name,a.fld_rentamt,a.fld_glcode,  
b.region,b.branch,cmt_dt=convert(varchar(11),b.cmt_dt,103),exp_dt=convert(varchar(11),b.exp_dt,103)
from tbl_licensor_details(nolock)a  
inner join  
(select * from tbl_leaseentry(nolock))b  
on a.lno=b.lno

GO

