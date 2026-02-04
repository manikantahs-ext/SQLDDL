-- DDL Export
-- Server: 10.253.33.89
-- Database: MFCustomizedARQ
-- Exported: 2026-02-05T02:38:49.979566

USE MFCustomizedARQ;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_Split1
-- --------------------------------------------------

create FUNCTION [dbo].[fn_Split1](@text VARCHAR(MAX),@delimiter VARCHAR(5) = ',')   
RETURNS @Strings TABLE  
(StringValue VARCHAR(MAX))  
AS  
  
BEGIN  
 DECLARE @index INT = -1   
  
 WHILE (LEN(@text) > 0)  
 BEGIN  
  SET @index = CHARINDEX(@delimiter , @text)  
  
  IF (@index = 0) AND (LEN(@text) > 0)  
  BEGIN   
   INSERT INTO @Strings  
   VALUES (LTRIM(RTRIM(@text)))  
   BREAK  
  END  
  ELSE IF (@index > 1)  
  BEGIN   
   INSERT INTO @Strings  
   VALUES (LTRIM(RTRIM(LEFT(@text,@index - 1))))   
  
   SET @text = RIGHT(@text, (LEN(@text) - @index))  
  END  
  ELSE  
  BEGIN  
   SET @text = RIGHT(@text, (LEN(@text) - @index))  
  END  
 END  
 RETURN  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUNC_CUSTARQ_DEBTRATIO
-- --------------------------------------------------
CREATE FUNCTION FUNC_CUSTARQ_DEBTRATIO(@CLIENTCODE VARCHAR(50))
 RETURNS @DEBTRATIO TABLE(ARQ DECIMAL (38,2),FIXEDINCOME DECIMAL(38,2))
 AS BEGIN

 DECLARE @ARQ AS DECIMAL (38,2)=0
 DECLARE @FIXEDINCOME AS DECIMAL (38,2)=0

 SELECT @ARQ= ARQ,@FIXEDINCOME=FIXEDINCOME FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @CLIENTCODE

 IF(@ARQ=0 AND @FIXEDINCOME=0)
 BEGIN

 SELECT @ARQ= ARQ,@FIXEDINCOME=FIXEDINCOME FROM TBL_CUSTARQ_DEBTRATIO

 END

 INSERT INTO @DEBTRATIO
 SELECT @ARQ,@FIXEDINCOME

 RETURN 
 END

GO

-- --------------------------------------------------
-- FUNCTION dbo.UniqueRefNum
-- --------------------------------------------------
CREATE function UniqueRefNum (@r2 float, @r3 float, @r4 float)    
returns char(14)    
begin    
    -- Not sure if rand() might return 1.0    
    -- If it does, the conversion code below would produce a character that's not an    
    -- uppercase letter so let's avoid it just in case    
        
    if @r2 = 1.0 set @r2 = 0    
    if @r3 = 1.0 set @r3 = 0    
    if @r4 = 1.0 set @r4 = 0    
    
    declare @now datetime    
    set @now = getdate() -- or getutcdate()    
    
    declare @m char(2)    
    if month(@now) < 10    
        set @m = '0' + month(@now)    
    else    
        set @m = month(@now)    
    
    declare @d varchar(2)    
    if day(@now) < 10    
    begin
    set @d='0'
        set @d =  @d+ cast(day(@now) as varchar)    
        end
    else   
    begin 
        set @d = day(@now)    
    end
    return  @d + '' +                
           char(65 + cast(@r3 * 26 as int)) +     
           char(65 + cast(@r4 * 26 as int))     
               
               
end

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_CLIENT_MODE
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_CLIENT_MODE] ADD CONSTRAINT [PK_TBL_CUSTARQ_CLIENT_MODE] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_CLIENT_RISKPROFILE
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_CLIENT_RISKPROFILE] ADD CONSTRAINT [PK__TBL_CUST__3214EC2732E0915F] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_DEBTRATIO
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_DEBTRATIO] ADD CONSTRAINT [PK_TBL_ARQCUST_DEBTRATION] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_DEBTRATIO_CLIENT
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_DEBTRATIO_CLIENT] ADD CONSTRAINT [PK__TBL_CUST__3214EC271ED998B2] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_MFORDER_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_MFORDER_LOG] ADD CONSTRAINT [PK__TBL_CUST__3214EC27571DF1D5] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_MODEMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_MODEMASTER] ADD CONSTRAINT [PK_TBL_MODEMASTER] PRIMARY KEY ([RecID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_RAWNAV
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_RAWNAV] ADD CONSTRAINT [PK_TBL_RAWNAV] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CUSTARQ_UPDATELIMIT_LOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CUSTARQ_UPDATELIMIT_LOG] ADD CONSTRAINT [PK__TBL_CUST__3214EC275FB337D6] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_GetARQANS
-- --------------------------------------------------
--Prc_GetARQANS '5'
CREATE Procedure Prc_GetARQANS
(
@QID int
)
As
Begin
select RPA_iID,RPA_tANS from MST_RiskProfile_Ans with(nolock) where RPA_iRPQID=@QID
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_InsClientQANS
-- --------------------------------------------------
CREATE Procedure Prc_InsClientQANS
(
@Party_Code varchar(50),
@RPA_AgeID int,
@RPA_AgeDesc varchar(50),
@RPA_SInvestID int,
@RPA_SInvestDesc varchar(50),
@RPA_ExperienceID int,
@RPA_ExperienceDesc varchar(50),
@RPA_InvestMoneyID int,
@RPA_InvestMoneyDesc varchar(50),
@RPA_PortfolioID int,
@RPA_PortfolioDesc varchar(50),
@CreatedBy varchar(50)
)
As
Begin 
declare @RPA_AgeScore int,@RPA_SInvestScore int,@RPA_ExperienceScore int,@RPA_InvestMoneyScore int,@RPA_PortfolioScore int,@FinalScore int 

select @RPA_AgeScore = RPA_dScore from MST_RiskProfile_Ans with(nolock) where RPA_iID=@RPA_AgeID
select @RPA_SInvestScore  = RPA_dScore from MST_RiskProfile_Ans with(nolock) where RPA_iID=@RPA_SInvestID
select @RPA_ExperienceScore = RPA_dScore from MST_RiskProfile_Ans with(nolock) where RPA_iID=@RPA_ExperienceID
select @RPA_InvestMoneyScore = RPA_dScore from MST_RiskProfile_Ans with(nolock) where RPA_iID=@RPA_InvestMoneyID
select @RPA_PortfolioScore = RPA_dScore from MST_RiskProfile_Ans with(nolock) where RPA_iID=@RPA_PortfolioID


Select @FinalScore=@RPA_AgeScore +@RPA_SInvestScore+@RPA_ExperienceScore+@RPA_InvestMoneyScore+@RPA_PortfolioScore

if exists (select * from tbl_ClientQANS where party_code=@Party_Code)
Begin
update tbl_ClientQANS
set RPA_AgeID=@RPA_AgeID,RPA_AgeDesc=@RPA_AgeDesc,RPA_AgeScore=@RPA_AgeScore,RPA_SInvestID=@RPA_SInvestID,RPA_SInvestDesc=@RPA_SInvestDesc,
RPA_SInvestScore=@RPA_SInvestScore,RPA_ExperienceID=@RPA_ExperienceID,RPA_ExperienceDesc=@RPA_ExperienceDesc,RPA_ExperienceScore=@RPA_ExperienceScore,
RPA_InvestMoneyID=@RPA_InvestMoneyID,RPA_InvestMoneyDesc=@RPA_InvestMoneyDesc,RPA_InvestMoneyScore=@RPA_InvestMoneyScore,RPA_PortfolioID=@RPA_PortfolioID
,RPA_PortfolioIDDesc=@RPA_PortfolioDesc,RPA_PortfolioIDScore=@RPA_PortfolioScore,UpdatedBy=@CreatedBy,UpdatedDT=getdate()
where party_code=@party_code
End
Else
Begin
insert into tbl_ClientQANS
values
(@Party_Code,@RPA_AgeID,@RPA_AgeDesc,@RPA_AgeScore,@RPA_SInvestID,@RPA_SInvestDesc,@RPA_SInvestScore,@RPA_ExperienceID,@RPA_ExperienceDesc,@RPA_ExperienceScore,
@RPA_InvestMoneyID,@RPA_InvestMoneyDesc,@RPA_InvestMoneyScore,@RPA_PortfolioID,@RPA_PortfolioDesc,@RPA_PortfolioScore,@CreatedBy,GETDATE(),'',getdate())
End




select Score,Bucket,[Return(CAGR)],MaxDropDown,SharpeRatio,Percentage from tbl_CustomizedARQDtls with(nolock) where Score=@FinalScore



End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_findstring
-- --------------------------------------------------
create procedure [dbo].[sp_findstring]    



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
-- PROCEDURE dbo.USP_CUSTARQ_BUILD_INVESTMENTPLAN
-- --------------------------------------------------
		
CREATE PROC [dbo].[USP_CUSTARQ_BUILD_INVESTMENTPLAN]
@CLIENTCODE AS VARCHAR(50)='',
@USERNAME AS VARCHAR(200)='',
@DIVICEID AS VARCHAR(50)=''

AS BEGIN
		
	
DECLARE @PROFILE AS VARCHAR(100)
		
DECLARE @PROFILENUM AS INT =0
DECLARE @FUND AS VARCHAR(50) =''
DECLARE @SCORE AS INT=0
DECLARE @MODEID AS VARCHAR(50)='0'
DECLARE @ARQ AS VARCHAR(50)='0'
DECLARE @DEBT AS VARCHAR(50)='0'
DECLARE @CNT AS INT =0
DECLARE @STRATEGY AS VARCHAR(50)=''
DECLARE @QN7ANS AS VARCHAR(10)=''


SELECT @PROFILE=QNANS,@PROFILENUM=PROFILENUM FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@CLIENTCODE

		


SELECT A.*,C.FUND INTO #TM  FROM (SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A
JOIN 
(SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT],CAST (RPA_DSCORE AS FLOAT) AS RSCORE,RPA_TMOBANS AS FUND FROM TBL_CUSTARQ_ANS_MST)C
ON A.SCORE=C.SCORE AND A.QN =C.QN

SELECT @FUND=FUND FROM #TM WHERE QN =6

SELECT @QN7ANS=SCORE FROM #TM WHERE QN =7


SELECT @SCORE= SUM(A.SCORE)  FROM (SELECT A.QN, CASE WHEN (A.QN IN (6,7)) THEN 0 ELSE B.RSCORE END AS SCORE ,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN

,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A
JOIN 

(SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT],CAST (RPA_DSCORE AS FLOAT) AS RSCORE,RPA_TMOBANS AS FUND FROM TBL_CUSTARQ_ANS_MST)B
ON A.SCORE=B.SCORE AND A.QN =B.QN)A

DROP TABLE #TM
		

		
	

----pramod

IF(@QN7ANS=1)
BEGIN
SELECT @MODEID=MODEID ,@ARQ=ARQPERCENTAGE ,@DEBT =100- ARQPERCENTAGE  ,@STRATEGY = (CASE WHEN  CALCOPTION ='Ultra Short Term' THEN 'ALTRA' ELSE 'INCOME' END) FROM [dbo].[TBL_3STOCK_PROFILE_DATA] WHERE PROFILESID=@PROFILENUM AND FUNDID=@FUND AND SCOREID=@SCORE
END
ELSE
BEGIN
SELECT @MODEID=MODEID ,@ARQ=ARQPERCENTAGE ,@DEBT =100- ARQPERCENTAGE  ,@STRATEGY = (CASE WHEN  CALCOPTION ='Ultra Short Term' THEN 'ALTRA' ELSE 'INCOME' END) FROM [dbo].[TBL_12STOCK_PROFILE_DATA] WHERE PROFILESID=@PROFILENUM AND FUNDID=@FUND AND SCOREID=@SCORE
END






      DECLARE @CNT1 AS INT=0

        SELECT @CNT1=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@CLIENTCODE

		IF @CNT1 >0 
		BEGIN
		----UPDATE 
		UPDATE TBL_CUSTARQ_CLIENT_MODE
		SET RECID=@MODEID,
		ISDIRECT=0,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENT_CODE =@CLIENTCODE
		END
		ELSE
		BEGIN
		----INSERT 
		INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @CLIENTCODE,@MODEID,GETDATE(),0,@USERNAME,GETDATE(),@DIVICEID

		

		END


SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @CLIENTCODE

IF @CNT >0 
BEGIN
----UPDATE 
UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT
	SET ARQ=CAST (@ARQ AS FLOAT),
	FIXEDINCOME=CAST (@DEBT AS FLOAT),
	UPDATE_BY=@USERNAME,
	UPDATE_DATE=GETDATE(),
	DIVICEID=@DIVICEID
WHERE CLIENTCODE= @CLIENTCODE
END
ELSE
BEGIN
INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)
SELECT @CLIENTCODE,CAST (@ARQ AS FLOAT),CAST (@DEBT AS FLOAT),@USERNAME,GETDATE(),@DIVICEID
END

		
EXEC USP_CUSTARQ_CUST_MAIN_BUILDPLAN @CLIENTCODE,@STRATEGY
		


	
END












	






--SELECT 	RPA_dScore,RPA_tAns FROM TBL_CUSTARQ_ANS_MST

--SELECT * FROM TBL_CUSTARQ_CLIENT_RISKPROFILE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CAL_STRATEGY
-- --------------------------------------------------
---[USP_CUSTARQ_CAL_STRATEGY] 'VL001','ALTRA'
CREATE PROC [dbo].[USP_CUSTARQ_CAL_STRATEGY]

@CLEINT_CODE VARCHAR(50)='',
@STATERGY VARCHAR(50)=''

AS BEGIN


IF OBJECT_ID('TEMPDB..#CAL_UST') IS NOT NULL
    DROP TABLE #CAL_UST


	IF OBJECT_ID('TEMPDB..#OP_UST') IS NOT NULL
    DROP TABLE #OP_UST

CREATE TABLE #CAL_UST
(

ID INT IDENTITY(1,1) PRIMARY KEY,
TRADE_DATE DATE,
CUSTOM float,
ALTRA float,
BSE100 float
)

DECLARE @ARQ float=0.0
DECLARE @FIXEDINCOME float=0.0

DECLARE @VAL AS float=0.0






INSERT INTO #CAL_UST
EXEC USP_CUSTARQ_CUSTOM_CALCULATE @CLEINT_CODE,@STATERGY




SELECT @ARQ=ARQ,@FIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)


SELECT ID,TRADE_DATE,CUSTOM,ALTRA,EQUITY,DEBT,@VAL AS TOTALINVEST,@VAL AS 'EQUITYPER',@VAL AS 'DEBTPER' ,0 AS 'ISREBALANCE',@VAL AS EQUITYCHNG,@VAL AS DEBTCHNG,@VAL AS MID,
@VAL AS ULTRASHORT ,@VAL AS AFTERREBALTOTAL,@VAL AS AFTERREBALRATIO,@VAL PEEK,@VAL DIFF,@VAL DROWDOWN,@VAL DAILYCHANGE,@VAL ADJUSTED,BSE100,
@VAL AS BSEPEEK,@VAL AS BSEDIFF ,@VAL AS BSEDROWDOWN,@VAL AS BSEDAILYCHANGE,@VAL AS BSEADJUSTED
INTO #OP_UST
FROM (SELECT *,@VAL AS  EQUITY ,@VAL AS DEBT FROM #CAL_UST)A

EXEC USP_CUSTARQ_REBALANCE @STATERGY,@CLEINT_CODE



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_LIMIT_VALIDATE
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_CUST_LIMIT_VALIDATE]

 @CLIENTCODE AS VARCHAR(MAX) = ''

AS BEGIN


DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);
DECLARE @Body AS VARCHAR(8000) = ''
DECLARE @GROUPCODE AS VARCHAR(50)=''


SELECT @GROUPCODE=A.tag FROM (SELECT TOP 1   tag   FROM [mis].dbo.odinclientinfo WHERE pcode = @CLIENTCODE AND  servermapped <> '192.168.3.186')A



SET @Body = '{"strUserId" : "'+@CLIENTCODE+'","strGroupId" : "'+@GROUPCODE+'","requestID" : "","requestType":""}'


EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'post','http://196.1.115.183:120/Service1.svc/GetFundsViewData', 'false'

EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'text/plain'
EXEC sp_OAMethod @Object, 'send', null, @body

EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
SELECT @ResponseText as [RESPONSE]

EXEC sp_OADestroy @Object

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_MAIN
-- --------------------------------------------------
--USP_CUSTARQ_CUST_MAIN 'VL001'

CREATE PROC [dbo].[USP_CUSTARQ_CUST_MAIN]
@CLIANT_CODE VARCHAR(50)=''
AS BEGIN

CREATE TABLE #TBLSTATERGY
(
EQDROWDOWN FLOAT,
EQCAGR FLOAT,
EQCARMAX FLOAT,
EQAVG FLOAT,
EQSTDDEV FLOAT,
EQSQRT FLOAT,
EQSHARPRATIO FLOAT,
BSEDROWDOWN FLOAT,
BSECAGR FLOAT,
BSECARMAX FLOAT,
BSEAVG FLOAT,
BSESTDDEV FLOAT,
BSESQRT FLOAT,
BSESHARPRATIO FLOAT,
STATERGY VARCHAR(50)
)


CREATE TABLE #TBL_GRAPHDATA
(
ID INT,
TRADE_DATE DATE,
CUSTOM FLOAT,
ALTRA FLOAT,
EQUITY FLOAT,
DEBT FLOAT,
TOTALINVEST FLOAT,
EQUITYPER FLOAT,
DEBTPER FLOAT,
ISREBALANCE FLOAT,
EQUITYCHNG FLOAT,
DEBTCHNG FLOAT,
MID FLOAT,
ULTRASHORT FLOAT,
AFTERREBALTOTAL FLOAT,
AFTERREBALRATIO FLOAT,
PEEK FLOAT,
DIFF FLOAT,
DROWDOWN FLOAT,
DAILYCHANGE FLOAT,
ADJUSTED FLOAT,
BSE100 FLOAT,
BSEPEEK FLOAT,
BSEDIFF FLOAT,
BSEDROWDOWN FLOAT,
BSEDAILYCHANGE FLOAT,
BSEADJUSTED FLOAT,
STATERGY VARCHAR(50)
)


EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'ALTRA'

EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'INCOME'

SELECT ROW_NUMBER () OVER (ORDER BY (SELECT 1)) AS ID , EQDROWDOWN,
EQCAGR,
EQSHARPRATIO,
EQSTDDEV,
BSEDROWDOWN,
BSECAGR,
BSESHARPRATIO,
BSESTDDEV ,STATERGY
INTO #TBLSTATERGYFINAL
FROM #TBLSTATERGY

--DECLARE @STRID AS INT =2
--DECLARE @MAXID AS INT=0

--SELECT @MAXID =MAX(ID) FROM #TBLSTATERGYFINAL

DECLARE @STRDROWDOWN AS FLOAT =0
DECLARE @STRSTATERGY as VARCHAR(50)
DECLARE @CARGEQ AS FLOAT =0.0

DECLARE @STRDROWDOWN1 AS FLOAT =0
DECLARE @STRSTATERGY1 as VARCHAR(50)
DECLARE @CARGEQ1 AS FLOAT =0.0

SELECT @STRDROWDOWN=EQDROWDOWN, @STRSTATERGY =STATERGY,@CARGEQ=EQCAGR FROM #TBLSTATERGYFINAL WHERE ID =1

SELECT @STRDROWDOWN1=EQDROWDOWN, @STRSTATERGY1 =STATERGY,@CARGEQ1=EQCAGR FROM #TBLSTATERGYFINAL WHERE ID =2

--DELETE  FROM #TBLSTATERGYFINAL WHERE STATERGY= CASE WHEN  @STRDROWDOWN1> @STRDROWDOWN THEN @STRSTATERGY ELSE @STRSTATERGY1 END

--DELETE  FROM  #TBL_GRAPHDATA  WHERE STATERGY= CASE WHEN  @STRDROWDOWN1> @STRDROWDOWN THEN @STRSTATERGY ELSE @STRSTATERGY1 END

DELETE  FROM #TBLSTATERGYFINAL WHERE STATERGY= CASE WHEN  (@CARGEQ1/ (@STRDROWDOWN1*-1)) > (@CARGEQ/ (@STRDROWDOWN*-1)) THEN @STRSTATERGY ELSE @STRSTATERGY1 END

DELETE  FROM  #TBL_GRAPHDATA  WHERE STATERGY= CASE WHEN   (@CARGEQ1/ (@STRDROWDOWN1*-1)) > (@CARGEQ/ (@STRDROWDOWN*-1)) THEN @STRSTATERGY ELSE @STRSTATERGY1 END

--WHILE (@STRID <= @MAXID)
--BEGIN

--DECLARE @DROWDOWN AS FLOAT =0
--DECLARE @STATERGY as VARCHAR(50)

--SELECT @STRDROWDOWN=DROWDOWN, @STRSTATERGY =STATERGY FROM #TBLSTATERGYFINAL WHERE ID =@STRID

--SET @STRID=@STRID+1

