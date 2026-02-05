-- DDL Export
-- Server: 10.254.33.26
-- Database: PRADNYA
-- Exported: 2026-02-05T11:34:15.174862

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
-- FUNCTION dbo.CLASS_PWDENCRY
-- --------------------------------------------------
CREATE Function [dbo].[CLASS_PWDENCRY](@PWD Varchar(20)) Returns Varchar(20) as
Begin
	DECLARE @retVal int
	DECLARE @retstr varchar(1000)
	DECLARE @comHandle INT
	DECLARE @errorSource VARCHAR(8000)
	DECLARE @errorDescription VARCHAR(8000)
	
	EXEC @retVal = master..sp_OACreate 'PradnyaPWDDllPrj.PradnyaPwdDll', @comHandle OUTPUT
	if @retVal <> 0 
	begin 
		EXEC master..sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
		Return RTrim(LTrim(@errorDescription))
	end
	
	EXEC @retVal = master..sp_OAMethod @comHandle, 'Encrypt',@retstr output, @PWD
		OUTPUT
	
	exec master..sp_OADestroy @comHandle
	
	Return @retstr 
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.CLS_PIECE
-- --------------------------------------------------


CREATE FUNCTION [dbo].[CLS_PIECE] ( @CHARACTEREXPRESSION VARCHAR(8000), @DELIMITER CHAR(1), @POSITION INTEGER)
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
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEFOLDER>', CONVERT(VARCHAR,@BUSINESS_DATE,112))    
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEYYYYMMDD>', CONVERT(VARCHAR,@BUSINESS_DATE,112))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE106NS>', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMM>', LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/',''),4))    
    
     
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEMMYY>', RIGHT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,3),'/',''),4))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE103->', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/','-'))    
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE103>', CONVERT(VARCHAR,@BUSINESS_DATE,103))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<MON-YEAR>', LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),3) + '-' + RIGHT(LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11),4))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,103),'/',''))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEDDMMYY>', LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,3),'/',''),6))    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<MEMBERCODE>', @MEMBERCODE)    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATE109>', '''' + LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11) + '''')    
    
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
 END    
    
 IF @SETT_TYPE = 'D'     
 BEGIN    
  SET @PARAMETER = REPLACE(@PARAMETER,'<SettTypePC>','P')    
 END    
    
 SET @PARAMETER = REPLACE(@PARAMETER,'<BUSINESS_DATE>',LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,109),11))    
    
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
-- FUNCTION dbo.fnMax
-- --------------------------------------------------

Create  Function [dbo].[fnMax](@Value1 money, @Value2 Money ) 
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

Create  Function [dbo].[fnMin](@Value1 money, @Value2 Money ) 
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
-- FUNCTION dbo.fnMinMax
-- --------------------------------------------------

CREATE Function [dbo].[fnMinMax](@Amt money, @MinAmt Money, @MaxAmt Money) 
Returns Money As
Begin
if @Amt > 0 
	begin	
		if @MinAmt > 0 
		Begin
			if @Amt < @MinAmt 
			Begin
				Set @Amt = @MinAmt
			End
			Begin
				Set @Amt = @Amt
			End
		End

		if @MaxAmt > -1 
		Begin
			if @Amt > @MaxAmt 
			Begin
				Set @Amt = @MaxAmt
			End
			Begin
				Set @Amt = @Amt
			End
		End
	End
	Return @Amt
End

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
CREATE FUNCTION [dbo].[IndianCurrencyInWords]
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
-- FUNCTION dbo.ReplaceServerName
-- --------------------------------------------------

Create   Function [dbo].[ReplaceServerName](@ServerName  Varchar(100))     
Returns Varchar(100) As    
Begin    
 Select @ServerName = Replace(Replace(@ServerName,'[',''),']','')       
    
Return @ServerName     
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.ReplaceTradeNo
-- --------------------------------------------------

CREATE FUNCTION [dbo].[ReplaceTradeNo]
(
  @Temp varchar(255)
)

RETURNS varchar(255)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^0-9]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')
    Return @Temp
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.ReplaceTradeNo_BAK_FEB112021
-- --------------------------------------------------
CREATE  Function [dbo].[ReplaceTradeNo_BAK_FEB112021](@TradeNo  Varchar(16)) 
Returns Varchar(16) As
Begin
declare @Flag Varchar(1)

	Select @Flag = '0'
	while @Flag <> '1'
	Begin
		Select @Flag = Left(Upper(@TradeNo),1)
		if @Flag >= 'A' And @Flag <= 'Z'
			Select @TradeNo = Replace(@TradeNo, @Flag, '')
		Else
			Select @Flag = '1'
	End
Return @TradeNo 
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RoundedTurnover
-- --------------------------------------------------
CREATE  Function [dbo].[RoundedTurnover](@Amt Numeric(18,4), @roundingAmt Numeric(18,4))  
Returns Numeric(18,4)  
As  
Begin  

	 if @Amt > 0 AND @roundingAmt > 1   
	  Select @Amt = (Case When @Amt - Convert(BigInt,@Amt/@roundingAmt)*@roundingAmt = 0   
						  Then @Amt   
			Else (Convert(BigInt,@Amt/@roundingAmt)+1)*@roundingAmt   
			  End)  
	 Else   
	  select @Amt = @Amt  
	 
	Return @Amt  
  
  end

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
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.UK
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [TEMPIDX] ON [dbo].[UK] ([MyFlag])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.NumberWords
-- --------------------------------------------------
ALTER TABLE [dbo].[NumberWords] ADD CONSTRAINT [PK__NumberWo__78A1A19C58D1301D] PRIMARY KEY ([Number])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__73BA3083] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_STATISTICS
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW
-- --------------------------------------------------

--EXEC PRADNYA.DBO.CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW @STATUSID = 'broker', @STATUSNAME = 'broker', @FROMPARTYCODE = '0', @TOPARTYCODE = 'ZZZZZZZ', @FROMDATE = 'Dec  1 2007', @TODATE = 'Nov 30 2010', @SETT_TYPE = '%', @FROMCODE = 'DFGDF', @TOCODE = 'DFGDF', @RPT_BY = 'SUB_BROKER' 

CREATE PROC [dbo].[CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW]
	(                        
	@STATUSID VARCHAR(25),
	@STATUSNAME VARCHAR(25),
	@FROMPARTYCODE VARCHAR(10),
	@TOPARTYCODE VARCHAR(10),
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@SETT_TYPE VARCHAR(3),
	@FROMCODE VARCHAR(15)='',
	@TOCODE	VARCHAR(15)='zzzzzzzzzz',
	@RPT_BY VARCHAR(15)='BROKER'
	)                        
                        
/*                        
EXEC [CLASSPROC_SAUDA_SUMMARY_CASHPRINT_NEW] 'BROKER','BROKER', 'GV54', 'GV54', 'FEB  1 2011', 'FEB 28 2011' ,'%'                       
*/                        
                        
AS                        

IF @TOCODE = ''
BEGIN
	SET @TOCODE = 'zzzzzzzzzz'
END


SELECT
	DISTINCT
	PARTY_CODE,
	PARENTCODE
INTO 
	#PARTY
FROM
	AngelBSECM.PRADNYA.DBO.TBL_ECNCASH with (NOLOCK)
WHERE
	PARENTCODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE
	AND (
	CASE
		WHEN @RPT_BY = 'FAMILY'		THEN FAMILY
		WHEN @RPT_BY = 'REGION'		THEN REGION
		WHEN @RPT_BY = 'AREA'		THEN AREA
		WHEN @RPT_BY = 'BRANCH'		THEN BRANCH_CD
		WHEN @RPT_BY = 'SUB_BROKER'	THEN SUB_BROKER
		WHEN @RPT_BY = 'TRADER'		THEN TRADER
		ELSE PARTY_CODE
	END)
	BETWEEN @FROMCODE AND @TOCODE
	AND @STATUSNAME = (
	CASE 
		WHEN @STATUSID = 'AREA' THEN AREA                
		WHEN @STATUSID = 'REGION' THEN REGION                
		WHEN @STATUSID = 'BRANCH' THEN BRANCH_CD                
		WHEN @STATUSID = 'SUBBROKER' THEN SUB_BROKER                
		WHEN @STATUSID = 'TRADER' THEN TRADER                
		WHEN @STATUSID = 'FAMILY' THEN FAMILY                
		WHEN @STATUSID = 'CLIENT' THEN PARTY_CODE                
		WHEN @STATUSID = 'BROKER' THEN @STATUSNAME                
		ELSE 'I DONT KNOW ' 
	END)




CREATE TABLE #CLASSTBL_SAUDASUMMARY                        
(                        
 EXCHANGE VARCHAR(8),                        
 TRDTYPE  VARCHAR(10),                        
 PARTY_CODE VARCHAR(10),                        
 TRADEDATE VARCHAR(10),                        
 SCRIP_CD VARCHAR(12),                         
 SCRIP_NAME VARCHAR(100),                        
 SETT_NO VARCHAR(7),                        
 SETT_TYPE VARCHAR(3),                        
 BUYQTY INT,                         
 BUYAVGRATE MONEY,                        
 BUYAMOUNT MONEY,                         
 SELLQTY INT,                        
 SELLAVGRATE MONEY,                        
 SELLAMOUNT MONEY,                        
 NETQTY INT,                        
 NETAVGRATE MONEY,                        
 NetAmount MONEY,                        
 FLAG TINYINT,
 LONG_NAME VARCHAR(100),          
 BRANCH_CD VARCHAR(20),          
 SUB_BROKER VARCHAR(20),          
 L_ADDRESS1 VARCHAR(100),          
 L_ADDRESS2 VARCHAR(100),          
 L_ADDRESS3 VARCHAR(100),          
 L_CITY VARCHAR(50),          
 L_STATE VARCHAR(50),          
 L_ZIP VARCHAR(20),          
 MOBILE_PAGER VARCHAR(50),          
 RES_PHONE1 VARCHAR(100),          
 RES_PHONE2 VARCHAR(100),          
 OFF_PHONE1 VARCHAR(100)         
)                        
                        
----------------------------                        
-- NOW STARTING BSE CASH --                        
----------------------------                        
                        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                        
INSERT INTO #CLASSTBL_SAUDASUMMARY                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '1. TRD',                        
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME,                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYTRD),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYTRD) <> 0 THEN SUM(PAMTTRD) / SUM(PQTYTRD) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTTRD),                         
 SELLQTY = SUM(SQTYTRD),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYTRD) <> 0 THEN SUM(SAMTTRD) / SUM(SQTYTRD) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTTRD) ,                        
 NETQTY = SUM(PQTYTRD) - SUM(SQTYTRD),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYTRD) - SUM(SQTYTRD)) <> 0 THEN ABS((SUM(SAMTTRD)-SUM(PAMTTRD))/(SUM(PQTYTRD) - SUM(SQTYTRD))) ELSE 0 END),                        
 NETAMT = SUM(SAMTTRD)-SUM(PAMTTRD),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY                         
	P.PARENTCODE,                        
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SCRIP_NAME,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYTRD) - SUM(SQTYTRD) <> 0                         
	OR SUM(SAMTTRD)-SUM(PAMTTRD) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '2. DEL',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                   
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_NAME + ' (DELIVERY)',                        
 SETT_NO,                        
 SETT_TYPE,           
 BUYQTY = SUM(PQTYDEL),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYDEL) <> 0 THEN SUM(PAMTDEL) / SUM(PQTYDEL) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTDEL),                         
 SELLQTY = SUM(SQTYDEL),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYDEL) <> 0 THEN SUM(SAMTDEL) / SUM(SQTYDEL) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTDEL),                        
 NETQTY = SUM(PQTYDEL) - SUM(SQTYDEL),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYDEL) - SUM(SQTYDEL)) <> 0 THEN ABS((SUM(SAMTDEL)-SUM(PAMTDEL))/(SUM(PQTYDEL) - SUM(SQTYDEL))) ELSE 0 END),                        
 NETAMT = SUM(SAMTDEL)-SUM(PAMTDEL),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY                         
	P.PARENTCODE,                        
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SCRIP_NAME,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYDEL) - SUM(SQTYDEL) <> 0                         
	OR SUM(SAMTDEL)-SUM(PAMTDEL) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'BSE CASH',                        
 TRDTYPE = '3. LEV',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD = 'ZZZZZZZZZZZZ',                         
SCRIP_NAME = '** LEVIES **',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = 0,                         
 BUYAVGRATE = 0,                        
 BUYAMOUNT = 0,                         
 SELLQTY = 0,                        
 SELLAVGRATE = 0,                        
 SELLAMOUNT = 0,                        
 NETQTY = 0,                        
 NETAVGRATE = 0,                        
 NETAMT = (SUM(SERVICE_TAX) + SUM(TURN_TAX)  + SUM(SEBI_TAX) + SUM(INS_CHRG) + SUM(BROKER_CHRG) + SUM(OTHER_CHRG)) * -1,                        
 FLAG = 2,                        
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	BSEDB_AB.DBO.CMBILLVALAN C (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND C.SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('AC','AD')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SETT_NO,                        
	SETT_TYPE                        
                        
----------------------------                        
-- NOW STARTING NSE CASH --                        
----------------------------                        
                        
                        
INSERT INTO #CLASSTBL_SAUDASUMMARY                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '1. TRD',                        
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_CD + ' - ' + SERIES,                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYTRD),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYTRD) <> 0 THEN SUM(PAMTTRD) / SUM(PQTYTRD) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTTRD),                         
 SELLQTY = SUM(SQTYTRD),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYTRD) <> 0 THEN SUM(SAMTTRD) / SUM(SQTYTRD) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTTRD) ,                        
 NETQTY = SUM(PQTYTRD) - SUM(SQTYTRD),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYTRD) - SUM(SQTYTRD)) <> 0 THEN ABS((SUM(SAMTTRD)-SUM(PAMTTRD))/(SUM(PQTYTRD) - SUM(SQTYTRD))) ELSE 0 END),                        
 NETAMT = SUM(SAMTTRD)-SUM(PAMTTRD),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),                     
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SERIES,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYTRD) - SUM(SQTYTRD) <> 0          
	OR SUM(SAMTTRD)-SUM(PAMTTRD) <> 0                        
                        
UNION                        
                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '2. DEL',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD,                         
 SCRIP_NAME = SCRIP_CD + ' - ' + SERIES + ' (DELIVERY)',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = SUM(PQTYDEL),                         
 BUYAVGRATE = (CASE WHEN SUM(PQTYDEL) <> 0 THEN SUM(PAMTDEL) / SUM(PQTYDEL) ELSE 0 END),                        
 BUYAMOUNT = SUM(PAMTDEL),                         
 SELLQTY = SUM(SQTYDEL),                        
 SELLAVGRATE = (CASE WHEN SUM(SQTYDEL) <> 0 THEN SUM(SAMTDEL) / SUM(SQTYDEL) ELSE 0 END),                        
 SELLAMOUNT = SUM(SAMTDEL),                        
 NETQTY = SUM(PQTYDEL) - SUM(SQTYDEL),                        
 NETAVGRATE = (CASE WHEN (SUM(PQTYDEL) - SUM(SQTYDEL)) <> 0 THEN ABS((SUM(SAMTDEL)-SUM(PAMTDEL))/(SUM(PQTYDEL) - SUM(SQTYDEL))) ELSE 0 END),                        
 NETAMT = SUM(SAMTDEL)-SUM(PAMTDEL),                        
 FLAG = 1,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with(NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SCRIP_CD,                         
	SERIES,                        
	SETT_NO,                        
	SETT_TYPE                        
HAVING                        
	SUM(PQTYDEL) - SUM(SQTYDEL) <> 0                         
	OR SUM(SAMTDEL)-SUM(PAMTDEL) <> 0                        

UNION                        
                        
SELECT                         
 EXCHANGE = 'NSE CASH',                        
 TRDTYPE = '3. LEV',                         
 PARTY_CODE = P.PARENTCODE,                        
 TRADEDATE = CONVERT(VARCHAR,SAUDA_DATE,103),                        
 SCRIP_CD = 'ZZZZZZZZZZZZ',                         
 SCRIP_NAME = '** LEVIES **',                        
 SETT_NO,                        
 SETT_TYPE,                        
 BUYQTY = 0,                         
 BUYAVGRATE = 0,                        
 BUYAMOUNT = 0,                         
 SELLQTY = 0,                        
 SELLAVGRATE = 0,                        
 SELLAMOUNT = 0,                        
 NETQTY = 0,                        
 NETAVGRATE = 0,                        
 NETAMT = (SUM(SERVICE_TAX) + SUM(TURN_TAX)  + SUM(SEBI_TAX) + SUM(INS_CHRG) + SUM(BROKER_CHRG) + SUM(OTHER_CHRG)) * -1,            
 FLAG = 2,
 LONG_NAME='',
 BRANCH_CD='',
 SUB_BROKER='',
 L_ADDRESS1='',
 L_ADDRESS2='',
 L_ADDRESS3='',
 L_CITY='',
 L_STATE='',
 L_ZIP='',
 MOBILE_PAGER='',
 RES_PHONE1='',
 RES_PHONE2='',
 OFF_PHONE1=''
FROM 
	AngelNseCM.MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),
	#PARTY P (NOLOCK)
WHERE 
	C.PARTY_CODE = P.PARTY_CODE
	AND SAUDA_DATE >= @FROMDATE
	AND SAUDA_DATE <= @TODATE + ' 23:59:59'
	AND SETT_TYPE = (CASE WHEN @SETT_TYPE = '%' THEN C.SETT_TYPE ELSE @SETT_TYPE END)
	AND C.SETT_TYPE NOT IN ('A','X')
GROUP BY
	P.PARENTCODE,
	CONVERT(VARCHAR,SAUDA_DATE,103),                        
	SETT_NO,                        
	SETT_TYPE                                              

-------------------------------                        
-- COMPLETED CALCULATION --                        
-------------------------------                        
                    
UPDATE 
	#CLASSTBL_SAUDASUMMARY
