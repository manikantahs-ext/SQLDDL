-- DDL Export
-- Server: 10.253.50.28
-- Database: PRADNYA
-- Exported: 2026-01-30T12:58:00.661057

USE PRADNYA;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.REPORTDETAILS_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[REPORTDETAILS_NEW] ADD CONSTRAINT [FK_ReportDetails_NEW_ReportMaster_NEW] FOREIGN KEY ([RD_Report_Code]) REFERENCES [dbo].[REPORTMASTER_NEW] ([RM_Report_Code])

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
-- FUNCTION dbo.CLS_FUN_SPLITSTRING
-- --------------------------------------------------




CREATE FUNCTION [dbo].[CLS_FUN_SPLITSTRING](
                @SPLITSTRING VARCHAR(8000),
                @DELIMITER   VARCHAR(3))
RETURNS @SPLITTED TABLE (
    [SNO] [INT] IDENTITY(1,1) NOT NULL, 
    [SPLITTED_VALUE] [VARCHAR](100) NOT NULL)

AS

/* SPLIT THE STRING AND GET SPLITTED VALUES IN THE RESULT-SET. DELIMITER UPTO 3 CHARACTERS LONG CAN BE USED FOR SPLITTING */
BEGIN   
  DECLARE  @STRING         VARCHAR(8000),
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
-- FUNCTION dbo.CLS_FUN_SPLITSTRING_2NUM
-- --------------------------------------------------