--END

		SELECT ID,
		ROUND(EQDROWDOWN,1) AS EQDROWDOWN,
		ROUND(EQCAGR,1) AS EQCAGR,
		ROUND(EQSHARPRATIO,2) AS EQSHARPRATIO ,
		ROUND(EQSTDDEV,2) AS EQSTDDEV,
		ROUND(BSEDROWDOWN,1) AS BSEDROWDOWN,
		ROUND(BSECAGR,1) AS BSECAGR,
		ROUND(BSESHARPRATIO,2) AS BSESHARPRATIO,
		ROUND(BSESTDDEV,2) AS BSESTDDEV,
		STATERGY
		FROM #TBLSTATERGYFINAL

		SELECT ROUND(AFTERREBALTOTAL,0) AS 'PORTFOLIO',
               ROUND(BSE100,0) AS 'INDEX',
			   TRADE_DATE
               FROM #TBL_GRAPHDATA ORDER BY ID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_MAIN_BUILDPLAN
-- --------------------------------------------------

--USP_CUSTARQ_CUST_MAIN_BUILDPLAN 'VL001',''

CREATE PROC [dbo].[USP_CUSTARQ_CUST_MAIN_BUILDPLAN]
@CLIANT_CODE VARCHAR(50)='',
@STRATEGY VARCHAR(50)=''
AS BEGIN

CREATE TABLE #TBLSTATERGY
(
EQDROWDOWN FLOAT,
EQCAGR FLOAT,
EQCARMAX FLOAT,
EQAVG FLOAT,
EQSTDDEV FLOAT,
EQSQRT FLOAT,
EQSHARPRATIO FLOAT,
BSEDROWDOWN FLOAT,
BSECAGR FLOAT,
BSECARMAX FLOAT,
BSEAVG FLOAT,
BSESTDDEV FLOAT,
BSESQRT FLOAT,
BSESHARPRATIO FLOAT,
STATERGY VARCHAR(50)
)


CREATE TABLE #TBL_GRAPHDATA
(
ID INT,
TRADE_DATE DATE,
CUSTOM FLOAT,
ALTRA FLOAT,
EQUITY FLOAT,
DEBT FLOAT,
TOTALINVEST FLOAT,
EQUITYPER FLOAT,
DEBTPER FLOAT,
ISREBALANCE FLOAT,
EQUITYCHNG FLOAT,
DEBTCHNG FLOAT,
MID FLOAT,
ULTRASHORT FLOAT,
AFTERREBALTOTAL FLOAT,
AFTERREBALRATIO FLOAT,
PEEK FLOAT,
DIFF FLOAT,
DROWDOWN FLOAT,
DAILYCHANGE FLOAT,
ADJUSTED FLOAT,
BSE100 FLOAT,
BSEPEEK FLOAT,
BSEDIFF FLOAT,
BSEDROWDOWN FLOAT,
BSEDAILYCHANGE FLOAT,
BSEADJUSTED FLOAT,
STATERGY VARCHAR(50)
)


EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'ALTRA'

EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'INCOME'

SELECT ROW_NUMBER () OVER (ORDER BY (SELECT 1)) AS ID , EQDROWDOWN,
EQCAGR,
EQSHARPRATIO,
EQSTDDEV,
BSEDROWDOWN,
BSECAGR,
BSESHARPRATIO,
BSESTDDEV ,STATERGY
INTO #TBLSTATERGYFINAL
FROM #TBLSTATERGY

--DECLARE @STRID AS INT =2
--DECLARE @MAXID AS INT=0

--SELECT @MAXID =MAX(ID) FROM #TBLSTATERGYFINAL

DECLARE @STRDROWDOWN AS FLOAT =0
DECLARE @STRSTATERGY as VARCHAR(50)

DECLARE @STRDROWDOWN1 AS FLOAT =0
DECLARE @STRSTATERGY1 as VARCHAR(50)

SELECT @STRDROWDOWN=EQDROWDOWN, @STRSTATERGY =STATERGY FROM #TBLSTATERGYFINAL WHERE ID =1

SELECT @STRDROWDOWN1=EQDROWDOWN, @STRSTATERGY1 =STATERGY FROM #TBLSTATERGYFINAL WHERE ID =2



		SELECT ID,
		ROUND(EQDROWDOWN,2) AS EQDROWDOWN,
		ROUND(EQCAGR,2) AS EQCAGR,
		ROUND(EQSHARPRATIO,2) AS EQSHARPRATIO ,
		ROUND(EQSTDDEV,2) AS EQSTDDEV,
		ROUND(BSEDROWDOWN,2) AS BSEDROWDOWN,
		ROUND(BSECAGR,2) AS BSECAGR,
		ROUND(BSESHARPRATIO,2) AS BSESHARPRATIO,
		ROUND(BSESTDDEV,2) AS BSESTDDEV,
		STATERGY
		FROM #TBLSTATERGYFINAL
		WHERE STATERGY= @STRATEGY

		SELECT ROUND(AFTERREBALTOTAL,0) AS 'PORTFOLIO',
               ROUND(BSE100,0) AS 'INDEX',
			   TRADE_DATE
               FROM #TBL_GRAPHDATA
			   WHERE STATERGY=@STRATEGY
			    ORDER BY ID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_MAIN_TEST
-- --------------------------------------------------
--USP_CUSTARQ_CUST_MAIN_TEST 'VL001'

CREATE PROC [dbo].[USP_CUSTARQ_CUST_MAIN_TEST]
@CLIANT_CODE VARCHAR(50)=''
AS BEGIN

CREATE TABLE #TBLSTATERGY
(
EQDROWDOWN FLOAT,
EQCAGR FLOAT,
EQCARMAX FLOAT,
EQAVG FLOAT,
EQSTDDEV FLOAT,
EQSQRT FLOAT,
EQSHARPRATIO FLOAT,
BSEDROWDOWN FLOAT,
BSECAGR FLOAT,
BSECARMAX FLOAT,
BSEAVG FLOAT,
BSESTDDEV FLOAT,
BSESQRT FLOAT,
BSESHARPRATIO FLOAT,
STATERGY VARCHAR(50)
)


CREATE TABLE #TBL_GRAPHDATA
(
ID INT,
TRADE_DATE DATE,
CUSTOM FLOAT,
ALTRA FLOAT,
EQUITY FLOAT,
DEBT FLOAT,
TOTALINVEST FLOAT,
EQUITYPER FLOAT,
DEBTPER FLOAT,
ISREBALANCE FLOAT,
EQUITYCHNG FLOAT,
DEBTCHNG FLOAT,
MID FLOAT,
ULTRASHORT FLOAT,
AFTERREBALTOTAL FLOAT,
AFTERREBALRATIO FLOAT,
PEEK FLOAT,
DIFF FLOAT,
DROWDOWN FLOAT,
DAILYCHANGE FLOAT,
ADJUSTED FLOAT,
BSE100 FLOAT,
BSEPEEK FLOAT,
BSEDIFF FLOAT,
BSEDROWDOWN FLOAT,
BSEDAILYCHANGE FLOAT,
BSEADJUSTED FLOAT,
STATERGY VARCHAR(50)
)


EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'ALTRA'

EXEC USP_CUSTARQ_CAL_STRATEGY @CLIANT_CODE,'INCOME'

SELECT ROW_NUMBER () OVER (ORDER BY (SELECT 1)) AS ID , EQDROWDOWN,
EQCAGR,
EQSHARPRATIO,
EQSTDDEV,
BSEDROWDOWN,
BSECAGR,
BSESHARPRATIO,
BSESTDDEV ,STATERGY
INTO #TBLSTATERGYFINAL
FROM #TBLSTATERGY

--DECLARE @STRID AS INT =2
--DECLARE @MAXID AS INT=0

--SELECT @MAXID =MAX(ID) FROM #TBLSTATERGYFINAL

DECLARE @STRDROWDOWN AS FLOAT =0
DECLARE @STRSTATERGY as VARCHAR(50)
DECLARE @CARGEQ AS FLOAT =0.0

DECLARE @STRDROWDOWN1 AS FLOAT =0
DECLARE @STRSTATERGY1 as VARCHAR(50)
DECLARE @CARGEQ1 AS FLOAT =0.0

SELECT @STRDROWDOWN=EQDROWDOWN, @STRSTATERGY =STATERGY,@CARGEQ=EQCAGR FROM #TBLSTATERGYFINAL WHERE ID =1

SELECT @STRDROWDOWN1=EQDROWDOWN, @STRSTATERGY1 =STATERGY,@CARGEQ1=EQCAGR FROM #TBLSTATERGYFINAL WHERE ID =2

DELETE  FROM #TBLSTATERGYFINAL WHERE STATERGY= CASE WHEN  (@CARGEQ1/ (@STRDROWDOWN1*-1)) > (@CARGEQ/ (@STRDROWDOWN*-1)) THEN @STRSTATERGY ELSE @STRSTATERGY1 END

DELETE  FROM  #TBL_GRAPHDATA  WHERE STATERGY= CASE WHEN   (@CARGEQ1/ (@STRDROWDOWN1*-1)) > (@CARGEQ/ (@STRDROWDOWN*-1)) THEN @STRSTATERGY ELSE @STRSTATERGY1 END

--WHILE (@STRID <= @MAXID)
--BEGIN

--DECLARE @DROWDOWN AS FLOAT =0
--DECLARE @STATERGY as VARCHAR(50)

--SELECT @STRDROWDOWN=DROWDOWN, @STRSTATERGY =STATERGY FROM #TBLSTATERGYFINAL WHERE ID =@STRID

--SET @STRID=@STRID+1

--END

		SELECT ID,
		ROUND(EQDROWDOWN,2) AS EQDROWDOWN,
		ROUND(EQCAGR,2) AS EQCAGR,
		ROUND(EQSHARPRATIO,2) AS EQSHARPRATIO ,
		ROUND(EQSTDDEV,2) AS EQSTDDEV,
		ROUND(BSEDROWDOWN,2) AS BSEDROWDOWN,
		ROUND(BSECAGR,2) AS BSECAGR,
		ROUND(BSESHARPRATIO,2) AS BSESHARPRATIO,
		ROUND(BSESTDDEV,2) AS BSESTDDEV,
		STATERGY
		FROM #TBLSTATERGYFINAL

		SELECT *
               FROM #TBL_GRAPHDATA ORDER BY ID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_PUSHMF
-- --------------------------------------------------




CREATE PROC [dbo].[USP_CUSTARQ_CUST_PUSHMF]

 @Body AS VARCHAR(MAX) = ''

AS BEGIN

DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);

EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'post','http://196.1.115.136:3213/MFQuickSIP.svc/LumsumOrderInsertModification', 'false'

EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'text/plain'
EXEC sp_OAMethod @Object, 'send', null, @body

EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
SELECT @ResponseText as [RESPONSE]

EXEC sp_OADestroy @Object

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUST_UPDATEPGLIMIT
-- --------------------------------------------------
--[USP_CUSTARQ_CUST_UPDATEPGLIMIT] 'Y8049','45000','MF17270991130'  
  
CREATE PROC [dbo].[USP_CUSTARQ_CUST_UPDATEPGLIMIT]    
    
 @CLIENTCODE AS VARCHAR(MAX) = '',    
 @AMOUNT VARCHAR(200)='',  
 @MFTRansactionNo varchar(100)=''    
    
AS BEGIN    
    
    
DECLARE @Object AS INT;    
DECLARE @ResponseText AS VARCHAR(8000);    
DECLARE @Body AS VARCHAR(8000) = ''    
DECLARE @GROUPCODE AS VARCHAR(50)=''    
DECLARE @IPO MONEY=0,@MF MONEY=0,@TRADINGAMT MONEY=0  
   
IF(@MFTRansactionNo<>'')  
BEGIN  
   
select @IPO=IPOAmount,@MF=MFAmount,@TRADINGAMT=TradingAmount from TBL_CUSTARQ_UPDATELIMIT_LOG where MFTransactionNO=@MFTRansactionNo AND CLIENTCODE=@CLIENTCODE --AND Amount=@AMOUNT  
END  
  
    
SELECT @GROUPCODE=A.tag FROM (SELECT TOP 1   tag   FROM [mis].dbo.odinclientinfo WHERE pcode = @CLIENTCODE AND  servermapped <> '192.168.3.186')A    
    
    
    
SET @Body = '{"UserId" : "'+@CLIENTCODE+'","Amount":"'+@AMOUNT+'","ordertype":"MF","decIPOLimits":"'+CAST(@IPO AS VARCHAR)+'","GroupId" : "'+@GROUPCODE+'","decTradingLimits" : "'+CAST(@TRADINGAMT AS VARCHAR)+'","decMFLimits":"'+CAST(@MF AS VARCHAR)+'"}'  
  
print @Body    
    
EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;    
EXEC sp_OAMethod @Object, 'open', NULL, 'post','http://196.1.115.183:120/Service1.svc/UpdatePGLimits', 'false'    
    
EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'text/plain'    
EXEC sp_OAMethod @Object, 'send', null, @body    
    
EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT    
SELECT @ResponseText as [RESPONSE]    
    
EXEC sp_OADestroy @Object    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_CUSTOM_CALCULATE
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_CUSTOM_CALCULATE]       
      
@CLIENT_CODE AS VARCHAR(50)='',    
@FLAG as varchar(50)      
      
AS BEGIN      
      
DECLARE @STRINGVALUE AS VARCHAR(1000)=''      
DECLARE @RECID AS VARCHAR(50)=''      
DECLARE @SQL1 AS VARCHAR(200)='FUNDAMENTAL_WINNERS,MID_CAP_PORTFOLIO,MID_CAP_STOCKS,VALUE_STOCKS,QUALITY_STOCKS,STABLE_STOCK_PORTFOLIO,LARGE_CAP_STOCKS'      
DECLARE @FINALCOL AS VARCHAR(1000)=''      
DECLARE @SQL AS VARCHAR(MAX)=''      
CREATE TABLE #TEMPTABLE       
(STRINGVALUE VARCHAR(1000))      
      
SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@CLIENT_CODE      
      
      
      
--INSERT INTO #TEMPTABLE      
EXEC USP_CUSTARQ_GET_MOD @RECID,@STRINGVALUE OUT      


EXEC USP_CUSTARQ_GET_MOD @RECID,@STRINGVALUE OUT       
--SELECT @STRINGVALUE =STRINGVALUE FROM #TEMPTABLE      
      
      
SELECT @FINALCOL=@FINALCOL+'+'+ CASE WHEN  B.StringValue IS NULL THEN A.StringValue +'* 0' ELSE B.StringValue END  FROM (SELECT  StringValue  FROM DBO.fn_Split1 ( @SQL1,',')) A      
LEFT JOIN      
(SELECT * FROM DBO.fn_Split1 ( @STRINGVALUE,','))B      
ON B.StringValue LIKE '%'+A.StringValue +'%'      
      
SELECT @FINALCOL= SUBSTRING ( @FINALCOL,2,LEN(@FINALCOL))      
--SELECT * FROM [TBL_CUSTARQ_RAWNAV]      
      
      
      
SET @SQL='SELECT TRADE_DATE, ROUND( '+@FINALCOL+',0) AS CUSTOM,'+@FLAG+',BSE100 FROM TBL_CUSTARQ_RAWNAV'      

print @RECID      
print (@SQL)      
EXEC (@SQL)      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS
--EXEC USP_CUSTARQ_FILEGENERATION 'alwr1937','60000','50','50','aLTRA','ajyc',''
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)
		declare @MinimumDebtAmt int
		DECLARE @VAL AS INT=0
		DECLARE @STR AS VARCHAR(50)=''
		DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int
		
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		/*added by sandeep on 24 May 2018*/
		
		SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		
		
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			--SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			--else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2)
)/100))%5000)) end,0) as int))
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT) )
			
			END
		
		

		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
		
		
		set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)
 		set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))
 		set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end
 		set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)
 		set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)
 		set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end 
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		PRINT @TotalInvest
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@TotalInvest/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		PRINT @NewMinInvest-@TotalInvest
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))  
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [MIDDLEWARE].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.253].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.108].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [MIDDLEWARE].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	     where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'
	   --and v.[TYPE] =@CALCOPTION
	    
	   declare @cnt int,@cntRcd int
	   set @cnt=1
	   set @cntRcd=(select COUNT(1) from #MFARQ)
	   while(@cnt<=@cntRcd)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   set @cnt= @cnt+1
	   end
	   
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   (@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [MIDDLEWARE].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_14Nov2017
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS
--EXEC USP_CUSTARQ_FILEGENERATION_14Nov2017 'k75542','25000','100','0','aLTRA','ZADE',''
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_14Nov2017]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='VL001'
		--DECLARE @MINIMUMINVESTMENT MONEY='350000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =20.00
		--DECLARE @DEBTPERCENTAGE FLOAT=80.00
		 	
		
		--DECLARATION
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		 INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		ON V.arq_tbsescripcode = c.securitycode 
            
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.ARQ_TCATEGORY=X.MODEDESC
		WHERE ARQ_TSTATUS='A'
		
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@ARQINVESTMENT/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET AMOUNT=@DEBTINVESTMENT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		select BSEEQUITY=                                                          
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE( 
				Format                                                        
                ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
                ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
                ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
                ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
                --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
                ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
                from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
                on 1=1                                            
				where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
				and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		select NSEEQUITY=                                                          
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(
        REPLACE( 
				Format
				,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
                ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
                ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
                ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
                ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
                --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
                ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
                from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
                on 1=1                                            
				where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
				and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   @DEBTINVESTMENT as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_14Nov2017Bak
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS
--EXEC USP_CUSTARQ_FILEGENERATION 'D44336','250000','20','80','aLTRA'
Create PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_14Nov2017Bak]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='VL001'
		--DECLARE @MINIMUMINVESTMENT MONEY='350000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =20.00
		--DECLARE @DEBTPERCENTAGE FLOAT=80.00
		 	
		
		--DECLARATION
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		SELECT   PARTY_CODE=@PARTY_CODE,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		 INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		ON V.arq_tbsescripcode = c.securitycode 
            
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.ARQ_TCATEGORY=X.MODEDESC
		WHERE ARQ_TSTATUS='A'
		
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@ARQINVESTMENT/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET AMOUNT=@DEBTINVESTMENT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		select EQUITY=                                                          
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE( 
				Format                                                        
                ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
                ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
                ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
                ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
                --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
                ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
                from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
                on 1=1                                            
				where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
				and a.QUANTITY>0
				
				
		select  DEBT=                                                         
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE(                                                        
        REPLACE( 
				Format                                                        
                ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
                ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
                ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
                ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
                --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
                ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
                from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
                on 1=1  -- where 1=2                                         
				where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
				and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   @DEBTINVESTMENT as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_20nov2021
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS
--EXEC USP_CUSTARQ_FILEGENERATION 'alwr1937','60000','50','50','aLTRA','ajyc',''
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_20nov2021]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)
		declare @MinimumDebtAmt int
		DECLARE @VAL AS INT=0
		DECLARE @STR AS VARCHAR(50)=''
		DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int
		
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		/*added by sandeep on 24 May 2018*/
		
		SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		
		
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			--SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			--else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2)
)/100))%5000)) end,0) as int))
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT) )
			
			END
		
		

		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
		
		
		set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)
 		set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))
 		set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end
 		set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)
 		set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)
 		set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end 
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		PRINT @TotalInvest
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@TotalInvest/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		PRINT @NewMinInvest-@TotalInvest
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))  
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	     where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'
	   --and v.[TYPE] =@CALCOPTION
	    
	   declare @cnt int,@cntRcd int
	   set @cnt=1
	   set @cntRcd=(select COUNT(1) from #MFARQ)
	   while(@cnt<=@cntRcd)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   set @cnt= @cnt+1
	   end
	   
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   (@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_24MAY2018
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS
--EXEC USP_CUSTARQ_FILEGENERATION 'bknr2333','25000','100','0','aLTRA','SWSG',''
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_24MAY2018]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
		
		
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@ARQINVESTMENT/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET AMOUNT=@DEBTINVESTMENT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   round(@ARQINVESTMENT/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	   --and v.[TYPE] =@CALCOPTION
	    
	   declare @cnt int,@cntRcd int
	   set @cnt=1
	   set @cntRcd=(select COUNT(1) from #MFARQ)
	   while(@cnt<=@cntRcd)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   set @cnt= @cnt+1
	   end
	   
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   @DEBTINVESTMENT as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_ByNeeta
-- --------------------------------------------------

/*
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS

EXEC USP_CUSTARQ_FILEGENERATION 'alwr1937','60000','50','50','aLTRA','ajyc',''
exec USP_CUSTARQ_FILEGENERATION_ByNeeta 'P79943','25000','50','50','INCOME','CBHO','ARN-77404'

*/
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_ByNeeta]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)
		declare @MinimumDebtAmt int
		DECLARE @VAL AS INT=0
		DECLARE @STR AS VARCHAR(50)=''
		DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int
		
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		/*added by sandeep on 24 May 2018*/
		
		SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		
		
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			--SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			--else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )
			
			END
		
		

		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
		
		
		set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)
 		set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))
 		set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end
 		set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)
 		set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)
 		set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end 
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		PRINT @TotalInvest
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@CurrARQInvestment/@CNTSCRIPT
		--SET AMOUNT=@TotalInvest/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		PRINT @NewMinInvest-@TotalInvest
		
		UPDATE #ARQBUYDEBTSCRIPT
		--SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest
		SET AMOUNT=(@MINIMUMINVESTMENT * @DEBT)/100
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   a.Amount AS AmountUnit,
	   --round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	     where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'
	   --and v.[TYPE] =@CALCOPTION
	    
	   declare @cnt int,@cntRcd int
	   set @cnt=1
	   set @cntRcd=(select COUNT(1) from #MFARQ)
	   while(@cnt<=@cntRcd)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   set @cnt= @cnt+1
	   end
	   
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	    (@MINIMUMINVESTMENT * @DEBT)/100 AS AmountUnit,
	   --(@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_ByNeeta_1
-- --------------------------------------------------

/*
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS

EXEC USP_CUSTARQ_FILEGENERATION_ByNeeta 'alwr1937','60000','50','50','aLTRA','ajyc',''
exec USP_CUSTARQ_FILEGENERATION_ByNeeta_1 'ALWR2167','25000','50','50','INCOME','ajyc','ARN-111113'

A129643



exec [172.31.16.109].NXT.dbo.PowerUserValidate 'ALWR2167','INF769K01010','40000.00'
*/
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_ByNeeta_1]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)
		declare @MinimumDebtAmt int
		DECLARE @VAL AS INT=0
		DECLARE @STR AS VARCHAR(50)=''
		DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int
		
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		/*added by sandeep on 24 May 2018*/
		
		SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		
		
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			--SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			--else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )
			
			END
		
		

		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
		
		
		set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)
 		set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))
 		set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end
 		set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)
 		set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)
 		set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end 
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		PRINT @TotalInvest
		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@CurrARQInvestment/@CNTSCRIPT
		--SET AMOUNT=@TotalInvest/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		PRINT @NewMinInvest-@TotalInvest
		
		UPDATE #ARQBUYDEBTSCRIPT
		--SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest
		SET AMOUNT=(@MINIMUMINVESTMENT * @DEBT)/100
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   a.Amount AS AmountUnit,
	   --round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	     where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'
	   --and v.[TYPE] =@CALCOPTION
	    
	   --declare @cnt int,@cntRcd int
	   --set @cnt=1
	   --set @cntRcd=(select COUNT(1) from #MFARQ)
	   --while(@cnt<=@cntRcd)
	   --begin
	   --select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   --set @cnt= @cnt+1
	   --end
	   
	   --select * from #MFARQ
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	    (@MINIMUMINVESTMENT * @DEBT)/100 AS AmountUnit,
	   --(@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action 
	  
	   into #temp

	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())

select  
 RecID=ROW_NUMBER() over(order by X.isin),
isin,ClientCode,AmountUnit,'' as stat
into #final from (
select isin,ClientCode,AmountUnit from #MFARQ
union
select isin,ClientCode,AmountUnit from #temp
) X




 declare @cnt int =null ,@cntRcd int =null,
         @isin varchar(12) =null,
       @amount numeric(17,2) =null
	   --@stat int
	   set @cnt=1
	   set @cntRcd= (select COUNT(1) from #final)
	   while(@cnt<=@cntRcd)
	   begin
	   --select  Action from #MFARQ where RecID=@cnt
	  declare @stat int
	   select @isin=isin,@amount=AmountUnit from #final where RecID=@cnt
	   
	  --select @isin ,@amount,@cnt,@stat
exec [172.31.16.109].NXT.dbo.PowerUserValidate_1 @party_code,@isin,@amount,@stat output

--select @stat
	 update   #final set stat= @stat where RecID=@cnt
	   --declare @stat int
	   --exec [172.31.16.109].NXT.dbo.PowerUserValidate_1 'ALWR2167','INF109K01RT3','5000.00',@stat output 
	   --select * from #final	   
	   set @cnt= @cnt+1
	   end

if not exists (select 1 from #final where stat=1)
begin
       declare @cnt1 int,@cntRcd1 int
	   set @cnt1=1
	   set @cntRcd1=(select COUNT(1) from #MFARQ)
	   while(@cnt1<=@cntRcd1)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt1
	   set @cnt1= @cnt1+1
	   end

select * from #temp
end

drop table #temp
drop table #MFARQ
drop table #final


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_ByNeeta_NY
-- --------------------------------------------------

/*
--CREATED BY :- SANDEEP RAI
--CREATED ON :- 17 AUG 2017
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS

EXEC USP_CUSTARQ_FILEGENERATION_ByNeeta 'alwr1937','60000','50','50','aLTRA','ajyc',''
exec USP_CUSTARQ_FILEGENERATION_ByNeeta 'ALWR2154','25000','50','50','INCOME','ajyc','ARN-111113'

exec [172.31.16.109].NXT.dbo.PowerUserValidate 'ALWR2154','INF769K01010','50000.00'
*/
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_ByNeeta_NY]
@PARTY_CODE VARCHAR(50)='',
@MINIMUMINVESTMENT MONEY='',
@ARQPERCENTAGE INT='',
@DEBTPERCENTAGE INT='',
@CALCOPTION VARCHAR(50),
@USERNAME varchar(50),
@ARNCODE VARCHAR(500)=''
AS
BEGIN
		--DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'
		--DECLARE @MINIMUMINVESTMENT MONEY='25000.00'
		--DECLARE @ARQPERCENTAGE	FLOAT =100.00
		--DECLARE @DEBTPERCENTAGE FLOAT=0.00
		--declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''
		 	
		
		--DECLARATION
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)
		declare @MinimumDebtAmt int
		DECLARE @VAL AS INT=0
		DECLARE @STR AS VARCHAR(50)=''
		DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int
		
		DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY
		
		SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))
		SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))
		--SELECT @ARQINVESTMENT,@DEBTPERCENTAGE	
		
		
							
		DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT
		