SET 
	LONG_NAME	= C1.LONG_NAME,
	BRANCH_CD	= C1.BRANCH_CD,
	SUB_BROKER	= C1.SUB_BROKER,
	L_ADDRESS1	= C1.L_ADDRESS1,
	L_ADDRESS2	= C1.L_ADDRESS2,
	L_ADDRESS3	= C1.L_ADDRESS3,
	L_CITY		= C1.L_CITY,
	L_STATE		= C1.L_STATE,
	L_ZIP		= C1.L_ZIP,
	MOBILE_PAGER= C1.MOBILE_PAGER,
	RES_PHONE1	= C1.RES_PHONE1,
	RES_PHONE2	= C1.RES_PHONE2,
	OFF_PHONE1	= C1.OFF_PHONE1
FROM
	AngelBSECM.PRADNYA.DBO.TBL_ECNCASH C1 (NOLOCK)
WHERE
	#CLASSTBL_SAUDASUMMARY.PARTY_CODE = C1.PARTY_CODE


SELECT                         
	EXCHANGE,
	TRDTYPE,
	PARTY_CODE,
	TRADEDATE,
	SCRIP_CD,
	SCRIP_NAME,
	SETT_NO,
	SETT_TYPE,
	BUYQTY,
	BUYAVGRATE,
	BUYAMOUNT,
	SELLQTY,
	SELLAVGRATE,
	SELLAMOUNT,
	NETQTY,
	NETAVGRATE,
	NetAmount,
	FLAG,
	LONG_NAME,          
	BRANCH_CD,          
	SUB_BROKER,          
	L_ADDRESS1,          
	L_ADDRESS2,          
	L_ADDRESS3,          
	L_CITY,          
	L_STATE,          
	L_ZIP,          
	MOBILE_PAGER,          
	RES_PHONE1,          
	RES_PHONE2,          
	OFF_PHONE1          
FROM            
	#CLASSTBL_SAUDASUMMARY (NOLOCK)
ORDER BY                        
	PARTY_CODE,                        
	EXCHANGE,                        
	SETT_NO,                        
	SETT_TYPE,                        
	FLAG,                        
	SCRIP_NAME,                        
	TRDTYPE                        
                        
--TRUNCATE TABLE #CLASSTBL_SAUDASUMMARY        
                        
--DROP TABLE #CLASSTBL_SAUDASUMMARY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_ADMIN_GET_EXCHANGE_SEGMENT
-- --------------------------------------------------

create PROC [dbo].[CLS_ADMIN_GET_EXCHANGE_SEGMENT]  
AS  
SELECT EXCHANGE, SEGMENT, DISPLAY = EXCHANGE + ' ' + SEGMENT FROM PRADNYA..MULTICOMPANY WHERE PRIMARYSERVER = 1 ORDER BY 3

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
-- PROCEDURE dbo.CLS_ENTITY_FILTER_WRAPPER
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CLS_ENTITY_FILTER_WRAPPER]
(
 @SEARCHSTR VARCHAR(20),
 @SEARCHSTR_TO VARCHAR(20),
 @EXCHANGE VARCHAR(3),
 @SEGMENT VARCHAR(10),        
 @STATUSID VARCHAR(25),          
 @STATUSNAME VARCHAR(25),          
 @SEARCHWHAT VARCHAR(20) = 'CLIENT'
)          
AS

DECLARE
	@@SQL VARCHAR(MAX),
	@@SHAREDB VARCHAR(30)

	SELECT @@SHAREDB = SHAREDB FROM CLS_MULTICOMPANY WHERE EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT

	SET @@SQL = "EXEC " + @@SHAREDB + "..CLS_ENTITY_FILTER '" + @STATUSID + "','" + @STATUSNAME + "','" + @SEARCHWHAT + "','" + @SEARCHSTR + "', '" + @SEARCHSTR_TO + "'"
	PRINT @@SQL
	EXEC(@@SQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_F2CONFIG_WRAPPER
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_F2CONFIG_WRAPPER] (  
 @F2CODE VARCHAR(10)  
 ,@F2PARAMS VARCHAR(500)  
 ,@F2WHFLDS VARCHAR(1000) = ''  
 ,@F2WHVALS VARCHAR(1000) = ''  
 ,@F2WHOPR VARCHAR(100) = ''  
 ,@ENTITY VARCHAR(100)  
 ,@ENTITY_LIST VARCHAR(1000)  
 ,@WINDOWTITLE VARCHAR(100) = '' OUTPUT  
 ,@TABLEHEADER VARCHAR(200) = '' OUTPUT  
 )  
AS  
 

  

BEGIN  

DECLARE
	@TABLEHEADERNAME VARCHAR(MAX)
	
SELECT @TABLEHEADERNAME = TABLEHEADER FROM CLS_F2CONFIG WHERE F2CODE = @F2CODE


DECLARE
	@@SQLTABLE VARCHAR(MAX)
	
CREATE TABLE #TBLPARTY_DETAILS_TEMP
(
	SRNO INT IDENTITY(1, 1)
)	
	
SET @@SQLTABLE = "ALTER TABLE #TBLPARTY_DETAILS_TEMP ADD "
SET @@SQLTABLE  = @@SQLTABLE + REPLACE(REPLACE(@TABLEHEADERNAME,' ','_'), ',', ' VARCHAR(1000),') + " VARCHAR(1000)"


EXEC (@@SQLTABLE)

ALTER TABLE #TBLPARTY_DETAILS_TEMP DROP COLUMN SRNO


	
 /*CREATE TABLE #TBLPARTY_DETAILS_TEMP (  
  PARTY_CODE VARCHAR(100)  
  ,PARTY_NAME VARCHAR(100)  
  )*/  
  
 CREATE TABLE #ENTITYLIST_TEMP (ENTITY VARCHAR(100))  
  
 DECLARE @ENTITY1 VARCHAR(50)  
  
 SET @ENTITY1 =.dbo.cls_piece(@F2PARAMS, '|', 7)  
  
 INSERT INTO #TBLPARTY_DETAILS_TEMP /*(  
  PARTY_CODE  
  ,PARTY_NAME  
  )  */
 EXEC [CLS_PROC_F2CONFIG] @F2CODE  
  ,@F2PARAMS  
  ,@F2WHFLDS  
  ,@F2WHVALS  
  ,@F2WHOPR  
  ,0  
  ,@WINDOWTITLE OUTPUT  
  ,@TABLEHEADER OUTPUT  
  
	--print 'safd1'
 IF @ENTITY_LIST = 'ALL'  
  OR @ENTITY = 'PARTY'  
  OR @ENTITY1 <> 'PARTY'  OR @ENTITY1 IS NULL
   
 BEGIN  
  SELECT  DISTINCT *
  FROM #TBLPARTY_DETAILS_TEMP  
 END  
 ELSE  
 BEGIN  
  INSERT INTO #ENTITYLIST_TEMP (ENTITY)  
  SELECT MSAJAG.DBO.cls_PIECE(ITEMS, '-', 1)  
  FROM MSAJAG.DBO.CLS_SPLIT(@ENTITY_LIST, '|')  
  

  DECLARE @@SQL VARCHAR(MAX)  
  
  SET @@SQL = ""  
  SET @@SQL = @@SQL + "SELECT T.* FROM #TBLPARTY_DETAILS_TEMP T, MSAJAG.DBO.CLIENT_DETAILS C, #ENTITYLIST_TEMP E "  
  SET @@SQL = @@SQL + "WHERE T.PARTY_CODE = C.CL_CODE "  
  SET @@SQL = @@SQL + "AND CASE '" + @ENTITY + "' WHEN 'AREA' THEN C.AREA "  
  SET @@SQL = @@SQL + "WHEN 'REGION' THEN C.REGION "  
  SET @@SQL = @@SQL + "WHEN 'BRANCH' THEN C.BRANCH_CD "  
  SET @@SQL = @@SQL + "WHEN 'SUBBROKER' THEN C.SUB_BROKER "  
  SET @@SQL = @@SQL + "WHEN 'TRADER' THEN C.TRADER "  
  SET @@SQL = @@SQL + "WHEN 'FAMILY' THEN C.FAMILY "  
  SET @@SQL = @@SQL + "WHEN 'PARTY' THEN C.PARTY_CODE "  
  SET @@SQL = @@SQL + "ELSE '' END IN (E.ENTITY) "  
  
  PRINT @@SQL  
  
  EXEC (@@SQL)  
 END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GET_BILL_PATH
-- --------------------------------------------------


CREATE PROC [dbo].[CLS_GET_BILL_PATH]      
(      
 @EXCHANGE VARCHAR(3),      
 @SEGMENT VARCHAR(25),      
 @SHAREDB VARCHAR(25),      
 @ACCDB VARCHAR(25),      
 @BILLDT VARCHAR(11),      
 @NARRATION VARCHAR(500)  -- THIS PARAMETER IS USING AS VNO
     
)      
      
AS      
DECLARE @@SQL AS VARCHAR(MAX),    
		@@SEGMENT VARCHAR(25),      
		@@EXCHANGE VARCHAR(3)
/*      
 SELECT CNT = COUNT(*) INTO #CHK FROM ACCOUNT.SYS.OBJECTS WHERE NAME = 'BILLPOSTED'       
 SELECT * FROM ACCOUNT..BILLPOSTED        
 SELECT * FROM #CHK   
 CLS_GET_BILL_PATH 'nse','capital','msajag','account','Apr  6 2018','201804000027'   
 
 SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 103),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL FROM 
 account .DBO.BILLPOSTED BP, ACCOUNT.DBO.CLS_PLDETAIL PL 
  WHERE  PL.EXCHANGE = 'nse'  AND PL.SEGMENT = 'capital'  AND BP.VTYP = PL.VTYPE   AND BP.VNO = '201804000027' 
  /* AND BP.SETT_TYPE = PL.SETTTYPE */AND FLAG = 'Y'
 
*/
 SELECT @NARRATION  = [dbo].[CLS_PIECE](@NARRATION,'~',1)


--SELECT [dbo].[CLS_PIECE]('dddd!dddd','!',1)

SET @@SEGMENT = ''
SET @@EXCHANGE = ''
CREATE TABLE #CHK(NAME VARCHAR(50))
CREATE TABLE #EXCHANGE(EXCHANGE VARCHAR(3), SEGMENT VARCHAR(25))

SET @@SQL = " INSERT INTO #CHK SELECT NAME FROM " + @ACCDB + ".SYS.OBJECTS WHERE NAME = 'BILLPOSTED' "
PRINT @@SQL
EXEC (@@SQL)

IF (SELECT		COUNT(1)	FROM #CHK)> 0 BEGIN
IF @EXCHANGE = 'NSE' AND @SEGMENT = 'CAPITAL' BEGIN
print 'aa'
SET @@SQL = ""
SET @@SQL = @@SQL + " INSERT INTO #EXCHANGE SELECT  EXCHANGE, SEGMENT FROM " + @ACCDB + ".DBO.BILLPOSTED A, CLS_SETT_MASTER_COMMON B WHERE A.SETT_NO = B.SETT_NO AND A.SETT_TYPE = B.SETT_TYPE AND A.VNO =  '" + @NARRATION + "' "
EXEC (@@SQL)
PRINT @@SQL
SELECT
	@@EXCHANGE = EXCHANGE
	,@@SEGMENT = SEGMENT
FROM #EXCHANGE
END ELSE BEGIN
SELECT
	@@EXCHANGE = @EXCHANGE
	,@@SEGMENT = @SEGMENT
END
IF (@SEGMENT = 'CAPITAL') BEGIN
SET @@SQL = ""
SET @@SQL = @@SQL + " SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 103),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL, EXCHANGE  = '" + @EXCHANGE + "', SEGMENT = '" + @@SEGMENT + "' FROM " + @ACCDB + " .DBO.BILLPOSTED BP, ACCOUNT.DBO.CLS_PLDETAIL PL "
SET @@SQL = @@SQL + " WHERE "
SET @@SQL = @@SQL + " PL.EXCHANGE = '" + @EXCHANGE + "' "
SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "
SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "
END ELSE BEGIN
SET @@SQL = ""
SET @@SQL = @@SQL + " SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 103),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL, EXCHANGE  = '" + @@EXCHANGE + "', SEGMENT = '" + @@SEGMENT + "' FROM " + @ACCDB + " .DBO.BILLPOSTED BP, ACCOUNT.DBO.CLS_PLDETAIL PL "
SET @@SQL = @@SQL + " WHERE "
SET @@SQL = @@SQL + " PL.EXCHANGE = '" + @EXCHANGE + "' "
SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "
SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "

END
IF @SEGMENT <> 'FUTURES' AND 1 = 2 BEGIN
SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE "
END
SET @@SQL = @@SQL + "  AND BP.VNO = '" + @NARRATION + "' "
SET @@SQL = @@SQL + "/* AND BP.SETT_TYPE = PL.SETTTYPE */AND FLAG = 'Y'"


PRINT @@SQL
EXEC (@@SQL)
END
DROP TABLE #CHK

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GET_SETTING
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_GET_SETTING] 
@RPTCODE VARCHAR(25) = ''
AS
SELECT * FROM CLS_PDF_SETTING WHERE FLDREPORTCODE LIKE @RPTCODE + '%'
SELECT * FROM CLS_PDFCSS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_F2CONFIG
-- --------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
CREATE PROC [dbo].[CLS_PROC_F2CONFIG]    
(    
  @F2CODE VARCHAR(10),          
  @F2PARAMS VARCHAR(500),          
  @F2WHFLDS VARCHAR(1000) = '',          
  @F2WHVALS VARCHAR(1000) = '',          
  @F2WHOPR VARCHAR(100) = '',          
  @USEXML BIT = 0,              
  @WINDOWTITLE VARCHAR(100) = '' OUTPUT,          
  @TABLEHEADER VARCHAR(200) = '' OUTPUT        
     
)    
AS    
--EXEC .dbo.PROC_F2CONFIG 'F000000002','IN','','','',0,'TITLE','TAB'    

--SELECT * FROM F2CONFIG   
/*
declare @p8 varchar(100)
set @p8='CODE'
declare @p9 varchar(200)
set @p9='CODE,DESCRIPTION'
exec Pradnya..CLS_F2CONFIG_WRAPPER @F2CODE='F000000077',@F2PARAMS='1|||T|%',@F2WHFLDS='EXCHANGE,',@F2WHVALS='NSE,',@F2WHOPR='=,',@ENTITY='',@ENTITY_LIST='',@WINDOWTITLE=@p8 output,@TABLEHEADER=@p9 output
select @p8, @p9



SELECT  DISTINCT CONVERT(VARCHAR,TABLE_NO)TABLE_NO,UPPER(TABLE_NAME) FROM Msajag..BRANCHBROKTABLE WHERE 1 = 1  AND TABLE_NO LIKE '1' + '%'  
AND EXCHANGE = 'NSE' + ''  
AND SEGMENT = 'CAPITAL' + ''  AND TABLE_TYPE = 'T' + ''  ORDER BY TABLE_NO

*/
 
SET NOCOUNT ON          
DECLARE          
 @OBJID INT,          
 @OBJNAME VARCHAR(256),          
 @OBJTYPE VARCHAR(1),          
 @DATABASENAME VARCHAR(256),          
 @PARAMFIELDS VARCHAR(500),          
 @OBJECTOUT VARCHAR(500),          
 @PARAMCUR CURSOR,          
 @PARAMPOS TINYINT,          
 @PARAMNAME VARCHAR(60),          
 @PARAMVAL VARCHAR(500),          
 @PARAMOPR VARCHAR(8),          
 @PARAMOPRLIST VARCHAR(100),          
 @ORDERLIST VARCHAR(100),          
 @CONNECTIONDB VARCHAR(1),          
 @SQL NVARCHAR(MAX),          
 @DBNAME VARCHAR(256),    
 @SCHEMA_NAME VARCHAR(50)    
 SET @SCHEMA_NAME = (SELECT SCHEMA_NAME())    
 SET @DBNAME = ''          
       
BEGIN TRY        
 SELECT          
  @OBJNAME = F2OBJECT,          
  @OBJTYPE = F2OBJECTTYPE,          
  @OBJECTOUT = ISNULL(F2OUTPUT, ''),          
  @PARAMFIELDS = ISNULL(F2PARAMFIELDS, ''),          
  @PARAMOPRLIST = ISNULL(F2OPRLIST, ''),          
  @ORDERLIST = ISNULL(F2ORDERLIST, ''),          
  @DATABASENAME = ISNULL(DATABASENAME, ''),          
  @WINDOWTITLE = ISNULL(WINDOWTITLE, 'HELP LIST'),          
  @TABLEHEADER = ISNULL(TABLEHEADER, ''),          
  @CONNECTIONDB = ISNULL(CONNECTIONDB, '')          
 FROM          
  CLS_F2CONFIG          
 WHERE          
  F2CODE = @F2CODE   
  
  
  
  IF @OBJTYPE = 'T' or @OBJTYPE = 'P'
  BEGIN
	  DECLARE
		@@PATIDX INT,
		@EXCHANGE VARCHAR(3),
		@SEGMENT VARCHAR(7)
	  
	  SELECT @@PATIDX = PATINDEX('%|FUTURES|%', @F2PARAMS)
	  
	  IF @@PATIDX > 0
	  BEGIN
		SELECT @SEGMENT = SUBSTRING (@F2PARAMS, PATINDEX('%|FUTURES|%', @F2PARAMS) + 1, 7)

		SELECT @EXCHANGE = SUBSTRING (@F2PARAMS, PATINDEX('%|FUTURES|%', @F2PARAMS) - 3, 3)
	  END
	  
	  IF @@PATIDX < 1
	  BEGIN
		  SELECT @@PATIDX = PATINDEX('%|CAPITAL|%', @F2PARAMS)
		  
		  IF @@PATIDX > 0
		  BEGIN
			SELECT @SEGMENT = SUBSTRING (@F2PARAMS, PATINDEX('%|CAPITAL|%', @F2PARAMS) + 1, 7)

			SELECT @EXCHANGE = SUBSTRING (@F2PARAMS, PATINDEX('%|CAPITAL|%', @F2PARAMS) - 3, 3)
		  END
		END
			
		  
		DECLARE @STRSHAREDB VARCHAR(30)
		SET @STRSHAREDB = ''
		SELECT TOP 1 @STRSHAREDB = SHAREDB FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT

		DECLARE @STRACCDB VARCHAR(30)
		SET @STRACCDB = ''
		SELECT TOP 1 @STRACCDB = AccountDb FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT


	END

