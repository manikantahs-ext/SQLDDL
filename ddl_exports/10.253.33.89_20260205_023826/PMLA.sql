-- DDL Export
-- Server: 10.253.33.89
-- Database: PMLA
-- Exported: 2026-02-05T02:39:13.339867

USE PMLA;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_str_Client_Master
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_str_Client_Master] ADD CONSTRAINT [FK_Batchid] FOREIGN KEY ([BatchId]) REFERENCES [dbo].[tbl_Str_Master] ([Id])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_str_Client_Master
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_str_Client_Master] ADD CONSTRAINT [FK_category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[tbl_Str_Category] ([Id])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_str_clientid
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_str_clientid] ADD CONSTRAINT [FK__tbl_str_c__StrId__725BF7F6] FOREIGN KEY ([StrId]) REFERENCES [dbo].[tbl_Str_RENAMEDAS_PII] ([Id])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_Str_RENAMEDAS_PII
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Str_RENAMEDAS_PII] ADD CONSTRAINT [FK__tbl_Str__Categor__04AFB25B] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[tbl_Str_Category] ([Id])

GO

-- --------------------------------------------------
-- FUNCTION dbo.BreakStringIntoRows
-- --------------------------------------------------
CREATE FUNCTION dbo.BreakStringIntoRows (@CommadelimitedString   varchar(1000))
RETURNS   @Result TABLE (Column1   VARCHAR(100))
AS
BEGIN
        DECLARE @IntLocation INT
        WHILE (CHARINDEX(',',    @CommadelimitedString, 0) > 0)
        BEGIN
              SET @IntLocation =   CHARINDEX(',',    @CommadelimitedString, 0)      
              INSERT INTO   @Result (Column1)
              --LTRIM and RTRIM to ensure blank spaces are   removed
              SELECT RTRIM(LTRIM(SUBSTRING(@CommadelimitedString,   0, @IntLocation)))   
              SET @CommadelimitedString = STUFF(@CommadelimitedString,   1, @IntLocation,   '') 
        END
        INSERT INTO   @Result (Column1)
        SELECT RTRIM(LTRIM(@CommadelimitedString))--LTRIM and RTRIM to ensure blank spaces are removed
        RETURN 
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.Fun_GetOrderStatusName
-- --------------------------------------------------

CREATE FUNCTION [dbo].[Fun_GetOrderStatusName]    
(    
    @SoS varchar(5)    
)    
RETURNS varchar(100) -- or whatever length you need    
AS    
BEGIN    
    
RETURN (SELECT     
CASE @SoS    
WHEN 'P' THEN 'Pending'    
WHEN 'IP' THEN 'InProcess'    
WHEN 'E' THEN 'Executed'    
WHEN 'T' THEN 'Send to RTA'    
WHEN 'R' THEN 'Rejected'    
WHEN 'C' THEN 'Cancelled'    
WHEN 'S' THEN 'Success'    
ELSE 'Other'    
END)    
       
    
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.InitCap
-- --------------------------------------------------

  
CREATE FUNCTION [dbo].[InitCap] ( @InputString varchar(4000) )   
RETURNS VARCHAR(4000)  
AS  
BEGIN  
  
DECLARE @Index          INT  
DECLARE @Char           CHAR(1)  
DECLARE @PrevChar       CHAR(1)  
DECLARE @OutputString   VARCHAR(255)  
  
SET @OutputString = LOWER(@InputString)  
SET @Index = 1  
  
WHILE @Index <= LEN(@InputString)  
BEGIN  
    SET @Char     = SUBSTRING(@InputString, @Index, 1)  
    SET @PrevChar = CASE WHEN @Index = 1 THEN ' '  
                         ELSE SUBSTRING(@InputString, @Index - 1, 1)  
                    END  
  
    IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')  
    BEGIN  
        IF @PrevChar != '''' OR UPPER(@Char) != 'S'  
            SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))  
    END  
  
    SET @Index = @Index + 1  
END  
  
RETURN @OutputString  
  
END

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_client_master
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_tbl_client_master] ON [dbo].[tbl_client_master] ([client_code], [NISE_PARTY_CODE], [template_code])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_client_master
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_tbl_client_master_NISE_PARTY_CODE] ON [dbo].[tbl_client_master] ([NISE_PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_client_master_Prev
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_tbl_client_master_Prev] ON [dbo].[tbl_client_master_Prev] ([client_code], [NISE_PARTY_CODE], [template_code])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_client_master_Prev
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_tbl_client_master_Prev_NISE_PARTY_CODE] ON [dbo].[tbl_client_master_Prev] ([NISE_PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_CLIENT_POA
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_Tbl_CLIENT_POA] ON [dbo].[Tbl_CLIENT_POA] ([CLIENT_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_CLIENT_POA_Prev
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_Tbl_CLIENT_POA_Prev] ON [dbo].[Tbl_CLIENT_POA_Prev] ([CLIENT_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Str_Category
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Str_Category] ADD CONSTRAINT [PK__tbl_Str___3214EC072FCF1A8A] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_str_Client_Master
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_str_Client_Master] ADD CONSTRAINT [PK__tbl_str___3214EC07740F363E] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_str_clientid
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_str_clientid] ADD CONSTRAINT [PK__tbl_str___3214EC077073AF84] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Str_Master
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Str_Master] ADD CONSTRAINT [PK__tbl_Str___3214EC073429BB53] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Str_RENAMEDAS_PII
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Str_RENAMEDAS_PII] ADD CONSTRAINT [PK__tbl_Str__3214EC0702C769E9] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insertSTRDataDump
-- --------------------------------------------------

CREATE PROC insertSTRDataDump
AS
BEGIN

DECLARE @tblrowcount AS INT,@temprowcount AS INT,@singlerowcountinner AS INT
DECLARE @singlerowcount AS INT,@batchid As INT, @companyname AS VARCHAR(MAX), @category VARCHAR(MAX), @clientcode VARCHAR(MAX),
@strdate VARCHAR(100), @groundofsus As VARCHAR(MAX)

SELECT @tblrowcount  = MAX([batch no#])
FROM TEMPSTRONE
SELECT @singlerowcount = MIN([batch no#])
FROM TEMPSTRONE
SET @singlerowcountinner = 1
WHILE (@singlerowcount <= @tblrowcount)
BEGIN

	SELECT @batchid = [batch no#], @companyname = company, @category = category, 
	@strdate = [date],@groundofsus = [ground of suspicion], @clientcode = [data with comma]
	FROM TEMPSTRONE where [batch no#] = @singlerowcount
	select row_number() over( order by (select 0)) as 'srno',[column1] into #temp 
	from dbo.BreakStringIntoRows(@clientcode) 
	where NULLIF([column1],'') IS NOT NULL
	
	SELECT @temprowcount = count(1) FROM #temp 
	
	SET @singlerowcountinner = 1
	
	WHILE (@singlerowcountinner <= @temprowcount)
	BEGIN
		INSERT INTO tblSTRMasterDataDump
		select @batchid,@companyname,@category,(select [column1] from #temp where srno = @singlerowcountinner),@strdate,@groundofsus
		SET @singlerowcountinner = @singlerowcountinner + 1
	END
	SET @singlerowcount = @singlerowcount + 1
	drop table #temp
	
END


select max(batchid)
from tblSTRMasterDataDump



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SearchAllTables
-- --------------------------------------------------


create  PROC [dbo].[SearchAllTables]
(
	@SearchStr nvarchar(100)
)
AS
BEGIN

CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				INSERT INTO #Results
				EXEC
				(
					'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
					FROM ' + @TableName + ' (NOLOCK) ' +
					' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				)
			END
		END	
	END

	SELECT ColumnName, ColumnValue FROM #Results
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Test
-- --------------------------------------------------
CREATE proc Test 

AS

select '1'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_AMD_tbl_client_master
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[Usp_AMD_tbl_client_master]  
 AS  
 BEGIN  
  SET NOCOUNT ON  
  --IF OBJECT_ID('TEMPDB..#tbl_client_master') IS NOT NULL  
  -- DROP TABLE #tbl_client_master  
  
  
  --SELECT Party_Code,FROM_DATE,MTFSTATUS  
  --INTO #tbl_client_master  
  --FROM AngelNseCM.MTFtrade.dbo.tbl_client_master  WITH(NOLOCK)  
    
  
  
  
  
  --------------------------Prev Table Insert------------------  
  
    
  TRUNCATE TABLE tbl_client_master_Prev  
  
  INSERT INTO tbl_client_master_Prev  
  (  
  client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD  
  )  
  SELECT   client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD FROM tbl_client_master WITH (NOLOCK)  
    
  DROP SYNONYM tbl_client_master_syn  
  
  CREATE SYNONYM tbl_client_master_syn for tbl_client_master_Prev  
  
  
  
  --------------------------Original Table Insert------------------  
  
  TRUNCATE TABLE tbl_client_master  
  
  INSERT INTO tbl_client_master( client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD )  
  select client_code,NISE_PARTY_CODE,template_code ,FIRST_HOLD_NAME,STATUS,EMAIL_ADD from [AngelDP4].inhouse.dbo.tbl_client_master WITH (NOLOCK)   
  
  DROP SYNONYM tbl_client_master_syn  
  
  CREATE SYNONYM tbl_client_master_syn for tbl_client_master  
  
  /*  
  ----Same table craeted on 42   
  EXEC [172.31.16.42].[IPartner].sys.sp_executesql N'Truncate table dbo.vw_Dashboard_sbrisk'  
    
  INSERT INTO [172.31.16.42].[IPartner].Dbo.vw_Dashboard_sbrisk   
  (party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date)  
  SELECT party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date  
   FROM vw_Dashboard_sbrisk  
   */  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_AMD_tbl_client_master_25jan2022
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[Usp_AMD_tbl_client_master_25jan2022]  
 AS  
 BEGIN  
  SET NOCOUNT ON  
  --IF OBJECT_ID('TEMPDB..#tbl_client_master') IS NOT NULL  
  -- DROP TABLE #tbl_client_master  
  
  
  --SELECT Party_Code,FROM_DATE,MTFSTATUS  
  --INTO #tbl_client_master  
  --FROM [196.1.115.196].MTFtrade.dbo.tbl_client_master  WITH(NOLOCK)  
    
  
  
  
  
  --------------------------Prev Table Insert------------------  
  
    
  TRUNCATE TABLE tbl_client_master_Prev  
  
  INSERT INTO tbl_client_master_Prev  
  (  
  client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD  
  )  
  SELECT   client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD FROM tbl_client_master WITH (NOLOCK)  
    
  DROP SYNONYM tbl_client_master_syn  
  
  CREATE SYNONYM tbl_client_master_syn for tbl_client_master_Prev  
  
  
  
  --------------------------Original Table Insert------------------  
  
  TRUNCATE TABLE tbl_client_master  
  
  INSERT INTO tbl_client_master( client_code,NISE_PARTY_CODE,template_code,FIRST_HOLD_NAME,STATUS,EMAIL_ADD )  
  select client_code,NISE_PARTY_CODE,template_code ,FIRST_HOLD_NAME,STATUS,EMAIL_ADD from [172.31.16.94].inhouse.dbo.tbl_client_master WITH (NOLOCK)   
  
  DROP SYNONYM tbl_client_master_syn  
  
  CREATE SYNONYM tbl_client_master_syn for tbl_client_master  
  
  /*  
  ----Same table craeted on 42   
  EXEC [172.31.16.42].[IPartner].sys.sp_executesql N'Truncate table dbo.vw_Dashboard_sbrisk'  
    
  INSERT INTO [172.31.16.42].[IPartner].Dbo.vw_Dashboard_sbrisk   
  (party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date)  
  SELECT party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date  
   FROM vw_Dashboard_sbrisk  
   */  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_AMD_Tbl_CLIENT_POA
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[Usp_AMD_Tbl_CLIENT_POA]
	AS
	BEGIN
		SET NOCOUNT ON
		--IF OBJECT_ID('TEMPDB..#Tbl_CLIENT_POA') IS NOT NULL
		--	DROP TABLE #Tbl_CLIENT_POA


		--SELECT	Party_Code,FROM_DATE,MTFSTATUS
		--INTO #Tbl_CLIENT_POA
		--FROM AngelNseCM.MTFtrade.dbo.Tbl_CLIENT_POA  WITH(NOLOCK)
		




		--------------------------Prev Table Insert------------------

		
		TRUNCATE TABLE Tbl_CLIENT_POA_Prev

		INSERT INTO Tbl_CLIENT_POA_Prev
		(
		CLIENT_CODE,HOLDER_INDI,MASTER_POA,POA_TYPE,POA_DATE_FROM,POA_STATUS
		)
		SELECT CLIENT_CODE,HOLDER_INDI,MASTER_POA,POA_TYPE,POA_DATE_FROM,POA_STATUS FROM Tbl_CLIENT_POA WITH (NOLOCK)
		
		DROP SYNONYM Tbl_CLIENT_POA_syn

		CREATE SYNONYM Tbl_CLIENT_POA_syn for Tbl_CLIENT_POA_Prev



		--------------------------Original Table Insert------------------

		TRUNCATE TABLE Tbl_CLIENT_POA

		INSERT INTO Tbl_CLIENT_POA( CLIENT_CODE,HOLDER_INDI,MASTER_POA,POA_TYPE,POA_DATE_FROM,POA_STATUS)
		select CLIENT_CODE,HOLDER_INDI,MASTER_POA,POA_TYPE,POA_DATE_FROM,POA_STATUS from [AGMUBODPL3].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) 

		DROP SYNONYM Tbl_CLIENT_POA_syn

		CREATE SYNONYM Tbl_CLIENT_POA_syn for Tbl_CLIENT_POA

		/*
		----Same table craeted on 42 
		EXEC [172.31.16.42].[IPartner].sys.sp_executesql N'Truncate table dbo.vw_Dashboard_sbrisk'
		
		INSERT INTO [172.31.16.42].[IPartner].Dbo.vw_Dashboard_sbrisk 
		(party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date)
		SELECT party_code,long_name,Reason,Risk,SUB_BROKER,Net_collection,Pure_Risk,shortage_value,squareoffvalue,square_off_type,square_off_date
		 FROM vw_Dashboard_sbrisk
		 */
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CaseAnalysisValidateUserLogin
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_CaseAnalysisValidateUserLogin]     
 @User nvarchar (1000)    
AS    
BEGIN    
  
DECLARE @iCount INT   
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES (@User + ' PMLA', getdate())    
    
  
  SELECT   
  @iCount = COUNT(0)  
 FROM     
  AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
 WHERE     
  CL_CODE = @User    
  OR PAN_GIR_NO  = @User    
  OR mobile_pager  = @User    
  OR email  = @User    
  
 IF(@iCount > 0)  
  SELECT   
   CL_CODE   
   ,short_name     
   ,PAN_GIR_NO   
  FROM     
   AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
  WHERE     
   CL_CODE = @User    
   OR PAN_GIR_NO  = @User    
   OR mobile_pager  = @User    
   OR email  = @User    
  
  ELSE   
   SELECT TOP 1   
   '' AS CL_CODE  
   , first_Hold_Name  AS Short_name   
   , ITPAN  AS PAN_GIR_NO   
   FROM [AngelDP4].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK)    
   WHERE   
   ISNULL(ITPAN,'')  = @User  
    
  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CaseAnalysisValidateUserLogin_22jan2022
-- --------------------------------------------------
--  exec usp_CaseAnalysisValidateUserLogin   '9819924434'     
--  exec usp_CaseAnalysisValidateUserLogin   '9898387500'     
--  exec usp_CaseAnalysisValidateUserLogin   'AJAY007700@GMAIL.COM'     
-- exec usp_CaseAnalysisValidateUserLogin   'ALBPB5099C'     
-- exec usp_CaseAnalysisValidateUserLogin   'rp61'     
-- exec usp_CaseAnalysisValidateUserLogin   'BMLPS9515A'     
    
  
CREATE PROCEDURE [dbo].[usp_CaseAnalysisValidateUserLogin_22jan2022]     
 @User nvarchar (1000)    
AS    
BEGIN    
  
DECLARE @iCount INT   
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES (@User + ' PMLA', getdate())    
    
  
  SELECT   
  @iCount = COUNT(0)  
 FROM     
  ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
 WHERE     
  CL_CODE = @User    
  OR PAN_GIR_NO  = @User    
  OR mobile_pager  = @User    
  OR email  = @User    
  
 IF(@iCount > 0)  
  SELECT   
   CL_CODE   
   ,short_name     
   ,PAN_GIR_NO   
  FROM     
   ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
  WHERE     
   CL_CODE = @User    
   OR PAN_GIR_NO  = @User    
   OR mobile_pager  = @User    
   OR email  = @User    
  
  ELSE   
   SELECT TOP 1   
   '' AS CL_CODE  
   , first_Hold_Name  AS Short_name   
   , ITPAN  AS PAN_GIR_NO   
   FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK)    
   WHERE   
   ISNULL(ITPAN,'')  = @User  
    
  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CaseAnalysisValidateUserLogin_25jan2022
-- --------------------------------------------------
--  exec usp_CaseAnalysisValidateUserLogin   '9819924434'     
--  exec usp_CaseAnalysisValidateUserLogin   '9898387500'     
--  exec usp_CaseAnalysisValidateUserLogin   'AJAY007700@GMAIL.COM'     
-- exec usp_CaseAnalysisValidateUserLogin   'ALBPB5099C'     
-- exec usp_CaseAnalysisValidateUserLogin   'rp61'     
-- exec usp_CaseAnalysisValidateUserLogin   'BMLPS9515A'     
    
  
CREATE PROCEDURE [dbo].[usp_CaseAnalysisValidateUserLogin_25jan2022]     
 @User nvarchar (1000)    
AS    
BEGIN    
  
DECLARE @iCount INT   
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES (@User + ' PMLA', getdate())    
    
  
  SELECT   
  @iCount = COUNT(0)  
 FROM     
  ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
 WHERE     
  CL_CODE = @User    
  OR PAN_GIR_NO  = @User    
  OR mobile_pager  = @User    
  OR email  = @User    
  
 IF(@iCount > 0)  
  SELECT   
   CL_CODE   
   ,short_name     
   ,PAN_GIR_NO   
  FROM     
   ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
  WHERE     
   CL_CODE = @User    
   OR PAN_GIR_NO  = @User    
   OR mobile_pager  = @User    
   OR email  = @User    
  
  ELSE   
   SELECT TOP 1   
   '' AS CL_CODE  
   , first_Hold_Name  AS Short_name   
   , ITPAN  AS PAN_GIR_NO   
   FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK)    
   WHERE   
   ISNULL(ITPAN,'')  = @User  
    
  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CheckCaseAnalysisExits
-- --------------------------------------------------
/*

	exec usp_CheckCaseAnalysisExits  'rp61'

*/
CREATE PROC usp_CheckCaseAnalysisExits
(
	@ClientID varchar (40)

)
AS
BEGIN 

	IF EXISTS (SELECT 0 FROM tbl_CaseAnalysis WHERE ClientID = @ClientID AND CONVERT(VARCHAR,RecordAddedon, 103)  =  CONVERT(VARCHAR,GETDATE(), 103))
	BEGIN
		SELECT 'Exists' AS CheckRecord
	END 
	ELSE 
	BEGIN
		SELECT 'Non-Exists' AS CheckRecord
	END 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CheckNBFCExit
-- --------------------------------------------------
  
/*  
 EXEC usp_CheckNBFCExit 'M709'   
   
 EXEC usp_CheckNBFCExit 'rp61'   
  
*/  
  
CREATE PROCEDURE usp_CheckNBFCExit  
(  
 @ClientCode varchar(20)  
)  
AS  
  
BEGIN  
  
DECLARE @NBFCExits TABLE    
(    
 RecordExits varchar(10)  
)    
INSERT INTO @NBFCExits    
EXEC [CSOKYC-6].[General].dbo.usp_CheckNBFCExit_PMLA @ClientCode  
    
  
  
SELECT * FROM @NBFCExits  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CheckUserCredential
-- --------------------------------------------------
  
/*    
    
EXEC usp_CheckUserCredentiaL 'e67753','Angel2016'    
EXEC usp_CheckUserCredentiaL 'E10398','renil1234'    
EXEC usp_CheckUserCredentiaL 'E32749','asdf1234'    
  
SELECT * FROM [196.1.115.132].ROLEMGM.dbo.user_login A Inner Join  tblUser B   
ON A.userName  = B.Username  
WHERE     
 a.username = 'e10398'  
      
 select * from tbl_UserLog order by id desc  
  
  
*/    
    
    
CREATE PROCEDURE [dbo].[usp_CheckUserCredential]     
@User nvarchar (1000)    
,@Password nvarchar (1000)    
    
AS    
    
BEGIN    
    
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES (@User + ' PMLA ', getdate())    
    
SELECT * FROM ROLEMGM.dbo.user_login     
WHERE     
 username=@User    
 AND userpassword = @Password    
    
  
--SELECT * FROM [196.1.115.132].ROLEMGM.dbo.user_login A INNER JOIN tblUser B   
-- ON A.userName  = B.Username  
--WHERE     
-- A.username=@User    
-- AND A.userpassword = @Password    
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FINDINUSP
-- --------------------------------------------------

    
create PROCEDURE [dbo].[USP_FINDINUSP]                  
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
 --PRINT @STR                
  EXEC(@STR)                
        
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateBankMandateCreation
-- --------------------------------------------------
  
/*  
  
EXEC usp_GenerateBankMandateCreation  
  
  
EXEC usp_GenerateBankMandateCreation 'S107257', 'IBKL0000014', null, null, null  
  
sMandateID nAmount  sMandateRefNo sMandateStatus   sBankName sBankBranch  sAccountNo   sIfscCode  
1346595  50000.00 NULL   REGISTERED BY MEMBER AXIS BANK AXIS BANK  912010029807597  UTIB0000103  
  
SELECT DISTINCT [sMandateStatus]  FROM [196.1.115.253].[MutualFund].dbo.tblxsipmandatedetails WITH(NOLOCK)    
WHERE 1=1  
  
*/  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateBankMandateCreation]  
(  
 @ClientCodeSearch varchar(40) = NULL,  
 @IFSCCode varchar(40) = NULL,  
 @AccountNo varchar(40) = NULL,  
 @AccountType varchar(40) = NULL,  
 @mandateamount varchar(40) = NULL  
)  
AS  
BEGIN  
  
DECLARE @BankMandateCreation TABLE (  
 SrNo int identity(1,1),  
 [Id] bigint NOT NULL,  
 [sClientCode] [varchar](50) NULL,  
 [sMandateID] [varchar](30) NULL,  
 [nAmount] [decimal](30, 2) NULL,  
 [sMandateRefNo] [varchar](50) NULL,  
 [sMandateStatus] [varchar](50) NULL,  
 [sBankName] [varchar](500) NULL,  
 [sBankBranch] [varchar](500) NULL,  
 [sAccountNo] [varchar](50) NULL,  
 [sIfscCode] [varchar](30) NULL,  
 [dRegistrationDate] [varchar](100) NULL,  
 [dInsertedOn] [varchar](100) NULL,  
 [sInsertedBy] [varchar](50) NULL,  
 [dUpdatedOn] [varchar](100) NULL,  
 [sUpdatedBy] [varchar](50) NULL,  
 [sAccountType] [varchar](50) NULL,  
 [dApprovedDate] [varchar](100) NULL,  
 [sRejectionRemarks] [varchar](500) NULL,  
 [username] [varchar](50) NULL,  
 [sAccessCode] [varchar](50) NULL,  
 [sAccessTo] [varchar](50) NULL,  
 [sSmsSend] [varchar](1) NULL,  
 [sImgPath] [varchar](500) NULL  
)  
  
--EXEC [196.1.115.253].[MutualFund].dbo.usp_GetXsipMandateDetails 'N69633'---@ClientCodeSearch  
  
DECLARE @SQL NVARCHAR(4000)  
  
SET @SQL = 'SELECT * FROM   
[196.1.115.253].[MutualFund].dbo.tblxsipmandatedetails WITH(NOLOCK)    
WHERE 1=1'  
  
SET @SQL = @SQL + ' AND [sClientCode] = ''' + @ClientCodeSearch + ''''  
+ ' AND sMandateStatus NOT IN (''REJECTED'',''INITIAL REJECTION'',''RETURNED BY EXCHANGE'',''Failed'')'   
  
  
IF (ISNULL(@AccountNo,'') != '')  
BEGIN  
SET @SQL = @SQL + ' AND [sAccountNo] = ''' + @AccountNo + ''''  
END  
  
IF (ISNULL(@IFSCCode,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [sIfscCode] = ''' + @IFSCCode + ''''  
END  
  
IF (ISNULL(@AccountType,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [sAccountType] = ''' + @AccountType + ''''  
END  
  
IF (ISNULL(@mandateamount,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [nAmount] = ''' + @mandateamount + ''''  
END  
  
-- PRINT @SQL  
  
INSERT INTO @BankMandateCreation  
EXEC(@SQL)   
  
SELECT   
 SrNo ,  
 [Id] ,  
 [sClientCode] ,  
 [sMandateID] ,  
 [nAmount] ,  
 [sMandateRefNo] ,  
 [sMandateStatus] ,  
 [sBankName] ,  
 [sBankBranch] ,  
 [sAccountNo] ,  
 [sIfscCode] ,  
 --[dRegistrationDate]AS  [dRegistrationDate1],  
 CONVERT (varchar, [dRegistrationDate], 100) AS  [dRegistrationDate],  
 [dInsertedOn] ,  
 [sInsertedBy] ,  
 [dUpdatedOn] ,  
 [sUpdatedBy] ,  
 [sAccountType] ,  
 [dApprovedDate] ,  
 [sRejectionRemarks] ,  
 [username] ,  
 [sAccessCode] ,  
 [sAccessTo] ,  
 CASE WHEN [sSmsSend]= 'N' Then 'No' Else 'Yes' END AS  sSmsSend,  
 [sImgPath]   
 FROM @BankMandateCreation   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateBankMandateCreation_20_Nov_2021
-- --------------------------------------------------
  
/*  
  
EXEC usp_GenerateBankMandateCreation  
  
  
EXEC usp_GenerateBankMandateCreation 'S107257', 'IBKL0000014', null, null, null  
  
sMandateID nAmount  sMandateRefNo sMandateStatus   sBankName sBankBranch  sAccountNo   sIfscCode  
1346595  50000.00 NULL   REGISTERED BY MEMBER AXIS BANK AXIS BANK  912010029807597  UTIB0000103  
  
SELECT DISTINCT [sMandateStatus]  FROM [196.1.115.132].[MutualFund].dbo.tblxsipmandatedetails WITH(NOLOCK)    
WHERE 1=1  
  
*/  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateBankMandateCreation_20_Nov_2021]  
(  
 @ClientCodeSearch varchar(40) = NULL,  
 @IFSCCode varchar(40) = NULL,  
 @AccountNo varchar(40) = NULL,  
 @AccountType varchar(40) = NULL,  
 @mandateamount varchar(40) = NULL  
)  
AS  
BEGIN  
  
DECLARE @BankMandateCreation TABLE (  
 SrNo int identity(1,1),  
 [Id] bigint NOT NULL,  
 [sClientCode] [varchar](50) NULL,  
 [sMandateID] [varchar](30) NULL,  
 [nAmount] [decimal](30, 2) NULL,  
 [sMandateRefNo] [varchar](50) NULL,  
 [sMandateStatus] [varchar](50) NULL,  
 [sBankName] [varchar](500) NULL,  
 [sBankBranch] [varchar](500) NULL,  
 [sAccountNo] [varchar](50) NULL,  
 [sIfscCode] [varchar](30) NULL,  
 [dRegistrationDate] [varchar](100) NULL,  
 [dInsertedOn] [varchar](100) NULL,  
 [sInsertedBy] [varchar](50) NULL,  
 [dUpdatedOn] [varchar](100) NULL,  
 [sUpdatedBy] [varchar](50) NULL,  
 [sAccountType] [varchar](50) NULL,  
 [dApprovedDate] [varchar](100) NULL,  
 [sRejectionRemarks] [varchar](500) NULL,  
 [username] [varchar](50) NULL,  
 [sAccessCode] [varchar](50) NULL,  
 [sAccessTo] [varchar](50) NULL,  
 [sSmsSend] [varchar](1) NULL,  
 [sImgPath] [varchar](500) NULL  
)  
  
--EXEC [196.1.115.132].[MutualFund].dbo.usp_GetXsipMandateDetails 'N69633'---@ClientCodeSearch  
  
DECLARE @SQL NVARCHAR(4000)  
  
SET @SQL = 'SELECT * FROM   
[196.1.115.132].[MutualFund].dbo.tblxsipmandatedetails WITH(NOLOCK)    
WHERE 1=1'  
  
SET @SQL = @SQL + ' AND [sClientCode] = ''' + @ClientCodeSearch + ''''  
+ ' AND sMandateStatus NOT IN (''REJECTED'',''INITIAL REJECTION'',''RETURNED BY EXCHANGE'',''Failed'')'   
  
  
IF (ISNULL(@AccountNo,'') != '')  
BEGIN  
SET @SQL = @SQL + ' AND [sAccountNo] = ''' + @AccountNo + ''''  
END  
  
IF (ISNULL(@IFSCCode,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [sIfscCode] = ''' + @IFSCCode + ''''  
END  
  
IF (ISNULL(@AccountType,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [sAccountType] = ''' + @AccountType + ''''  
END  
  
IF (ISNULL(@mandateamount,'') != '')  
BEGIN  
 SET @SQL = @SQL + ' AND [nAmount] = ''' + @mandateamount + ''''  
END  
  
-- PRINT @SQL  
  
INSERT INTO @BankMandateCreation  
EXEC(@SQL)   
  
SELECT   
 SrNo ,  
 [Id] ,  
 [sClientCode] ,  
 [sMandateID] ,  
 [nAmount] ,  
 [sMandateRefNo] ,  
 [sMandateStatus] ,  
 [sBankName] ,  
 [sBankBranch] ,  
 [sAccountNo] ,  
 [sIfscCode] ,  
 --[dRegistrationDate]AS  [dRegistrationDate1],  
 CONVERT (varchar, [dRegistrationDate], 100) AS  [dRegistrationDate],  
 [dInsertedOn] ,  
 [sInsertedBy] ,  
 [dUpdatedOn] ,  
 [sUpdatedBy] ,  
 [sAccountType] ,  
 [dApprovedDate] ,  
 [sRejectionRemarks] ,  
 [username] ,  
 [sAccessCode] ,  
 [sAccessTo] ,  
 CASE WHEN [sSmsSend]= 'N' Then 'No' Else 'Yes' END AS  sSmsSend,  
 [sImgPath]   
 FROM @BankMandateCreation   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateBSEAlert
-- --------------------------------------------------
/*

	--exec usp_GenerateBSEAlert 'R87276', '13/11/2016', '13/11/2016'

	exec usp_GenerateBSEAlert 'R87276'

*/


CREATE PROC [dbo].[usp_GenerateBSEAlert]
(
	@ClientID varchar(20)
	--,@FromDate as varchar (100)
	--,ToDate as varchar (100)

)
AS
BEGIN 	  

--SET @FromDate  = '15/12/2016'
--SET @ToDate  = '15/12/2016'
--SET @ClientID = 'R87276'

--SET @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
--SET @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  

--SELECT @FromDate 
--SELECT @ToDate 


SELECT 
	ClientName
	,AlertType 
	--,AlertDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,AlertFrequencyType
	,InstrumentCode
	-- ,TradeDate
	,ISNULL(CONVERT(VARCHAR,TradeDate, 103),'') TradeDate
	,AlertGroup
	,[Type]
	,Scrip
	,[Message]
	,GroupAlertNo
	,OtherClients
	,RefNo
	,ExchangeStatus
	,InstrumentName
	,CaseId
	,ClosedDate
	,IntermediatoryName
	,RiskCategory
	,CSC
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_BSEAlert] 
WHERE 
	RecordStatus = 'A' AND 
	ClientID  = @ClientID 
	--AND AlertDate BETWEEN @FromDate  AND @ToDate  


--SELECT top 10
--	*
--FROM 
--	[dbo].[tbl_BSEAlert] 

--INSERT [dbo].[tbl_PMLAUserLog] 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateBSEScriptDetails
-- --------------------------------------------------
-- EXEC usp_GenerateBSEScriptDetails 'rp61', '06/01/2015','09/01/2016', '', ''  
  
-- EXEC usp_GenerateBSEScriptDetails 'B20608', '2015-04-14' ,'2016-09-14','533160','533160'  
  
 -- EXEC usp_GenerateBSEScriptDetails 'B20608', '14/04/2015' ,'14/09/2016','',''  
  
-- EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
  
  
  
  
CREATE  PROCEDURE [dbo].[usp_GenerateBSEScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Declare @FDate smalldatetime  
--Declare @TDate smalldatetime   
  
--SET @FDate  = @FromDate  
--SET @TDate  = @ToDate  
  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--SELECT @FromDate   
--SELECT @ToDate   
  
  
DECLARE @ScriptReport TABLE  
(  
[Date] smalldatetime,  
Code  nvarchar(100),  
Series nvarchar(100),  
Name  nvarchar(100),  
ISIN nvarchar(100),  
PQty  decimal(18,2),  
PAvgRate  decimal(18,2),  
PValue decimal(18,2),  
SQty decimal(18,2),  
SAvgRate  decimal(18,2),  
SValue decimal(18,2),  
OQty decimal(18,2),  
OAvgRate decimal(18,2),  
OValue decimal(18,2),  
TradingPnl decimal(18,2),  
NetValue decimal(18,2)  
)  
  
  
--DECLARE @ScriptReport TABLE  
--(  
-- Scrip_cd  nvarchar(100),  
-- Series  nvarchar(100),  
-- Scrip_name  nvarchar(1000),  
-- Ptradedqty  numeric (18,2),  
-- ptradedamt  numeric (18,2),  
-- stradedqty  numeric (18,2),  
-- Stradedamt  numeric (18,2),  
-- buybrokerage  numeric (18,2),  
-- Selbrokerage  numeric (18,2),  
-- buydeliverychrg  numeric (18,2),  
-- selldeliverychrg  numeric (18,2),  
-- Billpamt  numeric (18,2),  
-- Billsamt  numeric (18,2),  
-- Pmarketrate  numeric (18,2),  
-- Smarketrate  numeric (18,2),  
-- Pnetrate  numeric (18,2),  
-- Snetrate  numeric (18,2),  
-- Trdamt  numeric (18,2),  
-- delamt  numeric (18,2),  
-- Serinex  numeric (18,2),  
-- service_tax  numeric (18,2),  
-- exservice_tax  numeric (18,2),  
-- turn_tax  numeric (18,2),  
-- sebi_tax  numeric (18,2),  
-- ins_chrg  numeric (18,2),  
-- broker_chrg  numeric (18,2),  
-- other_chrg  numeric (18,2),  
-- Membertype  numeric (18,2),  
-- Companyname  nvarchar (1000),  
-- pnl  numeric (18,2)  
--)  
  
  
  
  
  
  
--INSERT INTO @ScriptReport(  
-- Scrip_cd  ,  
-- Series  ,  
-- Scrip_name ,  
-- Ptradedqty  ,  
-- ptradedamt  ,  
-- stradedqty  ,  
-- Stradedamt  ,  
-- buybrokerage  ,  
-- Selbrokerage  ,  
-- buydeliverychrg  ,  
-- selldeliverychrg  ,  
-- Billpamt  ,  
-- Billsamt  ,  
-- Pmarketrate  ,  
-- Smarketrate  ,  
-- Pnetrate  ,  
-- Snetrate  ,  
-- Trdamt  ,  
-- delamt  ,  
-- Serinex  ,  
-- service_tax  ,  
-- exservice_tax  ,  
-- turn_tax  ,  
-- sebi_tax  ,  
-- ins_chrg  ,  
-- broker_chrg  ,  
-- other_chrg  ,  
-- Membertype  ,  
-- Companyname  ,  
-- pnl    
--)  
  
--EXEC AngelBSECM.bsedb_ab.dbo.Proc_NewBasicReport_Parent '', '', '%', 'Aug 14 2015', 'Sep 14 2016 ', '533160', '533160', 'B20608', 'B20608', 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker'  
--EXEC AngelBSECM.bsedb_ab.dbo.Proc_NewBasicReport_Parent '', '', '%', @fromDate , @ToDate , @FromScriptCode, @ToScriptCode, @client_code, @client_code, 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker'  
  
-- EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA '2015-04-14' ,'2016-09-14','B20608','533160','533160'  
--EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA 'Apr 14 2015' ,'Sep 14 2016','B20608','533160','533160'  
  
INSERT INTO @ScriptReport(  
 [Date],  
 Code,  
 Series,  
 Name,  
 ISIN,  
 PQty,  
 PAvgRate,  
 PValue,  
 SQty ,  
 SAvgRate,  
 SValue ,  
 OQty ,  
 OAvgRate,  
 OValue ,  
 TradingPnl ,  
 NetValue  
)  
EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
  
  
--INSERT INTO @ScriptReport(  
-- Scrip_cd  ,  
-- Series  ,  
-- Scrip_name ,  
-- Ptradedqty  ,  
-- ptradedamt  ,  
-- stradedqty  ,  
-- Stradedamt  ,  
-- buybrokerage  ,  
-- Selbrokerage  ,  
-- buydeliverychrg  ,  
-- selldeliverychrg  ,  
-- Billpamt  ,  
-- Billsamt  ,  
-- Pmarketrate  ,  
-- Smarketrate  ,  
-- Pnetrate  ,  
-- Snetrate  ,  
-- Trdamt  ,  
-- delamt  ,  
-- Serinex  ,  
-- service_tax  ,  
-- exservice_tax  ,  
-- turn_tax  ,  
-- sebi_tax  ,  
-- ins_chrg  ,  
-- broker_chrg  ,  
-- other_chrg  ,  
-- Membertype  ,  
-- Companyname  ,  
-- pnl    
--)  
--EXEC AngelNseCM.msajag.dbo.Proc_Newbasicreport '', '', '%', 'Apr  1 2015 ', 'Mar 31 2016 ', '', '', 'RP61', 'RP61', 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker',''   
  
  
  
--SELECT   
-- Scrip_cd,   
-- Series,   
-- Scrip_name,  
-- Ptradedqty,  
-- Pmarketrate,  
-- --Ptradedqty * Pmarketrate AS ptradedamt ,  
-- ptradedamt,  
  
-- stradedqty,  
-- Smarketrate,  
-- --(stradedqty * Smarketrate) AS Stradedamt,  
-- Stradedamt,  
   
-- (Ptradedqty - stradedqty) AS Otradedqty,  
-- --CASE   
-- -- WHEN (Stradedamt -  ptradedamt ) > 0  THEN (Ptradedqty - stradedqty)  
-- -- WHEN (Stradedamt -  ptradedamt ) < 0  THEN '0'  
-- --END  AS Otradedqty,  
-- CASE   
--  WHEN (Pmarketrate > 0 AND Smarketrate > 0) THEN Smarketrate   
--  WHEN (Pmarketrate ) > 0  THEN Pmarketrate  
--  WHEN (Smarketrate) > 0  THEN Smarketrate  
-- END  AS Omarketrate,  
-- --CASE   
-- -- WHEN (Stradedamt -  ptradedamt ) > 0  THEN (Stradedamt -  ptradedamt )  
-- -- WHEN (Stradedamt -  ptradedamt ) < 0  THEN '0'  
-- --END  AS Otradedamt,  
-- --((stradedqty * Smarketrate) - (Ptradedqty * Pmarketrate ) ) AS Otradedamt,   
   
-- (Stradedamt -ptradedamt) AS Otradedamt,   
-- pnl,  
-- (Stradedamt -ptradedamt)  AS NetValue  
-- --Otradedamt AS  NetValue  
  
--from @ScriptReport   
  
DECLARE @Count int  
  
SELECT @Count = COUNT(0) FROM @ScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @ScriptReport(Name)  
VALUES('GRAND TOTALS')  
  
  
  
-------------- Purchase  
UPDATE @ScriptReport  
SET  PQTY = (SELECT SUM (PQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where PAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  PAvgRate = (SELECT (SUM(PAvgRate)/ CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  PValue = (SELECT SUM (PValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
-------------- Sales  
UPDATE @ScriptReport  
SET  SQTY = (SELECT SUM (SQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where SAvgRate > 0  
--select 'sal'  
--select @Count  
  
UPDATE @ScriptReport  
SET  SAvgRate = (SELECT (SUM(SAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  SValue = (SELECT SUM (SValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
-------------- OPEN  
UPDATE @ScriptReport  
SET  OQty = (SELECT SUM (OQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where OAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  OAvgRate = (SELECT (SUM(OAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  OValue = (SELECT SUM (OValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
  
-------------- Trading and Net  
UPDATE @ScriptReport  
SET  TradingPnl = (SELECT SUM (TradingPnl) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  NetValue= (SELECT SUM (NetValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
END  
  
SELECT convert(varchar, [Date], 106) AS TranDate, * from @ScriptReport --Order by [Date] ASC  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateBSEScriptDetails_iPartner
-- --------------------------------------------------
-- EXEC usp_GenerateBSEScriptDetails 'rp61', '06/01/2015','09/01/2016', '', ''  
  
-- EXEC usp_GenerateBSEScriptDetails 'B20608', '2015-04-14' ,'2016-09-14','533160','533160'  
  
 -- EXEC usp_GenerateBSEScriptDetails 'B20608', '14/04/2015' ,'14/09/2016','',''  
  
-- EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
  
  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateBSEScriptDetails_iPartner]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Declare @FDate smalldatetime  
--Declare @TDate smalldatetime   
  
--SET @FDate  = @FromDate  
--SET @TDate  = @ToDate  
  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--SELECT @FromDate   
--SELECT @ToDate   
  
  
DECLARE @ScriptReport TABLE  
(  
[Date] smalldatetime,  
Code  nvarchar(100),  
Series nvarchar(100),  
Name  nvarchar(100),  
ISIN nvarchar(100),  
PQty  decimal(18,2),  
PAvgRate  decimal(18,2),  
PValue decimal(18,2),  
SQty decimal(18,2),  
SAvgRate  decimal(18,2),  
SValue decimal(18,2),  
OQty decimal(18,2),  
OAvgRate decimal(18,2),  
OValue decimal(18,2),  
TradingPnl decimal(18,2),  
NetValue decimal(18,2)  
)  
  
  
--DECLARE @ScriptReport TABLE  
--(  
-- Scrip_cd  nvarchar(100),  
-- Series  nvarchar(100),  
-- Scrip_name  nvarchar(1000),  
-- Ptradedqty  numeric (18,2),  
-- ptradedamt  numeric (18,2),  
-- stradedqty  numeric (18,2),  
-- Stradedamt  numeric (18,2),  
-- buybrokerage  numeric (18,2),  
-- Selbrokerage  numeric (18,2),  
-- buydeliverychrg  numeric (18,2),  
-- selldeliverychrg  numeric (18,2),  
-- Billpamt  numeric (18,2),  
-- Billsamt  numeric (18,2),  
-- Pmarketrate  numeric (18,2),  
-- Smarketrate  numeric (18,2),  
-- Pnetrate  numeric (18,2),  
-- Snetrate  numeric (18,2),  
-- Trdamt  numeric (18,2),  
-- delamt  numeric (18,2),  
-- Serinex  numeric (18,2),  
-- service_tax  numeric (18,2),  
-- exservice_tax  numeric (18,2),  
-- turn_tax  numeric (18,2),  
-- sebi_tax  numeric (18,2),  
-- ins_chrg  numeric (18,2),  
-- broker_chrg  numeric (18,2),  
-- other_chrg  numeric (18,2),  
-- Membertype  numeric (18,2),  
-- Companyname  nvarchar (1000),  
-- pnl  numeric (18,2)  
--)  
  
  
  
  
  
  
--INSERT INTO @ScriptReport(  
-- Scrip_cd  ,  
-- Series  ,  
-- Scrip_name ,  
-- Ptradedqty  ,  
-- ptradedamt  ,  
-- stradedqty  ,  
-- Stradedamt  ,  
-- buybrokerage  ,  
-- Selbrokerage  ,  
-- buydeliverychrg  ,  
-- selldeliverychrg  ,  
-- Billpamt  ,  
-- Billsamt  ,  
-- Pmarketrate  ,  
-- Smarketrate  ,  
-- Pnetrate  ,  
-- Snetrate  ,  
-- Trdamt  ,  
-- delamt  ,  
-- Serinex  ,  
-- service_tax  ,  
-- exservice_tax  ,  
-- turn_tax  ,  
-- sebi_tax  ,  
-- ins_chrg  ,  
-- broker_chrg  ,  
-- other_chrg  ,  
-- Membertype  ,  
-- Companyname  ,  
-- pnl    
--)  
  
--EXEC AngelBSECM.bsedb_ab.dbo.Proc_NewBasicReport_Parent '', '', '%', 'Aug 14 2015', 'Sep 14 2016 ', '533160', '533160', 'B20608', 'B20608', 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker'  
--EXEC AngelBSECM.bsedb_ab.dbo.Proc_NewBasicReport_Parent '', '', '%', @fromDate , @ToDate , @FromScriptCode, @ToScriptCode, @client_code, @client_code, 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker'  
  
-- EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA '2015-04-14' ,'2016-09-14','B20608','533160','533160'  
--EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA 'Apr 14 2015' ,'Sep 14 2016','B20608','533160','533160'  
  
INSERT INTO @ScriptReport(  
 [Date],  
 Code,  
 Series,  
 Name,  
 ISIN,  
 PQty,  
 PAvgRate,  
 PValue,  
 SQty ,  
 SAvgRate,  
 SValue ,  
 OQty ,  
 OAvgRate,  
 OValue ,  
 TradingPnl ,  
 NetValue  
)  
EXEC AngelBSECM.bsedb_ab.dbo.BSESAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
  
  
--INSERT INTO @ScriptReport(  
-- Scrip_cd  ,  
-- Series  ,  
-- Scrip_name ,  
-- Ptradedqty  ,  
-- ptradedamt  ,  
-- stradedqty  ,  
-- Stradedamt  ,  
-- buybrokerage  ,  
-- Selbrokerage  ,  
-- buydeliverychrg  ,  
-- selldeliverychrg  ,  
-- Billpamt  ,  
-- Billsamt  ,  
-- Pmarketrate  ,  
-- Smarketrate  ,  
-- Pnetrate  ,  
-- Snetrate  ,  
-- Trdamt  ,  
-- delamt  ,  
-- Serinex  ,  
-- service_tax  ,  
-- exservice_tax  ,  
-- turn_tax  ,  
-- sebi_tax  ,  
-- ins_chrg  ,  
-- broker_chrg  ,  
-- other_chrg  ,  
-- Membertype  ,  
-- Companyname  ,  
-- pnl    
--)  
--EXEC AngelNseCM.msajag.dbo.Proc_Newbasicreport '', '', '%', 'Apr  1 2015 ', 'Mar 31 2016 ', '', '', 'RP61', 'RP61', 'PARTY_CODE', 'S', '0', '3', '3', '', 'broker', 'broker',''   
  
  
  
--SELECT   
-- Scrip_cd,   
-- Series,   
-- Scrip_name,  
-- Ptradedqty,  
-- Pmarketrate,  
-- --Ptradedqty * Pmarketrate AS ptradedamt ,  
-- ptradedamt,  
  
-- stradedqty,  
-- Smarketrate,  
-- --(stradedqty * Smarketrate) AS Stradedamt,  
-- Stradedamt,  
   
-- (Ptradedqty - stradedqty) AS Otradedqty,  
-- --CASE   
-- -- WHEN (Stradedamt -  ptradedamt ) > 0  THEN (Ptradedqty - stradedqty)  
-- -- WHEN (Stradedamt -  ptradedamt ) < 0  THEN '0'  
-- --END  AS Otradedqty,  
-- CASE   
--  WHEN (Pmarketrate > 0 AND Smarketrate > 0) THEN Smarketrate   
--  WHEN (Pmarketrate ) > 0  THEN Pmarketrate  
--  WHEN (Smarketrate) > 0  THEN Smarketrate  
-- END  AS Omarketrate,  
-- --CASE   
-- -- WHEN (Stradedamt -  ptradedamt ) > 0  THEN (Stradedamt -  ptradedamt )  
-- -- WHEN (Stradedamt -  ptradedamt ) < 0  THEN '0'  
-- --END  AS Otradedamt,  
-- --((stradedqty * Smarketrate) - (Ptradedqty * Pmarketrate ) ) AS Otradedamt,   
   
-- (Stradedamt -ptradedamt) AS Otradedamt,   
-- pnl,  
-- (Stradedamt -ptradedamt)  AS NetValue  
-- --Otradedamt AS  NetValue  
  
--from @ScriptReport   
  
DECLARE @Count int  
  
SELECT @Count = COUNT(0) FROM @ScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @ScriptReport(Name)  
VALUES('GRAND TOTALS')  
  
  
  
-------------- Purchase  
UPDATE @ScriptReport  
SET  PQTY = (SELECT SUM (PQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where PAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  PAvgRate = (SELECT (SUM(PAvgRate)/ CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  PValue = (SELECT SUM (PValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
-------------- Sales  
UPDATE @ScriptReport  
SET  SQTY = (SELECT SUM (SQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where SAvgRate > 0  
--select 'sal'  
--select @Count  
  
UPDATE @ScriptReport  
SET  SAvgRate = (SELECT (SUM(SAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  SValue = (SELECT SUM (SValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
-------------- OPEN  
UPDATE @ScriptReport  
SET  OQty = (SELECT SUM (OQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where OAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  OAvgRate = (SELECT (SUM(OAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  OValue = (SELECT SUM (OValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
  
-------------- Trading and Net  
UPDATE @ScriptReport  
SET  TradingPnl = (SELECT SUM (TradingPnl) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  NetValue= (SELECT SUM (NetValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
END  
  
SELECT convert(varchar, [Date], 106) AS TranDate, * from @ScriptReport --Order by [Date] ASC  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisBackground
-- --------------------------------------------------

/*
	EXEC usp_GenerateCASEAnalysisBackground 'rp61'
*/


CREATE PROC [dbo].[usp_GenerateCASEAnalysisBackground]
(
@PARTY_CODE nvarchar (40)
)
AS

BEGIN 

DECLARE @CLIENT_CODE VARCHAR(100)

DECLARE @ClientProfile  TABLE
(
	Client_Name nvarchar (400),  ----F
	CL_CODE nvarchar(100),		----F
	DPID  nvarchar(100),		----F
	Mobile nvarchar (100),		----F
	Email nvarchar (200),		----F
	Age nvarchar(100),			----F
	SBTag nvarchar(100),				----F
	BranchTag nvarchar(100),			----F
	SBName nvarchar(100),			----F
	BranchName nvarchar(100),			----F
	AddressLine nvarchar(4000),			----F
	PANNo  nvarchar(100),				----F
	Occupation nvarchar (100)			----F
)


INSERT INTO @ClientProfile
(
	Client_Name ,
	CL_CODE ,
	DPID  ,
	Mobile ,
	Email ,
	Age ,
	SBTag ,
	BranchTag ,
	SBName ,
	BranchName ,
	AddressLine ,
	PANNo  ,
	Occupation 
)
EXEC usp_GenerateCASEAnalysisClientBackground @PARTY_CODE

SELECT  * FROM @ClientProfile


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisBackground_19012017
-- --------------------------------------------------

/*

	exec usp_GenerateCASEAnalysisBackground_19012017'rp61'


*/
	
CREATE PROC [dbo].[usp_GenerateCASEAnalysisBackground_19012017]
(
@PARTY_CODE nvarchar (40)
)
AS

--set @PARTY_CODE = 'rp61'

DECLARE @CLIENT_CODE VARCHAR(100)
--DECLARE @AccountOpeningDate nvarchar(200)
--DECLARE @AccountClosingDate nvarchar(200)
--DECLARE @SpecialCategory nvarchar(200)
--DECLARE @SegmentList varchar (100)

DECLARE @ClientProfile  TABLE
(
	Client_Name nvarchar (400),  ----F
	CL_CODE nvarchar(100),		----F
	DPID  nvarchar(100),		----F
	Mobile nvarchar (100),		----F
	Email nvarchar (200),		----F
	--AccountOpeningDate nvarchar(200),	----F
	--AccountClosingDate nvarchar(200),   ----F
	--AccountStatus nvarchar(200),
	Age nvarchar(100),			----F
	--SegmentRegistered nvarchar (400),	----F
	SBTag nvarchar(100),				----F
	BranchTag nvarchar(100),			----F
	SBName nvarchar(100),			----F
	BranchName nvarchar(100),			----F
	AddressLine nvarchar(4000),			----F
	PANNo  nvarchar(100),				----F
	Occupation nvarchar (100)			----F
	--SpecialCategory nvarchar (400)
)


INSERT INTO @ClientProfile
(
	Client_Name,
	CL_CODE,
	BranchTag,
	SBTag,
	SBName,
	BranchName,
	AddressLine,
	PANNo,
	Mobile,
	Email,
	Age
)
SELECT 
	 CD.Short_Name
	 ,CD.CL_CODE
	 ,CD.BRANCH_CD
	 ,CD.SUB_BROKER
	 ,SBV.SB_Name
	 ,SBV.BranchName
	 , ISNULL(CD.L_ADDRESS1, '') +', ' + ISNULL(CD.L_ADDRESS2, '') + ', ' + ISNULL(CD.L_ADDRESS3,'') + ', ' + ISNULL(CD.L_CITY,'') 
	 + ',' + ISNULL(CD.L_STATE,'') + ', ' +  ISNULL(CD.L_NATION, '') +', ' + ISNULL(CD.L_ZIP,'') AS Addressline
	 ,CD.PAN_GIR_NO
	 ,CD.MOBILE_PAGER
	 ,CD.EMAIL
	 ,CONVERT(INT, ROUND(DATEDIFF(hour, DOB, GETDATE())/8766.0,0)) AS AgeYearsIntRound
 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) 
 LEFT OUTER JOIN [196.1.115.182].general.dbo.vw_rms_sb_vertical  SBV
 ON CD.SUB_BROKER = SBV.SB
 WHERE Cd.CL_CODE = @PARTY_CODE

 --select * from @ClientProfile 

 --SELECT 
	-- @AccountOpeningDate =  convert(varchar, First_Active_date, 103)
	-- ,  @AccountClosingDate = convert(varchar, last_inactive_date, 103) 
	-- --, @SpecialCategory= cl_type
 --FROM Risk.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE = @PARTY_CODE

 --SELECT  @AccountOpeningDate , @AccountClosingDate



--SELECT
--@SegmentList  = 
--				CASE isnull(bsecm, '') When 'Y'  Then 'BSE' ELSE '' END  
--				+  CASE isnull(nsecm, '') When 'Y'  Then ', NSE' ELSE '' END 
--				+  CASE isnull(nsefo, '') When 'Y'  Then ', NSEFO' ELSE '' END 
--				+  CASE isnull(mcdx, '') When 'Y'  Then ', MCDX' ELSE '' END 
--				+  CASE isnull(ncdx, '') When 'Y'  Then ', NCDX' ELSE '' END 
--				+  CASE isnull(bsefo, '') When 'Y'  Then ', BSEFO' ELSE '' END 
-- FROM Risk.DBO.CLIENT_DETAILS CD WITH(NOLOCK) 
-- WHERE cl_code= @PARTY_CODE

-- SET @SegmentList=  
--				CASE  WHEN CHARINDEX(',', @SegmentList) = 1  
--						THEN SUBSTRING (@SegmentList , 2, len(@SegmentList) -1 )
--						ELSE 
--							@SegmentList 
--				END 

--SELECT @SegmentList

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

--SELECT @CLIENT_CODE

-- select @SubBroker 

DECLARE @OCCUPATION nvarchar(100)
DECLARE @Client_Name nvarchar(200)
--DECLARE @ACCOUNT_STATUS nvarchar(100)
--DECLARE @OPENING_DATE nvarchar(100)

SELECT * INTO #TEMPMASTER FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              
SELECT * INTO #TEMPAMCSCEME FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         
SELECT * INTO #tbl_client_master FROM   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE
SELECT * INTO #tbl_client_POA FROM   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT distinct                                

	@OCCUPATION = TM.DESCRIPTION
	
	--@Client_Name  = FIRST_HOLD_NAME, 

	--@ACCOUNT_STATUS = [STATUS]

--	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              

--	@INCOME = TIN.DESCRIPTION 

FROM                              
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

	LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        

ON T.CLIENT_CODE = P.CLIENT_CODE                     

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 
	t.CLIENT_CODE = @CLIENT_CODE



	

	
UPDATE @ClientProfile
SET 
	CL_CODE = @PARTY_CODE,

	DPID =	@CLIENT_CODE , 

	Occupation  = @OCCUPATION

	--AccountOpeningDate = @AccountOpeningDate,

	--AccountClosingDate = @AccountClosingDate,

	--AccountStatus =  @ACCOUNT_STATUS

	--, SegmentRegistered = @SegmentList

	--, SpecialCategory = @SpecialCategory

	
DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 



SELECT  * FROM @ClientProfile

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisClientBackground
-- --------------------------------------------------
  
/*  
  
 EXEC usp_GenerateCASEAnalysisBackground3 'rp61'  
  
  
*/  
  
  
CREATE PROC [dbo].[usp_GenerateCASEAnalysisClientBackground]  
  
(  
@PARTY_CODE nvarchar (40)  
)  
  
AS  
  
  
BEGIN   
  
DECLARE @CLIENT_CODE VARCHAR(100)  
  
DECLARE @ClientProfile  TABLE  
(  
  
 Client_Name nvarchar (400),  ----F  
  
 CL_CODE nvarchar(100),  ----F  
  
 DPID  nvarchar(100),  ----F  
  
 Mobile nvarchar (100),  ----F  
  
 Email nvarchar (200),  ----F  
  
 Age nvarchar(100),   ----F  
  
 SBTag nvarchar(100),    ----F  
  
 BranchTag nvarchar(100),   ----F  
  
 SBName nvarchar(100),   ----F  
  
 BranchName nvarchar(100),   ----F  
  
 AddressLine nvarchar(4000),   ----F  
  
 PANNo  nvarchar(100),    ----F  
  
 Occupation nvarchar (100)   ----F  
  
)  
  
  
  
  
  
INSERT INTO @ClientProfile  
  
(  
  
 Client_Name,  
  
 CL_CODE,  
  
 BranchTag,  
  
 SBTag,  
  
 SBName,  
  
 BranchName,  
  
 AddressLine,  
  
 PANNo,  
  
 Mobile,  
  
 Email,  
  
 Age  
  
)  
  
SELECT   
  
  CD.Short_Name  
  
  ,CD.CL_CODE  
  
  ,CD.BRANCH_CD  
  
  ,CD.SUB_BROKER  
  
  ,SBV.SB_Name  
  
  ,SBV.BranchName  
  
  , ISNULL(CD.L_ADDRESS1, '') +', ' + ISNULL(CD.L_ADDRESS2, '') + ', ' + ISNULL(CD.L_ADDRESS3,'') + ', ' + ISNULL(CD.L_CITY,'')   
  
  + ',' + ISNULL(CD.L_STATE,'') + ', ' +  ISNULL(CD.L_NATION, '') +', ' + ISNULL(CD.L_ZIP,'') AS Addressline  
  
  ,CD.PAN_GIR_NO  
  
  ,CD.MOBILE_PAGER  
  
  ,CD.EMAIL  
  
  ,CONVERT(INT, ROUND(DATEDIFF(hour, DOB, GETDATE())/8766.0,0)) AS AgeYearsIntRound  
  
 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)   
  
 LEFT OUTER JOIN [CSOKYC-6].general.dbo.vw_rms_sb_vertical  SBV  
  
 ON CD.SUB_BROKER = SBV.SB  
  
 WHERE Cd.CL_CODE = @PARTY_CODE  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
DECLARE @OCCUPATION nvarchar(100)  
  
DECLARE @Client_Name nvarchar(200)  
  
  
SELECT * INTO #TEMPMASTER FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                                
  
SELECT * INTO #tbl_client_master FROM   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE  
  
  
SELECT distinct                                  
  
 @OCCUPATION = TM.DESCRIPTION  
  
FROM                                
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
 LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                                
WHERE   
  
 t.CLIENT_CODE = @CLIENT_CODE  
  
  
UPDATE @ClientProfile  
SET   
 CL_CODE = @PARTY_CODE,  
 DPID = @CLIENT_CODE ,   
 Occupation  = @OCCUPATION  
  
SELECT    
  
 ISNULL(Client_Name, '') Client_Name,  
  
 ISNULL(CL_CODE, '')  CL_CODE,  ----F  
  
 ISNULL(DPID, '')   DPID,  ----F  
  
 ISNULL(Mobile, '')  Mobile,  ----F  
  
 ISNULL(Email, '') Email,  ----F  
  
 ISNULL(Age, '')  Age,   ----F  
  
 ISNULL(SBTag, '')  SBTag,    ----F  
  
 ISNULL(BranchTag, '')  BranchTag,   ----F  
  
 ISNULL(SBName, '')  SBName,   ----F  
  
 ISNULL(BranchName, '')  BranchName,   ----F  
  
 ISNULL(AddressLine, '')  AddressLine,   ----F  
  
 ISNULL(PANNo, '')   PANNo,    ----F  
  
 ISNULL(Occupation, '')  Occupation   ----F  
  
FROM @ClientProfile  
  
  
  
  
  
  
  
  
  
DROP TABLE #tbl_client_master  
  
  
  
DROP TABLE #TEMPMASTER  
  
  
  
  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisComments
-- --------------------------------------------------


/*
	exec usp_GenerateCASEAnalysisComments 1, 'rp61'
*/
	
CREATE PROC [dbo].[usp_GenerateCASEAnalysisComments]
(
	@ID int
	,@PARTY_CODE nvarchar (40)
)
AS

SELECT * 
FROM 
	tbl_CaseAnalysis 
WHERE 
	ID  = @ID
	AND ClientID  = @PARTY_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisFinancial
-- --------------------------------------------------
CREATE PROC [dbo].[usp_GenerateCASEAnalysisFinancial]  
  
(  
 @PARTY_CODE nvarchar (40)  
)  
  
AS  
  
--DECLARE @GROSSINCOME VARCHAR (100)  
  
--DECLARE @NET_WORTH VARCHAR (100)  
  
DECLARE @INCOME VARCHAR (100)  
  
  
DECLARE @ClientFinancial  TABLE  
(  
  
GROSSINCOME VARCHAR (100),  
  
NET_WORTH VARCHAR (100),  
  
INCOME VARCHAR (100)  
  
)  
  
INSERT INTO @ClientFinancial  
(  
 GROSSINCOME,  
  
 NET_WORTH,  
  
 INCOME  
)  
  
SELECT   
  
 ISNULL(GROSSINCOME, '')   
  
 ,ISNULL(NET_WORTH, '')   
  
 , ''  
  
FROM   
  
AngelNseCM.msajag.[dbo].[V_INCOME]   
  
WHERE   
  
 PARTY_CODE  = @PARTY_CODE   
  
  
  
SELECT @INCOME =  B.Income  
FROM   
 [AngelDP4].dmat.[citrus_usr].[TBL_CLIENT_MASTER] A INNER JOIN tbl_IncomeCategory B  
ON   
 A.Income_Code  =  B.Id   
WHERE   
 A.Client_Code = (SELECT TOP 1 CLIENT_CODE FROM [AngelDP4].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
  
   
UPDATE @ClientFinancial  
SET INCOME = isnull(@INCOME, '')  
  
  
SELECT  *  FROM @ClientFinancial  
  
  
  
--SELECT   
  
-- @GROSSINCOME  =  ISNULL(GROSSINCOME, '')   
  
-- ,@NET_WORTH  =  ISNULL(NET_WORTH, 0.00)   
  
--FROM   
  
-- AngelNseCM.msajag.[dbo].[V_INCOME]   
  
--WHERE   
  
-- PARTY_CODE  = @PARTY_CODE   
  
  
  
-- SELECT @INCOME =  B.Income  
  
--FROM   
  
-- [172.31.16.108].dmat.[citrus_usr].[TBL_CLIENT_MASTER] A INNER JOIN tbl_IncomeCategory B  
  
--ON   
  
-- A.Income_Code  =  B.Id   
  
--WHERE   
  
-- A.Client_Code = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.108].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
  
  
  
--SELECT   
  
--  @GROSSINCOME   AS Grossincome    
  
-- ,@NET_WORTH  AS Networth   
  
-- ,@INCOME AS Income

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisFinancial_25jan2022
-- --------------------------------------------------
  
/*  
  
 exec usp_GenerateCASEAnalysisFinancial 'rp61'  
  
 exec usp_GenerateCASEAnalysisFinancial 'R87276'  
  
 exec usp_GenerateCASEAnalysisFinancial 'B14695'  
  
  
 exec usp_GenerateCASEAnalysisFinancial 'GJ34'  
  
   
   
*/  
  
  
CREATE PROC [dbo].[usp_GenerateCASEAnalysisFinancial_25jan2022]  
  
(  
 @PARTY_CODE nvarchar (40)  
)  
  
AS  
  
--DECLARE @GROSSINCOME VARCHAR (100)  
  
--DECLARE @NET_WORTH VARCHAR (100)  
  
DECLARE @INCOME VARCHAR (100)  
  
  
DECLARE @ClientFinancial  TABLE  
(  
  
GROSSINCOME VARCHAR (100),  
  
NET_WORTH VARCHAR (100),  
  
INCOME VARCHAR (100)  
  
)  
  
INSERT INTO @ClientFinancial  
(  
 GROSSINCOME,  
  
 NET_WORTH,  
  
 INCOME  
)  
  
SELECT   
  
 ISNULL(GROSSINCOME, '')   
  
 ,ISNULL(NET_WORTH, '')   
  
 , ''  
  
FROM   
  
 [196.1.115.196].msajag.[dbo].[V_INCOME]   
  
WHERE   
  
 PARTY_CODE  = @PARTY_CODE   
  
  
  
SELECT @INCOME =  B.Income  
FROM   
 [172.31.16.94].dmat.[citrus_usr].[TBL_CLIENT_MASTER] A INNER JOIN tbl_IncomeCategory B  
ON   
 A.Income_Code  =  B.Id   
WHERE   
 A.Client_Code = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
  
   
UPDATE @ClientFinancial  
SET INCOME = isnull(@INCOME, '')  
  
  
SELECT  *  FROM @ClientFinancial  
  
  
  
--SELECT   
  
-- @GROSSINCOME  =  ISNULL(GROSSINCOME, '')   
  
-- ,@NET_WORTH  =  ISNULL(NET_WORTH, 0.00)   
  
--FROM   
  
-- [196.1.115.196].msajag.[dbo].[V_INCOME]   
  
--WHERE   
  
-- PARTY_CODE  = @PARTY_CODE   
  
  
  
-- SELECT @INCOME =  B.Income  
  
--FROM   
  
-- [172.31.16.94].dmat.[citrus_usr].[TBL_CLIENT_MASTER] A INNER JOIN tbl_IncomeCategory B  
  
--ON   
  
-- A.Income_Code  =  B.Id   
  
--WHERE   
  
-- A.Client_Code = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
  
  
  
--SELECT   
  
--  @GROSSINCOME   AS Grossincome    
  
-- ,@NET_WORTH  AS Networth   
  
-- ,@INCOME AS Income

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisMatchEmail
-- --------------------------------------------------

/*
	exec usp_GenerateCASEAnalysisMatchEmail 'B14695'
	exec usp_GenerateCASEAnalysisMatchEmail 'rp61'
	exec usp_GenerateCASEAnalysisMatchEmail 'R87276'

*/

CREATE PROC [dbo].[usp_GenerateCASEAnalysisMatchEmail]
(
 @PARTY_CODE nvarchar (40)
)
AS

SELECT 
	cl_code
	, Short_Name
	, Branch_cd
	, Sub_Broker
	, Pan_gir_no
	, email 
FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) 
WHERE email IN 
(
	SELECT TOP 1 Email FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE cl_code= @PARTY_CODE AND ISNULL(Email , '') <> '' 
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisMatchMobile
-- --------------------------------------------------

/*

	exec usp_GenerateCASEAnalysisMatchMobile 'B14695'
	exec usp_GenerateCASEAnalysisMatchMobile 'rp61'
	exec usp_GenerateCASEAnalysisMatchMobile 'R87276'
	
*/

	
CREATE PROC [dbo].[usp_GenerateCASEAnalysisMatchMobile]
(
 @PARTY_CODE nvarchar (40)
)
AS

SELECT cl_code
	, Short_Name
	, Branch_cd
	, Sub_Broker
	, Pan_gir_no
	, mobile_pager 
FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) 
WHERE MOBILE_PAGER IN 
(
SELECT TOP 1 mobile_pager FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE cl_code= @PARTY_CODE
)


--SELECT cl_code, Short_Name, Branch_cd, Sub_Broker,  Pan_gir_no, email  FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE email = 'RCSHAH_1234@YAHOO.COM'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisPayInOut
-- --------------------------------------------------

/*

	exec usp_GenerateCASEAnalysisPayInOut 'B14695'
	exec usp_GenerateCASEAnalysisPayInOut 'rp61'
	exec usp_GenerateCASEAnalysisPayInOut 'R87276'
	
*/

	
CREATE PROC [dbo].[usp_GenerateCASEAnalysisPayInOut]
(
 @PARTY_CODE nvarchar (40)
)
AS

Declare @PayInOut TABLE
(
PType varchar (100)
,PayIn decimal(18,2)
,PayOut decimal(18,2)
,GrandTotal decimal(18,2)
)

DECLARE @ToDate varchar (20)

SET @ToDate  = convert(varchar, GETDATE(),  103)


INSERT INTO @PayInOut
EXEC usp_GeneratePayInPayOutTransaction_History @PARTY_CODE,'01/01/1900',@ToDate, ''

UPDATE @PayInOut
SET PType = 'Non-NBFC'

INSERT INTO @PayInOut
EXEC usp_GeneratePayInPayOutTransaction_History @PARTY_CODE,'01/01/1900',@ToDate, 'nbfc'


--SELECT *
--FROM @PayInOut

SELECT 
	PType 
	,SUM(PayIn) PayIn 
	,SUM(PayOut) PayOut 
	,SUM(GrandTotal) GrandTotal
FROM 
	@PayInOut
GROUP BY PType
ORDER BY PType



--SELECT * 
--FROM OPENQUERY ('ABCSOUATINHOUSE', 
--  'EXEC PMLA.dbo.usp_GeneratePayInPayOutTransaction_History 
--  @clt_code = ''B14695'',
--   @FROM_DATE = ''01/01/2016'', 
--  @TO_DATE = ''31/12/2016'', @Segment= ''''')


/*

exec  usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2016','31/12/2016', ''
exec usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2000','31/12/2016', 'nbfc'

*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisSignification
-- --------------------------------------------------

/*
	exec usp_GenerateCASEAnalysisSignification 'AMLPP1117G'

*/
	
CREATE PROC [dbo].[usp_GenerateCASEAnalysisSignification]
(
 @PAN nvarchar (40)
)
AS


SELECT 
	ScripCode
	,ScripGroup
	,ISIN
	,ISINName
	,HoldingQuantity
	,TotMarketCapShares
	,PercMarketCap
	,AffiliatedAs

FROM 
	tbl_ShareHolder 
WHERE 
	--ClientID = @PARTY_CODE
	PAN  = @PAN
	AND RecordStatus =  'A'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCASEAnalysisSTR
-- --------------------------------------------------

/*

	exec usp_GenerateCASEAnalysisSTR 'rp61'

	exec usp_GenerateCASEAnalysisSTR 'AEEPD5174J'

*/

CREATE PROC [dbo].[usp_GenerateCASEAnalysisSTR]
(
 @PAN nvarchar (40)
)

AS

--SELECT a.id, A.BatchNumber, C.Ctype AS Category,  convert(varchar, A.insertedOn, 106)  as insertedOn, a.GroundOfSuspicion 

--FROM 

--	tbl_Str A 

--		INNER JOIN tbl_str_clientid B 

--			ON A.ID =  B.StrId	

--		INNER JOIN tbl_Str_Category C 

--			ON A.CategoryId =  C.ID	



--WHERE 

--	B.ClientCode  = @PARTY_CODE


--commneted on 22 May 2017
--SELECT a.id, cast(A.ID as varchar) AS BatchNumber, C.Ctype AS Category,  convert(varchar, A.insertedOn, 106)  AS insertedOn, a.GroundOfSuspicion 
--FROM 
--	tbl_Str_Master A 
--	INNER JOIN tbl_str_Client_Master B 
--		ON A.Id = B.BatchId
--		INNER JOIN tbl_Str_Category C
--			ON B.CategoryId =  C.ID	
--WHERE 
--	B.PanNo = @PAN


SELECT a.id, cast(A.ID as varchar) AS BatchNumber, C.Ctype AS Category,  convert(varchar, A.Strdate, 106)  AS insertedOn, a.GroundOfSuspicion 

FROM 

	tbl_Str_Master A 

	INNER JOIN tbl_str_Client_Master B 

		ON A.Id = B.BatchId

		INNER JOIN tbl_Str_Category C

			ON B.CategoryId =  C.ID	
WHERE 

	B.PanNo = @PAN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateCDSLAlert
-- --------------------------------------------------

/*
	exec usp_GenerateCDSLAlert 'R87276',  'fiu1'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu2'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu3'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu4'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu5'
*/


CREATE PROC [dbo].[usp_GenerateCDSLAlert]
(
	@ClientID varchar(20)
	,@CDSLType varchar (20)
)
AS
BEGIN

SELECT 
	ID
	--,ClientID
	,ClientName
	,Batch
	,ISIN
	,ISINDescription
	,CONVERT(VARCHAR,TransDate, 103) TransDate
	,CreditDebit
	,TransQty
	,TransDescription
	,RefNo
	,MarketRateISIN
	,TransactionValue
	,OppClientName
	,CaseId
	,LastestIncome
	,RiskCategory
	,CSC
	,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType = @CDSLType 	

--SELECT * 
--FROM 
--	[dbo].[tbl_CDSLAlert] 

/*
	Update tbl_CDSLAlert
	SET ClientID  = 'R87276'

	Update tbl_CDSLAlert
	SET RecordStatus  = 'A'

	Update [tbl_TSSAlert]
	SET RecordStatus  = 'D'
	WHERE ID > 2000
	-- truncate table tbl_TSSAlert
*/

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileBank
-- --------------------------------------------------
-- exec usp_GenerateClientProfileBank 'gj3214'  
--- exec [usp_GenerateClientProfileBank] 'G18145'  
--- exec [usp_GenerateClientProfileBank] 'rp61'  
  
CREATE PROC [dbo].[usp_GenerateClientProfileBank]  
(  
 @PARTY_CODE nvarchar (40)  
)  
AS  
BEGIN  
  
DECLARE @ClientBankDetail TABLE   
(  
 CLTCODE nvarchar (100),  
 SEGMENT nvarchar (20),  
 ACCOUNTNO nvarchar (100),  
 BANK_NAME nvarchar (100),  
 BRANCH_NAME nvarchar (100),  
 ACCOUNT_TYPE nvarchar (40),  
 MICR_NO nvarchar (100),  
 IFSCCODE nvarchar (100),  
 DEFAULTBANK nvarchar (100)  
)  
  
INSERT INTO @ClientBankDetail  
--EXEC [196.1.115.167].KYC.dbo.Spx_BankDetails_M2 'rp61'  
EXEC MIS.KYC.dbo.Spx_BankDetails_M2 @PARTY_CODE  
  
  
-- SELECT * FROM @ClientBankDetail  
    
    
  SELECT DISTINCT   
    ACCOUNTNO ,  
    BANK_NAME ,  
    BRANCH_NAME ,  
    ACCOUNT_TYPE  
 FROM @ClientBankDetail  
    
   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileBank_Ipartner
-- --------------------------------------------------

-- exec usp_GenerateClientProfileBank 'gj3214'    
--- exec [usp_GenerateClientProfileBank] 'G18145'    
--- exec [usp_GenerateClientProfileBank_Ipartner] 'rp61'    
    
CREATE PROC [dbo].[usp_GenerateClientProfileBank_Ipartner]    
(    
 @PARTY_CODE nvarchar (40)    
)    
AS    
BEGIN    
Set nocount on 
-- return 0


DECLARE @ClientBankDetail TABLE     
(    
 CLTCODE nvarchar (100),    
 SEGMENT nvarchar (20),    
 ACCOUNTNO nvarchar (100),    
 BANK_NAME nvarchar (100),    
 BRANCH_NAME nvarchar (100),    
 ACCOUNT_TYPE nvarchar (40),    
 MICR_NO nvarchar (100),    
 IFSCCODE nvarchar (100),    
 DEFAULTBANK nvarchar (100)    
)    
    
INSERT INTO @ClientBankDetail    
--EXEC [196.1.115.167].KYC.dbo.Spx_BankDetails_M2 'rp61'    
EXEC MIS.KYC.dbo.Spx_BankDetails_M2 @PARTY_CODE    
    
    
-- SELECT * FROM @ClientBankDetail    
      
 SELECT cltcode,AccNO,SelForOnline into #Acc_master_Online_cli  from CMS.DBO.Acc_master_Online_cli  with(nolock) where cltcode=@PARTY_CODE
 
  SELECT DISTINCT     
    ACCOUNTNO ,    
    c.BANK_NAME ,    
    BRANCH_NAME ,    
    ACCOUNT_TYPE,
    isnull(cl.SelForOnlinE,0) as DefaultBank    
 FROM @ClientBankDetail   c left join #Acc_master_Online_cli cl
 on c.CLTCODE=cl.cltcode and c.ACCOUNTNO=cl.AccNO
 
     
     
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileBrokerage
-- --------------------------------------------------
CREATE  PROC [dbo].[usp_GenerateClientProfileBrokerage]  
  
(  
  
 @PARTY_CODE nvarchar (40)  
  
)  
  
AS  
  
BEGIN  
  
  
  
DEclare @ClientBrokerage  TABLE   
  
(  
  
 BrokType nvarchar(100),  
  
 CashUpperLimit nvarchar(100),  
  
 CashMinPaise nvarchar(100),  
  
 CashMax nvarchar(100),  --%  
  
 FoUpperLimit nvarchar(100),  
  
 FOFutureMinPaise nvarchar(100),  
  
 FOFutureMax nvarchar(100),  --%  
  
 CurrUpperLimit nvarchar(100),  
  
 CurrencyFutureMinPaise nvarchar(100),  
  
 CurrencyFutureMax nvarchar(100), --%  
  
 CommoUpperLimit nvarchar(100),  
  
 CommodityFutureMinPaise nvarchar(100),  
  
 CommodityFutureMax nvarchar(100),   --%  
  
 FnoUpperLimit nvarchar(100),  
  
 FOOptionPremium nvarchar(100), --%  
  
 FOOptionMinPerLot nvarchar(100),  
  
 FOOptionMaxPerLot nvarchar(100),  
  
 CurrencyOptionPremium nvarchar(100),   --%  
  
 CurrencyOptionMinPerLot nvarchar(100),  
  
 CurrencyOptionMaxPerLot nvarchar(100)  
  
)  

INSERT INTO @ClientBrokerage  
  
EXEC ABVSKYCMIS.KYC.dbo.Spx_Get_ClientBrokDetails_New_Forverification @PARTY_CODE  
  
--EXEC MIS.KYC.dbo.Spx_Get_ClientBrokDetails_New_Forverification 'gj3214'  
  
--EXEC MIS.KYC.dbo.SPX_GETCLIENTDATAFROMBOFORAUDITOTHERDETAIL_CLIENTPROFILE 'k60156'  
  
   
SELECT * FROM @ClientBrokerage  
 
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileBrokerage_Ipartner
-- --------------------------------------------------
CREATE  PROC [dbo].[usp_GenerateClientProfileBrokerage_Ipartner]  
  
(  
  
 @PARTY_CODE nvarchar (40)  
  
)  
  
AS  
  
BEGIN  
  
  
  
DEclare @ClientBrokerage  TABLE   
  
(  
  
 BrokType nvarchar(100),  
  
 CashUpperLimit nvarchar(100),  
  
 CashMinPaise nvarchar(100),  
  
 CashMax nvarchar(100),  --%  
  
 FoUpperLimit nvarchar(100),  
  
 FOFutureMinPaise nvarchar(100),  
  
 FOFutureMax nvarchar(100),  --%  
  
 CurrUpperLimit nvarchar(100),  
  
 CurrencyFutureMinPaise nvarchar(100),  
  
 CurrencyFutureMax nvarchar(100), --%  
  
 CommoUpperLimit nvarchar(100),  
  
 CommodityFutureMinPaise nvarchar(100),  
  
 CommodityFutureMax nvarchar(100),   --%  
  
 FnoUpperLimit nvarchar(100),  
  
 FOOptionPremium nvarchar(100), --%  
  
 FOOptionMinPerLot nvarchar(100),  
  
 FOOptionMaxPerLot nvarchar(100),  
  
 CurrencyOptionPremium nvarchar(100),   --%  
  
 CurrencyOptionMinPerLot nvarchar(100),  
  
 CurrencyOptionMaxPerLot nvarchar(100)  
  
)  

INSERT INTO @ClientBrokerage  
  
EXEC ABVSKYCMIS.KYC.dbo.Spx_Get_ClientBrokDetails_New_Forverification @PARTY_CODE  
  
--EXEC MIS.KYC.dbo.Spx_Get_ClientBrokDetails_New_Forverification 'gj3214'  
  
--EXEC MIS.KYC.dbo.SPX_GETCLIENTDATAFROMBOFORAUDITOTHERDETAIL_CLIENTPROFILE 'k60156'  
  
   
SELECT * FROM @ClientBrokerage  
 
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDetail
-- --------------------------------------------------

--- exec usp_GenerateClientProfileDetail 'gj3214'  

 --- exec usp_GenerateClientProfileDetail 'G18145'  

 --- exec usp_GenerateClientProfileDetail 'rp61'  

 --- exec usp_GenerateClientProfileDetail 'bknr3290'  

--- exec usp_GenerateClientProfileDetail 'G31959'  -- Online Discount

  --drop proc [usp_GenerateClientProfileDetail]


CREATE PROC [dbo].[usp_GenerateClientProfileDetail]  
(  
@PARTY_CODE nvarchar (40)  
)  

AS  
 
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
   

DECLARE @ClientProfile  TABLE  

(  

 CL_CODE nvarchar(100),  

 Client_Name nvarchar (400),  

 AssociatedAs nvarchar (200),  

 Age nvarchar(100),  

 Gender nvarchar (10),  

 Risk  nvarchar (100),  

 CSC nvarchar (100),  

 Occupation nvarchar (100),  

 ConstitutionType  nvarchar (100),  

 Mobile nvarchar (100),  

 IncomeGroup nvarchar(200),  

 Email nvarchar (200),  

  

 CAddressLine1  nvarchar(1000),  

 CAddressLine2  nvarchar(1000),  

 CAddressLine3  nvarchar(1000),  

 CAddressCity  nvarchar(200),  

 CAddressState  nvarchar(200),  

 CAddressCountry  nvarchar(200),  

 CAddressPin  nvarchar(200),  

 CustomRisk  nvarchar(100),    

 PANNo  nvarchar(100),  

 BranchTag nvarchar(100),  

 SBTag nvarchar(100),  

 SBContactNumber nvarchar(100),  

  

 AccountOpeningDate nvarchar(200),  

 AMCScheme nvarchar(200),  

 POAStatus nvarchar(100),  

 InitialMargin nvarchar(100),  

 ECN nvarchar(100),  

 SMS nvarchar(100),  

 DealerName nvarchar(100),  

 Recordings nvarchar (100),  

 SBPayOut nvarchar (200),  

   

 --DeactivationRemarks nvarchar(1000),  

 NBFCStatus nvarchar(100),  

 MFStatus nvarchar(100),  

 OnlineOffline nvarchar (100),  

 LastTradeDate nvarchar(100),  

 SalesPersonName nvarchar(100),  

 WelcomeCall nvarchar (400),  

 TCStatus nvarchar(200),  

 SBDepositCash nvarchar (200),  

 SBDepositNonCash nvarchar (200),  
   

 KYCCopy nvarchar (200),  

 FDSCalls nvarchar (200),  

 AccountType nvarchar (100),  

 AccountStatus nvarchar(100),  

 ClientID nvarchar(100) ,

 OnlineBrokerageDiscount nvarchar(100),

 AutoPayOut nvarchar(100)

)  


IF (ISNULL(@PARTY_CODE, '' ) != ''  )
BEGIN
	INSERT INTO @ClientProfile  
	EXEC [usp_GenerateClientProfileInfo] @PARTY_CODE  
 END

SELECT   

 

 ISNULL(CL_CODE ,'-') AS CL_CODE ,  

 ISNULL(Client_Name,'-') AS Client_Name,  

 ISNULL(AssociatedAs,'-') AS AssociatedAs,  

 ISNULL(Age ,'-') AS Age ,  

 ISNULL(Gender,'-') AS Gender,  

 ISNULL(Risk ,'-') AS Risk ,  

 ISNULL(CSC,'-') AS CSC,  

 ISNULL(Occupation,'-') AS Occupation,  

 ISNULL(ConstitutionType ,'-') AS ConstitutionType ,  

 ISNULL(Mobile,'-') AS Mobile,  

 ISNULL(IncomeGroup ,'-') AS IncomeGroup ,  

 ISNULL(Email,'-') AS Email,  

 ISNULL(CAddressLine1  ,'-') AS CAddressLine1  ,  

 ISNULL(CAddressLine2  ,'-') AS CAddressLine2  ,  

 ISNULL(CAddressLine3  ,'-') AS CAddressLine3  ,  

 ISNULL(CAddressCity  ,'-') AS CAddressCity  ,  

 ISNULL(CAddressState  ,'-') AS CAddressState  ,  

 ISNULL(CAddressCountry  ,'-') AS CAddressCountry  ,  

 ISNULL(CAddressPin  ,'-') AS CAddressPin  ,  

 ISNULL(CustomRisk    ,'-') AS CustomRisk    ,  

 ISNULL(PANNo  ,'-') AS PANNo  ,  

 ISNULL(BranchTag ,'-') AS BranchTag ,  

 ISNULL(SBTag ,'-') AS SBTag ,  

 --ISNULL(SBContactNumber ,'-') AS SBContactNumber ,  

 CASE WHEN SBContactNumber = '' THEN '-' ELSE ISNULL(SBContactNumber ,'-') END  AS SBContactNumber ,  

 ISNULL(AccountOpeningDate ,'-') AS AccountOpeningDate ,  

 ISNULL(AMCScheme ,'-') AS AMCScheme ,  

 ISNULL(POAStatus ,'-') AS POAStatus ,  

 ISNULL(InitialMargin ,'-') AS InitialMargin ,  

 ISNULL(ECN ,'-') AS ECN ,  

 ISNULL(SMS ,'-') AS SMS ,  

 ISNULL(DealerName ,'-') AS DealerName ,  

 ISNULL(Recordings,'-') AS Recordings,  

 ISNULL(SBPayOut,'-') AS SBPayOut,  

 ISNULL(NBFCStatus ,'-') AS NBFCStatus ,  

 ISNULL(MFStatus ,'-') AS MFStatus ,  

 ISNULL(OnlineOffline,'-') AS OnlineOffline,  

 ISNULL(LastTradeDate ,'-') AS LastTradeDate ,  

 ISNULL(SalesPersonName ,'-') AS SalesPersonName ,  

 ISNULL(WelcomeCall,'-') AS WelcomeCall,  

 ISNULL(TCStatus ,'-') AS TCStatus ,  

 ISNULL(SBDepositCash,'-') AS SBDepositCash,  

 ISNULL(SBDepositNonCash,'-') AS SBDepositNonCash,  

 ISNULL(KYCCopy,'-') AS KYCCopy,  

 ISNULL(FDSCalls,'-') AS FDSCalls,  

 ISNULL(AccountType,'-') AS AccountType,  

 ISNULL(AccountStatus ,'-') AS AccountStatus ,  

 ISNULL(ClientID,'-') AS ClientID ,

 ISNULL(OnlineBrokerageDiscount, '-') AS OnlineBrokerageDiscount,

 ISNULL(AutoPayOut, '-') AS AutoPayOut

     
FROM @ClientProfile  

 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDetail_07022021
-- --------------------------------------------------

--- exec usp_GenerateClientProfileDetail 'gj3214'  

 --- exec usp_GenerateClientProfileDetail 'G18145'  

 --- exec usp_GenerateClientProfileDetail 'rp61'  

 --- exec usp_GenerateClientProfileDetail 'bknr3290'  

--- exec usp_GenerateClientProfileDetail 'G31959'  -- Online Discount

  --drop proc [usp_GenerateClientProfileDetail]


CREATE PROC [dbo].[usp_GenerateClientProfileDetail_07022021]  
(  
@PARTY_CODE nvarchar (40)  
)  

AS  
 
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
   

DECLARE @ClientProfile  TABLE  

(  

 CL_CODE nvarchar(100),  

 Client_Name nvarchar (400),  

 AssociatedAs nvarchar (200),  

 Age nvarchar(100),  

 Gender nvarchar (10),  

 Risk  nvarchar (100),  

 CSC nvarchar (100),  

 Occupation nvarchar (100),  

 ConstitutionType  nvarchar (100),  

 Mobile nvarchar (100),  

 IncomeGroup nvarchar(200),  

 Email nvarchar (200),  

  

 CAddressLine1  nvarchar(1000),  

 CAddressLine2  nvarchar(1000),  

 CAddressLine3  nvarchar(1000),  

 CAddressCity  nvarchar(200),  

 CAddressState  nvarchar(200),  

 CAddressCountry  nvarchar(200),  

 CAddressPin  nvarchar(200),  

 CustomRisk  nvarchar(100),    

 PANNo  nvarchar(100),  

 BranchTag nvarchar(100),  

 SBTag nvarchar(100),  

 SBContactNumber nvarchar(100),  

  

 AccountOpeningDate nvarchar(200),  

 AMCScheme nvarchar(200),  

 POAStatus nvarchar(100),  

 InitialMargin nvarchar(100),  

 ECN nvarchar(100),  

 SMS nvarchar(100),  

 DealerName nvarchar(100),  

 Recordings nvarchar (100),  

 SBPayOut nvarchar (200),  

   

 --DeactivationRemarks nvarchar(1000),  

 NBFCStatus nvarchar(100),  

 MFStatus nvarchar(100),  

 OnlineOffline nvarchar (100),  

 LastTradeDate nvarchar(100),  

 SalesPersonName nvarchar(100),  

 WelcomeCall nvarchar (400),  

 TCStatus nvarchar(200),  

 SBDepositCash nvarchar (200),  

 SBDepositNonCash nvarchar (200),  
   

 KYCCopy nvarchar (200),  

 FDSCalls nvarchar (200),  

 AccountType nvarchar (100),  

 AccountStatus nvarchar(100),  

 ClientID nvarchar(100) ,

 OnlineBrokerageDiscount nvarchar(100),

 AutoPayOut nvarchar(100)

)  


IF (ISNULL(@PARTY_CODE, '' ) != ''  )
BEGIN
	INSERT INTO @ClientProfile  
	EXEC [usp_GenerateClientProfileInfo] @PARTY_CODE  
 END

SELECT   

 

 ISNULL(CL_CODE ,'-') AS CL_CODE ,  

 ISNULL(Client_Name,'-') AS Client_Name,  

 ISNULL(AssociatedAs,'-') AS AssociatedAs,  

 ISNULL(Age ,'-') AS Age ,  

 ISNULL(Gender,'-') AS Gender,  

 ISNULL(Risk ,'-') AS Risk ,  

 ISNULL(CSC,'-') AS CSC,  

 ISNULL(Occupation,'-') AS Occupation,  

 ISNULL(ConstitutionType ,'-') AS ConstitutionType ,  

 ISNULL(Mobile,'-') AS Mobile,  

 ISNULL(IncomeGroup ,'-') AS IncomeGroup ,  

 ISNULL(Email,'-') AS Email,  

 ISNULL(CAddressLine1  ,'-') AS CAddressLine1  ,  

 ISNULL(CAddressLine2  ,'-') AS CAddressLine2  ,  

 ISNULL(CAddressLine3  ,'-') AS CAddressLine3  ,  

 ISNULL(CAddressCity  ,'-') AS CAddressCity  ,  

 ISNULL(CAddressState  ,'-') AS CAddressState  ,  

 ISNULL(CAddressCountry  ,'-') AS CAddressCountry  ,  

 ISNULL(CAddressPin  ,'-') AS CAddressPin  ,  

 ISNULL(CustomRisk    ,'-') AS CustomRisk    ,  

 ISNULL(PANNo  ,'-') AS PANNo  ,  

 ISNULL(BranchTag ,'-') AS BranchTag ,  

 ISNULL(SBTag ,'-') AS SBTag ,  

 --ISNULL(SBContactNumber ,'-') AS SBContactNumber ,  

 CASE WHEN SBContactNumber = '' THEN '-' ELSE ISNULL(SBContactNumber ,'-') END  AS SBContactNumber ,  

 ISNULL(AccountOpeningDate ,'-') AS AccountOpeningDate ,  

 ISNULL(AMCScheme ,'-') AS AMCScheme ,  

 ISNULL(POAStatus ,'-') AS POAStatus ,  

 ISNULL(InitialMargin ,'-') AS InitialMargin ,  

 ISNULL(ECN ,'-') AS ECN ,  

 ISNULL(SMS ,'-') AS SMS ,  

 ISNULL(DealerName ,'-') AS DealerName ,  

 ISNULL(Recordings,'-') AS Recordings,  

 ISNULL(SBPayOut,'-') AS SBPayOut,  

 ISNULL(NBFCStatus ,'-') AS NBFCStatus ,  

 ISNULL(MFStatus ,'-') AS MFStatus ,  

 ISNULL(OnlineOffline,'-') AS OnlineOffline,  

 ISNULL(LastTradeDate ,'-') AS LastTradeDate ,  

 ISNULL(SalesPersonName ,'-') AS SalesPersonName ,  

 ISNULL(WelcomeCall,'-') AS WelcomeCall,  

 ISNULL(TCStatus ,'-') AS TCStatus ,  

 ISNULL(SBDepositCash,'-') AS SBDepositCash,  

 ISNULL(SBDepositNonCash,'-') AS SBDepositNonCash,  

 ISNULL(KYCCopy,'-') AS KYCCopy,  

 ISNULL(FDSCalls,'-') AS FDSCalls,  

 ISNULL(AccountType,'-') AS AccountType,  

 ISNULL(AccountStatus ,'-') AS AccountStatus ,  

 ISNULL(ClientID,'-') AS ClientID ,

 ISNULL(OnlineBrokerageDiscount, '-') AS OnlineBrokerageDiscount,

 ISNULL(AutoPayOut, '-') AS AutoPayOut

     
FROM @ClientProfile  

 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDetail_IPartner
-- --------------------------------------------------
/**************/
-- AngelBSECM
-- PMLA
-- SP created for IPartner
/**************/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- exec usp_GenerateClientProfileDetail 'gj3214'  

 --- exec usp_GenerateClientProfileDetail 'G18145'  

 --- exec usp_GenerateClientProfileDetail 'rp61'  

 --- exec usp_GenerateClientProfileDetail 'bknr3290'  

--- exec usp_GenerateClientProfileDetail 'G31959'  -- Online Discount

  --drop proc [usp_GenerateClientProfileDetail]


CREATE PROC [dbo].[usp_GenerateClientProfileDetail_IPartner]  
(  
@PARTY_CODE varchar (40)  
)  

AS  
 
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
   

DECLARE @ClientProfile  TABLE  

(  

 CL_CODE nvarchar(100),  

 Client_Name nvarchar (400),  

 AssociatedAs nvarchar (200),  

 Age nvarchar(100),  

 Gender nvarchar (10),  

 Risk  nvarchar (100),  

 CSC nvarchar (100),  

 Occupation nvarchar (100),  

 ConstitutionType  nvarchar (100),  

 Mobile nvarchar (100),  

 IncomeGroup nvarchar(200),  

 Email nvarchar (200),  

  

 CAddressLine1  nvarchar(1000),  

 CAddressLine2  nvarchar(1000),  

 CAddressLine3  nvarchar(1000),  

 CAddressCity  nvarchar(200),  

 CAddressState  nvarchar(200),  

 CAddressCountry  nvarchar(200),  

 CAddressPin  nvarchar(200),  

 CustomRisk  nvarchar(100),    

 PANNo  nvarchar(100),  

 BranchTag nvarchar(100),  

 SBTag nvarchar(100),  

 SBContactNumber nvarchar(100),  

  

 AccountOpeningDate nvarchar(200),  

 AMCScheme nvarchar(200),  

 POAStatus nvarchar(100),  

 InitialMargin nvarchar(100),  

 ECN nvarchar(100),  

 SMS nvarchar(100),  

 DealerName nvarchar(100),  

 Recordings nvarchar (100),  

 SBPayOut nvarchar (200),  

   

 --DeactivationRemarks nvarchar(1000),  

 NBFCStatus nvarchar(100),  

 MFStatus nvarchar(100),  

 OnlineOffline nvarchar (100),  

 LastTradeDate nvarchar(100),  

 SalesPersonName nvarchar(100),  

 WelcomeCall nvarchar (400),  

 TCStatus nvarchar(200),  

 SBDepositCash nvarchar (200),  

 SBDepositNonCash nvarchar (200),  
   

 KYCCopy nvarchar (200),  

 FDSCalls nvarchar (200),  

 AccountType nvarchar (100),  

 AccountStatus nvarchar(100),  

 ClientID nvarchar(100) ,

 OnlineBrokerageDiscount nvarchar(100),

 AutoPayOut nvarchar(100)

)  


IF (ISNULL(@PARTY_CODE, '' ) != ''  )
BEGIN
	INSERT INTO @ClientProfile  
	EXEC [usp_GenerateClientProfileInfo_IPartner] @PARTY_CODE  
 END

SELECT   

 

 ISNULL(CL_CODE ,'-') AS CL_CODE ,  

 ISNULL(Client_Name,'-') AS Client_Name,  

 ISNULL(AssociatedAs,'-') AS AssociatedAs,  

 ISNULL(Age ,'-') AS Age ,  

 ISNULL(Gender,'-') AS Gender,  

 ISNULL(Risk ,'-') AS Risk ,  

 ISNULL(CSC,'-') AS CSC,  

 ISNULL(Occupation,'-') AS Occupation,  

 ISNULL(ConstitutionType ,'-') AS ConstitutionType ,  

 ISNULL(Mobile,'-') AS Mobile,  

 ISNULL(IncomeGroup ,'-') AS IncomeGroup ,  

 ISNULL(Email,'-') AS Email,  

 ISNULL(CAddressLine1  ,'-') AS CAddressLine1  ,  

 ISNULL(CAddressLine2  ,'-') AS CAddressLine2  ,  

 ISNULL(CAddressLine3  ,'-') AS CAddressLine3  ,  

 ISNULL(CAddressCity  ,'-') AS CAddressCity  ,  

 ISNULL(CAddressState  ,'-') AS CAddressState  ,  

 ISNULL(CAddressCountry  ,'-') AS CAddressCountry  ,  

 ISNULL(CAddressPin  ,'-') AS CAddressPin  ,  

 ISNULL(CustomRisk    ,'-') AS CustomRisk    ,  

 ISNULL(PANNo  ,'-') AS PANNo  ,  

 ISNULL(BranchTag ,'-') AS BranchTag ,  

 ISNULL(SBTag ,'-') AS SBTag ,  

 --ISNULL(SBContactNumber ,'-') AS SBContactNumber ,  

 CASE WHEN SBContactNumber = '' THEN '-' ELSE ISNULL(SBContactNumber ,'-') END  AS SBContactNumber ,  

 ISNULL(AccountOpeningDate ,'-') AS AccountOpeningDate ,  

 ISNULL(AMCScheme ,'-') AS AMCScheme ,  

 ISNULL(POAStatus ,'-') AS POAStatus ,  

 ISNULL(InitialMargin ,'-') AS InitialMargin ,  

 ISNULL(ECN ,'-') AS ECN ,  

 ISNULL(SMS ,'-') AS SMS ,  

 ISNULL(DealerName ,'-') AS DealerName ,  

 ISNULL(Recordings,'-') AS Recordings,  

 ISNULL(SBPayOut,'-') AS SBPayOut,  

 ISNULL(NBFCStatus ,'-') AS NBFCStatus ,  

 ISNULL(MFStatus ,'-') AS MFStatus ,  

 ISNULL(OnlineOffline,'-') AS OnlineOffline,  

 ISNULL(LastTradeDate ,'-') AS LastTradeDate ,  

 ISNULL(SalesPersonName ,'-') AS SalesPersonName ,  

 ISNULL(WelcomeCall,'-') AS WelcomeCall,  

 ISNULL(TCStatus ,'-') AS TCStatus ,  

 ISNULL(SBDepositCash,'-') AS SBDepositCash,  

 ISNULL(SBDepositNonCash,'-') AS SBDepositNonCash,  

 ISNULL(KYCCopy,'-') AS KYCCopy,  

 ISNULL(FDSCalls,'-') AS FDSCalls,  

 ISNULL(AccountType,'-') AS AccountType,  

 ISNULL(AccountStatus ,'-') AS AccountStatus ,  

 ISNULL(ClientID,'-') AS ClientID ,

 ISNULL(OnlineBrokerageDiscount, '-') AS OnlineBrokerageDiscount,

 ISNULL(AutoPayOut, '-') AS AutoPayOut

     
FROM @ClientProfile  

 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDetail_Ipartnet
-- --------------------------------------------------


  

--- exec [usp_GenerateClientProfileDetail_Ipartnet] 'gj3214'    

  

 --- exec usp_GenerateClientProfileDetail 'G18145'    

  

 --- exec usp_GenerateClientProfileDetail 'rp61'    

  

 --- exec usp_GenerateClientProfileDetail 'bknr3290'    

  

--- exec usp_GenerateClientProfileDetail_ipartner 'alwr2144'  -- Online Discount  

  

  --drop proc [usp_GenerateClientProfileDetail]  

  

  

CREATE PROC [dbo].[usp_GenerateClientProfileDetail_Ipartnet]    

(    

@PARTY_CODE nvarchar (40)    

)    

  

AS    


--declare @PARTY_CODE nvarchar (40)    ='alwr2144'

   

DECLARE @CLIENT_CODE VARCHAR(100)               

    

BEGIN    

     

  

create TABLE   #ClientProfile  

  

(    

  

 CL_CODE nvarchar(100),    

  

 Client_Name nvarchar (400),    

  

 AssociatedAs nvarchar (200),    

  

 Age nvarchar(100),    

  

 Gender nvarchar (10),    

  

 Risk  nvarchar (100),    

  

 CSC nvarchar (100),    

  

 Occupation nvarchar (100),    

  

 ConstitutionType  nvarchar (100),    

  

 Mobile nvarchar (100),    

  

 IncomeGroup nvarchar(200),    

  

 Email nvarchar (200),    

  

    

  

 CAddressLine1  nvarchar(1000),    

  

 CAddressLine2  nvarchar(1000),    

  

 CAddressLine3  nvarchar(1000),    

  

 CAddressCity  nvarchar(200),    

  

 CAddressState  nvarchar(200),    

  

 CAddressCountry  nvarchar(200),    

  

 CAddressPin  nvarchar(200),    

  

 CustomRisk  nvarchar(100),      

  

 PANNo  nvarchar(100),    

  

 BranchTag nvarchar(100),    

  

 SBTag nvarchar(100),    

  

 SBContactNumber nvarchar(100),    

  

    

  

 AccountOpeningDate nvarchar(200),    

  

 AMCScheme nvarchar(200),    

  

 POAStatus nvarchar(100),    

  

 InitialMargin nvarchar(100),    

  

 ECN nvarchar(100),    

  

 SMS nvarchar(100),    

  

 DealerName nvarchar(100),    

  

 Recordings nvarchar (100),    

  

 SBPayOut nvarchar (200),    

  

     

  

 --DeactivationRemarks nvarchar(1000),    

  

 NBFCStatus nvarchar(100),    

  

 MFStatus nvarchar(100),    

  

 OnlineOffline nvarchar (100),    

  

 LastTradeDate nvarchar(100),    

  

 SalesPersonName nvarchar(100),    

  

 WelcomeCall nvarchar (400),    

  

 TCStatus nvarchar(200),    

  

 SBDepositCash nvarchar (200),    

  

 SBDepositNonCash nvarchar (200),    

     

  

 KYCCopy nvarchar (200),    

  

 FDSCalls nvarchar (200),    

  

 AccountType nvarchar (100),    

  

 AccountStatus nvarchar(100),    

  

 ClientID nvarchar(100) ,  

  

 OnlineBrokerageDiscount nvarchar(100),  

  

 AutoPayOut nvarchar(100)  

  

)    

  

  

IF (ISNULL(@PARTY_CODE, '' ) != ''  )  

BEGIN  

 INSERT INTO #ClientProfile    

 --EXEC [usp_GenerateClientProfileInfo] @PARTY_CODE    
  EXEC [usp_GenerateClientProfileInfo_Ipartner_new] @PARTY_CODE  

 END  





alter table #ClientProfile    

add  MF varchar(50)


UPDATE #ClientProfile
SET Client_Name = (select top 1 SHORT_NAME FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 WHERE party_code = @PARTY_CODE)
WHERE ISNULL(Client_Name,'') = ''

UPDATE #ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''

  

SELECT     

  

   

  

 ISNULL(c.CL_CODE ,'-') AS CL_CODE ,    

  

 ISNULL(Client_Name,'-') AS Client_Name,    

  

 ISNULL(AssociatedAs,'-') AS AssociatedAs,    

  

 ISNULL(Age ,'-') AS Age ,    

  

 ISNULL(Gender,'-') AS Gender,    

  

 ISNULL(Risk ,'-') AS Risk ,    

  

 ISNULL(CSC,'-') AS CSC,    

  

 ISNULL(Occupation,'-') AS Occupation,    

  

 ISNULL(ConstitutionType ,'-') AS ConstitutionType ,    

  

 ISNULL(Mobile,'-') AS Mobile,    

  

 ISNULL(IncomeGroup ,'-') AS IncomeGroup ,    

  

 ISNULL(c.Email,'-') AS Email,    

  

 ISNULL(CAddressLine1  ,'-') AS CAddressLine1  ,    

  

 ISNULL(CAddressLine2  ,'-') AS CAddressLine2  ,    

  

 ISNULL(CAddressLine3  ,'-') AS CAddressLine3  ,    

  

 ISNULL(CAddressCity  ,'-') AS CAddressCity  ,    

  

 ISNULL(CAddressState  ,'-') AS CAddressState  ,    

  

 ISNULL(CAddressCountry  ,'-') AS CAddressCountry  ,    

  

 ISNULL(CAddressPin  ,'-') AS CAddressPin  ,    

  

 ISNULL(CustomRisk    ,'-') AS CustomRisk    ,    

  

 ISNULL(PANNo  ,'-') AS PANNo  ,    

  

 ISNULL(BranchTag ,'-') AS BranchTag ,    

  

 ISNULL(SBTag ,'-') AS SBTag ,    

  

 --ISNULL(SBContactNumber ,'-') AS SBContactNumber ,    

  

 CASE WHEN SBContactNumber = '' THEN '-' ELSE ISNULL(SBContactNumber ,'-') END  AS SBContactNumber ,    

  

 ISNULL(AccountOpeningDate ,'-') AS AccountOpeningDate ,    

  

 ISNULL(AMCScheme ,'-') AS AMCScheme ,    

  

 ISNULL(POAStatus ,'-') AS POAStatus ,    

  

 ISNULL(InitialMargin ,'-') AS InitialMargin ,    

  

 ISNULL(ECN ,'-') AS ECN ,    

  

 ISNULL(SMS ,'-') AS SMS ,    

  

 ISNULL(DealerName ,'-') AS DealerName ,    

  

 ISNULL(Recordings,'-') AS Recordings,    

  

 ISNULL(SBPayOut,'-') AS SBPayOut,    

  

 ISNULL(NBFCStatus ,'-') AS NBFCStatus ,    

  

 ISNULL(MFStatus ,'-') AS MFStatus ,    

  

 ISNULL(OnlineOffline,'-') AS OnlineOffline,    

  

 ISNULL(LastTradeDate ,'-') AS LastTradeDate ,    

  

 ISNULL(SalesPersonName ,'-') AS SalesPersonName ,    

  

 ISNULL(WelcomeCall,'-') AS WelcomeCall,    

  

 ISNULL(TCStatus ,'-') AS TCStatus ,    

  

 ISNULL(SBDepositCash,'-') AS SBDepositCash,    

  

 ISNULL(SBDepositNonCash,'-') AS SBDepositNonCash,    

  

 ISNULL(KYCCopy,'-') AS KYCCopy,    

  

 ISNULL(FDSCalls,'-') AS FDSCalls,    

  

 ISNULL(AccountType,'-') AS AccountType,    

  

 ISNULL(AccountStatus ,'-') AS AccountStatus ,    

  

 ISNULL(ClientID,'-') AS ClientID ,  

  

 ISNULL(OnlineBrokerageDiscount, '-') AS OnlineBrokerageDiscount,  

  

 ISNULL(AutoPayOut, '-') AS AutoPayOut,

 ISNULL(cd.MF,'-') as MF  

  

       

FROM #ClientProfile    c 

inner join 

[CSOKYC-6].general.dbo.client_details cd

on c.CL_CODE=cd.party_code





--drop table   #ClientProfile

   

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDPPayIn
-- --------------------------------------------------



--  exec [usp_GenerateClientProfileDPPayIn] 'gj3214'
--- exec [usp_GenerateClientProfileDPPayIn] 'G18145'
--- exec [usp_GenerateClientProfileDPPayIn] 'rp61'

CREATE  PROC [dbo].[usp_GenerateClientProfileDPPayIn]
(
 @PARTY_CODE nvarchar (40)
)
AS
BEGIN

SELECT m.Party_code AS Client_Code,m.CltDpNo AS AccNo, m.DpId AS DPID, m.Introducer, m.DpType AS DPType, m.Def AS DEF, BANKNAME AS DPName,

case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag

from AngelNseCM.MSAJAG.dbo.MULTICLTID m With(NoLock)

	Inner Join AngelNseCM.MSAJAG.dbo.BANK  S With(NoLock) On m.dpid=S.BANKID

where  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')   

union   

select m.Party_code,m.CltDpNo,m.DpId,m.Introducer,m.DpType,m.Def,BANKNAME,

case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag 

from AngelDemat.BSEDB.dbo.MULTICLTID m With(NoLock) 

	Inner Join AngelDemat.BSEDB.dbo.BANK  S  With(NoLock) On m.dpid=S.BANKID

WHERE  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')    


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDPPayOut
-- --------------------------------------------------


--  exec usp_GenerateClientProfileDPPayOut 'gj3214'
--- exec usp_GenerateClientProfileDPPayOut 'G18145'
--- exec usp_GenerateClientProfileDPPayOut 'rp61'


CREATE PROC [dbo].[usp_GenerateClientProfileDPPayOut]
(
 @PARTY_CODE nvarchar (40)
)
AS
BEGIN

--SELECT m.Party_code AS Client_Code,m.CltDpNo AS DPNO, m.DpId AS DPID, m.Introducer, m.DpType AS DPType, m.Def AS DEF, BANKNAME AS DPName,

--case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag

--from AngelNseCM.MSAJAG.dbo.MULTICLTID m With(NoLock)

--	Inner Join AngelNseCM.MSAJAG.dbo.BANK  S With(NoLock) On m.dpid=S.BANKID

--where  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')   

--union   

--select m.Party_code,m.CltDpNo,m.DpId,m.Introducer,m.DpType,m.Def,BANKNAME,

--case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag 

--from AngelDemat.BSEDB.dbo.MULTICLTID m With(NoLock) 

--	Inner Join AngelDemat.BSEDB.dbo.BANK  S  With(NoLock) On m.dpid=S.BANKID

--WHERE  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')    



select t.Cl_code AS Client_Code,t.Party_code,t.Instru,t.BankID  AS DPID,t.Cltdpid AS AccNo, t.Depository,t.DefDp,BANKNAME AS DPName,

case when (t.BankId='12033200' and DefDp='1' ) then '1' else '0' end as DefaultFlag  

from AngelNseCM.MSAJAG.dbo.Client4 T With(NoLock)

	Inner Join AngelNseCM.MSAJAG.dbo.BANK  S  With(NoLock) On T.BANKID=S.BANKID  

where  cl_code=@party_code AND DEPOSITORY IN ('CDSL', 'NSDL')    

union  

select t.Cl_code,t.Party_code,t.Instru,t.BankID,t.Cltdpid,t.Depository,t.DefDp,BANKNAME ,

case when (t.BankId='12033200' and DefDp='1' ) then '1' else '0' end as DefaultFlag  

from AngelDemat.BSEDB.dbo.Client4 T With(NoLock)

	Inner Join AngelDemat.bsedb.dbo.BANK  S  With(NoLock) On T.BANKID=S.BANKID 

where  cl_code=@party_code AND DEPOSITORY IN ('CDSL', 'NSDL') 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileDPPayOut_Ipartner
-- --------------------------------------------------



--  exec usp_GenerateClientProfileDPPayOut 'gj3214'
--- exec usp_GenerateClientProfileDPPayOut 'G18145'
--- exec usp_GenerateClientProfileDPPayOut 'rp61'


CREATE PROC [dbo].[usp_GenerateClientProfileDPPayOut_Ipartner]
(
 @PARTY_CODE nvarchar (40)
)
AS
BEGIN

--SELECT m.Party_code AS Client_Code,m.CltDpNo AS DPNO, m.DpId AS DPID, m.Introducer, m.DpType AS DPType, m.Def AS DEF, BANKNAME AS DPName,

--case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag

--from AngelNseCM.MSAJAG.dbo.MULTICLTID m With(NoLock)

--	Inner Join AngelNseCM.MSAJAG.dbo.BANK  S With(NoLock) On m.dpid=S.BANKID

--where  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')   

--union   

--select m.Party_code,m.CltDpNo,m.DpId,m.Introducer,m.DpType,m.Def,BANKNAME,

--case when (DpId='12033200' and DEF='1' ) then '1' else '0' end as DefaultFlag 

--from AngelDemat.BSEDB.dbo.MULTICLTID m With(NoLock) 

--	Inner Join AngelDemat.BSEDB.dbo.BANK  S  With(NoLock) On m.dpid=S.BANKID

--WHERE  PARTY_CODE=@PARTY_CODE AND DpType in ('CDSL', 'NSDL')    



select t.Cl_code AS Client_Code,t.Party_code,t.Instru,t.BankID  AS DPID,t.Cltdpid AS AccNo, t.Depository,t.DefDp,BANKNAME AS DPName,

case when (t.BankId='12033200' and DefDp='1' ) then '1' else '0' end as DefaultFlag  

from AngelNseCM.MSAJAG.dbo.Client4 T With(NoLock)

	Inner Join AngelNseCM.MSAJAG.dbo.BANK  S  With(NoLock) On T.BANKID=S.BANKID  

where  cl_code=@party_code AND DEPOSITORY IN ('CDSL', 'NSDL')    

union  

select t.Cl_code,t.Party_code,t.Instru,t.BankID,t.Cltdpid,t.Depository,t.DefDp,BANKNAME ,

case when (t.BankId='12033200' and DefDp='1' ) then '1' else '0' end as DefaultFlag  

from AngelDemat.BSEDB.dbo.Client4 T With(NoLock)

	Inner Join AngelDemat.bsedb.dbo.BANK  S  With(NoLock) On T.BANKID=S.BANKID 

where  cl_code=@party_code AND DEPOSITORY IN ('CDSL', 'NSDL') 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo
-- --------------------------------------------------

 --- exec usp_GenerateClientProfileInfo 'R82164'  

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo 'C16748'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo]
(
	@PARTY_CODE nvarchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

SELECT * INTO #TEMPAMCSCEME FROM AGMUBODPL3.DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT DISTINCT                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --AGMUBODPL3.Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN AGMUBODPL3.Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE



UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	---Email =  @EMAIL_ID,
	Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD nvarchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)


 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from [CSOKYC-6].general.dbo.Vw_RMS_Client_Vertical A 

					INNER JOIN MIS.SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM Risk.DBO.emp_info with(nolock) WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 with(nolock)

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )



--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [CSOKYC-6].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker nvarchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [CSOKYC-6].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [CSOKYC-6].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  ABCSOORACLEMDLW.oraclefin.dbo.sb_balance with(nolock) 

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from AngelFO.NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from AngelFO.BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [CSOKYC-6].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [Mimansa].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=Mimansa;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [Mimansa].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=Mimansa;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec Mimansa.[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

----------------------------------------------------------Added on 09-01-19--------------------------------------------------------  

UPDATE @ClientProfile
SET Client_Name = (select top 1 SHORT_NAME FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 WHERE party_code = @PARTY_CODE)
WHERE ISNULL(Client_Name,'') = ''

UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''

SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_07022021
-- --------------------------------------------------

 --- exec usp_GenerateClientProfileInfo 'gj3214'   --- 

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo 'C16748'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_07022021]
(
	@PARTY_CODE nvarchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

SELECT * INTO #TEMPAMCSCEME FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT distinct                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE


UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	Email =  @EMAIL_ID,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD nvarchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)


 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from [196.1.115.182].general.dbo.Vw_RMS_Client_Vertical A 

					INNER JOIN [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM [196.1.115.132].Risk.DBO.emp_info WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )


--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [196.1.115.182].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker nvarchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [196.1.115.182].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [196.1.115.182].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [196.1.115.182].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=196.1.115.207;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=196.1.115.207;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_09_01_2019
-- --------------------------------------------------

 --- exec usp_GenerateClientProfileInfo 'R82164'  

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo 'C16748'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_09_01_2019]
(
	@PARTY_CODE nvarchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

SELECT * INTO #TEMPAMCSCEME FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT DISTINCT                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE



UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	---Email =  @EMAIL_ID,
	Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD nvarchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)


 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from [196.1.115.182].general.dbo.Vw_RMS_Client_Vertical A 

					INNER JOIN [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM Risk.DBO.emp_info with(nolock) WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 with(nolock)

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )



--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [196.1.115.182].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker nvarchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [196.1.115.182].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [196.1.115.182].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [196.1.115.182].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=196.1.115.207;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=196.1.115.207;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_IPartner
-- --------------------------------------------------
/**************/
-- AngelBSECM
-- PMLA
-- SP created for IPartner
/**************/

 --- exec usp_GenerateClientProfileInfo 'gj3214'   --- 

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo_IPartner 'S96666'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_IPartner]
(
	@PARTY_CODE varchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo_IPartner', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

SELECT * INTO #TEMPAMCSCEME FROM AGMUBODPL3.DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT distinct                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --AGMUBODPL3.Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN AGMUBODPL3.Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE


UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	Email =  @EMAIL_ID,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD varchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)


 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from [CSOKYC-6].general.dbo.Vw_RMS_Client_Vertical A 

					INNER JOIN MIS.SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM Risk.DBO.emp_info WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )


--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [CSOKYC-6].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker varchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [CSOKYC-6].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [CSOKYC-6].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  ABCSOORACLEMDLW.oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from AngelFO.NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from AngelFO.BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [CSOKYC-6].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [Mimansa].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=Mimansa;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [Mimansa].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=Mimansa;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec Mimansa.[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

----------------------------------------------------------Added on 09-01-19--------------------------------------------------------  

UPDATE @ClientProfile
SET Client_Name = (select top 1 SHORT_NAME FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 WHERE party_code = @PARTY_CODE)
WHERE ISNULL(Client_Name,'') = ''

UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_IPartner_09_01_2019
-- --------------------------------------------------
/**************/
-- 196.1.115.2019
-- PMLA
-- SP created for IPartner
/**************/

 --- exec usp_GenerateClientProfileInfo 'gj3214'   --- 

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo_IPartner 'S96666'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_IPartner_09_01_2019]
(
	@PARTY_CODE varchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo_IPartner', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

SELECT * INTO #TEMPAMCSCEME FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT distinct                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE


UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	Email =  @EMAIL_ID,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD varchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)


 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from [196.1.115.182].general.dbo.Vw_RMS_Client_Vertical A 

					INNER JOIN [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM [196.1.115.132].Risk.DBO.emp_info WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )


--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [196.1.115.182].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker varchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [196.1.115.182].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [196.1.115.182].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [196.1.115.182].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=196.1.115.207;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=196.1.115.207;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView
-- --------------------------------------------------


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  


--EXEC [usp_GenerateClientProfileInfo_Ipartner_ClientView_new111] 'Alwr1927'
--Return 0  

select * into #ANGELCLIENT1 from Mimansa.ANGELCS.DBO.ANGELCLIENT1  WITH(NOLOCK) where party_code = @PARTY_CODE

	select * into #client_details from AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)  where party_code=@PARTY_CODE
	select * into #mfss_client from AngelFO.bsemfss.DBO.mfss_client CD WITH(NOLOCK) where party_code= @PARTY_CODE 
	--select * into #Tbl_CLIENT_POA from [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @PARTY_CODE
	--select * into #tbl_client_master from [172.31.16.94].inhouse.dbo.tbl_client_master T WITH (NOLOCK) where NISE_PARTY_CODE =@PARTY_CODE
	--select * into #DP_Access_CliProfile from [DP_Access_CliProfile] where CLIENT_CODE  = @PARTY_CODE
    -- Insert statements for procedure here

	
  
--INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
--VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM dbo.Tbl_CLIENT_MASTER_syn WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   dbo.Tbl_CLIENT_MASTER_Syn WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   dbo.Tbl_CLIENT_POA_syn WITH(NOLOCK) WHERE CLIENT_CODE = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM #ANGELCLIENT1  WITH(NOLOCK) where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM #ANGELCLIENT1 WITH(NOLOCK) where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   

Drop table #ANGELCLIENT1
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView_1
-- --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--kill 561

CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView_1]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  

--Return 0  

select * into #ANGELCLIENT1 from Mimansa.ANGELCS.DBO.ANGELCLIENT1  WITH(NOLOCK) where party_code = @PARTY_CODE
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM AngelFO.bsemfss.DBO.mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM #ANGELCLIENT1  WITH(NOLOCK) where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM #ANGELCLIENT1 WITH(NOLOCK) where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from AngelFO.NSEMFSS.dbo.MFSS_CLIENT  WITH(NOLOCK) where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from AngelFO.BSEMFSS.dbo.MFSS_CLIENT  WITH(NOLOCK) where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   

Drop table #ANGELCLIENT1
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView_23042019
-- --------------------------------------------------


-- exec usp_GenerateClientProfileInfo_Ipartner_ClientView 'S32515'

CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView_23042019]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM [196.1.115.200].bsemfss.DBO.mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView_Bkp04Sep2020
-- --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--kill 561

CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView_Bkp04Sep2020]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  

--Return 0  

select * into #ANGELCLIENT1 from [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1  WITH(NOLOCK) where party_code = @PARTY_CODE
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM [196.1.115.200].bsemfss.DBO.mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM #ANGELCLIENT1  WITH(NOLOCK) where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM #ANGELCLIENT1 WITH(NOLOCK) where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT  WITH(NOLOCK) where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT  WITH(NOLOCK) where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   

Drop table #ANGELCLIENT1
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView_Bkp10Mar2021
-- --------------------------------------------------


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView_Bkp10Mar2021]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  

--Return 0  

select * into #ANGELCLIENT1 from [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1  WITH(NOLOCK) where party_code = @PARTY_CODE

	select * into #client_details from ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)  where party_code=@PARTY_CODE
	select * into #mfss_client from [196.1.115.200].bsemfss.DBO.mfss_client CD WITH(NOLOCK) where party_code= @PARTY_CODE 
	--select * into #Tbl_CLIENT_POA from [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @PARTY_CODE
	--select * into #tbl_client_master from [172.31.16.94].inhouse.dbo.tbl_client_master T WITH (NOLOCK) where NISE_PARTY_CODE =@PARTY_CODE
	--select * into #DP_Access_CliProfile from [DP_Access_CliProfile] where CLIENT_CODE  = @PARTY_CODE
    -- Insert statements for procedure here


  
--INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
--VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM #ANGELCLIENT1  WITH(NOLOCK) where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM #ANGELCLIENT1 WITH(NOLOCK) where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   

Drop table #ANGELCLIENT1
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_ClientView_New111
-- --------------------------------------------------


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_ClientView_New111]  
(  
--Declare  
	@PARTY_CODE nvarchar (40)  ='Alwr1927'
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  


--EXEC [usp_GenerateClientProfileInfo_Ipartner_ClientView] 'Alwr1927'
--Return 0  

select * into #ANGELCLIENT1 from Mimansa.ANGELCS.DBO.ANGELCLIENT1  WITH(NOLOCK) where party_code = @PARTY_CODE

	select * into #client_details from ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK)  where party_code=@PARTY_CODE
	select * into #mfss_client from Angelfo.bsemfss.DBO.mfss_client CD WITH(NOLOCK) where party_code= @PARTY_CODE 
	--select * into #Tbl_CLIENT_POA from [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @PARTY_CODE
	--select * into #tbl_client_master from [172.31.16.94].inhouse.dbo.tbl_client_master T WITH (NOLOCK) where NISE_PARTY_CODE =@PARTY_CODE
	--select * into #DP_Access_CliProfile from [DP_Access_CliProfile] where CLIENT_CODE  = @PARTY_CODE
    -- Insert statements for procedure here


  
--INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
--VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int, CL_CODE nvarchar(100),   Client_Name nvarchar (400),   AssociatedAs nvarchar (200),   Age nvarchar(100),   Gender nvarchar (10),     Risk  nvarchar (100),  
  CSC nvarchar (100), Occupation nvarchar (100), ConstitutionType  nvarchar (100), Mobile nvarchar (100), IncomeGroup nvarchar(200),Email nvarchar (200), CAddressLine1  nvarchar(1000),  
 CAddressLine2  nvarchar(1000),CAddressLine3  nvarchar(1000), CAddressCity  nvarchar(200), CAddressState  nvarchar(200), CAddressCountry  nvarchar(200), CAddressPin  nvarchar(200),  
 CustomRisk  nvarchar(100), PANNo  nvarchar(100), BranchTag nvarchar(100),  SBTag nvarchar(100), SBContactNumber nvarchar(100), AccountOpeningDate nvarchar(200),  
 AMCScheme nvarchar(200),   POAStatus nvarchar(100), InitialMargin nvarchar(100),  ECN nvarchar(100), SMS nvarchar(100), DealerName nvarchar(100),  
 Recordings nvarchar (100),  SBPayOut nvarchar (200),  NBFCStatus nvarchar(100),  MFStatus nvarchar(100), OnlineOffline nvarchar (100),  LastTradeDate nvarchar(100),  
 SalesPersonName nvarchar(100),  WelcomeCall nvarchar (400),   TCStatus nvarchar(200),   SBDepositCash nvarchar (200),  SBDepositNonCash nvarchar (200),  
 KYCCopy nvarchar (200),  FDSCalls nvarchar (200),  AccountType nvarchar (100),  AccountStatus nvarchar(100),  ClientID nvarchar(100),  OnlineBrokerageDiscount nvarchar(100),  
  AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile ( sr,CL_CODE,BranchTag,SBTag,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,PANNo,Mobile,Email,AccountType,Gender,Age)  
 
SELECT   1 as sr,
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
 CD.PAN_GIR_NO,  
 CD.MOBILE_PAGER,                
 CD.EMAIL,                
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 UNION 
 
 SELECT  2 as sr, 
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
 CD.PAN_NO,  
 CD.MOBILE_No,                
 CD.EMAIL_ID,                
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
 FROM #mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE

--DECLARE @OCCUPATION nvarchar(100)  
DECLARE @Client_Name nvarchar(200)  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
DECLARE @SUB_TYPE nvarchar(200)  
DECLARE @POAStatus nvarchar(100)  
DECLARE @OPENING_DATE nvarchar(100)  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM dbo.Tbl_CLIENT_MASTER_syn WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
select * into #tbl_client_master from   dbo.Tbl_CLIENT_MASTER_Syn WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  select * into #tbl_client_POA from   dbo.Tbl_CLIENT_POA_syn WITH(NOLOCK) WHERE CLIENT_CODE = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
 @Client_Name  = FIRST_HOLD_NAME,   
 @ACCOUNT_STATUS = [STATUS],   
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
WHERE   
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
SET   
 Client_Name =  @Client_Name ,  
 POAStatus = @POAStatus,  
 AccountOpeningDate = @OPENING_DATE,   
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
  ClientID = @CLIENT_CODE  
     

	 --select distinct * from @ClientProfile  

DECLARE @LastTradeDate nvarchar(100)  
DECLARE @ECN nvarchar(10)  
DECLARE @NBFCStatus nvarchar(10)  
DECLARE @RiskCategory nvarchar(100)  
DECLARE @Branch_CD nvarchar(20)  
DECLARE @Cash_Colleteral NVARCHAR(100)  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn
	FROM #ANGELCLIENT1  WITH(NOLOCK) where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
 LastTradeDate = @LastTradeDate ,   
 NBFCStatus = @NBFCStatus,  
 Risk = @RiskCategory  
  
DECLARE @SubBroker nvarchar (100)  
SELECT @SubBroker = SBTag   from @ClientProfile  
                


UPDATE @ClientProfile
SET AccountOpeningDate = (SELECT TOP 1 CONVERT(VARCHAR(12),ActiveFrom,103) FROM #ANGELCLIENT1 WITH(NOLOCK) where party_code = @PARTY_CODE)
WHERE ISNULL(AccountOpeningDate,'') = ''


UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from #mfss_client WITH(NOLOCK) where party_code = @PARTY_CODE  
)  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
SELECT  distinct Client_Name,CL_CODE	,Mobile,CAddressLine1,CAddressPin,Email,CAddressLine2,CAddressCity,PANNo,CAddressLine3,CAddressState
		,AccountOpeningDate,MFStatus	--,AdharStaus
		,ECN,POAStatus
 FROM @ClientProfile  --order by sr asc

  
DROP TABLE #tbl_client_master  
DROP TABLE #tbl_client_POA   
--DROP TABLE #TEMPMASTER  
--DROP TABLE #TEMPAMCSCEME   

Drop table #ANGELCLIENT1
  
--DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_new
-- --------------------------------------------------




  
 --- exec usp_GenerateClientProfileInfo 'R82164'    
  
 --- exec usp_GenerateClientProfileInfo 'G18145'  
  
 --- exec usp_GenerateClientProfileInfo 'rp61'  
  
 --- exec usp_GenerateClientProfileInfo 'C16748'  
  
 --- exec usp_GenerateClientProfileInfo 'hegu393'  
  
 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson  
  
 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin  
  
 --- exec usp_GenerateClientProfileInfo 'alwr2144'  -- Online Discount  
 
 /* 
  begin tran
  exec usp_GenerateClientProfileInfo_Ipartner_NY 'PTM1715'
  rollback
  */



CREATE  PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_new]  
(  
 @PARTY_CODE nvarchar (40)  
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int,
 CL_CODE nvarchar(100),  
  
 Client_Name nvarchar (400),  
  
 AssociatedAs nvarchar (200),  
  
 Age nvarchar(100),  
  
 Gender nvarchar (10),  
  
 Risk  nvarchar (100),  
  
 CSC nvarchar (100),  
  
 Occupation nvarchar (100),  
  
 ConstitutionType  nvarchar (100),  
  
 Mobile nvarchar (100),  
  
 IncomeGroup nvarchar(200),  
  
 Email nvarchar (200),  
  
 CAddressLine1  nvarchar(1000),  
  
 CAddressLine2  nvarchar(1000),  
  
 CAddressLine3  nvarchar(1000),  
  
 CAddressCity  nvarchar(200),  
  
 CAddressState  nvarchar(200),  
  
 CAddressCountry  nvarchar(200),  
  
 CAddressPin  nvarchar(200),  
  
 CustomRisk  nvarchar(100),    
  
 PANNo  nvarchar(100),  
  
 BranchTag nvarchar(100),  
  
 SBTag nvarchar(100),  
  
 SBContactNumber nvarchar(100),  
  
 AccountOpeningDate nvarchar(200),  
  
 AMCScheme nvarchar(200),  
  
 POAStatus nvarchar(100),  
  
 InitialMargin nvarchar(100),  
  
 ECN nvarchar(100),  
  
 SMS nvarchar(100),  
  
 DealerName nvarchar(100),  
  
 Recordings nvarchar (100),  
  
 SBPayOut nvarchar (200),  
  
 --DeactivationRemarks nvarchar(1000),  
  
 NBFCStatus nvarchar(100),  
  
 MFStatus nvarchar(100),  
  
 OnlineOffline nvarchar (100),  
  
 LastTradeDate nvarchar(100),  
  
 SalesPersonName nvarchar(100),  
  
 WelcomeCall nvarchar (400),  
  
 TCStatus nvarchar(200),  
  
 SBDepositCash nvarchar (200),  
  
 SBDepositNonCash nvarchar (200),  
  
 KYCCopy nvarchar (200),  
  
 FDSCalls nvarchar (200),  
  
 AccountType nvarchar (100),  
  
 AccountStatus nvarchar(100),  
  
 ClientID nvarchar(100),  
  
 --DPCharges nvarchar(100),  
  
 --PenalCharges nvarchar(100)  
  
 OnlineBrokerageDiscount nvarchar(100),  
  
 AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile  
( 
sr, 
 CL_CODE,  
  
 BranchTag,  
  
 SBTag,  
  
 CAddressLine1,  
  
 CAddressLine2,  
  
 CAddressLine3,  
  
 CAddressCity,  
  
 CAddressState,  
  
 CAddressCountry,  
  
 CAddressPin,  
  
 PANNo,   
  
 Mobile,  
  
 Email,  
  
 AccountType,   
  
 Gender,  
  
 Age  
  
 --ClientID  
  
)  
  
  
  
SELECT   1 as sr,
  
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
  
 CD.PAN_GIR_NO,  
  
 CD.MOBILE_PAGER,                
   
 CD.EMAIL,                
    
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
  
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
  
 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                            
  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
  
 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 
 
 
 union 
 
 
 SELECT  2 as sr, 
  
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
  
 CD.PAN_NO,  
  
 CD.MOBILE_No,                
   
 CD.EMAIL_ID,                
    
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
  
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
  
 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                            
  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  

 FROM ANGELFO.bsemfss.DBO.mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE


 
  
 -- select * from @ClientProfile  
  
 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                                
  
--- select *    FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'            
  
-- select @SubBroker   
  
  
DECLARE @OCCUPATION nvarchar(100)  
  
DECLARE @Client_Name nvarchar(200)  
  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
  
DECLARE @SUB_TYPE nvarchar(200)  
  
DECLARE @POAStatus nvarchar(100)  
  
DECLARE @OPENING_DATE nvarchar(100)  
  
--DECLARE @CLIENT_CODE nvarchar(100)  
  
DECLARE @INCOME nvarchar(100)  
  
DECLARE @AMC nvarchar(200)  
  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SELECT * INTO #TEMPMASTER FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                                
  
SELECT * INTO #TEMPAMCSCEME FROM AGMUBODPL3.DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)           
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
select * into #tbl_client_master from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  
select * into #tbl_client_POA from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
  
 @OCCUPATION = TM.DESCRIPTION,  
   
 @Client_Name  = FIRST_HOLD_NAME,   
   
 @ACCOUNT_STATUS = [STATUS],   
   
 @SUB_TYPE = SUB_TYPE,  
    
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
  
 @OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                                
   
 --T.TYPE  AS AC_TYPE,  
   
 @INCOME = TIN.DESCRIPTION ,  
  
   
 @AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,    
   
  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)             
  
--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)            
  
 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)            
   
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK)   
   
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
  
--and   p.holder_indi=1                        
  
LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                                
  
LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                                
  
LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                              
  
LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                       
  
LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                       
  
LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                          
  
WHERE   
  
--T.NISE_PARTY_CODE=@PARTY_CODE  
  
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
  
SET   
 Occupation  = @OCCUPATION,  
  
 ConstitutionType = @SUB_TYPE ,   
   
 Client_Name =  @Client_Name ,  
   
 POAStatus = @POAStatus,  
   
 AccountOpeningDate = @OPENING_DATE,   
    
 IncomeGroup = @INCOME,  
   
 AMCScheme  = @AMC,  
   
 ---Email =  @EMAIL_ID,  
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
   
    ClientID = @CLIENT_CODE  
   
--UPDATE @ClientProfile  
  
--SET ClientID = @CLIENT_CODE  
  
  
--SELECT   
  
-- @OCCUPATION ,  
  
   
  
-- @ACCOUNT_STATUS ,   
  
   
  
-- @SUB_TYPE ,  
  
  
  
-- @POAStatus ,  
  
  
  
-- @OPENING_DATE ,  
  
  
  
-- @INCOME ,  
  
  
  
-- @AMC ,  
  
  
  
-- @EMAIL_ID  
  
   
  
-- LastTradeDate, ECN, NBFC Client, RiskCategory,   
  
DECLARE @LastTradeDate nvarchar(100)  
  
DECLARE @ECN nvarchar(10)  
  
DECLARE @NBFCStatus nvarchar(10)  
  
DECLARE @RiskCategory nvarchar(100)  
  
DECLARE @Branch_CD nvarchar(20)  
  
DECLARE @Cash_Colleteral NVARCHAR(100)  
  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn,   
  
  @LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) ,   
  
  @NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END,   
  
  @RiskCategory = RiskCategory,  
  
  @Branch_CD = Branch_CD  
  
FROM Mimansa.ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE  
  
  
--SELECT @ECN  ,   
  
--  @LastTradeDate ,   
  
--  @NBFCStatus ,  
  
--  @RiskCategory  
  
  
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
  
 LastTradeDate = @LastTradeDate ,   
   
 NBFCStatus = @NBFCStatus,  
   
 Risk = @RiskCategory  
    
 --NewClient_ID = '123'  
   
  
UPDATE @ClientProfile  
SET   
  
 OnlineOffline  = (SELECT top 1 CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)  
  
  
UPDATE @ClientProfile  
  
SET   
  
 SBContactNumber  = (  
  
     SELECT top 1 B.TerMobNo from [CSOKYC-6].general.dbo.Vw_RMS_Client_Vertical A   
  
     INNER JOIN MIS.SB_COMP.dbo.VW_SubBroker_Details B  
  
     ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))  
  
     WHERE A.client = @Party_Code  
  
     )  
  
UPDATE @ClientProfile  
  
SET   
 DealerName  = (  
  
      SELECT top 1 Emp_Name FROM Risk.DBO.emp_info with(nolock) WHERE emp_no IN   
      (  
        SELECT  CASE   
  
         WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer  
  
         WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1  
  
         WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2  
  
         WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name   
  
        FROM MIMANSA.ANGELCS.DBO.ANGELCLIENT1 with(nolock)  
  
        WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD   
  
      )  
       )  
  
  
  
--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral)   
  
--from [196.1.115.182].[General].dbo.rms_dtclfi where Sub_broker='hegu'  
  
--group by Sub_broker  
  
DECLARE @SubBroker nvarchar (100)  
  
SELECT @SubBroker = SBTag   from @ClientProfile  
  
  
--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral)   
  
--FROM [196.1.115.182].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker  
  
--GROUP BY Sub_broker  
  
SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl)   
  
FROM [CSOKYC-6].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker  
  
GROUP BY Sub_broker  
  
UPDATE @ClientProfile  
SET SBDepositCash = @Cash_Colleteral  
  
UPDATE @ClientProfile  
SET SBDepositNonCash = @NonCash_Colleteral  
  
UPDATE @ClientProfile  
SET SBPayOut =   
(  
 SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))    
  
 FROM  ABCSOORACLEMDLW.oraclefin.dbo.sb_balance    
  
 WHERE vtype='PAYMENT' and sbtag = @SubBroker  
  
 GROUP BY vdt  
  
 ORDER BY vdt DESC  
)  
  
  
--UPDATE @ClientProfile  
  
--SET SalesPersonName =   
  
--(  
  
--SELECT distinct VW.Emp_name   
  
-- FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)  
  
--     INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid  
  
--  INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A'   
  
--  WHERE c.party_code= @Party_Code  ---'bknr3290'  
  
--)  
  
UPDATE @ClientProfile  
SET SalesPersonName =   
(  
SELECT INTRODUCER  FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
)  
                
UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from AngelFO.NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from AngelFO.BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
)  
  
UPDATE @ClientProfile  
SET InitialMargin =   
(   
 SELECT  SUM(IMargin)  from [CSOKYC-6].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE  
)  
  
  
/*  
  
SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))    
  
 FROM  [196.1.115.199].oraclefin.dbo.sb_balance    
  
 WHERE vtype='PAYMENT' and sbtag = 'hegu'  
  
 GROUP BY sbtag  
  
*/  
  
  
--UPDATE @ClientProfile  
--SET DPCharges =   
--(   
-- SELECT SUM(A.CHARGES_AMT)   
-- FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                            
-- INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                            
-- WHERE CHARGES_DATE > CUTOFFDATE                                    
-- AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                   
-- GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME       
  
--)  
  
--UPDATE @ClientProfile  
--SET PenalCharges =   
--(   
-- SELECT SUM(A.CHARGES_AMT)   
-- FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                            
-- INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                            
-- WHERE CHARGES_DATE > CUTOFFDATE                                    
-- AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                            
-- GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME       
  
--)  
  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
Declare @AutoPayOut varchar(100)  
  
DECLARE @OnlineBrokerageDiscount  TABLE  
(  
 Party_Code nvarchar (400),  
 OnlineBrokerageDiscount nvarchar (200)  
)  
  
--INSERT INTO @OnlineDiscount    
--EXEC [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE  
  
--SET @AutoPayOut = NULL  
  
--UPDATE @ClientProfile  
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)  
  
--UPDATE @ClientProfile  
--SET AutoPayOut =  @AutoPayOut  
  
--SELECT * INTO #tmptbl      
--    FROM OPENROWSET ('SQLOLEDB','Server=196.1.115.207;TRUSTED_CONNECTION=YES;'   
--   ,'set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''')   
  
 DECLARE @sql NVARCHAR(MAX)  
 --Set @Party_Code = 'G31959'   
 SET @sql = 'SELECT * INTO tmptbl      
 FROM OPENROWSET(  
     ''SQLOLEDB'',  
     ''Server=Mimansa;TRUSTED_CONNECTION=YES;'',  
     ''set fmtonly off exec Mimansa.[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'  
 -- Print @sql  
 EXEC(@sql)  
  
  
UPDATE @ClientProfile  
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)  
  
UPDATE @ClientProfile  
SET AutoPayOut =  NULL  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
UPDATE @ClientProfile  
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'  
  
UPDATE @ClientProfile  
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'  
  
SELECT  CL_CODE,Client_Name,AssociatedAs,Age,Gender,Risk,CSC,Occupation,ConstitutionType,Mobile,IncomeGroup,Email,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,CustomRisk,PANNo,BranchTag,SBTag,SBContactNumber,AccountOpeningDate,AMCScheme,POAStatus,InitialMargin,ECN,SMS,DealerName,Recordings,SBPayOut,NBFCStatus,MFStatus,OnlineOffline,LastTradeDate,SalesPersonName,WelcomeCall,TCStatus,SBDepositCash,SBDepositNonCash,KYCCopy,FDSCalls,AccountType,AccountStatus,ClientID,OnlineBrokerageDiscount,AutoPayOut
 FROM @ClientProfile  order by sr asc
  
DROP TABLE #tbl_client_master  
  
DROP TABLE #tbl_client_POA   
  
DROP TABLE #TEMPMASTER  
  
DROP TABLE #TEMPAMCSCEME   
  
DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_Ipartner_new_08Feb2019
-- --------------------------------------------------

CREATE PROC [dbo].[usp_GenerateClientProfileInfo_Ipartner_new_08Feb2019]  
(  
 @PARTY_CODE nvarchar (40)  
)  
  
AS  
  
DECLARE @CLIENT_CODE VARCHAR(100)             
  
BEGIN  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateClientProfileInfo_Ipartner_new', getdate())  
  
DECLARE @ClientProfile  TABLE  
(  
sr int,
 CL_CODE nvarchar(100),  
  
 Client_Name nvarchar (400),  
  
 AssociatedAs nvarchar (200),  
  
 Age nvarchar(100),  
  
 Gender nvarchar (10),  
  
 Risk  nvarchar (100),  
  
 CSC nvarchar (100),  
  
 Occupation nvarchar (100),  
  
 ConstitutionType  nvarchar (100),  
  
 Mobile nvarchar (100),  
  
 IncomeGroup nvarchar(200),  
  
 Email nvarchar (200),  
  
 CAddressLine1  nvarchar(1000),  
  
 CAddressLine2  nvarchar(1000),  
  
 CAddressLine3  nvarchar(1000),  
  
 CAddressCity  nvarchar(200),  
  
 CAddressState  nvarchar(200),  
  
 CAddressCountry  nvarchar(200),  
  
 CAddressPin  nvarchar(200),  
  
 CustomRisk  nvarchar(100),    
  
 PANNo  nvarchar(100),  
  
 BranchTag nvarchar(100),  
  
 SBTag nvarchar(100),  
  
 SBContactNumber nvarchar(100),  
  
 AccountOpeningDate nvarchar(200),  
  
 AMCScheme nvarchar(200),  
  
 POAStatus nvarchar(100),  
  
 InitialMargin nvarchar(100),  
  
 ECN nvarchar(100),  
  
 SMS nvarchar(100),  
  
 DealerName nvarchar(100),  
  
 Recordings nvarchar (100),  
  
 SBPayOut nvarchar (200),  
  
 --DeactivationRemarks nvarchar(1000),  
  
 NBFCStatus nvarchar(100),  
  
 MFStatus nvarchar(100),  
  
 OnlineOffline nvarchar (100),  
  
 LastTradeDate nvarchar(100),  
  
 SalesPersonName nvarchar(100),  
  
 WelcomeCall nvarchar (400),  
  
 TCStatus nvarchar(200),  
  
 SBDepositCash nvarchar (200),  
  
 SBDepositNonCash nvarchar (200),  
  
 KYCCopy nvarchar (200),  
  
 FDSCalls nvarchar (200),  
  
 AccountType nvarchar (100),  
  
 AccountStatus nvarchar(100),  
  
 ClientID nvarchar(100),  
  
 --DPCharges nvarchar(100),  
  
 --PenalCharges nvarchar(100)  
  
 OnlineBrokerageDiscount nvarchar(100),  
  
 AutoPayOut nvarchar(100)  
)  
  
  
INSERT INTO @ClientProfile  
( 
sr, 
 CL_CODE,  
  
 BranchTag,  
  
 SBTag,  
  
 CAddressLine1,  
  
 CAddressLine2,  
  
 CAddressLine3,  
  
 CAddressCity,  
  
 CAddressState,  
  
 CAddressCountry,  
  
 CAddressPin,  
  
 PANNo,   
  
 Mobile,  
  
 Email,  
  
 AccountType,   
  
 Gender,  
  
 Age  
  
 --ClientID  
  
)  
  
  
  
SELECT   1 as sr,
  
 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,  
  
 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,                
  
 CD.PAN_GIR_NO,  
  
 CD.MOBILE_PAGER,                
   
 CD.EMAIL,                
    
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                     
  
 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
  
 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                            
  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  
  
 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
 

 
 union 
 
 
 SELECT  2 as sr, 
  
 CD.party_code,CD.BRANCH_CD,  CD.SUB_BROKER,  
  
 CD.ADDR1,CD.ADDR2,CD.ADDR3,CD.CITY,CD.STATE,CD.NATION,CD.ZIP,                
  
 CD.PAN_NO,  
  
 CD.MOBILE_No,                
   
 CD.EMAIL_ID,                
    
 CASE WHEN CD.bank_ac_type='SB' THEN 'SAVING' WHEN CD.bank_ac_type='CB' THEN 'CURRENT' ELSE CD.bank_ac_type END AS AC_TYPE,                                     
  
 CASE WHEN ISNULL(Gender,'')='M' THEN 'MALE' WHEN ISNULL(Gender,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,  
  
 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                            
  
 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound  

 FROM [196.1.115.200].bsemfss.DBO.mfss_client CD WITH(NOLOCK) WHERE party_code=@PARTY_CODE


 
  
 -- select * from @ClientProfile  
  
 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                                
  
--- select *    FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'            
  
-- select @SubBroker   
  
  
DECLARE @OCCUPATION nvarchar(100)  
  
DECLARE @Client_Name nvarchar(200)  
  
DECLARE @ACCOUNT_STATUS nvarchar(100)  
  
DECLARE @SUB_TYPE nvarchar(200)  
  
DECLARE @POAStatus nvarchar(100)  
  
DECLARE @OPENING_DATE nvarchar(100)  
  
--DECLARE @CLIENT_CODE nvarchar(100)  
  
DECLARE @INCOME nvarchar(100)  
  
DECLARE @AMC nvarchar(200)  
  
DECLARE @EMAIL_ID nvarchar(200)  
  
  
SELECT * INTO #TEMPMASTER FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                                
  
SELECT * INTO #TEMPAMCSCEME FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)           
  
SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)  
  
select * into #tbl_client_master from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE  
  
select * into #tbl_client_POA from   [172.31.16.94].DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE    
  
  
SELECT DISTINCT                                  
  
 @OCCUPATION = TM.DESCRIPTION,  
   
 @Client_Name  = FIRST_HOLD_NAME,   
   
 @ACCOUNT_STATUS = [STATUS],   
   
 @SUB_TYPE = SUB_TYPE,  
    
 @POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,  
  
 @OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                                
   
 --T.TYPE  AS AC_TYPE,  
   
 @INCOME = TIN.DESCRIPTION ,  
  
   
 @AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then AM.REMARKS else T.TEMPLATE_CODE end ,    
   
  
 @EMAIL_ID = EMAIL_ADD   
   
FROM                                
  
  
--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)             
  
--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)            
  
 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)            
   
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK)   
   
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)          
  
   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                          
     
ON T.CLIENT_CODE = P.CLIENT_CODE                       
  
--and   p.holder_indi=1                        
  
LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                                
  
LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                                
  
LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                              
  
LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                       
  
LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                       
  
LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                          
  
WHERE   
  
--T.NISE_PARTY_CODE=@PARTY_CODE  
  
t.CLIENT_CODE =@CLIENT_CODE  
  
  
  
UPDATE @ClientProfile  
  
SET   
 Occupation  = @OCCUPATION,  
  
 ConstitutionType = @SUB_TYPE ,   
   
 Client_Name =  @Client_Name ,  
   
 POAStatus = @POAStatus,  
   
 AccountOpeningDate = @OPENING_DATE,   
    
 IncomeGroup = @INCOME,  
   
 AMCScheme  = @AMC,  
   
 ---Email =  @EMAIL_ID,  
 Email =  CASE ISNULL(Email,'') WHEN '' THEN @EMAIL_ID ELSE Email END,  
   
    ClientID = @CLIENT_CODE  
     
DECLARE @LastTradeDate nvarchar(100)  
  
DECLARE @ECN nvarchar(10)  
  
DECLARE @NBFCStatus nvarchar(10)  
  
DECLARE @RiskCategory nvarchar(100)  
  
DECLARE @Branch_CD nvarchar(20)  
  
DECLARE @Cash_Colleteral NVARCHAR(100)  
  
DECLARE @NonCash_Colleteral NVARCHAR(100)  
  
  
 SELECT @ECN  = ecn,   
  
  @LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) ,   
  
  @NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END,   
  
  @RiskCategory = RiskCategory,  
  
  @Branch_CD = Branch_CD  
  
FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE  
  
    
UPDATE @ClientProfile  
SET   
 ECN  = @ECN,  
  
 LastTradeDate = @LastTradeDate ,   
   
 NBFCStatus = @NBFCStatus,  
   
 Risk = @RiskCategory  
    
 --NewClient_ID = '123'  
   
  
UPDATE @ClientProfile  
SET   
  
 OnlineOffline  = (SELECT top 1 CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)  
  
  
UPDATE @ClientProfile  
  
SET   
  
 SBContactNumber  = (  
  
     SELECT top 1 B.TerMobNo from [196.1.115.182].general.dbo.Vw_RMS_Client_Vertical A   
  
     INNER JOIN [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details B  
  
     ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))  
  
     WHERE A.client = @Party_Code  
  
     )  
  
UPDATE @ClientProfile  
  
SET   
 DealerName  = (  
  
      SELECT top 1 Emp_Name FROM Risk.DBO.emp_info with(nolock) WHERE emp_no IN   
      (  
        SELECT  CASE   
  
         WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer  
  
         WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1  
  
         WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2  
  
         WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name   
  
        FROM [196.1.115.207].ANGELCS.DBO.ANGELCLIENT1 with(nolock)  
  
        WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD   
  
      )  
       )  
  
  
  
DECLARE @SubBroker nvarchar (100)  
  
SELECT @SubBroker = SBTag   from @ClientProfile  
  
    
SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl)   
  
FROM [196.1.115.182].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker  
  
GROUP BY Sub_broker  
  
UPDATE @ClientProfile  
SET SBDepositCash = @Cash_Colleteral  
  
UPDATE @ClientProfile  
SET SBDepositNonCash = @NonCash_Colleteral  
  
UPDATE @ClientProfile  
SET SBPayOut =   
(  
 SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))    
  
 FROM  [196.1.115.199].oraclefin.dbo.sb_balance    
  
 WHERE vtype='PAYMENT' and sbtag = @SubBroker  
  
 GROUP BY vdt  
  
 ORDER BY vdt DESC  
)  
  
  
--UPDATE @ClientProfile  
  
--SET SalesPersonName =   
  
--(  
  
--SELECT distinct VW.Emp_name   
  
-- FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)  
  
--     INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid  
  
--  INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A'   
  
--  WHERE c.party_code= @Party_Code  ---'bknr3290'  
  
--)  
  
UPDATE @ClientProfile  
SET SalesPersonName =   
(  
SELECT INTRODUCER  FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE  
)  
                
UPDATE @ClientProfile  
SET MFStatus =   
(   
  SELECT 'YES' from [196.1.115.200].NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE    
  UNION    
  SELECT 'YES' from [196.1.115.200].BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
)  
  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
Declare @AutoPayOut varchar(100)  
  
DECLARE @OnlineBrokerageDiscount  TABLE  
(  
 Party_Code nvarchar (400),  
 OnlineBrokerageDiscount nvarchar (200)  
)  
 
 DECLARE @sql NVARCHAR(MAX)  
 --Set @Party_Code = 'G31959'   
 SET @sql = 'SELECT * INTO tmptbl      
 FROM OPENROWSET(  
     ''SQLOLEDB'',  
     ''Server=196.1.115.207;TRUSTED_CONNECTION=YES;'',  
     ''set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'  
 -- Print @sql  
 EXEC(@sql)  
  
  
UPDATE @ClientProfile  
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)  
  
UPDATE @ClientProfile  
SET AutoPayOut =  NULL  
  
----------------------------------------------------------Added on 05-07-17--------------------------------------------------------  
  
--UPDATE @ClientProfile  
--SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'  
  
--UPDATE @ClientProfile  
--SET SMS = 'http://196.1.115.212/commonloginnew/home/index'  
  
SELECT  
--CL_CODE,Client_Name,AssociatedAs,Age,Gender,Risk,CSC,Occupation,ConstitutionType,Mobile,IncomeGroup,
--Email,CAddressLine1,CAddressLine2,CAddressLine3,CAddressCity,CAddressState,CAddressCountry,CAddressPin,
--CustomRisk,PANNo,BranchTag,SBTag,SBContactNumber,AccountOpeningDate,AMCScheme,POAStatus,InitialMargin,
--ECN,SMS,DealerName,Recordings,SBPayOut,NBFCStatus,MFStatus,OnlineOffline,LastTradeDate,SalesPersonName,
--WelcomeCall,TCStatus,SBDepositCash,SBDepositNonCash,KYCCopy,FDSCalls,AccountType,AccountStatus
--,ClientID,OnlineBrokerageDiscount,AutoPayOut
 
--,
Client_Name
,CL_CODE
,Mobile
,CAddressLine1
,CAddressPin
,Email
,CAddressLine2
,CAddressCity
,PANNo
,CAddressLine3
,CAddressState
,AccountOpeningDate
,MFStatus
--,AdharStaus
,ECN
,POAStatus
 
 
 
 
 FROM @ClientProfile  order by sr asc




  
DROP TABLE #tbl_client_master  
  
DROP TABLE #tbl_client_POA   
  
DROP TABLE #TEMPMASTER  
  
DROP TABLE #TEMPAMCSCEME   
  
DROP TABLE tmptbl     
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileInfo_opt
-- --------------------------------------------------

 --- exec usp_GenerateClientProfileInfo 'gj3214'   --- 

 --- exec usp_GenerateClientProfileInfo 'G18145'

 --- exec usp_GenerateClientProfileInfo 'rp61'

 --- exec usp_GenerateClientProfileInfo 'C16748'

 --- exec usp_GenerateClientProfileInfo 'hegu393'

 --- exec usp_GenerateClientProfileInfo 'bknr3290'    --- Salesperson

 --- exec usp_GenerateClientProfileInfo 'A83244'  -- Initial Margin

 --- exec usp_GenerateClientProfileInfo 'G31959'  -- Online Discount


CREATE PROC [dbo].[usp_GenerateClientProfileInfo_opt]
(
	@PARTY_CODE nvarchar (40)
)

AS

DECLARE @CLIENT_CODE VARCHAR(100)           

BEGIN


INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateClientProfileInfo', getdate())

DECLARE @ClientProfile  TABLE
(
	CL_CODE nvarchar(100),

	Client_Name nvarchar (400),

	AssociatedAs nvarchar (200),

	Age nvarchar(100),

	Gender nvarchar (10),

	Risk  nvarchar (100),

	CSC nvarchar (100),

	Occupation nvarchar (100),

	ConstitutionType  nvarchar (100),

	Mobile nvarchar (100),

	IncomeGroup nvarchar(200),

	Email nvarchar (200),

	CAddressLine1  nvarchar(1000),

	CAddressLine2  nvarchar(1000),

	CAddressLine3  nvarchar(1000),

	CAddressCity  nvarchar(200),

	CAddressState  nvarchar(200),

	CAddressCountry  nvarchar(200),

	CAddressPin  nvarchar(200),

	CustomRisk  nvarchar(100),  

	PANNo  nvarchar(100),

	BranchTag nvarchar(100),

	SBTag nvarchar(100),

	SBContactNumber nvarchar(100),

	AccountOpeningDate nvarchar(200),

	AMCScheme nvarchar(200),

	POAStatus nvarchar(100),

	InitialMargin nvarchar(100),

	ECN nvarchar(100),

	SMS nvarchar(100),

	DealerName nvarchar(100),

	Recordings nvarchar (100),

	SBPayOut nvarchar (200),

	--DeactivationRemarks nvarchar(1000),

	NBFCStatus nvarchar(100),

	MFStatus nvarchar(100),

	OnlineOffline nvarchar (100),

	LastTradeDate nvarchar(100),

	SalesPersonName nvarchar(100),

	WelcomeCall nvarchar (400),

	TCStatus nvarchar(200),

	SBDepositCash nvarchar (200),

	SBDepositNonCash nvarchar (200),

	KYCCopy nvarchar (200),

	FDSCalls nvarchar (200),

	AccountType nvarchar (100),

	AccountStatus nvarchar(100),

	ClientID nvarchar(100),

	--DPCharges nvarchar(100),

	--PenalCharges nvarchar(100)

	OnlineBrokerageDiscount nvarchar(100),

	AutoPayOut nvarchar(100)
)


INSERT INTO @ClientProfile
(
	CL_CODE,

	BranchTag,

	SBTag,

	CAddressLine1,

	CAddressLine2,

	CAddressLine3,

	CAddressCity,

	CAddressState,

	CAddressCountry,

	CAddressPin,

	PANNo, 

	Mobile,

	Email,

	AccountType, 

	Gender,

	Age

	--ClientID

)



SELECT 

 CD.CL_CODE,CD.BRANCH_CD,  CD.SUB_BROKER,

 CD.L_ADDRESS1,CD.L_ADDRESS2,CD.L_ADDRESS3,CD.L_CITY,CD.L_STATE,CD.L_NATION,CD.L_ZIP,              

 CD.PAN_GIR_NO,

 CD.MOBILE_PAGER,              
 
 CD.EMAIL,              
  
 CASE WHEN CD.AC_TYPE='S' THEN 'SAVING' WHEN CD.AC_TYPE='C' THEN 'CURRENT' ELSE CD.AC_TYPE END AS AC_TYPE,                                   

 CASE WHEN ISNULL(SEX,'')='M' THEN 'MALE' WHEN ISNULL(SEX,'')='F' THEN 'FEMALE' ELSE '' END AS SEX  ,

 --CONVERT(VARCHAR(12),DOB,103) AS DOB,                                          

 CONVERT(int,ROUND(DATEDIFF(hour,DOB,GETDATE())/8766.0,0)) AS AgeYearsIntRound

 FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE

 -- select * from @ClientProfile

 -- SELECT * FROM [172.31.16.94].DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

--- select *    FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE= 'rp61'          

-- select @SubBroker 


DECLARE @OCCUPATION nvarchar(100)

DECLARE @Client_Name nvarchar(200)

DECLARE @ACCOUNT_STATUS nvarchar(100)

DECLARE @SUB_TYPE nvarchar(200)

DECLARE @POAStatus nvarchar(100)

DECLARE @OPENING_DATE nvarchar(100)

--DECLARE @CLIENT_CODE nvarchar(100)

DECLARE @INCOME nvarchar(100)

DECLARE @AMC nvarchar(200)

DECLARE @EMAIL_ID nvarchar(200)


SELECT * INTO #TEMPMASTER FROM AGMUBODPL3.DMAT.dbo.TYPE_MASTER  WITH(NOLOCK)                              

---SELECT *   FROM [172.31.16.94].DMAT.CITRUS_USR.VW_TEMPLATE_MASTER_CI WITH(NOLOCK)         

SET @CLIENT_CODE = (SELECT TOP 1 CLIENT_CODE FROM AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE=@PARTY_CODE)

select * into #tbl_client_master from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE  =@CLIENT_CODE

select * into #tbl_client_POA from   AGMUBODPL3.DMAT.dbo.Tbl_CLIENT_POA WITH(NOLOCK) WHERE CLIENT_CODE  = @CLIENT_CODE       


SELECT distinct                                

	@OCCUPATION = TM.DESCRIPTION,
	
	@Client_Name  = FIRST_HOLD_NAME, 
	
	@ACCOUNT_STATUS = [STATUS], 
	
	@SUB_TYPE = SUB_TYPE,
		
	@POAStatus = CASE WHEN  P.POA_STATUS = 'A' THEN 'Active' ELSE 'Deactive' END,

	@OPENING_DATE = CONVERT(VARCHAR(12),ACTIVE_DATE,103),                              
	
	--T.TYPE  AS AC_TYPE,
	
	@INCOME = TIN.DESCRIPTION ,

	
	@AMC = CASE WHEN ISNULL(T.TEMPLATE_CODE,'')='1' then 'INVESTOR' else T.TEMPLATE_CODE end ,  
	

	@EMAIL_ID = EMAIL_ADD 
	
FROM                              


--[196.1.115.199].SYNERGY.DBO.TBL_CLIENT_MASTER T WITH(NOLOCK)           

--LEFT OUTER JOIN [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA P WITH(NOLOCK)          

 --[172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_MASTER  T WITH(NOLOCK)          
 
 --LEFT OUTER JOIN [172.31.16.94].Dmat.citrus_usr.TBL_CLIENT_POA P WITH(NOLOCK) 
 
   #TBL_CLIENT_MASTER  T WITH(NOLOCK)        

   LEFT OUTER JOIN #TBL_CLIENT_POA P WITH(NOLOCK)                        
   
ON T.CLIENT_CODE = P.CLIENT_CODE                     

--and   p.holder_indi=1                      

LEFT OUTER JOIN #TEMPMASTER TM ON TM.CODE=T.OCCUPATION AND TM.TYPE='OCCUPATION'                              

LEFT OUTER JOIN #TEMPMASTER TIN ON TIN.CODE=T.INCOME_CODE AND TIN.TYPE='INCOME'                              

LEFT OUTER JOIN #TEMPMASTER TBT ON TBT.CODE=T.BANK_ACC_TYPE AND TBT.TYPE='BANK_ACC_TYPE'                            

---LEFT OUTER JOIN #TEMPAMCSCEME AM ON T.TEMPLATE_CODE= AM.TEMPLATE_CODE                     

LEFT OUTER JOIN #TEMPMASTER TE ON TE.CODE=T.EDUCATION_CODE AND TE.TYPE='EDUCATION'                     

LEFT OUTER JOIN #TEMPMASTER TN ON TN.CODE=T.BO_NATIONALITY AND TN.TYPE='NATIONALITY'                        

WHERE 

--T.NISE_PARTY_CODE=@PARTY_CODE

t.CLIENT_CODE =@CLIENT_CODE


UPDATE @ClientProfile

SET 
	Occupation  = @OCCUPATION,

	ConstitutionType =	@SUB_TYPE , 
	
	Client_Name =  @Client_Name ,
	
	POAStatus = @POAStatus,
	
	AccountOpeningDate = @OPENING_DATE, 
		
	IncomeGroup = @INCOME,
	
	AMCScheme  = @AMC,
	
	Email =  @EMAIL_ID,
	
    ClientID = @CLIENT_CODE
	
--UPDATE @ClientProfile

--SET ClientID = @CLIENT_CODE


--SELECT 

--	@OCCUPATION ,

	

--	@ACCOUNT_STATUS , 

	

--	@SUB_TYPE ,



--	@POAStatus ,



--	@OPENING_DATE ,



--	@INCOME ,



--	@AMC ,



--	@EMAIL_ID

	

-- LastTradeDate, ECN, NBFC Client, RiskCategory, 

DECLARE @LastTradeDate nvarchar(100)

DECLARE @ECN nvarchar(10)

DECLARE @NBFCStatus nvarchar(10)

DECLARE @RiskCategory nvarchar(100)

DECLARE @Branch_CD nvarchar(20)

DECLARE @Cash_Colleteral NVARCHAR(100)

DECLARE @NonCash_Colleteral NVARCHAR(100)

SELECT *  INTO #ANGELCLIENT1 FROM  MImansa.ANGELCS.DBO.ANGELCLIENT1 where party_code= @PARTY_CODE
SELECT * INTO  #Vw_RMS_Client_Vertical FROM  [CSOKYC-6].general.dbo.Vw_RMS_Client_Vertical WHERE client = @Party_Code

 SELECT @ECN  = ecn, 

		@LastTradeDate = CONVERT(VARCHAR(12),LastTrade,106) , 

		@NBFCStatus = CASE WHEN NbFcClient = 'N' THEN 'NO' ELSE 'YES' END, 

		@RiskCategory = RiskCategory,

		@Branch_CD = Branch_CD

FROM  #ANGELCLIENT1 where party_code= @PARTY_CODE


--SELECT @ECN  , 

--		@LastTradeDate , 

--		@NBFCStatus ,

--		@RiskCategory


UPDATE @ClientProfile
SET 
	ECN  = @ECN,

	LastTradeDate =	@LastTradeDate , 
	
	NBFCStatus = @NBFCStatus,
	
	Risk = @RiskCategory
		
	--NewClient_ID = '123'
	

UPDATE @ClientProfile
SET 

	OnlineOffline  = (SELECT CASE WHEN (bbb = '4' OR bbb= '134')  THEN 'Online' WHEN (bbb = '2' OR bbb='133') THEN  'Offline' END FROM intranet.mis.dbo.odinclientinfo WHERE PCODE = @PARTY_CODE)


UPDATE @ClientProfile

SET 

	SBContactNumber  = (

					SELECT B.TerMobNo from #Vw_RMS_Client_Vertical A 

					INNER JOIN MIS.SB_COMP.dbo.VW_SubBroker_Details B

					ON LTRIM(RTRIM(A.SB_Name)) = LTRIM(RTRIM(B.TradeName))

					WHERE A.client = @Party_Code

					)

UPDATE @ClientProfile

SET 
	DealerName  = (

						SELECT Emp_Name FROM Risk.DBO.emp_info WHERE emp_no IN 
						(
								SELECT  CASE 

									WHEN RmDealer <> 'UNDEFINED' THEN  RmDealer

									WHEN CommDealer1 <> 'UNDEFINED' THEN  CommDealer1

									WHEN Commdealer2 <> 'UNDEFINED' THEN   Commdealer2

									WHEN CurrencyDealer <> 'UNDEFINED' THEN   CurrencyDealer END AS Name 

								FROM #ANGELCLIENT1 

								WHERE party_code = @PARTY_CODE AND Branch_CD = @Branch_CD 

						)
				   )


--SELECT sum(Cash_Colleteral),sum(NonCash_Colleteral) 

--from [196.1.115.182].[General].dbo.rms_dtclfi where Sub_broker='hegu'

--group by Sub_broker

DECLARE @SubBroker nvarchar (100)

SELECT @SubBroker = SBTag   from @ClientProfile


--SELECT @Cash_Colleteral = SUM(Cash_Colleteral), @NonCash_Colleteral = SUM(NonCash_Colleteral) 

--FROM [196.1.115.182].[General].dbo.rms_dtclfi WHERE Sub_broker = @SubBroker

--GROUP BY Sub_broker

SELECT  @Cash_Colleteral = SUM(SB_CashColl), @NonCash_Colleteral = SUM(SB_NonCashColl) 

FROM [CSOKYC-6].[General].dbo.rms_dtsbfi WHERE Sub_broker = @SubBroker

GROUP BY Sub_broker

UPDATE @ClientProfile
SET SBDepositCash = @Cash_Colleteral

UPDATE @ClientProfile
SET SBDepositNonCash = @NonCash_Colleteral

UPDATE @ClientProfile
SET SBPayOut = 
(
	SELECT  TOP 1 SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  ABCSOORACLEMDLW.oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = @SubBroker

	GROUP BY vdt

	ORDER BY vdt DESC
)


--UPDATE @ClientProfile

--SET SalesPersonName = 

--(

--SELECT distinct VW.Emp_name 

--	FROM [196.1.115.167].kyc.dbo.tbl_kyc_inward t WITH(NOLOCK)

--	    INNER JOIN [196.1.115.167].kyc.dbo.client_inwardregister c on t.fld_srno=c.brid

--		INNER JOIN [196.1.115.237].AngelBroking.dbo.Vu_empContactDetail VW WITH(NOLOCK) on VW.Emp_No=t.fld_introducer and vw.status='A' 

--		WHERE c.party_code= @Party_Code  ---'bknr3290'

--)

UPDATE @ClientProfile
SET SalesPersonName = 
(
SELECT INTRODUCER  FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE CL_CODE=@PARTY_CODE
)
              
UPDATE @ClientProfile
SET MFStatus = 
(	
  SELECT 'YES' from AngelFO.NSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE  
  UNION  
  SELECT 'YES' from AngelFO.BSEMFSS.dbo.MFSS_CLIENT where party_code = @PARTY_CODE
)

UPDATE @ClientProfile
SET InitialMargin = 
(	
 SELECT  SUM(IMargin)  from [CSOKYC-6].[General].dbo.rms_dtclfi where Party_Code = @PARTY_CODE
)


/*

SELECT  SUM( CAST(ISNULL(debit,0)+ isnull(credit,0) as numeric(18,2)))  

	FROM  [196.1.115.199].oraclefin.dbo.sb_balance  

	WHERE vtype='PAYMENT' and sbtag = 'hegu'

	GROUP BY sbtag

*/


--UPDATE @ClientProfile
--SET DPCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('DP')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)

--UPDATE @ClientProfile
--SET PenalCharges = 
--(	
--	SELECT SUM(A.CHARGES_AMT) 
--	FROM [INTRANET].[MISC].DBO.CLI_ACCCHARGES A WITH (NOLOCK)                          
--	INNER JOIN [INTRANET].[MISC].DBO.CLI_ACCCHARGESMASTER B WITH (NOLOCK) ON A.CHARGES_CODE = B.CHARGES_CODE                          
--	WHERE CHARGES_DATE > CUTOFFDATE                                  
--	AND A.PARTY_CODE = @PARTY_CODE AND B.CHARGES_NAME IN ('PENAL')                          
--	GROUP BY A.PARTY_CODE, A.CHARGES_CODE, B.CHARGES_NAME     

--)


----------------------------------------------------------Added on 05-07-17--------------------------------------------------------
Declare @AutoPayOut varchar(100)

DECLARE @OnlineBrokerageDiscount  TABLE
(
	Party_Code nvarchar (400),
	OnlineBrokerageDiscount nvarchar (200)
)

--INSERT INTO @OnlineDiscount  
--EXEC [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @PARTY_CODE

--SET @AutoPayOut = NULL

--UPDATE @ClientProfile
--SET OnlineDiscount  =  (SELECT OnlineBrokerageDiscount FROM @OnlineDiscount)

--UPDATE @ClientProfile
--SET AutoPayOut =  @AutoPayOut

--SELECT * INTO #tmptbl    
--    FROM OPENROWSET ('SQLOLEDB','Server=196.1.115.207;TRUSTED_CONNECTION=YES;' 
--   ,'set fmtonly off exec [196.1.115.207].[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] ''123''') 

	DECLARE @sql NVARCHAR(MAX)
	--Set @Party_Code = 'G31959' 
	SET @sql = 'SELECT * INTO tmptbl    
	FROM OPENROWSET(
					''SQLOLEDB'',
					''Server=Mimansa;TRUSTED_CONNECTION=YES;'',
					''set fmtonly off exec Mimansa.[CRM].[dbo].[USP_GetOnlineBrokerageDiscount_InHouse] @Party_Code =' + convert(varchar(400),@Party_Code) + ''')'
	-- Print @sql
	EXEC(@sql)


UPDATE @ClientProfile
SET OnlineBrokerageDiscount  =  (SELECT OnlineBrokerageDiscount FROM tmptbl)

UPDATE @ClientProfile
SET AutoPayOut =  NULL

----------------------------------------------------------Added on 05-07-17--------------------------------------------------------

UPDATE @ClientProfile
SET Recordings = 'http://angelvconsole.elasticbeanstalk.com/Login'

UPDATE @ClientProfile
SET SMS = 'http://196.1.115.212/commonloginnew/home/index'

SELECT  * FROM @ClientProfile

DROP TABLE #tbl_client_master

DROP TABLE #tbl_client_POA 

DROP TABLE #TEMPMASTER

--DROP TABLE #TEMPAMCSCEME 

DROP TABLE tmptbl   


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateClientProfileSegmentAction
-- --------------------------------------------------
   
--  exec [usp_GenerateClientProfileSegmentAction] 'gj3214'    
    
--- exec [usp_GenerateClientProfileSegmentAction] 'G18145'    
    
--- exec [usp_GenerateClientProfileSegmentAction] 'rp61'    
    
    
    
CREATE PROC [dbo].[usp_GenerateClientProfileSegmentAction]    
    
(    
    
 @PARTY_CODE nvarchar (40)    
    
)    
    
AS    
    
BEGIN    
    
    
    
Declare @ClientSegment  TABLE     
    
(    
    
 Cl_Code nvarchar(40),    
    
 Exchange nvarchar(40),    
    
 Segment nvarchar(100),    
    
 Active_Date nvarchar(100),  --%    
    
 Inactive_From nvarchar(100),    
    
 [Status] nvarchar(40),    
    
 Deactive_value nvarchar(1000),  --%    
    
 Deactive_remarks nvarchar(1000),  --%    
    
 Print_options nvarchar(1000)    
    
)    
    
  
INSERT INTO @ClientSegment    
    
EXEC MIS.KYC.dbo.SPX_GETCLIENTDATAFROMBOFORAUDITOTHERDETAIL_CLIENTPROFILE @PARTY_CODE     
    
--EXEC [196.1.115.167].KYC.dbo.SPX_GETCLIENTDATAFROMBOFORAUDITOTHERDETAIL_CLIENTPROFILE 'gj3214'    
      
SELECT     
Cl_Code ,    
    
 Exchange,    
    
 Segment ,    
    
    
 CONVERT(CHAR(16),CONVERT(DATETIME,LEFT(Active_Date,10),105),106) AS Active_Date,    
 CONVERT(CHAR(16),CONVERT(DATETIME,LEFT(Inactive_From,10),105),106) AS Inactive_From,    
    
 [Status],    
    
 Deactive_value ,  --%    
    
 Deactive_remarks ,  --%    
    
 Print_options     
    
FROM @ClientSegment    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateContractNotes
-- --------------------------------------------------


 /* 

 select * from tbl_UserLog where loginuser  =  'usp_GenerateContractNotes'

 
  exec usp_GenerateContractNotes 'NOD2912', '20170628','20170713'

    exec usp_GenerateContractNotes 'B32692', '01/06/2017','20/07/2017'

  exec usp_GenerateContractNotes 'NOD2912', '28/06/2017','13/07/2017'   


  EXEC [196.1.115.169].esigner.dbo.ecnFinalQuery @ClientCode='NOD2912',@FromDate='20170628',@Todate='20170713',@Exchange='ALL',@DatabaseName='',@FileType='Contract Note'


  */

  
CREATE PROCEDURE [dbo].[usp_GenerateContractNotes]
(
	@ClientCode varchar(100)  
  
	,@FromDate varchar(40)  
  
	,@ToDate varchar(40)  
)
AS  

BEGIN	


--insert into temptable
--values(@FromDate)

--insert into temptable
--values(@ToDate)




insert into temptable
values(@ClientCode)

set @FromDate =  right(@FromDate ,4) +  left(right(@FromDate ,7),2) + left(@FromDate ,2)
set @ToDate =  right(@ToDate ,4) +  left(right(@ToDate ,7),2) + left(@ToDate ,2)


insert into temptable
values(@FromDate)

insert into temptable
values(@ToDate)
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateContractNotes', getdate())  
    
/*

DECLARE @ContractNote TABLE
(
	Documentdate varchar(100)
	,DocumentName varchar(100)
	,DocumentPath varchar(400)
	,ActivityDate datetime
)

INSERT INTO @ContractNote
VALUES(
GETDATE()
,'CN_NOD2912_28062017.pdf', 
'<a href='
+ 'file://\\196.1.115.169\e$\DATANEW\Backup\COMMONCN\28062017\CN_NOD2912_28062017.pdf' + ' target =''_blank'''
+ '>View</a>'
, GETDATE())

SELECT 
	Documentdate As Documentdate 
	,DocumentName  As DocumentName 
	,DocumentPath AS [View]
	,'<a' + ' onclick=DownloadLink(''' + DocumentName  + ''')>' + 'Map Clients</a>' as Download
	,ActivityDate 
FROM @ContractNote

*/



DECLARE @ContractNote TABLE
(
	ViewStatus varchar(40)
	,Documentdate varchar(100)
	,DocumentName varchar(100)
	,Exchange varchar(100)
	,ActivityDate datetime
	,DocumentPath varchar(400)
)

INSERT INTO @ContractNote
(	ViewStatus 
	,Documentdate 
	,DocumentName 
	,Exchange 
	,ActivityDate 
)
EXEC [196.1.115.169].esigner.dbo.ecnFinalQuery 
	@ClientCode=@ClientCode 
	,@FromDate=@FromDate
	,@Todate= @ToDate
	,@Exchange='ALL'
	,@DatabaseName='',@FileType='Contract Note'

 --EXEC [196.1.115.169].esigner.dbo.ecnFinalQuery @ClientCode='NOD2912',@FromDate='20170628',@Todate='20170713',@Exchange='ALL',@DatabaseName='',@FileType='Contract Note'


UPDATE @ContractNote
SET DocumentPath  = 'file://\\196.1.115.169\e$\DATANEW\Backup\COMMONCN\' + LEFT(RIGHT(DocumentName, 12), 8) +  '\' + DocumentName 


SELECT 
	Documentdate 
	,DocumentName  As DocumentName 
	,'<a href='	+ DocumentPath + ' target =''_blank''>View</a>' AS [View]
	,'<a href=''#''' + ' onclick=DownloadLink(''' + DocumentName  + ''')>' + 'Download</a>' AS [Download]
	,ActivityDate 
FROM @ContractNote

--	SELECT  
--'CN_NOD2912_28062017.pdf' as DocumentFileName
--, 'file://\\196.1.115.169\e$\DATANEW\Backup\COMMONCN\' +  left(right('CN_NOD2912_28062017.pdf', 12), 8) +  '\CN_NOD2912_28062017.pdf' AS FilePath

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPCharges
-- --------------------------------------------------
    
/*    
    
  exec usp_GenerateDPCharges 'B14695','13/04/2000','21/04/2016'    
  exec usp_GenerateDPCharges 'ALWR490','01/01/2000','31/12/2016'    
  exec usp_GenerateDPCharges 'M100301','01/01/2017','17/06/2017'    
  exec usp_GenerateDPCharges 'v905', '25/06/2017', '10/07/2017'    
    
  exec usp_GenerateDPCharges 'rp61','2014-2015'    
  exec usp_GenerateDPCharges 'rp61','2015-2016'    
  exec usp_GenerateDPCharges 'rp61','2016-2017'    
    
*/    
    
CREATE PROCEDURE [dbo].[usp_GenerateDPCharges]    
(    
    
 @clt_code AS varchar(10),    
    
 @FinancialYear AS varchar(100)    
)    
    
AS    
    
BEGIN    
    
  INSERT INTO tbl_UserLog (LoginUser, ModifiedDate)    
  VALUES ('usp_GenerateDPCharges', GETDATE())    
    
  DECLARE  @tblDPCharges TABLE    
  (    
 SRNO int,    
 DP_ID varchar(100),    
 VOUCHER_DATE varchar (100),    
 VOUCHER_NO int,    
 VOUCHER_DESCRIPTION varchar (100),    
 NARRATION varchar (1000),    
 DEBIT decimal(18,2),    
 CREDIT decimal(18,2),    
 LEDGER_BALANCE decimal(18,2)    
  )    
    
  DECLARE @ClientID varchar(100)    
  DECLARE @ClientName varchar(100)    
    
  SELECT      
    @ClientID  = Client_Code    
   ,@ClientName = first_hold_name    
  FROM AngelDP4.inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK)     
  WHERE NISE_PARTY_CODE = @clt_code    
    
    
    
  Declare @Date varchar (100)    
  SET @Date = LEFT(@FinancialYear, 4)    
    
    
   IF YEAR(@Date) < '2015'    
   BEGIN     
       
  INSERT INTO @tblDPCharges (    
   SRNO ,    
   DP_ID ,    
   VOUCHER_DATE ,    
   VOUCHER_NO ,    
   VOUCHER_DESCRIPTION ,    
   NARRATION ,    
   DEBIT ,    
   CREDIT ,    
   LEDGER_BALANCE     
  )    
  EXEC MIS.[DEMAT].dbo.[RPT_DP_FINANCIAL_CLIENTPROFILE] @flag=N'0',@finyear=@FinancialYear, @client_code = @clientID ,@type=N'D',    
   @username=N'E10398', @HolderName = @ClientName, @TradingID= @clt_code, @LstDateTime=N''    
   ,@access_to=N'BROKER',@access_code=N'CSO'    
   END     
   ELSE    
   BEGIN     
    
  INSERT INTO @tblDPCharges (    
   SRNO ,    
   DP_ID ,    
   VOUCHER_DATE ,    
   VOUCHER_NO ,    
   VOUCHER_DESCRIPTION ,    
   NARRATION ,    
   DEBIT ,    
   CREDIT ,    
   LEDGER_BALANCE     
  )    
  EXEC Mis.[DEMAT].dbo.[RPT_DP_FINANCIAL] @flag=N'0',@finyear=@FinancialYear, @client_code = @clientID ,@type=N'D',    
   @username=N'E10398', @HolderName = @ClientName, @TradingID= @clt_code, @LstDateTime=N''    
   ,@access_to=N'BROKER',@access_code=N'CSO'     
   END     
        
 SELECT * FROM @tblDPCharges    
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPCharges_25jan2022
-- --------------------------------------------------
  
/*  
  
  exec usp_GenerateDPCharges 'B14695','13/04/2000','21/04/2016'  
  exec usp_GenerateDPCharges 'ALWR490','01/01/2000','31/12/2016'  
  exec usp_GenerateDPCharges 'M100301','01/01/2017','17/06/2017'  
  exec usp_GenerateDPCharges 'v905', '25/06/2017', '10/07/2017'  
  
  exec usp_GenerateDPCharges 'rp61','2014-2015'  
  exec usp_GenerateDPCharges 'rp61','2015-2016'  
  exec usp_GenerateDPCharges 'rp61','2016-2017'  
  
*/  
  
CREATE PROCEDURE [dbo].[usp_GenerateDPCharges_25jan2022]  
(  
  
 @clt_code AS varchar(10),  
  
 @FinancialYear AS varchar(100)  
)  
  
AS  
  
BEGIN  
  
  INSERT INTO tbl_UserLog (LoginUser, ModifiedDate)  
  VALUES ('usp_GenerateDPCharges', GETDATE())  
  
  DECLARE  @tblDPCharges TABLE  
  (  
 SRNO int,  
 DP_ID varchar(100),  
 VOUCHER_DATE varchar (100),  
 VOUCHER_NO int,  
 VOUCHER_DESCRIPTION varchar (100),  
 NARRATION varchar (1000),  
 DEBIT decimal(18,2),  
 CREDIT decimal(18,2),  
 LEDGER_BALANCE decimal(18,2)  
  )  
  
  DECLARE @ClientID varchar(100)  
  DECLARE @ClientName varchar(100)  
  
  SELECT    
    @ClientID  = Client_Code  
   ,@ClientName = first_hold_name  
  FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK)   
  WHERE NISE_PARTY_CODE = @clt_code  
  
  
  
  Declare @Date varchar (100)  
  SET @Date = LEFT(@FinancialYear, 4)  
  
  
   IF YEAR(@Date) < '2015'  
   BEGIN   
     
  INSERT INTO @tblDPCharges (  
   SRNO ,  
   DP_ID ,  
   VOUCHER_DATE ,  
   VOUCHER_NO ,  
   VOUCHER_DESCRIPTION ,  
   NARRATION ,  
   DEBIT ,  
   CREDIT ,  
   LEDGER_BALANCE   
  )  
  EXEC [196.1.115.167].[DEMAT].dbo.[RPT_DP_FINANCIAL_CLIENTPROFILE] @flag=N'0',@finyear=@FinancialYear, @client_code = @clientID ,@type=N'D',  
   @username=N'E10398', @HolderName = @ClientName, @TradingID= @clt_code, @LstDateTime=N''  
   ,@access_to=N'BROKER',@access_code=N'CSO'  
   END   
   ELSE  
   BEGIN   
  
  INSERT INTO @tblDPCharges (  
   SRNO ,  
   DP_ID ,  
   VOUCHER_DATE ,  
   VOUCHER_NO ,  
   VOUCHER_DESCRIPTION ,  
   NARRATION ,  
   DEBIT ,  
   CREDIT ,  
   LEDGER_BALANCE   
  )  
  EXEC [196.1.115.167].[DEMAT].dbo.[RPT_DP_FINANCIAL] @flag=N'0',@finyear=@FinancialYear, @client_code = @clientID ,@type=N'D',  
   @username=N'E10398', @HolderName = @ClientName, @TradingID= @clt_code, @LstDateTime=N''  
   ,@access_to=N'BROKER',@access_code=N'CSO'   
   END   
      
 SELECT * FROM @tblDPCharges  
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPSettlementCharges
-- --------------------------------------------------
  
---  exec usp_GenerateDPSettlementCharges 'v905', '31/12/2015','07/07/2017'   
  
---  exec usp_GenerateDPSettlementCharges 'rp61', '01/01/2016','20/06/2017'   
  
  
CREATE PROCEDURE [dbo].[usp_GenerateDPSettlementCharges]  
(
	@ClientCode varchar(100)  
  
	,@FromDate varchar(40)  
  
	,@ToDate varchar(40)  
)
  
AS  

BEGIN  
  
-- exec [196.1.115.167].demat.dbo.usp_dpchrgs_report @fdt=N'30/12/2015',@tdt=N'07/07/2017',@type=N'P',@fp=N'v905',@ft=N'v905',@access_to=N'BROKER',@access_code=N'CSO'
  
--SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
--SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  

  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateDPSettlementCharges', getdate())  
 
  
  
DECLARE @TransactionDetail TABLE  
(  
	[To_Sett_Type] nvarchar(100),  
	[To_Sett_No] nvarchar(100),  
	[Party_Code] nvarchar(100),  
	[Party_Name] nvarchar(400),  
	[scrip_Code] nvarchar(100),  
	[Scrip_Name] nvarchar(400),  
	ISIN nvarchar(400),  
	[Transaction_Date] nvarchar(40),  
	[Transaction_Type] nvarchar(1000),  
	Qty decimal(18,0),
	Recieved  decimal(18,2),
	Given  decimal(18,2),
	Charge1  decimal(18,2),
	Charge2   decimal(18,2),
	ServTax   decimal(18,2),
	ServTax2   decimal(18,2),
	[EDU_CESS1]   decimal(18,2),
	[EDU_CESS2]   decimal(18,2),
	SHEC1   decimal(18,2),
	SHEC2  decimal(18,2),
	SBC   decimal(18,2),
	KKC    decimal(18,2),
	CGST    decimal(18,2),
	SGST    decimal(18,2),
	UGST    decimal(18,2),
	IGST    decimal(18,2),
	[Total_Charges] decimal(18,2),
	PARTY_STATE  nvarchar(400),  
	Region  nvarchar(400),  
	Branch  nvarchar(400),  
	Sub_Broker  nvarchar(100),  
	[Client_Type]  nvarchar(100),  
	ARPC  nvarchar(100),  
	ExpAmt  nvarchar(100)  
)  
    

INSERT INTO @TransactionDetail   
EXEC MIS.demat.dbo.usp_dpchrgs_report @fdt=@FromDate,@tdt=@ToDate,@type=N'P',@fp=@ClientCode,@ft=@ClientCode,@access_to=N'BROKER',@access_code=N'CSO'

--- exec MIS.demat.dbo.usp_dpchrgs_report @fdt=N'30/12/2015',@tdt=N'07/07/2017',@type=N'P',@fp=N'v905',@ft=N'v905',@access_to=N'BROKER',@access_code=N'CSO'

SELECT  *   FROM @TransactionDetail  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPStatment
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GenerateDPStatment]    
    
@ClientCode varchar(100)    
    
--,@FromDate varchar(400)    
    
--,@ToDate varchar(400)    
    
AS    
    
    
    
DECLARE @ClientID varchar(100)    
    
    
BEGIN    
    
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES ('usp_GenerateDPStatment', getdate())    
    
    
    
SELECT  @ClientID = CLIENT_CODE FROM [AngelDP4].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = @ClientCode    
    
--- SELECT  CLIENT_CODE FROM [172.31.16.108].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = 'rp61'    
    
  ---EXEC [MIS].DEMAT.dbo.USP_DP_CUSTOMER_PROFILE_Inhouse1 @ClientID,'broker','cso'     
    
--exec [MIS].DEMAT.dbo.[USP_DP_CUSTOMER_PROFILE_CLIENT_PROFILIER] '1203320002017026','SBMAST','PPSGRP'     
    
    
    
DECLARE @TransactionMaster  TABLE    
(    
 CLIENT_ID  nvarchar (1000),    
 CLIENT_CODE  nvarchar (1000),    
 ACCTYPE  nvarchar (1000),    
 NAME  nvarchar (1000),    
 FATHER_HUSBAND_NAME  nvarchar (1000),    
 DOB  nvarchar (1000),    
 ACC_STATUS  nvarchar (1000),    
 OPEN_DATE  nvarchar (1000),    
 CLOSE_DATE  nvarchar (1000),    
 CADD1  nvarchar (1000),    
 CADD2  nvarchar (1000),    
 CADD3  nvarchar (1000),    
 CCITY  nvarchar (1000),    
 CSTATE  nvarchar (1000),    
 CCOUNTRY  nvarchar (1000),    
 CPIN  nvarchar (1000),    
 CPHONE  nvarchar (1000),    
 CFAX  nvarchar (1000),    
 CMOBILE  nvarchar (1000),    
 SH_NAME  nvarchar (1000),    
 SH_PAN  nvarchar (1000),    
 TH_NAME  nvarchar (1000),    
 TH_PAN  nvarchar (1000),    
 EMAIL  nvarchar (1000),    
 ECN  nvarchar (1000),    
 FHPAN  nvarchar (1000),    
 SMARTFLAG  nvarchar (1000),    
 FOREIGN_ADDR1  nvarchar (1000),    
 FOREIGN_ADDR2  nvarchar (1000),    
 FOREIGN_ADDR3  nvarchar (1000),    
 FOREIGN_CITY  nvarchar (1000),    
 FOREIGN_STATE  nvarchar (1000),    
 FOREIGN_CNTRY  nvarchar (1000),    
 FOREIGN_ZIP  nvarchar (1000),    
 FOREIGN_PHONE  nvarchar (1000),    
 FOREIGN_FAX  nvarchar (1000),    
 sub_type  nvarchar (1000),    
 bank_name  nvarchar (1000),    
 bank_accno  nvarchar (1000),    
 micr_code  nvarchar (1000),    
 IFSC  nvarchar (1000),    
 BANK_ADD1  nvarchar (1000),    
 BANK_ADD2  nvarchar (1000),    
 BANK_ADD3  nvarchar (1000),    
 BANK_ZIP  nvarchar (1000),    
 RGESS_FLAG  nvarchar (1000),    
 BSDA_FLAG  nvarchar (1000),    
 ELECTRONIC_DIVIDEND  nvarchar (1000),    
 Nominee_Flag  nvarchar (1000),    
 Minor_Flag  nvarchar (1000),    
 NOMI_GUard_name  nvarchar (1000),    
 NISE_PARTY_CODE  nvarchar (1000),    
 template_code  nvarchar (1000),    
 Category  nvarchar (1000)    
)    
    
INSERT INTO @TransactionMaster     
EXEC [MIS].DEMAT.dbo.[USP_DP_CUSTOMER_PROFILE_CLIENT_PROFILIER] @ClientID,'broker','cso'     
    
-- select * from @DomainHistory     
    
SELECT     
 CLIENT_ID,     
 ACC_STATUS,     
 ACCTYPE,     
 Category,     
 sub_type,     
 NAME,     
 CADD1 + ', ' + CADD2 + ', ' + CADD3 + ', ' + CCITY + '-' + CPIN  + ', ' + CSTATE + ', ' +  CCOUNTRY  AS [Address],     
 CMOBILE      
FROM @TransactionMaster    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPStatment_25jan2022
-- --------------------------------------------------
-- exec [usp_GenerateDPStatment] 'rp61'    
    
    
CREATE PROCEDURE [dbo].[usp_GenerateDPStatment_25jan2022]    
    
@ClientCode varchar(100)    
    
--,@FromDate varchar(400)    
    
--,@ToDate varchar(400)    
    
AS    
    
    
    
DECLARE @ClientID varchar(100)    
    
    
BEGIN    
    
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES ('usp_GenerateDPStatment', getdate())    
    
    
    
SELECT  @ClientID = CLIENT_CODE FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = @ClientCode    
    
--- SELECT  CLIENT_CODE FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = 'rp61'    
    
  ---EXEC [MIS].DEMAT.dbo.USP_DP_CUSTOMER_PROFILE_Inhouse1 @ClientID,'broker','cso'     
    
--exec [MIS].DEMAT.dbo.[USP_DP_CUSTOMER_PROFILE_CLIENT_PROFILIER] '1203320002017026','SBMAST','PPSGRP'     
    
    
    
DECLARE @TransactionMaster  TABLE    
(    
 CLIENT_ID  nvarchar (1000),    
 CLIENT_CODE  nvarchar (1000),    
 ACCTYPE  nvarchar (1000),    
 NAME  nvarchar (1000),    
 FATHER_HUSBAND_NAME  nvarchar (1000),    
 DOB  nvarchar (1000),    
 ACC_STATUS  nvarchar (1000),    
 OPEN_DATE  nvarchar (1000),    
 CLOSE_DATE  nvarchar (1000),    
 CADD1  nvarchar (1000),    
 CADD2  nvarchar (1000),    
 CADD3  nvarchar (1000),    
 CCITY  nvarchar (1000),    
 CSTATE  nvarchar (1000),    
 CCOUNTRY  nvarchar (1000),    
 CPIN  nvarchar (1000),    
 CPHONE  nvarchar (1000),    
 CFAX  nvarchar (1000),    
 CMOBILE  nvarchar (1000),    
 SH_NAME  nvarchar (1000),    
 SH_PAN  nvarchar (1000),    
 TH_NAME  nvarchar (1000),    
 TH_PAN  nvarchar (1000),    
 EMAIL  nvarchar (1000),    
 ECN  nvarchar (1000),    
 FHPAN  nvarchar (1000),    
 SMARTFLAG  nvarchar (1000),    
 FOREIGN_ADDR1  nvarchar (1000),    
 FOREIGN_ADDR2  nvarchar (1000),    
 FOREIGN_ADDR3  nvarchar (1000),    
 FOREIGN_CITY  nvarchar (1000),    
 FOREIGN_STATE  nvarchar (1000),    
 FOREIGN_CNTRY  nvarchar (1000),    
 FOREIGN_ZIP  nvarchar (1000),    
 FOREIGN_PHONE  nvarchar (1000),    
 FOREIGN_FAX  nvarchar (1000),    
 sub_type  nvarchar (1000),    
 bank_name  nvarchar (1000),    
 bank_accno  nvarchar (1000),    
 micr_code  nvarchar (1000),    
 IFSC  nvarchar (1000),    
 BANK_ADD1  nvarchar (1000),    
 BANK_ADD2  nvarchar (1000),    
 BANK_ADD3  nvarchar (1000),    
 BANK_ZIP  nvarchar (1000),    
 RGESS_FLAG  nvarchar (1000),    
 BSDA_FLAG  nvarchar (1000),    
 ELECTRONIC_DIVIDEND  nvarchar (1000),    
 Nominee_Flag  nvarchar (1000),    
 Minor_Flag  nvarchar (1000),    
 NOMI_GUard_name  nvarchar (1000),    
 NISE_PARTY_CODE  nvarchar (1000),    
 template_code  nvarchar (1000),    
 Category  nvarchar (1000)    
)    
    
INSERT INTO @TransactionMaster     
EXEC [MIS].DEMAT.dbo.[USP_DP_CUSTOMER_PROFILE_CLIENT_PROFILIER] @ClientID,'broker','cso'     
    
-- select * from @DomainHistory     
    
SELECT     
 CLIENT_ID,     
 ACC_STATUS,     
 ACCTYPE,     
 Category,     
 sub_type,     
 NAME,     
 CADD1 + ', ' + CADD2 + ', ' + CADD3 + ', ' + CCITY + '-' + CPIN  + ', ' + CSTATE + ', ' +  CCOUNTRY  AS [Address],     
 CMOBILE      
FROM @TransactionMaster    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPStatmentTransaction
-- --------------------------------------------------
---- exec usp_GenerateDPStatmentTransaction 'rp61', '2016-06-01','2016-09-01'    
    
---  exec usp_GenerateDPStatmentTransaction 'rp61', '06/04/2016','09/01/2016'     
    
---  exec usp_GenerateDPStatmentTransaction 'rp61', '01/01/2016','20/06/2016'     
    
    
    
CREATE PROCEDURE [dbo].[usp_GenerateDPStatmentTransaction]    
    
@ClientCode varchar(100)    
    
,@FromDate varchar(400)    
    
,@ToDate varchar(400)    
    
AS    
BEGIN    
    
DECLARE @ClientID varchar(100)    
    
--exec [196.1.115.167].demat.dbo.USP_DP_Transaction_Report '2016-07-01 00:00:00.000','2016-09-30 00:00:00.000','rp61','1203320006951435','all','broker','cso' ,'',''                
    
    
--declare @FDate datetime    
--declare @TDate datetime    
    
--SELECT @FDate=  CONVERT(CHAR(19), CONVERT(DATETIME, @FromDate, 3), 120)    
--SELECT @TDate=  CONVERT(CHAR(19), CONVERT(DATETIME, @ToDate, 3), 120)    
    
    
    
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)    
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)    
    
--select @FromDate    
--select @ToDate    
    
             
    
SELECT  @ClientID = CLIENT_CODE FROM AngelDP4.inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = @ClientCode    
    
--select @ClientID    
    
    
DECLARE @TransactionDetail TABLE    
(    
 SERIAL_NO  nvarchar(400),    
 BKGDATE  nvarchar(100),    
 COMPANY_NAME  nvarchar(400),    
 REF_NO  nvarchar(100),    
 [DESCRIPTION]  nvarchar(1000),    
 OPN  nvarchar(100),    
 DEBIT  nvarchar(100),    
 CREDIT  nvarchar(100),    
 ISIN  nvarchar(4000),    
 CTR_SET_No  nvarchar(400)    
)    
    
INSERT INTO @TransactionDetail     
EXEC MIS.demat.dbo.USP_DP_Transaction_Report  @FromDate, @ToDate,@ClientCode,@ClientID,'all','broker','cso' ,'',''                         
    
--EXEC MIS.demat.dbo.USP_DP_Transaction_Report  '2016-06-04', '2016-09-01','rp61','1203320006684234','all','broker','cso' ,'',''                         
    
    
SELECT     
    
 BKGDATE,    
 --CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([BKGDATE], '')), 101) as [BKGDATE1],     
 --CASE WHEN ISNULL(BKGDATE, '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([BKGDATE], '')), 101)  ELSE '' END [BKGDATE1],    
     
 COMPANY_NAME,    
 REF_NO,    
 [DESCRIPTION],    
 CTR_SET_No,    
 CAST(ROUND(OPN,2) as numeric(18,2)) OPN,    
 CAST(ROUND(DEBIT,2) as numeric(18,2)) DEBIT,    
 CAST(ROUND(CREDIT,2) as numeric(18,2)) CREDIT,    
 ISIN    
    
FROM @TransactionDetail    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateDPStatmentTransaction_25jan2022
-- --------------------------------------------------
---- exec usp_GenerateDPStatmentTransaction 'rp61', '2016-06-01','2016-09-01'    
    
---  exec usp_GenerateDPStatmentTransaction 'rp61', '06/04/2016','09/01/2016'     
    
---  exec usp_GenerateDPStatmentTransaction 'rp61', '01/01/2016','20/06/2016'     
    
    
    
CREATE PROCEDURE [dbo].[usp_GenerateDPStatmentTransaction_25jan2022]    
    
@ClientCode varchar(100)    
    
,@FromDate varchar(400)    
    
,@ToDate varchar(400)    
    
AS    
BEGIN    
    
DECLARE @ClientID varchar(100)    
    
--exec [196.1.115.167].demat.dbo.USP_DP_Transaction_Report '2016-07-01 00:00:00.000','2016-09-30 00:00:00.000','rp61','1203320006951435','all','broker','cso' ,'',''                
    
    
--declare @FDate datetime    
--declare @TDate datetime    
    
--SELECT @FDate=  CONVERT(CHAR(19), CONVERT(DATETIME, @FromDate, 3), 120)    
--SELECT @TDate=  CONVERT(CHAR(19), CONVERT(DATETIME, @ToDate, 3), 120)    
    
    
    
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)    
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)    
    
--select @FromDate    
--select @ToDate    
    
             
    
SELECT  @ClientID = CLIENT_CODE FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER WITH(NOLOCK) WHERE NISE_PARTY_CODE = @ClientCode    
    
--select @ClientID    
    
    
DECLARE @TransactionDetail TABLE    
(    
 SERIAL_NO  nvarchar(400),    
 BKGDATE  nvarchar(100),    
 COMPANY_NAME  nvarchar(400),    
 REF_NO  nvarchar(100),    
 [DESCRIPTION]  nvarchar(1000),    
 OPN  nvarchar(100),    
 DEBIT  nvarchar(100),    
 CREDIT  nvarchar(100),    
 ISIN  nvarchar(4000),    
 CTR_SET_No  nvarchar(400)    
)    
    
INSERT INTO @TransactionDetail     
EXEC MIS.demat.dbo.USP_DP_Transaction_Report  @FromDate, @ToDate,@ClientCode,@ClientID,'all','broker','cso' ,'',''                         
    
--EXEC MIS.demat.dbo.USP_DP_Transaction_Report  '2016-06-04', '2016-09-01','rp61','1203320006684234','all','broker','cso' ,'',''                         
    
    
SELECT     
    
 BKGDATE,    
 --CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([BKGDATE], '')), 101) as [BKGDATE1],     
 --CASE WHEN ISNULL(BKGDATE, '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([BKGDATE], '')), 101)  ELSE '' END [BKGDATE1],    
     
 COMPANY_NAME,    
 REF_NO,    
 [DESCRIPTION],    
 CTR_SET_No,    
 CAST(ROUND(OPN,2) as numeric(18,2)) OPN,    
 CAST(ROUND(DEBIT,2) as numeric(18,2)) DEBIT,    
 CAST(ROUND(CREDIT,2) as numeric(18,2)) CREDIT,    
 ISIN    
    
FROM @TransactionDetail    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateEquityReport
-- --------------------------------------------------
----  exec [usp_GenerateEquityReport] 'bSECM','rp61','04/06/2015','01/09/2016'  
  
----  exec [usp_GenerateEquityReport] 'bSECM','rp61','06/04/2016','21/09/2016'  
  
CREATE PROCEDURE [dbo].[usp_GenerateEquityReport]  
  
@co_code as varchar(10),  
  
@client as varchar(10),  
  
@FromDate as varchar (100),  
  
@ToDate as varchar (100)  
  
--@userid as varchar(15),          
--@access_To as varchar(10),          
--@access_Code as varchar(10)       
AS  
  
BEGIN   
  
--SET FMTONLY OFF  
  
  
--SELECT @FromDate=  CONVERT(VARCHAR(10), @FromDate, 101)   
--SELECT @ToDate=  CONVERT(VARCHAR(10), @ToDate, 101)   
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateEquityReport', getdate())  
  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--SELECT @FromDate  
--SELECT @ToDate  
           
  
--DECLARE @EquityReport TABLE  
--(  
--srno  nvarchar(10),  
--[VoucDate]  nvarchar(100),  
--[VoucType]  nvarchar(100),  
--[VoucNo]  nvarchar(100),  
--Narration  nvarchar(1000),  
--debit  int,  
--Credit  int,  
--Amount  int,  
--Balance  int,  
--[VoucEff]  nvarchar(100),  
--[ChequeNo]  nvarchar(100)  
--)  
  
  
DECLARE @EquityReport TABLE  
(  
srno  nvarchar(10),  
[VoucDate]  nvarchar(100),  
[VoucType]  nvarchar(100),  
[VoucNo]  nvarchar(100),  
Narration  nvarchar(1000),  
debit  decimal (18,2),  
Credit  decimal (18,2),  
Amount  decimal (18,2),  
Balance  decimal (18,2),  
[VoucEff]  nvarchar(100),  
[ChequeNo]  nvarchar(100)  
)  
  
  
INSERT INTO @EquityReport(  
srno,  
[VoucDate],  
[VoucType],  
[VoucNo],  
Narration,  
debit,  
Credit,  
Amount,  
Balance,  
[VoucEff],  
[ChequeNo]  
)  
  
-- EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC_ClientProfilier @client,'','%','E01089','broker','cso'  
  
--- exec [196.1.115.182].[General].dbo.[Rpt_FinYearCliLedger_ClientProfilier] 'bSECM','rp61','03-04-2014','09-09-2016'  
  
EXEC [CSOKYC-6].[General].dbo.[Rpt_FinYearCliLedger_ClientProfilier] @co_code, @client,@FromDate,@ToDate  
  
--select 'Total of Debit'  
  
--SELECT SUM (Debit) FROM  @EquityReport  
  
Declare @Count int  
  
select @Count = count(0) FROM @EquityReport  
  
  
IF (@Count > 0)  
  
BEGIN  
INSERT INTO @EquityReport(Narration)  
VALUES('Total')  
  
UPDATE @EquityReport  
SET  Debit = (SELECT SUM (Debit) FROM  @EquityReport)  
WHERE Narration ='Total'  
  
  
UPDATE @EquityReport  
SET  Credit = (SELECT SUM (Credit) FROM  @EquityReport)  
WHERE Narration ='Total'  
  
INSERT INTO @EquityReport(Narration)  
VALUES('Net Balance')  
  
UPDATE @EquityReport  
SET  Credit = (SELECT sum(Credit) + sum(Debit) FROM  @EquityReport Where Narration <> 'Total')  
WHERE Narration ='Net Balance'  
  
--UPDATE @EquityReport  
--SET  VoucDate= ''  
--, VoucEff=''  
--WHERE Narration ='Total'  
  
  
  
END  
  
SELECT   
 srno,  
 --ISNULL([VoucDate], '') as [VoucDate1],  
 --CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucDate], '')), 106) AS [VoucDate],  
 CASE WHEN ISNULL([VoucDate], '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucDate], '')), 106)  ELSE '' END [VoucDate],  
 ISNULL([VoucType], '') as [VoucType],  
 ISNULL([VoucNo], '') as [VoucNo],  
 ISNULL(Narration, '') as Narration,  
 debit,  
 Credit,  
 Amount,  
 Balance,  
 CASE WHEN ISNULL([VoucEff], '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucEff], '')), 106)  ELSE '' END [VoucEff],  
 ISNULL([ChequeNo], '') as [ChequeNo]  
  
FROM  @EquityReport   
   
-- select 'Debit'  
-- SELECT SUM (Debit) FROM  @EquityReport  
  
  
-- select 'Credit'  
-- SELECT SUM (Credit) FROM  @EquityReport  
  
-- select '2815138'      
  
-- select '141079'  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateEquityReport_Ipartner
-- --------------------------------------------------

----  exec [usp_GenerateEquityReport] 'bSECM','rp61','04/06/2015','01/09/2016'  
  
----  exec [usp_GenerateEquityReport] 'bSECM','rp61','06/04/2016','21/09/2016'  
  
CREATE PROCEDURE [dbo].[usp_GenerateEquityReport_Ipartner]  
  
@co_code as varchar(10),  
  
@client as varchar(10),  
  
@FromDate as varchar (100),  
  
@ToDate as varchar (100)  
  
--@userid as varchar(15),          
--@access_To as varchar(10),          
--@access_Code as varchar(10)       
AS  
  
BEGIN   
  
--SET FMTONLY OFF  
  
  
--SELECT @FromDate=  CONVERT(VARCHAR(10), @FromDate, 101)   
--SELECT @ToDate=  CONVERT(VARCHAR(10), @ToDate, 101)   
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateEquityReport', getdate())  
  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--SELECT @FromDate  
--SELECT @ToDate  
           
  
--DECLARE @EquityReport TABLE  
--(  
--srno  nvarchar(10),  
--[VoucDate]  nvarchar(100),  
--[VoucType]  nvarchar(100),  
--[VoucNo]  nvarchar(100),  
--Narration  nvarchar(1000),  
--debit  int,  
--Credit  int,  
--Amount  int,  
--Balance  int,  
--[VoucEff]  nvarchar(100),  
--[ChequeNo]  nvarchar(100)  
--)  
  
  
DECLARE @EquityReport TABLE  
(  
srno  nvarchar(10),  
[VoucDate]  nvarchar(100),  
[VoucType]  nvarchar(100),  
[VoucNo]  nvarchar(100),  
Narration  nvarchar(1000),  
debit  decimal (18,2),  
Credit  decimal (18,2),  
Amount  decimal (18,2),  
Balance  decimal (18,2),  
[VoucEff]  nvarchar(100),  
[ChequeNo]  nvarchar(100)  
)  
  
  
INSERT INTO @EquityReport(  
srno,  
[VoucDate],  
[VoucType],  
[VoucNo],  
Narration,  
debit,  
Credit,  
Amount,  
Balance,  
[VoucEff],  
[ChequeNo]  
)  
  
-- EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC_ClientProfilier @client,'','%','E01089','broker','cso'  
  
--- exec [196.1.115.182].[General].dbo.[Rpt_FinYearCliLedger_ClientProfilier] 'bSECM','rp61','03-04-2014','09-09-2016'  
  
EXEC [CSOKYC-6].[General].dbo.[Rpt_FinYearCliLedger_ClientProfilier] @co_code, @client,@FromDate,@ToDate  
  
--select 'Total of Debit'  
  
--SELECT SUM (Debit) FROM  @EquityReport  
  
Declare @Count int  
  
select @Count = count(0) FROM @EquityReport  
  
  
IF (@Count > 0)  
  
BEGIN  
INSERT INTO @EquityReport(Narration)  
VALUES('Total')  
  
UPDATE @EquityReport  
SET  Debit = (SELECT SUM (Debit) FROM  @EquityReport)  
WHERE Narration ='Total'  
  
  
UPDATE @EquityReport  
SET  Credit = (SELECT SUM (Credit) FROM  @EquityReport)  
WHERE Narration ='Total'  
  
INSERT INTO @EquityReport(Narration)  
VALUES('Net Balance')  
  
UPDATE @EquityReport  
SET  Credit = (SELECT sum(Credit) + sum(Debit) FROM  @EquityReport Where Narration <> 'Total')  
WHERE Narration ='Net Balance'  
  
--UPDATE @EquityReport  
--SET  VoucDate= ''  
--, VoucEff=''  
--WHERE Narration ='Total'  
  
  
  
END  
  
SELECT   
 srno,  
 --ISNULL([VoucDate], '') as [VoucDate1],  
 --CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucDate], '')), 106) AS [VoucDate],  
 CASE WHEN ISNULL([VoucDate], '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucDate], '')), 106)  ELSE '' END [VoucDate],  
 ISNULL([VoucType], '') as [VoucType],  
 ISNULL([VoucNo], '') as [VoucNo],  
 ISNULL(Narration, '') as Narration,  
 debit,  
 Credit,  
 Amount,  
 Balance,  
 CASE WHEN ISNULL([VoucEff], '') <>'' THEN  CONVERT(varchar(100), CONVERT(SMALLDATETIME, ISNULL([VoucEff], '')), 106)  ELSE '' END [VoucEff],  
 ISNULL([ChequeNo], '') as [ChequeNo]  
  
FROM  @EquityReport   
   
-- select 'Debit'  
-- SELECT SUM (Debit) FROM  @EquityReport  
  
  
-- select 'Credit'  
-- SELECT SUM (Credit) FROM  @EquityReport  
  
-- select '2815138'      
  
-- select '141079'  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateMCDXCDSScriptDetails
-- --------------------------------------------------
  
-- EXEC usp_GenerateMCDXCDSScriptDetails 'A10071', '01/08/2014', '24/12/2017', '', ''  
-- exec AngelCommodity.MCDXCDS.dbo.MCDSAUDA   'AUG 1 2014', 'dec 24 2017','A10071','',''  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateMCDXCDSScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelCommodity.MCDXCDS.dbo.MCDSAUDA  @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
   
-- exec AngelCommodity.MCDXCDS.dbo.MCDSAUDA   'AUG 1 2014', 'dec 24 2017','A10071','',''  
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
--SELECT @Count  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
  
  
--UPDATE @CalculatedScriptReport  
--SET  PRATE = (SELECT (SUM(PRATE)/@Count) FROM  @CalculatedScriptReport)  
--WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
--UPDATE @CalculatedScriptReport  
--SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/sum(case when SRATE > 0 then 1 else 0 end)) FROM  @CalculatedScriptReport)  
--WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
--UPDATE @CalculatedScriptReport  
--SET  NETRate = (SELECT (SUM(NETRate)/@Count) FROM  @CalculatedScriptReport)  
--WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
--SELECT convert(varchar, SAUDA_DATE, 106) AS SAUDADATE, convert(varchar, expirydate , 106) AS  Expiry_Date , * from @ScriptReport   
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateMCDXScriptDetails
-- --------------------------------------------------
-- EXEC usp_GenerateMCDXScriptDetails 'A74100', '01/08/2014', '24/12/2017', '', ''  
-- exec AngelCommodity.MCDX.dbo.MCXSAUDA   'AUG 1 2014', 'dec 24 2017','A74100','',''  
  
  
CREATE  PROCEDURE [dbo].[usp_GenerateMCDXScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelCommodity.MCDX.dbo.MCXSAUDA  @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
   
-- exec AngelCommodity.MCDX.dbo.MCXSAUDA   'AUG 1 2014', 'dec 24 2017','A74100','',''  
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
--SELECT @Count  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateMFAUM
-- --------------------------------------------------
  
/*  
  
 EXEC usp_GenerateMFNFO   
  
*/  
  
CREATE PROCEDURE [dbo].[usp_GenerateMFAUM](  
 @clientcode varchar(50) = null  
)  
AS    
BEGIN  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateMFAUM', getdate())  
  
  
 DECLARE @AUM TABLE   
 (  
  mf_cocode varchar(100)  
  , mf_schcode varchar(100)  
  , sch_name  varchar(1000)  
  , launc_date  varchar(100)  
  , cldate  varchar(100)  
  , FundClass varchar(1000)  
  , isin varchar(100)  
 )  
  
 INSERT INTO @AUM  
 EXEC [ABVSAWUARQ1].NXT.[dbo].[usp_MF_Get_NFO]  
  
 SELECT * FROM @AUM  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateMFDashboard
-- --------------------------------------------------
/*
	EXEC usp_GenerateMFDashboard '06-Jun-2018',	'06-Jun-2018',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC usp_GenerateMFDashboard  @PanNoSearch= 'CLBPS5210C'
	EXEC usp_GenerateMFDashboard null,	null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC usp_GenerateMFDashboard '06-Jun-2018','06-Jun-2018',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC usp_GenerateMFDashboard NULL,NULL,'P103926',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC usp_GenerateMFDashboard NULL,NULL,'N69633',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC usp_GenerateMFDashboard NULL,NULL,'S219823',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	EXEC [196.1.115.167].[KYC_CI].dbo.spx_GetMfkycDashboardAll  '06-Jun-2018','06-Jun-2018',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
*/

CREATE PROCEDURE [dbo].[usp_GenerateMFDashboard]
(
	@FromDateSearch varchar(11) = NULL,
	@ToDateSearch varchar(11) = NULL,
	@ClientCodeSearch varchar(10) = NULL,
	@PanNoSearch varchar(10) = NULL,
	@ApplicationNoSearch varchar(20) = NULL,
	@MobileNoSearch varchar(20) = NULL,
	@EmailIdSearch varchar(20) = NULL,
	@PaymentStatusSearch varchar(10) = NULL,
	@OrderPlacedSearch varchar(20) = NULL,
	@OrderStatus varchar(20) = NULL,
	@InvestmentType varchar(50) = NULL
)
AS
BEGIN


--EXEC spx_GetMfkycDashboardAll '06-Jun-2018',	'06-Jun-2018',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
-- EXEC [196.1.115.167].[KYC_CI].dbo.spx_GetMfkycDashboardAll '06-Jun-2018',	'06-Jun-2018',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
-- EXEC spx_GetMfkycDashboardAll @PanNoSearch= 'CLBPS5210C'



INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GenerateMFDashboard', getdate())


DECLARE @MFDashboard TABLE (
	SrNo int identity(1,1)
	,MfKycId varchar (400) NULL
	,Name varchar (400) NULL
	,ClientCode varchar (400) NULL
	,Created_Date varchar (400) NULL
	,Amount varchar (400) NULL
	,Journey varchar (400) NULL
	,[Source] varchar (100) NULL
	,Panno varchar (100) NULL
	,Application_No varchar (400) NULL
	,PlanSelection  varchar (100) NULL
	,IdentityDetails varchar (100) NULL
	,BankDetails varchar (100) NULL
	,Payment varchar (100) NULL
	,PersonalInfo varchar (100) NULL	 
	,DataPush varchar (100) NULL
	,CodeGenerated varchar (100) NULL
	,CitrusPushed varchar (100) NULL
	,UccPushed varchar (100) NULL	 
	,OnepagerUploaded varchar (100) NULL
	,CKycPushed varchar (100) NULL
	,KraPushed varchar (100) NULL
	,RegisteredForTrade varchar (100) NULL
	,PushedToOdin varchar (100) NULL
	,FatcaUploaded varchar (100) NULL
	,OrderPlaced varchar (100) NULL
	,[Signature] varchar (100) NULL
	,OrderStatus varchar (100) NULL
	,Schemes varchar (4000) NULL
	,OnepagerPath varchar (4000) NULL
	,MandateFilePath varchar (4000) NULL
	,[StpNonStp] varchar (400) NULL 
	,InvestmentType varchar (4000) NULL
	,BankAccountNoInitial varchar (400) NULL
	,IfscCodeInitial varchar (400) NULL
	,IsImps varchar (100) NULL
	,PaymentDate varchar (400) NULL
	,AccountOpeningDate varchar (400) NULL
	,EyeBallStatus varchar (400) NULL
	,EyeBallApprovedDate varchar (400) NULL
	,PaymentType varchar (400) NULL
	,City varchar (400) NULL
	,ReceiptEntryDate varchar (400) NULL
	,JVBoPushedDate varchar (400) NULL
)
INSERT INTO @MFDashboard 
EXEC MIS.[KYC_CI].dbo.spx_GetMfkycDashboardAll 	@FromDateSearch,@ToDateSearch,@ClientCodeSearch,@PanNoSearch,@ApplicationNoSearch,@MobileNoSearch
,@EmailIdSearch,@PaymentStatusSearch,@OrderPlacedSearch,@OrderStatus,@InvestmentType 

SELECT * FROM @MFDashboard 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateMFNFO
-- --------------------------------------------------
  
/*  
  
 EXEC usp_GenerateMFNFO   
  
*/  
  
CREATE PROCEDURE [dbo].[usp_GenerateMFNFO]  
(  
 @clientcode varchar(50) = null  
 ,@PageNo INT = NULL  
 ,@PageSize INT = NULL  
)  
AS    
BEGIN  
  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateMFNFO', getdate())  
  
DECLARE @NFO TABLE   
(  
 mf_cocode varchar(100)  
 , mf_schcode varchar(100)  
 , sch_name  varchar(1000)  
 , launc_date  varchar(100)  
 , cldate  varchar(100)  
 , FundClass varchar(1000)  
 , isin varchar(100)  
)  
  
INSERT INTO @NFO  
EXEC [ABVSAWUARQ1].NXT.[dbo].[usp_MF_Get_NFO] @PageNo, @PageSize  
  
SELECT * FROM @NFO  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNBFCStatement
-- --------------------------------------------------
  
/*  
  
 EXEC usp_GenerateNBFCStatement 'M709'   
 EXEC usp_GenerateNBFCStatement 'M70913212'   
  
 */  
  
CREATE PROCEDURE usp_GenerateNBFCStatement  
(  
@ClientCode varchar(20)  
)  
AS  
  
--SET nocount ON   
   
DECLARE @NBFCReport TABLE    
(    
 srno INT,   
 [vouc date] nvarchar(40),    
 [vouc type] nvarchar(40),    
 [vouc no] nvarchar(500),    
 narration nvarchar(1000),    
 debit  decimal(18,2),    
 Credit  decimal(18,2),    
 Amount  decimal(18,2),    
 Balance  decimal(18,2)    
)    
    
  
INSERT INTO @NBFCReport  
EXEC [CSOKYC-6].[General].dbo.usp_GenerateNBFCStatement_PMLA @ClientCode  
  
  
  
SELECT * FROM @NBFCReport  
  
--SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNCDXScriptDetails
-- --------------------------------------------------
-- EXEC usp_GenerateNCDXScriptDetails 'A43700', '01/08/2014', '24/12/2017', '', ''  
-- exec AngelCommodity.NCDX.dbo.NCXSAUDA    'AUG 1 2014', 'dec 24 2017','A43700','',''  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNCDXScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelCommodity.NCDX.dbo.NCXSAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
   
-- exec AngelCommodity.NCDX.dbo.NCXSAUDA    'AUG 1 2014', 'dec 24 2017','A43700','',''  
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
--SELECT @Count  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEAlert_Delete
-- --------------------------------------------------

/*
	exec usp_GenerateCDSLAlert 'R87276',  'fiu1'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu2'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu3'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu4'
	exec usp_GenerateCDSLAlert 'R87276',  'fiu5'
*/


CREATE PROC [dbo].[usp_GenerateNSEAlert]
(
	@ClientID varchar(20)
	,@NSEType varchar (20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	AlertType
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,CONVERT(VARCHAR,CurrentPeriod, 103) CurrentPeriod
	,CurrentTurnover
	,PreviousPeriod
	,PreviousTurnover
	,PercentIncrease
	,CaseId
	,CONVERT(VARCHAR, ClosedDate, 103) ClosedDate
	,LastestIncome
	,RiskCategory
	,CSC
	--,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	--,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	--AND CDSLType = @CDSLType 	

--SELECT * 
--FROM 
--	[dbo].[tbl_CDSLAlert] 

/*
	Update tbl_CDSLAlert
	SET ClientID  = 'R87276'

	Update tbl_CDSLAlert
	SET RecordStatus  = 'A'

	Update [tbl_TSSAlert]
	SET RecordStatus  = 'D'
	WHERE ID > 2000
	-- truncate table tbl_TSSAlert
*/

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEClientGroupAlert
-- --------------------------------------------------

/*

	exec usp_GenerateNSEClientGroupAlert 'R87276'

*/

CREATE PROC [dbo].[usp_GenerateNSEClientGroupAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,AlertType
	,InstrumentCode
	,CONVERT(VARCHAR,TradeDate, 103) TradeDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	--,'31/12/2017' AlertDate
	,RefNo
	,ClientBuyValue
	,ClientSellValue
	,MemberBuyValue
	,MemberSellValue
	,GrossScripQuantity
	,MemberScripQuantity
	,MemberScripPercent
	,Top5BuyValue
	,Top5SellValue
	,AggClientPercentage
	,PercentMemberConcentration
	,PercentMarketConcentration
	,Scrip
	,LastestIncome
	,IntermediatoryCode
	,RiskCategory
	,CSC
	--,CaseID
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Client Group of Client' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEClientsAlert
-- --------------------------------------------------

/*
	exec usp_GenerateNSEClientsAlert 'R87276'
*/

CREATE PROC [dbo].[usp_GenerateNSEClientsAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

-- Truncate table tbl_PMLAUserLog

	INSERT INTO tbl_PMLAUserLog (SPName,param1)
	VALUES('usp_GenerateNSEClientsAlert', @ClientID)

SELECT 
	ID
	,ClientName
	,AlertType
	,IntermediatoryCode
	,CONVERT(VARCHAR,TradeDate, 103) TradeDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,CurrentTurnover
	,ClientBuyValue
	,ClientSellValue
	,MemberBuyQuantity
	,MemberSellQuantity
	,MemberBuyValue
	,MemberSellValue
	,GrossScripQuantity
	,MemberScripQuantity
	,PercentMemberConcentration
	,CaseId
	,LastestIncome
	,RiskCategory
	,CSC
	--,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	--,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Client s Group of Client' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSECURFOScriptDetails
-- --------------------------------------------------
 
  
-- EXEC usp_GenerateNSECURFOScriptDetails 'A10071', '01/08/2014', '24/12/2016', '', ''  
-- exec AngelFO.NSECURFO.dbo.NSXSAUDA '09/01/2014', '12/31/2016','A10071','',''  
  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNSECURFOScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelFO.NSECURFO.dbo.NSXSAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
   
-- exec AngelFO.NSECURFO.dbo.NSXSAUDA  'AUG 1 2011', 'dec 24 2017','A10071','',''  
  
  
--INSERT INTO @CalculatedScriptReport  
--SELECT   
-- *,  
-- CASE   
--   WHEN (SQTY > 0 AND PQTY = 0)   THEN SQTY  
--   WHEN (PQTY > 0 AND SQTY = 0)   THEN PQTY  
--   WHEN (PQTY > 0 AND SQTY > 0)   THEN   
--  CASE    
--   WHEN (SQTY > PQTY) THEN (SQTY - PQTY) * -1  
--   WHEN (SQTY < PQTY)  THEN (PQTY - SQTY)  
--  END   
-- END AS [NETQTY],  
  
-- CASE    
--  WHEN (SQTY = PQTY) THEN 0  
--  WHEN (SQTY > PQTY) THEN 0  
--  ELSE  
--   ((PAMT - SAMT)/(PQty - SQty)) END   
--  AS [NETRATE],  
  
-- --CASE    
-- --WHEN (SQTY = PQTY) THEN 0  
-- --ELSE  
-- -- ((PAMT - SAMT)/(CASE WHEN (PQty - SQty) <= 0 THEN 1   
-- -- ELSE   
-- -- --CASE   
-- -- --WHEN (PQty - SQty) < 0 THEN  (PQty - SQty) *- 1  
-- -- --ELSE   
-- -- -- (PQty - SQty)  
-- -- --END  
-- -- (PQty - SQty) END))   
-- --END  
-- --AS [NETRATE],  
  
-- CASE    
--  WHEN (SQTY > PQTY) THEN (SAMT- PAMT) * -1  
--  ELSE   
--  (SAMT- PAMT)  
--  END AS NETAmt  
  
-- --CASE WHEN NETQTY < 0 THEN ((SAMT - PAMT) * -1) END  AS NETAmt  
  
--FROM @ScriptReport   
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
--select 'pur'  
--select @Count  
  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
--select 'sale'  
--select @Count  
  
--SELECT 'Sum'  
--SELECT (SUM(SRATE)) FROM  @CalculatedScriptReport  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
--SELECT convert(varchar, SAUDA_DATE, 106) AS SAUDADATE, convert(varchar, expirydate , 106) AS  Expiry_Date , * from @ScriptReport   
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEFOScriptDetails
-- --------------------------------------------------
-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', '08/01/2016', '12/24/2016', '', ''  
-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', '01/09/2016', '31/12/2016', '', ''  
-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', 'AUG 1 2016', 'dec 24 2016', '', ''  
-- exec AngelFO.nsefo.dbo.fosauda '09/01/2016', '12/31/2016','A100077','',''  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNSEFOScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelFO.nsefo.dbo.fosauda @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
 -- exec AngelFO.nsefo.dbo.fosauda 'AUG 1 2016', 'dec 24 2016 00:00:00','A100077','','zzzzz'  
-- exec AngelFO.nsefo.dbo.fosauda '09/01/2016', '12/31/2016','A100077','',''  
  
  
--INSERT INTO @CalculatedScriptReport  
--SELECT   
-- *,  
-- CASE   
--   WHEN (SQTY > 0 AND PQTY = 0)   THEN SQTY  
--   WHEN (PQTY > 0 AND SQTY = 0)   THEN PQTY  
--   WHEN (PQTY > 0 AND SQTY > 0)   THEN   
--  CASE    
--   WHEN (SQTY > PQTY) THEN (SQTY - PQTY) * -1  
--   WHEN (SQTY < PQTY)  THEN (PQTY - SQTY)  
--  END   
-- END AS [NETQTY],  
  
-- CASE    
--  WHEN (SQTY = PQTY) THEN 0  
--  WHEN (SQTY > PQTY) THEN 0  
--  ELSE  
--   ((PAMT - SAMT)/(PQty - SQty)) END   
--  AS [NETRATE],  
  
-- --CASE    
-- --WHEN (SQTY = PQTY) THEN 0  
-- --ELSE  
-- -- ((PAMT - SAMT)/(CASE WHEN (PQty - SQty) <= 0 THEN 1   
-- -- ELSE   
-- -- --CASE   
-- -- --WHEN (PQty - SQty) < 0 THEN  (PQty - SQty) *- 1  
-- -- --ELSE   
-- -- -- (PQty - SQty)  
-- -- --END  
-- -- (PQty - SQty) END))   
-- --END  
-- --AS [NETRATE],  
  
-- CASE    
--  WHEN (SQTY > PQTY) THEN (SAMT- PAMT) * -1  
--  ELSE   
--  (SAMT- PAMT)  
--  END AS NETAmt  
  
-- --CASE WHEN NETQTY < 0 THEN ((SAMT - PAMT) * -1) END  AS NETAmt  
  
--FROM @ScriptReport   
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
--select 'pur'  
--select @Count  
  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
--select 'sale'  
--select @Count  
  
--SELECT 'Sum'  
--SELECT (SUM(SRATE)) FROM  @CalculatedScriptReport  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
--SELECT convert(varchar, SAUDA_DATE, 106) AS SAUDADATE, convert(varchar, expirydate , 106) AS  Expiry_Date , * from @ScriptReport   
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEFOScriptDetails_Ipartner
-- --------------------------------------------------

-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', '08/01/2016', '12/24/2016', '', ''  
-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', '01/09/2016', '31/12/2016', '', ''  
-- EXEC usp_GenerateNSEFOScriptDetails 'A100077', 'AUG 1 2016', 'dec 24 2016', '', ''  
-- exec AngelFO.nsefo.dbo.fosauda '09/01/2016', '12/31/2016','A100077','',''  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNSEFOScriptDetails_Ipartner]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
  
--Select @FromDate   
--Select @ToDate   
  
  
Declare @Count int  
  
DECLARE @CalculatedScriptReport TABLE  
(  
 SAUDA_DATE  smalldatetime,  
 inst_type  nvarchar(40),  
 SYMBOL  nvarchar(100),  
 STRIke_price numeric(18,2),  
 expirydate  smalldatetime,  
 Option_type  nvarchar(40),  
 OPEN_QTY  numeric(18,0),  
 PQTY  numeric(18,0),  
 PRATE  numeric(18,2),  
 PAMT  numeric(18,2),  
 SQTY  numeric(18,0),  
 SRATE  numeric(18,2),  
 SAMT  numeric(18,2),  
 PBROKAMT  numeric(18,2),  
 SBROKAMT  numeric(18,2),  
 CL_RATE  numeric(18,2),  
 NETQty  numeric(18,0),  
 NETRate  numeric(18,2),  
 NETAMT numeric(18,2),  
 --NETAMT_TEMP  numeric(18,2),  
 CL_QTY  numeric(18,0),  
 PNL  numeric(18,2)  
)  
  
INSERT INTO @CalculatedScriptReport  
exec AngelFO.nsefo.dbo.fosauda @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
 -- exec AngelFO.nsefo.dbo.fosauda 'AUG 1 2016', 'dec 24 2016 00:00:00','A100077','','zzzzz'  
-- exec AngelFO.nsefo.dbo.fosauda '09/01/2016', '12/31/2016','A100077','',''  
  
  
--INSERT INTO @CalculatedScriptReport  
--SELECT   
-- *,  
-- CASE   
--   WHEN (SQTY > 0 AND PQTY = 0)   THEN SQTY  
--   WHEN (PQTY > 0 AND SQTY = 0)   THEN PQTY  
--   WHEN (PQTY > 0 AND SQTY > 0)   THEN   
--  CASE    
--   WHEN (SQTY > PQTY) THEN (SQTY - PQTY) * -1  
--   WHEN (SQTY < PQTY)  THEN (PQTY - SQTY)  
--  END   
-- END AS [NETQTY],  
  
-- CASE    
--  WHEN (SQTY = PQTY) THEN 0  
--  WHEN (SQTY > PQTY) THEN 0  
--  ELSE  
--   ((PAMT - SAMT)/(PQty - SQty)) END   
--  AS [NETRATE],  
  
-- --CASE    
-- --WHEN (SQTY = PQTY) THEN 0  
-- --ELSE  
-- -- ((PAMT - SAMT)/(CASE WHEN (PQty - SQty) <= 0 THEN 1   
-- -- ELSE   
-- -- --CASE   
-- -- --WHEN (PQty - SQty) < 0 THEN  (PQty - SQty) *- 1  
-- -- --ELSE   
-- -- -- (PQty - SQty)  
-- -- --END  
-- -- (PQty - SQty) END))   
-- --END  
-- --AS [NETRATE],  
  
-- CASE    
--  WHEN (SQTY > PQTY) THEN (SAMT- PAMT) * -1  
--  ELSE   
--  (SAMT- PAMT)  
--  END AS NETAmt  
  
-- --CASE WHEN NETQTY < 0 THEN ((SAMT - PAMT) * -1) END  AS NETAmt  
  
--FROM @ScriptReport   
  
SELECT @Count = COUNT(0) FROM @CalculatedScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @CalculatedScriptReport(Option_type)  
VALUES('GRAND TOTALS')  
  
UPDATE @CalculatedScriptReport  
SET  OPEN_QTY = (SELECT SUM (OPEN_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
-------------- Purchase  
UPDATE @CalculatedScriptReport  
SET  PQTY = (SELECT SUM (PQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where PRATE > 0  
--select 'pur'  
--select @Count  
  
  
UPDATE @CalculatedScriptReport  
SET  PRATE = (SELECT (SUM(PRATE)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  PAMT = (SELECT SUM (PAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Sales  
UPDATE @CalculatedScriptReport  
SET  SQTY = (SELECT SUM (SQTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
set @Count = 0  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where SRATE > 0  
  
--select 'sale'  
--select @Count  
  
--SELECT 'Sum'  
--SELECT (SUM(SRATE)) FROM  @CalculatedScriptReport  
  
UPDATE @CalculatedScriptReport  
SET  SRATE = (SELECT ((SUM(round(SRATE,2)))/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  SAMT = (SELECT SUM (SAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------------Net  
  
UPDATE @CalculatedScriptReport  
SET  NETQty = (SELECT SUM (NETQty) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @CalculatedScriptReport Where NETRate <> 0  
  
UPDATE @CalculatedScriptReport  
SET  NETRate = (SELECT (SUM(NETRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
UPDATE @CalculatedScriptReport  
SET  NETAMT = (SELECT SUM (NETAMT) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- CL  
UPDATE @CalculatedScriptReport  
SET  CL_QTY = (SELECT SUM (CL_QTY) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
---------- PNL  
UPDATE @CalculatedScriptReport  
SET  PNL = (SELECT SUM (PNL) FROM  @CalculatedScriptReport)  
WHERE Option_type ='GRAND TOTALS'  
  
  
--SELECT convert(varchar, SAUDA_DATE, 106) AS SAUDADATE, convert(varchar, expirydate , 106) AS  Expiry_Date , * from @ScriptReport   
END  
  
SELECT   
 CONVERT(VARCHAR, SAUDA_DATE, 106) AS SAUDADATE,   
 CONVERT(VARCHAR, expirydate , 106) AS  Expiry_Date , *   
FROM @CalculatedScriptReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEOrderAlert
-- --------------------------------------------------

/*

	exec usp_GenerateNSEOrderAlert 'R87276'

*/

CREATE PROC [dbo].[usp_GenerateNSEOrderAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,AlertType
	,InstrumentCode
	,CONVERT(VARCHAR,TradeDate, 103) TradeDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,LimitPrice
	,OriginalVolume
	,VolumeDisclosed
	,LTPVariation
	,BuySell
	,OrderNumber
	,UnderlyingPrice
	,OptionType
	,StrikePrice
	,CONVERT(VARCHAR, ExpiryDate, 103) ExpiryDate
	,TotalBuyQty
	,TotalSellQty
	,TotalSPoofQty
	,Profit
	,CaseId
	,LastestIncome
	,RiskCategory
	,CSC
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Order book spoofing' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEScriptDetails
-- --------------------------------------------------
--EXEC usp_GenerateBSEScriptDetails 'B20608', '2015-04-14' ,'2016-09-14','533160','533160'  
  
 -- EXEC [usp_GenerateNSEScriptDetails] 'B20608', '14/04/2015' ,'30/09/2016','',''  
  
 -- EXEC [usp_GenerateNSEScriptDetails] 'rp61', '01/01/2015' ,'09/01/2016','',''  
  
-- EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNSEScriptDetails]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
DECLARE @ScriptReport TABLE  
(  
[Date] smalldatetime,  
Code  nvarchar(100),  
Series nvarchar(100),  
Name  nvarchar(100),  
ISIN nvarchar(100),  
PQty  decimal(18,2),  
PAvgRate  decimal(18,2),  
PValue decimal(18,2),  
SQty decimal(18,2),  
SAvgRate  decimal(18,2),  
SValue decimal(18,2),  
OQty decimal(18,2),  
OAvgRate decimal(18,2),  
OValue decimal(18,2),  
TradingPnl decimal(18,2),  
NetValue decimal(18,2)  
)  
  
  
INSERT INTO @ScriptReport(  
 [Date],  
 Code,  
 Series,  
 Name,  
 ISIN,  
 PQty,  
 PAvgRate,  
 PValue,  
 SQty ,  
 SAvgRate,  
 SValue ,  
 OQty ,  
 OAvgRate,  
 OValue ,  
 TradingPnl ,  
 NetValue  
)  
--EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
EXEC  AngelNseCM.MSAJAG.dbo.NSESAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
  
  
  
DECLARE @Count int  
  
SELECT @Count = COUNT(0) FROM @ScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @ScriptReport(Name)  
VALUES('GRAND TOTALS')  
  
  
  
-------------- Purchase  
UPDATE @ScriptReport  
SET  PQTY = (SELECT SUM (PQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where PAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  PAvgRate = (SELECT (SUM(PAvgRate)/ CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  PValue = (SELECT SUM (PValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
-------------- Sales  
UPDATE @ScriptReport  
SET  SQTY = (SELECT SUM (SQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where SAvgRate > 0  
--select 'sal'  
--select @Count  
  
UPDATE @ScriptReport  
SET  SAvgRate = (SELECT (SUM(SAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  SValue = (SELECT SUM (SValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
-------------- OPEN  
UPDATE @ScriptReport  
SET  OQty = (SELECT SUM (OQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where OAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  OAvgRate = (SELECT (SUM(OAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  OValue = (SELECT SUM (OValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
  
-------------- Trading and Net  
UPDATE @ScriptReport  
SET  TradingPnl = (SELECT SUM (TradingPnl) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  NetValue= (SELECT SUM (NetValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
END  
  
SELECT convert(varchar, Date, 106) AS TranDate, * from @ScriptReport --Order by [Date] ASC  

  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSEScriptDetails_iPartner
-- --------------------------------------------------
--EXEC usp_GenerateBSEScriptDetails 'B20608', '2015-04-14' ,'2016-09-14','533160','533160'  
  
 -- EXEC [usp_GenerateNSEScriptDetails] 'B20608', '14/04/2015' ,'30/09/2016','',''  
  
 -- EXEC [usp_GenerateNSEScriptDetails] 'rp61', '01/01/2015' ,'09/01/2016','',''  
  
-- EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
  
  
CREATE PROCEDURE [dbo].[usp_GenerateNSEScriptDetails_iPartner]  
(  
 @client_code as varchar(100),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @FromScriptCode as varchar (100),  
  
 @ToScriptCode as varchar (100)  
)  
AS  
  
BEGIN  
  
  
  
--Select @FromDate =  convert(varchar, CAST(@FromDate AS smalldatetime), 109)  
--Select @ToDate =  convert(varchar,  CAST(@ToDate AS smalldatetime), 109)  
  
  
  
SELECT @FromDate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FromDate,10),105),101)  
SELECT @ToDate=  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@ToDate,10),105),101)  
  
DECLARE @ScriptReport TABLE  
(  
[Date] smalldatetime,  
Code  nvarchar(100),  
Series nvarchar(100),  
Name  nvarchar(100),  
ISIN nvarchar(100),  
PQty  decimal(18,2),  
PAvgRate  decimal(18,2),  
PValue decimal(18,2),  
SQty decimal(18,2),  
SAvgRate  decimal(18,2),  
SValue decimal(18,2),  
OQty decimal(18,2),  
OAvgRate decimal(18,2),  
OValue decimal(18,2),  
TradingPnl decimal(18,2),  
NetValue decimal(18,2)  
)  
  
  
INSERT INTO @ScriptReport(  
 [Date],  
 Code,  
 Series,  
 Name,  
 ISIN,  
 PQty,  
 PAvgRate,  
 PValue,  
 SQty ,  
 SAvgRate,  
 SValue ,  
 OQty ,  
 OAvgRate,  
 OValue ,  
 TradingPnl ,  
 NetValue  
)  
--EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA '2015-04-14' ,'2016-08-14','B20608','533160','533160'  
EXEC   AngelNseCM.MSAJAG.dbo.NSESAUDA @fromDate, @ToDate, @client_code, @FromScriptCode, @ToScriptCode  
  
  
  
DECLARE @Count int  
  
SELECT @Count = COUNT(0) FROM @ScriptReport  
  
  
IF (@Count > 0)  
BEGIN  
  
INSERT INTO @ScriptReport(Name)  
VALUES('GRAND TOTALS')  
  
  
  
-------------- Purchase  
UPDATE @ScriptReport  
SET  PQTY = (SELECT SUM (PQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where PAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  PAvgRate = (SELECT (SUM(PAvgRate)/ CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  PValue = (SELECT SUM (PValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
-------------- Sales  
UPDATE @ScriptReport  
SET  SQTY = (SELECT SUM (SQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where SAvgRate > 0  
--select 'sal'  
--select @Count  
  
UPDATE @ScriptReport  
SET  SAvgRate = (SELECT (SUM(SAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  SValue = (SELECT SUM (SValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
-------------- OPEN  
UPDATE @ScriptReport  
SET  OQty = (SELECT SUM (OQty) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
SELECT @Count = COUNT(1) FROM @ScriptReport Where OAvgRate > 0  
--select 'pur'  
--select @Count  
  
UPDATE @ScriptReport  
SET  OAvgRate = (SELECT (SUM(OAvgRate)/CASE WHEN @Count <= 0 THEN  1 ELSE @Count  END) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  OValue = (SELECT SUM (OValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
  
  
-------------- Trading and Net  
UPDATE @ScriptReport  
SET  TradingPnl = (SELECT SUM (TradingPnl) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
UPDATE @ScriptReport  
SET  NetValue= (SELECT SUM (NetValue) FROM  @ScriptReport)  
WHERE Name ='GRAND TOTALS'  
  
END  
  
SELECT convert(varchar, Date, 106) AS TranDate, * from @ScriptReport --Order by [Date] ASC  

  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSESelfAlert
-- --------------------------------------------------

/*
	exec usp_GenerateNSESelfAlert 'R87276'
	
*/


CREATE PROC [dbo].[usp_GenerateNSESelfAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,AlertType
	,IntermediatoryCode
	,CONVERT(VARCHAR,TradeDate, 103) TradeDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,TotalSelfQty
	,CaseId
	,LastestIncome
	,RiskCategory
	,CSC
	--,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	--,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Self Trade' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSESignificantAlert
-- --------------------------------------------------

/*
	exec usp_GenerateNSESignificantAlert 'R87276'
	
*/


CREATE PROC [dbo].[usp_GenerateNSESignificantAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,AlertType
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,CONVERT(VARCHAR,CurrentPeriod, 103) CurrentPeriod
	,CurrentTurnover
	,PreviousPeriod
	,PreviousTurnover
	,PercentIncrease
	,CaseId
	,CONVERT(VARCHAR, ClosedDate, 103) ClosedDate
	,LastestIncome
	,RiskCategory
	,CSC
	--,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	--,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Significant  increase' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateNSESuddenAlert
-- --------------------------------------------------

/*

	exec usp_GenerateNSESuddenAlert 'R87276'

*/

CREATE PROC [dbo].[usp_GenerateNSESuddenAlert]
(
	@ClientID varchar(20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,AlertType
	,InstrumentCode
	,CONVERT(VARCHAR,TradeDate, 103) TradeDate
	,CONVERT(VARCHAR,AlertDate, 103) AlertDate
	,RefNo
	,ClientBuyValue
	,ClientSellValue
	,MemberBuyValue
	,MemberSellValue
	,Scrip
	,CaseId
	,LastestIncome
	,RiskCategory
	,CSC
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEtype = 'Sudden trading activity' 	

--SELECT distinct NSEtype
--FROM 
--	[dbo].tbl_NSEAlert

	--6, 3, 1, 2, 4, 5 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInPayoutSummary
-- --------------------------------------------------
  
  
/*  
  
 exec usp_GeneratePayInPayoutSummary 'V51815','07/03/2014','04/10/2017'  
 exec usp_GeneratePayInPayoutSummary 'S125760','18/10/2012','04/10/2017'  
   
  
*/  
  
----  exec usp_GeneratePayInPayoutSummary 'B14695','13/04/2000','21/04/2016'  
----  exec usp_GeneratePayInPayoutSummary 'ALWR490','01/01/2000','31/12/2016'  
----  exec usp_GeneratePayInPayoutSummary 'M100301','01/01/2017','17/06/2017'  
  
  
CREATE PROCEDURE [dbo].[usp_GeneratePayInPayoutSummary]  
  
@clt_code as varchar(10),  
  
@FromDate as varchar (100),  
  
@ToDate as varchar (100)  
  
--@userid as varchar(15),          
--@access_To as varchar(10),          
--@access_Code as varchar(10)       
  
AS  
  
BEGIN   
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GeneratePayInPayoutSummary', getdate())  
  
DECLARE @PayInPayOutReportAll TABLE  
(  
 [sno] int identity(1,1),  
 [Exchange]  nvarchar(100),  
 [vno]  nvarchar(100),  
 [vdt]  nvarchar(100),  
 [Payin]  decimal(18,2),  
 [PayOut]  decimal(18,2),  
 [GrandTotal]  decimal(18,2)  
)  
  
  
--declare @CURR_DATE VARCHAR(11)  
--SET @CURR_DATE='01/12/2016'  
  
  
--declare @FDate DATETIME  
--declare @TDate DATETIME  
  
--SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)  
--SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)  
  
  
--DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME  
----SET @CURR_DATE='2016/03/30'  
--IF MONTH(getdate()) IN (1,2,3)  
--BEGIN  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)  
--END  
--ELSE  
--BEGIN  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)  
--END  
----SELECT @STARTDATE AS ST_FI,@ENDDATE AS END_FY  
  
--IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE )   
--BEGIN  
----select 'cur'  
-- INSERT INTO @PayInPayOutReport(  
--  [Exchange],  
--  [vno],  
--  [vdt],  
--  [Payin] ,  
--  [PayOut],  
--  [GrandTotal]  
-- )  
-- -- EXEC [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016'  
-- --- exec [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/2000','31/12/2016'  
-- EXEC [CSOKYC-6].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, ''  
--END  
--ELSE   
-- BEGIN  
-- --select 'pre'  
-- INSERT INTO @PayInPayOutReport(  
--  [Exchange],  
--  [vno],  
--  [vdt],  
--  [Payin] ,  
--  [PayOut],  
--  [GrandTotal]  
-- )  
-- -- EXEC [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016'  
-- --- exec [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER_history 'ALWR490','01/01/2000','31/12/2016',''  
-- EXEC usp_GeneratePayInPayOutTransaction_History @clt_code, @FromDate, @ToDate, ''  
--END   
  
  
 INSERT INTO @PayInPayOutReportAll(  
   [Exchange],  
   [vno],  
   [vdt],  
   [Payin] ,  
   [PayOut]  
   --[GrandTotal]  
  )  
  
 EXEC [CSOKYC-6].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, ''  
  
 INSERT INTO @PayInPayOutReportAll (  
   [Exchange],  
   [vno],  
   [vdt],  
   [Payin] ,  
   [PayOut]  
   --[GrandTotal]  
  )  
  
 EXEC usp_GeneratePayInPayOutTransaction_History @clt_code, @FromDate, @ToDate, ''  
  
  
 Declare @Count int  
  
 select @Count = count(0) FROM @PayInPayOutReportAll  
  
  
IF (@Count > 0)  
  
BEGIN  
  
INSERT INTO @PayInPayOutReportAll(  
  [Exchange],  
  [vno],  
  [vdt],  
  [Payin] ,  
  [PayOut]  
 --[GrandTotal]  
)  
-- EXEC [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016', 'nbfc'  
--- exec [CSOKYC-6].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/2000','31/12/2016'  
EXEC [CSOKYC-6].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, 'NBFC'  
  
DELETE FROM @PayInPayOutReportAll where sno in  
(  
 SELECT sno  FROM @PayInPayOutReportAll D WHERE   
 1 < (SELECT COUNT(*) FROM @PayInPayOutReportAll A WHERE A.Exchange = D.Exchange and A.vno = D.vno and A.vdt = D.vdt and D.sno >= A.sno)  
)  
  
END  
  
DECLARE @PayInPayOutReport TABLE  
(  
 [Exchange]  nvarchar(100),  
 [Payin]  decimal(18,2),  
 [PayOut]  decimal(18,2),  
 [GrandTotal]  decimal(18,2)  
)  
  
  
INSERT INTO @PayInPayOutReport(  
  [Exchange],  
  [Payin] ,  
  [PayOut],  
  [GrandTotal]  
 )  
SELECT [Exchange], ISNULL(SUM(Payin), 0) AS Payin, ISNULL(SUM(Payout), 0) AS Payout, ISNULL(SUM(Payin), 0) - ISNULL(SUM(PayOut), 0) As [GrandTotal]   
FROM @PayInPayOutReportAll  
WHERE [Exchange] NOT IN ('NBFC')  
GROUP BY [Exchange]  
  
  
INSERT INTO @PayInPayOutReport([Exchange])  
VALUES('Grand Total')  
  
UPDATE @PayInPayOutReport  
SET  Payin = (SELECT SUM (Payin) FROM  @PayInPayOutReport)  
WHERE Exchange ='Grand Total'  
  
  
UPDATE @PayInPayOutReport  
SET  PayOut = (SELECT SUM (PayOut) FROM  @PayInPayOutReport)  
WHERE Exchange ='Grand Total'  
  
UPDATE @PayInPayOutReport  
SET  GrandTotal = (SELECT SUM (GrandTotal) FROM  @PayInPayOutReport)  
WHERE Exchange ='Grand Total'  
  
INSERT INTO @PayInPayOutReport(  
  [Exchange],  
  [Payin] ,  
  [PayOut],  
  [GrandTotal]  
 )  
SELECT [Exchange], ISNULL(SUM(PayIn), 0) AS Payin, ISNULL(SUM(PayOut), 0) AS Payout, ISNULL(SUM(PayIn), 0) - ISNULL(SUM(PayOut), 0) As [GrandTotal]   
FROM @PayInPayOutReportAll  
WHERE [Exchange] IN ('NBFC')  
GROUP BY [Exchange]  
  
SELECT * FROM @PayInPayOutReport  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInPayoutSummary_30062017
-- --------------------------------------------------


----  exec usp_GeneratePayInPayoutSummary 'B14695','13/04/2016','21/04/2016'
----  exec usp_GeneratePayInPayoutSummary 'ALWR490','01/01/2000','31/12/2016'

----  exec usp_GeneratePayInPayoutSummary 'M100301','01/01/2017','17/06/2017'


CREATE PROCEDURE [dbo].[usp_GeneratePayInPayoutSummary_30062017]

@clt_code as varchar(10),

@FromDate as varchar (100),

@ToDate as varchar (100)

--@userid as varchar(15),        
--@access_To as varchar(10),        
--@access_Code as varchar(10)     
AS

BEGIN 



INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GeneratePayInPayoutSummary', getdate())

DECLARE @PayInPayOutReport TABLE
(
	[Exchange]	 nvarchar(100),
	[Payin]	 decimal(18,2),
	[PayOut]	 decimal(18,2),
	[GrandTotal]	 decimal(18,2)
)


--INSERT INTO @PayInPayOutReport(
--	[Exchange],
--	[Payin] ,
--	[PayOut],
--	[GrandTotal]
--)
----	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016'
----- exec [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/2000','31/12/2016'
--EXEC [196.1.115.182].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER_History] @clt_code, @FromDate,	@ToDate, ''

--declare @CURR_DATE VARCHAR(11)
--SET @CURR_DATE='01/12/2016'


declare @FDate DATETIME
declare @TDate DATETIME

SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)
SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)


DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME
--SET @CURR_DATE='2016/03/30'
IF MONTH(getdate()) IN (1,2,3)
BEGIN
    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)
END
ELSE
BEGIN
    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)
END
--SELECT @STARTDATE AS ST_FI,@ENDDATE AS END_FY

IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE ) 
BEGIN
--select 'cur'
	INSERT INTO @PayInPayOutReport(
		[Exchange],
		[Payin] ,
		[PayOut],
		[GrandTotal]
	)
	--	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016'
	--- exec [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/2000','31/12/2016'
	EXEC [196.1.115.182].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate,	@ToDate, ''
END
ELSE 
	BEGIN
	--select 'pre'
	INSERT INTO @PayInPayOutReport(
		[Exchange],
		[Payin] ,
		[PayOut],
		[GrandTotal]
	)
	--	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016'
	--- exec [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER_history 'ALWR490','01/01/2000','31/12/2016',''
	EXEC usp_GeneratePayInPayOutTransaction_History @clt_code, @FromDate,	@ToDate, ''
END 


Declare @Count int

select @Count = count(0) FROM @PayInPayOutReport


IF (@Count > 0)

BEGIN
INSERT INTO @PayInPayOutReport([Exchange])
VALUES('Grand Total')

UPDATE @PayInPayOutReport
SET  Payin = (SELECT SUM (Payin) FROM  @PayInPayOutReport)
WHERE Exchange ='Grand Total'


UPDATE @PayInPayOutReport
SET  PayOut = (SELECT SUM (PayOut) FROM  @PayInPayOutReport)
WHERE Exchange ='Grand Total'

UPDATE @PayInPayOutReport
SET  GrandTotal = (SELECT SUM (GrandTotal) FROM  @PayInPayOutReport)
WHERE Exchange ='Grand Total'


INSERT INTO @PayInPayOutReport(
	[Exchange],
	[Payin] ,
	[PayOut],
	[GrandTotal]
)
--	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'B14695','01/01/2016','31/12/2016', 'nbfc'
--- exec [196.1.115.182].[General].dbo.RPT_PAYIN_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/2000','31/12/2016'
EXEC [196.1.115.182].[General].dbo.[RPT_PAYIN_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate,	@ToDate, 'NBFC'


END

SELECT * FROM  @PayInPayOutReport

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInPayOutTransaction_History
-- --------------------------------------------------
  
-- exec  usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2016','31/12/2016', ''  
  
-- exec usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2000','31/12/2016', 'nbfc'  
  
-- exec  usp_GeneratePayInPayOutTransaction_History 'B44730','01/01/2014','31/12/2016', ''  
  
-- usp_GeneratePayInPayOutTransaction_History 'ALWR490','01/01/2000','31/12/2016', ''  
  
  
  
CREATE  PROCEDURE [dbo].[usp_GeneratePayInPayOutTransaction_History]  
  
(                      
  
 @clt_code VARCHAR(20),                  
  
  
 @FROM_DATE VARCHAR(11),                    
  
  
 @TO_DATE VARCHAR(11),  
  
  
 @Segment VARCHAR(11)  
  
  
)    
  
AS                    
  
BEGIN                    
  
 SELECT @FROM_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FROM_DATE,10),105),101)  
  
 SELECT @TO_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@TO_DATE,10),105),101)  
  
  
  
IF (@Segment <> 'NBFC')   
  
  
  
BEGIN  
  
  
  
--SELECT Co_Code, ISNULL(SUM(Payin), 0) AS Payin, ISNULL(SUM(Payout), 0) AS Payout, ISNULL(sum(Payin), 0) - ISNULL(sum(PayOut), 0) As [GrandTotal]   
  
--FROM   
  
--(  
  
SELECT   
  
  A.Co_Code  
  
 , A.vno   
  
 , A.vdt  
  
 ,CASE WHEN a.vtyp = 2 then (A.vamt)  end AS PayIn  
  
 ,CASE WHEN a.vtyp = 3 then (A.vamt)  end AS Payout   
  
FROM   
 --comment for Mitali archival data issue  
 ---VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK)   
  
 [CSOKYC-6].General.dbo.VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK)   
   
 ON A.CLTCODE = B.CLIENT   
  
 LEFT OUTER JOIN  [CSOKYC-6].General.dbo.vmast C   
  
  ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code  
  
WHERE   
  
 a.cltcode = @clt_code AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
  
  
--GROUP BY A.Co_Code, a.vtyp  
  
--) Z  
  
--GROUP By Co_Code  
  
END  
  
ELSE   
  
BEGIN  
  
--SELECT Co_Code, ISNULL(SUM(Payin), 0) AS Payin, ISNULL(SUM(Payout), 0) AS Payout, ISNULL(sum(Payin), 0) - ISNULL(sum(PayOut), 0) As [GrandTotal]   
  
--FROM  
  
--(  
  
 SELECT   
   
 'NBFC' AS Co_Code  
  
 , A.vno   
  
 , A.vdt  
  
 ,CASE WHEN vtyp = 'REPBNK' then isnull(A.vamt,0)  end AS PayIn   
  
 ,CASE WHEN vtyp = 'PAYBNK' then isnull(A.vamt,0)  end AS Payout   
  
 FROM [CSOKYC-6].General.dbo.nbfc_ledger  A   
  
 WHERE  
  
 -- A.cltcode = 'B14695'   
  
 a.cltcode = @clt_code AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
-- GROUP BY vtyp  
  
-- )Z  
  
--GROUP By Co_Code  
  
  
  
END  
  
  
  
  
  
--SELECT CLTCODE, A.CO_CODE,  COUNT(CLTCODE) FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
  
--GROUP BY CLTCODE,  A.CO_CODE   
  
--HAVING COUNT(CLTCODE) > 1  
  
--ORDER BY CLTCODE  
  
  
  
--   select top 1 * from nbfc_ledger  
  
--- select top 10 * from VW_RMS_CLIENT_VERTICAL where client like '%B14695%'  
  
   
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInPayOutTransaction_History_30062017
-- --------------------------------------------------

-- exec  usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2016','31/12/2016', ''

-- exec usp_GeneratePayInPayOutTransaction_History 'B14695','01/01/2000','31/12/2016', 'nbfc'

-- exec  usp_GeneratePayInPayOutTransaction_History 'B44730','01/01/2014','31/12/2016', ''

-- usp_GeneratePayInPayOutTransaction_History 'ALWR490','01/01/2000','31/12/2016', ''



CREATE  PROCEDURE [dbo].[usp_GeneratePayInPayOutTransaction_History_30062017]

(                    

 @clt_code VARCHAR(20),                


 @FROM_DATE VARCHAR(11),                  


 @TO_DATE VARCHAR(11),


 @Segment VARCHAR(11)


)  

                

AS                  



BEGIN                  



	SELECT @FROM_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FROM_DATE,10),105),101)

	SELECT @TO_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@TO_DATE,10),105),101)



IF (@Segment <> 'NBFC')	



BEGIN



SELECT Co_Code, ISNULL(SUM(Payin), 0) AS Payin, ISNULL(SUM(Payout), 0) AS Payout, ISNULL(sum(Payin), 0) - ISNULL(sum(PayOut), 0) As [GrandTotal] 

FROM 

(

SELECT 

	A.Co_Code

	,CASE WHEN a.vtyp = 2 then SUM(A.vamt)  end AS PayIn

	,CASE WHEN a.vtyp = 3 then SUM(A.vamt)  end AS Payout 

FROM 
	--comment for Mitali archival data issue
	---VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [196.1.115.182].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK)	

	[196.1.115.182].General.dbo.VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [196.1.115.182].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK)	
	
	ON A.CLTCODE = B.CLIENT 

	LEFT OUTER JOIN  [196.1.115.182].General.dbo.vmast C 

		ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code

WHERE 

	a.cltcode = @clt_code AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE

GROUP BY A.Co_Code, a.vtyp

) Z

GROUP By Co_Code



END



ELSE 



BEGIN



SELECT Co_Code, ISNULL(SUM(Payin), 0) AS Payin, ISNULL(SUM(Payout), 0) AS Payout, ISNULL(sum(Payin), 0) - ISNULL(sum(PayOut), 0) As [GrandTotal] 

FROM

(

 SELECT 'NBFC' AS Co_Code,

	CASE WHEN vtyp = 'REPBNK' then SUM(isnull(A.vamt,0))  end AS PayIn	

	,CASE WHEN vtyp = 'PAYBNK' then SUM(isnull(A.vamt,0))  end AS Payout 

 FROM [196.1.115.182].General.dbo.nbfc_ledger  A 

 WHERE

 -- A.cltcode = 'B14695' 

	a.cltcode = @clt_code AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE

 GROUP BY vtyp

 )Z

GROUP By Co_Code



END





--SELECT CLTCODE, A.CO_CODE,  COUNT(CLTCODE) FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT 

--GROUP BY CLTCODE,  A.CO_CODE 

--HAVING COUNT(CLTCODE) > 1

--ORDER BY CLTCODE



--   select top 1 * from nbfc_ledger

--- select top 10 * from VW_RMS_CLIENT_VERTICAL where client like '%B14695%'

	



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInReport
-- --------------------------------------------------
  
-- exec usp_GeneratePayInReport 'ALWR490','01/01/1900','31/12/2016' , 'bSECM'  
-- exec usp_GeneratePayInReport 'ALWR490','01/05/2016','31/12/2016' , 'NSECM'  
  
-- exec usp_GeneratePayInReport 'B14695','01/01/2000','31/12/2016' , 'nbfc'  
  
  
  
CREATE PROCEDURE [dbo].[usp_GeneratePayInReport]  
(  
 @clt_code as varchar(10),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @Segment VARCHAR(11)  
  
)  
AS  
  
BEGIN   
  
DECLARE @PayInReport TABLE  
(  
 [sno] int identity(1,1),  
 Co_Code nvarchar(100),  
 cltcode nvarchar(100),  
 acname nvarchar(100),  
 Branch nvarchar(100),  
 vtyp nvarchar(10),  
 VType nvarchar(100),  
 drcr nvarchar(1),  
 vdt  nvarchar(100),  
 vno nvarchar(100),  
 vamt decimal(18,2)  
)  
  
--declare @FDate DATETIME  
--declare @TDate DATETIME  
  
  
--SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)  
--SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)  
  
  
--DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME  
----SET @CURR_DATE='2016/03/30'  
--IF MONTH(getdate()) IN (1,2,3)  
--BEGIN  
  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)  
--END  
--ELSE  
--BEGIN  
  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)  
--END  
----SELECT @STARTDATE AS ST_FI,@ENDDATE AS END_FY  
  
--IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE )   
-- BEGIN  
-- --select 'cur'  
-- -- EXEC [CSOKYC-6].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'  
-- --- exec [CSOKYC-6].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'  
-- INSERT INTO @PayInReport  
-- EXEC [CSOKYC-6].[General].dbo.[RPT_PAYIN_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment  
-- END  
  
--ELSE   
-- BEGIN  
-- --select 'pre'  
--  INSERT INTO @PayInReport  
--  EXEC usp_GeneratePayInTransaction_History @clt_code, @FromDate, @ToDate, @Segment  
-- END   
  
  
 INSERT INTO @PayInReport  
 EXEC [CSOKYC-6].[General].dbo.[RPT_PAYIN_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment  
  
 INSERT INTO @PayInReport  
 EXEC usp_GeneratePayInTransaction_History @clt_code, @FromDate, @ToDate, @Segment  
  
  
 DELETE FROM @PayInReport WHERE sno in  
 (  
  SELECT sno  FROM @PayInReport D WHERE   
  1 < (SELECT COUNT(*) FROM @PayInReport A WHERE A.Co_Code = D.Co_Code and A.cltcode = D.cltcode   
  and A.acname = D.acname and A.vdt = D.vdt and A.vno  = D.vno and D.sno >= A.sno)  
 )  
   
 SELECT * FROM @PayInReport   
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInReport_30062017
-- --------------------------------------------------

--	exec usp_GeneratePayInReport 'ALWR490','01/01/1900','31/12/2016' , 'bSECM'
--	exec usp_GeneratePayInReport 'ALWR490','01/05/2016','31/12/2016' , 'NSECM'

--	exec usp_GeneratePayInReport 'B14695','01/01/2000','31/12/2016' , 'nbfc'



CREATE PROCEDURE [dbo].[usp_GeneratePayInReport_30062017]
(
 @clt_code as varchar(10),

 @FromDate as varchar (100),

 @ToDate as varchar (100),

 @Segment VARCHAR(11)

)
AS

BEGIN 

DECLARE @PayInReport TABLE
(
	Co_Code	nvarchar(100),
	cltcode	nvarchar(100),
	acname	nvarchar(100),
	Branch	nvarchar(100),
	vtyp	nvarchar(10),
	VType	nvarchar(100),
	drcr	nvarchar(1),
	vdt		nvarchar(100),
	vno	nvarchar(100),
	vamt	decimal(18,2)
)

----	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'
----- exec [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'
--INSERT INTO @PayInReport
--EXEC [196.1.115.182].[General].dbo.[RPT_PAYIN_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment


declare @FDate DATETIME
declare @TDate DATETIME


SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)
SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)


DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME
--SET @CURR_DATE='2016/03/30'
IF MONTH(getdate()) IN (1,2,3)
BEGIN

    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)
END
ELSE
BEGIN

    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)
END
--SELECT @STARTDATE AS ST_FI,@ENDDATE AS END_FY

IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE ) 
	BEGIN
	--select 'cur'
	--	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'
	--- exec [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'
	INSERT INTO @PayInReport
	EXEC [196.1.115.182].[General].dbo.[RPT_PAYIN_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment
	END

ELSE 
	BEGIN
	--select 'pre'
		INSERT INTO @PayInReport
		EXEC usp_GeneratePayInTransaction_History @clt_code, @FromDate, @ToDate, @Segment
	END 

SELECT * FROM @PayInReport 


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayInTransaction_History
-- --------------------------------------------------
  
  
-- usp_GeneratePayInTransaction_History 'B14695','01/01/2016','31/12/2016', 'BSEcm'  
-- usp_GeneratePayInTransaction_History 'B14695','01/01/2016','31/12/2016', 'NSECM'  
  
-- usp_GeneratePayInTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'  
-- usp_GeneratePayInTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'  
-- usp_GeneratePayInTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'NSEFO'  
-- usp_GeneratePayInTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'MCX'  
  
-- usp_GeneratePayInTransaction_History 'B14695','01/01/2016','31/12/2016', 'nbfc'  
  
-- usp_GeneratePayInTransaction_History 'rp61','01/05/2010','31/12/2016' , 'BSECM'  
  
  
CREATE   PROCEDURE [dbo].[usp_GeneratePayInTransaction_History]  
(                      
 @clt_code VARCHAR(20),                  
  
 @FROM_DATE VARCHAR(11),                    
  
 @TO_DATE VARCHAR(11),  
     
 @Segment VARCHAR(11)  
  
)                    
AS                    
  
BEGIN                    
  
 SELECT @FROM_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FROM_DATE,10),105),101)  
 SELECT @TO_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@TO_DATE,10),105),101)  
  
   
IF (@Segment <> 'NBFC')   
  
BEGIN  
  
 SELECT A.Co_Code, a.cltcode, a.acname, B.Branch, a.vtyp, C.Shortdesc AS VType,  A.drcr,   convert(varchar, A.vdt, 106) AS vdt,  A.vno, A.vamt  
   
 -- FROM VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
   
 FROM [CSOKYC-6].General.dbo.VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
   
 LEFT OUTER JOIN  [CSOKYC-6].General.dbo.vmast C ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code  
  
 WHERE a.cltcode = @clt_code AND VTYP = 2  AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
 AND A.Co_Code = @Segment  
END   
  
ELSE   
  
BEGIN  
  
 SELECT 'NBFC' AS Co_Code, A.cltcode, A.acname, B.Branch, a.vtyp, a.vtyp,  A.drcr,  convert(varchar, A.vdt, 106) AS vdt,  A.vno, A.vamt  
  
 FROM [CSOKYC-6].General.dbo.nbfc_ledger A  WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
  
 WHERE a.cltcode = @clt_code AND  vtyp = 'REPBNK' AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
  
END  
  
 -- 2 PayIN  
 -- 3 Payout  
  
 --SELECT CLTCODE, A.CO_CODE,  COUNT(CLTCODE) FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
 --GROUP BY CLTCODE,  A.CO_CODE   
 --HAVING COUNT(CLTCODE) > 1  
 --ORDER BY CLTCODE  
  
 --SELECT A.Co_Code, a.cltcode, a.acname, B.Branch, a.vtyp, C.Shortdesc AS VType,  A.drcr, A.vdt, A.vno, A.vamt  
 --FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
 --LEFT OUTER JOIN vmast C ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code  
 --WHERE a.cltcode = 'B14695' AND VTYP = 2  AND A.VDT >= '2014-06-08 00:00:00.000' AND A.VDT <= '2016-09-16 00:00:00.000'  
  
  
 -- SELECT CLTCODE, A.CO_CODE,  COUNT(CLTCODE) FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
 --where a.vtyp = 2   
 --GROUP BY CLTCODE,  A.CO_CODE   
 --HAVING COUNT(CLTCODE) > 1  
 --ORDER BY CLTCODE  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayOutReport
-- --------------------------------------------------
  
-- exec usp_GeneratePayOutReport 'ALWR490','01/01/1900','31/12/2016' , 'bSECM'  
--  exec usp_GeneratePayOutReport 'ALWR490','01/04/2016','31/12/2016' , 'NSECM'  
--  exec usp_GeneratePayOutReport 'B14695','01/01/2000','31/12/2016' , 'nbfc'  
  
  
CREATE PROCEDURE [dbo].[usp_GeneratePayOutReport]  
(  
 @clt_code as varchar(10),  
  
 @FromDate as varchar (100),  
  
 @ToDate as varchar (100),  
  
 @Segment VARCHAR(11)  
  
)  
AS  
  
BEGIN   
  
DECLARE @PayInReport TABLE  
(  
 [sno] int identity(1,1),  
 Co_Code nvarchar(100),  
 cltcode nvarchar(100),  
 acname nvarchar(100),  
 Branch nvarchar(100),  
 vtyp nvarchar(10),  
 VType nvarchar(100),  
 drcr nvarchar(1),  
 vdt  nvarchar(100),  
 vno nvarchar(100),  
 vamt decimal(18,2)  
)  
  
  
  
  
--declare @FDate DATETIME  
--declare @TDate DATETIME  
  
  
--SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)  
--SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)  
  
  
--DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME  
----SET @CURR_DATE='2016/03/30'  
--IF MONTH(getdate()) IN (1,2,3)  
--BEGIN  
  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)  
--END  
--ELSE  
--BEGIN  
  
--    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)  
--    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)  
--END  
  
  
  
--IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE )   
-- BEGIN  
--  --select 'cur'  
    
--  INSERT INTO @PayInReport  
--  EXEC [CSOKYC-6].[General].dbo.[RPT_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment  
-- END  
--ELSE   
-- BEGIN  
--  --SELECT 'pre'  
--  INSERT INTO @PayInReport  
--  EXEC [usp_GeneratePayOutTransaction_History] @clt_code, @FromDate, @ToDate, @Segment  
-- END   
  
  
  
 INSERT INTO @PayInReport  
 EXEC [CSOKYC-6].[General].dbo.[RPT_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment  
  
 INSERT INTO @PayInReport  
 EXEC [usp_GeneratePayOutTransaction_History] @clt_code, @FromDate, @ToDate, @Segment  
  
 DELETE FROM @PayInReport WHERE sno in  
 (  
  SELECT sno  FROM @PayInReport D WHERE   
  1 < (SELECT COUNT(*) FROM @PayInReport A WHERE A.Co_Code = D.Co_Code and A.cltcode = D.cltcode   
  and A.acname = D.acname and A.vdt = D.vdt and A.vno  = D.vno and D.sno >= A.sno)  
 )  
  
  
SELECT * FROM @PayInReport   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayOutReport_30062017
-- --------------------------------------------------

--	exec usp_GeneratePayOutReport 'ALWR490','01/01/1900','31/12/2016' , 'bSECM'
--  exec usp_GeneratePayOutReport 'ALWR490','01/04/2016','31/12/2016' , 'NSECM'
--  exec usp_GeneratePayOutReport 'B14695','01/01/2000','31/12/2016' , 'nbfc'


CREATE PROCEDURE [dbo].[usp_GeneratePayOutReport_30062017]
(
 @clt_code as varchar(10),

 @FromDate as varchar (100),

 @ToDate as varchar (100),

 @Segment VARCHAR(11)

)
AS

BEGIN 

DECLARE @PayInReport TABLE
(
	Co_Code	nvarchar(100),
	cltcode	nvarchar(100),
	acname	nvarchar(100),
	Branch	nvarchar(100),
	vtyp	nvarchar(10),
	VType	nvarchar(100),
	drcr	nvarchar(1),
	vdt		nvarchar(100),
	vno	nvarchar(100),
	vamt	decimal(18,2)
)




declare @FDate DATETIME
declare @TDate DATETIME


SELECT @FDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@FromDate,10),105),101) AS DATETIME)
SELECT @TDate = CAST(CONVERT(CHAR(11),CONVERT(DATETIME,LEFT(@ToDate,10),105),101) AS DATETIME)


DECLARE @STARTDATE DATETIME, @ENDDATE DATETIME,@CURR_DATE DATETIME
--SET @CURR_DATE='2016/03/30'
IF MONTH(getdate()) IN (1,2,3)
BEGIN

    SET @STARTDATE= CAST( CAST(YEAR(getdate())-1 AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())  AS VARCHAR)+'/03/31'  AS DATE)
END
ELSE
BEGIN

    SET @STARTDATE= CAST( CAST(YEAR(getdate()) AS VARCHAR)+'/04/01'  AS DATE)
    SET @ENDDATE= CAST( CAST(YEAR(getdate())+1 AS VARCHAR)+'/03/31'  AS DATE)
END




----	EXEC [196.1.115.182].[General].dbo.RPT_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'
----- exec [196.1.115.182].[General].dbo.RPT_PAYOUT_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'
--INSERT INTO @PayInReport
--EXEC [196.1.115.182].[General].dbo.[RPT_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment



IF (@FDate >= @STARTDATE AND   @FDate <= @ENDDATE AND @TDate >= @STARTDATE AND  @TDate  <= @ENDDATE ) 
	BEGIN
		--select 'cur'
		--	EXEC [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'
		--- exec [196.1.115.182].[General].dbo.RPT_PAYIN_CLIENTPROFILIER 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'

		INSERT INTO @PayInReport
		EXEC [196.1.115.182].[General].dbo.[RPT_PAYOUT_CLIENTPROFILIER] @clt_code, @FromDate, @ToDate, @Segment
	END
ELSE 
	BEGIN
		--SELECT 'pre'
		INSERT INTO @PayInReport
		EXEC [usp_GeneratePayOutTransaction_History] @clt_code, @FromDate, @ToDate, @Segment
	END 


SELECT * FROM @PayInReport 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePayOutTransaction_History
-- --------------------------------------------------
  
  
-- usp_GeneratePayOutTransaction_History 'B14695','01/01/2016','31/12/2016', 'BSEcm'  
-- usp_GeneratePayOutTransaction_History 'B14695','01/01/2016','31/12/2016', 'NSECM'  
  
-- usp_GeneratePayOutTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'BSEcm'  
-- usp_GeneratePayOutTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'NSECM'  
-- usp_GeneratePayOutTransaction_History 'ALWR490','01/01/1900','31/12/2016' , 'NSEFO'  
--  usp_GeneratePayOutTransaction_History 'B14695','01/01/1900','31/12/2016' , 'NBFC'  
  
  
CREATE PROCEDURE [dbo].[usp_GeneratePayOutTransaction_History]  
(                      
 @clt_code VARCHAR(20),                  
  
 @FROM_DATE VARCHAR(11),                    
  
 @TO_DATE VARCHAR(11),  
     
 @Segment VARCHAR(11)  
  
)    
                  
AS                    
  
BEGIN                    
  
 SELECT @FROM_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@FROM_DATE,10),105),101)  
 SELECT @TO_DATE =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@TO_DATE,10),105),101)  
  
  
    
IF (@Segment <> 'NBFC')   
  
BEGIN  
 SELECT A.Co_Code, a.cltcode, a.acname, B.Branch, a.vtyp, C.Shortdesc AS VType,  A.drcr,  convert(varchar, A.vdt, 106) AS vdt, A.vno, A.vamt  
  
 --FROM VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
  
 FROM [CSOKYC-6].General.dbo.VW_COMBINE_LEDGER_PAYINPAYOUT_HISTORY A WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
   
 LEFT OUTER JOIN  [CSOKYC-6].General.dbo.vmast C ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code  
  
 WHERE a.cltcode = @clt_code AND VTYP = 3  AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
 AND A.Co_Code = @Segment  
  
END  
ELSE   
  
BEGIN  
  
  
 SELECT 'NBFC' AS Co_Code, A.cltcode, A.acname, B.Branch, a.vtyp, a.vtyp,  A.drcr,  convert(varchar, A.vdt, 106) AS vdt,  A.vno, A.vamt  
  
 FROM  [CSOKYC-6].General.dbo.nbfc_ledger A  WITH(NOLOCK) INNER JOIN  [CSOKYC-6].General.dbo.VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
  
 WHERE a.cltcode = @clt_code AND  vtyp = 'PAYBNK' AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
 --SELECT 'NBFC' AS Co_Code, A.cltcode, A.acname, B.Branch, a.vtyp, a.vtyp,  A.drcr,   A.vdt,  A.vno, A.vamt  
  
 --FROM  [CSOKYC-6].General.dbo.nbfc_ledger A  WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
  
 --WHERE a.cltcode = @clt_code AND  vtyp = 'PAYBNK' AND A.VDT >= @FROM_DATE AND A.VDT <= @TO_DATE  
  
  
END  
  
 --SELECT CLTCODE, A.CO_CODE,  COUNT(CLTCODE) FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
 --GROUP BY CLTCODE,  A.CO_CODE   
 --HAVING COUNT(CLTCODE) > 1  
 --ORDER BY CLTCODE  
  
 --SELECT A.Co_Code, a.cltcode, a.acname, B.Branch, a.vtyp, C.Shortdesc AS VType,  A.drcr, A.vdt, A.vno, A.vamt  
 --FROM VW_COMBINE_LEDGER_PAYINPAYOUT A WITH(NOLOCK) INNER JOIN VW_RMS_CLIENT_VERTICAL B WITH(NOLOCK) ON A.CLTCODE = B.CLIENT   
 --LEFT OUTER JOIN vmast C ON A.vtyp = C.Vtype AND A.Co_Code = C.co_code  
 --WHERE a.cltcode = 'B14695' AND VTYP = 3  AND A.VDT >= '2014-06-08 00:00:00.000' AND A.VDT <= '2016-09-16 00:00:00.000'  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GeneratePenalCharges
-- --------------------------------------------------
  
----  exec usp_GeneratePenalCharges 'B14695','13/04/2000','21/04/2016'  
----  exec usp_GeneratePenalCharges 'ALWR490','01/01/2000','31/12/2016'  
----  exec usp_GeneratePenalCharges 'M100301','01/01/2017','17/06/2017'  
----  exec usp_GeneratePenalCharges 'v905', '25/06/2017', '10/07/2017'  
----  exec usp_GeneratePenalCharges 'rp61', '25/06/2017', '10/07/2017'  
  
--drop proc [usp_GeneratePenalCharges]  
  
CREATE PROCEDURE [dbo].[usp_GeneratePenalCharges]  
(  
  
 @clt_code AS varchar(10),  
  
 @FromDate AS varchar(100),  
  
 @ToDate AS varchar(100)  
  
)  
AS  
  
BEGIN  
  
  INSERT INTO tbl_UserLog (LoginUser, ModifiedDate)  
  VALUES ('usp_GeneratePenalCharges', GETDATE())  
  
  DECLARE @FDate varchar(40)  
  DECLARE @TDate varchar(40)  
  
  SELECT  
    @FDate = RIGHT(@FromDate, 4) + '-' + LEFT(RIGHT(@FromDate, 7), 2) + '-' + LEFT(@FromDate, 2)  
  
  SELECT  
    @TDate = RIGHT(@ToDate, 4) + '-' + LEFT(RIGHT(@ToDate, 7), 2) + '-' + LEFT(@ToDate, 2)  
  
  
  DECLARE @DPCReport TABLE (  
    Branch_cd varchar(10),  
    Sub_Broker varchar(10),  
    Party_Code varchar(100),  
    Party_name varchar(100),  
    --BalanceDate varchar(40),         
    BalanceDate datetime,  
    BSECM decimal(18, 2),  
    NSECM decimal(18, 2),  
    BSEFO decimal(18, 2),  
    NSEFO decimal(18, 2),  
    MCX decimal(18, 2),  
    NCDEX decimal(18, 2),  
    MCD decimal(18, 2),  
    NSX decimal(18, 2),  
    TOTAL decimal(18, 2),  
    InterestAmount decimal(18, 2),  
    InterestRate decimal(18, 2),  
    Gross_DPC decimal(18, 2),  
    Excl_DPC decimal(18, 2),  
    --Updatedon varchar(40),    
    Updatedon datetime,  
    Reason varchar(4000),  
    Pure_Risk decimal(18, 2),  
    --LastBillDate varchar(40),        
    LastBillDate datetime,  
    DyDiffd decimal(18, 0)  
  )  
  
  INSERT INTO @DPCReport  
  EXEC MISC.dbo.DPC_CliReport @clt_code,  
                                              @FDate,  
                                              @TDate,  
                                              'BROKER',  
             'CSO'  
    
INSERT INTO @DPCReport(Branch_cd)  
VALUES('Total')  
  
UPDATE @DPCReport  
SET  BSECM = (SELECT SUM (BSECM) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
  
UPDATE @DPCReport  
SET  NSECM = (SELECT SUM (NSECM) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
  
UPDATE @DPCReport  
SET  BSEFO = (SELECT SUM (BSEFO) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  NSEFO = (SELECT SUM (NSEFO) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  MCX = (SELECT SUM (MCX) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  NCDEX = (SELECT SUM (NCDEX) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  MCD = (SELECT SUM (MCD) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  NSX = (SELECT SUM (NSX) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  TOTAL = (SELECT SUM (TOTAL) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
  
UPDATE @DPCReport  
SET  Gross_DPC = (SELECT SUM (Gross_DPC) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
UPDATE @DPCReport  
SET  Excl_DPC = (SELECT SUM (Excl_DPC) FROM  @DPCReport)  
WHERE Branch_cd ='Total'  
  
  
  SELECT   
    Branch_cd ,  
    Sub_Broker ,  
    Party_Code ,  
    Party_name ,  
    ISNULL(CONVERT(varchar,BalanceDate,105), 'Total')  AS BalanceDate,  
    BSECM ,  
    NSECM ,  
    BSEFO ,  
    NSEFO ,  
    MCX ,  
    NCDEX ,  
    MCD ,  
    NSX ,  
    TOTAL ,  
    InterestAmount ,  
    InterestRAte ,  
    Gross_DPC ,  
    Excl_DPC ,  
 CONVERT(varchar,Updatedon ,105)  AS Updatedon ,  
    Reason ,  
    Pure_Risk ,  
 CONVERT(varchar,LastBillDate ,105)  AS LastBillDate ,  
    DyDiffd   
  FROM @DPCReport  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSebiBanned
-- --------------------------------------------------
/*  
  
exec usp_GenerateSebiBanned  'S1121'  
*/  
  
CREATE PROCEDURE usp_GenerateSebiBanned  
(  
@ClientCode varchar(40)  
)  
AS  
  
BEGIN   
  
DECLARE @PanNo varchar(40)  
  
DECLARE @SEBIBannedReport TABLE    
(    
 Name varchar (400)  
 ,[address] varchar(8000)  
 ,pan_no varchar(40)  
 ,dt_sebi_order varchar(40)  
 ,order_no varchar(2000)  
 ,Brief_particulars varchar(max)  
 ,[start_date] varchar(40)  
 ,end_date varchar(2000)  
)    
  
SELECT  @PanNo = pan_gir_no FROM [CSOKYC-6].general.dbo.client_details   
WHERE   Party_code =  @ClientCode  
  
INSERT INTO @SEBIBannedReport  
EXEC [testdb].dbo.usp_GenerateSebiBannedPMLA @PanNo  
  
  
SELECT * FROM @SEBIBannedReport  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSecuritieReport
-- --------------------------------------------------
  
--  EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC 'V905', '','%','E01089','broker','cso'    
    
    
--- exec usp_GenerateSecuritieReport 'V905'    
  
    
CREATE PROCEDURE [dbo].[usp_GenerateSecuritieReport]    
  
@client as varchar(10)    
  
--@party_name as varchar(100),            
--@co_Code as varchar(10),            
--@userid as varchar(15),            
--@access_To as varchar(10),            
--@access_Code as varchar(10)         
  
AS    
    
BEGIN     
    
--SET FMTONLY OFF    
    
--EXEC [196.1.115.182].General.dbo.Rpt_RMS_New_Holding_VHC 'V905','','%','E01089','broker','cso'    
    
    
    
    
--DECLARE @DomainHistory  TABLE    
--(    
--    [Name] nvarchar(1000)    
--)    
--INSERT INTO @DomainHistory(Name)    
--EXEC usp_SynopsisTest    
--Select * from @DomainHistory    
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES ('usp_GenerateSecuritieReport', getdate())    
  
  
DECLARE @DomainHistory  TABLE    
(  
  Branch nvarchar(1000),  
  SB  nvarchar(1000),  
  Client nvarchar(1000),  
  Client_Name nvarchar(1000),  
  ISIN nvarchar(1000),  
  [ScripCode] nvarchar(1000),  
  Symbol nvarchar(1000),  
  [POOLHOLDING]  numeric(18,2),     
  [CollateralHOLDING]  numeric(18,2),     
  [DPAccount]  numeric(18,2),     
  [NET]  numeric(18,2),     
  [Bluechip]  numeric(18,2),     
  [Good]  numeric(18,2),     
  [Average]  numeric(18,2),     
  [Poor]  numeric(18,2),     
  [TotalValue]  numeric(18,2)  
 )  
  
    
INSERT INTO @DomainHistory(    
  Branch ,  
  SB,  
  Client ,  
  Client_Name ,  
  ISIN ,  
  [ScripCode] ,  
  Symbol ,  
  [POOLHOLDING]  ,     
  [CollateralHOLDING]  ,     
  [DPAccount]  ,     
  [NET]  ,     
  [Bluechip]  ,     
  [Good]  ,     
  [Average]  ,     
  [Poor]  ,     
  [TotalValue]    
)    
EXEC [CSOKYC-6].[General].dbo.RPT_HOLDING_SEC_CLIENTPROFILIER 'CLIENT', @client, '%', '', 'Broker', 'cso'                        
  
    
INSERT INTO @DomainHistory(Symbol)    
VALUES('Total')    
    
   
UPDATE @DomainHistory    
SET  POOLHOLDING = (SELECT SUM (POOLHOLDING) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
  
UPDATE @DomainHistory    
SET  [CollateralHOLDING] = (SELECT SUM ([CollateralHOLDING]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
  
UPDATE @DomainHistory    
SET  [DPAccount] = (SELECT SUM([DPAccount]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Bluechip] = (SELECT SUM ([Bluechip]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Good] = (SELECT SUM ([Good]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Average] = (SELECT SUM ([Average]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Poor] = (SELECT SUM ([Poor]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [TotalValue] = (SELECT SUM ([TotalValue]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
    
SELECT * FROM  @DomainHistory     
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSecuritieReport_06072017
-- --------------------------------------------------
--  EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC 'V905', '','%','E01089','broker','cso'  
  
  
--- exec usp_GenerateSecuritieReport 'V905'  
  
CREATE PROCEDURE [dbo].[usp_GenerateSecuritieReport_06072017]  
@client as varchar(10)  
--@party_name as varchar(100),          
--@co_Code as varchar(10),          
--@userid as varchar(15),          
--@access_To as varchar(10),          
--@access_Code as varchar(10)       
AS  
  
BEGIN   
  
--SET FMTONLY OFF  
  
--EXEC [196.1.115.182].General.dbo.Rpt_RMS_New_Holding_VHC 'V905','','%','E01089','broker','cso'  
  
  
  
  
--DECLARE @DomainHistory  TABLE  
--(  
--    [Name] nvarchar(1000)  
--)  
--INSERT INTO @DomainHistory(Name)  
--EXEC usp_SynopsisTest  
--Select * from @DomainHistory  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateSecuritieReport', getdate())  
  
  
  
DECLARE @DomainHistory  TABLE  
(  
    [ScripCode] nvarchar(2000),   
 [ScripName] nvarchar(1000),   
 BSECM numeric(18,2),   
 AGOLD numeric(18,2),   
 NSECM numeric(18,2),    
 NSEFO numeric(18,2),   
 NBFC numeric(18,2),   
 Total numeric(18,2),   
 BLUECHIP numeric(18,2),   
 GOOD numeric(18,2),   
 Average numeric(18,2),   
 Poor numeric(18,2),   
 [TotalHOLD] numeric(18,2),   
 [Haircut] numeric(18,2),   
 [HoldingwithHaircut] numeric(18,2),   
 [VarHC] numeric(18,2),   
 [HoldHC] numeric(18,2)  
)  
  
INSERT INTO @DomainHistory(  
 [ScripCode],   
 [ScripName],   
 BSECM,   
 AGOLD,   
 NSECM,   
 NSEFO,   
 NBFC,   
 Total,    
 BLUECHIP,   
 GOOD,   
 Average,   
 Poor,   
 [TotalHOLD],   
 [Haircut],   
 [HoldingwithHaircut] ,   
 [VarHC],   
 [HoldHC]  
)  
--EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC @client, '','%','E01089','broker','cso'  
EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC_ClientProfilier @client,'','%','E01089','broker','cso'  
  
INSERT INTO @DomainHistory([ScripName])  
VALUES('Total')  
  
  
--UPDATE @DomainHistory  
--SET  BSECM= SUM(BSECM)   
--WHERE [Scrip Name] = 'Total'  
  
  
  
--UPDATE A  
--SET A.BSECM = B.BSECM1  
--FROM @DomainHistory A INNER JOIN   
--(SELECT [Scrip Code], SUM([BSECM]) AS [BSECM1]  
-- FROM @DomainHistory   
-- GROUP BY [Scrip Code]) B  
--ON A.[Scrip Name] ='Total'  
  
  
UPDATE @DomainHistory  
SET  BSECM = (SELECT SUM (BSECM) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  AGOLD = (SELECT SUM (AGOLD) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
UPDATE @DomainHistory  
SET  NSECM = (SELECT SUM (NSECM) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  NSEFO = (SELECT SUM (NSEFO) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  NBFC = (SELECT SUM (NBFC) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  Total = (SELECT SUM (Total) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  BLUECHIP = (SELECT SUM (BLUECHIP) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  GOOD = (SELECT SUM (GOOD) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  Average = (SELECT SUM (Average) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  Poor = (SELECT SUM (Poor) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory  
SET  [TotalHOLD] = (SELECT SUM ([TotalHOLD]) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
   
  
UPDATE @DomainHistory  
SET  [HoldingwithHaircut] = (SELECT SUM ([HoldingwithHaircut]) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
UPDATE @DomainHistory   
SET  [HoldHC] = (SELECT SUM ([HoldHC]) FROM  @DomainHistory)  
WHERE [ScripName] ='Total'  
  
  
  
--UPDATE @DomainHistory   
--SET  [ScripName] = '<a>Aditya Birla Fashion</a>'  
--WHERE [ScripCode] ='535755'  
  
  
SELECT * FROM  @DomainHistory   
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSecuritieReport_Ipartner
-- --------------------------------------------------
  
  
--  EXEC [196.1.115.182].[General].dbo.Rpt_RMS_New_Holding_VHC 'V905', '','%','E01089','broker','cso'    
    
    
--- exec usp_GenerateSecuritieReport 'V905'    
  
    
CREATE PROCEDURE [dbo].[usp_GenerateSecuritieReport_Ipartner]    
  
@client as varchar(10)    
  
--@party_name as varchar(100),            
--@co_Code as varchar(10),            
--@userid as varchar(15),            
--@access_To as varchar(10),            
--@access_Code as varchar(10)         
  
AS    
    
BEGIN     
    
--SET FMTONLY OFF    
    
--EXEC [196.1.115.182].General.dbo.Rpt_RMS_New_Holding_VHC 'V905','','%','E01089','broker','cso'    
    
    
    
    
--DECLARE @DomainHistory  TABLE    
--(    
--    [Name] nvarchar(1000)    
--)    
--INSERT INTO @DomainHistory(Name)    
--EXEC usp_SynopsisTest    
--Select * from @DomainHistory    
    
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
VALUES ('usp_GenerateSecuritieReport', getdate())    
  
  
DECLARE @DomainHistory  TABLE    
(  
  Branch nvarchar(1000),  
  SB  nvarchar(1000),  
  Client nvarchar(1000),  
  Client_Name nvarchar(1000),  
  ISIN nvarchar(1000),  
  [ScripCode] nvarchar(1000),  
  Symbol nvarchar(1000),  
  [POOLHOLDING]  numeric(18,2),     
  [CollateralHOLDING]  numeric(18,2),     
  [DPAccount]  numeric(18,2),     
  [NET]  numeric(18,2),     
  [Bluechip]  numeric(18,2),     
  [Good]  numeric(18,2),     
  [Average]  numeric(18,2),     
  [Poor]  numeric(18,2),     
  [TotalValue]  numeric(18,2)  
 )  
  
    
INSERT INTO @DomainHistory(    
  Branch ,  
  SB,  
  Client ,  
  Client_Name ,  
  ISIN ,  
  [ScripCode] ,  
  Symbol ,  
  [POOLHOLDING]  ,     
  [CollateralHOLDING]  ,     
  [DPAccount]  ,     
  [NET]  ,     
  [Bluechip]  ,     
  [Good]  ,     
  [Average]  ,     
  [Poor]  ,     
  [TotalValue]    
)    
EXEC [CSOKYC-6].[General].dbo.RPT_HOLDING_SEC_CLIENTPROFILIER 'CLIENT', @client, '%', '', 'Broker', 'cso'                        
  
    
INSERT INTO @DomainHistory(Symbol)    
VALUES('Total')    
    
   
UPDATE @DomainHistory    
SET  POOLHOLDING = (SELECT SUM (POOLHOLDING) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
  
UPDATE @DomainHistory    
SET  [CollateralHOLDING] = (SELECT SUM ([CollateralHOLDING]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
  
UPDATE @DomainHistory    
SET  [DPAccount] = (SELECT SUM([DPAccount]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Bluechip] = (SELECT SUM ([Bluechip]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Good] = (SELECT SUM ([Good]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Average] = (SELECT SUM ([Average]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [Poor] = (SELECT SUM ([Poor]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
UPDATE @DomainHistory    
SET  [TotalValue] = (SELECT SUM ([TotalValue]) FROM  @DomainHistory)    
WHERE Symbol ='Total'    
    
    
SELECT * FROM  @DomainHistory     
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSignificationHolding
-- --------------------------------------------------
/*

	exec usp_GenerateSignificationHolding  'AMLPP1117G'

*/

CREATE PROCEDURE [dbo].[usp_GenerateSignificationHolding]
(
	@PAN varchar(40)
)
AS

BEGIN 

	SELECT 
		ClientID
		,DPID
		,ClientName
		,PAN 
		,ScripCode
		,ScripGroup
		,ISIN
		,ISINName
		,HoldingQuantity
		,TotMarketCapShares
		,PercMarketCap
		,AffiliatedAs
		
	FROM 
		[dbo].[tbl_ShareHolder]
	WHERE 
		RecordStatus = 'A' 
		AND pan  = @PAN

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSIPCancellation
-- --------------------------------------------------
    
/*    
    
EXEC usp_GenerateSIPCancellation 'NEHR6396','','','06-2018','',''    
EXEC usp_GenerateSIPCancellation '','','','','',''    
EXEC usp_GenerateSIPCancellation 'A1033914','DEBT','123Hdfc Mutual Fund','','',''    
EXEC usp_GenerateSIPCancellation 'A103394','','','','',''    
    
*/    
    
CREATE PROCEDURE [dbo].[usp_GenerateSIPCancellation]    
(    
 @clientcode varchar(50) = null,      
 @amcname varchar(50) = null,      
 @schemetype varchar(50) = null,      
 @selectedmonthyear varchar(10) = null ,    
 @Access_to varchar(50)=null,     
 @Access_code varchar(50)=null    
)    
AS      
BEGIN    
    
 DECLARE @SIPCancellation TABLE     
 (    
  SrNo int,    
  sclientcode varchar(100),    
  party_name varchar(400),    
  amcname varchar(1000),    
  schemename varchar(1000),    
  scheme_type varchar(100),    
  amount decimal(18,2),    
  sipregndate varchar(40),    
  sipcancellationdate varchar(40),    
  startdate varchar(40),     
  endate  varchar(40),     
  noofinstallpaid int,      
  siptype varchar(40),     
  sbtag varchar(40),     
  frequencytype  varchar(40)    
 )    
    
INSERT INTO @SIPCancellation    
EXEC [196.1.115.253].MUTUALFUND.DBO.[usp_GetXsipSipCancellationSBReport] @clientcode,@amcname,@schemetype,@selectedmonthyear,'',''    
    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
--INSERT INTO @SIPCancellation    
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',    
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')    
    
    
SELECT * FROM @SIPCancellation    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSIPCancellation_20_Nov_2021
-- --------------------------------------------------
  
/*  
  
EXEC usp_GenerateSIPCancellation 'NEHR6396','','','06-2018','',''  
EXEC usp_GenerateSIPCancellation '','','','','',''  
EXEC usp_GenerateSIPCancellation 'A1033914','DEBT','123Hdfc Mutual Fund','','',''  
EXEC usp_GenerateSIPCancellation 'A103394','','','','',''  
  
*/  
  
CREATE PROCEDURE [dbo].[usp_GenerateSIPCancellation_20_Nov_2021]  
(  
 @clientcode varchar(50) = null,    
 @amcname varchar(50) = null,    
 @schemetype varchar(50) = null,    
 @selectedmonthyear varchar(10) = null ,  
 @Access_to varchar(50)=null,   
 @Access_code varchar(50)=null  
)  
AS    
BEGIN  
  
 DECLARE @SIPCancellation TABLE   
 (  
  SrNo int,  
  sclientcode varchar(100),  
  party_name varchar(400),  
  amcname varchar(1000),  
  schemename varchar(1000),  
  scheme_type varchar(100),  
  amount decimal(18,2),  
  sipregndate varchar(40),  
  sipcancellationdate varchar(40),  
  startdate varchar(40),   
  endate  varchar(40),   
  noofinstallpaid int,    
  siptype varchar(40),   
  sbtag varchar(40),   
  frequencytype  varchar(40)  
 )  
  
INSERT INTO @SIPCancellation  
EXEC [196.1.115.132].MUTUALFUND.DBO.[usp_GetXsipSipCancellationSBReport] @clientcode,@amcname,@schemetype,@selectedmonthyear,'',''  
  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (1, 'NEHR6396', 'Nikhil  Dutta', 'Sbi Mutual Fund', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'XYZ', 'John Machlen', 'HDFC', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
--INSERT INTO @SIPCancellation  
--VALUES (2, 'ACDD6396', 'Smith Gaber', 'AXIS', 'Sbi Blue Chip Fund - Growth', 'EQUITY', 2000.00, '25 Nov 2017', '20 Jun 2018', '15 Jan 2018',  
--'14 Jan 2021', 7, 'Xsip', 'NAKC', 'Monthly')  
  
  
SELECT * FROM @SIPCancellation  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSTR
-- --------------------------------------------------
/*

usp_GenerateSTR 0


*/
CREATE PROCEDURE [dbo].[usp_GenerateSTR]  
(
@ID int  =  0
)
AS 

if (@ID <> 0)
BEGIN 
SELECT 
	ID
	,convert(varchar, strDate, 105) AS strDate
	,CompanyName
	,GroundOfSuspicion
	,insertedBy
	,convert(varchar, insertedOn, 105) AS insertedOn
	,updatedBy
	,convert(varchar, updatedOn, 105) AS updatedOn
	,'<a class=''modify'' href="#">Modify</a>' AS [Modify]
	,'<a class=''delete'' href=''#''>Delete</a>' as [Delete]
    ,'<a class=''mapping'' href=''#''>Map Clients</a>' as Mapping

 FROM tbl_Str_Master WHERE ID  = @ID

END 
ELSE 
BEGIN 
SELECT 
	ID
	,convert(varchar, strDate, 105) AS strDate
	,CompanyName
	,GroundOfSuspicion
	,insertedBy
	,convert(varchar, insertedOn, 105) AS insertedOn
	,updatedBy
	,convert(varchar, updatedOn, 105) AS updatedOn
	,'<a class=''modify'' href=''#''>Modify</a>' AS [Modify]
	,'<a class=''delete'' href=''#''>Delete</a>' as [Delete]
    ,'<a class=''mapping'' href=''#''>Map Clients</a>' as Mapping

 FROM tbl_Str_Master 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSTR_backup14022016
-- --------------------------------------------------

/*

usp_GenerateSTR 0


*/
CREATE PROCEDURE [dbo].[usp_GenerateSTR_backup14022016]  
(
@ID int  =  0
)
AS 

if (@ID <> 0)
BEGIN 
SELECT 
	ID
	,convert(varchar, strDate, 105) AS strDate
	,CompanyName
	,GroundOfSuspicion
	,insertedBy
	,convert(varchar, insertedOn, 105) AS insertedOn
	,updatedBy
	,convert(varchar, updatedOn, 105) AS updatedOn
	,'<a class=''modify'' href="#">Modify</a>' AS [Modify]
	,'<a class=''delete'' href=''#''>Delete</a>' as [Delete]
    ,'<a class=''mapping'' href=''#''>Map Clients</a>' as Mapping

 FROM tbl_Str_Master WHERE ID  = @ID

END 
ELSE 
BEGIN 
SELECT 
	ID
	,convert(varchar, strDate, 105) AS strDate
	,CompanyName
	,GroundOfSuspicion
	,insertedBy
	,convert(varchar, insertedOn, 105) AS insertedOn
	,updatedBy
	,convert(varchar, updatedOn, 105) AS updatedOn
	,'<a class=''modify'' href=''#''>Modify</a>' AS [Modify]
	,'<a class=''delete'' href=''#''>Delete</a>' as [Delete]
    ,'<a class=''mapping'' href=''#''>Map Clients</a>' as Mapping

 FROM tbl_Str_Master 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSTRExport
-- --------------------------------------------------

/*
	
	usp_GenerateSTRExport



*/
	
CREATE PROC [dbo].[usp_GenerateSTRExport]

AS



--SELECT 
--	'31-01-2017' AS STRDate,	
--	'1' AS BatchNumber, 
--	'Trading' AS Category,	
--	'Shah & Co.' AS ClientName, 
--	'Apop01245' AS	PANNo, 
--	'ABC internation' AS CompanyName,	
--	'Ground Of Suspicion' AS GroundOfSuspicion


select id,BID,categoryid,clientcode+'-'+substring(clientname,charindex('-',clientname)+2,len(clientname)) as clientname,panno, isactive,ctype,
strdate,companyname,groundofsuspicion
into #tbl_str_Client_Master 
from 
(
	--select a.*,b.ctype, convert(varchar,d.strdate,105) as strdate ,companyname,groundofsuspicion from tbl_str_Client_Master  a
	--join   tbl_str_category b
	--on a.categoryid=b.id
	--right outer join tbl_str_master d
	--on d.id=a.batchid
	--where a.isactive=1

	SELECT a.*, b.ctype, d.id as BID,convert (varchar,d.strdate,105) as strdate ,companyname,groundofsuspicion 
	from tbl_str_master d 
	LEFT OUTER join   tbl_str_Client_Master  a
	on d.id = a.batchid and a.isactive=1
	LEFT OUTER join   tbl_str_category b
	on a.categoryid=b.id
	

	--SELECT a.*, b.ctype, d.id as BID,d.strdate as strdate ,companyname,groundofsuspicion 
	--from tbl_str_master d 
	--LEFT OUTER join   tbl_str_Client_Master  a
	--on d.id = a.batchid and a.isactive=1
	--LEFT OUTER join   tbl_str_category b
	--on a.categoryid=b.id
	

) c

SELECT  
	ISNULL(t1.strdate, '') as STRDate,
	ISNULL(cast(t1.BID as varchar), '') as BatchNumber,
	ISNULL(t1.ctype, '') as Category,
ISNULL(
		   STUFF(
				(SELECT ',' + t.[clientname]
				FROM #tbl_str_Client_Master t
				WHERE t.BID = t1.BID
				ORDER BY t.[clientname]
				FOR XML PATH(''))
				, 1, 1, ''
				)
	  , '')  AS ClientName,
ISNULL(
		STUFF(
				(SELECT ', ' + panno
				FROM #tbl_str_Client_Master t2
				where t1.BID = t2.BID
				FOR XML PATH (''))
				, 1, 1, ''
			 )  
		 , '') AS PANNo
,t1.companyname as CompanyName
,t1.groundofsuspicion as GroundOfSuspicion

FROM #tbl_str_Client_Master t1
GROUP BY 
		t1.BID,t1.ctype
			,t1.strdate
					,t1.companyname
							,t1.groundofsuspicion



---order by t1.strdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSTRList
-- --------------------------------------------------
/*
	exec usp_GenerateSTRList 'rp61'

	exec usp_GenerateSTRList 'AGJPB7753L'

*/

CREATE PROC [dbo].[usp_GenerateSTRList]
(

 @PAN nvarchar (40)

)

AS


--SELECT a.id, cast(A.ID as varchar) AS BatchNumber, C.Ctype AS Category,  convert(varchar, A.insertedOn, 106)  AS insertedOn, a.GroundOfSuspicion 
--FROM 
--	tbl_Str_Master A 
--	INNER JOIN tbl_str_Client_Master B 
--		ON A.Id = B.BatchId
--		INNER JOIN tbl_Str_Category C
--			ON B.CategoryId =  C.ID	
--WHERE 
--	B.PanNo = @PAN

--commented on 22 May 2017
--SELECT a.id, cast(A.ID as varchar) AS BatchNumber, C.Ctype AS Category,  A.insertedOn, a.GroundOfSuspicion 
--FROM 
--	tbl_Str_Master A 
--	INNER JOIN tbl_str_Client_Master B 
--		ON A.Id = B.BatchId
--		INNER JOIN tbl_Str_Category C
--			ON B.CategoryId =  C.ID	
--WHERE 
--	B.PanNo = @PAN

SELECT a.id, cast(A.ID as varchar) AS BatchNumber, C.Ctype AS Category,  A.Strdate AS insertedOn, a.GroundOfSuspicion 
FROM 
	tbl_Str_Master A 
	INNER JOIN tbl_str_Client_Master B 
		ON A.Id = B.BatchId
		INNER JOIN tbl_Str_Category C
			ON B.CategoryId =  C.ID	
WHERE 
	B.PanNo = @PAN


---select * from tbl_Str_Master

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSTRMasterExport
-- --------------------------------------------------
/*
	usp_GenerateSTRMasterExport
*/
	
CREATE PROC [dbo].[usp_GenerateSTRMasterExport]
AS

DECLARE @tblstrClientMaster TABLE 
(
	id int
	,BID int
	,categoryid int
	,clientname nvarchar(100)
	,panno nvarchar(100)  
	,isactive bit
	,ctype nvarchar(100)
	,strdate smalldatetime
	,companyname varchar(400)  
	,groundofsuspicion varchar(max)
)

INSERT INTO @tblstrClientMaster
SELECT id,BID,categoryid,clientcode+'-'+substring(clientname,charindex('-',clientname)+2,len(clientname)) as clientname,panno, isactive,ctype,
strdate,companyname,groundofsuspicion
from 
(
	--select a.*,b.ctype, convert(varchar,d.strdate,105) as strdate ,companyname,groundofsuspicion from tbl_str_Client_Master  a
	--join   tbl_str_category b
	--on a.categoryid=b.id
	--right outer join tbl_str_master d
	--on d.id=a.batchid
	--where a.isactive=1

	--SELECT a.*, b.ctype, d.id as BID,convert (varchar,d.strdate,105) as strdate ,companyname,groundofsuspicion 
	--from tbl_str_master d 
	--LEFT OUTER join   tbl_str_Client_Master  a
	--on d.id = a.batchid and a.isactive=1
	--LEFT OUTER join   tbl_str_category b
	--on a.categoryid=b.id
	

	SELECT a.*, b.ctype, d.id as BID,d.strdate as strdate ,companyname,groundofsuspicion 
	from tbl_str_master d 
	LEFT OUTER join   tbl_str_Client_Master  a
	on d.id = a.batchid and a.isactive=1
	LEFT OUTER join   tbl_str_category b
	on a.categoryid=b.id
) c


--SELECT id,BID,categoryid,clientcode+'-'+substring(clientname,charindex('-',clientname)+2,len(clientname)) as clientname,panno, isactive,ctype,
--strdate,companyname,groundofsuspicion
--into @tblstrClientMaster
--from 
--(
--	SELECT a.*, b.ctype, d.id as BID,convert (varchar,d.strdate,105) as strdate ,companyname,groundofsuspicion 
--	from tbl_str_master d 
--	LEFT OUTER join   tbl_str_Client_Master  a
--	on d.id = a.batchid and a.isactive=1
--	LEFT OUTER join   tbl_str_category b
--	on a.categoryid=b.id
--) c

SELECT  
	ISNULL(t1.strdate, '') as STRDate,
	ISNULL(cast(t1.BID as varchar), '') as BatchNumber,
	ISNULL(t1.ctype, '') as Category,
ISNULL(
		   STUFF(
				(SELECT ',' + t.[clientname]
				FROM @tblstrClientMaster t
				WHERE t.BID = t1.BID
				ORDER BY t.[clientname]
				FOR XML PATH(''))
				, 1, 1, ''
				)
	  , '')  AS ClientName,
ISNULL(
		STUFF(
				(SELECT ', ' + panno
				FROM @tblstrClientMaster t2
				where t1.BID = t2.BID
				FOR XML PATH (''))
				, 1, 1, ''
			 )  
		 , '') AS PANNo
,t1.companyname as CompanyName
,t1.groundofsuspicion as GroundOfSuspicion

FROM @tblstrClientMaster t1
GROUP BY 
		t1.BID,t1.ctype
			,t1.strdate
					,t1.companyname
							,t1.groundofsuspicion

---order by t1.strdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateSynopsisList
-- --------------------------------------------------
--  exec usp_GenerateSynopsisList 'gj3214'  
--- exec usp_GenerateSynopsisList 'G18145'  
--- exec usp_GenerateSynopsisList 'rp61'  
  
CREATE PROC [dbo].[usp_GenerateSynopsisList]  
(  
 @PARTY_CODE nvarchar (40)  
)  
AS  
  
  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GenerateSynopsisList', getdate())  
  
  
SELECT * FROM tbl_Synopsis WHERE code = @PARTY_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GenerateTSSAlert
-- --------------------------------------------------

/*
	--exec usp_GenerateBSEAlert 'R87276', '13/11/2016', '13/11/2016'
	exec usp_GenerateTSSAlert 'R87276', 'O', 'TSS Money flow Out'
	exec usp_GenerateTSSAlert 'R87276', 'I', 'TSS Money flow In'
*/


CREATE PROC [dbo].[usp_GenerateTSSAlert]
(
	@ClientID varchar(20)
	,@InOut char (1)
	,@TSStype varchar (20)
)
AS
BEGIN

SELECT 
	ID
	,ClientName
	,Networth
	,Income
	,Strength
	,CASE WHEN @InOut  =  'I' THEN MoneyInOut END AS MoneyIn
	,CASE WHEN @InOut  =  'O' THEN MoneyInOut END AS MoneyOut 
	,ViolationAmt
	,CONVERT(VARCHAR,MinTransDate, 103) MinTransDate
	,CONVERT(VARCHAR,MaxTransDate, 103) MaxTransDate
	,NetworthDesc
	,IncomeDesc
	,IsNBFClient
	,CaseId
	--,CONVERT(VARCHAR, ClosedDate, 103) ClosedDate
	,RegisterCaseID
	,LastestIncome
	,IntermediatoryCode
	---,IntermediatoryName
	,RiskCategory
	,CSC
	,CONVERT(VARCHAR,AddedOn, 103) AddedOn
	,CONVERT(VARCHAR,EditedOn, 103) EditedOn
	,Comment
	,[Status]
FROM 
	[dbo].[tbl_TSSAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND TSStype =  @TSStype
	
--SELECT * 
--FROM 
--	[dbo].[tbl_TSSAlert]

/*
	Update [tbl_TSSAlert]
	SET ClientID  = 'R87276'

	Update [tbl_TSSAlert]
	SET RecordStatus  = 'A'

	Update [tbl_TSSAlert]
	SET RecordStatus  = 'D'
	WHERE ID > 2000

	-- truncate table tbl_TSSAlert
	
*/

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_STR
-- --------------------------------------------------
CREATE PROC USP_GET_STR
AS
BEGIN
SELECT * from tbl_str
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_getBigSavingInvestmentDetailsReport
-- --------------------------------------------------
CREATE proc [dbo].[USP_getBigSavingInvestmentDetailsReport]              
(@clientCode varchar(500)=null)      
as              
begin   
SET FMTONLY OFF    
SELECT sclientcode, ISNULL(nTotalUnits,0.00) AS totalunits, ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)  as bigsavingbalance ,            
 ISNULL(nInvestedAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)  As investedamt,          
 (ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)) -           
 (ISNULL(nInvestedAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00) ) AS earnedmoney,           
  CONVERT(decimal(30,4),(((ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00)) * 0.90)-ISNULL(nredemptionAmt,0.00))) As instaredemption,        
  CONVERT(decimal(30,4),(((ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00)))-ISNULL(nredemptionAmt,0.00))) as withdrawalamt          
 INTO #bigsaving        
 FROM [196.1.115.253].mutualfund.dbo.tblBigSavingAccount with(nolock)   
   
 select  angelid,Folio,requesttime= max(requesttime)   
 into #foliotabel  
 from [172.31.16.75].ANGEL_WMS.dbo.UserLiquidFundDetails  with(nolock)  
group by angelid,Folio   
  
   
     
select bsa.id, bsa.sClientCode,bsa.nTotalUnits,CASE WHEN bs.bigsavingbalance < 0 THEN 0.0000 ELSE bs.bigsavingbalance END AS bigsavingbalance,    
CASE WHEN bs.investedamt < 0 THEN 0.0000 ELSE bs.investedamt END AS investedamt,      
bs.earnedmoney,      
CASE WHEN bs.instaredemption < 0 THEN 0.0000 ELSE bs.instaredemption END AS instaredemption,      
CASE WHEN bs.withdrawalamt < 0 THEN 0.0000 ELSE bs.withdrawalamt END AS withdrawalamt,  
f.Folio,     
bsa.nLastNav,bsa.nAvgNav,bsa.nInvestwellAmt,bsa.nExecutedAmt,bsa.nPendingAmt,      
bsa.nInprocessAmt,bsa.nRedemptionAmt,bsa.dInsertedOn,bsa.dUpdatedOn,bsa.sUpdatedBy,bsa.nInvestedAmt       
from [196.1.115.253].mutualfund.dbo.tblBigSavingAccount bsa join #bigsaving as bs on bsa.sClientCode=bs.sClientCode  
left join #foliotabel as f on bsa.sClientCode=f.angelid           
where (bsa.sClientCode=@clientCode or @clientCode is null)                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_getBigSavingInvestmentDetailsReport_20_Nov_2021
-- --------------------------------------------------
CREATE proc [dbo].[USP_getBigSavingInvestmentDetailsReport_20_Nov_2021]              
(@clientCode varchar(500)=null)      
as              
begin   
SET FMTONLY OFF    
SELECT sclientcode, ISNULL(nTotalUnits,0.00) AS totalunits, ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)  as bigsavingbalance ,            
 ISNULL(nInvestedAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)  As investedamt,          
 (ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00)) -           
 (ISNULL(nInvestedAmt,0.00) + ISNULL(nExecutedAmt,0.00) + ISNULL(nPendingAmt,0.00) + ISNULL(nInprocessAmt,0.00)  - ISNULL(nredemptionAmt,0.00) ) AS earnedmoney,           
  CONVERT(decimal(30,4),(((ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00)) * 0.90)-ISNULL(nredemptionAmt,0.00))) As instaredemption,        
  CONVERT(decimal(30,4),(((ISNULL(ninvestwellAmt,0.00) + ISNULL(nExecutedAmt,0.00)))-ISNULL(nredemptionAmt,0.00))) as withdrawalamt          
 INTO #bigsaving        
 FROM [196.1.115.132].mutualfund.dbo.tblBigSavingAccount with(nolock)   
   
 select  angelid,Folio,requesttime= max(requesttime)   
 into #foliotabel  
 from [172.31.16.75].ANGEL_WMS.dbo.UserLiquidFundDetails  with(nolock)  
group by angelid,Folio   
  
   
     
select bsa.id, bsa.sClientCode,bsa.nTotalUnits,CASE WHEN bs.bigsavingbalance < 0 THEN 0.0000 ELSE bs.bigsavingbalance END AS bigsavingbalance,    
CASE WHEN bs.investedamt < 0 THEN 0.0000 ELSE bs.investedamt END AS investedamt,      
bs.earnedmoney,      
CASE WHEN bs.instaredemption < 0 THEN 0.0000 ELSE bs.instaredemption END AS instaredemption,      
CASE WHEN bs.withdrawalamt < 0 THEN 0.0000 ELSE bs.withdrawalamt END AS withdrawalamt,  
f.Folio,     
bsa.nLastNav,bsa.nAvgNav,bsa.nInvestwellAmt,bsa.nExecutedAmt,bsa.nPendingAmt,      
bsa.nInprocessAmt,bsa.nRedemptionAmt,bsa.dInsertedOn,bsa.dUpdatedOn,bsa.sUpdatedBy,bsa.nInvestedAmt       
from [196.1.115.132].mutualfund.dbo.tblBigSavingAccount bsa join #bigsaving as bs on bsa.sClientCode=bs.sClientCode  
left join #foliotabel as f on bsa.sClientCode=f.angelid           
where (bsa.sClientCode=@clientCode or @clientCode is null)                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetCaseAnalysisList
-- --------------------------------------------------

/*
	exec usp_GetCaseAnalysisList  'rp61'


*/

CREATE PROC [dbo].[usp_GetCaseAnalysisList]
(
	@ClientID varchar (40)
)
AS
BEGIN 

	SELECT 
		ID
		,CONVERT(VARCHAR,RecordAddedon, 106) [STR Date]
		,SuspiciousNon
		, BackgroundComment
		, FinancialComment
		, TradingComment 
		, case Submit When 1 then 'Closed' else 'open' end Submit
		, 'Edit ' AS Modify
		 
	FROM 
		tbl_CaseAnalysis
		WHERE 
			ClientID = @ClientID 
			Order By RecordAddedon
END 






--insert into tbl_CaseAnalysis 
--(
--ClientID
--,AlertComment
--,BackgroundComment
--,FinancialComment
--,STRComment
--,SignificantScripName
--,SignificantComment
--,DPComment
--,TradingComment
--,OtherDetail
--,SuspiciousNon
--,Conclusion
--,Submit
--,RecordStatus
--,RecordAddedon
--,RecordEditedon
--)
--select 
--ClientID
--,AlertComment
--,BackgroundComment
--,FinancialComment
--,STRComment
--,SignificantScripName
--,SignificantComment
--,DPComment
--,TradingComment
--,OtherDetail
--,SuspiciousNon
--,Conclusion
--,Submit
--,RecordStatus
--,RecordAddedon
--,RecordEditedon
--From tbl_CaseAnalysis

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetCDSLAlertCount
-- --------------------------------------------------

/*
	exec usp_GetCDSLAlertCount 'R87276'
*/

CREATE PROC [dbo].[usp_GetCDSLAlertCount]
(
	@ClientID varchar(20)
)
AS
BEGIN

DECLARE @Countfiu1 INT
DECLARE @Countfiu2 INT
DECLARE @Countfiu3 INT
DECLARE @Countfiu4 INT
DECLARE @Countfiu5 INT


SELECT  @Countfiu1  =  COUNT(0)
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType =  'fiu1'

SELECT  @Countfiu2  =  COUNT(0)
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType =  'fiu2'

SELECT  @Countfiu3  =  COUNT(0)
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType =  'fiu3'

SELECT  @Countfiu4  =  COUNT(0)
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType =  'fiu4'

SELECT  @Countfiu5  =  COUNT(0)
FROM 
	[dbo].[tbl_CDSLAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND CDSLType =  'fiu5'
	
SELECT  
	@Countfiu1 AS Countfiu1 
	,@Countfiu2 AS Countfiu2 
	,@Countfiu3 AS Countfiu3 
	,@Countfiu4 AS Countfiu4
	,@Countfiu5 AS Countfiu5  


END 

/*

SELECT  distinct   CDSLType
FROM 
	[dbo].[tbl_CDSLAlert] 

*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetClientCodes
-- --------------------------------------------------
CREATE PROC [dbo].[usp_GetClientCodes](@clientcode varchar(20))  
AS  
BEGIN  
SELECT DISTINCT cl_code     
FROM risk.dbo.client_details     
WHERE cl_code like @clientcode   
--and last_inactive_date > GETDATE()   
ORDER BY cl_code    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetClientDpSbCodes
-- --------------------------------------------------
CREATE PROC [dbo].[usp_GetClientDpSbCodes](      
@clientcode varchar(20),      
@type varchar(20)      
)        
AS        
BEGIN        
IF @type = 'trading'      
BEGIN      
 SELECT DISTINCT cl_code as clientcode,cl_code +  ISNULL(NULLIF(' - ' +short_name,''),'') as clientname,ISNULL(pan_gir_no,'') as panno      
 FROM risk.dbo.client_details           
 WHERE cl_code like @clientcode         
 ORDER BY cl_code          
END      
IF @type = 'dp'      
BEGIN    
 SELECT TOP 100 client_code as clientcode, client_code + ISNULL(NULLIF(' - ' +first_hold_name ,''),'')as clientname,ISNULL(itpan,'') as panno          
 FROM AngelDP4.inhouse.dbo.tbl_client_master          
 where status <> 'closed' and client_code like @clientcode          
END    
IF @type = 'SB'    
BEGIN    
SELECT TOP 100 sbtag as clientcode, sbtag + ISNULL(NULLIF(' - ' +tradename ,''),'')as clientname,ISNULL(panno,'') as panno          
 FROM MIS.sb_comp.dbo.sb_broker       
 where sbtag like @clientcode    
END    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetClientDpSbCodes_25jan2022
-- --------------------------------------------------
CREATE PROC [dbo].[usp_GetClientDpSbCodes_25jan2022](    
@clientcode varchar(20),    
@type varchar(20)    
)      
AS      
BEGIN      
IF @type = 'trading'    
BEGIN    
 SELECT DISTINCT cl_code as clientcode,cl_code +  ISNULL(NULLIF(' - ' +short_name,''),'') as clientname,ISNULL(pan_gir_no,'') as panno    
 FROM [196.1.115.132].risk.dbo.client_details         
 WHERE cl_code like @clientcode       
 ORDER BY cl_code        
END    
IF @type = 'dp'    
BEGIN  
 SELECT TOP 100 client_code as clientcode, client_code + ISNULL(NULLIF(' - ' +first_hold_name ,''),'')as clientname,ISNULL(itpan,'') as panno        
 FROM [172.31.16.94].inhouse.dbo.tbl_client_master        
 where status <> 'closed' and client_code like @clientcode        
END  
IF @type = 'SB'  
BEGIN  
SELECT TOP 100 sbtag as clientcode, sbtag + ISNULL(NULLIF(' - ' +tradename ,''),'')as clientname,ISNULL(panno,'') as panno        
 FROM [196.1.115.167].sb_comp.dbo.sb_broker     
 where sbtag like @clientcode  
END  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_GetLumsumOrderDetails
-- --------------------------------------------------
  
CREATE proc [dbo].[Usp_GetLumsumOrderDetails]          
(@clientCode varchar(500)=null,@SelectedOrderStatus varchar(500)=null,@InsertedOnFromDate varchar(50)=null,@InsertedOnToDate varchar(50)=null)          
as          
begin          
SET FMTONLY OFF   
SELECT DISTINCT scheme_code, scheme_name,scheme_type      
into #vw_etl_mfschememaster    
FROM [196.1.115.253].mutualfund.dbo.vw_etl_mfschememaster      
    
    
SELECT ID,samc,scheme_name,sClientCode,nAmountUnit,(case  when sPurchaseRedeem='P' then 'Purchase' when sPurchaseRedeem='R' then 'Redeem' end) as sPurchaseRedeem,        
(case when sDematPhysical='C' then 'Demat' when sDematPhysical='P' then 'Physical' end) as sDematPhysical,          
sBuySell,sUserRefNo,dbo.Fun_GetOrderStatusName(sOrderStatus) as sOrderStatus,sBSEOrderNo,(case when sDematPhysical='C' then sDpid when sDematPhysical='P' then sFolioNo end) as sFolioNo_sDpid          
,nAllotedAmtUnit,CONVERT(VARCHAR(20), dExportedOn, 100) as dExportedOn,sSubrokerARNCode,sEUINNumber,sUserType,sInsertedBy,CONVERT(VARCHAR(20), dInsertedOn, 100) as dInsertedOn,sRemarks          
FROM [196.1.115.253].mutualfund.dbo.tblLumsumOrderDetails as lod          
join #vw_etl_mfschememaster sm on lod.sSchemeCode =sm.scheme_code  
where (sClientCode=@clientCode or @clientCode is null)              
and (sOrderStatus=@SelectedOrderStatus or @SelectedOrderStatus is null)              
and ((convert(datetime,Convert(varchar,dInsertedOn,105), 103) BETWEEN  convert(datetime,@InsertedOnFromDate, 103) and convert(datetime,@InsertedOnToDate, 103)) or (@InsertedOnFromDate is null and @InsertedOnToDate is null))       
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_GetLumsumOrderDetails_20_Nov_2021
-- --------------------------------------------------
  
CREATE proc [dbo].[Usp_GetLumsumOrderDetails_20_Nov_2021]          
(@clientCode varchar(500)=null,@SelectedOrderStatus varchar(500)=null,@InsertedOnFromDate varchar(50)=null,@InsertedOnToDate varchar(50)=null)          
as          
begin          
SET FMTONLY OFF   
SELECT DISTINCT scheme_code, scheme_name,scheme_type      
into #vw_etl_mfschememaster    
FROM [196.1.115.132].mutualfund.dbo.vw_etl_mfschememaster      
    
    
SELECT ID,samc,scheme_name,sClientCode,nAmountUnit,(case  when sPurchaseRedeem='P' then 'Purchase' when sPurchaseRedeem='R' then 'Redeem' end) as sPurchaseRedeem,        
(case when sDematPhysical='C' then 'Demat' when sDematPhysical='P' then 'Physical' end) as sDematPhysical,          
sBuySell,sUserRefNo,dbo.Fun_GetOrderStatusName(sOrderStatus) as sOrderStatus,sBSEOrderNo,(case when sDematPhysical='C' then sDpid when sDematPhysical='P' then sFolioNo end) as sFolioNo_sDpid          
,nAllotedAmtUnit,CONVERT(VARCHAR(20), dExportedOn, 100) as dExportedOn,sSubrokerARNCode,sEUINNumber,sUserType,sInsertedBy,CONVERT(VARCHAR(20), dInsertedOn, 100) as dInsertedOn,sRemarks          
FROM [196.1.115.132].mutualfund.dbo.tblLumsumOrderDetails as lod          
join #vw_etl_mfschememaster sm on lod.sSchemeCode =sm.scheme_code  
where (sClientCode=@clientCode or @clientCode is null)              
and (sOrderStatus=@SelectedOrderStatus or @SelectedOrderStatus is null)              
and ((convert(datetime,Convert(varchar,dInsertedOn,105), 103) BETWEEN  convert(datetime,@InsertedOnFromDate, 103) and convert(datetime,@InsertedOnToDate, 103)) or (@InsertedOnFromDate is null and @InsertedOnToDate is null))       
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GETMutualFundAMCSCHEME
-- --------------------------------------------------
  
  
/*  
 EXEC usp_GETMutualFundAMCSCHEME 'amc'  
 GO  
 EXEC usp_GETMutualFundAMCSCHEME ''  
 GO  
*/  
  
CREATE PROCEDURE [dbo].[usp_GETMutualFundAMCSCHEME]     
 @type as varchar(10)  
AS    
BEGIN  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GETMutualFundAMCSCHEME', getdate())  
  
 DECLARE @AMCandScheme TABLE   
 (  
  ID INT identity   
  ,samcname varchar(max)  
 )  
  
 INSERT INTO @AMCandScheme  
 EXEC [196.1.115.253].MUTUALFUND.DBO.usp_getinstallmentdueamccodeschemetype @type  
  
  SELECT * FROM @AMCandScheme  
  
  
-- SELECT * FROM tblAMCandScheme  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GETMutualFundAMCSCHEME_20_Nov_2021
-- --------------------------------------------------
  
  
/*  
 EXEC usp_GETMutualFundAMCSCHEME 'amc'  
 GO  
 EXEC usp_GETMutualFundAMCSCHEME ''  
 GO  
*/  
  
CREATE PROCEDURE [dbo].[usp_GETMutualFundAMCSCHEME_20_Nov_2021]     
 @type as varchar(10)  
AS    
BEGIN  
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GETMutualFundAMCSCHEME', getdate())  
  
 DECLARE @AMCandScheme TABLE   
 (  
  ID INT identity   
  ,samcname varchar(max)  
 )  
  
 INSERT INTO @AMCandScheme  
 EXEC [196.1.115.132].MUTUALFUND.DBO.usp_getinstallmentdueamccodeschemetype @type  
  
  SELECT * FROM @AMCandScheme  
  
  
-- SELECT * FROM tblAMCandScheme  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetMutualFundPortfolio
-- --------------------------------------------------

/*

exec usp_GetMutualFundPortfolio 'rp61'

*/

CREATE PROC [dbo].[usp_GetMutualFundPortfolio]  
(  
@clientcode VARCHAR(50)  
)  
AS  
BEGIN 
--SET FMTONLY OFF 

INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)
VALUES ('usp_GetMutualFundPortfolio', getdate())


DECLARE @MFP AS TABLE 
(
	AsOnDate [varchar](100) NULL,
	PartyCode [varchar](100) NULL,
	Exchange [varchar](100) NULL,
	AngelCode [varchar](100) NULL,
	AMCSchemeCode [varchar](10) NULL,
	CoSchCode [varchar](100) NULL,
	ISIN [varchar](100) NULL,
	SchemeName [varchar](4000) NULL,
	SchemeCategory [varchar](1000) NULL,
	TotalQty [varchar](100) NULL,
	AngelQty [varchar](100) NULL,
	RedeemableQty [varchar](100) NULL,
	AvgPrice [varchar](100) NULL,
	LastNAVPrice [varchar](100) NULL,
	PrevNAV [varchar](100) NULL,
	LastUpdateTime [varchar](100) NULL,
	DATA1 [varchar](100) NULL,
	MapID [varchar](100) NULL,
	ProductID [varchar](100) NULL,
	DATA4 [varchar](1000) NULL
) 

INSERT INTO  @MFP
(
	AsOnDate ,
	PartyCode ,
	Exchange ,
	AngelCode ,
	AMCSchemeCode ,
	CoSchCode ,
	ISIN ,
	SchemeName ,
	SchemeCategory ,
	TotalQty ,
	AngelQty ,
	RedeemableQty ,
	AvgPrice ,
	LastNAVPrice ,
	PrevNAV ,
	LastUpdateTime ,
	DATA1 ,
	MapID ,
	ProductID ,
	DATA4 
)
EXEC [172.31.16.85].ABR_DW.dbo.usp_ui_get_mf_holding @clientcode,'','',0,0

SELECT * FROM @MFP 

--DROP TABLE #MFP



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetMutualFundPortfolio_20_No_2021
-- --------------------------------------------------
  
/*  
  
exec usp_GetMutualFundPortfolio 'rp61'  
  
*/  
  
CREATE PROC [dbo].[usp_GetMutualFundPortfolio_20_No_2021]    
(    
@clientcode VARCHAR(50)    
)    
AS    
BEGIN   
--SET FMTONLY OFF   
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
VALUES ('usp_GetMutualFundPortfolio', getdate())  
  
  
DECLARE @MFP AS TABLE   
(  
 AsOnDate [varchar](100) NULL,  
 PartyCode [varchar](100) NULL,  
 Exchange [varchar](100) NULL,  
 AngelCode [varchar](100) NULL,  
 AMCSchemeCode [varchar](10) NULL,  
 CoSchCode [varchar](100) NULL,  
 ISIN [varchar](100) NULL,  
 SchemeName [varchar](4000) NULL,  
 SchemeCategory [varchar](1000) NULL,  
 TotalQty [varchar](100) NULL,  
 AngelQty [varchar](100) NULL,  
 RedeemableQty [varchar](100) NULL,  
 AvgPrice [varchar](100) NULL,  
 LastNAVPrice [varchar](100) NULL,  
 PrevNAV [varchar](100) NULL,  
 LastUpdateTime [varchar](100) NULL,  
 DATA1 [varchar](100) NULL,  
 MapID [varchar](100) NULL,  
 ProductID [varchar](100) NULL,  
 DATA4 [varchar](1000) NULL  
)   
  
INSERT INTO  @MFP  
(  
 AsOnDate ,  
 PartyCode ,  
 Exchange ,  
 AngelCode ,  
 AMCSchemeCode ,  
 CoSchCode ,  
 ISIN ,  
 SchemeName ,  
 SchemeCategory ,  
 TotalQty ,  
 AngelQty ,  
 RedeemableQty ,  
 AvgPrice ,  
 LastNAVPrice ,  
 PrevNAV ,  
 LastUpdateTime ,  
 DATA1 ,  
 MapID ,  
 ProductID ,  
 DATA4   
)  
EXEC [172.31.16.85].ABR_DW.dbo.usp_ui_get_mf_holding @clientcode,'','',0,0  
  
SELECT * FROM @MFP   
  
--DROP TABLE #MFP  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetNSEAlertCount
-- --------------------------------------------------

/*
	exec usp_GetNSEAlertCount 'R87276'
*/

CREATE PROC [dbo].[usp_GetNSEAlertCount]
(
	@ClientID varchar(20)
)
AS
BEGIN

DECLARE @CountClient INT
DECLARE @CountClientGrp INT
DECLARE @CountOrder INT
DECLARE @CountSelf INT
DECLARE @CountSignificant INT
DECLARE @CountSudden INT


SELECT  @CountClient  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Client Group of Client'

SELECT  @CountClientGrp  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Client s Group of Client'


SELECT  @CountOrder  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Order book spoofing'

SELECT  @CountSelf  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Self Trade'

SELECT  @CountSignificant  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Significant  increase'


SELECT  @CountSudden  =  COUNT(0)
FROM 
	[dbo].[tbl_NSEAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND NSEType =  'Sudden trading activity'

	
SELECT  
	@CountClient AS CountClient 
	,@CountClientGrp AS CountClientGrp
	,@CountOrder AS CountOrder 
	,@CountSelf AS CountSelf
	,@CountSignificant AS CountSignificant  
	,@CountSudden AS CountSudden  


END 

/*

SELECT  distinct   CDSLType
FROM 
	[dbo].[tbl_CDSLAlert] 

*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetSIPOrderDetails
-- --------------------------------------------------
--exec [usp_GetSIPOrderDetails] '','','','C'    
CREATE PROCEDURE [dbo].[usp_GetSIPOrderDetails]
(      
@clientcode varchar(20)=null,      
@fromdate VARCHAR(50) = null,      
@todate VARCHAR(50) = null,      
@orderstatus varchar(50)= NULL      
)     
WITH RECOMPILE      
AS      
BEGIN      
BEGIN TRY     
SET FMTONLY OFF       
      
      
 IF(NULLIF(@fromdate,'') IS null)      
 BEGIN      
 SET @fromdate = '01-01-2015'      
 END      
 IF(NULLIF(@todate,'') IS null)      
 BEGIN      
 SET @todate = replace(convert(varchar,convert(date,GETDATE(),103),103),'/','-')      
 END       
 IF(NULLIF(@orderstatus,'') IS null)      
 BEGIN      
 SET @orderstatus = '%'      
 END       
 IF(NULLIF(@clientcode,'') IS NULL)        
 BEGIN        
  SET @clientcode= '%'             
 END        
         
 SELECT distinct sClientcode        
 INTO #riskClients        
 FROM [196.1.115.253].mutualfund.dbo.tblSipOrderDetails a WITH(NOLOCK)        
 JOIN risk.dbo.client_details b WITH(NOLOCK)        
 ON a.sClientCode = b.party_code        
 WHERE         
   a.sClientCode LIKE @clientcode /*condition added for optimization 18 Jan 2017*/        
        
         
 select distinct a.sclientcode         
 INTO #angelfoClients        
 from [196.1.115.253].mutualfund.dbo.tblSipOrderDetails a WITH(NOLOCK)         
 JOIN ANGELFO.bsemfss.dbo.MFSS_CLIENT b WITH(NOLOCK)  ON a.sclientcode = b.party_code         
  AND a.sClientCode LIKE @clientcode  /*condition added for optimization 18 Jan 2017*/        
 LEFT JOIN #riskClients c on a.sclientcode = c.sClientcode        
 WHERE        
  c.sClientcode IS NULL        
         
 select sClientcode        
 INTO #actualClients         
 FROM #riskClients        
 UNION        
 SELECT sClientcode        
 FROM #angelfoClients         
      
  BEGIN    
      
  BEGIN        
      
 SELECT  sAmcCode,a.sSchemeCode,c.schemename,a.sClientCode,a.sMandateRefNo,sUserRefNo,b.sBankName, b.sAccountNo, sTransMode,sDpTxnMode,CONVERT(VARCHAR(19),a.dStartDate, 120) as dStartDate,      
 CONVERT(VARCHAR(19),ISNULL(a.dRegistrationDate,''), 120) as dRegistrationDate, CONVERT(VARCHAR(19),ISNULL(a.dExportedOn,''),120) AS dExportedOn, sFrequencyType,nFrequencyAllowed,nInstallmentAmount,bstatus,      
 case when sOrderStatus = 'p' then 'Pending'      
   when sOrderStatus = 'c' then 'Cancelled'      
   when sOrderStatus = 'e' then 'Executed'      
   when sOrderStatus = 'ip' then 'In Process'      
   when sOrderStatus IN ('d','R') then 'Rejected'      
   when sOrderStatus = 't' then 'Send to RTA'      
   when sOrderStatus = 's' then 'Success'      
   when sOrderStatus = 'cp'  then 'Cancellation InProcess'      
  when sOrderStatus = 'ci'  then 'Cancellation Initiated'       
   END as sOrderStatus,      
 CASE WHEN NULLIF(dEndDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),dEndDate, 120) ELSE '' END as endate,      
 CASE WHEN NULLIF(sPrevPaidDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),CONVERT(DATETIME,sPrevPaidDate),120) ELSE '' END AS previoussipdate,      
 CASE WHEN NULLIF(sDueDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),CONVERT(DATETIME,sDueDate),120) ELSE '' END AS nextsipdate,ISNULL(a.sSipRegnNo,'') as sipregistrationno,      
 CONVERT(INT,ISNULL(NULLIF(sNoOfInstallPaid,''),0)) as totalnoofsippaid, CONVERT(DECIMAL(15,3),ISNULL(NULLIF(sTotalAmtPaid,''),0)) as totalamountpaid,      
 CASE WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'P' THEN 'Pending'        
 WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'S' THEN 'Success'       
 WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'C' THEN 'Cancelled' ELSE 'Pending' END AS sipregnstatus,      
 sMemberCode,sFolioNo,sDpId,sSipRemarks,nInstallmentNo,sFirstOrderToday,sSbTag,sEuinNumber,sEuinDeclaration,sDPCFlag,sSbArnCode,      
 IpAddress,a.sUserType,dInsertedOn,sInsertedBy,dUpdatedOn,sUpdatedBy,sTransactionStatus,'SIP' as sOrderType       
 FROM [196.1.115.253].mutualfund.dbo.tblSipOrderDetails a      
 JOIN #actualClients z on a.sClientCode = z.sClientCode        
 LEFT JOIN (SELECT DISTINCT sBankCode,sClientCode,sMandateRefNo, sAccountNo, sBankName FROM [196.1.115.253].mutualfund.dbo.tblSipMandateDetails WITH (NOLOCK)  
  WHERE NULLIF(sMandateRefno,'') IS NOT NULL) b      
 ON a.sMandateRefNo = b.sMandateRefNo      
 LEFT JOIN (select distinct schemecode,schemename from  [196.1.115.132].risk.dbo.sip_scheme WITH(NOLOCK)) c      
 ON a.sSchemecode = c.schemecode      
 LEFT JOIN (SELECT sSipRegnNo,sDueDate,sPrevPaidDate,sNoOfInstallPaid,sTotalAmtPaid  FROM [196.1.115.253].mutualfund.dbo.tblSipInstallmentDueMaster WITH (NOLOCK))d      
 ON a.sSipRegnNo = d.sSipRegnNo      
 WHERE a.sclientcode LIKE @clientcode       
 AND sOrderStatus LIKE @orderstatus   
 AND CONVERT(DATE,dInsertedOn) >= CONVERT(DATE,@fromdate,103)      
 AND CONVERT(DATE,dInsertedOn) <= CONVERT(DATE,@todate,103)      
 ORDER BY dInsertedOn DESC    
  END    
      
 END      
       
END TRY      
BEGIN CATCH      
select error_message()      
END CATCH      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetSIPOrderDetails_20_Nov_2021
-- --------------------------------------------------
--exec [usp_GetSIPOrderDetails] '','','','C'    
CREATE PROCEDURE [dbo].[usp_GetSIPOrderDetails_20_Nov_2021]
(      
@clientcode varchar(20)=null,      
@fromdate VARCHAR(50) = null,      
@todate VARCHAR(50) = null,      
@orderstatus varchar(50)= NULL      
)     
WITH RECOMPILE      
AS      
BEGIN      
BEGIN TRY     
SET FMTONLY OFF       
      
      
 IF(NULLIF(@fromdate,'') IS null)      
 BEGIN      
 SET @fromdate = '01-01-2015'      
 END      
 IF(NULLIF(@todate,'') IS null)      
 BEGIN      
 SET @todate = replace(convert(varchar,convert(date,GETDATE(),103),103),'/','-')      
 END       
 IF(NULLIF(@orderstatus,'') IS null)      
 BEGIN      
 SET @orderstatus = '%'      
 END       
 IF(NULLIF(@clientcode,'') IS NULL)        
 BEGIN        
  SET @clientcode= '%'             
 END        
         
 SELECT distinct sClientcode        
 INTO #riskClients        
 FROM [196.1.115.132].mutualfund.dbo.tblSipOrderDetails a WITH(NOLOCK)        
 JOIN risk.dbo.client_details b WITH(NOLOCK)        
 ON a.sClientCode = b.party_code        
 WHERE         
   a.sClientCode LIKE @clientcode /*condition added for optimization 18 Jan 2017*/        
        
         
 select distinct a.sclientcode         
 INTO #angelfoClients        
 from [196.1.115.132].mutualfund.dbo.tblSipOrderDetails a WITH(NOLOCK)         
 JOIN ANGELFO.bsemfss.dbo.MFSS_CLIENT b WITH(NOLOCK)  ON a.sclientcode = b.party_code         
  AND a.sClientCode LIKE @clientcode  /*condition added for optimization 18 Jan 2017*/        
 LEFT JOIN #riskClients c on a.sclientcode = c.sClientcode        
 WHERE        
  c.sClientcode IS NULL        
         
 select sClientcode        
 INTO #actualClients         
 FROM #riskClients        
 UNION        
 SELECT sClientcode        
 FROM #angelfoClients         
      
  BEGIN    
      
  BEGIN        
      
 SELECT  sAmcCode,a.sSchemeCode,c.schemename,a.sClientCode,a.sMandateRefNo,sUserRefNo,b.sBankName, b.sAccountNo, sTransMode,sDpTxnMode,CONVERT(VARCHAR(19),a.dStartDate, 120) as dStartDate,      
 CONVERT(VARCHAR(19),ISNULL(a.dRegistrationDate,''), 120) as dRegistrationDate, CONVERT(VARCHAR(19),ISNULL(a.dExportedOn,''),120) AS dExportedOn, sFrequencyType,nFrequencyAllowed,nInstallmentAmount,bstatus,      
 case when sOrderStatus = 'p' then 'Pending'      
   when sOrderStatus = 'c' then 'Cancelled'      
   when sOrderStatus = 'e' then 'Executed'      
   when sOrderStatus = 'ip' then 'In Process'      
   when sOrderStatus IN ('d','R') then 'Rejected'      
   when sOrderStatus = 't' then 'Send to RTA'      
   when sOrderStatus = 's' then 'Success'      
   when sOrderStatus = 'cp'  then 'Cancellation InProcess'      
  when sOrderStatus = 'ci'  then 'Cancellation Initiated'       
   END as sOrderStatus,      
 CASE WHEN NULLIF(dEndDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),dEndDate, 120) ELSE '' END as endate,      
 CASE WHEN NULLIF(sPrevPaidDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),CONVERT(DATETIME,sPrevPaidDate),120) ELSE '' END AS previoussipdate,      
 CASE WHEN NULLIF(sDueDate,'') IS NOT NULL THEN CONVERT(VARCHAR(19),CONVERT(DATETIME,sDueDate),120) ELSE '' END AS nextsipdate,ISNULL(a.sSipRegnNo,'') as sipregistrationno,      
 CONVERT(INT,ISNULL(NULLIF(sNoOfInstallPaid,''),0)) as totalnoofsippaid, CONVERT(DECIMAL(15,3),ISNULL(NULLIF(sTotalAmtPaid,''),0)) as totalamountpaid,      
 CASE WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'P' THEN 'Pending'        
 WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'S' THEN 'Success'       
 WHEN ISNULL(NULLIF(a.sSipRegistrationStatus,''),'')  = 'C' THEN 'Cancelled' ELSE 'Pending' END AS sipregnstatus,      
 sMemberCode,sFolioNo,sDpId,sSipRemarks,nInstallmentNo,sFirstOrderToday,sSbTag,sEuinNumber,sEuinDeclaration,sDPCFlag,sSbArnCode,      
 IpAddress,a.sUserType,dInsertedOn,sInsertedBy,dUpdatedOn,sUpdatedBy,sTransactionStatus,'SIP' as sOrderType       
 FROM [196.1.115.132].mutualfund.dbo.tblSipOrderDetails a      
 JOIN #actualClients z on a.sClientCode = z.sClientCode        
 LEFT JOIN (SELECT DISTINCT sBankCode,sClientCode,sMandateRefNo, sAccountNo, sBankName FROM [196.1.115.132].mutualfund.dbo.tblSipMandateDetails WITH (NOLOCK)  
  WHERE NULLIF(sMandateRefno,'') IS NOT NULL) b      
 ON a.sMandateRefNo = b.sMandateRefNo      
 LEFT JOIN (select distinct schemecode,schemename from  [196.1.115.132].risk.dbo.sip_scheme WITH(NOLOCK)) c      
 ON a.sSchemecode = c.schemecode      
 LEFT JOIN (SELECT sSipRegnNo,sDueDate,sPrevPaidDate,sNoOfInstallPaid,sTotalAmtPaid  FROM [196.1.115.132].mutualfund.dbo.tblSipInstallmentDueMaster WITH (NOLOCK))d      
 ON a.sSipRegnNo = d.sSipRegnNo      
 WHERE a.sclientcode LIKE @clientcode       
 AND sOrderStatus LIKE @orderstatus   
 AND CONVERT(DATE,dInsertedOn) >= CONVERT(DATE,@fromdate,103)      
 AND CONVERT(DATE,dInsertedOn) <= CONVERT(DATE,@todate,103)      
 ORDER BY dInsertedOn DESC    
  END    
      
 END      
       
END TRY      
BEGIN CATCH      
select error_message()      
END CATCH      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetTSSAlertCount
-- --------------------------------------------------

/*

	exec usp_GetTSSAlertCount 'R87276'
	
*/



CREATE PROC [dbo].[usp_GetTSSAlertCount]
(
	@ClientID varchar(20)
)
AS
BEGIN

DECLARE @CountIn INT
DECLARE @CountOut INT

SELECT  @CountIn  =  COUNT(0)
FROM 
	[dbo].[tbl_TSSAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND TSStype =  'TSS Money flow In'


SELECT  @CountOut  =  COUNT(0)
FROM 
	[dbo].[tbl_TSSAlert] 
WHERE 
	RecordStatus = 'A' 
	AND ClientID  = @ClientID 
	AND TSStype =  'TSS Money flow Out'

	
	
--SELECT  @CountIn AS [MoneyFlowInCount]
--SELECT  @CountOut AS [MoneyFlowOutCount]


SELECT  @CountIn AS [MoneyFlowInCount],  @CountOut AS [MoneyFlowOutCount]


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetXSIPOrderDetails
-- --------------------------------------------------
  
  
  
CREATE PROCEDURE [dbo].[usp_GetXSIPOrderDetails]
(  
@clientcode varchar(20)= null,  
@fromdate VARCHAR(50) = null,  
@todate VARCHAR(50) = null,  
@orderstatus varchar(50)= NULL  
  
) WITH RECOMPILE  
AS  
BEGIN  
BEGIN TRY  
SET FMTONLY OFF  
 IF(NULLIF(@fromdate,'') IS null)  
 BEGIN  
 SET @fromdate = '01-01-2015'  
 END  
 IF(NULLIF(@todate,'') IS null)  
 BEGIN  
 SET @todate = replace(convert(varchar,convert(date,GETDATE(),103),103),'/','-')  
 END   
 IF(NULLIF(@orderstatus,'') IS null)  
 BEGIN  
 SET @orderstatus = '%'  
 END   
   
 IF(NULLIF(@clientcode,'') IS null)  
 BEGIN  
 SET @clientcode = '%'  
 END   
   
 select distinct scheme_name, scheme_code, scheme_type     
 INTO #schemedetails    
 from [196.1.115.253].mutualfund.dbo.vw_etl_mfschememaster with(nolock)    
   
 SELECT [SIP Regn Number]  as sSipRegnNo,[Due Date] as sDueDate,[Prev Paid date] as sPrevPaidDate,  
 [Total Installments Paid] as sNoOfInstallPaid,[Total Installment Amt Paid] as sTotalAmtPaid    
 INTO #installmentdue  
 FROM [196.1.115.132].risk.dbo.tbl_sip_installment_due_data with(nolock)  
   
 SELECT DISTINCT XSIPRegnNO,CONVERT(VARCHAR,convert(date,EndDate),106) as EndDate  
 INTO #sipRegnHistory  
 FROM [196.1.115.253].mutualfund.dbo.tblXsipRegistrationMasterHistory with(nolock)  
   
   
 BEGIN  
    
  BEGIN  
     
   SELECT cl_code as party_code, long_name as  party_name, sub_broker      
   INTO #mfssclient    
   FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK)    
     
   SELECT  ROW_NUMBER() OVER(ORDER BY a.dInsertedOn desc) as srno, sUserRefNo,  
   dbo.initcap(ISNULL(a.sClientCode,'')) as sClientCode,dbo.initcap(c.scheme_name) as scheme_name, ISNULL(nInstallmentAmount,0) as nInstallmentAmount ,  
   case when sOrderStatus = 'p' then 'Pending'  
   when sOrderStatus = 'c' then 'Cancelled'  
   when sOrderStatus = 'e' then 'Executed'  
   when sOrderStatus = 'ip' then 'In Process'  
   when sOrderStatus = 'd' then 'Rejected'  
   when sOrderStatus = 't' then 'Send to RTA'  
   when sOrderStatus  = 's' then 'Success'  
   when sOrderStatus = 'ci' then 'Cancellation Initiated'  
   when sOrderStatus = 'cp' then 'Cancellation In Process'  
   END as sOrderStatus, b.smandateid, dbo.initcap(b.smandatestatus) as smandatestatus, CONVERT(VARCHAR,a.dStartDate, 106) as dStartDate,  
   CASE WHEN NULLIF(e.enddate,'') IS NOT NULL THEN CONVERT(VARCHAR,e.enddate, 106) ELSE '' END as endate,dbo.initcap(sFrequencyType) as sFrequencyType,  
   REPLACE(CONVERT(VARCHAR,ISNULL(a.dExportedOn,''),106),'01 Jan 1900','') AS dExportedOn,  
   REPLACE(CONVERT(VARCHAR,ISNULL(a.dRegistrationDate,''), 106),'01 Jan 1900','') as dRegistrationDate, ISNULL(a.sXSipRegnNo,'') as sipregistrationno,  dbo.initcap(b.sBankName) as sBankName, b.sAccountNo,  
   CASE WHEN NULLIF(sPrevPaidDate,'') IS NOT NULL THEN CONVERT(VARCHAR,CONVERT(DATE,sPrevPaidDate),106) ELSE '' END AS previoussipdate,  
   CASE WHEN NULLIF(sDueDate,'') IS NOT NULL THEN CONVERT(VARCHAR,CONVERT(DATE,sDueDate),106) ELSE '' END AS nextsipdate,  
   CONVERT(INT,ISNULL(NULLIF(sNoOfInstallPaid,''),0)) as totalnoofsippaid, CONVERT(DECIMAL(15,3),ISNULL(NULLIF(sTotalAmtPaid,''),0)) as totalamountpaid,  
   CASE WHEN NULLIF(a.sXSipRegnNo,'') IS NULL THEN 'Pending' ELSE 'Success' END AS sipregnstatus,  
   sMemberCode,sFolioNo,sDpId, case when sorderstatus  in ('D', 'R') THEN sSipRemarks ELSE '' END as sSipRemarks,nInstallmentNo,CASE WHEN sFirstOrderToday = 'Y' THEN 'Yes' ELSE 'No' END as sFirstOrderToday,  
   sSbTag,sEuinNumber,sEuinDeclaration,sSbArnCode,a.dInsertedOn,sUserName as sInsertedBy,sUserType  
   FROM [196.1.115.253].mutualfund.dbo.tblXSipOrderDetails  a with(nolock)  
   LEFT JOIN #mfssclient g on a.sclientcode = g.party_code  
   LEFT JOIN [196.1.115.253].mutualfund.dbo.tblxsipmandatedetails  b with(nolock) on a.smandateid = b.smandateid AND a.sClientCode = b.sClientCode  
   LEFT JOIN #schemedetails c ON a.sSchemecode = c.scheme_code  
   LEFT JOIN #installmentdue d ON a.sXSipRegnNo = d.sSipRegnNo  
   LEFT JOIN #sipRegnHistory  e ON a.sXSipRegnNo  = e.XSIPRegnNO  
   WHERE a.sclientcode LIKE @clientcode   
   AND sOrderStatus LIKE @orderstatus   
   AND CONVERT(DATE,a.dInsertedOn) >= CONVERT(DATE,@fromdate,103)  
   AND CONVERT(DATE,a.dInsertedOn) <= CONVERT(DATE,@todate,103)  
     
   ORDER BY a.dInsertedOn DESC  
  END  
    
 END  
  
END TRY  
BEGIN CATCH  
select error_message()  
END CATCH  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetXSIPOrderDetails_20_Nov_2021
-- --------------------------------------------------
  
  
  
CREATE PROCEDURE [dbo].[usp_GetXSIPOrderDetails_20_Nov_2021]
(  
@clientcode varchar(20)= null,  
@fromdate VARCHAR(50) = null,  
@todate VARCHAR(50) = null,  
@orderstatus varchar(50)= NULL  
  
) WITH RECOMPILE  
AS  
BEGIN  
BEGIN TRY  
SET FMTONLY OFF  
 IF(NULLIF(@fromdate,'') IS null)  
 BEGIN  
 SET @fromdate = '01-01-2015'  
 END  
 IF(NULLIF(@todate,'') IS null)  
 BEGIN  
 SET @todate = replace(convert(varchar,convert(date,GETDATE(),103),103),'/','-')  
 END   
 IF(NULLIF(@orderstatus,'') IS null)  
 BEGIN  
 SET @orderstatus = '%'  
 END   
   
 IF(NULLIF(@clientcode,'') IS null)  
 BEGIN  
 SET @clientcode = '%'  
 END   
   
 select distinct scheme_name, scheme_code, scheme_type     
 INTO #schemedetails    
 from [196.1.115.132].mutualfund.dbo.vw_etl_mfschememaster with(nolock)    
   
 SELECT [SIP Regn Number]  as sSipRegnNo,[Due Date] as sDueDate,[Prev Paid date] as sPrevPaidDate,  
 [Total Installments Paid] as sNoOfInstallPaid,[Total Installment Amt Paid] as sTotalAmtPaid    
 INTO #installmentdue  
 FROM [196.1.115.132].risk.dbo.tbl_sip_installment_due_data with(nolock)  
   
 SELECT DISTINCT XSIPRegnNO,CONVERT(VARCHAR,convert(date,EndDate),106) as EndDate  
 INTO #sipRegnHistory  
 FROM [196.1.115.132].mutualfund.dbo.tblXsipRegistrationMasterHistory with(nolock)  
   
   
 BEGIN  
    
  BEGIN  
     
   SELECT cl_code as party_code, long_name as  party_name, sub_broker      
   INTO #mfssclient    
   FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK)    
     
   SELECT  ROW_NUMBER() OVER(ORDER BY a.dInsertedOn desc) as srno, sUserRefNo,  
   dbo.initcap(ISNULL(a.sClientCode,'')) as sClientCode,dbo.initcap(c.scheme_name) as scheme_name, ISNULL(nInstallmentAmount,0) as nInstallmentAmount ,  
   case when sOrderStatus = 'p' then 'Pending'  
   when sOrderStatus = 'c' then 'Cancelled'  
   when sOrderStatus = 'e' then 'Executed'  
   when sOrderStatus = 'ip' then 'In Process'  
   when sOrderStatus = 'd' then 'Rejected'  
   when sOrderStatus = 't' then 'Send to RTA'  
   when sOrderStatus  = 's' then 'Success'  
   when sOrderStatus = 'ci' then 'Cancellation Initiated'  
   when sOrderStatus = 'cp' then 'Cancellation In Process'  
   END as sOrderStatus, b.smandateid, dbo.initcap(b.smandatestatus) as smandatestatus, CONVERT(VARCHAR,a.dStartDate, 106) as dStartDate,  
   CASE WHEN NULLIF(e.enddate,'') IS NOT NULL THEN CONVERT(VARCHAR,e.enddate, 106) ELSE '' END as endate,dbo.initcap(sFrequencyType) as sFrequencyType,  
   REPLACE(CONVERT(VARCHAR,ISNULL(a.dExportedOn,''),106),'01 Jan 1900','') AS dExportedOn,  
   REPLACE(CONVERT(VARCHAR,ISNULL(a.dRegistrationDate,''), 106),'01 Jan 1900','') as dRegistrationDate, ISNULL(a.sXSipRegnNo,'') as sipregistrationno,  dbo.initcap(b.sBankName) as sBankName, b.sAccountNo,  
   CASE WHEN NULLIF(sPrevPaidDate,'') IS NOT NULL THEN CONVERT(VARCHAR,CONVERT(DATE,sPrevPaidDate),106) ELSE '' END AS previoussipdate,  
   CASE WHEN NULLIF(sDueDate,'') IS NOT NULL THEN CONVERT(VARCHAR,CONVERT(DATE,sDueDate),106) ELSE '' END AS nextsipdate,  
   CONVERT(INT,ISNULL(NULLIF(sNoOfInstallPaid,''),0)) as totalnoofsippaid, CONVERT(DECIMAL(15,3),ISNULL(NULLIF(sTotalAmtPaid,''),0)) as totalamountpaid,  
   CASE WHEN NULLIF(a.sXSipRegnNo,'') IS NULL THEN 'Pending' ELSE 'Success' END AS sipregnstatus,  
   sMemberCode,sFolioNo,sDpId, case when sorderstatus  in ('D', 'R') THEN sSipRemarks ELSE '' END as sSipRemarks,nInstallmentNo,CASE WHEN sFirstOrderToday = 'Y' THEN 'Yes' ELSE 'No' END as sFirstOrderToday,  
   sSbTag,sEuinNumber,sEuinDeclaration,sSbArnCode,a.dInsertedOn,sUserName as sInsertedBy,sUserType  
   FROM [196.1.115.132].mutualfund.dbo.tblXSipOrderDetails  a with(nolock)  
   LEFT JOIN #mfssclient g on a.sclientcode = g.party_code  
   LEFT JOIN [196.1.115.132].mutualfund.dbo.tblxsipmandatedetails  b with(nolock) on a.smandateid = b.smandateid AND a.sClientCode = b.sClientCode  
   LEFT JOIN #schemedetails c ON a.sSchemecode = c.scheme_code  
   LEFT JOIN #installmentdue d ON a.sXSipRegnNo = d.sSipRegnNo  
   LEFT JOIN #sipRegnHistory  e ON a.sXSipRegnNo  = e.XSIPRegnNO  
   WHERE a.sclientcode LIKE @clientcode   
   AND sOrderStatus LIKE @orderstatus   
   AND CONVERT(DATE,a.dInsertedOn) >= CONVERT(DATE,@fromdate,103)  
   AND CONVERT(DATE,a.dInsertedOn) <= CONVERT(DATE,@todate,103)  
     
   ORDER BY a.dInsertedOn DESC  
  END  
    
 END  
  
END TRY  
BEGIN CATCH  
select error_message()  
END CATCH  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_InsertCaseAnalysis
-- --------------------------------------------------


/*

	exec [usp_InsertCaseAnalysis] 'GJ3214', 'cc', 'f', 's', 's', 'd', 't', 'o', 'suspicious', 'c', 'h', false


*/


CREATE  PROC [dbo].[usp_InsertCaseAnalysis]

(

	@ClientID varchar (40)

	--,@AlertComment varchar (MAX)

	,@BackgroundComment varchar (MAX)

	,@FinancialComment varchar (MAX)

	,@STRComment varchar (MAX)

	,@SignificantScripName varchar (MAX)

	,@SignificantComment varchar (MAX)

	,@DPComment varchar (MAX)

	,@TradingComment varchar (MAX)

	,@OtherDetail varchar (MAX)

	,@SuspiciousNon varchar (50)

	,@Conclusion varchar (MAX)

	,@Submit bit

)

AS

BEGIN 



BEGIN TRAN



	--IF EXISTS (SELECT 0 FROM tbl_CaseAnalysis WHERE ClientID = @ClientID AND CONVERT(VARCHAR,RecordAddedon, 103)  =  CONVERT(VARCHAR,GETDATE(), 103))

	--BEGIN

	--	UPDATE tbl_CaseAnalysis

	--	SET 

	--		--,@AlertComment 

	--		BackgroundComment  =  @BackgroundComment 

	--		,FinancialComment  = @FinancialComment 

	--		,STRComment  = @STRComment 

	--		,SignificantScripName  = @SignificantScripName 

	--		,SignificantComment  = @SignificantComment 

	--		,DPComment = @DPComment 

	--		,TradingComment = @TradingComment 

	--		,OtherDetail = @OtherDetail 

	--		,SuspiciousNon = @SuspiciousNon 

	--		,Conclusion  = @Conclusion 

	--	WHERE 

	--		ClientID = @ClientID 

	--		AND CONVERT(VARCHAR,RecordAddedon, 103) = CONVERT(VARCHAR,GETDATE(), 103)

	--END 

	--ELSE 

	--BEGIN

		INSERT INTO tbl_CaseAnalysis

		(

			ClientID

			--,AlertComment

			,BackgroundComment

			,FinancialComment

			,STRComment

			,SignificantScripName

			,SignificantComment

			,DPComment

			,TradingComment

			,OtherDetail

			,SuspiciousNon

			,Conclusion

			,Submit

		)

		VALUES

		(

			@ClientID 

			--,@AlertComment 

			,@BackgroundComment 

			,@FinancialComment 

			,@STRComment 

			,@SignificantScripName 

			,@SignificantComment 

			,@DPComment 

			,@TradingComment 

			,@OtherDetail 

			,@SuspiciousNon 

			,@Conclusion 

			,@Submit

		)

	--END 

SELECT @@IDENTITY


	IF @@Error <> 0 

		ROLLBACK TRAN 

	ELSE

		COMMIT TRAN 


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_InsertSTR
-- --------------------------------------------------

/*
	exec usp_InsertSTR 1, '13-02-2017', 	'Test',  'Ground',  '123'
*/
  
CREATE PROCEDURE [dbo].[usp_InsertSTR]  
(
	@ID as int,
	@Strdate  as varchar (100),   
	@CompanyName as varchar(400),  
	@GroundOfSuspicion as text,
	@insertedBy  as varchar (500)
)
AS  
  
BEGIN   

--select * from [dbo].[tbl_str_master]
  
--INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
--VALUES ('usp_InsertSTR', @Strdate)  
  
--declare  @Strdate  as varchar (100)
--set @Strdate   = '13/02/2017'
  
--SELECT @Strdate =  CONVERT(CHAR(16),CONVERT(DATETIME,LEFT(@Strdate,10),105),101)  
--SELECT @Strdate 

--INSERT INTO [tbl_str_master](  
--	ID,
--	Strdate  ,   
--	CompanyName ,  
--	GroundOfSuspicion ,
--	insertedBy     
--	--insertedOn 

--)  
--VALUES 
--(
--	1,
--	@Strdate  ,   
--	'd',  
--	'hh',
--	'qww'
--	--Getdate()
--)


SELECT @Strdate =  CONVERT(CHAR(16),CONVERT(DATETIME,LEFT(@Strdate,10),105),101)  

INSERT INTO [tbl_str_master](  
	ID,
	Strdate  ,   
	CompanyName ,  
	GroundOfSuspicion ,
	insertedBy,     
	insertedOn 

)  
VALUES 
(
	@ID,
	@Strdate  ,   
	@CompanyName ,  
	@GroundOfSuspicion ,
	@insertedBy,    
	Getdate()
)
  
  --SELECT @@IDENTITY 
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_InsertSynopsis
-- --------------------------------------------------


/*

select * from tbl_Synopsis

 */



-- exec [usp_InsertSynopsis] '1','2','3','4'



CREATE PROC [dbo].[usp_InsertSynopsis]                              

(  

@Code	nvarchar	(100)

,@Concern	nvarchar	(1000)

,@Finding		nvarchar	(1000)

,@Actionable		nvarchar	(1000)

--,@Username	varchar(400)

--,@AccessCode	varchar(400)

--,@AccessTo	varchar(400)

)                              

AS                              

BEGIN             

		INSERT INTO tbl_Synopsis 

		VALUES                               

		(                              

		@Code

		,@Concern

		,@Finding

		,@Actionable

		,Getdate()

		)  

		

		

                            



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_SubmitCaseAnalysis
-- --------------------------------------------------


CREATE PROC [dbo].[usp_SubmitCaseAnalysis]
(
	@ID int
	,@ClientID varchar (40)
	
)
AS
BEGIN 

	BEGIN TRAN

	--IF EXISTS (select 0 from tbl_CaseAnalysis WHERE ClientID = @ClientID AND CONVERT(VARCHAR,RecordAddedon, 103)  =  CONVERT(VARCHAR,GETDATE(), 103))
	--BEGIN
		UPDATE tbl_CaseAnalysis
		SET Submit = 'T'
		WHERE 
			ClientID = @ClientID 
			AND ID  = @ID
	
	IF @@Error <> 0 
		ROLLBACK TRAN 
	ELSE
		COMMIT TRAN 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateCaseAnalysis
-- --------------------------------------------------


CREATE PROC [dbo].[usp_UpdateCaseAnalysis]

(

	@ClientID varchar (40)

	,@ID int

	--,@AlertComment varchar (MAX)

	,@BackgroundComment varchar (MAX)

	,@FinancialComment varchar (MAX)

	,@STRComment varchar (MAX)

	,@SignificantScripName varchar (MAX)

	,@SignificantComment varchar (MAX)

	,@DPComment varchar (MAX)

	,@TradingComment varchar (MAX)

	,@OtherDetail varchar (MAX)

	,@SuspiciousNon varchar (50)

	,@Conclusion varchar (MAX)

)

AS

BEGIN 

	BEGIN TRAN

		UPDATE tbl_CaseAnalysis
		SET 
			--,@AlertComment 
			BackgroundComment  =  @BackgroundComment 

			,FinancialComment  = @FinancialComment 

			,STRComment  = @STRComment 

			,SignificantScripName  = @SignificantScripName 

			,SignificantComment  = @SignificantComment 

			,DPComment = @DPComment 

			,TradingComment = @TradingComment 

			,OtherDetail = @OtherDetail 

			,SuspiciousNon = @SuspiciousNon 

			,Conclusion  = @Conclusion 

		WHERE 

			ClientID = @ClientID 

			AND ID  = @ID

			--AND CONVERT(VARCHAR,RecordAddedon, 103) = CONVERT(VARCHAR,GETDATE(), 103)

	SELECT cast (@ID as int)


	IF @@Error <> 0 

		ROLLBACK TRAN 

	ELSE

		COMMIT TRAN 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateCaseAnalysisStatus
-- --------------------------------------------------


CREATE PROC [dbo].[usp_UpdateCaseAnalysisStatus]
(
	@ClientID varchar (40)

	,@ID int
)

AS

BEGIN 

	BEGIN TRAN

		UPDATE tbl_CaseAnalysis
		SET 
			Submit  = 1 
		WHERE 

			ClientID = @ClientID 

			AND ID  = @ID



	IF @@Error <> 0 

		ROLLBACK TRAN 

	ELSE

		COMMIT TRAN 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UpdateSTR
-- --------------------------------------------------

/*

	exec usp_UpdateSTR 2, '13/02/2017', 	'Test',  'Ground',  '123' ,  '13/02/2017', 'kl',	'13/02/2017'

*/
  
CREATE  PROCEDURE [dbo].[usp_UpdateSTR]  
(
	@ID as int,
	@Strdate  as varchar (100),   
	@CompanyName as varchar(400),  
	@GroundOfSuspicion as text,
	@updatedBy  as varchar (500)
	
)
AS  
  
BEGIN   

--INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)  
--VALUES ('usp_GenerateEquityReport', getdate())  
  
--declare  @Strdate  as varchar (100)
--set @Strdate   = '13/02/2017'

SELECT @Strdate =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@Strdate,10),105),101)  
--SELECT @updatedOn  =  CONVERT(CHAR(10),CONVERT(DATETIME,LEFT(@updatedOn,10),105),101)  

UPDATE tbl_str_master
SET Strdate   = @Strdate,   
	CompanyName = @CompanyName ,  
	GroundOfSuspicion  = @GroundOfSuspicion,
	updatedBy   = @updatedBy,   
	updatedOn  = Getdate() 
WHERE ID =@ID 
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadAlert
-- --------------------------------------------------
CREATE PROC [dbo].[usp_UploadAlert]  
(  
@FileName varchar(100)  
,@SheetName varchar(100) = ''  
)  
AS  
  
BEGIN   
  
 DECLARE @Flag varchar(20)  
  
 BEGIN TRAN   
   
 -- SELECT * from [dbo].[tbl_PMLAUserLog]  
 -- Truncate table tbl_PMLAUserLog  
 INSERT INTO tbl_PMLAUserLog (SPName,param1)  
 VALUES('usp_UploadAlert', @FileName)  
  
 /*  
  delete from tbl_TSSAlert_Temp where id > 20  
  select * from tbl_TSSAlert_Temp where id > 20  
  select * from tbl_TSSAlert where RecordStatus   = 'd'  
  select * from tbl_TSSAlert where RecordStatus   = 'A'  
 */  
  
 SET @Flag  = 'Success'  
  
  
 IF (@FileName ='BSE' )  
 BEGIN   
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_BSEAlert  A Inner Join tbl_BSEAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.AlertDate =  B.AlertDate  
    
  INSERT INTO [tbl_BSEAlert]  
     (  
     ClientID  
     ,ClientName  
     ,AlertType  
     ,AlertDate  
     ,AlertFrequencyType  
     ,InstrumentCode  
     ,TradeDate  
     ,AlertGroup  
     ,[Type]  
     ,Scrip  
     ,[Message]  
     ,GroupAlertNo  
     ,OtherClients  
     ,RefNo  
     ,ExchangeStatus  
     ,Part  
     ,TotalSelfQty  
     ,TotalBuyQty  
     ,TotalSellQty  
     ,TotalSPoofQty  
     ,Profit  
     ,DeadLine  
     ,PAN  
     ,EmailSendDate  
     ,ScripQty  
     ,Top5ClientBuy  
     ,Top5ClientSell  
     ,TradeDateString  
     ,CurrentPeriod  
     ,InstrumentName  
     ,CaseId  
     ,ClientExplanation  
     ,EmailSent  
     ,ExchangeInformed  
     ,ClosedDate  
     ,RegisterCaseID  
     ,Segment  
     ,Age  
     ,CustomRisk  
     ,LastestIncome  
     ,Email  
     ,Mobile  
     ,IntermediatoryCode  
     ,IntermediatoryName  
     ,TradeName  
     ,RiskCategory  
     ,CSC  
     ,Gender  
     ,AddedBy  
     ,AddedOn  
     ,LastEditedBy  
     ,EditedOn  
     ,Comment  
     ,[Status]  
     )  
  
    SELECT   
      ClientID  
      ,ClientName  
      ,AlertType  
      ,AlertDate  
      ,AlertFrequencyType  
      ,InstrumentCode  
      ,TradeDate  
      ,AlertGroup  
      ,[Type]  
      ,Scrip  
      ,[Message]  
      --,GroupAlertNo  
      ,CAST((CASE WHEN ISNULL(GroupAlertNo,'') = '' THEN '0' ELSE GroupAlertNo END) AS DECIMAL(18,0))  
      ,OtherClients  
      ,RefNo  
      ,ExchangeStatus  
      ,Part  
      --,TotalSelfQty  
      --,TotalBuyQty  
      --,TotalSellQty  
      --,TotalSPoofQty  
      ,CAST((CASE WHEN ISNULL(TotalSelfQty,'') = '' THEN '0' ELSE TotalSelfQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalBuyQty,'') = '' THEN '0' ELSE TotalBuyQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalSellQty,'') = '' THEN '0' ELSE TotalSellQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalSPoofQty,'') = '' THEN '0' ELSE TotalSPoofQty END) AS DECIMAL(18,0))  
      ,Profit  
      ,DeadLine  
      ,PAN  
      ,EmailSendDate  
      --,ScripQty  
      ,CAST((CASE WHEN ISNULL(ScripQty,'') = '' THEN '0' ELSE ScripQty END) AS DECIMAL(18,0))  
      ,Top5ClientBuy  
      ,Top5ClientSell  
      ,TradeDateString  
      ,CurrentPeriod  
      ,InstrumentName  
      ,CaseId  
      ,ClientExplanation  
      ,EmailSent  
      ,ExchangeInformed  
      ,ClosedDate  
      ,RegisterCaseID  
      ,Segment  
      ,Age  
      ,CustomRisk  
      ,LastestIncome  
      ,Email  
      ,Mobile  
      ,IntermediatoryCode  
      ,IntermediatoryName  
      ,TradeName  
      ,RiskCategory  
      ,CSC  
      ,Gender  
      ,AddedBy  
      ,AddedOn  
      ,LastEditedBy  
      ,EditedOn  
      ,Comment  
      ,[Status]  
    FROM [dbo].[tbl_BSEAlert_Temp]    
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
   
 ELSE IF (@FileName ='TSS' )  
 BEGIN   
  UPDATE A   
   SET A.RecordStatus   = 'D'  
   FROM  tbl_TSSAlert  A Inner Join tbl_TSSAlert_Temp B  
   ON A.ClientID  =  B.ClientID   
   AND A.MinTransDate =  B.MinTransDate  
   AND A.MaxTransDate =  B.MaxTransDate  
   AND A.TSStype = B.TSStype  
  
  INSERT INTO tbl_TSSAlert  
   (  
   ClientID  
   ,ClientName  
   ,Networth  
   ,Income  
   ,Strength  
   ,MoneyInOut  
   ,ViolationAmt  
   ,MinTransDate  
   ,MaxTransDate  
   ,NetworthDesc  
   ,IncomeDesc  
   ,MinTransDateString  
   ,MaxTransDateString  
   ,RunDateString  
   ,IsNBFClient  
   ,SanctionLimit  
   ,CaseID  
   ,ClientExplanation  
   ,EmailSent  
   ,ExchangeInformed  
   ,ClosedDate  
   ,RegisterCaseID  
   ,Segment  
   ,Age  
   ,CustomRisk  
   ,LastestIncome  
   ,Email  
   ,Mobile  
   ,IntermediatoryCode  
   ,IntermediatoryName  
   ,TradeName  
   ,RiskCategory  
   ,CSC  
   ,Gender  
   ,RuleID  
   ,AddedBy  
   ,AddedOn  
   ,LastEditedBy  
   ,EditedOn  
   ,Comment  
   ,[Status]  
   ,TSStype  
   )  
  
   SELECT   
     ClientID  
     ,ClientName  
     --,Networth  
     --,Income  
     --,Strength  
     ,CAST((CASE WHEN ISNULL(Networth ,'') = '' THEN '0' ELSE Networth  END) AS DECIMAL(18,2))  
     ,CAST((CASE WHEN ISNULL(Income ,'') = '' THEN '0' ELSE Income  END) AS DECIMAL(18,2))  
     ,CAST((CASE WHEN ISNULL(Strength ,'') = '' THEN '0' ELSE Strength  END) AS DECIMAL(18,2))  
     ,MoneyInOut  
     --,ViolationAmt   
     ,CAST((CASE WHEN ISNULL(ViolationAmt ,'') = '' THEN '0' ELSE ViolationAmt  END) AS DECIMAL(18,2))  
     ,MinTransDate  
     ,MaxTransDate  
     ,NetworthDesc  
     ,IncomeDesc  
     ,MinTransDateString  
     ,MaxTransDateString  
     ,RunDateString  
     ,IsNBFClient  
     ,SanctionLimit  
     ,CaseID  
     ,ClientExplanation  
     ,EmailSent  
     ,ExchangeInformed  
     ,ClosedDate  
     ,RegisterCaseID  
     ,Segment  
     ,Age  
     ,CustomRisk  
     ,LastestIncome  
     ,Email  
     ,Mobile  
     ,IntermediatoryCode  
     ,IntermediatoryName  
     ,TradeName  
     ,RiskCategory  
     ,CSC  
     ,Gender  
     ,RuleID  
     ,AddedBy  
     ,AddedOn  
     ,LastEditedBy  
     ,EditedOn  
     ,Comment  
     ,[Status]  
     ,TSStype  
   FROM [dbo].[tbl_TSSAlert_Temp]     
     
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
 ELSE IF (@FileName ='DP' )  
 BEGIN   
    
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_CDSLAlert  A Inner Join tbl_CDSLAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.TransDate =  B.TransDate  
  AND A.CDSLType = B.CDSLType  
  
  INSERT INTO tbl_CDSLAlert  
 (  
  ClientID  
  ,ClientName  
  ,Batch  
  ,TransactionType  
  ,PAN  
  ,Scrip  
  ,ISIN  
  ,ISINDescription  
  ,TransDate  
  ,CreditDebit  
  ,TransQty  
  ,TransDescription  
  ,RefNo  
  ,MarketRateISIN  
  ,TransactionValue  
  ,OppClientDPID  
  ,OppClientID  
  ,OppClientName  
  ,ReasonCode  
  ,Segment  
  ,TarFileName  
  ,TransDateString  
  ,CaseId  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,RegisterCaseID  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,IntermediatoryName  
  ,TradeName  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,Consideration  
  ,Reason  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,CDSLType  
 )  
  
 SELECT   
  ClientID  
  ,ClientName  
  ,Batch  
  ,TransactionType  
  ,PAN  
  ,Scrip  
  ,ISIN  
  ,ISINDescription  
  ,TransDate  
  ,CreditDebit  
  --,TransQty     
  ,CAST((CASE WHEN ISNULL(TransQty,'') = '' THEN '0' ELSE TransQty END) AS DECIMAL(18,0))  
  ,TransDescription  
  ,RefNo  
  --,MarketRateISIN  
  ,CAST((CASE WHEN ISNULL(MarketRateISIN,'') = '' THEN '0' ELSE MarketRateISIN END) AS DECIMAL(18,0))  
  ,TransactionValue  
  ,OppClientDPID   
  ,OppClientID  
  ,OppClientName  
  ,ReasonCode  
  ,Segment  
  ,TarFileName  
  ,TransDateString  
  ,CaseId  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,RegisterCaseID  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,IntermediatoryName  
  ,TradeName  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,Consideration  
  ,Reason  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,CDSLType  
 FROM [dbo].[tbl_CDSLAlert_Temp]     
  
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
 ELSE IF (@FileName ='NSE')  
 BEGIN   
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_NSEAlert  A Inner Join tbl_NSEAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.AlertDate =  B.AlertDate  
  AND A.NSEtype= B.NSEtype  
    
 INSERT INTO tbl_NSEAlert  
 (  
  ClientID  
  ,ClientName  
  ,AlertDate  
  ,RefNo  
  ,AlertType  
  ,[FileName]  
  ,TradeDate  
  ,DeadLine  
  ,PAN  
  ,CaseID  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,MemberID  
  ,CurrentPeriod  
  ,CurrentTurnover  
  ,PreviousPeriod  
  ,PreviousTurnover  
  ,PercentIncrease  
  ,BuySell  
  ,InstrumentCode  
  ,ClientBuyValue  
  ,ClientSellValue  
  ,MemberBuyValue  
  ,MemberSellValue  
  ,Scrip  
  ,NSEGroup  
  ,[Type]  
  ,MemberBuyQuantity  
  ,MemberSellQuantity  
  ,GrossScripQuantity  
  ,MemberScripQuantity  
  ,PercentMemberConcentration  
  ,MemberScripPercent  
  
  ,Top5BuyValue  
  ,Top5SellValue  
  ,AggClientPercentage  
  ,PercentMarketConcentration  
  ,LimitPrice  
  ,OriginalVolume  
  ,VolumeDisclosed  
  ,LTPVariation  
  ,OrderNumber  
  ,UnderlyingPrice  
  ,OptionType  
  ,StrikePrice  
  ,ExpiryDate  
  ,TotalBuyQty  
  ,TotalSellQty  
  ,TotalSPoofQty  
  ,Profit  
  ,Part  
  ,TotalSelfQty  
  ,NSEtype  
 )  
 SELECT   
  
  ClientID  
  ,ClientName  
  ,AlertDate  
  ,RefNo  
  ,AlertType  
  ,[FileName]  
  ,TradeDate  
  ,DeadLine  
  ,PAN  
  ,CaseID  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,MemberID  
  ,CurrentPeriod  
  ,CurrentTurnover  
  ,PreviousPeriod  
  ,PreviousTurnover  
  --,PercentIncrease  
  ,CAST((CASE WHEN ISNULL(PercentIncrease,'') = '' THEN '0' ELSE PercentIncrease END) AS DECIMAL(18,2))  
  ,BuySell  
  ,InstrumentCode  
  ,ClientBuyValue  
  ,ClientSellValue  
  ,MemberBuyValue  
  ,MemberSellValue  
  ,Scrip  
  ,NSEGroup  
  ,[Type]  
  --,MemberBuyQuantity  
  --,MemberSellQuantity  
  --,GrossScripQuantity  
  --,MemberScripQuantity  
  --,PercentMemberConcentration  
  --,MemberScripPercent  
  ,CAST((CASE WHEN ISNULL(MemberBuyQuantity,'') = '' THEN '0' ELSE MemberBuyQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(MemberSellQuantity,'') = '' THEN '0' ELSE MemberSellQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(GrossScripQuantity,'') = '' THEN '0' ELSE GrossScripQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(MemberScripQuantity,'') = '' THEN '0' ELSE MemberScripQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(PercentMemberConcentration,'') = '' THEN '0' ELSE PercentMemberConcentration  END) AS DECIMAL(18,2))  
  ,CAST((CASE WHEN ISNULL(MemberScripPercent,'') = '' THEN '0' ELSE MemberScripPercent  END) AS DECIMAL(18,2))  
  ,Top5BuyValue  
  ,Top5SellValue  
  --,AggClientPercentage  
  --,PercentMarketConcentration  
  ,CAST((CASE WHEN ISNULL(AggClientPercentage,'') = '' THEN '0' ELSE AggClientPercentage  END) AS DECIMAL(18,2))  
  ,CAST((CASE WHEN ISNULL(PercentMarketConcentration,'') = '' THEN '0' ELSE PercentMarketConcentration  END) AS DECIMAL(18,2))  
  ,LimitPrice  
  --,OriginalVolume  
  --,VolumeDisclosed  
  ,CAST((CASE WHEN ISNULL(OriginalVolume,'') = '' THEN '0' ELSE OriginalVolume END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(VolumeDisclosed,'') = '' THEN '0' ELSE VolumeDisclosed END) AS DECIMAL(18,0))  
  ,LTPVariation  
  ,OrderNumber  
  ,UnderlyingPrice  
  --,CAST((CASE WHEN ISNULL(PercentMarketConcentration,'') = '' THEN '0' ELSE PercentMarketConcentration  END) AS DECIMAL(18,2))  
  ,OptionType  
  ,StrikePrice  
  ,ExpiryDate  
  --,TotalBuyQty  
  --,TotalSellQty  
  --,TotalSPoofQty  
  ,CAST((CASE WHEN ISNULL(TotalBuyQty,'') = '' THEN '0' ELSE TotalBuyQty  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(TotalSellQty,'') = '' THEN '0' ELSE TotalSellQty  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(TotalSPoofQty,'') = '' THEN '0' ELSE TotalSPoofQty  END) AS DECIMAL(18,0))  
  ,Profit  
  ,Part  
  --,TotalSelfQty  
  ,CAST((CASE WHEN ISNULL(TotalSelfQty,'') = '' THEN '0' ELSE TotalSelfQty END) AS DECIMAL(18,0))  
  ,NSEtype  
 FROM [dbo].[tbl_NSEAlert_Temp]     
    
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
   
 ELSE IF (@FileName ='signification holding')  
 BEGIN   
    
  --UPDATE A   
  --SET A.RecordStatus   = 'D'  
  --FROM  tbl_ShareHolder A Inner Join tbl_ShareHolder_Temp B  
  --ON A.ClientID  =  B.ClientID   
  
  UPDATE A   
  SET A.ClientID  =  B.CL_CODE  
  FROM tbl_ShareHolder_Temp A INNER JOIN ANAND1.MSAJAG.DBO.CLIENT_DETAILS B  
  ON A.PAN  = B.PAN_GIR_NO   
  WHERE A.ClientID =  '0'  
  
  UPDATE A   
  SET A.ClientID  =  B.NISE_PARTY_CODE  
  FROM tbl_ShareHolder_Temp A INNER JOIN [AngelDP4].DMAT.dbo.Tbl_CLIENT_MASTER B  
  ON A.DPID = B.CLIENT_CODE  
  WHERE A.ClientID =  '0'  
  
/*  
SELECT NISE_PARTY_CODE,CLIENT_CODE ,  * FROM [172.31.16.108].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE IN   
(  
 '1203320007904242','1203320001242112','1203320001246005'  
)  
*/  
  
  INSERT INTO dbo.[tbl_ShareHolder]  
  (  
   DPID  
   ,ClientID  
   ,ClientName  
   ,PAN  
   ,ScripCode  
   ,ScripGroup  
   ,ISIN  
   ,ISINName  
   ,HoldingQuantity  
   ,TotMarketCapShares  
   ,PercMarketCap  
   ,AffiliatedAs  
   --,AffiliatedIsin  
   --,AffiliatedIsinName  
   --,ScripValue  
   --,TotHoldingValue  
   --,ScripPerTotHolding  
   --,LastIncomeGroup  
   --,LastExactIncome  
   --,LastNetworth  
   --,Age  
   --,Occupation  
   --,Mobile  
   --,Email  
   --,[Address]  
   --,Risk  
  )  
  
  SELECT   
   DPID  
   ,ClientID  
   ,ClientName  
   ,PAN  
   ,ScripCode  
   ,ScripGroup  
   ,ISIN  
   ,ISINName  
   ,CAST((CASE WHEN ISNULL(HoldingQuantity,'') = '' THEN '0' ELSE HoldingQuantity END) AS DECIMAL(18,2))  
   ,CAST((CASE WHEN ISNULL(TotMarketCapShares,'') = '' THEN '0' ELSE TotMarketCapShares END) AS DECIMAL(18,2))  
   ,CAST((CASE WHEN ISNULL(PercMarketCap,'') = '' THEN '0' ELSE PercMarketCap END) AS DECIMAL(18,2))  
   ,AffiliatedAs  
   --,AffiliatedIsin  
   --,AffiliatedIsinName  
   --,CAST((CASE WHEN ISNULL(ScripValue,'') = '' THEN '0' ELSE ScripValue END) AS DECIMAL(18,2))  
   --,CAST((CASE WHEN ISNULL(TotHoldingValue,'') = '' THEN '0' ELSE TotHoldingValue END) AS DECIMAL(18,2))  
   --,CAST((CASE WHEN ISNULL(ScripPerTotHolding,'') = '' THEN '0' ELSE ScripPerTotHolding END) AS DECIMAL(18,2))  
   --,LastIncomeGroup  
   --,LastExactIncome  
   --,LastNetworth  
   --,Age  
   --,Occupation  
   --,Mobile  
   --,Email  
   --,[Address]  
   --,Risk  
  FROM [dbo].[tbl_ShareHolder_Temp]  
  
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
    
 IF @@Error <> 0   
  BEGIN  
  SET @Flag  = 'Fail'  
   EXEC usp_UploadClear @FileName, @SheetName, @Flag  
  ROLLBACK TRAN   
  END   
 ELSE  
  COMMIT TRAN   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadAlert_25jan2022
-- --------------------------------------------------
  
/*  
 exec usp_UploadAlert 'BSE'  
 exec usp_UploadAlert 'TSS'  
 exec usp_UploadAlert 'DP'  
 exec usp_UploadAlert 'NSE'  
 exec usp_UploadAlert 'SIGNIFICATION'  
   
*/  
  
CREATE PROC [dbo].[usp_UploadAlert_25jan2022]  
(  
@FileName varchar(100)  
,@SheetName varchar(100) = ''  
)  
AS  
  
BEGIN   
  
 DECLARE @Flag varchar(20)  
  
 BEGIN TRAN   
   
 -- SELECT * from [dbo].[tbl_PMLAUserLog]  
 -- Truncate table tbl_PMLAUserLog  
 INSERT INTO tbl_PMLAUserLog (SPName,param1)  
 VALUES('usp_UploadAlert', @FileName)  
  
 /*  
  delete from tbl_TSSAlert_Temp where id > 20  
  select * from tbl_TSSAlert_Temp where id > 20  
  select * from tbl_TSSAlert where RecordStatus   = 'd'  
  select * from tbl_TSSAlert where RecordStatus   = 'A'  
 */  
  
 SET @Flag  = 'Success'  
  
  
 IF (@FileName ='BSE' )  
 BEGIN   
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_BSEAlert  A Inner Join tbl_BSEAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.AlertDate =  B.AlertDate  
    
  INSERT INTO [tbl_BSEAlert]  
     (  
     ClientID  
     ,ClientName  
     ,AlertType  
     ,AlertDate  
     ,AlertFrequencyType  
     ,InstrumentCode  
     ,TradeDate  
     ,AlertGroup  
     ,[Type]  
     ,Scrip  
     ,[Message]  
     ,GroupAlertNo  
     ,OtherClients  
     ,RefNo  
     ,ExchangeStatus  
     ,Part  
     ,TotalSelfQty  
     ,TotalBuyQty  
     ,TotalSellQty  
     ,TotalSPoofQty  
     ,Profit  
     ,DeadLine  
     ,PAN  
     ,EmailSendDate  
     ,ScripQty  
     ,Top5ClientBuy  
     ,Top5ClientSell  
     ,TradeDateString  
     ,CurrentPeriod  
     ,InstrumentName  
     ,CaseId  
     ,ClientExplanation  
     ,EmailSent  
     ,ExchangeInformed  
     ,ClosedDate  
     ,RegisterCaseID  
     ,Segment  
     ,Age  
     ,CustomRisk  
     ,LastestIncome  
     ,Email  
     ,Mobile  
     ,IntermediatoryCode  
     ,IntermediatoryName  
     ,TradeName  
     ,RiskCategory  
     ,CSC  
     ,Gender  
     ,AddedBy  
     ,AddedOn  
     ,LastEditedBy  
     ,EditedOn  
     ,Comment  
     ,[Status]  
     )  
  
    SELECT   
      ClientID  
      ,ClientName  
      ,AlertType  
      ,AlertDate  
      ,AlertFrequencyType  
      ,InstrumentCode  
      ,TradeDate  
      ,AlertGroup  
      ,[Type]  
      ,Scrip  
      ,[Message]  
      --,GroupAlertNo  
      ,CAST((CASE WHEN ISNULL(GroupAlertNo,'') = '' THEN '0' ELSE GroupAlertNo END) AS DECIMAL(18,0))  
      ,OtherClients  
      ,RefNo  
      ,ExchangeStatus  
      ,Part  
      --,TotalSelfQty  
      --,TotalBuyQty  
      --,TotalSellQty  
      --,TotalSPoofQty  
      ,CAST((CASE WHEN ISNULL(TotalSelfQty,'') = '' THEN '0' ELSE TotalSelfQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalBuyQty,'') = '' THEN '0' ELSE TotalBuyQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalSellQty,'') = '' THEN '0' ELSE TotalSellQty END) AS DECIMAL(18,0))  
      ,CAST((CASE WHEN ISNULL(TotalSPoofQty,'') = '' THEN '0' ELSE TotalSPoofQty END) AS DECIMAL(18,0))  
      ,Profit  
      ,DeadLine  
      ,PAN  
      ,EmailSendDate  
      --,ScripQty  
      ,CAST((CASE WHEN ISNULL(ScripQty,'') = '' THEN '0' ELSE ScripQty END) AS DECIMAL(18,0))  
      ,Top5ClientBuy  
      ,Top5ClientSell  
      ,TradeDateString  
      ,CurrentPeriod  
      ,InstrumentName  
      ,CaseId  
      ,ClientExplanation  
      ,EmailSent  
      ,ExchangeInformed  
      ,ClosedDate  
      ,RegisterCaseID  
      ,Segment  
      ,Age  
      ,CustomRisk  
      ,LastestIncome  
      ,Email  
      ,Mobile  
      ,IntermediatoryCode  
      ,IntermediatoryName  
      ,TradeName  
      ,RiskCategory  
      ,CSC  
      ,Gender  
      ,AddedBy  
      ,AddedOn  
      ,LastEditedBy  
      ,EditedOn  
      ,Comment  
      ,[Status]  
    FROM [dbo].[tbl_BSEAlert_Temp]    
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
   
 ELSE IF (@FileName ='TSS' )  
 BEGIN   
  UPDATE A   
   SET A.RecordStatus   = 'D'  
   FROM  tbl_TSSAlert  A Inner Join tbl_TSSAlert_Temp B  
   ON A.ClientID  =  B.ClientID   
   AND A.MinTransDate =  B.MinTransDate  
   AND A.MaxTransDate =  B.MaxTransDate  
   AND A.TSStype = B.TSStype  
  
  INSERT INTO tbl_TSSAlert  
   (  
   ClientID  
   ,ClientName  
   ,Networth  
   ,Income  
   ,Strength  
   ,MoneyInOut  
   ,ViolationAmt  
   ,MinTransDate  
   ,MaxTransDate  
   ,NetworthDesc  
   ,IncomeDesc  
   ,MinTransDateString  
   ,MaxTransDateString  
   ,RunDateString  
   ,IsNBFClient  
   ,SanctionLimit  
   ,CaseID  
   ,ClientExplanation  
   ,EmailSent  
   ,ExchangeInformed  
   ,ClosedDate  
   ,RegisterCaseID  
   ,Segment  
   ,Age  
   ,CustomRisk  
   ,LastestIncome  
   ,Email  
   ,Mobile  
   ,IntermediatoryCode  
   ,IntermediatoryName  
   ,TradeName  
   ,RiskCategory  
   ,CSC  
   ,Gender  
   ,RuleID  
   ,AddedBy  
   ,AddedOn  
   ,LastEditedBy  
   ,EditedOn  
   ,Comment  
   ,[Status]  
   ,TSStype  
   )  
  
   SELECT   
     ClientID  
     ,ClientName  
     --,Networth  
     --,Income  
     --,Strength  
     ,CAST((CASE WHEN ISNULL(Networth ,'') = '' THEN '0' ELSE Networth  END) AS DECIMAL(18,2))  
     ,CAST((CASE WHEN ISNULL(Income ,'') = '' THEN '0' ELSE Income  END) AS DECIMAL(18,2))  
     ,CAST((CASE WHEN ISNULL(Strength ,'') = '' THEN '0' ELSE Strength  END) AS DECIMAL(18,2))  
     ,MoneyInOut  
     --,ViolationAmt   
     ,CAST((CASE WHEN ISNULL(ViolationAmt ,'') = '' THEN '0' ELSE ViolationAmt  END) AS DECIMAL(18,2))  
     ,MinTransDate  
     ,MaxTransDate  
     ,NetworthDesc  
     ,IncomeDesc  
     ,MinTransDateString  
     ,MaxTransDateString  
     ,RunDateString  
     ,IsNBFClient  
     ,SanctionLimit  
     ,CaseID  
     ,ClientExplanation  
     ,EmailSent  
     ,ExchangeInformed  
     ,ClosedDate  
     ,RegisterCaseID  
     ,Segment  
     ,Age  
     ,CustomRisk  
     ,LastestIncome  
     ,Email  
     ,Mobile  
     ,IntermediatoryCode  
     ,IntermediatoryName  
     ,TradeName  
     ,RiskCategory  
     ,CSC  
     ,Gender  
     ,RuleID  
     ,AddedBy  
     ,AddedOn  
     ,LastEditedBy  
     ,EditedOn  
     ,Comment  
     ,[Status]  
     ,TSStype  
   FROM [dbo].[tbl_TSSAlert_Temp]     
     
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
 ELSE IF (@FileName ='DP' )  
 BEGIN   
    
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_CDSLAlert  A Inner Join tbl_CDSLAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.TransDate =  B.TransDate  
  AND A.CDSLType = B.CDSLType  
  
  INSERT INTO tbl_CDSLAlert  
 (  
  ClientID  
  ,ClientName  
  ,Batch  
  ,TransactionType  
  ,PAN  
  ,Scrip  
  ,ISIN  
  ,ISINDescription  
  ,TransDate  
  ,CreditDebit  
  ,TransQty  
  ,TransDescription  
  ,RefNo  
  ,MarketRateISIN  
  ,TransactionValue  
  ,OppClientDPID  
  ,OppClientID  
  ,OppClientName  
  ,ReasonCode  
  ,Segment  
  ,TarFileName  
  ,TransDateString  
  ,CaseId  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,RegisterCaseID  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,IntermediatoryName  
  ,TradeName  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,Consideration  
  ,Reason  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,CDSLType  
 )  
  
 SELECT   
  ClientID  
  ,ClientName  
  ,Batch  
  ,TransactionType  
  ,PAN  
  ,Scrip  
  ,ISIN  
  ,ISINDescription  
  ,TransDate  
  ,CreditDebit  
  --,TransQty     
  ,CAST((CASE WHEN ISNULL(TransQty,'') = '' THEN '0' ELSE TransQty END) AS DECIMAL(18,0))  
  ,TransDescription  
  ,RefNo  
  --,MarketRateISIN  
  ,CAST((CASE WHEN ISNULL(MarketRateISIN,'') = '' THEN '0' ELSE MarketRateISIN END) AS DECIMAL(18,0))  
  ,TransactionValue  
  ,OppClientDPID   
  ,OppClientID  
  ,OppClientName  
  ,ReasonCode  
  ,Segment  
  ,TarFileName  
  ,TransDateString  
  ,CaseId  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,RegisterCaseID  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,IntermediatoryName  
  ,TradeName  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,Consideration  
  ,Reason  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,CDSLType  
 FROM [dbo].[tbl_CDSLAlert_Temp]     
  
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
 ELSE IF (@FileName ='NSE')  
 BEGIN   
  UPDATE A   
  SET A.RecordStatus   = 'D'  
  FROM  tbl_NSEAlert  A Inner Join tbl_NSEAlert_Temp B  
  ON A.ClientID  =  B.ClientID   
  AND A.AlertDate =  B.AlertDate  
  AND A.NSEtype= B.NSEtype  
    
 INSERT INTO tbl_NSEAlert  
 (  
  ClientID  
  ,ClientName  
  ,AlertDate  
  ,RefNo  
  ,AlertType  
  ,[FileName]  
  ,TradeDate  
  ,DeadLine  
  ,PAN  
  ,CaseID  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,MemberID  
  ,CurrentPeriod  
  ,CurrentTurnover  
  ,PreviousPeriod  
  ,PreviousTurnover  
  ,PercentIncrease  
  ,BuySell  
  ,InstrumentCode  
  ,ClientBuyValue  
  ,ClientSellValue  
  ,MemberBuyValue  
  ,MemberSellValue  
  ,Scrip  
  ,NSEGroup  
  ,[Type]  
  ,MemberBuyQuantity  
  ,MemberSellQuantity  
  ,GrossScripQuantity  
  ,MemberScripQuantity  
  ,PercentMemberConcentration  
  ,MemberScripPercent  
  
  ,Top5BuyValue  
  ,Top5SellValue  
  ,AggClientPercentage  
  ,PercentMarketConcentration  
  ,LimitPrice  
  ,OriginalVolume  
  ,VolumeDisclosed  
  ,LTPVariation  
  ,OrderNumber  
  ,UnderlyingPrice  
  ,OptionType  
  ,StrikePrice  
  ,ExpiryDate  
  ,TotalBuyQty  
  ,TotalSellQty  
  ,TotalSPoofQty  
  ,Profit  
  ,Part  
  ,TotalSelfQty  
  ,NSEtype  
 )  
 SELECT   
  
  ClientID  
  ,ClientName  
  ,AlertDate  
  ,RefNo  
  ,AlertType  
  ,[FileName]  
  ,TradeDate  
  ,DeadLine  
  ,PAN  
  ,CaseID  
  ,ClientExplanation  
  ,EmailSent  
  ,ExchangeInformed  
  ,ClosedDate  
  ,Age  
  ,CustomRisk  
  ,LastestIncome  
  ,Email  
  ,Mobile  
  ,IntermediatoryCode  
  ,RiskCategory  
  ,CSC  
  ,Gender  
  ,AddedBy  
  ,AddedOn  
  ,LastEditedBy  
  ,EditedOn  
  ,Comment  
  ,[Status]  
  ,MemberID  
  ,CurrentPeriod  
  ,CurrentTurnover  
  ,PreviousPeriod  
  ,PreviousTurnover  
  --,PercentIncrease  
  ,CAST((CASE WHEN ISNULL(PercentIncrease,'') = '' THEN '0' ELSE PercentIncrease END) AS DECIMAL(18,2))  
  ,BuySell  
  ,InstrumentCode  
  ,ClientBuyValue  
  ,ClientSellValue  
  ,MemberBuyValue  
  ,MemberSellValue  
  ,Scrip  
  ,NSEGroup  
  ,[Type]  
  --,MemberBuyQuantity  
  --,MemberSellQuantity  
  --,GrossScripQuantity  
  --,MemberScripQuantity  
  --,PercentMemberConcentration  
  --,MemberScripPercent  
  ,CAST((CASE WHEN ISNULL(MemberBuyQuantity,'') = '' THEN '0' ELSE MemberBuyQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(MemberSellQuantity,'') = '' THEN '0' ELSE MemberSellQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(GrossScripQuantity,'') = '' THEN '0' ELSE GrossScripQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(MemberScripQuantity,'') = '' THEN '0' ELSE MemberScripQuantity  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(PercentMemberConcentration,'') = '' THEN '0' ELSE PercentMemberConcentration  END) AS DECIMAL(18,2))  
  ,CAST((CASE WHEN ISNULL(MemberScripPercent,'') = '' THEN '0' ELSE MemberScripPercent  END) AS DECIMAL(18,2))  
  ,Top5BuyValue  
  ,Top5SellValue  
  --,AggClientPercentage  
  --,PercentMarketConcentration  
  ,CAST((CASE WHEN ISNULL(AggClientPercentage,'') = '' THEN '0' ELSE AggClientPercentage  END) AS DECIMAL(18,2))  
  ,CAST((CASE WHEN ISNULL(PercentMarketConcentration,'') = '' THEN '0' ELSE PercentMarketConcentration  END) AS DECIMAL(18,2))  
  ,LimitPrice  
  --,OriginalVolume  
  --,VolumeDisclosed  
  ,CAST((CASE WHEN ISNULL(OriginalVolume,'') = '' THEN '0' ELSE OriginalVolume END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(VolumeDisclosed,'') = '' THEN '0' ELSE VolumeDisclosed END) AS DECIMAL(18,0))  
  ,LTPVariation  
  ,OrderNumber  
  ,UnderlyingPrice  
  --,CAST((CASE WHEN ISNULL(PercentMarketConcentration,'') = '' THEN '0' ELSE PercentMarketConcentration  END) AS DECIMAL(18,2))  
  ,OptionType  
  ,StrikePrice  
  ,ExpiryDate  
  --,TotalBuyQty  
  --,TotalSellQty  
  --,TotalSPoofQty  
  ,CAST((CASE WHEN ISNULL(TotalBuyQty,'') = '' THEN '0' ELSE TotalBuyQty  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(TotalSellQty,'') = '' THEN '0' ELSE TotalSellQty  END) AS DECIMAL(18,0))  
  ,CAST((CASE WHEN ISNULL(TotalSPoofQty,'') = '' THEN '0' ELSE TotalSPoofQty  END) AS DECIMAL(18,0))  
  ,Profit  
  ,Part  
  --,TotalSelfQty  
  ,CAST((CASE WHEN ISNULL(TotalSelfQty,'') = '' THEN '0' ELSE TotalSelfQty END) AS DECIMAL(18,0))  
  ,NSEtype  
 FROM [dbo].[tbl_NSEAlert_Temp]     
    
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
   
 ELSE IF (@FileName ='signification holding')  
 BEGIN   
    
  --UPDATE A   
  --SET A.RecordStatus   = 'D'  
  --FROM  tbl_ShareHolder A Inner Join tbl_ShareHolder_Temp B  
  --ON A.ClientID  =  B.ClientID   
  
  UPDATE A   
  SET A.ClientID  =  B.CL_CODE  
  FROM tbl_ShareHolder_Temp A INNER JOIN ANAND1.MSAJAG.DBO.CLIENT_DETAILS B  
  ON A.PAN  = B.PAN_GIR_NO   
  WHERE A.ClientID =  '0'  
  
  UPDATE A   
  SET A.ClientID  =  B.NISE_PARTY_CODE  
  FROM tbl_ShareHolder_Temp A INNER JOIN [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER B  
  ON A.DPID = B.CLIENT_CODE  
  WHERE A.ClientID =  '0'  
  
/*  
SELECT NISE_PARTY_CODE,CLIENT_CODE ,  * FROM [172.31.16.94].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK) WHERE CLIENT_CODE IN   
(  
 '1203320007904242','1203320001242112','1203320001246005'  
)  
*/  
  
  INSERT INTO dbo.[tbl_ShareHolder]  
  (  
   DPID  
   ,ClientID  
   ,ClientName  
   ,PAN  
   ,ScripCode  
   ,ScripGroup  
   ,ISIN  
   ,ISINName  
   ,HoldingQuantity  
   ,TotMarketCapShares  
   ,PercMarketCap  
   ,AffiliatedAs  
   --,AffiliatedIsin  
   --,AffiliatedIsinName  
   --,ScripValue  
   --,TotHoldingValue  
   --,ScripPerTotHolding  
   --,LastIncomeGroup  
   --,LastExactIncome  
   --,LastNetworth  
   --,Age  
   --,Occupation  
   --,Mobile  
   --,Email  
   --,[Address]  
   --,Risk  
  )  
  
  SELECT   
   DPID  
   ,ClientID  
   ,ClientName  
   ,PAN  
   ,ScripCode  
   ,ScripGroup  
   ,ISIN  
   ,ISINName  
   ,CAST((CASE WHEN ISNULL(HoldingQuantity,'') = '' THEN '0' ELSE HoldingQuantity END) AS DECIMAL(18,2))  
   ,CAST((CASE WHEN ISNULL(TotMarketCapShares,'') = '' THEN '0' ELSE TotMarketCapShares END) AS DECIMAL(18,2))  
   ,CAST((CASE WHEN ISNULL(PercMarketCap,'') = '' THEN '0' ELSE PercMarketCap END) AS DECIMAL(18,2))  
   ,AffiliatedAs  
   --,AffiliatedIsin  
   --,AffiliatedIsinName  
   --,CAST((CASE WHEN ISNULL(ScripValue,'') = '' THEN '0' ELSE ScripValue END) AS DECIMAL(18,2))  
   --,CAST((CASE WHEN ISNULL(TotHoldingValue,'') = '' THEN '0' ELSE TotHoldingValue END) AS DECIMAL(18,2))  
   --,CAST((CASE WHEN ISNULL(ScripPerTotHolding,'') = '' THEN '0' ELSE ScripPerTotHolding END) AS DECIMAL(18,2))  
   --,LastIncomeGroup  
   --,LastExactIncome  
   --,LastNetworth  
   --,Age  
   --,Occupation  
   --,Mobile  
   --,Email  
   --,[Address]  
   --,Risk  
  FROM [dbo].[tbl_ShareHolder_Temp]  
  
  EXEC usp_UploadClear @FileName, @SheetName, @Flag  
 END   
  
    
 IF @@Error <> 0   
  BEGIN  
  SET @Flag  = 'Fail'  
   EXEC usp_UploadClear @FileName, @SheetName, @Flag  
  ROLLBACK TRAN   
  END   
 ELSE  
  COMMIT TRAN   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadClear
-- --------------------------------------------------


/*

exec usp_UploadAlertClear


*/

CREATE  PROC [dbo].[usp_UploadClear]
(
	@FileName varchar(100),
	@SheetName varchar(100) ='',
	@Flag varchar(20)
)
AS

BEGIN 

	BEGIN TRAN 

		IF (@FileName ='BSE' )
		BEGIN 
			TRUNCATE TABLE [dbo].[tbl_BSEAlert_Temp]  
			EXEC [usp_UploadSendMail] @FileName, @SheetName, @Flag
		END
	
		ELSE IF (@FileName ='TSS' )
		BEGIN 
			TRUNCATE TABLE [dbo].[tbl_TSSAlert_Temp]  
			EXEC [usp_UploadSendMail] @FileName, @SheetName, @Flag
		END

		ELSE IF (@FileName ='DP' )
		BEGIN 
			TRUNCATE TABLE [dbo].[tbl_CDSLAlert_Temp] 
			EXEC [usp_UploadSendMail] @FileName, @SheetName, @Flag
		END
	
		ELSE IF (@FileName ='NSE')
		BEGIN 
			TRUNCATE TABLE [dbo].[tbl_NSEAlert_Temp]  
			EXEC [usp_UploadSendMail] @FileName, @SheetName, @Flag
		END

		ELSE IF (@FileName ='signification holding')
		BEGIN 
			TRUNCATE TABLE [dbo].[tbl_ShareHolder_Temp]   
			EXEC [usp_UploadSendMail] @FileName, @SheetName, @Flag
		END

	COMMIT TRAN 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadClearAll
-- --------------------------------------------------


/*
	exec usp_UploadClearAll
*/

CREATE PROC [dbo].[usp_UploadClearAll]
AS

BEGIN 

	BEGIN TRAN 
	
		TRUNCATE TABLE [dbo].[tbl_BSEAlert_Temp]  
		TRUNCATE TABLE [dbo].[tbl_NSEAlert_Temp]   
		TRUNCATE TABLE [dbo].[tbl_CDSLAlert_Temp]   
		TRUNCATE TABLE [dbo].[tbl_TSSAlert_Temp]   
		TRUNCATE TABLE [dbo].[tbl_ShareHolder_Temp]   
 


	COMMIT TRAN 

	/*

	
		TRUNCATE TABLE [dbo].[tbl_BSEAlert]  
		TRUNCATE TABLE [dbo].[tbl_NSEAlert]   
		TRUNCATE TABLE [dbo].[tbl_CDSLAlert]   
		TRUNCATE TABLE [dbo].[tbl_TSSAlert]   
		TRUNCATE TABLE [dbo].[tbl_ShareHolder]  

		select * from  [dbo].[tbl_BSEAlert_Temp]  
		select * from  [dbo].[tbl_NSEAlert_Temp]   
		select * from  [dbo].[tbl_CDSLAlert_Temp]   
		select * from  [dbo].[tbl_TSSAlert_Temp]   
		select * from  [dbo].[tbl_ShareHolder_Temp]  
		 
		select * from  [dbo].[tbl_BSEAlert]  
		select * from  [dbo].[tbl_NSEAlert]   
		select * from  [dbo].[tbl_CDSLAlert]   
		select * from  [dbo].[tbl_TSSAlert]   
		select * from  [dbo].[tbl_ShareHolder]  

	*/
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadSendMail
-- --------------------------------------------------
/*  
  
 exec usp_UploadSendMail  'BSE',  'DataSheet', 'Success'  
 exec usp_UploadSendMail  'BSE',  'DataSheet', 'Exception'  
 exec usp_UploadSendMail  'BSE',  'DataSheet', 'Fail'  
   
  
*/  
  
CREATE PROC [dbo].[usp_UploadSendMail]  
(  
 @FileName varchar(100),  
 @SheetName varchar(100) = '',  
 @flag varchar(20)  
)  
AS  
  
BEGIN   
  
 --declare @Status varchar (100)  
 declare @CurrentDate varchar(100)  
 --set @CurrentDate  = convert(varchar, getdate(), 103)  
 set @CurrentDate  = left( convert(varchar, getdate(), 113),20)  
   
 declare @SubjectLine nvarchar(1000)  
 declare @BodyLine nvarchar(MAX)  
 declare @BodyMessage nvarchar(MAX)  
  
 if (@SheetName <> '')   
  SET @SheetName =  '-' + @SheetName  
 else   
  SET @SheetName =  ' '  
  
 IF (@flag = 'Success')  
  BEGIN  
   ---SET @Status =  'Successfully'  
   SET @SubjectLine  =  'Bulk Upload for ' + @FileName  + @SheetName  +' processed successfully for ' + @CurrentDate  
   SET @BodyMessage ='Bulk Upload for ' + @FileName  + @SheetName + ' of records for the dated ' + @CurrentDate  + ' has processed Successfully'  
  END   
 ELSE IF (@flag = 'Exception')  
  BEGIN  
   --SET @Status =  'due to File convetion failure'  
   SET @SubjectLine  =  'Bulk Upload for ' + @FileName  + @SheetName +' failed due to File dated ' + @CurrentDate  
   SET @BodyMessage ='Bulk Upload for ' + @FileName  + @SheetName + ' for the dated ' + @CurrentDate  + ' failed due to File Error'  
  END  
 ELSE   
  BEGIN  
   --SET @Status =  'with failure'  
   SET @SubjectLine  =  'Bulk Upload for ' + @FileName  + @SheetName +' failed for the dated ' + @CurrentDate  
   SET @BodyMessage ='Bulk Upload for ' + @FileName  + @SheetName + ' for the dated ' + @CurrentDate  + ' failed due File content error'  
  END  
  
  
 --SET @SubjectLine  =  'Bulk Upload for ' + @FileName +' processed successfully for ' + @CurrentDate  
  
 SET @BodyLine =  '<html><body><div>  
 Dear Sir,  
 <br></br>  
 <br>' + @BodyMessage +'</br>    
 <br></br>  
 <br>Note: This is system generated message. For any issue, please send an email to </br>  
 <br></br>  
 <br>inhouse.support@angelbroking.com</br>  
 <br></br>  
 <br></br>  
 <br></br>  
  
 <br>Thanking You,</br>  
 <br>In-House Support Team.</br>  
 <br></br>  
 <br></br>  
 </div></body></html>'   
  
 EXEC msdb.dbo.sp_send_dbmail                                     
  @profile_name = 'Intranet',                                                       
  --@recipients=  'farhan.khan@angelbroking.com; Subramanian.iyer@angelbroking.com; pratibha.chaudhari@angelbroking.com',            
    
  --@recipients=  'kevin.fernanades@angelbroking.com;',          
  --@copy_recipients= 'vivek.naik@angelbroking.com',  
    
  @recipients=  'aslam.kazi@angelbroking.com;',          
  @copy_recipients= 'chirag.gandani@angelbroking.com;aslam.kazi@angelbroking.com;bhushan.patil@angelbroking.com;darshna@angelbroking.com',  
    
  @body = @BodyLine,                                         
  --@file_attachments=@strAttach,                              
  @body_format = 'HTML',                                                           
  @subject = @SubjectLine    
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ValidateUserLogin
-- --------------------------------------------------
--  exec usp_ValidateUserLogin   '9819924434'       
--  exec usp_ValidateUserLogin   '9898387500'       
--  exec usp_ValidateUserLogin   'AJAY007700@GMAIL.COM'       
--  exec usp_ValidateUserLogin   'ALBPB5099C'       
--  exec usp_ValidateUserLogin   'rp61'       
    
--  exec usp_ValidateUserLogin   '565928275249'    
--  exec usp_ValidateUserLogin   '474466432181'    
--  exec usp_ValidateUserLogin   'Y11240'       
    
    
    
      
CREATE PROCEDURE [dbo].[usp_ValidateUserLogin]       
@User nvarchar (1000)      
AS      
BEGIN      
    
/*      
      
23 R78066 2016-11-22 18:01:00      
24 rp61 2016-11-22 18:14:00      
SELECT  * FROM tbl_UserLog order  by id  (Taotal Record : 26)       
      
65 B47677 2016-12-12 13:23:00      
66 J5788 2016-12-12 13:48:00      
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 66)      
      
68 PTM6628  2016-12-12 18:11:00      
69 GRGN7765 2016-12-13 09:56:00      
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 69)      
      
75 AGRA2137 2016-12-14 17:19:00      
76 D23988 2016-12-15 10:50:00      
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 76)      
      
92 T14939 2016-12-15 17:43:00      
95 usp_GenerateClientProfileInfo 2016-12-15 17:53:00      
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 95)      
      
*/      
      
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)      
VALUES (@User, getdate())      
    
 --SELECT       
 -- Party_code, short_name       
 --FROM       
 -- --client_details       
 -- [196.1.115.182].general.dbo.client_details       
 --WHERE       
 -- party_code = @User      
 -- OR pan_gir_no  = @User      
 -- OR mobile_pager  = @User      
 -- OR email  = @User      
    
(    
 SELECT      
     
  Party_code, short_name    
     
 FROM       
     
  [CSOKYC-6].general.dbo.client_details  A with (nolock) left outer JOIN  
  [kyc1db].[e-Modification].[dbo].[Tbl_Client_Aadhaar_Repository] B with (nolock)    
      
  ON A.party_code = b.partycode    
     
 WHERE       
  A.party_code = @User      
      
  OR A.pan_gir_no  = @User      
      
  OR A.mobile_pager  = @User      
      
  OR A.email  = @User      
      
  OR b.AadhaarNo= @User    
)    
UNION     
(    
 SELECT      
  party_code, party_name as short_name    
 FROM     
  angelfo.bsemfss.dbo.mfss_client with (nolock)     
 WHERE     
      
  party_code = @User      
      
  OR  Pan_No = @User      
      
  OR email_id  = @User      
      
  OR mobile_no = @User      
)    
    
/*    
 SELECT       
  Party_code, short_name    
 FROM       
  [196.1.115.182].general.dbo.client_details  A INNER JOIN [kyc1db].[e-Modification].[dbo].[Tbl_Client_Aadhaar_Repository] B    
  ON A.party_code = b.partycode    
 WHERE       
  A.party_code = @User      
  OR A.pan_gir_no  = @User      
  OR A.mobile_pager  = @User      
  OR A.email  = @User      
  OR b.AadhaarNo= '565928275249'    
    
  select top 10 * from [kyc1db].[e-Modification].[dbo].[Tbl_Client_Aadhaar_Repository]  Where partycode ='WDLA0758'    
    
*/      
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_ValidateUserLogin_Ipartner
-- --------------------------------------------------
  
--  exec usp_ValidateUserLogin   '9819924434'     
  
--  exec usp_ValidateUserLogin   '9898387500'     
  
--  exec usp_ValidateUserLogin   'AJAY007700@GMAIL.COM'     
  
--  exec usp_ValidateUserLogin   'ALBPB5099C'     
  
--  exec usp_ValidateUserLogin   'Y11240'     
  
--  exec usp_ValidateUserLogin   'R105583'     
  
  
  
    
  
CREATE PROCEDURE [dbo].[usp_ValidateUserLogin_Ipartner]     
  
@User nvarchar (1000)    
  
AS    
  
BEGIN    
  
  
  
/*    
  
    
  
23 R78066 2016-11-22 18:01:00    
  
24 rp61 2016-11-22 18:14:00    
  
SELECT  * FROM tbl_UserLog order  by id  (Taotal Record : 26)     
  
    
  
65 B47677 2016-12-12 13:23:00    
  
66 J5788 2016-12-12 13:48:00    
  
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 66)    
  
    
  
68 PTM6628  2016-12-12 18:11:00    
  
69 GRGN7765 2016-12-13 09:56:00    
  
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 69)    
  
    
  
75 AGRA2137 2016-12-14 17:19:00    
  
76 D23988 2016-12-15 10:50:00    
  
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 76)    
  
    
  
92 T14939 2016-12-15 17:43:00    
  
95 usp_GenerateClientProfileInfo 2016-12-15 17:53:00    
  
SELECT  * FROM tbl_UserLog order  by id (Taotal Record : 95)    
  
    
  
*/    
  
    
  
INSERT INTO tbl_UserLog(LoginUser,ModifiedDate)    
  
VALUES (@User, getdate())    
  
  
  
--commented on 04 Apr 2018 for mutual fund client  
  
 --SELECT     
  
 -- Party_code, short_name     
  
 --FROM     
  
 -- [196.1.115.182].general.dbo.client_details     
  
 --WHERE     
  
 -- party_code = @User    
  
 -- OR pan_gir_no  = @User    
  
 -- OR mobile_pager  = @User    
  
 -- OR email  = @User    
  
  
  
   
 (  
  SELECT  DISTINCT  
   Party_code, short_name     
  FROM     
   [CSOKYC-6].general.dbo.client_details     
  WHERE     
  
   party_code = @User    
  
   OR pan_gir_no  = @User    
  
   OR mobile_pager  = @User    
  
   OR email  = @User    
 )  
UNION  
 (  
 SELECT  DISTINCT  
  party_code, party_name as short_name  
 FROM   
  angelfo.bsemfss.dbo.mfss_client  
 WHERE   
    
  party_code = @User    
    
  OR  Pan_No = @User    
    
  OR email_id  = @User    
    
  OR mobile_no = @User    
  )  
  
  
  --- select *  from [172.31.16.173].[e-Modification].[dbo].[Tbl_Client_Aadhaar_Repository] where AadhaarNo= '565928275249'  
  
/*  
  
 SELECT     
  
  Party_code, short_name  
  
 FROM     
  
  [196.1.115.182].general.dbo.client_details  A INNER JOIN [172.31.16.173].[e-Modification].[dbo].[Tbl_Client_Aadhaar_Repository] B  
  
  ON A.party_code = b.partycode  
  
 WHERE     
  
  A.party_code = @User    
  
  OR A.pan_gir_no  = @User    
  
  OR A.mobile_pager  = @User    
  
  OR A.email  = @User    
  
  OR b.AadhaarNo= '565928275249'  
  
*/    
  
  
END

GO

-- --------------------------------------------------
-- TABLE dbo.strMIS
-- --------------------------------------------------
CREATE TABLE [dbo].[strMIS]
(
    [Batch No#] FLOAT NULL,
    [Company] NVARCHAR(255) NULL,
    [Category] NVARCHAR(255) NULL,
    [Client Code] NVARCHAR(255) NULL,
    [F5] NVARCHAR(255) NULL,
    [Data With comma] NVARCHAR(255) NULL,
    [ ] DATETIME NULL,
    [Ground of Suspicion] NVARCHAR(MAX) NULL,
    [Alert Criteria] NVARCHAR(255) NULL,
    [F10] NVARCHAR(255) NULL,
    [F11] NVARCHAR(255) NULL,
    [Reported to BSE] NVARCHAR(255) NULL,
    [F13] FLOAT NULL,
    [F14] NVARCHAR(255) NULL,
    [F15] NVARCHAR(255) NULL,
    [F16] NVARCHAR(255) NULL,
    [F17] NVARCHAR(255) NULL,
    [F18] NVARCHAR(255) NULL,
    [F19] NVARCHAR(255) NULL,
    [F20] NVARCHAR(255) NULL,
    [F21] NVARCHAR(255) NULL,
    [F22] NVARCHAR(255) NULL,
    [F23] NVARCHAR(255) NULL,
    [F24] NVARCHAR(255) NULL,
    [F25] NVARCHAR(255) NULL,
    [F26] NVARCHAR(255) NULL,
    [F27] NVARCHAR(255) NULL,
    [F28] NVARCHAR(255) NULL,
    [F29] NVARCHAR(255) NULL,
    [F30] NVARCHAR(255) NULL,
    [F31] NVARCHAR(255) NULL,
    [F32] NVARCHAR(255) NULL,
    [F33] NVARCHAR(255) NULL,
    [F34] NVARCHAR(255) NULL,
    [F35] NVARCHAR(255) NULL,
    [F36] NVARCHAR(255) NULL,
    [F37] NVARCHAR(255) NULL,
    [F38] NVARCHAR(255) NULL,
    [F39] NVARCHAR(255) NULL,
    [F40] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t1
-- --------------------------------------------------
CREATE TABLE [dbo].[t1]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [batchid] INT NULL,
    [categoryid] INT NULL,
    [clientcode] VARCHAR(5000) NULL,
    [clientname] VARCHAR(MAX) NULL,
    [panno] VARCHAR(5000) NULL,
    [isactive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSEAlert_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSEAlert_RENAMEDAS_PII]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [AlertType] VARCHAR(400) NULL,
    [AlertDate] SMALLDATETIME NULL,
    [AlertFrequencyType] VARCHAR(10) NULL,
    [InstrumentCode] VARCHAR(50) NULL,
    [TradeDate] SMALLDATETIME NULL,
    [AlertGroup] VARCHAR(10) NULL,
    [Type] VARCHAR(10) NULL,
    [Scrip] VARCHAR(100) NULL,
    [Message] VARCHAR(1000) NULL,
    [GroupAlertNo] DECIMAL(18, 0) NULL,
    [OtherClients] VARCHAR(100) NULL,
    [RefNo] VARCHAR(50) NULL,
    [ExchangeStatus] VARCHAR(50) NULL,
    [Part] VARCHAR(10) NULL,
    [TotalSelfQty] DECIMAL(18, 0) NULL,
    [TotalBuyQty] DECIMAL(18, 0) NULL,
    [TotalSellQty] DECIMAL(18, 0) NULL,
    [TotalSPoofQty] DECIMAL(18, 0) NULL,
    [Profit] MONEY NULL,
    [DeadLine] SMALLDATETIME NULL,
    [PAN] VARCHAR(20) NULL,
    [EmailSendDate] SMALLDATETIME NULL,
    [ScripQty] DECIMAL(18, 0) NULL,
    [Top5ClientBuy] MONEY NULL,
    [Top5ClientSell] MONEY NULL,
    [TradeDateString] SMALLDATETIME NULL,
    [CurrentPeriod] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(100) NULL,
    [CaseId] VARCHAR(50) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL,
    [Segment] VARCHAR(10) NULL,
    [Age] INT NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(20) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(400) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [RecordStatus] CHAR(1) NULL DEFAULT 'A',
    [RecordAddedon] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSEAlert_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSEAlert_Temp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(20) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [AlertType] VARCHAR(100) NULL,
    [AlertDate] SMALLDATETIME NULL,
    [AlertFrequencyType] VARCHAR(10) NULL,
    [InstrumentCode] VARCHAR(50) NULL,
    [TradeDate] SMALLDATETIME NULL,
    [AlertGroup] VARCHAR(10) NULL,
    [Type] VARCHAR(10) NULL,
    [Scrip] VARCHAR(100) NULL,
    [Message] VARCHAR(1000) NULL,
    [GroupAlertNo] VARCHAR(100) NULL,
    [OtherClients] VARCHAR(100) NULL,
    [RefNo] VARCHAR(50) NULL,
    [ExchangeStatus] VARCHAR(50) NULL,
    [Part] VARCHAR(10) NULL,
    [TotalSelfQty] VARCHAR(100) NULL,
    [TotalBuyQty] VARCHAR(100) NULL,
    [TotalSellQty] VARCHAR(100) NULL,
    [TotalSPoofQty] VARCHAR(100) NULL,
    [Profit] VARCHAR(100) NULL,
    [DeadLine] SMALLDATETIME NULL,
    [PAN] VARCHAR(20) NULL,
    [EmailSendDate] SMALLDATETIME NULL,
    [ScripQty] VARCHAR(100) NULL,
    [Top5ClientBuy] VARCHAR(100) NULL,
    [Top5ClientSell] VARCHAR(100) NULL,
    [TradeDateString] SMALLDATETIME NULL,
    [CurrentPeriod] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(100) NULL,
    [CaseId] VARCHAR(50) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL,
    [Segment] VARCHAR(10) NULL,
    [Age] VARCHAR(10) NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(20) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(400) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [RecordStatus] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CaseAnalysis
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CaseAnalysis]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NULL,
    [AlertComment] VARCHAR(MAX) NULL,
    [BackgroundComment] VARCHAR(MAX) NULL,
    [FinancialComment] VARCHAR(MAX) NULL,
    [STRComment] VARCHAR(MAX) NULL,
    [SignificantScripName] VARCHAR(400) NULL,
    [SignificantComment] VARCHAR(MAX) NULL,
    [DPComment] VARCHAR(MAX) NULL,
    [TradingComment] VARCHAR(MAX) NULL,
    [OtherDetail] VARCHAR(MAX) NULL,
    [SuspiciousNon] VARCHAR(50) NULL,
    [Conclusion] VARCHAR(MAX) NULL,
    [Submit] BIT NULL DEFAULT ((0)),
    [RecordStatus] CHAR(1) NULL DEFAULT 'A',
    [RecordAddedon] SMALLDATETIME NULL DEFAULT (getdate()),
    [RecordEditedon] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CDSLAlert
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CDSLAlert]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [Batch] VARCHAR(100) NULL,
    [TransactionType] VARCHAR(25) NULL,
    [PAN] VARCHAR(20) NULL,
    [Scrip] VARCHAR(100) NULL,
    [ISIN] VARCHAR(100) NULL,
    [ISINDescription] VARCHAR(1000) NULL,
    [TransDate] SMALLDATETIME NULL,
    [CreditDebit] CHAR(10) NULL,
    [TransQty] DECIMAL(18, 0) NULL DEFAULT ((0)),
    [TransDescription] VARCHAR(400) NULL,
    [RefNo] VARCHAR(100) NULL,
    [MarketRateISIN] DECIMAL(18, 2) NULL DEFAULT ((0)),
    [TransactionValue] MONEY NULL DEFAULT ((0)),
    [OppClientDPID] VARCHAR(100) NULL DEFAULT ((0)),
    [OppClientID] VARCHAR(100) NULL DEFAULT ((0)),
    [OppClientName] VARCHAR(100) NULL,
    [ReasonCode] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [TarFileName] VARCHAR(40) NULL,
    [TransDateString] SMALLDATETIME NULL,
    [CaseId] VARCHAR(100) NULL DEFAULT ((0)),
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL DEFAULT ((0)),
    [Age] INT NULL DEFAULT ((0)),
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(20) NULL,
    [IntermediatoryCode] VARCHAR(50) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(100) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [Consideration] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [CDSLType] VARCHAR(100) NULL,
    [RecordStatus] CHAR(1) NULL DEFAULT 'A',
    [RecordAddedon] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CDSLAlert_Temp 
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CDSLAlert_Temp ]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [Batch] VARCHAR(100) NULL,
    [TransactionType] VARCHAR(25) NULL,
    [PAN] VARCHAR(20) NULL,
    [Scrip] VARCHAR(100) NULL,
    [ISIN] VARCHAR(100) NULL,
    [ISINDescription] VARCHAR(1000) NULL,
    [TransDate] SMALLDATETIME NULL,
    [CreditDebit] CHAR(10) NULL,
    [TransQty] VARCHAR(100) NULL DEFAULT ((0)),
    [TransDescription] VARCHAR(1000) NULL,
    [RefNo] VARCHAR(100) NULL,
    [MarketRateISIN] VARCHAR(100) NULL DEFAULT ((0)),
    [TransactionValue] VARCHAR(100) NULL,
    [OppClientDPID] VARCHAR(100) NULL DEFAULT ((0)),
    [OppClientID] VARCHAR(100) NULL DEFAULT ((0)),
    [OppClientName] VARCHAR(100) NULL,
    [ReasonCode] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [TarFileName] VARCHAR(40) NULL,
    [TransDateString] SMALLDATETIME NULL,
    [CaseId] VARCHAR(100) NULL DEFAULT ((0)),
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL DEFAULT ((0)),
    [Age] VARCHAR(100) NULL DEFAULT ((0)),
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(100) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(100) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [Consideration] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(20) NULL,
    [CDSLType] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_client_master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_client_master]
(
    [client_code] VARCHAR(50) NULL,
    [NISE_PARTY_CODE] VARCHAR(50) NULL,
    [template_code] VARCHAR(50) NULL,
    [FIRST_HOLD_NAME] VARCHAR(500) NULL,
    [STATUS] VARCHAR(50) NULL,
    [EMAIL_ADD] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_client_master_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_client_master_Prev]
(
    [client_code] VARCHAR(50) NULL,
    [NISE_PARTY_CODE] VARCHAR(50) NULL,
    [template_code] VARCHAR(50) NULL,
    [FIRST_HOLD_NAME] VARCHAR(500) NULL,
    [STATUS] VARCHAR(50) NULL,
    [EMAIL_ADD] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_CLIENT_POA
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_CLIENT_POA]
(
    [CLIENT_CODE] VARCHAR(500) NULL,
    [HOLDER_INDI] VARCHAR(10) NULL,
    [MASTER_POA] VARCHAR(500) NULL,
    [POA_TYPE] VARCHAR(5) NULL,
    [POA_DATE_FROM] DATE NULL,
    [POA_STATUS] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_CLIENT_POA_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_CLIENT_POA_Prev]
(
    [CLIENT_CODE] VARCHAR(500) NULL,
    [HOLDER_INDI] VARCHAR(10) NULL,
    [MASTER_POA] VARCHAR(500) NULL,
    [POA_TYPE] VARCHAR(5) NULL,
    [POA_DATE_FROM] DATE NULL,
    [POA_STATUS] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_EquityStatement
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_EquityStatement]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Code] NVARCHAR(100) NOT NULL,
    [Concern] NVARCHAR(1000) NOT NULL,
    [Finding] NVARCHAR(1000) NULL,
    [Actionable] NVARCHAR(1000) NULL,
    [DateModified] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IncomeCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IncomeCategory]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Income] VARCHAR(400) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEAlert_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEAlert_RENAMEDAS_PII]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [AlertDate] SMALLDATETIME NULL,
    [RefNo] VARCHAR(50) NULL,
    [AlertType] VARCHAR(100) NULL,
    [FileName] VARCHAR(100) NULL,
    [TradeDate] SMALLDATETIME NULL,
    [DeadLine] SMALLDATETIME NULL,
    [PAN] VARCHAR(20) NULL,
    [CaseID] VARCHAR(50) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [Age] INT NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(20) NULL,
    [IntermediatoryCode] VARCHAR(50) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [MemberID] VARCHAR(50) NULL,
    [CurrentPeriod] SMALLDATETIME NULL,
    [CurrentTurnover] MONEY NULL,
    [PreviousPeriod] VARCHAR(400) NULL,
    [PreviousTurnover] MONEY NULL,
    [PercentIncrease] DECIMAL(18, 2) NULL,
    [BuySell] CHAR(1) NULL,
    [InstrumentCode] VARCHAR(100) NULL,
    [ClientBuyValue] MONEY NULL,
    [ClientSellValue] MONEY NULL,
    [MemberBuyValue] MONEY NULL,
    [MemberSellValue] MONEY NULL,
    [Scrip] VARCHAR(400) NULL,
    [NSEGroup] VARCHAR(100) NULL,
    [Type] VARCHAR(50) NULL,
    [MemberBuyQuantity] DECIMAL(18, 0) NULL,
    [MemberSellQuantity] DECIMAL(18, 0) NULL,
    [GrossScripQuantity] DECIMAL(18, 0) NULL,
    [MemberScripQuantity] DECIMAL(18, 0) NULL,
    [PercentMemberConcentration] DECIMAL(18, 2) NULL,
    [MemberScripPercent] DECIMAL(18, 2) NULL,
    [Top5BuyValue] MONEY NULL,
    [Top5SellValue] MONEY NULL,
    [AggClientPercentage] DECIMAL(18, 2) NULL,
    [PercentMarketConcentration] DECIMAL(18, 2) NULL,
    [LimitPrice] MONEY NULL,
    [OriginalVolume] DECIMAL(18, 0) NULL,
    [VolumeDisclosed] DECIMAL(18, 0) NULL,
    [LTPVariation] MONEY NULL,
    [OrderNumber] VARCHAR(100) NULL,
    [UnderlyingPrice] MONEY NULL,
    [OptionType] CHAR(10) NULL,
    [StrikePrice] MONEY NULL,
    [ExpiryDate] SMALLDATETIME NULL,
    [TotalBuyQty] DECIMAL(18, 0) NULL,
    [TotalSellQty] DECIMAL(18, 0) NULL,
    [TotalSPoofQty] DECIMAL(18, 0) NULL,
    [Profit] MONEY NULL,
    [Part] VARCHAR(50) NULL,
    [TotalSelfQty] DECIMAL(18, 0) NULL,
    [NSEtype] VARCHAR(100) NULL,
    [RecordStatus] CHAR(1) NULL DEFAULT 'A',
    [RecordAddedon] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEAlert_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEAlert_Temp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [AlertDate] SMALLDATETIME NULL,
    [RefNo] VARCHAR(50) NULL,
    [AlertType] VARCHAR(100) NULL,
    [FileName] VARCHAR(100) NULL,
    [TradeDate] SMALLDATETIME NULL,
    [DeadLine] SMALLDATETIME NULL,
    [PAN] VARCHAR(20) NULL,
    [CaseID] VARCHAR(100) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [Age] VARCHAR(100) NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(100) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [RiskCategory] VARCHAR(100) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [MemberID] VARCHAR(50) NULL,
    [CurrentPeriod] SMALLDATETIME NULL,
    [CurrentTurnover] VARCHAR(100) NULL,
    [PreviousPeriod] VARCHAR(400) NULL,
    [PreviousTurnover] VARCHAR(100) NULL,
    [PercentIncrease] VARCHAR(100) NULL,
    [BuySell] CHAR(1) NULL,
    [InstrumentCode] VARCHAR(100) NULL,
    [ClientBuyValue] VARCHAR(100) NULL,
    [ClientSellValue] VARCHAR(100) NULL,
    [MemberBuyValue] VARCHAR(100) NULL,
    [MemberSellValue] VARCHAR(100) NULL,
    [Scrip] VARCHAR(400) NULL,
    [NSEGroup] VARCHAR(100) NULL,
    [Type] VARCHAR(50) NULL,
    [MemberBuyQuantity] VARCHAR(100) NULL,
    [MemberSellQuantity] VARCHAR(100) NULL,
    [GrossScripQuantity] VARCHAR(100) NULL,
    [MemberScripQuantity] VARCHAR(100) NULL,
    [PercentMemberConcentration] VARCHAR(100) NULL,
    [MemberScripPercent] VARCHAR(100) NULL,
    [Top5BuyValue] VARCHAR(100) NULL,
    [Top5SellValue] VARCHAR(100) NULL,
    [AggClientPercentage] VARCHAR(100) NULL,
    [PercentMarketConcentration] VARCHAR(100) NULL,
    [LimitPrice] VARCHAR(100) NULL,
    [OriginalVolume] VARCHAR(100) NULL,
    [VolumeDisclosed] VARCHAR(100) NULL,
    [LTPVariation] VARCHAR(100) NULL,
    [OrderNumber] VARCHAR(100) NULL,
    [UnderlyingPrice] VARCHAR(100) NULL,
    [OptionType] CHAR(10) NULL,
    [StrikePrice] VARCHAR(100) NULL,
    [ExpiryDate] SMALLDATETIME NULL,
    [TotalBuyQty] VARCHAR(100) NULL,
    [TotalSellQty] VARCHAR(100) NULL,
    [TotalSPoofQty] VARCHAR(100) NULL,
    [Profit] VARCHAR(100) NULL,
    [Part] VARCHAR(50) NULL,
    [TotalSelfQty] VARCHAR(100) NULL,
    [NSEtype] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PMLAUserLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PMLAUserLog]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [LoginUser] NVARCHAR(1000) NULL,
    [SPName] VARCHAR(50) NULL,
    [param1] VARCHAR(50) NULL,
    [param2] VARCHAR(50) NULL,
    [param3] VARCHAR(50) NULL,
    [ModifiedDate] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ShareHolder
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ShareHolder]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [DPID] VARCHAR(40) NULL,
    [ClientID] VARCHAR(40) NULL,
    [ClientName] VARCHAR(400) NULL,
    [PAN] VARCHAR(20) NULL,
    [ScripCode] VARCHAR(100) NULL,
    [ScripGroup] VARCHAR(20) NULL,
    [ISIN] VARCHAR(100) NULL,
    [ISINName] VARCHAR(1000) NULL,
    [HoldingQuantity] DECIMAL(18, 2) NULL,
    [TotMarketCapShares] DECIMAL(18, 2) NULL,
    [PercMarketCap] DECIMAL(18, 2) NULL,
    [AffiliatedAs] VARCHAR(100) NULL,
    [AffiliatedIsin] VARCHAR(100) NULL,
    [AffiliatedIsinName] VARCHAR(400) NULL,
    [ScripValue] DECIMAL(18, 2) NULL,
    [TotHoldingValue] DECIMAL(18, 2) NULL,
    [ScripPerTotHolding] DECIMAL(18, 2) NULL,
    [LastIncomeGroup] VARCHAR(400) NULL,
    [LastExactIncome] VARCHAR(400) NULL,
    [LastNetworth] VARCHAR(400) NULL,
    [Age] INT NULL,
    [Occupation] VARCHAR(100) NULL,
    [Mobile] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Address] VARCHAR(1000) NULL,
    [Risk] VARCHAR(50) NULL,
    [RecordStatus] CHAR(1) NULL DEFAULT 'A',
    [RecordAddedon] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Str_Category
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Str_Category]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Ctype] VARCHAR(50) NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_str_Client_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_str_Client_Master]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [BatchId] INT NULL,
    [CategoryId] INT NULL,
    [ClientCode] VARCHAR(5000) NULL,
    [ClientName] VARCHAR(MAX) NULL,
    [PanNo] VARCHAR(5000) NULL,
    [IsActive] BIT NULL,
    [InsertedOn] DATETIME NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_str_clientid
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_str_clientid]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [StrId] INT NULL,
    [ClientCode] VARCHAR(8) NULL,
    [IsActive] BIT NULL,
    [InsertedOn] DATETIME NULL,
    [UpdatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Str_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Str_Master]
(
    [Id] INT NOT NULL,
    [Strdate] SMALLDATETIME NULL,
    [CompanyName] VARCHAR(400) NULL,
    [GroundOfSuspicion] VARCHAR(MAX) NULL,
    [insertedBy] VARCHAR(20) NULL,
    [insertedOn] SMALLDATETIME NULL,
    [updatedBy] VARCHAR(20) NULL,
    [updatedOn] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Str_RENAMEDAS_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Str_RENAMEDAS_PII]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Strdate] DATETIME NULL,
    [PanNo] VARCHAR(10) NULL,
    [DpId] VARCHAR(15) NULL,
    [CompanyName] VARCHAR(25) NULL,
    [CategoryId] INT NULL,
    [BatchNumber] VARCHAR(25) NULL,
    [GroundOfSuspicion] VARCHAR(500) NULL,
    [insertedBy] VARCHAR(20) NULL,
    [insertedOn] DATETIME NULL,
    [updatedBy] VARCHAR(20) NULL,
    [updatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Synopsis
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Synopsis]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Code] NVARCHAR(100) NOT NULL,
    [Concern] NVARCHAR(1000) NOT NULL,
    [Finding] NVARCHAR(1000) NULL,
    [Actionable] NVARCHAR(1000) NULL,
    [DateModified] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TSSAlert
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TSSAlert]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [Networth] DECIMAL(18, 0) NULL,
    [Income] DECIMAL(18, 0) NULL,
    [Strength] DECIMAL(18, 0) NULL,
    [MoneyInOut] MONEY NULL,
    [ViolationAmt] DECIMAL(18, 2) NULL,
    [MinTransDate] SMALLDATETIME NULL,
    [MaxTransDate] SMALLDATETIME NULL,
    [NetworthDesc] VARCHAR(100) NULL,
    [IncomeDesc] VARCHAR(100) NULL,
    [MinTransDateString] SMALLDATETIME NULL,
    [MaxTransDateString] SMALLDATETIME NULL,
    [RunDateString] SMALLDATETIME NULL,
    [IsNBFClient] CHAR(1) NULL,
    [SanctionLimit] VARCHAR(100) NULL,
    [CaseID] VARCHAR(50) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [Age] INT NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(20) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(400) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [RuleID] INT NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [TSStype] VARCHAR(100) NULL,
    [RecordStatus] CHAR(1) NULL DEFAULT 'A'
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TSSAlert_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TSSAlert_temp]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientID] VARCHAR(40) NOT NULL,
    [ClientName] VARCHAR(400) NOT NULL,
    [Networth] VARCHAR(100) NULL,
    [Income] VARCHAR(100) NULL,
    [Strength] VARCHAR(100) NULL,
    [MoneyInOut] VARCHAR(100) NULL DEFAULT ((0)),
    [ViolationAmt] VARCHAR(100) NULL DEFAULT ((0)),
    [MinTransDate] SMALLDATETIME NULL,
    [MaxTransDate] SMALLDATETIME NULL,
    [NetworthDesc] VARCHAR(100) NULL,
    [IncomeDesc] VARCHAR(100) NULL,
    [MinTransDateString] SMALLDATETIME NULL,
    [MaxTransDateString] SMALLDATETIME NULL,
    [RunDateString] SMALLDATETIME NULL,
    [IsNBFClient] CHAR(1) NULL,
    [SanctionLimit] VARCHAR(100) NULL,
    [CaseID] VARCHAR(100) NULL,
    [ClientExplanation] VARCHAR(1000) NULL,
    [EmailSent] CHAR(1) NULL,
    [ExchangeInformed] CHAR(3) NULL,
    [ClosedDate] SMALLDATETIME NULL,
    [RegisterCaseID] VARCHAR(100) NULL,
    [Segment] VARCHAR(50) NULL,
    [Age] VARCHAR(100) NULL,
    [CustomRisk] VARCHAR(50) NULL,
    [LastestIncome] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Mobile] VARCHAR(100) NULL,
    [IntermediatoryCode] VARCHAR(100) NULL,
    [IntermediatoryName] VARCHAR(100) NULL,
    [TradeName] VARCHAR(400) NULL,
    [RiskCategory] VARCHAR(50) NULL,
    [CSC] VARCHAR(100) NULL,
    [Gender] CHAR(1) NULL,
    [RuleID] VARCHAR(100) NULL,
    [AddedBy] VARCHAR(10) NULL,
    [AddedOn] SMALLDATETIME NULL,
    [LastEditedBy] VARCHAR(10) NULL,
    [EditedOn] SMALLDATETIME NULL,
    [Comment] VARCHAR(1000) NULL,
    [Status] CHAR(10) NULL,
    [TSStype] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UserLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UserLog]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [LoginUser] NVARCHAR(1000) NULL,
    [SPName] VARCHAR(50) NULL,
    [Param1] VARCHAR(50) NULL,
    [Param2] VARCHAR(50) NULL,
    [Param3] VARCHAR(50) NULL,
    [ModifiedDate] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblSTRMasterDataDump
-- --------------------------------------------------
CREATE TABLE [dbo].[tblSTRMasterDataDump]
(
    [batchid] INT NULL,
    [companyname] VARCHAR(MAX) NULL,
    [category] VARCHAR(MAX) NULL,
    [clientcode] VARCHAR(MAX) NULL,
    [strdate] DATETIME NULL,
    [groundofsuspicion] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUser
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUser]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [userName] VARCHAR(100) NOT NULL,
    [userPassword] VARCHAR(400) NOT NULL,
    [isActive] CHAR(1) NOT NULL DEFAULT 'Y',
    [createdBy] VARCHAR(100) NULL,
    [createdDate] SMALLDATETIME NULL DEFAULT (getdate()),
    [modifiedDate] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMPSTRONE
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMPSTRONE]
(
    [Batch No#] FLOAT NULL,
    [Company] NVARCHAR(255) NULL,
    [Category] NVARCHAR(255) NULL,
    [Client Code] NVARCHAR(MAX) NULL,
    [F5] NVARCHAR(255) NULL,
    [Data With comma] NVARCHAR(MAX) NULL,
    [Date] DATETIME NULL,
    [Ground of Suspicion] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temptable
-- --------------------------------------------------
CREATE TABLE [dbo].[temptable]
(
    [spname] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Combine_Ledger_PayinPayout_history
-- --------------------------------------------------
  
  
  
CREATE VIEW [dbo].[Vw_Combine_Ledger_PayinPayout_history]        
  
AS  
  
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_Code='BSECM'   
from ANGELBSECM.account_ab.dbo.ledger  with (nolock)  
Where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())       
  
UNION ALL          
  
/*select *,Ledger='BSECM' from BSECM_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
union all  */        
  
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='NSECM'   
from ANGELNSECM.account.dbo.ledger with(nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())         
  
  
/*union all          
  
select *,Ledger='NSECM' from NSECM_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
*/        
  
  
union all          
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='NSEFO'   
from ANGELFO.accountfo.dbo.ledger with(nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
/*union all          
  
  
select *,Ledger='NSEFO' from NSEFo_pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
  
*/        
  
union all          
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='MCX'   
From Angelcommodity.accountmcdx.dbo.ledger with(nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
/*union all          
  
select *,Ledger='MCX' from MCX_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
*/        
  
  
union all          
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='NCDEX'   
from Angelcommodity.accountncdx.dbo.ledger with(nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
Union All  
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='MCD'   
from Angelcommodity.ACCOUNTMCDXCDS.dbo.ledger with (nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
/*union all          
  
select *,Ledger='NCDEX' from NCDEX_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
*/        
  
--union all          
  
--select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='MCD' from [172.31.16.30].ACCOUNTMCDXCDS.dbo.ledger with (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
-- select distinct vtyp from VW_COMBINE_LEDGER_PAYINPAYOUT   
  
/*union all          
select *,Ledger='MCD' from MCD_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
*/        
  
  
union all          
  
  
select vtyp,vno,edt,lno,acname,drcr,vamt,vdt,vno1,refno,balamt,NoDays,cdt,cltcode,BookType,EnteredBy,pdt,CheckedBy,actnodays,narration,Co_code='NSX'   
from ANGELFO.accountcurfo.dbo.ledger with (nolock)   
where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
  
/*union all          
  
select *,Ledger='NSX' from NSX_Pledger (nolock) where vtyp in(2,3) AND VDT < CONVERT(VARCHAR(11),GETDATE())          
  
  
*/

GO