select 1		
		SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE
		SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE
		SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE
		
		
		--SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		-- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock) 
		--ON V.arq_tbsescripcode = c.securitycode 
            
		--INNER JOIN 
		--(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		--ON V.ARQ_TCATEGORY=X.MODEDESC
		--WHERE ARQ_TSTATUS='A'
		
		/*added by sandeep on 24 May 2018*/
		
		SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)
select 2	
		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		
select 3			
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			--SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			--else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )
			
			END
		
		

		
		
		
		/*For MF ARQ*/
		SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		INNER JOIN 
		(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.type=X.MODEDESC
		
	select 4		
		
		set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)
 		set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))
 		set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end
 		set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)
 		set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)
 		set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end 
		
		SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT
		
		PRINT @TotalInvest
select 5		
		UPDATE #ARQBUYSCRIPT
		SET AMOUNT=@CurrARQInvestment/@CNTSCRIPT
		--SET AMOUNT=@TotalInvest/@CNTSCRIPT
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--SELECT * FROM #ARQBUYSCRIPT  	
		
		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
		SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		
select 6		--SELECT * FROM #ARQBUYDEBTSCRIPT 
		PRINT @NewMinInvest-@TotalInvest
		
		UPDATE #ARQBUYDEBTSCRIPT
		--SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest
		SET AMOUNT=(@MINIMUMINVESTMENT * @DEBT)/100
		WHERE PARTY_CODE=@PARTY_CODE
		
		UPDATE #ARQBUYDEBTSCRIPT
		SET QUANTITY=AMOUNT/Price
		WHERE PARTY_CODE=@PARTY_CODE
		
		
		--select BSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
				
		--select  DEBT=                                                         
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE( 
		--		Format                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1  -- where 1=2                                         
		--		where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0

		--select NSEEQUITY=                                                          
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(                                                        
  --      REPLACE(
  --      REPLACE( 
		--		Format
		--		,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                        
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                        
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                         
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                        
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                     
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                  
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST            
  --              on 1=1                                            
		--		where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                   
		--		and a.QUANTITY>0
				
    
    
    	  			
				
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)
	   select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)
       set @ID=@ID+1
       set @BuySell='FRESH'
       
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
       
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [196.1.115.132].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)
       
       
       
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)
	   
       set @DPIP=(SELECT top 1 client_code from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')
       
       --set @USERNAME='System'
	   
	   /*logic for MF ARQ Stock*/
	    select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	    RecID=ROW_NUMBER() over(order by v.isin)  ,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	   a.Amount AS AmountUnit,
	   --round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action
	   into #MFARQ 
	   from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
		inner join #ARQBUYSCRIPT a
		on v.isin=a.isin
	   --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)
	     where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'
	   --and v.[TYPE] =@CALCOPTION
	    
	   declare @cnt int,@cntRcd int
	   set @cnt=1
	   set @cntRcd=(select COUNT(1) from #MFARQ)
	   while(@cnt<=@cntRcd)
	   begin
	   select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt
	   set @cnt= @cnt+1
	   end
	   
	   
	   /*logic end*/
	   
	   
	   
	   
	   select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,
	   amc_code as AmcCode,
	   scheme_code as SchemeCode,
	   @party_code as ClientCode,
	   ''+v.isin+'' as Isin,
	   'P' as PurchaseRedeem,
	    (@MINIMUMINVESTMENT * @DEBT)/100 AS AmountUnit,
	   --(@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,
	   case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,
	   'C' as DematPhysical,
	   case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,
	   @DPIP as DpId,
	   'Y' as KycFlag,
	   'Y' as MinRedemptionFlag,
	   convert(varchar(5),purchase_cutoff_time) as CutOffTime,
	   --'17:30' as CutOffTime,
	   'N' as AllUnits,
	   ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,
	   'CUSTARQ' as UserType,
	   'CUSTARQ' as LumSumRemarks,
	   ''+@USERNAME+'' as InsertedBy,
	   'insert' as Action from 
	   [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	   left join [196.1.115.239].commonmaster.dbo.vw_etl_mfschememaster e with (nolock) 
	   on v.isin=e.isin 
	   where minimum_pur_amt=5000.0000
	   and v.[TYPE] =@CALCOPTION
	   
	   --and e.purchase_allowed='Y' 
	   
	   
	   
	   
	   
	 --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';
	 --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;
	 --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'         
	 --  from [172.31.16.75].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v
	 --  where v.[TYPE] ='Debt-Income'

		--insert into TBL_MFDEBTAPILOG
		--values
		--('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_Poweruser
-- --------------------------------------------------
  
/*  
--CREATED BY :- SANDEEP RAI  
--CREATED ON :- 17 AUG 2017  
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS  
  
EXEC USP_CUSTARQ_FILEGENERATION_ByNeeta 'alwr1937','60000','50','50','aLTRA','ajyc',''  
exec USP_CUSTARQ_FILEGENERATION_ByNeeta_1 'ALWR2167','25000','50','50','INCOME','ajyc','ARN-111113'  
  
A129643  
  
  
  
exec [172.31.16.109].NXT.dbo.PowerUserValidate_Arq 'ALWR2167','INF769K01010','40000.00'  
*/  
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_Poweruser]  
@PARTY_CODE VARCHAR(50)='',  
@MINIMUMINVESTMENT MONEY='',  
@ARQPERCENTAGE INT='',  
@DEBTPERCENTAGE INT='',  
@CALCOPTION VARCHAR(50),  
@USERNAME varchar(50),  
@ARNCODE VARCHAR(500)=''  
AS  
BEGIN  
  --DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'  
  --DECLARE @MINIMUMINVESTMENT MONEY='25000.00'  
  --DECLARE @ARQPERCENTAGE FLOAT =100.00  
  --DECLARE @DEBTPERCENTAGE FLOAT=0.00  
  --declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''  
      
    
  --DECLARATION  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  declare @MinimumDebtAmt int  
  DECLARE @VAL AS INT=0  
  DECLARE @STR AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
    
  DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY  
    
  SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))  
  SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))  
  --SELECT @ARQINVESTMENT,@DEBTPERCENTAGE   
    
    
         
  DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT  
    
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE  
  SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE  
  SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE  
    
    
  --SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V  
  -- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock)   
  --ON V.arq_tbsescripcode = c.securitycode   
              
  --INNER JOIN   
  --(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  --ON V.ARQ_TCATEGORY=X.MODEDESC  
  --WHERE ARQ_TSTATUS='A'  
    
  /*added by sandeep on 24 May 2018*/  
    
  SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
    
  
    
    
    
  /*For MF ARQ*/  
  SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
    
  set @CurrARQInvestment=@MINIMUMINVESTMENT*(CAST (@ARQR AS DECIMAL(18,2))/100)  
   set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
   set @ModVal=case when (cast(@PerScheme as int)%500)=0 then @PerScheme else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
   set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
   set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
   set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
    
  SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT  
    
  PRINT @TotalInvest  
    
  UPDATE #ARQBUYSCRIPT  
  SET AMOUNT=@CurrARQInvestment/@CNTSCRIPT  
  --SET AMOUNT=@TotalInvest/@CNTSCRIPT  
  WHERE PARTY_CODE=@PARTY_CODE  
    
  UPDATE #ARQBUYSCRIPT  
  SET QUANTITY=AMOUNT/Price  
  WHERE PARTY_CODE=@PARTY_CODE  
    
    
  --SELECT * FROM #ARQBUYSCRIPT     
    
  select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end  
    
  SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  WHERE [TYPE] =@CALCOPTION  
    
  --SELECT * FROM #ARQBUYDEBTSCRIPT   
  PRINT @NewMinInvest-@TotalInvest  
    
  UPDATE #ARQBUYDEBTSCRIPT  
  --SET AMOUNT=@MINIMUMINVESTMENT-@TotalInvest  
  SET AMOUNT=(@MINIMUMINVESTMENT * @DEBT)/100  
  WHERE PARTY_CODE=@PARTY_CODE  
    
  UPDATE #ARQBUYDEBTSCRIPT  
  SET QUANTITY=AMOUNT/Price  
  WHERE PARTY_CODE=@PARTY_CODE  
    
    
  --select BSEEQUITY=                                                            
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                 
  --      REPLACE(                                                          
  --      REPLACE(   
  --  Format                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1                                              
  --  where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
      
      
  --select  DEBT=                                                           
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(   
  --  Format                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1  -- where 1=2                                           
  --  where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
  
  --select NSEEQUITY=                                                            
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(  
  --      REPLACE(   
  --  Format  
  --  ,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1                                              
  --  where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
      
      
      
            
      
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)  
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)  
    select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)  
       set @ID=@ID+1  
       set @BuySell='FRESH'  
         
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
    where minimum_pur_amt=5000.0000  
    and v.[TYPE] =@CALCOPTION  
         
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [INTRANET].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)  
         
         
         
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)  
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)  
      
       set @DPIP=(SELECT top 1 client_code from [AGMUBODPL3].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')  
         
       --set @USERNAME='System'  
      
    /*logic for MF ARQ Stock*/  
     select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,  
     RecID=ROW_NUMBER() over(order by v.isin)  ,  
    amc_code as AmcCode,  
    scheme_code as SchemeCode,  
    @party_code as ClientCode,  
    ''+v.isin+'' as Isin,  
    'P' as PurchaseRedeem,  
    a.Amount AS AmountUnit,  
    --round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,  
    case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,  
    'C' as DematPhysical,  
    case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,  
    @DPIP as DpId,  
    'Y' as KycFlag,  
    'Y' as MinRedemptionFlag,  
    convert(varchar(5),purchase_cutoff_time) as CutOffTime,  
    --'17:30' as CutOffTime,  
    'N' as AllUnits,  
    ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,  
    'CUSTARQ' as UserType,  
    'CUSTARQ' as LumSumRemarks,  
    ''+@USERNAME+'' as InsertedBy,  
    'insert' as Action  
    into #MFARQ   
    from   
    [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
  inner join #ARQBUYSCRIPT a  
  on v.isin=a.isin  
    --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)  
      where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'  
    --and v.[TYPE] =@CALCOPTION  
       
    --declare @cnt int,@cntRcd int  
    --set @cnt=1  
    --set @cntRcd=(select COUNT(1) from #MFARQ)  
    --while(@cnt<=@cntRcd)  
    --begin  
    --select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt  
    --set @cnt= @cnt+1  
    --end  
      
    --select * from #MFARQ  
      
    /*logic end*/  
      
      
      
      
    select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,  
    amc_code as AmcCode,  
    scheme_code as SchemeCode,  
    @party_code as ClientCode,  
    ''+v.isin+'' as Isin,  
    'P' as PurchaseRedeem,  
     (@MINIMUMINVESTMENT * @DEBT)/100 AS AmountUnit,  
    --(@MINIMUMINVESTMENT-@TotalInvest) as AmountUnit,  
    case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,  
    'C' as DematPhysical,  
    case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,  
    @DPIP as DpId,  
    'Y' as KycFlag,  
    'Y' as MinRedemptionFlag,  
    convert(varchar(5),purchase_cutoff_time) as CutOffTime,  
    --'17:30' as CutOffTime,  
    'N' as AllUnits,  
    ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,  
    'CUSTARQ' as UserType,  
    'CUSTARQ' as LumSumRemarks,  
    ''+@USERNAME+'' as InsertedBy,  
    'insert' as Action   
     
    into #temp  
  
    from   
    [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
    where minimum_pur_amt=5000.0000  
    and v.[TYPE] =@CALCOPTION  
      
    --and e.purchase_allowed='Y'   
      
      
      
      
      
  --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';  
  --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;  
  --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'           
  --  from [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
  --  where v.[TYPE] ='Debt-Income'  
  
  --insert into TBL_MFDEBTAPILOG  
  --values  
  --('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())  
  
select    
 RecID=ROW_NUMBER() over(order by X.isin),  
isin,ClientCode,AmountUnit,'' as stat  
into #final from (  
select isin,ClientCode,AmountUnit from #MFARQ  
union  
select isin,ClientCode,AmountUnit from #temp  
) X  
  
  
  
  
 declare @cnt int =null ,@cntRcd int =null,  
         @isin varchar(12) =null,  
       @amount numeric(17,2) =null  
    --@stat int  
    set @cnt=1  
    set @cntRcd= (select COUNT(1) from #final)  
    while(@cnt<=@cntRcd)  
    begin  
    --select  Action from #MFARQ where RecID=@cnt  
   declare @stat int  
    select @isin=isin,@amount=AmountUnit from #final where RecID=@cnt  
      
   --select @isin ,@amount,@cnt,@stat  
exec [172.31.16.109].NXT.dbo.PowerUserValidate_Arq @party_code,@isin,@amount,@stat output  
  
--select @stat  
  update   #final set stat= @stat where RecID=@cnt  
    --declare @stat int  
    --exec [172.31.16.109].NXT.dbo.PowerUserValidate_Arq 'ALWR2167','INF109K01RT3','5000.00',@stat output   
    --select * from #final      
    set @cnt= @cnt+1  
    end  
  
if not exists (select 1 from #final where stat=1)  
begin  
       declare @cnt1 int,@cntRcd1 int  
    set @cnt1=1  
    set @cntRcd1=(select COUNT(1) from #MFARQ)  
    while(@cnt1<=@cntRcd1)  
    begin  
    select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt1  
    set @cnt1= @cnt1+1  
    end  
  
select * from #temp  
end  
  
drop table #temp  
drop table #MFARQ  
drop table #final  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_FILEGENERATION_Test
-- --------------------------------------------------
--CREATED BY :- SANDEEP RAI  
--CREATED ON :- 17 AUG 2017  
--RESON      :- TO GET THE CLIENT BUY STOCK DETAILS  
--EXEC USP_CUSTARQ_FILEGENERATION_Test 'bknr2333','41300','80','20','aLTRA','KKGR',''  
CREATE PROCEDURE [dbo].[USP_CUSTARQ_FILEGENERATION_Test]  
@PARTY_CODE VARCHAR(50)='',  
@MINIMUMINVESTMENT MONEY='',  
@ARQPERCENTAGE INT='',  
@DEBTPERCENTAGE INT='',  
@CALCOPTION VARCHAR(50),  
@USERNAME varchar(50),  
@ARNCODE VARCHAR(500)=''  
AS  
BEGIN  
  --DECLARE @PARTY_CODE VARCHAR(50)='bknr2333'  
  --DECLARE @MINIMUMINVESTMENT MONEY='25000.00'  
  --DECLARE @ARQPERCENTAGE FLOAT =100.00  
  --DECLARE @DEBTPERCENTAGE FLOAT=0.00  
  --declare @CALCOPTION VARCHAR(50),@USERNAME varchar(50),@ARNCODE VARCHAR(500)=''  
      
    
  --DECLARATION  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  declare @MinimumDebtAmt int  
  DECLARE @VAL AS INT=0  
  DECLARE @STR AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
    
  DECLARE @ARQINVESTMENT MONEY,@DEBTINVESTMENT MONEY  
    
  SET @ARQINVESTMENT =(@MINIMUMINVESTMENT*(@ARQPERCENTAGE/100.00))  
  SET @DEBTINVESTMENT =(@MINIMUMINVESTMENT*(@DEBTPERCENTAGE/100.00))  
  --SELECT @ARQINVESTMENT,@DEBTPERCENTAGE   
    
    
         
  DECLARE @RECID VARCHAR(50)='',@GROUPID VARCHAR(50)='',@CNTSCRIPT INT  
    
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@PARTY_CODE  
  SELECT @STR=RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE  
  SELECT @GROUPID=TAG FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE PCODE=@PARTY_CODE  
    
    
  --SELECT   PARTY_CODE=@PARTY_CODE,BSESymbol=ARQ_tBSEScripCode,ARQ_tScripName=ARQ_tNSESymbol,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),
  -- Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),ModeID=x.CUSTOMMODEID  INTO #ARQBUYSCRIPT FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V  
  -- INNER JOIN [172.31.16.85].ODINFEED.dbo.feed_live_eq_bse c WITH (nolock)   
  --ON V.arq_tbsescripcode = c.securitycode   
              
  --INNER JOIN   
  --(SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  --ON V.ARQ_TCATEGORY=X.MODEDESC  
  --WHERE ARQ_TSTATUS='A'  
    
  /*added by sandeep on 24 May 2018*/  
    
  SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 
  THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
    
  
    
    
    
  /*For MF ARQ*/  
  SELECT  PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  
  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
    
  set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
   set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
   set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
   set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
   set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
   set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
    
  SELECT @CNTSCRIPT=COUNT(*) FROM #ARQBUYSCRIPT  
    
  PRINT @TotalInvest  
    
  UPDATE #ARQBUYSCRIPT  
  SET AMOUNT=@TotalInvest/@CNTSCRIPT  
  WHERE PARTY_CODE=@PARTY_CODE  
    
  UPDATE #ARQBUYSCRIPT  
  SET QUANTITY=AMOUNT/Price  
  WHERE PARTY_CODE=@PARTY_CODE  
    
    
  --SELECT * FROM #ARQBUYSCRIPT     
    
  select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end  
    
  SELECT top 1 PARTY_CODE=@PARTY_CODE,TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYDEBTSCRIPT 
  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  WHERE [TYPE] =@CALCOPTION  
    
  --SELECT * FROM #ARQBUYDEBTSCRIPT   
  PRINT @NewMinInvest-@TotalInvest  
    
  UPDATE #ARQBUYDEBTSCRIPT  
  SET AMOUNT=@NewMinInvest-@TotalInvest  
  WHERE PARTY_CODE=@PARTY_CODE  
    
  UPDATE #ARQBUYDEBTSCRIPT  
  SET QUANTITY=AMOUNT/Price  
  WHERE PARTY_CODE=@PARTY_CODE  
    
    
  --select BSEEQUITY=                                                            
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(   
  --  Format                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(BSESymbol)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1                                              
  --  where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
      
      
  --select  DEBT=                                                           
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(   
  --  Format                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(SCHEME_NAME)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim('DEBT')),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYDEBTSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1  -- where 1=2                                           
  --  where FileType='BUYADDNEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
  
  --select NSEEQUITY=                                                            
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(                                                          
  --      REPLACE(  
  --      REPLACE(   
  --  Format  
  --  ,'@ReferenceNo',ISNULL(ltrim(rtrim(ROW_NUMBER() over(order by  ARQ_tScripName))),''))                                                          
  --              ,'@QTY',isnull(ltrim(rtrim(QUANTITY)),''))                                                          
  --              ,'@SCRIP_CD',isnull(ltrim(rtrim(ARQ_tScripName)),''))                                           
  --              ,'@PARTY_CODE',isnull(ltrim(rtrim(upper(@Party_code))),''))                                                          
  --              ,'@BUCKET',isnull(ltrim(rtrim(ModeID)),''))                                       
  --              --,'@managerid',isnull(ltrim(rtrim(@ManagerIp)),''))                                    
  --              ,'@GROUPID',isnull(ltrim(rtrim(@GROUPID)),''))  
  --              from    #ARQBUYSCRIPT a left outer join TBL_CUSTARQ_FILEGENERATION_MST              
  --              on 1=1                                              
  --  where FileType='BUYNSENEW' AND a.PARTY_CODE=@Party_code                                     
  --  and a.QUANTITY>0  
      
      
      
            
      
       declare @ID int,@BuySell varchar(50),@FolioNo varchar(50)=''--,@USERNAME varchar(50)  
       ,@RequestData varchar(8000),@ARN varchar(50),@SBTAG varchar(50),@DPIP varchar(50),@amcCode varchar(50),@schemeCode varchar(50)  
    select @ID=isnull(MAX(recid),0) from TBL_MFDEBTAPILOG with(nolock)  
       set @ID=@ID+1  
       set @BuySell='FRESH'  
         
       select top 1 @schemeCode=e.scheme_code,@amcCode=e.amc_code from [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
    where minimum_pur_amt=5000.0000  
    and v.[TYPE] =@CALCOPTION  
         
       set @FolioNo=(select top 1 isnull(sFolioNo,0) from [INTRANET].MutualFund.dbo.TBLCLIENTFOLIODETAILS with(nolock) where sClientCode=@PARTY_CODE and sAMCCode=@amcCode and sSchemeCode=@schemeCode order by sInsertedOn desc)  
         
         
         
       set @SBTAG=(select top 1 sub_broker from risk.dbo.client_details with(nolock) where party_code=@PARTY_CODE)  
       --set @ARN=(SELECT ISNULL([ARN No],'')  FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@SBTAG)  
      
       set @DPIP=(SELECT top 1 client_code from [AGMUBODPL3].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@PARTY_CODE and left(client_Code,8)='12033200')  
         
       --set @USERNAME='System'  
      
    /*logic for MF ARQ Stock*/  
     select ltrim(rtrim('CUSTARQ'+convert(varchar,ROW_NUMBER() over(order by v.isin))+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,  
     RecID=ROW_NUMBER() over(order by v.isin)  ,  
    amc_code as AmcCode,  
    scheme_code as SchemeCode,  
    @party_code as ClientCode,  
    ''+v.isin+'' as Isin,  
    'P' as PurchaseRedeem,  
    round(@TotalInvest/@CNTSCRIPT,0) as AmountUnit,  
    case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,  
    'C' as DematPhysical,  
    case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,  
    @DPIP as DpId,  
    'Y' as KycFlag,  
    'Y' as MinRedemptionFlag,  
    convert(varchar(5),purchase_cutoff_time) as CutOffTime,  
    --'17:30' as CutOffTime,  
    'N' as AllUnits,  
    ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,  
    'CUSTARQ' as UserType,  
    'CUSTARQ' as LumSumRemarks,  
    ''+@USERNAME+'' as InsertedBy,  
    'insert' as Action  
    into #MFARQ   
    from   
    [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
  inner join #ARQBUYSCRIPT a  
  on v.isin=a.isin  
    --where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000)  
      where (minimum_pur_amt=5000.0000 or minimum_pur_amt=1000.0000 or minimum_pur_amt=500.0000) and purchase_allowed='Y'  
    --and v.[TYPE] =@CALCOPTION  
       
    declare @cnt int,@cntRcd int  
    set @cnt=1  
    set @cntRcd=(select COUNT(1) from #MFARQ)  
    while(@cnt<=@cntRcd)  
    begin  
    select  InternalRefNo,AmcCode,SchemeCode,ClientCode,Isin,PurchaseRedeem,AmountUnit,BuySell,DematPhysical,FolioNo,DpId,KycFlag,MinRedemptionFlag,CutOffTime,AllUnits,SbARNCode,UserType,LumSumRemarks,InsertedBy,Action from #MFARQ where RecID=@cnt  
    set @cnt= @cnt+1  
    end  
      
      
    /*logic end*/  
      
      
      
      
    select ltrim(rtrim('CUSTARQ'+dbo.UniqueRefNum( rand(), rand(), rand())+'')) as InternalRefNo,  
    amc_code as AmcCode,  
    scheme_code as SchemeCode,  
    @party_code as ClientCode,  
    ''+v.isin+'' as Isin,  
    'P' as PurchaseRedeem,  
    (@NewMinInvest-@TotalInvest) as AmountUnit,  
    case when isnull(@FolioNo,'')<>'' then 'ADDITIONAL' else 'FRESH' end as BuySell,  
    'C' as DematPhysical,  
    case when @FolioNo<>'' then @FolioNo else '' end as FolioNo,  
    @DPIP as DpId,  
    'Y' as KycFlag,  
    'Y' as MinRedemptionFlag,  
    convert(varchar(5),purchase_cutoff_time) as CutOffTime,  
    --'17:30' as CutOffTime,  
    'N' as AllUnits,  
    ''+CASE WHEN (@ARNCODE='')THEN 'ARN-77404' ELSE @ARNCODE END +'' as SbARNCode,  
    'CUSTARQ' as UserType,  
    'CUSTARQ' as LumSumRemarks,  
    ''+@USERNAME+'' as InsertedBy,  
   'insert' as Action from   
    [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
    left join MIDDLEWARE.commonmaster.dbo.vw_etl_mfschememaster e with (nolock)   
    on v.isin=e.isin   
    where minimum_pur_amt=5000.0000  
    and v.[TYPE] =@CALCOPTION  
      
    --and e.purchase_allowed='Y'   
      
      
      
      
      
  --  select  'InternalRefNo,CUSTARQ'+cast(@ID as varchar)+';AmcCode,MIRAEASSET;SchemeCode,MATSRG-GR;ClientCode,'+'R784511'+';Isin,'+v.isin+';  
  --  PurchaseRedeem,P;AmountUnit,5000;BuySell,'+@BuySell+';DematPhysical,P;FolioNo,'+@FolioNo+';DpId,;KycFlag,Y;MinRedemptionFlag,Y;CutOffTime,14:30;  
  --  AllUnits,N;SbARNCode,ARN3456;UserType,AWA;LumSumRemarks,Test;InsertedBy,'+@USERNAME+';Action,insert'           
  --  from [ABVSAWUARQ1].angel_wms.dbo.TBL_ARQ_DEBT_MFSTOCK_V3 v  
  --  where v.[TYPE] ='Debt-Income'  
  
  --insert into TBL_MFDEBTAPILOG  
  --values  
  --('CUSTARQ'+cast(@ID as varchar)+'',@PARTY_CODE,@RequestData,'',@USERNAME,GETDATE())  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GET_MOD
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GET_MOD]  
@RECID VARCHAR(50)='',  
@COLS VARCHAR(MAX)='' OUT  
  
AS BEGIN  
  
  
SELECT *,ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) AS ID INTO #TEMP FROM DBO.fn_Split1(@RECID,',')  
  
DECLARE @COL AS VARCHAR(500)=''  
  
DECLARE @TOTAL AS DECIMAL(38,8)=0  
  
  
SELECT @TOTAL= SUM(INVEST_RS) FROM (SELECT StringValue AS RECID  FROM DBO.fn_Split1(@RECID,',')) A  
JOIN (SELECT  INVEST_RS,RECID  FROM TBL_CUSTARQ_MODEMASTER )B  
ON A.RECID =B.RECID   
  
  
SELECT @COL=@COL+','+ CASE WHEN STRINGVALUE =1 THEN 'LARGE_CAP_STOCKS'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =2 THEN 'MID_CAP_PORTFOLIO'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =3 THEN 'MID_CAP_STOCKS'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =4 THEN 'QUALITY_STOCKS'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =5 THEN 'VALUE_STOCKS'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =6 THEN 'FUNDAMENTAL_WINNERS'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       WHEN STRINGVALUE =7 THEN 'STABLE_STOCK_PORTFOLIO'  +'*'+  CAST (  (  ( CAST( 10000 AS DECIMAL)/  CAST( @TOTAL AS DECIMAL))*100)/100 AS VARCHAR(100))  
       END  
  
        
         
  
     FROM #TEMP  
  
  
  
  
DROP TABLE #TEMP  
  
  
SET @COLS=SUBSTRING (@COL,2,LEN(@COL))   
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA]  
@PROCESS AS VARCHAR(100)='',  
@FILTER1 AS VARCHAR(5000)='',  
@FILTER2 AS VARCHAR(50)='',  
@FILTER3 AS VARCHAR(50)='',  
@FILTER4 AS VARCHAR(50)='',  
@FILTER5 AS VARCHAR(50)='',  
@FILTER6 AS VARCHAR(50)='',  
@FILTER7 AS VARCHAR(50)='',  
@FILTER8 AS VARCHAR(50)='',  
@FILTER9 AS VARCHAR(50)='',  
@USERNAME AS VARCHAR(200)='',  
@ACCESS_TO AS VARCHAR(100)='',  
@ACCESS_CODE AS VARCHAR(100)='',  
@DIVICEID AS VARCHAR(25)=''  
  
  
AS BEGIN   
    
  declare @MinimumDebtAmt int  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  DECLARE @RECID AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
     
  IF (@PROCESS='VALIDATE CLIENT')  
  BEGIN  
  
  --WAITFOR DELAY '00:00:08';  
  SELECT PARTY_CODE,LONG_NAME FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE  
   -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE  
  
  DECLARE @STR AS VARCHAR(50)=''  
  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  --SELECT A.RECID AS ID, MODEDESC--,NO_STOCK  
  SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK  
  ,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  --ORDER BY NO_STOCK  
  
  
  END  
  
  
  IF (@PROCESS='UPDATE CLIENT MODE')  
  BEGIN  
  
  DECLARE @CNT AS INT=0  
  DECLARE @VAL AS INT=0  
  DECLARE @AMT_TO_INVET FLOAT=0  
  
        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
  SET RECID=@FILTER2,  
  ISDIRECT=1,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENT_CODE =@FILTER1  
  END  
  ELSE  
  BEGIN  
  ----INSERT   
  INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID  
  
    
  
  END  
  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1  
  
    
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
   ----GET MINIMUM INVETMENT  
  
  SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
    
  
        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
  /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
  
  select @NewMinInvest AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'   
  
  DECLARE @MODEDESC AS VARCHAR(500)=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='RECALCULATE')  
  BEGIN  
  
   DECLARE @ISDIRECT AS INT =1  
  
   SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
   SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  
  DECLARE @PREARQ AS FLOAT  
  DECLARE @PREFIXEDINCOME AS FLOAT  
  
  SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT  
  SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  
  WHERE CLIENTCODE= @FILTER1  
  END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID  
  END  
  
  IF(@ISDIRECT=0)  
  BEGIN  
  
   IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )  
   BEGIN  
        EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
   END  
   ELSE  
   BEGIN  
  
    
  
   UPDATE TBL_CUSTARQ_CLIENT_MODE  
   SET ISDIRECT=1  
   WHERE CLIENT_CODE =@FILTER1  
  
   EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  
  
   END  
  
    
  END  
  ELSE  
  BEGIN  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  END  
    
  
    
  
  
   ----GET MINIMUM INVETMENT  
     
  
   SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
   JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
   ON A.RECID=B.ID   
     
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1   
     
   SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT2  
   FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
   inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
   on v.isin=n.isin    
   INNER JOIN   
   (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
   ON V.type=X.MODEDESC  
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST')  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST')  
     
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
  
           
         /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@FILTER2 AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT2))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT2)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@FILTER2 AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
           
            select @NewMinInvest AS 'MINIMUMINVEST'  
   SET @MODEDESC=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='GETRISKPROFILE')  
  BEGIN  
  
  DECLARE @PROFILE AS VARCHAR(100)  
  
  SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST  
  
  
    
  SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1  
  
  SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN  
  
  ,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A  
  JOIN   
  
  (SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B  
  ON A.SCORE=B.SCORE AND A.QN =B.QN  
  
  
  END  
  
  
  
  IF (@PROCESS='GETRECOMENTAION')  
  BEGIN  
    
    
  SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2  
  END  
  
  IF (@PROCESS='GENERATE FILE')  
  BEGIN  
  
  IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))  
  BEGIN  
  SET @FILTER4=@FILTER6  
  END  
  
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)  
  WHERE CLIENT_CODE=@FILTER1  
    
  EXEC USP_CUSTARQ_FILEGENERATION @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7  
    
  END  
  
  IF (@PROCESS='BUILDRISKPROFILE')  
  BEGIN  
  
   
  SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1  
  
  DECLARE @SCOREQN7 INT =0  
  DECLARE @PROFILE1 AS VARCHAR(50)=''  
    
  DECLARE @RECID1 AS INT =0  
  
  
    
  
     
  
  IF @CNT >0   
  BEGIN  
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  QNANS=@FILTER2,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
  SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1  
    
  SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM   
  DBO.fn_Split1( @PROFILE1,','))A  
  WHERE A.QN=7   
    
    
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
    
    
     END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID  
  END  
    
    ----GET GRAPH DATA  
  
  EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
  
  
    ----GET DEBT RATIO  
  
  SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
  
    
 ----GET MINIMUM INVETMENT  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
   SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT1  
  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
     
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
         --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000))end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
     
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
     
   /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT1))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT1)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
     
