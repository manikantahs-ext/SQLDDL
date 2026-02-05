-- DDL Export
-- Server: 10.253.33.232
-- Database: HoldingCSV
-- Exported: 2026-02-05T12:29:20.902996

USE HoldingCSV;
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
-- INDEX dbo.HoldingCSV_ArchBSE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxDate] ON [dbo].[HoldingCSV_ArchBSE] ([HoldingDate])

GO

-- --------------------------------------------------
-- INDEX dbo.HoldingCSV_ArchBSE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxHolding] ON [dbo].[HoldingCSV_ArchBSE] ([SETT_NO], [SETT_TYPE], [PARTY_CODE], [SCRIP_CD], [BCLTDPID])

GO

-- --------------------------------------------------
-- INDEX dbo.HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxDate] ON [dbo].[HoldingCSV_LiveBSE] ([HoldingDate])

GO

-- --------------------------------------------------
-- INDEX dbo.HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxHolding] ON [dbo].[HoldingCSV_LiveBSE] ([SETT_NO], [SETT_TYPE], [PARTY_CODE], [SCRIP_CD], [BCLTDPID])

GO

-- --------------------------------------------------
-- INDEX dbo.P_HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_P_HoldingCSV_LiveBSE] ON [dbo].[P_HoldingCSV_LiveBSE] ([Party_Code], [Series], [Sett_No], [Sett_Type], [ClientId])

GO

-- --------------------------------------------------
-- INDEX dbo.P_HoldingCSV_LiveNSE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_P_HoldingCSV_LiveNSE] ON [dbo].[P_HoldingCSV_LiveNSE] ([Party_Code], [Scrip_Cd], [Sett_No], [Sett_Type], [ClientId])

GO

-- --------------------------------------------------
-- INDEX dbo.S_HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_S_HoldingCSV_LiveBSE] ON [dbo].[S_HoldingCSV_LiveBSE] ([Series], [Party_Code], [Sett_No], [Sett_Type], [ClientId])

GO

-- --------------------------------------------------
-- INDEX dbo.S_HoldingCSV_LiveNSE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_S_HoldingCSV_LiveNSE] ON [dbo].[S_HoldingCSV_LiveNSE] ([Scrip_Cd], [Party_Code], [Sett_No], [Sett_Type], [ClientId])

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__395884C4] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Pbseholding1
-- --------------------------------------------------
CREATE PROC [dbo].[Pbseholding1]            
as                          
set nocount on                          
set transaction  isolation  level read uncommitted                                        
                    
declare @s as varchar(500)                          
declare @s1 as varchar(500)                          
            
select Party_Code+','+Party_Name+','+Scrip_Cd+','+Series+','+DPId+','+ClientId+','+Isin+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv      
--Scrip_Cd+','+Series+','+Party_Code+','+Party_Name+','+Isin+','+DPId+','+ClientId+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv              
Into zzpbseholding1          
from P_holdingcsv_livebse              
insert into zzpbseholding1 values('Party_Code,Party_Name,Scrip_Cd,Series,DPId,ClientId,Isin,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty')        
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT csv FROM ANGELDEMAT.HOLDINGCSV.DBO.ZZpBSEHOLDING1" queryout '+'d:\pbsehold.csv -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                        
set @s1= @s+''''                               
exec(@s1)                
drop table zzpbseholding1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PNSEholding1
-- --------------------------------------------------
CREATE PROC [dbo].[PNSEholding1]            
as                          
set nocount on                          
set transaction  isolation  level read uncommitted                                        
                    
declare @s as varchar(500)                          
declare @s1 as varchar(500)                          
            
select Party_Code+','+Party_Name+','+Scrip_Cd+','+Series+','+DPId+','+ClientId+','+Isin+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv      
--Scrip_Cd+','+Series+','+Party_Code+','+Party_Name+','+Isin+','+DPId+','+ClientId+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv              
Into zzpNSEholding1          
from P_holdingcsv_liveNSE        
insert into zzpnseholding1 values('Party_Code,Party_Name,Scrip_Cd,Series,DPId,ClientId,Isin,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty')        
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT csv FROM ANGELDEMAT.HOLDINGCSV.DBO.ZZpnseHOLDING1" queryout '+'d:\pnsehold.csv -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                        
set @s1= @s+''''                               
exec(@s1)                
drop table zzpNSEholding1

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
-- PROCEDURE dbo.sbseholding1
-- --------------------------------------------------
CREATE PROC [dbo].[sbseholding1]          
as                        
set nocount on                        
set transaction  isolation  level read uncommitted                                      
                  
declare @s as varchar(500)                        
declare @s1 as varchar(500)                        
          
