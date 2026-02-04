-- DDL Export
-- Server: 10.253.33.233
-- Database: PRADNYA
-- Exported: 2026-02-05T02:38:00.988448

USE PRADNYA;
GO

-- --------------------------------------------------
-- FUNCTION dbo.CHECKZIPFILE
-- --------------------------------------------------

CREATE FUNCTION [dbo].[CHECKZIPFILE]
(
	@FILENAME	VARCHAR(200)
) RETURNS INT
AS
BEGIN
	DECLARE @STATUS	INT
	SET @STATUS = 0 
	
	SET @STATUS = (CASE WHEN @FILENAME LIKE '%.ZIP' THEN 1 ELSE 0 END)

	IF @STATUS = 0
	BEGIN
		SET @STATUS = (CASE WHEN @FILENAME LIKE '%.GZ' THEN 1 ELSE 0 END)
	END
	RETURN @STATUS
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_CLASS_Auto_Process_Replace
-- --------------------------------------------------
CREATE FUNCTION [dbo].[fn_CLASS_Auto_Process_Replace]  
(  
 @PARAMETER  VARCHAR(500),   
 @BUSINESS_DATE DATETIME,   
 @MEMBERCODE  VARCHAR(10),  
 @SETT_NO  VARCHAR(7),  
 @SETT_TYPE  VARCHAR(2)  
) RETURNS VARCHAR(500)  
AS  
BEGIN  
-- SELECT .DBO.fn_CLASS_Auto_Process_Replace('<BUSINESS_DATE>','jul 10 2017', '', '', '')
DECLARE @NEWSETT_NO VARCHAR(10)  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEFOLDER>', CONVERT(VARCHAR,@BUSINESS_DATE,112))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEYYYYMMDD>', CONVERT(VARCHAR,@BUSINESS_DATE,112))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE106NS>', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMM>', LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/',''),4))  
  
   
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEMMYY>', RIGHT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,3),'/',''),4))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE103>', CONVERT(VARCHAR,@BUSINESS_DATE,103))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE103->', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/','-'))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<MON-YEAR>', LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),3) + '-' + RIGHT(LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11),4))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/',''))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMMYY>', LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,3),'/',''),6))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<MEMBERCODE>', @MEMBERCODE)  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE109>', '''' + LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11) + '''')  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<CURDATE109>', '''' + LEFT(CONVERT(VARCHAR,GETDATE(),109),11) + '''')  

 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE109,>', '''' + LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11) + ''',')   
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE106MMM_YYYY>', '' + REPLACE(RIGHT(LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,106),11),8),' ', '_') + '')  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<SetNo>',@SETT_NO)  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<SetNo3>',RIGHT(@SETT_NO,3))  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<SettType>',@SETT_TYPE)  
  
 IF @SETT_TYPE = 'D'   
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<SettTypeDR>','DR')  
 END  
  
 IF @SETT_TYPE = 'C'   
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<SettTypeDR>','C')  
 END  
  
 IF @SETT_TYPE = 'C'   
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<SettTypePC>','PC')  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYINSHRT>','DELSHTC')  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYOUTSHRT>','RECSHTC')  
 END  
  
 IF @SETT_TYPE = 'D'   
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<SettTypePC>','P')  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYINSHRT>','AUCCONR')  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYOUTSHRT>','RECSHTR')  
 END  
  
 IF @SETT_TYPE = 'N' OR @SETT_TYPE = 'L' OR @SETT_TYPE = 'I'  
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYOUTSHRT>','SHRT_' + RTRIM(LTRIM(@SETT_TYPE)))  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYINSHRT>','SHRT_' + RTRIM(LTRIM(@SETT_TYPE)))  
 END  
 IF @SETT_TYPE = 'W'  OR @SETT_TYPE = 'A'  
 BEGIN  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYOUTSHRT>','ASQR_A')  
  SET @PARAMETER = REPLACE(@PARAMETER,'<PAYINSHRT>','ASQR_A')  
  IF @PARAMETER LIKE '%ASQR%'  
  BEGIN  
   SELECT @NEWSETT_NO = MAX(SETT_NO) FROM MSAJAG.DBO.SETT_MST  
   WHERE SETT_NO < @SETT_NO AND SETT_TYPE = @SETT_TYPE  
  
   SET @PARAMETER = REPLACE(@PARAMETER, @SETT_NO, @NEWSETT_NO)  
  END  
 END  
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<BUSINESS_DATE>',LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11))  
 SET @PARAMETER = REPLACE(@PARAMETER,'<PROCESS_DATE>',LEFT(CONVERT(VARCHAR,GETDATE(),109),11))  
  
 RETURN @PARAMETER  
END

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
-- FUNCTION dbo.FN_EXCHANGE_SEGMENTS
-- --------------------------------------------------
CREATE FUNCTION FN_EXCHANGE_SEGMENTS ()  
RETURNS @EXCHANGE_SEGMENTS TABLE  
(  
 EXCHANGE_SEGMENTS VARCHAR(12),  
 EXCHANGE VARCHAR(3),  
 SEGMENT VARCHAR(7)  
) AS  
BEGIN  
 INSERT @EXCHANGE_SEGMENTS VALUES ('NCDX','NCX','FUTURES')  
 INSERT @EXCHANGE_SEGMENTS VALUES ('MCDX','MCX','FUTURES')  
  
 RETURN  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.fnMax
-- --------------------------------------------------

create function [dbo].[fnMax](@Value1 money, @Value2 Money ) 
Returns Money As
Begin
	Declare @Return Money
	if @Value1  > @Value2
		Begin
			Set @Return =  @Value1 
		End
	else
		Begin
			Set @Return =  @Value2
		End
	Return @Return

End

GO

-- --------------------------------------------------
-- FUNCTION dbo.fnMin
-- --------------------------------------------------

create function [dbo].[fnMin](@Value1 money, @Value2 Money ) 
Returns Money As
Begin
	Declare @Return Money
	if @Value1  < @Value2
		Begin
			Set @Return =  @Value1 
		End
	else
		Begin
			Set @Return =  @Value2
		End
	Return @Return

End

GO

-- --------------------------------------------------
-- FUNCTION dbo.fnSplitString2Tbl
-- --------------------------------------------------
  
  
CREATE FUNCTION [dbo].[fnSplitString2Tbl] (  
      @InputString                  VARCHAR(8000),  
      @Delimiter                    VARCHAR(50)  
)  
  
RETURNS @Items TABLE (  
      Item                          VARCHAR(8000)  
)  
  
AS  
BEGIN  
      IF @Delimiter = ' '  
      BEGIN  
            SET @Delimiter = ','  
            SET @InputString = REPLACE(@InputString, ' ', @Delimiter)  
      END  
  
      IF (@Delimiter IS NULL OR @Delimiter = '')  
            SET @Delimiter = ','  
  
      DECLARE @Item                 VARCHAR(8000)  
      DECLARE @ItemList       VARCHAR(8000)  
      DECLARE @DelimIndex     INT  
  
      SET @ItemList = @InputString  
      SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)  
      WHILE (@DelimIndex != 0)  
      BEGIN  
            SET @Item = SUBSTRING(@ItemList, 0, @DelimIndex)  
            INSERT INTO @Items VALUES (@Item)  
  
            -- Set @ItemList = @ItemList minus one less item  
            SET @ItemList = SUBSTRING(@ItemList, @DelimIndex+1, LEN(@ItemList)-@DelimIndex)  
            SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)  
      END -- End WHILE  
  
      IF @Item IS NOT NULL -- At least one delimiter was encountered in @InputString  
      BEGIN  
            SET @Item = @ItemList  
            INSERT INTO @Items VALUES (@Item)  
      END  
  
      -- No delimiters were encountered in @InputString, so just return @InputString  
      ELSE INSERT INTO @Items VALUES (@InputString)  
  
      RETURN  
  
END -- End Function

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_PRINTF
-- --------------------------------------------------
CREATE FUNCTION FUN_PRINTF(      
                @PRINTF   VARCHAR(6))      
RETURNS @PRINTF_TAB TABLE (      
    [PRINTF] [TINYINT] NOT NULL)      
      
AS      
      
/* FUNCTION TO GET VALID PRINTF FLAGS FOR THE PURPOSES OF FILTERING IN CONTRACT PRINTING */      
BEGIN         
  IF @PRINTF = 'ALL'      
    BEGIN      
      INSERT INTO @PRINTF_TAB VALUES (0)      
      INSERT INTO @PRINTF_TAB VALUES (2)      
      INSERT INTO @PRINTF_TAB VALUES (3)      
      INSERT INTO @PRINTF_TAB VALUES (4)      
      INSERT INTO @PRINTF_TAB VALUES (5)      
    END      
  ELSE      
    IF @PRINTF = 'ECN'      
    BEGIN      
      INSERT INTO @PRINTF_TAB VALUES (2)      
    END      
  ELSE      
    IF @PRINTF = 'NONECN'      
    BEGIN      
      INSERT INTO @PRINTF_TAB VALUES (0)      
      INSERT INTO @PRINTF_TAB VALUES (3)      
      INSERT INTO @PRINTF_TAB VALUES (4)      
      INSERT INTO @PRINTF_TAB VALUES (5)      
    END      
      
  RETURN       
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING
-- --------------------------------------------------
CREATE FUNCTION FUN_SPLITSTRING(  
                @SPLITSTRING VARCHAR(1000),  
                @DELIMITER   VARCHAR(3))  
RETURNS @SPLITTED TABLE (  
    [SNO] [INT] IDENTITY(1,1) NOT NULL,   
    [SPLITTED_VALUE] [VARCHAR](100) NOT NULL)  
  
AS  
  
/* Split the String and get splitted values in the result-set. Delimiter upto 3 characters long can be used for splitting */  
BEGIN     
  DECLARE  @STRING         VARCHAR(1000),  
           @POSITION       INT,  
           @START_LOCATION INT,  
           @STRING_LENGTH  INT  
                             
  SET @STRING = @SPLITSTRING  
                  
  SET @POSITION = 0  
                    
  SET @START_LOCATION = 0  
                          
  SET @STRING_LENGTH = LEN(@STRING)  
                         
  WHILE @STRING_LENGTH > 0  
    BEGIN  
      
      SET @POSITION = CHARINDEX(@DELIMITER,@STRING,@START_LOCATION)  
                        
      IF @POSITION = 0  
        BEGIN  
          INSERT INTO @SPLITTED  
          SELECT @STRING  
                   
          SET @STRING_LENGTH = 0  
                                 
        END  
      ELSE  
        BEGIN  
          INSERT INTO @SPLITTED  
          SELECT LEFT(@STRING,@POSITION - 1)  
                   
          SET @STRING = RIGHT(@STRING,@STRING_LENGTH - @POSITION)  
                          
          SET @STRING_LENGTH = LEN(@STRING)  
        END  
          
    END  
  
  RETURN   
  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING_2NUM
-- --------------------------------------------------


   CREATE FUNCTION [dbo].[FUN_SPLITSTRING_2NUM](  
                @SPLITSTRING VARCHAR(8000),  
                @DELIMITER   VARCHAR(3))  
RETURNS  INT  
AS  
  
BEGIN     
  
  DECLARE @INTRETURN INT  
  DECLARE  @STRING         VARCHAR(8000),  
           @POSITION       INT,  
           @START_LOCATION INT,  
           @STRING_LENGTH  INT  
                             
  SET @STRING = @SPLITSTRING  
                  
  SET @POSITION = 0  
                    
  SET @START_LOCATION = 0  
  SET @INTRETURN = 0                      
  SET @STRING_LENGTH = LEN(@STRING)  
                         
  WHILE @STRING_LENGTH > 0  
    BEGIN  
      
      SET @POSITION = CHARINDEX(@DELIMITER,@STRING,@START_LOCATION)  
                        
      IF @POSITION = 0  
        BEGIN  
          SET @INTRETURN = @INTRETURN +  CONVERT(INT,@STRING )                  
          SET @STRING_LENGTH = 0  
                                 
        END  
      ELSE  
        BEGIN  
          SET @INTRETURN = @INTRETURN + CONVERT(INT,LEFT(@STRING,@POSITION - 1))                 
          SET @STRING = RIGHT(@STRING,@STRING_LENGTH - @POSITION)  
                          
          SET @STRING_LENGTH = LEN(@STRING)  
        END  
          
    END  
  
  
   RETURN  @INTRETURN  
          
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.IndianCurrencyInWords
-- --------------------------------------------------