select @NewMinInvest AS 'MINIMUMINVEST'  
           
  
    
  SET @MODEDESC=''  
  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  
  IF (@PROCESS='ADD MF LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)  
  SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()  
    
  END  
  
  IF (@PROCESS='ADD PG LIMIT LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)  
  SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()  
    
  END  
  
  IF(@PROCESS='PUSH MF')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1  
  
  END  
  
  
  IF(@PROCESS='GET LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1  
  
  END  
  
  IF(@PROCESS='GET MF')  
  BEGIN  
  
  SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1  
  
  END  
  
  
  IF(@PROCESS='UPDATE LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3  
  
  END  
    
  IF(@PROCESS='GET ARN')  
  BEGIN  
  SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE  
    
  END  
  IF(@PROCESS='GET DPID')  
  BEGIN  
  SELECT client_code as DPID from [AngelDP4].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8) IN ('12033200','12033201')    
    
  END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA_23May2018
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA_23May2018]
@PROCESS AS VARCHAR(100)='',
@FILTER1 AS VARCHAR(5000)='',
@FILTER2 AS VARCHAR(50)='',
@FILTER3 AS VARCHAR(50)='',
@FILTER4 AS VARCHAR(50)='',
@FILTER5 AS VARCHAR(50)='',
@FILTER6 AS VARCHAR(50)='',
@FILTER7 AS VARCHAR(50)='',
@FILTER8 AS VARCHAR(50)='',
@FILTER9 AS VARCHAR(50)='',
@USERNAME AS VARCHAR(200)='',
@ACCESS_TO AS VARCHAR(100)='',
@ACCESS_CODE AS VARCHAR(100)='',
@DIVICEID AS VARCHAR(25)=''


AS BEGIN 
		
		declare @MinimumDebtAmt int
		DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)

		IF (@PROCESS='VALIDATE CLIENT')
		BEGIN

		--WAITFOR DELAY '00:00:08';
		SELECT PARTY_CODE,LONG_NAME FROM [196.1.115.182].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE
		 -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE

		DECLARE @STR AS VARCHAR(50)=''

		SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		--SELECT A.RECID AS ID, MODEDESC--,NO_STOCK
		SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK
		,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		--ORDER BY NO_STOCK


		END


		IF (@PROCESS='UPDATE CLIENT MODE')
		BEGIN

		DECLARE @CNT AS INT=0
		DECLARE @VAL AS INT=0
		DECLARE @AMT_TO_INVET FLOAT=0

        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		IF @CNT >0 
		BEGIN
		----UPDATE 
		UPDATE TBL_CUSTARQ_CLIENT_MODE
		SET RECID=@FILTER2,
		ISDIRECT=1,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENT_CODE =@FILTER1
		END
		ELSE
		BEGIN
		----INSERT 
		INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID

		

		END

		EXEC USP_CUSTARQ_CUST_MAIN @FILTER1

		
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

			----GET MINIMUM INVETMENT

		SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		

        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		
		
		set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'
			END
		
		
		

		DECLARE @MODEDESC AS VARCHAR(500)=''
		 SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END

		IF (@PROCESS='RECALCULATE')
		BEGIN

		 DECLARE @ISDIRECT AS INT =1

		 SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1
		 SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1


		DECLARE @PREARQ AS FLOAT
		DECLARE @PREFIXEDINCOME AS FLOAT

		SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

		IF @CNT >0 
		BEGIN
		----UPDATE 
		UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT
		SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID

		WHERE CLIENTCODE= @FILTER1
		END
		ELSE
		BEGIN
		INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID
		END

		IF(@ISDIRECT=0)
		BEGIN

			IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )
			BEGIN
			     EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID
			END
			ELSE
			BEGIN

		

			UPDATE TBL_CUSTARQ_CLIENT_MODE
			SET ISDIRECT=1
			WHERE CLIENT_CODE =@FILTER1

			EXEC USP_CUSTARQ_CUST_MAIN @FILTER1 


			END

		
		END
		ELSE
		BEGIN
		EXEC USP_CUSTARQ_CUST_MAIN @FILTER1 
		END
		

		


			----GET MINIMUM INVETMENT
			

			SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
			JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
			ON A.RECID=B.ID 
			
			
			
			set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))
			else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END

	        

			SET @MODEDESC=''
		 SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END

		IF (@PROCESS='GETRISKPROFILE')
		BEGIN

		DECLARE @PROFILE AS VARCHAR(100)

		SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST


		
		SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1

		SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN

		,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A
		JOIN 

		(SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B
		ON A.SCORE=B.SCORE AND A.QN =B.QN


		END



		IF (@PROCESS='GETRECOMENTAION')
		BEGIN
		
		DECLARE @RECID AS VARCHAR(50)=''
		SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1
		EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2
		END

		IF (@PROCESS='GENERATE FILE')
		BEGIN

		IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))
		BEGIN
		SET @FILTER4=@FILTER6
		END

		UPDATE TBL_CUSTARQ_CLIENT_MODE
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)
		WHERE CLIENT_CODE=@FILTER1
		
		EXEC USP_CUSTARQ_FILEGENERATION @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7
		
		END

		IF (@PROCESS='BUILDRISKPROFILE')
		BEGIN

	
		SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1

		DECLARE @SCOREQN7 INT =0
		DECLARE @PROFILE1 AS VARCHAR(50)=''
		
		DECLARE @RECID1 AS INT =0


		

		 

		IF @CNT >0 
		BEGIN
		UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE
		SET  QNANS=@FILTER2,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENTCODE=@FILTER1
		
		SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1
		
		SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM 
		DBO.fn_Split1( @PROFILE1,','))A
		WHERE A.QN=7 
		
		
		UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE
		SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENTCODE=@FILTER1
		
		
		
	    END
		ELSE
		BEGIN
		INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID
		END
		
    ----GET GRAPH DATA

		EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID


    ----GET DEBT RATIO

		SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1

		
	----GET MINIMUM INVETMENT
		SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 


		
		 SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)
		 
		 
		 set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))
			PRINT @MinimumDebtAmt
			if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)
			BEGIN 
			--SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'
			
			
			SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
			else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'
			
			--SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END			
			ELSE
			BEGIN 
			SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
			END
		 
		 
         

		
		SET @MODEDESC=''

		 SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END


		IF (@PROCESS='ADD MF LOG')
		BEGIN
		
		INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)
		SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()
		
		END

		IF (@PROCESS='ADD PG LIMIT LOG')
		BEGIN
		
		INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)
		SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()
		
		END

		IF(@PROCESS='PUSH MF')
		BEGIN

		EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1

		END


		IF(@PROCESS='GET LIMIT')
		BEGIN

		EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1

		END

		IF(@PROCESS='GET MF')
		BEGIN

		SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1

		END


		IF(@PROCESS='UPDATE LIMIT')
		BEGIN

		EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3

		END
		
		IF(@PROCESS='GET ARN')
		BEGIN
		SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE
		
		END
		IF(@PROCESS='GET DPID')
		BEGIN
		SELECT client_code as DPID from [172.31.16.94].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8)='12033200'		
		
		END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA_ByNeeta
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA_ByNeeta]  
@PROCESS AS VARCHAR(100)='',  
@FILTER1 AS VARCHAR(5000)='',  
@FILTER2 AS VARCHAR(50)='',  
@FILTER3 AS VARCHAR(50)='',  
@FILTER4 AS VARCHAR(50)='',  
@FILTER5 AS VARCHAR(50)='',  
@FILTER6 AS VARCHAR(50)='',  
@FILTER7 AS VARCHAR(50)='',  
@FILTER8 AS VARCHAR(50)='',  
@FILTER9 AS VARCHAR(50)='',  
@USERNAME AS VARCHAR(200)='',  
@ACCESS_TO AS VARCHAR(100)='',  
@ACCESS_CODE AS VARCHAR(100)='',  
@DIVICEID AS VARCHAR(25)=''  
  
  
AS BEGIN   
    
  declare @MinimumDebtAmt int  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  DECLARE @RECID AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
     
  IF (@PROCESS='VALIDATE CLIENT')  
  BEGIN  
  
  --WAITFOR DELAY '00:00:08';  
  SELECT PARTY_CODE,LONG_NAME FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE  
   -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE  
  
  DECLARE @STR AS VARCHAR(50)=''  
  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  --SELECT A.RECID AS ID, MODEDESC--,NO_STOCK  
  SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK  
  ,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  --ORDER BY NO_STOCK  
  
  
  END  
  
  
  IF (@PROCESS='UPDATE CLIENT MODE')  
  BEGIN  
  
  DECLARE @CNT AS INT=0  
  DECLARE @VAL AS INT=0  
  DECLARE @AMT_TO_INVET FLOAT=0  
  
        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
  SET RECID=@FILTER2,  
  ISDIRECT=1,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENT_CODE =@FILTER1  
  END  
  ELSE  
  BEGIN  
  ----INSERT   
  INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID  
  
    
  
  END  
  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1  
  
    
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
   ----GET MINIMUM INVETMENT  
  
  SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
    
  
        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
  /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
  
  select @NewMinInvest AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'   
  
  DECLARE @MODEDESC AS VARCHAR(500)=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='RECALCULATE')  
  BEGIN  
  
   DECLARE @ISDIRECT AS INT =1  
  
   SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
   SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  
  DECLARE @PREARQ AS FLOAT  
  DECLARE @PREFIXEDINCOME AS FLOAT  
  
  SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT  
  SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  
  WHERE CLIENTCODE= @FILTER1  
  END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID  
  END  
  
  IF(@ISDIRECT=0)  
  BEGIN  
  
   IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )  
   BEGIN  
        EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
   END  
   ELSE  
   BEGIN  
  
    
  
   UPDATE TBL_CUSTARQ_CLIENT_MODE  
   SET ISDIRECT=1  
   WHERE CLIENT_CODE =@FILTER1  
  
   EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  
  
   END  
  
    
  END  
  ELSE  
  BEGIN  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  END  
    
  
    
  
  
   ----GET MINIMUM INVETMENT  
     
  
   SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
   JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
   ON A.RECID=B.ID   
     
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1   
     
   SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT2  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
   inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
   on v.isin=n.isin    
   INNER JOIN   
   (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
   ON V.type=X.MODEDESC  
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST')  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST')  
     
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
  
           
         /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@FILTER2 AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT2))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT2)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@FILTER2 AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
           
            select @NewMinInvest AS 'MINIMUMINVEST'  
   SET @MODEDESC=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='GETRISKPROFILE')  
  BEGIN  
  
  DECLARE @PROFILE AS VARCHAR(100)  
  
  SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST  
  
  
    
  SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1  
  
  SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN  
  
  ,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A  
  JOIN   
  
  (SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B  
  ON A.SCORE=B.SCORE AND A.QN =B.QN  
  
  
  END  
  
  
  
  IF (@PROCESS='GETRECOMENTAION')  
  BEGIN  
    
    
  SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2  
  END  
  
  IF (@PROCESS='GENERATE FILE')  
  BEGIN  
  
  IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))  
  BEGIN  
  SET @FILTER4=@FILTER6  
  END  
  
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)  
  WHERE CLIENT_CODE=@FILTER1  
    
  EXEC USP_CUSTARQ_FILEGENERATION_ByNeeta @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7  
    
  END  
  
  IF (@PROCESS='BUILDRISKPROFILE')  
  BEGIN  
  
   
  SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1  
  
  DECLARE @SCOREQN7 INT =0  
  DECLARE @PROFILE1 AS VARCHAR(50)=''  
    
  DECLARE @RECID1 AS INT =0  
  
  
    
  
     
  
  IF @CNT >0   
  BEGIN  
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  QNANS=@FILTER2,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
  SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1  
    
  SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM   
  DBO.fn_Split1( @PROFILE1,','))A  
  WHERE A.QN=7   
    
    
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
    
    
     END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID  
  END  
    
    ----GET GRAPH DATA  
  
  EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
  
  
    ----GET DEBT RATIO  
  
  SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
  
    
 ----GET MINIMUM INVETMENT  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
   SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT1  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
     
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
         --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
     
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT) )  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
     
   /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT1))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT1)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
     
