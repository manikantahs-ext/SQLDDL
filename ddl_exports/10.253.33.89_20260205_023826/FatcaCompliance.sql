-- DDL Export
-- Server: 10.253.33.89
-- Database: FatcaCompliance
-- Exported: 2026-02-05T02:38:44.573539

USE FatcaCompliance;
GO

-- --------------------------------------------------
-- FUNCTION dbo.random_password
-- --------------------------------------------------
  
    
--select dbo.random_password(8, '')      
CREATE Function [dbo].[random_password]                 
(                  
@len int = 8, --Length of the password to be generated                  
@password_type char(7) = 'simple'                   
--Default is to generate a simple password with lowecase letters.                   
--Pass anything other than 'simple' to generate a complex password.                   
--The complex password includes numbers, special characters, upper case and lower case letters                  
)           
Returns varchar(15)                 
AS                  
Begin          
              
                
DECLARE @password varchar(25), @type tinyint, @bitmap char(6)                  
SET @password=''                   
--SET @bitmap = '#$%^&~!'                   
--SET @bitmap = 'aeruoy'                   
----@bitmap contains all the vowels, which are a, e, i, o, u and y. These vowels are used to generate slightly readable/rememberable simple passwords                  
SET @bitmap = '1234567890'                   
    
IF @password_type <> 'simple'                 
begin                
  select @password = @password + SUBSTRING(@bitmap,CONVERT(int,ROUND(1 + (RandNum * (5)),0)),1) from Vw_RAND                 
  set @len = @len-1                
end                
SET @bitmap = 'aerouy'                   
--set @len =len(@password)                
                
WHILE @len > 0                  
BEGIN                  
 IF @password_type = 'simple' --Generating a simple password                  
 BEGIN                  
  IF (@len%2) = 0  --Appending a random vowel to @password                  
    select @password = @password + SUBSTRING(@bitmap,CONVERT(int,ROUND(1 + (RandNum * (5)),0)),1)   from Vw_RAND                       
  ELSE --Appending a random alphabet                  
    select @password = @password + CHAR(ROUND(97 + (RandNum * (25)),0))      from Vw_RAND                    
  END                  
 ELSE --Generating a complex password                  
  BEGIN                  
  select @type = 3--ROUND(1 + (RandNum * (3)),0)  from Vw_RAND                            
                  
   IF @type = 1 --Appending a random lower case alphabet to @password                  
    select @password = @password + CHAR(ROUND(97 + (RandNum * (25)),0))     from Vw_RAND                     
 ELSE IF @type = 2 --Appending a random upper case alphabet to @password                  
    select @password = @password + CHAR(ROUND(65 + (RandNum * (25)),0))     from Vw_RAND                    
 ELSE IF @type = 3 --Appending a random number between 0 and 9 to @password                  
    select @password = @password + CHAR(ROUND(48 + (RandNum * (9)),0))        from Vw_RAND                 
 ELSE IF @type = 4 --Appending a random special character to @password                  
--    below ascii code is off. replace with numeric code between 0 and 9              
--    SET @password = @password + CHAR(ROUND(33 + (RAND() * (13)),0))                 
    select @password = @password + CHAR(ROUND(48 + (RandNum * (9)),0))     from Vw_RAND                     
  END                  
  SET @len = @len - 1                  
END                  
                  
return @password --Here's the result                  
                  
END

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FATCA_CRS_Declaration
-- --------------------------------------------------
ALTER TABLE [dbo].[FATCA_CRS_Declaration] ADD CONSTRAINT [PK_FATCA_CRS_Declaration] PRIMARY KEY ([FATCAId])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_KYC_Client_Fatca_Compliance
-- --------------------------------------------------


Create PROCEDURE dbo.GET_KYC_Client_Fatca_Compliance  
  
  
AS  
begin  
		select * from [KYC_Client_Fatca_Compliance]  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_GetData
-- --------------------------------------------------
--Prc_GetData 'CountryID','','','','','','',''      
CREATE Procedure [dbo].[Prc_GetData]      
(      
@Filter1 varchar(20)='',      
@Filter2 varchar(20)='',      
@Filter3 varchar(20)='',      
@Filter4 varchar(20)='',      
@Filter5 varchar(20)='',      
@Filter6 varchar(20)='',      
@Filter7 varchar(20)='',      
@Filter8 varchar(20)=''      
)      
As      
Begin      
if(@Filter1='CountryID')      
Begin      
IF OBJECT_ID('tempdb..#tbl_Country') IS NOT NULL    
DROP TABLE #tbl_Country    
    