create FUNCTION [dbo].[IndianCurrencyInWords]
(
	@Currency decimal(11,2)
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @tCurr varchar(12)
		,@RetVal varchar(255)

	SELECT @tCurr = CAST(@Currency AS varchar(12))
		,@RetVal = ''
	
	;WITH IndianCurrency (pos, ln, ord, sng, plr)
	AS
	(
		SELECT 1, 2, 5, 'Paisa', 'Paise'
		UNION ALL SELECT 4, 3, 4, 'Rupee', 'Rupees'
		UNION ALL SELECT 7, 2, 3, 'Thousand', 'Thousand'
		UNION ALL SELECT 9, 2, 2, 'Lakh', 'Lakhs'
		UNION ALL SELECT 11, 2, 1, 'Crore', 'Crores'
	), Split (Number, ord, sng, plr)
	AS
	(
		SELECT REVERSE(SUBSTRING(REVERSE(@tCurr), pos, ln))
			,ord, sng, plr
		FROM IndianCurrency
	), OrdWord (ord, Word)
	AS
	(
		SELECT ord
			,CASE
				--WHEN @Currency >= 1 AND ord = 5 THEN 'and '
				--WHEN W.Number < 100 AND ord = 4 THEN 'and '
				WHEN @Currency >= 1 AND ord = 5 THEN ''
				WHEN W.Number < 100 AND ord = 4 THEN ''
				ELSE ''
			END
			+ CASE WHEN @Currency >= 1 AND ord = 4 AND W.NumberWord IS NULL THEN 'Rupees' ELSE '' END
			+ COALESCE(W.NumberWord + ' ' + CASE WHEN W.Number = 1 and @Currency < 2 THEN S.sng ELSE S.plr END, '')
		FROM Split S
			LEFT JOIN NumberWords W
				ON S.Number = W.Number
		WHERE LEN(S.Number) > 0
	)
	SELECT @RetVal = @RetVal + COALESCE(' ' + Word, '')
	FROM OrdWord B
	WHERE LEN(Word) > 0
	ORDER BY ord

	RETURN @RetVal
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.PIECE
-- --------------------------------------------------





CREATE FUNCTION [dbo].[PIECE] ( @CHARACTEREXPRESSION VARCHAR(8000), @DELIMITER CHAR(1), @POSITION INTEGER)
RETURNS VARCHAR(8000)
AS
BEGIN
	IF @POSITION<1 RETURN NULL
	IF LEN(@DELIMITER)<>1 RETURN NULL
	DECLARE @START INTEGER
	SET @START=1
	WHILE @POSITION>1
		BEGIN
			SET @START=ISNULL(CHARINDEX(@DELIMITER, @CHARACTEREXPRESSION, @START),0)
			IF @START=0 RETURN NULL
			SET @POSITION= @POSITION-1
			SET @START=@START+1
		END
	DECLARE @END INTEGER
	SET @END= ISNULL(CHARINDEX(@DELIMITER, @CHARACTEREXPRESSION, @START),0)
	IF @END=0 SET @END=LEN(@CHARACTEREXPRESSION)+1
	RETURN SUBSTRING(@CHARACTEREXPRESSION, @START, @END-@START)
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.ReplaceTradeNo
-- --------------------------------------------------


CREATE   Function [dbo].[ReplaceTradeNo](@TradeNo  Varchar(16)) 
Returns Varchar(16) As
Begin
	Select @TradeNo = (Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(@TradeNo,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U','') )   

Return @TradeNo 
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RoundedToThousand
-- --------------------------------------------------


create Function [dbo].[RoundedToThousand](@Amt Numeric(18,4))
Returns Numeric(18,4)
As
Begin  
if @Amt > 0  
	select @Amt = ((convert(numeric(18,2),@Amt/10000) - Right(convert(numeric(18,2),@Amt/10000),3))+1)*10000
Else 
	select @Amt = @Amt

Return @Amt 

End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RoundedTurnover
-- --------------------------------------------------


create function [dbo].[RoundedTurnover](@Amt Numeric(18,4), @roundingAmt Numeric(18,4))
Returns Numeric(18,4)
As
Begin  
if @Amt > 0  
	Select @Amt = (Case When @Amt - Convert(BigInt,@Amt/@roundingAmt)*@roundingAmt = 0 Then @Amt Else (Convert(BigInt,@Amt/@roundingAmt)+1)*@roundingAmt End)
Else 
	select @Amt = @Amt

Return @Amt 

End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RoundedTurnover_NEW
-- --------------------------------------------------



CREATE Function [dbo].[RoundedTurnover_NEW](@Amt Numeric(18,4), @roundingAmt Numeric(18,4), @ROUNDFLAG VARCHAR(1) = 'N')  
Returns Numeric(18,4)  
As  
Begin  

IF @ROUNDFLAG = 'Y' 
	BEGIN

	 if @Amt > 0 AND @roundingAmt > 0   
	  Select @Amt = (Case When @Amt - Convert(BigInt,@Amt/@roundingAmt)*@roundingAmt = 0   
						  Then @Amt   
			Else (Convert(BigInt,@Amt/@roundingAmt)+1)*@roundingAmt   
			  End)  
	 Else   
	  select @Amt = @Amt  
	END 
	Return @Amt  
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.Split
-- --------------------------------------------------
CREATE FUNCTION [dbo].[Split]  
(  
 @RowData nvarchar(2000),  
 @SplitOn nvarchar(5)  
)    
RETURNS @RtnValue table   
(  
 Id int identity(1,1),  
 ITEMS nvarchar(100)  
)   
AS    
BEGIN   
 Declare @Cnt int  
 Set @Cnt = 1  
  
 While (Charindex(@SplitOn,@RowData)>0)  
 Begin  
  Insert Into @RtnValue (ITEMS)  
  Select   
   Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))  
  
  Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))  
  Set @Cnt = @Cnt + 1  
 End  
   
 Insert Into @RtnValue (ITEMS)  
 Select ITEMS = ltrim(rtrim(@RowData))  
  
 Return  
END

GO

-- --------------------------------------------------
-- INDEX dbo.History_Fosettlement_Mcdx
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PARTY] ON [dbo].[History_Fosettlement_Mcdx] ([Party_Code], [Sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.HISTORY_FOSETTLEMENT_MCDXCDS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_PARTY] ON [dbo].[HISTORY_FOSETTLEMENT_MCDXCDS] ([SAUDA_DATE], [PARTY_CODE], [EXPIRYDATE], [SETT_NO], [SYMBOL])

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.HISTORY_FOCLOSING_BILLREPORT_MCDXCDS
-- --------------------------------------------------
ALTER TABLE [dbo].[HISTORY_FOCLOSING_BILLREPORT_MCDXCDS] ADD CONSTRAINT [PK_foclosing_billreport] PRIMARY KEY ([Expirydate], [Trade_date], [Symbol])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.HISTORY_FOCLOSING_MCDXCDS
-- --------------------------------------------------
ALTER TABLE [dbo].[HISTORY_FOCLOSING_MCDXCDS] ADD CONSTRAINT [PK_foclosing] PRIMARY KEY ([Expirydate], [Trade_date], [Symbol])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.NumberWords
-- --------------------------------------------------
ALTER TABLE [dbo].[NumberWords] ADD CONSTRAINT [PK__NumberWo__78A1A19C51EF2864] PRIMARY KEY ([Number])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__4CA06362] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_QLcomm_bounced
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_QLcomm_bounced] ADD CONSTRAINT [PK_Tbl_QLcomm_bounced] PRIMARY KEY ([EXCHANGE], [PARTY_CODE], [SAUDA_DATE])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_CMPADDR
-- --------------------------------------------------


CREATE PROC [dbo].[CLS_CMPADDR]
(
	@EXCHANGE VARCHAR(3),
	@SEGMENT VARCHAR(20)
)
AS
/*

CLS_CMPADDR 'BSE','CAPITAL'

SELECT * FROM MSAJAG.DBO.OWNER
SELECT * FROM NSEMFSS.DBO.OWNER
SELECT * FROM BBO_FA.DBO.OWNER
EXEC USP_CMPADDR 'NSEMFSS'

*/
/*BEGIN
	DECLARE @SQL VARCHAR(MAX), @SEGMENT VARCHAR(10)
	SELECT @SEGMENT = SEGMENT FROM PRADNYA.DBO.MULTICOMPANY WHERE SHAREDB = @SHAREDB AND PRIMARYSERVER = 1
	SET @SQL="SELECT COMPANY, ADDR1, ADDR2, ADDR3" + CASE WHEN @SEGMENT = 'FUTURES' THEN '=''''' ELSE '' END + ", CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX,EMAIL,MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE FROM "
	SET @SQL=@SQL+@SHAREDB
	SET @SQL=@SQL+".." + CASE WHEN @SEGMENT = 'FUTURES' THEN 'FOOWNER' ELSE 'OWNER' END
	PRINT @SQL
	EXEC(@SQL)
END*/
SELECT * FROM CLS_OWNER_VW WHERE EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT

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
-- PROCEDURE dbo.SP
-- --------------------------------------------------

CREATE PROC SP @SPNAME VARCHAR(25)AS                   
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @SPNAME + '%' AND XTYPE='P' ORDER BY NAME

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
-- PROCEDURE dbo.V2_CHECKBLOCKEDREPORTS
-- --------------------------------------------------

CREATE PROCEDURE V2_CHECKBLOCKEDREPORTS
                @RPTPATH VARCHAR(100)
                
AS

  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  SET NOCOUNT ON
        
  IF (SELECT COUNT(1)
      FROM   TBLREPORTS_BLOCKED WITH (NOLOCK)
      WHERE  BLOCK_FLAG = 1
             AND LTRIM(RTRIM(FLDPATH)) = left(LTRIM(RTRIM(@RPTPATH)),len(FLDPATH))) > 0 
  BEGIN 
    SELECT '<font color = red><b>UPDATION IN PROGRESS!!</b></font>'
  END 
  ELSE 
  BEGIN 
    SELECT '' 
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_CLASS_CHECKPATH
-- --------------------------------------------------
 CREATE PROC V2_CLASS_CHECKPATH  
(  
 @REPPATH VARCHAR(8000),  
 @CATEGORY INT  
)  
AS  
  
  
SELECT  
 POSCOUNT = ISNULL(SUM(ISNULL(CHARINDEX(X.FILEPATH,@REPPATH, 0),0)),0)  
FROM  
(  
 SELECT FILEPATH, FLDCATEGORY FROM PRADNYA.DBO.TBL_CLASS_EXCEPTION_FOLDERS (NOLOCK)  
 WHERE ISNULL(FLDCATEGORY,'') <> ''  
 UNION  
 SELECT FILEPATH, FLDCATEGORY = ','+CAST(@CATEGORY AS VARCHAR)+',' FROM PRADNYA.DBO.TBL_CLASS_EXCEPTION_FOLDERS (NOLOCK)  
 WHERE ISNULL(FLDCATEGORY,'') = ''   
) X  
WHERE   
 CHARINDEX(','+cast(@CATEGORY as VARCHAR)+',',X.FLDCATEGORY,0) > 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_MONTHLYLEDGER
-- --------------------------------------------------
CREATE PROC [dbo].[V2_PROC_MONTHLYLEDGER]                      
(                      
 @STARTDT VARCHAR(11),                      
 @ENDDT VARCHAR(11),                      
 @FROMPARTY VARCHAR(10),                      
 @TOPARTY VARCHAR(10)                      
)                      
                      
/*  **************  Process for Monthly Ledger   ***************           
New sp for Commodity sent by Sinu on 07-jul-2011             
EXEC V2_PROC_MONTHLYLEDGER 'MAR  1 2008' , 'MAR 31 2011', '0000000000', 'ZZZZZZZZZZ'                      
EXEC V2_PROC_MONTHLYLEDGER 'JUN  1 2008' , 'AUG 31 2008', '0080', '0080'                      
*/                      
                      
AS                      
                      
SET NOCOUNT ON                      
                      
/*                      
CREATE TABLE V2_CLASS_MONTHLYLEDGER                      
(                      
 CQL_ID BIGINT IDENTITY(1,1),                      
 CQL_SEGMENT VARCHAR(20),                      
 CQL_PARTYCODE VARCHAR(10),                      
 CQL_VDT VARCHAR(20),                      
 CQL_VTYPE VARCHAR(10),                      
 CQL_VNO VARCHAR(20),                      
 CQL_ACCODE VARCHAR(10),                      
 CQL_REMARKS VARCHAR(255),                      
 CQL_DDNO VARCHAR(20),                      
 CQL_DEBIT MONEY,                      
 CQL_CREDIT MONEY,                      
 CQL_BALANCE MONEY,                      
 CQL_ORDERBY TINYINT,                      
 CQL_DT INT,                       
 CQL_ACNAME VARCHAR(100)                      
)                      
*/                      
                      
TRUNCATE TABLE V2_CLASS_MONTHLYLEDGER                      
                      
DECLARE @@SDTCUR DATETIME                      
                      
                      
/* NOW DOING NSECM */                      
        
CREATE TABLE #ACMAST        
(CLTCODE VARCHAR(10))        
        
CREATE CLUSTERED INDEX IDXCL ON #ACMAST(CLTCODE)        
        
INSERT INTO #ACMAST        
SELECT CL_CODE FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS        
WHERE CL_CODE >= @FROMPARTY AND CL_CODE <= @TOPARTY AND Exchange in ('NCX','MCX')      
                      
                      
/*===========================================================================================================*/                      
--------------------------------------------------------------------------------------------------------------------            
-- NCDX            
            
SELECT                       
 @@SDTCUR = SDTCUR                       
FROM                       
 ACCOUNTNCDX.DBO.PARAMETER                     
WHERE                      
 @STARTDT BETWEEN SDTCUR AND LDTCUR                      
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO V2_CLASS_MONTHLYLEDGER                      
SELECT                       
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                      
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                      
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                      
 SUM(CQL_BALANCE),                      
 CQL_ORDERBY,                      
 19000101,                      
 CQL_ACNAME                      
