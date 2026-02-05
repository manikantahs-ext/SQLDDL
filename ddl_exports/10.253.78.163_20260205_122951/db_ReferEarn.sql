-- DDL Export
-- Server: 10.253.78.163
-- Database: db_ReferEarn
-- Exported: 2026-02-05T12:29:52.841322

USE db_ReferEarn;
GO

-- --------------------------------------------------
-- FUNCTION dbo.GetColumnValue
-- --------------------------------------------------
CREATE FUNCTION dbo.GetColumnValue(
@String varchar(8000),
@Delimiter char(1),
@Column int = 1
)
returns varchar(8000)
as     
begin

declare @idx int     
declare @slice varchar(8000)     

select @idx = 1     
    if len(@String)<1 or @String is null  return null

declare @ColCnt int
    set @ColCnt = 1

while (@idx != 0)
begin     
    set @idx = charindex(@Delimiter,@String)     
    if @idx!=0 begin
        if (@ColCnt = @Column) return left(@String,@idx - 1)        

        set @ColCnt = @ColCnt + 1

    end

    set @String = right(@String,len(@String) - @idx)     
    if len(@String) = 0 break
end 
return @String  
end

GO

-- --------------------------------------------------
-- FUNCTION dbo.Split
-- --------------------------------------------------
CREATE FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))        
returns @temptable TABLE (items varchar(8000))        
as        
begin        
    declare @idx int        
    declare @slice varchar(8000)        
       
    select @idx = 1        
        if len(@String)<1 or @String is null  return        
       
    while @idx!= 0        
    begin        
        set @idx = charindex(@Delimiter,@String)        
        if @idx!=0        
            set @slice = left(@String,@idx - 1)        
        else        
            set @slice = @String        
           
        if(len(@slice)>0)   
            insert into @temptable(Items) values(@slice)        
  
        set @String = right(@String,len(@String) - @idx)        
        if len(@String) = 0 break        
    end    
return        
end

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_BROKARAGEDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_BROKARAGEDETAILS] ADD CONSTRAINT [PK__TBL_BROK__3214EC275FB337D6] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BrokarageSource
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BrokarageSource] ADD CONSTRAINT [PK__tbl_Brok__3213E83F72C60C4A] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_coupans
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_coupans] ADD CONSTRAINT [PK__tbl_coup__3213E83F0AD2A005] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_coupans_upload
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_coupans_upload] ADD CONSTRAINT [PK__tbl_coup__3213E83F1CF15040] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_JVFILELOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_JVFILELOG] ADD CONSTRAINT [PK__TBL_JVFI__FBDF78C96754599E] PRIMARY KEY ([RecordID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_LMS_SOURCE
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_LMS_SOURCE] ADD CONSTRAINT [PK_TBL_LMS_SOURCE] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_LMS_SOURCE_upload
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_LMS_SOURCE_upload] ADD CONSTRAINT [PK__TBL_LMS___3213E83F21B6055D] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_findstring
-- --------------------------------------------------

CREATE procedure [dbo].[sp_findstring]    

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
 @table_name varchar(776),    -- The table/view for which the INSERT statements will be generated using the existing data    
 @target_table varchar(776) = NULL,  -- Use this parameter to specify a different table name into which the data will be inserted    
 @include_column_list bit = 1,  -- Use this parameter to include/ommit column list in the generated INSERT statement    
 @from varchar(800) = NULL,   -- Use this parameter to filter the rows based on a filter condition (using WHERE)    
 @include_timestamp bit = 0,   -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement    
 @debug_mode bit = 0,   -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination    
 @owner varchar(64) = NULL,  -- Use this parameter if you are not the owner of the table    
 @ommit_images bit = 0,   -- Use this parameter to generate INSERT statements by omitting the 'image' columns    
 @ommit_identity bit = 0,  -- Use this parameter to ommit the identity columns    
 @top int = NULL,   -- Use this parameter to generate INSERT statements only for the TOP n rows    
 @cols_to_include varchar(8000) = NULL, -- List of columns to be included in the INSERT statement    
 @cols_to_exclude varchar(8000) = NULL, -- List of columns to be excluded from the INSERT statement    
 @disable_constraints bit = 0,  -- When 1, disables foreign key constraints and enables them after the INSERT statements    
 @ommit_computed_cols bit = 0  -- When 1, computed columns will not be included in the INSERT statement    
     
)    
AS    
BEGIN    
    
/***********************************************************************************************************    
Procedure: sp_generate_inserts  (Build 22)     
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
  Joris Laperre   -- For reporting a regression bug in handling text/ntext columns    
    
Tested on:  SQL Server 7.0 and SQL Server 2000    
    
Date created: January 17th 2001 21:52 GMT    
    
Date modified: May 1st 2002 19:50 GMT    
    
Email:   vyaskn@hotmail.com    
    
NOTE:  This procedure may not work with tables with too many columns.    
  Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types    
  Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results    
  IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed    
  you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts    
  like nchar and nvarchar    
      
    
Example 1: To generate INSERT statements for table 'titles':    
      
  EXEC sp_generate_inserts 'titles'    
    
Example 2:  To ommit the column list in the INSERT statement: (Column list is included by default)    
  IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,    
  to avoid erroneous results    
      
  EXEC sp_generate_inserts 'titles', @include_column_list = 0    
    
Example 3: To generate INSERT statements for 'titlesCopy' table from 'titles' table:    
    
  EXEC sp_generate_inserts 'titles', 'titlesCopy'    
    
Example 4: To generate INSERT statements for 'titles' table for only those titles     
  which contain the word 'Computer' in them:    
  NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter    
    
  EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"    
    
Example 5:  To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:    
  (By default TIMESTAMP column's data is not scripted)    
    
  EXEC sp_generate_inserts 'titles', @include_timestamp = 1    
    
Example 6: To print the debug information:    
      
  EXEC sp_generate_inserts 'titles', @debug_mode = 1    
    
Example 7:  If you are not the owner of the table, use @owner parameter to specify the owner name    
  To use this option, you must have SELECT permissions on that table    
    
  EXEC sp_generate_inserts Nickstable, @owner = 'Nick'    
    
Example 8:  To generate INSERT statements for the rest of the columns excluding images    
  When using this otion, DO NOT set @include_column_list parameter to 0.    
    
  EXEC sp_generate_inserts imgtable, @ommit_images = 1    
    
Example 9:  To generate INSERT statements excluding (ommiting) IDENTITY columns:    
  (By default IDENTITY columns are included in the INSERT statement)    
    
  EXEC sp_generate_inserts mytable, @ommit_identity = 1    
    
Example 10:  To generate INSERT statements for the TOP 10 rows in the table:    
      
  EXEC sp_generate_inserts mytable, @top = 10    
    
Example 11:  To generate INSERT statements with only those columns you want:    
      
  EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"    
    
Example 12:  To generate INSERT statements by omitting certain columns:    
      
  EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"    
    
Example 13: To avoid checking the foreign key constraints while loading data with INSERT statements:    
      
  EXEC sp_generate_inserts titles, @disable_constraints = 1    
    
Example 14:  To exclude computed columns from the INSERT statement:    
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
DECLARE  @Column_ID int,       
  @Column_List varchar(8000),     
  @Column_Name varchar(128),     
  @Start_Insert varchar(786),     
  @Data_Type varchar(128),     
  @Actual_Values varchar(8000), --This is the string that will be finally executed to generate INSERT statements    
  @IDN varchar(128)  --Will contain the IDENTITY column's name in the table    
    
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
WHERE  TABLE_NAME = @table_name AND    
(@owner IS NULL OR TABLE_SCHEMA = @owner)    
    
    
    
--Loop through all the columns of the table, to get the column names and their data types    
WHILE @Column_ID IS NOT NULL    
 BEGIN    
  SELECT  @Column_Name = QUOTENAME(COLUMN_NAME),     
  @Data_Type = DATA_TYPE     
  FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
  WHERE  ORDINAL_POSITION = @Column_ID AND     
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
    
  SELECT  @Column_ID = MIN(ORDINAL_POSITION)     
  FROM  INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
  WHERE  TABLE_NAME = @table_name AND     
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
    SELECT  'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'    
   END    
  ELSE    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'    
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
    SELECT  'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL'  AS '--Code to enable the previously disabled constraints'    
   END    
  ELSE    
   BEGIN    
    SELECT  'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'    
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
-- PROCEDURE dbo.SPX_DataPushForBrokerageCashback
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SPX_DataPushForBrokerageCashback]
AS
BEGIN

	INSERT INTO TBL_ELIGIBLITYDETAILS
	([CLIENT_CODE],[CLIENT_TYPE],[LEAD_GEN_DATE],[LEAD_ACT_DATE],[LMS_SOURCE],[ENTRY_DATE],
	[ISFIRSTTRADE],[ISMARGIN],[MARGINAMT],[ISSIXMONTH],[MODIFYDATE],[ISELEGIBLE],[REFERENCE],
	[EXPIRYDT],[name],[email],[mobile],[status],[TotalAMT],[ReversedAMT],cashbackPercentage)

	SELECT
		C.PartyCode AS CLIENT_CODE
		,'REFERRER' AS CLIENT_TYPE
		,NULL AS LEAD_GEN_DATE
		,C.PartyCodeGenerationDate AS LEAD_ACT_DATE
		,'DIY' AS LMS_SOURCE
		,GETDATE() AS ENTRY_DATE
		,1 AS ISFIRSTTRADE
		,1 AS ISMARGIN
		,P.TotalPayment AS MARGINAMT
		,1 AS ISSIXMONTH
		,NULL AS MODIFYDATE
		,1 AS ISELEGIBLE
		,NULL AS REFERENCE
		,(C.PartyCodeGenerationDate + 364) AS EXPIRYDT
		,NULL AS name
		,NULL AS email
		,NULL AS mobile
		,1 AS status
		,B.BrokerageCashback AS TotalAMT
		,'0.00' AS ReversedAMT
		,'0.10' AS cashbackPercentage
	from [KYC1DB].AngelBrokingDiyKyc.DBO.Diykyc_CLientInfo C With(Nolock)
		LEFT JOIN [KYC1DB].AngelBrokingDiyKyc.DBO.DiyKyc_PaymentInfo P with(nolock) ON C.DiykycId = P.DiykycId
		LEFT JOIN [KYC1DB].AngelBrokingDiyKyc.DBO.DiyKyc_Brokerage_Plan B With(Nolock) ON P.TotalPayment = B.Margin_Min
		--LEFT JOIN [KYC1DB].AngelBrokingDiyKyc.DBO.tbl_Angel_Partner AP WITH(NOLOCK) ON C.DiykycId = AP.DiykycId
	WHERE CAST(C.PartyCodeGenerationDate AS DATE) = CAST(GETDATE() AS DATE) AND P.TotalPayment <> '699.00'
	--BETWEEN '2018-07-11' AND '2018-08-20' 
	--AND AP.DiykycId IS NULL
	
	Union ALL
	
	SELECT CI.GeneratedCode AS CLIENT_CODE,'REFERRER' AS CLIENT_TYPE,NULL AS LEAD_GEN_DATE,ASS.ModifiedDate AS LEAD_ACT_DATE
		,'Dkyc' AS LMS_SOURCE,GETDATE() AS ENTRY_DATE,1 AS ISFIRSTTRADE,1 AS ISMARGIN,MDC.Total_Amount AS MARGINAMT,1 AS ISSIXMONTH
		,NULL AS MODIFYDATE,1 AS ISELEGIBLE,NULL AS REFERENCE,(ASS.ModifiedDate + 364) AS EXPIRYDT,NULL AS name
		,NULL AS email,NULL AS mobile,1 AS status,MDC.CashBackAmount AS TotalAMT,'0.00' AS ReversedAMT,'0.10' AS cashbackPercentage
	From [KYC1DB].AngelBrokingWebDB.dbo.ClientInfo CI With(NoLock)
		Inner Join [KYC1DB].AngelBrokingWebDB.dbo.PaymentInfo PIN With(noLock) On  CI.Client_Id=PIN.Client_Id And PIN.PaymentMode_Id=96 And PIN.PaymentStatus=1
		Inner Join [KYC1DB].AngelBrokingWebDB.dbo.Margin_Deposit_Charges MDC With(noLock) On MDC.Client_Id=CI.Client_Id And ISNULL(MDC.IsSalesExec,0)=0
		Inner Join [KYC1DB].AngelBrokingWebDB.dbo.AppStepsStatus ASS With(noLock) On ASS.ClientId=CI.Client_Id And ASS.StepId=20 And ASS.Status=14
	Where CI.Created_Date>='20-Aug-2018' And MDC.Margin_Dep_Amount>699 And MDC.IsBrokerageCashback=1
	--Where CAST(CI.Created_Date AS DATE)= CAST(GETDATE() AS DATE) And MDC.Margin_Dep_Amount>699 And MDC.IsBrokerageCashback=1

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BEFOREUPLOAD
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_BEFOREUPLOAD]
	@TYPE AS VARCHAR(30)
AS
BEGIN
	IF (@TYPE='COUPON')
	BEGIN
		INSERT INTO TBL_COUPANS_LOG(ID,STARTDATE,ENDDATE,COUPANCODE,ENTRYDATE)
		SELECT ID,STARTDATE,ENDDATE,COUPANCODE,ENTRYDATE FROM TBL_COUPANS
		TRUNCATE TABLE TBL_COUPANS
		
		SELECT 1
	END
	IF( @TYPE = 'LMS')
	BEGIN
		INSERT INTO TBL_LMS_SOURCE_LOG(ID,REFEREE_CODE,REFERRER_CODE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE)
		SELECT ID,REFEREE_CODE,REFERRER_CODE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE FROM TBL_LMS_SOURCE
		TRUNCATE TABLE TBL_LMS_SOURCE
		
		SELECT 1
	END
	
	IF( @TYPE = 'AFTERLMS')
	BEGIN
		/*
		--DELETE 6 MONTHS
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT *,'DIFFRENCE BETWEEN LEAD GENERATION DATE AND ACTIVATION DATE IS GREATER THAN 6 MONTHS.' AS REASON,GETDATE() AS UPDATEDON  FROM TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6
		DELETE FROM TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6
		
		
		--DELETE MARGIN
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT A.*,'MARGINE AMOUNT IS LESS THAN 25000 MARGIN AMT='+CAST(MARGIN_AMT AS VARCHAR) AS REASON,GETDATE() AS UPDATEDON FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT  PARTY_CODE AS PARTY_CODE,MAX(TOTALMARGIN) AS MARGIN_AMT FROM [196.1.115.132].RISK.DBO.VW_CLIENTSTOTALMARGIN  GROUP BY PARTY_CODE) B
		ON A.REFEREE_CODE = B.PARTY_CODE
		WHERE B.MARGIN_AMT <25000
		
		DELETE  A
		FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT  PARTY_CODE AS PARTY_CODE,MAX(TOTALMARGIN) AS MARGIN_AMT FROM [196.1.115.132].RISK.DBO.VW_CLIENTSTOTALMARGIN  GROUP BY PARTY_CODE) B
		ON A.REFEREE_CODE = B.PARTY_CODE
		WHERE B.MARGIN_AMT <25000
		--DELETE FIRST TRADE DATE
		
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT A.*,'FIRST TRADE IS NOT DONE' AS REASON,GETDATE() AS UPDATEDON FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE AS PARTY_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL) B
		ON A.REFEREE_CODE = B.PARTY_CODE
		WHERE B.PARTY_CODE IS NULL
		
		DELETE  A
		FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE AS PARTY_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL) B
		ON A.REFEREE_CODE = B.PARTY_CODE
		WHERE B.PARTY_CODE IS NULL
		*/
		-- DELETE DUPLICATE REFREE()
		SELECT REFEREE_CODE,COUNT(REFEREE_CODE) AS COUNT INTO #TEMP FROM TBL_LMS_SOURCE GROUP BY REFEREE_CODE HAVING COUNT(REFEREE_CODE)>1
		
		
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT A.*,'DUPLICATE RECORD' AS REASON,GETDATE() AS UPDATEDON FROM (SELECT * FROM TBL_LMS_SOURCE WHERE ID IN 
																					(SELECT MAX(ID) FROM TBL_LMS_SOURCE WHERE REFEREE_CODE IN  
																					(SELECT REFEREE_CODE FROM #TEMP) GROUP BY REFEREE_CODE)) A
		DELETE FROM TBL_LMS_SOURCE WHERE ID IN (SELECT MAX(ID) FROM TBL_LMS_SOURCE WHERE REFEREE_CODE IN  
									(SELECT REFEREE_CODE FROM #TEMP) GROUP BY REFEREE_CODE)
		
		-- DELETE INVALID CLIENTS
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT A.*,'INVALID REFERRER CODE' AS REASON,GETDATE() AS UPDATEDON FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] )B
		ON 
		A.REFERRER_CODE = B.CL_CODE
		WHERE B.CL_CODE IS NULL
		
		INSERT INTO TBL_LMS_SOURCE_REJECTION
		SELECT A.*,'INVALID REFEREE CODE' AS REASON,GETDATE() AS UPDATEDON FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] )B
		ON 
		A.REFEREE_CODE = B.CL_CODE
		WHERE B.CL_CODE IS NULL
		
		
		
		DELETE  A FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] )B
		ON 
		A.REFERRER_CODE = B.CL_CODE
		WHERE B.CL_CODE IS NULL
		
		
		DELETE  A FROM TBL_LMS_SOURCE A
		LEFT JOIN
		(SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] )B
		ON 
		A.REFEREE_CODE = B.CL_CODE
		WHERE B.CL_CODE IS NULL
		
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BOAPIPUSH
-- --------------------------------------------------
CREATE proc [dbo].[USP_BOAPIPUSH]  
as  
  
 select                                         
 8 as VOUCHERTYPE,                          
 ROW_NUMBER() OVER ( ORDER BY client_Code) AS [SNo],                          
convert(datetime,convert(varchar(8),getdate(),112)) as VDATE,                          
convert(datetime,convert(varchar(8),getdate(),112)) as EDATE,                                                 
 client_Code as CLTCODE,                          
 round(ReversedAMT,2) as CREDITAMT,                          
 0 as DEBITAMT,                          
 /*'Amount Subscribed for Sovereign Gold Bond' as NARRATION,                        */  
  'Being 10% Brok Reversed for '+cast(LEFT(DATENAME(MONTH,SAUDA_DATE),3) as varchar)+' '+cast(DATENAME(YEAR,SAUDA_DATE) as varchar)+'_Clt-'+client_CODE as NARRATION,                          
 '' as BANKCODE,                          
 '' as MARGINCODE,                          
 '' as BANKNAME,                          
 '' as BRANCHNAME,                          
 'HO' as BRANCHCODE,                          
 '' as DDNO,              
 /*VerifierId as DDNO, */    
 /* convert(varchar(10),VerifierID)+convert(varchar(10),RequestID) as DDNO, */              
 '' as CHEQUEMODE,                          
'' as CHEQUEDATE,                          
 '' as CHEQUENAME,                          
 '' as CLEAR_MODE,                          
 '' as TPACCOUNTNUMBER,                          
 EXCHANGE=case    