select upper(Description) as Description,CountryID as StateCode into #tbl_Country from ABVSKYCMIS.Kyc_ci.dbo.vw_Country with(nolock)  where description ='Usa'    
insert into #tbl_Country     
select a.Description,a.StateCode  from (select Description,CountryID as StateCode from ABVSKYCMIS.Kyc_ci.dbo.vw_Country with(nolock)  where description <>'Usa'  )a order by a.Description    
    
select * from #tbl_Country     
End      
if(@Filter2='SourceWealth')      
Begin      
select Wealth_Name,Wealth_No as StateCode from SourceOfWealth_Master  with(nolock)    
End      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_InsErrLog
-- --------------------------------------------------
Create Procedure Prc_InsErrLog
@Errdesc varchar(max),
@Functionname varchar(50),
@Pagename varchar(50),
@CreatedBy varchar(50)
As
Begin
insert into tbl_Errorlog
(Err_desc,Function_Name,PageName,CreatedBy,CreatedDT)
values
(@Errdesc,@Functionname,@Pagename,@CreatedBy,getdate())
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.prc_ValidClient
-- --------------------------------------------------
CREATE Procedure [dbo].[prc_ValidClient]              
@Client_code varchar(10)=null,              
@Pancard varchar(20)=null              
As              
Begin              
if(isnull(@Client_code,'')<>'' and isnull(@Pancard,'')='')              
Begin              
select   c.Party_code,Mobile_pager,Email,case when isnull(k.party_code,'')<>'' then 'Y' else 'N' end IsFatcaDeclare,case when c.Last_inactive_date<=getdate() then 'InActive' else 'Active' end as [Status] from risk.dbo.client_details c with(nolock) left join ABVSKYCMIS.kyc_ci.dbo.[KYC_Client_Fatca_Compliance] k with(nolock) on c.party_code=k.party_code where c.party_code=@Client_code   and c.first_active_date>='01 Jul 2014'  and cl_status='IND'    
End              
if(isnull(@Pancard,'')<>'' and isnull(@Client_code,'')='')              
Begin              
select  c.Party_code,Mobile_pager,Email,case when isnull(k.party_code,'')<>'' then 'Y' else 'N' end IsFatcaDeclare,case when c.Last_inactive_date<=getdate() then 'InActive' else 'Active' end as [Status]   from risk.dbo.client_details c with(nolock) left join ABVSKYCMIS.kyc_ci.dbo.[KYC_Client_Fatca_Compliance] k with(nolock) on c.party_code=k.party_code where c.pan_gir_no=@Pancard          and c.first_active_date>='01 Jul 2014' and cl_status='IND'            
--select top 1 '9702292512' as Mobile_pager,Email from intranet.risk.dbo.client_details where pan_gir_no=@Pancard              
End              
if(isnull(@Client_code,'')<>'' and isnull(@Pancard,'')<>'')              
Begin              
select   c.Party_code,Mobile_pager,Email,case when isnull(k.party_code,'')<>'' then 'Y' else 'N' end IsFatcaDeclare,case when c.Last_inactive_date<=getdate() then 'InActive' else 'Active' end as [Status]   from risk.dbo.client_details c with(nolock) left 
join ABVSKYCMIS.kyc_ci.dbo.[KYC_Client_Fatca_Compliance] k with(nolock) on c.party_code=k.party_code where c.party_code=@Client_code    and c.pan_gir_no=@Pancard          and c.first_active_date>='01 Jul 2014'        and cl_status='IND'    
--select '9702292512' as Mobile_pager,Email from intranet.risk.dbo.client_details where party_code=@Client_code and pan_gir_no=@Pancard              
End              
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_KYC_Client_Fatca_Compliance
-- --------------------------------------------------
              
              
CREATE PROCEDURE [dbo].[SP_KYC_Client_Fatca_Compliance]              
   (              
 @Client_code varchar(50),            
 @Is_US_Person varchar(50),            
 @TaxResidency int,            
 @CitizenCountry int,            
 @TaxIdentificationNo varchar(100),            
 @SourceWealth varchar(500),           
 @BirthCountry int,        
 @BirthCity varchar(100),        
 @BirthZip  varchar(15),        
 @SourceWealthOther varchar(50),      
 @CreatedBy varchar(50),            
 @IpAddress varchar(50),            
 @IpDnsName varchar(50)            
 )              