FROM                       
 (                      
  SELECT                       
   CQL_SEGMENT = 'NCDX',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                      
   CQL_REMARKS = 'OPENING BALANCE',        
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 5,                      
   CQL_ACNAME = L.ACNAME                      
  FROM                      
   ACCOUNTNCDX.DBO.LEDGER L                        
  WHERE                      
   L.VDT >= @@SDTCUR                      
   AND L.VDT < @STARTDT                      
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)        
 ) X                      
GROUP BY                      
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                      
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_ORDERBY,                      
 CQL_ACNAME                      
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO V2_CLASS_MONTHLYLEDGER                      
SELECT                       
 CQL_SEGMENT = 'NCDX',                       
 CQL_PARTYCODE = L.CLTCODE,                      
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                      
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                      
 CQL_VNO = L.VNO,                      
 CQL_ACCODE = '',                      
 CQL_REMARKS = L.NARRATION,                      
 CQL_DDNO = '',                      
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
 CQL_ORDERBY = 6,                      
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                      
 CQL_ACNAME  = L.ACNAME                      
FROM                      
 ACCOUNTNCDX.DBO.LEDGER L                        
 INNER JOIN                       
 ACCOUNTNCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                      
WHERE                       
 L.VDT >=  @STARTDT                      
 AND L.VDT <= @ENDDT + ' 23:59:59'                      
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)        
                      
---------------------------------------------------------------------------------------------------------------            
-- MCDX            
            
SELECT                       
 @@SDTCUR = SDTCUR                       
FROM                       
 ACCOUNTMCDX.DBO.PARAMETER                     
WHERE                      
 @STARTDT BETWEEN SDTCUR AND LDTCUR                      
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO V2_CLASS_MONTHLYLEDGER                      
SELECT                       
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                     
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                      
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                      
 SUM(CQL_BALANCE),                      
 CQL_ORDERBY,                      
 19000101,                      
 CQL_ACNAME                      
FROM                       
 (                      
  SELECT                       
   CQL_SEGMENT = 'MCDX',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                     
   CQL_REMARKS = 'OPENING BALANCE',                      
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 5,                      
   CQL_ACNAME = L.ACNAME               
  FROM                      
   ACCOUNTMCDX.DBO.LEDGER L                        
  WHERE                       
   L.VDT >= @@SDTCUR                      
   AND L.VDT < @STARTDT                      
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)                   
 ) X                      
GROUP BY                      
 CQL_SEGMENT,                      
 CQL_PARTYCODE,           
 CQL_VDT,                      
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_ORDERBY,                      
 CQL_ACNAME            
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO V2_CLASS_MONTHLYLEDGER                      
SELECT                       
 CQL_SEGMENT = 'MCDX',                       
 CQL_PARTYCODE = L.CLTCODE,                      
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                      
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                      
 CQL_VNO = L.VNO,                      
 CQL_ACCODE = '',                      
 CQL_REMARKS = L.NARRATION,                      
 CQL_DDNO = '',                      
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
 CQL_ORDERBY = 6,                      
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                      
 CQL_ACNAME  = L.ACNAME                      
FROM                      
 ACCOUNTMCDX.DBO.LEDGER L                        
 INNER JOIN                       
 ACCOUNTMCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                      
WHERE                       
 L.VDT >=  @STARTDT                      
 AND L.VDT <= @ENDDT + ' 23:59:59'                      
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)        
                      
            
-------------------------------------------------------------------------------------------------------------------                                            
/*============================================================================================================*/                    
/*                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
SELECT                       
 Q.*,                      
 CQL_ADD1 = C.L_ADDRESS1,                      
 CQL_ADD2 = C.L_ADDRESS2,                      
 CQL_ADD3 = C.L_ADDRESS3,                      
 CQL_CITY = C.L_CITY,                      
 CQL_ZIP = C.L_ZIP,                      
 CQL_PHONE = C.RES_PHONE1,                      
 CQL_BRANCH = B.BRANCH+' ~ ('+C.BRANCH_CD+')',                      
 CQL_SUBBROKER = S.NAME + ' ~ (' + C.SUB_BROKER + ')',                      
 CQL_TRADER = T.LONG_NAME + ' ~ (' + C.TRADER + ')'                      
FROM                       
 V2_CLASS_MONTHLYLEDGER Q (NOLOCK)                      
 INNER JOIN                      
  MSAJAG.DBO.CLIENT_DETAILS C (NOLOCK)                      
  INNER JOIN MSAJAG.DBO.BRANCH B (NOLOCK) ON (C.BRANCH_CD = B.BRANCH_CODE)                      
  INNER JOIN MSAJAG.DBO.BRANCHES T (NOLOCK) ON (C.TRADER = T.SHORT_NAME)                      
  INNER JOIN MSAJAG.DBO.SUBBROKERS S (NOLOCK) ON (C.SUB_BROKER = S.SUB_BROKER)                      
 ON (Q.CQL_PARTYCODE = C.CL_CODE)                      
ORDER BY                       
 Q.CQL_PARTYCODE,             
 Q.CQL_ORDERBY,                      
 Q.CQL_DT                      
          
*/                                
                  
DELETE FROM V2_CLASS_MONTHLYLEDGER                  
WHERE CQL_DEBIT = 0                  
AND CQL_CREDIT = 0       
   
      
DELETE FROM V2_CLASS_MONTHLYLEDGER       
WHERE NOT EXISTS (SELECT  CQL_PARTYCODE FROM V2_CLASS_MONTHLYLEDGER B       
WHERE  B.CQL_PARTYCODE = V2_CLASS_MONTHLYLEDGER.CQL_PARTYCODE       
AND B.CQL_VTYPE ='BILL')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_MONTHLYLEDGER_POP
-- --------------------------------------------------


CREATE PROC V2_PROC_MONTHLYLEDGER_POP   

(            
	@FROMDATE   VARCHAR(11),
	@TODATE     VARCHAR(11),
	@FROMPARTY  VARCHAR(10),
	@TOPARTY    VARCHAR(10)
)

AS

--- EXEC V2_PROC_MONTHLYLEDGER_POP 'DEC  1 2012','DEC 31 2012','A0000','ZZZZZ'

EXEC PRADNYA.DBO.V2_PROC_MONTHLYLEDGER @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY

--- DATA FINAL FOR MONTHLY LEDGER GENERATION

SELECT PARTY_CODE,COUNT(TRADE_NO) AS TRD_CNT INTO #T 
FROM MCDX.DBO.FOSETTLEMENT WITH (NOLOCK)
WHERE SAUDA_DATE >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59' AND TRADEQTY <> 0
GROUP BY PARTY_CODE

----

INSERT INTO #T 
SELECT PARTY_CODE,COUNT(TRADE_NO) AS TRD_CNT 
FROM NCDX.DBO.FOSETTLEMENT WITH (NOLOCK)
WHERE SAUDA_DATE >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59' AND TRADEQTY <> 0
GROUP BY PARTY_CODE


----

SELECT PARTY_CODE,SUM(TRD_CNT) AS TRD_NO INTO #X FROM #T
GROUP BY PARTY_CODE HAVING SUM(TRD_CNT) < 3 

--

DELETE FROM V2_CLASS_MONTHLYLEDGER WHERE CQL_PARTYCODE IN 
(SELECT PARTY_CODE FROM #X)  

Select COUNT(1) from V2_CLASS_MONTHLYLEDGER -- 328844

DROP TABLE #T
DROP TABLE #X

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER
-- --------------------------------------------------
CREATE PROC [dbo].[V2_PROC_QUARTERLYLEDGER]                    
(                    
 @STARTDT VARCHAR(11),                    
 @ENDDT VARCHAR(11),                    
 @FROMPARTY VARCHAR(10),                    
 @TOPARTY VARCHAR(10)                    
)                    
                    
/*  **************  Process for Quarterly Ledger   ***************         
New sp for Commodity sent by Sinu on 07-jul-2011           
EXEC V2_PROC_QUARTERLYLEDGER 'MAR  1 2008' , 'MAR 31 2011', '0000000000', 'ZZZZZZZZZZ'                    
EXEC V2_PROC_QUARTERLYLEDGER 'JUN  1 2008' , 'AUG 31 2008', '0080', '0080'                    
*/                    
                    
AS                    
                    
SET NOCOUNT ON                    
                    
/*                    
CREATE TABLE V2_CLASS_QUARTERLYLEDGER                    
(                    
 CQL_ID BIGINT IDENTITY(1,1),                    
 CQL_SEGMENT VARCHAR(20),                    
 CQL_PARTYCODE VARCHAR(10),                    
 CQL_VDT VARCHAR(20),                    
 CQL_VTYPE VARCHAR(10),                    
 CQL_VNO VARCHAR(20),                    
 CQL_ACCODE VARCHAR(10),                    
 CQL_REMARKS VARCHAR(255),                    
 CQL_DDNO VARCHAR(20),                    
 CQL_DEBIT MONEY,                    
 CQL_CREDIT MONEY,                    
 CQL_BALANCE MONEY,                    
 CQL_ORDERBY TINYINT,                    
 CQL_DT INT,                     
 CQL_ACNAME VARCHAR(100)                    
)                    
*/                    
                    
TRUNCATE TABLE V2_CLASS_QUARTERLYLEDGER                    
                    
DECLARE @@SDTCUR DATETIME                    
                    
                    
/* NOW DOING NSECM */                    
      
CREATE TABLE #ACMAST      
(CLTCODE VARCHAR(10))      
      
CREATE CLUSTERED INDEX IDXCL ON #ACMAST(CLTCODE)      
      
INSERT INTO #ACMAST      
SELECT CL_CODE FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS      
WHERE CL_CODE >= @FROMPARTY AND CL_CODE <= @TOPARTY AND Exchange in ('NCX','MCX')    
                    
                    
/*===========================================================================================================*/                    
--------------------------------------------------------------------------------------------------------------------          
-- NCDX          
          
SELECT                     
 @@SDTCUR = SDTCUR                     
FROM                     
 ACCOUNTNCDX.DBO.PARAMETER                   
WHERE                    
 @STARTDT BETWEEN SDTCUR AND LDTCUR                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                    
 SUM(CQL_BALANCE),                    
 CQL_ORDERBY,                    
 19000101,                    
 CQL_ACNAME                    
FROM                     
 (                    
  SELECT                     
   CQL_SEGMENT = 'NCDX',                     
   CQL_PARTYCODE = L.CLTCODE,                    
   CQL_VDT = '',                    
   CQL_VTYPE = '',                    
   CQL_VNO = '',                    
   CQL_ACCODE = '',                    
   CQL_REMARKS = 'OPENING BALANCE',                    
   CQL_DDNO = '',                    
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
   CQL_ORDERBY = 5,                    
   CQL_ACNAME = L.ACNAME                    
  FROM                    
   ACCOUNTNCDX.DBO.LEDGER L                      
  WHERE                    
   L.VDT >= @@SDTCUR                    
   AND L.VDT < @STARTDT                    
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
 ) X                    
GROUP BY                    
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_ORDERBY,                    
 CQL_ACNAME                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT = 'NCDX',                     
 CQL_PARTYCODE = L.CLTCODE,                    
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                    
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                    
 CQL_VNO = L.VNO,                    
 CQL_ACCODE = '',                    
 CQL_REMARKS = L.NARRATION,                    
 CQL_DDNO = '',                    
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
 CQL_ORDERBY = 6,                    
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                    
 CQL_ACNAME  = L.ACNAME                    
FROM                    
 ACCOUNTNCDX.DBO.LEDGER L                      
 INNER JOIN                     
 ACCOUNTNCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                    
WHERE                     
 L.VDT >=  @STARTDT                    
 AND L.VDT <= @ENDDT + ' 23:59:59'                    
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
                    
---------------------------------------------------------------------------------------------------------------          
-- MCDX          
          
SELECT                     
 @@SDTCUR = SDTCUR                     
FROM                     
 ACCOUNTMCDX.DBO.PARAMETER                   
WHERE                    
 @STARTDT BETWEEN SDTCUR AND LDTCUR                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                   
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                    
 SUM(CQL_BALANCE),                    
 CQL_ORDERBY,                    
 19000101,                    
 CQL_ACNAME                    
FROM                     
 (                    
  SELECT                     
   CQL_SEGMENT = 'MCDX',                     
   CQL_PARTYCODE = L.CLTCODE,                    
   CQL_VDT = '',                    
   CQL_VTYPE = '',                    
   CQL_VNO = '',                    
   CQL_ACCODE = '',                    
   CQL_REMARKS = 'OPENING BALANCE',                    
   CQL_DDNO = '',                    
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
   CQL_ORDERBY = 5,                    
   CQL_ACNAME = L.ACNAME             
  FROM                    
   ACCOUNTMCDX.DBO.LEDGER L                      
  WHERE                     
   L.VDT >= @@SDTCUR                    
   AND L.VDT < @STARTDT                    
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)                 
 ) X                    
GROUP BY                    
 CQL_SEGMENT,                    
 CQL_PARTYCODE,         
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_ORDERBY,                    
 CQL_ACNAME          
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT = 'MCDX',                     
 CQL_PARTYCODE = L.CLTCODE,                    
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                    
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                    
 CQL_VNO = L.VNO,                    
 CQL_ACCODE = '',                    
 CQL_REMARKS = L.NARRATION,                    
 CQL_DDNO = '',                    
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
 CQL_ORDERBY = 6,                    
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                    
 CQL_ACNAME  = L.ACNAME                    
