-- DDL Export
-- Server: 10.253.33.232
-- Database: Pradnya
-- Exported: 2026-02-05T12:29:22.244555

USE Pradnya;
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
-- FUNCTION dbo.CLS_Piece
-- --------------------------------------------------



CREATE FUNCTION [dbo].[CLS_Piece] ( @CharacterExpression VARCHAR(8000), @Delimiter CHAR(1), @Position INTEGER)

RETURNS VARCHAR(8000)

AS

BEGIN

	If @Position<1 return null

	if len(@Delimiter)<>1 return null

	declare @Start integer

	set @Start=1

	while @Position>1

		BEGIN

			Set @Start=ISNULL(CHARINDEX(@Delimiter, @CharacterExpression, @Start),0)

			IF @Start=0 return null

			set @position= @position-1

			set @Start=@Start+1

		END

	Declare @End INTEGER

	Set @End= ISNULL(CHARINDEX(@Delimiter, @CharacterExpression, @Start),0)

	If @End=0 Set @End=LEN(@CharacterExpression)+1

	RETURN SUBSTRING(@CharacterExpression, @Start, @End-@Start)

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
DECLARE @NDSETTNO VARCHAR(7)
DECLARE @NEWSETT_NO VARCHAR(10)

DECLARE @PREVDATE DATETIME
	SELECT @PREVDATE = MAX(SYSDATE) FROM BSEDB.DBO.CLOSING WHERE SYSDATE < @BUSINESS_DATE
	   
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEFOLDER>', CONVERT(VARCHAR,@BUSINESS_DATE,112))    
  
 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEYYYYMMDD>', CONVERT(VARCHAR,@BUSINESS_DATE,112))    

 SET @PARAMETER = REPLACE(@PARAMETER,'<DATEYYYYDDMM>', LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,112),4)+RIGHT(CONVERT(VARCHAR,@BUSINESS_DATE,112),2)+RIGHT(LEFT(CONVERT(VARCHAR,@BUSINESS_DATE,112),6),2))    
      
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

 IF (CASE WHEN @PARAMETER LIKE '%<PDATEDDMMYYYY>%' THEN 1 
		  WHEN @PARAMETER LIKE '%<PDATEDDMMYY>%' THEN 1 
		  WHEN @PARAMETER LIKE '%<PBUSINESS_DATE>%' THEN 1
		  ELSE 0 END) = 1
 BEGIN
	SET @PARAMETER = REPLACE(@PARAMETER,'<PDATEDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@PREVDATE,103),'/',''))    
	SET @PARAMETER = REPLACE(@PARAMETER,'<PDATEDDMMYY>', REPLACE(CONVERT(VARCHAR,@PREVDATE,3),'/','')) 
	SET @PARAMETER = REPLACE(@PARAMETER,'<PBUSINESS_DATE>',LEFT(CONVERT(VARCHAR,@PREVDATE,109),11))       
 END

 
IF (CASE WHEN @PARAMETER LIKE '%<NDSET3>%' THEN 1 ELSE 0 END) = 1 
BEGIN
	SELECT @NDSETTNO = RIGHT(SETT_NO,3) FROM BSEDB.DBO.SETT_MST 
	WHERE Start_date >= @BUSINESS_DATE AND START_DATE <= @BUSINESS_DATE + '23:59'
	AND Sett_Type = 'D'
	SET @PARAMETER = REPLACE(@PARAMETER,'<NDSET3>', @NDSETTNO)
END  



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

 IF (CASE WHEN @PARAMETER LIKE '%<PDATEDDMMYYYY>%' THEN 1 ELSE 0 END) = 1
 BEGIN
	
	SET @PARAMETER = REPLACE(@PARAMETER,'<PDATEDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@PREVDATE,103),'/',''))    
 END


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

	IF @SETT_TYPE = 'AD' 
	BEGIN
		SET @PARAMETER = REPLACE(@PARAMETER,'<PAYOUTSHRT>','RECAR')
		SET @PARAMETER = REPLACE(@PARAMETER,'<PAYINSHRT>','AUCCONR')
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
		IF @PARAMETER LIKE '%ASQR%' AND  @SETT_TYPE = 'W' 
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
-- FUNCTION dbo.FNMIN
-- --------------------------------------------------

CREATE  FUNCTION [dbo].[FNMIN](@VALUE1 NUMERIC(36,12), @VALUE2 NUMERIC(36,12) ) 
RETURNS NUMERIC(36,12) AS
BEGIN
	DECLARE @RETURN NUMERIC(36,12)
	IF @VALUE1  < @VALUE2
		BEGIN
			SET @RETURN =  @VALUE1 
		END
	ELSE
		BEGIN
			SET @RETURN =  @VALUE2
		END
	RETURN @RETURN

END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING
-- --------------------------------------------------
CREATE FUNCTION [dbo].[FUN_SPLITSTRING](
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
-- INDEX dbo.TBLDEL_TRANSSTAT_QRLY
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxdphold] ON [dbo].[TBLDEL_TRANSSTAT_QRLY] ([Party_Code], [Scrip_Cd], [Holdername], [Drcr], [Bdptype], [Bdpid], [Bcltdpid])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLDEL_TRANSSTAT1_QRLY
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxhpdold] ON [dbo].[TBLDEL_TRANSSTAT1_QRLY] ([PARTY_CODE], [SCRIP_CD], [BDPID], [BCLTDPID])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_CLASS_POOLTRANSACTIONS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxparty] ON [dbo].[V2_CLASS_POOLTRANSACTIONS] ([PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_CLASS_QUARTERLYLEDGER
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxparty] ON [dbo].[V2_CLASS_QUARTERLYLEDGER] ([CQL_PARTYCODE])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_CLASS_QUARTERLYSECLEDGER
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxparty] ON [dbo].[V2_CLASS_QUARTERLYSECLEDGER] ([PARTY_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PDFMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[PDFMASTER] ADD CONSTRAINT [PK_PDFMASTER] PRIMARY KEY ([PDFCODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.trace
-- --------------------------------------------------
ALTER TABLE [dbo].[trace] ADD CONSTRAINT [PK__trace__77BFCB91] PRIMARY KEY ([RowNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.trace_1
-- --------------------------------------------------
ALTER TABLE [dbo].[trace_1] ADD CONSTRAINT [PK__trace_1__79A81403] PRIMARY KEY ([RowNumber])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_CMPADDR
-- --------------------------------------------------

create  PROC [dbo].[CLS_CMPADDR]
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
	@TABLEHEADERNAME VARCHAR(MAX),
	@@SQLTABLE VARCHAR(MAX),
	@ENTITY1 VARCHAR(50),  
	@@SQL VARCHAR(MAX)  
		
SELECT @TABLEHEADERNAME = TABLEHEADER FROM CLS_F2CONFIG WHERE F2CODE = @F2CODE
	
CREATE TABLE #TBLPARTY_DETAILS_TEMP
(
	SRNO INT IDENTITY(1, 1)
)	
	
SET @@SQLTABLE = "ALTER TABLE #TBLPARTY_DETAILS_TEMP ADD "
SET @@SQLTABLE  = @@SQLTABLE + REPLACE(REPLACE(@TABLEHEADERNAME,' ','_'), ',', ' VARCHAR(1000),') + " VARCHAR(1000)"

EXEC (@@SQLTABLE)

ALTER TABLE #TBLPARTY_DETAILS_TEMP DROP COLUMN SRNO

CREATE TABLE #ENTITYLIST_TEMP (ENTITY VARCHAR(100))  
  
SET @ENTITY1 =.DBO.CLS_PIECE(@F2PARAMS, '|', 7)  
  
 INSERT INTO #TBLPARTY_DETAILS_TEMP 
 EXEC [CLS_PROC_F2CONFIG] @F2CODE  
  ,@F2PARAMS  
  ,@F2WHFLDS  
  ,@F2WHVALS  
  ,@F2WHOPR  
  ,0  
  ,@WINDOWTITLE OUTPUT  
  ,@TABLEHEADER OUTPUT 
  
   

 IF @ENTITY_LIST = 'ALL' OR @ENTITY = 'PARTY' OR @ENTITY1 <> 'PARTY'  OR @ENTITY1 IS NULL
 BEGIN  
  SELECT * FROM #TBLPARTY_DETAILS_TEMP  
 END  
 ELSE  
 BEGIN  
  INSERT INTO #ENTITYLIST_TEMP (ENTITY)  
  SELECT MSAJAG.DBO.CLS_PIECE(ITEMS, '-', 1)  
  FROM MSAJAG.DBO.CLS_SPLIT(@ENTITY_LIST, '|')  
  

  
  
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
  drop table #TBLPARTY_DETAILS_TEMP
 END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_PROC_F2CONFIG
-- --------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
create PROC [dbo].[CLS_PROC_F2CONFIG]    
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

--SELECT @F2CODE ,@F2PARAMS ,@F2WHFLDS,@F2WHVALS,@F2WHOPR,@USEXML,@WINDOWTITLE,@TABLEHEADER RETURN
--EXEC .DBO.PROC_F2CONFIG 'F000000002','IN','','','',0,'TITLE','TAB'    
--EXEC DBO.CLS_PROC_F2CONFIG 'F000000131','A|AZZZZZZ|NSE|CAPITAL|BROKER|BROKER||%','','','',0,'','' 
--SELECT * FROM F2CONFIG   
/*
DECLARE @P8 VARCHAR(100)
SET @P8='CODE'
DECLARE @P9 VARCHAR(200)
SET @P9='CODE,DESCRIPTION'
EXEC PRADNYA..CLS_F2CONFIG_WRAPPER @F2CODE='F000000077',@F2PARAMS='1|||T|%',@F2WHFLDS='EXCHANGE,',@F2WHVALS='NSE,',@F2WHOPR='=,',@ENTITY='',@ENTITY_LIST='',@WINDOWTITLE=@P8 OUTPUT,@TABLEHEADER=@P9 OUTPUT
SELECT @P8, @P9



SELECT  DISTINCT CONVERT(VARCHAR,TABLE_NO)TABLE_NO,UPPER(TABLE_NAME) FROM MSAJAG..BRANCHBROKTABLE WHERE 1 = 1  AND TABLE_NO LIKE '1' + '%'  
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
 FROM    CLS_F2CONFIG          
 WHERE     F2CODE = @F2CODE  
 

 

  IF @OBJTYPE = 'T' OR @OBJTYPE = 'P'
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

		  SELECT @@PATIDX = PATINDEX('%|SLBS|%', @F2PARAMS)
		  
		  IF @@PATIDX > 0
		  BEGIN
			SELECT @SEGMENT = SUBSTRING (@F2PARAMS, PATINDEX('%|SLBS|%', @F2PARAMS) + 1, 4)

			SELECT @EXCHANGE = SUBSTRING (@F2PARAMS, PATINDEX('%|SLBS|%', @F2PARAMS) - 3, 3)
		  END

		END
		 
		DECLARE @STRSHAREDB VARCHAR(30)
		SET @STRSHAREDB = ''
		SELECT TOP 1 @STRSHAREDB = SHAREDB FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT

		DECLARE @STRACCDB VARCHAR(30)
		SET @STRACCDB = ''
		SELECT TOP 1 @STRACCDB = ACCOUNTDB FROM CLS_MULTICOMPANY (NOLOCK) 
		WHERE EXCHANGE =@EXCHANGE AND SEGMENT = @SEGMENT


	END

IF @CONNECTIONDB = ''
	SET @DATABASENAME = @DATABASENAME
ELSE IF @STRSHAREDB <> '' AND @CONNECTIONDB <> 'A'
    SET @DATABASENAME = @STRSHAREDB
ELSE IF @EXCHANGE <> '' AND @SEGMENT <> ''
	SET @DATABASENAME = @STRACCDB
 
 IF @OBJTYPE = 'T' OR @OBJTYPE = 'V'          
  BEGIN   
  -- SET @OBJNAME = @MULTISERVER + @OBJNAME          
   SET @SQL = "SELECT  " + @OBJECTOUT + " FROM "+ @DATABASENAME + ".." + @OBJNAME + " WHERE 1 = 1 "   
  print @sql        
   IF LEN(@PARAMFIELDS) > 0          
    BEGIN  
	     
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .DBO.CLS_PIECE(@PARAMFIELDS, ',', @PARAMPOS)          
       IF @PARAMNAME = '' OR @PARAMNAME IS NULL          
        BEGIN          
			BREAK          
        END    
       SET @PARAMVAL = .DBO.CLS_PIECE(@F2PARAMS, '|', @PARAMPOS)          
       SET @PARAMOPR = .DBO.CLS_PIECE(@PARAMOPRLIST, ',', @PARAMPOS)          
       SET @SQL = @SQL + " AND " + @PARAMNAME + " " + (CASE WHEN @PARAMOPR = '' OR @PARAMOPR IS NULL THEN '=' ELSE @PARAMOPR END) + " '" + (CASE WHEN @PARAMVAL = '' OR @PARAMVAL IS NULL THEN CASE WHEN @PARAMOPR = 'LIKE' THEN '' ELSE '0' END ELSE @PARAMVAL END) + "' + '" + (CASE WHEN @PARAMOPR = 'LIKE' THEN '%' ELSE '' END) + "' "          
       SET @PARAMPOS = @PARAMPOS + 1
	   print @SQL
	     
      END          
    END 

	       
   IF LEN(@F2WHFLDS) > 0          
    BEGIN   
     SET @PARAMPOS = 1          
     WHILE 1 = 1          
      BEGIN          
       SET @PARAMNAME = .DBO.CLS_PIECE(@F2WHFLDS, ',', @PARAMPOS)       
			 IF @PARAMNAME IS NULL          
        BEGIN          
         BREAK          
        END          
       IF CHARINDEX('~',@PARAMNAME) > 0    
       BEGIN   
			 SET @PARAMNAME = REPLACE(@PARAMNAME, '~', ',')    
       END  
       SET @PARAMVAL = .DBO.CLS_PIECE(@F2WHVALS, ',', @PARAMPOS)          
       SET @PARAMOPR = .DBO.CLS_PIECE(@F2WHOPR, ',', @PARAMPOS)    
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
  
   EXEC(@SQL)          
  END        
 ELSE IF @OBJTYPE = 'P'          
  BEGIN          

  PRINT 'P' 
      
   CREATE TABLE #PARANAMES (SRNO INT IDENTITY(1,1), PARANAME VARCHAR(256))          
   IF @DATABASENAME <> ''          
    BEGIN          
	 SET @SQL = "SELECT COLORDER, NAME INTO #PARAMTEMP FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')   ORDER BY COLORDER"  		
     --SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM " + @DATABASENAME + "..SYSCOLUMNS WHERE ID = (SELECT ID FROM " + @DATABASENAME + "..SYSOBJECTS WHERE NAME = '" + @OBJNAME + "' AND XTYPE = 'P' AND USER_NAME(UID) = '" + @SCHEMA_NAME + "')  "          
	 SET @SQL = @SQL + " INSERT INTO #PARANAMES (PARANAME) SELECT NAME FROM #PARAMTEMP ORDER BY COLORDER "
     PRINT @SQL        
     EXEC (@SQL)     
	 PRINT @DATABASENAME       
     SET @PARAMCUR = CURSOR FOR SELECT PARANAME FROM #PARANAMES ORDER BY SRNO
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
	  
     PRINT 'C'             
      SET @PARAMCUR = CURSOR FOR SELECT NAME FROM SYSCOLUMNS WHERE ID = (SELECT ID FROM SYSOBJECTS WHERE NAME = @OBJNAME AND XTYPE = 'P')          
     END          
       
   OPEN @PARAMCUR  
   PRINT 'D'               
   FETCH NEXT FROM @PARAMCUR INTO @PARAMFIELDS          
   SET @SQL = ''      
    
   SET @PARAMPOS = 1          
   WHILE @@FETCH_STATUS = 0          
    BEGIN          
		PRINT @PARAMFIELDS
     SET @PARAMVAL = .DBO.CLS_PIECE(@F2PARAMS, '|', @PARAMPOS)          
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
   	 PRINT @SQL  
   IF LEN(@SQL) > 0          
    BEGIN         
    PRINT @DATABASENAME  
     SET @SQL = @DATABASENAME + '..' + @OBJNAME + ' ' + SUBSTRING(@SQL, 1, LEN(@SQL)-1)          
    END          
   ELSE          
    BEGIN   
	PRINT @DATABASENAME      
     SET @SQL = @DATABASENAME + '..' + @OBJNAME          
    END
	 	         
    EXEC SP_EXECUTESQL @SQL          
  PRINT 'PRINTED Q ' +  @SQL         
  END          
    
	print @SQL
    
END TRY          
BEGIN CATCH          
  DECLARE @ERRMSG VARCHAR(1000)          
  SET @ERRMSG = ERROR_MESSAGE()          
  RAISERROR(@ERRMSG, 16, 1)          
END CATCH     
    
--COMMIT

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
-- PROCEDURE dbo.Test
-- --------------------------------------------------
CREATE  PROC [dbo].[Test]--Test 'D:\backoffice\pnsehold128.csv'   
@Test_File AS VARCHAR(MAX)  
AS   
BEGIN  
  
TRUNCATE TABLE PNSEHOLD128;  
  
DECLARE @SQL VARCHAR(2000)  
  
SET NOCOUNT ON  
SET @SQL = 'BULK INSERT PNSEHOLD128 FROM ''' + @Test_File + ''' WITH (FIRSTROW = 1,FIELDTERMINATOR = '','',ROWTERMINATOR = ''\n'') '  
EXEC(@SQL)  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYSHARELEDGER
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[V2_PROC_QUARTERLYSHARELEDGER]              
              
(              
               @FROMDATE   VARCHAR(11),              
               @TODATE     VARCHAR(11),              
               @FROMPARTY  VARCHAR(10),              
               @TOPARTY    VARCHAR(10),              
               @FROMSCRIP  VARCHAR(12),              
               @TOSCRIP    VARCHAR(12),              
               @STATUSID   VARCHAR(50),              
               @STATUSNAME VARCHAR(50))              
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
    
EXEC BSEDB.DBO.RPT_HOLDCHECK_FINAL @FROMDATE, @TODATE    
    
EXEC MSAJAG.DBO.RPT_HOLDCHECK_FINAL @FROMDATE, @TODATE    
    
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER    
SELECT * FROM BSEDB.DBO.V2_DELHOLDFINAL    
    
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER    
SELECT * FROM MSAJAG.DBO.V2_DELHOLDFINAL    
    
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
  PARTY_CODE, SCRIP_CD, SERIES, ISIN,            
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),            
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))          
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST           
  WHERE            
   EFFDATE < @FROMDATE            
   AND PARTY_CODE   >= @FROMPARTY          
   AND PARTY_CODE <= @TOPARTY          
  GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS            
 ) X          
 GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, ISIN          
          
          
          
INSERT INTO #COLL            
SELECT             
EXCHANGE,            
SEGMENT,            
'',            
convert(varchar,effdate,103),             
PARTY_CODE, SCRIP_CD, SERIES, '', ISIN,            
CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),            
DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END)),            
UPPER(REMARKS),            
EFFDATE,            
1            
FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST            
WHERE            
 EFFDATE >= @FROMDATE            
 AND EFFDATE <= @TODATE + ' 23:59:59'            
 AND PARTY_CODE   >= @FROMPARTY          
 AND PARTY_CODE <= @TOPARTY          
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, EFFDATE, REMARKS            
            
            
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
  PARTY_CODE, SCRIP_CD, SERIES, ISIN,            
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),            
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))          
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST           
  WHERE            
EFFDATE <= @TODATE  + ' 23:59:59'          
   AND PARTY_CODE   >= @FROMPARTY          
   AND PARTY_CODE <= @TOPARTY          
  GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS            
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
  ANAND1.MSAJAG.DBO.SCRIP1 S1 (NOLOCK),              
  ANAND1.MSAJAG.DBO.SCRIP2 S2 (NOLOCK)              
 WHERE              
  S1.CO_CODE = S2.CO_CODE        
  AND S2.SCRIP_CD = #COLL.SCRIP_CD              
  AND S2.SERIES = #COLL.SERIES              
            
                
            
UPDATE #COLL            
SET SCRIP_NAME = S1.LONG_NAME              
 FROM              
  ANGELBSECM.BSEDB_AB.DBO.SCRIP1 S1 (NOLOCK),              
  ANGELBSECM.BSEDB_AB.DBO.SCRIP2 S2 (NOLOCK)              
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
-- PROCEDURE dbo.V2_PROC_QUARTERLYSHARELEDGER_dkm
-- --------------------------------------------------
            
CREATE PROCEDURE [dbo].[V2_PROC_QUARTERLYSHARELEDGER_dkm]            
            
(            
               @FROMDATE   VARCHAR(11),            
               @TODATE     VARCHAR(11),            
               @FROMPARTY  VARCHAR(10),            
               @TOPARTY    VARCHAR(10),            
               @FROMSCRIP  VARCHAR(12),            
               @TOSCRIP    VARCHAR(12),            
               @STATUSID   VARCHAR(50),            
               @STATUSNAME VARCHAR(50))            
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
        REASON      VARCHAR(255),            
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
            
            
/* NOW DOING BSECM */            
            
        
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
            
/*           
          
           
SELECT EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN,          
effdate, SUM(QTY)          
FROM C_SECURITIESMST          
where effdate >= '' and effdate <= ''          
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, effdate          
          
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
  PARTY_CODE, SCRIP_CD, SERIES, ISIN,          
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),          
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))        
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST         
  WHERE          
   EFFDATE < @FROMDATE          
   AND PARTY_CODE   >= @FROMPARTY        
   AND PARTY_CODE <= @TOPARTY        
  GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS          
 ) X        
 GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, ISIN        
        
        
        
INSERT INTO #COLL          
SELECT           
EXCHANGE,          
SEGMENT,          
'',          
convert(varchar,effdate,103),           
PARTY_CODE, SCRIP_CD, SERIES, '', ISIN,          
CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),          
DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END)),          
UPPER(REMARKS),          
EFFDATE,          
1          
FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST          
WHERE          
 EFFDATE >= @FROMDATE          
 AND EFFDATE <= @TODATE + ' 23:59:59'          
 AND PARTY_CODE   >= @FROMPARTY        
 AND PARTY_CODE <= @TOPARTY        
GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, EFFDATE, REMARKS          
          
          
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
  PARTY_CODE, SCRIP_CD, SERIES, ISIN,          
  CQTY = SUM((CASE WHEN DRCR = 'C' THEN QTY ELSE 0 END)),          
  DQTY = SUM((CASE WHEN DRCR = 'D' THEN QTY ELSE 0 END))        
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST         
  WHERE          
   EFFDATE <= @TODATE  + ' 23:59:59'        
   AND PARTY_CODE   >= @FROMPARTY        
   AND PARTY_CODE <= @TOPARTY        
  GROUP BY EXCHANGE, SEGMENT, PARTY_CODE, SCRIP_CD, SERIES, DRCR, ISIN, REMARKS          
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
  ANAND1.MSAJAG.DBO.SCRIP1 S1 (NOLOCK),            
  ANAND1.MSAJAG.DBO.SCRIP2 S2 (NOLOCK)            
 WHERE            
  S1.CO_CODE = S2.CO_CODE            
  AND S2.SCRIP_CD = #COLL.SCRIP_CD            
  AND S2.SERIES = #COLL.SERIES            
          
              
          
UPDATE #COLL          
SET SCRIP_NAME = S1.LONG_NAME            
 FROM            
  ANAND.BSEDB_AB.DBO.SCRIP1 S1 (NOLOCK),            
  ANAND.BSEDB_AB.DBO.SCRIP2 S2 (NOLOCK)            
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
        
--select * from V2_CLASS_QUARTERLYSECLEDGER        
  
DELETE ANAND.PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER  
  
INSERT INTO ANAND.PRADNYA.DBO.V2_CLASS_QUARTERLYSECLEDGER  
SELECT * FROM V2_CLASS_QUARTERLYSECLEDGER  
  
        
SET ANSI_NULLS OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_PROC_QUARTERLYSHARELEDGER_new
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[V2_PROC_QUARTERLYSHARELEDGER_new]              
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
    
EXEC MSAJAG.DBO.RPT_HOLDCHECK_FINAL @FROMDATE, @TODATE, '', @FROMPARTY, @TOPARTY        
    
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER    
SELECT * FROM BSEDB.DBO.V2_DELHOLDFINAL    
    
INSERT INTO V2_CLASS_QUARTERLYSECLEDGER    
SELECT * FROM MSAJAG.DBO.V2_DELHOLDFINAL    

     
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
	PARTY_CODE	VARCHAR(15),
	PARTYNAME	VARCHAR(100),
	PARENTCODE	VARCHAR(15),
	BRANCH_CD	VARCHAR(15),
	SUB_BROKER	VARCHAR(15)
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
		ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK)
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
		ANAND1.PRADNYA.DBO.TBLCLIENT_GROUP T WITH (NOLOCK),
		ANAND1.MSAJAG.DBO.CLIENT_DETAILS C WITH (NOLOCK)
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
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
  ANAND1.MSAJAG.DBO.SCRIP1 S1 WITH (NOLOCK),              
  ANAND1.MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK)
 WHERE              
  S1.CO_CODE = S2.CO_CODE        
  AND S2.SCRIP_CD = #COLL.SCRIP_CD        
  AND S2.SERIES = #COLL.SERIES         
            
                
            
UPDATE #COLL            
SET SCRIP_NAME = S1.LONG_NAME              
 FROM              
  ANAND.BSEDB_AB.DBO.SCRIP1 S1 WITH (NOLOCK),              
  ANAND.BSEDB_AB.DBO.SCRIP2 S2 WITH (NOLOCK)
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
-- PROCEDURE dbo.V2_PROC_YEARLYSHARELEDGER_new
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[V2_PROC_YEARLYSHARELEDGER_new]              
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
    
TRUNCATE TABLE V2_CLASS_YEARLYSECLEDGER    

 
    
--EXEC BSEDB.DBO.RPT_HOLDCHECK_YEAR_FINAL @FROMDATE, @TODATE, '', @FROMPARTY, @TOPARTY    
    
--EXEC MSAJAG.DBO.RPT_HOLDCHECK_YEAR_FINAL @FROMDATE, @TODATE, '', @FROMPARTY, @TOPARTY        
    
INSERT INTO V2_CLASS_YEARLYSECLEDGER    
SELECT * FROM BSEDB.DBO.V2_DELHOLDFINAL    
    
INSERT INTO V2_CLASS_YEARLYSECLEDGER    
SELECT * FROM MSAJAG.DBO.V2_DELHOLDFINAL    
    
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
INSERT INTO V2_CLASS_YEARLYSECLEDGER              
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
	PARTY_CODE	VARCHAR(15),
	PARTYNAME	VARCHAR(100),
	PARENTCODE	VARCHAR(15),
	BRANCH_CD	VARCHAR(15),
	SUB_BROKER	VARCHAR(15)
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
		ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH (NOLOCK)
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
		ANAND1.PRADNYA.DBO.TBLCLIENT_GROUP T WITH (NOLOCK),
		ANAND1.MSAJAG.DBO.CLIENT_DETAILS C WITH (NOLOCK)
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
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
  FROM ANAND1.MSAJAG.DBO.C_SECURITIESMST S WITH (NOLOCK)
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
  ANAND1.MSAJAG.DBO.SCRIP1 S1 WITH (NOLOCK),              
  ANAND1.MSAJAG.DBO.SCRIP2 S2 WITH (NOLOCK)
 WHERE              
  S1.CO_CODE = S2.CO_CODE        
  AND S2.SCRIP_CD = #COLL.SCRIP_CD        
  AND S2.SERIES = #COLL.SERIES              
            
                
            
UPDATE #COLL            
SET SCRIP_NAME = S1.LONG_NAME              
 FROM              
  ANGELBSECM.BSEDB_AB.DBO.SCRIP1 S1 WITH (NOLOCK),              
  ANGELBSECM.BSEDB_AB.DBO.SCRIP2 S2 WITH (NOLOCK)
 WHERE              
  S1.CO_CODE = S2.CO_CODE              
  AND S2.BSECODE = #COLL.SCRIP_CD              
            
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
INSERT INTO V2_CLASS_YEARLYSECLEDGER              
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
          
--- Select * from V2_CLASS_YEARLYSECLEDGER          

Delete from V2_CLASS_YEARLYSECLEDGER where Party_code in ('BROKER','EEEE','SSSS')
          
SET ANSI_NULLS OFF

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
-- TABLE dbo.BSE_V2_DELHOLDFINAL
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_V2_DELHOLDFINAL]
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
-- TABLE dbo.MSAJAGDELTRANS
-- --------------------------------------------------
CREATE TABLE [dbo].[MSAJAGDELTRANS]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_type] VARCHAR(2) NOT NULL,
    [RefNo] INT NOT NULL,
    [TCode] NUMERIC(18, 0) NOT NULL,
    [TrType] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 0) NOT NULL,
    [FromNo] VARCHAR(16) NULL,
    [ToNo] VARCHAR(16) NULL,
    [CertNo] VARCHAR(16) NULL,
    [FolioNo] VARCHAR(16) NULL,
    [HolderName] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [DrCr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [OrgQty] NUMERIC(18, 0) NULL,
    [DpType] VARCHAR(10) NULL,
    [DpId] VARCHAR(16) NULL,
    [CltDpId] VARCHAR(16) NULL,
    [BranchCd] VARCHAR(10) NOT NULL,
    [PartipantCode] VARCHAR(10) NOT NULL,
    [SlipNo] NUMERIC(18, 0) NULL,
    [BatchNo] VARCHAR(10) NULL,
    [ISett_No] VARCHAR(7) NULL,
    [ISett_Type] VARCHAR(2) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MULTICOMPANY
-- --------------------------------------------------
CREATE TABLE [dbo].[MULTICOMPANY]
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
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(25) NULL,
    [License] VARCHAR(500) NULL,
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [CATEGORY] VARCHAR(50) NULL
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
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL,
    [Category] VARCHAR(12) NULL,
    [PAYMENT_BANK] VARCHAR(10) NULL,
    [ExchangeGroup] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PBSEHOLD128
-- --------------------------------------------------
CREATE TABLE [dbo].[PBSEHOLD128]
(
    [PartyCode] VARCHAR(50) NULL,
    [PartyName] VARCHAR(100) NULL,
    [ScrpCode] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DpId] VARCHAR(50) NULL,
    [CltCode] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [SettNo] VARCHAR(50) NULL,
    [SettType] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PDFFORMAT
-- --------------------------------------------------
CREATE TABLE [dbo].[PDFFORMAT]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PDFCODE] VARCHAR(10) NULL,
    [REPORTSECTION] VARCHAR(2) NULL,
    [OBJECTNAME] VARCHAR(50) NULL,
    [FONT_NAME] VARCHAR(30) NULL,
    [FONT_SIZE] TINYINT NULL,
    [BOLD] BIT NULL,
    [UNDERLINE] BIT NULL,
    [STRIKEOUT] BIT NULL,
    [ITALIC] BIT NULL,
    [MULTISECTIONNAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PDFMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[PDFMASTER]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
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
-- TABLE dbo.PNSEHOLD128
-- --------------------------------------------------
CREATE TABLE [dbo].[PNSEHOLD128]
(
    [PartyCode] VARCHAR(50) NULL,
    [PartyName] VARCHAR(100) NULL,
    [ScrpCode] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [DpId] VARCHAR(50) NULL,
    [CltCode] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [SettNo] VARCHAR(50) NULL,
    [SettType] VARCHAR(50) NULL,
    [HoldQty] VARCHAR(50) NULL,
    [PledgeQty] VARCHAR(50) NULL,
    [Qty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.QL_Hold_SCCS131014_all
-- --------------------------------------------------
CREATE TABLE [dbo].[QL_Hold_SCCS131014_all]
(
    [Segment] VARCHAR(5) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Net] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sebi_Cir
-- --------------------------------------------------
CREATE TABLE [dbo].[Sebi_Cir]
(
    [Party_code] VARCHAR(10) NULL
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
-- TABLE dbo.TBL_ISIN_MASTERARC_DKM
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ISIN_MASTERARC_DKM]
(
    [SEGMENT] VARCHAR(5) NOT NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [SERIES] VARCHAR(3) NULL,
    [CERTNO] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCS_CL2312
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCS_CL2312]
(
    [Party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLDEL_TRANSSTAT_QRLY
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLDEL_TRANSSTAT_QRLY]
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
    [Qty] NUMERIC(18, 0) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 0) NULL,
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
    [Filler5] INT NULL,
    [SCRIP_NAME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLDEL_TRANSSTAT1_QRLY
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLDEL_TRANSSTAT1_QRLY]
(
    [TRANSDATE] VARCHAR(30) NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SCRIP_NAME] VARCHAR(255) NULL,
    [CERTNO] VARCHAR(16) NULL,
    [CQTY] NUMERIC(38, 0) NULL,
    [DQTY] NUMERIC(38, 0) NULL,
    [SLIPNO] NUMERIC(18, 0) NULL,
    [DPID] VARCHAR(16) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [TRTYPE] NUMERIC(18, 0) NOT NULL,
    [REASON] VARCHAR(100) NULL,
    [BDPID] VARCHAR(16) NULL,
    [BCLTDPID] VARCHAR(16) NULL,
    [TRANSDATE1] DATETIME NOT NULL,
    [FLAG] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trace
-- --------------------------------------------------
CREATE TABLE [dbo].[trace]
(
    [RowNumber] INT IDENTITY(1,1) NOT NULL,
    [EventClass] INT NULL,
    [TextData] NTEXT NULL,
    [NTUserName] NVARCHAR(128) NULL,
    [ClientProcessID] INT NULL,
    [ApplicationName] NVARCHAR(128) NULL,
    [LoginName] NVARCHAR(128) NULL,
    [SPID] INT NULL,
    [Duration] BIGINT NULL,
    [StartTime] DATETIME NULL,
    [Reads] BIGINT NULL,
    [Writes] BIGINT NULL,
    [CPU] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trace_1
-- --------------------------------------------------
CREATE TABLE [dbo].[trace_1]
(
    [RowNumber] INT IDENTITY(1,1) NOT NULL,
    [EventClass] INT NULL,
    [TextData] NTEXT NULL,
    [NTUserName] NVARCHAR(128) NULL,
    [ClientProcessID] INT NULL,
    [ApplicationName] NVARCHAR(128) NULL,
    [LoginName] NVARCHAR(128) NULL,
    [SPID] INT NULL,
    [Duration] BIGINT NULL,
    [StartTime] DATETIME NULL,
    [Reads] BIGINT NULL,
    [Writes] BIGINT NULL,
    [CPU] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_CLASS_POOLTRANSACTIONS
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_POOLTRANSACTIONS]
(
    [EXCHANGE] VARCHAR(10) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(10) NULL,
    [SEC_PAYIN] VARCHAR(11) NULL,
    [PARTY_CODE] VARCHAR(12) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [SERIES] VARCHAR(3) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(20) NULL,
    [CLTDPID] VARCHAR(20) NULL,
    [PURQTY] INT NULL,
    [EXEDATE] VARCHAR(11) NULL,
    [SELLQTY] INT NULL,
    [RECDATE] VARCHAR(100) NULL,
    [RPTDATE] VARCHAR(20) NULL,
    [TRANSDATE] DATETIME NULL
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
-- TABLE dbo.V2_CLASS_YEARLYSECLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_CLASS_YEARLYSECLEDGER]
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
-- VIEW dbo.CLS_MULTICOMPANY
-- --------------------------------------------------


CREATE VIEW [dbo].[CLS_MULTICOMPANY]
AS
SELECT BROKERID,COMPANYNAME,SEGMENT_DESCRIPTION,EXCHANGE,SEGMENT,MEMBERTYPE,MEMBERCODE,SHAREDB,SHARESERVER,SHAREIP,ACCOUNTDB,ACCOUNTSERVER,ACCOUNTIP,DEFAULTDB,DEFAULTDBSERVER,DEFAULTDBIP,DEFAULTCLIENT,PANGIR_NO,PRIMARYSERVER,FILLER2,DBUSERNAME,DBPASSWORD,

	   LICENSE,APPSHARE_ROOTFLDR_NAME,CATEGORY,PAYMENT_BANK,EXCHANGEGROUP 
FROM MULTICOMPANY_ALL

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
-- VIEW dbo.MULTICOMPANY_ALL
-- --------------------------------------------------
CREATE VIEW [dbo].[MULTICOMPANY_ALL] 

AS


SELECT 
BrokerId,CompanyName,Segment_Description,Exchange,Segment,MemberType,MemberCode,ShareDb,ShareServer,ShareIP,AccountDb,
AccountServer,AccountIP,DefaultDb,DefaultDbServer,DefaultDbIP,DefaultClient,PANGIR_No,primaryServer,Filler2,
dbusername,dbpassword,License,AppShare_RootFldr_Name,Category,PAYMENT_BANK,'EQ' AS ExchangeGroup 
FROM MULTICOMPANY

UNION ALL


SELECT BROKERID
,COMPANYNAME
,SEGMENT_DESCRIPTION
,EXCHANGE
,SEGMENT
,MEMBERTYPE
,MEMBERCODE
,SHAREDB
,SHARESERVER
,SHAREIP
,ACCOUNTDB
,ACCOUNTSERVER
,ACCOUNTIP
,DEFAULTDB
,DEFAULTDBSERVER
,DEFAULTDBIP
,DEFAULTCLIENT
,PANGIR_NO
,PRIMARYSERVER
,FILLER2
,DBUSERNAME
,DBPASSWORD
,LICENSE
,APPSHARE_ROOTFLDR_NAME
,Category
,PAYMENT_BANK
,ExchangeGroup FROM MULTICOMPANY_ADDITIONAL

GO