select @NewMinInvest AS 'MINIMUMINVEST'  
           
  
    
  SET @MODEDESC=''  
  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  
  IF (@PROCESS='ADD MF LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)  
  SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()  
    
  END  
  
  IF (@PROCESS='ADD PG LIMIT LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)  
  SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()  
    
  END  
  
  IF(@PROCESS='PUSH MF')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1  
  
  END  
  
  
  IF(@PROCESS='GET LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1  
  
  END  
  
  IF(@PROCESS='GET MF')  
  BEGIN  
  
  SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1  
  
  END  
  
  
  IF(@PROCESS='UPDATE LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3  
  
  END  
    
  IF(@PROCESS='GET ARN')  
  BEGIN  
  SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE  
    
  END  
  IF(@PROCESS='GET DPID')  
  BEGIN  
  SELECT client_code as DPID from [AGMUBODPL3].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8)='12033200'    
    
  END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA_Ipartner
-- --------------------------------------------------
  
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA_Ipartner]  
@PROCESS AS VARCHAR(100)='',  
@FILTER1 AS VARCHAR(5000)='',  
@FILTER2 AS VARCHAR(50)='',  
@FILTER3 AS VARCHAR(50)='',  
@FILTER4 AS VARCHAR(50)='',  
@FILTER5 AS VARCHAR(50)='',  
@FILTER6 AS VARCHAR(50)='',  
@FILTER7 AS VARCHAR(50)='',  
@FILTER8 AS VARCHAR(50)='',  
@FILTER9 AS VARCHAR(50)='',  
@USERNAME AS VARCHAR(200)='',  
@ACCESS_TO AS VARCHAR(100)='',  
@ACCESS_CODE AS VARCHAR(100)='',  
@DIVICEID AS VARCHAR(25)=''  
  
  
AS BEGIN   
    
  declare @MinimumDebtAmt int  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  DECLARE @RECID AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
     
  IF (@PROCESS='VALIDATE CLIENT')  
  BEGIN  
  
  --WAITFOR DELAY '00:00:08';  
  SELECT PARTY_CODE,LONG_NAME FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE  
   -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE  
  
  DECLARE @STR AS VARCHAR(50)=''  
  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  --SELECT A.RECID AS ID, MODEDESC--,NO_STOCK  
  SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK  
  ,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  --ORDER BY NO_STOCK  
  
  
  END  
  
  
  IF (@PROCESS='UPDATE CLIENT MODE')  
  BEGIN  
  
  DECLARE @CNT AS INT=0  
  DECLARE @VAL AS INT=0  
  DECLARE @AMT_TO_INVET FLOAT=0  
  
        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
  SET RECID=@FILTER2,  
  ISDIRECT=1,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENT_CODE =@FILTER1  
  END  
  ELSE  
  BEGIN  
  ----INSERT   
  INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID  
  
    
  
  END  
  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1  
  
    
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
   ----GET MINIMUM INVETMENT  
  
  SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
    
  
        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2)
)/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
  /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
  
  select @NewMinInvest AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'   
  
  DECLARE @MODEDESC AS VARCHAR(500)=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='RECALCULATE')  
  BEGIN  
  
   DECLARE @ISDIRECT AS INT =1  
  
   SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
   SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  
  DECLARE @PREARQ AS FLOAT  
  DECLARE @PREFIXEDINCOME AS FLOAT  
  
  SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT    SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  
  WHERE CLIENTCODE= @FILTER1  
  END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID  
  END  
  
  IF(@ISDIRECT=0)  
  BEGIN  
  
   IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )  
   BEGIN  
        EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
   END  
   ELSE  
   BEGIN  
  
    
  
   UPDATE TBL_CUSTARQ_CLIENT_MODE  
   SET ISDIRECT=1  
   WHERE CLIENT_CODE =@FILTER1  
  
   EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  
  
   END  
  
    
  END  
  ELSE  
  BEGIN  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  END  
    
  
    
  
  
   ----GET MINIMUM INVETMENT  
     
  
   SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
   JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
   ON A.RECID=B.ID   
     
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1   
     
   SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT2  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
   inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
   on v.isin=n.isin    
   INNER JOIN   
   (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
   ON V.type=X.MODEDESC  
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST')  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST')  
     
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
  
           
         /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@FILTER2 AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT2))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT2)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@FILTER2 AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
           
            select @NewMinInvest AS 'MINIMUMINVEST'  
   SET @MODEDESC=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='GETRISKPROFILE')  
  BEGIN  
  
  DECLARE @PROFILE AS VARCHAR(100)  
  
  SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST  
  
  
    
  SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1  
  
  SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN  
  
  ,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A  
  JOIN   
  
  (SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B  
  ON A.SCORE=B.SCORE AND A.QN =B.QN  
  
  
  END  
  
  
  
  IF (@PROCESS='GETRECOMENTAION')  
  BEGIN  
    
    
  SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2  
  END  
  
  IF (@PROCESS='GENERATE FILE')  
  BEGIN  
  
  IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))  
  BEGIN  
  SET @FILTER4=@FILTER6  
  END  
  
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)  
  WHERE CLIENT_CODE=@FILTER1  
    
  EXEC USP_CUSTARQ_FILEGENERATION_Poweruser @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7  
    
  END  
  
  IF (@PROCESS='BUILDRISKPROFILE')  
  BEGIN  
  
   
  SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1  
  
  DECLARE @SCOREQN7 INT =0  
  DECLARE @PROFILE1 AS VARCHAR(50)=''  
    
  DECLARE @RECID1 AS INT =0  
  
  
    
  
     
  
  IF @CNT >0   
  BEGIN  
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  QNANS=@FILTER2,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
  SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1  
    
  SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM   
  DBO.fn_Split1( @PROFILE1,','))A  
  WHERE A.QN=7   
    
    
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
    
    
     END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID  
  END  
    
    ----GET GRAPH DATA  
  
  EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
  
  
    ----GET DEBT RATIO  
  
  SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
  
    
 ----GET MINIMUM INVETMENT  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
   SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT1  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
     
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
         --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
     
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT) )  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
     
   /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT1))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT1)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
     
select @NewMinInvest AS 'MINIMUMINVEST'  
           
  
    
  SET @MODEDESC=''  
  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  
  IF (@PROCESS='ADD MF LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)  
  SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()  
    
  END  
  
  IF (@PROCESS='ADD PG LIMIT LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)  
  SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()  
    
  END  
  
  IF(@PROCESS='PUSH MF')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1  
  
  END  
  
  
  IF(@PROCESS='GET LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1  
  
  END  
  
  IF(@PROCESS='GET MF')  
  BEGIN  
  
  SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1  
  
  END  
  
  
  IF(@PROCESS='UPDATE LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3  
  
  END  
    
  IF(@PROCESS='GET ARN')  
  BEGIN  
  SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE  
    
  END  
  IF(@PROCESS='GET DPID')  
  BEGIN  
  SELECT client_code as DPID from [AngelDP4].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8)='12033200'    
    
  END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA_UAT
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA_UAT]  
@PROCESS AS VARCHAR(100)='',  
@FILTER1 AS VARCHAR(5000)='',  
@FILTER2 AS VARCHAR(50)='',  
@FILTER3 AS VARCHAR(50)='',  
@FILTER4 AS VARCHAR(50)='',  
@FILTER5 AS VARCHAR(50)='',  
@FILTER6 AS VARCHAR(50)='',  
@FILTER7 AS VARCHAR(50)='',  
@FILTER8 AS VARCHAR(50)='',  
@FILTER9 AS VARCHAR(50)='',  
@USERNAME AS VARCHAR(200)='',  
@ACCESS_TO AS VARCHAR(100)='',  
@ACCESS_CODE AS VARCHAR(100)='',  
@DIVICEID AS VARCHAR(25)=''  
  
  
AS BEGIN   
    
  declare @MinimumDebtAmt int  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  DECLARE @RECID AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
     
  IF (@PROCESS='VALIDATE CLIENT')  
  BEGIN  
  
  --WAITFOR DELAY '00:00:08';  
  SELECT PARTY_CODE,LONG_NAME FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE  
   -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE  
  
  DECLARE @STR AS VARCHAR(50)=''  
  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  --SELECT A.RECID AS ID, MODEDESC--,NO_STOCK  
  SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK  
  ,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  --ORDER BY NO_STOCK  
  
  
  END  
  
  
  IF (@PROCESS='UPDATE CLIENT MODE')  
  BEGIN  
  
  DECLARE @CNT AS INT=0  
  DECLARE @VAL AS INT=0  
  DECLARE @AMT_TO_INVET FLOAT=0  
  
        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
  SET RECID=@FILTER2,  
  ISDIRECT=1,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENT_CODE =@FILTER1  
  END  
  ELSE  
  BEGIN  
  ----INSERT   
  INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID  
  
    
  
  END  
  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1  
  
    
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
   ----GET MINIMUM INVETMENT  
  
  SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
    
  
        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2
))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
  /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
  
  select @NewMinInvest AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'   
  
  DECLARE @MODEDESC AS VARCHAR(500)=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='RECALCULATE')  
  BEGIN  
  
   DECLARE @ISDIRECT AS INT =1  
  
   SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
   SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  
  DECLARE @PREARQ AS FLOAT  
  DECLARE @PREFIXEDINCOME AS FLOAT  
  
  SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT  
  SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  
  WHERE CLIENTCODE= @FILTER1  
  END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID  
  END  
  
  IF(@ISDIRECT=0)  
  BEGIN  
  
   IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )  
   BEGIN  
        EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
   END  
   ELSE  
   BEGIN  
  
    
  
   UPDATE TBL_CUSTARQ_CLIENT_MODE  
   SET ISDIRECT=1  
   WHERE CLIENT_CODE =@FILTER1  
  
   EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  
  
   END  
  
    
  END  
  ELSE  
  BEGIN  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  END  
    
  
    
  
  
   ----GET MINIMUM INVETMENT  
     
  
   SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
   JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
   ON A.RECID=B.ID   
     
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1   
     
   SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT2  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
   inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
   on v.isin=n.isin    
   INNER JOIN   
   (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
   ON V.type=X.MODEDESC  
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST')  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST')  
     
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
  
           
         /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@FILTER2 AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT2))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT2)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@FILTER2 AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
           
            select @NewMinInvest AS 'MINIMUMINVEST'  
   SET @MODEDESC=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='GETRISKPROFILE')  
  BEGIN  
  
  DECLARE @PROFILE AS VARCHAR(100)  
  
  SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST  
  
  
    
  SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1  
  
  SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN  
  
  ,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A  
  JOIN   
  
  (SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B  
  ON A.SCORE=B.SCORE AND A.QN =B.QN  
  
  
  END  
  
  
  
  IF (@PROCESS='GETRECOMENTAION')  
  BEGIN  
    
    
  SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2  
  END  
  
  IF (@PROCESS='GENERATE FILE')  
  BEGIN  
  
  IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))  
  BEGIN  
  SET @FILTER4=@FILTER6  
  END  
  
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)  
  WHERE CLIENT_CODE=@FILTER1  
    
  EXEC USP_CUSTARQ_FILEGENERATION @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7  
    
  END  
  
  IF (@PROCESS='BUILDRISKPROFILE')  
  BEGIN  
  
   
  SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1  
  
  DECLARE @SCOREQN7 INT =0  
  DECLARE @PROFILE1 AS VARCHAR(50)=''  
    
  DECLARE @RECID1 AS INT =0  
  
  
    
  
     
  
  IF @CNT >0   
  BEGIN  
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  QNANS=@FILTER2,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
  SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1  
    
  SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM   
  DBO.fn_Split1( @PROFILE1,','))A  
  WHERE A.QN=7   
    
    
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
    
    
     END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID  
  END  
    
    ----GET GRAPH DATA  
  
  EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
  
  
    ----GET DEBT RATIO  
  
  SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
  
    
 ----GET MINIMUM INVETMENT  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
   SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT1  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
     
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
         --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000))end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) 
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
     
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
 END,0) AS INT) )  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
     
   /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT1))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT1)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
     