select Scrip_Cd+','+Series+','+Party_Code+','+Party_Name+','+Isin+','+DPId+','+ClientId+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv            
Into zzsbseholding1        
from s_holdingcsv_livebse            
insert into zzsbseholding1 values('Scrip_Cd,Series,Party_Code,Party_Name,Isin,DPId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty')      
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT csv FROM ANGELDEMAT.HOLDINGCSV.DBO.ZZSBSEHOLDING1" queryout '+'d:\sbsehold.csv -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                      
set @s1= @s+''''                             
exec(@s1)              
drop table zzsbseholding1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEARCHINALL
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[SEARCHINALL] 
(@STRFIND AS VARCHAR(MAX))
AS



BEGIN
    SET NOCOUNT ON; 
    --TO FIND STRING IN ALL PROCEDURES        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) SP_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) SP_DEFINITION
        FROM   SYS.PROCEDURES
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL VIEWS        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) VIEW_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) VIEW_DEFINITION
        FROM   SYS.VIEWS
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL FUNCTION        
    BEGIN
        SELECT ROUTINE_NAME           FUNCTION_NAME
              ,ROUTINE_DEFINITION     FUNCTION_DEFINITION
        FROM   INFORMATION_SCHEMA.ROUTINES
        WHERE  ROUTINE_DEFINITION LIKE '%'+@STRFIND+'%'
               AND ROUTINE_TYPE = 'FUNCTION'
        ORDER BY
               ROUTINE_NAME
    END

    --TO FIND STRING IN ALL TABLES OF DATABASE.    
    BEGIN
        SELECT T.NAME      AS TABLE_NAME
              ,C.NAME      AS COLUMN_NAME
        FROM   SYS.TABLES  AS T
               INNER JOIN SYS.COLUMNS C
                    ON  T.OBJECT_ID = C.OBJECT_ID
        WHERE  C.NAME LIKE '%'+@STRFIND+'%'
        ORDER BY
               TABLE_NAME
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SNSEholding1
-- --------------------------------------------------
CREATE PROC [dbo].[SNSEholding1]            
as                          
set nocount on                          
set transaction  isolation  level read uncommitted                                        
                    
declare @s as varchar(500)                          
declare @s1 as varchar(500)                          
            
select Scrip_Cd+','+Series+','+Party_Code+','+Party_Name+','+Isin+','+DPId+','+ClientId+','+Sett_No+','+Sett_Type+','+convert(varchar,HoldQty)+','+convert(varchar,PledgeQty)+','+convert(varchar,Qty)  as csv              
Into zzsNSEholding1          
from S_holdingcsv_liveNSE        
insert into zzsnseholding1 values('Scrip_Cd,Series,Party_Code,Party_Name,Isin,DPId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty')        
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT csv FROM ANGELDEMAT.HOLDINGCSV.DBO.ZZSnseHOLDING1" queryout '+'d:\snsehold.csv -c -SANGELDEMAT -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                        
set @s1= @s+''''                               
exec(@s1)                
drop table zzsNSEholding1

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
-- PROCEDURE dbo.spHoldingFreenPledgeCSV
-- --------------------------------------------------
/*              
BackOffice Holding Date Wise              
*/              
CREATE Proc spHoldingFreenPledgeCSV  @ScripPartyWise as Varchar(1),@Exchange as Varchar(3)             
as              
set nocount on              
  
set transaction isolation level read uncommitted  
 /* S=ScripWise, P=PartyWise*/  
  
set transaction isolation level read uncommitted      
            
/* Exec spHoldingFreenPledgeCSV  'S','BSE'  */            
        