IF @CONNECTIONDB = ''
	SET @DATABASENAME = @DATABASENAME
else IF @STRSHAREDB <> '' AND @CONNECTIONDB <> 'A'
    SET @DATABASENAME = @STRSHAREDB
ELSE IF @EXCHANGE <> '' AND @SEGMENT <> ''
	SET @DATABASENAME = @STRACCDB
 

 
 IF @OBJTYPE = 'T' OR @OBJTYPE = 'V'          
  BEGIN          
  
  -- SET @OBJNAME = @MULTISERVER + @OBJNAME          
   SET @SQL = "SELECT  " + @OBJECTOUT + " FROM "+ @DATABASENAME + ".." + @OBJNAME + " WHERE 1 = 1 "          
   IF LEN(@PARAMFIELDS) > 0          
    BEGIN          
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .dbo.CLS_Piece(@PARAMFIELDS, ',', @PARAMPOS)          
       IF @PARAMNAME = '' OR @PARAMNAME IS NULL          
        BEGIN          
					BREAK          
        END    
       SET @PARAMVAL = .dbo.CLS_Piece(@F2PARAMS, '|', @PARAMPOS)          
       SET @PARAMOPR = .dbo.CLS_Piece(@PARAMOPRLIST, ',', @PARAMPOS)          
       SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE @PARAMOPR END) + " '" + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' THEN '%' ELSE '' END) + "' "          
       SET @PARAMPOS = @PARAMPOS + 1          
      END          
    END          
   IF LEN(@F2WHFLDS) > 0          
    BEGIN   
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .dbo.CLS_Piece(@F2WHFLDS, ',', @PARAMPOS)       
			 IF @PARAMNAME IS NULL          
        BEGIN          
         BREAK          
        END          
       IF CHARINDEX('~',@PARAMNAME) > 0    
       BEGIN   
			 SET @PARAMNAME = REPLACE(@PARAMNAME, '~', ',')    
       END  
       SET @PARAMVAL = .dbo.CLS_Piece(@F2WHVALS, ',', @PARAMPOS)          
       SET @PARAMOPR = .dbo.CLS_Piece(@F2WHOPR, ',', @PARAMPOS)    
			 SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE CASE WHEN @PARAMOPR = 'NL' THEN ' NOT LIKE ' ELSE @PARAMOPR END END) + " '" + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '%' ELSE '' END) + "' "          
       SET @PARAMPOS = @PARAMPOS + 1          
      END          
    END          
   IF LEN(@ORDERLIST) > 0          
    BEGIN          
     SET @SQL = @SQL + " ORDER BY " + @ORDERLIST          
    END          
   ELSE          
    BEGIN          
     SET @SQL = @SQL + " ORDER BY 1 "          
    END          
   IF @USEXML = 1          
    BEGIN          
     SET @SQL = @SQL + " FOR XML AUTO "          
    END          
   PRINT @SQL          
   EXEC(@SQL)          
  END        
 ELSE IF @OBJTYPE = 'P'          
  BEGIN          
  print 'p'       
   CREATE TABLE #PARANAMES (PARANAME VARCHAR(256))          
   IF @DATABASENAME <> ''          
    BEGIN          
	 SET @SQL = "SELECT NAME INTO #PARAMTEMP FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')   order by colorder"  		
     --SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')  "          
	 SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM #PARAMTEMP "
     print @SQL        
     EXEC (@SQL)          
     SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES          
    END   
   
   --ELSE          
   -- IF @MULTISERVER <> ''          
   --  BEGIN         
   --   SET @DATABASENAME = @MULTISERVER          
   --   SET @SQL = "INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @MULTISERVER + "SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @MULTISERVER + "SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P')"          
   --   --PRINT @SQL           
   --   EXEC (@SQL)          
   --   SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES          
   --  END          
    ELSE          
     BEGIN   
	  
     print 'C'             
      SET @PARAMCUR = CURSOR FOR SELECT NAME FROM SYSCOLUMNS WHERE ID = (SELECT ID FROM SYSOBJECTS WHERE NAME = @OBJNAME AND XTYPE = 'P')          
     END          
               
   OPEN @PARAMCUR  
   print 'D'               
   FETCH NEXT FROM @PARAMCUR INTO @PARAMFIELDS          
   SET @SQL = ''      
       
   SET @PARAMPOS = 1          
   WHILE @@FETCH_STATUS = 0          
    BEGIN          
     SET @PARAMVAL = .dbo.CLS_Piece(@F2PARAMS, '|', @PARAMPOS)          
     IF @PARAMVAL IS NULL          
      BEGIN          
       SET @SQL = @SQL + @PARAMFIELDS + "=NULL,"          
      END        
     ELSE          
      BEGIN          
       SET @SQL = @SQL + @PARAMFIELDS + "='" + @PARAMVAL + "',"          

      END          
     SET @PARAMPOS = @PARAMPOS + 1          
     FETCH NEXT FROM @PARAMCUR INTO @PARAMFIELDS          
    END          
   print @SQL        
   IF LEN(@SQL) > 0          
    BEGIN         
    
     SET @SQL = @DATABASENAME + '..' + @OBJNAME + ' ' + SUBSTRING(@SQL, 1, LEN(@SQL)-1)          
    END          
   ELSE          
    BEGIN          
     SET @SQL = @DATABASENAME + '..' + @OBJNAME          
    END          
      EXEC SP_EXECUTESQL @SQL          
   print @SQL         
  END          
    
    
END TRY          
BEGIN CATCH          
  DECLARE @ERRMSG VARCHAR(1000)          
  SET @ERRMSG = ERROR_MESSAGE()          
  RAISERROR(@ERRMSG, 16, 1)          
END CATCH     
    
--COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_SP_SETUP
-- --------------------------------------------------

--SELECT * FROM ACMAST WHERE acname like 'BANK%'
CREATE PROC [dbo].[CLS_SP_SETUP]
@EXCHSEG VARCHAR(30) = '',
@REASON VARCHAR(1000) = ''
AS

DECLARE @@SQL VARCHAR(8000)

IF NOT EXISTS(
	SELECT 1 
	FROM 
		SYSOBJECTS,
		SYSCOLUMNS 
	WHERE 
	SYSOBJECTS.ID = SYSCOLUMNS.ID 
	AND SYSOBJECTS.NAME = 'CLS_SETUP')
BEGIN
	CREATE TABLE CLS_SETUP
	(
		ID INT identity(1,1),
		SEG_DESC VARCHAR(50),
		EXCHANGE VARCHAR(3),
		SEGMENT VARCHAR(20),
		CONNECTION VARCHAR(10),
		REASON varchar(1000),
		PRODUCT_DETAILS tinyint,
		TEMPCLEANER_DETAILS tinyint,
		FLAG tinyint,
	)
END 

INSERT INTO CLS_SETUP
SELECT SEGMENT_DESCRIPTION, EXCHANGE, SEGMENT,CONNECTION = '',REASON = '',0,0,0 FROM CLS_MULTICOMPANY WHERE PRIMARYSERVER = 1 AND EXCHANGE + '-' + SEGMENT NOT IN (SELECT EXCHANGE + '-' + SEGMENT FROM CLS_SETUP) 

IF @EXCHSEG != ''
 BEGIN 
	UPDATE CLS_SETUP SET CONNECTION = CASE WHEN @REASON = '' THEN UPPER('PASSED') ELSE UPPER('FAILED') END, REASON = @REASON, FLAG = CASE WHEN @REASON = '' THEN 1 ELSE 9 END WHERE EXCHANGE + '-' + SEGMENT = @EXCHSEG
 END 
 
UPDATE CLS_SETUP SET PRODUCT_DETAILS = CASE WHEN (SELECT COUNT(*) FROM MSAJAG..CLS_PRODUCT_VERSION) > 0 THEN 1 ELSE 0 END 
UPDATE CLS_SETUP SET TEMPCLEANER_DETAILS = CASE WHEN (SELECT COUNT(*) FROM PRADNYA..CLS_TEMP_CLEANER) > 0 THEN 1 ELSE 0 END
UPDATE CLS_SETUP SET FLAG = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- --------------------------------------------------
CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FN
-- --------------------------------------------------
  
CREATE PROC FN @FUN VARCHAR(25)AS             
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @FUN + '%' AND XTYPE='FN' ORDER BY NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_EXCHANGE_SEGMENT
-- --------------------------------------------------

CREATE PROC [dbo].[GET_EXCHANGE_SEGMENT]
AS
SELECT EXCHANGE, SEGMENT, EXCHANGE + ' ' + SEGMENT FROM PRADNYA..MULTICOMPANY WHERE PRIMARYSERVER = 1 ORDER BY 3

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_EXCHANGE_SEGMENT_04102012
-- --------------------------------------------------
  
CREATE PROC [dbo].[GET_EXCHANGE_SEGMENT_04102012]  
AS  
SELECT EXCHANGE, SEGMENT, EXCHANGE + ' ' + SEGMENT FROM PRADNYA..MULTICOMPANY WHERE PRIMARYSERVER = 1 ORDER BY 3

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_STATISTICS
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NseAccValan
-- --------------------------------------------------

CREATE Proc NseAccValan (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As         
        
Declare @Service_Tax Numeric(18,4)        
        
Select @Service_Tax= Service_Tax From Globals G, Sett_Mst S        
Where Sett_No = @Sett_no And Sett_Type = @Sett_Type         
And Year_Start_Dt <= Start_Date And Year_End_Dt >= End_Date        
        
--Select @Service_Tax        
        
--Delete From NseBillValan Where Sett_No = @Sett_No and Sett_Type = @Sett_Type         
truncate table NseBillValan  
Insert Into NseBillValan         
select s.party_code,S.Scrip_Cd,sell_buy,pamt =           
isnull((case when sell_buy = 1 then           
 ( case when  Service_chrg = 2 then          
   sum(tradeqty * (N_NetRate))           
 else            
   sum(tradeqty *  (N_NetRate) +  NSertax)           
 end ) + ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Turnover_tax = 1 THEN          
    SUM(turn_tax)           
     else 0 end )            
    else 0 end )          
         + (CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Sebi_Turn_tax = 1 THEN          
    SUM(Sebi_Tax)           
     else 0 end )            
    else 0 end )          
         + ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Insurance_Chrg = 1 THEN          
    SUM(Ins_chrg)           
     else 0 end )            
    else 0 end )          
   + ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Brokernote = 1 THEN          
    SUM(Broker_chrg)           
     else 0 end )            
    else 0 end )          
  + ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN c2.Other_chrg = 1 OR AuctionPart Like 'F%' THEN          
    SUM(S.other_chrg)           
     else 0 end )            
    else 0 end )          
end),0),          
samt = isnull((case when sell_buy = 2 then           
 ( case when  Service_chrg = 2 then          
   sum(tradeqty *  (N_NetRate) )           
 else            
   sum(tradeqty *  (N_NetRate) - NSertax)           
 end ) - ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Turnover_tax = 1 THEN          
    SUM(turn_tax)           
     else 0 end )            
    else 0 end )          
         - ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Sebi_Turn_tax = 1 THEN          
    SUM(Sebi_Tax)           
     else 0 end )            
    else 0 end )          
         - ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Insurance_Chrg = 1 THEN          
    SUM(Ins_chrg)           
     else 0 end )            
    else 0 end )          
  - ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN Brokernote = 1 THEN          
    SUM(Broker_chrg)           
     else 0 end )            
    else 0 end )          
  - ( CASE WHEN dispcharge = 1 THEN          
   ( CASE WHEN c2.Other_chrg = 1 OR AuctionPart Like 'F%' THEN          
    SUM(S.other_chrg)           
     else 0 end )            
    else 0 end )          
end),0),        
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy1) Else 0 End),          
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy1) Else 0 End),        
Brokerage = (Case When BillFlag in (2,3) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
                    Then (CASE WHEN Sum(NSertax)  = 0         
                               THEN Sum(TradeQty*NBrokapp)-Round(Sum(TradeQty*NBrokapp)*@Service_Tax/(100+@Service_Tax),2)        
                               ELSE Sum(TradeQty*NBrokapp)          
                         END )        
                   Else Sum(TradeQty*NBrokapp)         
              End) Else 0 End),        
        
DelBrokerage = (Case When BillFlag in (1,4,5) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
                       Then  (CASE WHEN Sum(NSertax)  = 0         
                                   THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)        
                                   ELSE Sum(TradeQty*NBrokApp)          
                             END )        
                       Else Sum(TradeQty*NBrokApp)         
                 End) Else 0 End) ,        
        
NSertax = (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)         
   ELSE Sum(NSertax) END )        
    Else Sum(NSertax) End),        
ExNSertax = (Case When Service_chrg = 2         
        Then Sum(NSertax)        
  Else 0         
   End),        
Turn_Tax = (Case WHEN dispcharge = 1         
   THEN (Case WHEN Turnover_tax = 1         
              THEN SUM(turn_tax)           
                 Else 0         
         End)            
          else 0         
     End ),        
Sebi_Tax = (Case WHEN dispcharge = 1         
   THEN (CASE WHEN Sebi_Turn_tax = 1         
              THEN SUM(Sebi_Tax)           
       Else 0         
         End)            
   Else 0         
     End),          
Ins_Chrg = (Case WHEN dispcharge = 1         
   THEN (CASE WHEN Insurance_Chrg = 1         
       THEN SUM(Ins_chrg)           
         Else 0         
         End)            
   Else 0         
     End),        
Broker_Chrg = (CASE WHEN dispcharge = 1         
      THEN (CASE WHEN Brokernote = 1         
          THEN SUM(Broker_chrg)           
                 Else 0         
            End)            
      Else 0         
        End),        
Other_Chrg = (CASE WHEN dispcharge = 1         
     THEN (CASE WHEN c2.Other_chrg = 1 Or AuctionPart Like 'F%'        
                THEN SUM(S.other_chrg)           
                Else 0         
           End)            
     Else 0         
       End),          
TrdAmt = Sum(TradeQty*S.MarketRate),         
DelAmt = (Case When BillFlag in (1,4,5)        
         Then Sum(TradeQty*S.MarketRate)        
        Else 0         
   End),         
sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType='N',        
PQty = (Case When Sell_Buy = 1 Then Sum(TradeQty) Else 0 End ),         
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ) ,0        
from settlement S, Client2 C2, OWNER,Client1          
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code          
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type         
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,        
Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,Cl_Type,BillFlag,C2.SerTaxMethod,AuctionPart          

  INSERT INTO NSEBILLVALAN      
  SELECT   S.CD_PARTY_CODE,      
           S.CD_SCRIP_CD,      
           SELL_BUY = 1,      
           PAMT = SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) + (CASE       
                                                                                                                WHEN SERVICE_CHRG <> 2 THEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX + CD_DELBUYSERTAX + CD_DELSELLSERTAX)      
                                                                                                                ELSE 0      
                                                                                                              END),      
           SAMT = 0,      
           PRATE = 0,      
           SRATE = 0,      
           BROKERAGE = (CASE       
                          WHEN C2.SERVICE_CHRG = 1      
                               AND C2.SERTAXMETHOD = 1 THEN (CASE       
                                                               WHEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX) = 0 THEN SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) - ROUND(SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),2)      
                                                               ELSE SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE)      
                              END)      
                          ELSE SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE)      
                        END),      
           DELBROKERAGE = (CASE       
                             WHEN C2.SERVICE_CHRG = 1      
                                  AND C2.SERTAXMETHOD = 1 THEN (CASE       
                                                                  WHEN SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX) = 0 THEN SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) - ROUND(SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),2)      
                                                                  ELSE SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE)      
                                                                END)      
                             ELSE SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE)      
                           END),      
           NSERTAX = (CASE       
                        WHEN C2.SERVICE_CHRG = 1      
                             AND C2.SERTAXMETHOD = 1 THEN (CASE       
                                                             WHEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX) = 0 THEN ROUND(SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),      
                                                                                                                         2)      
                                                             ELSE SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX)      
                                                           END)      
                        ELSE SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX)      
                      END) + (CASE       
                                WHEN C2.SERVICE_CHRG = 1      
                                     AND C2.SERTAXMETHOD = 1 THEN (CASE       
                                                                     WHEN SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX) = 0 THEN ROUND(SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),      
                                                                                                                                 2)      
                                                                     ELSE SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX)      
                                                                   END)      
                                ELSE SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX)      
                              END),      
           EXNSERTAX = (CASE       
                          WHEN SERVICE_CHRG = 2 THEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX + CD_DELBUYSERTAX + CD_DELSELLSERTAX)      
                          ELSE 0      
                        END),      
           TURN_TAX = 0,      
           SEBI_TAX = 0,      
           INS_CHRG = 0,      
           BROKER_CHRG = 0,      
           OTHER_CHRG = 0,      
           TRDAMT = 0,      
           DELAMT = 0,      
           CD_SETT_NO,      
           CD_SETT_TYPE,      
           BILLNO = 0,      
           BRANCH_CD,      
           CL_TYPE,      
           TRDTYPE = 'N',      
           PQTY = 0,      
           SQTY = 0,      
           0      
  FROM     CHARGES_DETAIL S,      
           CLIENT2 C2,      
           CLIENT1,      
           OWNER      
  WHERE    C2.PARTY_CODE = S.CD_PARTY_CODE      
           AND CLIENT1.CL_CODE = C2.CL_CODE      
           AND S.CD_SETT_NO = @SETT_NO      
           AND S.CD_SETT_TYPE = @SETT_TYPE      
  GROUP BY CD_SETT_NO,CD_SETT_TYPE,S.CD_PARTY_CODE,S.CD_SCRIP_CD,      
           SERVICE_CHRG,BRANCH_CD,CL_TYPE,SERTAXMETHOD,      
           CD_SERIES

