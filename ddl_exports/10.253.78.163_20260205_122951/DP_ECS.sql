-- DDL Export
-- Server: 10.253.78.163
-- Database: DP_ECS
-- Exported: 2026-02-05T12:29:54.763284

USE DP_ECS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_GET_MAX_OF_STRING
-- --------------------------------------------------
/*******************************************************************

CREATED DATE :: 03 AUG 2011
PURPOSE :: USE TO GET MAX VALUE IN PROVIDED 
			ARRAYS 

*******************************************************************/

CREATE FUNCTION [dbo].[FUN_GET_MAX_OF_STRING]
(
	@DELIMITER VARCHAR(5), 
	@LIST VARCHAR(MAX)
)

RETURNS NUMERIC(18,5)	

AS
BEGIN
	
	DECLARE @MAX_VAL NUMERIC(18,5)	
		
	DECLARE @TABLE TABLE 
	( 
		VALUE NUMERIC(18,5)
	)
	   
	INSERT INTO @TABLE (VALUE) 
	SELECT CONVERT(NUMERIC(18,5),VALUE) 
	FROM DBO.SPLIT(@DELIMITER,@LIST)

	SET @MAX_VAL = (SELECT MAX_VALUE = MAX(VALUE) FROM @TABLE)
	
	RETURN @MAX_VAL
	
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.getlastdate
-- --------------------------------------------------
Create function [dbo].[getlastdate](@mmonth int, @myear int)  
RETURNs Datetime  
As  
Begin  
--set @mmonth =  2  
--set @myear  = 2007  
declare @tdate as datetime  
select @tdate=convert(datetime,convert(varchar(2),case when @mmonth < 12 then @mmonth+1 else 1 end)+'/01/'+convert(varchar(4),  
case when @mmonth < 12 then @myear else @myear+1 end))-1  
Return @tdate  
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.RemoveNonAlphaCharacters
-- --------------------------------------------------
Create Function [dbo].[RemoveNonAlphaCharacters](@Temp VarChar(max))  
Returns VarChar(max)  
AS  
Begin  
  
    While PatIndex('%[^a-z]%', @Temp) > 0  
        Set @Temp = Stuff(@Temp, PatIndex('%[^a-z]%', @Temp), 1, '')  
  
    Return @TEmp  
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.Removenonnumeric
-- --------------------------------------------------
CREATE Function [dbo].[Removenonnumeric]  
(  
 @Temp Varchar(max)  
)  
Returns Varchar(max)  
As  
Begin  
   While Patindex('%[^0-9]%', @Temp) > 0  
  Set @Temp = Stuff(@Temp, Patindex('%[^0-9]%', @Temp), 1, '')  
  
   If (Left(@TEmp, 1) = 9)  
      And (Len(@TEmp) = 11)  
   Begin  
      Set @TEmp=Right(@TEmp, 10)  
   End  
  
   If (Left(@TEmp, 2) = '00')  
   Begin  
      If Len(@TEmp) > 2  
      Begin  
         Set @TEmp=Right(@TEmp, Len(@TEmp) - 2)  
      End  
   End  
  
   If (Left(@TEmp, 1) = '0')  
   Begin  
      If Len(@TEmp) > 1  
      Begin  
         Set @TEmp=Right(@TEmp, Len(@TEmp) - 1)  
      End  
   End  
  
   Return @TEmp  
  
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.REMOVESPECIALCHARS
-- --------------------------------------------------
/**************************************************************************************

CREATED BY :: SOURCE (CHRISTIAN D'HEUREUSE, WWW.SOURCE-CODE.BIZ)
CREATED DATE :: 27 AUG 2011
PURPOSE :: REMOVES SPECIAL CHARACTERS FROM A STRING VALUE.
            ALL CHARACTERS EXCEPT 0-9, A-Z AND A-Z ARE REMOVED AND


MODIFIED BY ::
MODIFIED DATE ::
MODIFIED REASON ::

***************************************************************************************/

CREATE FUNCTION [dbo].[REMOVESPECIALCHARS] 
(
    @INPUT_STRING VARCHAR(256)
) 
RETURNS VARCHAR(1000)

WITH SCHEMABINDING

BEGIN

    IF @INPUT_STRING IS NULL
    RETURN NULL

    DECLARE @INPUT_STRING2 VARCHAR(256)
    DECLARE @LENGTH INT
    DECLARE @P INT

    SET @INPUT_STRING2 = ''
    SET @LENGTH = LEN(@INPUT_STRING)
    SET @P = 1

    WHILE @P <= @LENGTH 
    BEGIN
    
        DECLARE @C INT
        SET @C = ASCII(SUBSTRING(@INPUT_STRING, @P, 1))

        IF @C BETWEEN 48 AND 57 OR @C BETWEEN 65 AND 90 OR @C BETWEEN 97 AND 122
            SET @INPUT_STRING2 = @INPUT_STRING2 + CHAR(@C)
            SET @P = @P + 1
    END

    IF LEN(@INPUT_STRING2) = 0
    BEGIN	
        RETURN NULL
    END

    RETURN @INPUT_STRING2
    
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.SPLIT
-- --------------------------------------------------
/*******************************************************************

CREATED DATE :: 03 AUG 2011
PURPOSE :: USE TO SPLIT INPUT ARRAY WHICH 
			RETURNS TEMP TABLE 
			INCLUDES IDENTITY AND REQUIRED VALUE

*******************************************************************/

CREATE FUNCTION [dbo].[SPLIT]
(  
	@DELIMITER VARCHAR(5), 
	@LIST VARCHAR(MAX)
) 
RETURNS @TABLEOFVALUES TABLE 
(  
	ROWID SMALLINT IDENTITY(1,1), 
	[VALUE] VARCHAR(50) 
) 

