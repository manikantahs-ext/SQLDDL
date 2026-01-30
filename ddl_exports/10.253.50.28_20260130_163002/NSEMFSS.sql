-- DDL Export
-- Server: 10.253.50.28
-- Database: NSEMFSS
-- Exported: 2026-01-30T16:31:04.453876

USE NSEMFSS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.ConvertDigit
-- --------------------------------------------------

CREATE Function [dbo].[ConvertDigit] ( @MyDigit char(1)) returns varchar(10) 
	as 
	Begin
	 declare @vOutput varchar(8)
	 set @vOutput =  Case @MyDigit
	            when '1' then 'One'
	            when '2' then 'Two'
	            when '3' then 'Three'
	            when '4' then 'Four'
	            when '5' then 'Five'
	            when '6' then 'Six'
	            when '7' then 'Seven'
	            when '8' then 'Eight'
	            when '9' then 'Nine'
        	    Else '' end 
      	Return (@vOutPut)
	End

GO

-- --------------------------------------------------
-- FUNCTION dbo.ConvertHundreds
-- --------------------------------------------------
/*
Print dbo.ConvertHundreds('121')
*/
CREATE Function [dbo].[ConvertHundreds](@MyNumber varchar(3)) returns varchar(200)
as
Begin
	Declare @Result varchar(200)
	set @Result = ''
	-- Exit if there is nothing to convert.
	If convert(int,@MyNumber) <> 0 
	Begin
		--' Append leading zeros to number.
		set @MyNumber = Right('000' + @MyNumber, 3)
		--' Do we have a hundreds place digit to convert?
		If Left(@MyNumber, 1) <> '0' 
		Begin
			set @Result = dbo.ConvertDigit(Left(@MyNumber, 1)) + ' Hundred '
		End
		
		--' Do we have a tens place digit to convert?
		If SubString(@MyNumber, 2, 1) <> '0' 
		Begin
			set @Result = @Result + dbo.ConvertTens(SubString(@MyNumber, 2,2))
		End
		Else
		Begin
			--' If not, then convert the ones place digit.
			set @Result = @Result +  dbo.ConvertDigit(SubString(@MyNumber, 3,1))
		end
		
	End
	return (@Result)
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.ConvertIntoIndianCurEng
-- --------------------------------------------------
/*
Print dbo.ConvertIntoIndianCurEng('500.51')
*/

CREATE Function [dbo].[ConvertIntoIndianCurEng]( @MyNumber varchar(200)) returns varchar(200)
as
Begin
	Declare @Temp varchar(200),
	@Dollars varchar(200), @Cents varchar(100),
	@DecimalPlace int, @Count int , @Return varchar(200)
	
	--' Convert MyNumber to a string, trimming extra spaces.
	set @MyNumber = ltrim(rtrim(@mynumber))
	
	--' Find decimal place.
	set @DecimalPlace = CHARINDEX ('.',@MyNumber)

	set @Cents = ''
	set @Dollars = ''

	--' If we find decimal place...
	If @DecimalPlace > 0 
	Begin
		--' Convert cents
		set @Temp = Left(substring(@MyNumber, @DecimalPlace + 1,2) + '00', 2)
		set @Cents = dbo.ConvertTens(@Temp)
		--' Strip off cents from remainder to convert.
		set @MyNumber = Left(@MyNumber, @DecimalPlace - 1)
	End 

	

	set @Count = 1
	set @Temp = dbo.ConvertHundreds(Right(@MyNumber, 3))


	If @Temp <> '' 
		set @Dollars = @Temp + dbo.Place(@Count) + @Dollars
	
	If Len(@MyNumber) > 3 
		--' Remove last 3 converted digits from MyNumber.
		set @MyNumber = Left(@MyNumber, Len(@MyNumber) - 3)
	Else
		set @MyNumber = ''

	set @Count = @Count + 1

	While @MyNumber <> ''
	Begin
		--' Convert last 2 digits of MyNumber to Indian Rs.
		set @Temp = dbo.ConvertHundreds(Right(@MyNumber, 2))
		If @Temp <> '' 
			set @Dollars = @Temp + dbo.Place(@Count) + @Dollars

		If Len(@MyNumber) > 2 
			--' Remove last 2 converted digits from MyNumber.
			set @MyNumber = Left(@MyNumber, Len(@MyNumber) - 2)
		Else
			set @MyNumber = ''
		set @Count = @Count + 1
	end
	
	--' Clean up Rupees.

	set @Dollars = Case @Dollars
			when '' then 'Zero '
			when 'One' then 'One '
			Else @Dollars + ''
			end 

	
	--' Clean up cents.
	set @Cents  = Case @Cents
			when '' then '' 	--'Cents = " And zero Paise"
			when 'One' then ' And Paisa One '
			Else ' And ' +  'Paise ' + @Cents 
			end 
	

	set @Return =  @Dollars + @Cents + ' Only'
	Return (@Return) 
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.ConvertTens
-- --------------------------------------------------

/*
Print dbo.ConvertTens(13)
*/
CREATE Function [dbo].[ConvertTens] (@MyTens char(2)) returns varchar(15)
  as 
  Begin
  Declare @Result varchar(15)
  
  -- Is value between 10 and 19?
	If Left(@MyTens, 1) = 1 
	Begin
		set  @Result = Case convert(int,(@MyTens))
		when 10 then 'Ten'
		when 11 then 'Eleven'
		when 12 then 'Twelve'
		when 13 then 'Thirteen'
		when 14 then 'Fourteen'
		when 15 then 'Fifteen'
		when 16 then 'Sixteen'
		when 17 then 'Seventeen'
		when 18 then 'Eighteen'
		when 19 then 'Nineteen'
		Else ''
		end 
	End
	Else
	Begin
		--' .. otherwise it's between 20 and 99.
		set  @Result = Case convert(int,Left(@MyTens, 1))
		when 2 then 'Twenty '
		when 3 then 'Thirty '
		when 4 then 'Forty '
		when 5 then 'Fifty '
		when 6 then 'Sixty '
		when 7 then 'Seventy '
		when 8 then 'Eighty '
		when 9 then 'Ninety '
		Else ''
		end 
		set @Result = @Result + dbo.ConvertDigit(Right(@MyTens, 1))
	End


    -- Convert ones place digit.
    
  Return (@Result)
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_SERIES_NAME
-- --------------------------------------------------
CREATE  FUNCTION [dbo].[FN_SERIES_NAME] (@DIV_REINVEST_FLAG VARCHAR(3) ) 
RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @SERIES_NAME VARCHAR(20)
	SELECT @SERIES_NAME = CASE 
							WHEN @DIV_REINVEST_FLAG = 'N' THEN ' - Dividend Payout'
							WHEN @DIV_REINVEST_FLAG = 'Z' THEN ' - Dividend ReInvest' 
							ELSE ''
						  END

	RETURN @SERIES_NAME

END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING
-- --------------------------------------------------
  
create  FUNCTION [dbo].[FUN_SPLITSTRING](  
                @SPLITSTRING VARCHAR(8000),  
                @DELIMITER   VARCHAR(3))  
RETURNS @SPLITTED TABLE (  
    [SNO] [INT] IDENTITY(1,1) NOT NULL,   
    [SPLITTED_VALUE] [VARCHAR](100) NOT NULL)  
  
AS  
  
/* Split the String and get splitted values in the result-set. Delimiter upto 3 characters long can be used for splitting */  
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
-- FUNCTION dbo.Place
-- --------------------------------------------------

CREATE Function [dbo].[Place](@Count as int ) Returns varchar(15)
as 
Begin
	Declare @Return varchar(15)
	set @Return = case @Count
			when 2 then ' Thousand '
			when 3 then ' Lakhs '
			when 4 then ' Crores '
			when 5 then ' Arab '
			else ''
			end
	Return(@Return)
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.UFN_LOGINCHECK
-- --------------------------------------------------
CREATE FUNCTION [dbo].[UFN_LOGINCHECK]      
(      
	@EXCHANGE UDTEXCHANGE = '',      
	@SEGMENT UDTSEGMENT = '',      
	@STATUSID VARCHAR(25),      
	@STATUSNAME VARCHAR(25),      
	@SEARCHWHAT VARCHAR(20) = 'PARTY',      
	@FROMCODE VARCHAR(20) = '0',      
	@TOCODE VARCHAR(20) = 'ZZZZZZZZZZ',      
	@CLTYPE VARCHAR(3) = ''      
)      
/*      
SELECT CODE, SHORT_NAME FROM UFN_LOGINCHECK('NSE', 'CAPITAL', 'BROKER', 'BROKER', 'party', '100', 'Z','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', 'BROKER', 'BROKER', 'party', '0', 'a','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'FAMILY', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', 'BRANCH', 'HO', 'TRADER', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'BRANCH', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'AREA', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'REGION', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', '', '0', 'zz','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'GL', '0', 'Z','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'cb', '0', 'Z','')      
SELECT * FROM UFN_LOGINCHECK('NSE', 'CAPITAL', '118522', 'BROKER', 'BB', '0', 'Z','')      
*/      
RETURNS      
@CLIENTLOGIN TABLE (      
 [CODE] VARCHAR(50) NOT NULL  DEFAULT '', -- PRIMARY KEY CLUSTERED,      
 [SHORT_NAME] UDTACNAME NOT NULL DEFAULT '',      
 [LONG_NAME] UDTACNAME NOT NULL DEFAULT '',      
 [L_ADDRESS1] VARCHAR(50) NOT NULL DEFAULT '',    
 [L_ADDRESS2] VARCHAR(50) NOT NULL DEFAULT '',    
 [L_ADDRESS3] VARCHAR(50) NOT NULL DEFAULT '',    
 [L_CITY] VARCHAR(35) NOT NULL DEFAULT '',    
 [L_STATE] VARCHAR(50) NOT NULL DEFAULT '',    
 [L_NATION] VARCHAR(50) NOT NULL DEFAULT '',    
 [L_ZIP] VARCHAR(6) NOT NULL DEFAULT '',    
 [FAX] VARCHAR(20) NOT NULL DEFAULT '',    
 [RES_PHONE1] VARCHAR(15) NOT NULL DEFAULT '',    
 [RES_PHONE2] VARCHAR(15) NOT NULL DEFAULT '',    
 [MOBILE_PAGER] VARCHAR(50) NOT NULL DEFAULT '',    
 [PAN_GIR_NO] VARCHAR(10) NOT NULL DEFAULT '',    
 [EMAIL] VARCHAR(50) NOT NULL DEFAULT '',    
 [CL_TYPE] VARCHAR(3) NOT NULL DEFAULT '',   
 [FAMILY] [UDTPARTYCODE] NOT NULL DEFAULT '',      
 [TRADER] [UDTPARTYCODE] NOT NULL DEFAULT '',      
 [SUB_BROKER] UDTREMISIERCODE NOT NULL DEFAULT '',      
 [BRANCH_CD] [UDTBRANCHCODE] NOT NULL DEFAULT '',      
 [AREA] [UDTAREACODE] NOT NULL DEFAULT '',      
 [REGION] [UDTREGIONCODE] NOT NULL DEFAULT '',
 [BANK_NAME] VARCHAR(50) NOT NULL DEFAULT '',
 [ACC_NUM] VARCHAR(40) NOT NULL DEFAULT ''
 ) 
     
AS      
BEGIN   
  
IF @FROMCODE = '' OR @FROMCODE = 'ALL' OR @FROMCODE = '%'      
 BEGIN      
  SET @FROMCODE = '0'      
 END      
 IF @TOCODE = '' OR @TOCODE = 'ALL' OR @FROMCODE = '%'      
 BEGIN      
  SET @TOCODE = 'ZZZZZZZZZZ'      
 END  
 -- ======================================= PARTY ======================================      
 IF @SEARCHWHAT = 'PARTY'      
 BEGIN      
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_STATE,    
      L_NATION, L_ZIP, FAX, RES_PHONE1, RES_PHONE2, MOBILE_PAGER, PAN_GIR_NO, EMAIL, CL_TYPE, FAMILY, TRADER, SUB_BROKER, BRANCH_CD, AREA, REGION, BANK_NAME, ACC_NUM)       
  SELECT CL_CODE, SHORT_NAME, LONG_NAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_STATE,    
      L_NATION, L_ZIP, FAX, RES_PHONE1, RES_PHONE2, MOBILE_PAGER, PAN_GIR_NO, EMAIL, CL_TYPE, FAMILY, TRADER, SUB_BROKER, BRANCH_CD, AREA, REGION, BANK_NAME, ACC_NO     
  FROM CLIENT1 (NOLOCK)      
  WHERE @STATUSNAME = CASE @STATUSID WHEN 'FAMILY' THEN FAMILY      
   WHEN 'TRADER' THEN TRADER      
   WHEN 'SUBBROKER' THEN SUB_BROKER      
   WHEN 'BRANCH' THEN BRANCH_CD      
   WHEN 'AREA' THEN AREA      
   WHEN 'REGION' THEN REGION      
   ELSE 'BROKER' END      
   AND CL_CODE BETWEEN @FROMCODE AND @TOCODE
   AND CL_TYPE = CASE WHEN @CLTYPE = '' OR @CLTYPE = '%' OR @CLTYPE = 'ALL' THEN CL_TYPE ELSE @CLTYPE END      
  ORDER BY CL_CODE, SHORT_NAME      
 END      
 -- ======================================== PARTY ENDS ===============================      
      
 -- ==================================== FAMILY =======================================      
 ELSE IF @SEARCHWHAT = 'FAMILY'       
 BEGIN      
  IF @STATUSID = 'CLIENT'      
   RETURN       
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
  SELECT CL_CODE, SHORT_NAME, LONG_NAME      
  FROM CLIENT1 (NOLOCK)      
  WHERE @STATUSNAME = CASE @STATUSID WHEN 'FAMILY' THEN FAMILY      
   WHEN 'TRADER' THEN TRADER      
   WHEN 'SUBBROKER' THEN SUB_BROKER      
   WHEN 'BRANCH' THEN BRANCH_CD      
   WHEN 'AREA' THEN AREA      
   WHEN 'REGION' THEN REGION      
   ELSE 'BROKER' END      
   AND FAMILY BETWEEN @FROMCODE and @TOCODE      
   AND CL_TYPE = CASE WHEN @CLTYPE = '' OR @CLTYPE = '%' OR @CLTYPE = 'ALL' THEN CL_TYPE ELSE @CLTYPE END      
  ORDER BY CL_CODE, SHORT_NAME      
 END      
 -- ==================================== FAMILY ENDS=======================================      
      
 -- ==================================== TRADER ===========================================      
 ELSE IF @SEARCHWHAT = 'TRADER'       
 BEGIN      
  IF @STATUSID = 'CLIENT' OR @STATUSID = 'FAMILY'      
   RETURN       
  IF @STATUSID = 'TRADER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT BRANCH_CD, SHORT_NAME, LONG_NAME      
   FROM BRANCHES (NOLOCK)      
   WHERE BRANCH_CD = @STATUSNAME--BETWEEN @FROMCODE and @TOCODE      
   ORDER BY BRANCH_CD, SHORT_NAME      
  END      
      
  ELSE IF @STATUSID = 'SUB_BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.SHORT_NAME, B.SHORT_NAME, B.LONG_NAME      
   FROM BRANCHES B (NOLOCK), SUBBROKERS S (NOLOCK)      
   WHERE B.BRANCH_CD = S.BRANCH_CODE      
    AND B.SHORT_NAME BETWEEN @FROMCODE AND @TOCODE      
    AND S.SUB_BROKER = @STATUSNAME      
   ORDER BY B.SHORT_NAME      
  END      
      
  ELSE IF @STATUSID = 'BRANCH'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.SHORT_NAME, B.SHORT_NAME, B.LONG_NAME      
   FROM BRANCHES B (NOLOCK), BRANCH B1 (NOLOCK)      
   WHERE B.BRANCH_CD = B1.BRANCH_CODE      
    AND B.SHORT_NAME BETWEEN @FROMCODE and @TOCODE      
    AND B1.BRANCH_CODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'AREA'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.SHORT_NAME, B.SHORT_NAME, B.LONG_NAME      
   FROM BRANCHES B (NOLOCK), AREA A (NOLOCK)      
   WHERE B.BRANCH_CD = A.BRANCH_CODE      
    AND B.SHORT_NAME BETWEEN @FROMCODE and @TOCODE      
    AND A.AREACODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'REGION'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.SHORT_NAME, B.SHORT_NAME, B.LONG_NAME      
   FROM BRANCHES B (NOLOCK), REGION R (NOLOCK)      
   WHERE B.BRANCH_CD = R.BRANCH_CODE      
    AND B.SHORT_NAME BETWEEN @FROMCODE and @TOCODE      
    AND R.REGIONCODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT SHORT_NAME, SHORT_NAME, LONG_NAME      
   FROM BRANCHES (NOLOCK)      
   WHERE SHORT_NAME BETWEEN @FROMCODE AND @TOCODE      
  END      
 END      
 -- ==================================== TRADER ENDS =======================================      
      
 -- ==================================== SUB BROKER ========================================      
 ELSE IF @SEARCHWHAT = 'SUB_BROKER'       
 BEGIN      
  IF @STATUSID = 'CLIENT' OR @STATUSID = 'FAMILY'      
   RETURN      
  IF @STATUSID = 'TRADER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT S.SUB_BROKER, S.NAME, S.NAME      
   FROM BRANCHES B (NOLOCK), SUBBROKERS S (NOLOCK)      
   WHERE B.BRANCH_CD = S.BRANCH_CODE      
    AND S.SUB_BROKER BETWEEN @FROMCODE AND @TOCODE      
    AND B.SHORT_NAME = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'SUB_BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT SUB_BROKER, NAME, NAME      
   FROM SUBBROKERS (NOLOCK)      
   WHERE SUB_BROKER = @STATUSNAME--BETWEEN @FROMCODE and @TOCODE      
  END      
      
  ELSE IF @STATUSID = 'BRANCH'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT S.SUB_BROKER, S.NAME, S.NAME      
   FROM SUBBROKERS S (NOLOCK), BRANCH B (NOLOCK)      
   WHERE S.BRANCH_CODE = B.BRANCH_CODE      
    AND S.SUB_BROKER BETWEEN @FROMCODE and @TOCODE      
    AND B.BRANCH_CODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'AREA'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT S.SUB_BROKER, S.NAME, S.NAME      
   FROM SUBBROKERS S (NOLOCK), AREA A (NOLOCK)      
   WHERE S.BRANCH_CODE = A.BRANCH_CODE      
    AND S.SUB_BROKER BETWEEN @FROMCODE and @TOCODE      
    AND A.AREACODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'REGION'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT S.SUB_BROKER, S.NAME, S.NAME      
   FROM SUBBROKERS S (NOLOCK), REGION R (NOLOCK)      
   WHERE S.BRANCH_CODE = R.BRANCH_CODE      
    AND S.SUB_BROKER BETWEEN @FROMCODE and @TOCODE      
    AND R.REGIONCODE = @STATUSNAME      
  END      
      
 ELSE IF @STATUSID = 'BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT SUB_BROKER, NAME, NAME      
   FROM SUBBROKERS (NOLOCK)      
   WHERE SUB_BROKER BETWEEN @FROMCODE AND @TOCODE      
  END      
 END      
 -- ==================================== SUB BROKER ENDS ===================================      
      
 -- ==================================== BRANCH ============================================      
 ELSE IF @SEARCHWHAT = 'BRANCH'       
 BEGIN      
  IF @STATUSID = 'CLIENT' OR @STATUSID = 'FAMILY' OR @STATUSID = 'TRADER' OR @STATUSID = 'SUB_BROKER'      
   RETURN      
  IF @STATUSID = 'BRANCH'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT BRANCH_CODE, BRANCH, LONG_NAME      
   FROM BRANCH (NOLOCK)      
   WHERE BRANCH_CODE = @STATUSNAME--BETWEEN @FROMCODE and @TOCODE      
  END      
      
  ELSE IF @STATUSID = 'AREA'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.BRANCH_CODE, B.BRANCH, B.LONG_NAME      
   FROM BRANCH B (NOLOCK), AREA A (NOLOCK)      
   WHERE B.BRANCH_CODE = A.BRANCH_CODE      
    AND B.BRANCH_CODE BETWEEN @FROMCODE and @TOCODE      
    AND A.AREACODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'REGION'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT B.BRANCH_CODE, B.BRANCH, B.LONG_NAME      
   FROM BRANCH B (NOLOCK), REGION R (NOLOCK)      
   WHERE B.BRANCH_CODE = R.BRANCH_CODE      
    AND B.BRANCH_CODE BETWEEN @FROMCODE and @TOCODE      
    AND R.REGIONCODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT BRANCH_CODE, BRANCH, LONG_NAME      
   FROM BRANCH (NOLOCK)      
   WHERE BRANCH_CODE BETWEEN @FROMCODE AND @TOCODE      
  END      
 END      
 -- ==================================== BRANCH ENDS ===================================      
      
 -- ==================================== AREA ============================================      
 ELSE IF @SEARCHWHAT = 'AREA'       
 BEGIN      
  IF @STATUSID = 'CLIENT' OR @STATUSID = 'FAMILY' OR @STATUSID = 'TRADER' OR @STATUSID = 'SUB_BROKER' OR @STATUSID = 'BRANCH'      
   RETURN      
  IF @STATUSID = 'AREA'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT AREACODE, DESCRIPTION, DESCRIPTION      
   FROM AREA (NOLOCK)      
   WHERE AREACODE = @STATUSNAME--BETWEEN @FROMCODE and @TOCODE      
  END      
      
  ELSE IF @STATUSID = 'REGION'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT A.AREACODE, A.DESCRIPTION, A.DESCRIPTION      
   FROM AREA A (NOLOCK), REGION R (NOLOCK)      
   WHERE A.BRANCH_CODE = R.BRANCH_CODE      
    AND A.AREACODE BETWEEN @FROMCODE and @TOCODE      
    AND R.REGIONCODE = @STATUSNAME      
  END      
      
  ELSE IF @STATUSID = 'BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT AREACODE, DESCRIPTION, DESCRIPTION      
   FROM AREA (NOLOCK)      
   WHERE AREACODE BETWEEN @FROMCODE AND @TOCODE      
  END      
 END      
 -- ==================================== AREA ENDS ===================================      
      
 -- ==================================== REGION ============================================      
 ELSE IF @SEARCHWHAT = 'REGION'       
 BEGIN      
  IF @STATUSID = 'CLIENT' OR @STATUSID = 'FAMILY' OR @STATUSID = 'TRADER' OR @STATUSID = 'SUB_BROKER' OR @STATUSID = 'BRANCH' OR @STATUSID = 'AREA'      
   RETURN      
  IF @STATUSID = 'REGION'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT REGIONCODE, DESCRIPTION, DESCRIPTION      
   FROM REGION (NOLOCK)      
   WHERE REGIONCODE = @STATUSNAME--BETWEEN @FROMCODE and @TOCODE      
  END      
      
  ELSE IF @STATUSID = 'BROKER'      
  BEGIN      
   INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
   SELECT REGIONCODE, DESCRIPTION, DESCRIPTION      
   FROM REGION (NOLOCK)      
   WHERE REGIONCODE BETWEEN @FROMCODE AND @TOCODE      
  END      
 END      
 -- ==================================== REGION ENDS ===================================      
      
 -- ==================================== General Ledger ================================      
 ELSE IF @SEARCHWHAT = 'GL'       
 BEGIN      
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
  SELECT CLTCODE, ACNAME, LONGNAME      
  FROM ACMAST (NOLOCK)      
  WHERE       
  EXCHANGE = @EXCHANGE      
  AND SEGMENT = @SEGMENT      
  AND ACCAT IN (3, 14, 103)      
  AND (BRANCHCODE = 'ALL' OR      
   BRANCHCODE = CASE @STATUSID WHEN 'BROKER' THEN BRANCHCODE      
       WHEN 'BRANCH' THEN @STATUSNAME      
       ELSE '' END)      
  AND CLTCODE BETWEEN @FROMCODE AND @TOCODE      
  ORDER BY CLTCODE, ACNAME      
 END      
      
 -- ==================================== General Ledger End ============================      
      
 -- ==================================== Cash Book ================================      
 ELSE IF @SEARCHWHAT = 'CB'       
 BEGIN      
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
  SELECT CLTCODE, ACNAME, LONGNAME      
  FROM ACMAST (NOLOCK)      
  WHERE       
  EXCHANGE = @EXCHANGE      
  AND SEGMENT = @SEGMENT      
  AND ACCAT = 1      
  AND (BRANCHCODE = 'ALL' OR      
   BRANCHCODE = CASE @STATUSID WHEN 'BROKER' THEN BRANCHCODE      
       WHEN 'BRANCH' THEN @STATUSNAME      
       ELSE '' END)      
  AND CLTCODE BETWEEN @FROMCODE AND @TOCODE      
  ORDER BY CLTCODE, ACNAME      
 END      
      
 -- ==================================== Cash Book End ============================      
      
 -- ==================================== Bank Book ================================      
 ELSE IF @SEARCHWHAT = 'BB'       
 BEGIN      
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
  SELECT CLTCODE, ACNAME, LONGNAME      
  FROM ACMAST (NOLOCK)      
  WHERE       
  EXCHANGE = @EXCHANGE      
  AND SEGMENT = @SEGMENT      
  AND ACCAT = 2      
  AND (BRANCHCODE = 'ALL' OR      
   BRANCHCODE = CASE @STATUSID WHEN 'BROKER' THEN BRANCHCODE      
       WHEN 'BRANCH' THEN @STATUSNAME      
       ELSE '' END)      
  AND CLTCODE BETWEEN @FROMCODE AND @TOCODE      
  ORDER BY CLTCODE, ACNAME      
 END      
      
 -- ==================================== Bank Book End ============================      
      
 -- ==================================== Client Type ================================      
 ELSE IF @SEARCHWHAT = 'CLTYPE'       
 BEGIN      
  INSERT INTO @CLIENTLOGIN(CODE, SHORT_NAME, LONG_NAME)      
  SELECT LTRIM(RTRIM(CL_TYPE)), LTRIM(RTRIM(DESCRIPTION)), LTRIM(RTRIM(DESCRIPTION))      
  FROM CLIENTTYPE (NOLOCK)      
  WHERE       
  CL_TYPE BETWEEN @FROMCODE AND @TOCODE      
  ORDER BY CL_TYPE, DESCRIPTION      
 END      
      
 -- ==================================== Client Type End ============================      
  RETURN      
END      
/*      
SELECT TOP 5 * FROM CLIENT_DETAILS --WHERE FAMILY = '00000031'      
SELECT TOP 5 * FROM CLIENT1      
SELECT TOP 5 * FROM CLIENT2      
SELECT  TOP 5 * FROM BRANCH      
SELECT  TOP 5 * FROM BRANCHES      
SELECT TOP 5 * FROM SUBBROKERS      
SELECT TOP 5 * FROM AREA      
SELECT TOP 5 * FROM REGION      
SELECT TOP 5 * FROM ACMAST  WHERE  ACCAT = 3      
*/

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branch] ON [dbo].[BRANCH] ([BRANCH], [BRANCH_CODE], [LONG_NAME])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Brcode] ON [dbo].[BRANCH] ([BRANCH_CODE], [BRANCH])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCHES
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branches] ON [dbo].[BRANCHES] ([SHORT_NAME], [BRANCH_CD], [COM_PERC])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCHES
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branchshort] ON [dbo].[BRANCHES] ([BRANCH_CD], [SHORT_NAME], [COM_PERC])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENT_DETAIL_SETTING
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXTYPE] ON [dbo].[CLIENT_DETAIL_SETTING] ([OBJNAME])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENTSTATUS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxSt] ON [dbo].[CLIENTSTATUS] ([CL_STATUS])

GO

-- --------------------------------------------------
-- INDEX dbo.clienttype
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxType] ON [dbo].[clienttype] ([Cl_Type])

GO

-- --------------------------------------------------
-- INDEX dbo.IMP_FilePath
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxFl] ON [dbo].[IMP_FilePath] ([File_Type])

GO

-- --------------------------------------------------
-- INDEX dbo.MFSS_CLMST_VALUES
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXTYPE] ON [dbo].[MFSS_CLMST_VALUES] ([V_TYPE])

GO

-- --------------------------------------------------
-- INDEX dbo.STATE_MASTER
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxstate] ON [dbo].[STATE_MASTER] ([State])

GO

-- --------------------------------------------------
-- INDEX dbo.SUBBROKERS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxSb] ON [dbo].[SUBBROKERS] ([SUB_BROKER], [BRANCH_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.SUBBROKERS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [indSbBrok] ON [dbo].[SUBBROKERS] ([SUB_BROKER])

GO

-- --------------------------------------------------
-- INDEX dbo.TblAdmin
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblAdmin] ([Fldauto_Admin])

GO

-- --------------------------------------------------
-- INDEX dbo.TblAdminconfig
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblAdminconfig] ([Fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TblCategory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [categoryidx] ON [dbo].[TblCategory] ([Fldcategorycode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblCatmenu
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblCatmenu] ([Fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCLASSUSERLOGINS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDXLOGIN] ON [dbo].[TBLCLASSUSERLOGINS] ([FLDUSERNAME], [FLDSESSION], [FLDIPADDRESS])

GO

-- --------------------------------------------------
-- INDEX dbo.TblMenuHead
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxMenu] ON [dbo].[TblMenuHead] ([Fldmenucode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblPradnyausers
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxUser] ON [dbo].[TblPradnyausers] ([Fldauto], [Fldadminauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReportgrp
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpr] ON [dbo].[TblReportgrp] ([Fldreportgrp], [Fldmenugrp])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReports
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxReport] ON [dbo].[TblReports] ([Fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReports_Blocked
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpt] ON [dbo].[TblReports_Blocked] ([fldadminauto], [Fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlGlobals
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[tblUserControlGlobals] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [AutoIDx] ON [dbo].[tblUserControlMaster] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [UserIdidx] ON [dbo].[tblUserControlMaster] ([FLDUSERID])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster_Jrnl
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[tblUserControlMaster_Jrnl] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_Login_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxUser] ON [dbo].[V2_Login_Log] ([AddDt], [UserId])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxReport] ON [dbo].[V2_Report_Access_Log] ([RepPath])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCH
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCH] ADD CONSTRAINT [Pk_Branch] PRIMARY KEY ([BRANCH_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCHES
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCHES] ADD CONSTRAINT [Pk_Branches] PRIMARY KEY ([SHORT_NAME])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Delaccbalance
-- --------------------------------------------------
ALTER TABLE [dbo].[Delaccbalance] ADD CONSTRAINT [PK_Delaccbalance] PRIMARY KEY ([Cltcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Demattrans
-- --------------------------------------------------
ALTER TABLE [dbo].[Demattrans] ADD CONSTRAINT [PK_demattrans] PRIMARY KEY ([Sno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_BROKERAGE_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_BROKERAGE_MASTER] ADD CONSTRAINT [PK_MFSS_BROKERAGE_MASTER] PRIMARY KEY ([PARTY_CODE], [FROMDATE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_CLIENT_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_CLIENT_NEW] ADD CONSTRAINT [PK_MFSS_CLIENT_NEW] PRIMARY KEY ([PARTY_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_DPMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_DPMASTER] ADD CONSTRAINT [PK_MFSS_DPMASTER] PRIMARY KEY ([PARTY_CODE], [DP_TYPE], [DPID], [CLTDPID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_FUNDS_OBLIGATION
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_FUNDS_OBLIGATION] ADD CONSTRAINT [PK_MFSS_FUNDS_OBLIGATION] PRIMARY KEY ([ORDER_DATE], [ORDER_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_NAV
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_NAV] ADD CONSTRAINT [PK_MFSS_NAV] PRIMARY KEY ([NAV_DATE], [SCRIP_CD])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_123
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_123] ADD CONSTRAINT [PK_MFSS_ORDER] PRIMARY KEY ([ORDER_DATE], [ORDER_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_ALLOT_CONF
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_ALLOT_CONF] ADD CONSTRAINT [PK_MFSS_ORDER_ALLOT_CONF] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_STATUS
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_STATUS] ADD CONSTRAINT [PK_MFSS_ORDER_STATUS] PRIMARY KEY ([SETT_NO], [SETT_TYPE], [ORDER_NO], [ORDER_DATE], [SCRIP_CD])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_TMP
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_TMP] ADD CONSTRAINT [PK_MFSS_ORDER_TMP] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_SETTLEMENT
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_SETTLEMENT] ADD CONSTRAINT [PK_MFSS_SETTLEMENT1] PRIMARY KEY ([ORDER_NO], [SETT_NO], [SETT_TYPE], [SCRIP_CD], [SERIES], [ORDER_DATE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Multicltid
-- --------------------------------------------------
ALTER TABLE [dbo].[Multicltid] ADD CONSTRAINT [PK_Multicltid_1] PRIMARY KEY ([Party_Code], [Cltdpno], [Dpid])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SETT_MST_ORG
-- --------------------------------------------------
ALTER TABLE [dbo].[SETT_MST_ORG] ADD CONSTRAINT [PK_SETT_MST] PRIMARY KEY ([Sett_Type], [Sett_No])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TblPradnyausers
-- --------------------------------------------------
ALTER TABLE [dbo].[TblPradnyausers] ADD CONSTRAINT [PK_tblpradnyausers] PRIMARY KEY ([Fldauto])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.add_area
-- --------------------------------------------------
CREATE PROC [dbo].[add_area]
     @AREA_CODE  VARCHAR(20),
     @DESC       VARCHAR(50),
     @CODE_BRAN  VARCHAR(500)
AS
/*
BEGIN TRAN
ROLLBACK TRAN
exec add_area 'HO','Navi Mumbai','ABC,CHE01,HO'
*/
BEGIN 
		DECLARE 
			@ROWPOS AS INT,
			@ROWPOS_MAIN AS INT,
			@BRDATA AS VARCHAR(500),
			@INSTR AS VARCHAR(500),
			@EXISTSTR AS VARCHAR(500),
			@SHAREDBLST_VAR AS VARCHAR(500),
			@EXCH_SECH_VAR AS VARCHAR(500),
			@SHAREDBLST AS VARCHAR(500),
			@EXCH_SEG AS VARCHAR(500),
			@STRSQL AS VARCHAR(8000),
			@@BRANCHCOUNT AS INT
			
		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		CREATE TABLE #TEMMP(EXCH VARCHAR(800),SUCCESS VARCHAR(8000),EXIST VARCHAR(8000))
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))


		SET @ROWPOS_MAIN = 1 
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				BEGIN  
				 BREAK  
				END  

				 SET @INSTR = ''
				 SET @EXISTSTR = ''
				 SET @ROWPOS = 1
				 SET @STRSQL=''
				 
				WHILE 1 = 1  
				  BEGIN  
				   SET @BRDATA = LTRIM(RTRIM(.DBO.PIECE(@CODE_BRAN, ',', @ROWPOS)))  
				  
				   IF @BRDATA IS NULL OR @BRDATA = ''  
					BEGIN  
					 BREAK  
					END  

--					SET @STRSQL="SELECT COUNT(*) FROM "+ @SHAREDBLST_VAR + "..AREA WHERE AREACODE = '"+ @AREA_CODE +"' AND BRANCH_CODE = '"+ @BRDATA +"'"
--					INSERT INTO #TBLCOUNT
--					EXEC (@STRSQL)
--					
--					IF (SELECT A FROM #TBLCOUNT)= 0
					 BEGIN
						SET @STRSQL ="DELETE FROM "+ @SHAREDBLST_VAR + "..AREA WHERE AREACODE = '"+ @AREA_CODE +"' AND BRANCH_CODE = '"+ @BRDATA +"'"
						EXEC (@STRSQL)
						SET @STRSQL=''
						SET @STRSQL =" INSERT INTO "+ @SHAREDBLST_VAR + "..AREA (AREACODE,DESCRIPTION,BRANCH_CODE)"
						SET @STRSQL =@STRSQL + " VALUES('"+@AREA_CODE+"','"+@DESC+"','"+@BRDATA+"')"
						EXEC (@STRSQL)
						SET @STRSQL=''
						SET @STRSQL=" UPDATE "+ @SHAREDBLST_VAR + "..AREA  SET DESCRIPTION= '"+@DESC+"' WHERE AREACODE = '"+ @AREA_CODE +"'"
						EXEC (@STRSQL)
						SET @INSTR  = @INSTR  + @BRDATA  +','
					 END 
--					ELSE 
--					 BEGIN
--						SET @EXISTSTR = @EXISTSTR + @BRDATA + ',' 	
--				     END
					DELETE FROM #TBLCOUNT 

					SET @ROWPOS = @ROWPOS + 1
				  END
				SET @INSTR = @INSTR + '~'
				SET @EXISTSTR = @EXISTSTR + '~'
				INSERT INTO #TEMMP
				SELECT @EXCH_SECH_VAR ,@INSTR ,@EXISTSTR 

				SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 

		END 

SELECT EXCH,REPLACE(REPLACE(SUCCESS,',~',''),'~','') AS SUCCESS FROM #TEMMP
DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.add_region
-- --------------------------------------------------
CREATE PROC [dbo].[add_region]
     @REGION_CODE	VARCHAR(20),
     @DESC			VARCHAR(50),
     @CODE_BRAN		VARCHAR(500)
AS
/*
exec add_region 'HO','Navi Mumbai','ABC,CHE01,HO'
exec add_region 'WEE','WRES','ABC,CHE01,HO'
*/
BEGIN
		DECLARE
			@ROWPOS AS INT, 
			@ROWPOS_MAIN AS INT,
			@BRDATA AS VARCHAR(500),
			@INSTR AS VARCHAR(500),
			@EXISTSTR AS VARCHAR(500),
			@SHAREDBLST_VAR AS VARCHAR(500),
			@EXCH_SECH_VAR AS VARCHAR(500),
			@SHAREDBLST	as VARCHAR(500),
			@EXCH_SEG as VARCHAR(500),
			@STRSQL AS VARCHAR(8000),
			@@BRANCHCOUNT AS INT

		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		CREATE TABLE #TEMMP(EXCH VARCHAR(800),SUCCESS VARCHAR(8000),EXIST VARCHAR(8000))
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))

		SET @ROWPOS_MAIN = 1 
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				BEGIN  
				 BREAK  
				END  

				 SET @INSTR = ''
				 SET @EXISTSTR = ''
				 SET @ROWPOS = 1
				 SET @STRSQL=''

			 WHILE 1 = 1  
				BEGIN  
					SET @BRDATA = LTRIM(RTRIM(.DBO.PIECE(@CODE_BRAN, ',', @ROWPOS)))  
			  
					IF @BRDATA IS NULL OR @BRDATA = ''  
					 BEGIN  
						BREAK  
					 END  
				
--					SET @STRSQL="SELECT COUNT(*) FROM "+ @SHAREDBLST_VAR + "..REGION WITH(NOLOCK) WHERE REGIONCODE = '"+ @REGION_CODE +"' AND BRANCH_CODE = '"+ @BRDATA +"'"
--					INSERT INTO #TBLCOUNT
--					EXEC (@STRSQL)
--
--					IF (SELECT A FROM #TBLCOUNT)= 0
					 BEGIN
						SET @STRSQL ="DELETE FROM "+ @SHAREDBLST_VAR + "..REGION WHERE REGIONCODE = '"+ @REGION_CODE +"' AND BRANCH_CODE = '"+ @BRDATA +"'"
						EXEC (@STRSQL)
						SET @STRSQL=''
						SET @STRSQL=" INSERT INTO "+ @SHAREDBLST_VAR + "..REGION (REGIONCODE,DESCRIPTION,BRANCH_CODE)"
						SET @STRSQL=@STRSQL + " VALUES('"+@REGION_CODE+"','"+@DESC+"','"+@BRDATA+"')"
						EXEC (@STRSQL)
						SET @STRSQL=''
						SET @STRSQL ="UPDATE "+ @SHAREDBLST_VAR + "..REGION SET DESCRIPTION='"+@DESC+"' WHERE REGIONCODE = '"+ @REGION_CODE +"'"
						EXEC (@STRSQL)
						SET @INSTR  = @INSTR  + @BRDATA  +','
					 END 
--					ELSE 
--					 BEGIN
--						SET @EXISTSTR = @EXISTSTR + @BRDATA + ',' 	
--				     END
					DELETE FROM #TBLCOUNT 

					SET @ROWPOS = @ROWPOS + 1
			  END
			SET @INSTR = @INSTR + '~'
			SET @EXISTSTR = @EXISTSTR + '~'
			INSERT INTO #TEMMP
			SELECT @EXCH_SECH_VAR ,@INSTR ,@EXISTSTR 

			SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 

		END 
SELECT EXCH,REPLACE(REPLACE(SUCCESS,',~',''),'~','') AS SUCCESS FROM #TEMMP
DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADMIN_ADDREPORT
-- --------------------------------------------------
CREATE PROC [dbo].[ADMIN_ADDREPORT]
(
	@REPORT VARCHAR(35),
	@PATH VARCHAR(500),
	@TARGET VARCHAR(25),
	@DESC VARCHAR(80),
	@REPORTGRP VARCHAR(10),
	@MENUGRP VARCHAR(3),
	@STATUS VARCHAR(20)
	
)
/*
BEGIN TRAN
EXEC ADMIN_ADDREPORT 'Voucher Edit','/ACCOUNT/ACCMODULES/VOUCHER_EDIT/V2_VOUCHER_MAIN.ASP','FRATOPIC','DCA','98',5,'ALL'
SELECT * FROM TBLREPORTS WHERE FLDREPORTNAME = 'VOUCHER EDIT'
ROLLBACK
*/
AS
	DECLARE 
		@RESULT VARCHAR(50),
		@COUNT INT
SELECT @COUNT = COUNT(*) FROM TBLREPORTS WHERE UPPER(RTRIM(LTRIM(FLDREPORTNAME))) = UPPER(RTRIM(LTRIM(@REPORT)))

IF @COUNT > 0 
 BEGIN
	SET @RESULT = 'REPORT NAME ALREADY EXIST...'
	SELECT @RESULT AS MESSAGE
	RETURN;
 END


BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO TBLREPORTS 
	VALUES(@REPORT,@PATH,@TARGET,@DESC,@REPORTGRP,@MENUGRP,@STATUS,0)
	
	SET @RESULT = 'REPORT SUCCESSFULLY INSERTED!'

	IF @@ERROR = 0
	 BEGIN
		SELECT @RESULT AS MESSAGE
    END 
		
END TRY
BEGIN CATCH
	SELECT 
        ERROR_MESSAGE() AS MESSAGE;
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADMIN_DELREPORT
-- --------------------------------------------------
CREATE PROC [dbo].[ADMIN_DELREPORT]
(
	@FLDAUTO VARCHAR(500),
	@ADMIN_NAME VARCHAR(50),
	@IPADD VARCHAR(20)
)

AS
/*
ADMIN_DELREPORT '2452','ADMINISTRATOR',''
2445, 2444, 2446

SELECT * FROM TBLCATMENU_LOG WHERE FLDREPORTCODE = 2452

select * from tblreports_LOG where fldreportname = 'voucher edit1'

*/
CREATE TABLE #TEMPID
(
	ID INT
)

DECLARE 
	@LOOPID INT,
	@LOOPDATA VARCHAR(300),
	@GLOBALDATE DATETIME,
	@ADMINID INT, 
	@RESULT VARCHAR(50)	


SET @GLOBALDATE = GETDATE()

BEGIN TRY
	SET NOCOUNT ON;
	SET @LOOPID = 1
	WHILE 1 = 1
	 BEGIN
		SET @LOOPDATA = .DBO.PIECE(@FLDAUTO,',',@LOOPID)

		IF @LOOPDATA = '' OR @LOOPDATA IS NULL
		 BEGIN
			BREAK
		 END
			
		INSERT INTO #TEMPID(ID) VALUES(@LOOPDATA)
		SET @LOOPID = @LOOPID + 1 
	 END


	INSERT INTO TBLREPORTS_LOG (
		FLDREPORTCODE,
		FLDREPORTNAME,
		FLDPATH,
		FLDTARGET,
		FLDDESC,
		FLDREPORTGRP,
		FLDMENUGRP,
		FLDSTATUS,
		FLDORDER,
		EDIT_FLAG,
		CREATED_BY,
		CREATED_ON )
	SELECT 
		FLDREPORTCODE,
		FLDREPORTNAME,
		FLDPATH,
		FLDTARGET,
		FLDDESC,
		FLDREPORTGRP,
		FLDMENUGRP,
		FLDSTATUS,
		FLDORDER,
		'D',
		@ADMIN_NAME,
		@GLOBALDATE
	FROM
		TBLREPORTS, #TEMPID
	WHERE 
		FLDREPORTCODE = ID

	DELETE 
		TR
	FROM 
		TBLREPORTS TR, #TEMPID 
	WHERE 
		FLDREPORTCODE = ID

	INSERT INTO TBLCATMENU_LOG (
		FLDREPORTCODE,
		FLDADMINAUTO,
		FLDCATEGORYCODE_OLD,
		FLDCATEGORYCODE_NEW,
		EDIT_FLAG,
		CREATED_BY,
		CREATED_ON,
		MACHINE_IP )
	SELECT 
		FLDREPORTCODE,
		FLDADMINAUTO,
		FLDCATEGORYCODE,
		'',
		'D',
		@ADMIN_NAME,
		@GLOBALDATE,
		@IPADD 
	FROM 
		TBLCATMENU, #TEMPID 
	WHERE 
		FLDREPORTCODE = ID
		
	DELETE 
		TC
	FROM 
		TBLCATMENU TC, #TEMPID  
	WHERE 
		FLDREPORTCODE = ID
	

		SET @RESULT = 'DELETED SUCCESSFULLY!'

		IF @@ERROR = 0
		 BEGIN
			SELECT @RESULT AS MESSAGE
         END 
		DROP TABLE #TEMPID
END TRY
BEGIN CATCH
	SELECT 
        ERROR_MESSAGE() AS MESSAGE;
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADMIN_DELUSER
-- --------------------------------------------------
CREATE PROC [dbo].[ADMIN_DELUSER]
(
	@FLDAUTO VARCHAR(500),
	@ADMIN_NAME VARCHAR(50),
	@IPADD VARCHAR(20)
)

AS
/*
ADMIN_DELUSER '19,10,11,13','BROKER_CHECKER','10.11.12.74' 
SELECT * FROM TBLUSERCONTROLMASTER_JRNL
SELECT * FROM TBLPRADNYAUSERS_LOG WHERE FLDUSERNAME  ='testBhrt'

ROLLBACK
*/
CREATE TABLE #TEMPID
(
	ID INT
)

DECLARE 
	@LOOPID INT,
	@LOOPDATA VARCHAR(3),
	@GLOBALDATE DATETIME,
	@ADMINID INT

SET @GLOBALDATE = GETDATE()
SELECT  @ADMINID = FLDAUTO_ADMIN FROM TBLADMIN WHERE FLDNAME = @ADMIN_NAME

BEGIN TRAN
	SET @LOOPID = 1
	WHILE 1 = 1
	 BEGIN
		SET @LOOPDATA = .DBO.PIECE(@FLDAUTO,',',@LOOPID)

		IF @LOOPDATA = '' OR @LOOPDATA IS NULL
		 BEGIN
			BREAK
		 END
			
		INSERT INTO #TEMPID(ID) VALUES(@LOOPDATA)
		SET @LOOPID = @LOOPID + 1 
	 END	

	INSERT INTO TBLPRADNYAUSERS_LOG 
		(FLDAUTO,
		FLDUSERNAME,
		FLDPASSWORD,
		FLDFIRSTNAME,
		FLDMIDDLENAME,
		FLDLASTNAME,
		FLDSEX,
		FLDADDRESS1,
		FLDADDRESS2,
		FLDPHONE1,
		FLDPHONE2,
		FLDCATEGORY,
		FLDADMINAUTO,
		FLDSTNAME,
		PWD_EXPIRY_DATE,
		EDIT_FLAG,
		CREATED_BY,
		CREATED_ON,
		MACHINEIP,
		FLDLOG_DATA)
	SELECT 
		FLDAUTO,
		FLDUSERNAME,
		FLDPASSWORD,
		FLDFIRSTNAME,
		FLDMIDDLENAME,
		FLDLASTNAME,
		FLDSEX,
		FLDADDRESS1,
		FLDADDRESS2,
		FLDPHONE1,
		FLDPHONE2,
		FLDCATEGORY,
		FLDADMINAUTO,
		FLDSTNAME,
		PWD_EXPIRY_DATE,
		'D',
		@ADMIN_NAME,
		@GLOBALDATE,
		@IPADD,
		'DELETEENTRY' 
	FROM 
		TBLPRADNYAUSERS, #TEMPID
	WHERE 
		FLDAUTO = ID

	INSERT INTO TBLUSERCONTROLMASTER_JRNL
		(FLDAUTO,
		FLDUSERID,
		FLDPWDEXPIRY,
		FLDMAXATTEMPT,
		FLDATTEMPTCNT,
		FLDSTATUS,
		FLDLOGINFLAG,
		FLDACCESSLVL,
		FLDIPADD,
		FLDTIMEOUT,
		FLDFIRSTLOGIN,
		FLDFORCELOGOUT,
		FLDUPDTBY,
		FLDUPDTDT)
	SELECT 
		FLDAUTO,
		FLDUSERID,
		FLDPWDEXPIRY,
		FLDMAXATTEMPT,
		FLDATTEMPTCNT,
		FLDSTATUS,
		FLDLOGINFLAG,
		FLDACCESSLVL,
		FLDIPADD,
		FLDTIMEOUT,
		FLDFIRSTLOGIN,
		FLDFORCELOGOUT,
		@ADMINID,
		@GLOBALDATE 
	FROM 
		TBLUSERCONTROLMASTER TBC, #TEMPID
	WHERE 
		FLDUSERID = ID
	
	DELETE 
		TB
	FROM 
		TBLPRADNYAUSERS TB,  #TEMPID 
	WHERE 
		FLDAUTO= ID
COMMIT

DROP TABLE #TEMPID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADMIN_GET_CATEGORIES
-- --------------------------------------------------
CREATE PROC [dbo].[ADMIN_GET_CATEGORIES]
(
	@FLDADMINAUTO INT
)
AS
/*
ADMIN_GET_CATEGORIES 26
SELECT * FROM TBLADMIN
SELECT * FROM TBLCATEGORY
DROP PROC  GET_CATEGORIES
*/

SELECT 
	FLDAUTO_ADMIN, FLDSTATUS 
INTO 
	#TEMP
FROM 
	TBLADMIN 
WHERE FLDSTATUS = (SELECT FLDSTATUS FROM TBLADMIN WHERE FLDAUTO_ADMIN = @FLDADMINAUTO)

--SELECT * FROM #TEMP

SELECT * FROM TBLCATEGORY, #TEMP WHERE FLDAUTO_ADMIN = FLDADMINAUTO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BSEMFSS_DUPRECCHECK
-- --------------------------------------------------
  
CREATE PROC [dbo].[BSEMFSS_DUPRECCHECK] (@SAUDA_DATE VARCHAR(11))    
AS    
    
IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP WHERE CONF_FLAG <> '' ) > 0     
BEGIN    
 UPDATE MFSS_ORDER SET CONF_FLAG = M.CONF_FLAG,    
        REJECT_REASON = M.REJECT_REASON    
 FROM MFSS_ORDER_TMP M    
 WHERE M.ORDER_DATE = @SAUDA_DATE    
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO    
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD      
END  
  
INSERT INTO MFSS_SETTLEMENT_LOG   
SELECT * FROM MFSS_SETTLEMENT  
WHERE MFSS_SETTLEMENT.ORDER_DATE = @SAUDA_DATE    
 AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_TMP     
      WHERE MFSS_ORDER_TMP.ORDER_DATE = @SAUDA_DATE    
      AND MFSS_SETTLEMENT.ORDER_NO = MFSS_ORDER_TMP.ORDER_NO    
      AND MFSS_SETTLEMENT.SCRIP_CD = MFSS_ORDER_TMP.SCRIP_CD  
      AND MFSS_ORDER_TMP.CONF_FLAG = 'INVALID'  
      AND MFSS_ORDER_TMP.REJECT_REASON <> 'PROVISIONAL ORDER')  
  
DELETE FROM MFSS_SETTLEMENT  
WHERE MFSS_SETTLEMENT.ORDER_DATE = @SAUDA_DATE    
 AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_TMP     
      WHERE MFSS_ORDER_TMP.ORDER_DATE = @SAUDA_DATE    
      AND MFSS_SETTLEMENT.ORDER_NO = MFSS_ORDER_TMP.ORDER_NO    
      AND MFSS_SETTLEMENT.SCRIP_CD = MFSS_ORDER_TMP.SCRIP_CD  
      AND MFSS_ORDER_TMP.CONF_FLAG = 'INVALID'  
      AND MFSS_ORDER_TMP.REJECT_REASON <> 'PROVISIONAL ORDER')  
        
INSERT INTO MFSS_ORDER    
SELECT MEMBERCODE,ORDER_DATE,ORDER_TIME,ORDER_NO,SETT_NO,PARTY_CODE,  
    PARTY_NAME,SCRIP_CD,SCHEME_NAME,ISIN,SUB_RED_FLAG,AMOUNT,QTY,  
    ALLOTMENT_MODE,DPCLT,FOLIONO,USER_ID,CONF_FLAG,  
    REJECT_REASON,NAV_VALUE_ALLOTED,QTY_ALLOTED,AMOUNT_ALLOTED,INT_REF_NO,SETTLEMENT_TYPE,ORDER_TYPE,SIP_REGN_NO,SIP_REGN_DATE  
FROM MFSS_ORDER_TMP M    
WHERE M.ORDER_DATE = @SAUDA_DATE    
AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_ORDER     
      WHERE MFSS_ORDER.ORDER_DATE = @SAUDA_DATE    
      AND M.ORDER_NO = MFSS_ORDER.ORDER_NO    
      AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BSEMFSS_DUPRECSETTCHECK
-- --------------------------------------------------
 
CREATE PROC [dbo].[BSEMFSS_DUPRECSETTCHECK] (@SAUDA_DATE VARCHAR(11))    
AS    
    
IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP     
 WHERE ORDER_DATE = @SAUDA_DATE    
 AND CONF_FLAG = 'VALID' AND REJECT_REASON <> 'PROVISIONAL ORDER' ) > 0     
BEGIN    
 INSERT INTO MFSS_TRADE    
 SELECT MEMBERCODE,ORDER_DATE,ORDER_TIME,ORDER_NO,SETT_NO,SETT_TYPE=SETTLEMENT_TYPE,  
  PARTY_CODE,PARTY_NAME,SCRIP_CD,SCHEME_NAME,ISIN,SUB_RED_FLAG,  
  SETTFLAG = (CASE WHEN SUB_RED_FLAG = 'P' THEN 4 ELSE 5 END),  
  AMOUNT,QTY,ALLOTMENT_MODE,DPCLT,FOLIONO,USER_ID,CONF_FLAG,REJECT_REASON,  
  FILLER1 = '', FILLER2 = '', FILLER3 = ''  
 FROM MFSS_ORDER M    
 WHERE M.ORDER_DATE = @SAUDA_DATE    
 AND CONF_FLAG = 'VALID'   
 AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_TRADE     
       WHERE MFSS_TRADE.ORDER_DATE = @SAUDA_DATE    
       AND M.ORDER_NO = MFSS_TRADE.ORDER_NO    
       AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD)    
 AND SETTLEMENT_TYPE <> '' AND SETT_NO <> ''
END    
    
DELETE FROM MFSS_TRADE    
WHERE ORDER_DATE = @SAUDA_DATE    
AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_SETTLEMENT M    
       WHERE M.ORDER_DATE = @SAUDA_DATE    
       AND M.ORDER_NO = MFSS_TRADE.ORDER_NO    
       AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD)    
/*    
UPDATE MFSS_TRADE SET SETT_NO = S.SETT_NO, SETT_TYPE = S.SETT_TYPE    
FROM SETT_MST S    
WHERE S.START_DATE LIKE @SAUDA_DATE + '%'  
AND   MFSS_TRADE.SETT_NO = ''
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_ACCESSIBLEUSER
-- --------------------------------------------------
CREATE PROC [dbo].[CBO_ACCESSIBLEUSER]
	@REPORTCODE INT,
	@USERCATEGORY VARCHAR(2000)
AS
/*
	CBO_ACCESSIBLEUSER 1056, 388
*/

IF (SELECT COUNT(1) FROM TBLCATMENU WHERE FLDREPORTCODE = @REPORTCODE AND FLDCATEGORYCODE LIKE '%' + @USERCATEGORY + '%') > 0
	SELECT ALLOWED = 1
ELSE
	SELECT ALLOWED = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_GETBRANCHLIST
-- --------------------------------------------------


CREATE PROC [dbo].[CBO_GETBRANCHLIST]
	@BRANCH_CODE VARCHAR(20) = '',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'

AS
/*
	CBO_GETBRANCHLIST '', 'PARTY', 'C000000002'
*/
SET @BRANCH_CODE = LTRIM(RTRIM(@BRANCH_CODE))
IF @STATUSID = 'BROKER'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B
			WHERE
				B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'BRANCH'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B
			WHERE
				B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND B.BRANCH_CODE = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'AREA'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				AREA A
			WHERE
				B.BRANCH_CODE = A.BRANCH_CODE
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND A.AREACODE = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'REGION'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				REGION R
			WHERE
				B.BRANCH_CODE = R.BRANCH_CODE
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND R.REGIONCODE = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'SUBBROKER'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				SUBBROKERS S
			WHERE
				B.BRANCH_CODE = S.BRANCH_CODE
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND S.SUB_BROKER = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'TRADER'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				BRANCHES T
			WHERE
				B.BRANCH_CODE = T.BRANCH_CD
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND T.SHORT_NAME = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'FAMILY'
	BEGIN
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				CLIENT1 C1
			WHERE
				B.BRANCH_CODE = C1.BRANCH_CD
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
				AND C1.FAMILY = @STATUSNAME
			ORDER BY
				B.BRANCH_CODE
	END
ELSE IF @STATUSID = 'CLIENT'
	BEGIN
		SELECT
			C2.PARTY_CODE,
			C1.BRANCH_CD
		INTO
			#CLIENT2
		FROM
			CLIENT1 C1,
			CLIENT2 C2
		WHERE
			C1.CL_CODE = C2.CL_CODE
			AND C2.PARTY_CODE = @STATUSNAME
		SELECT DISTINCT
				B.BRANCH_CODE,
				B.BRANCH
			FROM
				BRANCH B,
				#CLIENT2 C2
			WHERE
				B.BRANCH_CODE = C2.BRANCH_CD
				AND B.BRANCH_CODE = CASE WHEN LEN(@BRANCH_CODE) > 0 AND @BRANCH_CODE <> '%' THEN @BRANCH_CODE ELSE B.BRANCH_CODE END
			ORDER BY
				B.BRANCH_CODE
	END
ELSE
	BEGIN
		SELECT
			BRANCH_CODE = '',
			BRANCH = ''
		FROM
			BRANCH
		WHERE
			1 = 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_USER
-- --------------------------------------------------
CREATE PROC [dbo].[CHECK_USER]      
(      
 @UID VARCHAR(50),      
 @STNAME VARCHAR(50),      
 @RESULT INT OUTPUT      
)       
/*      
CHECK_USER 'DFS','',''
      
SELECT * FROM MSAJAG..CLIENT_DETAILS WHERE CL_CODE = '00000031'       
SELECT * FROM TBLPRADNYAUSERS WHERE FLDUSERNAME ='TEST'
*/       
     
AS      
 DECLARE @COUNT SMALLINT      
       
SET @COUNT = 0       
      
IF UPPER(@STNAME) = 'CLIENT'      
 BEGIN      
 SELECT @COUNT = COUNT(*) FROM MSAJAG.DBO.CLIENT_DETAILS WHERE CL_CODE = @UID      
       
 IF @COUNT = 0       
  BEGIN      
  SET @RESULT = 2 --'NOTEXISTS'      
  SELECT @RESULT      
  RETURN      
  END      
 END       

SELECT @COUNT = COUNT(FLDNAME) FROM TBLUSERBLOCK WHERE FLDNAME LIKE '%'+@UID OR FLDNAME LIKE @UID+'%'
IF @COUNT <> 0       
 BEGIN      
 SET @RESULT = 4 --'INVALID'      
 SELECT @RESULT      
 RETURN      
 END      

      
SELECT       
 @COUNT = COUNT(FLDUSERNAME) FROM TBLPRADNYAUSERS (NOLOCK) WHERE FLDUSERNAME LIKE @UID      
      
IF @COUNT <> 0       
 BEGIN      
 SET @RESULT = 1 --'EXSITSINMASTER'      
 SELECT @RESULT      
 RETURN      
 END      
ELSE      
 BEGIN      
 SET @RESULT = 0 --'OK'      
 SELECT @RESULT      
 RETURN      
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99U92WJ6X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_03052012
-- --------------------------------------------------
CREATE PROC [DBO].[CHECKVERSION_03052012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '7=99S52WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_09012010
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'
SET @ERRCODE2 = '0=>9U22WJ7X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '$!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'N75'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.checkversion_11JAN2010
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'
SET @ERRCODE2 = '0=>9T02WJ7X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '$!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'N75'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_11Jan2019
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@Z'
SET @ERRCODE2 = '</{9U72WJ7Z9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12022014
-- --------------------------------------------------
    
CREATE PROC [DBO].[CHECKVERSION_12022014]    
AS    
    
DECLARE     
@ERRCODE1 VARCHAR(100),    
@ERRCODE2 VARCHAR(20),    
@ERRCODE3 VARCHAR(2),    
@ERRCODE4 VARCHAR(10),    
@ERRCODE5 VARCHAR(10),    
@ERRCODE6 VARCHAR(100),    
@ERRCODE7 VARCHAR(100),    
@ERRCODE8 VARCHAR(100),    
@ERRCODE9 VARCHAR(100),    
@ERRCODE10 VARCHAR(10),    
@ERRCODE11 VARCHAR(10),    
@ERRCODE12 VARCHAR(100),    
@ERRCODE13 VARCHAR(10),    
@ERRCODE14 VARCHAR(100)    
    
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'    
SET @ERRCODE2 = '0/*9S42WJ749S8xTKD2 '    
SET @ERRCODE3 = 'R4'    
SET @ERRCODE4 = '6!'''    
SET @ERRCODE5 = '7''\@'    
SET @ERRCODE6 = 'LICENSE PERIOD OVER '    
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'    
SET @ERRCODE8 = ''    
SET @ERRCODE9 = 'LICENSE NOT VALID'    
SET @ERRCODE10 = 'S6  M'    
SET @ERRCODE11 = 'N'    
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'    
SET @ERRCODE13 = 'SY'    
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'    
    
SELECT    
 ERRCODE1 = @ERRCODE1,    
 ERRCODE2 = @ERRCODE2,    
 ERRCODE3 = @ERRCODE3,    
 ERRCODE4 = @ERRCODE4,    
 ERRCODE5 = @ERRCODE5,    
 ERRCODE6 = @ERRCODE6,    
 ERRCODE7 = @ERRCODE7,    
 ERRCODE8 = @ERRCODE8,    
 ERRCODE9 = @ERRCODE9,    
 ERRCODE10 = @ERRCODE10,    
 ERRCODE11 = @ERRCODE11,    
 ERRCODE12 = @ERRCODE12,    
 ERRCODE13 = @ERRCODE13,    
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12062013
-- --------------------------------------------------
    
CREATE PROC [DBO].[CHECKVERSION_12062013]    
AS    
    
DECLARE     
@ERRCODE1 VARCHAR(100),    
@ERRCODE2 VARCHAR(20),    
@ERRCODE3 VARCHAR(2),    
@ERRCODE4 VARCHAR(10),    
@ERRCODE5 VARCHAR(10),    
@ERRCODE6 VARCHAR(100),    
@ERRCODE7 VARCHAR(100),    
@ERRCODE8 VARCHAR(100),    
@ERRCODE9 VARCHAR(100),    
@ERRCODE10 VARCHAR(10),    
@ERRCODE11 VARCHAR(10),    
@ERRCODE12 VARCHAR(100),    
@ERRCODE13 VARCHAR(10),    
@ERRCODE14 VARCHAR(100)    
    
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'    
SET @ERRCODE2 = '7=99R02WJ749S8xTKD2 '    
SET @ERRCODE3 = 'R4'    
SET @ERRCODE4 = '6!'''    
SET @ERRCODE5 = '7''\@'    
SET @ERRCODE6 = 'LICENSE PERIOD OVER '    
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'    
SET @ERRCODE8 = ''    
SET @ERRCODE9 = 'LICENSE NOT VALID'    
SET @ERRCODE10 = 'J267'    
SET @ERRCODE11 = 'N'    
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'    
SET @ERRCODE13 = 'SY'    
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'    
    
SELECT    
 ERRCODE1 = @ERRCODE1,    
 ERRCODE2 = @ERRCODE2,    
 ERRCODE3 = @ERRCODE3,    
 ERRCODE4 = @ERRCODE4,    
 ERRCODE5 = @ERRCODE5,    
 ERRCODE6 = @ERRCODE6,    
 ERRCODE7 = @ERRCODE7,    
 ERRCODE8 = @ERRCODE8,    
 ERRCODE9 = @ERRCODE9,    
 ERRCODE10 = @ERRCODE10,    
 ERRCODE11 = @ERRCODE11,    
 ERRCODE12 = @ERRCODE12,    
 ERRCODE13 = @ERRCODE13,    
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12072011
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_12072011]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '0/*9T52WJ769S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_13042011
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_13042011]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '<<!9T52WJ769S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16102012
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_16102012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '5,/9S42WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_17042010
-- --------------------------------------------------




  
CREATE PROC [DBO].[CHECKVERSION_17042010]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '<<!9T42WJ7X9S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_17072012
-- --------------------------------------------------


  
CREATE PROC [DBO].[CHECKVERSION_17072012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '0/*9S32WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_20042012
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_20042012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'  
SET @ERRCODE2 = '<<!9S02WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '$!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'J267'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_24May2019
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99U72WJ7Y9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_27082015
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '5,/9S72WJ729S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.checkversion_31122009
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'
SET @ERRCODE2 = '!;:9R02WJYY9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '$!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'N75'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_Bkup_20Jan2020
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99U72WJ7Y9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_MAY122011
-- --------------------------------------------------

CREATE PROC [dbo].[CHECKVERSION_MAY122011]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@5!W'
SET @ERRCODE2 = '7=99T72WJ769S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '$!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'J267'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_AUTHORIZED_COUNT
-- --------------------------------------------------
CREATE PROC [dbo].[CLASS_AUTHORIZED_COUNT]    
(    
 @UNAME VARCHAR(30),    
 @ADMIN_NAME VARCHAR(30),  
 @CUREXCHSEG VARCHAR(50)      
)    
/*    
 CLASS_USER_COUNT 'Bha', 'ADMINISTRATOR', ''    
 SELECT * FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = 'DSS'    
EXEC CLASS_USER_COUNT 'SAMARTHLANJEKAR','Broker','NSE~~CAPITAL'  
  
*/    
AS    
 DECLARE      
 @@EXCHANGE AS VARCHAR(3),    
 @@SEGMENT AS VARCHAR(15),    
 @@SHARESVR AS VARCHAR(20),    
 @@SHAREDB   AS VARCHAR(20),    
 @@SEGORD AS TINYINT,    
 @@SQL  AS VARCHAR(500),    
 @@MAINREC AS CURSOR    
     
  CREATE TABLE [DBO].[#RESULT]      
  (      
  EXCHANGE VARCHAR(6),       
  SEGMENT VARCHAR(10),    
  RESULT VARCHAR(100)    
  ) ON [PRIMARY]    
      
 CREATE TABLE #USERS    
 (    
  FLDUSERNAME VARCHAR(30)    
 )    
    
 IF UPPER(@ADMIN_NAME) = 'ADMINISTRATOR'  
 BEGIN  
  SET @@MAINREC = CURSOR FOR       
 SELECT EXCHANGE, SEGMENT, SHAREDB, SHARESERVER FROM PRADNYA.DBO.MULTICOMPANY_ALL WHERE PRIMARYSERVER = 1 ORDER BY 1     
 END  
 ELSE  
 BEGIN  
  SET @@MAINREC = CURSOR FOR    
 SELECT EXCHANGE, SEGMENT, SHAREDB, SHARESERVER FROM PRADNYA.DBO.MULTICOMPANY_ALL WHERE EXCHANGE + '~~' + SEGMENT =  @CUREXCHSEG  AND PRIMARYSERVER = 1 ORDER BY 1  
 END    
     
 SET @@SEGORD = 1      
 OPEN @@MAINREC      
 FETCH NEXT FROM @@MAINREC INTO @@EXCHANGE, @@SEGMENT, @@SHAREDB, @@SHARESVR     
  WHILE @@FETCH_STATUS = 0    
   BEGIN    
   IF @@SHARESVR <> @@SERVERNAME     
    BEGIN    
     SET @@SQL = " INSERT INTO #USERS SELECT FLDUSERNAME FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS TP, " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER TU WHERE TP.FLDAUTO = TU.FLDUSERID AND FLDSTATUS <> 0 AND FLDUSERNAME = '"+ @UNAME +"' "    
    END    
    ELSE    
    BEGIN     
     SET @@SQL = " INSERT INTO #USERS SELECT FLDUSERNAME #USERS FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS TP, " + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER TU WHERE TP.FLDAUTO = TU.FLDUSERID AND FLDSTATUS <> 0 AND FLDUSERNAME = '"+ @UNAME +"' "    
    END    
   PRINT(@@SQL)    
   EXEC(@@SQL)     
  --SELECT * FROM #USERS     
  IF @@ROWCOUNT <> 0    
   BEGIN    
   INSERT INTO #RESULT VALUES(@@EXCHANGE,@@SEGMENT,'USER AVAILABLE')    
   END     
      
 SET @@SEGORD = @@SEGORD + 1    
 FETCH NEXT FROM @@MAINREC INTO @@EXCHANGE, @@SEGMENT, @@SHAREDB, @@SHARESVR    
 END     
    
 SELECT * FROM #RESULT    
 DROP TABLE #RESULT    
 DROP TABLE #USERS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_USER_COUNT
-- --------------------------------------------------
CREATE PROC [dbo].[CLASS_USER_COUNT]  
(  
 @UNAME VARCHAR(30),  
 @ADMIN_NAME VARCHAR(30),
 @CUREXCHSEG VARCHAR(50) 	  
)  
/*  
 CLASS_USER_COUNT 'TEST', 'ADMINISTRATOR', ''  
 SELECT * FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = 'DSS'  
EXEC CLASS_USER_COUNT 'SAMARTHLANJEKAR','Broker','NSE~~CAPITAL'

*/  
AS  
 DECLARE    
 @@EXCHANGE AS VARCHAR(3),  
 @@SEGMENT AS VARCHAR(15),  
 @@SHARESVR AS VARCHAR(20),  
 @@SHAREDB   AS VARCHAR(20),  
 @@SEGORD AS TINYINT,  
 @@SQL  AS VARCHAR(500),  
 @@MAINREC AS CURSOR  
   
  CREATE TABLE [DBO].[#RESULT]    
  (    
  EXCHANGE VARCHAR(6),     
  SEGMENT VARCHAR(10),  
  RESULT VARCHAR(100)  
  ) ON [PRIMARY]  
    
 CREATE TABLE #USERS  
 (  
  FLDUSERNAME VARCHAR(30)  
 )  
  
 IF UPPER(@ADMIN_NAME) = 'ADMINISTRATOR'
 BEGIN
  SET @@MAINREC = CURSOR FOR 	  	
 SELECT EXCHANGE, SEGMENT, SHAREDB, SHARESERVER FROM PRADNYA.DBO.MULTICOMPANY_ALL WHERE PRIMARYSERVER = 1 ORDER BY 1   
 END
 ELSE
 BEGIN
  SET @@MAINREC = CURSOR FOR 	
 SELECT EXCHANGE, SEGMENT, SHAREDB, SHARESERVER FROM PRADNYA.DBO.MULTICOMPANY_ALL WHERE EXCHANGE + '~~' + SEGMENT = 	@CUREXCHSEG  AND PRIMARYSERVER = 1 ORDER BY 1
 END		
   
 SET @@SEGORD = 1    
 OPEN @@MAINREC    
 FETCH NEXT FROM @@MAINREC INTO @@EXCHANGE, @@SEGMENT, @@SHAREDB, @@SHARESVR   
  WHILE @@FETCH_STATUS = 0  
   BEGIN  
   IF @@SHARESVR <> @@SERVERNAME   
    BEGIN  
     SET @@SQL = " INSERT INTO #USERS SELECT FLDUSERNAME FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+ @UNAME +"' "  
    END  
    ELSE  
    BEGIN   
     SET @@SQL = " INSERT INTO #USERS SELECT FLDUSERNAME #USERS FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+ @UNAME +"' "  
    END  
   PRINT(@@SQL)  
   EXEC(@@SQL)   
  --SELECT * FROM #USERS   
  IF @@ROWCOUNT <> 0  
   BEGIN  
   INSERT INTO #RESULT VALUES(@@EXCHANGE,@@SEGMENT,'USER AVAILABLE')  
   END   
    
 SET @@SEGORD = @@SEGORD + 1  
 FETCH NEXT FROM @@MAINREC INTO @@EXCHANGE, @@SEGMENT, @@SHAREDB, @@SHARESVR  
 END   
  
 SELECT * FROM #RESULT  
 DROP TABLE #RESULT  
 DROP TABLE #USERS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_VALIDATE_ADMIN
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CLASS_VALIDATE_ADMIN]      
(      
    @ADMINID     VARCHAR(50),      
    @IPADDRESS  VARCHAR(20),      
    @RETCODE    INT  OUTPUT,      
    @RETMSG     VARCHAR(200)  OUTPUT,      
    @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,      
    @LASTLOGIN VARCHAR(40) OUTPUT      
)      
AS      
  
  DECLARE  @@USER_COUNT TINYINT      
  DECLARE  @@LASTLOGIN VARCHAR(40)        
  DECLARE  @@USER_SESSION VARCHAR(200)      
      
                                
  SELECT @@USER_COUNT = COUNT(1)      
  FROM   TBLCLASSADMINLOGINS (NOLOCK)      
  WHERE  FLDADMINNAME = @ADMINID      
                          
  IF ISNULL(@@USER_COUNT,0) = 0      
    BEGIN      
      INSERT INTO TBLCLASSADMINLOGINS      
   (      
    FLDAUTO,      
    FLDADMINNAME,      
    FLDSTATUS,      
    FLDSTNAME,      
    FLDSESSION,      
    FLDIPADDRESS,      
    FLDLASTVISIT,      
    FLDTIMEOUTPRD      
   )    
   SELECT A.FLDAUTO_ADMIN,      
  A.FLDNAME,      
  A.FLDSTATUS,      
  A.FLDSTNAME,      
  '',      
  '',      
  GETDATE(),      
  ''     
   FROM   TBLADMIN A (NOLOCK)      
   WHERE  A.FLDNAME = @ADMINID     
                                   
   IF @@ERROR <> 0      
  BEGIN      
   SET @RETCODE = 0      
   SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'      
   RETURN      
  END      
 END      
          
      
 SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)      
 FROM TBLCLASSADMINLOGINS      
 WHERE FLDADMINNAME = @ADMINID      
      
      
 SET @@USER_SESSION = NEWID()      
                             
 UPDATE TBLCLASSADMINLOGINS      
 SET    FLDIPADDRESS = @IPADDRESS,      
   FLDSESSION = @@USER_SESSION,      
   FLDLASTVISIT = GETDATE(),      
   FLDLASTLOGIN = GETDATE()      
 WHERE  FLDADMINNAME = @ADMINID      
                              
  IF @@ERROR <> 0      
    BEGIN      
  SET @RETCODE = 0      
  SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'      
  RETURN      
    END      
          
  SET @RETCODE = 1      
  SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'      
  SET @UM_SESSION = @@USER_SESSION      
  SET @LASTLOGIN = @@LASTLOGIN                      
  RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_VALIDATE_USER
-- --------------------------------------------------
CREATE PROCEDURE [DBO].[CLASS_VALIDATE_USER]    
(    
                @USERID     VARCHAR(50),    
                @IPADDRESS  VARCHAR(20),    
                @RETCODE    INT  OUTPUT,    
                @RETMSG     VARCHAR(200)  OUTPUT,    
                @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,    
    @LASTLOGIN VARCHAR(40) OUTPUT    
)    
AS    
    
  DECLARE  @@USER_COUNT TINYINT    
  DECLARE  @@LASTLOGIN VARCHAR(40)      
  DECLARE  @@USER_SESSION VARCHAR(200)    
    
                              
  SELECT @@USER_COUNT = COUNT(1)    
  FROM   TBLCLASSUSERLOGINS (NOLOCK)    
  WHERE  FLDUSERNAME = @USERID    
                           
  IF ISNULL(@@USER_COUNT,0) = 0    
    BEGIN    
        
  INSERT INTO TBLCLASSUSERLOGINS    
  (    
   FLDAUTO,    
   FLDUSERNAME,    
   FLDSTATUS,    
   FLDSTNAME,    
   FLDSESSION,    
   FLDIPADDRESS,    
   FLDLASTVISIT,    
   FLDTIMEOUTPRD    
  )    
  SELECT P.FLDAUTO,    
     P.FLDUSERNAME,    
     A.FLDSTATUS,    
     P.FLDSTNAME,    
     '',    
     '',    
     GETDATE(),    
     ISNULL(M.FLDTIMEOUT,1)    
  FROM   TBLPRADNYAUSERS P (NOLOCK)    
     LEFT OUTER JOIN TBLUSERCONTROLMASTER M (NOLOCK)    
    ON (M.FLDUSERID = P.FLDAUTO)    
     INNER JOIN TBLADMIN A (NOLOCK)    
    ON (P.FLDADMINAUTO = A.FLDAUTO_ADMIN)    
  WHERE  P.FLDUSERNAME = @USERID    
                                 
  IF @@ERROR <> 0    
    BEGIN    
   SET @RETCODE = 0    
               
   SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'    
               
   RETURN    
    END    
            
    END    
        
    
     SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)    
 FROM TBLCLASSUSERLOGINS    
 WHERE FLDUSERNAME = @USERID    
    
    
 SET @@USER_SESSION = NEWID()    
                           
 UPDATE TBLCLASSUSERLOGINS    
 SET    FLDIPADDRESS = @IPADDRESS,    
   FLDSESSION = @@USER_SESSION,    
   FLDLASTVISIT = GETDATE(),    
   FLDLASTLOGIN = GETDATE()    
 WHERE  FLDUSERNAME = @USERID    
                            
  IF @@ERROR <> 0    
    BEGIN    
  SET @RETCODE = 0    
  SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'    
  RETURN    
    END    
        
  SET @RETCODE = 1    
  SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'    
  SET @UM_SESSION = @@USER_SESSION    
  SET @LASTLOGIN = @@LASTLOGIN                    
  RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_VALIDATE_USER_21042011
-- --------------------------------------------------
    
   CREATE PROCEDURE [DBO].[CLASS_VALIDATE_USER_21042011]      
(      
                @USERID     VARCHAR(50),      
                @IPADDRESS  VARCHAR(20),      
                @RETCODE    INT  OUTPUT,      
                @RETMSG     VARCHAR(200)  OUTPUT,      
                @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,      
    @LASTLOGIN VARCHAR(40) OUTPUT      
)      
AS      
      
  DECLARE  @@USER_COUNT TINYINT      
  DECLARE  @@LASTLOGIN VARCHAR(40)        
  DECLARE  @@USER_SESSION VARCHAR(200)      
      
                                
  SELECT @@USER_COUNT = COUNT(1)      
  FROM   TBLCLASSUSERLOGINS (NOLOCK)      
  WHERE  FLDUSERNAME = @USERID      
                             
  IF ISNULL(@@USER_COUNT,0) = 0      
    BEGIN      
          
  INSERT INTO TBLCLASSUSERLOGINS      
  (      
   FLDAUTO,      
   FLDUSERNAME,      
   FLDSTATUS,      
   FLDSTNAME,      
   FLDSESSION,      
   FLDIPADDRESS,      
   FLDLASTVISIT,      
   FLDTIMEOUTPRD      
  )      
  SELECT P.FLDAUTO,      
     P.FLDUSERNAME,      
     A.FLDSTATUS,      
     P.FLDSTNAME,      
     '',      
     '',      
     GETDATE(),      
     ISNULL(M.FLDTIMEOUT,1)      
  FROM   TBLPRADNYAUSERS P (NOLOCK)      
     LEFT OUTER JOIN TBLUSERCONTROLMASTER M (NOLOCK)      
    ON (M.FLDUSERID = P.FLDAUTO)      
     INNER JOIN TBLADMIN A (NOLOCK)      
    ON (P.FLDADMINAUTO = A.FLDAUTO_ADMIN)      
  WHERE  P.FLDUSERNAME = @USERID      
                                   
  IF @@ERROR <> 0      
    BEGIN      
   SET @RETCODE = 0      
                 
   SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'      
                 
   RETURN      
    END      
              
    END      
          
      
     SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)      
 FROM TBLCLASSUSERLOGINS      
 WHERE FLDUSERNAME = @USERID      
      
      
 SET @@USER_SESSION = NEWID()      
                             
 UPDATE TBLCLASSUSERLOGINS      
 SET    FLDIPADDRESS = @IPADDRESS,      
   FLDSESSION = @@USER_SESSION,      
   FLDLASTVISIT = GETDATE(),      
   FLDLASTLOGIN = GETDATE()      
 WHERE  FLDUSERNAME = @USERID      
                              
  IF @@ERROR <> 0      
    BEGIN      
  SET @RETCODE = 0      
  SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'      
  RETURN      
    END      
          
  SET @RETCODE = 1      
  SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'      
  SET @UM_SESSION = @@USER_SESSION      
  SET @LASTLOGIN = @@LASTLOGIN                      
  RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLIENT_ACTIVE_STAT_UPD
-- --------------------------------------------------

CREATE PROC [dbo].[CLIENT_ACTIVE_STAT_UPD]       
(      
 @SESSIONID VARCHAR(20),      
 @UNAME VARCHAR(20),      
 @FILE_DATE VARCHAR(11),      
 @IMP_METHOD VARCHAR(10),      
 @FILE_PATH VARCHAR(400)      
) AS       
      
BEGIN TRAN      
      
 DECLARE @IMPDATETIME DATETIME      
 SET @IMPDATETIME = GETDATE()      
       
 INSERT INTO CLIENT_ACTIVE_STAT_LOG      
 SELECT *,'RE IMPORT' FROM CLIENT_ACTIVE_STAT WHERE FILE_DATE = @FILE_DATE      
      
 INSERT INTO CLIENT_ACTIVE_STAT_LOG      
 SELECT *,'HISTORY' FROM CLIENT_ACTIVE_STAT WHERE FILE_DATE < @FILE_DATE      
      
 TRUNCATE TABLE CLIENT_ACTIVE_STAT       
      
 INSERT INTO CLIENT_ACTIVE_STAT      
 (      
  FILE_DATE,USERID,ACCOUNT_ID,SEGMENT,EXCHANGE_USER_ID,EXPIRYDATE,      
  EXCHANGE_USER_INFO,ENABLED_FLAG,CLMAST_UPD_STAT,UPLOADED_BY,UPLOADED_ON      
 )      
        
 SELECT       
       
  FILE_DATE = @FILE_DATE,      
  USERID = DBO.PIECE(FILE_DATA,'|',1),      
  ACCOUNT_ID = DBO.PIECE(FILE_DATA,'|',2),      
  SEGMENT = DBO.PIECE(FILE_DATA,'|',3),      
  EXCHANGE_USER_ID = DBO.PIECE(FILE_DATA,'|',4),      
  EXPIRYDATE = DBO.PIECE(FILE_DATA,'|',5),      
  EXCHANGE_USER_INFO = DBO.PIECE(FILE_DATA,'|',6),      
  ENABLED_FLAG = DBO.PIECE(FILE_DATA,'|',7),      
  CLMAST_UPD_STAT = 0,      
  UPLOADED_BY = @UNAME,      
  UPLOADED_ON = @IMPDATETIME      
 FROM       
  CLIENT_ACTIVE_STAT_IMP      
 WHERE LEN(FILE_DATA) > 10      
       
 TRUNCATE TABLE CLIENT_ACTIVE_STAT_IMP      
       
 INSERT INTO CLIENT_ACTIVE_STAT_IMP_LOG (FILE_DATE,IMP_METHOD,FILE_PATH,UPLOADED_BY,UPLOADED_ON)      
 VALUES (@FILE_DATE,@IMP_METHOD,UPPER(@FILE_PATH),UPPER(@UNAME),@IMPDATETIME)      
      
 ---------------NSE---------------     
 UPDATE NSEMFSS..MFSS_CLIENT       
 SET INACTIVE_FROM = @FILE_DATE     
 FROM CLIENT_ACTIVE_STAT C      
 WHERE ADDEDON BETWEEN @FILE_DATE AND @FILE_DATE + ' 23:59'      
 AND ACCOUNT_ID = PARTY_CODE  
 AND ENABLED_FLAG ='N' 
 AND INACTIVE_FROM > @FILE_DATE    
 AND SEGMENT = 'NSEMFF'      
      
 UPDATE NSEMFSS..MFSS_CLIENT       
 SET INACTIVE_FROM = 'DEC 31 2049 23:59'   
 FROM CLIENT_ACTIVE_STAT C      
 WHERE ADDEDON BETWEEN @FILE_DATE AND @FILE_DATE + ' 23:59'      
 AND ACCOUNT_ID = PARTY_CODE      
 AND ENABLED_FLAG ='Y'      
 AND INACTIVE_FROM <= @FILE_DATE 
 AND SEGMENT = 'NSEMFF'

--------------BSE---------------------
 UPDATE BSEMFSS..MFSS_CLIENT       
 SET INACTIVE_FROM = @FILE_DATE     
 FROM CLIENT_ACTIVE_STAT C      
 WHERE ADDEDON BETWEEN @FILE_DATE AND @FILE_DATE + ' 23:59'      
 AND ACCOUNT_ID = PARTY_CODE  
 AND ENABLED_FLAG ='N' 
 AND INACTIVE_FROM > @FILE_DATE 
 AND SEGMENT = 'BSEMFF'
      
 UPDATE BSEMFSS..MFSS_CLIENT       
 SET INACTIVE_FROM = 'DEC 31 2049 23:59'   
 FROM CLIENT_ACTIVE_STAT C      
 WHERE ADDEDON BETWEEN @FILE_DATE AND @FILE_DATE + ' 23:59'      
 AND ACCOUNT_ID = PARTY_CODE      
 AND ENABLED_FLAG ='Y'      
 AND INACTIVE_FROM <= @FILE_DATE 
 AND SEGMENT = 'BSEMFF'
 
             
COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CREATE_CLASS_USER
-- --------------------------------------------------


CREATE PROC [dbo].[CREATE_CLASS_USER]  
(
 @FLDAUTO VARCHAR(50),	  
 @USERNAME VARCHAR(25),  
 @PASSWORD VARCHAR(50),  
 @FIRSTNAME VARCHAR(25),  
 @MIDDLENAME VARCHAR(25),  
 @LASTNAME VARCHAR(25),  
 @SEX  VARCHAR(8),  
 @ADD1  VARCHAR(100),  
 @MAILADD2 VARCHAR(100),  
 @PHONE1  VARCHAR(10),  
 @PHONE2  VARCHAR(10),   
 @CATEGORY VARCHAR(10),  
 @ADMIN_AUTO INT,  
 @STNAME  VARCHAR(50),  
 @ADMIN_NAME VARCHAR(30),  
 @IPADD  VARCHAR(20),  
 @PWDEXPIRYDAYS SMALLINT,  
 @USERSTATUS SMALLINT,  
 @ATTEMPTCOUNT SMALLINT,  
 @MAXATTEMPTCOUNT SMALLINT,  
 @ACCESSLEVEL CHAR(1),  
 @LOGINSTATUS SMALLINT,
 @FIRSTLOGIN CHAR(1),	
 @USERIPADDRESS VARCHAR(2000),
 @USERTYPE VARCHAR(25), 	
 @EXCHANGE VARCHAR(3),
 @SEGMENT VARCHAR(20),
 @CREATION_FLAG VARCHAR(3), --All or Single segment
 @ACTION_FLAG VARCHAR(20), -- EDIT OR REGISTER 
 @FLD_MAC_ID VARCHAR(200)
)  
  
AS
DECLARE   
 @@EDIT_FLAG  CHAR(1),  
 @@NEWDATE  VARCHAR(11), 
 @@EXPDATE  VARCHAR(11), 	 
 @@FLDLOG_DATA VARCHAR(8000),  
 @@FLDAUTO  INT,  
 @@FLDAUTO_NEW INT,
 @@FLDADMINAUTO INT,	
 @@ERROR_COUNT BIGINT,  
 @MESSAGE  VARCHAR(200),
 @MOB_ACCESS SMALLINT,
 @RESULT VARCHAR(MAX)


BEGIN TRAN   
/*SELECT top 1 FLDUSERNAME = '12',FLDFIRSTNAME = '54',RESULT = 'PRADNYA & USER CONTROL MASTER NOT POPULATED PROPERLY!',EXCHANGE = '54', SEGMENT = '54'
from tblpradnyausers
ROLLBACK 
RETURN	*/

SET @@NEWDATE = CONVERT(VARCHAR,GETDATE(),109)  
SET @@EXPDATE = CONVERT(VARCHAR,GETDATE() + @PWDEXPIRYDAYS,109)  
/*SELECT 
	@MOB_ACCESS = MOB_ACCESS 
FROM 
	PRADNYA.DBO.ADMIN_INFO*/

IF UPPER(@ACTION_FLAG) = 'EDIT' 
 BEGIN
	SET @@EDIT_FLAG = 'E' 
	SET @@FLDLOG_DATA = '' 
 END
ELSE
 IF UPPER(@ACTION_FLAG) = 'REGISTER' 
  BEGIN
	SET @@EDIT_FLAG = 'A' 
	SET @@FLDLOG_DATA = 'ADDENTRY' 
  END	
ELSE
 IF UPPER(@ACTION_FLAG) = 'DELETE'
  BEGIN
	SET @@EDIT_FLAG = 'D' 
	SET @@FLDLOG_DATA = ''   
  END 

--BEGIN TRY
	IF UPPER(@ACTION_FLAG) = 'EDIT' 
     BEGIN
		
		SELECT @@FLDAUTO = FLDAUTO, @@FLDADMINAUTO = FLDADMINAUTO FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERNAME
	
		SELECT   
		 @@ERROR_COUNT = COUNT(FLDUSERNAME)
		FROM     
		 TBLPRADNYAUSERS (NOLOCK)   
		WHERE  
		 FLDUSERNAME = @USERNAME 
		
		IF @@ERROR_COUNT <> 0    
		BEGIN 
		
		SELECT 
			@@FLDLOG_DATA = FLDPASSWORD +'~'+ 
			CASE WHEN FLDFIRSTNAME = '' THEN '$' ELSE FLDFIRSTNAME END +'~'+
			CASE WHEN FLDMIDDLENAME = '' THEN '$' ELSE FLDMIDDLENAME END +'~'+
			CASE WHEN FLDLASTNAME = '' THEN '$' ELSE FLDLASTNAME END +'~'+
			CASE WHEN FLDSEX = '' THEN '$' ELSE FLDSEX END +'~'+
			CASE WHEN FLDADDRESS1 = '' THEN '$' ELSE FLDADDRESS1 END +'~'+
			CASE WHEN FLDADDRESS2 = '' THEN '$' ELSE FLDADDRESS2 END  +'~'+
			CASE WHEN FLDPHONE1 = '' THEN '$' ELSE FLDPHONE1 END +'~'+
			CASE WHEN FLDPHONE2 = '' THEN '$' ELSE FLDPHONE2 END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDCATEGORY) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDCATEGORY) END+'~'+
			CASE WHEN CONVERT(VARCHAR,PWD_EXPIRY_DATE) = '' THEN '$' ELSE CONVERT(VARCHAR,PWD_EXPIRY_DATE) END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,FLDATTEMPTCNT) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDATTEMPTCNT) END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDSTATUS) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDSTATUS) END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDLOGINFLAG) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDLOGINFLAG) END +'~'+
			CASE WHEN FLDACCESSLVL = '' THEN '$' ELSE FLDACCESSLVL END +'~'+
			CASE WHEN FLDIPADD  = '' THEN '$' ELSE FLDIPADD END+'~'+
			CASE WHEN CONVERT(VARCHAR,FLDTIMEOUT) = '' THEN '$' ELSE FLDFIRSTLOGIN END +'~'+
			CASE WHEN FLDFIRSTLOGIN = '' THEN '$' ELSE FLDFIRSTLOGIN END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,FLDFORCELOGOUT) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDFORCELOGOUT) END +'~'
		FROM 
			TBLPRADNYAUSERS TP, TBLUSERCONTROLMASTER TU 
		WHERE 
			TP.FLDAUTO = FLDUSERID
			AND FLDUSERNAME = @USERNAME 
		
		-- CLASS USER LOG TABLE ------------------------------  
		INSERT INTO   
		TBLPRADNYAUSERS_LOG  
		(  
		FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2,  
		FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA  
		)  
		SELECT  
			FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1,  
			FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, @@NEWDATE, @@EDIT_FLAG, @ADMIN_NAME, @@NEWDATE, @IPADD, @@FLDLOG_DATA  
		FROM   
			TBLPRADNYAUSERS  
		WHERE   
			FLDUSERNAME =@USERNAME  

		INSERT INTO   
			TBLUSERCONTROLMASTER_JRNL   
		SELECT   
			*,@@FLDADMINAUTO,@@NEWDATE   
		FROM   
			TBLUSERCONTROLMASTER  
		WHERE   
			FLDUSERID = @FLDAUTO  
		
		UPDATE 
			TBLPRADNYAUSERS 
		SET 
			FLDUSERNAME = @USERNAME, FLDPASSWORD = @PASSWORD, FLDFIRSTNAME = @FIRSTNAME, FLDMIDDLENAME = @MIDDLENAME,
			FLDLASTNAME = @LASTNAME, FLDSEX = @SEX,	FLDADDRESS1 = @ADD1, FLDADDRESS2 = @MAILADD2, FLDPHONE1 = @PHONE1,
			FLDPHONE2 = @PHONE2, FLDCATEGORY = @CATEGORY, FLDSTNAME = @STNAME, PWD_EXPIRY_DATE = @@EXPDATE, EDIT_FLAG = @@EDIT_FLAG 
		WHERE 
			FLDAUTO = @FLDAUTO
		
		
		UPDATE 
			TBLUSERCONTROLMASTER
		SET
			FLDPWDEXPIRY = @PWDEXPIRYDAYS, FLDMAXATTEMPT = @MAXATTEMPTCOUNT, FLDATTEMPTCNT = 0, FLDSTATUS = @USERSTATUS,
			FLDLOGINFLAG = @LOGINSTATUS, FLDACCESSLVL = @ACCESSLEVEL, FLDIPADD = @USERIPADDRESS, FLDFIRSTLOGIN = @FIRSTLOGIN
		WHERE 
			FLDUSERID = @FLDAUTO

		SET @RESULT = 'EDITED SUCCESSFULLY'
	  	
		IF @@ERROR = 0
		 BEGIN
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
			SELECT @USERNAME,@FIRSTNAME, @RESULT ,'',''
		 END
		END
 		ELSE
		 BEGIN
			SET @MESSAGE = 'USER DOST NOT EXIST IN SYSTEM!'    
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
			SELECT @USERNAME,@FIRSTNAME, @MESSAGE ,'','' 
		 END 
	 END
   	ELSE	
	 BEGIN
		SELECT   
		 @@ERROR_COUNT = COUNT(FLDUSERNAME)
		FROM     
		 TBLPRADNYAUSERS (NOLOCK)   
		WHERE  
		 FLDUSERNAME =@USERNAME 
		
		IF @@ERROR_COUNT = 0    
		 BEGIN   
				--MAIN CLASS USER TABLE------------------------------  
			INSERT INTO   
			 TBLPRADNYAUSERS  
			(  
			 FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, 
			 FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE,EDIT_FLAG, CREATED_BY, MODIFIED_BY  
			)  
			VALUES  
			(  
			 @USERNAME, @PASSWORD, @FIRSTNAME, @MIDDLENAME, @LASTNAME, @SEX, @ADD1, @MAILADD2, @PHONE1, @PHONE2, @CATEGORY,   
			 @ADMIN_AUTO, @STNAME, @@EXPDATE, @@EDIT_FLAG, @ADMIN_NAME, @ADMIN_NAME   
			)  
		  
			-- CLASS USER LOG TABLE ------------------------------  
			INSERT INTO   
			 TBLPRADNYAUSERS_LOG  
			(  
			 FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2,  
			 FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA  
			)  
			SELECT  
			 FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1,  
			 FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, @@NEWDATE, @@EDIT_FLAG, @ADMIN_NAME, @@NEWDATE, @IPADD, @@FLDLOG_DATA  
			FROM   
			 TBLPRADNYAUSERS  
			WHERE   
			 FLDUSERNAME =@USERNAME  
		 
		 
			SELECT @@FLDAUTO_NEW = FLDAUTO FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERNAME
			
			-- USER CONTROL MASTER TABLE -----------------------------  
			INSERT INTO TBLUSERCONTROLMASTER 
				(
				FLDUSERID,
				FLDPWDEXPIRY,
				FLDMAXATTEMPT,
				FLDATTEMPTCNT,
				FLDSTATUS,
				FLDLOGINFLAG,
				FLDACCESSLVL,
				FLDIPADD,
				FLDTIMEOUT,
				FLDFIRSTLOGIN,
				FLDFORCELOGOUT
				)  
			SELECT   
				A.FLDAUTO, 
				@PWDEXPIRYDAYS, 
				@MAXATTEMPTCOUNT,
				@ATTEMPTCOUNT, 
				@USERSTATUS, 
				0, 
				@ACCESSLEVEL, 
				@USERIPADDRESS, 
				B.FLDTIMEOUT,  
				B.FLDFIRSTLOGIN, 
				B.FLDFORCELOGOUT
			FROM   
				TBLPRADNYAUSERS A LEFT OUTER JOIN TBLUSERCONTROLMASTER X  
			ON   
				(A.FLDAUTO = X.FLDUSERID), TBLUSERCONTROLGLOBALS B  
			WHERE   
				B.FLDCATEGORYID = A.FLDCATEGORY  
				AND ISNULL(A.FLDAUTO,0) = @@FLDAUTO_NEW  
		   
			--LOG USER CONTROL MASTER TABLE -----------------------------  
			  
			INSERT INTO   
			 TBLUSERCONTROLMASTER_JRNL   
			SELECT   
			 *,@@FLDADMINAUTO,@@NEWDATE   
			FROM   
			 TBLUSERCONTROLMASTER  
			WHERE   
			 FLDUSERID = @FLDAUTO  
		  
			--FOR MOBILE USER 
			/*IF @MOB_ACCESS = 1 AND @USERTYPE = 'CLIENT'
			  BEGIN
				INSERT INTO PRADNYA.DBO.USER_INFO (CLIENTID,USERNAME,LASTNAME,MAILID,STATUS_FLAG,EXCHANGE,SEGMENT,LOGIN_FLAG)
				SELECT 
					FLDUSERNAME, FLDFIRSTNAME, FLDLASTNAME, FLDADDRESS2, 1, EXCHANGE = @EXCHANGE+'·', SEGMENT = '|'+@SEGMENT, LOGIN_FLAG = 0 
				FROM 
					TBLPRADNYAUSERS 
				WHERE
					 FLDUSERNAME = @USERNAME  
			  END */  		
			
			SET @RESULT = 'CREATED SUCCESSFULLY..'
	  	
			IF @@ERROR = 0
			 BEGIN
				SELECT  
					FLDUSERNAME, FLDFIRSTNAME, RESULT = @RESULT, EXCHANGE='', SEGMENT = '' INTO #RES 
				FROM 
					TBLPRADNYAUSERS TP, TBLUSERCONTROLMASTER TU
				WHERE
					 FLDUSERNAME = @USERNAME 
					 AND TP.FLDAUTO = TU.FLDUSERID
				
				IF @@ROWCOUNT = 0 
				 BEGIN
					ROLLBACK TRAN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
					SELECT FLDUSERNAME = '',FLDFIRSTNAME = '',RESULT = 'PRADNYA & USER CONTROL MASTER NOT POPULATED PROPERLY!',EXCHANGE = '', SEGMENT = ''
					RETURN	
				 END
				ELSE
				 BEGIN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
					SELECT * FROM #RES
				 END	
			 END 
		  END
		ELSE 
		 BEGIN
			SET @MESSAGE = 'USER ALREADY EXIST IN SYSTEM!'
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)    
			SELECT @USERNAME,'', @MESSAGE ,'','' 
		 END 
	END			
/*END TRY
BEGIN CATCH
	SELECT 
        ERROR_MESSAGE() AS MESSAGE;
		ROLLBACK
END CATCH*/
IF @@ERROR = 0
 BEGIN
	COMMIT TRAN
 END
ELSE
 BEGIN
	ROLLBACK TRAN	
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CREATE_CLASS_USER_ALL
-- --------------------------------------------------
CREATE PROC [dbo].[CREATE_CLASS_USER_ALL]
(
	 @FLDAUTO		VARCHAR(50),	  
	 @USERNAME		VARCHAR(25),  
	 @PASSWORD		VARCHAR(50),  
	 @FIRSTNAME		VARCHAR(25),  
	 @MIDDLENAME	VARCHAR(25),  
	 @LASTNAME		VARCHAR(25),  
	 @SEX			VARCHAR(8),  
	 @ADD1			VARCHAR(100),  
	 @MAILADD2		VARCHAR(100),  
	 @PHONE1		VARCHAR(10),  
	 @PHONE2		VARCHAR(10),   
	 @CATEGORY		VARCHAR(10),  
	 @ADMIN_AUTO	INT,  
	 @STNAME		VARCHAR(50),  
	 @ADMIN_NAME	VARCHAR(30),  
	 @IPADD			VARCHAR(20),  
	 @PWDEXPIRYDAYS SMALLINT,  
	 @USERSTATUS	SMALLINT,  
	 @ATTEMPTCOUNT	SMALLINT,  
	 @MAXATTEMPTCOUNT SMALLINT,  
	 @ACCESSLEVEL	CHAR(1),  
	 @LOGINSTATUS	SMALLINT,
	 @FIRSTLOGIN	CHAR(1),	
	 @USERIPADDRESS VARCHAR(2000),
	 @USERTYPE		VARCHAR(25), 	
	 @EXCHANGE		VARCHAR(3),
	 @SEGMENT		VARCHAR(20),
	 @EXCSEG		VARCHAR(MAX),
	 @CREATION_FLAG VARCHAR(10), --All or Single segment
	 @ACTION_FLAG	VARCHAR(20), -- EDIT OR REGISTER 
	 @FLD_MAC_ID	VARCHAR(200)	
)

AS
/*
BEGIN TRAN
CREATE_CLASS_USER_ALl  '80662',  'AJAY',  'A8EE7FDD1FA67206',  'Ajay',  'n',  'Sengar',  'MALE',  'mumbai',  'a@c.c',  '46454',  '',  '400',  '2',  'Broker',  'Administrator',  '10.11.12.74',  '30',  2,  0,  6,  'F',  0,  'N',  '10.11.12.74',  'Broker',  

'NSE',  'CAPITAL',  '',  'MULTI',  'Edit',
'10.11.12.74,10.111.12.74'  
ROLLBACK	
SELECT FLDAUTO_ADMIN FROM [MTSRVR06\DEV].NSEFO.DBO.TBLADMIN WHERE FLDNAME = 'Broker' 
INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) 
select * from nsefo..tblpradnyausers where fldusername = 'ajay'
EXECUTE CREATE_CLASS_USER_ALL  '',  'All',  'B5A07E53E1EF805D',  'bhrt',  'bhrt',  'bhrt',  'MALE',  'mum',  'a@c.n',  '9898989898',  '9989889898',  '388',  '2',  'Broker',  'Administrator',  '10.11.12.74',  '31',  2,  0,  6,  'F',  0,  'Y',  '',  'Broker',  'NSE',  'CAPITAL',  'BSE~CAPITAL,NSE~CAPITAL,BSE~FUTURES,NSE~FUTURES,',  'Choose',  'Register',  '' 
*/

 CREATE TABLE [DBO].[#DBNAME]  
 (  
	SHAREDB VARCHAR(50),
	SHARESERVER VARCHAR(50),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10)
 ) ON [PRIMARY]  

 CREATE TABLE [DBO].[#RESULT]  
 (  
	UNAME VARCHAR(50),
	FIRSTNAME VARCHAR(50),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10),
	RESULT VARCHAR(100)
 ) ON [PRIMARY]

 CREATE TABLE [DBO].#ADMIN_AUTO
 (
	ADMIN_AUTO INT	
 ) ON [PRIMARY]

 CREATE TABLE [DBO].#MKCK
 (
	MKCKFLAG INT	
 )
	
 CREATE TABLE [DBO].#CATEGORY
 (
	CATEGORY VARCHAR(50),
	CATEGORYCODE INT
 ) ON [PRIMARY]
 CREATE TABLE [DBO].#PRADNYA
 (
	FLDAUTO	INT,
	FLDADMINAUTO INT
 )

DECLARE  
 @@SHAREDB VARCHAR(20),	  
 @@SHARESVR VARCHAR(20),  
 @@EXCHANGE VARCHAR(15),  
 @@SEGMENT VARCHAR(15),  
 @@ORDERFLAG VARCHAR(1),  
 @@SQL VARCHAR(5000),
 @@DB VARCHAR(MAX),
 @@SEGORD TINYINT,
 @@FLDNAME VARCHAR(30),	
 @@CATFLAG INT,	  
 @@CATNAME VARCHAR(50),
 @@MKCKFLAG INT,
 @@FLDAUTO	INT,
 @@FLDADMINAUTO INT,	 	
 @@MAINREC AS CURSOR  
 

	SELECT @@FLDNAME = FLDNAME FROM TBLADMIN WHERE FLDAUTO_ADMIN = @ADMIN_AUTO
	SELECT @@CATNAME = FLDCATEGORYNAME FROM TBLCATEGORY WHERE FLDCATEGORYCODE = @CATEGORY
	
	SET @@DB = " INSERT INTO #DBNAME "   
	SET @@DB = @@DB + " SELECT "
	SET @@DB = @@DB + "		SHAREDB, SHARESERVER, EXCHANGE, SEGMENT "
	SET @@DB = @@DB + " FROM "
	SET @@DB = @@DB + "		PRADNYA.DBO.MULTICOMPANY (NOLOCK) "
	SET @@DB = @@DB + " WHERE "
	SET @@DB = @@DB + " 	PRIMARYSERVER = 1 "
	IF UPPER(@CREATION_FLAG) = 'CHOOSE'
	 BEGIN	
		SET @@DB = @@DB + "		AND EXCHANGE+'~'+SEGMENT IN ('" + REPLACE(@EXCSEG,',',''',''') + "')  "
	 END
	ELSE
	 IF UPPER(@CREATION_FLAG) = 'SIN'
	  BEGIN	
		SET @@DB = @@DB + "		AND EXCHANGE+'~'+SEGMENT IN ( '"+@EXCHANGE+"' +'~'+ '"+@SEGMENT+"' ) "
      END 
	 		
	SET @@DB = @@DB + " ORDER BY "
	SET @@DB = @@DB + "		EXCHANGE "  

	PRINT @@DB
	EXEC(@@DB)  

	SET @@MAINREC = CURSOR FOR  
	
	SELECT SHAREDB, SHARESERVER, EXCHANGE, SEGMENT FROM #DBNAME  
	SET @@SEGORD = 1  
	
	OPEN @@MAINREC  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT  
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			IF @@SHARESVR <> @@SERVERNAME 
				BEGIN
					
					SET @@SQL = " INSERT INTO #ADMIN_AUTO SELECT FLDAUTO_ADMIN FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLADMIN WHERE FLDNAME = '"+ @@FLDNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #CATEGORY SELECT FLDCATEGORYNAME,FLDCATEGORYCODE FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLCATEGORY WHERE FLDCATEGORYNAME = '"+ @@CATNAME + "' "
					SET @@SQL = @@SQL + " INSERT INTO #MKCK SELECT MKCKFLAG FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLGLOBALPARAMS "
					SET @@SQL = @@SQL + " INSERT INTO #PRADNYA SELECT FLDAUTO, FLDADMINAUTO FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+@USERNAME+"' "
				END
			 ELSE
				BEGIN	
					SET @@SQL = " INSERT INTO #ADMIN_AUTO SELECT FLDAUTO_ADMIN FROM " + @@SHAREDB + ".DBO.TBLADMIN WHERE FLDNAME = '"+ @@FLDNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #CATEGORY SELECT FLDCATEGORYNAME,FLDCATEGORYCODE FROM " + @@SHAREDB + ".DBO.TBLCATEGORY WHERE FLDCATEGORYNAME = '"+ @@CATNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #MKCK SELECT MKCKFLAG FROM " + @@SHAREDB + ".DBO.TBLGLOBALPARAMS "
					SET @@SQL = @@SQL + " INSERT INTO #PRADNYA SELECT FLDAUTO, FLDADMINAUTO FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+@USERNAME+"' "
				END
		
			PRINT @@SQL	
			EXEC(@@SQL)

			SELECT @@MKCKFLAG = MKCKFLAG FROM #MKCK
			--SELECT @@FLDAUTO = FLDAUTO, @@FLDADMINAUTO = FLDADMINAUTO FROM #PRADNYA	 				
			SELECT @CATEGORY = CATEGORYCODE FROM #CATEGORY 
			SELECT @ADMIN_AUTO = ADMIN_AUTO FROM #ADMIN_AUTO
			
						
			IF @@ROWCOUNT = 0 
			 BEGIN
				INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) VALUES('','','ADMINISTRATOR IS NOT AVAILABLE IN THIS EXCH - SEG','','')
			 END
			ELSE
			 IF (SELECT COUNT(1) FROM #CATEGORY ) = 0
				BEGIN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) VALUES('','','USER CATEGORY IS NOT AVAILABLE IN THIS EXCH - SEG','','')		
				END			
			ELSE
			 BEGIN	
			 --SET @@SQL = " INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) "
			 IF @@SHARESVR <> @@SERVERNAME 
				BEGIN
					SET @@SQL = @@SQL + " EXEC " + @@SHARESVR + "." + @@SHAREDB + ".DBO.CREATE_CLASS_USER "
				END
			 ELSE
				BEGIN	
					SET @@SQL = @@SQL + " EXEC " + @@SHAREDB + ".DBO.CREATE_CLASS_USER "
				END
			SET @@SQL = @@SQL + "  '" + @FLDAUTO + "' "
			SET @@SQL = @@SQL + ", '" + @USERNAME + "' "
			SET @@SQL = @@SQL + ", '" + @PASSWORD + "' "
			SET @@SQL = @@SQL + ", '" + @FIRSTNAME + "' "
			SET @@SQL = @@SQL + ", '" + @MIDDLENAME + "' "
			SET @@SQL = @@SQL + ", '" + @LASTNAME + "' "
			SET @@SQL = @@SQL + ", '" + @SEX + "' "
			SET @@SQL = @@SQL + ", '" + @ADD1 + "' "
			SET @@SQL = @@SQL + ", '" + @MAILADD2 + "' "
			SET @@SQL = @@SQL + ", '" + @PHONE1 + "' "
			SET @@SQL = @@SQL + ", '" + @PHONE2 + "' "
			SET @@SQL = @@SQL + ", '" + @CATEGORY + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@ADMIN_AUTO) + " "
			SET @@SQL = @@SQL + ", '" + @STNAME + "' "
			SET @@SQL = @@SQL + ", '" + @ADMIN_NAME + "' "
			SET @@SQL = @@SQL + ", '" + @IPADD + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@PWDEXPIRYDAYS) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,CASE WHEN @@MKCKFLAG = 0 THEN 0 ELSE @USERSTATUS END) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@ATTEMPTCOUNT) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@MAXATTEMPTCOUNT) + " "
			SET @@SQL = @@SQL + ", '" + @ACCESSLEVEL + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@LOGINSTATUS) + " "
			SET @@SQL = @@SQL + ", '" + @FIRSTLOGIN + "' "
			SET @@SQL = @@SQL + ", '" + @USERIPADDRESS + "' "
			SET @@SQL = @@SQL + ", '" + @USERTYPE + "' "
			SET @@SQL = @@SQL + ", '" + @EXCHANGE + "' " 
			SET @@SQL = @@SQL + ", '" + @SEGMENT + "' " 
			SET @@SQL = @@SQL + ", '" + @CREATION_FLAG + "' " 
			SET @@SQL = @@SQL + ", '" + @ACTION_FLAG + "' " 
			SET @@SQL = @@SQL + ", '" + @FLD_MAC_ID + "' " 
			PRINT (@@SQL)
			EXEC(@@SQL)
		   END	

			UPDATE 
				#RESULT
			SET 
				EXCHANGE = @@EXCHANGE,
				SEGMENT = @@SEGMENT
			WHERE 
				EXCHANGE = '' AND SEGMENT = ''
			
			TRUNCATE TABLE #ADMIN_AUTO
			TRUNCATE TABLE #MKCK
			TRUNCATE TABLE #CATEGORY		
	SET @@SEGORD = @@SEGORD + 1  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT
	END 

	SELECT * FROM #RESULT
	TRUNCATE TABLE #DBNAME  
	DROP TABLE #DBNAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CREATEMENU
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_CUSTODIAN
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_CUSTODIAN]   
(  
 @INITIAL VARCHAR(10)  
)  
AS  
SELECT DISTINCT CUSTODIANCODE   
FROM MSAJAG..CUSTODIAN    
WHERE CUSTODIANCODE LIKE  @INITIAL+'%'  
order by 1 asc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_PARTYCODE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_PARTYCODE]
(
	@INITIAL VARCHAR(10)
)
AS
SELECT DISTINCT C2.PARTY_CODE, PARTYNAME = C1.LONG_NAME  
FROM MSAJAG..CLIENT1 C1 ,MSAJAG..CLIENT2 C2  
WHERE C2.PARTY_CODE LIKE @INITIAL+'%'
AND C1.CL_CODE = C2.CL_CODE  
--AND 'BROKER' = (  CASE  WHEN 'BROKER' = 'BRANCH' THEN C1.BRANCH_CD  WHEN 'BROKER' = 'SUBBROKER' THEN C1.SUB_BROKER  WHEN 'BROKER' = 'TRADER' THEN C1.TRADER  WHEN 'BROKER' = 'FAMILY' THEN C1.FAMILY  WHEN 'BROKER' = 'AREA' THEN C1.AREA  WHEN 'BROKER' = 'REGION' THEN C1.REGION  WHEN 'BROKER' = 'CLIENT' THEN C2.PARTY_CODE  ELSE 'BROKER' END)  
ORDER BY 1 ASC

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_SEARCH_SHAREDB
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[F2_SEARCH_SHAREDB]
(
@FROMCODE	varchar(11),
@TOCODE	varchar(11)='',
@SEARCHWHAT varchar(10),-----party, famliy,area,branch,region,sub_broker,trader
@STATUSID VARCHAR(15),
@STATUSNAME VARCHAR(15),
@CLTYPE VARCHAR(3)

)
as
/*
exec F2_SEARCH_SHAREDB '0','zz','PARENT','broker','broker',''

exec nsemfss..[F2_SEARCH_SHAREDB] 'A','B','TRADER','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'TRADER','A','S','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] '0','zz','AREA','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'sub_broker','h','','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'branch','1','','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'REGION','1','','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'area','A','K','BROKER','BROKER'
exec nsemfss..[F2_SEARCH_SHAREDB] 'parent','a','','BROKER','BROKER'
SELECT DISTINCT SUB_BROKER FROM MSAJAG..CLIENT_INFO
SELECT * FROM NSEMFSS..SUBBROKERS
SELECT DISTINCT SUB_BROKER FROM MFSS_CLIENT
exec nsemfss..[F2_SEARCH_SHAREDB] '0','','TRADER','BROKER','BROKER',''

*/


SELECT DISTINCT CODE,SHORT_NAME AS NAME FROM UFN_LOGINCHECK('', '', @STATUSID, @STATUSNAME, @SEARCHWHAT, @FROMCODE, @TOCODE,@CLTYPE)        


	
--		SELECT DISTINCT PARTY_CODE AS CODE, LONG_NAME AS NAME 
--			FROM CLIENT_INFO C1
--				WHERE PARTY_CODE LIKE @FROMCODE+'%' 
--						AND @STATUSNAME = (  CASE @STATUSID WHEN 'BRANCH' THEN C1.BRANCH_CD  WHEN 'FAMILY' THEN C1.FAMILY  WHEN 'AREA' THEN C1.AREA  WHEN 'REGION' THEN C1.REGION  WHEN 'CLIENT' THEN C1.PARTY_CODE  ELSE 'BROKER' END)  AND C1.PARTY_CODE >= '0' ORDER BY 1 ASC
--	END
--ELSE IF @SEARCHWHAT = 'PARTY' AND @TOCODE <> ''
--	BEGIN
--		SELECT DISTINCT PARTY_CODE AS CODE, LONG_NAME AS NAME 
--			FROM CLIENT_INFO C1
--				WHERE PARTY_CODE >= @FROMCODE   AND  PARTY_CODE < =@TOCODE
						
--						AND @STATUSNAME = (  CASE @STATUSID WHEN 'BRANCH' THEN C1.BRANCH_CD  WHEN 'SUBBROKER' THEN C1.SUB_BROKER  WHEN  'TRADER' THEN C1.TRADER  WHEN 'FAMILY' THEN C1.FAMILY  WHEN  'AREA' THEN C1.AREA  WHEN 'REGION' THEN C1.REGION  WHEN 'CLIENT' THEN C1.PARTY_CODE  ELSE 'BROKER' END)  AND C1.PARTY_CODE >= '0' ORDER BY 1 ASC
--	END
----=======================================================================================================----------------	
--ELSE IF @SEARCHWHAT = 'FAMILY' AND @TOCODE =''
--BEGIN
--		SELECT DISTINCT C1.FAMILY AS CODE, C1.LONG_NAME  AS NAME
--			FROM CLIENT_INFO C1
--				WHERE 
--					C1.FAMILY LIKE @FROMCODE+'%' 
--					AND @STATUSNAME = (  CASE @STATUSID WHEN  'BRANCH' THEN C1.BRANCH_CD  WHEN 'SUBBROKER' THEN C1.SUB_BROKER  WHEN 'TRADER' THEN C1.TRADER  WHEN 'FAMILY' THEN C1.FAMILY  WHEN 'AREA' THEN C1.AREA  WHEN 'REGION' THEN C1.REGION  WHEN 'CLIENT' THEN C1.PARTY_CODE  ELSE 'BROKER' END)  AND C1.PARTY_CODE >= '0' ORDER BY 1 ASC
--END
--ELSE IF @SEARCHWHAT = 'FAMILY' AND @TOCODE <> ''
--BEGIN
--		SELECT DISTINCT C1.FAMILY AS CODE, C1.LONG_NAME  AS NAME
--			FROM CLIENT_INFO C1
--				WHERE 
--					C1.FAMILY >= @FROMCODE AND  C1.FAMILY <= @TOCODE
--					AND @STATUSNAME = (  CASE @STATUSID WHEN 'BRANCH' THEN C1.BRANCH_CD  WHEN 'SUBBROKER' THEN C1.SUB_BROKER  WHEN 'TRADER' THEN C1.TRADER  WHEN 'FAMILY' THEN C1.FAMILY  WHEN 'AREA' THEN C1.AREA  WHEN  'REGION' THEN C1.REGION  WHEN 'CLIENT' THEN C1.PARTY_CODE  ELSE 'BROKER' END)  AND C1.PARTY_CODE >= '0' ORDER BY 1 ASC
--END
----=======================================================================================================----------------
--ELSE IF @SEARCHWHAT = 'SUBBROKER' AND @TOCODE =''
--BEGIN
--		SELECT  DISTINCT SB.SUB_BROKER AS CODE,NAME
--			FROM SUBBROKERS SB 
--				WHERE SB.SUB_BROKER LIKE @FROMCODE+'%' 
--				ORDER BY 1 ASC
--END	
--ELSE IF @SEARCHWHAT = 'SUBBROKER' AND @TOCODE <> ''

--BEGIN
--	SELECT  DISTINCT SB.SUB_BROKER AS CODE,NAME
--			FROM SUBBROKERS SB 
--				WHERE SB.SUB_BROKER >= @FROMCODE AND  SB.SUB_BROKER <= @TOCODE
--				ORDER BY 1 ASC

--END
----=======================================================================================================----------------
--IF @SEARCHWHAT = 'AREA' AND @TOCODE =''
--BEGIN
--		SELECT DISTINCT AREACODE AS CODE,[DESCRIPTION]AS NAME
--			FROM AREA
--				WHERE 
--					[DESCRIPTION] LIKE @FROMCODE+'%' ORDER BY 1 ASC
--END
--ELSE IF @SEARCHWHAT = 'AREA' AND @TOCODE <> ''
--BEGIN
--		SELECT DISTINCT AREACODE AS CODE,[DESCRIPTION]AS NAME
--			FROM AREA
--				WHERE 
--					[DESCRIPTION] >= @FROMCODE AND  [DESCRIPTION] <= @TOCODE ORDER BY 1 ASC	
--END
----=======================================================================================================----------------
--ELSE IF @SEARCHWHAT = 'REGION' AND @TOCODE =''
--BEGIN
--SELECT DISTINCT REGIONCODE AS CODE ,[DESCRIPTION] AS NAME FROM REGION WHERE [DESCRIPTION] LIKE '%' ORDER BY 1 ASC
--END
--ELSE IF @SEARCHWHAT = 'REGION' AND @TOCODE <> ''
--BEGIN
--SELECT DISTINCT REGIONCODE AS CODE ,[DESCRIPTION] AS NAME  FROM REGION WHERE [DESCRIPTION] >=@FROMCODE AND [DESCRIPTION] <= @TOCODE ORDER BY 1 ASC
--END
----=======================================================================================================----------------
--ELSE IF @SEARCHWHAT = 'BRANCH' AND @TOCODE =''
--BEGIN
--		SELECT DISTINCT BRANCH_CODE AS CODE,BRANCH AS NAME
--			FROM BRANCH 
--				WHERE BRANCH_CODE LIKE @FROMCODE+'%' 
--					ORDER BY 1 ASC
--END
--ELSE IF @SEARCHWHAT = 'BRANCH' AND @TOCODE <> ''
--BEGIN 
--		SELECT DISTINCT BRANCH_CODE AS CODE,BRANCH  AS NAME
--					FROM BRANCH 
--						WHERE BRANCH_CODE >= @FROMCODE AND BRANCH_CODE <= @TOCODE
--							ORDER BY 1 ASC

--END
-- --=======================================================================================================----------------
--ELSE IF @SEARCHWHAT = 'TRADER' AND @TOCODE =''
--BEGIN
--	SELECT DISTINCT BR.SHORT_NAME AS CODE,BR.BRANCH_CD as NAME
--		FROM BRANCHES BR 
--			WHERE BR.SHORT_NAME LIKE @FROMCODE+'%' 
--				ORDER BY 1 ASC
--END
--ELSE IF @SEARCHWHAT = 'TRADER' AND @TOCODE <> ''
--BEGIN
--	SELECT DISTINCT BR.SHORT_NAME AS CODE,BR.BRANCH_CD as NAME
--		FROM BRANCHES BR 
--			WHERE BR.SHORT_NAME >= @FROMCODE AND BR.SHORT_NAME <= @TOCODE 
--				ORDER BY 1 ASC
--END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_SEARCHPARTY
-- --------------------------------------------------
  --exec F2_SEARCHPARTY 'a','z','nse','capital','broker','broker','party','%'  
CREATE  PROCEDURE [dbo].[F2_SEARCHPARTY]          
(          
 @FROMCODE VARCHAR(20) = '0',                  
 @TOCODE VARCHAR(20) = 'ZZZZZZZZZZ',            
 @EXCHANGE UDTEXCHANGE = '',                  
 @SEGMENT UDTSEGMENT = '',                  
 @STATUSID VARCHAR(25),                  
 @STATUSNAME VARCHAR(25),                  
 @SEARCHWHAT VARCHAR(20) = 'PARTY',                  
 @CLTYPE VARCHAR(3) = ''       
)          
AS       
 SET NOCOUNT ON;          
 IF @FROMCODE = ''        
 SET @FROMCODE = '0'        
 IF @TOCODE = ''        
 SET @TOCODE = 'ZZZZZ'        
         
SELECT TOP 100  CODE, SHORT_NAME FROM UFN_LOGINCHECK          
(@EXCHANGE, @SEGMENT, @STATUSID, @STATUSNAME, @SEARCHWHAT, @FROMCODE,@TOCODE,@CLTYPE)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_SHARE_SETT_N_SCRIP
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_SHARE_SETT_N_SCRIP]
(
@FROMCODE	VARCHAR(20)='0',
@TOCODE		VARCHAR(20)='zz',
--@TODATE		VARCHAR(12),
@FOR		VARCHAR(10),----SETTNO,SETT_TYPE,SCRIP
@STATUSID	VARCHAR(15),
@STATUSNAME	VARCHAR(15),
@SETT_TYPE  VARCHAR(3)

)
/*
EXEC F2_SHARE_SETT_N_SCRIP '','','SETT_TYPE','','',''
	SELECT DISTINCT SETT_NO FROM SETT_MST WHERE SETT_TYPE LIKE 'U' AND SETT_NO LIKE '2%'
	SELECT * FROM SETT_MST
	EXEC F2_SHARE_SETT_N_SCRIP '','','SCRIP',''
	select distinct Scrip_cd from MSAJAG.DBO.scrip2 where scrip_cd like '%'  order by 1 asc
*/
AS

SELECT CODE,SHORT_NAME AS NAME FROM UFN_LOGINCHECK('', '', @STATUSID, @STATUSNAME, @FOR, @FROMCODE, @TOCODE,@SETT_TYPE)        

--IF @FOR ='SETT_NO' 
--	BEGIN
--		SELECT DISTINCT SETT_NO AS CODE FROM SETT_MST WHERE SETT_TYPE LIKE @SETT_TYPE+'%' AND SETT_NO LIKE @FROM+'%' AND END_DATE >= @TODATE   order by 1 asc
--	END
--IF @FOR ='SETT_TYPE'
--	BEGIN
--	SELECT DISTINCT SETT_TYPE AS CODE FROM SETT_MST WHERE END_DATE > = @TODATE  ORDER BY 1 ASC
--	END	
--IF @FOR ='SCRIP'
--	BEGIN
--	SELECT DISTINCT SCRIP_CD FROM MFSS_SCRIP_MASTER WHERE SCRIP_CD LIKE @FROM+'%'  ORDER BY 1 ASC
--	END
	
--SELECT * FROM MFSS_SCRIP_MASTER

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_SYMBOL
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_SYMBOL]   
(  
 @INITIAL VARCHAR(10)  
)  
AS  
SELECT DISTINCT SYMBOL   
FROM NSEFO..foclosing    
WHERE SYMBOL LIKE  @INITIAL+'%'  
order by symbol

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_SYMBOL_FOR_SECURITIESRPT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_SYMBOL_FOR_SECURITIESRPT]
(

@SYMBOL  VARCHAR(12),
@ACTIVE_SCRIP_FLAG VARCHAR(2),
@INST_TYPE VARCHAR(6)
)
AS
/*
EXEC F2_SYMBOL_FOR_SECURITIESRPT 'N','0','OPTIDX'
*/
SELECT DISTINCT SYMBOL 
FROM NSEFO..FOSCRIP2 (NOLOCK) WHERE SYMBOL LIKE @SYMBOL+'%' 
AND INST_TYPE = @INST_TYPE
AND 1 = CASE WHEN @ACTIVE_SCRIP_FLAG = 0 THEN 1 ELSE CASE WHEN EXPIRYDATE >= GETDATE() THEN 1 ELSE 2 END END ORDER BY SYMBOL

GO

-- --------------------------------------------------
-- PROCEDURE dbo.F2_TERMINALID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[F2_TERMINALID] 
(
	@INITIAL VARCHAR(10)
)
AS
SELECT DISTINCT USERID,TRADELIMIT = ISNULL(TRADELIMIT,'')  
FROM MSAJAG..TERMLIMIT    
WHERE USERID LIKE  @INITIAL+'%'
order by 1 asc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FILELISTPROC
-- --------------------------------------------------
CREATE  PROC [DBO].[FILELISTPROC] (@FILEPATH VARCHAR(100) )        
AS         
      
DECLARE @NEWFILEPATH VARCHAR(100)      
      
SET @NEWFILEPATH = REPLACE(@FILEPATH, '*.TXT', '*.*')      
CREATE TABLE #FILELIST         
( FILENAMELIST VARCHAR(100))        
INSERT INTO #FILELIST         
EXEC MASTER.DBO.XP_CMDSHELL @NEWFILEPATH        
  
SELECT * FROM #FILELIST

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_BDPID_BCLTDPID
-- --------------------------------------------------
--GET_BDPID_BCLTDPID 'bsemfss'
CREATE PROC [dbo].[GET_BDPID_BCLTDPID] 
(
	@SHAREDB VARCHAR(20) 
)
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX),
			@SQL1 VARCHAR(MAX)
	--SET @SQL = 	@SHAREDB + '..DELTRANS'
   

	SET @SQL = 'SELECT DISTINCT BDPID FROM ' + @SHAREDB + '..DELTRANS' + ' ORDER BY BDPID ' 
exec(@SQL)
	SET @SQL1 = 'SELECT DISTINCT BCLTDPID FROM ' + @SHAREDB + '..DELTRANS' + ' ORDER BY BCLTDPID'
exec(@SQL1) 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_BRANCH_CD
-- --------------------------------------------------
CREATE PROC [dbo].[GET_BRANCH_CD]
AS
BEGIN
	SELECT DISTINCT BRANCH_CD FROM MSAJAG..CLIENT1 ORDER BY BRANCH_CD
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_DPID_DPCLTNO
-- --------------------------------------------------
--exec GET_DPID_DPCLTNO 'bsmfss'
CREATE PROC [dbo].[GET_DPID_DPCLTNO]
(
	@SHAREDB VARCHAR(20) 
)
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX),
			@SQL1 VARCHAR(MAX)

	SET @SQL ='SELECT DISTINCT DPID FROM ' + @SHAREDB + '..DELIVERYDP ORDER BY DPID'
	exec(@SQL)

	SET @SQL1 ='SELECT DISTINCT DPCLTNO FROM ' + @SHAREDB + '..DELIVERYDP ORDER BY DPCLTNO'
	exec(@SQL1)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_IDUSER_LIST
-- --------------------------------------------------
CREATE PROC [dbo].[GET_IDUSER_LIST]
(
	@IDUSER VARCHAR(30)
)

AS

SET @IDUSER = UPPER(@IDUSER)

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
IF @IDUSER = 'BRANCH'
	BEGIN
		SELECT DISTINCT BRANCH_CODE, BRANCH = UPPER(BRANCH) FROM BRANCH (NOLOCK) ORDER BY BRANCH
	END
ELSE IF @IDUSER = 'SUBBROKER'
	BEGIN 
		SELECT DISTINCT SUB_BROKER, NAME = UPPER(NAME) FROM SUBBROKERS (NOLOCK) WHERE SUB_BROKER <> '' AND NAME <> '' ORDER BY NAME	
	END
ELSE IF @IDUSER = 'TRADER'
	BEGIN
	SELECT DISTINCT SHORT_NAME,LONG_NAME FROM BRANCHES (NOLOCK) WHERE SHORT_NAME <> '' AND LONG_NAME <> '' ORDER BY LONG_NAME 
	END
ELSE IF @IDUSER = 'AREA'
	BEGIN
		SELECT DISTINCT AREACODE,DESCRIPTION FROM AREA (NOLOCK) ORDER BY DESCRIPTION
	END	
ELSE IF @IDUSER = 'REGION'
	BEGIN
		SELECT DISTINCT REGIONCODE,DESCRIPTION FROM REGION (NOLOCK) ORDER BY DESCRIPTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_PWD_EXPIRY
-- --------------------------------------------------
CREATE PROC GET_PWD_EXPIRY  
(  
  @UNAME VARCHAR(100)  
)  
AS  
SELECT LTRIM(RTRIM(T.FLDFIRSTNAME)) AS FIRSTNAME,     
 CASE WHEN DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 2  THEN  'THE DAY AFTER TOMORROW'    
 ELSE    
  CASE WHEN  DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 1  THEN  'TOMORROW'    
 ELSE    
 CASE WHEN  DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 0  THEN  '<U>TODAY</U>'    
 ELSE    
 'ON ' + LEFT(CONVERT(VARCHAR, T.PWD_EXPIRY_DATE, 109), 11)    
END   
END   
END    
 AS PWD_EXPIRY_DATE    
 FROM    
 TBLPRADNYAUSERS T, TBLADMIN A   
 WHERE    
 T.FLDADMINAUTO = A.FLDAUTO_ADMIN    
 AND T.FLDUSERNAME = @UNAME   
 AND GETDATE() <= T.PWD_EXPIRY_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_SETTYPE_SETTNO
-- --------------------------------------------------
-- exec GET_SETTYPE_SETTNO '2','bsemfss'
CREATE PROC [dbo].[GET_SETTYPE_SETTNO]
(
	@FLAG VARCHAR(2),
	@SHAREDB VARCHAR(20) 
)
AS
BEGIN  
  DECLARE @SQL VARCHAR(MAX),
		  @SQL1 VARCHAR(MAX)
  IF @FLAG='1'
	BEGIN
		SET @SQL='SELECT DISTINCT SETT_TYPE FROM ' + @SHAREDB + '..DELIVERYCLT WHERE SETT_TYPE IN (''A'',''X'')'
		EXEC(@SQL)
		SET @SQL1='SELECT DISTINCT SETT_NO  FROM ' + @SHAREDB + '..DELIVERYCLT WHERE SETT_TYPE IN (''A'',''X'') ORDER BY SETT_NO DESC'
		EXEC(@SQL1)
	END
  ELSE
	BEGIN
		SET @SQL='SELECT DISTINCT SETT_NO FROM ' + @SHAREDB + '..DELIVERYCLT ORDER BY SETT_NO DESC'
		EXEC(@SQL)
		SET @SQL1='SELECT DISTINCT SETT_TYPE FROM ' + @SHAREDB + '..DELIVERYCLT ORDER BY SETT_TYPE DESC'
		EXEC(@SQL1)
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_USER_CATEGORY
-- --------------------------------------------------

CREATE PROC GET_USER_CATEGORY  
(  
  @FLDCATEGORY INT  
)  
AS  
SELECT FLDCATEGORYNAME FROM TBLCATEGORY WHERE FLDCATEGORYCODE = @FLDCATEGORY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_USER_FOREDIT
-- --------------------------------------------------
CREATE PROC [dbo].[GET_USER_FOREDIT]
(
	@FLDAUTO INT
)
AS
/*
GET_USER_FOREDIT 81848
select * from TBLUSERCONTROLMASTER where flduserid = 81848
*/
SELECT 
	T.FLDAUTO,
	FLDUSERNAME,
	FLDPASSWORD,
	FLDFIRSTNAME,
	FLDMIDDLENAME,
	FLDLASTNAME,
	FLDSEX,
	FLDADDRESS1,
	FLDADDRESS2,
	FLDPHONE1,	
	FLDPHONE2,	
	FLDCATEGORY,
	FLDADMINAUTO,
	FLDSTNAME,
	PWD_EXPIRY_DATE,
	TB.FLDPWDEXPIRY,
	TB.FLDMAXATTEMPT,
	TB.FLDATTEMPTCNT,
	TB.FLDSTATUS,
	TB.FLDLOGINFLAG,
	TB.FLDACCESSLVL,
	TB.FLDIPADD,
	TB.FLDFIRSTLOGIN,
	TB.FLDFORCELOGOUT
FROM 
	TBLPRADNYAUSERS T, TBLUSERCONTROLMASTER TB
WHERE
	T.FLDAUTO = @FLDAUTO  
	AND T.FLDAUTO = FLDUSERID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GETBRANCHDATA
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GETBRANCHDATA]  
AS  
SELECT DISTINCT BRANCH_CODE FROM MSAJAG..BRANCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GETPROD_PARENT
-- --------------------------------------------------
CREATE PROC [dbo].[GETPROD_PARENT]
(
	@FROMCODE VARCHAR(20) = '0',                  
	@TOCODE VARCHAR(20) = 'ZZZZZZZZZZ',            
	@EXCHANGE VARCHAR(11),
	@SEGMENT VARCHAR(11),                  
	@STATUSID VARCHAR(25),                  
	@STATUSNAME VARCHAR(25),                  
	@SEARCHWHAT VARCHAR(20),                  
	@CLTYPE VARCHAR(3) = '' ,
	@SHAREDB VARCHAR(22)
)
AS
/*
	exec getprod_parent '0','zz','NSE','CAPITAL','BROKER','BROKER','MSAJAG','','PRODUCT'
*/
BEGIN
	DECLARE @SQL VARCHAR(MAX)
	SET @SQL="SELECT CODE,SHORT_NAME FROM "
	/*SET @SQL=@SQL+@SHAREDB*/
	set @sql=@sql+"msajag"
	SET @SQL=@SQL+"..UFN_LOGINCHECK('"
	SET @SQL=@SQL+@EXCHANGE+"','"
	SET @SQL=@SQL+@SEGMENT+"','"
	SET @SQL=@SQL+@STATUSID+"','"
	SET @SQL=@SQL+@STATUSNAME+"','"
	SET @SQL=@SQL+@SEARCHWHAT+"','"
	SET @SQL=@SQL+@FROMCODE+"','"
	SET @SQL=@SQL+@TOCODE+"','"
	SET @SQL=@SQL+@CLTYPE+"')"
	
	PRINT @SQL
	EXEC(@SQL)
	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GETSETTYPE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GETSETTYPE]   
   
 @SETT_TYPE VARCHAR(2),  
 @SETT_NO VARCHAR(10),  
 @PA_FLG VARCHAR(2),  
    @PA_PARTY VARCHAR(10),  
 @SHAREDB VARCHAR(20) = 'NSEMFSS'  
  
AS  
/*  
  EXEC GETSETTYPE '','',''  
  EXEC GETSETTYPE 'A','',''  
  EXEC GETSETTYPE '','','', '','BSEMFSS'
*/  
BEGIN  
 DECLARE @SQL VARCHAR(MAX)  
 SET @SQL = ''  
 IF @SHAREDB = ''  
  SET @SHAREDB = 'NSEMFSS'  
 IF @SETT_TYPE='' AND @SETT_NO=''  
  BEGIN  
   SET @SQL = 'SELECT DISTINCT SETT_TYPE FROM ' + @SHAREDB + '..DEMATTRANS ORDER BY SETT_TYPE'  
  END  
 ELSE IF @SETT_TYPE <>'' AND @SETT_NO=''  
  BEGIN  
   SET @SQL = 'SELECT DISTINCT SETT_NO FROM ' + @SHAREDB + '..DEMATTRANS WHERE SETT_TYPE= ''' + @SETT_TYPE + ''' ORDER BY SETT_NO DESC'  
  END  
 ELSE IF @SETT_TYPE <>'' AND @SETT_NO<>''  
  BEGIN  
     IF @PA_FLG = '1'   
   BEGIN  
               IF @PA_PARTY = 'missing'  
    BEGIN    
     SET @SQL = 'SELECT DISTINCT PARTY_CODE '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY PARTY_CODE'  
    END  
               ELSE  
    BEGIN    
     SET @SQL = 'SELECT DISTINCT PARTY_CODE '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY PARTY_CODE'  
    END  
            END      
               
   --END  
   if @PA_FLG = '2'  
   BEGIN  
                IF @PA_PARTY = 'missing'  
      BEGIN   
     SET @SQL = 'SELECT DISTINCT SCRIP_CD '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY SCRIP_CD'  
      END   
    ELSE   
      BEGIN   
     SET @SQL = 'SELECT DISTINCT SCRIP_CD '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY SCRIP_CD'  
      END   
   END  
   IF @PA_FLG = '3'  
   BEGIN  
    IF @PA_PARTY = 'missing'  
      BEGIN   
     SET @SQL = 'SELECT DISTINCT Left(Convert(Varchar,Trdate,109),11) as TDate '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY TDate'  
      END  
    ELSE   
      BEGIN  
     SET @SQL = 'SELECT DISTINCT Left(Convert(Varchar,Trdate,109),11) as TDate '  
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '  
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY TDate'  
      END   
     END  
        END  
END  
print @sql  
exec(@sql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GETSETTYPE_11032013
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GETSETTYPE_11032013]     
     
 @SETT_TYPE VARCHAR(2),    
 @SETT_NO VARCHAR(10),    
 @PA_FLG VARCHAR(2),    
    @PA_PARTY VARCHAR(10),    
 @SHAREDB VARCHAR(20) = 'NSEMFSS'    
    
AS    
/*    
  EXEC GETSETTYPE '','',''    
  EXEC GETSETTYPE 'A','',''    
  EXEC GETSETTYPE '','','', '','BSEMFSS'  
*/    
BEGIN    
 DECLARE @SQL VARCHAR(MAX)    
 SET @SQL = ''    
 IF @SHAREDB = ''    
  SET @SHAREDB = 'NSEMFSS'    
 IF @SETT_TYPE='' AND @SETT_NO=''    
  BEGIN    
   SET @SQL = 'SELECT DISTINCT SETT_TYPE FROM ' + @SHAREDB + '..DEMATTRANS ORDER BY SETT_TYPE'    
  END    
 ELSE IF @SETT_TYPE <>'' AND @SETT_NO=''    
  BEGIN    
   SET @SQL = 'SELECT DISTINCT SETT_NO FROM ' + @SHAREDB + '..DEMATTRANS WHERE SETT_TYPE= ''' + @SETT_TYPE + ''' ORDER BY SETT_NO DESC'    
  END    
 ELSE IF @SETT_TYPE <>'' AND @SETT_NO<>''    
  BEGIN    
     IF @PA_FLG = '1'     
   BEGIN    
               IF @PA_PARTY = 'missing'    
    BEGIN      
     SET @SQL = 'SELECT DISTINCT PARTY_CODE '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY PARTY_CODE'    
    END    
               ELSE    
    BEGIN      
     SET @SQL = 'SELECT DISTINCT PARTY_CODE '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY PARTY_CODE'    
    END    
            END        
                 
   --END    
   if @PA_FLG = '2'    
   BEGIN    
                IF @PA_PARTY = 'missing'    
      BEGIN     
     SET @SQL = 'SELECT DISTINCT SCRIP_CD '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY SCRIP_CD'    
      END     
    ELSE     
      BEGIN     
     SET @SQL = 'SELECT DISTINCT SCRIP_CD '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY SCRIP_CD'    
      END     
   END    
   IF @PA_FLG = '3'    
   BEGIN    
    IF @PA_PARTY = 'missing'    
      BEGIN     
     SET @SQL = 'SELECT DISTINCT Left(Convert(Varchar,Trdate,109),11) as TDate '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE = ''PARTY'' ORDER BY TDate'    
      END    
    ELSE     
      BEGIN    
     SET @SQL = 'SELECT DISTINCT Left(Convert(Varchar,Trdate,109),11) as TDate '    
     SET @SQL = @SQL + 'FROM ' + @SHAREDB + '..DEMATTRANS '    
     SET @SQL = @SQL + 'WHERE SETT_NO = ''' + @SETT_NO + ''' AND SETT_TYPE = ''' + @SETT_TYPE + ''' And PARTY_CODE != ''PARTY'' ORDER BY TDate'    
      END     
     END    
        END    
END    
print @sql    
exec(@sql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSCLTDELWISE
-- --------------------------------------------------
/****** OBJECT:  STORED PROCEDURE DBO.INSCLTDELWISE    SCRIPT DATE: 12/09/2004 4:50:00 PM ******/                  
                  
CREATE PROC [dbo].[INSCLTDELWISE] ( @SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2),@REFNO INT) AS                  
DECLARE @@SCRIP_CD VARCHAR(12),                  
 @@SERIES VARCHAR(3),                  
 @@PARTY_CODE VARCHAR(10),                  
 @@DELQTY NUMERIC(18,4),                  
 @@QTY NUMERIC(18,4),                  
 @@QTY1 NUMERIC(18,4),                  
 @@TRADEQTY NUMERIC(18,4),                  
 @@CERTNO VARCHAR(15),                  
 @@FROMNO VARCHAR(15),                  
 @@FOLIONO VARCHAR(15),                  
 @@REASON VARCHAR(25),                  
 @@TCODE NUMERIC(18,0),                  
 @@CERTPARTY VARCHAR(10),                  
 @@ORGQTY NUMERIC(18,4),                  
 @@SDATE VARCHAR(11),                  
 @@SNO NUMERIC(18,0),                  
 @@PCOUNT NUMERIC(18,4),                  
 @@REMQTY NUMERIC(18,4),                  
 @@OLDQTY NUMERIC(18,4),                  
 @@FLAG VARCHAR(1),                  
 @@QTYCUR CURSOR,                  
 @@DELCLT CURSOR,                  
 @@CERTCUR CURSOR,    
 @@DPCLT VARCHAR(16)    
            
SET @@DELCLT = CURSOR FOR                              
 SELECT DT.SCRIP_CD,DT.SERIES,DT.PARTY_CODE,QTY,DPCLT,FLAG='N' FROM DELIVERYCLT DT     
 WHERE INOUT = 'O'                  
 AND SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                   
 ORDER BY DT.SCRIP_CD,DT.SERIES,FLAG,DT.QTY ASC,DT.PARTY_CODE                  
OPEN @@DELCLT                  
FETCH NEXT FROM @@DELCLT INTO @@SCRIP_CD,@@SERIES,@@PARTY_CODE,@@DELQTY,@@DPCLT,@@FLAG                  
WHILE @@FETCH_STATUS = 0                   
BEGIN                  
                       
       SET @@QTYCUR = CURSOR FOR                   
       SELECT ISNULL(SUM(QTY),0) FROM DELTRANS                   
       WHERE SETT_NO = @SETT_NO                   
       AND SETT_TYPE = @SETT_TYPE                   
       AND REFNO = @REFNO                  
       AND PARTY_CODE = @@PARTY_CODE                  
       AND SCRIP_CD  = @@SCRIP_CD                   
       AND SERIES = @@SERIES                   
       AND DRCR = 'D' AND FILLER2 = 1    
       AND CLTDPID = (CASE WHEN LEN(CLTDPID) = 16 THEN @@DPCLT ELSE RIGHT(@@DPCLT,8) END)    
       OPEN @@QTYCUR                   
       FETCH NEXT FROM @@QTYCUR INTO @@QTY                     
                         
       IF @@DELQTY > @@QTY                  
       BEGIN                    
  SELECT @@DELQTY = @@DELQTY - @@QTY                  
  SET @@CERTCUR = CURSOR FOR                  
  SELECT QTY,CERTNO, FROMNO,FOLIONO,TDATE=LEFT(CONVERT(VARCHAR,TRANSDATE,109),11),ORGQTY,SNO,TCODE                  
  FROM DELTRANS                   
  WHERE SETT_NO = @SETT_NO                   
  AND SETT_TYPE = @SETT_TYPE                   
  AND REFNO = @REFNO                  
  AND PARTY_CODE = 'BROKER'                  
  AND SCRIP_CD  = @@SCRIP_CD                   
  AND SERIES = @@SERIES                   
  AND DRCR = 'D' AND TRTYPE = 904 AND FILLER2 = 1                      
  ORDER BY TRANSDATE ASC,QTY DESC                   
   OPEN @@CERTCUR                  
   FETCH NEXT FROM @@CERTCUR INTO @@TRADEQTY,@@CERTNO,@@FROMNO,@@FOLIONO,@@SDATE,@@ORGQTY,@@SNO,@@TCODE                  
   IF @@FETCH_STATUS = 0                   
   BEGIN                  
     SELECT @@PCOUNT = 0                  
     WHILE @@PCOUNT < @@DELQTY AND @@FETCH_STATUS = 0                   
     BEGIN                  
    SELECT @@PCOUNT = @@PCOUNT + @@TRADEQTY                  
    IF @@PCOUNT <= @@DELQTY                   
    BEGIN                      
     UPDATE DELTRANS SET PARTY_CODE = @@PARTY_CODE, REASON=(CASE WHEN @@FLAG='E' THEN 'EXCESS RECEIVED TRANSFER' ELSE 'PAY-OUT' END),    
     DPID = LEFT(@@DPCLT,8), CLTDPID = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN RIGHT(@@DPCLT, 8) ELSE @@DPCLT END),    
     DPTYPE = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN 'NSDL' ELSE 'CDSL' END)    
     WHERE SNO = @@SNO               
    END                      
       ELSE                    
    BEGIN                  
      SELECT @@PCOUNT = @@PCOUNT - @@TRADEQTY                  
    SELECT @@REMQTY = @@DELQTY - @@PCOUNT                  
      SELECT @@OLDQTY = @@TRADEQTY - @@REMQTY                  
      SELECT @@PCOUNT = @@PCOUNT + @@REMQTY                    
                        
     INSERT INTO DELTRANS(SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,FROMNO,TONO,CERTNO,FOLIONO,    
     HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5)                  
     SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY=@@OLDQTY,FROMNO,TONO,CERTNO,FOLIONO,    
     HOLDERNAME,REASON,'D',DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,1,FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5                  
     FROM DELTRANS WHERE SNO = @@SNO            
                  
     UPDATE DELTRANS SET PARTY_CODE = @@PARTY_CODE, REASON=(CASE WHEN @@FLAG='E' THEN 'EXCESS RECEIVED TRANSFER' ELSE 'PAY-OUT' END),    
     DPID = LEFT(@@DPCLT,8), CLTDPID = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN RIGHT(@@DPCLT, 8) ELSE @@DPCLT END),     
     DPTYPE = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN 'NSDL' ELSE 'CDSL' END),     
     QTY = @@REMQTY              
     WHERE SNO = @@SNO             
                    
    END                  
    FETCH NEXT FROM @@CERTCUR INTO @@TRADEQTY,@@CERTNO,@@FROMNO,@@FOLIONO,@@SDATE,@@ORGQTY,@@SNO,@@TCODE                  
     END                  
   END                  
   CLOSE @@CERTCUR                  
   DEALLOCATE @@CERTCUR                   
      END                  
      CLOSE @@QTYCUR                  
      DEALLOCATE @@QTYCUR                  
      FETCH NEXT FROM @@DELCLT INTO @@SCRIP_CD,@@SERIES,@@PARTY_CODE,@@DELQTY,@@DPCLT,@@FLAG                  
END                  
CLOSE @@DELCLT                  
DEALLOCATE @@DELCLT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelAccCheck
-- --------------------------------------------------
  
        
  
CREATE PROC [dbo].[InsDelAccCheck] AS             
  
TRUNCATE TABLE DELACCBALANCE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelAccDebit
-- --------------------------------------------------
CREATE Proc [dbo].[InsDelAccDebit](@FPartyCode Varchar(10),@TPartyCode Varchar(10)) AS
select D.Scrip_cd,D.Series,M.SEC_NAME AS SCHEME_NAME,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId,CertNo,    
Qty=sum(qty),delivered,bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,Cl_Rate=IsNull(NAV_VALUE,0),Exchg = 'BSE'     
from NSEMFSS.DBO.Client1 c1,NSEMFSS.DBO.client2 c2,DelAccBalance A,DeliveryDp DP, MFSS_SCRIP_MASTER M, 
NSEMFSS.DBO.DelTrans D Left Outer Join MFSS_NAV C    
On ( D.Scrip_Cd = C.Scrip_CD 
And NAV_DATE = (Select Max(NAV_DATE) From MFSS_NAV Where Scrip_Cd = C.Scrip_CD  ))     
where D.Party_Code >= @FPartyCode and D.Party_Code <= @TPartyCode and DrCr = 'D'
And TrType <> 906 and D.Party_code = C2.Party_code     
and C1.Cl_Code = c2.Cl_Code and filler2= 1 And A.CltCode = D.Party_Code And Delivered = '0'    
And DP.DpType = D.BDpType And DP.DpCltNo = D.BCltDpId And DP.DpId = D.BDpId And Description not like '%POOL%'
AND M.SCRIP_CD = D.SCRIP_CD    
Group by D.Scrip_cd,D.Series,M.SEC_NAME,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId, CertNo, delivered,    
bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,delivered,NAV_VALUE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelCheckPos
-- --------------------------------------------------
CREATE PROC [dbo].[InsDelCheckPos] (@REFNO INT) AS                      
DECLARE                      
@@SNO NUMERIC(18,0),                      
@@SETT_NO VARCHAR(7),                      
@@SETT_TYPE VARCHAR(2),                      
@@PARTY_CODE VARCHAR(10),                      
@@SCRIP_CD VARCHAR(12),                      
@@SERIES VARCHAR(3),                      
@@DEMATQTY NUMERIC(18, 4),                      
@@CERTQTY NUMERIC(18, 4),                      
@@DELQTY NUMERIC(18, 4),                      
@@DQTY NUMERIC(18, 4),                      
@@REMQTY NUMERIC(18, 4),                      
@@CLTACCNO VARCHAR(16),                      
@@BANKCODE VARCHAR(16),                      
@@TRANSNO VARCHAR(16),                      
@@DEMATCUR CURSOR,                      
@@DELCUR CURSOR,                      
@@MCUR CURSOR,                      
@@DCUR CURSOR,                      
@@CERTCUR CURSOR                      
                      
SET NOCOUNT ON                       
                
UPDATE DEMATTRANS SET SERIES = 'MF'      
      
UPDATE DEMATTRANS SET SCRIP_CD = M.SCRIP_CD, SETT_TYPE = M.SETT_TYPE,       
PARTY_CODE = M.PARTY_CODE, SERIES = M.SERIES      
FROM DELIVERYCLT M       
WHERE DEMATTRANS.SETT_NO = M.SETT_NO       
AND M.DPCLT = DEMATTRANS.CLTACCNO      
AND M.ISIN = DEMATTRANS.ISIN       
AND TRTYPE <> 906       
      
UPDATE DEMATTRANS SET SCRIP_CD = M.SCRIP_CD, SETT_TYPE = M.SETT_TYPE, SERIES = M.SERIES       
FROM DELIVERYCLT M       
WHERE DEMATTRANS.SETT_NO = M.SETT_NO       
AND M.ISIN = DEMATTRANS.ISIN       
AND TRTYPE = 906

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelPayIn
-- --------------------------------------------------
CREATE PROC [dbo].[InsDelPayIn] 
(
      @STATUSID VARCHAR(25), 
      @STATUSNAME VARCHAR(25), 
      @SETT_NO VARCHAR(11), 
      @SETT_TYPE VARCHAR(11), 
      @FPARTY_CD VARCHAR(10), 
      @TPARTY_CD VARCHAR(10)
) 
/*
Exec NSEMFSS.DBO.InsDelPayIn 'broker','broker','1011186','T3','0','zz'
*/
AS
SET NOCOUNT ON
set dateformat mdy
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

      SELECT 
            PARTY_CODE,
            LONG_NAME
      INTO #CLIENTMASTER 
      FROM CLIENT2 C2 WITH(NOLOCK), 
            CLIENT1 C1 WITH(NOLOCK) 
      WHERE C1.CL_CODE = C2.CL_CODE 
            AND C2.PARTY_CODE >= @FPARTY_CD 
            AND C2.PARTY_CODE <= @TPARTY_CD 
             AND @STATUSNAME = 
                  (CASE 
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                        WHEN @STATUSID = 'AREA' THEN C1.AREA
                        WHEN @STATUSID = 'REGION' THEN C1.REGION
                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                  ELSE 
                        'BROKER'
                  END)

      SELECT 
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            ISIN=CERTNO,
            D.SCRIP_CD,
            SEC_NAME AS SCHEME_NAME,
            QTY=SUM(QTY), 
            CLTDPID = CLTDPID,
            DPID = D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            TRANSDATE=LEFT(CONVERT(VARCHAR,TRANSDATE,109),11),
            EXCHG='BSE', 
            REMARK=(
                  CASE 
                        WHEN TRTYPE = 907 
                        THEN 'INTER SETTLEMENT FROM ' + CLTDPID 
                        ELSE 'RECEIVED' 
                  END
                  ) 
      FROM DELTRANS D WITH(NOLOCK), 
            #CLIENTMASTER C2 WITH(NOLOCK), MFSS_SCRIP_MASTER M 
      WHERE D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND DRCR = 'C' 
            AND FILLER2 = 1 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
            AND SHARETYPE <> 'AUCTION' 
            AND C2.PARTY_CODE = D.PARTY_CODE 
            AND D.SCRIP_CD = M.SCRIP_CD
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            CERTNO,
            D.SCRIP_CD,
            SEC_NAME,
            CLTDPID,
            D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            D.SETT_NO,
            TRANSDATE,
            DELIVERED,
            TRTYPE 

      UNION ALL 

      SELECT 
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            ISIN=' ',
            D.SCRIP_CD,
            SCHEME_NAME,
            QTY=D.QTY-SUM((
                  CASE 
                        WHEN DRCR = 'C' 
                        THEN ISNULL(DE.QTY,0) 
                        ELSE -ISNULL(DE.QTY,0) 
                  END
                  )), 
            CLTDPID=' ', 
            DPID = ' ', 
            ISETT_NO=' ',
            ISETT_TYPE=' ',
            TRANSDATE=LEFT(CONVERT(VARCHAR,SEC_PAYIN,109),11),
            EXCHG='NSE', 
            REMARK='PAYIN SHORTAGE' 
      FROM SETT_MST S WITH(NOLOCK),
            #CLIENTMASTER C2 WITH(NOLOCK),
            DELIVERYCLT D WITH(NOLOCK) 
            LEFT OUTER JOIN 
            DELTRANS DE WITH(NOLOCK) 
            ON 
            ( 
                  DE.SETT_NO = D.SETT_NO 
                  AND DE.SETT_TYPE = D.SETT_TYPE 
                  AND DE.SCRIP_CD = D.SCRIP_CD 
                  AND DE.SERIES = D.SERIES 
                  AND DE.PARTY_CODE = D.PARTY_CODE 
                  AND FILLER2 = 1 
                  AND SHARETYPE <> 'AUCTION'
            ) 
      WHERE D.INOUT = 'I' 
            AND D.QTY > 0 
            AND D.PARTY_CODE = C2.PARTY_CODE 
            AND D.SETT_NO = S.SETT_NO 
            AND D.SETT_TYPE = S.SETT_TYPE 
            AND D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            D.SCRIP_CD,
            D.SERIES,
            SCHEME_NAME,
            D.QTY,
            SEC_PAYIN 
      HAVING D.QTY <> SUM((
            CASE 
                  WHEN DRCR = 'C' 
                  THEN ISNULL(DE.QTY,0) 
                  ELSE -ISNULL(DE.QTY,0) 
            END
            )) 
      ORDER BY D.PARTY_CODE,
            EXCHG,
            SEC_NAME,
            D.SETT_NO,
            D.SETT_TYPE,
            LEFT(CONVERT(VARCHAR,TRANSDATE,109),11)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelPayOut
-- --------------------------------------------------
CREATE Proc [dbo].[InsDelPayOut](@StatusId Varchar(15),@StatusName Varchar(25),@FromTrDate Varchar(11),@ToTrDate Varchar(11),@FParty_Cd Varchar(10),@TParty_Cd Varchar(10),@Branch Varchar(10)) As  
Select D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name=Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',
L_Address1, L_Address2, L_Address3, L_City, L_State, L_Zip,
IsIn=CertNo,D.Scrip_Cd,SEC_NAME AS SCHEME_NAME,Qty=Sum(Qty),  
CltDpId = (Case When Delivered = '0'   
         Then DpCltNo   
         When ISett_No <> '' And TrType <> 908  
         Then ' '  
  Else  
         CltDpID   
      End),       
DpId =    (Case When Delivered = '0'   
         Then D.DpID   
         When ISett_No <> '' And TrType <> 908  
         Then ' '  
  Else  
         D.DpID   
      End),Isett_No,Isett_Type,  
TransDate=Left(Convert(Varchar,TransDate,109),11),Exchg='BSE',  
Remark=(Case When Delivered = '0'   
      Then ''/*'SHARES HELD FOR DEBIT'*/
      When ISett_No <> ''   
      Then 'TRFD FOR PAY-IN OF ' + 'BSE' + '/' + Right(ISett_No,3)  
      When TransDate > Sec_PayOut  
      Then ''/*'SHARES HELD FOR DEBIT Released'*/
      When Reason Like 'Excess%' Then 'EXCESS RECEIVED TRANSFER'  
 Else '' End)  
From NSEMFSS.DBO.DelTrans D,  
NSEMFSS.DBO.Client2 C2 , NSEMFSS.DBO.Client1 C1, NSEMFSS.DBO.Sett_Mst S,NSEMFSS.DBO.DeliveryDp Dp, NSEMFSS.DBO.MFSS_SCRIP_MASTER M   
Where TransDate >= @FromTrDate And TransDate <= @ToTrDate + ' 23:59:59' And DrCr = 'D' And Filler2 = 1  
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd  
And C1.Cl_Code = C2.Cl_Code and C2.Party_code = D.Party_Code And D.Sett_No = S.Sett_No  
And D.Sett_Type = S.Sett_Type And Dp.DpId = D.BDpId and Dp.DpCltNo = D.BCltDpID and ( Delivered in ('G','D') or Description not Like '%POOL%')  
And C1.Branch_cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End )  
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End )  
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End )  
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End )  
And C2.Party_code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End ) 
AND M.SCRIP_CD = D.SCRIP_CD 
Group By D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',
L_Address1, L_Address2, L_Address3, L_City, L_State, L_Zip,
CertNo,D.Scrip_Cd,SEC_NAME,CltDpId,DpCltNo,D.DpID,DP.DpID,Isett_No,Isett_Type,  
S.Sett_No,TransDate,Delivered,Sec_PayOut, TrType,Reason
order by d.Party_Code,SEC_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDELTRANSPRINTBEN
-- --------------------------------------------------
CREATE PROC [dbo].[INSDELTRANSPRINTBEN] (@OPTFLAG INT, @BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),      
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))                         
AS                        
DECLARE                         
@SETT_NO VARCHAR(7),                        
@SETT_TYPE VARCHAR(2),                        
@SNO NUMERIC,                        
@QTY NUMERIC(18,4),                        
@DIFFQTY NUMERIC(18,4),                        
@SLIPNO INT,                        
@BATCHNO INT,                        
@TRANSDATE VARCHAR(11),                        
@HOLDERNAME VARCHAR(30),                        
@FOLIONO VARCHAR(20),                        
@PARTY_CODE VARCHAR(10),                        
@SCRIP_CD VARCHAR(12),                        
@SERIES VARCHAR(3),                        
@CERTNO VARCHAR(12),                        
@TRTYPE INT,                        
@DPID VARCHAR(8),                        
@CLTDPID VARCHAR(16),                        
@DELBDPID VARCHAR(8),                        
@DELBCLTDPID VARCHAR(16),                        
@ALLQTY NUMERIC(18,4),                        
@DELCUR CURSOR,                        
@BENCUR CURSOR,              
@REFNO INT,              
@FROMPARTY VARCHAR(10),                       
@TOPARTY VARCHAR(10),      
@FLAG INT      
              
              
IF @OPTFLAG = 3                        
BEGIN                        
              
UPDATE DELTRANSPRINTBEN SET OPTIONFLAG = 3 WHERE OPTIONFLAG = 4              
              
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME                        
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND OPTIONFLAG = 3                        
AND D.QTY = NEWQTY                        
AND FILLER1 = 'THIRD PARTY'                      
                      
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 3                        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                      
AND FILLER1 = 'THIRD PARTY'                      
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 3 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID,         @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                        
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                        
 AND FILLER1 = 'THIRD PARTY'                      
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID,                     
 @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO              
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 3                      
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                                       
END                        
                        
IF @OPTFLAG = 4                        
BEGIN                        
              
SELECT @REFNO = REFNO FROM DELSEGMENT               
SELECT @FROMPARTY = ISNULL(MIN(FROMPARTY),'0'), @TOPARTY = ISNULL(MAX(TOPARTY),'ZZZZZZZ') FROM DELTRANSPRINTBEN              
              
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME                        
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND OPTIONFLAG = 4                        
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 4 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID, @CLTDPID,                   @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY, FLAG = 1 FROM DELTRANS D                       
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD             
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
 And Sett_No In (Select Sett_No From MSAJAG.DBO.DelPayOut L              
 Where L.Sett_No = D.Sett_No And L.Sett_Type = D.Sett_Type              
 And L.Party_Code = D.Party_Code And L.CertNo = D.CertNo          
 AND L.SCRIP_CD = D.SCRIP_CD AND L.SERIES = D.SERIES               
 And ActPayout > 0 )      
 UNION ALL      
 SELECT SETT_NO, SETT_TYPE, SNO, QTY, FLAG = 2 FROM DELTRANS D                
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
 And Sett_No Not In (Select Sett_No From MSAJAG.DBO.DelPayOut L              
 Where L.Sett_No = D.Sett_No And L.Sett_Type = D.Sett_Type              
 And L.Party_Code = D.Party_Code And L.CertNo = D.CertNo          
 AND L.SCRIP_CD = D.SCRIP_CD AND L.SERIES = D.SERIES               
 And ActPayout > 0 )      
 ORDER BY 5, SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY, @FLAG                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE           
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                  
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,               
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
 AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                 
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY, @FLAG                        
 END                      
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID, @CLTDPID,                     
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 4                        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO              
        
/*        
INSERT INTO MSAJAG.DBO.DELPAYOUT_RECO              
SELECT EXCHANGE, SETT_NO, SETT_TYPE, PARTY_CODE, SCRIP_CD, SERIES, CERTNO, ACTYPE,               
HOLDQTY=DEBITQTY, RMSPAYQTY=ACTPAYOUT, PAYQTY, RUNDATE = GETDATE()              
FROM MSAJAG.DBO.DELPAYOUT              
WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
AND EXCHANGE = (CASE WHEN @REFNO = 110 THEN 'NSE' ELSE 'BSE' END)              
              
INSERT INTO MSAJAG.DBO.DELPAYOUT_RECO              
SELECT EXCHANGE=(CASE WHEN REFNO = 110 THEN 'NSE' ELSE 'BSE' END),              
DELTRANSTEMP.SETT_NO, DELTRANSTEMP.SETT_TYPE, DELTRANSTEMP.PARTY_CODE,               
DELTRANSTEMP.SCRIP_CD, DELTRANSTEMP.SERIES, DELTRANSTEMP.CERTNO, ACTYPE = 'BEN',              
HOLDQTY = 0, RMSPAYQTY = 0, PAYQTY = SUM(DELTRANSTEMP.QTY), RUNDATE = GETDATE()              
FROM DELTRANSTEMP, DELTRANSPRINTBEN D                        
WHERE DELTRANSTEMP.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANSTEMP.PARTY_CODE <= D.TOPARTY               
AND DELTRANSTEMP.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANSTEMP.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANSTEMP.SERIES = D.SERIES                    
AND DELTRANSTEMP.CERTNO = D.CERTNO                        
AND DELTRANSTEMP.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1              
AND DRCR = 'D'              
AND DELTRANSTEMP.BDPTYPE = D.BDPTYPE                        
AND DELTRANSTEMP.BDPID = D.BDPID                        
AND DELTRANSTEMP.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'D'                        
AND DELTRANSTEMP.DPID = D.DPID                        
AND DELTRANSTEMP.CLTDPID = D.CLTDPID                        
AND DELTRANSTEMP.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 4                       
AND DELTRANSTEMP.SLIPNO = D.SLIPNO                      
AND DELTRANSTEMP.BATCHNO = D.BATCHNO              
GROUP BY DELTRANSTEMP.SETT_NO, DELTRANSTEMP.SETT_TYPE, DELTRANSTEMP.PARTY_CODE,               
DELTRANSTEMP.SCRIP_CD, DELTRANSTEMP.SERIES, DELTRANSTEMP.CERTNO, DELTRANSTEMP.REFNO              
              
DELETE FROM MSAJAG.DBO.DELPAYOUT              
WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
AND EXCHANGE = (CASE WHEN @REFNO = 110 THEN 'NSE' ELSE 'BSE' END)              
*/        
END                        
                        
IF @OPTFLAG = 5                        
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 5                      
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 5 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN      
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 5                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END                  
                        
IF @OPTFLAG = 6                      
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                 
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 6                      
AND D.QTY = NEWQTY        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 6 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                  
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY            
AND DELTRANS.PARTY_CODE = D.PARTY_CODE           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 6                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END         
        
IF @OPTFLAG = 7                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 7                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )      
                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 7 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'          
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 7        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
END      
      
IF @OPTFLAG = 8                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 8                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 8 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,          
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 8        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                       
END    
    
IF @OPTFLAG = 9                      
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                 
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID     
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID    
AND DELIVERED = '0'                        
AND OPTIONFLAG = 9                      
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 9 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID    
 AND DELTRANS.DPID = @BDPID                   
 AND DELTRANS.CLTDPID = @BCLTDPID    
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,    
DELTRANS.FILLER5                  
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY            
AND DELTRANS.PARTY_CODE = D.PARTY_CODE           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID     
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                       
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 9                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END    
    
IF @OPTFLAG = 10                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                         
AND DELIVERED = '0'                        
AND OPTIONFLAG = 10                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 10 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID    
 AND DELTRANS.DPID = @BDPID                   
 AND DELTRANS.CLTDPID = @BCLTDPID    
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,          
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 10     
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDELTRANSPRINTPOOL
-- --------------------------------------------------
CREATE PROC [dbo].[INSDELTRANSPRINTPOOL] (@OPTFLAG INT, @BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),    
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))     
AS    
DECLARE     
@SETT_NO VARCHAR(7),    
@SETT_TYPE VARCHAR(2),    
@SNO NUMERIC,    
@QTY NUMERIC(18, 4),    
@DIFFQTY NUMERIC(18, 4),    
@SLIPNO INT,    
@BATCHNO INT,    
@TRANSDATE VARCHAR(11),    
@HOLDERNAME VARCHAR(30),    
@FOLIONO VARCHAR(20),    
@PARTY_CODE VARCHAR(10),    
@CERTNO VARCHAR(12),    
@TRTYPE INT,    
@DPID VARCHAR(8),    
@CLTDPID VARCHAR(16),    
@DELBDPID VARCHAR(8),    
@DELBCLTDPID VARCHAR(16),    
@ALLQTY INT,    
@DELCUR CURSOR,    
@BENCUR CURSOR    
    
IF @OPTFLAG = 1     
BEGIN    
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,     
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,    
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME    
FROM DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = '0'    
AND DELTRANS.ISETT_NO = D.ISETT_NO    
AND DELTRANS.ISETT_TYPE = D.ISETT_TYPE    
AND OPTIONFLAG = 1  AND DELTRANS.PARTY_CODE <> 'BROKER'    
END    
    
IF @OPTFLAG = 3    
BEGIN    
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,     
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,    
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME    
FROM DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = '0'    
AND DELTRANS.DPID = D.DPID    
AND DELTRANS.CLTDPID = D.CLTDPID    
AND OPTIONFLAG = 3    
AND D.QTY = NEWQTY     
AND DELTRANS.PARTY_CODE <> 'BROKER'    
    
INSERT INTO DELTRANSTEMP    
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,    
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,    
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,    
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,    
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,    
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5    
FROM DELTRANS, DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = 'G'    
AND DELTRANS.DPID = D.DPID    
AND DELTRANS.CLTDPID = D.CLTDPID    
AND DELTRANS.FOLIONO = D.FOLIONO    
AND DELTRANS.SLIPNO = D.SLIPNO    
AND DELTRANS.BATCHNO = D.BATCHNO    
AND OPTIONFLAG = 3    
AND D.QTY = NEWQTY     
AND DELTRANS.PARTY_CODE <> 'BROKER'    
    
SET @BENCUR = CURSOR FOR    
SELECT SETT_NO, SETT_TYPE, PARTY_CODE, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,     
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID    
FROM DELTRANSPRINTPOOL WHERE OPTIONFLAG = 3 AND QTY <> NEWQTY     
ORDER BY PARTY_CODE, CERTNO    
OPEN @BENCUR    
FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE, @PARTY_CODE, @CERTNO, @TRTYPE, @DPID, @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO,     
@HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID    
WHILE @@FETCH_STATUS = 0     
BEGIN    
 SELECT @DIFFQTY = @ALLQTY    
 SET @DELCUR = CURSOR FOR    
 SELECT SNO, QTY FROM DELTRANS    
 WHERE PARTY_CODE = @PARTY_CODE    
 AND CERTNO = @CERTNO    
 AND TRTYPE = @TRTYPE    
 AND DRCR = 'D'    
 AND DELIVERED = '0'    
 AND FILLER2 = 1     
 AND DPID = @DPID    
 AND CLTDPID = @CLTDPID    
 AND BDPID = @DELBDPID    
 AND BCLTDPID = @DELBCLTDPID    
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC    
 OPEN @DELCUR    
 FETCH NEXT FROM @DELCUR INTO @SNO, @QTY     
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0     
 BEGIN    
  IF @DIFFQTY >= @QTY    
  BEGIN    
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,    
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
   SELECT @DIFFQTY = @DIFFQTY - @QTY    
  END    
  ELSE    
  BEGIN    
   INSERT INTO DELTRANS    
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,    
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,    
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,    
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
    
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,    
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
    
   SELECT @DIFFQTY = 0     
  END    
  FETCH NEXT FROM @DELCUR INTO @SNO, @QTY     
 END    
 FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE,@PARTY_CODE, @CERTNO, @TRTYPE, @DPID, @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO,     
 @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID    
END    
    
INSERT INTO DELTRANSTEMP    
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,    
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,    
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,    
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,    
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,    
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5    
FROM DELTRANS, DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = 'G'    
AND DELTRANS.DPID = D.DPID    
AND DELTRANS.CLTDPID = D.CLTDPID    
AND DELTRANS.FOLIONO = D.FOLIONO    
AND DELTRANS.SLIPNO = D.SLIPNO    
AND DELTRANS.BATCHNO = D.BATCHNO    
AND OPTIONFLAG = 3    
AND D.QTY <> NEWQTY    
    
END    
    
IF @OPTFLAG = 2    
BEGIN    
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,     
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,    
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME    
FROM DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = '0'    
AND OPTIONFLAG = 2    
AND DELTRANS.PARTY_CODE <> 'BROKER'    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1     
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE     
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)    
    )     
    
INSERT INTO DELTRANSTEMP    
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,    
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,    
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,    
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,    
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,    
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5    
FROM DELTRANS, DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = 'G'    
AND OPTIONFLAG = 2    
AND DELTRANS.FOLIONO = D.FOLIONO    
AND DELTRANS.SLIPNO = D.SLIPNO    
AND DELTRANS.BATCHNO = D.BATCHNO    
AND DELTRANS.PARTY_CODE <> 'BROKER'    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1     
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE     
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)    
    )     
END    
  
IF @OPTFLAG = 4    
BEGIN    
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,     
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,    
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME    
FROM DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = '0'    
AND OPTIONFLAG = 4  
AND D.QTY = NEWQTY     
AND DELTRANS.PARTY_CODE <> 'BROKER'    
    
INSERT INTO DELTRANSTEMP    
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,    
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,    
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,    
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,    
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,    
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5    
FROM DELTRANS, DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = 'G'    
AND DELTRANS.FOLIONO = D.FOLIONO    
AND DELTRANS.SLIPNO = D.SLIPNO    
AND DELTRANS.BATCHNO = D.BATCHNO    
AND OPTIONFLAG = 4   
AND D.QTY = NEWQTY     
AND DELTRANS.PARTY_CODE <> 'BROKER'    
    
SET @BENCUR = CURSOR FOR    
SELECT SETT_NO, SETT_TYPE, PARTY_CODE, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,     
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID    
FROM DELTRANSPRINTPOOL WHERE OPTIONFLAG = 4 AND QTY <> NEWQTY     
ORDER BY PARTY_CODE, CERTNO    
OPEN @BENCUR    
FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE, @PARTY_CODE, @CERTNO, @TRTYPE, @SLIPNO, @BATCHNO, @FOLIONO,     
@HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID    
WHILE @@FETCH_STATUS = 0     
BEGIN    
 SELECT @DIFFQTY = @ALLQTY    
 SET @DELCUR = CURSOR FOR    
 SELECT SNO, QTY FROM DELTRANS    
 WHERE PARTY_CODE = @PARTY_CODE    
 AND CERTNO = @CERTNO    
 AND TRTYPE = @TRTYPE    
 AND DRCR = 'D'    
 AND DELIVERED = '0'    
 AND FILLER2 = 1     
 AND BDPID = @DELBDPID    
 AND BCLTDPID = @DELBCLTDPID    
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC    
 OPEN @DELCUR    
 FETCH NEXT FROM @DELCUR INTO @SNO, @QTY     
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0     
 BEGIN    
  IF @DIFFQTY >= @QTY    
  BEGIN    
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,    
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
   SELECT @DIFFQTY = @DIFFQTY - @QTY    
  END    
  ELSE    
  BEGIN    
   INSERT INTO DELTRANS    
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,    
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,    
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,    
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
    
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,    
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY    
   WHERE SETT_NO = @SETT_NO    
   AND SETT_TYPE = @SETT_TYPE    
   AND SNO = @SNO    
    
   SELECT @DIFFQTY = 0     
  END    
  FETCH NEXT FROM @DELCUR INTO @SNO, @QTY     
 END    
 FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE,@PARTY_CODE, @CERTNO, @TRTYPE, @SLIPNO, @BATCHNO, @FOLIONO,     
 @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID    
END    
    
INSERT INTO DELTRANSTEMP    
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,    
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,    
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,    
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,    
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,    
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5    
FROM DELTRANS, DELTRANSPRINTPOOL D    
WHERE DELTRANS.SETT_NO = D.SETT_NO    
AND DELTRANS.SETT_TYPE = D.SETT_TYPE    
AND DELTRANS.PARTY_CODE >= D.FROMPARTY    
AND DELTRANS.PARTY_CODE <= D.TOPARTY    
AND DELTRANS.PARTY_CODE = D.PARTY_CODE    
AND DELTRANS.SCRIP_CD LIKE '%'    
AND DELTRANS.SERIES LIKE '%'    
AND DELTRANS.CERTNO = D.CERTNO    
AND DELTRANS.TRTYPE = D.TRTYPE    
AND FILLER2 = 1    
AND DRCR = 'D'    
AND DELTRANS.BDPTYPE = D.BDPTYPE    
AND DELTRANS.BDPID = D.BDPID    
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELIVERED = 'G'    
AND DELTRANS.FOLIONO = D.FOLIONO    
AND DELTRANS.SLIPNO = D.SLIPNO    
AND DELTRANS.BATCHNO = D.BATCHNO    
AND OPTIONFLAG = 4    
AND D.QTY <> NEWQTY    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Insdematnsecursor
-- --------------------------------------------------
CREATE Proc [dbo].[Insdematnsecursor] ( @Refno Int) As      
      
Insert Into Deltrans      
Select Sett_No, Sett_Type, Refno, Tcode, Trtype, Party_Code, D.Scrip_Cd, D.Series, Qty, Transno, Transno, D.Isin, Transno, '',       
'Pay-Out', 'C', '0', Qty, Dptype, Dpid, Cltaccno, Branch_Cd, Partipantcode, 0, '', '', '', 'Demat',       
Trdate, Filler1, 1, Filler3, Bdptype, Bdpid, Bcltaccno, Filler4, Filler5      
From Demattrans D Where Drcr = 'C'       
And D.Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type      
        And De.Scrip_Cd = D.Scrip_Cd And De.Series = D.Series )             
      
Insert Into Deltrans      
Select Sett_No, Sett_Type, Refno, Tcode, (CASE WHEN TRTYPE = 906 THEN 904 ELSE 906 END),   
(CASE WHEN TRTYPE = 906 THEN 'BROKER' ELSE 'EXE' END), D.Scrip_Cd, D.Series, Qty, Transno, Transno, D.Isin, Transno, '',       
'Pay-Out', 'D', (CASE WHEN TRTYPE = 906 THEN '0' ELSE 'D' END), Qty, Dptype, Dpid, Cltaccno, Branch_Cd, Partipantcode, 0, '', '', '', 'Demat',       
Trdate, Filler1, 1, Filler3, Bdptype, Bdpid, Bcltaccno, Filler4, Filler5      
From Demattrans D Where Drcr = 'C'       
And D.Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type      
        And De.Scrip_Cd = D.Scrip_Cd And De.Series = D.Series )      
      
Delete From Demattrans Where Drcr = 'C'       
And Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = Demattrans.Sett_No And DE.Sett_Type = Demattrans.Sett_Type      
        And De.Scrip_Cd = Demattrans.Scrip_Cd And De.Series = Demattrans.Series )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDEMATTRANSDUPLICATE
-- --------------------------------------------------
CREATE PROC [dbo].[INSDEMATTRANSDUPLICATE]  
AS  
TRUNCATE TABLE SPEED_TEMP
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
INSERT INTO SPEED_TEMP       
SELECT T.SNO, T.SETT_NO, T.SETT_TYPE, T.REFNO, T.TCODE, 
T.TRTYPE, T.PARTY_CODE, T.SCRIP_CD, T.SERIES, T.QTY, T.TRDATE, 
T.CLTACCNO, T.DPID, T.DPNAME, T.ISIN, T.BRANCH_CD, T.PARTIPANTCODE, 
T.DPTYPE, T.TRANSNO, T.DRCR, T.BDPTYPE, T.BDPID, T.BCLTACCNO
FROM DELTRANS D WITH(INDEX(DELHOLD)),             
DEMATTRANSSPEED T WITH(INDEX(TRN_SPEED))            
WHERE T.SETT_NO = D.SETT_NO            
AND D.CERTNO = T.ISIN            
AND D.FILLER2 = 1 AND D.DRCR = 'C'             
AND D.BDPTYPE = T.BDPTYPE            
AND D.BDPID = T.BDPID            
AND D.BCLTDPID = T.BCLTACCNO 
AND D.DPID = T.DPID            
AND D.CLTDPID = T.CLTACCNO           
AND D.FROMNO = T.TRANSNO 
AND D.TRTYPE <> 907
           
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
INSERT INTO SPEED_TEMP       
SELECT T.SNO, T.SETT_NO, T.SETT_TYPE, T.REFNO, T.TCODE, 
T.TRTYPE, T.PARTY_CODE, T.SCRIP_CD, T.SERIES, T.QTY, T.TRDATE, 
T.CLTACCNO, T.DPID, T.DPNAME, T.ISIN, T.BRANCH_CD, T.PARTIPANTCODE, 
T.DPTYPE, T.TRANSNO, T.DRCR, T.BDPTYPE, T.BDPID, T.BCLTACCNO
FROM DELTRANS D WITH(INDEX(DELHOLD)),             
DEMATTRANSSPEED T WITH(INDEX(TRN_SPEED))            
WHERE T.SETT_NO = D.SETT_NO            
AND D.CERTNO = T.ISIN            
AND D.FILLER2 = 1 AND D.DRCR = 'C'             
AND D.BDPTYPE = T.BDPTYPE            
AND D.BDPID = T.BDPID            
AND D.BCLTDPID = T.BCLTACCNO 
AND D.FROMNO = T.TRANSNO 
AND D.TRTYPE = 907

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDEMATTRANSINSERT
-- --------------------------------------------------
CREATE PROC [dbo].[INSDEMATTRANSINSERT] (                    
 @TCODE INT,                     
 @REFNO INT )                     
AS                     
             
UPDATE DELCODE SET TCODE = @TCODE WHERE REFNO = @REFNO                    
                
DELETE FROM DEMATTRANSSPEED WHERE SNO IN (SELECT SNO FROM SPEED_TEMP)                
/* TILL HERE */                
                    
DELETE DEMATTRANSSPEED FROM DEMATTRANS DT                 
WHERE DEMATTRANSSPEED.SETT_NO = DT.SETT_NO                
AND DEMATTRANSSPEED.ISIN = DT.ISIN                       
AND LEFT(DEMATTRANSSPEED.TRDATE,11) = LEFT(DT.TRDATE,11)  
AND DEMATTRANSSPEED.DRCR = DT.DRCR                   
AND DT.BDPTYPE = 'NSDL'                   
AND DT.BCLTACCNO = DEMATTRANSSPEED.BCLTACCNO                       
AND DEMATTRANSSPEED.TRANSNO = DT.TRANSNO    
AND DT.DPID = DEMATTRANSSPEED.DPID   
AND DT.CLTACCNO = DEMATTRANSSPEED.CLTACCNO                     
                    
DELETE DEMATTRANSSPEED FROM DEMATTRANSOUT DT                 
WHERE DEMATTRANSSPEED.SETT_NO = DT.SETT_NO                
AND DEMATTRANSSPEED.ISIN = DT.ISIN                       
AND LEFT(DEMATTRANSSPEED.TRDATE,11) = LEFT(DT.TRDATE,11)  
AND DEMATTRANSSPEED.DRCR = DT.DRCR                   
AND DT.BDPTYPE = 'NSDL'                   
AND DT.BCLTACCNO = DEMATTRANSSPEED.BCLTACCNO                       
AND DEMATTRANSSPEED.TRANSNO = DT.TRANSNO                      
                    
INSERT INTO DEMATTRANS( SETT_NO, SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,                    
TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,PARTIPANTCODE,DPTYPE,TRANSNO,                     
DRCR , BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5 )                    
SELECT SETT_NO, SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,                     
TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,PARTIPANTCODE,DPTYPE,TRANSNO,                     
DRCR , BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5 FROM DEMATTRANSSPEED                     
                                      
UPDATE DEMATTRANS SET SCRIP_CD = S2.SCRIP_CD,SERIES = D.SERIES, SETT_TYPE = S2.SETT_TYPE
FROM DELIVERYCLT S2 ,DEMATTRANS  D 
WHERE D.SETT_NO = S2.SETT_NO 
AND S2.ISIN = D.ISIN
                    
IF @REFNO = 120                     
BEGIN                    
      UPDATE DEMATTRANS SET SETT_TYPE = D.SETT_TYPE FROM DELIVERYCLT D                     
        WHERE D.SETT_NO = DEMATTRANS.SETT_NO AND D.SCRIP_CD = DEMATTRANS.SCRIP_CD AND D.SETT_TYPE = 'C'                     
        AND D.SETT_NO >= '2004164' AND DEMATTRANS.SETT_TYPE = 'D'                     
                  
      UPDATE DEMATTRANS SET SETT_TYPE = D.SETT_TYPE FROM DELIVERYCLT D                     
        WHERE D.SETT_NO = DEMATTRANS.SETT_NO AND D.SCRIP_CD = DEMATTRANS.SCRIP_CD AND D.SETT_TYPE = 'D'                  
        AND D.SETT_NO >= '2004164' AND DEMATTRANS.SETT_TYPE = 'C'                  
END                    
                    
UPDATE DEMATTRANS SET CLTACCNO = RTRIM(ISNULL((SELECT LEFT(SETT_NO + '                ',16) FROM DEMATTRANS D WHERE                     
D.TRANSNO = DEMATTRANS.TRANSNO AND                    
D.TRTYPE = 907 AND D.DRCR = 'D'),CLTACCNO))                    
WHERE TRTYPE = 907 AND DRCR = 'C'                    
                       
UPDATE DEMATTRANS SET DPID = RTRIM(ISNULL((SELECT LEFT(SETT_TYPE + '                ',8) FROM DEMATTRANS D                     
WHERE D.TRANSNO = DEMATTRANS.TRANSNO AND                    
D.TRTYPE = 907 AND D.DRCR = 'D'),DPID))                    
WHERE TRTYPE = 907 AND DRCR = 'C'                
                    
UPDATE DEMATTRANS SET                     
PARTY_CODE = (CASE WHEN @REFNO = 120                     
                              THEN 'BSE'                     
                              ELSE 'NSE'                     
                     END)                     
WHERE TRTYPE = 906    
                      
INSERT INTO DEMATTRANSOUT SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,                    
PARTIPANTCODE,DPTYPE,TRANSNO,DRCR,BDPTYPE,BDPID,BCLTACCNO,FILLER1,FILLER2,FILLER3,FILLER4,FILLER5                    
FROM DEMATTRANS WHERE DRCR = 'D'     
                        
DELETE FROM DEMATTRANS WHERE DRCR = 'D'                    
                    
TRUNCATE TABLE SPEED_TEMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDUPRECCHECK
-- --------------------------------------------------
  
CREATE PROC [dbo].[INSDUPRECCHECK] AS         
        
DELETE FROM DEMATTRANSSPEED   
WHERE TRANSNO IN (SELECT TRANSNO FROM DEMATTRANS   
                  WHERE SETT_NO = DEMATTRANSSPEED.SETT_NO   
                  AND Left(Convert(Varchar,TRDATE,109),11) = Left(Convert(Varchar,DEMATTRANSSPEED.TRDATE,109),11)  
                  AND DEMATTRANS.ISIN = DEMATTRANSSPEED.ISIN       
                  AND TRANSNO = DEMATTRANSSPEED.TRANSNO AND DPID = DEMATTRANSSPEED.DPID   
                  AND CLTACCNO = DEMATTRANSSPEED.CLTACCNO)  
         
DELETE FROM DEMATTRANSSPEED   
WHERE TRANSNO IN (SELECT FROMNO FROM DELTRANS   
                  WHERE SETT_NO = DEMATTRANSSPEED.SETT_NO   
                  AND Left(Convert(Varchar,Transdate,109),11) = Left(Convert(Varchar,DEMATTRANSSPEED.TRDATE,109),11)  
                  AND CERTNO = DEMATTRANSSPEED.ISIN       
                  AND FROMNO = DEMATTRANSSPEED.TRANSNO AND DPID = DEMATTRANSSPEED.DPID   
                  AND CLTDPID = DEMATTRANSSPEED.CLTACCNO AND FILLER2 = 1 AND DRCR = 'C')         
                    
INSERT INTO DEMATTRANS (SETT_NO, SETT_TYPE, REFNO, TCODE, TRTYPE, PARTY_CODE, SCRIP_CD, SERIES, QTY,   
                        TRDATE, CLTACCNO, DPID, DPNAME, ISIN, BRANCH_CD, PARTIPANTCODE, DPTYPE, TRANSNO,   
                        DRCR, BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5)        
SELECT SETT_NO, SETT_TYPE, REFNO, TCODE, TRTYPE, PARTY_CODE, SCRIP_CD, SERIES, QTY,   
       TRDATE, CLTACCNO, DPID, DPNAME, ISIN, BRANCH_CD, PARTIPANTCODE, DPTYPE, TRANSNO, DRCR, BDPTYPE,   
       BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5   
FROM DEMATTRANSSPEED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Insertdematspeed
-- --------------------------------------------------
/****** Object:  Stored Procedure Dbo.Insertdematspeed    Script Date: 12/16/2003 2:21:08 Pm ******/  
  
CREATE Procedure [dbo].[Insertdematspeed]   
  
       @Sett_No                  Varchar(7)          ,           
       @Sett_Type                Varchar(2)          ,           
       @Refno                    Int                 ,           
       @Tcode                    Numeric(18, 0)       ,           
       @Trtype                   Numeric(18, 0)       ,           
       @Party_Code               Varchar(10)         ,           
       @Scrip_Cd                 Varchar(12)         = Null,     
       @Series                   Varchar(3)          = Null,     
       @Qty                      Numeric(18, 4)       ,           
       @Trdate                   Datetime            ,           
       @Cltaccno                 Varchar(16)         = Null,     
       @Dpid                     Varchar(16)         = Null,     
       @Dpname                   Varchar(50)         = Null,     
       @Isin                     Varchar(12)         = Null,     
       @Branch_Cd                Varchar(10)         = Null,     
       @Partipantcode            Varchar(10)         = Null,     
       @Dptype                 Varchar(4)         = Null,     
       @Transno                Varchar(15)         ,           
       @Drcr                       Varchar(1)    ,   
       @Bdptype               Varchar(4)         = Null,     
       @Bdpid                     Varchar(16)         = Null,     
       @Bcltaccno             Varchar(50)         = Null,   
       @Filler1  Varchar(100),         
       @Filler2  Int,   
       @Filler3  Int,   
       @Filler4  Int,   
       @Filler5  Int  
  
As  
  
       Declare @Procname Varchar(50)  
       Select @Procname = Object_Name(@@Procid)  
  
       Begin Transaction Trninsans  
  
              Begin  
                     Insert Into Demattransspeed(  
                                          Sett_No,   
                                          Sett_Type,   
                                          Refno,   
                                          Tcode,   
                                          Trtype,   
                                          Party_Code,   
                                          Scrip_Cd,   
                                          Series,   
                                          Qty,   
                                          Trdate,   
                                          Cltaccno,   
                                          Dpid,   
                                          Dpname,   
                                          Isin,   
                                          Branch_Cd,   
                                          Partipantcode,   
                                          Dptype,   
                                          Transno,   
                                          Drcr,   
               Bdptype,                 
               Bdpid,   
                      Bcltaccno,   
               Filler1,           
               Filler2,   
                                          Filler3,   
                                          Filler4,   
               Filler5  
                                          )  
                     Select  
                                          @Sett_No,   
                                          @Sett_Type,   
                                          @Refno,   
                                          @Tcode,   
                                          @Trtype,   
                                          @Party_Code,   
                                          @Scrip_Cd,   
                                          @Series,   
                                          @Qty,   
                                          @Trdate,   
                                          @Cltaccno,   
                                          @Dpid,   
                                          @Dpname,   
                                          @Isin,    
                                          @Branch_Cd,   
                                          @Partipantcode,   
                                          @Dptype,   
                                          @Transno,   
                                          @Drcr,   
               @Bdptype,                 
               @Bdpid,   
                      @Bcltaccno,   
               @Filler1,           
               @Filler2,   
                                          @Filler3,   
                                          @Filler4,   
               @Filler5  
  
                     If @@Error ! = 0  
                            Begin  
                                   Rollback Transaction Trninsans  
                                   Raiserror('Error Inserting Into Table Demattrans.  Error Occurred In Procedure %s.  Rolling Back Transaction...', 16, 1, @Procname)  
                                   Return  
                            End  
                     Else  
                            Begin  
                                   Commit Transaction Trninsans  
                            End  
              End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MAINPROC
-- --------------------------------------------------

CREATE PROC [dbo].[MAINPROC](@PA_EXCH VARCHAR(100), @PA_PARA1 VARCHAR(100))
AS
BEGIN 

	DECLARE @ROWPOS AS INT,
	@BRDATA AS VARCHAR(500),
	@INSTR AS VARCHAR(500),
	@EXISTSTR AS VARCHAR(500)
,@L_STR VARCHAR(8000)
 SET @INSTR = ''
 SET @EXISTSTR = ''
 SET @ROWPOS = 1
 WHILE 1 = 1  
  BEGIN  
   SET @BRDATA = LTRIM(RTRIM(.DBO.PIECE(@PA_EXCH, ',', @ROWPOS)))  
 
   IF @BRDATA IS NULL OR @BRDATA = ''  
    BEGIN  
     BREAK  
    END  
	
	SET @L_STR  ='EXEC ' + @BRDATA +'..INSERTDATA '''+@PA_PARA1+''''
PRINT @L_STR  
	EXEC(@L_STR  )

	SET @ROWPOS = @ROWPOS+1

END 


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_ADD
-- --------------------------------------------------
CREATE PROC [dbo].[MFSS_CLIENT_ADD]       
(      
 @UNAME VARCHAR(20)     
 ) AS       
      
BEGIN TRAN      
      
 INSERT INTO MFSS_CLIENT       
 SELECT 
		PARTY_CODE = DBO.PIECE(FILE_DATA,'|',1),      
		PARTY_NAME = DBO.PIECE(FILE_DATA,'|',2), 
		CL_TYPE = DBO.PIECE(FILE_DATA,'|',3), 
		CL_BALANCE = LEFT(DBO.PIECE(FILE_DATA,'|',4),1), 
		CL_STATUS = DBO.PIECE(FILE_DATA,'|',5), 
		BRANCH_CD = DBO.PIECE(FILE_DATA,'|',6), 
		SUB_BROKER = DBO.PIECE(FILE_DATA,'|',7), 
		TRADER = DBO.PIECE(FILE_DATA,'|',8), 
		AREA = DBO.PIECE(FILE_DATA,'|',9), 
		REGION = DBO.PIECE(FILE_DATA,'|',10), 
		SBU = DBO.PIECE(FILE_DATA,'|',11), 
		FAMILY = DBO.PIECE(FILE_DATA,'|',12), 
		GENDER = DBO.PIECE(FILE_DATA,'|',13), 
		OCCUPATION_CODE = DBO.PIECE(FILE_DATA,'|',14), 
		TAX_STATUS = DBO.PIECE(FILE_DATA,'|',15), 
		PAN_NO = DBO.PIECE(FILE_DATA,'|',16), 
		KYC_FLAG = DBO.PIECE(FILE_DATA,'|',17), 
		ADDR1 = DBO.PIECE(FILE_DATA,'|',18), 
		ADDR2 = DBO.PIECE(FILE_DATA,'|',19), 
		ADDR3 = DBO.PIECE(FILE_DATA,'|',20), 
		CITY = DBO.PIECE(FILE_DATA,'|',21), 
		STATE = UPPER(DBO.PIECE(FILE_DATA,'|',22)), 
		ZIP = DBO.PIECE(FILE_DATA,'|',23), 
		NATION = DBO.PIECE(FILE_DATA,'|',24), 
		OFFICE_PHONE = DBO.PIECE(FILE_DATA,'|',25), 
		RES_PHONE = DBO.PIECE(FILE_DATA,'|',26), 
		MOBILE_NO = DBO.PIECE(FILE_DATA,'|',27), 
		EMAIL_ID = DBO.PIECE(FILE_DATA,'|',28), 
		BANK_NAME = DBO.PIECE(FILE_DATA,'|',29), 
		BANK_BRANCH = DBO.PIECE(FILE_DATA,'|',30), 
		BANK_CITY = DBO.PIECE(FILE_DATA,'|',31), 
		ACC_NO = DBO.PIECE(FILE_DATA,'|',32), 
		PAYMODE = DBO.PIECE(FILE_DATA,'|',33), 
		MICR_NO = DBO.PIECE(FILE_DATA,'|',34), 
		DOB = DBO.PIECE(FILE_DATA,'|',35), 
		GAURDIAN_NAME = DBO.PIECE(FILE_DATA,'|',36), 
		GAURDIAN_PAN_NO = DBO.PIECE(FILE_DATA,'|',37), 
		NOMINEE_NAME = DBO.PIECE(FILE_DATA,'|',38), 
		NOMINEE_RELATION = DBO.PIECE(FILE_DATA,'|',39), 
		BANK_AC_TYPE = DBO.PIECE(FILE_DATA,'|',40), 
		STAT_COMM_MODE = DBO.PIECE(FILE_DATA,'|',41), 
		DP_TYPE = DBO.PIECE(FILE_DATA,'|',42), 
		DPID = DBO.PIECE(FILE_DATA,'|',43), 
		CLTDPID = DBO.PIECE(FILE_DATA,'|',44), 
		MODE_HOLDING = DBO.PIECE(FILE_DATA,'|',45), 
		HOLDER2_CODE = DBO.PIECE(FILE_DATA,'|',46), 
		HOLDER2_NAME = DBO.PIECE(FILE_DATA,'|',47), 
		HOLDER2_PAN_NO = DBO.PIECE(FILE_DATA,'|',48), 
		HOLDER2_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',49), 
		HOLDER3_CODE = DBO.PIECE(FILE_DATA,'|',50), 
		HOLDER3_NAME = DBO.PIECE(FILE_DATA,'|',51), 
		HOLDER3_PAN_NO = DBO.PIECE(FILE_DATA,'|',52), 
		HOLDER3_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',53), 
		BUY_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',54), 
		SELL_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',55), 
		BROK_EFF_DATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',56),103),109) , 
		NEFTCODE = DBO.PIECE(FILE_DATA,'|',57), 
		CHEQUENAME = DBO.PIECE(FILE_DATA,'|',58), 
		RESIFAX = DBO.PIECE(FILE_DATA,'|',59), 
		OFFICEFAX = DBO.PIECE(FILE_DATA,'|',60), 
		MAPINID = DBO.PIECE(FILE_DATA,'|',61), 
		REMARK = DBO.PIECE(FILE_DATA,'|',62), 
		UCC_STATUS = DBO.PIECE(FILE_DATA,'|',63), 
		ADDEDBY = @UNAME, 
		ADDEDON = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',64),103),109) , 
		ACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109), 
		INACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109),
		POAFLAG =  DBO.PIECE(FILE_DATA,'|',66) 
 FROM       
  CLIENT_ACTIVE_STAT_IMP      
 WHERE LEN(FILE_DATA) > 10      
       
             
COMMIT    

--EXEC MFSS_CLIENT_ADD ''

--SELECT LEN('KALINGODOLA K NUAGAM GANJAM')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_ADD_MODIFY
-- --------------------------------------------------
CREATE PROC [dbo].[MFSS_CLIENT_ADD_MODIFY]       
(      
	@UNAME VARCHAR(20),
	@TYPE  VARCHAR(1),
	@FILE_DATE VARCHAR(11) 
) AS       
      
BEGIN TRAN       

DECLARE @PROFILE_BROK_FLAG VARCHAR(1)

 TRUNCATE TABLE MFSS_CLIENT_TEMP

 INSERT INTO MFSS_CLIENT_TEMP       
 SELECT 
		PARTY_CODE = DBO.PIECE(FILE_DATA,'|',1),     
		PARTY_NAME = DBO.PIECE(FILE_DATA,'|',2),
		CL_TYPE = DBO.PIECE(FILE_DATA,'|',3), 
		CL_BALANCE = LEFT(DBO.PIECE(FILE_DATA,'|',4),1), 
		CL_STATUS = DBO.PIECE(FILE_DATA,'|',5), 
		BRANCH_CD = DBO.PIECE(FILE_DATA,'|',6), 
		SUB_BROKER = DBO.PIECE(FILE_DATA,'|',7), 
		TRADER = DBO.PIECE(FILE_DATA,'|',8), 
		AREA = DBO.PIECE(FILE_DATA,'|',9), 
		REGION = DBO.PIECE(FILE_DATA,'|',10), 
		SBU = DBO.PIECE(FILE_DATA,'|',11), 
		FAMILY = DBO.PIECE(FILE_DATA,'|',12), 
		GENDER = DBO.PIECE(FILE_DATA,'|',13), 
		OCCUPATION_CODE = DBO.PIECE(FILE_DATA,'|',14), 
		TAX_STATUS = DBO.PIECE(FILE_DATA,'|',15), 
		PAN_NO = DBO.PIECE(FILE_DATA,'|',16), 
		KYC_FLAG = DBO.PIECE(FILE_DATA,'|',17), 
		ADDR1 = DBO.PIECE(FILE_DATA,'|',18), 
		ADDR2 = DBO.PIECE(FILE_DATA,'|',19), 
		ADDR3 = DBO.PIECE(FILE_DATA,'|',20), 
		CITY = DBO.PIECE(FILE_DATA,'|',21), 
		STATE = UPPER(DBO.PIECE(FILE_DATA,'|',22)), 
		ZIP = DBO.PIECE(FILE_DATA,'|',23), 
		NATION = DBO.PIECE(FILE_DATA,'|',24), 
		OFFICE_PHONE = DBO.PIECE(FILE_DATA,'|',25), 
		RES_PHONE = DBO.PIECE(FILE_DATA,'|',26), 
		MOBILE_NO = DBO.PIECE(FILE_DATA,'|',27), 
		EMAIL_ID = DBO.PIECE(FILE_DATA,'|',28), 
		BANK_NAME = DBO.PIECE(FILE_DATA,'|',29), 
		BANK_BRANCH = DBO.PIECE(FILE_DATA,'|',30), 
		BANK_CITY = DBO.PIECE(FILE_DATA,'|',31), 
		ACC_NO = DBO.PIECE(FILE_DATA,'|',32), 
		PAYMODE = DBO.PIECE(FILE_DATA,'|',33), 
		MICR_NO = DBO.PIECE(FILE_DATA,'|',34), 
		DOB = DBO.PIECE(FILE_DATA,'|',35), 
		GAURDIAN_NAME = DBO.PIECE(FILE_DATA,'|',36), 
		GAURDIAN_PAN_NO = DBO.PIECE(FILE_DATA,'|',37), 
		NOMINEE_NAME = DBO.PIECE(FILE_DATA,'|',38), 
		NOMINEE_RELATION = DBO.PIECE(FILE_DATA,'|',39), 
		BANK_AC_TYPE = DBO.PIECE(FILE_DATA,'|',40), 
		STAT_COMM_MODE = DBO.PIECE(FILE_DATA,'|',41), 
		DP_TYPE = DBO.PIECE(FILE_DATA,'|',42), 
		DPID = DBO.PIECE(FILE_DATA,'|',43), 
		CLTDPID = DBO.PIECE(FILE_DATA,'|',44), 
		MODE_HOLDING = DBO.PIECE(FILE_DATA,'|',45), 
		HOLDER2_CODE = DBO.PIECE(FILE_DATA,'|',46), 
		HOLDER2_NAME = DBO.PIECE(FILE_DATA,'|',47), 
		HOLDER2_PAN_NO = DBO.PIECE(FILE_DATA,'|',48), 
		HOLDER2_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',49), 
		HOLDER3_CODE = DBO.PIECE(FILE_DATA,'|',50), 
		HOLDER3_NAME = DBO.PIECE(FILE_DATA,'|',51), 
		HOLDER3_PAN_NO = DBO.PIECE(FILE_DATA,'|',52), 
		HOLDER3_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',53), 
		BUY_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',54), 
		SELL_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',55), 
		BROK_EFF_DATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',56),103),109), 
		NEFTCODE = DBO.PIECE(FILE_DATA,'|',57), 
		CHEQUENAME = DBO.PIECE(FILE_DATA,'|',58),
		RESIFAX = DBO.PIECE(FILE_DATA,'|',59),
		OFFICEFAX = DBO.PIECE(FILE_DATA,'|',60),
		MAPINID = DBO.PIECE(FILE_DATA,'|',61),
		REMARK = DBO.PIECE(FILE_DATA,'|',62),
		UCC_STATUS = DBO.PIECE(FILE_DATA,'|',63),
		ADDEDBY = @UNAME,
		ADDEDON = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',64),103),109), 
		ACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109), 
		INACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109),
		POAFLAG =  DBO.PIECE(FILE_DATA,'|',66),
		RECVALID = 'N',
		VALID_SBU = 'N',
		VALID_REGION = 'N',
		VALID_AREA = 'N',
		VALID_TRADER = 'N',
		VALID_SUBBROKER = 'N',
		VALID_BRANCH = 'N',
		VALID_BANK = 'N',
		VALID_DPBANK = 'N',
		BANKID = '',
		VALID_BUY_BROK_TABLE = 'N',
		VALID_SELL_BROK_TABLE = 'N',
		EXCHANGE =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'NM' THEN 'NSE' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'BS' THEN 'BSE' ELSE 'All' END,
		SEGMENT =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'NM' THEN 'MFSS' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'BS' THEN 'STAR' ELSE 'All' END
 FROM       
  CLIENT_ACTIVE_STAT_IMP      
 WHERE LEN(DBO.PIECE(FILE_DATA,'|',1)) > 0       
	
	SELECT @PROFILE_BROK_FLAG = ISNULL(PROFILE_BROK_FLAG,0) FROM OWNER (NOLOCK)

	IF @PROFILE_BROK_FLAG = '0'
	BEGIN
		---- VALIDATE BUY/SELL BROK TABLE NO ----
		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..BROKTABLE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.TABLE_NO 
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..BROKTABLE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.TABLE_NO
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..BROKTABLE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.TABLE_NO 
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..BROKTABLE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.TABLE_NO
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
	END 

	IF @PROFILE_BROK_FLAG = '1'
	BEGIN
		---- VALIDATE BUY/SELL BROK PROFILE ID ----

		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
		
		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

	END
	
	---- VALIDATE SBU ----
	UPDATE MFSS_CLIENT_TEMP SET VALID_SBU = 'Y'                                                       
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..SBU_MASTER AS B                                                       
	WHERE A.SBU = B.SBU_CODE AND SBU_TYPE ='SBU' 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP SET VALID_SBU = 'Y'                                                       
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..SBU_MASTER AS B                                                       
	WHERE A.SBU = B.SBU_CODE AND SBU_TYPE ='SBU' 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
	
	---- VALIDATE REGION ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_AREA = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..REGION AS B                                                       
	WHERE A.REGION = B.REGIONCODE 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_AREA = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..REGION AS B                                                       
	WHERE A.REGION = B.REGIONCODE 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

	---- VALIDATE AREA ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_REGION = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..AREA AS B                                                       
	WHERE A.AREA = B.AREACODE
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_REGION = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..AREA AS B                                                       
	WHERE A.AREA = B.AREACODE
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
	
	---- VALIDATE TRADER ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_TRADER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..BRANCHES AS B                                                       
	WHERE A.TRADER = B.SHORT_NAME                                                      
	AND A.BRANCH_CD = B.BRANCH_CD
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_TRADER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..BRANCHES AS B                                                       
	WHERE A.TRADER = B.SHORT_NAME                                                      
	AND A.BRANCH_CD = B.BRANCH_CD 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

    ---- VALIDATE SUBBROKER ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_SUBBROKER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..SUBBROKERS AS B                                                       
	WHERE A.SUB_BROKER = B.SUB_BROKER 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_SUBBROKER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..SUBBROKERS AS B                                                       
	WHERE A.SUB_BROKER = B.SUB_BROKER 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END 

	---- VALIDATE BRANCH ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BRANCH = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..BRANCH AS B                                                       
	WHERE A.BRANCH_CD = B.BRANCH_CODE
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BRANCH = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..BRANCH AS B                                                       
	WHERE A.BRANCH_CD = B.BRANCH_CODE
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

	---- VALIDATE BANK ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BANK = 'Y' ,BANKID=B.BANKID
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..POBANK AS B                                                       
	WHERE A.BANK_NAME = B.BANK_NAME 
	AND A.BANK_BRANCH = B.BRANCH_NAME
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BANK = 'Y' ,BANKID=B.BANKID
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..POBANK AS B                                                       
	WHERE A.BANK_NAME = B.BANK_NAME 
	AND A.BANK_BRANCH = B.BRANCH_NAME
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
	
	---- VALIDATE DPBANK ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_DPBANK = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS..BANK AS B                                                       
	WHERE A.DPID = B.BANKID 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END 

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_DPBANK = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS..BANK AS B                                                       
	WHERE A.DPID = B.BANKID 
	AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
	AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
	
	-- UPDATING VALID RECORD -----

	UPDATE MFSS_CLIENT_TEMP
	SET RECVALID='Y'
	WHERE 
		VALID_SBU = 'Y'
	AND VALID_REGION = 'Y'
	AND VALID_AREA = 'Y'
	AND VALID_TRADER = 'Y'
	AND VALID_SUBBROKER = 'Y'
	AND VALID_BRANCH = 'Y'
	AND VALID_BANK = 'Y'
	AND VALID_DPBANK = 'Y'
	AND VALID_BUY_BROK_TABLE = 'Y'
	AND	VALID_SELL_BROK_TABLE = 'Y'

	IF @TYPE='A'
	BEGIN             
		-- VALIDATE FOR DUPLICAT RECORD ---
		UPDATE MFSS_CLIENT_TEMP SET RECVALID='N'
		FROM NSEMFSS..MFSS_CLIENT A,MFSS_CLIENT_TEMP B
		WHERE A.PARTY_CODE = B.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

		UPDATE MFSS_CLIENT_TEMP SET RECVALID='N'
		FROM MFSS_CLIENT A,MFSS_CLIENT_TEMP B
		WHERE A.PARTY_CODE = B.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

	END

	IF @TYPE='U'
	BEGIN             
		-- VALIDATE FOR RECORD EXIST---
		UPDATE MFSS_CLIENT_TEMP SET RECVALID='Y'
		FROM NSEMFSS..MFSS_CLIENT A,MFSS_CLIENT_TEMP B
		WHERE A.PARTY_CODE = B.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
		AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
		
		UPDATE MFSS_CLIENT_TEMP SET RECVALID='Y'
		FROM BSEMFSS..MFSS_CLIENT A,MFSS_CLIENT_TEMP B
		WHERE A.PARTY_CODE = B.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
		AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
		AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

	END

	IF @TYPE = 'A' 
		BEGIN
----------------------------NSE-------------------------------------------------------------------------
			INSERT INTO NSEMFSS..MFSS_CLIENT 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
			
			INSERT INTO NSEMFSS..MFSS_DPMASTER 
			SELECT 
			PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,DP_TYPE,DPID,CLTDPID, 
			MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,DEFAULTDP=1, ADDEDBY, ADDEDON, POAFlag 
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

			INSERT INTO NSEMFSS..MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
		
			INSERT INTO BBO_FA..ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','NSE','MFSS'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
			
			/*INSERT INTO BBO_FA..MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','NSE','MFSS',@UNAME,getdate(),@UNAME,getdate(),NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END*/
			
---------------------------------------------BSE-----------------------------------------------------------
			INSERT INTO BSEMFSS..MFSS_CLIENT 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
			
			INSERT INTO BSEMFSS..MFSS_DPMASTER 
			SELECT 
			PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,DP_TYPE,DPID,CLTDPID, 
			MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,DEFAULTDP=1, ADDEDBY, ADDEDON, POAFlag 
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

			INSERT INTO BSEMFSS..MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
		
			INSERT INTO BBO_FA..ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','BSE','STAR'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
			
			/*INSERT INTO BBO_FA..MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','BSE','STAR',@UNAME,getdate(),@UNAME,getdate(),NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END*/

 		END 
	IF @TYPE = 'U' 
		BEGIN
			---------------/////////////// FOR NSE ////////////------------------------------------

			---LOG----

			INSERT INTO NSEMFSS..MFSS_CLIENT_LOG 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,@UNAME,GETDATE(),ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

			---LOG----

			----CLIENT TABLE UPDATE FOR NSE ----

			UPDATE  NSEMFSS..MFSS_CLIENT 
			SET PARTY_CODE = B.PARTY_CODE,     
			PARTY_NAME = B.PARTY_NAME,
			CL_TYPE = B.CL_TYPE, 
			CL_BALANCE = B.CL_BALANCE, 
			CL_STATUS = B.CL_STATUS, 
			BRANCH_CD = B.BRANCH_CD, 
			SUB_BROKER = B.SUB_BROKER, 
			TRADER = B.TRADER, 
			AREA = B.AREA, 
			REGION = B.REGION, 
			SBU = B.SBU, 
			FAMILY = B.FAMILY, 
			GENDER = B.GENDER, 
			OCCUPATION_CODE = B.OCCUPATION_CODE, 
			TAX_STATUS = B.TAX_STATUS, 
			PAN_NO = B.PAN_NO, 
			KYC_FLAG = B.KYC_FLAG, 
			ADDR1 = B.ADDR1, 
			ADDR2 = B.ADDR2, 
			ADDR3 = B.ADDR3, 
			CITY = B.CITY, 
			STATE = B.STATE, 
			ZIP = B.ZIP, 
			NATION = B.NATION, 
			OFFICE_PHONE = B.OFFICE_PHONE, 
			RES_PHONE = B.RES_PHONE, 
			MOBILE_NO = B.MOBILE_NO, 
			EMAIL_ID = B.EMAIL_ID, 
			BANK_NAME = B.BANK_NAME, 
			BANK_BRANCH = B.BANK_BRANCH, 
			BANK_CITY = B.BANK_CITY, 
			ACC_NO = B.ACC_NO, 
			PAYMODE = B.PAYMODE, 
			MICR_NO = B.MICR_NO, 
			DOB = B.DOB, 
			GAURDIAN_NAME = B.GAURDIAN_NAME, 
			GAURDIAN_PAN_NO = B.GAURDIAN_PAN_NO, 
			NOMINEE_NAME =B. NOMINEE_NAME, 
			NOMINEE_RELATION = B.NOMINEE_RELATION, 
			BANK_AC_TYPE = B.BANK_AC_TYPE, 
			STAT_COMM_MODE = B.STAT_COMM_MODE, 
			DP_TYPE = B.DP_TYPE, 
			DPID = B.DPID, 
			CLTDPID = B.CLTDPID, 
			MODE_HOLDING = B.MODE_HOLDING, 
			HOLDER2_CODE = B.HOLDER2_CODE, 
			HOLDER2_NAME = B.HOLDER2_NAME, 
			HOLDER2_PAN_NO = B.HOLDER2_PAN_NO, 
			HOLDER2_KYC_FLAG = B.HOLDER2_KYC_FLAG, 
			HOLDER3_CODE = B.HOLDER3_CODE, 
			HOLDER3_NAME = B.HOLDER3_NAME, 
			HOLDER3_PAN_NO = B.HOLDER3_PAN_NO, 
			HOLDER3_KYC_FLAG = B.HOLDER3_KYC_FLAG, 
			BUY_BROK_TABLE_NO = B.BUY_BROK_TABLE_NO, 
			SELL_BROK_TABLE_NO = B.SELL_BROK_TABLE_NO, 
			BROK_EFF_DATE = B.BROK_EFF_DATE, 
			NEFTCODE = B.NEFTCODE, 
			CHEQUENAME = B.CHEQUENAME,
			RESIFAX = B.RESIFAX,
			OFFICEFAX = B.OFFICEFAX,
			MAPINID = B.MAPINID,
			REMARK = B.REMARK,
			UCC_STATUS = B.UCC_STATUS,
			ADDEDBY = @UNAME,
			ADDEDON = B.ADDEDON, 
			ACTIVE_FROM = B.ACTIVE_FROM, 
			INACTIVE_FROM = B.INACTIVE_FROM,
			POAFLAG =  B.POAFLAG
			FROM NSEMFSS..MFSS_CLIENT AS A,MFSS_CLIENT_TEMP AS B
			WHERE RECVALID='Y' 
			AND A.PARTY_CODE = B.PARTY_CODE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

			DELETE NSEMFSS..MFSS_BROKERAGE_MASTER                                                       
			FROM NSEMFSS..MFSS_BROKERAGE_MASTER AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' AND A.PARTY_CODE = B.PARTY_CODE  
			AND FROMDATE = BROK_EFF_DATE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

			
			UPDATE NSEMFSS..MFSS_BROKERAGE_MASTER SET TODATE = dateadd(d,-1, CONVERT(VARCHAR(11),CONVERT(DATETIME,BROK_EFF_DATE,103),109)  + ' 23:59')
			FROM MFSS_CLIENT_TEMP A,NSEMFSS..MFSS_BROKERAGE_MASTER B
			WHERE A.PARTY_CODE = B.PARTY_CODE
			AND A.BROK_EFF_DATE BETWEEN FROMDATE AND TODATE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
			
			INSERT INTO NSEMFSS..MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END

			DELETE  BBO_FA..ACMAST                                                       
			FROM BBO_FA..ACMAST AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND B.EXCHANGE = CASE WHEN B.EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND B.SEGMENT = CASE WHEN B.SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END	
			
			INSERT INTO BBO_FA..ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','NSE','MFSS'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
			
			/*DELETE  BBO_FA..MULTIBANKID                                                       
			FROM BBO_FA..MULTIBANKID AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND B.EXCHANGE = CASE WHEN B.EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND B.SEGMENT = CASE WHEN B.SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END
			
			INSERT INTO BBO_FA..MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','NSE','MFSS',@UNAME,getdate(),@UNAME,getdate(),NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'NSE' THEN 'NSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'MFSS' THEN 'MFSS' ELSE 'ALL' END*/
			
			---------------/////////////// FOR NSE ////////////------------------------------------

			---------------/////////////// FOR BSE ////////////------------------------------------

			---LOG----

			INSERT INTO BSEMFSS..MFSS_CLIENT_LOG
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,@UNAME,GETDATE(),ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

			---LOG----

			----CLIENT TABLE UPDATE FOR BSE ----

			UPDATE  BSEMFSS..MFSS_CLIENT 
			SET PARTY_CODE = B.PARTY_CODE,     
			PARTY_NAME = B.PARTY_NAME,
			CL_TYPE = B.CL_TYPE, 
			CL_BALANCE = B.CL_BALANCE, 
			CL_STATUS = B.CL_STATUS, 
			BRANCH_CD = B.BRANCH_CD, 
			SUB_BROKER = B.SUB_BROKER, 
			TRADER = B.TRADER, 
			AREA = B.AREA, 
			REGION = B.REGION, 
			SBU = B.SBU, 
			FAMILY = B.FAMILY, 
			GENDER = B.GENDER, 
			OCCUPATION_CODE = B.OCCUPATION_CODE, 
			TAX_STATUS = B.TAX_STATUS, 
			PAN_NO = B.PAN_NO, 
			KYC_FLAG = B.KYC_FLAG, 
			ADDR1 = B.ADDR1, 
			ADDR2 = B.ADDR2, 
			ADDR3 = B.ADDR3, 
			CITY = B.CITY, 
			STATE = B.STATE, 
			ZIP = B.ZIP, 
			NATION = B.NATION, 
			OFFICE_PHONE = B.OFFICE_PHONE, 
			RES_PHONE = B.RES_PHONE, 
			MOBILE_NO = B.MOBILE_NO, 
			EMAIL_ID = B.EMAIL_ID, 
			BANK_NAME = B.BANK_NAME, 
			BANK_BRANCH = B.BANK_BRANCH, 
			BANK_CITY = B.BANK_CITY, 
			ACC_NO = B.ACC_NO, 
			PAYMODE = B.PAYMODE, 
			MICR_NO = B.MICR_NO, 
			DOB = B.DOB, 
			GAURDIAN_NAME = B.GAURDIAN_NAME, 
			GAURDIAN_PAN_NO = B.GAURDIAN_PAN_NO, 
			NOMINEE_NAME =B. NOMINEE_NAME, 
			NOMINEE_RELATION = B.NOMINEE_RELATION, 
			BANK_AC_TYPE = B.BANK_AC_TYPE, 
			STAT_COMM_MODE = B.STAT_COMM_MODE, 
			DP_TYPE = B.DP_TYPE, 
			DPID = B.DPID, 
			CLTDPID = B.CLTDPID, 
			MODE_HOLDING = B.MODE_HOLDING, 
			HOLDER2_CODE = B.HOLDER2_CODE, 
			HOLDER2_NAME = B.HOLDER2_NAME, 
			HOLDER2_PAN_NO = B.HOLDER2_PAN_NO, 
			HOLDER2_KYC_FLAG = B.HOLDER2_KYC_FLAG, 
			HOLDER3_CODE = B.HOLDER3_CODE, 
			HOLDER3_NAME = B.HOLDER3_NAME, 
			HOLDER3_PAN_NO = B.HOLDER3_PAN_NO, 
			HOLDER3_KYC_FLAG = B.HOLDER3_KYC_FLAG, 
			BUY_BROK_TABLE_NO = B.BUY_BROK_TABLE_NO, 
			SELL_BROK_TABLE_NO = B.SELL_BROK_TABLE_NO, 
			BROK_EFF_DATE = B.BROK_EFF_DATE, 
			NEFTCODE = B.NEFTCODE, 
			CHEQUENAME = B.CHEQUENAME,
			RESIFAX = B.RESIFAX,
			OFFICEFAX = B.OFFICEFAX,
			MAPINID = B.MAPINID,
			REMARK = B.REMARK,
			UCC_STATUS = B.UCC_STATUS,
			ADDEDBY = @UNAME,
			ADDEDON = B.ADDEDON, 
			ACTIVE_FROM = B.ACTIVE_FROM, 
			INACTIVE_FROM = B.INACTIVE_FROM,
			POAFLAG =  B.POAFLAG
			FROM BSEMFSS..MFSS_CLIENT AS A,MFSS_CLIENT_TEMP AS B
			WHERE RECVALID='Y' 
			AND A.PARTY_CODE = B.PARTY_CODE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

			DELETE BSEMFSS..MFSS_BROKERAGE_MASTER                                                       
			FROM BSEMFSS..MFSS_BROKERAGE_MASTER AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' AND A.PARTY_CODE = B.PARTY_CODE  
			AND FROMDATE = BROK_EFF_DATE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

			
			UPDATE BSEMFSS..MFSS_BROKERAGE_MASTER SET TODATE = dateadd(d,-1, CONVERT(VARCHAR(11),CONVERT(DATETIME,BROK_EFF_DATE,103),109)  + ' 23:59')
			FROM MFSS_CLIENT_TEMP A,BSEMFSS..MFSS_BROKERAGE_MASTER B
			WHERE A.PARTY_CODE = B.PARTY_CODE
			AND A.BROK_EFF_DATE BETWEEN FROMDATE AND TODATE
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
			
			INSERT INTO BSEMFSS..MFSS_BROKERAGE_MASTER
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END

			DELETE  BBO_FA..ACMAST                                                       
			FROM BBO_FA..ACMAST AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND B.EXCHANGE = CASE WHEN B.EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND B.SEGMENT = CASE WHEN B.SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END	
			
			INSERT  INTO BBO_FA..ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','BSE','STAR'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
			
			/*DELETE  BBO_FA..MULTIBANKID                                                       
			FROM BBO_FA..MULTIBANKID AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND B.EXCHANGE = CASE WHEN B.EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND B.SEGMENT = CASE WHEN B.SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END
			
			INSERT INTO BBO_FA..MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','BSE','STAR',@UNAME,getdate(),@UNAME,getdate(),NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND EXCHANGE = CASE WHEN EXCHANGE = 'BSE' THEN 'BSE' ELSE 'ALL' END
			AND SEGMENT = CASE WHEN SEGMENT = 'STAR' THEN 'STAR' ELSE 'ALL' END*/
			
			---------------/////////////// FOR BSE ////////////------------------------------------
		END 
			----CLIENT TABLE UPDATE----
 COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_ADD_MODIFY_old
-- --------------------------------------------------
create PROC [dbo].[MFSS_CLIENT_ADD_MODIFY_old]       
(      
	@UNAME VARCHAR(20),
	@TYPE  VARCHAR(1),
	@FILE_DATE VARCHAR(11) 
) AS       
      
BEGIN TRAN       

DECLARE @PROFILE_BROK_FLAG VARCHAR(1)

 TRUNCATE TABLE MFSS_CLIENT_TEMP

 INSERT INTO MFSS_CLIENT_TEMP       
 SELECT 
		PARTY_CODE = DBO.PIECE(FILE_DATA,'|',1),     
		PARTY_NAME = DBO.PIECE(FILE_DATA,'|',2),
		CL_TYPE = DBO.PIECE(FILE_DATA,'|',3), 
		CL_BALANCE = LEFT(DBO.PIECE(FILE_DATA,'|',4),1), 
		CL_STATUS = DBO.PIECE(FILE_DATA,'|',5), 
		BRANCH_CD = DBO.PIECE(FILE_DATA,'|',6), 
		SUB_BROKER = DBO.PIECE(FILE_DATA,'|',7), 
		TRADER = DBO.PIECE(FILE_DATA,'|',8), 
		AREA = DBO.PIECE(FILE_DATA,'|',9), 
		REGION = DBO.PIECE(FILE_DATA,'|',10), 
		SBU = DBO.PIECE(FILE_DATA,'|',11), 
		FAMILY = DBO.PIECE(FILE_DATA,'|',12), 
		GENDER = DBO.PIECE(FILE_DATA,'|',13), 
		OCCUPATION_CODE = DBO.PIECE(FILE_DATA,'|',14), 
		TAX_STATUS = DBO.PIECE(FILE_DATA,'|',15), 
		PAN_NO = DBO.PIECE(FILE_DATA,'|',16), 
		KYC_FLAG = DBO.PIECE(FILE_DATA,'|',17), 
		ADDR1 = DBO.PIECE(FILE_DATA,'|',18), 
		ADDR2 = DBO.PIECE(FILE_DATA,'|',19), 
		ADDR3 = DBO.PIECE(FILE_DATA,'|',20), 
		CITY = DBO.PIECE(FILE_DATA,'|',21), 
		STATE = UPPER(DBO.PIECE(FILE_DATA,'|',22)), 
		ZIP = DBO.PIECE(FILE_DATA,'|',23), 
		NATION = DBO.PIECE(FILE_DATA,'|',24), 
		OFFICE_PHONE = DBO.PIECE(FILE_DATA,'|',25), 
		RES_PHONE = DBO.PIECE(FILE_DATA,'|',26), 
		MOBILE_NO = DBO.PIECE(FILE_DATA,'|',27), 
		EMAIL_ID = DBO.PIECE(FILE_DATA,'|',28), 
		BANK_NAME = DBO.PIECE(FILE_DATA,'|',29), 
		BANK_BRANCH = DBO.PIECE(FILE_DATA,'|',30), 
		BANK_CITY = DBO.PIECE(FILE_DATA,'|',31), 
		ACC_NO = DBO.PIECE(FILE_DATA,'|',32), 
		PAYMODE = DBO.PIECE(FILE_DATA,'|',33), 
		MICR_NO = DBO.PIECE(FILE_DATA,'|',34), 
		DOB = DBO.PIECE(FILE_DATA,'|',35), 
		GAURDIAN_NAME = DBO.PIECE(FILE_DATA,'|',36), 
		GAURDIAN_PAN_NO = DBO.PIECE(FILE_DATA,'|',37), 
		NOMINEE_NAME = DBO.PIECE(FILE_DATA,'|',38), 
		NOMINEE_RELATION = DBO.PIECE(FILE_DATA,'|',39), 
		BANK_AC_TYPE = DBO.PIECE(FILE_DATA,'|',40), 
		STAT_COMM_MODE = DBO.PIECE(FILE_DATA,'|',41), 
		DP_TYPE = DBO.PIECE(FILE_DATA,'|',42), 
		DPID = DBO.PIECE(FILE_DATA,'|',43), 
		CLTDPID = DBO.PIECE(FILE_DATA,'|',44), 
		MODE_HOLDING = DBO.PIECE(FILE_DATA,'|',45), 
		HOLDER2_CODE = DBO.PIECE(FILE_DATA,'|',46), 
		HOLDER2_NAME = DBO.PIECE(FILE_DATA,'|',47), 
		HOLDER2_PAN_NO = DBO.PIECE(FILE_DATA,'|',48), 
		HOLDER2_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',49), 
		HOLDER3_CODE = DBO.PIECE(FILE_DATA,'|',50), 
		HOLDER3_NAME = DBO.PIECE(FILE_DATA,'|',51), 
		HOLDER3_PAN_NO = DBO.PIECE(FILE_DATA,'|',52), 
		HOLDER3_KYC_FLAG = DBO.PIECE(FILE_DATA,'|',53), 
		BUY_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',54), 
		SELL_BROK_TABLE_NO = DBO.PIECE(FILE_DATA,'|',55), 
		BROK_EFF_DATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',56),103),109), 
		NEFTCODE = DBO.PIECE(FILE_DATA,'|',57), 
		CHEQUENAME = DBO.PIECE(FILE_DATA,'|',58),
		RESIFAX = DBO.PIECE(FILE_DATA,'|',59),
		OFFICEFAX = DBO.PIECE(FILE_DATA,'|',60),
		MAPINID = DBO.PIECE(FILE_DATA,'|',61),
		REMARK = DBO.PIECE(FILE_DATA,'|',62),
		UCC_STATUS = DBO.PIECE(FILE_DATA,'|',63),
		ADDEDBY = @UNAME,
		ADDEDON = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',64),103),109), 
		ACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109), 
		INACTIVE_FROM = CONVERT(VARCHAR(11),CONVERT(DATETIME,DBO.PIECE(FILE_DATA,'|',65),103),109),
		POAFLAG =  DBO.PIECE(FILE_DATA,'|',66),
		RECVALID = 'N',
		VALID_SBU = 'N',
		VALID_REGION = 'N',
		VALID_AREA = 'N',
		VALID_TRADER = 'N',
		VALID_SUBBROKER = 'N',
		VALID_BRANCH = 'N',
		VALID_BANK = 'N',
		VALID_DPBANK = 'N',
		BANKID = '',
		VALID_BUY_BROK_TABLE = 'N',
		VALID_SELL_BROK_TABLE = 'N',
		NSE_EXCHANGE =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'NM' THEN 'NSE' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'B' THEN 'NSE' END,
		NSE_SEGMENT =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'NM' THEN 'MFSS' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'B' THEN 'MFSS' END,
		BSE_EXCHANGE =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'BS' THEN 'BSE' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'B' THEN 'BSE' END,
		BSE_SEGMENT =  CASE WHEN DBO.PIECE(FILE_DATA,'|',67) = 'BS' THEN 'STAR' WHEN DBO.PIECE(FILE_DATA,'|',67) = 'B' THEN 'STAR' END
 FROM       
  CLIENT_ACTIVE_STAT_IMP      
 WHERE LEN(DBO.PIECE(FILE_DATA,'|',1)) > 0       
	
	SELECT @PROFILE_BROK_FLAG = ISNULL(PROFILE_BROK_FLAG,0) FROM OWNER (NOLOCK)

	IF @PROFILE_BROK_FLAG = '0'
	BEGIN
		---- VALIDATE BUY/SELL BROK TABLE NO ----
		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.BROKTABLE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.TABLE_NO 
		AND NSE_EXCHANGE = 'NSE'
		AND NSE_SEGMENT = 'MFSS'

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.BROKTABLE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.TABLE_NO
		AND NSE_EXCHANGE = 'NSE'
		AND NSE_SEGMENT = 'MFSS'

		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.BROKTABLE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.TABLE_NO 
		AND BSE_EXCHANGE = 'BSE'
		AND BSE_SEGMENT = 'STAR'

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.BROKTABLE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.TABLE_NO
		AND BSE_EXCHANGE = 'BSE'
		AND BSE_SEGMENT = 'STAR'
	END 

	IF @PROFILE_BROK_FLAG = '1'
	BEGIN
		---- VALIDATE BUY/SELL BROK PROFILE ID ----

		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND NSE_EXCHANGE = 'NSE'
		AND NSE_SEGMENT = 'MFSS'

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND NSE_EXCHANGE = 'NSE'
		AND NSE_SEGMENT = 'MFSS'
		
		UPDATE MFSS_CLIENT_TEMP SET VALID_BUY_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.BUY_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND BSE_EXCHANGE = 'BSE'
		AND BSE_SEGMENT = 'STAR'

		UPDATE MFSS_CLIENT_TEMP SET VALID_SELL_BROK_TABLE = 'Y'                                                       
		FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.MFSS_BRANCH_BROK_PROFILE AS B                                                       
		WHERE A.SELL_BROK_TABLE_NO = B.PROFILE_ID
		AND BROK_EFF_DATE BETWEEN DATE_FROM AND DATE_TO
		AND SELL_BUY_FLAG = 1
		AND ((A.BRANCH_CD = B.BRANCH_CD) OR  (B.BRANCH_CD = 'ALL'))
		AND BSE_EXCHANGE = 'BSE'
		AND BSE_SEGMENT = 'STAR'

	END
	
	---- VALIDATE SBU ----
	UPDATE MFSS_CLIENT_TEMP SET VALID_SBU = 'Y'                                                       
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.SBU_MASTER AS B                                                       
	WHERE A.SBU = B.SBU_CODE AND SBU_TYPE ='SBU' 
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP SET VALID_SBU = 'Y'                                                       
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.SBU_MASTER AS B                                                       
	WHERE A.SBU = B.SBU_CODE AND SBU_TYPE ='SBU' 
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'
	
	---- VALIDATE REGION ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_AREA = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.REGION AS B                                                       
	WHERE A.REGION = B.REGIONCODE 
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_AREA = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.REGION AS B                                                       
	WHERE A.REGION = B.REGIONCODE 
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'

	---- VALIDATE AREA ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_REGION = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.AREA AS B                                                       
	WHERE A.AREA = B.AREACODE
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_REGION = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.AREA AS B                                                       
	WHERE A.AREA = B.AREACODE
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'
	
	---- VALIDATE TRADER ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_TRADER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.BRANCHES AS B                                                       
	WHERE A.TRADER = B.SHORT_NAME                                                      
	AND A.BRANCH_CD = B.BRANCH_CD
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_TRADER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.BRANCHES AS B                                                       
	WHERE A.TRADER = B.SHORT_NAME                                                      
	AND A.BRANCH_CD = B.BRANCH_CD 
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'

    ---- VALIDATE SUBBROKER ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_SUBBROKER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.SUBBROKERS AS B                                                       
	WHERE A.SUB_BROKER = B.SUB_BROKER 
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_SUBBROKER = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.SUBBROKERS AS B                                                       
	WHERE A.SUB_BROKER = B.SUB_BROKER 
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR' 

	---- VALIDATE BRANCH ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BRANCH = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.BRANCH AS B                                                       
	WHERE A.BRANCH_CD = B.BRANCH_CODE
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BRANCH = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.BRANCH AS B                                                       
	WHERE A.BRANCH_CD = B.BRANCH_CODE
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'

	---- VALIDATE BANK ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BANK = 'Y' ,BANKID=B.BANKID
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.POBANK AS B                                                       
	WHERE A.BANK_NAME = B.BANK_NAME 
	AND A.BANK_BRANCH = B.BRANCH_NAME
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS'

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_BANK = 'Y' ,BANKID=B.BANKID
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.POBANK AS B                                                       
	WHERE A.BANK_NAME = B.BANK_NAME 
	AND A.BANK_BRANCH = B.BRANCH_NAME
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'
	
	---- VALIDATE DPBANK ----

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_DPBANK = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, NSEMFSS.DBO.BANK AS B                                                       
	WHERE A.DPID = B.BANKID 
	AND NSE_EXCHANGE = 'NSE'
	AND NSE_SEGMENT = 'MFSS' 

	UPDATE MFSS_CLIENT_TEMP                               
	SET VALID_DPBANK = 'Y'                               
	FROM MFSS_CLIENT_TEMP AS A, BSEMFSS.DBO.BANK AS B                                                       
	WHERE A.DPID = B.BANKID 
	AND BSE_EXCHANGE = 'BSE'
	AND BSE_SEGMENT = 'STAR'
	
	-- UPDATING VALID RECORD -----

	UPDATE MFSS_CLIENT_TEMP
	SET RECVALID='Y'
	WHERE 
		VALID_SBU = 'Y'
	AND VALID_REGION = 'Y'
	AND VALID_AREA = 'Y'
	AND VALID_TRADER = 'Y'
	AND VALID_SUBBROKER = 'Y'
	AND VALID_BRANCH = 'Y'
	AND VALID_BANK = 'Y'
	AND VALID_DPBANK = 'Y'
	AND VALID_BUY_BROK_TABLE = 'Y'
	AND	VALID_SELL_BROK_TABLE = 'Y'

	IF @TYPE='A'
	BEGIN             
		-- VALIDATE FOR DUPLICAT RECORD ---
		UPDATE MFSS_CLIENT_TEMP SET RECVALID='N'
		FROM MFSS_CLIENT A,MFSS_CLIENT_TEMP B
		WHERE A.PARTY_CODE = B.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
	END

	IF @TYPE='U'
	BEGIN             
		-- VALIDATE FOR RECORD EXIST---
		UPDATE MFSS_CLIENT_TEMP SET RECVALID='Y'
		FROM MFSS_CLIENT
		WHERE MFSS_CLIENT.PARTY_CODE = MFSS_CLIENT_TEMP.PARTY_CODE
		AND VALID_SBU = 'Y'
		AND VALID_REGION = 'Y'
		AND VALID_AREA = 'Y'
		AND VALID_TRADER = 'Y'
		AND VALID_SUBBROKER = 'Y'
		AND VALID_BRANCH = 'Y'
		AND VALID_BANK = 'Y'
		AND VALID_DPBANK = 'Y'
		AND VALID_BUY_BROK_TABLE = 'Y'
		AND	VALID_SELL_BROK_TABLE = 'Y'
	END

	IF @TYPE = 'A' 
		BEGIN
----------------------------NSE-------------------------------------------------------------------------
			INSERT INTO NSEMFSS.DBO.MFSS_CLIENT 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
			INSERT INTO NSEMFSS.DBO.MFSS_DPMASTER 
			SELECT 
			PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,DP_TYPE,DPID,CLTDPID, 
			MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,DEFAULTDP=1, ADDEDBY, ADDEDON, POAFlag 
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'

			INSERT INTO NSEMFSS.DBO.MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
		
			INSERT INTO BBO_FA.DBO.ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','NSE','MFSS'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
			INSERT INTO BBO_FA.DBO.MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','NSE','MFSS','','','','',NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
---------------------------------------------BSE-----------------------------------------------------------
			INSERT INTO BSEMFSS.DBO.MFSS_CLIENT 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND BSE_EXCHANGE = 'BSE'
			AND BSE_SEGMENT = 'STAR'
			
			INSERT INTO BSEMFSS.DBO.MFSS_DPMASTER 
			SELECT 
			PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,DP_TYPE,DPID,CLTDPID, 
			MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,DEFAULTDP=1, ADDEDBY, ADDEDON, POAFlag 
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND BSE_EXCHANGE = 'BSE'
			AND BSE_SEGMENT = 'STAR'

			INSERT INTO BSEMFSS.DBO.MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND BSE_EXCHANGE = 'BSE'
			AND BSE_SEGMENT = 'STAR'
		
			INSERT INTO BBO_FA.DBO.ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','BSE','STAR'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND BSE_EXCHANGE = 'BSE'
			AND BSE_SEGMENT = 'STAR'
			
			INSERT INTO BBO_FA.DBO.MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','BSE','STAR','','','','',NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND BSE_EXCHANGE = 'BSE'
			AND BSE_SEGMENT = 'STAR'

 		END 
	IF @TYPE = 'U' 
		BEGIN
			---LOG----

			INSERT INTO MFSS_CLIENT_LOG 
			SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,
			SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
			NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
			MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,
			DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,
			HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,
			CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,@UNAME,GETDATE(),ACTIVE_FROM,INACTIVE_FROM,POAFLAG
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'

			---LOG----

			----CLIENT TABLE UPDATE FOR NSE ----

			UPDATE  NSEMFSS.DBO.MFSS_CLIENT 
			SET PARTY_CODE = B.PARTY_CODE,     
			PARTY_NAME = B.PARTY_NAME,
			CL_TYPE = B.CL_TYPE, 
			CL_BALANCE = B.CL_BALANCE, 
			CL_STATUS = B.CL_STATUS, 
			BRANCH_CD = B.BRANCH_CD, 
			SUB_BROKER = B.SUB_BROKER, 
			TRADER = B.TRADER, 
			AREA = B.AREA, 
			REGION = B.REGION, 
			SBU = B.SBU, 
			FAMILY = B.FAMILY, 
			GENDER = B.GENDER, 
			OCCUPATION_CODE = B.OCCUPATION_CODE, 
			TAX_STATUS = B.TAX_STATUS, 
			PAN_NO = B.PAN_NO, 
			KYC_FLAG = B.KYC_FLAG, 
			ADDR1 = B.ADDR1, 
			ADDR2 = B.ADDR2, 
			ADDR3 = B.ADDR3, 
			CITY = B.CITY, 
			STATE = B.STATE, 
			ZIP = B.ZIP, 
			NATION = B.NATION, 
			OFFICE_PHONE = B.OFFICE_PHONE, 
			RES_PHONE = B.RES_PHONE, 
			MOBILE_NO = B.MOBILE_NO, 
			EMAIL_ID = B.EMAIL_ID, 
			BANK_NAME = B.BANK_NAME, 
			BANK_BRANCH = B.BANK_BRANCH, 
			BANK_CITY = B.BANK_CITY, 
			ACC_NO = B.ACC_NO, 
			PAYMODE = B.PAYMODE, 
			MICR_NO = B.MICR_NO, 
			DOB = B.DOB, 
			GAURDIAN_NAME = B.GAURDIAN_NAME, 
			GAURDIAN_PAN_NO = B.GAURDIAN_PAN_NO, 
			NOMINEE_NAME =B. NOMINEE_NAME, 
			NOMINEE_RELATION = B.NOMINEE_RELATION, 
			BANK_AC_TYPE = B.BANK_AC_TYPE, 
			STAT_COMM_MODE = B.STAT_COMM_MODE, 
			DP_TYPE = B.DP_TYPE, 
			DPID = B.DPID, 
			CLTDPID = B.CLTDPID, 
			MODE_HOLDING = B.MODE_HOLDING, 
			HOLDER2_CODE = B.HOLDER2_CODE, 
			HOLDER2_NAME = B.HOLDER2_NAME, 
			HOLDER2_PAN_NO = B.HOLDER2_PAN_NO, 
			HOLDER2_KYC_FLAG = B.HOLDER2_KYC_FLAG, 
			HOLDER3_CODE = B.HOLDER3_CODE, 
			HOLDER3_NAME = B.HOLDER3_NAME, 
			HOLDER3_PAN_NO = B.HOLDER3_PAN_NO, 
			HOLDER3_KYC_FLAG = B.HOLDER3_KYC_FLAG, 
			BUY_BROK_TABLE_NO = B.BUY_BROK_TABLE_NO, 
			SELL_BROK_TABLE_NO = B.SELL_BROK_TABLE_NO, 
			BROK_EFF_DATE = B.BROK_EFF_DATE, 
			NEFTCODE = B.NEFTCODE, 
			CHEQUENAME = B.CHEQUENAME,
			RESIFAX = B.RESIFAX,
			OFFICEFAX = B.OFFICEFAX,
			MAPINID = B.MAPINID,
			REMARK = B.REMARK,
			UCC_STATUS = B.UCC_STATUS,
			ADDEDBY = @UNAME,
			ADDEDON = B.ADDEDON, 
			ACTIVE_FROM = B.ACTIVE_FROM, 
			INACTIVE_FROM = B.INACTIVE_FROM,
			POAFLAG =  B.POAFLAG
			FROM NSEMFSS.DBO.MFSS_CLIENT AS A,MFSS_CLIENT_TEMP AS B
			WHERE RECVALID='Y' 
			AND A.PARTY_CODE = B.PARTY_CODE
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'

			DELETE NSEMFSS.DBO.MFSS_BROKERAGE_MASTER                                                       
			FROM NSEMFSS.DBO.MFSS_BROKERAGE_MASTER AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' AND A.PARTY_CODE = B.PARTY_CODE  
			AND FROMDATE = BROK_EFF_DATE
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'

			
			UPDATE NSEMFSS.DBO.MFSS_BROKERAGE_MASTER SET TODATE = dateadd(d,-1, CONVERT(VARCHAR(11),CONVERT(DATETIME,BROK_EFF_DATE,103),109)  + ' 23:59')
			FROM MFSS_CLIENT_TEMP A,NSEMFSS.DBO.MFSS_BROKERAGE_MASTER B
			WHERE A.PARTY_CODE = B.PARTY_CODE
			AND A.BROK_EFF_DATE BETWEEN FROMDATE AND TODATE
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
			INSERT INTO NSEMFSS.DBO.MFSS_BROKERAGE_MASTER 
			SELECT PARTY_CODE,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,'Dec 31 2049 23:59'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'

			DELETE  BBO_FA.DBO.ACMAST                                                       
			FROM BBO_FA.DBO.ACMAST AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'	
			
			INSERT INTO BBO_FA.DBO.ACMAST 
			SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','',MICR_NO,BRANCH_CD,0,'C','','','','NSE','MFSS'
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
			DELETE  BBO_FA.DBO.MULTIBANKID                                                       
			FROM BBO_FA.DBO.MULTIBANKID AS A, MFSS_CLIENT_TEMP AS B                                                       
			WHERE B.RECVALID = 'Y' 
			AND A.CLTCODE = B.PARTY_CODE  
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'
			
			INSERT INTO BBO_FA.DBO.MULTIBANKID SELECT PARTY_CODE,BANKID,ACC_NO,'SB',PARTY_NAME,'1','NSE','MFSS','','','','',NULL,'',''
			FROM MFSS_CLIENT_TEMP WHERE RECVALID='Y'
			AND NSE_EXCHANGE = 'NSE'
			AND NSE_SEGMENT = 'MFSS'

		END 
			----CLIENT TABLE UPDATE----
 COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_CI
-- --------------------------------------------------
  
--DROP TABLE #MFSS_CLIENT_COMMONINTERFACE  
  
  
  
CREATE PROC MFSS_CLIENT_CI  
AS  
  
/** MFSS CLIENT INSERT PROVIDED BY MKT  
SOURCE : INHOUSE  
DESTINATION :MFSS (NSE,BSE)  
CREATED BY : SIVA KUMAR   
DATE: 2015-11-19' **/  
  
BEGIN   
SELECT * INTO #MFSS_CLIENT_COMMONINTERFACE   
FROM MFSS_CLIENT_COMMONINTERFACE WHERE CIFLAG=0  
  
UPDATE #MFSS_CLIENT_COMMONINTERFACE SET   
DP_TYPE=CD.DEPOSITORY1,  
DPID=CD.DPID1,  
CLTDPID=CD.CLTDPID1  
 FROM [196.1.115.196].MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE #MFSS_CLIENT_COMMONINTERFACE.PARTY_CODE=CD.CL_CODE  
  
DELETE FROM #MFSS_CLIENT_COMMONINTERFACE WHERE DP_TYPE NOT IN ('CDSL','NSDL')  
  
  
--INSERT INTO MFSS_CLIENT  
SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK
_BRANCH,BANK_CITY,ACC_NO,PAYMODE,MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,HOLDER3_NAME,HOLD
ER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
--INSERT INTO BSEMFSS..MFSS_CLIENT  
SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK
_BRANCH,BANK_CITY,ACC_NO,PAYMODE,MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,HOLDER3_NAME,HOLD
ER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
  
--INSERT INTO BBO_FA.DBO.ACMAST   
SELECT PARTY_NAME,PARTY_NAME,ACTYP='ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','BSE','MFSS'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
--INSERT INTO BBO_FA.DBO.ACMAST   
SELECT PARTY_NAME,PARTY_NAME,ACTYP='ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','NSE','MFSS'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
--INSERT INTO MFSS_BROKERAGE_MASTER  
SELECT PARTY_CODE,1,1,GETDATE(),'2049-12-31 23:59:00.000'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
--INSERT INTO BSEMFSS..MFSS_BROKERAGE_MASTER  
SELECT PARTY_CODE,1,1,GETDATE(),'2049-12-31 23:59:00.000'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
--INSERT INTO MFSS_DPMASTER  
SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,  
DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,1,ADDEDBY,ADDEDON,POAFLAG  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
--INSERT INTO BSEMFSS..MFSS_DPMASTER  
SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,  
DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER3_NAME,HOLDER3_PAN_NO,1,ADDEDBY,ADDEDON,POAFLAG  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
---NSE--  
INSERT INTO POBANK  
SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM #MFSS_CLIENT_COMMONINTERFACE M  
LEFT OUTER   
JOIN POBANK  
ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME  
WHERE BANKID IS NULL  
GROUP BY M.BANK_NAME, BANK_BRANCH  
  
---BSE  
INSERT INTO POBANK  
SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM #MFSS_CLIENT_COMMONINTERFACE M  
LEFT OUTER   
JOIN BSEMFSS..POBANK  
ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME  
WHERE BANKID IS NULL  
GROUP BY M.BANK_NAME, BANK_BRANCH  
  
  
INSERT INTO BBO_FA.DBO.MULTIBANKID(Cltcode,Bankid,Accno,Acctype,Chequename,Defaultbank,exchange,segment)  
SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'BSE','MFSS'  
FROM  #MFSS_CLIENT_COMMONINTERFACE M , POBANK P  
WHERE CIFLAG=0  
AND M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  
GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME   
  
INSERT INTO BBO_FA.DBO.MULTIBANKID  
SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'NSE','MFSS'  
FROM  #MFSS_CLIENT_COMMONINTERFACE M , POBANK P  
WHERE CIFLAG=0  
AND M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  
GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME   
  
UPDATE MFSS_CLIENT_COMMONINTERFACE SET CIFLAG=1  
WHERE PARTY_CODE IN   
(SELECT PARTY_CODE FROM #MFSS_CLIENT_COMMONINTERFACE)  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_UPDATE_MSAJAG
-- --------------------------------------------------
--EXEC MFSS_CLIENT_UPDATE_MSAJAG
CREATE PROCEDURE [dbo].[MFSS_CLIENT_UPDATE_MSAJAG]
AS
BEGIN
	INSERT INTO MFSS_CLIENT_TEST
	SELECT     
	 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,    
	 SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,    
	 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',    
	 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,    
	 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,    
	 BANK_NAME=ISNULL(C4.BANK_NAME,''),BANK_BRANCH=ISNULL(C4.BRANCH_NAME,''),BANK_CITY=ISNULL(C4.CITY,''),    
	 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),    
	 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',    
	 BANK_AC_TYPE = (CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING'   
		   THEN 'SB'   
		   WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING'   
						  THEN 'CB'   
						  ELSE ''   
					 END),  
	 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),    
	 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',    
	 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',    
	 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',    
	 BROK_EFF_DATE=CONVERT(DATETIME,(CONVERT(VARCHAR(11),GETDATE(),103)),103),NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID='',REMARK='',UCC_STATUS='',
	 ADDEDBY='SYSTEM',ADDEDON=GETDATE(),ACTIVE_FROM=GETDATE(),INACTIVE_FROM='',    
	 POAFLAG = ''    
	FROM    
	 MSAJAG..CLIENT1 C1 (NOLOCK), MSAJAG..CLIENT2 C2 (NOLOCK)    
	 LEFT OUTER JOIN ACCOUNT..ACMAST (NOLOCK)    
	  ON (CLTCODE = C2.PARTY_CODE)    
	 LEFT OUTER JOIN (SELECT PARTY_CODE,CL4.BANKID,CLTDPID,DEPOSITORY,BANK_NAME,BRANCH_NAME,CITY FROM MSAJAG..CLIENT4 CL4,MSAJAG..POBANK P(NOLOCK)   
	 WHERE DEPOSITORY IN ('SAVING','CURRENT') AND CL4.BANKID=P.BANKID) C4    
	 ON (C2.PARTY_CODE = C4.PARTY_CODE)    
	 LEFT OUTER JOIN MSAJAG..CLIENT5 C5 (NOLOCK)    
	 ON (C5.CL_CODE = C2.PARTY_CODE)    
	 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM MSAJAG..CLIENT4 (NOLOCK)   
	 WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44    
	 ON (C2.PARTY_CODE = C44.PARTY_CODE)    
	WHERE    
	 C1.CL_CODE = C2.CL_CODE    
	 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT_TEST MC (NOLOCK)   
	WHERE MC.PARTY_CODE = C2.PARTY_CODE)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_NAV01_UPD
-- --------------------------------------------------
CREATE PROC [dbo].[MFSS_NAV01_UPD] (@TRADEDATE VARCHAR(11)) AS

IF @TRADEDATE =''
BEGIN
	 RETURN 
END

IF (SELECT COUNT(1) FROM MFSS_NAV01_TMP) =0
BEGIN
	 RETURN 
END

CREATE TABLE #MFSS_NAV01
(
	ISIN_GROWTH VARCHAR(16),
	ISIN_REINVESTMENT VARCHAR(16),
	NET_ASSET_VALUE NUMERIC(18,4)
)

INSERT INTO #MFSS_NAV01
SELECT 
	ISIN_GROWTH			= ISNULL(DBO.PIECE(FILEDATA,';',2),'') ,
	ISIN_REINVESTMENT	= ISNULL(DBO.PIECE(FILEDATA,';',3),'') ,
	NET_ASSET_VALUE		= CONVERT(NUMERIC(18,4),ISNULL(DBO.PIECE(FILEDATA,';',5),0)) 
FROM MFSS_NAV01_TMP 
WHERE CHARINDEX('INF',FILEDATA) > 0
AND CHARINDEX('N.A.',FILEDATA) = 0


DELETE MFSS_NAV01 WHERE NAV_DATE = @TRADEDATE

INSERT INTO MFSS_NAV01
SELECT @TRADEDATE,ISIN_GROWTH,NET_ASSET_VALUE
FROM #MFSS_NAV01 WHERE NET_ASSET_VALUE <> 0
AND LTRIM(RTRIM(ISIN_GROWTH)) <> ''
AND LTRIM(RTRIM(ISIN_GROWTH)) <> '-'
AND LTRIM(RTRIM(ISIN_GROWTH)) <> '.'

INSERT INTO MFSS_NAV01
SELECT @TRADEDATE,ISIN_REINVESTMENT,NET_ASSET_VALUE
FROM #MFSS_NAV01 WHERE NET_ASSET_VALUE <> 0
AND LTRIM(RTRIM(ISIN_REINVESTMENT)) <> ''
AND LTRIM(RTRIM(ISIN_REINVESTMENT)) <> '-'
AND LTRIM(RTRIM(ISIN_REINVESTMENT)) <> '.'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NEWVALANSUMMARY_NORMAL
-- --------------------------------------------------

  
/*use bsedb      
Exec NEWVALANSUMMARY_NORMAL '2007071', 'D', 'Jul 10 2007', 'A', 'broker', 'broker','NSE','MFSS','account',''  
Exec NEWVALANSUMMARY_NORMAL '2007071', 'D', '10/07/2007', 'P', 'broker', 'broker','NSE','MFSS','account',''*/      
/*        
 EXEC ..NEWVALANSUMMARY'2006070', 'N', 'APR  1 2006', 'O', 'CLIENT', 'ME123'        
*/    
      
CREATE PROCEDURE [dbo].[NEWVALANSUMMARY_NORMAL]          
 (     
 @SETT_NO VARCHAR(7),        
 @SETT_TYPE VARCHAR(2),        
 @VDT VARCHAR(11),        
 @DISPOPT VARCHAR(1),        
 @STATUSID VARCHAR(10),        
 @STATUSNAME VARCHAR(30),  
 @EXCHANGE VARCHAR(10),  
 @SEGMENT VARCHAR(25),  
 @ACCOUNTDB VARCHAR(10),  
 @SORTON VARCHAR(10)  
  )      
 AS    
 
 BEGIN  
	IF LEN(@VDT) = 10 AND CHARINDEX('/', @VDT) > 0  
	BEGIN  
		SET @VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, @VDT, 103), 109)  
	END  
 END 
  
 DECLARE @SQL VARCHAR(MAX)  
   
 BEGIN 
  
 
 
  /* FOR ALL ACCOUNTS */
 
 IF @DISPOPT = 'A'  
BEGIN 
  SET @SQL =     "    SELECT " 
 SET @SQL = @SQL +            "    CLTCODE =A.PARTY_CODE, "  
 SET @SQL = @SQL +            "    ACNAME  = M.LONGNAME, "  
 SET @SQL = @SQL +            "    DRAMT   = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END), "  
 SET @SQL = @SQL +            "    CRAMT = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END), "                         
 SET @SQL = @SQL +            "    VDT = '"+@VDT+"', "  
 SET @SQL = @SQL +            "    CLBAL = 0 "  
 SET @SQL = @SQL +            "    FROM "  
 SET @SQL = @SQL +            "    ACCBILL A, "  
 SET @SQL = @SQL + "          " + @ACCOUNTDB + " ..ACMAST M " 
 SET @SQL = @SQL +			  "    WHERE "  
 SET @SQL = @SQL +			  "    A.PARTY_CODE = M.CLTCODE  "  
 SET @SQL = @SQL +			  "    AND A.SETT_NO = '"+@SETT_NO+"' "  
 SET @SQL = @SQL +			  "    AND A.SETT_TYPE = '"+@SETT_TYPE+"' "  
 SET @SQL = @SQL +			  "    AND A.BRANCHCD <> 'ZZZ'  "  
 SET @SQL = @SQL +			  "    GROUP BY "  
 SET @SQL = @SQL +			  "    A.PARTY_CODE, "  
 SET @SQL = @SQL +			  "    M.LONGNAME "  

END
/* FOR ALL ACCOUNTS */
 
   
/* FOR PARTY ACCOUNT */
   
 IF @DISPOPT = 'P'  
  
  BEGIN
    SET @SQL =        "    SELECT " 
	SET @SQL = @SQL + "  CLTCODE = A.PARTY_CODE, "
	SET @SQL = @SQL + "  ACNAME  = M.LONGNAME, "  
	SET @SQL = @SQL + "  DRAMT   = CASE WHEN A.SELL_BUY = 1 THEN AMOUNT ELSE 0 END, "
	SET @SQL = @SQL + "  CRAMT   = CASE WHEN A.SELL_BUY = 2 THEN AMOUNT ELSE 0 END, "
	SET @SQL = @SQL + "  VDT     ='" + @VDT + "', "
	SET @SQL = @SQL + "  CLBAL   =0 "
	SET @SQL = @SQL + "  FROM "
	SET @SQL = @SQL + "  ACCBILL A,"
	SET @SQL = @SQL + "          " + @ACCOUNTDB + " ..ACMAST M " 
	SET @SQL = @SQL + "  WHERE "
	SET @SQL = @SQL + "  A.PARTY_CODE = M.CLTCODE "
	SET @SQL = @SQL + "  AND A.SETT_NO = '"+@SETT_NO+"' "
	SET @SQL = @SQL + "  AND A.SETT_TYPE = '"+@SETT_TYPE+"' " 
	SET @SQL = @SQL + "  AND ACCAT IN (4, 14) "                 -- PARTY ACCOUNT 
	SET @SQL = @SQL + "  ORDER BY"
	SET @SQL = @SQL + "  A.PARTY_CODE "    
   
   		
   
  END 
   
  /* FOR PARTY ACCOUNTS */

 /* FOR GL ACCOUNTS */
IF @DISPOPT = 'G' 
 BEGIN  
    SET @SQL =     "     SELECT " 
	SET @SQL = @SQL + "  A.PARTY_CODE, "
	SET @SQL = @SQL + "  ACNAME = M.LONGNAME, "  
	SET @SQL = @SQL + "  DRAMT = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END), "
	SET @SQL = @SQL + "  CRAMT = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END), "
	SET @SQL = @SQL + "  VDT     ='" + @VDT + "', "
	SET @SQL = @SQL + "  CLBAL   =0 "
	SET @SQL = @SQL + "  FROM "
	SET @SQL = @SQL + "  ACCBILL A,"
	SET @SQL = @SQL + "          " + @ACCOUNTDB + " ..ACMAST M " 
	SET @SQL = @SQL + "  WHERE "
	SET @SQL = @SQL + "  A.PARTY_CODE = M.CLTCODE "
	SET @SQL = @SQL + "  AND A.SETT_NO = '"+@SETT_NO+"' "
	SET @SQL = @SQL + "  AND A.SETT_TYPE = '"+@SETT_TYPE+"' " 
	SET @SQL = @SQL + "  AND ACCAT NOT IN (4, 14) "                 -- GL ACCOUNT 
	SET @SQL = @SQL + "  GROUP BY "
	SET @SQL = @SQL + "  A.PARTY_CODE, "   
	SET @SQL = @SQL + "  M.LONGNAME,A.SELL_BUY,A.AMOUNT  "  
	

  END 
  
 /* FOR GL ACCOUNTS */
     
    
    
 IF @ACCOUNTDB = 'BBO_FA'  
   BEGIN  
     SET @SQL = @SQL +     " EXCHANGE = '"+ @EXCHANGE +"' "  
     SET @SQL = @SQL +     " EXCHANGE = '"+ @SEGMENT +"' "   
   END  
     
   
IF @DISPOPT = 'G'  
 BEGIN  
  SET @SQL = @SQL +     " UNION ALL "  
  SET @SQL = @SQL +     " SELECT  "  
  SET @SQL = @SQL +     " PARTY_CODE = '', "  
  SET @SQL = @SQL +     " ACNAME = 'CLIENT SUMMARY', "  
  SET @SQL = @SQL +     " DRAMT = CASE WHEN A.SELL_BUY = 1 THEN AMOUNT ELSE 0 END, "  
  SET @SQL = @SQL +     " CRAMT = CASE WHEN A.SELL_BUY = 2 THEN AMOUNT ELSE 0 END, "  
  SET @SQL = @SQL +     " VDT   ='" + @VDT + "', "
  SET @SQL = @SQL +     " CLBAL = 0 "  
  SET @SQL = @SQL +     " FROM "  
  SET @SQL = @SQL +     " ACCBILL A,"  
  SET @SQL = @SQL + "          " + @ACCOUNTDB + " ..ACMAST M "  
  SET @SQL = @SQL +     " WHERE  "  
  SET @SQL = @SQL +     " ACCAT NOT IN(4, 14)"           -- GL    
  SET @SQL = @SQL +     " AND A.SETT_NO =   '" + @SETT_NO + "' "  
  SET @SQL = @SQL +     " AND A.SETT_TYPE = '" + @SETT_TYPE +"' "  
  SET @SQL = @SQL +     " GROUP BY "  
  SET @SQL = @SQL +     " PARTY_CODE, "  
  SET @SQL = @SQL +     " ACNAME,A.SELL_BUY,A.AMOUNT  "  

 
 END  
   PRINT @SQL  
  EXEC (@SQL)       

END
  
  
  
  
       
        
 /* FOR ALL ACCOUNTS   
  IF @DISPOPT = 'A'     
  BEGIN        
    SELECT         
     CLTCODE = A.PARTY_CODE,         
     ACNAME = M.LONGNAME,         
     DRAMT = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 1 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END),         
     CRAMT = (CASE WHEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) > 0 THEN SUM(CASE WHEN A.SELL_BUY = 2 THEN A.AMOUNT ELSE -A.AMOUNT END) ELSE 0 END),    
     VDT = @VDT,         
     CLBAL = 0        
    FROM         
     ACCBILL A, ACCOUNTDB..ACMAST M        
    WHERE         
     A.PARTY_CODE = M.CLTCODE        
     AND A.SETT_NO = @SETT_NO        
     AND A.SETT_TYPE = @SETT_TYPE        
     AND A.BRANCHCD <> 'ZZZ'        
    GROUP BY        
     A.PARTY_CODE,        
     M.LONGNAME        
    ORDER BY        
     A.PARTY_CODE        
  END    
    
  /* FOR ALL ACCOUNTS */     
     
     
   IF @DISPOPT = 'P' -- PARTY ACCOUNT  
    BEGIN  
  ACCAT IN(4, 14)  
 END  
   ELSE @DISPOPT = 'G'  
    BEGIN  
  ACCAT NOT IN(4, 14) -- GL ACCOUNT  
 END  
     
     
   IF @ACCOUNTDB = 'BBO_FA'  
   BEGIN  
 EXCHANGE = @EXCHANGE  
 SEGMENT = @SEGMENT  
   END  
     
   IF @DISPOPT = 'G'  
   BEGIN  
      UNION ALL  
      SELECT         
       PARTY_CODE = '',        
       LONG_NAME = 'CLIENT SUMMARY',         
       DRAMT = CASE WHEN A.SELL_BUY = 1 THEN AMOUNT ELSE 0 END,         
       CRAMT = CASE WHEN A.SELL_BUY = 2 THEN AMOUNT ELSE 0 END,        
       VDT = @VDT,         
       CLBAL = 0        
      FROM         
       ACCBILL A, ACMAST  
      WHERE         
       ACCAT NOT IN(4, 14) -- GL     
       AND A.SETT_NO = @SETT_NO        
       AND A.SETT_TYPE = @SETT_TYPE             
      GROUP BY        
       PARTY_CODE, LONG_NAME, VDT        
   END  */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Now_Proc_Margin
-- --------------------------------------------------

 CREATE PROC [dbo].[Now_Proc_Margin] (@Sauda_Date Varchar(11))                                  
As       
      
 SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End) ,  
                          
      Margin = convert(Numeric(18,4),0)                
    into #AMR_LEDGER                              
      FROM                                  
            Account.DBO.Ledger L with(nolock),                                   
            Account.DBO.Parameter P,                              
            Account.DBO.ACMAST A with(nolock)                                    
      Where                                   
           edt <= @Sauda_Date + ' 23:59:59'                                          
   And vdt >= SdtCur                                      
            And vdt <= LdtCur   
   --And vtyp<>15                 
            And Curyear = 1                              
     And A.CLTCODE = L.CLTCODE             
     AND ACCAT = 4   
Group by l.Cltcode                                      
     

 INSERT INTO #AMR_LEDGER                                  
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then 0 Else -VAmt End),0                                  
       FROM                                  
            Account.DBO.Ledger L with(nolock),                                   
            Account.DBO.Parameter P,                              
            Account.DBO.ACMAST A with(nolock)                                    
      Where                                   
            edt > @Sauda_Date + ' 00:00'                                          
   And edt >= SdtCur                                      
            And edt <= LdtCur   
   --And vtyp=15                                      
            And Curyear = 1                              
     And A.CLTCODE = L.CLTCODE             
     AND ACCAT = 4                                         
      Group by L.CLTCODE      
--NSEMFSS 
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/  
--INSERT INTO #LEDBAL (CLTCODE, BALAMT)  

DECLARE @SDTCUR DATETIME
SELECT @SDTCUR=SDTCUR FROM PARAMETER WHERE CURYEAR=1

SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 INTO #LEDBAL
FROM  
 BBO_FA..ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT >= @SDTCUR AND L.VDT < @Sauda_Date  
GROUP BY  
 L.CLTCODE  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
FROM  
 BBO_FA..ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT >= @Sauda_Date AND L.VDT <= @Sauda_Date + ' 23:59:59'  
 AND L.VTYPE <> 15  
GROUP BY  
 L.CLTCODE  
  
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 CLTCODE,  
 BALAMT = SUM(BALAMT)  
FROM  
 (  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 FROM  
  BBO_FA..ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @Sauda_Date + ' 23:59'  
 GROUP BY  
  L.CLTCODE  
 UNION ALL  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)  
 FROM  
  BBO_FA..ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)  
  AND L.VDT < @SDTCUR  
 GROUP BY  
  L.CLTCODE  
 ) A  
GROUP BY  
 CLTCODE 
 --NSEMFSS end
 
    SELECT  header,CLTCODE, AMR=SUM(AMR) into #amr_new                            
      FROM #AMR_LEDGER                        
             GROUP BY HEADER, CLTCODE                                  
      ORDER BY CLTCODE 

insert into  #amr_new 
select '03',CLTCODE,BALAMT from #LEDBAL
                            
        
insert into  #amr_new 
select header='03',cl_code,0 from msajag..client_details where cl_code not in(select distinct cltcode from  #amr_new)                         
  
update #amr_new set  amr=0 where amr<0  
  
  SELECT  CLTCODE, AMR=SUM(AMR),'','','' from #amr_new                            
  GROUP BY HEADER, CLTCODE                
  ORDER BY CLTCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Now_Proc_Margin_test
-- --------------------------------------------------

 CREATE PROC [dbo].[Now_Proc_Margin_test] (@Sauda_Date Varchar(11))                                  
As       
      
 SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then VAmt Else -VAmt End) ,  
                          
      Margin = convert(Numeric(18,4),0)                
    into #AMR_LEDGER                              
      FROM                                  
            Account.DBO.Ledger L with(nolock),                                   
            Account.DBO.Parameter P,                              
            Account.DBO.ACMAST A with(nolock)                                    
      Where                                   
           edt <= @Sauda_Date + ' 23:59:59'                                          
   And vdt >= SdtCur                                      
            And vdt <= LdtCur   
   --And vtyp<>15                 
            And Curyear = 1                              
     And A.CLTCODE = L.CLTCODE             
     AND ACCAT = 4   
Group by l.Cltcode                                      
     

 INSERT INTO #AMR_LEDGER                                  
      SELECT HEADER = '03', L.CLTCODE, AMR = Sum(Case When DrCr = 'C' Then 0 Else -VAmt End),0                                  
       FROM                                  
            Account.DBO.Ledger L with(nolock),                                   
            Account.DBO.Parameter P,                              
            Account.DBO.ACMAST A with(nolock)                                    
      Where                                   
            edt > @Sauda_Date + ' 00:00'                                          
   And edt >= SdtCur                                      
            And edt <= LdtCur   
   --And vtyp=15                                      
            And Curyear = 1                              
     And A.CLTCODE = L.CLTCODE             
     AND ACCAT = 4                                         
      Group by L.CLTCODE      
--NSEMFSS 
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/  
--INSERT INTO #LEDBAL (CLTCODE, BALAMT)  

DECLARE @SDTCUR DATETIME
SELECT @SDTCUR=SDTCUR FROM PARAMETER WHERE CURYEAR=1

SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 INTO #LEDBAL
FROM  
 BBO_FA..ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT >= @SDTCUR AND L.VDT < @Sauda_Date  
GROUP BY  
 L.CLTCODE  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
FROM  
 BBO_FA..ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT >= @Sauda_Date AND L.VDT <= @Sauda_Date + ' 23:59:59'  
 AND L.VTYPE <> 15  
GROUP BY  
 L.CLTCODE  
  
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 CLTCODE,  
 BALAMT = SUM(BALAMT)  
FROM  
 (  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 FROM  
  BBO_FA..ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @Sauda_Date + ' 23:59'  
 GROUP BY  
  L.CLTCODE  
 UNION ALL  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)  
 FROM  
  BBO_FA..ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)  
  AND L.VDT < @SDTCUR  
 GROUP BY  
  L.CLTCODE  
 ) A  
GROUP BY  
 CLTCODE 
 --NSEMFSS end
 
    SELECT  header,CLTCODE, AMR=SUM(AMR) into #amr_new                            
      FROM #AMR_LEDGER                        
             GROUP BY HEADER, CLTCODE                                  
      ORDER BY CLTCODE 

insert into  #amr_new 
select '03',CLTCODE,BALAMT from #LEDBAL
                            
        
insert into  #amr_new 
select header='03',cl_code,0 from msajag..client_details where cl_code not in(select distinct cltcode from  #amr_new)                         
  
update #amr_new set  amr=0 where amr<0  
  
  SELECT  CLTCODE, AMR=SUM(AMR),'','','' from #amr_new                            
  GROUP BY HEADER, CLTCODE                
  ORDER BY CLTCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_DUPRECCHECK
-- --------------------------------------------------

CREATE PROC [dbo].[NSEMFSS_DUPRECCHECK] (@SAUDA_DATE VARCHAR(11))
AS

IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP WHERE CONF_FLAG <> '' ) > 0 
BEGIN
	UPDATE MFSS_ORDER SET CONF_FLAG = M.CONF_FLAG,
						  REJECT_REASON = M.REJECT_REASON
	FROM MFSS_ORDER_TMP M
	WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES
END

INSERT INTO MFSS_SETTLEMENT_LOG   
SELECT *, GETDATE() FROM MFSS_SETTLEMENT  
WHERE REPLACE(CONVERT(VARCHAR, MFSS_SETTLEMENT.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
 AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_TMP     
      WHERE REPLACE(CONVERT(VARCHAR, MFSS_ORDER_TMP.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
      AND MFSS_SETTLEMENT.ORDER_NO = MFSS_ORDER_TMP.ORDER_NO    
      AND MFSS_SETTLEMENT.SCRIP_CD = MFSS_ORDER_TMP.SCRIP_CD  
	  AND MFSS_SETTLEMENT.SERIES = MFSS_ORDER_TMP.SERIES
      AND MFSS_ORDER_TMP.CONF_FLAG = 'N')  
  
DELETE FROM MFSS_SETTLEMENT  
WHERE REPLACE(CONVERT(VARCHAR, MFSS_SETTLEMENT.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
 AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_TMP     
      WHERE REPLACE(CONVERT(VARCHAR, MFSS_ORDER_TMP.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
      AND MFSS_SETTLEMENT.ORDER_NO = MFSS_ORDER_TMP.ORDER_NO    
      AND MFSS_SETTLEMENT.SCRIP_CD = MFSS_ORDER_TMP.SCRIP_CD  
	  AND MFSS_SETTLEMENT.SERIES = MFSS_ORDER_TMP.SERIES
      AND MFSS_ORDER_TMP.CONF_FLAG = 'N')  

INSERT INTO MFSS_ORDER
SELECT ORDER_NO,SETT_TYPE,SETT_NO,SUB_RED_FLAG,ALLOTMENT_MODE,ORDER_DATE,ORDER_TIME,
	   AMC_CODE,AMC_SCHEME_CODE,RTA_CODE,RTA_SCHEME_CODE,SCHEME_CATEGORY,SCRIP_CD,SERIES,
	   SCHEME_OPT_TYPE,ISIN,QTY,AMOUNT,PURCHASE_TYPE,MEMBERCODE,BRANCH_CODE,DEALER_CODE,FOLIONO,
	   PAYOUT_MECHANISM,APPLN_NO,PARTY_CODE,TAX_STATUS,MODE_HOLDING,F_CL_NAME,F_CL_PAN,F_CL_KYC,
	   S_CL_NAME,S_CL_PAN,S_CL_KYC,T_CL_NAME,T_CL_PAN,T_CL_KYC,G_NAME,G_PAN,DPNAME,DP_ID,CLTDPID,
	   MOBILE_NO,BANK_AC_TYPE,BANK_AC_NO,BANK_NAME,BANK_BRANCH,BANK_CITY,MICR_CODE,NEFT_CODE,
	   RTGS_CODE,EMAIL_ID,USER_ID = '',CONF_FLAG,REJECT_REASON,NAV_VALUE_ALLOTED=0,QTY_ALLOTED=0,AMOUNT_ALLOTED=0, 
	   SIP_REGD_NO, SIP_TRANCHE_NO, EUIN_NUMBER
FROM MFSS_ORDER_TMP M
WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_ORDER 
					 WHERE REPLACE(CONVERT(VARCHAR, MFSS_ORDER.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
						AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
						AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
						AND M.SERIES = MFSS_ORDER.SERIES )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_DUPRECCHECK_06082013
-- --------------------------------------------------
  
CREATE PROC [dbo].[NSEMFSS_DUPRECCHECK_06082013] (@SAUDA_DATE VARCHAR(11))    
AS    
    
IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP WHERE CONF_FLAG <> '' ) > 0     
BEGIN    
 UPDATE MFSS_ORDER SET CONF_FLAG = M.CONF_FLAG,    
        REJECT_REASON = M.REJECT_REASON    
 FROM MFSS_ORDER_TMP M    
 WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO    
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD    
 AND M.SERIES = MFSS_ORDER.SERIES    
END    
    
INSERT INTO MFSS_ORDER    
SELECT ORDER_NO,SETT_TYPE,SETT_NO,SUB_RED_FLAG,ALLOTMENT_MODE,ORDER_DATE,ORDER_TIME,    
    AMC_CODE,AMC_SCHEME_CODE,RTA_CODE,RTA_SCHEME_CODE,SCHEME_CATEGORY,SCRIP_CD,SERIES,    
    SCHEME_OPT_TYPE,ISIN,QTY,AMOUNT,PURCHASE_TYPE,MEMBERCODE,BRANCH_CODE,DEALER_CODE,FOLIONO,    
    PAYOUT_MECHANISM,APPLN_NO,PARTY_CODE,TAX_STATUS,MODE_HOLDING,F_CL_NAME,F_CL_PAN,F_CL_KYC,    
    S_CL_NAME,S_CL_PAN,S_CL_KYC,T_CL_NAME,T_CL_PAN,T_CL_KYC,G_NAME,G_PAN,DPNAME,DP_ID,CLTDPID,    
    MOBILE_NO,BANK_AC_TYPE,BANK_AC_NO,BANK_NAME,BANK_BRANCH,BANK_CITY,MICR_CODE,NEFT_CODE,    
    RTGS_CODE,EMAIL_ID,USER_ID = '',CONF_FLAG,REJECT_REASON,NAV_VALUE_ALLOTED=0,QTY_ALLOTED=0,AMOUNT_ALLOTED=0     
    FROM MFSS_ORDER_TMP M    
WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_ORDER     
      WHERE REPLACE(CONVERT(VARCHAR, MFSS_ORDER.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE    
      AND M.ORDER_NO = MFSS_ORDER.ORDER_NO    
      AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD    
      AND M.SERIES = MFSS_ORDER.SERIES )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_DUPRECSETTCHECK
-- --------------------------------------------------

CREATE PROC [dbo].[NSEMFSS_DUPRECSETTCHECK] (@SAUDA_DATE VARCHAR(11))
AS

IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP 
	WHERE REPLACE(CONVERT(VARCHAR, ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
	AND CONF_FLAG = 'Y' ) > 0 
BEGIN
	INSERT INTO MFSS_TRADE
	SELECT ORDER_NO, STATUS=CONVERT(VARCHAR(2),'11'), SETT_NO, SETT_TYPE, SCRIP_CD, SERIES, ISIN, PARTY_CODE, 
	SETTFLAG = (CASE WHEN SUB_RED_FLAG = 'P' THEN 4 ELSE 5 END),
    F_CL_KYC, F_CL_PAN, APPLN_NO, 
	PURCHASE_TYPE, DP_SETTLMENT = (CASE WHEN LEN(DP_ID) = 0 THEN 'N' ELSE 'Y' END), 
	DP_ID, DPCODE=CONVERT(VARCHAR(8),''), CLTDPID=CLTDPID, FOLIONO, AMOUNT, QTY, MODE_HOLDING, 
	S_CLIENTID='', S_CL_KYC, S_CL_PAN, T_CLIENTID='', T_CL_KYC, T_CL_PAN,
	USER_ID = DEALER_CODE, BRANCH_ID = BRANCH_CODE, SUB_RED_FLAG, ORDER_DATE, ORDER_TIME, 
	MEMBERCODE, '', '', '' 
	FROM MFSS_ORDER M
	WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
	AND CONF_FLAG = 'Y'
	AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_TRADE 
						 WHERE REPLACE(CONVERT(VARCHAR, MFSS_TRADE.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
							AND M.ORDER_NO = MFSS_TRADE.ORDER_NO
							AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD
							AND M.SERIES = MFSS_TRADE.SERIES )
END

DELETE FROM MFSS_TRADE
WHERE REPLACE(CONVERT(VARCHAR, ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_SETTLEMENT M
						 WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
							AND M.ORDER_NO = MFSS_TRADE.ORDER_NO
							AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD
							AND M.SERIES = MFSS_TRADE.SERIES )

UPDATE MFSS_TRADE SET SETT_NO = S.SETT_NO, SETT_TYPE = S.SETT_TYPE
FROM SETT_MST S
WHERE REPLACE(CONVERT(VARCHAR, S.START_DATE, 106), ' ', '-') = @SAUDA_DATE
AND   MFSS_TRADE.SETT_NO = ''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_SCRIPUPLOAD
-- --------------------------------------------------

CREATE PROC NSEMFSS_SCRIPUPLOAD
(
	@FilePath Varchar(100), 
	@ROWTERMINATOR VARCHAR(10)='\n'
)
AS

DECLARE @SQL VARCHAR(2000)

TRUNCATE TABLE MFSS_SCRIP_MASTER_TMP

SELECT TOKEN,SCRIP_CD,SERIES,INTRUMENTTYPE,QUANTITY_LIMIT,RTSCHEMECODE,
AMCSCHEMECODE,ISIN,FOLIO_LENGHT,SEC_STATUS_NRM,ELIGIBILITY_NRM,
SEC_STATUS_ODDLOT,ELIGIBILITY_ODDLOT,SEC_STATUS_SPOT,ELIGIBILITY_SPOT,
SEC_STATUS_AUCTION,ELIGIBILITY_AUCTION,AMCCODE,CATEGORYCODE,SEC_NAME,
ISSUE_RATE,MINSUBSCRADDL,BUYNAVPRICE,SELLNAVPRICE,RTAGENTCODE,VALDECINDICATOR,
CATSTARTTIME,QTYDECINDICATOR,CATENDTIME,MINSUBSCRFRESH,VALUE_LIMIT,
RECORD_DATE=0,EX_DATE=0,NAVDATE=0,NO_DELIVERY_END_DATE=0,ST_ELIGIBLE_IDX,ST_ELIGIBLE_AON,ST_ELIGIBLE_MIN_FILL,
SECDEPMANDATORY,SEC_DIVIDEND,SECALLOWDEP,SECALLOWSELL,SECMODCXL,SECALLOWBUY,BOOK_CL_START_DT=0,
BOOK_CL_END_DT=0,DIVIDEND,RIGHTS,BONUS,INTEREST,AGM,EGM,OTHER,LOCAL_DTTIME=0,DELETEFLAG,REMARK
INTO #MFSS_SCRIP_MASTER_TMP FROM MFSS_SCRIP_MASTER_TMP
WHERE 1 = 2 

SET @SQL = 'BULK INSERT #MFSS_SCRIP_MASTER_TMP FROM ''' + @FilePath + ''' WITH  ( FIELDTERMINATOR = ''|'', ROWTERMINATOR = '''+ @ROWTERMINATOR +''', FirstRow = 2 )'
EXEC (@SQL)

INSERT INTO MFSS_SCRIP_MASTER_TMP
SELECT TOKEN,SCRIP_CD,SERIES,INTRUMENTTYPE,QUANTITY_LIMIT,RTSCHEMECODE,
AMCSCHEMECODE,ISIN,FOLIO_LENGHT,SEC_STATUS_NRM,ELIGIBILITY_NRM,
SEC_STATUS_ODDLOT,ELIGIBILITY_ODDLOT,SEC_STATUS_SPOT,ELIGIBILITY_SPOT,
SEC_STATUS_AUCTION,ELIGIBILITY_AUCTION,AMCCODE,CATEGORYCODE,SEC_NAME,
ISSUE_RATE,MINSUBSCRADDL,BUYNAVPRICE,SELLNAVPRICE,RTAGENTCODE,VALDECINDICATOR,
CATSTARTTIME,QTYDECINDICATOR,CATENDTIME,MINSUBSCRFRESH,VALUE_LIMIT,
RECORD_DATE=DATEADD(SS, RECORD_DATE, CONVERT(DATETIME,'JAN  1 1980')),
EX_DATE=DATEADD(SS, EX_DATE, CONVERT(DATETIME,'JAN  1 1980')),
NAVDATE=DATEADD(SS, NAVDATE, CONVERT(DATETIME,'JAN  1 1980')),
NO_DELIVERY_END_DATE=DATEADD(SS, NO_DELIVERY_END_DATE, CONVERT(DATETIME,'JAN  1 1980')),
ST_ELIGIBLE_IDX,ST_ELIGIBLE_AON,ST_ELIGIBLE_MIN_FILL,
SECDEPMANDATORY,SEC_DIVIDEND,SECALLOWDEP,SECALLOWSELL,SECMODCXL,SECALLOWBUY,
BOOK_CL_START_DT=DATEADD(SS, BOOK_CL_START_DT, CONVERT(DATETIME,'JAN  1 1980')),
BOOK_CL_END_DT=DATEADD(SS, BOOK_CL_END_DT, CONVERT(DATETIME,'JAN  1 1980')),
DIVIDEND,RIGHTS,BONUS,INTEREST,AGM,EGM,OTHER,LOCAL_DTTIME=0,DELETEFLAG,REMARK
FROM #MFSS_SCRIP_MASTER_TMP

DELETE FROM MFSS_SCRIP_MASTER WHERE SCRIP_CD IN ( SELECT SCRIP_CD FROM MFSS_SCRIP_MASTER_TMP 
WHERE MFSS_SCRIP_MASTER.SCRIP_CD = MFSS_SCRIP_MASTER_TMP.SCRIP_CD 
AND MFSS_SCRIP_MASTER.SERIES = MFSS_SCRIP_MASTER_TMP.SERIES) 

INSERT INTO MFSS_SCRIP_MASTER 
SELECT * FROM MFSS_SCRIP_MASTER_TMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_COMMONSCRIPCDODE_GET
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[PR_COMMONSCRIPCDODE_GET]     
(    
 @FILETYPE VARCHAR(12),    
 @INST_TYPE VARCHAR(6),       
 @SYMBOL VARCHAR(12),      
 @EXPIRYDATE VARCHAR(11),       
 @OPTION_TYPE VARCHAR(2),    
 @STRIKE_PRICE MONEY       
)    
AS    
    
IF @FILETYPE = 'RICBASIC'    
BEGIN    
 SELECT  ISNULL(DBO.GETRICBASIC (@SYMBOL),'')    
END    
    
IF @FILETYPE = 'BLOOMBERG'    
BEGIN    
 SELECT  ISNULL(DBO.GETBLOOMBERGCODE (@INST_TYPE,@SYMBOL,@EXPIRYDATE,@STRIKE_PRICE,@OPTION_TYPE,0),'')    
END    
    
IF @FILETYPE = 'CUSIP'    
BEGIN    
 SELECT  ISNULL(DBO.GETCUSIP (@INST_TYPE,@SYMBOL,@EXPIRYDATE,@STRIKE_PRICE,@OPTION_TYPE),'')    
END    
    
IF @FILETYPE = 'SEDOL'    
BEGIN    
 SELECT  ISNULL(SEDOL,'') FROM SCRIP_CODES   
 WHERE SYMBOL = @SYMBOL   
END    
  
IF @FILETYPE = 'RICCODE'  
BEGIN  
 SELECT ISNULL(DBO.GETRICCODE (@INST_TYPE,@SYMBOL,@EXPIRYDATE,@STRIKE_PRICE,@OPTION_TYPE,''),'')  
END  
  
IF @FILETYPE = 'MERRYLCODE'  
BEGIN  
 SELECT ISNULL(DBO.GETMERRYLCODE (@SYMBOL),'')  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_IMPORT_FILE
-- --------------------------------------------------
CREATE PROC [dbo].[PR_IMPORT_FILE]   
(  
 @FILETYPE VARCHAR(20),  
 @SESSIONID VARCHAR(20),  
 @UNAME VARCHAR(20),  
 @SAUDA_DATE VARCHAR(11),  
 @INTMODE INT   
) AS   
  
IF @FILETYPE = 'CONTRACT MASTER'  
BEGIN  
 EXEC PR_IMPORT_CONTRACT_FILE @SESSIONID, @UNAME, @SAUDA_DATE, @INTMODE   
 EXEC V2_PROCESS_STATUS_LOG_UPD @SAUDA_DATE,'CNTMST','',@UNAME,''  
END  
  
  
IF @FILETYPE = 'TRADE'  
BEGIN  
 EXEC PR_IMPORT_TRADE_FILE @SESSIONID, @UNAME, @SAUDA_DATE, @INTMODE   
END  
  
  
IF @FILETYPE = 'CLOSING RATE'  
BEGIN  
 EXEC PR_IMPORT_CLOSING_FILE @SESSIONID, @UNAME, @SAUDA_DATE, @INTMODE   
 EXEC V2_PROCESS_STATUS_LOG_UPD @SAUDA_DATE,'CLOSING','',@UNAME,''  
END  
  
  
IF @FILETYPE = 'POSITION FILE'  
BEGIN  
 EXEC PR_IMPORT_POSITION_FILE @SESSIONID, @UNAME, @SAUDA_DATE, @INTMODE   
 EXEC V2_PROCESS_STATUS_LOG_UPD @SAUDA_DATE,'POSIMP','',@UNAME,''  
END  
  
  
  
IF @FILETYPE = 'MARGIN FILE'  
BEGIN  
 EXEC PR_IMPORT_MARGIN_FILE @SESSIONID, @UNAME, @SAUDA_DATE, @INTMODE   
 EXEC V2_PROCESS_STATUS_LOG_UPD @SAUDA_DATE,'MRGIMP','',@UNAME,''  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_acc_GetCompanyName_FA
-- --------------------------------------------------
create PROCEDURE proc_acc_GetCompanyName_FA      
 @AccoundDBName VarChar (50)      
AS      
      
SELECT * FROM      
 pradnya.dbo.multicompany      
      
WHERE      
 sharedb = @AccoundDBName AND      
 primaryserver = 1      
      
ORDER BY      
 companyname

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_MFSS_Auction_Carry
-- --------------------------------------------------
  
CREATE PROC [dbo].[Proc_MFSS_Auction_Carry]  
(  
 @FROMSETT_NO VARCHAR(7),  
 @SETT_TYPE  VARCHAR(2),  
 @TOSETT_NO  VARCHAR(7)  
)  
As  
  
DELETE FROM DELIVERYCLT_AUC  
WHERE SETT_NO = @FROMSETT_NO AND SETT_TYPE = @SETT_TYPE  
  
DELETE FROM DELTRANS  
WHERE SETT_NO = @FROMSETT_NO AND SETT_TYPE = @SETT_TYPE  
AND SHARETYPE = 'AUCTION'  
  
INSERT INTO DELIVERYCLT_AUC  
SELECT D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.SCHEME_NAME,D.ISIN,D.PARTY_CODE,  
QTY = D.QTY-SUM(ISNULL(T.QTY,0)),D.INOUT,D.BRANCH_CD,D.PARTIPANTCODE,D.DPCLT,TOSETT_NO=@TOSETT_NO  
FROM DELIVERYCLT D LEFT OUTER JOIN DELTRANS T  
ON (D.SETT_NO = T.SETT_NO AND D.SETT_TYPE = T.SETT_TYPE  
AND D.PARTY_CODE = T.PARTY_CODE AND D.SCRIP_CD = T.SCRIP_CD  
AND D.SERIES = T.SERIES AND D.ISIN = T.CERTNO AND DRCR = 'D' AND FILLER2 = 1)  
WHERE D.SETT_NO = @FROMSETT_NO AND D.SETT_TYPE = @SETT_TYPE  
AND INOUT = 'O'  
GROUP BY D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.SCHEME_NAME,D.ISIN,D.PARTY_CODE,  
D.QTY,D.INOUT,D.BRANCH_CD,D.PARTIPANTCODE,D.DPCLT  
HAVING D.QTY-SUM(ISNULL(T.QTY,0)) > 0   
  
INSERT INTO DELTRANS  
SELECT D.Sett_No,D.Sett_Type,Refno=120,Tcode=0,Trtype=904,Party_Code,Scrip_Cd,Series,  
       Qty,Fromno='0',Tono='0',Certno='AUCTION',Foliono='0',Holdername='TRANSFER TO SETT NO ' + @TOSETT_NO,  
       Reason='TRANSFER TO SETT NO ' + @TOSETT_NO,Drcr='D',Delivered='D',Orgqty=QTY,  
       Dptype='',Dpid='',Cltdpid='',Branch_cd,Partipantcode,Slipno='0',Batchno='',Isett_No='',Isett_Type='',  
       Sharetype='AUCTION',Transdate=LEFT(SEC_PAYOUT,11),Filler1='',Filler2=1,Filler3='',Bdptype='',Bdpid='',Bcltdpid='',Filler4=0,Filler5=0  
FROM DELIVERYCLT_AUC D, SETT_MST S  
WHERE D.SETT_NO = @FROMSETT_NO AND D.SETT_TYPE = @SETT_TYPE  
AND D.SETT_NO = S.SETT_NO  AND D.SETT_TYPE = S.SETT_TYPE  
  
INSERT INTO DELTRANS  
SELECT D.Sett_No,D.Sett_Type,Refno=120,Tcode=0,Trtype=906,Party_Code='EXE',Scrip_Cd,Series,  
       Qty,Fromno='0',Tono='0',Certno='AUCTION',Foliono='0',Holdername='TRANSFER TO SETT NO ' + @TOSETT_NO,  
       Reason='TRANSFER TO SETT NO ' + @TOSETT_NO,Drcr='C',Delivered='0',Orgqty=QTY,  
       Dptype='',Dpid='',Cltdpid='',Branch_cd,Partipantcode,Slipno='0',Batchno='',Isett_No='',Isett_Type='',  
       Sharetype='AUCTION',Transdate=LEFT(SEC_PAYOUT,11),Filler1='',Filler2=1,Filler3='',Bdptype='',Bdpid='',Bcltdpid='',Filler4=0,Filler5=0  
FROM DELIVERYCLT_AUC D, SETT_MST S  
WHERE D.SETT_NO = @FROMSETT_NO AND D.SETT_TYPE = @SETT_TYPE  
AND D.SETT_NO = S.SETT_NO  AND D.SETT_TYPE = S.SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_ClientMaster
-- --------------------------------------------------
CREATE PROC PROC_MFSS_ClientMaster 
AS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_CONTRACTALLTRADE
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_CONTRACTALLTRADE] (@SAUDA_DATE VARCHAR(11))
AS

DECLARE @CNTNO VARCHAR(7)

SELECT @CNTNO = CONTRACTNO FROM CONTGEN
WHERE @SAUDA_DATE >= Start_Date and @SAUDA_DATE <= End_Date

SELECT DISTINCT SETT_NO, SETT_TYPE, PARTY_CODE, CONTRACTNO
INTO #CNTNO FROM MFSS_SETTLEMENT M
WHERE M.ORDER_DATE = @SAUDA_DATE

SELECT * INTO #CONF
FROM MFSS_CONFIRMVIEW

UPDATE #CONF SET CONTRACTNO = C.CONTRACTNO
FROM #CNTNO C
WHERE C.PARTY_CODE = #CONF.PARTY_CODE
AND C.SETT_NO = #CONF.SETT_NO
AND C.SETT_TYPE = #CONF.SETT_TYPE

SELECT DISTINCT SETT_NO, SETT_TYPE, PARTY_CODE, CONTRACTNO
INTO #CNTNO_1 FROM #CONF M
WHERE M.ORDER_DATE = @SAUDA_DATE
AND CONTRACTNO = '0'
ORDER BY SETT_NO, SETT_TYPE, PARTY_CODE

ALTER TABLE #CNTNO_1
ADD SNO Int IDENTITY (1, 1) NOT NULL 

UPDATE #CNTNO_1 SET CONTRACTNO = RIGHT('0000000' + CONVERT(VARCHAR,SNO + CONVERT(INT,@CNTNO)),7)

UPDATE #CONF SET CONTRACTNO = C.CONTRACTNO
FROM #CNTNO_1 C
WHERE C.PARTY_CODE = #CONF.PARTY_CODE
AND C.SETT_NO = #CONF.SETT_NO
AND C.SETT_TYPE = #CONF.SETT_TYPE

SELECT @CNTNO = MAX(CONVERT(INT,CONTRACTNO)) FROM #CONF

UPDATE CONTGEN SET CONTRACTNO = @CNTNO
WHERE @SAUDA_DATE >= Start_Date and @SAUDA_DATE <= End_Date

INSERT INTO MFSS_SETTLEMENT
SELECT * FROM #CONF

TRUNCATE TABLE MFSS_TRADE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_CROBG_STATUS
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_CROBG_STATUS]
(
	@ORDER_DATE		VARCHAR(11)
)

AS

UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = 'ORDER REJECTED BY BROKER'
FROM MFSS_CROBG M
WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
AND M.SERIES = MFSS_ORDER.SERIES
AND MFSS_ORDER.ORDER_DATE LIKE @ORDER_DATE + '%'
AND M.CONF_FLAG = 'N' AND REC_STATUS = 'S'

INSERT INTO MFSS_SETTLEMENT_LOG
SELECT *, REJECTEDDATE = GETDATE() FROM MFSS_SETTLEMENT
WHERE ORDER_DATE LIKE @ORDER_DATE + '%'
AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_CROBG M
				 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
				 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
				 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
				 AND M.SERIES = MFSS_SETTLEMENT.SERIES)
				 
Delete From MFSS_SETTLEMENT
Where ORDER_DATE LIKE @ORDER_DATE + '%'
And ORDER_NO in (Select ORDER_NO From MFSS_CROBG M
				 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
				 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
				 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
				 AND M.SERIES = MFSS_SETTLEMENT.SERIES)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_DFDS_DELIVERY
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_DFDS_DELIVERY]
(
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2),
	@TRANSNO	VARCHAR(16)
)

AS

INSERT INTO DELTRANS
SELECT D.SETT_NO,D.SETT_TYPE,REFNO=110,TCODE=1,TRTYPE=904,D.PARTY_CODE,D.SCRIP_CD,D.SERIES,D.QTY,
FROMNO=TRANSNO,TONO=TRANSNO,CERTNO=D.ISIN,FOLIONO=TRANSNO,HOLDERNAME='PAYIN',REASON='PAYIN',
DRCR='C',DELIVERED='0',ORGQTY=D.QTY,DPTYPE=(CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END),
DPID=(CASE WHEN LEN(CLTDPID) = 16 THEN LEFT(CLTDPID,8) ELSE D.DPID END),CLTDPID,BRANCHCD='HO',PARTIPANTCODE,
SLIPNO='0',BATCHNO='',ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',
TRANSDATE=LEFT(SEC_PAYIN,11),FILLER1='DFDS',FILLER2=1,FILLER3='0',
BDPTYPE=DP.DPTYPE,BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''
FROM MFSS_DFDS D, DELIVERYDP DP, SETT_MST S, DELIVERYCLT C
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE
AND D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE
AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE
AND D.PARTY_CODE = C.PARTY_CODE
AND D.SCRIP_CD = C.SCRIP_CD
AND D.SERIES = C.SERIES
AND DP.DESCRIPTION LIKE '%POOL%'
AND INOUT = 'I'
AND DP.DPTYPE = (CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END)
AND TRANSNO = @TRANSNO


INSERT INTO DELTRANS
SELECT D.SETT_NO,D.SETT_TYPE,REFNO=110,TCODE=1,TRTYPE=906,PARTY_CODE='EXE',D.SCRIP_CD,D.SERIES,D.QTY,
FROMNO=TRANSNO,TONO=TRANSNO,CERTNO=D.ISIN,FOLIONO=TRANSNO,HOLDERNAME='PAYIN',REASON='PAYIN',
DRCR='D',DELIVERED='D',ORGQTY=D.QTY,DPTYPE=(CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END),
DPID=(CASE WHEN LEN(CLTDPID) = 16 THEN LEFT(CLTDPID,8) ELSE D.DPID END),CLTDPID,BRANCHCD='HO',PARTIPANTCODE,
SLIPNO='0',BATCHNO='',ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',
TRANSDATE=LEFT(SEC_PAYIN,11),FILLER1='DFDS',FILLER2=1,FILLER3='0',
BDPTYPE=DP.DPTYPE,BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''
FROM MFSS_DFDS D, DELIVERYDP DP, SETT_MST S, DELIVERYCLT C
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE
AND D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE
AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE
AND D.PARTY_CODE = C.PARTY_CODE
AND D.SCRIP_CD = C.SCRIP_CD
AND D.SERIES = C.SERIES
AND DP.DESCRIPTION LIKE '%POOL%'
AND INOUT = 'I'
AND DP.DPTYPE = (CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END)
AND TRANSNO = @TRANSNO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_DPMASTER
-- --------------------------------------------------

CREATE PROC PROC_MFSS_DPMASTER
(
	@Party_Code		VARCHAR(10),
	@DP_TYPE		VARCHAR(4),
	@DPID			VARCHAR(8),
	@CLTDPID		VARCHAR(16)
)

AS

	DELETE FROM MFSS_DPMASTER 
	WHERE PARTY_CODE = @Party_Code
	AND DP_TYPE = @DP_TYPE
	AND DPID = @DPID
	AND CLTDPID = @CLTDPID
	AND DEFAULTDP = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_FUNDS_OBL_CALC
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_FUNDS_OBL_CALC]
(
	@TRADE_DATE VARCHAR(11)
)

AS
/*
	PROC_MFSS_FUNDS_OBL_CALC 'DEC  5 2009'
	
*/
DECLARE
		@SNO		NUMERIC(18,0), 
		@PARTY_CODE	VARCHAR(10), 
		@AMOUNT		NUMERIC(18, 4),
		@LEDCUR		CURSOR,
		@SDTCUR		DATETIME

SELECT @SDTCUR = SDTCUR FROM BBO_FA.dbo.PARAMETER WHERE @TRADE_DATE BETWEEN SDTCUR AND LDTCUR

CREATE TABLE #CLCODES
(
	CLTCODE VARCHAR(10),
	CL_BALANCE VARCHAR(1)
)
/*---------GETTING CLIENT MASTER SETTIING FOR BALANCE TYPE------------------------*/
INSERT INTO #CLCODES
	(CLTCODE, CL_BALANCE)
SELECT
	M.PARTY_CODE,
	CL_BALANCE = CASE WHEN M.CL_BALANCE <> 'E' THEN 'V' ELSE 'E' END
FROM
	MFSS_CLIENT M
WHERE
	EXISTS (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION O 
			WHERE O.ORDER_DATE LIKE @TRADE_DATE + '%' AND M.PARTY_CODE = O.PARTY_CODE)
------------------------------------------------------------------------------------
CREATE TABLE #LEDBAL
(
	CLTCODE VARCHAR(10),
	BALAMT NUMERIC(18, 4)
)
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/
INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	L.CLTCODE,
	BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
FROM
	BBO_FA.dbo.ACC_LEDGER_PL L,
	#CLCODES C
WHERE
	L.EXCHANGE = 'BSE'
	AND L.SEGMENT = 'MFSS'
	AND L.CLTCODE = C.CLTCODE
	AND C.CL_BALANCE = 'V'
	AND L.VDT >= @SDTCUR AND L.VDT < @TRADE_DATE
GROUP BY
	L.CLTCODE

INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	L.CLTCODE,
	BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
FROM
	BBO_FA.dbo.ACC_LEDGER_PL L,
	#CLCODES C
WHERE
	L.EXCHANGE = 'BSE'
	AND L.SEGMENT = 'MFSS'
	AND L.CLTCODE = C.CLTCODE
	AND C.CL_BALANCE = 'V'
	AND L.VDT >= @TRADE_DATE AND L.VDT <= @TRADE_DATE + ' 23:59:59'
	AND L.VTYPE <> 15
GROUP BY
	L.CLTCODE

-------------------------------------------------------------------------------------
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/

INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	CLTCODE,
	BALAMT = SUM(BALAMT)
FROM
	(
	SELECT
		L.CLTCODE,
		BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
	FROM
		BBO_FA.dbo.ACC_LEDGER_PL L,
		#CLCODES C
	WHERE
		L.EXCHANGE = 'BSE'
		AND L.SEGMENT = 'MFSS'
		AND L.CLTCODE = C.CLTCODE
		AND C.CL_BALANCE = 'E'
		AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @TRADE_DATE + ' 23:59'
	GROUP BY
		L.CLTCODE
	UNION ALL
	SELECT
		L.CLTCODE,
		BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)
	FROM
		BBO_FA.dbo.ACC_LEDGER_PL L,
		#CLCODES C
	WHERE
		L.EXCHANGE = 'BSE'
		AND L.SEGMENT = 'MFSS'
		AND L.CLTCODE = C.CLTCODE
		AND C.CL_BALANCE = 'E'
		AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)
		AND L.VDT < @SDTCUR
	GROUP BY
		L.CLTCODE
	) A
GROUP BY
	CLTCODE
--------------------------OLD CODE----------------------------------
--SELECT CLTCODE, BALAMT = SUM(CRAMOUNT-DRAMOUNT)
--INTO #LEDBAL 
--FROM BBO_FA.DBO.ACC_LEDGER_PL
--WHERE EXCHANGE = 'BSE' AND SEGMENT = 'MFSS'
--AND EDT <= @TRADE_DATE + ' 23:59:59'
--AND @TRADE_DATE BETWEEN LDTCUR AND SDTCUR
--AND CLTCODE IN (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION
--				WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59')
--GROUP BY CLTCODE

SET @LEDCUR = CURSOR FOR
SELECT SNO, PARTY_CODE, AMOUNT FROM MFSS_FUNDS_OBLIGATION
WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59'
ORDER BY SNO
OPEN @LEDCUR
FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE MFSS_FUNDS_OBLIGATION SET AVAIL_AMOUNT = BALAMT
	FROM #LEDBAL
	WHERE SNO = @SNO
	AND CLTCODE = PARTY_CODE

	UPDATE #LEDBAL SET BALAMT = (CASE WHEN @AMOUNT > BALAMT THEN 0 ELSE BALAMT - @AMOUNT END)
	WHERE CLTCODE = @PARTY_CODE

	FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT
END
CLOSE @LEDCUR
DEALLOCATE @LEDCUR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_FUNDS_OBL_CALC_bak
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_FUNDS_OBL_CALC_bak]  
(  
 @TRADE_DATE VARCHAR(11)  
)  
  
AS  
/*  
 PROC_MFSS_FUNDS_OBL_CALC 'DEC  5 2009'  
   
*/  
DECLARE  
  @SNO  NUMERIC(18,0),   
  @PARTY_CODE VARCHAR(10),   
  @AMOUNT  NUMERIC(18, 4),  
  @LEDCUR  CURSOR,  
  @SDTCUR  DATETIME  
  
SELECT @SDTCUR = SDTCUR FROM BBO_FA.dbo.PARAMETER WHERE @TRADE_DATE BETWEEN SDTCUR AND LDTCUR  
  
CREATE TABLE #CLCODES  
(  
 CLTCODE VARCHAR(10),  
 CL_BALANCE VARCHAR(1)  
)  
/*---------GETTING CLIENT MASTER SETTIING FOR BALANCE TYPE------------------------*/  
INSERT INTO #CLCODES  
 (CLTCODE, CL_BALANCE)  
SELECT  
 M.PARTY_CODE,  
 CL_BALANCE = CASE WHEN M.CL_BALANCE <> 'E' THEN 'V' ELSE 'E' END  
FROM  
 MFSS_CLIENT M  
WHERE  
 EXISTS (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION O WHERE O.ORDER_DATE LIKE @TRADE_DATE + '%' AND M.PARTY_CODE = O.PARTY_CODE)  
------------------------------------------------------------------------------------  
CREATE TABLE #LEDBAL  
(  
 CLTCODE VARCHAR(10),  
 BALAMT NUMERIC(18, 4)  
)  
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
FROM  
 BBO_FA.dbo.ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT BETWEEN @SDTCUR AND @TRADE_DATE + ' 23:59'  
GROUP BY  
 L.CLTCODE  
-------------------------------------------------------------------------------------  
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 CLTCODE,  
 BALAMT = SUM(BALAMT)  
FROM  
 (  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 FROM  
  BBO_FA.dbo.ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @TRADE_DATE + ' 23:59'  
 GROUP BY  
  L.CLTCODE  
 UNION ALL  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)  
 FROM  
  BBO_FA.dbo.ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)  
  AND L.VDT < @SDTCUR  
 GROUP BY  
  L.CLTCODE  
 ) A  
GROUP BY  
 CLTCODE  
--------------------------OLD CODE----------------------------------  
--SELECT CLTCODE, BALAMT = SUM(CRAMOUNT-DRAMOUNT)  
--INTO #LEDBAL   
--FROM BBO_FA.DBO.ACC_LEDGER_PL  
--WHERE EXCHANGE = 'NSE' AND SEGMENT = 'MFSS'  
--AND EDT <= @TRADE_DATE + ' 23:59:59'  
--AND @TRADE_DATE BETWEEN LDTCUR AND SDTCUR  
--AND CLTCODE IN (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION  
--    WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59')  
--GROUP BY CLTCODE  
  
SET @LEDCUR = CURSOR FOR  
SELECT SNO, PARTY_CODE, AMOUNT FROM MFSS_FUNDS_OBLIGATION  
WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59'  
ORDER BY SNO  
OPEN @LEDCUR  
FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 UPDATE MFSS_FUNDS_OBLIGATION SET AVAIL_AMOUNT = BALAMT  
 FROM #LEDBAL  
 WHERE SNO = @SNO  
 AND CLTCODE = PARTY_CODE  
  
 UPDATE #LEDBAL SET BALAMT = (CASE WHEN @AMOUNT > BALAMT THEN 0 ELSE BALAMT - @AMOUNT END)  
 WHERE CLTCODE = @PARTY_CODE  
  
 FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT  
END  
CLOSE @LEDCUR  
DEALLOCATE @LEDCUR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_MISSINGSCRIP
-- --------------------------------------------------
CREATE PROC PROC_MFSS_MISSINGSCRIP AS        
SET NOCOUNT ON       
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
      
CREATE TABLE #MFSS_TRADE  
(    
 SCRIP_CD VARCHAR (20)
)    
    
INSERT INTO #MFSS_TRADE   
  SELECT     
 DISTINCT SCRIP_CD  
  FROM   MFSS_TRADE (NOLOCK)    
    
SELECT * FROM #MFSS_TRADE MFSS_TRADE    
  WHERE  NOT EXISTS (SELECT SCRIP_CD    
                     FROM   MFSS_SCRIP_MASTER M  
                     WHERE  MFSS_TRADE.SCRIP_CD = M.SCRIP_CD )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_STATUS_UPDATE
-- --------------------------------------------------
  
CREATE PROC [dbo].[PROC_MFSS_STATUS_UPDATE]  
(  
 @FLAG INT  
)  
AS  
  
IF @FLAG = 1   
BEGIN  
 UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED,   
        QTY_ALLOTED = M.QTY_ALLOTED,   
        AMOUNT_ALLOTED = M.AMOUNT_ALLOTED,  
        FOLIONO = M.FOLIONO  
 FROM MFSS_ORDER_ALLOT_CONF M  
 WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
 AND M.SERIES = MFSS_ORDER.SERIES  
  
 UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END),   
        AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)  
 FROM MFSS_ORDER_ALLOT_CONF M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES  
  
END  
  
IF @FLAG = 2   
BEGIN  
 UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON  
 FROM MFSS_ORDER_ALLOT_REJ M  
 WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
 AND M.SERIES = MFSS_ORDER.SERIES  
  
 INSERT INTO MFSS_SETTLEMENT_DELETED  
 SELECT * FROM MFSS_SETTLEMENT  
 WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES)  
  
 DELETE FROM MFSS_SETTLEMENT  
 WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES)  
END  
  
IF @FLAG = 3   
BEGIN  
 UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED,   
        QTY_ALLOTED = M.QTY_ALLOTED,   
        AMOUNT_ALLOTED = M.AMOUNT_ALLOTED  
 FROM MFSS_ORDER_REDEM_CONF M  
 WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
 AND M.SERIES = MFSS_ORDER.SERIES  
  
 UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END),   
        AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)  
 FROM MFSS_ORDER_REDEM_CONF M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES  
  
END  
  
IF @FLAG = 4   
BEGIN  
 UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON  
 FROM MFSS_ORDER_REDEM_REJ M  
 WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
 AND M.SERIES = MFSS_ORDER.SERIES  
  
 INSERT INTO MFSS_SETTLEMENT_DELETED  
 SELECT * FROM MFSS_SETTLEMENT  
 WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES)  
  
 DELETE FROM MFSS_SETTLEMENT  
 WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M  
 WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
 AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
 AND M.SERIES = MFSS_SETTLEMENT.SERIES)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_STATUS_UPDATE_bak
-- --------------------------------------------------
  
CREATE PROC [DBO].[PROC_MFSS_STATUS_UPDATE]  
(  
 @SETT_NO VARCHAR(7),
 @SETT_TYPE VARCHAR(2)
)  
AS  
  

UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED,   
    QTY_ALLOTED = M.QTY_ALLOTED,   
    AMOUNT_ALLOTED = M.AMOUNT_ALLOTED,
	FOLIONO = M.FOLIONO  
FROM MFSS_ORDER_STATUS M  
WHERE M.SETT_NO = @SETT_NO
AND M.SETT_TYPE = @SETT_TYPE
AND M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
AND M.RECFLAG = 'Y' 

UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END),   
    AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END),
	FOLIONO = M.FOLIONO 
FROM MFSS_ORDER_STATUS M  
WHERE M.SETT_NO = @SETT_NO
AND M.SETT_TYPE = @SETT_TYPE
AND M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD  
AND M.RECFLAG = 'Y'

UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REMARK  
FROM MFSS_ORDER_STATUS M  
WHERE M.SETT_NO = @SETT_NO
AND M.SETT_TYPE = @SETT_TYPE
AND M.ORDER_DATE = MFSS_ORDER.ORDER_DATE  
AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
AND M.RECFLAG = 'N'

INSERT INTO MFSS_SETTLEMENT_DELETED
SELECT * FROM MFSS_SETTLEMENT  
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_STATUS M  
WHERE M.SETT_NO = @SETT_NO
AND M.SETT_TYPE = @SETT_TYPE
AND M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
AND M.RECFLAG = 'N') 

DELETE FROM MFSS_SETTLEMENT  
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_STATUS M  
WHERE M.SETT_NO = @SETT_NO
AND M.SETT_TYPE = @SETT_TYPE
AND M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE  
AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO  
AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
AND M.RECFLAG = 'N')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_VALAN]          
(          
 @SETT_NO   VARCHAR(7),          
    @SETT_TYPE VARCHAR(2)          
)          
AS          
      
        
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST         
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE        
 AND START_DATE <= 'DEC 23 2010 23:59') > 0         
BEGIN        
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE        
 RETURN        
END          
          
IF (SELECT ISNULL(PROFILE_BROK_FLAG,0) FROM OWNER) > 0           
BEGIN          
 SELECT * INTO #MFSS_SETTLEMENT
 FROM MFSS_SETTLEMENT
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
 
	UPDATE #MFSS_SETTLEMENT SET SCRIP_CD = M.SCRIP_CD, SERIES = M.SERIES
	FROM MFSS_SCRIP_MASTER M
	WHERE #MFSS_SETTLEMENT.ISIN = M.ISIN
	AND M.CATEGORYCODE <> 'DBTCR'
	AND #MFSS_SETTLEMENT.SCRIP_CD IN (SELECT M1.SCRIP_CD FROM MFSS_SCRIP_MASTER M1
									  WHERE #MFSS_SETTLEMENT.SCRIP_CD = M1.SCRIP_CD
									  AND #MFSS_SETTLEMENT.SERIES = M1.SERIES
									  AND M1.CATEGORYCODE = 'DBTCR')
	  
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND B.AMC_CODE = 'ALL'        
 AND B.CATEGORYCODE = 'ALL'        
 AND B.SCRIP_CD = 'ALL'        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
        
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M, MFSS_SCRIP_MASTER S        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND B.AMC_CODE = 'ALL'        
 AND B.SCRIP_CD = 'ALL'        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
 AND #MFSS_SETTLEMENT.SCRIP_CD = S.SCRIP_CD        
 AND #MFSS_SETTLEMENT.SERIES = S.SERIES        
 AND S.CATEGORYCODE = B.CATEGORYCODE        
        
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M, MFSS_SCRIP_MASTER S        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND B.AMC_CODE = S.AMCCODE        
 AND B.SCRIP_CD = 'ALL'        
 AND B.CATEGORYCODE = 'ALL'        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
 AND #MFSS_SETTLEMENT.SCRIP_CD = S.SCRIP_CD        
 AND #MFSS_SETTLEMENT.SERIES = S.SERIES        
        
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M, MFSS_SCRIP_MASTER S        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND B.SCRIP_CD = 'ALL'        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
 AND #MFSS_SETTLEMENT.SCRIP_CD = S.SCRIP_CD        
 AND #MFSS_SETTLEMENT.SERIES = S.SERIES        
 AND S.CATEGORYCODE = B.CATEGORYCODE        
 AND S.AMCCODE = B.AMC_CODE        
        
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M, MFSS_SCRIP_MASTER S        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
 AND #MFSS_SETTLEMENT.SCRIP_CD = S.SCRIP_CD        
 AND #MFSS_SETTLEMENT.SERIES = S.SERIES        
 AND B.SCRIP_CD = S.SCRIP_CD        
 AND ( B.SERIES = '' OR B.SERIES = 'ALL')        
        
 UPDATE #MFSS_SETTLEMENT        
 SET FILLER1 = B.TABLE_NO        
 FROM MFSS_BROK_PROFILE B, MFSS_BROKERAGE_MASTER M, MFSS_SCRIP_MASTER S        
 WHERE #MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND #MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND PROFILE_ID = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
        THEN M.BUY_BROK_TABLE_NO         
        ELSE M.SELL_BROK_TABLE_NO         
      END)        
 AND B.SELL_BUY_FLAG = (CASE WHEN #MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'         
           THEN 1        
           ELSE 2        
         END)        
 AND M.PARTY_CODE = #MFSS_SETTLEMENT.PARTY_CODE        
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE        
 AND #MFSS_SETTLEMENT.SCRIP_CD = S.SCRIP_CD        
 AND #MFSS_SETTLEMENT.SERIES = S.SERIES        
 AND B.SCRIP_CD = S.SCRIP_CD        
 AND B.SERIES = S.SERIES      

 UPDATE MFSS_SETTLEMENT SET FILLER1 = M.FILLER1
 FROM #MFSS_SETTLEMENT M
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO        
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE        
 AND M.SETT_NO = MFSS_SETTLEMENT.SETT_NO
 AND M.SETT_TYPE = MFSS_SETTLEMENT.SETT_TYPE
 AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	  
 TRUNCATE TABLE  #MFSS_SETTLEMENT
 DROP TABLE #MFSS_SETTLEMENT 
END          
ELSE          
BEGIN          
 UPDATE MFSS_SETTLEMENT          
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'          
      THEN M.BUY_BROK_TABLE_NO          
      ELSE M.SELL_BROK_TABLE_NO          
       END)          
 FROM MFSS_BROKERAGE_MASTER M          
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO          
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE          
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE          
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE          
END          
          
UPDATE MFSS_SETTLEMENT SET           
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),          
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100          
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G          
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO          
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE          
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE             
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1           
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT            
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM          
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'          
          
DELETE FROM ACCBILL        
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE        

SELECT * INTO #MFSS_SETTLEMENT_TEMP FROM MFSS_SETTLEMENT S
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE

UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0 
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER O, TBL_MFFS_DPAYIN P
				   WHERE ORDER_DATE BETWEEN FROMDATE AND TODATE
				   AND O.SCHEME_CATEGORY = P.SCHEME_CATEGORY
				   AND SUB_RED_FLAG = 'P' AND O.AMOUNT >= AMT_CUT_OFF) 
-- ANIMESH
UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0, INS_CHRG = 0, BROKER_CHRG = 0 WHERE SAUDA_DATE >= 'APR  1 2022'

DELETE FROM #MFSS_SETTLEMENT_TEMP WHERE  SAUDA_DATE >= 'APR  1 2022' AND BROKERAGE+SERVICE_TAX <= 0
-- ANIMESH 
-- ALL THE PLACES AFTER THIS PATCH, MFSS_SETTLEMENT CHANGED TO #MFSS_SETTLEMENT_TEMP IF IT IS NOT USED

SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),         
BRANCHCD = BRANCH_CD,        
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0) + ISNULL(BROKER_CHRG,0)      
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0) + ISNULL(BROKER_CHRG,0)       
       END),2),        
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)        
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)        
       END),        
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN BROKERAGE         
      ELSE BROKERAGE        
       END),        
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN SERVICE_TAX        
      ELSE SERVICE_TAX      
       END), 
STAMP_DUTY =  SUM(ISNULL(BROKER_CHRG,0)),SUB_RED_FLAG, CATEGORYCODE        
INTO #VALAN         
FROM MFSS_CLIENT C, #MFSS_SETTLEMENT_TEMP S, MFSS_SCRIP_MASTER M         
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE        
AND S.PARTY_CODE = C.PARTY_CODE        
AND M.SCRIP_CD = S.SCRIP_CD
AND M.SERIES = S.SERIES
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, LEFT(S.ORDER_DATE, 11), BRANCH_CD,SUB_RED_FLAG, CATEGORYCODE        
        
INSERT INTO ACCBILL        
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),        
BRANCHCD,NARRATION = CATEGORYCODE 
FROM #VALAN S, SETT_MST M        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),        
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'CLEARING HOUSE'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG, CATEGORYCODE       
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),        
BRANCHCD,NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'BROKERAGE REALISED'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE        

INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD,NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE 

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),          
BRANCHCD,NARRATION=CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX = 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,         
BRANCHCD,NARRATION = CATEGORYCODE
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX,CATEGORYCODE
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),          
BRANCHCD,NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE     
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),    
BRANCHCD,NARRATION = CATEGORYCODE
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'EDU CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE    
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),        
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'CLEARING HOUSE'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,SUB_RED_FLAG,CATEGORYCODE        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),        
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'BROKERAGE REALISED'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CATEGORYCODE        

INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CATEGORYCODE 
        
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX = 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CATEGORYCODE          

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX,CATEGORYCODE         
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE     
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),    
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE 
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'EDU CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE    
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0           
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',        
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE,PAYOUT_DATE,        
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),        
BRANCHCD,NARRATION -- = 'MFSS BILL POSTED'        
FROM ACCBILL S, VALANACCOUNT V        
WHERE S.SETT_NO = @SETT_NO        
AND S.SETT_TYPE = @SETT_TYPE        
AND V.ACNAME = 'ROUNDING OFF'        
AND BRANCHCD <> 'ZZZ'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD,NARRATION        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',        
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE,PAYOUT_DATE,        
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),        
BRANCHCD='ZZZ',NARRATION -- = 'MFSS BILL POSTED'        
FROM ACCBILL S, VALANACCOUNT V        
WHERE S.SETT_NO = @SETT_NO       
AND S.SETT_TYPE = @SETT_TYPE        
AND V.ACNAME = 'ROUNDING OFF'        
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,NARRATION 

UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE) 
FROM MFSS_CATEGORY C
WHERE SETT_NO = @SETT_NO       
AND SETT_TYPE = @SETT_TYPE   
AND CATEGORYCODE = NARRATION
AND START_DATE BETWEEN FROM_DATE AND TO_DATE
AND SELL_BUY = 2
AND PARTY_CODE NOT IN (SELECT ACCODE FROM VALANACCOUNT)

UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE) 
FROM MFSS_CATEGORY C
WHERE SETT_NO = @SETT_NO       
AND SETT_TYPE = @SETT_TYPE   
AND CATEGORYCODE = NARRATION
AND START_DATE BETWEEN FROM_DATE AND TO_DATE
AND SELL_BUY = 1
AND PARTY_CODE IN (SELECT ACCODE FROM VALANACCOUNT)

UPDATE ACCBILL SET NARRATION = 'MFSS BILL POSTED - ' + NARRATION
WHERE SETT_NO = @SETT_NO       
AND SETT_TYPE = @SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_17052013
-- --------------------------------------------------
--SELECT * FROM MFSS_SETTLEMENT  
CREATE PROC [dbo].[PROC_MFSS_VALAN_17052013]  
(  
 @SETT_NO   VARCHAR(7),  
    @SETT_TYPE VARCHAR(2)  
)  
AS  
  
UPDATE MFSS_SETTLEMENT SET   
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),  
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100  
FROM MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G  
WHERE MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE     
AND MFSS_SETTLEMENT.PARTY_CODE = M.PARTY_CODE    
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P'   
           THEN M.BUY_BROK_TABLE_NO   
        ELSE M.SELL_BROK_TABLE_NO   
      END)  
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE    
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT    
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM   
AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM  
  
DELETE FROM ACCBILL  
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
  
SELECT SETT_NO, SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(ORDER_DATE, 11),   
BRANCHCD = BRANCH_CD,  
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN AMOUNT + BROKERAGE + SERVICE_TAX   
      ELSE BROKERAGE + SERVICE_TAX  
       END),2),  
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN AMOUNT   
      ELSE 0  
       END),  
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN BROKERAGE   
      ELSE BROKERAGE  
       END),  
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN SERVICE_TAX  
      ELSE SERVICE_TAX  
       END)  
INTO #VALAN   
FROM MFSS_SETTLEMENT S, MFSS_CLIENT C  
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
AND S.PARTY_CODE = C.PARTY_CODE  
GROUP BY SETT_NO, SETT_TYPE, S.PARTY_CODE, LEFT(ORDER_DATE, 11), BRANCH_CD  
  
INSERT INTO ACCBILL  
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=1,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=PARTY_AMOUNT,  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'CLEARING HOUSE'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'BROKERAGE REALISED'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'SERVICE TAX'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'CLEARING HOUSE'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'BROKERAGE REALISED'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'SERVICE TAX'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',  
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),  
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE,PAYOUT_DATE,  
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM ACCBILL S, VALANACCOUNT V  
WHERE S.SETT_NO = @SETT_NO  
AND S.SETT_TYPE = @SETT_TYPE  
AND V.ACNAME = 'ROUNDING OFF'  
AND BRANCHCD <> 'ZZZ'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',  
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),  
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE,PAYOUT_DATE,  
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM ACCBILL S, VALANACCOUNT V  
WHERE S.SETT_NO = @SETT_NO  
AND S.SETT_TYPE = @SETT_TYPE  
AND V.ACNAME = 'ROUNDING OFF'  
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_BKUP_01JUL2022
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_VALAN_BKUP_01JUL2022]            
(            
 @SETT_NO   VARCHAR(7),            
    @SETT_TYPE VARCHAR(2)            
)            
AS            
        
          
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST           
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
 AND START_DATE <= 'DEC 23 2010 23:59') > 0           
BEGIN          
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE          
 RETURN          
END            
            
        
 UPDATE MFSS_SETTLEMENT            
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'            
      THEN M.BUY_BROK_TABLE_NO            
      ELSE M.SELL_BROK_TABLE_NO            
       END)            
 FROM MFSS_BROKERAGE_MASTER M            
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE            
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                   
            
UPDATE MFSS_SETTLEMENT SET             
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),            
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100            
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G            
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE               
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1             
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM            
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'            
            
DELETE FROM ACCBILL          
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
          
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),           
BRANCHCD = BRANCH_CD,          
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)           
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)          
       END),2),          
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)          
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)          
       END),          
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN BROKERAGE           
      ELSE BROKERAGE          
       END),          
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN SERVICE_TAX          
      ELSE SERVICE_TAX        
       END), SUB_RED_FLAG          
INTO #VALAN           
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S           
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE          
AND S.PARTY_CODE = C.PARTY_CODE          
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, LEFT(S.ORDER_DATE, 11), BRANCH_CD,SUB_RED_FLAG          
          
INSERT INTO ACCBILL          
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD          
          
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD,NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,           
BRANCHCD,NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX  
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD,NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD,NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX       
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,SUB_RED_FLAG          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT          
          
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX           
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'            
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX       
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0             
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO          
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND BRANCHCD <> 'ZZZ'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO         
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_OLD
-- --------------------------------------------------
--SELECT * FROM MFSS_SETTLEMENT    
CREATE PROC [dbo].[PROC_MFSS_VALAN_OLD]    
(    
 @SETT_NO   VARCHAR(7),    
    @SETT_TYPE VARCHAR(2)    
)    
AS    
    
UPDATE MFSS_SETTLEMENT SET     
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),    
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100    
FROM MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G    
WHERE MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE       
AND MFSS_SETTLEMENT.PARTY_CODE = M.PARTY_CODE      
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P'     
           THEN M.BUY_BROK_TABLE_NO     
        ELSE M.SELL_BROK_TABLE_NO     
      END)     
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE      
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM     
    
DELETE FROM ACCBILL    
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE    
    
SELECT SETT_NO, SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(ORDER_DATE, 11),     
BRANCHCD = BRANCH_CD,    
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'     
      THEN AMOUNT + BROKERAGE + SERVICE_TAX     
      ELSE BROKERAGE + SERVICE_TAX    
       END),2),    
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'     
      THEN AMOUNT     
      ELSE 0    
       END),    
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'     
      THEN BROKERAGE     
      ELSE BROKERAGE    
       END),    
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'     
      THEN SERVICE_TAX    
      ELSE SERVICE_TAX    
       END)    
INTO #VALAN     
FROM MFSS_SETTLEMENT S, MFSS_CLIENT C    
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE    
AND S.PARTY_CODE = C.PARTY_CODE    
GROUP BY SETT_NO, SETT_TYPE, S.PARTY_CODE, LEFT(ORDER_DATE, 11), BRANCH_CD    
    
INSERT INTO ACCBILL    
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=1,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=PARTY_AMOUNT,    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'CLEARING HOUSE'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'BROKERAGE REALISED'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'SERVICE TAX'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),    
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'CLEARING HOUSE'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),    
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'BROKERAGE REALISED'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),    
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V    
WHERE S.SETT_NO = M.SETT_NO    
AND S.SETT_TYPE = M.SETT_TYPE    
AND V.ACNAME = 'SERVICE TAX'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',    
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),    
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE,PAYOUT_DATE,    
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'    
FROM ACCBILL S, VALANACCOUNT V    
WHERE S.SETT_NO = @SETT_NO    
AND S.SETT_TYPE = @SETT_TYPE    
AND V.ACNAME = 'ROUNDING OFF'    
AND BRANCHCD <> 'ZZZ'    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD    
    
INSERT INTO ACCBILL    
SELECT ACCODE,BILL_NO='0',    
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),    
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,    
PAYIN_DATE,PAYOUT_DATE,    
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),    
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'    
FROM ACCBILL S, VALANACCOUNT V    
WHERE S.SETT_NO = @SETT_NO    
AND S.SETT_TYPE = @SETT_TYPE    
AND V.ACNAME = 'ROUNDING OFF'    
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_NewBasicReport
-- --------------------------------------------------
CREATE  Procedure [dbo].[Proc_NewBasicReport] (   
@sett_no Varchar(10),    	---1  Settlement No(from)  
@tosett_no Varchar(10),   	---2  Settlement No (to)  
@sett_type Varchar(3),   	---3  Settlement Type   
@sauda_date Varchar(11),  	---4  Sauda_date (from)  
@todate Varchar(11),   		---5  Sauda_date (to)  
@fromscrip Varchar(10),   	---6  From Scrip_cd (from)  
@toscrip Varchar(10),   	---7  To Scrip_cd (to)  
@from Varchar(20),     		---8  From Consol  
@to Varchar (20),     		---9  To Consol  
@consol Varchar(10),   		---10 Consol Indicates That Whether Is "party_code","trader","sub Broker","branch"  
@detail Varchar(3),    		---11 This Is Other Details In Query "b" = "bill","c" = "confirmation","p" = "position","br" = "brokerage","s" = "sauda Summary"  
@level  Smallint,            	---12 Will Be Used To Select  Level Of Consolidation Default 0  
@groupf Varchar(500),   	---13 (any Necessary Grouping) This Can Be Defined On The Fly By Developer  
@orderf Varchar(500),   	---14 (any Necessary Order By) This Can De Defined On The Fly By Developer   
@use1 Varchar(10),           	---15 To Be Used Later  For Other Purposes  
@statusid Varchar(15),  
@statusname Varchar(25) )  
  
As  

Declare  
@@getstyle As Cursor,  
@@sett_no As Varchar(10),  
@@fromparty_code As Varchar(10),  
@@toparty_code  As Varchar(10),  
@@fromsett_type As Varchar(3),  
@@tosett_type As Varchar(3),  
@@myquery As Varchar(4000),  
@@myreport As Varchar(50),  
@@myorder As Varchar(1500),  
@@mygroup As Varchar(1500),  
@@part As Varchar(8000),  
@@part1 As Varchar(8000),  
@@part2 As Varchar(8000),  
@@part3 As Varchar(8000),  
@@part4 As Varchar(8000),  
@@part5 As Varchar(8000),  
@@part6 As Varchar(8000),  
@@wisereport As Varchar(10),  
@@dummy1 As Varchar(1000),  
@@dummy2 As Varchar(1000),  
@@fromfamily As Varchar(10),  
@@tofamily  As Varchar(10),  
@@frombranch_cd As Varchar(15),  
@@tobranch_cd  As Varchar(15),  
@@fromsub_broker As Varchar(25),  
@@tosub_broker  As Varchar(25),  
@@fromtrader As Varchar(50),  
@@totrader  As Varchar(50),  
@@fromregion Varchar(15),  
@@toregion Varchar(15),  
@@fromarea Varchar(15),  
@@toarea Varchar(15),  
@@dummy3 As Varchar(1000),  
@@fromtable As Varchar(1000),    	---------------------  This String Will Enable Us To Code Conditions Like From Settlement  
@@selectflex As Varchar (2000),   	---------------------  This String Will Enable Us To Code Flexible Select Conditions   
@@selectflex1 As Varchar (2000),   	---------------------  This String Will Enable Us To Code Flexible Select Conditions   
@@selectbody As Varchar(8000),  	---------------------  This Is Regular Select Body  
@@selectbody1 As Varchar(8000),  	---------------------  This Is Regular Select Body  
@@wheretext As Varchar(8000),  		---------------------  This Will Be Used For Coding Where Condition    
@@fromtable1 As Varchar(1000), 		---------------------  This Is Another String That Can Be Used For    
@@wherecond1 As Varchar(2000)  
  
/* To Reduce The Number Of Queries We Have Joined Maximum Number Of Parameters With Ranges*/  
/* Hence We Are Extracting Ranges If The Partmeter Passed Is %  Or ""   */  
/* If The Parameter Is Passed Then We Make That Same Parameter As From <-----> To  */  
 
If ((@consol = "party_code" Or @consol = "broker")) And  ((@from <> "") And (@to = "" ) )   
Begin  
	Select @@fromparty_code = @from  
	Select @@toparty_code = @from   
End  
  
If ((@consol = "party_code" Or @consol = "broker")) And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromparty_code = @from  
	Select @@toparty_code = @to   
End  
  
If (@consol = "family") And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromfamily = @from  
	Select @@tofamily = @to   
	Select @@fromparty_code = ''
	SELECT @@toparty_code = 'zzzzzzz'
End  
Else If (@consol = "family") And  ((@from = "") And (@to = "" ) )   
Begin            
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@fromfamily = ''  
	Select @@tofamily = 'zzzzzzz'  
End  
  
If (@consol = "branch_cd") And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@frombranch_cd = @from  
	Select @@tobranch_cd = @to   
	Select @@fromparty_code = '' 
	SELECT @@toparty_code = 'zzzzzzz'
End  
Else If (@consol = "branch_cd") And  ((@from = "") And (@to = "" ) )   
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@frombranch_cd = ''  
	Select @@tobranch_cd = 'zzzzzzz'  
End  
  
If (@consol = "trader") And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromtrader = @from  
	Select @@totrader = @to   
	Select @@fromparty_code = '' 
	SELECT @@toparty_code = 'zzzzzzz'
End  
Else If (@consol = "trader")  And ( ( @from = "" ) And ( @to = "" ) )    
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@fromtrader = ''  
	Select @@totrader = 'zzzzzzz'  
End  
  
If (@consol = "sub_broker") And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromsub_broker = @from  
	Select @@tosub_broker = @to   
	Select @@fromparty_code = '' 
	SELECT @@toparty_code = 'zzzzzzz'
End  
Else If (@consol = "sub_broker")  And ( ( @from = "" ) And ( @to = "" ) )    
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@fromsub_broker = ''  
	Select @@tosub_broker = 'zzzzzzz'  
End  
  
If (@consol = "region")  And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromregion = @from   
	Select @@toregion = @to  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'   
End  
  
Else If (@consol = "region")  And  ((@from = "") And (@to = "" ) )   
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@fromregion = ''  
	Select @@toregion = 'zzzzzzz'  
End  
If (@consol = "area")  And  ((@from <> "") And (@to <> "" ) )   
Begin  
	Select @@fromarea = @from   
	Select @@toarea = @to  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
End  
  
Else If (@consol = "area")  And  ((@from = "") And (@to = "" ) )   
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
	Select @@fromarea = ''  
	Select @@toarea = 'zzzzzzz'  
End  
  
If ((@consol = "party_code" Or @consol = "broker")) And ( ( @from = "" ) And ( @to = "" ))
Begin  
	Select @@fromparty_code = ''  
	Select @@toparty_code = 'zzzzzzz'  
End  
-----------------------------------------------------------------------------------------  
If @sett_type  <>  "%"   
Begin  
	Select @@fromsett_type = @sett_type  
	Select @@tosett_type = @sett_type  
End  
  
If @sett_type  =  "%"   
Begin  
      	Select @@fromsett_type = Min(sett_type), @@tosett_type = Max(sett_type) From sett_mst  
End  
  
-----------------------------------------------------------------------------------------  
  
If @fromscrip = ""
Begin
	Select @fromscrip = ''
End 

If @toscrip = ""
Begin
	Select @toscrip = 'zzzzzzz'
End 
 
-----------------------------------------------------------------------------------------  

If @tosett_no = ""   
Begin  
	Set @tosett_no = @sett_no  
End  
  
Select @sauda_date = Ltrim(rtrim(@sauda_date))  
If Len(@sauda_date) = 10   
Begin  
	Set @sauda_date = Stuff(@sauda_date, 4, 1,"  ")  
End  
  
Select @todate = Ltrim(rtrim(@todate))  
If Len(@todate) = 10   
Begin  
	Set @todate = Stuff(@todate, 4, 1,"  ")  
End  
--------------------------------------------------- Find Saudadate From To From Settlement Range  -------------------------------------------------------------------------------------------------------  
If ( @todate  = "" )   
Begin  
        Select @todate = End_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @tosett_no   
End  
  
If ( @sauda_date  = "" )   
Begin  
        Select @sauda_date = Start_date From Sett_mst Where Sett_type = @sett_type And Sett_no = @sett_no   
End  
----------------------------------------------------find Settno From To From Sauda_date  Range -------------------------------------------------------------------------------------------------------  
If ( (@sett_no = "" ) And ( Len(@sauda_date) > 1))   
Begin  
	Select @sett_no = Min(sett_no) From Sett_mst Where Sett_type Between  @@fromsett_type And @@tosett_type  And Start_date >= @sauda_date + " 00:00"  And End_date <= @todate + " 23:59:59"     
	If @todate = ""   
	Set @tosett_no = @sett_no  
End  
  
If ( (@tosett_no = "" ) And ( Len(@todate) > 1))   
Begin  
        Select @tosett_no = Max(sett_no) From Sett_mst Where Sett_type Between  @@fromsett_type And @@tosett_type  And Start_date >= @sauda_date + " 00:00"  And End_date <= @todate + " 23:59:59"     
End  


SELECT 
	PARTY_CODE = S.PARTY_CODE, CONTRACTNO,BILLNO,SAUDA_DATE=ORDER_DATE,ORDER_TIME,ORDER_NO,SETT_NO = S.SETT_NO,SETT_TYPE = S.SETT_TYPE,
	PARTY_NAME = C.PARTY_NAME, SCRIP_CD = S.SCRIP_CD,ISIN = S.ISIN,SUB_RED_FLAG,SETTFLAG,AMOUNT,QTY,FOLIONO,
	SCRIP_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), SERIES = '',
	BROKERAGE,INS_CHRG,TURN_TAX,OTHER_CHRG,SEBI_TAX,BROKER_CHRG,SERVICE_TAX,
	Clienttype=CL_TYPE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,PAN_NO,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,
	NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,START_DATE=LEFT(CONVERT(VARCHAR,START_DATE,109),11),END_DATE=LEFT(CONVERT(VARCHAR,END_DATE,109),11)
INTO
	#MFSS_SETTLEMENT
FROM
	MFSS_SETTLEMENT S (NOLOCK),
	MFSS_CLIENT C (NOLOCK),
	SETT_MST M (NOLOCK),
	MFSS_SCRIP_MASTER SM (NOLOCK)
WHERE
	S.PARTY_CODE = C.PARTY_CODE
	AND C.PARTY_CODE = (CASE WHEN @consol = 'family' THEN FAMILY ELSE C.PARTY_CODE END)
	AND S.SETT_TYPE = M.SETT_TYPE
	AND S.SETT_NO = M.SETT_NO
	AND S.SCRIP_CD = SM.SCRIP_CD
	AND S.ORDER_DATE BETWEEN @sauda_date AND @todate + ' 23:59:59'
	AND C.PARTY_CODE BETWEEN @@fromparty_code AND @@toparty_code


If @detail = "b"   
   Set @@myreport = "bill"  
   
If @detail = "c"   
   Set @@myreport = "confirmation"  
  
If @detail = "p"   
   Set @@myreport = "position"  
  
If @detail = "br"   
   Set @@myreport = "brokerage"  
  
If @detail = "s"   
   Set @@myreport = "saudasummary"  
  
------------------------------------- We Will Select From  Various Order By Options --------------------------------------   
  
  
If @orderf = "0"       ------------------------------ To Be Used For Contract / Bill --Printing  ------------------------  
Begin  
	  If @consol = "party_code"  
             Set @@myorder = " Order By S.party_code, S.sett_no, S.sett_type,  S.scrip_cd Asc, S.series, Tradetyp , Billno, Contractno, S.sauda_date Option (fast 10 )  "  
End  
   
If @orderf = "1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
   	  If @consol = "region"  
             Set  @@myorder = " Order   By Region  Option (fast 1 ) "  
   	  If @consol = "area"  
             Set  @@myorder = " Order   By Area  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order   By Party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order  By Branch_cd  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker Option (fast 1 ) "  
End  
  
If @orderf = "1.1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Region  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Area  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Branch_cd  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Family Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, Trader Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order By S.scrip_cd, S.series, S.Sub_broker Option (fast 1 ) "  
End  
  
If @orderf = "2"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "  
           If @consol = "party_code"  
             Set  @@myorder = " Order  By  S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder  = " Order  By S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "sub_broker"  
     	     Set  @@myorder = " Order By S.sett_no,s.sett_type Option (fast 1 )"  
End  
  
  
If @orderf = "3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
          If @consol = "region"  
	     Set  @@myorder = " Order  By S.scrip_cd ,s.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order  By S.scrip_cd ,s.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order  By S.scrip_cd ,s.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder  = " Order  By S.scrip_cd ,s.series  Option (fast 1 ) "  
          If @consol = "sub_broker"  
     	     Set  @@myorder = " Order By S.scrip_cd ,s.series  Option (fast 1 )"  
End  
  
If @orderf = "3.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  ,s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.11"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region,s.party_code  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area,s.party_code  Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code  Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  , S.party_code  Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.party_code  Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.party_code  Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.party_code Option (fast 1 )"  
End  
  
If @orderf = "3.2"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By Branch_cd  ,s.sauda_date ,s.sett_no,s.sett_type ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker  , S.sauda_date ,s.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.3"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
  
          If @consol = "region"  
             Set  @@myorder = " Order By Region,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area,S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,S.party_code, s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.Branch_Cd,S.Sub_Broker,S.Trader,S.Family,S.party_code, s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By S.Family,S.party_code, S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By S.Trader,S.party_code, S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.Sub_broker,S.party_code, S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "3.4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "party_code"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type ,s.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order By S.sett_no,s.sett_type  ,s.scrip_cd , S.series Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  Bys.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By S.sett_no,s.sett_type , S.scrip_cd, S.series Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order  By S.sett_no,s.sett_type  , S.scrip_cd, S.series Option (fast 1 )"  
End  
  
If @orderf = "4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,sauda_date,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "          If @consol = "party_code"  
             Set  @@myorder = " Order By S.sauda_date , S.sett_no,s.sett_type  Option (fast 1 ) "          If @consol = "branch_cd"  
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order By S.sauda_date  , S.sett_no,s.sett_type Option (fast 1 ) "  
End  
  
If @orderf = "4.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,sauda_date,tmark  ----------------------  
Begin  
          If @consol = "region"  
             Set  @@myorder = " Order By Region  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "  
          If @consol = "area"  
             Set  @@myorder = " Order By Area  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "  
           If @consol = "party_code"  
             Set  @@myorder = " Order By S.party_code  , S.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "  
          If @consol = "branch_cd"  
             Set  @@myorder = " Order  By Branch_cd  ,s.sett_no,s.sett_type , S.scrip_cd,s.series,s.sauda_date Option (fast 1 ) "  
          If @consol = "family"  
             Set  @@myorder = " Order  By Family  ,s.sett_no,s.sett_type , S.scrip_cd,s.series , S.sauda_date Option (fast 1 ) "  
          If @consol = "trader"  
             Set  @@myorder = " Order  By Trader  , S.sett_no,s.sett_type , S.scrip_cd,s.series, S.sauda_date Option (fast 1 ) "  
          If @consol = "sub_broker"  
             Set  @@myorder = " Order By Sub_broker , S.sett_no,s.sett_type , S.scrip_cd,s.series ,s.sauda_date Option (fast 1 ) "  
End  
  
  
-------------------------------------  End Of Select  Order By Options  ----------------------------------------------------  
  
  
If @groupf = "3.3" Or @groupf = "1"  
Begin  
	Set @@fromtable = " From #MFSS_SETTLEMENT S Left Outer Join BRANCH BR On (S.Branch_CD = BR.Branch_Code) Left Outer Join SUBBROKERS SB On (S.sub_broker = SB.Sub_Broker) "  
End  
Else  
Begin  
	Set @@fromtable = " From #MFSS_SETTLEMENT S "  
End  

------------------------------------- We Will Decide Various Group By Options --------------------------------------   
  
If @groupf = "0"    ----------------------  To Be Used For Contract Or Bills ----------------------  
Begin  
     If @consol = "party_code"   
     Set  @@mygroup =  " Group By Party_code , Party_name, Branch_cd, Sub_broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_name, Sauda_date  , Left(convert(varchar,sauda_date,109),11), Contractno , Billno , Tradetype , Start_date, End_date"  
     Set  @@selectflex =  " Select Party_code , Long_name=party_name, Branch_cd, Sub_broker, Trader, Family, Sett_no , Sett_type  , Scrip_cd  , Series , Scrip_name, Sauda_date = Left(convert(varchar,sauda_date,109),11), Contractno , Billno, Ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg),  Trade_date = S.sauda_date , Tradetyp = (case When Tradetype Like  '%bf' Then 1 Else Case When Tradetype Like  '%cf' Then 3 Else Case When Tradetype Like  '%r' Then 4 Else 2 End End End), Trdtype = Tradetype, Start_date, End_date "  
End  
  
If @groupf = "1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
     If @consol = "region"  
     Begin  
	Set @@mygroup = " Group By REGION "  
	SET @@selectflex = "SELECT REGION,Long_name=REGION,ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0,Clienttype='' "
     End  
     If @consol = "area"  
     Begin  
	Set @@mygroup = " Group By Area "  
	SET @@selectflex = "SELECT Area, Long_name=Area, ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0, Clienttype='' "
     End  
     If @consol = "party_code"  
     Begin  
	Set @@mygroup = " Group By S.party_code, Party_name, Clienttype "  
	SET @@selectflex = "SELECT S.party_code,Long_name=Party_name,ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0,Clienttype=Clienttype "
     End  
     If @consol = "branch_cd"  
     Begin   
	Set @@mygroup = " Group By Branch_cd, Branch "  
	SET @@selectflex = "SELECT Branch_cd, Long_name=Branch, ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0, Clienttype='' "
     End  
     If @consol = "family"  
     Begin   
	Set @@mygroup = " Group By Family, PARTY_NAME"  
	SET @@selectflex = "SELECT Family, Long_name=PARTY_NAME, ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0, Clienttype='' "
     End   
     If @consol = "trader"  
     Begin   
	Set @@mygroup = " Group By Trader "  
	SET @@selectflex = "SELECT Trader, Long_name=Trader, ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0, Clienttype='' "
     End         
     If @consol = "sub_broker"  
     Begin   
	Set @@mygroup = " Group By S.Sub_broker, Name "  
	SET @@selectflex = "SELECT S.Sub_broker, Long_name=Name, ptradedqty = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),ptradedamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),stradedqty = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Stradedamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Buybrokerage = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),Selbrokerage = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Buydeliverychrg = 0,Selldeliverychrg = 0,Clienttype = '',Billpamt = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),Billsamt = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "Pmarketrate = 0,Smarketrate = 0,Pnetrate = 0,Snetrate = 0,Trdamt= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),delamt=SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),Serinex=0,service_tax= Sum(service_tax),exservice_tax=0,turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg), "
	SET @@selectflex = @@selectflex + "other_chrg=sum(other_chrg),Membertype = '',Companyname = '',pnl = 0, Clienttype='' "
     End  
End  
  
If @groupf = "1.1"  ------------------------ To Be Used For Gross Position Across Range ----------------------  
Begin  
     If @consol = "region"  
     Begin  
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,REGION "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,REGION,LONG_NAME=REGION, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End  
     If @consol = "area"  
     Begin  
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,AREA "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,AREA,LONG_NAME=AREA, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End  
     If @consol = "party_code"  
     Begin  
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,PARTY_CODE,PARTY_NAME,CLIENTTYPE "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PARTY_CODE,LONG_NAME=PARTY_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE "
     End  
     If @consol = "branch_cd"  
     Begin   
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,BRANCH_CD "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,BRANCH_CD,LONG_NAME=BRANCH_CD, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End  
     If @consol = "family"  
     Begin   
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,FAMILY,PARTY_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,FAMILY,LONG_NAME=PARTY_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End   
     If @consol = "trader"  
     Begin   
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,TRADER "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,TRADER,LONG_NAME=TRADER, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End         
     If @consol = "sub_broker"  
     Begin   
	SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME,SUB_BROKER "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,SUB_BROKER,LONG_NAME=SUB_BROKER, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE ='' "
     End  
End  

  
If @groupf = "2"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
     If @consol = "area"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
  
     If @consol = "party_code"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "branch_cd"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
     If @consol = "family"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End                     
     If @consol = "trader"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End   
     If @consol = "sub_broker"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,START_DATE,END_DATE "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,START_DATE,END_DATE,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
End  
  
  
If @groupf = "3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
     If @consol = "area"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
     If @consol = "party_code"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "branch_cd"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End    
     If @consol = "family"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End                     
     If @consol = "trader"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End   
     If @consol = "sub_broker"  
     Begin   
        SET @@mygroup = " GROUP BY SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT SCRIP_CD,SERIES,SCRIP_NAME,PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
End  
If @groupf = "2.11"  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Region,branch_cd,membertype, Companyname "  
          Set  @@selectflex =  " Select  Region,branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Area,branch_cd,membertype, Companyname "  
          Set  @@selectflex =  " Select  Area,branch_cd,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
End  
If @groupf = "3.1"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,REGION,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,REGION,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End   
     If @consol = "area"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,AREA,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,AREA,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End   
     If @consol = "party_code"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End   
     If @consol = "branch_cd"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End  
     If @consol = "family"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,FAMILY,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,FAMILY,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End  
     If @consol = "trader"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,TRADER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End  
     If @consol = "sub_broker"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO,SETT_TYPE,SUB_BROKER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME"  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,SUB_BROKER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End  
End  
  
if @groupf = "3.11"   ------------------------ To Be Used For Net Position Across Settlement  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
          Set  @@mygroup = " Group By Region,branch_cd,party_code, Party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select  Region,branch_cd,party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
     If @consol = "area"  
     Begin  
          Set  @@mygroup = " Group By Area,branch_cd,party_code, Party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select  Area,branch_cd,party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "    
     End  
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Party_code,party_name,clienttype,membertype, Companyname, "  
          Set  @@selectflex =  " Select Party_code, Party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End   
     If @consol = "branch_cd"  
     Begin  
          Set  @@mygroup = " Group By Branch_cd,party_code,party_name,clienttype,membertype, Companyname  "  
          Set  @@selectflex =  " Select Branch_cd,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "family"  
     Begin  
          Set  @@mygroup = " Group By Family,party_code,party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select Family,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "trader"  
     Begin  
          Set  @@mygroup = " Group By Trader,party_code,party_name,clienttype,membertype, Companyname "  
          Set  @@selectflex =  " Select Trader,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
     If @consol = "sub_broker"  
     Begin  
          Set  @@mygroup = " Group By Sub_broker,party_code,party_name,clienttype,membertype, Companyname  "  
          Set  @@selectflex =  " Select Sub_broker,party_code,party_name,clienttype,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd)  ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) ,  Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ), Trdamt=sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End  
End  
  
  
  
If @groupf = "3.2"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
     If @consol = "region"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),REGION,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),REGION,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
     If @consol = "area"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),AREA,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),AREA,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
     If @consol = "party_code"  
     Begin   
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End   
     If @consol = "branch_cd"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),BRANCH_CD,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
     If @consol = "family"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),FAMILY,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),FAMILY,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
     If @consol = "trader"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),TRADER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),TRADER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
     If @consol = "sub_broker"  
     Begin  
	Set @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SUB_BROKER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,TRADE_DATE = S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),SUB_BROKER,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME,"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0,CLIENTTYPE =''"
     End  
End  
  
  
If @groupf = "3.3"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin     If @consol = "region"  
     Begin  
	SET @@mygroup = " GROUP BY REGION,S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT REGION,S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "area"  
     Begin  
	SET @@mygroup = " GROUP BY AREA,S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT AREA,S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
  
     If @consol = "party_code"  
     Begin   
	SET @@mygroup = " GROUP BY S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End   
     If @consol = "branch_cd"  
     Begin  
	SET @@mygroup = " GROUP BY S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "family"  
     Begin  
	SET @@mygroup = " GROUP BY S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "trader"  
     Begin  
	SET @@mygroup = " GROUP BY S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "sub_broker"  
     Begin  
	SET @@mygroup = " GROUP BY S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BR.BRANCH,SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME "
	SET @@selectflex = "SELECT S.BRANCH_CD,S.SUB_BROKER,S.TRADER,S.FAMILY,BRANCHNAME=BR.BRANCH,SUBBROKERNAME=SB.NAME,PARTY_CODE,PARTY_NAME,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
End  
  
  
If @groupf = "3.4"   ------------------------ To Be Used For Net Position Across Settlement,scrip,series  ----------------------  
Begin  
    If @consol = "region"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "area"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "party_code"  
     Begin   
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End   
     If @consol = "branch_cd"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "family"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "trader"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
     If @consol = "sub_broker"  
     Begin  
	SET @@mygroup = " GROUP BY SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME "  
	SET @@selectflex = "SELECT SETT_NO, SETT_TYPE,SCRIP_CD,SERIES,SCRIP_NAME, "
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END), "
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END), "
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0, "
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX), "
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0 "
     End  
End  
  
If @groupf = "4"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
     If @consol = "area"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
  
     If @consol = "party_code"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
     If @consol = "branch_cd"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
     If @consol = "family"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
     If @consol = "trader"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
     If @consol = "sub_broker"  
     Begin   
        SET @@mygroup = " Group By SETT_NO,SETT_TYPE,S.SAUDA_DATE,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) "  
	SET @@selectflex = "SELECT SETT_NO,SETT_TYPE,TRADE_DATE=S.SAUDA_DATE,SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11),"
	SET @@selectflex = @@selectflex + "PTRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),PTRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),"
	SET @@selectflex = @@selectflex + "STRADEDQTY = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),STRADEDAMT = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),BUYBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN BROKERAGE ELSE 0 END),"
	SET @@selectflex = @@selectflex + "SELBROKERAGE = SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN BROKERAGE ELSE 0 END),BUYDELIVERYCHRG = 0,SELLDELIVERYCHRG = 0,BILLPAMT = 0,BILLSAMT = 0,PMARKETRATE = 0,SMARKETRATE = 0,PNETRATE = 0,SNETRATE = 0,"
	SET @@selectflex = @@selectflex + "TRDAMT= SUM(CASE WHEN SUB_RED_FLAG = 'P' THEN AMOUNT ELSE 0 END),DELAMT= SUM(CASE WHEN SUB_RED_FLAG <> 'P' THEN AMOUNT ELSE 0 END),SERINEX=0,SERVICE_TAX= SUM(SERVICE_TAX),EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),"
	SET @@selectflex = @@selectflex + "SEBI_TAX=SUM(SEBI_TAX),INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),OTHER_CHRG=SUM(OTHER_CHRG),MEMBERTYPE = '', COMPANYNAME = '',PNL = 0"
     End    
End  
  
  
  
If @groupf = "4.1"  ------------------------ To Be Used For Net Position Across Settlement,scrip,series,tmark  ----------------------  
Begin  
     If @consol = "region"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),region,branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),region,branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "area"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),area,branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),area,branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
  
     If @consol = "party_code"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),party_code,party_name,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "            
   Set  @@selectflex =  " Select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),party_code, Party_name,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype, Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "branch_cd"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),branch_cd,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),branch_cd,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "  
 
     End    
     If @consol = "family"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),family,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),family,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "trader"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),trader,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),trader,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname,pnl = Sum(samttrd-pamttrd) "   
     End    
     If @consol = "sub_broker"  
     Begin   
          Set  @@mygroup = " Group By Sett_no, Sett_type,sauda_date,left(convert(varchar,sauda_date,109),11),sub_broker,clienttype,membertype, Companyname,scrip_cd,series,scrip_name "  
          Set  @@selectflex =  "select Sett_no, Sett_type,trade_date = S.sauda_date,sauda_date = Left(convert(varchar,sauda_date,109),11),sub_broker,scrip_cd,series,scrip_name,ptradedqty = Sum(pqtytrd + Pqtydel) ,ptradedamt = Sum(pamttrd + Pamtdel) ,stradedqty = Sum(sqtytrd + Sqtydel), Stradedamt = Sum(samttrd + Samtdel),buybrokerage = Sum(pbroktrd) , Selbrokerage= Sum(sbroktrd) ,buydeliverychrg = Sum(pbrokdel) ,selldeliverychrg = Sum(sbrokdel) , Clienttype='', Billpamt = Sum(pamt) , Billsamt = Sum(samt) , Pmarketrate = ( Sum(prate) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Smarketrate = ( Sum(srate) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),   Pnetrate = ( Sum(pamttrd + Pamtdel) / Case When Sum(pqtytrd + Pqtydel) > 0 Then Sum(pqtytrd + Pqtydel) Else 1 End) , Snetrate = ( Sum(samttrd+samtdel) / (case When Sum(sqtytrd + Sqtydel) > 0 Then Sum(sqtytrd + Sqtydel) Else 1 End ) ),  Trdamt= Sum(trdamt) ,delamt=sum(delamt), Serinex=sum(serinex),service_tax= Sum(service_tax) ,exservice_tax= Sum(exservice_tax),turn_tax=sum(turn_tax),sebi_tax=sum(sebi_tax),ins_chrg=sum(ins_chrg),broker_chrg=sum(broker_chrg),other_chrg=sum(other_chrg), Membertype, Companyname ,pnl = Sum(samttrd-pamttrd)" 
  
     End    
End  
  
-------------------------------------  End Of Decide Group By Options  ----------------------------------------------------  
  
If @groupf = "3.3"  
Begin  
 Set @@wheretext =  " Where /*S.Branch_CD = BR.Branch_Code And S.sub_broker= SB.Sub_Broker And*/ S.sauda_date Between '" + @sauda_date + " 00:00:00' And '" + @todate + " 00:00:00'"  
End  
ELse  
Begin  
 Set @@wheretext =  " Where S.sauda_date Between '" + @sauda_date + " 00:00:00' And '" + @todate + " 00:00:00'"  
End  
Set @@wheretext =  @@wheretext + " And S.scrip_cd Between '" + @fromscrip + "' And '"+  @toscrip +"' /*and S.sett_no Between '" + @sett_no + "' And '" + @tosett_no +"' */ "    
Set @@wheretext =  @@wheretext + " And S.party_code Between '" + @@fromparty_code  + "' And '" + @@toparty_code   +"'  "    
  
If Upper(@use1) <> 'ALL'  
Begin  
   If Len(@use1) > 0   
   Begin   
 Set @@wheretext = @@wheretext +  " And S.clienttype = '" + @use1 + "' "  
   End  
End  
---------------------------  Now We Will Decide About Join  We Will Always Provide From Party And Toparty -------------------------------------------  
  
If @consol = "family"  
Begin   
 Set @@wheretext =  @@wheretext + " And Family Between '" + @@fromfamily  + "' And '" + @@tofamily   +"'  "   
End  
If @consol = "trader"  
Begin  
 Set @@wheretext =  @@wheretext + " And  Trader Between '" + @@fromtrader  + "' And '" + @@totrader   +"' "   
End  
If @consol = "branch_cd"   
Begin  
 Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @@frombranch_cd  + "' And '" + @@tobranch_cd   +"' "   
End   
If @consol = "sub_broker"  
Begin   
 Set @@wheretext =  @@wheretext + " And S.Sub_broker Between '" + @@fromsub_broker  + "' And '" + @@tosub_broker   +"' "   
End  
If @consol = "region"   
Begin  
 Set @@wheretext =  @@wheretext + " And Region Between '" + @@fromregion  + "' And '" + @@toregion  +"' "   
End   
If @consol = "area"   
Begin  
 Set @@wheretext =  @@wheretext + " And  Area Between '" + @@fromarea  + "' And '" + @@toarea  +"' "   
End  
------------------------- Added For Access Control As Per User Login Status ---------------------------------------------------------------------------------------------  
  
  
If @statusid = "family"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Family Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If @statusid = "trader"  
Begin  
 Set @@wheretext =  @@wheretext + " And  Trader Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If (@statusid = "branch") OR (@statusid = "branch_cd")  
Begin  
 Set @@wheretext =  @@wheretext + " And Branch_cd Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If (@statusid = "subbroker") OR (@statusid = "sub_broker")  
Begin  
 Set @@wheretext =  @@wheretext + " And S.Sub_broker Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
  
If @statusid = "client"   
Begin  
 Set @@wheretext =  @@wheretext + " And Party_code Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = "region"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Region Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = "area"   
Begin  
 Set @@wheretext =  @@wheretext +   "  And Area Between '" + @statusname  + "' And '" + @statusname   +"'  "   
End  
If @statusid = ""   
Begin  
 Set @@wheretext =  @@wheretext +   "  And 1 = 2 "   
End  
  
  
---------------------------   Decided About Join  -------------------------------------------  

Set @@wheretext = @@wheretext + " And  S.sett_type Between '" + @@fromsett_type + "'  And '" +  @@tosett_type  + "'"    

/*
If @detail = "br"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'scf','icf','ir' )  "    
  
If @detail = "s"  
Begin  
   If @groupf <> "0"  
   Begin  
    Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'ir' )  "    
   End  
End  
  
If @detail = "po"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'sbf','scf','ir' )"    
  
If @detail = "tu"  
   Set @@wheretext = @@wheretext + " And  Tradetype Not In ( 'sbf','scf','ibf','icf','ir' )"    
*/

  
/*null Chk For Where*/  
If @@wheretext Is Null Or Len(ltrim(rtrim(@@wheretext))) = 0  
Begin  
 Set @@wheretext = " Where 1=0"  
End  

Print @@selectflex   
Print @@selectbody   
Print @@fromtable   
Print @@wheretext   
Print @@mygroup  
Print @@myorder  
  
If @detail = "br"  
	Exec (@@selectflex + @@selectbody+ @@fromtable + @@wheretext + @@mygroup + @@myorder)    
If @detail = "s"  
	Exec (@@selectflex + @@selectbody+ @@fromtable + @@wheretext + @@mygroup + @@myorder)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_Scrip_Mst_Up
-- --------------------------------------------------
CREATE Proc [dbo].[Proc_Scrip_Mst_Up](@FilePath Varchar(200), @UpFlag Varchar(1), @ROWTERMINATOR VARCHAR(10)='\n')      
AS  
  
Declare @strSql varchar(500)              
            
TRUNCATE TABLE MFSS_SCRIP_MASTER_TMP  

SELECT TOKEN,SCRIP_CD,SERIES,INTRUMENTTYPE,QUANTITY_LIMIT,RTSCHEMECODE, AMCSCHEMECODE,
FILLER,ISIN,FOLIO_LENGHT,SEC_STATUS_NRM,ELIGIBILITY_NRM, SEC_STATUS_ODDLOT,ELIGIBILITY_ODDLOT,
SEC_STATUS_SPOT,ELIGIBILITY_SPOT, SEC_STATUS_AUCTION,ELIGIBILITY_AUCTION,AMCCODE,CATEGORYCODE,
SEC_NAME, ISSUE_RATE,MINSUBSCRADDL,BUYNAVPRICE,SELLNAVPRICE,RTAGENTCODE,VALDECINDICATOR, CATSTARTTIME,
QTYDECINDICATOR,CATENDTIME,MINSUBSCRFRESH,VALUE_LIMIT, RECORD_DATE=0,EX_DATE=0,NAVDATE=0,NO_DELIVERY_END_DATE=0,
ST_ELIGIBLE_IDX,ST_ELIGIBLE_AON,ST_ELIGIBLE_MIN_FILL, SECDEPMANDATORY,SEC_DIVIDEND,SECALLOWDEP,SECALLOWSELL,
SECMODCXL,SECALLOWBUY,BOOK_CL_START_DT=0, BOOK_CL_END_DT=0,DIVIDEND,RIGHTS,BONUS,INTEREST,AGM,EGM,OTHER,
LOCAL_DTTIME=0,DELETEFLAG,REMARK INTO #MFSS_SCRIP_MASTER_TMP 
FROM MFSS_SCRIP_MASTER_TMP 
Where 1 = 2            
        
if @ROWTERMINATOR = '\n'         
 Set @strSql = 'Bulk insert #MFSS_SCRIP_MASTER_TMP from ''' + @FilePath  + '''  with ( FIELDTERMINATOR = ''|'', ROWTERMINATOR = ''' + @ROWTERMINATOR + ''' )'              
else        
 Set @strSql = 'Bulk insert #MFSS_SCRIP_MASTER_TMP from ''' + @FilePath  + '''  with ( FIELDTERMINATOR = ''|'', ROWTERMINATOR = ''' + @ROWTERMINATOR + ''', FirstRow = 2 )'              
Exec(@strSql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_AREALISTING
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_AREALISTING]
	(
    @FROMAREACODE VARCHAR(15),
	@TOAREACODE VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15)
	)
	
AS
    if @FROMAREACODE = '' begin set @FROMAREACODE = '0'  end
    if @TOAREACODE = '' begin set @TOAREACODE = 'zzzzzz' end
    if @FROMBRANCH = '' begin set @FROMBRANCH = '0'  end
    if @TOBRANCH = '' begin set @TOBRANCH = 'zzzzzz' end

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
			Areacode = UPPER(Areacode),
			Description = UPPER(Description),
			Branch_Code = UPPER(Branch_Code)

From 
    AREA

Where
    Areacode between @FROMAREACODE and @TOAREACODE
    AND Branch_Code between @FROMBRANCH and @TOBRANCH
    

Order by
        
		Areacode,Description,Branch_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_BANKDETAILS
-- --------------------------------------------------
   
CREATE PROC [dbo].[RPT_BANKDETAILS]         
 (         
 @PARTYCODE VARCHAR(10)         
 )        
        
 --EXEC RPT_BANKDETAILS 'O123'        
         
 AS    
SET NOCOUNT ON         
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
    
 /*       
 SELECT         
  BANKNAME = ISNULL(P.BANK_NAME,''),        
  BRANCH = ISNULL(P.BRANCH_NAME,''),        
  ACNUM = ISNULL(C.CLTDPID,''),        
  ACTYPE = ISNULL(C.DEPOSITORY,'')        
 FROM        
  CLIENT4 C (NOLOCK)        
   JOIN POBANK P (NOLOCK)        
   ON (P.BANKID = C.BANKID)        
 WHERE        
  C.DEPOSITORY NOT IN ('CDSL','NSDL')        
  AND C.PARTY_CODE = @PARTYCODE        
        
------        
UNION        
------        
 */    
         
 SELECT         
  BANKNAME = ISNULL(P.BANK_NAME,''),        
  BRANCH = ISNULL(P.BRANCH_NAME,''),        
  ACNUM = ISNULL(C.ACCNO,''),        
  ACTYPE = (Case When ISNULL(C.ACCTYPE,'')  = 'SAVING' or ISNULL(C.ACCTYPE,'')  = 'SB' Then 'SAVING'       
                           When ISNULL(C.ACCTYPE,'')  = 'CURRENT' or ISNULL(C.ACCTYPE,'')  = 'CA' Then 'CURRENT'       
                           When ISNULL(C.ACCTYPE,'')  = 'OD' Then 'OVER DRAFT'       
                           ELSE 'OTHER'      
                  END),  
   IFSCCODE =  ISNULL(p.ifsccode,'')     
 FROM        
  ACCOUNT..MULTIBANKID C (NOLOCK)        
   JOIN POBANK P (NOLOCK)        
   ON (P.BANKID = C.BANKID)        
 WHERE        
  C.CLTCODE = @PARTYCODE      
  /*AND  ACCNO NOT IN (SELECT CLTDPID FROM CLIENT4       
  WHERE DEPOSITORY NOT IN ('CDSL','NSDL')        
  AND PARTY_CODE = @PARTYCODE  AND CLIENT4.BANKID = C.BANKID)*/      
        
 ORDER BY         
  BANKNAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_branchDelGet
-- --------------------------------------------------
/****** Object:  Stored Procedure dbo.rpt_branchDelGet    Script Date: 12/16/2003 2:31:43 PM ******/      
      
CREATE PROCEDURE [dbo].[rpt_branchDelGet]      
@dematid varchar(2),      
@settno varchar(7),      
@settype varchar(3),      
@branch varchar(15)      
      
AS      
  
set transaction isolation level read uncommitted      
select   
      d.sett_no,  
      d.sett_type,  
      d.Scrip_cd,  
      d.Series,  
      GetFromNse=d.Qty,      
      givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),      
      RecievedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0),      
      Branch=C1.Branch_Cd      
from   
      Client1 C1 (nolock),  
      Client2 C2 (nolock),  
      DeliveryClt d  (nolock)  
            Left Outer Join   
      DelTrans DT  (nolock)     
            On   
            (  
                  DT.sett_no = d.sett_no   
                  and Dt.sett_type = d.sett_type   
                  and DT.scrip_cd = d.scrip_cd   
                  and Dt.series = d.series       
                  And filler2 = 1   
                  And D.Party_Code = DT.Party_Code   
            )      
where   
      d.party_code = c2.party_code   
      and c1.cl_code = c2.cl_code      
      and d.sett_no = @settno   
      and d.sett_type = @settype   
      and inout = 'I'       
      and c1.Branch_Cd like ltrim(@branch)+'%'       
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Party_Code,D.Qty,C1.Branch_Cd      
Order By d.sett_no,d.sett_type,C1.Branch_Cd,D.Scrip_Cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_branchDelGive
-- --------------------------------------------------
/****** Object:  Stored Procedure dbo.rpt_branchDelGive    Script Date: 12/16/2003 2:31:43 PM ******/    
    
CREATE PROCEDURE [dbo].[rpt_branchDelGive]    
    
@dematid varchar(2),    
@settno varchar(7),    
@settype varchar(3),    
@branch varchar(15)    
    
AS    
    
select d.sett_no,d.sett_type,d.Scrip_cd,d.Series,GiveNse=d.Qty,    
 givenNse= isnull(Sum(Case When DrCr = 'D' Then DT.qty Else 0 End),0),    
 RecievedNse=isnull(Sum(Case When DrCr = 'C' Then DT.qty Else 0 End),0),    
 ScripName=d.Series,Branch=C1.Branch_Cd    
 from Client1 C1,Client2 C2,DeliveryClt d Left Outer Join DelTrans DT    
 On (DT.sett_no = d.sett_no and Dt.sett_type = d.sett_type and     
 DT.scrip_cd = d.scrip_cd and Dt.series = d.series and DrCr = 'D'    
 And filler2 = 1 And D.Party_Code = Dt.Party_Code )    
 where d.party_code = c2.party_code and c2.cl_code = c1.cl_code    
 and d.sett_no = @settno and d.sett_type = @settype and inout = 'O'     
 and c1.branch_cd like ltrim(@branch)+'%'      
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,D.Qty,D.Party_Code,C1.Branch_Cd    
 Order By d.sett_no,d.sett_type,C1.Branch_Cd,d.scrip_cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_BRANCHLISTING
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_BRANCHLISTING]
	(
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS
   
    
    if @FROMBRANCH = '' begin set @FROMBRANCH = '0'  end
    if @TOBRANCH = '' begin set @TOBRANCH = 'zzzzzz' end

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		BRANCHCODE 	= UPPER(B.BRANCH_CODE),
		BRANCHNAME 	= UPPER(ISNULL(B.BRANCH,'')),
		SUBBROKERCODE 	= UPPER(ISNULL(S.SUB_BROKER,'')),
		SUBBROKERNAME 	= UPPER(ISNULL(S.NAME,'')),
		TRADERCODE 	= UPPER(ISNULL(B2.BRANCH_CD,'')),
		TRADERNAME 	= UPPER(ISNULL(B2.LONG_NAME,''))
	FROM
		BRANCH B (NOLOCK)
			LEFT OUTER JOIN SUBBROKERS S (NOLOCK)
			ON (B.BRANCH_CODE = S.BRANCH_CODE)
			
			LEFT OUTER JOIN BRANCHES B2 (NOLOCK)
			ON (B2.BRANCH_CD = B.BRANCH_CODE)
	WHERE
		B.BRANCH_CODE >= @FROMBRANCH	
		AND B.BRANCH_CODE <= @TOBRANCH
                AND @STATUSNAME = (   
                	CASE 
                        WHEN @STATUSID = 'BRANCH' 
                        THEN B.BRANCH_CODE 
                        ELSE 'BROKER' END) 
	ORDER BY
		B.BRANCH_CODE,
		S.SUB_BROKER,
		B2.BRANCH_CD

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_broktable
-- --------------------------------------------------
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 01/15/2005 1:28:10 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 12/16/2003 2:31:44 Pm ******/  
  
  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 05/08/2002 12:35:08 Pm ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 01/14/2002 20:32:52 ******/  
  
/****** Object:  Stored Procedure Dbo.rpt_broktable    Script Date: 12/26/2001 1:23:16 Pm ******/  
  
CREATE Procedure [dbo].[Rpt_broktable]  
  
@valperc As Varchar(20),  
@val1 As Varchar(20),  
@trddel As Int  
As  
  
  
If @val1 = '%'  
  
Begin  
  
  
If @trddel = 0   
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f','d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
  
If @trddel = 1  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where  Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('t','s','f') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
If @trddel = 2  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where Trd_del In ('d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
End  
  
  
  
If @val1 <> '%'  
  
Begin  
  
  
If @trddel = 0   
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where  
(day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('t','s','f','d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
  
If @trddel = 1  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where Table_no In (select Distinct Table_no From Broktable Where  
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('t','s','f') And Val_perc Like @valperc)     
Order By Table_no,line_no,upper_lim  
End  
If @trddel = 2  
  
Begin  
Select Table_no,line_no,table_name,upper_lim,val_perc,day_puc,day_sales,sett_purch,sett_sales,normal,round_to,  
Trd_del = (case When Trd_del = 't' Then 'trading'   
  When Trd_del = 'd' Then 'delivery'  
  When Trd_del = 'f' Then 'first Leg'  
  When Trd_del = 's' Then 'second Leg'  
    End)  
From Broktable  
Where  Table_no In (select Distinct Table_no From Broktable Where  
 (day_puc = Cast(@val1 As Numeric(18,6)) Or Day_sales = Cast(@val1 As Numeric(18,6)) Or Sett_purch = Cast(@val1 As Numeric(18,6)) Or Sett_sales = Cast(@val1 As Numeric(18,6)) Or Normal = Cast(@val1 As Numeric(18,6)))  
And Trd_del In ('d') And Val_perc Like @valperc)    
Order By Table_no,line_no,upper_lim  
End  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_broktabledetails
-- --------------------------------------------------

CREATE procedure [dbo].[rpt_broktabledetails]  
  
@tabno as int  
  
as  
  
select table_no,upper_lim,day_puc,day_sales,sett_purch,sett_sales,normal,trd_del,val_perc,line_no,table_name,round_to,  
RoFig,ErrNum,NoZero,  
  
rt = ( case when ( RoFig =0  and  ErrNum=0.5 and  NoZero=1) then "ACTUAL"  else   
        ( case when ( RoFig =1  and  ErrNum=-0.1 and  NoZero=0) then "NEXT 1P" else   
         ( case when ( RoFig =5  and  ErrNum=-0.1 and  NoZero=0) then "NEXT 5P" else  
    ( case when ( RoFig =-1  and  ErrNum=0.1 and  NoZero=0) then "PREV 1P" else  
     ( case when ( RoFig =-5  and  ErrNum=0.1 and  NoZero=0) then "PREV 5P" else   
      ( case when ( RoFig =5  and  ErrNum=-2.5 and  NoZero=0) then "BANKERS"  
   
      end )end )end )end )end )end )  
from broktable  
where table_no = @tabno  
order by table_no,line_no,upper_lim

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_CLIENTLIST_REPORT
-- --------------------------------------------------


CREATE PROCEDURE  [dbo].[RPT_CLIENTLIST_REPORT]      
 (    
 @FROMDATE AS VARCHAR(11),      
 @TODATE AS VARCHAR(11),      
 @ORDER_BY AS VARCHAR(16),      
 @STATUSID VARCHAR(15),      
 @STATUSNAME VARCHAR(25),      
 @FROMPARTY VARCHAR(10),      
 @TOPARTY VARCHAR(10),      
 @FILTERVALUE VARCHAR(10),      
 @FROMCODE VARCHAR(10),      
 @TOCODE VARCHAR(10),      
 @FIELDINPUT VARCHAR(15),    
 @CLTSTATUS VARCHAR(10),    
 @CLTYPE VARCHAR(10),    
 @SEARCH VARCHAR(15),    
 @SEARCHTEXT VARCHAR(30),    
 @DELSETTING CHAR(1),    
 @POACLIENT INT = 0,    
 @EXTRAFILTER VARCHAR(20) = '',    
 @FLTOTHER VARCHAR(10)='',
 @NONPOACLIENT INT = 0,
 @PRINTFLAG CHAR(1) = ''
 )      
 AS      
              
IF @TOPARTY = '' SET @TOPARTY = 'ZZZZZZZZZZ'  
IF @TOCODE = '' SET @TOCODE = 'ZZZZZZZZZZ'      
IF @FLTOTHER <> ''  
BEGIN   
 IF @FROMDATE = '' SET @FROMDATE = 'JAN  1 1901'    
 IF @TODATE = '' SET @TODATE = 'DEC 31 2049'  
END  
ELSE  
BEGIN  
 SET @FROMDATE = ''  
 SET @TODATE = ''  
END  
  
SELECT * INTO #CLIENT1_TMP FROM msajag..CLIENT1 WHERE 1=2  
SELECT * INTO #CLIENT5_TMP FROM msajag..CLIENT5 WHERE 1=2  
  
INSERT INTO #CLIENT1_TMP SELECT C1.* FROM msajag..CLIENT1 C1 INNER JOIN msajag..CLIENT2 C2 ON C1.CL_CODE = C2.CL_CODE  
WHERE C1.CL_CODE BETWEEN @FROMPARTY AND @TOPARTY  
AND C1.CL_TYPE LIKE @CLTYPE + '%'  
AND C1.CL_STATUS LIKE @CLTSTATUS +'%'  
AND @STATUSNAME = (CASE WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD  
      WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER   
      WHEN @STATUSID = 'TRADER' THEN C1.TRADER         
      WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY         
      WHEN @STATUSID = 'AREA' THEN C1.AREA         
      WHEN @STATUSID = 'REGION' THEN C1.REGION         
      WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE         
     ELSE 'BROKER' END)   
AND (CASE WHEN @FILTERVALUE = 'SUBBROKER' THEN C1.SUB_BROKER   
  WHEN @FILTERVALUE = 'TRADER' THEN C1.TRADER         
  WHEN @FILTERVALUE = 'FAMILY' THEN C1.FAMILY         
  WHEN @FILTERVALUE = 'AREA' THEN C1.AREA         
  WHEN @FILTERVALUE = 'REGION' THEN C1.REGION  
  WHEN @FILTERVALUE = 'SBU' THEN C2.DUMMY8  
 ELSE  C1.BRANCH_CD END) BETWEEN @FROMCODE AND @TOCODE  
  
CREATE NONCLUSTERED INDEX [IDX_CLIENT1_TMP] ON [DBO].[#CLIENT1_TMP]   
(  
 [CL_CODE] ASC,  
 [BRANCH_CD] ASC  
) ON [PRIMARY]  
  
IF @FLTOTHER IN ('T','NT','A','IN','AT','INT','ANT','INNT','ACT','DACT')  
 INSERT INTO #CLIENT5_TMP SELECT C5.* FROM msajag..CLIENT5 C5 INNER JOIN #CLIENT1_TMP C1 ON C5.CL_CODE = C1.CL_CODE  
 LEFT OUTER JOIN  
  (SELECT PARTY_CODE,LASTTRADE = MAX(LEFT(SAUDA_DATE,11)),TRADED = CONVERT(VARCHAR(10),'T') FROM SETTLEMENT WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59' GROUP BY PARTY_CODE) S  
   ON C5.CL_CODE = S.PARTY_CODE  
  WHERE @FLTOTHER = (CASE WHEN @FLTOTHER IN ('T','NT') THEN ISNULL(S.TRADED,'NT')  
     WHEN @FLTOTHER IN ('A','IN') THEN (CASE WHEN GETDATE() BETWEEN ACTIVEFROM AND INACTIVEFROM THEN 'A' ELSE 'IN' END)   
     WHEN @FLTOTHER IN ('ACT') THEN (CASE WHEN C5.ACTIVEFROM BETWEEN @FROMDATE AND @TODATE + ' 23:59' THEN 'ACT' ELSE '' END)   
     WHEN @FLTOTHER IN ('DACT') THEN (CASE WHEN C5.INACTIVEFROM BETWEEN @FROMDATE AND @TODATE + ' 23:59' THEN 'DACT' ELSE '' END)  
     WHEN @FLTOTHER IN ('AT','INT','ANT','INNT') THEN ((CASE WHEN GETDATE() BETWEEN C5.ACTIVEFROM AND C5.INACTIVEFROM THEN 'A' ELSE 'IN' END) + ISNULL(S.TRADED,'NT'))   
     ELSE '' END)  
       
ELSE   
 IF @FLTOTHER ='B'   
  INSERT INTO #CLIENT5_TMP SELECT C5.* FROM msajag..CLIENT5 C5 INNER JOIN #CLIENT1_TMP C1 ON C5.CL_CODE = C1.CL_CODE  
   INNER JOIN (SELECT DISTINCT PARTY_CODE FROM TBL_ECNBOUNCED WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE) B   
    ON C5.CL_CODE = B.PARTY_CODE  
 ELSE   
  INSERT INTO #CLIENT5_TMP SELECT C5.* FROM msajag..CLIENT5 C5 INNER JOIN #CLIENT1_TMP C1 ON C5.CL_CODE = C1.CL_CODE  
  
CREATE NONCLUSTERED INDEX [IDX_CLIENT5_TMP] ON [DBO].[#CLIENT5_TMP]   
(  
 [CL_CODE] ASC  
) ON [PRIMARY]  
  
  
IF @SEARCH = ''    
BEGIN    
 SET @SEARCH = ''    
 SET @SEARCHTEXT = ''     
END    
    
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
SELECT          
ORDERBY = (          
    CASE           
        WHEN @ORDER_BY = 'BRANCH'           
        THEN C1.BRANCH_CD+C2.PARTY_CODE           
        ELSE       
        CASE          
            WHEN @ORDER_BY = 'SUBBROKER'           
            THEN C1.SUB_BROKER+C2.PARTY_CODE           
            ELSE           
            CASE           
                WHEN @ORDER_BY = 'PARTYCODE'           
                THEN C2.PARTY_CODE           
                ELSE           
                CASE           
                    WHEN @ORDER_BY = 'CLIENT'           
                    THEN C1.SHORT_NAME+C2.PARTY_CODE           
                    ELSE           
                    CASE           
                        WHEN @ORDER_BY = 'FAMILY'           
                        THEN C1.FAMILY+C2.PARTY_CODE           
                        ELSE           
                        CASE           
                            WHEN @ORDER_BY = 'ACTIVE'           
                            THEN CONVERT(VARCHAR(11),ACTIVEFROM)+C2.PARTY_CODE           
                            ELSE           
                            CASE           
                                WHEN @ORDER_BY = 'INACTIVE'           
                                THEN CONVERT(VARCHAR(11),INACTIVEFROM)+C2.PARTY_CODE        
                            END           
                        END           
                    END           
                END           
            END           
        END           
    END           
    )    ,      
    C1.SHORT_NAME,         
    C1.LONG_NAME,         
    ISNULL(C1.RES_PHONE1,'-') AS RES_PHONE1,         
    ISNULL(C1.OFF_PHONE1,'-') AS OFF_PHONE1,         
    C1.CL_CODE,         
    ISNULL(C1.EMAIL,'-') AS EMAIL,         
    ISNULL(C1.BRANCH_CD,'-') AS BRANCH_CD,         
    ISNULL(C1.FAMILY,'-') AS FAMILY,         
    ISNULL(C1.SUB_BROKER,'-') AS SUB_BROKER,         
	ISNULL(C1.TRADER,'-') AS TRADER,         
    C2.PARTY_CODE,         
    C2.TURNOVER_TAX,         
    C2.SEBI_TURN_TAX,         
    INSURANCE_CHRG,        
    BROKERNOTE,         
    OTHER_CHRG,         
    ISNULL(C3.BRANCH,'-') AS BRANCH,         
    C4.SHORT_NAME AS TRADER_NAME,         
    C5.NAME,        
    C5.COM_PERC,         
    ISNULL(C1.PAN_GIR_NO,'-') AS PAN_GIR_NO,         
    ISNULL(CONVERT(VARCHAR(11),ACTIVEFROM),'-') AS ACTIVEFROM,         
    ISNULL(CONVERT(VARCHAR(11),INACTIVEFROM),'-') AS INACTIVEFROM,         
    INTRODUCER = ISNULL(CL5.INTRODUCER,'-'),         
    APPROVER = ISNULL(CL5.APPROVER,'-'),         
    ISNULL(C1.L_ADDRESS1,'-') AS L_ADDRESS1,         
    ISNULL(C1.L_ADDRESS2,'-') AS L_ADDRESS2,         
    ISNULL(CL41.CLTDPID,'-') AS ACCNO,         
    ISNULL(POBANKCODE,'-') AS POBANKCODE,         
    ISNULL(POBANKNAME,'-') AS POBANKNAME,         
    ISNULL(PAYMODE,'-') AS PAYMODE,    
    BANKID = (CASE 
				WHEN @POACLIENT = 1 THEN     
					(SELECT TOP 1 DPID FROM MULTICLTID WHERE PARTY_CODE = C2.PARTY_CODE AND DEF = 1)    
				WHEN @NONPOACLIENT = 1 THEN
					(SELECT TOP 1 DPID FROM MULTICLTID WHERE PARTY_CODE = C2.PARTY_CODE AND DEF = 0)    
				ELSE
					ISNULL(CL4.BANKID,'-') 
			END),    
    CLIENTDPID = (CASE 
					WHEN @POACLIENT = 1 THEN     
						(SELECT TOP 1 CLTDPNO FROM MULTICLTID WHERE PARTY_CODE = C2.PARTY_CODE AND DEF = 1)    
					WHEN @NONPOACLIENT = 1 THEN     
						(SELECT TOP 1 CLTDPNO FROM MULTICLTID WHERE PARTY_CODE = C2.PARTY_CODE AND DEF = 0)    
					ELSE ISNULL(CL4.CLTDPID,'-') 
					END),    
    ISNULL(C1.L_ADDRESS3,'-') AS L_ADDRESS3,         
    ISNULL(C1.L_CITY,'-') AS L_CITY,         
    ISNULL(C1.L_STATE,'-') AS L_STATE,         
    ISNULL(C1.L_NATION,'-') AS L_NATION,         
    ISNULL(C1.L_ZIP,'-') AS L_ZIP,         
    ISNULL(C1.FAX,'-') AS FAX,         
    ISNULL(C1.MOBILE_PAGER,'-') AS MOBILE_PAGER,         
	CLBANKID=ISNULL(CL41.BANKID,'-'),         
    BANKNAME = ISNULL(B.BANK_NAME,'-'),     
    RMCODE = (CASE WHEN SM.SBU_TYPE='RELMGR' THEN ISNULL(SBU_CODE,'-') ELSE '' END),    
	RMNAME = (CASE WHEN SM.SBU_TYPE='RELMGR' THEN ISNULL(SBU_NAME,'-') ELSE '' END),    
    SBUCODE = ISNULL(DUMMY9,''),    
	BOUNCEDATE = ISNULL(CONVERT(VARCHAR,SAUDA_DATE,103),'')     
FROM #CLIENT1_TMP C1 (NOLOCK)    
 INNER JOIN #CLIENT5_TMP CL5 (NOLOCK) ON C1.CL_CODE = CL5.CL_CODE    
 INNER JOIN CLIENT2 C2 (NOLOCK) ON C1.CL_CODE = C2.CL_CODE    
 INNER JOIN BRANCH C3 (NOLOCK) ON C1.BRANCH_CD = C3.BRANCH_CODE    
 INNER JOIN BRANCHES C4 (NOLOCK) ON C1.TRADER=C4.SHORT_NAME    
 INNER JOIN SUBBROKERS C5 (NOLOCK) ON C1.SUB_BROKER=C5.SUB_BROKER         
 INNER JOIN ACCOUNT..ACMAST AM (NOLOCK) ON AM.CLTCODE = C2.PARTY_CODE
 INNER JOIN CLIENT_PRINT_SETTINGS  CP (NOLOCK) ON C2.PRINTF = CP.PRINT_FLAG AND C2.PRINTF = (CASE WHEN @PRINTFLAG = '' THEN C2.PRINTF ELSE @PRINTFLAG END)
 LEFT OUTER JOIN CLIENT4 CL4 (NOLOCK) ON CL4.PARTY_CODE = C2.PARTY_CODE AND CL4.DEFDP = 1 AND CL4.DEPOSITORY IN ('CDSL','NSDL')        
 LEFT OUTER JOIN CLIENT4 CL41 (NOLOCK) ON  CL41.CL_CODE = C2.CL_CODE AND CL41.DEPOSITORY NOT IN ('CDSL','NSDL')    
 LEFT OUTER JOIN POBANK B ON CONVERT(VARCHAR,B.BANKID)=CL41.BANKID     
 LEFT OUTER JOIN SBU_MASTER SM (NOLOCK) ON C2.DUMMY8 = SM.SBU_CODE    
 LEFT OUTER JOIN CLIENT_DETAILS_OTHER CDO ON C1.CL_CODE = CDO.CL_CODE AND CDO.FLD_NAME = @EXTRAFILTER AND CDO.FLD_VALUE = 1  
 LEFT OUTER JOIN     
  (SELECT DISTINCT PARTY_CODE FROM MULTICLTID M (NOLOCK), BANK B (NOLOCK) WHERE B.BANKID = M.DPID AND DEF=1) POA    
   ON C1.CL_CODE = POA.PARTY_CODE    
 LEFT OUTER JOIN     
  (SELECT DISTINCT PARTY_CODE FROM MULTICLTID M (NOLOCK), BANK B (NOLOCK) WHERE B.BANKID = M.DPID AND DEF=0
	AND PARTY_CODE NOT IN (SELECT DISTINCT PARTY_CODE FROM MULTICLTID M (NOLOCK), BANK B (NOLOCK) WHERE B.BANKID = M.DPID AND DEF=1)) NPOA    
   ON C1.CL_CODE = NPOA.PARTY_CODE
 LEFT OUTER JOIN    
  (SELECT DISTINCT PARTY_CODE,SAUDA_DATE FROM TBL_ECNBOUNCED (NOLOCK) WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE +' 23:59:59') TE    
   ON C1.CL_CODE = TE.PARTY_CODE    
 WHERE (CASE WHEN @POACLIENT = 1 THEN (CASE WHEN C1.CL_CODE = POA.PARTY_CODE THEN 1 ELSE 0 END) ELSE 0 END) = @POACLIENT     
 AND (CASE WHEN @NONPOACLIENT = 1 THEN (CASE WHEN C1.CL_CODE = NPOA.PARTY_CODE THEN 1 ELSE 0 END) ELSE 0 END) = @NONPOACLIENT  
 AND (CASE WHEN @EXTRAFILTER <> '' THEN CDO.CL_CODE ELSE C1.CL_CODE END) = C1.CL_CODE  
 AND (CASE     
   WHEN @SEARCH = 'EMAIL'   THEN C1.EMAIL     
   WHEN @SEARCH = 'PAN_GIR_NO'  THEN C1.PAN_GIR_NO     
   WHEN @SEARCH = 'BANK_NAME'  THEN B.BANK_NAME     
   WHEN @SEARCH = 'RES_PHONE1'  THEN C1.RES_PHONE1     
   WHEN @SEARCH = 'OFF_PHONE1'  THEN C1.OFF_PHONE1     
   WHEN @SEARCH = 'MOBILE_PAGER'  THEN C1.MOBILE_PAGER     
   WHEN @SEARCH = 'FAX'   THEN C1.FAX     
   WHEN @SEARCH = 'CLTDPID'  THEN CL41.CLTDPID     
   WHEN @SEARCH = 'L_CITY'  THEN C1.L_CITY     
   WHEN @SEARCH = 'L_STATE'  THEN C1.L_STATE     
   WHEN @SEARCH = 'L_ZIP'   THEN C1.L_ZIP     
   ELSE '' END) = RTRIM(LTRIM(@SEARCHTEXT))    
   AND  1 = (CASE    
   WHEN UPPER(@FIELDINPUT) = 'MAIL' THEN (CASE WHEN C1.EMAIL = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'PAN' THEN (CASE WHEN C1.PAN_GIR_NO = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'BANKNAME' THEN (CASE WHEN B.BANK_NAME = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'BRANCH' THEN (CASE WHEN B.BRANCH_NAME = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'TELR' THEN (CASE WHEN C1.RES_PHONE1 = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'TELO' THEN (CASE WHEN C1.OFF_PHONE1 = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'MOBILE' THEN (CASE WHEN C1.MOBILE_PAGER = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'FAX' THEN (CASE WHEN C1.FAX = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'ACCNO' THEN (CASE WHEN CL41.CLTDPID = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'DDPID' THEN (CASE WHEN CL4.CLTDPID = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'BDPID' THEN (CASE WHEN CL4.BANKID = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'ADD1' THEN (CASE WHEN C1.L_ADDRESS1 = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'ADD2' THEN (CASE WHEN C1.L_ADDRESS2 = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'ADD3' THEN (CASE WHEN C1.L_ADDRESS3 = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'CITY' THEN (CASE WHEN C1.L_CITY = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'STATE' THEN (CASE WHEN C1.L_STATE = '' THEN 1 ELSE 2 END)    
   WHEN UPPER(@FIELDINPUT) = 'ZIP' THEN (CASE WHEN C1.L_ZIP = '' THEN 1 ELSE 2 END)    
     ELSE 1      
    END)       
ORDER BY 1      
    
  
DROP TABLE #CLIENT1_TMP  
DROP TABLE #CLIENT5_TMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_CLIENTLISTING
-- --------------------------------------------------
--RPT_CLIENTLISTING ,'','','','','','','broker','broker'

CREATE   PROC RPT_CLIENTLISTING
	(
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE ,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		AREA,
		REGION,
		SBU,
		FAMILY,
		BANK_NAME,
		BANK_BRANCH,
		BANK_CITY,
		ACC_NO,
		DP_TYPE,
		DPID,
		CLTDPID
	FROM
		MFSS_CLIENT (NOLOCK)
	WHERE
		PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN FAMILY
			WHEN @STATUSID = 'AREA'
			THEN AREA
			WHEN @STATUSID = 'REGION'
			THEN REGION
			WHEN @STATUSID = 'CLIENT'
			THEN PARTY_CODE
			ELSE 'BROKER' 
		END)

	
	ORDER BY
		1,2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_CONFIRMMEMO
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_CONFIRMMEMO]
(
	@FPARTY VARCHAR(10),
	@TPARTY VARCHAR(10),
	@FDATE VARCHAR(11),
	@TDATE VARCHAR(11),
	@STATUSID VARCHAR(25),
	@STATUSNAME VARCHAR(25)
)	
AS
/*
	EXEC RPT_CONFIRMMEMO '0', 'ZZZZZ', '01/01/2000', '31/12/2010', 'BROKER', 'BROKER'
*/

IF LEN(@FDATE) = 10 AND CHARINDEX('/', @FDATE) > 0
	SET @FDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FDATE, 103), 109)

IF LEN(@TDATE) = 10 AND CHARINDEX('/', @TDATE) > 0
	SET @TDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TDATE, 103), 109)

CREATE TABLE #CL_DETAILS
(
	SRNO INT IDENTITY(1,1),
	NAME VARCHAR(100),
	ADDR1 VARCHAR(100),
	ADDR2 VARCHAR(100),
	ADDR3 VARCHAR(100),
	CITY VARCHAR(40),
	ZIP VARCHAR(10),
	PARTY_CODE VARCHAR(10),
	PHONE1 VARCHAR(15),
	PHONE2 VARCHAR(15),
	PHONEO1 VARCHAR(15),
	PHONEO2 VARCHAR(15),
	CELLNO VARCHAR(40),
	PAN VARCHAR(50),
	EMAIL VARCHAR(100),
	PASSPORTNO VARCHAR(30),
	VOTERSID VARCHAR(30),
	RATIONCARD VARCHAR(30),
	LICENCENO VARCHAR(30),
	PASSPORTDATEOFISSUE VARCHAR(30),
	PASSPORTPLACEOFISSUE VARCHAR(30),
	VOTERIDDATEOFISSUE VARCHAR(30),
	VOTERIDPLACEOFISSUE VARCHAR(30),
	LICENCENODATEOFISSUE VARCHAR(30),
	LICENCENOPLACEOFISSUE VARCHAR(30),
	RATIONCARDDATEOFISSUE VARCHAR(30),
	RATIONCARDPLACEOFISSUE VARCHAR(30),
	PASSPORT_EXPIRES_ON VARCHAR(30),
	LICENCE_EXPIRES_ON VARCHAR(30),
	BANK_NAME VARCHAR(50),
	BRANCH_NAME VARCHAR(50),
	AC_NUM VARCHAR(20),
	AC_TYPE VARCHAR(7),
	BANKNAME VARCHAR(60),
	BANKID VARCHAR(16),
	CLTDPID VARCHAR(16),
	DEPOSITORY VARCHAR(7),
	SYSTEMDATE VARCHAR(11),
	BRANCH_CD VARCHAR(20),
	BRNAME VARCHAR(80),
	BRADD1 VARCHAR(100),
	BRADD2 VARCHAR(100),
	BRCITY VARCHAR(40),
	BRZIP VARCHAR(30),
	BRPHONE1 VARCHAR(30),
	BRPHONE2 VARCHAR(30),
	BREMAIL VARCHAR(100)
)

INSERT INTO #CL_DETAILS
	(NAME, ADDR1, ADDR2, ADDR3, CITY, ZIP, PARTY_CODE, PHONE1, PHONE2, PHONEO1, PHONEO2, CELLNO, PAN, EMAIL, PASSPORTNO, VOTERSID, RATIONCARD,
	LICENCENO, PASSPORTDATEOFISSUE, PASSPORTPLACEOFISSUE, VOTERIDDATEOFISSUE, VOTERIDPLACEOFISSUE, LICENCENODATEOFISSUE,
	LICENCENOPLACEOFISSUE, RATIONCARDDATEOFISSUE, RATIONCARDPLACEOFISSUE, PASSPORT_EXPIRES_ON, LICENCE_EXPIRES_ON, BANK_NAME,
	BRANCH_NAME, AC_NUM, AC_TYPE, BANKNAME, BANKID, CLTDPID, DEPOSITORY, SYSTEMDATE, BRANCH_CD, BRNAME, BRADD1, BRADD2, BRCITY, BRZIP,
	BRPHONE1, BRPHONE2, BREMAIL)

SELECT
	NAME = CLIENT_DETAILS.LONG_NAME,
	ADDR1 = L_ADDRESS1,
	ADDR2 = L_ADDRESS2,
	ADDR3 = L_ADDRESS3,
	CITY = L_CITY,
	ZIP = L_ZIP,
	PARTY_CODE,
	PHONE1 = RES_PHONE1,
	PHONE2 = RES_PHONE2,
	PHONEO1 = OFF_PHONE1,
	PHONEO2 = OFF_PHONE2,
	CELLNO = MOBILE_PAGER,
	PAN = PAN_GIR_NO,
	EMAIL = LOWER(CLIENT_DETAILS.EMAIL),
	PASSPORTNO = PASSPORT_NO,
	VOTERSID = VOTERSID_NO,
	RATIONCARD = RAT_CARD_NO,
	LICENCENO = LICENCE_NO,
	PASSPORTDATEOFISSUE = (CASE WHEN YEAR(PASSPORT_ISSUED_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,PASSPORT_ISSUED_ON,103) END),
	PASSPORTPLACEOFISSUE = PASSPORT_ISSUED_AT,
	VOTERIDDATEOFISSUE = (CASE WHEN YEAR(VOTERSID_ISSUED_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,VOTERSID_ISSUED_ON,103) END),
	VOTERIDPLACEOFISSUE = VOTERSID_ISSUED_AT,
	LICENCENODATEOFISSUE = (CASE WHEN YEAR(LICENCE_ISSUED_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,LICENCE_ISSUED_ON,103) END),
	LICENCENOPLACEOFISSUE = LICENCE_ISSUED_AT,
	RATIONCARDDATEOFISSUE = (CASE WHEN YEAR(RAT_CARD_ISSUED_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,RAT_CARD_ISSUED_ON,103) END),
	RATIONCARDPLACEOFISSUE = RAT_CARD_ISSUED_AT,
	PASSPORT_EXPIRES_ON = (CASE WHEN YEAR(PASSPORT_EXPIRES_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,PASSPORT_EXPIRES_ON,103) END),
	LICENCE_EXPIRES_ON = (CASE WHEN YEAR(LICENCE_EXPIRES_ON) = '1900' THEN '' ELSE CONVERT(VARCHAR,LICENCE_EXPIRES_ON,103) END),
	BANK_NAME,
	BRANCH_NAME,
	AC_NUM,
	AC_TYPE = (CASE WHEN AC_TYPE = 'S' THEN 'SAVING' WHEN AC_TYPE = 'C' THEN 'CURRENT' ELSE 'OTHER' END),
	BANKNAME = ISNULL(BANKNAME,'N/A'),
	BANKID = DPID1,
	CLTDPID = CLTDPID1,
	DEPOSITORY = DEPOSITORY1,
	SYSTEMDATE = '', --LEFT(MIN(SYSTEMDATE),11),
	BRANCH_CD = BR.BRANCH_CODE,
	BRNAME = BR.BRANCH,
	BRADD1 = BR.ADDRESS1,
	BRADD2 = BR.ADDRESS2,
	BRCITY = BR.CITY,
	BRZIP = BR.ZIP,
	BRPHONE1 = BR.PHONE1,
	BRPHONE2 = BR.PHONE2,
	BREMAIL = BR.EMAIL
FROM
	MSAJAG..CLIENT_DETAILS
		LEFT OUTER JOIN BANK ON (DPID1 = BANKID )
		LEFT OUTER JOIN BRANCH BR ON (BR.BRANCH_CODE = CLIENT_DETAILS.BRANCH_CD)
WHERE
	PARTY_CODE >= @FPARTY AND PARTY_CODE <= @TPARTY
	AND EXISTS (SELECT CL_CODE FROM MSAJAG..CLIENT_BROK_DETAILS I WHERE I.SYSTEMDATE >= @FDATE AND I.SYSTEMDATE <= @TDATE + ' 23:59'
				AND CLIENT_DETAILS.PARTY_CODE = I.CL_CODE)
	--AND SYSTEMDATE >= @FDATE AND SYSTEMDATE <= @TDATE + ' 23:59:59'
	AND @STATUSNAME = CASE @STATUSID
						WHEN 'AREA' THEN AREA
						WHEN 'REGION' THEN REGION
						WHEN 'BRANCH' THEN BRANCH_CD
						WHEN 'SUBBROKER' THEN SUB_BROKER
						WHEN 'TRADER' THEN TRADER
						WHEN 'FAMILY' THEN FAMILY
						WHEN 'CLIENT' THEN PARTY_CODE
						ELSE 'BROKER' END
ORDER BY
	PARTY_CODE

UPDATE O SET SYSTEMDATE = CONVERT(VARCHAR(11), I.SYSTEMDATE, 109) FROM
	#CL_DETAILS O,
	(SELECT
		CL_CODE,
		SYSTEMDATE = MIN(SYSTEMDATE)
	FROM
		MSAJAG..CLIENT_BROK_DETAILS
	GROUP BY
		CL_CODE
	) I
WHERE
	O.PARTY_CODE = I.CL_CODE

SELECT * FROM #CL_DETAILS
EXEC MSAJAG..V2_RPT_CLIENTBROKTABLEDETAILS
DROP TABLE #CL_DETAILS
SELECT COMPANY, ADDR1, ADDR2, PHONE, ZIP, CITY, FAX FROM OWNER

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_CUSTODIANWISEBROK_REPORT
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_CUSTODIANWISEBROK_REPORT]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMCUSTODIAN VARCHAR(15),
	@TOCUSTODIAN VARCHAR(15),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@STATUSID VARCHAR(10),
	@STATUSNAME VARCHAR(25),
	@RPTTYPE VARCHAR(10)
	)

	AS

	-- EXEC RPT_CUSTODIANWISEBROK_REPORT 'JAN  1 2000','DEC 31 2009','','ZZZZZZZ','BROKER','BROKER'

	IF @FROMCUSTODIAN =''
	BEGIN
		SET @FROMCUSTODIAN = ''
	END

	IF @TOCUSTODIAN =''
	BEGIN
		SET @TOCUSTODIAN = 'ZZZZZZZZZZZ'
	END

	IF @FROMPARTY =''
	BEGIN
		SET @FROMPARTY = ''
	END

	IF @TOPARTY =''
	BEGIN
		SET @TOPARTY = 'ZZZZZZZZZZZ'
	END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT 
		CUSTODIANCODE,
		CUSTODIAN_NAME = ISNULL(C.LONG_NAME,''),
		PARTY_CODE = I.PARTY_CODE,
		PARTY_NAME = ISNULL(C1.LONG_NAME,''),
		NSETOTBROK = CONVERT(NUMERIC(18,4),ROUND(SUM(TRADEQTY*NBROKAPP),4)),
		NSENETBROK = CONVERT(NUMERIC(18,4),ROUND(SUM(CASE 
				WHEN SERVICE_CHRG = 1 THEN 
					(TRADEQTY*NBROKAPP) - ((TRADEQTY*NBROKAPP)- ABS((TRADEQTY*NBROKAPP)*100/(100+G.SERVICE_TAX)))
				ELSE
					(TRADEQTY*NBROKAPP)
				END),4)),
		NSESERVICE = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN SERVICE_CHRG = 0 
					THEN NSERTAX ELSE 0 
					END),2)),
		NSETURNTAX = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN TURNOVER_TAX = 1 
					THEN TURN_TAX ELSE 0 
					END),2)),
		NSESEBITURNTAX = CONVERT(NUMERIC(18,2),ROUND(
					SUM(CASE 
						WHEN SEBI_TURN_TAX = 1 
						THEN SEBI_TAX ELSE 0 
						END),2)),
		NSESTAMPDUTY = CONVERT(NUMERIC(18,2),ROUND(
					SUM(CASE 
						WHEN BROKERNOTE = 1 
						THEN BROKER_CHRG ELSE 0 
						END),2)),
		NSESTT = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN INSURANCE_CHRG = 1 
					THEN INS_CHRG ELSE 0 
					END),2)),
		NSEOTHERCHRG = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN C2.OTHER_CHRG = 1 
					THEN I.OTHER_CHRG ELSE 0 
					END),2)),

		BSETOTBROK = CONVERT(NUMERIC(18,4),ROUND(0,4)),
		BSENETBROK = CONVERT(NUMERIC(18,4),ROUND(0,4)),
		BSESERVICE = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		BSETURNTAX = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		BSESEBITURNTAX = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		BSESTAMPDUTY = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		BSESTT = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		BSEOTHERCHRG = CONVERT(NUMERIC(18,2),ROUND(0,2))
		
	INTO 
		#NSECUSTREPORT		
	FROM 
		ISETTLEMENT I, 
		CLIENT1 C1, 
		CLIENT2 C2, 
		CUSTODIAN C, 
		GLOBALS G
	WHERE 
		I.PARTY_CODE = C2.PARTY_CODE
		AND C1.CL_CODE = C2.CL_CODE
		AND C2.CLTDPNO = C.CUSTODIANCODE
		AND SAUDA_DATE BETWEEN G.YEAR_START_DT AND G.YEAR_END_DT
		AND SAUDA_DATE BETWEEN @FROMDATE AND @TODATE +' 23:59:59'
		AND I.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND C.CUSTODIANCODE BETWEEN @FROMCUSTODIAN AND @TOCUSTODIAN
		AND @STATUSNAME = (
		CASE
			WHEN @STATUSID = 'BRANCH'
			THEN C1.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN C1.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN C1.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN C1.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN C1.AREA
			WHEN @STATUSID = 'REGION'
			THEN C1.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN C2.PARTY_CODE
			ELSE 'BROKER' 
		END)
	GROUP BY
		CUSTODIANCODE,
		I.PARTY_CODE,
		ISNULL(C.LONG_NAME,''),
		ISNULL(C1.LONG_NAME,'')


	INSERT INTO #NSECUSTREPORT
	SELECT 
		CUSTODIANCODE,
		CUSTODIAN_NAME = ISNULL(C.LONG_NAME,''),
		PARTY_CODE = I.PARTY_CODE,
		PARTY_NAME = ISNULL(C1.LONG_NAME,''),
		NSETOTBROK = CONVERT(NUMERIC(18,4),ROUND(0,4)),
		NSENETBROK = CONVERT(NUMERIC(18,4),ROUND(0,4)),
		NSESERVICE = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		NSETURNTAX = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		NSESEBITURNTAX = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		NSESTAMPDUTY = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		NSESTT = CONVERT(NUMERIC(18,2),ROUND(0,2)),
		NSEOTHERCHRG = CONVERT(NUMERIC(18,2),ROUND(0,2)),

		BSETOTBROK = CONVERT(NUMERIC(18,4),ROUND(SUM(TRADEQTY*NBROKAPP),4)),
		BSENETBROK = CONVERT(NUMERIC(18,4),ROUND(SUM(CASE 
				WHEN SERVICE_CHRG = 1 THEN 
					(TRADEQTY*NBROKAPP) - ((TRADEQTY*NBROKAPP)- ABS((TRADEQTY*NBROKAPP)*100/(100+G.SERVICE_TAX)))
				ELSE
					(TRADEQTY*NBROKAPP)
				END),4)),
		BSESERVICE = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN SERVICE_CHRG = 0 
					THEN NSERTAX ELSE 0 
					END),2)),
		BSETURNTAX = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN TURNOVER_TAX = 1 
					THEN TURN_TAX ELSE 0 
					END),2)),
		BSESEBITURNTAX = CONVERT(NUMERIC(18,2),ROUND(
					SUM(CASE 
						WHEN SEBI_TURN_TAX = 1 
						THEN SEBI_TAX ELSE 0 
						END),2)),
		BSESTAMPDUTY = CONVERT(NUMERIC(18,2),ROUND(
					SUM(CASE 
						WHEN BROKERNOTE = 1 
						THEN BROKER_CHRG ELSE 0 
						END),2)),
		BSESTT = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN INSURANCE_CHRG = 1 
					THEN INS_CHRG ELSE 0 
					END),2)),
		BSEOTHERCHRG = CONVERT(NUMERIC(18,2),ROUND(
				SUM(CASE 
					WHEN C2.OTHER_CHRG = 1 
					THEN I.OTHER_CHRG ELSE 0 
					END),2))

	FROM 
		BSEDB.DBO.ISETTLEMENT I, 
		BSEDB.DBO.CLIENT1 C1, 
		BSEDB.DBO.CLIENT2 C2, 
		BSEDB.DBO.CUSTODIAN C, 
		BSEDB.DBO.GLOBALS G
	WHERE 
		I.PARTY_CODE = C2.PARTY_CODE
		AND C1.CL_CODE = C2.CL_CODE
		AND C2.CLTDPNO = C.CUSTODIANCODE
		AND SAUDA_DATE BETWEEN G.YEAR_START_DT AND G.YEAR_END_DT
		AND SAUDA_DATE BETWEEN @FROMDATE AND @TODATE +' 23:59:59'
		AND I.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND C.CUSTODIANCODE BETWEEN @FROMCUSTODIAN AND @TOCUSTODIAN
		AND @STATUSNAME = (
		CASE
			WHEN @STATUSID = 'BRANCH'
			THEN C1.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN C1.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN C1.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN C1.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN C1.AREA
			WHEN @STATUSID = 'REGION'
			THEN C1.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN C2.PARTY_CODE
			ELSE 'BROKER' 
		END)
	GROUP BY
		CUSTODIANCODE,
		I.PARTY_CODE,
		ISNULL(C.LONG_NAME,''),
		ISNULL(C1.LONG_NAME,'')

	IF @RPTTYPE = 'CUSTODIAN'
	BEGIN
		SELECT 
			CUSTODIANCODE,
			CUSTODIAN_NAME,
			NSETOTBROK = SUM(NSETOTBROK),
			NSENETBROK = SUM(NSENETBROK),
			NSESERVICE = SUM(NSESERVICE),
			NSETURNTAX = SUM(NSETURNTAX),
			NSESEBITURNTAX = SUM(NSESEBITURNTAX),
			NSESTAMPDUTY = SUM(NSESTAMPDUTY),
			NSESTT = SUM(NSESTT),
			NSEOTHERCHRG = SUM(NSEOTHERCHRG),

			BSETOTBROK = SUM(BSETOTBROK),
			BSENETBROK = SUM(BSENETBROK),
			BSESERVICE = SUM(BSESERVICE),
			BSETURNTAX = SUM(BSETURNTAX),
			BSESEBITURNTAX = SUM(BSESEBITURNTAX),
			BSESTAMPDUTY = SUM(BSESTAMPDUTY),
			BSESTT = SUM(BSESTT),
			BSEOTHERCHRG = SUM(BSEOTHERCHRG)
		FROM
			#NSECUSTREPORT
		GROUP BY
			CUSTODIANCODE,
			CUSTODIAN_NAME
		ORDER BY
			CUSTODIANCODE
	END 

	IF @RPTTYPE = 'CLIENT'
	BEGIN
		SELECT 
			PARTY_CODE,
			PARTY_NAME,
			NSETOTBROK = SUM(NSETOTBROK),
			NSENETBROK = SUM(NSENETBROK),
			NSESERVICE = SUM(NSESERVICE),
			NSETURNTAX = SUM(NSETURNTAX),
			NSESEBITURNTAX = SUM(NSESEBITURNTAX),
			NSESTAMPDUTY = SUM(NSESTAMPDUTY),
			NSESTT = SUM(NSESTT),
			NSEOTHERCHRG = SUM(NSEOTHERCHRG),

			BSETOTBROK = SUM(BSETOTBROK),
			BSENETBROK = SUM(BSENETBROK),
			BSESERVICE = SUM(BSESERVICE),
			BSETURNTAX = SUM(BSETURNTAX),
			BSESEBITURNTAX = SUM(BSESEBITURNTAX),
			BSESTAMPDUTY = SUM(BSESTAMPDUTY),
			BSESTT = SUM(BSESTT),
			BSEOTHERCHRG = SUM(BSEOTHERCHRG)
		FROM
			#NSECUSTREPORT
		GROUP BY
			PARTY_CODE,
			PARTY_NAME
		ORDER BY
			PARTY_CODE
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELBENPAYOUT_NRM_CLRATE
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_DELBENPAYOUT_NRM_CLRATE] (                  
@BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),                   
@FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),                  
@FROMSCRIP VARCHAR(20), @TOSCRIP VARCHAR(20),  
@ACNAME VARCHAR(100),                  
@CHKFLAG VARCHAR(20), @PAYFLAG INT, @SUMMARYFLAG INT,            
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))                  
AS                       
        
TRUNCATE TABLE DELACCBALANCE        
                  
IF @CHKFLAG <> 'THIRD PARTY' AND @PAYFLAG = 1                  
BEGIN                  
 EXEC INSDELACCCHECK                  
                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,' '),TRTYPE,                  
 D.DPTYPE,D.CLTDPID,D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),                  
 ISETT_NO=' ',ISETT_TYPE=' ',SETT_NO=' ',SETT_TYPE=' ',SERIESID=D.SERIES,CL_RATE = CONVERT(NUMERIC(18,4),0)                   
 INTO #DELPAYOUT                   
 FROM MFSS_DPMASTER M, MFSS_SCRIP_MASTER S, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A                   
  ON ( A.CLTCODE = D.PARTY_CODE )                   
 WHERE TRTYPE IN (904,905) AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID                   
 AND M.DP_TYPE = D.DPTYPE AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP     
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series              
 AND TRTYPE >= (CASE WHEN @CHKFLAG = 'BRANCH MARKING'                
        THEN 905                
        ELSE 904                
      END)            
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )                     
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,ISNULL(PARTY_NAME,' '),TRTYPE,D.CLTDPID,D.DPID,                  
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,D.DPTYPE                   
 ORDER BY D.DPTYPE,D.PARTY_CODE,S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUT SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUT.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUT.SCRIP_CD                                    
 AND #DELPAYOUT.CL_RATE = 0                  
                              
 SELECT * FROM #DELPAYOUT                   
                  
END                  
                  
IF @CHKFLAG = 'THIRD PARTY' AND @PAYFLAG = 1                  
BEGIN                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(C1.LONG_NAME,' '),TRTYPE,                  
 D.DPTYPE,D.CLTDPID,D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=0,                  
 ISETT_NO=' ',ISETT_TYPE=' ',SETT_NO=' ',SETT_TYPE=' ', SERIESID=D.SERIES,CL_RATE = CONVERT(NUMERIC(18,4),0)                   
 INTO #DELPAYOUTTHIRD                   
 FROM CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER S, DELTRANS D                   
 WHERE TRTYPE IN (904,905) AND D.PARTY_CODE = C2.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE                   
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP                  
 AND D.FILLER1 LIKE 'THIRD PARTY'            
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series   
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )                  
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,C1.LONG_NAME,TRTYPE,D.CLTDPID,D.DPID,                   
 CERTNO, BDPTYPE,BDPID,BCLTDPID,D.DPTYPE                   
 ORDER BY D.DPTYPE,D.PARTY_CODE,S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUTTHIRD SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUTTHIRD.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUTTHIRD.SCRIP_CD                                    
 AND #DELPAYOUTTHIRD.CL_RATE = 0                  
                  
 SELECT * FROM #DELPAYOUTTHIRD                   
                  
END                  
                  
IF @PAYFLAG = 0                  
BEGIN                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=' ',TRTYPE,DT.DPTYPE,CLTDPID=DPCLTNO,                  
 DT.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=0,ISETT_NO=' ',ISETT_TYPE=' ',                  
 SETT_NO=' ',SETT_TYPE=' ', SERIESID = D.SERIES, CL_RATE = CONVERT(NUMERIC(18,4),0),ACTPAYOUT=CONVERT(NUMERIC(18,3),SUM(QTY))                   
 INTO #DELPAYOUTBEN                  
 FROM DELTRANS D, MFSS_SCRIP_MASTER S, DELIVERYDP DT                   
 WHERE TRTYPE = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then 1002 Else 904 END)         
 AND DT.DESCRIPTION = @ACNAME                  
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP    
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series           
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )        
 AND D.CLTDPID = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then DT.DpCltNo Else D.CLTDPID END)        
 AND D.DPID = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then DT.DPID Else D.DPID END)        
 GROUP BY D.PARTY_CODE, S.SEC_NAME,D.SCRIP_CD,D.SERIES,TRTYPE,DPCLTNO,DT.DPID,CERTNO,BDPTYPE,BDPID,BCLTDPID,DT.DPTYPE                   
 ORDER BY D.PARTY_CODE, S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUTBEN SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUTBEN.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUTBEN.SCRIP_CD                                    
 AND #DELPAYOUTBEN.CL_RATE = 0                 
              
 IF @SUMMARYFLAG = 0               
 BEGIN                  
  SELECT * FROM #DELPAYOUTBEN              
  ORDER BY PARTY_CODE, SERIES, SCRIP_CD,  CERTNO                 
    END              
 ELSE              
 BEGIN              
  SELECT SCRIP_CD, SERIES, PARTY_CODE = 'BEN', LONG_NAME, TRTYPE, DPTYPE, CLTDPID, DPID, CERTNO,               
  QTY=CONVERT(NUMERIC(18,3),SUM(QTY)), BDPTYPE, BDPID, BCLTDPID, AMOUNT = 0, ISETT_NO, ISETT_TYPE, SETT_NO, SETT_TYPE,              
  SERIESID, CL_RATE, ACTPAYOUT=SUM(ACTPAYOUT) FROM #DELPAYOUTBEN              
  GROUP BY SCRIP_CD, SERIES, LONG_NAME, TRTYPE, DPTYPE, CLTDPID, DPID, CERTNO, BDPTYPE, BDPID, BCLTDPID,               
  ISETT_NO, ISETT_TYPE, SETT_NO, SETT_TYPE, SERIESID, CL_RATE              
  ORDER BY SCRIP_CD, SERIES, CERTNO              
 END              
   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELHOLDMATCH_NEW
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_DELHOLDMATCH_NEW]               
( @CLTDPID VARCHAR(16),                
  @DPID VARCHAR(8) )                
AS               
CREATE TABLE #HOLDRECO            
(             
 ISIN VARCHAR(12),            
 SCRIP_NAME VARCHAR(250),            
 SETT_NO VARCHAR(7),            
 SETT_TYPE VARCHAR(2),            
 SCRIP_CD VARCHAR(50),            
 QTY NUMERIC(18,3),            
 FREEQTY NUMERIC(18,3),            
 PLEDGEQTY NUMERIC(18,3),            
 HOLDQTY NUMERIC(18,3),            
 HOLDFREEQTY NUMERIC(18,3),            
 HOLDPLEDGEQTY NUMERIC(18,3),            
 TODAYQTY NUMERIC(18,3)            
)             
SELECT SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,SERIES,CERTNO,QTY=SUM(QTY),TRANSDATE,DRCR,      
BDPTYPE,BDPID,BCLTDPID,FILLER2,DELIVERED, EXCHG = 'BSE'      
INTO #DEL FROM DELTRANS      
WHERE DRCR = 'D' AND FILLER2 = 1 AND BCLTDPID = @CLTDPID AND BDPID = @DPID        
AND SHARETYPE = 'DEMAT'       
GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,SERIES,CERTNO,TRANSDATE,DRCR,BDPTYPE,BDPID,BCLTDPID,FILLER2, DELIVERED      
    
IF (SELECT ISNULL(COUNT(*),0) FROM DELIVERYDP WHERE DPID = @DPID AND DPCLTNO = @CLTDPID AND DESCRIPTION LIKE '%POOL%' AND DPTYPE = 'NSDL') > 0                 
BEGIN      
INSERT INTO #HOLDRECO               
SELECT ISIN=ISNULL(CERTNO,A.ISIN),SCRIP_NAME=S2.SEC_NAME, D.SETT_NO , D.SETT_TYPE, SCRIP_CD=S2.SCRIP_CD ,                
QTY=SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)),                
FREEQTY=SUM(CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ,                
PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),                
/*TODAYQTY=SUM(CASE WHEN CONVERT(VARCHAR,TRANSDATE,106) = CONVERT(VARCHAR,GETDATE(),106) AND DELIVERED = 'G' THEN QTY ELSE 0 END) */                
TODAYQTY=SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR,TRANSDATE,106) + ' 23:59:59') >= GETDATE() AND DELIVERED = 'G' THEN QTY ELSE 0 END)                 
FROM MFSS_SCRIP_MASTER S2 (NOLOCK), #DEL D (NOLOCK) LEFT OUTER JOIN RPT_DELCDSLBALANCE A   (NOLOCK)              
ON ( A.ISIN = CERTNO AND BCLTDPID = A.CLTDPID AND BDPID = A.DPID AND A.PARTY_CODE= D.SETT_NO+D.SETT_TYPE)                 
WHERE BCLTDPID = @CLTDPID AND BDPID = @DPID               
AND CERTNO LIKE 'IN%' AND S2.SCRIP_CD = D.SCRIP_CD AND S2.SERIES = D.SERIES             
AND D.FILLER2 = 1           
GROUP BY D.SETT_NO,D.SETT_TYPE,ISNULL(CERTNO,A.ISIN),S2.SEC_NAME,FREEBAL,CURRBAL,PLEDGEBAL              
HAVING SUM(CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) <> 0                 
OR ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0               
UNION                 
SELECT ISIN=A.ISIN, SCRIP_NAME=S2.SEC_NAME, SETT_NO= LEFT(PARTY_CODE,7),SETT_TYPE= SUBSTRING(PARTY_CODE,8,9), SCRIP_CD=S2.SCRIP_CD ,            
QTY=0,FREEQTY=0,PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),TODAYQTY=0                 
FROM MFSS_SCRIP_MASTER S2 (NOLOCK), RPT_DELCDSLBALANCE A (NOLOCK) WHERE CLTDPID = @CLTDPID                
AND DPID = @DPID AND S2.SCRIP_CD = A.SCRIP_CD           
AND S2.SERIES = A.SERIES AND                 
A.ISIN NOT IN ( SELECT DISTINCT CERTNO FROM #DEL D WHERE BCLTDPID = A.CLTDPID AND                 
BDPID = A.DPID AND A.ISIN = CERTNO               
AND DELIVERED <> 'D' AND CERTNO LIKE 'IN%' AND A.PARTY_CODE= D.SETT_NO+D.SETT_TYPE )                 
--ORDER BY 2              
END                
ELSE                
BEGIN               
INSERT INTO #HOLDRECO             
SELECT ISIN=ISNULL(CERTNO,A.ISIN),SCRIP_NAME=M.SEC_NAME, SETT_NO='NA', SETT_TYPE='NA', SCRIP_CD=D.SCRIP_CD,                
QTY=SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)),                
FREEQTY=SUM((CASE WHEN TRTYPE <> 909 THEN (CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ELSE 0 END)) ,                
PLEDGEQTY=SUM((CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END)),HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),                
/*TODAYQTY=SUM(CASE WHEN CONVERT(VARCHAR,TRANSDATE,106) = CONVERT(VARCHAR,GETDATE(),106) AND DELIVERED = 'G' THEN QTY ELSE 0 END) */                
TODAYQTY=SUM(CASE WHEN  TRANSDATE >= GETDATE() AND DELIVERED IN ('G','D') THEN QTY ELSE 0 END)                 
FROM MFSS_SCRIP_MASTER M, #DEL D (NOLOCK)  LEFT OUTER JOIN RPT_DELCDSLBALANCE_NEW A    (NOLOCK)               
ON ( A.ISIN = CERTNO AND BCLTDPID = A.CLTDPID AND BDPID = A.DPID)                 
WHERE BCLTDPID = @CLTDPID AND BDPID = @DPID AND DRCR = 'D'                 
AND FILLER2 = 1 AND CERTNO LIKE 'IN%' AND TRTYPE <> 906                    
AND ( DELIVERED = ( CASE WHEN  TRANSDATE >= GETDATE() THEN 'G' ELSE '0' END)                
    OR DELIVERED = ( CASE WHEN  TRANSDATE >= GETDATE() THEN 'D' ELSE '0' END) )     
    AND D.SCRIP_CD = M.SCRIP_CD AND M.SERIES = D.SERIES              
GROUP BY ISNULL(CERTNO,A.ISIN),SEC_NAME,D.SCRIP_CD,FREEBAL,CURRBAL,PLEDGEBAL                 
HAVING ( SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)) <> 0                 
OR SUM((CASE WHEN TRTYPE <> 909 THEN (CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ELSE 0 END)) <> 0                 
OR SUM((CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END)) <> 0                 
OR ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0                 
OR SUM(CASE WHEN  TRANSDATE >= GETDATE() AND DELIVERED IN ('G','D') THEN QTY ELSE 0 END) <> 0 )                
UNION ALL                
SELECT ISIN=A.ISIN, SCRIP_NAME=ISNULL(S2.SEC_NAME,'SCRIP'), SETT_NO='NA', SETT_TYPE='NA',   
SCRIP_CD=ISNULL(S2.SCRIP_CD,'SCRIP'),QTY=0,FREEQTY=0,PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),TODAYQTY=0                 
FROM RPT_DELCDSLBALANCE_NEW A (NOLOCK)  LEFT OUTER JOIN MFSS_SCRIP_MASTER S2  (NOLOCK)                
ON (S2.SCRIP_CD = A.SCRIP_CD AND S2.SERIES = A.SERIES)                 
WHERE CLTDPID = @CLTDPID                
AND DPID = @DPID AND                 
A.ISIN NOT IN ( SELECT DISTINCT CERTNO FROM #DEL D  (NOLOCK) WHERE BCLTDPID = A.CLTDPID AND                 
BDPID = A.DPID AND A.ISIN = CERTNO                 
AND DRCR = 'D' AND FILLER2 = 1 AND CERTNO LIKE 'IN%' AND TRTYPE <> 906       
AND DELIVERED <> 'D')                 
GROUP BY A.ISIN,ISNULL(S2.SEC_NAME,'SCRIP'),S2.SCRIP_CD,FREEBAL,CURRBAL,PLEDGEBAL                 
HAVING ( ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0 )                
--ORDER BY 2                 
END          
      
SELECT * FROM #HOLDRECO ORDER BY SCRIP_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELIVERYPAYOUT
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_DELIVERYPAYOUT]          
(@SETT_NO VARCHAR(7),              
 @SETT_TYPE VARCHAR(2),              
 @FROMPARTY VARCHAR(10),              
 @TOPARTY VARCHAR(10),              
 @FROMSCRIP VARCHAR(12),              
 @TOSCRIP VARCHAR(12),              
 @DPTYPE VARCHAR(4),              
 @DPID VARCHAR(8),              
 @CLTDPID VARCHAR(16),    
 @CATEGORY VARCHAR(10),     
 @BRANCHCODE VARCHAR(10),    
 @chkflag Varchar(20))              
AS              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
          
EXEC INSDELACCCHECK    
    
/*INSERT INTO DELACCBALANCE      
SELECT PARTY_CODE, 0, PAYFLAG = 0      
FROM DELPARTYFLAG      
WHERE PARTY_CODE NOT IN (SELECT CLTCODE FROM DELACCBALANCE)      
*/  
      
--UPDATE DELACCBALANCE SET AMOUNT = 0, PAYFLAG=1 WHERE CLTCODE IN ( SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 1 )              
--UPDATE DELACCBALANCE SET AMOUNT = -1, PAYFLAG=2 WHERE CLTCODE IN ( SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 2 )              
    
if @ChkFlag = 'Branch Marking'     
Begin    
 SELECT D.SCRIP_CD,SERIES=D.SCRIP_CD,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,              
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),              
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),              
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A               
 ON ( A.CLTCODE = D.PARTY_CODE )               
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906              
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE              
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'               
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1               
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY              
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1     
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE     
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END))    
 AND TRTYPE = 905    
 GROUP BY D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,               
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG       
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,D.SCRIP_CD              
End    
Else if @ChkFlag = 'Always Payout'     
Begin    
 SELECT D.SCRIP_CD,SERIES=D.SCRIP_CD,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,              
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),              
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),              
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A               
 ON ( A.CLTCODE = D.PARTY_CODE )               
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906              
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE              
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'               
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1               
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY              
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1     
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE     
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)    
      )    
 AND ISNULL(A.PAYFLAG,0) = 1    
 GROUP BY D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,               
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG       
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,D.SCRIP_CD              
End    
Else    
Begin    
 SELECT D.SCRIP_CD,SERIES=D.SCRIP_CD,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,              
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),              
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),              
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A               
 ON ( A.CLTCODE = D.PARTY_CODE )               
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906              
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE              
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'               
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1               
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY              
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1     
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE     
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)    
      )    
 GROUP BY D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,               
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG       
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,D.SCRIP_CD              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_edoprocess
-- --------------------------------------------------
CREATE proceDURE [dbo].[rpt_edoprocess]
	@fromdate as varchar(11),
	@todate as varchar(11),
	@RptType Varchar(10)
	AS
SET @fromdate = CONVERT(varchar,@fromdate,109)             
SET @todate   = CONVERT(varchar,@todate,109)   
  
set transaction isolation level read uncommitted

If (@RptType = 'Summary')
Begin
	select
		Business_Date ,
		Sett_Type ,
		Sett_No,
		Import_Trade,
		Billing,
		VBB ,
		STT ,
		Valan,
		Contract,
		Posting,
		Open_Close,
		ProcessDate 
	
	from
		MSAJAG..V2_Business_Process(NOLOCK)
	WHERE
	 ProcessDate >= @fromdate   
   	 And   ProcessDate <= @todate + ' 23:59:59'     
 END
Else

If (@RptType = 'Detail')
Begin
	select
		SNO,
		Exchange ,
		Segment,
		BusinessDate,
		Sett_No,
		Sett_Type,
		ProcessName,
		FileName,
		Start_End_Flag,
		ProcessDate,
		ProcessBy,
		MachineIP
	from
				MSAJAG..V2_Process_Status_Log(NOLOCK)
	WHERE
	 ProcessDate >= @fromdate   
   	 And   ProcessDate <= @todate + ' 23:59:59'  

 End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_ERRORLOG
-- --------------------------------------------------
CREATE Procedure  [dbo].[rpt_ERRORLOG]            
@fromdate as varchar(11),  
@todate as varchar(11)  
  
  
AS      
SET @fromdate = CONVERT(varchar,@fromdate,109)               
SET @todate = CONVERT(varchar,@todate,109)       
            
set transaction isolation level read uncommitted                  
    
SELECT     
 Cname,  
 Mname,  
 Sname,  
 Errstr,     
 Errdate = CONVERT(varchar,Errdate,109)   
       
FROM msajag..Errorlog(NOLOCK)    
  
where    
 Errdate >= @FROMDATE    
    AND Errdate <= @TODATE + ' 23:59:59'    
Order by Errdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_FTpartydetails
-- --------------------------------------------------
CREATE Procedure [dbo].[rpt_FTpartydetails]       
-- exec rpt_FTpartydetails '0a141'
@partycode as varchar(20)      
          
as       
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
select cl2.cl_code,cl2.party_code, --cl2.dummy1,        
turnover_tax =  (case when cl2.Turnover_tax=0 then 'N'        
   when cl2.Turnover_tax=1 then 'Y'        
  end),        
sebi_turn_tax =  (case when cl2.sebi_turn_tax=0 then 'N'        
   when cl2.sebi_turn_tax=1 then 'Y'        
  end),        
Service_chrg = (case when cl2.service_chrg=0 then 'Exclusive'        
   when cl2.service_chrg=1 then 'Incl in Brok'        
   when cl2.service_chrg=2 then 'Inclusive'        
  end),        
Insurance_Chrg = (case when cl2.Insurance_Chrg=0 then 'N'        
   when cl2.Insurance_Chrg =1 then 'Y'        
  end),        
Other_chrg =(case when cl2.Other_chrg=0 then 'N'        
   when cl2.Other_chrg=1 then 'Y'        
  end),        
cl2.table_no,cl2.sub_tableno,/*cl2.demat_tableno,*/cl2.p_to_p      
,cl2.Std_rate,cl2.demat_tableno,cl2.ALBMDelchrg,cl2.ALBMDelivery,cl2.AlbmCF_tableno,cl2.MF_tableno,cl2.SB_tableno,       
cl2.brok1_tableno,cl2.brok2_tableno,      
/*brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'      
when cl2.brok3_tableno=1 then 'Treat as Charges' else 'Not Selected' end),      
dummy1= (case when cl2.dummy1=0 then 'Premium' when cl2.dummy1=1 then 'Strike'      
 when cl2.dummy1=2 then 'Strike + Premium'       
else   'Not Selected' end), cl2.Dummy2,*/      
      
brokernote= (case when cl2.brokernote=0 then 'N'        
   when cl2.brokernote=1 then 'Y'        
  end),        
brok_scheme = (case when cl2.brok_scheme=0 then 'Default'        
   when cl2.brok_scheme=1 then 'Max Logic (F/S) - Buy Side'        
   when cl2.brok_scheme=2 then 'Max Rate'      
   when cl2.brok_scheme=3 then 'Max Logic (F/S) - Sell Side'        
   when cl2.brok_scheme=4 then 'Flat Brokerage Default'        
   when cl2.brok_scheme=5 then 'Flat Brokerage (Max Logic) - Buy Side'        
   when cl2.brok_scheme=6 then 'Flat Brokerage (Max Logic) - Sell Side'        
  end),        
brok3_table_no= (case when cl2.brok3_tableno=0 then 'Treat as Brokerage'        
   when cl2.brok3_tableno=1 then 'Treat as Charges'        
  else        
   'Not Selected'        
  end),        
dummy1= (case when cl2.dummy1=0 then 'Premium'        
   when cl2.dummy1=1 then 'Strike'        
   when cl2.dummy1=2 then 'Strike + Premium'        
  else        
   'Not Selected'        
  end),        
cl2.Dummy2,        
cl1.long_name,cl1.Short_name,cl1.l_address1,cl1.l_address2, cl1.l_address3,       
cl1.L_city,cl1.L_State,cl1.L_Nation,cl1.L_Zip,cl1.Fax,cl1.Res_Phone1, Res_Phone2, Off_Phone1, Off_Phone2, cl1.Email,        
cl1.Branch_cd,cl1.Cl_type,cl1.Cl_Status,cl1.Family,cl1.Sub_Broker,cl1.Mobile_Pager,cl1.pan_gir_no,cl1.trader,        
s1.name,b1.branch  ,      
conttype= (case when cl2.InsCont='S' then 'Scripwise'        
   when cl2.InsCont='O' then 'Orderwise'        
   when cl2.InsCont='N' then 'Normal'        
  else        
   'Not available'        
  end),      
participant = (case when cl1.Cl_type='INS' then cl2.BankId      
   else  ''       
                            end) ,       
      
custodian = (case when cl1.Cl_type='INS' then CL2.CLTDPNO      
   else  ''       
                            end) ,       
      
Printf = (case when cl2.Printf=0 then 'Print'        
   else        
                'Dont Print'        
              end) ,      
      
contprt = (case when cl2.Printf =0 then 'Detail Bill And Contract'        
   when cl2.Printf =1 then 'Dont Print Bill And Contract'        
   when cl2.Printf =2 then 'Summarised Contract and Detail Bill'        
   when cl2.Printf =3 then 'Summarised Bill and Detail Contract'        
   when cl2.Printf =4 then 'Both Summarised'        
  end) ,      
convert(varchar(11),c5.ActiveFrom) as ActiveFrom ,        
InactiveFrom = (case when convert(varchar(11),c5.InactiveFrom) ='Jan  1 1900' then 'N.A.'        
   else        
               convert(varchar(11),c5.InactiveFrom)      
      end),      
/*convert(varchar(11),c5.InactiveFrom)   as InactiveFrom,*/      
C5.Introducer,C5.Approver ,       
isnull(c5.Passportdtl,'') as Passportdtl, isnull(c5.PassportDateOfIssue,'') as PassportDateOfIssue,  isnull(c5.PassportPlaceOfIssue,'') as PassportPlaceOfIssue,  isnull(c5.PASSPORTEXPDATE,'') as PASSPORTEXPDATE,      
isnull(c5.Drivelicendtl,'') as Drivelicendtl, isnull(c5.LicenceNoDateOfIssue,'') as LicenceNoDateOfIssue, isnull(c5.LicenceNoPlaceOfIssue,'') as LicenceNoPlaceOfIssue, isnull(c5.DRIVEEXPDATE,'') as DRIVEEXPDATE,      
isnull(c5.Rationcarddtl,'') as Rationcarddtl, isnull(c5.RationCardDateOfIssue,'') as RationCardDateOfIssue, isnull(c5.RationCardPlaceOfIssue,'') as RationCardPlaceOfIssue,      
isnull(c5.VotersIDdtl,'') as VotersIDdtl, isnull(c5.VoterIdDateOfIssue,'') as VoterIdDateOfIssue, isnull(c5.VoterIdPlaceOfIssue,'') as VoterIdPlaceOfIssue,  
PayLocation = cl1.Gl_code,  
SEBI_NO = FD_CODE,  
MAPINID = IsNull(MAPIDID,''),  
UCC_CODE = IsNull(UCC_CODE,''),  
PAYMENT_MODE = Space(50),  
AUTOFUNDPAYOUT = Space(5),  
BirthDate = (Case When Left(Convert(Varchar,c5.BirthDate,109),11) = 'Jan  1 1900' Then '' Else Left(Convert(Varchar,c5.BirthDate,109),11) End)  
  
INTO #ClientDetails      
from msajag..client2 cl2 Left Outer Join msajag..UCC_Client UC On (cl2.Party_Code = UC.Party_Code), msajag..client1 cl1 Left Outer Join msajag..Client5 C5 On ( C5.Cl_Code = cl1.Cl_Code ) ,      
subbrokers s1,branch b1      
where cl1.cl_code = cl2.cl_code        
and s1.sub_broker = cl1.sub_broker        
and cl2.party_code =@partycode      
and b1.branch_code = cl1.branch_cd      
    
  
IF (SELECT COUNT(1) FROM MSAJAG..SYSOBJECTS WHERE NAME = 'CLIENT_BROK_DETAILS') > 0  
BEGIN  
 UPDATE    
  #ClientDetails SET  
  PAYMENT_MODE = PAYCODENAME  
 FROM   
  MSAJAG..CLIENT_BROK_DETAILS C, MSAJAG..PAYMENTMODE P  
 WHERE  
  C.CL_CODE = #ClientDetails.PARTY_CODE  
  AND C.PAY_PAYMENT_MODE = P.PAYCODE  
  AND C.EXCHANGE = 'NSE' AND C.SEGMENT = 'FUTURES'  
END   
  
IF (SELECT COUNT(1) FROM MSAJAG..SYSOBJECTS WHERE NAME = 'CLIENT_DETAILS') > 0  
BEGIN  
 UPDATE    
  #ClientDetails SET  
  AUTOFUNDPAYOUT = (CASE WHEN C.AUTOFUNDPAYOUT = 0 THEN 'N' ELSE 'Y' END)  
 FROM   
  MSAJAG..CLIENT_DETAILS C  
 WHERE  
  C.CL_CODE = #ClientDetails.PARTY_CODE  
END   
  
SELECT * FROM #ClientDetails  
DROP TABLE #ClientDetails

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_LOGINACCESS
-- --------------------------------------------------

CREATE PROCEDURE  [dbo].[RPT_LOGINACCESS]             
@FROMDATE AS VARCHAR(11),
@TODATE AS VARCHAR(11),
@REPORTTYPE VARCHAR(10),
@SEARCHBY VARCHAR(10)


AS    
SET @FROMDATE = CONVERT(VARCHAR,@FROMDATE,109)             
SET @TODATE = CONVERT(VARCHAR,@TODATE,109)     
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
  
IF @REPORTTYPE = 'SUCCESS'
BEGIN	
	SELECT   
		   
		L.USERID,   
		L.USERNAME,
		C.FLDCATEGORYNAME,
		L.STATUSNAME,
		L.STATUSID,
		L.IPADD,
		L.ACTION,
		ADDDT = CONVERT(VARCHAR,L.ADDDT,109) 
	    	
	    
	FROM V2_LOGIN_LOG L(NOLOCK)  
		
		   
	LEFT OUTER JOIN   
	    TBLCATEGORY C(NOLOCK)     
	    ON   
	    (   
	        L.CATEGORY = C.FLDCATEGORYCODE   
	     ) 
	WHERE  
		ADDDT >= @FROMDATE  
	   	AND ADDDT <= @TODATE + ' 23:59:59'  
		AND STATUSNAME = CASE WHEN @SEARCHBY ='ADMIN' THEN 'ADMIN' ELSE STATUSNAME END
	ORDER BY ADDDT  
END
ELSE
BEGIN
	SELECT LOGIN_ID,LOGIN_PWD,IPADD,ERR_TYPE,LOGIN_DT 
	FROM V2_LOGIN_ERR_LOG
	WHERE LOGIN_DT BETWEEN @FROMDATE AND @TODATE + ' 23:59'
	AND LOGIN_TYPE = @SEARCHBY
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_BILL
-- --------------------------------------------------
CREATE   PROC [dbo].[RPT_MFSS_BILL]
	(
		@FROMDATE VARCHAR(11),
		@TODATE VARCHAR(11),
		@FROMPARTY VARCHAR(15),
		@TOPARTY VARCHAR(15),
		@FROMBRANCH VARCHAR(15),
		@TOBRANCH VARCHAR(15),
		@FROMSUBBROKER VARCHAR(15),
		@TOSUBBROKER VARCHAR(15),
		@STATUSID VARCHAR(15),
		@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'ZZZZZZZZZZ'
	END


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		MS.ORDER_NO,
		MS.ISIN,
		MS.SCRIP_CD,
		SEC_NAME = S.SCHEME_NAME + DBO.FN_SERIES_NAME(S.DIV_REINVEST_FLAG) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'PURCHASE' ELSE 'REDEEM' END),
		CR_AMOUNT = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(AMOUNT) ELSE 0 END),
		DR_AMOUNT = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(AMOUNT) ELSE 0 END),
		BROKERAGE = SUM(BROKERAGE),
		SERVICE_TAX = SUM(SERVICE_TAX),
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY = SUM(QTY),
		NETAMOUNT = SUM(
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (BROKERAGE - SERVICE_TAX)
		END),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		BILLNO = CONTRACTNO,
		FOLIONO		
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	GROUP BY	
		MS.PARTY_CODE,
		MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		OFFICE_PHONE,
		RES_PHONE, 
		EMAIL_ID,
		PAN_NO,
		CONVERT(VARCHAR,ORDER_DATE,103),
		MS.SETT_NO,
		MS.SETT_TYPE,
		MS.SCRIP_CD,
		SUB_RED_FLAG,
		CONVERT(VARCHAR,ORDER_DATE,112),
		CONTRACTNO,S.SCHEME_NAME,
		MS.ORDER_NO,
		MS.ISIN, DIV_REINVEST_FLAG, FOLIONO	
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		S.SCHEME_NAME,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_BILL_JM
-- --------------------------------------------------


CREATE   PROC [dbo].[RPT_MFSS_BILL_JM]
	(
		@FROMDATE VARCHAR(11),
		@TODATE VARCHAR(11),
		@FROMPARTY VARCHAR(15),
		@TOPARTY VARCHAR(15),
		@FROMBRANCH VARCHAR(15),
		@TOBRANCH VARCHAR(15),
		@FROMSUBBROKER VARCHAR(15),
		@TOSUBBROKER VARCHAR(15),
		@STATUSID VARCHAR(15),
		@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'ZZZZZZZZZZ'
	END


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME=LEFT(CONVERT(VARCHAR(12), ORDER_TIME, 114),8),
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		MS.ORDER_NO,
		MS.ISIN,
		MS.SCRIP_CD,
		SEC_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'PURCHASE' ELSE 'REDEEM' END),
		CR_AMOUNT = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(AMOUNT) ELSE 0 END),
		DR_AMOUNT = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(AMOUNT) ELSE 0 END),
		BROKERAGE = SUM(BROKERAGE),
		SERVICE_TAX = SUM(SERVICE_TAX),
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY = SUM(QTY),
		NETAMOUNT = SUM(
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (BROKERAGE - SERVICE_TAX)
		END),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		BILLNO = CONTRACTNO,
		FOLIONO		
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND S.SERIES = MS.SERIES
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	GROUP BY	
		MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		OFFICE_PHONE,
		RES_PHONE, 
		EMAIL_ID,
		PAN_NO,
		CONVERT(VARCHAR,ORDER_DATE,103),
		LEFT(CONVERT(VARCHAR(12), ORDER_TIME, 114),8),
		MS.SETT_NO,
		MS.SETT_TYPE,
		MS.SCRIP_CD,
		S.SERIES,
		SUB_RED_FLAG,
		CONVERT(VARCHAR,ORDER_DATE,112),
		CONTRACTNO,SEC_NAME,
		MS.ORDER_NO,
		MS.ISIN,
		FOLIONO	
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		MS.SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_CONFIRMATION
-- --------------------------------------------------
CREATE   PROC [dbo].[RPT_MFSS_CONFIRMATION]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END



	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),	
		CONTRACTNO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		S.SCRIP_CD,
		SEC_NAME = S.SCHEME_NAME + DBO.FN_SERIES_NAME(S.DIV_REINVEST_FLAG) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'Pur.' ELSE 'Redm.' END),
		AMOUNT,
		BROKERAGE,
		SERVICE_TAX,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY = QTY,
		NETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (AMOUNT - BROKERAGE - SERVICE_TAX)
		END),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		FOLIONO
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		CONTRACTNO,
		ORDER_NO,
		S.SCHEME_NAME,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_CONTRACT
-- --------------------------------------------------
CREATE   PROC [dbo].[RPT_MFSS_CONTRACT]
	(
		@FROMDATE VARCHAR(11),
		@TODATE VARCHAR(11),
		@SETT_TYPE VARCHAR(2),
		@FROMPARTY VARCHAR(15),
		@TOPARTY VARCHAR(15),
		@FROMBRANCH VARCHAR(15),
		@TOBRANCH VARCHAR(15),
		@FROMSUBBROKER VARCHAR(15),
		@TOSUBBROKER VARCHAR(15),
		@STATUSID VARCHAR(15),
		@STATUSNAME VARCHAR(25)
	)
	
	AS
---EXEC RPT_MFSS_CONTRACT 'Aug 27 2008','Aug 27 2010','U','0','ZZZ','','zzzzzzzzzz','','zzzzzzzzzz','broker','broker'
---EXEC RPT_MFSS_CONTRACT 'Aug 27 2009','Aug 27 2010','00','zzz','','','','','broker','broker'

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'ZZZZZZZZZZ'
	END


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END),
		MOBILE_NO, 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME=RIGHT(ORDER_TIME,8),
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		MS.ORDER_NO,
		MS.ISIN,
		MS.SCRIP_CD,
		SEC_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'PURCHASE' ELSE 'REDEEM' END),
		RATE  = (CASE WHEN SUM(QTY)> 0 THEN  SUM(AMOUNT)/SUM(QTY) ELSE 0 END),
		PRATE = (CASE WHEN SUB_RED_FLAG = 'P' AND SUM(QTY)> 0 THEN SUM(AMOUNT)/SUM(QTY) ELSE 0 END),
        SRATE = (CASE WHEN SUB_RED_FLAG <> 'P' AND SUM(QTY)> 0  THEN SUM(AMOUNT)/SUM(QTY) ELSE 0 END),
		
		AMOUNT   = SUM(AMOUNT),
		PAMOUNT  = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(AMOUNT) ELSE 0 END),
		SAMOUNT  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(AMOUNT) ELSE 0 END),
		
		BROKERAGE = SUM(BROKERAGE),
		PBROKERAGE  = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(BROKERAGE) ELSE 0 END),
		SBROKERAGE  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(BROKERAGE) ELSE 0 END),
		
		INS_CHRG=SUM(INS_CHRG),
		PINS_CHRG  = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(INS_CHRG) ELSE 0 END),
		SINS_CHRG  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(INS_CHRG) ELSE 0 END),
		
		TURN_TAX=SUM(TURN_TAX),
		OTHER_CHRG=SUM(OTHER_CHRG),
		SEBI_TAX=SUM(SEBI_TAX),
		BROKER_CHRG=SUM(BROKER_CHRG),
		
		SERVICE_TAX = SUM(SERVICE_TAX),
		PSERVICE_TAX  = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(SERVICE_TAX) ELSE 0 END),
		SSERVICE_TAX  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(SERVICE_TAX) ELSE 0 END),

		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		
		QTY = SUM(QTY),
		PQTY  = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(QTY) ELSE 0 END),
		SQTY  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(QTY) ELSE 0 END),
		
		DQTY =0,
		DPQTY  =0,
		DSQTY  =0,
		
		NETAMOUNT = SUM(
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (BROKERAGE - SERVICE_TAX)
		END),
		PNETAMOUNT=SUM(
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE 0
		END),
		SNETAMOUNT=SUM(
		CASE WHEN SUB_RED_FLAG <> 'P' 
			THEN (BROKERAGE - SERVICE_TAX)
			ELSE 0
		END),

		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		CONTRACTNO,
		BILLNO = CONTRACTNO,
		FOLIONO,
		BRANCH_CD,
		SUB_BROKER,
		TRADER

	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND MS.SETT_TYPE = @SETT_TYPE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND S.SERIES = MS.SERIES
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	GROUP BY
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		OFFICE_PHONE,
		RES_PHONE, 
		MOBILE_NO,
		EMAIL_ID,
		PAN_NO,
		CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME,
		MS.SETT_NO,
		MS.SETT_TYPE,
		MS.SCRIP_CD,
		S.SERIES,
		SUB_RED_FLAG,
		CONVERT(VARCHAR,ORDER_DATE,112),
		CONTRACTNO,SEC_NAME,
		MS.ORDER_NO,
		MS.ISIN,
		FOLIONO	
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		MS.SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_DFDSREPORT
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_MFSS_DFDSREPORT]
(
	@STATUSID	VARCHAR(20),
	@STATUSNAME	VARCHAR(30),
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2)
)
AS

SELECT SETT_NO,SETT_TYPE,S.PARTY_CODE,PARTY_NAME,
SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,
QTY,S.DPID,S.CLTDPID,TRANSNO 
FROM MFSS_DFDS S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
WHERE S.SETT_NO = @SETT_NO
AND S.SETT_TYPE = @SETT_TYPE
AND S.PARTY_CODE = C.PARTY_CODE
AND S.SCRIP_CD = M.SCRIP_CD
AND S.SERIES = M.SERIES
AND @STATUSNAME =             
				  (CASE             
						WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
						WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
						WHEN @STATUSID = 'TRADER' THEN C.TRADER            
						WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
						WHEN @STATUSID = 'AREA' THEN C.AREA            
						WHEN @STATUSID = 'REGION' THEN C.REGION            
						WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
				  ELSE             
						'BROKER'            
				  END)
ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_FUND_OBL_MATCH
-- --------------------------------------------------
    
CREATE PROC RPT_MFSS_FUND_OBL_MATCH    
(    
 @STATUSID VARCHAR(20),    
 @STATUSNAME VARCHAR(30),    
 @SETT_NO VARCHAR(7),    
 @SETT_TYPE VARCHAR(2)    
)    
AS    
SELECT S.PARTY_CODE, C.PARTY_NAME, ORDER_DATE = CONVERT(VARCHAR,S.ORDER_DATE,103),     
S.ORDER_NO, S.SCRIP_CD, SEC_NAME = M.AMC_NAME ,--+ DBO.FN_SERIES_NAME(M.DIV_REINVEST_FLAG),    
S.ISIN, S.AMOUNT, EX_AMOUNT = ISNULL(O.AMOUNT, 0)    
FROM MFSS_CLIENT C, MFSS_SCRIP_MASTER M, MFSS_SETTLEMENT S    
FULL OUTER JOIN MFSS_FUNDS_OBLIGATION O    
ON     
 (    
  S.SETT_NO = O.SETT_NO AND S.SETT_TYPE = O.SETT_TYPE    
  AND S.PARTY_CODE = O.PARTY_CODE AND S.SCRIP_CD = O.SCRIP_CD AND S.SCRIP_CD = O.SCRIP_CD    
  AND S.ORDER_NO = O.ORDER_NO    
 )    
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE    
AND S.PARTY_CODE = C.PARTY_CODE    
AND SUB_RED_FLAG = 'P'    
AND S.SCRIP_CD = M.SCRIP_CD    
AND @STATUSNAME =                 
                  (CASE                 
                        WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD                
                        WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER                
                        WHEN @STATUSID = 'TRADER' THEN C.TRADER                
                        WHEN @STATUSID = 'FAMILY' THEN C.FAMILY                
                        WHEN @STATUSID = 'AREA' THEN C.AREA                
                        WHEN @STATUSID = 'REGION' THEN C.REGION                
                        WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE                
                  ELSE                 
                        'BROKER'                
                  END)    
ORDER BY PARTY_CODE,  S.SCRIP_CD

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_NAVDATA
-- --------------------------------------------------
  
CREATE PROC RPT_MFSS_NAVDATA  
(  
 @NAV_DATE VARCHAR(11)  
)  
AS  
SELECT NAV_DATE = CONVERT(VARCHAR,NAV_DATE,103), SCRIP_CD,
SCHEME_NAME = SCHEME_NAME + DBO.FN_SERIES_NAME(DIV_REINVEST_FLAG),
RTA_SCHEME_CODE, RTA_CODE, ISIN, NAV_VALUE  
FROM MFSS_NAV  
WHERE NAV_DATE = @NAV_DATE + ' 23:59:59'  
ORDER BY 3, 1, 2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_ORDERCONFIRMATION
-- --------------------------------------------------

--EXEC [RPT_MFSS_ORDERCONFIRMATION] 'JAN  1 2000','DEC 31 2011','','ZZZZZZZZ','','ZZZZZZZZ','','ZZZZZZZZ','BROKER','BROKER'

CREATE  PROC [dbo].[RPT_MFSS_ORDERCONFIRMATION]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25),
	@RPT_TYPE INT = 1
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT 
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME = MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),	
		BILLNO = CONTRACTNO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		SCRIP_CD = MS.SCRIP_CD,
		SCRIP_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES),
		SELL_BUY = SUB_RED_FLAG,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY,
		PQTY  = (CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),
		SQTY  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),
		RATE  = (CASE WHEN (QTY)> 0 THEN  (AMOUNT)/(QTY) ELSE 0 END),
		PRATE = (CASE WHEN SUB_RED_FLAG = 'P' AND (QTY)> 0 THEN (AMOUNT)/(QTY) ELSE 0 END),
		SRATE = (CASE WHEN SUB_RED_FLAG <> 'P' AND (QTY)> 0  THEN (AMOUNT)/(QTY) ELSE 0 END),
		AMOUNT,
		PAMOUNT  = (CASE WHEN SUB_RED_FLAG = 'P' THEN (AMOUNT) ELSE 0 END),
		SAMOUNT  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN (AMOUNT) ELSE 0 END),
		BROKERAGE,
		PBROKERAGE  = (CASE WHEN SUB_RED_FLAG = 'P' THEN (BROKERAGE) ELSE 0 END),
		SBROKERAGE  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN (BROKERAGE) ELSE 0 END),
		INS_CHRG,
		TURN_TAX,
		OTHER_CHRG,
		SEBI_TAX,
		BROKER_CHRG,
		SERVICE_TAX,
		NETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE)
			ELSE (AMOUNT - BROKERAGE)
		END),
		PNETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE)
			ELSE 0
		END),
		SNETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN 0
			ELSE (AMOUNT - BROKERAGE)
		END),
		FOLIONO			
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		CONTRACTNO,
		ORDER_NO,
		SEC_NAME,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_STATUSREPORT
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_MFSS_STATUSREPORT]  
 (  
 @STATUSID VARCHAR(20),  
 @STATUSNAME VARCHAR(30),  
 @FROMSETT_NO VARCHAR(7),  
 @TOSETT_NO VARCHAR(7),  
 @FROMPARTY VARCHAR(15),  
 @TOPARTY VARCHAR(15),  
 @SETT_TYPE VARCHAR(2),  
 @STATUS     VARCHAR(2)  
 )  
   
 AS  
  
 IF @TOSETT_NO = ''  
 BEGIN  
  SET @TOSETT_NO = '9999999'  
 END  
  
 IF @TOPARTY = ''  
 BEGIN  
  SET @TOPARTY = 'zzzzzzzzzz'  
 END  
  
 IF @STATUS = 'AC'   
 BEGIN  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE,   
  S.PARTY_CODE, C.PARTY_NAME,   
  ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),   
  SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,   
  APPLN_NO, DP_FOLIO = (CASE WHEN S.CLTDPID = '' THEN CONVERT(VARCHAR,FOLIONO) ELSE RIGHT(S.DP_ID+S.CLTDPID,16) END),   
  ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = QTY_ALLOTED, ALLOT_AMT = AMOUNT_ALLOTED, NAV_VALUE_ALLOTED,  
  REMARK = ''  
  FROM MFSS_ORDER_ALLOT_CONF S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C  
  WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO  
  AND S.SETT_TYPE = @SETT_TYPE  
  AND S.PARTY_CODE = C.PARTY_CODE  
  AND S.SCRIP_CD = M.SCRIP_CD  
  AND S.SERIES = M.SERIES  
  AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND @STATUSNAME =               
     (CASE               
    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD              
    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER              
    WHEN @STATUSID = 'TRADER' THEN C.TRADER              
    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY              
    WHEN @STATUSID = 'AREA' THEN C.AREA              
    WHEN @STATUSID = 'REGION' THEN C.REGION              
    WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE              
     ELSE               
    'BROKER'              
     END)  
  ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES  
 END  
   
   
 IF @STATUS = 'AR'   
 BEGIN  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE,   
  S.PARTY_CODE, C.PARTY_NAME,   
  ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),   
  SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,   
  APPLN_NO, DP_FOLIO = '-',   
  ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = 0, ALLOT_AMT = 0, NAV_VALUE_ALLOTED=0,  
  REMARK = REJECT_REASON  
  FROM MFSS_ORDER_ALLOT_REJ S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C  
  WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO  
  AND S.SETT_TYPE = @SETT_TYPE  
  AND S.PARTY_CODE = C.PARTY_CODE  
  AND S.SCRIP_CD = M.SCRIP_CD  
  AND S.SERIES = M.SERIES  
  AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND @STATUSNAME =               
     (CASE               
    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD              
    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER              
    WHEN @STATUSID = 'TRADER' THEN C.TRADER              
    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY              
    WHEN @STATUSID = 'AREA' THEN C.AREA              
    WHEN @STATUSID = 'REGION' THEN C.REGION              
    WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE              
     ELSE               
    'BROKER'              
     END)  
  ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES  
 END  
   
   
 IF @STATUS = 'RC'   
 BEGIN  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE,   
  S.PARTY_CODE, C.PARTY_NAME,   
  ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),   
  SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,   
  APPLN_NO, DP_FOLIO = (CASE WHEN S.BANK_AC_NO = '' THEN CONVERT(VARCHAR,FOLIONO) ELSE S.BANK_NAME +'-'+BANK_AC_NO END),   
  ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = QTY_ALLOTED, ALLOT_AMT = AMOUNT_ALLOTED, NAV_VALUE_ALLOTED,  
  REMARK = ''  
  FROM MFSS_ORDER_REDEM_CONF S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C  
  WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO  
  AND S.SETT_TYPE = @SETT_TYPE  
  AND S.PARTY_CODE = C.PARTY_CODE  
  AND S.SCRIP_CD = M.SCRIP_CD  
  AND S.SERIES = M.SERIES  
  AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND @STATUSNAME =               
     (CASE               
    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD              
    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER              
    WHEN @STATUSID = 'TRADER' THEN C.TRADER              
    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY              
    WHEN @STATUSID = 'AREA' THEN C.AREA              
    WHEN @STATUSID = 'REGION' THEN C.REGION              
    WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE              
     ELSE               
    'BROKER'              
     END)  
  ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES  
 END  
   
   
 IF @STATUS = 'RR'   
 BEGIN  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE,   
  S.PARTY_CODE, C.PARTY_NAME,   
  ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),   
  SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,   
  APPLN_NO, DP_FOLIO = '-',   
  ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = 0, ALLOT_AMT = 0, NAV_VALUE_ALLOTED=0,  
  REMARK = REJECT_REASON  
  FROM MFSS_ORDER_REDEM_REJ S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C  
  WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO  
  AND S.SETT_TYPE = @SETT_TYPE  
  AND S.PARTY_CODE = C.PARTY_CODE  
  AND S.SCRIP_CD = M.SCRIP_CD  
  AND S.SERIES = M.SERIES  
  AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
  AND @STATUSNAME =               
     (CASE               
    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD              
    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER              
    WHEN @STATUSID = 'TRADER' THEN C.TRADER              
    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY              
    WHEN @STATUSID = 'AREA' THEN C.AREA              
    WHEN @STATUSID = 'REGION' THEN C.REGION              
    WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE              
     ELSE               
    'BROKER'              
     END)  
  ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_TRADEBOOK
-- --------------------------------------------------
CREATE   PROC [dbo].[RPT_MFSS_TRADEBOOK]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@CONF_FLAG VARCHAR(10),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
				END), 
		EMAIL_ID = MC.EMAIL_ID,
		PAN_NO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = SM.SETT_TYPE,
		SELL_BUY = (CASE 
				WHEN SUB_RED_FLAG = 'P' THEN 'Purchase' 
				ELSE 'Redeem' 
				END),
		ALLOTMENT_MODE,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),
		S.SCRIP_CD,
		SERIES=S.SCHEME_NAME + DBO.FN_SERIES_NAME(S.DIV_REINVEST_FLAG),
		QTY,
		AMOUNT,
		CONF_FLAG,
		REJECT_REASON,
		NAV_VALUE_ALLOTED,
		AMOUNT_ALLOTED,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		FOLIONO
	FROM
		MFSS_ORDER MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND MS.SETT_NO = SM.SETT_NO
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND CONF_FLAG BETWEEN @CONF_FLAG AND @CONF_FLAG
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		ORDER_NO,
		SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelAllClientList
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NSEDelAllClientList] (          
@StatusId Varchar(15),@StatusName Varchar(25),@SCRIP_CD Varchar(12), @Series Varchar(3))          
as           
Set Transaction Isolation level read uncommitted          
       
select distinct d.PARTY_CODE, LONG_NAME,      
Qty=0      
from DeliveryClt D, Client2 C2, Client1 C1          
where D.SCRIP_CD = @SCRIP_CD      
and d.series = @Series      
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code       
And @StatusName =       
   (case       
         when @StatusId = 'BRANCH' then c1.branch_cd      
         when @StatusId = 'SUBBROKER' then c1.sub_broker      
         when @StatusId = 'Trader' then c1.Trader      
         when @StatusId = 'Family' then c1.Family      
         when @StatusId = 'Area' then c1.Area      
         when @StatusId = 'Region' then c1.Region      
         when @StatusId = 'Client' then c2.party_code      
   else       
         'BROKER'      
   End)              
order by d.PARTY_CODE, LONG_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelAllScripList
-- --------------------------------------------------
  
CREATE Proc [dbo].[Rpt_NSEDelAllScripList] (        
@StatusId Varchar(15),@StatusName Varchar(25),@Party_Code Varchar(10))        
as  
Set Transaction Isolation level read uncommitted        
     
select distinct d.scrip_cd,d.series,    
Qty=0    
from DeliveryClt D, Client2 C2, Client1 C1        
where D.Party_Code = @Party_Code        
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code     
And @StatusName =     
   (case     
         when @StatusId = 'BRANCH' then c1.branch_cd    
         when @StatusId = 'SUBBROKER' then c1.sub_broker    
         when @StatusId = 'Trader' then c1.Trader    
         when @StatusId = 'Family' then c1.Family    
         when @StatusId = 'Area' then c1.Area    
         when @StatusId = 'Region' then c1.Region    
         when @StatusId = 'Client' then c2.party_code    
   else     
         'BROKER'    
   End)        
Group by d.scrip_cd,d.series 
order by d.scrip_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelCertinfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[rpt_NSEDelCertinfo]      
@targetid varchar(2),      
@settno varchar(7),      
@settype varchar(3),      
@scripcd varchar(20),      
@series varchar(3),      
@partycode varchar(20)      
AS    

if @targetid = 1      
begin      
	select Sett_no,Sett_Type,Party_Code,d.Scrip_cd,d.Series,scheme_name=sec_name,
	Qty,TransDate,CertNo,HolderName,FolioNo,TrType,Reason,CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type      
	from DelTrans d (nolock), mfss_scrip_master m where sett_no = @SettNo and sett_type = @Settype      
	and d.scrip_cd = @scripcd and d.series = @series and DrCr = 'C'       
	and party_code = @partycode and filler2 = 1  and d.scrip_cd = m.scrip_cd and d.series = m.series    
end      
if @targetid = 2      
begin      
	select Sett_no,Sett_Type,Party_Code,d.Scrip_cd,d.Series,scheme_name=sec_name,
	Qty,TransDate,CertNo,HolderName,FolioNo,TrType,      
	Reason=(case When TrType = 909 Then 'DEMAT' Else Reason End),CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type      
	from DelTrans d (nolock), mfss_scrip_master m where sett_no = @SettNo and sett_type = @Settype      
	and d.scrip_cd = @scripcd and d.series = @series and DrCr = 'D'       
	and party_code = @partycode and filler2 = 1 and d.scrip_cd = m.scrip_cd and d.series = m.series      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelClientList
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NSEDelClientList] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )    
as     
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2      
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code     
 and d.sett_no like @settno and d.sett_type like @Sett_Type   
 and d.party_code like @Party_Code + '%'    
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)   
 order by c1.short_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelClientScrips
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[rpt_NSEDelClientScrips]      
@StatusId Varchar(15),@StatusName Varchar(25),      
@dematid varchar(2),      
@settno varchar(7),      
@settype varchar(3),      
@partycode varchar(20)      
AS  
Set Transaction Isolation level read uncommitted      
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,     
/*RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),      
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))*/      
RecQty = (Case When D.Sett_Type ='W' Then       
   (Case When InOut ='I' Then Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)      
   Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End),      
GivenQty = (Case When D.Sett_Type ='W' Then       
   (Case When InOut ='O' Then Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)      
   Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) End)      
from client1 c1,client2 c2, deliveryclt d Left Outer Join DelTrans De      
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )       
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code      
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode   
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)      
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
--Union All      
--select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,      
--RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),      
--GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))      
--from client1 c1,client2 c2,DelTrans D      
--where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code      
--and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1      
--And d.Party_code Not In ( Select Party_Code From DeliveryClt De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
--And De.Party_Code = D.Party_Code And De.Series = D.Series )   
--And @StatusName =   
--   (case   
--         when @StatusId = 'BRANCH' then c1.branch_cd  
--         when @StatusId = 'SUBBROKER' then c1.sub_broker  
--         when @StatusId = 'Trader' then c1.Trader  
--         when @StatusId = 'Family' then c1.Family  
--         when @StatusId = 'Area' then c1.Area  
--         when @StatusId = 'Region' then c1.Region  
--         when @StatusId = 'Client' then c2.party_code  
--   else   
--         'BROKER'  
--   End)       
--group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code      
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelClientSettScrip_new
-- --------------------------------------------------
CREATE PROCEDURE  [dbo].[rpt_NSEDelClientSettScrip_new]  
@scripcd varchar(20),      
@series varchar(3),      
@partycode varchar(10)      
AS      
Set Transaction Isolation level read uncommitted      
  
  
  
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,  
d.BUYQty, D.SELLQTY,       
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),      
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)),      
Demat_Date = 'Jan 30 2079'      
from client1 c1,client2 c2, (select sett_no, sett_type, party_code, scrip_cd, series,  
BuyQty = SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END),  
SELLQty = SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)  
FROM DELIVERYCLT  
GROUP BY sett_no, sett_type, party_code, scrip_cd, series) D   
Left Outer Join DelTrans De      
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )       
where d.party_code = c2.party_code and c1.cl_code =c2.cl_code      
and d.party_code = @partycode And d.scrip_cd = @scripcd and d.series = @series      
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,D.BUYQty, SELLQTY      
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelConsolidated
-- --------------------------------------------------
-- CREATED BY SANTOSH  
-- EXEC RPT_NSEDELCONSOLIDATED 'N', '2006030'  
CREATE PROC [dbo].[Rpt_NSEDelConsolidated]  
(  
 @SETT_TYPE VARCHAR(2),  
 @SETT_NO VARCHAR(7)  
)  
AS   
BEGIN  
  SELECT D.SCRIP_CD, D.SERIES, D.QTY, D.INOUT,   
  CQTY = SUM((CASE WHEN C.INOUT <> D.INOUT THEN ISNULL(C.QTY,0) ELSE 0 END)),  
        GQTY = ISNULL(D.QTY + SUM((CASE WHEN C.INOUT <> D.INOUT THEN ISNULL(C.QTY,0) ELSE 0 END)),0),  
        SQTY = ISNULL((SELECT ISNULL(SUM(ISNULL(QTY,0)),0) FROM DELTRANS WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
            AND SCRIP_CD = D.SCRIP_CD AND SERIES = D.SERIES AND FILLER2 = 1 AND DRCR = 'C' AND TRTYPE <> '906')  
                                                  - (SELECT ISNULL(SUM(ISNULL(QTY,0)),0) FROM DELTRANS WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
            AND SCRIP_CD = D.SCRIP_CD AND SERIES = D.SERIES AND FILLER2 = 1 AND DRCR = 'D' AND TRTYPE <> '906')  
                       ,0),  
        SHORTAGE = D.QTY - ABS(ISNULL((SELECT ISNULL(SUM(ISNULL(QTY,0)),0) FROM DELTRANS WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
            AND SCRIP_CD = D.SCRIP_CD AND SERIES = D.SERIES AND FILLER2 = 1 AND DRCR = 'C' AND TRTYPE <> '906')  
                                                  - (SELECT ISNULL(SUM(ISNULL(QTY,0)),0) FROM DELTRANS WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
            AND SCRIP_CD = D.SCRIP_CD AND SERIES = D.SERIES AND FILLER2 = 1 AND DRCR = 'D' AND TRTYPE <> '906')  
                       ,0))  
    
  FROM DELIVERYCLT C, DELNET D   
  WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE  
  AND C.SETT_NO = D.SETT_NO AND   
  C.SETT_TYPE = D.SETT_TYPE AND C.SCRIP_CD = D.SCRIP_CD  
  GROUP BY D.SCRIP_CD, D.SERIES, D.QTY, D.INOUT   
  ORDER BY D.SCRIP_CD,D.SERIES  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelDematCltIdSearch
-- --------------------------------------------------
--Created by Santosh on 15th Sept.2010  
-- Exec Rpt_NSEDelDematCltIdSearch 'broker','broker','HOC0000001','12010402','1201040200005621','ALL'  
CREATE proc [dbo].[Rpt_NSEDelDematCltIdSearch]  
(  
 @StatusId varchar(10),  
 @statusname varchar(20),  
 @Party_code varchar(12),  
 @DpId varchar(8),  
 @CltDpId varchar(16),  
 @Status varchar(10)  
   
)  
as   
Declare @@ssql varchar(8000)  
Begin  
  If @Status <> 'PAYOUT'  
  Begin  
   Set @@ssql='select M.Party_code,Introducer=M.PARTY_NAME,DpId,CltDpNo=M.CltDpID,DPTYPE=M.Dp_Type,  
      Def=(Case When POAFLAG = ''YES'' Then ''Received'' Else ''Not Received'' End),  
   ACType=''Pay_In'' from MFSS_DPMASTER M, Client2 C2, Client1 C1   
   where C1.Cl_Code = C2.Cl_Code And M.Party_Code = C2.Party_Code   
   And M.Party_code like '''+ @Party_code +'%'' and DpId like  '''+ @DpId +'%'' and M.CltDpID like '''+ @CltDpId +'%'' '  
     
   If @StatusId = 'branch'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.branch_cd = @statusname'  
   End  
   If @StatusId = 'subbroker'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.sub_broker = @statusname'  
   End  
   If @StatusId = 'trader'  
   Begin   
    Set @@ssql=@@ssql + ' And C1.trader = @statusname'  
   End  
   If @StatusId = 'family'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.family = @statusname'  
   End  
   If @StatusId = 'area'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.area = @statusname'   
   End  
   If @StatusId = 'region'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.region = @statusname '  
   End  
   If @StatusId = 'client'  
   Begin   
    Set @@ssql=@@ssql + ' And C2.Party_Code = @statusname'   
   End  
   if @Status = 'POA'   
   Begin  
    Set @@ssql=@@ssql + ' And Def = ''1'''  
   End  
   if @Status = 'NONPOA'  
   Begin  
    Set @@ssql=@@ssql + ' And Def = ''0'''  
   end  
  End  
   
  
 If @Status = 'ALL'  
 Begin  
  Set @@ssql=@@ssql + ' UNION ALL'  
 End  
 If @Status = 'ALL' Or @Status = 'PAYOUT'  
 Begin   
  Set @@ssql=@@ssql + ' select C2.Party_code,Introducer=Long_Name,DpId=C4.DPID,CltDpNo=C4.CltDpId,  
  DpType=DP_TYPE, Def=(Case When DEFAULTDP = 1 Then ''Default'' Else ''-'' End),ACType=''Pay_Out''   
  from Client2 C2,MFSS_DPMASTER C4, Client1 C1   
  where c1.cl_code = c2.cl_code and C2.party_Code = C4.party_Code And C2.Party_code like '''+@Party_code+'%''   
  and C4.DPID like '''+@DpId+'%'' and C4.CltDpId like '''+ @CltDpId+'%'' And DP_TYPE in (''NSDL'',''CDSL'' )   
  And C4.DPID <> '''' '  
  If @StatusId = 'branch'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.branch_cd = @statusname'  
  End  
  If @StatusId = 'subbroker'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.sub_broker = @statusname'  
  End  
  If @StatusId = 'trader'  
  Begin   
   Set @@ssql=@@ssql + ' And C1.trader = @statusname'  
  End  
  If @StatusId = 'family'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.family = @statusname'  
  End  
  If @StatusId = 'area'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.area = @statusname '  
  End  
  If @StatusId = 'region'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.region = @statusname '  
  End  
  If @StatusId = 'client'  
  Begin   
   Set @@ssql=@@ssql + ' And C2.Party_Code = @statusname '  
  End  
 End  
 Set @@ssql=@@ssql + ' order by 1'  
--print(@@ssql)  
Exec(@@ssql)  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELDEMATISINSEARCH
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_NSEDELDEMATISINSEARCH]  
(  
 @SCRIP_CD VARCHAR(30),  
 @ISIN VARCHAR(12)  
)  
AS   
BEGIN  
  SELECT SCHEME_NAME=SEC_NAME, SCRIP_CD = M.SCRIP_CD + '-' + SERIES, M.ISIN, VALID='CURRENT'  
  FROM MFSS_SCRIP_MASTER M  WHERE M.SCRIP_CD LIKE @SCRIP_CD+'%' AND M.ISIN LIKE @ISIN+'%'   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelDematThirdParty
-- --------------------------------------------------

CREATE proc [dbo].[Rpt_NSEDelDematThirdParty]  
(  
 @sett_type varchar(2),  
 @sett_No varchar(7),  
 @fdate varchar(12),  
 @tdate varchar(12),  
 @partycode varchar(15),  
 @scrip varchar(50)  
)  
as   
set @tdate=@tdate + ' 23:59:59'  
begin  
 select sett_no,sett_type,party_code,scrip_cd=isnull(scrip_cd,''),
 series=isnull(series,''),isin,dpid,DpName,qty, CltAccno,transno,TrDate=Convert(Varchar,TrDate,103),  
 branch_cd,partipantcode,TrType,BDpId,BCltAccNo,dptype,sno   
 from demattrans where   
 sett_no=@sett_No  and sett_type= @sett_type  and DrCr = 'C'   
 And  TrDate >=  @fdate    
 and Trdate <=  @tdate   
 and Party_Code = @partycode     
 and isnull(Scrip_CD,'') like @scrip + '%'   
 order by scrip_cd,series,party_code,cltaccno Asc  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelDematTransNoSearch
-- --------------------------------------------------
CREATE PROC [dbo].[Rpt_NSEDelDematTransNoSearch]
(
	@TRANSNO VARCHAR(10)
)
AS 
BEGIN
		SELECT TRANSNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES,SCHEME_NAME=ISNULL(SEC_NAME,'N/A'),QTY,TRDATE=CONVERT(VARCHAR,TRDATE,103),
		CLTACCNO,DPID,D.ISIN FROM DEMATTRANS D LEFT OUTER JOIN MFSS_SCRIP_MASTER M
		ON (D.SCRIP_CD = M.SCRIP_CD)
		WHERE TRANSNO LIKE @TRANSNO+'%' 
		UNION ALL
		SELECT TRANSNO=FROMNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES,SEC_NAME AS SCHEME_NAME,QTY,TRDATE=CONVERT(VARCHAR,TRANSDATE,103),
		CLTACCNO=CLTDPID,DPID,ISIN=CERTNO FROM DELTRANS D, MFSS_SCRIP_MASTER M
		WHERE FROMNO LIKE @TRANSNO+'%' AND FILLER2 = 1 AND DRCR = 'C' 
		AND (D.SCRIP_CD = M.SCRIP_CD)
		ORDER BY TRANSNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelExeReport
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelExeReport]     
(@TDate Varchar(11),    
 @BDpId Varchar(8),    
 @BCltDpId Varchar(16),    
 @FParty Varchar(10),    
 @TParty Varchar(10),    
 @FScrip Varchar(12),    
 @TScrip Varchar(12)    
) As    
/* Pool To Client Trans */    
Set Transaction Isolation level read uncommitted    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME, Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M   
Where DrCr = 'D' And Delivered = 'D'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip  
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES   
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
And D.SNo in ( Select Sno From DelTransTemp Where BDpId = @BDpId And BCltDpId = @BCltDpId and CONVERT(VARCHAR,TransDate,103) = @TDate )     
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Pool To Pool InterSett */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Inter Sett'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered in ('G','D')    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 907    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES 
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Pool To Ben Trans */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'     
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%'    
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD  AND M.SERIES = D.SERIES
And TCode in (Select TCode From DelTrans Where DrCr = 'D'     
And BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code     
And d.SCRIP_CD = SCRIP_CD AND D.SERIES = SERIES)    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'     
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Like '%POOL%'    
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD  
And D.Sno in (Select Sno From DelTransTemp Where BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code     
And d.SCRIP_CD = SCRIP_CD and CONVERT(VARCHAR,TransDate,103) = @TDate  )    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type    
Union All    
/* Ben To Client Trans */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'D'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Not Like '%POOL%' And Filler2 = 1    
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Not Like '%POOL%' And Filler2 = 1    
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
And D.Sno In ( Select SNo From DelTransTemp Where DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId and CONVERT(VARCHAR,TransDate,103) = @TDate )    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Ben To Pool InterSett */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Pool'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered in ('G','D')    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 1000    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Not Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES 
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Order By D.Party_Code,C1.Short_Name,SEC_NAME,d.SCRIP_CD,D.SERIES,CertNo,Remark,Sett_no,Sett_Type,ISett_No,ISett_Type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelGive
-- --------------------------------------------------
    
--exec RPT_NSEDELGIVE '3','1011186','T3'    
CREATE PROCEDURE [dbo].[rpt_NSEDelGive]                    
@DEMATID VARCHAR(2),                    
@SETT_NO VARCHAR(7),                    
@SETT_TYPE VARCHAR(3)                    
AS    
DECLARE               
@START_DATE DATETIME,              
@SEC_PAYIN DATETIME              
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
            
SELECT *             
INTO #DEL FROM DELTRANS                
WHERE SETT_NO = @SETT_NO                
AND SETT_TYPE = @SETT_TYPE                
AND FILLER2 = 1                 
AND TRTYPE = 906                
AND CERTNO <> 'AUCTION'                
            
SELECT SETT_NO, SETT_TYPE, SCRIP_CD, SERIES = SCHEME_NAME,SERIES_TEST = SERIES,    
BUYQTY = SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END),            
SELLQTY = SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)            
INTO #DELNET FROM DELNET              
WHERE SETT_NO = @SETT_NO              
AND SETT_TYPE = @SETT_TYPE              
--AND INOUT = 'O'              
GROUP BY SETT_NO, SETT_TYPE, SCRIP_CD, SERIES,SCHEME_NAME           
            
SELECT @START_DATE=MIN(START_DATE), @SEC_PAYIN=MAX(SEC_PAYIN)              
FROM SETT_MST              
WHERE SETT_NO = @SETT_NO              
AND SETT_TYPE = @SETT_TYPE                
            
SELECT D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.SERIES_TEST,           
GIVENSE=BUYQTY, RECEIVENSE=SELLQTY,                   
GIVENNSE= ISNULL(SUM(CASE WHEN DRCR = 'D' THEN DT.QTY ELSE 0 END),0),                    
RECEIVEDNSE=ISNULL(SUM(CASE WHEN DRCR = 'C' THEN DT.QTY ELSE 0 END),0),                
CL_RATE = CONVERT(NUMERIC(18,4),0)                
INTO #SHORT FROM #DELNET D LEFT OUTER JOIN #DEL DT                    
ON (DT.SETT_NO = D.SETT_NO AND DT.SETT_TYPE = D.SETT_TYPE AND                     
DT.SCRIP_CD = D.SCRIP_CD and D.SERIES_TEST = DT.SERIES AND TRTYPE = 906                     
AND FILLER2 = 1 )         
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE --AND INOUT = 'I'                     
GROUP BY D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.BUYQTY,SELLQTY,D.SERIES_TEST                   
              
SELECT * FROM #SHORT                 
ORDER BY SCRIP_CD,SERIES

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelHoldDetails
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelHoldDetails] (      
@StatusId Varchar(15),@StatusName Varchar(25),@HoldDate varchar(11),@SettNo Varchar(7),@Sett_Type Varchar(10),@Scrip_Cd Varchar(12),@Series varchar(3),@BDpID Varchar(8),@BCltDpID Varchar(16))      
AS     
Select Sett_No, Sett_type, TCode, D.Party_Code, D.scrip_cd ,     
d.series, SCHEME_NAME=sec_name, certno, Qty, TransNo=foliono, DrCr, convert(varchar(11),TransDate,106) as TransDate, Reason,CltDpId,DpID     
from DelTrans D,    
Client1 C1,Client2 C2, MFSS_SCRIP_MASTER M    
where sett_no = @settno and sett_Type = @sett_Type     
and D.scrip_cd = @scrip_Cd and d.series = @series    
and BDpId = @BDpId and BCltDpId = @BCltDpId       
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code    
And Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType In(904,905,909)    
And ShareType <> 'AUCTION'  AND M.SCRIP_CD = D.SCRIP_CD and m.series = d.series 
And @StatusName =     
   (case     
         when @StatusId = 'BRANCH' then c1.branch_cd    
         when @StatusId = 'SUBBROKER' then c1.sub_broker    
         when @StatusId = 'Trader' then c1.Trader    
         when @StatusId = 'Family' then c1.Family    
         when @StatusId = 'Area' then c1.Area    
         when @StatusId = 'Region' then c1.Region    
         when @StatusId = 'Client' then c2.party_code    
   else     
         'BROKER'    
   End)    
ORDER BY SCHEME_NAME,D.Scrip_CD,Sett_No, Sett_type, D.Party_Code, DrCr

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelHoldParty
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelHoldParty] (            
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),            
@ToParty varchar(10),@FromScrip Varchar(12),          
@ToScrip Varchar(12),@BDpID Varchar(8),          
@BCltDpID Varchar(16), @Branch Varchar(10))            
AS            
if @BDpID = ''             
Select @BDpID = '%'            
if @BCltDpID = ''             
Select @BCltDpID = '%'            
Set Transaction Isolation level read uncommitted            
select D.scrip_cd, D.series, SCHEME_NAME=sec_name, D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,            
HoldQty=(Case When @StatusId = 'broker' Then Sum(Case When P.Description NOT LIKE '%PLEDGE%' AND TrType <> 909 Then Qty Else 0 End) Else Sum(Qty) End),       
PledgeQty=(Case When @StatusId = 'broker' Then Sum(Case When P.Description LIKE '%PLEDGE%' OR TrType = 909 Then Qty Else 0 End) Else 0 End),      
Party_Name = C1.Long_Name , C1.Long_Name             
from DELTRANS D, Client1 C1, Client2 C2, DeliveryDP P, MFSS_SCRIP_MASTER M             
where BDpId Like @BDpId and BCltDpId Like @BCltDpId      
AND D.Bdpid = P.Dpid    
AND D.BCltDpId = P.Dpcltno           
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY            
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'            
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'            
And C1.Branch_Cd Like @Branch          
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code            
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)             
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)            
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)            
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)            
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)            
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)            
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)            
AND D.SCRIP_CD = M.SCRIP_CD AND D.SERIES = M.SERIES   
group by D.scrip_cd,CertNo, D.series,sec_name, D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0             
Order By D.Party_Code,sec_name,D.Scrip_CD,D.Series,Sett_No, Sett_type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELHOLDSCRIP
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_NSEDELHOLDSCRIP] (          
@STATUSID VARCHAR(15),@STATUSNAME VARCHAR(25),@FROMPARTY VARCHAR(10),          
@TOPARTY VARCHAR(10),@FROMSCRIP VARCHAR(12),@TOSCRIP VARCHAR(12),        
@BDPID VARCHAR(8),@BCLTDPID VARCHAR(16), @BRANCH VARCHAR(10))          
AS          
IF @BDPID = ''           
SELECT @BDPID = '%'          
IF @BCLTDPID = ''           
SELECT @BCLTDPID = '%'          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
SELECT D.SCRIP_CD, D.SERIES,SCHEME_NAME=sec_name,D.PARTY_CODE,C1.LONG_NAME,SETT_NO, SETT_TYPE, QTY=SUM(QTY),CERTNO,BDPID,BCLTDPID,    
HOLDQTY=(CASE WHEN @STATUSID = 'BROKER' THEN SUM(CASE WHEN TRTYPE <> 909 THEN QTY ELSE 0 END) ELSE SUM(QTY) END),     
PLEDGEQTY=(CASE WHEN @STATUSID = 'BROKER' THEN SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) ELSE 0 END)    
FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER M          
WHERE BDPID LIKE @BDPID+'%' AND BCLTDPID LIKE @BCLTDPID+'%' AND C1.CL_CODE = C2.CL_CODE AND D.PARTY_CODE = C2.PARTY_CODE          
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP AND DRCR = 'D' AND FILLER2 = 1  AND DELIVERED = '0'  AND TRTYPE <> 907           
AND D.PARTY_CODE <> 'BROKER' AND TRTYPE <> 906 AND CERTNO NOT LIKE 'AUCTION'          
AND C1.BRANCH_CD LIKE @BRANCH        
AND C1.BRANCH_CD LIKE (CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE '%' END)           
AND C1.SUB_BROKER LIKE (CASE WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME ELSE '%' END)          
AND C1.TRADER LIKE (CASE WHEN @STATUSID = 'TRADER' THEN @STATUSNAME ELSE '%' END)          
AND C1.FAMILY LIKE (CASE WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME ELSE '%' END)          
AND C1.REGION LIKE (CASE WHEN @STATUSID = 'REGION' THEN @STATUSNAME ELSE '%' END)          
AND C1.AREA LIKE (CASE WHEN @STATUSID = 'AREA' THEN @STATUSNAME ELSE '%' END)          
AND C2.PARTY_CODE LIKE (CASE WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME ELSE '%' END)     
AND D.SCRIP_CD = M.SCRIP_CD AND D.SERIES = M.SERIES
GROUP BY D.SCRIP_CD,CERTNO, D.SERIES ,sec_name,D.PARTY_CODE,C1.LONG_NAME, SETT_NO, SETT_TYPE,BDPID,BCLTDPID HAVING SUM(QTY) > 0           
ORDER BY sec_name,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,SETT_NO, SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELHOLDSUM
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_NSEDELHOLDSUM] (      
@STATUSID VARCHAR(15),@STATUSNAME VARCHAR(25),@HOLDDATE VARCHAR(11),@BDPID VARCHAR(8),@BCLTDPID VARCHAR(16))      
AS      
SELECT D.SCRIP_CD, D.SERIES, SCHEME_NAME=SEC_NAME, CERTNO ,SETT_NO, SETT_TYPE,QTY=SUM(QTY) FROM DELTRANS D,    
CLIENT1 C1,CLIENT2 C2, MFSS_SCRIP_MASTER M    
WHERE BDPID = @BDPID AND BCLTDPID = @BCLTDPID       
AND C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE    
AND FILLER2 = 1 AND DRCR = 'D' AND DELIVERED = '0' AND TRTYPE IN(904,905,909)    
AND SHARETYPE <> 'AUCTION'    
AND @STATUSNAME =     
   (CASE     
         WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD    
         WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER    
         WHEN @STATUSID = 'TRADER' THEN C1.TRADER    
         WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY    
         WHEN @STATUSID = 'AREA' THEN C1.AREA    
         WHEN @STATUSID = 'REGION' THEN C1.REGION    
         WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE    
   ELSE     
         'BROKER'    
   END)    
AND M.SCRIP_CD = D.SCRIP_CD  AND M.SERIES = D.SERIES         
GROUP BY D.SCRIP_CD, D.SERIES, SEC_NAME, CERTNO , SETT_NO, SETT_TYPE HAVING SUM(QTY) > 0       
ORDER BY SEC_NAME, D.SCRIP_CD, D.SERIES,CERTNO,SETT_NO,SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelInterBen_new
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelInterBen_new] (        
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@ISett_Type Varchar(2),@ISettNo Varchar(7), @Flag int,  
@Status Int = 1 )        
AS        
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
if @Flag = 1       
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,         
qty=sum(d.Qty),   
Delivered = (Case When Delivered = '0' Then 'No'  
      When Delivered = 'G' Then 'Yes'  
      Else 'Close' End),   
D.ISett_No,D.ISett_Type,CltDpId, HolderName from deltrans d, client1 c1, client2 c2         
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D'         
and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo And Filler2 = 1       
And @StatusName =       
                  (case       
                        when @StatusId = 'BRANCH' then c1.branch_cd      
                        when @StatusId = 'SUBBROKER' then c1.sub_broker      
                        when @StatusId = 'Trader' then c1.Trader      
                        when @StatusId = 'Family' then c1.Family      
                        when @StatusId = 'Area' then c1.Area      
                        when @StatusId = 'Region' then c1.Region      
                        when @StatusId = 'Client' then c2.party_code      
                  else       
                        'BROKER'      
                  End)   
And 1 = (Case When @Status = 1 Then 1   
     When @Status = 2 And Delivered = '0' Then 1   
     When @Status = 3 And Delivered = 'G' Then 1   
     When @Status = 4 And Delivered = 'D' Then 1   
     ELSE 2  
   End)      
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No,   
d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,         
D.ISett_No,D.ISett_Type,CltDpId,HolderName   
order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series         
Else      
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,         
qty=sum(d.Qty),   
Delivered = (Case When Delivered = '0' Then 'No'  
      When Delivered = 'G' Then 'Yes'  
      Else 'Close' End),  
D.ISett_No,D.ISett_Type, CltDpId, HolderName from deltrans d, client1 c1, client2 c2         
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D'         
and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo And Filler2 = 1       
And @StatusName =       
                  (case       
                        when @StatusId = 'BRANCH' then c1.branch_cd      
                        when @StatusId = 'SUBBROKER' then c1.sub_broker      
                        when @StatusId = 'Trader' then c1.Trader      
                        when @StatusId = 'Family' then c1.Family      
                        when @StatusId = 'Area' then c1.Area      
                        when @StatusId = 'Region' then c1.Region      
                        when @StatusId = 'Client' then c2.party_code      
                  else       
                        'BROKER'      
                  End)  
And 1 = (Case When @Status = 1 Then 1   
     When @Status = 2 And Delivered = '0' Then 1   
     When @Status = 3 And Delivered = 'G' Then 1   
     When @Status = 4 And Delivered = 'D' Then 1   
     ELSE 2  
   End)       
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,         
D.ISett_No,D.ISett_Type, CltDpId, HolderName order by d.scrip_cd, d.series, d.party_code, d.Sett_No, d.Sett_type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelInterSett
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelInterSett] (      
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@ISettNo Varchar(7),@Flag Varchar(1))      
AS      
If @Flag = 'P'       
Begin      
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,       
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)      
from deltrans d, client1 c1, client2 c2       
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D'       
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo       
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)    
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,       
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103)       
order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series,Convert(Varchar,TransDate,103)      
End      
Else      
Begin      
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,       
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)      
from deltrans d, client1 c1, client2 c2       
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D'       
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo       
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)     
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,       
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103)       
order by d.scrip_cd, d.series,d.party_code, d.Sett_No, d.Sett_type, Convert(Varchar,TransDate,103)      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelListAsc
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_NSEDelListAsc    Script Date: 12/16/2003 2:31:23 PM ******/  
  
CREATE  Proc [dbo].[Rpt_NSEDelListAsc] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )  
as   
If @statusid = 'broker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 order by D.Party_Code ASC  
End  
If @statusid = 'branch'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, branches br    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and br.short_name = c1.trader and br.branch_cd = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'subbroker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, subbrokers sb  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'trader'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.trader = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'client'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c2.party_code = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'family'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.family = @statusname  
 order by D.Party_Code ASC  
End 
If @statusid = 'area'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.area = @statusname  
 order by D.Party_Code ASC  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelListDesc
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_NSEDelListDesc    Script Date: 12/16/2003 2:31:23 PM ******/  
  
CREATE  Proc [dbo].[Rpt_NSEDelListDesc] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )  
as   
If @statusid = 'broker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 order by D.Party_Code DESC  
End  
If @statusid = 'branch'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, branches br    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and br.short_name = c1.trader and br.branch_cd = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'subbroker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, subbrokers sb  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'trader'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.trader = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'client'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c2.party_code = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'family'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.family = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'area'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.area = @statusname  
 order by D.Party_Code DESC  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelPosDirect
-- --------------------------------------------------
-- exec Rpt_NSEDelPosDirect 'N', 2006002,'45'  
--Created by Santosh (dated for Delivery Position Report)  
CREATE proc [dbo].[Rpt_NSEDelPosDirect]  
(  
 @sett_type varchar(2),  
 @sett_No varchar(7),  
 @Rptid varchar(2)  
)  
as   
declare @@ssql varchar(800)  
begin  
 set @@ssql='select Long_name,D.Party_code,D.Scrip_cd,Scripname=series,Qty=DirectpayQty,CltAcCm=Cltdpid,  
    DpId,Dptype from DirectPO d, Client2 C2, Client1 C1 Where Sett_no = ''+ @sett_No +''   
    and sett_type = ''+@sett_type+ '' And c1.cl_code = c2.cl_code and c2.party_code = d.party_code '  
   
 if ''+ @Rptid +''= '45'   
 begin  
  set @@ssql = @@ssql +'order by  D.Scrip_cd,D.Series,D.Party_code'  
 end  
 if ''+ @Rptid +''= '46'   
 begin  
  set @@ssql = @@ssql + 'order by  D.Party_code,D.Scrip_cd,D.Series'   
 end  
 if ''+ @Rptid +''= '47'   
 begin  
  set @@ssql = @@ssql + 'order by  D.Party_code,D.Scrip_cd,D.Series '  
 end  
 exec(@@ssql)  
 print(@@ssql)  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelScripList
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NSEDelScripList] (    
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Scrip_Cd Varchar(12),@Series Varchar(3))    
as     
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End)   
from DeliveryClt D, Client2 C2, Client1 C1  
where d.sett_no like @settno and d.sett_type like @Sett_Type   
and d.scrip_cd like @Scrip_Cd and d.series like @Series    
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)       
Group by d.scrip_cd,d.series order by d.scrip_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelScripWise_New
-- --------------------------------------------------
    
CREATE PROC [dbo].[Rpt_NseDelScripWise_New] (@STATUSID VARCHAR(15), @STATUSNAME VARCHAR(25),@SETT_NO VARCHAR(7), @SETT_TYPE VARCHAR(2),@PARTY_CODE VARCHAR(10),        
@SCRIP_CD VARCHAR(12), @SERIES VARCHAR(3)) AS    
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,PARTY_CODE,        
BUYQTY=SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END),        
SELLQTY=SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END),
SCHEME_NAME
INTO #DELCLT     
FROM DELIVERYCLT D    
WHERE  D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE    
AND D.PARTY_CODE LIKE @PARTY_CODE         
AND D.SCRIP_CD LIKE @SCRIP_CD         
AND D.SERIES LIKE @SERIES        
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,PARTY_CODE ,SCHEME_NAME       
    
SELECT * INTO #DELTRANS    
FROM DELTRANS D    
WHERE  D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE    
AND D.PARTY_CODE LIKE @PARTY_CODE         
AND D.SCRIP_CD LIKE @SCRIP_CD         
AND D.SERIES LIKE @SERIES      
AND FILLER2 = 1    
    
SELECT * INTO #CLIENT2    
FROM CLIENT2    
WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #DELCLT    
      UNION    
      SELECT PARTY_CODE FROM #DELTRANS)    
    
SELECT * INTO #CLIENT1    
FROM CLIENT1    
WHERE CL_CODE IN (SELECT CL_CODE FROM #CLIENT2)    
    
SELECT D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,C1.SHORT_NAME,D.SCRIP_CD,D.SERIES,SCHEME_NAME,        
BUYTRADEQTY = BUYQTY, BUYRECQTY=SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) ,        
SELLTRADEQTY = SELLQTY , SELLRECQTY=SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END) ,        
BUYSHORTAGE = (CASE WHEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) > 0         
          THEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END)        
          ELSE 0 END )         
 + (CASE WHEN (SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) < 0 THEN         
  ABS(SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) ELSE 0 END),        
SELLSHORTAGE = (CASE WHEN (SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) > 0 THEN         
  ABS(SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) ELSE 0 END) +        
  (CASE WHEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) < 0         
           THEN ABS(BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END))        
          ELSE 0 END )        
FROM #CLIENT2 C2,#CLIENT1 C1, #DELCLT D LEFT OUTER JOIN #DELTRANS DE         
ON ( DE.SETT_NO = D.SETT_NO AND DE.SETT_TYPE = D.SETT_TYPE AND DE.SCRIP_CD = D.SCRIP_CD        
AND DE.SERIES = D.SERIES AND DE.PARTY_CODE = D.PARTY_CODE AND FILLER2 = 1 )        
WHERE D.PARTY_CODE = C2.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE AND D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE        
AND C1.BRANCH_CD LIKE (CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE '%' END)        
AND C1.SUB_BROKER LIKE (CASE WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME ELSE '%' END)        
AND C1.TRADER LIKE (CASE WHEN @STATUSID = 'TRADER' THEN @STATUSNAME ELSE '%' END)        
AND C1.FAMILY LIKE (CASE WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME ELSE '%' END)        
AND D.PARTY_CODE LIKE (CASE WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME ELSE '%' END)        
AND D.PARTY_CODE LIKE @PARTY_CODE         
AND D.SCRIP_CD LIKE @SCRIP_CD         
AND D.SERIES LIKE @SERIES        
GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,C1.SHORT_NAME,D.SCRIP_CD,D.SERIES,D.BUYQTY,SELLQTY ,SCHEME_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelSettPosParty
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelSettPosParty]       
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))      
As      
  
Select *, Scripname = SCHEME_NAME Into #Del From DeliveryClt  
Where sett_no = @SettNo and sett_type = @Sett_Type       
  
select D.Party_Code,C1.Long_Name,ScripName,D.Scrip_Cd,D.Series,  
ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end )       
from #Del D, Client2 C2, Client1 C1  
Where sett_no = @SettNo and sett_type = @Sett_Type       
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code  
And @StatusName =             
                  (case             
                        when @StatusId = 'BRANCH' then c1.branch_cd            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker            
                        when @StatusId = 'Trader' then c1.Trader            
                        when @StatusId = 'Family' then c1.Family            
                        when @StatusId = 'Area' then c1.Area            
                        when @StatusId = 'Region' then c1.Region            
                        when @StatusId = 'Client' then c2.party_code            
                  else             
                        'BROKER'            
                  End)            
Order By D.Party_Code,C1.Long_Name,ScripName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelSettPosScrip
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelSettPosScrip]     
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))    
As    
Select *, Scripname = SCHEME_NAME Into #Del From DeliveryClt  
Where sett_no = @SettNo and sett_type = @Sett_Type       
  
select D.Party_Code,C1.Long_Name,ScripName,D.Scrip_Cd,D.Series,  
ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end )       
from #Del D, Client2 C2, Client1 C1  
Where sett_no = @SettNo and sett_type = @Sett_Type       
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code  
And @StatusName =             
                  (case             
                        when @StatusId = 'BRANCH' then c1.branch_cd            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker            
                        when @StatusId = 'Trader' then c1.Trader            
                        when @StatusId = 'Family' then c1.Family            
                        when @StatusId = 'Area' then c1.Area            
                        when @StatusId = 'Region' then c1.Region            
                        when @StatusId = 'Client' then c2.party_code            
                  else             
                        'BROKER'            
                  End)            
Order By ScripName,D.Party_Code,C1.Long_Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelTransaction
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelTransaction] (    
@StatusId Varchar(15),@StatusName Varchar(25),@FromDate varchar(11),@ToDate Varchar(11),@Party_Code Varchar(10),@Scrip_Cd Varchar(12))    
AS    
   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, SCHEME_NAME=sec_name, D.Sett_No, D.Sett_type, D.TCode, D.Qty,    
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId    
from deltrans D, CLient1 C1, Client2 C2, MFSS_SCRIP_MASTER M   
where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code     
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'    
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1     
AND M.SCRIP_CD = D.SCRIP_CD  and m.series = d.series
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)          
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)          
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELTRANSFER
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_NSEDELTRANSFER]     
(@STATUSID VARCHAR(15), @STATUSNAME VARCHAR(25),     
 @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),     
 @FROMSCRIP VARCHAR(12), @TOSCRIP VARCHAR(12),  
 @FROMDATE VARCHAR(11), @TODATE VARCHAR(11)  
)    
AS     
  
SELECT SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, D.SCRIP_CD, D.SERIES, SCHEME_NAME=SEC_NAME, QTY = SUM(QTY), DPID, CLTDPID,     
TRANSDATE = LEFT(CONVERT(VARCHAR, TRANSDATE, 109), 11), BDPID, BCLTDPID, TRTYPE, ISETT_NO, ISETT_TYPE     
FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER M   
WHERE DELIVERED = 'D' AND FILLER2 = 1 AND DRCR = 'D'     
AND C2.PARTY_CODE = D.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE     
AND D.PARTY_CODE > = @FROMPARTY AND D.PARTY_CODE < = @TOPARTY    
AND D.SCRIP_CD > = @FROMSCRIP AND D.SCRIP_CD < = @TOSCRIP     
AND D.TRANSDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'  
AND M.SCRIP_CD = D.SCRIP_CD AND D.SERIES = M.SERIES  
GROUP BY D.PARTY_CODE, C1.LONG_NAME, D.SCRIP_CD, D.SERIES, SEC_NAME,SETT_NO, SETT_TYPE, DPID,     
CLTDPID, LEFT(CONVERT(VARCHAR, TRANSDATE, 109), 11), BDPID, BCLTDPID, TRTYPE, ISETT_NO, ISETT_TYPE     
ORDER BY D.PARTY_CODE, C1.LONG_NAME, SEC_NAME, D.SCRIP_CD, D.SERIES, SETT_NO, SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_partymapping
-- --------------------------------------------------



CREATE     proceDURE [dbo].[rpt_partymapping]
	@date varchar(11),
	@OrderType Varchar(10),
	@RptType Varchar(10)

	AS
  
set transaction isolation level read uncommitted

If (@RptType = 'Summary')
Begin
	select
		RptOrder = (Case When @OrderType = 'PARTY' 
				Then Party_Code
				Else ContractNo
				End),	
		party_code,
		contractno,
		User_Id,
		branch_id,
		sell_buy,
		Tradeqty = sum(Tradeqty),
		avgrate = sum(Marketrate*Tradeqty)/Sum(Tradeqty),
		Scrip_CD,
		Series		
	from
		Settlement S (Nolock),
		Client1 C1 (Nolock)
	where 
		S.Party_code = C1.CL_Code
		And sauda_date like @date +'%' 
		And tradeqty > 0
	
	group by
		party_code,
		user_id,
		branch_id,
		contractno,
		sell_buy,
		Scrip_CD,
		Series	

	order by 
		contractno,
		Party_code,
		RptOrder
		
		
	
End
Else
Begin
	select
		RptOrder = (Case When @OrderType = 'PARTY' 
				Then Party_Code
				Else ContractNo
				End),	
		party_code,
		contractno,
		User_Id,
		branch_id,
		sell_buy,
		Tradeqty = Tradeqty,
		avgrate = Marketrate,
		Scrip_CD,
		Series		
	from
		Settlement S (Nolock),
		Client1 C1 (Nolock)
	where 
		S.Party_code = C1.CL_Code
		And sauda_date like @date +'%' 
		and tradeqty > 0
	order by 
		contractno,
		Party_code,
		RptOrder

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_PODPBANK_DETAILS
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_PODPBANK_DETAILS]
	(
	@BANKTYPE VARCHAR(5)
	)

	AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF (@BANKTYPE = 'PO')
	BEGIN
		SELECT 
			DISTINCT 
			BANKID, 
			BANK_NAME, 
			BRANCH_NAME 
		FROM 
			POBANK (NOLOCK)
	END
	ELSE
	BEGIN
		SELECT 
			DISTINCT 
			BANKID, 
			BANKNAME, 
			BANKTYPE 
		FROM 
			BANK (NOLOCK)
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_REGIONLISTING
-- --------------------------------------------------


CREATE PROC [dbo].[RPT_REGIONLISTING]
	(
    	@FROMREGION VARCHAR(15),
	@TOREGION VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15)
	)
	
AS
    if @FROMREGION = '' begin set @FROMREGION = '0'  end
    if @TOREGION = '' begin set @TOREGION = 'zzzzzz' end
    if @FROMBRANCH = '' begin set @FROMBRANCH = '0'  end
    if @TOBRANCH = '' begin set @TOBRANCH = 'zzzzzz' end

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
			Regioncode = UPPER(Regioncode),
			Description = UPPER(Description),
			Branch_Code = UPPER(Branch_Code)

From 
    Region

Where
    Regioncode between @FROMREGION and @TOREGION
    AND Branch_Code between @FROMBRANCH and @TOBRANCH
    

Order by
		Regioncode,Description,Branch_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_SAUDADETAILS
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_SAUDADETAILS]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@STATUSID VARCHAR(10),
	@STATUSNAME VARCHAR(20)
	)

	AS

	--EXEC RPT_SAUDADETAILS 'JAN  1 2007','JAN  1 2008','','ZZZZZZZZZZZZZZZ','BROKER','BROKER'
/*
	Commodity Query to fetch the Trade Details
	Report Format :
	OrderNo,TradeNo,ClientCode,ClientName,ContractDate,ScripName,BuySell,Quantity,ExecRate,NetRate
	
	Note : Change the hard corderd date condition as per your need
	
*/

  IF @FROMPARTY = '' BEGIN SET @FROMPARTY = '0' END
  IF @TOPARTY = '' BEGIN SET @TOPARTY = 'ZZZZZZ'END  

Set Transaction Isolation Level read uncommitted
Select
	OrderNo  = Order_No,
	TradeNo  = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Trade_No,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U',''),
	ClientCode = Client2.Party_Code,
	ClientName = Client1.Long_Name,
	ContractDate = Convert(Varchar,Sauda_Date,103),
	FoSettlement.Inst_type,
	FoSettlement.Symbol,
	FoSettlement.ExpiryDate,
	FoSettlement.Strike_Price,
	FoSettlement.Option_Type,
	BuySell = Case When Sell_Buy =1 Then 'Buy' else 'Sell' End,
	Quantity = Sum(TradeQty),
	ExecRate = Price,
	NetRate = NetRate,
	Brokerage = Sum(TradeQty * BrokApplied),
	NetAmount = Sum(NetRate * TradeQty)

Into 
	#FoSett
From
	FoSettlement, Client1, Client2, FoScrip2	
Where
	Client1.Cl_Code = Client2.Cl_Code
	And FoSettlement.Party_Code = Client2.Party_Code
	And FoSettlement.Inst_Type = FoScrip2.Inst_Type
	And FoSettlement.Symbol = FoScrip2.Symbol
	And FoSettlement.ExpiryDate = FoScrip2.ExpiryDate
	And FoSettlement.Option_Type = FoScrip2.Option_Type
	And FoSettlement.Strike_Price = FoScrip2.Strike_Price
	And TradeQty > 0
	And Sauda_Date Between @FROMDATE and @TODATE + ' 23:59'
	AND FoSettlement.Party_Code >= @FROMPARTY
	AND FoSettlement.Party_Code <= @TOPARTY
Group By
	Order_No,
	Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Trade_No,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U',''),
	Client2.Party_Code,
	Client1.Long_Name,
	Convert(Varchar,Sauda_Date,103),
	FoSettlement.Inst_type,
	FoSettlement.Symbol,
	FoSettlement.ExpiryDate,
	FoSettlement.Strike_Price,
	FoSettlement.Option_Type,
	Sell_Buy,
	Price,
	NetRate


IF (SELECT COUNT(1) FROM PRADNYA..DATAIN_HISTORY_FOSETTLEMENT_NSEFO WHERE SAUDA_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:00') > 0
BEGIN
	INSERT INTO #FoSett
	Select
		OrderNo  = Order_No,
		TradeNo  = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Trade_No,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U',''),
		ClientCode = Client2.Party_Code,
		ClientName = Client1.Long_Name,
		ContractDate = Convert(Varchar,Sauda_Date,103),
		H.Inst_type,
		H.Symbol,
		H.ExpiryDate,
		H.Strike_Price,
		H.Option_Type,
		BuySell = Case When Sell_Buy =1 Then 'Buy' else 'Sell' End,
		Quantity = Sum(TradeQty),
		ExecRate = Price,
		NetRate = NetRate,
		Brokerage = Sum(TradeQty * BrokApplied),
		NetAmount = Sum(NetRate * TradeQty)	
	From
		PRADNYA..HISTORY_FOSETTLEMENT_NSEFO H, Client1, Client2, FoScrip2	
	Where
		Client1.Cl_Code = Client2.Cl_Code
		And H.Party_Code = Client2.Party_Code
		And H.Inst_Type = FoScrip2.Inst_Type
		And H.Symbol = FoScrip2.Symbol
		And H.ExpiryDate = FoScrip2.ExpiryDate
		And H.Option_Type = FoScrip2.Option_Type
		And H.Strike_Price = FoScrip2.Strike_Price
		And TradeQty > 0
		And Sauda_Date Between @FROMDATE and @TODATE + ' 23:59'
		AND H.Party_Code >= @FROMPARTY
		AND H.Party_Code <= @TOPARTY
	Group By
		Order_No,
		Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Trade_No,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U',''),
		Client2.Party_Code,
		Client1.Long_Name,
		Convert(Varchar,Sauda_Date,103),
		H.Inst_type,
		H.Symbol,
		H.ExpiryDate,
		H.Strike_Price,
		H.Option_Type,
		Sell_Buy,
		Price,
		NetRate
END


IF (SELECT COUNT(1) FROM CHARGES_DETAIL WHERE CD_Sauda_Date BETWEEN @FROMDATE AND @TODATE + ' 23:59:00') > 0
BEGIN
	UPDATE   
	 	#FoSett  
	SET  
	 	Brokerage = 
		CD_Tot_Brok  + (Case When Service_Chrg = 1 Then CD_Tot_SerTax Else 0 End)
	FROM  
		CHARGES_DETAIL , Client2 
	WHERE  
		Convert(Varchar,CD_Sauda_Date,103) = ContractDate 
		And CD_Party_Code = ClientCode
		And CD_Inst_Type = Inst_Type
		And CD_Symbol = Symbol  
		And CD_Expiry_Date = ExpiryDate  
		And CD_Option_Type = Option_Type  
		And CD_Strike_Price = Strike_Price  
		And CD_Trade_No = TradeNo  
		And CD_Order_No = OrderNo 
		And Client2.Party_Code = CD_Party_Code
		AND CD_Party_Code >= @FROMPARTY
		AND CD_Party_Code <= @TOPARTY
END


Select 
	OrderNo,
	TradeNo,
	ClientCode,
	ClientName,
	ContractDate,
	Inst_type,
	Symbol,
	ExpiryDate = CONVERT(VARCHAR(11),ExpiryDate,103),
	Strike_Price,
	Option_Type,
	BuySell,
	Quantity,
	ExecRate,
	NetRate,
	Brokerage,
	NetAmount 
From 
	#FoSett 
Order By
	ContractDate,
	ClientCode,
	Inst_type,
	Symbol,
	ExpiryDate,
	Strike_Price,
	Option_Type,
	BuySell,
	ExecRate


Drop Table #FoSett

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_SBUMASTER
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_SBUMASTER] 
(
	@Sbu_CodeFROM VARCHAR(10),
	@Sbu_CodeTO   VARCHAR(10)
	
)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
IF @Sbu_CodeFROM = '' BEGIN SET @Sbu_CodeFROM = '0' END
IF @Sbu_CodeTO = '' BEGIN SET @Sbu_CodeTO = 'ZZZ' END

BEGIN
	Select 
		Sbu_Code,Sbu_Name,Sbu_Addr1,Sbu_Addr2,Sbu_Addr3,Sbu_State,Sbu_City,Sbu_Zip,Sbu_Phone1,Sbu_Phone2,Sbu_Type,Sbu_Party_Code  
	From 
		SBU_MASTER (nolock)
	Where 
		sbu_code >= @Sbu_CodeFROM
		And sbu_code <= @Sbu_CodeTO
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_SETTYPE_DELCLT
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_SETTYPE_DELCLT] 

	@SETT_TYPE VARCHAR(2)
AS
/*
	EXEC RPT_SETTYPE_DELCLT ''
	EXEC RPT_SETTYPE_DELCLT 'W'
*/
BEGIN
	IF @SETT_TYPE='' 
		BEGIN
			SELECT DISTINCT 
				SETT_TYPE 
			FROM 
				BSEMFSS..DELIVERYCLT 
			ORDER BY 
				SETT_TYPE
		END
	ELSE IF @SETT_TYPE <>'' 
		BEGIN
			SELECT DISTINCT 
				SETT_NO  
			FROM 
				BSEMFSS..DELIVERYCLT 
			WHERE 
				SETT_TYPE=@SETT_TYPE 
			ORDER BY 
				SETT_NO DESC
		END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_UCCFILEGENERATION
-- --------------------------------------------------
CREATE PROCEDURE RPT_UCCFILEGENERATION
(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@PARTYFROM VARCHAR(10),
	@PARTYTO VARCHAR(10),
	@BRANCHFROM VARCHAR(10),
	@BRANCHTO VARCHAR(10),
	@CLTYPE VARCHAR(3)
)
AS

SELECT
	PARTY_CODE,
	MODE_HOLDING,
	TAX_STATUS = '0'+ CONVERT(VARCHAR,TAX_STATUS),
	OCCUPATION_CODE ='0' + CONVERT(VARCHAR,OCCUPATION_CODE),
	APPNAME1 = LEFT(PARTY_NAME,70),
	APPNAME2 = LEFT(HOLDER2_NAME,35),
	APPNAME3 = LEFT(HOLDER3_NAME,35),
	DOB = CASE WHEN DOB ='' THEN '' ELSE CONVERT(VARCHAR,DOB,103) END,
	GENDER,
	GAURDIAN_NAME = LEFT(GAURDIAN_NAME,35),
	PAN_NO,
	NOMINEE_NAME = LEFT(NOMINEE_NAME,35),
	NOMINEE_RELATION = LEFT(NOMINEE_RELATION,20),
	GAURDIAN_PAN_NO = LEFT(GAURDIAN_PAN_NO,10),
	DP_TYPE,
	CDSLDPID = CASE WHEN DP_TYPE ='CDSL' THEN DPID ELSE '' END,
	CDSLCLTID = CASE WHEN DP_TYPE ='CDSL' THEN CLTDPID ELSE '' END,
	NSDLDPID = CASE WHEN DP_TYPE ='NSDL' THEN DPID ELSE '' END,
	NSDLCLTID = CASE WHEN DP_TYPE ='NSDL' THEN CLTDPID ELSE '' END,
	BANK_NAME = LEFT(BANK_NAME,40),
	BANK_BRANCH = LEFT(BANK_BRANCH,40),
	BANK_CITY = LEFT(BANK_CITY,35),
	BANK_AC_TYPE,
	ACC_NO = LEFT(ACC_NO,16),
	MICR_NO = LEFT(MICR_NO,9),
	NEFTCODE = LEFT(NEFTCODE,11),
	CHEQUENAME = LEFT(CHEQUENAME,35),
	ADDR1 = LEFT(ADDR1,40),
	ADDR2 = LEFT(ADDR2,40),
	ADDR3 = LEFT(ADDR3,40),
	CITY = LEFT(CITY,35),
	STATE_CODE,
	ZIP = LEFT(ZIP,6),
	NATION = LEFT(NATION,35),
	RES_PHONE = LEFT(RES_PHONE,15),
	RESIFAX = LEFT(RESIFAX,15),
	OFFICE_PHONE = LEFT(OFFICE_PHONE,15),
	OFFICEFAX = LEFT(OFFICEFAX,15),
	EMAIL_ID = LEFT(EMAIL_ID,50),
	STAT_COMM_MODE,
	PAYMODE = '0' + CONVERT(VARCHAR,PAYMODE),
	HOLDER2_PAN_NO = LEFT(HOLDER2_PAN_NO,10),
	HOLDER3_PAN_NO = LEFT(HOLDER3_PAN_NO,10),
	MAPINID = LEFT(MAPINID,16)
FROM 
	MFSS_CLIENT (NOLOCK), STATE_MASTER (NOLOCK)
WHERE 
	MFSS_CLIENT.STATE = STATE_MASTER.STATE
	AND ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
	AND PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
	AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
	AND CL_TYPE = CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_UCCFILEGENERATION_NEW
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[RPT_UCCFILEGENERATION_NEW]
(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@PARTYFROM VARCHAR(10),
	@PARTYTO VARCHAR(10),
	@BRANCHFROM VARCHAR(10),
	@BRANCHTO VARCHAR(10),
	@CLTYPE VARCHAR(3),
	@OPTIONVAL VARCHAR(2)
)

	AS

	--EXEC RPT_UCCFILEGENERATION_NEW 'JAN  1 2010','DEC 31 2022','WPNBAS171','WPNBAS171','','ZZZZZZ','','A'


	CREATE TABLE #CLIENTLIST  
	(PARTY_CODE VARCHAR(10))  

	CREATE INDEX [INDXCL2] ON #CLIENTLIST ([PARTY_CODE])
	
	/*-----------------------------------------------------------------------------  
	FETCHING TRADED CLIENT LIST TO #CLIENTLIS  
	-----------------------------------------------------------------------------*/  
  
	IF @OPTIONVAL = 'T'  
	BEGIN  
		INSERT INTO #CLIENTLIST  
		SELECT  
			DISTINCT PARTY_CODE  
		FROM 
			MFSS_SETTLEMENT (NOLOCK)  
		WHERE  
			ORDER_DATE BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			--AND TRADETYPE NOT IN ( 'SCF','ICF','IR' )  
	END
	ELSE IF @OPTIONVAL = 'M'
	BEGIN
		INSERT INTO #CLIENTLIST  
		SELECT  
			PARTY_CODE  
		FROM  
			MFSS_CLIENT_LOG M
		WHERE
			PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END 
			AND EDITEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND ADDEDON <> EDITEDON
	END
	ELSE  
	BEGIN  
		INSERT INTO #CLIENTLIST  
		SELECT  
			PARTY_CODE  
		FROM  
			MFSS_CLIENT (NOLOCK)
		WHERE  
	
			PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO  
	END

	SELECT	* INTO #MFSSMASTER
	FROM 	MFSS_CLIENT (NOLOCK)
	WHERE	PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END 
			AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #CLIENTLIST WHERE #CLIENTLIST.PARTY_CODE = MFSS_CLIENT.PARTY_CODE)

	UPDATE	#MFSSMASTER
	SET		--PARTY_NAME = REPLACE(PARTY_NAME,' ','|'),
			HOLDER2_NAME = REPLACE(HOLDER2_NAME,' ','|'),
			HOLDER3_NAME = REPLACE(HOLDER3_NAME,' ','|'),
			GAURDIAN_NAME = REPLACE(GAURDIAN_NAME,' ','|')

	SELECT
		PARTY_CODE,
		/*
		--PRIMARY_HOLDER_FIRST_NAME = ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',1))),''),
		--PRIMARY_HOLDER_MIDDLE_NAME = (
		--CASE
		--	WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',2))),'')
		--	ELSE ''
		--END),
		--PRIMARY_HOLDER_LAST_NAME = (
		--CASE
		--	WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',3))),'')
		--	ELSE ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(PARTY_NAME,'|',2))),'')
		--END),
		*/
		PRIMARY_HOLDER_FIRST_NAME = PARTY_NAME,
		PRIMARY_HOLDER_MIDDLE_NAME = '',
		PRIMARY_HOLDER_LAST_NAME = '',
		
		--MODE_HOLDING,
		TAX_STATUS = RIGHT('0'+ CONVERT(VARCHAR,TAX_STATUS),2),
		/*
		TAX_STATUS = (
		CASE
			WHEN ISNULL(CL_STATUS,'') IN ('IND','IN','ROR','CLI') THEN '01'
			WHEN ISNULL(CL_STATUS,'') IN ('OBM') THEN '02'
			WHEN ISNULL(CL_STATUS,'') IN ('HUF') THEN '03'
			WHEN ISNULL(CL_STATUS,'') IN ('PRO') THEN '04'
			WHEN ISNULL(CL_STATUS,'') IN ('AOP') THEN '05'
			WHEN ISNULL(CL_STATUS,'') IN ('PAR','PSF') THEN '06'
			WHEN ISNULL(CL_STATUS,'') IN ('BC','BCP') THEN '07'
			WHEN ISNULL(CL_STATUS,'') IN ('TS','TRU') THEN '08'
			--WHEN ISNULL(CL_STATUS,'') IN ('TS','TRU') THEN '09'
			WHEN ISNULL(CL_STATUS,'') IN ('OTH') THEN '10'
			WHEN ISNULL(CL_STATUS,'') IN ('DFI') THEN '12'
			WHEN ISNULL(CL_STATUS,'') IN ('SOL') THEN '13'
			WHEN ISNULL(CL_STATUS,'') IN ('NRE') THEN '21'
			WHEN ISNULL(CL_STATUS,'') IN ('OCB') THEN '22'
			WHEN ISNULL(CL_STATUS,'') IN ('FII') THEN '23'
			WHEN ISNULL(CL_STATUS,'') IN ('NRO') THEN '24'
			WHEN ISNULL(CL_STATUS,'') IN ('OCB') THEN '25'
			WHEN ISNULL(CL_STATUS,'') IN ('PF') THEN '31'
			WHEN ISNULL(CL_STATUS,'') IN ('QFI') THEN '41'
			WHEN ISNULL(CL_STATUS,'') IN ('LLP') THEN '47'
			WHEN ISNULL(CL_STATUS,'') IN ('NPO') THEN '48'
			WHEN ISNULL(CL_STATUS,'') IN ('MF') THEN '54'
			WHEN ISNULL(CL_STATUS,'') IN ('FP4') THEN '55'
			WHEN ISNULL(CL_STATUS,'') IN ('FP5') THEN '56'
			WHEN ISNULL(CL_STATUS,'') IN ('FP6') THEN '57'
			WHEN ISNULL(CL_STATUS,'') IN ('IC') THEN '60'
			ELSE '99'
		END),
		*/
		GENDER,
		DOB = CASE WHEN DOB ='' THEN '' ELSE CONVERT(VARCHAR,DOB,103) END,
		OCCUPATION_CODE ='0' + CONVERT(VARCHAR,OCCUPATION_CODE),
		MODE_HOLDING,
		SECOND_HOLDER_FIRST_NAME = ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',1))),''),
		SECOND_HOLDER_MIDDLE_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',2))),'')
			ELSE ''
		END),
		SECOND_HOLDER_LAST_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',3))),'')
			ELSE ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER2_NAME,'|',2))),'')
		END),

		THIRD_HOLDER_FIRST_NAME = ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',1))),''),
		THIRD_HOLDER_MIDDLE_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',2))),'')
			ELSE ''
		END),
		THIRD_HOLDER_LAST_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',3))),'')
			ELSE ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(HOLDER3_NAME,'|',2))),'')
		END),

		SECOND_HOLDER_DOB = ISNULL(CONVERT(VARCHAR,SECOND_HOLDER_DOB,103),''),
		THIRD_HOLDER_DOB = ISNULL(CONVERT(VARCHAR,THIRD_HOLDER_DOB,103),''),

		GUARDIAN_FIRST_NAME = ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',1))),''),
		GUARDIAN_MIDDLE_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',2))),'')
			ELSE ''
		END),
		GUARDIAN_LAST_NAME = (
		CASE
			WHEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',3))),'') <> '' THEN ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',3))),'')
			ELSE ISNULL(LTRIM(RTRIM(MSAJAG.DBO.PIECE(GAURDIAN_NAME,'|',2))),'')
		END),
		
		GUARDIAN_BOB = ISNULL(CONVERT(VARCHAR,GUARDIAN_DOB,103),''),

		PRIMARY_HOLDER_PAN_EXEMPT = (CASE WHEN ISNULL(PRIMARYEXEMPT,'') = '' THEN 'N' ELSE ISNULL(PRIMARYEXEMPT,'') END), 
		
		SECOND_HOLDER_PAN_EXEMPT = (
		CASE 
			WHEN TAX_STATUS IN (1,21,24,26,27,28,29) 
			THEN (CASE WHEN ISNULL(HOLDER2_NAME,'') = '' THEN '' ELSE ISNULL(SECONDEXEMPT,'') END)
			ELSE ''
		END),
		THIRD_HOLDER_PAN_EXEMPT = (
		CASE 
			WHEN TAX_STATUS IN (1,21,24,26,27,28,29) 
			THEN (CASE WHEN ISNULL(HOLDER3_NAME,'') = '' THEN '' ELSE ISNULL(THIRDEXEMPT,'') END)
			ELSE ''
		END),
		GUARDIAN_PAN_EXEMPT  = (
		CASE 
			WHEN TAX_STATUS IN (1,21,24,26,27,28,29) 
			THEN (CASE WHEN ISNULL(GAURDIAN_NAME,'') = '' THEN '' ELSE ISNULL(GUARDIANEXEMPT,'') END)
			ELSE ''
		END),

		PRIMARY_HOLDER_PAN = LEFT(PAN_NO,10),
		SECOND_HOLDER_PAN = LEFT(HOLDER2_PAN_NO,10),
		THIRD_HOLDER_PAN = LEFT(HOLDER3_PAN_NO,10),
		GUARDIAN_PAN = LEFT(GAURDIAN_PAN_NO,10),

		PRIMARY_HOLDER_EXEMPT_CATEGORY = (CASE WHEN ISNULL(PRIMARYEXEMPT,'') = 'Y' THEN ISNULL(PRIMARYEXEMPTCAT,'') ELSE '' END),
		SECOND_HOLDER_EXEMPT_CATEGORY = (CASE WHEN ISNULL(SECONDEXEMPT,'') = 'Y' THEN ISNULL(SECONDEXEMPTCAT,'') ELSE '' END),
		THIRD_HOLDER_EXEMPT_CATEGORY = (CASE WHEN ISNULL(THIRDEXEMPT,'') = 'Y' THEN ISNULL(THIRDEXEMPTCAT,'') ELSE '' END),
		GUARDIAN_EXEMPT_CATEGORY = (CASE WHEN ISNULL(GUARDIANEXEMPT,'') = 'Y' THEN ISNULL(GUARDIANEXEMPTCAT,'') ELSE '' END),
		CLIENT_TYPE = ISNULL(PD_CLTYPE,''),
		PMS = ISNULL(PMS,''),

		DEFAULT_DP = (CASE WHEN ISNULL(PD_CLTYPE,'') ='D' THEN ISNULL(DP_TYPE,'') ELSE '' END),
		CDSL_DPID = (CASE WHEN ISNULL(PD_CLTYPE,'') ='D' AND ISNULL(DP_TYPE,'') ='CDSL' THEN DPID ELSE '' END),
		CDSLCLTID = (CASE WHEN ISNULL(PD_CLTYPE,'') ='D' AND ISNULL(DP_TYPE,'') ='CDSL' THEN CLTDPID ELSE '' END),
		CMBP_ID = (CASE WHEN ISNULL(DP_TYPE,'') ='NSDL' AND ISNULL(PMS,'') = 'Y' THEN ISNULL(PID,'') ELSE '' END),
		NSDLDPID = (CASE WHEN ISNULL(PD_CLTYPE,'') ='D' AND ISNULL(DP_TYPE,'') ='NSDL' THEN DPID ELSE '' END),
		NSDLCLTID = (CASE WHEN ISNULL(PD_CLTYPE,'') ='D' AND ISNULL(DP_TYPE,'') ='NSDL' THEN CLTDPID ELSE '' END),

		ACCOUNT_TYPE_1 = ISNULL(BANK_AC_TYPE,''),
		ACCOUNT_NO_1 = ISNULL(ACC_NO,''),
		MICR_NO_1 = ISNULL(MICR_NO,''),
		IFSC_CODE_1 = ISNULL(IFSCCODE,''),
		DEFAULT_BANK_FLAG_1 = 'Y',

		ACCOUNT_TYPE_2 = CONVERT(VARCHAR(2),''),
		ACCOUNT_NO_2 = CONVERT(VARCHAR(40),''),
		MICR_NO_2 = CONVERT(VARCHAR(10),''),
		IFSC_CODE_2 = CONVERT(VARCHAR(12),''),
		DEFAULT_BANK_FLAG_2 = CONVERT(VARCHAR(1),''),

		ACCOUNT_TYPE_3 = CONVERT(VARCHAR(2),''),
		ACCOUNT_NO_3 = CONVERT(VARCHAR(40),''),
		MICR_NO_3 = CONVERT(VARCHAR(10),''),
		IFSC_CODE_3 = CONVERT(VARCHAR(12),''),
		DEFAULT_BANK_FLAG_3 = CONVERT(VARCHAR(1),''),

		ACCOUNT_TYPE_4 = CONVERT(VARCHAR(2),''),
		ACCOUNT_NO_4 = CONVERT(VARCHAR(40),''),
		MICR_NO_4 = CONVERT(VARCHAR(10),''),
		IFSC_CODE_4 = CONVERT(VARCHAR(12),''),
		DEFAULT_BANK_FLAG_4 = CONVERT(VARCHAR(1),''),
		
		ACCOUNT_TYPE_5 = CONVERT(VARCHAR(2),''),
		ACCOUNT_NO_5 = CONVERT(VARCHAR(40),''),
		MICR_NO_5 = CONVERT(VARCHAR(10),''),
		IFSC_CODE_5 = CONVERT(VARCHAR(12),''),
		DEFAULT_BANK_FLAG_5 = CONVERT(VARCHAR(1),''),

		CHEQUE_NAME= ISNULL(CHEQUENAME,''),
		DIV_PAYMODE = '0' + CONVERT(VARCHAR,PAYMODE),

		ADDR1 = LEFT(ADDR1,40),
		ADDR2 = LEFT(ADDR2,40),
		ADDR3 = LEFT(ADDR3,40),
		CITY = LEFT(CITY,35),
		STATE_CODE,
		ZIP = LEFT(ZIP,6),
		NATION = LEFT(NATION,35),
		RES_PHONE = LEFT(RES_PHONE,15),
		RESIFAX = LEFT(RESIFAX,15),
		OFFICE_PHONE = LEFT(OFFICE_PHONE,15),
		OFFICEFAX = LEFT(OFFICEFAX,15),
		EMAIL_ID = LEFT(EMAIL_ID,50),
		STAT_COMM_MODE,

		CM_FORADD1 = LEFT(ISNULL(CM_FORADD1,''),40),
		CM_FORADD2 = LEFT(ISNULL(CM_FORADD2,''),40),
		CM_FORADD3 = LEFT(ISNULL(CM_FORADD3,''),40),
		CM_FORCITY = LEFT(ISNULL(CM_FORCITY,''),35),
		CM_FORPINCODE = LEFT(ISNULL(CM_FORPINCODE,''),10),
		CM_FORSTATE = LEFT(ISNULL(CM_FORSTATE,''),35),
		CM_FORCOUNTRY = LEFT(ISNULL(CM_FORCOUNTRY,''),3),
		CM_FORRESIPHONE = LEFT(ISNULL(CM_FORRESIPHONE,''),15),
		CM_FORRESIFAX = LEFT(ISNULL(CM_FORRESIFAX,''),15),
		CM_FOROFFPHONE = LEFT(ISNULL(CM_FOROFFPHONE,''),15),
		CM_FOROFFFAX = LEFT(ISNULL(CM_FOROFFFAX,''),15),
		INDIAN_MOBILENO = ISNULL(MOBILE_NO,''), 

		NOMINEE_NAME_1 = LEFT(NOMINEE_NAME,40),
		NOMINEE_RELATION_1 = LEFT(NOMINEE_RELATION,40),
		NOMINEE_APPLICABLE_PER_1 = (CASE WHEN ISNULL(NOMINEEPER,'') = '' THEN '' ELSE ISNULL(NOMINEEPER,'0') END),
		NOMINEE_MINORFLAG_1 = ISNULL(NOMINEEMINORFLAG,''),--(CASE WHEN ISNULL(NOMINEEMINORFLAG,'') = 'N' THEN '' ELSE ISNULL(NOMINEEMINORFLAG,'') END),
		NOMINEE_DOB_1 = (CASE WHEN ISNULL(NOMINEEMINORFLAG,'') = 'Y' THEN CONVERT(VARCHAR,ISNULL(NOMINEEDOB,''),103) ELSE '' END),
		NOMINEE_GUARDIAN_1 = ISNULL(NOMINEEGUARDIAN,''),

		NOMINEE_NAME_2 = LEFT(NOMINEE_NAME2,40),
		NOMINEE_RELATION_2 = LEFT(NOMINEE_RELATION2,40),
		NOMINEE_APPLICABLE_PER_2 = (CASE WHEN ISNULL(NOMINEEPER2,'') = '' THEN '' ELSE ISNULL(NOMINEEPER2,'0') END),
		NOMINEE_DOB_2 = (CASE WHEN ISNULL(NOMINEEMINORFLAG2,'') = 'Y' THEN CONVERT(VARCHAR,ISNULL(NOMINEEDOB2,''),103) ELSE '' END),
		NOMINEE_MINORFLAG_2 = ISNULL(NOMINEEMINORFLAG2,''),
		NOMINEE_GUARDIAN_2 = ISNULL(NOMINEEGUARDIAN2,''),
		
		NOMINEE_NAME_3 = LEFT(NOMINEE_NAME3,40),
		NOMINEE_RELATION_3 = LEFT(NOMINEE_RELATION3,40),
		NOMINEE_APPLICABLE_PER_3 = (CASE WHEN ISNULL(NOMINEEPER3,'') = '' THEN '' ELSE ISNULL(NOMINEEPER3,'0') END),
		NOMINEE_DOB_3 = (CASE WHEN ISNULL(NOMINEEMINORFLAG3,'') = 'Y' THEN CONVERT(VARCHAR,ISNULL(NOMINEEDOB3,''),103) ELSE '' END),
		NOMINEE_MINORFLAG_3 = ISNULL(NOMINEEMINORFLAG3,''),
		NOMINEE_GUARDIAN_3 = ISNULL(NOMINEEGUARDIAN3,''),

		PRIMARY_HOLDER_KYC_TYPE = ISNULL(PRIMARYHOLDERKYCTYPE,''),
		PRIMARY_HOLDER_CKYC_NO = ISNULL(PRIMARYHOLDERCKYCNO,''),
		SECOND_HOLDER_KYC_TYPE = ISNULL(SECONDHOLDERKYCTYPE,''),
		SECOND_HOLDER_CKYC_NO = ISNULL(SECONDHOLDERCKYCNO,''),
		THIRD_HOLDER_KYC_TYPE = ISNULL(THIRDHOLDERKYCTYPE,''),
		THIRD_HOLDER_CKYC_NO = ISNULL(THIRDHOLDERCKYCNO,''),
		GUARDIAN_KYC_TYPE = ISNULL(GUARDIANHOLDERKYCTYPE,''),
		GUARDIAN_CKYC_NO = ISNULL(GUARDIANHOLDERCKYCNO,''),
		PRIMARY_HOLDER_KRA_EXEMPT_REFNO = ISNULL(PRIMARYHOLDERKRAEXEMPTNO,''),
		SECOND_HOLDER_KRA_EXEMPT_REFNO = ISNULL(SECONDHOLDERKRAEXEMPTNO,''),
		THIRD_HOLDER_KRA_EXEMPT_REFNO = ISNULL(THIRDHOLDERKRAEXEMPTNO,''),
		GUARDIAN_EXEMPT_REFNO = ISNULL(GUARDIANHOLDERKRAEXEMPTNO,''),
		AADHAAR_UPDATED = ISNULL(AADHARUPDATED,''),
		MAPIN_ID = ISNULL(MAPINID,''),
		PAPERLESS_FLAG = ISNULL(PAPERLESSFLAG,''),
		LEI_NO = ISNULL(LEINO,''),
		LEI_VALIDITY = ISNULL(LEIVALIDITY,''),
		FILLER_1 = '',
		FILLER_2 = '',
		FILLER_3 = ''
	INTO
		#NSEMFSS_UCC
	FROM 
		#MFSSMASTER M, STATE_MASTER (NOLOCK)
	WHERE 
		M.STATE = STATE_MASTER.STATE
		AND ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
		AND PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
		AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
		AND CL_TYPE = CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END 
		AND EXISTS (SELECT DISTINCT PARTY_CODE FROM #CLIENTLIST WHERE #CLIENTLIST.PARTY_CODE = M.PARTY_CODE)
		AND ADDEDON BETWEEN   
			CASE WHEN @OPTIONVAL = 'A' THEN @DATEFROM ELSE 'JAN  1 1900' END  
			AND  
			CASE WHEN @OPTIONVAL = 'A' THEN @DATETO + ' 23:59' ELSE 'DEC 31 2049 23:59' END  
		AND ACTIVE_FROM BETWEEN  
			CASE WHEN @OPTIONVAL = 'S' THEN @DATEFROM ELSE 'JAN  1 1900' END  
			AND  
			CASE WHEN @OPTIONVAL = 'S' THEN @DATETO + ' 23:59' ELSE 'DEC 31 2049 23:59' END
		AND INACTIVE_FROM NOT BETWEEN  
			CASE WHEN @OPTIONVAL = 'S' THEN @DATEFROM ELSE 'JAN  1 1900' END  
			AND  
			CASE WHEN @OPTIONVAL = 'S' THEN @DATETO + ' 23:59' ELSE '' END  
		AND INACTIVE_FROM BETWEEN  
			CASE WHEN @OPTIONVAL = 'I' THEN @DATEFROM ELSE 'JAN  1 1900' END  
			AND  
			CASE WHEN @OPTIONVAL = 'I' THEN @DATETO + ' 23:59' ELSE 'DEC 31 2049 23:59' END
	ORDER BY
		PARTY_CODE

/*
	UPDATE	#NSEMFSS_UCC
	SET		ACCOUNT_TYPE_1 = (
			CASE 
				WHEN LEFT(ACCTYPE,6) = 'SAVING'		THEN 'SB' 
				WHEN LEFT(ACCTYPE,7) = 'CURRENT'	THEN 'CB' 
				WHEN LEFT(ACCTYPE,3) = 'NRE'		THEN 'NE' 
				WHEN LEFT(ACCTYPE,3) = 'NRO'		THEN 'NO' 
				ELSE ''
			END),
			ACCOUNT_NO_1 = ISNULL(M.ACCNO,''),
			MICR_NO_1 = ISNULL(P.MICRNO,''),
			IFSC_CODE_1 = ISNULL(P.IFSCCODE,''),
			DEFAULT_BANK_FLAG_1 = 'Y'
	FROM	BBO_FA.DBO.MULTIBANKID M (NOLOCK) INNER JOIN POBANK P (NOLOCK) ON M.BANKID = CONVERT(VARCHAR,P.BANKID)
	WHERE 	#NSEMFSS_UCC.PARTY_CODE = M.CLTCODE
			AND M.DEFAULTBANK = 1
			AND ACCOUNT_NO_1 = ''
*/



	UPDATE	#NSEMFSS_UCC
	SET		ACCOUNT_TYPE_2 = (
			CASE 
				WHEN LEFT(ACCTYPE,6) = 'SAVING'		THEN 'SB' 
				WHEN LEFT(ACCTYPE,7) = 'CURRENT'	THEN 'CB' 
				WHEN LEFT(ACCTYPE,3) = 'NRE'		THEN 'NE' 
				WHEN LEFT(ACCTYPE,3) = 'NRO'		THEN 'NO' 
				ELSE ACCTYPE
			END),
			ACCOUNT_NO_2 = ISNULL(M.ACCNO,''),
			MICR_NO_2 = ISNULL(P.MICRNO,''),
			IFSC_CODE_2 = ISNULL(P.IFSCCODE,''),
			DEFAULT_BANK_FLAG_2 = 'N'
	FROM	BBO_FA.DBO.MULTIBANKID M (NOLOCK) INNER JOIN POBANK P (NOLOCK) ON M.BANKID = CONVERT(VARCHAR,P.BANKID)
	WHERE 	#NSEMFSS_UCC.PARTY_CODE = M.CLTCODE
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_1 
			AND M.DEFAULTBANK <> 1

	UPDATE	#NSEMFSS_UCC
	SET		ACCOUNT_TYPE_3 = (
			CASE 
				WHEN LEFT(ACCTYPE,6) = 'SAVING'		THEN 'SB' 
				WHEN LEFT(ACCTYPE,7) = 'CURRENT'	THEN 'CB' 
				WHEN LEFT(ACCTYPE,3) = 'NRE'		THEN 'NE' 
				WHEN LEFT(ACCTYPE,3) = 'NRO'		THEN 'NO' 
				ELSE ACCTYPE
			END),
			ACCOUNT_NO_3 = ISNULL(M.ACCNO,''),
			MICR_NO_3 = ISNULL(P.MICRNO,''),
			IFSC_CODE_3 = ISNULL(P.IFSCCODE,''),
			DEFAULT_BANK_FLAG_3 = 'N'
	FROM	BBO_FA.DBO.MULTIBANKID M (NOLOCK) INNER JOIN POBANK P (NOLOCK) ON M.BANKID = CONVERT(VARCHAR,P.BANKID)
	WHERE 	#NSEMFSS_UCC.PARTY_CODE = M.CLTCODE
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_1 
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_2 
			AND M.DEFAULTBANK <> 1

	UPDATE	#NSEMFSS_UCC
	SET		ACCOUNT_TYPE_4 = (
			CASE 
				WHEN LEFT(ACCTYPE,6) = 'SAVING'		THEN 'SB' 
				WHEN LEFT(ACCTYPE,7) = 'CURRENT'	THEN 'CB' 
				WHEN LEFT(ACCTYPE,3) = 'NRE'		THEN 'NE' 
				WHEN LEFT(ACCTYPE,3) = 'NRO'		THEN 'NO' 
				ELSE ACCTYPE
			END),
			ACCOUNT_NO_4 = ISNULL(M.ACCNO,''),
			MICR_NO_4 = ISNULL(P.MICRNO,''),
			IFSC_CODE_4 = ISNULL(P.IFSCCODE,''),
			DEFAULT_BANK_FLAG_4 = 'N'
	FROM	BBO_FA.DBO.MULTIBANKID M (NOLOCK) INNER JOIN POBANK P (NOLOCK) ON M.BANKID = CONVERT(VARCHAR,P.BANKID)
	WHERE 	#NSEMFSS_UCC.PARTY_CODE = M.CLTCODE
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_1 
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_2
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_3 
			AND M.DEFAULTBANK <> 1

	UPDATE	#NSEMFSS_UCC
	SET		ACCOUNT_TYPE_5 = (
			CASE 
				WHEN LEFT(ACCTYPE,6) = 'SAVING'		THEN 'SB' 
				WHEN LEFT(ACCTYPE,7) = 'CURRENT'	THEN 'CB' 
				WHEN LEFT(ACCTYPE,3) = 'NRE'		THEN 'NE' 
				WHEN LEFT(ACCTYPE,3) = 'NRO'		THEN 'NO' 
				ELSE ACCTYPE
			END),
			ACCOUNT_NO_5 = ISNULL(M.ACCNO,''),
			MICR_NO_5 = ISNULL(P.MICRNO,''),
			IFSC_CODE_5 = ISNULL(P.IFSCCODE,''),
			DEFAULT_BANK_FLAG_5 = 'N'
	FROM	BBO_FA.DBO.MULTIBANKID M (NOLOCK) INNER JOIN POBANK P (NOLOCK) ON M.BANKID = CONVERT(VARCHAR,P.BANKID)
	WHERE 	#NSEMFSS_UCC.PARTY_CODE = M.CLTCODE
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_1 
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_2
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_3 
			AND M.ACCNO <> #NSEMFSS_UCC.ACCOUNT_NO_4
			AND M.DEFAULTBANK <> 1

	
	SELECT	* FROM #NSEMFSS_UCC
	ORDER BY PARTY_CODE

	
	DROP TABLE #MFSSMASTER
	DROP TABLE #CLIENTLIST
	DROP TABLE #NSEMFSS_UCC

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_VBB_Broktabledetails
-- --------------------------------------------------

  CREATE Proc [dbo].[rpt_VBB_Broktabledetails]    
 (    
 @PARTYCODE VARCHAR(15)    
 )    
    
 As    
    
 If (Select Count(1) From Sysobjects Where Name ='Scheme_Mapping') > 0    
 Begin    
    
  Set NoCount On    
  Set Transaction Isolation Level Read Uncommitted     
      
  Select      
  SchemeDt = left(SP_Date_From,11) + ' -  ' + left(SP_Date_to,11),    
  SchemeId = SP_Scheme_Id,    
  SchemeDesc = IsNull(SM_Scheme_Desc,''),    
  SchemeType = Case     
    When SP_Trd_Type='TRD' Then 'Normal Trade'     
    When SP_Trd_Type='DEL' Then 'Delivery Trade'     
    Else '' End,    
  Symbol = Sp_Scrip ,     
  ComputationType = case SP_Brok_ComputeType when  'I' then 'Incremental' else 'Variable' end,    
  BrokComputeOn = Case When SP_Brok_ComputeOn ='T' Then 'Turnover' Else    
     Case When SP_Brok_ComputeOn ='Q' Then 'Quantity' Else    
     Case When SP_Brok_ComputeOn ='L' Then 'Lot Size' Else    
     'Value Of Lot' End End End ,    
  ComputationLevel = Case When Sp_Computation_Level ='T' Then 'Trades' Else    
     Case When Sp_Computation_Level ='O' Then 'Order' Else    
     Case When Sp_Computation_Level ='S' Then 'Scrip' Else    
      'Contract' End End End,    
  Scheme = Case When Sp_Scheme_Type=0 then 'Default' else    
     Case When Sp_Scheme_Type=1 then 'Max Logic BS FL' else     
    'Max Logic SS FL' end end,    
  ValueRange = convert(varchar,sp_value_from) + ' - ' + case when sp_value_to = -1 then 'Un Limit' else    
   convert(varchar,sp_value_to) end,    
  Brok = 'Buy ' + convert(varchar,sp_buy_brok) + Case when sp_buy_brok_type ='V' then ' Value' else ' Perc' end  +    
   ' Sell ' + convert(varchar,sp_sell_brok) + Case when sp_sell_brok_type ='V' then ' Value' else ' Perc' end,    
     
  ScrOrd = case when SP_Scrip='ALL' then 1 else 2 end,    
  RCount = 1    
  From msajag..Scheme_Mapping MP Left Outer Join msajag..Scheme_Master MS on (SM_Scheme_Id = SP_Scheme_Id)    
  Where SP_Party_Code = @PARTYCODE    
  Order By 1,3,ScrOrd    
     
 End    
 Else    
 Begin    
  Select    
  RCount = 0    
 End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDBRANCH_EXECUTE
-- --------------------------------------------------
CREATE PROC SP_ADDBRANCH_EXECUTE    
@STRSQL VARCHAR(8000)    
AS    
PRINT @STRSQL    
EXEC (@STRSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDCLIENT_EXECUTE
-- --------------------------------------------------
CREATE PROC SP_ADDCLIENT_EXECUTE    
@STRSQL VARCHAR(8000)    
AS    
PRINT @STRSQL    
EXEC (@STRSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDEDITSCRIP_EXECUTE
-- --------------------------------------------------
CREATE PROC SP_ADDEDITSCRIP_EXECUTE  
@STRSQL VARCHAR(8000)  
AS  
PRINT @STRSQL  
EXEC (@STRSQL)

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

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_MENU_RIGHTS
-- --------------------------------------------------
   CREATE PROC SP_MENU_RIGHTS   
(  
 @NOPT INT,   
 @VALIDDATE VARCHAR(20)='',  
 @NALERT INT=0  
)  
as   
  
CREATE TABLE #VERSION  
(  
  ERRCODE1 VARCHAR(100),    
  ERRCODE2 VARCHAR(20),    
  ERRCODE3 VARCHAR(2),    
  ERRCODE4 VARCHAR(10),    
  ERRCODE5 VARCHAR(10),    
  ERRCODE6 VARCHAR(100),    
  ERRCODE7 VARCHAR(100),    
  ERRCODE8 VARCHAR(100),    
  ERRCODE9 VARCHAR(100),    
  ERRCODE10 VARCHAR(10),    
  ERRCODE11 VARCHAR(100),   
  ERRCODE12 VARCHAR(100),  
  ERRCODE13 VARCHAR(100),    
  ERRCODE14 VARCHAR(100)    
)  
  
INSERT INTO #VERSION EXEC CHECKVERSION  
  
IF @NOPT =1  
BEGIN  
 SELECT ERRCODE2,ERRCODE3 FROM #VERSION  
END  
ELSE  
BEGIN  
  
 SELECT CASE  
  WHEN DATEDIFF(D,GETDATE(),@VALIDDATE)- @NALERT < 0  
  THEN ERRCODE7 + ' ' + @VALIDDATE  
  WHEN  CONVERT(VARCHAR,GETDATE(),112) >= CONVERT(VARCHAR,CONVERT(DATETIME,@VALIDDATE,112),112)  
  THEN ERRCODE6  
  ELSE ''   
 END AS USERMSG  
 FROM #VERSION   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sp_Update_delBranchMark
-- --------------------------------------------------
--CREATED BY PIYUSH
CREATE PROCEDURE [dbo].[Sp_Update_delBranchMark]
(
	@SETT_NO VARCHAR(7),
	@SETT_TYPE VARCHAR(3),
	@PARTY_CODE VARCHAR(10),
	@SCRIP_CD VARCHAR(30),
	@SERIES VARCHAR(3),
	@CERTNO VARCHAR(20),
	@DPTYPE VARCHAR(20),
	@DPID VARCHAR(20),
	@CLTDPID VARCHAR(25),
	@UNAME VARCHAR(100),
	@DELQTY NUMERIC(18,0),
	@PAYOUTQTY NUMERIC(18,0),
	@APROVED INT
)
AS
IF(@APROVED > 0)
	BEGIN
		UPDATE 
				MSAJAG..DELBRANCHMARK 
		SET 
				APROVED = 1,APROVEDDATE=GETDATE(),APROVEDBY=@UNAME
		WHERE 
				SETT_NO = @SETT_NO
				AND SETT_TYPE = @SETT_TYPE 
				AND PARTY_CODE = @PARTY_CODE
				AND SCRIP_CD = @SCRIP_CD 
				AND CERTNO = @CERTNO
				AND DPTYPE = @DPTYPE 
				AND DPID = @DPID
				AND CLTDPID = @CLTDPID 
				AND APROVED = 0 

		EXEC MSAJAG..RPT_NSEDELBRANCHMARK @SETT_NO,@SETT_TYPE,@PARTY_CODE
	END

ELSE IF @DELQTY > 0 AND @DELQTY <= @PAYOUTQTY
BEGIN
	SELECT * FROM 
			MSAJAG..DELBRANCHMARK 
	WHERE 
			SETT_NO = @SETT_NO
			AND SETT_TYPE = @SETT_TYPE AND PARTY_CODE = @PARTY_CODE
			AND SCRIP_CD = @SCRIP_CD AND CERTNO = @CERTNO
			AND DPTYPE = @DPTYPE AND DPID = @DPID
			AND CLTDPID = @CLTDPID AND APROVED = 0

	IF(@@ROWCOUNT > 0)
		BEGIN
			UPDATE 
				MSAJAG..DELBRANCHMARK 
			SET 
				DELMARKQTY = '' 
			WHERE 
				SETT_NO = @SETT_NO
				AND SETT_TYPE = @SETT_TYPE AND PARTY_CODE = @PARTY_CODE
				AND SCRIP_CD = @SCRIP_CD AND CERTNO = @CERTNO
				AND DPTYPE = @DPTYPE AND DPID = @DPID
				AND CLTDPID = @CLTDPID AND APROVED = 0
		END
	ELSE
		BEGIN
			INSERT INTO 
					MSAJAG..DELBRANCHMARK 
			VALUES
					(@SETT_NO,@SETT_TYPE,@PARTY_CODE,@SCRIP_CD,
					 @SERIES,@CERTNO,@DPTYPE,@DPID,@CLTDPID,@PAYOUTQTY,@DELQTY,'0','0',
					 GETDATE(),@UNAME,'','')
		END
END

ELSE IF @DELQTY = 0
	BEGIN
			SELECT * FROM 
				MSAJAG..DELBRANCHMARK 
			WHERE 
				SETT_NO = @SETT_NO
				AND SETT_TYPE = @SETT_TYPE AND PARTY_CODE = @PARTY_CODE
				AND SCRIP_CD = @SCRIP_CD AND CERTNO = @CERTNO
				AND DPTYPE = @DPTYPE AND DPID = @DPID
				AND CLTDPID = @CLTDPID AND APROVED = 0 

    IF(@@ROWCOUNT > 0)
		BEGIN
			DELETE FROM 
				MSAJAG..DELBRANCHMARK 
			WHERE 
				SETT_NO = SETT_NO
				AND SETT_TYPE = @SETT_TYPE AND PARTY_CODE = @PARTY_CODE
				AND SCRIP_CD = @SCRIP_CD AND CERTNO = @CERTNO
				AND DPTYPE = @DPTYPE AND DPID = @DPID
				AND CLTDPID = @CLTDPID AND APROVED = 0 
		END
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------
  

  
CREATE PROC Tbl @TblName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Add_Branch
-- --------------------------------------------------
CREATE PROC [dbo].[USP_Add_Branch]
    @BRANCH_CODE	VARCHAR(20),
	@BRANCH			VARCHAR(80),
	@LONG_NAME		VARCHAR(100),
	@ADDRESS1		VARCHAR(100),
	@ADDRESS2		VARCHAR(100),
	@CITY			VARCHAR(40),
	@STATE			VARCHAR(30),
	@NATION			VARCHAR(30),
	@ZIP			VARCHAR(30),
	@PHONE1			VARCHAR(30),
	@PHONE2			VARCHAR(30),
	@FAX			VARCHAR(30),
	@EMAIL			VARCHAR(100),
	@REMOTE			VARCHAR(1),
	@SECURITY_NET	VARCHAR(1),
	@MONEY_NET		VARCHAR(1),
	@EXCISE_REG		VARCHAR(60),
	@CONTACT_PERSON	VARCHAR(150),
	@PREFIX			VARCHAR(3),
	@REMPARTYCODE	VARCHAR(10)
	

AS
BEGIN
		DECLARE
			@ROWPOS_MAIN AS INT,
			@INSTR AS VARCHAR(500),
			@EXISTSTR AS VARCHAR(500),
			@SHAREDBLST_VAR AS VARCHAR(500),
			@EXCH_SECH_VAR AS VARCHAR(500),
			@STRSQL AS VARCHAR(8000),
			@INSTCOUNT AS INT,
			@EXISTCOUNT AS INT,
			@SHAREDBLST	AS VARCHAR(500),
			@EXCH_SEG AS VARCHAR(500)
		
		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))

		SET @ROWPOS_MAIN = 1
		SET @INSTR = ''
		SET @EXISTSTR = ''
		SET @INSTCOUNT = 0
		SET @EXISTCOUNT = 0
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				 BEGIN  
				  BREAK  
				 END  

--				 SET @STRSQL='' 
--				 SET @STRSQL="SELECT COUNT(*) FROM "+ @SHAREDBLST_VAR + "..BRANCH WITH(NOLOCK) WHERE BRANCH_CODE = '"+ @BRANCH_CODE +"'"
--				 INSERT INTO #TBLCOUNT
--				 EXEC (@STRSQL)

--				 IF (SELECT A FROM #TBLCOUNT)= 0
				  BEGIN
					SET @STRSQL ="DELETE FROM "+ @SHAREDBLST_VAR + "..BRANCH WHERE BRANCH_CODE = '"+ @BRANCH_CODE +"'"
					EXEC (@STRSQL)
					SET @STRSQL=''
					SET @STRSQL=" INSERT INTO "+ @SHAREDBLST_VAR + "..BRANCH (BRANCH_CODE,BRANCH,LONG_NAME,ADDRESS1,ADDRESS2,CITY,STATE,NATION,ZIP,PHONE1,PHONE2,FAX,EMAIL,REMOTE,SECURITY_NET,MONEY_NET,EXCISE_REG,CONTACT_PERSON,PREFIX,REMPARTYCODE)"
					SET @STRSQL=@STRSQL + " VALUES('" + @BRANCH_CODE + "', '" + @BRANCH + "', '" + @LONG_NAME + "', '" + @ADDRESS1 + "', '" + @ADDRESS2 + "', '" + @CITY + "', '" + @STATE + "', '" + @NATION + "', '" + @ZIP + "', '" + @PHONE1 + "', '" + @PHONE2 + "', '" + @FAX + "', '" + @EMAIL + "', '" + @REMOTE + "', '" + @SECURITY_NET + "', '" + @MONEY_NET + "', '" + @EXCISE_REG + "', '" + @CONTACT_PERSON + "', '" + @PREFIX + "', '" + @REMPARTYCODE + "')"
					EXEC(@STRSQL)
					IF @INSTCOUNT < 5
						BEGIN
							SET @INSTCOUNT = @INSTCOUNT + 1
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',&nbsp;'
						END
					ELSE
						BEGIN
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',<br>'
							SET @INSTCOUNT = 0
						END
				  END 
--				 ELSE 
--				  BEGIN
--					IF @EXISTCOUNT < 2
--						BEGIN
--							SET @EXISTCOUNT = @EXISTCOUNT + 1
--							SET @EXISTSTR = @EXISTSTR + @EXCH_SECH_VAR + ',&nbsp;' 
--						END
--					ELSE
--						BEGIN
--							SET @EXISTSTR = @EXISTSTR  + @EXCH_SECH_VAR + ',<br>'
--							SET @EXISTCOUNT = 0
--						END
--				  END
				DELETE FROM #TBLCOUNT 
			

			

			SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 
			print @INSTR
			print @EXISTSTR
		END 
		SET @INSTR = @INSTR + '~'
		SET @EXISTSTR = @EXISTSTR + '~'

	SELECT @BRANCH_CODE as BRANCH_CODE,REPLACE(REPLACE(@INSTR,',&nbsp;~',''),'~','') AS SUCCESS
	DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_DELIVERYDP
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADD_DELIVERYDP]   
(  
	@DPID		VARCHAR(16),
	@DPTYPE		VARCHAR(4),
	@DPCLTNO	VARCHAR(16), 
	@DESCRIPTION VARCHAR(50), 
	@ACCOUNTTYPE VARCHAR(4), 
	@LICENCENO	VARCHAR(12), 
	@EXCHANGE	VARCHAR(3), 
	@SEGMENT	VARCHAR(7), 
	@DIVACNO	VARCHAR(10), 
	@STATUS_FLAG VARCHAR(1),
	@SNO		INT  
)  
AS  
BEGIN  
 IF (SELECT COUNT(*) FROM MSAJAG..DELIVERYDP WHERE SNO=@SNO)=0
	BEGIN
		INSERT INTO MSAJAG..DELIVERYDP (DPID,DPTYPE,DPCLTNO,DESCRIPTION,ACCOUNTTYPE,LICENCENO,EXCHANGE,SEGMENT,DIVACNO,STATUS_FLAG) VALUES (@DPID, @DPTYPE, @DPCLTNO, @DESCRIPTION, @ACCOUNTTYPE, @LICENCENO, @EXCHANGE, @SEGMENT, @DIVACNO, @STATUS_FLAG)  
	END
 ELSE
	BEGIN
		UPDATE MSAJAG..DELIVERYDP SET DPID=@DPID,DPTYPE=@DPTYPE,DPCLTNO=@DPCLTNO,DESCRIPTION=@DESCRIPTION,ACCOUNTTYPE=@ACCOUNTTYPE,LICENCENO=@LICENCENO,EXCHANGE=@EXCHANGE,SEGMENT=@SEGMENT,DIVACNO=@DIVACNO,STATUS_FLAG=@STATUS_FLAG WHERE SNO=@SNO
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_INCOME
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADD_INCOME] 
(
	@RECTYPE	VARCHAR(50),
	@MINAMOUNT	NUMERIC(18,0),
	@MAXAMOUNT	NUMERIC(18,0),
	@CREATEDBY	VARCHAR(50),
	@SNO		INT 
)
AS
BEGIN
 IF (SELECT COUNT(*) FROM MSAJAG..TBL_INCOME_DETAIL WHERE SRNO=@SNO)=0
	BEGIN
		INSERT INTO MSAJAG..TBL_INCOME_DETAIL (RECTYPE,MINAMOUNT,MAXAMOUNT,CREATEDBY,CREATEDON) VALUES (@RECTYPE,@MINAMOUNT,@MAXAMOUNT,@CREATEDBY,GETDATE())
	END
 ELSE
	BEGIN
		UPDATE MSAJAG..TBL_INCOME_DETAIL SET RECTYPE=@RECTYPE,MINAMOUNT=@MINAMOUNT,MAXAMOUNT=@MAXAMOUNT,CREATEDBY=@CREATEDBY,CREATEDON=GETDATE() WHERE SRNO=@SNO  
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_PRODUCT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADD_PRODUCT]   
(  
 @PRODUCT_CODE VARCHAR(2),  
 @PRODUCT_TYPE VARCHAR(10),  
 @PRODUCT_DESC VARCHAR(50),  
 @PRODUCT_PRESUFF VARCHAR(1),  
 @PRODUCT_SUFFIX VARCHAR(2)  
)  
AS  
BEGIN  
 IF (SELECT COUNT(*) FROM MSAJAG..PRODUCT_MASTER WHERE PRODUCT_CODE=@PRODUCT_CODE)=0
	BEGIN
		INSERT INTO MSAJAG..PRODUCT_MASTER (PRODUCT_CODE,PRODUCT_TYPE,PRODUCT_DESC,PRODUCT_PRESUFF,PRODUCT_SUFFIX) VALUES (@PRODUCT_CODE, @PRODUCT_TYPE, @PRODUCT_DESC, @PRODUCT_PRESUFF, @PRODUCT_SUFFIX) 
	END
 ELSE
	BEGIN
		UPDATE MSAJAG..PRODUCT_MASTER SET PRODUCT_TYPE=@PRODUCT_TYPE,PRODUCT_DESC=@PRODUCT_DESC,PRODUCT_PRESUFF=@PRODUCT_PRESUFF,PRODUCT_SUFFIX=@PRODUCT_SUFFIX WHERE PRODUCT_CODE=@PRODUCT_CODE  
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_SCRIP
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADD_SCRIP]  
(  
 @SCRIP_CD  VARCHAR(12),  
 @SHORT_NAME  VARCHAR(50),  
 @LONG_NAME  VARCHAR(50),  
 @SERIES   VARCHAR(3),  
 @MARKET_LOT  INT,  
 @FACE_VAL  FLOAT,  
 @BOOK_CL_DT  VARCHAR(11),  
 @EXCHANGE  VARCHAR(3),  
 @BSECODE  VARCHAR(10),  
 @SECTOR   VARCHAR(10),  
 @TRACK   VARCHAR(10),  
 @CDOL_NO  VARCHAR(10),  
 @GLOBALCUSTODIAN VARCHAR(10),  
 @COMMON_CODE VARCHAR(10),  
 @INDEXNAME  VARCHAR(10),  
 @INDUSTRY  VARCHAR(10),  
 @BLOOMBERG  VARCHAR(10),  
 @RICCODE  VARCHAR(10),  
 @REUTERS  VARCHAR(10),  
 @IES   VARCHAR(10),  
 @NOOFISSUEDSHARES NUMERIC(18,4),  
 @ADRGDRRATIO NUMERIC(18,4),  
 @GEMULTIPLE  NUMERIC(18,4),  
 @GROUPFORGE  INT,  
 @RBICEILINGINDICATORFLAG VARCHAR(2),  
 @RBICEILINGINDICATORVALUE NUMERIC(18,4),  
 @STATUS   VARCHAR(10),  
 @CO_CODE  VARCHAR(6)  
)  
AS  
BEGIN  
DECLARE   
 @COCODE NUMERIC  
 IF (SELECT COUNT(*) FROM MSAJAG..SCRIP2 WHERE SCRIP_CD=@SCRIP_CD and SERIES=@SERIES )=0  
 BEGIN  
  SELECT @COCODE = MAX (CONVERT(NUMERIC,CO_CODE))+1 FROM MSAJAG..SCRIP1  
  INSERT INTO MSAJAG..SCRIP1(CO_CODE,SERIES,SHORT_NAME,LONG_NAME,MARKET_LOT,FACE_VAL,BOOK_CL_DT,DEMAT_DATE,EX_DIV_DT,EX_BON_DT,EX_RIT_DT,EQT_TYPE,SUB_TYPE,AGENT_CD,DEMAT_FLAG,RES1,RES2,RES3,RES4) VALUES(@COCODE,@SERIES,@SHORT_NAME,@LONG_NAME,@MARKET_LOT,@FACE_VAL,CONVERT(DATETIME,@BOOK_CL_DT,103),'','','','','','','','','','','','')    
  INSERT INTO MSAJAG..SCRIP2(CO_CODE,SERIES,EXCHANGE,SCRIP_CD,BSECODE,SECTOR,TRACK,CDOL_NO,GLOBALCUSTODIAN,COMMON_CODE,INDEXNAME,INDUSTRY,BLOOMBERG,RICCODE,REUTERS,IES,NOOFISSUEDSHARES,STATUS,ADRGDRRATIO,GEMULTIPLE,GROUPFORGE,RBICEILINGINDICATORFLAG,RBICEILINGINDICATORVALUE,SCRIP_CAT,NO_DEL_FR,NO_DEL_TO,CL_RATE,CLOS_RATE_DT,MIN_TRD_QTY,ISIN,DELSC_CAT,RES1,RES2,RES3,RES4) VALUES(@COCODE,@SERIES,@EXCHANGE,@SCRIP_CD,@BSECODE,@SECTOR,@TRACK,@CDOL_NO,@GLOBALCUSTODIAN,@COMMON_CODE,@INDEXNAME,@INDUSTRY,@BLOOMBERG,@RICCODE,@REUTERS,@IES,@NOOFISSUEDSHARES,@STATUS,@ADRGDRRATIO,@GEMULTIPLE,@GROUPFORGE,@RBICEILINGINDICATORFLAG,@RBICEILINGINDICATORVALUE,'','','','','',0,'','','','','','')  
 END  
 ELSE  
 BEGIN  
  UPDATE MSAJAG..SCRIP1 SET SERIES=@SERIES,SHORT_NAME=@SHORT_NAME,LONG_NAME=@LONG_NAME,MARKET_LOT=@MARKET_LOT,FACE_VAL=@FACE_VAL,BOOK_CL_DT=CONVERT(DATETIME,@BOOK_CL_DT,103) WHERE CO_CODE=@CO_CODE  
  UPDATE MSAJAG..SCRIP2 SET SERIES=@SERIES,EXCHANGE=@EXCHANGE,SCRIP_CD=@SCRIP_CD,BSECODE=@BSECODE,SECTOR=@SECTOR,TRACK=@TRACK,CDOL_NO=@CDOL_NO,GLOBALCUSTODIAN=@GLOBALCUSTODIAN,COMMON_CODE=@COMMON_CODE,INDEXNAME=@INDEXNAME,INDUSTRY=@INDUSTRY,BLOOMBERG=@BLOOMBERG,RICCODE=@RICCODE,REUTERS=@REUTERS,IES=@IES,NOOFISSUEDSHARES=@NOOFISSUEDSHARES,STATUS=@STATUS,ADRGDRRATIO=@ADRGDRRATIO,GEMULTIPLE=@GEMULTIPLE,GROUPFORGE=@GROUPFORGE,RBICEILINGINDICATORFLAG=@RBICEILINGINDICATORFLAG,RBICEILINGINDICATORVALUE=@RBICEILINGINDICATORVALUE WHERE CO_CODE=@CO_CODE  
 END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_SERIES
-- --------------------------------------------------
/*
	exec USP_ADD_SERIES '21','xyz','d',''
*/
CREATE PROCEDURE [dbo].[USP_ADD_SERIES]
(
	@SERIES VARCHAR(2),
	@DESCRIPTION VARCHAR(50),
	@FLAG VARCHAR(1),
	@UNAME VARCHAR(50),
	@IP VARCHAR(20),
	@RESULT INT = NULL OUTPUT,
	@CUSTOMERRORMESSAGE VARCHAR(MAX) = NULL OUTPUT
)
AS
BEGIN TRY
  BEGIN TRANSACTION
  IF @FLAG <> 'A'  AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('ADD/DELETE FLAGS NOT SET PROPERLY', 16, 1)
			RETURN
		END
		IF @FLAG = 'A'
		BEGIN
				IF EXISTS (SELECT SERIES FROM SERIES WHERE SERIES=@SERIES)
					BEGIN
						SET @RESULT = 0
						SET @CUSTOMERRORMESSAGE = 'SERIES ALREADY EXISTS'
					END
				ELSE
				BEGIN
					INSERT INTO SERIES(SERIES,DESCRIPTION)VALUES (@SERIES,@DESCRIPTION)
					SET @RESULT = 1
					SET @CUSTOMERRORMESSAGE = 'SERIES ADDED SUCCESSFULLY'
				END

		END
		ELSE IF @FLAG = 'D'
		BEGIN
					IF NOT EXISTS (SELECT TOP 1 SERIES FROM SERIES WHERE SERIES=@SERIES)
						BEGIN
								RAISERROR ('SERIES NOT PRESENT', 16, 1)
								SET @RESULT = 0
						END
					ELSE
						BEGIN
							INSERT INTO SERIES_LOG SELECT SERIES,DESCRIPTION,@UNAME,getdate(),'DELETE',@IP FROM SERIES WHERE SERIES=@SERIES
							DELETE FROM SERIES
							WHERE SERIES=@SERIES
							SET @RESULT = 1
							
						END
		END	

  COMMIT TRANSACTION
END TRY

BEGIN CATCH
  IF @@TRANCOUNT>0
  ROLLBACK TRANSACTION
  --SET @ISSUCCESS = 0
  SET @CUSTOMERRORMESSAGE='INSERT FAILED - TABLE NAME : SERIES'
  PRINT 'ERROR OCCURED IN INSERT SP'
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Add_SubBroker
-- --------------------------------------------------
CREATE PROC [dbo].[USP_Add_SubBroker]
    @SUB_BROKER		VARCHAR(10),
	@NAME			VARCHAR(50),
	@ADDRESS1		VARCHAR(100),
	@ADDRESS2		VARCHAR(100),
	@CITY			VARCHAR(20),
	@STATE			VARCHAR(15),
	@NATION			VARCHAR(15),
	@ZIP			VARCHAR(10),
	@FAX			VARCHAR(15),
	@PHONE1			VARCHAR(15),
	@PHONE2			VARCHAR(15),
	@REG_NO			VARCHAR(30),
	@REGISTERED		VARCHAR(1),
	@MAIN_SUB		VARCHAR(1),
	@EMAIL			VARCHAR(50),
	@COM_PERC		MONEY,
	@BRANCH_CODE	VARCHAR(10),
	@CONTACT_PERSON VARCHAR(100),
	@REMPARTYCODE	VARCHAR(10)
	
AS
/*
exec USP_Add_SubBroker @SUB_BROKER='ho',@NAME='hgch',@ADDRESS1='',@ADDRESS2='',@CITY='',@STATE='',@NATION='',@ZIP='',@FAX='',@PHONE1='',@PHONE2='',@REG_NO='',@REGISTERED='0',@MAIN_SUB='0',@EMAIL='',@COM_PERC=0.0000,@BRANCH_CODE='ABC',@CONTACT_PERSON='',@REMPARTYCODE=''
exec USP_Add_SubBroker @SUB_BROKER='HO',@NAME='Mumbai',@ADDRESS1='',@ADDRESS2='',@CITY='',@STATE='',@NATION='',@ZIP='',@FAX='',@PHONE1='',@PHONE2='',@REG_NO='',@REGISTERED='0',@MAIN_SUB='0',@EMAIL='',@COM_PERC=0.0000,@BRANCH_CODE='CHE01',@CONTACT_PERSON='',@REMPARTYCODE='',@SHAREDBLST='BSEFOPCM|BSEDB|BSEFO|BSECURFO|BSECURFOPCM|DGCX|DGCXPCM|MCDXCDS|MCDXPCM|MCDX|MCDXCDSPCM|NSEFOPCM|NCDX|NMCE|Msajag|NSEFO|NSEL|NSECURFO|NSECURFOPCM|NCDXPCM|USECURFOPCM|USECURFO|BSEMFSS|IEX|NSEMFSS',@EXCH_SEG='BCM-FUTURES|BSE-CAPITAL|BSE-FUTURES|BSX-FUTURES|BXM-FUTURES|DGX-FUTURES|DXM-FUTURES|MCD-FUTURES|MCM-FUTURES|MCX-FUTURES|MXM-FUTURES|NCM-FUTURES|NCX-FUTURES|NMC-FUTURES|NSE-CAPITAL|NSE-FUTURES|NSP-FUTURES|NSX-FUTURES|NXM-FUTURES|NXP-FUTURES|USM-FUTURES|USX-FUTURES|BSE-MFSS|IEX-FUTURES|NSE-MFSS'
*/
BEGIN
		DECLARE
			@ROWPOS_MAIN AS INT,
			@INSTR AS VARCHAR(500),
			@EXISTSTR AS VARCHAR(500),
			@SHAREDBLST_VAR AS VARCHAR(500),
			@EXCH_SECH_VAR AS VARCHAR(500),
			@STRSQL AS VARCHAR(8000),
			@INSTCOUNT AS INT,
			@EXISTCOUNT AS INT,
			@SHAREDBLST	AS VARCHAR(500),
			@EXCH_SEG AS VARCHAR(500)
		
		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))

		SET @ROWPOS_MAIN = 1
		SET @INSTR = ''
		SET @EXISTSTR = ''
		SET @INSTCOUNT = 0
		SET @EXISTCOUNT = 0
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				 BEGIN  
				  BREAK  
				 END  

--				 SET @STRSQL='' 
--				 SET @STRSQL="SELECT COUNT(*) FROM "+ @SHAREDBLST_VAR + "..SUBBROKERS WITH(NOLOCK) WHERE SUB_BROKER = '"+ @SUB_BROKER +"'" -- AND  BRANCH_CODE='" + @BRANCH_CODE + "'" 
--				 INSERT INTO #TBLCOUNT
--				 EXEC (@STRSQL)
--
--				 IF (SELECT A FROM #TBLCOUNT)= 0
				  BEGIN
					SET @STRSQL ="DELETE FROM "+ @SHAREDBLST_VAR + "..SUBBROKERS WHERE SUB_BROKER = '"+ @SUB_BROKER +"'"
					EXEC (@STRSQL)
					SET @STRSQL=''
					SET @STRSQL=" INSERT INTO "+ @SHAREDBLST_VAR + "..SUBBROKERS (SUB_BROKER,NAME,ADDRESS1,ADDRESS2,CITY,STATE,NATION,ZIP,FAX,PHONE1,PHONE2,REG_NO,REGISTERED,MAIN_SUB,EMAIL,COM_PERC,BRANCH_CODE,CONTACT_PERSON,REMPARTYCODE)"
					SET @STRSQL=@STRSQL + " VALUES('" + @SUB_BROKER + "','" + @NAME + "','" + @ADDRESS1 + "','" + @ADDRESS2 + "','" + @CITY + "', '" + @STATE + "', '" + @NATION + "', '" + @ZIP + "','" + @FAX + "', '" + @PHONE1 + "', '" + @PHONE2 + "', '" + @REG_NO + "', '" + @REGISTERED + "', '" + @MAIN_SUB + "', '" + @EMAIL + "', " + CONVERT(VARCHAR(20), @COM_PERC) + ", '" + @BRANCH_CODE + "', '" + @CONTACT_PERSON + "','" + @REMPARTYCODE + "')"
					EXEC(@STRSQL)
					IF @INSTCOUNT < 5
						BEGIN
							SET @INSTCOUNT = @INSTCOUNT + 1
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',&nbsp;'
						END
					ELSE
						BEGIN
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',<br>'
							SET @INSTCOUNT = 0
						END
				  END 
--				 ELSE 
--				  BEGIN
--					IF @EXISTCOUNT < 2
--						BEGIN
--							SET @EXISTCOUNT = @EXISTCOUNT + 1
--							SET @EXISTSTR = @EXISTSTR + @EXCH_SECH_VAR + ',&nbsp;' 
--						END
--					ELSE
--						BEGIN
--							SET @EXISTSTR = @EXISTSTR  + @EXCH_SECH_VAR + ',<br>'
--							SET @EXISTCOUNT = 0
--						END
--				  END
				DELETE FROM #TBLCOUNT 
			

			

			SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 
			print @INSTR
			print @EXISTSTR
		END 
		SET @INSTR = @INSTR + '~'
		SET @EXISTSTR = @EXISTSTR + '~'

	SELECT @SUB_BROKER as SUBBROKERS_CODE,REPLACE(REPLACE(@INSTR,',&nbsp;~',''),'~','') AS SUCCESS
	DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADD_TRADER
-- --------------------------------------------------
CREATE PROC [dbo].[USP_ADD_TRADER]  
 @BRANCH_CD  VARCHAR(50),  
 @SHORT_NAME  VARCHAR(20),  
 @LONG_NAME  VARCHAR(50),  
 @ADDRESS1  VARCHAR(25),  
 @ADDRESS2  VARCHAR(25),  
 @CITY   VARCHAR(20),  
 @STATE   VARCHAR(15),  
 @NATION   VARCHAR(15),  
 @ZIP   VARCHAR(15),  
 @PHONE1   VARCHAR(15),  
 @PHONE2   VARCHAR(15),  
 @FAX   VARCHAR(15),  
 @EMAIL   VARCHAR(50),  
 @REMOTE   VARCHAR(1),  
 @SECURITY_NET VARCHAR(1),  
 @MONEY_NET  VARCHAR(1),  
 @EXCISE_REG  VARCHAR(30),  
 @CONTACT_PERSON VARCHAR(25),  
 @COM_PERC  MONEY,  
 @TERMINAL_ID VARCHAR(10),  
 @DEFTRADER  INT  
   
AS  
/*  

exec USP_ADD_TRADER @BRANCH_CD='ABC',@SHORT_NAME='Mumbai',@LONG_NAME='HO',@ADDRESS1='',@ADDRESS2='',@CITY='',@STATE='',@NATION='',@ZIP='',@PHONE1='',@PHONE2='',@FAX='',@EMAIL='',@REMOTE='0',@SECURITY_NET='',@MONEY_NET='',@EXCISE_REG='',@CONTACT_PERSON='',
@COM_PERC=0.0000,@TERMINAL_ID='',@DEFTRADER=0

exec USP_ADD_TRADER @BRANCH_CD='ABC',@SHORT_NAME='Mumbai',@LONG_NAME='HO',@ADDRESS1='',@ADDRESS2='',@CITY='',@STATE='',@NATION='',@ZIP='',@PHONE1='',@PHONE2='',@FAX='',@EMAIL='',@REMOTE='0',@SECURITY_NET='',@MONEY_NET='',@EXCISE_REG='',@CONTACT_PERSON='',
@COM_PERC=0.0000,@TERMINAL_ID='',@DEFTRADER=0,@SHAREDBLST='NSEMFSS',@EXCH_SEG='NSE-MFSS'  
*/  
BEGIN  
  DECLARE  
   @ROWPOS_MAIN AS INT,  
   @INSTR AS VARCHAR(500),  
   @EXISTSTR AS VARCHAR(500),  
   @SHAREDBLST_VAR AS VARCHAR(500),  
   @EXCH_SECH_VAR AS VARCHAR(500),  
   @STRSQL AS VARCHAR(8000),  
   @INSTCOUNT AS INT,  
   @EXISTCOUNT AS INT,  
   @SHAREDBLST AS VARCHAR(500),  
   @EXCH_SEG AS VARCHAR(500)  
    
  SET @SHAREDBLST=''  
  SET @EXCH_SEG=''  
   
  SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'  
  CREATE TABLE #TBLCOUNT (A VARCHAR(10))  
  
  SET @ROWPOS_MAIN = 1  
  SET @INSTR = ''  
  SET @EXISTSTR = ''  
  SET @INSTCOUNT = 0  
  SET @EXISTCOUNT = 0  
  WHILE 1 = 1    
  BEGIN    
     SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))    
     SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))  
    IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''    
     BEGIN    
      BREAK    
     END    
  
--     SET @STRSQL=''   
--     SET @STRSQL="SELECT COUNT(*) FROM "+ @SHAREDBLST_VAR + "..BRANCHES WITH(NOLOCK) WHERE LONG_NAME = '"+ @LONG_NAME +"'"  
--     INSERT INTO #TBLCOUNT  
--     EXEC (@STRSQL)  
--  
--     IF (SELECT A FROM #TBLCOUNT)= 0  
      BEGIN  
     SET @STRSQL ="DELETE FROM " + @SHAREDBLST_VAR + "..BRANCHES WHERE SHORT_NAME = '"+ @SHORT_NAME +"'"  
     EXEC (@STRSQL)  
     SET @STRSQL=''  
     SET @STRSQL=@STRSQL + " INSERT INTO "+ @SHAREDBLST_VAR + "..BRANCHES (BRANCH_CD,SHORT_NAME,LONG_NAME,ADDRESS1,ADDRESS2,CITY,STATE,NATION,ZIP,PHONE1,PHONE2,FAX,EMAIL,REMOTE,"
     set @STRSQL=@STRSQL + " SECURITY_NET,MONEY_NET,EXCISE_REG,CONTACT_PERSON,COM_PERC,TERMINAL_ID,DEFTRADER)"  
     SET @STRSQL=@STRSQL + " VALUES('" + @BRANCH_CD + "', '" + @SHORT_NAME + "', '" + @LONG_NAME + "', '" + @ADDRESS1 + "', '" + @ADDRESS2 + "', '" + @CITY + "', '" + @STATE + "', '" + @NATION + "', '" + @ZIP + "', '" + @PHONE1 + "', '" + @PHONE2 + "', '"+ @FAX + "', '" + @EMAIL + "', '" + @REMOTE + "', '" + @SECURITY_NET + "', '" + @MONEY_NET + "', '" + @EXCISE_REG + "', '" + @CONTACT_PERSON + "', '" + CONVERT(VARCHAR(20), @COM_PERC) + "', '" + @TERMINAL_ID + "', '" + convert(varchar(20),@DEFTRADER) + "')"  
     EXEC(@STRSQL)  
     IF @INSTCOUNT < 5  
      BEGIN  
       SET @INSTCOUNT = @INSTCOUNT + 1  
       SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',&nbsp;'  
      END  
     ELSE  
      BEGIN  
       SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',<br>'  
       SET @INSTCOUNT = 0  
      END  
      END   
--     ELSE   
--      BEGIN  
--     IF @EXISTCOUNT < 2  
--      BEGIN  
--       SET @EXISTCOUNT = @EXISTCOUNT + 1  
--       SET @EXISTSTR = @EXISTSTR + @EXCH_SECH_VAR + ',&nbsp;'   
--      END  
--     ELSE  
--      BEGIN  
--       SET @EXISTSTR = @EXISTSTR  + @EXCH_SECH_VAR + ',<br>'  
--       SET @EXISTCOUNT = 0  
--      END  
--      END  
    DELETE FROM #TBLCOUNT   
     
  
     
  
   SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1   
   print @INSTR  
   print @EXISTSTR  
  END   
  SET @INSTR = @INSTR + '~'  
  SET @EXISTSTR = @EXISTSTR + '~'  
  
 SELECT @LONG_NAME as TRADER_CODE,REPLACE(REPLACE(@INSTR,',&nbsp;~',''),'~','') AS SUCCESS  
 DROP TABLE #TBLCOUNT   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADDEDIT_CUSTODIAN
-- --------------------------------------------------
/*
EXEC USP_ADDEDIT_CUSTODIAN 'FGFG','ABC','ASASs','','','','','','','','','','','','',''
EXEC USP_ADDEDIT_CUSTODIAN 'HDFC121','HDFC','HDFC BANK1','Mumbai','Mumbai','Mumbai','MAHA','INDIA','400595','989898667','989898667','989898667','adads@ds.com','SDFG','GGHDF','SGSF'
	
*/
CREATE PROCEDURE [dbo].[USP_ADDEDIT_CUSTODIAN]
	(	 
		 @CUSTODIANCODE VARCHAR(15),  
		 @SHORT_NAME VARCHAR(21),  
		 @LONG_NAME VARCHAR(50),  
		 @ADDRESS1 VARCHAR(50),  
		 @ADDRESS2 VARCHAR(50),  
		 @CITY VARCHAR(50),  
		 @STATE VARCHAR(50),  
		 @NATION VARCHAR(50),  
		 @ZIP VARCHAR(10),  
		 @FAX VARCHAR(10),  
		 @OFF_PHONE1 VARCHAR(10),  
		 @OFF_PHONE2 VARCHAR(10),  
		 @EMAIL VARCHAR(50),  
		 @EXCHCODE VARCHAR(16),  
		 @STPCODE VARCHAR(16),  
		 @SEBIREGNO VARCHAR(15)
	)
AS
BEGIN
		DECLARE
		@ROWPOS_MAIN AS INT,
		@INSTR AS VARCHAR(500),
		@EXISTSTR AS VARCHAR(500),
		@SHAREDBLST_VAR AS VARCHAR(500),
		@EXCH_SECH_VAR AS VARCHAR(500),
		@SQL AS VARCHAR(8000),
		@SQL1 AS VARCHAR(8000),
		@INSTCOUNT AS INT,
		@EXISTCOUNT AS INT,
		@SHAREDBLST	AS VARCHAR(500),
		@EXCH_SEG AS VARCHAR(500)
		
		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		print @SHAREDBLST
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))
		SET @ROWPOS_MAIN = 1
		SET @INSTR = ''
		SET @EXISTSTR = ''
		SET @INSTCOUNT = 0
		SET @EXISTCOUNT = 0
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				 BEGIN  
				  BREAK  
				 END  
				 BEGIN
				    --SET @SQL1="ALTER TABLE "+ @SHAREDBLST_VAR + ".DBO.Custodian ALTER COLUMN Email varchar(50)"
				    --EXEC (@SQL1)
					SET @SQL ="DELETE FROM "+ @SHAREDBLST_VAR + ".DBO.CUSTODIAN WHERE CUSTODIANCODE = '"+ @CUSTODIANCODE +"'"
					EXEC (@SQL)
					SET @SQL=''
					SET @SQL=" INSERT INTO "+ @SHAREDBLST_VAR + ".DBO.CUSTODIAN (CUSTODIANCODE,SHORT_NAME,LONG_NAME,ADDRESS1,ADDRESS2,CITY,STATE,NATION,ZIP,FAX,OFF_PHONE1,OFF_PHONE2,EMAIL,CLTDPNO,DPID,SEBIREGNO)"
					SET @SQL=@SQL + " VALUES('" + @CUSTODIANCODE + "', '" + @SHORT_NAME + "', '" + @LONG_NAME + "', '" + @ADDRESS1 + "', '" + @ADDRESS2 + "', '" + @CITY + "', '" + @STATE + "', '" + @NATION + "', '" + @ZIP + "', '" + @FAX + "', '" + @OFF_PHONE1 + "', '" + @OFF_PHONE2 + "', '" + @EMAIL + "', '" + @EXCHCODE + "', '" + @STPCODE  + "', '" + @SEBIREGNO + "')"
					print @SQL
					EXEC(@SQL)
					IF @INSTCOUNT < 5
						BEGIN
							SET @INSTCOUNT = @INSTCOUNT + 1
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',&nbsp;'
						END
					ELSE
						BEGIN
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',<br>'
							SET @INSTCOUNT = 0
						END
				  END 
				  DELETE FROM #TBLCOUNT 
				  
				  SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 
			print @INSTR
			print @EXISTSTR
		END 
		SET @INSTR = @INSTR + '~'
		SET @EXISTSTR = @EXISTSTR + '~'

	SELECT @CUSTODIANCODE as CUSTODIANCODE,REPLACE(REPLACE(@INSTR,',&nbsp;~',''),'~','') AS SUCCESS
	DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADDEDIT_TERMINAL
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADDEDIT_TERMINAL]
(
	@TERMINALID VARCHAR(20),
	@TRADELIMIT MONEY,
	@FLAG VARCHAR(1),
	@UNAME VARCHAR(50),
	@RESULT INT = NULL OUTPUT 
)
AS
BEGIN TRY
  BEGIN TRANSACTION
  IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('ADD/EDIT FLAGS NOT SET PROPERLY', 16, 1)
			RETURN
		END
	IF @FLAG = 'A'
		BEGIN
					IF EXISTS (SELECT USERID FROM TERMLIMIT WHERE USERID=@TERMINALID)
					BEGIN
						SET @RESULT = 0
					END
					ELSE
					BEGIN
						UPDATE TERMLIMIT_LOG SET FLAG =1 WHERE USERID = @TERMINALID
						INSERT INTO TERMLIMIT_LOG VALUES (@TERMINALID,@TRADELIMIT,@UNAME,getdate(),'ADD',0)
						
						INSERT INTO TERMLIMIT(USERID,TRADELIMIT)VALUES (@TERMINALID,@TRADELIMIT)
						SET @RESULT = 1
					END
		END
	ELSE IF @FLAG = 'E'
		BEGIN
					IF NOT EXISTS (SELECT TOP 1 USERID FROM TERMLIMIT WHERE USERID = @TERMINALID)
						BEGIN
								SET @RESULT = 0
						END
					ELSE
						BEGIN
							--DECLARE @OLDTLIMIT MONEY
							--SET @OLDTLIMIT=(SELECT TRADELIMIT FROM TERMLIMIT WHERE USERID =@TERMINALID)
							--INSERT INTO TERMLIMIT_LOG (USERID,TRADELIMIT,MODIFIEDBY,MODIFIEDON,MODE,FLAG) VALUES 
							--(@TERMINALID,@OLDTLIMIT,@UNAME,getdate(),'EDIT',0)
							
							INSERT INTO TERMLIMIT_LOG SELECT USERID,TRADELIMIT,@UNAME,getdate(),'EDIT',0 FROM TERMLIMIT WHERE USERID =@TERMINALID

							UPDATE TERMLIMIT SET TRADELIMIT = @TRADELIMIT WHERE USERID = @TERMINALID
							SET @RESULT = 1
						END
				
		END
	ELSE IF @FLAG = 'D'
		BEGIN
					IF NOT EXISTS (SELECT TOP 1 USERID FROM TERMLIMIT WHERE USERID = @TERMINALID)
						BEGIN
								RAISERROR ('TERMINAL NOT PRESENT', 16, 1)
								SET @RESULT = 0
						END
					ELSE
						BEGIN
							INSERT INTO TERMLIMIT_LOG SELECT USERID,TRADELIMIT,@UNAME,getdate(),'DELETE',0 FROM TERMLIMIT WHERE USERID =@TERMINALID
							DELETE FROM TERMLIMIT
							WHERE USERID = @TERMINALID
							SET @RESULT = 1
							
						END
		END
 COMMIT TRANSACTION
END TRY

BEGIN CATCH
  IF @@TRANCOUNT>0
  ROLLBACK TRANSACTION
  PRINT 'ERROR OCCURED IN INSERT SP'
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADDEDITDEL_MAPTERMINALID
-- --------------------------------------------------
/*
BEGIN TRAN
EXEC USP_ADDEDITDEL_MAPTERMINALID '12345678','0A141','2','b','A','DEMO',''
ROLLBACK
*/

CREATE PROCEDURE [dbo].[USP_ADDEDITDEL_MAPTERMINALID]
(
	@USER_ID VARCHAR(15),
	@PARTY_CODE VARCHAR(50),
	@PRO_CLI VARCHAR(50),
	@EXCEPT_PARTY VARCHAR(50),
	@FLAG   VARCHAR(1),
	@UNAME VARCHAR(50),
	@RESULT INT = NULL OUTPUT 
)
AS
BEGIN TRY
  BEGIN TRANSACTION
  IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('ADD/EDIT FLAGS NOT SET PROPERLY', 16, 1)
			RETURN
		END
	IF @FLAG = 'A'
		BEGIN
					IF NOT EXISTS (SELECT TOP 1 USERID FROM TERMLIMIT WHERE USERID = @USER_ID)
						BEGIN
								SET @RESULT = 0
								PRINT @RESULT
						END
					ELSE IF NOT EXISTS (SELECT TOP 1 PARTY_CODE FROM CLIENT2 WHERE PARTY_CODE = @PARTY_CODE)
						BEGIN
								SET @RESULT = 1
								PRINT @RESULT
						END
					ELSE IF NOT EXISTS (SELECT TOP 1 PARTY_CODE FROM CLIENT2 WHERE PARTY_CODE = @EXCEPT_PARTY)AND @EXCEPT_PARTY<>''
								BEGIN
										SET @RESULT = 2
										PRINT @RESULT
								END
						
					ELSE IF EXISTS (SELECT USERID,PARTY_CODE,EXCEPTPARTY FROM TERMPARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE AND EXCEPTPARTY=@EXCEPT_PARTY)
					BEGIN
						SET @RESULT = 3
						
						PRINT @RESULT
					END
					ELSE 
					BEGIN
						UPDATE TERMPARTY_LOG SET FLAG =1 WHERE USERID = @USER_ID AND PARTY_CODE=@PARTY_CODE 
						INSERT INTO TERMPARTY_LOG VALUES (@USER_ID,@PARTY_CODE,@PRO_CLI,@EXCEPT_PARTY,@UNAME,getdate(),'ADD',0)
						
						INSERT INTO TERMPARTY(USERID,PARTY_CODE,PROCLI,EXCEPTPARTY)VALUES (@USER_ID,@PARTY_CODE,@PRO_CLI,@EXCEPT_PARTY)
						SET @RESULT = 4
						PRINT @RESULT
					END
		END
	ELSE IF @FLAG = 'E'
		BEGIN
					IF NOT EXISTS (SELECT USERID,PARTY_CODE,PROCLI,EXCEPTPARTY FROM TERMPARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE)
						BEGIN
								SET @RESULT = 0
								print @RESULT
						END
					ELSE
						BEGIN
							
							INSERT INTO TERMPARTY_LOG SELECT USERID,PARTY_CODE,PROCLI,EXCEPTPARTY,@UNAME,getdate(),'EDIT',0 FROM TERMPARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE
							
							UPDATE TERMPARTY SET PROCLI = @PRO_CLI,EXCEPTPARTY=@EXCEPT_PARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE
							SET @RESULT = 1
							print @RESULT
						END
				
		END
	ELSE IF @FLAG = 'D'
		BEGIN
					IF NOT EXISTS (SELECT USERID,PARTY_CODE,PROCLI,EXCEPTPARTY FROM TERMPARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE)
						BEGIN
								RAISERROR ('TERMINAL MAP NOT PRESENT', 16, 1)
								SET @RESULT = 0
						END
					ELSE
						BEGIN
							INSERT INTO TERMPARTY_LOG SELECT USERID,PARTY_CODE,PROCLI,EXCEPTPARTY,@UNAME,getdate(),'DELETE',0 FROM TERMPARTY WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE
							DELETE FROM TERMPARTY
							WHERE USERID=@USER_ID AND PARTY_CODE=@PARTY_CODE
							SET @RESULT = 1
							
						END
		END
 COMMIT TRANSACTION
END TRY

BEGIN CATCH
  IF @@TRANCOUNT>0
  ROLLBACK TRANSACTION
  PRINT 'ERROR OCCURED IN INSERT SP'
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADDEDITDEL_PARTYMAPPING
-- --------------------------------------------------

/*
BEGIN TRAN
EXEC USP_ADDEDITDEL_PARTYMAPPING '011','0A141','E',''
ROLLBACK
*/

CREATE PROCEDURE [dbo].[USP_ADDEDITDEL_PARTYMAPPING]
(
	@OLDPARTY_CODE VARCHAR(12),
	@NEWPARTY_CODE VARCHAR(12),
	@FLAG VARCHAR(1),
	@RESULT INT = NULL OUTPUT 
)
AS 
BEGIN TRY
  BEGIN TRANSACTION
  IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('ADD/EDIT FLAGS NOT SET PROPERLY', 16, 1)
			RETURN
		END
	IF @FLAG = 'A'
		BEGIN
				IF NOT EXISTS (SELECT TOP 1 PARTY_CODE FROM CLIENT2 WHERE PARTY_CODE = @NEWPARTY_CODE)
						BEGIN
								SET @RESULT = 0
								PRINT @RESULT
						END
				ELSE IF EXISTS (SELECT TOP 1 OLDPARTY_CODE FROM PARTYMAPPING WHERE OLDPARTY_CODE=@OLDPARTY_CODE)
						BEGIN
								SET @RESULT=1
								PRINT @RESULT 
						END	
				ELSE 
						BEGIN
						 INSERT INTO PARTYMAPPING(OLDPARTY_CODE,NEWPARTY_CODE) VALUES (@OLDPARTY_CODE,@NEWPARTY_CODE)
						 SET @RESULT=2
						 PRINT @RESULT 
						END	
		END
	ELSE IF @FLAG = 'E'
		BEGIN
			IF NOT EXISTS (SELECT TOP 1 PARTY_CODE FROM CLIENT2 WHERE PARTY_CODE = @NEWPARTY_CODE)
						BEGIN
								SET @RESULT = 0
								PRINT @RESULT
						END
			ELSE IF EXISTS (SELECT TOP 1 OLDPARTY_CODE FROM PARTYMAPPING WHERE NEWPARTY_CODE=@NEWPARTY_CODE)
						BEGIN
								SET @RESULT=1
								PRINT @RESULT 
						END
			ELSE
				BEGIN
						UPDATE PARTYMAPPING SET NEWPARTY_CODE = @NEWPARTY_CODE WHERE OLDPARTY_CODE=@OLDPARTY_CODE
						SET @RESULT = 2
				END
		END
	ELSE IF @FLAG = 'D'
		BEGIN
			
					IF NOT EXISTS (SELECT OLDPARTY_CODE,NEWPARTY_CODE FROM PARTYMAPPING WHERE OLDPARTY_CODE=@OLDPARTY_CODE)
						BEGIN
								RAISERROR ('PARTY MAP NOT PRESENT', 16, 1)
								SET @RESULT = 0
						END
					ELSE
						BEGIN
							DELETE FROM PARTYMAPPING WHERE NEWPARTY_CODE=@NEWPARTY_CODE AND OLDPARTY_CODE=@OLDPARTY_CODE
							SET @RESULT = 1
						END
		END
 COMMIT TRANSACTION
END TRY

BEGIN CATCH
  IF @@TRANCOUNT>0
  ROLLBACK TRANSACTION
  PRINT 'ERROR OCCURED IN INSERT SP'
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_EXCEPTION_BROK_RPT
-- --------------------------------------------------
  CREATE  PROCEDURE [dbo].[USP_EXCEPTION_BROK_RPT]   
 (  
 
 @FROMDATE VARCHAR(11),  
 @TODATE VARCHAR(11),
 @ORDERBY CHAR(1)
 )  
  /*
  EXEC USP_EXCEPTION_BROK_RPT 'FEB 2 2000','FEB 2 2012','P'
  */
 AS  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON  
SELECT S.PARTY_CODE,
CONVERT(VARCHAR,S.SAUDA_DATE,103)SAUDA_DATE, 
PARTY_NAME=LONG_NAME,
CL_TYPE,
PTRADEDQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) ,
PTRADEDAMT = SUM(CASE WHEN SELL_BUY = 1 THEN 
TRADEQTY*(PRICE+STRIKE_PRICE) ELSE 0 END), 
STRADEDQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) ,  
STRADEDAMT = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*(PRICE+STRIKE_PRICE) ELSE 0 END), 
BUYBROKERAGE = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY*BROKAPPLIED ELSE 0 END),  
SELBROKERAGE = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*BROKAPPLIED ELSE 0 END),  
BUYDELIVERYCHRG = 0,
SELLDELIVERYCHRG = 0,  
BILLPAMT = 0,  
BILLSAMT = 0, 
PMARKETRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0 THEN  SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY*PRICE ELSE 0 END) / SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) ELSE 0 END ) ,
SMARKETRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0 THEN  SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*PRICE ELSE 0 END) / SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) ELSE 0 END ) , 
PNETRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0 THEN  SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY*NETRATE ELSE 0 END) / SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) ELSE 0 END ) ,  
SNETRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0 THEN  SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY*NETRATE ELSE 0 END) / SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) ELSE 0 END ) , 
TRDAMT= SUM(CASE WHEN OPTION_TYPE IN ('CA','PA') THEN TRADEQTY*STRIKE_PRICE ELSE TRADEQTY*PRICE END) ,
DELAMT=0, SERINEX=0, SERVICE_TAX= SUM(SERVICE_TAX) ,
EXSERVICE_TAX= 0,TURN_TAX=SUM(TURN_TAX),
SEBI_TAX=SUM(SEBI_TAX),
INS_CHRG=SUM(INS_CHRG),BROKER_CHRG=SUM(BROKER_CHRG),
OTHER_CHRG=SUM(S.OTHER_CHRG),
MEMBERTYPE='',
COMPANYNAME='',
PNL = 0,
TOTALBROKERAGE = SUM(TRADEQTY*BROKAPPLIED),
YEAR(S.SAUDA_DATE),MONTH(SAUDA_DATE),DAY(SAUDA_DATE)
FROM  FOSETTLEMENT S,CLIENT1 C1,CLIENT2 C2  
WHERE S.PARTY_CODE =  C2.PARTY_CODE  
AND C1.CL_CODE = C2.CL_CODE  
AND S.SAUDA_DATE   BETWEEN  @FROMDATE AND @TODATE + ' 23:59' 
GROUP BY S.PARTY_CODE,CONVERT(VARCHAR,S.SAUDA_DATE,103), YEAR(S.SAUDA_DATE),MONTH(SAUDA_DATE),DAY(SAUDA_DATE),LONG_NAME,CL_TYPE
ORDER BY 
(CASE   
   WHEN @ORDERBY ='P'   
   THEN S.PARTY_CODE
   ELSE   
   (CASE   
    WHEN @ORDERBY ='N'   
    THEN LONG_NAME 
    ELSE ''
		--(CASE 
		-- WHEN @ORDERBY ='D'
		-- THEN YEAR(S.SAUDA_DATE),MONTH(SAUDA_DATE),DAY(SAUDA_DATE),S.PARTY_CODE
		-- ELSE ''
		-- END)
   END)  
  END),YEAR(S.SAUDA_DATE),MONTH(SAUDA_DATE),DAY(SAUDA_DATE)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_MULTIBANK_DETAIL
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GET_MULTIBANK_DETAIL]
(
	
	/*@SHAREDB VARCHAR(20),*/
	@CLTCODE VARCHAR(10)
)
AS
BEGIN
	IF(SELECT COUNT(1) ACNAME FROM ACMAST WHERE CLTCODE=@CLTCODE)<=0
	BEGIN
		  RAISERROR('PARTY CODE DOSE NOT EXIST.', 16, 1)
		  RETURN   
	END
	ELSE
		BEGIN
			PRINT "A"
			SELECT DISTINCT MB.SRNO,MB.MIMETYPE,MB.BANKID,MB.CLTCODE,MB.CHEQUEIMG,B.BANK_NAME,B.BRANCH_NAME,MB.ACCNO,MB.ACCTYPE,MB.CHEQUENAME,B.IFSC_CODE AS IFSCCODE,MB.DEFAULTBANK ,A.ACNAME,MB.ISPOSTED
			FROM MULTIBANKID_MAKER MB,RBIBANKMASTER B,ACMAST A
			WHERE MB.CLTCODE=@CLTCODE AND MB.CLTCODE= A.CLTCODE AND B.RBI_BANKID=MB.BANKID 
		END
END 

/*EXEC USP_GET_MULTIBANK_DETAIL '0A14'*/
SELECT COUNT(1) FROM ACMAST WHERE CLTCODE='0A14'
/*select * from multibankid_maker where cltcode='0a141'*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_SHAREDBLIST
-- --------------------------------------------------
/*
exec USP_GET_SHAREDBLIST 'BCM-FUTURES|DGX-FUTURES|MXM-FUTURES'
select SHAREDB from ..VW_MULTICOMPANY WHERE PRIMARYSERVER = 1 and EXCHANGE='BCM' and SEGMENT='FUTURES'
*/
CREATE PROC [dbo].[USP_GET_SHAREDBLIST]
	@EXCH_SEG  VARCHAR(500)
AS
DECLARE 
	@ROWPOS AS INT,
	@EXSE_DATA AS VARCHAR(500),
	@EXCH_DATA AS VARCHAR(500),
	@SEGH_DATA AS VARCHAR(500),
	@STRSHAREDB AS VARCHAR(500)

SET @STRSHAREDB  = '' 
SET @ROWPOS = 1

 WHILE 1 = 1  
  BEGIN  
	SET @EXSE_DATA = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG, '|', @ROWPOS)))  
	SET @EXCH_DATA = LTRIM(RTRIM(.DBO.PIECE(@EXSE_DATA, '-', 1)))
	SET @SEGH_DATA = LTRIM(RTRIM(.DBO.PIECE(@EXSE_DATA, '-', 2)))
	
	IF @EXSE_DATA IS NULL OR @EXSE_DATA = ''  
	BEGIN  
     BREAK  
    END  
	
	SELECT  @STRSHAREDB = SHAREDB + '|' + @STRSHAREDB 
	FROM
		..VW_MULTICOMPANY 
   WHERE 
		PRIMARYSERVER = 1 AND 
		EXCHANGE = @EXCH_DATA AND 
		SEGMENT=@SEGH_DATA
  
  SET @ROWPOS = @ROWPOS + 1
  END
  SET @STRSHAREDB = @STRSHAREDB + '~'
SELECT SDBLIST=REPLACE(@STRSHAREDB,'|~','')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IMPORT_EXCHANGE_FILE
-- --------------------------------------------------
CREATE PROC [dbo].[USP_IMPORT_EXCHANGE_FILE]
(
	 @PROGID VARCHAR(11),
	 @TRADEDATE VARCHAR(11),
	 @FILETYPE VARCHAR(10),
	 @UNAME VARCHAR(25),
	 @INTMODE INT   
)
/*
	SELECT * FROM CLASSFILEUPD 
*/
AS

BEGIN 

INSERT INTO 
	CLASSFILEUPD
SELECT 
	FILEDATA,PROGID FROM CLASSAPP..FILE_DATA WHERE PROGID = @PROGID 
	
IF(SELECT COUNT(1) FROM CLASSFILEUPD WHERE SESSION_ID = @PROGID) > 0
 BEGIN
	EXEC PR_IMPORT_FILE @FILETYPE, @PROGID, @UNAME, @TRADEDATE, @INTMODE
 END
 
DELETE FROM CLASSFILEUPD WHERE SESSION_ID = @PROGID 	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_OWNER_BANK_EDIT
-- --------------------------------------------------
CREATE PROC [dbo].[USP_OWNER_BANK_EDIT]
(
	@COMPANY		VARCHAR (50),
	@ADDR1			VARCHAR (30),
	@ADDR2			VARCHAR (30),
	@PHONE			VARCHAR (25),
	@ZIP			VARCHAR (6),
	@CITY			VARCHAR (20),
	@PANNO			VARCHAR (50),
	@FAX			VARCHAR (25),
	@STATE			VARCHAR (50),
	@EMAIL			VARCHAR (100),
	@SERVICES_TAXNO VARCHAR (30),
	@NSECMCODE      VARCHAR (20),
	@SEBINO			VARCHAR (20),
	@TM_CODE		VARCHAR (10),
	@WEBSITE_ID     VARCHAR (100),
	@ADDR3			VARCHAR (50),
	@COUNTRY        VARCHAR (20),
	@OFF_ADDR1      VARCHAR (50),
	@OFF_ADDR2      VARCHAR (50),
	@OFF_ADDR3      VARCHAR (50),
	@OFF_PHONE      VARCHAR (20),
	@DEL_PHONE1     VARCHAR (20),
	@OFF_FAX        VARCHAR (20),
	@OFF_ZIP        VARCHAR (6),
	@OFF_CITY       VARCHAR (50),
	@OFF_EMAIL      VARCHAR (50),
	@OFF_STATE      VARCHAR (50),
	@OFF_COUNTRY    VARCHAR (20),
	@CORP_ADDR1     VARCHAR (50),
	@CORP_ADDR2     VARCHAR (50),
	@CORP_ADDR3     VARCHAR (50),
	@CORP_PHONE     VARCHAR (255),
	@CORP_ZIP       VARCHAR (50),
	@CORP_CITY      VARCHAR (50),
	@CORP_STATE     VARCHAR (50),
	@CORP_COUNTRY   VARCHAR (20),
	@COMPLIANCE_NAME VARCHAR (50),
	@COMPLIANCE_EMAIL   VARCHAR (100),
	@COMPLIANCE_PHONE   VARCHAR (15),
	@COMPLIANCE_MOBILE  VARCHAR (15),
	@BNK_NAME       VARCHAR (100),
	@BNK_BRANCH     VARCHAR (50),
	@BNK_ACNO       VARCHAR (20),
	@IFSC_CODE      VARCHAR (12),
	@NEFT_CODE      VARCHAR (12),
	@MICR_NO        INT,
	@BANK_ADDRESS1  VARCHAR (50),
	@BANK_ADDRESS2  VARCHAR (50),
	@BANK_ADDRESS3  VARCHAR (50),
	@BANK_PIN       VARCHAR (50),
	@BANK_CITY      VARCHAR (50),
	@BANK_COUNTRY   VARCHAR (20),
	@BANK_TELE_LIST VARCHAR (100),
	@BANK_FAX_LIST  VARCHAR (100),
	@BANK_CONTACT_PERSON VARCHAR (100),
	@BANK_EMAIL_LIST VARCHAR (255),
	@AUTHNAME		VARCHAR (500),
	@MARGINMULTIPLIER INT
)
AS 
UPDATE OWNER SET 
COMPANY=@COMPANY,		
ADDR1=@ADDR1,
ADDR2=@ADDR2,	
PHONE=@PHONE,			
ZIP=@ZIP,			
CITY=@CITY,			
PANNO=@PANNO,			
FAX=@FAX,	
STATE=@STATE,
EMAIL=@EMAIL,
MARGINMULTIPLIER=@MARGINMULTIPLIER,
SERVICES_TAXNO=@SERVICES_TAXNO,
NSECMCODE=@NSECMCODE,
SEBINO=@SEBINO,
TM_CODE=@TM_CODE,
WEBSITE_ID=@WEBSITE_ID,
ADDR3=@ADDR3,
COUNTRY=@COUNTRY,
OFF_ADDR1=@OFF_ADDR1,
OFF_ADDR2=@OFF_ADDR2,
OFF_ADDR3=@OFF_ADDR3,
OFF_PHONE=@OFF_PHONE,
DEL_PHONE1=@DEL_PHONE1,
OFF_FAX=@OFF_FAX,
OFF_ZIP=@OFF_ZIP,
OFF_CITY=@OFF_CITY,      
OFF_EMAIL=@OFF_EMAIL,
OFF_STATE=@OFF_STATE,
OFF_COUNTRY=@OFF_COUNTRY,
CORP_ADDR1=@CORP_ADDR1,
CORP_ADDR2=@CORP_ADDR2,
CORP_ADDR3=@CORP_ADDR3,
CORP_PHONE=@CORP_PHONE,
CORP_ZIP=@CORP_ZIP,
CORP_CITY=@CORP_CITY,
CORP_STATE=@CORP_STATE,
CORP_COUNTRY=@CORP_COUNTRY,
COMPLIANCE_NAME=@COMPLIANCE_NAME,
COMPLIANCE_EMAIL=@COMPLIANCE_EMAIL,
COMPLIANCE_PHONE=@COMPLIANCE_PHONE,
COMPLIANCE_MOBILE=@COMPLIANCE_MOBILE

UPDATE BANKMAST SET
BNK_NAME=@BNK_NAME,
BNK_BRANCH=@BNK_BRANCH,
BNK_ACNO=@BNK_ACNO,
IFSC_CODE=@IFSC_CODE,
NEFT_CODE=@NEFT_CODE,
MICR_NO=@MICR_NO,
BANK_ADDRESS1=@BANK_ADDRESS1,
BANK_ADDRESS2=@BANK_ADDRESS2,
BANK_ADDRESS3=@BANK_ADDRESS3,
BANK_PIN=@BANK_PIN,
BANK_CITY=@BANK_CITY,
BANK_COUNTRY=@BANK_COUNTRY,
BANK_TELE_LIST=@BANK_TELE_LIST,
BANK_FAX_LIST=@BANK_FAX_LIST,
BANK_CONTACT_PERSON=@BANK_CONTACT_PERSON,
BANK_EMAIL_LIST=@BANK_EMAIL_LIST

update AUTHORISEDSIGNETORY set NAME=@AUTHNAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_OWNER_EDIT
-- --------------------------------------------------
CREATE PROC [dbo].[USP_OWNER_EDIT]
AS 
/*
EXEC USP_OWNER_EDIT
*/
SELECT
COMPANY,
ADDR1,
ADDR2,
PHONE,
ZIP,
CITY,
PANNO,
FAX,
STATE,
EMAIL,
SERVICES_TAXNO,
NSECMCODE,
SEBINO,
TM_CODE,
WEBSITE_ID,
ADDR3,
COUNTRY,
OFF_ADDR1,
OFF_ADDR2,
OFF_ADDR3,
OFF_PHONE,
DEL_PHONE1,
OFF_FAX,
OFF_ZIP,
OFF_CITY,
OFF_EMAIL,
OFF_STATE,
OFF_COUNTRY,
CORP_ADDR1,
CORP_ADDR2,
CORP_ADDR3,
CORP_PHONE,
CORP_ZIP,
CORP_CITY,
CORP_STATE,
CORP_COUNTRY,
COMPLIANCE_NAME,
COMPLIANCE_EMAIL,
COMPLIANCE_PHONE,
COMPLIANCE_MOBILE,
MARGINMULTIPLIER
FROM OWNER

SELECT * FROM BANKMAST

SELECT name FROM AUTHORISEDSIGNETORY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBUMASTER
-- --------------------------------------------------
CREATE PROC [dbo].[USP_SBUMASTER]
    @SBU_CODE		VARCHAR(10),
	@SBU_NAME		VARCHAR(50),
	@SBU_ADDR1		VARCHAR(40),
	@SBU_ADDR2		VARCHAR(40),
	@SBU_ADDR3		VARCHAR(40),
	@SBU_CITY		VARCHAR(20),
	@SBU_STATE		VARCHAR(20),
	@SBU_ZIP		VARCHAR(10),
	@SBU_PHONE1		VARCHAR(15),
	@SBU_PHONE2		VARCHAR(15),
	@SBU_TYPE		VARCHAR(10),
	@SBU_PARTY_CODE	VARCHAR(10),
	@BRANCH_CD		VARCHAR(10)

AS
BEGIN
		DECLARE
			@ROWPOS_MAIN AS INT,
			@INSTR AS VARCHAR(500),
			@EXISTSTR AS VARCHAR(500),
			@SHAREDBLST_VAR AS VARCHAR(500),
			@EXCH_SECH_VAR AS VARCHAR(500),
			@STRSQL AS VARCHAR(8000),
			@INSTCOUNT AS INT,
			@EXISTCOUNT AS INT,
			@SHAREDBLST	AS VARCHAR(500),
			@EXCH_SEG AS VARCHAR(500)
		
		SET @SHAREDBLST=''
		SET @EXCH_SEG=''
 
		SELECT @SHAREDBLST = @SHAREDBLST + SHAREDB + '|', @EXCH_SEG = @EXCH_SEG + EXCHANGE + '-' + SEGMENT + '|' FROM VW_MULTICOMPANY WHERE PRIMARYSERVER='1'
		CREATE TABLE #TBLCOUNT (A VARCHAR(10))

		SET @ROWPOS_MAIN = 1
		SET @INSTR = ''
		SET @EXISTSTR = ''
		SET @INSTCOUNT = 0
		SET @EXISTCOUNT = 0
		WHILE 1 = 1  
		BEGIN  
		   SET @SHAREDBLST_VAR = LTRIM(RTRIM(.DBO.PIECE(@SHAREDBLST, '|', @ROWPOS_MAIN)))  
		   SET @EXCH_SECH_VAR  = LTRIM(RTRIM(.DBO.PIECE(@EXCH_SEG,'|',@ROWPOS_MAIN)))
				IF @SHAREDBLST_VAR IS NULL OR @SHAREDBLST_VAR = ''  
				 BEGIN  
				  BREAK  
				 END  

				  
					SET @STRSQL ="DELETE FROM "+ @SHAREDBLST_VAR + "..SBU_MASTER WHERE SBU_CODE = '"+ @SBU_CODE +"'"
					EXEC (@STRSQL)
					SET @STRSQL = ''
					SET @STRSQL = " INSERT INTO "+ @SHAREDBLST_VAR + "..SBU_MASTER (SBU_CODE,SBU_NAME,SBU_ADDR1,SBU_ADDR2,SBU_ADDR3,SBU_CITY,SBU_STATE,SBU_ZIP,SBU_PHONE1,SBU_PHONE2,SBU_TYPE,SBU_PARTY_CODE,BRANCH_CD)"
					SET @STRSQL = @STRSQL + " VALUES('" + @SBU_CODE + "', '" + @SBU_NAME+ "', '" + @SBU_ADDR1 + "', '" + @SBU_ADDR2 + "', '" + @SBU_ADDR3 + "', '" + @SBU_CITY + "', '" + @SBU_STATE + "', '" + @SBU_ZIP + "', '" + @SBU_PHONE1 + "', '" + @SBU_PHONE2 + "', '" + @SBU_TYPE + "', '" + @SBU_PARTY_CODE + "', '" + @BRANCH_CD	+"'	)"
					EXEC(@STRSQL)
					IF @INSTCOUNT < 5
						BEGIN
							SET @INSTCOUNT = @INSTCOUNT + 1
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',&nbsp;'
						END
					ELSE
						BEGIN
							SET @INSTR  = @INSTR  + @EXCH_SECH_VAR  +',<br>'
							SET @INSTCOUNT = 0
						END
				   
			DELETE FROM #TBLCOUNT 
			SET @ROWPOS_MAIN = @ROWPOS_MAIN + 1 
			print @INSTR
			print @EXISTSTR
		END 
		SET @INSTR = @INSTR + '~'
		SET @EXISTSTR = @EXISTSTR + '~'

	SELECT @SBU_CODE as SBU_CODE,REPLACE(REPLACE(@INSTR,',&nbsp;~',''),'~','') AS SUCCESS
	DROP TABLE #TBLCOUNT 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_APPLICATION_LOG
-- --------------------------------------------------

CREATE  proc [dbo].[V2_APPLICATION_LOG]  
(  
          @FromDate VARCHAR(11),              
          @ToDate VARCHAR(11),              
          @LoginName  VARCHAR(20),  
          @ReportType varchar(10)  
)              
  
AS              
              
/*              
  SET @FromDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@FromDate,'/',''),'-',''),112),11)              
  SET @ToDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ToDate,'/',''),'-',''),112),11)              
*/  
  SET @FromDate = LEFT(CONVERT(DATETIME,@FromDate,105),11)              
  SET @ToDate = LEFT(CONVERT(DATETIME,@ToDate,105),11)

           
  
  
if @ReportType = 'LOGIN LOG'  
begin  
 if @LoginName = ''  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
	   UserName [User Name],   
	   StatusName [Status Name],   
	   StatusID [Status ID],   
	   IpAdd [IP Address],   
	   [Action],   
	   AddDt as [Activity Time]  
  FROM  
	   V2_LOGIN_LOG (NOLOCK)  
  WHERE  
	   ADDDT >= @FROMDATE  
	   AND ADDDT <= @TODATE + ' 23:59:59'  
	  Order by AddDt Desc 
 end  
 else  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
	   UserName [User Name],   
	   StatusName [Status Name],   
	   StatusID [Status ID],   
	   IpAdd [IP Address],   
	   [Action],   
	   AddDt as [Activity Time]  
  FROM  
	   V2_LOGIN_LOG (NOLOCK)  
  WHERE 
	   ADDDT >= @FROMDATE  
	   AND ADDDT <= @TODATE + ' 23:59:59'  
	   AND USERNAME LIKE @LoginName   
  Order by AddDt Desc
 end  
end  
  
if @ReportType = 'ACCESS LOG'  
begin  
 if @LoginName = ''  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT
		   UserName [User Name],   
		   StatusName [Status Name],   
		   StatusID [Status ID],   
		   IpAdd [IP Address],
		   tr.Fldreportname [Report Name], 
		   tm.fldmenuname[Menu Name],    
		   RepPath [Report Path],   
		   AddDt as [Activity Time]  
	from   V2_Report_Access_Log V2  
		   Left outer join tblreports tr
	on    
            replace(V2.reppath,'`','')=tr.Fldpath
	        Left outer join tblmenuhead tm
            on tr.fldmenugrp=tm.fldmenucode 
	WHERE 
			replace(V2.reppath,'`','')=tr.Fldpath 
			AND tr.fldmenugrp=tm.fldmenucode  
			AND ADDDT >= @FROMDATE  
			AND ADDDT <= @TODATE + ' 23:59:59'  
  Order by AddDt Desc 
 end  
 else  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT
		   UserName [User Name],   
		   StatusName [Status Name],   
		   StatusID [Status ID],   
		   IpAdd [IP Address],
		   tr.Fldreportname [Report Name],
		   tm.fldmenuname[Menu Name],    
		   RepPath [Report Path],   
		   AddDt as [Activity Time]  
  FROM  
			V2_Report_Access_Log V2  
			Left outer join tblreports tr
			on    replace(V2.reppath,'`','')=tr.Fldpath 
			Left outer join tblmenuhead tm
			on tr.fldmenugrp=tm.fldmenucode  
  WHERE
			replace(V2.reppath,'`','')=tr.Fldpath 
			AND tr.fldmenugrp=tm.fldmenucode  
			AND ADDDT >= @FROMDATE  
			AND ADDDT <= @TODATE + ' 23:59:59'  
			AND USERNAME LIKE @LoginName   
		    Order by AddDt Desc
 end  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_EXECUTEF2
-- --------------------------------------------------
CREATE PROC [dbo].[V2_EXECUTEF2]
(
	@F2CODE VARCHAR(10),
	@F2DESCRIPTION	VARCHAR(50) = ''  OUTPUT,
	@F2OBJECT	VARCHAR(100) = ''  OUTPUT,
	@F2OBJECTTYPE VARCHAR(1) = ''  OUTPUT,
	@F2PARAMFIELDS	VARCHAR(500) = ''  OUTPUT,
	@F2OUTPUT	VARCHAR(500) = ''  OUTPUT,
	@F2OPRLIST	VARCHAR(100) = ''  OUTPUT,
	@F2ORDERLIST	VARCHAR(100) = ''  OUTPUT,
	@DATABASENAME	VARCHAR(256) = ''  OUTPUT,
	@WINDOWTITLE	VARCHAR(100) = ''  OUTPUT,
	@TABLEHEADER	VARCHAR(200) = ''  OUTPUT,
	@CONNECTIONDB  VARCHAR(1) = ''  OUTPUT
)
AS
	SELECT 
		@F2DESCRIPTION	= UPPER(F2DESCRIPTION),
		@F2OBJECT = UPPER(F2OBJECT),
		@F2OBJECTTYPE = UPPER(F2OBJECTTYPE),
		@F2PARAMFIELDS = UPPER(F2PARAMFIELDS),
		@F2OUTPUT = UPPER(F2OUTPUT),
		@F2OPRLIST = UPPER(F2OPRLIST),
		@F2ORDERLIST = UPPER(F2ORDERLIST),
		@DATABASENAME = UPPER(DATABASENAME),
		@WINDOWTITLE = UPPER(WINDOWTITLE),
		@TABLEHEADER = UPPER(TABLEHEADER),
		@CONNECTIONDB = UPPER(CONNECTIONDB)
	FROM 
		F2CONFIG 
	WHERE 
		F2CODE = @F2CODE
		AND F2OBJECTTYPE = 'T'
		
--SELECT * FROM F2CONFIG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_InstTradeLog_Report
-- --------------------------------------------------
-- Exec   V2_InstTradeLog_Report 'Feb 13 2006','Feb 13 2008 23:59:59','','zzzzzz','','ZZZZZZZZ','','99999999',1        
  
CREATE Proc [dbo].[V2_InstTradeLog_Report]              
(          
        @SAUDA_DATEFROM VARCHAR(11),          
        @SAUDA_DATETO VARCHAR(11),          
 @PARTY_CODEFROM varchar(15),                    
        @PARTY_CODETO  varchar(15),                    
        @SCRIP_CDFROM  varchar(15),          
        @SCRIP_CDTO  varchar(15),                    
        @CONTRACT_NOFROM varchar(15),                    
        @CONTRACT_NOTO varchar(15) ,          
 @fldstat int          
)           
AS          
 IF @fldstat = 1          
  BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
      and I.Party_Code <> I.New_Party_Code           
      And called_from Like '%AFTERCONT%'           
      And I.New_Party_Code <> ''            
      and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
          
 IF  @fldstat = 2          
          
          
  BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
                  And Module = 'MIBROK'          
    And called_from Like '%Brok%'           
    And I.Party_Code = I.New_Party_Code            
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
IF  @fldstat = 3          
          
          
  BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
                 And I.Participant_Code <> I.New_Participant_Code           
          And I.Party_Code = I.New_Party_Code            
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
IF  @fldstat = 4          
          
  BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
                And called_from Like '%CONFIRM%'           
         And I.Party_Code = I.New_Party_Code           
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
IF  @fldstat = 5          
BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
                And called_from Like '%REJECT%'          
         And I.Party_Code = I.New_Party_Code          
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
IF  @fldstat = 6          
          
BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
               And called_from Like 'CONSOLIDAT%'           
        And I.Party_Code = I.New_Party_Code           
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
 if @fldstat = 7          
          
          
BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,          
   i.order_no,i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code           
  FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE             c1.cl_code=c2.cl_code           
              And called_from Like 'UNCONSOLIDAT%'          
       And I.Party_Code = I.New_Party_Code           
             and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END          
          
IF @fldstat= 8          
          
BEGIN          
 SELECT called_from,          
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,          
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,           
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,          
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,    
   i.order_no,           
   i.qty,          
   i.new_qty,          
   i.market_rate,          
   i.net_rate,          
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,          
   I.Party_Code,          
   I.New_Party_Code,          
   I.Brokerage,          
   I.New_Brokerage,          
   I.Participant_Code,           
   I.New_Participant_Code       FROM           
     msajag..inst_log i,          
     client1 c1,          
     client2 c2          
   Left           
     Outer Join           
     msajag..Ucc_Client U           
     On (u.party_code=c2.party_code)          
 WHERE           
   c1.cl_code=c2.cl_code              
     And I.Party_Code = I.New_Party_Code And I.Brokerage = I.New_Brokerage          
     And I.Net_Rate = I.New_Net_Rate And I.Participant_Code = I.New_Participant_Code          
      and  i.party_code=c2.party_code          
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM          
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'          
      and i.party_code >= @PARTY_CODEFROM          
      and  i.party_code<= @PARTY_CODETO          
      and   i.scrip_cd >=   @SCRIP_CDFROM          
      and   i.scrip_cd <=  @SCRIP_CDTO          
      and i.contract_no >=  @CONTRACT_NOFROM          
      and  i.contract_no<= @CONTRACT_NOTO          
 order by timestamp          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_ADMINPASSWORD
-- --------------------------------------------------
CREATE PROC [dbo].[V2_UPDATE_ADMINPASSWORD]  
(  
 @PASSWORD VARCHAR(512),  
 @ADMINID VARCHAR(25),  
 @DAYCOUNT INT   
)  
  
AS
SET NOCOUNT ON  
  
DECLARE @@FLDOLDPASSWORD TINYINT  
DECLARE @@FLDAUTO INT  
DECLARE @@PASSAUTO BIGINT  
DECLARE @@OLDPASSSTRING VARCHAR(2000)  
DECLARE @@OLDPASSCOUNT INT  
DECLARE @@NEWPASSSTRING VARCHAR(2000)  
  
  
/*  
CREATE TABLE TBLUSERPASSHIST  
(  
 FLDAUTO BIGINT IDENTITY(1,1),  
 FLDUSERID INT,  
 FLDOLDPASSLISTING VARCHAR(2000)  
)  
*/  
  
  
SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS  
  
IF ISNULL(@@FLDOLDPASSWORD,0) = 0  
BEGIN  
 SET @@FLDOLDPASSWORD = 1  
END  
  
  
  
SELECT @@FLDAUTO = ISNULL(FLDAUTO_ADMIN,0) FROM TBLADMIN  
WHERE FLDNAME = @ADMINID  
  
IF ISNULL(@@FLDAUTO,0) = 0  
BEGIN  
 SELECT MSG = 'ADMIN USER NOT FOUND'  
 RETURN  
END  
  
  
  
SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLADMINPASSHIST  
WHERE FLDADMINID = @@FLDAUTO  
  
IF ISNULL(@@OLDPASSSTRING,'') = ''  
BEGIN  
 SET @@OLDPASSSTRING = ''  
END  
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 SET @@PASSAUTO = 0  
END  
  
  
SELECT   
 @@OLDPASSCOUNT = COUNT(1)  
FROM   
 FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE   
 SPLITTED_VALUE = @PASSWORD  
 AND SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
  
  
IF ISNULL(@@OLDPASSCOUNT,0) > 0  
BEGIN  
 SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'  
 RETURN  
END  
  
  
  
UPDATE TBLADMIN   
SET   
 FLDPASSWORD = @PASSWORD,  
 PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT),
 FLDATTEMPTCNT = 0 
WHERE   
 FLDAUTO_ADMIN = @@FLDAUTO  
  
SET @@NEWPASSSTRING = ''  
  
DECLARE @@STRING VARCHAR(100)  
  
DECLARE vendor_cursor CURSOR FOR   
  
SELECT SPLITTED_VALUE  
FROM   
 FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE  SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
OPEN vendor_cursor  
  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
END   
  
CLOSE vendor_cursor  
DEALLOCATE vendor_cursor  
  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD   
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 INSERT INTO TBLADMINPASSHIST   
 (FLDADMINID, FLDOLDPASSLISTING)   
 VALUES  
 (@@FLDAUTO, @@NEWPASSSTRING)  
END  
ELSE  
BEGIN  
 UPDATE TBLADMINPASSHIST  
 SET FLDOLDPASSLISTING = @@NEWPASSSTRING  
 WHERE FLDAUTO = @@PASSAUTO  
 AND FLDADMINID = @@FLDAUTO   
END  
  
SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'  
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD
-- --------------------------------------------------
  
  CREATE  PROC V2_UPDATE_PASSWORD  
(  
 @PASSWORD VARCHAR(15),  
 @USERID VARCHAR(25),  
 @DAYCOUNT INT   
)  
  
AS  
  
  
SET NOCOUNT ON  
  
DECLARE @@FLDOLDPASSWORD TINYINT  
DECLARE @@FLDAUTO INT  
DECLARE @@PASSAUTO BIGINT  
DECLARE @@OLDPASSSTRING VARCHAR(2000)  
DECLARE @@OLDPASSCOUNT INT  
DECLARE @@NEWPASSSTRING VARCHAR(2000)  
  
  
/*  
CREATE TABLE TBLUSERPASSHIST  
(  
 FLDAUTO BIGINT IDENTITY(1,1),  
 FLDUSERID INT,  
 FLDOLDPASSLISTING VARCHAR(2000)  
)  
*/  
  
  
SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS  
  
IF ISNULL(@@FLDOLDPASSWORD,0) = 0  
BEGIN  
 SET @@FLDOLDPASSWORD = 1  
END  
  
  
  
SELECT @@FLDAUTO = ISNULL(FLDAUTO,0) FROM TBLPRADNYAUSERS  
WHERE FLDUSERNAME = @USERID  
  
IF ISNULL(@@FLDAUTO,0) = 0  
BEGIN  
 SELECT MSG = 'USER NOT FOUND'  
 RETURN  
END  
  
  
  
SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLUSERPASSHIST  
WHERE FLDUSERID = @@FLDAUTO  
  
IF ISNULL(@@OLDPASSSTRING,'') = ''  
BEGIN  
 SET @@OLDPASSSTRING = ''  
END  
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 SET @@PASSAUTO = 0  
END  
  
  
SELECT   
 @@OLDPASSCOUNT = COUNT(1)  
FROM   
 FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE   
 SPLITTED_VALUE = @PASSWORD  
 AND SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
  
  
IF ISNULL(@@OLDPASSCOUNT,0) > 0  
BEGIN  
 SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'  
 RETURN  
END  
  
  
  
UPDATE TBLPRADNYAUSERS   
SET   
 FLDPASSWORD = @PASSWORD,  
 PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT)  
WHERE   
 FLDAUTO = @@FLDAUTO  
  
          
UPDATE TBLUSERCONTROLMASTER   
SET   
 FLDATTEMPTCNT = 0,  
 FLDFIRSTLOGIN = 'N'  
WHERE   
 TBLUSERCONTROLMASTER.FLDUSERID = @@FLDAUTO   
  
  
  
SET @@NEWPASSSTRING = ''  
  
  
DECLARE @@STRING VARCHAR(100)  
  
DECLARE vendor_cursor CURSOR FOR   
  
SELECT SPLITTED_VALUE  
FROM   
 FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE  SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
OPEN vendor_cursor  
  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
END   
  
CLOSE vendor_cursor  
DEALLOCATE vendor_cursor  
  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD   
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 INSERT INTO TBLUSERPASSHIST   
 (FLDUSERID, FLDOLDPASSLISTING)   
 VALUES  
 (@@FLDAUTO, @@NEWPASSSTRING)  
END  
ELSE  
BEGIN  
 UPDATE TBLUSERPASSHIST  
 SET FLDOLDPASSLISTING = @@NEWPASSSTRING  
 WHERE FLDAUTO = @@PASSAUTO  
 AND FLDUSERID = @@FLDAUTO   
END  
  
SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'  
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD_1802
-- --------------------------------------------------
 create  PROC [dbo].[V2_UPDATE_PASSWORD_1802]  
(  
 @PASSWORD VARCHAR(512),  
 @USERID VARCHAR(25),  
 @DAYCOUNT INT,  
 @OLDPASSWORD VARCHAR(512)  
)  
  
AS  
  
  
SET NOCOUNT ON  
  
DECLARE @@FLDOLDPASSWORD TINYINT  
DECLARE @@FLDAUTO INT  
DECLARE @@PASSAUTO BIGINT  
DECLARE @@OLDPASSSTRING VARCHAR(2000)  
DECLARE @@OLDPASSCOUNT INT  
DECLARE @@NEWPASSSTRING VARCHAR(2000)  
  
  
/*  
CREATE TABLE TBLUSERPASSHIST  
(  
 FLDAUTO BIGINT IDENTITY(1,1),  
 FLDUSERID INT,  
 FLDOLDPASSLISTING VARCHAR(2000)  
)  
*/  
  
  
SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS  
  
IF ISNULL(@@FLDOLDPASSWORD,0) = 0  
BEGIN  
 SET @@FLDOLDPASSWORD = 1  
END  
  
  
  
SELECT @@FLDAUTO = ISNULL(FLDAUTO,0) FROM TBLPRADNYAUSERS  
WHERE FLDUSERNAME = @USERID  
  
IF ISNULL(@@FLDAUTO,0) = 0  
BEGIN  
 SELECT MSG = 'USER NOT FOUND'  
 RETURN  
END  
  
IF (SELECT COUNT(1) FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERID AND FLDPASSWORD = @OLDPASSWORD) <= 0  
 BEGIN  
  SELECT MSG = 'INVAVLID PASSWORD...'  
  RETURN  
 END  
  
SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLUSERPASSHIST  
WHERE FLDUSERID = @@FLDAUTO  
  
IF ISNULL(@@OLDPASSSTRING,'') = ''  
BEGIN  
 SET @@OLDPASSSTRING = ''  
END  
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 SET @@PASSAUTO = 0  
END  
  
  
SELECT   
 @@OLDPASSCOUNT = COUNT(1)  
FROM   
 .dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE   
 SPLITTED_VALUE = @PASSWORD  
 AND SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       .dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
  
  
IF ISNULL(@@OLDPASSCOUNT,0) > 0  
BEGIN  
 SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'  
 RETURN  
END  
  
  
  
UPDATE TBLPRADNYAUSERS   
SET   
 FLDPASSWORD = @PASSWORD,  
 PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT)  
WHERE   
 FLDAUTO = @@FLDAUTO  
  
          
UPDATE TBLUSERCONTROLMASTER   
SET   
 FLDATTEMPTCNT = 0,  
 FLDFIRSTLOGIN = 'N'  
WHERE   
 TBLUSERCONTROLMASTER.FLDUSERID = @@FLDAUTO   
  
  
  
SET @@NEWPASSSTRING = ''  
  
  
DECLARE @@STRING VARCHAR(100)  
  
DECLARE vendor_cursor CURSOR FOR   
  
SELECT SPLITTED_VALUE  
FROM   
 .dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
WHERE  SNO > (  
      SELECT   
        ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)  
      FROM   
       .dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')  
     )  
OPEN vendor_cursor  
  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'  
FETCH NEXT FROM vendor_cursor   
INTO @@STRING  
END   
  
CLOSE vendor_cursor  
DEALLOCATE vendor_cursor  
  
 SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD   
  
IF ISNULL(@@PASSAUTO,0) = 0  
BEGIN  
 INSERT INTO TBLUSERPASSHIST   
 (FLDUSERID, FLDOLDPASSLISTING)   
 VALUES  
 (@@FLDAUTO, @@NEWPASSSTRING)  
END  
ELSE  
BEGIN  
 UPDATE TBLUSERPASSHIST  
 SET FLDOLDPASSLISTING = @@NEWPASSSTRING  
 WHERE FLDAUTO = @@PASSAUTO  
 AND FLDUSERID = @@FLDAUTO   
END  
  
SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'  
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD_18042013
-- --------------------------------------------------



CREATE  PROC V2_UPDATE_PASSWORD
(
	@PASSWORD VARCHAR(15),
	@USERID VARCHAR(25),
	@DAYCOUNT INT	
)

AS


SET NOCOUNT ON

DECLARE @@FLDOLDPASSWORD TINYINT
DECLARE @@FLDAUTO INT
DECLARE @@PASSAUTO BIGINT
DECLARE @@OLDPASSSTRING VARCHAR(2000)
DECLARE @@OLDPASSCOUNT INT
DECLARE @@NEWPASSSTRING VARCHAR(2000)


/*
CREATE TABLE TBLUSERPASSHIST
(
	FLDAUTO BIGINT IDENTITY(1,1),
	FLDUSERID INT,
	FLDOLDPASSLISTING VARCHAR(2000)
)
*/


SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS

IF ISNULL(@@FLDOLDPASSWORD,0) = 0
BEGIN
	SET @@FLDOLDPASSWORD = 1
END



SELECT @@FLDAUTO = ISNULL(FLDAUTO,0) FROM TBLPRADNYAUSERS
WHERE FLDUSERNAME = @USERID

IF ISNULL(@@FLDAUTO,0) = 0
BEGIN
	SELECT MSG = 'USER NOT FOUND'
	RETURN
END



SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLUSERPASSHIST
WHERE FLDUSERID = @@FLDAUTO

IF ISNULL(@@OLDPASSSTRING,'') = ''
BEGIN
	SET @@OLDPASSSTRING = ''
END

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	SET @@PASSAUTO = 0
END


SELECT 
	@@OLDPASSCOUNT = COUNT(1)
FROM 
	FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE 
	SPLITTED_VALUE = @PASSWORD
	AND SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)


IF ISNULL(@@OLDPASSCOUNT,0) > 0
BEGIN
	SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'
	RETURN
END



UPDATE TBLPRADNYAUSERS 
SET 
	FLDPASSWORD = @PASSWORD,
	PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT)
WHERE 
	FLDAUTO = @@FLDAUTO

								
UPDATE TBLUSERCONTROLMASTER 
SET 
	FLDATTEMPTCNT = 0,
	FLDFIRSTLOGIN = 'N'
WHERE 
	TBLUSERCONTROLMASTER.FLDUSERID = @@FLDAUTO 



SET @@NEWPASSSTRING = ''


DECLARE @@STRING VARCHAR(100)

DECLARE vendor_cursor CURSOR FOR 

SELECT SPLITTED_VALUE
FROM 
	FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE  SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)
OPEN vendor_cursor

FETCH NEXT FROM vendor_cursor 
INTO @@STRING

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'
FETCH NEXT FROM vendor_cursor 
INTO @@STRING
END 

CLOSE vendor_cursor
DEALLOCATE vendor_cursor

	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD 

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	INSERT INTO TBLUSERPASSHIST 
	(FLDUSERID, FLDOLDPASSLISTING) 
	VALUES
	(@@FLDAUTO, @@NEWPASSSTRING)
END
ELSE
BEGIN
	UPDATE TBLUSERPASSHIST
	SET FLDOLDPASSLISTING = @@NEWPASSSTRING
	WHERE FLDAUTO = @@PASSAUTO
	AND FLDUSERID = @@FLDAUTO 
END

SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD_old
-- --------------------------------------------------

create  PROC [dbo].[V2_UPDATE_PASSWORD]
(
	@PASSWORD VARCHAR(512),
	@USERID VARCHAR(25),
	@DAYCOUNT INT,
	@OLDPASSWORD VARCHAR(512)
)

AS


SET NOCOUNT ON

DECLARE @@FLDOLDPASSWORD TINYINT
DECLARE @@FLDAUTO INT
DECLARE @@PASSAUTO BIGINT
DECLARE @@OLDPASSSTRING VARCHAR(2000)
DECLARE @@OLDPASSCOUNT INT
DECLARE @@NEWPASSSTRING VARCHAR(2000)


/*
CREATE TABLE TBLUSERPASSHIST
(
	FLDAUTO BIGINT IDENTITY(1,1),
	FLDUSERID INT,
	FLDOLDPASSLISTING VARCHAR(2000)
)
*/


SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS

IF ISNULL(@@FLDOLDPASSWORD,0) = 0
BEGIN
	SET @@FLDOLDPASSWORD = 1
END



SELECT @@FLDAUTO = ISNULL(FLDAUTO,0) FROM TBLPRADNYAUSERS
WHERE FLDUSERNAME = @USERID

IF ISNULL(@@FLDAUTO,0) = 0
BEGIN
	SELECT MSG = 'USER NOT FOUND'
	RETURN
END

IF (SELECT COUNT(1) FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERID AND FLDPASSWORD = @OLDPASSWORD) <= 0
	BEGIN
		SELECT MSG = 'INVAVLID PASSWORD...'
		RETURN
	END

SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLUSERPASSHIST
WHERE FLDUSERID = @@FLDAUTO

IF ISNULL(@@OLDPASSSTRING,'') = ''
BEGIN
	SET @@OLDPASSSTRING = ''
END

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	SET @@PASSAUTO = 0
END


SELECT 
	@@OLDPASSCOUNT = COUNT(1)
FROM 
	.dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE 
	SPLITTED_VALUE = @PASSWORD
	AND SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							.dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)


IF ISNULL(@@OLDPASSCOUNT,0) > 0
BEGIN
	SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'
	RETURN
END



UPDATE TBLPRADNYAUSERS 
SET 
	FLDPASSWORD = @PASSWORD,
	PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT)
WHERE 
	FLDAUTO = @@FLDAUTO

								
UPDATE TBLUSERCONTROLMASTER 
SET 
	FLDATTEMPTCNT = 0,
	FLDFIRSTLOGIN = 'N'
WHERE 
	TBLUSERCONTROLMASTER.FLDUSERID = @@FLDAUTO 



SET @@NEWPASSSTRING = ''


DECLARE @@STRING VARCHAR(100)

DECLARE vendor_cursor CURSOR FOR 

SELECT SPLITTED_VALUE
FROM 
	.dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE  SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							.dbo.FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)
OPEN vendor_cursor

FETCH NEXT FROM vendor_cursor 
INTO @@STRING

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'
FETCH NEXT FROM vendor_cursor 
INTO @@STRING
END 

CLOSE vendor_cursor
DEALLOCATE vendor_cursor

	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD 

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	INSERT INTO TBLUSERPASSHIST 
	(FLDUSERID, FLDOLDPASSLISTING) 
	VALUES
	(@@FLDAUTO, @@NEWPASSSTRING)
END
ELSE
BEGIN
	UPDATE TBLUSERPASSHIST
	SET FLDOLDPASSLISTING = @@NEWPASSSTRING
	WHERE FLDAUTO = @@PASSAUTO
	AND FLDUSERID = @@FLDAUTO 
END

SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_User_Report_Mapping
-- --------------------------------------------------
CREATE Proc [dbo].[V2_User_Report_Mapping]  
@fldstat varchar(15)          
  
AS  
  
Select   
      u.fldusername,  
      fldname = u.fldfirstname +  ' ' + u.fldmiddlename + ' ' + u.fldlastname,  
      u.fldstname,  
      a.fldstatus,   
      c.fldcategoryname,   
      r.fldreportname,   
      r.fldpath,   
      g.fldgrpname,   
      m.fldmenuname,  
      Branch_Cd = isnull(branch_cd,''),   
      Trader = isnull(trader,a.fldstatus + ' Login'),   
      Client_Name = isnull(long_name,a.fldstatus + ' Login')   
From   
      TblAdmin a (nolock),  
      TblCategory c (nolock),  
      tblreports r (nolock),   
      tblreportgrp g (nolock),   
      tblmenuhead m (nolock),   
      tblcatmenu cm (nolock),     
      TblPradnyaUsers u  (nolock)  
      left outer join   
      (  
            Select   
                  Party_Code,   
                  Branch_Cd,  
                  Trader,  
                  Long_Name  
            From  
                  Client1 C1 (nolock),  
                  Client2 C2 (nolock)  
            Where  
                  C1.Cl_COde = C2.Cl_Code  
      ) cl  
      on  
      (cl.party_code = u.fldstname)  
Where   
      u.fldadminauto = a.fldauto_admin  
      And u.fldcategory = c.fldcategorycode   
      And r.fldreportgrp =g.fldreportgrp    
      and r.fldmenugrp = m.fldmenucode    
      and r.fldreportcode = cm.fldreportcode    
--      and u.fldcategory = 8  
      and cm.fldcategorycode like '%,' + u.fldcategory + ',%' 
      and a.fldstatus=@fldstat
Order By   
      u.fldusername,   
      g.fldgrpname,   
      m.fldmenuname,  
      r.fldreportname

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_User_Report_Mapping_withoutrep
-- --------------------------------------------------
create Proc [dbo].[V2_User_Report_Mapping_withoutrep]    
@fldstat varchar(15)            
    
AS    
    
Select distinct      
      u.fldusername,    
      fldname = u.fldfirstname +  ' ' + u.fldmiddlename + ' ' + u.fldlastname,    
      u.fldstname,    
      a.fldstatus,     
      c.fldcategoryname     
    /*  r.fldreportname,     
      r.fldpath,     
      g.fldgrpname,     
      m.fldmenuname,    
      Branch_Cd = isnull(branch_cd,''),     
      Trader = isnull(trader,a.fldstatus + ' Login'),     
      Client_Name = isnull(long_name,a.fldstatus + ' Login')     */
From     
      TblAdmin a (nolock),    
      TblCategory c (nolock),    
      tblreports r (nolock),     
      tblreportgrp g (nolock),     
      tblmenuhead m (nolock),     
      tblcatmenu cm (nolock),       
      TblPradnyaUsers u  (nolock)    
      left outer join     
      (    
            Select     
                  Party_Code,     
                  Branch_Cd,    
                  Trader,    
                  Long_Name    
            From    
                  Client1 C1 (nolock),    
                  Client2 C2 (nolock)    
            Where    
                  C1.Cl_COde = C2.Cl_Code    
      ) cl    
      on    
      (cl.party_code = u.fldstname)    
Where     
      u.fldadminauto = a.fldauto_admin    
      And u.fldcategory = c.fldcategorycode     
      And r.fldreportgrp =g.fldreportgrp      
      and r.fldmenugrp = m.fldmenucode      
      and r.fldreportcode = cm.fldreportcode      
      and cm.fldcategorycode like '%,' + u.fldcategory + ',%'   
      and a.fldstatus=@fldstat  
Order By     
      u.fldusername
   --   g.fldgrpname,     
 --     m.fldmenuname,    
--      r.fldreportname

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw
-- --------------------------------------------------
    
CREATE PROC Vw @VwName VARCHAR(25)AS                   
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO

-- --------------------------------------------------
-- TABLE dbo.ACCBILL
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCBILL]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Start_Date] DATETIME NOT NULL,
    [End_Date] DATETIME NOT NULL,
    [Payin_Date] DATETIME NOT NULL,
    [Payout_Date] DATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AREA
-- --------------------------------------------------
CREATE TABLE [dbo].[AREA]
(
    [AREACODE] VARCHAR(20) NULL,
    [DESCRIPTION] VARCHAR(50) NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AUTHORISEDSIGNETORIES
-- --------------------------------------------------
CREATE TABLE [dbo].[AUTHORISEDSIGNETORIES]
(
    [Authorisedsignetory1] VARCHAR(100) NULL,
    [Authorisedsignetory2] VARCHAR(100) NULL,
    [Authorisedsignetory3] VARCHAR(100) NULL,
    [Authorisedsignetory4] VARCHAR(100) NULL,
    [Authorisedsignetory5] VARCHAR(100) NULL,
    [Authorisedsignetory6] VARCHAR(100) NULL,
    [Authorisedsignetory7] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BANK
-- --------------------------------------------------
CREATE TABLE [dbo].[BANK]
(
    [BankId] VARCHAR(16) NOT NULL,
    [BankName] VARCHAR(60) NULL,
    [address1] VARCHAR(60) NULL,
    [address2] VARCHAR(60) NULL,
    [city] VARCHAR(40) NULL,
    [pincode] VARCHAR(20) NULL,
    [phone1] VARCHAR(20) NULL,
    [phone2] VARCHAR(20) NULL,
    [phone3] VARCHAR(20) NULL,
    [phone4] VARCHAR(20) NULL,
    [fax1] VARCHAR(40) NULL,
    [fax2] VARCHAR(20) NULL,
    [email] VARCHAR(50) NULL,
    [BankType] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BRANCH
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCH]
(
    [BRANCH_CODE] VARCHAR(20) NOT NULL,
    [BRANCH] VARCHAR(80) NULL,
    [LONG_NAME] VARCHAR(100) NULL,
    [ADDRESS1] VARCHAR(100) NULL,
    [ADDRESS2] VARCHAR(100) NULL,
    [CITY] VARCHAR(40) NULL,
    [STATE] VARCHAR(30) NULL,
    [NATION] VARCHAR(30) NULL,
    [ZIP] VARCHAR(30) NULL,
    [PHONE1] VARCHAR(30) NULL,
    [PHONE2] VARCHAR(30) NULL,
    [FAX] VARCHAR(30) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [REMOTE] BIT NOT NULL,
    [SECURITY_NET] BIT NOT NULL,
    [MONEY_NET] BIT NOT NULL,
    [EXCISE_REG] VARCHAR(60) NULL,
    [CONTACT_PERSON] VARCHAR(150) NULL,
    [PREFIX] VARCHAR(3) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BRANCHES
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCHES]
(
    [BRANCH_CD] VARCHAR(50) NOT NULL,
    [SHORT_NAME] VARCHAR(20) NOT NULL,
    [LONG_NAME] VARCHAR(50) NULL,
    [ADDRESS1] VARCHAR(25) NULL,
    [ADDRESS2] VARCHAR(25) NULL,
    [CITY] VARCHAR(20) NULL,
    [STATE] CHAR(15) NULL,
    [NATION] CHAR(15) NULL,
    [ZIP] CHAR(15) NULL,
    [PHONE1] CHAR(15) NULL,
    [PHONE2] CHAR(15) NULL,
    [FAX] CHAR(15) NULL,
    [EMAIL] CHAR(50) NULL,
    [REMOTE] BIT NOT NULL,
    [SECURITY_NET] BIT NOT NULL,
    [MONEY_NET] BIT NOT NULL,
    [EXCISE_REG] CHAR(30) NULL,
    [CONTACT_PERSON] CHAR(25) NULL,
    [COM_PERC] MONEY NULL,
    [TERMINAL_ID] VARCHAR(10) NULL,
    [DEFTRADER] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[broktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(18, 4) NULL,
    [Day_Sales] NUMERIC(18, 4) NULL,
    [Sett_Purch] NUMERIC(18, 4) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [Table_name] CHAR(25) NULL,
    [sett_sales] NUMERIC(18, 4) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [Def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] NUMERIC(18, 9) NULL,
    [NoZero] INT NULL,
    [Branch_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_DETAIL_SETTING
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_DETAIL_SETTING]
(
    [OBJNAME] VARCHAR(30) NULL,
    [BLANK_ALLOWED] INT NULL,
    [FIELD_WIDTH] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENTSTATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENTSTATUS]
(
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [DESCRIPTION] VARCHAR(35) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clienttype
-- --------------------------------------------------
CREATE TABLE [dbo].[clienttype]
(
    [Cl_Type] VARCHAR(3) NOT NULL,
    [Description] VARCHAR(50) NULL,
    [GROUP_CODE] VARCHAR(10) NULL,
    [prefix] VARCHAR(3) NOT NULL,
    [priority] INT NULL,
    [MarginFlag] VARCHAR(1) NULL,
    [DEBITBALPERCENTAGE] DECIMAL(18, 4) NULL,
    [FutBalPercentage] DECIMAL(18, 4) NULL,
    [FUNDS_FNO_IM] VARCHAR(1) NULL,
    [FUNDS_FNO_EXP] VARCHAR(1) NULL,
    [FUNDS_ADHOC_PAYOUT] VARCHAR(1) NULL,
    [FUNDS_SETT_PAYOUT] VARCHAR(1) NULL,
    [FAMILY_BALANCE] VARCHAR(1) NULL,
    [CREATEBY] VARCHAR(20) NULL,
    [CREATEDATE] DATETIME NULL,
    [UPDATEBY] VARCHAR(20) NULL,
    [UPDATEDATE] DATETIME NULL,
    [InstFlag] VARCHAR(1) NULL,
    [PANVALIDATION] VARCHAR(1) NULL,
    [CREDITAMOUNT] NUMERIC(18, 4) NULL,
    [CASHMARGINMARKUP] NUMERIC(18, 4) NULL,
    [FOMARGINMARKUP] NUMERIC(18, 4) NULL,
    [NLRSell] NUMERIC(18, 4) NULL,
    [NLRMCall] NUMERIC(18, 4) NULL,
    [NLRHold] NUMERIC(18, 4) NULL,
    [SPANMARKUP] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CONTGEN
-- --------------------------------------------------
CREATE TABLE [dbo].[CONTGEN]
(
    [Contractno] VARCHAR(7) NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DEALINGADDRESS
-- --------------------------------------------------
CREATE TABLE [dbo].[DEALINGADDRESS]
(
    [BRANCHNAME] VARCHAR(100) NULL,
    [ADDR1] VARCHAR(100) NULL,
    [ADDR2] VARCHAR(100) NULL,
    [ADDR3] VARCHAR(100) NULL,
    [PHONE1] VARCHAR(100) NULL,
    [PHONE2] VARCHAR(100) NULL,
    [FAX] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [COMPLEmail1] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DEL_REASONCODE
-- --------------------------------------------------
CREATE TABLE [dbo].[DEL_REASONCODE]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [SLIPFORMAT] VARCHAR(20) NULL,
    [FROMACCOUNT] VARCHAR(16) NULL,
    [TOACCOUNT] VARCHAR(16) NULL,
    [REASONCODE] VARCHAR(2) NULL,
    [REASONDESC] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delaccbalance
-- --------------------------------------------------
CREATE TABLE [dbo].[Delaccbalance]
(
    [Cltcode] VARCHAR(10) NOT NULL,
    [Amount] MONEY NULL,
    [Payflag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delcdslbalance
-- --------------------------------------------------
CREATE TABLE [dbo].[Delcdslbalance]
(
    [Party_Code] VARCHAR(10) NULL,
    [Dpid] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(16) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(12) NOT NULL,
    [Freebal] NUMERIC(18, 3) NOT NULL,
    [Currbal] NUMERIC(18, 3) NULL,
    [Freezebal] NUMERIC(18, 3) NOT NULL,
    [Lockinbal] NUMERIC(18, 3) NOT NULL,
    [Pledgebal] NUMERIC(18, 3) NOT NULL,
    [Dpvbal] NUMERIC(18, 3) NOT NULL,
    [Dpcbal] NUMERIC(18, 3) NOT NULL,
    [Rpcbal] CHAR(10) NOT NULL,
    [Elimbal] NUMERIC(18, 3) NOT NULL,
    [Earmarkbal] NUMERIC(18, 3) NOT NULL,
    [Remlockbal] NUMERIC(18, 3) NOT NULL,
    [Totalbalance] NUMERIC(18, 3) NOT NULL,
    [Trdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELCODE
-- --------------------------------------------------
CREATE TABLE [dbo].[DELCODE]
(
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Nsdlno] NUMERIC(18, 0) NULL,
    [Cdslno] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELCODE_ORG
-- --------------------------------------------------
CREATE TABLE [dbo].[DELCODE_ORG]
(
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELFILENO
-- --------------------------------------------------
CREATE TABLE [dbo].[DELFILENO]
(
    [Sno] INT IDENTITY(1,1) NOT NULL,
    [FileType] VARCHAR(10) NOT NULL,
    [FileNo] INT NOT NULL,
    [FileDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELIVERYCLT_AUC
-- --------------------------------------------------
CREATE TABLE [dbo].[DELIVERYCLT_AUC]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [QTY] NUMERIC(38, 4) NULL,
    [INOUT] VARCHAR(1) NOT NULL,
    [BRANCH_CD] VARCHAR(2) NOT NULL,
    [PARTIPANTCODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [TOSETT_NO] VARCHAR(7) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DeliveryDp
-- --------------------------------------------------
CREATE TABLE [dbo].[DeliveryDp]
(
    [SNo] DECIMAL(18, 0) NOT NULL,
    [DpType] VARCHAR(4) NULL,
    [DpId] VARCHAR(16) NULL,
    [DpCltNo] VARCHAR(16) NULL,
    [Description] VARCHAR(65) NULL,
    [ACCOUNTTYPE] VARCHAR(4) NULL,
    [LICENCENO] VARCHAR(10) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delsegment
-- --------------------------------------------------
CREATE TABLE [dbo].[delsegment]
(
    [Refno] INT NOT NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(10) NULL,
    [Company] VARCHAR(50) NULL,
    [Db] VARCHAR(20) NULL,
    [Pdptype] VARCHAR(5) NULL,
    [Pdpid] VARCHAR(16) NULL,
    [Pcltid] VARCHAR(16) NULL,
    [Bdptype] VARCHAR(5) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltid] VARCHAR(16) NULL,
    [Pdptype1] VARCHAR(5) NULL,
    [Pdpid1] VARCHAR(16) NULL,
    [Pcltid1] VARCHAR(16) NULL,
    [Bdptype1] VARCHAR(5) NULL,
    [Bdpid1] VARCHAR(16) NULL,
    [Bcltid1] VARCHAR(16) NULL,
    [Fileread] INT NULL,
    [Auctionper] DECIMAL(18, 2) NULL,
    [Nsecmbpid] VARCHAR(8) NULL,
    [Bsecmbpid] VARCHAR(8) NULL,
    [Nsdltocdsl] VARCHAR(8) NULL,
    [Auctionparty] VARCHAR(10) NULL,
    [Auctionchrg] MONEY NULL,
    [Allocationtype] INT NULL,
    [Noofslip] INT NULL,
    [Insettex] INT NULL,
    [Inbenex] INT NULL,
    [Brokerid] VARCHAR(8) NULL,
    [Brokerfileid] VARCHAR(2) NULL,
    [AuctionFlag] INT NULL,
    [AuctionFlagDesc] VARCHAR(100) NULL,
    [RMSPAYOUT] INT NULL,
    [COLLCALCULATIONFLAG] INT NULL,
    [LOANPARTY] VARCHAR(10) NULL,
    [AUCTIONFINAL] DECIMAL(18, 4) NULL,
    [SETTPOCKETFLAG] INT NULL,
    [NSECMID] VARCHAR(8) NULL,
    [BSECMID] VARCHAR(8) NULL,
    [SENDERPOAID] VARCHAR(16) NULL,
    [WITH_ROOT_FLAG] INT NULL,
    [THIRDPARTY_CODE] VARCHAR(10) NULL,
    [MCXCMBPID] VARCHAR(8) NULL,
    [MCXCMID] VARCHAR(8) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delslipformat
-- --------------------------------------------------
CREATE TABLE [dbo].[delslipformat]
(
    [FormatProvider] VARCHAR(10) NOT NULL,
    [FromDp] VARCHAR(4) NOT NULL,
    [ToDp] VARCHAR(4) NOT NULL,
    [Detail] VARCHAR(10) NOT NULL,
    [PoolOrBen] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSLIPMST
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSLIPMST]
(
    [Dptype] CHAR(4) NULL,
    [Sliptype] VARCHAR(2) NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Slflag] INT NULL,
    [Checksum] VARCHAR(5) NULL,
    [Dpid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [SLIPSERIES] VARCHAR(6) NULL,
    [SLIPSTATUS] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSLIPTYPE
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSLIPTYPE]
(
    [SLIPTYPE] VARCHAR(2) NULL,
    [SLIPDESC] VARCHAR(50) NULL,
    [DPTYPE] VARCHAR(4) NULL,
    [ACCOUNTTYPE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltrans
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltrans]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELTRANS_SURESH
-- --------------------------------------------------
CREATE TABLE [dbo].[DELTRANS_SURESH]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltranspi
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltranspi]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(35) NULL,
    [Reason] VARCHAR(30) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DelTransPrintPool
-- --------------------------------------------------
CREATE TABLE [dbo].[DelTransPrintPool]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [FromParty] VARCHAR(10) NOT NULL,
    [ToParty] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [CertNo] VARCHAR(12) NOT NULL,
    [TrType] INT NOT NULL,
    [BDpType] VARCHAR(4) NOT NULL,
    [BDpId] VARCHAR(8) NOT NULL,
    [BCltDpId] VARCHAR(16) NOT NULL,
    [ISett_No] VARCHAR(7) NOT NULL,
    [ISett_Type] VARCHAR(2) NOT NULL,
    [DpId] VARCHAR(8) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [SlipNo] NUMERIC(18, 0) NOT NULL,
    [Batchno] VARCHAR(10) NOT NULL,
    [FolioNo] VARCHAR(16) NOT NULL,
    [TransDate] DATETIME NOT NULL,
    [HolderName] VARCHAR(100) NOT NULL,
    [OptionFlag] INT NOT NULL,
    [Qty] NUMERIC(18, 4) NULL,
    [NewQty] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltranstemp
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltranstemp]
(
    [Sno] NUMERIC(18, 0) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattrans
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattrans]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattransout
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattransout]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattransspeed
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattransspeed]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ErrorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[ErrorLog]
(
    [ErrDate] SMALLDATETIME NULL,
    [CName] VARCHAR(200) NULL,
    [MName] VARCHAR(200) NULL,
    [SName] VARCHAR(200) NULL,
    [ErrStr] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GLOBALS
-- --------------------------------------------------
CREATE TABLE [dbo].[GLOBALS]
(
    [Year] VARCHAR(4) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Service_Tax] NUMERIC(10, 4) NULL,
    [Service_Tax_Ac] VARCHAR(30) NULL,
    [Turnover_Ac] VARCHAR(30) NULL,
    [Sebi_Turn_Ac] VARCHAR(30) NULL,
    [Broker_Note_Ac] VARCHAR(30) NULL,
    [Other_Chrg_Ac] VARCHAR(30) NULL,
    [Exchange_Gl_Ac] VARCHAR(30) NULL,
    [Year_Start_Dt] DATETIME NULL,
    [Year_End_Dt] DATETIME NULL,
    [Cess_Tax] NUMERIC(10, 4) NULL,
    [Trdbuytrans] NUMERIC(18, 4) NULL,
    [Trdselltrans] NUMERIC(18, 4) NULL,
    [Delbuytrans] NUMERIC(18, 4) NULL,
    [Delselltrans] NUMERIC(18, 4) NULL,
    [EDUCESSTAX] NUMERIC(18, 4) NULL,
    [STT_TAX_AC] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.iaccbill
-- --------------------------------------------------
CREATE TABLE [dbo].[iaccbill]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Start_Date] SMALLDATETIME NOT NULL,
    [End_Date] SMALLDATETIME NOT NULL,
    [Payin_Date] SMALLDATETIME NOT NULL,
    [Payout_Date] SMALLDATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IMP_FilePath
-- --------------------------------------------------
CREATE TABLE [dbo].[IMP_FilePath]
(
    [File_Type] VARCHAR(20) NULL,
    [File_Path] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_BROKERAGE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_BROKERAGE_MASTER]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(50) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [FROMDATE] DATETIME NOT NULL,
    [TODATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(12) NULL,
    [FORADD2] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_COMMONINTERFACE
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_COMMONINTERFACE]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NULL,
    [ADDR3] VARCHAR(50) NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NULL,
    [RES_PHONE] VARCHAR(15) NULL,
    [MOBILE_NO] VARCHAR(50) NULL,
    [EMAIL_ID] VARCHAR(50) NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NULL,
    [NOMINEE_NAME] VARCHAR(50) NULL,
    [NOMINEE_RELATION] VARCHAR(50) NULL,
    [BANK_AC_TYPE] VARCHAR(10) NULL,
    [STAT_COMM_MODE] VARCHAR(1) NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NULL,
    [HOLDER2_NAME] VARCHAR(100) NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NULL,
    [HOLDER3_CODE] VARCHAR(20) NULL,
    [HOLDER3_NAME] VARCHAR(100) NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NULL,
    [BUY_BROK_TABLE_NO] INT NULL,
    [SELL_BROK_TABLE_NO] INT NULL,
    [BROK_EFF_DATE] DATETIME NULL,
    [NEFTCODE] VARCHAR(11) NULL,
    [CHEQUENAME] VARCHAR(35) NULL,
    [RESIFAX] VARCHAR(15) NULL,
    [OFFICEFAX] VARCHAR(15) NULL,
    [MAPINID] VARCHAR(16) NULL,
    [REMARK] VARCHAR(100) NULL,
    [UCC_STATUS] INT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [CIFLAG] VARCHAR(1) NULL,
    [CICreationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_LOG]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [EDITEDBY] VARCHAR(50) NOT NULL,
    [EDITEDON] DATETIME NOT NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [CM_FORADD1] VARCHAR(12) NULL,
    [FORADD2] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(50) NULL,
    [CM_FORPINCODE] VARCHAR(50) NULL,
    [CM_FORSTATE] VARCHAR(50) NULL,
    [CM_FORCOUNTRY] VARCHAR(50) NULL,
    [CM_FORRESIPHONE] VARCHAR(50) NULL,
    [CM_FORRESIFAX] VARCHAR(50) NULL,
    [CM_FOROFFPHONE] VARCHAR(50) NULL,
    [CM_FOROFFFAX] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_NEW]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [AADHAR_UID] VARCHAR(12) NULL,
    [CM_FORADD1] VARCHAR(50) NULL,
    [CM_FORADD2] VARCHAR(50) NULL,
    [CM_FORADD3] VARCHAR(50) NULL,
    [CM_FORCITY] VARCHAR(35) NULL,
    [CM_FORPINCODE] VARCHAR(10) NULL,
    [CM_FORSTATE] VARCHAR(35) NULL,
    [CM_FORCOUNTRY] VARCHAR(3) NULL,
    [CM_FORRESIPHONE] VARCHAR(15) NULL,
    [CM_FORRESIFAX] VARCHAR(15) NULL,
    [CM_FOROFFPHONE] VARCHAR(15) NULL,
    [CM_FOROFFFAX] VARCHAR(15) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(100) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERKYCTYPE] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLMST_VALUES
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLMST_VALUES]
(
    [V_TYPE] VARCHAR(10) NULL,
    [V_CODE] VARCHAR(10) NULL,
    [V_VALUE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DFDS
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DFDS]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(2) NOT NULL,
    [IsIn] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(50) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [DpId] VARCHAR(8) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [TransNo] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_LOG]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [EDITEDBY] VARCHAR(50) NOT NULL,
    [EDITEDON] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_NEW]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_FUNDS_OBLIGATION
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_FUNDS_OBLIGATION]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [ORDER_NO] NUMERIC(18, 0) NOT NULL,
    [ORDER_INDICATOR] VARCHAR(1) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [AVAIL_AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PROCESSDATE] DATETIME NULL,
    [INT_REF_NO] VARCHAR(10) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] BIGINT NULL,
    [SIP_REGN_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_NAV
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_NAV]
(
    [NAV_DATE] DATETIME NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(20) NOT NULL,
    [DIV_REINVEST_FLAG] VARCHAR(5) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [NAV_VALUE] NUMERIC(18, 4) NOT NULL,
    [RTA_CODE] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_order
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_order]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NOT NULL,
    [PAYOUT_MECHANISM] INT NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_123
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_123]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [MEMBERCODE] VARCHAR(10) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] VARCHAR(10) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(10) NOT NULL,
    [DPCLT] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [User_Id] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(10) NULL,
    [REJECT_REASON] VARCHAR(100) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [INT_REF_NO] VARCHAR(10) NULL,
    [SETTLEMENT_TYPE] VARCHAR(2) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] INT NULL,
    [SIP_REGN_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_CONF
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_CONF]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [C_DPID] VARCHAR(8) NULL,
    [C_CLTDPID] VARCHAR(16) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_REJ
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_REJ]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_CONF
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_CONF]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [ENTRY_EXIT_LOAD] VARCHAR(20) NULL,
    [STT] VARCHAR(20) NULL,
    [TDS] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_REJ
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_REJ]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_STATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_STATUS]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [SCRIP_CD] VARCHAR(20) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(20) NOT NULL,
    [USERID] VARCHAR(20) NOT NULL,
    [FOLIONO] VARCHAR(16) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(20) NOT NULL,
    [RTA_TRANS_NO] NUMERIC(18, 0) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [RECFLAG] VARCHAR(1) NULL,
    [REMARK] VARCHAR(100) NULL,
    [RECFOR] VARCHAR(1) NULL,
    [STT] NUMERIC(18, 4) NULL,
    [INT_REF_NO] VARCHAR(10) NULL,
    [ORDER_TYPE] VARCHAR(3) NULL,
    [SIP_REGN_NO] BIGINT NULL,
    [SIP_REGN_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_TMP
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_TMP]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NOT NULL,
    [PAYOUT_MECHANISM] INT NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_scrip_master
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_scrip_master]
(
    [TOKEN] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [INTRUMENTTYPE] VARCHAR(6) NOT NULL,
    [QUANTITY_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RTSCHEMECODE] VARCHAR(5) NOT NULL,
    [AMCSCHEMECODE] VARCHAR(10) NOT NULL,
    [Filler] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [FOLIO_LENGHT] INT NOT NULL,
    [SEC_STATUS_NRM] INT NOT NULL,
    [ELIGIBILITY_NRM] VARCHAR(1) NOT NULL,
    [SEC_STATUS_ODDLOT] INT NOT NULL,
    [ELIGIBILITY_ODDLOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_SPOT] INT NOT NULL,
    [ELIGIBILITY_SPOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_AUCTION] INT NOT NULL,
    [ELIGIBILITY_AUCTION] VARCHAR(1) NOT NULL,
    [AMCCODE] VARCHAR(3) NOT NULL,
    [CATEGORYCODE] VARCHAR(5) NOT NULL,
    [SEC_NAME] VARCHAR(200) NULL,
    [ISSUE_RATE] NUMERIC(18, 4) NOT NULL,
    [MINSUBSCRADDL] NUMERIC(18, 4) NOT NULL,
    [BUYNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [SELLNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [RTAGENTCODE] VARCHAR(50) NOT NULL,
    [VALDECINDICATOR] INT NOT NULL,
    [CATSTARTTIME] INT NOT NULL,
    [QTYDECINDICATOR] INT NOT NULL,
    [CATENDTIME] INT NOT NULL,
    [MINSUBSCRFRESH] NUMERIC(18, 4) NOT NULL,
    [VALUE_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RECORD_DATE] DATETIME NOT NULL,
    [EX_DATE] DATETIME NOT NULL,
    [NAVDATE] DATETIME NOT NULL,
    [NO_DELIVERY_END_DATE] DATETIME NOT NULL,
    [ST_ELIGIBLE_IDX] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_AON] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_MIN_FILL] VARCHAR(1) NOT NULL,
    [SECDEPMANDATORY] VARCHAR(1) NOT NULL,
    [SEC_DIVIDEND] VARCHAR(1) NOT NULL,
    [SECALLOWDEP] VARCHAR(1) NOT NULL,
    [SECALLOWSELL] VARCHAR(1) NOT NULL,
    [SECMODCXL] VARCHAR(1) NOT NULL,
    [SECALLOWBUY] VARCHAR(1) NOT NULL,
    [BOOK_CL_START_DT] DATETIME NOT NULL,
    [BOOK_CL_END_DT] DATETIME NOT NULL,
    [DIVIDEND] VARCHAR(1) NOT NULL,
    [RIGHTS] VARCHAR(1) NOT NULL,
    [BONUS] VARCHAR(1) NOT NULL,
    [INTEREST] VARCHAR(1) NOT NULL,
    [AGM] VARCHAR(1) NOT NULL,
    [EGM] VARCHAR(1) NOT NULL,
    [OTHER] VARCHAR(1) NOT NULL,
    [LOCAL_DTTIME] DATETIME NOT NULL,
    [DELETEFLAG] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(25) NOT NULL,
    [SIP_ELIGIBILITY] VARCHAR(1) NULL,
    [MAX_PFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_PAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MIN_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MULTI_PS_LIM] NUMERIC(18, 4) NULL,
    [MULTI_DS_LIM] NUMERIC(18, 4) NULL,
    [AMC_NAME] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SCRIP_MASTER_TMP
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SCRIP_MASTER_TMP]
(
    [TOKEN] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [INTRUMENTTYPE] VARCHAR(6) NOT NULL,
    [QUANTITY_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RTSCHEMECODE] VARCHAR(5) NOT NULL,
    [AMCSCHEMECODE] VARCHAR(10) NOT NULL,
    [Filler] VARCHAR(10) NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [FOLIO_LENGHT] INT NOT NULL,
    [SEC_STATUS_NRM] INT NOT NULL,
    [ELIGIBILITY_NRM] VARCHAR(1) NOT NULL,
    [SEC_STATUS_ODDLOT] INT NOT NULL,
    [ELIGIBILITY_ODDLOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_SPOT] INT NOT NULL,
    [ELIGIBILITY_SPOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_AUCTION] INT NOT NULL,
    [ELIGIBILITY_AUCTION] VARCHAR(1) NOT NULL,
    [AMCCODE] VARCHAR(3) NOT NULL,
    [CATEGORYCODE] VARCHAR(5) NOT NULL,
    [SEC_NAME] VARCHAR(250) NULL,
    [ISSUE_RATE] NUMERIC(18, 4) NOT NULL,
    [MINSUBSCRADDL] NUMERIC(18, 4) NOT NULL,
    [BUYNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [SELLNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [RTAGENTCODE] VARCHAR(50) NOT NULL,
    [VALDECINDICATOR] INT NOT NULL,
    [CATSTARTTIME] INT NOT NULL,
    [QTYDECINDICATOR] INT NOT NULL,
    [CATENDTIME] INT NOT NULL,
    [MINSUBSCRFRESH] NUMERIC(18, 4) NOT NULL,
    [VALUE_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RECORD_DATE] DATETIME NOT NULL,
    [EX_DATE] DATETIME NOT NULL,
    [NAVDATE] DATETIME NOT NULL,
    [NO_DELIVERY_END_DATE] DATETIME NOT NULL,
    [ST_ELIGIBLE_IDX] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_AON] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_MIN_FILL] VARCHAR(1) NOT NULL,
    [SECDEPMANDATORY] VARCHAR(1) NOT NULL,
    [SEC_DIVIDEND] VARCHAR(1) NOT NULL,
    [SECALLOWDEP] VARCHAR(1) NOT NULL,
    [SECALLOWSELL] VARCHAR(1) NOT NULL,
    [SECMODCXL] VARCHAR(1) NOT NULL,
    [SECALLOWBUY] VARCHAR(1) NOT NULL,
    [BOOK_CL_START_DT] DATETIME NOT NULL,
    [BOOK_CL_END_DT] DATETIME NOT NULL,
    [DIVIDEND] VARCHAR(1) NOT NULL,
    [RIGHTS] VARCHAR(1) NOT NULL,
    [BONUS] VARCHAR(1) NOT NULL,
    [INTEREST] VARCHAR(1) NOT NULL,
    [AGM] VARCHAR(1) NOT NULL,
    [EGM] VARCHAR(1) NOT NULL,
    [OTHER] VARCHAR(1) NOT NULL,
    [LOCAL_DTTIME] DATETIME NOT NULL,
    [DELETEFLAG] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(25) NOT NULL,
    [SIP_ELIGIBILITY] VARCHAR(1) NULL,
    [MAX_PFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_PAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MIN_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MULTI_PS_LIM] NUMERIC(18, 4) NULL,
    [MULTI_DS_LIM] NUMERIC(18, 4) NULL,
    [AMC_NAME] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT_DELETED
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT_DELETED]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT_LOG]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(10) NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL,
    [REJECTEDDATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_trade
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_trade]
(
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(16) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Multicltid
-- --------------------------------------------------
CREATE TABLE [dbo].[Multicltid]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Cltdpno] VARCHAR(16) NOT NULL,
    [Dpid] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [Dptype] VARCHAR(4) NULL,
    [Def] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OWNER
-- --------------------------------------------------
CREATE TABLE [dbo].[OWNER]
(
    [Company] VARCHAR(60) NULL,
    [Addr1] VARCHAR(30) NULL,
    [Addr2] VARCHAR(30) NULL,
    [Phone] VARCHAR(25) NULL,
    [Zip] VARCHAR(6) NULL,
    [City] VARCHAR(20) NULL,
    [Membercode] VARCHAR(15) NULL,
    [Bankname] VARCHAR(50) NULL,
    [Bankadd] VARCHAR(50) NULL,
    [Csdlid] VARCHAR(10) NULL,
    [Cdaccno] VARCHAR(10) NULL,
    [Dpid] VARCHAR(10) NULL,
    [Cltaccno] VARCHAR(10) NULL,
    [Mainbroker] CHAR(1) NULL,
    [Maxpartylen] TINYINT NULL,
    [Preprintchq] CHAR(1) NULL,
    [Table_No] SMALLINT NULL,
    [Sub_Tableno] SMALLINT NULL,
    [Std_Rate] SMALLINT NULL,
    [P_To_P] SMALLINT NULL,
    [Demat_Tableno] SMALLINT NULL,
    [Albmcf_Tableno] SMALLINT NULL,
    [Mf_Tableno] SMALLINT NULL,
    [Sb_Tableno] SMALLINT NULL,
    [Brok1_Tableno] SMALLINT NULL,
    [Brok2_Tableno] SMALLINT NULL,
    [Brok3_Tableno] SMALLINT NULL,
    [Terminal] VARCHAR(10) NULL,
    [Tscheme] TINYINT NULL,
    [Dispcharge] TINYINT NULL,
    [Brok_Inc_Stax] TINYINT NULL,
    [Def_Scheme] CHAR(1) NULL,
    [Brok_Scheme] TINYINT NULL,
    [Contcharge] TINYINT NULL,
    [Mincontcharge] TINYINT NULL,
    [Marginmultiplier] TINYINT NULL,
    [Dummy1] TINYINT NULL,
    [Dummy2] TINYINT NULL,
    [Style] INT NULL,
    [Exchangecode] VARCHAR(3) NULL,
    [Brokersebiregno] VARCHAR(15) NULL,
    [Counterparty] VARCHAR(15) NULL,
    [Cp_Sebiregno] VARCHAR(15) NULL,
    [Panno] VARCHAR(50) NULL,
    [Fax] VARCHAR(25) NULL,
    [State] VARCHAR(50) NULL,
    [AutoGenPartyCode] INT NULL,
    [EMAIL] VARCHAR(100) NULL,
    [SMTP_SRV_NAME] VARCHAR(100) NULL,
    [ExchangeSegment] VARCHAR(10) NULL,
    [LEVEL] INT NULL,
    [KEEPINST] TINYINT NULL,
    [PROFILE_BROK_FLAG] INT NULL,
    [SERVICES_TAXNO] VARCHAR(30) NULL,
    [NSECMCODE] VARCHAR(20) NULL,
    [SEBINO] VARCHAR(20) NULL,
    [Tm_Code] VARCHAR(10) NULL,
    [WEBSITE_ID] VARCHAR(100) NULL,
    [Addr3] VARCHAR(50) NULL,
    [Country] VARCHAR(20) NULL,
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
    [COMPLIANCE_NAME] VARCHAR(50) NULL,
    [COMPLIANCE_EMAIL] VARCHAR(100) NULL,
    [COMPLIANCE_PHONE] VARCHAR(15) NULL,
    [COMPLIANCE_MOBILE] VARCHAR(15) NULL,
    [CIN] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POBANK
-- --------------------------------------------------
CREATE TABLE [dbo].[POBANK]
(
    [BANKID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BRANCH_NAME] VARCHAR(50) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [CITY] VARCHAR(25) NULL,
    [STATE] VARCHAR(25) NULL,
    [NATION] VARCHAR(25) NULL,
    [ZIP] VARCHAR(15) NULL,
    [PHONE1] VARCHAR(15) NULL,
    [PHONE2] VARCHAR(15) NULL,
    [FAX] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [IFSCCODE] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REGION
-- --------------------------------------------------
CREATE TABLE [dbo].[REGION]
(
    [REGIONCODE] VARCHAR(20) NULL,
    [DESCRIPTION] VARCHAR(50) NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL,
    [REG_SUBBROKER] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBU_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[SBU_MASTER]
(
    [SBU_CODE] VARCHAR(10) NOT NULL,
    [SBU_NAME] VARCHAR(50) NOT NULL,
    [SBU_ADDR1] VARCHAR(40) NOT NULL,
    [SBU_ADDR2] VARCHAR(40) NULL,
    [SBU_ADDR3] VARCHAR(40) NULL,
    [SBU_CITY] VARCHAR(20) NULL,
    [SBU_STATE] VARCHAR(20) NULL,
    [SBU_ZIP] VARCHAR(10) NULL,
    [SBU_PHONE1] VARCHAR(15) NULL,
    [SBU_PHONE2] VARCHAR(15) NULL,
    [SBU_TYPE] VARCHAR(10) NOT NULL,
    [SBU_PARTY_CODE] VARCHAR(10) NULL,
    [BRANCH_CD] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST_ORG
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST_ORG]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MSTTEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MSTTEMP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STAT_TRD
-- --------------------------------------------------
CREATE TABLE [dbo].[STAT_TRD]
(
    [Actioncode] VARCHAR(3) NULL,
    [Sysdate] SMALLDATETIME NULL,
    [Filedate] SMALLDATETIME NULL,
    [Com_Date] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STATE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[STATE_MASTER]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [State] VARCHAR(50) NOT NULL,
    [State_Code] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SUBBROKERS
-- --------------------------------------------------
CREATE TABLE [dbo].[SUBBROKERS]
(
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(50) NULL,
    [ADDRESS1] CHAR(100) NULL,
    [ADDRESS2] CHAR(100) NULL,
    [CITY] CHAR(20) NULL,
    [STATE] CHAR(15) NULL,
    [NATION] CHAR(15) NULL,
    [ZIP] CHAR(10) NULL,
    [FAX] CHAR(15) NULL,
    [PHONE1] CHAR(15) NULL,
    [PHONE2] CHAR(15) NULL,
    [REG_NO] CHAR(30) NULL,
    [REGISTERED] BIT NOT NULL,
    [MAIN_SUB] CHAR(1) NULL,
    [EMAIL] CHAR(50) NULL,
    [COM_PERC] MONEY NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [CONTACT_PERSON] VARCHAR(100) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_HOLD_SEC
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_HOLD_SEC]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(30) NULL,
    [SERIES] VARCHAR(5) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [TRANSDATE] DATETIME NULL,
    [CRQTY] INT NULL,
    [DRQTY] INT NULL,
    [DPID] VARCHAR(20) NULL,
    [CLTDPID] VARCHAR(20) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [BDPID] VARCHAR(20) NULL,
    [REMARK] VARCHAR(100) NULL,
    [MEMBER_ACC_TYPE] VARCHAR(20) NULL,
    [PLEDGED_BAL_QTY] INT NULL,
    [FREE_BAL_QTY] INT NULL,
    [TRF_REF_NO] VARCHAR(20) NULL,
    [TRANSACTION_TYPE] VARCHAR(20) NULL,
    [PURPOSE] VARCHAR(100) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_MASTER_POAID
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_MASTER_POAID]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [POA_TYPE] VARCHAR(10) NULL,
    [MASTER_POA_ID] VARCHAR(16) NULL,
    [FROM_DATE] DATETIME NULL,
    [TO_DATE] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL,
    [ADDED_ON] DATETIME NULL,
    [EDITED_BY] VARCHAR(16) NULL,
    [EDITED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_MASTER_USER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_MASTER_USER]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [REC_TYPE] VARCHAR(10) NULL,
    [DEF_FLAG] INT NULL,
    [USERCODE] VARCHAR(12) NULL,
    [USERNAME] VARCHAR(50) NULL,
    [FROM_DATE] DATETIME NULL,
    [TO_DATE] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL,
    [ADDED_ON] DATETIME NULL,
    [EDITED_BY] VARCHAR(16) NULL,
    [EDITED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_GST_LOCATION
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_GST_LOCATION]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [LOC_CODE] VARCHAR(20) NULL,
    [LOCATION] VARCHAR(80) NULL,
    [LONG_NAME] VARCHAR(100) NULL,
    [ADDRESS1] VARCHAR(100) NULL,
    [ADDRESS2] VARCHAR(100) NULL,
    [CITY] VARCHAR(50) NULL,
    [STATE] VARCHAR(50) NULL,
    [NATION] VARCHAR(50) NULL,
    [ZIP] VARCHAR(30) NULL,
    [PHONE1] VARCHAR(30) NULL,
    [PHONE2] VARCHAR(30) NULL,
    [FAX] VARCHAR(30) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [GST_NO] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblAdmin
-- --------------------------------------------------
CREATE TABLE [dbo].[TblAdmin]
(
    [Fldauto_Admin] INT IDENTITY(1,1) NOT NULL,
    [Fldname] VARCHAR(30) NOT NULL,
    [Fldpassword] VARCHAR(50) NULL,
    [Fldcompany] VARCHAR(50) NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Fldstatus] VARCHAR(25) NOT NULL,
    [Flddesc] VARCHAR(100) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDUSERSTATUS] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDROLE] SMALLINT NULL,
    [FLDRIGHTS] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMIN_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMIN_LOG]
(
    [Fldauto_Admin] INT NOT NULL,
    [Fldname] VARCHAR(30) NOT NULL,
    [Fldpassword] VARCHAR(30) NOT NULL,
    [Fldcompany] VARCHAR(50) NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Fldstatus] VARCHAR(25) NOT NULL,
    [Flddesc] VARCHAR(100) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDUSERSTATUS] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDROLE] SMALLINT NULL,
    [FLDRIGHTS] SMALLINT NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINEIP] VARCHAR(20) NULL,
    [FLDLOG_DATA] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblAdminconfig
-- --------------------------------------------------
CREATE TABLE [dbo].[TblAdminconfig]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldadmin] VARCHAR(50) NULL,
    [Fldflag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMINPASSHIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMINPASSHIST]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDADMINID] INT NULL,
    [FLDOLDPASSLISTING] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[TblCategory]
(
    [Fldcategorycode] INT IDENTITY(1,1) NOT NULL,
    [Fldcategoryname] VARCHAR(50) NOT NULL,
    [Fldadminauto] INT NULL,
    [Flddesc] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATEGORY_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATEGORY_LOG]
(
    [Fldcategorycode] INT NOT NULL,
    [Fldcategoryname] VARCHAR(50) NOT NULL,
    [Fldadminauto] INT NULL,
    [Flddesc] VARCHAR(80) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblCatmenu
-- --------------------------------------------------
CREATE TABLE [dbo].[TblCatmenu]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldreportcode] INT NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldcategorycode] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATMENU_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATMENU_LOG]
(
    [Fldreportcode] INT NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldcategorycode_OLD] VARCHAR(2000) NULL,
    [Fldcategorycode_NEW] VARCHAR(2000) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINE_IP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCLASSADMINLOGINS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCLASSADMINLOGINS]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDAUTO] BIGINT NULL,
    [FLDADMINNAME] VARCHAR(50) NULL,
    [FLDSTATUS] VARCHAR(25) NULL,
    [FLDSTNAME] VARCHAR(50) NULL,
    [FLDSESSION] VARCHAR(200) NULL,
    [FLDIPADDRESS] VARCHAR(20) NULL,
    [FLDLASTVISIT] DATETIME NULL,
    [FLDTIMEOUTPRD] INT NULL,
    [FLDLASTLOGIN] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCLASSUSERLOGINS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCLASSUSERLOGINS]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDAUTO] BIGINT NULL,
    [FLDUSERNAME] VARCHAR(50) NULL,
    [FLDSTATUS] VARCHAR(25) NULL,
    [FLDSTNAME] VARCHAR(50) NULL,
    [FLDSESSION] VARCHAR(200) NULL,
    [FLDIPADDRESS] VARCHAR(20) NULL,
    [FLDLASTVISIT] DATETIME NULL,
    [FLDTIMEOUTPRD] INT NULL,
    [FLDLASTLOGIN] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblglobalparams
-- --------------------------------------------------
CREATE TABLE [dbo].[tblglobalparams]
(
    [FLDPWDMINLENGTH] SMALLINT NULL,
    [FLDPWDMAXLENGTH] SMALLINT NULL,
    [FLDSPCLCHAR] CHAR(1) NULL,
    [FLDENCRYPTION] CHAR(1) NULL,
    [FLDBLOCKPWD] VARCHAR(255) NULL,
    [FLDDELBLOCK] CHAR(1) NULL,
    [fldlastins] BIGINT NULL,
    [fldlastdel] BIGINT NULL,
    [fldlastupdt] BIGINT NULL,
    [fldupdtdate] DATETIME NULL,
    [fldclientMakerCheker] INT NULL,
    [fldAutoCodeGenerate] INT NULL,
    [fldflag] VARCHAR(3) NULL,
    [fldreportflag] VARCHAR(3) NULL,
    [fldCheckClientProcess] VARCHAR(1) NULL,
    [fldBranchAdd] TINYINT NULL,
    [BranchFlag] CHAR(1) NULL,
    [FldPwdAlphaNumOnly] INT NULL,
    [FLDOLDPASSWORD] TINYINT NULL,
    [FLDPANVALIDATION] CHAR(1) NULL,
    [FLDPARTYCODEBY] VARCHAR(10) NULL,
    [ALLOW_MULTI_LOGIN] INT NULL,
    [MAX_REJECTION_ALLOW] SMALLINT NULL,
    [FLDCAPTCHA] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblMenuHead
-- --------------------------------------------------
CREATE TABLE [dbo].[TblMenuHead]
(
    [Fldmenucode] VARCHAR(20) NULL,
    [Fldmenuname] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblPradnyausers
-- --------------------------------------------------
CREATE TABLE [dbo].[TblPradnyausers]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(50) NULL,
    [Fldfirstname] VARCHAR(25) NULL,
    [Fldmiddlename] VARCHAR(25) NULL,
    [Fldlastname] VARCHAR(25) NULL,
    [Fldsex] VARCHAR(8) NULL,
    [Fldaddress1] VARCHAR(100) NULL,
    [Fldaddress2] VARCHAR(100) NULL,
    [Fldphone1] VARCHAR(10) NULL,
    [Fldphone2] VARCHAR(10) NULL,
    [Fldcategory] VARCHAR(10) NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [MODIFIED_BY] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLPRADNYAUSERS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLPRADNYAUSERS_LOG]
(
    [Fldauto] INT NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(15) NULL,
    [Fldfirstname] VARCHAR(25) NULL,
    [Fldmiddlename] VARCHAR(25) NULL,
    [Fldlastname] VARCHAR(25) NULL,
    [Fldsex] VARCHAR(8) NULL,
    [Fldaddress1] VARCHAR(100) NULL,
    [Fldaddress2] VARCHAR(100) NULL,
    [Fldphone1] VARCHAR(10) NULL,
    [Fldphone2] VARCHAR(10) NULL,
    [Fldcategory] VARCHAR(10) NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MachineIP] VARCHAR(20) NULL,
    [FLDLOG_DATA] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblReportgrp
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReportgrp]
(
    [Fldreportgrp] INT IDENTITY(1,1) NOT NULL,
    [Fldgrpname] VARCHAR(35) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Flddesc] VARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTGRP_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTGRP_LOG]
(
    [Fldreportgrp] INT NOT NULL,
    [Fldgrpname] VARCHAR(35) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblReports
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReports]
(
    [Fldreportcode] INT IDENTITY(1,1) NOT NULL,
    [Fldreportname] VARCHAR(200) NULL,
    [Fldpath] VARCHAR(500) NULL,
    [Fldtarget] VARCHAR(25) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [Fldreportgrp] VARCHAR(10) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Fldstatus] VARCHAR(20) NULL,
    [Fldorder] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblReports_Blocked
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReports_Blocked]
(
    [fldusername] VARCHAR(25) NOT NULL,
    [fldcategory] VARCHAR(10) NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldstatus] VARCHAR(25) NOT NULL,
    [Block_Flag] INT NOT NULL,
    [Fldreportcode] INT NOT NULL,
    [fldpath] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTS_LOG]
(
    [Fldreportcode] INT NOT NULL,
    [Fldreportname] VARCHAR(35) NULL,
    [Fldpath] VARCHAR(500) NULL,
    [Fldtarget] VARCHAR(25) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [Fldreportgrp] VARCHAR(10) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Fldstatus] VARCHAR(20) NULL,
    [Fldorder] INT NOT NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUserControlGlobals
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlGlobals]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDCATEGORYID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlMaster]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDUSERID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDSTATUS] SMALLINT NULL,
    [FLDLOGINFLAG] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUserControlMaster_Jrnl
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlMaster_Jrnl]
(
    [FLDAUTO] BIGINT NOT NULL,
    [FLDUSERID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDSTATUS] SMALLINT NULL,
    [FLDLOGINFLAG] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL,
    [FLDUPDTBY] VARCHAR(64) NULL,
    [FLDUPDTDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERPASSHIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERPASSHIST]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDUSERID] INT NULL,
    [FLDOLDPASSLISTING] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERS]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [PRADNYAAUTO] INT NULL,
    [REMARK] VARCHAR(200) NULL,
    [MAX_EDIT] TINYINT NULL,
    [BLOCK] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERS_LOG]
(
    [FLDAUTO] INT NOT NULL,
    [PRADNYAAUTO] INT NULL,
    [REMARK] VARCHAR(200) NULL,
    [MAX_EDIT] TINYINT NULL,
    [BLOCK] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(20) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINEIP] VARCHAR(20) NULL
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
-- TABLE dbo.V2_Login_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Login_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(64) NULL,
    [Category] VARCHAR(64) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusId] VARCHAR(32) NULL,
    [IPADD] VARCHAR(20) NULL,
    [Action] VARCHAR(6) NULL,
    [AddDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Report_Access_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [RepPath] VARCHAR(4000) NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(50) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusID] VARCHAR(32) NULL,
    [IPAdd] VARCHAR(20) NULL,
    [AddDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VALANACCOUNT
-- --------------------------------------------------
CREATE TABLE [dbo].[VALANACCOUNT]
(
    [Accode] VARCHAR(10) NULL,
    [Acname] VARCHAR(50) NULL,
    [Reversed] INT NULL,
    [Revcode] VARCHAR(10) NULL,
    [Oppcode] VARCHAR(10) NULL,
    [Effdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Broktablevalues
-- --------------------------------------------------
CREATE View [dbo].[Broktablevalues]  
As   
Select Distinct Day_Puc As Brok From Broktable  
  
Union All  
Select Distinct Day_Sales As Brok From Broktable  
  
Union All  
Select Distinct Sett_Purch As Brok From Broktable  
  
Union All  
Select Distinct Sett_Sales As Brok From Broktable  
  
Union All  
Select Distinct Normal As Brok From Broktable

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_INFO
-- --------------------------------------------------
CREATE VIEW [dbo].[CLIENT_INFO]
AS
SELECT 
 PARTY_CODE , 
 LONG_NAME= PARTY_NAME ,
 FAMILY,
 AREA,
 REGION,
 SUB_BROKER,
 TRADER,
 BRANCH_CD,
 L_ADDRESS1 =ADDR1,  
 L_ADDRESS2=ADDR2,  
 L_ADDRESS3=ADDR3,  
 L_CITY=CITY,  
 L_STATE= [STATE],  
 L_NATION = NATION,  
 L_ZIP =ZIP,
 PAN_GIR_NO=PAN_NO,  
 RES_PHONE1 =RES_PHONE,  
 RES_PHONE2='',
 OFF_PHONE1 =OFFICE_PHONE,  
 OFF_PHONE2 = '' ,
 MOBILE_PAGER='',  
 RES_FAX=RESIFAX,
 OFF_FAX = OFFICEFAX,
 EMAIL=EMAIL_ID,  
 CL_TYPE,  
 CL_STATUS  
  FROM MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW
-- --------------------------------------------------
      
CREATE VIEW [dbo].[CLIENT_OTHER_SEGMENT_VIEW] AS        
        
SELECT         
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,        
 SUB_BROKER,TRADER,AREA,REGION,SBU='HO',FAMILY,        
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE= (SELECT V_CODE FROM MFSS_CLMST_VALUES (nolock) WHERE V_TYPE ='OCCUPATION'
 AND V_VALUE =DESCRIPTION )
 ,TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='Y',        
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,        
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,  
 BANK_NAME=BANK_NAME,BANK_BRANCH=BRANCH_NAME,BANK_CITY=BRANCH_NAME,        
 --BANK_NAME=ISNULL(POBANKCODE,''),BANK_BRANCH=ISNULL(POBRANCH,''),BANK_CITY=ISNULL(POBRANCH,''),        
-- ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),     
 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE=1,MICR_NO='',     
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',        
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,        
 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),        
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',        
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',        
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO=1,SELL_BROK_TABLE_NO=1,        
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',        
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID='' , POAFLAG = ''        
FROM        
 ANAND1.MSAJAG.DBO.CLIENT1 C1 with (NOLOCK), ANAND1.MSAJAG.DBO.CLIENT2 C2 with(NOLOCK)        
 LEFT OUTER JOIN ANAND1.ACCOUNT.DBO.ACMAST with(NOLOCK)        
  ON (CLTCODE = C2.PARTY_CODE)        
 LEFT OUTER JOIN (SELECT PARTY_CODE,S.BANKID,BANK_NAME,BRANCH_NAME,CLTDPID,DEPOSITORY FROM MSAJAG.DBO.CLIENT4  S with(NOLOCK),MSAJAG.DBO.POBANK AS P WHERE DEPOSITORY IN ('SAVING','CURRENT')
 AND S.BANKID=P.BANKID ) C4        
 ON (C2.PARTY_CODE = C4.PARTY_CODE)        
 LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5 with(NOLOCK)        
 ON (C5.CL_CODE = C2.PARTY_CODE)        
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4 with(NOLOCK) WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44        
 ON (C2.PARTY_CODE = C44.PARTY_CODE)  
 LEFT OUTER JOIN 
 ( SELECT PARTY_CODE,DESCRIPTION FROM MSAJAG.DBO.CLIENT_STATIC_CODES AS CA,MSAJAG.DBO.CLIENT_MASTER_UCC_DATA AS B 
   WHERE CA.CATEGORY = 'OCCUPATION' AND KRA_TYPE ='CDSL' AND B.OCCUPATION=CODE)    C45    
ON (C2.PARTY_CODE = C45.PARTY_CODE) 
WHERE        
 C1.CL_CODE = C2.CL_CODE        
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_01032011
-- --------------------------------------------------
	  
CREATE  VIEW [dbo].[CLIENT_OTHER_SEGMENT_VIEW_01032011] AS  
  
SELECT   
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,  
 SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,  
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',  
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,  
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,  
 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',  
 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO='',  
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',  
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,  
 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),  
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',  
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',  
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO='',SELL_BROK_TABLE_NO='',  
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',  
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''  
FROM  
 ANAND.BSEDB_AB.DBO.CLIENT1 C1 , ANAND.BSEDB_AB.DBO.CLIENT2 C2 
 LEFT OUTER JOIN ANAND.ACCOUNT_AB.DBO.ACMAST 
  ON (CLTCODE = C2.PARTY_CODE)  
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND.BSEDB_AB.DBO.CLIENT4  WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4  
 ON (C2.PARTY_CODE = C4.PARTY_CODE)  
 LEFT OUTER JOIN ANAND.BSEDB_AB.DBO.CLIENT5 C5 
 ON (C5.CL_CODE = C2.PARTY_CODE)  
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND.BSEDB_AB.DBO.CLIENT4  WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44  
 ON (C2.PARTY_CODE = C44.PARTY_CODE)  
WHERE  
 C1.CL_CODE = C2.CL_CODE  
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_02JAN2010
-- --------------------------------------------------


CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW AS

SELECT 
	C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,
	SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,
	GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',
	ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,
	OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,
	 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',      
	ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),
	DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',
	BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,
	STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),
	CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',
	HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',
	HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO='',SELL_BROK_TABLE_NO='',
	BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS=''
FROM
	NSEFO.DBO.CLIENT1 C1 (NOLOCK), NSEFO.DBO.CLIENT2 C2 (NOLOCK)
	LEFT OUTER JOIN ACCOUNTFO.DBO.ACMAST (NOLOCK)
 	ON (CLTCODE = C2.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4
	ON (C2.PARTY_CODE = C4.PARTY_CODE)
	LEFT OUTER JOIN NSEFO.DBO.CLIENT5 C5 (NOLOCK)
	ON (C5.CL_CODE = C2.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44
	ON (C2.PARTY_CODE = C44.PARTY_CODE)
WHERE
	C1.CL_CODE = C2.CL_CODE
	AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_BAK
-- --------------------------------------------------
CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW_BAK AS      
      
SELECT       
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,      
 SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,      
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',      
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,      
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,      
 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',      
 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),      
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',      
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,      
 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),      
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',      
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',      
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BROK_TABLE_NO='',      
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',      
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''      
FROM      
 NSEFO.DBO.CLIENT1 C1 (NOLOCK), NSEFO.DBO.CLIENT2 C2 (NOLOCK)      
 LEFT OUTER JOIN ACCOUNTfo.DBO.ACMAST (NOLOCK)      
  ON (CLTCODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4      
 ON (C2.PARTY_CODE = C4.PARTY_CODE)      
 LEFT OUTER JOIN NSEFO.DBO.CLIENT5 C5 (NOLOCK)      
 ON (C5.CL_CODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44      
 ON (C2.PARTY_CODE = C44.PARTY_CODE)      
WHERE      
 C1.CL_CODE = C2.CL_CODE      
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT1
-- --------------------------------------------------
CREATE VIEW [dbo].[CLIENT1]    
AS    
SELECT   
 CL_CODE = PARTY_CODE,   
 SHORT_NAME = PARTY_NAME,   
 LONG_NAME = PARTY_NAME,  
 L_ADDRESS1 = ADDR1,  
 L_ADDRESS2 = ADDR2,  
 L_ADDRESS3 = ADDR3,  
 L_CITY = CITY,    
 L_STATE = [STATE],    
 L_NATION = NATION,  
 L_ZIP = ZIP,    
 FAX = '',    
 RES_PHONE1 = OFFICE_PHONE,    
 RES_PHONE2 = RES_PHONE,    
 MOBILE_PAGER = MOBILE_NO,    
 PAN_GIR_NO = PAN_NO,    
 EMAIL = EMAIL_ID,    
 FAMILY,   
 TRADER,   
 SUB_BROKER,   
 BRANCH_CD,   
 AREA,   
 REGION,   
 CL_TYPE,
 BANK_NAME,
 ACC_NO    
FROM NSEMFSS.DBO.MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT1_org
-- --------------------------------------------------
CREATE VIEW [dbo].[CLIENT1_org]  
AS  
SELECT 
	CL_CODE = PARTY_CODE, 
	SHORT_NAME = PARTY_NAME, 
	LONG_NAME = PARTY_NAME,
	L_ADDRESS1 = ADDR1,
	L_ADDRESS2 = ADDR2,
	L_ADDRESS3 = ADDR3,
	L_CITY = CITY,  
	L_STATE = [STATE],  
	L_NATION = NATION,
	L_ZIP = ZIP,  
	FAX = '',  
	RES_PHONE1 = OFFICE_PHONE,  
	RES_PHONE2 = RES_PHONE,  
	MOBILE_PAGER = MOBILE_NO,  
	PAN_GIR_NO = PAN_NO,  
	EMAIL = EMAIL_ID,  
	FAMILY, 
	TRADER, 
	SUB_BROKER, 
	BRANCH_CD, 
	AREA, 
	REGION, 
	CL_TYPE  
FROM BSEMFSS.DBO.MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT2
-- --------------------------------------------------
  
CREATE VIEW CLIENT2  
AS  
SELECT  
 CL_CODE = PARTY_CODE,  
 PARTY_CODE  
FROM  
 NSEMFSS.dbo.MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.DELIVERYCLT
-- --------------------------------------------------
CREATE VIEW [dbo].[DELIVERYCLT]                
AS                
                
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,PARTY_CODE,QTY=SUM(QTY),INOUT,BRANCH_CD,PARTIPANTCODE,DPCLT           
FROM (          
SELECT SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SCHEME_NAME=SEC_NAME, S.ISIN, PARTY_CODE, QTY = SUM(QTY),                 
INOUT = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'O' ELSE 'I' END), BRANCH_CD = 'HO',             
PARTIPANTCODE = MEMBERCODE, DPCLT=(Case When Dp_ID <> '' Then Dp_ID + CLTDPID Else CLTDPID End)      
FROM MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M         
WHERE S.SCRIP_CD = M.SCRIP_CD        
AND S.SERIES = M.SERIES        
AND ORDER_DATE >= 'DEC 24 2010'    
AND CLTDPID <> ''    
GROUP BY SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SEC_NAME, S.ISIN, PARTY_CODE, SUB_RED_FLAG, MEMBERCODE, CLTDPID,Dp_ID  
UNION ALL    
SELECT SETT_NO=TOSETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,PARTY_CODE,QTY,INOUT,BRANCH_CD,PARTIPANTCODE,DPCLT     
FROM DELIVERYCLT_AUC
) A          
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,PARTY_CODE,INOUT,BRANCH_CD,PARTIPANTCODE,DPCLT

GO

-- --------------------------------------------------
-- VIEW dbo.DELNET
-- --------------------------------------------------
CREATE VIEW [dbo].[DELNET]    
AS            
            
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,QTY=SUM(QTY),INOUT    
FROM (      
SELECT SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SCHEME_NAME=SEC_NAME, S.ISIN, QTY = SUM(QTY),             
INOUT = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'O' ELSE 'I' END)    
FROM MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M     
WHERE S.SCRIP_CD = M.SCRIP_CD    
AND S.SERIES = M.SERIES    
AND ORDER_DATE >= 'DEC 24 2010'    
--AND DP_SETTLMENT = 'Y'    
GROUP BY SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SEC_NAME, S.ISIN, SUB_RED_FLAG   
UNION ALL      
SELECT SETT_NO=TOSETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,QTY=SUM(QTY),INOUT       
FROM DELIVERYCLT_AUC  
GROUP BY TOSETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,INOUT  
) A      
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,INOUT

GO

-- --------------------------------------------------
-- VIEW dbo.MFSS_CONFIRMVIEW
-- --------------------------------------------------

CREATE VIEW [dbo].[MFSS_CONFIRMVIEW] 

AS      

SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.PARTY_CODE = M.PARTY_CODE
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P' 
				       THEN M.BUY_BROK_TABLE_NO 
					   ELSE M.SELL_BROK_TABLE_NO 
				  END)
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND T.AMOUNT > B.LOWER_LIM AND T.AMOUNT <= B.UPPER_LIM
AND T.SETT_NO <> ''
UNION ALL
SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=0,
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=0,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.AMOUNT = 0
AND T.SETT_NO <> ''

GO

-- --------------------------------------------------
-- VIEW dbo.MFSS_CONFIRMVIEW_OLD
-- --------------------------------------------------
CREATE VIEW [dbo].[MFSS_CONFIRMVIEW_OLD] 

AS      

SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.PARTY_CODE = M.PARTY_CODE
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P' 
				       THEN M.BUY_BROK_TABLE_NO 
					   ELSE M.SELL_BROK_TABLE_NO 
				  END)
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND T.AMOUNT > B.LOWER_LIM AND T.AMOUNT <= B.UPPER_LIM
AND T.SETT_NO <> ''
UNION ALL
SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=0,
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=0,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.AMOUNT = 0
AND T.SETT_NO <> ''

GO

-- --------------------------------------------------
-- VIEW dbo.MFSS_POAPAYIN
-- --------------------------------------------------
CREATE VIEW [dbo].[MFSS_POAPAYIN] AS      
SELECT SETT_NO, SETT_TYPE, S.PARTY_CODE, SCRIPNAME=SEC_NAME,CERTNO=S.ISIN, ORDER_NO,       
QTY=CONVERT(NUMERIC(18,3),QTY), DPTYPE = D.DP_TYPE, D.DPID, D.CLTDPID,     
LONG_NAME = C.PARTY_NAME,      
M.SCRIP_CD, M.SERIES, TRTYPE = 904, NEWQTY = CONVERT(NUMERIC(18,0),CONVERT(NUMERIC(18,3),QTY)*1000)      
FROM MFSS_ORDER S, MFSS_DPMASTER D, MFSS_SCRIP_MASTER M, MFSS_CLIENT C       
WHERE S.PARTY_CODE = D.PARTY_CODE      
AND S.CLTDPID = D.CLTDPID      
AND D.DP_TYPE = 'CDSL'      
AND SUB_RED_FLAG = 'R'      
AND D.POAFLAG = 'YES'    
AND S.SCRIP_CD = M.SCRIP_CD    
AND S.SERIES = M.SERIES    
AND S.PARTY_CODE = C.PARTY_CODE    
--AND AMOUNT_ALLOTED = 0

GO

-- --------------------------------------------------
-- VIEW dbo.VIEW_F2_SCIP_CD
-- --------------------------------------------------

CREATE VIEW dbo.VIEW_F2_SCIP_CD
AS
SELECT DISTINCT Scrip_Cd, '(' + Scrip_Cd + '-' + Series + ') - ' + SEC_Name AS SCRIP_NAME
FROM         dbo.MFSS_SCRIP_MASTER

GO

-- --------------------------------------------------
-- VIEW dbo.VIEW_F2_SCRIP_CD
-- --------------------------------------------------

CREATE VIEW VIEW_F2_SCRIP_CD
AS
SELECT DISTINCT Scrip_Cd, '(' + Scrip_Cd + '-' + Series + ') - ' + SEC_Name AS SCRIP_NAME
FROM         dbo.mfss_scrip_master

GO

-- --------------------------------------------------
-- VIEW dbo.VW_MULTICOMPANY
-- --------------------------------------------------
CREATE VIEW [dbo].[VW_MULTICOMPANY]
AS
SELECT BrokerId,CompanyName,Segment_Description,Exchange,Segment,MemberType,MemberCode,ShareDb,ShareServer,ShareIP,AccountDb,AccountServer,AccountIP,DefaultDb,DefaultDbServer,DefaultDbIP,DefaultClient,PANGIR_No,primaryServer,dbUserName,dbPassword
FROM PRADNYA..MultiCompany_ALL

GO