CREATE FUNCTION [dbo].[CLS_FUN_SPLITSTRING_2NUM](
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
-- FUNCTION dbo.CLS_ReplaceTradeNo
-- --------------------------------------------------



CREATE FUNCTION [dbo].[CLS_ReplaceTradeNo](@TRADENO  VARCHAR(30))   
RETURNS VARCHAR(30) AS  
BEGIN  
DECLARE @FLAG CHAR(1)
DECLARE @INTLNG INT
DECLARE @INTCNT INT
SELECT @INTLNG = LEN(@TRADENO)
SET @INTCNT = 0

 WHILE @INTCNT < @INTLNG
 BEGIN  
	  SELECT @FLAG = LEFT(UPPER(@TRADENO),1)  
	  SET @INTCNT = @INTCNT + 1

	  IF ASCII(@FLAG) >= 65 AND ASCII(@FLAG) <= 90
	   SELECT @TRADENO = REPLACE(@TRADENO, @FLAG, '')  
 END  
RETURN @TRADENO   
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.CLS_SPLIT
-- --------------------------------------------------

CREATE FUNCTION [dbo].[CLS_SPLIT]  
(  
 @STRING NVARCHAR(MAX),   
 @DELIMITER CHAR(1)  
)  
  
RETURNS @RESULTS  TABLE (ITEMS NVARCHAR(4000))  
  
AS  
  
/*  
 SELECT * FROM SPLIT('A,B,C!', ',')  
*/  
  
BEGIN  
    DECLARE @INDEX INT  
    DECLARE @SLICE NVARCHAR(4000)  
    SELECT @INDEX = 1  
    IF @STRING IS NULL RETURN  
    WHILE @INDEX !=0  
  
        BEGIN   
         -- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER  
         SELECT @INDEX = CHARINDEX(@DELIMITER,@STRING)  
   
      -- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE  
         IF @INDEX !=0  
          SELECT @SLICE = LEFT(@STRING,@INDEX - 1)  
         ELSE  
          SELECT @SLICE = @STRING  
         -- PUT THE ITEM INTO THE RESULTS SET  
    
     INSERT INTO @RESULTS(ITEMS) VALUES(@SLICE)  
         -- CHOP THE ITEM REMOVED OFF THE MAIN STRING  
         SELECT @STRING = RIGHT(@STRING,LEN(@STRING) - @INDEX)  
         -- BREAK OUT IF WE ARE DONE  
         IF LEN(@STRING) = 0 BREAK  
    END 
 
    RETURN  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_CLASS_Auto_Process_Replace
-- --------------------------------------------------







CREATE FUNCTION [dbo].[fn_CLASS_Auto_Process_Replace]
(
	@PARAMETER		VARCHAR(500), 
	@BUSINESS_DATE	DATETIME, 
	@MEMBERCODE		VARCHAR(10),
	@SETT_NO		VARCHAR(7),
	@SETT_TYPE		VARCHAR(2)
) RETURNS VARCHAR(500)
AS
BEGIN

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

	RETURN @PARAMETER
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
-- FUNCTION dbo.FUN_GET_TBLREPORT
-- --------------------------------------------------
CREATE  FUNCTION [DBO].[FUN_GET_TBLREPORT](  
                @OLDSTRING VARCHAR(2000),  
                @NEWSTRING VARCHAR(2000))  
RETURNS  VARCHAR (8000)
AS

  
BEGIN 

    DECLARE @RETURNSTR VARCHAR(8000)
    SET @RETURNSTR =''

    DECLARE @DIFF_STRING  TABLE(  
    [STR1_VALUE] [VARCHAR](100) NOT NULL,  
    [STR2_VALUE] [VARCHAR](100) NOT NULL)  

    DECLARE      
	@REPCODE1 VARCHAR(10),
	@REPCODE2 VARCHAR(10),
	@TBLREPCUR CURSOR ,     
        @CATNAME VARCHAR(20)
  
  
	INSERT INTO @DIFF_STRING
	SELECT 
		STR1= CASE WHEN A.SPLITTED_VALUE IS NOT NULL THEN A.SPLITTED_VALUE ELSE '' END,
		STR2= CASE WHEN B.SPLITTED_VALUE IS NOT NULL THEN B.SPLITTED_VALUE ELSE '' END
	FROM
	(
		SELECT * FROM PRADNYA..FUN_SPLITSTRING(@OLDSTRING,',')
	) A
	 FULL OUTER JOIN
	(
		SELECT * FROM PRADNYA..FUN_SPLITSTRING(@NEWSTRING,',')
	) B
	 ON (A.SPLITTED_VALUE=B.SPLITTED_VALUE)
	WHERE A.SPLITTED_VALUE IS NULL OR B.SPLITTED_VALUE IS NULL
	

	SET @TBLREPCUR = CURSOR FOR  SELECT ISNULL(STR1_VALUE,''),ISNULL(STR2_VALUE,'') FROM  @DIFF_STRING
	OPEN @TBLREPCUR      
	     
	FETCH NEXT FROM @TBLREPCUR INTO @REPCODE1,@REPCODE2
	WHILE @@FETCH_STATUS = 0       
	BEGIN      
	      
	
	 IF @REPCODE1<>''
		BEGIN
			SET @CATNAME = NULL
			SELECT @CATNAME =FLDCATEGORYNAME FROM TBLCATEGORY (NOLOCK) WHERE FLDCATEGORYCODE = CONVERT(INT,@REPCODE1)
			SELECT @RETURNSTR = @RETURNSTR + '-' + ISNULL(@CATNAME,@REPCODE1) +', '
		END
	IF @REPCODE2<>''
		BEGIN
			SET @CATNAME = NULL
			SELECT @CATNAME =FLDCATEGORYNAME FROM TBLCATEGORY (NOLOCK)  WHERE FLDCATEGORYCODE = CONVERT(INT,@REPCODE2)
			SELECT @RETURNSTR = @RETURNSTR + '+' + ISNULL(@CATNAME,@REPCODE2) +', '
		END

	    
	 FETCH NEXT FROM @TBLREPCUR INTO @REPCODE1,@REPCODE2
	END      
	CLOSE @TBLREPCUR      
	DEALLOCATE @TBLREPCUR
     

	RETURN LEFT(@RETURNSTR,LEN(@RETURNSTR)-1)

END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING
-- --------------------------------------------------



CREATE FUNCTION [dbo].[FUN_SPLITSTRING](
                @SPLITSTRING VARCHAR(8000),
                @DELIMITER   VARCHAR(3))
RETURNS @SPLITTED TABLE (
    [SNO] [INT] IDENTITY(1,1) NOT NULL, 
    [SPLITTED_VALUE] [VARCHAR](100) NOT NULL)

AS

/* SPLIT THE STRING AND GET SPLITTED VALUES IN THE RESULT-SET. DELIMITER UPTO 3 CHARACTERS LONG CAN BE USED FOR SPLITTING */
BEGIN   
  DECLARE  @STRING         VARCHAR(8000),
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
-- FUNCTION dbo.FUN_SPLITSTRING_BKUP_13Nov2019
-- --------------------------------------------------

CREATE FUNCTION [dbo].[FUN_SPLITSTRING_BKUP_13Nov2019](
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

CREATE Function [dbo].[ReplaceTradeNo](@TradeNo  Varchar(20)) 
Returns Varchar(20) As
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
-- INDEX dbo.CHARTSPECS
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_CHARTSPECS] ON [dbo].[CHARTSPECS] ([REPORTCODE])

GO

-- --------------------------------------------------
-- INDEX dbo.CLS_F2CONFIG
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxcd] ON [dbo].[CLS_F2CONFIG] ([F2CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.CLS_PROCESSSTATUS
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IDX_SESSIONID] ON [dbo].[CLS_PROCESSSTATUS] ([SESSION_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CHARTSPECS
-- --------------------------------------------------
ALTER TABLE [dbo].[CHARTSPECS] ADD CONSTRAINT [IX_CHARTSPECS] UNIQUE ([REPORTCODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.NumberWords
-- --------------------------------------------------
ALTER TABLE [dbo].[NumberWords] ADD CONSTRAINT [PK__NumberWo__78A1A19C62AFA012] PRIMARY KEY ([Number])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.REPORTMASTER_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[REPORTMASTER_NEW] ADD CONSTRAINT [PK_REPORTMASTER_NEW] PRIMARY KEY ([RM_Report_Code])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_GETSQLCONTROLDATA
-- --------------------------------------------------


create PROC [dbo].[CBO_GETSQLCONTROLDATA]

AS

SELECT
	SQL_KEY,
	SQL_SUPPLEMENT
FROM
	CBO_SQLCONTROL
ORDER BY
	SNO

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
 @TOCODE VARCHAR(15)='zzzzzzzzzz',  
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
 PRADNYA.DBO.TBL_ECNCASH with (NOLOCK)  
WHERE  
 PARENTCODE BETWEEN @FROMPARTYCODE AND @TOPARTYCODE  
 AND (  
 CASE  
  WHEN @RPT_BY = 'FAMILY'  THEN FAMILY  
  WHEN @RPT_BY = 'REGION'  THEN REGION  
  WHEN @RPT_BY = 'AREA'  THEN AREA  
  WHEN @RPT_BY = 'BRANCH'  THEN BRANCH_CD  
  WHEN @RPT_BY = 'SUB_BROKER' THEN SUB_BROKER  
  WHEN @RPT_BY = 'TRADER'  THEN TRADER  
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
 MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),                       
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
 SUM(PQTYTRD) - SUM(SQTYTRD) <> 0             OR SUM(SAMTTRD)-SUM(PAMTTRD) <> 0                          
                          
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
 MSAJAG.DBO.CMBILLVALAN C with(NOLOCK),  
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
 MSAJAG.DBO.CMBILLVALAN C with (NOLOCK),  
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
 LONG_NAME = C1.LONG_NAME,  
 BRANCH_CD = C1.BRANCH_CD,  
 SUB_BROKER = C1.SUB_BROKER,  
 L_ADDRESS1 = C1.L_ADDRESS1,  
 L_ADDRESS2 = C1.L_ADDRESS2,  
 L_ADDRESS3 = C1.L_ADDRESS3,  
 L_CITY  = C1.L_CITY,  
 L_STATE  = C1.L_STATE,  
 L_ZIP  = C1.L_ZIP,  
 MOBILE_PAGER= C1.MOBILE_PAGER,  
 RES_PHONE1 = C1.RES_PHONE1,  
 RES_PHONE2 = C1.RES_PHONE2,  
 OFF_PHONE1 = C1.OFF_PHONE1  
FROM  
 PRADNYA.DBO.TBL_ECNCASH C1 (NOLOCK)  
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

CREATE PROC [dbo].[CLS_ADMIN_GET_EXCHANGE_SEGMENT]  
AS  
SELECT EXCHANGE, SEGMENT, DISPLAY = EXCHANGE + ' ' + SEGMENT FROM PRADNYA..MULTICOMPANY WHERE PRIMARYSERVER = 1 ORDER BY 3

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_CLIENT_DETAILS_NEW
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_CLIENT_DETAILS_NEW]  
(  
 @PARTY_CODE VARCHAR(10),
 @STATUSID  VARCHAR(30) = 'BROKER',
 @STATUSNAME VARCHAR(30) = 'BROKER'
)  
AS
BEGIN

--exec pradnya..cls_client_details_new @PARTY_CODE='0a141'



CREATE TABLE #TEMP1
(
	CL_CODE VARCHAR(20),  
	EXCHANGE VARCHAR(20),
	SEGMENT VARCHAR(20),
	LONG_NAME VARCHAR(200), 
	AREA VARCHAR(20),
	REGION VARCHAR(20),
	BRANCH_CD VARCHAR(20),
	SUB_BROKER VARCHAR(100),
	TRADER VARCHAR(100),
	FAMILY VARCHAR(100), 
	SHORT_NAME VARCHAR(200),  
	L_ADDRESS1 VARCHAR(300) ,
	L_ADDRESS2 VARCHAR(300),
	L_ADDRESS3 VARCHAR(300) ,
	L_CITY VARCHAR(50),
	L_ZIP  VARCHAR(10),
	L_STATE  VARCHAR(50) ,
	L_NATION  VARCHAR(50),
	PAN_GIR_NO  VARCHAR(20),
	RES_PHONE1  VARCHAR(20),
	RES_PHONE2  VARCHAR(20),
	OFF_PHONE1  VARCHAR(20),
	OFF_PHONE2  VARCHAR(20),
	MOBILE_PAGER  VARCHAR(20),
	FAX  VARCHAR(20),
	EMAIL  VARCHAR(MAX),
	DOB VARCHAR(11),
	CL_TYPE  VARCHAR(50),  
	BANK_NAME  VARCHAR(200),
	BRANCH_NAME  VARCHAR(200),
	AC_TYPE  VARCHAR(50),
	AC_NUM  VARCHAR(50),
	IFSCCODE VARCHAR(50) DEFAULT(''),
	PAY_PAYMENT_MODE  VARCHAR(50),
	POA1 VARCHAR(10),
	POA2 VARCHAR(10),
	POA3 VARCHAR(10),
	DPTYPE  VARCHAR(100),
	DPTYPE2  VARCHAR(100),
	DPTYPE3  VARCHAR(50),
	DPID  VARCHAR(100),
	DPNAME  VARCHAR(500),
	DPNAME2  VARCHAR(500) DEFAULT '',
	DPNAME3  VARCHAR(500) DEFAULT '',
	DPACCOUNTNO  VARCHAR(50),
	DPID2  VARCHAR(50),
	DPID3 VARCHAR(50) ,
	CLTDPID2  VARCHAR(50),
	CLTDPID3  VARCHAR(50),
	ACTIVE_DATE VARCHAR(11),
	INACTIVE_FROM VARCHAR(11)
)


INSERT INTO #TEMP1
(
	CL_CODE,  
	EXCHANGE ,
	SEGMENT ,
	LONG_NAME , 
	AREA ,
	REGION,
	BRANCH_CD ,
	SUB_BROKER ,
	TRADER ,
	FAMILY, 
	SHORT_NAME ,  
	L_ADDRESS1  ,
	L_ADDRESS2 ,
	L_ADDRESS3  ,
	L_CITY ,
	L_ZIP  ,
	L_STATE ,
	L_NATION  ,
	PAN_GIR_NO ,
	RES_PHONE1 ,
	RES_PHONE2 ,
	OFF_PHONE1 ,
	OFF_PHONE2 ,
	MOBILE_PAGER,
	FAX,
	EMAIL,
	DOB,
	CL_TYPE,  
	BANK_NAME,
	BRANCH_NAME,
	AC_TYPE,
	AC_NUM ,
	IFSCCODE,
	PAY_PAYMENT_MODE,
	POA1,
	POA2,
	POA3,
	DPTYPE,
	DPTYPE2,
	DPTYPE3,
	DPID  ,
	DPNAME,
	DPNAME2,
	DPNAME3,
	DPACCOUNTNO,
	DPID2,
	DPID3,
	CLTDPID2  ,
	CLTDPID3  ,
	ACTIVE_DATE,
	INACTIVE_FROM
)
SELECT 
	B.CL_CODE,  
	B.EXCHANGE,B.SEGMENT,C.LONG_NAME, 
	C.AREA,C.REGION,C.BRANCH_CD,C.SUB_BROKER,C.TRADER,C.FAMILY, 
	C.SHORT_NAME,  
	C.L_ADDRESS1 ,L_ADDRESS2 ,L_ADDRESS3 ,
	L_CITY ,L_ZIP ,L_STATE ,L_NATION,
	C.PAN_GIR_NO,
	C.RES_PHONE1,C.RES_PHONE2,C.OFF_PHONE1,C.OFF_PHONE2,
	C.MOBILE_PAGER,C.FAX,C.EMAIL,
	CONVERT(VARCHAR,C.DOB, 103) AS DOB,
	C.CL_TYPE,  
	C.BANK_NAME,C.BRANCH_NAME,C.AC_TYPE,C.AC_NUM,IFSCCODE='',
	B.PAY_PAYMENT_MODE,C.POA1,C.POA2,C.POA3,
	--B1.BANKNAME AS DPNAME,
	C.DEPOSITORY1 AS DPTYPE,C.DEPOSITORY2 AS DPTYPE2,C.DEPOSITORY3 AS DPTYPE3,C.DPID1 AS DPID,B1.BANKNAME AS DPNAME,'','',C.CLTDPID1 AS DPACCOUNTNO,C.DPID2,C.DPID3 ,C.CLTDPID2,C.CLTDPID3,
	CONVERT(VARCHAR,B.ACTIVE_DATE, 103) AS ACTIVE_DATE,
	CONVERT(VARCHAR,B.INACTIVE_FROM, 103) AS INACTIVE_FROM
	

FROM 
	MSAJAG..CLIENT_BROK_DETAILS B,MSAJAG..CLIENT_DETAILS C LEFT OUTER JOIN MSAJAG..BANK B1 ON C.DPID1 = B1.BANKID --,MSAJAG..POBANK P
 
WHERE  
	C.CL_CODE = @PARTY_CODE
	AND C.CL_CODE=B.CL_CODE   
	--AND C.DPID1 = B1.BANKID
	AND @STATUSNAME = 
         (CASE WHEN @STATUSID = 'AREA' THEN AREA 
         WHEN @STATUSID = 'REGION' THEN REGION 
         WHEN @STATUSID =  'BRANCH' THEN BRANCH_CD 
         WHEN @STATUSID =  'SUBBROKER' THEN SUB_BROKER 
         WHEN @STATUSID =  'TRADER' THEN TRADER 
         WHEN @STATUSID =  'FAMILY' THEN FAMILY 
         WHEN @STATUSID =  'CLIENT' THEN C.CL_CODE 
         WHEN @STATUSID =  'BROKER' THEN @STATUSNAME
         ELSE 'I DONT KNOW ' END)
         
         
    

UPDATE #TEMP1
SET IFSCCODE = 
ISNULL((
	SELECT POBANK.IFSCCODE FROM MSAJAG..CLIENT_DETAILS C, MSAJAG..POBANK  POBANK
	WHERE POBANK.BANK_NAME = C.BANK_NAME 
	AND POBANK.BRANCH_NAME = C.BRANCH_NAME
	AND CONVERT(VARCHAR(20),POBANK.BANKID) = C.BANK_ID	
	--AND POBANK.IFSCCODE = C.BANK_ID
	AND C.CL_CODE=@PARTY_CODE),'')

UPDATE #TEMP1 
SET DPNAME2 = ISNULL((SELECT  BANKNAME 
				FROM MSAJAG..CLIENT_DETAILS C,MSAJAG..BANK B
				WHERE C.CL_CODE = @PARTY_CODE AND
				C.DPID2 = B.BANKID),'')

UPDATE #TEMP1 
SET DPNAME3 = ISNULL((SELECT BANKNAME 
				FROM MSAJAG..CLIENT_DETAILS C,MSAJAG..BANK B
				WHERE C.CL_CODE= @PARTY_CODE AND
				C.DPID3 = B.BANKID),'')

SELECT * FROM #TEMP1
DROP TABLE #TEMP1


END

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
-- PROCEDURE dbo.CLS_COMPDETAILS
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_COMPDETAILS]
(
	--@SHAREDB VARCHAR(20),
	@EXCHANGE VARCHAR(15),
    @SEGMENT VARCHAR(15)
)
AS
BEGIN

--CREATE TABLE #DUMMY
--(
--	COMPANY	VARCHAR(50),
--	ADDR1	VARCHAR(30),
--	ADDR2	VARCHAR(30),
--	PHONE	VARCHAR(15),
--	ZIP	VARCHAR(6),
--	CITY	VARCHAR(15),
--	EMAIL	VARCHAR(50),
--	EXCHANGE VARCHAR(20),
--	--COUNTROWS INT 
--)

	--DECLARE @SQL VARCHAR(MAX),@SEGMENT VARCHAR(10)
	--SELECT @SEGMENT = SEGMENT FROM CLS_MULTICOMPANY WHERE SHAREDB = @SHAREDB AND PRIMARYSERVER = 1
	
	DECLARE @SQL VARCHAR(MAX),@SHAREDB VARCHAR(10)
    SELECT @SHAREDB = SHAREDB FROM PRADNYA..CLS_MULTICOMPANY WHERE EXCHANGE=@EXCHANGE AND SEGMENT=@SEGMENT
	
	
	--SET @SQL = "INSERT INTO #DUMMY "
	SET @SQL = "SELECT COMPANY, ADDR1, ADDR2, PHONE, ZIP, CITY, EMAIL,FAX = " + CASE WHEN  UPPER(@SEGMENT) = 'FUTURES' THEN "''" ELSE 'FAX' END + ", EXCHANGE = '"+@EXCHANGE+"',SEGMENT = '"+@SEGMENT+"' FROM "
	SET @SQL = @SQL + @SHAREDB + ".." + CASE WHEN @SEGMENT = 'FUTURES' THEN 'FOOWNER' ELSE 'OWNER' END
	
	
	
	--SET @SQL = @SQL + " UPDATE #DUMMY "
	--SET @SQL = @SQL + " SET COUNTROWS =(SELECT COUNT(1) FROM " + @SHAREDB + "..FOSETTLEMENT WHERE LEFT(CONVERT(VARCHAR,EXPIRYDATE,109),11) LIKE '"+ @SAUDADATE +"%' ) "  
	PRINT @SQL
	
	
	EXEC(@SQL)
	--SELECT * FROM #DUMMY

	
END

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
	--PRINT @@SQL
	EXEC(@@SQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_EXECUTEF2
-- --------------------------------------------------

    
CREATE PROC [dbo].[CLS_EXECUTEF2]
(      
 @F2CODE VARCHAR(10),      
 @F2PARAMS VARCHAR(500),      
 @F2WHFLDS VARCHAR(1000) = '',      
 @F2WHVALS VARCHAR(1000) = '',      
 @F2WHOPR VARCHAR(100) = '',      
 @USEXML BIT = 1,      
 @EXCHANGE VARCHAR(10),      
 @SEGMENT VARCHAR(10),      
 @WINDOWTITLE VARCHAR(100) = '' OUTPUT,      
 @TABLEHEADER VARCHAR(200) = '' OUTPUT,      
 @STATUSID VARCHAR(25) = 'BROKER',      
 @STATUSNAME VARCHAR(25) = 'BROKER'      
)      
AS      

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
 @PARAMNAME VARCHAR(30),      
 @PARAMVAL VARCHAR(500),      
 @PARAMOPR VARCHAR(8),      
 @PARAMOPRLIST VARCHAR(100),      
 @ORDERLIST VARCHAR(100),      
 @CONNECTIONDB VARCHAR(1),      
 @SQL NVARCHAR(MAX),      
 @DBNAME VARCHAR(256),      
 @MULTISERVER VARCHAR(256)      
 SET @DBNAME = ''      
 SET @MULTISERVER = ''      
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
  @CONNECTIONDB = ISNULL(CONNECTIONDB, 'A')      
 FROM      
  CLS_F2CONFIG      
 WHERE      
  F2CODE = @F2CODE      
 IF @CONNECTIONDB = ''      
  BEGIN      
   SET @CONNECTIONDB = 'A'      
  END      
 IF @OBJNAME = '' OR @OBJNAME IS NULL      
  BEGIN      
   RAISERROR('F2 Reference Code not found...', 16, 1)      
  END      
      
      
   IF @CONNECTIONDB = 'A' OR @CONNECTIONDB = 'S'      
    BEGIN      
     SELECT      
      @DBNAME = CASE WHEN @CONNECTIONDB = 'A' THEN ACCOUNTDB ELSE SHAREDB END,      
      @MULTISERVER = CASE WHEN @CONNECTIONDB = 'A' THEN ACCOUNTSERVER ELSE SHARESERVER END      
     FROM      
      PRADNYA..CLS_MULTICOMPANY
     WHERE      
      PRIMARYSERVER = 1      
      AND EXCHANGE = @EXCHANGE      
      AND SEGMENT = @SEGMENT      
    END      
   ELSE IF @CONNECTIONDB = 'D'      
    BEGIN      
     SELECT      
      @DBNAME = SHAREDB,      
      @MULTISERVER = CASE WHEN @CONNECTIONDB = 'A' THEN ACCOUNTSERVER ELSE SHARESERVER END      
     FROM      
      PRADNYA..CLS_MULTICOMPANY      
     WHERE      
      PRIMARYSERVER <> 1      
      AND EXCHANGE = @EXCHANGE      
      AND SEGMENT = @SEGMENT      
   IF @@ROWCOUNT <= 0      
      BEGIN      
       SELECT      
        @DBNAME = SHAREDB,      
        @MULTISERVER = CASE WHEN @CONNECTIONDB = 'A' THEN ACCOUNTSERVER ELSE SHARESERVER END      
       FROM      
        PRADNYA..CLS_MULTICOMPANY      
       WHERE      
        PRIMARYSERVER = 1      
        AND EXCHANGE = @EXCHANGE      
        AND SEGMENT = @SEGMENT      
      END      
    END      
   IF @@SERVERNAME = REPLACE(REPLACE(@MULTISERVER, '[', ''), ']', '')      
    BEGIN      
     SET @MULTISERVER = '' + @DBNAME
    END      
   ELSE      
    BEGIN      
     SET @MULTISERVER = @MULTISERVER + '.' + @DBNAME
    END      
      
      
      
 IF @OBJTYPE = 'T' OR @OBJTYPE = 'V'      
  BEGIN      
   SET @OBJNAME = @MULTISERVER + '..' + @OBJNAME
   SET @SQL = "SELECT  " + @OBJECTOUT + " FROM " + @OBJNAME + " WHERE 1 = 1 "      
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
       SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE @PARAMOPR END) + " '" 
       + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' THEN '' ELSE '0' END ELSE @PARAMVAL
		END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' THEN '%' ELSE '' END) + "' "      
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
       SET @PARAMVAL = .dbo.CLS_Piece(@F2WHVALS, ',', @PARAMPOS)      
       SET @PARAMOPR = .dbo.CLS_Piece(@F2WHOPR, ',', @PARAMPOS)      
       SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL 
       THEN '=' ELSE CASE WHEN @PARAMOPR = 'NL' THEN ' NOT LIKE ' ELSE @PARAMOPR END END) + " '" 
       + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN 
		@PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" 
		+ (CASE WHEN @PARAMOPR = 'LIKE' OR @PARAMOPR = 'NL' THEN '%' ELSE '' END) + "' "      
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
   CREATE TABLE #PARANAMES (PARANAME VARCHAR(256))      
   IF @DATABASENAME <> ''      
    BEGIN      
     SET @SQL = "INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @DATABASENAME + ".SYS.PARAMETERS WHERE OBJECT_ID = (SELECT OBJECT_ID FROM " +
      @DATABASENAME + ".SYS.OBJECTS WHERE NAME = '" + @OBJNAME + "' AND TYPE = 'P' AND SCHEMA_ID = (SELECT SCHEMA_ID FROM " + 
      @DATABASENAME + ".SYS.SCHEMAS WHERE NAME = SCHEMA_NAME()))"
     EXEC (@SQL)      
     SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES      
    END      
   ELSE      
    IF @MULTISERVER <> ''      
     BEGIN      
      SET @DATABASENAME = @MULTISERVER      
      SET @SQL = "INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @MULTISERVER + ".SYS.PARAMETERS WHERE OBJECT_ID = (SELECT OBJECT_ID FROM " 
      + @MULTISERVER + ".SYS.OBJECTS WHERE NAME = '" + @OBJNAME + "' AND TYPE = 'P' AND SCHEMA_ID = (SELECT SCHEMA_ID FROM " + @DATABASENAME +
       ".SYS.SCHEMAS WHERE NAME = SCHEMA_NAME()))"      
      PRINT @SQL       
      EXEC (@SQL)      
      SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES      
     END      
    ELSE      
     BEGIN      
      SET @PARAMCUR = CURSOR FOR SELECT NAME FROM SYS.PARAMETERS WHERE OBJECT_ID = (SELECT OBJECT_ID FROM SYS.OBJECTS WHERE NAME = @OBJNAME 
      AND TYPE = 'P' AND SCHEMA_ID = SCHEMA_ID())      
     END      
           
   OPEN @PARAMCUR      
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
   IF LEN(@SQL) > 0      
    BEGIN      
     SET @SQL = @DATABASENAME + '..' + @OBJNAME + ' ' + SUBSTRING(@SQL, 1, LEN(@SQL)-1)      
    END      
   ELSE      
    BEGIN      
		SELECT @DATABASENAME , @OBJNAME
     SET @SQL = @DATABASENAME + '..' + @OBJNAME      
    END      
   PRINT @SQL      
   EXEC SP_EXECUTESQL @SQL      
  END      
END TRY      
BEGIN CATCH      
 DECLARE @ERRMSG VARCHAR(1000)      
 SET @ERRMSG = ERROR_MESSAGE()      
 RAISERROR(@ERRMSG, 16, 1)      
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_F2_SCRIP
-- --------------------------------------------------
CREATE PROC [dbo].[CLS_F2_SCRIP]
(
	@SCRIP_CD VARCHAR(50),
	@EXCHANGE VARCHAR(3) = '',    
	@SEGMENT VARCHAR(7) = ''
	
)
AS

DECLARE @STRSQL VARCHAR(MAX)
DECLARE @STRSHAREDB VARCHAR(30)

SELECT TOP 1 @STRSHAREDB = SHAREDB FROM CLS_MULTICOMPANY (NOLOCK) 
WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT

SET @STRSQL = 'EXEC ' + @STRSHAREDB + '.DBO.CLS_F2_SCRIP ''' 
SET @STRSQL = @STRSQL + @SCRIP_CD + ''','''
SET @STRSQL = @STRSQL + @EXCHANGE + ''','''
SET @STRSQL = @STRSQL + @SEGMENT + ''''


EXEC (@STRSQL)

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
-- PROCEDURE dbo.CLS_GET_BILL_DETAILS
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_GET_BILL_DETAILS]      
(      
 @EXCHANGE VARCHAR(3),      
 @SEGMENT VARCHAR(25),      
 @SHAREDB VARCHAR(25),      
 @ACCDB VARCHAR(25),      
 @BILLDT VARCHAR(11),      
 @NARRATION VARCHAR(500)  -- THIS PARAMETER IS USING AS VNO     
)      
      
AS      
DECLARE @@SQL AS VARCHAR(MAX)      
/*      
 SELECT CNT = COUNT(*) INTO #CHK FROM ACCOUNT.SYS.OBJECTS WHERE NAME = 'BILLPOSTED'       
 SELECT * FROM ACCOUNT..BILLPOSTED        
 SELECT * FROM #CHK      
*/      
CREATE TABLE #CHK( NAME VARCHAR(50))      
      
SET @@SQL = " INSERT INTO #CHK SELECT NAME FROM " + @ACCDB + ".SYS.OBJECTS WHERE NAME = 'BILLPOSTED' "      
PRINT @@SQL      
EXEC(@@SQL)      
      
IF (SELECT COUNT(1) FROM #CHK) > 0       
 BEGIN      
 SET @@SQL = ""      
 SET @@SQL = @@SQL + " SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 109),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL FROM " + @ACCDB +" .DBO.BILLPOSTED BP, ACCOUNT.DBO.PLDETAIL PL "      
 SET @@SQL = @@SQL + " WHERE "      
 SET @@SQL = @@SQL + " PL.EXCHANGE = '" + @EXCHANGE + "' "      
 SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "      
 SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "      
IF @SEGMENT <> 'FUTURES'   
 BEGIN  
  SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE "    
 END  
 SET @@SQL = @@SQL + "  AND BP.VNO = '" + @NARRATION + "' "    
 SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE AND FLAG = 'Y'"      
    
    
 PRINT @@SQL      
 EXEC(@@SQL)      
 END      
DROP TABLE #CHK

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
DECLARE @@SQL AS VARCHAR(MAX)      
/*      
 SELECT CNT = COUNT(*) INTO #CHK FROM ACCOUNT.SYS.OBJECTS WHERE NAME = 'BILLPOSTED'       
 SELECT * FROM ACCOUNT..BILLPOSTED        
 SELECT * FROM #CHK      
*/      
CREATE TABLE #CHK( NAME VARCHAR(50))      
      
SET @@SQL = " INSERT INTO #CHK SELECT NAME FROM " + @ACCDB + ".SYS.OBJECTS WHERE NAME = 'BILLPOSTED' "      
PRINT @@SQL      
EXEC(@@SQL)      
      
IF (SELECT COUNT(1) FROM #CHK) > 0       
 BEGIN      
 SET @@SQL = ""      
 SET @@SQL = @@SQL + " SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 103),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL FROM " + @ACCDB +" .DBO.BILLPOSTED BP, ACCOUNT.DBO.CLS_PLDETAIL PL "      
 SET @@SQL = @@SQL + " WHERE "      
 SET @@SQL = @@SQL + " PL.EXCHANGE = '" + @EXCHANGE + "' "      
 SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "      
 SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "      
IF @SEGMENT <> 'FUTURES' AND 1=2   
 BEGIN  
  SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE "    
 END  
 SET @@SQL = @@SQL + "  AND BP.VNO = '" + @NARRATION + "' "    
 SET @@SQL = @@SQL + "/* AND BP.SETT_TYPE = PL.SETTTYPE */AND FLAG = 'Y'"      
    
    
 PRINT @@SQL      
 EXEC(@@SQL)      
 END      
DROP TABLE #CHK

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GET_SETTING
-- --------------------------------------------------
CREATE proc CLS_GET_SETTING
@rptCode varchar(20)
as
select * from CLS_PDF_SETTING where FLDREPORTCODE = @rptCode
select * from cls_pdfcss

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GLCODES
-- --------------------------------------------------
CREATE PROCEDURE CLS_GLCODES
    (
		@CODE VARCHAR(10),
		@CLTFILTER VARCHAR(20),
		@STATUSID VARCHAR(20),
		@STATUSNAME VARCHAR(20)

    )
    AS
    BEGIN
		IF @CLTFILTER = 'BANKCLTCODE' OR @CLTFILTER = 'CASHCLTCODE' OR @CLTFILTER = 'BANKCLTCODECR'  
		BEGIN
			 SELECT TOP 5 CLTCODE, LONGNAME
			 FROM ACMAST    
			 WHERE    
			  /*EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT AND*/ 
			  --BOOKTYPE LIKE CASE WHEN @CLTFILTER = 'BANKCLTCODECR' THEN '%' ELSE @BOOKTYPE END    
			  ACCAT BETWEEN CASE WHEN @CLTFILTER = 'CASHCLTCODE' OR @CLTFILTER = 'BANKCLTCODECR' THEN '1' ELSE '2' END    
				 AND CASE WHEN @CLTFILTER = 'BANKCLTCODE' OR @CLTFILTER = 'BANKCLTCODECR' THEN '2' ELSE '1' END    
			  AND ((LEFT(ACNAME,LEN(@CODE)) = @CODE) OR (LEFT(CLTCODE,LEN(@CODE)) = @CODE))    
			  AND (BRANCHCODE LIKE CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE '%' END    
			  OR  LTRIM(RTRIM(BRANCHCODE)) LIKE 'ALL')    
			 ORDER BY 2,1   
		END 
		IF @CLTFILTER = 'JVCODES'
		BEGIN
			SELECT TOP 5 LTRIM(RTRIM(CLTCODE)) + '|' + LTRIM(RTRIM(BRANCHCODE)) + '|' + LTRIM(RTRIM(LONGNAME)),    
			  '(' + CLTCODE + ') -' + ACNAME     
			 FROM ACMAST (NOLOCK)    
			 WHERE     
			  /*EXCHANGE = @EXCHANGE    
			  AND SEGMENT = @SEGMENT    
			  AND */
			  ACCAT NOT IN  ('1','2','18')    
			  AND (LEFT(ACNAME,LEN(@CODE)) = @CODE OR LEFT(CLTCODE, LEN(@CODE)) = @CODE)    
			  AND (BRANCHCODE =  CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE BRANCHCODE END OR BRANCHCODE = CASE WHEN @STATUSID = 'BRANCH' THEN 'ALL' ELSE BRANCHCODE END)    
			 ORDER BY 2,1    
		
		END
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_MARGIN_RPT
-- --------------------------------------------------

--EXEC CLS_MARGIN_RPT '01/01/2000','10/10/2014','','','BROKER','BROKER'

CREATE  PROC [DBO].[CLS_MARGIN_RPT]
(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@FROMPARTY VARCHAR(20),
	@TOPARTY VARCHAR (20), 
	@STATUSID VARCHAR(15),  
	@STATUSNAME VARCHAR(25)
)  AS


SET @DATEFROM = LEFT(CONVERT(DATETIME,@DATEFROM,103),11)
SET @DATETO = LEFT(CONVERT(DATETIME,@DATETO,103),11)


IF @TOPARTY =''
SET @TOPARTY ='ZZZZZZZ'


IF (SELECT COUNT(1) FROM PRADNYA.DBO.HISTORY_TBL_CLIENTMARGIN_NSEFO (NOLOCK)
WHERE MARGINDATE  BETWEEN @DATEFROM  AND  @DATETO + ' 23:59:00' ) > 0
BEGIN
SELECT
		CLIENT2.PARTY_CODE,
		PARTY_NAME = CLIENT1.LONG_NAME,		
		MARGIN_DATE = CONVERT(VARCHAR,MARGINDATE,103),
		BILL_AMOUNT = BILLAMOUNT ,
		LEDGER_AMOUNT = LEDGERAMOUNT ,      
		NET_CASH_AVAILABLE = BILLAMOUNT + LEDGERAMOUNT,
		COLLATERAL_AVAILABLE = CASH_COLL + NONCASH_COLL,
		REPORTED_MRG_COLLATERAL = ISNULL(F.FINALAMOUNT,0),
		INITIALMARGIN = INITIALMARGIN, 
		MTMMARGIN = MTMMARGIN,
		ADDMARGIN = ADDMARGIN,
		FREE_COLLATERALS = ((CASH_COLL + NONCASH_COLL)- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)),
		NET_AMOUNT = ((CASH_COLL + NONCASH_COLL)- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)) +  (BILLAMOUNT + LEDGERAMOUNT),
		FREE_COLLATERALS_REPORTING = (ISNULL(F.FINALAMOUNT,(CASH_COLL + NONCASH_COLL))- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)),
		NET_AMOUNT_REPORTING = (ISNULL(F.FINALAMOUNT,(CASH_COLL + NONCASH_COLL))- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)) +  (BILLAMOUNT + LEDGERAMOUNT)
	FROM
		CLIENT1 (NOLOCK) ,  CLIENT2 (NOLOCK),
		PRADNYA.DBO.HISTORY_TBL_CLIENTMARGIN_BSECURFO FO (NOLOCK)
		LEFT OUTER JOIN
		(
			SELECT EFFDATE,PARTY_CODE, FINALAMOUNT = SUM(FINALAMOUNT) FROM 
			TBL_COLLATERAL_MARGIN (NOLOCK) 
			WHERE EFFDATE BETWEEN @DATEFROM AND @DATETO + ' 23:59:00' 
			AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY 
			GROUP BY EFFDATE,PARTY_CODE
		) F
		ON (MARGINDATE = EFFDATE AND F.PARTY_CODE = FO.PARTY_CODE)
	WHERE
		MARGINDATE BETWEEN @DATEFROM AND @DATETO + ' 23:59:00' 
		AND FO.PARTY_CODE = CLIENT2.PARTY_CODE
		AND CLIENT1.CL_CODE = CLIENT2.CL_CODE
		AND CLIENT2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY   
		AND @STATUSNAME = 
			(CASE 
				WHEN @STATUSID = 'BRANCH' THEN FO.BRANCH_CD
				WHEN @STATUSID = 'SUBBROKER' THEN FO.SUB_BROKER
				WHEN @STATUSID = 'TRADER' THEN FO.TRADER
				WHEN @STATUSID = 'FAMILY' THEN FO.FAMILY
				WHEN @STATUSID = 'AREA' THEN AREA
				WHEN @STATUSID = 'REGION' THEN REGION
				WHEN @STATUSID = 'CLIENT' THEN FO.PARTY_CODE
				ELSE 
			'BROKER'
			END)      
	ORDER BY 1,2
END
ELSE
BEGIN
	SELECT
		CLIENT2.PARTY_CODE,
		PARTY_NAME = CLIENT1.LONG_NAME,		
		MARGIN_DATE = CONVERT(VARCHAR,MARGINDATE,103),
		BILL_AMOUNT = BILLAMOUNT ,
		LEDGER_AMOUNT = LEDGERAMOUNT ,      
		NET_CASH_AVAILABLE = BILLAMOUNT + LEDGERAMOUNT,
		COLLATERAL_AVAILABLE = CASH_COLL + NONCASH_COLL,
		REPORTED_MRG_COLLATERAL = ISNULL(F.FINALAMOUNT,0),
		INITIALMARGIN = INITIALMARGIN, 
		MTMMARGIN = MTMMARGIN,
		ADDMARGIN = ADDMARGIN,
		FREE_COLLATERALS = ((CASH_COLL + NONCASH_COLL)- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)),
		NET_AMOUNT = ((CASH_COLL + NONCASH_COLL)- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)) +  (BILLAMOUNT + LEDGERAMOUNT),
		FREE_COLLATERALS_REPORTING = (ISNULL(F.FINALAMOUNT,(CASH_COLL + NONCASH_COLL))- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)),
		NET_AMOUNT_REPORTING = (ISNULL(F.FINALAMOUNT,(CASH_COLL + NONCASH_COLL))- (INITIALMARGIN+MTMMARGIN+ADDMARGIN)) +  (BILLAMOUNT + LEDGERAMOUNT)
	FROM
		CLIENT1 (NOLOCK) ,  CLIENT2 (NOLOCK),
		TBL_CLIENTMARGIN FO (NOLOCK)
		LEFT OUTER JOIN
		(
			SELECT EFFDATE,PARTY_CODE, FINALAMOUNT = SUM(FINALAMOUNT) FROM 
			TBL_COLLATERAL_MARGIN (NOLOCK) 
			WHERE EFFDATE BETWEEN @DATEFROM AND @DATETO + ' 23:59:00' 
			AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY 
			GROUP BY EFFDATE,PARTY_CODE
		) F
		ON (MARGINDATE = EFFDATE AND F.PARTY_CODE = FO.PARTY_CODE)
	WHERE
		MARGINDATE BETWEEN @DATEFROM AND @DATETO + ' 23:59:00' 
		AND FO.PARTY_CODE = CLIENT2.PARTY_CODE
		AND CLIENT1.CL_CODE = CLIENT2.CL_CODE
		AND CLIENT2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY   
		AND @STATUSNAME = 
			(CASE 
				WHEN @STATUSID = 'BRANCH' THEN FO.BRANCH_CD
				WHEN @STATUSID = 'SUBBROKER' THEN FO.SUB_BROKER
				WHEN @STATUSID = 'TRADER' THEN FO.TRADER
				WHEN @STATUSID = 'FAMILY' THEN FO.FAMILY
				WHEN @STATUSID = 'AREA' THEN AREA
				WHEN @STATUSID = 'REGION' THEN REGION
				WHEN @STATUSID = 'CLIENT' THEN FO.PARTY_CODE
				ELSE 
			'BROKER'
			END)      
	ORDER BY 1,2
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_DASH_COLLATERALDETAILS
-- --------------------------------------------------

CREATE PROC [dbo].[CLS_PROC_DASH_COLLATERALDETAILS]
	(
	@PARTY_CODE	VARCHAR(15),
	@EXCHANGE	VARCHAR(3),
	@SEGMENT	VARCHAR(7),
	@FROMDATE	VARCHAR(11),
	@TODATE		VARCHAR(11),
	@C_N_FLAG	CHAR(1)
	)

	AS
	
	/*
	SET @PARTY_CODE	= '0A141'
	SET @EXCHANGE = 'NSE'
	SET	@SEGMENT = 'FUTURES'
	SET	@FROMDATE = 'JAN  1 2010'
	SET	@TODATE  = 'MAR 12 2013'
	SET	@C_N_FLAG = 'C'
	
	FOR CASH	: EXEC CLASS_PROC_DASH_COLLATERALDETAILS '0A141','NSE','FUTURES','JAN  1 2010','MAR 12 2013','C'
	FOR NONCASH : EXEC CLASS_PROC_DASH_COLLATERALDETAILS '0A141','NSE','FUTURES','JAN  1 2010','MAR 12 2013','N'
	*/
    
    SET @FROMDATE = CONVERT(VARCHAR(11),GETDATE(),109)
    SET @TODATE   = CONVERT(VARCHAR(11),GETDATE(),109)
    

	CREATE TABLE #COLLDETAILS
		(
		EFFDATE			VARCHAR(11),
		EXCHANGE		VARCHAR(3),
		SEGMENT			VARCHAR(7),
		PARTY_CODE		VARCHAR(15),
		SCRIP_CD		VARCHAR(15),
		SERIES			VARCHAR(3),
		QTY				INT,
		CL_RATE			MONEY,
		BANK_CODE		VARCHAR(15),
		FD_BG_NO		VARCHAR(20),
		RECEIVE_DATE	VARCHAR(11),
		MATURITY_DATE	VARCHAR(11),
		AMOUNT			MONEY,
		HAIRCUT			MONEY,
		FINALAMOUNT		MONEY,
		CASH_NONCASH	CHAR(1),
		COLL_FLAG		VARCHAR(7),
		ORD_FLAG		INT
		)

	IF @C_N_FLAG = 'N'
	BEGIN
		INSERT INTO #COLLDETAILS
		SELECT
			EFFDATE = CONVERT(VARCHAR(11),EFFDATE,103),
			EXCHANGE,
			SEGMENT,
			PARTY_CODE,
			SCRIP_CD,
			SERIES,
			QTY,
			CL_RATE,
			BANK_CODE = '',
			FD_BG_NO = '',
			RECEIVE_DATE = '',
			MATURITY_DATE = '',
			AMOUNT,
			HAIRCUT,
			FINALAMOUNT,
			CASH_NONCASH = CASH_NCASH,
			COLL_FLAG = 'SEC',
			ORD_FLAG = 1
		FROM
			MSAJAG..COLLATERALDETAILS
		WHERE
			PARTY_CODE = @PARTY_CODE
			AND EXCHANGE = @EXCHANGE
			AND SEGMENT = @SEGMENT
			AND EFFDATE BETWEEN	@FROMDATE AND @TODATE + ' 23:59:59'
			AND CASH_NCASH = @C_N_FLAG
	END

	IF @C_N_FLAG = 'C'
	BEGIN
		INSERT INTO #COLLDETAILS
		SELECT
			EFFDATE = CONVERT(VARCHAR(11),EFFDATE,103),
			EXCHANGE,
			SEGMENT,
			PARTY_CODE,
			SCRIP_CD,
			SERIES,
			QTY,
			CL_RATE,
			BANK_CODE,
			FD_BG_NO,
			RECEIVE_DATE = CONVERT(VARCHAR(11),RECEIVE_DATE,103),
			MATURITY_DATE = CONVERT(VARCHAR(11),MATURITY_DATE,103),
			AMOUNT,
			HAIRCUT,
			FINALAMOUNT,
			CASH_NONCASH = CASH_NCASH,
			COLL_FLAG = COLL_TYPE,
			ORD_FLAG = (
			CASE
				WHEN COLL_TYPE = 'BG' THEN 1
				WHEN COLL_TYPE = 'FD' THEN 2
				WHEN COLL_TYPE = 'MARGIN' THEN 3
				ELSE 4
			END)		
		FROM
			MSAJAG..COLLATERALDETAILS
		WHERE
			PARTY_CODE = @PARTY_CODE
			AND EXCHANGE = @EXCHANGE
			AND SEGMENT = @SEGMENT
			AND EFFDATE BETWEEN	@FROMDATE AND @TODATE + ' 23:59:59'
			AND CASH_NCASH = @C_N_FLAG
	END

	SELECT * FROM #COLLDETAILS
	ORDER BY
		ORD_FLAG,PARTY_CODE,EFFDATE,SCRIP_CD,SERIES,FD_BG_NO
		
	DROP TABLE #COLLDETAILS

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
-- PROCEDURE dbo.CLS_PROC_F2CONFIG_test
-- --------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
CREATE PROC [dbo].[CLS_PROC_F2CONFIG_test]    
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
-- PROCEDURE dbo.CLS_PROC_LEDGERSAUDA
-- --------------------------------------------------
CREATE PROC [dbo].[CLS_PROC_LEDGERSAUDA]                  
(                    
 @FROMPARTY VARCHAR(10),                    
 @TOPARTY VARCHAR(10),                    
 @FROMDT VARCHAR(11),                    
 @TODT VARCHAR(11),                    
 @EXC VARCHAR(4),                    
 @STATUSID VARCHAR(25),                    
 @STATUSNAME VARCHAR(25)                    
)                    
/*                    
    
EXEC PRADNYA..V2_PROC_LEDGERSAUDA '00000010','00000010','JUL 27 2009','JUL 30 2009','BOTH','BROKER','BROKER'                    
*/                    
AS                    
SET @FROMDT =  CONVERT(VARCHAR(11),CONVERT(DATETIME,@FROMDT ,103),109)    
SET @TODT = CONVERT(VARCHAR(11),CONVERT(DATETIME,@TODT ,103),109)                    
SET NOCOUNT ON                    
                    
CREATE TABLE #V2_CLASS_LEDGERSAUDA                    
(        
 VCL_ID INT IDENTITY(1,1),                    
 VCL_EXCHANGE VARCHAR(20),                    
 VCL_PARTY_CODE VARCHAR(12),                    
 VCL_DT VARCHAR(10),                    
 VCL_VTYPE VARCHAR(100),                    
 VCL_SETTNO VARCHAR(10),                    
 VCL_SETTTYPE VARCHAR(5),                    
 VCL_REMARKS VARCHAR(255),                    
 VCL_BUYSELL VARCHAR(4),                    
 VCL_QTY INT,                    
 VCL_MKTRATE MONEY,                    
 VCL_NETRATE MONEY,                    
 VCL_DEBIT MONEY,                    
 VCL_CREDIT MONEY,                    
 VCL_BALANCE MONEY,                    
 VCL_DATE DATETIME,                    
 VCL_FLAG TINYINT                    
)                    
                    
CREATE TABLE #CLOSINGBALANCES                    
(                    
 CB_PARTY_CODE VARCHAR(12),                    
 CB_EXCHANGE VARCHAR(20),                    
 CB_DEBIT MONEY,                    
 CB_CREDIT MONEY,                    
 CB_BALANCE MONEY                    
)                    
                
               
               
INSERT INTO #CLOSINGBALANCES                    
EXEC PRADNYA..CLS_PROC_QUARTERLYLEDGER_OPENBAL @FROMPARTY , @TOPARTY , @FROMDT ,@STATUSID ,@STATUSNAME                  
  
  
      
DELETE FROM #CLOSINGBALANCES                    
WHERE CB_EXCHANGE NOT IN ('NSECM','NSEFO')   
  
  
  
TRUNCATE TABLE #V2_CLASS_LEDGERSAUDA                    
                    
INSERT INTO #V2_CLASS_LEDGERSAUDA                    
SELECT                    
 CB_EXCHANGE,                    
 CB_PARTY_CODE,                    
 CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDT,109),103),                    
 'OPENING BALANCE',                    
 '',                    
 '',                    
 'OPENING BALANCE',                    
 '',                    
 0,                    
 0,                    
 0,                    
 CB_DEBIT,                    
 CB_CREDIT,                    
 CB_BALANCE,                    
 CONVERT(DATETIME,@FROMDT,109),                    
 0                    
FROM                     
 #CLOSINGBALANCES                    
  
      
               
 CREATE TABLE #NSEVALANTABLE                    
  (                    
   EXCHANGE VARCHAR(10),                    
   PARTY_CODE VARCHAR(12),                    
   SETT_NO VARCHAR(10),                    
   SETT_TYPE VARCHAR(3),                    
   SCRIP_NAME VARCHAR(100),                    
   SAUDA_DATE DATETIME,                    
   PQTY INT,                    
   SQTY INT,                    
   PRATE MONEY,                    
   SRATE MONEY,                    
   PAMT MONEY,                    
   SAMT MONEY,                    
   BROKERAGE MONEY,                    
   SERVICETAX MONEY,                    
   TURN_TAX MONEY,                    
   SEBI_TAX MONEY,                    
   INS_CHRG MONEY,                    
   BROKER_CHRG MONEY,                    
   OTHER_CHRG MONEY                    
  )                    
                
IF @EXC = 'NSE' OR @EXC = 'BOTH'    
BEGIN                    
                
IF  @STATUSID ='BROKER'                   
BEGIN                 
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT /*DISTINCT */                  
  'NSECM',                    
  L.CLTCODE,                    
  CONVERT(VARCHAR,L.VDT,103),                    
  ISNULL(V.VDESC,'N.A.'),                    
  B.Sett_No,                    
  B.Sett_Type,                    
  L.NARRATION,                    
  '',                    
  0,                    
  0,                    
  0,                    
  CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE 0 END,                    
  CASE WHEN L.DRCR = 'C' THEN L.VAMT ELSE 0 END,                    
  (CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),                    
  CONVERT(DATETIME,CONVERT(VARCHAR,L.VDT,103),103),                    
  10                    
  FROM ACCOUNT..LEDGER L                    
  INNER JOIN ACCOUNT..ACMAST A                    
   ON (L.CLTCODE = A.CLTCODE AND A.ACCAT IN ('4','104','204'))                    
  LEFT OUTER JOIN ACCOUNT..VMAST V                     
   ON (V.VTYPE = L.VTYP)  
   left outer join  ACCOUNT..BILLPOSTED B on (B.vno = L.Vno AND B.VTYP = L.VTYP AND B.BookType = L.Booktype)  
  WHERE                    
   1 = 1  
                      
   --AND L.VTYP NOT IN ('15','21','18')                   
   --AND L.VTYP NOT IN ('15','21','18')                     
 AND L.VTYP NOT IN ('18')                     
   AND L.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                    
   AND L.VDT BETWEEN @FROMDT AND @TODT + ' 23:59:59'  
   ORDER BY L.Vdt, L.VTYP     
     
       
       
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT /*DISTINCT */                  
  'NSEFO',                    
  L.CLTCODE,                    
  CONVERT(VARCHAR,L.VDT,103),                    
  ISNULL(V.VDESC,'N.A.'),                    
  '',                    
  '',                    
  L.NARRATION,                    
  '',                    
  0,                    
  0,                    
  0,                    
  CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE 0 END,                    
  CASE WHEN L.DRCR = 'C' THEN L.VAMT ELSE 0 END,                    
  (CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),                    
  CONVERT(DATETIME,CONVERT(VARCHAR,L.VDT,103),103),                    
  10                    
  FROM ACCOUNTFO..LEDGER L                    
  INNER JOIN ACCOUNTFO..ACMAST A                    
   ON (L.CLTCODE = A.CLTCODE AND A.ACCAT IN ('4','104','204'))                    
  LEFT OUTER JOIN ACCOUNTFO..VMAST V    
   ON (V.VTYPE = L.VTYP)                    
  WHERE                    
   1 = 1                    
   --AND L.VTYP NOT IN ('15','21','18')                   
   --AND L.VTYP NOT IN ('15','21','18')                     
 AND L.VTYP NOT IN ('18')                     
   AND L.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                    
   AND L.VDT BETWEEN @FROMDT AND @TODT + ' 23:59:59'   
   ORDER BY L.Vdt, L.VTYP   
     
      
               
  INSERT INTO #NSEVALANTABLE                    
  SELECT                     
  'NSECM',                    
  PARTY_CODE,                    
  CM.SETT_NO,                    
  CM.SETT_TYPE,                    
  SCRIP_NAME,                    
  VDT,                    
  PQTY = PQTYTRD + PQTYDEL,                    
  SQTY = SQTYTRD + SQTYDEL,                    
  PRATE = (CASE WHEN PQTYTRD + PQTYDEL > 0 THEN ROUND((PRATE)/(PQTYTRD + PQTYDEL),2) ELSE 0 END),                    
  SRATE = (CASE WHEN SQTYTRD + SQTYDEL > 0 THEN ROUND((SRATE)/(SQTYTRD + SQTYDEL),2) ELSE 0 END),                    
  PAMT = PRATE,                    
  SAMT = SRATE,                    
  BROKERAGE = ROUND(PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL,4),                    
  SERVICETAX = ROUND(SERVICE_TAX + EXSERVICE_TAX,4),                    
  TURN_TAX = ROUND(TURN_TAX,4),                    
  SEBI_TAX = ROUND(SEBI_TAX,4),                    
  INS_CHRG = ROUND(INS_CHRG,4),                    
  BROKER_CHRG = ROUND(BROKER_CHRG,4),                    
  OTHER_CHRG = ROUND(OTHER_CHRG,4)                    
  FROM              
  MSAJAG..CMBILLVALAN CM, (SELECT SETT_NO, SETT_TYPE, VNO = MAX(VNO), VTYP, BOOKTYPE, VDT = MAX(VDT) FROM ACCOUNT..BILLPOSTED GROUP BY SETT_NO, SETT_TYPE, VTYP, BOOKTYPE) BL                   
  WHERE   /*SAUDA_DATE >= @FROMDT                    
  AND SAUDA_DATE <= @TODT          
  VDT >= @FROMDT                
  AND VDT <=@TODT          */                
  EXISTS (SELECT VNO FROM ACCOUNT..LEDGER L WHERE BL.VNO = L.VNO AND BL.VTYP = L.VTYP AND BL.BOOKTYPE = L.BOOKTYPE       
  AND L.VDT >= @FROMDT           
  AND L.VDT <=@TODT AND CLTCODE = PARTY_CODE )      
  AND PARTY_CODE >= @FROMPARTY                    
  AND PARTY_CODE <= @TOPARTY                    
  AND CM.SETT_NO=BL.SETT_NO                
  AND CM.SETT_TYPE=BL.SETT_TYPE                    
                
END                 
ELSE             
BEGIN                 
PRINT 'BRANCH'            
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT /*DISTINCT */                    
  'NSECM',                    
  L.CLTCODE,                    
  CONVERT(VARCHAR,L.VDT,103),                    
  ISNULL(V.VDESC,'N.A.'),                    
  b.Sett_No,                    
  b.Sett_Type,                    
  L.NARRATION,                    
  '',                    
  0,                    
  0,                    
  0,                    
  CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE 0 END,                    
  CASE WHEN L.DRCR = 'C' THEN L.VAMT ELSE 0 END,                    
  (CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),                    
  CONVERT(DATETIME,CONVERT(VARCHAR,L.VDT,103),103),                    
  10                    
  FROM ACCOUNT..LEDGER L                    
  INNER JOIN ACCOUNT..ACMAST A                    
   ON (L.CLTCODE = A.CLTCODE AND A.ACCAT IN ('4','104','204') )--AND A.BRANCHCODE=@STATUSNAME)                    
  LEFT OUTER JOIN ACCOUNT..VMAST V                     
   ON (V.VTYPE = L.VTYP) /*INNER JOIN  ACCOUNT..LEDGER2 L2                 
   ON (L.VNO=L2.VNO AND L.VTYP=L2.VTYPE AND L.BOOKTYPE=L2.BOOKTYPE AND L.LNO=L2.LNO AND L.DRCR = L2.DRCR)   */         
   INNER JOIN MSAJAG..CLIENT_DETAILS C1 ON (C1.CL_CODE=L.CLTCODE)  
   left outer join  ACCOUNT..BILLPOSTED B on (B.vno = L.Vno AND B.VTYP = L.VTYP AND B.BookType = L.Booktype)         
  WHERE                    
   1 = 1                    
   --AND L.VTYP NOT IN ('15','21','18')                   
   --AND L2.VTYPE NOT IN ('15','21')                     
 AND L.VTYP NOT IN ('18')                     
   AND L.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                    
   AND L.VDT BETWEEN @FROMDT AND @TODT + ' 23:59:59'   
     
   --AND EXISTS(SELECT COSTNAME FROM ACCOUNT..COSTMAST C WHERE C.COSTCODE = L2.COSTCODE AND COSTNAME = A.BRANCHCODE)                              
   AND C1.BRANCH_CD LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'BRANCH'                     
                  THEN @STATUSNAME                     
  ELSE '%'                     
            END                    
            )                     
            AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUB_BROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
   AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUBBROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND TRADER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'TRADER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
      )                     
            AND C1.FAMILY LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'FAMILY'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND C1.PARTY_CODE LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'CLIENT'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
         )   
       ORDER BY L.VDT, L.Vtyp                    
         
         
       INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT /*DISTINCT */                    
  'NSEFO',                    
  L.CLTCODE,                    
  CONVERT(VARCHAR,L.VDT,103),                    
  ISNULL(V.VDESC,'N.A.'),                    
  '',                    
  '',                    
  L.NARRATION,                    
  '',                    
  0,                    
  0,                    
  0,                    
  CASE WHEN L.DRCR = 'D' THEN L.VAMT ELSE 0 END,                    
  CASE WHEN L.DRCR = 'C' THEN L.VAMT ELSE 0 END,                    
  (CASE WHEN L.DRCR = 'D' THEN -L.VAMT ELSE L.VAMT END),                    
  CONVERT(DATETIME,CONVERT(VARCHAR,L.VDT,103),103),                    
  10                    
  FROM ACCOUNTFO..LEDGER L                    
  INNER JOIN ACCOUNTFO..ACMAST A                    
   ON (L.CLTCODE = A.CLTCODE AND A.ACCAT IN ('4','104','204') )--AND A.BRANCHCODE=@STATUSNAME)                    
  LEFT OUTER JOIN ACCOUNT..VMAST V                     
   ON (V.VTYPE = L.VTYP) /*INNER JOIN  ACCOUNT..LEDGER2 L2                 
   ON (L.VNO=L2.VNO AND L.VTYP=L2.VTYPE AND L.BOOKTYPE=L2.BOOKTYPE AND L.LNO=L2.LNO AND L.DRCR = L2.DRCR)   */         
   INNER JOIN MSAJAG..CLIENT_DETAILS C1 ON (C1.CL_CODE=L.CLTCODE)  
   --left outer join  ACCOUNTFO..BILLPOSTED B on (B.vno = L.Vno AND B.VTYP = L.VTYP AND B.BookType = L.Booktype)         
  WHERE                    
   1 = 1                    
   --AND L.VTYP NOT IN ('15','21','18')                   
   --AND L2.VTYPE NOT IN ('15','21')                     
 AND L.VTYP NOT IN ('18')                     
   AND L.CLTCODE BETWEEN @FROMPARTY AND @TOPARTY                    
   AND L.VDT BETWEEN @FROMDT AND @TODT + ' 23:59:59'   
     
   --AND EXISTS(SELECT COSTNAME FROM ACCOUNT..COSTMAST C WHERE C.COSTCODE = L2.COSTCODE AND COSTNAME = A.BRANCHCODE)                              
   AND C1.BRANCH_CD LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'BRANCH'                     
                  THEN @STATUSNAME                     
  ELSE '%'                     
            END                    
            )                     
            AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUB_BROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
   AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUBBROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND TRADER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'TRADER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND C1.FAMILY LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'FAMILY'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND C1.PARTY_CODE LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'CLIENT'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
         )   
       ORDER BY L.VDT, L.Vtyp   
            
                    
                    
  INSERT INTO #NSEVALANTABLE                    
  SELECT                     
  'NSECM',                    
  PARTY_CODE,                    
  CM.SETT_NO,                    
  CM.SETT_TYPE,                    
  SCRIP_NAME,                    
  VDT,                    
  PQTY = PQTYTRD + PQTYDEL,                    
  SQTY = SQTYTRD + SQTYDEL,                    
  PRATE = (CASE WHEN PQTYTRD + PQTYDEL > 0 THEN ROUND((PRATE)/(PQTYTRD + PQTYDEL),2) ELSE 0 END),                    
  SRATE = (CASE WHEN SQTYTRD + SQTYDEL > 0 THEN ROUND((SRATE)/(SQTYTRD + SQTYDEL),2) ELSE 0 END),                    
  PAMT = PRATE,                    
  SAMT = SRATE,                    
  BROKERAGE = ROUND(PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL,4),                    
  SERVICETAX = ROUND(SERVICE_TAX + EXSERVICE_TAX,4),                    
  TURN_TAX = ROUND(TURN_TAX,4),                    
  SEBI_TAX = ROUND(SEBI_TAX,4),                    
  INS_CHRG = ROUND(INS_CHRG,4),                    
  BROKER_CHRG = ROUND(BROKER_CHRG,4),                    
  OTHER_CHRG = ROUND(OTHER_CHRG,4)                    
  FROM                     
  MSAJAG..CMBILLVALAN CM , (SELECT SETT_NO, SETT_TYPE, VNO = MAX(VNO), VTYP, BOOKTYPE, VDT = MAX(VDT) FROM ACCOUNT..BILLPOSTED GROUP BY SETT_NO, SETT_TYPE, VTYP, BOOKTYPE) BL                   
  WHERE   /*SAUDA_DATE >= @FROMDT                    
  AND SAUDA_DATE <= @TODT          
  VDT >= @FROMDT                
  AND VDT <=@TODT          */      
  EXISTS (SELECT VNO FROM ACCOUNT..LEDGER L WHERE BL.VNO = L.VNO AND BL.VTYP = L.VTYP AND BL.BOOKTYPE = L.BOOKTYPE       
  AND L.VDT >= @FROMDT                
  AND L.VDT <=@TODT AND CLTCODE = PARTY_CODE )      
  AND PARTY_CODE >= @FROMPARTY                    
  AND PARTY_CODE <= @TOPARTY                
  --AND CM.BRANCH_CD=@STATUSNAME                    
  AND CM.SETT_NO=BL.SETT_NO                
  AND CM.SETT_TYPE=BL.SETT_TYPE                    
  AND CM.BRANCH_CD LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'BRANCH'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUB_BROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
   AND SUB_BROKER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'SUBBROKER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND TRADER LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'TRADER'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
            )                     
            AND CM.FAMILY LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'FAMILY'                     
                  THEN @STATUSNAME    
                  ELSE '%'                     
            END                    
            )                     
            AND CM.PARTY_CODE LIKE (                    
            CASE                     
                  WHEN @STATUSID = 'CLIENT'                     
                  THEN @STATUSNAME                     
                  ELSE '%'                     
            END                    
         )     
                           
                        
END                 
                
                
   INSERT INTO #V2_CLASS_LEDGERSAUDA                    
   SELECT                    
    EXCHANGE,                    
    PARTY_CODE,                    
    CONVERT(VARCHAR,SAUDA_DATE,103),                    
    'BILL',                    
    SETT_NO,                    
    SETT_TYPE,                    
    SCRIP_NAME,                        
    'BUY',                    
    SUM(PQTY),                    
    CASE WHEN SUM(PQTY) > 0 THEN ROUND(SUM(PAMT)/SUM(PQTY),2) END,                    
    0,                    
    SUM(PAMT),           
    0,                    
    SUM(PAMT) * -1,                    
    SAUDA_DATE,                    
    1                    
  FROM                    
   #NSEVALANTABLE                    
  GROUP BY                    
   EXCHANGE,                    
   PARTY_CODE,                    
   SAUDA_DATE,                    
   SETT_NO,                    
   SETT_TYPE,                    
   SCRIP_NAME                    
                       
   INSERT INTO #V2_CLASS_LEDGERSAUDA                    
   SELECT                    
    EXCHANGE,                    
    PARTY_CODE,                    
    CONVERT(VARCHAR,SAUDA_DATE,103),                    
    'BILL',                    
    SETT_NO,                    
    SETT_TYPE,                    
    SCRIP_NAME,                    
    'SELL',                    
    SUM(SQTY),                    
    CASE WHEN SUM(SQTY) > 0 THEN ROUND(SUM(SAMT)/SUM(SQTY),2) END,                    
    0,                    
    0,                    
    SUM(SAMT),                    
    SUM(SAMT),                    
    SAUDA_DATE,                    
    1                    
  FROM                    
   #NSEVALANTABLE          
  GROUP BY                    
   EXCHANGE,                    
   PARTY_CODE,                    
   SAUDA_DATE,                    
   SETT_NO,                    
   SETT_TYPE,                    
   SCRIP_NAME                      
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   PARTY_CODE,                    
   CONVERT(VARCHAR,SAUDA_DATE,103),                    
   'BILL',                    
   SETT_NO,                    
   SETT_TYPE,                    
   'TOTAL CHARGES',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(BROKERAGE + SERVICETAX + TURN_TAX + SEBI_TAX + BROKER_CHRG + INS_CHRG + OTHER_CHRG),                    
   0,                    
   SUM(BROKERAGE + SERVICETAX + TURN_TAX + SEBI_TAX + BROKER_CHRG + INS_CHRG + OTHER_CHRG) * -1,                    
    SAUDA_DATE,                    
   2                    
  FROM                    
   #NSEVALANTABLE                    
  GROUP BY                     
   PARTY_CODE,                    
   SAUDA_DATE,                    
   SETT_NO,                    
   SETT_TYPE      
     
    
    
   
  /*INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   'BILL',                    
   S.SETT_NO,                    
   S.SETT_TYPE,                    
   'SERVICE TAX',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(SERVICETAX),                    
   0,                    
   SUM(SERVICETAX) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   3                    
  FROM                    
   #NSEVALANTABLE S                    
  WHERE                    
   1 = 1                    
   AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                    
   AND S.SAUDA_DATE BETWEEN @FROMDT AND @TODT + ' 23:59:59'                    
  GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE                    
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
  'BILL',                    
   S.SETT_NO,          
   S.SETT_TYPE,                    
   'TURNOVER TAX',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(TURN_TAX),                    
   0,          
   SUM(TURN_TAX) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   4                    
  FROM                    
   #NSEVALANTABLE S                    
  GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE                    
                    
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   'BILL',                    
   S.SETT_NO,                    
   S.SETT_TYPE,                    
   'SEBI TAX',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(SEBI_TAX),                    
   0,                    
   SUM(SEBI_TAX) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   5                    
  FROM                    
   #NSEVALANTABLE S                    
  GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE                    
                    
                    
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',              
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   'BILL',                    
   S.SETT_NO,                    
   S.SETT_TYPE,                    
   'STAMP DUTY',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(BROKER_CHRG),                    
   0,                    
   SUM(BROKER_CHRG) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   6                    
  FROM                    
   #NSEVALANTABLE S                    
  GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE                    
                    
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   'BILL',                    
   S.SETT_NO,                    
   S.SETT_TYPE,                    
   'STT',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(INS_CHRG),                    
   0,                    
   SUM(INS_CHRG) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   7                    
  FROM                    
   #NSEVALANTABLE S                    
 GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE                    
                    
                    
  INSERT INTO #V2_CLASS_LEDGERSAUDA                    
  SELECT                     
   'NSECM',                    
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   'BILL',                    
   S.SETT_NO,                    
   S.SETT_TYPE,                    
   'OTHER CHARGES',                    
   '',                    
   0,                    
   0,                    
   0,                    
   SUM(OTHER_CHRG),                    
   0,                    
   SUM(OTHER_CHRG) * -1,                    
    CONVERT(DATETIME,CONVERT(VARCHAR,S.SAUDA_DATE,103),103),                    
   8                    
  FROM                    
   #NSEVALANTABLE S                    
  GROUP BY                     
   S.PARTY_CODE,                    
   CONVERT(VARCHAR,S.SAUDA_DATE,103),                    
   S.SETT_NO,                    
   S.SETT_TYPE  */                  
      
END      
                    
                    
DELETE FROM #V2_CLASS_LEDGERSAUDA                    
WHERE                    
 VCL_DEBIT = 0                    
 AND VCL_CREDIT = 0                    
 AND VCL_BALANCE = 0                    
 AND VCL_VTYPE <> 'OPENING BALANCE'   
 and VCL_FLAG <> '2'   
   
UPDATE V SET VCL_BALANCE = (SELECT SUM(VCL_BALANCE) FROM #V2_CLASS_LEDGERSAUDA V1   
WHERE V.VCL_PARTY_CODE = V1.VCL_PARTY_CODE AND V.VCL_EXCHANGE = V1.VCL_EXCHANGE AND v1.VCL_FLAG <> '11' AND V1.VCL_ID <= V.VCL_ID)  
FROM #V2_CLASS_LEDGERSAUDA V where VCL_FLAG <> '11' and VCL_REMARKS <> 'CLOSING BALANCE'  
  
UPDATE #V2_CLASS_LEDGERSAUDA SET VCL_BALANCE = CASE WHEN VCL_CREDIT > 0 THEN VCL_CREDIT ELSE -VCL_DEBIT END WHERE VCL_FLAG IN('1', '2')  
  
   
      
/*      
SELECT V.*, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE   AND VCL_SETTNO = ''    
ORDER BY VCL_PARTY_CODE, VCL_EXCHANGE, VCL_DATE, VCL_SETTNO, VCL_SETTTYPE, VCL_FLAG                    
    
SELECT V.*, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE   AND VCL_SETTNO <> ''    
ORDER BY VCL_PARTY_CODE, VCL_EXCHANGE, VCL_DATE, VCL_SETTNO, VCL_SETTTYPE, VCL_FLAG                    
*/    
  
UPDATE #V2_CLASS_LEDGERSAUDA   
SET   
 VCL_VTYPE = 'Provisional'  
WHERE   
 CHARINDEX('PROVISIONAL',VCL_REMARKS) > 0  
  
/*********missing opening entry******/  
INSERT INTO #V2_CLASS_LEDGERSAUDA  
  SELECT   
 DISTINCT    
     VCL_EXCHANGE,                    
  VCL_PARTY_CODE,                    
  CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDT,109),103),                    
  'OPENING BALANCE',                    
  '',                    
  '',                    
  'OPENING BALANCE',                    
  '',                    
  0,                    
  0,                    
  0,                    
  0,                    
  0,                    
  0,                    
  CONVERT(DATETIME,@FROMDT,109),                    
  0                    
  FROM   
 #V2_CLASS_LEDGERSAUDA A  
  WHERE   
 VCL_FLAG = 10  
 AND  
 NOT EXISTS (SELECT VCL_PARTY_CODE FROM #V2_CLASS_LEDGERSAUDA B WHERE VCL_FLAG = 0 AND A.VCL_PARTY_CODE = B.VCL_PARTY_CODE)  
  
  
  
SELECT VCL_ID,VCL_EXCHANGE,VCL_PARTY_CODE,VCL_DT,VCL_VTYPE,VCL_SETTNO,VCL_SETTTYPE,VCL_REMARKS,VCL_BUYSELL,VCL_QTY,VCL_MKTRATE,VCL_NETRATE,VCL_DEBIT ,VCL_CREDIT ,VCL_BALANCE = ROUND(VCL_BALANCE, 2),VCL_DATE,VCL_FLAG, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE AND VCL_FLAG = 0  -- AND VCL_SETTNO = ''  --AND VCL_EXCHANGE = 'NSEFO'  
UNION ALL    
SELECT VCL_ID,VCL_EXCHANGE,VCL_PARTY_CODE,VCL_DT,VCL_VTYPE,VCL_SETTNO,VCL_SETTTYPE,VCL_REMARKS,VCL_BUYSELL,VCL_QTY,VCL_MKTRATE,VCL_NETRATE,VCL_DEBIT ,VCL_CREDIT ,VCL_BALANCE = ROUND(VCL_BALANCE, 2),VCL_DATE,VCL_FLAG, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE AND VCL_FLAG = 10  -- AND VCL_SETTNO = ''  --AND VCL_EXCHANGE = 'NSEFO'  
UNION ALL    
SELECT VCL_ID = MAX(VCL_ID),VCL_EXCHANGE,VCL_PARTY_CODE,VCL_DT = MAX(VCL_DT),VCL_VTYPE = '',VCL_SETTNO = '',  
VCL_SETTTYPE = '',VCL_REMARKS = 'CLOSING BALANCE',VCL_BUYSELL = '',VCL_QTY = 0,VCL_MKTRATE = 0,VCL_NETRATE = 0,  
VCL_DEBIT = SUM(VCL_DEBIT),VCL_CREDIT = SUM(VCL_CREDIT),VCL_BALANCE = ROUND(SUM(VCL_CREDIT) -  SUM(VCL_DEBIT), 2),  
VCL_DATE = MAX(VCL_DATE),VCL_FLAG = 11, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE AND VCL_VTYPE <> 'BILL'  --AND VCL_SETTNO = ''    
GROUP BY VCL_PARTY_CODE,LONG_NAME,VCL_EXCHANGE    
UNION ALL    
SELECT VCL_ID = MAX(VCL_ID),VCL_EXCHANGE = MAX(VCL_EXCHANGE),VCL_PARTY_CODE,VCL_DT = MAX(VCL_DT),VCL_VTYPE = '',VCL_SETTNO = '',  
VCL_SETTTYPE = '',VCL_REMARKS = '<B>COMBINED CLOSING BALANCE</B>',VCL_BUYSELL = '',VCL_QTY = 0,VCL_MKTRATE = 0,VCL_NETRATE = 0,  
VCL_DEBIT = SUM(VCL_DEBIT),VCL_CREDIT = SUM(VCL_CREDIT),VCL_BALANCE = ROUND(SUM(VCL_CREDIT) -  SUM(VCL_DEBIT), 2),  
VCL_DATE = MAX(VCL_DATE),VCL_FLAG = 12, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE   AND VCL_VTYPE <> 'BILL'--AND VCL_SETTNO = ''    
GROUP BY VCL_PARTY_CODE,LONG_NAME --, VCL_SETTNO, VCL_SETTTYPE   
ORDER BY VCL_PARTY_CODE, VCL_EXCHANGE, VCL_FLAG, VCL_DATE, VCL_ID,VCL_SETTNO, VCL_SETTTYPE                    
    
    
SELECT VCL_ID,VCL_EXCHANGE,VCL_PARTY_CODE,VCL_DT,VCL_VTYPE,VCL_SETTNO,VCL_SETTTYPE,VCL_REMARKS,VCL_BUYSELL,VCL_QTY,VCL_MKTRATE,VCL_NETRATE,VCL_DEBIT ,VCL_CREDIT  ,VCL_BALANCE = ROUND(VCL_BALANCE, 2),VCL_DATE,VCL_FLAG, VCL_PARTY_NAME = LONG_NAME    
--INTO LEDGER_PDF     
FROM #V2_CLASS_LEDGERSAUDA V, MSAJAG..CLIENT_DETAILS C    
WHERE V.VCL_PARTY_CODE = C.PARTY_CODE   AND VCL_SETTNO <> ''  and VCL_FLAG <> 10  
ORDER BY VCL_PARTY_CODE, VCL_EXCHANGE, VCL_DATE, VCL_SETTNO, VCL_SETTTYPE, VCL_FLAG      
    
    
EXEC NSEFO..CLS_RPT_PROC_FO_NEWBILLDETAIL_NEW @STATUSID, @STATUSNAME, @FROMDT, @TODT, @FROMPARTY, @TOPARTY, '', '0'    
    
SELECT CL_CODE,L_ADDRESS1,L_CITY,L_ADDRESS2,L_STATE,L_ADDRESS3,L_NATION,L_ZIP,PAN_GIR_NO,WARD_NO,SEBI_REGN_NO,RES_PHONE1,RES_PHONE2,OFF_PHONE1,OFF_PHONE2,MOBILE_PAGER,FAX,EMAIL,CL_TYPE,CL_STATUS FROM MSAJAG..CLIENT_DETAILS D,(SELECT DISTINCT VCL_PARTY_CODE FROM #V2_CLASS_LEDGERSAUDA) V    
WHERE D.CL_CODE =  V.VCL_PARTY_CODE    
      
TRUNCATE TABLE #V2_CLASS_LEDGERSAUDA                    
                    
DROP TABLE #V2_CLASS_LEDGERSAUDA

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_MARGIN_SUMMARY
-- --------------------------------------------------
CREATE PROC [dbo].[CLS_PROC_MARGIN_SUMMARY]
	(
	@STATUSID VARCHAR(25),
	@STATUSNAME VARCHAR(25),
	@PARTYCODE VARCHAR(10),
	@MDATE VARCHAR(11)
	)

	AS

	---EXEC [CLASSPROC_MARGIN_SUMMARY] 'BROKER','BROKER','0A141','NOV 21 2007'

	CREATE TABLE #FOMARGIN
		(
		EXCHANGE	VARCHAR(8),
		MDATE		VARCHAR(11), 
		PARTY_CODE	VARCHAR(15),
		INIT_MARGIN MONEY, 
		EXPO_MARGIN MONEY,
		CASH 		MONEY,
		NONCASH 	MONEY,
		FLAG		VARCHAR(2)
		)

	CREATE TABLE #COLLATERAL
		(
		EXCHANGE	VARCHAR(10),
		SEGMENT		VARCHAR(10),
		COLLDATE	VARCHAR(11), 
		PARTY_CODE	VARCHAR(15),
		CASH 		MONEY, 
		NONCASH 	MONEY
		)

	DECLARE @MMDATE VARCHAR(11)

	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='NSEFO') > 0 
	BEGIN
		SELECT @MMDATE = LEFT(MAX(TRADE_DATE),11)
		FROM   NSEFO..FOCLOSING (NOLOCK)
		WHERE  TRADE_DATE < @MDATE

		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'NSEFO',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(PSPANMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			NSEFO..FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = @MMDATE
			--AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM NSEFO.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END


	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='MCDX') > 0 
	BEGIN
		SELECT @MMDATE = LEFT(MAX(TRADE_DATE),11)
		FROM   MCDX..FOCLOSING (NOLOCK)
		WHERE  TRADE_DATE < @MDATE

		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'MCDX',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(TOTALMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			MCDX..FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = @MMDATE
			--AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM MCDX.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END


	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='NCDX') > 0 
	BEGIN
		SELECT @MMDATE = LEFT(MAX(TRADE_DATE),11)
		FROM   NCDX..FOCLOSING (NOLOCK)
		WHERE  TRADE_DATE < @MDATE

		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'NCDX',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(PSPANMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			NCDX..FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = @MMDATE
			--AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM NCDX.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END

	/*
	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='BSEFO') > 0 
	BEGIN
		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'BSEFO',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(PSPANMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			BSEFO.DBO.FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM BSEFO.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END
	*/

	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='NSECURFO') > 0 
	BEGIN
		SELECT @MMDATE = LEFT(MAX(TRADE_DATE),11)
		FROM   NSECURFO..FOCLOSING (NOLOCK)
		WHERE  TRADE_DATE < @MDATE

		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'NSECURFO',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(PSPANMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			NSECURFO..FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = @MMDATE
			--AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM NSECURFO.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END

	/*
	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='BSECURFO') > 0 
	BEGIN
		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'BSX',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(PSPANMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			BSECURFO.DBO.FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM BSECURFO.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END
	*/

	IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='MCDXCDS') > 0 
	BEGIN
		SELECT @MMDATE = LEFT(MAX(TRADE_DATE),11)
		FROM   MCDXCDS..FOCLOSING (NOLOCK)
		WHERE  TRADE_DATE < @MDATE

		INSERT INTO #FOMARGIN
		SELECT
			EXCHANGE = 'MCDXCDS',
			MDATE = LEFT(MDATE,11), 
			PARTY_CODE,
			INIT_MARGIN = ISNULL(SUM(TOTALMARGIN),0), 
			EXPO_MARGIN = ISNULL(SUM(MTOM),0),
			CASH 		= 0,
			NONCASH 	= 0,
			FLAG		= 'M'
		FROM 
			MCDXCDS..FOMARGINNEW (NOLOCK) 
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND LEFT(MDATE,11) = @MMDATE
			--AND LEFT(MDATE,11) = (SELECT LEFT(MAX(MDATE),11) FROM MCDXCDS.DBO.FOMARGINNEW (NOLOCK) WHERE PARTY_CODE = @PARTYCODE)
		GROUP BY 
			LEFT(MDATE,11),
			PARTY_CODE
	END

	DELETE FROM #FOMARGIN
	WHERE (INIT_MARGIN + EXPO_MARGIN) = 0

	SELECT @MMDATE = LEFT(MAX(TRANS_DATE),11) FROM MSAJAG..COLLATERAL (NOLOCK)
	WHERE PARTY_CODE = @PARTYCODE

	INSERT INTO #COLLATERAL
	SELECT
		EXCHANGE,
		SEGMENT,
		COLLDATE 	= LEFT(TRANS_DATE,11),
		PARTY_CODE,
		CASH 		= ISNULL(SUM(CASH),0),
		NONCASH 	= ISNULL(SUM(NONCASH),0)
	FROM 
		MSAJAG..COLLATERAL (NOLOCK)
	WHERE 
		PARTY_CODE = @PARTYCODE
		AND LEFT(TRANS_DATE,11) = @MMDATE
	GROUP BY 
		EXCHANGE,
		SEGMENT,
		LEFT(TRANS_DATE,11),
		PARTY_CODE

	UPDATE #COLLATERAL SET
	EXCHANGE = (CASE 
			WHEN #COLLATERAL.EXCHANGE = 'NSE' AND #COLLATERAL.SEGMENT ='CAPITAL' THEN 'NSECM' 
			WHEN #COLLATERAL.EXCHANGE = 'BSE' AND #COLLATERAL.SEGMENT ='CAPITAL' THEN 'BSECM' 
			ELSE SHAREDB
			END)
	FROM CLS_MULTICOMPANY M 
	WHERE PRIMARYSERVER = 1
	AND #COLLATERAL.EXCHANGE = M.EXCHANGE
	AND #COLLATERAL.SEGMENT	 = M.SEGMENT

	INSERT INTO #FOMARGIN
	SELECT
		EXCHANGE,
		COLLDATE, 
		PARTY_CODE,
		INIT_MARGIN = 0, 
		EXPO_MARGIN = 0,
		CASH 		= CASH,
		NONCASH 	= NONCASH,
		FLAG		= 'C'
	FROM
		#COLLATERAL

	SELECT * FROM #FOMARGIN ORDER BY FLAG DESC

	DROP TABLE #FOMARGIN
	DROP TABLE #COLLATERAL

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_QUARTERLYLEDGER_OPENBAL
-- --------------------------------------------------


CREATE PROC [dbo].[CLS_PROC_QUARTERLYLEDGER_OPENBAL]                      
(                      
 @FROMPARTY VARCHAR(10),                      
 @TOPARTY VARCHAR(10),                
 @STARTDT VARCHAR(11) ,
 @STATUSID VARCHAR(25),                
 @STATUSNAME VARCHAR(25)                                 
)                     
                      
/*                      
EXEC CLASS_PROC_QUARTERLYLEDGER_OPENBAL '00000010', '00000010', 'JUL 27 2009'         
*/                      
                      
AS                      
                
                
SET NOCOUNT ON                      
                      
CREATE TABLE [cspl].[#QUARTERLYLEDGER](                
 [CQL_ID] [bigint] IDENTITY(1,1) NOT NULL,                
 [CQL_SEGMENT] [varchar](20) NULL,                
 [CQL_PARTYCODE] [varchar](10) NULL,                
 [CQL_VDT] [varchar](20) NULL,                
 [CQL_EDT] [varchar](20) NULL,                
 [CQL_VTYPE] [varchar](10) NULL,                
 [CQL_VNO] [varchar](20) NULL,                
 [CQL_ACCODE] [varchar](10) NULL,                
 [CQL_REMARKS] [varchar](255) NULL,                
 [CQL_DDNO] [varchar](20) NULL,                
 [CQL_DEBIT] [money] NULL,                
 [CQL_CREDIT] [money] NULL,                
 [CQL_BALANCE] [money] NULL,                
 [CQL_ORDERBY] [tinyint] NULL,                
 [CQL_DT] [int] NULL,                
 [CQL_ACNAME] [varchar](100) NULL                
) ON [PRIMARY]                
                      
TRUNCATE TABLE #QUARTERLYLEDGER                      
                      
DECLARE @@SDTCUR VARCHAR(11)                      
                      
                      
/* NOW DOING NSECM */                      
set  @STARTDT = (select CONVERT(varchar(11),CONVERT(datetime,@STARTDT,103),109))                     
                      
SELECT                       
 @@SDTCUR = CONVERT(VARCHAR(11),SDTCUR ,109)                      
FROM                       
 ACCOUNT..PARAMETER (NOLOCK)                      
WHERE                      
 @STARTDT BETWEEN SDTCUR AND LDTCUR                      
   
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO #QUARTERLYLEDGER                      
SELECT                       
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                      
 CQL_EDT,                
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
   CQL_SEGMENT = 'NSECM',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_EDT = '',                
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                      
   CQL_REMARKS = 'OPENING BALANCE',                      
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 1,                      
   CQL_ACNAME = A.ACNAME                      
  FROM                      
   ACCOUNT..LEDGER L (NOLOCK)                       
   INNER JOIN                      
   ACCOUNT..ACMAST A (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))                      
  WHERE                 
   L.VDT < @STARTDT    
   AND L.VDT >= @@SDTCUR                               
   AND L.VTYP <> '18'
   AND A.CLTCODE >= @FROMPARTY                      
   AND A.CLTCODE <= @TOPARTY                  
   
   union all
   
     SELECT                       
   CQL_SEGMENT = 'NSECM',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_EDT = '',                
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                      
   CQL_REMARKS = 'OPENING BALANCE',                      
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 1,                      
   CQL_ACNAME = A.ACNAME                      
  FROM                      
   ACCOUNT..LEDGER L (NOLOCK)                       
   INNER JOIN                      
   ACCOUNT..ACMAST A (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))                      
  WHERE                 
   L.VDT LIKE  @@SDTCUR + '%'   
   AND L.Vtyp = 18                            
   AND A.CLTCODE >= @FROMPARTY                      
   AND A.CLTCODE <= @TOPARTY 
 ) X                      
GROUP BY                      
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                      
 CQL_EDT,        
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_ORDERBY,                      
 CQL_ACNAME                      
                      
                      
                      
                      
/* NOW DOING BSECM */                      
                      
                      
SELECT                       
 @@SDTCUR = SDTCUR                       
FROM                       
 ACCOUNTFO..PARAMETER (NOLOCK)                      
WHERE                      
 @STARTDT BETWEEN SDTCUR AND LDTCUR                      
                      
                      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                      
INSERT INTO #QUARTERLYLEDGER                      
SELECT                       
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                
 CQL_EDT,                      
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
   CQL_SEGMENT = 'NSEFO',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_EDT = '',                
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                      
   CQL_REMARKS = 'OPENING BALANCE',                      
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 3,                      
   CQL_ACNAME = A.ACNAME                      
  FROM                      
   ACCOUNTFO..LEDGER L (NOLOCK)                       
   INNER JOIN                      
   ACCOUNTFO..ACMAST A (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))                      
  WHERE                       
   L.VDT < @STARTDT    
   AND L.VDT >= @@SDTCUR                               
   AND L.VTYP <> '18'                              
   AND A.CLTCODE >= @FROMPARTY                      
   AND A.CLTCODE <= @TOPARTY                      
   
   UNION ALL
   
   SELECT                       
   CQL_SEGMENT = 'NSEFO',                       
   CQL_PARTYCODE = L.CLTCODE,                      
   CQL_VDT = '',                      
   CQL_EDT = '',                
   CQL_VTYPE = '',                      
   CQL_VNO = '',                      
   CQL_ACCODE = '',                      
   CQL_REMARKS = 'OPENING BALANCE',                      
   CQL_DDNO = '',                      
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),                      
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),                      
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),                      
   CQL_ORDERBY = 3,                      
   CQL_ACNAME = A.ACNAME                      
  FROM                      
   ACCOUNTFO..LEDGER L (NOLOCK)                       
   INNER JOIN                      
   ACCOUNTFO..ACMAST A (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))                      
  WHERE                       
   L.VDT LIKE  @@SDTCUR + '%'   
   AND L.Vtyp = 18                                      
   AND A.CLTCODE >= @FROMPARTY                      
   AND A.CLTCODE <= @TOPARTY    
   
 ) X                      
GROUP BY                      
 CQL_SEGMENT,                      
 CQL_PARTYCODE,                      
 CQL_VDT,                      
 CQL_EDT,                      
 CQL_VTYPE,                      
 CQL_VNO,                      
 CQL_ACCODE,                      
 CQL_REMARKS,                      
 CQL_DDNO,                      
 CQL_ORDERBY,                      
 CQL_ACNAME                      
                      
    
SELECT       
 CQL_PARTYCODE,      
 CQL_SEGMENT,      
 CQL_DEBIT,      
 CQL_CREDIT,      
 CQL_BALANCE      
FROM #QUARTERLYLEDGER                  
ORDER BY      
 CQL_PARTYCODE,      
 CQL_SEGMENT        
TRUNCATE TABLE #QUARTERLYLEDGER                
DROP TABLE #QUARTERLYLEDGER

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_QUARTERLYLEDGER_SUMM_NEW
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CLS_PROC_QUARTERLYLEDGER_SUMM_NEW]
	@FROMPARTY [varchar](10),
	@TOPARTY [varchar](10),
	@STARTDT [varchar](11),
	@ENDDT [varchar](11)
AS

SET NOCOUNT ON

IF LEN(@STARTDT) = 10 AND CHARINDEX('/', @STARTDT) > 0
BEGIN
	SET @STARTDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @STARTDT, 103), 109)
END
IF LEN(@ENDDT) = 10 AND CHARINDEX('/', @ENDDT) > 0
BEGIN
	SET @ENDDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @ENDDT, 103), 109)
END

CREATE TABLE [DBO].[#QUARTERLYLEDGER](
	[CQL_ID] [BIGINT] IDENTITY(1,1) NOT NULL,
	[CQL_EXCHANGE] [VARCHAR](5) NULL,
	[CQL_SEGMENT] [VARCHAR](20) NULL,
	[CQL_PARTYCODE] [VARCHAR](10) NULL,
	[CQL_LED_BALANCE] [MONEY] NULL,
	[CQL_UNSETTLED_TRADE] [MONEY] NULL,
	[CQL_UNCLEARED_CHEQUS] [MONEY] NULL,
	[CQL_CASH_COLL] [MONEY] NULL,
	[CQL_NONCASH_COLL] [MONEY] NULL,
	[CQL_MARGIN_REQ] [MONEY] NULL,
	[CQL_MARGIN_SHORT] [MONEY] NULL,
	[CQL_DEBIT_STOCK] [MONEY] NULL,
	[MDATE] [VARCHAR](11) NULL,
	[CDATE] [VARCHAR](11) NULL,
	[CQL_ORDERBY] [INT] NULL
	
	
) ON [PRIMARY]

TRUNCATE TABLE #QUARTERLYLEDGER

DECLARE @@SDTCUR DATETIME

/* NOW DOING NSECM */	

DECLARE @EXCHANGE		VARCHAR(3)
DECLARE @SEGMENT 		VARCHAR(10)
DECLARE @SHAREDB		VARCHAR(35)
DECLARE @SHARESERVER	VARCHAR(35)
DECLARE @ACCOUNTDB		VARCHAR(35)
DECLARE @ACCOUNTSERVER	VARCHAR(35)
DECLARE @EXCHANGEWISE_CURSOR CURSOR
DECLARE	@STRSQL			VARCHAR(8000)
DECLARE	@MDATE			VARCHAR(11)
DECLARE	@CDATE			VARCHAR(11)


CREATE TABLE #MDATE
(
	MDATE DATETIME
)

DECLARE
	@@NFOSHARESERVER VARCHAR(20)
	
SELECT @@NFOSHARESERVER = SHARESERVER FROM CLS_MULTICOMPANY WHERE SHAREDB = 'NSEFO'

SET @STRSQL = "INSERT INTO #MDATE SELECT LEFT(MAX(MDATE),11) FROM " + @@NFOSHARESERVER + ".NSEFO.DBO.FOMARGINNEW WITH (NOLOCK) WHERE MDATE <= '" +  @ENDDT + + " 23:59'"
EXEC (@STRSQL)

SELECT @MDATE= MDATE FROM #MDATE

SET @EXCHANGEWISE_CURSOR = CURSOR FOR
SELECT	DISTINCT EXCHANGE=M.EXCHANGE,SEGMENT=M.SEGMENT,SHAREDB,SHARESERVER,ACCOUNTDB,ACCOUNTSERVER 
FROM	CLS_MULTICOMPANY M WITH (NOLOCK),
		MSAJAG..CLIENT_BROK_DETAILS CB WITH (NOLOCK)
WHERE	M.EXCHANGE NOT IN ('UCX','USM','USX','FDX')
		AND CB.EXCHANGE = M.EXCHANGE
		AND CB.SEGMENT = M.SEGMENT
		AND PRIMARYSERVER = 1 
		AND CB.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY

OPEN @EXCHANGEWISE_CURSOR 
FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @EXCHANGE,@SEGMENT,@SHAREDB,@SHARESERVER,@ACCOUNTDB,@ACCOUNTSERVER

WHILE @@FETCH_STATUS = 0
BEGIN
	
		SET @STRSQL = ''
		IF @SEGMENT = 'CAPITAL'
		BEGIN
				SET @STRSQL =''
				SET @STRSQL ='INSERT INTO #QUARTERLYLEDGER '
				SET @STRSQL = @STRSQL + '	SELECT '
				SET @STRSQL = @STRSQL + ' 		CQL_EXCHANGE = '''+ @EXCHANGE +''','
				SET @STRSQL = @STRSQL + ' 		CQL_SEGMENT = '''+ @SEGMENT +''','
				SET @STRSQL = @STRSQL + '		CQL_PARTYCODE = CLTCODE,'
				SET @STRSQL = @STRSQL + '		CQL_LED_BALANCE = SUM(VAMT),'
				SET @STRSQL = @STRSQL + '		CQL_UNSETTLED_TRADE = 0,'
				SET @STRSQL = @STRSQL + '		CQL_UNCLEARED_CHEQUS = 0,'
				SET @STRSQL = @STRSQL + '		CQL_CASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '		CQL_NONCASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '		CQL_MARGIN_REQ = 0,'
				SET @STRSQL = @STRSQL + '		CQL_MARGIN_SHORT = 0,'
				SET @STRSQL = @STRSQL + '		CQL_DEBIT_STOCK = 0,'
				SET @STRSQL = @STRSQL + ' 		MDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + ' 		CDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + '		CQL_ORDERBY = 1'
				SET @STRSQL = @STRSQL + '	FROM'
				SET @STRSQL = @STRSQL + '		('
				SET @STRSQL = @STRSQL + '			SELECT'
				SET @STRSQL = @STRSQL + '				CLTCODE,'
				SET @STRSQL = @STRSQL + '				SUM( CASE WHEN DRCR =''C'' THEN VAMT ELSE - VAMT END) VAMT'
				SET @STRSQL = @STRSQL + '			FROM'
				SET @STRSQL = @STRSQL + '				' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'LEDGER L WITH (NOLOCK), '
				SET @STRSQL = @STRSQL + '				' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'PARAMETER P WITH (NOLOCK) '
				SET @STRSQL = @STRSQL + '			WHERE'
				SET @STRSQL = @STRSQL + '				L.VDT BETWEEN P.SDTCUR AND P.LDTCUR '
				SET @STRSQL = @STRSQL + '				AND GETDATE() BETWEEN P.SDTCUR AND P.LDTCUR '
				SET @STRSQL = @STRSQL + '				AND VDT <= ''' + @ENDDT + ' 23:59'''
				SET @STRSQL = @STRSQL + '				AND CLTCODE >= ''' + @FROMPARTY +''''
				SET @STRSQL = @STRSQL + '				AND CLTCODE <= ''' + @TOPARTY +''''
				SET @STRSQL = @STRSQL + '			GROUP BY CLTCODE' 
				SET @STRSQL = @STRSQL + '		) CLOSEBAL'
				SET @STRSQL = @STRSQL + '	GROUP BY'
				SET @STRSQL = @STRSQL + '		CLTCODE '

				EXEC( @STRSQL)
				--PRINT @STRSQL
				
				SET @STRSQL = ''
				IF @EXCHANGE = 'BSE'
				BEGIN
					SET @STRSQL =''
					SET @STRSQL ='INSERT INTO #QUARTERLYLEDGER '
					SET @STRSQL = @STRSQL + 'SELECT '
					SET @STRSQL = @STRSQL + ' 	CQL_EXCHANGE = '''+ @EXCHANGE +''','
					SET @STRSQL = @STRSQL + ' 	CQL_SEGMENT = '''+ @SEGMENT +''','
					SET @STRSQL = @STRSQL + '	CQL_PARTYCODE = PARTY_CODE,'
					SET @STRSQL = @STRSQL + '	CQL_LED_BALANCE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNSETTLED_TRADE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNCLEARED_CHEQUS = 0,'
					SET @STRSQL = @STRSQL + '	CQL_CASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_NONCASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = SUM(VARAMT+ELM),'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_SHORT = 0,'
					SET @STRSQL = @STRSQL + '	CQL_DEBIT_STOCK = 0,'
					SET @STRSQL = @STRSQL + ' 	MDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + ' 	CDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + '	CQL_ORDERBY = 1 '
					SET @STRSQL = @STRSQL + 'FROM '
					SET @STRSQL = @STRSQL + '	' + @SHARESERVER + '.' + @SHAREDB + '.DBO.TBL_MG02 WITH (NOLOCK) '
					SET @STRSQL = @STRSQL + 'WHERE '
					SET @STRSQL = @STRSQL + '	MARGIN_DATE BETWEEN '''+ @MDATE +''' AND ''' + @MDATE + ' 23:59'''
					SET @STRSQL = @STRSQL + '	AND PARTY_CODE BETWEEN ''' + @FROMPARTY +''' AND ''' + @TOPARTY +''''
					SET @STRSQL = @STRSQL + 'GROUP BY '
					SET @STRSQL = @STRSQL + '	PARTY_CODE '
					EXEC( @STRSQL)
					--PRINT @STRSQL
				END
				ELSE
				BEGIN
					SET @STRSQL =''
					SET @STRSQL ='INSERT INTO #QUARTERLYLEDGER '
					SET @STRSQL = @STRSQL + 'SELECT '
					SET @STRSQL = @STRSQL + ' 	CQL_EXCHANGE = '''+ @EXCHANGE +''','
					SET @STRSQL = @STRSQL + ' 	CQL_SEGMENT = '''+ @SEGMENT +''','
					SET @STRSQL = @STRSQL + '	CQL_PARTYCODE = PARTY_CODE,'
					SET @STRSQL = @STRSQL + '	CQL_LED_BALANCE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNSETTLED_TRADE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNCLEARED_CHEQUS = 0,'
					SET @STRSQL = @STRSQL + '	CQL_CASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_NONCASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = SUM(VARAMT) + (CASE WHEN SUM(MTOM) > 0 THEN -ABS(SUM(MTOM)) ELSE ABS(SUM(MTOM)) END),'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_SHORT = 0,'
					SET @STRSQL = @STRSQL + '	CQL_DEBIT_STOCK = 0,'
					SET @STRSQL = @STRSQL + ' 	MDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + ' 	CDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + '	CQL_ORDERBY = 1 '
					SET @STRSQL = @STRSQL + 'FROM '
					SET @STRSQL = @STRSQL + '	' + @SHARESERVER + '.' + @SHAREDB + '.DBO.TBL_MG02 WITH (NOLOCK) '
					SET @STRSQL = @STRSQL + 'WHERE '
					SET @STRSQL = @STRSQL + '	MARGIN_DATE BETWEEN '''+ @MDATE +''' AND ''' + @MDATE + ' 23:59'''
					SET @STRSQL = @STRSQL + '	AND PARTY_CODE BETWEEN ''' + @FROMPARTY +''' AND ''' + @TOPARTY +''''
					SET @STRSQL = @STRSQL + 'GROUP BY '
					SET @STRSQL = @STRSQL + '	PARTY_CODE '
					EXEC( @STRSQL)
					--PRINT @STRSQL
				END


				SET @STRSQL =''
				SET @STRSQL = 'INSERT INTO #QUARTERLYLEDGER '
				SET @STRSQL = @STRSQL + 'SELECT '
				SET @STRSQL = @STRSQL + ' 	CQL_EXCHANGE = '''+ @EXCHANGE +''','
				SET @STRSQL = @STRSQL + ' 	CQL_SEGMENT = '''+ @SEGMENT +''','
				SET @STRSQL = @STRSQL + '	CQL_PARTYCODE = PARTY_CODE,'
				SET @STRSQL = @STRSQL + '	CQL_LED_BALANCE = 0,'
				SET @STRSQL = @STRSQL + '	CQL_UNSETTLED_TRADE = SUM(TRDAMT),'
				SET @STRSQL = @STRSQL + '	CQL_UNCLEARED_CHEQUS = 0,'
				SET @STRSQL = @STRSQL + '	CQL_CASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '	CQL_NONCASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = 0,'
				SET @STRSQL = @STRSQL + '	CQL_MARGIN_SHORT = 0,'
				SET @STRSQL = @STRSQL + '	CQL_DEBIT_STOCK = 0,'
				SET @STRSQL = @STRSQL + ' 	MDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + ' 	CDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + '	CQL_ORDERBY = 1 '
				SET @STRSQL = @STRSQL + 'FROM '
				SET @STRSQL = @STRSQL + '	' + @SHARESERVER + '.' + @SHAREDB + '.DBO.CMBILLVALAN C WITH (NOLOCK) '
				SET @STRSQL = @STRSQL + 'WHERE '
				SET @STRSQL = @STRSQL + '	SAUDA_DATE BETWEEN '''+ @STARTDT +''' AND ''' + @ENDDT + ' 23:59'''
				SET @STRSQL = @STRSQL + '	AND PARTY_CODE BETWEEN ''' + @FROMPARTY +''' AND ''' + @TOPARTY +''''
				SET @STRSQL = @STRSQL + '	AND TRADETYPE NOT IN ( ''SCF'',''ICF'',''IR'' ) '
				SET @STRSQL = @STRSQL + '	AND EXISTS (SELECT DISTINCT SETT_NO FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.SETT_MST SM WITH (NOLOCK)'
				SET @STRSQL = @STRSQL + '	WHERE FUNDS_PAYIN > GETDATE() '
				SET @STRSQL = @STRSQL + '	AND SM.SETT_NO = C.SETT_NO AND SM.SETT_TYPE = C.SETT_TYPE) '
				SET @STRSQL = @STRSQL + 'GROUP BY '
				SET @STRSQL = @STRSQL + '	PARTY_CODE '
				EXEC( @STRSQL)
				--PRINT @STRSQL

		END
		ELSE
		BEGIN
				SET @STRSQL =''
				SET @STRSQL ='INSERT INTO #QUARTERLYLEDGER '
				SET @STRSQL = @STRSQL + '	SELECT '
				SET @STRSQL = @STRSQL + ' 		CQL_EXCHANGE = '''+ @EXCHANGE +''','
				SET @STRSQL = @STRSQL + ' 		CQL_SEGMENT = '''+ @SEGMENT +''','
				SET @STRSQL = @STRSQL + '		CQL_PARTYCODE = CLTCODE,'
				SET @STRSQL = @STRSQL + '		CQL_LED_BALANCE = SUM(VAMT),'
				SET @STRSQL = @STRSQL + '		CQL_UNSETTLED_TRADE = 0,'
				SET @STRSQL = @STRSQL + '		CQL_UNCLEARED_CHEQUS = 0,'
				SET @STRSQL = @STRSQL + '		CQL_CASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '		CQL_NONCASH_COLL = 0,'
				SET @STRSQL = @STRSQL + '		CQL_MARGIN_REQ = 0,'
				SET @STRSQL = @STRSQL + '		CQL_MARGIN_SHORT = 0,'
				SET @STRSQL = @STRSQL + '		CQL_DEBIT_STOCK = 0,'
				SET @STRSQL = @STRSQL + ' 	    MDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + ' 	    CDATE = '''+ @ENDDT +''','
				SET @STRSQL = @STRSQL + '		CQL_ORDERBY = 2'
				SET @STRSQL = @STRSQL + '	FROM'
				SET @STRSQL = @STRSQL + '		('
				SET @STRSQL = @STRSQL + '			SELECT'
				SET @STRSQL = @STRSQL + '				CLTCODE,'
				SET @STRSQL = @STRSQL + '				SUM( CASE WHEN DRCR =''C'' THEN VAMT ELSE - VAMT END) VAMT'
				SET @STRSQL = @STRSQL + '			FROM'
				SET @STRSQL = @STRSQL + '				' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'LEDGER L WITH (NOLOCK), '
				SET @STRSQL = @STRSQL + '				' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'PARAMETER P WITH (NOLOCK) '
				SET @STRSQL = @STRSQL + '			WHERE'
				SET @STRSQL = @STRSQL + '				L.VDT BETWEEN P.SDTCUR AND P.LDTCUR '
				SET @STRSQL = @STRSQL + '				AND GETDATE() BETWEEN P.SDTCUR AND P.LDTCUR '
				SET @STRSQL = @STRSQL + '				AND VDT <= ''' + @ENDDT + ' 23:59'''
				SET @STRSQL = @STRSQL + '				AND CLTCODE >= ''' + @FROMPARTY +''''
				SET @STRSQL = @STRSQL + '				AND CLTCODE <= ''' + @TOPARTY +''''
				SET @STRSQL = @STRSQL + '			GROUP BY CLTCODE' 
				SET @STRSQL = @STRSQL + '		) CLOSEBAL'
				SET @STRSQL = @STRSQL + '	GROUP BY'
				SET @STRSQL = @STRSQL + '		CLTCODE'
				EXEC( @STRSQL)
				--PRINT @STRSQL

				SET @STRSQL = ''
				IF @EXCHANGE = 'BSE'
				BEGIN
					SET @STRSQL =''
					SET @STRSQL = 'INSERT INTO #QUARTERLYLEDGER '
					SET @STRSQL = @STRSQL + 'SELECT '
					SET @STRSQL = @STRSQL + ' 	CQL_EXCHANGE = '''+ @EXCHANGE +''','
					SET @STRSQL = @STRSQL + ' 	CQL_SEGMENT = '''+ @SEGMENT +''','
					SET @STRSQL = @STRSQL + '	CQL_PARTYCODE = PARTY_CODE,'
					SET @STRSQL = @STRSQL + '	CQL_LED_BALANCE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNSETTLED_TRADE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNCLEARED_CHEQUS = 0,'
					SET @STRSQL = @STRSQL + '	CQL_CASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_NONCASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = ABS(SUM(SPAN_MARGIN))+ABS(SUM(EXTREME_LOSS_MARGIN)),'
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_SHORT = 0,'
					SET @STRSQL = @STRSQL + '	CQL_DEBIT_STOCK = 0,'
					SET @STRSQL = @STRSQL + ' 	MDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + ' 	CDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + '	CQL_ORDERBY = 2 '
					SET @STRSQL = @STRSQL + 'FROM '
					SET @STRSQL = @STRSQL + '	' + @SHARESERVER + '.' + @SHAREDB + '.DBO.BFOMARGIN WITH (NOLOCK) '
					SET @STRSQL = @STRSQL + 'WHERE '
					SET @STRSQL = @STRSQL + '	MARGIN_DATE BETWEEN '''+ @MDATE +''' AND ''' + @MDATE + ' 23:59'''
					SET @STRSQL = @STRSQL + '	AND PARTY_CODE BETWEEN ''' + @FROMPARTY +''' AND ''' + @TOPARTY +''''
					SET @STRSQL = @STRSQL + 'GROUP BY '
					SET @STRSQL = @STRSQL + '	PARTY_CODE '
					--PRINT @STRSQL
					EXEC( @STRSQL)
					
				END
				ELSE
				BEGIN
					SET @STRSQL = 'IF (SELECT COUNT(1) FROM ' + @SHARESERVER + '.' + @SHAREDB + '.DBO.SYSOBJECTS WHERE NAME = ''FOMARGINNEW'') > 0  '
					SET @STRSQL = @STRSQL + 'BEGIN '
					SET @STRSQL = @STRSQL + 'INSERT INTO #QUARTERLYLEDGER '
					SET @STRSQL = @STRSQL + 'SELECT '
					SET @STRSQL = @STRSQL + ' 	CQL_EXCHANGE = '''+ @EXCHANGE +''','
					SET @STRSQL = @STRSQL + ' 	CQL_SEGMENT = '''+ @SEGMENT +''','
					SET @STRSQL = @STRSQL + '	CQL_PARTYCODE = PARTY_CODE,'
					SET @STRSQL = @STRSQL + '	CQL_LED_BALANCE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNSETTLED_TRADE = 0,'
					SET @STRSQL = @STRSQL + '	CQL_UNCLEARED_CHEQUS = 0,'
					SET @STRSQL = @STRSQL + '	CQL_CASH_COLL = 0,'
					SET @STRSQL = @STRSQL + '	CQL_NONCASH_COLL = 0,'
					IF @EXCHANGE IN ('MFO','MFC')
					BEGIN
						SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = ABS(SUM(INITIAL_MARGIN)) + ABS(SUM(MTM)),'
					END
					ELSE IF @EXCHANGE IN ('ACE','BSX')
					BEGIN
						SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = ABS(SUM(TOTAL_MARGIN)),'
					END
					ELSE
					BEGIN
						SET @STRSQL = @STRSQL + '	CQL_MARGIN_REQ = ABS(SUM(PSPANMARGIN))+ ABS(SUM(NONSPREADMARGIN)) + ABS(SUM(MTOM)),'
					END
					SET @STRSQL = @STRSQL + '	CQL_MARGIN_SHORT = 0,'
					SET @STRSQL = @STRSQL + '	CQL_DEBIT_STOCK = 0,'
					SET @STRSQL = @STRSQL + ' 	MDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + ' 	CDATE = '''+ @ENDDT +''','
					SET @STRSQL = @STRSQL + '	CQL_ORDERBY = 2 '
					SET @STRSQL = @STRSQL + 'FROM '
					SET @STRSQL = @STRSQL + '	' + @SHARESERVER + '.' + @SHAREDB + '.DBO.FOMARGINNEW WITH (NOLOCK) '
					SET @STRSQL = @STRSQL + 'WHERE '
					SET @STRSQL = @STRSQL + '	MDATE BETWEEN '''+ @MDATE +''' AND ''' + @MDATE + ' 23:59'''
					
					SET @STRSQL = @STRSQL + '	AND PARTY_CODE BETWEEN ''' + @FROMPARTY +''' AND ''' + @TOPARTY +''''
					SET @STRSQL = @STRSQL + 'GROUP BY '
					SET @STRSQL = @STRSQL + '	PARTY_CODE '
					SET @STRSQL = @STRSQL + 'END '
					--PRINT @STRSQL
					EXEC( @STRSQL)
				END
		END

	SET @STRSQL =''
	SET @STRSQL ='INSERT INTO #QUARTERLYLEDGER '
	SET @STRSQL = @STRSQL + '	SELECT '
	SET @STRSQL = @STRSQL + ' 		CQL_EXCHANGE = '''+ @EXCHANGE +''','
	SET @STRSQL = @STRSQL + ' 		CQL_SEGMENT = '''+ @SEGMENT +''','
	SET @STRSQL = @STRSQL + '		CQL_PARTYCODE = CLTCODE,'
	SET @STRSQL = @STRSQL + '		CQL_LED_BALANCE = 0,'
	SET @STRSQL = @STRSQL + '		CQL_UNSETTLED_TRADE = 0,'
	SET @STRSQL = @STRSQL + '		CQL_UNCLEARED_CHEQUS = SUM(VAMT),'
	SET @STRSQL = @STRSQL + '		CQL_CASH_COLL = 0,'
	SET @STRSQL = @STRSQL + '		CQL_NONCASH_COLL = 0,'
	SET @STRSQL = @STRSQL + '		CQL_MARGIN_REQ = 0,'
	SET @STRSQL = @STRSQL + '		CQL_MARGIN_SHORT = 0,'
	SET @STRSQL = @STRSQL + '		CQL_DEBIT_STOCK = 0,'
	SET @STRSQL = @STRSQL + ' 	    MDATE = '''+ @ENDDT +''','
	SET @STRSQL = @STRSQL + ' 	    CDATE = '''+ @ENDDT +''','
	SET @STRSQL = @STRSQL + '		CQL_ORDERBY = (CASE WHEN '''+ @SEGMENT +''' = ''CAPITAL'' THEN 1 ELSE 2 END)'
	SET @STRSQL = @STRSQL + '	FROM'
	SET @STRSQL = @STRSQL + '		('
	SET @STRSQL = @STRSQL + '		SELECT'
	SET @STRSQL = @STRSQL + '			CLTCODE,'
	SET @STRSQL = @STRSQL + '			SUM( CASE WHEN DRCR =''C'' THEN VAMT ELSE - VAMT END) VAMT'      
	SET @STRSQL = @STRSQL + '		FROM '
	SET @STRSQL = @STRSQL + '			' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'LEDGER WITH (NOLOCK)'
	SET @STRSQL = @STRSQL + '		WHERE '     
	SET @STRSQL = @STRSQL + '			VDT >= (SELECT SDTCUR FROM ' + @ACCOUNTSERVER + '.' + @ACCOUNTDB + '.DBO.' + 'PARAMETER WITH (NOLOCK) WHERE '''+ @STARTDT +''' BETWEEN SDTCUR AND LDTCUR)'
	SET @STRSQL = @STRSQL + '			AND VDT <= '''+ @ENDDT + ' 23:59'''
	SET @STRSQL = @STRSQL + '			AND EDT > '''+ @ENDDT + ' 23:59'''
	SET @STRSQL = @STRSQL + '			AND CLTCODE = '''+ @FROMPARTY + ''''
	SET @STRSQL = @STRSQL + '			AND VTYP = ''2'''
	SET @STRSQL = @STRSQL + '		GROUP BY CLTCODE '  
	SET @STRSQL = @STRSQL + '		) A'
	SET @STRSQL = @STRSQL + '	GROUP BY CLTCODE '  
	EXEC( @STRSQL)
				
	FETCH NEXT FROM @EXCHANGEWISE_CURSOR INTO @EXCHANGE,@SEGMENT,@SHAREDB,@SHARESERVER,@ACCOUNTDB,@ACCOUNTSERVER
	--END
END

CLOSE @EXCHANGEWISE_CURSOR
DEALLOCATE @EXCHANGEWISE_CURSOR

SET @CDATE=(SELECT LEFT(MAX(EFFDATE),11) FROM MSAJAG.DBO.COLLATERALDETAILS WITH (NOLOCK)
			where Effdate <= @ENDDT + ' 23:59')
			

INSERT INTO #QUARTERLYLEDGER
SELECT
 	CQL_EXCHANGE = EXCHANGE,
 	CQL_SEGMENT = SEGMENT,
	CQL_PARTYCODE = PARTY_CODE,
	CQL_LED_BALANCE = 0,
	CQL_UNSETTLED_TRADE = 0,
	CQL_UNCLEARED_CHEQUS = 0,
	CQL_CASH_COLL = SUM(CASE WHEN CASH_NCASH = 'C' THEN FINALAMOUNT ELSE 0 END),
	CQL_NONCASH_COLL = SUM(CASE WHEN CASH_NCASH = 'N' THEN FINALAMOUNT ELSE 0 END),
	CQL_MARGIN_REQ = 0,
	CQL_MARGIN_SHORT = 0,
	CQL_DEBIT_STOCK = 0,
	MDATE = @ENDDT,
	CDATE = @ENDDT,
	CQL_ORDERBY = (CASE WHEN SEGMENT = 'CAPITAL' THEN 1 ELSE 2 END)
FROM
	MSAJAG.DBO.COLLATERALDETAILS WITH (NOLOCK)
WHERE
	EFFDATE BETWEEN @CDATE AND @CDATE + ' 23:59'
	AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
GROUP BY
 	EXCHANGE,
 	SEGMENT,
	PARTY_CODE


--select * from #QUARTERLYLEDGER
--return


	
SELECT 
 	CQL_EXCHANGE,
 	CQL_SEGMENT,
	CQL_PARTYCODE,
	CQL_LED_BALANCE = SUM(CQL_LED_BALANCE),
	CQL_UNSETTLED_TRADE = SUM(CQL_UNSETTLED_TRADE),
	CQL_UNCLEARED_CHEQUS = SUM(CQL_UNCLEARED_CHEQUS),
	CQL_CASH_COLL = SUM(CQL_CASH_COLL),
	CQL_NONCASH_COLL = SUM(CQL_NONCASH_COLL),
	CQL_MARGIN_REQ = SUM(CQL_MARGIN_REQ),
	CQL_MARGIN_SHORT = SUM(CQL_CASH_COLL+CQL_NONCASH_COLL)-SUM(CQL_MARGIN_REQ),
	MDATE=CONVERT(VARCHAR,CONVERT(DATETIME,@MDATE,111),103),
	CDATE=CONVERT(VARCHAR,CONVERT(DATETIME,@CDATE,111),103),
	CQL_DEBIT_STOCK = 0
FROM #QUARTERLYLEDGER
GROUP BY
 	CQL_EXCHANGE,
 	CQL_SEGMENT,
	CQL_PARTYCODE
HAVING
	(SUM(CQL_LED_BALANCE)+SUM(CQL_UNSETTLED_TRADE)+SUM(CQL_UNCLEARED_CHEQUS)+SUM(CQL_CASH_COLL)+SUM(CQL_NONCASH_COLL)+SUM(CQL_MARGIN_REQ))<> 0
	
	
DROP TABLE #QUARTERLYLEDGER

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
-- PROCEDURE dbo.GET_EXCHANGE_SEGMENT_BKUP_13Nov2019
-- --------------------------------------------------


CREATE PROC [dbo].[GET_EXCHANGE_SEGMENT_BKUP_13Nov2019]  
AS  
SELECT EXCHANGE, SEGMENT, EXCHANGE + ' ' + SEGMENT FROM PRADNYA..MULTICOMPANY WHERE PRIMARYSERVER = 1 ORDER BY 3

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NseAccValan
-- --------------------------------------------------
CREATE Proc [dbo].[NseAccValan] (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As         
        
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
-- PROCEDURE dbo.POP_CONTRACTDATA
-- --------------------------------------------------
CREATE PROC [dbo].[POP_CONTRACTDATA](      
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
-- PROCEDURE dbo.PR_GET_STATUS_ALL
-- --------------------------------------------------
CREATE proc [dbo].[PR_GET_STATUS_ALL]
(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@INTMODE INT = 0
)
AS



DECLARE @SEGMENTCUR 	CURSOR
DECLARE @SHARESERVER 	VARCHAR(20)
DECLARE @SHAREDB 	VARCHAR(20)
DECLARE @EXCHANGE 	VARCHAR(3)
DECLARE @SEGMENT  	VARCHAR(7)
DECLARE @STRSQL		VARCHAR(1000)

SET @SEGMENTCUR = CURSOR FOR SELECT * FROM V2_SEGMENTS WHERE SHAREDB NOT IN ('NSESLBS','BSESLBS')
OPEN @SEGMENTCUR
FETCH NEXT FROM @SEGMENTCUR INTO @SHARESERVER,@SHAREDB,@EXCHANGE,@SEGMENT

WHILE @@FETCH_STATUS =0
BEGIN
	SET @STRSQL = 'EXEC ' + @SHARESERVER +'.' + @SHAREDB 
	IF @INTMODE = 0 
	BEGIN
		SET @STRSQL = @STRSQL + '.DBO.PR_GET_STATUS ''' 
	END
	ELSE
	BEGIN	
 		SET @STRSQL = @STRSQL + '.DBO.PR_GET_STATUS_DATA ''' 
	END
	SET @STRSQL = @STRSQL + @DATEFROM + ''','''+ @DATETO + ''',''' + @EXCHANGE + ''','''+  @SEGMENT + ''''

	EXEC (@STRSQL)

FETCH NEXT FROM @SEGMENTCUR INTO @SHARESERVER,@SHAREDB,@EXCHANGE,@SEGMENT
END
CLOSE @SEGMENTCUR
DEALLOCATE @SEGMENTCUR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RETENTIONANEXUREAB
-- --------------------------------------------------
CREATE PROC [dbo].[RETENTIONANEXUREAB]    
(    
          @FROMPARTY_CODE VARCHAR(10)               
) 

--EXEC     [RETENTIONANEXUREAB] 'KLNS516'           
    
AS                
      
BEGIN  
 SELECT  
 PARTYCODE =A.PARTY_CODE,    
 --PARTYNAME,    
 --BRANCHCODE,    
 TOT_LEDBAL=-UNENCUMBERED_BAL,    
 TOT_MLEDBAL = UNENCUMBERED_MARGIN,    
 SECVAL_TDAY = VALUE_SECURITIESTDAY,    
 TOT_DLEDBAL =FUNDS_RETAINED,   
 VALUE_SECURITIESRETAINED,  
 
-- A.OTHERSEGMENTDEBIT,
 
 B.UNENCUMBERED_DEBITBAL , 
   
 NSE_FUNDSPAYIN_TDAY=TDAY_FUNDSPAYIN_NSECM,    
 BSE_FUNDSPAYIN_TDAY=TDAY_FUNDSPAYIN_BSECM,    
 NFO_FUNDSPAYIN_TDAY=TDAY_FUNDSPAYIN_NSEFO,    
 BFO_FUNDSPAYIN_TDAY=0,    
 NSX_FUNDSPAYIN_TDAY=TDAY_FUNDSPAYIN_NSX,    
 MCD_FUNDSPAYIN_TDAY=TDAY_FUNDSPAYIN_MCD,    
 NSE_FUNDSPAYIN_TM1DAY=T_1DAY_FUNDSPAYIN_NSECM ,    
 BSE_FUNDSPAYIN_TM1DAY=T_1DAY_FUNDSPAYIN_BSECM ,    
 NSE_SECPAYIN_TDAY=TDAY_SECURITIESPAYIN_NSECM,    
 BSE_SECPAYIN_TDAY=TDAY_SECURITIESPAYIN_BSECM,    
 NSE_SECPAYIN_TM1DAY=T_1DAY_SECURITESPAYIN_NSECM,    
 BSE_SECPAYIN_TM1DAY=T_1DAY_SECURITESPAYIN_BSECM, 
 NFO_MARGINREQ_175P = TDAY_MARGIN_NSEFO,    
 BFO_MARGINREQ_175P = 0,    
 NSX_MARGINREQ_175P = TDAY_MARGIN_NSX,    
 MCD_MARGINREQ_175P = TDAY_MARGIN_MCD,    
   
 NSE_TURNOVER_TDAY=TDAY_TURNOVER_NSECM,    
 BSE_TURNOVER_TDAY=TDAY_TURNOVER_BSECM,    
   
 TOT_FUNDSREC = A.FUNDS_RETAINED,  
 TOT_SECREL = A.SECURITIES_RELEASED,  
   
 FUNDSRELDT = CONVERT(VARCHAR(11), B.UPDATEDON),    
 TOT_FUNDSREL =A.FUNDS_RELEASED,
 B.OTHERSEGMENTDEBIT,ACCRUALAMT
   
 FROM  SCCSANNEXURE_A A(NOLOCK),SCCSANNEXURE_B B (NOLOCK)  
 WHERE A.PARTY_CODE=B.PARTY_CODE AND A.PARTY_CODE= @FROMPARTY_CODE  
   
 END   
   
--SELECT TOP 10 * FROM  SCCSANNEXURE_A WHERE PARTY_CODE ='A063'  
  
--SELECT TOP 10 * FROM  SCCSANNEXURE_BWHERE PARTY_CODE ='A063'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RETENTIONANEXURECD
-- --------------------------------------------------
CREATE PROC [dbo].[RETENTIONANEXURECD]  
(  
          @FROMPARTY_CODE VARCHAR(10)             
)  
--EXEC  RETENTIONANEXURECD 'A063'           
  
AS              
    
BEGIN
 SELECT 
 PARTY_CODE,
 EXCHANGE=SEGMENT, 	
 SCRIP_CD=SCRIP_NAME, 	
 ISIN, 
 SEC_RET=convert(int,QUANTITY), 	
 SEC_REL=0, 	
 CL_RATE=CLOSING_RATE, 	
 HAIRCUT, 	
 SEC_RETVALUE=VALUE, 
 SEC_RELVALUE=0,
 NET_SEC_RETVALUE = VALUE, 	
 NET_SEC_RELVALUE= 0
 FROM SCCSANNEXURE_C 
 WHERE PARTY_CODE= @FROMPARTY_CODE
 
 UNION ALL
 
 SELECT 
 PARTY_CODE,
 EXCHANGE=SEGMENT, 	
 SCRIP_CD=SCRIP_NAME, 	
 ISIN, 
 SEC_RET=0, 	
 SEC_REL=convert(int,QUANTITY), 	
 CL_RATE=CLOSING_RATE, 	
 HAIRCUT, 	
 SEC_RETVALUE=0, 
 SEC_RELVALUE=VALUE,
 NET_SEC_RETVALUE = 0, 	
 NET_SEC_RELVALUE= VALUE
 FROM SCCSANNEXURE_D
 WHERE PARTY_CODE= @FROMPARTY_CODE
 
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RETENTIONANEXUREEF
-- --------------------------------------------------

CREATE PROC [dbo].[RETENTIONANEXUREEF]  
(  
          @FROMPARTY_CODE VARCHAR(10) ,
          @FROMCOLLTYPE VARCHAR(10)                         
)  
--EXEC  RETENTIONANEXUREEF 'D745','FD'           
AS              

BEGIN
SELECT PARTY_CODE=PARTY_CODE,SEGMENT,BANK_NAME=BANK_CODE,BG_NO=FD_BGNO,BG_AMOUNT=FINALAMOUNT,
MATURITY_DATE=CONVERT(VARCHAR,MATURITY_DATE,103)
FROM SCCSANNEXURE_E WITH (NOLOCK)  WHERE PARTY_CODE=@FROMPARTY_CODE AND COll_TYPE= @FROMCOLLTYPE

END 

--

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_STATUS_REPORT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RPT_STATUS_REPORT] (@DATEFROM VARCHAR(10), @DATETO VARCHAR(10)) AS

IF (@DATEFROM <> @DATETO)
BEGIN

	DECLARE @DATEFROM_NEW VARCHAR(11),
		@DATETO_NEW  VARCHAR(11)

	SET @DATEFROM_NEW = LEFT(CONVERT(DATETIME,@DATEFROM,103),11)
	SET @DATETO_NEW = LEFT(CONVERT(DATETIME,@DATETO,103),11)
	
	EXEC PR_GET_STATUS_ALL @DATEFROM_NEW,@DATETO_NEW

END
ELSE
BEGIN

	DECLARE 
		@SPLITVAL VARCHAR(100),
		@COMPANYNAME  VARCHAR(100),
		@EXCHANGE  VARCHAR(3),
		@SEGMENT  VARCHAR(7),
		@INTREC INT
	DECLARE @REPORT_PERIOD VARCHAR(22)
	
	SET @REPORT_PERIOD = @DATEFROM +'-'+ @DATETO
	SELECT TOP 1 @COMPANYNAME=COMPANYNAME FROM MULTICOMPANY (NOLOCK)
	SET @INTREC = 0
	
	DECLARE @SR_SEGMENT VARCHAR(12)
	DECLARE @SEGMENTS  CURSOR

	SET @SEGMENTS = CURSOR FOR SELECT 
			DISTINCT SR_SEGMENT
		FROM
			STATUS_REPORT (NOLOCK) 
		WHERE 
			SR_RPT_PERIOD = @REPORT_PERIOD 

	
	OPEN  @SEGMENTS	         
	      
	FETCH NEXT FROM @SEGMENTS INTO @SR_SEGMENT
	WHILE @@FETCH_STATUS = 0       
	BEGIN  
			SET @SPLITVAL = ''
			SELECT 
				@SPLITVAL=SR_VALUE, 
				@EXCHANGE = LEFT(SR_SEGMENT,3) , 
				@SEGMENT =SUBSTRING(SR_SEGMENT,5,LEN(SR_SEGMENT)-3) 
			FROM
				STATUS_REPORT (NOLOCK) 
			WHERE 
				SR_RPT_PERIOD = @REPORT_PERIOD 
				AND SR_SEGMENT = @SR_SEGMENT
				AND SR_TYPE= 1
		
				IF @SPLITVAL <> '' 
				BEGIN	
					SET @INTREC = 1					
					SELECT 
						COMPANYNAME = @COMPANYNAME,
						EXCHANGE = @EXCHANGE,
						SEGMENT = @SEGMENT,
						REC_DESCRIPTION = 
							CASE 
								WHEN SNO= 1 THEN 'LAST TRADE DATE'
								WHEN SNO= 2 THEN 'LAST INST TRADE DATE'
								WHEN SNO= 3 THEN 'TOTAL NUMBER OF RETAIL TRADES'
								WHEN SNO= 4 THEN 'TOTAL NUMBER OF RETAIL CONTRACTS'
								WHEN SNO= 5 THEN 'TOTAL RETAIL TURNOVER'
								WHEN SNO= 6 THEN 'TOTAL NUMBER OF INST TRADES'
								WHEN SNO= 7 THEN 'TOTAL NUMBER OF INST CONTRACTS'
								WHEN SNO= 8 THEN 'TOTAL INST TURNOVER'
								WHEN SNO= 9 THEN 'NUMBER OF TRADING DAYS'
								WHEN SNO= 10 THEN 'AVRG RETAIL CONTRACTS PER DAY'
								WHEN SNO= 11 THEN 'AVRG RETAIL TURNOVER PER DAY'
								WHEN SNO= 12 THEN 'AVRG INST CONTRACTS PER DAY'
								WHEN SNO= 13 THEN 'AVRG INST TURNOVER PER DAY'
							END,
						REC_VALUE = SPLITTED_VALUE
					FROM
					(
					SELECT SNO,SPLITTED_VALUE FROM FUN_SPLITSTRING(@SPLITVAL,'|')
					) STAT_DATA
				
				END	
					
			SET @SPLITVAL = ''			
			SELECT 
				@SPLITVAL=SR_VALUE, 
				@EXCHANGE = LEFT(SR_SEGMENT,3) , 
				@SEGMENT =SUBSTRING(SR_SEGMENT,5,LEN(SR_SEGMENT)-3) 
			FROM
				STATUS_REPORT (NOLOCK) 
			WHERE 
				SR_RPT_PERIOD = @REPORT_PERIOD 
				AND SR_SEGMENT = @SR_SEGMENT
				AND SR_TYPE= 2
			
			IF @SPLITVAL <> '' 
				BEGIN	
					SET @INTREC = 1	
					SELECT	
						@COMPANYNAME,@EXCHANGE,@SEGMENT,
						ENT_TYPE = 
							CASE 
								WHEN SNO= 1 THEN 'BROKER'
								WHEN SNO= 2 THEN 'BRANCH'
								WHEN SNO= 3 THEN 'SUBBROKER'
								WHEN SNO= 4 THEN 'TRADER'
								WHEN SNO= 5 THEN 'CLIENT'
								WHEN SNO= 6 THEN 'FAMILY'
								WHEN SNO= 7 THEN 'AREA'
								WHEN SNO= 8 THEN 'REGION'
								WHEN SNO= 9 THEN 'CLTYPE'
								WHEN SNO= 10 THEN 'GROUP'
								WHEN SNO= 11 THEN 'RELMGR'
								WHEN SNO= 12 THEN 'SBU'
								WHEN SNO= 13 THEN 'CLSTATUS'
							END,
						REC_VALUE = REPLACE(SPLITTED_VALUE,'-',',')
					FROM
					(
					SELECT SNO,SPLITTED_VALUE FROM FUN_SPLITSTRING(@SPLITVAL,'|')
					) STAT_DATA
				END
	
	    
	 FETCH NEXT FROM @SEGMENTS INTO @SR_SEGMENT
	END      
	CLOSE @SEGMENTS      
	DEALLOCATE @SEGMENTS
	IF @INTREC = 0
	BEGIN
		SELECT 1 FROM MULTICOMPANY (NOLOCK) WHERE 1 = 2
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP
-- --------------------------------------------------
  
CREATE PROC SP @spName VARCHAR(25)AS               
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

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
create PROC [dbo].[sp_generate_inserts]   
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
@Actual_Values varchar(8000), --This is the string that will be finally executed to generate INSERT statements   
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
  
--------------------------------use to generate script  
--sp_generate_inserts 'v2_contract_digital_data'  
  
   
  
----------------------------

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
 @NARRATION VARCHAR(500)  -- this parameter is using as vno     
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
 SET @@SQL = @@SQL + " SELECT BILLDATE = CONVERT(VARCHAR(11), BILLDATE, 109),BP.SETT_NO,BP.SETT_TYPE,PATH = REPORTURL FROM " + @ACCDB +" .DBO.BILLPOSTED BP, ACCOUNT.DBO.PLDETAIL PL "      
 SET @@SQL = @@SQL + " WHERE "      
 SET @@SQL = @@SQL + " PL.EXCHANGE = '" + @EXCHANGE + "' "      
 SET @@SQL = @@SQL + " AND PL.SEGMENT = '" + @SEGMENT + "' "      
 SET @@SQL = @@SQL + " AND BP.VTYP = PL.VTYPE "      
IF @SEGMENT <> 'FUTURES'   
 BEGIN  
  SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE "    
 END  
 SET @@SQL = @@SQL + "  AND BP.vno = '" + @NARRATION + "' "    
 SET @@SQL = @@SQL + " AND BP.SETT_TYPE = PL.SETTTYPE AND FLAG = 'Y'"      
    
    
 PRINT @@SQL      
 EXEC(@@SQL)      
 END      
DROP TABLE #CHK

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_GET_BILL_DETAILS_14012014
-- --------------------------------------------------

create PROC [dbo].[SP_GET_BILL_DETAILS_14012014]
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
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------
  

  
CREATE PROC Tbl @TblName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ukproc
-- --------------------------------------------------
create proc [dbo].[ukproc] as
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
CREATE PROC [dbo].[V2_CLASS_CHECKPATH]  
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
create PROC [dbo].[V2_PROC_MONTHLYLEDGER]                      
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
SELECT CL_CODE FROM MSAJAG.DBO.CLIENT_BROK_DETAILS        
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


create PROC [dbo].[V2_PROC_MONTHLYLEDGER_POP]   

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
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_NEW
-- --------------------------------------------------

  
CREATE PROC [dbo].[V2_PROC_QUARTERLYLEDGER_NEW]              
(              
 @STARTDT VARCHAR(11),              
 @ENDDT VARCHAR(11),              
 @FROMPARTY VARCHAR(10),              
 @TOPARTY VARCHAR(10),  
 @FROMBRANCH VARCHAR(15) = '',  
 @TOBRANCH VARCHAR(15) = 'ZZZZZZZZZZ',  
 @FROMSUBBROKER VARCHAR(15) = '',  
 @TOSUBBROKER VARCHAR(15) = 'ZZZZZZZZZZ',  
 @RPT_FILTER INT = 0  
)              
              
/*              
EXEC V2_PROC_QUARTERLYLEDGER 'JUN  1 2008' , 'AUG 31 2008', '0000000000', 'ZZZZZZZZZZ'              
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
  
IF (@TOBRANCH = '')  
BEGIN  
 SET @TOBRANCH  = 'ZZZZZZZZZZ'  
END  
  
IF (@TOSUBBROKER = '')  
BEGIN  
 SET @TOSUBBROKER = 'ZZZZZZZZZZ'  
END  
  
CREATE TABLE #CLIENTMASTER  
 (  
 PARTY_CODE VARCHAR(15),  
 PARTYNAME VARCHAR(100),  
 PARENTCODE VARCHAR(15),  
 BRANCH_CD VARCHAR(15),  
 SUB_BROKER VARCHAR(15)  
 )  
  
IF (@RPT_FILTER = 0)  
BEGIN  
 INSERT INTO #CLIENTMASTER  
 SELECT  
  DISTINCT  
  PARTY_CODE = CL_CODE,  
  PARTYNAME='',  
  PARENTCODE,  
  BRANCH_CD,  
  SUB_BROKER  
 FROM  
  MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK)  
 WHERE  
  PARENTCODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH  
  AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER  
END  
ELSE  
BEGIN  
 INSERT INTO #CLIENTMASTER  
 SELECT  
  DISTINCT  
  PARTY_CODE = C.CL_CODE,  
  PARTYNAME='',  
  PARENTCODE,  
  BRANCH_CD,  
  SUB_BROKER  
 FROM  
  PRADNYA.DBO.TBLCLIENT_GROUP T WITH (NOLOCK),  
  MSAJAG.DBO.CLIENT_DETAILS C WITH (NOLOCK)  
 WHERE  
  T.PARTY_CODE = C.PARTY_CODE  
  AND PARENTCODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH  
  AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER  
END  
  
UPDATE #CLIENTMASTER SET PARTYNAME = ISNULL(SHORT_NAME,'') FROM MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK)  
WHERE #CLIENTMASTER.PARENTCODE = CLIENT_DETAILS.PARENTCODE  
              
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNT.DBO.PARAMETER         
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
   CQL_SEGMENT = 'NSECM',               
   CQL_PARTYCODE = C.PARENTCODE, ---L.CLTCODE,              
   CQL_VDT = '',              
   CQL_VTYPE = '',              
   CQL_VNO = '',              
   CQL_ACCODE = '',              
   CQL_REMARKS = 'OPENING BALANCE',              
   CQL_DDNO = '',              
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),              
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),              
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),              
   CQL_ORDERBY = 1,              
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ACCOUNT.DBO.LEDGER L WITH (NOLOCK)               
   INNER JOIN              
   ACCOUNT.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))  
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
              
              
              
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNT.DBO.PARAMETER               
WHERE              
 @STARTDT BETWEEN SDTCUR AND LDTCUR              
              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
INSERT INTO V2_CLASS_QUARTERLYLEDGER              
SELECT               
 CQL_SEGMENT = 'NSECM',               
 CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),              
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),              
 CQL_VNO = L.VNO,              
 CQL_ACCODE = '',              
 CQL_REMARKS = L.NARRATION,              
 CQL_DDNO = '',              
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),              
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),              
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),              
 CQL_ORDERBY = 2,              
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),              
 CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
FROM              
 ACCOUNT.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ACCOUNT.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ACCOUNT.DBO.VMAST V ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
              
              
/* NOW DOING BSECM */              
              
              
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNT_AB.DBO.PARAMETER             
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
   CQL_SEGMENT = 'BSECM',               
   CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,      
   CQL_VDT = '',              
   CQL_VTYPE = '',              
   CQL_VNO = '',              
   CQL_ACCODE = '',              
   CQL_REMARKS = 'OPENING BALANCE',              
   CQL_DDNO = '',              
   CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),              
   CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),              
   CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),              
   CQL_ORDERBY = 3,              
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK)               
   INNER JOIN              
   ACCOUNT_AB.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_SEGMENT = 'BSECM',               
 CQL_PARTYCODE = C.PARENTCODE, ---L.CLTCODE,              
 CQL_VDT = CONVERT(VARCHAR,L.VDT,103),              
 CQL_VTYPE = ISNULL(V.SHORTDESC,'NA'),              
 CQL_VNO = L.VNO,              
 CQL_ACCODE = '',              
 CQL_REMARKS = L.NARRATION,              
 CQL_DDNO = '',              
 CQL_DEBIT = (CASE WHEN DRCR = 'D' THEN VAMT ELSE 0 END),              
 CQL_CREDIT = (CASE WHEN DRCR = 'C' THEN VAMT ELSE 0 END),              
 CQL_BALANCE = (CASE WHEN DRCR = 'D' THEN -VAMT ELSE VAMT END),              
 CQL_ORDERBY = 4,              
 CAST(CONVERT(VARCHAR,L.VDT,112) AS INT),              
 CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
FROM              
 ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ACCOUNT_AB.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ACCOUNT_AB.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
              
/* NOW DOING NSEFO */              
              
              
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNTFO.DBO.PARAMETER             
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
   CQL_SEGMENT = 'NSEFO',               
   CQL_PARTYCODE = C.PARENTCODE, ---L.CLTCODE,              
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
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK)  
   INNER JOIN              
   ACCOUNTFO.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_SEGMENT = 'NSEFO',               
 CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,  
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
 CQL_ACNAME  = C.PARTYNAME  ---A.ACNAME  
FROM              
 ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK)  
 INNER JOIN              
 ACCOUNTFO.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ACCOUNTFO.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
              
/*===========================================================================================================             
--------------------------------------------------------------------------------------------------------------------    
-- NCDX    
    
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ANGELCOMMODITY.ACCOUNTNCDX.DBO.PARAMETER             
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
   CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK)  
   INNER JOIN              
   ANGELCOMMODITY.ACCOUNTNCDX.DBO.ACMAST A  WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_PARTYCODE = C.PARENTCODE,  --- L.CLTCODE,              
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
 CQL_ACNAME  = C.PARTYNAME  ---A.ACNAME              
FROM              
 ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ANGELCOMMODITY.ACCOUNTNCDX.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ANGELCOMMODITY.ACCOUNTNCDX.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)  
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
              
---------------------------------------------------------------------------------------------------------------    
-- MCDX    
    
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ANGELCOMMODITY.ACCOUNTMCDX.DBO.PARAMETER             
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
   CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
   CQL_ACNAME = C.PARTYNAME   ---A.ACNAME              
  FROM              
   ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK)  
   INNER JOIN              
   ANGELCOMMODITY.ACCOUNTMCDX.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
 CQL_ACNAME  = C.PARTYNAME  ---A.ACNAME              
FROM              
 ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ANGELCOMMODITY.ACCOUNTMCDX.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ANGELCOMMODITY.ACCOUNTMCDX.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
     */         
---------------------------------------------------------------------------------------------------------------    
-- MCDXCDS    
    
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNTMCDXCDS.DBO.PARAMETER             
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
   CQL_SEGMENT = 'MCDXCDS',               
   CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK)               
   INNER JOIN              
   ACCOUNTMCDXCDS.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_SEGMENT = 'MCDXCDS',               
 CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
 CQL_ACNAME  = C.PARTYNAME  ---A.ACNAME              
FROM              
 ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ACCOUNTMCDXCDS.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ACCOUNTMCDXCDS.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY      
    
    
--------------------------------------------------------------------------------------------------------------    
-- NSECURFO    
    
SELECT               
 @@SDTCUR = SDTCUR               
FROM               
 ACCOUNTCURFO.DBO.PARAMETER             
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
   CQL_SEGMENT = 'NSECURFO',               
   CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
   CQL_ACNAME = C.PARTYNAME  ---A.ACNAME              
  FROM              
   ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK)               
   INNER JOIN              
   ACCOUNTCURFO.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
   INNER JOIN  
   #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
  WHERE               
   L.VDT >= @@SDTCUR              
   AND L.VDT < @STARTDT              
   AND C.PARENTCODE >= @FROMPARTY              
   AND C.PARENTCODE <= @TOPARTY              
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
 CQL_SEGMENT = 'NSECURFO',               
 CQL_PARTYCODE = C.PARENTCODE,  ---L.CLTCODE,              
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
 CQL_ACNAME  = C.PARTYNAME  ---A.ACNAME              
FROM              
 ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK)               
 INNER JOIN              
 ACCOUNTCURFO.DBO.ACMAST A WITH (NOLOCK) ON (A.CLTCODE = L.CLTCODE AND A.ACCAT IN ('4','104','204'))              
 LEFT OUTER JOIN               
 ACCOUNTCURFO.DBO.VMAST V WITH (NOLOCK) ON (V.VTYPE = L.VTYP)              
 INNER JOIN  
 #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = A.CLTCODE)  
WHERE               
 L.VDT >=  @STARTDT              
 AND L.VDT <= @ENDDT + ' 23:59:59'              
 AND C.PARENTCODE >= @FROMPARTY              
 AND C.PARENTCODE <= @TOPARTY              
    
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

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYLEDGER_POP
-- --------------------------------------------------


  
CREATE PROC [dbo].[V2_PROC_QUARTERLYLEDGER_POP]       
(                
               @FROMDATE   VARCHAR(11),                
               @TODATE     VARCHAR(11),                
               @FROMPARTY  VARCHAR(10),                
               @TOPARTY    VARCHAR(10),                
               @FROMSCRIP  VARCHAR(12),                
               @TOSCRIP    VARCHAR(12)                
)         
AS      
  
--- EXEC V2_PROC_QUARTERLYLEDGER_POP 'OCT 23 2012','JAN 14 2013','A0000','ZZZZZ','00000000','ZZZZZZZZZ'  
  
--- BY DHARMESH ON 14 01 2013  
--- LEDGER DATA FETCH IN V2_CLASS_QUARTERLYLEDGER ON BSE SERVER (ANAND - 201)  
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYLEDGER_NEW @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY  
  
  
--- LEDGER DATA FETCH IN V2_CLASS_QUARTERLYSECLEDGER ON DEMAT SERVER (ANGELDEAMT - 197) AND COPY TO BSE (ANAND) SERVER   
EXEC PRADNYA.DBO.V2_PROC_QUARTERLYSHARELEDGER_NEW @FROMDATE,@TODATE,@FROMPARTY,@TOPARTY,@FROMSCRIP,@TOSCRIP,'BROKER','BROKER'  
  
  
---   
  
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE CQL_VTYPE LIKE 'OPEN%'  
  
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE CQL_SEGMENT IN ('MCDX','NCDX')  
  
--- SECURITIES DATA COPY FROM DEMAT SERVER   
  
TRUNCATE TABLE V2_CLASS_QUARTERLYSECLEDGER  
  
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER  
SELECT * FROM PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER   
   
--- FUNDS AND SECURITIES RELEASED CLIENT LIST  
  
SELECT DISTINCT PARTY_CODE   
 INTO #PARTY  
FROM PRADNYA.DBO.TBL_SCCSCLIENT (NOLOCK)  
WHERE INACTIVE_DATE > GETDATE () AND LEFT(SCCS_DATE,11) = (  
SELECT DISTINCT LEFT(MAX(SCCS_DATE),11) FROM TBL_SCCSCLIENT WHERE SCCS_DATE < @TODATE )   
   
--- FUNDS & SECURITIES PAYOUT CLIENTS  
  
SELECT DISTINCT PARTY_CODE   
 INTO #PO   
FROM PRADNYA.DBO.TBL_SCCSCLIENT (NOLOCK)   
WHERE FLAG = 'Y' AND LEFT(SCCS_DATE,11) = (  
SELECT DISTINCT LEFT(MAX(SCCS_DATE),11) FROM TBL_SCCSCLIENT WHERE SCCS_DATE < @TODATE )  
  
   
--- BILLS   
  
SELECT DISTINCT CQL_PARTYCODE AS PARTY_CODE   
 INTO #BILL  
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)   
WHERE CQL_VTYPE = 'BILL'   
AND CQL_SEGMENT IN ('BSECM','NSECM','NSEFO','MCDXCDS','NSECURFO')  
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )  
  
--- HOLDING   
  
SELECT DISTINCT PARTY_CODE AS PARTY_CODE   
 INTO #HOLD  
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER C (NOLOCK)  
WHERE 1 = 1  
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE #PARTY.PARTY_CODE = C.PARTY_CODE )  
  
--- RS 1000.00 DR/CR --  
  
SELECT CQL_PARTYCODE,SUM(CQL_BALANCE) AS BAL   
 INTO #DRCR  
FROM PRADNYA.DBO.V2_CLASS_QUARTERLYLEDGER (NOLOCK)   
WHERE CQL_SEGMENT IN ('BSECM','NSECM','NSEFO','MCDXCDS','NSECURFO')  
AND EXISTS (SELECT PARTY_CODE FROM #PARTY WHERE PARTY_CODE = CQL_PARTYCODE )  
GROUP BY CQL_PARTYCODE  
HAVING SUM(CQL_BALANCE) < -1000 OR SUM(CQL_BALANCE) >1000  
ORDER BY CQL_PARTYCODE   
  
---   
  
SELECT *   
 INTO #CL   
FROM  
 (  
 SELECT * FROM #PO   
 UNION  
 SELECT * FROM #BILL  
 UNION  
 SELECT CQL_PARTYCODE FROM #DRCR  
 UNION  
 SELECT * FROM #HOLD  
 ) X  
  
--- SCCS DATA DUMP INTO TEMP TABLE  
  
SELECT * INTO #SCCS FROM VW_SCCS_DATA (NOLOCK)  
  
TRUNCATE TABLE TBL_SCCS_DATA_TEMP  
  
INSERT INTO TBL_SCCS_DATA_TEMP  
SELECT * FROM #SCCS (NOLOCK)   
WHERE SCCS_DATE > @FROMDATE AND SCCS_DATE < @TODATE   
AND PARTY_CODE IN  
(SELECT * FROM #CL)   
  
----   
  
DELETE FROM V2_CLASS_QUARTERLYSECLEDGER WHERE   
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = V2_CLASS_QUARTERLYSECLEDGER.PARTY_CODE )  
  
DELETE FROM V2_CLASS_QUARTERLYLEDGER WHERE   
NOT EXISTS (SELECT PARTY_CODE FROM #CL WHERE #CL.PARTY_CODE = CQL_PARTYCODE )  
  
DROP TABLE #CL   
DROP TABLE #PO   
DROP TABLE #BILL  
DROP TABLE #DRCR  
DROP TABLE #HOLD  
DROP TABLE #PARTY  
DROP TABLE #SCCS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYSHARELEDGER_new
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[V2_PROC_QUARTERLYSHARELEDGER_new]                
(                
@FROMDATE   VARCHAR(11),  
@TODATE     VARCHAR(11),  
@FROMPARTY  VARCHAR(10),  
@TOPARTY    VARCHAR(10),  
@FROMSCRIP  VARCHAR(12),  
@TOSCRIP    VARCHAR(12),  
@STATUSID   VARCHAR(50),  
@STATUSNAME VARCHAR(50),  
@FROMBRANCH VARCHAR(15) = '',  
@TOBRANCH VARCHAR(15) = 'zzzzzzzzzz',  
@FROMSUBBROKER VARCHAR(15) = '',  
@TOSUBBROKER VARCHAR(15) = 'zzzzzzzzzz',  
@RPT_FILTER INT = 0  
)                
  
AS  
            
/*          
SELECT COUNT(1) FROM MSAJAG.DBO.DELTRANS            
EXEC V2_PROC_QUARTERLYSHARELEDGER  'JUL  1 1900', 'JUN 15 2009', '0a146', '0a146', '0000000000', 'ZZZZZZZZZZ', 'BROKER', 'BROKER'                      
*/      
                
DECLARE  @@LOOPDPID VARCHAR(10)                
              
DECLARE  @@LOOPCLTDPID VARCHAR(16)                
              
DECLARE  @NEWFROMDATE VARCHAR(11)                
                                    
SET @@LOOPDPID = 'AAAA'                
              
SET @@LOOPCLTDPID = 'AAAA'                
                                  
SELECT @NEWFROMDATE = 'APR  1 1950'                        
      
TRUNCATE TABLE V2_CLASS_QUARTERLYSECLEDGER      
      
EXEC BSEDB.DBO.RPT_HOLDCHECK_FINAL @FROMDATE, @TODATE, '', @FROMPARTY, @TOPARTY      
      
EXEC MSAJAGDEMAT.DBO.RPT_HOLDCHECK_FINAL @FROMDATE, @TODATE, '', @FROMPARTY, @TOPARTY          
      
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER      
SELECT * FROM BSEDB.DBO.V2_DELHOLDFINAL      
      
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER      
SELECT * FROM MSAJAGDEMAT.DBO.V2_DELHOLDFINAL      
      
/*                                        
                
      CREATE TABLE #TABLEREPORT (                
  SEGMENT VARCHAR(5),                
        TRANSDATE   VARCHAR(10),                
        SETT_NO     VARCHAR(10),                
        SETT_TYPE   VARCHAR(5),                
        PARTY_CODE  VARCHAR(10),                
        SCRIP_CD    VARCHAR(20),                
        SCRIP_NAME  VARCHAR(255),                
        CERTNO      VARCHAR(20),                
        CQTY        INT,                
        DQTY        INT,                
        SLIPNO      VARCHAR(20),                
        DPID        VARCHAR(8),                
        CLTDPID     VARCHAR(16),                
        TRTYPE      VARCHAR(6),                
        REASON      VARCHAR(255),                
        BDPID       VARCHAR(8),                
        BCLTDPID    VARCHAR(16),                
        TRANSDATEDT DATETIME,                
        FLAG        INT)                          
            
      CREATE TABLE #TABLE1 (                
        TRANSDATE   VARCHAR(10),                
        SETT_NO     VARCHAR(10),                
        SETT_TYPE   VARCHAR(5),                
        PARTY_CODE  VARCHAR(10),                
        SCRIP_CD    VARCHAR(20),                
        SCRIP_NAME  VARCHAR(255),                
        CERTNO      VARCHAR(20),                
        CQTY        INT,                
        DQTY        INT,                
        SLIPNO      VARCHAR(20),                
        DPID        VARCHAR(8),                
        CLTDPID     VARCHAR(16),                
        TRTYPE      VARCHAR(6),                
        REASON      VARCHAR(255),                
        BDPID       VARCHAR(8),                
        BCLTDPID    VARCHAR(16),                
        TRANSDATEDT DATETIME,                
        FLAG        INT)                
                
                
      CREATE TABLE #TABLE2 (                
        TRANSDATE   VARCHAR(10),                
        SETT_NO     VARCHAR(10),                
        SETT_TYPE   VARCHAR(5),                
        PARTY_CODE  VARCHAR(10),                
        SCRIP_CD    VARCHAR(20),                
        SCRIP_NAME  VARCHAR(255),                
        CERTNO      VARCHAR(20),                
        CQTY        INT,                
        DQTY        INT,                
   SLIPNO      VARCHAR(20),                
  DPID        VARCHAR(8),                
        CLTDPID     VARCHAR(16),                
        TRTYPE      VARCHAR(6),                
        REASON  VARCHAR(255),                
        BDPID       VARCHAR(8),                
        BCLTDPID    VARCHAR(16),                
        TRANSDATEDT DATETIME,                
  FLAG        INT)                
                
                
  TRUNCATE TABLE TBLDEL_TRANSSTAT_QRLY                
                
      
Set Transaction isolation level read uncommitted                                
select * into #Del_TransStat_TMP From MSAJAG.DBO.Deltrans_Report With(NoLock)                                 
Where Party_Code >= @FromParty And Party_Code <= @ToParty                                
and Scrip_CD >= @FromScrip And Scrip_CD <= @ToScrip                                
--And TransDate >= @NewFromDate and TransDate <= @ToDate            
And Filler2 = 1             
            
INSERT INTO #DEL_TRANSSTAT_TMP            
SELECT D.SNO, D.Sett_No, D.Sett_type, D.RefNo, D.TCode, TrType=904, D.Party_Code, D.scrip_cd, D.series,             
D.Qty, D.FromNo, D.ToNo, D.CertNo, D.FolioNo, HolderName = 'Ben ' + BCLTDPID, Reason = 'Ben ' + BCLTDPID, DrCr = 'D',             
Delivered = 'G', D.OrgQty, D.DpType, D.DpId, D.CltDpId, D.BranchCd, D.PartipantCode,             
D.SlipNo, D.BatchNo, ISett_No='', ISett_Type='', D.ShareType, TransDate = SEC_PAYIN, D.Filler1,            
Filler2 = 0, D.Filler3, BDpType = DP1.DPTYPE, BDpId = DP1.DPID, BCltDpId = DP1.DPCLTNO, D.Filler4, D.Filler5            
FROM #DEL_TRANSSTAT_TMP D, MSAJAG.DBO.SETT_MST S, MSAJAG.DBO.DELIVERYDP DP, MSAJAG.DBO.DELIVERYDP DP1            
WHERE D.SETT_NO = S.SETT_NO            
AND D.SETT_TYPE = S.SETT_TYPE            
AND DP.DESCRIPTION NOT LIKE '%POOL%'            
AND D.BDPID = DP.DPID            
AND D.BCLTDPID = DP.DPCLTNO            
AND FILLER1 NOT IN ('SPILT', 'BONUS', 'RIGHTS')            
AND DP1.DESCRIPTION LIKE '%POOL%'            
AND DP1.DPTYPE = (CASE WHEN FILLER1 = '0' THEN 'NSDL' ELSE 'CDSL' END)          
AND TCODE <> 0 AND FILLER1 NOT LIKE 'HOLDING TRANSFER%'      
                
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED                
  INSERT INTO   TBLDEL_TRANSSTAT_QRLY                
  SELECT D.*,''                 
  FROM   #DEL_TRANSSTAT_TMP  D             
  WHERE  D.TRANSDATE >= @NEWFROMDATE                
         AND D.TRANSDATE <= @TODATE               
      
 UPDATE TBLDEL_TRANSSTAT_QRLY      SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES      
 FROM MSAJAG.DBO.MULTIISIN M      
 WHERE M.ISIN = TBLDEL_TRANSSTAT_QRLY.CERTNO      
 AND VALID = 1       
                
 UPDATE TBLDEL_TRANSSTAT_QRLY            
 SET SCRIP_NAME = S1.LONG_NAME                
 FROM                
  MSAJAG.DBO.SCRIP1 S1 (NOLOCK),                
  MSAJAG.DBO.SCRIP2 S2 (NOLOCK)                
 WHERE                
  S1.CO_CODE = S2.CO_CODE                
  AND S2.SCRIP_CD = TBLDEL_TRANSSTAT_QRLY.SCRIP_CD                
  AND S2.SERIES = TBLDEL_TRANSSTAT_QRLY.SERIES                
                  
                 
 UPDATE TBLDEL_TRANSSTAT_QRLY                
 SET SCRIP_NAME = SCRIP_CD + ' (' + CERTNO + ')'                
 WHERE ISNULL(SCRIP_NAME,'') = ''                
                
                
  DECLARE STATEMENT_CURSOR CURSOR  FOR                
                  
                  
  SELECT DISTINCT DPID,                
                DPCLTNO                
  FROM   MSAJAG.DBO.DELIVERYDP D (NOLOCK)                
 WHERE D.DESCRIPTION NOT LIKE '%POOL%' AND D.DESCRIPTION NOT LIKE '%PRINCI%'        
   AND DPCLTNO IN (      
SELECT DISTINCT BCLTDPID      
FROM MSAJAG.DBO.DELTRANS      
WHERE FILLER2 = 1        
AND DRCR = 'D'      
AND DELIVERED = '0'      
AND TRTYPE IN (904, 905)      
AND PARTY_CODE <> 'BROKER'      
AND SHARETYPE <> 'AUCTION')      
                      
  OPEN STATEMENT_CURSOR                
                  
  FETCH NEXT FROM STATEMENT_CURSOR                
  INTO @@LOOPDPID,                
       @@LOOPCLTDPID        
                       
  WHILE @@FETCH_STATUS = 0                
    BEGIN                
  TRUNCATE TABLE  TBLDEL_TRANSSTAT1_QRLY                
  INSERT INTO     TBLDEL_TRANSSTAT1_QRLY                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO,                
                   DPID = BDPID,                
                   CLTDPID = BCLTDPID,                
                   TRTYPE,                
                   REASON = (CASE                 
                               WHEN HOLDERNAME LIKE 'MARGIN%' THEN 'TRANS TO MARGIN'                
                               ELSE 'TRANS TO BEN'                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 1                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   MSAJAG.DBO.CLIENT2 C2,                
                   MSAJAG.DBO.CLIENT1 C1                
          WHERE    DRCR = 'D'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = 'G'                
                   AND FILLER2 = 0                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND HOLDERNAME LIKE '%' + RTRIM(LTRIM(@@LOOPCLTDPID)) + '%'                
                   AND HOLDERNAME NOT LIKE 'MARGIN%'                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
          ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,              
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
          BDPID,BCLTDPID,HOLDERNAME                
                                   
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO,                
                   DPID = DPID,                
                   CLTDPID = CLTDPID,                
                   TRTYPE,                
                   REASON = (CASE        
                                               WHEN REASON = 'DEMAT' THEN 'PAY-IN'                
                           ELSE REASON                
                                             END),                
             BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 2                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   MSAJAG.DBO.CLIENT2 C2,                
                   MSAJAG.DBO.CLIENT1 C1                
          WHERE    DRCR = 'C'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   /*AND DELIVERED = '0'*/                
                   AND FILLER2 = 1                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   /*AND SETT_NO = '2000000' */                
                   AND FILLER1 NOT IN ('SPLIT','BONUS')                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
  CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,REASON                
                                   
          UNION ALL                
                          
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,        
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO = 0,                
         DPID = '',                
                   CLTDPID = '',                
                   TRTYPE,                
                   UPPER(REASON),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 3       
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   MSAJAG.DBO.CLIENT2 C2,                
                   MSAJAG.DBO.CLIENT1 C1                
          WHERE    DRCR = 'C'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = '0'                
                   AND FILLER2 = 1                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   AND FILLER1 IN ('SPLIT','BONUS')                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,REASON                
                                
          UNION ALL         
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = 0,                
                   DQTY = SUM(QTY),                
                   SLIPNO = (CASE                 
                               WHEN FILLER1 = 'SPLIT' THEN 0                
                               ELSE SLIPNO                
      END),                
                   DPID = (CASE                 
                             WHEN TRTYPE IN (1000,907,908) THEN ''                
                             WHEN FILLER1 = 'SPLIT' THEN ''                
                             WHEN FILLER1 LIKE 'CHANGE TO%' THEN ''                
                             ELSE DPID                
                           END),                
                   CLTDPID = (CASE                 
                                WHEN TRTYPE IN (1000,907,908) THEN ''                
                                WHEN FILLER1 = 'SPLIT' THEN ''                
                                WHEN FILLER1 LIKE 'CHANGE TO%' THEN ''                
                                ELSE CLTDPID                
                              END),             
                   TRTYPE,                
                   REASON = (CASE                 
                               WHEN TRTYPE IN (1000,907,908) THEN 'TRANS TO POOL - ' + ISETT_NO + '-' + ISETT_TYPE                
                               ELSE (CASE                 
                                       WHEN FILLER1 = 'SPLIT' THEN 'CORPORATE ACTION'                
                                       WHEN FILLER1 LIKE 'CHANGE TO%' THEN FILLER1                
                                       ELSE (CASE                 
                                               WHEN REASON = 'DEMAT' THEN 'PAY-OUT'                
                                               ELSE REASON                
                                             END)                
                                     END)                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 4                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
       MSAJAG.DBO.CLIENT2 C2,                
                   MSAJAG.DBO.CLIENT1 C1                
          WHERE    FILLER2 = 1                
                   AND DRCR = 'D'                
                   AND DELIVERED <> '0'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                   ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
   WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   --AND HOLDERNAME NOT LIKE 'MARGIN%'                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,FILLER1,REASON                
                                   
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
    SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = 0,                
                   DQTY = SUM(QTY),                
                   SLIPNO,                
                   DPID = DP.DPID,                
                   CLTDPID = DP.DPCLTNO,                
                   TRTYPE,                
                   REASON = (CASE                 
                               WHEN HOLDERNAME LIKE 'MARGIN%' THEN 'TRANS TO MARGIN'                
                               ELSE 'TRANS TO BEN'                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 1                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   MSAJAG.DBO.CLIENT2 C2,                
                   MSAJAG.DBO.CLIENT1 C1,                
                   MSAJAG.DBO.DELIVERYDP DP                
          WHERE    DRCR = 'D'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = 'G'                
                   AND FILLER2 = 0                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
       AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   /*AND DESCRIPTION NOT LIKE '%POOL%'*/            
                   AND (HOLDERNAME LIKE 'BEN ' + DP.DPCLTNO                
                         OR HOLDERNAME LIKE 'MARGIN ' + DP.DPCLTNO)                
                   AND C1.BRANCH_CD LIKE (CASE                 
      WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                               END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                             END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                           END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,TRTYPE,                
                   DP.DPID,DPCLTNO,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,HOLDERNAME                
                
                
          INSERT INTO #TABLE1                
          SELECT   TRANSDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDATE),103),                
               SETT_NO = '',                
                   SETT_TYPE = '',                
                   PARTY_CODE,                
                   SCRIP_CD,                
                   SCRIP_NAME,                
                   CERTNO,                
                   CQTY = (CASE                 
                             WHEN SUM(CQTY - DQTY) > 0 THEN SUM(CQTY - DQTY)                
                             ELSE 0                
                           END),                
                   DQTY = (CASE                 
                             WHEN SUM(DQTY - CQTY) > 0 THEN SUM(DQTY - CQTY)                
                             ELSE 0                
                           END),                
                   SLIPNO = '0',                
                   DPID = '',                
                   CLTDPID = '',                
                   TRTYPE = '0',                
                   REASON = 'OPENING BALANCE',                
                   BDPID = '',                
                   BCLTDPID = '',                
                   TRANSDATE1 = CONVERT(DATETIME,@FROMDATE),                
         FLAG = 0                
          FROM     TBLDEL_TRANSSTAT1_QRLY                
          WHERE    TRANSDATE1 < @FROMDATE                
          GROUP BY PARTY_CODE, SCRIP_CD,SCRIP_NAME,CERTNO                
          UNION ALL                
          SELECT *                
          FROM   TBLDEL_TRANSSTAT1_QRLY                
          WHERE  TRANSDATE1 >= @FROMDATE                
                 AND TRANSDATE1 <= @TODATE                
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@TODATE),103),                
                   SETT_NO = '',                
                   SETT_TYPE = '',                
                   PARTY_CODE,                
                   SCRIP_CD,                
                   SCRIP_NAME,                
                   CERTNO,                
                   CQTY = (CASE                 
                             WHEN SUM(CQTY - DQTY) > 0 THEN SUM(CQTY - DQTY)                
    ELSE 0                
                           END),                
                   DQTY = (CASE                 
  WHEN SUM(DQTY - CQTY) > 0 THEN SUM(DQTY - CQTY)                
                             ELSE 0                
                           END),                
                   SLIPNO = '0',                
                   DPID = '',                
                   CLTDPID = '',                
                   TRTYPE = '0',                
                   REASON = 'CLOSING BALANCE',               
                   BDPID = '',                
                   BCLTDPID = '',                
                   TRANSDATE1 = CONVERT(DATETIME,@TODATE),                
                   FLAG = 6                
          FROM     TBLDEL_TRANSSTAT1_QRLY                
          WHERE    TRANSDATE1 <= @TODATE                
          GROUP BY PARTY_CODE, SCRIP_CD,SCRIP_NAME,CERTNO                
          ORDER BY PARTY_CODE,                
                   SCRIP_CD,                
                   CERTNO,                
                   TRANSDATE1,                
             FLAG,                
                   SETT_NO,                
                   SETT_TYPE                
                            
          TRUNCATE TABLE TBLDEL_TRANSSTAT1_QRLY                
                
                
                      
      FETCH NEXT FROM STATEMENT_CURSOR                
      INTO @@LOOPDPID,                
           @@LOOPCLTDPID                
    END                
                    
  CLOSE STATEMENT_CURSOR                
                  
  DEALLOCATE STATEMENT_CURSOR                
            
 INSERT INTO #TABLEREPORT                
  SELECT   'NSECM', *                
      FROM     #TABLE1                
  WHERE  CQTY <> 0 OR DQTY <> 0                      
 ORDER BY PARTY_CODE,                
               SCRIP_CD,                
               FLAG,                
               TRANSDATEDT                
                               
      TRUNCATE TABLE #TABLE1                
      DROP TABLE #TABLE1                
*/                
      
/* NOW DOING BSECM */                
/*                
            
  TRUNCATE TABLE TBLDEL_TRANSSTAT_QRLY                
       
Set Transaction isolation level read uncommitted                                
select * into #Del_TransStat_TMP_1 From BSEDB.DBO.Deltrans_Report With(NoLock)                                 
Where Party_Code >= @FromParty And Party_Code <= @ToParty                                
and Scrip_CD >= @FromScrip And Scrip_CD <= @ToScrip                                
--And TransDate >= @NewFromDate and TransDate <= @ToDate            
And Filler2 = 1             
            
INSERT INTO #DEL_TRANSSTAT_TMP_1            
SELECT D.SNO, D.Sett_No, D.Sett_type, D.RefNo, D.TCode, TrType=904, D.Party_Code, D.scrip_cd, D.series,             
D.Qty, D.FromNo, D.ToNo, D.CertNo, D.FolioNo, HolderName = 'Ben ' + BCLTDPID, Reason = 'Ben ' + BCLTDPID, DrCr = 'D',             
Delivered = 'G', D.OrgQty, D.DpType, D.DpId, D.CltDpId, D.BranchCd, D.PartipantCode,             
D.SlipNo, D.BatchNo, ISett_No='', ISett_Type='', D.ShareType, TransDate = SEC_PAYIN, D.Filler1,            
Filler2 = 0, D.Filler3, BDpType = DP1.DPTYPE, BDpId = DP1.DPID, BCltDpId = DP1.DPCLTNO, D.Filler4, D.Filler5            
FROM #DEL_TRANSSTAT_TMP_1 D, BSEDB.DBO.SETT_MST S, BSEDB.DBO.DELIVERYDP DP, BSEDB.DBO.DELIVERYDP DP1            
WHERE D.SETT_NO = S.SETT_NO            
AND D.SETT_TYPE = S.SETT_TYPE            
AND DP.DESCRIPTION NOT LIKE '%POOL%'            
AND D.BDPID = DP.DPID            
AND D.BCLTDPID = DP.DPCLTNO            
AND FILLER1 NOT IN ('SPILT', 'BONUS', 'RIGHTS')            
AND DP1.DESCRIPTION LIKE '%POOL%'            
AND DP1.DPTYPE = (CASE WHEN FILLER1 = '0' THEN 'NSDL' ELSE 'CDSL' END)          
/*AND TCODE <> 0 */AND FILLER1 NOT LIKE 'HOLDING TRANSFER%'      
                
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED                
  INSERT INTO   TBLDEL_TRANSSTAT_QRLY                
  SELECT D.*,''                 
  FROM   #DEL_TRANSSTAT_TMP_1  D             
WHERE  D.TRANSDATE >= @NEWFROMDATE                
         AND D.TRANSDATE <= @TODATE       
               
                
 UPDATE TBLDEL_TRANSSTAT_QRLY                
 SET SCRIP_NAME = S1.LONG_NAME                
 FROM                
  BSEDB.DBO.SCRIP1 S1 (NOLOCK),                
  BSEDB.DBO.SCRIP2 S2 (NOLOCK)                
 WHERE                
  S1.CO_CODE = S2.CO_CODE                
  AND S2.BSECODE = TBLDEL_TRANSSTAT_QRLY.SCRIP_CD                
                  
                 
 UPDATE TBLDEL_TRANSSTAT_QRLY                
 SET SCRIP_NAME = SCRIP_CD + ' (' + CERTNO + ')'                
 WHERE ISNULL(SCRIP_NAME,'') = ''                
                
  DECLARE STATEMENT_CURSOR CURSOR  FOR                
                  
                  
        
  SELECT DISTINCT DPID,                
                DPCLTNO                
  FROM   BSEDB.DBO.DELIVERYDP D (NOLOCK)                
 WHERE D.DESCRIPTION NOT LIKE '%POOL%' AND D.DESCRIPTION NOT LIKE '%PRINCI%'        
 AND DPCLTNO IN (      
SELECT DISTINCT BCLTDPID      
FROM BSEDB.DBO.DELTRANS      
WHERE FILLER2 = 1        
AND DRCR = 'D'      
AND DELIVERED = '0'      
AND TRTYPE IN (904, 905)      
AND PARTY_CODE <> 'BROKER'      
AND SHARETYPE <> 'AUCTION')      
                 
  OPEN STATEMENT_CURSOR                
                  
  FETCH NEXT FROM STATEMENT_CURSOR                
  INTO @@LOOPDPID,                
       @@LOOPCLTDPID                
                       
  WHILE @@FETCH_STATUS = 0                
    BEGIN                
  TRUNCATE TABLE  TBLDEL_TRANSSTAT1_QRLY                
  INSERT INTO     TBLDEL_TRANSSTAT1_QRLY                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO,                
                   DPID = BDPID,                
                   CLTDPID = BCLTDPID,                
                   TRTYPE,                
                   REASON = (CASE                 
                               WHEN HOLDERNAME LIKE 'MARGIN%' THEN 'TRANS TO MARGIN'                
                               ELSE 'TRANS TO BEN'                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 1                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   BSEDB.DBO.CLIENT2 C2,                
                   BSEDB.DBO.CLIENT1 C1                
          WHERE    DRCR = 'D'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = 'G'                
                   AND FILLER2 = 0                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
     AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND HOLDERNAME LIKE '%' + RTRIM(LTRIM(@@LOOPCLTDPID)) + '%'                
                   AND HOLDERNAME NOT LIKE 'MARGIN%'                
                   AND C1.BRANCH_CD LIKE (CASE        
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
     WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
  D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,HOLDERNAME                
                                   
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO,                
                   DPID = DPID,                
                   CLTDPID = CLTDPID,                
                   TRTYPE,                
                   UPPER(REASON),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                         FLAG = 2                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   BSEDB.DBO.CLIENT2 C2,            
                   BSEDB.DBO.CLIENT1 C1                
          WHERE    DRCR = 'C'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   /*AND DELIVERED = '0'*/                
                   AND FILLER2 = 1                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   /*AND SETT_NO = '2000000' */                
                   AND FILLER1 NOT IN ('SPLIT','BONUS')                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
      END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME         
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
               BDPID,BCLTDPID,REASON                
                                   
          UNION ALL                
                          
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   SCRIP_NAME = D.SCRIP_CD + '( ' + CERTNO + ')',                
                   CERTNO,                
                   CQTY = SUM(QTY),                
                   DQTY = 0,                
                   SLIPNO = 0,                
                   DPID = '',                
                   CLTDPID = '',                
                   TRTYPE,                
                   UPPER(REASON),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 3                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   BSEDB.DBO.CLIENT2 C2,                
                   BSEDB.DBO.CLIENT1 C1                
          WHERE    DRCR = 'C'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = '0'                
                   AND FILLER2 = 1                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
          AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   AND FILLER1 IN ('SPLIT','BONUS')                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
     AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                 END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,REASON                
                                   
          UNION ALL                
          SELECT  TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = 0,                
                   DQTY = SUM(QTY),                
                   SLIPNO = (CASE                 
                               WHEN FILLER1 = 'SPLIT' THEN 0                
                               ELSE SLIPNO                
                             END),                
                   DPID = (CASE                 
                             WHEN TRTYPE IN (1000,907,908) THEN ''                
                             WHEN FILLER1 = 'SPLIT' THEN ''                
                             WHEN FILLER1 LIKE 'CHANGE TO%' THEN ''                
                             ELSE DPID                
                           END),                
                   CLTDPID = (CASE                 
                                WHEN TRTYPE IN (1000,907,908) THEN ''                
                                WHEN FILLER1 = 'SPLIT' THEN ''                
                                WHEN FILLER1 LIKE 'CHANGE TO%' THEN ''                
                                ELSE CLTDPID                
                              END),                
                   TRTYPE,                
                   REASON = (CASE                 
                               WHEN TRTYPE IN (1000,907,908) THEN 'TRANS TO POOL - ' + ISETT_NO + '-' + ISETT_TYPE                
                               ELSE (CASE                 
                                       WHEN FILLER1 = 'SPLIT' THEN 'CORPORATE ACTION'                
                                       WHEN FILLER1 LIKE 'CHANGE TO%' THEN FILLER1                
                                       ELSE (CASE                 
                                               WHEN REASON = 'DEMAT' THEN 'PAY-OUT'                
                           ELSE REASON                
                                             END)                
                                     END)                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 4                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   BSEDB.DBO.CLIENT2 C2,                
                   BSEDB.DBO.CLIENT1 C1                
          WHERE    FILLER2 = 1                
                   AND DRCR = 'D'                
AND DELIVERED <> '0'                
                   AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                              ELSE '%'                
                                           END)                
                   AND HOLDERNAME NOT LIKE 'MARGIN%'                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
         D.SCRIP_CD,CERTNO,SLIPNO,DPID,                
                   CLTDPID,TRTYPE,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,FILLER1,REASON                
                                   
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,TRANSDATE,103),                
                   SETT_NO,                
                   SETT_TYPE,                
                   D.PARTY_CODE,                
                   D.SCRIP_CD,                
                   D.SCRIP_NAME,                
                   CERTNO,                
                   CQTY = 0,                
                   DQTY = SUM(QTY),                
                   SLIPNO,                
                   DPID = DP.DPID,                
                   CLTDPID = DP.DPCLTNO,                
      TRTYPE,                
                   REASON = (CASE                 
                               WHEN HOLDERNAME LIKE 'MARGIN%' THEN 'TRANS TO MARGIN'                
                               ELSE 'TRANS TO BEN'                
                             END),                
                   BDPID,                
                   BCLTDPID,                
                   TRANSDATE1 = TRANSDATE,                
                   FLAG = 1                
          FROM     TBLDEL_TRANSSTAT_QRLY D,                
                   BSEDB.DBO.CLIENT2 C2,                
                   BSEDB.DBO.CLIENT1 C1,                
                   BSEDB.DBO.DELIVERYDP DP                
          WHERE    DRCR = 'D'                
        AND SHARETYPE <> 'AUCTION'                
                   AND CERTNO LIKE 'IN%'                
                   AND DELIVERED = 'G'                
                   AND FILLER2 = 0                
                   AND C2.CL_CODE = C1.CL_CODE                
                   AND C2.PARTY_CODE = D.PARTY_CODE                
                   AND TRANSDATE >= @NEWFROMDATE                
                   AND TRANSDATE <= @TODATE                
                   AND D.PARTY_CODE >= @FROMPARTY                
                   AND D.PARTY_CODE <= @TOPARTY                
                   AND D.SCRIP_CD >= @FROMSCRIP                
                   AND D.SCRIP_CD <= @TOSCRIP                
                   AND BDPID = @@LOOPDPID                
                   AND BCLTDPID = @@LOOPCLTDPID                
                   /*AND DESCRIPTION NOT LIKE '%POOL%'    */            
                   AND (HOLDERNAME LIKE 'BEN ' + DP.DPCLTNO                
                         OR HOLDERNAME LIKE 'MARGIN ' + DP.DPCLTNO)         
                   AND C1.BRANCH_CD LIKE (CASE                 
                                            WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME                
                                            ELSE '%'                
                                          END)                
                   AND C1.SUB_BROKER LIKE (CASE                 
                                             WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
                   AND C1.TRADER LIKE (CASE                 
                                         WHEN @STATUSID = 'TRADER' THEN @STATUSNAME                
                                        ELSE '%'                
                                       END)                
                   AND C1.FAMILY LIKE (CASE                 
                                         WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME                
                                         ELSE '%'                
                                       END)                
                   AND C2.PARTY_CODE LIKE (CASE                 
                                             WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME                
                                             ELSE '%'                
                                           END)                
          GROUP BY TRANSDATE,SETT_NO,SETT_TYPE,D.PARTY_CODE, D.SCRIP_NAME,                
                   D.SCRIP_CD,CERTNO,SLIPNO,TRTYPE,                
                   DP.DPID,DPCLTNO,ISETT_NO,ISETT_TYPE,                
                   BDPID,BCLTDPID,HOLDERNAME                
                
                
          INSERT INTO #TABLE2                
          SELECT   TRANSDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@FROMDATE),103),                
                   SETT_NO = '',                
                   SETT_TYPE = '',                
                   PARTY_CODE,                
                   SCRIP_CD,                
                   SCRIP_NAME,                
                   CERTNO,                
                   CQTY = (CASE                 
                             WHEN SUM(CQTY - DQTY) > 0 THEN SUM(CQTY - DQTY)                
                             ELSE 0                
 END),                
                   DQTY = (CASE                 
                             WHEN SUM(DQTY - CQTY) > 0 THEN SUM(DQTY - CQTY)                
                             ELSE 0                
                           END),                
                   SLIPNO = '0',                
                   DPID = '',                
       CLTDPID = '',                
                   TRTYPE = '0',                
                   REASON = 'OPENING BALANCE',                
                   BDPID = '',                
           BCLTDPID = '',   
                   TRANSDATE1 = CONVERT(DATETIME,@FROMDATE),                
                   FLAG = 0                
          FROM     TBLDEL_TRANSSTAT1_QRLY                
          WHERE    TRANSDATE1 < @FROMDATE                
          GROUP BY PARTY_CODE, SCRIP_CD,SCRIP_NAME,CERTNO                
          UNION ALL                
          SELECT *                
          FROM   TBLDEL_TRANSSTAT1_QRLY                
          WHERE  TRANSDATE1 >= @FROMDATE                
                 AND TRANSDATE1 <= @TODATE                
          UNION ALL                
          SELECT   TRANSDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@TODATE),103),                
                   SETT_NO = '',                
                   SETT_TYPE = '',                
                   PARTY_CODE,                
                   SCRIP_CD,                
                   SCRIP_NAME,                
                   CERTNO,                
                   CQTY = (CASE                 
                             WHEN SUM(CQTY - DQTY) > 0 THEN SUM(CQTY - DQTY)                
                             ELSE 0                
                           END),                
                   DQTY = (CASE                 
                             WHEN SUM(DQTY - CQTY) > 0 THEN SUM(DQTY - CQTY)                
                             ELSE 0                
                           END),         
                   SLIPNO = '0',                
                   DPID = '',                
                   CLTDPID = '',                
                   TRTYPE = '0',                
  REASON = 'CLOSING BALANCE',                
                   BDPID = '',                
                   BCLTDPID = '',                
                   TRANSDATE1 = CONVERT(DATETIME,@TODATE),                
                   FLAG = 6                
          FROM     TBLDEL_TRANSSTAT1_QRLY                
          WHERE    TRANSDATE1 <= @TODATE                
          GROUP BY PARTY_CODE, SCRIP_CD,SCRIP_NAME,CERTNO                
          ORDER BY PARTY_CODE,                
                   SCRIP_CD,                
                   CERTNO,                
                   TRANSDATE1,                
                   FLAG,                
                   SETT_NO,                
                   SETT_TYPE                
                                   
          TRUNCATE TABLE TBLDEL_TRANSSTAT1_QRLY                
                
                
                      
      FETCH NEXT FROM STATEMENT_CURSOR                
      INTO @@LOOPDPID,                
           @@LOOPCLTDPID                
    END                
                    
  CLOSE STATEMENT_CURSOR                
                  
  DEALLOCATE STATEMENT_CURSOR                
                
 INSERT INTO #TABLEREPORT                
  SELECT   'BSECM', *                
      FROM     #TABLE2                
  WHERE  CQTY <> 0 OR DQTY <> 0                      
 ORDER BY PARTY_CODE,                
               SCRIP_CD,                
               FLAG,                
               TRANSDATEDT                
                               
      TRUNCATE TABLE #TABLE2                
      DROP TABLE #TABLE2                
                
                
                
                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER                
SELECT                   
 Q.*                
FROM                   
 #TABLEREPORT Q (NOLOCK)                  
                
                
TRUNCATE TABLE #TABLEREPORT                
DROP TABLE #TABLEREPORT                
*/      
                
/*             
SELECT EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN,          effdate, SUM(QTY)              
FROM C_SECURITIESMST              
where effdate >= '' and effdate <= ''              
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, effdate  
*/  
  
  
  
IF (@TOBRANCH = '')  
BEGIN  
 set @TOBRANCH  = 'zzzzzzzzzz'  
END  
  
IF (@TOSUBBROKER = '')  
BEGIN  
 set @TOSUBBROKER  = 'zzzzzzzzzz'  
END  
  
CREATE TABLE #CLIENTMASTER  
 (  
 PARTY_CODE VARCHAR(15),  
 PARTYNAME VARCHAR(100),  
 PARENTCODE VARCHAR(15),  
 BRANCH_CD VARCHAR(15),  
 SUB_BROKER VARCHAR(15)  
 )  
  
IF (@RPT_FILTER = 0)  
BEGIN  
 INSERT INTO #CLIENTMASTER  
 SELECT  
  DISTINCT  
  PARTY_CODE,  
  PARTYNAME='',  
  PARENTCODE,  
  BRANCH_CD,  
  SUB_BROKER  
 FROM  
  MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK)  
 WHERE  
  PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH  
  AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER  
END  
ELSE  
BEGIN  
 INSERT INTO #CLIENTMASTER  
 SELECT  
  DISTINCT  
  PARTY_CODE = T.PARTY_CODE,  
  PARTYNAME='',  
  PARENTCODE,  
  BRANCH_CD,  
  SUB_BROKER  
 FROM  
  PRADNYA.DBO.TBLCLIENT_GROUP T WITH (NOLOCK),  
  MSAJAG.DBO.CLIENT_DETAILS C WITH (NOLOCK)  
 WHERE  
  T.PARTY_CODE = C.PARTY_CODE  
  AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH  
  AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER  
END  
  
/*  
UPDATE #CLIENTMASTER SET PARTYNAME = ISNULL(SHORT_NAME,'') FROM MSAJAG.DBO.CLIENT_DETAILS (NOLOCK)  
WHERE #CLIENTMASTER.PARENTCODE = CLIENT_DETAILS.PARENTCODE  
*/                  
                  
CREATE TABLE #COLL              
(              
 EXCHANGE VARCHAR(10),              
 SEGMENT VARCHAR(20),              
 EXCSEGMENT VARCHAR(10),              
 EFFDT VARCHAR(10),              
 PARTY_CODE VARCHAR(10),              
 SCRIP_CD VARCHAR(20),              
 SERIES VARCHAR(10),              
 SCRIP_NAME VARCHAR(100),              
 CERTNO VARCHAR(20),              
 CQTY INT,              
 DQTY INT,              
 REASON VARCHAR(255),              
 TRANSDATEDT DATETIME,              
 FLAG INT              
)              
               
INSERT INTO #COLL              
SELECT            
 EXCHANGE,            
 SEGMENT,            
 '',            
 CONVERT(varchar,CONVERT(DATETIME, @FROMDATE,109),103),            
 PARTY_CODE,            
 SCRIP_CD,            
 SERIES,            
 '',            
 ISIN,            
 CQTY = (CASE WHEN SUM(CQTY - DQTY) >= 0 THEN SUM(CQTY - DQTY) ELSE 0 END),            
 DQTY = (CASE WHEN SUM(DQTY - CQTY) >= 0 THEN SUM(DQTY - CQTY) ELSE 0 END),            
 'OPENING BALANCE',              
 CONVERT(DATETIME, @FROMDATE,109),              
 2              
FROM            
 (            
  SELECT               
  EXCHANGE,              
  SEGMENT,               
  PARTY_CODE = C.PARENTCODE,   
  SCRIP_CD, SERIES, ISIN,              
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),              
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))            
  FROM MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)  
  INNER JOIN  
  #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = S.PARTY_CODE)  
  WHERE              
   EFFDATE < @FROMDATE              
   AND S.PARTY_CODE   >= @FROMPARTY            
   AND S.PARTY_CODE <= @TOPARTY            
  GROUP BY EXCHANGE, SEGMENT, C.PARENTCODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS              
 ) X            
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, ISIN            
            
            
            
INSERT INTO #COLL              
SELECT               
EXCHANGE,              
SEGMENT,              
'',              
convert(varchar,effdate,103),               
PARTY_CODE = C.PARENTCODE,  
SCRIP_CD, SERIES, '', ISIN,              
CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),              
DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END)),              
UPPER(REMARKS),              
EFFDATE,              
1              
FROM MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)  
INNER JOIN  
#CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = S.PARTY_CODE)  
WHERE              
 EFFDATE >= @FROMDATE              
 AND EFFDATE <= @TODATE + ' 23:59:59'              
 AND S.PARTY_CODE >= @FROMPARTY            
 AND S.PARTY_CODE <= @TOPARTY            
GROUP BY EXCHANGE, SEGMENT, C.PARENTCODE, SCRIP_CD, SERIES, DRCR, ISIN, EFFDATE, REMARKS              
              
              
/*            
INSERT INTO #COLL              
SELECT               
EXCHANGE,              
SEGMENT,              
'',              
convert(varchar,effdate,103),     PARTY_CODE, SCRIP_CD, SERIES, '', ISIN,              
CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),              
DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END)),              
'CLOSING BALANCE',              
@TODATE + ' 23:59:59',              
6              
FROM MSAJAG.DBO.C_SECURITIESMST (NOLOCK)              
WHERE              
 EFFDATE <= @TODATE + ' 23:59:59'              
 AND PARTY_CODE   >= @FROMPARTY            
 AND PARTY_CODE <= @TOPARTY            
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, EFFDATE, REMARKS              
*/            
            
INSERT INTO #COLL              
SELECT            
 EXCHANGE,            
 SEGMENT,            
 '',            
 CONVERT(varchar,CONVERT(DATETIME, @TODATE,109),103),            
 PARTY_CODE,  
 SCRIP_CD,            
 SERIES,            
 '',            
 ISIN,            
 CQTY = (CASE WHEN SUM(CQTY - DQTY) >= 0 THEN SUM(CQTY - DQTY) ELSE 0 END),   
 DQTY = (CASE WHEN SUM(DQTY - CQTY) >= 0 THEN SUM(DQTY - CQTY) ELSE 0 END),            
 'CLOSING BALANCE',              
 @TODATE + ' 23:59:59',              
 6              
 FROM            
 (            
  SELECT               
  EXCHANGE,              
  SEGMENT,               
  PARTY_CODE = C.PARENTCODE,  
  SCRIP_CD, SERIES, ISIN,              
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),              
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))            
  FROM MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)  
  INNER JOIN  
  #CLIENTMASTER C WITH (NOLOCK) ON (C.PARTY_CODE = S.PARTY_CODE)  
  WHERE              
   EFFDATE <= @TODATE  + ' 23:59:59'            
   AND S.PARTY_CODE >= @FROMPARTY            
   AND S.PARTY_CODE <= @TOPARTY            
  GROUP BY EXCHANGE, SEGMENT, C.PARENTCODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS              
 ) X            
 GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, ISIN            
              
              
              
UPDATE #COLL                
SET SCRIP_NAME = SCRIP_CD + ' (' + CERTNO + ')' ,              
EXCSEGMENT =               
 ( CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'CAPITAL' THEN 'NSECM'              
WHEN EXCHANGE = 'BSE' AND SEGMENT = 'CAPITAL' THEN 'BSECM'              
WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN 'NSEFO'              
WHEN EXCHANGE = 'BSE' AND SEGMENT = 'FUTURES' THEN 'BSEFO'              
WHEN EXCHANGE = 'NCX' AND SEGMENT = 'FUTURES' THEN 'NCDX'              
WHEN EXCHANGE = 'MCX' AND SEGMENT = 'FUTURES' THEN 'MCDX'              
WHEN EXCHANGE = 'ALL' AND SEGMENT = 'COMMON' THEN 'DBCOMMON'              
WHEN EXCHANGE = 'BCM' AND SEGMENT = 'FUTURES' THEN 'BSEFOPCM'              
WHEN EXCHANGE = 'BSE' AND SEGMENT = 'SLBS' THEN 'BSESLBS'              
WHEN EXCHANGE = 'BSX' AND SEGMENT = 'FUTURES' THEN 'BSECURFO'              
WHEN EXCHANGE = 'MCD' AND SEGMENT = 'FUTURES' THEN 'MCDXCDS'              
WHEN EXCHANGE = 'MCM' AND SEGMENT = 'FUTURES' THEN 'MCDXPCM'              
WHEN EXCHANGE = 'NCM' AND SEGMENT = 'FUTURES' THEN 'NSEFOPCM'              
WHEN EXCHANGE = 'NMC' AND SEGMENT = 'FUTURES' THEN 'NMCE'              
WHEN EXCHANGE = 'NSE' AND SEGMENT = 'SLBS' THEN 'NSESLBS'              
WHEN EXCHANGE = 'NSX' AND SEGMENT = 'FUTURES' THEN 'NSECURFO'              
WHEN EXCHANGE = 'NXM' AND SEGMENT = 'FUTURES' THEN 'NSECURFOPCM'                
ELSE 'UNKNOWN' END)              
              
              
UPDATE #COLL              
SET SCRIP_NAME = S1.LONG_NAME                
 FROM                
  MSAJAG.DBO.SCRIP1 S1 WITH (NOLOCK),                
  MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK)  
 WHERE                
  S1.CO_CODE = S2.CO_CODE          
  AND S2.SCRIP_CD = #COLL.SCRIP_CD          
  AND S2.SERIES = #COLL.SERIES           
              
                  
              
UPDATE #COLL              
SET SCRIP_NAME = S1.LONG_NAME                
 FROM                
  BSEDB_AB.DBO.SCRIP1 S1 WITH (NOLOCK),                
  BSEDB_AB.DBO.SCRIP2 S2 WITH (NOLOCK)  
 WHERE                
  S1.CO_CODE = S2.CO_CODE                
  AND S2.BSECODE = #COLL.SCRIP_CD                
              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER                
SELECT                   
 EXCSEGMENT,              
 EFFDT,              
 '',              
 '',              
 PARTY_CODE,              
 SCRIP_CD,              
 SCRIP_NAME,              
 CERTNO,              
 CQTY,              
 DQTY,              
 '0',              
 '',              
 '',              
 '0',              
 UPPER(REASON),              
 '',              
 '',              
 TRANSDATEDT ,              
 FLAG               
FROM                   
 #COLL  (NOLOCK)                  
WHERE            
 PARTY_CODE   >= @FROMPARTY            
 AND PARTY_CODE <= @TOPARTY            
 AND ( CQTY <> 0  OR DQTY <> 0)            
              
TRUNCATE TABLE #COLL              
DROP TABLE #COLL              
            
--- Select * from V2_CLASS_QUARTERLYSECLEDGER            
  
Delete from V2_CLASS_QUARTERLYSECLEDGER where Party_code in ('BROKER','EEEE','SSSS')  
            
SET ANSI_NULLS OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw
-- --------------------------------------------------
    
CREATE PROC Vw @VwName VARCHAR(25)AS                   
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Charges_detail240610
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Charges_detail240610]
(
    [CD_SrNo] INT NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Charges_detail250610
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Charges_detail250610]
(
    [CD_SrNo] INT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Charges_detail280610
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Charges_detail280610]
(
    [CD_SrNo] INT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_Charges_Detail290610
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_Charges_Detail290610]
(
    [CD_SrNo] INT IDENTITY(1,1) NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_DKM_Charges_Detail
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_DKM_Charges_Detail]
(
    [CD_SrNo] INT NOT NULL,
    [CD_Party_Code] VARCHAR(10) NOT NULL,
    [CD_Sett_No] VARCHAR(7) NOT NULL,
    [CD_Sett_Type] VARCHAR(2) NOT NULL,
    [CD_Sauda_Date] DATETIME NOT NULL,
    [CD_ContractNo] VARCHAR(7) NOT NULL,
    [CD_Trade_No] VARCHAR(14) NOT NULL,
    [CD_Order_No] VARCHAR(16) NULL,
    [CD_Scrip_Cd] VARCHAR(12) NOT NULL,
    [CD_Series] VARCHAR(3) NOT NULL,
    [CD_BuyRate] MONEY NOT NULL,
    [CD_SellRate] MONEY NOT NULL,
    [CD_TrdBuy_Qty] INT NOT NULL,
    [CD_TrdSell_Qty] INT NOT NULL,
    [CD_DelBuy_Qty] INT NOT NULL,
    [CD_DelSell_Qty] INT NOT NULL,
    [CD_TrdBuyBrokerage] MONEY NOT NULL,
    [CD_TrdSellBrokerage] MONEY NOT NULL,
    [CD_DelBuyBrokerage] MONEY NOT NULL,
    [CD_DelSellBrokerage] MONEY NOT NULL,
    [CD_TotalBrokerage] MONEY NOT NULL,
    [CD_TrdBuySerTax] MONEY NOT NULL,
    [CD_TrdSellSerTax] MONEY NOT NULL,
    [CD_DelBuySerTax] MONEY NOT NULL,
    [CD_DelSellSerTax] MONEY NOT NULL,
    [CD_TotalSerTax] MONEY NOT NULL,
    [CD_TrdBuy_TurnOver] MONEY NOT NULL,
    [CD_TrdSell_TurnOver] MONEY NOT NULL,
    [CD_DelBuy_TurnOver] MONEY NOT NULL,
    [CD_DelSell_TurnOver] MONEY NOT NULL,
    [CD_Computation_Level] CHAR(1) NOT NULL,
    [CD_Min_BrokAmt] MONEY NOT NULL,
    [CD_Max_BrokAmt] MONEY NOT NULL,
    [CD_Min_ScripAmt] MONEY NOT NULL,
    [CD_Max_ScripAmt] MONEY NOT NULL,
    [CD_TimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bak_multicompany_06072006
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_multicompany_06072006]
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
-- TABLE dbo.bak_multicompany_alldec292014
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_multicompany_alldec292014]
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
-- TABLE dbo.bak_multicompany_apr202022
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_multicompany_apr202022]
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
    [Filler2] VARCHAR(2) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bak_multicompanymar282017
-- --------------------------------------------------
CREATE TABLE [dbo].[bak_multicompanymar282017]
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
    [Filler2] VARCHAR(2) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CBO_SQLCONTROL
-- --------------------------------------------------
CREATE TABLE [dbo].[CBO_SQLCONTROL]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [SQL_KEY] VARCHAR(100) NULL,
    [SQL_SUPPLEMENT] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CHARTSPECS
-- --------------------------------------------------
CREATE TABLE [dbo].[CHARTSPECS]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CHARTCODE] VARCHAR(10) NULL,
    [CHARTDESCRIPTION] VARCHAR(100) NULL,
    [DEFAULTTYPE] VARCHAR(1) NULL,
    [HEADING_PREFIX] VARCHAR(100) NULL,
    [HEADING_FIELD] VARCHAR(100) NULL,
    [HEADING_SUFFIX] VARCHAR(100) NULL,
    [SUBHEAD_PREFIX] VARCHAR(100) NULL,
    [SUBHEAD_FIELD] VARCHAR(100) NULL,
    [SUBHEAD_SUFFIX] VARCHAR(100) NULL,
    [DECIMALS] NUMERIC(2, 0) NULL,
    [SHOWLABELS] BIT NULL,
    [SHOWVALUES] BIT NULL,
    [NUMBERPREFIX] VARCHAR(10) NULL,
    [NUMBERSUFFIX] VARCHAR(10) NULL,
    [SHOWHOVERVALUES] BIT NULL,
    [XAXISLABEL] VARCHAR(100) NULL,
    [YAXISLABEL] VARCHAR(100) NULL,
    [DATAGROUPON] VARCHAR(200) NULL,
    [DATALABEL_PREFIX] VARCHAR(100) NULL,
    [DATALABLE_FIELD] VARCHAR(50) NULL,
    [DATALABEL_SUFFIX] VARCHAR(100) NULL,
    [DATAVALUE] VARCHAR(50) NULL,
    [DATACOLOR] VARCHAR(20) NULL,
    [VALUEOPERATION] VARCHAR(20) NULL,
    [REPORTGROUP] VARCHAR(100) NULL,
    [REPORTCODE] VARCHAR(10) NOT NULL
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
-- TABLE dbo.CLS_OWNER_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_OWNER_NEW]
(
    [Company] VARCHAR(60) NULL,
    [Addr1] VARCHAR(50) NULL,
    [Addr2] VARCHAR(50) NULL,
    [Phone] VARCHAR(60) NULL,
    [Zip] VARCHAR(6) NULL,
    [city] VARCHAR(20) NULL,
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
    [Fax] VARCHAR(25) NULL,
    [KRA_TYPE] VARCHAR(4) NULL,
    [POS_CODE] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [WEBSITE_ID] VARCHAR(100) NULL,
    [COMPLIANCE_NAME] VARCHAR(50) NULL,
    [COMPLIANCE_EMAIL] VARCHAR(100) NULL,
    [COMPLIANCE_PHONE] VARCHAR(15) NULL,
    [SERVICES_TAXNO] VARCHAR(30) NULL,
    [CIN] VARCHAR(30) NULL,
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
    [CORP_FAX] VARCHAR(25) NULL
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
    [FLDREPORTCODE] VARCHAR(20) NULL,
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
    [DUMMY4] VARCHAR(10) NULL
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
-- TABLE dbo.CLS_PLDETAIL
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_PLDETAIL]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Exchange] CHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [Vtype] INT NULL,
    [Setttype] VARCHAR(3) NULL,
    [Narration] VARCHAR(25) NULL,
    [ReportURL] VARCHAR(250) NULL,
    [Flag] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_PROCESSSTATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_PROCESSSTATUS]
(
    [SESSION_ID] VARCHAR(200) NULL
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
-- TABLE dbo.DataIn_History_Fosettlement_mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_mcdx]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] DATETIME NULL
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
    [expirydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DATAIN_HISTORY_FOSETTLEMENT_NSECURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[DATAIN_HISTORY_FOSETTLEMENT_NSECURFO]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_Nsefo]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [expirydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.F2CONFIG
-- --------------------------------------------------
CREATE TABLE [dbo].[F2CONFIG]
(
    [SRNO] SMALLINT IDENTITY(1,1) NOT NULL,
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
-- TABLE dbo.history_Fosettlement_Mcdx
-- --------------------------------------------------
CREATE TABLE [dbo].[history_Fosettlement_Mcdx]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] INT NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] DATETIME NULL,
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
    [CpId] INT NULL,
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
-- TABLE dbo.HISTORY_FOSETTLEMENT_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOSETTLEMENT_NCDX]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] DATETIME NULL,
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
-- TABLE dbo.HISTORY_FOSETTLEMENT_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_FOSETTLEMENT_NSEFO]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] DATETIME NULL,
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
    [Order_no] VARCHAR(16) NULL,
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
    [Status] VARCHAR(2) NULL,
    [CpId] VARCHAR(20) NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
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
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_NSEcurFO
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_NSEcurFO]
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
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_NSEFO]
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
-- TABLE dbo.MAINSHEET
-- --------------------------------------------------
CREATE TABLE [dbo].[MAINSHEET]
(
    [C_PARTY_NETWORK_ID] FLOAT NULL,
    [a_party_id] FLOAT NULL,
    [b_party_id] FLOAT NULL,
    [DURATION] FLOAT NULL,
    [DUR IN MINUTES] FLOAT NULL,
    [Date] DATETIME NULL,
    [call_type] NVARCHAR(255) NULL,
    [unit] FLOAT NULL,
    [charge] FLOAT NULL,
    [chg] FLOAT NULL,
    [len] FLOAT NULL,
    [len1] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicompany
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicompany]
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
    [License] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_11Mar24
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_11Mar24]
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
-- TABLE dbo.MULTICOMPANY_12062013
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_12062013]
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
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_15012011
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_15012011]
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
    [dbusername] VARCHAR(10) NULL,
    [dbpassword] VARCHAR(10) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY_18122017
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY_18122017]
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
    [Filler2] VARCHAR(2) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_196122011
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_196122011]
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
    [Segment_Description] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_22122011
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_22122011]
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
    [Segment_Description] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MultiCompany_Additional
-- --------------------------------------------------
CREATE TABLE [dbo].[MultiCompany_Additional]
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
-- TABLE dbo.MultiCompany_Additional_15122017
-- --------------------------------------------------
CREATE TABLE [dbo].[MultiCompany_Additional_15122017]
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
-- TABLE dbo.multicompany_all_23122014
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_all_23122014]
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
-- TABLE dbo.multicompany_Bkup_23May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_Bkup_23May2019]
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
    [Filler2] VARCHAR(2) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_ServiceUser_BKP_20220510
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_ServiceUser_BKP_20220510]
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
    [Filler2] VARCHAR(2) NULL,
    [dbusername] VARCHAR(25) NULL,
    [dbpassword] VARCHAR(25) NULL,
    [FLDSRNO] TINYINT NULL,
    [Segment_Description] VARCHAR(100) NULL,
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL,
    [category] VARCHAR(50) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [CONTRACTGROUP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany15092008
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany15092008]
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
    [dbusername] VARCHAR(10) NULL,
    [dbpassword] VARCHAR(10) NULL,
    [FLDSRNO] TINYINT NULL
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
-- TABLE dbo.OND2009
-- --------------------------------------------------
CREATE TABLE [dbo].[OND2009]
(
    [PARTY_CODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OWNER
-- --------------------------------------------------
CREATE TABLE [dbo].[OWNER]
(
    [Company] VARCHAR(60) NULL,
    [Addr1] VARCHAR(50) NULL,
    [Addr2] VARCHAR(50) NULL,
    [Phone] VARCHAR(60) NULL,
    [Zip] VARCHAR(6) NULL,
    [city] VARCHAR(20) NULL,
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
    [Fax] VARCHAR(25) NULL,
    [KRA_TYPE] VARCHAR(4) NULL,
    [POS_CODE] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [WEBSITE_ID] VARCHAR(100) NULL,
    [COMPLIANCE_NAME] VARCHAR(50) NULL,
    [COMPLIANCE_EMAIL] VARCHAR(100) NULL,
    [COMPLIANCE_PHONE] VARCHAR(15) NULL,
    [SERVICES_TAXNO] VARCHAR(30) NULL,
    [CIN] VARCHAR(30) NULL,
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
    [CORP_FAX] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pdfmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[pdfmaster]
(
    [SRNO] INT NOT NULL,
    [PDFCODE] VARCHAR(10) NOT NULL,
    [PDFDESCRIPTION] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [SPNAME] VARCHAR(100) NULL,
    [RPTFILE] VARCHAR(100) NULL,
    [FILE_SUFFIX] VARCHAR(10) NULL,
    [FILE_PREFIX] VARCHAR(10) NULL,
    [FIELDINFILENAME] VARCHAR(150) NULL,
    [DATESTAMP] BIT NULL,
    [DTSTAMPFORMAT] VARCHAR(10) NULL,
    [NAMEDELIMETER] VARCHAR(1) NULL,
    [PDFON] VARCHAR(50) NULL,
    [SERVERIP] VARCHAR(50) NOT NULL,
    [DATABASENAME] VARCHAR(20) NOT NULL,
    [USER_NAME] VARCHAR(20) NOT NULL,
    [USER_PASSWORD] VARCHAR(20) NOT NULL,
    [PARAMETERPOSITION] VARCHAR(15) NULL,
    [PDFONMASTER] VARCHAR(40) NULL,
    [SIGIMGFIELD] VARCHAR(25) NULL
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
-- TABLE dbo.REPORT_GROUPING_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORT_GROUPING_NEW]
(
    [RG_SrNo] INT IDENTITY(1,1) NOT NULL,
    [RG_Report_Code] VARCHAR(10) NULL,
    [RG_Group_Field] VARCHAR(50) NULL,
    [RG_Group_Order] INT NULL,
    [RG_Mapped_Header_Section] VARCHAR(10) NULL,
    [RG_Mapped_Footer_Section] VARCHAR(10) NULL,
    [RG_Report_Header] BIT NULL,
    [RG_Repport_Footer] BIT NULL,
    [RG_PageBreak] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORT_RUNTIME_HANDLE
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORT_RUNTIME_HANDLE]
(
    [RR_SR_NO] INT IDENTITY(1,1) NOT NULL,
    [RR_REPORT_CODE] VARCHAR(10) NULL,
    [RR_UPDATE_FIELDS] VARCHAR(500) NULL,
    [RR_UPDATE_VALUES] VARCHAR(500) NULL,
    [RR_WHERE_FIELDS] VARCHAR(500) NULL,
    [RR_WHERE_VALUES] VARCHAR(500) NULL,
    [RR_CONDITION_CODE] VARCHAR(10) NULL,
    [RR_ISSTRUCTURE] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORTDETAILS_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORTDETAILS_NEW]
(
    [RD_Sr_NO] INT IDENTITY(1,1) NOT NULL,
    [RD_Report_Code] VARCHAR(10) NULL,
    [RD_Report_Fld] VARCHAR(50) NULL,
    [RD_Mapped_Fld] VARCHAR(50) NULL,
    [RD_Field_Label] VARCHAR(500) NULL,
    [RD_Field_Description] VARCHAR(500) NULL,
    [RD_Field_XPosition] INT NULL,
    [RD_Field_YPosition] INT NULL,
    [RD_Field_Width] INT NULL,
    [RD_WrapText] BIT NULL,
    [RD_WrapLines] BIT NULL,
    [RD_Field_Allign] VARCHAR(10) NULL,
    [RD_IsDisplayed] BIT NULL,
    [RD_IsPrintable] BIT NULL,
    [RD_IsExportable] BIT NULL,
    [RD_Field_Rounding] INT NULL,
    [RD_Rounding_Style] VARCHAR(10) NULL,
    [RD_Report_Section] VARCHAR(10) NULL,
    [RD_IsCompulsory] BIT NULL,
    [RD_ForeColor] VARCHAR(7) NULL,
    [RD_BlackColor] VARCHAR(7) NULL,
    [RD_Bold] BIT NULL,
    [RD_UnderLine] BIT NULL,
    [RD_CssClass] VARCHAR(30) NULL,
    [RD_Header_CssClass] VARCHAR(30) NULL,
    [RD_Header_StyleElement] VARCHAR(1000) NULL,
    [RD_StyleElement] VARCHAR(1000) NULL,
    [RD_IsFormulaField] BIT NULL,
    [RD_IsAggregate] BIT NULL,
    [RD_Lable_ColumnSpan] INT NULL,
    [RD_Value_ColumnSpan] INT NULL,
    [RD_IsDrillDown] BIT NULL,
    [RD_IsNoHeader] BIT NOT NULL DEFAULT ((0)),
    [RD_SplField] VARCHAR(25) NULL,
    [RD_FieldID] VARCHAR(20) NULL,
    [RD_LableID] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORTFORMULATION_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORTFORMULATION_NEW]
(
    [RF_Sr_NO] INT IDENTITY(1,1) NOT NULL,
    [RF_Report_Code] VARCHAR(10) NULL,
    [RF_Formula_Field] VARCHAR(50) NULL,
    [RF_Field_Formula] VARCHAR(500) NULL,
    [RF_Division] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORTLINKS_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORTLINKS_NEW]
(
    [RL_SrNo] INT IDENTITY(1,1) NOT NULL,
    [RL_Report_Code] VARCHAR(10) NULL,
    [RL_Mapped_Fld] VARCHAR(50) NULL,
    [RL_DisplayText] VARCHAR(50) NULL,
    [RL_OrderNo] INT NULL,
    [RL_IsDivider] BIT NULL,
    [RL_InnerCSS] VARCHAR(50) NULL,
    [RL_InnerStyle] VARCHAR(1000) NULL,
    [RL_PopCSS] VARCHAR(50) NULL,
    [RL_PopStyle] VARCHAR(1000) NULL,
    [RL_PageAddress] VARCHAR(200) NULL,
    [RL_QryStrParams] VARCHAR(1000) NULL,
    [RL_QryValFlds] VARCHAR(1000) NULL,
    [RL_ReqParams] VARCHAR(1000) NULL,
    [RL_ReqVal] VARCHAR(1000) NULL,
    [RL_LiteralName] VARCHAR(1000) NULL,
    [RL_LiteralValue] VARCHAR(1000) NULL,
    [RL_ParamList] VARCHAR(2000) NULL,
    [RL_FILTERVAL] VARCHAR(100) NULL,
    [RL_NOLINK] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORTMASTER_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORTMASTER_NEW]
(
    [RM_Sr_NO] INT IDENTITY(1,1) NOT NULL,
    [RM_Report_Code] VARCHAR(10) NOT NULL,
    [RM_Report_Description] VARCHAR(100) NULL,
    [RM_Page_Length] INT NULL,
    [RM_Page_Width] INT NULL,
    [RM_Has_Header] BIT NULL,
    [RM_Has_Footer] BIT NULL,
    [RM_IsPlain] BIT NULL,
    [RM_IsGrouping] BIT NULL,
    [RM_MainTblStyle] VARCHAR(1000) NULL,
    [RM_ProcName] VARCHAR(100) NULL,
    [RM_Params] VARCHAR(2000) NULL,
    [RM_ParaType] VARCHAR(2000) NULL,
    [RM_ParamSize] VARCHAR(1000) NULL,
    [RM_ParamDirect] VARCHAR(500) NULL,
    [RM_IsPaginated] BIT NULL,
    [RM_Page_ProcName] VARCHAR(100) NULL,
    [RM_Page_Params] VARCHAR(2000) NULL,
    [RM_Page_ParaType] VARCHAR(2000) NULL,
    [RM_Page_ParamSize] VARCHAR(1000) NULL,
    [RM_Page_ParamDirect] VARCHAR(500) NULL,
    [RM_Page_ParamPosition] VARCHAR(30) NULL,
    [RM_Page_ParamLocation] VARCHAR(30) NULL,
    [RM_PrintCompanyName] BIT NULL,
    [RM_PrintCompanyAddress] BIT NULL,
    [RM_IsInternal] BIT NULL,
    [OutputFileds] VARCHAR(1000) NULL,
    [RM_PG_CONN] VARCHAR(100) NULL,
    [RM_MAINSP_CONN] VARCHAR(100) NULL,
    [RM_CRYSTAL_CLASS] VARCHAR(100) NULL,
    [RM_IsCrystal] BIT NULL,
    [RM_RepeatPageHeader] BIT NULL,
    [RM_CHARTCODE] VARCHAR(10) NULL,
    [RM_ISMAILABLE] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.REPORTSUMMATION_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[REPORTSUMMATION_NEW]
(
    [RS_SrNo] INT IDENTITY(1,1) NOT NULL,
    [RS_Report_Code] VARCHAR(10) NULL,
    [RS_Report_Fld] VARCHAR(50) NULL,
    [RS_Expression] VARCHAR(500) NULL,
    [RS_Operation] VARCHAR(20) NULL,
    [RS_Condition] VARCHAR(500) NULL
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
-- TABLE dbo.SessionLog
-- --------------------------------------------------
CREATE TABLE [dbo].[SessionLog]
(
    [sessionid] VARCHAR(50) NOT NULL,
    [uid] VARCHAR(50) NULL,
    [lToken] VARCHAR(50) NOT NULL,
    [rToken] VARCHAR(50) NOT NULL,
    [dgToken] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t_multicompany_02072007
-- --------------------------------------------------
CREATE TABLE [dbo].[t_multicompany_02072007]
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
-- TABLE dbo.TBL_SCCS_DATA_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCS_DATA_TEMP]
(
    [SCCS_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [BSECM_LEDGER] MONEY NULL,
    [NSECM_LEDGER] MONEY NULL,
    [NSEFO_LEDGER] MONEY NULL,
    [NSX_LEDGER] MONEY NULL,
    [MCD_LEDGER] MONEY NULL,
    [BSECM_DEPOSIT] MONEY NULL,
    [NSECM_DEPOSIT] MONEY NULL,
    [NSEFO_DEPOSIT] MONEY NULL,
    [NSX_DEPOSIT] MONEY NULL,
    [MCD_DEPOSIT] MONEY NULL,
    [OTHER_SEGMENT] MONEY NULL,
    [BSECM_COLLATERAL] INT NOT NULL,
    [NSECM_COLLATERAL] INT NOT NULL,
    [NSEFO_COLLATERAL] MONEY NULL,
    [NSX_COLLATERAL] MONEY NULL,
    [MCD_COLLATERAL] MONEY NULL,
    [ACCRUAL] NUMERIC(20, 4) NULL,
    [BSECM_UNRECO] MONEY NULL,
    [NSECM_UNRECO] MONEY NULL,
    [NSEFO_UNRECO] MONEY NULL,
    [NSX_UNRECO] MONEY NULL,
    [MCD_UNRECO] MONEY NULL,
    [NSEFO_MARGIN] NUMERIC(23, 6) NULL,
    [NSX_MARGIN] NUMERIC(23, 6) NULL,
    [MCD_MARGIN] NUMERIC(23, 6) NULL,
    [BSECM_UNSETTLE] MONEY NULL,
    [NSECM_UNSETTLE] MONEY NULL,
    [NSEFO_UNSETTLE] MONEY NULL,
    [NSX_UNSETTLE] MONEY NULL,
    [MCD_UNSETTLE] MONEY NULL,
    [CASH_ADDITIONAL_MARGIN] MONEY NULL,
    [NSEFO_ADDITIONAL_MARGIN] MONEY NULL,
    [SECURITY_HOLDING] FLOAT NOT NULL,
    [SHARES_PAYOUT_VALUE] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCSCLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCSCLIENT]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCCS_DATE] DATETIME NULL,
    [FLAG] VARCHAR(1) NULL,
    [INACTIVE_DATE] DATETIME NULL
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
-- TABLE dbo.tblClientMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tblClientMaster]
(
    [VarClientCode] VARCHAR(50) NOT NULL,
    [VarClientName] VARCHAR(150) NULL,
    [VarClientAddr] VARCHAR(200) NULL,
    [VarClientCity] VARCHAR(50) NULL,
    [VarClientPhone] VARCHAR(15) NULL,
    [VarClientEmail] VARCHAR(150) NULL,
    [VarClientaltEmail] VARCHAR(200) NULL,
    [VarClientbccEmail] VARCHAR(150) NULL,
    [BitClientActive] BIT NULL,
    [VarClientPassword] VARCHAR(30) NULL,
    [DateClientUpdate] DATETIME NULL,
    [Varlocationname] VARCHAR(50) NULL,
    [VarInvalidEmail] VARCHAR(200) NULL,
    [VarInvalidAltEmail] VARCHAR(200) NULL,
    [VarInvalidBccEmail] VARCHAR(200) NULL,
    [Gatewaytouse] INT NULL
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
    [CQL_ID] BIGINT NOT NULL,
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
-- TABLE dbo.V2_CLASS_QUARTERLYLEDGER_11092013
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYLEDGER_11092013]
(
    [CQL_ID] BIGINT NOT NULL,
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
-- TABLE dbo.V2_CLASS_QUARTERLYLEDGER_12072013
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYLEDGER_12072013]
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
-- TABLE dbo.V2_CLASS_QUARTERLYSECLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYSECLEDGER]
(
    [SEGMENT] VARCHAR(5) NULL,
    [TRANSDATE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(5) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(255) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [CQTY] INT NULL,
    [DQTY] INT NULL,
    [SLIPNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [TRTYPE] VARCHAR(6) NULL,
    [REASON] VARCHAR(255) NULL,
    [BDPID] VARCHAR(8) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [TRANSDATEDT] DATETIME NULL,
    [FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_QUARTERLYSECLEDGER_11092013
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYSECLEDGER_11092013]
(
    [SEGMENT] VARCHAR(5) NULL,
    [TRANSDATE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(5) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(255) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [CQTY] INT NULL,
    [DQTY] INT NULL,
    [SLIPNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [TRTYPE] VARCHAR(6) NULL,
    [REASON] VARCHAR(255) NULL,
    [BDPID] VARCHAR(8) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [TRANSDATEDT] DATETIME NULL,
    [FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_QUARTERLYSECLEDGER_12072013
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_QUARTERLYSECLEDGER_12072013]
(
    [SEGMENT] VARCHAR(5) NULL,
    [TRANSDATE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(5) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(255) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [CQTY] INT NULL,
    [DQTY] INT NULL,
    [SLIPNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [TRTYPE] VARCHAR(6) NULL,
    [REASON] VARCHAR(255) NULL,
    [BDPID] VARCHAR(8) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [TRANSDATEDT] DATETIME NULL,
    [FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Hold_QUARTERLYSECLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Hold_QUARTERLYSECLEDGER]
(
    [SEGMENT] VARCHAR(5) NULL,
    [TRANSDATE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(5) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SCRIP_NAME] VARCHAR(255) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [CQTY] INT NULL,
    [DQTY] INT NULL,
    [SLIPNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [TRTYPE] VARCHAR(6) NULL,
    [REASON] VARCHAR(255) NULL,
    [BDPID] VARCHAR(8) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [TRANSDATEDT] DATETIME NULL,
    [FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_LOGIN_ERR_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_LOGIN_ERR_LOG]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOGIN_ID] VARCHAR(20) NULL,
    [LOGIN_PWD] VARCHAR(20) NULL,
    [IPADD] VARCHAR(20) NULL,
    [ERR_TYPE] VARCHAR(20) NULL,
    [LOGIN_TYPE] VARCHAR(10) NULL,
    [LOGIN_DT] DATETIME NULL
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
CREATE VIEW [dbo].[ACC_MULTICOMPANY]     
    
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
-- VIEW dbo.AUDIT_MULTICOMPANY_ALL_NEW
-- --------------------------------------------------


--SELECT TOP 1 * FROM AUDIT_MULTICOMPANY_ALL WHERE SEGMENT = 'MFSS'
CREATE VIEW [dbo].[AUDIT_MULTICOMPANY_ALL_NEW] 
AS

SELECT ACCOUNTSERVER, ACCOUNTDB, EXCHANGE, SEGMENT, SHAREDB FROM ACCOUNT..COMPANY_MASTER_SETTING

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_MULTICOMPANY
-- --------------------------------------------------


CREATE VIEW [DBO].[CLS_MULTICOMPANY]
AS
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,LICENSE,APPSHARE_ROOTFLDR_NAME,CATEGORY,PAYMENT_BANK,EXCHANGEGROUP 
FROM MULTICOMPANY
WHERE SEGMENT_DESCRIPTION <>'BSE F&O'

UNION ALL

SELECT '12798','ANGEL CAPITAL AND DEBT MARKET LTD.','NSE CAPITAL MARKET','NSE',	'MFSS',	'TM	', '12798',	'NSEMFSS',	'ABCSOMKTUATSVR1','196.1.115.241','BBO_FA',	'ABCSOMKTUATSVR1','196.1.115.241',
'NSEMFSS',	'ABCSOMKTUATSVR1','196.1.115.241',	0,	'1'	,	'1','0','CLSANGEL',	'ANGELCLASS'	,''	,	'CGI-BIN1'	,'EQUITY',NULL,'EQ'
FROM MULTICOMPANY_ALL
WHERE EXCHANGE ='NSE'

UNION ALL

SELECT '0612','ANGEL CAPITAL AND DEBT MARKET LTD.','BSE CAPITAL MARKET','BSE',	'MFSS',	'TM	', '0612',	'BSEMFSS',	'ABCSOMKTUATSVR1','196.1.115.241','BBO_FA',	'ABCSOMKTUATSVR1','196.1.115.241',
'BSEMFSS',	'ABCSOMKTUATSVR1','196.1.115.241',	0,	'1'	,	'1','0','CLSANGEL',	'ANGELCLASS'	,''	,	'CGI-BIN1'	,'EQUITY',NULL,'EQ'
FROM MULTICOMPANY_ALL
WHERE EXCHANGE ='BSE'

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_MULTICOMPANY_19122017
-- --------------------------------------------------



CREATE VIEW [dbo].[CLS_MULTICOMPANY_19122017]
AS
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,LICENSE,APPSHARE_ROOTFLDR_NAME,CATEGORY,PAYMENT_BANK,EXCHANGEGROUP 
FROM MULTICOMPANY
where SEGMENT_DESCRIPTION <>'BSE F&O'

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_OWNER_VW
-- --------------------------------------------------

    
CREATE VIEW [dbo].[CLS_OWNER_VW] AS   
SELECT 'NSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM MSAJAG.DBO.OWNER   
UNION ALL   
SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB_ab.DBO.OWNER   
--UNION ALL   
--SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL='',WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME='',COMPLIANCE_EMAIL='',COMPLIANCE_PHONE='',COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB.DBO.OWNER   
UNION ALL   
SELECT 'NSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NSEFO.DBO.FOOWNER   
UNION ALL   
SELECT 'BSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEFO.DBO.bfoowner   --select *from  CLS_OWNER_VW       
UNION ALL 
SELECT 'NCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
UNION ALL   
SELECT 'MCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
  
--OWNER_VW

GO

-- --------------------------------------------------
-- VIEW dbo.MULTICOMPANY_ALL
-- --------------------------------------------------

CREATE VIEW [dbo].[MULTICOMPANY_ALL] AS

SELECT BrokerId,CompanyName,Segment_Description,Exchange,Segment,MemberType,MemberCode,ShareDb,ShareServer,ShareIP,AccountDb,AccountServer,AccountIP,DefaultDb,DefaultDbServer,DefaultDbIP,DefaultClient,
PANGIR_No,primaryServer,Filler2,dbusername,dbpassword,
--License,
AppShare_RootFldr_Name
--,Category
--,PAYMENT_BANK,ExchangeGroup 
FROM MULTICOMPANY

UNION ALL

--SELECT *,'','','EQ' FROM MULTICOMPANY_ADDITIONAL

SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,
PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,
--LICENSE,
APPSHARE_ROOTFLDR_NAME
--, '','','EQ' 
FROM MULTICOMPANY_ADDITIONAL

GO

-- --------------------------------------------------
-- VIEW dbo.SCCSANNEXURE_A
-- --------------------------------------------------
CREATE VIEW SCCSANNEXURE_A      
AS      
SELECT PARTY_CODE,UNENCUMBERED_BAL,UNENCUMBERED_MARGIN,VALUE_SECURITIESTDAY,      
FUNDS_RETAINED=CASE WHEN UNENCUMBERED_BAL<0 AND UNENCUMBERED_BAL>-1000 THEN UNENCUMBERED_BAL*-1      
WHEN UNENCUMBERED_BAL<0 THEN (UNENCUMBERED_BAL+FUNDS_RELEASED)*-1      
ELSE 0 END,      
VALUE_SECURITIESRETAINED,FUNDS_RELEASED,SECURITIES_RELEASED,OTHERSEGMENTDEBIT,UPDATEDON      
 FROM mis.sccs_uat.dbo.SCCS_SUMMARY_RETAIN_RELEASE WITH (NOLOCK)

GO

-- --------------------------------------------------
-- VIEW dbo.SCCSANNEXURE_B
-- --------------------------------------------------

CREATE VIEW [dbo].[SCCSANNEXURE_B]        
AS        
SELECT PARTY_CODE,UNENCUMBERED_DEBITBAL,        
TDAY_FUNDSPAYIN_BSECM,T_1DAY_FUNDSPAYIN_BSECM,TDAY_SECURITIESPAYIN_BSECM,T_1DAY_SECURITESPAYIN_BSECM,TDAY_TURNOVER_BSECM,        
TDAY_FUNDSPAYIN_NSECM,T_1DAY_FUNDSPAYIN_NSECM,TDAY_SECURITIESPAYIN_NSECM,T_1DAY_SECURITESPAYIN_NSECM,TDAY_TURNOVER_NSECM,        
TDAY_FUNDSPAYIN_NSEFO,TDAY_MARGIN_NSEFO,        
TDAY_FUNDSPAYIN_NSX,TDAY_MARGIN_NSX,        
TDAY_FUNDSPAYIN_MCD,TDAY_MARGIN_MCD, OTHERSEGMENTDEBIT,ACCRUALAMT,     
UPDATEDON 

 FROM mis.sccs_uat.dbo.SCCS_SUMMARY_RETAIN_RELEASE WITH (NOLOCK)

GO

-- --------------------------------------------------
-- VIEW dbo.SCCSANNEXURE_C
-- --------------------------------------------------
/*SCCSANNEXURE_C*/ 
CREATE VIEW SCCSANNEXURE_C          
AS          
SELECT PARTY_CODE,SCRIP_NAME,ISIN,QUANTITY,CLOSING_RATE,HAIRCUT,VALUE=SUM(VALUE),SEGMENT=ISNULL(COLLATERAL,SEGMENT),UPDATEDON   
FROM mis.sccs_uat.dbo.SCCS_SHAREDETAILS WITH (NOLOCK) WHERE FLAG IN ('I','B')          
GROUP BY PARTY_CODE,SCRIP_NAME,ISIN,QUANTITY,CLOSING_RATE,HAIRCUT,SEGMENT,COLLATERAL,UPDATEDON

GO

-- --------------------------------------------------
-- VIEW dbo.SCCSANNEXURE_D
-- --------------------------------------------------
/*SCCSANNEXURE_D*/ 
CREATE VIEW SCCSANNEXURE_D        
AS        
SELECT PARTY_CODE,SCRIP_NAME,ISIN,QUANTITY,CLOSING_RATE,HAIRCUT,VALUE,SEGMENT=ISNULL(COLLATERAL,SEGMENT),UPDATEDON 
FROM mis.sccs_uat.dbo.SCCS_SHAREDETAILS WITH (NOLOCK) WHERE FLAG ='R'

GO

-- --------------------------------------------------
-- VIEW dbo.SCCSANNEXURE_E
-- --------------------------------------------------
/*SCCSANNEXURE_E*/ 
CREATE VIEW SCCSANNEXURE_E  
AS  
SELECT PARTY_CODE,SEGMENT,COLL_TYPE,BANK_CODE,FD_BGNO,MATURITY_DATE,FINALAMOUNT,UPDATEDON   
FROM mis.sccs_uat.dbo.SCCS_FDBG WITH (NOLOCK)

GO

-- --------------------------------------------------
-- VIEW dbo.VW_REPORTING_MULTICOMPANY
-- --------------------------------------------------

CREATE VIEW VW_REPORTING_MULTICOMPANY

AS

SELECT * FROM MULTICOMPANY WHERE PRIMARYSERVER = 1

GO

