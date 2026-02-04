-- DDL Export
-- Server: 10.253.33.93
-- Database: PRADNYA
-- Exported: 2026-02-05T02:40:23.520477

USE PRADNYA;
GO

-- --------------------------------------------------
-- FUNCTION dbo.awsdms_fn_LsnSegmentToHexa
-- --------------------------------------------------
        
CREATE FUNCTION [dbo].[awsdms_fn_LsnSegmentToHexa] (@InputData VARBINARY(32)) RETURNS VARCHAR(64)
AS
  BEGIN
    DECLARE  @HexDigits   	CHAR(16),
             @OutputData      VARCHAR(64),
             @i           	INT,
             @InputDataLength INT

    DECLARE  @ByteInfo  	INT,
             @LeftNibble 	INT,
             @RightNibble INT

    SET @OutputData = ''

    SET @i = 1

    SET @InputDataLength = DATALENGTH(@InputData)

    SET @HexDigits = '0123456789abcdef'

    WHILE (@i <= @InputDataLength)
      BEGIN
        SET @ByteInfo = CONVERT(INT,SUBSTRING(@InputData,@i,1))
        SET @LeftNibble= FLOOR(@ByteInfo / 16)
        SET @RightNibble = @ByteInfo - (@LeftNibble* 16)
        SET @OutputData = @OutputData + SUBSTRING(@HexDigits,@LeftNibble+ 1,1) + SUBSTRING(@HexDigits,@RightNibble + 1,1)
        SET @i = @i + 1
      END

    RETURN @OutputData

  END

GO

-- --------------------------------------------------
-- FUNCTION dbo.awsdms_fn_NumericLsnToHexa
-- --------------------------------------------------
        
CREATE FUNCTION [dbo].[awsdms_fn_NumericLsnToHexa](@numeric25Lsn numeric(25,0)) returns varchar(32)
 AS
 BEGIN
-- In order to avoid form sign overflow problems - declare the LSN segments 
-- to be one 'type' larger than the intendent target type.
-- For example, convert(smallint, convert(numeric(25,0),65535)) will fail 
-- but convert(binary(2), convert(int,convert(numeric(25,0),65535))) will give the 
-- expected result of 0xffff.

declare @high4bytelsnSegment bigint,@mid4bytelsnSegment bigint,@low2bytelsnSegment int
declare @highFactor bigint, @midFactor int

declare @lsnLeftSeg	binary(4)
declare @lsnMidSeg	binary(4)
declare @lsnRightSeg	binary(2)

declare	@hexaLsn	varchar(32)

select @highFactor = 1000000000000000
select @midFactor  = 100000

select @high4bytelsnSegment = convert(bigint, floor(@numeric25Lsn / @highFactor))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @high4bytelsnSegment) * @highFactor
select @mid4bytelsnSegment = convert(bigint,floor(@numeric25Lsn / @midFactor ))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @mid4bytelsnSegment) * @midFactor
select @low2bytelsnSegment = convert(int, @numeric25Lsn)

set	@lsnLeftSeg	= convert(binary(4), @high4bytelsnSegment)
set	@lsnMidSeg	= convert(binary(4), @mid4bytelsnSegment)
set   @lsnRightSeg	= convert(binary(2), @low2bytelsnSegment)

return [dbo].[awsdms_fn_LsnSegmentToHexa](@lsnLeftSeg)+':'+[dbo].[awsdms_fn_LsnSegmentToHexa](@lsnMidSeg)+':'+[dbo].[awsdms_fn_LsnSegmentToHexa](@lsnRightSeg)
END

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
  
DECLARE @NDSETTNO VARCHAR(7)  
DECLARE @NEWSETT_NO VARCHAR(10),  
@PDATE DATETIME  
  
DECLARE @PREVDATE DATETIME  
 SELECT @PREVDATE = MAX(START_DATE) FROM [AngelNseCM].MSAJAG.DBO.SETT_MST WHERE START_DATE < @BUSINESS_DATE  
 and Sett_Type = 'N'  
  
set @PDATE = @PREVDATE    
if (CASE WHEN (@PARAMETER LIKE '%<DATEP109>%' OR @PARAMETER LIKE '%<DATEP106NSD>%' or @PARAMETER LIKE '%<DATEP106NS>%' OR @PARAMETER LIKE '%<DATEP106>%' OR @PARAMETER LIKE '%<DATEPDDMMYYYY>%')     
   THEN 1 ELSE 0 END) > 0     
begin    
   
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEPDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@PDATE,103),'/',''))      
  
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106NS>', REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''))    
    
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106NSD>', (CASE WHEN LEFT(REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''),1) = '0'    
                   THEN RIGHT(REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''),8)    
                ELSE REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', '')    
                 END))    
    
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106>', CONVERT(VARCHAR,@PDATE,106))    
    
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP109>', LEFT(CONVERT(VARCHAR,@PDATE,109),11))    
end   
SET @PARAMETER = REPLACE(@PARAMETER,'<DATE106NSD>', (CASE WHEN LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''),1) = '0'    
                   THEN RIGHT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''),8)    
                ELSE REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', '')    
                 END))    
                       
                       
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
-- FUNCTION dbo.fn_CLASS_Auto_Process_Replace_30062021
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
DECLARE @NEWSETT_NO VARCHAR(10),
@PDATE DATETIME

DECLARE @PREVDATE DATETIME
	SELECT @PREVDATE = MAX(START_DATE) FROM [196.1.115.196].MSAJAG.DBO.SETT_MST WHERE START_DATE < @BUSINESS_DATE
	and Sett_Type = 'N'

set @PDATE = @PREVDATE  
if (CASE WHEN (@PARAMETER LIKE '%<DATEP109>%' OR @PARAMETER LIKE '%<DATEP106NSD>%' or @PARAMETER LIKE '%<DATEP106NS>%' OR @PARAMETER LIKE '%<DATEP106>%' OR @PARAMETER LIKE '%<DATEPDDMMYYYY>%')   
   THEN 1 ELSE 0 END) > 0   
begin  
 
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEPDDMMYYYY>', REPLACE(CONVERT(VARCHAR,@PDATE,103),'/',''))    

  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106NS>', REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''))  
  
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106NSD>', (CASE WHEN LEFT(REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''),1) = '0'  
                   THEN RIGHT(REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', ''),8)  
                ELSE REPLACE(CONVERT(VARCHAR,@PDATE,106),' ', '')  
                 END))  
  
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP106>', CONVERT(VARCHAR,@PDATE,106))  
  
  SET @PARAMETER = REPLACE(@PARAMETER,'<DATEP109>', LEFT(CONVERT(VARCHAR,@PDATE,109),11))  
end 
SET @PARAMETER = REPLACE(@PARAMETER,'<DATE106NSD>', (CASE WHEN LEFT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''),1) = '0'  
                   THEN RIGHT(REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', ''),8)  
                ELSE REPLACE(CONVERT(VARCHAR,@BUSINESS_DATE,106),' ', '')  
                 END))  
                 	   
                 	   
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

Create  Function fnMax(@Value1 money, @Value2 Money ) 
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

Create  Function fnMin(@Value1 money, @Value2 Money ) 
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
-- FUNCTION dbo.GETFNSPLITSTRING
-- --------------------------------------------------
  CREATE FUNCTION [dbo].[GETFNSPLITSTRING](  
                @SPLITSTRING VARCHAR(1000),  
                @DELIMITER   VARCHAR(3))  
RETURNS   
 VARCHAR(8000)  
  
AS  
  
  
/* Split the String and get splitted values in the result-set. Delimiter upto 3 characters long can be used for splitting */  
BEGIN     
  DECLARE    
  @STRING         VARCHAR(1000),  
  @POSITION       INT,  
  @START_LOCATION INT,  
  @STRING_LENGTH  INT  
                             
DECLARE @OUTVAL  VARCHAR(8000)  
SET @OUTVAL = ''  
  
DECLARE @PREVSTRING VARCHAR(100)  
SET @PREVSTRING = ''  
  
  SET @STRING = @SPLITSTRING  
  SET @POSITION = 0  
  SET @START_LOCATION = 0  
  SET @STRING_LENGTH = LEN(@STRING)  
  
                         
  WHILE @STRING_LENGTH > 0  
    BEGIN  
      SET @POSITION = CHARINDEX(@DELIMITER,@STRING,@START_LOCATION)  
      IF @POSITION = 0  
        BEGIN  
          SET @PREVSTRING = '/'  
          SET @STRING_LENGTH = 0  
        END  
        ELSE  
        BEGIN  
          SET @PREVSTRING = LEFT(@STRING,@POSITION - 1)  
          SET @STRING = RIGHT(@STRING,@STRING_LENGTH - @POSITION)  
          SET @STRING_LENGTH = LEN(@STRING)       
  END  
  IF @STRING_LENGTH > 0   
  BEGIN  
   SET @OUTVAL = @OUTVAL + '/' + @PREVSTRING  
  END  
    END  
SET @OUTVAL = REPLACE(@OUTVAL,'//','/')  
RETURN @OUTVAL + '/'  
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



CREATE   Function [dbo].[ReplaceTradeNo](@TradeNo  Varchar(20)) 
Returns Varchar(20) As
Begin
	Select @TradeNo = (Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(@TradeNo,'R',''),'E',''),'A',''),'X',''),'B',''),'T',''),'S',''),'I',''),'U','') )   

Return @TradeNo 
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RoundedToThousand
-- --------------------------------------------------


CREATE Function RoundedToThousand(@Amt Numeric(18,4))
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