FROM                    
 ACCOUNTMCDX.DBO.LEDGER L                      
 INNER JOIN                     
 ACCOUNTMCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                    
WHERE                     
 L.VDT >=  @STARTDT                    
 AND L.VDT <= @ENDDT + ' 23:59:59'                    
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
                    
          
-------------------------------------------------------------------------------------------------------------------                                          
/*============================================================================================================*/                  
/*                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
SELECT                     
 Q.*,                    
 CQL_ADD1 = C.L_ADDRESS1,                    
 CQL_ADD2 = C.L_ADDRESS2,                    
 CQL_ADD3 = C.L_ADDRESS3,                    
 CQL_CITY = C.L_CITY,                    
 CQL_ZIP = C.L_ZIP,                    
 CQL_PHONE = C.RES_PHONE1,                    
 CQL_BRANCH = B.BRANCH+' ~ ('+C.BRANCH_CD+')',                    
 CQL_SUBBROKER = S.NAME + ' ~ (' + C.SUB_BROKER + ')',                    
 CQL_TRADER = T.LONG_NAME + ' ~ (' + C.TRADER + ')'                    
FROM                     
 V2_CLASS_QUARTERLYLEDGER Q (NOLOCK)                    
 INNER JOIN                    
  MSAJAG.DBO.CLIENT_DETAILS C (NOLOCK)                    
  INNER JOIN MSAJAG.DBO.BRANCH B (NOLOCK) ON (C.BRANCH_CD = B.BRANCH_CODE)                    
  INNER JOIN MSAJAG.DBO.BRANCHES T (NOLOCK) ON (C.TRADER = T.SHORT_NAME)                    
  INNER JOIN MSAJAG.DBO.SUBBROKERS S (NOLOCK) ON (C.SUB_BROKER = S.SUB_BROKER)                    
 ON (Q.CQL_PARTYCODE = C.CL_CODE)                    
ORDER BY                     
 Q.CQL_PARTYCODE,                    
 Q.CQL_ORDERBY,                    
 Q.CQL_DT                    
        
*/                              
                
DELETE FROM V2_CLASS_QUARTERLYLEDGER                
WHERE CQL_DEBIT = 0                
AND CQL_CREDIT = 0     

-- Comment by Dharmesh M on dated : 04/06/2012  
    
--DELETE FROM V2_CLASS_QUARTERLYLEDGER     
--WHERE NOT EXISTS (SELECT  CQL_PARTYCODE FROM V2_CLASS_QUARTERLYLEDGER B     
--WHERE  B.CQL_PARTYCODE = V2_CLASS_QUARTERLYLEDGER.CQL_PARTYCODE     
--AND B.CQL_VTYPE ='BILL')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_POP
-- --------------------------------------------------


    
CREATE  PROC [dbo].[V2_PROC_QUARTERLYLEDGER_POP]           
(                    
               @FROMDATE   VARCHAR(11),                    
               @TODATE     VARCHAR(11),                    
               @FROMPARTY  VARCHAR(10),                    
               @TOPARTY    VARCHAR(10),        
    @FROMSCRIP  VARCHAR(12),        
    @TOSCRIP    VARCHAR(12)                 
)             
AS          
        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER_POP 'jul 12 2016','oct  3 2016','A101024','A101024','00','zzzzz'        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER 'jul 12 2016','oct  3 2016','A101024','A101024'     
          
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY          
        
---        
        
DELETE FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER WHERE CQL_VTYPE LIKE 'OPEN%'        
   

--- FINAL DATA FOR QL FILES GENERATION        
        
SELECT DISTINCT PARTY_CODE INTO #PO         
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK) WHERE FLAG = 'Y' AND LEFT(FMC_DATE,11) = (        
SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         
---        
        
SELECT DISTINCT PARTY_CODE         
INTO #PARTY        
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK)        
WHERE 
/*INACTIVE_DATE >= @TODATE AND */ /*Commented By Neha Naiwar on 20 Feb 2019 as suggested By Siva Sir.*/
LEFT(FMC_DATE,11) = (SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         

--- BILLS     
        
SELECT DISTINCT CQL_PARTYCODE AS PARTY_CODE INTO #BILL        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE CQL_VTYPE = 'BILL'         
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )       
  
        
--- DR/CR --        
        
/* ###### CHANGE ON 23/12/2016 ##### */        
        
SELECT CQL_PARTYCODE,SUM(CQL_BALANCE) AS BAL INTO #DRCR        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )        
GROUP BY CQL_PARTYCODE        
-- HAVING SUM(CQL_BALANCE) < -1000 OR SUM(CQL_BALANCE) >1000        
ORDER BY CQL_PARTYCODE         
        
--              
      
SELECT *         
INTO #CL         
FROM        
 (        
 SELECT * FROM #PO         
 UNION        
 SELECT * FROM #BILL        
 UNION        
 SELECT CQL_PARTYCODE FROM #DRCR        
 ) X        
      
---         
    
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE         
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = CQL_PARTYCODE )     

 
       
 DROP TABLE #CL         
 DROP TABLE #PO         
 DROP TABLE #BILL        
 DROP TABLE #DRCR        
 DROP TABLE #PARTY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_POP_BAK_09012018
-- --------------------------------------------------

CREATE  PROC V2_PROC_QUARTERLYLEDGER_POP_BAK_09012017       
(                
               @FROMDATE   VARCHAR(11),                
               @TODATE     VARCHAR(11),                
               @FROMPARTY  VARCHAR(10),                
               @TOPARTY    VARCHAR(10),    
      @FROMSCRIP  VARCHAR(12),    
      @TOSCRIP    VARCHAR(12)             
)         
AS      
    
---- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER_POP 'jul 12 2016','oct  3 2016','A101024','A101024','00','zzzzz'    
--EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER 'jul 12 2016','oct  3 2016','A101024','A101024' 
      
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY      
    
---    
    
DELETE FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER WHERE CQL_VTYPE LIKE 'OPEN%'    
    
--- FINAL DATA FOR QL FILES GENERATION    
    
SELECT DISTINCT PARTY_CODE INTO #PO     
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK) WHERE FLAG = 'Y' AND LEFT(FMC_DATE,11) = (    
SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )     
     
    
---    
    
SELECT DISTINCT PARTY_CODE     
INTO #PARTY    
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK)    
WHERE INACTIVE_DATE >= @TODATE AND LEFT(FMC_DATE,11) = (SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )     
     
--- BILLS     
    
SELECT DISTINCT CQL_PARTYCODE AS PARTY_CODE INTO #BILL    
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)     
WHERE CQL_VTYPE = 'BILL'     
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )    
    
--- RS 1000.00 DR/CR --    
    
/* ###### CHANGE ON 23/12/2016 ##### */    
    
--SELECT CQL_PARTYCODE,SUM(CQL_BALANCE) AS BAL INTO #DRCR    
--FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)     
--WHERE EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )    
--GROUP BY CQL_PARTYCODE    
--HAVING SUM(CQL_BALANCE) < -1000 OR SUM(CQL_BALANCE) >1000    
--ORDER BY CQL_PARTYCODE     
    
--     
    
  
SELECT *     
INTO #CL     
FROM    
 (    
 SELECT * FROM #PO     
 UNION    
 SELECT * FROM #BILL    
 --UNION    
 --SELECT CQL_PARTYCODE FROM #DRCR    
 ) X    
    
---     
    
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE     
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = CQL_PARTYCODE )    
    
DROP TABLE #CL     
DROP TABLE #PO     
DROP TABLE #BILL    
--DROP TABLE #DRCR    
DROP TABLE #PARTY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_POP_BAK_12072018
-- --------------------------------------------------

    
CREATE  PROC [dbo].[V2_PROC_QUARTERLYLEDGER_POP_BAK_12072018]           
(                    
               @FROMDATE   VARCHAR(11),                    
               @TODATE     VARCHAR(11),                    
               @FROMPARTY  VARCHAR(10),                    
               @TOPARTY    VARCHAR(10),        
    @FROMSCRIP  VARCHAR(12),        
    @TOSCRIP    VARCHAR(12)                 
)             
AS          
        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER_POP 'jul 12 2016','oct  3 2016','A101024','A101024','00','zzzzz'        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER 'jul 12 2016','oct  3 2016','A101024','A101024'     
          
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY          
        
---        
        
DELETE FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER WHERE CQL_VTYPE LIKE 'OPEN%'        
   

--- FINAL DATA FOR QL FILES GENERATION        
        
SELECT DISTINCT PARTY_CODE INTO #PO         
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK) WHERE FLAG = 'Y' AND LEFT(FMC_DATE,11) = (        
SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         
---        
        
SELECT DISTINCT PARTY_CODE         
INTO #PARTY        
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK)        
WHERE INACTIVE_DATE >= @TODATE AND LEFT(FMC_DATE,11) = (SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         

--- BILLS     
        
SELECT DISTINCT CQL_PARTYCODE AS PARTY_CODE INTO #BILL        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE CQL_VTYPE = 'BILL'         
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )       
  
        
--- DR/CR --        
        
/* ###### CHANGE ON 23/12/2016 ##### */        
        
SELECT CQL_PARTYCODE,SUM(CQL_BALANCE) AS BAL INTO #DRCR        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )        
GROUP BY CQL_PARTYCODE        
-- HAVING SUM(CQL_BALANCE) < -1000 OR SUM(CQL_BALANCE) >1000        
ORDER BY CQL_PARTYCODE         
        
--              
      
SELECT *         
INTO #CL         
FROM        
 (        
 SELECT * FROM #PO         
 UNION        
 SELECT * FROM #BILL        
 UNION        
 SELECT CQL_PARTYCODE FROM #DRCR        
 ) X        
      
---         
        
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE         
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = CQL_PARTYCODE )     
 

       
 DROP TABLE #CL         
 DROP TABLE #PO         
 DROP TABLE #BILL        
 DROP TABLE #DRCR        
 DROP TABLE #PARTY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_POP_TEST
-- --------------------------------------------------

    
CREATE  PROC [dbo].[V2_PROC_QUARTERLYLEDGER_POP_TEST]           
(                    
               @FROMDATE   VARCHAR(11),                    
               @TODATE     VARCHAR(11),                    
               @FROMPARTY  VARCHAR(10),                    
               @TOPARTY    VARCHAR(10),        
    @FROMSCRIP  VARCHAR(12),        
    @TOSCRIP    VARCHAR(12)                 
)             
AS          
        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER_POP 'jul 12 2016','oct  3 2016','A101024','A101024','00','zzzzz'        
-- EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER 'jul 12 2016','oct  3 2016','A101024','A101024'     
          
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY          
        
---        
        
DELETE FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER WHERE CQL_VTYPE LIKE 'OPEN%'        
   

--- FINAL DATA FOR QL FILES GENERATION        
        
SELECT DISTINCT PARTY_CODE INTO #PO         
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK) WHERE FLAG = 'Y' AND LEFT(FMC_DATE,11) = (        
SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         
---        
        
SELECT DISTINCT PARTY_CODE         
INTO #PARTY        
FROM PRADNYA.DBO.TBL_FCCSCLIENT (NOLOCK)        
WHERE INACTIVE_DATE >= @TODATE AND LEFT(FMC_DATE,11) = (SELECT DISTINCT LEFT(MAX(FMC_DATE),11) FROM TBL_FCCSCLIENT WHERE FMC_DATE < @TODATE )         
         

--- BILLS     
        
SELECT DISTINCT CQL_PARTYCODE AS PARTY_CODE INTO #BILL        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE CQL_VTYPE = 'BILL'         
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )       
  
        
--- DR/CR --        
        
/* ###### CHANGE ON 23/12/2016 ##### */        
        
SELECT CQL_PARTYCODE,SUM(CQL_BALANCE) AS BAL INTO #DRCR        
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)         
WHERE EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )        
GROUP BY CQL_PARTYCODE        
-- HAVING SUM(CQL_BALANCE) < -1000 OR SUM(CQL_BALANCE) >1000        
ORDER BY CQL_PARTYCODE         
        
--              
      
SELECT *         
INTO #CL         
FROM        
 (        
 SELECT * FROM #PO         
 UNION        
 SELECT * FROM #BILL        
 UNION        
 SELECT CQL_PARTYCODE FROM #DRCR        
 ) X        
      
---         
        
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE         
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = CQL_PARTYCODE )     
 

       
 DROP TABLE #CL         
 DROP TABLE #PO         
 DROP TABLE #BILL        
 DROP TABLE #DRCR        
 DROP TABLE #PARTY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_TEST
-- --------------------------------------------------

CREATE PROC [dbo].[V2_PROC_QUARTERLYLEDGER_TEST]                    
(                    
 @STARTDT VARCHAR(11),                    
 @ENDDT VARCHAR(11),                    
 @FROMPARTY VARCHAR(10),                    
 @TOPARTY VARCHAR(10)                    
)                    
                    
/*  **************  Process for Quarterly Ledger   ***************         
New sp for Commodity sent by Sinu on 07-jul-2011           
EXEC V2_PROC_QUARTERLYLEDGER 'MAR  1 2008' , 'MAR 31 2011', '0000000000', 'ZZZZZZZZZZ'                    
EXEC V2_PROC_QUARTERLYLEDGER 'JUN  1 2008' , 'AUG 31 2008', '0080', '0080'                    
*/                    
                    