AS              
begin              
  
  
  
if not exists (select  * from [KYC_Client_Fatca_Compliance] with(nolock)where party_code=@Client_code)  
Begin   
set @SourceWealth=replace(replace(@SourceWealth,'[',''),']','')            
            
            
INSERT INTO [KYC_Client_Fatca_Compliance]              
           ([Party_code] ,             
           [Is_US_Person]              
           ,[TaxResidencyCountry_ID]              
           ,[CitizenCountry_ID]              
           ,[TaxIdentificationNo]              
           ,[SourceofWealth]              
           ,[CreatedBy]              
           ,[CreateDate]              
           ,[Ip_Address]            
           ,[Ip_DnsName]            
           --,[UpdatedBy]              
           --,[UpdateDate]              
           --,[Ip_Address]              
           ,[BirthCountry_ID]              
           ,[BirthCity]              
           ,[BirthPinCode]       
           ,[SourceWealthOther]           
           )              
     VALUES              
           (              
           @Client_code,              
           --'rp61' ,            
           @Is_US_Person              
           ,@TaxResidency              
           ,@CitizenCountry              
           ,@TaxIdentificationNo              
           ,@SourceWealth              
           ,@CreatedBy              
           ,GETDATE()            
           ,@IpAddress            
           ,@IpDnsName              
           --,@UpdatedBy              
           --,@UpdateDate              
           --,@Ip_Address              
           ,@BirthCountry              
           ,@BirthCity              
           ,@BirthZip        
           ,@SourceWealthOther      
           )              
                     
exec ABVSKYCMIS.KYC_CI.dbo.[SPX_Update_KYC_Client_Fatca_Compliance]   @Client_code,@Is_US_Person,@TaxResidency,@CitizenCountry,@TaxIdentificationNo,@SourceWealth,@BirthCountry,@BirthCity,@BirthZip,'Inhouse'                   
--exec KYC_CI.dbo.SPX_Update_KYC_Client_Fatca_Compliance @Client_code,@Is_US_Person,@TaxResidency,@CitizenCountry,@TaxIdentificationNo,@SourceWealth,@BirthCountry,@BirthCity,@BirthZip,'Inhouse'                   
  
End  
            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_KYC_Client_Fatca_Compliance_06May2016
-- --------------------------------------------------
  
  
CREATE PROCEDURE dbo.SP_KYC_Client_Fatca_Compliance_06May2016  
   (  
 @Party_code varchar(50) ,  
 @Is_US_Person bit =NULL,  
 @TaxResidencyCountry_ID int =NULL,  
 @CitizenCountry_ID int =NULL,  
 @TaxIdentificationNo varchar(100)= NULL,  
 @SourceofWealth varchar(500) =NULL,  
 @CreatedBy varchar(50) ,  
 @CreateDate datetime ,  
 @UpdatedBy varchar(50) ,  
 @UpdateDate datetime =NULL,  
 @Ip_Address nvarchar(50)= NULL,  
 @BirthCountry_ID int =NULL,  
 @BirthCity varchar(100)= NULL,  
 @BirthPinCode varchar(15)= NULL  
 )  
AS  
begin  
INSERT INTO [KYC_Client_Fatca_Compliance]  
           ([Party_code]  
           ,[Is_US_Person]  
           ,[TaxResidencyCountry_ID]  
           ,[CitizenCountry_ID]  
           ,[TaxIdentificationNo]  
           ,[SourceofWealth]  
           ,[CreatedBy]  
           ,[CreateDate]  
           ,[UpdatedBy]  
           ,[UpdateDate]  
           ,[Ip_Address]  
           ,[BirthCountry_ID]  
           ,[BirthCity]  
           ,[BirthPinCode])  
     VALUES  
           (  
            @Party_code  
           ,@Is_US_Person  
           ,@TaxResidencyCountry_ID  
           ,@CitizenCountry_ID  
           ,@TaxIdentificationNo  
           ,@SourceofWealth  
           ,@CreatedBy  
           ,GETDATE()  
           ,@UpdatedBy  
           ,@UpdateDate  
           ,@Ip_Address  
           ,@BirthCountry_ID  
           ,@BirthCity  
           ,@BirthPinCode  
           )  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Fatca_OTPSTATUS