when segment='BSE' then 'BSE'    
when segment='NSE' then 'NSE'    
when segment='NSEFO' then 'NSE'    
when segment='MCD' then 'MCD'    
when segment='NSX' then 'NSX'    
when segment='NCDEX' then 'NCX'   
when segment='MCX' then 'MCX'     
else segment end    
,       
 SEGMENT= case    
 when segment='BSE' then 'CAPITAL'    
when segment='NSE' then 'CAPITAL'    
when segment='NSEFO' then 'FUTURES'    
when segment='MCD' then 'FUTURES'    
when segment='NSX' then 'FUTURES'    
when segment='NCDEX' then 'FUTURES'   
when segment='MCX' then 'FUTURES'    
 else segment end  ,                          
 1 as MKCK_FLAG,                          
 '' as Return_fld4,                          
 'R&E' as Return_fld5,                          
 0 as Rowstate,            
 'Refer' as Return_fld2   INTO #TEMP                   
 from                           
 (select * from TBL_BROKARAGEDETAILS with(nolock)   where JVCreated=0 and isnull(ReversedAMT,0.00) > 0) a                  
 join [196.1.115.132].risk.dbo.Vw_RMS_Client_Vertical c  with(nolock)                        
 on a.client_Code=c.client   
 join [196.1.115.132].risk.dbo.client_details b with(nolock)  on a.client_Code=b.party_code   where b.b2c='Y'  
                     
  
SELECT * FROM (  
  SELECT * FROM #TEMP  
  UNION ALL  
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'520014' CLTCODE,  
  '0' CREDTAMT,CREDITAMT DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,  
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,  
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2  
 FROM #TEMP )A  
 ORDER BY SNO  
   
 --select max(len(exchange)) from #TEMP  
 --select len(exchange),exchange from #TEMP where   len(exchange)>3 order by  len(exchange)  
  
  
INSERT INTO  anand.MKTAPI.dbo.tbl_post_data                     
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,                          
 CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2)                                            
SELECT * FROM (  
  SELECT * FROM #TEMP  
  UNION ALL  
  SELECT VOUCHERTYPE,SNo,VDATE,EDATE,'520014' CLTCODE,  
  '0' CREDTAMT,CREDITAMT DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,  
  DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,  
  MKCK_FLAG,Return_fld4,Return_fld5,Rowstate,Return_fld2  
 FROM #TEMP )A  
 ORDER BY SNO     
   
   
 update  TBL_BROKARAGEDETAILS set JVCreated=1 where JVCreated=0 and isnull(ReversedAMT,0.00) > 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_findInUSP]                  
 @DBNAME VARCHAR(500),                
 @SRCSTR VARCHAR(500)                  
