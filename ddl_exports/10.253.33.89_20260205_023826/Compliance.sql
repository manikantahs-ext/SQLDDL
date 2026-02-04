-- DDL Export
-- Server: 10.253.33.89
-- Database: Compliance
-- Exported: 2026-02-05T02:38:38.545325

USE Compliance;
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
-- FUNCTION dbo.sp_CTCL
-- --------------------------------------------------




CREATE Function sp_CTCL      

(      

@SBTag varchar(50)      

)      

RETURNS @table TABLE 

(

  [Login/Odin Id] varchar(100),	

  Segment varchar(100),

  UserName	varchar(100),

  [Terminal Address] varchar(max),	

  [NCFM/BCSM Regn No] varchar(100),

  VALIDUpTo varchar(100)

  

)

AS

 begin



 



insert @table

select b.stOdinId as [Login/Odin Id],b.stSegment as [Segment],(c.STFIRSTNAME +' '+ CASE WHEN c.STMIDDLENAME IS NULL THEN ''                                          

 ELSE c.STMIDDLENAME END+''+c.STLASTNAME) AS UserName,      

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS1        

 when AD.AddressType='A1' then (select AddLine1 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

 when AD.AddressType='A2' then (select AddLine1 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')          

  ELSE T.TERADDLINE1 END + ' '  +                            

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS2         

  when AD.AddressType='A1' then (select AddLine2 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

when AD.AddressType='A2' then (select AddLine2 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')           

 ELSE TERADDLINE2 END  + ' '  +                                                                  

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS3         

 when AD.AddressType='A1' then (select Landmark from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

 when AD.AddressType='A2' then (select Landmark from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')             

 ELSE TERLANDMARK END  + ' ' +    

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRCITY       

 when AD.AddressType='A1' then (select City from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')          

 when AD.AddressType='A2' then (select City from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')         

 ELSE T.TERCITY END +  ' ' +                              

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRSTATE       

 when AD.AddressType='A1' then (select State from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')          

 when AD.AddressType='A2' then (select State from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')         

 ELSE TERSTATE END + ' ' +              

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRZIP       

 when AD.AddressType='A1' then (select Pincode from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')          

 when AD.AddressType='A2' then (select Pincode from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')         

 ELSE TERPINCODE END   as [Terminal Address],(STREGNOPRIFIX +''+ STREGNO) AS [NCFM/BCSM Regn No],      

 case when CONVERT(VARCHAR(11),C.DTVALIDITYDATE,103)='01/01/1900' then '' else  CONVERT(VARCHAR(11),C.DTVALIDITYDATE,103) end AS VALIDUpTo   

   

 --into #temp  

 from [196.1.115.132].ctclnew.dbo.tbl_CtclId b with(nolock)      

 left join [196.1.115.132].ctclnew.dbo.V_EMPMASTER c with(nolock)      

 on b.stIntSysRefNo=c.stIntSysRefNo      

 LEFT OUTER JOIN                                           

 [196.1.115.132].ctclnew.dbo.TBL_BRANCHMASTER d with(nolock)                                          

ON                                           

 B.STBRTAG=d.STBRTAG        

 LEFT OUTER JOIN                                

[196.1.115.132].ctclnew.dbo.tbl_CtclAddTransaction Ad  with(nolock)                             

ON                                    

B.STINTSYSREFNO=Ad.STINTSYSREFNO         

LEFT OUTER JOIN                                           

[MIS].SB_COMP.DBO.VW_SUBBROKER_DETAILS T    with(nolock)                                       

ON                                           

B.STSBTAG=T.SBTAG        

where b.stSBTag=@SBTag and b.stStatus='A'      

      

      

    

  --select [Login/Odin Id] ,UserName ,[Terminal Address],Segment=Replace(REPLACE((isnull([MCXSX-MCXSX],'0')+','+isnull([NSE-CDS],'0')+','+isnull([NCDEX-NCDEX],'0')+','+isnull([NSE-FO],'0')+','+isnull([MCX-MCX],'0')+','+isnull([BSE-CDS],'0')+','+isnull([NSE-MFSS],'0')+','+isnull([BSE-FO],'0')+','+isnull([NSE-CASH],'0')+','+isnull([NSE-IRFC],'0')+','+isnull([BSE-CASH],'0')),'0,',''),',0','')  

  -- from(select [Login/Odin Id] ,Segment , UserName ,[Terminal Address]   from @table    ) as A  

  --pivot  (min(segment) for segment in   ([MCXSX-MCXSX],[NSE-CDS],[NCDEX-NCDEX],[NSE-FO],[MCX-MCX],[BSE-CDS],[NSE-MFSS],[BSE-FO],[NSE-CASH],[NSE-IRFC],[BSE-CASH]) ) as pvt  





    



    

RETURN      

End

GO

-- --------------------------------------------------
-- FUNCTION dbo.UDF_GET_TOTALQUESTION
-- --------------------------------------------------
CREATE FUNCTION [dbo].[UDF_GET_TOTALQUESTION]()
RETURNS VARCHAR(50) 
AS BEGIN
DECLARE @COUNT AS INT
select @COUNT= COUNT(1)  from dbo.Tbl_question_master where is_approved =1
RETURN CAST( @COUNT AS VARCHAR(50))
END

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_answer
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_Tbl_answer] ON [dbo].[Tbl_answer] ([SBTAG])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B610F975522] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_annexture
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_annexture] ADD CONSTRAINT [PK_Tbl_annexture] PRIMARY KEY ([Entry_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_answer
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_answer] ADD CONSTRAINT [PK_Tbl_answer] PRIMARY KEY ([Entry_Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Exception
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Exception] ADD CONSTRAINT [PK_tbl_Exception] PRIMARY KEY ([Sno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_question_master
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_question_master] ADD CONSTRAINT [PK_Tbl_question_master] PRIMARY KEY ([sno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_SACC_EmailMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_SACC_EmailMaster] ADD CONSTRAINT [PK_Tbl_SACC_EmailMaster] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_SACC_SMSMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_SACC_SMSMaster] ADD CONSTRAINT [PK__Tbl_SACC__3213E83F6FE99F9F] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_terminaldetails
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_terminaldetails] ADD CONSTRAINT [PK__Tbl_term__3213E83F628FA481] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.getentryid
-- --------------------------------------------------
-- =============================================
-- Author:		<suraj patil>
-- Create date: <24-01-2015>

-- =============================================
CREATE PROCEDURE [dbo].[getentryid] 
	@sbtag varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select  Entry_id from Tbl_answer where sbtag=@sbtag
select question from Tbl_question_master
END

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
-- PROCEDURE dbo.sp_CTCL_new
-- --------------------------------------------------


CREATE Procedure sp_CTCL_new        

(        

@SBTag varchar(50)        

)        

As        

Begin        

select b.stOdinId as [Login/Odin Id],b.stSegment as [Segment],(c.STFIRSTNAME +' '+ CASE WHEN c.STMIDDLENAME IS NULL THEN ''                                            

 ELSE c.STMIDDLENAME END+''+c.STLASTNAME) AS UserName,        

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS1          

 when AD.AddressType='A1' then (select AddLine1 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')              

 when AD.AddressType='A2' then (select AddLine1 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')            

  ELSE T.TERADDLINE1 END + ' '  +                              

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS2           

  when AD.AddressType='A1' then (select AddLine2 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')              

when AD.AddressType='A2' then (select AddLine2 from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')             

 ELSE TERADDLINE2 END  + ' '  +                                                                    

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRADDRESS3           

 when AD.AddressType='A1' then (select Landmark from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')              

 when AD.AddressType='A2' then (select Landmark from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')               

 ELSE TERLANDMARK END  + ' ' +      

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRCITY         

 when AD.AddressType='A1' then (select City from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

 when AD.AddressType='A2' then (select City from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')           

 ELSE T.TERCITY END +  ' ' +                                

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRSTATE         

 when AD.AddressType='A1' then (select State from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

 when AD.AddressType='A2' then (select State from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')           

 ELSE TERSTATE END + ' ' +                

 CASE WHEN B.STSBTAG=B.STBRTAG THEN d.STBRZIP         

 when AD.AddressType='A1' then (select Pincode from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ABL')            

 when AD.AddressType='A2' then (select Pincode from [MIS].sb_comp.dbo.sb_contact_terminal with(nolock) where SBTag=AD.SBTag and Company='ACBPL')           

 ELSE TERPINCODE END   as [Terminal Address],(STREGNOPRIFIX +''+ STREGNO) AS [NCFM/BCSM Regn No],        

 case when CONVERT(VARCHAR(11),C.DTVALIDITYDATE,103)='01/01/1900' then '' else  CONVERT(VARCHAR(11),C.DTVALIDITYDATE,103) end AS VALIDUpTo     

     

 into #temp    

 from [INTRANET].CTCLNEW.dbo.tbl_CtclId b with(nolock)        

 left join [INTRANET].CTCLNEW.dbo.V_EMPMASTER c with(nolock)        

 on b.stIntSysRefNo=c.stIntSysRefNo        

 LEFT OUTER JOIN                                             

 [INTRANET].CTCLNEW.dbo.TBL_BRANCHMASTER d with(nolock)                                            

ON                                             

 B.STBRTAG=d.STBRTAG          

 LEFT OUTER JOIN                                  

[INTRANET].CTCLNEW.dbo.tbl_CtclAddTransaction Ad  with(nolock)                                

ON                                      

B.STINTSYSREFNO=Ad.STINTSYSREFNO           

LEFT OUTER JOIN                                        

[MIS].SB_COMP.DBO.VW_SUBBROKER_DETAILS T    with(nolock)                                         

ON                                             

B.STSBTAG=T.SBTAG          

where b.stSBTag=@SBTag and b.stStatus='A'        

        

        

      

       select  * into #TEMP2 from (  

     select  [Login/Odin Id] ,UserName ,[Terminal Address] ,Row=ROW_NUMBER() over ( partition by [Login/Odin Id] order by [Login/Odin Id] )  from #temp  

     group by [Login/Odin Id] ,UserName ,[Terminal Address]  

     )a  where Row=1  

         

      

  select [Login/Odin Id] ,Segment=Replace(REPLACE((    

  isnull([MCXSX-MCXSX],'0')+','+isnull([NSE-CDS],'0')+','+isnull([NCDEX-NCDEX],'0')+','  

  +isnull([NSE-FO],'0')+','+isnull([MCX-MCX],'0')+','+isnull([BSE-CDS],'0')+','+isnull([NSE-MFSS],'0')+','+isnull([BSE-FO],'0')+','+isnull([NSE-CASH],'0')+','+isnull([NSE-IRFC],'0')+','+isnull([BSE-CASH],'0')),'0,',''),',0','')    

   into #temp3 from(      

  select [Login/Odin Id] ,Segment    from #temp      

  ) as A    

  pivot     

  (min(segment) for segment in     

    

 ([MCXSX-MCXSX],[NSE-CDS],[NCDEX-NCDEX],[NSE-FO],[MCX-MCX],[BSE-CDS],[NSE-MFSS],[BSE-FO],[NSE-CASH],[NSE-IRFC],[BSE-CASH]) ) as pvt    

      

    

    select  TEMP2.[Login/Odin Id] ,temp2 .UserName,temp2 .[Terminal Address],Segment  from #TEMP2 temp2 join #temp3 temp3 on temp2. [Login/Odin Id]=temp3 .[Login/Odin Id]   

      

    

      

End

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
-- PROCEDURE dbo.sp_findstring
-- --------------------------------------------------
create procedure [dbo].[sp_findstring]    

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


create PROC [dbo].[sp_generate_inserts]
(
	@table_name varchar(776),  		-- The table/view for which the INSERT statements will be generated using the existing data
	@target_table varchar(776) = NULL, 	-- Use this parameter to specify a different table name into which the data will be inserted
	@include_column_list bit = 1,		-- Use this parameter to include/ommit column list in the generated INSERT statement
	@from varchar(800) = NULL, 		-- Use this parameter to filter the rows based on a filter condition (using WHERE)
	@include_timestamp bit = 0, 		-- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement
	@debug_mode bit = 0,			-- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination
	@owner varchar(64) = NULL,		-- Use this parameter if you are not the owner of the table
	@ommit_images bit = 0,			-- Use this parameter to generate INSERT statements by omitting the 'image' columns
	@ommit_identity bit = 0,		-- Use this parameter to ommit the identity columns
	@top int = NULL,			-- Use this parameter to generate INSERT statements only for the TOP n rows
	@cols_to_include varchar(8000) = NULL,	-- List of columns to be included in the INSERT statement
	@cols_to_exclude varchar(8000) = NULL,	-- List of columns to be excluded from the INSERT statement
	@disable_constraints bit = 0,		-- When 1, disables foreign key constraints and enables them after the INSERT statements
	@ommit_computed_cols bit = 0		-- When 1, computed columns will not be included in the INSERT statement
	
)
AS
BEGIN

/***********************************************************************************************************
Procedure:	sp_generate_inserts  (Build 22) 
		(Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.)
                                          
Purpose:	To generate INSERT statements from existing data. 
		These INSERTS can be executed to regenerate the data at some other location.
		This procedure is also useful to create a database setup, where in you can 
		script your data along with your table definitions.

Written by:	Narayana Vyas Kondreddi
	        http://vyaskn.tripod.com

Acknowledgements:
		Divya Kalra	-- For beta testing
		Mark Charsley	-- For reporting a problem with scripting uniqueidentifier columns with NULL values
		Artur Zeygman	-- For helping me simplify a bit of code for handling non-dbo owned tables
		Joris Laperre   -- For reporting a regression bug in handling text/ntext columns

Tested on: 	SQL Server 7.0 and SQL Server 2000

Date created:	January 17th 2001 21:52 GMT

Date modified:	May 1st 2002 19:50 GMT

Email: 		vyaskn@hotmail.com

NOTE:		This procedure may not work with tables with too many columns.
		Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types
		Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results
		IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed
		you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts
		like nchar and nvarchar
		

Example 1:	To generate INSERT statements for table 'titles':
		
		EXEC sp_generate_inserts 'titles'

Example 2: 	To ommit the column list in the INSERT statement: (Column list is included by default)
		IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,
		to avoid erroneous results
		
		EXEC sp_generate_inserts 'titles', @include_column_list = 0

Example 3:	To generate INSERT statements for 'titlesCopy' table from 'titles' table:

		EXEC sp_generate_inserts 'titles', 'titlesCopy'

Example 4:	To generate INSERT statements for 'titles' table for only those titles 
		which contain the word 'Computer' in them:
		NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter

		EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"

Example 5: 	To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:
		(By default TIMESTAMP column's data is not scripted)

		EXEC sp_generate_inserts 'titles', @include_timestamp = 1

Example 6:	To print the debug information:
  
		EXEC sp_generate_inserts 'titles', @debug_mode = 1

Example 7: 	If you are not the owner of the table, use @owner parameter to specify the owner name
		To use this option, you must have SELECT permissions on that table

		EXEC sp_generate_inserts Nickstable, @owner = 'Nick'

Example 8: 	To generate INSERT statements for the rest of the columns excluding images
		When using this otion, DO NOT set @include_column_list parameter to 0.

		EXEC sp_generate_inserts imgtable, @ommit_images = 1

Example 9: 	To generate INSERT statements excluding (ommiting) IDENTITY columns:
		(By default IDENTITY columns are included in the INSERT statement)

		EXEC sp_generate_inserts mytable, @ommit_identity = 1

Example 10: 	To generate INSERT statements for the TOP 10 rows in the table:
		
		EXEC sp_generate_inserts mytable, @top = 10

Example 11: 	To generate INSERT statements with only those columns you want:
		
		EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"

Example 12: 	To generate INSERT statements by omitting certain columns:
		
		EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"

Example 13:	To avoid checking the foreign key constraints while loading data with INSERT statements:
		
		EXEC sp_generate_inserts titles, @disable_constraints = 1

Example 14: 	To exclude computed columns from the INSERT statement:
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
DECLARE		@Column_ID int, 		
		@Column_List varchar(8000), 
		@Column_Name varchar(128), 
		@Start_Insert varchar(786), 
		@Data_Type varchar(128), 
		@Actual_Values varchar(8000),	--This is the string that will be finally executed to generate INSERT statements
		@IDN varchar(128)		--Will contain the IDENTITY column's name in the table

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

SELECT	@Column_ID = MIN(ORDINAL_POSITION) 	
FROM	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE 	TABLE_NAME = @table_name AND
(@owner IS NULL OR TABLE_SCHEMA = @owner)



--Loop through all the columns of the table, to get the column names and their data types
WHILE @Column_ID IS NOT NULL
	BEGIN
		SELECT 	@Column_Name = QUOTENAME(COLUMN_NAME), 
		@Data_Type = DATA_TYPE 
		FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
		WHERE 	ORDINAL_POSITION = @Column_ID AND 
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

		SELECT 	@Column_ID = MIN(ORDINAL_POSITION) 
		FROM 	INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
		WHERE 	TABLE_NAME = @table_name AND 
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
				SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
			END
		ELSE
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'
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
				SELECT 	'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL'  AS '--Code to enable the previously disabled constraints'
			END
		ELSE
			BEGIN
				SELECT 	'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'
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
-- PROCEDURE dbo.USP_annecture_details
-- --------------------------------------------------
CREATE proc USP_annecture_details  
@SB_Tag as varchar(20),  
@Actual_Address as varchar(max),  
@Actual_user as varchar(max),  
@terminal as varchar(max)  
as  
begin  
  
        update Tbl_annexture  
        set  
        Actual_Address = @Actual_Address,  
        Actual_user = @Actual_user,  
        Terminal_Active = @terminal  
        where sb_Login_ID = @SB_Tag  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Excption
-- --------------------------------------------------
create PROC [dbo].[USP_Excption]  
@Source varchar(30)='',  
@Message varchar(max)='',  
@UserId varchar(50)='',  
@IP varchar(50)=''  
  
AS BEGIN      
    INSERT INTO tbl_Exceptionlog(Source,Message,UserId,IP,OccuredOn)  
    VALUES (@Source,@Message,@UserId,@IP,getdate())  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_SACC_DASHBOARD
-- --------------------------------------------------




-- =============================================

-- Author:		Suraj Patil 

-- Create date: 05-04-2016

-- Description:	used to get dashboard data 

--USP_GET_SACC_DASHBOARD '','','INDORE'

-- =============================================

CREATE PROCEDURE [dbo].[USP_GET_SACC_DASHBOARD]

	@ZONE AS VARCHAR(100)='',

	@REGION AS VARCHAR(100)='',

	@BRANCH AS VARCHAR(100)=''

AS

BEGIN       

            DECLARE @BRANCH_TAG  AS VARCHAR(50)

            SELECT @BRANCH_TAG = BRANCH FROM BRANCH_MASTER WHERE BRANCHNAME = @BRANCH

            

            SET @BRANCH = @BRANCH_TAG

            

           

            

            DECLARE @TOTAL AS INT

            DECLARE @COUNT AS INT

            DECLARE @COMPLETED AS INT

            DECLARE @INCOMPLETED AS INT

            DECLARE @COUNT1 INT 

            DECLARE @Counter INT  

            DECLARE @MaxOscars INT 

            

            DECLARE @COMPLIANCE AS DECIMAL(38,2)  

            DECLARE @NONCOMPLIANCE AS DECIMAL(38,2)  

            DECLARE @NOT_APPLICABLE AS DECIMAL(38,2) 

            

             DECLARE @COMPLIANCE1 AS INT

            

            DECLARE @str AS VARCHAR(MAX)

            SET @str = '' 

            DECLARE  @TABLE2 AS TABLE(QNO  INT,COMPLIANCE  DECIMAL(38,2), NONCOMPLIANCE  DECIMAL(38,2), NOT_APPLICABLE  DECIMAL(38,2))

            DECLARE  @TABLE1 AS TABLE(TOTAL  INT,COMPLETE INT,INCOMPLETE  INT)

            

            

            if @ZONE <> '' or @REGION <> '' or @BRANCH <>''

            begin

                                -- DATA FOR CHART

                                

                                     declare @str1 as varchar(max)

                                        set @str1 = ''

                                        if @ZONE <> '' 

                                        begin

                                        set  @str1 = @str1 + 'where ZONE = '''+@ZONE +''''

                                        end

                                        else if @REGION <> '' 

                                        begin

                                        set  @str1 = @str1 + 'where region = '''+@REGION+''''

                                        end

                                        else if @BRANCH <> '' 

                                        begin

                                        set  @str1 = @str1 + 'where branch = '''+@BRANCH +''''

                                        end

                                        



                                        set @str = ' SELECT @TOTAL = COUNT(DISTINCT SBTAG) FROM [MIS].SB_COMP.dbo.VW_ACTIVESACC_BROKER ' + @str1

                                        declare @Sql nvarchar(max) = @str

                                        declare @max int

                                        set @max = 0

                                        print @str

                                        exec sp_executesql @Sql, N'@TOTAL int out',@TOTAL out

                                        

                                        

                                                    

                                        

                                        set @str = 'SELECT @COUNT =COUNT( Entry_Id) FROM Tbl_answer where sbtag in (select sb_login_id from tbl_annexture '+@str1+' )'  

                                        set @str=REPLACE(@str,'branch','branch_tag')

                                        set @Sql = @str

                                         print @str

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@COUNT int out',@COUNT out

                                        





                                       

                                        set @str = 'SELECT @COMPLETED =COUNT( Entry_Id) FROM Tbl_answer WHERE Is_Verified = 1 and sbtag in (select sb_login_id from tbl_annexture '+@str1+' )'  

                           set @str=REPLACE(@str,'branch','branch_tag')

                                        set @Sql = @str

                                         print @str

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@COMPLETED int out',@COMPLETED out

                                        set @COMPLETED = @COMPLETED







                                        --SELECT @COUNT =COUNT( Entry_Id) FROM Tbl_answer

                                        --SELECT @COMPLETED =COUNT( Entry_Id) FROM Tbl_answer WHERE Is_Verified = 1

                                        

                                        

                                        

                                        SET @INCOMPLETED = @COUNT - @COMPLETED



                                        insert into @TABLE1 values (@TOTAL,@COMPLETED,@INCOMPLETED) 

                                        --SELECT A.* INTO @TABLE1 FROM (SELECT @TOTAL AS TOTAL,@COMPLETED AS COMPLETE,@INCOMPLETED AS INCOMPLETE)A



                                        SELECT * FROM  @TABLE1



                                        -- DATA FOR GRAPH

                                        

                                        --DECLARE @COUNT1 INT

                                        

                                        set @str = 'SELECT @COUNT1 = COUNT(1) FROM Tbl_answer WHERE Is_Verified = 1 and sbtag in (select sb_login_id from tbl_annexture '+@str1+' )'  

                                         set @str=REPLACE(@str,'branch','branch_tag')

                                        set @Sql = @str

                                         print @str

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@COUNT1 int out',@COUNT1 out

                                        set @COUNT1 = @COUNT1

                                        

                                        --SELECT @COUNT1 = COUNT(1) FROM Tbl_answer WHERE Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1) 

                                        

                                        

                                        --DECLARE @Counter INT

                                        --DECLARE @MaxOscars INT

                                        SET @Counter = 1

                                        SET @MaxOscars = 38



                                        --DECLARE @COMPLIANCE AS DECIMAL(38,2)

                                        --DECLARE @NONCOMPLIANCE AS DECIMAL(38,2)

                                        --DECLARE @NOT_APPLICABLE AS DECIMAL(38,2)

                                        --DECLARE  @TABLE2 AS TABLE(QNO  INT,COMPLIANCE  DECIMAL(38,2), NONCOMPLIANCE  DECIMAL(38,2), NOT_APPLICABLE  DECIMAL(38,2))



                                        WHILE @Counter <= @MaxOscars

                                        BEGIN

                                        print @str1

                                        set @str = 'SELECT @COMPLIANCE1 = COUNT(1) FROM Tbl_tr_answer WHERE Question_no = '+cast (@Counter as varchar(10))+' AND Maker_ans IN ( ''Compliance'' , ''Yes'' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHE
RE Is_Verified = 1 and sbtag in (select sb_login_id from tbl_annexture '+@str1+') )'

                                         set @str=REPLACE(@str,'branch','branch_tag')  

                                        set @Sql = @str

                                        print @Sql

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@COMPLIANCE1 int out',@COMPLIANCE1 out

                                        print @COMPLIANCE1

                                        set @COMPLIANCE = CAST( @COMPLIANCE1 as float)

                                       



                                       

                                        --SELECT @COMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Compliance' , 'Yes' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)

                                        

                                        set @str = 'SELECT @NONCOMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no='+cast (@Counter as varchar(10))+' AND Maker_ans IN ( ''Not compliance'' , ''No'' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1 and sbtag in (select sb_login_id from tbl_annexture '+@str1+') )' 

                                         set @str=REPLACE(@str,'branch','branch_tag') 

                                        set @Sql = @str

                                         print @str

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@NONCOMPLIANCE int out',@NONCOMPLIANCE out

                                        set @NONCOMPLIANCE = @NONCOMPLIANCE

                                        

                                        

                                        --SELECT @NONCOMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Not compliance' , 'No' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)

                                         print @str

                                         set @str = 'SELECT @NOT_APPLICABLE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no='+cast (@Counter as varchar(10))+' AND Maker_ans =''Not applicable''  AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1 and sbtag in (select sb_login_id from tbl_annexture '+@str1+') )'  

                                          set @str=REPLACE(@str,'branch','branch_tag')

                                        set @Sql = @str

                                         print @str

                                        set @max = 0

                                        exec sp_executesql @Sql, N'@NOT_APPLICABLE int out',@NOT_APPLICABLE out

                                        set @NOT_APPLICABLE = @NOT_APPLICABLE

                                        

                                        

                                        

                                        --SELECT @NOT_APPLICABLE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans ='Not applicable' AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1) 

                                        

                                        --INSERT INTO @TABLE2 VALUES(@Counter,((@COMPLIANCE/@COUNT1)*100),((@NONCOMPLIANCE/@COUNT1)*100),((@NOT_APPLICABLE/@COUNT1)*100))

                                        INSERT INTO @TABLE2 VALUES(@Counter,CASE WHEN @COUNT1 <> 0 THEN ((@COMPLIANCE/@COUNT1)*100) ELSE 0 END,CASE WHEN @COUNT1 <> 0 THEN((@NONCOMPLIANCE/@COUNT1)*100) ELSE 0 END,CASE WHEN @COUNT1 <> 0 THEN((@NOT_APPLICABLE/@COUNT1)*100)ELSE 0 END)

                                

                                

                                SET @Counter += 1

                                END



                                 SELECT * FROM @TABLE2



            end

            else

            begin

                  -- DATA FOR CHART  

           

  

            SELECT @TOTAL = COUNT(DISTINCT SBTAG) FROM [MIS].SB_COMP.dbo.VW_ACTIVESACC_BROKER  

            SELECT @COUNT =COUNT( Entry_Id) FROM Tbl_answer  

            SELECT @COMPLETED =COUNT( Entry_Id) FROM Tbl_answer WHERE Is_Verified = 1  

            SET @INCOMPLETED = @COUNT - @COMPLETED  

  

            SELECT A.* INTO #TABLE1 FROM (SELECT @TOTAL AS TOTAL,@COMPLETED AS COMPLETE,@INCOMPLETED AS INCOMPLETE)A  

  

            SELECT * FROM  #TABLE1  

  

            -- DATA FOR GRAPH  

              

            --DECLARE @COUNT1 INT 

            SELECT @COUNT1 = COUNT(1) FROM Tbl_answer WHERE Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)   

            

            if(@COUNT1=0)

            begin

				set @COUNT1 = 1

            end

            --DECLARE @Counter INT  

            --DECLARE @MaxOscars INT  

            SET @Counter = 1  

            SET @MaxOscars = 38  

  

            --DECLARE @COMPLIANCE AS DECIMAL(38,2)  

            --DECLARE @NONCOMPLIANCE AS DECIMAL(38,2)  

            --DECLARE @NOT_APPLICABLE AS DECIMAL(38,2)  

            --DECLARE  @TABLE2 AS TABLE(QNO  INT,COMPLIANCE  DECIMAL(38,2), NONCOMPLIANCE  DECIMAL(38,2), NOT_APPLICABLE  DECIMAL(38,2))  

  

            WHILE @Counter <= @MaxOscars  

            BEGIN  

            SELECT @COMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Compliance' , 'Yes' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)  

            SELECT @NONCOMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Not compliance' , 'No' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)  

            SELECT @NOT_APPLICABLE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans ='Not applicable' AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Verified = 1)   

              

            INSERT INTO @TABLE2 VALUES(@Counter,((@COMPLIANCE/@COUNT1)*100),((@NONCOMPLIANCE/@COUNT1)*100),((@NOT_APPLICABLE/@COUNT1)*100))  

              

              

            SET @Counter += 1  

            END  

  

             SELECT * FROM @TABLE2                 

            end





END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_SACC_DASHBOARD_bak
-- --------------------------------------------------




-- =============================================

-- Author:		Suraj Patil 

-- Create date: 05-04-2016

-- Description:	used to get dashboard data 

-- =============================================

CREATE PROCEDURE USP_GET_SACC_DASHBOARD_bak

	@ZONE AS VARCHAR(100)='',

	@REGION AS VARCHAR(100)='',

	@BRANCH AS VARCHAR(100)=''

AS

BEGIN

            -- DATA FOR CHART

            DECLARE @TOTAL AS INT

            DECLARE @COUNT AS INT

            DECLARE @COMPLETED AS INT

            DECLARE @INCOMPLETED AS INT



            SELECT @TOTAL = COUNT(DISTINCT SBTAG) FROM [MIS].SB_COMP.dbo.VW_ACTIVESACC_BROKER

            SELECT @COUNT =COUNT( Entry_Id) FROM Tbl_answer

            SELECT @COMPLETED =COUNT( Entry_Id) FROM Tbl_answer WHERE Is_Complete = 1

            SET @INCOMPLETED = @COUNT - @COMPLETED



            SELECT A.* INTO #TABLE1 FROM (SELECT @TOTAL AS TOTAL,@COMPLETED AS COMPLETE,@INCOMPLETED AS INCOMPLETE)A



            SELECT * FROM  #TABLE1



            -- DATA FOR GRAPH

            

            DECLARE @COUNT1 INT

            SELECT @COUNT1 = COUNT(1) FROM Tbl_answer WHERE Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Complete = 1) 

            DECLARE @Counter INT

            DECLARE @MaxOscars INT

            SET @Counter = 1

            SET @MaxOscars = 38



            DECLARE @COMPLIANCE AS DECIMAL(38,2)

            DECLARE @NONCOMPLIANCE AS DECIMAL(38,2)

            DECLARE @NOT_APPLICABLE AS DECIMAL(38,2)

            DECLARE  @TABLE2 AS TABLE(QNO  INT,COMPLIANCE  DECIMAL(38,2), NONCOMPLIANCE  DECIMAL(38,2), NOT_APPLICABLE  DECIMAL(38,2))



            WHILE @Counter <= @MaxOscars

            BEGIN

            SELECT @COMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Compliance' , 'Yes' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Complete = 1)

            SELECT @NONCOMPLIANCE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans IN ( 'Not compliance' , 'No' ) AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Complete = 1)

            SELECT @NOT_APPLICABLE = COUNT(1) FROM Tbl_tr_answer WHERE Question_no=@Counter AND Maker_ans ='Not applicable' AND Entry_id IN (SELECT Entry_id FROM Tbl_answer WHERE Is_Complete = 1) 

            

            INSERT INTO @TABLE2 VALUES(@Counter,((@COMPLIANCE/@COUNT1)*100),((@NONCOMPLIANCE/@COUNT1)*100),((@NOT_APPLICABLE/@COUNT1)*100))

            

            

            SET @Counter += 1

            END



             SELECT * FROM @TABLE2







END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_insertrecord
-- --------------------------------------------------
-- =============================================
-- Author:	suraj patil
-- Create date: 25-01-2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_insertrecord
@Entry_id as int,
@Question_no as int,
@Question as nvarchar(max),
@Answer as nvarchar(50),
@remark as nvarchar(max)='',
@Attachment as nvarchar(max)='',
@Answered_on as nvarchar(200)='',
@current_tab as int=''
AS
BEGIN
DECLARE @COUNT AS INT=0;  
--SELECT * FROM Tbl_tr_answer WHERE Question_no='2' and Entry_id='1'
SELECT @COUNT= COUNT(*) FROM Tbl_tr_answer WHERE Question_no=@Question_no and Entry_id=@Entry_id

if(@COUNT = 0)
begin
    insert into Tbl_tr_answer(Entry_id,Question_no,Question,Answer,remark,Attachment,Answered_on) values(@Entry_id,@Question_no,@Question,@Answer,@remark,@Attachment,@Answered_on)
end
else
begin
update  Tbl_tr_answer
set Entry_id=@Entry_id,
Question_no =@Question_no,
Question=@Question,
Answer=@Answer,
remark=@remark,
Attachment=@Attachment,
Answered_on=@Answered_on
WHERE Question_no=@Question_no and Entry_id=@Entry_id
end


if(@current_tab <> '')
begin
update tbl_answer
set Current_Tab = @current_tab
where Entry_id=@Entry_id
end

update tbl_answer
set Last_Transaction_Time = GETDATE()
where Entry_id=@Entry_id


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_insertsbtag
-- --------------------------------------------------
-- =============================================
-- Author:	suraj patil
-- Create date: 21-04-2016
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[usp_insertsbtag]
@sbtag as varchar(30)
AS
BEGIN
DECLARE @COUNT AS INT=0;  
--SELECT * FROM Tbl_tr_answer WHERE Question_no='2' and Entry_id='1'
SELECT @COUNT= COUNT(1) FROM TBL_UPLOAD_MASTER WHERE sb_tag=@sbtag 

if(@COUNT = 0)
begin
    insert into TBL_UPLOAD_MASTER values(@sbtag,0)
end

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Question_Master
-- --------------------------------------------------
-- =============================================  
-- Author:  Suraj Patil  
-- Create date:     31-12-2015  
-- Description: <Description,,>  
--USP_Question_Master 'getquestions','dbn'  
-- =============================================  
CREATE PROCEDURE [dbo].[USP_Question_Master]  
    @process varchar(30),  
    @SBTAG nvarchar(30)=''  
      
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    if @process = 'getquestions'  
    begin  
      
    
    select q.Question_no,Q.Question,Q.option1,Q.option2,Q.option3,Q.upload_option,Q.Has_annexture,Q.has_attachment,p.* from ( select * from   Tbl_question_master where isactivated =1 ) q   
    Left outer join   
    (  
    select B.Entry_Id,B.SBTAG,B.Current_Tab,A.Question_no,A.Answer,A.attachment,A.remark from ( select * from Tbl_answer where SBTAG = @SBTAG) b join Tbl_tr_answer a on a.Entry_Id=b.Entry_id  
    ) p  
    on p.Question_no = q.Question_no  order by q.Question_no asc 
   
 end  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Question_Master_MultiLanguage
-- --------------------------------------------------

-- =============================================  
-- Author:  Suraj Patil  
-- Create date:     31-12-2015  
-- Description: <Description,,>  
--USP_Question_Master_MultiLanguage 'getquestions','dbn'  
-- =============================================  
CREATE PROCEDURE [dbo].[USP_Question_Master_MultiLanguage]  
    @process varchar(30),  
    @SBTAG nvarchar(30)='',
    @language varchar(50)='English'  
      
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    if @process = 'getquestions'  
    begin  
      
    
    --select q.Question_no,Q.Question,Q.option1,Q.option2,Q.option3,Q.upload_option,Q.Has_annexture,Q.has_attachment,p.* from ( select * from   Tbl_question_master where isactivated =1 ) q   
    --Left outer join   
    --(  
    --select B.Entry_Id,B.SBTAG,B.Current_Tab,A.Question_no,A.Answer,A.attachment,A.remark from ( select * from Tbl_answer where SBTAG = @SBTAG) b join Tbl_tr_answer a on a.Entry_Id=b.Entry_id  
    --) p  
    --on p.Question_no = q.Question_no  order by q.Question_no asc 

        if @language = 'English'  
        begin 
                --IF OBJECT_ID('tempdb..#english') IS NOT NULL
                --DROP TABLE #english
                select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
                
        end
        else if @language = 'Gujarati'  
        begin  
            --IF OBJECT_ID('tempdb..#guj') IS NOT NULL
            --DROP TABLE #guj 
            select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master_Gujarati  where isactivated = 1   
        end
        else if @language = 'Hindi'  
        begin  
               --IF OBJECT_ID('tempdb..#Hindi') IS NOT NULL
               --DROP TABLE #Hindi 
            select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master_hindi where isactivated = 1   
               
        end  

  

	

	
  
 --   select * into #english from ( select q.Question_no,Q.Question,Q.option1,Q.option2,Q.option3,Q.upload_option,Q.Has_annexture,Q.has_attachment,p.*  from ( select * from   Tbl_question_master where isactivated =1 ) q   
 --   Left outer join   
 --   (  
 --   select B.Entry_Id,B.SBTAG,B.Current_Tab,A.Question_no as 'QnNume',A.Answer,A.attachment,A.remark from ( select * from Tbl_answer where SBTAG = @SBTAG) b join Tbl_tr_answer a on a.Entry_Id=b.Entry_id  
 --   ) p  
 --   on p.QnNume = q.Question_no)as eng


	-- select * into #Hindi from ( select q.Question_no,Q.Question,Q.option1,Q.option2,Q.option3,Q.upload_option,Q.Has_annexture,Q.has_attachment,p.*  from ( select * from   Tbl_question_master_hindi where isactivated =1 ) q   
 --   Left outer join   
 --   (  
 --   select B.Entry_Id,B.SBTAG,B.Current_Tab,A.Question_no as 'QnNume',A.Answer,A.attachment,A.remark from ( select * from Tbl_answer where SBTAG = @SBTAG) b join Tbl_tr_answer a on a.Entry_Id=b.Entry_id  
 --   ) p  
 --   on p.QnNume = q.Question_no)as hin


	--	 select * into #guj from ( select q.Question_no,Q.Question,Q.option1,Q.option2,Q.option3,Q.upload_option,Q.Has_annexture,Q.has_attachment,p.*  from ( select * from   Tbl_question_master_Gujarati where isactivated =1 ) q   
 --   Left outer join   
 --   (  
 --   select B.Entry_Id,B.SBTAG,B.Current_Tab,A.Question_no as 'QnNume',A.Answer,A.attachment,A.remark from ( select * from Tbl_answer where SBTAG = @SBTAG) b join Tbl_tr_answer a on a.Entry_Id=b.Entry_id  
 --   ) p  
 --   on p.QnNume = q.Question_no)as guj
	

	--select en.Question_no,'< span class=''english''>'+en.Question+'</span>'+'< span class=''hindi''>'+hn.Question+'</span>'+'< span class=''Gujrati''>'+guj.Question+'</span>' as Question,
	--'< span class=''english''>'+en.option1+'</span>'+'< span class=''hindi''>'+hn.option1+'</span>'+'< span class=''Gujrati''>'+guj.option1+'</span>' as option1,
	--'< span class=''english''>'+en.option2+'</span>'+'< span class=''hindi''>'+hn.option2+'</span>'+'< span class=''Gujrati''>'+guj.option2+'</span>' as option2,
	--'< span class=''english''>'+en.option3+'</span>'+'< span class=''hindi''>'+hn.option3+'</span>'+'< span class=''Gujrati''>'+guj.option3+'</span>' as option3 ,en.upload_option ,en.Has_annexture,en.has_attachment,en.Entry_Id,en.SBTAG ,en.Current_Tab,en. QnNume,en. Answer,en.attachment,en.remark
	-- from #english en join (select Question_no,Question,option1,option2,option3 from #Hindi) hn
	--on en.Question_no=hn.Question_no
	--join (select Question_no,Question,option1,option2,option3 from #guj) guj
	--on en.Question_no=guj.Question_no 
	--order by en.Question_no

	
   
 end  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sacc_finaldatasubmit
-- --------------------------------------------------
  
  
  
  
  
  
  
  
-- =============================================    
  
-- Author:  Suraj Patil    
  
-- Create date: 28-01-2015    
  
-- Description:     
  
-- =============================================    
  
CREATE PROCEDURE [dbo].[usp_sacc_finaldatasubmit]    
  
--usp_sacc_finaldatasubmit 'yasmir'    
  
 -- Add the parameters for the stored procedure here    
  
 @sbtag varchar(30)    
  
AS    
  
BEGIN    
  
    DECLARE @Entry_id AS INT=0;      
  
    SELECT @Entry_id= Entry_id FROM Tbl_answer WHERE sbtag=@sbtag      
  
    PRINT @Entry_id     
  
    DECLARE @count AS INT=0;      
  
    DECLARE @Questioncount AS INT=0;      
  
    SELECT @Questioncount= COUNT(1) FROM Tbl_question_master WHERE isactivated =1  
  
    SELECT @count= COUNT(1) FROM Tbl_tr_answer WHERE Entry_id = @Entry_id      
  
    PRINT @count     
  
    if ( @count = @Questioncount)    
  
    begin     
  
            update Tbl_answer    
  
            set Is_Complete = 1,    
  
            Complete_Date = GETDATE(),    
  
            Current_Tab = -1    
  
            where  sbtag = @sbtag    
  
      
  
   DECLARE @complint AS INT=0;      
  
   SELECT @complint= COUNT(1) from Tbl_tr_answer where Entry_id = @Entry_id and Answer not in ('Not Applicable','Compliant','yes')      
  
   PRINT @complint     
  
  
  
   if(@complint > 0)    
  
   begin    
  
  
  
    update Tbl_answer    
  
    set Is_Compliance = 0    
  
    where  sbtag = @sbtag    
  
   end    
  
   else    
  
   begin    
  
    update Tbl_answer    
  
    set Is_Compliance = 1    
  
    where  sbtag = @sbtag    
  
   end    
  
  
  
   SELECT @COUNT = isnull(Email_Ack,0) FROM Tbl_answer WHERE sbtag=@sbtag    
  
   print @count  
  
   if @COUNT <> 1     
  
   begin    
  
  
  
     --attachment start  
  
     truncate table temp1  
  
     insert into temp1 values(0,'Question','Answer','remark','','','')  
  
     insert into temp1(Question_no,Question,Answer,remark) 
	 select REPLACE(REPLACE(replace(Question_no, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Question, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Answer, ',', ''), CHAR(13), ''), CHAR(10), ''), REPLACE(REPLACE(replace(remark, ',', ' '), CHAR(13), ''), CHAR(10), '') 
	 from compliance.dbo.Tbl_tr_answer where Entry_id = @Entry_id  
  
     declare  @SQLStatement as varchar(2000)  
  
     select @SQLStatement = 'bcp " select * from compliance.dbo.temp1  " queryout \\INHOUSELIVEAPP2-FS.angelone.in\d$\upload_sacc\compliance.csv /c /t, -T -S' + @@servername  
  
     exec master..xp_cmdshell @SQLStatement   
  
     print @SQLStatement    
  
  
  
  
  
     declare @strAttach varchar(max)                              
  
     set @strAttach = '\\INHOUSELIVEAPP2-FS.angelone.in\d$\upload_sacc\compliance.csv'     
  
     --attachment end  
  
  
  
  
  
     declare @mobile as varchar(20)  
  
     --set @mobile = '9860229924'  
  
     declare @branch as varchar(20)  
  
     set @branch = ''  
  
     select @branch=branch_tag from Tbl_annexture where sb_Login_ID =@sbtag  
  
     declare @sms_msg as varchar(max)  
  
     set @sms_msg = ''  
  
     declare @toaddress as varchar(max)  
  
     set @toaddress = ''  
  
     select @toaddress = Email from Tbl_annexture where sb_Login_ID =@sbtag  
  
     set @toaddress = @toaddress   
  
     declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)    
  
     set @Orisubject = (select [SUBJECT] from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )    
  
     set @Orisubject = upper(@branch) +'/'+upper(@sbtag)+' - '+@Orisubject  
  
     set @fromAddress=(select from_address from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )    
  
     set @oribody = (select body from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0  )    
  
  
  
     EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL      
  
     @subject = @Orisubject,    
  
     @from_address = @fromAddress,    
  
     @body = @oribody,-- ,    
  
     @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc    
  
     @RECIPIENTS = @toaddress,    
  
     @copy_recipients = 'sbsupport@angelbroking.com',  
  
     @body_format = 'html',  
  
     @file_attachments=@strAttach    
  
     --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag    
  
     --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 ,   
  
  
  
     update Tbl_answer  
  
     set Email_Ack =1  
  
     where SBTAG=@sbtag   
  
   End   
  
  
  
   SELECT @COUNT = isnull(sms_Ack,0) FROM Tbl_answer WHERE sbtag=@sbtag    
  
   print @count  
  
   if @COUNT <> 1     
  
   begin    
  
    ----------------sms start----------------------------  
  
    -- declare @mobile as varchar(20)  
  
    -- set @mobile = ''  
  
    -- select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag   
  
    --insert into [196.1.115.132].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)    
  
    -- select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from       
  
    -- (      
  
    -- select '9930617289' as No,  
  
    -- 'Dear Partner, you have successfully submitted Self Assessment Compliance Checklist (SACC) for '''+@sbtag+'''. We will get back to you shortly' as sms_msg ,  
  
    -- convert(varchar(10), getdate(), 103) as sms_dt,  
  
    -- ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,  
  
    -- 'P' as flag,  
  
    -- case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,  
  
    -- 'SB_SACC_Submit'as Purpose  
  
    -- )a    
  
  
  
  
  
    select @sms_msg = BODY from Tbl_SACC_SMSMaster where purpose = 'SB_SACC_Submit' and isdelete = 0  
  
    set @sms_msg= REPLACE( @sms_msg, '@sbtag', @sbtag )  
  
    print @sms_msg   
  
    select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag   
  
  
  
    insert into [INTRANET].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)    
  
    select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from       
  
    (      
  
    select @mobile as No,  
  
    @sms_msg as sms_msg ,  
  
    convert(varchar(10), getdate(), 103) as sms_dt,  
  
    ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,  
  
    'P' as flag,  
  
    case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,  
  
    'SB_SACC_Submit'as Purpose  
  
    )a      
  
  
  
    ----------------sms end----------------------------  
  
  
  
    update Tbl_answer  
  
    set sms_Ack =1  
  
    where SBTAG=@sbtag   
  
   End     
  
  
  
 end    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sacc_finaldatasubmit02082016
-- --------------------------------------------------



-- =============================================  
-- Author:  Suraj Patil  
-- Create date: 28-01-2015  
-- Description:   
-- =============================================  
create PROCEDURE [dbo].[usp_sacc_finaldatasubmit02082016]  
--usp_sacc_finaldatasubmit 'hst'  
 -- Add the parameters for the stored procedure here  
 @sbtag varchar(30)  
AS  
BEGIN  
    DECLARE @Entry_id AS INT=0;    
    SELECT @Entry_id= Entry_id FROM Tbl_answer WHERE sbtag=@sbtag    
    PRINT @Entry_id   
    DECLARE @count AS INT=0;    
    SELECT @count= COUNT(1) FROM Tbl_tr_answer WHERE Entry_id = @Entry_id    
    PRINT @count   
    if ( @count = 39)  
    begin   
    update Tbl_answer  
    set Is_Complete = 1,  
    Complete_Date = GETDATE(),  
    Current_Tab = -1  
    where  sbtag = @sbtag  
    end  
    DECLARE @complint AS INT=0;    
    SELECT @complint= COUNT(1) from Tbl_tr_answer where Entry_id = @Entry_id and Answer not in ('Not Applicable','Compliant','yes')    
    PRINT @complint   
      
    if(@complint > 0)  
    begin  
   
    update Tbl_answer  
    set Is_Compliance = 0  
    where  sbtag = @sbtag  
    end  
    else  
    begin  
    update Tbl_answer  
    set Is_Compliance = 1  
    where  sbtag = @sbtag  
      
    end  
  
   SELECT @COUNT = isnull(Email_Ack,0) FROM Tbl_answer WHERE sbtag=@sbtag  
      print @count
   if @COUNT <> 1   
   begin  
      declare @mobile as varchar(20)
      set @mobile = '9860229924'
      declare @branch as varchar(20)
      set @branch = ''
      select @branch=branch_tag from Tbl_annexture where sb_Login_ID =@sbtag
      declare @sms_msg as varchar(max)
      set @sms_msg = ''
      declare @toaddress as varchar(max)
      set @toaddress = ''
      select @toaddress = Email from Tbl_annexture where sb_Login_ID =@sbtag
      set @toaddress = @toaddress + ';pramod.jadhav@angelbroking.com;suraj.patil@angelbroking.com;kinnari.solanki@angelbroking.com'
      declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)  
      set @Orisubject = (select [SUBJECT] from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )  
      set @Orisubject = upper(@branch) +'/'+upper(@sbtag)+' - '+@Orisubject
      set @fromAddress=(select from_address from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )  
      set @oribody = (select body from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0  )  
      EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL    
      @subject = @Orisubject,  
      @from_address = @fromAddress,  
      @body = @oribody,-- ,  
      @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc  
      @RECIPIENTS = @toaddress,  
      @copy_recipients = 'sbsupport@angelbroking.com',
      @body_format = 'html'  
      --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag  
      --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 , 
 
      update Tbl_answer
      set Email_Ack =1
      where SBTAG=@sbtag 
    End 
    
     SELECT @COUNT = isnull(sms_Ack,0) FROM Tbl_answer WHERE sbtag=@sbtag  
      print @count
   if @COUNT <> 1   
   begin  
              ----------------sms start----------------------------
       -- declare @mobile as varchar(20)
       -- set @mobile = ''
       -- select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag 
       --insert into [196.1.115.132].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)  
       -- select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from     
       -- (    
       -- select '9930617289' as No,
       -- 'Dear Partner, you have successfully submitted Self Assessment Compliance Checklist (SACC) for '''+@sbtag+'''. We will get back to you shortly' as sms_msg ,
       -- convert(varchar(10), getdate(), 103) as sms_dt,
       -- ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,
       -- 'P' as flag,
       -- case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,
       -- 'SB_SACC_Submit'as Purpose
       -- )a  
       

        select @sms_msg = BODY from Tbl_SACC_SMSMaster where purpose = 'SB_SACC_Submit' and isdelete = 0
        set @sms_msg= REPLACE( @sms_msg, '@sbtag', @sbtag )
        print @sms_msg 
        select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag 

        insert into [196.1.115.132].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)  
        select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from     
        (    
        select @mobile as No,
        @sms_msg as sms_msg ,
        convert(varchar(10), getdate(), 103) as sms_dt,
        ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,
        'P' as flag,
        case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,
        'SB_SACC_Submit'as Purpose
        )a    
          
      ----------------sms end----------------------------
 
      update Tbl_answer
      set sms_Ack =1
      where SBTAG=@sbtag 
    End   
      
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS
-- --------------------------------------------------


  --USP_SACC_GETCLIENTDETAILS 'gds'    

CREATE PROC [dbo].[USP_SACC_GETCLIENTDETAILS]      

      @SBTAG VARCHAR(50)='',

      @language varchar(50)='English'     

AS      

BEGIN      

DECLARE @SBCOUNT AS INT=0;  

declare @cnt1 as int =0;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  



select @cnt1 =COUNT(1) from Tbl_answer with(nolock) where SBTAG=@SBTAG 

    

SELECT @SBCOUNT= COUNT(sb_Login_ID) FROM Tbl_annexture  with(nolock) WHERE sb_Login_ID=@SBTAG      

PRINT @sbCOUNT     

  DECLARE @entry_id AS INT=0;       

IF(@SBCOUNT=0 and @cnt1=0)      

BEGIN      

    SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,      

             CASE      

              WHEN SEGMENT='BSE'      

              THEN 'BSE'      

              WHEN SEGMENT='BSEFO'      

              THEN 'BSE'      

              WHEN SEGMENT='MCX'      

              THEN 'MCX'      

              WHEN SEGMENT='MCX CURRENCY'      

              THEN 'MCD'      

              WHEN SEGMENT='NCDX'      

              THEN 'NCX'      

              WHEN SEGMENT='NSE'      

              THEN 'NSE'      

              WHEN SEGMENT='NSE CURRENCY'      

              THEN 'NSX'      

              WHEN SEGMENT='NSEFO'      

              THEN 'NSE'      

              ELSE SEGMENT      

             END AS 'EXCHANGE',      

             CASE      

             WHEN SEGMENT='BSE'      

             THEN 'CASH'      

             WHEN SEGMENT='BSEFO'      

             THEN 'FUTURES'      

             WHEN SEGMENT='MCX'      

             THEN 'FUTURES'      

             WHEN SEGMENT='MCX CURRENCY'      

             THEN 'FUTURES'      

             WHEN SEGMENT='NCDX'      

             THEN 'FUTURES'      

             WHEN SEGMENT='NSE'      

             THEN 'CASH'      

             WHEN SEGMENT='NSE CURRENCY'      

             THEN 'FUTURES'      

             WHEN SEGMENT='NSEFO'      

             THEN 'FUTURES'      

             ELSE SEGMENT      

             END AS 'SEGMENTS',      

  SEGMENT INTO #TEMPSEG      

    FROM [MIS].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC   with(nolock)    

    WHERE SBTAG=@SBTAG      

 AND AppStatus IS NOT NULL      

    ORDER BY SEGMENT ASC;      

    DECLARE @MAX AS INT=0;      

    SELECT @MAX=MAX( isnull( ID,0))      

    FROM #TEMPSEG;      

    DECLARE @CNT AS INT=0;      

    DECLARE @STR AS VARCHAR(200)='';      

    DECLARE @STREXCH AS VARCHAR(200)='';      

    WHILE @MAX>@CNT      

    BEGIN      

    SET @CNT=@CNT+1;      

    DECLARE @STRTEMP AS VARCHAR(50);      

    DECLARE @STRTEMPEXCH AS VARCHAR(50);      

    SELECT @STRTEMP=SEGMENTS,      

  @STRTEMPEXCH=EXCHANGE      

    FROM #TEMPSEG      

    WHERE ID=@CNT;      

    SET @STR=@STRTEMP+','+@STR;      

    SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;      

    END;      

    insert into Tbl_annexture      

    SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,      

     '' as Actual_Address, @STREXCH AS 'Exchange', @STR AS 'Segment',[REGISTERED NAME] AS Approved_User, '-' AS Relation_with_approved_user,'' as new_branch_tag,'' as new_sb_tag,'' as new_user_name,'' as new_certificate_no,'' as new_user_pan_no, BRANCH as


    branch_tag,PANNO as pan_no ,Email,Mobile,'' as Actual_user, '' as Terminal_Active,'' as region, '' as zone, '' as verified_date ,'' as category

    FROM [MIS].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  with(nolock)     

    WHERE SBTAG=@SBTAG;    

            declare @zone as varchar(50)  

            declare @region as varchar(50)  

            select @zone = zone,@region=region from [INTRANET].SMS.DBO.CLIENT_VERTICAL_DETAILS  with(nolock) where SB = @SBTAG  

            --select @region = region from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  

      

      

        update Tbl_annexture  

        set zone=@zone,  

        region = @region  

         WHERE sb_Login_ID=@SBTAG 

        

         DECLARE @CATEGORY AS VARCHAR(50)

         SET @CATEGORY =''

         

         SELECT  top 1 @CATEGORY = sb_category from [CSOKYC-6].general.DBO.Vw_RMS_Client_Vertical  with(nolock) where SB=@SBTAG

        

         update Tbl_annexture 

         set category = @CATEGORY

         WHERE sb_Login_ID=@SBTAG 

          

        

          

          

    insert into Tbl_segment_details       

    SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,      

  STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],      

           CASE      

          WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'      

          THEN '-'      

          ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)      

           END AS VALIDUPTO       

    FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)      

    LEFT JOIN      

    INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)      

    ON B.STINTSYSREFNO=C.STINTSYSREFNO      

    WHERE B.STSBTAG=@SBTAG      

 AND B.STSTATUS='A'      

 AND STREGNOPRIFIX+''+STREGNO IS NOT NULL      

 AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';      

          

      insert into Tbl_answer([SBTAG],Current_tab,is_compliance,is_complete,Last_Transaction_Time,complete_date) values(@SBTAG,1,0,0,GETDATE(),'')      

      DROP TABLE #TEMPSEG;      

      select a.Actual_user,a.Terminal_Active,a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      

 from Tbl_annexture a      

 inner join  Tbl_answer b      

 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG      

     

         select * from Tbl_segment_details where sbtag=@SBTAG     

         select Current_Tab from Tbl_answer where sbtag=@SBTAG     

         SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    

         select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no    

         --select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1

           exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag ,@language

         create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(200),Segment varchar(50))

         insert into #table

         exec sp_CTCL_new @sbtag 



         insert into tbl_terminaldetails(Entryid,OdianID,ActualUserName  ,TerminalAddress,segment,sbtag)

         select @entry_id as Entryid, a.[Login/Odin Id] as OdianID,a.[UserName] as ActualUserName,a.[Terminal Address] as terminaladdress,	a.[Segment] as segment,@SBTAG from (select * from #table)a

         drop table #table

         select * from tbl_terminaldetails where entryid=@entry_id

                  

  END      

  ELSE      

  BEGIN      

   select a.Actual_user,a.Terminal_Active, a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      

 from Tbl_annexture a      

 inner join  Tbl_answer b      

 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG        

  select * from Tbl_segment_details  with(nolock) where sbtag=@SBTAG     

   select Current_Tab from Tbl_answer  with(nolock) where sbtag=@SBTAG     

      

    SELECT @entry_id= entry_id FROM Tbl_answer  with(nolock) WHERE sbtag=@SBTAG    

    select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no 

    -- select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1

    exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag,@language

     

      select * from tbl_terminaldetails  with(nolock) where entryid=@entry_id 

  END   

  

  SET TRANSACTION ISOLATION LEVEL READ COMMITTED    

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS_20072016
-- --------------------------------------------------
  --USP_SACC_GETCLIENTDETAILS 'gds'    
create PROC [dbo].[USP_SACC_GETCLIENTDETAILS_20072016]      
      @SBTAG VARCHAR(50)='',
      @language varchar(50)='English'     
AS      
BEGIN      
DECLARE @SBCOUNT AS INT=0;      
SELECT @SBCOUNT= COUNT(sb_Login_ID) FROM Tbl_annexture WHERE sb_Login_ID=@SBTAG      
PRINT @sbCOUNT     
  DECLARE @entry_id AS INT=0;       
IF(@SBCOUNT=0)      
BEGIN      
    SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,      
             CASE      
              WHEN SEGMENT='BSE'      
              THEN 'BSE'      
              WHEN SEGMENT='BSEFO'      
              THEN 'BSE'      
              WHEN SEGMENT='MCX'      
              THEN 'MCX'      
              WHEN SEGMENT='MCX CURRENCY'      
              THEN 'MCD'      
              WHEN SEGMENT='NCDX'      
              THEN 'NCX'      
              WHEN SEGMENT='NSE'      
              THEN 'NSE'      
              WHEN SEGMENT='NSE CURRENCY'      
              THEN 'NSX'      
              WHEN SEGMENT='NSEFO'      
              THEN 'NSE'      
              ELSE SEGMENT      
             END AS 'EXCHANGE',      
             CASE      
             WHEN SEGMENT='BSE'      
             THEN 'CASH'      
             WHEN SEGMENT='BSEFO'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NCDX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSE'      
             THEN 'CASH'      
             WHEN SEGMENT='NSE CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSEFO'      
             THEN 'FUTURES'      
             ELSE SEGMENT      
             END AS 'SEGMENTS',      
  SEGMENT INTO #TEMPSEG      
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC      
    WHERE SBTAG=@SBTAG      
 AND AppStatus IS NOT NULL      
    ORDER BY SEGMENT ASC;      
    DECLARE @MAX AS INT=0;      
    SELECT @MAX=MAX(ID)      
    FROM #TEMPSEG;      
    DECLARE @CNT AS INT=0;      
    DECLARE @STR AS VARCHAR(200)='';      
    DECLARE @STREXCH AS VARCHAR(200)='';      
    WHILE @MAX>@CNT      
    BEGIN      
    SET @CNT=@CNT+1;      
    DECLARE @STRTEMP AS VARCHAR(50);      
    DECLARE @STRTEMPEXCH AS VARCHAR(50);      
    SELECT @STRTEMP=SEGMENTS,      
  @STRTEMPEXCH=EXCHANGE      
    FROM #TEMPSEG      
    WHERE ID=@CNT;      
    SET @STR=@STRTEMP+','+@STR;      
    SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;      
    END;      
    insert into Tbl_annexture      
    SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,      
     '' as Actual_Address, @STREXCH AS 'Exchange', @STR AS 'Segment',[REGISTERED NAME] AS Approved_User, '-' AS Relation_with_approved_user,'' as new_branch_tag,'' as new_sb_tag,'' as new_user_name,'' as new_certificate_no,'' as new_user_pan_no, BRANCH as
    branch_tag,PANNO as pan_no ,Email,Mobile,'' as Actual_user, '' as Terminal_Active,'' as region, '' as zone, '' as verified_date ,'' as category
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC      
    WHERE SBTAG=@SBTAG;    
            declare @zone as varchar(50)  
            declare @region as varchar(50)  
            select @zone = zone from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  
            select @region = region from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  
      
      
        update Tbl_annexture  
        set zone=@zone,  
        region = @region  
         WHERE sb_Login_ID=@SBTAG 
        
         DECLARE @CATEGORY AS VARCHAR(50)
         SET @CATEGORY =''
         
         SELECT  top 1 @CATEGORY = sb_category from [196.1.115.182].general.DBO.Vw_RMS_Client_Vertical where SB=@SBTAG
        
         update Tbl_annexture 
         set category = @CATEGORY
         WHERE sb_Login_ID=@SBTAG 
          
        
          
          
    insert into Tbl_segment_details       
    SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,      
  STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],      
           CASE      
          WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'      
          THEN '-'      
          ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)      
           END AS VALIDUPTO       
    FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)      
    LEFT JOIN      
    INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)      
    ON B.STINTSYSREFNO=C.STINTSYSREFNO      
    WHERE B.STSBTAG=@SBTAG      
 AND B.STSTATUS='A'      
 AND STREGNOPRIFIX+''+STREGNO IS NOT NULL      
 AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';      
          
      insert into Tbl_answer([SBTAG],Current_tab,is_compliance,is_complete,Last_Transaction_Time,complete_date) values(@SBTAG,1,0,0,GETDATE(),'')      
      DROP TABLE #TEMPSEG;      
      select a.Actual_user,a.Terminal_Active,a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG      
     
         select * from Tbl_segment_details where sbtag=@SBTAG     
         select Current_Tab from Tbl_answer where sbtag=@SBTAG     
         SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    
         select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no    
         --select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
           exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag ,@language
         create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(200),Segment varchar(50))
         insert into #table
         exec sp_CTCL_new @sbtag 

         insert into tbl_terminaldetails(Entryid,OdianID,ActualUserName  ,TerminalAddress,segment,sbtag)
         select @entry_id as Entryid, a.[Login/Odin Id] as OdianID,a.[UserName] as ActualUserName,a.[Terminal Address] as terminaladdress,	a.[Segment] as segment,@SBTAG from (select * from #table)a
         drop table #table
         select * from tbl_terminaldetails where entryid=@entry_id
                  
  END      
  ELSE      
  BEGIN      
   select a.Actual_user,a.Terminal_Active, a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG        
  select * from Tbl_segment_details where sbtag=@SBTAG     
   select Current_Tab from Tbl_answer where sbtag=@SBTAG     
      
    SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    
    select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no 
    -- select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
    exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag,@language
     
      select * from tbl_terminaldetails where entryid=@entry_id 
  END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS_21012016
-- --------------------------------------------------

create PROC dbo.USP_SACC_GETCLIENTDETAILS_21012016
      @SBTAG VARCHAR(50)=''
AS
BEGIN
DECLARE @SBCOUNT AS INT=0;
SELECT @SBCOUNT= COUNT(*) FROM Tbl_answer WHERE SBTAG=@SBTAG
PRINT @sbCOUNT
IF(@SBCOUNT=0)
BEGIN
	   SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,
									    CASE
											   WHEN SEGMENT='BSE'
											   THEN 'BSE'
											   WHEN SEGMENT='BSEFO'
											   THEN 'BSE'
											   WHEN SEGMENT='MCX'
											   THEN 'MCX'
											   WHEN SEGMENT='MCX CURRENCY'
											   THEN 'MCD'
											   WHEN SEGMENT='NCDX'
											   THEN 'NCX'
											   WHEN SEGMENT='NSE'
											   THEN 'NSE'
											   WHEN SEGMENT='NSE CURRENCY'
											   THEN 'NSX'
											   WHEN SEGMENT='NSEFO'
											   THEN 'NSE'
											   ELSE SEGMENT
									    END AS 'EXCHANGE',
												 CASE
													WHEN SEGMENT='BSE'
													THEN 'CASH'
													WHEN SEGMENT='BSEFO'
													THEN 'FUTURES'
													WHEN SEGMENT='MCX'
													THEN 'FUTURES'
													WHEN SEGMENT='MCX CURRENCY'
													THEN 'FUTURES'
													WHEN SEGMENT='NCDX'
													THEN 'FUTURES'
													WHEN SEGMENT='NSE'
													THEN 'CASH'
													WHEN SEGMENT='NSE CURRENCY'
													THEN 'FUTURES'
													WHEN SEGMENT='NSEFO'
													THEN 'FUTURES'
													ELSE SEGMENT
												 END AS 'SEGMENTS',
		SEGMENT INTO #TEMPSEG
	   FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC
	   WHERE SBTAG=@SBTAG
	AND AppStatus IS NOT NULL
	   ORDER BY SEGMENT ASC;
	   DECLARE @MAX AS INT=0;
	   SELECT @MAX=MAX(ID)
	   FROM #TEMPSEG;
	   DECLARE @CNT AS INT=0;
	   DECLARE @STR AS VARCHAR(200)='';
	   DECLARE @STREXCH AS VARCHAR(200)='';
	   WHILE @MAX>@CNT
	   BEGIN
	   SET @CNT=@CNT+1;
	   DECLARE @STRTEMP AS VARCHAR(50);
	   DECLARE @STRTEMPEXCH AS VARCHAR(50);
	   SELECT @STRTEMP=SEGMENTS,
		@STRTEMPEXCH=EXCHANGE
	   FROM #TEMPSEG
	   WHERE ID=@CNT;
	   SET @STR=@STRTEMP+','+@STR;
	   SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;
	   END;
	   SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,
	    SBTAG,
				 
				 
				 
				 @STREXCH AS 'EXCHANG',
				 @STR AS 'SEGEMENT',
				 '-' AS RELATION,
				 BRANCH,
				 PANNO 
	   FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC
	   WHERE SBTAG=@SBTAG;
	   SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,
		STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],
								   CASE
								  WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'
								  THEN '-'
								  ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)
								   END AS VALIDUPTO
	   FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)
	   LEFT JOIN
	   INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)
	   ON B.STINTSYSREFNO=C.STINTSYSREFNO
	   WHERE B.STSBTAG=@SBTAG
	AND B.STSTATUS='A'
	AND STREGNOPRIFIX+''+STREGNO IS NOT NULL
	AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';
	   DROP TABLE #TEMPSEG;
	   END
	   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS_23012016
-- --------------------------------------------------

create PROC dbo.USP_SACC_GETCLIENTDETAILS_23012016
      @SBTAG VARCHAR(50)=''
AS
BEGIN
DECLARE @SBCOUNT AS INT=0;
SELECT @SBCOUNT= COUNT(*) FROM Tbl_answer WHERE sbtag=@SBTAG
PRINT @sbCOUNT
IF(@SBCOUNT=0)
BEGIN
	   SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,
									    CASE
											   WHEN SEGMENT='BSE'
											   THEN 'BSE'
											   WHEN SEGMENT='BSEFO'
											   THEN 'BSE'
											   WHEN SEGMENT='MCX'
											   THEN 'MCX'
											   WHEN SEGMENT='MCX CURRENCY'
											   THEN 'MCD'
											   WHEN SEGMENT='NCDX'
											   THEN 'NCX'
											   WHEN SEGMENT='NSE'
											   THEN 'NSE'
											   WHEN SEGMENT='NSE CURRENCY'
											   THEN 'NSX'
											   WHEN SEGMENT='NSEFO'
											   THEN 'NSE'
											   ELSE SEGMENT
									    END AS 'EXCHANGE',
												 CASE
													WHEN SEGMENT='BSE'
													THEN 'CASH'
													WHEN SEGMENT='BSEFO'
													THEN 'FUTURES'
													WHEN SEGMENT='MCX'
													THEN 'FUTURES'
													WHEN SEGMENT='MCX CURRENCY'
													THEN 'FUTURES'
													WHEN SEGMENT='NCDX'
													THEN 'FUTURES'
													WHEN SEGMENT='NSE'
													THEN 'CASH'
													WHEN SEGMENT='NSE CURRENCY'
													THEN 'FUTURES'
													WHEN SEGMENT='NSEFO'
													THEN 'FUTURES'
													ELSE SEGMENT
												 END AS 'SEGMENTS',
		SEGMENT INTO #TEMPSEG
	   FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC
	   WHERE SBTAG=@SBTAG
	AND AppStatus IS NOT NULL
	   ORDER BY SEGMENT ASC;
	   DECLARE @MAX AS INT=0;
	   SELECT @MAX=MAX(ID)
	   FROM #TEMPSEG;
	   DECLARE @CNT AS INT=0;
	   DECLARE @STR AS VARCHAR(200)='';
	   DECLARE @STREXCH AS VARCHAR(200)='';
	   WHILE @MAX>@CNT
	   BEGIN
	   SET @CNT=@CNT+1;
	   DECLARE @STRTEMP AS VARCHAR(50);
	   DECLARE @STRTEMPEXCH AS VARCHAR(50);
	   SELECT @STRTEMP=SEGMENTS,
		@STRTEMPEXCH=EXCHANGE
	   FROM #TEMPSEG
	   WHERE ID=@CNT;
	   SET @STR=@STRTEMP+','+@STR;
	   SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;
	   END;
	   insert into Tbl_annexture
	   SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,
	    '' as Actual_Address, @STREXCH AS 'Exchange', @STR AS 'Segment',[REGISTERED NAME] AS Approved_User, '-' AS Relation_with_approved_user,'' as new_branch_tag,'' as new_sb_tag,'' as new_user_name,'' as new_certificate_no,'' as new_user_pan_no, BRANCH as branch_tag,
	    PANNO as pan_no 
	   FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC
	   WHERE SBTAG=@SBTAG;
	   
	   
	   insert into Tbl_segment_details 
	   SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,
		STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],
								   CASE
								  WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'
								  THEN '-'
								  ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)
								   END AS VALIDUPTO 
	   FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)
	   LEFT JOIN
	   INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)
	   ON B.STINTSYSREFNO=C.STINTSYSREFNO
	   WHERE B.STSBTAG=@SBTAG
	AND B.STSTATUS='A'
	AND STREGNOPRIFIX+''+STREGNO IS NOT NULL
	AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';
	   
	     insert into Tbl_answer([SBTAG],Current_tab,is_compliance,is_complete,Last_Transaction_Time,complete_date) values(@SBTAG,1,0,0,GETDATE(),'')
	     DROP TABLE #TEMPSEG;
	     select a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab
 from Tbl_annexture a
 inner join  Tbl_answer b
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG
	   END
	 ELSE
	 BEGIN
		 select a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab
 from Tbl_annexture a
 inner join  Tbl_answer b
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG  
	 END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS01072016
-- --------------------------------------------------
  --USP_SACC_GETCLIENTDETAILS 'gds'    
create PROC [dbo].[USP_SACC_GETCLIENTDETAILS01072016]      
      @SBTAG VARCHAR(50)='',
      @language varchar(50)='English'     
AS      
BEGIN      
DECLARE @SBCOUNT AS INT=0;      
SELECT @SBCOUNT= COUNT(sb_Login_ID) FROM Tbl_annexture WHERE sb_Login_ID=@SBTAG      
PRINT @sbCOUNT     
  DECLARE @entry_id AS INT=0;       
IF(@SBCOUNT=0)      
BEGIN      
    SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,      
             CASE      
              WHEN SEGMENT='BSE'      
              THEN 'BSE'      
              WHEN SEGMENT='BSEFO'      
              THEN 'BSE'      
              WHEN SEGMENT='MCX'      
              THEN 'MCX'      
              WHEN SEGMENT='MCX CURRENCY'      
              THEN 'MCD'      
              WHEN SEGMENT='NCDX'      
              THEN 'NCX'      
              WHEN SEGMENT='NSE'      
              THEN 'NSE'      
              WHEN SEGMENT='NSE CURRENCY'      
              THEN 'NSX'      
              WHEN SEGMENT='NSEFO'      
              THEN 'NSE'      
              ELSE SEGMENT      
             END AS 'EXCHANGE',      
             CASE      
             WHEN SEGMENT='BSE'      
             THEN 'CASH'      
             WHEN SEGMENT='BSEFO'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NCDX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSE'      
             THEN 'CASH'      
             WHEN SEGMENT='NSE CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSEFO'      
             THEN 'FUTURES'      
             ELSE SEGMENT      
             END AS 'SEGMENTS',      
  SEGMENT INTO #TEMPSEG      
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC      
    WHERE SBTAG=@SBTAG      
 AND AppStatus IS NOT NULL      
    ORDER BY SEGMENT ASC;      
    DECLARE @MAX AS INT=0;      
    SELECT @MAX=MAX(ID)      
    FROM #TEMPSEG;      
    DECLARE @CNT AS INT=0;      
    DECLARE @STR AS VARCHAR(200)='';      
    DECLARE @STREXCH AS VARCHAR(200)='';      
    WHILE @MAX>@CNT      
    BEGIN      
    SET @CNT=@CNT+1;      
    DECLARE @STRTEMP AS VARCHAR(50);      
    DECLARE @STRTEMPEXCH AS VARCHAR(50);      
    SELECT @STRTEMP=SEGMENTS,      
  @STRTEMPEXCH=EXCHANGE      
    FROM #TEMPSEG      
    WHERE ID=@CNT;      
    SET @STR=@STRTEMP+','+@STR;      
    SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;      
    END;      
    insert into Tbl_annexture      
    SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,      
     '' as Actual_Address, @STREXCH AS 'Exchange', @STR AS 'Segment',[REGISTERED NAME] AS Approved_User, '-' AS Relation_with_approved_user,'' as new_branch_tag,'' as new_sb_tag,'' as new_user_name,'' as new_certificate_no,'' as new_user_pan_no, BRANCH as
    branch_tag,PANNO as pan_no ,Email,Mobile,'' as Actual_user, '' as Terminal_Active,'' as region, '' as zone, '' as verified_date ,'' as category
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC      
    WHERE SBTAG=@SBTAG;    
            declare @zone as varchar(50)  
            declare @region as varchar(50)  
            select @zone = zone from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  
            select @region = region from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  
      
      
        update Tbl_annexture  
        set zone=@zone,  
        region = @region  
         WHERE sb_Login_ID=@SBTAG 
        
         DECLARE @CATEGORY AS VARCHAR(50)
         SET @CATEGORY =''
         
         SELECT  top 1 @CATEGORY = sb_category from [196.1.115.182].general.DBO.Vw_RMS_Client_Vertical where SB=@SBTAG
        
         update Tbl_annexture 
         set category = @CATEGORY
         WHERE sb_Login_ID=@SBTAG 
          
        
          
          
    insert into Tbl_segment_details       
    SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,      
  STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],      
           CASE      
          WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'      
          THEN '-'      
          ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)      
           END AS VALIDUPTO       
    FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)      
    LEFT JOIN      
    INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)      
    ON B.STINTSYSREFNO=C.STINTSYSREFNO      
    WHERE B.STSBTAG=@SBTAG      
 AND B.STSTATUS='A'      
 AND STREGNOPRIFIX+''+STREGNO IS NOT NULL      
 AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';      
          
      insert into Tbl_answer([SBTAG],Current_tab,is_compliance,is_complete,Last_Transaction_Time,complete_date) values(@SBTAG,1,0,0,GETDATE(),'')      
      DROP TABLE #TEMPSEG;      
      select a.Actual_user,a.Terminal_Active,a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG      
     
         select * from Tbl_segment_details where sbtag=@SBTAG     
         select Current_Tab from Tbl_answer where sbtag=@SBTAG     
         SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    
         select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no    
         --select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
           exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag
         create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(200),Segment varchar(50))
         insert into #table
         exec sp_CTCL_new @sbtag 

         insert into tbl_terminaldetails(Entryid,OdianID,ActualUserName  ,TerminalAddress,segment,sbtag)
         select @entry_id as Entryid, a.[Login/Odin Id] as OdianID,a.[UserName] as ActualUserName,a.[Terminal Address] as terminaladdress,	a.[Segment] as segment,@SBTAG from (select * from #table)a
         drop table #table
         select * from tbl_terminaldetails where entryid=@entry_id
                  
  END      
  ELSE      
  BEGIN      
   select a.Actual_user,a.Terminal_Active, a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG        
  select * from Tbl_segment_details where sbtag=@SBTAG     
   select Current_Tab from Tbl_answer where sbtag=@SBTAG     
      
    SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    
    select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no 
    -- select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
    exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag
     
      select * from tbl_terminaldetails where entryid=@entry_id 
  END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETCLIENTDETAILS21082017
-- --------------------------------------------------
  --USP_SACC_GETCLIENTDETAILS 'gds'    
create PROC [dbo].[USP_SACC_GETCLIENTDETAILS21082017]      
      @SBTAG VARCHAR(50)='',
      @language varchar(50)='English'     
AS      
BEGIN      
DECLARE @SBCOUNT AS INT=0;  
declare @cnt1 as int =0;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

select @cnt1 =COUNT(1) from Tbl_answer with(nolock) where SBTAG=@SBTAG 
    
SELECT @SBCOUNT= COUNT(sb_Login_ID) FROM Tbl_annexture  with(nolock) WHERE sb_Login_ID=@SBTAG      
PRINT @sbCOUNT     
  DECLARE @entry_id AS INT=0;       
IF(@SBCOUNT=0 and @cnt1=0)      
BEGIN      
    SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT) AS ID,      
             CASE      
              WHEN SEGMENT='BSE'      
              THEN 'BSE'      
              WHEN SEGMENT='BSEFO'      
              THEN 'BSE'      
              WHEN SEGMENT='MCX'      
              THEN 'MCX'      
              WHEN SEGMENT='MCX CURRENCY'      
              THEN 'MCD'      
              WHEN SEGMENT='NCDX'      
              THEN 'NCX'      
              WHEN SEGMENT='NSE'      
              THEN 'NSE'      
              WHEN SEGMENT='NSE CURRENCY'      
              THEN 'NSX'      
              WHEN SEGMENT='NSEFO'      
              THEN 'NSE'      
              ELSE SEGMENT      
             END AS 'EXCHANGE',      
             CASE      
             WHEN SEGMENT='BSE'      
             THEN 'CASH'      
             WHEN SEGMENT='BSEFO'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='MCX CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NCDX'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSE'      
             THEN 'CASH'      
             WHEN SEGMENT='NSE CURRENCY'      
             THEN 'FUTURES'      
             WHEN SEGMENT='NSEFO'      
             THEN 'FUTURES'      
             ELSE SEGMENT      
             END AS 'SEGMENTS',      
  SEGMENT INTO #TEMPSEG      
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC   with(nolock)    
    WHERE SBTAG=@SBTAG      
 AND AppStatus IS NOT NULL      
    ORDER BY SEGMENT ASC;      
    DECLARE @MAX AS INT=0;      
    SELECT @MAX=MAX( isnull( ID,0))      
    FROM #TEMPSEG;      
    DECLARE @CNT AS INT=0;      
    DECLARE @STR AS VARCHAR(200)='';      
    DECLARE @STREXCH AS VARCHAR(200)='';      
    WHILE @MAX>@CNT      
    BEGIN      
    SET @CNT=@CNT+1;      
    DECLARE @STRTEMP AS VARCHAR(50);      
    DECLARE @STRTEMPEXCH AS VARCHAR(50);      
    SELECT @STRTEMP=SEGMENTS,      
  @STRTEMPEXCH=EXCHANGE      
    FROM #TEMPSEG      
    WHERE ID=@CNT;      
    SET @STR=@STRTEMP+','+@STR;      
    SET @STREXCH=@STRTEMPEXCH+','+@STREXCH;      
    END;      
    insert into Tbl_annexture      
    SELECT TOP 1 [REGISTERED NAME] AS sb_Name,SBTAG AS 'sb_Login_ID',[REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address,      
     '' as Actual_Address, @STREXCH AS 'Exchange', @STR AS 'Segment',[REGISTERED NAME] AS Approved_User, '-' AS Relation_with_approved_user,'' as new_branch_tag,'' as new_sb_tag,'' as new_user_name,'' as new_certificate_no,'' as new_user_pan_no, BRANCH as
    branch_tag,PANNO as pan_no ,Email,Mobile,'' as Actual_user, '' as Terminal_Active,'' as region, '' as zone, '' as verified_date ,'' as category
    FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  with(nolock)     
    WHERE SBTAG=@SBTAG;    
            declare @zone as varchar(50)  
            declare @region as varchar(50)  
            select @zone = zone,@region=region from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS  with(nolock) where SB = @SBTAG  
            --select @region = region from [196.1.115.132].SMS.DBO.CLIENT_VERTICAL_DETAILS where SB = @SBTAG  
      
      
        update Tbl_annexture  
        set zone=@zone,  
        region = @region  
         WHERE sb_Login_ID=@SBTAG 
        
         DECLARE @CATEGORY AS VARCHAR(50)
         SET @CATEGORY =''
         
         SELECT  top 1 @CATEGORY = sb_category from [196.1.115.182].general.DBO.Vw_RMS_Client_Vertical  with(nolock) where SB=@SBTAG
        
         update Tbl_annexture 
         set category = @CATEGORY
         WHERE sb_Login_ID=@SBTAG 
          
        
          
          
    insert into Tbl_segment_details       
    SELECT @SBTAG as SBTAG,B.STSEGMENT AS SEGMENT,      
  STREGNOPRIFIX+''+STREGNO AS [NCFM/BCSM REGN NO],      
           CASE      
          WHEN CONVERT( VARCHAR(11), C.DTVALIDITYDATE, 103)='01/01/1900'      
          THEN '-'      
          ELSE CONVERT(VARCHAR(11), C.DTVALIDITYDATE, 103)      
           END AS VALIDUPTO       
    FROM INTRANET.CTCLNEW.DBO.TBL_CTCLID B WITH (NOLOCK)      
    LEFT JOIN      
    INTRANET.CTCLNEW.DBO.V_EMPMASTER C WITH (NOLOCK)      
    ON B.STINTSYSREFNO=C.STINTSYSREFNO      
    WHERE B.STSBTAG=@SBTAG      
 AND B.STSTATUS='A'      
 AND STREGNOPRIFIX+''+STREGNO IS NOT NULL      
 AND LTRIM(RTRIM(STREGNOPRIFIX+''+STREGNO))<>'';      
          
      insert into Tbl_answer([SBTAG],Current_tab,is_compliance,is_complete,Last_Transaction_Time,complete_date) values(@SBTAG,1,0,0,GETDATE(),'')      
      DROP TABLE #TEMPSEG;      
      select a.Actual_user,a.Terminal_Active,a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG      
     
         select * from Tbl_segment_details where sbtag=@SBTAG     
         select Current_Tab from Tbl_answer where sbtag=@SBTAG     
         SELECT @entry_id= entry_id FROM Tbl_answer WHERE sbtag=@SBTAG    
         select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no    
         --select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
           exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag ,@language
         create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(200),Segment varchar(50))
         insert into #table
         exec sp_CTCL_new @sbtag 

         insert into tbl_terminaldetails(Entryid,OdianID,ActualUserName  ,TerminalAddress,segment,sbtag)
         select @entry_id as Entryid, a.[Login/Odin Id] as OdianID,a.[UserName] as ActualUserName,a.[Terminal Address] as terminaladdress,	a.[Segment] as segment,@SBTAG from (select * from #table)a
         drop table #table
         select * from tbl_terminaldetails where entryid=@entry_id
                  
  END      
  ELSE      
  BEGIN      
   select a.Actual_user,a.Terminal_Active, a.sb_name,a.sb_login_id,a.Approved_user as trade_name,a.Approved_address,a.Exchange,a.Segment,a.Relation_with_approved_user,a.Actual_address,a.branch_tag,a.pan_no,a.new_user_pan_no ,b.current_tab      
 from Tbl_annexture a      
 inner join  Tbl_answer b      
 on a.sb_login_id=b.sbtag and b.sbtag=@SBTAG        
  select * from Tbl_segment_details  with(nolock) where sbtag=@SBTAG     
   select Current_Tab from Tbl_answer  with(nolock) where sbtag=@SBTAG     
      
    SELECT @entry_id= entry_id FROM Tbl_answer  with(nolock) WHERE sbtag=@SBTAG    
    select * from Tbl_tr_answer where Entry_id = @entry_id order by Question_no 
    -- select Question_no,Question,upload_option,Has_annexture,has_attachment from Tbl_question_master where isactivated = 1
    exec USP_Question_Master_MultiLanguage 'getquestions',@sbtag,@language
     
      select * from tbl_terminaldetails  with(nolock) where entryid=@entry_id 
  END   
  
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETDATA
-- --------------------------------------------------
-- =============================================
-- Author:		PRAMOD JADHAV
-- Create date:     28 FEB 2016
-- Description:	GET SACC RFLATED DATA

-- [USP_SACC_GETDATA]'VERIFIED',1,1,'Compliance','Trading terminals ','E57289'
-- =============================================
CREATE PROCEDURE [dbo].[USP_SACC_GETDATA]
@PROCESS AS VARCHAR(50)='',
@FILTER1 AS VARCHAR(800)='',
@FILTER2 AS VARCHAR(max)='',
@FILTER3 AS VARCHAR(max)='',
@FILTER4 AS VARCHAR(max)='',
@FILTER5 AS VARCHAR(100)='',
@FILTER6 AS VARCHAR(100)='',
@FILTER7 AS VARCHAR(100)='',
@FILTER8 AS VARCHAR(100)=''	
AS
BEGIN

	   IF @PROCESS ='GET_ZONEREGIONBRANCH'
	   BEGIN
	       ---SELECT ZONE,REGION,BR_CODE,BRANCHNAME FROM [196.1.115.132].RISK.DBO.ZONE_REGION_BRANCH WHERE ZONE  IS NOT NULL 
	       select distinct zone,region,REGIONNAME,branch,BRANCHNAME from [MIS].SB_COMP.dbo.VW_ACTIVESACC_BROKER where zone is not null and region is not null and branch is not null
	   END
	   
	   IF @PROCESS ='GET_ANS'
	   BEGIN
	   --TABLE 1
	       SELECT ANS .*,OP.OPTIONS FROM TBL_TR_ANSWER ANS
	       JOIN (SELECT QUESTION_NO,OPTION_TYPE FROM TBL_QUESTION_MASTER WHERE IS_APPROVED =1) QN
	       ON QN.QUESTION_NO =ANS.QUESTION_NO 
	       JOIN TBL_OPTIONS OP
	       ON OP.OPTION_TYPE=QN.OPTION_TYPE
	        WHERE ENTRY_ID =@FILTER1 
	        ORDER BY ANS.QUESTION_NO 
	        
	        --TABLE 2
	        
	        SELECT ENTRY_ID,SB_LOGIN_ID,SB_NAME,BRANCH_TAG,MOBILE  FROM TBL_ANNEXTURE WHERE ENTRY_ID =@FILTER1
	   END
	   
	   
	    IF @PROCESS ='GET_SACCDATA'
	      BEGIN
			-- SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+'/'+ DBO.UDF_GET_TOTALQUESTION() AS 'Ans_Qn' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN 'COMPLETED' ELSE 'NOT COMPLETED'  END AS 'STATUS',Last_Transaction_Time AS 'LAST UPDATED',Entry_Id  
			--FROM tbl_answer) A
			--JOIN 
			--(select  sb_Login_ID as SBTAG ,sb_Name 'LONG_NAME',branch_tag 'BRANCH_CD',pan_no 'PAN_GIR_NO',Email AS 'EMAIL',Mobile 'MOBILE_PAGER'   
			--from TBL_ANNEXTURE )B
			--ON A.SBTAG=B.SBTAG
			--JOIN(SELECT Entry_id,COUNT(Question_no) AS 'ANSNUM' FROM tbl_tr_answer
			--GROUP BY Entry_id)C
			--ON C.Entry_id =A.Entry_Id 
			--order by A.[LAST UPDATED] desc
			
	 declare @str as varchar(max)
	
	   --       set @str=' select * from (select z.*,q.zone,q.region,q.branch,q.BRANCHNAME from (SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Ans_Qn'' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN ''COMPLETED'' ELSE ''NOT COMPLETED''  END AS ''STATUS'',Last_Transaction_Time AS ''LAST UPDATED'',Entry_Id  
			 --FROM tbl_answer) A
			 --JOIN 
			 --(select  sb_Login_ID as SBTAG ,sb_Name ''LONG_NAME'',branch_tag ''BRANCH_CD'',pan_no ''PAN_GIR_NO'',Email AS ''EMAIL'',Mobile ''MOBILE_PAGER''   
			 --from TBL_ANNEXTURE )B
			 --ON A.SBTAG=B.SBTAG
			 --JOIN(SELECT Entry_id,COUNT(Question_no) AS ''ANSNUM'' FROM tbl_tr_answer
			 --GROUP BY Entry_id)C
			 --ON C.Entry_id =A.Entry_Id )z
			 --join  (select zone,region,branch,BRANCHNAME,SBTAG from [196.1.115.167].SB_COMP.dbo.VW_ACTIVESACC_BROKER ) q
			 --on z.SBTAG=q.SBTAG)ab
			 --'+@FILTER1 +'
			 --order by [LAST UPDATED] desc'
			
			   set @str=' select * from (select z.*,q.zone,q.region,q.branch,q.BRANCHNAME from (SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Ans_Qn''
						, CAST( isnull(ver.[VERSUM],0) AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Verified'' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id 
						,case when (isnull(ver.[VERSUM],0)= cast(DBO.UDF_GET_TOTALQUESTION() as int)) then 1 else 0 end as  VerStatus
						FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN ''COMPLETED'' ELSE ''NOT COMPLETED''  END AS ''STATUS'',
						Last_Transaction_Time AS ''LAST UPDATED'',Entry_Id  
						FROM tbl_answer) A
						JOIN 
						(select  sb_Login_ID as SBTAG ,sb_Name ''LONG_NAME'',branch_tag ''BRANCH_CD'',pan_no ''PAN_GIR_NO'',Email AS ''EMAIL'',Mobile ''MOBILE_PAGER''   
						from TBL_ANNEXTURE )B
						ON A.SBTAG=B.SBTAG
						JOIN(SELECT Entry_id,COUNT(Question_no) AS ''ANSNUM'' FROM tbl_tr_answer
						GROUP BY Entry_id)C
						ON C.Entry_id =A.Entry_Id 
						left join
						(select Entry_id, isnull( COUNT(1),0) as VERSUM from tbl_tr_answer
						where Maker_ans IS NOT NULL
						group by Entry_id)ver
						on ver.Entry_id =c.Entry_Id 
						)z
						left join  (select zone,region,branch,BRANCHNAME,SBTAG from [MIS].SB_COMP.dbo.VW_ACTIVESACC_BROKER ) q
						on z.SBTAG=q.SBTAG)ab
						'+@FILTER1 +'
						order by [LAST UPDATED] '
			 
			 exec  (@str)
	   END

	   IF @PROCESS ='VERIFIED'
	   BEGIN
	   
	   -- [USP_SACC_GETDATA]'VERIFIED',2,1,'Compliance','Trading terminals ','E57289'
	       UPDATE TBL_TR_ANSWER
	       SET Maker_ans=@FILTER3,
	       Maker_remark=@FILTER4 ,
	       Verified_on=GETDATE() ,
	       VERIFIED_BY=@FILTER5 
	       WHERE Entry_id =@FILTER1 AND Question_no=@FILTER2
	       
	       SELECT GETDATE() AS DATES
	         --added by suraj start
            declare @count as int
          
            select @count = COUNT(1) from tbl_tr_answer where Maker_ans is not null and Entry_id=@FILTER1
            declare @Questioncount as int
          
            select @Questioncount = COUNT(1) from Tbl_question_master where isactivated = 1
            
            print(@count)
            if @count =@Questioncount 
            begin
                    declare  @Email_conf as int    
                    SELECT @Email_conf = isnull(Email_conf,0)  FROM Tbl_answer WHERE Entry_id=@FILTER1  
             
                    if @Email_conf <> 1   
                    begin
                          --attachment start
                    truncate table temp1
                    insert into temp1 values(0,'Question','Answer','remark','attachment','Verified_answer','Verified_remark')
                    insert into temp1 select REPLACE(REPLACE(replace(Question_no, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Question, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Answer, ',', ' '), CHAR(13), ''), CHAR(10), ''), REPLACE(REPLACE(replace(remark, ',', ' '), CHAR(13), ''), CHAR(10), ''), REPLACE(REPLACE(replace(attachment, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Maker_ans, ',', ' '), CHAR(13), ''), CHAR(10), '') as Verified_answer,REPLACE(REPLACE(replace(Maker_remark, ',', ' '), CHAR(13), ''), CHAR(10), '')as Verified_remark from compliance.dbo.Tbl_tr_answer where Entry_id = @FILTER1
                    declare  @SQLStatement as varchar(2000)
                    select @SQLStatement = 'bcp " select * from compliance.dbo.temp1  " queryout \\INHOUSELIVEAPP2-FS.angelone.in\d$\upload_sacc\compliance.csv /c /t, -T -S' + @@servername
                    exec master..xp_cmdshell @SQLStatement 
                    print @SQLStatement  


                    declare @strAttach varchar(max)                            
                    set @strAttach = '\\INHOUSELIVEAPP2-FS.angelone.in\d$\upload_sacc\compliance.csv'   
                    --attachment end

                        declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)  
                        set @Orisubject = (select [SUBJECT] from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0 )  
                        set @fromAddress=(select from_address from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0 )  
                        set @oribody = (select body from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0  )  
                        EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL    
                        @subject = @Orisubject,  
                        @from_address = @fromAddress,  
                        @body = @oribody,-- ,  
                        @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc  
                        @RECIPIENTS = 'pramod.jadhav@angelbroking.com;suraj.patil@angelbroking.com;kinnari.solanki@angelbroking.com',  
                        @body_format = 'html',
                        @file_attachments=@strAttach  
                        --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag  
                        --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 , 
                        DECLARE @COMPLIANCE_COUNT AS INT
                        DECLARE @NONCOMPLIANCE_COUNT AS INT
                        DECLARE @NOTAPPLICABLE_COUNT AS INT
                        
                        SELECT  @COMPLIANCE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans IN ('Compliance','Yes') and Entry_id =@FILTER1
                        SELECT  @NONCOMPLIANCE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans IN ('Not compliance','No') and Entry_id =@FILTER1
                        SELECT  @NOTAPPLICABLE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans not IN ('Compliance','Yes','Not compliance','No') and Entry_id =@FILTER1
                        
                     
                        
                        
                        update Tbl_answer
                        set Email_conf =1,
                        is_Verified = 1,
                        verified_date =GETDATE(),
                        COMPLIANCE_COUNT =@COMPLIANCE_COUNT,
                        NONCOMPLIANCE_COUNT=@NONCOMPLIANCE_COUNT,
                        NOTAPPLICABLE_COUNT=@NOTAPPLICABLE_COUNT
                        
                        where Entry_id=@FILTER1
                        
                        
                        
                     end
                     
                    declare  @sms_conf as int    
                    SELECT @sms_conf = isnull(sms_conf,0)  FROM Tbl_answer WHERE Entry_id=@FILTER1  
                    if @sms_conf <> 1   
                    begin
                        ----------------sms start----------------------------
                        --declare @mobile as varchar(20)
                        --set @mobile = '9860229924'
                        --declare @sbtag as varchar(20)
                        --set @sbtag = ''
                        -- select @sbtag= SBTAG  FROM Tbl_answer WHERE Entry_id=@FILTER1
                        --select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag 
                        --insert into [196.1.115.132].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)  
                        --select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from     
                        --(    
                        --select @mobile as No,
                        --'Dear Partner, we have reviewed your Self Assessment Compliance Checklist (SACC) for BranchTag/SBTag & have sent updated report with remarks on your email id.​' as sms_msg ,
                        --convert(varchar(10), getdate(), 103) as sms_dt,
                        --ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,
                        --'P' as flag,
                        --case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,
                        --'SB_SACC_Review'as Purpose
                        --)a 
                          declare @mobile as varchar(20)
                        set @mobile = '9860229924'
                        declare @sbtag as varchar(20)
                        set @sbtag = ''
                        select @sbtag= SBTAG  FROM Tbl_answer WHERE Entry_id=@FILTER1
                       declare @branch as varchar(20)
                       set @branch = ''
                       select @branch=branch_tag from Tbl_annexture where sb_Login_ID =@sbtag
                       declare @sms_msg as varchar(max)
                       set @sms_msg = ''
                       select @sms_msg = BODY from Tbl_SACC_SMSMaster where purpose = 'SB_SACC_Review' and isdelete = 0
                       set @sms_msg= REPLACE( @sms_msg, '@branch/@sbtag', @branch+'/'+@sbtag )
                       select @sms_msg 
                       select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag 
                        insert into [INTRANET].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)  
                        select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from     
                        (    
                        select @mobile as No,
                        @sms_msg as sms_msg ,
                        convert(varchar(10), getdate(), 103) as sms_dt,
                        ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,
                        'P' as flag,
                        case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,
                        'SB_SACC_Review'as Purpose
                        )a       
                        ----------------sms end----------------------------

                    
                    
                        update Tbl_answer
                        set sms_conf =1
                        where Entry_id=@FILTER1
                        
                     end
      
            end
	       
	       
	       
	       
	   END
	   
	   IF @PROCESS ='GETEMAIL'
	   BEGIN
	       
	       select SUBJECT ,BODY ,Purpose  from Tbl_SACC_EmailMaster WHERE isdelete =0 and Purpose =@FILTER1 
	       
	       
	   END
	    IF @PROCESS ='GETSMS'
	   BEGIN
	       select BODY ,Purpose  from Tbl_SACC_SMSMaster WHERE isdelete =0 and Purpose =@FILTER1 
	   END
	   
	   IF @PROCESS ='UPDATEMAIL'
	   BEGIN
	       
			select * into #tempmail from 
			(select [from_address],[SUBJECT],[BODY],[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],Modified_on,Modified_by,[Purpose],[isdelete]
			from Tbl_SACC_EmailMaster where isdelete=0 and Purpose=@FILTER1  )ab

			update Tbl_SACC_EmailMaster
			set isdelete =1
			where isdelete=0 and Purpose=@FILTER1 

			insert into Tbl_SACC_EmailMaster ([from_address],[SUBJECT],[BODY],[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],[Modified_on],[Modified_by],[Purpose],[isdelete])
			select [from_address],REPLACE(@FILTER2,'Subject :','')  ,@FILTER3,[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],GETDATE(),@FILTER4,[Purpose],[isdelete]
			from #tempmail

			drop table #tempmail

			select '1'   
	   END
	   
	   
	   IF @PROCESS ='UPDATSMS'
	   BEGIN
	       
			select * into #tempsms from 
			(select [BODY],Modified_on,Modified_by,[Purpose],[isdelete]
			from Tbl_SACC_SMSMaster where isdelete=0 and Purpose=@FILTER1  )ab

			update Tbl_SACC_SMSMaster
			set isdelete =1
			where isdelete=0 and Purpose=@FILTER1 

			insert into Tbl_SACC_SMSMaster ([BODY],[Modified_on],[Modified_by],[Purpose],[isdelete])
			select @FILTER3,GETDATE(),@FILTER4,[Purpose],[isdelete]
			from #tempsms

			drop table #tempsms

			select '1'   
	   END


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_GETDATA24062016
-- --------------------------------------------------
-- =============================================
-- Author:		PRAMOD JADHAV
-- Create date:     28 FEB 2016
-- Description:	GET SACC RFLATED DATA

-- [USP_SACC_GETDATA]'VERIFIED',1,1,'Compliance','Trading terminals ','E57289'
-- =============================================
create PROCEDURE [dbo].[USP_SACC_GETDATA24062016]
@PROCESS AS VARCHAR(50)='',
@FILTER1 AS VARCHAR(800)='',
@FILTER2 AS VARCHAR(max)='',
@FILTER3 AS VARCHAR(max)='',
@FILTER4 AS VARCHAR(max)='',
@FILTER5 AS VARCHAR(100)='',
@FILTER6 AS VARCHAR(100)='',
@FILTER7 AS VARCHAR(100)='',
@FILTER8 AS VARCHAR(100)=''	
AS
BEGIN

	   IF @PROCESS ='GET_ZONEREGIONBRANCH'
	   BEGIN
	       ---SELECT ZONE,REGION,BR_CODE,BRANCHNAME FROM [196.1.115.132].RISK.DBO.ZONE_REGION_BRANCH WHERE ZONE  IS NOT NULL 
	       select distinct zone,region,REGIONNAME,branch,BRANCHNAME from [196.1.115.167].SB_COMP.dbo.VW_ACTIVESACC_BROKER where zone is not null and region is not null and branch is not null
	   END
	   
	   IF @PROCESS ='GET_ANS'
	   BEGIN
	   --TABLE 1
	       SELECT ANS .*,OP.OPTIONS FROM TBL_TR_ANSWER ANS
	       JOIN (SELECT QUESTION_NO,OPTION_TYPE FROM TBL_QUESTION_MASTER WHERE IS_APPROVED =1) QN
	       ON QN.QUESTION_NO =ANS.QUESTION_NO 
	       JOIN TBL_OPTIONS OP
	       ON OP.OPTION_TYPE=QN.OPTION_TYPE
	        WHERE ENTRY_ID =@FILTER1 
	        ORDER BY ANS.QUESTION_NO 
	        
	        --TABLE 2
	        
	        SELECT ENTRY_ID,SB_LOGIN_ID,SB_NAME,BRANCH_TAG,MOBILE  FROM TBL_ANNEXTURE WHERE ENTRY_ID =@FILTER1
	   END
	   
	   
	    IF @PROCESS ='GET_SACCDATA'
	      BEGIN
			-- SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+'/'+ DBO.UDF_GET_TOTALQUESTION() AS 'Ans_Qn' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN 'COMPLETED' ELSE 'NOT COMPLETED'  END AS 'STATUS',Last_Transaction_Time AS 'LAST UPDATED',Entry_Id  
			--FROM tbl_answer) A
			--JOIN 
			--(select  sb_Login_ID as SBTAG ,sb_Name 'LONG_NAME',branch_tag 'BRANCH_CD',pan_no 'PAN_GIR_NO',Email AS 'EMAIL',Mobile 'MOBILE_PAGER'   
			--from TBL_ANNEXTURE )B
			--ON A.SBTAG=B.SBTAG
			--JOIN(SELECT Entry_id,COUNT(Question_no) AS 'ANSNUM' FROM tbl_tr_answer
			--GROUP BY Entry_id)C
			--ON C.Entry_id =A.Entry_Id 
			--order by A.[LAST UPDATED] desc
			
	 declare @str as varchar(max)
	
	   --       set @str=' select * from (select z.*,q.zone,q.region,q.branch,q.BRANCHNAME from (SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Ans_Qn'' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN ''COMPLETED'' ELSE ''NOT COMPLETED''  END AS ''STATUS'',Last_Transaction_Time AS ''LAST UPDATED'',Entry_Id  
			 --FROM tbl_answer) A
			 --JOIN 
			 --(select  sb_Login_ID as SBTAG ,sb_Name ''LONG_NAME'',branch_tag ''BRANCH_CD'',pan_no ''PAN_GIR_NO'',Email AS ''EMAIL'',Mobile ''MOBILE_PAGER''   
			 --from TBL_ANNEXTURE )B
			 --ON A.SBTAG=B.SBTAG
			 --JOIN(SELECT Entry_id,COUNT(Question_no) AS ''ANSNUM'' FROM tbl_tr_answer
			 --GROUP BY Entry_id)C
			 --ON C.Entry_id =A.Entry_Id )z
			 --join  (select zone,region,branch,BRANCHNAME,SBTAG from [196.1.115.167].SB_COMP.dbo.VW_ACTIVESACC_BROKER ) q
			 --on z.SBTAG=q.SBTAG)ab
			 --'+@FILTER1 +'
			 --order by [LAST UPDATED] desc'
			
			   set @str=' select * from (select z.*,q.zone,q.region,q.branch,q.BRANCHNAME from (SELECT B.*, CAST( c.[ANSNUM] AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Ans_Qn''
						, CAST( isnull(ver.[VERSUM],0) AS VARCHAR(50))+''/''+ DBO.UDF_GET_TOTALQUESTION() AS ''Verified'' ,A.STATUS ,A.[LAST UPDATED],A.Entry_Id 
						,case when (isnull(ver.[VERSUM],0)= cast(DBO.UDF_GET_TOTALQUESTION() as int)) then 1 else 0 end as  VerStatus
						FROM (SELECT SBTAG,CASE WHEN Is_Complete=1 THEN ''COMPLETED'' ELSE ''NOT COMPLETED''  END AS ''STATUS'',
						Last_Transaction_Time AS ''LAST UPDATED'',Entry_Id  
						FROM tbl_answer) A
						JOIN 
						(select  sb_Login_ID as SBTAG ,sb_Name ''LONG_NAME'',branch_tag ''BRANCH_CD'',pan_no ''PAN_GIR_NO'',Email AS ''EMAIL'',Mobile ''MOBILE_PAGER''   
						from TBL_ANNEXTURE )B
						ON A.SBTAG=B.SBTAG
						JOIN(SELECT Entry_id,COUNT(Question_no) AS ''ANSNUM'' FROM tbl_tr_answer
						GROUP BY Entry_id)C
						ON C.Entry_id =A.Entry_Id 
						left join
						(select Entry_id, isnull( COUNT(1),0) as VERSUM from tbl_tr_answer
						where Maker_ans IS NOT NULL
						group by Entry_id)ver
						on ver.Entry_id =c.Entry_Id 
						)z
						left join  (select zone,region,branch,BRANCHNAME,SBTAG from [196.1.115.167].SB_COMP.dbo.VW_ACTIVESACC_BROKER ) q
						on z.SBTAG=q.SBTAG)ab
						'+@FILTER1 +'
						order by [LAST UPDATED] '
			 
			 exec  (@str)
	   END

	   IF @PROCESS ='VERIFIED'
	   BEGIN
	   
	   -- [USP_SACC_GETDATA]'VERIFIED',2,1,'Compliance','Trading terminals ','E57289'
	       UPDATE TBL_TR_ANSWER
	       SET Maker_ans=@FILTER3,
	       Maker_remark=@FILTER4 ,
	       Verified_on=GETDATE() ,
	       VERIFIED_BY=@FILTER5 
	       WHERE Entry_id =@FILTER1 AND Question_no=@FILTER2
	       
	       SELECT GETDATE() AS DATES
	         --added by suraj start
            declare @count as int
          
            select @count = COUNT(1) from tbl_tr_answer where Maker_ans is not null and Entry_id=@FILTER1
            
            print(@count)
            if @count =38
            begin
                    declare  @Email_conf as int    
                    SELECT @Email_conf = isnull(Email_conf,0)  FROM Tbl_answer WHERE Entry_id=@FILTER1  
             
                    if @Email_conf <> 1   
                    begin
                          --attachment start
                    truncate table temp1
                    insert into temp1 values(0,'Question','Answer','remark','attachment','Verified_answer','Verified_remark')
                    insert into temp1 select REPLACE(REPLACE(replace(Question_no, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Question, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Answer, ',', ' '), CHAR(13), ''), CHAR(10), ''), REPLACE(REPLACE(replace(remark, ',', ' '), CHAR(13), ''), CHAR(10), ''), REPLACE(REPLACE(replace(attachment, ',', ' '), CHAR(13), ''), CHAR(10), ''),REPLACE(REPLACE(replace(Maker_ans, ',', ' '), CHAR(13), ''), CHAR(10), '') as Verified_answer,REPLACE(REPLACE(replace(Maker_remark, ',', ' '), CHAR(13), ''), CHAR(10), '')as Verified_remark from compliance.dbo.Tbl_tr_answer where Entry_id = @FILTER1
                    declare  @SQLStatement as varchar(2000)
                    select @SQLStatement = 'bcp " select * from compliance.dbo.temp1  " queryout \\196.1.115.183\d$\upload_sacc\compliance.csv /c /t, -T -S' + @@servername
                    exec master..xp_cmdshell @SQLStatement 
                    print @SQLStatement  


                    declare @strAttach varchar(max)                            
                    set @strAttach = '\\196.1.115.183\d$\upload_sacc\compliance.csv'   
                    --attachment end

                        declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)  
                        set @Orisubject = (select [SUBJECT] from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0 )  
                        set @fromAddress=(select from_address from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0 )  
                        set @oribody = (select body from [Tbl_SACC_EmailMaster] where Purpose ='Confermation_Email' and isdelete = 0  )  
                        EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL    
                        @subject = @Orisubject,  
                        @from_address = @fromAddress,  
                        @body = @oribody,-- ,  
                        @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc  
                        @RECIPIENTS = 'pramod.jadhav@angelbroking.com;suraj.patil@angelbroking.com;kinnari.solanki@angelbroking.com',  
                        @body_format = 'html',
                        @file_attachments=@strAttach  
                        --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag  
                        --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 , 
                        DECLARE @COMPLIANCE_COUNT AS INT
                        DECLARE @NONCOMPLIANCE_COUNT AS INT
                        DECLARE @NOTAPPLICABLE_COUNT AS INT
                        
                        SELECT  @COMPLIANCE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans IN ('Compliance','Yes') and Entry_id =@FILTER1
                        SELECT  @NONCOMPLIANCE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans IN ('Not compliance','No') and Entry_id =@FILTER1
                        SELECT  @NOTAPPLICABLE_COUNT = COUNT(1) FROM Tbl_tr_answer WHERE Maker_ans not IN ('Compliance','Yes','Not compliance','No') and Entry_id =@FILTER1
                        
                     
                        
                        
                        update Tbl_answer
                        set Email_conf =1,
                        is_Verified = 1,
                        verified_date =GETDATE(),
                        COMPLIANCE_COUNT =@COMPLIANCE_COUNT,
                        NONCOMPLIANCE_COUNT=@NONCOMPLIANCE_COUNT,
                        NOTAPPLICABLE_COUNT=@NOTAPPLICABLE_COUNT
                        
                        where Entry_id=@FILTER1
                        
                        
                        
                     end
                     
                    declare  @sms_conf as int    
                    SELECT @sms_conf = isnull(sms_conf,0)  FROM Tbl_answer WHERE Entry_id=@FILTER1  
                    if @sms_conf <> 1   
                    begin
                        ----------------sms start----------------------------
                        declare @mobile as varchar(20)
                        set @mobile = '9860229924'
                        declare @sbtag as varchar(20)
                        set @sbtag = ''
                         select @sbtag= SBTAG  FROM Tbl_answer WHERE Entry_id=@FILTER1
                        select @mobile = Mobile from Tbl_annexture where sb_Login_ID = @sbtag 
                        insert into [196.1.115.132].sms.dbo.sms (to_no,message,date,time,flag,ampm,purpose)  
                        select  No, sms_msg, sms_dt ,sms_time, flag,ampm,purpose from     
                        (    
                        select @mobile as No,
                        'Dear Partner, we have reviewed your Self Assessment Compliance Checklist (SACC) for BranchTag/SBTag & have sent updated report with remarks on your email id.​' as sms_msg ,
                        convert(varchar(10), getdate(), 103) as sms_dt,
                        ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate())))))  as sms_time,
                        'P' as flag,
                        case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end  as ampm,
                        'SB_SACC_Review'as Purpose
                        )a    
                        ----------------sms end----------------------------

                    
                    
                        update Tbl_answer
                        set sms_conf =1
                        where Entry_id=@FILTER1
                        
                     end
      
            end
	       
	       
	       
	       
	   END
	   
	   IF @PROCESS ='GETEMAIL'
	   BEGIN
	       
	       select SUBJECT ,BODY ,Purpose  from Tbl_SACC_EmailMaster WHERE isdelete =0 and Purpose =@FILTER1 
	       
	       
	   END
	   
	   IF @PROCESS ='UPDATEMAIL'
	   BEGIN
	       
			select * into #tempmail from 
			(select [from_address],[SUBJECT],[BODY],[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],Modified_on,Modified_by,[Purpose],[isdelete]
			from Tbl_SACC_EmailMaster where isdelete=0 and Purpose=@FILTER1  )ab

			update Tbl_SACC_EmailMaster
			set isdelete =1
			where isdelete=0 and Purpose=@FILTER1 

			insert into Tbl_SACC_EmailMaster ([from_address],[SUBJECT],[BODY],[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],[Modified_on],[Modified_by],[Purpose],[isdelete])
			select [from_address],REPLACE(@FILTER2,'Subject :','')  ,@FILTER3,[PROFILE_NAME],[recipients],[COPY_RECIPIENTS],[BLIND_COPY_RECIPIENTS],[FILE_ATTACHMENTS],GETDATE(),@FILTER4,[Purpose],[isdelete]
			from #tempmail

			drop table #tempmail

			select '1'   
	   END


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sacc_insertrecord
-- --------------------------------------------------
-- =============================================
-- Author:	suraj patil
-- Create date: 25-01-2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_sacc_insertrecord]
@Entry_id as int,
@Question_no as int,
@Question as nvarchar(max),
@Answer as nvarchar(50),
@remark as nvarchar(max)='',
@Attachment as nvarchar(max)='',
@Answered_on as nvarchar(200)='',
@current_tab as int=''
AS
BEGIN
DECLARE @COUNT AS INT=0;  
--SELECT * FROM Tbl_tr_answer WHERE Question_no='2' and Entry_id='1'
SELECT @COUNT= COUNT(*) FROM Tbl_tr_answer WHERE Question_no=@Question_no and Entry_id=@Entry_id

if(@COUNT = 0)
begin
    insert into Tbl_tr_answer(Entry_id,Question_no,Question,Answer,remark,Attachment,Answered_on) values(@Entry_id,@Question_no,@Question,@Answer,@remark,@Attachment,@Answered_on)
end
else
begin
update  Tbl_tr_answer
set Entry_id=@Entry_id,
Question_no =@Question_no,
Question=@Question,
Answer=@Answer,
remark=@remark,
Attachment=@Attachment,
Answered_on=@Answered_on
WHERE Question_no=@Question_no and Entry_id=@Entry_id
end


if(@current_tab <> '')
begin
update tbl_answer
set Current_Tab = @current_tab
where Entry_id=@Entry_id
end

update tbl_answer
set Last_Transaction_Time = GETDATE()
where Entry_id=@Entry_id


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_MIS
-- --------------------------------------------------

-- =============================================
-- Author:		Suraj Patil 
-- Create date: 07-04-2016
-- Description:	Sacc MIS report
--USP_SACC_MIS '','','','','','',''
-- =============================================
CREATE PROCEDURE [dbo].[USP_SACC_MIS]
	@ZONE AS VARCHAR(100)='',
	@REGION AS VARCHAR(100)='',
	@BRANCH AS VARCHAR(100)='',
	@SBTAG AS VARCHAR(100)='',
	@FROMDATE AS VARCHAR(100)='',
	@TODATE AS VARCHAR(100)='',
	@CATEGORY AS VARCHAR(100)=''
AS
BEGIN
        DECLARE @STR AS VARCHAR(MAX)
        SET @STR=''
        IF @ZONE <> '' OR @REGION <> '' OR @BRANCH <> ''  OR @SBTAG <> ''  OR @FROMDATE <> ''  OR @TODATE <> '' OR @CATEGORY <> '' 
        begin          
            IF @ZONE <> '' 
            begin 
                SET @STR = @STR + ' WHERE a.ZONE = '''+@ZONE+''''
            end
            IF @REGION <> '' 
            begin 
                SET @STR = @STR + ' WHERE  a.REGION = '''+@REGION+''''                
            end
            IF @BRANCH <> '' 
            begin 
                DECLARE @BRANCH_TAG  AS VARCHAR(50)
                SELECT @BRANCH_TAG = BRANCH FROM BRANCH_MASTER WHERE BRANCHNAME = @BRANCH
                SET @BRANCH = @BRANCH_TAG
                SET @STR = @STR + ' WHERE  a.BRANCH = '''+@BRANCH+''''     
            end
            IF @SBTAG <> '' 
            begin 
                SET @STR = @STR + ' WHERE  a.sb_Login_ID = '''+@SBTAG+''''                     
            end
            IF @FROMDATE <> '' 
            begin 
                SET @STR = @STR + ' WHERE  b.VERIFIED_DATE BETWEEN CAST( '''+@FROMDATE+''' AS DATE) AND CAST( '''+@TODATE+''' AS DATE)'                          
            end
              IF @CATEGORY <> '' 
            begin 
                SET @STR = @STR + ' WHERE  a.category = '''+@CATEGORY+''''                     
            end
            
            set @STR ='select a.sb_Login_ID as SBTAG,a.sb_Name,a.zone,a.region,a.branch_tag,a.category,b.COMPLIANCE_COUNT as Compliance,
            b.NONCOMPLIANCE_COUNT as Noncompliance ,b.NOTAPPLICABLE_COUNT as Notapplicable  from tbl_annexture a
            join Tbl_answer b on a.Entry_id=b.Entry_Id '+@STR
            
            print @str
            exec (@str)
             
            
            
        end 
        else
        begin
           select a.sb_Login_ID as SBTAG,a.sb_Name,a.zone,a.region,a.branch_tag,a.category,b.COMPLIANCE_COUNT as Compliance,
            b.NONCOMPLIANCE_COUNT as Noncompliance ,b.NOTAPPLICABLE_COUNT as Notapplicable  from tbl_annexture a
            join Tbl_answer b on a.Entry_id=b.Entry_Id

        end
        
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACC_SendEmail
-- --------------------------------------------------
-- =============================================
-- Author:		suraj patil
-- Create date:     01/02/2016
-- Description:	<Description,,>
--USP_SACC_SendEmail 'dbn',''
-- =============================================
CREATE PROCEDURE [dbo].[USP_SACC_SendEmail]
	@sbtag varchar(30),
	@purpose varchar(50)
	
AS
BEGIN

DECLARE @COUNT AS INT=0;  
SELECT @COUNT = Email_Ack  FROM Tbl_answer WHERE sbtag=@sbtag
 print @count
if @COUNT <> 1
begin
--DECLARE @subject as varchar(100);
--DECLARE @from_address as varchar(30);
--DECLARE @body as varchar(1000);
--DECLARE @profile_name as varchar(100);
--DECLARE @recipients as varchar(30);
--DECLARE @FILE_ATTACHMENTS as varchar(100);


declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)
set @Orisubject = (select [SUBJECT] from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )
set @fromAddress=(select from_address from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 )
set @oribody = (select body from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0  )
 EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL  
@subject = @Orisubject,
@from_address = @fromAddress,
@body = @oribody,-- ,
@PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc
@RECIPIENTS = 'pramod.jadhav@angelbroking.com;suraj.patil@angelbroking.com;harish.upadhyay@angelbroking.com',
@body_format = 'html'
 --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag
--@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 ,


end


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACCAnnexture
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj Patil
-- Create date: 22062016
-- Description:	Annexture operations
-- =============================================

--select * from tbl_terminaldetails
CREATE PROCEDURE USP_SACCAnnexture
@process as varchar(20),
@sbtag as varchar(30),
@OdianID as varchar(30),
@newTerminaladdress as varchar(30)='',
@newActualUser as varchar(30)='',
@dateofbirth as varchar(30)='',
@Residencyaddress as varchar(30)='',
@panno as varchar(30)='',
@connectivity as varchar(30)=''

AS
BEGIN
    Declare @count as int
    set @count =0
    if(@process='annexture1')
    begin
        update tbl_terminaldetails
        set newTerminaladdress=@newTerminaladdress
        where sbtag=@sbtag and OdianID=@OdianID
    end
    if(@process='annexture2')
    begin
        update tbl_terminaldetails
        set newActualUser=@newActualUser,dateofbirth = @dateofbirth, Residencyaddress = @Residencyaddress, panno = @panno, connectivity = @connectivity
        where sbtag=@sbtag and OdianID=@OdianID
    end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SACCVERIFYANNEXTURE
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj Patil
-- Create date: 23062016
-- Description:	SACC verify process annexture details
-- =============================================
CREATE PROCEDURE USP_SACCVERIFYANNEXTURE 
    @process as varchar(50),
	@Entryid as int
AS
BEGIN
	select * from Tbl_terminaldetails  where Entryid = @Entryid
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SyncAnnextureAddress
-- --------------------------------------------------


        

-- =============================================        

-- Author:  Suraj Patil        

-- Create date: 23/12/2016        

-- Description: Sync terminal address        

-- =============================================        

CREATE PROCEDURE [dbo].[USP_SyncAnnextureAddress]        

         

AS        

BEGIN        

			set IDENTITY_INSERT Tbl_annexture_log ON

			insert into Tbl_annexture_log(Entry_id,sb_Name,sb_Login_ID,Approved_Address,Actual_Address,Exchange,

			Segment,Approved_User,Relation_with_approved_user,new_branch_tag,

			new_sb_tag,new_user_name,new_certificate_no,new_user_pan_no,

			branch_tag,pan_no,Email,Mobile,Actual_user,

			Terminal_Active,region,zone,verified_date,category,Logdate)

			

			select Entry_id,sb_Name,sb_Login_ID,Approved_Address,Actual_Address,Exchange,

			Segment,Approved_User,Relation_with_approved_user,new_branch_tag,

			new_sb_tag,new_user_name,new_certificate_no,new_user_pan_no,

			branch_tag,pan_no,Email,Mobile,Actual_user,

			Terminal_Active,region,zone,verified_date,category,GETDATE()  from  Tbl_annexture

			set IDENTITY_INSERT Tbl_annexture_log OFF

             

       Declare @sb_Login_ID as varchar(100)        

       DECLARE @CursorForsb_Login_ID CURSOR        

       SET @CursorForsb_Login_ID = CURSOR FAST_FORWARD        

       FOR        

       SELECT distinct  sb_Login_ID         

       FROM   Tbl_annexture         

             

       OPEN @CursorForsb_Login_ID        

       FETCH NEXT FROM @CursorForsb_Login_ID        

       INTO @sb_Login_ID        

       WHILE @@FETCH_STATUS = 0        

       BEGIN        

			            

				BEGIN TRY



						IF OBJECT_ID('tempdb..#table') IS NOT NULL        

						DROP TABLE #table 



						create table #table ([sb_Login_ID] varchar(50),[Approved_Address] varchar(max)) 

						insert into #table

						select top 1 SBTAG, [REGADDRESS LINE 1]+' '+[REGADDRESS LINE 2]+' '+REGADRESSLINE3+' '+REGCITY+' '+REGSTATE+' '+REGPIN AS Approved_Address 

						from [MIS].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where SBtag = @sb_Login_ID

						

						

						update a

						set a.Approved_Address =b.Approved_Address

						from Tbl_annexture a

						left join

						#table b

						on a.sb_Login_ID = b.sb_Login_ID

						where a.sb_Login_ID = @sb_Login_ID





				End Try 

				Begin Catch 

				End catch    

                 

      FETCH NEXT FROM @CursorForsb_Login_ID        

      INTO @sb_Login_ID        

       END        

       CLOSE @CursorForsb_Login_ID        

       DEALLOCATE @CursorForsb_Login_ID        

               

       --Send email start        

      declare @Orisubject  varchar(max),@fromAddress varchar(50),@oribody varchar(max)        

      set @Orisubject = 'SACC Approved address updation process'        

      set @fromAddress='suraj.patil@angelbroking.com'        

      set @oribody = '<p>Dear Team,</p><p>SACC Approved address update  process completed successfully at '+ cast(GETDATE() as varchar(30)) +' .</p><p>Thank you</p>'        

      EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL          

      @subject = @Orisubject,        

      @from_address = @fromAddress,        

      @body = @oribody,

      @PROFILE_NAME ='intranet',

      @RECIPIENTS = 'suraj.patil@angelbroking.com',        

      @body_format = 'html'        

   

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SyncTerminalAddress
-- --------------------------------------------------
        
-- =============================================        
-- Author:  Suraj Patil        
-- Create date: 23/12/2016        
-- Description: Sync terminal address        
-- =============================================        
CREATE PROCEDURE [dbo].[USP_SyncTerminalAddress]        
         
AS        
BEGIN        
   
       insert into tbl_terminaldetails_Log      
       select *,GETDATE() from tbl_terminaldetails      
             
             
       Declare @OdianID as varchar(100)        
       DECLARE @CursorForOdianid CURSOR        
       SET @CursorForOdianid = CURSOR FAST_FORWARD        
       FOR        
       SELECT distinct  sbtag as odianid        
       FROM   tbl_terminaldetails         
             
       OPEN @CursorForOdianid        
       FETCH NEXT FROM @CursorForOdianid        
       INTO @OdianID        
       WHILE @@FETCH_STATUS = 0        
       BEGIN        
			            
			    BEGIN TRY
			                 
				  IF OBJECT_ID('tempdb..#table') IS NOT NULL        
				  DROP TABLE #table        
				  create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(500),Segment varchar(50))        
				  insert into #table        
				  exec sp_CTCL_new @OdianID        
			             
					DECLARE @Odianid_new varchar(max)        
					DECLARE @Terminaladdr varchar(max)        
					DECLARE @ColWorkid int        
					--------------------------------------------------------        
					DECLARE @MyCursor CURSOR        
					SET @MyCursor = CURSOR FAST_FORWARD        
					FOR        
					SELECT  [Login/Odin Id] as odianid,[Terminal Address] as addr        
					FROM   #table         
			             
					set @ColWorkid = 1        
			             
					OPEN @MyCursor        
					FETCH NEXT FROM @MyCursor        
					INTO @Odianid_new,@Terminaladdr        
					WHILE @@FETCH_STATUS = 0        
					BEGIN        
					 -- print(cast(@ColWorkid as varchar(10)) + '   '+@Odianid_new+' '+  @Terminaladdr)        
				   update tbl_terminaldetails         
				   set TerminalAddress = @Terminaladdr        
				   where OdianID = @Odianid_new         
             
					set @ColWorkid = @ColWorkid + 1        
					FETCH NEXT FROM @MyCursor        
					INTO  @Odianid_new,@Terminaladdr        
					END        
					CLOSE @MyCursor        
					DEALLOCATE @MyCursor     
			End Try 
			Begin Catch 
			End catch    
                 
      FETCH NEXT FROM @CursorForOdianid        
      INTO @OdianID        
       END        
       CLOSE @CursorForOdianid        
       DEALLOCATE @CursorForOdianid        
               
       --Send email start        
      declare @Orisubject  varchar(max),@fromAddress varchar(50),@oribody varchar(max)        
      set @Orisubject = 'SACC Terminal address updation process'        
      set @fromAddress='suraj.patil@angelbroking.com'        
      set @oribody = '<p>Dear Team,</p><p>SACC Terminal address update  process completed successfully at '+ cast(GETDATE() as varchar(30)) +' .</p><p>Thank you</p>'        
      EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL          
      @subject = @Orisubject,        
      @from_address = @fromAddress,        
      @body = @oribody,-- ,        
      @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc        
      @RECIPIENTS = 'suraj.patil@angelbroking.com',        
      @body_format = 'html'        
      --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag        
      --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 ,        
               
       --Send Email End        
 --END TRY  
 --BEGIN CATCH  
 --        --declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)        
 --     set @Orisubject = 'SACC Terminal address updation process'        
 --     set @fromAddress='suraj.patil@angelbroking.com'        
 --     set @oribody = '<p>Dear Team,</p><p>SACC Terminal address update  process failed at '+ cast(GETDATE() as varchar(30)) +' .</p><p>Thank you</p>'        
 --     EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL          
 --     @subject = @Orisubject,        
 --     @from_address = @fromAddress,        
 --     @body = @oribody,-- ,        
 --     @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc        
 --     @RECIPIENTS = 'suraj.patil@angelbroking.com',        
 --     @body_format = 'html'   
 --END CATCH  
 
--update [172.31.16.75].angel_wms.dbo.users
--set isTradingClient = 'Y'
--where loginID = 'geo1'
 
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SyncTerminalAddress13012017
-- --------------------------------------------------
        
-- =============================================        
-- Author:  Suraj Patil        
-- Create date: 23/12/2016        
-- Description: Sync terminal address        
-- =============================================        
create  PROCEDURE [dbo].[USP_SyncTerminalAddress13012017]        
         
AS        
BEGIN        
  BEGIN TRY  
       insert into tbl_terminaldetails_Log      
       select *,GETDATE() from tbl_terminaldetails      
             
             
       Declare @OdianID as varchar(50)        
       DECLARE @CursorForOdianid CURSOR        
       SET @CursorForOdianid = CURSOR FAST_FORWARD        
       FOR        
       SELECT distinct  sbtag as odianid        
       FROM   tbl_terminaldetails         
             
       OPEN @CursorForOdianid        
       FETCH NEXT FROM @CursorForOdianid        
       INTO @OdianID        
       WHILE @@FETCH_STATUS = 0        
       BEGIN        
            
                 
      IF OBJECT_ID('tempdb..#table') IS NOT NULL        
      DROP TABLE #table        
      create table #table ([Login/Odin Id] varchar(50),UserName varchar(50),[Terminal Address] varchar(200),Segment varchar(50))        
      insert into #table        
      exec sp_CTCL_new @OdianID        
             
        DECLARE @Odianid_new varchar(max)        
        DECLARE @Terminaladdr varchar(max)        
        DECLARE @ColWorkid int        
        --------------------------------------------------------        
        DECLARE @MyCursor CURSOR        
        SET @MyCursor = CURSOR FAST_FORWARD        
        FOR        
        SELECT  [Login/Odin Id] as odianid,[Terminal Address] as addr        
        FROM   #table         
             
        set @ColWorkid = 1        
             
        OPEN @MyCursor        
        FETCH NEXT FROM @MyCursor        
        INTO @Odianid_new,@Terminaladdr        
        WHILE @@FETCH_STATUS = 0        
        BEGIN        
         -- print(cast(@ColWorkid as varchar(10)) + '   '+@Odianid_new+' '+  @Terminaladdr)        
       update tbl_terminaldetails         
       set TerminalAddress = @Terminaladdr        
       where OdianID = @Odianid_new         
             
       set @ColWorkid = @ColWorkid + 1        
       FETCH NEXT FROM @MyCursor        
       INTO  @Odianid_new,@Terminaladdr        
        END        
        CLOSE @MyCursor        
        DEALLOCATE @MyCursor        
                 
      FETCH NEXT FROM @CursorForOdianid        
      INTO @OdianID        
       END        
       CLOSE @CursorForOdianid        
       DEALLOCATE @CursorForOdianid        
               
       --Send email start        
      declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)        
      set @Orisubject = 'SACC Terminal address updation process'        
      set @fromAddress='suraj.patil@angelbroking.com'        
      set @oribody = '<p>Dear Team,</p><p>SACC Terminal address update  process completed successfully at '+ cast(GETDATE() as varchar(30)) +' .</p><p>Thank you</p>'        
      EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL          
      @subject = @Orisubject,        
      @from_address = @fromAddress,        
      @body = @oribody,-- ,        
      @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc        
      @RECIPIENTS = 'pramod.jadhav@angelbroking.com;suraj.patil@angelbroking.com',        
      @body_format = 'html'        
      --SBTAG FROM [196.1.115.167].SB_COMP.DBO.V_SUBBROKERDETAILS_SACC  where sbtag = @sbtag        
      --@FILE_ATTACHMENTS = FILE_ATTACHMENTS from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 1 ,        
               
       --Send Email End        
 END TRY  
   
 -- The previous GO breaks the script into two batches,  
 -- generating syntax errors. The script runs if this GO  
 -- is removed.  
 BEGIN CATCH  
         --declare @Orisubject  varchar(100),@fromAddress varchar(50),@oribody varchar(max)        
      set @Orisubject = 'SACC Terminal address updation process'        
      set @fromAddress='suraj.patil@angelbroking.com'        
      set @oribody = '<p>Dear Team,</p><p>SACC Terminal address update  process failed at '+ cast(GETDATE() as varchar(30)) +' .</p><p>Thank you</p>'        
      EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL          
      @subject = @Orisubject,        
      @from_address = @fromAddress,        
      @body = @oribody,-- ,        
      @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc        
      @RECIPIENTS = 'suraj.patil@angelbroking.com',        
      @body_format = 'html'   
 END CATCH  
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Upload_clients
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj Patil
-- Create date: 04-04-2016
-- Description:	for bulk copy
-- =============================================
CREATE PROCEDURE USP_Upload_clients
	@myTableType [MyTableType_forupload] readonly
AS
BEGIN
	insert into TBL_UPLOAD_MASTER SELECT * from @myTableType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Verify
-- --------------------------------------------------
-- =============================================  
-- Author:  Suraj Patil  
-- Create date: 21-04-2016  
-- Description: To verify subbroker completed SACC or not.  
--          USP_Verify 'hoet'  
-- =============================================  
CREATE PROCEDURE [dbo].[USP_Verify]  
 @sbtag as varchar(30)  
AS  
BEGIN  
  
declare @count as int  
declare @UserType as varchar(50)=''  
  
select @UserType = usertype from ROLEMGM.dbo.user_login where username = @sbtag  
  
  
set @count = 0  
  select @count = b.Questioncount from (  
  (select SBTAG,Entry_Id from Tbl_answer  where SBTAG = @sbtag) a  
  join (select COUNT(1) as Questioncount,entry_id from Tbl_tr_answer    group by Entry_id) b  
  on  
  a.Entry_Id = b.Entry_id )  
--select @count = COUNT(1)  from TBL_UPLOAD_MASTER where SB_TAG =@sbtag  
    if @count  = 39  
        begin  
        select 0  
        end  
    else   
        begin   
         if(@UserType='admin' or @UserType='USER')  
   begin  
     select 2  
   end  
   else  
   begin  
    select 0  
   end  
       
        end  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Verify07062017
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj Patil
-- Create date: 21-04-2016
-- Description:	To verify subbroker completed SACC or not.
--          USP_Verify 'dbn'
-- =============================================
create PROCEDURE [dbo].[USP_Verify07062017]
	@sbtag as varchar(30)
AS
BEGIN

declare @count as int
set @count = 0

select @count = COUNT(1)  from TBL_UPLOAD_MASTER where SB_TAG =@sbtag
    if @count  = 0
        begin
        select 0
        end
    else 
        begin 
        set @count = 0       
        select @count = isnull(NO_OF_ATTEMPTS,0)  from TBL_UPLOAD_MASTER where SB_TAG =@sbtag
        
        if cast (@count as int)  < 3
            begin
                update  TBL_UPLOAD_MASTER
                set NO_OF_ATTEMPTS = (NO_OF_ATTEMPTS + 1) 
                where SB_TAG = @sbtag
                
                select 1
            end
        else
            begin
            select 2
            end
        
        end


END

GO

-- --------------------------------------------------
-- TABLE dbo.branch_master
-- --------------------------------------------------
CREATE TABLE [dbo].[branch_master]
(
    [branchName] VARCHAR(100) NULL,
    [branch] VARCHAR(10) NULL,
    [region] VARCHAR(255) NULL,
    [zone] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPS_MIS_temp_RENAMED_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[NPS_MIS_temp_RENAMED_PII]
(
    [ClientCode] VARCHAR(12) NULL,
    [Region] VARCHAR(50) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NOT NULL,
    [UserType] VARCHAR(20) NULL,
    [SurveyDate] DATETIME NULL,
    [Response_Date] DATETIME NULL,
    [Rating] INT NULL,
    [Suggestion] VARCHAR(500) NULL,
    [Suggestion_Type] VARCHAR(500) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [ActivationDate] DATETIME NULL,
    [Persona] VARCHAR(8000) NULL,
    [OnBoardingPersona] VARCHAR(10) NULL,
    [gender] CHAR(1) NULL,
    [Age] INT NULL,
    [b2c] VARCHAR(1) NULL,
    [Online] VARCHAR(3) NOT NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [short_name] VARCHAR(21) NOT NULL
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
-- TABLE dbo.Tbl_annexture
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_annexture]
(
    [Entry_id] INT IDENTITY(1,1) NOT NULL,
    [sb_Name] NVARCHAR(100) NULL,
    [sb_Login_ID] NVARCHAR(100) NULL,
    [Approved_Address] NVARCHAR(500) NULL,
    [Actual_Address] NVARCHAR(500) NULL,
    [Exchange] NVARCHAR(100) NULL,
    [Segment] NVARCHAR(100) NULL,
    [Approved_User] NVARCHAR(100) NULL,
    [Relation_with_approved_user] NVARCHAR(100) NULL,
    [new_branch_tag] NVARCHAR(100) NULL,
    [new_sb_tag] NVARCHAR(100) NULL,
    [new_user_name] NVARCHAR(100) NULL,
    [new_certificate_no] NVARCHAR(100) NULL,
    [new_user_pan_no] NVARCHAR(100) NULL,
    [branch_tag] NVARCHAR(100) NULL,
    [pan_no] NVARCHAR(100) NULL,
    [Email] NVARCHAR(100) NULL,
    [Mobile] NVARCHAR(100) NULL,
    [Actual_user] NVARCHAR(100) NULL,
    [Terminal_Active] NVARCHAR(100) NULL,
    [region] NVARCHAR(100) NULL,
    [zone] NVARCHAR(100) NULL,
    [verified_date] DATE NULL,
    [category] NVARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_annexture_log
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_annexture_log]
(
    [Entry_id] INT IDENTITY(1,1) NOT NULL,
    [sb_Name] NVARCHAR(100) NULL,
    [sb_Login_ID] NVARCHAR(100) NULL,
    [Approved_Address] VARCHAR(1000) NULL,
    [Actual_Address] VARCHAR(1000) NULL,
    [Exchange] NVARCHAR(100) NULL,
    [Segment] NVARCHAR(100) NULL,
    [Approved_User] NVARCHAR(100) NULL,
    [Relation_with_approved_user] NVARCHAR(100) NULL,
    [new_branch_tag] NVARCHAR(100) NULL,
    [new_sb_tag] NVARCHAR(100) NULL,
    [new_user_name] NVARCHAR(100) NULL,
    [new_certificate_no] NVARCHAR(100) NULL,
    [new_user_pan_no] NVARCHAR(100) NULL,
    [branch_tag] NVARCHAR(100) NULL,
    [pan_no] NVARCHAR(100) NULL,
    [Email] NVARCHAR(100) NULL,
    [Mobile] NVARCHAR(100) NULL,
    [Actual_user] VARCHAR(200) NULL,
    [Terminal_Active] VARCHAR(200) NULL,
    [region] VARCHAR(200) NULL,
    [zone] VARCHAR(200) NULL,
    [verified_date] DATE NULL,
    [category] VARCHAR(100) NULL,
    [Logdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_annextureffff
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_annextureffff]
(
    [Entry_id] INT IDENTITY(1,1) NOT NULL,
    [sb_Name] NVARCHAR(50) NULL,
    [sb_Login_ID] NVARCHAR(50) NULL,
    [Approved_Address] NVARCHAR(200) NULL,
    [Actual_Address] NVARCHAR(200) NULL,
    [Exchange] NVARCHAR(100) NULL,
    [Segment] NVARCHAR(100) NULL,
    [Approved_User] NVARCHAR(30) NULL,
    [Relation_with_approved_user] NVARCHAR(30) NULL,
    [new_branch_tag] NVARCHAR(50) NULL,
    [new_sb_tag] NVARCHAR(50) NULL,
    [new_user_name] NVARCHAR(50) NULL,
    [new_certificate_no] NVARCHAR(50) NULL,
    [new_user_pan_no] NVARCHAR(50) NULL,
    [branch_tag] NVARCHAR(50) NULL,
    [pan_no] NVARCHAR(50) NULL,
    [Email] NVARCHAR(50) NULL,
    [Mobile] NVARCHAR(50) NULL,
    [Actual_user] VARCHAR(50) NULL,
    [Terminal_Active] VARCHAR(50) NULL,
    [region] VARCHAR(30) NULL,
    [zone] VARCHAR(30) NULL,
    [verified_date] DATE NULL,
    [category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_answer
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_answer]
(
    [Entry_Id] INT IDENTITY(1,1) NOT NULL,
    [SBTAG] NVARCHAR(50) NULL,
    [Current_Tab] INT NULL,
    [Is_Compliance] INT NULL,
    [Is_Complete] INT NULL,
    [Access_To] NVARCHAR(50) NULL,
    [Access_Code] NVARCHAR(50) NULL,
    [User_Name] NVARCHAR(50) NULL,
    [User_Type] NVARCHAR(50) NULL,
    [Last_Transaction_Time] NVARCHAR(50) NULL,
    [Complete_Date] NVARCHAR(50) NULL,
    [Email_Ack] INT NULL,
    [Email_conf] INT NULL,
    [sms_Ack] INT NULL,
    [sms_conf] INT NULL,
    [is_Verified] INT NULL,
    [verified_date] DATE NULL,
    [COMPLIANCE_COUNT] INT NULL,
    [NONCOMPLIANCE_COUNT] INT NULL,
    [NOTAPPLICABLE_COUNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Exception
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Exception]
(
    [Sno] INT IDENTITY(1,1) NOT NULL,
    [Function_Name] VARCHAR(200) NULL,
    [Date_Time] NVARCHAR(50) NULL,
    [Exception_Msg] NCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Exceptionlog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Exceptionlog]
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
-- TABLE dbo.TBL_OPTIONS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_OPTIONS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Option_Type] INT NULL,
    [OPTIONS] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_question_master
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_question_master]
(
    [sno] INT IDENTITY(1,1) NOT NULL,
    [Question_no] INT NOT NULL,
    [Question] NVARCHAR(MAX) NOT NULL,
    [option1] NVARCHAR(50) NULL,
    [option2] NVARCHAR(50) NULL,
    [option3] NVARCHAR(50) NULL,
    [isactivated] INT NULL,
    [upload_option] NVARCHAR(50) NULL,
    [Has_annexture] INT NULL,
    [has_attachment] INT NULL,
    [added_by] NVARCHAR(50) NULL,
    [added_on] NVARCHAR(50) NULL,
    [modified_by] NVARCHAR(50) NULL,
    [modified_on] NVARCHAR(50) NULL,
    [approved_by] NVARCHAR(50) NULL,
    [approved_on] NVARCHAR(50) NULL,
    [is_approved] INT NULL,
    [Option_Type] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_question_master_Gujarati
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_question_master_Gujarati]
(
    [sno] INT IDENTITY(1,1) NOT NULL,
    [Question_no] INT NOT NULL,
    [Question] NVARCHAR(MAX) NOT NULL,
    [option1] NVARCHAR(50) NULL,
    [option2] NVARCHAR(50) NULL,
    [option3] NVARCHAR(50) NULL,
    [isactivated] INT NULL,
    [upload_option] NVARCHAR(50) NULL,
    [Has_annexture] INT NULL,
    [has_attachment] INT NULL,
    [added_by] NVARCHAR(50) NULL,
    [added_on] NVARCHAR(50) NULL,
    [modified_by] NVARCHAR(50) NULL,
    [modified_on] NVARCHAR(50) NULL,
    [approved_by] NVARCHAR(50) NULL,
    [approved_on] NVARCHAR(50) NULL,
    [is_approved] INT NULL,
    [Option_Type] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_question_master_Hindi
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_question_master_Hindi]
(
    [sno] INT IDENTITY(1,1) NOT NULL,
    [Question_no] INT NOT NULL,
    [Question] NVARCHAR(MAX) NOT NULL,
    [option1] NVARCHAR(50) NULL,
    [option2] NVARCHAR(50) NULL,
    [option3] NVARCHAR(50) NULL,
    [isactivated] INT NULL,
    [upload_option] NVARCHAR(50) NULL,
    [Has_annexture] INT NULL,
    [has_attachment] INT NULL,
    [added_by] NVARCHAR(50) NULL,
    [added_on] NVARCHAR(50) NULL,
    [modified_by] NVARCHAR(50) NULL,
    [modified_on] NVARCHAR(50) NULL,
    [approved_by] NVARCHAR(50) NULL,
    [approved_on] NVARCHAR(50) NULL,
    [is_approved] INT NULL,
    [Option_Type] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SACC_EmailMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SACC_EmailMaster]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [from_address] VARCHAR(50) NOT NULL,
    [SUBJECT] VARCHAR(265) NOT NULL,
    [BODY] VARCHAR(5000) NOT NULL,
    [PROFILE_NAME] VARCHAR(30) NULL,
    [recipients] VARCHAR(300) NOT NULL,
    [COPY_RECIPIENTS] VARCHAR(300) NULL,
    [BLIND_COPY_RECIPIENTS] VARCHAR(300) NULL,
    [FILE_ATTACHMENTS] VARCHAR(50) NULL,
    [Modified_on] VARCHAR(30) NULL,
    [Modified_by] VARCHAR(50) NULL,
    [Purpose] VARCHAR(50) NOT NULL,
    [isdelete] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_SACC_SMSMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_SACC_SMSMaster]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [BODY] VARCHAR(1000) NULL,
    [Modified_on] VARCHAR(50) NULL,
    [Modified_by] VARCHAR(50) NULL,
    [Purpose] VARCHAR(50) NULL,
    [isdelete] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_segment_details
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_segment_details]
(
    [SBTAG] NVARCHAR(50) NOT NULL,
    [SEGMENT] NVARCHAR(100) NULL,
    [NCFM/BCSM_REGN_NO] NVARCHAR(50) NULL,
    [VALIDUPTO] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_terminaldetails
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_terminaldetails]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [Entryid] INT NOT NULL,
    [OdianID] VARCHAR(30) NULL,
    [ActualUserName] VARCHAR(50) NULL,
    [TerminalAddress] VARCHAR(200) NULL,
    [segment] VARCHAR(100) NULL,
    [Validity] VARCHAR(30) NULL,
    [NCFM/BCSM] VARCHAR(300) NULL,
    [newActualUser] VARCHAR(300) NULL,
    [newTerminaladdress] VARCHAR(300) NULL,
    [sbtag] VARCHAR(30) NULL,
    [dateofbirth] VARCHAR(30) NULL,
    [Residencyaddress] VARCHAR(30) NULL,
    [panno] VARCHAR(30) NULL,
    [connectivity] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_terminaldetails_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_terminaldetails_Log]
(
    [id] INT NOT NULL,
    [Entryid] INT NOT NULL,
    [OdianID] VARCHAR(30) NULL,
    [ActualUserName] VARCHAR(50) NULL,
    [TerminalAddress] VARCHAR(200) NULL,
    [segment] VARCHAR(100) NULL,
    [Validity] VARCHAR(30) NULL,
    [NCFM/BCSM] VARCHAR(300) NULL,
    [newActualUser] VARCHAR(300) NULL,
    [newTerminaladdress] VARCHAR(300) NULL,
    [sbtag] VARCHAR(30) NULL,
    [dateofbirth] VARCHAR(30) NULL,
    [Residencyaddress] VARCHAR(30) NULL,
    [panno] VARCHAR(30) NULL,
    [connectivity] VARCHAR(30) NULL,
    [Logdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_tr_answer
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_tr_answer]
(
    [Entry_id] INT NULL,
    [Question_no] INT NULL,
    [Question] NVARCHAR(MAX) NULL,
    [Answer] NVARCHAR(50) NULL,
    [remark] NVARCHAR(MAX) NULL,
    [attachment] NVARCHAR(MAX) NULL,
    [answered_on] NVARCHAR(50) NULL,
    [Maker_ans] VARCHAR(50) NULL,
    [Maker_remark] VARCHAR(MAX) NULL,
    [Verified_on] DATETIME NULL,
    [ID] INT IDENTITY(1,1) NOT NULL,
    [VERIFIED_BY] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_UPLOAD_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_UPLOAD_MASTER]
(
    [SB_TAG] VARCHAR(25) NOT NULL,
    [NO_OF_ATTEMPTS] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1]
(
    [Question_no] INT NULL,
    [Question] NVARCHAR(MAX) NULL,
    [Answer] VARCHAR(MAX) NULL,
    [remark] NVARCHAR(MAX) NULL,
    [attachment] NVARCHAR(MAX) NULL,
    [Verified_answer] VARCHAR(50) NULL,
    [Verified_remark] VARCHAR(MAX) NULL
);

GO