if @Exchange = 'BSE'        
begin        


 set transaction isolation level read uncommitted      
 Exec spHoldingFreenPledgeCSVMovetoArch  'BSE'          
      
 set transaction isolation level read uncommitted      
 Delete from HoldingCSV_LiveBSE  where HoldingDate=Convert(Varchar(12),getdate(),103)              
               
      
  set transaction isolation level read uncommitted      
  Insert into HoldingCSV_LiveBSE               
  SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,              
  SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',              
  SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',              
  SUM(QTY) 'TotalHolding'              
  FROM AngelDemat.BseDb.dbo.DELTRANS              
  WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'               
  /*               
   AND BCLTDPID = '10003588'               
   -- AND BCLTDPID = '1203320000000066'              
   -- AND BCLTDPID = '1203320000000028'              
   -- AND BCLTDPID = '1203320000072218'              
   -- AND BCLTDPID = '16921197'              
  */              
  and party_code not in ('BSE','EXE','BROKER')          
  and Left(CERTNO,2) = 'IN'          
  GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID              
  ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD  
    -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE              
           
 Insert into TblUpdateDtTime values ('HoldingCSV_LiveBSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))

    set transaction isolation level read uncommitted      

if @ScripPartyWise <> ''         
begin
	if @ScripPartyWise = 'P'  
	--Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty  
	begin  
	   Select Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',    
	   Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',      
	   (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',    
	   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'    
	   into #P_HoldingCSV_LiveBSE  
	   from HoldingCSV_LiveBSE      H     
	   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD      
	 --  order by BCLTDPId,Series,Sett_No,Party_Code    
	  
	-- Drop Table HoldingCSV_BSE
	   Truncate Table HoldingCSV_BSE_Party
	
	  Insert into HoldingCSV_BSE_Party
	  Select *  from #P_HoldingCSV_LiveBSE order by Party_Code,Scrip_Cd,Series,Sett_No,Sett_Type,ClientId    
	
	Insert into TblUpdateDtTime values ('HoldingCSV_BSE_Party',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))
	
	end  
	  
	if @ScripPartyWise = 'S'  
	--Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty  
	begin  
	   Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',  
	   Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',    
	   CertNo as 'Isin', (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',    
	   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'    
	   into #S_HoldingCSV_LiveBSE  
	   from HoldingCSV_LiveBSE      H         
	   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD      
	--   order by Scrip_Cd,Series,Party_Code,Sett_No  
	  
	 --  Select * from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No  
	   Truncate Table HoldingCSV_BSE_Scrip
	
	  Insert into HoldingCSV_BSE_Scrip
	  Select *  from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No  
	
	Insert into TblUpdateDtTime values ('HoldingCSV_BSE_Scrip',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))

	  Select * from HoldingCSV_BSE_Scrip order by ClientId,Scrip_Cd,Party_Code
	
	end  
end  
    
end        
        
if @Exchange = 'NSE'        
begin        
            
 set transaction isolation level read uncommitted        
 Exec spHoldingFreenPledgeCSVMovetoArch  'NSE'          
               
 set transaction isolation level read uncommitted      
 Delete from HoldingCSV_LiveNSE where HoldingDate=Convert(Varchar(12),getdate(),103)              
               
 set transaction isolation level read uncommitted      
 Insert into HoldingCSV_LiveNSE              
 SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,              
 SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',              
 SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',              
 SUM(QTY) 'TotalHolding'              
 FROM AngelDemat.MSAJAG.dbo.DELTRANS              
 WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'               
 /*               
  AND BCLTDPID = '10003588'               
  -- AND BCLTDPID = '1203320000000066'              
  -- AND BCLTDPID = '1203320000000028'              
  -- AND BCLTDPID = '1203320000072218'              
  -- AND BCLTDPID = '16921197'              
 */              
 and party_code not in ('BSE','EXE','BROKER')              
 and Left(CERTNO,2) = 'IN'      
 GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID              
 -- ORDER BY BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE              
  ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD  
    -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE              

 Insert into TblUpdateDtTime values ('HoldingCSV_LiveNSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))
  
           
 set transaction isolation level read uncommitted      
--  Select * from HoldingCSV_LiveNSE              
    
if @ScripPartyWise <> ''         
begin   
	if @ScripPartyWise = 'P'  
	--Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty  
	begin  
	
	   Select Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',    
	   Scrip_Cd, (Select Scrip_Cd from AngelDemat.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',      
	   (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',    
	   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'    
	   into #P_HoldingCSV_LiveNSE  
	   from HoldingCSV_LiveNSE      H         
	   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD      
	 --  order by BCLTDPId,Series,Sett_No,Party_Code    
	  
	  Select * from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code    
	
	   Truncate Table HoldingCSV_NSE_Party
	
	  Insert into HoldingCSV_NSE_Party
	  Select *  from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code    
	
	Insert into TblUpdateDtTime values ('HoldingCSV_NSE_Party',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))
	
	
	  Select * from HoldingCSV_NSE_Party order by ClientId,Party_Code,Scrip_Cd
	end  
	  
	if @ScripPartyWise = 'S'  
	--Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty  
	begin  
	   Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',  
	   Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',    
	   CertNo as 'Isin', (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',    
	   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'    
	   into #S_HoldingCSV_LiveNSE  
	   from HoldingCSV_LiveNSE      H        
	   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD       
	--    order by Scrip_Cd,Series,Party_Code,Sett_No  
	  
	--   Select * from #S_HoldingCSV_LiveNSE order by Scrip_Cd,Series,Party_Code,Sett_No   
	--  Select * from #S_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code    
	
	   Truncate Table HoldingCSV_NSE_Scrip
	
	  Insert into HoldingCSV_NSE_Scrip
	  Select *  from #S_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code    
	
	Insert into TblUpdateDtTime values ('HoldingCSV_NSE_Scrip',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))
	
	  Select * from HoldingCSV_NSE_Party order by ClientId,Scrip_Cd,Party_Code
	end  
  
end     
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spHoldingFreenPledgeCSV_Report
-- --------------------------------------------------
/*                          
BackOffice Holding Date Wise                          
S = ScripWise ; P = PartyWise            
BSE,NSE            
Y,N = Regenerate Option            
*/                          
CREATE Proc [dbo].[spHoldingFreenPledgeCSV_Report]  @ScripPartyWise as Varchar(1),@Exchange as Varchar(3) ,@Regenrate as Varchar(1)            
as                          
set nocount on                          
              
set transaction isolation level read uncommitted              
 /* S=ScripWise, P=PartyWise*/              
              
set transaction isolation level read uncommitted                  
                        
/* Exec spHoldingFreenPledgeCSV_Report  'S','BSE','N'  */                        
                    
if @Exchange = 'BSE'                    
begin                    
            
 if @Regenrate = 'Y'            
 begin            
   set transaction isolation level read uncommitted                  
   Exec spHoldingFreenPledgeCSVMovetoArch  'BSE'                      
                    
   set transaction isolation level read uncommitted                  
   Delete from HoldingCSV_LiveBSE  where HoldingDate=Convert(Varchar(12),getdate(),103)                          
                             
                    
    set transaction isolation level read uncommitted                  
    Insert into HoldingCSV_LiveBSE                           
    SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,                          
    SUM(CASE WHEN TRTYPE in (904,1000,905) THEN QTY ELSE 0 END) 'FreeHolding',                          
    SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
    SUM(QTY) 'TotalHolding'                          
    FROM AngelDemat.BSEDB.dbo.DELTRANS                          
    WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
    /*                           
     AND BCLTDPID = '10003588'                           
     -- AND BCLTDPID = '1203320000000066'                          
     -- AND BCLTDPID = '1203320000000028'                          
     -- AND BCLTDPID = '1203320000072218'                          
     -- AND BCLTDPID = '16921197'                          
    */                          
    and party_code not in ('BSE','EXE','BROKER')                      
    and Left(CERTNO,2) = 'IN'                      
    GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID                          
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD              
      -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
        
   Delete From TblUpdateDtTime where TableName = 'HoldingCSV_LiveBSE'        
        
   Insert into TblUpdateDtTime values ('HoldingCSV_LiveBSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))            
 end            
            
--if @ScripPartyWise <> ''                     
--begin            
-- if @ScripPartyWise = 'P'    --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin      
  
  
    Truncate Table P_HoldingCSV_LiveBSE        
  
    Insert into   P_HoldingCSV_LiveBSE        
    Select Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
    Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',                  
    (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
    -- into #P_HoldingCSV_LiveBSE              
    from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveBSE      H                 
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        --  order by BCLTDPId,Series,Sett_No,Party_Code                
            
  Update P_HoldingCSV_LiveBSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update P_HoldingCSV_LiveBSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update P_HoldingCSV_LiveBSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update P_HoldingCSV_LiveBSE Set Series = LTrim(RTrim(Series))  
  Update P_HoldingCSV_LiveBSE Set ISIN = LTrim(RTrim(ISIN))  
  
--   Select * into P_HoldingCSV_LiveBSE from #P_HoldingCSV_LiveBSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code                
  
-- end              
               
 -- if @ScripPartyWise = 'S'              
 --Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin        
  
  
    Truncate Table S_HoldingCSV_LiveBSE        
        
    Insert into S_HoldingCSV_LiveBSE        
    Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',              
    Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
    CertNo as 'Isin', (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
    -- into #S_HoldingCSV_LiveBSE              
    from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveBSE      H                     
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        --   order by Scrip_Cd,Series,Party_Code,Sett_No              
               
  Update S_HoldingCSV_LiveBSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update S_HoldingCSV_LiveBSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update S_HoldingCSV_LiveBSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update S_HoldingCSV_LiveBSE Set Series = LTrim(RTrim(Series))  
  Update S_HoldingCSV_LiveBSE Set ISIN = LTrim(RTrim(ISIN))  
  
--    Select *  into S_HoldingCSV_LiveBSE   from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No              
 -- end              
end              
--end                    
                    
if @Exchange = 'NSE'                    
begin                    
 if @Regenrate = 'Y'            
 begin            
          
   set transaction isolation level read uncommitted                    
   Exec spHoldingFreenPledgeCSVMovetoArch  'NSE'                      
          
                             
   set transaction isolation level read uncommitted                  
   Delete from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE where HoldingDate=Convert(Varchar(12),getdate(),103)                          
                             
   set transaction isolation level read uncommitted                  
            
   Insert into AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE                          
   SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'                          
   -- into HoldingCSV_LiveNSE              /* Drop Table HoldingCSV_LiveNSE */            
   FROM AngelDemat.MSAJAG.dbo.DELTRANS                          
   WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
   /*                           
    AND BCLTDPID = '10003588'                           
    -- AND BCLTDPID = '1203320000000066'                          
    -- AND BCLTDPID = '1203320000000028'                          
    -- AND BCLTDPID = '1203320000072218'                          
    -- AND BCLTDPID = '16921197'                          
   */                          
   and party_code not in ('BSE','EXE','BROKER')                          
   and Left(CERTNO,2) = 'IN'                  
   GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID                          
   -- ORDER BY BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series              
      -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
              
                
   Delete From TblUpdateDtTime where TableName = 'HoldingCSV_LiveNSE'        
        
   Insert into TblUpdateDtTime values ('HoldingCSV_LiveNSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))            
               
  Select distinct Scrip_Cd,Series into #Scrip2 from AngelDemat.MSAJAG.dbo.Scrip2            
            
 end          
                 
-- if @ScripPartyWise = 'P'    --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin              
  
   Truncate Table P_HoldingCSV_LiveNSE  
  
   Insert into P_HoldingCSV_LiveNSE  
   Select Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
   Scrip_Cd,-- (Select Series from #Scrip2 s2 where s2.Scrip_Cd  = H.Scrip_Cd and S2.Series = H.Series ) as 'Series'            
   Series,CertNo as 'Isin',(Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
   -- into #P_HoldingCSV_LiveNSE   -- Drop Table #P_HoldingCSV_LiveNSE              
   from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE      H                     
   where HoldingDate=Convert(Varchar(12),getdate(),103)                          
   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD                  
 --  order by BCLTDPId,Series,Sett_No,Party_Code                
  
  
  Update P_HoldingCSV_LiveNSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update P_HoldingCSV_LiveNSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update P_HoldingCSV_LiveNSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update P_HoldingCSV_LiveNSE Set Series = LTrim(RTrim(Series))  
  Update P_HoldingCSV_LiveNSE Set ISIN = LTrim(RTrim(ISIN))  
      
-- Select Distinct HoldingDate from AngelHoldingCSV.HoldingCSV.dbo.HoldingCSV_LiveNSE             
-- Select Distinct HoldingDate from AngelHoldingCSV.HoldingCSV.dbo.HoldingCSV_LiveBSE             
              
  -- Select * into  P_HoldingCSV_LiveNSE     from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code                
-- end              
              
-- if @ScripPartyWise = 'S'              
--Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin              
  
   Truncate Table S_HoldingCSV_LiveNSE  
  
   Insert into S_HoldingCSV_LiveNSE  
   Select Scrip_Cd,Series, -- (Select Scrip_Cd from AngelHoldingCSV.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',              
   Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
   CertNo as 'Isin', (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
   -- into #S_HoldingCSV_LiveNSE              
   from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE      H                    
   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD                   
--    order by Scrip_Cd,Series,Party_Code,Sett_No              
              
  
  Update S_HoldingCSV_LiveNSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update S_HoldingCSV_LiveNSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update S_HoldingCSV_LiveNSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update S_HoldingCSV_LiveNSE Set Series = LTrim(RTrim(Series))  
  Update S_HoldingCSV_LiveNSE Set ISIN = LTrim(RTrim(ISIN))  
  
  
  -- Select * into S_HoldingCSV_LiveNSE  from #S_HoldingCSV_LiveNSE order by Scrip_Cd,Series,Party_Code,Sett_No               
-- end              
              
                 
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spHoldingFreenPledgeCSV_Report_31032011
-- --------------------------------------------------
/*                          
BackOffice Holding Date Wise                          
S = ScripWise ; P = PartyWise            
BSE,NSE            
Y,N = Regenerate Option            
*/                          
CREATE Proc [dbo].[spHoldingFreenPledgeCSV_Report_31032011]  @ScripPartyWise as Varchar(1),@Exchange as Varchar(3) ,@Regenrate as Varchar(1)            
as                          
set nocount on                          
              
set transaction isolation level read uncommitted              
 /* S=ScripWise, P=PartyWise*/              
              
set transaction isolation level read uncommitted                  
                        
/* Exec spHoldingFreenPledgeCSV_Report  'S','BSE','N'  */                        
                    
if @Exchange = 'BSE'                    
begin                    
            
 if @Regenrate = 'Y'            
 begin            
   set transaction isolation level read uncommitted                  
   Exec spHoldingFreenPledgeCSVMovetoArch  'BSE'                      
                    
   set transaction isolation level read uncommitted                  
   Delete from HoldingCSV_LiveBSE  where HoldingDate=Convert(Varchar(12),getdate(),103)                          
                             
                    
    set transaction isolation level read uncommitted                  
    Insert into HoldingCSV_LiveBSE                           
    SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,                          
    SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
    SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
    SUM(QTY) 'TotalHolding'                          
    FROM AngelDemat.BSEDB.dbo.DELTRANS                          
    WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
    /*                           
     AND BCLTDPID = '10003588'                           
     -- AND BCLTDPID = '1203320000000066'                          
     -- AND BCLTDPID = '1203320000000028'                          
     -- AND BCLTDPID = '1203320000072218'                          
     -- AND BCLTDPID = '16921197'                          
    */                          
    and party_code not in ('BSE','EXE','BROKER')                      
    and Left(CERTNO,2) = 'IN'                      
    GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID                          
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD              
      -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
        
   Delete From TblUpdateDtTime where TableName = 'HoldingCSV_LiveBSE'        
        
   Insert into TblUpdateDtTime values ('HoldingCSV_LiveBSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))            
 end            
            
--if @ScripPartyWise <> ''                     
--begin            
-- if @ScripPartyWise = 'P'    --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin      
  
  
    Truncate Table P_HoldingCSV_LiveBSE        
  
    Insert into   P_HoldingCSV_LiveBSE        
    Select Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
    Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',                  
    (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
    -- into #P_HoldingCSV_LiveBSE              
    from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveBSE      H                 
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        --  order by BCLTDPId,Series,Sett_No,Party_Code                
            
  Update P_HoldingCSV_LiveBSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update P_HoldingCSV_LiveBSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update P_HoldingCSV_LiveBSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update P_HoldingCSV_LiveBSE Set Series = LTrim(RTrim(Series))  
  Update P_HoldingCSV_LiveBSE Set ISIN = LTrim(RTrim(ISIN))  
  
--   Select * into P_HoldingCSV_LiveBSE from #P_HoldingCSV_LiveBSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code                
  
-- end              
               
 -- if @ScripPartyWise = 'S'              
 --Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin        
  
  
    Truncate Table S_HoldingCSV_LiveBSE        
        
    Insert into S_HoldingCSV_LiveBSE        
    Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',              
    Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
    CertNo as 'Isin', (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
    -- into #S_HoldingCSV_LiveBSE              
    from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveBSE      H                     
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        --   order by Scrip_Cd,Series,Party_Code,Sett_No              
               
  Update S_HoldingCSV_LiveBSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update S_HoldingCSV_LiveBSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update S_HoldingCSV_LiveBSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update S_HoldingCSV_LiveBSE Set Series = LTrim(RTrim(Series))  
  Update S_HoldingCSV_LiveBSE Set ISIN = LTrim(RTrim(ISIN))  
  
--    Select *  into S_HoldingCSV_LiveBSE   from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No              
 -- end              
end              
--end                    
                    
if @Exchange = 'NSE'                    
begin                    
 if @Regenrate = 'Y'            
 begin            
          
   set transaction isolation level read uncommitted                    
   Exec spHoldingFreenPledgeCSVMovetoArch  'NSE'                      
          
                             
   set transaction isolation level read uncommitted                  
   Delete from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE where HoldingDate=Convert(Varchar(12),getdate(),103)                          
                             
   set transaction isolation level read uncommitted                  
            
   Insert into AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE                          
   SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID,                          
   SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                          
   SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                          
   SUM(QTY) 'TotalHolding'                          
   -- into HoldingCSV_LiveNSE              /* Drop Table HoldingCSV_LiveNSE */            
   FROM AngelDemat.MSAJAG.dbo.DELTRANS                          
   WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                           
   /*                           
    AND BCLTDPID = '10003588'                           
    -- AND BCLTDPID = '1203320000000066'                          
    -- AND BCLTDPID = '1203320000000028'                          
    -- AND BCLTDPID = '1203320000072218'                          
    -- AND BCLTDPID = '16921197'                          
   */                          
   and party_code not in ('BSE','EXE','BROKER')                          
   and Left(CERTNO,2) = 'IN'                  
   GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series,CERTNO,BCLTDPID                          
   -- ORDER BY BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,Series              
      -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                          
              
                
   Delete From TblUpdateDtTime where TableName = 'HoldingCSV_LiveNSE'        
        
   Insert into TblUpdateDtTime values ('HoldingCSV_LiveNSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))            
               
  Select distinct Scrip_Cd,Series into #Scrip2 from AngelDemat.MSAJAG.dbo.Scrip2            
            
 end          
                 
-- if @ScripPartyWise = 'P'    --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin              
  
   Truncate Table P_HoldingCSV_LiveNSE  
  
   Insert into P_HoldingCSV_LiveNSE  
   Select Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
   Scrip_Cd,-- (Select Series from #Scrip2 s2 where s2.Scrip_Cd  = H.Scrip_Cd and S2.Series = H.Series ) as 'Series'            
   Series,CertNo as 'Isin',(Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
   -- into #P_HoldingCSV_LiveNSE   -- Drop Table #P_HoldingCSV_LiveNSE              
   from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE      H                     
   where HoldingDate=Convert(Varchar(12),getdate(),103)                          
   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD                  
 --  order by BCLTDPId,Series,Sett_No,Party_Code                
  
  
  Update P_HoldingCSV_LiveNSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update P_HoldingCSV_LiveNSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update P_HoldingCSV_LiveNSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update P_HoldingCSV_LiveNSE Set Series = LTrim(RTrim(Series))  
  Update P_HoldingCSV_LiveNSE Set ISIN = LTrim(RTrim(ISIN))  
      
-- Select Distinct HoldingDate from AngelHoldingCSV.HoldingCSV.dbo.HoldingCSV_LiveNSE             
-- Select Distinct HoldingDate from AngelHoldingCSV.HoldingCSV.dbo.HoldingCSV_LiveBSE             
              
  -- Select * into  P_HoldingCSV_LiveNSE     from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code                
-- end              
              
-- if @ScripPartyWise = 'S'              
--Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty              
-- begin              
  
   Truncate Table S_HoldingCSV_LiveNSE  
  
   Insert into S_HoldingCSV_LiveNSE  
   Select Scrip_Cd,Series, -- (Select Scrip_Cd from AngelHoldingCSV.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',              
   Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',                
   CertNo as 'Isin', (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',                
   BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'                
   -- into #S_HoldingCSV_LiveNSE              
   from AngelDemat.HoldingCSV.dbo.HoldingCSV_LiveNSE      H                    
   ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD                   
--    order by Scrip_Cd,Series,Party_Code,Sett_No              
              
  
  Update S_HoldingCSV_LiveNSE Set Party_Code = LTrim(RTrim(Party_Code))  
  Update S_HoldingCSV_LiveNSE Set Party_Name = LTrim(RTrim(Party_Name))  
  Update S_HoldingCSV_LiveNSE Set Scrip_Cd = LTrim(RTrim(Scrip_Cd))  
  Update S_HoldingCSV_LiveNSE Set Series = LTrim(RTrim(Series))  
  Update S_HoldingCSV_LiveNSE Set ISIN = LTrim(RTrim(ISIN))  
  
  
  -- Select * into S_HoldingCSV_LiveNSE  from #S_HoldingCSV_LiveNSE order by Scrip_Cd,Series,Party_Code,Sett_No               
-- end              
              
                 
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spHoldingFreenPledgeCSV_ReportNitin
-- --------------------------------------------------
/*                
BackOffice Holding Date Wise                
S = ScripWise ; P = PartyWise  
BSE,NSE  
Y,N = Regenerate Option  
*/                
CREATE Proc spHoldingFreenPledgeCSV_ReportNitin  @ScripPartyWise as Varchar(1),@Exchange as Varchar(3) ,@Regenrate as Varchar(1)  
as                
set nocount on                
    
set transaction isolation level read uncommitted    
 /* S=ScripWise, P=PartyWise*/    
    
set transaction isolation level read uncommitted        
              
/* Exec spHoldingFreenPledgeCSV_Report  'S','BSE','N'  */              
          
if @Exchange = 'BSE'          
begin          
  
if @Regenrate = 'Y'  
begin  
 set transaction isolation level read uncommitted        
 Exec spHoldingFreenPledgeCSVMovetoArch  'BSE'            
        
 set transaction isolation level read uncommitted        
 Delete from HoldingCSV_LiveBSE  where HoldingDate=Convert(Varchar(12),getdate(),103)                
                 
        
  set transaction isolation level read uncommitted        
  Insert into HoldingCSV_LiveBSE                 
  SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,                
  SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                
  SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                
  SUM(QTY) 'TotalHolding'                
  FROM AngelDemat.BseDb.dbo.DELTRANS                
  WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                 
  /*                 
   AND BCLTDPID = '10003588'                 
   -- AND BCLTDPID = '1203320000000066'                
   -- AND BCLTDPID = '1203320000000028'                
   -- AND BCLTDPID = '1203320000072218'                
   -- AND BCLTDPID = '16921197'                
  */                
  and party_code not in ('BSE','EXE','BROKER')            
  and Left(CERTNO,2) = 'IN'            
  GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID                
  ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD    
    -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                
             
 Insert into TblUpdateDtTime values ('HoldingCSV_LiveBSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
end  
  
    set transaction isolation level read uncommitted        
  
if @ScripPartyWise <> ''           
begin  
 if @ScripPartyWise = 'P'    
 --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty    
 begin    
    Select Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',      
    Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',        
    (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',      
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'      
    into #P_HoldingCSV_LiveBSE    
    from HoldingCSV_LiveBSE      H       
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        
  --  order by BCLTDPId,Series,Sett_No,Party_Code      
     
 -- Drop Table HoldingCSV_BSE  
    Truncate Table HoldingCSV_BSE_Party  
   
   Insert into HoldingCSV_BSE_Party  
   Select *  from #P_HoldingCSV_LiveBSE order by Party_Code,Scrip_Cd,Series,Sett_No,Sett_Type,ClientId      
   
 Insert into TblUpdateDtTime values ('HoldingCSV_BSE_Party',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
  
   Select *  from HoldingCSV_BSE_Party order by Party_Code,Scrip_Cd,Series,Sett_No,Sett_Type,ClientId      
   
 end    
     
 if @ScripPartyWise = 'S'    
 --Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty    
 begin    
    Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.BseDb.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',    
    Party_Code, ( Select Short_Name  from   AngelDemat.BseDb.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',      
    CertNo as 'Isin', (Select DPId from AngelDemat.BSEDB.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',      
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'      
    into #S_HoldingCSV_LiveBSE    
    from HoldingCSV_LiveBSE      H           
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        
 --   order by Scrip_Cd,Series,Party_Code,Sett_No    
     
  --  Select * from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No    
    Truncate Table HoldingCSV_BSE_Scrip  
   
   Insert into HoldingCSV_BSE_Scrip  
   Select *  from #S_HoldingCSV_LiveBSE order by Scrip_Cd,Series,Party_Code,Sett_No    
   
 Insert into TblUpdateDtTime values ('HoldingCSV_BSE_Scrip',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
  
   Select * from HoldingCSV_BSE_Scrip order by ClientId,Scrip_Cd,Party_Code  
   
 end    
end    
      
end          
          
if @Exchange = 'NSE'          
begin          
              
  
if @Regenrate = 'Y'  
begin  
 set transaction isolation level read uncommitted          
 Exec spHoldingFreenPledgeCSVMovetoArch  'NSE'            
                 
 set transaction isolation level read uncommitted        
 Delete from HoldingCSV_LiveNSE where HoldingDate=Convert(Varchar(12),getdate(),103)                
                 
 set transaction isolation level read uncommitted        
 Insert into HoldingCSV_LiveNSE                
 SELECT Convert(Varchar(12),getdate(),103) as 'HoldingDate',SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID,                
 SUM(CASE WHEN TRTYPE = 904 THEN QTY ELSE 0 END) 'FreeHolding',                
 SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) 'PledgedHolding',                
 SUM(QTY) 'TotalHolding'                
 FROM AngelDemat.MSAJAG.dbo.DELTRANS                
 WHERE DRCR = 'D' AND FILLER2 = '1' AND DELIVERED = '0'                 
 /*                 
  AND BCLTDPID = '10003588'                 
  -- AND BCLTDPID = '1203320000000066'                
  -- AND BCLTDPID = '1203320000000028'                
  -- AND BCLTDPID = '1203320000072218'                
  -- AND BCLTDPID = '16921197'                
 */                
 and party_code not in ('BSE','EXE','BROKER')                
 and Left(CERTNO,2) = 'IN'        
 GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,CERTNO,BCLTDPID                
 -- ORDER BY BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                
  ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD    
    -- BCLTDPID,PARTY_CODE,SCRIP_CD,SETT_NO,SETT_TYPE                
  
 Insert into TblUpdateDtTime values ('HoldingCSV_LiveNSE',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
    
end              
 set transaction isolation level read uncommitted        
--  Select * from HoldingCSV_LiveNSE                
      
if @ScripPartyWise <> ''           
begin     
 if @ScripPartyWise = 'P'    
 --Party_Code,Party_Name,Scrip_Cd,Series,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty    
 begin    
   
    Select Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',      
    Scrip_Cd, (Select Scrip_Cd from AngelDemat.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',CertNo as 'Isin',        
    (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',      
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'      
    into #P_HoldingCSV_LiveNSE    
    from HoldingCSV_LiveNSE      H           
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD        
  --  order by BCLTDPId,Series,Sett_No,Party_Code      
     
   -- Select * from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code      
   
    Truncate Table HoldingCSV_NSE_Party  
   
   Insert into HoldingCSV_NSE_Party  
   Select *  from #P_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code      
   
 Insert into TblUpdateDtTime values ('HoldingCSV_NSE_Party',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
   
   
   Select * from HoldingCSV_NSE_Party order by ClientId,Party_Code,Scrip_Cd  
 end    
     
 if @ScripPartyWise = 'S'    
 --Scrip_Cd,Series,Party_Code,Party_Name,IsIn,DpId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty    
 begin    
    Select Scrip_Cd, (Select Scrip_Cd from AngelDemat.MSAJAG.dbo.Scrip2 where bsecode  = H.Scrip_Cd) as 'Series',    
    Party_Code, ( Select Short_Name  from   AngelDemat.MSAJAG.dbo.client1 where Cl_Code = Party_Code) as 'Party_Name',      
    CertNo as 'Isin', (Select DPId from AngelDemat.MSAJAG.dbo.DeliveryDp where DpCltNo = BCLTDPID) as 'DPId',      
    BCLTDPID as 'ClientId',Sett_No,Sett_Type,FreeHolding as 'HoldQty',PledgedHolding as 'PledgeQty',TotalHolding  as 'Qty'      
    into #S_HoldingCSV_LiveNSE    
    from HoldingCSV_LiveNSE      H          
    ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD         
 --    order by Scrip_Cd,Series,Party_Code,Sett_No    
     
 --   Select * from #S_HoldingCSV_LiveNSE order by Scrip_Cd,Series,Party_Code,Sett_No     
 --  Select * from #S_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code      
   
    Truncate Table HoldingCSV_NSE_Scrip  
   
   Insert into HoldingCSV_NSE_Scrip  
   Select *  from #S_HoldingCSV_LiveNSE order by ClientId,Series,Sett_No,Sett_Type,Party_Code      
   
 Insert into TblUpdateDtTime values ('HoldingCSV_NSE_Scrip',convert(varchar(8),getdate(),112),convert(varchar(8),getdate(),108))  
   
   Select * from HoldingCSV_NSE_Party order by ClientId,Scrip_Cd,Party_Code  
 end    
    
end       
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spHoldingFreenPledgeCSVMovetoArch
-- --------------------------------------------------

CREATE proc spHoldingFreenPledgeCSVMovetoArch @Exchange as varchar(3)                 
as                  
set nocount on                   
/*      
Exec spHoldingFreenPledgeCSVMovetoArch 'BSE'    
Exec spHoldingFreenPledgeCSVMovetoArch 'NSE'    
*/                  
if @Exchange = 'BSE'                
begin                
      
 set transaction isolation level read uncommitted
 truncate table holdingcsv_archbse      
 --Delete from HoldingCSV_ArchBSE where                  
 --HoldingDate in (Select Distinct HoldingDate from HoldingCSV_LiveBSE)                  
      
 set transaction isolation level read uncommitted                   
 Insert into HoldingCSV_ArchBSE                  
 Select * from HoldingCSV_LiveBSE                   
      
 set transaction isolation level read uncommitted                   
 Delete from HoldingCSV_LiveBSE where HoldingDate<>Convert(Varchar(12),getdate(),103)                    
end                  
if @Exchange = 'NSE'                
begin                
 set transaction isolation level read uncommitted      
 truncate table holdingcsv_archnse
 --Delete from HoldingCSV_ArchNSE where                  
 --HoldingDate in (Select Distinct HoldingDate from HoldingCSV_LiveNSE)                  
                   
 set transaction isolation level read uncommitted      
 Insert into HoldingCSV_ArchNSE                  
 Select * from HoldingCSV_LiveNSE                   
                   
 set transaction isolation level read uncommitted      
 Delete from HoldingCSV_LiveNSE where HoldingDate<>Convert(Varchar(12),getdate(),103)                    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spHoldingUpdate4CSV
-- --------------------------------------------------
CREATE Proc spHoldingUpdate4CSV  
as  
set nocount on  
/*  
Exec spHoldingUpdate4CSV  
*/  
  
set transaction isolation level read uncommitted  

-- Exec spHoldingFreenPledgeCSV  '','NSE'
-- Exec spHoldingFreenPledgeCSV '','BSE'
  
Truncate Table TblUpdateDtTime
Exec spHoldingFreenPledgeCSV_Report  '','NSE','Y'
Exec spHoldingFreenPledgeCSV_Report '','BSE','Y'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spRemoveArchHoldingsCSV
-- --------------------------------------------------
CREATE Proc spRemoveArchHoldingsCSV
as    
set nocount on    
/*    
Exec spHoldingUpdate4CSV    
*/    
    
set transaction isolation level read uncommitted    


Truncate Table HoldingCSV_ArchNSE
Truncate Table HoldingCSV_ArchBSE

GO

-- --------------------------------------------------
-- TABLE dbo.a1
-- --------------------------------------------------
CREATE TABLE [dbo].[a1]
(
    [fname] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_ArchBSE
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_ArchBSE]
(
    [HoldingDate] VARCHAR(12) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [CERTNO] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [FreeHolding] NUMERIC(38, 0) NULL,
    [PledgedHolding] NUMERIC(38, 0) NULL,
    [TotalHolding] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_ArchNSE
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_ArchNSE]
(
    [HoldingDate] VARCHAR(12) NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [CERTNO] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [FreeHolding] NUMERIC(38, 0) NULL,
    [PledgedHolding] NUMERIC(38, 0) NULL,
    [TotalHolding] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_BSE_Party
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_BSE_Party]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_BSE_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_BSE_Scrip]
(
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_LiveBSE]
(
    [HoldingDate] VARCHAR(12) NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [CERTNO] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [FreeHolding] NUMERIC(38, 0) NULL,
    [PledgedHolding] NUMERIC(38, 0) NULL,
    [TotalHolding] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_LiveNSE
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_LiveNSE]
(
    [HoldingDate] VARCHAR(12) NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [CERTNO] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [FreeHolding] NUMERIC(38, 0) NULL,
    [PledgedHolding] NUMERIC(38, 0) NULL,
    [TotalHolding] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_NSE_Party
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_NSE_Party]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HoldingCSV_NSE_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[HoldingCSV_NSE_Scrip]
(
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.P_HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE TABLE [dbo].[P_HoldingCSV_LiveBSE]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.P_HoldingCSV_LiveNSE
-- --------------------------------------------------
CREATE TABLE [dbo].[P_HoldingCSV_LiveNSE]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.S_HoldingCSV_LiveBSE
-- --------------------------------------------------
CREATE TABLE [dbo].[S_HoldingCSV_LiveBSE]
(
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.S_HoldingCSV_LiveNSE
-- --------------------------------------------------
CREATE TABLE [dbo].[S_HoldingCSV_LiveNSE]
(
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Qty] NUMERIC(38, 0) NULL
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
-- TABLE dbo.tbl_Scrip_bse_holding
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Scrip_bse_holding]
(
    [csv] VARCHAR(213) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblUpdateDtTime
-- --------------------------------------------------
CREATE TABLE [dbo].[TblUpdateDtTime]
(
    [TableName] VARCHAR(20) NULL,
    [UpdDate] VARCHAR(8) NULL,
    [UpdTime] VARCHAR(8) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.zzheading
-- --------------------------------------------------
CREATE TABLE [dbo].[zzheading]
(
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(12) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(21) NULL,
    [Isin] VARCHAR(16) NULL,
    [DPId] VARCHAR(16) NULL,
    [ClientId] VARCHAR(16) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [HoldQty] NUMERIC(38, 0) NULL,
    [PledgeQty] NUMERIC(38, 0) NULL,
    [Scrip_Cd,Series,Party_Code,Party_Name,Isin,DPId,ClientId,Sett_No,Sett_Type,HoldQty,PledgeQty,Qty] NUMERIC(38, 0) NULL
);

GO