select @NewMinInvest AS 'MINIMUMINVEST'  
           
  
    
  SET @MODEDESC=''  
  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  
  IF (@PROCESS='ADD MF LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)  
  SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()  
    
  END  
  
  IF (@PROCESS='ADD PG LIMIT LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)  
  SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()  
    
  END  
  
  IF(@PROCESS='PUSH MF')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1  
  
  END  
  
  
  IF(@PROCESS='GET LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1  
  
  END  
  
  IF(@PROCESS='GET MF')  
  BEGIN  
  
  SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1  
  
  END  
  
  
  IF(@PROCESS='UPDATE LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3  
  
  END  
    
  IF(@PROCESS='GET ARN')  
  BEGIN  
  SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE  
    
  END  
  IF(@PROCESS='GET DPID')  
  BEGIN  
  SELECT client_code as DPID from [AngelDP4].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8) IN ('12033200','12033201')    
    
  END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA_V1
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_GETDATA_V1]  
@PROCESS AS VARCHAR(100)='',  
@FILTER1 AS VARCHAR(5000)='',  
@FILTER2 AS VARCHAR(50)='',  
@FILTER3 AS VARCHAR(50)='',  
@FILTER4 AS VARCHAR(50)='',  
@FILTER5 AS VARCHAR(50)='',  
@FILTER6 AS VARCHAR(50)='',  
@FILTER7 AS VARCHAR(50)='',  
@FILTER8 AS VARCHAR(50)='',  
@FILTER9 AS VARCHAR(50)='',  
@USERNAME AS VARCHAR(200)='',  
@ACCESS_TO AS VARCHAR(100)='',  
@ACCESS_CODE AS VARCHAR(100)='',  
@DIVICEID AS VARCHAR(25)=''  
  
  
AS BEGIN   
    
  declare @MinimumDebtAmt int  
  DECLARE @ARQR AS VARCHAR(25),@DEBT AS VARCHAR(25)  
  DECLARE @RECID AS VARCHAR(50)=''  
  DECLARE @CurrMinInvest float,@CurrARQInvestment float,@PerScheme float,@ModVal float,@TotalInvest float,@NewMinInvest float,@RoundUp int  
     
  IF (@PROCESS='VALIDATE CLIENT')  
  BEGIN  
  
  --WAITFOR DELAY '00:00:08';  
  SELECT PARTY_CODE,LONG_NAME FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE  
   -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE  
  
  DECLARE @STR AS VARCHAR(50)=''  
  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  --SELECT A.RECID AS ID, MODEDESC--,NO_STOCK  
  SELECT A.RECID AS ID, case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end as MODEDESC--,NO_STOCK  
  ,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  --ORDER BY NO_STOCK  
  
  
  END  
  
  
  IF (@PROCESS='UPDATE CLIENT MODE')  
  BEGIN  
  
  DECLARE @CNT AS INT=0  
  DECLARE @VAL AS INT=0  
  DECLARE @AMT_TO_INVET FLOAT=0  
  
        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
  SET RECID=@FILTER2,  
  ISDIRECT=1,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENT_CODE =@FILTER1  
  END  
  ELSE  
  BEGIN  
  ----INSERT   
  INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID  
  
    
  
  END  
  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1  
  
    
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
   ----GET MINIMUM INVETMENT  
  
  SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
    
  
        SELECT @ARQR= ARQ ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
    
  SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
    
    
  set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000
  
 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2 
 
))/100))%5000)) end,0) as int))  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'  
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
     
   END  
    
  /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
  
  select @NewMinInvest AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'   
  
  DECLARE @MODEDESC AS VARCHAR(500)=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='RECALCULATE')  
  BEGIN  
  
   DECLARE @ISDIRECT AS INT =1  
  
   SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
   SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  
  DECLARE @PREARQ AS FLOAT  
  DECLARE @PREFIXEDINCOME AS FLOAT  
  
  SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
  
  IF @CNT >0   
  BEGIN  
  ----UPDATE   
  UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT  
  SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  
  WHERE CLIENTCODE= @FILTER1  
  END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID  
  END  
  
  IF(@ISDIRECT=0)  
  BEGIN  
  
   IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )  
   BEGIN  
        EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
   END  
   ELSE  
   BEGIN  
  
    
  
   UPDATE TBL_CUSTARQ_CLIENT_MODE  
   SET ISDIRECT=1  
   WHERE CLIENT_CODE =@FILTER1  
  
   EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  
  
   END  
  
    
  END  
  ELSE  
  BEGIN  
  EXEC USP_CUSTARQ_CUST_MAIN @FILTER1   
  END  
    
  
    
  
  
   ----GET MINIMUM INVETMENT  
     
  
   SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
   JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
   ON A.RECID=B.ID   
     
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1   
     
   SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT2  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
   inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
   on v.isin=n.isin    
   INNER JOIN   
   (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
   ON V.type=X.MODEDESC  
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(@FILTER3>0 and (@MinimumDebtAmt*(CAST (@FILTER3 AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
   --SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   --else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))  
   else (5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@FILTER3 AS DECIMAL(18,2))/100))%5000)) end,0) as int)AS 'MINIMUMINVEST')  
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0)AS INT) AS 'MINIMUMINVEST'  
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST')  
     
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
  
           
         /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@FILTER2 AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT2))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT2)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@FILTER2 AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
           
            select @NewMinInvest AS 'MINIMUMINVEST'  
   SET @MODEDESC=''  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  IF (@PROCESS='GETRISKPROFILE')  
  BEGIN  
  
  DECLARE @PROFILE AS VARCHAR(100)  
  
  SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST  
  
  
    
  SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1  
  
  SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN  
  
  ,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A  
  JOIN   
  
  (SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B  
  ON A.SCORE=B.SCORE AND A.QN =B.QN  
  
  
  END  
  
  
  
  IF (@PROCESS='GETRECOMENTAION')  
  BEGIN  
    
    
  SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2  
  END  
  
  IF (@PROCESS='GENERATE FILE')  
  BEGIN  
  
  IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))  
  BEGIN  
  SET @FILTER4=@FILTER6  
  END  
  
  UPDATE TBL_CUSTARQ_CLIENT_MODE  
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)  
  WHERE CLIENT_CODE=@FILTER1  
    
  EXEC USP_CUSTARQ_FILEGENERATION_ByNeeta @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName,@FILTER7  
    
  END  
  
  IF (@PROCESS='BUILDRISKPROFILE')  
  BEGIN  
  
   
  SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1  
  
  DECLARE @SCOREQN7 INT =0  
  DECLARE @PROFILE1 AS VARCHAR(50)=''  
    
  DECLARE @RECID1 AS INT =0  
  
  
    
  
     
  
  IF @CNT >0   
  BEGIN  
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  QNANS=@FILTER2,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
  SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1  
    
  SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM   
  DBO.fn_Split1( @PROFILE1,','))A  
  WHERE A.QN=7   
    
    
  UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE  
  SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,  
  UPDATE_BY=@USERNAME,  
  UPDATE_DATE=GETDATE(),  
  DIVICEID=@DIVICEID  
  WHERE CLIENTCODE=@FILTER1  
    
    
    
     END  
  ELSE  
  BEGIN  
  INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)  
  SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID  
  END  
    
    ----GET GRAPH DATA  
  
  EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID  
  
  
    ----GET DEBT RATIO  
  
  SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1  
  
    
 ----GET MINIMUM INVETMENT  
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1  
  
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
   SELECT @ARQR= ARQ,@DEBT=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)  
     
   SELECT @RECID=RECID FROM TBL_CUSTARQ_CLIENT_MODE WITH(NOLOCK) WHERE CLIENT_CODE=@FILTER1  
    
  SELECT  TYPE,SCHEME_NAME,V.ISIN,QUANTITY=CONVERT(INT,0),AMOUNT=CONVERT(MONEY,0),Price=Navprice into #ARQBUYSCRIPT1  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  INNER JOIN   
  (SELECT MODEID,MODEDESC,CUSTOMMODEID FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.type=X.MODEDESC  
     
     
   set @MinimumDebtAmt =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT))  
   PRINT @MinimumDebtAmt  
   if(CAST (@DEBT AS DECIMAL(18,2))>0 and (@MinimumDebtAmt*(CAST (@DEBT AS DECIMAL(18,2))/100))<5000)  
   BEGIN   
   --SELECT (5000/(CAST (@FILTER3 AS DECIMAL(18,2))/100))+5000.00 AS 'MINIMUMINVEST'  
     
     
         --SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000))end,0) as int)AS 'MINIMUMINVEST'  
     
   set @CurrMinInvest =(SELECT cast(ROUND(case when ((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)=0 then (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))
   else (5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100)) +(5000-((5000.00/(CAST (@DEBT AS DECIMAL(18,2))/100))%5000)) end,0) as int))  
     
     
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%10000 END,0) AS INT) AS 'MINIMUMINVEST'  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END     
   ELSE  
   BEGIN   
   --SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) AS 'MINIMUMINVEST'  
     
     
   set @CurrMinInvest =(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) 
   ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%5000 END,0) AS INT) )  
   ---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
   END  
     
   /*to get the new invest */    
  
     set @CurrARQInvestment=@CurrMinInvest*(CAST (@ARQR AS DECIMAL(18,2))/100)  
     set @PerScheme=ceiling(@CurrARQInvestment/(select count(1) from #ARQBUYSCRIPT1))  
     set @ModVal=case when (cast(@PerScheme as int)%500)=0 then 0 else ceiling(500-((cast(@PerScheme as int)%500)))+@PerScheme end  
     set @TotalInvest= @ModVal*(select count(1) from #ARQBUYSCRIPT1)  
     set @RoundUp=round(100-cast(@TotalInvest as int)/(CAST (@ARQR AS DECIMAL(18,2))/100)%100,0)  
     set @NewMinInvest=case when @TotalInvest=0 then @CurrMinInvest else  round((@TotalInvest/(CAST (@ARQR AS DECIMAL(18,2))/100))+@RoundUp,0) end   
  
   /*ended by sandeep*/  
     
select @NewMinInvest AS 'MINIMUMINVEST'  
           
  
    
  SET @MODEDESC=''  
  
   SELECT @MODEDESC =@MODEDESC+','+case when MODEDESC='Large Cap Stocks' then 'Large Cap' when MODEDESC='Multi Cap Stocks' then 'Multi Cap' when MODEDESC='Mid Cap Stocks' then 'Mid Cap' end 
   FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC  
  
  END  
  
  
  IF (@PROCESS='ADD MF LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)  
  SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()  
    
  END  
  
  IF (@PROCESS='ADD PG LIMIT LOG')  
  BEGIN  
    
  INSERT INTO TBL_CUSTARQ_UPDATELIMIT_LOG(CLIENTCODE,MESSAGE,STATUS,IPOAmount,MFAmount,TradingAmount,AMOUNT,MFTransactionNO,ADDEDBY,ADDEDON)  
  SELECT @FILTER1,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER6,@FILTER7,@FILTER8,@USERNAME,GETDATE()  
    
  END  
  
  IF(@PROCESS='PUSH MF')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1  
  
  END  
  
  
  IF(@PROCESS='GET LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1  
  
  END  
  
  IF(@PROCESS='GET MF')  
  BEGIN  
  
  SELECT * FROM ANGELFO.BSEMFSS.DBO.MFSS_CLIENT  WHERE  PARTY_CODE =@FILTER1  
  
  END  
  
  
  IF(@PROCESS='UPDATE LIMIT')  
  BEGIN  
  
  EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_UPDATEPGLIMIT @FILTER1,@FILTER2,@FILTER3  
  
  END  
    
  IF(@PROCESS='GET ARN')  
  BEGIN  
  SELECT ISNULL([ARN No],'') as  ARNNo FROM RISK.DBO.TBL_MF_LS_ARN_EUINS WITH(NOLOCK) WHERE [SB EQUITY TAG]=@ACCESS_CODE  
    
  END  
  IF(@PROCESS='GET DPID')  
  BEGIN  
  SELECT client_code as DPID from [AngelDP4].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 and left(client_Code,8)='12033200'    
    
  END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETDATA21092017
-- --------------------------------------------------
create PROC [dbo].[USP_CUSTARQ_GETDATA21092017]
@PROCESS AS VARCHAR(100)='',
@FILTER1 AS VARCHAR(5000)='',
@FILTER2 AS VARCHAR(50)='',
@FILTER3 AS VARCHAR(50)='',
@FILTER4 AS VARCHAR(50)='',
@FILTER5 AS VARCHAR(50)='',
@FILTER6 AS VARCHAR(50)='',
@USERNAME AS VARCHAR(200)='',
@ACCESS_TO AS VARCHAR(100)='',
@ACCESS_CODE AS VARCHAR(100)='',
@DIVICEID AS VARCHAR(25)=''


AS BEGIN 

		IF (@PROCESS='VALIDATE CLIENT')
		BEGIN

		--WAITFOR DELAY '00:00:08';
		SELECT PARTY_CODE,LONG_NAME FROM [196.1.115.182].GENERAL.DBO.CLIENT_DETAILS WITH (NOLOCK) WHERE PARTY_CODE=@FILTER1 AND SUB_BROKER=@ACCESS_CODE
		 -- SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=rtrim(ltrim(@FILTER1)) AND SUB_BROKER=@ACCESS_CODE

		DECLARE @STR AS VARCHAR(50)=''

		SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		SELECT A.RECID AS ID, MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,CAST(CASE WHEN B.ID IS NULL THEN 0 ELSE 1 END AS BIT) AS OPTED FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		LEFT JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 
		ORDER BY NO_STOCK


		END


		IF (@PROCESS='UPDATE CLIENT MODE')
		BEGIN

		DECLARE @CNT AS INT=0
		DECLARE @VAL AS INT=0
		DECLARE @AMT_TO_INVET FLOAT=0

        SELECT @CNT=COUNT(1) FROM  TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		IF @CNT >0 
		BEGIN
		----UPDATE 
		UPDATE TBL_CUSTARQ_CLIENT_MODE
		SET RECID=@FILTER2,
		ISDIRECT=1,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENT_CODE =@FILTER1
		END
		ELSE
		BEGIN
		----INSERT 
		INSERT INTO TBL_CUSTARQ_CLIENT_MODE(CLIENT_CODE,RECID,UPDATE_DATE,ISDIRECT,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,@FILTER2,@FILTER3,1,@USERNAME,GETDATE(),@DIVICEID

		

		END

		EXEC USP_CUSTARQ_CUST_MAIN @FILTER1

		
        SELECT * FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

			----GET MINIMUM INVETMENT

		SELECT @STR=RECID,@AMT_TO_INVET= isnull(AMT_TO_INVEST,0)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		DECLARE @ARQR AS VARCHAR(25)

        SELECT @ARQR= ARQ FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 


		
		--SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'
		 SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%25000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%25000 END,0) AS INT) AS 'MINIMUMINVEST',@AMT_TO_INVET AS 'INVESTAMT'

		DECLARE @MODEDESC AS VARCHAR(500)=''
		 SELECT @MODEDESC =@MODEDESC+','+MODEDESC FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END

		IF (@PROCESS='RECALCULATE')
		BEGIN

		 DECLARE @ISDIRECT AS INT =1

		 SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1
		 SELECT @STR=RECID,@ISDIRECT=ISNULL(ISDIRECT,1)   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1


		DECLARE @PREARQ AS FLOAT
		DECLARE @PREFIXEDINCOME AS FLOAT

		SELECT @PREARQ=ARQ,@PREFIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)

		IF @CNT >0 
		BEGIN
		----UPDATE 
		UPDATE TBL_CUSTARQ_DEBTRATIO_CLIENT
		SET ARQ=CAST (@FILTER2 AS FLOAT),FIXEDINCOME=CAST (@FILTER3 AS FLOAT),
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID

		WHERE CLIENTCODE= @FILTER1
		END
		ELSE
		BEGIN
		INSERT INTO TBL_CUSTARQ_DEBTRATIO_CLIENT(CLIENTCODE,ARQ,FIXEDINCOME,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,CAST (@FILTER2 AS FLOAT),CAST (@FILTER3 AS FLOAT),@USERNAME,GETDATE(),@DIVICEID
		END

		IF(@ISDIRECT=0)
		BEGIN

			IF((@PREARQ=CAST (@FILTER2 AS FLOAT)) AND (@PREFIXEDINCOME=CAST (@FILTER3 AS FLOAT)) )
			BEGIN
			     EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID
			END
			ELSE
			BEGIN

		

			UPDATE TBL_CUSTARQ_CLIENT_MODE
			SET ISDIRECT=1
			WHERE CLIENT_CODE =@FILTER1

			EXEC USP_CUSTARQ_CUST_MAIN @FILTER1 


			END

		
		END
		ELSE
		BEGIN
		EXEC USP_CUSTARQ_CUST_MAIN @FILTER1 
		END
		

		


			----GET MINIMUM INVETMENT
			

			SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
			JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
			ON A.RECID=B.ID 


	 SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%25000=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-(@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))%25000 END,0) AS INT) AS 'MINIMUMINVEST'
			---SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@FILTER2 AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@FILTER2 AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'

			SET @MODEDESC=''
		 SELECT @MODEDESC =@MODEDESC+','+MODEDESC FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END

		IF (@PROCESS='GETRISKPROFILE')
		BEGIN

		DECLARE @PROFILE AS VARCHAR(100)

		SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(500)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST


		
		SELECT @PROFILE=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE =@FILTER1

		SELECT A.*,B.TEXT FROM(SELECT SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN

		,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM DBO.fn_Split1( @PROFILE,','))A
		JOIN 

		(SELECT CAST ( [RPA_IRPQID] AS VARCHAR(50)) AS QN,CAST ([RPA_IANSNO] AS VARCHAR(50)) AS SCORE, CAST ([RPA_TANS] AS VARCHAR(50)) AS [TEXT] FROM TBL_CUSTARQ_ANS_MST)B
		ON A.SCORE=B.SCORE AND A.QN =B.QN


		END



		IF (@PROCESS='GETRECOMENTAION')
		BEGIN
		
		DECLARE @RECID AS VARCHAR(50)=''
		SELECT @RECID= RECID FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1
		EXEC USP_CUSTARQ_GETRECOMMENDATION @FILTER1, @RECID,@FILTER2
		END

		IF (@PROCESS='GENERATE FILE')
		BEGIN

		IF(CAST( @FILTER4 AS MONEY) < CAST(@FILTER6 AS MONEY))
		BEGIN
		SET @FILTER4=@FILTER6
		END

		UPDATE TBL_CUSTARQ_CLIENT_MODE
        SET AMT_TO_INVEST=CAST(@FILTER6 AS FLOAT)
		WHERE CLIENT_CODE=@FILTER1
		
		EXEC USP_CUSTARQ_FILEGENERATION @FILTER1,@FILTER4,@FILTER2,@FILTER3,@FILTER5,@UserName
		
		END

		IF (@PROCESS='BUILDRISKPROFILE')
		BEGIN

	
		SELECT @CNT=COUNT(1) FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE= @FILTER1

		DECLARE @SCOREQN7 INT =0
		DECLARE @PROFILE1 AS VARCHAR(50)=''
		
		DECLARE @RECID1 AS INT =0


		

		 

		IF @CNT >0 
		BEGIN
		UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE
		SET  QNANS=@FILTER2,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENTCODE=@FILTER1
		
		SELECT @PROFILE1=QNANS FROM TBL_CUSTARQ_CLIENT_RISKPROFILE WHERE CLIENTCODE=@FILTER1
		
		SELECT @RECID1= CASE WHEN SCORE =1 THEN 1 ELSE 2 END FROM (SELECT  SUBSTRING(StringValue,0,CHARINDEX('-',StringValue))AS QN,SUBSTRING(StringValue,(CHARINDEX('-',StringValue))+1,LEN(StringValue)+1) as SCORE FROM 
		DBO.fn_Split1( @PROFILE1,','))A
		WHERE A.QN=7 
		
		
		UPDATE TBL_CUSTARQ_CLIENT_RISKPROFILE
		SET  PROFILENUM=CASE WHEN PROFILENUM =(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE CASE WHEN( PROFILENUM +1) >(CASE WHEN @RECID1=1 THEN 5 ELSE 3 END ) THEN 1 ELSE ( PROFILENUM +1) END END,
		UPDATE_BY=@USERNAME,
		UPDATE_DATE=GETDATE(),
		DIVICEID=@DIVICEID
		WHERE CLIENTCODE=@FILTER1
		
		
		
	    END
		ELSE
		BEGIN
		INSERT INTO TBL_CUSTARQ_CLIENT_RISKPROFILE(CLIENTCODE,QNANS,PROFILENUM,INSERT_BY,INSERT_DATE,DIVICEID)
		SELECT @FILTER1,@FILTER2,1,@USERNAME,GETDATE(),@DIVICEID
		END
		
    ----GET GRAPH DATA

		EXEC USP_CUSTARQ_BUILD_INVESTMENTPLAN @FILTER1,@USERNAME,@DIVICEID


    ----GET DEBT RATIO

		SELECT * FROM TBL_CUSTARQ_DEBTRATIO_CLIENT WHERE CLIENTCODE= @FILTER1

		
	----GET MINIMUM INVETMENT
		SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@FILTER1

		SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 


		
		 SELECT @ARQR= ARQ FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@FILTER1)
         SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%25000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%25000 END,0) AS INT) AS 'MINIMUMINVEST'

		
		SET @MODEDESC=''

		 SELECT @MODEDESC =@MODEDESC+','+MODEDESC FROM (SELECT MODEDESC,NO_STOCK,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A
		JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B
		ON A.RECID=B.ID 

		SELECT SUBSTRING( @MODEDESC,2,LEN(@MODEDESC)) AS MODEDESC

		END


		IF (@PROCESS='ADD MF LOG')
		BEGIN
		
		INSERT INTO TBL_CUSTARQ_MFORDER_LOG(CLIENTCODE,INTERNALREFNO,MESSAGE,STATUS,SCHEMECODE,INPUT,ADDEDBY,ADDEDON)
		SELECT @FILTER6,@FILTER2,@FILTER3,@FILTER4,@FILTER5,@FILTER1,@USERNAME,GETDATE()
		
		END

		IF(@PROCESS='PUSH MF')
		BEGIN

		EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_PUSHMF @FILTER1

		END


		IF(@PROCESS='GET LIMIT')
		BEGIN

		EXEC CustomizedARQ.DBO.USP_CUSTARQ_CUST_LIMIT_VALIDATE @FILTER1

		END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETRECOMMENDATION
-- --------------------------------------------------
--USP_CUSTARQ_GETRECOMMENDATION 'bknr2333','2,3','aLTRA'  
CREATE Procedure  [dbo].[USP_CUSTARQ_GETRECOMMENDATION]  
@PARTY_CODE VARCHAR(12)='',  
@RECID VARCHAR(50)='',  
@CALCOPTION VARCHAR(50)=''  
AS  
BEGIN  
--DECLARE @RECID VARCHAR(50)='2,4,5,6'  
  DECLARE @STR VARCHAR(50),@VAL AS INT=0,@MINIMUMINVEST MONEY,@ARQEQUITYPER decimal(18,2),@ARQCNT INT,@DEBTPER decimal(18,2)  
  SELECT @CALCOPTION=CASE WHEN @CALCOPTION='ALTRA' THEN 'DEBT-ULTRA SHORT TERM' ELSE 'DEBT-INCOME' END  
    
        DECLARE @ARQR VARCHAR(25),@DEBT VARCHAR(50)  
        SELECT @ARQR= ARQ FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)  
  --SELECT @ARQR  
  SET @DEBT=100.00-@ARQR  
    
  SELECT @STR=RECID   FROM TBL_CUSTARQ_CLIENT_MODE WHERE CLIENT_CODE =@PARTY_CODE  
    
  SELECT @VAL= SUM( INVEST_RS) FROM (SELECT MODEDESC,INVEST_RS,CAGR,DRAWDOWN,SHARPRATIO,VOLATILITY,RECID FROM TBL_CUSTARQ_MODEMASTER)A  
  JOIN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@STR,','))B  
  ON A.RECID=B.ID   
  
  
    
  --SELECT CAST( ROUND( CASE WHEN (@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100))=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+25000.00-@VAL%(CAST (@ARQR AS DECIMAL(18,2))/100) END,0) AS INT) AS 'MINIMUMINVEST'  
  --GET MINIMUM INVESTMENT OF EQUITY AND DEBT  
    
  if exists (select * from TBL_CUSTARQ_CLIENT_MODE with(nolock) where CLIENT_CODE=@PARTY_CODE and isnull(AMT_TO_INVEST,0)>0)  
  BEGIN  
  SET @MINIMUMINVEST=(select ISNULL(AMT_TO_INVEST,0) from TBL_CUSTARQ_CLIENT_MODE with(nolock) where CLIENT_CODE=@PARTY_CODE and AMT_TO_INVEST>0)  
  END  
  ELSE  
  BEGIN  
  SET @MINIMUMINVEST=(SELECT CAST( ROUND( CASE WHEN (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%10000=0.0 THEN @VAL/(CAST (@ARQR AS DECIMAL(18,2))/100) ELSE (@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))+5000.00-(@VAL/(CAST (@ARQR AS DECIMAL(18,2))/100))%10000
 END,0) AS INT))  
  END  
    
     
   --SELECT @MINIMUMINVEST  
   SET @ARQCNT=(SELECT COUNT(*) FROM (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,','))X)  
  --select @ARQCNT  
   --GET WEIGHTAGE PERCENTAGE OF EQUITY AND DEBT    
     
   SET @ARQEQUITYPER=(SELECT (@MINIMUMINVEST*(@ARQR/100.00))/@ARQCNT)     
   SET @ARQEQUITYPER=(SELECT ((@ARQEQUITYPER/@MINIMUMINVEST)*100))  
   SET @DEBTPER=(SELECT (@MINIMUMINVEST*(@DEBT/100.00)))     
   SET @DEBTPER=(SELECT ((@DEBTPER/@MINIMUMINVEST)*100))  
     
  --SELECT @ARQEQUITYPER,@DEBTPER  
    
  --GET RECOMMENDATION OF EQUITY AND DEBT  
    
  --SELECT ARQ_TCATEGORY as Category ,ARQ_TSCRIPNAME as Script,V.ISIN as Isin,ARQ_TBENCHMARK as Benckmark,Price = CAST (c.lasttradeprice AS DECIMAL(18,2)),cast(CAST(ROUND(@ARQEQUITYPER,2) AS decimal(18,2)) as varchar)+'%' AS WEIGHTAGE  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V  
  -- INNER JOIN [172.31.16.85].odinfeed.dbo.feed_live_eq_bse c WITH (nolock)   
  --ON V.arq_tbsescripcode = c.securitycode   
              
  --INNER JOIN   
  --(SELECT MODEID,MODEDESC FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  --ON V.ARQ_TCATEGORY=X.MODEDESC  
  --WHERE ARQ_TSTATUS='A'  
    
    
    
    
    
  SELECT case when Type='Large Cap Stocks' then 'Large Cap' when Type='Multi Cap Stocks' then 'Multi Cap' when Type='Mid Cap Stocks' then 'Mid Cap' end as Category,
  SCHEME_NAME as Script,V.isin as Isin,CONVERT(varchar(50),'MFARQ') as ARQ_TBENCHMARK,Price=CAST (Navprice AS DECIMAL(18,2)),cast(CAST(ROUND(@ARQEQUITYPER/X.NO_STOCK,2) AS decimal(18,2)) as varchar)+'%' AS WEIGHTAGE    
  from [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin  
  INNER JOIN   
  (SELECT MODEID,MODEDESC,NO_STOCK FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X  
  ON V.Type=X.MODEDESC  
    
    
    
    
  union all  
  SELECT TYPE as ARQ_TCATEGORY,SCHEME_NAME as Script,V.ISIN as Isin,CONVERT(varchar(50),'DEBT') as ARQ_TBENCHMARK,Price=CAST (Navprice AS DECIMAL(18,2)) ,CAST(CAST(ROUND(@DEBTPER,2) AS decimal(18,2)) as varchar)+'%' AS WEIGHTAGE  
  FROM [ABVSAWUARQ1].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v  
  inner join [172.31.16.85].abr_dw.dbo.IWMF_vw_NAVDetails n  
  on v.isin=n.isin    
  WHERE [TYPE] =@CALCOPTION   
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_GETRECOMMENDATION_22AUG2017
-- --------------------------------------------------
--USP_CUSTARQ_GETRECOMMENDATION 'V68432','2','aLTRA'
CREATE Procedure  [dbo].[USP_CUSTARQ_GETRECOMMENDATION_22AUG2017]
@PARTY_CODE VARCHAR(12)='',
@RECID VARCHAR(50)='',
@CALCOPTION VARCHAR(50)=''
AS
BEGIN
--DECLARE @RECID VARCHAR(50)='2,4,5,6'

		select @CALCOPTION=case when @CALCOPTION='ALTRA' then 'DEBT-ULTRA SHORT TERM' else 'DEBT-INCOME' end
		
        DECLARE @ARQR VARCHAR(25),@DEBT VARCHAR(50)
        SELECT @ARQR= ARQ FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@PARTY_CODE)
		--SELECT @ARQR
		SET @DEBT=100.00-@ARQR
		SELECT ARQ_TCATEGORY as Category ,ARQ_TSCRIPNAME as Script,V.ISIN as Isin,ARQ_TBENCHMARK as Benckmark,Price = CONVERT(DECIMAL(18, 2), c.lasttradeprice),@ARQR+'%' AS WEIGHTAGE  FROM [172.31.16.75].ANGEL_WMS.DBO.ARQ_RECO_EQSTOCK_V3 V
		 INNER JOIN [172.31.16.85].livefeed.dbo.feed_live_eq_bse c WITH (nolock) 
		ON V.arq_tbsescripcode = c.securitycode 
            
		INNER JOIN 
		(SELECT MODEID,MODEDESC FROM TBL_CUSTARQ_MODEMASTER WITH(NOLOCK) WHERE RECID IN (SELECT STRINGVALUE AS ID FROM DBO.FN_SPLIT1(@RECID,',')))X
		ON V.ARQ_TCATEGORY=X.MODEDESC
		WHERE ARQ_TSTATUS='A'
		
		
		
		union all
		SELECT TYPE as ARQ_TCATEGORY,SCHEME_NAME as Script,V.ISIN as Isin,CONVERT(varchar(50),'DEBT') as ARQ_TBENCHMARK,Price=Navprice ,@DEBT+'%' AS WEIGHTAGE
		FROM [172.31.16.75].ANGEL_WMS.DBO.TBL_ARQ_DEBT_MFSTOCK_V3 v
		inner join [172.31.16.38].abr_dw.dbo.IWMF_vw_NAVDetails n
		on v.isin=n.isin		
		WHERE [TYPE] =@CALCOPTION
		



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CUSTARQ_REBALANCE
-- --------------------------------------------------
CREATE PROC [dbo].[USP_CUSTARQ_REBALANCE]
@STATERGY VARCHAR(50)='',
@CLEINT_CODE VARCHAR(50)=''
AS BEGIN

DECLARE @ARQ1 float=0.0
DECLARE @FIXEDINCOME1 float=0.0
DECLARE @SHARPRATIO AS float=(0.075/248.00)
DECLARE @MAXAFTERREBALTOTAL AS float=0.0
DECLARE @MINAFTERREBALTOTAL AS float=0.0
DECLARE @MAXBSETOTAL AS float=0.0
DECLARE @MINBSETOTAL AS float=0.0
DECLARE @STARTDATE AS DATE =NULL
DECLARE @ENDDATE AS DATE=NULL




DELETE FROM #OP_UST WHERE TRADE_DATE IS NULL

SELECT @ARQ1=ARQ,@FIXEDINCOME1=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)

	UPDATE #OP_UST SET MID = (CUSTOM*(@ARQ1/100)),
	ULTRASHORT=(ALTRA*(@FIXEDINCOME1/100)),
	EQUITYPER=((CUSTOM*(@ARQ1/100))/Custom)*100,DEBTPER=((ALTRA*(@FIXEDINCOME1/100)) /Custom)*100,
	EQUITY=(CUSTOM*(@ARQ1/100)),DEBT=(ALTRA*(@FIXEDINCOME1/100)) ,
	TOTALINVEST=(CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)),
	AFTERREBALTOTAL=(CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)),
	AFTERREBALRATIO=(((CUSTOM*(@ARQ1/100)))/((CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100))))*100.00,
	PEEK =(CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)),
	DIFF =((CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)))-((CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100))),
	DROWDOWN=( ((CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)))/ ((CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100))) -1  )*100,
	DAILYCHANGE=0,
	ADJUSTED=0,
	BSEPEEK=BSE100,
	BSEDIFF=0,
	BSEDROWDOWN=(BSE100/BSE100-1)*100,
	BSEDAILYCHANGE=0,
	BSEADJUSTED=0
    WHERE ID =1


	SELECT @STARTDATE=TRADE_DATE,
	@MINAFTERREBALTOTAL=(CUSTOM*(@ARQ1/100))+(ALTRA*(@FIXEDINCOME1/100)),
	@MINBSETOTAL=BSE100
	FROM #OP_UST
	WHERE ID =1