-- --------------------------------------------------
CREATE PROC [dbo].[USP_Fatca_OTPSTATUS]           
@Client_Code varchar(20)='',        
@PanCard varchar(20)='',           
@MOBILE_NO VARCHAR(20)='',              
@MOB_MESSAGE VARCHAR(MAX)='',              
@DATE VARCHAR(15)='',              
@TM VARCHAR(15)='',              
@FLAG VARCHAR(10)='',              
@AP VARCHAR(15)='',              
@PURPOSE VARCHAR(200)='',              
@Status VARCHAR(200)='',        
@OTPNo varchar(10)=''              
AS BEGIN              
        
DECLARE  @ClientName varchar(100) , @Email varchar(100)        
 SELECT top 1 @ClientName=Long_name,@Email=rtrim(ltrim(isnull(Email,'')))                                          
  --FROM RISK.DBO.CLIENT_DETAILS                                          
  FROM risk.dbo.client_details WITH (NOLOCK)                     
  WHERE PARTY_CODE = @Client_Code        
        
--Sending Mail To Client        
if(@Email<>'')
Begin
declare @msgbody Nvarchar(MAX)                                            
set @msgbody='Dear ' + @Client_Code + ',' + @ClientName + '<br><br>'        
set @msgbody=@msgbody+ 'Your OTP(one time password) for FATCA/CRS Declaration is '+@OTPNo+'.Please enter this code in the<br>'        
set @msgbody=@msgbody+ 'OTP Code box Listed on the page.<br><br>'        
set @msgbody=@msgbody+ 'Note: This OTP will be valid only for 1 Hour.'    
    
        
EXEC intranet.msdb.dbo.sp_send_dbmail                                           
@profile_name = 'FATCA',                                                             
@recipients= @Email,                                    
--@recipients=  'Nimesh.Sanghvi@gmmail.com',                                    
--@recipients=  'nirav.shah@angelbroking.com',                                                                        
--@recipients=  'sandeep.rai@angelbroking.com',                                    
@body = @msgbody,                                               
--@file_attachments=@strAttach,                                    
@body_format = 'HTML',                                                                 
@subject = 'FATCA/CRS Declaration'         

End        
--Insert into Log whose email and Sms Successfully Send              
if(@MOBILE_NO<>'')
Begin
INSERT INTO Fatca_SMS_LOG (MOBILE_NO ,MOB_MESSAGE,DATE,TM,FLAG,AP,PURPOSE,Status)              
VALUES(@MOBILE_NO ,@MOB_MESSAGE,cast (cast (getdate() as varchar(25)) as date), REPLACE(SUBSTRING(CONVERT(VARCHAR, GETDATE(), 9), 13, 5), '', ''),@FLAG,RIGHT(CONVERT(VARCHAR, GETDATE(), 100), 2),@PURPOSE,@Status)                     
        
insert into FATCA_CRS_Declaration(PanNo,ClientCode,MobileNo,Mob_Message,OTP_Status,OPT_No,Created_By,Created_Date)        
VALUES(@PanCard,@Client_Code,@MOBILE_NO ,@MOB_MESSAGE,@Status,@OTPNo,@Client_Code,getdate())        
End
        
        
--select top 1 *  from Fatca_SMS_LOG        
--select * from FATCA_CRS_Declaration        
        
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Fatca_ValidateOTP
-- --------------------------------------------------
/***********************************************************************************                                            
CREATED BY ::                                            
CREATED DATE ::                                            
PURPOSE ::                                            
                                            
MODIFIED BY ::                                            
MODIFIED DATE ::                                            
REASON ::                                            
***********************************************************************************/                                            
            
