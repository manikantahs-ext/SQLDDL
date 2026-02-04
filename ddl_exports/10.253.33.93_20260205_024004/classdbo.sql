-- DDL Export
-- Server: 10.253.33.93
-- Database: classdbo
-- Exported: 2026-02-05T02:40:11.504477

USE classdbo;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fnNumToWords
-- --------------------------------------------------
CREATE FUNCTION fnNumToWords(@Number Numeric(18,2),@CPaise Char(1))
RETURNS varchar(100) AS  
BEGIN
	--SELECT .dbo.fnNumToWords(12.300, 'n')
	DECLARE @M_Words TABLE (CODE NUMERIC(9) IDENTITY(1,1), WNUMBER INT DEFAULT (0), WWORDS VARCHAR(50))
	INSERT INTO @M_Words(wnumber, wwords) values ('0', 'Zero')
	INSERT INTO @M_Words(wnumber, wwords) values ('1', 'One')
	INSERT INTO @M_Words(wnumber, wwords) values ('2', 'Two')
	INSERT INTO @M_Words(wnumber, wwords) values ('3', 'Three')
	INSERT INTO @M_Words(wnumber, wwords) values ('4', 'Four')
	INSERT INTO @M_Words(wnumber, wwords) values ('5', 'Five')
	INSERT INTO @M_Words(wnumber, wwords) values ('6', 'Six')
	INSERT INTO @M_Words(wnumber, wwords) values ('7', 'Seven')
	INSERT INTO @M_Words(wnumber, wwords) values ('8', 'Eight')
	INSERT INTO @M_Words(wnumber, wwords) values ('9', 'Nine')
	INSERT INTO @M_Words(wnumber, wwords) values ('10', 'Ten')
	INSERT INTO @M_Words(wnumber, wwords) values ('11', 'Eleven')
	INSERT INTO @M_Words(wnumber, wwords) values ('12', 'Twelve')
	INSERT INTO @M_Words(wnumber, wwords) values ('13', 'Thirteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('14', 'Fourteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('15', 'Fifteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('16', 'Sixteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('17', 'Seventeen')
	INSERT INTO @M_Words(wnumber, wwords) values ('18', 'Eighteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('19', 'Nineteen')
	INSERT INTO @M_Words(wnumber, wwords) values ('20', 'Twenty')
	INSERT INTO @M_Words(wnumber, wwords) values ('30', 'Thirty')
	INSERT INTO @M_Words(wnumber, wwords) values ('40', 'Forty')
	INSERT INTO @M_Words(wnumber, wwords) values ('50', 'Fifty')
	INSERT INTO @M_Words(wnumber, wwords) values ('60', 'Sixty')
	INSERT INTO @M_Words(wnumber, wwords) values ('70', 'Seventy')
	INSERT INTO @M_Words(wnumber, wwords) values ('80', 'Eighty')
	INSERT INTO @M_Words(wnumber, wwords) values ('90', 'Ninety')

	
	Declare @StrNumber varchar(10), @SLacs char(2), @SThou char(2), @SHun char(2)
	Declare @STenUnt char(2), @STen char(2), @SUnt char(2), @SDecimal char(2)
	Declare @ILacs Int, @IThou Int, @IHun Int, @ITenUnt Int, @ITen Int, @IUnt Int, @IDecimal Int
	Declare @SNumToWords varchar(100), @Wwords varchar(10)

	Select @StrNumber = Replicate('0',10-Len(LTrim(RTrim(convert(varchar,@Number))))) + LTrim(RTrim(Convert(varchar,@Number)))
	--Print @StrNumber
	--Print Len(@StrNumber)
	Select @SNumToWords = ''

	--Print Len(LTrim(RTrim(convert(varchar,@Number))))
	If Len(LTrim(RTrim(convert(varchar,@Number)))) > 4
	Begin
		--Print Len(@StrNumber)
		Select @SLacs = Substring(@StrNumber,1,2)
		--Print @SLacs
		Select @ILacs = Convert(int,@SLacs)
		If @ILacs > 0
		Begin
			Select @STen = Substring(@StrNumber,1,1)
			Select @SUnt = Substring(@StrNumber,2,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,1,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End

			If @ITen > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Tens'
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Unit'
			End

			--Select @Wwords = ''
			--Select @Wwords = Wwords From @M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + ' Lacs'
		End

		Select @SThou = Substring(@StrNumber,3,2)
		--Print @SThou
		Select @IThou = Convert(int,@SThou)
		If @IThou > 0
		Begin
			Select @STen = Substring(@StrNumber,3,1)
			Select @SUnt = Substring(@StrNumber,4,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,3,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End
			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Tens'
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Unit'
			End

			--Select @Wwords = ''
			--Select @Wwords = Wwords From @M_Words Where WNumber = @IThou
			--Print @Wwords
			--Select @SNumToWords = @SNumToWords + @Wwords + ' Thousand '
			Select @SNumToWords = @SNumToWords + ' Thousand '
		End

		Select @SHun = Substring(@StrNumber,5,1)
		--Print @SHun
		Select @IHun = Convert(int,@SHun)
		If @IHun > 0
		Begin
			Select @Wwords = ''
			Select @Wwords = Wwords From @M_Words Where WNumber = @IHun
			--Print @Wwords
			Select @SNumToWords = @SNumToWords + @Wwords + ' Hundred'
		End

		Select @STenUnt = Substring(@StrNumber,6,2)
		---Print @STenUnt

		Select @ITenUnt = Convert(int,@STenUnt)

		If @ITenUnt > 0
		Begin
			Select @STen = Substring(@StrNumber,6,1)
			Select @SUnt = Substring(@StrNumber,7,1)

			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,6,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End

			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Tens'
			End

			If @IUnt > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Unit'
			End
		End

		Select @SNumToWords = 'Rupees ' + @SNumToWords  --Only/-



	End
	Else
	Begin
		--Print Len(@StrNumber)
		--Print LTrim(RTrim(convert(varchar,@Number)))
		Select @SLacs = Substring(LTrim(RTrim(convert(varchar,@Number))),1,1)
		--Print @SLacs
		Select @ILacs = Convert(int,@SLacs)
		If @ILacs > 0 and @ILacs <> 1
		Begin
			Select @Wwords = ''
			Select @Wwords = Wwords From @M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = 'Rupees ' + @SNumToWords + Space(1) + @Wwords
		End
		Else
		Begin
			Select @Wwords = ''
			Select @Wwords = Wwords From @M_Words Where WNumber = @ILacs
			--Print @Wwords
			Select @SNumToWords = 'Rupees ' + @SNumToWords + @Wwords
		End
	End

	If @CPaise = 'Y'
	Begin
		Select @SDecimal = Substring(@StrNumber,9,2)
		Select @IDecimal = Convert(int,@SDecimal)
		If @IDecimal > 0
		Begin
			Select @SNumToWords = @SNumToWords + ' and Paise '
			Select @STen = Substring(@SDecimal,1,1)
			Select @SUnt = Substring(@SDecimal,2,1)
	
			if Convert(int,@STen) = 1 
			Begin
				Select @ITen = Convert(int,Substring(@StrNumber,9,2))
				Select @IUnt = 0
			End
			Else
			Begin
				Select @ITen = Convert(int,@STen)*10
				Select @IUnt = Convert(int,@SUnt)
			End
			
			If @ITen > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @ITen
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Tens'
			End
	
			If @IUnt > 0 
			Begin			
				Select @Wwords = ''
				Select @Wwords = Wwords From @M_Words Where WNumber = @IUnt
				--Print @Wwords
				Select @SNumToWords = @SNumToWords + Space(1) + @Wwords --' Unit'
			End
	
			Select @SNumToWords = @SNumToWords
	
		End
	End

	--Print LTrim(RTrim(@SNumToWords))
	Return LTrim(RTrim(@SNumToWords))

End

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLASS_INIT
-- --------------------------------------------------
ALTER TABLE [dbo].[CLASS_INIT] ADD CONSTRAINT [PK__CLASS_INIT__09DE7BCC] PRIMARY KEY ([EXCHANGE], [SEGMENT], [TABLENAME])

GO

-- --------------------------------------------------
-- TABLE dbo.CLASS_INIT
-- --------------------------------------------------
CREATE TABLE [dbo].[CLASS_INIT]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(25) NOT NULL,
    [SEGMENT] VARCHAR(25) NOT NULL,
    [TABLENAME] VARCHAR(50) NOT NULL,
    [DBTYPE] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLASS_SYS_DBS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLASS_SYS_DBS]
(
    [SRNO] INT NOT NULL,
    [DBNAME] VARCHAR(50) NULL,
    [ISDEFAULT] VARCHAR(1) NULL,
    [ISSUSPENDED] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLASS_SYS_LOGINS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLASS_SYS_LOGINS]
(
    [LOGINNAME] VARCHAR(200) NULL,
    [SCHEMANAME] VARCHAR(200) NULL,
    [OWNLOGIN] VARCHAR(1) NULL,
    [ISDISABLED] VARCHAR(1) NULL,
    [MAPPED_DBS] VARCHAR(MAX) NULL,
    [BASE_SCHEMA] VARCHAR(1) NULL,
    [srno] INT IDENTITY(0,1) NOT NULL,
    [SQL_CODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLASS_USERS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLASS_USERS]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [FLDUSERNAME] VARCHAR(25) NULL,
    [MEMBERCODE] VARCHAR(15) NULL,
    [SQL_USER] VARCHAR(50) NULL,
    [SQL_CODE] VARCHAR(512) NULL,
    [SQL_SCHEMA] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fragmentaion_after_reorg
-- --------------------------------------------------
CREATE TABLE [dbo].[Fragmentaion_after_reorg]
(
    [Schema] NVARCHAR(128) NOT NULL,
    [Table] NVARCHAR(128) NOT NULL,
    [Index] NVARCHAR(128) NULL,
    [avg_fragmentation_in_percent] FLOAT NULL,
    [page_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fragmentaion_before_reorg
-- --------------------------------------------------
CREATE TABLE [dbo].[Fragmentaion_before_reorg]
(
    [Schema] NVARCHAR(128) NOT NULL,
    [Table] NVARCHAR(128) NOT NULL,
    [Index] NVARCHAR(128) NULL,
    [avg_fragmentation_in_percent] FLOAT NULL,
    [page_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Fragmentaion_details
-- --------------------------------------------------
create view Fragmentaion_details
as 

SELECT S.name as 'Schema',
T.name as 'Table',
I.name as 'Index',
DDIPS.avg_fragmentation_in_percent,
DDIPS.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 0

GO