DECLARE @MAX INT =0
DECLARE @CNT INT =2


SELECT @MAX = MAX(ID) FROM  #OP_UST WHERE TRADE_DATE IS NOT NULL

WHILE (@CNT<=@MAX)
BEGIN


DECLARE @PREULTRASHORT AS float=0.0
DECLARE @PREVMID AS float=0.0
DECLARE @PREVEQUITY AS float=0.0
DECLARE @PREVDEBT AS float=0.0
DECLARE @PREVCUSTOM AS float=0.0
DECLARE @PREEQUITYPER AS float=0.0
DECLARE @PREDEBTPERPER AS float=0.0
DECLARE @PREALTRA AS float=0.0
DECLARE @PREEPEEK AS float=0.0
DECLARE @PREEAFTERREBALTOTAL AS float=0.0
DECLARE @PRETRADE_DATE AS DATE=NULL
DECLARE @PREBSEPEEK AS float=0.0
DECLARE @PREBSE100 AS float=0.0

DECLARE @CURRMID AS float=0.0
DECLARE @CURREQUITY AS float=0.0
DECLARE @CURRDEBT AS float=0.0
DECLARE @CURRCUSTOM AS float=0.0
DECLARE @CURREQUITYPER AS float=0.0
DECLARE @CURRDEBTPERPER AS float=0.0
DECLARE @CURRALTRA AS float=0.0
DECLARE @CURRBSE100 float=0.0
DECLARE @CURRTRADE_DATE AS DATE=NULL
DECLARE @ARQ float=0.0
DECLARE @FIXEDINCOME float=0.0

--commented by sandeep as suggested by jay thakker on 23 aug 2017
--SELECT @ARQ=ARQ+20,@FIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)
SELECT @ARQ=ARQ+10,@FIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)

            -----GET PREVIOUS RECORD
			SELECT @PREVEQUITY=EQUITY,
			@PREVCUSTOM=CUSTOM,
			@PREVDEBT=DEBT,
			@PREVMID=MID,
			@PREEQUITYPER=((EQUITY/(EQUITY+DEBT))*100) ,
			@PREDEBTPERPER= ((DEBT/(EQUITY+DEBT))*100),
			@PRETRADE_DATE=TRADE_DATE,
			@PREULTRASHORT=ULTRASHORT,
			@PREALTRA=ALTRA ,
			@PREEPEEK=PEEK,
			@PREEAFTERREBALTOTAL=AFTERREBALTOTAL,
			@PREBSEPEEK=BSEPEEK,
			@PREBSE100 =BSE100
			FROM #OP_UST WHERE ID =@CNT-1

			-----GET CURRENT RECORD
			SELECT @CURREQUITY=(@PREVMID*CUSTOM)/@PREVCUSTOM,
			@CURRCUSTOM=CUSTOM,
			@CURRDEBT=(@PREULTRASHORT*ALTRA)/@PREALTRA ,
			@CURREQUITYPER=((((@PREVMID*CUSTOM)/@PREVCUSTOM)/(((@PREVMID*CUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*ALTRA)/@PREALTRA) ))*100) ,
			@CURRDEBTPERPER= (((@PREULTRASHORT*ALTRA)/@PREALTRA)/(((@PREVMID*CUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*ALTRA)/@PREALTRA)))*100,
			@CURRTRADE_DATE=TRADE_DATE,
			@CURRALTRA=ALTRA,
			@CURRBSE100=BSE100  
			FROM #OP_UST WHERE ID =@CNT



IF (@CURREQUITYPER>=@ARQ)
BEGIN

-----GET LAST TRAD DATE WHOSE REBALANCE DONE

DECLARE @LASTREBALNCEDATE AS DATE =NULL