--[usp_Fatca_ValidateOTP] 'rp61','O','0'            
CREATE PROC [dbo].[usp_Fatca_ValidateOTP]                                            
@ClientCode AS VARCHAR(50),            
@OTPFlag VARCHAR(5),                                        
@Mode INT                                            
AS                                            
BEGIN                                            
                                            
 IF @Mode = 0                                            
 BEGIN                                            
  DECLARE @PASSWORD AS VARCHAR(50),                                            
  @MOBILE_NO AS VARCHAR(11),                                            
  @COUNT AS INT,                                            
  @MOB_MESSAGE AS VARCHAR(MAX),            
  @ClientName varchar(100) ,          
  @Pancard varchar(20) ,          
  @Email varchar(50)          
                                          
  --SELECT top 1 @MOBILE_NO = rtrim(ltrim(isnull(mobile_pager,''))),@ClientName=Long_name,@Pancard=pan_gir_no,@Email=isnull(Email,'')                                            
  SELECT top 1 @MOBILE_NO = rtrim(ltrim(isnull(mobile_pager,''))),@ClientName=Long_name,@Pancard=pan_gir_no,@Email=isnull(Email,'')                                            
  --FROM  RISK.DBO.CLIENT_DETAILS                                            
  FROM risk.dbo.client_details WITH (NOLOCK)                       
  WHERE PARTY_CODE = @ClientCode                                            
                                            
  SELECT @PASSWORD = DBO.RANDOM_PASSWORD(4, '')                                            
                                            
  UPDATE Fatca_GENOTPDETAILS SET FLAG = 1                                            
  WHERE PARTY_CODE = @ClientCode AND FLAG= 0                                            
  --AND CONVERT(VARCHAR(11), TDATE) = CONVERT(VARCHAR(11), GETDATE())                                            
                                    
                                            
  INSERT INTO Fatca_GENOTPDETAILS                                            
  VALUES (@ClientCode, @MOBILE_NO, @PASSWORD, GETDATE(), 0)                                                                    
              
                                            
  /***************************** SEND SMS ********************************************/                                            
                                            
  CREATE TABLE #SMS                                            
  (                                
  Client_Code varchar(20),          
  PanCard varchar(20),                      
  MOBILE_NO VARCHAR(15),                                              
  MOB_MESSAGE VARCHAR (MAX),                                            
  DATE VARCHAR(50),                                            
  TM VARCHAR(15),                                            
  FLAG VARCHAR(2),                                            
  AP VARCHAR(2),                                            
  PURPOSE VARCHAR(200),          
  OTPNo varchar(10),    
  Email varchar(50)                                          
  )                                            
                                          
  IF (@OTPFlag = 'O')                                        
  BEGIN                                        
 --SET @MOB_MESSAGE='DEAR SIR, YOUR PDA PASSOWRD IS: ' + @PASSWORD + 'USE THIS FOR FURTHER TRANSACTION'                                            
 --SET @MOB_MESSAGE='Dear ' + @ClientCode + ', your One Time Password for Online/Mobile Trading registration is ' + @PASSWORD + ', please enter this in PDA to complete the registration process.'                                        
  --SET @MOB_MESSAGE='Dear ' + @ClientCode + ',' + @ClientName + ' your One Time Password for FATCA/CRS Declaration is ' + @PASSWORD + ', please enter this code in the OTP box listed on the page.'                                        
  SET @MOB_MESSAGE= 'Your one time password (OTP) is '+@PASSWORD+' for FATCA/CRS Declaration.' + CHAR(13) + ' Note: This OTP will be valid for 1 Hour'                                        
  END                                        
             
                                            
  INSERT INTO #SMS                                   
  VALUES (@ClientCode,@Pancard,@MOBILE_NO, @MOB_MESSAGE, CONVERT(VARCHAR(11), GETDATE(), 103),                                            
  --REPLACE(SUBSTRING(CONVERT(VARCHAR, DATEADD(MI, -5, GETDATE()), 9), 13, 5), '', ''),                                            
  REPLACE(SUBSTRING(CONVERT(VARCHAR, GETDATE(), 9), 13, 5), '', ''),                                            
  'P', RIGHT(CONVERT(VARCHAR, GETDATE(), 100), 2),                                            
  'Fatca OTP',@PASSWORD,@Email)                                            