CREATE  Function RoundedTurnover(@Amt Numeric(18,4), @roundingAmt Numeric(18,4))
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
-- INDEX dbo.DataIn_History_Fosettlement_NseCurFo
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ContractIDx] ON [dbo].[DataIn_History_Fosettlement_NseCurFo] ([Sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.DataIn_History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ContractIDx] ON [dbo].[DataIn_History_Fosettlement_Nsefo] ([Sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Foclosing_Billreport_NseCurFo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Partydate] ON [dbo].[History_Foclosing_Billreport_NseCurFo] ([Trade_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Foclosing_NseCurFo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Partydate] ON [dbo].[History_Foclosing_NseCurFo] ([Trade_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Fosettlement_NseCurFo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxParty] ON [dbo].[History_Fosettlement_NseCurFo] ([Sauda_date], [Party_Code], [Inst_type], [Symbol], [Expirydate], [Strike_price], [Option_type], [AuctionPart], [Sell_buy])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDX_History_Fosettlement_Nsefo_Party_Code_Sauda_date_INCL_User_id] ON [dbo].[History_Fosettlement_Nsefo] ([Party_Code], [Sauda_date]) INCLUDE ([User_id])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxParty] ON [dbo].[History_Fosettlement_Nsefo] ([Sauda_date], [Party_Code], [Inst_type], [Symbol], [Expirydate], [Strike_price], [Option_type], [AuctionPart], [Sell_buy])

GO

-- --------------------------------------------------
-- INDEX dbo.History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_SAUDA_DATE] ON [dbo].[History_Fosettlement_Nsefo] ([Sauda_date])

GO

-- --------------------------------------------------
-- INDEX dbo.HISTORY_TBL_CLIENTMARGIN_NSEFO
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [clmidx] ON [dbo].[HISTORY_TBL_CLIENTMARGIN_NSEFO] ([party_code], [margindate], [branch_cd], [lst_update_dt])

GO

-- --------------------------------------------------
-- INDEX dbo.HISTORY_TBL_CLIENTMARGIN_NSEFO
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxDt] ON [dbo].[HISTORY_TBL_CLIENTMARGIN_NSEFO] ([margindate], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.HISTORY_TBL_MTOMPREMIUMBILL
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxMtom] ON [dbo].[HISTORY_TBL_MTOMPREMIUMBILL] ([billdate], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.MULTICOMPANY_ADDITIONAL
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXEX] ON [dbo].[MULTICOMPANY_ADDITIONAL] ([EXCHANGE], [SEGMENT])

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.awsdms_truncation_safeguard
-- --------------------------------------------------
ALTER TABLE [dbo].[awsdms_truncation_safeguard] ADD CONSTRAINT [PK__awsdms_t__65C99AC8488F6DF4] PRIMARY KEY ([latchTaskName], [latchMachineGUID], [LatchKey])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataIn_History_Fosettlement_NseCurFo
-- --------------------------------------------------
ALTER TABLE [dbo].[DataIn_History_Fosettlement_NseCurFo] ADD CONSTRAINT [PK_DataIn_History_Fosettlement_NseCurFo] PRIMARY KEY ([Sauda_Date], [expirydate])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PDFMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[PDFMASTER] ADD CONSTRAINT [PK_PDFMASTER] PRIMARY KEY ([PDFCODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.REPORTMASTER_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[REPORTMASTER_NEW] ADD CONSTRAINT [PK_REPORTMASTER_NEW] PRIMARY KEY ([RM_Report_Code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sauda_date
-- --------------------------------------------------
ALTER TABLE [dbo].[sauda_date] ADD CONSTRAINT [PK__sauda_date__3493CFA7] PRIMARY KEY ([RowNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sauda_trace
-- --------------------------------------------------
ALTER TABLE [dbo].[sauda_trace] ADD CONSTRAINT [PK__sauda_trace__367C1819] PRIMARY KEY ([RowNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__5D95E53A] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

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
-- PROCEDURE dbo.GETPDFSETTINGS
-- --------------------------------------------------

CREATE PROC [dbo].[GETPDFSETTINGS]
(
	@PDFCODE VARCHAR(10)
)
AS
/*
	EXEC GETPDFSETTINGS 'P000000002'
	SELECT * FROM PDFMASTER
*/
SELECT
	PDFCODE,
	PDFDESCRIPTION,
	EXCHANGE,
	SEGMENT,
	SPNAME,
	RPTFILE,
	FILE_SUFFIX = ISNULL(FILE_SUFFIX, ''),
	FILE_PREFIX = ISNULL(FILE_PREFIX, ''),
	FIELDINFILENAME = ISNULL(FIELDINFILENAME, ''),
	DATESTAMP = ISNULL(DATESTAMP, 0),
	DTFORMAT = ISNULL(DTSTAMPFORMAT, 'DDMMYYYY'),
	NAMEDELIMETER = ISNULL(NAMEDELIMETER, ''),
	PDFON = ISNULL(PDFON, ''),
	SERVERIP,
	DATABASENAME,
	USER_NAME,
	USER_PASSWORD,
	PARAMETERPOSITION = ISNULL(PARAMETERPOSITION, ''),
	SIGNFIELD = ISNULL(SIGIMGFIELD, '')
FROM
	PDFMASTER
WHERE
	PDFCODE = @PDFCODE

DECLARE
	@EXCHANGE VARCHAR(10),
	@SEGMENT VARCHAR(10),
	@PROCNAME VARCHAR(256),
	@SERVERIP VARCHAR(50),
	@DBNAME VARCHAR(20),
	@SQL VARCHAR(8000),
	@OBJID INT

SELECT
	@EXCHANGE = EXCHANGE,
	@SEGMENT = SEGMENT,
	@PROCNAME = SPNAME,
	@SERVERIP = SERVERIP,
	@DBNAME = DATABASENAME
FROM
	PDFMASTER
WHERE
	PDFCODE = @PDFCODE

EXEC PDFCOMPANYINFO @EXCHANGE, @SEGMENT

CREATE TABLE #OBJID(ID INT)

SET @SQL = "INSERT INTO #OBJID (ID) SELECT OBJECT_ID FROM " + @DBNAME + ".SYS.OBJECTS WHERE NAME = '" + @PROCNAME + "'"
EXEC (@SQL)

SELECT
	@OBJID = ID
FROM
	#OBJID

DROP TABLE #OBJID

CREATE TABLE #OBJPARAMS (PARAMNAME VARCHAR(256))

SET @SQL = "INSERT INTO #OBJPARAMS (PARAMNAME) SELECT NAME FROM " + @SERVERIP + "." + @DBNAME + ".SYS.COLUMNS WHERE OBJECT_ID = " + CONVERT(VARCHAR, @OBJID) + " ORDER BY COLUMN_ID"

EXEC (@SQL)

SELECT PARAMNAME = 'PARAM_' + UPPER(REPLACE(PARAMNAME, '@', '')) FROM #OBJPARAMS

DROP TABLE #OBJPARAMS

SELECT
	PDFCODE,
	REPORTSECTION,
	OBJECTNAME,
	FONT_NAME,
	FONT_SIZE,
	BOLD,
	UNDERLINE,
	STRIKEOUT,
	ITALIC,
	MULTISECTIONNAME = ISNULL(UPPER(MULTISECTIONNAME), '')
FROM
	PDFFORMAT
WHERE
	PDFCODE = @PDFCODE
ORDER BY
	SRNO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PDFCOMPANYINFO
-- --------------------------------------------------


CREATE PROC [dbo].[PDFCOMPANYINFO]
(
	@EXCHANGE VARCHAR(10),
	@SEGMENT VARCHAR(10)
)
AS
/*
	EXEC PDFCOMPANYINFO 'bSE', 'mfss'
*/
SET NOCOUNT ON
CREATE TABLE #OWNERINFORMATION
(
	COMPANY VARCHAR(100),
	ADDR1 VARCHAR(70),
	ADDR2 VARCHAR(70),
	PHONE VARCHAR(25),
	FAX VARCHAR(25),
	ZIP VARCHAR(6),
	CITY VARCHAR(20),
	MEMBERCODE VARCHAR(15),
	BROKERSEBIREGNO VARCHAR(15),
	DPID VARCHAR(16),
	DPCLTID VARCHAR(16),
	CMBPID VARCHAR(8),
	COMPPAN VARCHAR(50),
	COMPMAIL VARCHAR(100)
)
IF @EXCHANGE = '' OR @EXCHANGE = 'ALL'
	BEGIN
		SET @EXCHANGE = 'NSE'
	END

IF @SEGMENT = '' OR @SEGMENT = 'ALL'
	BEGIN
		SET @SEGMENT = 'CAPITAL'
	END

DECLARE
	@SHAREDB VARCHAR(255),
	@OWNERTBL VARCHAR(255),
	@SQL VARCHAR(8000)
SELECT @SHAREDB = SHAREDB FROM MULTICOMPANY WHERE EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT
IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO #OWNERINFORMATION (COMPANY, ADDR1, ADDR2, PHONE, FAX, ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID, DPCLTID, CMBPID, COMPPAN, COMPMAIL)
		SELECT COMPANY, ADDR1, ADDR2, PHONE, FAX, ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID = '', DPCLTID = '', CMBPID = '', PANNO, EMAIL FROM MSAJAG.dbo.OWNER
		UPDATE #OWNERINFORMATION SET DPID = D.DPID, DPCLTID = D.DPCLTNO
		FROM MSAJAG.dbo.DELIVERYDP D WHERE D.DPTYPE = 'NSDL' AND D.DESCRIPTION LIKE '%POOL%'
		UPDATE #OWNERINFORMATION SET CMBPID = D1.NSECMBPID
		FROM MSAJAG.dbo.DELSEGMENT D1
		SELECT COMPANY, ADDR1, ADDR2, PHONE, FAX, ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID, DPCLTID, CMBPID, COMPPAN, COMPMAIL FROM #OWNERINFORMATION
		RETURN
	END
IF (@EXCHANGE = 'NSE' OR @EXCHANGE = 'BSE') AND @SEGMENT = 'CAPITAL'
	BEGIN
		SET @OWNERTBL = 'OWNER'
	END
ELSE
	BEGIN
		SET @OWNERTBL = 'FOOWNER'
	END
SET @SQL = "INSERT INTO #OWNERINFORMATION (COMPANY, ADDR1, ADDR2, PHONE, FAX, ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID, DPCLTID, CMBPID, COMPPAN, COMPMAIL) "
SET @SQL = @SQL + "SELECT COMPANY, ADDR1, ADDR2, PHONE, " + CASE WHEN @OWNERTBL = 'FOOWNER' THEN 'FAX='''', ' ELSE 'FAX, ' END + "ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID = '', DPCLTID = '', CMBPID = '', PANNO, EMAIL FROM " + @SHAREDB + ".dbo." + @OWNERTBL
PRINT @SQL
EXEC(@SQL)

SET @SQL = "UPDATE #OWNERINFORMATION SET DPID = D.DPID, DPCLTID = D.DPCLTNO "
SET @SQL = @SQL + "FROM " + @SHAREDB + ".dbo.DELIVERYDP D WHERE D.DPTYPE = 'NSDL' AND D.DESCRIPTION LIKE '%POOL%'"

EXEC(@SQL)

IF (@EXCHANGE = 'NSE' OR @EXCHANGE = 'BSE') AND @SEGMENT = 'CAPITAL'
	BEGIN
		SET @SQL = "UPDATE #OWNERINFORMATION SET CMBPID = D." + @EXCHANGE + "CMBPID "
		SET @SQL = @SQL + "FROM " + @SHAREDB + ".dbo.DELSEGMENT D"
		EXEC(@SQL)
	END
SELECT COMPANY, ADDR1, ADDR2, PHONE, FAX, ZIP, CITY, MEMBERCODE, BROKERSEBIREGNO, DPID, DPCLTID, CMBPID, COMPPAN, COMPMAIL FROM #OWNERINFORMATION
DROP TABLE #OWNERINFORMATION

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
-- PROCEDURE dbo.Rpt_StampDuty_New_Report_PRATHAM
-- --------------------------------------------------
--EXEC Rpt_StampDuty_New_Report_PRATHAM 'SEP 30 2015','SEP 30 2015','%'
     
CREATE Proc [dbo].[Rpt_StampDuty_New_Report_PRATHAM]         
  
 (        
  
 @Start_Date Varchar(11),         
 @End_Date Varchar(11),         
  @State Varchar(50),        
  @RPT_TYPE INT = 0        
  )              
 As  
 Select  fosettlement.Party_Code,              
   SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),        
   Totamt = sum(case          
  
  when AuctionPart = 'EA'    
  
  then          
  
  (Case          
  
  When fosettlement.Inst_Type Like 'OPT%' And AuctionPart = 'EA'             
  
     Then          
  
  TradeQty * Strike_Price        
  
    Else          
  
  TradeQty * (        
  
           CASE                   
  
           WHEN Broker_Note_On = 'PRICE'                   
  
           THEN PRICE                   
  
           ELSE                   
  
           CASE                   
  
               WHEN Broker_Note_On = 'SPRICE'                   
  
               THEN                   
  
               CASE                   
  
                   WHEN Strike_Price = 0                   
  
                   THEN Price                   
  
                   ELSE Strike_Price                   
  
               END                   
  
               ELSE Strike_price + PRICE                   
  
           END                   
  
           END )          
  
    End)           
  
   else 0          
  
   end),           
  
  Totalamt = sum(case          
  
    when AuctionPart = ''           
  
    then          
  
    (Case          
  
    When fosettlement.Inst_Type Like 'OPT%' And AuctionPart = 'EA'             
  
     Then          
  
  TradeQty * Strike_Price            
  
    Else          
  
  TradeQty *  (        
  
           CASE                   
  
           WHEN Broker_Note_On = 'PRICE'                   
  
           THEN PRICE                   
  
           ELSE                   
  
           CASE                   
  
               WHEN Broker_Note_On = 'SPRICE'                   
  
               THEN                   
  
               CASE                   
  
                   WHEN Strike_Price = 0                   
  
                   THEN Price                   
  
                   ELSE Strike_Price                   
  
               END                   
  
               ELSE Strike_price + PRICE                   
  
           END                   
  
           END )           
  
    End)           
  
   else 0          
  
   end),          
  
  BrokChrg = sum(case          
  
   when           
  
  AuctionPart = 'EA'           
  
  then          
  
   (CASE WHEN BrokerNote = 1 THEN Broker_Chrg ELSE 0 END)        
  
  Else          
  
  0          
  
  End),           
  
  BrokerChrg = sum(case          
  
   when           
  
  AuctionPart = ''           
  
  then          
  
   (CASE WHEN BrokerNote = 1 THEN Broker_Chrg ELSE 0 END)             
  
  Else          
  
  0          
  
  End),          
  
  ATSTAMP = Convert(Numeric(18,4),0),                        
  
  ADSTAMP = Convert(Numeric(18,4),0),          
  
  Cl_Type,                 
  
  L_State                   
  
 Into              
  
  #StampDuty                
  
 From                
  
  fosettlement  (NOLOCK), Client2 (NOLOCK), V_STATE_STAMP  (NOLOCK)  ,fotaxes (nolock)                    
  
 where                
  
  Sauda_date >= @Start_Date and Sauda_date <= @End_Date + ' 23:59'                  
  
  and fosettlement.party_code = Client2.party_code               
  
  and Sauda_date between from_date and to_date         
  
  and fotaxes.inst_type = left(fosettlement.inst_type,3) and trans_cat='trd'                                 
  
  and V_STATE_STAMP.Cl_code = Client2.Cl_code                       
  
  And TradeQty > 0 And Price > 0                 
  
  And L_State Like @State         
  
 group by                
  
  fosettlement.Party_Code,Cl_Type, L_State,        
  
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)        
  
                    
  
        
  
        
  
   
  
        
  
              
  
 Insert Into #StampDuty                  
  
 Select  fosettlement.party_code,     
  
 SAUDA_DATE = (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END),        
  
 Totamt = sum(case          
  
    when AuctionPart = 'EA'           
  
    then          
  
    (Case          
  
    When fosettlement.Inst_Type Like 'OPT%' And AuctionPart = 'EA'             
  
     Then          
  
  TradeQty * Strike_Price        
  
    Else          
  
  TradeQty * (        
  
           CASE                   
  
         WHEN Broker_Note_On = 'PRICE'                   
  
           THEN PRICE                   
  
           ELSE                   
  
           CASE                   
  
               WHEN Broker_Note_On = 'SPRICE'                   
  
               THEN                   
  
              CASE                   
  
                   WHEN Strike_Price = 0                   
  
                   THEN Price                   
  
                   ELSE Strike_Price                   
  
               END                   
  
               ELSE Strike_price + PRICE          
  
           END                   
  
           END )          
  
    End)           
  
   else 0          
  
   end),           
  
  Totalamt = sum(case          
  
    when AuctionPart = ''           
  
    then          
  
    (Case          
  
    When fosettlement.Inst_Type Like 'OPT%' And AuctionPart = 'EA'             
  
     Then          
  
  TradeQty * Strike_Price            
  
    Else          
  
  TradeQty *  (        
  
           CASE                   
  
           WHEN Broker_Note_On = 'PRICE'                   
  
           THEN PRICE                   
  
           ELSE                   
  
           CASE                   
  
               WHEN Broker_Note_On = 'SPRICE'                   
  
               THEN                   
  
               CASE                   
  
                   WHEN Strike_Price = 0                   
  
                   THEN Price                   
  
                   ELSE Strike_Price                   
  
               END                   
  
               ELSE Strike_price + PRICE                   
  
           END                   
  
           END )           
  
    End)           
  
   else 0          
  
   end),          
  
  BrokChrg = sum(case          
  
   when           
  
  AuctionPart = 'EA'           
  
  then          
  
   (CASE WHEN BrokerNote = 1 THEN Broker_Chrg ELSE 0 END)        
  
  Else          
  
  0          
  
  End),           
  
  BrokerChrg = sum(case          
  
   when           
  
  AuctionPart = ''           
  
  then          
  
   (CASE WHEN BrokerNote = 1 THEN Broker_Chrg ELSE 0 END)             
  
  Else          
  
  0          
  
  End),          
  
  ATSTAMP = Convert(Numeric(18,4),0),                        
  
  ADSTAMP = Convert(Numeric(18,4),0),          
  
  Cl_Type,                 
  
  L_State                   
  
          
  
 From                
  
  Pradnya.dbo.History_Fosettlement_NseCurFo fosettlement, Client2, V_STATE_STAMP  ,fotaxes (nolock)                    
  
 where                
  
  Sauda_date >= @Start_Date and Sauda_date <= @End_Date + ' 23:59'                  
  
  and fosettlement.party_code = Client2.party_code               
  
  and Sauda_date between from_date and to_date         
  
  and fotaxes.inst_type = left(fosettlement.inst_type,3) and trans_cat='trd'                                 
  
  and V_STATE_STAMP.Cl_code = Client2.Cl_code                       
  
  And TradeQty > 0 And Price > 0                 
  
  And L_State Like @State         
  
 group by                
  
   fosettlement.party_code  ,Cl_Type, L_State,     
  
  (CASE WHEN @RPT_TYPE = 0 THEN '' ELSE LEFT(CONVERT(VARCHAR,SAUDA_DATE,103),11) END)        
  
        
  
        
  
 UPDATE #StampDuty SET           
  
 ATSTAMP = (Totalamt * TRDSTAMPDUTY / 100),          
  
 ADSTAMP = (Totamt * DELSTAMPDUTY / 100)          
  
 FROM STATE_MASTER          
  
 WHERE L_STATE = STATE          
  
           
  
 UPDATE #StampDuty SET           
  
 ATSTAMP = (Totalamt * TRDSTAMPDUTY / 100),          
  
 ADSTAMP = (Totamt * DELSTAMPDUTY / 100)          
  
 FROM STATE_MASTER          
  
 WHERE STATE = 'MAHARASHTRA'          
  
 AND L_STATE NOT IN (SELECT STATE FROM STATE_MASTER)          
  
        
  
        
  
 Select        
 party_code, 
 L_State,            
  
 SAUDA_DATE,        
  
 ProDelAmt = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type = 'PRO'           
  
   Then TotAmt          
  
   Else 0          
  
     End)),          
  
 ProTrdAmt = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type = 'PRO'           
  
   Then TotalAmt          
  
   Else 0          
  
     End)),          
  
 NrmTrdAmt = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type <> 'PRO'           
  
   Then TotalAmt          
  
   Else 0          
  
     End)),          
  
 NrmDelAmt = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type <> 'PRO'           
  
   Then TotAmt          
  
   Else 0          
  
     End)),          
  
 ProTrd = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type = 'PRO'          
  
   Then BrokerChrg          
  
   Else 0          
  
     End)),          
  
 ProDel = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type = 'PRO'           
  
   Then BrokChrg          
  
   Else 0          
  
     End)),          
  
 NrmTrd = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type <> 'PRO'           
  
   Then BrokerChrg          
  
   Else 0          
  
     End)),          
  
 NrmDel = Convert(Numeric(18,4),           
  
     Sum(Case When Cl_Type <> 'PRO'           
  
   Then BrokChrg          
  
  Else 0          
  
     End)),          
  
 ProTrd1 = convert(numeric(18,4),             
  
  Sum(Case When Cl_Type = 'PRO'            
  
     Then ATSTAMP            
  
     Else 0          
  
    End)),          
  
 ProDel1 = convert(numeric(18,4),             
  
  Sum(Case When Cl_Type = 'PRO'             
  
        Then ADSTAMP          
  
       Else 0          
  
     End)),              
  
           
  
 NrmTrd1 = convert(numeric(18,4),             
  
  Sum(Case When Cl_Type = 'PRO'             
  
       Then 0            
  
       Else ATSTAMP          
  
    End)),          
  
           
  
 NrmDel1 = convert(numeric(18,4),             
  
  Sum(Case When Cl_Type = 'PRO'             
  
       Then 0                   
  
       Else ADSTAMP               
  
     End)),           
  
 TotalAmt = convert(numeric(18,4), sum(totamt + TotalAmt))            
  
           
  
 Into #StampDuty_Report                    
  
 From #StampDuty              
  
 Group by L_State, SAUDA_DATE ,party_code          
  
           
  
 Select           
  
  EXCHANGE = 'NSE',         
  
  SEGMENT = 'FUTURES',        
  
  *,TotalStampDuty = (ProTrd1+ProDel1+NrmTrd1+NrmDel1),party_code From #StampDuty_Report                    
  
 Order by L_State          
  
           
  
 Drop Table #StampDuty_Report                
  
 Drop Table #StampDuty

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
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------


CREATE PROC Tbl @TblName VARCHAR(25)AS           

Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UKUPDATE
-- --------------------------------------------------
Create Proc UKUPDATE
as

Update Client1 Set branch_cd = 'BVI', sub_broker='MHB' where cl_code = 'Q111'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R002'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R014'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R019'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R029'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R033'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R037'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R044'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R046'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R087'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R092'
Update Client1 Set branch_cd = 'ACM', sub_broker='HEM' where cl_code = 'R10002'
Update Client1 Set branch_cd = 'HYD', sub_broker='HST' where cl_code = 'R10040'
Update Client1 Set branch_cd = 'JAM1', sub_broker='HEMA1' where cl_code = 'R10077'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'R1011'
Update Client1 Set branch_cd = 'XF', sub_broker='MBR' where cl_code = 'R10233'
Update Client1 Set branch_cd = 'XG', sub_broker='ARI' where cl_code = 'R1026'
Update Client1 Set branch_cd = 'XD', sub_broker='DMN' where cl_code = 'R10283'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R10287'
Update Client1 Set branch_cd = 'XF', sub_broker='MR' where cl_code = 'R103'
Update Client1 Set branch_cd = 'DELHI', sub_broker='ARBR' where cl_code = 'R10405'
Update Client1 Set branch_cd = 'DELHI', sub_broker='ARBR' where cl_code = 'R10406'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'R10500'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDHD' where cl_code = 'R1057'
Update Client1 Set branch_cd = 'BNG', sub_broker='BNG' where cl_code = 'R10604'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R10629'
Update Client1 Set branch_cd = 'XN', sub_broker='PAS' where cl_code = 'R1063'
Update Client1 Set branch_cd = 'BVI', sub_broker='PROY' where cl_code = 'R1081'
Update Client1 Set branch_cd = 'XPU', sub_broker='BBV' where cl_code = 'R1086'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'R1135'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R114'
Update Client1 Set branch_cd = 'XS', sub_broker='FI' where cl_code = 'R1175'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R118'
Update Client1 Set branch_cd = 'XN', sub_broker='RALY' where cl_code = 'R1184'
Update Client1 Set branch_cd = 'HYD', sub_broker='PVV' where cl_code = 'R1246'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'R1309'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R131'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R132'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R135'
Update Client1 Set branch_cd = 'XN', sub_broker='STL' where cl_code = 'R1388'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R140'
Update Client1 Set branch_cd = 'HYD', sub_broker='KIT' where cl_code = 'R1444'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R148'
Update Client1 Set branch_cd = 'XS', sub_broker='RDI' where cl_code = 'R1516'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R1549'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'R1675'
Update Client1 Set branch_cd = 'YA', sub_broker='RPD' where cl_code = 'R1678'
Update Client1 Set branch_cd = 'HO', sub_broker='MUK' where cl_code = 'R1721'
Update Client1 Set branch_cd = 'XPU', sub_broker='SIS' where cl_code = 'R1726'
Update Client1 Set branch_cd = 'XPU', sub_broker='VJP' where cl_code = 'R1749'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R176'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R177'
Update Client1 Set branch_cd = 'YA', sub_broker='MPS' where cl_code = 'R1784'
Update Client1 Set branch_cd = 'RAJ', sub_broker='SMO' where cl_code = 'R1795'
Update Client1 Set branch_cd = 'RAJ', sub_broker='MDR' where cl_code = 'R1802'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R182'
Update Client1 Set branch_cd = 'XF', sub_broker='MBR' where cl_code = 'R1833'
Update Client1 Set branch_cd = 'TB', sub_broker='TB' where cl_code = 'R1834'
Update Client1 Set branch_cd = 'YA', sub_broker='BCM' where cl_code = 'R1849'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R187'
Update Client1 Set branch_cd = 'YA', sub_broker='EBG' where cl_code = 'R1870'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R1887'
Update Client1 Set branch_cd = 'HYD', sub_broker='KIT' where cl_code = 'R1889'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R190'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R191'
Update Client1 Set branch_cd = 'XG', sub_broker='RU' where cl_code = 'R1911'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJS' where cl_code = 'R1950'
Update Client1 Set branch_cd = 'BVI', sub_broker='SRSR' where cl_code = 'R1954'
Update Client1 Set branch_cd = 'XD', sub_broker='PP' where cl_code = 'R1955'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R197'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R198'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R200'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R201'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R202'
Update Client1 Set branch_cd = 'DELHI', sub_broker='VKP' where cl_code = 'R2043'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R206'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R211'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R2113'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R212'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R214'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R216'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'R2161'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R217'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RRD' where cl_code = 'R2182'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R219'
Update Client1 Set branch_cd = 'BVI', sub_broker='MKS' where cl_code = 'R2192'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R220'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RAR' where cl_code = 'R2207'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R221'
Update Client1 Set branch_cd = 'YA', sub_broker='BSB' where cl_code = 'R2244'
Update Client1 Set branch_cd = 'YA', sub_broker='AKSH' where cl_code = 'R2268'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R2276'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RAR' where cl_code = 'R2279'
Update Client1 Set branch_cd = 'HYD', sub_broker='NND' where cl_code = 'R2309'
Update Client1 Set branch_cd = 'HO', sub_broker='MUK' where cl_code = 'R2314'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R2318'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R2319'
Update Client1 Set branch_cd = 'ACM', sub_broker='AKA' where cl_code = 'R2444'
Update Client1 Set branch_cd = 'HYD', sub_broker='KIT' where cl_code = 'R2467'
Update Client1 Set branch_cd = 'HYD', sub_broker='SSRS' where cl_code = 'R2472'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJS' where cl_code = 'R2749'
Update Client1 Set branch_cd = 'ACM', sub_broker='AKA' where cl_code = 'R2771'
Update Client1 Set branch_cd = 'YA', sub_broker='PPO' where cl_code = 'R2801'
Update Client1 Set branch_cd = 'YA', sub_broker='AMIR' where cl_code = 'R2865'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RELI' where cl_code = 'R2871'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDHD' where cl_code = 'R2895'
Update Client1 Set branch_cd = 'RAJ', sub_broker='HIRE' where cl_code = 'R2910'
Update Client1 Set branch_cd = 'AHD', sub_broker='RASH' where cl_code = 'R2963'
Update Client1 Set branch_cd = 'XPU', sub_broker='VKS' where cl_code = 'R2974'
Update Client1 Set branch_cd = 'RAJ', sub_broker='OMST' where cl_code = 'R2985'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'R3002'
Update Client1 Set branch_cd = 'DELHI', sub_broker='VKP' where cl_code = 'R3040'
Update Client1 Set branch_cd = 'BVI', sub_broker='ASHI' where cl_code = 'R3076'
Update Client1 Set branch_cd = 'RAJ', sub_broker='OMST' where cl_code = 'R3083'
Update Client1 Set branch_cd = 'YA', sub_broker='BMM' where cl_code = 'R3115'
Update Client1 Set branch_cd = 'HYD', sub_broker='SKH' where cl_code = 'R3170'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R330'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R334'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R335'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R337'
Update Client1 Set branch_cd = 'BNG', sub_broker='HRB' where cl_code = 'R3412'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'R3417'
Update Client1 Set branch_cd = 'BNG', sub_broker='RRG' where cl_code = 'R3422'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R348'
Update Client1 Set branch_cd = 'XN', sub_broker='APJ' where cl_code = 'R3491'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R352'
Update Client1 Set branch_cd = 'XPU', sub_broker='VKS' where cl_code = 'R3555'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R356'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RELI' where cl_code = 'R3560'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R3577'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R361'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RELI' where cl_code = 'R3618'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R362'
Update Client1 Set branch_cd = 'XPU', sub_broker='ING' where cl_code = 'R3652'
Update Client1 Set branch_cd = 'HYD', sub_broker='NES' where cl_code = 'R3659'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R366'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'R368'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R369'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R370'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R371'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R374'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R375'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R376'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R378'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R380'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R381'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R382'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R383'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R387'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R394'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R395'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'R3959'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R3964'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJS' where cl_code = 'R3973'
Update Client1 Set branch_cd = 'HO', sub_broker='MUK' where cl_code = 'R3981'
Update Client1 Set branch_cd = 'YA', sub_broker='KGD' where cl_code = 'R4044'
Update Client1 Set branch_cd = 'XF', sub_broker='RS' where cl_code = 'R407'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R410'
Update Client1 Set branch_cd = 'INDO', sub_broker='INDO' where cl_code = 'R4110'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R414'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R415'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R418'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R4180'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R422'
Update Client1 Set branch_cd = 'RAJ', sub_broker='PHJ' where cl_code = 'R4227'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R437'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R441'
Update Client1 Set branch_cd = 'HYD', sub_broker='SSRS' where cl_code = 'R4422'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R443'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R444'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R445'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R448'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R455'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R459'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R467'
Update Client1 Set branch_cd = 'HO', sub_broker='CLOSED' where cl_code = 'R4680'
Update Client1 Set branch_cd = 'VD', sub_broker='RISHI' where cl_code = 'R4739'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R474'
Update Client1 Set branch_cd = 'HO', sub_broker='PL' where cl_code = 'R4747'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RRS' where cl_code = 'R4764'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R481'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R482'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R483'
Update Client1 Set branch_cd = 'YA', sub_broker='EBG' where cl_code = 'R4845'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R491'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'R4935ZZ'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R4949'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R495'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'R496'
Update Client1 Set branch_cd = 'XN', sub_broker='DK' where cl_code = 'R498'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R4989'
Update Client1 Set branch_cd = 'XG', sub_broker='XY' where cl_code = 'R501'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'R5010'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R503'
Update Client1 Set branch_cd = 'XPU', sub_broker='RTT' where cl_code = 'R5040'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R506'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R507'
Update Client1 Set branch_cd = 'XS', sub_broker='RAG' where cl_code = 'R5074'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R508'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R5098'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R510'
Update Client1 Set branch_cd = 'NASIK', sub_broker='DSI' where cl_code = 'R5111'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'R5160'
Update Client1 Set branch_cd = 'XPU', sub_broker='ARDH' where cl_code = 'R5185'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R519'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R520'
Update Client1 Set branch_cd = 'YA', sub_broker='BKG' where cl_code = 'R5240'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R525'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R5258'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'R528'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'R5287'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R530'
Update Client1 Set branch_cd = 'AHD', sub_broker='HNC' where cl_code = 'R5305'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R533'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'R5367'
Update Client1 Set branch_cd = 'THN', sub_broker='MAG' where cl_code = 'R5380'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'R539'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R540'
Update Client1 Set branch_cd = 'RAJ', sub_broker='PNRA' where cl_code = 'R5408'
Update Client1 Set branch_cd = 'SG', sub_broker='SG' where cl_code = 'R545'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R550'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R552'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R5531'
Update Client1 Set branch_cd = 'RAJ', sub_broker='PNRA' where cl_code = 'R5548'
Update Client1 Set branch_cd = 'INDO', sub_broker='ASDA' where cl_code = 'R5550'
Update Client1 Set branch_cd = 'YA', sub_broker='EBG' where cl_code = 'R5557'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R557'
Update Client1 Set branch_cd = 'INDO', sub_broker='POS' where cl_code = 'R5575'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R560'
Update Client1 Set branch_cd = 'BNG', sub_broker='BNG' where cl_code = 'R5600'
Update Client1 Set branch_cd = 'YA', sub_broker='BCM' where cl_code = 'R5619'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R563'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'R5642'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R565'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R567'
Update Client1 Set branch_cd = 'HO', sub_broker='NW' where cl_code = 'R5727'
Update Client1 Set branch_cd = 'BNG', sub_broker='RRG' where cl_code = 'R5736'
Update Client1 Set branch_cd = 'YA', sub_broker='DEL' where cl_code = 'R5747'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R5782'
Update Client1 Set branch_cd = 'HO', sub_broker='VSEC' where cl_code = 'R5903'
Update Client1 Set branch_cd = 'XS', sub_broker='UD' where cl_code = 'R593'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R5969'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RSO' where cl_code = 'R5988'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R6020'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'R6032'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'R6071'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R6074'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'R6135'
Update Client1 Set branch_cd = 'HYD', sub_broker='BRK' where cl_code = 'R6148'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'R6151'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R628'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R6284'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'R6356'
Update Client1 Set branch_cd = 'HYD', sub_broker='MVR' where cl_code = 'R6498'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R655'
Update Client1 Set branch_cd = 'RAJ', sub_broker='SMO' where cl_code = 'R6559'
Update Client1 Set branch_cd = 'XV', sub_broker='SFF' where cl_code = 'R6561'
Update Client1 Set branch_cd = 'XI', sub_broker='RHM' where cl_code = 'R6607'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R6665'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MAI' where cl_code = 'R6672'
Update Client1 Set branch_cd = 'HO', sub_broker='PD' where cl_code = 'R677'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'R6779'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R683'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R6880'
Update Client1 Set branch_cd = 'XV', sub_broker='JN' where cl_code = 'R692'
Update Client1 Set branch_cd = 'XV', sub_broker='JN' where cl_code = 'R693'
Update Client1 Set branch_cd = 'BNG', sub_broker='ASL' where cl_code = 'R6937'
Update Client1 Set branch_cd = 'RAJ', sub_broker='TULSI' where cl_code = 'R7014'
Update Client1 Set branch_cd = 'YA', sub_broker='JTD' where cl_code = 'R7048'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R7074'
Update Client1 Set branch_cd = 'DELHI', sub_broker='SCI' where cl_code = 'R7119'
Update Client1 Set branch_cd = 'RAJ', sub_broker='NBS' where cl_code = 'R7123'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R7148'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RDN' where cl_code = 'R7177'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R718'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'R727'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MAI' where cl_code = 'R7277'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'R7310'
Update Client1 Set branch_cd = 'XF', sub_broker='GYTR' where cl_code = 'R7365'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R740'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R741'
Update Client1 Set branch_cd = 'XV', sub_broker='JN' where cl_code = 'R742'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RJM' where cl_code = 'R7425'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R744'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R753'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R757'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R767'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'R769'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R771'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R772'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'R7781'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R779'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'R78'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R780'
Update Client1 Set branch_cd = 'ACM', sub_broker='RJA' where cl_code = 'R7833'
Update Client1 Set branch_cd = 'NASIK', sub_broker='TSS' where cl_code = 'R7926'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'R794'
Update Client1 Set branch_cd = 'VD', sub_broker='VD' where cl_code = 'R7952'
Update Client1 Set branch_cd = 'YB', sub_broker='KS' where cl_code = 'R7978'
Update Client1 Set branch_cd = 'XC', sub_broker='DCZ' where cl_code = 'R802'
Update Client1 Set branch_cd = 'HYD', sub_broker='DIJ' where cl_code = 'R8023'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RVB' where cl_code = 'R8046'
Update Client1 Set branch_cd = 'INDO', sub_broker='SPT' where cl_code = 'R8049'
Update Client1 Set branch_cd = 'YS', sub_broker='YS' where cl_code = 'R805'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'R806'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'R810'
Update Client1 Set branch_cd = 'HO', sub_broker='WS' where cl_code = 'R812'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MAI' where cl_code = 'R8217'
Update Client1 Set branch_cd = 'XS1', sub_broker='HAG' where cl_code = 'R8310'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'R838'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'R8387'
Update Client1 Set branch_cd = 'INDO', sub_broker='FOR' where cl_code = 'R8451'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'R8457'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'R848'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'R853'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R8620'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'R8657'
Update Client1 Set branch_cd = 'YA', sub_broker='PPS' where cl_code = 'R866'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R8738'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'R8899'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'R8940'
Update Client1 Set branch_cd = 'ACM', sub_broker='AKA' where cl_code = 'R8941'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'R896'
Update Client1 Set branch_cd = 'VP', sub_broker='PLG' where cl_code = 'R8971'
Update Client1 Set branch_cd = 'XS', sub_broker='RBI' where cl_code = 'R910'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R917'
Update Client1 Set branch_cd = 'INDO', sub_broker='LUC' where cl_code = 'R9180'
Update Client1 Set branch_cd = 'YB', sub_broker='HY' where cl_code = 'R933'
Update Client1 Set branch_cd = 'INDO', sub_broker='GOLD' where cl_code = 'R9338'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'R9382'
Update Client1 Set branch_cd = 'XC', sub_broker='DCZ' where cl_code = 'R943'
Update Client1 Set branch_cd = 'XV', sub_broker='ROK' where cl_code = 'R9489'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R949'
Update Client1 Set branch_cd = 'XI', sub_broker='RHM' where cl_code = 'R9542'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'R955'
Update Client1 Set branch_cd = 'YB', sub_broker='SMPL' where cl_code = 'R9561'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'R959'
Update Client1 Set branch_cd = 'HYD', sub_broker='DIJ' where cl_code = 'R9669'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'R9740'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'R9759'
Update Client1 Set branch_cd = 'YB', sub_broker='UD' where cl_code = 'R977'
Update Client1 Set branch_cd = 'HYD', sub_broker='DIJ' where cl_code = 'R9787'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'R999'
Update Client1 Set branch_cd = 'YB', sub_broker='HY' where cl_code = 'RA18'
Update Client1 Set branch_cd = 'XI', sub_broker='HN' where cl_code = 'RA33'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'RA62'
Update Client1 Set branch_cd = 'XV', sub_broker='RMK' where cl_code = 'RA72'
Update Client1 Set branch_cd = 'YB', sub_broker='DO' where cl_code = 'RA93'
Update Client1 Set branch_cd = 'YA', sub_broker='NVP' where cl_code = 'RB10'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'RB16'
Update Client1 Set branch_cd = 'YB', sub_broker='NU' where cl_code = 'RB85'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'RB99'
Update Client1 Set branch_cd = 'XH', sub_broker='DR' where cl_code = 'RC16'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'RCA001'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'RCK31'
Update Client1 Set branch_cd = 'HO', sub_broker='RC' where cl_code = 'RCMO13'
Update Client1 Set branch_cd = 'HO', sub_broker='ZH' where cl_code = 'RD05'
Update Client1 Set branch_cd = 'XI', sub_broker='DKI' where cl_code = 'RD19'
Update Client1 Set branch_cd = 'HO', sub_broker='NVK' where cl_code = 'RD27'
Update Client1 Set branch_cd = 'YA', sub_broker='DARS' where cl_code = 'RD38'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'RD41'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RD42'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RD44'
Update Client1 Set branch_cd = 'XD', sub_broker='MMI' where cl_code = 'RD51'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'RE03'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'RE21'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'RE22'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'RE25'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'RE44'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RE47'
Update Client1 Set branch_cd = 'XD', sub_broker='MI' where cl_code = 'RE56'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'RE59'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RE64'
Update Client1 Set branch_cd = 'XF', sub_broker='MI' where cl_code = 'RE72'
Update Client1 Set branch_cd = 'XD', sub_broker='MI' where cl_code = 'RE76'
Update Client1 Set branch_cd = 'XD', sub_broker='MI' where cl_code = 'RE77'
Update Client1 Set branch_cd = 'YA', sub_broker='DSB' where cl_code = 'RE85'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'RE90'
Update Client1 Set branch_cd = 'XD', sub_broker='PP' where cl_code = 'RF05'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'RF33'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RF94'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'RG07'
Update Client1 Set branch_cd = 'YA', sub_broker='ENSU' where cl_code = 'RG11'
Update Client1 Set branch_cd = 'YA', sub_broker='VIRA' where cl_code = 'RH39'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RH65'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'RJ79'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'RK12'
Update Client1 Set branch_cd = 'XD', sub_broker='PP' where cl_code = 'RK98'
Update Client1 Set branch_cd = 'YB', sub_broker='KMSH' where cl_code = 'RL15'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RM31'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'RN10'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'RN18'
Update Client1 Set branch_cd = 'XS', sub_broker='ABS' where cl_code = 'RN25'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'RN35'
Update Client1 Set branch_cd = 'TB', sub_broker='SHRE' where cl_code = 'RN38'
Update Client1 Set branch_cd = 'XG', sub_broker='DJ' where cl_code = 'RN44'
Update Client1 Set branch_cd = 'XF', sub_broker='SSN' where cl_code = 'RN97'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'RP12'
Update Client1 Set branch_cd = 'XD', sub_broker='SIT' where cl_code = 'RP42'
Update Client1 Set branch_cd = 'ACM', sub_broker='JAIN' where cl_code = 'RP85'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'RR65'
Update Client1 Set branch_cd = 'TB', sub_broker='CMP' where cl_code = 'RT47'
Update Client1 Set branch_cd = 'XG', sub_broker='KF' where cl_code = 'RT54'
Update Client1 Set branch_cd = 'XN', sub_broker='RALY' where cl_code = 'RU56'
Update Client1 Set branch_cd = 'TB', sub_broker='CS' where cl_code = 'RU89'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHA' where cl_code = 'RV10'
Update Client1 Set branch_cd = 'TB', sub_broker='DAN' where cl_code = 'RV88'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'RV99'
Update Client1 Set branch_cd = 'XG', sub_broker='BO' where cl_code = 'RW55'
Update Client1 Set branch_cd = 'XS', sub_broker='RJZ' where cl_code = 'RW93'
Update Client1 Set branch_cd = 'XN', sub_broker='SPR' where cl_code = 'RX07'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHH' where cl_code = 'RY04'
Update Client1 Set branch_cd = 'BVI', sub_broker='PROY' where cl_code = 'RZ27'
Update Client1 Set branch_cd = 'XI', sub_broker='STS' where cl_code = 'RZ74'
Update Client1 Set branch_cd = 'TB', sub_broker='JNK' where cl_code = 'RZ97'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S033'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S043'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S051'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S053'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S063'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S074'
Update Client1 Set branch_cd = 'XF', sub_broker='JN' where cl_code = 'S078'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S081'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S096'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S098'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'S100'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S10039'
Update Client1 Set branch_cd = 'XS', sub_broker='SML' where cl_code = 'S10116'
Update Client1 Set branch_cd = 'YB', sub_broker='NU' where cl_code = 'S1016'
Update Client1 Set branch_cd = 'DELHI', sub_broker='UTM' where cl_code = 'S10239'
Update Client1 Set branch_cd = 'XF', sub_broker='SAR' where cl_code = 'S10244'
Update Client1 Set branch_cd = 'XF', sub_broker='ZD' where cl_code = 'S10245'
Update Client1 Set branch_cd = 'XR', sub_broker='XR' where cl_code = 'S10263'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'S10286'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'S10324ZZ'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S10348'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S10440'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S10502'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'S10537'
Update Client1 Set branch_cd = 'RAJ', sub_broker='NBS' where cl_code = 'S10570'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S10595'
Update Client1 Set branch_cd = 'XN', sub_broker='RRR' where cl_code = 'S1062'
Update Client1 Set branch_cd = 'DELHI', sub_broker='VKP' where cl_code = 'S10629'
Update Client1 Set branch_cd = 'TB', sub_broker='SHRE' where cl_code = 'S1066'
Update Client1 Set branch_cd = 'XPU', sub_broker='NBJ' where cl_code = 'S10671'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'S10826'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S10859'
Update Client1 Set branch_cd = 'BVI', sub_broker='JNB' where cl_code = 'S10887'
Update Client1 Set branch_cd = 'INDO', sub_broker='INDO' where cl_code = 'S10933'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SNW' where cl_code = 'S10947'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SNW' where cl_code = 'S10949'
Update Client1 Set branch_cd = 'XPU', sub_broker='ARZ' where cl_code = 'S10998'
Update Client1 Set branch_cd = 'AHD', sub_broker='TSJ' where cl_code = 'S11019'
Update Client1 Set branch_cd = 'VD', sub_broker='VD' where cl_code = 'S11029'
Update Client1 Set branch_cd = 'XPU', sub_broker='SIS' where cl_code = 'S11145'
Update Client1 Set branch_cd = 'XI', sub_broker='XJ' where cl_code = 'S11175'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'S11267'
Update Client1 Set branch_cd = 'HYD', sub_broker='PSR' where cl_code = 'S11314'
Update Client1 Set branch_cd = 'BNG', sub_broker='ASL' where cl_code = 'S11322'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S11352'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S11353'
Update Client1 Set branch_cd = 'ACM', sub_broker='KRIH' where cl_code = 'S11459'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S11465'
Update Client1 Set branch_cd = 'RAJ', sub_broker='APB' where cl_code = 'S11513ZZ'
Update Client1 Set branch_cd = 'XD', sub_broker='PP' where cl_code = 'S1154'
Update Client1 Set branch_cd = 'HYD', sub_broker='APK' where cl_code = 'S11627'
Update Client1 Set branch_cd = 'BNG', sub_broker='PASPL' where cl_code = 'S11698'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S1171'
Update Client1 Set branch_cd = 'YB', sub_broker='SHJA' where cl_code = 'S1174'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S11797'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'S11815'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MYV' where cl_code = 'S11918'
Update Client1 Set branch_cd = 'XI', sub_broker='RHM' where cl_code = 'S11986'
Update Client1 Set branch_cd = 'XD', sub_broker='SFS' where cl_code = 'S1199'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S1202'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'S12181'
Update Client1 Set branch_cd = 'XF', sub_broker='KT' where cl_code = 'S122'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MAI' where cl_code = 'S12402'
Update Client1 Set branch_cd = 'DELHI', sub_broker='SYA' where cl_code = 'S12469'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MHR' where cl_code = 'S12603'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S12784'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUDL' where cl_code = 'S12836'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S12905'
Update Client1 Set branch_cd = 'XF', sub_broker='PD' where cl_code = 'S12932'
Update Client1 Set branch_cd = 'INDO', sub_broker='INDO' where cl_code = 'S12955'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S12961'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S13027'
Update Client1 Set branch_cd = 'NASIK', sub_broker='NASIK' where cl_code = 'S13070'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S1309'
Update Client1 Set branch_cd = 'YA', sub_broker='EBG' where cl_code = 'S13118'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RVB' where cl_code = 'S13142'
Update Client1 Set branch_cd = 'XV', sub_broker='GL' where cl_code = 'S1317'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S13179'
Update Client1 Set branch_cd = 'HYD', sub_broker='HSTH' where cl_code = 'S13186'
Update Client1 Set branch_cd = 'XN', sub_broker='PAS' where cl_code = 'S13261'
Update Client1 Set branch_cd = 'INDO', sub_broker='SNR' where cl_code = 'S13312ZZ'
Update Client1 Set branch_cd = 'XD', sub_broker='SFS' where cl_code = 'S13333'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'S13389'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S13413'
Update Client1 Set branch_cd = 'ACM', sub_broker='JAIN' where cl_code = 'S1342'
Update Client1 Set branch_cd = 'HYD', sub_broker='HSTH' where cl_code = 'S13463'
Update Client1 Set branch_cd = 'XD', sub_broker='UNNA' where cl_code = 'S13476'
Update Client1 Set branch_cd = 'RAJ', sub_broker='HLK' where cl_code = 'S13490'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'S13697'
Update Client1 Set branch_cd = 'VD', sub_broker='REN' where cl_code = 'S13946'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S13949'
Update Client1 Set branch_cd = 'VD', sub_broker='REN' where cl_code = 'S13985'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'S14036'
Update Client1 Set branch_cd = 'YA', sub_broker='BMM' where cl_code = 'S1417'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S14296'
Update Client1 Set branch_cd = 'DELHI', sub_broker='SAPN' where cl_code = 'S14333'
Update Client1 Set branch_cd = 'YB', sub_broker='FOI' where cl_code = 'S14381'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'S14383'
Update Client1 Set branch_cd = 'HYD', sub_broker='HST' where cl_code = 'S14394'
Update Client1 Set branch_cd = 'NASIK', sub_broker='NASHIK' where cl_code = 'S14409'
Update Client1 Set branch_cd = 'NASIK', sub_broker='NASHIK' where cl_code = 'S14464'
Update Client1 Set branch_cd = 'XG', sub_broker='KBKY' where cl_code = 'S14546'
Update Client1 Set branch_cd = 'HYD', sub_broker='DIJ' where cl_code = 'S14620'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S14621'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S147'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'S14739'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'S14754'
Update Client1 Set branch_cd = 'XPU', sub_broker='AMIN' where cl_code = 'S14775'
Update Client1 Set branch_cd = 'XPU', sub_broker='AMIN' where cl_code = 'S14843'
Update Client1 Set branch_cd = 'INDO', sub_broker='LUC' where cl_code = 'S15014'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S15162'
Update Client1 Set branch_cd = 'DELL', sub_broker='DELL' where cl_code = 'S15176'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDHD' where cl_code = 'S1519'
Update Client1 Set branch_cd = 'VD', sub_broker='SHRP' where cl_code = 'S15411'
Update Client1 Set branch_cd = 'INDO', sub_broker='INDO' where cl_code = 'S15535'
Update Client1 Set branch_cd = 'BVI', sub_broker='LRJ' where cl_code = 'S15568'
Update Client1 Set branch_cd = 'INDO', sub_broker='LUC' where cl_code = 'S15581'
Update Client1 Set branch_cd = 'XH', sub_broker='FS' where cl_code = 'S1559'
Update Client1 Set branch_cd = 'VD', sub_broker='BDA' where cl_code = 'S15615'
Update Client1 Set branch_cd = 'AHD', sub_broker='PERF' where cl_code = 'S15729'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'S15734'
Update Client1 Set branch_cd = 'ACM', sub_broker='NBH' where cl_code = 'S15737'
Update Client1 Set branch_cd = 'XV', sub_broker='GL' where cl_code = 'S1578'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'S15859'
Update Client1 Set branch_cd = 'HYD', sub_broker='PTS' where cl_code = 'S15859'
Update Client1 Set branch_cd = 'YB', sub_broker='DSM' where cl_code = 'S16243'
Update Client1 Set branch_cd = 'ACM', sub_broker='HEM' where cl_code = 'S16276'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'S16284'
Update Client1 Set branch_cd = 'ANAND', sub_broker='ANAND' where cl_code = 'S16327'
Update Client1 Set branch_cd = 'YA', sub_broker='SLI' where cl_code = 'S16365'
Update Client1 Set branch_cd = 'VD', sub_broker='VD' where cl_code = 'S16424'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S1644'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S1645'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SNW' where cl_code = 'S16479'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'S16561'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S166'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'S1675'
Update Client1 Set branch_cd = 'YA', sub_broker='DARS' where cl_code = 'S1689'
Update Client1 Set branch_cd = 'YA3', sub_broker='YA3' where cl_code = 'S17054'
Update Client1 Set branch_cd = 'INDO', sub_broker='AJK' where cl_code = 'S17068'
Update Client1 Set branch_cd = 'XPU', sub_broker='VAIS' where cl_code = 'S17083'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'S17084'
Update Client1 Set branch_cd = 'XD', sub_broker='AT' where cl_code = 'S17175'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S1743'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S176'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'S1764'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S177'
Update Client1 Set branch_cd = 'XN', sub_broker='RALY' where cl_code = 'S1791'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'S1825'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S184'
Update Client1 Set branch_cd = 'BVI', sub_broker='NPL' where cl_code = 'S1878'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S189'
Update Client1 Set branch_cd = 'XF', sub_broker='MBR' where cl_code = 'S1890'
Update Client1 Set branch_cd = 'BVI', sub_broker='ADS' where cl_code = 'S1897'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'S191'
Update Client1 Set branch_cd = 'YA', sub_broker='NNS' where cl_code = 'S1916'
Update Client1 Set branch_cd = 'XN', sub_broker='MTL' where cl_code = 'S1921'
Update Client1 Set branch_cd = 'YA', sub_broker='DM' where cl_code = 'S1938'
Update Client1 Set branch_cd = 'TB', sub_broker='MEER' where cl_code = 'S1972'
Update Client1 Set branch_cd = 'TB', sub_broker='HTL' where cl_code = 'S1979'
Update Client1 Set branch_cd = 'BVI', sub_broker='DMS' where cl_code = 'S1989'
Update Client1 Set branch_cd = 'BVI', sub_broker='DMS' where cl_code = 'S1997'
Update Client1 Set branch_cd = 'YB', sub_broker='HP' where cl_code = 'S2006'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'S2049'
Update Client1 Set branch_cd = 'XN', sub_broker='SBJ' where cl_code = 'S2066'
Update Client1 Set branch_cd = 'XS', sub_broker='SBIN' where cl_code = 'S2109'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S212'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'S215'
Update Client1 Set branch_cd = 'XV', sub_broker='AJ' where cl_code = 'S2175'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'S218'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'S2353'
Update Client1 Set branch_cd = 'BVI', sub_broker='PROY' where cl_code = 'S2358'
Update Client1 Set branch_cd = 'YB', sub_broker='KDA' where cl_code = 'S2369'
Update Client1 Set branch_cd = 'YB', sub_broker='KDA' where cl_code = 'S2370'
Update Client1 Set branch_cd = 'XD', sub_broker='JKG' where cl_code = 'S2456'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'S247'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'S2498'
Update Client1 Set branch_cd = 'BVI', sub_broker='PROY' where cl_code = 'S2514'
Update Client1 Set branch_cd = 'XD', sub_broker='JIN' where cl_code = 'S2520'
Update Client1 Set branch_cd = 'XG', sub_broker='KJSH' where cl_code = 'S2601'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S2639'
Update Client1 Set branch_cd = 'ACM', sub_broker='TRR' where cl_code = 'S2683'
Update Client1 Set branch_cd = 'TB', sub_broker='RKM' where cl_code = 'S2706'
Update Client1 Set branch_cd = 'XC', sub_broker='MNV' where cl_code = 'S2756'
Update Client1 Set branch_cd = 'ACM', sub_broker='TRR' where cl_code = 'S2759'
Update Client1 Set branch_cd = 'HYD', sub_broker='ANIT' where cl_code = 'S2794'
Update Client1 Set branch_cd = 'XD', sub_broker='SUA' where cl_code = 'S2827'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S286'
Update Client1 Set branch_cd = 'ACM', sub_broker='TRR' where cl_code = 'S2865'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S289'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S290'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S294'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S295'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'S2958'
Update Client1 Set branch_cd = 'BVI', sub_broker='SIG' where cl_code = 'S2976'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S298'
Update Client1 Set branch_cd = 'HYD', sub_broker='AKSE' where cl_code = 'S3000'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S3001'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S301'
Update Client1 Set branch_cd = 'XPU', sub_broker='VJP' where cl_code = 'S3018'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S304'
Update Client1 Set branch_cd = 'YB', sub_broker='ED' where cl_code = 'S3047'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S307'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S311'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S312'
Update Client1 Set branch_cd = 'XPU', sub_broker='ARDH' where cl_code = 'S3125'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S313'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S314'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S315'
Update Client1 Set branch_cd = 'XPU', sub_broker='GLC' where cl_code = 'S3153'
Update Client1 Set branch_cd = 'HYD', sub_broker='MIN' where cl_code = 'S3164'
Update Client1 Set branch_cd = 'XV', sub_broker='BB' where cl_code = 'S317'
Update Client1 Set branch_cd = 'HYD', sub_broker='PSV' where cl_code = 'S3192'
Update Client1 Set branch_cd = 'TB', sub_broker='RM' where cl_code = 'S320'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S324'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S325'
Update Client1 Set branch_cd = 'HYD', sub_broker='PSR' where cl_code = 'S3288'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S329'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S332'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S333'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S334'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S336'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S337'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S338'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S3431'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S344'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S346'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S347'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S349'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S351'
Update Client1 Set branch_cd = 'TB', sub_broker='KB' where cl_code = 'S353'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S3549'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S355'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S3602'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S363'
Update Client1 Set branch_cd = 'YA', sub_broker='SLD' where cl_code = 'S3644'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S365'
Update Client1 Set branch_cd = 'ACM', sub_broker='TRR' where cl_code = 'S3659'
Update Client1 Set branch_cd = 'XPU', sub_broker='VNR' where cl_code = 'S3688'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S372'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S376'
Update Client1 Set branch_cd = 'XS', sub_broker='RAG' where cl_code = 'S3768'
Update Client1 Set branch_cd = 'XV', sub_broker='BB' where cl_code = 'S381'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S382'
Update Client1 Set branch_cd = 'YA', sub_broker='DEAL' where cl_code = 'S3835'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S384'
Update Client1 Set branch_cd = 'YB', sub_broker='TI' where cl_code = 'S3866'
Update Client1 Set branch_cd = 'RAJ', sub_broker='PNRA' where cl_code = 'S3940'
Update Client1 Set branch_cd = 'YA', sub_broker='MUBE' where cl_code = 'S3948'
Update Client1 Set branch_cd = 'XG', sub_broker='RU' where cl_code = 'S3997'
Update Client1 Set branch_cd = 'HYD', sub_broker='NSK' where cl_code = 'S3998'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S400'
Update Client1 Set branch_cd = 'DELHI', sub_broker='JAI' where cl_code = 'S4128'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S413'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S414'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S4144'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'S4156'
Update Client1 Set branch_cd = 'TB', sub_broker='RM' where cl_code = 'S418'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S421'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S422'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S423'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S424'
Update Client1 Set branch_cd = 'XE', sub_broker='AA' where cl_code = 'S425'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S427'
Update Client1 Set branch_cd = 'DELHI', sub_broker='SEEM' where cl_code = 'S4274'
Update Client1 Set branch_cd = 'XPU', sub_broker='ALL' where cl_code = 'S4281'
Update Client1 Set branch_cd = 'HO', sub_broker='KLP' where cl_code = 'S4288'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S433'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S439'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'S4407'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S444'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S445'
Update Client1 Set branch_cd = 'XI', sub_broker='SVD' where cl_code = 'S4505'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S452'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S453'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S454'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S458'
Update Client1 Set branch_cd = 'HYD', sub_broker='SBF' where cl_code = 'S4598'
Update Client1 Set branch_cd = 'YA', sub_broker='SVT' where cl_code = 'S4601'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S462'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S463'
Update Client1 Set branch_cd = 'XPU', sub_broker='VEN' where cl_code = 'S4661'
Update Client1 Set branch_cd = 'HYD', sub_broker='SBB' where cl_code = 'S4685'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S470'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S471'
Update Client1 Set branch_cd = 'VD', sub_broker='SRI' where cl_code = 'S4725'
Update Client1 Set branch_cd = 'YA', sub_broker='SAUR' where cl_code = 'S4727'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S476'
Update Client1 Set branch_cd = 'VD', sub_broker='SRI' where cl_code = 'S4762'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'S4764'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S481'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S483'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S486'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S487'
Update Client1 Set branch_cd = 'AHD', sub_broker='SGS' where cl_code = 'S4885'
Update Client1 Set branch_cd = 'XPU', sub_broker='VIJAY' where cl_code = 'S4905'
Update Client1 Set branch_cd = 'XD', sub_broker='SKT' where cl_code = 'S4948'
Update Client1 Set branch_cd = 'XD', sub_broker='SKT' where cl_code = 'S4949'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S499'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S501'
Update Client1 Set branch_cd = 'HYD', sub_broker='APK' where cl_code = 'S5038'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S505'
Update Client1 Set branch_cd = 'XN', sub_broker='SUNS' where cl_code = 'S5110'
Update Client1 Set branch_cd = 'XPU', sub_broker='VIKG' where cl_code = 'S5112ZZ'
Update Client1 Set branch_cd = 'HYD', sub_broker='SKH' where cl_code = 'S5127'
Update Client1 Set branch_cd = 'AHD', sub_broker='PFC' where cl_code = 'S5129'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S515'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S519'
Update Client1 Set branch_cd = 'BVI', sub_broker='SRSH' where cl_code = 'S5195'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S520'
Update Client1 Set branch_cd = 'AHD', sub_broker='RRP' where cl_code = 'S5211'
Update Client1 Set branch_cd = 'AHD', sub_broker='AIR' where cl_code = 'S5247'
Update Client1 Set branch_cd = 'YA', sub_broker='PKS' where cl_code = 'S5257'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S528'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S533'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S534'
Update Client1 Set branch_cd = 'YA', sub_broker='BSB' where cl_code = 'S5380'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S540'
Update Client1 Set branch_cd = 'HYD', sub_broker='MHF' where cl_code = 'S5423'
Update Client1 Set branch_cd = 'HYD', sub_broker='PASA' where cl_code = 'S5424'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S545'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S547'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S548'
Update Client1 Set branch_cd = 'HYD', sub_broker='SBF' where cl_code = 'S5531'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S557'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S558'
Update Client1 Set branch_cd = 'AHD', sub_broker='PFC' where cl_code = 'S5587'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'S5592'
Update Client1 Set branch_cd = 'XN', sub_broker='SBJ' where cl_code = 'S5595'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S565'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S566'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S567'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S568'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S569'
Update Client1 Set branch_cd = 'BVI', sub_broker='JYO' where cl_code = 'S5696'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S570'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHA' where cl_code = 'S5701'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S572'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'S5726'
Update Client1 Set branch_cd = 'BNG', sub_broker='HRB' where cl_code = 'S5767'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'S5900'
Update Client1 Set branch_cd = 'XD', sub_broker='SKT' where cl_code = 'S5969'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S600'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S601'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S602'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'S6026'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S603'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S604'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'S605'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S606'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S610'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S612'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S617'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S618'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S6195'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'S6210ZZ'
Update Client1 Set branch_cd = 'DELHI', sub_broker='BHAD' where cl_code = 'S6227'
Update Client1 Set branch_cd = 'BVI', sub_broker='ASHI' where cl_code = 'S6251'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S626'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S629'
Update Client1 Set branch_cd = 'HYD', sub_broker='BRR' where cl_code = 'S6308'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'S6309'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S633'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S634'
Update Client1 Set branch_cd = 'RAJ', sub_broker='MLT' where cl_code = 'S6365'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S644'
Update Client1 Set branch_cd = 'AHD', sub_broker='SDT' where cl_code = 'S6452ZZ'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S649'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S650'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S651'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S6553'
Update Client1 Set branch_cd = 'XI', sub_broker='PPJ' where cl_code = 'S6554'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'S6555'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S657'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S658'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'S6580'
Update Client1 Set branch_cd = 'HYD', sub_broker='NES' where cl_code = 'S6604'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'S6608ZZ'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'S665'
Update Client1 Set branch_cd = 'ACM', sub_broker='SHRN' where cl_code = 'S6653'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S667'
Update Client1 Set branch_cd = 'DELHI', sub_broker='VKP' where cl_code = 'S6694'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S670'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S671'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S673'
Update Client1 Set branch_cd = 'BNG', sub_broker='RAVC' where cl_code = 'S6752'
Update Client1 Set branch_cd = 'XC', sub_broker='BELA' where cl_code = 'S6790'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'S683'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S687'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S691'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S695'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S697'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S698'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S701'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'S702'
Update Client1 Set branch_cd = 'HYD', sub_broker='SKH' where cl_code = 'S7049'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S705'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S708'
Update Client1 Set branch_cd = 'HYD', sub_broker='NES' where cl_code = 'S7118'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S712'
Update Client1 Set branch_cd = 'DELHI', sub_broker='BHAD' where cl_code = 'S7172'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'S718'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S724'
Update Client1 Set branch_cd = 'XN', sub_broker='BB' where cl_code = 'S726'
Update Client1 Set branch_cd = 'XW', sub_broker='BB' where cl_code = 'S730'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S733'
Update Client1 Set branch_cd = 'INDO', sub_broker='SUV' where cl_code = 'S7351'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S737'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'S7441'
Update Client1 Set branch_cd = 'XS', sub_broker='ROI' where cl_code = 'S7473'
Update Client1 Set branch_cd = 'AHD', sub_broker='AHD' where cl_code = 'S7477'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S751'
Update Client1 Set branch_cd = 'TB', sub_broker='JNK' where cl_code = 'S7600'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S761'
Update Client1 Set branch_cd = 'XG', sub_broker='BO' where cl_code = 'S762'
Update Client1 Set branch_cd = 'XS', sub_broker='SHI' where cl_code = 'S769'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S774'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S777'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S781'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S782'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'S7873'
Update Client1 Set branch_cd = 'INDO', sub_broker='INDO' where cl_code = 'S7875'
Update Client1 Set branch_cd = 'ACM', sub_broker='SID' where cl_code = 'S7958'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJ' where cl_code = 'S8051'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'S8076'
Update Client1 Set branch_cd = 'HO', sub_broker='NW' where cl_code = 'S817'
Update Client1 Set branch_cd = 'XS', sub_broker='SONI' where cl_code = 'S8227'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S824'
Update Client1 Set branch_cd = 'XS', sub_broker='SONI' where cl_code = 'S8288'
Update Client1 Set branch_cd = 'HO', sub_broker='KD' where cl_code = 'S8403'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'S8425'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'S849'
Update Client1 Set branch_cd = 'HYD', sub_broker='SRA' where cl_code = 'S8539'
Update Client1 Set branch_cd = 'XC', sub_broker='PI' where cl_code = 'S8721'
Update Client1 Set branch_cd = 'XD', sub_broker='XV' where cl_code = 'S8751'
Update Client1 Set branch_cd = 'BNG', sub_broker='BNG' where cl_code = 'S8772'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'S885'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S8934'
Update Client1 Set branch_cd = 'XN', sub_broker='KG' where cl_code = 'S895'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'S8957'
Update Client1 Set branch_cd = 'XT', sub_broker='AA' where cl_code = 'S899'
Update Client1 Set branch_cd = 'ACM', sub_broker='VIT' where cl_code = 'S8995'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'S901'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'S9140'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'S916'
Update Client1 Set branch_cd = 'THN', sub_broker='MAG' where cl_code = 'S9239'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S926'
Update Client1 Set branch_cd = 'HYD', sub_broker='SHAN' where cl_code = 'S9350'
Update Client1 Set branch_cd = 'HYD', sub_broker='MHF' where cl_code = 'S9479'
Update Client1 Set branch_cd = 'AHD', sub_broker='BLJ' where cl_code = 'S9531'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S961'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S962'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S9651'
Update Client1 Set branch_cd = 'VD', sub_broker='LSU' where cl_code = 'S9681'
Update Client1 Set branch_cd = 'XPU', sub_broker='YES' where cl_code = 'S9708'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'S972'
Update Client1 Set branch_cd = 'XPU', sub_broker='SVP' where cl_code = 'S9755'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S9763'
Update Client1 Set branch_cd = 'XV', sub_broker='TJ' where cl_code = 'S977'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'S9770'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'S979'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S9809'
Update Client1 Set branch_cd = 'YA', sub_broker='BCM' where cl_code = 'S9826'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S9835'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'S9888'
Update Client1 Set branch_cd = 'NASIK', sub_broker='NASIK' where cl_code = 'S9914'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'S999'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SA23'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'SA33'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SA39'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SA44'
Update Client1 Set branch_cd = 'XD', sub_broker='AV' where cl_code = 'SA45'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'SA49'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SA50'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'SA61'
Update Client1 Set branch_cd = 'XC', sub_broker='DCZ' where cl_code = 'SA66'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SA74'
Update Client1 Set branch_cd = 'XN', sub_broker='SON' where cl_code = 'SA86'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'SA91'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SA92'
Update Client1 Set branch_cd = 'HO', sub_broker='XH' where cl_code = 'SA94'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SB07'
Update Client1 Set branch_cd = 'XS', sub_broker='BB' where cl_code = 'SB21'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'SB23'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'SB24'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SB29'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB32'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB34'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB35'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'SB37'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB39'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SB41'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SB45'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'SB47'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB53'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'SB56'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SB58'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB67'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SB77'
Update Client1 Set branch_cd = 'XV', sub_broker='RD' where cl_code = 'SB79'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'SB90'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'SB93'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'SC06'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'SC17'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SC23'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'SC27'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SC34'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SC36'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SC37'
Update Client1 Set branch_cd = 'XV', sub_broker='BB' where cl_code = 'SC45'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SC63'
Update Client1 Set branch_cd = 'XF', sub_broker='PIT' where cl_code = 'SC65'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'SC77'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'SC79'
Update Client1 Set branch_cd = 'XS', sub_broker='BB' where cl_code = 'SC84'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SC85'
Update Client1 Set branch_cd = 'XG', sub_broker='RZ' where cl_code = 'SD05'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'SD10'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'SD27'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SD43'
Update Client1 Set branch_cd = 'YB', sub_broker='WS' where cl_code = 'SD56'
Update Client1 Set branch_cd = 'HO', sub_broker='TH' where cl_code = 'SD60'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'SD68'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'SD71'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SD95'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'SD98'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'SE06'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SE08'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'SE15'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SE17'
Update Client1 Set branch_cd = 'XC', sub_broker='DCZ' where cl_code = 'SE31'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SE53'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHJ' where cl_code = 'SF05'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'SF08'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'SF41'
Update Client1 Set branch_cd = 'YB', sub_broker='VN' where cl_code = 'SF45'
Update Client1 Set branch_cd = 'XC', sub_broker='SJ' where cl_code = 'SF74'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SF94'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SF98'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SG05'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SG15'
Update Client1 Set branch_cd = 'YZ', sub_broker='SY' where cl_code = 'SG59'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SH28'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SH29'
Update Client1 Set branch_cd = 'XC', sub_broker='PI' where cl_code = 'SH33'
Update Client1 Set branch_cd = 'XG', sub_broker='SHNE' where cl_code = 'SH70'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'SH82'
Update Client1 Set branch_cd = 'XH', sub_broker='FS' where cl_code = 'SH90'
Update Client1 Set branch_cd = 'XG', sub_broker='JA' where cl_code = 'SH95'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'SHG006'
Update Client1 Set branch_cd = 'XH', sub_broker='DR' where cl_code = 'SI05'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHJ' where cl_code = 'SI46'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHB' where cl_code = 'SI52'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHB' where cl_code = 'SI53'
Update Client1 Set branch_cd = 'XH', sub_broker='DR' where cl_code = 'SI62'
Update Client1 Set branch_cd = 'XD', sub_broker='MMI' where cl_code = 'SI79'
Update Client1 Set branch_cd = 'XD', sub_broker='MMI' where cl_code = 'SI89'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SJ27'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SJ31'
Update Client1 Set branch_cd = 'XS', sub_broker='RIC' where cl_code = 'SJ32'
Update Client1 Set branch_cd = 'XM', sub_broker='DRC' where cl_code = 'SJ36'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'SJ38'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SJ76'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SJ78'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SJ80'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SJ81'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SJ82'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SJ83'
Update Client1 Set branch_cd = 'XD', sub_broker='MMI' where cl_code = 'SK02'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SK50'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SK51'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SK64'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SL11'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SL12'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SL13'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SL17'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SL35'
Update Client1 Set branch_cd = 'HO', sub_broker='POJ' where cl_code = 'SL61'
Update Client1 Set branch_cd = 'XV', sub_broker='NN' where cl_code = 'SL62'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SL73'
Update Client1 Set branch_cd = 'XF', sub_broker='MI' where cl_code = 'SL90'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'SM28'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'SM30'
Update Client1 Set branch_cd = 'XD', sub_broker='MI' where cl_code = 'SM45'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SM59'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SM60'
Update Client1 Set branch_cd = 'XS', sub_broker='AYU' where cl_code = 'SM68'
Update Client1 Set branch_cd = 'HO', sub_broker='RKS' where cl_code = 'SM98'
Update Client1 Set branch_cd = 'HO', sub_broker='MUK' where cl_code = 'SN07'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SN32'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SN33'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SO20'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SO21'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'SO22'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'SO26'
Update Client1 Set branch_cd = 'HO', sub_broker='PL' where cl_code = 'SO31'
Update Client1 Set branch_cd = 'YA', sub_broker='VIRA' where cl_code = 'SO49'
Update Client1 Set branch_cd = 'XV', sub_broker='NN' where cl_code = 'SO81'
Update Client1 Set branch_cd = 'XD', sub_broker='MX' where cl_code = 'SP52'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SP55'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SP98'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SQ18'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SQ31'
Update Client1 Set branch_cd = 'YZ', sub_broker='SY' where cl_code = 'SQ33'
Update Client1 Set branch_cd = 'XS', sub_broker='KJC' where cl_code = 'SQ93'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'SR36'
Update Client1 Set branch_cd = 'XC', sub_broker='BELA' where cl_code = 'SR44'
Update Client1 Set branch_cd = 'TB', sub_broker='TB' where cl_code = 'SR47'
Update Client1 Set branch_cd = 'YB', sub_broker='UD' where cl_code = 'SR87'
Update Client1 Set branch_cd = 'HYD', sub_broker='SSRS' where cl_code = 'SU02'
Update Client1 Set branch_cd = 'XG', sub_broker='DD' where cl_code = 'SU12'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'SU22'
Update Client1 Set branch_cd = 'XS', sub_broker='POOJ' where cl_code = 'SU81'
Update Client1 Set branch_cd = 'YZ', sub_broker='SY' where cl_code = 'SU93'
Update Client1 Set branch_cd = 'XI', sub_broker='GN' where cl_code = 'SV11'
Update Client1 Set branch_cd = 'SVB', sub_broker='SVB' where cl_code = 'SVB429'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'SW11'
Update Client1 Set branch_cd = 'XF', sub_broker='SAR' where cl_code = 'SW21'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SW41'
Update Client1 Set branch_cd = 'YA', sub_broker='DARS' where cl_code = 'SX42'
Update Client1 Set branch_cd = 'XS', sub_broker='RDI' where cl_code = 'SX89'
Update Client1 Set branch_cd = 'XS', sub_broker='RDI' where cl_code = 'SX92'
Update Client1 Set branch_cd = 'XG', sub_broker='BO' where cl_code = 'SX98'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'SY82'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'SZ03'
Update Client1 Set branch_cd = 'XD', sub_broker='FB' where cl_code = 'SZ11'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'SZ28'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'SZ36'
Update Client1 Set branch_cd = 'XC', sub_broker='MNV' where cl_code = 'SZ46'
Update Client1 Set branch_cd = 'XF', sub_broker='MBR' where cl_code = 'SZ91'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'T007'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'T016'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T026'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T038'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T041'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T047'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'T048'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'T061'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'T063'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'T067'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'T072'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'T073'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T078'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'T081'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T087'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'T103'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'T1068'
Update Client1 Set branch_cd = 'XM', sub_broker='XM' where cl_code = 'T108'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T115'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'T119'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'T1194'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'T125'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'T126'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'T127'
Update Client1 Set branch_cd = 'XD', sub_broker='AA' where cl_code = 'T131'
Update Client1 Set branch_cd = 'XS', sub_broker='TIME' where cl_code = 'T135'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'T136'
Update Client1 Set branch_cd = 'ANAND', sub_broker='ANAND' where cl_code = 'T1437ZZ'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'T1477'
Update Client1 Set branch_cd = 'HYD', sub_broker='HST' where cl_code = 'T1503'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'T1514'
Update Client1 Set branch_cd = 'VP', sub_broker='PLG' where cl_code = 'T1603'
Update Client1 Set branch_cd = 'GRR', sub_broker='GRR' where cl_code = 'T1702'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'T1742'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'T240'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'T328'
Update Client1 Set branch_cd = 'YA', sub_broker='DM' where cl_code = 'T391'
Update Client1 Set branch_cd = 'XS', sub_broker='ROI' where cl_code = 'T412'
Update Client1 Set branch_cd = 'XD', sub_broker='PP' where cl_code = 'T469'
Update Client1 Set branch_cd = 'YB', sub_broker='NU' where cl_code = 'T487'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'T511'
Update Client1 Set branch_cd = 'XS', sub_broker='AKS' where cl_code = 'T571'
Update Client1 Set branch_cd = 'TB', sub_broker='PRF' where cl_code = 'T587'
Update Client1 Set branch_cd = 'HYD', sub_broker='TRM' where cl_code = 'T622'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'T656'
Update Client1 Set branch_cd = 'RAJ', sub_broker='TULSI' where cl_code = 'T674'
Update Client1 Set branch_cd = 'XD', sub_broker='SKT' where cl_code = 'T676'
Update Client1 Set branch_cd = 'XD', sub_broker='SKT' where cl_code = 'T703'
Update Client1 Set branch_cd = 'DELHI', sub_broker='VKP' where cl_code = 'T815'
Update Client1 Set branch_cd = 'YD', sub_broker='DEL' where cl_code = 'T831'
Update Client1 Set branch_cd = 'ACM', sub_broker='TARA' where cl_code = 'T844'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'T848'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'T849'
Update Client1 Set branch_cd = 'DELHI', sub_broker='LUD' where cl_code = 'T865'
Update Client1 Set branch_cd = 'HO', sub_broker='ZH' where cl_code = 'T949'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'T970'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'T971'
Update Client1 Set branch_cd = 'XH', sub_broker='VL' where cl_code = 'TEST23'
Update Client1 Set branch_cd = 'ACM', sub_broker='GOIN' where cl_code = 'TK05'
Update Client1 Set branch_cd = 'RAJ1', sub_broker='SUIN' where cl_code = 'TMO13'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'U002'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'U003'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'U014'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U017'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'U019'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U020'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U023'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U028'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U029'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'U032'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'U039'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'U040'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'U041'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'U058'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'U091'
Update Client1 Set branch_cd = 'BNG', sub_broker='LLT' where cl_code = 'U1006'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'U1068'
Update Client1 Set branch_cd = 'HO', sub_broker='NW' where cl_code = 'U1071'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'U1077'
Update Client1 Set branch_cd = 'XPU', sub_broker='NBJ' where cl_code = 'U1078'
Update Client1 Set branch_cd = 'NASIK', sub_broker='UJJ' where cl_code = 'U1119'
Update Client1 Set branch_cd = 'XPU', sub_broker='NBJ' where cl_code = 'U1131'
Update Client1 Set branch_cd = 'XS1', sub_broker='XS1' where cl_code = 'U1150'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'U1222'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'U1253'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'U1254'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MHR' where cl_code = 'U1255'
Update Client1 Set branch_cd = 'DELHI', sub_broker='USI' where cl_code = 'U1256'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'U1289'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'U1354'
Update Client1 Set branch_cd = 'HO', sub_broker='ZH' where cl_code = 'U136'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'U1374'
Update Client1 Set branch_cd = 'HYD', sub_broker='HSTB' where cl_code = 'U1466'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'U147'
Update Client1 Set branch_cd = 'XS', sub_broker='ANU' where cl_code = 'U152'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'U1603'
Update Client1 Set branch_cd = 'TB', sub_broker='BMP' where cl_code = 'U162'
Update Client1 Set branch_cd = 'XI', sub_broker='MI' where cl_code = 'U165'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'U173'
Update Client1 Set branch_cd = 'HO', sub_broker='PL' where cl_code = 'U190'
Update Client1 Set branch_cd = 'HO', sub_broker='VU' where cl_code = 'U238'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'U322'
Update Client1 Set branch_cd = 'YZ', sub_broker='YZ' where cl_code = 'U325'
Update Client1 Set branch_cd = 'XV', sub_broker='UM' where cl_code = 'U341'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'U404'
Update Client1 Set branch_cd = 'BVI', sub_broker='SIG' where cl_code = 'U454'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'U461'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RAR' where cl_code = 'U502'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'U519'
Update Client1 Set branch_cd = 'DELHI', sub_broker='FBD' where cl_code = 'U608'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'U617'
Update Client1 Set branch_cd = 'XS', sub_broker='SR' where cl_code = 'U648ZZ'
Update Client1 Set branch_cd = 'HYD', sub_broker='UMRA' where cl_code = 'U658'
Update Client1 Set branch_cd = 'VD', sub_broker='VDP' where cl_code = 'U731'
Update Client1 Set branch_cd = 'ACM', sub_broker='SMV' where cl_code = 'U822'
Update Client1 Set branch_cd = 'RAJ', sub_broker='ALS' where cl_code = 'U892ZZ'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'U922'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'U927'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'U962'
Update Client1 Set branch_cd = 'XPU', sub_broker='RTT' where cl_code = 'U969'
Update Client1 Set branch_cd = 'ACM', sub_broker='PREM' where cl_code = 'U996'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V023'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V040'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V043'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V045'
Update Client1 Set branch_cd = 'XG', sub_broker='XL' where cl_code = 'V051'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V067'
Update Client1 Set branch_cd = 'XF', sub_broker='AS' where cl_code = 'V074'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V086'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V088'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V092'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V093'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V096'
Update Client1 Set branch_cd = 'HYD', sub_broker='PSR' where cl_code = 'V1047'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V105'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V107'
Update Client1 Set branch_cd = 'XPU', sub_broker='VPD' where cl_code = 'V1074'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V109'
Update Client1 Set branch_cd = 'AHD', sub_broker='RASH' where cl_code = 'V1114'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V113'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V115'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJS' where cl_code = 'V1167'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V119'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V127'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V1286'
Update Client1 Set branch_cd = 'BVI', sub_broker='ASHI' where cl_code = 'V1348'
Update Client1 Set branch_cd = 'XD', sub_broker='AMES' where cl_code = 'V1384'
Update Client1 Set branch_cd = 'XN', sub_broker='VAK' where cl_code = 'V1463'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V147'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V149'
Update Client1 Set branch_cd = 'RAJ', sub_broker='MDV' where cl_code = 'V1502'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V153'
Update Client1 Set branch_cd = 'HYD', sub_broker='MEK' where cl_code = 'V1544'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V155'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'V1553'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V157'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V159'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V160'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V162'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V164'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V165'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V167'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V168'
Update Client1 Set branch_cd = 'RAJ', sub_broker='MDV' where cl_code = 'V1683'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'V169'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V170'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V172'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'V1720'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V1736'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V174'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V181'
Update Client1 Set branch_cd = 'RAJ', sub_broker='MDV' where cl_code = 'V1848'
Update Client1 Set branch_cd = 'HYD', sub_broker='NES' where cl_code = 'V1849'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V185'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V190'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V191'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V192'
Update Client1 Set branch_cd = 'NASIK', sub_broker='PK' where cl_code = 'V1926'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V193'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V196'
Update Client1 Set branch_cd = 'TB', sub_broker='TB' where cl_code = 'V2006'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'V2044ZZ'
Update Client1 Set branch_cd = 'XF', sub_broker='BH' where cl_code = 'V205'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJE' where cl_code = 'V2063'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V207'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'V2073ZZ'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V210'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V215'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'V2169'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V220'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'V223'
Update Client1 Set branch_cd = 'VD', sub_broker='VD' where cl_code = 'V2242'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V2251'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V2261'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V228'
Update Client1 Set branch_cd = 'HYD', sub_broker='BNS' where cl_code = 'V2318'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V241'
Update Client1 Set branch_cd = 'NASIK', sub_broker='TSS' where cl_code = 'V2413'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'V245'
Update Client1 Set branch_cd = 'XW', sub_broker='BB' where cl_code = 'V252'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V269'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V270'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V276'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'V293'
Update Client1 Set branch_cd = 'BNG', sub_broker='LLT' where cl_code = 'V2975'
Update Client1 Set branch_cd = 'VD', sub_broker='VDP' where cl_code = 'V2979'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V298'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'V303'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V3035'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RVR' where cl_code = 'V3049'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V3073'
Update Client1 Set branch_cd = 'YB', sub_broker='KA' where cl_code = 'V3086'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V309'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V316'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V320'
Update Client1 Set branch_cd = 'THN', sub_broker='PRH' where cl_code = 'V3224'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V325'
Update Client1 Set branch_cd = 'HYD', sub_broker='BRK' where cl_code = 'V3355'
Update Client1 Set branch_cd = 'HYD', sub_broker='BRK' where cl_code = 'V3356'
Update Client1 Set branch_cd = 'YD', sub_broker='YD' where cl_code = 'V3373'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V3379'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V3396'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RAR' where cl_code = 'V3399'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V3490'
Update Client1 Set branch_cd = 'BNG', sub_broker='MAIN' where cl_code = 'V3524'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'V359'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V360'
Update Client1 Set branch_cd = 'RAJ', sub_broker='VPA' where cl_code = 'V3631'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'V364'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'V376'
Update Client1 Set branch_cd = 'YI', sub_broker='YI' where cl_code = 'V3803'
Update Client1 Set branch_cd = 'VP', sub_broker='VAPI' where cl_code = 'V3812'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'V3816'
Update Client1 Set branch_cd = 'BNG', sub_broker='BULL' where cl_code = 'V3824'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MAI' where cl_code = 'V3825'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V383'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'V384'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'V385'
Update Client1 Set branch_cd = 'XS', sub_broker='SHI' where cl_code = 'V3850'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V387'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'V388'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'V396'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'V400'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'V401'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'V402'
Update Client1 Set branch_cd = 'INDO', sub_broker='VBG' where cl_code = 'V4020'
Update Client1 Set branch_cd = 'XN', sub_broker='DMP' where cl_code = 'V4052'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V4095'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'V4098'
Update Client1 Set branch_cd = 'XM', sub_broker='XM' where cl_code = 'V411'
Update Client1 Set branch_cd = 'INDO', sub_broker='GOLD' where cl_code = 'V4147'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'V4162'
Update Client1 Set branch_cd = 'BNG', sub_broker='REKO' where cl_code = 'V4252'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'V4285'
Update Client1 Set branch_cd = 'XU', sub_broker='XU' where cl_code = 'V429'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'V4311'
Update Client1 Set branch_cd = 'XI', sub_broker='NI' where cl_code = 'V4314'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'V435'
Update Client1 Set branch_cd = 'XS', sub_broker='VNI' where cl_code = 'V440'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'V4417'
Update Client1 Set branch_cd = 'TB', sub_broker='SHRE' where cl_code = 'V445'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V4475'
Update Client1 Set branch_cd = 'XC', sub_broker='XC' where cl_code = 'V448'
Update Client1 Set branch_cd = 'XG', sub_broker='ZC' where cl_code = 'V4572'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'V4602'
Update Client1 Set branch_cd = 'XC', sub_broker='DCZ' where cl_code = 'V469'
Update Client1 Set branch_cd = 'VD', sub_broker='REN' where cl_code = 'V4787'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SNW' where cl_code = 'V4792'
Update Client1 Set branch_cd = 'YB', sub_broker='JD' where cl_code = 'V483'
Update Client1 Set branch_cd = 'RAJ', sub_broker='VIJY' where cl_code = 'V4870'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V4874'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'V4920'
Update Client1 Set branch_cd = 'YA', sub_broker='KGD' where cl_code = 'V4921'
Update Client1 Set branch_cd = 'XI', sub_broker='RHM' where cl_code = 'V5001'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V5057'
Update Client1 Set branch_cd = 'RAJ', sub_broker='JDS' where cl_code = 'V5078'
Update Client1 Set branch_cd = 'BNG', sub_broker='SOS' where cl_code = 'V5157'
Update Client1 Set branch_cd = 'INDO', sub_broker='PRJA' where cl_code = 'V5169'
Update Client1 Set branch_cd = 'DELHI', sub_broker='KSBZ' where cl_code = 'V5170'
Update Client1 Set branch_cd = 'NASIK', sub_broker='DIBS' where cl_code = 'V5236'
Update Client1 Set branch_cd = 'ACM', sub_broker='APA' where cl_code = 'V5241'
Update Client1 Set branch_cd = 'YA', sub_broker='BCM' where cl_code = 'V525'
Update Client1 Set branch_cd = 'YA', sub_broker='SSN' where cl_code = 'V5289'
Update Client1 Set branch_cd = 'YA', sub_broker='UNF' where cl_code = 'V529'
Update Client1 Set branch_cd = 'HYD', sub_broker='SRA' where cl_code = 'V5300'
Update Client1 Set branch_cd = 'NASHIK', sub_broker='SNW' where cl_code = 'V5320'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJ' where cl_code = 'V5471'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V5549'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MYI' where cl_code = 'V5814'
Update Client1 Set branch_cd = 'VD', sub_broker='ZIL' where cl_code = 'V5828'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V5882'
Update Client1 Set branch_cd = 'XD', sub_broker='BB' where cl_code = 'V601'
Update Client1 Set branch_cd = 'THN', sub_broker='THN' where cl_code = 'V6019'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V6050'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V6051'
Update Client1 Set branch_cd = 'XS', sub_broker='BB' where cl_code = 'V607'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'V6078'
Update Client1 Set branch_cd = 'XG', sub_broker='BB' where cl_code = 'V608'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'V6091'
Update Client1 Set branch_cd = 'YA', sub_broker='EBG' where cl_code = 'V6095'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'V610'
Update Client1 Set branch_cd = 'HO', sub_broker='BB' where cl_code = 'V611'
Update Client1 Set branch_cd = 'XE', sub_broker='BB' where cl_code = 'V612'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MYU' where cl_code = 'V6136'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'V679'
Update Client1 Set branch_cd = 'HO', sub_broker='RE' where cl_code = 'V680'
Update Client1 Set branch_cd = 'XN', sub_broker='ID' where cl_code = 'V718'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'V751'
Update Client1 Set branch_cd = 'XF', sub_broker='AN' where cl_code = 'V758'
Update Client1 Set branch_cd = 'XD', sub_broker='MI' where cl_code = 'V764'
Update Client1 Set branch_cd = 'XD', sub_broker='UNNA' where cl_code = 'V877'
Update Client1 Set branch_cd = 'XF', sub_broker='MBR' where cl_code = 'V883'
Update Client1 Set branch_cd = 'YA', sub_broker='ANMO' where cl_code = 'V924'
Update Client1 Set branch_cd = 'XN', sub_broker='SPR' where cl_code = 'V948'
Update Client1 Set branch_cd = 'XF', sub_broker='SAR' where cl_code = 'VB19'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDH' where cl_code = 'VB49'
Update Client1 Set branch_cd = 'XN', sub_broker='RRR' where cl_code = 'VC56'
Update Client1 Set branch_cd = 'XD', sub_broker='NIT' where cl_code = 'VC57'
Update Client1 Set branch_cd = 'YA', sub_broker='NDD' where cl_code = 'VC94'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'VD55'
Update Client1 Set branch_cd = 'YB', sub_broker='SHJA' where cl_code = 'VD75'
Update Client1 Set branch_cd = 'RAJ1', sub_broker='VDJ' where cl_code = 'VDJ32'
Update Client1 Set branch_cd = 'TB', sub_broker='BMP' where cl_code = 'VE70'
Update Client1 Set branch_cd = 'XD', sub_broker='UNNA' where cl_code = 'VF20'
Update Client1 Set branch_cd = 'XS', sub_broker='RDI' where cl_code = 'VF31'
Update Client1 Set branch_cd = 'HYD', sub_broker='PVV' where cl_code = 'VG17'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDHD' where cl_code = 'VG23'
Update Client1 Set branch_cd = 'XN', sub_broker='SPR' where cl_code = 'VG31'
Update Client1 Set branch_cd = 'XN', sub_broker='STL' where cl_code = 'VG41'
Update Client1 Set branch_cd = 'XS', sub_broker='RAG' where cl_code = 'VG51'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'VG77'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'VH50'
Update Client1 Set branch_cd = 'XPU', sub_broker='XPU' where cl_code = 'VJ57'
Update Client1 Set branch_cd = 'BVI', sub_broker='PROY' where cl_code = 'VJ82'
Update Client1 Set branch_cd = 'BVI', sub_broker='SUM' where cl_code = 'VK37'
Update Client1 Set branch_cd = 'HYD', sub_broker='VIJ' where cl_code = 'VK39'
Update Client1 Set branch_cd = 'BVI', sub_broker='SRSH' where cl_code = 'VK49'
Update Client1 Set branch_cd = 'XN', sub_broker='SBJ' where cl_code = 'VL48'
Update Client1 Set branch_cd = 'XPU', sub_broker='VIKG' where cl_code = 'VL64'
Update Client1 Set branch_cd = 'HYD', sub_broker='KSN' where cl_code = 'VL82'
Update Client1 Set branch_cd = 'YZ', sub_broker='MDHD' where cl_code = 'VL83'
Update Client1 Set branch_cd = 'AHD', sub_broker='AIR' where cl_code = 'VM75'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'VM76'
Update Client1 Set branch_cd = 'TB', sub_broker='PE' where cl_code = 'VM99'
Update Client1 Set branch_cd = 'XS', sub_broker='KIK' where cl_code = 'VN11'
Update Client1 Set branch_cd = 'HO', sub_broker='MUK' where cl_code = 'VN19'
Update Client1 Set branch_cd = 'XF', sub_broker='BH' where cl_code = 'VN20'
Update Client1 Set branch_cd = 'XD', sub_broker='JKG' where cl_code = 'VN32'
Update Client1 Set branch_cd = 'ACM', sub_broker='TRR' where cl_code = 'VN74'
Update Client1 Set branch_cd = 'XV', sub_broker='PARA' where cl_code = 'VP26'
Update Client1 Set branch_cd = 'DELHI', sub_broker='DEL' where cl_code = 'VP85'
Update Client1 Set branch_cd = 'AHD', sub_broker='PFC' where cl_code = 'VR92'
Update Client1 Set branch_cd = 'YA', sub_broker='AKSH' where cl_code = 'VT07ZZ'
Update Client1 Set branch_cd = 'XPU', sub_broker='VIKG' where cl_code = 'VT79ZZ'
Update Client1 Set branch_cd = 'DELHI', sub_broker='RELI' where cl_code = 'VU57'
Update Client1 Set branch_cd = 'AHD', sub_broker='AIR' where cl_code = 'VU70'
Update Client1 Set branch_cd = 'RAJ', sub_broker='YSK' where cl_code = 'VW43'
Update Client1 Set branch_cd = 'VD', sub_broker='RHP' where cl_code = 'VW93'
Update Client1 Set branch_cd = 'XPU', sub_broker='VJP' where cl_code = 'VW98'
Update Client1 Set branch_cd = 'XPU', sub_broker='VIJAY' where cl_code = 'VX08'
Update Client1 Set branch_cd = 'HYD', sub_broker='HST' where cl_code = 'VX17'
Update Client1 Set branch_cd = 'AHD', sub_broker='PFC' where cl_code = 'VX72'
Update Client1 Set branch_cd = 'AHD', sub_broker='VISH' where cl_code = 'VX77'
Update Client1 Set branch_cd = 'RAJ', sub_broker='PVT' where cl_code = 'VY41'
Update Client1 Set branch_cd = 'XPU', sub_broker='SAK' where cl_code = 'VY68'
Update Client1 Set branch_cd = 'HYD', sub_broker='KIT' where cl_code = 'VZ73'
Update Client1 Set branch_cd = 'HO', sub_broker='HO' where cl_code = 'W018'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'W021'
Update Client1 Set branch_cd = 'ACM', sub_broker='MSD' where cl_code = 'WS02'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'Y002'
Update Client1 Set branch_cd = 'XT', sub_broker='XT' where cl_code = 'Y015'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'Y020'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'Y021'
Update Client1 Set branch_cd = 'XV', sub_broker='XV' where cl_code = 'Y022'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'Y025'
Update Client1 Set branch_cd = 'XG', sub_broker='XG' where cl_code = 'Y026'
Update Client1 Set branch_cd = 'XN', sub_broker='XN' where cl_code = 'Y028'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'Y029'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'Y032'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'Y036'
Update Client1 Set branch_cd = 'XH', sub_broker='XH' where cl_code = 'Y052'
Update Client1 Set branch_cd = 'TB', sub_broker='PR' where cl_code = 'Y077'
Update Client1 Set branch_cd = 'XH', sub_broker='KI' where cl_code = 'Y079'
Update Client1 Set branch_cd = 'XS', sub_broker='CY' where cl_code = 'Y080'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'Y095'
Update Client1 Set branch_cd = 'XS', sub_broker='TSBR' where cl_code = 'Y097'
Update Client1 Set branch_cd = 'XS', sub_broker='CY' where cl_code = 'Y098'
Update Client1 Set branch_cd = 'XF', sub_broker='PM' where cl_code = 'Y099'
Update Client1 Set branch_cd = 'XD', sub_broker='PZ' where cl_code = 'Y111'
Update Client1 Set branch_cd = 'HO', sub_broker='ZHD' where cl_code = 'Y117'
Update Client1 Set branch_cd = 'YZ', sub_broker='SY' where cl_code = 'Y145'
Update Client1 Set branch_cd = 'TB', sub_broker='SDB' where cl_code = 'Y150'
Update Client1 Set branch_cd = 'XS', sub_broker='PSM' where cl_code = 'Y152'
Update Client1 Set branch_cd = 'XI', sub_broker='XI' where cl_code = 'Y154'
Update Client1 Set branch_cd = 'YA', sub_broker='PHS' where cl_code = 'Y155'
Update Client1 Set branch_cd = 'BVI', sub_broker='SUM' where cl_code = 'Y189'
Update Client1 Set branch_cd = 'XS', sub_broker='ALC' where cl_code = 'Y204'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'Y231'
Update Client1 Set branch_cd = 'YA', sub_broker='IM' where cl_code = 'Y272'
Update Client1 Set branch_cd = 'XS', sub_broker='NCS' where cl_code = 'Y281'
Update Client1 Set branch_cd = 'XPU', sub_broker='YES' where cl_code = 'Y303'
Update Client1 Set branch_cd = 'YA', sub_broker='VMD' where cl_code = 'Y311'
Update Client1 Set branch_cd = 'RAJ', sub_broker='YSNB' where cl_code = 'Y348'
Update Client1 Set branch_cd = 'AHD', sub_broker='DGP' where cl_code = 'Y350'
Update Client1 Set branch_cd = 'XS', sub_broker='KPJ' where cl_code = 'Y401'
Update Client1 Set branch_cd = 'HYD', sub_broker='HYD' where cl_code = 'Y435'
Update Client1 Set branch_cd = 'AHD', sub_broker='SUR' where cl_code = 'Y450'
Update Client1 Set branch_cd = 'AHD', sub_broker='RASH' where cl_code = 'Y463ZZ'
Update Client1 Set branch_cd = 'BVI', sub_broker='ASHI' where cl_code = 'Y477'
Update Client1 Set branch_cd = 'RAJ', sub_broker='LDT' where cl_code = 'Y498ZZ'
Update Client1 Set branch_cd = 'ANK', sub_broker='CC' where cl_code = 'Y525'
Update Client1 Set branch_cd = 'XD', sub_broker='XD' where cl_code = 'Y530'
Update Client1 Set branch_cd = 'AHD', sub_broker='JBP' where cl_code = 'Y563'
Update Client1 Set branch_cd = 'ACM', sub_broker='ACM' where cl_code = 'Y564'
Update Client1 Set branch_cd = 'BAN', sub_broker='BAN' where cl_code = 'Y576'
Update Client1 Set branch_cd = 'RAJ', sub_broker='RAJ' where cl_code = 'Y585'
Update Client1 Set branch_cd = 'YA', sub_broker='SSI' where cl_code = 'Y586'
Update Client1 Set branch_cd = 'DELHI', sub_broker='MHR' where cl_code = 'Y721ZZ'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'Y731'
Update Client1 Set branch_cd = 'YA', sub_broker='SSSB' where cl_code = 'Y784'
Update Client1 Set branch_cd = 'NASIK', sub_broker='NASIK' where cl_code = 'Y790'
Update Client1 Set branch_cd = 'TB', sub_broker='EQT' where cl_code = 'Y800'
Update Client1 Set branch_cd = 'ACM', sub_broker='KLSH' where cl_code = 'Y804'
Update Client1 Set branch_cd = 'BVI', sub_broker='PJS' where cl_code = 'Y809'
Update Client1 Set branch_cd = 'XPU', sub_broker='AMIN' where cl_code = 'Y821'
Update Client1 Set branch_cd = 'ANAND', sub_broker='ANAND' where cl_code = 'Y860'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'Y879'
Update Client1 Set branch_cd = 'RAJ', sub_broker='JLS' where cl_code = 'Y886'
Update Client1 Set branch_cd = 'RAJ', sub_broker='KRD' where cl_code = 'Y918'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'Z020'
Update Client1 Set branch_cd = 'XF', sub_broker='XF' where cl_code = 'Z023'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'Z028'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'Z042'
Update Client1 Set branch_cd = 'XI', sub_broker='BY' where cl_code = 'Z044'
Update Client1 Set branch_cd = 'XF', sub_broker='PM' where cl_code = 'Z066'
Update Client1 Set branch_cd = 'XS', sub_broker='ALC' where cl_code = 'ZA08'
Update Client1 Set branch_cd = 'XS', sub_broker='FI' where cl_code = 'ZA12'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'ZA14'
Update Client1 Set branch_cd = 'BAN', sub_broker='BAN' where cl_code = 'ZA44'
Update Client1 Set branch_cd = 'XS', sub_broker='CY' where cl_code = 'ZA63'
Update Client1 Set branch_cd = 'XS', sub_broker='XS' where cl_code = 'ZA64'
Update Client1 Set branch_cd = 'XG', sub_broker='ZC' where cl_code = 'ZA65'
Update Client1 Set branch_cd = 'YB', sub_broker='AAK' where cl_code = 'ZA66'
Update Client1 Set branch_cd = 'YB', sub_broker='YB' where cl_code = 'ZA67'
Update Client1 Set branch_cd = 'VD', sub_broker='ZIL' where cl_code = 'ZA71'
Update Client1 Set branch_cd = 'VD', sub_broker='VD' where cl_code = 'ZA72'
Update Client1 Set branch_cd = 'NASIK', sub_broker='SOH' where cl_code = 'ZB15'
Update Client1 Set branch_cd = 'YA', sub_broker='SABA' where cl_code = 'ZB16'
Update Client1 Set branch_cd = 'BAN', sub_broker='BAN' where cl_code = 'ZB74'
Update Client1 Set branch_cd = 'BAN', sub_broker='BAN' where cl_code = 'ZB75'
Update Client1 Set branch_cd = 'YB', sub_broker='IDA' where cl_code = 'ZB84'
Update Client1 Set branch_cd = 'BVI', sub_broker='RKJ' where cl_code = 'ZB85'
Update Client1 Set branch_cd = 'XR', sub_broker='NS' where cl_code = 'ZO42'
Update Client1 Set branch_cd = 'XR', sub_broker='NS' where cl_code = 'ZO43'
Update Client1 Set branch_cd = 'YA', sub_broker='CC' where cl_code = 'ZO48'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'ZO60'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'ZO61'
Update Client1 Set branch_cd = 'BVI', sub_broker='BVI' where cl_code = 'ZO62'
Update Client1 Set branch_cd = 'BVI', sub_broker='SUM' where cl_code = 'ZO63'
Update Client1 Set branch_cd = 'BVI', sub_broker='KJSH' where cl_code = 'ZO65'
Update Client1 Set branch_cd = 'BVI', sub_broker='RCM' where cl_code = 'ZO66'

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
-- PROCEDURE dbo.V2_CLASS_CHECKPATH_POP
-- --------------------------------------------------
CREATE PROC V2_CLASS_CHECKPATH_POP AS    
    
 SET NOCOUNT ON     
     
 BEGIN TRAN    
     
 DELETE FROM TBL_CLASS_EXCEPTION_FOLDERS    
 WHERE ISNULL(FLDCATEGORY,'') <> ''    
    
 DELETE FROM TBL_CLASS_EXCEPTION_FOLDERS    
 WHERE ISNULL(FILEPATH,'/') = '/'    
    
 DECLARE @SHAREDB VARCHAR(20)    
 DECLARE @MULTICOMPANY CURSOR    
 DECLARE @SQL VARCHAR(8000)     
     
 SET @MULTICOMPANY = CURSOR FOR SELECT DISTINCT SHAREDB FROM MULTICOMPANY_ALL    
 OPEN @MULTICOMPANY          
               
           
 FETCH NEXT FROM @MULTICOMPANY INTO @SHAREDB    
 WHILE @@FETCH_STATUS = 0           
 BEGIN          
     
  SET @SQL ='INSERT INTO TBL_CLASS_EXCEPTION_FOLDERS'    
  SET @SQL = @SQL + ' SELECT FILEPATH = PRADNYA.DBO.GETFNSPLITSTRING(R.FLDPATH,''/''), c.fldcategorycode'    
  SET @SQL = @SQL + ' FROM ' + @SHAREDB  +'.DBO.TBLREPORTS R (NOLOCK) INNER JOIN '+ @SHAREDB +'.DBO.TBLCATMENU C (NOLOCK)'    
  SET @SQL = @SQL + ' ON (R.FLDREPORTCODE = C.FLDREPORTCODE)'    
     
  EXEC (@SQL)    
         
  FETCH NEXT FROM @MULTICOMPANY INTO @SHAREDB    
 END          
 CLOSE @MULTICOMPANY          
 DEALLOCATE @MULTICOMPANY    
     
 SELECT DISTINCT * INTO #TBL_CLASS_EXCEPTION_FOLDERS FROM TBL_CLASS_EXCEPTION_FOLDERS    
 WHERE ISNULL(FLDCATEGORY,'') <> ''    
     
 INSERT INTO TBL_CLASS_EXCEPTION_FOLDERS SELECT * FROM #TBL_CLASS_EXCEPTION_FOLDERS    
 DROP TABLE #TBL_CLASS_EXCEPTION_FOLDERS    
     
 DELETE FROM TBL_CLASS_EXCEPTION_FOLDERS    
 WHERE ISNULL(FILEPATH,'/') = '/'    
     
 COMMIT    
    
 SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_CONTSECTION
-- --------------------------------------------------

CREATE    PROC V2_CONTSECTION ( @STATUSID VARCHAR(15), @STATUSNAME VARCHAR(25), @SAUDA_DATE VARCHAR(11), @FROMPARTY_CODE VARCHAR(10), @TOPARTY_CODE VARCHAR(10), @BRANCH VARCHAR(10), @SUB_BROKER VARCHAR(10), @FROMCONTRACTNO VARCHAR(12), @TOCONTRACTNO VARCHAR(12), @CONTFLAG VARCHAR(10) ) 
AS 
        If @SUB_BROKER = 'ALL' OR @SUB_BROKER = '' 
        Begin 
                Set @SUB_BROKER = '%' 
        End If @BRANCH          = 'ALL' OR @BRANCH = '' 
Begin 
        Set @BRANCH = '%' 
End 

	If @FROMCONTRACTNO = ''
	Begin
		set @FROMCONTRACTNO = 000000
	End
	
	If @TOCONTRACTNO = ''
	Begin
		Set @TOCONTRACTNO = 99999999
	End

SELECT  C2.PARTY_CODE, 
        C1.LONG_NAME, 
        C1.L_ADDRESS1, 
        C1.L_ADDRESS2, 
        C1.L_ADDRESS3, 
        C1.L_CITY, 
        C1.L_ZIP, 
        C1.BRANCH_CD , 
        C1.SUB_BROKER, 
        C1.TRADER, 
        C1.PAN_GIR_NO, 
        C1.OFF_PHONE1, 
        C1.OFF_PHONE2, 
        PRINTF, 
        MAPIDID, 
        C2.SERVICE_CHRG, 
        BROKERNOTE, 
        TURNOVER_TAX, 
        SEBI_TURN_TAX, 
        C2.OTHER_CHRG, 
        INSURANCE_CHRG,
	SEBI_NO = FD_Code
INTO    #CLIENTMASTER 
FROM    CLIENT1 C1 
WITH 
        ( 
                NOLOCK 
        ) 
        , 
        CLIENT2 C2 
WITH 
        ( 
                NOLOCK 
        ) 
LEFT OUTER JOIN UCC_CLIENT UC 
WITH 
        ( 
                NOLOCK 
        ) 
        ON C2.PARTY_CODE = UC.PARTY_CODE 
WHERE   C2.CL_CODE       = C1.CL_CODE 
        AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
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
                ELSE 'BROKER' END) 
        AND BRANCH_CD LIKE @BRANCH 
        AND SUB_BROKER LIKE @SUB_BROKER SELECT  Contractno, 
        Billno, 
        Trade_No, 
        Party_Code, 
        Inst_Type, 
        Symbol, 
        Sec_Name, 
        Expirydate, 
        Strike_Price, 
        Option_Type, 
        User_Id, 
        Pro_Cli, 
        O_C_Flag, 
        C_U_Flag, 
        Tradeqty, 
        Auctionpart, 
        Markettype, 
        Series, 
        Order_No, 
        Price, 
        Sauda_Date, 
        Table_No, 
        Line_No, 
        Val_Perc, 
        Normal, 
        Day_Puc, 
        Day_Sales, 
        Sett_Purch, 
        Sett_Sales, 
        Sell_Buy, 
        Settflag, 
        Brokapplied, 
        Netrate, 
        Amount, 
        Ins_Chrg, 
        Turn_Tax, 
        Other_Chrg, 
        Sebi_Tax, 
        Broker_Chrg, 
        Service_Tax, 
        Trade_Amount, 
        Billflag, 
        Sett_No, 
        Nbrokapp, 
        Nsertax, 
        N_Netrate, 
        Sett_Type, 
        Cl_Rate, 
        Participantcode, 
        Status, 
        Cpid, 
        Instrument, 
        Booktype, 
        Branch_Id, 
        Tmark, 
        Scheme, 
        Dummy1, 
        Dummy2, 
        Reserved1, 
        Reserved2 
INTO    #FOSETT 
FROM    FOSETTLEMENT 
WHERE   1 = 2 
INSERT 
INTO    #FOSETT 
SELECT  Contractno, 
        Billno, 
        Trade_No, 
        Party_Code, 
        Inst_Type, 
        Symbol, 
        Sec_Name, 
        Expirydate, 
        Strike_Price, 
        Option_Type, 
        User_Id, 
        Pro_Cli, 
        O_C_Flag, 
        C_U_Flag, 
        Tradeqty, 
        Auctionpart, 
        Markettype, 
        Series, 
        Order_No, 
        Price, 
     Sauda_Date, 
        Table_No, 
        Line_No, 
        Val_Perc, 
        Normal, 
        Day_Puc, 
        Day_Sales, 
        Sett_Purch, 
        Sett_Sales, 
        Sell_Buy, 
        Settflag, 
        Brokapplied, 
        Netrate, 
        Amount, 
        Ins_Chrg, 
        Turn_Tax, 
        Other_Chrg, 
        Sebi_Tax, 
        Broker_Chrg, 
        Service_Tax, 
        Trade_Amount, 
        Billflag, 
        Sett_No, 
        Nbrokapp, 
        Nsertax, 
        N_Netrate, 
        Sett_Type, 
        Cl_Rate, 
        Participantcode, 
        Status, 
        Cpid, 
        Instrument, 
        Booktype, 
        Branch_Id, 
        Tmark, 
        Scheme, 
        Dummy1, 
        Dummy2, 
        Reserved1, 
        Reserved2 
FROM    FOSETTLEMENT 
WHERE   sauda_date LIKE @SAUDA_DATE + '%' 
        AND party_code >= @FROMPARTY_CODE 
        AND party_code <= @TOPARTY_CODE 
        AND auctionpart NOT IN ('CA') 
        AND tradeqty <> 0 
        AND PRICE     > 0 
        AND RESERVED1 = 0 
/*
INSERT 
INTO    #FOSETT 
SELECT  Contractno, 
        Billno, 
        Trade_No, 
        Party_Code, 
        Inst_Type, 
        Symbol, 
        Sec_Name, 
        Expirydate, 
        Strike_Price, 
        Option_Type, 
        User_Id, 
        Pro_Cli, 
        O_C_Flag, 
        C_U_Flag, 
        Tradeqty, 
        Auctionpart, 
        Markettype, 
        Series, 
        Order_No, 
        Price, 
        Sauda_Date, 
        Table_No, 
        Line_No, 
        Val_Perc, 
        Normal, 
        Day_Puc, 
        Day_Sales, 
        Sett_Purch, 
        Sett_Sales, 
        Sell_Buy, 
        Settflag, 
        Brokapplied, 
        Netrate, 
        Amount, 
        Ins_Chrg, 
        Turn_Tax, 
        Other_Chrg, 
        Sebi_Tax, 
        Broker_Chrg, 
        Service_Tax, 
        Trade_Amount, 
        Billflag, 
        Sett_No, 
        Nbrokapp, 
        Nsertax, 
        N_Netrate, 
        Sett_Type, 
        Cl_Rate, 
        Participantcode, 
        Status, 
        Cpid, 
        Instrument, 
        Booktype, 
        Branch_Id, 
        Tmark, 
        Scheme, 
        Dummy1, 
        Dummy2, 
        Reserved1, 
        Reserved2 
FROM    PRADNYA.DBO.HISTORY_FOSETTLEMENT_NSEFO 
WHERE   sauda_date LIKE @SAUDA_DATE + '%' 
        AND party_code >= @FROMPARTY_CODE 
        AND party_code <= @TOPARTY_CODE 
        AND auctionpart NOT IN ('CA') 
        AND tradeqty <> 0 
        AND PRICE     > 0 
        AND RESERVED1 = 0 
*/
CREATE INDEX [DELPOS] 
        ON [dbo].[#FOSETT] 
        ( 
                [PARTY_CODE] 
        ) 
SELECT  order_no, 
        ORDER_TIME = ( 
        CASE 
                WHEN CPID = 'NIL' 
                OR CPID   = '0' 
                THEN '        ' 
                ELSE Right(CpId,8) END), 
        Trade_no, 
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,108),11) as tradetime, 
        pqty = ( 
        CASE 
                WHEN sell_buy = 1 
                THEN tradeqty 
                ELSE 0 END), 
        sqty = ( 
        CASE 
                WHEN sell_buy = 2 
                THEN tradeqty 
                ELSE 0 END), 
        prate = ( 
        CASE 
                WHEN sell_buy = 1 
                THEN isnull(price,0) 
                ELSE 0 END), 
        srate = ( 
        CASE 
                WHEN sell_buy = 2 
                THEN isnull(price,0) 
                ELSE 0 END), 
        pbrok =( 
        CASE 
                WHEN sell_buy = 1 
                THEN isnull((brokapplied + ( 
                CASE 
                        WHEN C.service_chrg=1 
                        THEN isnull(f.SERVICE_TAX/tradeqty,0) 
                        ELSE 0 END )),0) 
                ELSE 0 END), 
        sbrok =( 
        CASE 
                WHEN sell_buy = 2 
                THEN isnull((brokapplied + ( 
                CASE 
                        WHEN C.service_chrg=1 
                        THEN isnull(f.SERVICE_TAX/tradeqty,0) 
                        ELSE 0 END )),0) 
                ELSE 0 END), 
        PNetRate = ( 
        CASE 
                WHEN sell_buy =1 
                THEN isnull(netrate + ( 
                CASE 
                        WHEN C.service_chrg = 1 
                        THEN isnull((f.service_tax/TradeQty),0) 
                        ELSE 0 END),0) 
                ELSE 0 END), 
        SNetRate = ( 
        CASE 
                WHEN sell_buy =2 
                THEN isnull(netrate - ( 
                CASE 
                        WHEN C.service_chrg = 1 
                        THEN isnull((f.service_tax/TradeQty),0) 
                        ELSE 0 END),0) 
                ELSE 0 END), 
        isnull(amount,0) amount , 
        inst_type= ( 
        CASE 
                WHEN f.auctionpart = 'EA' 
                THEN stuff(inst_type,1,3,'EA-') 
                ELSE inst_type END), 
        symbol, 
        pAmt=( 
        CASE 
                WHEN sell_buy = 1 
                THEN (tradeqty * netrate) + ( 
                CASE 
                        WHEN C.service_chrg = 1 
                        THEN isnull((f.service_tax),0) 
                        ELSE ( 
                        CASE 
                                WHEN C.service_chrg = 0 
                                THEN 0 
                                ELSE ( 
                                CASE 
                                        WHEN C.service_chrg = 2 
                                        THEN 0 
                                        ELSE 0 END) END ) END ) 
                ELSE 0 END), 
        sAmt=( 
        CASE 
                WHEN sell_buy = 2 
                THEN(tradeqty * netrate) - ( 
                CASE 
                        WHEN C.service_chrg = 1 
                        THEN isnull((f.service_tax),0) 
                        ELSE ( 
                        CASE 
                                WHEN C.service_chrg = 0 
                                THEN 0 
                                ELSE ( 
                                CASE 
                                        WHEN C.service_chrg = 2 
                                        THEN 0 
                                        ELSE 0 END ) END ) END) 
                ELSE 0 END), 
        LEFT(CONVERT(VARCHAR,expirydate,106),11) as expirydate, 
        f.party_code, 
        sell_buy, 
        contractno, 
        convert(varchar,sauda_date,103) as sauda_date, 
        isnull(strike_price,0) strike_price, 
        option_type, 
        pservice_Tax= ( 
        CASE 
                WHEN sell_buy = 1 
                THEN ( 
                CASE 
                        WHEN C.service_chrg=0 
                        THEN (f.service_tax) 
                        ELSE ( 
                        CASE 
                                WHEN C.service_chrg=1 
                                THEN 0 
                                ELSE ( 
                                CASE 
                                        WHEN C.service_chrg=2 
                                        THEN 0 END) END) END) 
                ELSE 0 END), 
        sservice_Tax= ( 
        CASE 
                WHEN sell_buy = 2 
                THEN ( 
                CASE 
                        WHEN C.service_chrg=0 
                        THEN (f.service_tax) 
                        ELSE ( 
                        CASE 
                                WHEN C.service_chrg=1 
                                THEN 0 
                                ELSE ( 
                                CASE 
                                        WHEN C.service_chrg=2 
                                        THEN 0 END) END) END) 
                ELSE 0 END), 
        yy          =year(sauda_date), 
        mm          =month(sauda_date), 
        dd          =day(sauda_date), 
        DFlag       = 1 , 
        Broker_Chrg = ( 
        CASE 
                WHEN BrokerNote = 1 
                THEN Broker_Chrg 
                ELSE 0 END ), 
        turn_tax = ( 
        CASE 
                WHEN Turnover_tax = 1 
                THEN turn_tax 
                ELSE 0 END), 
        sebi_tax = ( 
        CASE 
                WHEN Sebi_Turn_tax = 1 
                THEN sebi_tax 
                ELSE 0 END), 
        other_chrg = ( 
        CASE 
                WHEN C.Other_chrg = 1 
                THEN f.other_chrg 
                ELSE 0 END) , 
        Ins_Chrg = ( 
        CASE 
                WHEN Insurance_Chrg = 1 
                THEN Ins_chrg 
                ELSE 0 END ), 
        Service_Tax = ( 
        CASE 
                WHEN Service_chrg = 0 
                THEN Service_Tax 
                ELSE 0 END ), 
        NSerTax = ( 
        CASE 
                WHEN Service_chrg = 0 
                THEN Service_Tax
                ELSE 0 END ), 
        Brokerage = isnull(tradeqty*brokapplied,0), 
        C.Branch_cd , 
        C.Sub_broker, 
        C.Trader, 
        PRINTF,   
        C.service_chrg,   
        PARTYNAME=long_name, 
        L_ADDRESS1, 
        L_ADDRESS2, 
        L_ADDRESS3, 
        L_CITY, 
        L_ZIP, 
        PAN_GIR_NO, 
        OFF_PHONE1, 
        OFF_PHONE2,   
        MAPIDID,
	SEBI_NO
INTO    #CONTSETT 
FROM    #FOSETT f, 
        #CLIENTMASTER C 
WHERE   f.party_code     >= @FROMPARTY_CODE 
        AND f.party_code <= @TOPARTY_CODE 
        AND contractno BETWEEN ( 
        CASE 
                WHEN inst_type like 'opt%' 
                AND AuctionPart ='EA' 
                THEN 0 
                ELSE @FROMCONTRACTNO END) 
        AND @TOCONTRACTNO 
        AND f.party_code=C.party_code SELECT  ORDER_NO='0000000000000000', 
        ORDER_TIME      = '          ', 
        TRADE_NO        ='00000000000000', 
        tradetime       ='0000000000000', 
        PQTY            =SUM(PQTY), 
        SQTY            =SUM(SQTY), 
        PRATE           =( 
        CASE 
                WHEN SUM(PQTY) > 0 
                THEN SUM(PRATE*PQTY)/SUM(PQTY) 
                ELSE 0 END), 
        SRATE=( 
        CASE 
                WHEN SUM(SQTY) > 0 
                THEN SUM(SRATE*SQTY)/SUM(SQTY) 
                ELSE 0 END ), 
        PBROK=( 
        CASE 
                WHEN SUM(PQTY) > 0 
                THEN SUM(PBROK*PQTY)/SUM(PQTY) 
                ELSE 0 END ), 
        SBROK=( 
        CASE 
                WHEN SUM(SQTY) > 0 
                THEN SUM(SBROK*SQTY)/SUM(SQTY) 
                ELSE 0 END ), 
        PNETRATE=( 
        CASE 
                WHEN SUM(PQTY) > 0 
                THEN SUM(PNETRATE*PQTY)/SUM(PQTY) 
                ELSE 0 END ), 
        SNETRATE=( 
        CASE 
                WHEN SUM(SQTY) > 0 
                THEN SUM(SNETRATE*SQTY)/SUM(SQTY) 
                ELSE 0 END ), 
        amount=SUM(AMOUNT), 
        inst_type, 
        symbol, 
        PAMT=SUM(PAMT), 
        SAMT=SUM(sAmt), 
        expirydate, 
        party_code, 
        sell_buy, 
        contractno, 
        SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
        strike_price, 
        option_type, 
        Pservice_Tax=SUM(Pservice_Tax), 
        Sservice_Tax=SUM(Sservice_Tax), 
        yy, 
        mm, 
        dd, 
        DFlag, 
        BROKER_CHRG = SUM(BROKER_CHRG), 
        TURN_TAX    = SUM(TURN_TAX), 
        SEBI_TAX    = SUM(SEBI_TAX), 
        OTHER_CHRG  = SUM(OTHER_CHRG) , 
        INS_CHRG    = SUM(INS_CHRG), 
        SERVICE_TAX = SUM(SERVICE_TAX), 
        NSERTAX     = SUM(NSERTAX), 
        BROKERAGE   = SUM(BROKERAGE), 
        Branch_cd, 
        Sub_broker, 
        Trader, 
        PRINTF,   
        service_chrg,   
        PARTYNAME, 
        L_ADDRESS1, 
        L_ADDRESS2, 
        L_ADDRESS3, 
        L_CITY, 
        L_ZIP, 
        PAN_GIR_NO, 
        OFF_PHONE1, 
        OFF_PHONE2,   
        MAPIDID,
	SEBI_NO
INTO    #CONTSETTNEW 
FROM    #CONTSETT 
WHERE   PRINTF = '3' 
GROUP BY inst_type, 
        symbol, 
        expirydate, 
        party_code, 
        sell_buy, 
        contractno, 
        strike_price, 
        option_type, 
        LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
        yy, 
        mm, 
        dd, 
        DFlag, 
        Branch_cd, 
        Sub_broker, 
        Trader, 
        PRINTF,   
        service_chrg,   
        PARTYNAME, 
        L_ADDRESS1, 
        L_ADDRESS2, 
        L_ADDRESS3, 
        L_CITY, 
        L_ZIP, 
        PAN_GIR_NO, 
        OFF_PHONE1, 
        OFF_PHONE2,   
        MAPIDID,
	SEBI_NO
INSERT 
INTO    #CONTSETTNEW SELECT  * 
FROM    #CONTSETT 
WITH 
        ( 
                NOLOCK 
        ) 
WHERE   PRINTF <> '3' 
UPDATE #CONTSETTNEW 
        SET ORDER_NO = S.ORDER_NO, 
        ORDER_TIME   = S.ORDER_TIME, 
        tradetime    = S.tradetime, 
        TRADE_NO     = S.TRADE_NO 
FROM    #CONTSETT S 
WITH 
        ( 
                NOLOCK 
        ) 
WHERE   S.PRINTF           = #CONTSETTNEW.PRINTF 
        AND S.PRINTF       = '3' 
        AND S.PARTY_CODE   = #CONTSETTNEW.PARTY_CODE 
        AND S.INST_TYPE    = #CONTSETTNEW.INST_TYPE 
        AND S.SYMBOL       = #CONTSETTNEW.SYMBOL 
        AND S.EXPIRYDATE   = #CONTSETTNEW.EXPIRYDATE 
        AND S.OPTION_TYPE  = #CONTSETTNEW.OPTION_TYPE 
        AND S.STRIKE_PRICE = #CONTSETTNEW.STRIKE_PRICE 
        AND S.SELL_BUY     = #CONTSETTNEW.SELL_BUY 
        AND S.SAUDA_DATE   = 
        (SELECT MIN(SAUDA_DATE) 
        FROM    #CONTSETT ISETT 
        WITH 
                ( 
                        NOLOCK 
                ) 
        WHERE   PRINTF             = '3' 
                AND S.PARTY_CODE   = ISETT.PARTY_CODE 
                AND S.INST_TYPE    = ISETT.INST_TYPE 
                AND S.SYMBOL       = ISETT.SYMBOL 
                AND S.EXPIRYDATE   = ISETT.EXPIRYDATE 
                AND S.OPTION_TYPE  = ISETT.OPTION_TYPE 
                AND S.STRIKE_PRICE = ISETT.STRIKE_PRICE 
                AND S.SELL_BUY     = ISETT.SELL_BUY 
        ) 
        IF (@CONTFLAG = 'CONTRACT') BEGIN 
SELECT  ORDER_NO,
        ORDER_TIME,
        TRADE_NO,
        TM=tradetime,  
        PQTY,
        SQTY,  
        Rate = PRate + SRate,  
        PRATE,
        SRATE,  
        BROK=PBrok+SBrok,  
        PBROK,
        SBROK,  
        NETRATE = PNETRATE + SNETRATE,  
        PNETRATE,
        SNETRATE,  
        amount,
        inst_type,
        symbol,   
        AMT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN -PAMT 
                ELSE SAMT END), 
        PAMT, 
        SAMT, 
        AMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN -(PAMT+INS_CHRG) 
                ELSE (SAMT-INS_CHRG) END), 
        PAMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+INS_CHRG 
                ELSE 0 END), 
        SAMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-INS_CHRG 
                ELSE 0 END), 
        expirydate,
        party_code,
        sell_buy,
        contractno,
        SAUDA_DATE,
        SDT=SAUDA_DATE,
        strike_price,  
        option_type,
        Pservice_Tax,
        Sservice_Tax,
        yy,
        mm,
        dd,
        DFlag,
        BROKER_CHRG,
        TURN_TAX,
        SEBI_TAX,
        OTHER_CHRG,  
        PINS_CHRG=(
        CASE 
                WHEN Sell_Buy = 1 
                THEN Ins_Chrg 
                ELSE 0 END),  
        SINS_CHRG=(
        CASE 
                WHEN Sell_Buy = 2 
                THEN Ins_Chrg 
                ELSE 0 END),  
        INS_CHRG,
        SERVICE_TAX,
        NSERTAX,
        BROKERAGE,
        PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),
        SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),
        Branch_cd,
        Sub_broker,
        Trader,
        PRINTF,
        service_chrg,   
        PARTYNAME, 
        L_ADDRESS1, 
        L_ADDRESS2, 
        L_ADDRESS3, 
        L_CITY, 
        L_ZIP, 
	SEBI_NO,
        PAN_GIR_NO, 
        OFF_PHONE1, 
        OFF_PHONE2,   
        MAPIDID,  
        MARKETAMT  = (PRATE + SRATE) * (PQTY+SQTY), 
        PMARKETAMT = PRATE * PQTY , 
        SMARKETAMT = SRATE * SQTY , 
        Series     = '',
        TMARK      ='',  
        ScripName  = (
        CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END),   
        PScripName = (Case When Sell_Buy=1 Then (CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END)
		ELSE '' END),   
        SScripName = (Case When Sell_Buy=2 Then (CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END)
		ELSE '' END)   

FROM    #CONTSETTNEW 
WITH 
        ( 
                NOLOCK 
        ) 
WHERE   PRINTF <> 1 
ORDER BY BRANCH_CD, 
        SUB_BROKER, 
        TRADER, 
        PARTY_CODE, 
        INST_TYPE, 
        SYMBOL, 
        EXPIRYDATE, 
        OPTION_TYPE, 
        STRIKE_PRICE, 
        ORDER_NO, 
        TRADE_NO 
END 
ELSE BEGIN SELECT  ORDER_NO,
        ORDER_TIME,
        TRADE_NO,
        TM=tradetime,  
        PQTY,
        SQTY,  
        Rate = PRate + SRate,  
        PRATE,
        SRATE,  
        BROK=PBrok+SBrok,  
        PBROK,
        SBROK,  
        NETRATE = PNETRATE + SNETRATE,  
        PNETRATE,
        SNETRATE,  
        amount,
        inst_type,
        symbol,   
        AMT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN -PAMT 
                ELSE SAMT END), 
        PAMT, 
        SAMT, 
        AMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN -(PAMT+INS_CHRG) 
                ELSE (SAMT-INS_CHRG) END), 
        PAMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+INS_CHRG 
                ELSE 0 END), 
        SAMTSTT = ( 
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-INS_CHRG 
                ELSE 0 END), 
        expirydate,
        party_code,
        sell_buy,
        contractno,
        SAUDA_DATE,
        SDT=SAUDA_DATE,
        strike_price,  
        option_type,
        Pservice_Tax,
        Sservice_Tax,
        yy,
        mm,
        dd,
        DFlag,
        BROKER_CHRG,
        TURN_TAX,
        SEBI_TAX,
        OTHER_CHRG,  
        PINS_CHRG=(
        CASE 
                WHEN Sell_Buy = 1 
                THEN Ins_Chrg 
                ELSE 0 END),  
        SINS_CHRG=(
        CASE 
                WHEN Sell_Buy = 2 
                THEN Ins_Chrg 
                ELSE 0 END),  
        INS_CHRG,
        SERVICE_TAX,
        NSERTAX,
        BROKERAGE,
        PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),
        SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),
        Branch_cd,
        Sub_broker,
        Trader,
        PRINTF,
        service_chrg,   
        PARTYNAME, 
        L_ADDRESS1, 
        L_ADDRESS2, 
        L_ADDRESS3, 
        L_CITY, 
        L_ZIP, 
	SEBI_NO,
        PAN_GIR_NO, 
        OFF_PHONE1, 
        OFF_PHONE2,   
        MAPIDID,  
        MARKETAMT  = (PRATE + SRATE) * (PQTY+SQTY), 
        PMARKETAMT = PRATE * PQTY , 
        SMARKETAMT = SRATE * SQTY , 
        Series     = '',
        TMARK      ='',  
        ScripName  = (
        CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END), 
        PScripName = (Case When Sell_Buy=1 Then (CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END)
		ELSE '' END),   
        SScripName = (Case When Sell_Buy=2 Then (CASE 
                WHEN Inst_Type Like 'FUT%' 
                THEN RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11)     
                ELSE RTrim(inst_type) + ' ' + RTrim(symbol) + ' ' + Left(ExpiryDate,11) + ' ' + RTrim(Convert(Varchar,strike_Price)) + ' ' + RTrim(Option_Type)    
		END)
		ELSE '' END)   
FROM    #CONTSETTNEW 
WITH 
        ( 
                NOLOCK 
        ) 
ORDER BY BRANCH_CD, 
SUB_BROKER, 
        TRADER, 
        PARTY_CODE, 
        INST_TYPE, 
        SYMBOL, 
        EXPIRYDATE, 
        OPTION_TYPE, 
        STRIKE_PRICE, 
        ORDER_NO, 
        TRADE_NO 
END

GO

-- --------------------------------------------------
-- TABLE dbo.angel_ebrokTO_temp2
-- --------------------------------------------------
CREATE TABLE [dbo].[angel_ebrokTO_temp2]
(
    [Company] VARCHAR(6) NOT NULL,
    [mmonth] NVARCHAR(30) NULL,
    [Myear] NVARCHAR(30) NULL,
    [Turnover] MONEY NULL,
    [brokerage] MONEY NULL,
    [TO_Trd_Fut] MONEY NULL,
    [TO_Del_Opt] MONEY NULL,
    [BK_Trd_Fut] MONEY NULL,
    [BK_Del_Opt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANgel_nooftrades
-- --------------------------------------------------
CREATE TABLE [dbo].[ANgel_nooftrades]
(
    [tdate] DATETIME NULL,
    [NOOFTRADE] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANgel_nooftrades_a
-- --------------------------------------------------
CREATE TABLE [dbo].[ANgel_nooftrades_a]
(
    [tdate] DATETIME NULL,
    [NOOFTRADE] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.awsdms_truncation_safeguard
-- --------------------------------------------------
CREATE TABLE [dbo].[awsdms_truncation_safeguard]
(
    [latchTaskName] VARCHAR(128) NOT NULL,
    [latchMachineGUID] VARCHAR(40) NOT NULL,
    [LatchKey] CHAR(1) NOT NULL,
    [latchLocker] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.C_Multicompany
-- --------------------------------------------------
CREATE TABLE [dbo].[C_Multicompany]
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
    [Filler2] VARCHAR(10) NULL
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
-- TABLE dbo.DataIn_History_Fosettlement_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_NseCurFo]
(
    [Sauda_Date] VARCHAR(11) NOT NULL,
    [expirydate] SMALLDATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataIn_History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[DataIn_History_Fosettlement_Nsefo]
(
    [Sauda_Date] VARCHAR(11) NOT NULL,
    [expirydate] SMALLDATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FoaccBill_Uppili_DoNotDelete
-- --------------------------------------------------
CREATE TABLE [dbo].[FoaccBill_Uppili_DoNotDelete]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(12) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [BillDate] SMALLDATETIME NOT NULL,
    [Start_Date] SMALLDATETIME NOT NULL,
    [End_Date] SMALLDATETIME NOT NULL,
    [PayIn_Date] SMALLDATETIME NOT NULL,
    [PayOut_Date] SMALLDATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [expiryflag] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL,
    [Reserved3] INT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FONoOfTrades_a
-- --------------------------------------------------
CREATE TABLE [dbo].[FONoOfTrades_a]
(
    [tdate] DATETIME NULL,
    [NOOFTRADE] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOSETTLEMENT_MAY
-- --------------------------------------------------
CREATE TABLE [dbo].[FOSETTLEMENT_MAY]
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
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(16) NULL,
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
-- TABLE dbo.foturn
-- --------------------------------------------------
CREATE TABLE [dbo].[foturn]
(
    [User_ID] INT NOT NULL,
    [Turnover] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.foturn1
-- --------------------------------------------------
CREATE TABLE [dbo].[foturn1]
(
    [User_ID] INT NOT NULL,
    [Turnover] MONEY NULL
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
-- TABLE dbo.History_Foclosing_Billreport_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_Billreport_NseCurFo]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(2) NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_FoClosing_BillReport_nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoClosing_BillReport_nsefo]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(2) NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_Foclosing_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Foclosing_NseCurFo]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(2) NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_FoClosing_nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoClosing_nsefo]
(
    [Cl_Rate] MONEY NULL,
    [Expirydate] SMALLDATETIME NULL,
    [Trade_Date] SMALLDATETIME NULL,
    [Inst_Type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Strike_price] MONEY NULL,
    [Cor_Act_level] INT NULL,
    [MarketType] VARCHAR(2) NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History_FoexerciseAllocation_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoexerciseAllocation_NseCurFo]
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
-- TABLE dbo.History_FoExerciseAllocation_nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_FoExerciseAllocation_nsefo]
(
    [foea_table_no] INT NULL,
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
-- TABLE dbo.History_Fosettlement_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_NseCurFo]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(20) NULL,
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
    [Instrument] INT NULL,
    [BookType] VARCHAR(5) NULL,
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
-- TABLE dbo.History_Fosettlement_Nsefo
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_Nsefo]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(30) NULL,
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
    [Order_no] VARCHAR(16) NULL,
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
-- TABLE dbo.History_Fosettlement_Nsefo_BKUP_26_to_30JUN2027
-- --------------------------------------------------
CREATE TABLE [dbo].[History_Fosettlement_Nsefo_BKUP_26_to_30JUN2027]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(30) NULL,
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
    [Order_no] VARCHAR(16) NULL,
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
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_NSECURFO
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_NSECURFO]
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
-- TABLE dbo.HISTORY_TBL_CLIENTMARGIN_NSEFO_20122011_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_CLIENTMARGIN_NSEFO_20122011_DATA]
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
-- TABLE dbo.HISTORY_TBL_MTOMPREMIUMBILL
-- --------------------------------------------------
CREATE TABLE [dbo].[HISTORY_TBL_MTOMPREMIUMBILL]
(
    [billdate] SMALLDATETIME NULL,
    [pqty] INT NULL,
    [sqty] INT NULL,
    [netrate] MONEY NULL,
    [cl_rate] MONEY NULL,
    [party_code] VARCHAR(10) NULL,
    [inst_type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expirydate] SMALLDATETIME NULL,
    [sdate] SMALLDATETIME NULL,
    [sell_buy] INT NULL,
    [service_tax] MONEY NULL,
    [brok] MONEY NULL,
    [nonexpiryservice_tax] MONEY NULL,
    [nonexpirybrok] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [stampduty] MONEY NULL,
    [inex_service_tax] MONEY NULL,
    [inex_sebi_tax] MONEY NULL,
    [inex_turn_tax] MONEY NULL,
    [inex_stampduty] MONEY NULL,
    [expirybrok] MONEY NULL,
    [expiryservice_tax] MONEY NULL,
    [insurance_chrg] MONEY NULL,
    [inex_insurance_chrg] MONEY NULL,
    [other_chrg] MONEY NULL,
    [inex_other_chrg] MONEY NULL,
    [auctionpart] VARCHAR(2) NULL,
    [option_type] VARCHAR(2) NULL,
    [strike_price] MONEY NULL,
    [netwithbrok] MONEY NULL,
    [bfdayflag] VARCHAR(3) NULL,
    [reserved1] INT NULL,
    [actbuyqty] INT NULL,
    [actsellqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MultiCompany
-- --------------------------------------------------
CREATE TABLE [dbo].[MultiCompany]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [SEGMENT_DESCRIPTION] VARCHAR(50) NULL,
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
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL
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
    [APPSHARE_ROOTFLDR_NAME] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.multicompany_BKP_20220404
-- --------------------------------------------------
CREATE TABLE [dbo].[multicompany_BKP_20220404]
(
    [BrokerId] VARCHAR(6) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [SEGMENT_DESCRIPTION] VARCHAR(50) NULL,
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
    [License] VARCHAR(500) NULL,
    [AppShare_RootFldr_Name] VARCHAR(20) NULL
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
-- TABLE dbo.PRATHAM_NseCurFo
-- --------------------------------------------------
CREATE TABLE [dbo].[PRATHAM_NseCurFo]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [TRADECOUNT_NseCurFo] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PRATHAM_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[PRATHAM_NSEFO]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [TRADECOUNT_NSEFO] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_trd_FNO_omnesys
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_trd_FNO_omnesys]
(
    [sauda_date] DATETIME NOT NULL,
    [USER_ID] INT NOT NULL,
    [order_no] VARCHAR(16) NULL,
    [trade_no] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_trd_FNO_omnesys_a
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_trd_FNO_omnesys_a]
(
    [sauda_date] DATETIME NOT NULL,
    [USER_ID] INT NOT NULL,
    [order_no] VARCHAR(16) NULL,
    [trade_no] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_trd_NSECUR_omnesys
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_trd_NSECUR_omnesys]
(
    [sauda_date] DATETIME NOT NULL,
    [USER_ID] VARCHAR(15) NULL,
    [order_no] VARCHAR(16) NULL,
    [trade_no] VARCHAR(20) NULL
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
-- TABLE dbo.sauda_date
-- --------------------------------------------------
CREATE TABLE [dbo].[sauda_date]
(
    [RowNumber] INT IDENTITY(0,1) NOT NULL,
    [EventClass] INT NULL,
    [TextData] NTEXT NULL,
    [DatabaseID] INT NULL,
    [DatabaseName] NVARCHAR(128) NULL,
    [ObjectID] INT NULL,
    [ObjectName] NVARCHAR(128) NULL,
    [ServerName] NVARCHAR(128) NULL,
    [BinaryData] IMAGE NULL,
    [SPID] INT NULL,
    [StartTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sauda_trace
-- --------------------------------------------------
CREATE TABLE [dbo].[sauda_trace]
(
    [RowNumber] INT IDENTITY(0,1) NOT NULL,
    [EventClass] INT NULL,
    [TextData] NTEXT NULL,
    [DatabaseID] INT NULL,
    [DatabaseName] NVARCHAR(128) NULL,
    [ServerName] NVARCHAR(128) NULL,
    [SPID] INT NULL,
    [StartTime] DATETIME NULL,
    [BinaryData] IMAGE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sinu
-- --------------------------------------------------
CREATE TABLE [dbo].[sinu]
(
    [BrokerId] VARCHAR(12) NULL,
    [CompanyName] VARCHAR(100) NULL,
    [Exchange] NVARCHAR(3) NOT NULL,
    [Segment] VARCHAR(40) NULL,
    [MemberType] NVARCHAR(3) NOT NULL,
    [MemberCode] VARCHAR(30) NULL,
    [ShareDb] NVARCHAR(20) NOT NULL,
    [ShareServer] VARCHAR(40) NULL,
    [ShareIP] NVARCHAR(15) NULL,
    [AccountDb] NVARCHAR(20) NOT NULL,
    [AccountServer] VARCHAR(40) NULL,
    [AccountIP] NVARCHAR(15) NULL,
    [DefaultDb] NVARCHAR(20) NOT NULL,
    [DefaultDbServer] VARCHAR(40) NULL,
    [DefaultDbIP] NVARCHAR(10) NULL,
    [DefaultClient] INT NULL,
    [PANGIR_No] VARCHAR(30) NULL,
    [Filler1] NVARCHAR(10) NULL,
    [Filler2] NVARCHAR(10) NULL
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
-- TABLE dbo.Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp]
(
    [Sauda_Date] VARCHAR(11) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Buy] INT NULL,
    [Sell] INT NULL,
    [Pamt] MONEY NULL,
    [Samt] MONEY NULL
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
-- VIEW dbo.AIAAS_ExEmpActiveLogin
-- --------------------------------------------------
Create View AIAAS_ExEmpActiveLogin
as
select emp_no,Emp_name,designation,CostCode,separationdate,CategoryDesc,Department,Sr_Name from
(select * from AIAAS_UserInfo where active='Yes') a,
(Select * from intranet.risk.dbo.emp_info with (nolock) where status <> 'A') b
where fldusername=b.emp_no

GO

-- --------------------------------------------------
-- VIEW dbo.AIAAS_UserInfo
-- --------------------------------------------------
CREATE View AIAAS_UserInfo
as
select a.fldauto,fldusername,Active=
(Case 
when isnull(b.fldstatus,9)=0 then 'Yes' 
when isnull(b.fldstatus,9)=1 then 'No' 
else 'Missing' end)
from nsefo.dbo.tblpradnyausers a with (nolock) left outer join nsefo.dbo.tblUserControlMaster b with (nolock)
on a.fldauto=b.flduserid

GO

-- --------------------------------------------------
-- VIEW dbo.CLS_OWNER_VW
-- --------------------------------------------------


    
CREATE VIEW [dbo].[CLS_OWNER_VW] AS   
----SELECT 'NSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM MSAJAG.DBO.OWNER   
----UNION ALL   
--SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB_ab.DBO.OWNER   
----UNION ALL   
----SELECT 'BSE' AS EXCHANGE ,'CAPITAL' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL='',WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME='',COMPLIANCE_EMAIL='',COMPLIANCE_PHONE='',COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEDB.DBO.OWNER   
--UNION ALL   
SELECT 'NSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,PANNO,COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NSEFO.DBO.FOOWNER   
--UNION ALL   
--SELECT 'BSE' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM BSEFO.DBO.bfoowner   --select *from  CLS_OWNER_VW       
--UNION ALL 
--SELECT 'NCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
--UNION ALL   
--SELECT 'MCX' AS EXCHANGE ,'FUTURES' AS SEGMENT,COMPANY, ADDR1, ADDR2, ADDR3='', CITY, STATE,COUNTRY = '',ZIP,PHONE,FAX='',EMAIL,WEBSITE_ID='',MEMBERCODE,BROKERSEBIREGNO,'',COMPLIANCE_NAME,COMPLIANCE_EMAIL,COMPLIANCE_PHONE,COMMONSEBINO='',COMMONMEMBERCODE='' FROM NCDX.DBO.NCXowner   --select *from  CLS_  
  
--OWNER_VW

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

-- --------------------------------------------------
-- VIEW dbo.MULTICOMPANY_ALL
-- --------------------------------------------------
CREATE VIEW [DBO].[MULTICOMPANY_ALL] AS  
SELECT * FROM MULTICOMPANY_ADDITIONAL

GO