SELECT @LASTREBALNCEDATE = MAX (TRADE_DATE) FROM #OP_UST WHERE ID < @CNT AND ISREBALANCE=1

		IF(@LASTREBALNCEDATE IS NOT NULL)
		BEGIN

		DECLARE @DIFF AS INT =0

		SET @DIFF=DATEDIFF (DD ,@LASTREBALNCEDATE,@CURRTRADE_DATE)

			IF(@DIFF>=30)
			BEGIN
			

			----REBALANCE AGAIN
				SELECT @ARQ=ARQ,@FIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)



					UPDATE #OP_UST
					SET
					EQUITYCHNG=@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00),
					DEBTCHNG=(@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265),
					MID =(@CURREQUITY+@CURRDEBT)*(@ARQ/100),
					EQUITY=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
					DEBT =(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
					--ULTRASHORT=(@CURREQUITY+@CURRDEBT)*(@ARQ/100) * (1-0.002265)+@PREULTRASHORT, 
					ULTRASHORT= @CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)), 
					EQUITYPER=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
					DEBTPER=(((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
					ISREBALANCE=1,
					TOTALINVEST=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
					AFTERREBALTOTAL=((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))),
					AFTERREBALRATIO=(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))/(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))))*100.00,
					PEEK=CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END,
					DIFF =(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))-(CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END),
					DROWDOWN=( (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/ (CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END) -1  )*100,
					DAILYCHANGE=((((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/@PREEAFTERREBALTOTAL -1)*100,
					ADJUSTED=(((((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/@PREEAFTERREBALTOTAL -1)*100)-(@SHARPRATIO*100),

					BSEPEEK=CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END  ,
					BSEDIFF=@CURRBSE100 - (CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END),
					BSEDROWDOWN=(@CURRBSE100/(CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END)-1)*100,
					BSEDAILYCHANGE=(@CURRBSE100/@PREBSE100-1)*100,
					BSEADJUSTED=((@CURRBSE100/@PREBSE100-1)*100)-(@SHARPRATIO*100)
					WHERE ID=@CNT

			END

			ELSE
			BEGIN

			

			UPDATE #OP_UST
			SET EQUITY=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
			MID=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
			DEBT =(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
			ULTRASHORT=(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
			EQUITYPER=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
            DEBTPER=(((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
			TOTALINVEST=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
			AFTERREBALTOTAL=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
			AFTERREBALRATIO=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100.00,
			PEEK=CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ,
			DIFF =(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))-(CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ),
			DROWDOWN=( (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))/ (CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ) -1  )*100,
			DAILYCHANGE=(( ((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA) )/@PREEAFTERREBALTOTAL -1 )*100,
			ADJUSTED=((( ((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA) )/@PREEAFTERREBALTOTAL -1 )*100)-(@SHARPRATIO*100.00),

			BSEPEEK=CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END  ,
			BSEDIFF=@CURRBSE100 - (CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END),
			BSEDROWDOWN=(@CURRBSE100/(CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END)-1)*100,
			BSEDAILYCHANGE=(@CURRBSE100/@PREBSE100-1)*100,
			BSEADJUSTED=((@CURRBSE100/@PREBSE100-1)*100)-(@SHARPRATIO*100)
			WHERE ID=@CNT

			END

		END
		ELSE
		BEGIN

		---1ST TIME REBALANCE
		

		SELECT @ARQ=ARQ,@FIXEDINCOME=FIXEDINCOME FROM DBO.FUNC_CUSTARQ_DEBTRATIO(@CLEINT_CODE)

		UPDATE #OP_UST
		SET
		EQUITYCHNG=@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00),
		DEBTCHNG=(@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265),
		MID =(@CURREQUITY+@CURRDEBT)*(@ARQ/100),
		EQUITY=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
		DEBT =(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
		--ULTRASHORT=(@CURREQUITY+@CURRDEBT)*(@ARQ/100) * (1-0.002265)+@PREULTRASHORT, 
		ULTRASHORT= @CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)), 
		EQUITYPER=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
        DEBTPER=(((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
		ISREBALANCE=1,
		TOTALINVEST=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
		AFTERREBALTOTAL=((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))),
		AFTERREBALRATIO=(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))/(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))))*100.00,
		PEEK=CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END,
		DIFF =(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))-(CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END),
		DROWDOWN=( (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/ (CASE WHEN (@PREEPEEK >(((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))) THEN @PREEPEEK ELSE (((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265)))) END) -1  )*100,
		DAILYCHANGE=((((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/@PREEAFTERREBALTOTAL -1)*100,
		ADJUSTED=(((((@CURREQUITY+@CURRDEBT)*(@ARQ/100))+(@CURRDEBT +((@CURREQUITY-(@CURREQUITY+@CURRDEBT)*(@ARQ/100.00))*(1-0.002265))))/@PREEAFTERREBALTOTAL -1)*100)-(@SHARPRATIO*100),

		BSEPEEK=CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END  ,
		BSEDIFF=@CURRBSE100 - (CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END),
		BSEDROWDOWN=(@CURRBSE100/(CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END)-1)*100,
		BSEDAILYCHANGE=(@CURRBSE100/@PREBSE100-1)*100,
		BSEADJUSTED=((@CURRBSE100/@PREBSE100-1)*100)-(@SHARPRATIO*100)

		WHERE ID=@CNT

		END

END

ELSE
BEGIN

	

        UPDATE #OP_UST
		SET EQUITY=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
		MID=(@PREVMID*@CURRCUSTOM)/@PREVCUSTOM,
		DEBT =(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
		ULTRASHORT=(@PREULTRASHORT*@CURRALTRA)/@PREALTRA,
		EQUITYPER=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
        DEBTPER=(((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100,
		TOTALINVEST=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
		AFTERREBALTOTAL=((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA),
		AFTERREBALRATIO=(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)/(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)))*100.00,
		PEEK=CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ,
		DIFF =(((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))-(CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ),
		DROWDOWN=( (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))/ (CASE WHEN (@PREEPEEK > (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA))) THEN @PREEPEEK ELSE (((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA)) END ) -1  )*100,
		DAILYCHANGE=(( ((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA) )/@PREEAFTERREBALTOTAL -1 )*100,
		ADJUSTED=((( ((@PREVMID*@CURRCUSTOM)/@PREVCUSTOM)+((@PREULTRASHORT*@CURRALTRA)/@PREALTRA) )/@PREEAFTERREBALTOTAL -1 )*100)-(@SHARPRATIO*100.00),

		BSEPEEK=CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END  ,
		BSEDIFF=@CURRBSE100 - (CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END),
		BSEDROWDOWN=(@CURRBSE100/(CASE WHEN (@PREBSEPEEK > @CURRBSE100) THEN @PREBSEPEEK ELSE @CURRBSE100 END)-1)*100,
		BSEDAILYCHANGE=(@CURRBSE100/@PREBSE100-1)*100,
		BSEADJUSTED=((@CURRBSE100/@PREBSE100-1)*100)-(@SHARPRATIO*100)

		WHERE ID=@CNT
		

END



SET @CNT=@CNT+1
END


--SELECT * FROM #OP_UST

SELECT @ENDDATE=MAX(TRADE_DATE)  FROM #OP_UST

SELECT @MAXAFTERREBALTOTAL =AFTERREBALTOTAL,@MAXBSETOTAL=BSE100 FROM  #OP_UST WHERE TRADE_DATE=@ENDDATE



--DECLARE @STARTVALUE AS float=100000.00000000

--DECLARE @ENDVALUE AS float=398711.97883500

--DECLARE @STARTDATE AS DATE ='2009-02-15'

--DECLARE @ENDDATE AS DATE='2016-10-28'

DECLARE @MONTHNO AS  float =DATEDIFF(DD,@STARTDATE,DATEADD(DD,1,@ENDDATE))/365.00

--select @MONTHNO/365


DECLARE @EQDROWDOWN AS float=0.0
DECLARE @EQCAGR AS float=0.0
DECLARE @EQAVG AS float=0.0
DECLARE @EQSTDDEV AS float=0.0
DECLARE @EQSQRT AS float=0.0
DECLARE @EQSHARPRATIO AS float=0.0

DECLARE @BSEDROWDOWN AS float=0.0
DECLARE @BSECAGR AS float=0.0

DECLARE @BSEAVG AS float=0.0
DECLARE @BSESTDDEV AS float=0.0
DECLARE @BSESQRT AS float=0.0
DECLARE @BSESHARPRATIO AS float=0.0




SELECT @EQDROWDOWN= MIN( DROWDOWN) , @EQCAGR= (POWER((@MAXAFTERREBALTOTAL/@MINAFTERREBALTOTAL),(1.0/@MONTHNO))-1.0)*100 ,@EQAVG=AVG (ADJUSTED ),@EQSTDDEV=STDEV (ADJUSTED),
 @BSEDROWDOWN=MIN (BSEDROWDOWN)  ,@BSECAGR=(POWER((@MAXBSETOTAL /@MINBSETOTAL ),(1.0/@MONTHNO))-1.0)*100 ,@BSEAVG=AVG(BSEADJUSTED),@BSESTDDEV=STDEV (BSEADJUSTED)

FROM #OP_UST

INSERT INTO #TBL_GRAPHDATA
SELECT *,@STATERGY  FROM #OP_UST

INSERT INTO #TBLSTATERGY
SELECT @EQDROWDOWN AS EQDROWDOWN ,@EQCAGR AS EQCAGR,(@EQCAGR/@EQDROWDOWN) AS 'EQCARMAX',@EQAVG AS EQAVG,@EQSTDDEV AS EQSTDDEV,@EQAVG*SQRT (248)/100 AS EQSQRT,((@EQAVG*SQRT (248)/100)/@EQSTDDEV)*100 AS EQSHARPRATIO,
@BSEDROWDOWN AS BSEDROWDOWN,@BSECAGR AS BSECAGR,(@BSECAGR/@BSEDROWDOWN) AS 'BSECARMAX',@BSEAVG AS BSEAVG,@BSESTDDEV AS BSESTDDEV,@BSEAVG*SQRT (248)/100 AS BSESQRT,((@BSEAVG*SQRT (248)/100)/@BSESTDDEV)*100 AS BSESHARPRATIO,@STATERGY




END

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
-- PROCEDURE dbo.usp_get_ClientDP
-- --------------------------------------------------
CREATE procedure [dbo].[usp_get_ClientDP]
(
		@PROCESS varchar(100)
		,@FILTER1 varchar(100)
)
as
begin


		IF(@PROCESS='GET DPID')
		BEGIN
		SELECT client_code as DPID from [AngelDP4].inhouse.dbo.tbl_client_master with(nolock) where [status] = 'active' and nise_party_code=@FILTER1 
		and left(client_Code,8)='12033200'		
		
		END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPART_GOOGLEPUSH
-- --------------------------------------------------
--exec USP_IPART_GOOGLEPUSH 'fS-KXefx00U:APA91bGtHhZ6TRLCtDxTYq-mnP7-5POi08MinOFBJ4sWiysxO_2W60WFaYPnIm-3nM5Qa7Pc0YAH0MPBLi9aCYJQKYyTgNr7HKaibvbvPZoTW6np6jbayNjzlV25YrZBi8mCKXNsCtav','','8097479830'
CREATE proc [dbo].[USP_IPART_GOOGLEPUSH]

@ID AS VARCHAR(MAX)='',@TITLE AS VARCHAR(200)='',@BODYMSG AS VARCHAR(500)=''
 
 AS BEGIN


 DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);
DECLARE @Body AS VARCHAR(8000) = 
'{
  "to" : "'+@ID+'",
   "data" : {
     "object" : {
     	"notificationType":"1",          
        "title" : "Angel Inhouse",                
        "message":"'+@BODYMSG+'", 
        "imageUrl":""
		 }
   } 
}'  

EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'post','https://fcm.googleapis.com/fcm/send', 'false'

EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Authorization', 'key=AAAAGh6QAmE:APA91bFCsBGjImmfrTQ0Vb_oeO99sAev1qVW7rEJGXIScEAN8vIlYroWNfQrX44-CndZmeR2WKcX8IyY6YFef6eDi0OPVdbq1dnP5kQyhhTUpy9JVc9UVlbTyU1J5mMquCjdqwY5RkBJ'
EXEC sp_OAMethod @Object, 'send', null, @body

EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT


EXEC sp_OADestroy @Object

 select @ResponseText

 END

GO

-- --------------------------------------------------
-- TABLE dbo.12Stock
-- --------------------------------------------------
CREATE TABLE [dbo].[12Stock]
(
    [ID] FLOAT NULL,
    [PROFILESID] FLOAT NULL,
    [FUNDID] NVARCHAR(255) NULL,
    [SCOREID] FLOAT NULL,
    [MODE] NVARCHAR(255) NULL,
    [MODEID] FLOAT NULL,
    [ARQPERCENTAGE] FLOAT NULL,
    [CALCOPTION] NVARCHAR(255) NULL,
    [CREATEDBY] NVARCHAR(255) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] NVARCHAR(255) NULL,
    [UPDATEDDT] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.3Stock
-- --------------------------------------------------
CREATE TABLE [dbo].[3Stock]
(
    [ID] FLOAT NULL,
    [PROFILESID] FLOAT NULL,
    [FUNDID] NVARCHAR(255) NULL,
    [SCOREID] FLOAT NULL,
    [MODE] NVARCHAR(255) NULL,
    [MODEID] FLOAT NULL,
    [ARQPERCENTAGE] FLOAT NULL,
    [CALCOPTION] NVARCHAR(255) NULL,
    [CREATEDBY] NVARCHAR(255) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] NVARCHAR(255) NULL,
    [UPDATEDDT] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CustARQRawNav
-- --------------------------------------------------
CREATE TABLE [dbo].[CustARQRawNav]
(
    [Date] DATETIME NULL,
    [Fundamental] FLOAT NULL,
    [Mid Portfolio] FLOAT NULL,
    [Mid] FLOAT NULL,
    [Value] FLOAT NULL,
    [Quality] FLOAT NULL,
    [Stable] FLOAT NULL,
    [Largecap] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_12STOCK_PROFILE_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_12STOCK_PROFILE_DATA]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_12STOCK_PROFILE_DATA_15Feb2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_12STOCK_PROFILE_DATA_15Feb2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_12STOCK_PROFILE_DATA_23Aug2017_NIGHT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_12STOCK_PROFILE_DATA_23Aug2017_NIGHT]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_12STOCK_PROFILE_DATA_27032018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_12STOCK_PROFILE_DATA_27032018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_3STOCK_PROFILE_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_3STOCK_PROFILE_DATA]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] INT NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_3STOCK_PROFILE_DATA_15Feb2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_3STOCK_PROFILE_DATA_15Feb2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] INT NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_3STOCK_PROFILE_DATA_23Aug2017_NIGHT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_3STOCK_PROFILE_DATA_23Aug2017_NIGHT]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [MODEID] INT NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_ANS_MST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_ANS_MST]
(
    [RPA_iID] INT NOT NULL,
    [RPA_iRPQID] INT NOT NULL,
    [RPA_iAnsNo] INT NOT NULL,
    [RPA_tAns] VARCHAR(500) NULL,
    [RPA_tMobAns] VARCHAR(100) NULL,
    [RPA_tStatus] CHAR(1) NOT NULL,
    [RPA_dValidFrom] DATETIME NOT NULL,
    [RPA_dValidTo] DATETIME NOT NULL,
    [RPA_dScore] VARCHAR(10) NULL,
    [RPA_dCreatedOn] DATETIME NOT NULL,
    [RPA_dCreatedBy] VARCHAR(100) NOT NULL,
    [RPA_dUpdatedOn] DATETIME NOT NULL,
    [RPA_dUpdatedBy] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_CLIENT_MODE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_CLIENT_MODE]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [RECID] VARCHAR(50) NULL,
    [UPDATE_DATE] DATETIME NULL,
    [ISDIRECT] INT NULL,
    [DIVICEID] VARCHAR(50) NULL,
    [INSERT_BY] VARCHAR(50) NULL,
    [INSERT_DATE] DATETIME NULL,
    [UPDATE_BY] VARCHAR(50) NULL,
    [AMT_TO_INVEST] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_CLIENT_MODE_08102018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_CLIENT_MODE_08102018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENT_CODE] VARCHAR(50) NULL,
    [RECID] VARCHAR(50) NULL,
    [UPDATE_DATE] DATETIME NULL,
    [ISDIRECT] INT NULL,
    [DIVICEID] VARCHAR(50) NULL,
    [INSERT_BY] VARCHAR(50) NULL,
    [INSERT_DATE] DATETIME NULL,
    [UPDATE_BY] VARCHAR(50) NULL,
    [AMT_TO_INVEST] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_CLIENT_RISKDETAILS_NOT_IN_USE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_CLIENT_RISKDETAILS_NOT_IN_USE]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(50) NULL,
    [RPA_AGEID] INT NULL,
    [RPA_AGEDESC] VARCHAR(50) NULL,
    [RPA_AGESCORE] INT NULL,
    [RPA_CURRENTSTATUSID] INT NULL,
    [RPA_CURRENTSTATUSDESC] VARCHAR(50) NULL,
    [RPA_CURRENTSTATUSSCORE] INT NULL,
    [RPA_SINVESTID] INT NULL,
    [RPA_SINVESTDESC] VARCHAR(50) NULL,
    [RPA_SINVESTSCORE] INT NULL,
    [RPA_EXPERIENCEID] INT NULL,
    [RPA_EXPERIENCEDESC] VARCHAR(50) NULL,
    [RPA_EXPERIENCESCORE] INT NULL,
    [RPA_SAVINGMONEYID] INT NULL,
    [RPA_SAVINGMONEYDESC] VARCHAR(50) NULL,
    [RPA_SAVINGMONEYSCORE] INT NULL,
    [RPA_INVESTMONEYID] INT NULL,
    [RPA_INVESTMONEYDESC] VARCHAR(50) NULL,
    [RPA_INVESTMONEYSCORE] INT NULL,
    [RPA_PORTFOLIOID] INT NULL,
    [RPA_PORTFOLIOIDDESC] VARCHAR(50) NULL,
    [RPA_PORTFOLIOIDSCORE] INT NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_CLIENT_RISKPROFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_CLIENT_RISKPROFILE]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENTCODE] VARCHAR(50) NULL,
    [QNANS] VARCHAR(150) NULL,
    [PROFILENUM] INT NULL,
    [INSERT_BY] VARCHAR(50) NULL,
    [INSERT_DATE] DATETIME NULL,
    [UPDATE_DATE] DATETIME NULL,
    [UPDATE_BY] VARCHAR(50) NULL,
    [DIVICEID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_DEBTRATIO
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_DEBTRATIO]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ARQ] INT NULL,
    [FIXEDINCOME] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_DEBTRATIO_CLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_DEBTRATIO_CLIENT]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENTCODE] VARCHAR(50) NULL,
    [ARQ] DECIMAL(18, 2) NULL,
    [FIXEDINCOME] DECIMAL(18, 2) NULL,
    [INSERT_BY] VARCHAR(50) NULL,
    [INSERT_DATE] DATETIME NULL,
    [UPDATE_DATE] DATETIME NULL,
    [UPDATE_BY] VARCHAR(50) NULL,
    [DIVICEID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_FILEGENERATION_MST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_FILEGENERATION_MST]
(
    [Format] VARCHAR(500) NULL,
    [FileType] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_MFORDER_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_MFORDER_LOG]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENTCODE] VARCHAR(50) NULL,
    [INTERNALREFNO] VARCHAR(100) NULL,
    [MESSAGE] VARCHAR(300) NULL,
    [STATUS] VARCHAR(100) NULL,
    [SCHEMECODE] VARCHAR(100) NULL,
    [INPUT] VARCHAR(MAX) NULL,
    [ADDEDBY] VARCHAR(100) NULL,
    [ADDEDON] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_MODEMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_MODEMASTER]
(
    [RecID] INT IDENTITY(1,1) NOT NULL,
    [ModeId] VARCHAR(50) NULL,
    [ModeDesc] VARCHAR(50) NULL,
    [CustomModeID] VARCHAR(50) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [UpdatedDT] DATETIME NULL,
    [INVEST_RS] DECIMAL(38, 8) NULL,
    [CAGR] VARCHAR(30) NULL,
    [DRAWDOWN] VARCHAR(30) NULL,
    [SHARPRATIO] VARCHAR(30) NULL,
    [VOLATILITY] VARCHAR(30) NULL,
    [NO_STOCK] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_QUESTION_MST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_QUESTION_MST]
(
    [RPQ_iID] INT NOT NULL,
    [RPQ_QHeaderNo] INT NOT NULL,
    [RPQ_QHeader] VARCHAR(200) NOT NULL,
    [RPQ_iQuestionNo] INT NOT NULL,
    [RPQ_tQuestion] VARCHAR(8000) NOT NULL,
    [RPQ_tMobQuestion] VARCHAR(8000) NOT NULL,
    [RPQ_tStatus] CHAR(1) NOT NULL,
    [RPQ_dValidFrom] DATETIME NOT NULL,
    [RPQ_dValidTo] DATETIME NOT NULL,
    [RPQ_dCreated_On] DATETIME NOT NULL,
    [RPQ_iCreated_By] VARCHAR(100) NOT NULL,
    [RPQ_dUpdatedOn] DATETIME NOT NULL,
    [RPQ_iUpdated_By] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_RAWNAV
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_RAWNAV]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [TRADE_DATE] DATE NULL,
    [FUNDAMENTAL_WINNERS] FLOAT NULL,
    [MID_CAP_PORTFOLIO] FLOAT NULL,
    [MID_CAP_STOCKS] FLOAT NULL,
    [VALUE_STOCKS] FLOAT NULL,
    [QUALITY_STOCKS] FLOAT NULL,
    [STABLE_STOCK_PORTFOLIO] FLOAT NULL,
    [LARGE_CAP_STOCKS] FLOAT NULL,
    [INCOME_AVERAGE] FLOAT NULL,
    [ULTRA_SHORT_TERM_AVERAGE] FLOAT NULL,
    [INCOME] FLOAT NULL,
    [ALTRA] FLOAT NULL,
    [UPLOAD_DATE] DATETIME NULL,
    [BSE100] FLOAT NULL,
    [BSE100VALUE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_RAWNAV_04Apr2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_RAWNAV_04Apr2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [TRADE_DATE] DATE NULL,
    [FUNDAMENTAL_WINNERS] FLOAT NULL,
    [MID_CAP_PORTFOLIO] FLOAT NULL,
    [MID_CAP_STOCKS] FLOAT NULL,
    [VALUE_STOCKS] FLOAT NULL,
    [QUALITY_STOCKS] FLOAT NULL,
    [STABLE_STOCK_PORTFOLIO] FLOAT NULL,
    [LARGE_CAP_STOCKS] FLOAT NULL,
    [INCOME_AVERAGE] FLOAT NULL,
    [ULTRA_SHORT_TERM_AVERAGE] FLOAT NULL,
    [INCOME] FLOAT NULL,
    [ALTRA] FLOAT NULL,
    [UPLOAD_DATE] DATETIME NULL,
    [BSE100] FLOAT NULL,
    [BSE100VALUE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_RAWNAV_15Feb2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_RAWNAV_15Feb2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [TRADE_DATE] DATE NULL,
    [FUNDAMENTAL_WINNERS] FLOAT NULL,
    [MID_CAP_PORTFOLIO] FLOAT NULL,
    [MID_CAP_STOCKS] FLOAT NULL,
    [VALUE_STOCKS] FLOAT NULL,
    [QUALITY_STOCKS] FLOAT NULL,
    [STABLE_STOCK_PORTFOLIO] FLOAT NULL,
    [LARGE_CAP_STOCKS] FLOAT NULL,
    [INCOME_AVERAGE] FLOAT NULL,
    [ULTRA_SHORT_TERM_AVERAGE] FLOAT NULL,
    [INCOME] FLOAT NULL,
    [ALTRA] FLOAT NULL,
    [UPLOAD_DATE] DATETIME NULL,
    [BSE100] FLOAT NULL,
    [BSE100VALUE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_RAWNAV_26Mar2018
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_RAWNAV_26Mar2018]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [TRADE_DATE] DATE NULL,
    [FUNDAMENTAL_WINNERS] FLOAT NULL,
    [MID_CAP_PORTFOLIO] FLOAT NULL,
    [MID_CAP_STOCKS] FLOAT NULL,
    [VALUE_STOCKS] FLOAT NULL,
    [QUALITY_STOCKS] FLOAT NULL,
    [STABLE_STOCK_PORTFOLIO] FLOAT NULL,
    [LARGE_CAP_STOCKS] FLOAT NULL,
    [INCOME_AVERAGE] FLOAT NULL,
    [ULTRA_SHORT_TERM_AVERAGE] FLOAT NULL,
    [INCOME] FLOAT NULL,
    [ALTRA] FLOAT NULL,
    [UPLOAD_DATE] DATETIME NULL,
    [BSE100] FLOAT NULL,
    [BSE100VALUE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_RAWNAV_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_RAWNAV_temp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [TRADE_DATE] DATE NULL,
    [FUNDAMENTAL_WINNERS] FLOAT NULL,
    [MID_CAP_PORTFOLIO] FLOAT NULL,
    [MID_CAP_STOCKS] FLOAT NULL,
    [VALUE_STOCKS] FLOAT NULL,
    [QUALITY_STOCKS] FLOAT NULL,
    [STABLE_STOCK_PORTFOLIO] FLOAT NULL,
    [LARGE_CAP_STOCKS] FLOAT NULL,
    [INCOME_AVERAGE] FLOAT NULL,
    [ULTRA_SHORT_TERM_AVERAGE] FLOAT NULL,
    [INCOME] FLOAT NULL,
    [ALTRA] FLOAT NULL,
    [UPLOAD_DATE] DATETIME NULL,
    [BSE100] FLOAT NULL,
    [BSE100VALUE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CUSTARQ_UPDATELIMIT_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CUSTARQ_UPDATELIMIT_LOG]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [CLIENTCODE] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [MESSAGE] VARCHAR(300) NULL,
    [STATUS] VARCHAR(100) NULL,
    [IPOAmount] MONEY NULL,
    [MFAmount] MONEY NULL,
    [TradingAmount] MONEY NULL,
    [MFTransactionNO] VARCHAR(100) NULL,
    [ADDEDBY] VARCHAR(100) NULL,
    [ADDEDON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFDEBTAPILOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFDEBTAPILOG]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [INTERNALREFNO] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(50) NULL,
    [REQUESTDATA] VARCHAR(8000) NULL,
    [RESPONSEDATA] VARCHAR(8000) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_Other_1
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_Other_1]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_Other_2
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_Other_2]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_Other_3
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_Other_3]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROFILE_1
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROFILE_1]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROFILE_2
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROFILE_2]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROFILE_3
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROFILE_3]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROFILE_4
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROFILE_4]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROFILE_5
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROFILE_5]
(
    [RECID] INT IDENTITY(1,1) NOT NULL,
    [PROFILESID] INT NULL,
    [FUNDID] VARCHAR(50) NULL,
    [SCOREID] INT NULL,
    [MODE] VARCHAR(50) NULL,
    [ARQPERCENTAGE] VARCHAR(50) NULL,
    [CALCOPTION] VARCHAR(50) NULL,
    [CREATEDBY] VARCHAR(50) NULL,
    [CREATEDDT] DATETIME NULL,
    [UPDATEDBY] VARCHAR(50) NULL,
    [UPDATEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempRawNav
-- --------------------------------------------------
CREATE TABLE [dbo].[TempRawNav]
(
    [Date] DATETIME NULL,
    [MultiCap] FLOAT NULL,
    [MidCap] FLOAT NULL,
    [LargeCap] FLOAT NULL,
    [Custom] FLOAT NULL,
    [F6] NVARCHAR(255) NULL,
    [Income] FLOAT NULL,
    [Ultra Short Term] FLOAT NULL,
    [F9] NVARCHAR(255) NULL,
    [Income Average] FLOAT NULL,
    [Ultra Short Term Average] FLOAT NULL,
    [F12] NVARCHAR(255) NULL,
    [F13] NVARCHAR(255) NULL,
    [BSE100] FLOAT NULL,
    [BSE1001] FLOAT NULL,
    [Date1] DATETIME NULL,
    [BSE 100 Values] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xyz_test_log_ship
-- --------------------------------------------------
CREATE TABLE [dbo].[xyz_test_log_ship]
(
    [col1] INT NULL
);

GO

