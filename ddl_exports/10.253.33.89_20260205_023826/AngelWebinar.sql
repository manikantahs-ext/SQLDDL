-- DDL Export
-- Server: 10.253.33.89
-- Database: AngelWebinar
-- Exported: 2026-02-05T02:38:29.337478

USE AngelWebinar;
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
-- PK_UNIQUE dbo.ErorLog
-- --------------------------------------------------
ALTER TABLE [dbo].[ErorLog] ADD CONSTRAINT [PK_ErorLog] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B6107020F21] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_WebinarRegistered
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_WebinarRegistered] ADD CONSTRAINT [PK_tbl_WebinarRegistered] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CheckClientsMapped
-- --------------------------------------------------


/*
		
	exec CheckClientsMapped 'e60022', 'A100073' 

*/

CREATE PROC [dbo].[CheckClientsMapped]
(
	@EMPNO varchar (100)
	,@Party_Code varchar(100)
)
AS
BEGIN

Declare @ClientExists varchar (10)

DECLARE @PartyList TABLE
(
	Dealer_Code varchar(100)
	,Party_Code varchar(100)
)

INSERT INTO @PartyList(Party_Code)
EXEC [mimansa].CRM.DBO.USP_CRMSACCESS @EMPNO = @EMPNO -- 'e60022'     
      ,@STATUSID = 'EXECUTIVE'    
      ,@PARTY_CODE = ''    

IF EXISTS(Select * From @PartyList Where Party_Code = @Party_Code)
BEGIN
	SET @ClientExists = 'TRUE'
END
ELSE
BEGIN 
	SET @ClientExists = 'FALSE'
END 

SELECT @ClientExists AS ClientExists 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.getClientDetails
-- --------------------------------------------------

/*
	exec getClientDetails  'a'
	exec getClientDetails  'b'
	exec getClientDetails  'c'
	exec getClientDetails  'Rp61'

*/

CREATE PROC [dbo].[getClientDetails]
(
	@ClientCode varchar(400)
) with recompile
AS

BEGIN

Set @ClientCode= ltrim(rtrim(@ClientCode))

Declare @Count int


	SELECT * INTO #1 FROM  [MIS].[SB_COMP].[dbo].[get_client_details] with (nolock)
	WHERE clientcode = @ClientCode
	
	Select @count =Count(0) from #1 where isnull(clientcode,'')<>''

	IF @COUNT>0
		BEGIN
		 SELECT * FROM #1
		END
	ELSE
		BEGIN
			SELECT 

			PARTY_CODE as clientcode, 

			SUBSTRING (party_name ,1,CHARINDEX(' ', party_name )) as First_name,

			SUBSTRING (party_name ,CHARINDEX(' ', party_name ),LEN(party_name)) as Last_Name,

			MOBILE_NO as Mobile,

			EMAIL_ID AS Email 
		
				from [AngelFO].BSEMFSS.dbo.MFSS_client With(Nolock)  where PARTY_CODE=@ClientCode
		end 

--SELECT 
--	'U115141' as clientcode ,	'NANDKISHOREPUROHIT9@GMAIL.COM' as Email,	
--	'USHA' as First_name,		  'PUROHIT'	as Last_Name,	
--	'7506547572'	as Mobile
	
END

/*
	SELECT * FROM  [MIS].[SB_COMP].[dbo].[get_client_details]  
	WHERE clientcode like '%' + @ClientCode  +'%'
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.getClientDetailsBEE
-- --------------------------------------------------

/*
	exec getClientDetails  'a'
	exec getClientDetails  'b'
	exec getClientDetails  'S194943', '9833361665'
	exec getClientDetails  'Rp61', '9619040060'

*/

CREATE PROC [dbo].[getClientDetailsBEE]
(
	@ClientCode varchar(400)
	,@MobileNo varchar(400)
) with recompile
AS

BEGIN

Set @ClientCode= ltrim(rtrim(@ClientCode))