AS                  
                  
 SET NOCOUNT ON                
 SET @SRCSTR  = '%' + @SRCSTR + '%'                  
                
 DECLARE @STR AS VARCHAR(1000),@xdbname as varchar(500)                
    
 set @xdbname=@DBNAME    
    
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
                
 SET @STR='SELECT DISTINCT '''+@xdbname+''' as DBNAME,O.NAME,O.XTYPE FROM '+@DBNAME+'SYSCOMMENTS  C '                 
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '                 
 SET @STR=@STR+' WHERE O.XTYPE IN (''P'',''V'') AND C.TEXT LIKE '''+@SRCSTR+''''                  
 PRINT @STR                
  EXEC(@STR)                
        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETBROKARAGE
-- --------------------------------------------------
-- =============================================  
-- Author:  Suraj,Neha  
-- Create date: 24-08-2017  
-- Description: get client_brokarage  
-- =============================================  
--USP_GETBROKARAGE 'Aug  1 2018'  

 
CREATE PROCEDURE [dbo].[USP_GETBROKARAGE](@SAUDA_DATE VARCHAR(12)=null)  
   
AS  
BEGIN  
  
  IF OBJECT_ID('TEMPDB..#CLIENTDETAILS') IS NOT NULL  
  DROP TABLE #CLIENTDETAILS  
  
  IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL  
  DROP TABLE #COMB_CLI  
  
  -- GET BROKARAGE GENERATED   
  /*DECLARE @SAUDA_DATE VARCHAR(12)*/  
  --if(isnull(@SAUDA_DATE,'') ='')  
  --begin  
  -- SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM REMISIOR.DBO.COMB_CLI WITH(NOLOCK)  
  --end  
  --PRINT @SAUDA_DATE  
  /*select party_code,SUM(Brok_earned) as Brok_earned into #COMB_CLI from REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE group by party_code*/  
    
  /*select * into #aa from INTRANET.RISK.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE b2c='Y' */  
  select party_code,SUM(Brok_earned) as Brok_earned,segment into #COMB_CLI from REMISIOR.DBO.COMB_CLI a WITH(NOLOCK)   
  where -- party_code='NOD3228' and   
  Sauda_Date>= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) and  
  sauda_date<= DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)  group by party_code,segment  
  
    
    
  --GET ELEGIBLE CLIENTS IN TEMP TABEL  
  /*SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS FROM  TBL_ELIGIBLITYDETAILS   
  where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)  
  */  
    
  SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT,ReversedAMT_NSE,ReversedAMT_NSEFO,ReversedAMT_NSX,ReversedAMT_MCX,  
  ReversedAMT_NCDEX,totalamt INTO #CLIENTDETAILS FROM  TBL_ELIGIBLITYDETAILS With(Nolock)  
  where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS With(Nolock) group by client_code)   
  
    
  ALTER TABLE #CLIENTDETAILS  
  ADD BROKARAGEAMT_BSE MONEY,BROKARAGEREVERSEDAMT_BSE MONEY  
    
  ALTER TABLE #CLIENTDETAILS  
  ADD BROKARAGEAMT_NSE MONEY,BROKARAGEREVERSEDAMT_NSE MONEY,BROKARAGEAMT_NSEFO MONEY,BROKARAGEREVERSEDAMT_NSEFO MONEY,  
  BROKARAGEAMT_NSX MONEY,BROKARAGEREVERSEDAMT_NSX MONEY,BROKARAGEAMT_NCDX MONEY,BROKARAGEREVERSEDAMT_NCDX MONEY,  
  BROKARAGEAMT_MCX MONEY,BROKARAGEREVERSEDAMT_MCX MONEY  
    
  -- BROKARAGE DETAILS IN #CLIENTDETAILS  
 /* UPDATE A  
  SET A.BROKARAGEAMT = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT = (B.Brok_earned*0.1)  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
 */  
   
  UPDATE A  
  SET A.BROKARAGEAMT_BSE = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_BSE = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ABLCM'  
    
  UPDATE A  
  SET A.BROKARAGEAMT_NSE = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_NSE = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ACDLCM'  
    
  UPDATE A  
  SET A.BROKARAGEAMT_NSEFO = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_NSEFO = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ACDLFO'  
    
  UPDATE A  
  SET A.BROKARAGEAMT_NSX = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_NSX = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ACDLNSX'  
    
  UPDATE A  
  SET A.BROKARAGEAMT_NCDX = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_NCDX = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ACPLNCDX'  
    
  UPDATE A  
  SET A.BROKARAGEAMT_MCX = B.Brok_earned   
  ,A.BROKARAGEREVERSEDAMT_MCX = (B.Brok_earned*0.1)  
  --A.Segment=b.Segment  
  FROM #CLIENTDETAILS a  
  JOIN #COMB_CLI B  
  ON A.CLIENT_CODE = B.party_code  
  where b.segment='ACPLMCX'   
    
  -- DELETE NON TRADED CLIENTS  
    
  /*DELETE FROM #CLIENTDETAILS WHERE BROKARAGEAMT IS NULL AND BROKARAGEREVERSEDAMT IS NULL*/  
  DELETE FROM #CLIENTDETAILS WHERE  BROKARAGEAMT_BSE IS NULL AND BROKARAGEREVERSEDAMT_BSE  IS NULL AND  BROKARAGEAMT_NSE IS NULL AND BROKARAGEREVERSEDAMT_NSE IS NULL and  
  BROKARAGEAMT_NSEFO  IS NULL AND BROKARAGEREVERSEDAMT_NSEFO IS NULL AND   
  BROKARAGEAMT_NSX IS NULL AND BROKARAGEREVERSEDAMT_NSX IS NULL AND BROKARAGEAMT_NCDX IS NULL AND   
  BROKARAGEREVERSEDAMT_NCDX IS NULL AND   
  BROKARAGEAMT_MCX IS NULL AND BROKARAGEREVERSEDAMT_MCX IS NULL    
    
    
  --cretae table to hold extra amount (e.g ReversedAMT + BROKARAGEREVERSEDAMT > 5000 then extraamount  = BROKARAGEREVERSEDAMT  - (5000-ReversedAMT))  
    
  create table #extraAMT  
  (  
  id int identity(1,1) primary key,  
  client_code varchar(50),  
  BROKARAGEAMT money,  
  extraAMT money  
  )  
    
    
  /*  
    
  drop table #extraAMT  
  update #CLIENTDETAILS  
  set ReversedAMT = 4995  
  where id=14  
  */  
    
    
  --insert into #extraAMT  
  --select CLIENT_CODE,(BROKARAGEREVERSEDAMT  - (5000-ReversedAMT)) as extraAMT,BROKARAGEAMT from #CLIENTDETAILS A  
  --where (ReversedAMT+BROKARAGEREVERSEDAMT)>5000  
    
    
    
    
  /*  
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT =   
  CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (ReversedAMT+BROKARAGEREVERSEDAMT) ELSE (ReversedAMT +(5000-ReversedAMT))END ,  
  BROKARAGEREVERSEDAMT = CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (BROKARAGEREVERSEDAMT) ELSE ((5000-ReversedAMT))END   
  */  
    
  UPDATE #CLIENTDETAILS   
  SET ReversedAMT = case when ISNULL(BROKARAGEREVERSEDAMT_BSE,0.00)>totalamt THEN totalamt  
  else ISNULL(BROKARAGEREVERSEDAMT_BSE,0.00) END   
    
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT_NSE= CASE WHEN (TOTALAMT-ReversedAMT)< ISNULL(BROKARAGEREVERSEDAMT_NSE,0.00) THEN (TOTALAMT-ReversedAMT) ELSE ISNULL(BROKARAGEREVERSEDAMT_NSE,0.00) END  
  
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT_NSEFO= CASE WHEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE)< ISNULL(BROKARAGEREVERSEDAMT_NSEFO,0.00) THEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE) ELSE ISNULL(BROKARAGEREVERSEDAMT_NSEFO,0.00) END  
  
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT_MCX= CASE WHEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO)< ISNULL(BROKARAGEREVERSEDAMT_MCX,0.00) THEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO) ELSE ISNULL(BROKARAGEREVERSEDAMT_MCX,0.00) END    
    
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT_NCDEX= CASE WHEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO-ReversedAMT_MCX)<  ISNULL(BROKARAGEREVERSEDAMT_NCDX,0.00) THEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO-ReversedAMT_MCX) ELSE ISNULL(BROKARAGEREVERSEDAMT_NCDX,0.00) END    
  
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT_NSX= CASE WHEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO-ReversedAMT_MCX-ReversedAMT_NCDEX)<  ISNULL(BROKARAGEREVERSEDAMT_NSX,0.00) THEN (TOTALAMT-ReversedAMT-ReversedAMT_NSE-ReversedAMT_NSEFO-ReversedAMT_MCX-ReversedAMT_NCDEX) ELSE  ISNULL(BROKARAGEREVERSEDAMT_NSX,0.00) END    
  
    
  --INSERT RECORDS TO TRAIL TABLE  
  /*INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)  
  SELECT CLIENT_CODE,BROKARAGEAMT,@SAUDA_DATE, BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),ReversedAMT FROM #CLIENTDETAILS  
  */  
    
  INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT,segment)  
    
  SELECT CLIENT_CODE,BROKARAGEAMT_BSE,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_BSE,'SYSTEM',GETDATE(),  
  ReversedAMT,'BSE' as segment FROM #CLIENTDETAILS  
  union all  
  SELECT CLIENT_CODE,BROKARAGEAMT_NSE,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_NSE,'SYSTEM',GETDATE(),  
  ReversedAMT_NSE,'NSE' as segment FROM #CLIENTDETAILS  
  union all  
  SELECT CLIENT_CODE,BROKARAGEAMT_NSEFO,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_NSEFO,'SYSTEM',GETDATE(),  
  ReversedAMT_NSEFO,'NSEFO' as segment FROM #CLIENTDETAILS  
  union all  
  SELECT CLIENT_CODE,BROKARAGEAMT_NSX,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_NSX,'SYSTEM',GETDATE(),  
  ReversedAMT_NSX,'NSX' as segment FROM #CLIENTDETAILS  
  union all  
  SELECT CLIENT_CODE,BROKARAGEAMT_MCX,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_MCX,'SYSTEM',GETDATE(),  
  ReversedAMT_MCX,'MCX' as segment FROM #CLIENTDETAILS  
  union all  
  SELECT CLIENT_CODE,BROKARAGEAMT_NCDX,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1), BROKARAGEREVERSEDAMT_NCDX,'SYSTEM',GETDATE(),  
  ReversedAMT_NCDEX,'NCDEX' as segment FROM #CLIENTDETAILS  
  -- UPDATE RECORDS TO ELIGIBLITY TABLE  
  
  /*UPDATE A  
  SET A.ReversedAMT = B.ReversedAMT  
  FROM TBL_ELIGIBLITYDETAILS A  
  JOIN #CLIENTDETAILS B  
  ON A.CLIENT_CODE = B.CLIENT_CODE  
  and A.ID = B.ID  
    
  update  TBL_ELIGIBLITYDETAILS   
  set status = 2  
  where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000  
  */  
    
  UPDATE A  
  SET A.ReversedAMT = B.ReversedAMT  
  , A.ReversedAMT_NSE = B.ReversedAMT_NSE  
  , A.ReversedAMT_NSEFO = B.ReversedAMT_NSEFO  
  , A.ReversedAMT_MCX = B.ReversedAMT_MCX  
  , A.ReversedAMT_NCDEX = B.ReversedAMT_NCDEX  
  , A.ReversedAMT_NSX = B.ReversedAMT_NSX  
  FROM TBL_ELIGIBLITYDETAILS A  with(nolock)   
  JOIN #CLIENTDETAILS B  
  ON A.CLIENT_CODE = B.CLIENT_CODE  
  and A.ID = B.ID    
    
  update  TBL_ELIGIBLITYDETAILS   
  set status = 2  
   where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=totalamt or  ReversedAMT_NSE >=totalamt or  ReversedAMT_NSEFO >=totalamt or  
   ReversedAMT_MCX >=totalamt or  ReversedAMT_NCDEX >=totalamt or  ReversedAMT_NSX >=totalamt    
  --get clients which has extra amount(>5000)  
  /*  
  SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS_extra FROM  TBL_ELIGIBLITYDETAILS   
  where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)  
  and CLIENT_CODE in (select CLIENT_CODE from #extraAMT)  
    
    
    
  --INSERT RECORDS TO TRAIL TABLE  
  INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)  
  SELECT A.CLIENT_CODE,B.extraAMT ,@SAUDA_DATE, B.BROKARAGEAMT as BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),A.ReversedAMT   
  FROM #CLIENTDETAILS_extra A  
  left join  
  #extraAMT B  
  on A.CLIENT_CODE = B.CLIENT_CODE  
  */  
  -- UPDATE RECORDS TO ELIGIBLITY TABLE  
  /*  
  TBL_ELIGIBLITYDETAILS  
    
  */  
    
  /*UPDATE A  
  set A.ReversedAMT =   
  CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (A.ReversedAMT+B.BROKARAGEAMT) ELSE (A.ReversedAMT +(5000-A.ReversedAMT))END   
  --B.BROKARAGEAMT = CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (B.BROKARAGEAMT) ELSE ((5000-A.ReversedAMT))END  
   from  #CLIENTDETAILS_extra A  
   join #extraAMT B  
   on A.CLIENT_CODE = B.CLIENT_CODE  
     
    
    
    
    
  UPDATE A  
  SET A.ReversedAMT = B.ReversedAMT  
  FROM TBL_ELIGIBLITYDETAILS A  
  JOIN #CLIENTDETAILS_extra B  
  ON A.CLIENT_CODE = B.CLIENT_CODE  
  and A.ID = B.ID  
    
  update  TBL_ELIGIBLITYDETAILS   
  set status = 2  
  where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000  
  */  
    
  /*  
    
  TRUNCATE TABLE TBL_BROKARAGEDETAILS  
  UPDATE #CLIENTDETAILS  
  SET ReversedAMT = 4990  
  WHERE CLIENT_CODE='JOD19017'   
    
    
  */  
    
    
    
    
    
    
    
   
    
    
    
   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETBROKARAGE_02Jul2018
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj,Neha
-- Create date: 24-08-2017
-- Description:	get client_brokarage
-- =============================================
create PROCEDURE [dbo].[USP_GETBROKARAGE_02Jul2018]
	
AS
BEGIN

		IF OBJECT_ID('TEMPDB..#CLIENTDETAILS') IS NOT NULL
		DROP TABLE #CLIENTDETAILS

		IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
		DROP TABLE #COMB_CLI

		-- GET BROKARAGE GENERATED 
		DECLARE @SAUDA_DATE VARCHAR(12)
		SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
		PRINT @SAUDA_DATE
		select party_code,SUM(Brok_earned) as Brok_earned into #COMB_CLI from REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE group by party_code
		
		
		--GET ELEGIBLE CLIENTS IN TEMP TABEL
		SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS FROM  TBL_ELIGIBLITYDETAILS 
		where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)
		
		ALTER TABLE #CLIENTDETAILS
		ADD BROKARAGEAMT MONEY,BROKARAGEREVERSEDAMT MONEY
		
		-- BROKARAGE DETAILS IN #CLIENTDETAILS
		UPDATE A
		SET A.BROKARAGEAMT = B.Brok_earned 
		,A.BROKARAGEREVERSEDAMT = (B.Brok_earned*0.1)
		FROM #CLIENTDETAILS a
		JOIN #COMB_CLI B
		ON A.CLIENT_CODE = B.party_code
		
		
		-- DELETE NON TRADED CLIENTS
		
		DELETE FROM #CLIENTDETAILS WHERE BROKARAGEAMT IS NULL AND BROKARAGEREVERSEDAMT IS NULL
		
		
		--cretae table to hold extra amount (e.g ReversedAMT + BROKARAGEREVERSEDAMT > 5000 then extraamount  = BROKARAGEREVERSEDAMT  - (5000-ReversedAMT))
		
		create table #extraAMT
		(
		id int identity(1,1) primary key,
		client_code varchar(50),
		BROKARAGEAMT money,
		extraAMT money
		)
		
		
		/*
		
		drop table #extraAMT
		update #CLIENTDETAILS
		set ReversedAMT = 4995
		where id=14
		*/
		
		
		insert into #extraAMT
		select CLIENT_CODE,(BROKARAGEREVERSEDAMT  - (5000-ReversedAMT)) as extraAMT,BROKARAGEAMT from #CLIENTDETAILS A
		where (ReversedAMT+BROKARAGEREVERSEDAMT)>5000
		
		
		
		
		
		UPDATE #CLIENTDETAILS
		SET ReversedAMT = 
		CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (ReversedAMT+BROKARAGEREVERSEDAMT) ELSE (ReversedAMT +(5000-ReversedAMT))END ,
		BROKARAGEREVERSEDAMT = CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (BROKARAGEREVERSEDAMT) ELSE ((5000-ReversedAMT))END 
		
		--INSERT RECORDS TO TRAIL TABLE
		INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)
		SELECT CLIENT_CODE,BROKARAGEAMT,@SAUDA_DATE, BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),ReversedAMT FROM #CLIENTDETAILS
		
		-- UPDATE RECORDS TO ELIGIBLITY TABLE
		/*
		TBL_ELIGIBLITYDETAILS
		
		*/
		UPDATE A
		SET A.ReversedAMT = B.ReversedAMT
		FROM TBL_ELIGIBLITYDETAILS A
		JOIN #CLIENTDETAILS B
		ON A.CLIENT_CODE = B.CLIENT_CODE
		and A.ID = B.ID
		
		update  TBL_ELIGIBLITYDETAILS 
		set status = 2
		where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000
			
		--get clients which has extra amount(>5000)
		
		SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS_extra FROM  TBL_ELIGIBLITYDETAILS 
		where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)
		and CLIENT_CODE in (select CLIENT_CODE from #extraAMT)
		
		
		
		--INSERT RECORDS TO TRAIL TABLE
		INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)
		SELECT A.CLIENT_CODE,B.extraAMT ,@SAUDA_DATE, B.BROKARAGEAMT as BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),A.ReversedAMT 
		FROM #CLIENTDETAILS_extra A
		left join
		#extraAMT B
		on A.CLIENT_CODE = B.CLIENT_CODE
		
		-- UPDATE RECORDS TO ELIGIBLITY TABLE
		/*
		TBL_ELIGIBLITYDETAILS
		
		*/
		
		UPDATE A
		set A.ReversedAMT = 
		CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (A.ReversedAMT+B.BROKARAGEAMT) ELSE (A.ReversedAMT +(5000-A.ReversedAMT))END 
		--B.BROKARAGEAMT = CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (B.BROKARAGEAMT) ELSE ((5000-A.ReversedAMT))END
		 from  #CLIENTDETAILS_extra A
		 join #extraAMT B
		 on A.CLIENT_CODE = B.CLIENT_CODE
		 
		
		
		
		
		UPDATE A
		SET A.ReversedAMT = B.ReversedAMT
		FROM TBL_ELIGIBLITYDETAILS A
		JOIN #CLIENTDETAILS_extra B
		ON A.CLIENT_CODE = B.CLIENT_CODE
		and A.ID = B.ID
		
		update  TBL_ELIGIBLITYDETAILS 
		set status = 2
		where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000
		
		
		/*
		
		TRUNCATE TABLE TBL_BROKARAGEDETAILS
		UPDATE #CLIENTDETAILS
		SET ReversedAMT = 4990
		WHERE CLIENT_CODE='JOD19017' 
		
		
		*/
		
		
		
		
		
		
		
	
		
		
		
	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETBROKARAGE_23Aug2018
-- --------------------------------------------------
-- =============================================
-- Author:		Suraj,Neha
-- Create date: 24-08-2017
-- Description:	get client_brokarage
-- =============================================
--USP_GETBROKARAGE 'Aug  1 2018'
create PROCEDURE [dbo].[USP_GETBROKARAGE_23Aug2018](@SAUDA_DATE VARCHAR(12)=null)
	
AS
BEGIN

		IF OBJECT_ID('TEMPDB..#CLIENTDETAILS') IS NOT NULL
		DROP TABLE #CLIENTDETAILS

		IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
		DROP TABLE #COMB_CLI

		-- GET BROKARAGE GENERATED 
		/*DECLARE @SAUDA_DATE VARCHAR(12)*/
		if(isnull(@SAUDA_DATE,'') ='')
		begin
			SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
		end
		PRINT @SAUDA_DATE
		select party_code,SUM(Brok_earned) as Brok_earned into #COMB_CLI from REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE group by party_code
		
		
		--GET ELEGIBLE CLIENTS IN TEMP TABEL
		SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS FROM  TBL_ELIGIBLITYDETAILS 
		where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)
		
		ALTER TABLE #CLIENTDETAILS
		ADD BROKARAGEAMT MONEY,BROKARAGEREVERSEDAMT MONEY
		
		-- BROKARAGE DETAILS IN #CLIENTDETAILS
		UPDATE A
		SET A.BROKARAGEAMT = B.Brok_earned 
		,A.BROKARAGEREVERSEDAMT = (B.Brok_earned*0.1)
		FROM #CLIENTDETAILS a
		JOIN #COMB_CLI B
		ON A.CLIENT_CODE = B.party_code
		
		
		-- DELETE NON TRADED CLIENTS
		
		DELETE FROM #CLIENTDETAILS WHERE BROKARAGEAMT IS NULL AND BROKARAGEREVERSEDAMT IS NULL
		
		
		--cretae table to hold extra amount (e.g ReversedAMT + BROKARAGEREVERSEDAMT > 5000 then extraamount  = BROKARAGEREVERSEDAMT  - (5000-ReversedAMT))
		
		create table #extraAMT
		(
		id int identity(1,1) primary key,
		client_code varchar(50),
		BROKARAGEAMT money,
		extraAMT money
		)
		
		
		/*
		
		drop table #extraAMT
		update #CLIENTDETAILS
		set ReversedAMT = 4995
		where id=14
		*/
		
		
		insert into #extraAMT
		select CLIENT_CODE,(BROKARAGEREVERSEDAMT  - (5000-ReversedAMT)) as extraAMT,BROKARAGEAMT from #CLIENTDETAILS A
		where (ReversedAMT+BROKARAGEREVERSEDAMT)>5000
		
		
		
		
		
		UPDATE #CLIENTDETAILS
		SET ReversedAMT = 
		CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (ReversedAMT+BROKARAGEREVERSEDAMT) ELSE (ReversedAMT +(5000-ReversedAMT))END ,
		BROKARAGEREVERSEDAMT = CASE WHEN (ReversedAMT + BROKARAGEREVERSEDAMT)<=5000 THEN (BROKARAGEREVERSEDAMT) ELSE ((5000-ReversedAMT))END 
		
		--INSERT RECORDS TO TRAIL TABLE
		INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)
		SELECT CLIENT_CODE,BROKARAGEAMT,@SAUDA_DATE, BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),ReversedAMT FROM #CLIENTDETAILS
		
		-- UPDATE RECORDS TO ELIGIBLITY TABLE
		/*
		TBL_ELIGIBLITYDETAILS
		
		*/
		UPDATE A
		SET A.ReversedAMT = B.ReversedAMT
		FROM TBL_ELIGIBLITYDETAILS A
		JOIN #CLIENTDETAILS B
		ON A.CLIENT_CODE = B.CLIENT_CODE
		and A.ID = B.ID
		
		update  TBL_ELIGIBLITYDETAILS 
		set status = 2
		where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000
			
		--get clients which has extra amount(>5000)
		
		SELECT id,CLIENT_CODE,CLIENT_TYPE,REFERENCE,EXPIRYDT,ReversedAMT INTO #CLIENTDETAILS_extra FROM  TBL_ELIGIBLITYDETAILS 
		where ISELEGIBLE =1 and status = 1 and ID in (select MIN(ID) as id from TBL_ELIGIBLITYDETAILS group by client_code)
		and CLIENT_CODE in (select CLIENT_CODE from #extraAMT)
		
		
		
		--INSERT RECORDS TO TRAIL TABLE
		INSERT INTO TBL_BROKARAGEDETAILS(client_CODE,BROK_EARNED,SAUDA_DATE,BROK_CASHBK,ADDEDBY,ADDEDON,ReversedAMT)
		SELECT A.CLIENT_CODE,B.extraAMT ,@SAUDA_DATE, B.BROKARAGEAMT as BROKARAGEREVERSEDAMT,'SYSTEM',GETDATE(),A.ReversedAMT 
		FROM #CLIENTDETAILS_extra A
		left join
		#extraAMT B
		on A.CLIENT_CODE = B.CLIENT_CODE
		
		-- UPDATE RECORDS TO ELIGIBLITY TABLE
		/*
		TBL_ELIGIBLITYDETAILS
		
		*/
		
		UPDATE A
		set A.ReversedAMT = 
		CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (A.ReversedAMT+B.BROKARAGEAMT) ELSE (A.ReversedAMT +(5000-A.ReversedAMT))END 
		--B.BROKARAGEAMT = CASE WHEN (A.ReversedAMT + B.BROKARAGEAMT)<=5000 THEN (B.BROKARAGEAMT) ELSE ((5000-A.ReversedAMT))END
		 from  #CLIENTDETAILS_extra A
		 join #extraAMT B
		 on A.CLIENT_CODE = B.CLIENT_CODE
		 
		
		
		
		
		UPDATE A
		SET A.ReversedAMT = B.ReversedAMT
		FROM TBL_ELIGIBLITYDETAILS A
		JOIN #CLIENTDETAILS_extra B
		ON A.CLIENT_CODE = B.CLIENT_CODE
		and A.ID = B.ID
		
		update  TBL_ELIGIBLITYDETAILS 
		set status = 2
		where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000
		
		
		/*
		
		TRUNCATE TABLE TBL_BROKARAGEDETAILS
		UPDATE #CLIENTDETAILS
		SET ReversedAMT = 4990
		WHERE CLIENT_CODE='JOD19017' 
		
		
		*/
		
		
		
		
		
		
		
	
		
		
		
	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_getBrokrageLog
-- --------------------------------------------------
    
-- =============================================    
-- Author:  Suraj Patil    
-- Create date: 10-06-2017    
-- Description: REFSEGMENTWISE_Log    
    
/*    
USP_getBrokrageLog '2017-06-06','2017-06-07'    
*/    
    
-- =============================================    
CREATE PROCEDURE [dbo].[USP_getBrokrageLog]    
 -- Add the parameters for the stored procedure here    
 @fromdate as date,    
 @todate as date    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
  if @fromdate <> ''  
  begin  
  select party_code as [client code],cast(brok_earned as decimal(10,2))  as [Brokerage Generated],cast(AMT as decimal(10,2)) AS [Brokerage reversal Amount],
	cast(AMT as decimal(10,2)) as [Total Amount], DATENAME(month,UPDATEDON)+'-'+DATENAME(year,UPDATEDON)     as [Month], '10% Brokerage reversed' as Message from TBL_REFSEGMENTWISE
  --select * from TBL_REFSEGMENTWISE  
 -- union   
  -- select * from TBL_REFSEGMENTWISE_Log  where cast(ADDEDON as DATE ) >= @fromdate and cast(ADDEDON as DATE ) <= @todate    
  end  
  else  
  begin  
   --select * from TBL_REFSEGMENTWISE_Log    
   select party_code as [client code],cast(brok_earned as decimal(10,2))  as [Brokerage Generated],cast(AMT as decimal(10,2)) AS [Brokerage reversal Amount],
	cast(AMT as decimal(10,2)) as [Total Amount], DATENAME(month,UPDATEDON)+'-'+DATENAME(year,UPDATEDON)     as [Month], '10% Brokerage reversed' as Message from TBL_REFSEGMENTWISE
  end  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_JVFILE
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_JVFILE]  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
   select row_number() over (order by client_code) as Srno,id,CONVERT(VARCHAR(10), ADDEDON, 105) as VDATE, CONVERT(VARCHAR(10), ADDEDON, 105) as EDATE  
   ,client_code as CLTCODE,'C' as DRCR ,CONVERT(DECIMAL(10,2),brok_cashbk) as AMOUNT ,'Being 10% Brok Reversed for '+cast(LEFT(DATENAME(MONTH,ADDEDON),3) as varchar)+' '+cast(DATENAME(YEAR,ADDEDON) as varchar)+'_Clt-'+client_CODE as NARRATION  
   into #brokarage_Details  
   from TBL_BROKARAGEDETAILS where CAST(ADDEDON as date)  = CAST(getdate() as date) and JVCreated  = 0  
  
  
   select Srno,id,VDATE,EDATE,CLTCODE,DRCR,AMOUNT,NARRATION, branch_cd as BRANCHCODE   
   into #client_details  
   from #brokarage_Details a  
   left join (select cl_code,branch_cd from intranet.risk.dbo.client_details)b  
   on a.CLTCODE  = b.cl_code  
  
   select Srno,id,VDATE,EDATE,'520014' as CLTCODE,'D' as DRCR,AMOUNT,NARRATION, branch_cd as BRANCHCODE   
   into #angel_details  
   from #brokarage_Details a  
   left join (select cl_code,branch_cd from intranet.risk.dbo.client_details)b  
   on a.CLTCODE  = b.cl_code  
  
   update #client_details  
   set BRANCHCODE = 'ALL'  
  
   --update jv created flag in  TBL_BROKARAGEDETAILS   
  
   update TBL_BROKARAGEDETAILS   
   set JVCreated = 1  
   where ID in (select ID from #client_details)   
   -- create JV file log  
   insert into TBL_JVFILELOG(Srno,id,VDATE,EDATE,CLTCODE,DRCR,AMOUNT,NARRATION,BRANCHCODE)  
   select * from (select * from #client_details  
   union all  
   select * from #angel_details) a order by srno,drcr  
  
  
   --create  table with jv details to make attachment  
   truncate table TBL_JVFILE  
     
   insert into tbl_jvfile values('Srno','VDATE','EDATE','CLTCODE','DRCR','AMOUNT','NARRATION','BRANCHCODE')  
     
  
  
   insert into TBL_JVFILE  
   select   
   Srno,   
   DATENAME( day,CONVERT(date,VDATE,105))+'/'+cast(DATEpart(MONTH,CONVERT(date,VDATE,105)) as varchar)+'/'+ DATENAME( year,CONVERT(date,VDATE,105)) as VDATE,  
   DATENAME( day,CONVERT(date,EDATE,105))+'/'+cast(DATEpart(MONTH,CONVERT(date,EDATE,105)) as varchar)+'/'+ DATENAME( year,CONVERT(date,EDATE,105)) as EDATE,  
   CLTCODE,DRCR,AMOUNT,NARRATION,BRANCHCODE   
   from (select * from #client_details  
   union all  
   select * from #angel_details) a order by srno,drcr  
  
  
  
  
   --- Email generated JV file   
  
   --attachment start  
  
    declare  @SQLStatement as varchar(2000)  
    select @SQLStatement = 'bcp " select * from db_referearn.dbo.TBL_JVFILE" queryout \\196.1.115.142\d\upload_sacc\ReferAndEARNJV'+cast(CAST (GETDATE() as date) as varchar)+'.csv /c /t, -T -S' + @@servername  
    exec master..xp_cmdshell @SQLStatement   
    print @SQLStatement    
    declare @strAttach varchar(max)                              
    set @strAttach = '\\196.1.115.142\d\upload_sacc\ReferAndEARNJV'+cast(CAST (GETDATE() as date) as varchar)+'.csv'     
   --attachment end  
  
    Declare @bodytext as varchar(max)= 'Dear Anurag,<br><br>Please find the attached Todays(' + cast(getdate() as varchar) + ') JV File.<br><br><br>This is a system generated mail do not reply.<br>';  
  
   EXEC intranet.MSDB.DBO.SP_SEND_DBMAIL      
   @subject = 'Refer and Earn JV file',    
   @from_address = 'soft@angelbroking.com',    
   @body =@bodytext,  
   @PROFILE_NAME ='intranet',    -- profile_name from [Tbl_SACC_EmailMaster] where Purpose ='Acknowledgement_Email' and isdelete = 0 order by modified_on desc    
   --@RECIPIENTS = 'jalpa.dinesh@angelbroking.com',    
   @RECIPIENTS = 'neha.naiwar@angelbroking.com',    
   @copy_recipients = 'rahulc.shah@angelbroking.com;suraj.patil@angelbroking.com',  
   @body_format = 'html',  
   @file_attachments=@strAttach    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFERANDEARNMIS
-- --------------------------------------------------
/*
USP_REFERANDEARNMIS '','','','','','','','','','','REFERRERMIS'
USP_REFERANDEARNMIS '','','','','','','','','','','REFEREEMIS'

*/


CREATE PROCEDURE [dbo].[USP_REFERANDEARNMIS]
	@DATA1 AS VARCHAR(100)='',
	@DATA2 AS VARCHAR(100)='',
	@DATA3 AS VARCHAR(100)='',
	@DATA4 AS VARCHAR(100)='',
	@DATA5 AS VARCHAR(100)='',
	@DATA6 AS VARCHAR(100)='',
	@DATA7 AS VARCHAR(100)='',
	@DATA8 AS VARCHAR(100)='',
	@DATA9 AS VARCHAR(100)='',
	@DATA10 AS VARCHAR(100)='',
	@PROCESS AS VARCHAR(100)=''
	
AS
BEGIN
				IF OBJECT_ID('TEMPDB..#REFEREE_DETAILS_TEMP') IS NOT NULL
				DROP TABLE #REFEREE_DETAILS_TEMP
				IF OBJECT_ID('TEMPDB..#CASHBACKVALIDITY') IS NOT NULL
				DROP TABLE #CASHBACKVALIDITY
				IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
				DROP TABLE #TBL_LMS_SOURCE
				IF OBJECT_ID('TEMPDB..#BROK_CASHBK') IS NOT NULL
				DROP TABLE #BROK_CASHBK
				
				DECLARE @SQL AS VARCHAR(MAX)=''
				
				
		
				IF(@PROCESS  = 'REVERSALAMOUNT')
				BEGIN
				SELECT ID,CLIENT_CODE AS [CLIENT CODE],
				CAST(BROK_EARNED AS DECIMAL(10,2))  AS [BROKERAGE GENERATED],
				DATENAME(DAY,SAUDA_DATE)+'-'+DATENAME(MONTH,SAUDA_DATE)+'-'+DATENAME(YEAR,SAUDA_DATE)  AS [TRADE DATE],
				CAST(BROK_CASHBK AS DECIMAL(10,2)) AS [BROKERAGE CASHBACK],
				CAST(REVERSEDAMT AS DECIMAL(10,2)) AS [TOTAL BROKERAGE REVERSAL AMOUNT],
				DATENAME(DAY,ADDEDON)+'-'+DATENAME(MONTH,ADDEDON)+'-'+DATENAME(YEAR,ADDEDON)  AS [ADDED ON] FROM TBL_BROKARAGEDETAILS
					
					
					
				END
				IF(@PROCESS  = 'REJECTIONMIS')
				BEGIN
					SELECT * FROM TBL_LMS_SOURCE_REJECTION
				END

				IF(@PROCESS  = 'REFERRERMIS')
				BEGIN

					--SELECT distinct CLIENT_CODE,NAME,EMAIL,MOBILE,CASE WHEN ISELEGIBLE = 1 THEN 'ELIGIBLE' ELSE 'NOT ELIGIBLE' END AS [ELIGIBLITY],
					--CASE WHEN STATUS = 1 THEN 'ACTIVE' ELSE 'INACTIVE' END AS [STATUS]  
					--INTO #BASICDETAILS
					--FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFERRER' 


					--SELECT CLIENT_CODE,MAX(EXPIRYDT) AS [EXPIRYDATE],COUNT(1) AS [COUNTOFREFREE],
					--SUM(TOTALAMT) AS [TOTALCASHBACKAMT],SUM(REVERSEDAMT) AS REVERSEDAMT,MAX(EXPIRYDT) AS EXPIRYDT 
					--INTO #BROKARAGEDETAILS
					--FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFERRER' GROUP BY CLIENT_CODE 



					--SELECT CLIENT_CODE,SUM(BROK_EARNED) AS BROK_EARNED,SUM(BROK_CASHBK) AS BROK_CASHBK,max(REVERSEDAMT ) AS REVERSEDAMT
					--INTO #REVERSALAMT
					--FROM TBL_BROKARAGEDETAILS GROUP BY CLIENT_CODE


					--SELECT distinct A.CLIENT_CODE AS [CLIENT CODE],NAME AS NAME,EMAIL AS EMAIL,MOBILE AS MOBILE,COUNTOFREFREE AS [COUNT OF REFREE],
					--	CAST( ISNULL( TOTALCASHBACKAMT,0) AS DECIMAL(10,2)) AS [TOTAL CASH BACK AMOUNT],
					--	CAST(ISNULL(C.REVERSEDAMT,0)  AS DECIMAL(10,2)) AS [TOTAL BROKARAGE REVERSED],
					--	CAST(ISNULL(C.BROK_CASHBK,0)  AS DECIMAL(10,2))  AS [BROKARAGE REVERSAL AMOUNT],
					--	CAST(ISNULL(C.BROK_EARNED,0)  AS DECIMAL(10,2)) AS [BROKARAGE GENARATED],
					--	ELIGIBLITY,STATUS, DATENAME(DAY,EXPIRYDATE)+'-'+DATENAME(MONTH,EXPIRYDATE)+'-'+DATENAME(YEAR,EXPIRYDATE)   AS [EXPIRY DATE]
					--FROM #BROKARAGEDETAILS A
					--LEFT JOIN
					--#BASICDETAILS B
					--ON A.CLIENT_CODE = B.CLIENT_CODE 
					--LEFT JOIN #REVERSALAMT C
					--ON A.CLIENT_CODE = C.CLIENT_CODE 

					SELECT DISTINCT CLIENT_CODE,NAME,EMAIL,MOBILE--,CASE WHEN ISELEGIBLE = 1 THEN 'ELIGIBLE' ELSE 'NOT ELIGIBLE' END AS [ELIGIBLITY],
					--CASE WHEN STATUS = 1 THEN 'ACTIVE' ELSE 'INACTIVE' END AS [STATUS]  
					INTO #BASICDETAILS
					FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFERRER' 


					SELECT CLIENT_CODE,MAX(EXPIRYDT) AS [EXPIRYDATE],COUNT(1) AS [COUNTOFREFREE],
					SUM(TOTALAMT) AS [TOTALCASHBACKAMT],SUM(REVERSEDAMT) AS REVERSEDAMT,MAX(EXPIRYDT) AS EXPIRYDT 
					INTO #BROKARAGEDETAILS
					FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFERRER' GROUP BY CLIENT_CODE 

				
					SELECT sum(ISELEGIBLE) AS ELIGIBLECOUNT, REFERENCE as CLIENT_CODE
					INTO #ELEGIBLECLIENT 
					FROM TBL_ELIGIBLITYDETAILS  WHERE CLIENT_TYPE = 'REFERRER' GROUP BY REFERENCE 
					
					
					
					SELECT CLIENT_CODE,SUM(BROK_EARNED) AS BROK_EARNED,SUM(BROK_CASHBK) AS BROK_CASHBK,MAX(REVERSEDAMT ) AS REVERSEDAMT
					INTO #REVERSALAMT
					FROM TBL_BROKARAGEDETAILS GROUP BY CLIENT_CODE


					SELECT DISTINCT A.CLIENT_CODE AS [CLIENT CODE],NAME AS NAME,EMAIL AS EMAIL,MOBILE AS MOBILE,COUNTOFREFREE AS [COUNT OF REFREE],
						D.ELIGIBLECOUNT AS [ELIGIBLE COUNT OF REFREE],
						CAST( ISNULL( TOTALCASHBACKAMT,0) AS DECIMAL(10,2)) AS [TOTAL CASH BACK AMOUNT],
						CAST(ISNULL(C.REVERSEDAMT,0)  AS DECIMAL(10,2)) AS [TOTAL BROKARAGE REVERSED],
						CAST(ISNULL(C.BROK_CASHBK,0)  AS DECIMAL(10,2))  AS [BROKARAGE REVERSAL AMOUNT],
						CAST(ISNULL(C.BROK_EARNED,0)  AS DECIMAL(10,2)) AS [BROKARAGE GENARATED],
						--ELIGIBLITY, STATUS,
						 DATENAME(DAY,EXPIRYDATE)+'-'+DATENAME(MONTH,EXPIRYDATE)+'-'+DATENAME(YEAR,EXPIRYDATE)   AS [EXPIRY DATE]
					FROM #BROKARAGEDETAILS A
					LEFT JOIN
					#BASICDETAILS B
					ON A.CLIENT_CODE = B.CLIENT_CODE 
					LEFT JOIN #REVERSALAMT C
					ON A.CLIENT_CODE = C.CLIENT_CODE 
					LEFT JOIN #ELEGIBLECLIENT D
					ON A.CLIENT_CODE = D.CLIENT_CODE 
					
					
					





				END
				IF(@PROCESS  = 'REFEREEMIS')
				BEGIN
						
						SELECT A.CLIENT_CODE,A.NAME,A.EMAIL,A.MOBILE,CASE WHEN A.ISELEGIBLE = 1 THEN 'ELIGIBLE' ELSE 'NOT ELIGIBLE' END AS [ELIGIBLITY],
						CASE WHEN A.STATUS = 1 THEN 'ACTIVE' ELSE 'INACTIVE' END AS [STATUS], A.MARGINAMT,
						CASE WHEN ISNULL(A.ISSIXMONTH,0)=1 THEN 'TRUE' ELSE 'FALSE' END  AS ISSIXMONTH,
						CASE WHEN ISNULL(A.ISMARGIN,0)=1 THEN 'TRUE' ELSE 'FALSE' END  AS ISMARGIN,
						CASE WHEN ISNULL(A.ISFIRSTTRADE,0)=1 THEN 'TRUE' ELSE 'FALSE' END  AS ISFIRSTTRADE,
						B.CLIENT_CODE AS REFERRER_CODE, B.NAME AS REFERRER_NAME,B.MOBILE AS REFERRER_MOBILE
						INTO #BASICDETAILS_REFEREE
						FROM 
						(SELECT * FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFEREE') A
						JOIN
						(SELECT * FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFERRER') B
						ON A.CLIENT_CODE = B.REFERENCE

						SELECT CLIENT_CODE,MAX(EXPIRYDT) AS [EXPIRYDATE],
						SUM(TOTALAMT) AS [TOTALCASHBACKAMT],SUM(REVERSEDAMT) AS REVERSEDAMT
						INTO #BROKARAGEDETAILS_REFEREE
						FROM TBL_ELIGIBLITYDETAILS WHERE CLIENT_TYPE = 'REFEREE' GROUP BY CLIENT_CODE 


						SELECT CLIENT_CODE,SUM(BROK_EARNED) AS BROK_EARNED,SUM(BROK_CASHBK) AS BROK_CASHBK,max(REVERSEDAMT ) AS REVERSEDAMT
						INTO #REVERSALAMT_REFEREE
						FROM TBL_BROKARAGEDETAILS GROUP BY CLIENT_CODE


								
						SELECT 
						B.CLIENT_CODE AS [REFEREE CLIENT CODE],
						B.NAME AS [REFEREE NAME],
						B.EMAIL AS [REFEREE EMAIL],
						B.MOBILE AS [REFEREE MOBILE],
						REFERRER_CODE AS [REFERRER CLIENT CODE],
						REFERRER_NAME AS [REFERRER NAME],
						REFERRER_MOBILE AS [REFERRER MOBILE],
						CAST(ISNULL( A.TOTALCASHBACKAMT,0) AS DECIMAL(10,2)) AS [TOTAL CASH BACK AMOUNT],
						CAST(ISNULL( C.REVERSEDAMT,0) AS DECIMAL(10,2)) AS [TOTAL BROKARAGE REVERSED],
						CAST(ISNULL( C.BROK_CASHBK,0) AS DECIMAL(10,2)) AS [BROKARAGE REVERSAL AMOUNT],
						CAST(ISNULL( C.BROK_EARNED,0) AS DECIMAL(10,2)) AS [BROKARAGE GENARATED],
						ELIGIBLITY,STATUS,
						DATENAME(DAY,EXPIRYDATE)+'-'+DATENAME(MONTH,EXPIRYDATE)+'-'+DATENAME(YEAR,EXPIRYDATE) AS [EXPIRY DATE],
						MARGINAMT,
						ISSIXMONTH,ISMARGIN,ISFIRSTTRADE
						FROM #BROKARAGEDETAILS_REFEREE A
						LEFT JOIN
						#BASICDETAILS_REFEREE B
						ON A.CLIENT_CODE = B.CLIENT_CODE 
						LEFT JOIN #REVERSALAMT_REFEREE C
						ON A.CLIENT_CODE = C.CLIENT_CODE 

						--SELECT REFEREE_CODE,REFEREE_NAME,REFEREE_EMAIL,REFEREE_MOB,
						--REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFEREE_MARGIN_AMT,--CASE WHEN ISFIRST_TRADE='N' THEN 'Y' ELSE 'NO' END AS [TRADING CRITERIA],
						--CASE WHEN REFEREE_MARGIN_AMT>=25000 THEN 'Y' ELSE 'N' END AS [MARGIN CRITERIA],
						--CASE WHEN ISFIRST_TRADE='N' THEN 'Y' ELSE 'N' END AS ISFIRST_TRADE,EXPIRYDT
						--INTO #REFEREE_DETAILS_TEMP 
						--FROM TBL_REFEREE_DETAILS


						--SELECT  REFEREE_MARGIN_AMT,MAX(EXPIRYDT) AS EXPIRYDT,REFEREE_CODE
						--INTO #CASHBACKVALIDITY
						--FROM  TBL_REFEREE_DETAILS GROUP BY REFEREE_CODE,REFEREE_MARGIN_AMT  ORDER BY REFEREE_CODE

						--SELECT REFEREE_CODE,LEAD_GEN_DATE,LEAD_ACT_DATE,
						--CASE WHEN DATEDIFF(DAY,LEAD_GEN_DATE,LEAD_ACT_DATE)<180 THEN 'Y' ELSE 'N' END AS [TRADING CRITERIA]
						--INTO #TBL_LMS_SOURCE
						--FROM TBL_LMS_SOURCE WHERE REFEREE_CODE IN (SELECT REFEREE_CODE AS PARTY_CODE FROM #REFEREE_DETAILS_TEMP)



						--SELECT SUM(BROK_CASHBK) AS BROK_CASHBK,PARTY_CODE
						--,AMT AS [TOTAL CASH BACK  AMOUNT],SUM(BROK_EARNED) AS [TOTAL BROKERAGE GENERATED]
						-- INTO #BROK_CASHBK
						--FROM (
						--		SELECT * FROM TBL_REFSEGMENTWISE --WHERE PARTY_CODE = 'M106358'
						--		UNION
						--		SELECT * FROM TBL_REFSEGMENTWISE_LOG --WHERE PARTY_CODE = 'M106358'
						
						--)A 
						--WHERE PARTY_CODE IN (SELECT REFEREE_CODE AS PARTY_CODE FROM #REFEREE_DETAILS_TEMP)  GROUP BY PARTY_CODE,AMT


						--SELECT 
						--A.REFEREE_CODE AS [REFEREE CLIENT CODE],
						--A.REFEREE_NAME AS [REFEREE NAME],
						--A.REFEREE_EMAIL AS [REFEREE EMAIL],
						--A.REFEREE_MOB AS [REFEREE MOBILE],
						--A.REFERRER_CODE AS [REFERRER CLIENT CODE],
						--A.REFERRER_NAME AS [REFERRER NAME],--A.REFERRER_MOB AS [REFERRER MOBILE],
						--A.REFERRER_MOB AS [REFERRER MOBILE],
						--D.REFEREE_MARGIN_AMT AS [MARGIN AMOUNT],
						--CAST(C.[TOTAL CASH BACK  AMOUNT] AS DECIMAL(10,2)) AS [TOTAL CASH BACK  AMOUNT],
						--DATENAME(DAY,D.EXPIRYDT)+'-'+DATENAME(MONTH,D.EXPIRYDT)+'-'+DATENAME(YEAR,D.EXPIRYDT) AS [CASH BACK VALIDITY],
						--CAST(C.[TOTAL BROKERAGE GENERATED] AS DECIMAL(10,2)) AS [TOTAL BROKERAGE GENERATED],
						--CAST(C.BROK_CASHBK AS DECIMAL(10,2)) AS [TOTAL BROKERAGE REVERSED],
						
						--A.[MARGIN CRITERIA] AS [MARGIN CRITERIA],
						--A.ISFIRST_TRADE AS [TRADING CRITERIA],
						--A.[MARGIN CRITERIA] AS [CONSUMPTION VALIDITY CRITERIA],
						--CASE WHEN A.[MARGIN CRITERIA] ='Y' AND A.ISFIRST_TRADE ='Y' AND A.[MARGIN CRITERIA]='Y' THEN 'ELIGIBLE' ELSE 'NOT ELIGIBLE' END AS [OVERALL STATUS]
						
						
						
						--FROM  #REFEREE_DETAILS_TEMP A 
						--JOIN 
						--#TBL_LMS_SOURCE B
						--ON A.REFEREE_CODE  = B.REFEREE_CODE
						--JOIN 
						--#CASHBACKVALIDITY D
						--ON A.REFEREE_CODE  = D.REFEREE_CODE
						--JOIN 
						--#BROK_CASHBK C
						--ON A.REFEREE_CODE  = C.PARTY_CODE


				END





END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ReferandearnMIS11072017
-- --------------------------------------------------
/*
usp_ReferandearnMIS '','','','','','','','','','','ReferrerMIS'

*/


create PROCEDURE [dbo].[usp_ReferandearnMIS11072017]
	@data1 as varchar(100)='',
	@data2 as varchar(100)='',
	@data3 as varchar(100)='',
	@data4 as varchar(100)='',
	@data5 as varchar(100)='',
	@data6 as varchar(100)='',
	@data7 as varchar(100)='',
	@data8 as varchar(100)='',
	@data9 as varchar(100)='',
	@data10 as varchar(100)='',
	@process as varchar(100)=''
	
AS
BEGIN
				IF OBJECT_ID('tempdb..#REFEREE_DETAILS_temp') IS NOT NULL
				DROP TABLE #REFEREE_DETAILS_temp
				IF OBJECT_ID('tempdb..#cashbackvalidity') IS NOT NULL
				DROP TABLE #cashbackvalidity
				IF OBJECT_ID('tempdb..#TBL_LMS_SOURCE') IS NOT NULL
				DROP TABLE #TBL_LMS_SOURCE
				IF OBJECT_ID('tempdb..#BROK_CASHBK') IS NOT NULL
				DROP TABLE #BROK_CASHBK
		
		if(@process  = 'ReversalAmount')
		BEGIN
			select party_code as [client code],cast(brok_earned as decimal(10,2))  as [Brokerage Generated],cast(AMT as decimal(10,2)) AS [Brokerage reversal Amount],
			cast(AMT as decimal(10,2)) as [Total Amount], DATENAME(month,UPDATEDON)+'-'+DATENAME(year,UPDATEDON)     as [Month], '10% Brokerage reversed' as Message from TBL_REFSEGMENTWISE
		END


		if(@process  = 'ReferrerMIS')
		BEGIN
				
				select distinct REFERRER_CODE as [Referrer Client Code],REFERRER_NAME as [Referrer Name], REFERRER_EMAIL as [Referrer Email],
				REFERRER_MOB as [Referrer Mobile] into #REFERRER_DETAILS_temp from TBL_REFEREE_DETAILS


				select distinct COUNT(1) as [Count of Referee],REFERRER_CODE,MAX(EXPIRYDT)  as EXPIRYDT ,
				case when cast(MAX(EXPIRYDT) as DATE)>= getdate() then 'Active' else 'Expired/Not Eligible'  end as Brokrage_Status 
				into #CountOfReferee
				from TBL_REFEREE_DETAILS  --where REFERRER_CODE = 'F3981'
				where REFERRER_CODE in (select [Referrer Client Code] as REFERRER_CODE from #REFERRER_DETAILS_temp) 
				group by REFERRER_CODE,EXPIRYDT

				select distinct SUM(AMT) as BROK_CASHBK,party_code,sum(BROK_EARNED) AS BROK_EARNED ,SUM(BROK_EARNED) AS Brokerage_Reversed  
				into #REFERRER_BROK_CASHBK 
				from TBL_REFSEGMENTWISE 
				where PARTY_CODE in (select [Referrer Client Code] as PARTY_CODE from #REFERRER_DETAILS_temp)  
				group by PARTY_CODE


				select distinct a.*,b.[Count of Referee],b.EXPIRYDT as [Cash back validity],C.BROK_EARNED,C.Brokerage_Reversed,
				b.[Count of Referee],cast(c.BROK_CASHBK as decimal(10,2)) as 'Total Cash back  Amount',
				cast(c.BROK_CASHBK as decimal(10,2)) as 'Total Brokerage Reversed',B.[Brokrage_Status]  from #REFERRER_DETAILS_temp a 
				left join 
				#CountOfReferee b
				on a.[Referrer Client Code]  = b.REFERRER_CODE
				left join 
				#REFERRER_BROK_CASHBK c
				on a.[Referrer Client Code]  = c.party_code





		END
		if(@process  = 'RefereeMIS')
		BEGIN
				
		
		
				select REFEREE_CODE,REFEREE_NAME,REFEREE_EMAIL,REFEREE_MOB,
				REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFEREE_MARGIN_AMT,--case when ISFIRST_TRADE='N' then 'Y' else 'NO' end as [Trading Criteria],
				case when REFEREE_MARGIN_AMT>=25000 then 'Y' else 'N' end AS [Margin Criteria],
				case when ISFIRST_TRADE='N' then 'Y' else 'N' end as ISFIRST_TRADE,EXPIRYDT
				into #REFEREE_DETAILS_temp 
				from TBL_REFEREE_DETAILS


				SELECT  REFEREE_MARGIN_AMT,MAX(EXPIRYDT) as EXPIRYDT,REFEREE_CODE
				into #cashbackvalidity
				from  TBL_REFEREE_DETAILS group by REFEREE_CODE,REFEREE_MARGIN_AMT  order by REFEREE_CODE

				select REFEREE_CODE,LEAD_GEN_DATE,LEAD_ACT_DATE,
				case when DATEDIFF(day,LEAD_GEN_DATE,LEAD_ACT_DATE)<180 then 'Y' ELSE 'N' end as [Trading Criteria]
				into #TBL_LMS_SOURCE
				from TBL_LMS_SOURCE where REFEREE_CODE in (select REFEREE_CODE as PARTY_CODE from #REFEREE_DETAILS_temp)



				select SUM(BROK_CASHBK) as BROK_CASHBK,party_code into #BROK_CASHBK
				from TBL_REFSEGMENTWISE 
				where PARTY_CODE in (select REFEREE_CODE as PARTY_CODE from #REFEREE_DETAILS_temp)  group by PARTY_CODE


				select 
				a.REFEREE_CODE as [Referee Client Code],
				a.REFEREE_NAME as [Referee Name],a.REFEREE_EMAIL as [Referee Email],a.REFEREE_MOB as [Referee Mobile]
				,a.REFERRER_CODE as [Referrer Client Code],a.REFERRER_NAME as [Referrer Name],a.REFERRER_MOB as [Referrer Mobile],
				a.REFERRER_MOB as [Referrer Mobile],d.REFEREE_MARGIN_AMT as [Margin Amount],c.BROK_CASHBK as [Total Cash back  Amount]
				,d.EXPIRYDT as [Cash back validity],c.BROK_CASHBK as [Total Brokerage Reversed],a.[Margin Criteria] as [Margin Criteria],a.ISFIRST_TRADE as [Trading Criteria]
				,a.[Margin Criteria] as [Consumption Validity Criteria]  
				from  #REFEREE_DETAILS_temp a 
				left join 
				#TBL_LMS_SOURCE b
				on a.REFEREE_CODE  = b.REFEREE_CODE
				left join 
				#cashbackvalidity d
				on a.REFEREE_CODE  = d.REFEREE_CODE
				left join 
				#BROK_CASHBK c
				on a.REFEREE_CODE  = c.party_code


		END





END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN
-- --------------------------------------------------

CREATE PROC [dbo].[USP_REFFER_EARN]
AS
BEGIN
		declare @dayname varchar(20)=''
		declare @isholiday int = 0
		select @isholiday = count(cast(hdate as date)) from [196.1.115.239].harmony.dbo.HOLIMST where cast(hdate as date) = cast(GETDATE() as date)

		set @dayname = DATENAME(dw, GETDATE())
		if((@dayname <> 'Saturday' or @dayname <>  'Sunday') and @isholiday =0)
		begin

				IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
				DROP TABLE #TBL_LMS_SOURCE




				SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE

				--Insert of Tradding Brokerage

				IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
				DROP TABLE #COMB_CLI

				DECLARE @SAUDA_DATE VARCHAR(12)

				SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
				PRINT @SAUDA_DATE

				select * into #COMB_CLI from [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE




				---6 MONTH VALIDATION
				DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6


				---CHECK MARGIN AMOUNT OF REFREE 

				--delete b from (SELECT PARTY_CODE ,SUM(IMARGIN) AS  REFEREE_MARGIN_AMT FROM [196.1.115.182].GENERAL.DBO.RMS_DTCLFI GROUP BY PARTY_CODE)a
				--join (select REFEREE_CODE as party_code from #TBL_LMS_SOURCE)b
				--on a.party_code=b.party_code
				--where a.margin <25000


				----REMOVE DUPLICATE DATA FROM SOURCE

				DELETE A
				FROM #TBL_LMS_SOURCE A JOIN 
				TBL_REFEREE_DETAILS B
				ON A.REFEREE_CODE=B.REFEREE_CODE

				DELETE L FROM
				#TBL_LMS_SOURCE L LEFT JOIN  #COMB_CLI C
				ON L.REFEREE_CODE=C.party_code
				WHERE C.party_code IS NULL



				---CHECK ISFIRST_TRADE OR NOT THEN 

				UPDATE M
				SET M.ISFIRST_TRADE='N'
				 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
				JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON M.REFEREE_CODE=X.CL_CODE

				---ADD TO MAIN TABLE


				--SELECT * FROM TBL_REFEREE_DETAILS


				INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT],EXPIRYDT)
				SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],REFEREE_MARGIN_AMT,[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],250001 as [REFERRER_MARGIN_AMT], CAST( CAST ( GETDATE() +365 AS VARCHAR(20)) AS DATE) FROM 
				(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0)) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
				 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
				JOIN #TBL_LMS_SOURCE B
				ON B.REFEREE_CODE=A.REFEREE_CODE
				JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
				ON B.REFERRER_CODE=C.REFERRER_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFEREE_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code)D
				ON D.PARTY_CODE=B.REFEREE_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFERRER_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code )E
				ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

				----VALIDATION 

				UPDATE TBL_REFEREE_DETAILS
				SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 






				 --   DECLARE @ID AS int  
					--DECLARE @REFEREE_CODE AS varchar (50) 
					--DECLARE @REFEREE_MOB AS varchar (50) 
					--DECLARE @REFEREE_NAME AS varchar (50) 
					--DECLARE @REFEREE_EMAIL AS varchar (50) 
					--DECLARE @REFERRER_CODE AS varchar (50) 
					--DECLARE @REFERRER_NAME AS varchar (50) 
					--DECLARE @REFERRER_MOB AS varchar (50) 
					--DECLARE @REFERRER_EMAIL AS varchar (50) 

					--DECLARE @CURR_REFEREE_DETAILS CURSOR
					--SET @CURR_REFEREE_DETAILS = CURSOR FOR
					--SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
					--FROM TBL_REFEREE_DETAILS
					--OPEN @CURR_REFEREE_DETAILS
					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--WHILE @@FETCH_STATUS = 0
					--BEGIN

					-------LOGIC
					--SELECT @REFEREE_CODE

					----EXEC USP_SENDMAIL


					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--END
					--CLOSE @CURR_REFEREE_DETAILS
					--DEALLOCATE @CURR_REFEREE_DETAILS



					/*ADDED BY SANDEEP ON 23 MAY 2017*/	
					
					

						DECLARE @STR AS VARCHAR(MAX)=''

						SELECT @STR=@STR+','+ REFEREE_CODE+','+REFERRER_CODE   FROM TBL_REFEREE_DETAILS WHERE EXPIRYDT> CAST( CAST( GETDATE() AS VARCHAR(20)) AS DATE) and REFER_STATUS <> 2

						SELECT @STR= SUBSTRING(@STR,2,LEN(@STR)) 

						--select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',') GROUP BY items  



						-- Party code cash back brok Log Details tables
						insert into TBL_REFSEGMENTWISE_Log
						 select	t.PARTY_CODE,t.BROK_EARNED,t.SAUDA_DATE,t.BROK_CASHBK,t.ADDEDBY,t.ADDEDON,t.AMT,t.REMAININGAMT,getdate()            from TBL_REFSEGMENTWISE t inner join #COMB_CLI c
						 on t.party_code=c.party_code
						 --WHERE CONVERT(VARCHAR(12),t.EntryDate,106)<>CONVERT(VARCHAR(12),GETDATE(),106)




						 -----UPDATE REAMING BALANCE AND AMT BASED ON EXPIRY OR NEW ADD REFRENCE

						UPDATE A
						SET A.AMT=B.AMT,
						A.REMAININGAMT=CASE WHEN A.REMAININGAMT > B.AMT THEN B.AMT ELSE CASE WHEN A.AMT> B.AMT 
						THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (B.AMT-A.AMT) END END

						FROM TBL_REFSEGMENTWISE A with(nolock)
						inner Join
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )B
						ON A.party_code=B.PARTY_CODE
						WHERE A.AMT<>B.AMT


						 --Daily Update of Cash Back Brokerage
						UPDATE A
						SET 				
						Brok_earned=X.Brok_earned,
						sauda_date=x.SAUDA_DATE,
						Amt=x.Amt,
						BROK_CASHBK=CASE WHEN REMAININGAMT < (x.Brok_earned*0.1) THEN REMAININGAMT ELSE (x.Brok_earned*0.1) END,				
						--A.REMAININGAMT=CASE WHEN (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)< (X.Brok_earned*0.1) THEN 0 ELSE  (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1) END,
						A.REMAININGAMT=CASE WHEN (A.REMAININGAMT)< (X.Brok_earned*0.1) THEN 0 ELSE  A.REMAININGAMT-(X.Brok_earned*0.1) END,
						UPDATEDON=GETDATE()
						
						--select x.*,
						--(CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1)
						
						FROM TBL_REFSEGMENTWISE A with(nolock) inner Join
						  
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						where sauda_date>=@SAUDA_DATE 
						group by C.party_code,C.SAUDA_DATE,A.AMT
						)X
						on A.party_code=x.party_code
						WHERE CONVERT(VARCHAR(12),A.UPDATEDON,106)<>CONVERT(VARCHAR(12),GETDATE(),106)

					

						
						--insert New Client Cash back Details 

						INSERT INTO TBL_REFSEGMENTWISE(PARTY_CODE,BROK_EARNED,SAUDA_DATE,AMT,BROK_CASHBK,REMAININGAMT,ADDEDBY,ADDEDON,UPDATEDON)
						SELECT X.*,
						case when X.Brok_earned*0.1>Amt then Amt else  X.Brok_earned*0.1 end,case when  X.Brok_earned*0.1>Amt then 0 else  AMT-(X.Brok_earned*0.1) end AS REMAININGAMT,'SYSTEM',GETDATE(),GETDATE()
						FROM
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						left JOIN TBL_REFSEGMENTWISE LM
						ON LM.PARTY_CODE=A.PARTY_CODE
						where C.sauda_date>=@SAUDA_DATE AND LM.Party_code is null
						group by C.party_code,C.SAUDA_DATE,A.AMT
						--order by party_code
						)X

						
		end

					/*ENDED BY SANDEEP ON 23 MAY 2017*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN_07062017
-- --------------------------------------------------

CREATE PROC [dbo].[USP_REFFER_EARN_07062017]
AS
BEGIN

IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
DROP TABLE #TBL_LMS_SOURCE


SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE


---6 MONTH VALIDATION
DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6

---CHECK ISFIRST_TRADE OR NOT THEN 

UPDATE M
SET M.ISFIRST_TRADE='N'
 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
ON M.REFEREE_CODE=X.CL_CODE

---ADD TO MAIN TABLE



INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT],EXPIRYDT)
SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],250001 as [REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],250001 as [REFERRER_MARGIN_AMT],GETDATE()+365 FROM 
(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)* -1) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0) * -1) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
JOIN #TBL_LMS_SOURCE B
ON B.REFEREE_CODE=A.REFEREE_CODE
JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
ON B.REFERRER_CODE=C.REFERRER_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFEREE_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK) WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )D
ON D.PARTY_CODE=B.REFEREE_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFERRER_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK)  WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )E
ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

----VALIDATION 

UPDATE TBL_REFEREE_DETAILS
SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 






    DECLARE @ID AS int  
	DECLARE @REFEREE_CODE AS varchar (50) 
	DECLARE @REFEREE_MOB AS varchar (50) 
	DECLARE @REFEREE_NAME AS varchar (50) 
	DECLARE @REFEREE_EMAIL AS varchar (50) 
	DECLARE @REFERRER_CODE AS varchar (50) 
	DECLARE @REFERRER_NAME AS varchar (50) 
	DECLARE @REFERRER_MOB AS varchar (50) 
	DECLARE @REFERRER_EMAIL AS varchar (50) 

	DECLARE @CURR_REFEREE_DETAILS CURSOR
	SET @CURR_REFEREE_DETAILS = CURSOR FOR
	SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
	FROM TBL_REFEREE_DETAILS
	OPEN @CURR_REFEREE_DETAILS
	FETCH NEXT
	FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	WHILE @@FETCH_STATUS = 0
	BEGIN

	-----LOGIC
	SELECT @REFEREE_CODE

	--EXEC USP_SENDMAIL


	FETCH NEXT
	FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	END
	CLOSE @CURR_REFEREE_DETAILS
	DEALLOCATE @CURR_REFEREE_DETAILS



	/*ADDED BY SANDEEP ON 23 MAY 2017*/	
	
		DECLARE @STR AS VARCHAR(MAX)=''

		SELECT @STR=@STR+','+ REFEREE_CODE+','+REFERRER_CODE   FROM TBL_REFEREE_DETAILS WHERE EXPIRYDT>GETDATE() 

		SELECT @STR= SUBSTRING(@STR,2,LEN(@STR)) 

		select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items  


		DECLARE @SAUDA_DATE VARCHAR(12)

		SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
		PRINT @SAUDA_DATE
		
		--select * into #COMB_CLI from [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE

		--INSERT INTO TBL_REFSEGMENTWISE
		SELECT X.*,X.Brok_earned*0.1 ,AMT AS TOTAMT,AMT-(X.Brok_earned*0.1) AS REMAININGAMT,'SYSTEM',GETDATE() 
		FROM
		(
		select C.party_code,C.segment,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
		from #COMB_CLI   C with(nolock) 
		INNER JOIN 
		(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items )A
		ON C.party_code=A.PARTY_CODE
		where sauda_date>=@SAUDA_DATE 
		group by C.party_code,C.segment,C.SAUDA_DATE,A.AMT
		--order by party_code
		)X


	/*ENDED BY SANDEEP ON 23 MAY 2017*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN_13062017
-- --------------------------------------------------
create PROC [dbo].[USP_REFFER_EARN_13062017]
AS
BEGIN

IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
DROP TABLE #TBL_LMS_SOURCE




SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE



---6 MONTH VALIDATION
DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6


----REMOVE DUPLICATE DATA FROM SOURCE

DELETE A
FROM #TBL_LMS_SOURCE A JOIN 
TBL_REFEREE_DETAILS B
ON A.REFEREE_CODE=B.REFEREE_CODE

---CHECK ISFIRST_TRADE OR NOT THEN 

UPDATE M
SET M.ISFIRST_TRADE='N'
 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
ON M.REFEREE_CODE=X.CL_CODE

---ADD TO MAIN TABLE


SELECT * FROM TBL_REFEREE_DETAILS


INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT],EXPIRYDT)
SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],250001 as [REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],250001 as [REFERRER_MARGIN_AMT], CAST( CAST ( GETDATE() +365 AS VARCHAR(20)) AS DATE) FROM 
(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)* -1) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0) * -1) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
JOIN #TBL_LMS_SOURCE B
ON B.REFEREE_CODE=A.REFEREE_CODE
JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
ON B.REFERRER_CODE=C.REFERRER_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFEREE_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK) WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )D
ON D.PARTY_CODE=B.REFEREE_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFERRER_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK)  WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )E
ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

----VALIDATION 

UPDATE TBL_REFEREE_DETAILS
SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 






 --   DECLARE @ID AS int  
	--DECLARE @REFEREE_CODE AS varchar (50) 
	--DECLARE @REFEREE_MOB AS varchar (50) 
	--DECLARE @REFEREE_NAME AS varchar (50) 
	--DECLARE @REFEREE_EMAIL AS varchar (50) 
	--DECLARE @REFERRER_CODE AS varchar (50) 
	--DECLARE @REFERRER_NAME AS varchar (50) 
	--DECLARE @REFERRER_MOB AS varchar (50) 
	--DECLARE @REFERRER_EMAIL AS varchar (50) 

	--DECLARE @CURR_REFEREE_DETAILS CURSOR
	--SET @CURR_REFEREE_DETAILS = CURSOR FOR
	--SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
	--FROM TBL_REFEREE_DETAILS
	--OPEN @CURR_REFEREE_DETAILS
	--FETCH NEXT
	--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	--WHILE @@FETCH_STATUS = 0
	--BEGIN

	-------LOGIC
	--SELECT @REFEREE_CODE

	----EXEC USP_SENDMAIL


	--FETCH NEXT
	--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	--END
	--CLOSE @CURR_REFEREE_DETAILS
	--DEALLOCATE @CURR_REFEREE_DETAILS



	/*ADDED BY SANDEEP ON 23 MAY 2017*/	
	
	
IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
DROP TABLE #COMB_CLI

		DECLARE @STR AS VARCHAR(MAX)=''

		SELECT @STR=@STR+','+ REFEREE_CODE+','+REFERRER_CODE   FROM TBL_REFEREE_DETAILS WHERE EXPIRYDT> CAST( CAST( GETDATE() AS VARCHAR(20)) AS DATE)

		SELECT @STR= SUBSTRING(@STR,2,LEN(@STR)) 

		select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items  

			DECLARE @SAUDA_DATE VARCHAR(12)

		SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
		PRINT @SAUDA_DATE
		
		select * into #COMB_CLI from [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE

		-- Party code cash back brok Log Details tables
		insert into TBL_REFSEGMENTWISE_Log
		 select	t.PARTY_CODE,t.BROK_EARNED,t.SAUDA_DATE,t.BROK_CASHBK,t.ADDEDBY,t.ADDEDON,t.AMT,t.REMAININGAMT            from TBL_REFSEGMENTWISE t inner join #COMB_CLI c
		 on t.party_code=c.party_code



		 -----UPDATE REAMING BALANCE AND AMT BASED ON EXPIRY OR NEW ADD REFRENCE

		UPDATE A
		SET A.AMT=B.AMT,
		A.REMAININGAMT=CASE WHEN A.REMAININGAMT > B.AMT THEN B.AMT ELSE CASE WHEN A.AMT> B.AMT 
		THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (B.AMT-A.AMT) END END

		FROM TBL_REFSEGMENTWISE A with(nolock)
		inner Join
		(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items )B
		ON A.party_code=B.PARTY_CODE
		WHERE A.AMT<>B.AMT


		 --Daily Update of Cash Back Brokerage
		UPDATE A
		SET 				
		Brok_earned=X.Brok_earned,
		sauda_date=x.SAUDA_DATE,
		Amt=x.Amt,
		BROK_CASHBK=CASE WHEN REMAININGAMT < (x.Brok_earned*0.1) THEN REMAININGAMT ELSE (x.Brok_earned*0.1) END,				
		--A.REMAININGAMT=CASE WHEN (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)< (X.Brok_earned*0.1) THEN 0 ELSE  (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1) END,
		A.REMAININGAMT=CASE WHEN (A.REMAININGAM)< (X.Brok_earned*0.1) THEN 0 ELSE  A.REMAININGAM-(X.Brok_earned*0.1) END,
		UPDATEDON=GETDATE()
		
		--select x.*,
		--(CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1)
		
		FROM TBL_REFSEGMENTWISE A with(nolock) inner Join
		  
		(
		select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
		from #COMB_CLI   C with(nolock) 
		INNER JOIN 
		(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items )A
		ON C.party_code=A.PARTY_CODE
		where sauda_date>=@SAUDA_DATE 
		group by C.party_code,C.SAUDA_DATE,A.AMT
		)X
		on A.party_code=x.party_code
		WHERE CONVERT(VARCHAR(12),A.UPDATEDON,106)<>CONVERT(VARCHAR(12),GETDATE(),106)

	

		
		--insert New Client Cash back Details 

		INSERT INTO TBL_REFSEGMENTWISE(PARTY_CODE,BROK_EARNED,SAUDA_DATE,AMT,BROK_CASHBK,REMAININGAMT,ADDEDBY,ADDEDON,UPDATEDON)
		SELECT X.*,
		case when X.Brok_earned*0.1>Amt then Amt else  X.Brok_earned*0.1 end,case when  X.Brok_earned*0.1>Amt then 0 else  AMT-(X.Brok_earned*0.1) end AS REMAININGAMT,'SYSTEM',GETDATE(),GETDATE()
		FROM
		(
		select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
		from #COMB_CLI   C with(nolock) 
		INNER JOIN 
		(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
		GROUP BY items )A
		ON C.party_code=A.PARTY_CODE
		left JOIN TBL_REFSEGMENTWISE LM
		ON LM.PARTY_CODE=A.PARTY_CODE
		where C.sauda_date>=@SAUDA_DATE AND LM.Party_code is null
		group by C.party_code,C.SAUDA_DATE,A.AMT
		--order by party_code
		)X

		


	/*ENDED BY SANDEEP ON 23 MAY 2017*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN_23052017
-- --------------------------------------------------
create PROC [dbo].[USP_REFFER_EARN_23052017]
AS
BEGIN

IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
DROP TABLE #TBL_LMS_SOURCE


SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE


---6 MONTH VALIDATION
DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6

---CHECK ISFIRST_TRADE OR NOT THEN 

UPDATE M
SET M.ISFIRST_TRADE='N'
 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
ON M.REFEREE_CODE=X.CL_CODE

---ADD TO MAIN TABLE



INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT])
SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT] FROM 
(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)* -1) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0) * -1) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
JOIN #TBL_LMS_SOURCE B
ON B.REFEREE_CODE=A.REFEREE_CODE
JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
ON B.REFERRER_CODE=C.REFERRER_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFEREE_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK) WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )D
ON D.PARTY_CODE=B.REFEREE_CODE
LEFT JOIN (SELECT SUM( MARGINAMT) AS REFERRER_MARGIN_AMT ,PARTY_CODE FROM [196.1.115.132].CMS.DBO.NCMS_SEGWISECLDATA WITH (NOLOCK)  WHERE MARGINAMT < 0.00 GROUP BY PARTY_CODE  )E
ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

----VALIDATION 

UPDATE TBL_REFEREE_DETAILS
SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 



    DECLARE @ID AS int  
	DECLARE @REFEREE_CODE AS varchar (50) 
	DECLARE @REFEREE_MOB AS varchar (50) 
	DECLARE @REFEREE_NAME AS varchar (50) 
	DECLARE @REFEREE_EMAIL AS varchar (50) 
	DECLARE @REFERRER_CODE AS varchar (50) 
	DECLARE @REFERRER_NAME AS varchar (50) 
	DECLARE @REFERRER_MOB AS varchar (50) 
	DECLARE @REFERRER_EMAIL AS varchar (50) 

	DECLARE @CURR_REFEREE_DETAILS CURSOR
	SET @CURR_REFEREE_DETAILS = CURSOR FOR
	SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
	FROM TBL_REFEREE_DETAILS
	OPEN @CURR_REFEREE_DETAILS
	FETCH NEXT
	FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	WHILE @@FETCH_STATUS = 0
	BEGIN

	-----LOGIC
	SELECT @REFEREE_CODE

	EXEC USP_SENDMAIL


	FETCH NEXT
	FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
	END
	CLOSE @CURR_REFEREE_DETAILS
	DEALLOCATE @CURR_REFEREE_DETAILS


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN_25_Jul_2017
-- --------------------------------------------------

create  PROC [dbo].[USP_REFFER_EARN_25_Jul_2017]
AS
BEGIN
		declare @dayname varchar(20)=''
		declare @isholiday int = 0
		select @isholiday = count(cast(hdate as date)) from [196.1.115.239].harmony.dbo.HOLIMST where cast(hdate as date) = cast(GETDATE() as date)

		set @dayname = DATENAME(dw, GETDATE())
		if((@dayname <> 'Saturday' or @dayname <>  'Sunday') and @isholiday =0)
		begin

				IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
				DROP TABLE #TBL_LMS_SOURCE




				SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE

				--Insert of Tradding Brokerage

				IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
				DROP TABLE #COMB_CLI

				DECLARE @SAUDA_DATE VARCHAR(12)

				SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
				PRINT @SAUDA_DATE

				select * into #COMB_CLI from [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE




				---6 MONTH VALIDATION
				DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6


				---CHECK MARGIN AMOUNT OF REFREE 

				--delete b from (SELECT PARTY_CODE ,SUM(IMARGIN) AS  REFEREE_MARGIN_AMT FROM [196.1.115.182].GENERAL.DBO.RMS_DTCLFI GROUP BY PARTY_CODE)a
				--join (select REFEREE_CODE as party_code from #TBL_LMS_SOURCE)b
				--on a.party_code=b.party_code
				--where a.margin <25000


				----REMOVE DUPLICATE DATA FROM SOURCE

				DELETE A
				FROM #TBL_LMS_SOURCE A JOIN 
				TBL_REFEREE_DETAILS B
				ON A.REFEREE_CODE=B.REFEREE_CODE

				DELETE L FROM
				#TBL_LMS_SOURCE L LEFT JOIN  #COMB_CLI C
				ON L.REFEREE_CODE=C.party_code
				WHERE C.party_code IS NULL



				---CHECK ISFIRST_TRADE OR NOT THEN 

				UPDATE M
				SET M.ISFIRST_TRADE='N'
				 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
				JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON M.REFEREE_CODE=X.CL_CODE

				---ADD TO MAIN TABLE


				--SELECT * FROM TBL_REFEREE_DETAILS


				INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT],EXPIRYDT)
				SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],REFEREE_MARGIN_AMT,[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],250001 as [REFERRER_MARGIN_AMT], CAST( CAST ( GETDATE() +365 AS VARCHAR(20)) AS DATE) FROM 
				(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0)) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
				 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
				JOIN #TBL_LMS_SOURCE B
				ON B.REFEREE_CODE=A.REFEREE_CODE
				JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
				ON B.REFERRER_CODE=C.REFERRER_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFEREE_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code)D
				ON D.PARTY_CODE=B.REFEREE_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFERRER_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code )E
				ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

				----VALIDATION 

				UPDATE TBL_REFEREE_DETAILS
				SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 






				 --   DECLARE @ID AS int  
					--DECLARE @REFEREE_CODE AS varchar (50) 
					--DECLARE @REFEREE_MOB AS varchar (50) 
					--DECLARE @REFEREE_NAME AS varchar (50) 
					--DECLARE @REFEREE_EMAIL AS varchar (50) 
					--DECLARE @REFERRER_CODE AS varchar (50) 
					--DECLARE @REFERRER_NAME AS varchar (50) 
					--DECLARE @REFERRER_MOB AS varchar (50) 
					--DECLARE @REFERRER_EMAIL AS varchar (50) 

					--DECLARE @CURR_REFEREE_DETAILS CURSOR
					--SET @CURR_REFEREE_DETAILS = CURSOR FOR
					--SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
					--FROM TBL_REFEREE_DETAILS
					--OPEN @CURR_REFEREE_DETAILS
					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--WHILE @@FETCH_STATUS = 0
					--BEGIN

					-------LOGIC
					--SELECT @REFEREE_CODE

					----EXEC USP_SENDMAIL


					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--END
					--CLOSE @CURR_REFEREE_DETAILS
					--DEALLOCATE @CURR_REFEREE_DETAILS



					/*ADDED BY SANDEEP ON 23 MAY 2017*/	
					
					

						DECLARE @STR AS VARCHAR(MAX)=''

						SELECT @STR=@STR+','+ REFEREE_CODE+','+REFERRER_CODE   FROM TBL_REFEREE_DETAILS WHERE EXPIRYDT> CAST( CAST( GETDATE() AS VARCHAR(20)) AS DATE) and REFER_STATUS <> 2

						SELECT @STR= SUBSTRING(@STR,2,LEN(@STR)) 

						--select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',') GROUP BY items  



						-- Party code cash back brok Log Details tables
						insert into TBL_REFSEGMENTWISE_Log
						 select	t.PARTY_CODE,t.BROK_EARNED,t.SAUDA_DATE,t.BROK_CASHBK,t.ADDEDBY,t.ADDEDON,t.AMT,t.REMAININGAMT,getdate()            from TBL_REFSEGMENTWISE t inner join #COMB_CLI c
						 on t.party_code=c.party_code
						 --WHERE CONVERT(VARCHAR(12),t.EntryDate,106)<>CONVERT(VARCHAR(12),GETDATE(),106)




						 -----UPDATE REAMING BALANCE AND AMT BASED ON EXPIRY OR NEW ADD REFRENCE

						UPDATE A
						SET A.AMT=B.AMT,
						A.REMAININGAMT=CASE WHEN A.REMAININGAMT > B.AMT THEN B.AMT ELSE CASE WHEN A.AMT> B.AMT 
						THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (B.AMT-A.AMT) END END

						FROM TBL_REFSEGMENTWISE A with(nolock)
						inner Join
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )B
						ON A.party_code=B.PARTY_CODE
						WHERE A.AMT<>B.AMT


						 --Daily Update of Cash Back Brokerage
						UPDATE A
						SET 				
						Brok_earned=X.Brok_earned,
						sauda_date=x.SAUDA_DATE,
						Amt=x.Amt,
						BROK_CASHBK=CASE WHEN REMAININGAMT < (x.Brok_earned*0.1) THEN REMAININGAMT ELSE (x.Brok_earned*0.1) END,				
						--A.REMAININGAMT=CASE WHEN (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)< (X.Brok_earned*0.1) THEN 0 ELSE  (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1) END,
						A.REMAININGAMT=CASE WHEN (A.REMAININGAMT)< (X.Brok_earned*0.1) THEN 0 ELSE  A.REMAININGAMT-(X.Brok_earned*0.1) END,
						UPDATEDON=GETDATE()
						
						--select x.*,
						--(CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1)
						
						FROM TBL_REFSEGMENTWISE A with(nolock) inner Join
						  
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						where sauda_date>=@SAUDA_DATE 
						group by C.party_code,C.SAUDA_DATE,A.AMT
						)X
						on A.party_code=x.party_code
						WHERE CONVERT(VARCHAR(12),A.UPDATEDON,106)<>CONVERT(VARCHAR(12),GETDATE(),106)

					

						
						--insert New Client Cash back Details 

						INSERT INTO TBL_REFSEGMENTWISE(PARTY_CODE,BROK_EARNED,SAUDA_DATE,AMT,BROK_CASHBK,REMAININGAMT,ADDEDBY,ADDEDON,UPDATEDON)
						SELECT X.*,
						case when X.Brok_earned*0.1>Amt then Amt else  X.Brok_earned*0.1 end,case when  X.Brok_earned*0.1>Amt then 0 else  AMT-(X.Brok_earned*0.1) end AS REMAININGAMT,'SYSTEM',GETDATE(),GETDATE()
						FROM
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						left JOIN TBL_REFSEGMENTWISE LM
						ON LM.PARTY_CODE=A.PARTY_CODE
						where C.sauda_date>=@SAUDA_DATE AND LM.Party_code is null
						group by C.party_code,C.SAUDA_DATE,A.AMT
						--order by party_code
						)X

						
		end

					/*ENDED BY SANDEEP ON 23 MAY 2017*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REFFER_EARN23082017
-- --------------------------------------------------

create PROC [dbo].[USP_REFFER_EARN23082017]
AS
BEGIN
		declare @dayname varchar(20)=''
		declare @isholiday int = 0
		select @isholiday = count(cast(hdate as date)) from [196.1.115.239].harmony.dbo.HOLIMST where cast(hdate as date) = cast(GETDATE() as date)

		set @dayname = DATENAME(dw, GETDATE())
		if((@dayname <> 'Saturday' or @dayname <>  'Sunday') and @isholiday =0)
		begin

				IF OBJECT_ID('TEMPDB..#TBL_LMS_SOURCE') IS NOT NULL
				DROP TABLE #TBL_LMS_SOURCE




				SELECT * INTO #TBL_LMS_SOURCE FROM TBL_LMS_SOURCE

				--Insert of Tradding Brokerage

				IF OBJECT_ID('TEMPDB..#COMB_CLI') IS NOT NULL
				DROP TABLE #COMB_CLI

				DECLARE @SAUDA_DATE VARCHAR(12)

				SELECT @SAUDA_DATE=MAX(SAUDA_dATE) FROM [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK)
				PRINT @SAUDA_DATE

				select * into #COMB_CLI from [196.1.115.167].REMISIOR.DBO.COMB_CLI WITH(NOLOCK) where Sauda_Date=@SAUDA_DATE




				---6 MONTH VALIDATION
				DELETE FROM #TBL_LMS_SOURCE WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)>6


				---CHECK MARGIN AMOUNT OF REFREE 

				--delete b from (SELECT PARTY_CODE ,SUM(IMARGIN) AS  REFEREE_MARGIN_AMT FROM [196.1.115.182].GENERAL.DBO.RMS_DTCLFI GROUP BY PARTY_CODE)a
				--join (select REFEREE_CODE as party_code from #TBL_LMS_SOURCE)b
				--on a.party_code=b.party_code
				--where a.margin <25000


				----REMOVE DUPLICATE DATA FROM SOURCE

				DELETE A
				FROM #TBL_LMS_SOURCE A JOIN 
				TBL_REFEREE_DETAILS B
				ON A.REFEREE_CODE=B.REFEREE_CODE

				DELETE L FROM
				#TBL_LMS_SOURCE L LEFT JOIN  #COMB_CLI C
				ON L.REFEREE_CODE=C.party_code
				WHERE C.party_code IS NULL



				---CHECK ISFIRST_TRADE OR NOT THEN 

				UPDATE M
				SET M.ISFIRST_TRADE='N'
				 FROM (SELECT * FROM TBL_REFEREE_DETAILS WHERE ISFIRST_TRADE='Y') M
				JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON M.REFEREE_CODE=X.CL_CODE

				---ADD TO MAIN TABLE


				--SELECT * FROM TBL_REFEREE_DETAILS


				INSERT INTO TBL_REFEREE_DETAILS([REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],[REFEREE_MARGIN_AMT],[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS],[REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],[REFERRER_MARGIN_AMT],EXPIRYDT)
				SELECT [REFEREE_CODE],[REFEREE_MOB],[REFEREE_NAME],[REFEREE_EMAIL],REFEREE_MARGIN_AMT,[ISFIRST_TRADE],[TRADE_DATE],[REFER_STATUS], GETDATE() AS [REFER_DATE],[REFERRER_CODE],[REFERRER_NAME],[REFERRER_MOB],[REFERRER_EMAIL],250001 as [REFERRER_MARGIN_AMT], CAST( CAST ( GETDATE() +365 AS VARCHAR(20)) AS DATE) FROM 
				(SELECT A.*,C.*,B.LEAD_GEN_DATE,LEAD_ACT_DATE,(ISNULL(D.REFEREE_MARGIN_AMT,0)) AS REFEREE_MARGIN_AMT,(ISNULL(E.REFERRER_MARGIN_AMT,0)) AS REFERRER_MARGIN_AMT,-1 AS REFER_STATUS FROM
				 (SELECT COMB_LAST_DATE AS TRADE_DATE,CL_CODE AS REFEREE_CODE ,LONG_NAME AS REFEREE_NAME,MOBILE_PAGER AS REFEREE_MOB,EMAIL AS REFEREE_EMAIL,(CASE WHEN COMB_LAST_DATE IS NULL THEN 'Y' ELSE 'N' END) AS ISFIRST_TRADE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )A 
				JOIN #TBL_LMS_SOURCE B
				ON B.REFEREE_CODE=A.REFEREE_CODE
				JOIN (SELECT CL_CODE AS REFERRER_CODE ,LONG_NAME AS REFERRER_NAME,MOBILE_PAGER AS REFERRER_MOB,EMAIL AS REFERRER_EMAIL FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WITH (NOLOCK)  )C
				ON B.REFERRER_CODE=C.REFERRER_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFEREE_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code)D
				ON D.PARTY_CODE=B.REFEREE_CODE
				LEFT JOIN (select  party_code as PARTY_CODE,max(TotalMargin) as REFERRER_MARGIN_AMT from [196.1.115.132].risk.dbo.vw_ClientsTotalMargin  group by party_code )E
				ON E.PARTY_CODE=C.REFERRER_CODE)MAIN

				----VALIDATION 

				UPDATE TBL_REFEREE_DETAILS
				SET REFER_STATUS= CASE WHEN REFEREE_MARGIN_AMT < 25000 THEN  2 WHEN ISFIRST_TRADE ='Y' THEN 0 ELSE -1 END 






				 --   DECLARE @ID AS int  
					--DECLARE @REFEREE_CODE AS varchar (50) 
					--DECLARE @REFEREE_MOB AS varchar (50) 
					--DECLARE @REFEREE_NAME AS varchar (50) 
					--DECLARE @REFEREE_EMAIL AS varchar (50) 
					--DECLARE @REFERRER_CODE AS varchar (50) 
					--DECLARE @REFERRER_NAME AS varchar (50) 
					--DECLARE @REFERRER_MOB AS varchar (50) 
					--DECLARE @REFERRER_EMAIL AS varchar (50) 

					--DECLARE @CURR_REFEREE_DETAILS CURSOR
					--SET @CURR_REFEREE_DETAILS = CURSOR FOR
					--SELECT ID,REFEREE_CODE,REFEREE_MOB,REFEREE_NAME,REFEREE_EMAIL,REFERRER_CODE,REFERRER_NAME,REFERRER_MOB,REFERRER_EMAIL
					--FROM TBL_REFEREE_DETAILS
					--OPEN @CURR_REFEREE_DETAILS
					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--WHILE @@FETCH_STATUS = 0
					--BEGIN

					-------LOGIC
					--SELECT @REFEREE_CODE

					----EXEC USP_SENDMAIL


					--FETCH NEXT
					--FROM @CURR_REFEREE_DETAILS INTO @ID,@REFEREE_CODE,@REFEREE_MOB,@REFEREE_NAME,@REFEREE_EMAIL,@REFERRER_CODE,@REFERRER_NAME,@REFERRER_MOB,@REFERRER_EMAIL
					--END
					--CLOSE @CURR_REFEREE_DETAILS
					--DEALLOCATE @CURR_REFEREE_DETAILS



					/*ADDED BY SANDEEP ON 23 MAY 2017*/	
					
					

						DECLARE @STR AS VARCHAR(MAX)=''

						SELECT @STR=@STR+','+ REFEREE_CODE+','+REFERRER_CODE   FROM TBL_REFEREE_DETAILS WHERE EXPIRYDT> CAST( CAST( GETDATE() AS VARCHAR(20)) AS DATE) and REFER_STATUS <> 2

						SELECT @STR= SUBSTRING(@STR,2,LEN(@STR)) 

						--select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',') GROUP BY items  



						-- Party code cash back brok Log Details tables
						insert into TBL_REFSEGMENTWISE_Log
						 select	t.PARTY_CODE,t.BROK_EARNED,t.SAUDA_DATE,t.BROK_CASHBK,t.ADDEDBY,t.ADDEDON,t.AMT,t.REMAININGAMT,getdate()            from TBL_REFSEGMENTWISE t inner join #COMB_CLI c
						 on t.party_code=c.party_code
						 --WHERE CONVERT(VARCHAR(12),t.EntryDate,106)<>CONVERT(VARCHAR(12),GETDATE(),106)




						 -----UPDATE REAMING BALANCE AND AMT BASED ON EXPIRY OR NEW ADD REFRENCE

						UPDATE A
						SET A.AMT=B.AMT,
						A.REMAININGAMT=CASE WHEN A.REMAININGAMT > B.AMT THEN B.AMT ELSE CASE WHEN A.AMT> B.AMT 
						THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (B.AMT-A.AMT) END END

						FROM TBL_REFSEGMENTWISE A with(nolock)
						inner Join
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )B
						ON A.party_code=B.PARTY_CODE
						WHERE A.AMT<>B.AMT


						 --Daily Update of Cash Back Brokerage
						UPDATE A
						SET 				
						Brok_earned=X.Brok_earned,
						sauda_date=x.SAUDA_DATE,
						Amt=x.Amt,
						BROK_CASHBK=CASE WHEN REMAININGAMT < (x.Brok_earned*0.1) THEN REMAININGAMT ELSE (x.Brok_earned*0.1) END,				
						--A.REMAININGAMT=CASE WHEN (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)< (X.Brok_earned*0.1) THEN 0 ELSE  (CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1) END,
						A.REMAININGAMT=CASE WHEN (A.REMAININGAMT)< (X.Brok_earned*0.1) THEN 0 ELSE  A.REMAININGAMT-(X.Brok_earned*0.1) END,
						UPDATEDON=GETDATE()
						
						--select x.*,
						--(CASE WHEN A.REMAININGAMT > X.AMT THEN X.AMT ELSE CASE WHEN A.AMT> X.AMT THEN A.REMAININGAMT ELSE    A.REMAININGAMT + (X.AMT-A.AMT) END END)-(X.Brok_earned*0.1)
						
						FROM TBL_REFSEGMENTWISE A with(nolock) inner Join
						  
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						where sauda_date>=@SAUDA_DATE 
						group by C.party_code,C.SAUDA_DATE,A.AMT
						)X
						on A.party_code=x.party_code
						WHERE CONVERT(VARCHAR(12),A.UPDATEDON,106)<>CONVERT(VARCHAR(12),GETDATE(),106)

					

						
						--insert New Client Cash back Details 

						INSERT INTO TBL_REFSEGMENTWISE(PARTY_CODE,BROK_EARNED,SAUDA_DATE,AMT,BROK_CASHBK,REMAININGAMT,ADDEDBY,ADDEDON,UPDATEDON)
						SELECT X.*,
						case when X.Brok_earned*0.1>Amt then Amt else  X.Brok_earned*0.1 end,case when  X.Brok_earned*0.1>Amt then 0 else  AMT-(X.Brok_earned*0.1) end AS REMAININGAMT,'SYSTEM',GETDATE(),GETDATE()
						FROM
						(
						select C.party_code,sum(C.Brok_earned) as Brok_earned,C.SAUDA_DATE,A.AMT--,0.00,'SYSTEM',GETDATE() 
						from #COMB_CLI   C with(nolock) 
						INNER JOIN 
						(select items AS PARTY_CODE,COUNT(1)*5000 AS AMT FROM dbo.SPLIT(@STR, ',')
						GROUP BY items )A
						ON C.party_code=A.PARTY_CODE
						left JOIN TBL_REFSEGMENTWISE LM
						ON LM.PARTY_CODE=A.PARTY_CODE
						where C.sauda_date>=@SAUDA_DATE AND LM.Party_code is null
						group by C.party_code,C.SAUDA_DATE,A.AMT
						--order by party_code
						)X

						
		end

					/*ENDED BY SANDEEP ON 23 MAY 2017*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SENDMAIL
-- --------------------------------------------------
--Sending Mail To Client                    
            
			CREATE PROC USP_SENDMAIL 
			AS BEGIN
        DECLARE @NAME AS VARCHAR(100)='PRAMOD JADHAV'
		DECLARE @EMAIL AS VARCHAR(100)='pramod.jadhav@angelbroking.com'
		DECLARE @SENDERTYPE AS VARCHAR(50)='REFEREE'
        DECLARE @MAILHEADER AS VARCHAR(MAX)=''        
         DECLARE @MAILBOTTOM AS VARCHAR(MAX) =''       
        
         SET @MAILHEADER='<html xmlns="http://www.w3.org/1999/xhtml">        
            <head id="Head1" runat="server">        
             <title></title>        
            </head>        
            <body>        
             <div id=":148" class="ii gt adP adO">        
              <div id=":147" class="a3s aXjCH m15548d1330dd5acb">        
               <div class="adM">        
               </div>        
               <div>        
                <div class="adM">        
                </div>        
                <table align="center" border="0" cellpadding="0" cellspacing="0" style="min-width: 620px" width="620">        
                 <tbody>        
                  <tr>        
                   <td align="center" bgcolor="#0071bb" style="vertical-align: top; padding: 0px 0px 0px 0px; border-left: 1px solid #d1d1d1; border-top: 1px solid #d1d1d1; border-right: 1px solid #d1d1d1; background-color: #0071bb">        
                    <table border="0" cellpadding="0" cellspacing="0" style="min-width: 620px" width="620">        
                     <tbody>        
                      <tr>        
                       <td align="left" style="padding:10px 0px 10px 5px;" valign="bottom" width="310"><a href="http://lt.angelbroking.in/ptrack?id=cR0FAFVUDQQEAR0IAwYGDFAGVk0=AQIAUgEFVx4LVA9EWE9RWQsBSlhwVg9fVlpUSgxcC19XHVUNWw==&amp;client=12239&amp;test=1" target="_blank"><img alt="Angel Broking powered by ARQ" height="53" src="https://s3-ap-southeast-1.amazonaws.com/digitalservicing/MFS/angel-logo.jpg" style="display:block;" width="250"></a></td>     
 
                       <td align="right" valign="middle" width="325">        
                        <table border="0" cellpadding="0" cellspacing="0" width="140">        
                         <tbody>        
                          <tr>        
                           <td align="center" height="47" valign="middle">        
                            <h6 style="font-family: ''''Open Sans'''',sans-serif; font-size: 16px; color: #ffffff; line-height: auto; padding: 0; margin: 0"></h6>        </td>        
                          </tr>        
                         </tbody>        
                        </table>        
                       </td>        
                      </tr>        
                     </tbody>        
                    </table>        
                   </td>        
                  </tr>        
                 </tbody>        
                </table>        
                <table align="center" bgcolor="#ededed" cellpadding="0" cellspacing="0" width="620">        
                 <tbody>        
                  <tr>        
                   <td align="center" bgcolor="#454545" style="vertical-align: top; font-family: ''''Open Sans'''',arial,sans-serif; font-size: 20px; font-weight: 400; color: #ffffff; line-height: 30px; text-align: left; padding: 0 0 0 0; text-align: center" valign="middle">        
                    BROKERAGE REVERSAL FOR REFER N EARN </td>        
                  </tr>        
                  <tr>        
                   <td height="20px" style="border-left: 1px solid #d1d1d1; border-right: 1px solid #d1d1d1">&nbsp;</td>        
                  </tr>        
                  <tr>        
                  <td align="center" style="border-left: 1px solid #d1d1d1; border-right: 1px solid #d1d1d1">        
                  <table border="0" cellpadding="0" cellspacing="0" width="602">        
                  <tbody>        
                  <tr>        
                  <td style="padding: 0px 0px 0px 0px; background-color: #27a4a2; color: #ffffff">             
                  </tr>        
                  <tr>        
                  <td  valign="top">'        
        
         SET @MAILBOTTOM='</td>        
                     </tr>        
                    </tbody>        
                   </table>        
                  </td>        
                 </tr>        
                 <tr>        
                  <td height="10px" style="border-left: 1px solid #d1d1d1; border-right: 1px solid #d1d1d1">&nbsp;</td>        
                 </tr>        
                 <tr>        
                  <td bgcolor="#384c63" style="padding: 10px 10px 10px 10px; background-color: #384c63">        
                   <table align="left" border="0" cellpadding="0" cellspacing="0" width="28%">        
                    <tbody>        
                     <tr>        
                      <td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial,sans-serif; padding: 5px 5px 5px 5px"><a href="http://www.angelbroking.com" target="_blank">www.angelbroking.com</a></td>        
                     </tr>        
                    </tbody>        
                   </table>        
                   <table align="left" border="0" cellpadding="0" cellspacing="0" style="border-right: 1px solid #d1d1d1; border-left: 1px solid #d1d1d1" width="35%">        
                    <tbody>        
            <tr>        
                      <td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial,sans-serif; padding: 5px 5px 5px 5px">1860 200 2006 / 1860 500 5006</td>        
                     </tr>        
                    </tbody>        
                   </table>        
                   <table align="left" border="0" cellpadding="0" cellspacing="0" width="31%">        
                    <tbody>        
                     <tr>        
                      <td align="center" style="font-size: 11px; color: #ffffff; font-family: Arial,sans-serif; padding: 5px 5px 5px 5px"><a href="mailto:Ebroking@angelbroking.com " style="color: #ffffff" target="_blank">Ebroking@angelbroking.com </td>   
  
    
     
                     </tr>        
                    </tbody>        
                   </table>        
                  </td>        
                 </tr>        
                 <tr>        
                  <td align="left" style="vertical-align: top">        
                   <table border="0" cellpadding="0" cellspacing="0" width="100%">        
                    <tbody>        
                     <tr>        
                      <td bgcolor="#DBDBDB" style="font-size: 50%; color: #ffffff; font-family: Arial,sans-serif; padding: 10px 5px 5px 10px; text-align: center; background-color: #384c63">Angel Broking Private Limited, Registered Office: G-1, Ackruti Trade Centre, Road No. 7, MIDC, Andheri (E), Mumbai – 400 093. Tel: (022) 3083 7700. Fax: (022) 2835 8811, website: <a href="http://www.angelbroking.com" target="_blank">www.angelbroking.com</a>?</td>        
                     </tr>        
                    </tbody>        
                   </table>        
                  </td>        
                 </tr>        
                </tbody>        
               </table>        
               <br>        
               <div>        
               </div>        
               <img border="0" src="https://ci4.googleusercontent.com/proxy/kGU__8bP6TS7qtR9P_LldeRV_idn2XEUzyv8LrVaJBvcZw7U8jxeYdyH8VhbznmIA4zV_18zzRabfq4OfFXYNt35XZgbZnukqZiUUaCwbgylXGBK24ceiKmcWFt3_AtJB-t6J2oSA_V8CVc4bHqcrGt-W0o=s0-d-e1-ft#http://lt.angelbroking.in/ltrack?m=2619&amp;u=46933881566fc4e7116fffd6b9a591a7&amp;client=12239&amp;c=0000" class="CToWUd">        
              </div>        
              <div class="yj6qo"></div>        
              <div class="adL">        
              </div>        
             </div>        
            </div>        
           </body>        
           </html>'        
        
     DECLARE @HTMBODY AS VARCHAR(MAX)='' 
	 DECLARE @CONTENT AS VARCHAR(MAX)=''
	 IF (@SENDERTYPE='REFEREE')
	 BEGIN

	 SET @CONTENT='Your Amazon Voucher worth Rs. 5000/- has been sent via SMS and Rs. 5000/- reversal benefit on brokerage is activated as per Refer & Earn Program T&C. '

	 END
	 ELSE
	 BEGIN
	 SET @CONTENT='Your Rs. 5000/- reversal benefit on brokerage is activated as per Refer & Earn Program T&C.'
	 END
	        
     SET @HTMBODY =@MAILHEADER+'        
     <p>Dear '+substring( @NAME,1,charindex(' ',@NAME))+',</p>        
     <p>'+@CONTENT+'</p>        
     <p>For any further assistance, call on 18602002006.</p>        
     <p></p>        
     <p>Regards,</p>        
     <p>Angel Broking</p>        
     '+@MAILBOTTOM        
        
     EXEC [196.1.115.132].MSDB.DBO.Sp_send_dbmail                            
     @PROFILE_NAME = 'Intranet',                                           
     @RECIPIENTS =@Email,                                    
     @SUBJECT = 'BROKERAGE REVERSAL FOR REFER N EARN',                            
     @BODY = @HTMBODY,                            
     @BODY_FORMAT = 'HTML'         
        
        
        
        
        
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_VALIDATESOURCE
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 19/08/2017
-- DESCRIPTION:	VALIDATE REFRENCE DETAILS
-- =============================================
CREATE PROCEDURE [dbo].[USP_VALIDATESOURCE]
	
AS
BEGIN
	--update status for expired records
	update  TBL_ELIGIBLITYDETAILS 
	set status = 2
	where EXPIRYDT < CAST(GETDATE() as date) or ReversedAMT >=5000
	
	--UPDATE ISFIRST TRADE IN  TBL_ELIGIBLITYDETAILS
		UPDATE A
		SET A.ISFIRSTTRADE = 1
		FROM TBL_ELIGIBLITYDETAILS A
		JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON A.CLIENT_CODE=X.CL_CODE
				where a.CLIENT_TYPE = 'REFEREE'
	
	UPDATE TBL_ELIGIBLITYDETAILS
	SET ISELEGIBLE = CASE WHEN (ISFIRSTTRADE = 1 AND ISMARGIN = 1  AND ISSIXMONTH = 1)THEN 1 ELSE 0 END
	
	UPDATE TBL_ELIGIBLITYDETAILS
	SET EXPIRYDT = CAST( DATEADD(year, 1, getdate())  as date)
	where ISELEGIBLE = 1 and EXPIRYDT is null and ISFIRSTTRADE = 1 AND ISMARGIN = 1  	
	
	
	--SELECT DISTINCT REFEREE_CODE AS CLIENT_CODE,'REFEREE' AS CLIENT_TYPE,REFERRER_CODE AS REFERENCE, LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE INTO #TBL_LMS_SOURCE_REFEREE FROM TBL_LMS_SOURCE WHERE REFEREE_CODE NOT IN (SELECT CLIENT_CODE FROM TBL_ELIGIBLITYDETAILS)
	SELECT DISTINCT REFEREE_CODE AS CLIENT_CODE,'REFEREE' AS CLIENT_TYPE,
	REFERRER_CODE AS REFERENCE, LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,
	ENTRY_DATE,b.long_name as name,mobile_pager as mobile,EMAIL  
	INTO #TBL_LMS_SOURCE_REFEREE 
	FROM TBL_LMS_SOURCE a
	left join 
	(select cl_code,long_name,mobile_pager,EMAIL from   intranet.risk.dbo.client_details )b
	on a.REFEREE_CODE = b.cl_code
	WHERE a.REFEREE_CODE NOT IN (SELECT CLIENT_CODE FROM TBL_ELIGIBLITYDETAILS)



	select j.* INTO #TBL_LMS_SOURCE_REFERRER  from 
	(
			SELECT DISTINCT REFERRER_CODE AS CLIENT_CODE,'REFERRER' AS CLIENT_TYPE,
			REFEREE_CODE AS REFERENCE, LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,
			ENTRY_DATE,b.long_name as name,mobile_pager as mobile,EMAIL  
			FROM TBL_LMS_SOURCE a
			left join 
			(select cl_code,long_name,mobile_pager,EMAIL from   intranet.risk.dbo.client_details )b
			on a.REFERRER_CODE = b.cl_code
	)j
	left join
	(SELECT CLIENT_CODE, REFERENCE FROM TBL_ELIGIBLITYDETAILS where CLIENT_TYPE = 'REFERRER') c
	on j.CLIENT_CODE = c.CLIENT_CODE and j.REFERENCE =c.REFERENCE
	
	where c.CLIENT_CODE is null

	--SELECT DISTINCT REFERRER_CODE AS CLIENT_CODE,'REFERRER' AS CLIENT_TYPE,
	--REFERRER_CODE AS REFERENCE, LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,
	--ENTRY_DATE,b.long_name as name,mobile_pager as mobile,EMAIL  
	--INTO #TBL_LMS_SOURCE_REFERRER 
	--FROM TBL_LMS_SOURCE a
	--left join 
	--(select cl_code,long_name,mobile_pager,EMAIL from   intranet.risk.dbo.client_details )b
	--on a.REFEREE_CODE = b.cl_code
	--WHERE a.REFEREE_CODE NOT IN (SELECT CLIENT_CODE FROM TBL_ELIGIBLITYDETAILS)



	--SELECT DISTINCT REFERRER_CODE AS CLIENT_CODE,'REFERRER' AS CLIENT_TYPE,
	--REFERRER_CODE AS REFERENCE, LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,
	--ENTRY_DATE,b.long_name as name,mobile_pager as mobile,EMAIL  
	--INTO #TBL_LMS_SOURCE_REFERRER 
	--FROM TBL_LMS_SOURCE a
	--left join 
	--(select cl_code,long_name,mobile_pager,EMAIL from   intranet.risk.dbo.client_details )b
	--on a.REFEREE_CODE = b.cl_code
	
	--join
	--(SELECT CLIENT_CODE, REFERENCE FROM TBL_ELIGIBLITYDETAILS where CLIENT_TYPE = 'REFERRER') c
	--on a.REFERRER_CODE = c.CLIENT_CODE and a.REFEREE_CODE <>c.REFERENCE
	
	
	
	
	--WHERE a.REFEREE_CODE NOT IN (SELECT CLIENT_CODE FROM TBL_ELIGIBLITYDETAILS)



	--SELECT DISTINCT REFERRER_CODE AS CLIENT_CODE,'REFERRER' AS CLIENT_TYPE,REFEREE_CODE AS REFERENCE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE INTO #TBL_LMS_SOURCE_REFERRER FROM TBL_LMS_SOURCE WHERE REFERRER_CODE NOT IN (SELECT CLIENT_CODE FROM TBL_ELIGIBLITYDETAILS)
		
	-- ADD COLUMNS TO TEMP TABLE 
		ALTER TABLE  #TBL_LMS_SOURCE_REFEREE
					ADD ISFIRSTTRADE  INT,
					ISMARGIN   INT,
					MARGINAMT   VARCHAR(50),
					ISSIXMONTH   INT,
					MODIFYDATE DATETIME,
					ISELEGIBLE INT

		ALTER TABLE  #TBL_LMS_SOURCE_REFERRER
					ADD ISFIRSTTRADE  INT,
					ISMARGIN   INT,
					MARGINAMT   VARCHAR(50),
					ISSIXMONTH   INT,
					MODIFYDATE DATETIME,
					ISELEGIBLE INT
					
		--6 MONTHS VALIDATION
		UPDATE #TBL_LMS_SOURCE_REFEREE
		SET ISSIXMONTH = CASE WHEN (DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)<6)THEN 1 ELSE 0 END 
		--WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)<6
		
		UPDATE #TBL_LMS_SOURCE_REFERRER
		SET ISSIXMONTH = CASE WHEN (DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)<6)THEN 1 ELSE 0 END 
		--WHERE DATEDIFF(MM,LEAD_GEN_DATE,LEAD_ACT_DATE)<6
		
		-- UPDATE ISFIRSTTRADE 
		
		UPDATE A
		SET A.ISFIRSTTRADE = 1
		FROM #TBL_LMS_SOURCE_REFEREE A
		JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON A.CLIENT_CODE=X.CL_CODE
				
		UPDATE A
		SET A.ISFIRSTTRADE = 1
		FROM #TBL_LMS_SOURCE_REFERRER A
		JOIN (SELECT CL_CODE FROM [196.1.115.132].RISK.[DBO].[CLIENT_DETAILS] WHERE COMB_LAST_DATE IS NOT NULL)X
				ON A.CLIENT_CODE=X.CL_CODE
				
		-- MARGIN CRITERIA
		
		UPDATE A
		SET A.ISMARGIN = CASE WHEN X.MARGINAMT>=25000 THEN 1 ELSE 0 END
		,MARGINAMT = X.MARGINAMT
		FROM #TBL_LMS_SOURCE_REFEREE A
		JOIN (SELECT  PARTY_CODE  ,MAX(TOTALMARGIN) AS MARGINAMT  FROM [196.1.115.132].RISK.DBO.VW_CLIENTSTOTALMARGIN  GROUP BY PARTY_CODE)X
				ON A.CLIENT_CODE=X.PARTY_CODE
				
		--do not check referrer margin amount
		UPDATE A
		SET A.ISMARGIN =  1 
		,MARGINAMT = X.MARGINAMT
		FROM #TBL_LMS_SOURCE_REFERRER A
		JOIN (SELECT  PARTY_CODE  ,MAX(TOTALMARGIN) AS MARGINAMT  FROM [196.1.115.132].RISK.DBO.VW_CLIENTSTOTALMARGIN  GROUP BY PARTY_CODE)X
				ON A.CLIENT_CODE=X.PARTY_CODE
		
		
		
		-- UPDATE OVERALL ELIGIBLITY
		
		UPDATE #TBL_LMS_SOURCE_REFEREE
		SET MODIFYDATE	 = GETDATE(),		
		ISELEGIBLE = CASE WHEN (ISFIRSTTRADE = 1 AND ISMARGIN = 1  AND ISSIXMONTH = 1)THEN 1 ELSE 0 END
		
		UPDATE #TBL_LMS_SOURCE_REFERRER
		SET MODIFYDATE	 = GETDATE(),		
		ISELEGIBLE = CASE WHEN (ISFIRSTTRADE = 1 AND ISMARGIN = 1  AND ISSIXMONTH = 1)THEN 1 ELSE 0 END
		
		
		--ADD TEMP TABLES TO TBL_ELIGIBLITYDETAILS
		INSERT INTO TBL_ELIGIBLITYDETAILS(CLIENT_CODE,CLIENT_TYPE,REFERENCE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE,name,EMAIL,mobile,ISFIRSTTRADE,ISMARGIN,MARGINAMT,ISSIXMONTH,MODIFYDATE,ISELEGIBLE)
		SELECT CLIENT_CODE,CLIENT_TYPE,REFERENCE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE,name,EMAIL,mobile,ISFIRSTTRADE,ISMARGIN,MARGINAMT,ISSIXMONTH,MODIFYDATE,ISELEGIBLE FROM #TBL_LMS_SOURCE_REFEREE
		UNION
		SELECT CLIENT_CODE,CLIENT_TYPE,REFERENCE,LEAD_GEN_DATE,LEAD_ACT_DATE,LMS_SOURCE,ENTRY_DATE,name,EMAIL,mobile,ISFIRSTTRADE,ISMARGIN,MARGINAMT,ISSIXMONTH,MODIFYDATE,ISELEGIBLE FROM #TBL_LMS_SOURCE_REFERRER
		
		
		--update referrer status(refrrer is eligible only if refree is eligible)
		
		
		update A
		set A.ISELEGIBLE = B.ISELEGIBLE
		from TBL_ELIGIBLITYDETAILS A
		join
		(select client_code,ISELEGIBLE from TBL_ELIGIBLITYDETAILS where CLIENT_TYPE = 'REFEREE' ) B
		on a.REFERENCE = b.client_code
		where A.CLIENT_TYPE = 'REFERRER'
		
		
		--update expiry date after addition
		
		UPDATE TBL_ELIGIBLITYDETAILS
		SET --ISELEGIBLE = CASE WHEN (ISFIRSTTRADE = 1 AND ISMARGIN = 1  AND ISSIXMONTH = 1)THEN 1 ELSE 0 END,
		EXPIRYDT = case when(ISFIRSTTRADE = 1 AND ISMARGIN = 1  AND ISSIXMONTH = 1 and EXPIRYDT is null and ISELEGIBLE = 1) then CAST( DATEADD(year, 1, getdate())  as date) else null end
		where CLIENT_TYPE = 'REFEREE'

		UPDATE TBL_ELIGIBLITYDETAILS
		SET --ISELEGIBLE =  1 ,
		EXPIRYDT = case when( ISELEGIBLE = 1 and EXPIRYDT is null) then CAST( DATEADD(year, 1, getdate())  as date) else null end
		where CLIENT_TYPE = 'REFERRER'	
		
		--Update Total AMT and reversed AMT
		
		update TBL_ELIGIBLITYDETAILS
		set TotalAMT = 5000,ReversedAMT=0
		where ISELEGIBLE = 1 and TotalAMT is null and ReversedAMT is null
	
	
	
END

GO

-- --------------------------------------------------
-- TABLE dbo.Brokerage_17May2019
-- --------------------------------------------------
CREATE TABLE [dbo].[Brokerage_17May2019]
(
    [REFERRER] NVARCHAR(255) NULL,
    [FROM] DATETIME NULL,
    [BROKERAGE REVRSL] FLOAT NULL,
    [TYPE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Brokerage_Oct
-- --------------------------------------------------
CREATE TABLE [dbo].[Brokerage_Oct]
(
    [Client] NVARCHAR(255) NULL,
    [From] DATETIME NULL,
    [Sum of Eligible Reversal Amount] FLOAT NULL,
    [Type] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.er_18Jun2019
-- --------------------------------------------------
CREATE TABLE [dbo].[er_18Jun2019]
(
    [Referral Party Code] NVARCHAR(255) NULL,
    [FROM] DATETIME NULL,
    [BROKERAGE REVRSL] FLOAT NULL,
    [TYPE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Hemant_test
-- --------------------------------------------------
CREATE TABLE [dbo].[Hemant_test]
(
    [CLIENTCODE] NVARCHAR(255) NULL,
    [Offer Activation Month] DATETIME NULL,
    [Balance] FLOAT NULL,
    [Type] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RE_Nov2018
-- --------------------------------------------------
CREATE TABLE [dbo].[RE_Nov2018]
(
    [REFERRER] NVARCHAR(255) NULL,
    [FROM] DATETIME NULL,
    [BROKERAGE REVRSL] FLOAT NULL,
    [TYPE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_brok_details_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_brok_details_test]
(
    [segment] VARCHAR(10) NULL,
    [Sauda_Date] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subbrokcode] VARCHAR(10) NULL,
    [sub_remi_code] VARCHAR(10) NOT NULL,
    [party_code] CHAR(20) NULL,
    [client_name] VARCHAR(100) NULL,
    [Brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [Sub_remi_share] MONEY NULL,
    [Angel_share] MONEY NULL,
    [Fran_Share] MONEY NULL,
    [Fran_Percent] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BROKARAGEDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BROKARAGEDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [client_CODE] VARCHAR(50) NULL,
    [BROK_EARNED] MONEY NULL,
    [SAUDA_DATE] DATE NULL,
    [BROK_CASHBK] MONEY NULL,
    [ADDEDBY] VARCHAR(50) NULL,
    [ADDEDON] DATETIME NULL DEFAULT (getdate()),
    [ReversedAMT] MONEY NULL,
    [JVCreated] INT NULL DEFAULT ((0)),
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BROKARAGEDETAILS_12Sep2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BROKARAGEDETAILS_12Sep2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [client_CODE] VARCHAR(50) NULL,
    [BROK_EARNED] MONEY NULL,
    [SAUDA_DATE] DATE NULL,
    [BROK_CASHBK] MONEY NULL,
    [ADDEDBY] VARCHAR(50) NULL,
    [ADDEDON] DATETIME NULL,
    [ReversedAMT] MONEY NULL,
    [JVCreated] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BROKARAGEDETAILS_23Aug2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BROKARAGEDETAILS_23Aug2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [client_CODE] VARCHAR(50) NULL,
    [BROK_EARNED] MONEY NULL,
    [SAUDA_DATE] DATE NULL,
    [BROK_CASHBK] MONEY NULL,
    [ADDEDBY] VARCHAR(50) NULL,
    [ADDEDON] DATETIME NULL,
    [ReversedAMT] MONEY NULL,
    [JVCreated] INT NULL,
    [segment] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BROKARAGEDETAILS_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BROKARAGEDETAILS_hist]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [client_CODE] VARCHAR(50) NULL,
    [BROK_EARNED] MONEY NULL,
    [SAUDA_DATE] DATE NULL,
    [BROK_CASHBK] MONEY NULL,
    [ADDEDBY] VARCHAR(50) NULL,
    [ADDEDON] DATETIME NULL,
    [ReversedAMT] MONEY NULL,
    [JVCreated] INT NULL,
    [segment] VARCHAR(50) NULL,
    [Updated_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BrokarageSource
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BrokarageSource]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [clientcode] VARCHAR(20) NOT NULL,
    [cashbackAmt] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL,
    [ActivationDate] DATETIME NULL,
    [ExpiryDate] DATETIME NULL,
    [Application] VARCHAR(50) NOT NULL,
    [ReferCode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_coupans
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_coupans]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [startDate] DATE NOT NULL,
    [endDate] DATE NOT NULL,
    [coupanCode] VARCHAR(50) NOT NULL,
    [entryDate] DATE NOT NULL DEFAULT (getdate()),
    [isdelete] INT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_coupans_bulk_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_coupans_bulk_upload]
(
    [startDate] DATE NOT NULL,
    [endDate] DATE NOT NULL,
    [coupanCode] VARCHAR(50) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_coupans_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_coupans_log]
(
    [id] INT NOT NULL,
    [startDate] DATE NOT NULL,
    [endDate] DATE NOT NULL,
    [coupanCode] VARCHAR(50) NOT NULL,
    [entryDate] DATE NOT NULL,
    [logdate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_coupans_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_coupans_upload]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [startDate] DATE NULL,
    [endDate] DATE NULL,
    [coupanCode] VARCHAR(50) NULL,
    [entryDate] DATE NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DIYCashbackRefer
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DIYCashbackRefer]
(
    [CLIENT_CODE] NVARCHAR(255) NULL,
    [CLIENT_TYPE] NVARCHAR(255) NULL,
    [LEAD_GEN_DATE] NVARCHAR(255) NULL,
    [LEAD_ACT_DATE] DATETIME NULL,
    [LMS_SOURCE] NVARCHAR(255) NULL,
    [ENTRY_DATE] DATETIME NULL,
    [ISFIRSTTRADE] FLOAT NULL,
    [ISMARGIN] FLOAT NULL,
    [MARGINAMT] FLOAT NULL,
    [ISSIXMONTH] FLOAT NULL,
    [MODIFYDATE] NVARCHAR(255) NULL,
    [ISELEGIBLE] FLOAT NULL,
    [REFERENCE] NVARCHAR(255) NULL,
    [EXPIRYDT] DATETIME NULL,
    [name] NVARCHAR(255) NULL,
    [email] NVARCHAR(255) NULL,
    [mobile] NVARCHAR(255) NULL,
    [status] FLOAT NULL,
    [TotalAMT] FLOAT NULL,
    [ReversedAMT] FLOAT NULL,
    [cashbackPercentage] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL DEFAULT ((0)),
    [ISMARGIN] INT NULL DEFAULT ((0)),
    [MARGINAMT] VARCHAR(30) NULL DEFAULT ((0)),
    [ISSIXMONTH] INT NULL DEFAULT ((0)),
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL DEFAULT ((0)),
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL DEFAULT ((1)),
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL,
    [ReversedAMT_NSE] MONEY NULL,
    [ReversedAMT_NSEFO] MONEY NULL,
    [ReversedAMT_NSX] MONEY NULL,
    [ReversedAMT_MCX] MONEY NULL,
    [ReversedAMT_NCDEX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_01Aug2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_01Aug2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_02Jul2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_02Jul2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_12Sep2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_12Sep2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL,
    [ReversedAMT_NSE] MONEY NULL,
    [ReversedAMT_NSEFO] MONEY NULL,
    [ReversedAMT_NSX] MONEY NULL,
    [ReversedAMT_MCX] MONEY NULL,
    [ReversedAMT_NCDEX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_13Sep2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_13Sep2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL,
    [ReversedAMT_NSE] MONEY NULL,
    [ReversedAMT_NSEFO] MONEY NULL,
    [ReversedAMT_NSX] MONEY NULL,
    [ReversedAMT_MCX] MONEY NULL,
    [ReversedAMT_NCDEX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_15Nov2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_15Nov2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL,
    [ReversedAMT_NSE] MONEY NULL,
    [ReversedAMT_NSEFO] MONEY NULL,
    [ReversedAMT_NSX] MONEY NULL,
    [ReversedAMT_MCX] MONEY NULL,
    [ReversedAMT_NCDEX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_28Aug2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_28Aug2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_bk_12July2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_bk_12July2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ELIGIBLITYDETAILS_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ELIGIBLITYDETAILS_hist]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [CLIENT_TYPE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] VARCHAR(50) NULL,
    [ISFIRSTTRADE] INT NULL,
    [ISMARGIN] INT NULL,
    [MARGINAMT] VARCHAR(30) NULL,
    [ISSIXMONTH] INT NULL,
    [MODIFYDATE] DATETIME NULL,
    [ISELEGIBLE] INT NULL,
    [REFERENCE] VARCHAR(100) NULL,
    [EXPIRYDT] DATE NULL,
    [name] VARCHAR(100) NULL,
    [email] VARCHAR(100) NULL,
    [mobile] VARCHAR(20) NULL,
    [status] INT NULL,
    [TotalAMT] MONEY NULL,
    [ReversedAMT] MONEY NULL,
    [cashbackPercentage] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_JVFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_JVFILE]
(
    [Srno] VARCHAR(50) NULL,
    [VDATE] VARCHAR(10) NULL,
    [EDATE] VARCHAR(10) NULL,
    [CLTCODE] VARCHAR(50) NULL,
    [DRCR] VARCHAR(100) NOT NULL,
    [AMOUNT] VARCHAR(50) NULL,
    [NARRATION] VARCHAR(144) NULL,
    [BRANCHCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_JVFILELOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_JVFILELOG]
(
    [RecordID] INT IDENTITY(1,1) NOT NULL,
    [Srno] INT NULL,
    [id] INT NULL,
    [VDATE] VARCHAR(50) NULL,
    [EDATE] VARCHAR(50) NULL,
    [CLTCODE] VARCHAR(50) NULL,
    [DRCR] VARCHAR(50) NULL,
    [AMOUNT] VARCHAR(50) NULL,
    [NARRATION] VARCHAR(500) NULL,
    [BRANCHCODE] VARCHAR(50) NULL,
    [Logdate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LMS_SOURCE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LMS_SOURCE]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [REFEREE_CODE] VARCHAR(50) NULL,
    [REFERRER_CODE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LMS_SOURCE_log
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LMS_SOURCE_log]
(
    [ID] INT NOT NULL,
    [REFEREE_CODE] VARCHAR(50) NULL,
    [REFERRER_CODE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] DATETIME NULL,
    [logdate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LMS_SOURCE_REJECTION
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LMS_SOURCE_REJECTION]
(
    [ID] INT NULL,
    [REFEREE_CODE] VARCHAR(50) NULL,
    [REFERRER_CODE] VARCHAR(50) NULL,
    [LEAD_GEN_DATE] DATE NULL,
    [LEAD_ACT_DATE] DATE NULL,
    [LMS_SOURCE] VARCHAR(50) NULL,
    [ENTRY_DATE] DATETIME NULL,
    [reason] VARCHAR(MAX) NULL,
    [updatedon] VARCHAR(50) NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LMS_SOURCE_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LMS_SOURCE_upload]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [REFEREE_CODE] VARCHAR(100) NULL,
    [REFERRER_CODE] VARCHAR(100) NULL,
    [LEAD_GEN_DATE] VARCHAR(100) NULL,
    [LEAD_ACT_DATE] VARCHAR(100) NULL,
    [LMS_SOURCE] VARCHAR(100) NULL,
    [ENTRY_DATE] VARCHAR(100) NULL,
    [UploadDate] DATE NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_re
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_re]
(
    [REFERRER] NVARCHAR(255) NULL,
    [FROM] DATETIME NULL,
    [BROKERAGE REVRSL] FLOAT NULL,
    [TYPE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RE_Sep
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RE_Sep]
(
    [Client] NVARCHAR(255) NULL,
    [From] DATETIME NULL,
    [Sum of Eligible Reversal Amount] FLOAT NULL,
    [Type] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_refer_testingData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_refer_testingData]
(
    [Client Code] NVARCHAR(255) NULL,
    [Cashback Value] FLOAT NULL,
    [Cash Back Percentage] FLOAT NULL,
    [Activation Date] DATETIME NULL,
    [Expiry Date] DATETIME NULL,
    [Application] NVARCHAR(255) NULL,
    [Refer Code] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_REFSEGMENTWISE_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_REFSEGMENTWISE_Log]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(50) NULL,
    [BROK_EARNED] MONEY NULL,
    [SAUDA_DATE] DATETIME NULL,
    [BROK_CASHBK] MONEY NULL,
    [ADDEDBY] VARCHAR(50) NULL,
    [ADDEDON] DATETIME NULL,
    [AMT] DECIMAL(38, 8) NULL,
    [REMAININGAMT] DECIMAL(38, 8) NULL,
    [EntryDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblREAug_File
-- --------------------------------------------------
CREATE TABLE [dbo].[tblREAug_File]
(
    [Row Labels] NVARCHAR(255) NULL,
    [From] DATETIME NULL,
    [Sum of Eligible Reversal Amount] FLOAT NULL,
    [Type] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_refer_13Oct2018
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_refer_13Oct2018]
(
    [Row Labels] NVARCHAR(255) NULL,
    [From] DATETIME NULL,
    [Sum of Eligible Reversal Amount] FLOAT NULL,
    [Type] NVARCHAR(255) NULL
);

GO