/*                                          
  INSERT INTO  SMS.DBO.SMS                                            
  SELECT * FROM #SMS                                            
*/               
              
---Commenetd by Pramod--Start                                          
  --INSERT INTO PDA_SMS_LOG SELECT * FROM #SMS                                            
                                    
  --INSERT INTO [10.40.40.29].PDA4.DBO.PDA_SMS_LOG SELECT * FROM #SMS                   
                
  ---Commneted by pramod--End              
                
  select * from #SMS                                       
                                      
 END                                            
ELSE IF @MODE = 1                                            
 BEGIN                                            
  SELECT *,datediff(minute,tdate,getdate()) as Validity  FROM Fatca_GENOTPDETAILS WITH (NOLOCK)                                             
  WHERE PARTY_CODE = @ClientCode AND FLAG = 0                                             
  AND CONVERT(VARCHAR(11), TDATE) = CONVERT(VARCHAR(11), GETDATE()) --and datediff(minute,tdate,getdate()) <=60             
 END                                           
                      
END

GO

-- --------------------------------------------------
-- TABLE dbo.FATCA_CRS_Declaration
-- --------------------------------------------------
CREATE TABLE [dbo].[FATCA_CRS_Declaration]
(
    [FATCAId] BIGINT IDENTITY(1,1) NOT NULL,
    [PanNo] NVARCHAR(50) NULL,
    [ClientCode] NVARCHAR(50) NULL,
    [MobileNo] VARCHAR(10) NULL,
    [Mob_Message] VARCHAR(200) NULL,
    [OTP_Status] VARCHAR(200) NULL,
    [OPT_No] NVARCHAR(50) NULL,
    [Created_By] NVARCHAR(50) NULL,
    [Created_Date] DATETIME NULL,
    [UpdatedBy] NVARCHAR(50) NULL,
    [UpdatedDate] DATETIME NULL,
    [IP_Address] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fatca_GENOTPDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[Fatca_GENOTPDETAILS]
(
    [PARTY_CODE] VARCHAR(50) NULL,
    [MOBILE_NO] VARCHAR(15) NULL,
    [PASSWORD] VARCHAR(15) NULL,
    [tdate] DATETIME NULL,
    [flag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fatca_SMS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[Fatca_SMS_LOG]
(
    [MSGID] INT IDENTITY(1,1) NOT NULL,
    [MOBILE_NO] VARCHAR(20) NULL,
    [MOB_MESSAGE] VARCHAR(MAX) NULL,
    [DATE] DATE NULL,
    [TM] VARCHAR(15) NULL,
    [FLAG] VARCHAR(10) NULL,
    [AP] VARCHAR(15) NULL,
    [PURPOSE] VARCHAR(200) NULL,
    [Status] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KYC_Client_Fatca_Compliance
-- --------------------------------------------------
CREATE TABLE [dbo].[KYC_Client_Fatca_Compliance]
(
    [Party_code] VARCHAR(50) NOT NULL,
    [Is_US_Person] BIT NULL,
    [TaxResidencyCountry_ID] INT NULL,
    [CitizenCountry_ID] INT NULL,
    [TaxIdentificationNo] VARCHAR(100) NULL,
    [SourceofWealth] VARCHAR(500) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [CreateDate] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [UpdateDate] DATETIME NULL,
    [Ip_Address] NVARCHAR(50) NULL,
    [Ip_DnsName] VARCHAR(50) NULL,
    [BirthCountry_ID] INT NULL,
    [BirthCity] VARCHAR(100) NULL,
    [BirthPinCode] VARCHAR(15) NULL,
    [SourceWealthOther] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SourceOfWealth_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[SourceOfWealth_Master]
(
    [Wealth_No] NVARCHAR(50) NULL,
    [Wealth_Name] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ErrorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ErrorLog]
(
    [RecID] INT IDENTITY(1,1) NOT NULL,
    [Err_Desc] VARCHAR(MAX) NULL,
    [Function_Name] VARCHAR(50) NULL,
    [PageName] VARCHAR(50) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [CreatedDT] DATETIME NULL,
    [UpdatedBy] VARCHAR(50) NULL,
    [UpdatedDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_RAND
-- --------------------------------------------------
  
CREATE View [dbo].[Vw_RAND]      
as      
select RandNum=RAND()

GO