Declare @Count int

	SELECT * INTO #1 FROM  [MIS].[SB_COMP].[dbo].[get_client_details] with (nolock)
	WHERE clientcode = @ClientCode and MOBILE =  @MobileNo
	
	SELECT @COUNT = COUNT(0) FROM #1 WHERE ISNULL(clientcode,'')<>''

	IF @COUNT > 0
		BEGIN
		 SELECT * FROM #1
		END
	ELSE
		BEGIN
			SELECT 

			PARTY_CODE as clientcode, 

			SUBSTRING (party_name ,1,CHARINDEX(' ', party_name )) as First_name,

			SUBSTRING (party_name ,CHARINDEX(' ', party_name ),LEN(party_name)) as Last_Name,

			MOBILE_NO as Mobile,

			EMAIL_ID AS Email 
		
			from [AngelFO].BSEMFSS.dbo.MFSS_client With(Nolock)  where PARTY_CODE=@ClientCode
			and  MOBILE_NO =  @MobileNo
		END 

--SELECT 
--	'U115141' as clientcode ,	'NANDKISHOREPUROHIT9@GMAIL.COM' as Email,	
--	'USHA' as First_name,		  'PUROHIT'	as Last_Name,	
--	'7506547572'	as Mobile
	
END

/*
	SELECT * FROM  [MIS].[SB_COMP].[dbo].[get_client_details]  
	WHERE clientcode like '%' + @ClientCode  +'%'
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.getUserDetails
-- --------------------------------------------------

-- =============================================
-- Author		:		Jeyapratha Subramani
-- Create date	:		July 9 2020
-- Description	:		Get New customre details by mobile no
-- =============================================
CREATE PROCEDURE [dbo].[getUserDetails] 
	@MobileNo NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	FirstName,
			LastName,
			Mobile,
			Email
	FROM	dbo.tbl_UserRegistered 
	WHERE	Mobile = @MobileNo
	ORDER BY ID DESC
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
-- PROCEDURE dbo.usp_AddAngelClientOnDemandRegistration
-- --------------------------------------------------
/*
	usp_AddNewOnDemandRegistration
	usp_AddAngelClientOnDemandRegistration
*/

CREATE PROC [dbo].[usp_AddAngelClientOnDemandRegistration]
	 @ClientCode varchar(100)
	,@Mobile  varchar(400)
	,@RegistrationDate smalldatetime
	,@RegistrationType   varchar(1000)
AS

BEGIN 

	INSERT INTO Tbl_WebinarAngelClientRegistration
	(
		 Client_code
		,Mobile
		,RegistrationDate
		,RegistrationType
	)
	VALUES
	(
		@ClientCode 
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationType
	)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AddAngelClientUpcomingRegistration
-- --------------------------------------------------
/*

	Tbl_WebinarAngelClientRegistration

	usp_AddNewUpcomingRegistration
	usp_AddAngelClientUpcomingRegistration

*/

CREATE PROC [dbo].[usp_AddAngelClientUpcomingRegistration]
	 @ClientCode varchar(100)		-----
	,@WebinarDate smalldatetime		----- 
	,@WebinarName varchar(500)		-----
	,@StartTime smalldatetime		----
	,@EndTime smalldatetime			----

	,@WebinarKey varchar(400)		----
	,@FirstName varchar(400)		----
	,@LastName varchar(400)			----
	,@Email  varchar(400)			----
	,@Mobile  varchar(400)			----
	,@RegistrationDate smalldatetime	--- 
	,@RegistrationKey  varchar(400)		----
	,@Source  varchar(400)			----
	,@Answer   varchar(100)			----
	,@QuestionKey   varchar(100)	----
	,@JoinUrl   varchar(1000)		----
	,@RegistrationType   varchar(1000)  --- 
AS
BEGIN 

IF NOT EXISTS (SELECT 1 FROM tbl_WebinarRegistered  WHERE WebinarKey =  @WebinarKey)
BEGIN 
	INSERT INTO tbl_WebinarRegistered 
	(
		WebinarName
		,WebinarDate
		,WebinarKey
		,StartTime
		,EndTime
	)
	VALUES
	(
		@WebinarName 
		,@WebinarDate 
		,@WebinarKey
		,@StartTime
		,@EndTime 
	)
END

	INSERT tbl_UserRegistered
	(
		WebinarKey
		,FirstName 
		,LastName 
		,Email 
		,Mobile
		,RegistrationDate 
		,RegistrationKey 
		,[Source] 
		,JoinUrl
		,QuestionKey
		,Answer
		--,ViewedRecording
	)
	VALUES
	(
		 @WebinarKey 
		,@FirstName 
		,@LastName 
		,@Email  
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationKey  
		,@Source  
		,@JoinUrl   
		,@QuestionKey  
		,@Answer
	)

	INSERT INTO Tbl_WebinarAngelClientRegistration
	(
		 Client_code
		,Mobile
		,RegistrationDate
		,RegistrationType
	)
	VALUES
	(
		 @ClientCode 
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationType
	)

	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AddNewOnDemandRegistration