AS                    
                    
SET NOCOUNT ON                    
                    
/*                    
CREATE TABLE V2_CLASS_QUARTERLYLEDGER                    
(                    
 CQL_ID BIGINT IDENTITY(1,1),                    
 CQL_SEGMENT VARCHAR(20),                    
 CQL_PARTYCODE VARCHAR(10),                    
 CQL_VDT VARCHAR(20),                    
 CQL_VTYPE VARCHAR(10),                    
 CQL_VNO VARCHAR(20),                    
 CQL_ACCODE VARCHAR(10),                    
 CQL_REMARKS VARCHAR(255),                    
 CQL_DDNO VARCHAR(20),                    
 CQL_DEBIT MONEY,                    
 CQL_CREDIT MONEY,                    
 CQL_BALANCE MONEY,                    
 CQL_ORDERBY TINYINT,                    
 CQL_DT INT,                     
 CQL_ACNAME VARCHAR(100)                    
)                    
*/                    
                    
TRUNCATE TABLE V2_CLASS_QUARTERLYLEDGER                    
                    
DECLARE @@SDTCUR DATETIME                    
                    
                    
/* NOW DOING NSECM */                    
      
CREATE TABLE #ACMAST      
(CLTCODE VARCHAR(10))      
      
CREATE CLUSTERED INDEX IDXCL ON #ACMAST(CLTCODE)      
      
INSERT INTO #ACMAST      
SELECT CL_CODE FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS      
WHERE CL_CODE >= @FROMPARTY AND CL_CODE <= @TOPARTY AND Exchange in ('NCX','MCX')    
                    
                    
/*===========================================================================================================*/                    
--------------------------------------------------------------------------------------------------------------------          
-- NCDX          
          
SELECT                     
 @@SDTCUR = SDTCUR                     
FROM                     
 ACCOUNTNCDX.DBO.PARAMETER                   
WHERE                    
 @STARTDT BETWEEN SDTCUR AND LDTCUR                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                    
 SUM(CQL_BALANCE),                    
 CQL_ORDERBY,                    
 19000101,                    
 CQL_ACNAME                    
FROM                     
 (                    
  SELECT                     
   CQL_SEGMENT = 'NCDX',                     
   CQL_PARTYCODE = L.CLTCODE,                    
   CQL_VDT = '',                    
   CQL_VTYPE = '',                    
   CQL_VNO = '',                    
   CQL_ACCODE = '',                    
   CQL_REMARKS = 'OPENING BALANCE',                    
   CQL_DDNO = '',                    
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
   CQL_ORDERBY = 5,                    
   CQL_ACNAME = L.ACNAME                    
  FROM                    
   ACCOUNTNCDX.DBO.LEDGER L                      
  WHERE                    
   L.VDT >= @@SDTCUR                    
   AND L.VDT < @STARTDT                    
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
 ) X                    
GROUP BY                    
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_ORDERBY,                    
 CQL_ACNAME                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT = 'NCDX',                     
 CQL_PARTYCODE = L.CLTCODE,                    
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                    
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                    
 CQL_VNO = L.VNO,                    
 CQL_ACCODE = '',                    
 CQL_REMARKS = L.NARRATION,                    
 CQL_DDNO = '',                    
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
 CQL_ORDERBY = 6,                    
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                    
 CQL_ACNAME  = L.ACNAME                    
FROM                    
 ACCOUNTNCDX.DBO.LEDGER L                      
 INNER JOIN                     
 ACCOUNTNCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                    
WHERE                     
 L.VDT >=  @STARTDT                    
 AND L.VDT <= @ENDDT + ' 23:59:59'                    
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
                    
---------------------------------------------------------------------------------------------------------------          
-- MCDX          
          
SELECT                     
 @@SDTCUR = SDTCUR                     
FROM                     
 ACCOUNTMCDX.DBO.PARAMETER                   
WHERE                    
 @STARTDT BETWEEN SDTCUR AND LDTCUR                    
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT,                    
 CQL_PARTYCODE,                    
 CQL_VDT,                   
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_DEBIT = (CASE WHEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT) >= 0 THEN SUM(CQL_DEBIT) - SUM(CQL_CREDIT)  ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT) >= 0 THEN SUM(CQL_CREDIT) - SUM(CQL_DEBIT)  ELSE 0 END),                    
 SUM(CQL_BALANCE),                    
 CQL_ORDERBY,                    
 19000101,                    
 CQL_ACNAME                    
FROM                     
 (                    
  SELECT                     
   CQL_SEGMENT = 'MCDX',                     
   CQL_PARTYCODE = L.CLTCODE,                    
   CQL_VDT = '',                    
   CQL_VTYPE = '',                    
   CQL_VNO = '',                    
   CQL_ACCODE = '',                    
   CQL_REMARKS = 'OPENING BALANCE',                    
   CQL_DDNO = '',                    
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
   CQL_ORDERBY = 5,                    
   CQL_ACNAME = L.ACNAME             
  FROM                    
   ACCOUNTMCDX.DBO.LEDGER L                      
  WHERE                     
   L.VDT >= @@SDTCUR                    
   AND L.VDT < @STARTDT                    
   AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)                 
 ) X                    
GROUP BY                    
 CQL_SEGMENT,                    
 CQL_PARTYCODE,         
 CQL_VDT,                    
 CQL_VTYPE,                    
 CQL_VNO,                    
 CQL_ACCODE,                    
 CQL_REMARKS,                    
 CQL_DDNO,                    
 CQL_ORDERBY,                    
 CQL_ACNAME          
                    
                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
INSERT INTO V2_CLASS_QUARTERLYLEDGER                    
SELECT                     
 CQL_SEGMENT = 'MCDX',                     
 CQL_PARTYCODE = L.CLTCODE,                    
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),                    
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),                    
 CQL_VNO = L.VNO,                    
 CQL_ACCODE = '',                    
 CQL_REMARKS = L.NARRATION,                    
 CQL_DDNO = '',                    
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                    
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                    
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                    
 CQL_ORDERBY = 6,                    
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),                    
 CQL_ACNAME  = L.ACNAME                    
FROM                    
 ACCOUNTMCDX.DBO.LEDGER L                      
 INNER JOIN                     
 ACCOUNTMCDX.DBO.VMAST V ON (V.VTYPE = L.VTYP)                    