Insert Into NseBillValan
select s.party_code,S.Scrip_Cd,sell_buy,pamt =           
isnull((case when sell_buy = 1 then           
 ( case when Service_chrg = 2 then          
   sum(tradeqty *  (NBrokapp) )           
 else            
  sum(tradeqty *  (NBrokApp) +  NSertax ) end )         
 + Sum(Case WHEN dispcharge = 1         
   THEN (CASE WHEN Insurance_Chrg = 1         
       THEN (Ins_chrg)           
            Else 0         
         End)            
   Else 0         
     End)        
end),0),        
samt =           
isnull((case when sell_buy = 2 then           
 ( case when Service_chrg = 2 then          
   sum(tradeqty *  (NBrokapp) )           
 else            
  sum(tradeqty *  (NBrokApp) + NSertax  )  end )         
 + Sum(Case WHEN dispcharge = 1         
   THEN (CASE WHEN Insurance_Chrg = 1         
       THEN (Ins_chrg)           
            Else 0         
         End)            
   Else 0         
     End)        
end),0),        
PRate = 0,        
SRate = 0,        
Brokerage = (Case when BillFlag in (2,3) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokapp)-Round(Sum(TradeQty*NBrokapp)*@Service_Tax/(100+@Service_Tax),2)        
   ELSE Sum(TradeQty*NBrokapp)  END )        
    Else Sum(TradeQty*NBrokapp) End) Else 0 End),        
DelBrokerage = (Case when BillFlag in (1,4,5) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
    Then  (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)        
   ELSE Sum(TradeQty*NBrokApp)  END )        
    Else Sum(TradeQty*NBrokApp) End) Else 0 End),        
NSertax = (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1         
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)         
   ELSE Sum(NSertax) END )        
    Else Sum(NSertax) End),        
ExNSertax = (Case When Service_chrg = 2       
        Then Sum(NSertax)        
        Else 0         
   End),        
Turn_Tax = 0,        
Sebi_Tax = 0,          
Ins_Chrg = Sum(Case WHEN dispcharge = 1         
   THEN (CASE WHEN Insurance_Chrg = 1         
       THEN (Ins_chrg)           
            Else 0         
         End)            
   Else 0         
     End),        
Broker_Chrg = 0,        
Other_Chrg = 0 ,        
TrdAmt = 0 ,         
DelAmt = 0,          
sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType='I',        
PQty = (Case When Sell_Buy = 1 Then Sum(TradeQty) Else 0 End ),         
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ),0 from ISettlement S, Client2 C2 ,Client1, Owner          
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code         
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type         
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,Branch_cd,Cl_Type,BillFlag,SerTaxMethod

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Offline
-- --------------------------------------------------
CREATE Proc Offline 
(
@flag tinyint
)

as

If @flag = 0 
begin
	Truncate Table Multicompany
	Insert into Multicompany
	Select * from MultiCompany_Backup
end
if @flag = 1
begin
	Truncate Table Multicompany
	Insert into Multicompany
	Select * from V2_offline_MultiCompany
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.POP_CONTRACTDATA
-- --------------------------------------------------
CREATE PROC POP_CONTRACTDATA(      
           @SETT_NO        VARCHAR(7),      
           @SETT_TYPE      VARCHAR(2),      
           @SAUDA_DATE     VARCHAR(11),      
           @FROMPARTY_CODE VARCHAR(10),      
           @TOPARTY_CODE   VARCHAR(10))      
AS      
      
  DECLARE  @ColName VARCHAR(6),      
           @SDT     DATETIME      
                          
  SELECT @SDT = CONVERT(DATETIME,@SAUDA_DATE)      
                      
  DELETE FROM CONTRACT_DATA      
  WHERE       SETT_NO = @SETT_NO      
              AND SETT_TYPE = @SETT_TYPE      
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                     AND @TOPARTY_CODE      
                                               
  DELETE FROM CONTRACT_DATA_DET      
  WHERE       SETT_NO = @SETT_NO      
              AND SETT_TYPE = @SETT_TYPE      
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                     AND @TOPARTY_CODE      
                                               
  DELETE FROM CONTRACT_MASTER      
  WHERE       SETT_NO = @SETT_NO      
              AND SETT_TYPE = @SETT_TYPE      
              AND PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                     AND @TOPARTY_CODE      
                                               
  TRUNCATE TABLE CONTRACT_DATA_TMP      
        
  SET NOCOUNT ON      
        
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED      
        
  SELECT CONTRACTNO,      
         BILLNO,      
         TRADE_NO,      
         PARTY_CODE,      
         SCRIP_CD,      
         TRADEQTY,      
         SERIES,      
         ORDER_NO,      
         MARKETRATE,      
         SAUDA_DATE,      
         SELL_BUY,      
         SETTFLAG,      
         BROKAPPLIED,      
         NETRATE,      
         AMOUNT,      
         INS_CHRG,      
         TURN_TAX,      
         OTHER_CHRG,      
         SEBI_TAX,      
         BROKER_CHRG,      
         SERVICE_TAX,      
         BILLFLAG,      
         SETT_NO,      
         NBROKAPP,      
         NSERTAX,      
         N_NETRATE,      
         SETT_TYPE,      
         TMARK,      
         CPID      
  INTO   #SETT      
  FROM   SETTLEMENT      
  WHERE  1 = 2      
        
  INSERT INTO #SETT      
  SELECT CONTRACTNO,      
         BILLNO,      
         TRADE_NO = '00000000000',      
         PARTY_CODE,      
         SCRIP_CD,      
         TRADEQTY,      
         SERIES,      
         ORDER_NO = '0000000000000000',      
         MARKETRATE,      
         SAUDA_DATE = LEFT(SAUDA_DATE,11),      
         SELL_BUY,      
         SETTFLAG,      
         BROKAPPLIED,      
         NETRATE,      
         AMOUNT,      
         INS_CHRG,      
         TURN_TAX,      
         OTHER_CHRG,      
         SEBI_TAX,      
         BROKER_CHRG,      
         SERVICE_TAX,      
         BILLFLAG,      
         SETT_NO,      
         NBROKAPP,      
         NSERTAX,      
         N_NETRATE,      
         SETT_TYPE,      
         TMARK,      
         CPID = '        '      
  FROM   SETTLEMENT      
  WHERE  SETT_NO = @SETT_NO      
         AND SETT_TYPE = @SETT_TYPE      
         AND SAUDA_DATE NOT LIKE @SAUDA_DATE + '%'      
         AND AUCTIONPART NOT IN ('AP','AR')      
         AND MARKETRATE > 0      
         AND PARTY_CODE >= @FROMPARTY_CODE      
         AND PARTY_CODE <= @TOPARTY_CODE      
                                 
  INSERT INTO #SETT      
  SELECT CONTRACTNO,      
         BILLNO,      
         TRADE_NO,      
         PARTY_CODE,      
         SCRIP_CD,      
         TRADEQTY,      
         SERIES,      
         ORDER_NO,      
         MARKETRATE,      
         SAUDA_DATE,      
         SELL_BUY,      
         SETTFLAG,      
         BROKAPPLIED,      
         NETRATE,      
         AMOUNT,      
         INS_CHRG,      
         TURN_TAX,      
         OTHER_CHRG,      
         SEBI_TAX,      
         BROKER_CHRG,      
         SERVICE_TAX,      
         BILLFLAG,      
         SETT_NO,      
         NBROKAPP,      
         NSERTAX,      
         N_NETRATE,      
         SETT_TYPE,      
         TMARK,      
         CPID      
  FROM   SETTLEMENT      
  WHERE  SETT_TYPE = @SETT_TYPE      
         AND SAUDA_DATE LIKE @SAUDA_DATE + '%'      
         AND AUCTIONPART NOT IN ('AP','AR')      
         AND MARKETRATE > 0      
         AND PARTY_CODE >= @FROMPARTY_CODE      
         AND PARTY_CODE <= @TOPARTY_CODE      
                                 
  DELETE FROM #SETT      
  WHERE       SAUDA_DATE > @SAUDA_DATE + ' 23:59:59'      
        
  CREATE INDEX [DELPOS] ON [DBO].[#SETT] (      
        [SETT_NO],      
        [SETT_TYPE],      
        [PARTY_CODE],      
        [SCRIP_CD],      
        [SERIES])      
        
  SELECT DISTINCT S2.SCRIP_CD,      
                  S2.SERIES,      
                  SHORT_NAME      
  INTO   #SCRIP      
  FROM   SCRIP1 S1,      
         SCRIP2 S2,      
         #SETT S      
  WHERE  S1.CO_CODE = S2.CO_CODE      
         AND S2.SERIES = S1.SERIES      
         AND S2.SCRIP_CD = S.SCRIP_CD      
         AND S2.SERIES = S.SERIES      
                               
  CREATE CLUSTERED INDEX [SCR] ON [DBO].[#SCRIP] (      
        [SCRIP_CD],      
        [SERIES])      
        
  /*=========================================================================                                          
                /*FOR THE #SETT*/         
                =========================================================================*/      
  SELECT C2.PARTY_CODE,      
         C1.LONG_NAME,      
         C1.L_ADDRESS1,      
         C1.L_ADDRESS2,      
         C1.L_ADDRESS3,      
         C1.L_CITY,      
         C1.L_STATE,      
         C1.L_ZIP,      
         C1.BRANCH_CD,      
         C1.SUB_BROKER,      
         C1.TRADER,      
         C1.AREA,      
         C1.REGION,      
         C1.FAMILY,      
         C1.PAN_GIR_NO,      
        OFF_PHONE1=(CASE WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0 AND LEN(OFF_PHONE1) = 0 AND LEN(OFF_PHONE2) = 0    
       THEN MOBILE_PAGER     
       WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0 AND LEN(OFF_PHONE1) = 0     
       THEN OFF_PHONE2     
       WHEN LEN(RES_PHONE1) = 0 AND LEN(RES_PHONE2) = 0     
       THEN OFF_PHONE1    
       WHEN LEN(RES_PHONE1) = 0    
       THEN RES_PHONE2    
       ELSE     
         RES_PHONE1    
     END),       
         C1.OFF_PHONE2,      
         PRINTF,      
         MAPIDID = CONVERT(VARCHAR(20),''),      
         UCC_CODE = CONVERT(VARCHAR(20),''),      
         C2.SERVICE_CHRG,      
         BROKERNOTE,      
         TURNOVER_TAX,      
         SEBI_TURN_TAX,      
         C2.OTHER_CHRG,      
         INSURANCE_CHRG,      
         SEBI_NO = FD_CODE,      
         PARTICIPANT_CODE = BANKID,      
         CL_TYPE      
  INTO   #CLIENTMASTER      
  FROM   CLIENT1 C1 WITH (NOLOCK),      
         CLIENT2 C2 WITH (NOLOCK)      
               
  WHERE  C2.CL_CODE = C1.CL_CODE      
         AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                   AND @TOPARTY_CODE      
         AND C2.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE      
                               FROM   #SETT)      
                                    
  CREATE CLUSTERED INDEX [PARTY] ON [DBO].[#CLIENTMASTER] (      
        [PARTY_CODE])      
        
  UPDATE #CLIENTMASTER      
  SET    MAPIDID = UC.MAPIDID,      
         UCC_CODE = UC.UCC_CODE      
  FROM   UCC_CLIENT UC      
  WHERE  #CLIENTMASTER.PARTY_CODE = UC.PARTY_CODE      
                                          
  INSERT INTO CONTRACT_DATA_TMP      
  SELECT CONTRACTNO,      
         S.PARTY_CODE,      
         ORDER_NO,      
         ORDER_TIME = (CASE       
                         WHEN CPID = 'NIL' THEN '        '      
                         ELSE RIGHT(CPID,8)      
                       END),      
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),      
         TRADE_NO,      
         SAUDA_DATE,      
         S.SCRIP_CD,      
         S.SERIES,      
         SCRIPNAME = (CASE       
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) <> @SAUDA_DATE THEN 'BF-'      
                        ELSE ''      
                      END) + S2.SHORT_NAME + '   ',      
         SDT = CONVERT(VARCHAR,@SDT,103),      
         SELL_BUY,      
         BROKER_CHRG = (CASE       
                          WHEN BROKERNOTE = 1 THEN BROKER_CHRG      
                          ELSE 0      
                        END),      
         TURN_TAX = (CASE       
                       WHEN TURNOVER_TAX = 1 THEN TURN_TAX      
              ELSE 0      
                     END),      
         SEBI_TAX = (CASE       
                       WHEN SEBI_TURN_TAX = 1 THEN SEBI_TAX      
                       ELSE 0      
                     END),      
         OTHER_CHRG = (CASE       
                         WHEN C1.OTHER_CHRG = 1 THEN S.OTHER_CHRG      
                         ELSE 0      
                       END),      
         INS_CHRG = (CASE       
                       WHEN INSURANCE_CHRG = 1 THEN INS_CHRG      
                       ELSE 0      
                     END),      
         SERVICE_TAX = (CASE       
                          WHEN SERVICE_CHRG = 0 THEN NSERTAX      
                          ELSE 0      
                        END),      
         NSERTAX = (CASE       
                      WHEN SERVICE_CHRG = 0 THEN NSERTAX      
                      ELSE 0      
                    END),      
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
         PQTY = (CASE       
 WHEN SELL_BUY = 1 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         SQTY = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         PRATE = (CASE       
                    WHEN SELL_BUY = 1 THEN MARKETRATE      
                    ELSE 0      
                  END),      
         SRATE = (CASE       
                    WHEN SELL_BUY = 2 THEN MARKETRATE      
                    ELSE 0      
                  END),      
         PBROK = (CASE       
                    WHEN SELL_BUY = 1 THEN NBROKAPP + (CASE       
                                                         WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                         ELSE 0      
                                                       END)      
                    ELSE 0      
                  END),      
         SBROK = (CASE       
                    WHEN SELL_BUY = 2 THEN NBROKAPP + (CASE       
                                                         WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                         ELSE 0      
                                                       END)      
                    ELSE 0      
                  END),      
         PNETRATE = (CASE       
                       WHEN SELL_BUY = 1 THEN N_NETRATE + (CASE       
                                                             WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                             ELSE 0      
                                                           END)      
                       ELSE 0      
                     END),      
         SNETRATE = (CASE       
                       WHEN SELL_BUY = 2 THEN N_NETRATE - (CASE       
                                                             WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                             ELSE 0      
                                                           END)      
                       ELSE 0      
                     END),      
         PAMT = (CASE       
                   WHEN SELL_BUY = 1 THEN TRADEQTY * (N_NETRATE + (CASE       
                                                                     WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                                     ELSE 0      
                                                        END))      
                   ELSE 0      
                 END),      
         SAMT = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY * (N_NETRATE - (CASE       
                                                                     WHEN SERVICE_CHRG = 1 THEN NSERTAX / TRADEQTY      
                                                                     ELSE 0      
                                                                   END))      
                   ELSE 0      
                 END),      
         BROKERAGE = TRADEQTY * NBROKAPP + (CASE       
                                              WHEN SERVICE_CHRG = 1 THEN NSERTAX      
                                              ELSE 0      
                                            END),      
         S.SETT_NO,      
         S.SETT_TYPE,      
         TRADETYPE = '  ',      
         TMARK = CASE       
                   WHEN BILLFLAG = 1      
                         OR BILLFLAG = 4      
                         OR BILLFLAG = 5 THEN 'D'      
                   ELSE ''      
                 END,      
         /*TO DISPLAY THE HEADER PART*/      
         PARTYNAME = C1.LONG_NAME,      
         C1.L_ADDRESS1,      
         C1.L_ADDRESS2,      
         C1.L_ADDRESS3,      
         C1.L_CITY,      
         C1.L_STATE,      
         C1.L_ZIP,      
         C1.SERVICE_CHRG,      
         C1.BRANCH_CD,      
         C1.SUB_BROKER,      
         C1.TRADER,      
         C1.PAN_GIR_NO,      
         C1.OFF_PHONE1,      
         C1.OFF_PHONE2,      
         PRINTF,      
         MAPIDID,      
         UCC_CODE,      
         ORDERFLAG = 0,      
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,      
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE       
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))      
                                         ELSE ''      
                                       END),52),      
         SEBI_NO,      
         PARTICIPANT_CODE,      
         ACTSELL_BUY = SELL_BUY,      
         ISIN = CONVERT(VARCHAR(12),''),      
         START_DATE = CONVERT(CHAR,(START_DATE),103),      
         END_DATE = CONVERT(CHAR,(END_DATE),103),      
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),      
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),      
         AREA,      
         REGION,      
         CL_TYPE,      
         FAMILY      
  FROM   #SETT S WITH (NOLOCK),      
         #CLIENTMASTER C1 WITH (NOLOCK),      
         SETT_MST M WITH (NOLOCK),      
         #SCRIP S2      
  WHERE  S.SETT_NO = @SETT_NO      
         AND S.SETT_TYPE = @SETT_TYPE      
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                  AND @TOPARTY_CODE      
         AND S.SETT_NO = M.SETT_NO      
         AND S.SETT_TYPE = M.SETT_TYPE      
         AND M.END_DATE LIKE @SAUDA_DATE + '%'      
         AND S2.SCRIP_CD = S.SCRIP_CD      
         AND S2.SERIES = S.SERIES      
         AND S.PARTY_CODE = C1.PARTY_CODE      
         AND S.TRADEQTY > 0      


UPDATE           
 CONTRACT_DATA_TMP          
SET          
 Brokerage = (Case When Sell_Buy =1       
     Then (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)      
     Else (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)      
       End)      
           + (Case When Service_Chrg = 1       
     Then Case When Sell_Buy =1       
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)      
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)      
   End          
            Else 0       
       End),          
 Service_Tax = (Case When Service_Chrg = 0       
     Then Case When Sell_Buy =1       
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)      
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)      
   End          
            Else 0       
       End),          
 NSerTax = (Case When Service_Chrg = 0       
     Then Case When Sell_Buy =1       
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)      
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)      
   End          
            Else 0       
       End),      
      
PAmt     = (Case When Sell_Buy =1       
     Then PAmt + (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)      
     Else 0      
       End)      
           + (Case When Service_Chrg = 1       
     Then Case When Sell_Buy =1       
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)      
        Else 0      
   End          
            Else 0       
       End),      