-- --------------------------------------------------
/*
	select * from [dbo].[tbl_UserRegistered]
	select * from [dbo].[tbl_WebinarRegistered]
*/

CREATE PROC [dbo].[usp_AddNewOnDemandRegistration]
	@FirstName varchar(400)
	,@LastName varchar(400)
	,@Email  varchar(400)
	,@Mobile  varchar(400)
	,@RegistrationDate smalldatetime
	,@RegistrationType   varchar(1000)
AS
BEGIN 

	INSERT INTO Tbl_WebinarNewClientRegistration
	(
		 FirstName
		,LastName
		,Email
		,Mobile
		,RegistrationDate
		,RegistrationType
	)
	VALUES
	(
		@FirstName 
		,@LastName 
		,@Email  
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationType
	)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_AddNewUpcomingRegistration
-- --------------------------------------------------

CREATE PROC [dbo].[usp_AddNewUpcomingRegistration]
	-- @ClientCode varchar(100)
	 @WebinarDate smalldatetime
	,@WebinarName varchar(500)
	,@StartTime smalldatetime
	,@EndTime smalldatetime

	,@WebinarKey varchar(400)
	,@FirstName varchar(400)
	,@LastName varchar(400)
	,@Email  varchar(400)
	,@Mobile  varchar(400)
	,@RegistrationDate smalldatetime
	,@RegistrationKey  varchar(400)
	,@Source  varchar(400)
	,@Answer   varchar(100)
	,@QuestionKey   varchar(100)
	,@JoinUrl   varchar(1000)
	,@RegistrationType   varchar(1000)
AS
BEGIN 



IF NOT EXISTS (SELECT 1 FROM tbl_WebinarRegistered  WHERE WebinarKey =  @WebinarKey)
BEGIN 
	INSERT INTO tbl_WebinarRegistered 
	(
		WebinarName
		,WebinarDate
		,WebinarKey
		,StartTime
		,EndTime
	)
	VALUES
	(
		@WebinarName 
		,@WebinarDate 
		,@WebinarKey
		,@StartTime
		,@EndTime 
	)
END

	INSERT tbl_UserRegistered
	(
		WebinarKey
		,FirstName 
		,LastName 
		,Email 
		,Mobile
		,RegistrationDate 
		,RegistrationKey 
		,[Source] 
		,JoinUrl
		,QuestionKey
		,Answer
		--,ViewedRecording
	)
	VALUES
	(
		 @WebinarKey 
		,@FirstName 
		,@LastName 
		,@Email  
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationKey  
		,@Source  
		,@JoinUrl   
		,@QuestionKey  
		,@Answer
	)

	INSERT INTO Tbl_WebinarNewClientRegistration
	(
		 FirstName
		,LastName
		,Email
		,Mobile
		,RegistrationDate
		,RegistrationType
	)
	VALUES
	(
		@FirstName 
		,@LastName 
		,@Email  
		,@Mobile 
		,@RegistrationDate 
		,@RegistrationType
	)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SaveRegistration
-- --------------------------------------------------



create procedure usp_SaveRegistration
(
	@Client_code varchar (50),
	@Mobile  varchar (50),
	@RegistrationDate datetime,
	@RegistrationType  varchar (50)
)
AS
Begin 

INSERT INTO [Tbl_WebinarAngelClientRegistration]
VALUES (
	@Client_code ,
	@Mobile,
	@RegistrationDate ,
	@RegistrationType 
)

END

GO

-- --------------------------------------------------
-- TABLE dbo.ErorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[ErorLog]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Source] NVARCHAR(1000) NULL,
    [Message] NVARCHAR(MAX) NULL,
    [LastDate] SMALLDATETIME NULL DEFAULT (getdate())
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
-- TABLE dbo.tbl_WebinarRegistered
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_WebinarRegistered]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [WebinarName] VARCHAR(500) NULL,
    [WebinarDate] SMALLDATETIME NULL,
    [WebinarKey] VARCHAR(100) NULL,
    [StartTime] SMALLDATETIME NULL,
    [EndTime] SMALLDATETIME NULL
);

GO