WHERE                     
 L.VDT >=  @STARTDT                    
 AND L.VDT <= @ENDDT + ' 23:59:59'                    
 AND EXISTS(SELECT CLTCODE FROM #ACMAST A WHERE L.CLTCODE = A.CLTCODE)      
                    
          
-------------------------------------------------------------------------------------------------------------------                                          
/*============================================================================================================*/                  
/*                    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                    
SELECT                     
 Q.*,                    
 CQL_ADD1 = C.L_ADDRESS1,                    
 CQL_ADD2 = C.L_ADDRESS2,                    
 CQL_ADD3 = C.L_ADDRESS3,                    
 CQL_CITY = C.L_CITY,                    
 CQL_ZIP = C.L_ZIP,                    
 CQL_PHONE = C.RES_PHONE1,                    
 CQL_BRANCH = B.BRANCH+' ~ ('+C.BRANCH_CD+')',                    
 CQL_SUBBROKER = S.NAME + ' ~ (' + C.SUB_BROKER + ')',                    
 CQL_TRADER = T.LONG_NAME + ' ~ (' + C.TRADER + ')'                    
FROM                     
 V2_CLASS_QUARTERLYLEDGER Q (NOLOCK)                    
 INNER JOIN                    
  MSAJAG.DBO.CLIENT_DETAILS C (NOLOCK)                    
  INNER JOIN MSAJAG.DBO.BRANCH B (NOLOCK) ON (C.BRANCH_CD = B.BRANCH_CODE)                    
  INNER JOIN MSAJAG.DBO.BRANCHES T (NOLOCK) ON (C.TRADER = T.SHORT_NAME)                    
  INNER JOIN MSAJAG.DBO.SUBBROKERS S (NOLOCK) ON (C.SUB_BROKER = S.SUB_BROKER)                    
 ON (Q.CQL_PARTYCODE = C.CL_CODE)                    
ORDER BY                     
 Q.CQL_PARTYCODE,                    
 Q.CQL_ORDERBY,                    
 Q.CQL_DT                    
        
*/                              
  select * from V2_CLASS_QUARTERLYLEDGER WHERE CQL_PARTYCODE='AGRA2777'   
  --RETURN           
DELETE FROM V2_CLASS_QUARTERLYLEDGER                
WHERE CQL_DEBIT = 0                
AND CQL_CREDIT = 0   

                       
  select * from V2_CLASS_QUARTERLYLEDGER WHERE CQL_PARTYCODE='AGRA2777'   
 -- RETURN    

-- Comment by Dharmesh M on dated : 04/06/2012  
    
--DELETE FROM V2_CLASS_QUARTERLYLEDGER     
--WHERE NOT EXISTS (SELECT  CQL_PARTYCODE FROM V2_CLASS_QUARTERLYLEDGER B     
--WHERE  B.CQL_PARTYCODE = V2_CLASS_QUARTERLYLEDGER.CQL_PARTYCODE     
--AND B.CQL_VTYPE ='BILL')

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Client_details1102_dkm
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Client_details1102_dkm]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_zip] VARCHAR(10) NULL,
    [city] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Pin_code] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_dkm_Charges_detail_mcd
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_dkm_Charges_detail_mcd]
(
    [CD_SRNO] INT IDENTITY(1,1) NOT NULL,
    [CD_PARTY_CODE] VARCHAR(10) NOT NULL,
    [CD_SAUDA_DATE] DATETIME NOT NULL,
    [CD_CONTRACT_NO] VARCHAR(14) NOT NULL,
    [CD_TRADE_NO] VARCHAR(15) NOT NULL,
    [CD_ORDER_NO] VARCHAR(15) NOT NULL,
    [CD_INST_TYPE] VARCHAR(6) NOT NULL,
    [CD_SYMBOL] VARCHAR(12) NOT NULL,
    [CD_EXPIRY_DATE] DATETIME NOT NULL,
    [CD_OPTION_TYPE] VARCHAR(2) NOT NULL,
    [CD_STRIKE_PRICE] MONEY NOT NULL,
    [CD_AUCTIONPART] VARCHAR(2) NOT NULL,
    [CD_MARKETLOT] INT NOT NULL,
    [CD_SCHEME_ID] INT NOT NULL,
    [CD_COMPUTATIONLEVEL] CHAR(1) NOT NULL,
    [CD_COMPUTATIONON] CHAR(1) NOT NULL,
    [CD_COMPUTATIONTYPE] CHAR(1) NOT NULL,
    [CD_BUYRATE] NUMERIC(36, 12) NOT NULL,
    [CD_SELLRATE] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_BUYQTY] INT NOT NULL,
    [CD_TOT_SELLQTY] INT NOT NULL,
    [CD_TOT_BUYTURNOVER] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SELLTURNOVER] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_BUYTURNOVER_ROUNDED] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SELLTURNOVER_ROUNDED] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_TURNOVER] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_TURNOVER_ROUNDED] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_LOT] INT NOT NULL,
    [CD_TOT_RES_TURNOVER] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_RES_TURNOVER_ROUNDED] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_RES_LOT] INT NOT NULL,
    [CD_TOT_BUYBROK] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SELLBROK] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_BROK] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_BUYSERTAX] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SELLSERTAX] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SERTAX] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_STT] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_TURN_TAX] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_OTHER_CHRG] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_SEBI_TAX] NUMERIC(36, 12) NOT NULL,
    [CD_TOT_STAMPDUTY] NUMERIC(36, 12) NOT NULL,
    [CD_EXCH_BUYRATE] NUMERIC(36, 12) NOT NULL,
    [CD_EXCH_SELLRATE] NUMERIC(36, 12) NOT NULL,
    [CD_TIMESTAMP] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_dkm_Charges_detail_mcx
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_dkm_Charges_detail_mcx]
(
    [CD_SrNo] INT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_Contract_No] VARCHAR(14) NOT NULL,
    [CD_Trade_No] VARCHAR(15) NOT NULL,
    [CD_Order_No] VARCHAR(15) NOT NULL,
    [CD_Inst_Type] VARCHAR(6) NOT NULL,
    [CD_Symbol] VARCHAR(12) NOT NULL,
    [CD_Expiry_Date] DATETIME NOT NULL,
    [CD_Option_Type] VARCHAR(2) NOT NULL,
    [CD_Strike_Price] MONEY NOT NULL,
    [CD_AuctionPart] VARCHAR(2) NOT NULL,
    [CD_MarketLot] INT NOT NULL,
    [CD_Scheme_Id] INT NOT NULL,
    [CD_ComputationLevel] CHAR(1) NOT NULL,
    [CD_ComputationOn] CHAR(1) NOT NULL,
    [CD_ComputationType] CHAR(1) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_Tot_BuyQty] INT NOT NULL,
    [CD_Tot_SellQty] INT NOT NULL,
    [CD_Tot_BuyTurnOver] MONEY NOT NULL,
    [CD_Tot_SellTurnOver] MONEY NOT NULL,
    [CD_Tot_BuyTurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_SellTurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_TurnOver] MONEY NOT NULL,
    [CD_Tot_TurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_Lot] INT NOT NULL,
    [CD_Tot_Res_TurnOver] MONEY NOT NULL,
    [CD_Tot_Res_TurnOver_Rounded] MONEY NOT NULL,
    [CD_Tot_Res_Lot] INT NOT NULL,
    [CD_Tot_BuyBrok] MONEY NOT NULL,
    [CD_Tot_SellBrok] MONEY NOT NULL,
    [CD_Tot_Brok] MONEY NOT NULL,
    [CD_Tot_BuySerTax] MONEY NOT NULL,
    [CD_Tot_SellSerTax] MONEY NOT NULL,
    [CD_Tot_SerTax] MONEY NOT NULL,
    [CD_Tot_Stt] MONEY NOT NULL,
    [CD_Tot_Turn_Tax] MONEY NOT NULL,
    [CD_Tot_Other_Chrg] MONEY NOT NULL,
    [CD_Tot_Sebi_Tax] MONEY NOT NULL,
    [CD_Tot_StampDuty] MONEY NOT NULL,
    [CD_Exch_BuyRate] MONEY NOT NULL,
    [CD_Exch_SellRate] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_dkm_Client_details1102
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_dkm_Client_details1102]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [L_city] VARCHAR(40) NULL,
    [L_state] VARCHAR(50) NULL,
    [L_zip] VARCHAR(10) NULL,
    [city] VARCHAR(100) NULL,
    [State] VARCHAR(100) NULL,
    [Pin_code] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bak_FMC231212
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_FMC231212]
(
    [Party_code] VARCHAR(10) NULL,
    [MCDX_Ledger] MONEY NULL,
    [NCDX_Ledger] MONEY NULL,
    [MCDX_Deposit] MONEY NULL,
    [NCDX_Deposit] MONEY NULL,
    [MCDX_Margin] MONEY NULL,
    [NCDX_Margin] MONEY NULL,
    [MCDX_Coll] MONEY NULL,
    [NCDX_Coll] MONEY NULL,
    [MCDX_UnRecoVal] MONEY NULL,
    [NCDEX_UnRecoVal] MONEY NULL,
    [UnRecoVal] MONEY NULL,
    [Net_Credit] MONEY NULL,
    [Total_Marg75] MONEY NULL,
    [Intra_HghMrg_Comm] MONEY NULL,
    [MCDX_Net] MONEY NULL,
    [NCDX_Net] MONEY NULL,
    [Final_Net] MONEY NULL,
    [Update_date] DATETIME NULL,
    [AccrualAmt] MONEY NULL,
    [MCDX_OP] MONEY NULL,
    [NCDX_OP] MONEY NULL,
    [MCDX_USD] MONEY NULL,
    [NCDX_USD] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_MONTHLYLEDGER_Dec12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_MONTHLYLEDGER_Dec12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Apr12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Apr12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Aug11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Aug11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_AUG12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_AUG12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Dec11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Dec11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS010113
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS010113]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS011012
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS011012]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS020712
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS020712]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS030912
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS030912]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS031212
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS031212]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040213_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040213_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040213_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040213_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040612
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS040612]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060513_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060513_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060513_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060513_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060812
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS060812]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS061112
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS061112]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS070113
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS070113]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS080713
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS080713]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS081012
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS081012]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS100912
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS100912]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS101212
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS101212]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS110612
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS110612]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P3
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130513_P3]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130812
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS130812]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS131112
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS131112]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS140113
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS140113]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_V2_CLASS_QUARTERLYLEDGER_FCCS140317
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_V2_CLASS_QUARTERLYLEDGER_FCCS140317]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS151012
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS151012]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS160712
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS160712]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS170912
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS170912]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS171212
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS171212]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS180612
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS180612]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS191112
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS191112]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS200513_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210512
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210512]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210512_new
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210512_new]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210812
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS210812]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS220413_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS220413_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS220413_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS220413_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS221012
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS221012]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS230712
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS230712]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS250612
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS250612]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS261112
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS261112]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS261212
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS261212]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS270812
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS270812]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS280512
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS280512]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS290413_P1
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS290413_P1]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS290413_P2
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS290413_P2]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS291012
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS291012]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_FCCS300712
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_FCCS300712]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Feb12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Feb12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Jan12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Jan12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Jul11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Jul11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_JUL12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_JUL12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_V2_CLASS_QUARTERLYLEDGER_Jun11
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_V2_CLASS_QUARTERLYLEDGER_Jun11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_JUN12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_JUN12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_May12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_May12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Nov11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Nov11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Nov12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Nov12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Oct11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Oct11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Oct12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Oct12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Sep11
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Sep11]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bak_V2_CLASS_QUARTERLYLEDGER_Sep12
-- --------------------------------------------------
CREATE TABLE [dbo].[Bak_V2_CLASS_QUARTERLYLEDGER_Sep12]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_BseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_BseCurFo]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_Mcdx]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_MCDXCDS]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_Ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_Ncdx]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_Nsefo]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.history_fobillvalan_mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[history_fobillvalan_mcdx]
(
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Client_Type] VARCHAR(10) NULL,
    [BillNo] VARCHAR(10) NULL,
    [ContractNo] VARCHAR(10) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Option_type] VARCHAR(2) NULL,
    [Strike_Price] MONEY NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MaturityDate] SMALLDATETIME NULL,
    [Sauda_date] SMALLDATETIME NULL,
    [IsIn] VARCHAR(12) NULL,
    [PQty] INT NULL,
    [SQty] INT NULL,
    [PRate] MONEY NULL,
    [SRate] MONEY NULL,
    [PAmt] MONEY NULL,
    [SAmt] MONEY NULL,
    [PBrokAmt] MONEY NULL,
    [SBrokAmt] MONEY NULL,
    [PBillAmt] MONEY NULL,
    [SBillAmt] MONEY NULL,
    [Cl_Rate] MONEY NULL,
    [Cl_Chrg] MONEY NULL,
    [ExCl_Chrg] MONEY NULL,
    [Service_Tax] MONEY NULL,
    [ExSer_Tax] MONEY NULL,
    [InExSerFlag] SMALLINT NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [Broker_note] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [TradeType] VARCHAR(3) NULL,
    [ParticiPantCode] VARCHAR(15) NULL,
    [Terminal_Id] VARCHAR(15) NULL,
    [Family] VARCHAR(10) NULL,
    [FamilyName] VARCHAR(50) NULL,
    [Trader] VARCHAR(20) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [StatusName] VARCHAR(15) NULL,
    [Exchange] VARCHAR(5) NULL,
    [Segment] VARCHAR(10) NULL,
    [MemberType] VARCHAR(2) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Region] VARCHAR(50) NULL,
    [UpdateDate] VARCHAR(11) NULL,
    [email] VARCHAR(100) NULL,
    [SBU] VARCHAR(10) NULL,
    [RELMGR] VARCHAR(10) NULL,
    [GRP] VARCHAR(10) NULL,
    [Sector] VARCHAR(20) NULL,
    [CMClosing] MONEY NULL,
    [Track] VARCHAR(1) NULL,
    [Area] VARCHAR(10) NULL,
    [Numerator] NUMERIC(18, 4) NULL,
    [Denominator] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Foclosing_Billreport_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_Billreport_Mcdx]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] DATETIME NULL,
    [Trade_date] DATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(7) NULL,
    [Option_type] VARCHAR(2) NULL,
    [bhavcopy_date] DATETIME NULL,
    [reserved1] NUMERIC(18, 0) NULL,
    [reserved2] CHAR(2) NULL,
    [previous_close_price] NUMERIC(18, 0) NULL,
    [open_price] NUMERIC(18, 0) NULL,
    [high_price] NUMERIC(18, 0) NULL,
    [low_price] NUMERIC(18, 0) NULL,
    [closing_price] NUMERIC(18, 0) NULL,
    [total_qty_traded] NUMERIC(18, 0) NULL,
    [total_value_traded] NUMERIC(18, 0) NULL,
    [life_time_hight] NUMERIC(18, 0) NULL,
    [life_time_low] NUMERIC(18, 0) NULL,
    [quote_unit] CHAR(5) NULL,
    [number_of_price] NUMERIC(18, 0) NULL,
    [open_interest] NUMERIC(18, 0) NULL,
    [average_traded_price] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_FOCLOSING_BILLREPORT_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOCLOSING_BILLREPORT_MCDXCDS]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] DATETIME NOT NULL,
    [Trade_date] DATETIME NOT NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(7) NULL,
    [Option_type] VARCHAR(2) NULL,
    [bhavcopy_date] DATETIME NULL,
    [reserved1] NUMERIC(18, 0) NULL,
    [reserved2] CHAR(2) NULL,
    [previous_close_price] NUMERIC(18, 0) NULL,
    [open_price] NUMERIC(18, 0) NULL,
    [high_price] NUMERIC(18, 0) NULL,
    [low_price] NUMERIC(18, 0) NULL,
    [closing_price] NUMERIC(18, 0) NULL,
    [total_qty_traded] NUMERIC(18, 0) NULL,
    [total_value_traded] NUMERIC(18, 0) NULL,
    [life_time_hight] NUMERIC(18, 0) NULL,
    [life_time_low] NUMERIC(18, 0) NULL,
    [quote_unit] CHAR(5) NULL,
    [number_of_price] NUMERIC(18, 0) NULL,
    [open_interest] NUMERIC(18, 0) NULL,
    [average_traded_price] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Foclosing_Billreport_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_Billreport_ncdx]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(5) NULL,
    [Option_type] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Foclosing_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_Mcdx]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] DATETIME NULL,
    [Trade_date] DATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(7) NULL,
    [Option_type] VARCHAR(2) NULL,
    [bhavcopy_date] DATETIME NULL,
    [reserved1] NUMERIC(18, 0) NULL,
    [reserved2] CHAR(2) NULL,
    [previous_close_price] NUMERIC(18, 0) NULL,
    [open_price] NUMERIC(18, 0) NULL,
    [high_price] NUMERIC(18, 0) NULL,
    [low_price] NUMERIC(18, 0) NULL,
    [closing_price] NUMERIC(18, 0) NULL,
    [total_qty_traded] NUMERIC(18, 0) NULL,
    [total_value_traded] NUMERIC(18, 0) NULL,
    [life_time_hight] NUMERIC(18, 0) NULL,
    [life_time_low] NUMERIC(18, 0) NULL,
    [quote_unit] CHAR(5) NULL,
    [number_of_price] NUMERIC(18, 0) NULL,
    [open_interest] NUMERIC(18, 0) NULL,
    [average_traded_price] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_FOCLOSING_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOCLOSING_MCDXCDS]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] DATETIME NOT NULL,
    [Trade_date] DATETIME NOT NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NOT NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(7) NULL,
    [Option_type] VARCHAR(2) NULL,
    [bhavcopy_date] DATETIME NULL,
    [reserved1] NUMERIC(18, 0) NULL,
    [reserved2] CHAR(2) NULL,
    [previous_close_price] NUMERIC(18, 0) NULL,
    [open_price] NUMERIC(18, 0) NULL,
    [high_price] NUMERIC(18, 0) NULL,
    [low_price] NUMERIC(18, 0) NULL,
    [closing_price] NUMERIC(18, 0) NULL,
    [total_qty_traded] NUMERIC(18, 0) NULL,
    [total_value_traded] NUMERIC(18, 0) NULL,
    [life_time_hight] NUMERIC(18, 0) NULL,
    [life_time_low] NUMERIC(18, 0) NULL,
    [quote_unit] CHAR(5) NULL,
    [number_of_price] NUMERIC(18, 0) NULL,
    [open_interest] NUMERIC(18, 0) NULL,
    [average_traded_price] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Foclosing_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_ncdx]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(5) NULL,
    [Option_type] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_FoexerciseAllocation_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoexerciseAllocation_Mcdx]
(
    [foea_table_no] VARCHAR(16) NULL,
    [foea_position_date] DATETIME NULL,
    [foea_desc] VARCHAR(50) NULL,
    [foea_segment_ind] VARCHAR(5) NULL,
    [foea_sett_type] VARCHAR(2) NULL,
    [foea_cm_code] VARCHAR(13) NULL,
    [foea_mem_type] VARCHAR(1) NULL,
    [foea_tm_code] VARCHAR(13) NULL,
    [foea_acc_type] VARCHAR(2) NULL,
    [foea_party_code] VARCHAR(15) NULL,
    [foea_inst_type] VARCHAR(6) NULL,
    [foea_symbol] VARCHAR(12) NULL,
    [foea_expirydate] DATETIME NULL,
    [foea_strike_price] MONEY NULL,
    [foea_option_type] VARCHAR(2) NULL,
    [foea_cor_act_level] INT NULL,
    [foea_preexall_longqty] INT NULL,
    [foea_preexall_shortqty] INT NULL,
    [foea_exercise_qty] INT NULL,
    [foea_alloc_qty] INT NULL,
    [foea_postexall_longqty] INT NULL,
    [foea_postexall_shortqty] INT NULL,
    [foea_Brought_Forward_long_Quantity] INT NULL,
    [foea_Brought_Forward_long_Value] MONEY NULL,
    [foea_Brought_Forward_Short_Quantity] INT NULL,
    [foea_Brought_Forward_Short_Value] MONEY NULL,
    [foea_Day_Buy_Open_Quantity] INT NULL,
    [foea_Day_Buy_Open_Value] MONEY NULL,
    [foea_Day_Sell_Open_Quantity] INT NULL,
    [foea_Day_Sell_Open_Value] MONEY NULL,
    [foea_preexall_longValue] MONEY NULL,
    [foea_preexall_ShortValue] MONEY NULL,
    [foea_postexall_longValue] MONEY NULL,
    [foea_postexall_shortvalue] MONEY NULL,
    [foea_SettlementPrice] MONEY NULL,
    [foea_NetPremium] MONEY NULL,
    [foea_Daily_MTM_Settlement_Value] MONEY NULL,
    [foea_Futures_Final_Settlement_Value] MONEY NULL,
    [foea_Exercised_Assigned_Value] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_FOEXERCISEALLOCATION_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOEXERCISEALLOCATION_MCDXCDS]