SAmt     = (Case When Sell_Buy = 2      
     Then SAmt - (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)      
     Else 0      
       End)      
           + (Case When Service_Chrg = 1       
     Then Case When Sell_Buy = 2      
        Then (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)      
        Else 0      
   End          
            Else 0       
       End)           
FROM          
 CHARGES_DETAIL          
WHERE          
 CD_Sett_No = CONTRACT_DATA_TMP.Sett_No        
 And CD_Sett_Type = CONTRACT_DATA_TMP.Sett_Type        
 And CD_Party_Code = CONTRACT_DATA_TMP.Party_Code           
 And CD_Scrip_Cd = CONTRACT_DATA_TMP.Scrip_Cd        
 And CD_Series = CONTRACT_DATA_TMP.Series        
 And CD_Trade_No = Trade_No          
 And CD_Order_No = Order_No  
  
        INSERT     
        INTO    CONTRACT_DATA_TMP  
  
 SELECT  CONTRACTNO='0',           
                S.CD_PARTY_CODE,           
   CD_ORDER_NO,           
                ORDER_TIME='',           
                TM='',           
                TRADE_NO='',           
                CD_SAUDA_DATE,           
                S.CD_SCRIP_CD,           
                S.CD_SERIES,           
                SCRIPNAME = (           
                CASE           
              WHEN LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11) <> @SAUDA_DATE           
                        THEN 'BF-'           
                        ELSE '' END ) + ISNULL(S2.SHORT_NAME,'BROKERAGE') + '   ' ,           
                SDT = CONVERT(VARCHAR,@SDT,103),           
                SELL_BUY=1,           
                BROKER_CHRG =0,           
                TURN_TAX =0,           
                SEBI_TAX =0,           
                OTHER_CHRG =0,           
                INS_CHRG =0,           
                SERVICE_TAX = (           
                CASE           
                        WHEN SERVICE_CHRG = 0           
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax        
                        ELSE 0 END ),           
                NSERTAX = (           
                CASE           
                        WHEN SERVICE_CHRG = 0           
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax        
                        ELSE 0 END ),           
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),           
                PQTY = 0,           
                SQTY = 0,           
                PRATE = 0,           
                SRATE = 0,           
                PBROK = 0,           
                SBROK = 0,           
                PNETRATE =0,           
                SNETRATE =0,           
                PAMT =CD_TrdBuyBrokerage+CD_DelBuyBrokerage+(           
                CASE           
                        WHEN SERVICE_CHRG = 1            
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax     
                        ELSE 0 END ),           
                SAMT = 0,  
                BROKERAGE = CD_TrdBuyBrokerage+CD_DelBuyBrokerage+(           
                CASE           
                        WHEN SERVICE_CHRG = 1            
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax       
                        ELSE 0 END ),           
                S.CD_SETT_NO,           
                S.CD_SETT_TYPE,           
                TRADETYPE = '  ',           
                TMARK     = ' ',           
                /*TO DISPLAY THE HEADER PART*/           
                PARTYNAME = C1.LONG_NAME,           
                C1.L_ADDRESS1,           
                C1.L_ADDRESS2,           
                C1.L_ADDRESS3,           
                C1.L_CITY,          
  C1.L_STATE,           
                C1.L_ZIP,           
                C1.SERVICE_CHRG,           
                C1.BRANCH_CD ,           
                C1.SUB_BROKER,           
                C1.TRADER,           
                C1.PAN_GIR_NO,           
                C1.OFF_PHONE1,           
                C1.OFF_PHONE2,           
                PRINTF,           
                MAPIDID,           
  UCC_CODE,          
                ORDERFLAG  = 4,           
  SCRIPNAMEForOrderBy=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),        
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI'           
       Then LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(1))           
              Else ''           
         End), 52),                 
   SEBI_NO,          
   Participant_Code,          
   ActSell_buy = 1, ISIN = '', START_DATE = CONVERT(VARCHAR,START_DATE,103), END_DATE =  CONVERT(VARCHAR,END_DATE,103),  
FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103), FUNDS_PAYOUT =  CONVERT(VARCHAR,FUNDS_PAYOUT,103),  
AREA, REGION, CL_TYPE, FAMILY  
        FROM    CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2          
 ON (    S2.SCRIP_CD  = S.CD_SCRIP_CD           
                AND S2.SERIES    = S.CD_SERIES   ),           
                #CLIENTMASTER C1           
        WITH             
                (             
                        NOLOCK             
                )             
                ,           
                SETT_MST M           
        WITH             
                (             
                        NOLOCK             
                )     
                         
        WHERE   S.CD_SETT_NO       = @SETT_NO           
                AND S.CD_SETT_TYPE = @SETT_TYPE           
                AND S.CD_PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE           
                AND S.CD_SETT_NO   = M.SETT_NO           
                AND S.CD_SETT_TYPE = M.SETT_TYPE           
                AND M.END_DATE LIKE @SAUDA_DATE + '%'           
                AND S.CD_PARTY_CODE = C1.PARTY_CODE           
  AND CD_TrdBuyBrokerage+CD_DelBuyBrokerage > 0        
  AND CD_Trade_No = ''   
  
  
        INSERT     
        INTO    CONTRACT_DATA_TMP  
  
 SELECT  CONTRACTNO='0',           
                S.CD_PARTY_CODE,           
   CD_ORDER_NO,           
                ORDER_TIME='',           
                TM='',           
                TRADE_NO='',           
                CD_SAUDA_DATE,           
                S.CD_SCRIP_CD,           
                S.CD_SERIES,           
                SCRIPNAME = (           
                CASE           
                        WHEN LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11) <> @SAUDA_DATE           
                        THEN 'BF-'           
                        ELSE '' END ) + ISNULL(S2.SHORT_NAME,'BROKERAGE') + '   ' ,           
                SDT = CONVERT(VARCHAR,@SDT,103),           
                SELL_BUY=2,           
                BROKER_CHRG =0,           
                TURN_TAX =0,           
                SEBI_TAX =0,           
                OTHER_CHRG =0,           
                INS_CHRG =0,           
                SERVICE_TAX = (           
                CASE           
                        WHEN SERVICE_CHRG = 0           
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax        
                        ELSE 0 END ),           
                NSERTAX = (           
                CASE           
                        WHEN SERVICE_CHRG = 0           
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax        
                        ELSE 0 END ),           
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),           
                PQTY = 0,           
                SQTY = 0,           
                PRATE = 0,           
                SRATE = 0,           
                PBROK = 0,           
                SBROK = 0,           
                PNETRATE =0,           
                SNETRATE =0,           
                PAMT = 0,           
                SAMT = -(CD_TrdSellBrokerage+CD_DelSellBrokerage+(           
                CASE           
                        WHEN SERVICE_CHRG = 1            
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax        
                        ELSE 0 END )),  
                BROKERAGE = CD_TrdSellBrokerage+CD_DelSellBrokerage+(           
                CASE           
                        WHEN SERVICE_CHRG = 1            
                        THEN CD_TrdSellSerTax+CD_DelSellSerTax        
                        ELSE 0 END ),           
                S.CD_SETT_NO,           
                S.CD_SETT_TYPE,           
                TRADETYPE = '  ',           
                TMARK     = ' ',           
                /*TO DISPLAY THE HEADER PART*/           
                PARTYNAME = C1.LONG_NAME,           
                C1.L_ADDRESS1,           
                C1.L_ADDRESS2,           
                C1.L_ADDRESS3,           
                C1.L_CITY,          
  C1.L_STATE,           
                C1.L_ZIP,           
                C1.SERVICE_CHRG,           
                C1.BRANCH_CD ,           
                C1.SUB_BROKER,           
                C1.TRADER,           
                C1.PAN_GIR_NO,           
                C1.OFF_PHONE1,           
                C1.OFF_PHONE2,           
                PRINTF,           
                MAPIDID,           
  UCC_CODE,          
                ORDERFLAG  = 4,           
  SCRIPNAMEForOrderBy=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),        
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI'           
       Then LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(2))           
              Else ''           
         End), 52),                 
   SEBI_NO,          
   Participant_Code,          
   ActSell_buy = 2, ISIN = '', START_DATE = CONVERT(VARCHAR,START_DATE,103), END_DATE =  CONVERT(VARCHAR,END_DATE,103),  
FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103), FUNDS_PAYOUT =  CONVERT(VARCHAR,FUNDS_PAYOUT,103),  
AREA, REGION, CL_TYPE, FAMILY  
        FROM    CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2          
 ON (    S2.SCRIP_CD  = S.CD_SCRIP_CD           
                AND S2.SERIES    = S.CD_SERIES   ),           
                #CLIENTMASTER C1           
        WITH             
                (             
                        NOLOCK             
                )             
                ,           
                SETT_MST M           
        WITH             
                (             
                        NOLOCK             
                )             
                         
        WHERE   S.CD_SETT_NO       = @SETT_NO           
                AND S.CD_SETT_TYPE = @SETT_TYPE           
                AND S.CD_PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE           
                AND S.CD_SETT_NO   = M.SETT_NO           
                AND S.CD_SETT_TYPE = M.SETT_TYPE           
                AND M.END_DATE LIKE @SAUDA_DATE + '%'           
                AND S.CD_PARTY_CODE = C1.PARTY_CODE           
  AND CD_TrdSellBrokerage+CD_DelSellBrokerage > 0        
  AND CD_Trade_No = ''   
        
  /*=========================================================================                                          
                /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */         
                =========================================================================*/      
  INSERT INTO CONTRACT_DATA_TMP      
  SELECT CONTRACTNO,      
         S.PARTY_CODE,      
         ORDER_NO,      
         ORDER_TIME = (CASE       
                         WHEN CPID = 'NIL' THEN '        '      
                         ELSE RIGHT(CPID,8)      
                       END),      
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),      
         TRADE_NO,      
         SAUDA_DATE,      
         S.SCRIP_CD,      
         S.SERIES,      
         SCRIPNAME = (CASE       
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) = @SAUDA_DATE THEN 'ND-'      
  ELSE 'BF-'      
                      END) + S2.SHORT_NAME,      
         SDT = CONVERT(VARCHAR,@SDT,103),      
         SELL_BUY,      
         BROKER_CHRG = 0,      
         TURN_TAX = 0,      
         SEBI_TAX = 0,      
         S.OTHER_CHRG,      
         INS_CHRG = 0,      
         SERVICE_TAX = 0,      
         NSERTAX = 0,      
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
         PQTY = (CASE       
                   WHEN SELL_BUY = 1 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         SQTY = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         PRATE = (CASE       
                    WHEN SELL_BUY = 1 THEN MARKETRATE      
                    ELSE 0      
                  END),      
    SRATE = (CASE       
                    WHEN SELL_BUY = 2 THEN MARKETRATE      
                    ELSE 0      
                  END),      
         PBROK = 0,      
         SBROK = 0,      
         PNETRATE = (CASE       
                       WHEN SELL_BUY = 1 THEN MARKETRATE      
                       ELSE 0      
                     END),      
         SNETRATE = (CASE       
                       WHEN SELL_BUY = 2 THEN MARKETRATE      
                       ELSE 0      
                     END),      
         PAMT = (CASE       
                   WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE      
                   ELSE 0      
                 END),      
         SAMT = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE      
                   ELSE 0      
                 END),      
         BROKERAGE = 0,      
         S.SETT_NO,      
         S.SETT_TYPE,      
         TRADETYPE = 'BF',      
         TMARK = CASE       
                   WHEN BILLFLAG = 1      
                         OR BILLFLAG = 4      
                         OR BILLFLAG = 5 THEN ''      
                   ELSE ''      
                 END,      
         /*TO DISPLAY THE HEADER PART*/      
         PARTYNAME = C1.LONG_NAME,      
         C1.L_ADDRESS1,      
         C1.L_ADDRESS2,      
         C1.L_ADDRESS3,      
         C1.L_CITY,      
         C1.L_STATE,      
         C1.L_ZIP,      
         C1.SERVICE_CHRG,      
         C1.BRANCH_CD,      
         C1.SUB_BROKER,      
         C1.TRADER,      
         C1.PAN_GIR_NO,      
         C1.OFF_PHONE1,      
         C1.OFF_PHONE2,      
         PRINTF,      
         MAPIDID,      
         UCC_CODE,      
         ORDERFLAG = 0,      
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,      
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE       
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))      
                                         ELSE ''      
                                       END),52),      
         SEBI_NO,      
         PARTICIPANT_CODE,      
         ACTSELL_BUY = SELL_BUY,      
         ISIN = CONVERT(VARCHAR(12),''),      
         START_DATE = CONVERT(CHAR,(START_DATE),103),      
         END_DATE = CONVERT(CHAR,(END_DATE),103),      
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),      
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),      
         AREA,      
         REGION,      
         CL_TYPE,      
         FAMILY      
  FROM   #SETT S WITH (NOLOCK),      
         #CLIENTMASTER C1 WITH (NOLOCK),      
         SETT_MST M WITH (NOLOCK),      
         #SCRIP S2      
  WHERE  SAUDA_DATE <= @SAUDA_DATE + ' 23:59'      
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                  AND @TOPARTY_CODE      
         AND M.END_DATE > @SAUDA_DATE + ' 23:59:59'      
         AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE                       
         AND S.SETT_NO = M.SETT_NO      
         AND S.SETT_TYPE = M.SETT_TYPE      
         AND M.END_DATE NOT LIKE @SAUDA_DATE + '%'      
         AND S2.SCRIP_CD = S.SCRIP_CD      
   AND S2.SERIES = S.SERIES      
         AND S.PARTY_CODE = C1.PARTY_CODE      
         AND S.TRADEQTY > 0      
        
  /*=========================================================================                                          
                /* ND RECORD CARRY FORWARD FOR SAME DAY OR PREVIOUS DAYS */         
                =========================================================================*/      
  INSERT INTO CONTRACT_DATA_TMP      
  SELECT CONTRACTNO,      
         S.PARTY_CODE,      
         ORDER_NO,      
         ORDER_TIME = (CASE       
                         WHEN CPID = 'NIL' THEN '        '      
                         ELSE RIGHT(CPID,8)      
                       END),      
         TM = CONVERT(VARCHAR,SAUDA_DATE,108),      
         TRADE_NO,      
         SAUDA_DATE,      
         S.SCRIP_CD,      
         S.SERIES,      
         SCRIPNAME = 'CF-' + S2.SHORT_NAME,      
         SDT = CONVERT(VARCHAR,@SDT,103),      
         SELL_BUY = (CASE       
    WHEN SELL_BUY = 1 THEN 2      
                       ELSE 1      
                     END),      
         BROKER_CHRG = 0,      
         TURN_TAX = 0,      
         SEBI_TAX = 0,      
         S.OTHER_CHRG,      
         INS_CHRG = 0,      
         SERVICE_TAX = 0,      
         NSERTAX = 0,      
         SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
         PQTY = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         SQTY = (CASE       
                   WHEN SELL_BUY = 1 THEN TRADEQTY      
                   ELSE 0      
                 END),      
         PRATE = (CASE       
                    WHEN SELL_BUY = 2 THEN MARKETRATE      
                    ELSE 0      
                  END),      
         SRATE = (CASE       
                    WHEN SELL_BUY = 1 THEN MARKETRATE      
                    ELSE 0      
                  END),      
         PBROK = 0,      
         SBROK = 0,      
         PNETRATE = (CASE       
                       WHEN SELL_BUY = 2 THEN MARKETRATE      
                       ELSE 0      
                     END),      
         SNETRATE = (CASE       
                       WHEN SELL_BUY = 1 THEN MARKETRATE      
                       ELSE 0      
                     END),      
         PAMT = (CASE       
                   WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE      
                   ELSE 0      
                 END),      
         SAMT = (CASE       
                   WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE      
                   ELSE 0      
                 END),      
         BROKERAGE = 0,      
         S.SETT_NO,      
         S.SETT_TYPE,      
         TRADETYPE = 'CF',      
         TMARK = CASE       
                   WHEN BILLFLAG = 1      
                         OR BILLFLAG = 4      
                         OR BILLFLAG = 5 THEN ''      
                   ELSE ''      
                 END,      
         /*TO DISPLAY THE HEADER PART*/      
         PARTYNAME = C1.LONG_NAME,      
         C1.L_ADDRESS1,      
         C1.L_ADDRESS2,      
         C1.L_ADDRESS3,      
         C1.L_CITY,      
         C1.L_STATE,      
         C1.L_ZIP,      
         C1.SERVICE_CHRG,      
         C1.BRANCH_CD,      
         C1.SUB_BROKER,      
         C1.TRADER,      
         C1.PAN_GIR_NO,      
         C1.OFF_PHONE1,      
         C1.OFF_PHONE2,      
         PRINTF,      
         MAPIDID,      
         UCC_CODE,      
         ORDERFLAG = 1,      
         SCRIPNAMEFORORDERBY = S2.SHORT_NAME,      
         SCRIPNAME1 = CONVERT(VARCHAR,(CASE       
                                         WHEN CL_TYPE = 'NRI' THEN LTRIM(RTRIM(SELL_BUY))      
                                         ELSE ''      
                                       END),52),      
         SEBI_NO,      
         PARTICIPANT_CODE,      
         ACTSELL_BUY = SELL_BUY,      
         ISIN = CONVERT(VARCHAR(12),''),      
         START_DATE = CONVERT(CHAR,(START_DATE),103),      
         END_DATE = CONVERT(CHAR,(END_DATE),103),      
         FUNDS_PAYIN = CONVERT(VARCHAR,FUNDS_PAYIN,103),      
         FUNDS_PAYOUT = CONVERT(VARCHAR,FUNDS_PAYOUT,103),      
         AREA,      
         REGION,      
         CL_TYPE,      
         FAMILY      
  FROM   #SETT S WITH (NOLOCK),      
         #CLIENTMASTER C1 WITH (NOLOCK),      
         SETT_MST M WITH (NOLOCK),      
         #SCRIP S2      
  WHERE  SAUDA_DATE <= @SAUDA_DATE + ' 23:59'      
         AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE      
                                  AND @TOPARTY_CODE      
         AND M.END_DATE > @SAUDA_DATE + ' 23:59:59'      
         AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE                       
         AND S.SETT_NO = M.SETT_NO      
         AND S.SETT_TYPE = M.SETT_TYPE      
         AND M.END_DATE NOT LIKE @SAUDA_DATE + '%'      
         AND S2.SCRIP_CD = S.SCRIP_CD      
         AND S2.SERIES = S.SERIES      
         AND S.PARTY_CODE = C1.PARTY_CODE      
         AND S.TRADEQTY > 0      
                                
  UPDATE CONTRACT_DATA_TMP      
  SET    START_DATE = CONVERT(CHAR,(S.START_DATE),103),      
         END_DATE = CONVERT(CHAR,(S.END_DATE),103),      
         FUNDS_PAYIN = CONVERT(VARCHAR,S.FUNDS_PAYIN,103),      
         FUNDS_PAYOUT = CONVERT(VARCHAR,S.FUNDS_PAYOUT,103),      
         SETT_NO = @SETT_NO      
  FROM   SETT_MST S      
  WHERE  S.SETT_NO = @SETT_NO      
         AND S.SETT_TYPE = @SETT_TYPE      
                                 
  UPDATE CONTRACT_DATA_TMP      
  SET    ISIN = M.ISIN      
  FROM   MULTIISIN M      
  WHERE  M.SCRIP_CD = CONTRACT_DATA_TMP.SCRIP_CD      
         AND M.SERIES = (CASE       
                           WHEN CONTRACT_DATA_TMP.SERIES = 'BL' THEN 'EQ'      
                           WHEN CONTRACT_DATA_TMP.SERIES = 'IL' THEN 'EQ'      
                           ELSE CONTRACT_DATA_TMP.SERIES      
                         END)      
         AND VALID = 1      
                           
  INSERT INTO CONTRACT_DATA      
  SELECT   CONTRACTNO,      
           PARTY_CODE,      
           ORDER_NO = '0000000000000000',      
           ORDER_TIME = '        ',      
           TM = '        ',      
           TRADE_NO = '00000000000',      
           SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),      
           SCRIP_CD,      
           SERIES,      
           SCRIPNAME,      
           SDT,      
           SELL_BUY,      
           BROKER_CHRG = SUM(BROKER_CHRG),      
           TURN_TAX = SUM(TURN_TAX),      
           SEBI_TAX = SUM(SEBI_TAX),      
           OTHER_CHRG = SUM(OTHER_CHRG),      
           INS_CHRG = SUM(INS_CHRG),      
           SERVICE_TAX = SUM(SERVICE_TAX),      
           NSERTAX = SUM(NSERTAX),      
           SAUDA_DATE1,      
           PQTY = SUM(PQTY),      
           SQTY = SUM(SQTY),      
           PRATE = (CASE       
                      WHEN SUM(PQTY) > 0 THEN SUM(PRATE * PQTY) / SUM(PQTY)      
                      ELSE 0      
 END),      
           SRATE = (CASE       
                      WHEN SUM(SQTY) > 0 THEN SUM(SRATE * SQTY) / SUM(SQTY)      
                      ELSE 0      
                    END),      
           PBROK = (CASE       
                      WHEN SUM(PQTY) > 0 THEN SUM(PBROK * PQTY) / SUM(PQTY)      
                      ELSE 0      
                    END),      
           SBROK = (CASE       
                      WHEN SUM(SQTY) > 0 THEN SUM(SBROK * SQTY) / SUM(SQTY)      
                      ELSE 0      
                    END),      
           PNETRATE = (CASE       
                         WHEN SUM(PQTY) > 0 THEN SUM(PNETRATE * PQTY) / SUM(PQTY)      
                         ELSE 0      
                       END),      
           SNETRATE = (CASE       
                         WHEN SUM(SQTY) > 0 THEN SUM(SNETRATE * SQTY) / SUM(SQTY)      
                         ELSE 0      
                       END),      
           PAMT = SUM(PAMT),     
           SAMT = SUM(SAMT),      
           BROKERAGE = SUM(BROKERAGE),      
           SETT_NO,      
           SETT_TYPE,      
           TRADETYPE,      
           TMARK,      
           PRINTF,      
           ORDERFLAG,      
           SCRIPNAMEFORORDERBY,      
           SCRIPNAME1,      
           ACTSELL_BUY,      
           ISIN,      
           ROUNDTO = 4      
  FROM     CONTRACT_DATA_TMP WITH (NOLOCK)      
  WHERE    PRINTF = 3      
  GROUP BY CONTRACTNO,PARTY_CODE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SCRIP_CD,      
           SERIES,SCRIPNAME,SDT,SELL_BUY,      
           SETT_NO,SETT_TYPE,SAUDA_DATE1,TRADETYPE,      
           TMARK,PARTYNAME,L_ADDRESS1,L_ADDRESS2,      
           L_ADDRESS3,L_CITY,L_STATE,L_ZIP,      
           SERVICE_CHRG,BRANCH_CD,SUB_BROKER,TRADER,      
           PAN_GIR_NO,OFF_PHONE1,OFF_PHONE2,PRINTF,      
           MAPIDID,UCC_CODE,ORDERFLAG,SCRIPNAMEFORORDERBY,      
           SCRIPNAME1,SEBI_NO,PARTICIPANT_CODE,ACTSELL_BUY,      
           ISIN      
                 
  INSERT INTO CONTRACT_DATA_DET      
  SELECT CONTRACTNO,      
         PARTY_CODE,      
         ORDER_NO,      
         ORDER_TIME,      
         TM,      
         TRADE_NO,      
         SAUDA_DATE,      
         SCRIP_CD,      
         SERIES,      
         SCRIPNAME,      
         SDT,      
         SELL_BUY,      
         BROKER_CHRG,      
         TURN_TAX,      
         SEBI_TAX,      
         OTHER_CHRG,      
         INS_CHRG,      
         SERVICE_TAX,      
         NSERTAX,      
         SAUDA_DATE1,      
         PQTY,      
         SQTY,      
         PRATE,      
         SRATE,      
         PBROK,      
         SBROK,      
         PNETRATE,      
         SNETRATE,      
         PAMT,      
         SAMT,      
         BROKERAGE,      
         SETT_NO,      
         SETT_TYPE,      
         TRADETYPE,      
         TMARK,      
         PRINTF,      
         ORDERFLAG,      
         SCRIPNAMEFORORDERBY,      
         SCRIPNAME1,      
         ACTSELL_BUY,      
         ISIN,      
         ROUNDTO = 2      
  FROM   CONTRACT_DATA_TMP WITH (NOLOCK)      
  WHERE  PRINTF = 3      
                        
  INSERT INTO CONTRACT_DATA      
  SELECT CONTRACTNO,      
         PARTY_CODE,      
         ORDER_NO,      
         ORDER_TIME,      
         TM,      
         TRADE_NO,      
         SAUDA_DATE,      
         SCRIP_CD,      
         SERIES,      
         SCRIPNAME,      
         SDT,      
         SELL_BUY,      
         BROKER_CHRG,      
         TURN_TAX,      
         SEBI_TAX,      
         OTHER_CHRG,      
         INS_CHRG,      
         SERVICE_TAX,      
         NSERTAX,      
         SAUDA_DATE1,      
         PQTY,      
         SQTY,      
         PRATE,      
         SRATE,      
         PBROK,      
         SBROK,      
         PNETRATE,      
         SNETRATE,      
         PAMT,      
         SAMT,      
         BROKERAGE,      
         SETT_NO,      
         SETT_TYPE,      
         TRADETYPE,      
         TMARK,      
         PRINTF,      
         ORDERFLAG,      
         SCRIPNAMEFORORDERBY,      
         SCRIPNAME1,      
         ACTSELL_BUY,      
         ISIN,      
         ROUNDTO = 2      
  FROM   CONTRACT_DATA_TMP WITH (NOLOCK)      
  WHERE  PRINTF <> 3      
                         
  UPDATE CONTRACT_DATA      
  SET    ORDER_NO = S.ORDER_NO,      
         TM = CONVERT(VARCHAR,S.SAUDA_DATE,108),      
         TRADE_NO = S.TRADE_NO,      
         ORDER_TIME = S.ORDER_TIME      
  FROM   CONTRACT_DATA_TMP S WITH (NOLOCK)      
  WHERE  CONTRACT_DATA.SETT_NO = @SETT_NO      
         AND CONTRACT_DATA.SETT_TYPE = @SETT_TYPE      
         AND S.SETT_NO = @SETT_NO      
         AND S.SETT_TYPE = @SETT_TYPE      
         AND S.PARTY_CODE = CONTRACT_DATA.PARTY_CODE      
         AND S.SCRIP_CD = CONTRACT_DATA.SCRIP_CD      
         AND S.SERIES = CONTRACT_DATA.SERIES      
         AND CONTRACT_DATA.SAUDA_DATE LIKE @SAUDA_DATE + '%'      
         AND S.PRINTF = CONTRACT_DATA.PRINTF      
      AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%'      
         AND S.CONTRACTNO = CONTRACT_DATA.CONTRACTNO      
         AND S.ACTSELL_BUY = CONTRACT_DATA.ACTSELL_BUY      
         AND S.PRINTF = 3      
         AND S.SAUDA_DATE = (SELECT MIN(SAUDA_DATE)      
                             FROM   CONTRACT_DATA_TMP ISETT WITH (NOLOCK)      
                             WHERE  ISETT.SETT_NO = @SETT_NO      
                                    AND ISETT.SETT_TYPE = @SETT_TYPE      
                                    AND ISETT.SETT_NO = S.SETT_NO      
                                    AND ISETT.SETT_TYPE = S.SETT_TYPE      
                                    AND S.PARTY_CODE = ISETT.PARTY_CODE      
                                    AND S.SCRIP_CD = ISETT.SCRIP_CD      
                                    AND S.SERIES = ISETT.SERIES      
                                    AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%'      
                                    AND S.CONTRACTNO = ISETT.CONTRACTNO      
                                    AND S.ACTSELL_BUY = ISETT.ACTSELL_BUY      
                                    AND PRINTF = 3)      
                                  
  INSERT INTO CONTRACT_MASTER      
  SELECT DISTINCT SETT_TYPE,      
                  SETT_NO,      
                  PARTY_CODE,      
                  START_DATE,      
                  END_DATE,      
                  FUNDS_PAYIN,      
                  FUNDS_PAYOUT,      
                  BRANCH_CD,      
                  SUB_BROKER,      
                  TRADER,      
                  AREA,      
                  REGION,      
                  FAMILY,      
              PARTYNAME,      
                  L_ADDRESS1,      
                  L_ADDRESS2,      
                  L_ADDRESS3,      
                  L_CITY,      
                  L_STATE,      
                  L_ZIP,      
                  PAN_GIR_NO,      
                  OFF_PHONE1,      
                  OFF_PHONE2,      
                  MAPIDID,      
                  UCC_CODE,      
                  SEBI_NO,      
                  PARTICIPANT_CODE,      
                  CL_TYPE,      
                  SERVICE_CHRG,      
                  PRINTF      
  FROM   CONTRACT_DATA_TMP

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
CREATE PROC SP @spName VARCHAR(25)AS               
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

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
-- PROCEDURE dbo.sp_generate_inserts
-- --------------------------------------------------



---------------------------------------------------------------------------------------------------------------------- 
-- http://vyaskn.tripod.com/code.htm#inserts 
------------------------------------------------------------------------------------------------------------------------ 
--SET NOCOUNT ON 
--GO 
-- 
--PRINT 'Using Master database' 
--USE master 
--GO 
-- 
--PRINT 'Checking for the existence of this procedure' 
--IF (SELECT OBJECT_ID('sp_generate_inserts','P')) IS NOT NULL --means, the procedure already exists 
-- BEGIN 
-- PRINT 'Procedure already exists. So, dropping it' 
-- DROP PROC sp_generate_inserts 
-- END 
--GO 
-- 
----Turn system object marking on 
--EXEC master.dbo.sp_MS_upd_sysobj_category 1 
--GO 
CREATE PROC [dbo].[sp_generate_inserts] 
( 
@table_name varchar(776), -- The table/view for which the INSERT statements will be generated using the existing data 
@target_table varchar(776) = NULL, -- Use this parameter to specify a different table name into which the data will be inserted 
@include_column_list bit = 1, -- Use this parameter to include/ommit column list in the generated INSERT statement 
@from varchar(800) = NULL, -- Use this parameter to filter the rows based on a filter condition (using WHERE) 
@include_timestamp bit = 0, -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement 
@debug_mode bit = 0, -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination 
@owner varchar(64) = NULL, -- Use this parameter if you are not the owner of the table 
@ommit_images bit = 0, -- Use this parameter to generate INSERT statements by omitting the 'image' columns 
@ommit_identity bit = 0, -- Use this parameter to ommit the identity columns 
@top int = NULL, -- Use this parameter to generate INSERT statements only for the TOP n rows 
@cols_to_include varchar(8000) = NULL, -- List of columns to be included in the INSERT statement 
@cols_to_exclude varchar(8000) = NULL, -- List of columns to be excluded from the INSERT statement 
@disable_constraints bit = 0, -- When 1, disables foreign key constraints and enables them after the INSERT statements 
@ommit_computed_cols bit = 0 -- When 1, computed columns will not be included in the INSERT statement 
) 
AS 
BEGIN 
/*********************************************************************************************************** 
Procedure: sp_generate_inserts (Build 22) 
(Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.) 
Purpose: To generate INSERT statements from existing data. 
These INSERTS can be executed to regenerate the data at some other location. 
This procedure is also useful to create a database setup, where in you can 
script your data along with your table definitions. 
Written by: Narayana Vyas Kondreddi 
http://vyaskn.tripod.com 
Acknowledgements: 
Divya Kalra -- For beta testing 
Mark Charsley -- For reporting a problem with scripting uniqueidentifier columns with NULL values 
Artur Zeygman -- For helping me simplify a bit of code for handling non-dbo owned tables 
Joris Laperre -- For reporting a regression bug in handling text/ntext columns 
Tested on: SQL Server 7.0 and SQL Server 2000 
Date created: January 17th 2001 21:52 GMT 
Date modified: May 1st 2002 19:50 GMT 
Email: vyaskn@hotmail.com 
NOTE: This procedure may not work with tables with too many columns. 
Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types 
Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results 
IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed 
you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts 
like nchar and nvarchar 
Example 1: To generate INSERT statements for table 'titles': 
EXEC sp_generate_inserts 'titles' 
Example 2: To ommit the column list in the INSERT statement: (Column list is included by default) 
IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below, 
to avoid erroneous results 
EXEC sp_generate_inserts 'titles', @include_column_list = 0 
Example 3: To generate INSERT statements for 'titlesCopy' table from 'titles' table: 
EXEC sp_generate_inserts 'titles', 'titlesCopy' 
Example 4: To generate INSERT statements for 'titles' table for only those titles 
which contain the word 'Computer' in them: 
NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter 
EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'" 
Example 5: To specify that you want to include TIMESTAMP column's data as well in the INSERT statement: 
(By default TIMESTAMP column's data is not scripted) 
EXEC sp_generate_inserts 'titles', @include_timestamp = 1 
Example 6: To print the debug information: 
EXEC sp_generate_inserts 'titles', @debug_mode = 1 
Example 7: If you are not the owner of the table, use @owner parameter to specify the owner name 
To use this option, you must have SELECT permissions on that table 
EXEC sp_generate_inserts Nickstable, @owner = 'Nick' 
Example 8: To generate INSERT statements for the rest of the columns excluding images 
When using this otion, DO NOT set @include_column_list parameter to 0. 
EXEC sp_generate_inserts imgtable, @ommit_images = 1 
Example 9: To generate INSERT statements excluding (ommiting) IDENTITY columns: 
(By default IDENTITY columns are included in the INSERT statement) 
EXEC sp_generate_inserts mytable, @ommit_identity = 1 
Example 10: To generate INSERT statements for the TOP 10 rows in the table: 
EXEC sp_generate_inserts mytable, @top = 10 
Example 11: To generate INSERT statements with only those columns you want: 
EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'" 
Example 12: To generate INSERT statements by omitting certain columns: 
EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'" 
Example 13: To avoid checking the foreign key constraints while loading data with INSERT statements: 
EXEC sp_generate_inserts titles, @disable_constraints = 1 
Example 14: To exclude computed columns from the INSERT statement: 
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
DECLARE @Column_ID int, 
@Column_List varchar(8000), 
@Column_Name varchar(128), 
@Start_Insert varchar(786), 
@Data_Type varchar(128), 
@Actual_Values varchar(max), --This is the string that will be finally executed to generate INSERT statements 
@IDN varchar(128) --Will contain the IDENTITY column's name in the table 
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
SELECT @Column_ID = MIN(ORDINAL_POSITION) 
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE TABLE_NAME = @table_name AND 
(@owner IS NULL OR TABLE_SCHEMA = @owner) 
--Loop through all the columns of the table, to get the column names and their data types 
WHILE @Column_ID IS NOT NULL 
BEGIN 
SELECT @Column_Name = QUOTENAME(COLUMN_NAME), 
@Data_Type = DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE ORDINAL_POSITION = @Column_ID AND 
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
SET @Actual_Values = @Actual_Values + 
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
'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ',2)' + ')),''NULL'')' 
ELSE 
'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ')' + ')),''NULL'')' 
END + '+' + ''',''' + ' + ' 
--Generating the column list for the INSERT statement 
SET @Column_List = @Column_List + @Column_Name + ',' 
SKIP_LOOP: --The label used in GOTO 
SELECT @Column_ID = MIN(ORDINAL_POSITION) 
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE TABLE_NAME = @table_name AND 
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
' ''+' + '''(' + RTRIM(@Column_List) + '''+' + ''')''' + 
' +''VALUES(''+ ' + @Actual_Values + '+'')''' + ' ' + 
COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)') 
END 
ELSE IF (@include_column_list = 0) 
BEGIN 
SET @Actual_Values = 
'SELECT ' + 
CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
'''' + RTRIM(@Start_Insert) + 
' '' +''VALUES(''+ ' + @Actual_Values + '+'')''' + ' ' + 
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
SELECT 'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily' 
END 
ELSE 
BEGIN 
SELECT 'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily' 
END 
PRINT 'GO' 
END 
PRINT '' 
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + '''' 
--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes! 
print @Actual_Values
EXEC (@Actual_Values) 
PRINT 'PRINT ''Done''' 
PRINT '' 
IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL) 
BEGIN 
IF @owner IS NULL 
BEGIN 
SELECT 'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints' 
END 
ELSE 
BEGIN 
SELECT 'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints' 
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
-- PROCEDURE dbo.SP_GET_BILL_DETAILS
-- --------------------------------------------------

CREATE PROC [dbo].[SP_GET_BILL_DETAILS]
(
	@EXCHANGE VARCHAR(3),
	@SEGMENT VARCHAR(25),
	@SHAREDB VARCHAR(25),
	@ACCDB VARCHAR(25),
	@BILLDT VARCHAR(11),
	@NARRATION VARCHAR(500)
)

AS
DECLARE @@SQL AS VARCHAR(MAX)
/*
	SELECT CNT = COUNT(*) INTO #CHK FROM account.sys.objects WHERE NAME = 'BILLPOSTED' 
	SELECT * FROM ACCOUNT..BILLPOSTED	 
	SELECT * FROM #CHK
*/
CREATE TABLE #CHK( NAME VARCHAR(50))