AS 
   BEGIN
    
      DECLARE @LENSTRING INT 
 
      WHILE LEN( @LIST ) > 0 
         BEGIN 
         
            SELECT @LENSTRING = 
               (CASE CHARINDEX( @DELIMITER, @LIST ) 
                   WHEN 0 THEN LEN( @LIST ) 
                   ELSE ( CHARINDEX( @DELIMITER, @LIST ) -1 )
                END
               ) 
                                
            INSERT INTO @TABLEOFVALUES 
               SELECT SUBSTRING( @LIST, 1, @LENSTRING )
                
            SELECT @LIST = 
               (CASE ( LEN( @LIST ) - @LENSTRING ) 
                   WHEN 0 THEN '' 
                   ELSE RIGHT( @LIST, LEN( @LIST ) - @LENSTRING - 1 ) 
                END
               ) 
         END
          
      RETURN 
      
   END

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_DEACTIVE_PROCESS_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_DEACTIVE_PROCESS_LOG] ADD CONSTRAINT [PK__TBL_ECS_DEACTIVE__7F60ED59] PRIMARY KEY ([SR_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_EXCEED_TRAN_LIMIT
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_EXCEED_TRAN_LIMIT] ADD CONSTRAINT [PK__TBL_ECS_EXCEED_T__0CBAE877] PRIMARY KEY ([DP_ID], [MONTH], [YEAR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_GEN_PROCESS_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_GEN_PROCESS_LOG] ADD CONSTRAINT [PK__TBL_ECS_GEN_PROC__7C8480AE] PRIMARY KEY ([SR_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_REG_MASTER_RENAMED_PII
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_REG_MASTER_RENAMED_PII] ADD CONSTRAINT [PK__TBL_ECS_REG_MAST__07020F21] PRIMARY KEY ([DP_ID], [ECS_STATUS])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_TRAN_FILE_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_TRAN_FILE_LOG] ADD CONSTRAINT [PK__TBL_ECS_TRAN_FIL__014935CB] PRIMARY KEY ([SR_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_TRAN_PROCESS_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_TRAN_PROCESS_LOG] ADD CONSTRAINT [PK__TBL_ECS_TRAN_PRO__03317E3D] PRIMARY KEY ([SR_NO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ECS_TRANSACTION
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ECS_TRANSACTION] ADD CONSTRAINT [PK_TBL_ECS_TRANSACTION] PRIMARY KEY ([DP_ID], [MONTH], [YEAR])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHK_ECS_GEN_PROCESS_STATUS
-- --------------------------------------------------
/***********************************************************************************    
CREATED BY :: RUTVIJ PATIL    
CREATED DATE :: 25 JULY 2011    
PURPOSE :: USED TO CHECK WHETHER THE PROCESS IS DONE BEFORE    
    
MODIFIED BY ::    
MODIFIED DATE ::    
REASON ::    
***********************************************************************************/    
    
CREATE PROCEDURE [dbo].[CHK_ECS_GEN_PROCESS_STATUS]    
  
    @TYPE VARCHAR(10)  
      
AS    
BEGIN    
  
    IF(@TYPE = 'DEACTIVE')  
    BEGIN  
        SELECT [COUNT] = COUNT(*)     
        FROM TBL_ECS_REG_MASTER    
        WHERE REQ_STATUS = -1 AND ECS_STATUS = 'D'  
    END  
      
    IF(@TYPE = 'PENDING')  
    BEGIN  
        SELECT [COUNT] = COUNT(*)     
        FROM TBL_ECS_REG_MASTER    
        WHERE REQ_STATUS = -1  AND ECS_STATUS = 'P'  
    END  
    
END

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
-- PROCEDURE dbo.Sp_SysObj
-- --------------------------------------------------
/*  
Author :- Prashant  
Date :- 28/01/2011  
*/  
CREATE Procedure Sp_SysObj  
(  
 @objName as varchar(20),  
 @objType as varchar(3)=''  
)  
as  
Begin  
 select * from sysobjects where name like '%'+@objName+'%' and type like '%'+@objType+'%'--'%batch%'  
 order by name,type  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BRANCH_UPDATE_ECS_REG_MASTER
-- --------------------------------------------------
/******************************************************************************      
      
CREATED BY :: RUTVIJ PATIL      
CREATED DATE :: 04 SEPT 2011      
PURPOSE :: TO UPDATE VALUES INTO TBL_ECS_REG_MASTER FROM MASTER ENTRY PAGE      
            WHICH IS ACCESSIBLE TO BRACH LEVEL
      
MODIFIED BY ::       
MODIFIED DATE ::      
PURPOSE ::      
      
*******************************************************************************/      
      
CREATE PROCEDURE [dbo].[USP_BRANCH_UPDATE_ECS_REG_MASTER]      
      
    @PARTY_CODE VARCHAR(15),      
    @PARTY_NAME VARCHAR(100),      
    @DP_ID VARCHAR(16),      
    @MICR_CODE VARCHAR(24),      
    @BANK_NAME VARCHAR(100),      
    @BANK_ACCNO VARCHAR(20),      
    @BANK_ACC_TYPE VARCHAR(11),      
    @ECS_FORM_IMAGE VARBINARY(MAX),      
    @ECS_UPPER_LIMIT MONEY,      
    @CSO_RECEIVED_DATE DATETIME,      
    @ECS_EXPIRY_DATE DATETIME,      
    @SCHEME_NAME VARCHAR(20),      
    @PERIODICITY VARCHAR(20),      
    @ECS_STATUS VARCHAR(3),      
    @ENTERED_BY VARCHAR(20),  
    @ECS_CHEQUE_IMAGE VARBINARY(MAX)  
      
AS      
BEGIN      
          
    UPDATE TBL_ECS_REG_MASTER
    SET PARTY_NAME = @PARTY_NAME ,      
        MICR_CODE = @MICR_CODE,      
        BANK_NAME = @BANK_NAME,      
        BANK_ACCNO = @BANK_ACCNO,      
        BANK_ACC_TYPE = @BANK_ACC_TYPE,      
        ECS_FORM_IMAGE = @ECS_FORM_IMAGE,      
        ECS_UPPER_LIMIT = @ECS_UPPER_LIMIT,      
        CSO_RECEIVED_DATE = @CSO_RECEIVED_DATE,      
        ECS_EXPIRY_DATE = @ECS_EXPIRY_DATE,      
        SCHEME_NAME = @SCHEME_NAME,      
        PERIODICITY = @PERIODICITY,      
        ECS_STATUS = 'BE',
        ENTERED_BY = @ENTERED_BY,      
        ENTERED_DATE = GETDATE(),      
        REQ_STATUS = 0,
        ECS_CHEQUE_IMAGE = @ECS_CHEQUE_IMAGE
    WHERE PARTY_CODE = @PARTY_CODE AND DP_ID = @DP_ID AND ECS_STATUS = @ECS_STATUS
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CHECK_CLIENT_EXISTS
-- --------------------------------------------------
/******************************************************************************************                                        
                                        
CREATED BY :: RUTVIJ PATIL                                        
CREATED DATE :: 21 JULY 2011                                        
PURPOSE :: USE TO VALIDATE ENTER CLIENT CODE                                      
                                        
MODIFIED BY ::                                        
MODIFIED DATE ::                                        
PURPOSE ::                                        
                                        
*******************************************************************************************/        
        
--USP_CHECK_CLIENT_EXISTS '98RP61','BROKER','CSO'        
      
CREATE PROCEDURE [dbo].[USP_CHECK_CLIENT_EXISTS]        
            
    @PARTY_CODE VARCHAR(10),        
    @ACCESS_TO VARCHAR(25),        
    @ACCESS_CODE  VARCHAR(25)        
            
AS        
BEGIN        
        
    DECLARE @STR_SQL VARCHAR(1000)        
    DECLARE @STR_CONDITION VARCHAR(1000)        
            
    SET @STR_SQL = ''        
    SET @STR_CONDITION = ''        
            
    SET @ACCESS_TO = LTRIM(RTRIM(@ACCESS_TO))        
    SET @ACCESS_CODE = LTRIM(RTRIM(@ACCESS_CODE))        
            
    IF @ACCESS_TO='SB'                                                         
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.SB = '''+@ACCESS_CODE+''''                                                                                                                       
                                
    ELSE IF @ACCESS_TO='ZONE'                                                         
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.ZONE ='''+@ACCESS_CODE+''''                                                    
            
    ELSE IF @ACCESS_TO='SBMAST'                                                         
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.SB IN (SELECT DISTINCT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'                                                    
                                
    ELSE IF @ACCESS_TO = 'REGION'                                                                                                                 
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.REGION = '''+@ACCESS_CODE+''''                                             
                                
    ELSE IF @ACCESS_TO='BRANCH'                                        
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH = '''+@ACCESS_CODE+''''                                                                                   
                                
    ELSE IF @ACCESS_TO = 'BRMAST'                                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                  
                                
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                
    SET @STR_CONDITION =  @STR_CONDITION + ' '         
            
    SET @STR_SQL = @STR_SQL +         
    'SELECT * FROM INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CV
    WHERE CLIENT = ''' + @PARTY_CODE + '''' + @STR_CONDITION        
            
    PRINT @STR_SQL        
    EXECUTE(@STR_SQL)        
            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CHECK_ECS_TRAN_PROCESS
-- --------------------------------------------------
/*******************************************************************************************                                            
                                            
CREATED BY :: RUTVIJ PATIL                                            
CREATED DATE :: 26 JULY 2011                                            
PURPOSE :: USE TO CHECK WHETHER TRANSACTION PROCESS IS DONE OR NOT
                                            
MODIFIED BY ::                                            
MODIFIED DATE ::                                            
PURPOSE ::                                            
                                            
*******************************************************************************************/ 

CREATE PROCEDURE [dbo].[USP_CHECK_ECS_TRAN_PROCESS]

    @YEAR NUMERIC(4),
    @MONTH INT,
    @TYPE VARCHAR(10)

AS

BEGIN

    IF(@TYPE = 'GENERATED')
    BEGIN
        SELECT [COUNT] = COUNT(*)
        FROM TBL_ECS_TRANSACTION
        WHERE [YEAR] = @YEAR AND [MONTH] = @MONTH --AND REQ_STATUS = 0
    END

    IF(@TYPE = 'NOT-GENERATED')
    BEGIN
        SELECT [COUNT] = COUNT(*)
        FROM TBL_ECS_TRANSACTION
        WHERE [YEAR] = @YEAR AND [MONTH] = @MONTH 
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_DEACTIVE_PROCESS
-- --------------------------------------------------
/***********************************************************************************                
CREATED BY :: RUTVIJ PATIL                
CREATED DATE :: 25 JULY 2011                
PURPOSE :: USED TO DO REGISTRATION PROCESS                
                
MODIFIED BY ::                
MODIFIED DATE ::                
REASON ::                
***********************************************************************************/                
                
CREATE PROCEDURE [dbo].[USP_ECS_DEACTIVE_PROCESS]                
                
AS                
BEGIN                
                
    BEGIN TRAN                
                    
    SELECT [CLIENT DP ID] = SUBSTRING(TM.DP_ID,1,16),                
        [BANK A/C HOLDER NAME] = SUBSTRING(CM.FIRST_HOLD_NAME,1,100),                
        [BANK ACCOUNT NUMBER] = SUBSTRING(TM.BANK_ACCNO,1,20)            
    INTO #TEMP                
    FROM DBO.TBL_ECS_REG_MASTER TM                
        INNER JOIN [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER CM ON TM.DP_ID = CM.CLIENT_CODE                   
    WHERE TM.REQ_STATUS IN (0,1) AND TM.ECS_STATUS = 'D'            
        
            
    UPDATE TM                
    --SET TM.REQ_STATUS = -1                
    SET TM.REQ_STATUS = -2      
    FROM DBO.TBL_ECS_REG_MASTER TM                
        INNER JOIN #TEMP T ON  TM.DP_ID = T.[CLIENT DP ID] AND TM.REQ_STATUS IN (0,1) AND TM.ECS_STATUS = 'D'             
                      
    SELECT CNT = COUNT(*) FROM #TEMP              
                        
    IF(@@ERROR = 0)          
    BEGIN                      
        COMMIT TRAN               
    END              
          
    ELSE          
    BEGIN          
        ROLLBACK TRAN              
    END                
                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_DEC_FILE_GENERATION
-- --------------------------------------------------
/***********************************************************************************                
CREATED BY :: RUTVIJ PATIL                
CREATED DATE :: 25 JULY 2011                
PURPOSE :: USED TO DO DEACTIVE FILE GENERATION               
                
MODIFIED BY ::                
MODIFIED DATE ::                
REASON ::                
***********************************************************************************/                
                
--DBO.USP_ECS_DEC_FILE_GENERATION 'e32742'              
                
CREATE PROCEDURE [dbo].[USP_ECS_DEC_FILE_GENERATION]              
                
    @USERNAME VARCHAR(20)                
                
AS                
BEGIN                
                
    BEGIN TRAN                
                    
    DECLARE @LOT_NO INT                
    DECLARE @FILE_NAME VARCHAR(25)                
            
    SET @FILE_NAME  = 'ANGEDEAC' + (SELECT REPLACE(CONVERT(VARCHAR(8), GETDATE(), 5),'-',''))          
          
    SET @LOT_NO = (                
                    SELECT ISNULL(MAX(LOT_NO)+ 1,1)                 
                    FROM TBL_ECS_GEN_PROCESS_LOG                 
                    WHERE CONVERT(VARCHAR(11),PROCESSED_DATE) = CONVERT(VARCHAR(11),GETDATE())                
                   )                
            
    /****************************************************************************************              
        GETTING ALL THE CLIENTS WHO ARE ALREADY PROCESSED              
    ****************************************************************************************/               
                  
    SELECT                 
        [Client DP ID] = SUBSTRING(TM.DP_ID,1,16),                
        [Bank A/c Holder name] = SUBSTRING(CM.FIRST_HOLD_NAME,1,40),                
        [Bank Account Number] = SUBSTRING(TM.BANK_ACCNO,1,18)               
    INTO #TEMP                
    FROM DBO.TBL_ECS_REG_MASTER TM                
        INNER JOIN [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER CM ON TM.DP_ID = CM.CLIENT_CODE           
    --WHERE REQ_STATUS = -1 AND ECS_STATUS = 'D'          
    WHERE REQ_STATUS = -2 AND ECS_STATUS = 'D'  
            
    /****************************************************************************************              
        UPDATING STATUS              
    ****************************************************************************************/               
                  
    IF((SELECT COUNT(*) FROM #TEMP) > 0)              
                  
    BEGIN              
                  
        UPDATE TM                
        SET TM.REQ_STATUS = 2,                
            TM.UPDATED_BY = @USERNAME                
        FROM DBO.TBL_ECS_REG_MASTER TM                
            --INNER JOIN #TEMP T ON  TM.DP_ID = T.[CLIENT DP ID] AND TM.REQ_STATUS = -1 AND TM.ECS_STATUS = 'D'                
            INNER JOIN #TEMP T ON  TM.DP_ID = T.[CLIENT DP ID] AND TM.REQ_STATUS = -2 AND TM.ECS_STATUS = 'D'  
                        
        INSERT INTO TBL_ECS_DEACTIVE_PROCESS_LOG                
        VALUES(@FILE_NAME,@LOT_NO,@USERNAME,GETDATE())               
                      
        /****************************************************************************************              
            GETTING FINAL DATA FOR FILE EXECUTION              
        ****************************************************************************************/               
                      
        SELECT [Client DP ID] = SUBSTRING([Client DP ID],1,16),                
            [Bank A/c Holder name] = SUBSTRING([Bank A/c Holder name],1,40),                
            [Bank Account Number] = SUBSTRING([Bank Account Number],1,18)                
        FROM #TEMP               
                      
        SELECT [ECS_FILE_NAME] = @FILE_NAME              
                  
    END              
                    
    IF(@@ERROR = 0)      
    BEGIN                  
        COMMIT TRAN           
    END         
    ELSE      
    BEGIN      
        ROLLBACK TRAN          
    END               
                    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_GEN_REVERSE_REJ_FILE
-- --------------------------------------------------
/*******************************************************************************************        
        
CREATE BY :: RUTVIJ PATIL        
CREATED DATE :: 28 JULY 2011        
PURPOSE :: USE TO GENERATE ECS DEBIT REJECTION REVERSE FILE        
        
MODIFIED BY ::        
MODIFIED DATE ::        
PURPOSE ::        
        
********************************************************************************************/        
        
CREATE PROCEDURE [dbo].[USP_ECS_GEN_REVERSE_REJ_FILE]        
        
AS        
BEGIN        
        
        
    DECLARE @MAX_DATE DATETIME        
    DECLARE @DATE VARCHAR(15)        
    DECLARE @COUNT INT         
    DECLARE @FILE_NAME VARCHAR(50)        
    DECLARE @HEADER  VARCHAR(200)        
        
    SET @DATE = (SELECT REPLACE(CONVERT(VARCHAR(10), GETDATE(), 120),'-',''))        
        
    SET @MAX_DATE = (         
                    SELECT MAX(UPDATED_DATE)        
                    FROM TBL_ECS_TRAN_RESPONSE        
                )         
                        
    SELECT --ID= IDENTITY(INT,1,1),        
        ID= 1,    
        TR.DP_ID,        
        --BENF_ID = REPLACE(TR.DP_ID,'12033200',''),         
        BENF_ID = '12033200',    
        CODE = 'G68',        
        TYPE = 'D',        
        AMOUNT = CONVERT(NUMERIC(18,2),TR.AMOUNT),        
        DATE = @DATE,        
        -- NARRATION = 'ECS FUNDS TRANSFER REJECTED BY THE CLIENTS BANK HENCE REVERSED THE CREDIT ENTRY '+ TR.REF_NO        
        NARRATION = 'Being amt reversed for ' + REPLACE(TR.DP_ID,'12033200','') + ' against DP charges for ECS rejection'        
    INTO #TEMP        
    FROM TBL_ECS_TRAN_RESPONSE TR        
        INNER JOIN TBL_ECS_TRANSACTION T ON TR.DP_ID = T.DP_ID AND TR.REF_NO = T.REF_NO        
    WHERE TR.UPDATED_DATE = @MAX_DATE AND T.TRAN_STATUS = 'F'         
        
    SET @COUNT = (SELECT COUNT(*) FROM #TEMP)        
            
    IF(@COUNT > 0)        
    BEGIN        
            
        SET @HEADER = (SELECT '1~' + CONVERT(VARCHAR,@COUNT) +  '~' + @DATE + '~VIJAYU   ~')        
        SET @FILE_NAME = (SELECT REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19),GETDATE(),120),'-',''),' ',''),':','') + '_ECSREVERSE.TXT')        
                
        SELECT [FILE_NAME]= @FILE_NAME        
        SELECT [FILE HEADER] = @HEADER        
        SELECT * FROM #TEMP ORDER BY ID        
            
    END        
        
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_REG_FILE_GENERATION
-- --------------------------------------------------
/***********************************************************************************              
CREATED BY :: RUTVIJ PATIL              
CREATED DATE :: 25 JULY 2011              
PURPOSE :: USED TO DO REGISTRATION PROCESS              
              
MODIFIED BY ::              
MODIFIED DATE ::              
REASON ::              
***********************************************************************************/              
              
--DBO.USP_ECS_REG_FILE_GENERATION 'e32742'            
    
CREATE PROCEDURE [dbo].[USP_ECS_REG_FILE_GENERATION]            
              
    @USERNAME VARCHAR(20)              
              
AS              
    
BEGIN              
              
        BEGIN TRAN              
                  
        DECLARE @LOT_NO INT              
        DECLARE @FILE_NAME VARCHAR(20)              
              
        /*              
        SET @FILE_NAME  = 'ECSANGE' + (SELECT REPLACE(CONVERT(VARCHAR(8), GETDATE()-20, 5),'-',''))              
        */      
                   
        SET @FILE_NAME = 'ANGEREG'            
              
        SET @LOT_NO = (              
                        SELECT ISNULL(MAX(LOT_NO)+ 1,1)               
                        FROM TBL_ECS_GEN_PROCESS_LOG               
                        WHERE CONVERT(VARCHAR(11),PROCESSED_DATE) = CONVERT(VARCHAR(11),GETDATE())              
                       )              
              
        SET @FILE_NAME = @FILE_NAME + RIGHT('0000'+ CONVERT(VARCHAR(4),@LOT_NO),4)       
              
        /****************************************************************************************            
            GETTING ALL THE CLIENTS WHO ARE ALREADY PROCESSED            
        ****************************************************************************************/             
                    
        SELECT               
            [Sr. No.] = ROW_NUMBER()OVER(ORDER BY TM.PARTY_CODE),              
            [Client DP ID] = SUBSTRING(TM.DP_ID,1,16),              
            [Applicant Name] = SUBSTRING(TM.PARTY_NAME,1,40),              
            [Bank A/c Holder name] = SUBSTRING(CM.FIRST_HOLD_NAME,1,40),              
            [Bank Name] = REPLACE(SUBSTRING(TM.BANK_NAME,1,40),',',' '),              
            [Branch Name] = '',              
            [Bank Account Number] = SUBSTRING(TM.BANK_ACCNO,1,18),              
            [MICR] = SUBSTRING(TM.MICR_CODE,1,9),              
            [ACCOUNT TYPE] = CASE TM.BANK_ACC_TYPE WHEN 'Saving' THEN 1     
                                WHEN 'Current' THEN 2     
                                WHEN 'Cash Credit' THEN 3     
                            END,    
            [Date of effect / Start Date] = REPLACE(CONVERT(VARCHAR(10), ENTERED_DATE, 105),'-',''),              
            [Valid up to / End Date] = REPLACE(CONVERT(VARCHAR(10), ECS_EXPIRY_DATE, 105),'-',''),              
            [Amount (Upper limit)] = convert(numeric(12,2),ECS_UPPER_LIMIT)                
        INTO #TEMP              
        FROM DBO.TBL_ECS_REG_MASTER TM              
            INNER JOIN [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER CM ON TM.DP_ID = CM.CLIENT_CODE         
        WHERE REQ_STATUS = -1 AND ECS_STATUS = 'P'        
              
        /****************************************************************************************            
            UPDATING STATUS            
        ****************************************************************************************/             
                    
        IF((SELECT COUNT(*) FROM #TEMP) > 0)            
                    
        BEGIN            
                    
            UPDATE TM              
            SET --TM.REQ_STATUS = 2,              
                TM.REQ_STATUS = 1,  
                TM.UPDATED_BY = @USERNAME              
            FROM DBO.TBL_ECS_REG_MASTER TM              
                INNER JOIN #TEMP T ON  TM.DP_ID = T.[CLIENT DP ID] AND TM.REQ_STATUS = -1 AND TM.ECS_STATUS = 'P'           
                          
            INSERT INTO TBL_ECS_GEN_PROCESS_LOG              
            VALUES(@FILE_NAME,@LOT_NO,@USERNAME,GETDATE())             
                        
            /****************************************************************************************            
                GETTING FINAL DATA FOR FILE EXECUTION            
            ****************************************************************************************/             
                        
            SELECT [Sr. No.] = STUFF('000000',6-LEN([Sr. No.])+1,LEN([Sr. No.]),CONVERT(VARCHAR,[Sr. No.])),            
                    [Client DP ID],[Applicant Name],            
                    [Bank A/c Holder name],[Bank Name],            
                    [Branch Name],[Bank Account Number],            
                    [MICR],[Account Type],[Date of effect / Start Date],            
                    [Valid up to / End Date],[Amount (Upper limit)]             
            FROM #TEMP             
                        
            SELECT [ECS_FILE_NAME] = @FILE_NAME            
                    
        END            
                          
        IF(@@ERROR = 0)    
        BEGIN                
            COMMIT TRAN         
        END        
        ELSE    
        BEGIN    
            ROLLBACK TRAN        
        END    
                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_REG_PROCESS
-- --------------------------------------------------
/***********************************************************************************      
CREATED BY :: RUTVIJ PATIL      
CREATED DATE :: 25 JULY 2011      
PURPOSE :: USED TO DO REGISTRATION PROCESS      
      
MODIFIED BY ::      
MODIFIED DATE ::      
REASON ::      
***********************************************************************************/      
      
CREATE PROCEDURE [dbo].[USP_ECS_REG_PROCESS]      
      
AS      
BEGIN      
      
    BEGIN TRAN      
  
    SELECT       
        [Sr. No.] = ROW_NUMBER()OVER(ORDER BY TM.PARTY_CODE),      
        [Client DP ID] = SUBSTRING(TM.DP_ID,1,16),      
        [Applicant Name] = SUBSTRING(TM.PARTY_NAME,1,40),      
        [Bank A/c Holder name] = SUBSTRING(CM.FIRST_HOLD_NAME,1,40),      
        [Bank Name] = SUBSTRING(TM.BANK_NAME,1,40),      
        [Branch Name] = '',      
        [Bank Account Number] = SUBSTRING(TM.BANK_ACCNO,1,18),      
        [MICR] = SUBSTRING(TM.MICR_CODE,1,9),      
        [Account Type] = SUBSTRING(TM.BANK_ACC_TYPE,1,2),      
        [Date of effect / Start Date] = CONVERT(VARCHAR(10), CSO_RECEIVED_DATE, 105),      
        [Valid up to / End Date] = CONVERT(VARCHAR(10), ECS_EXPIRY_DATE, 105),      
        [Amount (Upper limit)] = ECS_UPPER_LIMIT      
    INTO #TEMP      
    FROM DBO.TBL_ECS_REG_MASTER TM      
        INNER JOIN [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER CM ON  TM.DP_ID = CM.CLIENT_CODE  
    WHERE REQ_STATUS = 0 AND TM.ECS_STATUS = 'P'  
  
    UPDATE TM      
    SET TM.REQ_STATUS = -1      
    FROM DBO.TBL_ECS_REG_MASTER TM      
        INNER JOIN #TEMP T ON  TM.DP_ID = T.[CLIENT DP ID] AND TM.REQ_STATUS = 0 AND TM.ECS_STATUS = 'P'  
        
    SELECT CNT = COUNT(*) FROM #TEMP    
  
    IF(@@ERROR = 0)  
    BEGIN              
        COMMIT TRAN       
    END      
    ELSE  
    BEGIN  
        ROLLBACK TRAN      
    END  
                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_TRAN_ALERT_SMS
-- --------------------------------------------------
/*******************************************************************************************                                                                                              
                                                                                              
CREATED BY :: RUTVIJ PATIL                                                                                              
CREATED DATE :: 26 JULY 2011                                                                                              
PURPOSE :: USE TO SEND SMS TO ECS CLIENT BEFORE                             
                    ECS TRANSACTION IS INITIATED                            
    
CHANGE ID :: 1    
MODIFIED BY :: MITTAL    
MODIFIED DATE :: JUN 13 2012    
PURPOSE :: CHANGED SMS CONTENT AS PER MAIL BY PRASHANT DATED JUN 13 2012.    
                                                                                              
*******************************************************************************************/                              
                            
CREATE PROCEDURE [DBO].[USP_ECS_TRAN_ALERT_SMS]    
                            
    @USERNAME VARCHAR(50),                            
    @MONTH INT,                            
    @YEAR NUMERIC(4,0)                            
                                
AS                            
                            
BEGIN                            
             
    SET XACT_ABORT ON           
                            
    BEGIN TRAN          
                            
    /**************************************************************************************************                                             
        SELECT REQUIRED CLIENTS TO SEND SMS                             
    **************************************************************************************************/                            
    SELECT M.PARTY_CODE,                            
        M.DP_ID,                            
        SCB_RESPONSE_DATE = MAX(M.SCB_RESPONSE_DATE),                            
        AMOUNT = AMOUNT/100,                            
        ACCOUNT = 'A/C XXXX' + RIGHT(BANK_ACCNO,4),                            
        MOBILE_NO = SPACE(11)                  
    INTO #TEMP                            
    FROM TBL_ECS_REG_MASTER M                            
        INNER JOIN TBL_ECS_TRANSACTION T ON M.DP_ID = T.DP_ID                            
    WHERE ECS_STATUS = 'A' AND MONTH = @MONTH AND YEAR = @YEAR AND T.ALERT_SMS_STATUS = '' AND T.TRAN_STATUS = 'P'                            
    GROUP BY PARTY_CODE,M.DP_ID,AMOUNT,'A/C XXXX' + RIGHT(BANK_ACCNO,4)                            
                            
    /**************************************************************************************************                                             
        GETTING REQUIRED CLIENTS MOBILE NO                            
    **************************************************************************************************/                            
    UPDATE T                            
    SET T.MOBILE_NO = ISNULL(CD.MOBILE_PAGER,'')                            
    FROM #TEMP T                            
        LEFT JOIN [196.1.115.196].MSAJAG.DBO.CLIENT_DETAILS CD ON T.PARTY_CODE = CD.PARTY_CODE                            
    WHERE ISNUMERIC(MOBILE_PAGER) = 1 AND LEN(MOBILE_PAGER) > 9                            
        
    DECLARE @MONTH_YEAR AS VARCHAR(10)    
     
 SELECT @MONTH_YEAR = LEFT(UPPER(CONVERT(VARCHAR,(DATENAME( MONTH , DATEADD( MONTH , 4 , 0 ) - 1 )))),3) + /*' ' +*/ right(CONVERT(VARCHAR,2012),2)    
 FROM #TEMP    
 WHERE MOBILE_NO <> ''    
        
    INSERT INTO [196.1.115.132].SMS.DBO.SMS    
    SELECT                             
        MOBILE_NO,                                                                                                                                            
        --MOB_MESSAGE= 'DEAR CLIENT, AMOUNT OF RS ' + CONVERT(VARCHAR,AMOUNT) + ' WILL BE DEBITED FROM REGISTERED BANK ' + LTRIM(RTRIM(ACCOUNT)) + ' THROUGH ECS AGAINST DP CHARGES FOR ' + UPPER(DATENAME(MM,'2011-' + CONVERT(VARCHAR,@MONTH) + '-01')) + ' '+  
        --CONVERT(VARCHAR,@YEAR),       
        /*    
        MOB_MESSAGE='DEAR CLIENT, AMT OF RS ' + CONVERT(VARCHAR,AMOUNT) + ' WILL BE DEBITED FM UR REGD BANK '       
   + LTRIM(RTRIM(ACCOUNT))       
   + ' THRU ECS AGNST DP CHRGS FOR '       
   + LEFT(UPPER(DATENAME(MM,CONVERT(VARCHAR,@YEAR)+'-'       
   + CONVERT(VARCHAR,@MONTH) + '-01')),3)+ ' ' +RIGHT(CONVERT(VARCHAR,@YEAR),2)  + '. ENSURE AVAILTY OF FUNDS BY 15TH '+LEFT(UPPER(DATENAME(MM,'2011-'       
   + CONVERT(VARCHAR,@MONTH+1) + '-01')),3) + ' ' +RIGHT(CONVERT(VARCHAR,@YEAR),2),           
     */  
     /*CHANGE ID :: 1*/  
		MOB_MESSAGE = 'Dear Client, Amount of Rs '+ CONVERT(VARCHAR,CONVERT(DECIMAL(15,2),AMOUNT))+' will be ECS debited from your registered bank '+ ACCOUNT +' against ' + @MONTH_YEAR + ' DP charges. Ensure funds in A/C by 15th'+@MONTH_YEAR ,
        DATE=CONVERT(VARCHAR(11),GETDATE(),103),    
        TM = REPLACE(SUBSTRING(CONVERT(VARCHAR,DATEADD(MI,10,GETDATE()),9),13,5),' ',''),    
        FLAG='P',    
        AP=RIGHT(CONVERT(VARCHAR,GETDATE(),100),2),    
        'ECS-TRAN'    
    FROM #TEMP    
    WHERE MOBILE_NO <> ''    
        
    /**************************************************************************************************                                             
        UPDATE FINAL STATUS INTO MAIN TRANSACTION TABLE                            
    **************************************************************************************************/                            
    UPDATE T                            
    SET T.ALERT_SMS_STATUS = CASE WHEN TMP.MOBILE_NO <> '' THEN 'S'                            
                            ELSE 'F'                            
                            END,                            
        T.ALERT_SMS_REASON = CASE WHEN TMP.MOBILE_NO <> '' THEN 'SUCCESSFUL'                            
                            ELSE 'INVALID MOBILE NO '                            
                            END                            
    FROM TBL_ECS_TRANSACTION T INNER JOIN #TEMP TMP ON T.DP_ID = TMP.DP_ID                              
    WHERE MONTH = @MONTH AND YEAR = @YEAR                            
                                
    IF((SELECT COUNT(*) FROM #TEMP) > 1)                            
    BEGIN                            
                                
        INSERT INTO TBL_ECS_TRAN_ALERT_SMS_LOG                      
        VALUES(@USERNAME,GETDATE())                            
                                
    END                            
                                
    IF(@@ERROR = 0)                                  
    BEGIN                                  
        COMMIT TRAN               
    END                                  
             
    ELSE                                   
    BEGIN                                  
        ROLLBACK TRAN                                  
    END                              
              
    SET XACT_ABORT OFF           
                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_TRAN_ALERT_SMS_13062012
-- --------------------------------------------------
/*******************************************************************************************                                                                                          
                                                                                          
CREATED BY :: RUTVIJ PATIL                                                                                          
CREATED DATE :: 26 JULY 2011                                                                                          
PURPOSE :: USE TO SEND SMS TO ECS CLIENT BEFORE                         
                    ECS TRANSACTION IS INITIATED                        
                                                                                          
MODIFIED BY ::                                                                                          
MODIFIED DATE ::                                                                                          
PURPOSE ::                                                                                          
                                                                                          
*******************************************************************************************/                          
                        
CREATE PROCEDURE [DBO].[USP_ECS_TRAN_ALERT_SMS_13062012]                  
                        
    @USERNAME VARCHAR(50),                        
    @MONTH INT,                        
    @YEAR NUMERIC(4,0)                        
                            
AS                        
                        
BEGIN                        
         
    SET XACT_ABORT ON       
                        
    BEGIN TRAN      
                        
    /**************************************************************************************************                                         
        SELECT REQUIRED CLIENTS TO SEND SMS                         
    **************************************************************************************************/                        
    SELECT M.PARTY_CODE,                        
        M.DP_ID,                        
        SCB_RESPONSE_DATE = MAX(M.SCB_RESPONSE_DATE),                        
        AMOUNT = AMOUNT/100,                        
        ACCOUNT = 'A/C XXXX' + RIGHT(BANK_ACCNO,4),                        
        MOBILE_NO = SPACE(11)              
    INTO #TEMP                        
    FROM TBL_ECS_REG_MASTER M                        
        INNER JOIN TBL_ECS_TRANSACTION T ON M.DP_ID = T.DP_ID                        
    WHERE ECS_STATUS = 'A' AND MONTH = @MONTH AND YEAR = @YEAR AND T.ALERT_SMS_STATUS = '' AND T.TRAN_STATUS = 'P'                        
    GROUP BY PARTY_CODE,M.DP_ID,AMOUNT,'A/C XXXX' + RIGHT(BANK_ACCNO,4)                        
                        
    /**************************************************************************************************                                         
        GETTING REQUIRED CLIENTS MOBILE NO                        
    **************************************************************************************************/                        
    UPDATE T                        
    SET T.MOBILE_NO = ISNULL(CD.MOBILE_PAGER,'')                        
    FROM #TEMP T                        
        LEFT JOIN [196.1.115.196].MSAJAG.DBO.CLIENT_DETAILS CD ON T.PARTY_CODE = CD.PARTY_CODE                        
    WHERE ISNUMERIC(MOBILE_PAGER) = 1 AND LEN(MOBILE_PAGER) > 9                        
                        
    INSERT INTO [196.1.115.132].SMS.DBO.SMS            
    SELECT                         
        MOBILE_NO,                                                                                                                                        
        --MOB_MESSAGE= 'DEAR CLIENT, AMOUNT OF RS ' + CONVERT(VARCHAR,AMOUNT) + ' WILL BE DEBITED FROM REGISTERED BANK ' + LTRIM(RTRIM(ACCOUNT)) + ' THROUGH ECS AGAINST DP CHARGES FOR ' + UPPER(DATENAME(MM,'2011-' + CONVERT(VARCHAR,@MONTH) + '-01')) + ' ' +  
        --CONVERT(VARCHAR,@YEAR),   
        MOB_MESSAGE='DEAR CLIENT, AMT OF RS ' + CONVERT(VARCHAR,AMOUNT) + ' WILL BE DEBITED FM UR REGD BANK '   
   + LTRIM(RTRIM(ACCOUNT))   
   + ' THRU ECS AGNST DP CHRGS FOR '   
   + LEFT(UPPER(DATENAME(MM,CONVERT(VARCHAR,@YEAR)+'-'   
   + CONVERT(VARCHAR,@MONTH) + '-01')),3)+ ' ' +RIGHT(CONVERT(VARCHAR,@YEAR),2)  + '. ENSURE AVAILTY OF FUNDS BY 15TH '+LEFT(UPPER(DATENAME(MM,'2011-'   
   + CONVERT(VARCHAR,@MONTH+1) + '-01')),3) + ' ' +RIGHT(CONVERT(VARCHAR,@YEAR),2),       
        DATE=CONVERT(VARCHAR(11),GETDATE(),103),                                         
        TM = REPLACE(SUBSTRING(CONVERT(VARCHAR,DATEADD(MI,10,GETDATE()),9),13,5),' ',''),                                                                                                         
        FLAG='P',                    
        AP=RIGHT(CONVERT(VARCHAR,GETDATE(),100),2),                        
        'ECS-TRAN'                        
    FROM #TEMP                              
    WHERE MOBILE_NO <> ''                    
                        
    /**************************************************************************************************                                         
        UPDATE FINAL STATUS INTO MAIN TRANSACTION TABLE                        
    **************************************************************************************************/                        
    UPDATE T                        
    SET T.ALERT_SMS_STATUS = CASE WHEN TMP.MOBILE_NO <> '' THEN 'S'                        
                            ELSE 'F'                        
                            END,                        
        T.ALERT_SMS_REASON = CASE WHEN TMP.MOBILE_NO <> '' THEN 'SUCCESSFUL'                        
                            ELSE 'INVALID MOBILE NO '                        
                            END                        
    FROM TBL_ECS_TRANSACTION T INNER JOIN #TEMP TMP ON T.DP_ID = TMP.DP_ID                          
    WHERE MONTH = @MONTH AND YEAR = @YEAR                        
                            
    IF((SELECT COUNT(*) FROM #TEMP) > 1)                        
    BEGIN                        
                            
        INSERT INTO TBL_ECS_TRAN_ALERT_SMS_LOG                  
        VALUES(@USERNAME,GETDATE())                        
                            
    END                        
                            
    IF(@@ERROR = 0)                              
    BEGIN                              
        COMMIT TRAN           
    END                              
         
    ELSE                               
    BEGIN                              
        ROLLBACK TRAN                              
    END                          
          
    SET XACT_ABORT OFF       
                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_TRAN_FILE_GENERATION
-- --------------------------------------------------
/***********************************************************************************                              
CREATED BY :: RUTVIJ PATIL                              
CREATED DATE :: 27 JULY 2011                              
PURPOSE :: USED TO GENERATE TRANSACTION FILE                    
                              
MODIFIED BY ::                              
MODIFIED DATE ::                              
REASON ::                              
***********************************************************************************/                      
                    
CREATE PROCEDURE [dbo].[USP_ECS_TRAN_FILE_GENERATION]                    
                    
    @USERNAME VARCHAR(20),                    
    @MONTH INT,
    @YEAR NUMERIC(4)
                    
AS                    
    
  BEGIN                   
           
        BEGIN TRAN     
             
        DECLARE @LOT_NO INT                              
        DECLARE @FILE_NAME VARCHAR(25)                    
                            
        -- SETTLEMENT NO IS HARDCODED AS TOLD BY SHWETA                    
        SET @FILE_NAME = 'ECSANGE' + REPLACE(CONVERT(VARCHAR(11), GETDATE(), 5),'-','') + '01'                    
                            
        PRINT @FILE_NAME                    
                            
        /****************************************************************************************                            
            GETTING ALL THE CLIENTS WHO ARE ALREADY PROCESSED                            
        ****************************************************************************************/                     
                            
        SELECT [Sr No.] = [SR NO],                    
            [Client DP ID] = DP_ID,                    
            [Applicant Name] = APPLICANT_NAME,                    
            [Bank A/C Holder Name] = ACC_HOLDER_NAME,                    
            [Bank Name] = BANK_NAME,                    
            [Branch Name] = BRANCH_NAME,                    
            [Destination Account No.] = DESTINATION_ACC,                    
            [MICR  (9 Characters)] = MICR,                    
            [Account Type] = ACCOUNT_TYPE,                    
            [Amount in Rs.ps] = AMOUNT,                    
            [Settlement Date] = SETTLEMENT_DATE,                    
            [Ref No.] = REF_NO,                    
            [Locations] = LOCATIONS                    
        INTO #TEMP                    
        FROM TBL_ECS_TRANSACTION                    
        WHERE [MONTH] = @MONTH AND [YEAR] = @YEAR                    
                          
        /***************************************************************************************************                    
        USE TO UPDATE TRANSACTION FLAG INTO TBL_ECS_TRANSACTION                           
        ***************************************************************************************************/                    
              
        UPDATE T                  
        SET T.REQ_STATUS = 1                  
        FROM TBL_ECS_TRANSACTION T                  
            INNER JOIN #TEMP TMP ON T.DP_ID = TMP.[Client DP ID] AND T.SETTLEMENT_DATE = TMP.[SETTLEMENT DATE]                  
                            
        IF((SELECT COUNT(*) FROM #TEMP) > 0)                    
        BEGIN                    
            INSERT INTO TBL_ECS_TRAN_FILE_LOG                    
            VALUES(@FILE_NAME,1,@MONTH,@YEAR,@USERNAME,GETDATE())                    
        END                    
                          
        SELECT [Sr No.],[Client DP ID],[Amount in Rs.ps],[Settlement Date]= replace(CONVERT(VARCHAR(10), [Settlement Date], 105),'-',''),          
        [Ref No.]          
        FROM #TEMP                    
                        
        SELECT @FILE_NAME                  
                          
        /* USE TO GENERATE SYNERGY FILE */             
        SELECT VOUCHERDATE = CONVERT(VARCHAR(10),[SETTLEMENT DATE],103),                
            BENEF = REPLACE([CLIENT DP ID],'12033200',''),           
            CHQNO = [Ref No.],                
            CHQTYPE = 'E',                
            CHQDATE = CONVERT(VARCHAR(10), [SETTLEMENT DATE], 103),                
            BANKNAME = 'SCB',                
            AMOUNT = CONVERT(NUMERIC(18,2),[Amount in Rs.ps]/100),    
            REVERSAL = 'G68',                
            NARRATION = 'Being amt received from ' + REPLACE([CLIENT DP ID],'12033200','') + ' towards DP charges through ECS'      
        FROM #TEMP    
          
        /* USE TO GENERATE FILE WHICH CONSISTS OF PARTY CODE EXCEEDING ECS_UPPER_LIMIT VALUE */   
        SELECT PARTY_CODE,DP_ID,[MONTH],[YEAR],ECS_UPPER_LIMIT,ECS_TRAN_AMOUNT   
        FROM TBL_ECS_EXCEED_TRAN_LIMIT                
        WHERE [YEAR] = @YEAR AND [MONTH] = @MONTH  
                 
        IF(@@ERROR = 0)    
        BEGIN    
            COMMIT TRAN    
        END    
        ELSE     
        BEGIN    
            ROLLBACK TRAN    
        END                          
               
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_TRAN_STATUS_SMS
-- --------------------------------------------------
/*******************************************************************************************                                                                                          
                                                                                          
CREATED BY :: RUTVIJ PATIL                                                                                          
CREATED DATE :: 26 JULY 2011                                                                                          
PURPOSE :: USE TO SEND SMS TO ECS CLIENT ONCE                
                    SCB RESPONSE UPLOADED                
                                                                                          
MODIFIED BY ::                                                                                          
MODIFIED DATE ::                                                                                          
PURPOSE ::                                                                                          
[USP_ECS_TRAN_STATUS_SMS] '',9,2011                                                                                                        
*******************************************************************************************/                          
                        
CREATE PROCEDURE [dbo].[USP_ECS_TRAN_STATUS_SMS]       
                        
    @USERNAME VARCHAR(50),                        
    @MONTH INT,                        
    @YEAR NUMERIC(4,0)                        
                            
AS                        
                        
BEGIN                        
              
   SET XACT_ABORT ON              
                        
   BEGIN TRANSACTION   
                                            
                        
    /**************************************************************************************************                                         
        SELECT REQUIRED CLIENTS TO SEND SMS                 
    **************************************************************************************************/                        
    SELECT M.PARTY_CODE,                        
        M.DP_ID,                        
        SCB_RESPONSE_DATE = MAX(M.SCB_RESPONSE_DATE),                        
        AMOUNT = AMOUNT/100,                        
        ACCOUNT = 'A/C XXXX' + RIGHT(BANK_ACCNO,4),                
        TRAN_STATUS,                
        MOBILE_NO = space(12)                        
    INTO #TEMP                        
    FROM TBL_ECS_REG_MASTER M                        
        INNER JOIN TBL_ECS_TRANSACTION T ON M.DP_ID = T.DP_ID                        
    WHERE ECS_STATUS = 'A' AND MONTH = @MONTH AND YEAR = @YEAR AND T.TRAN_SMS_STATUS = '' AND T.TRAN_STATUS <> 'P'                        
    GROUP BY PARTY_CODE,M.DP_ID,AMOUNT,'A/C XXXX' + RIGHT(BANK_ACCNO,4),TRAN_STATUS                        
                        
    /**************************************************************************************************                                         
        GETTING REQUIRED CLIENTS MOBILE NO                        
    **************************************************************************************************/                        
    UPDATE T                        
    SET T.MOBILE_NO = ISNULL(CD.MOBILE_PAGER,'')                        
    FROM #TEMP T                        
        LEFT JOIN [196.1.115.196].MSAJAG.DBO.CLIENT_DETAILS CD ON T.PARTY_CODE = CD.PARTY_CODE                        
    WHERE ISNUMERIC(MOBILE_PAGER) = 1 AND LEN(MOBILE_PAGER) > 9                        
                        
    --INSERT INTO INTRANET.SMS.DBO.SMS                              
    SELECT                         
        MOBILE_NO,                                                                                                                                                
        MOB_MESSAGE= CASE                 
           WHEN TRAN_STATUS = 'S'                
                        THEN 'Dear Client, amount of Rs ' + CONVERT(VARCHAR,AMOUNT) + ' has been debited from registered bank ' + ACCOUNT + ' through ECS against DP charges for ' + DATENAME(MM,@MONTH) + ' ' + CONVERT(VARCHAR,@YEAR)                
                       
                        WHEN TRAN_STATUS = 'F'                
                        THEN 'Dear Client, transaction for DP charges through ECS for ' + DATENAME(MM,@MONTH) + ' ' + CONVERT(VARCHAR,@YEAR) + 'from registered bank ' + ACCOUNT + ' has Failed. Please contact to your branch.'                
                    END,               
        DATE=CONVERT(VARCHAR(11),GETDATE(),103),                                 
        TM = REPLACE(SUBSTRING(CONVERT(VARCHAR,DATEADD(MI,10,GETDATE()),9),13,5),' ',''),                                                                                             
        FLAG='P',                            
        AP=RIGHT(CONVERT(VARCHAR,GETDATE(),100),2),                        
        'ECS-TRAN'                        
    FROM #TEMP                              
    WHERE MOBILE_NO <> ''                        
                        
    /**************************************************************************************************                                         
        UPDATE FINAL STATUS INTO MAIN TRANSACTION TABLE                        
    **************************************************************************************************/                        
    UPDATE T                        
    SET T.TRAN_SMS_STATUS = CASE WHEN TMP.MOBILE_NO <> '' THEN 'S'                        
                            ELSE 'F'                        
                            END,                        
    T.TRAN_SMS_REASON = CASE WHEN TMP.MOBILE_NO <> '' THEN 'SUCCESSFUL'                        
                            ELSE 'INVALID MOBILE NO '                        
                            END                        
    FROM TBL_ECS_TRANSACTION T                        
        --INNER JOIN #TEMP TMP ON T.PARTY_CODE = TMP.PARTY_CODE AND T.DP_ID = TMP.DP_ID                          
        INNER JOIN #TEMP TMP ON T.DP_ID = TMP.DP_ID                          
    WHERE MONTH = @MONTH AND YEAR = @YEAR                        
                            
    IF(@@ERROR = 0)                              
    BEGIN                              
        COMMIT TRAN                              
    END                              
    ELSE                               
    BEGIN                              
        ROLLBACK TRAN                              
    END                          
                  
 SET XACT_ABORT OFF  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ECS_TRANSACTION_PROCESS
-- --------------------------------------------------
/*******************************************************************************************                                                                                    
                                                                                    
CREATED BY :: RUTVIJ PATIL                                                                                    
CREATED DATE :: 26 JULY 2011                                                                                    
PURPOSE :: USE TO PROCESS ECS TRANSACTION                                         
      
CHANGE ID  :: 0                                                                                    
MODIFIED BY  ::      
MODIFIED DATE ::      
PURPOSE   ::      
      
CHANGE ID  :: 1      
MODIFIED BY  :: MITTAL      
MODIFIED DATE :: AUG 11 2012      
PURPOSE   :: DUE TO @FROM_DATE NOT ASSIGNED VALUE      
                                                                                    
*******************************************************************************************/                                         
                                        
CREATE PROCEDURE [dbo].[USP_ECS_TRANSACTION_PROCESS]                                        
                                        
    @USERNAME VARCHAR(25),                                        
    @MONTH INT,                                        
    @YEAR NUMERIC(4)                                        
                                            
AS                                        
                                        
BEGIN                                        
                                        
        BEGIN TRAN                                        
                                            
        DECLARE @FROM_DATE DATETIME                                          
        DECLARE @TO_DATE DATETIME                                        
                                        
        /*******************************************************************************************                                        
            USE TO SET FROM DATE AND TO DATE                                        
        *******************************************************************************************/                                        
                                        
        /*      
   CHANGE ID  :: 1      
        */      
        --SELECT @FROM_DATE = CONVERT(VARCHAR(11),MAX(SDTCUR))          
        --FROM   [196.1.115.182].GENERAL.DBO.PARAMETER A(NOLOCK)          
        --WHERE  LDTCUR <= GETDATE()      
              
        SELECT @FROM_DATE = CONVERT(VARCHAR(11),SDTCUR)                               
        FROM [196.1.115.182].GENERAL.DBO.PARAMETER                               
        WHERE SDTCUR <= GETDATE() AND LDTCUR >= GETDATE()          
                                      
        SET @TO_DATE = DBO.GETLASTDATE(@MONTH,@YEAR)                        
                        
        --PRINT @FROM_DATE                                        
        --PRINT @TO_DATE                                        
                                        
        /*******************************************************************************************                                        
            USE TO STORE FINAL DATA                                         
        *******************************************************************************************/                                        
                                        
        CREATE TABLE #TBL_ECS_TRANSACTION                                        
        (                                        
            [SR NO] INT ,                                        
            [DP_ID] VARCHAR(16),                                        
            [APPLICANT_NAME] VARCHAR(40),                                        
            [ACC_HOLDER_NAME] VARCHAR(40),                                        
            [BANK_NAME] VARCHAR(40),                                        
            [BRANCH_NAME] VARCHAR(40),                                                  [DESTINATION_ACC] VARCHAR(18),                                        
            [MICR] VARCHAR(9),                    
            [ACCOUNT_TYPE] VARCHAR(2),                                     
            [AMOUNT] NUMERIC(13) ,                                        
            [SETTLEMENT_DATE] DATETIME,                                        
            --[REF_NO] VARCHAR(40),                                        
            [LOCATIONS] VARCHAR(40),                                
            [MONTH] INT,                                        
            [YEAR] NUMERIC(4),                              
            PROCESSED_BY VARCHAR(20),                                        
            PROCESSED_DATE DATETIME,                                       
            REQ_STATUS INT                                        
        )                                        
                 
        /*******************************************************************************************                                        
            GETTING REQUIRED LEDGER VALUES TO DEBIT                                        
        *******************************************************************************************/                                      
        /*                
        SELECT LD_CLIENTCD,                                         
            LD_AMOUNT = SUM(CASE WHEN LD_DEBITFLAG = 'D' THEN LD_AMOUNT ELSE LD_AMOUNT*-1 END)                                       
        INTO #TEMP                                         
        FROM [ABCSOORACLEMDLW].SYNERGY.DBO.LEDGER L WITH(NOLOCK)                                           
            INNER JOIN TBL_ECS_REG_MASTER M ON L.LD_CLIENTCD = M.DP_ID                                        
        WHERE LD_DT >= @FROM_DATE AND         
        LD_DT <= @TO_DATE AND M.ECS_STATUS = 'A'          
        And  Not (LD_DocumentType='o' And          
                     LD_DT >= (Select Sdtcur          
                             From   INTRANET.RISK.DBO.Parameter A (NOLOCK)          
                             Where  Sdtcur <= Getdate() And          
                                    Ldtcur >= Getdate()))                                      
        GROUP BY LD_CLIENTCD                                            
        HAVING SUM(CASE WHEN LD_DEBITFLAG = 'D' THEN LD_AMOUNT ELSE LD_AMOUNT*-1 END) > 0                                           
        ORDER BY LD_CLIENTCD                 
        */    
            
  SELECT LD_CLIENTCD,                                         
            LD_AMOUNT = SUM(CASE WHEN LD_DEBITFLAG = 'D' THEN LD_AMOUNT ELSE LD_AMOUNT*-1 END)                                       
        INTO #TEMP                                         
        FROM [ABCSOORACLEMDLW].SYNERGY.DBO.LEDGER L WITH(NOLOCK)                                           
            INNER JOIN TBL_ECS_REG_MASTER M WITH(NOLOCK) ON L.LD_CLIENTCD = M.DP_ID                                        
        WHERE LD_DT <= @TO_DATE AND M.ECS_STATUS = 'A'          
        GROUP BY LD_CLIENTCD                                            
        HAVING SUM(CASE WHEN LD_DEBITFLAG = 'D' THEN LD_AMOUNT ELSE LD_AMOUNT*-1 END) > 0                                           
        ORDER BY LD_CLIENTCD         
                        
                        
        /*CREATE TABLE #TEMP                
        (                
            LD_CLIENTCD VARCHAR(16),                                         
            LD_AMOUNT MONEY                  
        )                
                
        INSERT INTO #TEMP VALUES('1203320000941105',100)                
        INSERT INTO #TEMP VALUES('1203320002613196',100)                
        INSERT INTO #TEMP VALUES('1203320005973333',100)                
        INSERT INTO #TEMP VALUES('1203320006684234',100)                
     INSERT INTO #TEMP VALUES('1203320005111566',200)            
        INSERT INTO #TEMP VALUES('1203320005412085',150) */                                               
                                        
        IF((SELECT COUNT(*) FROM #TEMP) > 0)                                   
        BEGIN                                      
                                              
            /*******************************************************************************************                                        
                INSERTING CALUCLATED DATA INTO TEMP TABLE                                        
            *******************************************************************************************/                                        
                                            
            INSERT INTO #TBL_ECS_TRANSACTION([DP_ID],[AMOUNT],[REQ_STATUS],[MONTH],[YEAR],PROCESSED_BY,PROCESSED_DATE)                                                                              
            SELECT LD_CLIENTCD,[LD_AMOUNT] * 100 ,0,@MONTH,@YEAR,@USERNAME,CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()))                                        
            FROM #TEMP                     
                              
            /*******************************************************************************************                                        
                INSERTING CALUCLATED DATA INTO TABLE                   
             TO HOLD THE TRANSACTION AMOUNT VALUE WHICH EXCEEDS THE UPPER LIMIT VALUE                  
            *******************************************************************************************/                                        
                              
            INSERT INTO TBL_ECS_EXCEED_TRAN_LIMIT                  
            SELECT LTRIM(RTRIM(M.PARTY_CODE)),                  
                LTRIM(RTRIM(M.DP_ID)),                  
                LTRIM(RTRIM(@MONTH)),                  
                LTRIM(RTRIM(@YEAR)),                  
                ECS_UPPER_LIMIT * 100, -- CONVERTING RS TO PAISE                   
                CASE WHEN AMOUNT > ((M.ECS_UPPER_LIMIT)*100) THEN (T.AMOUNT)                  
             ELSE 0 END,                  
                @USERNAME,                  
                GETDATE()                  
            FROM #TBL_ECS_TRANSACTION T                  
            INNER JOIN TBL_ECS_REG_MASTER M ON T.DP_ID = M.DP_ID AND M.ECS_STATUS = 'A'                    
                              
            /*******************************************************************************************                                        
                DELETE ALL THE RECORDS WHICH HAVING ECS TRANSACTION VALUE LESS THAN UPPER LIMIT                  
            *******************************************************************************************/                                                         
                              
            DELETE FROM TBL_ECS_EXCEED_TRAN_LIMIT                  
            WHERE ECS_TRAN_AMOUNT = 0                   
                                              
            /*******************************************************************************************                                        
                PREPARING DATA TO BE INSERT INTO TBL_ECS_TRANSACTION                  
            *******************************************************************************************/                                      
                                                        
            UPDATE T                                        
            SET T.[APPLICANT_NAME] = SUBSTRING(M.PARTY_NAME,1,40),                            
                T.[ACC_HOLDER_NAME] = SUBSTRING(CM.FIRST_HOLD_NAME,1,40),                            
                T.[BANK_NAME] = SUBSTRING(M.BANK_NAME,1,40),                                     
                T.[BRANCH_NAME] = '',           
                T.[DESTINATION_ACC] = M.BANK_ACCNO,                                        
                T.[MICR] = M.MICR_CODE ,                                        
                T.[ACCOUNT_TYPE] = CASE M.BANK_ACC_TYPE WHEN 'Saving' THEN 1                         
                                WHEN 'Current' THEN 2         
                                WHEN 'Cash Credit' THEN 3                         
                            END,                        
                T.[SETTLEMENT_DATE] = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE())),                                        
                --T.[REF_NO] = '',                                        
                T.[LOCATIONS] = '',                          
                T.[AMOUNT] = CASE WHEN AMOUNT <= ((M.ECS_UPPER_LIMIT)*100) THEN T.AMOUNT                          
                                ELSE 0 END                                        
            FROM #TBL_ECS_TRANSACTION T                                        
                INNER JOIN TBL_ECS_REG_MASTER M ON T.DP_ID = M.DP_ID AND M.ECS_STATUS = 'A'                          
                INNER JOIN [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER CM ON T.DP_ID = CM.CLIENT_CODE                                        
                                                        
            /*******************************************************************************************              
                INSERTING DATA INTO TBL_ECS_TRANSACTION                                        
            *******************************************************************************************/                                        
               
            INSERT INTO TBL_ECS_TRANSACTION                                          
            SELECT [SR NO] = ROW_NUMBER() OVER(ORDER BY [DP_ID]),                                        
                [DP_ID],                                        
                [APPLICANT_NAME],                                        
                [ACC_HOLDER_NAME],                                        
                [BANK_NAME],                                        
                [BRANCH_NAME],                                        
                [DESTINATION_ACC],                                        
                [MICR],                                        
                [ACCOUNT_TYPE],                                        
                [AMOUNT],                                        
                [SETTLEMENT_DATE],                                    
                --[REF_NO],                                        
                [LOCATIONS],                                        
                [MONTH],                                        
                [YEAR],                                        
                PROCESSED_BY,                                        
                PROCESSED_DATE,                                        
                REQ_STATUS,                                  
                'P',                                
                CONVERT(DATETIME,'1900-01-01'),                  
                '',                  
                '',                  
                '',                  
                ''                                         
            FROM #TBL_ECS_TRANSACTION                          
            WHERE [AMOUNT] > 0                        
                                     
            INSERT INTO TBL_ECS_TRAN_PROCESS_LOG                                      
            VALUES(@MONTH,@YEAR,@USERNAME,GETDATE())                                  
                                                    
        END                                      
                                            
        SELECT CNT = COUNT(*) FROM #TBL_ECS_TRANSACTION WHERE [AMOUNT] > 0                          
                                
        IF(@@ERROR = 0)                        
        BEGIN                        
            COMMIT TRAN                        
        END                        
        ELSE                         
        BEGIN                        
            ROLLBACK TRAN                        
        END                        
                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FIND_IN_USP
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_FIND_IN_USP]                

@DBNAME VARCHAR(500),              
@SRCSTR VARCHAR(500)                

AS                
                
    SET NOCOUNT ON              
    SET @SRCSTR  = '%' + @SRCSTR + '%'                
              
    DECLARE @STR AS VARCHAR(1000)              
    SET @STR=''              
    IF @DBNAME <>''              
    BEGIN              
    SET @DBNAME=@DBNAME+'.DBO.'              
    END              
    ELSE              
    BEGIN              
    SET @DBNAME=DB_NAME()+'.DBO.'              
    END              
    PRINT @DBNAME              
              
    SET @STR='SELECT DISTINCT O.NAME,O.XTYPE FROM '+@DBNAME+'SYSCOMMENTS  C '               
    SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '               
    SET @STR=@STR+' WHERE O.XTYPE IN (''P'',''V'') AND C.TEXT LIKE '''+@SRCSTR+''''                

    PRINT @STR              
    EXEC(@STR)      
        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FINDINUSP
-- --------------------------------------------------
CREATE PROCEDURE USP_FINDINUSP                
 @DBNAME VARCHAR(500),              
 @SRCSTR VARCHAR(500)                
AS                
                
 SET NOCOUNT ON              
 SET @SRCSTR  = '%' + @SRCSTR + '%'                
              
 DECLARE @STR AS VARCHAR(1000)              
 SET @STR=''              
 IF @DBNAME <>''              
 BEGIN              
 SET @DBNAME=@DBNAME+'.DBO.'              
 END              
 ELSE              
 BEGIN              
 SET @DBNAME=DB_NAME()+'.DBO.'              
 END              
 ----PRINT @DBNAME              
              
 SET @STR='SELECT DISTINCT O.NAME,O.XTYPE FROM '+@DBNAME+'SYSCOMMENTS  C '               
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '               
 SET @STR=@STR+' WHERE O.XTYPE IN (''P'',''V'') AND C.TEXT LIKE '''+@SRCSTR+''''                
 --PRINT @STR              
  EXEC(@STR)              
      
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_CLIENT_DETAILS
-- --------------------------------------------------
/******************************************************************      
CREATED BY :: RUTVIJ PATIL      
CREATED DATE :: 20 JULY 2011      
PURPOSE :: USE TO GET CLIENT DETAILS IN ECS MASTER UPDATION MODULE      
      
MODIFIED BY ::      
MODIFIED DATE ::      
PURPOSE ::      
*******************************************************************/      
      
--USP_GET_CLIENT_DETAILS 'J27289',NULL      
CREATE PROCEDURE [dbo].[USP_GET_CLIENT_DETAILS]      
      
    @PARTY_CODE VARCHAR(15),      
    @DP_ID VARCHAR(16) = NULL      
      
AS      
BEGIN      
      
    DECLARE @STR_SQL VARCHAR(MAX)      
          
    SET @STR_SQL  = ''      
          
    SET @STR_SQL  = @STR_SQL +      
          
    'SELECT ACCOUNT_TYPE,      
        NISE_PARTY_CODE,      
        CLIENT_NAME = FIRST_HOLD_NAME,      
        MICR_CODE,      
        BANK_NAME,      
        BANK_ACCNO,      
        BANK_ADD1=ISNULL(BANK_ADD1,''''),      
        BANK_ADD2=ISNULL(BANK_ADD2,''''),      
        BANK_ADD3=ISNULL(BANK_ADD3,''''),      
        BANK_ADD4=ISNULL(BANK_ADD4,''''),      
        BANK_ZIP=ISNULL(BANK_ZIP,''''),      
        CLIENT_CODE,      
        SHORT_NAME,      
        DP_ID = CLIENT_CODE,    
        FIRST_HOLD_NAME,    
        SECOND_HOLD_NAME=ISNULL(SECOND_HOLD_NAME,''''),    
        FIRST_HOLD_PHONE=ISNULL(FIRST_HOLD_PHONE,''''),    
        BANK_STATE=ISNULL(BANK_STATE,''''),    
        BANK_MICR           
    FROM [ABCSOORACLEMDLW].SYNERGY.DBO.TBL_CLIENT_MASTER WITH (NOLOCK)           
    WHERE NISE_PARTY_CODE = ''' + @PARTY_CODE + ''''      
          
    IF @DP_ID IS NOT NULL      
    BEGIN      
        SET @STR_SQL  = @STR_SQL + ' AND CLIENT_CODE = ''' + LTRIM(RTRIM(@DP_ID)) + ''''      
    END      
          
    PRINT @STR_SQL      
    EXEC(@STR_SQL)      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_ECS_REG_USER
-- --------------------------------------------------
/******************************************************************************  
  
CREATED BY :: RUTVIJ PATIL  
CREATED DATE :: 21 JULY 2011  
PURPOSE :: TO GET SINGLE CLIENT VALUES FOR MASTER ENTRY PAGE  
  
MODIFIED BY ::   
MODIFIED DATE ::  
PURPOSE ::  
  
*******************************************************************************/  
  
--USP_GET_ECS_REG_USER 'J27289','SB','PUK','5059791','P'  
  
CREATE PROCEDURE [dbo].[USP_GET_ECS_REG_USER]  
  
    @PARTY_CODE VARCHAR(15),  
    @ACCESS_TO VARCHAR(25),                                      
    @ACCESS_CODE VARCHAR(25),    
    @DP_ID VARCHAR(16) = NULL,  
    @STATUS VARCHAR(3) = NULL  
     
AS  
BEGIN  
      
      
    DECLARE @SQL VARCHAR(MAX)  
    DECLARE @STR_CONDITION VARCHAR(1000)  
      
    SET @SQL = ''  
    SET @STR_CONDITION = ''  
      
    IF @ACCESS_TO='SB'                                                               
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB = '''+@ACCESS_CODE+''''                                                                                                                             
                                      
    ELSE IF @ACCESS_TO='ZONE'                                                               
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.ZONE ='''+@ACCESS_CODE+''''                                                          
                  
    ELSE IF @ACCESS_TO='SBMAST'                                                               
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB IN  (SELECT DISTINCT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'                                                          
                                      
    ELSE IF @ACCESS_TO = 'REGION'                                                                                                                       
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.REGION = '''+@ACCESS_CODE+''''                                                   
                                      
    ELSE IF @ACCESS_TO='BRANCH'                                
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH = '''+@ACCESS_CODE+''''         
                                      
    ELSE IF @ACCESS_TO = 'BRMAST'                 
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                        
                                      
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                      
    SET @STR_CONDITION =  @STR_CONDITION + ' '               
                  
    SET @SQL = @SQL +   
      
                'SELECT ECS.*   
                 FROM TBL_ECS_REG_MASTER ECS              
                    INNER JOIN INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CD ON ECS.PARTY_CODE = CD.CLIENT    
                 WHERE ECS.ECS_STATUS <>''D'' and PARTY_CODE =''' +  @PARTY_CODE + '''' + @STR_CONDITION  
                   
    IF(@STATUS IS NOT NULL)  
    BEGIN  
        SET @SQL = @SQL + ' AND ECS.ECS_STATUS = ''' + @STATUS + ''''  
    END   
      
    IF(@DP_ID IS NOT NULL)  
    BEGIN  
        SET @SQL = @SQL + ' AND ECS.DP_ID = ''' + @DP_ID + ''''  
    END      
      
    PRINT @SQL  
    EXEC(@SQL)  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_ECS_REG_USER_Image
-- --------------------------------------------------
/******************************************************************************      
      
CREATED BY :: RUTVIJ PATIL      
CREATED DATE :: 21 JULY 2011      
PURPOSE :: TO GET SINGLE CLIENT VALUES FOR MASTER ENTRY PAGE      
      
MODIFIED BY ::       
MODIFIED DATE ::      
PURPOSE ::      
      
*******************************************************************************/      
      
--USP_GET_ECS_REG_USER 'J27289','SB','PUK','5059791','P'      
      
CREATE PROCEDURE [dbo].[USP_GET_ECS_REG_USER_Image]      
      
    @PARTY_CODE VARCHAR(15),      
    @ACCESS_TO VARCHAR(25),                                          
    @ACCESS_CODE VARCHAR(25),        
    @DP_ID VARCHAR(16) = NULL,      
    @STATUS VARCHAR(3) = NULL      
         
AS      
BEGIN      
          
          
    DECLARE @SQL VARCHAR(MAX)      
    DECLARE @STR_CONDITION VARCHAR(1000)      
          
    SET @SQL = ''      
    SET @STR_CONDITION = ''      
          
    IF @ACCESS_TO='SB'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB = '''+@ACCESS_CODE+''''                                                                                                                                 
                                          
    ELSE IF @ACCESS_TO='ZONE'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.ZONE ='''+@ACCESS_CODE+''''                                                              
                      
    ELSE IF @ACCESS_TO='SBMAST'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB IN  (SELECT DISTINCT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'                                                              
                                          
    ELSE IF @ACCESS_TO = 'REGION'                                                                                                                           
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.REGION = '''+@ACCESS_CODE+''''                                                       
                                          
    ELSE IF @ACCESS_TO='BRANCH'                                    
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH = '''+@ACCESS_CODE+''''             
                                          
    ELSE IF @ACCESS_TO = 'BRMAST'                     
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                            
                                          
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                          
    SET @STR_CONDITION =  @STR_CONDITION + ' '                   
                      
    SET @SQL = @SQL +       
          
                'SELECT ECS.*       
                 FROM TBL_ECS_REG_MASTER ECS                  
                    INNER JOIN INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CD ON ECS.PARTY_CODE = CD.CLIENT        
                 WHERE  PARTY_CODE =''' +  @PARTY_CODE + '''' + @STR_CONDITION      
                       
    IF(@STATUS IS NOT NULL)      
    BEGIN      
        SET @SQL = @SQL + ' AND ECS.ECS_STATUS = ''' + @STATUS + ''''      
    END       
          
    IF(@DP_ID IS NOT NULL)      
    BEGIN      
        SET @SQL = @SQL + ' AND ECS.DP_ID = ''' + @DP_ID + ''''      
    END          
          
    PRINT @SQL      
    EXEC(@SQL)      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_ECS_TRAN_TOTAL
-- --------------------------------------------------
/************************************************************************************                            
                            
    CREATED BY :: RUTVIJ PATIL                            
    CREATED DATE :: 26 JULY 2011                            
    REASON :: USE TO GET TRANSACTION TOTAL MONTH WISE  
                            
    MODIFIED BY ::                            
    MODIFIED DATE ::                            
    REASON ::                             
                            
************************************************************************************/   
  
CREATE PROCEDURE [DBO].[USP_GET_ECS_TRAN_TOTAL]
  
AS  
  
BEGIN  
  
    SELECT [YEAR],  
        [MONTH] = DATENAME(MM,'2011-' + CONVERT(VARCHAR,[MONTH]) + '-01'),  
        [TOTAL AMOUNT] = CONVERT(NUMERIC(14,2),SUM(AMOUNT)/100),  
        [TOTAL TRANSACTION] = COUNT(1)  
    FROM DBO.TBL_ECS_TRANSACTION  
    GROUP BY [MONTH],[YEAR]  
    ORDER BY [YEAR],[MONTH]  
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_NEWLY_REGISTERED_CLIENT
-- --------------------------------------------------
/***********************************************************************************              
CREATED BY :: RUTVIJ PATIL              
CREATED DATE :: 03 SEP 2011          
PURPOSE :: USED TO GET CLIENT AS PER ECS STATUS           
              
MODIFIED BY ::              
MODIFIED DATE ::              
REASON ::              
          
***********************************************************************************/          
          
CREATE PROCEDURE [DBO].[USP_GET_NEWLY_REGISTERED_CLIENT]          
          
    @ECS_STATUS VARCHAR(50),        
    @ACCESS_TO VARCHAR(25),                  
    @ACCESS_CODE  VARCHAR(25)        
          
AS          
BEGIN          
          
    DECLARE @STR_SQL VARCHAR(1000)                  
    DECLARE @STR_CONDITION VARCHAR(1000)                  
                      
    SET @STR_SQL = ''                  
    SET @STR_CONDITION = ''                  
                      
    SET @ACCESS_TO = LTRIM(RTRIM(@ACCESS_TO))                  
    SET @ACCESS_CODE = LTRIM(RTRIM(@ACCESS_CODE))                  
                      
    IF @ACCESS_TO = 'SB'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.SB = '''+@ACCESS_CODE+''''                                                                                                                                 
                                          
    ELSE IF @ACCESS_TO ='ZONE'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.ZONE ='''+@ACCESS_CODE+''''                                                              
                      
    ELSE IF @ACCESS_TO ='SBMAST'                                                                   
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.SB IN (SELECT DISTINCT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'                                                              
                                          
    ELSE IF @ACCESS_TO = 'REGION'                                                                                                                           
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.REGION = '''+@ACCESS_CODE+''''                                                       
                                          
    ELSE IF @ACCESS_TO='BRANCH'                                                  
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH = '''+@ACCESS_CODE+''''                                                                                             
                                          
    ELSE IF @ACCESS_TO = 'BRMAST'                                                                                             
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                            
                                          
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                          
    SET @STR_CONDITION =  @STR_CONDITION + ' '                   
                      
    SET @STR_SQL = @STR_SQL +             
              
    '          
    SELECT [CLIENT CODE] = M.PARTY_CODE,          
        [CLIENT NAME] = M.PARTY_NAME,          
        [DP ID] = DP_ID,          
        [MICR CODE] = MICR_CODE,          
        [BANK NAME] = BANK_NAME,          
        [BANK ACCOUNT NO] = BANK_ACCNO,          
        [BANK ACCOUNT TYPE] = BANK_ACC_TYPE,          
        [STATUS] = ECS_STATUS,          
        [ENROLL DATE] = ENTERED_DATE,          
        [SCHEME NAME] = SCHEME_NAME,          
        PERIODICITY,          
        [ECS FORM IMAGE] = ECS_FORM_IMAGE,  
        [Branch]=cv.[Branch],
        CSO_REMARK=m.CSO_REMARK          
    FROM DBO.TBL_ECS_REG_MASTER M          
    INNER JOIN INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CV ON M.PARTY_CODE = CV.CLIENT          
    WHERE ECS_STATUS IN (' + @ECS_STATUS + ')' + @STR_CONDITION  + '     
    ORDER BY M.PARTY_CODE           
              
    '          
                    
    --PRINT @STR_SQL                  
    EXECUTE(@STR_SQL)       
              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INSERT_ECS_REG_MASTER
-- --------------------------------------------------
/******************************************************************************    
    
CREATED BY :: RUTVIJ PATIL    
CREATED DATE :: 21 JULY 2011    
PURPOSE :: TO INSERT VALUES INTO TBL_ECS_REG_MASTER FROM MASTER ENTRY PAGE    
    
MODIFIED BY ::     
MODIFIED DATE ::    
PURPOSE ::    
    
*******************************************************************************/    
    
CREATE PROCEDURE [dbo].[USP_INSERT_ECS_REG_MASTER]    
    
    @PARTY_CODE VARCHAR(15),    
    @PARTY_NAME VARCHAR(100),    
    @DP_ID VARCHAR(16),    
    @MICR_CODE VARCHAR(24),    
    @BANK_NAME VARCHAR(100),    
    @BANK_ACCNO VARCHAR(20),    
    @BANK_ACC_TYPE VARCHAR(11),    
    @ECS_FORM_IMAGE VARBINARY(MAX),    
    @ECS_UPPER_LIMIT MONEY,    
    @CSO_RECEIVED_DATE DATETIME,    
    @ECS_EXPIRY_DATE DATETIME,    
    @SCHEME_NAME VARCHAR(20),    
    @PERIODICITY VARCHAR(20),    
    @ECS_STATUS VARCHAR(3),    
    @ENTERED_BY VARCHAR(20),
    @ECS_CHEQUE_IMAGE VARBINARY(MAX)
    
AS    
BEGIN    
        
    INSERT INTO TBL_ECS_REG_MASTER    
    (    
        PARTY_CODE,    
        PARTY_NAME,    
        DP_ID,    
        MICR_CODE,    
        BANK_NAME,    
        BANK_ACCNO,    
        BANK_ACC_TYPE,    
        ECS_FORM_IMAGE,    
        ECS_UPPER_LIMIT,    
        CSO_RECEIVED_DATE,    
        ECS_EXPIRY_DATE,    
        SCHEME_NAME,    
        PERIODICITY,    
        ECS_STATUS,    
        ENTERED_BY,    
        ENTERED_DATE,    
        REQ_STATUS,
        ECS_CHEQUE_IMAGE    
    )    
    VALUES    
    (    
        @PARTY_CODE,    
        @PARTY_NAME,    
        @DP_ID,    
        @MICR_CODE,    
        @BANK_NAME,    
        @BANK_ACCNO,    
        @BANK_ACC_TYPE,    
        @ECS_FORM_IMAGE,    
        @ECS_UPPER_LIMIT,    
        @CSO_RECEIVED_DATE,    
        @ECS_EXPIRY_DATE,    
        @SCHEME_NAME,    
        @PERIODICITY,    
        @ECS_STATUS,    
        @ENTERED_BY,    
        GETDATE(),    
        0,
        @ECS_CHEQUE_IMAGE
    )    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JOB_ECS_CLIENT_ACTIVATION
-- --------------------------------------------------
 /*******************************************************************************************                                                  
                                                  
CREATED BY :: RUTVIJ PATIL                                                  
CREATED DATE :: 30 AUG 2011                                                  
PURPOSE :: USE TO ACTIVATE ECS CLIENTS WHO       
            RECEIVED SCB SUCCESSFUL RESPONSE BEFORE 30 WORKING DAYS      
                                                  
MODIFIED BY ::                                                  
MODIFIED DATE ::                                                  
PURPOSE ::                                                  
                                                  
*******************************************************************************************/       
      
CREATE PROCEDURE [dbo].[USP_JOB_ECS_CLIENT_ACTIVATION]      
      
AS      
      
BEGIN      
      
    CREATE TABLE #HOLIDAY_MAIN      
    (      
        NO_WORKING DATETIME       
    )      
      
    /*******************************************************************************************      
        USE TO GET LIST OF HOLIDAYS       
    ********************************************************************************************/      
      
    DECLARE @COUNT INT      
    SET @COUNT = 0      
      
    WHILE(@COUNT<90)      
    BEGIN      
      
        IF(DATENAME(DW,GETDATE()-@COUNT) = 'SUNDAY')      
        BEGIN      
            INSERT INTO #HOLIDAY_MAIN      
            SELECT CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()- @COUNT))      
        END      
              
        SET @COUNT  = @COUNT + 1       
              
    END      
      
    INSERT INTO #HOLIDAY_MAIN       
    SELECT HDATE FROM [MIDDLEWARE].HARMONY.DBO.HOLIMST      
    WHERE HDATE BETWEEN GETDATE() - 100 AND GETDATE()      
    ORDER BY HDATE      
      
    /******************************************************************************************     
        ADDED TO REMOVE DUPLICATE ENTRIES ON SUNDAYS    
        HOLIDAYS COMING ON SUNDAYS    
    *******************************************************************************************/      
    SELECT DISTINCT *       
    INTO #HOLIDAY      
    FROM #HOLIDAY_MAIN      
      
    DROP TABLE #HOLIDAY_MAIN      
      
    /*******************************************************************************************      
        GETTING REQUIRED CLIENTS    
        MAX(SCB_RESPONSE_DATE) IS USE TO TAKE CLIENTS LATEST ENTRY     
    ********************************************************************************************/      
      
    SELECT ID=IDENTITY(INT,1,1),      
        PARTY_CODE,      
        DP_ID,      
        SCB_RESPONSE_DATE = MAX(SCB_RESPONSE_DATE),      
        [COUNT] =  DATEDIFF(DD,SCB_RESPONSE_DATE,GETDATE()),      
        [HCOUNT]=0      
    INTO #CLIENT      
    FROM TBL_ECS_REG_MASTER      
    WHERE ECS_STATUS = 'P' AND SCB_REMARK = 'PENDING FROM DESTINATION BANK'       
    GROUP BY PARTY_CODE,DP_ID,DATEDIFF(DD,SCB_RESPONSE_DATE,GETDATE())      
      
    /*******************************************************************************************      
        PERFORMING DAYS CALCULATION      
    ********************************************************************************************/      
      
    DECLARE @ID INT      
    DECLARE @DATE DATETIME      
    SET @DATE = (SELECT GETDATE())      
    SET @ID = 1      
      
    WHILE(@ID <= (SELECT COUNT(1) FROM #CLIENT))      
    BEGIN      
      
        SET @DATE = (SELECT SCB_RESPONSE_DATE FROM #CLIENT WHERE ID = @ID)      
              
        PRINT CONVERT(VARCHAR(11),@DATE)      
              
        SET @COUNT = ( SELECT COUNT(*)      
                        FROM #HOLIDAY       
                        WHERE NO_WORKING BETWEEN @DATE AND GETDATE()      
                     )      
              
        UPDATE #CLIENT      
        SET [HCOUNT] = @COUNT      
        WHERE ID = @ID      
          
        SET @ID = @ID + 1      
      
    END      
      
      
    /*******************************************************************************************      
        DELETING THOSE CLIENTS WHOSE DAYS ARE LESS THAN 30      
    ********************************************************************************************/      
      
    DELETE FROM #CLIENT      
    WHERE ([COUNT] - [HCOUNT]) < 30      
      
    UPDATE TM      
    SET TM.ECS_STATUS = 'A',      
        SCB_REMARK = 'APPROVED THROUGH ECS ACTIVATION JOB'  
    FROM TBL_ECS_REG_MASTER TM      
        INNER JOIN #CLIENT C ON TM.SCB_RESPONSE_DATE = C.SCB_RESPONSE_DATE AND TM.PARTY_CODE = C.PARTY_CODE AND TM.DP_ID = C.DP_ID      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RPT_ECS_CONSECUTIVE_FAILURE
-- --------------------------------------------------
/******************************************************************************                  
                  
CREATED BY :: RUTVIJ PATIL                  
CREATED DATE :: 03 SEPT 2011                  
PURPOSE :: TO DISPLAY CONSECUTIVE FAILURE REPORT                   
                  
MODIFIED BY ::                   
MODIFIED DATE ::                  
PURPOSE ::                  
                  
*******************************************************************************/                  
                  
CREATE PROCEDURE [dbo].[USP_RPT_ECS_CONSECUTIVE_FAILURE] --'','',''                  
                  
    @DP_ID VARCHAR(16),                
    @ACCESS_TO varchar(20),                  
    @ACCESS_CODE varchar(20)                
                  
AS                  
                  
BEGIN                  
                  
    IF(@DP_ID = '')                  
    BEGIN                  
                      
        /*******************************************************************************************                  
            GETTING ALL CLIENTS TRANSACTION DATA                  
        ********************************************************************************************/                  
        ---Start Comment Amit 05-Dec-2011            
        /*SELECT ID = IDENTITY(INT,1,1),                  
            DP_ID,                  
            MONTH,                  
            YEAR,                  
            TRAN_STATUS                  
        INTO #TEMP                  
        FROM DBO.TBL_ECS_TRANSACTION                  
        ORDER BY DP_ID,YEAR,MONTH                  
                  
        /*******************************************************************************************                  
            GETTING MAX ID FOR EACH CLIENTS FAILURE TRANSACTION                  
        ********************************************************************************************/                  
                  
        SELECT DP_ID,ID = MAX(ID),MONTH,YEAR                  
        INTO #DEL                  
        FROM #TEMP                  
        WHERE TRAN_STATUS = 'F'                  
        GROUP BY DP_ID,MONTH,YEAR                  
        ORDER BY DP_ID,YEAR,MONTH                  
                              
        /*******************************************************************************************                  
            DELETING ALL TRANSACTION BEFORE LAST CONSECUTIVE FAIL TRANSACTION                  
        ********************************************************************************************/                   
                              
        DELETE T                  
        FROM #TEMP T                   
            INNER JOIN #DEL D ON T.DP_ID = D.DP_ID AND T.ID < D.ID                  
                              
        DROP TABLE #DEL    */              
                    
        ---end Comment Amit 05-Dec-2011              
        ---added by Amit 05-Dec-2011              
        ;WITH cte AS (             
        SELECT    DP_ID  ,            
                  FailDate=cast(cast(year as varchar)+'-'+cast(month as varchar)+'-01' as datetime),            
                  YEAR*12 + MONTH AS YM            
         FROM     TBL_ECS_TRANSACTION where TRAN_STATUS='F'        
    and Scb_tran_date>DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())-2,0))          
         ),            
         cte1 AS (             
        SELECT    DP_ID  ,            
                  FailDate,            
                  YM,            
                  YM - DENSE_RANK() OVER (PARTITION BY DP_ID ORDER BY YM) AS G            
         FROM     cte            
         ),            
         cte2 As            
         (            
            SELECT DP_ID  ,            
                  MIN(FailDate) AS Mn,            
                  MAX(FailDate) AS Mx            
           FROM cte1            
           GROUP BY DP_ID, G            
           HAVING MAX(YM)-MIN(YM) >=1             
         )            
        SELECT     c.DP_ID,c.MONTH,c.YEAR,c.TRAN_STATUS            
        into #temp            
        FROM         TBL_ECS_TRANSACTION AS c             
        INNER JOIN  cte2 c2 ON c2.DP_ID = c.DP_ID            
        where c.TRAN_STATUS='F' and Scb_tran_date>DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())-2,0))             
        order by c.DP_ID            
                              
        /*******************************************************************************************                  
            SELECTING FINAL DATA FOR DISPLAY IN REPORT                  
        ********************************************************************************************/                  
                              
        SELECT [DP ID] = T.DP_ID,                  
            [CLIENT CODE] = M.PARTY_CODE,                  
            [CLIENT NAME] = M.PARTY_NAME,                  
            --[COUNT OF SUCCESSIVE FAILURE] = COUNT(T.DP_ID)                  
            [COUNT OF SUCCESSIVE FAILURE] = '<A HREF="\..\WEBAPPNEW\ECS\Reports\rptConsecutiveTransactionFailure.aspx?DP_ID='+ CONVERT(VARCHAR,T.DP_ID) + '"> ' +  CONVERT(VARCHAR,COUNT(T.DP_ID)) + '</A>'                  
        FROM #TEMP T                  
            INNER JOIN TBL_ECS_REG_MASTER M ON T.DP_ID = M.DP_ID           
        where  ECS_Status<>'D'                 
        GROUP BY T.DP_ID,M.PARTY_CODE,M.PARTY_NAME                  
        HAVING COUNT(T.DP_ID) > 1                  
                          
        DROP TABLE #TEMP                  
        Select ''                
        Select '<b> ECS More than 1 Consecutive Failure Report </b>'              
    END                  
                      
    IF(@DP_ID <> '')                  
    BEGIN                  
                      
        SELECT distinct [DP ID] = T.DP_ID,                  
            [CLIENT CODE] = M.PARTY_CODE,                  
            [MONTH & YEAR] = Cast(T.MONTH as varchar)+'-'+Cast(T.YEAR as varchar),                  
            [REASON FOR FAILURE] = RES.SCB_REMARK                  
        FROM TBL_ECS_TRANSACTION T                  
            INNER JOIN   
            (Select PARTY_CODE,dp_id from TBL_ECS_REG_MASTER where ECS_Status<>'D') M   
            ON T.DP_ID = M.DP_ID                  
            INNER JOIN TBL_ECS_TRAN_RESPONSE RES  
            ON T.DP_ID = RES.DP_ID  and  T.ref_no = RES.ref_no               
        WHERE T.DP_ID = @DP_ID and  T.TRAN_STATUS = 'F' --and M.ECS_Status<>'D'      
        and Scb_tran_date>DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())-2,0))  
        Select ''                
        Select '<b> ECS More than 1 Consecutive Failure Report for DP ID '+@DP_ID+'</b>'  
    END                  
                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RPT_ECS_DEBIT_MIS
-- --------------------------------------------------
  
/************************************************************************************        
        
    CREATED BY :: RUTVIJ PATIL        
    CREATED DATE :: 26 JULY 2011        
    REASON :: USE TO DISPLAY DEBIT MIS REPORT    
        
    MODIFIED BY ::        
    MODIFIED DATE ::        
    REASON ::         
        
************************************************************************************/        
    
--USP_RPT_ECS_DEBIT_MIS 'ZONE','%',2010,2011,1,12,'BROKER','CSO'    
    
CREATE PROCEDURE [dbo].[USP_RPT_ECS_DEBIT_MIS]    
    
    @REPORT_LEVEL VARCHAR(20),    
    @REPORT_VALUE VARCHAR(20),    
    @FROM_YEAR NUMERIC(4),     
    @TO_YEAR NUMERIC(4),     
    @FROM_MONTH INT,     
    @TO_MONTH INT,    
    @ACCESS_TO VARCHAR(25),    
    @ACCESS_CODE VARCHAR(25)    
    
AS    
    
BEGIN    
        
    DECLARE @STR_SQL VARCHAR(MAX)    
    DECLARE @STR_CONDITION  VARCHAR(MAX)    
        
    SET @STR_SQL = ''    
    SET @ACCESS_CODE = LTRIM(RTRIM(@ACCESS_CODE))                                        
    SET @ACCESS_TO = LTRIM(RTRIM(@ACCESS_TO))      
        
    IF(UPPER(@REPORT_VALUE) = 'ALL')                                      
    BEGIN    
        SET @REPORT_VALUE = '%'    
    END    
                                            
    /*************************************************************************************                                                
        SETTING FILTER LEVEL ACCORDING TO ACCESS LEVELS                                        
    *************************************************************************************/       
                                            
    SET @STR_CONDITION = ''                                        
                     
    IF @ACCESS_TO = 'SB'                                                                 
    SET @STR_CONDITION = @STR_CONDITION + 'AND CV.SB = '''+@ACCESS_CODE+''''                                             
                                        
    ELSE IF @ACCESS_TO = 'SBMAST'                                                                 
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CV.SB IN  (SELECT DISTINCT SUB_BROKER FROM RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'                                                            
                                        
    ELSE IF @ACCESS_TO = 'REGION'                                                                                                                         
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.REGION = '''+@ACCESS_CODE+''''                                                     
                                        
    ELSE IF @ACCESS_TO = 'BRANCH'                                                
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH = '''+@ACCESS_CODE+''''                                                                                           
                                        
    ELSE IF @ACCESS_TO = 'BRMAST'                                                                                           
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CV.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                          
                                        
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                        
    SET @STR_CONDITION =  @STR_CONDITION + ' '     
                                                  
        
    /******************************************************************************************     
        GETTING REQUIRED CLIENT CODES ONLY    
    ******************************************************************************************/    
        
    SET @STR_SQL = @STR_SQL +     
        
    '    
    SELECT CV.ZONE,    
        CV.REGION,    
        CV.BRANCH,    
        CV.SB,    
        PARTY_CODE=CV.CLIENT,    
        CV.PARTY_NAME,    
        CD.B2C     
    INTO #PARTY    
    FROM INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CV  WITH(NOLOCK)      
        INNER JOIN INTRANET.RISK.DBO.CLIENT_DETAILS CD ON CV.CLIENT = CD.PARTY_CODE    
    WHERE CV.' + @REPORT_LEVEL + ' LIKE ''' + @REPORT_VALUE + '''' + @STR_CONDITION + '    
        
    INSERT INTO #PARTY    
    SELECT CV.ZONE,    
        CV.REGION,    
        CV.BRANCH,    
        CV.SB,    
        PARTY_CODE=CV.CLIENT,    
        CV.PARTY_NAME,    
        CD.B2C     
    FROM INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CV   WITH(NOLOCK)    
        INNER JOIN INTRANET.RISK.DBO.CLIENT_DETAILS_OTHERS CD  WITH(NOLOCK)  ON CV.CLIENT = CD.PARTY_CODE    
    WHERE CV.' + @REPORT_LEVEL + ' LIKE ''' + @REPORT_VALUE + '''' + @STR_CONDITION + '      
        
    SELECT     
        TR.YEAR,    
        TR.MONTH,    
        ZONE,REGION,BRANCH,SB,    
        M.PARTY_CODE,    
        M.PARTY_NAME,    
        [ECS DEBIT AMOUNT] = TR.AMOUNT / 100,    
        [SETTLEMENT DATE] = convert(varchar(11),PROCESSED_DATE,103),    
        TRAN_STATUS = CASE WHEN (TRAN_STATUS = ''S'') THEN ''SUCCESSFUL'' WHEN (TRAN_STATUS = ''P'') THEN ''PENDING'' ELSE ''FAILED'' END,    
        [TRAN DATE] =  convert(varchar(11),SCB_TRAN_DATE,103),    
        P.B2C,    
        TR.DP_ID    
    INTO #TRAN    
    FROM TBL_ECS_TRANSACTION TR  WITH(NOLOCK)    
        INNER JOIN TBL_ECS_REG_MASTER M ON TR.DP_ID = M.DP_ID    
        INNER JOIN #PARTY P ON M.PARTY_CODE = P.PARTY_CODE    
    WHERE [YEAR] BETWEEN ' + CONVERT(VARCHAR(4),@FROM_YEAR) + ' AND ' + CONVERT(VARCHAR(4),@TO_YEAR) + ' AND [MONTH] BETWEEN ' + CONVERT(VARCHAR(2),@FROM_MONTH) + ' AND ' + CONVERT(VARCHAR(2),@TO_MONTH) +     
        
    '    
    SELECT TR.*,    
        RES.REMARK_CODE,    
        RES.SCB_REMARK,    
        [FAILURE COUNT] = 0    
    INTO #FINAL_DATA    
    FROM #TRAN TR   WITH(NOLOCK)   
        INNER JOIN TBL_ECS_TRAN_RESPONSE RES ON TR.DP_ID = RES.DP_ID     
        INNER JOIN TBL_ECS_TRAN_UPLOAD_LOG L ON RES.[FILE_NAME] = L.TRAN_FILE_NAME    
    WHERE TR.YEAR BETWEEN ' + CONVERT(VARCHAR(4),@FROM_YEAR) + ' AND ' + CONVERT(VARCHAR(4),@TO_YEAR) + ' AND TR.MONTH BETWEEN ' + CONVERT(VARCHAR(2),@FROM_MONTH) + ' AND ' + CONVERT(VARCHAR(2),@TO_MONTH) +  
      '  
    ORDER BY TR.YEAR,TR.MONTH    
        
    SELECT [YEAR-MONTH] = CONVERT(VARCHAR(4),YEAR) + ''-''+ CONVERT(VARCHAR(4),MONTH),     
        REGION,BRANCH,[SUB BROKER] = SB,    
        [CLIENT TYPE] = CASE B2C WHEN ''Y'' THEN ''B2C'' ELSE ''B2B'' END,    
        [CLIENT CODE] = PARTY_CODE,    
        [CLIENT NAME] = PARTY_NAME,    
        [ECS DEBIT AMOUNT] =convert(numeric(18,2),[ECS DEBIT AMOUNT]),    
        [SETTLEMENT DATE],    
        [STATUS] = TRAN_STATUS,    
        [SUCCESS/FAILURE DATE] = [TRAN DATE],    
        [REMARK] = SCB_REMARK,    
        [FAILURE COUNT]    
    FROM #FINAL_DATA   WITH(NOLOCK)   
        
    '    
        
    PRINT @STR_SQL    
    EXEC(@STR_SQL)    
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RPT_ECS_REGISTRATION
-- --------------------------------------------------
                            
/*******************************************************************************************                                                            
                                                            
CREATED BY :: RUTVIJ PATIL                                                            
CREATED DATE :: 21 JULY 2011                                                            
PURPOSE :: USE TO DISPLAY ECS REGISTRATION REPORT                                                            
                                                            
MODIFIED BY ::                                                            
MODIFIED DATE ::                                                            
PURPOSE ::                                                            
                
*******************************************************************************************/                              
                            
--USP_RPT_ECS_REGISTRATION 'CLIENT','PUK002','BROKER','CSO','1','',''                            
                            
CREATE PROCEDURE [dbo].[USP_RPT_ECS_REGISTRATION]                            
                            
    @REPORT_LEVEL VARCHAR(25),                                                            
    @REPORT_VALUE VARCHAR(25),                                                
    @ACCESS_TO VARCHAR(25),                                                    
    @ACCESS_CODE VARCHAR(25),                        
    @CHK_DATE VARCHAR(1),                            
    @FROM_DATE VARCHAR(11),                        
    @TO_DATE VARCHAR(11)                        
                                
AS                            
BEGIN                            
                            
    SET @ACCESS_CODE = LTRIM(RTRIM(@ACCESS_CODE))                                                    
    SET @ACCESS_TO = LTRIM(RTRIM(@ACCESS_TO))                                                    
                                                        
    DECLARE @STR_CONDITION VARCHAR(MAX)                            
    DECLARE @STR_SQL VARCHAR(MAX)                            
    DECLARE @DATE_COND VARCHAR(MAX)                            
                            
    /*************************************************************************************                                                            
        SETTING FILTER LEVEL ACCORDING TO ACCESS LEVELS                                                    
    *************************************************************************************/                                   
                                
    SET @STR_CONDITION = ''                                                    
    SET @STR_SQL = ''                            
    SET @DATE_COND = ''                            
                                
    IF(@CHK_DATE = '1')                            
    BEGIN                            
        SET @DATE_COND = ' AND ECS.CSO_RECEIVED_DATE BETWEEN ''' + CONVERT(VARCHAR(10),CONVERT(DATETIME,@FROM_DATE,103),101) + ''' AND ''' + CONVERT(VARCHAR(10),CONVERT(DATETIME,@TO_DATE,103),101) + ''''                            
    END                            
                                
    IF(@REPORT_VALUE = 'ALL')                            
    BEGIN                            
        SET @REPORT_VALUE = '%'                            
    END                            
                                                        
    IF @ACCESS_TO='SB'                                                                             
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB = '''+@ACCESS_CODE+''''                                                                                                                                           
                                                    
    ELSE IF @ACCESS_TO='ZONE'                                                                             
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.ZONE ='''+@ACCESS_CODE+''''            
                                
    ELSE IF @ACCESS_TO='SBMAST'                              
    SET @STR_CONDITION =  @STR_CONDITION + 'AND CD.SB IN  (SELECT DISTINCT SUB_BROKER FROM INTRANET.RISK.DBO.SB_MASTER WHERE SBMAST_CD='''+@ACCESS_CODE+''')'               
                                                    
    ELSE IF @ACCESS_TO = 'REGION'                                                                                             
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.REGION = '''+@ACCESS_CODE+''''                                                                 
                                          ELSE IF @ACCESS_TO='BRANCH'                                              
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH = '''+@ACCESS_CODE+''''                       
                                                    
    ELSE IF @ACCESS_TO = 'BRMAST'                               
    SET @STR_CONDITION =  @STR_CONDITION + ' AND CD.BRANCH IN (SELECT DISTINCT BRANCH_CD FROM INTRANET.RISK.DBO.BRANCH_MASTER WHERE BRMAST_CD= '''+@ACCESS_CODE+''')'                                                                                      
                                                    
    ELSE IF @ACCESS_TO = 'BROKER'                                                                                                                                    
    SET @STR_CONDITION =  @STR_CONDITION + ' '                             
                                
    SET @STR_SQL = @STR_SQL +                            
    '                            
    SELECT                             
        [CSO RECEIVED DATE] = CONVERT(VARCHAR(11),CSO_RECEIVED_DATE),                            
        BRANCH = CD.BRANCH,                
        [SUB BROKER] = CD.SB,                
        [PARTY CODE] = PARTY_CODE, 
        [PARTY NAME] = ECS.PARTY_NAME,               
        [DP ID] = DP_ID,                
        [BANK NAME] = replace(BANK_NAME,'','','' ''),                
        [BANK ACCNO] = BANK_ACCNO,                
        [MICR CODE] = MICR_CODE,
        [SCB Response Date]=CONVERT(VARCHAR(11),SCB_Response_Date),
        [ECS STATUS] = CASE ECS_STATUS        
      WHEN ''CR'' THEN ''CSO Reject''      
      WHEN ''CA'' THEN ''CSO Approve''       
      WHEN ''DTC'' THEN ''Dispatched To CSO''      
      WHEN ''BE'' THEN ''Branch Entry''              
                        WHEN ''P'' THEN ''Pending''                
                        WHEN ''A'' THEN ''Active''                
                        WHEN ''R'' THEN ''Rejected''                
                        WHEN ''D'' THEN ''Deactivated''                
                    END,                
        [ENTERED BY] = ENTERED_BY,                
        [SCB REMARK] = ISNULL(SCB_REMARK,''''),                
        [SCB DEST REMARK] = ISNULL(SCB_DEST_REMARK,''''),                
        [ECS FORM]=''<A HREF="\..\WEBAPPNEW\ECS\MASTERS\frmECSImageHolder.aspx?PARTYCODE=''+ECS.PARTY_CODE+''&DPID=''+DP_ID+''&STATUS='' + ECS_STATUS + ''&ImageName=ECS_FORM_IMAGE" TARGET="_self"> SHOW IMAGE</A>''                
        ,[ECS CHEQUE]=''<A HREF="\..\WEBAPPNEW\ECS\MASTERS\frmECSImageHolder.aspx?PARTYCODE=''+ECS.PARTY_CODE+''&DPID=''+DP_ID+''&STATUS='' + ECS_STATUS + ''&ImageName=ECS_CHEQUE_IMAGE" TARGET="_self"> SHOW IMAGE</A>''        
    FROM TBL_ECS_REG_MASTER ECS                
    INNER JOIN INTRANET.RISK.DBO.VW_RMS_ALL_CLIENT_VERTICAL CD ON ECS.PARTY_CODE = CD.CLIENT                
    WHERE CD.' + @REPORT_LEVEL + ' LIKE '''+ @REPORT_VALUE + '''' + @STR_CONDITION + @DATE_COND                
                
    --PRINT @STR_SQL                
    EXEC(@STR_SQL)                
                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPDATE_ECS_REG_MASTER
-- --------------------------------------------------
/*******************************************************************************************                                        
                                        
CREATED BY :: RUTVIJ PATIL                                        
CREATED DATE :: 21 JULY 2011                                        
PURPOSE :: USE TO UPDATE ECS REGISTRATION REPORT                                        
                                        
MODIFIED BY ::                                        
MODIFIED DATE ::                                        
PURPOSE ::                                        
    
*******************************************************************************************/          

CREATE PROCEDURE [dbo].[USP_UPDATE_ECS_REG_MASTER]

    @PARTY_CODE VARCHAR(15),
    @DP_ID VARCHAR(16),
    @ECS_STATUS VARCHAR(3),
    @CSO_REMARK VARCHAR(500),
    @UPDATED_BY VARCHAR(20)

AS
BEGIN

    DECLARE @STATUS VARCHAR(3)
    
    /* USE TO GET LAST ENTRED STATUS FOR PARTY CODE */
    SET @STATUS = (
                    SELECT TOP 1 ECS_STATUS
                    FROM TBL_ECS_REG_MASTER
                    WHERE PARTY_CODE = @PARTY_CODE
                    ORDER BY ENTERED_DATE DESC
                  )
    
    UPDATE TBL_ECS_REG_MASTER
    SET ECS_STATUS = @ECS_STATUS,
        CSO_REMARK = @CSO_REMARK,
        UPDATED_BY = @UPDATED_BY,
        ECS_DEACTIVE_DATE  = GETDATE()
    WHERE DP_ID = @DP_ID AND ECS_STATUS = @STATUS

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_ECS_REG_RESPONSE
-- --------------------------------------------------
/************************************************************************************              
              
    CREATED BY :: RUTVIJ PATIL              
    CREATED DATE :: 26 JULY 2011              
    REASON :: USE TO UOLOAD SCB RESPONSE FILE OF ECS REGISTRATION              
              
    MODIFIED BY :: RUTVIJ PATIL    
    MODIFIED DATE :: 30 AUG 2011    
    REASON :: TO IMPLEMENT 30 DAYS WORKING LOGIN     
              
************************************************************************************/              
              
CREATE PROCEDURE [dbo].[USP_UPLOAD_ECS_REG_RESPONSE]      
(              
    @FILENAME AS VARCHAR(100),                      
    @USERNAME AS VARCHAR(20)               
)      
                
AS                
              
    BEGIN TRAN              
                  
    INSERT INTO TBL_ECS_REG_RESPONSE              
    SELECT LTRIM(RTRIM(SRNO)),              
        LTRIM(RTRIM(DP_ID)),              
        LTRIM(RTRIM(PARTY_NAME)),              
        LTRIM(RTRIM(AC_HOLDER_NAME)),              
        LTRIM(RTRIM(BANK_NAME)),              
        LTRIM(RTRIM(BRANCH_NAME)),              
        LTRIM(RTRIM(BANK_ACCNO)),              
        LTRIM(RTRIM(MICR_CODE)),              
        LTRIM(RTRIM(BANK_ACC_TYPE)),              
        --LTRIM(RTRIM(CSO_RECEIVED_DATE)),              
        CONVERT(DATETIME,(RIGHT(LTRIM(RTRIM(CSO_RECEIVED_DATE)),4) + '-' + SUBSTRING(LTRIM(RTRIM(CSO_RECEIVED_DATE)),3,2) + '-' +  SUBSTRING(LTRIM(RTRIM(CSO_RECEIVED_DATE)),1,2))),                                      
        --LTRIM(RTRIM(ECS_EXPIRY_DATE)),              
        CONVERT(DATETIME,(RIGHT(LTRIM(RTRIM(ECS_EXPIRY_DATE)),4) + '-' + SUBSTRING(LTRIM(RTRIM(ECS_EXPIRY_DATE)),3,2) + '-' +  SUBSTRING(LTRIM(RTRIM(ECS_EXPIRY_DATE)),1,2))),                                      
        LTRIM(RTRIM(ECS_UPPER_LIMIT)),              
        CASE LTRIM(RTRIM(ECS_STATUS)) WHEN 'APPROVED' THEN 'A'              
                        WHEN 'FINAL REJECTED' THEN 'R'              
                        END,              
        LTRIM(RTRIM(SCB_REMARK)),              
        @USERNAME,              
        GETDATE(),              
        @FILENAME              
    FROM TBL_ECS_REG_RESPONSE_TEMP              
                  
    UPDATE M              
    SET     
        /* [+][30/08/2011][RUTVIJ PATIL]    
        M.SCB_REMARK = LTRIM(RTRIM(T.SCB_REMARK)),              
        M.ECS_STATUS = CASE LTRIM(RTRIM(T.ECS_STATUS)) WHEN 'APPROVED' THEN 'A'              
                        WHEN 'FINAL REJECTED' THEN 'R'              
                        END,              
        [-][30/08/2011][RUTVIJ PATIL]*/    
            
        M.SCB_REMARK = CASE WHEN (T.ECS_STATUS ='APPROVED') THEN 'PENDING FROM DESTINATION BANK'    
                            ELSE T.SCB_REMARK     
                            END,    
        M.ECS_STATUS = CASE LTRIM(RTRIM(T.ECS_STATUS)) WHEN 'APPROVED' THEN 'P'    
                        WHEN 'FINAL REJECTED' THEN 'R'              
                        END,              
        M.ECS_ACTIVE_DATE = CASE LTRIM(RTRIM(T.ECS_STATUS)) WHEN 'APPROVED' THEN CONVERT(DATETIME,(RIGHT(LTRIM(RTRIM(T.CSO_RECEIVED_DATE)),4) + '-' + SUBSTRING(LTRIM(RTRIM(T.CSO_RECEIVED_DATE)),3,2) + '-' +  SUBSTRING(LTRIM(RTRIM(T.CSO_RECEIVED_DATE)),1,2))) END,
        M.ECS_DEACTIVE_DATE = CASE LTRIM(RTRIM(T.ECS_STATUS)) WHEN 'APPROVED' THEN GETDATE() END,      
        M.SCB_RESPONSE_DATE = GETDATE()      
    FROM TBL_ECS_REG_MASTER M      
        INNER JOIN TBL_ECS_REG_RESPONSE_TEMP T ON M.DP_ID = T.DP_ID AND M.ECS_STATUS = 'P' AND M.REQ_STATUS = 1              
                      
    --TRUNCATE TABLE TBL_ECS_REG_RESPONSE_TEMP               
                
    IF(@@ERROR = 0)        
    BEGIN        
        COMMIT TRAN            
    END     
           
    ELSE        
    BEGIN        
        ROLLBACK TRAN               
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_ECS_TRAN_RESPONSE
-- --------------------------------------------------
/************************************************************************************                                        
                                        
    CREATED BY :: RUTVIJ PATIL                                        
    CREATED DATE :: 26 JULY 2011                                        
    REASON :: USE TO UPLOAD SCB RESPONSE FILE OF ECS TRANSACTION                                        
                                        
    MODIFIED BY ::                                        
    MODIFIED DATE ::                                        
    REASON ::                                         
                                        
************************************************************************************/                                        
                  
CREATE PROCEDURE [dbo].[USP_UPLOAD_ECS_TRAN_RESPONSE]                  
(                                        
    @FILENAME AS VARCHAR(100),                                                
    @USERNAME AS VARCHAR(20),                                  
    @MONTH VARCHAR(20),                                  
    @YEAR VARCHAR(20)                                       
)                                        
                                        
AS                                        
                                        
BEGIN                                        
                            
   BEGIN TRAN                      
                                             
   DECLARE @COUNT INT,                      
   @MNT INT,                                  
   @YR NUMERIC(4)                   
                      
   SET @MNT = CONVERT(INT,@MONTH)                  
   SET @YR = CONVERT(NUMERIC(4) ,@YEAR)                  
                                            
   SET @COUNT = (SELECT COUNT(*) FROM TBL_ECS_TRAN_UPLOAD_LOG WHERE TRAN_FILE_NAME = @FILENAME)                                        
                                            
    /***************************************************************************************************                                        
            USE TO AVOID UPLADING DUPLICATE FILES                                        
    ***************************************************************************************************/                                        
    IF(@COUNT < 1)                                        
    BEGIN                                        
                                            
        DECLARE @SCB_REMARK VARCHAR(40)                                        
        DECLARE @REMARK_CODE INT                                        
        DECLARE @LOT_NO INT                                        
        DECLARE @DATE VARCHAR(10)                                        
        --DECLARE @MNT INT                                        
        --DECLARE @YR NUMERIC(4)                                        
                                          
                                            
        /***************************************************************************************************                                        
            USE TO READ MONTH, YEAR AND LOT NO FROM FILE NAME                                        
        ***************************************************************************************************/                                        
                                                
        --SET @LOT_NO = CONVERT(INT,RIGHT(@FILENAME,2))                            
        SET @LOT_NO = CONVERT(INT,dbo.RemoveNonNumeric(@FILENAME))                                 
                                        
        /*                                      
        IF((CHARINDEX('SUCC', @FILENAME, 0)) > 0)                                        
        BEGIN                                        
            SET @SCB_REMARK = 'SUCCESS'                                        
            SET @REMARK_CODE = 1                 
            SET @DATE = REPLACE(@FILENAME,'ANGESUCC','')                                        
        END                                        
                                                
        IF((CHARINDEX('FAIL', @FILENAME, 0)) > 0)                                        
        BEGIN                                        
            SET @DATE = REPLACE(@FILENAME,'ANGEFAIL','')                                        
        END                                        
                                                
		SET @LOT_NO = SUBSTRING(@DATE,7,2)                                        
        SET @DATE = SUBSTRING(@DATE,1,6)                                        
        SET @MNT = SUBSTRING(@DATE,3,2)                                        
        SET @YR = SUBSTRING(@DATE,5,2)                                        
                                       
        IF(@YR = 1)                                        
        BEGIN                                        
            SET @YR = (SELECT CASE WHEN @YR = 1 THEN DATEPART(YY,GETDATE()) END)                                        
        END                                          
        ELSE                                        
        BEGIN                                        
            SET @YR = SUBSTRING(CONVERT(VARCHAR(4),DATEPART(YY,GETDATE())),1,2) + CONVERT(VARCHAR(2),@YR)                                        
        END                                         
                                     
        */                                    
        /***************************************************************************************************                                      
            USE TO INSERT VALUES INTO TBL_ECS_TRAN_RESPONSE                                            
        ***************************************************************************************************/                                        
                                                
        INSERT INTO TBL_ECS_TRAN_RESPONSE                                            
        SELECT LTRIM(RTRIM([SR NO])),                                        
            LTRIM(RTRIM(DP_ID)),                                        
            LTRIM(RTRIM(ITEM_SEQ_NO)),                                        
            LTRIM(RTRIM(APPLICANT_NAME)),                                        
            LTRIM(RTRIM(AMOUNT)),                                        
            SETTLEMENT_DATE = CONVERT(DATETIME,(RIGHT(LTRIM(RTRIM(SETTLEMENT_DATE)),4) + '-' + SUBSTRING(LTRIM(RTRIM(SETTLEMENT_DATE)),3,2) + '-' +  SUBSTRING(LTRIM(RTRIM(SETTLEMENT_DATE)),1,2))),                                        
            REF_NO,                                
            TRAN_STATUS,                                
            @USERNAME,                                        
            GETDATE(),                                        
            @FILENAME,                                        
            CASE WHEN REMARK_CODE IS NOT NULL THEN CONVERT(VARCHAR,LTRIM(RTRIM(REMARK_CODE))) ELSE '0' END,                                        
            CASE WHEN SCB_REMARK IS NOT NULL THEN LTRIM(RTRIM(SCB_REMARK)) ELSE '' END                                        
        FROM TBL_ECS_TRAN_RESPONSE_TEMP                                        
                                                                           
        /***************************************************************************************************                                        
            USE TO UPDATE TRANSACTION FLAG AND SCR TRANSACTION DATE                                    
            INTO TBL_ECS_TRANSACTION                                               
        ***************************************************************************************************/                                        
                                              
        UPDATE T                      
        SET --T.TRAN_STATUS = CASE WHEN TR.SCB_REMARK IS NULL THEN 'S' ELSE 'F' END,                                    
            T.TRAN_STATUS = (case TR.TRAN_STATUS when 'NA' then '' else TR.TRAN_STATUS end) ,                                  
            SCB_TRAN_DATE = TR.SETTLEMENT_DATE                    
        FROM TBL_ECS_TRANSACTION T                                      
            INNER JOIN TBL_ECS_TRAN_RESPONSE TR ON T.DP_ID = TR.DP_ID AND T.TRAN_STATUS = 'P' AND T.REF_NO = TR.REF_NO                                      
                                                
        /***************************************************************************************************                                              USE TO SEND TRANSACTION STATUS SMS TO CLIENTS              
        ***************************************************************************************************/                                        
        EXEC DBO.USP_ECS_TRAN_STATUS_SMS @USERNAME, @MONTH, @YEAR              
                      
        /***************************************************************************************************                                        
            USE TO INSERT VALUES TO LOG TABLE                                       
        ***************************************************************************************************/                                        
                            
        INSERT INTO TBL_ECS_TRAN_UPLOAD_LOG                                        
        VALUES(@FILENAME,@LOT_NO,Substring(Convert(varchar,@LOT_NO),3,2),'20'+Substring(Convert(varchar,@LOT_NO),5,2)
				,@USERNAME,GETDATE())                    
                                       
    END                                        
                                        
    TRUNCATE TABLE TBL_ECS_TRAN_RESPONSE_TEMP               
                  
    IF(@@ERROR = 0)                            
    BEGIN                            
        COMMIT TRAN                            
    END                            
    ELSE                             
    BEGIN                            
        ROLLBACK TRAN                            
    END                                        
                                            
END

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_DEACTIVE_PROCESS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_DEACTIVE_PROCESS_LOG]
(
    [SR_NO] INT IDENTITY(1,1) NOT NULL,
    [ECS_DEC_FILE_NAME] VARCHAR(20) NULL,
    [LOT_NO] INT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_EXCEED_TRAN_LIMIT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_EXCEED_TRAN_LIMIT]
(
    [PARTY_CODE] VARCHAR(15) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [MONTH] INT NOT NULL,
    [YEAR] NUMERIC(4, 0) NOT NULL,
    [ECS_UPPER_LIMIT] NUMERIC(13, 0) NULL,
    [ECS_TRAN_AMOUNT] NUMERIC(13, 0) NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_GEN_PROCESS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_GEN_PROCESS_LOG]
(
    [SR_NO] INT IDENTITY(1,1) NOT NULL,
    [ECS_REG_FILE_NAME] VARCHAR(20) NULL,
    [LOT_NO] INT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_REG_MASTER_RENAMED_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_REG_MASTER_RENAMED_PII]
(
    [PARTY_CODE] VARCHAR(15) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [MICR_CODE] VARCHAR(24) NULL,
    [BANK_NAME] VARCHAR(100) NULL,
    [BANK_ACCNO] VARCHAR(20) NULL,
    [BANK_ACC_TYPE] VARCHAR(11) NULL,
    [SCHEME_NAME] VARCHAR(20) NULL,
    [PERIODICITY] VARCHAR(20) NULL,
    [ECS_FORM_IMAGE] VARBINARY(MAX) NULL,
    [ECS_UPPER_LIMIT] MONEY NULL,
    [CSO_RECEIVED_DATE] DATETIME NULL,
    [ECS_ACTIVE_DATE] DATETIME NULL,
    [ECS_DEACTIVE_DATE] DATETIME NULL,
    [ECS_EXPIRY_DATE] DATETIME NULL,
    [ECS_STATUS] VARCHAR(3) NOT NULL,
    [SCB_REMARK] VARCHAR(500) NULL,
    [SCB_DEST_REMARK] VARCHAR(500) NULL,
    [CSO_REMARK] VARCHAR(500) NULL,
    [ENTERED_BY] VARCHAR(20) NULL,
    [ENTERED_DATE] DATETIME NULL,
    [REQ_STATUS] INT NULL,
    [UPDATED_BY] VARCHAR(20) NULL,
    [SCB_RESPONSE_DATE] DATETIME NULL DEFAULT (getdate()),
    [ECS_CHEQUE_IMAGE] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_REG_RESPONSE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_REG_RESPONSE]
(
    [SRNO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [PARTY_NAME] VARCHAR(40) NULL,
    [AC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [BANK_ACCNO] VARCHAR(18) NULL,
    [MICR_CODE] VARCHAR(9) NULL,
    [BANK_ACC_TYPE] VARCHAR(2) NULL,
    [CSO_RECEIVED_DATE] DATETIME NULL,
    [ECS_EXPIRY_DATE] DATETIME NULL,
    [ECS_UPPER_LIMIT] MONEY NULL,
    [ECS_STATUS] CHAR(1) NULL,
    [SCB_REMARK] VARCHAR(500) NULL,
    [UPDATED_BY] VARCHAR(20) NULL,
    [UPDATED_DATE] VARCHAR(20) NULL,
    [FILE_NAME] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_REG_RESPONSE_TEMP_RENAMED_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_REG_RESPONSE_TEMP_RENAMED_PII]
(
    [SRNO] VARCHAR(10) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [PARTY_NAME] VARCHAR(40) NULL,
    [AC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [BANK_ACCNO] VARCHAR(18) NULL,
    [MICR_CODE] VARCHAR(9) NULL,
    [BANK_ACC_TYPE] VARCHAR(2) NULL,
    [CSO_RECEIVED_DATE] VARCHAR(8) NULL,
    [ECS_EXPIRY_DATE] VARCHAR(8) NULL,
    [ECS_UPPER_LIMIT] MONEY NULL,
    [ECS_STATUS] VARCHAR(40) NULL,
    [SCB_REMARK] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_ALERT_SMS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_ALERT_SMS_LOG]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROCESSED_BY] VARCHAR(50) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_FILE_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_FILE_LOG]
(
    [SR_NO] INT IDENTITY(1,1) NOT NULL,
    [TRAN_FILE_NAME] VARCHAR(20) NULL,
    [LOT_NO] INT NULL,
    [MONTH] INT NULL,
    [YEAR] NUMERIC(4, 0) NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_PROCESS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_PROCESS_LOG]
(
    [SR_NO] INT IDENTITY(1,1) NOT NULL,
    [MONTH] INT NULL,
    [YEAR] NUMERIC(4, 0) NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_RESPONSE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_RESPONSE]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [ITEM_SEQ_NO] NUMERIC(10, 0) NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] DATETIME NULL,
    [REF_NO] VARCHAR(40) NULL,
    [TRAN_STATUS] VARCHAR(1) NULL,
    [UPDATED_BY] VARCHAR(20) NULL,
    [UPDATED_DATE] DATETIME NULL,
    [FILE_NAME] VARCHAR(100) NULL,
    [REMARK_CODE] VARCHAR(2) NULL DEFAULT NULL,
    [SCB_REMARK] VARCHAR(40) NULL DEFAULT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_RESPONSE_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_RESPONSE_TEMP]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [ITEM_SEQ_NO] NUMERIC(10, 0) NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] NVARCHAR(8) NULL,
    [REF_NO] NUMERIC(18, 0) NULL,
    [TRAN_STATUS] VARCHAR(1) NULL,
    [REMARK_CODE] VARCHAR(2) NULL DEFAULT NULL,
    [SCB_REMARK] VARCHAR(40) NULL DEFAULT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRAN_UPLOAD_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRAN_UPLOAD_LOG]
(
    [SR_NO] INT IDENTITY(1,1) NOT NULL,
    [TRAN_FILE_NAME] VARCHAR(20) NULL,
    [LOT_NO] INT NULL,
    [MONTH] INT NULL,
    [YEAR] NUMERIC(4, 0) NULL,
    [UPLOADED_BY] VARCHAR(20) NULL,
    [UPLOADED_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRANSACTION
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRANSACTION]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [ACC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [DESTINATION_ACC] VARCHAR(18) NULL,
    [MICR] VARCHAR(9) NULL,
    [ACCOUNT_TYPE] VARCHAR(2) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [REF_NO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOCATIONS] VARCHAR(40) NULL,
    [MONTH] INT NOT NULL,
    [YEAR] NUMERIC(4, 0) NOT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL,
    [REQ_STATUS] INT NULL,
    [TRAN_STATUS] VARCHAR(3) NULL,
    [SCB_TRAN_DATE] DATETIME NULL,
    [ALERT_SMS_REASON] VARCHAR(100) NULL,
    [ALERT_SMS_STATUS] CHAR(1) NULL,
    [TRAN_SMS_REASON] VARCHAR(100) NULL,
    [TRAN_SMS_STATUS] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRANSACTION_28092012
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRANSACTION_28092012]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [ACC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [DESTINATION_ACC] VARCHAR(18) NULL,
    [MICR] VARCHAR(9) NULL,
    [ACCOUNT_TYPE] VARCHAR(2) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [REF_NO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOCATIONS] VARCHAR(40) NULL,
    [MONTH] INT NOT NULL,
    [YEAR] NUMERIC(4, 0) NOT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL,
    [REQ_STATUS] INT NULL,
    [TRAN_STATUS] VARCHAR(3) NULL,
    [SCB_TRAN_DATE] DATETIME NULL,
    [ALERT_SMS_REASON] VARCHAR(100) NULL,
    [ALERT_SMS_STATUS] CHAR(1) NULL,
    [TRAN_SMS_REASON] VARCHAR(100) NULL,
    [TRAN_SMS_STATUS] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ECS_TRANSACTION_Test
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ECS_TRANSACTION_Test]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [ACC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [DESTINATION_ACC] VARCHAR(18) NULL,
    [MICR] VARCHAR(9) NULL,
    [ACCOUNT_TYPE] VARCHAR(2) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [REF_NO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOCATIONS] VARCHAR(40) NULL,
    [MONTH] INT NOT NULL,
    [YEAR] NUMERIC(4, 0) NOT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL,
    [REQ_STATUS] INT NULL,
    [TRAN_STATUS] VARCHAR(3) NULL,
    [SCB_TRAN_DATE] DATETIME NULL,
    [ALERT_SMS_REASON] VARCHAR(100) NULL,
    [ALERT_SMS_STATUS] CHAR(1) NULL,
    [TRAN_SMS_REASON] VARCHAR(100) NULL,
    [TRAN_SMS_STATUS] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_TBL_ECS_TRANSACTION
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_TBL_ECS_TRANSACTION]
(
    [SR NO] NUMERIC(6, 0) NULL,
    [DP_ID] VARCHAR(16) NOT NULL,
    [APPLICANT_NAME] VARCHAR(40) NULL,
    [ACC_HOLDER_NAME] VARCHAR(40) NULL,
    [BANK_NAME] VARCHAR(40) NULL,
    [BRANCH_NAME] VARCHAR(40) NULL,
    [DESTINATION_ACC] VARCHAR(18) NULL,
    [MICR] VARCHAR(9) NULL,
    [ACCOUNT_TYPE] VARCHAR(2) NULL,
    [AMOUNT] NUMERIC(13, 0) NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [REF_NO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOCATIONS] VARCHAR(40) NULL,
    [MONTH] INT NOT NULL,
    [YEAR] NUMERIC(4, 0) NOT NULL,
    [PROCESSED_BY] VARCHAR(20) NULL,
    [PROCESSED_DATE] DATETIME NULL,
    [REQ_STATUS] INT NULL,
    [TRAN_STATUS] VARCHAR(3) NULL,
    [SCB_TRAN_DATE] DATETIME NULL,
    [ALERT_SMS_REASON] VARCHAR(100) NULL,
    [ALERT_SMS_STATUS] CHAR(1) NULL,
    [TRAN_SMS_REASON] VARCHAR(100) NULL,
    [TRAN_SMS_STATUS] CHAR(1) NULL
);

GO