(
    [FOEA_TABLE_NO] VARCHAR(16) NULL,
    [FOEA_POSITION_DATE] DATETIME NULL,
    [FOEA_DESC] VARCHAR(50) NULL,
    [FOEA_SEGMENT_IND] VARCHAR(5) NULL,
    [FOEA_SETT_TYPE] VARCHAR(2) NULL,
    [FOEA_CM_CODE] VARCHAR(13) NULL,
    [FOEA_MEM_TYPE] VARCHAR(1) NULL,
    [FOEA_TM_CODE] VARCHAR(13) NULL,
    [FOEA_ACC_TYPE] VARCHAR(2) NULL,
    [FOEA_PARTY_CODE] VARCHAR(15) NULL,
    [FOEA_INST_TYPE] VARCHAR(6) NULL,
    [FOEA_SYMBOL] VARCHAR(12) NULL,
    [FOEA_EXPIRYDATE] DATETIME NULL,
    [FOEA_STRIKE_PRICE] MONEY NOT NULL,
    [FOEA_OPTION_TYPE] VARCHAR(2) NULL,
    [FOEA_COR_ACT_LEVEL] INT NULL,
    [FOEA_PREEXALL_LONGQTY] INT NULL,
    [FOEA_PREEXALL_SHORTQTY] INT NULL,
    [FOEA_EXERCISE_QTY] INT NULL,
    [FOEA_ALLOC_QTY] INT NULL,
    [FOEA_POSTEXALL_LONGQTY] INT NULL,
    [FOEA_POSTEXALL_SHORTQTY] INT NULL,
    [FOEA_BROUGHT_FORWARD_LONG_QUANTITY] INT NULL,
    [FOEA_BROUGHT_FORWARD_LONG_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_BROUGHT_FORWARD_SHORT_QUANTITY] INT NULL,
    [FOEA_BROUGHT_FORWARD_SHORT_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_DAY_BUY_OPEN_QUANTITY] INT NULL,
    [FOEA_DAY_BUY_OPEN_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_DAY_SELL_OPEN_QUANTITY] INT NULL,
    [FOEA_DAY_SELL_OPEN_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_PREEXALL_LONGVALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_PREEXALL_SHORTVALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_POSTEXALL_LONGVALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_POSTEXALL_SHORTVALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_SETTLEMENTPRICE] NUMERIC(36, 12) NOT NULL,
    [FOEA_NETPREMIUM] NUMERIC(36, 12) NOT NULL,
    [FOEA_DAILY_MTM_SETTLEMENT_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_FUTURES_FINAL_SETTLEMENT_VALUE] NUMERIC(36, 12) NOT NULL,
    [FOEA_EXERCISED_ASSIGNED_VALUE] NUMERIC(36, 12) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_FoexerciseAllocation_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoexerciseAllocation_ncdx]
(
    [foea_table_no] VARCHAR(16) NULL,
    [foea_position_date] DATETIME NULL,
    [foea_desc] VARCHAR(50) NULL,
    [foea_segment_ind] VARCHAR(5) NULL,
    [foea_sett_type] VARCHAR(2) NULL,
    [foea_cm_code] VARCHAR(13) NULL,
    [foea_mem_type] VARCHAR(1) NULL,
    [foea_tm_code] VARCHAR(13) NULL,
    [foea_acc_type] VARCHAR(2) NULL,
    [foea_party_code] VARCHAR(15) NULL,
    [foea_inst_type] VARCHAR(6) NULL,
    [foea_symbol] VARCHAR(12) NULL,
    [foea_expirydate] DATETIME NULL,
    [foea_strike_price] MONEY NULL,
    [foea_option_type] VARCHAR(2) NULL,
    [foea_cor_act_level] INT NULL,
    [foea_preexall_longqty] INT NULL,
    [foea_preexall_shortqty] INT NULL,
    [foea_exercise_qty] INT NULL,
    [foea_alloc_qty] INT NULL,
    [foea_postexall_longqty] INT NULL,
    [foea_postexall_shortqty] INT NULL,
    [foea_Brought_Forward_long_Quantity] INT NULL,
    [foea_Brought_Forward_long_Value] MONEY NULL,
    [foea_Brought_Forward_Short_Quantity] INT NULL,
    [foea_Brought_Forward_Short_Value] MONEY NULL,
    [foea_Day_Buy_Open_Quantity] INT NULL,
    [foea_Day_Buy_Open_Value] MONEY NULL,
    [foea_Day_Sell_Open_Quantity] INT NULL,
    [foea_Day_Sell_Open_Value] MONEY NULL,
    [foea_preexall_longValue] MONEY NULL,
    [foea_preexall_ShortValue] MONEY NULL,
    [foea_postexall_longValue] MONEY NULL,
    [foea_postexall_shortvalue] MONEY NULL,
    [foea_SettlementPrice] MONEY NULL,
    [foea_NetPremium] MONEY NULL,
    [foea_Daily_MTM_Settlement_Value] MONEY NULL,
    [foea_Futures_Final_Settlement_Value] MONEY NULL,
    [foea_Exercised_Assigned_Value] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Fosettlement_BSECURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_BSECURFO]
(
    [SrNo] INT NOT NULL,
    [Contractno] VARCHAR(14) NOT NULL,
    [Billno] INT NULL,
    [Trade_No] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_Name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Strike_Price] MONEY NULL,
    [Option_Type] VARCHAR(2) NULL,
    [User_Id] VARCHAR(15) NULL,
    [Pro_Cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [Auctionpart] VARCHAR(2) NULL,
    [Markettype] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_No] VARCHAR(20) NULL,
    [Price] NUMERIC(18, 8) NULL,
    [Sauda_Date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_Perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_Puc] MONEY NULL,
    [Day_Sales] MONEY NULL,
    [Sett_Purch] MONEY NULL,
    [Sett_Sales] MONEY NULL,
    [Sell_Buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] NUMERIC(18, 8) NULL,
    [Netrate] NUMERIC(18, 8) NULL,
    [Amount] MONEY NULL,
    [Ins_Chrg] MONEY NULL,
    [Turn_Tax] MONEY NULL,
    [Other_Chrg] MONEY NULL,
    [Sebi_Tax] MONEY NULL,
    [Broker_Chrg] MONEY NULL,
    [Service_Tax] NUMERIC(18, 8) NULL,
    [Trade_Amount] MONEY NULL,
    [Billflag] INT NULL,
    [Sett_No] VARCHAR(12) NULL,
    [Nbrokapp] NUMERIC(18, 8) NULL,
    [Nsertax] MONEY NULL,
    [N_Netrate] NUMERIC(18, 8) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [Participantcode] VARCHAR(15) NULL,
    [Status] VARCHAR(3) NULL,
    [Cpid] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [Booktype] VARCHAR(5) NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [Tmark] VARCHAR(10) NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] MONEY NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Fosettlement_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_Mcdx]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] INT NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(15) NOT NULL,
    [Price] MONEY NULL,
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
    [sett_no] VARCHAR(12) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] NUMERIC(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(3) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] VARCHAR(10) NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] MONEY NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_FOSETTLEMENT_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOSETTLEMENT_MCDXCDS]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CONTRACTNO] VARCHAR(14) NOT NULL,
    [BILLNO] INT NULL,
    [TRADE_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [SYMBOL] VARCHAR(12) NULL,
    [SEC_NAME] VARCHAR(25) NOT NULL,
    [EXPIRYDATE] SMALLDATETIME NULL,
    [STRIKE_PRICE] MONEY NOT NULL,
    [OPTION_TYPE] VARCHAR(2) NULL,
    [USER_ID] VARCHAR(15) NULL,
    [PRO_CLI] INT NULL,
    [O_C_FLAG] VARCHAR(5) NULL,
    [C_U_FLAG] VARCHAR(7) NULL,
    [TRADEQTY] NUMERIC(36, 0) NULL,
    [AUCTIONPART] VARCHAR(2) NULL,
    [MARKETTYPE] VARCHAR(2) NULL,
    [SERIES] CHAR(2) NOT NULL,
    [ORDER_NO] VARCHAR(15) NOT NULL,
    [PRICE] NUMERIC(36, 12) NOT NULL,
    [SAUDA_DATE] DATETIME NOT NULL,
    [TABLE_NO] VARCHAR(4) NOT NULL,
    [LINE_NO] NUMERIC(3, 0) NOT NULL,
    [VAL_PERC] CHAR(1) NULL,
    [NORMAL] NUMERIC(36, 12) NOT NULL,
    [DAY_PUC] NUMERIC(36, 12) NOT NULL,
    [DAY_SALES] NUMERIC(36, 12) NOT NULL,
    [SETT_PURCH] NUMERIC(36, 12) NOT NULL,
    [SETT_SALES] NUMERIC(36, 12) NOT NULL,
    [SELL_BUY] INT NOT NULL,
    [SETTFLAG] INT NULL,
    [BROKAPPLIED] NUMERIC(36, 12) NOT NULL,
    [NETRATE] NUMERIC(36, 12) NULL,
    [AMOUNT] NUMERIC(36, 12) NOT NULL,
    [INS_CHRG] NUMERIC(36, 12) NOT NULL,
    [TURN_TAX] NUMERIC(36, 12) NOT NULL,
    [OTHER_CHRG] NUMERIC(36, 12) NOT NULL,
    [SEBI_TAX] NUMERIC(36, 12) NOT NULL,
    [BROKER_CHRG] NUMERIC(36, 12) NOT NULL,
    [SERVICE_TAX] NUMERIC(36, 12) NOT NULL,
    [TRADE_AMOUNT] NUMERIC(36, 12) NOT NULL,
    [BILLFLAG] INT NULL,
    [SETT_NO] VARCHAR(12) NULL,
    [NBROKAPP] NUMERIC(36, 12) NOT NULL,
    [NSERTAX] NUMERIC(36, 12) NOT NULL,
    [N_NETRATE] NUMERIC(36, 12) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [CL_RATE] NUMERIC(36, 12) NOT NULL,
    [PARTICIPANTCODE] VARCHAR(15) NULL,
    [STATUS] VARCHAR(3) NULL,
    [CPID] INT NULL,
    [INSTRUMENT] NUMERIC(18, 4) NULL,
    [BOOKTYPE] NUMERIC(18, 4) NULL,
    [BRANCH_ID] VARCHAR(15) NULL,
    [TMARK] VARCHAR(10) NULL,
    [SCHEME] INT NULL,
    [DUMMY1] INT NULL,
    [DUMMY2] NUMERIC(36, 12) NOT NULL,
    [RESERVED1] INT NULL,
    [RESERVED2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Fosettlement_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_ncdx]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] MONEY NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(15) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] DECIMAL(15, 7) NULL,
    [Amount] MONEY NULL,
    [Ins_chrg] MONEY NULL,
    [turn_tax] MONEY NULL,
    [other_chrg] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [Broker_chrg] MONEY NULL,
    [Service_tax] MONEY NULL,
    [Trade_amount] MONEY NULL,
    [Billflag] INT NULL,
    [sett_no] VARCHAR(12) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] DECIMAL(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(3) NULL,
    [CpId] INT NULL,
    [Instrument] MONEY NULL,
    [BookType] MONEY NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] VARCHAR(10) NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] MONEY NULL,
    [Reserved1] INT NULL,
    [Reserved2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_BSECURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_BSECURFO]
(
    [Party_Code] VARCHAR(15) NOT NULL,
    [Margindate] DATETIME NOT NULL,
    [Billamount] MONEY NOT NULL,
    [Ledgeramount] MONEY NOT NULL,
    [Cash_Coll] MONEY NOT NULL,
    [Noncash_Coll] MONEY NOT NULL,
    [Initialmargin] MONEY NOT NULL,
    [Lst_Update_Dt] DATETIME NOT NULL,
    [Short_Name] VARCHAR(100) NULL,
    [Long_Name] VARCHAR(100) NULL,
    [Branch_Cd] VARCHAR(20) NULL,
    [Family] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(20) NULL,
    [Trader] VARCHAR(20) NULL,
    [Mtmmargin] MONEY NULL,
    [ActNoncash_Coll] MONEY NULL,
    [Client_Ctgry] VARCHAR(10) NULL,
    [AddMargin] MONEY NULL,
    [UNCLEARAMOUNT] MONEY NULL,
    [MRG_REP_COLL_CASH] MONEY NULL,
    [MRG_REP_COLL_NCASH] MONEY NULL,
    [PREV_BILLAMOUNT] MONEY NULL,
    [PREMIUM_MARGIN] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_MCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_MCDX]