SET @@SQL = " INSERT INTO #CHK SELECT NAME FROM " + @ACCDB + ".sys.objects WHERE NAME = 'BILLPOSTED' "
PRINT @@SQL
EXEC(@@SQL)

IF (SELECT COUNT(1) FROM #CHK) > 0 
 BEGIN
	SET @@SQL = ""
	SET @@SQL = @@SQL + " SELECT BILLDATE,BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL FROM " + @ACCDB +" .DBO.BILLPOSTED BP, ACCOUNT.DBO.PLDETAIL PL "
	SET @@SQL = @@SQL + " WHERE BILLDATE = '" + @BILLDT + "' "
	SET @@SQL = @@SQL + " AND PL.EXCHANGE = '" + @EXCHANGE + "' "
	SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "
	SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "
	SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE AND FLAG = 'Y'"
	PRINT @@SQL
	EXEC(@@SQL)
 END
DROP TABLE #CHK

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
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------

CREATE PROC Tbl @TblName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ukproc
-- --------------------------------------------------
create proc ukproc as
UPDATE UK
SET MYFLAG = 
(
CASE WHEN 
1 = 1
AND NSE_B <> '-' 
AND BSE_B = '-' 
AND FO_B <> '-' 
AND MCX_B = '-' 
AND NCX_B = '-'
	THEN
		(
		CASE WHEN 
			1 = 1
			AND CM_B = NSE_B 
			AND CM_S = NSE_S 
--			AND CM_B = BSE_B 
--			AND CM_S = BSE_S 
			AND CM_B = FO_B 
			AND CM_S = FO_S 
--			AND CM_B = MCX_B 
--			AND CM_S = MCX_S 
--			AND CM_B = NCX_B
--			AND CM_S = NCX_S
		THEN 1
		ELSE 0
		END
		)
	ELSE 2
END
)
WHERE
MYFLAG = 2

	
SELECT MYFLAG, COUNT(1) FROM UK
GROUP BY MYFLAG

SELECT * FROM UK
WHERE MYFLAG = 2

DELETE FROM UK
WHERE MYFLAG = 1

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
-- PROCEDURE dbo.VW
-- --------------------------------------------------
      
CREATE PROC VW @VWNAME VARCHAR(25)AS                     
SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%' + @VWNAME + '%' AND XTYPE='V' ORDER BY NAME

GO

-- --------------------------------------------------
-- TABLE dbo.acc_multicompany_DR
-- --------------------------------------------------
CREATE TABLE [dbo].[acc_multicompany_DR]
(
    [BROKERID] VARCHAR(6) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MEMBERTYPE] VARCHAR(3) NULL,
    [MEMBERCODE] VARCHAR(15) NULL,
    [SHAREDB] VARCHAR(20) NULL,
    [SHARESERVER] VARCHAR(100) NULL,
    [SHAREIP] VARCHAR(15) NULL,
    [ACCOUNTDB] VARCHAR(20) NULL,
    [ACCOUNTSERVER] VARCHAR(100) NULL,
    [ACCOUNTIP] VARCHAR(15) NULL,
    [DEFAULTDB] VARCHAR(20) NULL,
    [DEFAULTDBSERVER] VARCHAR(100) NULL,
    [DEFAULTDBIP] VARCHAR(15) NULL,
    [DEFAULTCLIENT] INT NULL,
    [PANGIR_NO] VARCHAR(30) NULL,
    [PRIMARYSERVER] VARCHAR(100) NULL,
    [FILLER2] VARCHAR(10) NULL,
    [DBUSERNAME] VARCHAR(25) NULL,
    [DBPASSWORD] VARCHAR(25) NULL,
    [Segment_Description] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_MG02_0109
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_MG02_0109]
(
    [Margin_Date] DATETIME NOT NULL,
    [Rec_Type] INT NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [BuyQty] NUMERIC(18, 4) NULL,
    [BUYAMT] NUMERIC(18, 4) NULL,
    [SELLQTY] NUMERIC(18, 4) NULL,
    [SELLAMT] NUMERIC(18, 4) NULL,
    [NETQTY] NUMERIC(18, 4) NULL,
    [NETAMT] NUMERIC(18, 4) NULL,
    [CL_RATE] NUMERIC(18, 4) NULL,
    [MTOM] NUMERIC(18, 4) NULL,
    [VARAMT] NUMERIC(18, 4) NULL,
    [MINIMUM_MARGIN] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_pincode
-- --------------------------------------------------
CREATE TABLE [dbo].[client_pincode]
(
    [Client_Code] NVARCHAR(255) NULL,
    [City] NVARCHAR(255) NULL,
    [State] NVARCHAR(255) NULL,
    [Pincode] FLOAT NULL,
    [R_City] NVARCHAR(255) NULL,
    [c_True_False] BIT NOT NULL,
    [R_State] NVARCHAR(255) NULL,
    [S_True_False] BIT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_F2CONFIG
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_F2CONFIG]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [F2CODE] VARCHAR(10) NULL,
    [F2DESCRIPTION] VARCHAR(50) NULL,
    [F2OBJECT] VARCHAR(100) NULL,
    [F2OBJECTTYPE] VARCHAR(1) NULL,
    [F2PARAMFIELDS] VARCHAR(500) NULL,
    [F2OUTPUT] VARCHAR(500) NULL,
    [F2OPRLIST] VARCHAR(100) NULL,
    [F2ORDERLIST] VARCHAR(100) NULL,
    [DATABASENAME] VARCHAR(256) NULL,
    [WINDOWTITLE] VARCHAR(100) NULL,
    [TABLEHEADER] VARCHAR(200) NULL,
    [CONNECTIONDB] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_OWNER_TEST
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_OWNER_TEST]
(
    [Company] VARCHAR(60) NULL,
    [Company_Addr1] VARCHAR(50) NULL,
    [Company_Addr2] VARCHAR(50) NULL,
    [Company_Phone] VARCHAR(60) NULL,
    [Company_Zip] VARCHAR(6) NULL,
    [Company_city] VARCHAR(20) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [BankName] VARCHAR(50) NULL,
    [BankAdd] VARCHAR(50) NULL,
    [csdlId] VARCHAR(10) NULL,
    [Cdaccno] VARCHAR(10) NULL,
    [DpId] VARCHAR(10) NULL,
    [CltAccNo] VARCHAR(10) NULL,
    [Mainbroker] CHAR(1) NULL,
    [Maxpartylen] TINYINT NULL,
    [Preprintchq] CHAR(1) NULL,
    [Table_No] SMALLINT NULL,
    [Sub_TableNo] SMALLINT NULL,
    [Std_rate] SMALLINT NULL,
    [P_to_P] SMALLINT NULL,
    [demat_tableno] SMALLINT NULL,
    [AlbmCf_tableno] SMALLINT NULL,
    [MF_tableno] SMALLINT NULL,
    [SB_tableno] SMALLINT NULL,
    [brok1_tableno] SMALLINT NULL,
    [brok2_tableno] SMALLINT NULL,
    [brok3_tableno] SMALLINT NULL,
    [Terminal] VARCHAR(10) NULL,
    [tscheme] TINYINT NULL,
    [dispcharge] TINYINT NULL,
    [Brok_Inc_STax] TINYINT NULL,
    [def_scheme] CHAR(1) NULL,
    [brok_scheme] TINYINT NULL,
    [ContCharge] TINYINT NULL,
    [MinContCharge] TINYINT NULL,
    [MarginMultiplier] TINYINT NULL,
    [dummy1] TINYINT NULL,
    [dummy2] TINYINT NULL,
    [Style] INT NULL,
    [ExchangeCode] VARCHAR(3) NULL,
    [BrokerSebiRegNo] VARCHAR(15) NULL,
    [CounterPart] VARCHAR(15) NULL,
    [CP_SebiRegNo] VARCHAR(15) NULL,
    [state] VARCHAR(50) NULL,
    [panno] VARCHAR(50) NULL,
    [AutoGenPartyCode] INT NULL,
    [Company_Fax] VARCHAR(25) NULL,
    [KRA_TYPE] VARCHAR(4) NULL,
    [POS_CODE] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [WEBSITE_ID] VARCHAR(100) NULL,
    [COMPLIANCE_NAME] VARCHAR(50) NULL,
    [COMPLIANCE_EMAIL] VARCHAR(100) NULL,
    [COMPLIANCE_PHONE] VARCHAR(15) NULL,
    [SERVICES_TAXNO] VARCHAR(30) NULL,
    [Company_CIN] VARCHAR(30) NULL,
    [COMMONSEBINO] VARCHAR(300) NULL,
    [COMMONMEMBERCODE] VARCHAR(300) NULL,
    [LOGO_FILE_PATH] VARCHAR(8000) NULL,
    [SMTP_SRV_NAME] VARCHAR(100) NULL,
    [ExchangeSegment] VARCHAR(10) NULL,
    [LEVEL] INT NULL,
    [KEEPINST] TINYINT NULL,
    [OMGEOBRKCODE] VARCHAR(20) NULL,
    [OMGEOEXCHG] VARCHAR(20) NULL,
    [PARENTCODE_FLAG] INT NULL,
    [DMA_ENABLED] INT NULL,
    [Total_mobile_no] INT NULL,
    [TOTAL_MAILID] INT NULL,
    [NSECMCODE] VARCHAR(20) NULL,
    [SEBINO] VARCHAR(20) NULL,
    [TM_CODE] VARCHAR(10) NULL,
    [ADDR3] VARCHAR(50) NULL,
    [COUNTRY] VARCHAR(20) NULL,
    [OFF_ADDR1] VARCHAR(50) NULL,
    [OFF_ADDR2] VARCHAR(50) NULL,
    [OFF_ADDR3] VARCHAR(50) NULL,
    [OFF_PHONE] VARCHAR(20) NULL,
    [DEL_PHONE1] VARCHAR(20) NULL,
    [OFF_FAX] VARCHAR(20) NULL,
    [OFF_ZIP] VARCHAR(6) NULL,
    [OFF_CITY] VARCHAR(50) NULL,
    [OFF_EMAIL] VARCHAR(50) NULL,
    [OFF_STATE] VARCHAR(50) NULL,
    [OFF_COUNTRY] VARCHAR(20) NULL,
    [CORP_ADDR1] VARCHAR(50) NULL,
    [CORP_ADDR2] VARCHAR(50) NULL,
    [CORP_ADDR3] VARCHAR(50) NULL,
    [CORP_PHONE] VARCHAR(255) NULL,
    [CORP_ZIP] VARCHAR(50) NULL,
    [CORP_CITY] VARCHAR(50) NULL,
    [CORP_STATE] VARCHAR(50) NULL,
    [CORP_COUNTRY] VARCHAR(20) NULL,
    [OMGEOFILENAME] VARCHAR(10) NULL,
    [BR_CMDPID] VARCHAR(300) NULL,
    [IGRIV_EMAIL] VARCHAR(100) NULL,
    [CORP_FAX] VARCHAR(25) NULL,
    [Company_Addr3] CHAR(1) NULL,
    [COMPLIANCE_MOBILE] CHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_PDF_SETTING
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_PDF_SETTING]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [FLDREPORTCODE] VARCHAR(25) NULL,
    [FILENAME] VARCHAR(50) NULL,
    [PSIZE] VARCHAR(100) NULL,
    [HSIZE] VARCHAR(1000) NULL,
    [FSIZE] VARCHAR(1000) NULL,
    [RPTTITLE] VARCHAR(50) NULL,
    [RPTAUTHOR] VARCHAR(50) NULL,
    [RPTSUBJECT] VARCHAR(50) NULL,
    [NOOFTABLE] INT NULL,
    [BLANKPAGE] CHAR(1) NULL,
    [DESC] VARCHAR(100) NULL,
    [H2REPEAT] VARCHAR(10) NULL,
    [DUMMY2] VARCHAR(10) NULL,
    [DUMMY3] VARCHAR(10) NULL,
    [DUMMY4] VARCHAR(10) NULL,
    [ROWSPERPAGE] INT NULL,
    [FIRSTPAGEROWS] INT NULL,
    [FOOTERCOUNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cls_pdfCss
-- --------------------------------------------------
CREATE TABLE [dbo].[cls_pdfCss]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [class] VARCHAR(15) NULL,
    [selector] VARCHAR(20) NULL,
    [value] VARCHAR(25) NULL,
    [styleIdentifier] VARCHAR(10) NULL,
    [desc] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_SETUP
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_SETUP]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [SEG_DESC] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [CONNECTION] VARCHAR(10) NULL,
    [REASON] VARCHAR(1000) NULL,
    [PRODUCT_DETAILS] TINYINT NULL,
    [TEMPCLEANER_DETAILS] TINYINT NULL,
    [FLAG] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_TEMP_CLEANER
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_TEMP_CLEANER]
(
    [startTime] DATETIME NULL,
    [endTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClTax
-- --------------------------------------------------
CREATE TABLE [dbo].[ClTax]
(
    [Exchange] CHAR(10) NULL,
    [Scidentity] CHAR(3) NULL,
    [Party_Code] CHAR(10) NULL,
    [Cl_Type] CHAR(5) NULL,
    [Trans_Cat] CHAR(5) NULL,
    [Insurance_Chrg] SMALLMONEY NULL,
    [Turnover_Tax] SMALLMONEY NULL,
    [Other_Chrg] SMALLMONEY NULL,
    [Sebiturn_Tax] NUMERIC(4, 4) NOT NULL,
    [Broker_Note] SMALLMONEY NULL,
    [Demat_Insure] SMALLMONEY NULL,
    [Service_Tax] SMALLMONEY NULL,
    [Tax1] SMALLMONEY NULL,
    [Tax2] SMALLMONEY NULL,
    [Tax3] SMALLMONEY NULL,
    [Tax4] SMALLMONEY NULL,
    [Tax5] SMALLMONEY NULL,
    [Tax6] SMALLMONEY NULL,
    [Tax7] SMALLMONEY NULL,
    [Tax8] SMALLMONEY NULL,
    [Tax9] SMALLMONEY NULL,
    [Tax10] SMALLMONEY NULL,
    [Latest] CHAR(10) NULL,
    [State] CHAR(15) NULL,
    [FromDate] DATETIME NULL,
    [Todate] DATETIME NULL,
    [Round_To] INT NULL,
    [Rofig] INT NULL,
    [Errnum] DECIMAL(19, 8) NULL,
    [Nozero] INT NULL
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
-- TABLE dbo.FOAPP
-- --------------------------------------------------
CREATE TABLE [dbo].[FOAPP]
(
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_01082013new
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_01082013new]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_12Jun18
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_12Jun18]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_25022021
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_25022021]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_ADDITIONAL
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_ADDITIONAL]
(
    [BROKERID] VARCHAR(6) NOT NULL,
    [COMPANYNAME] VARCHAR(100) NOT NULL,
    [SEGMENT_DESCRIPTION] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(3) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [MEMBERTYPE] VARCHAR(3) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [SHAREDB] VARCHAR(20) NOT NULL,
    [SHARESERVER] VARCHAR(50) NULL,
    [SHAREIP] VARCHAR(15) NULL,
    [ACCOUNTDB] VARCHAR(20) NOT NULL,
    [ACCOUNTSERVER] VARCHAR(50) NULL,
    [ACCOUNTIP] VARCHAR(15) NULL,
    [DEFAULTDB] VARCHAR(20) NOT NULL,
    [DEFAULTDBSERVER] VARCHAR(50) NULL,
    [DEFAULTDBIP] VARCHAR(15) NULL,
    [DEFAULTCLIENT] INT NULL,
    [PANGIR_NO] VARCHAR(30) NULL,
    [PRIMARYSERVER] VARCHAR(10) NULL,
    [FILLER2] VARCHAR(10) NULL,
    [DBUSERNAME] VARCHAR(25) NULL,
    [DBPASSWORD] VARCHAR(25) NULL,
    [LICENSE] VARCHAR(500) NOT NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(12) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_ALL
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_ALL]
(
    [BROKERID] VARCHAR(6) NOT NULL,
    [COMPANYNAME] VARCHAR(100) NOT NULL,
    [SEGMENT_DESCRIPTION] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(3) NOT NULL,
    [SEGMENT] VARCHAR(20) NOT NULL,
    [MEMBERTYPE] VARCHAR(3) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [SHAREDB] VARCHAR(20) NOT NULL,
    [SHARESERVER] VARCHAR(15) NOT NULL,
    [SHAREIP] VARCHAR(15) NULL,
    [ACCOUNTDB] VARCHAR(20) NOT NULL,
    [ACCOUNTSERVER] VARCHAR(15) NOT NULL,
    [ACCOUNTIP] VARCHAR(15) NULL,
    [DEFAULTDB] VARCHAR(20) NOT NULL,
    [DEFAULTDBSERVER] VARCHAR(15) NOT NULL,
    [DEFAULTDBIP] VARCHAR(15) NULL,
    [DEFAULTCLIENT] INT NULL,
    [PANGIR_NO] VARCHAR(30) NULL,
    [PRIMARYSERVER] VARCHAR(10) NULL,
    [FILLER2] VARCHAR(10) NULL,
    [DBUSERNAME] VARCHAR(25) NULL,
    [DBPASSWORD] VARCHAR(25) NULL,
    [LICENSE] VARCHAR(500) NOT NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_Backup
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_Backup]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_BKP_12OCT2022
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_BKP_12OCT2022]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_BKP_13_10_2022
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_BKP_13_10_2022]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_BKP_20220404
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_BKP_20220404]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_BKP11OCT2022
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_BKP11OCT2022]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_BKUP_17Mar2023_NCE
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_BKUP_17Mar2023_NCE]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_BKUP_17Mar2024
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_BKUP_17Mar2024]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany_BKUP_24FEB2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany_BKUP_24FEB2023]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [ID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NOTRD
-- --------------------------------------------------
CREATE TABLE [dbo].[NOTRD]
(
    [branch_cd] VARCHAR(10) NULL,
    [party_count] INT NULL,
    [Trade_Count] INT NULL
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
-- TABLE dbo.pradnyamulticompany
-- --------------------------------------------------
CREATE TABLE [dbo].[pradnyamulticompany]
(
    [BrokerId] NVARCHAR(6) NULL,
    [CompanyName] NVARCHAR(100) NULL,
    [Exchange] NVARCHAR(3) NULL,
    [Segment] NVARCHAR(20) NULL,
    [MemberType] NVARCHAR(3) NULL,
    [MemberCode] NVARCHAR(15) NULL,
    [ShareDb] NVARCHAR(20) NULL,
    [ShareServer] NVARCHAR(15) NULL,
    [ShareIP] NVARCHAR(15) NULL,
    [AccountDb] NVARCHAR(20) NULL,
    [AccountServer] NVARCHAR(15) NULL,
    [AccountIP] NVARCHAR(15) NULL,
    [DefaultDb] NVARCHAR(20) NULL,
    [DefaultDbServer] NVARCHAR(10) NULL,
    [DefaultDbIP] NVARCHAR(10) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] NVARCHAR(30) NULL,
    [PrimaryServer] NVARCHAR(10) NULL,
    [Filler2] NVARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sebi_cl
-- --------------------------------------------------
CREATE TABLE [dbo].[sebi_cl]
(
    [PartyCode] NVARCHAR(50) NULL,
    [NSECM] NVARCHAR(50) NULL,
    [BSECM] NVARCHAR(50) NULL,
    [NSEFO] NVARCHAR(50) NULL,
    [NSECD] NVARCHAR(50) NULL,
    [MCXSX] NVARCHAR(50) NULL
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
-- TABLE dbo.TBL_BAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BAL]
(
    [RPT_DATE] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [LED_BAL] MONEY NULL,
    [MRG] MONEY NULL,
    [PLD_VAL] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BKApp_ISIN
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BKApp_ISIN]
(
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BKApp_ISIN_new
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BKApp_ISIN_new]
(
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BKG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BKG]
(
    [RPT_DATE] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [BKG] MONEY NULL,
    [B2C] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BO_BAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BO_BAL]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [LED_BAL] MONEY NULL,
    [MRG] MONEY NULL
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
-- TABLE dbo.tbl_Ex_ISIN
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Ex_ISIN]
(
    [Isin] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_H_PRINTFLAG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_H_PRINTFLAG]
(
    [PARTY_CODE] VARCHAR(11) NULL,
    [Q_MONTH] INT NULL,
    [Q1_TOT_BROK] NUMERIC(18, 4) NULL,
    [Q2_TOT_BROK] NUMERIC(18, 4) NULL,
    [Q3_TOT_BROK] NUMERIC(18, 4) NULL,
    [PRINT_FLAG] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_H_PRINTFLAG_CASH
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_H_PRINTFLAG_CASH]
(
    [PARTY_CODE] VARCHAR(11) NULL,
    [Q_MONTH] INT NULL,
    [Q1_TOT_BROK] NUMERIC(18, 4) NULL,
    [Q2_TOT_BROK] NUMERIC(18, 4) NULL,
    [Q3_TOT_BROK] NUMERIC(18, 4) NULL,
    [PRINT_FLAG] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_HOLD_TRACKING
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_HOLD_TRACKING]
(
    [EXCHANGE] VARCHAR(5) NOT NULL,
    [ACCNO] VARCHAR(16) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [SERIES] VARCHAR(3) NULL,
    [CERTNO] VARCHAR(16) NULL,
    [QTY] NUMERIC(38, 0) NULL,
    [CLSRATE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_OLD_BANACC
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_OLD_BANACC]
(
    [EXCHANGE] VARCHAR(5) NOT NULL,
    [ACCNO] VARCHAR(16) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [SERIES] VARCHAR(3) NULL,
    [CERTNO] VARCHAR(16) NULL,
    [QTY] NUMERIC(38, 0) NULL,
    [CLSRATE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_rcs_hdfcISIN
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_rcs_hdfcISIN]
(
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCLIENT_GROUP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCLIENT_GROUP]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TE
-- --------------------------------------------------
CREATE TABLE [dbo].[TE]
(
    [PARTY_CODE] VARCHAR(12) NULL,
    [POSTION] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UK
-- --------------------------------------------------
CREATE TABLE [dbo].[UK]
(
    [CLCODE] VARCHAR(10) NULL,
    [CM_B] VARCHAR(10) NULL,
    [CM_S] VARCHAR(10) NULL,
    [NSE_B] VARCHAR(10) NULL,
    [NSE_S] VARCHAR(10) NULL,
    [BSE_B] VARCHAR(10) NULL,
    [BSE_S] VARCHAR(10) NULL,
    [FO_B] VARCHAR(10) NULL,
    [FO_S] VARCHAR(10) NULL,
    [MCX_B] VARCHAR(10) NULL,
    [MCX_S] VARCHAR(10) NULL,
    [NCX_B] VARCHAR(10) NULL,
    [NCX_S] VARCHAR(10) NULL,
    [MyFlag] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Offline_multicompany
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Offline_multicompany]
(
    [BrokerId] VARCHAR(6) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [MemberType] VARCHAR(3) NULL,
    [MemberCode] VARCHAR(15) NULL,
    [ShareDb] VARCHAR(20) NULL,
    [ShareServer] VARCHAR(15) NULL,
    [ShareIP] VARCHAR(15) NULL,
    [AccountDb] VARCHAR(20) NULL,
    [AccountServer] VARCHAR(15) NULL,
    [AccountIP] VARCHAR(15) NULL,
    [DefaultDb] VARCHAR(20) NULL,
    [DefaultDbServer] VARCHAR(20) NULL,
    [DefaultDbIP] VARCHAR(15) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [PrimaryServer] VARCHAR(10) NULL,
    [Filler2] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.W_AHMEDABAD
-- --------------------------------------------------
CREATE TABLE [dbo].[W_AHMEDABAD]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [L_City] VARCHAR(40) NULL,
    [l_Zip] VARCHAR(10) NULL,
    [L_State] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.ACC_MULTICOMPANY
-- --------------------------------------------------
CREATE VIEW [ACC_MULTICOMPANY]     
    
AS    
    
  SELECT BROKERID,    
         COMPANYNAME,    
         EXCHANGE,    
         SEGMENT,    
         MEMBERTYPE,    
         MEMBERCODE,    
         SHAREDB,    
         SHARESERVER = DBO.ReplaceServerName(SHARESERVER),    
         SHAREIP,    
         ACCOUNTDB,    
         ACCOUNTSERVER = DBO.ReplaceServerName(ACCOUNTSERVER),    
         ACCOUNTIP,    
         DEFAULTDB,    
         DEFAULTDBSERVER = DBO.ReplaceServerName(DEFAULTDBSERVER),    
         DEFAULTDBIP,    
         DEFAULTCLIENT,    
         PANGIR_NO,    
         PRIMARYSERVER = DBO.ReplaceServerName(PRIMARYSERVER),    
         FILLER2,    
         DBUSERNAME,    
         DBPASSWORD,  
   Segment_Description     
  FROM   MULTICOMPANY

GO

-- --------------------------------------------------
-- VIEW dbo.angel_Client_Category
-- --------------------------------------------------

CREATE view [dbo].[angel_Client_Category]
as
select client as party_code,Category from [CSOKYC-6].general.dbo.Vw_RMS_Client_Vertical with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.AUDIT_MULTICOMPANY_ALL
-- --------------------------------------------------


--SELECT TOP 1 * FROM AUDIT_MULTICOMPANY_ALL WHERE SEGMENT = 'MFSS'
CREATE VIEW [dbo].[AUDIT_MULTICOMPANY_ALL] 
AS

SELECT distinct ACCOUNTSERVER, ACCOUNTDB, EXCHANGE, SEGMENT FROM MULTICOMPANY --where segment='CAPITAL'

GO

-- --------------------------------------------------
-- VIEW dbo.AUDIT_MULTICOMPANY_ALL_NEW
-- --------------------------------------------------
  
  
  
   
--SELECT TOP 1 * FROM AUDIT_MULTICOMPANY_ALL WHERE SEGMENT = 'MFSS'  
CREATE VIEW [dbo].[AUDIT_MULTICOMPANY_ALL_NEW]   
AS  
  
SELECT ACCOUNTSERVER, ACCOUNTDB, EXCHANGE, SEGMENT, SHAREDB FROM ACCOUNT..COMPANY_MASTER_SETTING  where segment <> 'NBFC'

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_MULTICOMPANY
-- --------------------------------------------------

  
  
CREATE  VIEW [dbo].[CLS_MULTICOMPANY]  
AS  
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,
  
  
LICENSE='',APPSHARE_ROOTFLDR_NAME,CATEGORY,PAYMENT_BANK =NULL,EXCHANGEGROUP ='EQ'  
FROM MULTICOMPANY  
WHERE SEGMENT_DESCRIPTION <>'BSE F&O'  
  
UNION ALL  
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD 
 
,LICENSE='',APPSHARE_ROOTFLDR_NAME ,'EQUITY','' ,'EQ' FROM MULTICOMPANY_ADDITIONAL  
--SELECT '0612','ANGEL CAPITAL AND DEBT MARKET LTD.','BSE MFSS','BSE', 'MFSS', 'TM ', '0612', 'BSEMFSS', 'ANGELFO','AngelFO','BBO_FA', 'ANGELFO','AngelFO',  
--'BSEMFSS', 'ANGELFO','AngelFO', 0, '1' , '1','0','CLSANGEL', 'ANGELCLASS' ,'' , 'CGI-BIN1' ,'EQUITY',NULL,'EQ'  
--FROM MULTICOMPANY_ALL  
--WHERE EXCHANGE ='BSE'

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_MULTICOMPANY_BKP_01OCT_2022
-- --------------------------------------------------

  
  
CREATE  VIEW [dbo].[CLS_MULTICOMPANY_BKP_01OCT_2022]  
AS  
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,
  
  
LICENSE='',APPSHARE_ROOTFLDR_NAME,CATEGORY,PAYMENT_BANK =NULL,EXCHANGEGROUP ='EQ'  
FROM MULTICOMPANY  
WHERE SEGMENT_DESCRIPTION <>'BSE F&O'  
  
UNION ALL  
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD 
 
,LICENSE='',APPSHARE_ROOTFLDR_NAME ,'EQUITY','' ,'EQ' FROM MULTICOMPANY_ALL  
--SELECT '0612','ANGEL CAPITAL AND DEBT MARKET LTD.','BSE MFSS','BSE', 'MFSS', 'TM ', '0612', 'BSEMFSS', 'ANGELFO','AngelFO','BBO_FA', 'ANGELFO','AngelFO',  
--'BSEMFSS', 'ANGELFO','AngelFO', 0, '1' , '1','0','CLSANGEL', 'ANGELCLASS' ,'' , 'CGI-BIN1' ,'EQUITY',NULL,'EQ'  
--FROM MULTICOMPANY_ALL  
--WHERE EXCHANGE ='BSE'

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_NON_MULTICOMPANY
-- --------------------------------------------------
CREATE VIEW [dbo].[CLS_NON_MULTICOMPANY]
AS
	SELECT 
		BROKERID ='1',COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,
		MEMBERTYPE='',
		MEMBERCODE='',
		SHAREDB,SHARESERVER,
		SHAREIP = (SELECT TOP 1 SHAREIP FROM MULTICOMPANY_ALL),
		ACCOUNTDB,
		ACCOUNTSERVER,
		ACCOUNTIP = (SELECT TOP 1 ACCOUNTIP FROM MULTICOMPANY_ALL),
		DEFAULTDB = (SELECT TOP 1 DEFAULTDB FROM MULTICOMPANY_ALL),
		DEFAULTDBSERVER = (SELECT TOP 1 DEFAULTDBSERVER FROM MULTICOMPANY_ALL),
		DEFAULTDBIP = (SELECT TOP 1 DEFAULTDBIP FROM MULTICOMPANY_ALL),
		DEFAULTCLIENT = (SELECT TOP 1 DEFAULTCLIENT FROM MULTICOMPANY_ALL),
		PANGIR_NO = (SELECT TOP 1 PANGIR_NO FROM MULTICOMPANY_ALL),
		PRIMARYSERVER = (SELECT TOP 1 PRIMARYSERVER FROM MULTICOMPANY_ALL),
		FILLER2  = (SELECT TOP 1 FILLER2 FROM MULTICOMPANY_ALL),
		DBUSERNAME  = (SELECT TOP 1 DBUSERNAME FROM MULTICOMPANY_ALL),
		DBPASSWORD  = (SELECT TOP 1 DBPASSWORD FROM MULTICOMPANY_ALL),
		LICENSE  = (SELECT TOP 1 LICENSE FROM MULTICOMPANY_ALL),
		APPSHARE_ROOTFLDR_NAME  = (SELECT TOP 1 APPSHARE_ROOTFLDR_NAME FROM MULTICOMPANY_ALL),
		CATEGORY  = (SELECT TOP 1 CATEGORY FROM MULTICOMPANY),
		PAYMENT_BANK  = (SELECT TOP 1 PAYMENT_BANK FROM MULTICOMPANY),
		EXCHANGEGROUP = (SELECT TOP 1 EXCHANGEGROUP FROM MULTICOMPANY)
	 FROM 
		ACCOUNT..COMPANY_MASTER_SETTING WHERE MULTICOMPANY = 0

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_OWNER_VW
-- --------------------------------------------------


    
CREATE VIEW [dbo].[CLS_OWNER_VW] AS   
SELECT 'NSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM MSAJAG.DBO.OWNER   
----UNION ALL   
----SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB.DBO.OWNER   
------UNION ALL   
------SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL='',WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME='',COMPLIANCE_EMAIL='',COMPLIANCE_PHONE='',COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB.DBO.OWNER   
----UNION ALL   
----SELECT 'NSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NSEFO.DBO.FOOWNER   
----UNION ALL   
----SELECT 'BSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEFO.DBO.bfoowner   --select *from  CLS_OWNER_VW       
----UNION ALL 
----SELECT 'NCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
----UNION ALL   
----SELECT 'MCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
  
--OWNER_VW

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_SETT_MASTER_COMMON
-- --------------------------------------------------


CREATE VIEW [dbo].[CLS_SETT_MASTER_COMMON]
AS
SELECT EXCHANGE, SEGMENT = 'CAPITAL', SETT_TYPE, SETT_NO, SERIES FROM MSAJAG..SETT_MST
--UNION ALL 
--SELECT EXCHANGE, SEGMENT = 'CAPITAL', SETT_TYPE, SETT_NO, SERIES FROM BSEDB..SETT_MST

GO

-- --------------------------------------------------
-- VIEW dbo.MULTICOMPANY_ALL_suresh
-- --------------------------------------------------


create view MULTICOMPANY_ALL_suresh
as
SELECT  Distinct Segment_Description, AppShare_RootFldr_Name FROM angelfo.Pradnya.dbo.MULTICOMPANY_ADDITIONAL
union  all
Select Distinct Segment_Description, AppShare_RootFldr_Name from MultiCompany

GO

-- --------------------------------------------------
-- VIEW dbo.MULTICOMPANY_ALL_TEST
-- --------------------------------------------------



create view [dbo].[MULTICOMPANY_ALL_TEST]
as

select 
EXCHANGE ,    
    
   SEGMENT ,    
    
   SHARESERVER,    
    
   ACCOUNTDB,    
    
   ACCOUNTSERVER    
    
  FROM PRADNYA..MULTICOMPANY M(NOLOCK) where segment='capital' 
  and PrimaryServer='1'

GO

-- --------------------------------------------------
-- VIEW dbo.VW_REPORTING_MULTICOMPANY
-- --------------------------------------------------

CREATE VIEW VW_REPORTING_MULTICOMPANY

AS

SELECT * FROM MULTICOMPANY WHERE PRIMARYSERVER = 1

GO

-- --------------------------------------------------
-- VIEW dbo.VW_REPORTING_MULTICOMPANY_ALL
-- --------------------------------------------------


CREATE VIEW [dbo].[VW_REPORTING_MULTICOMPANY_ALL]

AS

SELECT BrokerId,CompanyName,Exchange,Segment,MemberType,MemberCode,ShareDb,ShareServer,ShareIP,AccountDb,AccountServer,AccountIP,DefaultDb,DefaultDbServer,DefaultDbIP,DefaultClient,PANGIR_No,PrimaryServer,Filler2,dbusername,dbpassword
 FROM MULTICOMPANY WHERE PRIMARYSERVER = 1 
UNION 
SELECT BrokerId,CompanyName,Exchange,Segment,MemberType,MemberCode,ShareDb,ShareServer,ShareIP,AccountDb,AccountServer,AccountIP,DefaultDb,DefaultDbServer,DefaultDbIP,DefaultClient,PANGIR_No,PrimaryServer,Filler2,dbusername,dbpassword 
FROM MULTICOMPANY_ALL WHERE PRIMARYSERVER = 1 


--SELECT top 1  * FROM MULTICOMPANY
--go
--SELECT top 1 * FROM MULTICOMPANY_ALL

GO