(
    [party_code] VARCHAR(15) NOT NULL,
    [margindate] DATETIME NOT NULL,
    [billamount] MONEY NOT NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [noncash_coll] MONEY NOT NULL,
    [initialmargin] MONEY NOT NULL,
    [lst_update_dt] DATETIME NOT NULL,
    [short_name] VARCHAR(25) NULL,
    [long_name] VARCHAR(100) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [sub_broker] VARCHAR(20) NULL,
    [trader] VARCHAR(20) NULL,
    [MTMMargin] MONEY NULL,
    [AddMargin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_MCDXCDS]
(
    [PARTY_CODE] VARCHAR(15) NOT NULL,
    [MARGINDATE] DATETIME NOT NULL,
    [BILLAMOUNT] MONEY NOT NULL,
    [LEDGERAMOUNT] MONEY NOT NULL,
    [CASH_COLL] MONEY NOT NULL,
    [NONCASH_COLL] MONEY NOT NULL,
    [INITIALMARGIN] MONEY NOT NULL,
    [LST_UPDATE_DT] DATETIME NOT NULL,
    [SHORT_NAME] VARCHAR(25) NULL,
    [LONG_NAME] VARCHAR(100) NULL,
    [BRANCH_CD] VARCHAR(20) NULL,
    [FAMILY] VARCHAR(20) NULL,
    [SUB_BROKER] VARCHAR(20) NULL,
    [TRADER] VARCHAR(20) NULL,
    [MTMMARGIN] MONEY NULL,
    [ACTNONCASH_COLL] MONEY NULL,
    [CLIENT_CTGRY] VARCHAR(10) NULL,
    [ADDMARGIN] MONEY NULL,
    [UNCLEARAMOUNT] MONEY NULL,
    [MRG_REP_COLL_CASH] MONEY NULL,
    [MRG_REP_COLL_NCASH] MONEY NULL,
    [PREV_BILLAMOUNT] MONEY NULL,
    [PREMIUM_MARGIN] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL,
    [MemberType] VARCHAR(3) NOT NULL,
    [MemberCode] VARCHAR(15) NOT NULL,
    [ShareDb] VARCHAR(20) NOT NULL,
    [ShareServer] VARCHAR(15) NOT NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NOT NULL,
    [AccountServer] VARCHAR(15) NOT NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NOT NULL,
    [DefaultDbServer] VARCHAR(15) NOT NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [primaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_bkp_20220404
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_bkp_20220404]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL,
    [MemberType] VARCHAR(3) NOT NULL,
    [MemberCode] VARCHAR(15) NOT NULL,
    [ShareDb] VARCHAR(20) NOT NULL,
    [ShareServer] VARCHAR(15) NOT NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NOT NULL,
    [AccountServer] VARCHAR(15) NOT NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NOT NULL,
    [DefaultDbServer] VARCHAR(15) NOT NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [primaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_BSE
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_BSE]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL,
    [MemberType] VARCHAR(3) NOT NULL,
    [MemberCode] VARCHAR(15) NOT NULL,
    [ShareDb] VARCHAR(20) NOT NULL,
    [ShareServer] VARCHAR(15) NOT NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NOT NULL,
    [AccountServer] VARCHAR(15) NOT NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NOT NULL,
    [DefaultDbServer] VARCHAR(15) NOT NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [primaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [segment_Description] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NumberWords
-- --------------------------------------------------
CREATE TABLE [dbo].[NumberWords]
(
    [Number] SMALLINT NOT NULL,
    [NumberWord] VARCHAR(31) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PRATHAM_MCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[PRATHAM_MCDX]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [TRADECOUNT_MCDX] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PRATHAM_MCDXCDS
-- --------------------------------------------------
CREATE TABLE [dbo].[PRATHAM_MCDXCDS]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [TRADECOUNT_MCDXCDS] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PRATHAM_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[PRATHAM_NCDX]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [TRADECOUNT_NCDX] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_trd_MCDX_omnesys
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_trd_MCDX_omnesys]
(
    [sauda_date] DATETIME NOT NULL,
    [USER_ID] INT NOT NULL,
    [order_no] VARCHAR(15) NOT NULL,
    [trade_no] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_trd_NCDX_omnesys
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_trd_NCDX_omnesys]
(
    [sauda_date] DATETIME NOT NULL,
    [USER_ID] INT NOT NULL,
    [order_no] VARCHAR(15) NOT NULL,
    [trade_no] VARCHAR(20) NULL
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
-- TABLE dbo.TBL_CLASS_EXCEPTION_FOLDERS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CLASS_EXCEPTION_FOLDERS]
(
    [FILEPATH] VARCHAR(512) NULL,
    [FLDCATEGORY] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CLASS_USERS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CLASS_USERS]
(
    [FLDUSERNAME] VARCHAR(25) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FCCSCLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FCCSCLIENT]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [FMC_DATE] DATETIME NULL,
    [FLAG] VARCHAR(1) NULL,
    [INACTIVE_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL010113
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL010113]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL011012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL011012]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL020712
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL020712]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL030912
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL030912]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL031212
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL031212]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL040612
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL040612]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL060812
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL060812]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL061112
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL061112]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL070113
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL070113]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL081012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL081012]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL090712
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL090712]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL100912
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL100912]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL101212
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL101212]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL110612
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL110612]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL130812
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL130812]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL131112
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL131112]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL151012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL151012]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL160712
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL160712]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL170912
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL170912]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL171212
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL171212]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL180612
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL180612]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL191112
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL191112]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL210512
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL210512]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL210812
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL210812]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL221012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL221012]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL230712
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL230712]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL240912
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL240912]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL250612
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL250612]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL261112
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL261112]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL261212
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL261212]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL270812
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL270812]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL280512
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL280512]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL291012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL291012]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC_CL300712
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC_CL300712]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FMC2105_mismth
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FMC2105_mismth]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_pincity_master
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_pincity_master]
(
    [State] VARCHAR(100) NULL,
    [City] VARCHAR(100) NULL,
    [Pin_Code] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_QLcomm_bounced
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_QLcomm_bounced]
(
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SAUDA_DATE] DATETIME NOT NULL,
    [STATUSNAME] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_QLcomm_bounced_09012018
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_QLcomm_bounced_09012018]
(
    [EXCHANGE] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SAUDA_DATE] DATETIME NOT NULL,
    [STATUSNAME] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_QLcomm_bounced_IMP
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_QLcomm_bounced_IMP]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SAUDA_DATE] VARCHAR(11) NULL,
    [SESSION_ID] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmp_ncdx_bs
-- --------------------------------------------------
CREATE TABLE [dbo].[tmp_ncdx_bs]
(
    [trade_no] VARCHAR(10) NOT NULL,
    [tdate] DATETIME NULL,
    [sell_buy] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_MONTHLYLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_MONTHLYLEDGER]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_QUARTERLYLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYLEDGER]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_QUARTERLYLEDGER_bak_15012018
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYLEDGER_bak_15012018]
(
    [CQL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CQL_SEGMENT] VARCHAR(20) NULL,
    [CQL_PARTYCODE] VARCHAR(10) NULL,
    [CQL_VDT] VARCHAR(20) NULL,
    [CQL_VTYPE] VARCHAR(10) NULL,
    [CQL_VNO] VARCHAR(20) NULL,
    [CQL_ACCODE] VARCHAR(10) NULL,
    [CQL_REMARKS] VARCHAR(255) NULL,
    [CQL_DDNO] VARCHAR(20) NULL,
    [CQL_DEBIT] MONEY NULL,
    [CQL_CREDIT] MONEY NULL,
    [CQL_BALANCE] MONEY NULL,
    [CQL_ORDERBY] TINYINT NULL,
    [CQL_DT] INT NULL,
    [CQL_ACNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_08022011
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_08022011]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_10012011
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_10012011]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_10062010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_10062010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_10122010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_10122010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_11082010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_11082010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_13082010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_13082010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_14012011
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_14012011]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_14052010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_14052010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15042010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15042010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15062010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15062010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15072010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15072010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15092010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15092010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15102010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15102010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15112010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15112010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_15122010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_15122010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_19102010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_19102010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_CMS_STYLE_AGEING_26042010
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_CMS_STYLE_AGEING_26042010]
(
    [ProcessDate] DATETIME NULL,
    [Cltcode] VARCHAR(10) NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [NSEFO_ledger] MONEY NULL,
    [MCX_ledger] MONEY NULL,
    [NCDEX_ledger] MONEY NULL,
    [MCD_ledger] MONEY NULL,
    [NSX_ledger] MONEY NULL,
    [BSECM_UnClear] MONEY NULL,
    [NSECM_UnClear] MONEY NULL,
    [NSEFO_UnClear] MONEY NULL,
    [MCX_UnClear] MONEY NULL,
    [NCDEX_UnClear] MONEY NULL,
    [MCD_UnClear] MONEY NULL,
    [NSX_UnClear] MONEY NULL,
    [BSECM_Shortage] MONEY NULL,
    [NSECM_Shortage] MONEY NULL,
    [NSEFO_MrgnNet] MONEY NULL,
    [MCX_MrgnNet] MONEY NULL,
    [NCDEX_MrgnNet] MONEY NULL,
    [MCD_MrgnNet] MONEY NULL,
    [NSX_MrgnNet] MONEY NULL,
    [BSECM_NetPO] MONEY NULL,
    [NSECM_NetPO] MONEY NULL,
    [NSEFO_NetPO] MONEY NULL,
    [MCX_NetPO] MONEY NULL,
    [NCDEX_NetPO] MONEY NULL,
    [MCD_NetPO] MONEY NULL,
    [NSX_NetPO] MONEY NULL,
    [TOTAL_NetPO] MONEY NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.acc_multicompany
-- --------------------------------------------------

create view acc_multicompany
as
select *from pradnya.dbo.multicompany

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_OWNER_VW
-- --------------------------------------------------


    
CREATE VIEW [dbo].[CLS_OWNER_VW] AS   
SELECT 'MCX' AS EXCHANGE 
,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE='',COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE
,COMMONSEBINO=''
,COMMONMEMBERCODE='' 
FROM MCDX.DBO.FOOWNERNEW

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_FCCS_Data
-- --------------------------------------------------
      
  
      
  
CREATE View Vw_FCCS_Data      
  
as        
  
select         
  
[FMC_PO_Date]= Update_Date,        
[Party_Code]= Party_Code,        
[NCDX_Ledger]= NCDX_Ledger*-1,        
[MCDX_Ledger]= MCDX_Ledger*-1,        
[NCDX_Deposit]= NCDX_Deposit,        
[MCDX_Deposit]= MCDX_Deposit,         
[Other_Segment] = 0,      
[NCDX_Collateral]= NCDX_Coll,        
[MCDX_Collateral]= MCDX_Coll,        
[Accrual]= AccrualAmt*-1,        
[NCDX_Unreco]= NCDEX_UnRecoVal*-1,        
[MCDX_Unreco]= MCDX_UnRecoVal*-1,        
[NCDX_Margin]= (NCDX_Margin*2.25)*-1,        
[MCDX_Margin]= (MCDX_Margin*2.25)*-1,        
[NCDX_UnSettle]= NCDX_USD*-1,        
[MCDX_UnSettle]= MCDX_USD*-1,        
[COMM_Additional_Margin]= Intra_HghMrg_comm        
from mis.fccs.dbo.SCCS_Data_Commodities_History SD with (nolock)        
where exists         
(select update_date,party_code from mis.fccs.dbo.V_FCCSmaxpayoutDate VD with (nolock)         
where         
SD.party_code = VD.party_code and          
SD.update_date = VD.update_date        
)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_FCCS_Data_BAK13102015
-- --------------------------------------------------
    

    

CREATE View Vw_FCCS_Data_BAK13102015    

as      

select       

[FMC_PO_Date]= Update_Date,      

[Party_Code]= Party_Code,      

[NCDX_Ledger]= NCDX_Ledger,      

[MCDX_Ledger]= MCDX_Ledger,      

[NCDX_Deposit]= NCDX_Deposit,      

[MCDX_Deposit]= MCDX_Deposit,       

[Other_Segment] = 0,    

[NCDX_Collateral]= NCDX_Coll,      

[MCDX_Collateral]= MCDX_Coll,      

[Accrual]= AccrualAmt,      

[NCDX_Unreco]= NCDEX_UnRecoVal,      

[MCDX_Unreco]= MCDX_Coll,      

[NCDX_Margin]= NCDX_Margin*3,      

[MCDX_Margin]= MCDX_Margin*3,      

[NCDX_UnSettle]= NCDX_USD,      

[MCDX_UnSettle]= MCDX_USD,      

[COMM_Additional_Margin]= Intra_HghMrg_comm      

from mis.fccs.dbo.SCCS_Data_Commodities_History SD with (nolock)      

where exists       

(select update_date,party_code from mis.fccs.dbo.V_FCCSmaxpayoutDate VD with (nolock)       

where       

SD.party_code = VD.party_code and        

SD.update_date = VD.update_date      

)

GO

