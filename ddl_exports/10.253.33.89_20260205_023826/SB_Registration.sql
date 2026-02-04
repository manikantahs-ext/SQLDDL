-- DDL Export
-- Server: 10.253.33.89
-- Database: SB_Registration
-- Exported: 2026-02-05T02:39:26.736179

USE SB_Registration;
GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_CheckNames
-- --------------------------------------------------
-- =============================================
-- Author:		<Author,SHEKHAR G>
-- Create date: <Create Date,8-Jun-2017>
-- Description:	<Description,To check Names matching REPLICA FROM ANGELWEBDB>
-- =============================================
CREATE FUNCTION [dbo].[Fn_CheckNames]
(
	@First_Name VARCHAR(150),
	@Middle_Name VARCHAR(150),
	@Last_Name VARCHAR(150),
	@First_Name1 VARCHAR(150),
	@Middle_Name1 VARCHAR(150),
	@Last_Name1 VARCHAR(150)
)
RETURNS Bit
AS
BEGIN
	Declare @Result bit
	Declare @Result_FirstName Int,@Result_MiddleName Int,@Result_LastName Int
	Set @Result=1
	
	
	If len(ISNULL(@First_Name,''))>0 And @First_Name in(ISNULL(@First_Name1,''),ISNULL(@Middle_Name1,''),ISNULL(@Last_Name1,''))
		Begin
			Set @Result_FirstName=1
		End
	Else
		Begin
			Set @Result_FirstName=0
		End
	
	
	If len(ISNULL(@Last_Name,''))>0 And @Last_Name in(ISNULL(@First_Name1,''),ISNULL(@Middle_Name1,''),ISNULL(@Last_Name1,''))
		Begin
			Set @Result_LastName=1
		End
	Else
		Begin
			Set @Result_LastName=0
		End
		
	If @Result_FirstName=1 And @Result_LastName=1
		Begin
			Set @Result=1
		End
	Else If @Result_FirstName=1 And ISNULL(@Last_Name,'')='' And ISNULL(@Last_Name1,'')=''
		Begin
			Set @Result=1
		End
	Else
		Begin
			Set @Result=0
		End
		
	--,@MiddleCheck bit
	--Set @Result=1
	
	
	--Set @MiddleCheck=1
	
	--If (len(@Middle_Name)>0 And len(@Middle_Name1)>0)
	--	Begin
	--		If isnull(@Middle_Name,'')!='' And isnull(@Middle_Name1,'')!=''
	--			Begin
	--				If substring(@Middle_Name,1,1)!=substring(@Middle_Name1,1,1)
	--					Begin
	--						Set @MiddleCheck=0
	--					End
	--			End
	--		Else
	--			Begin
	--				Set @MiddleCheck=0
	--			End
	--	End
		
	--If (@MiddleCheck=0) Or Not(
	--							(@First_Name=@First_Name1 And @Last_Name=@Last_Name1) 
	--								Or
	--							(@First_Name=@Last_Name1 And @Last_Name=@First_Name1)
	--						  )
	--	Begin
	--		Set @Result=0

	--	End 
							
	Return @Result
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_LPAD_LEADING_ZERO
-- --------------------------------------------------
  
CREATE FUNCTION [dbo].[FN_LPAD_LEADING_ZERO](@Lenght int,@String varchar(Max))   
RETURNS Varchar(Max)   
AS  
Begin  
      Declare @LPAD_STRING as varchar(Max)   
      Select @LPAD_STRING =(Case When Len(@String)<=@Lenght THEN  
      Stuff(SPACE(@Lenght -Len(@String))+@String,1, @Lenght -Len(@String),Replicate(0,@Lenght -Len(@String)))  
      ELSE @String END)  
      Return @LPAD_STRING   
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_Split_Name_3part
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 19th Sept 2020
-- Description:	Split name in three part
-- =============================================
CREATE FUNCTION [dbo].[Fn_Split_Name_3part] (@string NVARCHAR(MAX), @delimiter CHAR(1))
RETURNS @output TABLE (First_Name VARCHAR(150), Middle_Name VARCHAR(150), Last_Name VARCHAR(150))
AS
BEGIN
	DECLARE @start INT, @end INT
	DECLARE @First_Name VARCHAR(150)
	DECLARE @Last_Name VARCHAR(150)
	DECLARE @Middle_Name VARCHAR(150)
	SET @start = 1
	SET @end = CHARINDEX(@delimiter, @string)
	IF @end = 0
		BEGIN
			SET @First_Name = SUBSTRING(@string, @start,LEN(@string))
			insert into @output values(@First_Name,null,null)
			return
		END
	SET @First_Name = SUBSTRING(@string, @start, @end - @start)
	SET @start = @end + 1
	SET @end = CHARINDEX(@delimiter, @string, @start)
	IF @end = 0
		BEGIN
			SET @Middle_Name = SUBSTRING(@string, @start, LEN(@string)-LEN(@First_Name))
			insert into @output values(@First_Name,null,@Middle_Name)
			RETURN
		END
	SET @Middle_Name = SUBSTRING(@string, @start, @end - @start)
	SET @start = @end + 1
	SET @end = CHARINDEX(@delimiter, @string, @start)
	SET @Last_Name = SUBSTRING(@string, @start,LEN(@string)-LEN(@First_Name)-LEN(@Middle_Name))
	insert into @output values(@First_Name,@Middle_Name,@Last_Name)
	RETURN
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.SplitString
-- --------------------------------------------------
CREATE FUNCTION SplitString  
(      
      @Input NVARCHAR(MAX),  
      @Character CHAR(1)  
)  
RETURNS @Output TABLE (  
      Item NVARCHAR(1000)  
)  
AS  
BEGIN  
      DECLARE @StartIndex INT, @EndIndex INT  
   
      SET @StartIndex = 1  
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character  
      BEGIN  
            SET @Input = @Input + @Character  
      END  
   
      WHILE CHARINDEX(@Character, @Input) > 0  
      BEGIN  
            SET @EndIndex = CHARINDEX(@Character, @Input)  
             
            INSERT INTO @Output(Item)  
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)  
             
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))  
      END  
   
      RETURN  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.UDP_GETSBTAG
-- --------------------------------------------------



CREATE FUNCTION [dbo].[UDP_GETSBTAG] (@ENTRYID AS INT )  
RETURNS VARCHAR(50)  
AS BEGIN  
DECLARE @RANDOMID VARCHAR(32)    
DECLARE @COUNTER SMALLINT    
DECLARE @RANDOMNUMBER FLOAT    
DECLARE @RANDOMNUMBERINT TINYINT    
DECLARE @CURRENTCHARACTER VARCHAR(1)    
DECLARE @VALIDCHARACTERS VARCHAR(255)    
SET @VALIDCHARACTERS  = (SELECT LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(RIGHT(TRADENAME,(LEN(TRADENAME)-(CHARINDEX('.', TRADENAME)))),'/',''),'&',''),' ',''),'(',''),')',''),'.',''),10) AS APRNAME FROM TBL_BASICDETAILS WHERE CAST ( ENTRYID AS
 VARCHAR(50)) = @ENTRYID)          
              
    
DECLARE @VALIDCHARACTERSLENGTH INT    
SET @VALIDCHARACTERSLENGTH = LEN(@VALIDCHARACTERS)    
SET @CURRENTCHARACTER = ''    
SET @RANDOMNUMBER = 0    
SET @RANDOMNUMBERINT = 0    
SET @RANDOMID = ''    
    
  
    
SET @COUNTER = 1    
    
WHILE @COUNTER < (3)    
    
BEGIN    
    
         SELECT @RANDOMNUMBER=VALUE FROM VW_GETRANDVALUE   
  
        SET @RANDOMNUMBERINT = CONVERT(TINYINT, ((@VALIDCHARACTERSLENGTH - 1) * @RANDOMNUMBER + 1))    
    
        SELECT @CURRENTCHARACTER = SUBSTRING(@VALIDCHARACTERS, @RANDOMNUMBERINT, 1)    
    
        SET @COUNTER = @COUNTER + 1    
    
        SET @RANDOMID = @RANDOMID + @CURRENTCHARACTER    
  SET @RANDOMID = LEFT(@VALIDCHARACTERS,1)+@RANDOMID     
  
  
IF EXISTS (SELECT TOP 1 * FROM [MIS].SB_COMP.DBO.[SB_BROKER] WHERE SBTAG=@RANDOMID)              
BEGIN    
  
SELECT @RANDOMID= DBO.UDP_GETSBTAG (CAST ( @ENTRYID AS INT))   
END    
  
    
END    
RETURN @RANDOMID  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.UDP_SENDMOB_NOTIFICATION_CALL
-- --------------------------------------------------
CREATE FUNCTION [dbo].[UDP_SENDMOB_NOTIFICATION_CALL](@ID AS VARCHAR(MAX),@TITLE AS VARCHAR(200),@BODYMSG AS VARCHAR(500))
 RETURNS INT
 AS BEGIN
 DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);
DECLARE @Body AS VARCHAR(8000) = 
'{
  "to" : "'+@ID+'",
   "data" : {
     "object" : {
     	"notificationType":"call",          
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

 RETURN 0
 END

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_MF_IDENTITYDETAILS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_TBL_MF_IDENTITYDETAILS_SBTag] ON [dbo].[TBL_MF_IDENTITYDETAILS] ([SBTag])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ChatUsers
-- --------------------------------------------------
ALTER TABLE [dbo].[ChatUsers] ADD CONSTRAINT [PK__ChatUser__3213E83FC25AFD4E] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DiyKyc_KRAResponse
-- --------------------------------------------------
ALTER TABLE [dbo].[DiyKyc_KRAResponse] ADD CONSTRAINT [PK_KRAResponse] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SB_broker
-- --------------------------------------------------
ALTER TABLE [dbo].[SB_broker] ADD CONSTRAINT [PK__SB_broke__3214EC271FE657FF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ADDRESS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ADDRESS] ADD CONSTRAINT [PK_TBL_ADDRESS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_AGREEDDEPOSITS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_AGREEDDEPOSITS] ADD CONSTRAINT [PK_TBL_AGREEDDEPOSITS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_APPLICATIONSTATUSMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_APPLICATIONSTATUSMASTER] ADD CONSTRAINT [PK__TBL_APPL__3214EC2759FA5E80] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_BANKDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_BANKDETAILS] ADD CONSTRAINT [PK_TBL_BANKDETAILS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_BASICDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_BASICDETAILS] ADD CONSTRAINT [PK_TBL_BASICDETAILS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CASHDEPOSITS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CASHDEPOSITS] ADD CONSTRAINT [PK_TBL_CASHDEPOSITS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ChatHistroy
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ChatHistroy] ADD CONSTRAINT [PK__tbl_Chat__3214EC2761392C57] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_CONTRACTOR_SIGN
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_CONTRACTOR_SIGN] ADD CONSTRAINT [PK_TBL_CONTRACTOR_SIGN] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_DOCUMENTSUPLOAD
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_DOCUMENTSUPLOAD] ADD CONSTRAINT [PK_TBL_DOCUMENTSUPLOAD] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_DOCUMENTSUPLOAD_PDF
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_DOCUMENTSUPLOAD_PDF] ADD CONSTRAINT [PK_TBL_DOCUMENTSUPLOAD_PDF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_DOCUMENTSUPLOADFINAL_PDF
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] ADD CONSTRAINT [PK_TBL_DOCUMENTSUPLOADFINAL_PDF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_EsignDocNumber
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_EsignDocNumber] ADD CONSTRAINT [PK__TBL_Esig__3213E83F6E01572D] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_ESIGNDOCUMENTS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_ESIGNDOCUMENTS] ADD CONSTRAINT [PK_TBL_ESIGNDOCUMENTS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Exception_log
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Exception_log] ADD CONSTRAINT [PK_tbl_Exception_log] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_IDENTITYDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_IDENTITYDETAILS] ADD CONSTRAINT [PK_TBL_IDENTITYDETAILS] PRIMARY KEY ([ENTRYID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_INFRASTRUCTURE
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_INFRASTRUCTURE] ADD CONSTRAINT [PK_TBL_INFRASTRUCTURE_1] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Menudetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Menudetails] ADD CONSTRAINT [PK__tbl_Menu__3214EC27B265FFAF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ADDRESS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ADDRESS] ADD CONSTRAINT [PK_TBL__MF_ADDRESS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ADDRESS_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ADDRESS_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_A__3214EC27B7ADA2FB] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_Applicationlog
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_Applicationlog] ADD CONSTRAINT [PK__TBL_MF_A__3213E83FCB48C200] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ARNDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ARNDetails] ADD CONSTRAINT [PK__TBL_MF_A__3214EC27BFC7B6EB] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ARNDetails_Archival
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ARNDetails_Archival] ADD CONSTRAINT [PK__TBL_MF_A__3214EC2742EA8979] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_BANKDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_BANKDETAILS] ADD CONSTRAINT [PK_TBL_MF_BANKDETAILS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_BANKDETAILS_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_BANKDETAILS_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_B__3214EC27A63A947C] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_BASICDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_BASICDETAILS] ADD CONSTRAINT [PK__TBL_MF_B__3214EC27D130A00C] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_BASICDETAILS_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_BASICDETAILS_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_B__3214EC275ACCAE0A] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_DOCUMENTSUPLOAD
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD] ADD CONSTRAINT [PK_TBL_MF_DOCUMENTSUPLOAD] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_DOCUMENTSUPLOAD_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_D__3214EC27BFDEAFCB] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_DOCUMENTSUPLOAD_PDF
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF] ADD CONSTRAINT [PK_TBL_MF_DOCUMENTSUPLOAD_PDF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_DOCUMENTSUPLOAD_PDF_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_D__3214EC27503947B7] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_DOCUMENTSUPLOADFINAL_PDF
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] ADD CONSTRAINT [PK_TBL_MF_DOCUMENTSUPLOADFINAL_PDF] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ESIGNDOCUMENTS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ESIGNDOCUMENTS] ADD CONSTRAINT [PK_TBL_MF_ESIGNDOCUMENTS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_ESIGNDOCUMENTS_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_ESIGNDOCUMENTS_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_E__3214EC271ABC1A4A] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_IDENTITYDETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_IDENTITYDETAILS] ADD CONSTRAINT [PK__TBL_MF_I__83A4CBD3E8EAD5C2] PRIMARY KEY ([ENTRYID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_IDENTITYDETAILS_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_IDENTITYDETAILS_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_I__3214EC27130DFC9B] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_INFRASTRUCTURE
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_INFRASTRUCTURE] ADD CONSTRAINT [PK_TBL_MF_INFRASTRUCTURE_1] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_INFRASTRUCTURE_ARCHIVAL
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_INFRASTRUCTURE_ARCHIVAL] ADD CONSTRAINT [PK__TBL_MF_I__3214EC273F0180DB] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_NomineeDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_NomineeDetails] ADD CONSTRAINT [PK__TBL_MF_N__40B5EA361DB06A4F] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_NomineeDetails_Archival
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_NomineeDetails_Archival] ADD CONSTRAINT [PK__TBL_MF_N__3214EC277CAD6514] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_PaymentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_PaymentDetails] ADD CONSTRAINT [PK__TBL_MF_P__3214EC07B43E7F5F] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_PaymentDetails_Archival
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_PaymentDetails_Archival] ADD CONSTRAINT [PK__TBL_MF_P__3214EC27C6378891] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_REGISTRATIONRELATED
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_REGISTRATIONRELATED] ADD CONSTRAINT [PK_TBL_MF_REGISTRATIONRELATED] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MF_sbapplicationlog
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MF_sbapplicationlog] ADD CONSTRAINT [PK__tbl_MF_s__3213E83FE7A43942] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MF_sbapplicationlog_archival
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MF_sbapplicationlog_archival] ADD CONSTRAINT [PK__tbl_MF_s__3213E83F3A1491A2] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MF_UPDATEPROFILEPIC
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MF_UPDATEPROFILEPIC] ADD CONSTRAINT [PK__TBL_MF_U__3214EC273C72B73D] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MFSB_AadharData
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MFSB_AadharData] ADD CONSTRAINT [PK__tbl_MFSB__3214EC07A6AED368] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_Applicationlog
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_Applicationlog] ADD CONSTRAINT [PK__TBL_MFSB__3213E83F32061D8D] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_AssignedEmployeeDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_AssignedEmployeeDetail] ADD CONSTRAINT [PK__TBL_MFSB__3214EC071FEC1679] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_AssignedEmployeeMst
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_AssignedEmployeeMst] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07EB6EA452] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_ErrorLog
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_ErrorLog] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07BED85C10] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MFSB_ImpsDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MFSB_ImpsDetail] ADD CONSTRAINT [PK__tbl_MFSB__3214EC07701C0E13] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_NonARNClient
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_NonARNClient] ADD CONSTRAINT [PK__TBL_MFSB__3214EC0709850ED7] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_Otp
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_Otp] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07B586B437] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_PanResultFromUTI_IncomeTax
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_PanResultFromUTI_IncomeTax] ADD CONSTRAINT [PK__TBL_MFSB__3214EC27E9E2E153] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_POSPClient
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_POSPClient] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07E9090A35] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_Registration
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_Registration] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07F68175F8] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_Registration_Archival
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_Registration_Archival] ADD CONSTRAINT [PK__TBL_MFSB__3214EC0733D2E506] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_StepDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_StepDetail] ADD CONSTRAINT [PK__TBL_MFSB__3214EC07164A87DD] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_MFSB_StepMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_MFSB_StepMaster] ADD CONSTRAINT [PK__TBL_MFSB__3214EC0773D1166B] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_NONCASHDEPOSIT
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_NONCASHDEPOSIT] ADD CONSTRAINT [PK_TBL_NONCASHDEPOSIT] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_REGISTRATIONRELATED
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_REGISTRATIONRELATED] ADD CONSTRAINT [PK_TBL_REGISTRATIONRELATED] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_REJECTION_REASON
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_REJECTION_REASON] ADD CONSTRAINT [PK_TBL_REJECTION_REASON] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_sbapplicationlog
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_sbapplicationlog] ADD CONSTRAINT [PK__tbl_sbap__3213E83F72F5F39E] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_sbapplicationlog_archival
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_sbapplicationlog_archival] ADD CONSTRAINT [PK__tbl_sbap__3213E83F7BF325DF] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_SEGMENTS
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_SEGMENTS] ADD CONSTRAINT [PK_TBL_SEGMENTS] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_temp_2024_03_15
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_temp_2024_03_15] ADD CONSTRAINT [PK__tbl_temp__3213E83F6F982967] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_UPDATEPROFILEPIC
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_UPDATEPROFILEPIC] ADD CONSTRAINT [PK__TBL_UPDA__3214EC274AB81AF0] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Users
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Users] ADD CONSTRAINT [PK__tbl_User__3214EC2799448156] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo._USP_MF_GEN_TAG
-- --------------------------------------------------
/*

EXEC USP_MF_GEN_TAG 241

EXEC USP_MF_GEN_TAG 257 

EXEC USP_MF_GEN_TAG 301

*/

CREATE PROCEDURE [dbo].[_USP_MF_GEN_TAG] (@AprRefNo AS VARCHAR(15))      

AS      

DECLARE @count INT = 1,      

 @index2 INT = 1;      

DECLARE @RandomID VARCHAR(32)      

DECLARE @counter SMALLINT      

DECLARE @RandomNumber FLOAT      

DECLARE @RandomNumberInt INT      

DECLARE @CurrentCharacter VARCHAR(1)      

DECLARE @ValidCharacters VARCHAR(255)      

DECLARE @FChar VARCHAR (1)   

DECLARE @PANNO VARCHAR(15)     

DECLARE @SBTAGExists VARCHAR(15)  

  
SET @PANNO  = (

SELECT PAN from TBL_MF_IDENTITYDETAILS where entryid =  @AprRefNo

)

SET  @SBTAGExists = (      
	
	SELECT ISNULL(SBTAG, '') AS SBTAG      

	FROM [MIS].SB_COMP.DBO.[SB_broker]      

	WHERE PANNO = @PANNO and Branch  != 'MFSB'
)      
   

IF (@SBTAGExists = '')
BEGIN

SET @ValidCharacters = (      

  SELECT FIRSTNAME+ LASTNAME      

  FROM TBL_MF_BASICDETAILS      

   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO      

  )      

SET @FChar  = (      

 SELECT   SUBSTRING(FIRSTNAME, 1,1 )

 FROM TBL_MF_BASICDETAILS      

  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo      

 )      

DECLARE @pindex INT;      

WHILE (1 = 1)      

BEGIN      

 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)      

      

 IF (@pindex > 0)      

  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')      

 ELSE      

  BREAK;      

END      

Lablel1:      

DECLARE @ValidCharactersLength INT;      

DECLARE @index INT = 0;      

SET @ValidCharactersLength = len(@ValidCharacters)      

SET @CurrentCharacter = ''      

SET @RandomNumber = 0      

SET @RandomNumberInt = 0      

SET @RandomID = ''      

SET NOCOUNT ON      

SET @counter = 1      

SET @index = @count;      

WHILE @counter < = (3)      

BEGIN      

 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)      

      

 IF (@count >= @ValidCharactersLength)      

 BEGIN      

  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)      

  SET @index2 = @index2 + 1;      

 END      

      

 SET @RandomID = @RandomID + @CurrentCharacter      

 SET @counter = @counter + 1      

 SET @index = @index + 1;      

      

 IF (@counter = 3)      

 BEGIN      

  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID      

 END      

END      

IF EXISTS (      

  SELECT SBTAG      

  FROM [MIS].SB_COMP.DBO.[SB_broker]      

  WHERE sbtag = @FChar + @RandomID      

  )      

BEGIN      

 SET @count = @count + 1;      

 GOTO Lablel1;      

END      
ELSE      

 SELECT Upper(@FChar + @RandomID) AS TAG

 END
 
 ELSE 

 SELECT Upper(@SBTAGExists) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteWrongEntry
-- --------------------------------------------------

--DeleteWrongEntry 3401


CREATE PROC DeleteWrongEntry
@EntryID INT
AS
BEGIN 

BEGIN TRAN 

--declare @EntryID varchar(100) 
--set @EntryID  =  3398

DELETE FROM TBL_MF_IDENTITYDETAILS  where ENTRYID =  @EntryID

DELETE FROM TBL_MF_BASICDETAILS  where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_BANKDETAILS] where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_NomineeDetails] where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_ESIGNDOCUMENTS] where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_PaymentDetails]where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_Applicationlog] where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_DOCUMENTSUPLOAD] where ENTRYID =    @EntryID

DELETE FROM [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF] where ENTRYID =    @EntryID

--ROLLBACK TRAN 
 COMMIT TRAN 

 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetEmpCodeByEmail
-- --------------------------------------------------
--Execute GetEmpCodeByEmail @UserID='ABHISHEK.SINGH'  
      
CREATE PROCEDURE [dbo].[GetEmpCodeByEmail]      
  @UserID varchar(200)      
AS      
BEGIN      
 Declare @emp_no varchar(10)  
 select @emp_no=emp_no       
 from  [RISK].[dbo].[emp_info]       
 where email like @UserID + '@angelbroking.com'  and Status  = 'A'  
 --and SeparationDate is NULL      
  
 --- select *  from  [RISK].[dbo].[emp_info]     Where emp_no = 'E78155'  
   
 if ISNULL(@emp_no,'') = ''  
begin  
 SET @emp_no  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @UserID + '@angelbroking.com')  
end  
  
select @emp_no 'emp_no'      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetIsDeleted
-- --------------------------------------------------

CREATE PROCEDURE GetIsDeleted 
	
AS
BEGIN

	select * from TBL_MF_ESIGNDOCUMENTS
    where ISDELETE = 1
    and ISPHYSICALLYDELETED = 0 ;

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PRC_GETCLIENT_DETAILS_Ipartner
-- --------------------------------------------------

CREATE PROC [dbo].[PRC_GETCLIENT_DETAILS_Ipartner]
@CLIENTCODE AS VARCHAR(50)='',
@ACCESS_CODE AS VARCHAR(50)=''

AS BEGIN

SELECT LONG_NAME AS 'NAME',MOBILE_PAGER AS MOB,EMAIL AS EMAIL,L_CITY AS CITY FROM [CSOKYC-6].GENERAL.DBO.CLIENT_DETAILS WHERE CL_CODE =@CLIENTCODE
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_GetRejectedSB
-- --------------------------------------------------
CREATE PROC Proc_GetRejectedSB
(
	@Date AS DATETIME=NULL
)
AS
BEGIN
	IF @Date IS NULL
	BEGIN
		SET @Date=GETDATE()-1
	END	
	
	select entryid,MAX(Time)RejectTime 
	INTO #RejectTime-- DROP TABLE #RejectTime
	from tbl_sbapplicationlog
	where  operation='Record Rejected'
	GROUP BY entryid

	select bd.ENTRYID,id.ENTRYBY as Ecode 
		,ISNULL(bd.FIRSTNAME,'')+' '+ISNULL(bd.MIDDLENAME,'')+' '+ISNULL(bd.LASTNAME,'') as Name
		,bd.PARENT as Branch,bd.REGION,bd.INTERMEDIARYEMPLOYEE as Introdername
		,rt.RejectTime 
		,am.STATUS
	from TBL_BASICDETAILS bd
		JOIN #RejectTime rt
		ON bd.ENTRYID=rt.ENTRYID
		LEFT JOIN TBL_IDENTITYDETAILS  id
		ON bd.ENTRYID=id.ENTRYID
		LEFT JOIN TBL_APPLICATIONSTATUSMASTER am
		ON id.ISAPPROVED=am.STATUS_CODE
	where sbtag IS NULL AND DATEDIFF(DAY,RejectTime,@Date)=0
	ORDER BY RejectTime
	
	DROP TABLE #RejectTime
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_GetSBTATDetails
-- --------------------------------------------------
CREATE PROC Proc_GetSBTATDetails
(
	@Date AS DATETIME=NULL
)
AS 
BEGIN

	IF @Date IS NULL
	BEGIN
		SET @Date=GETDATE()-1
	END	

	SELECT entryid,operation,MIN(Time)Min_Time,MAX(Time)Max_Time
	INTO #EsignDone
	FROM tbl_sbapplicationlog 
	WHERE operation IN('Save Identity Details','Final Form Submit','CSO Esign Done')
			AND entryid IN(SELECT DISTINCT entryid FROM tbl_sbapplicationlog  WHERE operation='CSO Esign Done' AND DATEDIFF(DAY,TIME,@Date)=0)
	GROUP BY entryid,operation

	SELECT DISTINCT entryid 
	INTO #Record_Rejected
	FROM tbl_sbapplicationlog  
	WHERE operation='Record Rejected' AND DATEDIFF(DAY,TIME,@Date)=0

	SELECT entryid,operation,
			CASE WHEN operation='CSO Esign Done' 
				 THEN Max_Time
				 ELSE Min_Time
			END LogTime			 
	INTO #EsignLog
	FROM #EsignDone
	ORDER BY entryid

	SELECT entryid,[Save Identity Details],[Final Form Submit],[CSO Esign Done]
	INTO #EntryDetails
	From 
	(
		Select entryid,operation,LogTime
		From #EsignLog
	)A
	PIVOT
	(
		MAX(LogTime) For operation In ([Save Identity Details],[Final Form Submit],[CSO Esign Done])
	)B

	SELECT bd.sbtag,ed.entryid,ed.[Save Identity Details],ed.[Final Form Submit],ed.[CSO Esign Done]
			,CAST((ed.[Final Form Submit]-ed.[Save Identity Details]) as time(0)) AS BDO_TAT
			,CAST((ed.[CSO Esign Done]-ed.[Final Form Submit]) as time(0)) AS CSO_TAT
			,CAST((ed.[CSO Esign Done]-ed.[Save Identity Details]) as time(0)) AS Overall_TAT
			,CASE WHEN rr.entryid IS NULL
				 THEN 'No'
				 ELSE 'Yes'
			END	IsRejected
	INTO #Final
	FROM #EntryDetails ed
		LEFT JOIN TBL_BASICDETAILS bd
		ON ed.entryid=bd.entryid
		LEFT JOIN #Record_Rejected rr
		ON ed.entryid=rr.entryid

	SELECT *
	FROM #Final
	ORDER BY DATEDIFF(MINUTE,[CSO Esign Done],[Save Identity Details])

	DROP TABLE #EsignDone
	DROP TABLE #EsignLog
	DROP TABLE #EntryDetails
	DROP TABLE #Record_Rejected

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_GetSBTATDetails_Rejected
-- --------------------------------------------------
CREATE PROC Proc_GetSBTATDetails_Rejected
(
	@Date AS DATETIME=NULL
)
AS 
BEGIN

	IF @Date IS NULL
	BEGIN
		SET @Date=GETDATE()-1
	END	

	SELECT entryid,operation,MIN(Time)Min_Time,MAX(Time)Max_Time
	INTO #EsignDone
	FROM tbl_sbapplicationlog 
	WHERE operation IN('Save Identity Details','Final Form Submit','Record Rejected')
			AND entryid IN(SELECT DISTINCT entryid FROM tbl_sbapplicationlog  WHERE operation='Record Rejected' AND DATEDIFF(DAY,TIME,@Date)=0)
			AND entryid NOT IN(SELECT DISTINCT entryid FROM tbl_sbapplicationlog  WHERE operation='CSO Esign Done' AND DATEDIFF(DAY,TIME,@Date)=0)
	GROUP BY entryid,operation

	SELECT entryid,operation,
			CASE WHEN operation='Record Rejected' 
				 THEN Max_Time
				 ELSE Min_Time
			END LogTime			 
	INTO #EsignLog
	FROM #EsignDone
	ORDER BY entryid

	SELECT entryid,[Save Identity Details],[Final Form Submit],[Record Rejected]
	INTO #EntryDetails
	From 
	(
		Select entryid,operation,LogTime
		From #EsignLog
	)A
	PIVOT
	(
		MAX(LogTime) For operation In ([Save Identity Details],[Final Form Submit],[Record Rejected])
	)B

	SELECT bd.sbtag,ed.entryid,ed.[Save Identity Details],ed.[Final Form Submit],ed.[Record Rejected]
			,CAST((ed.[Final Form Submit]-ed.[Save Identity Details]) as time(0)) AS BDO_TAT
			,CAST((ed.[Record Rejected]-ed.[Final Form Submit]) as time(0)) AS CSO_TAT
			,CAST((ed.[Record Rejected]-ed.[Save Identity Details]) as time(0)) AS Overall_TAT
	INTO #Final
	FROM #EntryDetails ed
		LEFT JOIN TBL_BASICDETAILS bd
		ON ed.entryid=bd.entryid

	SELECT *
	FROM #Final
	ORDER BY DATEDIFF(MINUTE,[Record Rejected],[Save Identity Details])

	DROP TABLE #EsignDone
	DROP TABLE #EsignLog
	DROP TABLE #EntryDetails

END

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
-- PROCEDURE dbo.SP_GetAccessID
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[SP_GetAccessID]   
 @USERID varchar(100)=''  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 select id from tbl_accesscontrol where USERID = @USERID order by id desc; 
 --select id from tbl_accesscontrol where USERID = 'E61414' order by 1 desc;  
 
    -- select * from tbl_accesscontrol  
    
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Sp_GetData
-- --------------------------------------------------
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE Sp_GetData   
 @sqlCommand varchar(max)  
AS  
BEGIN  
  
EXEC (@sqlCommand)  
  
 --select * from TBL_MF_BASICDETAILS;  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_AadharResponse_Save
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 25th Nov 2020
-- Description:	For saving digilocker response
-- =============================================
create PROCEDURE [dbo].[spx_MFSB_AadharResponse_Save]
	@EntryId bigint,
	@IpAddress VARCHAR(50) = NULL,
	@AuthType VARCHAR(15) = NULL,
	@Name VARCHAR(150) = NULL,
	@FirstName VARCHAR(50) = NULL,
	@MiddleName VARCHAR(50) = NULL,
	@LastName VARCHAR(50) = NULL,
	@Address VARCHAR(550) = NULL,
	@AddressLine1 VARCHAR(150) = NULL,
	@AddressLine2 VARCHAR(150) = NULL,
	@AddressLine3 VARCHAR(250) = NULL,
	@State VARCHAR(50) = NULL,
	@City VARCHAR(50) = NULL,
	@PinCode VARCHAR(12) = NULL,
	@Dob varchar(15) = NULL,
	@Gender VARCHAR(15) = NULL,
	@Photo VARCHAR(MAX) = NULL,
	@Uid VARCHAR(4) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Msg varchar(200) = '', @IsValid BIT = 0 	
	BEGIN TRY 	
		IF NOT EXISTS (SELECT 1 FROM tbl_MFSB_AadharData A WITH(NOLOCK) WHERE EntryId = @EntryId)
		BEGIN
			INSERT INTO tbl_MFSB_AadharData
			(
				EntryId,
				IpAddress,
				AuthType,
				Name,
				FirstName,
				MiddleName,
				LastName,
				Address,
				AddressLine1,
				AddressLine2,
				AddressLine3,
				State,
				City,
				PinCode,
				Dob,
				Gender,
				Photo,
				CreateDate
			)
			VALUES
			(
				@EntryId,
				@IpAddress,
				@AuthType,
				@Name,
				@FirstName,
				@MiddleName,
				@LastName,
				@Address,
				@AddressLine1,
				@AddressLine2,
				@AddressLine3,
				@State,
				@City,
				@PinCode,
				@Dob,
				@Gender,
				@Photo,
				GETDATE()
			)
			
			SET @IsValid = 1
		END
		ELSE
		BEGIN
			UPDATE tbl_MFSB_AadharData
			SET	EntryId = @EntryId,
				IpAddress = @IpAddress,
				AuthType = @AuthType,
				Name = @Name,
				FirstName = @FirstName,
				MiddleName = @MiddleName,
				LastName = @LastName,
				Address = @Address,
				AddressLine1 = @AddressLine1,
				AddressLine2 = @AddressLine2,
				AddressLine3 = @AddressLine3,
				State = @State,
				City = @City,
				PinCode = @PinCode,
				Dob = @Dob,
				Gender = @Gender,
				Photo = @Photo,
				ModifiedDate = GETDATE()
			WHERE EntryId = @EntryId
			
			SET @IsValid = 1
			
		END
		
		IF @IsValid = 1
		BEGIN
			EXEC USP_MFSB_AddressDetail_Save @EntryId,@AddressLine1,@AddressLine2,@AddressLine3,'',@City,@PinCode,@State,1,1,1,'Saving aadhar address!',@IpAddress,1
			EXEC USP_MFSB_AddressDetail_Save @EntryId,@AddressLine1,@AddressLine2,@AddressLine3,'',@City,@PinCode,@State,0,1,1,'Saving aadhar address!',@IpAddress,1
			
			UPDATE TBL_MF_BASICDETAILS 
			SET FIRSTNAME = @FirstName,
			MIDDLENAME = @MiddleName,
			LASTNAME = @LastName,
			Gender = CASE WHEN ISNULL(@Gender, '') = 'M' OR ISNULL(@Gender, '') = 'm' THEN 'Male' WHEN ISNULL(@Gender, '') = 'F' OR ISNULL(@Gender, '') = 'f' THEN 'Female' ELSE @Gender END,
			ModifiedOn = GETDATE()
			WHERE ENTRYID = @EntryId
			
			UPDATE TBL_MF_IDENTITYDETAILS
			SET DOB = @Dob,
			AadharName = @Name,
			U_ID = @Uid,
			MODIFY_DATE = GETDATE(),
			IsAadhaar = 1
			WHERE ENTRYID = @EntryId
			
			IF EXISTS (SELECT * FROM TBL_MF_DOCUMENTSUPLOAD D WITH(NOLOCK) WHERE ENTRYID = @EntryId AND DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_DOCUMENTSUPLOAD
				SET ISDELETE = 1
				WHERE ENTRYID = @EntryId
				AND DOCTYPE = 'Photo'
			END
			IF EXISTS (SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF D WITH(NOLOCK) WHERE ENTRYID = @EntryId AND DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_DOCUMENTSUPLOAD_PDF
				SET ISDELETE = 1
				WHERE ENTRYID = @EntryId
				AND DOCTYPE = 'Photo'
			END
		END
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
		SET @Msg = @ErrorMessage
	END	CATCH
	
	--SELECT @Msg 'Message', @IsValid 'IsValid', @Pan 'Pan', @EntryId 'EntryId', @FirstName 'FirstName', @MiddleName 'MiddleName', @LastName 'LastName', @IsARN 'IsARN'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_CheckKey_Validation
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 31th Aug 2020
-- Description:	To validate key
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_CheckKey_Validation]
	@Key VARCHAR(500)
	,@Pan VARCHAR(12)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Msg varchar(200) = '', @IsValid BIT = 0
	BEGIN TRY 	
		IF EXISTS (SELECT 1 FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE R.SessionKey = @Key AND R.Pan = @Pan)
		BEGIN
			SET @Msg = 'Key successfully validated!'
			SET @IsValid = 1				
		END
		ELSE 
			SET @Msg = 'Key is not valid, please re-login!!';
		
	END TRY 
	BEGIN CATCH
				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
	END	CATCH
	
	SELECT @Msg 'Message', @IsValid 'IsValid'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_CheckNomineePan_Validation
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 28th Sept 2020
-- Description:	CHECK NOMINEE PAN 
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_CheckNomineePan_Validation]
	@EntryId bigint,
	@Pan varchar(12)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY 	
	
	Declare @Message varchar(50),@IsValid bit = 0;
	
	IF EXISTS(SELECT 1 FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE PAN = @Pan AND ENTRYID = @EntryId)
	BEGIN
		SET @Message = 'You can not use same pan as a nominee, so please enter valid pan!'
	END
	ELSE
	BEGIN
		SET @IsValid = 1
		SET @Message = 'Valid Pan!'
	END	
	
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
	END	CATCH
	
	Select @Message as 'Message', @IsValid 'IsValid'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_CheckPanInKYC_Validation
-- --------------------------------------------------
  
-- =============================================  
-- Author:  Shekhar Ghule  
-- Create date: 28th Aug 2020  
-- Description: CHECK PAN IN KYC FOR MFSB  
-- =============================================  
CREATE PROCEDURE [dbo].[spx_MFSB_CheckPanInKYC_Validation]  
 @Type varchar(1),  
 @Pan varchar(12)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 BEGIN TRY    
   
 Declare @Count int,@Message varchar(20),@Application_No Varchar(10),@DIYPanID varchar(10),@OneKycPanID varchar(100);  
 set @Count=0  
    
 If @Type='P' and @Count = 0  
 BEGIN    
  IF EXISTS (select 1 from [kyc1db].[AngelBrokingWebDB].[dbo].[BasicIdentity] B With(Nolock) WHERE PanCard_No = @Pan)  
  BEGIN  
   SET @Count = 1  
  END  
 END  
   
 If @Type='P' and @Count = 0  
 BEGIN  
  IF EXISTS (select 1 from [kyc1db].[AngelBrokingDiyKyc].[dbo].[DiyKyc_ClientDetails] B With(Nolock) WHERE PanCard_No = @Pan)  
  BEGIN  
   SET @Count=1  
  END  
    
  --SELECT top 1 @DIYPanID=DiyKycId FROM AngelBrokingDiyKyc.dbo.DiyKyc_AppStepsStatus_website A WITH(NOLOCK) WHERE DiyKycId IN (Select DCD.DiyKycId From AngelBrokingDiyKyc.dbo.DiyKyc_ClientDetails DCD With(NoLock)   
  --Inner Join AngelBrokingDiyKyc.dbo.DiyKyc_ClientInfo DCI With(NoLock) On DCD.DiyKycId=DCI.DiyKycId        
  --Where DCD.PanCard_No=@Pan and isnull(DCD.PanCard_No,'')<>''    
  --) and CAST(A.Updation_Date as DATE) > CAST(GETDATE()-30 as date) order by Updation_Date desc  
        
  --IF(ISNULL(@DIYPanID,'')!='')  
  --BEGIN  
  -- SET @Count=1  
  --END  
 END  
   
   
          
 If @Type='P' and @Count = 0  
 begin     
  IF EXISTS (Select 1  from [kyc1db].[KYCSDK].[dbo].[banks] b with(nolock) WHERE b.PAN = @Pan)  
  BEGIN  
   SET @Count=1  
  END  
  --Select top 1  @OneKycPanID=A.basicid  
  --from KYCSDK.dbo.tbl_KycMiddleware_Abma_AppStepsStatus A with(nolock) where basicid in (Select C.basicid  from KYCSDK.dbo.banks b with(nolock)   
  --inner join KYCSDK..tbl_KycMiddleware_ClientInfo c with(nolock) on b.basicId=c.basicid  
  --where b.pan=@Pan) and Status=1 and  CAST(A.UpdatedDate as DATE) > CAST(GETDATE()-30 as date)  order by UpdatedDate desc  
  --IF(ISNULL(@OneKycPanID,'')!='')  
  --   BEGIN  
  -- SET @Count=1  
  --END  
 end   
 END TRY   
 BEGIN CATCH      
  DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT  
    ,@ErrorNumber INT,@ErrorLine INT                                      
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()  
  ,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();  
     
 END CATCH  
   
 Select @Count as 'Count'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_CheckPanInSBCOM_Validation
-- --------------------------------------------------
  
-- =============================================  
-- Author:  Shekhar Ghule  
-- Create date: 18th Sept 2020  
-- Description: CHECK PAN IN SBCOM FOR MFSB  
-- =============================================  
CREATE PROCEDURE [dbo].[spx_MFSB_CheckPanInSBCOM_Validation]  
 @Pan varchar(12)  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 BEGIN TRY    
   
 Declare @Message varchar(50),@IsSuccess bit = 0;  
  IF EXISTS (select 1 from [MIS].SB_COMP.dbo.VW_SubBroker_Details With(nolock) WHERE PanNo=@Pan)  
  BEGIN  
   SET @IsSuccess = 0;  
   SET @Message = 'Pan is already registerd as SB!'  
  END  
  ELSE  
  BEGIN  
   SET @IsSuccess = 1  
   SET @Message = 'Success'  
  END  
 END TRY   
 BEGIN CATCH      
  DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT  
    ,@ErrorNumber INT,@ErrorLine INT                                      
  
  SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()  
  ,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();  
     
 END CATCH  
   
 Select @IsSuccess as 'IsSuccess', @Message 'Message'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_ClienteSignDetail_Get
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 11th Sept 2020
-- Description:	get client details fro esign
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_ClienteSignDetail_Get]
	@EntryID bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ClientName varchar(200) = ''
	BEGIN TRY 	
		SELECT @ClientName = ISNULL(B.FIRSTNAME,'') +' '+ ISNULL(B.MIDDLENAME,'') +' ' + ISNULL(B.LASTNAME,'')  FROM TBL_MF_BASICDETAILS B WITH(NOLOCK) WHERE B.ENTRYID = @EntryID	
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
	END	CATCH
	
	SELECT @ClientName 'ClientName'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_ClientName_Get
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 11th Nov 2020
-- Description:	get client name for IMPS
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_ClientName_Get]
	@EntryID bigint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @ClientName varchar(200) = ''
	BEGIN TRY 	
		SELECT @ClientName = ISNULL(B.FIRSTNAME,'') +' '+ ISNULL(B.MIDDLENAME,'') +' ' + ISNULL(B.LASTNAME,'')  FROM TBL_MF_BASICDETAILS B WITH(NOLOCK) WHERE B.ENTRYID = @EntryID	
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
	END	CATCH
	
	SELECT @ClientName 'ClientName'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_Key_Get
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 25th Nov 2020
-- Description:	Get key from entryId for digilocker
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_Key_Get]
	-- Add the parameters for the stored procedure here
	@EntryId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 SessionKey 'Key' FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE R.EntryID = @EntryId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_Otp_Save
-- --------------------------------------------------
   
-- =============================================  
-- Author:  Shekhar G  
-- Create date: 27th Aug 2020  
-- Description: To save otp details   
-- =============================================  
--EXEC spx_MFSB_Otp_Save @mobile='9867094397',@source='ABMASDK'  
CREATE PROCEDURE [dbo].[spx_MFSB_Otp_Save]  
 @Mobile VARCHAR(15)  
 ,@Source VARCHAR(30)  
 ,@Otp VARCHAR(10) = NULL  
 ,@Pan varchar(12) = NULL  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 Declare @Msg varchar(200) = ''  
 , @IsValid BIT = 0  
 ,@Today datetime = getdate()  
 ,@otpCount int = 0  
 ,@IsRegistered bit = 0  
   
 IF(ISNULL(@Pan,'') <> '' AND ISNULL(@Source,'') = 'mfsbregistration')  
 BEGIN    
  IF EXISTS (SELECT 1 FROM TBL_MFSB_Registration R With(nolock) WHERE R.Pan = @Pan or R.Mobile = @Mobile)  
  BEGIN  
   SET @Msg = 'You already registered with us. Please proceed with login!'  
  END  
 END   
 IF(@IsRegistered = 0)  
 BEGIN  
  SELECT @otpCount = COUNT(1) from dbo.TBL_MFSB_Otp WITH (NOLOCK)   
  WHERE Mobile = @mobile  AND CONVERT(varchar, CreatedAt, 112) = CONVERT(varchar, @Today, 112)   
    
  IF @otpCount >= 10  
  BEGIN  
   SET @Msg = 'Otp limit exceeded! You cannot generate more than 10 otps per day. Please try again tomorrow!';  
  END  
  ELSE   
  BEGIN  
   IF ISNULL(@otp, '') = ''  
    SET @otp = FLOOR(100000 + (RAND()* 900000));       
      
   INSERT INTO dbo.TBL_MFSB_Otp(Mobile,Otp,Source,CreatedAt,UpdatedAt)   
   VALUES ('',@otp,@source,@Today,null)  
     
   SET @IsValid = 1;  
   SET @Msg = 'Otp generated successfully!';  
  END  
 END  
 SELECT @Msg 'Message' , @IsValid 'IsValid', @Otp 'OTP'  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-38887 */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_Otp_Save_0Aug2025
-- --------------------------------------------------
   
-- =============================================  
-- Author:  Shekhar G  
-- Create date: 27th Aug 2020  
-- Description: To save otp details   
-- =============================================  
--EXEC spx_MFSB_Otp_Save @mobile='9867094397',@source='ABMASDK'  
CREATE PROCEDURE [dbo].[spx_MFSB_Otp_Save_0Aug2025]  
 @Mobile VARCHAR(15)  
 ,@Source VARCHAR(30)  
 ,@Otp VARCHAR(10) = NULL  
 ,@Pan varchar(12) = NULL  
AS  
BEGIN  
 SET NOCOUNT ON;  
   
 Declare @Msg varchar(200) = ''  
 , @IsValid BIT = 0  
 ,@Today datetime = getdate()  
 ,@otpCount int = 0  
 ,@IsRegistered bit = 0  
   
 IF(ISNULL(@Pan,'') <> '' AND ISNULL(@Source,'') = 'mfsbregistration')  
 BEGIN    
  IF EXISTS (SELECT 1 FROM TBL_MFSB_Registration R With(nolock) WHERE R.Pan = @Pan or R.Mobile = @Mobile)  
  BEGIN  
   SET @Msg = 'You already registered with us. Please proceed with login!'  
  END  
 END   
 IF(@IsRegistered = 0)  
 BEGIN  
  SELECT @otpCount = COUNT(1) from dbo.TBL_MFSB_Otp WITH (NOLOCK)   
  WHERE Mobile = @mobile  AND CONVERT(varchar, CreatedAt, 112) = CONVERT(varchar, @Today, 112)   
    
  IF @otpCount >= 10  
  BEGIN  
   SET @Msg = 'Otp limit exceeded! You cannot generate more than 10 otps per day. Please try again tomorrow!';  
  END  
  ELSE   
  BEGIN  
   IF ISNULL(@otp, '') = ''  
    SET @otp = FLOOR(100000 + (RAND()* 900000));       
      
   INSERT INTO dbo.TBL_MFSB_Otp(Mobile,Otp,Source,CreatedAt,UpdatedAt)   
   VALUES (@mobile,@otp,@source,@Today,null)  
     
   SET @IsValid = 1;  
   SET @Msg = 'Otp generated successfully!';  
  END  
 END  
 SELECT @Msg 'Message' , @IsValid 'IsValid', @Otp 'OTP'  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-38887 */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_Otp_Validate
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 27th Aug 2020
-- Description:	To validate otp details 
-- =============================================
--EXEC spx_MFSB_Otp_Validate '9527833149', '242053','Login','123'
CREATE PROCEDURE [dbo].[spx_MFSB_Otp_Validate]
	@Mobile VARCHAR(15)
	,@Otp VARCHAR(10)
	,@Source VARCHAR(15)
	,@ipAddress varchar(50) = ''
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Msg varchar(200) = '', @IsValid BIT = 0
	, @CreatedAt datetime = NULL
	, @Today datetime = getdate()
	, @Pan varchar(12)
	, @EntryId int = 0
	, @AppStatus varchar(2) = ''
	, @OtherMsg varchar(200) = ''
	, @PanName varchar(250) = ''
	, @FirstName varchar(50) = ''
	, @MiddleName varchar(50) = ''
	, @LastName varchar(50) = ''
	, @IsARN varchar(1) = ''
	, @ObjectionRemark varchar(1000) = ''
	BEGIN TRY 	
		IF ISNULL(@Mobile , '') <> ''
		BEGIN
				Declare @GeneratedOtp varchar(10) = '', @Id bigint;	
				SELECT TOP 1 @CreatedAt = CreatedAt, @GeneratedOtp = Otp, @Id = Id from dbo.TBL_MFSB_Otp WITH (NOLOCK) 
				WHERE Mobile = @Mobile and ISNULL(UpdatedAt, '') = ''
				ORDER BY CreatedAt DESC				  
				IF ISNULL(@CreatedAt, '') <> ''
				BEGIN				
					IF @GeneratedOtp = @otp
					BEGIN					
						IF (DATEDIFF(HOUR, @createdAt, @Today) <= 24)
						BEGIN
							UPDATE dbo.TBL_MFSB_Otp SET UpdatedAt = GETDATE()
							WHERE Id = @Id		
							SELECT @Pan = ISNULL(Pan,''), @EntryId = ISNULL(EntryID , 0),@IsARN=ISNULL(IsARN , '3') FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE Mobile = @Mobile							
							IF(ISNULL(@IsARN ,'3')  = '1' OR ISNULL(@IsARN ,'3') = '2')
							BEGIN
								IF ISNULL(@Pan,'') <> ''
								BEGIN							
									SELECT @AppStatus = ISNULL(ISAPPROVED,''), @ObjectionRemark = I.Remark FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE I.ENTRYID = @EntryId
									IF (@AppStatus = '1' or @AppStatus = '4' or @AppStatus = '6')
									BEGIN
										SET @IsValid = 1;
										SET @Msg = CASE WHEN @AppStatus = '1' THEN 'eSign is done, can not edit!' WHEN @AppStatus = '4' THEN 'Application is in under scrutiny, can not edit!' WHEN @AppStatus = '6' THEN 'SB tag is generated, can not edit!' END;	
										--SET @OtherMsg = CASE WHEN @AppStatus = '1' THEN 'eSign is done, can not edit!' WHEN @AppStatus = '4' THEN 'Application is in under scrutiny, can not edit!' WHEN @AppStatus = '6' THEN 'SB tag is generated, can not edit!' END;	
									END
									ELSE IF (@AppStatus = '2')
									BEGIN
										SET @IsValid = 1
										SET @Msg = 'Otp verification successful!';	
										SET @OtherMsg = @ObjectionRemark
									END
									ELSE
									BEGIN
										SET @IsValid = 1;
										SET @Msg = 'Otp verification successful!';	
									END								
								END
								ELSE								
								BEGIN
									SET @IsValid = 0;
									SET @Msg = 'Entered mobile no is not registered with us!';	
								END
							END
							ELSE IF(ISNULL(@IsARN ,'3')  = '3')
							BEGIN
								SET @IsValid = 0;
								SET @Msg = 'You are registered with us as POSP!';	
							END
							ELSE
							BEGIN
								SET @IsValid = 0;
								SET @Msg = 'You are not registered with us!';	
							END	
							
							-- Return name
							SELECT @PanName=PANName FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE ENTRYID = @EntryId
							CREATE TABLE #TempName (Id int Not NULL Identity(1,1),First_Name VARCHAR(150),Middle_Name VARCHAR(150),Last_Name VARCHAR(150))  
							INSERT INTO #TempName  
							SELECT * FROM dbo.Fn_Split_Name_3part(@PanName,' ')
							SELECT @FirstName=First_Name, @MiddleName=Middle_Name, @LastName=Last_Name FROM #TempName
							Drop table #TempName  
							-- Return name						
						END
						ELSE 
						BEGIN
							SET @Msg = 'Otp expired! Kindly regenerate otp!';
						END
					END
					ELSE 
					BEGIN
						SET @Msg = 'Invalid otp! Kindly enter latest otp or regenerate otp!';
					END
				END
				ELSE 
				BEGIN
					SET @Msg = 'Otp verification failed';
				END		
		END
		ELSE 
			SET @Msg = 'Mobile no required for otp verification';
	
	EXEC USP_MFSB_ApplicationLog_Save @EntryId,'Validate OTP',@Msg,@ipAddress
		
	END TRY 
	BEGIN CATCH
				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
	END	CATCH
	
	
	SELECT @Msg 'Message', @IsValid 'IsValid',@Pan 'Pan', @EntryId 'EntryId', @OtherMsg 'OtherMessage', @FirstName 'FirstName', @MiddleName 'MiddleName', @LastName 'LastName',@IsARN 'IsARN'	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_PanUTIResult_Save
-- --------------------------------------------------
 
-- =============================================
-- Author:		Shekhar G
-- Create date: 30th Aug 2020
-- Description:	To save PAN UTI details 
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_PanUTIResult_Save]
	@PanNo varchar(15) = NULL,
	@result nvarchar(200) =  NULL,
	@FirstName varchar(500) = NULL,
	@MiddleName varchar (500) = NULL,
	@LastName varchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	Declare @Msg varchar(200) = ''
	, @IsValid BIT = 0
	
	INSERT INTO dbo.TBL_MFSB_PanResultFromUTI_IncomeTax(PanNo,result,FirstName,MiddleName,LastName,PanCreationDate) 
			VALUES (@PanNo,@result,@FirstName,@MiddleName,@LastName,GETDATE())
			
			SET @IsValid = 1;
			SET @Msg = 'Record successfully save!';
			
	SELECT @Msg 'Message' , @IsValid 'IsValid'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_Registration_Save
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 28th Aug 2020
-- Description:	For registration of MFSB
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_Registration_Save]
	@Pan VARCHAR(15)
	,@PanName VARCHAR(100) = NULL
	,@Mobile VARCHAR(15)
	,@IsARN VARCHAR(1)
	,@ArnName varchar(100) = NULL
	,@DeviceId varchar(50) = NULL
	,@ReferralTag varchar(15) = NULL
	,@ReferralSource varchar(50) = NULL
	,@SbTag varchar(15) = NULL
	,@Url varchar(100) = NULL
	,@Otp VARCHAR(10) = NULL
	,@Version VARCHAR(10) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Msg varchar(200) = '', @IsValid BIT = 0 
	, @CreatedAt datetime = NULL
	, @Today datetime = getdate()	
	, @EntryId int = 0
	, @FirstName varchar(50) = ''
	, @MiddleName varchar(50) = ''
	, @LastName varchar(50) = ''
	BEGIN TRY 	
	Declare @GeneratedOtp varchar(10) = '', @Id bigint;	
	IF NOT EXISTS (SELECT 1 FROM TBL_MF_BASICDETAILS B WITH(NOLOCK)WHERE B.MobileNO = @Mobile)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE Pan = @Pan or Mobile = @Mobile)
		BEGIN
			SELECT TOP 1 @CreatedAt = CreatedAt, @GeneratedOtp = Otp, @Id = Id from dbo.TBL_MFSB_Otp WITH (NOLOCK) 
					WHERE Mobile = @Mobile and ISNULL(UpdatedAt, '') = ''
					ORDER BY CreatedAt DESC	
			IF ISNULL(@CreatedAt, '') <> ''
			BEGIN
				IF @GeneratedOtp = @otp
				BEGIN
					IF (DATEDIFF(HOUR, @createdAt, @Today) <= 24)
					BEGIN
						UPDATE dbo.TBL_MFSB_Otp SET UpdatedAt = GETDATE()
						WHERE Id = @Id	
						IF(ISNULL(@IsARN,'') = '2' OR ISNULL(@IsARN,'') = '3')
						BEGIN
							IF NOT EXISTS (SELECT 1 FROM TBL_MFSB_NonARNClient R WITH(NOLOCK) WHERE Mobile = @Mobile)
							BEGIN
								INSERT INTO TBL_MFSB_NonARNClient
								(
									Mobile,
									ARNName,
									DeviceId,
									InsertedOn,
									IsARN
								)
								VALUES
								(
									@Mobile,
									@ArnName,
									@DeviceId,
									GETDATE(),
									@IsARN
								)
								SET @Msg = 'Thank You for your interest, we will reach out to you shortly'
							END
							ELSE
							BEGIN
								SET @Msg = 'You already shows interest, we will reach out to you shortly'
							END
						END
						ELSE
						BEGIN
							INSERT INTO TBL_MFSB_Registration
							(
								Pan,
								Mobile,
								IsARN,
								ARNName,
								DeviceId,
								ReferralTag,
								ReferralSource,
								SbTag,
								Url,
								CreatedDate,
								Version
							)
							VALUES
							(
								@Pan,
								@Mobile,
								@IsARN,
								@ArnName,
								@DeviceId,
								@ReferralTag,
								@ReferralSource,
								@SbTag,
								@Url,
								GETDATE(),
								@Version
							)
							
							IF NOT EXISTS (SELECT 1 FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE PAN = @Pan)
							BEGIN
								INSERT INTO TBL_MF_IDENTITYDETAILS
								(
									PAN,
									PANName,
									ENTRY_DATE,
									ISAPPROVED,
									ENTRYBY,
									IsOnlineEntry
								)
								VALUES
								(
									@Pan,
									@PanName,
									GETDATE(),
									0,
									@ReferralTag,
									1
								)
								SET @EntryId = SCOPE_IDENTITY();
								
							UPDATE TBL_MFSB_Registration SET EntryID = @EntryId WHERE Pan = @Pan
							
							-- AUTO ASSIGN EMPLOYEE
							IF(ISNULL(@ReferralTag, '') = '' AND @EntryId > 0)
							BEGIN
								EXEC USP_MFSB_Employeed_Assign @EntryId
							END
							-- AUTO ASSIGN EMPLOYEE
							
							-- Return name
							CREATE TABLE #TempName (Id int Not NULL Identity(1,1),First_Name VARCHAR(150),Middle_Name VARCHAR(150),Last_Name VARCHAR(150))  
							INSERT INTO #TempName  
							SELECT * FROM dbo.Fn_Split_Name_3part(@PanName,' ')
							SELECT @FirstName=First_Name, @MiddleName=Middle_Name, @LastName=Last_Name FROM #TempName
							Drop table #TempName  
							-- Return name
							
							-- Step insertion
							INSERT INTO TBL_MFSB_StepDetail (EntryId,StepId,Status,IpAddress,InsertedDate)
							SELECT @EntryId,Id,0,@DeviceId,GETDATE() FROM TBL_MFSB_StepMaster WITH(NOLOCK) WHERE IsActive = 1 order by OrderBy asc
							
							UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=1
							-- Step insertion
							
							
							END
							
							SET @Msg = 'Record successfully save!'
							SET @IsValid = 1
						END
					END
					ELSE
					BEGIN
						SET @Msg = 'Otp expired! Kindly regenerate otp!';
					END
				END
				ELSE
				BEGIN
					SET @Msg = 'Invalid otp! Kindly enter latest otp or regenerate otp!';
				END
			END	
			ELSE
			BEGIN
				SET @Msg = 'Otp not available! Kindly regenerate otp!';
			END	
			END
		ELSE
		BEGIN
				IF(ISNULL(@IsARN,'') = '2' OR ISNULL(@IsARN,'') = '3')
				BEGIN
					IF NOT EXISTS (SELECT 1 FROM TBL_MFSB_NonARNClient R WITH(NOLOCK) WHERE Mobile = @Mobile)
					BEGIN
						INSERT INTO TBL_MFSB_NonARNClient
						(
							Mobile,
							ARNName,
							DeviceId,
							InsertedOn,
							IsARN
						)
						VALUES
						(
							@Mobile,
							@ArnName,
							@DeviceId,
							GETDATE(),
							@IsARN
						)
						SET @Msg = 'Thank You for your interest, we will reach out to you shortly'
					END
					ELSE
					BEGIN
						SET @Msg = 'You already shows interest, we will reach out to you shortly'
					END					
				END
				ELSE
				BEGIN
					SET @Msg = 'Account already registered with us! Kindly proceed with login!';
				END			
			END			
		--Region for Save log	
		EXEC USP_MFSB_ApplicationLog_Save @EntryId,'Save Registration',@Msg,@DeviceId
		--Region for Save log	
	END
	ELSE
	BEGIN
		SET @Msg = 'Your data is already with us!'
	END
	
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
		SET @Msg = @ErrorMessage
	END	CATCH
	
	SELECT @Msg 'Message', @IsValid 'IsValid', @Pan 'Pan', @EntryId 'EntryId', @FirstName 'FirstName', @MiddleName 'MiddleName', @LastName 'LastName', @IsARN 'IsARN'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_MFSB_SessionKey_Update
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 29th Aug 2020
-- Description:	sessionkey updateion
-- =============================================
CREATE PROCEDURE [dbo].[spx_MFSB_SessionKey_Update]
	@Pan VARCHAR(15)
	,@SessionKey VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Msg varchar(200) = '', @IsValid BIT = 0 
	, @CreatedAt datetime = NULL
	, @Today datetime = getdate()	
	BEGIN TRY 	
	Declare @GeneratedOtp varchar(10) = '';	
	IF EXISTS (SELECT 1 FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE Pan = @Pan)
	BEGIN
		UPDATE TBL_MFSB_Registration 
		SET SessionKey = @SessionKey
		,ModifyDate = GETDATE()
		WHERE Pan = @Pan
		
		SET @Msg = 'Session key successfully updated!'
		SET @IsValid = 1
	END
	ELSE
	BEGIN
		SET @Msg = 'Entered details not registered with us!';
	END
	
	END TRY 
	BEGIN CATCH				
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT,@ErrorState INT
				,@ErrorNumber INT,@ErrorLine INT                                    

		SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY()
		,@ErrorState = ERROR_STATE(),@ErrorNumber=ERROR_NUMBER(),@ErrorLine=ERROR_LINE();
		 
		SET @Msg = @ErrorMessage
	END	CATCH
	
	SELECT @Msg 'Message', @IsValid 'IsValid'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ADDRESS
-- --------------------------------------------------




CREATE PROC [dbo].[USP_ADDRESS]

	@ENTRYID int=0,

	@ADDRESS1 varchar (200)='',

	@ADDRESS2 varchar (200)='',

	@ADDRESS3 varchar (200)='',

	@AREA varchar (50)='',

	@CITY varchar (50)='',

	@EMAIL varchar (50)='',

	@MOBILE varchar (50)='',

	@PHONE varchar (50)='',

	@PIN varchar (50)='',

	@STATE varchar (50)='',

	@STD varchar (50)='',

	@ISPERMANENT bit =0,

	@SAMEASCORR BIT =0





AS BEGIN



BEGIN TRY



IF NOT EXISTS (SELECT ENTRYID FROM TBL_ADDRESS WHERE ENTRYID=@ENTRYID AND ISPERMANENT= @ISPERMANENT)

BEGIN



             DECLARE @CNT AS INT=0



			SELECT @CNT= COUNT(1) FROM [INTRANET].RISK.DBO.EMP_INFO where EMAIL=@EMAIL OR PHONE =@mobile  

			

			



			IF(@CNT > 0 and @ISPERMANENT=0)

			BEGIN



			SELECT -1  AS ENTRYID, 'NOT ALLOWED FOR ANGEL EMPLOYES' AS [MESSAGE] 



			END

			ELSE 

			BEGIN



			INSERT INTO TBL_ADDRESS(ENTRYID,ADDRESS1,ADDRESS2,ADDRESS3,AREA,CITY,EMAIL,MOBILE,PHONE,PIN,STATE,STD,ISPERMANENT,SAMEASCORR)

			VALUES (@ENTRYID,@ADDRESS1,@ADDRESS2,@ADDRESS3,@AREA,@CITY,@EMAIL,@MOBILE,@PHONE,@PIN,@STATE,@STD,@ISPERMANENT,@SAMEASCORR)



			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



			END



	



END



ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))

			BEGIN



			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



END



ELSE

BEGIN 



SELECT @CNT= COUNT(1) FROM [INTRANET].RISK.DBO.EMP_INFO where EMAIL=@EMAIL OR PHONE =@mobile

			

			



			IF(@CNT > 0 and @ISPERMANENT=0)

			BEGIN



			SELECT -1  AS ENTRYID, 'NOT ALLOWED FOR ANGEL EMPLOYES' AS [MESSAGE] 



			END

			ELSE 

			BEGIN



			    UPDATE TBL_ADDRESS 

				SET 

				ADDRESS1=@ADDRESS1  ,

				ADDRESS2=@ADDRESS2  ,

				ADDRESS3=@ADDRESS3 , 

				AREA=@AREA  ,

				CITY=@CITY  ,

				EMAIL=@EMAIL  ,

				MOBILE=@MOBILE  ,

				PHONE=@PHONE  ,

				PIN=@PIN  ,

				STATE=@STATE , 

				STD=@STD ,

				SAMEASCORR=@SAMEASCORR

				WHERE ENTRYID=@ENTRYID  AND ISPERMANENT=@ISPERMANENT



				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



			   



			END





  

END



END TRY

		BEGIN CATCH

		         SELECT -1  AS ENTRYID, ERROR_MESSAGE() AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AGREEDDEPOSITS
-- --------------------------------------------------
CREATE PROC [dbo].[USP_AGREEDDEPOSITS]

@ENTRYID  AS INT =0,
@CASHAGREEDDEPOSIT  AS VARCHAR(50)='',
@INTERMEDIARY  AS VARCHAR(50)='',
@NONCASHAGREEDDEPOSIT  AS VARCHAR(50)='',
@NOTES  AS VARCHAR(200)='',
@VERTICAL  AS VARCHAR(50)=''

AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@ENTRYID)
BEGIN
		INSERT INTO TBL_AGREEDDEPOSITS(ENTRYID,CASHAGREEDDEPOSIT,INTERMEDIARY,NONCASHAGREEDDEPOSIT,NOTES,VERTICAL)
		VALUES (@ENTRYID,@CASHAGREEDDEPOSIT,@INTERMEDIARY,@NONCASHAGREEDDEPOSIT,@NOTES,@VERTICAL)

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_AGREEDDEPOSITS 
				SET 
				CASHAGREEDDEPOSIT=@CASHAGREEDDEPOSIT  ,
				INTERMEDIARY=@INTERMEDIARY  ,
				NONCASHAGREEDDEPOSIT=@NONCASHAGREEDDEPOSIT , 
				NOTES=@NOTES  ,
				VERTICAL=@VERTICAL  
			
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BANKDETAILS
-- --------------------------------------------------


CREATE PROC [dbo].[USP_BANKDETAILS]
@ENTRYID  INT=0,
@ACCOUNTNO VARCHAR(50)='',
@ACCOUNTTYPE VARCHAR(10)='',
@ADDRESS VARCHAR(500)='',
@BANKNAME VARCHAR(100)='',
@BRANCH VARCHAR(50)='',
@IFSCRGTS VARCHAR(50)='',
@MICR VARCHAR(50)='',
@NAMEINBANK VARCHAR(100)='',
@ISCOMMODITY BIT=0,
@sameAs bit=0

AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_BANKDETAILS WHERE ENTRYID=@ENTRYID AND ISCOMMODITY=@ISCOMMODITY)
BEGIN
		INSERT INTO TBL_BANKDETAILS(ENTRYID,ACCOUNTNO,ACCOUNTTYPE,[ADDRESS],BANKNAME,BRANCH,IFSCRGTS,MICR,NAMEINBANK,ISCOMMODITY,sameAs)
		VALUES (@ENTRYID,@ACCOUNTNO,@ACCOUNTTYPE,@ADDRESS,@BANKNAME,@BRANCH,@IFSCRGTS,@MICR,@NAMEINBANK,@ISCOMMODITY,@sameAs)

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_BANKDETAILS 
				SET 
				ACCOUNTNO=@ACCOUNTNO  ,
				ACCOUNTTYPE=@ACCOUNTTYPE  ,
				[ADDRESS]=@ADDRESS , 
				BANKNAME=@BANKNAME  ,
				BRANCH=@BRANCH  ,
				IFSCRGTS=@IFSCRGTS  ,
				MICR =@MICR  ,
				NAMEINBANK=@NAMEINBANK  ,
				ISCOMMODITY=@ISCOMMODITY ,
				sameAs=@sameAs
				
				WHERE ENTRYID=@ENTRYID AND ISCOMMODITY=@ISCOMMODITY

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BASICDETAILS
-- --------------------------------------------------
CREATE PROC [dbo].[USP_BASICDETAILS]



@ENTRYID  AS INT =0,

@FATHERFIRSTNAME  AS VARCHAR(100)='',

@FATHERLASTNAME  AS VARCHAR(100)='',

@FATHERMIDDLENAME  AS VARCHAR(100)='',

@FIRSTNAME  AS VARCHAR(100)='',

@GENDER  AS VARCHAR(10)='',

@HUSBANDFIRSTNAME  AS VARCHAR(100)='',

@HUSBANDLASTNAME  AS VARCHAR(100)='',

@HUSBANDMIDDLENAME  AS VARCHAR(100)='',

@INCORPORATIONDATE  AS VARCHAR(100)='',

@INTERMEDIARYBRANCH  AS VARCHAR(100)='',

@INTERMEDIARYCODE  AS VARCHAR(100)='',

@INTERMEDIARYEMPLOYEE  AS VARCHAR(100)='',

@INTERMEDIARYNAME  AS VARCHAR(100)='',

@INTERMEDIARYTYPE  AS VARCHAR(100)='',

@LASTNAME  AS VARCHAR(100)='',

@MARTIALSTATUS  AS VARCHAR(100)='',

@MIDDLENAME  AS VARCHAR(100)='',

@PARENT  AS VARCHAR(100)='',

@REGION  AS VARCHAR(100)='',

@RELATIONSHIPMGR  AS VARCHAR(100)='',

@TRADENAME  AS VARCHAR(100)='',

@TRADENAMECOMM  AS VARCHAR(100)='',

@ZONE  AS VARCHAR(100)=''



AS BEGIN



BEGIN TRY



IF NOT EXISTS (SELECT ENTRYID FROM TBL_BASICDETAILS WHERE ENTRYID=@ENTRYID)

BEGIN



    ----Check intermediaryBranch

	        DECLARE @CNT AS INT=0



			SELECT @CNT= COUNT(1) FROM [CSOKYC-6].GENERAL.DBO.BO_REGION where Branch_Code=@intermediaryBranch



			IF(@CNT=0)

			BEGIN

			SELECT @CNT= COUNT(1) FROM [CSOKYC-6].GENERAL.DBO.VW_RMS_SB_VERTICAL  WHERE SB=@INTERMEDIARYBRANCH

			END



			IF(@CNT=0)

			BEGIN



			SELECT -1  AS ENTRYID, 'INVALID INTERMEDIARY BRANCH' AS [MESSAGE] 



			END

			ELSE

			BEGIN



			INSERT INTO TBL_BASICDETAILS(ENTRYID,FATHERFIRSTNAME,FATHERLASTNAME,FATHERMIDDLENAME,FIRSTNAME,GENDER,HUSBANDFIRSTNAME,HUSBANDLASTNAME,HUSBANDMIDDLENAME,INCORPORATIONDATE,INTERMEDIARYBRANCH,INTERMEDIARYCODE,INTERMEDIARYEMPLOYEE,INTERMEDIARYNAME,INTERMEDIARYTYPE,LASTNAME,MARTIALSTATUS,MIDDLENAME,PARENT,REGION,RELATIONSHIPMGR,TRADENAME,TRADENAMECOMM,ZONE)

		    VALUES (@ENTRYID,@FATHERFIRSTNAME,@FATHERLASTNAME,@FATHERMIDDLENAME,@FIRSTNAME,@GENDER,@HUSBANDFIRSTNAME,@HUSBANDLASTNAME,@HUSBANDMIDDLENAME,@INCORPORATIONDATE,@INTERMEDIARYBRANCH,@INTERMEDIARYCODE,@INTERMEDIARYEMPLOYEE,@INTERMEDIARYNAME,@INTERMEDIARYTYPE,@LASTNAME,@MARTIALSTATUS,@MIDDLENAME,@PARENT,@REGION,@RELATIONSHIPMGR,@TRADENAME,@TRADENAMECOMM,@ZONE)



		    SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



			END

			

 



		



END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))

BEGIN



			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



END

ELSE

BEGIN 





		SELECT @CNT= COUNT(1) FROM [CSOKYC-6].GENERAL.DBO.BO_REGION where Branch_Code=@intermediaryBranch



			IF(@CNT=0)

			BEGIN

			SELECT @CNT= COUNT(1) FROM [CSOKYC-6].GENERAL.DBO.VW_RMS_SB_VERTICAL  WHERE SB=@INTERMEDIARYBRANCH

			END



			IF(@CNT=0)

			BEGIN



			SELECT -1  AS ENTRYID, 'INVALID INTERMEDIARY BRANCH' AS [MESSAGE] 



			END

			ELSE

			BEGIN



                UPDATE TBL_BASICDETAILS 

				SET 

				FATHERFIRSTNAME=@FATHERFIRSTNAME  ,

				FATHERLASTNAME=@FATHERLASTNAME  ,

				FATHERMIDDLENAME=@FATHERMIDDLENAME , 

				FIRSTNAME=@FIRSTNAME  ,

				GENDER=@GENDER  ,

				HUSBANDFIRSTNAME=@HUSBANDFIRSTNAME  ,

				HUSBANDLASTNAME=@HUSBANDLASTNAME  ,

				HUSBANDMIDDLENAME=@HUSBANDMIDDLENAME  ,

				INCORPORATIONDATE=@INCORPORATIONDATE  ,

				INTERMEDIARYBRANCH=@INTERMEDIARYBRANCH , 

				INTERMEDIARYCODE=@INTERMEDIARYCODE  ,

				INTERMEDIARYEMPLOYEE=@INTERMEDIARYEMPLOYEE  ,

				INTERMEDIARYNAME=@INTERMEDIARYNAME  ,

				INTERMEDIARYTYPE=@INTERMEDIARYTYPE  ,

				LASTNAME=@LASTNAME  ,

				MARTIALSTATUS=@MARTIALSTATUS,  

				MIDDLENAME=@MIDDLENAME  ,

				PARENT=@PARENT  ,

				REGION=@REGION  ,

				RELATIONSHIPMGR=@RELATIONSHIPMGR , 

				TRADENAME=@TRADENAME  ,

				TRADENAMECOMM=@TRADENAMECOMM  ,

				ZONE=@ZONE 

				WHERE ENTRYID=@ENTRYID 



				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



			END





       

END



END TRY

		BEGIN CATCH

		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CASHDEPOSITS
-- --------------------------------------------------
/*
USP_CASHDEPOSITS 57,'dbdnj3728','955905','Client Bank Account','29-5-2017','Cheque','Confirmed','','ffnn','nnn','nnn','nnn','BSE CURRENCY','','','','',false,1
*/

CREATE PROC [dbo].[USP_CASHDEPOSITS]
	@ENTRYID   int=0,
	@ACCOUNTNO   varchar(50)='',
	@AMOUNT   varchar(100) ='',
	@BROKERBANKACC   varchar(100) ='',
	@DATE   varchar(50)='',
	@DEPOSITMODE   varchar(50)='',
	@DEPOSITTRANSACTIONSTATUS   varchar(50)='',
	@FORMOFDEPOSIT   varchar(50)='',
	@INSTRUMENTNO   varchar(50)='',
	@INTERMBANKACC   varchar(50)='',
	@INTERMEDIARY   varchar(50)='',
	@REMARKS   varchar(200) ='',
	@SEGMENT   varchar(50)='',
	@TYPE   varchar(50)='',
	@VERTICAL   varchar(50)='',
	@VOUCHERNO   varchar(50)='',
	@VOUCHERTYPE   varchar(50)='',
	@ISNONCASH BIT=0,
	@isDeposit BIT=0,
	@SAMEAS BIT=0,
    @SEGMENTADD VARCHAR(100)='',
    @DEPOSITMODEADD VARCHAR(100)='',
    @DEPOSITTRNSTATUSADD VARCHAR(100)='',
    @AMOUNTADD VARCHAR(100)='',
    @INSTRUMENTNOADD VARCHAR(100)='',
    @DATEADD VARCHAR(100)='',
    @REMARKSADD VARCHAR(100)='',
	@SEGMENTNSE VARCHAR(100)='',
    @DEPOSITMODENSE VARCHAR(100)='',
    @DEPOSITTRNSTATUSNSE VARCHAR(100)='',
    @AMOUNTNSE VARCHAR(100)='',
    @INSTRUMENTNONSE VARCHAR(100)='',
    @DATENSE VARCHAR(100)='',
       @REMARKSNSE VARCHAR(100)='',
       @SEGMENTMCX VARCHAR(100)='',
       @DEPOSITMODEMCX VARCHAR(100)='',
       @DEPOSITTRNSTATUSMCX VARCHAR(100)='',
       @AMOUNTMCX VARCHAR(100)='',
       @INSTRUMENTNOMCX VARCHAR(100)='',
       @DATEMCX VARCHAR(100)='',
       @REMARKSMCX VARCHAR(100)='',
     @SAMEASABOVE BIT,

		@SEGMENTNCDEX AS VARCHAR(100)='',
		@DEPOSITMODENCDEX AS VARCHAR(100)='',
		@DEPOSITTRNSTATUSNCDEX AS VARCHAR(100)='',
		@AMOUNTNCDEX AS VARCHAR(100)='',
		@INSTRUMENTNONCDEX AS VARCHAR(100)='',
		@DATENCDEX AS VARCHAR(100)='',
		@REMARKSNCDEX AS VARCHAR(100)='',
		@SAMEASMCX AS BIT=0

AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_CASHDEPOSITS WHERE ENTRYID=@ENTRYID and isDeposit = @isDeposit)
BEGIN
print 1
		INSERT INTO TBL_CASHDEPOSITS(ENTRYID,ACCOUNTNO,AMOUNT,BROKERBANKACC,DATE,DEPOSITMODE,DEPOSITTRANSACTIONSTATUS,FORMOFDEPOSIT,INSTRUMENTNO,INTERMBANKACC,INTERMEDIARY,REMARKS,SEGMENT,TYPE,VERTICAL,VOUCHERNO,VOUCHERTYPE,ISNONCASH,isDeposit, SAMEAS,SEGMENTADD, DEPOSITMODEADD , DEPOSITTRNSTATUSADD,AMOUNTADD , INSTRUMENTNOADD ,DATEADD ,REMARKSADD,
		SEGMENTNSE, DEPOSITMODENSE,DEPOSITTRNSTATUSNSE ,AMOUNTNSE,INSTRUMENTNONSE,DATENSE,REMARKSNSE ,SEGMENTMCX,DEPOSITMODEMCX ,DEPOSITTRNSTATUSMCX ,AMOUNTMCX,INSTRUMENTNOMCX ,DATEMCX ,REMARKSMCX ,SAMEASABOVE,SEGMENTNCDEX,DEPOSITMODENCDEX,DEPOSITTRNSTATUSNCDEX,AMOUNTNCDEX,INSTRUMENTNONCDEX,DATENCDEX,REMARKSNCDEX,SAMEASMCX )
		VALUES (@ENTRYID,@ACCOUNTNO,@AMOUNT,@BROKERBANKACC,@DATE,@DEPOSITMODE,@DEPOSITTRANSACTIONSTATUS,@FORMOFDEPOSIT,@INSTRUMENTNO,@INTERMBANKACC,@INTERMEDIARY,@REMARKS,@SEGMENT,@TYPE,@VERTICAL,@VOUCHERNO,@VOUCHERTYPE,@ISNONCASH,@isDeposit,  @SAMEAS,@SEGMENTADD, @DEPOSITMODEADD , @DEPOSITTRNSTATUSADD,@AMOUNTADD , @INSTRUMENTNOADD ,@DATEADD ,@REMARKSADD,
		@SEGMENTNSE, @DEPOSITMODENSE,@DEPOSITTRNSTATUSNSE ,@AMOUNTNSE,@INSTRUMENTNONSE,@DATENSE,@REMARKSNSE ,@SEGMENTMCX,@DEPOSITMODEMCX ,@DEPOSITTRNSTATUSMCX ,@AMOUNTMCX,@INSTRUMENTNOMCX ,@DATEMCX ,@REMARKSMCX ,@SAMEASABOVE,@SEGMENTNCDEX,@DEPOSITMODENCDEX,@DEPOSITTRNSTATUSNCDEX,@AMOUNTNCDEX,@INSTRUMENTNONCDEX,@DATENCDEX,@REMARKSNCDEX,@SAMEASMCX )

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN
print 2
			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE
BEGIN 
print 3
                UPDATE TBL_CASHDEPOSITS 
				SET 
				ACCOUNTNO=@ACCOUNTNO,
				AMOUNT=@AMOUNT,
				BROKERBANKACC=@BROKERBANKACC,
				DATE=@DATE,
				DEPOSITMODE=@DEPOSITMODE,
				DEPOSITTRANSACTIONSTATUS=@DEPOSITTRANSACTIONSTATUS,
				FORMOFDEPOSIT=@FORMOFDEPOSIT,
				INSTRUMENTNO=@INSTRUMENTNO,
				INTERMBANKACC=@INTERMBANKACC,
				INTERMEDIARY=@INTERMEDIARY,
				REMARKS=@REMARKS,
				SEGMENT=@SEGMENT,
				TYPE=@TYPE,
				VERTICAL=@VERTICAL,
				VOUCHERNO=@VOUCHERNO,
				VOUCHERTYPE=@VOUCHERTYPE,
				isDeposit=@isDeposit,
				SAMEAS=@sameAs, 
				SEGMENTADD=@SEGMENTADD,
				DEPOSITMODEADD=@DEPOSITMODEADD ,
				DEPOSITTRNSTATUSADD= @DEPOSITTRNSTATUSADD,
				AMOUNTADD=@AMOUNTADD ,
				INSTRUMENTNOADD= @INSTRUMENTNOADD ,
				[DATEADD]=@DATEADD ,
				REMARKSADD=@REMARKSADD,
				SEGMENTNSE =@SEGMENTNSE,
				DEPOSITMODENSE =@DEPOSITMODENSE,
				DEPOSITTRNSTATUSNSE =@DEPOSITTRNSTATUSNSE,
				AMOUNTNSE =@AMOUNTNSE,
				INSTRUMENTNONSE =@INSTRUMENTNONSE,
				DATENSE =@DATENSE,
				REMARKSNSE =@REMARKSNSE,
				SEGMENTMCX =@SEGMENTMCX,
				DEPOSITMODEMCX =@DEPOSITMODEMCX,
				DEPOSITTRNSTATUSMCX =@DEPOSITTRNSTATUSMCX,
				AMOUNTMCX =@AMOUNTMCX,
				INSTRUMENTNOMCX =@INSTRUMENTNOMCX,
				DATEMCX =@DATEMCX,
				REMARKSMCX = @REMARKSMCX,
				SAMEASABOVE =@SAMEASABOVE,
				SEGMENTNCDEX=@SEGMENTNCDEX,
				DEPOSITMODENCDEX=@DEPOSITMODENCDEX,
				DEPOSITTRNSTATUSNCDEX=@DEPOSITTRNSTATUSNCDEX,
				AMOUNTNCDEX=@AMOUNTNCDEX,
				INSTRUMENTNONCDEX=@INSTRUMENTNONCDEX,
				DATENCDEX=@DATENCDEX,
				REMARKSNCDEX=@REMARKSNCDEX,
				SAMEASMCX=@SAMEASMCX
						
				WHERE ENTRYID=@ENTRYID  and isDeposit = @isDeposit

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_DeleteEntryID
-- --------------------------------------------------

/*

SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = 7

EXEC usp_DeleteEntryID  700

SELECT * From TBL_MF_IDENTITYDETAILS_LOG

*/

CREATE PROC [dbo].[usp_DeleteEntryID] 
(
@entryID INT
)
AS 

DECLARE @vault  varchar (400)  = 'Vault Key does not exists'
DECLARE @exists varchar (40) 

BEGIN TRAN

IF (Exists(SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = @entryID))
BEGIN 

	INSERT INTO TBL_MF_IDENTITYDETAILS_LOG
	SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = @entryID

	SELECT @vault = AadharVaultKey FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = @entryID

	DELETE FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = @entryID

	 SELECT 'Success' AS Result, @vault AS AadharVault

END 
ELSE 
BEGIN 
	SELECT 'Failed' AS Result, @vault AS AadharVault
END 


-- select * from TBL_MF_IDENTITYDETAILS WHERE ENTRYID  = @entryID
-- ROLLBACK TRAN 

  COMMIT TRan

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DOCUMENTSUPLOAD
-- --------------------------------------------------
CREATE PROC [dbo].[USP_DOCUMENTSUPLOAD]
@PROCESS AS VARCHAR(50)='',
@ID AS INT=0,
@ENTRYID INT =0,
@FILENAME AS VARCHAR(100)='',
@PATH AS VARCHAR(200)='',
@ISDELETE AS INT=0,
@DOCTYPE AS VARCHAR(50)='',
@EXCHANGE AS VARCHAR(50)=''

AS BEGIN

BEGIN TRY

   IF @PROCESS ='DELETE'
	BEGIN
	        UPDATE tbl_DOCUMENTSUPLOAD
			SET ISDELETE=1
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]

			UPDATE A
			SET A.ISDELETE =1
			FROM  TBL_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND ID =@ID)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE

	END

	 IF @PROCESS ='DELETE PDF'
	BEGIN
	        UPDATE tbl_DOCUMENTSUPLOAD_PDF
			SET ISDELETE=1
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]
	END

	IF @PROCESS='ADD'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN


	IF @EXCHANGE= 'Individual'
	BEGIN

	DELETE FROM tbl_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Proprietor' AND ENTRYID=@ENTRYID

	END

	ELSE IF(@EXCHANGE= 'Proprietor')
	BEGIN

	DELETE FROM tbl_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Individual' AND ENTRYID=@ENTRYID

	END

	INSERT INTO tbl_DOCUMENTSUPLOAD
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	

	END
	ELSE
	BEGIN


	        DECLARE @IDS AS INT =0

			SELECT @IDS =ID FROM tbl_DOCUMENTSUPLOAD 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

	        UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

	

	END


	IF @PROCESS='ADD PDF'
	BEGIN
	IF NOT EXISTS (SELECT ENTRYID FROM TBL_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN

	INSERT INTO TBL_DOCUMENTSUPLOAD_PDF
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	END
	ELSE
	BEGIN
	SELECT @IDS =ID FROM TBL_DOCUMENTSUPLOAD_PDF 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

	        UPDATE TBL_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END
	END



	IF @PROCESS='UPDATE'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


		IF @PROCESS='UPDATE PDF'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


	IF @PROCESS='GET PDF FILE'
	BEGIN
	SELECT * FROM (SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND DOCTYPE NOT IN ('AFFIDAVIT','MOU') ) A
			WHERE A.DOCTYPE NOT LIKE '%AGREEMENT'

	END


	IF @PROCESS='GET AFTER ESIGN PDF FILE'
	BEGIN
	--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )

	        SELECT * 
            FROM  TBL_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND (DOCTYPE IN ('AFFIDAVIT','MOU') OR DOCTYPE LIKE '%AGREEMENT' ) AND ISDELETE =0)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE
			WHERE A.ISDELETE =0 and A.ENTRYID=@ENTRYID
	END


    IF @PROCESS='ADD COMBINE FILE'
	BEGIN

	UPDATE TBL_DOCUMENTSUPLOADFINAL_PDF
	SET ISDELETE=1
	WHERE ENTRYID =@ENTRYID AND DOCTYPE=@DOCTYPE

	INSERT INTO TBL_DOCUMENTSUPLOADFINAL_PDF
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

END TRY

		BEGIN CATCH

		SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DOCUMENTSUPLOAD_04052017
-- --------------------------------------------------
CREATE PROC [dbo].[USP_DOCUMENTSUPLOAD_04052017]
@PROCESS AS VARCHAR(50)='',
@ID AS INT=0,
@ENTRYID INT =0,
@FILENAME AS VARCHAR(100)='',
@PATH AS VARCHAR(200)='',
@ISDELETE AS INT=0,
@DOCTYPE AS VARCHAR(50)='',
@EXCHANGE AS VARCHAR(50)=''

AS BEGIN

BEGIN TRY

   IF @PROCESS ='DELETE'
	BEGIN
	        UPDATE tbl_DOCUMENTSUPLOAD
			SET ISDELETE=1
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]
	END

	IF @PROCESS='ADD'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0)
	BEGIN

	INSERT INTO tbl_DOCUMENTSUPLOAD
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT @ENTRYID  AS ENTRYID, 'UPLOAD SUCCESSFULLY.' AS [MESSAGE]

	END
	ELSE
	BEGIN
	        UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0

			SELECT @ENTRYID  AS ENTRYID, 'FILE UPDATED SUCCESSFULLY.' AS [MESSAGE]
	END

	

	END

	IF @PROCESS='UPDATE'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE UPDATED SUCCESSFULLY.' AS [MESSAGE]
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END

END TRY

		BEGIN CATCH

		SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DOCUMENTSUPLOAD02062017
-- --------------------------------------------------
create PROC [dbo].[USP_DOCUMENTSUPLOAD02062017]
@PROCESS AS VARCHAR(50)='',
@ID AS INT=0,
@ENTRYID INT =0,
@FILENAME AS VARCHAR(100)='',
@PATH AS VARCHAR(200)='',
@ISDELETE AS INT=0,
@DOCTYPE AS VARCHAR(50)='',
@EXCHANGE AS VARCHAR(50)=''

AS BEGIN

BEGIN TRY

   IF @PROCESS ='DELETE'
	BEGIN
	        UPDATE tbl_DOCUMENTSUPLOAD
			SET ISDELETE=1
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]
	END

	IF @PROCESS='ADD'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN

	INSERT INTO tbl_DOCUMENTSUPLOAD
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	

	END
	ELSE
	BEGIN


	DECLARE @IDS AS INT =0

			SELECT @IDS =ID FROM tbl_DOCUMENTSUPLOAD 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0

	        UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

	

	END

	IF @PROCESS='UPDATE'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END

END TRY

		BEGIN CATCH

		SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Exception
-- --------------------------------------------------
create proc [dbo].[USP_Exception]  
@process varchar(20)='',  
@Id int=0,  
@Source varchar(30)='',  
@Message varchar(300)='',  
@StackTrace varchar(1000) ='',  
@UserId varchar(50)='',  
@OccuredOn datetime=null,  
@Isresolved bit=0,  
@ResolvedBy varchar(50)='',  
@ResolvedOn datetime=null  
as begin  
      
 If (@process='Add Error')  
 begin  
 INSERT INTO [tbl_Exception_log] ([Source],[Message],[StackTrace],[UserId],[OccuredOn],[Isresolved],[ResolvedBy],[ResolvedOn])  
 VALUES(@Source,@Message,@StackTrace,@UserId,getdate(),0,NULL,NULL)  
 end  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FINDINUSP
-- --------------------------------------------------

    
create  PROCEDURE [dbo].[USP_FINDINUSP]                  
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
-- PROCEDURE dbo.USP_GEN_TAG
-- --------------------------------------------------
/*

USP_GEN_TAG 13

*/



CREATE PROCEDURE [DBO].[USP_GEN_TAG] (@APRREFNO AS VARCHAR(15))

AS

BEGIN



		if(exists( select * from TBL_BASICDETAILS where ENTRYID = @APRREFNO and  ISNULL(sbtag,'')<>''))

		begin

	

					select sbtag from TBL_BASICDETAILS where ENTRYID = @APRREFNO 

					PRINT('EXIST')

		end

		else 

		begin 

			PRINT('NEW')

			DECLARE @COUNT INT = 1,@INDEX2 INT = 1;

			DECLARE @RANDOMID VARCHAR(32)

			DECLARE @COUNTER SMALLINT

			DECLARE @RANDOMNUMBER FLOAT

			DECLARE @RANDOMNUMBERINT INT

			DECLARE @CURRENTCHARACTER VARCHAR(1)

			DECLARE @VALIDCHARACTERS VARCHAR(255)



			SET @VALIDCHARACTERS = (

			SELECT TRADENAME

			FROM TBL_BASICDETAILS

			WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO

			)



			DECLARE @PINDEX INT;



			WHILE (1 = 1)

			BEGIN

			SET @PINDEX = PATINDEX('%[^A-Z]%', @VALIDCHARACTERS)



			IF (@PINDEX > 0)

			SET @VALIDCHARACTERS = STUFF(@VALIDCHARACTERS, @PINDEX, 1, '')

			ELSE

			BREAK;

			END



			LABLEL1:



			DECLARE @VALIDCHARACTERSLENGTH INT;

			DECLARE @INDEX INT = 0;

			SET @VALIDCHARACTERSLENGTH = LEN(@VALIDCHARACTERS)

			SET @CURRENTCHARACTER = ''

			SET @RANDOMNUMBER = 0

			SET @RANDOMNUMBERINT = 0

			SET @RANDOMID = ''

			SET NOCOUNT ON

			SET @COUNTER = 1

			SET @INDEX = @COUNT;



			WHILE @COUNTER < = (3)

			BEGIN

			SET @CURRENTCHARACTER = SUBSTRING(@VALIDCHARACTERS, @INDEX, 1)



			IF (@COUNT >= @VALIDCHARACTERSLENGTH)

			BEGIN

			SET @CURRENTCHARACTER = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @INDEX2, 1)

			SET @INDEX2 = @INDEX2 + 1;

			END



			SET @RANDOMID = @RANDOMID + @CURRENTCHARACTER

			SET @COUNTER = @COUNTER + 1

			SET @INDEX = @INDEX + 1;



			IF (@COUNTER = 3)

			BEGIN

			SET @RANDOMID = LEFT(@VALIDCHARACTERS, 1) + @RANDOMID

			END

			END



			IF EXISTS (

			SELECT SBTAG

			FROM [MIS].SB_COMP.DBO.[SB_BROKER]

			WHERE SBTAG = @RANDOMID

			)

			BEGIN

			SET @COUNT = @COUNT + 1;



			GOTO LABLEL1;

			END

			ELSE

			SELECT UPPER(@RANDOMID) AS TAG



		END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GENERATE_TAG
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[USP_GENERATE_TAG]  

(  

 @APRREFNO AS VARCHAR(15)  

)  

  

AS  

  

DECLARE @RANDOMID VARCHAR(32)  

DECLARE @COUNTER SMALLINT  

DECLARE @RANDOMNUMBER FLOAT  

DECLARE @RANDOMNUMBERINT TINYINT  

DECLARE @CURRENTCHARACTER VARCHAR(1)  

DECLARE @VALIDCHARACTERS VARCHAR(255)  

SET @VALIDCHARACTERS  = (SELECT LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(RIGHT(TRADENAME,(LEN(TRADENAME)-(CHARINDEX('.', TRADENAME)))),'/',''),'&',''),' ',''),'(',''),')',''),'.',''),10) AS APRNAME FROM TBL_BASICDETAILS WHERE CAST ( ENTRYID AS
 VARCHAR(50)) = @APRREFNO)        

            

  

DECLARE @VALIDCHARACTERSLENGTH INT  

SET @VALIDCHARACTERSLENGTH = LEN(@VALIDCHARACTERS)  

SET @CURRENTCHARACTER = ''  

SET @RANDOMNUMBER = 0  

SET @RANDOMNUMBERINT = 0  

SET @RANDOMID = ''  

  

SET NOCOUNT ON  

  

SET @COUNTER = 1  

  

WHILE @COUNTER < (3)  

  

BEGIN  

  

        SET @RANDOMNUMBER = RAND()  

        SET @RANDOMNUMBERINT = CONVERT(TINYINT, ((@VALIDCHARACTERSLENGTH - 1) * @RANDOMNUMBER + 1))  

  

        SELECT @CURRENTCHARACTER = SUBSTRING(@VALIDCHARACTERS, @RANDOMNUMBERINT, 1)  

  

        SET @COUNTER = @COUNTER + 1  

  

        SET @RANDOMID = @RANDOMID + @CURRENTCHARACTER  

  SET @RANDOMID = LEFT(@VALIDCHARACTERS,1)+@RANDOMID   

  

END  

  

IF EXISTS (SELECT TOP 1 * FROM [MIS].SB_COMP.DBO.[SB_BROKER] WHERE SBTAG=@RANDOMID)            

BEGIN  

print @RANDOMID

EXEC USP_GENERATE_TAG @APRREFNO  

END  

ELSE  

SELECT @RANDOMID AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Get_MfSbRegistrationData
-- --------------------------------------------------
CREATE proc Usp_Get_MfSbRegistrationData(  
@option int,  
@FromDate varchar(20),  
@ToDate varchar(20)  )
as  
begin  

   
 select convert(varchar(20),a.ENTRY_DATE,101)'Entry Date',a.SBTAG,d.FirstName+space(1)+d.MiddleName+space(1)+d.LastName'ARN Name',a.pan 'PAN NUMBER',b.OrganizationType,d.ARN_Number,d.ARN_FromDate 'VALIDITY FROM',d.ARN_ToDate 'VALIDITY TO',d.EUINumber
 ,c.BANKNAME,c.ACCOUNTNO 'Bank Account No',c.BRANCH 'Bank Branch',c.IFSCRGTS 'Bank IFSC Code',c.MICR 'Bank MICR',c.ADDRESS,e.FirstName+space(1)+e.MiddleName+space(1)+e.LastName 'Nominee Name',e.PanNumber 'Nominee PAN',
 e.RelationShip 'Nominee Relatonship',e.AddressLine1+space(1)+e.AddressLine2+space(1)+e.AddressLine3 'Nominee Address'  
 from TBL_MF_IDENTITYDETAILS a  
 inner join TBL_MF_BASICDETAILS b on a.entryid=b.entryid  
 inner join TBL_MF_BANKDETAILS c on a.entryid=c.ENTRYID  
 inner join TBL_MF_ARNDetails d on a.entryid=d.EntryID  
 inner join TBL_MF_NomineeDetails e on a.entryid=e.EntryId  
 where a.ISAPPROVED=@option   
 and a.ENTRY_DATE>=Convert(datetime,@FromDate,103) and a.ENTRY_DATE<=convert(datetime,(@ToDate +' 23:50:50'),103)
 --and convert(varchar(20),a.ENTRY_DATE,103)>=convert(varchar(20),@FromDate,103)  
 --and convert(varchar(20),a.ENTRY_DATE,103) <=convert(varchar(20),@ToDate,103)  
 order by convert(varchar(20),a.ENTRY_DATE,101)   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Get_MfSbRegistrationData_24feb2023
-- --------------------------------------------------
CREATE proc Usp_Get_MfSbRegistrationData_24feb2023(  
@option int,  
@FromDate varchar(20),  
@ToDate varchar(20)  )
as  
begin  
   
 select convert(varchar(20),a.ENTRY_DATE,101)'Entry Date',a.SBTAG,d.FirstName+space(1)+d.MiddleName+space(1)+d.LastName'ARN Name',a.pan 'PAN NUMBER',b.OrganizationType,d.ARN_Number,d.ARN_FromDate 'VALIDITY FROM',d.ARN_ToDate 'VALIDITY TO',d.EUINumber
 ,c.BANKNAME,c.ACCOUNTNO 'Bank Account No',c.BRANCH 'Bank Branch',c.IFSCRGTS 'Bank IFSC Code',c.MICR 'Bank MICR',c.ADDRESS,e.FirstName+space(1)+e.MiddleName+space(1)+e.LastName 'Nominee Name',e.PanNumber 'Nominee PAN',
 e.RelationShip 'Nominee Relatonship',e.AddressLine1+space(1)+e.AddressLine2+space(1)+e.AddressLine3 'Nominee Address'  
 from TBL_MF_IDENTITYDETAILS a  
 inner join TBL_MF_BASICDETAILS b on a.entryid=b.entryid  
 inner join TBL_MF_BANKDETAILS c on a.entryid=c.ENTRYID  
 inner join TBL_MF_ARNDetails d on a.entryid=d.EntryID  
 inner join TBL_MF_NomineeDetails e on a.entryid=e.EntryId  
 where a.ISAPPROVED=@option   
 and a.ENTRY_DATE>=@FromDate and a.ENTRY_DATE<=@ToDate  
 --and convert(varchar(20),a.ENTRY_DATE,103)>=convert(varchar(20),@FromDate,103)  
 --and convert(varchar(20),a.ENTRY_DATE,103) <=convert(varchar(20),@ToDate,103)  
 order by convert(varchar(20),a.ENTRY_DATE,101)   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETAPPLICATIONDETAILS
-- --------------------------------------------------

-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 20-04-2017
-- DESCRIPTION:	USP_GETAPPLICATIONDETAILS
/*
USP_GETAPPLICATIONDETAILS 1
*/

-- =============================================


CREATE PROCEDURE [dbo].[USP_GETAPPLICATIONDETAILS]
	@ENTRYID INT 
AS
BEGIN
		SELECT ENTRYID,AADHAARNO,DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY FROM TBL_IDENTITYDETAILS AS TBL_IDENTITYDETAILS  WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,FATHERFIRSTNAME,FATHERLASTNAME,FATHERMIDDLENAME,FIRSTNAME,GENDER,HUSBANDFIRSTNAME,HUSBANDLASTNAME,
		HUSBANDMIDDLENAME,INCORPORATIONDATE,INTERMEDIARYBRANCH,INTERMEDIARYCODE,INTERMEDIARYEMPLOYEE,INTERMEDIARYNAME,INTERMEDIARYTYPE,
		LASTNAME,MARTIALSTATUS,MIDDLENAME,PARENT,REGION,RELATIONSHIPMGR,TRADENAME,TRADENAMECOMM,ZONE FROM TBL_BASICDETAILS WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,ACCOUNTNO,ACCOUNTTYPE,ADDRESS,BANKNAME,BRANCH,IFSCRGTS,MICR,NAMEINBANK,ISCOMMODITY FROM TBL_BANKDETAILS WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,ACCOUNTNO,AMOUNT,BROKERBANKACC,DATE,DEPOSITMODE,DEPOSITTRANSACTIONSTATUS,FORMOFDEPOSIT,INSTRUMENTNO,
		INTERMBANKACC,INTERMEDIARY,REMARKS,SEGMENT,TYPE,VERTICAL,VOUCHERNO,VOUCHERTYPE,ISNONCASH FROM TBL_CASHDEPOSITS WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,ADDRESS1,ADDRESS2,ADDRESS3,AREA,CITY,EMAIL,MOBILE,PHONE,PIN,STATE,STD,ISPERMANENT FROM TBL_ADDRESS WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,MAINOFFICE,INCOMERANGE,OFFICEFRONTFACING,OFFICEGROUNDFLOOR,SOCIALNETWORKING FROM TBL_INFRASTRUCTURE WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,AADHAARNO,EDUQUALI,OTHERQUALI,OCCUPATION,NATUREOFOCCUPATION,OTHEROCCUPATION,CAPITALMARKET,
		OTHEREXPERIENCE,PREBROKER,AUTHPERSON,WHETHERANY,MEMBERSHIPDETAILS,TRADINGACC,FATHERHUSBAND FROM TBL_REGISTRATIONRELATED WHERE ENTRYID =@ENTRYID


		SELECT ENTRYID,CASHAGREEDDEPOSIT,INTERMEDIARY,NONCASHAGREEDDEPOSIT,NOTES,VERTICAL FROM TBL_AGREEDDEPOSITS WHERE ENTRYID =@ENTRYID

		SELECT ENTRYID,BSECASH,NSECASH FROM TBL_SEGMENTS WHERE ENTRYID =@ENTRYID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETDATA
-- --------------------------------------------------


-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 10-04-2017
--USP_GETDATA 'INSERTSBTAG','ygen','1865'
-- =============================================


CREATE PROCEDURE [dbo].[USP_GETDATA]
@PROCESS VARCHAR(100),
@DATA1 VARCHAR(5000)='',
@DATA2 VARCHAR(500)='',
@DATA3 VARCHAR(500)='',
@DATA4 VARCHAR(500)='',
@DATA5 VARCHAR(500)='',
@DATA6 VARCHAR(500)='',
@DATA7 VARCHAR(500)='',
@DATA8 VARCHAR(500)='',
@DATA9 VARCHAR(500)='',
@DATA10 VARCHAR(500)='',
@DATA11 VARCHAR(500)=''
AS
BEGIN
	IF(@PROCESS = 'LOGINLOG')
	BEGIN
		INSERT INTO LOGIN_LOG(USERNAME,LOGIN_DATE,MESSAGE ) VALUES (@DATA1,GETDATE(),@DATA2)
	END
	
	IF(@PROCESS = 'INSERTSBTAG')
	BEGIN
			UPDATE TBL_BASICDETAILS
			SET SBTAG=@DATA1
			WHERE ENTRYID = @DATA2
			
			update TBL_IDENTITYDETAILS
			set ISAPPROVED = 6 
			where ENTRYID = @DATA2
			
			select ID,ENTRYID,FILENAME,
			replace(PATH,'\\10.253.6.118\ApplicationEsign\','http://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/') 
			
			as PATH ,ISDELETE,DOCTYPE,EXCHANGE,SOURCE from  TBL_ESIGNDOCUMENTS
			WHERE ENTRYID = @DATA2 and source = 'SBADMIN' and isdelete=0
			
			declare @ip varchar(100)
			select @ip  = ipAddress from tbl_sbapplicationlog 
			where entryid=@DATA2  and operation = 'CSO Esign Done'  and time  = (select MAX(time) as time from tbl_sbapplicationlog  where entryid=@DATA2  and operation = 'CSO Esign Done')
			
			--select @data2 , @ip
			exec USP_INHOUSE_INTEGRATION_live @data2 , @ip
			
	END
	
	IF(@PROCESS = 'GETCSOESIGN')
	BEGIN
			
			
			select ID,ENTRYID,FILENAME,
			replace(PATH,'\\10.253.6.118\ApplicationEsign\','http://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/') 
			
			as PATH ,ISDELETE,DOCTYPE,EXCHANGE,SOURCE from  TBL_ESIGNDOCUMENTS
			WHERE ENTRYID = @DATA2 and source = 'SBADMIN' and isdelete=0
			
	END
	
	
	--IF(@PROCESS = 'GET DOCUMETS AFTER SBADMIN ESIGN')
	--BEGIN
	--		select * from  TBL_ESIGNDOCUMENTS
	--		WHERE ENTRYID = @DATA1 and source = 'SBADMIN' and isdelete=0
	--END
	
	
	IF(@PROCESS = 'REJECTRECORD')
	BEGIN
		--INSERT INTO DBO.TBL_IDENTITYDETAILS(USERNAME,LOGIN_DATE,MESSAGE ) VALUES (@DATA1,GETDATE(),@DATA2)
		
		UPDATE DBO.TBL_IDENTITYDETAILS
		SET REMARK = @DATA1,
		APPROVE_DATE = GETDATE(),
		APPROVE_BY = @DATA2,
		ISAPPROVED = 2
		WHERE ENTRYID = @DATA3

		UPDATE TBL_ESIGNDOCUMENTS
		SET ISDELETE=1
		WHERE ENTRYID=@DATA3
		
		SELECT 1
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETDOCUMETSFORESIGN
-- --------------------------------------------------
    
-- =============================================    
-- AUTHOR:  SURAJ PATIL    
-- CREATE DATE: 13-06-2017    
-- DESCRIPTION: <DESCRIPTION,,>    
--  USP_GETDOCUMETSFORESIGN 66    
-- =============================================   
  
   
CREATE PROCEDURE [dbo].[USP_GETDOCUMETSFORESIGN]    
 @ID AS INT,    
 @EXCHANGE AS VARCHAR(20)=''    
AS    
BEGIN    
 --SELECT *,B.DOCNO FROM TBL_DOCUMENTSUPLOADFINAL_PDF A     
 --INNER JOIN    
 --TBL_ESIGNDOCNUMBER B    
 --ON A.DOCTYPE = B.DOCTYPE    
 --WHERE A.ENTRYID=@ID AND A.ISDELETE = 0 AND A.DOCTYPE IN( 'CORRESSPONDENCE ADDRESS', 'EDUCATION', 'PAN', 'RESIDENTIAL ADDRESS')    
  
  SELECT *FROM TBL_DOCUMENTSUPLOADFINAL_PDF A     
 INNER JOIN    
 TBL_ESIGNDOCNUMBER B    
 ON A.DOCTYPE = B.DOCTYPE    
 WHERE A.ENTRYID=@ID AND A.ISDELETE = 0 --AND A.DOCTYPE IN( 'CORRESSPONDENCE ADDRESS', 'EDUCATION', 'PAN', 'RESIDENTIAL ADDRESS')    
  
 UNION ALL   
  
SELECT * FROM (SELECT A.ID,ENTRYID,b.FILENAME,case when charindex('\\10.253.6.118\ApplicationPDF\',PATH) >0 then  replace(PATH,'\\10.253.6.118\ApplicationPDF\','http://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/')   
else replace(PATH,'ftp://10.253.6.118:23/','http://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/') end as PATH  ,ISDELETE,replace(replace(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.pdf','')  as DOCTYPE,A.EXCHANGE    
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
FROM TBL_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\10.253.6.118\ApplicationPDF\%' or PATH LIKE 'ftp://10.253.6.118:23/%') AND ENTRYID =@ID AND ISDELETE =0)A  
  
JOIN  
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@ID AND ISDELETE =0)B  
  
ON A.ID =B.ID )C  
 JOIN TBL_ESIGNDOCNUMBER D    
 ON C.DOCTYPE = D.DOCTYPE    
 WHERE C.ENTRYID=@ID AND C.ISDELETE = 0   
  
  UNION ALL   
  
 SELECT * FROM (SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@ID AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0) F  
  JOIN TBL_ESIGNDOCNUMBER D    
 ON F.DOCTYPE = D.DOCTYPE    
 WHERE F.ENTRYID=@ID AND F.ISDELETE = 0   
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETFILES_ZIP
-- --------------------------------------------------
CREATE PROC USP_GETFILES_ZIP  
@ENTRYID  INT =0  
AS BEGIN  
  
  
SELECT '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\'+cast (@ENTRYID as varchar(50))+'\'+ FILENAME  as FILENAME FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0  
UNION   
  
SELECT  '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\'+cast (@ENTRYID as varchar(50))+'\'+ FILENAME FROM [DBO].[TBL_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@ENTRYID AND ISDELETE =0  
--UNION  
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )  AND ISDELETE =0  
  
UNION  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://1@ENTRYID6.1.115.136:23/','HTTP://1@ENTRYID6.1.115.136:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@ENTRYID AND ISDELETE =0)A  
  
SELECT  '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\'+cast (@ENTRYID as varchar(50))+'\'+ b.FILENAME as FILENAME  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
FROM TBL_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\1@ENTRYID6.1.115.136\APPLICATIONPDF\%' OR PATH LIKE 'FTP://1@ENTRYID6.1.115.136:23/%') AND ENTRYID =@ENTRYID AND ISDELETE =0)A  
  
JOIN  
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@ENTRYID AND ISDELETE =0)B  
ON A.ID =B.ID   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETSBREGISTRATIONLIST
-- --------------------------------------------------
CREATE PROC  [dbo].[USP_GETSBREGISTRATIONLIST]      
AS      
BEGIN      
 ----SELECT A.ENTRYID, B.FIRSTNAME + ' '+B.LASTNAME AS NAME,   A.AADHAARNO,A.PAN,c.CompletionDate,A.ISAPPROVED,A.APPROVE_DATE,B.sbtag 
 --SELECT A.ENTRYID, B.FIRSTNAME + ' '+B.LASTNAME AS NAME,   A.AADHAARNO,A.PAN,A.ENTRY_DATE ,A.ISAPPROVED,A.APPROVE_DATE,B.sbtag 
 --FROM TBL_IDENTITYDETAILS A       
 --JOIN      
 --(SELECT ENTRYID,FIRSTNAME,LASTNAME,sbtag FROM TBL_BASICDETAILS) B      
 --ON A.ENTRYID = B.ENTRYID      
 ----join 
 ----(select max(time) as CompletionDate,entryid from  tbl_sbapplicationlog where entryid = 1862 and operation = 'Final Form Submit' group by operation ,entryid) c
 ----ON A.ENTRYID = c.ENTRYID      
 --WHERE ISAPPROVED IN(1,4,6,2)     
  SELECT A.ENTRYID, B.FIRSTNAME + ' '+B.LASTNAME AS NAME,   A.AADHAARNO,A.PAN,A.ENTRY_DATE,c.CompletionDate,A.ISAPPROVED,A.APPROVE_DATE,B.sbtag 
 --SELECT A.ENTRYID, B.FIRSTNAME + ' '+B.LASTNAME AS NAME,   A.AADHAARNO,A.PAN,A.ENTRY_DATE ,A.ISAPPROVED,A.APPROVE_DATE,B.sbtag 
 FROM TBL_IDENTITYDETAILS A       
 JOIN      
 (SELECT ENTRYID,FIRSTNAME,LASTNAME,sbtag FROM TBL_BASICDETAILS) B      
 ON A.ENTRYID = B.ENTRYID      
 left join 
 (select max(time) as CompletionDate,entryid from  tbl_sbapplicationlog where operation = 'Final Form Submit' group by operation ,entryid) c
 ON A.ENTRYID = c.ENTRYID      
 WHERE ISAPPROVED IN(1,4,6,2)         
 END    
 
 
 
 --select * from tbl_sbapplicationlog where entryid = 1862 and operation = 'Final Form Submit'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IDENTITYDETAILS
-- --------------------------------------------------


CREATE PROC [dbo].[USP_IDENTITYDETAILS]
@ENTRYID INT=0,
@AADHAARNO VARCHAR(50)='',
@DOB VARCHAR(50)='',
@PAN VARCHAR(50)='',
@ENTRY_BY VARCHAR(50)=''

AS BEGIN 

		IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE  rtrim(ltrim(PAN))=rtrim(ltrim(@PAN)))
		BEGIN
		---UPDATE
			--IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE PAN=@PAN AND ENTRYBY <>@ENTRY_BY)
			--BEGIN
			
			--		SELECT -1 AS ENTRYID,'PAN IS ALREADY USED IN DIFFERENT APPLICATION.' AS [MESSAGE]

			--END
			--ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE PAN=@PAN AND ISAPPROVED  IN (1,4))
			--BEGIN

			--SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_IDENTITYDETAILS WHERE  PAN=@PAN

			--END
			--ELSE
			--BEGIN

			--        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_IDENTITYDETAILS WHERE  PAN=@PAN
			 

			--		UPDATE TBL_IDENTITYDETAILS
			--		SET AADHAARNO=@AADHAARNO,
			--		DOB=@DOB,
			--		PAN=@PAN,
			--		MODIFY_DATE =GETDATE(),
			--		MODIFY_BY=@ENTRY_BY
			--		WHERE  PAN=@PAN


			--END
			
					UPDATE TBL_IDENTITYDETAILS
					SET AADHAARNO=@AADHAARNO
					WHERE  PAN=@PAN

			        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_IDENTITYDETAILS WHERE  PAN=@PAN

		END

		ELSE
		BEGIN

		--INSERT

		INSERT INTO TBL_IDENTITYDETAILS(AADHAARNO,DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY)
		VALUES(@AADHAARNO,@DOB,@PAN,0,GETDATE(),@ENTRY_BY)

		SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

		END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INFRASTRUCTURE
-- --------------------------------------------------


CREATE PROC [dbo].[USP_INFRASTRUCTURE]

	@ENTRYID  int =0,
	@MAINOFFICE  varchar(50) ='',
	@INCOMERANGE  varchar(50) ='',
	@OFFICEFRONTFACING  varchar(5) ='',
	@OFFICEGROUNDFLOOR  varchar(5) ='',
	@SOCIALNETWORKING varchar(200) =''
 
AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@ENTRYID )
BEGIN
		INSERT INTO TBL_INFRASTRUCTURE(ENTRYID,MAINOFFICE,INCOMERANGE,OFFICEFRONTFACING,OFFICEGROUNDFLOOR,SOCIALNETWORKING)
		VALUES (@ENTRYID,@MAINOFFICE,@INCOMERANGE,@OFFICEFRONTFACING,@OFFICEGROUNDFLOOR,@SOCIALNETWORKING)

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_INFRASTRUCTURE 
				SET 
				MAINOFFICE=@MAINOFFICE  ,
				INCOMERANGE=@INCOMERANGE  ,
				OFFICEFRONTFACING=@OFFICEFRONTFACING , 
				OFFICEGROUNDFLOOR=@OFFICEGROUNDFLOOR  ,
				SOCIALNETWORKING=@SOCIALNETWORKING  
				
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Inhouse_integration
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		SURAJ/ASHOK
-- CREATE DATE: 20/NOV/2017
-- DESCRIPTION:	TO PUSH ALL SB-REGISTRATION DATA INTO INHOUSE
-- USP_INHOUSE_INTEGRATION 23 ,'172.29.22.104'
-- =============================================
create PROCEDURE [dbo].[USP_Inhouse_integration]
	@ENTRYID AS INT,
	@CSOID AS VARCHAR(50)
AS
BEGIN
	DECLARE @REFNO numeric(18,0) 
	SELECT @REFNO= CAST((cast(datepart(day, GETDATE()) as varchar)+CAST( datepart(MONTH, GETDATE()) as varchar)+cast(datepart(year, GETDATE()) as varchar) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS numeric(18,0) )
	
		--SB_BROKER
		
		select @REFNO
		
		insert into SB_COMP.dbo.sb_broker(REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,SBSTATUS,REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,IPADDRESS,AUTHSIGN)
		SELECT @REFNO AS REFNO,A.SBTAG,A.INTERMEDIARYBRANCH AS BRANCH,A.PARENT AS PARENTTAG, A.TRADENAME AS TRADENAME,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS ORGTYPE,
		B.ENTRY_DATE AS DOI, A.INTERMEDIARYNAME AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,
		B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,NULL AS SBSTATUS,0 AS REGSTATUS,NULL AS RECSTATUS,
		B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,
		A.TRADENAMECOMM AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,
		B.ENTRYBY AS MAKERID,null AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN
		--into tbl_test
		FROM TBL_BASICDETAILS A
		JOIN TBL_IDENTITYDETAILS B
		ON A.ENTRYID = B.ENTRYID
		JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C
		ON B.ENTRYBY = C.EMP_NO
		WHERE A.ENTRYID = @ENTRYID
		
		--SB_CONTACT
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)
		
		insert into SB_COMP.dbo.sb_contact(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)
		SELECT @REFNO AS REFNO,'RES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
		'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
		FROM TBL_ADDRESS A
		JOIN TBL_IDENTITYDETAILS B
		ON A.ENTRYID = B.ENTRYID
		WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID

		UNION ALL
		--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )

		SELECT @REFNO AS REFNO,'OFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
		'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
		FROM TBL_ADDRESS A
		JOIN TBL_IDENTITYDETAILS B
		ON A.ENTRYID = B.ENTRYID
		WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID
		
		--SB_BROKERAGE DATA NOT AVAILABLE ON 21NOV2017
		
		--SB_DDCHEQUE
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT	
		
		--SB_COMP.dbo.SB_BANKOTHERS
		-- FOR EQUITY  ISCOMMODITY = 0
		insert into SB_COMP.dbo.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)
		SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
		A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
		A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
		NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,
		CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
		NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
		
		C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
		'EQUITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
		
		FROM TBL_BANKDETAILS A 
		JOIN TBL_INFRASTRUCTURE B
		ON A.ENTRYID = B.ENTRYID
		JOIN TBL_IDENTITYDETAILS C
		ON A.ENTRYID = C.ENTRYID
		WHERE A.ISCOMMODITY = 0 AND A.ENTRYID =@ENTRYID
		UNION ALL
		-- FOR COMMODITY  ISCOMMODITY = 1
		SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
		A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
		A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
		NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,
		CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
		NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
		
		C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
		'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
		
		FROM TBL_BANKDETAILS A 
		JOIN TBL_INFRASTRUCTURE B
		ON A.ENTRYID = B.ENTRYID
		JOIN TBL_IDENTITYDETAILS C
		ON A.ENTRYID = C.ENTRYID
		WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID
		
		
		--BPREGMASTER
	 
	
			SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM (
			SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID
			) AS A 
			UNPIVOT ( ISAPPLIED FOR SEGMENT IN ([BSECASH],[NSECASH],[NSEFNO],[NSECURRENCY],[MCX],[NCDEX]) ) AS UNPVT
			-- ADD REMAINING SEGMENTS
			INSERT INTO #SEGMENTS(ENTRYID,SEGMENT ,ISAPPLIED ) 
			SELECT @ENTRYID,'BFA',0  
			UNION ALL
			SELECT @ENTRYID,'BCR',0 
			UNION ALL
			SELECT @ENTRYID,'BSX',0 
			UNION ALL
			SELECT @ENTRYID,'NMF',0 
			
			--SELECT * FROM #SEGMENTS
			 

			UPDATE #SEGMENTS SET SEGMENT =CASE  WHEN SEGMENT='BSECASH' THEN 'BCS' 
			                       WHEN SEGMENT='NSECASH' THEN 'NCS' 
                                   WHEN SEGMENT='NSEFNO' THEN 'NFA'
                                   WHEN SEGMENT='NSECURRENCY' THEN 'NCF'
                                   WHEN SEGMENT='NCDEX' THEN 'NCX' ELSE SEGMENT END 
                                   
              
			UPDATE A  SET  SEGMENT= LEFT(SEGMENT,1) +(CASE WHEN B.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END)+ RIGHT(SEGMENT,2)  FROM #SEGMENTS A ,  
			TBL_BASICDETAILS B 
			WHERE B.ENTRYID =@ENTRYID
			
			--SELECT * FROM #SEGMENTS
			
			insert into SB_COMP.dbo.bpregmaster(RegAprRefNo,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT)
			SELECT @REFNO AS RegAprRefNo,A.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.INTERMEDIARYNAME AS NAMESALUTATION,
		    A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,
		    A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS REGFATHERHUSBANDNAME,
		    A.INTERMEDIARYTYPE AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,
		    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,
		    D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN, 
		    E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,
		    E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,
		    D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,
		    E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,
		    A.INTERMEDIARYBRANCH AS TAGBRANCH,'21'+A.SBTAG AS  GLUNREGISTEREDCODE,'28'+A.SBTAG AS GLREGISTEREDCODE,'NOT APPLIED' AS REGSTATUS,
		    NULL AS REGDATE,NULL AS REGNO,null AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,
		    NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT
			
			FROM TBL_BASICDETAILS A
			JOIN #SEGMENTS B
			ON A.ENTRYID = B.ENTRYID
			JOIN TBL_IDENTITYDETAILS C
			ON A.ENTRYID = C.ENTRYID
			JOIN TBL_ADDRESS D
			ON A.ENTRYID = D.ENTRYID
			JOIN TBL_ADDRESS E
			ON A.ENTRYID = E.ENTRYID
			WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID
			
			
			--SB_COMP.dbo.BPAPPLICATION 
			insert into SB_COMP.dbo.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)
			SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,
			'NOT APPLIED' AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,NULL AS SEBIREGNO,
			C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,
			NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,
			NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,NULL AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO
			
			FROM TBL_BASICDETAILS A
			JOIN #SEGMENTS B
			ON A.ENTRYID = B.ENTRYID
			JOIN TBL_IDENTITYDETAILS C
			ON A.ENTRYID = C.ENTRYID
			WHERE A.ENTRYID =@ENTRYID
			
			--SB_COMP.dbo.sb_personal
			
			insert into SB_COMP.dbo.sb_personal(RefNo,Salutation,FirstName,MiddleName,LastName,FathHusbName,DOB,Sex,Marital,EduQual,Occupation,OccDetails,ExpDetails,BrokingCompany,TradMember,BrokExp,Photograph,Signature,RecStatus,CrtBy,CrtDt,MdyBy,MdyDt,OccupationDetails,SpouseOcc,TimeStamp,IPADDRESS)
			select @REFNO AS RefNo,A.INTERMEDIARYNAME AS Salutation,A.FIRSTNAME as  FirstName, A.MIDDLENAME as MiddleName,A.LASTNAME as  LastName,
		    A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME as FathHusbName, CONVERT(DATETIME,B.DOB,103) AS DOB,
		    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS Sex,
		    CASE WHEN A.MARTIALSTATUS= 'Single' THEN 'S' WHEN A.MARTIALSTATUS = 'Married' THEN 'M' END AS Marital,
		    C.EDUQUALI as EduQual,C.OCCUPATION as  Occupation,C.NATUREOFOCCUPATION as OccDetails,null as ExpDetails,null as BrokingCompany,null as TradMember,null as BrokExp,null as Photograph,null as Signature,null as RecStatus,
		    B.ENTRYBY as CrtBy,B.ENTRY_DATE as  CrtDt,null as MdyBy,null as MdyDt,null as OccupationDetails,null as SpouseOcc,null as TimeStamp,null as IPADDRESS
			FROM TBL_BASICDETAILS A
			JOIN TBL_IDENTITYDETAILS B
			ON A.ENTRYID = B.ENTRYID
			join TBL_REGISTRATIONRELATED C
			ON A.ENTRYID = C.ENTRYID
			where A.ENTRYID = @ENTRYID
			
			

			--SB_COMP.dbo.TAG_BO_DETAILS
			--insert into SB_COMP.dbo.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)
			--select A.sbtag as TAG,B.ENTRY_DATE as  TAG_DATE,'N' as  BO_TAG_UPDATE,null as  BO_TAG_UPDATE_DATE
			--FROM TBL_BASICDETAILS A
			--JOIN TBL_IDENTITYDETAILS B
			--ON A.ENTRYID = B.ENTRYID
			--where A.ENTRYID = @ENTRYID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INHOUSE_INTEGRATION_live
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		SURAJ 
-- CREATE DATE: 20/NOV/2017
-- DESCRIPTION:	TO PUSH ALL SB-REGISTRATION DATA INTO INHOUSE
-- USP_INHOUSE_INTEGRATION_LIVE 1871 ,'172.29.22.104'
-- =============================================
CREATE PROCEDURE [dbo].[USP_INHOUSE_INTEGRATION_live]
	@ENTRYID AS INT,
	@CSOID AS VARCHAR(50)
AS
BEGIN
	DECLARE @REFNO NUMERIC(18,0) 
		IF(EXISTS( SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID AND  ISINHOUSEINTEGRATED = 1))
		BEGIN
		--UPDATE SB IN INHOUSE
					SELECT @REFNO= REFNO FROM TBL_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID
					
					PRINT(@REFNO)
					-- MIS.SB_COMP.DBO.SB_BROKER
					UPDATE A
					SET A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,
					A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,
					A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,
					A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,
					A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,
					A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,
					A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE()
					FROM MIS.SB_COMP.DBO.SB_BROKER A
					JOIN
					(SELECT @REFNO AS REFNO,A.SBTAG,A.INTERMEDIARYBRANCH AS BRANCH,'' AS PARENTTAG, A.TRADENAME AS TRADENAME,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS ORGTYPE,
						B.ENTRY_DATE AS DOI, A.INTERMEDIARYNAME AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,
						B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,NULL AS SBSTATUS,0 AS REGSTATUS,NULL AS RECSTATUS,
						B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,
						A.TRADENAMECOMM AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,
						B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN
						--INTO TBL_TEST
						FROM TBL_BASICDETAILS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C
						ON B.ENTRYBY = C.EMP_NO
						WHERE A.ENTRYID = @ENTRYID)B
						ON A.REFNO = B.REFNO
						AND A.SBTAG = B.SBTAG
						
					
					--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)
						
						
					UPDATE A
					SET A.ADDTYPE=B.ADDTYPE,A.ADDLINE1=B.ADDLINE1,A.ADDLINE2=B.ADDLINE2,A.LANDMARK=B.LANDMARK,A.CITY=B.CITY,A.STATE=B.STATE,A.COUNTRY=B.COUNTRY,
					A.PINCODE=B.PINCODE,A.STDCODE=B.STDCODE,A.TELNO=B.TELNO,A.MOBNO=B.MOBNO,A.EMAILID=B.EMAILID					
					FROM MIS.SB_COMP.DBO.SB_CONTACT A
					JOIN
						(SELECT @REFNO AS REFNO,'RES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID

						UNION ALL
						--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )

						SELECT @REFNO AS REFNO,'OFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID)B
						ON A.REFNO = B.REFNO
						AND A.ADDTYPE = B.ADDTYPE
					
					--MIS.SB_COMP.DBO.SB_BANKOTHERS
						-- FOR EQUITY  ISCOMMODITY = 0
						
						
					UPDATE A
					SET A.NAMEINBANK = B.NAMEINBANK,A.ACCTYPE=B.ACCTYPE,A.ACCNO=B.ACCNO,A.BANKNAME=B.BANKNAME,A.BRANCHADD1=B.BRANCHADD1,
					A.BRANCHADD2=B.BRANCHADD2,A.BRANCHADD3=B.BRANCHADD3,A.BRANCHPIN=B.BRANCHPIN,A.MICRCODE=B.MICRCODE,A.IFSRCODE=B.IFSRCODE,
					A.INCOMERANGE=B.INCOMERANGE,A.BUSINESSLOC=B.BUSINESSLOC,A.NOMINEEREL=B.NOMINEEREL,A.NOMINEENAME=B.NOMINEENAME,
					A.TERMINALLOCATION=B.TERMINALLOCATION,A.SOCIALNET=B.SOCIALNET,A.LANGUAGE=B.LANGUAGE,A.TRADINGACC=B.TRADINGACC,
					A.ACCCLIENTCODE=B.ACCCLIENTCODE,A.DEMATACCNO=B.DEMATACCNO,A.REGOTHER=B.REGOTHER,A.REGEXGNAME=B.REGEXGNAME,
					A.REGSEG=B.REGSEG,A.SEBIACTION=B.SEBIACTION,A.SEBIACTDET=B.SEBIACTDET,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,A.MDYDT=GETDATE(),
					A.NOOFBRANCHOFFICES=B.NOOFBRANCHOFFICES,A.TOTAREASQFEET=B.TOTAREASQFEET,A.TOTNOOFDEALERS=B.TOTNOOFDEALERS,A.TOTNOOFTERMINALS=B.TOTNOOFTERMINALS,A.IPADDRESS=B.IPADDRESS
					FROM MIS.SB_COMP.DBO.SB_BANKOTHERS A
					JOIN
						(SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'EQUITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 0 AND A.ENTRYID =@ENTRYID
						UNION ALL
						-- FOR COMMODITY  ISCOMMODITY = 1
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID)B	
						ON A.REFNO = B.REFNO
						AND A.COMPANY = B.COMPANY
					 
					--BPREGMASTER
					 
					
							SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM (
							SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID
							) AS A 
							UNPIVOT ( ISAPPLIED FOR SEGMENT IN ([BSECASH],[NSECASH],[NSEFNO],[NSECURRENCY],[MCX],[NCDEX]) ) AS UNPVT
							-- ADD REMAINING SEGMENTS
							INSERT INTO #SEGMENTS(ENTRYID,SEGMENT ,ISAPPLIED ) 
							SELECT @ENTRYID,'BFA',0  
							UNION ALL
							SELECT @ENTRYID,'BCR',0 
							UNION ALL
							SELECT @ENTRYID,'BSX',0 
							UNION ALL
							SELECT @ENTRYID,'NMF',0 
							
							--SELECT * FROM #SEGMENTS
							 

							UPDATE #SEGMENTS SET SEGMENT =CASE  WHEN SEGMENT='BSECASH' THEN 'BCS' 
												   WHEN SEGMENT='NSECASH' THEN 'NCS' 
												   WHEN SEGMENT='NSEFNO' THEN 'NFA'
												   WHEN SEGMENT='NSECURRENCY' THEN 'NCF'
												   WHEN SEGMENT='NCDEX' THEN 'NCX' ELSE SEGMENT END 
				                                   
				              
							UPDATE A  SET  SEGMENT= LEFT(SEGMENT,1) +(CASE WHEN B.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END)+ RIGHT(SEGMENT,2)  FROM #SEGMENTS A ,  
							TBL_BASICDETAILS B 
							WHERE B.ENTRYID =@ENTRYID
							
							--SELECT * FROM #SEGMENTS
							
							--INSERT INTO ()
							UPDATE A  SET A.REGAPRREFNO =B.REGAPRREFNO,A.REGTAG=B.REGTAG,A.REGEXCHANGESEGMENT=B.REGEXCHANGESEGMENT,A.NAMESALUTATION=B.NAMESALUTATION,
							A.REGNAME=B.REGNAME,A.TRADENAMESALUTATION=B.TRADENAMESALUTATION,A.REGTRADENAME=B.REGTRADENAME,A.REGFATHERHUSBANDNAME=B.REGFATHERHUSBANDNAME,
							A.TYPE=B.TYPE,A.REGDOB=B.REGDOB,A.REGSEX=B.REGSEX,A.REGRESADD1=B.REGRESADD1,A.REGRESADD2=B.REGRESADD2,
							A.REGRESADD3=B.REGRESADD3,A.REGRESCITY=B.REGRESCITY,A.REGRESPIN=B.REGRESPIN,A.REGOFFADD1=B.REGOFFADD1,A.REGOFFADD2=B.REGOFFADD2,
							A.REGOFFADD3=B.REGOFFADD3,A.REGOFFCITY=B.REGOFFCITY,A.REGOFFPIN=B.REGOFFPIN,A.REGOFFPHONE=B.REGOFFPHONE,A.REGMOBILE=B.REGMOBILE,
							A.REGMOBILE2=B.REGMOBILE2,A.REGRESPHONE=B.REGRESPHONE,A.REGRESFAX=B.REGRESFAX,A.REGPAN=B.REGPAN,A.REGPAN_APPLIED=B.REGPAN_APPLIED,
							A.REGCORRESPONDANCEADD=B.REGCORRESPONDANCEADD,A.REGMAPIN=B.REGMAPIN,A.REGPROPRIETORSHIPYN=B.REGPROPRIETORSHIPYN,A.REGEXPINYRS=B.REGEXPINYRS,
							A.REGRESIDENTIALSTATUS=B.REGRESIDENTIALSTATUS,A.REGEMAILID=B.REGEMAILID,A.REGREFERENCETAG=B.REGREFERENCETAG,A.REGMKRID=B.REGMKRID,
							A.REGMKRDT=B.REGMKRDT,A.TAGBRANCH=B.TAGBRANCH,A.GLUNREGISTEREDCODE=B.GLUNREGISTEREDCODE,A.GLREGISTEREDCODE=B.GLREGISTEREDCODE,
							A.REGSTATUS=B.REGSTATUS,A.REGDATE=B.REGDATE,A.REGNO=B.REGNO,A.UPLOAD=B.UPLOAD,A.ALIAS=B.ALIAS,A.ALIASNAME=B.ALIASNAME,A.REGPORTALNO=B.REGPORTALNO
							FROM MIS.SB_COMP.DBO.BPREGMASTER A
							JOIN
							(SELECT @REFNO AS REGAPRREFNO,A.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.INTERMEDIARYNAME AS NAMESALUTATION,
							A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS REGFATHERHUSBANDNAME,
							A.INTERMEDIARYTYPE AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,
							D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN, 
							E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,
							E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,
							D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,
							E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,
							A.INTERMEDIARYBRANCH AS TAGBRANCH,'21'+A.SBTAG AS  GLUNREGISTEREDCODE,'28'+A.SBTAG AS GLREGISTEREDCODE,'NOT APPLIED' AS REGSTATUS,
							NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,
							NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							JOIN TBL_ADDRESS D
							ON A.ENTRYID = D.ENTRYID
							JOIN TBL_ADDRESS E
							ON A.ENTRYID = E.ENTRYID
							WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID)B
							ON A.RegAprRefNo = B.REGAPRREFNO
							AND A.RegTAG = B.REGTAG
							AND A.RegExchangeSegment = B.RegExchangeSegment
							
							--RegAprRefNo	RegTAG
					
							--MIS.SB_COMP.DBO.BPAPPLICATION 
							--INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)
							
							UPDATE A 
							SET A.TERMINALLOCATION=B.TERMINALLOCATION,A.CRUSER=B.CRUSER,A.MODUSER=B.CRUSER,A.MODDATE= GETDATE(),A.APPAUTHORISED_PERSON=B.APPAUTHORISED_PERSON,
							A.MODE = B.MODE
							FROM MIS.SB_COMP.DBO.BPAPPLICATION A
							JOIN
							(SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,
							'NOT APPLIED' AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,NULL AS SEBIREGNO,
							C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,
							NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,
							NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,NULL AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID =@ENTRYID)B
							ON A.AppRefNo=B.AppRefNo AND A.EST=B.EST
							
							
							--MIS.SB_COMP.DBO.SB_PERSONAL
							
							--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)
							UPDATE A 
							SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,
							A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,
							A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,
							A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,
							A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS
							FROM MIS.SB_COMP.DBO.SB_PERSONAL A
							JOIN
							(SELECT @REFNO AS REFNO,A.INTERMEDIARYNAME AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,
							CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,
							C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,
							B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,NULL AS IPADDRESS
							FROM TBL_BASICDETAILS A
							JOIN TBL_IDENTITYDETAILS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_REGISTRATIONRELATED C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID = @ENTRYID)B
							ON A.REFNO= B.REFNO
							
							
							

							----MIS.SB_COMP.DBO.TAG_BO_DETAILS
							--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)
							--SELECT A.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE
							--FROM TBL_BASICDETAILS A
							--JOIN TBL_IDENTITYDETAILS B
							--ON A.ENTRYID = B.ENTRYID
							--WHERE A.ENTRYID = @ENTRYID
							
							

					
					
		END
		ELSE 
		BEGIN 
					--CREATE NEW SB IN INHOUSE	
				
					SELECT @REFNO= CAST((CAST(DATEPART(DAY, GETDATE()) AS VARCHAR)+CAST( DATEPART(MONTH, GETDATE()) AS VARCHAR)+CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS NUMERIC(18,0) )
					
						--SB_BROKER
						
						--SELECT @REFNO
						
						INSERT INTO MIS.SB_COMP.DBO.SB_BROKER(REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,SBSTATUS,REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,IPADDRESS,AUTHSIGN)
						SELECT @REFNO AS REFNO,A.SBTAG,A.INTERMEDIARYBRANCH AS BRANCH,'' AS PARENTTAG, A.TRADENAME AS TRADENAME,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS ORGTYPE,
						B.ENTRY_DATE AS DOI, A.INTERMEDIARYNAME AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,
						B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,NULL AS SBSTATUS,0 AS REGSTATUS,NULL AS RECSTATUS,
						B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,
						A.TRADENAMECOMM AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,
						B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN
						--INTO TBL_TEST
						FROM TBL_BASICDETAILS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C
						ON B.ENTRYBY = C.EMP_NO
						WHERE A.ENTRYID = @ENTRYID
						
						--SB_CONTACT
						--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)
						
						INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)
						SELECT @REFNO AS REFNO,'RES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID

						UNION ALL
						--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )

						SELECT @REFNO AS REFNO,'OFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID
						
						--SB_BROKERAGE DATA NOT AVAILABLE ON 21NOV2017
						
						--SB_DDCHEQUE
						--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT	
						
						--MIS.SB_COMP.DBO.SB_BANKOTHERS
						-- FOR EQUITY  ISCOMMODITY = 0
						INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'EQUITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 0 AND A.ENTRYID =@ENTRYID
						UNION ALL
						-- FOR COMMODITY  ISCOMMODITY = 1
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID
						
						
						--BPREGMASTER
					 --DROP TABLE #SEGMENTS
					
							SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS_INS FROM (
							SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID
							) AS A 
							UNPIVOT ( ISAPPLIED FOR SEGMENT IN ([BSECASH],[NSECASH],[NSEFNO],[NSECURRENCY],[MCX],[NCDEX]) ) AS UNPVT
							-- ADD REMAINING SEGMENTS
							INSERT INTO #SEGMENTS_INS(ENTRYID,SEGMENT ,ISAPPLIED ) 
							SELECT @ENTRYID,'BFA',0  
							UNION ALL
							SELECT @ENTRYID,'BCR',0 
							UNION ALL
							SELECT @ENTRYID,'BSX',0 
							UNION ALL
							SELECT @ENTRYID,'NMF',0 
							
							--SELECT * FROM #SEGMENTS
							 

							UPDATE #SEGMENTS_INS SET SEGMENT =CASE  WHEN SEGMENT='BSECASH' THEN 'BCS' 
												   WHEN SEGMENT='NSECASH' THEN 'NCS' 
												   WHEN SEGMENT='NSEFNO' THEN 'NFA'
												   WHEN SEGMENT='NSECURRENCY' THEN 'NCF'
												   WHEN SEGMENT='NCDEX' THEN 'NCX' ELSE SEGMENT END 
				                                   
				              
							UPDATE A  SET  SEGMENT= LEFT(SEGMENT,1) +(CASE WHEN B.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END)+ RIGHT(SEGMENT,2)  FROM #SEGMENTS_INS A ,  
							TBL_BASICDETAILS B 
							WHERE B.ENTRYID =@ENTRYID
							
							--SELECT * FROM #SEGMENTS
							
							INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT)
							SELECT @REFNO AS REGAPRREFNO,A.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.INTERMEDIARYNAME AS NAMESALUTATION,
							A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS REGFATHERHUSBANDNAME,
							A.INTERMEDIARYTYPE AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,
							D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN, 
							E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,
							E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,
							D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,
							E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,
							A.INTERMEDIARYBRANCH AS TAGBRANCH,'21'+A.SBTAG AS  GLUNREGISTEREDCODE,'28'+A.SBTAG AS GLREGISTEREDCODE,'NOT APPLIED' AS REGSTATUS,
							NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,
							NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS_INS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							JOIN TBL_ADDRESS D
							ON A.ENTRYID = D.ENTRYID
							JOIN TBL_ADDRESS E
							ON A.ENTRYID = E.ENTRYID
							WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID
							
							
							--MIS.SB_COMP.DBO.BPAPPLICATION 
							INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)
							SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,
							'NOT APPLIED' AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,NULL AS SEBIREGNO,
							C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,
							NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,
							NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,NULL AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS_INS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID =@ENTRYID
							
							--MIS.SB_COMP.DBO.SB_PERSONAL
							
							INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)
							SELECT @REFNO AS REFNO,A.INTERMEDIARYNAME AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,
							CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,
							C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,
							B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,NULL AS IPADDRESS
							FROM TBL_BASICDETAILS A
							JOIN TBL_IDENTITYDETAILS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_REGISTRATIONRELATED C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID = @ENTRYID
							
							
							
							

							--MIS.SB_COMP.DBO.TAG_BO_DETAILS
							INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)
							SELECT A.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE
							FROM TBL_BASICDETAILS A
							JOIN TBL_IDENTITYDETAILS B
							ON A.ENTRYID = B.ENTRYID
							WHERE A.ENTRYID = @ENTRYID
							
							
							--AFTER SUCCESSFUL COMPLITION OF PROCESS UPDATE STATUS IN TBL_IDENTITYDETAILS TABLE
							
							UPDATE TBL_IDENTITYDETAILS
							SET REFNO = @REFNO,
							ISINHOUSEINTEGRATED = 1
							WHERE ENTRYID = @ENTRYID
		--SELECT 0
		END 			
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INHOUSE_INTEGRATION_live_BK_25JAN2018
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		SURAJ/ASHOK
-- CREATE DATE: 20/NOV/2017
-- DESCRIPTION:	TO PUSH ALL SB-REGISTRATION DATA INTO INHOUSE
-- USP_INHOUSE_INTEGRATION_LIVE 1871 ,'172.29.22.104'
-- =============================================
CREATE PROCEDURE [dbo].[USP_INHOUSE_INTEGRATION_live_BK_25JAN2018]
	@ENTRYID AS INT,
	@CSOID AS VARCHAR(50)
AS
BEGIN
	DECLARE @REFNO NUMERIC(18,0) 
		IF(EXISTS( SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID AND  ISINHOUSEINTEGRATED = 1))
		BEGIN
		--UPDATE SB IN INHOUSE
					SELECT @REFNO= REFNO FROM TBL_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID
					PRINT(@REFNO)
					UPDATE A
					SET A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,
					A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,
					A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,
					A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,
					A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,
					A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,
					A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN
					FROM MIS.SB_COMP.DBO.SB_BROKER A
					JOIN
					(SELECT @REFNO AS REFNO,A.SBTAG,A.INTERMEDIARYBRANCH AS BRANCH,'' AS PARENTTAG, A.TRADENAME AS TRADENAME,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS ORGTYPE,
						B.ENTRY_DATE AS DOI, A.INTERMEDIARYNAME AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,
						B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,NULL AS SBSTATUS,0 AS REGSTATUS,NULL AS RECSTATUS,
						B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,
						A.TRADENAMECOMM AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,
						B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN
						--INTO TBL_TEST
						FROM TBL_BASICDETAILS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C
						ON B.ENTRYBY = C.EMP_NO
						WHERE A.ENTRYID = @ENTRYID)B
						ON A.REFNO = B.REFNO
						AND A.SBTAG = B.SBTAG
						
					
					
					 
						
					
					
					
					
		END
		ELSE 
		BEGIN 
					--CREATE NEW SB IN INHOUSE	
				
					SELECT @REFNO= CAST((CAST(DATEPART(DAY, GETDATE()) AS VARCHAR)+CAST( DATEPART(MONTH, GETDATE()) AS VARCHAR)+CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS NUMERIC(18,0) )
					
						--SB_BROKER
						
						--SELECT @REFNO
						
						INSERT INTO MIS.SB_COMP.DBO.SB_BROKER(REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,SBSTATUS,REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,IPADDRESS,AUTHSIGN)
						SELECT @REFNO AS REFNO,A.SBTAG,A.INTERMEDIARYBRANCH AS BRANCH,'' AS PARENTTAG, A.TRADENAME AS TRADENAME,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS ORGTYPE,
						B.ENTRY_DATE AS DOI, A.INTERMEDIARYNAME AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON,CASE WHEN A.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,
						B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,NULL AS SBSTATUS,0 AS REGSTATUS,NULL AS RECSTATUS,
						B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,
						A.TRADENAMECOMM AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,
						B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN
						--INTO TBL_TEST
						FROM TBL_BASICDETAILS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C
						ON B.ENTRYBY = C.EMP_NO
						WHERE A.ENTRYID = @ENTRYID
						
						--SB_CONTACT
						--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)
						
						INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)
						SELECT @REFNO AS REFNO,'RES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID

						UNION ALL
						--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )

						SELECT @REFNO AS REFNO,'OFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+' '+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT
						FROM TBL_ADDRESS A
						JOIN TBL_IDENTITYDETAILS B
						ON A.ENTRYID = B.ENTRYID
						WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID
						
						--SB_BROKERAGE DATA NOT AVAILABLE ON 21NOV2017
						
						--SB_DDCHEQUE
						--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT	
						
						--MIS.SB_COMP.DBO.SB_BANKOTHERS
						-- FOR EQUITY  ISCOMMODITY = 0
						INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'EQUITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 0 AND A.ENTRYID =@ENTRYID
						UNION ALL
						-- FOR COMMODITY  ISCOMMODITY = 1
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,
						NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,
						
						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,
						'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS	
						
						FROM TBL_BANKDETAILS A 
						JOIN TBL_INFRASTRUCTURE B
						ON A.ENTRYID = B.ENTRYID
						JOIN TBL_IDENTITYDETAILS C
						ON A.ENTRYID = C.ENTRYID
						WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID
						
						
						--BPREGMASTER
					 
					
							SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM (
							SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID
							) AS A 
							UNPIVOT ( ISAPPLIED FOR SEGMENT IN ([BSECASH],[NSECASH],[NSEFNO],[NSECURRENCY],[MCX],[NCDEX]) ) AS UNPVT
							-- ADD REMAINING SEGMENTS
							INSERT INTO #SEGMENTS(ENTRYID,SEGMENT ,ISAPPLIED ) 
							SELECT @ENTRYID,'BFA',0  
							UNION ALL
							SELECT @ENTRYID,'BCR',0 
							UNION ALL
							SELECT @ENTRYID,'BSX',0 
							UNION ALL
							SELECT @ENTRYID,'NMF',0 
							
							--SELECT * FROM #SEGMENTS
							 

							UPDATE #SEGMENTS SET SEGMENT =CASE  WHEN SEGMENT='BSECASH' THEN 'BCS' 
												   WHEN SEGMENT='NSECASH' THEN 'NCS' 
												   WHEN SEGMENT='NSEFNO' THEN 'NFA'
												   WHEN SEGMENT='NSECURRENCY' THEN 'NCF'
												   WHEN SEGMENT='NCDEX' THEN 'NCX' ELSE SEGMENT END 
				                                   
				              
							UPDATE A  SET  SEGMENT= LEFT(SEGMENT,1) +(CASE WHEN B.INTERMEDIARYTYPE='INDIVIDUAL' THEN 'I' ELSE 'P' END)+ RIGHT(SEGMENT,2)  FROM #SEGMENTS A ,  
							TBL_BASICDETAILS B 
							WHERE B.ENTRYID =@ENTRYID
							
							--SELECT * FROM #SEGMENTS
							
							INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT)
							SELECT @REFNO AS REGAPRREFNO,A.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.INTERMEDIARYNAME AS NAMESALUTATION,
							A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS REGFATHERHUSBANDNAME,
							A.INTERMEDIARYTYPE AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,
							D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN, 
							E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,
							E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,
							D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,
							E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,
							A.INTERMEDIARYBRANCH AS TAGBRANCH,'21'+A.SBTAG AS  GLUNREGISTEREDCODE,'28'+A.SBTAG AS GLREGISTEREDCODE,'NOT APPLIED' AS REGSTATUS,
							NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,
							NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							JOIN TBL_ADDRESS D
							ON A.ENTRYID = D.ENTRYID
							JOIN TBL_ADDRESS E
							ON A.ENTRYID = E.ENTRYID
							WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID
							
							
							--MIS.SB_COMP.DBO.BPAPPLICATION 
							INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)
							SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,
							'NOT APPLIED' AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,NULL AS SEBIREGNO,
							C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,
							NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,
							NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,NULL AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO
							
							FROM TBL_BASICDETAILS A
							JOIN #SEGMENTS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_IDENTITYDETAILS C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID =@ENTRYID
							
							--MIS.SB_COMP.DBO.SB_PERSONAL
							
							INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)
							SELECT @REFNO AS REFNO,A.INTERMEDIARYNAME AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,
							A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,
							CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,
							C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,
							B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,NULL AS IPADDRESS
							FROM TBL_BASICDETAILS A
							JOIN TBL_IDENTITYDETAILS B
							ON A.ENTRYID = B.ENTRYID
							JOIN TBL_REGISTRATIONRELATED C
							ON A.ENTRYID = C.ENTRYID
							WHERE A.ENTRYID = @ENTRYID
							
							
							
							

							--MIS.SB_COMP.DBO.TAG_BO_DETAILS
							--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)
							--SELECT A.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE
							--FROM TBL_BASICDETAILS A
							--JOIN TBL_IDENTITYDETAILS B
							--ON A.ENTRYID = B.ENTRYID
							--WHERE A.ENTRYID = @ENTRYID
							
							
							--AFTER SUCCESSFUL COMPLITION OF PROCESS UPDATE STATUS IN TBL_IDENTITYDETAILS TABLE
							
							UPDATE TBL_IDENTITYDETAILS
							SET REFNO = @REFNO,
							ISINHOUSEINTEGRATED = 1
							WHERE ENTRYID = @ENTRYID
		--SELECT 0
		END 			
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_insertCSOEsion
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_insertCSOEsion]
@ENTRYID AS INT,
@FILENAME AS VARCHAR(500),
@PATH AS VARCHAR(500),
@ISDELETE INT,
@DOCTYPE AS VARCHAR(50),
@EXCHANGE AS VARCHAR(50),
@SOURCE	AS VARCHAR(50)
AS
BEGIN

DECLARE @CNT AS INT=0
SELECT @CNT = COUNT(1) FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID = @ENTRYID AND DOCTYPE = @DOCTYPE AND ISDELETE = 0

	IF(@CNT>0)
	BEGIN
		UPDATE TBL_ESIGNDOCUMENTS
		SET FILENAME=@FILENAME,
		PATH=@PATH
		WHERE ENTRYID = @ENTRYID AND DOCTYPE = @DOCTYPE AND ISDELETE = 0
		select 1
	END
	ELSE
	BEGIN
	 INSERT TBL_ESIGNDOCUMENTS(ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE,SOURCE)
	 VALUES(@ENTRYID,@FILENAME,@PATH,@ISDELETE,@DOCTYPE,@EXCHANGE,@SOURCE)
	 select 1
	END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_IPARTNER_CALLOG
-- --------------------------------------------------
CREATE PROC [dbo].[USP_IPARTNER_CALLOG]
@MOBILE  VARCHAR(200)='',
@FLAG INT =0,
@USERID VARCHAR(50)='',
@CALLSTATUS VARCHAR(50)='',
@ID INT=0,
@PROCESS AS VARCHAR(50)=''

AS BEGIN

		IF(@PROCESS='ADD REQUEST')
		BEGIN
		INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID,CALLSTATUS)
        SELECT @MOBILE,0,@USERID,@CALLSTATUS
		END


		IF(@PROCESS='GET CALL LOG')
		BEGIN
		SELECT MOBILE AS CONTACT,LOGDATE,CALLSTATUS AS [CALLSTATUS] FROM TBL_SENDREQUEST WHERE USERID=@USERID
		ORDER BY LOGDATE ASC
		END

		IF(@PROCESS='MAP QRCODE')
		BEGIN
		INSERT INTO TBL_USER_QRCODE(QRCODE,USERID)
        SELECT @MOBILE,@USERID

		SELECT 'SUCCESS' AS MSG
		END

		IF(@PROCESS='GET CALL RECORDS')
		BEGIN
		SELECT MOBILE AS CONTACT,LOGDATE,CALLSTATUS AS [CALLSTATUS],RECORDING FROM TBL_RECORDING WHERE USERID=@USERID
		ORDER BY LOGDATE ASC
		END

		IF(@PROCESS='MAKE CALL')
		BEGIN

		--DECLARE @NOTID AS VARCHAR(MAX)=''

		--SELECT @NOTID= A.NOTIFICATIONID FROM (SELECT * FROM [196.1.115.132].RISK.DBO. TBL_MOB_NOTIFICATION WHERE USERID=@USERID)A
		--JOIN(SELECT MAX(ID) AS MAXID FROM [196.1.115.132].RISK.DBO. TBL_MOB_NOTIFICATION WHERE USERID=@USERID)B
		--ON A.ID=B.MAXID 

  --      SELECT DBO.UDP_SENDMOB_NOTIFICATION_CALL(@NOTID,'call',@MOBILE) 

		--SELECT @NOTID

		exec INTRANET.RISK.DBO.USP_MobInhouseLogin 'MAKE CALL',@USERID,@MOBILE

		END

			IF @PROCESS='CLIENTVALIDATION'
			BEGIN
			SELECT PARTY_CODE,LONG_NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE PARTY_CODE=RTRIM(LTRIM(@USERID)) 
			END  

		IF @PROCESS='GETAUTOCLIENT'
		BEGIN
		SELECT TOP 15 PARTY_CODE AS CLIENT_CODE,LONG_NAME +':'+ PARTY_CODE AS NAME FROM INTRANET.RISK.DBO.VWMFSS_CLIENTDETAILS WITH (NOLOCK) WHERE (LONG_NAME LIKE @USERID +'%' OR PARTY_CODE LIKE @USERID+'%')  
		END 


		IF @PROCESS = 'CLIENT_DETAILS'  
		BEGIN  
  

		EXEC INTRANET.RISK.DBO.USP_MOB_CLIENT_DETAILS @USERID
 

   
		END 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_ADDRESS
-- --------------------------------------------------




CREATE PROC [dbo].[USP_MF_ADDRESS]

	@ENTRYID int=0,

	@ADDRESS1 varchar (200)='',

	@ADDRESS2 varchar (200)='',

	@ADDRESS3 varchar (200)='',

	@AREA varchar (50)='',

	@CITY varchar (50)='',

	@EMAIL varchar (50)='',

	@MOBILE varchar (50)='',

	@PHONE varchar (50)='',

	@PIN varchar (50)='',

	@STATE varchar (50)='',

	@STD varchar (50)='',

	@ISPERMANENT bit =0,

	@operation varchar(500)='' ,

	@userType varchar(20)='',

	@employee_code varchar(50) ='',

	@ipAddress varchar(100)=''





AS BEGIN



BEGIN TRY



IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_ADDRESS WHERE ENTRYID=@ENTRYID AND ISPERMANENT= @ISPERMANENT)

BEGIN

		DECLARE @CNT AS INT=0

		SELECT @CNT= COUNT(1) FROM [INTRANET].RISK.DBO.EMP_INFO where EMAIL=@EMAIL OR PHONE =@mobile  

		IF(@CNT > 0 and @ISPERMANENT=0)

		BEGIN

			SELECT -1  AS ENTRYID, 'NOT ALLOWED FOR ANGEL EMPLOYES' AS [MESSAGE] 

		END

		ELSE 

		BEGIN

			INSERT INTO TBL_MF_ADDRESS(ENTRYID,ADDRESS1,ADDRESS2,ADDRESS3,AREA,CITY,EMAIL,MOBILE,PHONE,PIN,STATE,STD,ISPERMANENT,AddedOn)

			VALUES (@ENTRYID,@ADDRESS1,@ADDRESS2,@ADDRESS3,@AREA,@CITY,@EMAIL,@MOBILE,@PHONE,@PIN,@STATE,@STD,@ISPERMANENT,GETDATE())

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END



	



END



ELSE IF EXISTS (SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))

			BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END



ELSE

BEGIN 



SELECT @CNT= COUNT(1) FROM [INTRANET].RISK.DBO.EMP_INFO where EMAIL=@EMAIL OR PHONE =@mobile

			

			



			IF(@CNT > 0 and @ISPERMANENT=0)

			BEGIN



			SELECT -1  AS ENTRYID, 'NOT ALLOWED FOR ANGEL EMPLOYES' AS [MESSAGE] 



			END

			ELSE 

			BEGIN



			    UPDATE TBL_MF_ADDRESS 

				SET 

				ADDRESS1=@ADDRESS1  ,

				ADDRESS2=@ADDRESS2  ,

				ADDRESS3=@ADDRESS3 , 

				AREA=@AREA  ,

				CITY=@CITY  ,

				EMAIL=@EMAIL  ,

				MOBILE=@MOBILE  ,

				PHONE=@PHONE  ,

				PIN=@PIN  ,

				STATE=@STATE , 

				STD=@STD ,

				--SAMEASCORR=@SAMEASCORR,

				modifiedOn =GETDATE()

				WHERE ENTRYID=@ENTRYID  AND ISPERMANENT=@ISPERMANENT



				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 



			   



			END





  

END

select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID

-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018

EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress

-- END Code 



END TRY

		BEGIN CATCH

		         SELECT -1  AS ENTRYID, ERROR_MESSAGE() AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MF_applicationlog
-- --------------------------------------------------



CREATE proc [dbo].[usp_MF_applicationlog]
(

@entryid int ,
@operation varchar(500) ,
@userType varchar(20),
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
)
as
begin 

	if(@userType = 'BDO')
	begin
	select @employee_code = ENTRYBY from TBL_IDENTITYDETAILS
		insert into TBL_MF_Applicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
	end
	else
	begin
		insert into TBL_MF_Applicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
	end

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_ARNDetails
-- --------------------------------------------------

-- Description:	<Add and Update ARN Details >
-- =============================================
create PROCEDURE [dbo].[USP_MF_ARNDetails] 
@EntryID INT =0 ,
@IsARN bit =0,
@ARN_Number VARCHAR(200)='',
@FirstName VARCHAR(100)='',
@MiddleName VARCHAR(100)='',
@LastName VARCHAR(100)='',
@UploadFiles  VARCHAR(max)='',
@ARN_FromDate VARCHAR(100)='',
@ARN_ToDate VARCHAR(100)='',

@Exam_tentative_FromDate VARCHAR(100)='',
@Exam_tentative_ToDate VARCHAR(100)='',
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
AS
BEGIN

    If (@IsARN = 1)
		begin
		set @Exam_tentative_FromDate = null;
		set @Exam_tentative_ToDate = null;
		End
	else
		begin
		set @ARN_FromDate = null;
		set @ARN_ToDate = null;
		End
	



	IF NOT EXISTS(SELECT 1 FROM TBL_MF_ARNDETAILS WHERE EntryID=@EntryID)--AND ARN_Number=@ARN_Number
	BEGIN
		INSERT INTO TBL_MF_ARNDETAILS(EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,Exam_tentative_FromDate,
										Exam_tentative_ToDate,AddedOn,ARN_FromDate,ARN_ToDate) 
		VALUES(@EntryID,@IsARN,@ARN_Number,@FirstName,@MiddleName,@LastName,@UploadFiles,
		ISNULL(@Exam_tentative_FromDate, null),
		ISNULL(@Exam_tentative_ToDate, null),		
		GETDATE(),
		--CAST(@ARN_FromDate AS DATETIME),
		--CAST(@ARN_ToDate AS DATETIME)
		ISNULL(@ARN_FromDate, null),
		ISNULL(@ARN_ToDate, null)
		)

								
		SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
	END
	ELSE
	BEGIN
		UPDATE TBL_MF_ARNDETAILS SET IsARN=@IsARN,
								ARN_Number=@ARN_Number,
								FirstName=@FirstName,
								MiddleName=@MiddleName,
								LastName=@LastName,
								UploadFiles=@UploadFiles,
								--ARN_From_Date=CAST(@ARN_From_Date AS DATETIME),
								--ARN_To_Date=CAST(@ARN_To_Date AS DATETIME),
								Exam_tentative_FromDate=CAST(@Exam_tentative_FromDate AS DATETIME),
								Exam_tentative_ToDate=CAST(@Exam_tentative_ToDate AS DATETIME),
								ModifiedON=GETDATE(),
								ARN_FromDate=CONVERT(VarChar(50), @ARN_FromDate, 101),
								ARN_ToDate=CONVERT(VarChar(50), @ARN_ToDate, 101)
								
								WHERE EntryID=@EntryID --AND ARN_Number=@ARN_Number
	
		SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 								
	END
	
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_BANKDETAILS
-- --------------------------------------------------



CREATE PROC [dbo].[USP_MF_BANKDETAILS]
@ENTRYID  INT=0,
@ACCOUNTNO VARCHAR(50)='',
@ACCOUNTTYPE VARCHAR(10)='',
@ADDRESS VARCHAR(500)='',
@BANKNAME VARCHAR(100)='',
@BRANCH VARCHAR(50)='',
@IFSCRGTS VARCHAR(50)='',
@MICR VARCHAR(50)='',
@NAMEINBANK VARCHAR(100)='',
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@ENTRYID)
BEGIN
		INSERT INTO TBL_MF_BANKDETAILS(ENTRYID,ACCOUNTNO,ACCOUNTTYPE,[ADDRESS],BANKNAME,BRANCH,IFSCRGTS,MICR,NAMEINBANK,AddedOn)
		VALUES (@ENTRYID,@ACCOUNTNO,@ACCOUNTTYPE,@ADDRESS,@BANKNAME,@BRANCH,@IFSCRGTS,@MICR,@NAMEINBANK,GETDATE())

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_MF_BANKDETAILS 
				SET 
				ACCOUNTNO=@ACCOUNTNO  ,
				ACCOUNTTYPE=@ACCOUNTTYPE  ,
				[ADDRESS]=@ADDRESS , 
				BANKNAME=@BANKNAME  ,
				BRANCH=@BRANCH  ,
				IFSCRGTS=@IFSCRGTS  ,
				MICR =@MICR  ,
				NAMEINBANK=@NAMEINBANK  ,
				modifiedOn= GETDATE()
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_BASICDETAILS
-- --------------------------------------------------

-- USP_MF_BASICDETAILS @ENTRYID='122',@Salutation='Mr.',@FIRSTNAME='Narendra',@MIDDLENAME='k',@LASTNAME='Prajapati',
--@MobileNO='9999',@EmailID='sd',@OrganizationType='Stock',@TRADENAME='aa',@Photo='/9j/4AAQSkZJRgABAgEAYABgAAD/4Q8HRXhpZgAATU0AKgAAAAgABgEyAAIAAAAUAAAAVkdGAAMAAAABAAMAAEdJAAMAAAABADIAAJydAAEAAAAOAAAAAOocAAcAAAf0AAAAAIdpAAQAAAABAAAAagAAANQyMDA5OjAzOjEyIDEzOjQ3OjQzAAAFkAMAAgAAABQAAACskAQAAgAAABQAAADAkpEAAgAAAAM1NAAAkpIAAgAAAAM1NAAA6hwABwAAB7QAAAAAAAAAADIwMDg6MDM6MTQgMTM6NTk6MjYAMjAwODowMzoxNCAxMzo1OToyNgAABQEDAAMAAAABAAYAAAEaAAUAAAABAAABFgEbAAUAAAABAAABHgIBAAQAAAABAAABJgICAAQAAAABAAAN2QAAAAAAAABIAAAAAQAAAEgAAAAB/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wAARCAAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA'
--,@operation='Save MF Basic Details',@userType='BDO',@employee_code='',@maritalStatus='',@gender="Male",@ipAddress='',@BranchTag='dd' 
CREATE PROC [dbo].[USP_MF_BASICDETAILS]  
  
@ENTRYID  AS INT =0,  
@Salutation varchar(100)='',  
@FIRSTNAME  AS VARCHAR(100)='',  
@LASTNAME  AS VARCHAR(100)='',  
@MIDDLENAME  AS VARCHAR(100)='',  
@MobileNO VARCHAR(20)='',  
@EmailID varchar(200)='',  
@OrganizationType varchar(500)='',  
@TRADENAME  AS VARCHAR(100)='',  
@Photo VARCHAR(MAX)='',  
@operation varchar(500)='' ,  
@userType varchar(20)='',  
@employee_code varchar(50) ='',  
@maritalStatus varchar(50) ='',  
@gender varchar(50) ='',  
@ipAddress varchar(100)='',
@BranchTag varchar(20)=''  
AS BEGIN  
  
--BEGIN TRY  
  
IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_BASICDETAILS WHERE ENTRYID=@ENTRYID)  
BEGIN  
  
   -- ----Check intermediaryBranch  
   --      DECLARE @CNT AS INT=0  
  
   --SELECT @CNT= COUNT(1) FROM [196.1.115.182].GENERAL.DBO.BO_REGION where Branch_Code=@intermediaryBranch  
  
   --IF(@CNT=0)  
   --BEGIN  
   --SELECT @CNT= COUNT(1) FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL  WHERE SB=@INTERMEDIARYBRANCH  
   --END  
  
   --IF(@CNT=0)  
   --BEGIN  
  
   --SELECT -1  AS ENTRYID, 'INVALID INTERMEDIARY BRANCH' AS [MESSAGE]   
  
   --END  
   --ELSE  
   --BEGIN  
  
   INSERT INTO TBL_MF_BASICDETAILS(ENTRYID,Salutation,FIRSTNAME,LASTNAME,MIDDLENAME,MobileNO,EmailID,OrganizationType,TRADENAME,Photo,AddedOn,martialStatus,gender,BranchTag)  
      VALUES (@ENTRYID,@Salutation,@FIRSTNAME,@LASTNAME,@MIDDLENAME,@MobileNO ,@EmailID,@OrganizationType,@TRADENAME,@Photo,GETDATE(),@maritalStatus,@gender,@BranchTag)  
  
      SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE]   
  
   --END  
     
   
  
    
  
END  
ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))  
BEGIN  
  
   SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE]   
  
END  
ELSE  
BEGIN   
  
  
  --SELECT @CNT= COUNT(1) FROM [196.1.115.182].GENERAL.DBO.BO_REGION where Branch_Code=@intermediaryBranch  
  
  -- IF(@CNT=0)  
  -- BEGIN  
  -- SELECT @CNT= COUNT(1) FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL  WHERE SB=@INTERMEDIARYBRANCH  
  -- END  
  
  -- IF(@CNT=0)  
  -- BEGIN  
  
  -- SELECT -1  AS ENTRYID, 'INVALID INTERMEDIARY BRANCH' AS [MESSAGE]   
  
  -- END  
  -- ELSE  
  -- BEGIN  
  
                UPDATE TBL_MF_BASICDETAILS   
    SET   
    Salutation=@Salutation,  
    FIRSTNAME=@FIRSTNAME  ,  
    LASTNAME=@LASTNAME  ,  
    MIDDLENAME=@MIDDLENAME  ,  
    MobileNO=@MobileNO,  
    EmailID=@EmailID,  
    OrganizationType=@OrganizationType,  
    Photo=@Photo ,  
    TRADENAME=@TRADENAME  ,  
    modifiedOn =GETDATE(),  
    martialStatus = @maritalStatus,
	gender=@gender,
	BranchTag =@BranchTag

    WHERE ENTRYID=@ENTRYID   
  
    SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE]   
  
   --END  
  
  
         
END  
  
 select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018  
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress  
-- END Code   
  
--END TRY  
--  BEGIN CATCH  
--           SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE]   
--  END CATCH  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_DOCUMENTSUPLOAD
-- --------------------------------------------------

CREATE PROC [dbo].[USP_MF_DOCUMENTSUPLOAD]
@PROCESS AS VARCHAR(50)='',
@ID AS INT=0,
@ENTRYID INT =0,
@FILENAME AS VARCHAR(100)='',
@PATH AS VARCHAR(200)='',
@ISDELETE AS INT=0,
@DOCTYPE AS VARCHAR(50)='',
@EXCHANGE AS VARCHAR(50)='',
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)='',
@Photo VARCHAR(MAX)=''
AS BEGIN

BEGIN TRY

   IF @PROCESS ='DELETE'
	BEGIN
	
	        UPDATE TBL_MF_DOCUMENTSUPLOAD
			SET ISDELETE=1 ,modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]

			UPDATE A
			SET A.ISDELETE =1
			FROM  TBL_MF_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND ID =@ID)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE

	END

	 IF @PROCESS ='DELETE PDF'
	BEGIN
	        UPDATE tbl_MF_DOCUMENTSUPLOAD_PDF
			SET ISDELETE=1 ,modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]
	END

	IF @PROCESS='ADD'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN


	IF @EXCHANGE= 'Individual'
	BEGIN

	DELETE FROM tbl_MF_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Proprietor' AND ENTRYID=@ENTRYID

	END

	ELSE IF(@EXCHANGE= 'Proprietor')
	BEGIN

	DELETE FROM tbl_MF_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Individual' AND ENTRYID=@ENTRYID

	END

	--added on 24 Oct 2018 by aslam
	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END 

	INSERT INTO tbl_MF_DOCUMENTSUPLOAD
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE,GETDATE(),NULL

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	END
	ELSE
	BEGIN


	        DECLARE @IDS AS INT =0

			SELECT @IDS =ID FROM tbl_MF_DOCUMENTSUPLOAD 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

	        UPDATE tbl_MF_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
			modifiedOn =GETDATE()
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			--added on 24 Oct 2018 by aslam
			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END

	END


	IF @PROCESS='ADD PDF'
	BEGIN
	IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN

	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END

	INSERT INTO TBL_MF_DOCUMENTSUPLOAD_PDF(
											ENTRYID,
											FILENAME,
											PATH,
											ISDELETE,
											DOCTYPE,
											EXCHANGE,
											AddedOn,
											modifiedOn)
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE,GETDATE(),NULL
	
	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	END
	ELSE
	BEGIN
	SELECT @IDS =ID FROM TBL_MF_DOCUMENTSUPLOAD_PDF 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

	        UPDATE TBL_MF_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
			modifiedOn =GETDATE()
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END
	END



	IF @PROCESS='UPDATE'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_MF_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
		    modifiedOn =GETDATE()
		    
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END   

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


		IF @PROCESS='UPDATE PDF'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_MF_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
		    modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


	IF @PROCESS='GET PDF FILE'
	BEGIN
	SELECT * FROM (SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND DOCTYPE NOT IN ('AFFIDAVIT','MOU') ) A
			WHERE A.DOCTYPE NOT LIKE '%AGREEMENT'

	END


	IF @PROCESS='GET AFTER ESIGN PDF FILE'
	BEGIN
	--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )

	        SELECT * 
            FROM  TBL_MF_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND (DOCTYPE IN ('AFFIDAVIT','MOU') OR DOCTYPE LIKE '%AGREEMENT' ) AND ISDELETE =0)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE
			WHERE A.ISDELETE =0 and A.ENTRYID=@ENTRYID
	END


    IF @PROCESS='ADD COMBINE FILE'
	BEGIN

	UPDATE TBL_MF_DOCUMENTSUPLOADFINAL_PDF
	SET ISDELETE=1
	WHERE ENTRYID =@ENTRYID AND DOCTYPE=@DOCTYPE

	INSERT INTO TBL_MF_DOCUMENTSUPLOADFINAL_PDF
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 

END TRY

		BEGIN CATCH

		SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG
-- --------------------------------------------------
/*  
  
EXEC USP_MF_GEN_TAG 241  
  
EXEC USP_MF_GEN_TAG 257   
  
EXEC USP_MF_GEN_TAG 21569
  
*/  
  
CREATE PROCEDURE [dbo].[USP_MF_GEN_TAG] (@AprRefNo AS VARCHAR(15))        
  
AS        
  
DECLARE @count INT = 1,        
  
 @index2 INT = 1;        
  
DECLARE @RandomID VARCHAR(32)        
  
DECLARE @counter SMALLINT        
  
DECLARE @RandomNumber FLOAT        
  
DECLARE @RandomNumberInt INT        
  
DECLARE @CurrentCharacter VARCHAR(1)        
  
DECLARE @ValidCharacters VARCHAR(255)        
  
DECLARE @FChar VARCHAR (1)     
  
DECLARE @PANNO VARCHAR(15)       
  
DECLARE @SBTAGExists VARCHAR(15)    
  
    
SET @PANNO  = (  
  
SELECT PAN from TBL_MF_IDENTITYDETAILS where entryid =  @AprRefNo  
  
)  
  
SET  @SBTAGExists = (        
   
 SELECT ISNULL(SBTAG, '') AS SBTAG        
  
 FROM [MIS].SB_COMP.DBO.[SB_broker]        
  
 WHERE PANNO = @PANNO and Branch  != 'MFSB'  
)        
     
  
IF (ISNULL(@SBTAGExists,'') = '')  -- ADDED ON 02-JAN-2024 AS PER krishna sawant mail subject line "SB tag not generated"  entry-id 21569

BEGIN  
  
SET @ValidCharacters = (        
  
  SELECT FIRSTNAME+ LASTNAME        
  
  FROM TBL_MF_BASICDETAILS        
  
   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO        
  
  )        
  
SET @FChar  = (        
  
 SELECT   SUBSTRING(FIRSTNAME, 1,1 )  
  
 FROM TBL_MF_BASICDETAILS        
  
  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo        
  
 )        
  
DECLARE @pindex INT;        
  
WHILE (1 = 1)        
  
BEGIN        
  
 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)        
  
        
  
 IF (@pindex > 0)        
  
  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')        
  
 ELSE        
  
  BREAK;        
  
END        
  
Lablel1:        
  
DECLARE @ValidCharactersLength INT;        
  
DECLARE @index INT = 0;        
  
SET @ValidCharactersLength = len(@ValidCharacters)        
  
SET @CurrentCharacter = ''        
  
SET @RandomNumber = 0        
  
SET @RandomNumberInt = 0        
  
SET @RandomID = ''        
  
SET NOCOUNT ON        
  
SET @counter = 1        
  
SET @index = @count;        
  
WHILE @counter < = (3)        
  
BEGIN        
  
 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)        
  
        
  
 IF (@count >= @ValidCharactersLength)        
  
 BEGIN        
  
  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)        
  
  SET @index2 = @index2 + 1;        
  
 END        
  
        
  
 SET @RandomID = @RandomID + @CurrentCharacter        
  
 SET @counter = @counter + 1        
  
 SET @index = @index + 1;        
  
        
  
 IF (@counter = 3)        
  
 BEGIN        
  
  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID        
  
 END        
  
END        
  
IF EXISTS (        
  
  SELECT SBTAG        
  
  FROM [MIS].SB_COMP.DBO.[SB_broker]        
  
  WHERE sbtag = @FChar + @RandomID        
  
  )        
  
BEGIN        
  
 SET @count = @count + 1;        
  
 GOTO Lablel1;        
  
END        
ELSE        
  
 SELECT Upper(@FChar + @RandomID) AS TAG  
  
 END  
   
 ELSE   
  
 SELECT Upper(@SBTAGExists) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG_2024
-- --------------------------------------------------
/*  
  
EXEC USP_MF_GEN_TAG 241  
  
EXEC USP_MF_GEN_TAG 257   
  
EXEC USP_MF_GEN_TAG 21569

USP_MF_GEN_TAG_2024 21780

RSSHA
  
*/  
  
CREATE PROCEDURE [dbo].[USP_MF_GEN_TAG_2024] (@AprRefNo AS VARCHAR(15))        
  
AS        
  
DECLARE @count INT = 1,@index2 INT = 1;        
DECLARE @RandomID VARCHAR(32)        
DECLARE @counter SMALLINT        
DECLARE @RandomNumber FLOAT        
DECLARE @RandomNumberInt INT        
DECLARE @CurrentCharacter VARCHAR(1)        
DECLARE @ValidCharacters VARCHAR(255)        
DECLARE @FChar VARCHAR (1)     
DECLARE @PANNO VARCHAR(15)       
DECLARE @SBTAGExists VARCHAR(15)    
  
    
SET @PANNO  = 
(  
		SELECT	PAN 
		from	TBL_MF_IDENTITYDETAILS WITH(NoLock)
		where	entryid =  @AprRefNo  
)  
  
SET  @SBTAGExists = (        
   
		SELECT ISNULL(SBTAG, '') AS SBTAG        
		FROM	[MIS].SB_COMP.DBO.[SB_broker]    WITH(NoLock)     
		WHERE		PANNO = @PANNO 
				AND Branch != 'MFSB' 
				
				)        
     
  
IF (ISNULL(@SBTAGExists,'') = '')  -- ADDED ON 02-JAN-2024 AS PER krishna sawant mail subject line "SB tag not generated"  entry-id 21569

BEGIN  
  
	SET @ValidCharacters = (        
							  SELECT    LASTNAME + FIRSTNAME
							  FROM		TBL_MF_BASICDETAILS   WITH(NoLock)      
							  WHERE		CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO        
							)        
  
SET @FChar  = (        
		
		SELECT	SUBSTRING(FIRSTNAME, 1,1 )  
		FROM	TBL_MF_BASICDETAILS   WITH(NoLock)      
		WHERE	CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo        
 )        
  
DECLARE @pindex INT;        
  
WHILE (1 = 1)        
  
BEGIN        
  
		SET @pindex = patindex('%[^a-z]%', @ValidCharacters)        

		select @pindex,'pindex'
  
		IF (@pindex > 0)
			SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')        
		ELSE        
			BREAK;        
		END        
  
Lablel1:        
  
		DECLARE @ValidCharactersLength INT;        
		DECLARE @index INT = 0;        
  
		SET @ValidCharactersLength = len(@ValidCharacters)        
		SET @CurrentCharacter = ''        
		SET @RandomNumber = 0
		SET @RandomNumberInt = 0        
  
		SET @RandomID = ''        
  
		SET NOCOUNT ON        
  
		SET @counter = 1        
  
		SET @index = @count;        
  

		WHILE @counter < = (3)        
			BEGIN        
					SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1) 
			
					select 'current-char',@CurrentCharacter
				
					IF (@count >= @ValidCharactersLength)        
						BEGIN        
								SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)
  
								SET @index2 = @index2 + 1;        
  
				END        
  
        
  
 SET @RandomID = @RandomID + @CurrentCharacter        
  
 SET @counter = @counter + 1        
  
 SET @index = @index + 1;        
  
        
  
 IF (@counter = 3)        
  
 BEGIN        
  
  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID        
  
 END        
  
END        
  
IF EXISTS (        
  
  SELECT SBTAG        
  
  FROM	[MIS].SB_COMP.DBO.[SB_broker]   WITH(NoLock)      
  
  WHERE sbtag = @FChar + @RandomID        
  
  )        
  
BEGIN        
  
	select 'already exists', @FChar,@RandomID 

 SET @count = @count + 1;        
  
 GOTO Lablel1;        
  
END        
ELSE        
  
 SELECT Upper(@FChar + @RandomID) AS TAG  
  
 END  
   
 ELSE   
  
 SELECT Upper(@SBTAGExists) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG_29_Oct_2018
-- --------------------------------------------------

--  Execute USP_MF_GEN_TAG @AprRefNo=153
-- USP_MF_GEN_TAG 175  
CREATE PROCEDURE [dbo].[USP_MF_GEN_TAG_29_Oct_2018] (@AprRefNo AS VARCHAR(15))      
AS      
DECLARE @count INT = 1,      
 @index2 INT = 1;      
DECLARE @RandomID VARCHAR(32)      
DECLARE @counter SMALLINT      
DECLARE @RandomNumber FLOAT      
DECLARE @RandomNumberInt INT      
DECLARE @CurrentCharacter VARCHAR(1)      
DECLARE @ValidCharacters VARCHAR(255)      
DECLARE @FChar VARCHAR (1)   
      
SET @ValidCharacters = (      
  SELECT FIRSTNAME+ LASTNAME      
  FROM TBL_MF_BASICDETAILS      
   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO      
  )      

SET @FChar  = (      
 SELECT   SUBSTRING(FIRSTNAME, 1,1 )
 FROM TBL_MF_BASICDETAILS      
  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo      
 )      

      
DECLARE @pindex INT;      
      
WHILE (1 = 1)      
BEGIN      
 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)      
      
 IF (@pindex > 0)      
  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')      
 ELSE      
  BREAK;      
END      
      
Lablel1:      
      
DECLARE @ValidCharactersLength INT;      
DECLARE @index INT = 0;      
SET @ValidCharactersLength = len(@ValidCharacters)      
SET @CurrentCharacter = ''      
SET @RandomNumber = 0      
SET @RandomNumberInt = 0      
SET @RandomID = ''      
SET NOCOUNT ON      
SET @counter = 1      
SET @index = @count;      
      
WHILE @counter < = (3)      
BEGIN      
 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)      
      
 IF (@count >= @ValidCharactersLength)      
 BEGIN      
  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)      
  SET @index2 = @index2 + 1;      
 END      
      
 SET @RandomID = @RandomID + @CurrentCharacter      
 SET @counter = @counter + 1      
 SET @index = @index + 1;      
      
 IF (@counter = 3)      
 BEGIN      
  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID      
 END      
END      
      
IF EXISTS (      
  SELECT SBTAG      
  FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      
  WHERE sbtag = @FChar + @RandomID      
  )      
BEGIN      
 SET @count = @count + 1;      

 GOTO Lablel1;      
END      
ELSE      
 SELECT Upper(@FChar + @RandomID) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG_29062018
-- --------------------------------------------------

--  Execute USP_MF_GEN_TAG @AprRefNo=153
--USP_MF_GEN_TAG 81  
CREAte PROCEDURE [dbo].[USP_MF_GEN_TAG_29062018] (@AprRefNo AS VARCHAR(15))      
AS      
DECLARE @count INT = 1,      
 @index2 INT = 1;      
DECLARE @RandomID VARCHAR(32)      
DECLARE @counter SMALLINT      
DECLARE @RandomNumber FLOAT      
DECLARE @RandomNumberInt INT      
DECLARE @CurrentCharacter VARCHAR(1)      
DECLARE @ValidCharacters VARCHAR(255)      
      
SET @ValidCharacters = (      
  SELECT FIRSTNAME     
  FROM TBL_MF_BASICDETAILS      
   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO      
  )      
      
DECLARE @pindex INT;      
      
WHILE (1 = 1)      
BEGIN      
 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)      
      
 IF (@pindex > 0)      
  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')      
 ELSE      
  BREAK;      
END      
      
Lablel1:      
      
DECLARE @ValidCharactersLength INT;      
DECLARE @index INT = 0;      
SET @ValidCharactersLength = len(@ValidCharacters)      
SET @CurrentCharacter = ''      
SET @RandomNumber = 0      
SET @RandomNumberInt = 0      
SET @RandomID = ''      
SET NOCOUNT ON      
SET @counter = 1      
SET @index = @count;      
      
WHILE @counter < = (3)      
BEGIN      
 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)      
      
 IF (@count >= @ValidCharactersLength)      
 BEGIN      
  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)      
  SET @index2 = @index2 + 1;      
 END      
      
 SET @RandomID = @RandomID + @CurrentCharacter      
 SET @counter = @counter + 1      
 SET @index = @index + 1;      
      
 IF (@counter = 3)      
 BEGIN      
  SET @RandomID = left(@ValidCharacters, 1) + @RandomID      
 END      
END      
      
IF EXISTS (      
  SELECT SBTAG      
  FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      
  WHERE sbtag = @RandomID      
  )      
BEGIN      
 SET @count = @count + 1;      
      
 GOTO Lablel1;      
END      
ELSE      
 SELECT Upper(@RandomID) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG_29thJuly2020
-- --------------------------------------------------






/*



exec USP_MF_GEN_TAG 3396

*/



CREATE PROCEDURE [dbo].[USP_MF_GEN_TAG] (@AprRefNo AS VARCHAR(15))      



AS      



DECLARE @count INT = 1,      



 @index2 INT = 1;      



DECLARE @RandomID VARCHAR(32)      



DECLARE @counter SMALLINT      



DECLARE @RandomNumber FLOAT      



DECLARE @RandomNumberInt INT      



DECLARE @CurrentCharacter VARCHAR(1)      



DECLARE @ValidCharacters VARCHAR(255)      



DECLARE @FChar VARCHAR (1)   



DECLARE @PANNO VARCHAR(15)     



DECLARE @SBTAGExists VARCHAR(15)  



  

SET @PANNO  = (



SELECT PAN from TBL_MF_IDENTITYDETAILS where entryid =  @AprRefNo



)



SET  @SBTAGExists = (      

	

	SELECT ISNULL(SBTAG, '') AS SBTAG      



	FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      



	WHERE PANNO = @PANNO and Branch  != 'MFSB' AND ParentTag IS NULL

)      

   



IF (ISNULL(@SBTAGExists,'') = '')

BEGIN



SET @ValidCharacters = (      



  SELECT FIRSTNAME+ LASTNAME      



  FROM TBL_MF_BASICDETAILS      



   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO      



  )      



SET @FChar  = (      



 SELECT   SUBSTRING(FIRSTNAME, 1,1 )



 FROM TBL_MF_BASICDETAILS      



  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo      



 )      



DECLARE @pindex INT;      



WHILE (1 = 1)      



BEGIN      



 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)      



      



 IF (@pindex > 0)      



  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')      



 ELSE      



  BREAK;      



END      



Lablel1:      



DECLARE @ValidCharactersLength INT;      



DECLARE @index INT = 0;      



SET @ValidCharactersLength = len(@ValidCharacters)      



SET @CurrentCharacter = ''      



SET @RandomNumber = 0      



SET @RandomNumberInt = 0      



SET @RandomID = ''      



SET NOCOUNT ON      



SET @counter = 1      



SET @index = @count;      



WHILE @counter < = (3)      



BEGIN      



 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)      



      



 IF (@count >= @ValidCharactersLength)      



 BEGIN      



  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)      



  SET @index2 = @index2 + 1;      



 END      



      



 SET @RandomID = @RandomID + @CurrentCharacter      



 SET @counter = @counter + 1      



 SET @index = @index + 1;      



      



 IF (@counter = 3)      



 BEGIN      



  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID      



 END      



END      



IF EXISTS (      



  SELECT SBTAG      



  FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      



  WHERE sbtag = @FChar + @RandomID      



  )      



BEGIN      



 SET @count = @count + 1;      



 GOTO Lablel1;      



END      

ELSE      



 SELECT Upper(@FChar + @RandomID) AS TAG



 END

 

 ELSE 



 SELECT Upper(@SBTAGExists) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG_Test
-- --------------------------------------------------
/*  
  
EXEC USP_MF_GEN_TAG 241  
  
EXEC USP_MF_GEN_TAG 257   
  
USP_MF_GEN_TAG_Test '21569'
  
*/  
  
CREATE PROCEDURE [dbo].[USP_MF_GEN_TAG_Test] 
(@AprRefNo AS VARCHAR(15))        
  
AS        
  
DECLARE @count INT = 1,        
  
 @index2 INT = 1;        
  
DECLARE @RandomID VARCHAR(32)        
  
DECLARE @counter SMALLINT        
  
DECLARE @RandomNumber FLOAT        
  
DECLARE @RandomNumberInt INT        
  
DECLARE @CurrentCharacter VARCHAR(1)        
  
DECLARE @ValidCharacters VARCHAR(255)        
  
DECLARE @FChar VARCHAR (1)     
  
DECLARE @PANNO VARCHAR(15)       
  
DECLARE @SBTAGExists VARCHAR(15)    
  
    
SET @PANNO  = (  
  
SELECT PAN from TBL_MF_IDENTITYDETAILS where entryid =  @AprRefNo  
  
)  
SELECT 51,@PANNO  
SET  @SBTAGExists = (        
   
 SELECT ISNULL(SBTAG, '') AS SBTAG        
  
 FROM [MIS].SB_COMP.DBO.[SB_broker]        
  
 WHERE PANNO = @PANNO and Branch  != 'MFSB'  
)        
     

SELECT '62',@SBTAGExists

  
IF (ISNULL(@SBTAGExists,'') = '')  
BEGIN  
  
SET @ValidCharacters = (        
  
  SELECT FIRSTNAME+ LASTNAME        
  
  FROM TBL_MF_BASICDETAILS        
  
   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO        
  
  )        
  
SET @FChar  = (        
  
 SELECT   SUBSTRING(FIRSTNAME, 1,1 )  
  
 FROM TBL_MF_BASICDETAILS        
  
  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo        
  
 )        
  
DECLARE @pindex INT;        
  
WHILE (1 = 1)        
  
BEGIN        
  
 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)        
  
        
  
 IF (@pindex > 0)        
  
  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')        
  
 ELSE        
  
  BREAK;        
  
END        
  
Lablel1:        
  
DECLARE @ValidCharactersLength INT;        
  
DECLARE @index INT = 0;        
  
SET @ValidCharactersLength = len(@ValidCharacters)        
  
SET @CurrentCharacter = ''        
  
SET @RandomNumber = 0        
  
SET @RandomNumberInt = 0        
  
SET @RandomID = ''        
  
SET NOCOUNT ON        
  
SET @counter = 1        
  
SET @index = @count;        
  
WHILE @counter < = (3)        
  
BEGIN        
  
 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)        
  
        
  
 IF (@count >= @ValidCharactersLength)        
  
 BEGIN        
  
  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)        
  
  SET @index2 = @index2 + 1;        
  
 END        
  
        
  
 SET @RandomID = @RandomID + @CurrentCharacter        
  
 SET @counter = @counter + 1        
  
 SET @index = @index + 1;        
  
        
  
 IF (@counter = 3)        
  
 BEGIN        
  
  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID        
  
 END        
  
END        
  
IF EXISTS (        
  
  SELECT SBTAG        
  
  FROM [MIS].SB_COMP.DBO.[SB_broker]        
  
  WHERE sbtag = @FChar + @RandomID        
  
  )        
  
BEGIN        
  
 SET @count = @count + 1;        
  
 GOTO Lablel1;        
  
END        
ELSE        
  
 SELECT Upper(@FChar + @RandomID) AS TAG  
  
 END  
   
 ELSE   
  
 SELECT Upper(@SBTAGExists) AS TAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GEN_TAG29082019
-- --------------------------------------------------



/*



exec USP_MF_GEN_TAG 3396

exec USP_MF_GEN_TAG29082019 8521

	--- SSSUBH
	--- SSSUBHA

*/


CREATE  PROCEDURE [dbo].[USP_MF_GEN_TAG29082019] (@AprRefNo AS VARCHAR(15))      



AS      



DECLARE @count INT = 1,      



 @index2 INT = 1;      



DECLARE @RandomID VARCHAR(32)      



DECLARE @counter SMALLINT      



DECLARE @RandomNumber FLOAT      



DECLARE @RandomNumberInt INT      

DECLARE @LengthInt INT


DECLARE @CurrentCharacter VARCHAR(1)      



DECLARE @ValidCharacters VARCHAR(255)      



DECLARE @FChar VARCHAR (1)   



DECLARE @PANNO VARCHAR(15)     



DECLARE @SBTAGExists VARCHAR(15)  


if (@AprRefNo = '8521')
begin 
	--select 'y'
	--set @LengthInt  = 4
	goto label2
end 
else 
begin 
	select 'n'
	set @LengthInt  = 3
end 
  

SET @PANNO  = (



SELECT PAN from TBL_MF_IDENTITYDETAILS where entryid =  @AprRefNo



)



SET  @SBTAGExists = (      

	

	SELECT ISNULL(SBTAG, '') AS SBTAG      



	FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      



	WHERE PANNO = @PANNO and Branch  != 'MFSB' AND ParentTag IS NULL

)      

   



IF (ISNULL(@SBTAGExists,'') = '')

BEGIN



SET @ValidCharacters = (      



  SELECT FIRSTNAME+ LASTNAME      



  FROM TBL_MF_BASICDETAILS      



   WHERE CAST ( ENTRYID AS VARCHAR(50)) = @APRREFNO      



  )      



SET @FChar  = (      



 SELECT   SUBSTRING(FIRSTNAME, 1,1 )



 FROM TBL_MF_BASICDETAILS      



  WHERE CAST (ENTRYID AS VARCHAR(50)) = @AprRefNo      



 )      



DECLARE @pindex INT;      



WHILE (1 = 1)      



BEGIN      



 SET @pindex = patindex('%[^a-z]%', @ValidCharacters)      



      



 IF (@pindex > 0)      



  SET @ValidCharacters = stuff(@ValidCharacters, @pindex, 1, '')      



 ELSE      



  BREAK;      



END      



Lablel1:      



DECLARE @ValidCharactersLength INT;      



DECLARE @index INT = 0;      



SET @ValidCharactersLength = len(@ValidCharacters)      



SET @CurrentCharacter = ''      



SET @RandomNumber = 0      



SET @RandomNumberInt = 0      



SET @RandomID = ''      



SET NOCOUNT ON      



SET @counter = 1      



SET @index = @count;      



WHILE @counter < = (@LengthInt)      



BEGIN      



 SET @CurrentCharacter = SUBSTRING(@ValidCharacters, @index, 1)      



      



 IF (@count >= @ValidCharactersLength)      



 BEGIN      



  SET @CurrentCharacter = SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZYXWVUTSRQPONMLKJIHGFEDCBA', @index2, 1)      



  SET @index2 = @index2 + 1;      



 END      


 SET @RandomID = @RandomID + @CurrentCharacter      

 SET @counter = @counter + 1      

 SET @index = @index + 1;      



 IF (@counter = 3)      

 BEGIN      

  SET @RandomID = LEFT(@ValidCharacters, 1) + @RandomID      


 END      

END      


IF EXISTS (      

  SELECT SBTAG      

  FROM [196.1.115.167].SB_COMP.DBO.[SB_broker]      

  WHERE sbtag = @FChar + @RandomID      

  )      

BEGIN      

 SET @count = @count + 1;      

 GOTO Lablel1;      



END      

ELSE      



 SELECT Upper(@FChar + @RandomID) AS TAG



 END

 

 ELSE 



 SELECT Upper(@SBTAGExists) AS TAG


 Label2: 

 select upper('SUBHA')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GETDATA
-- --------------------------------------------------



-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 10-04-2017
--USP_GETDATA 'INSERTSBTAG','SJBA','71'
-- =============================================


CREATE PROCEDURE [dbo].[USP_MF_GETDATA]
@PROCESS VARCHAR(100),
@DATA1 VARCHAR(5000)='',
@DATA2 VARCHAR(500)='',
@DATA3 VARCHAR(500)='',
@DATA4 VARCHAR(500)='',
@DATA5 VARCHAR(500)='',
@DATA6 VARCHAR(500)='',
@DATA7 VARCHAR(500)='',
@DATA8 VARCHAR(500)='',
@DATA9 VARCHAR(500)='',
@DATA10 VARCHAR(500)='',
@DATA11 VARCHAR(500)=''
AS
BEGIN
	IF(@PROCESS = 'LOGINLOG')
	BEGIN
		INSERT INTO LOGIN_LOG(USERNAME,LOGIN_DATE,MESSAGE ) VALUES (@DATA1,GETDATE(),@DATA2)
	END
	
	IF(@PROCESS = 'INSERTSBTAG')
	BEGIN
			--UPDATE TBL_MF_BASICDETAILS
			--SET SBTAG=@DATA1
			--WHERE ENTRYID = @DATA2
			
			update TBL_MF_IDENTITYDETAILS
			set ISAPPROVED = 6 
			where ENTRYID = @DATA2
			
			select ID,ENTRYID,FILENAME,
			replace(PATH,'\\10.253.6.118\ApplicationEsign\','https://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/') 
			
			as PATH ,ISDELETE,DOCTYPE,EXCHANGE,SOURCE from  TBL_MF_ESIGNDOCUMENTS
			WHERE ENTRYID = @DATA2 and source = 'SBADMIN' and isdelete=0
			
			declare @ip varchar(100)
			select @ip  = ipAddress from tbl_sbapplicationlog 
			where entryid=@DATA2  and operation = 'CSO Esign Done'  and time  = (select MAX(time) as time from tbl_sbapplicationlog  where entryid=@DATA2  and operation = 'CSO Esign Done')
			
			--exec USP_INHOUSE_INTEGRATION_live @daNareta2 , @ip
			
	END
	
	IF(@PROCESS = 'GETCSOESIGN')
	BEGIN
			
			--select * from TBL_MF_ESIGNDOCUMENTS
			select ID,ENTRYID,FILENAME,NEWFILENAME,
			'https://sbreg.angelbroking.com/sb_registration_files/ApplicationEsign/MF_reg/'+CAST(ENTRYID AS VARCHAR(100))+'/' 
			as PATH ,ISDELETE,DOCTYPE,EXCHANGE,SOURCE from  TBL_MF_ESIGNDOCUMENTS
			WHERE ENTRYID = @DATA2 and source = 'SBESIGN' and isdelete=0
			
	END
	
	
	--IF(@PROCESS = 'GET DOCUMETS AFTER SBADMIN ESIGN')
	--BEGIN
	--		select * from  TBL_ESIGNDOCUMENTS
	--		WHERE ENTRYID = @DATA1 and source = 'SBADMIN' and isdelete=0
	--END
	
	
	IF(@PROCESS = 'REJECTRECORD')
	BEGIN
		--INSERT INTO DBO.TBL_IDENTITYDETAILS(USERNAME,LOGIN_DATE,MESSAGE ) VALUES (@DATA1,GETDATE(),@DATA2)
		
		UPDATE DBO.TBL_MF_IDENTITYDETAILS
		SET REMARK = @DATA1,
		APPROVE_DATE = GETDATE(),
		APPROVE_BY = @DATA2,
		ISAPPROVED = 2
		WHERE ENTRYID = @DATA3

		UPDATE TBL_ESIGNDOCUMENTS
		SET ISDELETE=1
		WHERE ENTRYID=@DATA3
		
		SELECT 1
	END

	IF @PROCESS = 'GET MIS'
	BEGIN
	    SELECT * FROM  TBL_MF_IDENTITYDETAILS
	END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GETDOCUMETSFORESIGN
-- --------------------------------------------------
                

-- =============================================                

-- AUTHOR:  NARENDRA          

-- CREATE DATE: 09-04-2018          

-- DESCRIPTION: <DESCRIPTION,,>                

/*
 USP_MF_GETDOCUMETSFORESIGN
	@EntryID = 21765,
	@Id = 0,
	@process = 'ALL'
 */

-- =============================================               

              

               

CREATE PROCEDURE [dbo].[USP_MF_GETDOCUMETSFORESIGN]                

@EntryID INT =0,      

@ID AS INT  =0 ,      

@process varchar(20)          

AS       

    

             

BEGIN                

  IF  @process ='All'      

  BEGIN 

       

   SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE,SOURCE,isnull(isEsign,0) as isEsign,rm,sourceid,Addedon,addedby,Modifiedon,modifiedby,NewFileName FROM TBL_MF_ESIGNDOCUMENTS     

   WHERE   ENTRYID = @EntryID  and ISDELETE = 0 

   --AND PATH LIKE '\\10.253.6.118\APPLICATIONPDF\MF_REG%' AND DOCTYPE IN('SB_SB_V1','SB_MFSB_V1')   
   AND PATH LIKE '\\10.253.6.118\APPLICATIONPDF\MF_REG%' AND DOCTYPE IN('SB_SB_V1','SB_MFSB_V1')   

    

  declare @SBTag as varchar(20)=''    

    

    

    

  select @SBTag=isnull(SBTag,'') from TBL_MF_IDENTITYDETAILS where ENTRYID = @EntryID       

  if(@SBTag='')    

  begin    

   EXEC USP_MF_GEN_TAG @AprRefNo = @EntryID;      

  end    

  else    

  begin    

   select @SBTag    

  end    

  DECLARE @TotalFileCount INT,@TotalEsignFileCount INT         

  SET @TotalFileCount=(Select Count(1) from TBL_MF_ESIGNDOCUMENTS where EntryID=@EntryID and ISDELETE = 0)        

  SET @TotalEsignFileCount=(Select Count(1) from TBL_MF_ESIGNDOCUMENTS where EntryID=@EntryID AND isEsign=1 and ISDELETE = 0)        

          

  IF @TotalFileCount=@TotalEsignFileCount        

  BEGIN        

   select 1       

  END     

  else    

  begin    

   select 0     

  end    

  --SELECT ID,a.ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE,SOURCE,isnull(isEsign,0) as isEsign,    

  --    rm,sourceid,Addedon,addedby,Modifiedon,modifiedby,NewFileName,b.SBTag FROM TBL_MF_ESIGNDOCUMENTS a,TBL_MF_IDENTITYDETAILS b    

  --    WHERE    

  --    a.ENTRYID = b.ENTRYID and     

  --    PATH LIKE '\\10.253.6.118\APPLICATIONPDF\MF_REG%'     

  -- AND DOCTYPE IN('D1') AND a.ENTRYID = @EntryID  and ISDELETE = 0    

    

  END          

  ELSE       

  IF @process ='UserWise'      

  BEGIN      

   SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE,SOURCE,isnull(isEsign,0) as isEsign,rm,sourceid,Addedon,addedby,Modifiedon,modifiedby,NewFileName FROM TBL_MF_ESIGNDOCUMENTS     

   WHERE  ENTRYID = @EntryID AND ID=@ID and ISDELETE = 0  AND

   PATH LIKE '\\10.253.6.118\APPLICATIONPDF\MF_REG%' AND DOCTYPE IN('SB_SB_V1','SB_MFSB_V1')        

   

   select Emp_name from [INTRANET].[risk].[dbo].emp_info  

   where emp_no = (Select ENTRYBY from TBL_MF_IDENTITYDETAILS where ENTRYID = @EntryID)  

   

   select AadharVaultKey from TBL_MF_IDENTITYDETAILS where ENTRYID = @EntryID

   

  END      

       

              

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GETFILES_ZIP
-- --------------------------------------------------
CREATE PROC [dbo].[USP_MF_GETFILES_ZIP]
@ENTRYID  INT = 0
AS BEGIN


SELECT '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\MF_reg\'+cast (@ENTRYID as varchar(50))+'\'+ FILENAME  as FILENAME FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
UNION 

SELECT  '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\MF_reg\'+cast (@ENTRYID as varchar(50))+'\'+ FILENAME FROM [DBO].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@ENTRYID AND ISDELETE =0
--UNION

--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )  AND ISDELETE =0

UNION
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://1@ENTRYID6.1.115.136:23/','HTTP://1@ENTRYID6.1.115.136:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@ENTRYID AND ISDELETE =0)A

SELECT  '\\INHOUSEALLAPP-FS.angelone.in\APPLICATIONPDF\MF_reg\'+cast (@ENTRYID as varchar(50))+'\'+ b.FILENAME as FILENAME
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_MF_DOCUMENTSUPLOAD 
WHERE  ENTRYID =@ENTRYID AND ISDELETE =0 
--(PATH LIKE '\\1@ENTRYID6.1.115.136\APPLICATIONPDF\%' OR PATH LIKE 'FTP://1@ENTRYID6.1.115.136:23/%') 
)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@ENTRYID AND ISDELETE =0)B
ON A.ID =B.ID 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GetLIST
-- --------------------------------------------------
--exec [USP_MF_GetLIST]
CREATE PROC  [dbo].[USP_MF_GetLIST]      

AS      

BEGIN      

	SET NOCOUNT ON;



	SELECT	ENTRYID,FIRSTNAME,LASTNAME 
	into	#temp_B
	FROM	TBL_MF_BASICDETAILS With(NoLock)



	select	max(time) as CompletionDate,entryid 
	INTO	#temp_C
	from	TBL_MF_Applicationlog 
	where	operation = 'Final Form Submit' 
	group by operation ,entryid



	select	MAX(time) as CompletionDate,entryid 
	INTO	#TEMP_D
	from	TBL_MFSB_Applicationlog With(nolock) 
	where	operation ='Final Form Submit' 
	group by operation, entryid




	  SELECT	A.ENTRYID,
				B.FIRSTNAME + ' ' + B.LASTNAME AS NAME,
				A.PAN,A.ENTRY_DATE,
				Case	when ISNULL(c.CompletionDate,'') <> '' 
						then c.CompletionDate 
						when ISNULL(c1.CompletionDate, '') <> '' 
						then ISNULL(c1.CompletionDate, '') 
						else '' 
						end 'CompletionDate',
				A.ISAPPROVED,
				A.APPROVE_DATE,
				A.sbtag,
				A.Remark,
				A.MODIFY_DATE 
	 FROM		TBL_MF_IDENTITYDETAILS A With(NoLock)
					JOIN      
				#temp_B B
						 ON A.ENTRYID = B.ENTRYID      
					left join 
				#temp_C c
						 ON A.ENTRYID = c.ENTRYID
					left join 
				#TEMP_D c1
						on A.ENTRYID = c1.entryid
	 WHERE		ISAPPROVED IN(1,4)  
	 
	-- 1 and 4 -- pending
	-- 2 rejected
	-- 6 approved
	 
	 DROP TABLE #temp_B
	 DROP TABLE #temp_c
	 DROP TABLE #temp_d
 
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GetLIST_BkUp_2023_07_12
-- --------------------------------------------------
--exec [USP_MF_GetLIST]
CREATE PROC  [dbo].[USP_MF_GetLIST_BkUp_2023_07_12]

AS      

BEGIN      

  SET NOCOUNT ON;
  SELECT A.ENTRYID, B.FIRSTNAME + ' ' + B.LASTNAME AS NAME,   A.PAN,A.ENTRY_DATE,
  case when ISNULL(c.CompletionDate,'') <> '' then c.CompletionDate when ISNULL(c1.CompletionDate, '') <> '' then ISNULL(c1.CompletionDate, '') else '' end 'CompletionDate',
  A.ISAPPROVED,A.APPROVE_DATE,A.sbtag ,A.Remark,A.MODIFY_DATE 
  
 --SELECT A.ENTRYID, B.FIRSTNAME + ' '+B.LASTNAME AS NAME,   A.AADHAARNO,A.PAN,A.ENTRY_DATE ,A.ISAPPROVED,A.APPROVE_DATE,B.sbtag 

 FROM TBL_MF_IDENTITYDETAILS A       

 JOIN      

 (SELECT ENTRYID,FIRSTNAME,LASTNAME FROM TBL_MF_BASICDETAILS) B      

 ON A.ENTRYID = B.ENTRYID      

 left join 

 (select max(time) as CompletionDate,entryid from  TBL_MF_Applicationlog where operation = 'Final Form Submit' group by operation ,entryid) c

 ON A.ENTRYID = c.ENTRYID      
 
  left join 
 (select MAX(time) as CompletionDate,entryid from TBL_MFSB_Applicationlog With(nolock) where operation ='Final Form Submit' group by operation, entryid ) c1
 on A.ENTRYID = c1.entryid


 WHERE ISAPPROVED IN(1,4,6,2)         
 

 END    

 

 

 

 --select * from tbl_sbapplicationlog where entryid = 1862 and operation = 'Final Form Submit'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_GetLIST_KYC20_6206
-- --------------------------------------------------
--exec [USP_MF_GetLIST]
CREATE PROC  [dbo].[USP_MF_GetLIST_KYC20_6206]      

AS      

BEGIN      

	SET NOCOUNT ON;



	SELECT	ENTRYID,FIRSTNAME,LASTNAME 
	into	#temp_B
	FROM	TBL_MF_BASICDETAILS With(NoLock)



	select	max(time) as CompletionDate,entryid 
	INTO	#temp_C
	from	TBL_MF_Applicationlog 
	where	operation = 'Final Form Submit' 
	group by operation ,entryid



	select	MAX(time) as CompletionDate,entryid 
	INTO	#TEMP_D
	from	TBL_MFSB_Applicationlog With(nolock) 
	where	operation ='Final Form Submit' 
	group by operation, entryid




	  SELECT	A.ENTRYID,
				B.FIRSTNAME + ' ' + B.LASTNAME AS NAME,
				A.PAN,A.ENTRY_DATE,
				Case	when ISNULL(c.CompletionDate,'') <> '' 
						then c.CompletionDate 
						when ISNULL(c1.CompletionDate, '') <> '' 
						then ISNULL(c1.CompletionDate, '') 
						else '' 
						end 'CompletionDate',
				A.ISAPPROVED,
				A.APPROVE_DATE,
				A.sbtag,
				A.Remark,
				A.MODIFY_DATE 
	 FROM		TBL_MF_IDENTITYDETAILS A With(NoLock)
					JOIN      
				#temp_B B
						 ON A.ENTRYID = B.ENTRYID      
					left join 
				#temp_C c
						 ON A.ENTRYID = c.ENTRYID
					left join 
				#TEMP_D c1
						on A.ENTRYID = c1.entryid
	 WHERE		ISAPPROVED IN(1,4)         
	 --WHERE		ISAPPROVED IN(2) 
 END    


-- 1 and 4 -- pending
-- 2 rejected
-- 6 approved

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_IDENTITYDETAILS
-- --------------------------------------------------
  
  
-- =============================================  
-- Author:  <Narendra Prajapati>  
-- Create date: <16 Feb 2018>  
-- Description: <Save and Update Identity Details of MF>  
-- =============================================  
--exec [USP_MF_IDENTITYDETAILS] null,'','12/04/1983','AHFPD6986Q','KAILASH.C','','Save MF Identity Details','BDO','::1','','','','CHIRAG SHANTILAL DESAI'  
CREATE PROCEDURE [dbo].[USP_MF_IDENTITYDETAILS]  
 @ENTRYID INT=0,  
 @AADHAARNO VARCHAR(50)='',  
 @DOB VARCHAR(50)='',  
 @PAN VARCHAR(50)='',  
 @ENTRY_BY VARCHAR(50)='',  
 @SBTag VARCHAR(50)='',  
 @operation varchar(500)='' ,  
 @userType varchar(20)='',  
 @employee_code varchar(50) ='',  
 @ipAddress varchar(100)='',  
 @AadhaarDetails varchar(max)='',  
 @AadharVaultKey varchar(100)='',  
 @UID varchar(50)='',  
 @PANName varchar(500)=''  
AS  
BEGIN  
  
declare @WindowsID varchar(100)=''  
declare @EmployeeCode varchar(50)=''  
  
--select @ENTRY_BY = emp_no from risk.dbo.emp_info where email =@ENTRY_BY+'@angelbroking.com'  
  
  
--declare @Emp_No varchar(50)  
  
 --SELECT @ENTRY_BY = emp_no      
 --FROM  [INTRANET].[RISK].[dbo].[emp_info]       
 --WHERE email like @ENTRY_BY + '@angelbroking.com'   
 --AND SeparationDate IS NULL  
  
  
--IF EXISTS  
--(  
-- SELECT emp_no      
-- FROM  [INTRANET].[RISK].[dbo].[emp_info] with   (nolock)      
-- WHERE email like @ENTRY_BY + '@angelbroking.com'   
-- AND SeparationDate IS NULL  
-- )  
--  BEGIN   
--  SELECT   
--   @ENTRY_BY = emp_no      
--  FROM    
--   [INTRANET].[RISK].[dbo].[emp_info] with   (nolock)    
--  WHERE email like @ENTRY_BY + '@angelbroking.com'   
--  AND SeparationDate IS NULL  
--  END   
--  ELSE   
--    BEGIN  
--  SELECT   
--   @ENTRY_BY = emp_no      
--  FROM    
--   [INTRANET].[RISK].[dbo].[emp_info] with   (nolock)      
--  WHERE PANNO like @PAN  
--  AND SeparationDate IS NULL  
--  END   
  
--SELECT @ENTRY_BY = TOP 1 emp_no FROM [196.1.115.237].angelbroking.dbo.[VW_HRMS_MOBILE_EMP_DETAIL] WHERE email like @ENTRY_BY + '@angelbroking.com'   
  
  
-- SET @ENTRY_BY  = (SELECT DISTINCT EMPLOYEE_NUMBER FROM [196.1.115.237].angelbroking.dbo.[VW_HRMS_MOBILE_EMP_DETAIL] WHERE EMP_OFF_EMAIL like @ENTRY_BY + '@angelbroking.com')  
  
-- Added by aslam on 12 June 2019  
SET @EmployeeCode  = (select distinct emp_no from  [RISK].[dbo].[emp_info] where email like @ENTRY_BY + '@angelbroking.com' and Status = 'A')  
  
  
-- Added by Shekhar on 14thJan 2020  
if ISNULL(@EmployeeCode,'') = ''  
begin  
 SET @ENTRY_BY  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @ENTRY_BY + '@angelbroking.com')  
end  
else  
begin  
 SET @ENTRY_BY=@EmployeeCode  
end  
--print @ENTRY_BY    
IF EXISTS (SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE  rtrim(ltrim(PAN))=rtrim(ltrim(@PAN)))  
  BEGIN  
     UPDATE TBL_MF_IDENTITYDETAILS  
     SET   
     --AADHAARNO=@AADHAARNO,  
     --AadhaarDetails = @AadhaarDetails,  
     --ENTRYBY= @ENTRY_BY,  
     sbtag = @SBTag,  
     AadharVaultKey = @AadharVaultKey,  
     U_ID = @UID  
     WHERE  PAN=@PAN  
           SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_MF_IDENTITYDETAILS WHERE  PAN=@PAN  
  
  END  
  
  ELSE  
  BEGIN  
  
  --INSERT  
  
  -- Commented on 25 Oct 2018 by aslam  
  --INSERT INTO TBL_MF_IDENTITYDETAILS(DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,SBTag,AadharVaultKey,U_ID)  
  --VALUES(@DOB,@PAN,0,GETDATE(),@ENTRY_BY,@SBTag,@AadharVaultKey,@UID)  
    
  INSERT INTO TBL_MF_IDENTITYDETAILS(DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,SBTag,AadharVaultKey,U_ID,PANName)  
  VALUES(@DOB,@PAN,0,GETDATE(),@ENTRY_BY,@SBTag,@AadharVaultKey,@UID, @PANName)  
  
  SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
END  
  
/*  
Commented on 18 July 2018  
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID  
*/  
  
SET @employee_code = @ENTRY_BY  
  
  
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018  
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress  
-- END Code     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_IDENTITYDETAILS_19_OCT_2018
-- --------------------------------------------------


-- =============================================
-- Author:		<Narendra Prajapati>
-- Create date: <16 Feb 2018>
-- Description:	<Save and Update Identity Details of MF>
-- =============================================
CREATE PROCEDURE [dbo].[USP_MF_IDENTITYDETAILS_19_OCT_2018]
@ENTRYID INT=0,
@AADHAARNO VARCHAR(50)='',
@DOB VARCHAR(50)='',
@PAN VARCHAR(50)='',
@ENTRY_BY VARCHAR(50)='',
@SBTag VARCHAR(50)='',
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)='',
@AadhaarDetails varchar(max)='',
@AadharVaultKey varchar(100)='',
@UID varchar(50)=''
AS
BEGIN

declare @WindowsID varchar(100)=''

--select @ENTRY_BY = emp_no from risk.dbo.emp_info where email =@ENTRY_BY+'@angelbroking.com'


--declare @Emp_No varchar(50)

 --SELECT @ENTRY_BY = emp_no    
 --FROM  [INTRANET].[RISK].[dbo].[emp_info]     
 --WHERE email like @ENTRY_BY + '@angelbroking.com' 
 --AND SeparationDate IS NULL


IF EXISTS
(
	SELECT emp_no    
	FROM  [INTRANET].[RISK].[dbo].[emp_info] with   (nolock)    
	WHERE email like @ENTRY_BY + '@angelbroking.com' 
	AND SeparationDate IS NULL
 )
  BEGIN 
		SELECT 
			@ENTRY_BY = emp_no    
		FROM  
			[INTRANET].[RISK].[dbo].[emp_info] with   (nolock)  
		WHERE email like @ENTRY_BY + '@angelbroking.com' 
		AND SeparationDate IS NULL
  END 
  ELSE 
    BEGIN
	 SELECT 
			@ENTRY_BY = emp_no    
		FROM  
			[INTRANET].[RISK].[dbo].[emp_info] with   (nolock)    
		WHERE PANNO like @PAN
		AND SeparationDate IS NULL
  END 


IF EXISTS (SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE  rtrim(ltrim(PAN))=rtrim(ltrim(@PAN)))
		BEGIN
					UPDATE TBL_MF_IDENTITYDETAILS
					SET 
					--AADHAARNO=@AADHAARNO,
					--AadhaarDetails = @AadhaarDetails,
					--ENTRYBY= @ENTRY_BY,
					sbtag = @SBTag,
					AadharVaultKey = @AadharVaultKey,
					U_ID = @UID
					WHERE  PAN=@PAN
			        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_MF_IDENTITYDETAILS WHERE  PAN=@PAN

		END

		ELSE
		BEGIN

		--INSERT

		INSERT INTO TBL_MF_IDENTITYDETAILS(DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,SBTag,AadharVaultKey,U_ID)
		VALUES(@DOB,@PAN,0,GETDATE(),@ENTRY_BY,@SBTag,@AadharVaultKey,@UID)

		SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

/*
Commented on 18 July 2018
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
*/

SET @employee_code = @ENTRY_BY


-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 		
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_IDENTITYDETAILS_21_Aug_2018
-- --------------------------------------------------




-- =============================================

-- Author:		<Narendra Prajapati>

-- Create date: <16 Feb 2018>

-- Description:	<Save and Update Identity Details of MF>

-- =============================================

CREATE PROCEDURE [dbo].[USP_MF_IDENTITYDETAILS_21_Aug_2018]

@ENTRYID INT=0,

@AADHAARNO VARCHAR(50)='',

@DOB VARCHAR(50)='',

@PAN VARCHAR(50)='',

@ENTRY_BY VARCHAR(50)='',

@SBTag VARCHAR(50)='',

@operation varchar(500)='' ,

@userType varchar(20)='',

@employee_code varchar(50) ='',

@ipAddress varchar(100)='',

@AadhaarDetails varchar(max)='',

@AadharVaultKey varchar(100)=''



AS

BEGIN



declare @WindowsID varchar(100)=''



select @ENTRY_BY = emp_no from risk.dbo.emp_info where email =@ENTRY_BY+'@angelbroking.com'











IF EXISTS (SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE  rtrim(ltrim(PAN))=rtrim(ltrim(@PAN)))

		BEGIN

					UPDATE TBL_MF_IDENTITYDETAILS

					SET 

					--AADHAARNO=@AADHAARNO,

					--AadhaarDetails = @AadhaarDetails,

					sbtag = @SBTag,

					AadharVaultKey = @AadharVaultKey

					WHERE  PAN=@PAN

			        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_MF_IDENTITYDETAILS WHERE  PAN=@PAN



		END



		ELSE

		BEGIN



		--INSERT



		INSERT INTO TBL_MF_IDENTITYDETAILS(DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,SBTag,AadharVaultKey)

		VALUES(@DOB,@PAN,0,GETDATE(),@ENTRY_BY,@SBTag,@AadharVaultKey)



		SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]



END



/*

Commented on 18 July 2018

select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID

*/



SET @employee_code = @ENTRY_BY





-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018

EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress

-- END Code 		

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INFRASTRUCTURE
-- --------------------------------------------------



CREATE PROC [dbo].[USP_MF_INFRASTRUCTURE]

	@ENTRYID  int =0,
	@MAINOFFICE  varchar(50) ='',
	@INCOMERANGE  varchar(50) ='',
	@OFFICEFRONTFACING  varchar(5) ='',
	@OFFICEGROUNDFLOOR  varchar(5) ='',
	@SOCIALNETWORKING varchar(200) ='',
 --@entryid int ,
	@operation varchar(500)='' ,
	@userType varchar(20)='',
	@employee_code varchar(50) ='',
	@ipAddress varchar(100)=''
AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@ENTRYID )
BEGIN
		INSERT INTO TBL_MF_INFRASTRUCTURE(ENTRYID,MAINOFFICE,INCOMERANGE,OFFICEFRONTFACING,OFFICEGROUNDFLOOR,SOCIALNETWORKING,AddedOn)
		VALUES (@ENTRYID,@MAINOFFICE,@INCOMERANGE,@OFFICEFRONTFACING,@OFFICEGROUNDFLOOR,@SOCIALNETWORKING,GETDATE())

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
--ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
--BEGIN

--			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

--END
ELSE
BEGIN 
        UPDATE TBL_MF_INFRASTRUCTURE 
				SET 
				MAINOFFICE=@MAINOFFICE  ,
				INCOMERANGE=@INCOMERANGE  ,
				OFFICEFRONTFACING=@OFFICEFRONTFACING , 
				OFFICEGROUNDFLOOR=@OFFICEGROUNDFLOOR  ,
				SOCIALNETWORKING=@SOCIALNETWORKING,
				modifiedOn =GETDATE()  
				
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	
END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INHOUSE_INTEGRATION
-- --------------------------------------------------
      
-- =============================================      
-- Author:  Ashok/Suraj      
-- Create date: 05May2018      
-- Description: uPDATE OLD sb details in in-house      
-- =============================================      
--Modified By : Vinod    
--Reason : Update Old Tag which is not MF Failed.    
    
CREATE PROCEDURE [dbo].[USP_MF_INHOUSE_INTEGRATION]      
  @ENTRYID AS INT,        
  @CSOID AS VARCHAR(50)        
      
AS      
BEGIN      
  
 
  
  DECLARE @REFNO NUMERIC(18,0),@SBTAG VARCHAR(30)      
  SELECT @SBTAG = SBTAG FROM TBL_MF_IDENTITYDETAILS  WHERE ENTRYID = @ENTRYID        
  SELECT @REFNO= REFNO FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG      
        
        
  IF EXISTS(SELECT * FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG AND isnull(SB_Broker_Type,'') ='MF')      
  BEGIN       
   EXEC USP_MF_UPDATE_NEWSB @ENTRYID,@CSOID      
   --USP_MF_UPDATE_OLDSB      
   --USP_MF_INSERT_NEWSB      
  END      
  ELSE IF EXISTS(SELECT * FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG AND isnull(SB_Broker_Type,'') <> 'MF')      
  BEGIN       
   EXEC USP_MF_UPDATE_OLDSB @ENTRYID,@CSOID      
   --USP_MF_UPDATE_NEWSB      
   --USP_MF_INSERT_NEWSB      
  END      
  ELSE      
  BEGIN       
   EXEC USP_MF_INSERT_NEWSB @ENTRYID,@CSOID      
   --USP_MF_UPDATE_OLDSB      
   --USP_MF_UPDATE_NEWSB      
   --      
  END      
      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INHOUSE_INTEGRATION_19June2018
-- --------------------------------------------------
  
-- =============================================  
-- Author:  Ashok/Suraj  
-- Create date: 05May2018  
-- Description: uPDATE OLD sb details in in-house  
-- =============================================  


create PROCEDURE [dbo].[USP_MF_INHOUSE_INTEGRATION_19June2018]  
  @ENTRYID AS INT,    
  @CSOID AS VARCHAR(50)    
  
AS  
BEGIN  
  DECLARE @REFNO NUMERIC(18,0),@SBTAG VARCHAR(30)  
  SELECT @SBTAG = SBTAG FROM TBL_MF_IDENTITYDETAILS  WHERE ENTRYID = @ENTRYID    
  SELECT @REFNO= REFNO FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG  
    
    
  IF EXISTS(SELECT * FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG AND SB_Broker_Type ='MF')  
  BEGIN   
   EXEC USP_MF_UPDATE_NEWSB @ENTRYID,@CSOID  
   --USP_MF_UPDATE_OLDSB  
   --USP_MF_INSERT_NEWSB  
  END  
  ELSE IF EXISTS(SELECT * FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG AND SB_Broker_Type <> 'MF')  
  BEGIN   
   EXEC USP_MF_UPDATE_OLDSB @ENTRYID,@CSOID  
   --USP_MF_UPDATE_NEWSB  
   --USP_MF_INSERT_NEWSB  
  END  
  ELSE  
  BEGIN   
   EXEC USP_MF_INSERT_NEWSB @ENTRYID,@CSOID  
   --USP_MF_UPDATE_OLDSB  
   --USP_MF_UPDATE_NEWSB  
   --  
  END  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INSERT_NEWSB
-- --------------------------------------------------
    
-- =============================================    
-- Author:  Ashok/Suraj    
-- Create date: 05May2018    
-- Description: Insert new MF sb details in in-house    
  
--modified on 4th june 2018 for mailed sending code for mf ,By Vinod  

--Modified On 12 Jun 2018 for    insertion failed In Sb_Broker table, By Vinod
-- =============================================    
CREATE PROCEDURE [dbo].[USP_MF_INSERT_NEWSB]    
  @ENTRYID AS INT,      
  @CSOID AS VARCHAR(50)      
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
  DECLARE @REFNO NUMERIC(18,0)       
  SELECT @REFNO= CAST((CAST(DATEPART(DAY, GETDATE()) AS VARCHAR)+CAST( DATEPART(MONTH, GETDATE()) AS VARCHAR)+CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS NUMERIC(18,0) )      
  --SB_BROKER      
    
  print @REFNO      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_BROKER(REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,IPADDRESS,AUTHSIGN,SB_Broker_Type,MF_REG_Date,SBstatus,SEBIRegNo)      
    SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE,     
    B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,      
    B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,      
    B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,      
    /*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,      
    B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,B.ENTRYBY  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,
  
CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END SEBIRegNo    
    --INTO TBL_TEST      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    --JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C      
    --ON B.ENTRYBY = C.EMP_NO      
    LEFT JOIN TBL_MF_ARNDetails D      
    ON A.ENTRYID = D.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
      
     
        
  --SB_CONTACT      
  --RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)      
    SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,      
    'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID      
    
    UNION ALL      
    --OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )      
    SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,      
    'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID      
    
  --SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018      
    
  --SB_DDCHEQUE      
  --SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT       
    
  --MIS.SB_COMP.DBO.SB_BANKOTHERS      
  -- FOR EQUITY  ISCOMMODITY = 0      
    INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,
  
DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)      
    SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
    A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,      
    A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,      
    NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,      
    CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,      
    NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,      
    
    C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,      
    'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS       
    
    FROM TBL_MF_BANKDETAILS A       
    --JOIN TBL_MF_INFRASTRUCTURE B      
    LEFT JOIN TBL_MF_INFRASTRUCTURE B  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID      
    --UNION ALL      
    ---- FOR COMMODITY  ISCOMMODITY = 1      
    --SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
    --A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,      
    --A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,      
    --NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,      
    --CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,      
    --NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,      
    
    --C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,      
    --'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS       
    
    --FROM TBL_BANKDETAILS A       
    --JOIN TBL_INFRASTRUCTURE B      
    --ON A.ENTRYID = B.ENTRYID      
    --JOIN TBL_IDENTITYDETAILS C      
    --ON A.ENTRYID = C.ENTRYID      
    --WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID      
    
        
  --BPREGMASTER      
      
  --drop table #SEGMENTS    
    IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL    
    /*Then it exists*/    
    DROP TABLE #SEGMENTS    
       
    SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM     
    (SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A    
    
    update #SEGMENTS       
    set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END     
    from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID      
    
    
        
    
  --DROP TABLE #SEGMENTS      
    
    INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)      
    
    SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,      
    A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,      
    /*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,      
    A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,      
    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,      
    D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,       
    E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,      
    E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,      
    D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,      
    E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,      
    A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,      
    NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,      
    NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo     
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    JOIN TBL_MF_ADDRESS D      
    ON A.ENTRYID = D.ENTRYID      
    JOIN TBL_MF_ADDRESS E      
    ON A.ENTRYID = E.ENTRYID      
    LEFT JOIN TBL_MF_ARNDetails F      
    ON A.ENTRYID = F.ENTRYID      
    WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID      
    
    
    
    
  --MIS.SB_COMP.DBO.BPAPPLICATION       
    INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)      
    
    SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,      
    CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,      
    C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,      
    NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,      
    NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO      
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    LEFT JOIN TBL_MF_ARNDetails D      
    ON A.ENTRYID = D.ENTRYID      
    WHERE A.ENTRYID =@ENTRYID      
    
    
    
  --MIS.SB_COMP.DBO.SB_PERSONAL      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)      
    
    SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,      
    /*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,      
    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,      
    CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,      
    C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,      
    B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    --JOIN TBL_MF_REGISTRATIONRELATED C      
    LEFT JOIN TBL_MF_REGISTRATIONRELATED C  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020    
    ON A.ENTRYID = C.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
  --MIS.SB_COMP.DBO.TAG_BO_DETAILS      
    INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)      
    SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
   -----New Code to get ARN_from date and ARN_Todate for Mail sending to MF SB 4th may 2018  
      
   declare @validFrom date  
   declare @validTo date  
   declare @ARN_number nvarchar(100)  
   declare @sbtag nvarchar(100)  
   SELECT @ARN_number=D.ARN_Number, @validFrom=D.ARN_FromDate,@validTo=ARN_ToDate,@sbtag=B.SBTag  
   FROM TBL_MF_BASICDETAILS A      
   JOIN TBL_MF_IDENTITYDETAILS B    
       
   ON A.ENTRYID = B.ENTRYID      
   --JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C      
   --ON B.ENTRYBY = C.EMP_NO      
   LEFT JOIN TBL_MF_ARNDetails D      
   ON A.ENTRYID = D.ENTRYID      
   WHERE A.ENTRYID = @ENTRYID    
     
   exec MIS.SB_COMP.DBO.SP_MF_SendMail_NewSBMF @sbtag,@ARN_number,@validFrom,@validTo  
    
  --AFTER SUCCESSFUL COMPLITION OF PROCESS UPDATE STATUS IN TBL_IDENTITYDETAILS TABLE      
    
    UPDATE TBL_MF_IDENTITYDETAILS      
    SET REFNO = @REFNO,      
    ISINHOUSEINTEGRATED = 1      
    WHERE ENTRYID = @ENTRYID      
    
    
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INSERT_NEWSB_Backup12June2018
-- --------------------------------------------------
    
-- =============================================    
-- Author:  Ashok/Suraj    
-- Create date: 05May2018    
-- Description: Insert new MF sb details in in-house    
  
--modified on 4th june 2018 for mailed sending code for mf By Vinod  
-- =============================================    
CREATE PROCEDURE [dbo].[USP_MF_INSERT_NEWSB_Backup12June2018]    
  @ENTRYID AS INT,      
  @CSOID AS VARCHAR(50)      
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
  DECLARE @REFNO NUMERIC(18,0)       
  SELECT @REFNO= CAST((CAST(DATEPART(DAY, GETDATE()) AS VARCHAR)+CAST( DATEPART(MONTH, GETDATE()) AS VARCHAR)+CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS NUMERIC(18,0) )      
  --SB_BROKER      
    
  print @REFNO      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_BROKER(REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,IPADDRESS,AUTHSIGN,SB_Broker_Type,MF_REG_Date,SBstatus,SEBIRegNo)      
    SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE,     
    B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,      
    B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,      
    B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,      
    /*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,      
    B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,
  
CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END SEBIRegNo    
    --INTO TBL_TEST      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C      
    ON B.ENTRYBY = C.EMP_NO      
    JOIN TBL_MF_ARNDetails D      
    ON A.ENTRYID = D.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
      
     
        
  --SB_CONTACT      
  --RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)      
    SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,      
    'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID      
    
    UNION ALL      
    --OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )      
    SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,      
    'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID      
    
  --SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018      
    
  --SB_DDCHEQUE      
  --SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT       
    
  --MIS.SB_COMP.DBO.SB_BANKOTHERS      
  -- FOR EQUITY  ISCOMMODITY = 0      
    INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,
  
DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)      
    SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
    A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,      
    A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,      
    NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,      
    CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,      
    NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,      
    
    C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,      
    'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS       
    
    FROM TBL_MF_BANKDETAILS A       
    JOIN TBL_MF_INFRASTRUCTURE B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID      
    --UNION ALL      
    ---- FOR COMMODITY  ISCOMMODITY = 1      
    --SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
    --A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,      
    --A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,      
    --NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,      
    --CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,      
    --NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,      
    
    --C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,      
    --'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS       
    
    --FROM TBL_BANKDETAILS A       
    --JOIN TBL_INFRASTRUCTURE B      
    --ON A.ENTRYID = B.ENTRYID      
    --JOIN TBL_IDENTITYDETAILS C      
    --ON A.ENTRYID = C.ENTRYID      
    --WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID      
    
        
  --BPREGMASTER      
      
  --drop table #SEGMENTS    
    IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL    
    /*Then it exists*/    
    DROP TABLE #SEGMENTS    
       
    SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM     
    (SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A    
    
    update #SEGMENTS       
    set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END     
    from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID      
    
    
        
    
  --DROP TABLE #SEGMENTS      
    
    INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)      
    
    SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,      
    A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,      
    /*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,      
    A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,      
    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,      
    D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,       
    E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,      
    E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,      
    D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,      
    E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,      
    A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,      
    NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,      
    NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo     
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    JOIN TBL_MF_ADDRESS D      
    ON A.ENTRYID = D.ENTRYID      
    JOIN TBL_MF_ADDRESS E      
    ON A.ENTRYID = E.ENTRYID      
    JOIN TBL_MF_ARNDetails F      
    ON A.ENTRYID = F.ENTRYID      
    WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID      
    
    
    
    
  --MIS.SB_COMP.DBO.BPAPPLICATION       
    INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)      
    
    SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,      
    CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,      
    C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,      
    NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,      
    NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO      
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    JOIN TBL_MF_ARNDetails D      
    ON A.ENTRYID = D.ENTRYID      
    WHERE A.ENTRYID =@ENTRYID      
    
    
    
  --MIS.SB_COMP.DBO.SB_PERSONAL      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)      
    
    SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,      
    /*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,      
    CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,      
    CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,      
    C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,      
    B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_REGISTRATIONRELATED C      
    ON A.ENTRYID = C.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
  --MIS.SB_COMP.DBO.TAG_BO_DETAILS      
    INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)      
    SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE      
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
   -----New Code to get ARN_from date and ARN_Todate for Mail sending to MF SB 4th may 2018  
      
   declare @validFrom date  
   declare @validTo date  
   declare @ARN_number nvarchar(100)  
   declare @sbtag nvarchar(100)  
   SELECT @ARN_number=D.ARN_Number, @validFrom=D.ARN_FromDate,@validTo=ARN_ToDate,@sbtag=B.SBTag  
   FROM TBL_MF_BASICDETAILS A      
   JOIN TBL_MF_IDENTITYDETAILS B    
       
   ON A.ENTRYID = B.ENTRYID      
   JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C      
   ON B.ENTRYBY = C.EMP_NO      
   JOIN TBL_MF_ARNDetails D      
   ON A.ENTRYID = D.ENTRYID      
   WHERE A.ENTRYID = @ENTRYID    
     
   exec MIS.SB_COMP.DBO.SP_MF_SendMail_NewSBMF @sbtag,@ARN_number,@validFrom,@validTo  
    
  --AFTER SUCCESSFUL COMPLITION OF PROCESS UPDATE STATUS IN TBL_IDENTITYDETAILS TABLE      
    
    UPDATE TBL_MF_IDENTITYDETAILS      
    SET REFNO = @REFNO,      
    ISINHOUSEINTEGRATED = 1      
    WHERE ENTRYID = @ENTRYID      
    
    
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_INSERT_NEWSB_v2
-- --------------------------------------------------
    
-- =============================================    
-- Author:		MITESH PARMAR
-- CreatedOn:	April-2024
-- =============================================    
CREATE PROCEDURE [dbo].[USP_MF_INSERT_NEWSB_v2]
  @ENTRYID AS INT,      
  @CSOID AS VARCHAR(50)      
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
  DECLARE @REFNO NUMERIC(18,0)       
  SELECT @REFNO= CAST((CAST(DATEPART(DAY, GETDATE()) AS VARCHAR)+CAST( DATEPART(MONTH, GETDATE()) AS VARCHAR)+CAST(DATEPART(YEAR, GETDATE()) AS VARCHAR) + DBO.[FN_LPAD_LEADING_ZERO] (3,@ENTRYID)) AS NUMERIC(18,0) )      
  --SB_BROKER      
    
  print @REFNO      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_BROKER
	(
			REFNO,SBTAG,BRANCH,PARENTTAG,TRADENAME,
			ORGTYPE,DOI,SALCONTACTPERSON,CONTACTPERSON,REGCAT,
			PANNO,LEADSOURCE,EMPID,PANVERIFIED,TAGGENERATEDDATE,
			REGSTATUS,RECSTATUS,CRTBY,CRTDT,PRINTED,
			TRADENAMEINCOMMODITY,DOICOR,PANNOCORP,MAKERPAN,CHECKERPAN,
			MAKERID,CHECKERID,APPSTATUS,REJECTREASONS,TIMESTAMP,
			IPADDRESS,AUTHSIGN,SB_Broker_Type,MF_REG_Date,
			SBstatus,SEBIRegNo
	)
    SELECT	@REFNO AS REFNO,
			B.SBTAG,
			A.BranchTag AS BRANCH,
			'' AS PARENTTAG, 
			A.TRADENAME AS TRADENAME, 
			
			CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE,
			B.ENTRY_DATE AS DOI, 
			A.Salutation AS SALCONTACTPERSON,
			A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, 
			CASE WHEN A.OrganizationType = 'INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,

			B.PAN AS PANNO,
			'D-REG' AS LEADSOURCE,
			B.ENTRYBY AS EMPID,
			'Y' AS PANVERIFIED, 
			GETDATE() AS TAGGENERATEDDATE,
			
			0 AS REGSTATUS,
			NULL AS RECSTATUS,      
			B.ENTRYBY AS CRTBY,
			B.ENTRY_DATE  AS CRTDT,
			1 AS PRINTED,      

			'' AS TRADENAMEINCOMMODITY,
			CONVERT(DATETIME,B.DOB,103) AS DOICOR,
			B.PAN AS PANNOCORP,
			B.PAN AS MAKERPAN,
			B.PAN AS CHECKERPAN,

    
			B.ENTRYBY AS MAKERID,
			NULL AS CHECKERID,
			'A' AS APPSTATUS,
			NULL AS REJECTREASONS,
			GETDATE() AS TIMESTAMP,
			
			@CSOID AS IPADDRESS,
			B.ENTRYBY  AS AUTHSIGN,
			'MF' as SB_Broker_Type,
			GETDATE() as MF_REG_Date,
			CASE WHEN D.IsARN = 1 THEN 'REG' ELSE NULL END AS SBstatus, -- v2
  
			CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END SEBIRegNo   -- v2 
    
	
    FROM	TBL_MF_BASICDETAILS A      with(Nolock)
				JOIN 
			TBL_MF_IDENTITYDETAILS B        with(Nolock)
					ON A.ENTRYID = B.ENTRYID      
				LEFT JOIN 
			TBL_MF_ARNDetails D        with(Nolock)
					ON A.ENTRYID = D.ENTRYID      
    WHERE	A.ENTRYID = @ENTRYID      
      
     
             
    
    INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT
	(
		REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,
		CITY,STATE,COUNTRY,PINCODE,STDCODE,
		TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,
		CRTDT
	)      
    SELECT 
			@REFNO AS REFNO,
			'MFRES' AS ADDTYPE ,
			A.ADDRESS1 AS ADDLINE1,
			A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,
			A.AREA AS LANDMARK,
			
			A.CITY AS CITY,
			A.STATE AS STATE,      
			'INDIA' AS COUNTRY,
			A.PIN AS PINCODE,
			A. STD AS STDCODE,
			
			A. PHONE AS TELNO,
			A. MOBILE AS MOBNO,
			A. EMAIL AS EMAILID,
			NULL AS RECSTATUS,
			B.ENTRYBY AS CRTBY,
			
			B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID      
    
    UNION ALL      
    --OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )      
    SELECT 
			@REFNO AS REFNO,
			'MFOFF' AS ADDTYPE ,
			A.ADDRESS1 AS ADDLINE1,
			A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,
			A.AREA AS LANDMARK,
			
			A.CITY AS CITY,
			A.STATE AS STATE,      
			'INDIA' AS COUNTRY,
			A.PIN AS PINCODE,
			A. STD AS STDCODE,
			
			A. PHONE AS TELNO,
			A. MOBILE AS MOBNO,
			A. EMAIL AS EMAILID,
			NULL AS RECSTATUS,
			B.ENTRYBY AS CRTBY,  
			
			B.ENTRY_DATE AS CRTDT      
    FROM TBL_MF_ADDRESS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID      
    
  --SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018      
    
  --SB_DDCHEQUE      
  --SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT       
    
  --MIS.SB_COMP.DBO.SB_BANKOTHERS      
  -- FOR EQUITY  ISCOMMODITY = 0      
    INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS
	(
		REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,
		BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,
		IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,
		TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,
		DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,
		SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,
		MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,
		COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS
)      
    SELECT 
			@REFNO AS REFNO,
			A.NAMEINBANK AS NAMEINBANK , -- V2
			CASE	WHEN A.ACCOUNTTYPE = 'CURRENT' THEN 'CR'  
					WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
			A.ACCOUNTNO AS ACCNO,
			A.BANKNAME AS BANKNAME ,
			
			A.ADDRESS AS  BRANCHADD1,
			'' AS BRANCHADD2,
			'' AS BRANCHADD3,
			'' AS BRANCHPIN ,
			A.MICR AS  MICRCODE,      
			
			A.IFSCRGTS AS IFSRCODE,
			REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS INCOMERANGE, -- v2
			CASE	WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' 
					WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' 
					WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' 
					END AS BUSINESSLOC,  -- V2
					
					    
			NULL AS NOMINEEREL,
			NULL AS NOMINEENAME,
			
			NULL AS TERMINALLOCATION,      
			CASE	WHEN B.SOCIALNETWORKING = '< 500 PEOPLE' THEN '500' 
					WHEN B.SOCIALNETWORKING = '500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET, --v2     
			NULL AS LANGUAGE,
			NULL AS TRADINGACC,
			NULL AS ACCCLIENTCODE,
			
			NULL AS DEMATACCNO,
			NULL AS REGOTHER,
			NULL AS REGEXGNAME,
			NULL AS REGSEG,
			NULL AS SEBIACTION,
			
			NULL AS SEBIACTDET,
			NULL AS RECSTATUS,      
    
			C.ENTRYBY AS CRTBY,
			C.ENTRY_DATE AS CRTDT,
			NULL AS MDYBY,
			NULL AS MDYDT,
			NULL AS NOOFBRANCHOFFICES,
			
			NULL AS TOTAREASQFEET,
			NULL AS TOTNOOFDEALERS,
			NULL AS TOTNOOFTERMINALS,      
			'MF' AS COMPANY,
			NULL AS MAKERID,
			
			NULL AS CHECKERID,
			NULL AS TIMESTAMP,
			@CSOID  AS IPADDRESS       
    
    FROM TBL_MF_BANKDETAILS A       
    --JOIN TBL_MF_INFRASTRUCTURE B      
    LEFT JOIN TBL_MF_INFRASTRUCTURE B  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID      
    --UNION ALL      
    ---- FOR COMMODITY  ISCOMMODITY = 1      
    --SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,      
    --A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,      
    --A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,      
    --NULL AS NOMINEEREL,NULL ASNOMINEENAME,NULL ASTERMINALLOCATION,      
    --CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,      
    --NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,      
    
    --C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,      
    --'COMMODITY' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,NULL AS IPADDRESS       
    
    --FROM TBL_BANKDETAILS A       
    --JOIN TBL_INFRASTRUCTURE B      
    --ON A.ENTRYID = B.ENTRYID      
    --JOIN TBL_IDENTITYDETAILS C      
    --ON A.ENTRYID = C.ENTRYID      
    --WHERE A.ISCOMMODITY = 1 AND A.ENTRYID =@ENTRYID      
    
        
  --BPREGMASTER      
      
  --drop table #SEGMENTS    
    IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL    
    /*Then it exists*/    
    DROP TABLE #SEGMENTS    
       
    SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM     
    (SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A    
    
    update #SEGMENTS       
    set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END     
    from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID      
    
    
        
    
  --DROP TABLE #SEGMENTS      
    
    INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER
	(
		REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,
		TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,
		REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,
		REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,
		REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,
		REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,
		REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,
		REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,
		GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,
		UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,
		BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],
		REASON,FILENAME,ATTACHMENT,RegNo
    )      
    
    SELECT 
			@REFNO AS REGAPRREFNO,
			C.SBTAG AS REGTAG,
			B.SEGMENT AS REGEXCHANGESEGMENT,
			A.Salutation AS NAMESALUTATION, -- v2   
			A.FIRSTNAME + ' ' + A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,
			
			'' AS TRADENAMESALUTATION,
			A.TRADENAME AS REGTRADENAME,      
			'' AS REGFATHERHUSBANDNAME,      
			A.OrganizationType AS TYPE,
			CONVERT(DATETIME,C.DOB,103) AS REGDOB,      
			
			CASE	WHEN A.GENDER = 'MALE' THEN 'M' 
					WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,      
					D.ADDRESS1 AS  REGRESADD1,
					D.ADDRESS2 AS  REGRESADD2,
					D.ADDRESS3 AS REGRESADD3,
					
			D.CITY AS REGRESCITY,
			D.PIN AS  REGRESPIN,       
			E.ADDRESS1 AS REGOFFADD1,
			E.ADDRESS2 AS REGOFFADD2, 
			E.ADDRESS3 AS REGOFFADD3,
			
			E.CITY AS REGOFFCITY,
			E.PIN AS REGOFFPIN,
			E.PHONE AS REGOFFPHONE,      
			E.MOBILE AS  REGMOBILE,
			'' AS REGMOBILE2,

			D.MOBILE AS REGRESPHONE,
			'' AS REGRESFAX,
			C.PAN AS REGPAN,
			NULL AS REGPAN_APPLIED,      
			D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,
			
			NULL AS REGMAPIN,
			NULL AS REGPROPRIETORSHIPYN,
			NULL AS REGEXPINYRS,
			NULL AS REGRESIDENTIALSTATUS,      
			E.EMAIL AS REGEMAILID,
			
			NULL AS REGREFERENCETAG,
			NULL AS REGMKRID,
			NULL AS REGMKRDT,      
			A.BranchTag AS TAGBRANCH,
			
			'21'+C.SBTAG AS  GLUNREGISTEREDCODE,
			'28'+C.SBTAG AS GLREGISTEREDCODE,
			CASE	WHEN F.IsARN = 1 THEN 'Registered' 
					ELSE 'Not Applied' END  AS REGSTATUS,      -- v2
			NULL AS REGDATE,
			NULL AS REGNO,
			
			NULL AS UPLOAD,
			NULL AS ALIAS,
			NULL AS ALIASNAME,
			NULL AS REGPORTALNO,
			NULL AS REGINTIMATEDATE,
			
			NULL AS BO_UPDATE,
			NULL AS CTS,      
			NULL AS PLS,
			NULL AS [ADDRESS STATUS],
			NULL AS [ADDRESS INTIMATE DATE],
			
			NULL AS REASON,
			NULL AS FILENAME,
			NULL AS ATTACHMENT,
			CASE	WHEN F.IsARN =1 THEN F.ARN_Number 
					ELSE NULL END AS RegNo     -- v2
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    JOIN TBL_MF_ADDRESS D      
    ON A.ENTRYID = D.ENTRYID      
    JOIN TBL_MF_ADDRESS E      
    ON A.ENTRYID = E.ENTRYID      
    LEFT JOIN TBL_MF_ARNDetails F      
    ON A.ENTRYID = F.ENTRYID      
    WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID      
    
    
    
    
  --MIS.SB_COMP.DBO.BPAPPLICATION       
    INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION
	(
		APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,
		STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,
		CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,
		MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,
		INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,
		CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO
	)
    
    SELECT	@REFNO AS APPREFNO,
			B.SEGMENT AS  EST,
			NULL AS TERMINALLOCATION,
			GETDATE() AS APPDATE,      
			CASE WHEN D.IsARN = 1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS, -- v2
			
			NULL AS STATUSDATE,
			NULL AS CSOREMARKS,
			NULL AS EXCHREMARKS,
			CASE	WHEN D.IsARN =1 THEN D.ARN_Number 
					ELSE NULL END AS SEBIREGNO,      -- v2
			C.ENTRYBY AS  CRUSER,
			
			C.ENTRY_DATE AS CRDATE,
			NULL AS MODUSER,
			NULL AS MODDATE,
			NULL AS APPAUTHORISED_PERSON,
			NULL AS MODE,      
    
			NULL AS CLIENT_CODE,
			NULL AS DDNO,
			NULL AS BANK_NAME,
			NULL AS SEBIPORTALNO,
			NULL AS INTIMATEDATE,
			
			NULL AS SEBIQUERY,
			NULL AS CSOCOMMENTS,      
			NULL AS FILENO,
			NULL AS MAKERID,
			NULL AS CHECKID,
			
			@CSOID AS IPADDRESS,
			NULL AS TIMESTAMP,
			NULL AS CHECKERSTATUS,
			NULL AS CHECKERSEBIREGNO      
    
    FROM TBL_MF_BASICDETAILS A      
    JOIN #SEGMENTS B      
    ON A.ENTRYID = B.ENTRYID      
    JOIN TBL_MF_IDENTITYDETAILS C      
    ON A.ENTRYID = C.ENTRYID      
    LEFT JOIN TBL_MF_ARNDetails D      
    ON A.ENTRYID = D.ENTRYID      
    WHERE A.ENTRYID =@ENTRYID      
    
    
    
  --MIS.SB_COMP.DBO.SB_PERSONAL      
    
    INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL
	(
		REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,
		FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,
		OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,
		TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,
		CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,
		SPOUSEOCC,TIMESTAMP,IPADDRESS
	)      
    SELECT 
			@REFNO AS REFNO,
			A.SALUTATION AS SALUTATION,  --v2
			A.FIRSTNAME AS  FIRSTNAME, 
			A.MIDDLENAME AS MIDDLENAME,
			A.LASTNAME AS  LASTNAME,      
    
			'' AS FATHHUSBNAME, 
			CONVERT(DATETIME,B.DOB,103) AS DOB,      
			CASE	WHEN A.GENDER = 'MALE' THEN 'M' 
					WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,      
			CASE	WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' 
					WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,      
			C.EDUQUALI AS EDUQUAL,
			
			C.OCCUPATION AS  OCCUPATION,
			C.NATUREOFOCCUPATION AS OCCDETAILS,
			NULL AS EXPDETAILS,
			NULL AS BROKINGCOMPANY,
			NULL AS TRADMEMBER,
			
			NULL AS BROKEXP,
			NULL AS PHOTOGRAPH,
			NULL AS SIGNATURE,
			NULL AS RECSTATUS,      
			B.ENTRYBY AS CRTBY,
			
			B.ENTRY_DATE AS CRTDT,
			NULL AS MDYBY,
			NULL AS MDYDT,
			NULL AS OCCUPATIONDETAILS,
			NULL AS SPOUSEOCC,
			
			NULL AS TIMESTAMP,
			@CSOID AS IPADDRESS
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    --JOIN TBL_MF_REGISTRATIONRELATED C      
    LEFT JOIN TBL_MF_REGISTRATIONRELATED C  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020    
    ON A.ENTRYID = C.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
  --MIS.SB_COMP.DBO.TAG_BO_DETAILS      
    INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS
	(
		TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE
	)      
    SELECT	B.SBTAG AS TAG,
			B.ENTRY_DATE AS  TAG_DATE,
			'N' AS  BO_TAG_UPDATE,
			NULL AS  BO_TAG_UPDATE_DATE
    FROM TBL_MF_BASICDETAILS A      
    JOIN TBL_MF_IDENTITYDETAILS B      
    ON A.ENTRYID = B.ENTRYID      
    WHERE A.ENTRYID = @ENTRYID      
    
   -----New Code to get ARN_from date and ARN_Todate for Mail sending to MF SB 4th may 2018  
      
   declare @validFrom date  
   declare @validTo date  
   declare @ARN_number nvarchar(100)  
   declare @sbtag nvarchar(100)  
   SELECT @ARN_number=D.ARN_Number, @validFrom=D.ARN_FromDate,@validTo=ARN_ToDate,@sbtag=B.SBTag  
   FROM TBL_MF_BASICDETAILS A      
   JOIN TBL_MF_IDENTITYDETAILS B    
       
   ON A.ENTRYID = B.ENTRYID      
   --JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C      
   --ON B.ENTRYBY = C.EMP_NO      
   LEFT JOIN TBL_MF_ARNDetails D      
   ON A.ENTRYID = D.ENTRYID      
   WHERE A.ENTRYID = @ENTRYID    
     
   exec MIS.SB_COMP.DBO.SP_MF_SendMail_NewSBMF @sbtag,@ARN_number,@validFrom,@validTo  
    
  --AFTER SUCCESSFUL COMPLITION OF PROCESS UPDATE STATUS IN TBL_IDENTITYDETAILS TABLE      
    
    UPDATE TBL_MF_IDENTITYDETAILS      
    SET REFNO = @REFNO,      
    ISINHOUSEINTEGRATED = 1      
    WHERE ENTRYID = @ENTRYID      
    
    
    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_PaymentDetails
-- --------------------------------------------------


-- =============================================

-- Create date: <17 Feb 2018>
-- Description:	<Save And Update Payment Details>
-- =============================================
CREATE PROCEDURE [dbo].[USP_MF_PaymentDetails] 
@EntryID INT=0,
@Amount INT=0,
@Instrument_No BIGINT=0,
@DATE VARCHAR(100)='',
@PaymentMode VARCHAR(200)='',	
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM TBL_MF_PaymentDetails WHERE EntryID=@EntryID)
	BEGIN
		INSERT INTO TBL_MF_PaymentDetails VALUES(@EntryID,
											@Amount,
											@Instrument_No,
											@DATE,
											@PaymentMode,
											GETDATE(),
											GETDATE()
											)
		SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 											
	END
	ELSE
	BEGIN
		UPDATE TBL_MF_PaymentDetails SET	Amount=@Amount,
											Instrument_No=@Instrument_No,
											DATE=@DATE,
											PaymentMode=@PaymentMode,
											ModifiedOn=GETDATE()
											WHERE EntryID=@EntryID

		SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 												
	END
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID	
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_REGISTRATIONRELATED
-- --------------------------------------------------

-- =============================================

-- Create date: <19 Feb 2018>
-- Description:	<Save and Updated Data for Registration Related>
-- =============================================
create PROCEDURE [dbo].[USP_MF_REGISTRATIONRELATED]
	@ID int  =0,
	@ENTRYID int  =0,
	@AADHAARNO varchar (50) ='',
	@EDUQUALI varchar (200) ='',
	@OTHERQUALI varchar (200) ='',
	@OCCUPATION varchar (200) ='',
	@NATUREOFOCCUPATION varchar (200) ='',
	@OTHEROCCUPATION varchar (200) ='',
	@CAPITALMARKET varchar (200) ='',
	@OTHEREXPERIENCE varchar (200) ='',
	@PREBROKER varchar (200) ='',
	@AUTHPERSON varchar (50) ='',
	@WHETHERANY varchar (50) ='',
	@MEMBERSHIPDETAILS varchar (200) ='',
	@TRADINGACC varchar (50) ='',
	@FATHERHUSBAND varchar (50) ='',
	@contactPerson varchar (50) ='',
	@contactPersonOccupation varchar (50) ='',
	@contractSignatory varchar(200)='',
	@operation varchar(500)='' ,
	@userType varchar(20)='',
	@employee_code varchar(50) ='',
	@ipAddress varchar(100)=''
AS
BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@ENTRYID )
BEGIN
		INSERT INTO TBL_MF_REGISTRATIONRELATED(ENTRYID,AADHAARNO,EDUQUALI,OTHERQUALI,OCCUPATION,NATUREOFOCCUPATION,OTHEROCCUPATION,CAPITALMARKET,OTHEREXPERIENCE,PREBROKER,AUTHPERSON,WHETHERANY,MEMBERSHIPDETAILS,TRADINGACC,FATHERHUSBAND,contactPerson,contactPersonOccupation,contractSignatory,AddedOn)
		VALUES (@ENTRYID,@AADHAARNO,@EDUQUALI,@OTHERQUALI,@OCCUPATION,@NATUREOFOCCUPATION,@OTHEROCCUPATION,@CAPITALMARKET,@OTHEREXPERIENCE,@PREBROKER,@AUTHPERSON,@WHETHERANY,@MEMBERSHIPDETAILS,@TRADINGACC,@FATHERHUSBAND,@contactPerson,@contactPersonOccupation,@contractSignatory,GETDATE())

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_MF_REGISTRATIONRELATED 
				SET 
	            AADHAARNO=@AADHAARNO  ,
				EDUQUALI=@EDUQUALI  ,
				OTHERQUALI=@OTHERQUALI , 
				OCCUPATION=@OCCUPATION  ,
				NATUREOFOCCUPATION=@NATUREOFOCCUPATION  ,
				OTHEROCCUPATION=@OTHEROCCUPATION  ,
				CAPITALMARKET=@CAPITALMARKET , 
				OTHEREXPERIENCE=@OTHEREXPERIENCE  ,
				PREBROKER=@PREBROKER  ,
				AUTHPERSON=@AUTHPERSON  ,
				WHETHERANY=@WHETHERANY , 
				MEMBERSHIPDETAILS=@MEMBERSHIPDETAILS  ,
				TRADINGACC=@TRADINGACC  ,
				FATHERHUSBAND=@FATHERHUSBAND,
				contactPerson =@contactPerson ,
				contactPersonOccupation = @contactPersonOccupation,
				contractSignatory=@contractSignatory,
				modifiedOn =GETDATE()
				
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, ERROR_MESSAGE() AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SAVE_FORM
-- --------------------------------------------------



CREATE PROC [dbo].[USP_MF_SAVE_FORM]  
@ENTRYID INT=0,  
@TYPE_ESIGNDOC  TYPE_MF_ESIGNDOC READONLY  
AS BEGIN   
  
    UPDATE  [TBL_MF_ESIGNDOCUMENTS]  
    SET ISDELETE=1   
    WHERE ENTRYID=@ENTRYID  
      
    INSERT INTO TBL_MF_ESIGNDOCUMENTS(ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,ESIGNNAME,SOURCE)  
    SELECT ENTRYID,FILENAME,FILEPATH,0,DOCTYPE,ESIGNNAME,'SBESIGN' FROM @TYPE_ESIGNDOC  
         
  
     UPDATE TBL_MF_IDENTITYDETAILS  
     SET ISAPPROVED=1  
     WHERE  ENTRYID=@ENTRYID  
  
     SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE],replace(PATH,'\\10.253.6.118','http://sbreg.angelbroking.com/sb_registration_files') as PATH from TBL_MF_ESIGNDOCUMENTS where ENTRYID = @ENTRYID  
 
  declare @employee_code varchar(50)
   select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID	
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @EntryID,'Final Form Submit','',@employee_code,''

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SaveNomineeDetails
-- --------------------------------------------------


-- =============================================
-- Author:		<Narendra Prajapati>
-- Create date: <16 Feb 2018>
-- Description:	<Save and Update nominee Details>
-- =============================================
CREATE PROCEDURE [dbo].[USP_MF_SaveNomineeDetails]
@EntryID INT=0 ,
@FirstName VARCHAR(100)='',
@MiddleName VARCHAR(100)='',
@LastName VARCHAR(100)='',
@DOB VARCHAR(100)='',
@PanNumber VARCHAR(100)='',
@AddressLine1 VARCHAR(500)='',
@AddressLine2 VARCHAR(500)='',
@AddressLine3 VARCHAR(500)='',
@State VARCHAR(500)='',
@City VARCHAR(500)='',
@Pincode VARCHAR(500)='',
@RelationShip VARCHAR(100)='',
@GuardianFname VARCHAR(100)='',
@GuardianMname VARCHAR(100)='',
@GuardianLname VARCHAR(100)='',
@GuardianDOB VARCHAR(100)='',
@GuardianPAN VARCHAR(100)='',
@GuardianAddressLine1 VARCHAR(500)='',
@GuardianAddressLine2 VARCHAR(500)='',
@GuardianAddressLine3 VARCHAR(500)='',
@GuardianState VARCHAR(500)='',
@GuardianCity VARCHAR(500)='',
@GuardianPincode VARCHAR(500)='',
@operation varchar(500)='' ,
@userType varchar(20)='',
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM TBL_MF_NomineeDetails WHERE EntryId =@EntryID )
	BEGIN
		INSERT INTO TBL_MF_NomineeDetails(EntryId,FirstName,MiddleName,LastName,DOB,PanNumber,AddressLine1,AddressLine2,AddressLine3,State,City,PinCode,
		                    RelationShip,GuardianFname,GuardianMname,GuardianLname,GuardianDOB,GuardianPAN,
							GuardianAddressLine1,GuardianAddressLine2,GuardianAddressLine3,GuardianState,GuardianCity,GuardianPincode,AddedOn)
		                   VALUES (@EntryID,
							@FirstName,
							@MiddleName,
							@LastName,
							@DOB,
							@PanNumber,
							@AddressLine1,
							@AddressLine2,
							@AddressLine3,
							@State,
							@City,
							@Pincode,
							@RelationShip,
							@GuardianFname,
							@GuardianMname,
							@GuardianLname,
							@GuardianDOB,
							@GuardianPAN,
							@GuardianAddressLine1,
							@GuardianAddressLine2,
							@GuardianAddressLine3,
							@GuardianState,
							@GuardianCity,
							@GuardianPincode,
							GETDATE()
							
							)
		SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
									
	END
	ELSE 
	BEGIN
		UPDATE TBL_MF_NomineeDetails SET 
							FirstName=@FirstName,
							MiddleName=@MiddleName,
							LastName=@LastName,
							DOB=@DOB,
							PanNumber=@PanNumber,
							AddressLine1=@AddressLine1,
							AddressLine2=@AddressLine2,
							AddressLine3=@AddressLine3,
							State=@State,
							City=@City,
							Pincode=@Pincode,
							RelationShip=@RelationShip,
							GuardianFname=@GuardianFname,
							GuardianMname=@GuardianMname,
							GuardianLname=@GuardianLname,
							GuardianDOB=@GuardianDOB,
							GuardianPAN=@GuardianPAN,
							GuardianAddressLine1=@GuardianAddressLine1,
							GuardianAddressLine2=@GuardianAddressLine2,
							GuardianAddressLine3=@GuardianAddressLine3,
							GuardianState=@GuardianState,
							GuardianCity=@GuardianCity,
							GuardianPincode=@GuardianPincode,
							ModifiedOn =GETDATE()
						
							WHERE EntryId = @EntryID
     
     SELECT @EntryID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
     							
	END
select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID	
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
EXEC usp_mfapplicationlog @EntryID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_MF_sbapplicationlog
-- --------------------------------------------------


CREATE proc [dbo].[usp_MF_sbapplicationlog]
(

@entryid int ,
@operation varchar(500) ,
@userType varchar(20),
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
)
as
begin 

	if(@userType = 'BDO')
	begin
	select @employee_code = ENTRYBY from TBL_IDENTITYDETAILS where ENTRYID=@entryid
		insert into tbl_sbapplicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
	end
	else
	begin
	select @employee_code = ENTRYBY from TBL_IDENTITYDETAILS where ENTRYID=@entryid
		insert into tbl_MF_sbapplicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
		
	
	end

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SBGETDATA
-- --------------------------------------------------
  
  
 -- USP_MF_SBGETDATA 'GET ALL APP OBJECTS','KUNWAR.SINGH'
  
  
CREATE PROCEDURE [dbo].[USP_MF_SBGETDATA] --'GET APP','9526'    
  
@PROCESS VARCHAR(50)='',    
  
@FILTER1 VARCHAR(50)='',    
  
@FILTER2 VARCHAR(50)=''  
  
AS    
  
BEGIN    
  
 IF @PROCESS ='GET APP LIST'    
  
BEGIN    
  
  
  
--comment on 22 Oct 2018  by aslam   
  
--SELECT *, 0 as ISMF,''AadhaarDetails FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
--UNION ALL    
  
--SELECT *, 1 as ISMF FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
    
  
    
  
SELECT *, 1 as ISMF,'' AadhaarDetails FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
  
  
END    
  
    
  
IF @PROCESS ='GET EMP NAME'    
  
BEGIN    
  
    
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1    
  
    
  
END    
  
    
  
IF @PROCESS ='GET MASTER DATA'    
  
BEGIN    
  
    
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,    
  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,    
  
--RTRIM (LTRIM (ZONE)) AS ZONE,    
  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,    
  
--RTRIM (LTRIM (REGION)) AS REGION,    
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,    
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL     
  
    
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A    
  
--JOIN (SELECT     
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,    
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B    
  
--ON A.BR_CODE=B.BR_CODE     
  
    
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION      
  
FROM [CSOKYC-6].GENERAL.DBO.BO_REGION    
  
    
  
    
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL    
  
    
  
SELECT ISIN,SCRIPNAME FROM [CSOKYC-6].GENERAL.DBO.SCRIP_MASTER WHERE 1=2    
  
    
  
SELECT * FROM TBL_CONTRACTOR_SIGN    
  
    
  
END    
  
    
  
IF @PROCESS ='GET APP'    
  
BEGIN    
  
    
  
SELECT *  FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=CAST(@FILTER1 AS INT)      
  
SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=CAST(@FILTER1 AS INT)      
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'      
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1      
  
  
  
-- Added is 22 Oct 2018 by aslam  
  
  
  
SELECT A.*, B.SBTAG AS SBTAGLIST FROM TBL_MF_IDENTITYDETAILS A LEFT OUTER JOIN  TBL_MF_SBTAGOPTION B  
  
ON A.PAN =  B.PAN  
  
WHERE ENTRYID = @FILTER1      
  
    
  
    
  
--SELECT * FROM TBL_MF_ARNDetails WHERE ENTRYID=@FILTER1      
  
    
  
select     
  
EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,    
  
CASE Exam_tentative_FromDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_FromDate, 120),1,10) End As 'Exam_tentative_FromDate',    
  
CASE Exam_tentative_ToDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_ToDate, 120),1,10)  End As 'Exam_tentative_ToDate',    
  
CASE ARN_FromDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, ARN_FromDate, 120),1,10)  End As 'ARN_FromDate',    
  
CASE ARN_ToDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar,ARN_ToDate, 120),1,10)  End As 'ARN_ToDate',  
  
EUINumber  
  
from tbl_MF_ARNDETAILS    
  
WHERE ENTRYID=@FILTER1    
  
    
  
--select EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,    
  
--Convert(varchar,Exam_tentative_FromDate,111) as Exam_tentative_FromDate,    
  
--Convert(varchar,Exam_tentative_ToDate,111) as Exam_tentative_ToDate,    
  
--Convert(varchar,ARN_FromDate,111) as ARN_FromDate,    
  
--Convert(varchar,ARN_ToDate,111) as ARN_ToDate    
  
--from tbl_MF_ARNDETAILS    
  
--WHERE ENTRYID=@FILTER1    
  
    
  
    
  
SELECT * FROM TBL_MF_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1      
  
    
  
--SELECT * FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1      
  
    
  
SELECT EntryID,Amount,Instrument_No,SUBSTRING(convert(varchar,DATE, 120),1,10) as 'DATE',PaymentMode FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1      
  
    
  
    
  
select * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1     
  
--SELECT * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1      
  
    
  
END    
  
    
  
--IF @PROCESS ='GET APP ADMIN'    
  
--BEGIN    
  
    
  
--SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1    
  
    
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0    
  
--UNION     
  
--SELECT * from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0    
  
--UNION    
  
----SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://10.253.6.118:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE      
  
---- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
----FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
----JOIN    
  
----( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
----ON A.ID =B.ID     
  
    
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
--JOIN    
  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
--ON A.ID =B.ID     
  
    
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1    
  
--END    
  
    
  
IF @PROCESS ='GET ALL APP OBJECTS'    
  
BEGIN    
  
    
  
    
  
    
  
--DECLARE @SQL AS VARCHAR(MAX)    
  
--DECLARE @STR AS VARCHAR(50)=''    
  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1    
  
    
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))    
  
    
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0    
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'    
  
    
  
--EXEC  (@SQL)    
  
  
  
declare @Emp_No varchar(50)  
  
  
  
 --select @Emp_No = emp_no      
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like @FILTER1 + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
  
  
 IF EXISTS (  
  
  SELECT  emp_no      
  
  FROM  [RISK].[dbo].[emp_info]       
  
  WHERE email like   @FILTER1 + '@angelbroking.com'   
  
  AND (SeparationDate is not null and SeparationDate >= GETDATE())  
  
  AND Status <> 'A'  
  
 )  
  
 BEGIN  
  
  SET @Emp_No  = ''  
  
 END  
  
 ELSE  
  
 BEGIN   
  
  SELECT @Emp_No = emp_no      
  
  FROM  [RISK].[dbo].[emp_info]       
  
  WHERE email like  @FILTER1 + '@angelbroking.com'   
  
 END  
  
   
  
 -- added by Shekhar  
  
 if ISNULL(@Emp_No,'') = ''  
  
 begin  
  
  SET @Emp_No  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @FILTER1 + '@angelbroking.com')   
  
 end  
  
    
  
-- if ISNULL(@EmployeeCode,'') = ''  
  
--begin  
  
-- SET @ENTRY_BY  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @ENTRY_BY + '@angelbroking.com')  
  
--end  
  
--else  
  
--begin  
  
-- SET @ENTRY_BY=@EmployeeCode  
  
--end  
  
   
  
  
  
 /*  
  
   
  
 IF Exists(  
  
  (SELECT emp_no  from  [RISK].[dbo].[emp_info]       
  
  where email like @FILTER1 + '@angelbroking.com'   
  
  and SeparationDate is NOT null  
  
  )  
  
  AND  
  
  (  
  
  SELECT emp_no  from  [RISK].[dbo].[emp_info]       
  
  where email like @FILTER1 + '@angelbroking.com'   
  
  and SeparationDate <= GETDATE())  
  
  )  
  
  )  
  
 BEGIN  
  
  
  
  
  
 END   
  
 ELSE  
  
 BEGIN  
  
  
  
  
  
 END  
  
  
  
   
  
 */  
  
  
  
 --  select emp_no     
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like 'Mohit.mishra' + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
    
  
 SELECT	ENTRYID 
 FROM	TBL_MF_IDENTITYDETAILS With(NoLock)
 WHERE	ENTRYBY = @Emp_No  and isnull(sbTag,'')  = ''
 union 
 SELECT	ENTRYID 
 FROM	TBL_MF_IDENTITYDETAILS With(NoLock)
 WHERE		ENTRYBY = @Emp_No  
		and isnull(sbTag,'')  <> ''
		and entry_date > (getdate() - 60)
  
    
  
 -- select * from TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No   
  
    
  
END    
  
    
  
IF @PROCESS ='GET FILES'    
  
BEGIN    
  
    
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0    
  
    
  
END    
  
    
  
IF @PROCESS ='ADD REQUEST'    
  
BEGIN    
  
    
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)    
  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))    
  
    
  
END    
  
    
  
IF @PROCESS ='CHECK PAN'    
  
BEGIN    
  
  
  
-- Added is 22 Oct 2018 by aslam  
  
DECLARE @Names  varchar(1000)  
  
  
  
SET @Names  =   (SELECT SBTAG + ','  
  
FROM [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo = @FILTER1    
  
FOR XML PATH(''))  
  
  
  
 DELETE TBL_MF_SBTAGOPTION WHERE PAN = @FILTER1    
  
  
  
IF (ISNULL(@Names,'') !='')  
  
BEGIN  
  
 INSERT TBL_MF_SBTAGOPTION  
  
 VALUES (@Names, @FILTER1)  
  
END   
  
  
  
--Commented on 30 Oct 2018 by aslam  
  
--- SELECT COUNT(1) AS CNT  FROM TBL_MF_IDENTITYDETAILS WHERE PAN = @FILTER1    
  
--- Addded on 30 Oct 2018 by aslam  
  
SELECT COUNT(A.PAN) AS CNT  FROM   
  
(  
  
 SELECT PAN AS PAN FROM TBL_MF_IDENTITYDETAILS  Where PAN  =  @FILTER1    
  
 UNION   
  
 SELECT PANNo AS PAN FROM [MIS].sb_comp.dbo.MfLead  Where PANNo  =  @FILTER1    
  
) A  
  
  
  
END    
  
  
  
if @PROCESS ='CHECK PAN SBTAG'  
  
Begin  
  
declare @Branch varchar(50)  
  
--For that perticular PAN and SBTAG exist in Idetity Details Branch Found then that branch come  
  
select @Branch=Branch from [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1 and SBTAG=@FILTER2  
  
  
  
if (@Branch!='')  
  
   select @Branch  
  
else  
  
   select 'MFSB'  
  
END  
  
  
  
  
  
  
  
IF @PROCESS ='CHECK SBTAG'    
  
BEGIN    
  
--SELECT sub_broker AS SBTAG  FROM [196.1.115.132].RISK.DBO.client_details WHERE pan_gir_no=@FILTER1 AND Last_inactive_date>=GETDATE()      
  
--select   SBTAG,panno from [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1   
  
  
  
--declare @SBTAG varchar(50)  
  
--select @SBTAG=SBTag from TBL_MF_IDENTITYDETAILS where PAN = @FILTER1  
  
  
  
-- This is for taking all SBTAG  
  
select SBTAG,panno from [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1   
  
  
  
END   
  
  
  
  
  
  
  
--IF @PROCESS ='GET EMP'    
  
--BEGIN    
  
    
  
--declare @partycode as varchar(500)=''    
  
--declare @CLIENTNAME as varchar(500)=''    
  
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C    
  
--JOIN     
  
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A    
  
--JOIN     
  
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B    
  
--ON A.ID=B.ID)D    
  
--ON C.PHONE=D.MOBILE    
  
    
  
--set @partycode= substring( @partycode,2,len(@partycode))    
  
    
  
--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME    
  
    
  
    
  
    
  
--END    
  
    
  
    
  
IF @PROCESS ='GET EMP'    
  
BEGIN    
  
    
  
declare @partycode as varchar(500)=''    
  
declare @CLIENTNAME as varchar(500)=''    
  
 SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [INTRANET].RISK.DBO.client_details with(nolock))C    
  
JOIN     
  
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID=@FILTER1 ) A    
  
JOIN     
  
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B    
  
ON A.ID=B.ID)D    
  
ON C.PHONE=D.MOBILE    
  
    
  
set @partycode= substring( @partycode,2,len(@partycode))    
  
    
  
select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME    
  
    
  
UPDATE TBL_SENDREQUEST    
  
set FLAG=1    
  
where USERID=@FILTER1    
  
    
  
    
  
    
  
END    
  
    
  
IF @PROCESS ='GETREJECTION'    
  
BEGIN    
  
    
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION     
  
    
  
END    
  
    
  
IF @PROCESS ='GETREJECTIONREASON'    
  
BEGIN    
  
    
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='DELETE CALL LOG'    
  
BEGIN    
  
    
  
UPDATE  TBL_SENDREQUEST    
  
SET flag=1    
  
 WHERE USERID=@FILTER1    
  
    
  
SELECT 1     
  
END    
  
    
  
    
  
IF @PROCESS ='GET QR CODE'    
  
BEGIN    
  
    
  
--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'    
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='CHECK AADHAR'    
  
BEGIN    
  
DECLARE @CNTER AS INT =0    
  
    
  
--SELECT @CNTER=COUNT(1) FROM TBL_MF_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1    
  
    
  
SELECT @CNTER AS CNT     
  
    
  
END    
  
    
  
IF @PROCESS ='GET FEFMEMBER DETAILS'    
  
BEGIN    
  
    
  
    
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'    
  
BEGIN    
  
    
  
    
  
 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers     
  
    
  
END    
  
    
  
IF @PROCESS ='FINALSUBMIT'    
  
BEGIN    
  
    
  
    
  
     UPDATE TBL_IDENTITYDETAILS    
  
     SET ISAPPROVED=4    
  
     WHERE  ENTRYID=@FILTER1    
  
    
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]    
  
    
  
END    
  
    
  
IF @PROCESS ='GET ESIGN DOCUMENTS'    
  
BEGIN    
  
    
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
--JOIN    
  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
--ON A.ID =B.ID     
  
    
  
SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONPDF/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
FROM TBL_MF_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
JOIN    
  
(SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE  FROM TBL_MF_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
ON A.ID =B.ID     
  
    
  
    
  
END    
  
    
  
IF @PROCESS ='VALIDATE USER'    
  
BEGIN    
  
    
  
            DECLARE @CNT  AS INT =0    
  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))    
  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))    
  
    
  
      
  
    
  
    
  
            SELECT @CNT= COUNT(1) FROM  [INTRANET].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD    
  
    
  
   IF(@CNT>0)    
  
   BEGIN    
  
   SELECT 'true' as result    
  
    
  
   END    
  
   ELSE    
  
   BEGIN    
  
   SELECT 'false' as result    
  
    
  
   END    
  
    
  
END    
  
    
  
    
  
    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SBGETDATA_30_Oct_2018
-- --------------------------------------------------

--Execute USP_MF_SBGETDATA  'GET ALL APP OBJECTS','Mohit.mishra'
-- Execute  USP_MF_SBGETDATA @PROCESS='GET APP',@FILTER1='3374',@FILTER2=''
-- =============================================  

-- Create date: <20 Feb 2018>  
-- Description: <Application Record>  
-- =============================================  

CREATE PROCEDURE [dbo].[USP_MF_SBGETDATA_30_Oct_2018] --'GET APP','6'  
@PROCESS VARCHAR(50)='',  
@FILTER1 VARCHAR(50)='',  
@FILTER2 VARCHAR(50)=''
AS  
BEGIN  
 IF @PROCESS ='GET APP LIST'  
BEGIN  

--comment on 22 Oct 2018  by aslam 
--SELECT *, 0 as ISMF,''AadhaarDetails FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
--UNION ALL  
--SELECT *, 1 as ISMF FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
  
  
SELECT *, 1 as ISMF,'' AadhaarDetails FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  

END  
  
IF @PROCESS ='GET EMP NAME'  
BEGIN  
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1  
  
END  
  
IF @PROCESS ='GET MASTER DATA'  
BEGIN  
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,  
--RTRIM (LTRIM (ZONE)) AS ZONE,  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,  
--RTRIM (LTRIM (REGION)) AS REGION,  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL   
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A  
--JOIN (SELECT   
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B  
--ON A.BR_CODE=B.BR_CODE   
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION    
FROM [196.1.115.182].GENERAL.DBO.BO_REGION  
  
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL  
  
SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2  
  
SELECT * FROM TBL_CONTRACTOR_SIGN  
  
END  
  
IF @PROCESS ='GET APP'  
BEGIN  
  
SELECT *  FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=CAST(@FILTER1 AS INT)    
SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=CAST(@FILTER1 AS INT)    
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1    
SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1    
SELECT * FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@FILTER1    
SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1    
SELECT * FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'    
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1    
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1    
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1    
--SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1    

-- Added is 22 Oct 2018 by aslam

SELECT A.*, B.SBTAG AS SBTAGLIST FROM TBL_MF_IDENTITYDETAILS A LEFT OUTER JOIN  TBL_MF_SBTAGOPTION B
ON A.PAN =  B.PAN
WHERE ENTRYID = @FILTER1    
  
  
--SELECT * FROM TBL_MF_ARNDetails WHERE ENTRYID=@FILTER1    
  
select   
EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,  
CASE Exam_tentative_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_FromDate, 120),1,10) End As 'Exam_tentative_FromDate',  
CASE Exam_tentative_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_ToDate, 120),1,10)  End As 'Exam_tentative_ToDate',  
CASE ARN_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, ARN_FromDate, 120),1,10)  End As 'ARN_FromDate',  
CASE ARN_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar,ARN_ToDate, 120),1,10)  End As 'ARN_ToDate'  
from tbl_MF_ARNDETAILS  
WHERE ENTRYID=@FILTER1  
  
--select EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,  
--Convert(varchar,Exam_tentative_FromDate,111) as Exam_tentative_FromDate,  
--Convert(varchar,Exam_tentative_ToDate,111) as Exam_tentative_ToDate,  
--Convert(varchar,ARN_FromDate,111) as ARN_FromDate,  
--Convert(varchar,ARN_ToDate,111) as ARN_ToDate  
--from tbl_MF_ARNDETAILS  
--WHERE ENTRYID=@FILTER1  
  
  
SELECT * FROM TBL_MF_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1    
  
SELECT EntryID,Amount,Instrument_No,SUBSTRING(convert(varchar,DATE, 120),1,10) as 'DATE',PaymentMode FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1    
  
  
select * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1   
--SELECT * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1    
  
END  
  
--IF @PROCESS ='GET APP ADMIN'  
--BEGIN  
  
--SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0  
--UNION   
--SELECT * from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0  
--UNION  
----SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE    
---- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
----FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
----JOIN  
----( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
----ON A.ID =B.ID   
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
--JOIN  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
--ON A.ID =B.ID   
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
--END  
  
IF @PROCESS ='GET ALL APP OBJECTS'  
BEGIN  
  
  
  
--DECLARE @SQL AS VARCHAR(MAX)  
--DECLARE @STR AS VARCHAR(50)=''  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))  
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'  
  
--EXEC  (@SQL)  

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null


 --  select emp_no   
 --from  [RISK].[dbo].[emp_info]     
 --where email like 'Mohit.mishra' + '@angelbroking.com' 
 --and SeparationDate is null
  
 SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No  
  
 -- select * from TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No 
  
END  
  
IF @PROCESS ='GET FILES'  
BEGIN  
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0  
  
END  
  
IF @PROCESS ='ADD REQUEST'  
BEGIN  
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))  
  
END  
  
IF @PROCESS ='CHECK PAN'  
BEGIN  

-- Added is 22 Oct 2018 by aslam
DECLARE @Names  varchar(1000)

SET @Names  =   (SELECT SBTAG + ','
FROM [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo = @FILTER1  
FOR XML PATH(''))

 DELETE TBL_MF_SBTAGOPTION WHERE PAN = @FILTER1  

IF (ISNULL(@Names,'') !='')
BEGIN
	INSERT TBL_MF_SBTAGOPTION
	VALUES (@Names, @FILTER1)
END 

SELECT COUNT(1) AS CNT  FROM TBL_MF_IDENTITYDETAILS WHERE PAN = @FILTER1  

END  

if @PROCESS ='CHECK PAN SBTAG'
Begin
declare @Branch varchar(50)
--For that perticular PAN and SBTAG exist in Idetity Details Branch Found then that branch come
select @Branch=Branch from [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1 and SBTAG=@FILTER2

if (@Branch!='')
   select @Branch
else
   select 'MFSB'
END



IF @PROCESS ='CHECK SBTAG'  
BEGIN  
--SELECT sub_broker AS SBTAG  FROM [196.1.115.132].RISK.DBO.client_details WHERE pan_gir_no=@FILTER1 AND Last_inactive_date>=GETDATE()    
--select   SBTAG,panno from [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1 

--declare @SBTAG varchar(50)
--select @SBTAG=SBTag from TBL_MF_IDENTITYDETAILS where PAN = @FILTER1

-- This is for taking all SBTAG
select SBTAG,panno from [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1 

END 



--IF @PROCESS ='GET EMP'  
--BEGIN  
  
--declare @partycode as varchar(500)=''  
--declare @CLIENTNAME as varchar(500)=''  
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C  
--JOIN   
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A  
--JOIN   
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B  
--ON A.ID=B.ID)D  
--ON C.PHONE=D.MOBILE  
  
--set @partycode= substring( @partycode,2,len(@partycode))  
  
--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME  
  
  
  
--END  
  
  
IF @PROCESS ='GET EMP'  
BEGIN  
  
declare @partycode as varchar(500)=''  
declare @CLIENTNAME as varchar(500)=''  
 SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C  
JOIN   
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID=@FILTER1 ) A  
JOIN   
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B  
ON A.ID=B.ID)D  
ON C.PHONE=D.MOBILE  
  
set @partycode= substring( @partycode,2,len(@partycode))  
  
select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME  
  
UPDATE TBL_SENDREQUEST  
set FLAG=1  
where USERID=@FILTER1  
  
  
  
END  
  
IF @PROCESS ='GETREJECTION'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION   
  
END  
  
IF @PROCESS ='GETREJECTIONREASON'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1  
  
END  
  
  
IF @PROCESS ='DELETE CALL LOG'  
BEGIN  
  
UPDATE  TBL_SENDREQUEST  
SET flag=1  
 WHERE USERID=@FILTER1  
  
SELECT 1   
END  
  
  
IF @PROCESS ='GET QR CODE'  
BEGIN  
  
--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1  
  
END  
  
  
IF @PROCESS ='CHECK AADHAR'  
BEGIN  
DECLARE @CNTER AS INT =0  
  
--SELECT @CNTER=COUNT(1) FROM TBL_MF_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1  
  
SELECT @CNTER AS CNT   
  
END  
  
IF @PROCESS ='GET FEFMEMBER DETAILS'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1  
  
END  
  
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers   
  
END  
  
IF @PROCESS ='FINALSUBMIT'  
BEGIN  
  
  
     UPDATE TBL_IDENTITYDETAILS  
     SET ISAPPROVED=4  
     WHERE  ENTRYID=@FILTER1  
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
END  
  
IF @PROCESS ='GET ESIGN DOCUMENTS'  
BEGIN  
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
--JOIN  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
--ON A.ID =B.ID   
  
SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONPDF/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
FROM TBL_MF_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
JOIN  
(SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE  FROM TBL_MF_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
ON A.ID =B.ID   
  
  
END  
  
IF @PROCESS ='VALIDATE USER'  
BEGIN  
  
            DECLARE @CNT  AS INT =0  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))  
  
    
  
  
            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD  
  
   IF(@CNT>0)  
   BEGIN  
   SELECT 'true' as result  
  
   END  
   ELSE  
   BEGIN  
   SELECT 'false' as result  
  
   END  
  
END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SBGETDATA_admin
-- --------------------------------------------------
  
  
---- USP_MF_SBGETDATA_admin  'GET APP ADMIN','3' 
CREATE PROC [dbo].[USP_MF_SBGETDATA_admin]  
@PROCESS VARCHAR(50)='',  
@FILTER1 VARCHAR(50)=''  
  
AS BEGIN  
  
IF @PROCESS ='GET APP LIST'  
BEGIN  
  
SELECT * FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
  
END  

IF @PROCESS ='PREESINGUPDATE'  
BEGIN  
  
UPDATE TBL_ESIGNDOCUMENTS
SET ISDELETE = 1
 WHERE SOURCE = 'SBADMIN' AND ENTRYID = @FILTER1
  
END  


IF @PROCESS ='GET EMP NAME'  
BEGIN  
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1  
  
END  
  
IF @PROCESS ='GET MASTER DATA'  
BEGIN  
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,  
--RTRIM (LTRIM (ZONE)) AS ZONE,  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,  
--RTRIM (LTRIM (REGION)) AS REGION,  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL   
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A  
--JOIN (SELECT   
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B  
--ON A.BR_CODE=B.BR_CODE   
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION    
FROM [CSOKYC-6].GENERAL.DBO.BO_REGION  
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL  
  
SELECT ISIN,SCRIPNAME FROM [CSOKYC-6].GENERAL.DBO.SCRIP_MASTER WHERE 1=2  
  
END  
  
IF @PROCESS ='GET APP'  
BEGIN  
   
  
SELECT * FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_ARNDetails where ENTRYID=@FILTER1 
select * from TBL_MF_NomineeDetails where ENTRYID=@FILTER1 
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1  
SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_INFRASTRUCTURE  WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
---UNION 
--SELECT * FROM [DBO].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
--UNION
--select * from TBL_MF_DOCUMENTSUPLOAD_PDF where ENTRYID =@FILTER1 and DOCTYPE='Affidavit' and ISDELETE =0
----
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://10.253.6.118:23/','HTTP://10.253.6.118:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_MF_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
END  


IF @PROCESS ='GET APP ADMIN'
BEGIN

		SELECT * FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
		SELECT I.ENTRYID,
				I.DOB,
				I.PAN,
				I.ISAPPROVED,
				I.ENTRY_DATE,
				I.ENTRYBY,
				I.MODIFY_DATE,
				I.MODIFY_BY,
				I.APPROVE_DATE,
				I.APPROVE_BY,
				I.Remark,
				I.IsInhouseIntegrated,
				I.RefNo,
				I.SBTag,
				I.AadharVaultKey,
				I.U_ID,
				CASE WHEN ISNULL(I.U_ID, '') = '' THEN 'NA' ELSE 'xxxxxxxx'+I.U_ID END 'aadhaarNo',
				PANName,
				CASE WHEN ISNULL(PANName, '') = '' THEN 'NA' ELSE PANName END 'panName',
				CASE WHEN ISNULL(AadharName, '') = '' THEN 'NA' ELSE AadharName END 'aadharName',
				CASE WHEN ISNULL(IM.BeneficiaryName, '') = '' THEN 'NA' ELSE IM.BeneficiaryName END 'impsName',
				CASE WHEN ISNULL(R.Pan, '') = '' THEN 'Offline' ELSE 'Online' END 'applicationType' FROM TBL_MF_IDENTITYDETAILS I 
				left join TBL_MFSB_Registration R ON R.EntryID = I.ENTRYID
				left join tbl_MFSB_ImpsDetail IM on IM.EntryId = I.ENTRYID
				WHERE I.ENTRYID=@FILTER1
		
				SELECT ID,ENTRYID,FILENAME,
				CASE WHEN CHARINDEX('\\10.253.6.118\APPLICATIONPDF\',replace(PATH,'http:','https:')) > 0 
				THEN 
		REPLACE(replace(PATH,'http:','https:'),'\\10.253.6.118\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/APPLICATIONPDF/')END AS PATH ,
		ISDELETE,DOCTYPE,EXCHANGE 
		FROM TBL_mf_DOCUMENTSUPLOAD 
		WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%D1%' AND ISDELETE =0  
		UNION   
		SELECT	ID,ENTRYID,FILENAME,replace(PATH,'http:','https:'),ISDELETE,DOCTYPE,EXCHANGE 
		FROM	[DBO].[TBL_mf_DOCUMENTSUPLOADFINAL_PDF] 
		WHERE	ENTRYID=@FILTER1 AND ISDELETE =0  
		UNION  
		SELECT A.ID,ENTRYID,B.FILENAME  
		,CASE WHEN CHARINDEX('\\10.253.6.118\APPLICATIONPDF\',replace(PATH,'http:','https:')) >0 THEN 
		REPLACE(replace(PATH,'http:','https:'),'\\10.253.6.118\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/APPLICATIONPDF/')END AS PATH  ,
		--REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/applicationesign/')END AS PATH  ,
		ISDELETE,REPLACE(REPLACE(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.PDF','')  AS DOCTYPE,A.EXCHANGE
		FROM 
		(SELECT FILENAME ,replace(PATH,'http:','https:') as PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE
		FROM TBL_mf_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%') 
		AND ENTRYID =@FILTER1 AND ISDELETE =0)A  

		JOIN  
		( 
		SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_MF_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
		ON A.ID =B.ID   
		
		--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID=@FILTER1 AND ISDELETE =0 		



		
		--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID=@FILTER1 AND ISDELETE =0 
		
		--AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
		-------UNION 

		-------SELECT * FROM [DBO].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
		--UNION

		--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@FILTER1 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )  AND ISDELETE =0

		--UNION
		--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://196.1.115.136:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
		--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
		--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

		--SELECT A.ID,ENTRYID,B.FILENAME
		--,CASE WHEN CHARINDEX('\\10.253.6.118\APPLICATIONPDF\',PATH) >0 THEN  REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') 
		--ELSE REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') END AS PATH  ,ISDELETE,REPLACE(REPLACE(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.PDF','')  AS DOCTYPE,A.EXCHANGE  
		--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
		--FROM TBL_MF_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' OR PATH LIKE 'FTP://196.1.115.136:23/%') AND ENTRYID =@FILTER1 AND ISDELETE =0)A

		--JOIN
		--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
		--ON A.ID =B.ID 
		SELECT * 
		from TBL_MF_NomineeDetails 
		where ENTRYID=@FILTER1 
		--SELECT * FROM TBL_MF_ARNDetails where ENTRYID=@FILTER1 
        SELECT ARN_Number,FirstName,MiddleName,LastName,
		isnull(SUBSTRING(convert(varchar, ARN_FromDate, 103),1,10),'') as ARN_FromDate,
		isnull(SUBSTRING(convert(varchar, ARN_ToDate, 103),1,10),'') as ARN_ToDate,
		B.UploadFiles ,		
		Isnull(SUBSTRING(convert(varchar, Exam_tentative_FromDate, 103),1,10),'') as Exam_tentative_FromDate,
		Isnull(SUBSTRING(convert(varchar, Exam_tentative_ToDate, 103),1,10),'') as Exam_tentative_ToDate,
		A.EUINumber 
		FROM TBL_MF_ARNDetails A
		left join 
		(select ENTRYID,ID,path + FILENAME as 'UploadFiles' 
		from  TBL_MF_DOCUMENTSUPLOAD where DOCTYPE='ARN'and EntryID = @FILTER1 and ISDELETE = 0)	B
		 on A.ENTRYID = B.ENTRYID
		where A.ENTRYID = @FILTER1 
		--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1
		--select * from TBL_MF_ARNDetails
		--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
		SELECT AL.ENTRYID,AL.OPERATION,AL.TIME,E.EMP_NO ,E.EMP_NAME
		FROM (SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO) E 
		INNER JOIN (SELECT ENTRYID,OPERATION,TIME,EMPLOYEE_CODE,IPADDRESS FROM  TBL_MF_Applicationlog)AL 
		ON E.EMP_NO =AL.EMPLOYEE_CODE AND ISNULL(AL.operation, '') <> ''
		WHERE ENTRYID = @FILTER1

		--Added by aslma on 23 Oct 2018
		SELECT 
			A.ENTRYID
			,(ISNULL(B.FIRSTNAME, '') +  ' ' +  ISNULL(B.MIDDLENAME, '') + ' ' +   ISNULL(B.LASTNAME,'')) AS FullName 
			, A.PANName
			, C.ESIGNNAME 
		FROM TBL_MF_IDENTITYDETAILS A 
			INNER JOIN TBL_MF_BASICDETAILS B 
				ON A.ENTRYID = B.ENTRYID 
			INNER JOIN TBL_MF_ESIGNDOCUMENTS C 
				ON B.ENTRYID = C.ENTRYID 
		WHERE A.ENTRYID = @FILTER1 AND ISDELETE =  0
END
  
IF @PROCESS ='GET ALL APP OBJECTS'  
BEGIN  
  
  
  
--DECLARE @SQL AS VARCHAR(MAX)  
--DECLARE @STR AS VARCHAR(50)=''  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))  
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'  
  
--EXEC  (@SQL)  
  
 SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
  
  
END  
  
IF @PROCESS ='GET FILES'  
BEGIN  
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,
PATH,
ISDELETE,DOCTYPE,EXCHANGE 
FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0  
  
END  
  
IF @PROCESS ='ADD REQUEST'  
BEGIN  
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))  
  
END  
  
  
IF @PROCESS ='CHECK PAN'  
BEGIN  
  
SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ISAPPROVED  IN(1,0,4) AND PAN=@FILTER1  
  
END  
  
  
IF @PROCESS ='GET EMP'  
BEGIN  
  
DECLARE @PARTYCODE AS VARCHAR(500)=''  
DECLARE @CLIENTNAME AS VARCHAR(500)=''  
 SELECT  @PARTYCODE=@PARTYCODE+','+  C.PARTY_CODE,@CLIENTNAME=C.CLIENTNAME FROM (SELECT PARTY_CODE,MOBILE_PAGER AS PHONE,SHORT_NAME AS CLIENTNAME FROM [INTRANET].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK))C  
JOIN   
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A  
JOIN   
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B  
ON A.ID=B.ID)D  
ON C.PHONE=D.MOBILE  
  
SET @PARTYCODE= SUBSTRING( @PARTYCODE,2,LEN(@PARTYCODE))  
  
SELECT @PARTYCODE AS PARTYCODE ,@CLIENTNAME AS CLIENTNAME  
  
--UPDATE TBL_SENDREQUEST  
--SET FLAG=1  
--WHERE ID IN (SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1)   
  
  
END  
  
IF @PROCESS ='GETREJECTION'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REJECTION AS VALUENAME  FROM TBL_REJECTION   
  
END  
  
IF @PROCESS ='GETREJECTIONREASON'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REASON AS VALUENAME FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1  
  
END  
  
  
IF @PROCESS ='DELETE CALL LOG'  
BEGIN  
  
UPDATE  TBL_SENDREQUEST  
SET FLAG=1  
 WHERE USERID=@FILTER1  
  
SELECT 1   
END  
  
  
IF @PROCESS ='GET QR CODE'  
BEGIN  
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@FILTER1  
  
END  
  
  
IF @PROCESS ='CHECK AADHAR'  
BEGIN  
DECLARE @CNTER AS INT =0  
  
--SELECT @CNTER=COUNT(1) FROM TBL_MF_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1  
  
SELECT @CNTER AS CNT   
  
END  
  
IF @PROCESS ='GET FEFMEMBER DETAILS'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1  
  
END  
  
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEE_GETALLTRAINERS   
  
END  
  
IF @PROCESS ='FINALSUBMIT'  
BEGIN  
  
  
                    UPDATE TBL_IDENTITYDETAILS  
     SET ISAPPROVED=4  
     WHERE  ENTRYID=@FILTER1  
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
END  
  
  
  
IF @PROCESS ='VALIDATE USER'  
BEGIN  
  
            DECLARE @CNT  AS INT =0  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))  
  
    
  
  
            SELECT @CNT= COUNT(1) FROM  [INTRANET].ROLEMGM.DBO.USER_LOGIN   WHERE USERNAME=@USERID AND USERPASSWORD=@PWD  
  
   IF(@CNT>0)  
   BEGIN  
   SELECT 'TRUE' AS RESULT  
  
   END  
   ELSE  
   BEGIN  
   SELECT 'FALSE' AS RESULT  
  
   END  
  
END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SBGETDATA_admin_bkup_2023_09_15
-- --------------------------------------------------
  
  
---- USP_MF_SBGETDATA_admin  'GET APP ADMIN','3' 
create PROC [dbo].[USP_MF_SBGETDATA_admin_bkup_2023_09_15]  
@PROCESS VARCHAR(50)='',  
@FILTER1 VARCHAR(50)=''  
  
AS BEGIN  
  
IF @PROCESS ='GET APP LIST'  
BEGIN  
  
SELECT * FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
  
END  

IF @PROCESS ='PREESINGUPDATE'  
BEGIN  
  
UPDATE TBL_ESIGNDOCUMENTS
SET ISDELETE = 1
 WHERE SOURCE = 'SBADMIN' AND ENTRYID = @FILTER1
  
END  


IF @PROCESS ='GET EMP NAME'  
BEGIN  
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1  
  
END  
  
IF @PROCESS ='GET MASTER DATA'  
BEGIN  
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,  
--RTRIM (LTRIM (ZONE)) AS ZONE,  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,  
--RTRIM (LTRIM (REGION)) AS REGION,  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL   
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A  
--JOIN (SELECT   
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B  
--ON A.BR_CODE=B.BR_CODE   
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION    
FROM [196.1.115.182].GENERAL.DBO.BO_REGION  
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL  
  
SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2  
  
END  
  
IF @PROCESS ='GET APP'  
BEGIN  
   
  
SELECT * FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_ARNDetails where ENTRYID=@FILTER1 
select * from TBL_MF_NomineeDetails where ENTRYID=@FILTER1 
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1  
SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_INFRASTRUCTURE  WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
---UNION 
--SELECT * FROM [DBO].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
--UNION
--select * from TBL_MF_DOCUMENTSUPLOAD_PDF where ENTRYID =@FILTER1 and DOCTYPE='Affidavit' and ISDELETE =0
----
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://172.31.16.251:23/','HTTP://172.31.16.251:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_MF_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
END  


IF @PROCESS ='GET APP ADMIN'
BEGIN

		SELECT * FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
		SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
		SELECT I.ENTRYID,
				I.DOB,
				I.PAN,
				I.ISAPPROVED,
				I.ENTRY_DATE,
				I.ENTRYBY,
				I.MODIFY_DATE,
				I.MODIFY_BY,
				I.APPROVE_DATE,
				I.APPROVE_BY,
				I.Remark,
				I.IsInhouseIntegrated,
				I.RefNo,
				I.SBTag,
				I.AadharVaultKey,
				I.U_ID,
				CASE WHEN ISNULL(I.U_ID, '') = '' THEN 'NA' ELSE 'xxxxxxxx'+I.U_ID END 'aadhaarNo',
				PANName,
				CASE WHEN ISNULL(PANName, '') = '' THEN 'NA' ELSE PANName END 'panName',
				CASE WHEN ISNULL(AadharName, '') = '' THEN 'NA' ELSE AadharName END 'aadharName',
				CASE WHEN ISNULL(IM.BeneficiaryName, '') = '' THEN 'NA' ELSE IM.BeneficiaryName END 'impsName',
				CASE WHEN ISNULL(R.Pan, '') = '' THEN 'Offline' ELSE 'Online' END 'applicationType' FROM TBL_MF_IDENTITYDETAILS I 
				left join TBL_MFSB_Registration R ON R.EntryID = I.ENTRYID
				left join tbl_MFSB_ImpsDetail IM on IM.EntryId = I.ENTRYID
				WHERE I.ENTRYID=@FILTER1
		
				SELECT ID,ENTRYID,FILENAME,CASE WHEN CHARINDEX('\\172.31.16.251\APPLICATIONPDF\',PATH) >0 THEN 
		REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/APPLICATIONPDF/')END AS PATH ,
		ISDELETE,DOCTYPE,EXCHANGE 
		FROM TBL_mf_DOCUMENTSUPLOAD 
		WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%D1%' AND ISDELETE =0  
		UNION   
		SELECT	ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE 
		FROM	[DBO].[TBL_mf_DOCUMENTSUPLOADFINAL_PDF] 
		WHERE	ENTRYID=@FILTER1 AND ISDELETE =0  
		UNION  
		SELECT A.ID,ENTRYID,B.FILENAME  
		,CASE WHEN CHARINDEX('\\172.31.16.251\APPLICATIONPDF\',PATH) >0 THEN 
		REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/APPLICATIONPDF/')END AS PATH  ,
		--REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','https://sbreg.angelbroking.com/sb_registration_files/applicationesign/')END AS PATH  ,
		ISDELETE,REPLACE(REPLACE(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.PDF','')  AS DOCTYPE,A.EXCHANGE
		FROM 
		(SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE
		FROM TBL_mf_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%') 
		AND ENTRYID =@FILTER1 AND ISDELETE =0)A  

		JOIN  
		( 
		SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_MF_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
		ON A.ID =B.ID   
		
		--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID=@FILTER1 AND ISDELETE =0 		



		
		--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID=@FILTER1 AND ISDELETE =0 
		
		--AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
		-------UNION 

		-------SELECT * FROM [DBO].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
		--UNION

		--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@FILTER1 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )  AND ISDELETE =0

		--UNION
		--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://196.1.115.136:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
		--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
		--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

		--SELECT A.ID,ENTRYID,B.FILENAME
		--,CASE WHEN CHARINDEX('\\172.31.16.251\APPLICATIONPDF\',PATH) >0 THEN  REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') 
		--ELSE REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') END AS PATH  ,ISDELETE,REPLACE(REPLACE(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.PDF','')  AS DOCTYPE,A.EXCHANGE  
		--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
		--FROM TBL_MF_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' OR PATH LIKE 'FTP://196.1.115.136:23/%') AND ENTRYID =@FILTER1 AND ISDELETE =0)A

		--JOIN
		--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
		--ON A.ID =B.ID 
		SELECT * 
		from TBL_MF_NomineeDetails 
		where ENTRYID=@FILTER1 
		--SELECT * FROM TBL_MF_ARNDetails where ENTRYID=@FILTER1 
        SELECT ARN_Number,FirstName,MiddleName,LastName,
		isnull(SUBSTRING(convert(varchar, ARN_FromDate, 103),1,10),'') as ARN_FromDate,
		isnull(SUBSTRING(convert(varchar, ARN_ToDate, 103),1,10),'') as ARN_ToDate,
		B.UploadFiles ,		
		Isnull(SUBSTRING(convert(varchar, Exam_tentative_FromDate, 103),1,10),'') as Exam_tentative_FromDate,
		Isnull(SUBSTRING(convert(varchar, Exam_tentative_ToDate, 103),1,10),'') as Exam_tentative_ToDate,
		A.EUINumber 
		FROM TBL_MF_ARNDetails A
		left join 
		(select ENTRYID,ID,path + FILENAME as 'UploadFiles' 
		from  TBL_MF_DOCUMENTSUPLOAD where DOCTYPE='ARN'and EntryID = @FILTER1 and ISDELETE = 0)	B
		 on A.ENTRYID = B.ENTRYID
		where A.ENTRYID = @FILTER1 
		--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1
		--select * from TBL_MF_ARNDetails
		--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
		--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
		SELECT AL.ENTRYID,AL.OPERATION,AL.TIME,E.EMP_NO ,E.EMP_NAME
		FROM (SELECT EMP_NO,EMP_NAME FROM [196.1.115.132].RISK.DBO.EMP_INFO) E 
		INNER JOIN (SELECT ENTRYID,OPERATION,TIME,EMPLOYEE_CODE,IPADDRESS FROM  TBL_MF_Applicationlog)AL 
		ON E.EMP_NO =AL.EMPLOYEE_CODE AND ISNULL(AL.operation, '') <> ''
		WHERE ENTRYID = @FILTER1

		--Added by aslma on 23 Oct 2018
		SELECT 
			A.ENTRYID
			,(ISNULL(B.FIRSTNAME, '') +  ' ' +  ISNULL(B.MIDDLENAME, '') + ' ' +   ISNULL(B.LASTNAME,'')) AS FullName 
			, A.PANName
			, C.ESIGNNAME 
		FROM TBL_MF_IDENTITYDETAILS A 
			INNER JOIN TBL_MF_BASICDETAILS B 
				ON A.ENTRYID = B.ENTRYID 
			INNER JOIN TBL_MF_ESIGNDOCUMENTS C 
				ON B.ENTRYID = C.ENTRYID 
		WHERE A.ENTRYID = @FILTER1 AND ISDELETE =  0
END
  
IF @PROCESS ='GET ALL APP OBJECTS'  
BEGIN  
  
  
  
--DECLARE @SQL AS VARCHAR(MAX)  
--DECLARE @STR AS VARCHAR(50)=''  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))  
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'  
  
--EXEC  (@SQL)  
  
 SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
  
  
END  
  
IF @PROCESS ='GET FILES'  
BEGIN  
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,
PATH,
ISDELETE,DOCTYPE,EXCHANGE 
FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0  
  
END  
  
IF @PROCESS ='ADD REQUEST'  
BEGIN  
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))  
  
END  
  
  
IF @PROCESS ='CHECK PAN'  
BEGIN  
  
SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ISAPPROVED  IN(1,0,4) AND PAN=@FILTER1  
  
END  
  
  
IF @PROCESS ='GET EMP'  
BEGIN  
  
DECLARE @PARTYCODE AS VARCHAR(500)=''  
DECLARE @CLIENTNAME AS VARCHAR(500)=''  
 SELECT  @PARTYCODE=@PARTYCODE+','+  C.PARTY_CODE,@CLIENTNAME=C.CLIENTNAME FROM (SELECT PARTY_CODE,MOBILE_PAGER AS PHONE,SHORT_NAME AS CLIENTNAME FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK))C  
JOIN   
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A  
JOIN   
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B  
ON A.ID=B.ID)D  
ON C.PHONE=D.MOBILE  
  
SET @PARTYCODE= SUBSTRING( @PARTYCODE,2,LEN(@PARTYCODE))  
  
SELECT @PARTYCODE AS PARTYCODE ,@CLIENTNAME AS CLIENTNAME  
  
--UPDATE TBL_SENDREQUEST  
--SET FLAG=1  
--WHERE ID IN (SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1)   
  
  
END  
  
IF @PROCESS ='GETREJECTION'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REJECTION AS VALUENAME  FROM TBL_REJECTION   
  
END  
  
IF @PROCESS ='GETREJECTIONREASON'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REASON AS VALUENAME FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1  
  
END  
  
  
IF @PROCESS ='DELETE CALL LOG'  
BEGIN  
  
UPDATE  TBL_SENDREQUEST  
SET FLAG=1  
 WHERE USERID=@FILTER1  
  
SELECT 1   
END  
  
  
IF @PROCESS ='GET QR CODE'  
BEGIN  
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@FILTER1  
  
END  
  
  
IF @PROCESS ='CHECK AADHAR'  
BEGIN  
DECLARE @CNTER AS INT =0  
  
--SELECT @CNTER=COUNT(1) FROM TBL_MF_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1  
  
SELECT @CNTER AS CNT   
  
END  
  
IF @PROCESS ='GET FEFMEMBER DETAILS'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1  
  
END  
  
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEE_GETALLTRAINERS   
  
END  
  
IF @PROCESS ='FINALSUBMIT'  
BEGIN  
  
  
                    UPDATE TBL_IDENTITYDETAILS  
     SET ISAPPROVED=4  
     WHERE  ENTRYID=@FILTER1  
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
END  
  
  
  
IF @PROCESS ='VALIDATE USER'  
BEGIN  
  
            DECLARE @CNT  AS INT =0  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))  
  
    
  
  
            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.DBO.USER_LOGIN   WHERE USERNAME=@USERID AND USERPASSWORD=@PWD  
  
   IF(@CNT>0)  
   BEGIN  
   SELECT 'TRUE' AS RESULT  
  
   END  
   ELSE  
   BEGIN  
   SELECT 'FALSE' AS RESULT  
  
   END  
  
END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_SBGETDATA_BkUp_2024_03_15
-- --------------------------------------------------
  
  
  -- USP_MF_SBGETDATA 'GET ALL APP OBJECTS','KUNWAR.SINGH'
  
  
CREATE PROCEDURE [dbo].[USP_MF_SBGETDATA_BkUp_2024_03_15] --'GET APP','9526'    
  
@PROCESS VARCHAR(50)='',    
  
@FILTER1 VARCHAR(50)='',    
  
@FILTER2 VARCHAR(50)=''  
  
AS    
  
BEGIN    
  
 IF @PROCESS ='GET APP LIST'    
  
BEGIN    
  
  
  
--comment on 22 Oct 2018  by aslam   
  
--SELECT *, 0 as ISMF,''AadhaarDetails FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
--UNION ALL    
  
--SELECT *, 1 as ISMF FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
    
  
    
  
SELECT *, 1 as ISMF,'' AadhaarDetails FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1    
  
  
  
END    
  
    
  
IF @PROCESS ='GET EMP NAME'    
  
BEGIN    
  
    
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1    
  
    
  
END    
  
    
  
IF @PROCESS ='GET MASTER DATA'    
  
BEGIN    
  
    
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,    
  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,    
  
--RTRIM (LTRIM (ZONE)) AS ZONE,    
  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,    
  
--RTRIM (LTRIM (REGION)) AS REGION,    
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,    
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL     
  
    
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A    
  
--JOIN (SELECT     
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,    
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B    
  
--ON A.BR_CODE=B.BR_CODE     
  
    
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION      
  
FROM [CSOKYC-6].GENERAL.DBO.BO_REGION    
  
    
  
    
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL    
  
    
  
SELECT ISIN,SCRIPNAME FROM [CSOKYC-6].GENERAL.DBO.SCRIP_MASTER WHERE 1=2    
  
    
  
SELECT * FROM TBL_CONTRACTOR_SIGN    
  
    
  
END    
  
    
  
IF @PROCESS ='GET APP'    
  
BEGIN    
  
    
  
SELECT *  FROM TBL_MF_BASICDETAILS  WHERE ENTRYID=CAST(@FILTER1 AS INT)      
  
SELECT * FROM TBL_MF_BANKDETAILS WHERE ENTRYID=CAST(@FILTER1 AS INT)      
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_ADDRESS WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_INFRASTRUCTURE WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1      
  
SELECT * FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'      
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1      
  
--SELECT * FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@FILTER1      
  
  
  
-- Added is 22 Oct 2018 by aslam  
  
  
  
SELECT A.*, B.SBTAG AS SBTAGLIST FROM TBL_MF_IDENTITYDETAILS A LEFT OUTER JOIN  TBL_MF_SBTAGOPTION B  
  
ON A.PAN =  B.PAN  
  
WHERE ENTRYID = @FILTER1      
  
    
  
    
  
--SELECT * FROM TBL_MF_ARNDetails WHERE ENTRYID=@FILTER1      
  
    
  
select     
  
EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,    
  
CASE Exam_tentative_FromDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_FromDate, 120),1,10) End As 'Exam_tentative_FromDate',    
  
CASE Exam_tentative_ToDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_ToDate, 120),1,10)  End As 'Exam_tentative_ToDate',    
  
CASE ARN_FromDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar, ARN_FromDate, 120),1,10)  End As 'ARN_FromDate',    
  
CASE ARN_ToDate    
  
        WHEN '1900-01-01' THEN null    
  
        ELSE SUBSTRING(convert(varchar,ARN_ToDate, 120),1,10)  End As 'ARN_ToDate',  
  
EUINumber  
  
from tbl_MF_ARNDETAILS    
  
WHERE ENTRYID=@FILTER1    
  
    
  
--select EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,    
  
--Convert(varchar,Exam_tentative_FromDate,111) as Exam_tentative_FromDate,    
  
--Convert(varchar,Exam_tentative_ToDate,111) as Exam_tentative_ToDate,    
  
--Convert(varchar,ARN_FromDate,111) as ARN_FromDate,    
  
--Convert(varchar,ARN_ToDate,111) as ARN_ToDate    
  
--from tbl_MF_ARNDETAILS    
  
--WHERE ENTRYID=@FILTER1    
  
    
  
    
  
SELECT * FROM TBL_MF_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1      
  
    
  
--SELECT * FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1      
  
    
  
SELECT EntryID,Amount,Instrument_No,SUBSTRING(convert(varchar,DATE, 120),1,10) as 'DATE',PaymentMode FROM TBL_MF_PaymentDetails WHERE ENTRYID=@FILTER1      
  
    
  
    
  
select * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1     
  
--SELECT * FROM TBL_MF_NomineeDetails WHERE ENTRYID=@FILTER1      
  
    
  
END    
  
    
  
--IF @PROCESS ='GET APP ADMIN'    
  
--BEGIN    
  
    
  
--SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1    
  
    
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0    
  
--UNION     
  
--SELECT * from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0    
  
--UNION    
  
----SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE      
  
---- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
----FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
----JOIN    
  
----( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
----ON A.ID =B.ID     
  
    
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
--JOIN    
  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
--ON A.ID =B.ID     
  
    
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1    
  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1    
  
--END    
  
    
  
IF @PROCESS ='GET ALL APP OBJECTS'    
  
BEGIN    
  
    
  
    
  
    
  
--DECLARE @SQL AS VARCHAR(MAX)    
  
--DECLARE @STR AS VARCHAR(50)=''    
  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1    
  
    
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))    
  
    
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0    
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')    
  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'    
  
    
  
--EXEC  (@SQL)    
  
  
  
declare @Emp_No varchar(50)  
  
  
  
 --select @Emp_No = emp_no      
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like @FILTER1 + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
  
  
 IF EXISTS (  
  
  SELECT  emp_no      
  
  FROM  [RISK].[dbo].[emp_info]       
  
  WHERE email like   @FILTER1 + '@angelbroking.com'   
  
  AND (SeparationDate is not null and SeparationDate >= GETDATE())  
  
  AND Status <> 'A'  
  
 )  
  
 BEGIN  
  
  SET @Emp_No  = ''  
  
 END  
  
 ELSE  
  
 BEGIN   
  
  SELECT @Emp_No = emp_no      
  
  FROM  [RISK].[dbo].[emp_info]       
  
  WHERE email like  @FILTER1 + '@angelbroking.com'   
  
 END  
  
   
  
 -- added by Shekhar  
  
 if ISNULL(@Emp_No,'') = ''  
  
 begin  
  
  SET @Emp_No  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @FILTER1 + '@angelbroking.com')   
  
 end  
  
    
  
-- if ISNULL(@EmployeeCode,'') = ''  
  
--begin  
  
-- SET @ENTRY_BY  = (select distinct Emp_no from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @ENTRY_BY + '@angelbroking.com')  
  
--end  
  
--else  
  
--begin  
  
-- SET @ENTRY_BY=@EmployeeCode  
  
--end  
  
   
  
  
  
 /*  
  
   
  
 IF Exists(  
  
  (SELECT emp_no  from  [RISK].[dbo].[emp_info]       
  
  where email like @FILTER1 + '@angelbroking.com'   
  
  and SeparationDate is NOT null  
  
  )  
  
  AND  
  
  (  
  
  SELECT emp_no  from  [RISK].[dbo].[emp_info]       
  
  where email like @FILTER1 + '@angelbroking.com'   
  
  and SeparationDate <= GETDATE())  
  
  )  
  
  )  
  
 BEGIN  
  
  
  
  
  
 END   
  
 ELSE  
  
 BEGIN  
  
  
  
  
  
 END  
  
  
  
   
  
 */  
  
  
  
 --  select emp_no     
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like 'Mohit.mishra' + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
    
  
 SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No    
  
    
  
 -- select * from TBL_MF_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No   
  
    
  
END    
  
    
  
IF @PROCESS ='GET FILES'    
  
BEGIN    
  
    
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0    
  
    
  
END    
  
    
  
IF @PROCESS ='ADD REQUEST'    
  
BEGIN    
  
    
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)    
  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))    
  
    
  
END    
  
    
  
IF @PROCESS ='CHECK PAN'    
  
BEGIN    
  
  
  
-- Added is 22 Oct 2018 by aslam  
  
DECLARE @Names  varchar(1000)  
  
  
  
SET @Names  =   (SELECT SBTAG + ','  
  
FROM [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo = @FILTER1    
  
FOR XML PATH(''))  
  
  
  
 DELETE TBL_MF_SBTAGOPTION WHERE PAN = @FILTER1    
  
  
  
IF (ISNULL(@Names,'') !='')  
  
BEGIN  
  
 INSERT TBL_MF_SBTAGOPTION  
  
 VALUES (@Names, @FILTER1)  
  
END   
  
  
  
--Commented on 30 Oct 2018 by aslam  
  
--- SELECT COUNT(1) AS CNT  FROM TBL_MF_IDENTITYDETAILS WHERE PAN = @FILTER1    
  
--- Addded on 30 Oct 2018 by aslam  
  
SELECT COUNT(A.PAN) AS CNT  FROM   
  
(  
  
 SELECT PAN AS PAN FROM TBL_MF_IDENTITYDETAILS  Where PAN  =  @FILTER1    
  
 UNION   
  
 SELECT PANNo AS PAN FROM [MIS].sb_comp.dbo.MfLead  Where PANNo  =  @FILTER1    
  
) A  
  
  
  
END    
  
  
  
if @PROCESS ='CHECK PAN SBTAG'  
  
Begin  
  
declare @Branch varchar(50)  
  
--For that perticular PAN and SBTAG exist in Idetity Details Branch Found then that branch come  
  
select @Branch=Branch from [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1 and SBTAG=@FILTER2  
  
  
  
if (@Branch!='')  
  
   select @Branch  
  
else  
  
   select 'MFSB'  
  
END  
  
  
  
  
  
  
  
IF @PROCESS ='CHECK SBTAG'    
  
BEGIN    
  
--SELECT sub_broker AS SBTAG  FROM [196.1.115.132].RISK.DBO.client_details WHERE pan_gir_no=@FILTER1 AND Last_inactive_date>=GETDATE()      
  
--select   SBTAG,panno from [196.1.115.167].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1   
  
  
  
--declare @SBTAG varchar(50)  
  
--select @SBTAG=SBTag from TBL_MF_IDENTITYDETAILS where PAN = @FILTER1  
  
  
  
-- This is for taking all SBTAG  
  
select SBTAG,panno from [MIS].SB_COMP.dbo.VW_SubBroker_Details where PanNo=@FILTER1   
  
  
  
END   
  
  
  
  
  
  
  
--IF @PROCESS ='GET EMP'    
  
--BEGIN    
  
    
  
--declare @partycode as varchar(500)=''    
  
--declare @CLIENTNAME as varchar(500)=''    
  
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C    
  
--JOIN     
  
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A    
  
--JOIN     
  
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B    
  
--ON A.ID=B.ID)D    
  
--ON C.PHONE=D.MOBILE    
  
    
  
--set @partycode= substring( @partycode,2,len(@partycode))    
  
    
  
--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME    
  
    
  
    
  
    
  
--END    
  
    
  
    
  
IF @PROCESS ='GET EMP'    
  
BEGIN    
  
    
  
declare @partycode as varchar(500)=''    
  
declare @CLIENTNAME as varchar(500)=''    
  
 SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [INTRANET].RISK.DBO.client_details with(nolock))C    
  
JOIN     
  
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID=@FILTER1 ) A    
  
JOIN     
  
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B    
  
ON A.ID=B.ID)D    
  
ON C.PHONE=D.MOBILE    
  
    
  
set @partycode= substring( @partycode,2,len(@partycode))    
  
    
  
select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME    
  
    
  
UPDATE TBL_SENDREQUEST    
  
set FLAG=1    
  
where USERID=@FILTER1    
  
    
  
    
  
    
  
END    
  
    
  
IF @PROCESS ='GETREJECTION'    
  
BEGIN    
  
    
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION     
  
    
  
END    
  
    
  
IF @PROCESS ='GETREJECTIONREASON'    
  
BEGIN    
  
    
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='DELETE CALL LOG'    
  
BEGIN    
  
    
  
UPDATE  TBL_SENDREQUEST    
  
SET flag=1    
  
 WHERE USERID=@FILTER1    
  
    
  
SELECT 1     
  
END    
  
    
  
    
  
IF @PROCESS ='GET QR CODE'    
  
BEGIN    
  
    
  
--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'    
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='CHECK AADHAR'    
  
BEGIN    
  
DECLARE @CNTER AS INT =0    
  
    
  
--SELECT @CNTER=COUNT(1) FROM TBL_MF_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1    
  
    
  
SELECT @CNTER AS CNT     
  
    
  
END    
  
    
  
IF @PROCESS ='GET FEFMEMBER DETAILS'    
  
BEGIN    
  
    
  
    
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1    
  
    
  
END    
  
    
  
    
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'    
  
BEGIN    
  
    
  
    
  
 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers     
  
    
  
END    
  
    
  
IF @PROCESS ='FINALSUBMIT'    
  
BEGIN    
  
    
  
    
  
     UPDATE TBL_IDENTITYDETAILS    
  
     SET ISAPPROVED=4    
  
     WHERE  ENTRYID=@FILTER1    
  
    
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]    
  
    
  
END    
  
    
  
IF @PROCESS ='GET ESIGN DOCUMENTS'    
  
BEGIN    
  
    
  
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
--JOIN    
  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
--ON A.ID =B.ID     
  
    
  
SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONPDF/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE      
  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE     
  
FROM TBL_MF_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A    
  
    
  
JOIN    
  
(SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE  FROM TBL_MF_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B    
  
ON A.ID =B.ID     
  
    
  
    
  
END    
  
    
  
IF @PROCESS ='VALIDATE USER'    
  
BEGIN    
  
    
  
            DECLARE @CNT  AS INT =0    
  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))    
  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))    
  
    
  
      
  
    
  
    
  
            SELECT @CNT= COUNT(1) FROM  [INTRANET].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD    
  
    
  
   IF(@CNT>0)    
  
   BEGIN    
  
   SELECT 'true' as result    
  
    
  
   END    
  
   ELSE    
  
   BEGIN    
  
   SELECT 'false' as result    
  
    
  
   END    
  
    
  
END    
  
    
  
    
  
    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATE_NEWSB
-- --------------------------------------------------

-- =============================================
-- Author:		Ashok/Suraj
-- Create date: 05May2018
-- Description:	uPDATE new MF sb details in in-house
-- =============================================
CREATE PROCEDURE [dbo].[USP_MF_UPDATE_NEWSB]
		@ENTRYID AS INT,  
		@CSOID AS VARCHAR(50)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @REFNO NUMERIC(18,0)   
		SELECT @REFNO= REFNO FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID  
		--SB_BROKER  

		print @REFNO  

				UPDATE A  
				SET A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,  
				A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,  
				A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,  
				A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,  
				A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,  
				A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,  
				A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE(), A.SBstatus=B.SBstatus,A.SEBIRegNo=B.SEBIRegNo 
				FROM MIS.SB_COMP.DBO.SB_BROKER A  
				JOIN  
				(
					SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE, 
					B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,  
					B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,  
					B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,  
					/*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,  
					B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,
					@CSOID AS IPADDRESS,B.ENTRYBY  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,
					CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIRegNo
					--INTO TBL_TEST  
					FROM TBL_MF_BASICDETAILS A  
					JOIN TBL_MF_IDENTITYDETAILS B  
					ON A.ENTRYID = B.ENTRYID  
					--JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C  
					--ON B.ENTRYBY = C.EMP_NO  
					LEFT JOIN TBL_MF_ARNDetails D  
					ON A.ENTRYID = D.ENTRYID  
					WHERE A.ENTRYID = @ENTRYID  
				)B
				ON A.REFNO = B.REFNO  
				AND A.SBTAG = B.SBTAG  
      
	    
		--SB_CONTACT  
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)  

				--INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)  
				UPDATE A  
				SET A.ADDTYPE=B.ADDTYPE,A.ADDLINE1=B.ADDLINE1,A.ADDLINE2=B.ADDLINE2,A.LANDMARK=B.LANDMARK,A.CITY=B.CITY,A.STATE=B.STATE,A.COUNTRY=B.COUNTRY,  
				A.PINCODE=B.PINCODE,A.STDCODE=B.STDCODE,A.TELNO=B.TELNO,A.MOBNO=B.MOBNO,A.EMAILID=B.EMAILID       
				FROM MIS.SB_COMP.DBO.SB_CONTACT A  
				JOIN  
				(
						SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
						FROM TBL_MF_ADDRESS A  
						JOIN TBL_MF_IDENTITYDETAILS B  
						ON A.ENTRYID = B.ENTRYID  
						WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID  

						UNION ALL  
						--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )  
						SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
						FROM TBL_MF_ADDRESS A  
						JOIN TBL_MF_IDENTITYDETAILS B  
						ON A.ENTRYID = B.ENTRYID  
						WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID
				)B  
				ON A.REFNO = B.REFNO  
				AND A.ADDTYPE = B.ADDTYPE    

		--SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018  

		--SB_DDCHEQUE  
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT   

		--MIS.SB_COMP.DBO.SB_BANKOTHERS  
		-- FOR EQUITY  ISCOMMODITY = 0  
				--INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				UPDATE A  
				SET A.NAMEINBANK = B.NAMEINBANK,A.ACCTYPE=B.ACCTYPE,A.ACCNO=B.ACCNO,A.BANKNAME=B.BANKNAME,A.BRANCHADD1=B.BRANCHADD1,  
				A.BRANCHADD2=B.BRANCHADD2,A.BRANCHADD3=B.BRANCHADD3,A.BRANCHPIN=B.BRANCHPIN,A.MICRCODE=B.MICRCODE,A.IFSRCODE=B.IFSRCODE,  
				A.INCOMERANGE=B.INCOMERANGE,A.BUSINESSLOC=B.BUSINESSLOC,A.NOMINEEREL=B.NOMINEEREL,A.NOMINEENAME=B.NOMINEENAME,  
				A.TERMINALLOCATION=B.TERMINALLOCATION,A.SOCIALNET=B.SOCIALNET,A.LANGUAGE=B.LANGUAGE,A.TRADINGACC=B.TRADINGACC,  
				A.ACCCLIENTCODE=B.ACCCLIENTCODE,A.DEMATACCNO=B.DEMATACCNO,A.REGOTHER=B.REGOTHER,A.REGEXGNAME=B.REGEXGNAME,  
				A.REGSEG=B.REGSEG,A.SEBIACTION=B.SEBIACTION,A.SEBIACTDET=B.SEBIACTDET,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,A.MDYDT=GETDATE(),  
				A.NOOFBRANCHOFFICES=B.NOOFBRANCHOFFICES,A.TOTAREASQFEET=B.TOTAREASQFEET,A.TOTNOOFDEALERS=B.TOTNOOFDEALERS,A.TOTNOOFTERMINALS=B.TOTNOOFTERMINALS,A.IPADDRESS=B.IPADDRESS  
				FROM MIS.SB_COMP.DBO.SB_BANKOTHERS A  
				JOIN  
				(
				
				
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,  
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,  
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,  
						NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,  
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,  
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,  

						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,  
						'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS   

						FROM TBL_MF_BANKDETAILS A   
						--JOIN TBL_MF_INFRASTRUCTURE B  
						LEFT JOIN TBL_MF_INFRASTRUCTURE B  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020
						ON A.ENTRYID = B.ENTRYID  
						JOIN TBL_MF_IDENTITYDETAILS C  
						ON A.ENTRYID = C.ENTRYID  
						WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID  
				)B   
				ON A.REFNO = B.REFNO  
				AND A.COMPANY = B.COMPANY  
    
		--BPREGMASTER  
		
		--drop table #SEGMENTS
				IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL
				/*Then it exists*/
				DROP TABLE #SEGMENTS
			
				SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM 
				(SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A

				update #SEGMENTS   
				set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END 
				from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID  


				

		--DROP TABLE #SEGMENTS  

				--INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)  
				UPDATE A  SET A.REGAPRREFNO =B.REGAPRREFNO,A.REGTAG=B.REGTAG,A.REGEXCHANGESEGMENT=B.REGEXCHANGESEGMENT,A.NAMESALUTATION=B.NAMESALUTATION,  
				A.REGNAME=B.REGNAME,A.TRADENAMESALUTATION=B.TRADENAMESALUTATION,A.REGTRADENAME=B.REGTRADENAME,A.REGFATHERHUSBANDNAME=B.REGFATHERHUSBANDNAME,  
				A.TYPE=B.TYPE,A.REGDOB=B.REGDOB,A.REGSEX=B.REGSEX,A.REGRESADD1=B.REGRESADD1,A.REGRESADD2=B.REGRESADD2,  
				A.REGRESADD3=B.REGRESADD3,A.REGRESCITY=B.REGRESCITY,A.REGRESPIN=B.REGRESPIN,A.REGOFFADD1=B.REGOFFADD1,A.REGOFFADD2=B.REGOFFADD2,  
				A.REGOFFADD3=B.REGOFFADD3,A.REGOFFCITY=B.REGOFFCITY,A.REGOFFPIN=B.REGOFFPIN,A.REGOFFPHONE=B.REGOFFPHONE,A.REGMOBILE=B.REGMOBILE,  
				A.REGMOBILE2=B.REGMOBILE2,A.REGRESPHONE=B.REGRESPHONE,A.REGRESFAX=B.REGRESFAX,A.REGPAN=B.REGPAN,A.REGPAN_APPLIED=B.REGPAN_APPLIED,  
				A.REGCORRESPONDANCEADD=B.REGCORRESPONDANCEADD,A.REGMAPIN=B.REGMAPIN,A.REGPROPRIETORSHIPYN=B.REGPROPRIETORSHIPYN,A.REGEXPINYRS=B.REGEXPINYRS,  
				A.REGRESIDENTIALSTATUS=B.REGRESIDENTIALSTATUS,A.REGEMAILID=B.REGEMAILID,A.REGREFERENCETAG=B.REGREFERENCETAG,A.REGMKRID=B.REGMKRID,  
				A.REGMKRDT=B.REGMKRDT,A.TAGBRANCH=B.TAGBRANCH,A.GLUNREGISTEREDCODE=B.GLUNREGISTEREDCODE,A.GLREGISTEREDCODE=B.GLREGISTEREDCODE,  
				A.REGSTATUS=B.REGSTATUS,A.REGDATE=B.REGDATE,A.REGNO=B.REGNO,A.UPLOAD=B.UPLOAD,A.ALIAS=B.ALIAS,A.ALIASNAME=B.ALIASNAME,A.REGPORTALNO=B.REGPORTALNO  
				FROM MIS.SB_COMP.DBO.BPREGMASTER A  
				JOIN  
				(
						SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,  
						A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,  
						/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,  
						A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,  
						CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,  
						D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,   
						E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,  
						E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,  
						D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,  
						E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,  
						A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,  
						NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,  
						NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo 

						FROM TBL_MF_BASICDETAILS A  
						JOIN #SEGMENTS B  
						ON A.ENTRYID = B.ENTRYID  
						JOIN TBL_MF_IDENTITYDETAILS C  
						ON A.ENTRYID = C.ENTRYID  
						JOIN TBL_MF_ADDRESS D  
						ON A.ENTRYID = D.ENTRYID  
						JOIN TBL_MF_ADDRESS E  
						ON A.ENTRYID = E.ENTRYID  
						LEFT JOIN TBL_MF_ARNDetails F  
						ON A.ENTRYID = F.ENTRYID  
						WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID  
				)B  
				ON A.RegAprRefNo = B.REGAPRREFNO  
				AND A.RegTAG = B.REGTAG  
				AND A.RegExchangeSegment = B.RegExchangeSegment  





		--MIS.SB_COMP.DBO.BPAPPLICATION   
				--INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)  
				UPDATE A   
				SET A.TERMINALLOCATION=B.TERMINALLOCATION,A.CRUSER=B.CRUSER,A.MODUSER=B.CRUSER,A.MODDATE= GETDATE(),A.APPAUTHORISED_PERSON=B.APPAUTHORISED_PERSON,  
				A.MODE = B.MODE  
				FROM MIS.SB_COMP.DBO.BPAPPLICATION A  
				JOIN  
				(
							SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,  
							CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,  
							C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,  
							NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,  
							NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO  

							FROM TBL_MF_BASICDETAILS A  
							JOIN #SEGMENTS B  
							ON A.ENTRYID = B.ENTRYID  
							JOIN TBL_MF_IDENTITYDETAILS C  
							ON A.ENTRYID = C.ENTRYID  
							LEFT JOIN TBL_MF_ARNDetails D  
							ON A.ENTRYID = D.ENTRYID  
							WHERE A.ENTRYID =@ENTRYID  
				)B  
				ON A.AppRefNo=B.AppRefNo AND A.EST=B.EST  



		--MIS.SB_COMP.DBO.SB_PERSONAL  

				--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)  
				UPDATE A   
				SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,  
				A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,  
				A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,  
				A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,  
				A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS  
				FROM MIS.SB_COMP.DBO.SB_PERSONAL A  
				JOIN  
				(
							SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,  
							/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,  
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,  
							CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,  
							C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,  
							B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS  
							FROM TBL_MF_BASICDETAILS A  
							JOIN TBL_MF_IDENTITYDETAILS B  
							ON A.ENTRYID = B.ENTRYID  
							--JOIN TBL_MF_REGISTRATIONRELATED C
							LEFT JOIN TBL_MF_REGISTRATIONRELATED C  -- Change by Shekhar G as per new MFSB journey at 10thOct 2020      
							ON A.ENTRYID = C.ENTRYID  
							WHERE A.ENTRYID = @ENTRYID  
				)B  
				ON A.REFNO= B.REFNO  
		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS  ONLY FOR NEW SB
		----MIS.SB_COMP.DBO.TAG_BO_DETAILS  
		--		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)  
		--		SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE  
		--		FROM TBL_MF_BASICDETAILS A  
		--		JOIN TBL_MF_IDENTITYDETAILS B  
		--		ON A.ENTRYID = B.ENTRYID  
		--		WHERE A.ENTRYID = @ENTRYID  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATE_NEWSB_19June2018
-- --------------------------------------------------

-- =============================================
-- Author:		Ashok/Suraj
-- Create date: 05May2018
-- Description:	uPDATE new MF sb details in in-house
-- =============================================
create PROCEDURE [dbo].[USP_MF_UPDATE_NEWSB_19June2018]
		@ENTRYID AS INT,  
		@CSOID AS VARCHAR(50)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @REFNO NUMERIC(18,0)   
		SELECT @REFNO= REFNO FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID = @ENTRYID  
		--SB_BROKER  

		print @REFNO  

				UPDATE A  
				SET A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,  
				A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,  
				A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,  
				A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,  
				A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,  
				A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,  
				A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE(), A.SBstatus=B.SBstatus,A.SEBIRegNo=B.SEBIRegNo 
				FROM MIS.SB_COMP.DBO.SB_BROKER A  
				JOIN  
				(
					SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE, 
					B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,  
					B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,  
					B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,  
					/*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,  
					B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,
					@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,
					CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIRegNo
					--INTO TBL_TEST  
					FROM TBL_MF_BASICDETAILS A  
					JOIN TBL_MF_IDENTITYDETAILS B  
					ON A.ENTRYID = B.ENTRYID  
					JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C  
					ON B.ENTRYBY = C.EMP_NO  
					JOIN TBL_MF_ARNDetails D  
					ON A.ENTRYID = D.ENTRYID  
					WHERE A.ENTRYID = @ENTRYID  
				)B
				ON A.REFNO = B.REFNO  
				AND A.SBTAG = B.SBTAG  
      
	    
		--SB_CONTACT  
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)  

				--INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)  
				UPDATE A  
				SET A.ADDTYPE=B.ADDTYPE,A.ADDLINE1=B.ADDLINE1,A.ADDLINE2=B.ADDLINE2,A.LANDMARK=B.LANDMARK,A.CITY=B.CITY,A.STATE=B.STATE,A.COUNTRY=B.COUNTRY,  
				A.PINCODE=B.PINCODE,A.STDCODE=B.STDCODE,A.TELNO=B.TELNO,A.MOBNO=B.MOBNO,A.EMAILID=B.EMAILID       
				FROM MIS.SB_COMP.DBO.SB_CONTACT A  
				JOIN  
				(
						SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
						FROM TBL_MF_ADDRESS A  
						JOIN TBL_MF_IDENTITYDETAILS B  
						ON A.ENTRYID = B.ENTRYID  
						WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID  

						UNION ALL  
						--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )  
						SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
						'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
						FROM TBL_MF_ADDRESS A  
						JOIN TBL_MF_IDENTITYDETAILS B  
						ON A.ENTRYID = B.ENTRYID  
						WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID
				)B  
				ON A.REFNO = B.REFNO  
				AND A.ADDTYPE = B.ADDTYPE    

		--SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018  

		--SB_DDCHEQUE  
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT   

		--MIS.SB_COMP.DBO.SB_BANKOTHERS  
		-- FOR EQUITY  ISCOMMODITY = 0  
				--INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				UPDATE A  
				SET A.NAMEINBANK = B.NAMEINBANK,A.ACCTYPE=B.ACCTYPE,A.ACCNO=B.ACCNO,A.BANKNAME=B.BANKNAME,A.BRANCHADD1=B.BRANCHADD1,  
				A.BRANCHADD2=B.BRANCHADD2,A.BRANCHADD3=B.BRANCHADD3,A.BRANCHPIN=B.BRANCHPIN,A.MICRCODE=B.MICRCODE,A.IFSRCODE=B.IFSRCODE,  
				A.INCOMERANGE=B.INCOMERANGE,A.BUSINESSLOC=B.BUSINESSLOC,A.NOMINEEREL=B.NOMINEEREL,A.NOMINEENAME=B.NOMINEENAME,  
				A.TERMINALLOCATION=B.TERMINALLOCATION,A.SOCIALNET=B.SOCIALNET,A.LANGUAGE=B.LANGUAGE,A.TRADINGACC=B.TRADINGACC,  
				A.ACCCLIENTCODE=B.ACCCLIENTCODE,A.DEMATACCNO=B.DEMATACCNO,A.REGOTHER=B.REGOTHER,A.REGEXGNAME=B.REGEXGNAME,  
				A.REGSEG=B.REGSEG,A.SEBIACTION=B.SEBIACTION,A.SEBIACTDET=B.SEBIACTDET,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,A.MDYDT=GETDATE(),  
				A.NOOFBRANCHOFFICES=B.NOOFBRANCHOFFICES,A.TOTAREASQFEET=B.TOTAREASQFEET,A.TOTNOOFDEALERS=B.TOTNOOFDEALERS,A.TOTNOOFTERMINALS=B.TOTNOOFTERMINALS,A.IPADDRESS=B.IPADDRESS  
				FROM MIS.SB_COMP.DBO.SB_BANKOTHERS A  
				JOIN  
				(
				
				
						SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,  
						A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,  
						A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,  
						NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,  
						CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,  
						NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,  

						C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,  
						'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS   

						FROM TBL_MF_BANKDETAILS A   
						JOIN TBL_MF_INFRASTRUCTURE B  
						ON A.ENTRYID = B.ENTRYID  
						JOIN TBL_MF_IDENTITYDETAILS C  
						ON A.ENTRYID = C.ENTRYID  
						WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID  
				)B   
				ON A.REFNO = B.REFNO  
				AND A.COMPANY = B.COMPANY  
    
		--BPREGMASTER  
		
		--drop table #SEGMENTS
				IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL
				/*Then it exists*/
				DROP TABLE #SEGMENTS
			
				SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM 
				(SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A

				update #SEGMENTS   
				set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END 
				from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID  


				

		--DROP TABLE #SEGMENTS  

				--INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)  
				UPDATE A  SET A.REGAPRREFNO =B.REGAPRREFNO,A.REGTAG=B.REGTAG,A.REGEXCHANGESEGMENT=B.REGEXCHANGESEGMENT,A.NAMESALUTATION=B.NAMESALUTATION,  
				A.REGNAME=B.REGNAME,A.TRADENAMESALUTATION=B.TRADENAMESALUTATION,A.REGTRADENAME=B.REGTRADENAME,A.REGFATHERHUSBANDNAME=B.REGFATHERHUSBANDNAME,  
				A.TYPE=B.TYPE,A.REGDOB=B.REGDOB,A.REGSEX=B.REGSEX,A.REGRESADD1=B.REGRESADD1,A.REGRESADD2=B.REGRESADD2,  
				A.REGRESADD3=B.REGRESADD3,A.REGRESCITY=B.REGRESCITY,A.REGRESPIN=B.REGRESPIN,A.REGOFFADD1=B.REGOFFADD1,A.REGOFFADD2=B.REGOFFADD2,  
				A.REGOFFADD3=B.REGOFFADD3,A.REGOFFCITY=B.REGOFFCITY,A.REGOFFPIN=B.REGOFFPIN,A.REGOFFPHONE=B.REGOFFPHONE,A.REGMOBILE=B.REGMOBILE,  
				A.REGMOBILE2=B.REGMOBILE2,A.REGRESPHONE=B.REGRESPHONE,A.REGRESFAX=B.REGRESFAX,A.REGPAN=B.REGPAN,A.REGPAN_APPLIED=B.REGPAN_APPLIED,  
				A.REGCORRESPONDANCEADD=B.REGCORRESPONDANCEADD,A.REGMAPIN=B.REGMAPIN,A.REGPROPRIETORSHIPYN=B.REGPROPRIETORSHIPYN,A.REGEXPINYRS=B.REGEXPINYRS,  
				A.REGRESIDENTIALSTATUS=B.REGRESIDENTIALSTATUS,A.REGEMAILID=B.REGEMAILID,A.REGREFERENCETAG=B.REGREFERENCETAG,A.REGMKRID=B.REGMKRID,  
				A.REGMKRDT=B.REGMKRDT,A.TAGBRANCH=B.TAGBRANCH,A.GLUNREGISTEREDCODE=B.GLUNREGISTEREDCODE,A.GLREGISTEREDCODE=B.GLREGISTEREDCODE,  
				A.REGSTATUS=B.REGSTATUS,A.REGDATE=B.REGDATE,A.REGNO=B.REGNO,A.UPLOAD=B.UPLOAD,A.ALIAS=B.ALIAS,A.ALIASNAME=B.ALIASNAME,A.REGPORTALNO=B.REGPORTALNO  
				FROM MIS.SB_COMP.DBO.BPREGMASTER A  
				JOIN  
				(
						SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,  
						A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,  
						/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,  
						A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,  
						CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,  
						D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,   
						E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,  
						E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,  
						D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,  
						E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,  
						A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,  
						NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,  
						NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo 

						FROM TBL_MF_BASICDETAILS A  
						JOIN #SEGMENTS B  
						ON A.ENTRYID = B.ENTRYID  
						JOIN TBL_MF_IDENTITYDETAILS C  
						ON A.ENTRYID = C.ENTRYID  
						JOIN TBL_MF_ADDRESS D  
						ON A.ENTRYID = D.ENTRYID  
						JOIN TBL_MF_ADDRESS E  
						ON A.ENTRYID = E.ENTRYID  
						JOIN TBL_MF_ARNDetails F  
						ON A.ENTRYID = F.ENTRYID  
						WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID  
				)B  
				ON A.RegAprRefNo = B.REGAPRREFNO  
				AND A.RegTAG = B.REGTAG  
				AND A.RegExchangeSegment = B.RegExchangeSegment  





		--MIS.SB_COMP.DBO.BPAPPLICATION   
				--INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)  
				UPDATE A   
				SET A.TERMINALLOCATION=B.TERMINALLOCATION,A.CRUSER=B.CRUSER,A.MODUSER=B.CRUSER,A.MODDATE= GETDATE(),A.APPAUTHORISED_PERSON=B.APPAUTHORISED_PERSON,  
				A.MODE = B.MODE  
				FROM MIS.SB_COMP.DBO.BPAPPLICATION A  
				JOIN  
				(
							SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,  
							CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,  
							C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,  
							NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,  
							NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO  

							FROM TBL_MF_BASICDETAILS A  
							JOIN #SEGMENTS B  
							ON A.ENTRYID = B.ENTRYID  
							JOIN TBL_MF_IDENTITYDETAILS C  
							ON A.ENTRYID = C.ENTRYID  
							JOIN TBL_MF_ARNDetails D  
							ON A.ENTRYID = D.ENTRYID  
							WHERE A.ENTRYID =@ENTRYID  
				)B  
				ON A.AppRefNo=B.AppRefNo AND A.EST=B.EST  



		--MIS.SB_COMP.DBO.SB_PERSONAL  

				--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)  
				UPDATE A   
				SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,  
				A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,  
				A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,  
				A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,  
				A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS  
				FROM MIS.SB_COMP.DBO.SB_PERSONAL A  
				JOIN  
				(
							SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,  
							/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,  
							CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,  
							CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,  
							C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,  
							B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS  
							FROM TBL_MF_BASICDETAILS A  
							JOIN TBL_MF_IDENTITYDETAILS B  
							ON A.ENTRYID = B.ENTRYID  
							JOIN TBL_MF_REGISTRATIONRELATED C  
							ON A.ENTRYID = C.ENTRYID  
							WHERE A.ENTRYID = @ENTRYID  
				)B  
				ON A.REFNO= B.REFNO  
		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS  ONLY FOR NEW SB
		----MIS.SB_COMP.DBO.TAG_BO_DETAILS  
		--		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)  
		--		SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE  
		--		FROM TBL_MF_BASICDETAILS A  
		--		JOIN TBL_MF_IDENTITYDETAILS B  
		--		ON A.ENTRYID = B.ENTRYID  
		--		WHERE A.ENTRYID = @ENTRYID  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATE_OLDSB
-- --------------------------------------------------


-- =============================================
-- Author:		Ashok/Suraj
-- Create date: 05May2018
-- Description:	uPDATE OLD sb details in in-house
-- =============================================
CREATE PROCEDURE [dbo].[USP_MF_UPDATE_OLDSB]
		@ENTRYID AS INT,  
		@CSOID AS VARCHAR(50)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @REFNO NUMERIC(18,0),@SBTAG VARCHAR(30)
		SELECT @SBTAG = SBTAG FROM TBL_MF_IDENTITYDETAILS  WHERE  ENTRYID = @ENTRYID 
		SELECT @REFNO= REFNO FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG
		--SB_BROKER  

		print @REFNO  

				UPDATE A  
				SET /*A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,  
				A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,  
				A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,  
				A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,  
				A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,  
				A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,  
				A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE(), A.SBstatus=B.SBstatus,A.SEBIRegNo=B.SEBIRegNo */
				A.SB_Broker_Type = B.SB_Broker_Type,A.MF_REG_Date = B.MF_REG_Date
				FROM MIS.SB_COMP.DBO.SB_BROKER A  
				JOIN  
				(
					SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE, 
					B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,  
					B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,  
					B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,  
					/*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,  
					B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,
					@CSOID AS IPADDRESS,B.ENTRYBY  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,
					CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIRegNo
					--INTO TBL_TEST  
					FROM TBL_MF_BASICDETAILS A  
					JOIN TBL_MF_IDENTITYDETAILS B  
					ON A.ENTRYID = B.ENTRYID  
					--JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C  
					--ON B.ENTRYBY = C.EMP_NO  
					JOIN TBL_MF_ARNDetails D  
					ON A.ENTRYID = D.ENTRYID  
					WHERE A.ENTRYID = @ENTRYID  
				)B
				ON A.REFNO = B.REFNO  
				AND A.SBTAG = B.SBTAG  
				
				
				
				if not exists(select * from [172.31.16.95].NXT.dbo.MF_UserLogin where access_code=@SBTAG)
				begin
					insert into [172.31.16.95].NXT.dbo.MF_UserLogin(userid,person_name,username,userpassword,usertype,access_to,access_code,cat_code,status,last_login,NoOfTry,NoOfLogin,login_Activated,login_inactive_date,active,email,IP,IP_active,Gateway,Gateway_active,session_id,CreatedBy,CreatedOn,LastModifiedBy,LastModifiedOn,MFUserType,MobNo,IsFirstLogin,PasswordChangedDate)
					select userid,person_name,username,userpassword,usertype,access_to,access_code,cat_code,status,last_login,NoOfTry,NoOfLogin,login_Activated,login_inactive_date,active,email,IP,IP_active,Gateway,Gateway_active,session_id,CreatedBy,CreatedOn,LastModifiedBy,LastModifiedOn,'MF' MFUserType,'' MobNo,1 IsFirstLogin,'' PasswordChangedDate from Rolemgm.dbo.user_login where access_code=@SBTAG
				END
				
      
	    
		--SB_CONTACT  
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)  

				INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)  
				SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID  

				UNION ALL  
				--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )  
				SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID  


				Update A
				Set MobNo=T.MobNo,
				email=T.Emailid
				From  [172.31.16.95].NXT.dbo.[MF_UserLogin] A
				Inner join 
				(
				select sbtag,C.MobNo,Emailid from 
				MIS.sb_comp.dbo.sb_broker SB 
				Inner join MIS.sb_comp.dbo.sb_contact C ON  SB.RefNo=C.RefNo
				--where sbtag='VIKE'
				and AddType in ('TER','MFRES','RES')-- 'RES'
				and sbtag=@SBTAG

				) T ON T.sbtag=access_code
				where sbtag=@SBTAG



		--SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018  

		--SB_DDCHEQUE  
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT   

		--MIS.SB_COMP.DBO.SB_BANKOTHERS  
		-- FOR EQUITY  ISCOMMODITY = 0  
				--INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,  
				A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,  
				A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,  
				NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,  
				CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,  
				NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,  

				C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,  
				'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS   

				FROM TBL_MF_BANKDETAILS A   
				JOIN TBL_MF_INFRASTRUCTURE B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID  
    
		--BPREGMASTER  
		
		--drop table #SEGMENTS
			IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL
				/*Then it exists*/
				DROP TABLE #SEGMENTS
			
				SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM 
				(SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A

				update #SEGMENTS   
				set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END 
				from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID  


				

		--DROP TABLE #SEGMENTS  

				INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)  

				SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,  
				A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,  
				/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,  
				A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,  
				CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,  
				D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,   
				E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,  
				E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,  
				D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,  
				E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,  
				A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,  
				NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,  
				NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo 

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ADDRESS D  
				ON A.ENTRYID = D.ENTRYID  
				JOIN TBL_MF_ADDRESS E  
				ON A.ENTRYID = E.ENTRYID  
				JOIN TBL_MF_ARNDetails F  
				ON A.ENTRYID = F.ENTRYID  
				WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID  





		--MIS.SB_COMP.DBO.BPAPPLICATION   
			INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)  

				SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,  
				CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,  
				C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,  
				NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,  
				NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO  

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ARNDetails D  
				ON A.ENTRYID = D.ENTRYID  
				WHERE A.ENTRYID =@ENTRYID  




		--MIS.SB_COMP.DBO.SB_PERSONAL  

				--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)  
				--UPDATE A   
				--SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,  
				--A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,  
				--A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,  
				--A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,  
				--A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS  
				--FROM MIS.SB_COMP.DBO.SB_PERSONAL A  
				--JOIN  
				--(
				--			SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,  
				--			/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,  
				--			CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,  
				--			CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,  
				--			C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,  
				--			B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS  
				--			FROM TBL_MF_BASICDETAILS A  
				--			JOIN TBL_MF_IDENTITYDETAILS B  
				--			ON A.ENTRYID = B.ENTRYID  
				--			JOIN TBL_MF_REGISTRATIONRELATED C  
				--			ON A.ENTRYID = C.ENTRYID  
				--			WHERE A.ENTRYID = @ENTRYID  
				--)B  
				--ON A.REFNO= B.REFNO  
		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS  ONLY FOR NEW SB
		----MIS.SB_COMP.DBO.TAG_BO_DETAILS  
		--		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)  
		--		SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE  
		--		FROM TBL_MF_BASICDETAILS A  
		--		JOIN TBL_MF_IDENTITYDETAILS B  
		--		ON A.ENTRYID = B.ENTRYID  
		--		WHERE A.ENTRYID = @ENTRYID  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATE_OLDSB_15092018
-- --------------------------------------------------


-- =============================================
-- Author:		Ashok/Suraj
-- Create date: 05May2018
-- Description:	uPDATE OLD sb details in in-house
-- =============================================
Create PROCEDURE [dbo].[USP_MF_UPDATE_OLDSB_15092018]
		@ENTRYID AS INT,  
		@CSOID AS VARCHAR(50)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @REFNO NUMERIC(18,0),@SBTAG VARCHAR(30)
		SELECT @SBTAG = SBTAG FROM TBL_MF_IDENTITYDETAILS  WHERE ENTRYID = @ENTRYID  
		SELECT @REFNO= REFNO FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG
		--SB_BROKER  

		print @REFNO  

				UPDATE A  
				SET /*A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,  
				A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,  
				A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,  
				A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,  
				A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,  
				A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,  
				A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE(), A.SBstatus=B.SBstatus,A.SEBIRegNo=B.SEBIRegNo */
				A.SB_Broker_Type = B.SB_Broker_Type,A.MF_REG_Date = B.MF_REG_Date
				FROM MIS.SB_COMP.DBO.SB_BROKER A  
				JOIN  
				(
					SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE, 
					B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,  
					B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,  
					B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,  
					/*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,  
					B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,
					@CSOID AS IPADDRESS,B.ENTRYBY  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,
					CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIRegNo
					--INTO TBL_TEST  
					FROM TBL_MF_BASICDETAILS A  
					JOIN TBL_MF_IDENTITYDETAILS B  
					ON A.ENTRYID = B.ENTRYID  
					--JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C  
					--ON B.ENTRYBY = C.EMP_NO  
					JOIN TBL_MF_ARNDetails D  
					ON A.ENTRYID = D.ENTRYID  
					WHERE A.ENTRYID = @ENTRYID  
				)B
				ON A.REFNO = B.REFNO  
				AND A.SBTAG = B.SBTAG  
      
	    
		--SB_CONTACT  
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)  

				INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)  
				SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID  

				UNION ALL  
				--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )  
				SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID  

		--SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018  

		--SB_DDCHEQUE  
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT   

		--MIS.SB_COMP.DBO.SB_BANKOTHERS  
		-- FOR EQUITY  ISCOMMODITY = 0  
				--INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,  
				A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,  
				A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,  
				NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,  
				CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,  
				NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,  

				C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,  
				'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS   

				FROM TBL_MF_BANKDETAILS A   
				JOIN TBL_MF_INFRASTRUCTURE B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID  
    
		--BPREGMASTER  
		
		--drop table #SEGMENTS
			IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL
				/*Then it exists*/
				DROP TABLE #SEGMENTS
			
				SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM 
				(SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A

				update #SEGMENTS   
				set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END 
				from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID  


				

		--DROP TABLE #SEGMENTS  

				INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)  

				SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,  
				A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,  
				/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,  
				A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,  
				CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,  
				D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,   
				E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,  
				E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,  
				D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,  
				E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,  
				A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,  
				NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,  
				NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo 

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ADDRESS D  
				ON A.ENTRYID = D.ENTRYID  
				JOIN TBL_MF_ADDRESS E  
				ON A.ENTRYID = E.ENTRYID  
				JOIN TBL_MF_ARNDetails F  
				ON A.ENTRYID = F.ENTRYID  
				WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID  





		--MIS.SB_COMP.DBO.BPAPPLICATION   
			INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)  

				SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,  
				CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,  
				C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,  
				NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,  
				NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO  

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ARNDetails D  
				ON A.ENTRYID = D.ENTRYID  
				WHERE A.ENTRYID =@ENTRYID  




		--MIS.SB_COMP.DBO.SB_PERSONAL  

				--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)  
				--UPDATE A   
				--SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,  
				--A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,  
				--A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,  
				--A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,  
				--A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS  
				--FROM MIS.SB_COMP.DBO.SB_PERSONAL A  
				--JOIN  
				--(
				--			SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,  
				--			/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,  
				--			CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,  
				--			CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,  
				--			C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,  
				--			B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS  
				--			FROM TBL_MF_BASICDETAILS A  
				--			JOIN TBL_MF_IDENTITYDETAILS B  
				--			ON A.ENTRYID = B.ENTRYID  
				--			JOIN TBL_MF_REGISTRATIONRELATED C  
				--			ON A.ENTRYID = C.ENTRYID  
				--			WHERE A.ENTRYID = @ENTRYID  
				--)B  
				--ON A.REFNO= B.REFNO  
		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS  ONLY FOR NEW SB
		----MIS.SB_COMP.DBO.TAG_BO_DETAILS  
		--		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)  
		--		SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE  
		--		FROM TBL_MF_BASICDETAILS A  
		--		JOIN TBL_MF_IDENTITYDETAILS B  
		--		ON A.ENTRYID = B.ENTRYID  
		--		WHERE A.ENTRYID = @ENTRYID  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATE_OLDSB_19June2018
-- --------------------------------------------------


-- =============================================
-- Author:		Ashok/Suraj
-- Create date: 05May2018
-- Description:	uPDATE OLD sb details in in-house
-- =============================================
create PROCEDURE [dbo].[USP_MF_UPDATE_OLDSB_19June2018]
		@ENTRYID AS INT,  
		@CSOID AS VARCHAR(50)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @REFNO NUMERIC(18,0),@SBTAG VARCHAR(30)
		SELECT @SBTAG = SBTAG FROM TBL_MF_IDENTITYDETAILS  WHERE ENTRYID = @ENTRYID  
		SELECT @REFNO= REFNO FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG = @SBTAG
		--SB_BROKER  

		print @REFNO  

				UPDATE A  
				SET /*A.BRANCH = B.BRANCH,A.PARENTTAG=B.PARENTTAG,A.TRADENAME=B.TRADENAME,A.ORGTYPE=B.ORGTYPE,  
				A.DOI=B.DOI,A.SALCONTACTPERSON=B.SALCONTACTPERSON,A.CONTACTPERSON=B.CONTACTPERSON,A.REGCAT=B.REGCAT,  
				A.PANNO=B.PANNO,A.LEADSOURCE=B.LEADSOURCE,A.EMPID=B.EMPID,  
				A.PANVERIFIED=B.PANVERIFIED,A.TRADENAMEINCOMMODITY=B.TRADENAMEINCOMMODITY,  
				A.DOICOR=B.DOICOR,A.PANNOCORP=B.PANNOCORP,A.MAKERPAN=B.MAKERPAN,A.CHECKERPAN=B.CHECKERPAN,  
				A.MAKERID=B.MAKERID,A.CHECKERID=B.CHECKERID,A.APPSTATUS=B.APPSTATUS,A.REJECTREASONS=B.REJECTREASONS,  
				A.IPADDRESS=B.IPADDRESS,A.AUTHSIGN=B.AUTHSIGN,A.MdyBy=B.CRTBY,A.MdyDt = GETDATE(), A.SBstatus=B.SBstatus,A.SEBIRegNo=B.SEBIRegNo */
				A.SB_Broker_Type = B.SB_Broker_Type,A.MF_REG_Date = B.MF_REG_Date
				FROM MIS.SB_COMP.DBO.SB_BROKER A  
				JOIN  
				(
					SELECT @REFNO AS REFNO,B.SBTAG,A.BranchTag AS BRANCH,/*A.PARENT*/'' AS PARENTTAG, A.TRADENAME AS TRADENAME, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END  AS ORGTYPE, 
					B.ENTRY_DATE AS DOI, A.Salutation AS SALCONTACTPERSON,A.FIRSTNAME+' '+A.MIDDLENAME+' '+A.LASTNAME AS CONTACTPERSON, CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'I' ELSE 'P' END AS REGCAT,  
					B.PAN AS PANNO,'D-REG' AS LEADSOURCE,B.ENTRYBY AS EMPID,'Y' AS PANVERIFIED, GETDATE() AS TAGGENERATEDDATE,0 AS REGSTATUS,NULL AS RECSTATUS,  
					B.ENTRYBY AS CRTBY,B.ENTRY_DATE  AS CRTDT,1 AS PRINTED,  
					/*A.TRADENAMECOMM */ '' AS TRADENAMEINCOMMODITY,CONVERT(DATETIME,B.DOB,103) AS DOICOR,B.PAN AS PANNOCORP,B.PAN AS MAKERPAN,B.PAN AS CHECKERPAN,  
					B.ENTRYBY AS MAKERID,NULL AS CHECKERID,'A' AS APPSTATUS,NULL AS REJECTREASONS,GETDATE() AS TIMESTAMP,
					@CSOID AS IPADDRESS,C.EMP_NAME  AS AUTHSIGN,'MF' as SB_Broker_Type,GETDATE() as MF_REG_Date,
					CASE WHEN D.IsARN =1 THEN 'REG' ELSE NULL END AS SBstatus,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIRegNo
					--INTO TBL_TEST  
					FROM TBL_MF_BASICDETAILS A  
					JOIN TBL_MF_IDENTITYDETAILS B  
					ON A.ENTRYID = B.ENTRYID  
					JOIN (SELECT EMP_NO,EMP_NAME FROM INTRANET.RISK.DBO.EMP_INFO )C  
					ON B.ENTRYBY = C.EMP_NO  
					JOIN TBL_MF_ARNDetails D  
					ON A.ENTRYID = D.ENTRYID  
					WHERE A.ENTRYID = @ENTRYID  
				)B
				ON A.REFNO = B.REFNO  
				AND A.SBTAG = B.SBTAG  
      
	    
		--SB_CONTACT  
		--RESIDENTIAL ADDRESS(WE ARE INSERTING CURRESPONDANCE ADDRESS INTO RESIDENTIAL ADDRESS)  

				INSERT INTO MIS.SB_COMP.DBO.SB_CONTACT(REFNO,ADDTYPE,ADDLINE1,ADDLINE2,LANDMARK,CITY,STATE,COUNTRY,PINCODE,STDCODE,TELNO,MOBNO,EMAILID,RECSTATUS,CRTBY,CRTDT)  
				SELECT @REFNO AS REFNO,'MFRES' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 0 AND A.ENTRYID = @ENTRYID  

				UNION ALL  
				--OFFICIAL ADDRESS(WE ARE INSERTING PERMENANT ADDRESS )  
				SELECT @REFNO AS REFNO,'MFOFF' AS ADDTYPE ,A.ADDRESS1 AS ADDLINE1,A.ADDRESS2+A.ADDRESS3 AS ADDLINE2,A.AREA AS LANDMARK,A.CITY AS CITY,A.STATE AS STATE,  
				'INDIA' AS COUNTRY,A.PIN AS PINCODE,A. STD AS STDCODE,A. PHONE AS TELNO,A. MOBILE AS MOBNO,A. EMAIL AS EMAILID,NULL AS RECSTATUS,B.ENTRYBY AS CRTBY,  B.ENTRY_DATE AS CRTDT  
				FROM TBL_MF_ADDRESS A  
				JOIN TBL_MF_IDENTITYDETAILS B  
				ON A.ENTRYID = B.ENTRYID  
				WHERE A.ISPERMANENT  = 1 AND A.ENTRYID = @ENTRYID  

		--SB_BROKERAGE DATA NOT AVAILABLE ON 05MAY2018  

		--SB_DDCHEQUE  
		--SELECT @REFNO AS REFNO,NONCASH,PARTICULAR,PAYEENAME,BANK,DDCHEQUENO,INSDATE,AMOUNT,PAYAT,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT   

		--MIS.SB_COMP.DBO.SB_BANKOTHERS  
		-- FOR EQUITY  ISCOMMODITY = 0  
				--INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				INSERT INTO MIS.SB_COMP.DBO.SB_BANKOTHERS(REFNO,NAMEINBANK,ACCTYPE,ACCNO,BANKNAME,BRANCHADD1,BRANCHADD2,BRANCHADD3,BRANCHPIN,MICRCODE,IFSRCODE,INCOMERANGE,BUSINESSLOC,NOMINEEREL,NOMINEENAME,TERMINALLOCATION,SOCIALNET,LANGUAGE,TRADINGACC,ACCCLIENTCODE,DEMATACCNO,REGOTHER,REGEXGNAME,REGSEG,SEBIACTION,SEBIACTDET,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,NOOFBRANCHOFFICES,TOTAREASQFEET,TOTNOOFDEALERS,TOTNOOFTERMINALS,COMPANY,MAKERID,CHECKERID,TIMESTAMP,IPADDRESS)  
				SELECT @REFNO AS REFNO,A.NAMEINBANK AS NAMEINBANK ,CASE WHEN A.ACCOUNTTYPE='CURRENT' THEN 'CR'  WHEN A.ACCOUNTTYPE='SAVINGS' THEN 'SAV' END AS  ACCTYPE,  
				A.ACCOUNTNO AS ACCNO,A.BANKNAME AS BANKNAME ,A.ADDRESS AS  BRANCHADD1,'' AS BRANCHADD2,'' AS BRANCHADD3,'' AS BRANCHPIN ,A.MICR AS  MICRCODE,  
				A.IFSCRGTS AS IFSRCODE,REPLACE (B.INCOMERANGE , ' LACS' ,'L') AS  INCOMERANGE,CASE WHEN B.MAINOFFICE = 'OWNED' THEN 'OP' WHEN B.MAINOFFICE = 'LEASED' THEN 'RENT' WHEN B.MAINOFFICE = 'BROKERS EXISTING BRANCH' THEN 'AO' END AS BUSINESSLOC,  
				NULL AS NOMINEEREL,NULL AS NOMINEENAME,NULL AS TERMINALLOCATION,  
				CASE WHEN B.SOCIALNETWORKING='< 500 PEOPLE' THEN '500' WHEN B.SOCIALNETWORKING='500-1000 PEOPLE' THEN '500-1000' END AS   SOCIALNET,  
				NULL AS LANGUAGE,NULL AS TRADINGACC,NULL AS ACCCLIENTCODE,NULL AS DEMATACCNO,NULL AS REGOTHER,NULL AS REGEXGNAME,NULL AS REGSEG,NULL AS SEBIACTION,NULL AS SEBIACTDET,NULL AS RECSTATUS,  

				C.ENTRYBY AS CRTBY,  C.ENTRY_DATE AS CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS NOOFBRANCHOFFICES,NULL AS TOTAREASQFEET,NULL AS TOTNOOFDEALERS,NULL AS TOTNOOFTERMINALS,  
				'MF' AS COMPANY,NULL AS MAKERID,NULL AS CHECKERID,NULL AS TIMESTAMP,@CSOID  AS IPADDRESS   

				FROM TBL_MF_BANKDETAILS A   
				JOIN TBL_MF_INFRASTRUCTURE B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				WHERE /*A.ISCOMMODITY = 0 AND*/ A.ENTRYID =@ENTRYID  
    
		--BPREGMASTER  
		
		--drop table #SEGMENTS
			IF OBJECT_ID('tempdb..#SEGMENTS') IS NOT NULL
				/*Then it exists*/
				DROP TABLE #SEGMENTS
			
				SELECT ENTRYID,SEGMENT ,ISAPPLIED INTO #SEGMENTS FROM 
				(SELECT @ENTRYID AS ENTRYID,cast('MMF' as varchar(10)) AS SEGMENT,0 AS ISAPPLIED)AS A

				update #SEGMENTS   
				set SEGMENT =CASE WHEN A.OrganizationType='INDIVIDUAL' THEN 'MIMF' ELSE 'MPMF' END 
				from #SEGMENTS , tbl_mf_basicDetails a where a.ENTRYID =@ENTRYID  


				

		--DROP TABLE #SEGMENTS  

				INSERT INTO MIS.SB_COMP.DBO.BPREGMASTER(REGAPRREFNO,REGTAG,REGEXCHANGESEGMENT,NAMESALUTATION,REGNAME,TRADENAMESALUTATION,REGTRADENAME,REGFATHERHUSBANDNAME,TYPE,REGDOB,REGSEX,REGRESADD1,REGRESADD2,REGRESADD3,REGRESCITY,REGRESPIN,REGOFFADD1,REGOFFADD2,REGOFFADD3,REGOFFCITY,REGOFFPIN,REGOFFPHONE,REGMOBILE,REGMOBILE2,REGRESPHONE,REGRESFAX,REGPAN,REGPAN_APPLIED,REGCORRESPONDANCEADD,REGMAPIN,REGPROPRIETORSHIPYN,REGEXPINYRS,REGRESIDENTIALSTATUS,REGEMAILID,REGREFERENCETAG,REGMKRID,REGMKRDT,TAGBRANCH,GLUNREGISTEREDCODE,GLREGISTEREDCODE,REGSTATUS,REGDATE,REGNO,UPLOAD,ALIAS,ALIASNAME,REGPORTALNO,REGINTIMATEDATE,BO_UPDATE,CTS,PLS,[ADDRESS STATUS],[ADDRESS INTIMATE DATE],REASON,FILENAME,ATTACHMENT,RegNo)  

				SELECT @REFNO AS REGAPRREFNO,C.SBTAG AS REGTAG,B.SEGMENT AS REGEXCHANGESEGMENT,A.Salutation AS NAMESALUTATION,  
				A.FIRSTNAME+ ' ' +A.MIDDLENAME+' '+A.LASTNAME AS REGNAME,'' AS TRADENAMESALUTATION,A.TRADENAME AS REGTRADENAME,  
				/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS REGFATHERHUSBANDNAME,  
				A.OrganizationType AS TYPE,CONVERT(DATETIME,C.DOB,103) AS REGDOB,  
				CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS REGSEX,  
				D.ADDRESS1 AS  REGRESADD1,D.ADDRESS2 AS  REGRESADD2,D.ADDRESS3 AS REGRESADD3,D.CITY AS REGRESCITY,D.PIN AS  REGRESPIN,   
				E.ADDRESS1 AS REGOFFADD1,E.ADDRESS2 AS REGOFFADD2, E.ADDRESS3 AS REGOFFADD3,E.CITY AS REGOFFCITY,E.PIN AS REGOFFPIN,E.PHONE AS REGOFFPHONE,  
				E.MOBILE AS  REGMOBILE,'' AS REGMOBILE2,D.MOBILE AS REGRESPHONE,'' AS REGRESFAX,C.PAN AS REGPAN,NULL AS REGPAN_APPLIED,  
				D.ADDRESS1+' '+D.ADDRESS2+' '+D.ADDRESS3 AS  REGCORRESPONDANCEADD,NULL AS REGMAPIN,NULL AS REGPROPRIETORSHIPYN,NULL AS REGEXPINYRS,NULL AS REGRESIDENTIALSTATUS,  
				E.EMAIL AS REGEMAILID,NULL AS REGREFERENCETAG,NULL AS REGMKRID,NULL AS REGMKRDT,  
				A.BranchTag AS TAGBRANCH,'21'+C.SBTAG AS  GLUNREGISTEREDCODE,'28'+C.SBTAG AS GLREGISTEREDCODE,CASE WHEN F.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS REGSTATUS,  
				NULL AS REGDATE,NULL AS REGNO,NULL AS UPLOAD,NULL AS ALIAS,NULL AS ALIASNAME,NULL AS REGPORTALNO,NULL AS REGINTIMATEDATE,NULL AS BO_UPDATE,NULL AS CTS,  
				NULL AS PLS,NULL AS [ADDRESS STATUS],NULL AS [ADDRESS INTIMATE DATE],NULL AS REASON,NULL AS FILENAME,NULL AS ATTACHMENT,CASE WHEN F.IsARN =1 THEN F.ARN_Number ELSE NULL END AS RegNo 

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ADDRESS D  
				ON A.ENTRYID = D.ENTRYID  
				JOIN TBL_MF_ADDRESS E  
				ON A.ENTRYID = E.ENTRYID  
				JOIN TBL_MF_ARNDetails F  
				ON A.ENTRYID = F.ENTRYID  
				WHERE D.ISPERMANENT = 0 AND E.ISPERMANENT = 1 AND A.ENTRYID =@ENTRYID  





		--MIS.SB_COMP.DBO.BPAPPLICATION   
			INSERT INTO MIS.SB_COMP.DBO.BPAPPLICATION (APPREFNO,EST,TERMINALLOCATION,APPDATE,APPSTATUS,STATUSDATE,CSOREMARKS,EXCHREMARKS,SEBIREGNO,CRUSER,CRDATE,MODUSER,MODDATE,APPAUTHORISED_PERSON,MODE,CLIENT_CODE,DDNO,BANK_NAME,SEBIPORTALNO,INTIMATEDATE,SEBIQUERY,CSOCOMMENTS,FILENO,MAKERID,CHECKID,IPADDRESS,TIMESTAMP,CHECKERSTATUS,CHECKERSEBIREGNO)  

				SELECT @REFNO AS APPREFNO,B.SEGMENT AS  EST,NULL AS TERMINALLOCATION,GETDATE() AS APPDATE,  
				CASE WHEN D.IsARN =1 THEN 'Registered' ELSE 'Not Applied' END  AS APPSTATUS,NULL AS STATUSDATE,NULL AS CSOREMARKS,NULL AS EXCHREMARKS,CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END AS SEBIREGNO,  
				C.ENTRYBY AS  CRUSER,C.ENTRY_DATE AS CRDATE,NULL AS MODUSER,NULL AS MODDATE,NULL AS APPAUTHORISED_PERSON,NULL AS MODE,  
				NULL AS CLIENT_CODE,NULL AS DDNO,NULL AS BANK_NAME,NULL AS SEBIPORTALNO,NULL AS INTIMATEDATE,NULL AS SEBIQUERY,NULL AS CSOCOMMENTS,  
				NULL AS FILENO,NULL AS MAKERID,NULL AS CHECKID,@CSOID AS IPADDRESS,NULL AS TIMESTAMP,NULL AS CHECKERSTATUS,NULL AS CHECKERSEBIREGNO  

				FROM TBL_MF_BASICDETAILS A  
				JOIN #SEGMENTS B  
				ON A.ENTRYID = B.ENTRYID  
				JOIN TBL_MF_IDENTITYDETAILS C  
				ON A.ENTRYID = C.ENTRYID  
				JOIN TBL_MF_ARNDetails D  
				ON A.ENTRYID = D.ENTRYID  
				WHERE A.ENTRYID =@ENTRYID  




		--MIS.SB_COMP.DBO.SB_PERSONAL  

				--INSERT INTO MIS.SB_COMP.DBO.SB_PERSONAL(REFNO,SALUTATION,FIRSTNAME,MIDDLENAME,LASTNAME,FATHHUSBNAME,DOB,SEX,MARITAL,EDUQUAL,OCCUPATION,OCCDETAILS,EXPDETAILS,BROKINGCOMPANY,TRADMEMBER,BROKEXP,PHOTOGRAPH,SIGNATURE,RECSTATUS,CRTBY,CRTDT,MDYBY,MDYDT,OCCUPATIONDETAILS,SPOUSEOCC,TIMESTAMP,IPADDRESS)  
				--UPDATE A   
				--SET A.SALUTATION=B.SALUTATION,A.FIRSTNAME=B.FIRSTNAME,A.MIDDLENAME=B.MIDDLENAME,A.LASTNAME=B.LASTNAME,A.FATHHUSBNAME=B.FATHHUSBNAME,  
				--A.DOB=B.DOB,A.SEX=B.SEX,A.MARITAL=B.MARITAL,A.EDUQUAL=B.EDUQUAL,A.OCCUPATION=B.OCCUPATION,A.OCCDETAILS=B.OCCDETAILS,A.OCCDETAILS=B.OCCDETAILS,  
				--A.BROKINGCOMPANY=B.BROKINGCOMPANY,A.TRADMEMBER=B.TRADMEMBER,A.BROKEXP=B.BROKEXP,A.PHOTOGRAPH=B.PHOTOGRAPH,  
				--A.SIGNATURE=B.SIGNATURE,A.RECSTATUS=B.RECSTATUS,A.MDYBY=B.CRTBY,MDYDT=GETDATE(),A.OCCUPATIONDETAILS=B.OCCUPATIONDETAILS,  
				--A.SPOUSEOCC=B.SPOUSEOCC,A.TIMESTAMP=B.TIMESTAMP,A.IPADDRESS=B.IPADDRESS  
				--FROM MIS.SB_COMP.DBO.SB_PERSONAL A  
				--JOIN  
				--(
				--			SELECT @REFNO AS REFNO,A.SALUTATION AS SALUTATION,A.FIRSTNAME AS  FIRSTNAME, A.MIDDLENAME AS MIDDLENAME,A.LASTNAME AS  LASTNAME,  
				--			/*A.FATHERFIRSTNAME+' '+A.FATHERMIDDLENAME+' '+A.FATHERLASTNAME */ '' AS FATHHUSBNAME, CONVERT(DATETIME,B.DOB,103) AS DOB,  
				--			CASE WHEN A.GENDER = 'MALE' THEN 'M' WHEN A.GENDER = 'FEMALE' THEN 'F' END AS SEX,  
				--			CASE WHEN A.MARTIALSTATUS= 'SINGLE' THEN 'S' WHEN A.MARTIALSTATUS = 'MARRIED' THEN 'M' END AS MARITAL,  
				--			C.EDUQUALI AS EDUQUAL,C.OCCUPATION AS  OCCUPATION,C.NATUREOFOCCUPATION AS OCCDETAILS,NULL AS EXPDETAILS,NULL AS BROKINGCOMPANY,NULL AS TRADMEMBER,NULL AS BROKEXP,NULL AS PHOTOGRAPH,NULL AS SIGNATURE,NULL AS RECSTATUS,  
				--			B.ENTRYBY AS CRTBY,B.ENTRY_DATE AS  CRTDT,NULL AS MDYBY,NULL AS MDYDT,NULL AS OCCUPATIONDETAILS,NULL AS SPOUSEOCC,NULL AS TIMESTAMP,@CSOID AS IPADDRESS  
				--			FROM TBL_MF_BASICDETAILS A  
				--			JOIN TBL_MF_IDENTITYDETAILS B  
				--			ON A.ENTRYID = B.ENTRYID  
				--			JOIN TBL_MF_REGISTRATIONRELATED C  
				--			ON A.ENTRYID = C.ENTRYID  
				--			WHERE A.ENTRYID = @ENTRYID  
				--)B  
				--ON A.REFNO= B.REFNO  
		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS  ONLY FOR NEW SB
		----MIS.SB_COMP.DBO.TAG_BO_DETAILS  
		--		--INSERT INTO MIS.SB_COMP.DBO.TAG_BO_DETAILS(TAG,TAG_DATE,BO_TAG_UPDATE,BO_TAG_UPDATE_DATE)  
		--		SELECT B.SBTAG AS TAG,B.ENTRY_DATE AS  TAG_DATE,'N' AS  BO_TAG_UPDATE,NULL AS  BO_TAG_UPDATE_DATE  
		--		FROM TBL_MF_BASICDETAILS A  
		--		JOIN TBL_MF_IDENTITYDETAILS B  
		--		ON A.ENTRYID = B.ENTRYID  
		--		WHERE A.ENTRYID = @ENTRYID  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UPDATEPROFILEPIC
-- --------------------------------------------------

CREATE PROC [dbo].[USP_MF_UPDATEPROFILEPIC]
@ENTRYID INT =0,
@ID INT =0,
@PIC VARCHAR(100)=''
AS BEGIN

BEGIN TRY


		IF EXISTS (SELECT ENTRYID FROM TBL_MF_UPDATEPROFILEPIC WHERE  ENTRYID=@ENTRYID)
		BEGIN

					UPDATE TBL_MF_UPDATEPROFILEPIC
					SET PIC=@PIC
					WHERE  ENTRYID=@ENTRYID

			        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_MF_UPDATEPROFILEPIC WHERE  ENTRYID=@ENTRYID

		END

		ELSE
		BEGIN

		--INSERT

		INSERT INTO TBL_MF_UPDATEPROFILEPIC(ENTRYID,PIC)
		VALUES(@ENTRYID,@PIC)

		SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

		END

		END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UpdateSbTag
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[USP_MF_UpdateSbTag]       

@EntryID INT ,  

@sbtag varchar(20),

@employee_code varchar(50)='',     

@ipAddress varchar(50)=''         

AS      

BEGIN      

  

DECLARE @BranchExists VARCHAR(400)

	

SET  @BranchExists  = 

		(      

			SELECT ISNULL(Branch, '') AS Branch      

			FROM [MIS].SB_COMP.DBO.[SB_broker]      

			WHERE SBTAG = @sbtag ---and Branch  != 'MFSB'

		)      



		--Added on 29 Oct 2018 by aslam

		IF (ISNULL(@BranchExists, '') <> '' )

		BEGIN 

			UPDATE TBL_MF_BASICDETAILS

			SET BranchTag = @BranchExists

			WHERE ENTRYID = @EntryID      

		END



		UPDATE TBL_MF_IDENTITYDETAILS   

		SET ISAPPROVED = 6,  

		SBTag = @sbtag  

		WHERE  EntryID=@EntryID      

		    

		Select 1      

		

		EXEC usp_mfapplicationlog @ENTRYID,'MF SB TAG GENERATED','CSO',@employee_code,@ipAddress  

		

		exec USP_MF_INHOUSE_INTEGRATION @EntryID,@ipAddress

		

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MF_UpdateSbTag_29_Oct_2018
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_MF_UpdateSbTag_29_Oct_2018]
@EntryID INT ,  
@sbtag varchar(20),
@employee_code varchar(50)='',     
@ipAddress varchar(50)=''         
AS      
BEGIN      
    
    
		UPDATE TBL_MF_IDENTITYDETAILS   
		SET ISAPPROVED = 6,  
		SBTag = @sbtag  
		WHERE  EntryID=@EntryID      
		    
		Select 1      
		
		EXEC usp_mfapplicationlog @ENTRYID,'MF SB TAG GENERATED','CSO',@employee_code,@ipAddress  
		
		exec USP_MF_INHOUSE_INTEGRATION @EntryID,@ipAddress
		
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mfapplicationlog
-- --------------------------------------------------
    
CREATE proc [dbo].[usp_mfapplicationlog]    
    
(    
@entryid int ,    
    
@operation varchar(500) ,    
    
@userType varchar(20),    
    
@employee_code varchar(50) ='',    
    
@ipAddress varchar(100)=''    
    
)    
    
as    
    
begin     
    
    
    
 if(@userType = 'BDO')    
    
 begin    
    
 select @employee_code = ENTRYBY from TBL_mf_IDENTITYDETAILS where Entryid=@entryid    
    
  insert into tbl_MF_applicationlog(entryid,operation,employee_code,ipAddress)    
    
  values(@entryid,@operation,@employee_code,@ipAddress)    
    
 end    
    
 else    
    
 begin    
    
select @employee_code = ENTRYBY from TBL_mf_IDENTITYDETAILS where Entryid=@entryid    
     
  insert into tbl_MF_applicationlog(entryid,operation,employee_code,ipAddress)    
    
  values(@entryid,@operation,@employee_code,@ipAddress)    
    
 end    
    
    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_AddressDetail_Save
-- --------------------------------------------------


CREATE PROC [dbo].[USP_MFSB_AddressDetail_Save]
	@ENTRYID int=0,
	@ADDRESS1 varchar (200)='',
	@ADDRESS2 varchar (200)='',
	@ADDRESS3 varchar (200)='',
	@AREA varchar (50)='',
	@CITY varchar (50)='',
	@PIN varchar (50)='',
	@STATE varchar (50)='',
	@ISPERMANENT bit =0,
	@IsSameAsPermanent bit =0,
	@IsSameAsAadhaar bit =0,
	@operation varchar(500)='' ,
	@ipAddress varchar(100)='',
	@AadharAddress bit = 0


AS BEGIN
DECLARE @MobileNo varchar(12)
DECLARE @Email varchar(50)
DECLARE @IsValid bit = 0
DECLARE @Message varchar(50)
BEGIN TRY
SELECT @MobileNo = MobileNO, @Email = EmailID FROM TBL_MF_BASICDETAILS WITH(NOLOCK) WHERE ENTRYID = @ENTRYID

IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_ADDRESS WHERE ENTRYID=@ENTRYID AND ISPERMANENT= @ISPERMANENT)
BEGIN
		
		INSERT INTO TBL_MF_ADDRESS(ENTRYID,ADDRESS1,ADDRESS2,ADDRESS3,AREA,CITY,EMAIL,MOBILE,PIN,STATE,ISPERMANENT,AddedOn,IsSameAsPermanent,IsSameAsAadhaar)
			VALUES (@ENTRYID,@ADDRESS1,@ADDRESS2,@ADDRESS3,@AREA,@CITY,@Email,@MobileNo,@PIN,@STATE,@ISPERMANENT,GETDATE(),@IsSameAsPermanent,@IsSameAsAadhaar)
			
			-- Step Updation
			IF ISNULL(@AadharAddress, 0) = 0
			BEGIN
				IF(@ISPERMANENT = 0)
				BEGIN
					UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=3
				END
				ELSE
				BEGIN
					UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=4
				END				
			END
			
			IF ISNULL(@IsSameAsAadhaar, 0) = 0
			BEGIN
				EXEC USP_MFSB_Step_Update @EntryId, 'DOCUMENT UPLOAD', 'Document step update from IsSameAsAadhar false!', @ipAddress, 0
			END
			-- Step Updation
			SET @IsValid = 1
			SET @Message = CASE WHEN @ISPERMANENT = 1 THEN 'Permanent address successfully save!' ELSE 'Correnspondance address successfully save!' END
			
END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_MF_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
			BEGIN
			SET @IsValid = 1
			SET @Message = 'Entry is in 1,4 status!'
END
ELSE
BEGIN 

			UPDATE TBL_MF_ADDRESS 
				SET 
				ADDRESS1=@ADDRESS1  ,
				ADDRESS2=@ADDRESS2  ,
				ADDRESS3=@ADDRESS3 , 
				AREA=@AREA  ,
				CITY=@CITY  ,
				EMAIL=@EMAIL  ,
				MOBILE=@MobileNo  ,
				PIN=@PIN  ,
				STATE=@STATE , 
				modifiedOn =GETDATE(),
				IsSameAsPermanent=@IsSameAsPermanent,
				IsSameAsAadhaar=@IsSameAsAadhaar
				WHERE ENTRYID=@ENTRYID  AND ISPERMANENT=@ISPERMANENT
				
				-- Step Updation
				IF ISNULL(@AadharAddress, 0) = 0
				BEGIN
					IF(@ISPERMANENT = 0)
					BEGIN
						UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=3
					END
					ELSE
					BEGIN
						UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=4
					END
				END
				
				IF ISNULL(@IsSameAsAadhaar, 0) = 0
				BEGIN
					EXEC USP_MFSB_Step_Update @EntryId, 'DOCUMENT UPLOAD', 'Document step update from IsSameAsAadhar false!', @ipAddress, 0
				END
				-- Step Updation

				SET @IsValid = 1
				SET @Message = CASE WHEN @ISPERMANENT = 1 THEN 'Permanent address successfully updated!' ELSE 'Correnspondance address successfully updated!'

END
  
END
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,@Message,@ipAddress
	--Region for Save log
END TRY
BEGIN CATCH
       SELECT -1  AS ENTRYID, ERROR_MESSAGE() AS [MESSAGE] 
END CATCH
SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_Application_Archive
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 22nd Sept 2020
-- Description:	ARCHIVAL PROCESS FOR DELETION
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_Application_Archive]
@Input varchar(15)
AS
BEGIN
DECLARE @IsValid bit = 0
DECLARE @Message varchar(50)
DECLARE @EntryId varchar(15)

SELECT @EntryId = R.EntryID FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE Mobile = @Input OR CAST(EntryID as varchar(15)) = @Input

IF(ISNULL(@EntryId , '') = '')
BEGIN
	SELECT @EntryId = R.EntryID FROM TBL_MF_BASICDETAILS R WITH(NOLOCK) WHERE MobileNO = @Input OR CAST(EntryID as varchar(15)) = @Input
END

IF(ISNULL(@EntryId , '') <> '')
BEGIN
	INSERT INTO TBL_MFSB_Registration_Archival
	(
		RegistrationId,
		Pan,
		Mobile,
		IsARN,
		ARNName,
		DeviceId,
		ReferralTag,
		SbTag,
		Url,
		SessionKey,
		CreatedDate,
		ModifyDate,
		EntryID,
		ArchivalDate
	)
	select Id,
			Pan,
			Mobile,
			IsARN,
			ARNName,
			DeviceId,
			ReferralTag,
			SbTag,
			Url,
			SessionKey,
			CreatedDate,
			ModifyDate,
			EntryID,
			GETDATE() from TBL_MFSB_Registration WITH(NOLOCK) where ENTRYID=@EntryId
	
	INSERT INTO TBL_MF_IDENTITYDETAILS_ARCHIVAL
	(
		ENTRYID,
		DOB,
		PAN,
		ISAPPROVED,
		ENTRY_DATE,
		ENTRYBY,
		MODIFY_DATE,
		MODIFY_BY,
		APPROVE_DATE,
		APPROVE_BY,
		Remark,
		IsInhouseIntegrated,
		RefNo,
		SBTag,
		AadharVaultKey,
		U_ID,
		PANName,
		ArchivalDate
	)
	select ENTRYID,
			DOB,
			PAN,
			ISAPPROVED,
			ENTRY_DATE,
			ENTRYBY,
			MODIFY_DATE,
			MODIFY_BY,
			APPROVE_DATE,
			APPROVE_BY,
			Remark,
			IsInhouseIntegrated,
			RefNo,
			SBTag,
			AadharVaultKey,
			U_ID,
			PANName,
			GETDATE() from TBL_MF_IDENTITYDETAILS WITH(NOLOCK) where ENTRYID=@EntryId	
	
	INSERT INTO TBL_MF_BASICDETAILS_ARCHIVAL
	(
		BASICID,
		ENTRYID,
		Salutation,
		FIRSTNAME,
		MIDDLENAME,
		LASTNAME,
		MobileNO,
		EmailID,
		OrganizationType,
		TradeName,
		Photo,
		AddedOn,
		ModifiedOn,
		martialStatus,
		Gender,
		BranchTag,
		ArchivalDate
	)	
	select ID,
			ENTRYID,
			Salutation,
			FIRSTNAME,
			MIDDLENAME,
			LASTNAME,
			MobileNO,
			EmailID,
			OrganizationType,
			TradeName,
			Photo,
			AddedOn,
			ModifiedOn,
			martialStatus,
			Gender,
			BranchTag,
			GETDATE() from TBL_MF_BASICDETAILS WITH(NOLOCK) where ENTRYID=@EntryId	
	
	INSERT INTO TBL_MF_ADDRESS_ARCHIVAL
	(
		ADDRESSID,
		ENTRYID,
		ADDRESS1,
		ADDRESS2,
		ADDRESS3,
		AREA,
		CITY,
		EMAIL,
		MOBILE,
		PHONE,
		PIN,
		STATE,
		STD,
		ISPERMANENT,
		AddedOn,
		modifiedOn,
		IsSameAsAadhaar,
		IsSameAsPermanent,
		ArchivalDate
	)
	select ID,
			ENTRYID,
			ADDRESS1,
			ADDRESS2,
			ADDRESS3,
			AREA,
			CITY,
			EMAIL,
			MOBILE,
			PHONE,
			PIN,
			STATE,
			STD,
			ISPERMANENT,
			AddedOn,
			modifiedOn,
			IsSameAsAadhaar,
			IsSameAsPermanent,
			GETDATE() from TBL_MF_ADDRESS WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_BANKDETAILS_ARCHIVAL
	(
		BANKID,
		ENTRYID,
		ACCOUNTNO,
		ACCOUNTTYPE,
		ADDRESS,
		BANKNAME,
		BRANCH,
		IFSCRGTS,
		MICR,
		NAMEINBANK,
		AddedOn,
		modifiedOn,
		ArchivalDate
	)
	select ID,
			ENTRYID,
			ACCOUNTNO,
			ACCOUNTTYPE,
			ADDRESS,
			BANKNAME,
			BRANCH,
			IFSCRGTS,
			MICR,
			NAMEINBANK,
			AddedOn,
			modifiedOn,
			GETDATE() from TBL_MF_BANKDETAILS WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_NomineeDetails_Archival
	(
		NomineeID,
		EntryId,
		FirstName,
		MiddleName,
		LastName,
		DOB,
		PanNumber,
		AddressLine1,
		AddressLine2,
		AddressLine3,
		State,
		City,
		Pincode,
		RelationShip,
		GuardianFname,
		GuardianMname,
		GuardianLname,
		GuardianDOB,
		GuardianPAN,
		GuardianAddressLine1,
		GuardianAddressLine2,
		GuardianAddressLine3,
		GuardianState,
		GuardianCity,
		GuardianPincode,
		AddedOn,
		ModifiedOn,
		ArchivalDate
	)
	select ID,
			EntryId,
			FirstName,
			MiddleName,
			LastName,
			DOB,
			PanNumber,
			AddressLine1,
			AddressLine2,
			AddressLine3,
			State,
			City,
			Pincode,
			RelationShip,
			GuardianFname,
			GuardianMname,
			GuardianLname,
			GuardianDOB,
			GuardianPAN,
			GuardianAddressLine1,
			GuardianAddressLine2,
			GuardianAddressLine3,
			GuardianState,
			GuardianCity,
			GuardianPincode,
			AddedOn,
			ModifiedOn,
			GETDATE() from TBL_MF_NomineeDetails WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_ARNDetails_Archival
	(
		ARNID,
		EntryID,
		IsARN,
		ARN_Number,
		FirstName,
		MiddleName,
		LastName,
		UploadFiles,
		Exam_tentative_FromDate,
		Exam_tentative_ToDate,
		AddedOn,
		ModifiedOn,
		ARN_FromDate,
		ARN_ToDate,
		EUINumber,
		ArchivalDate
	)	
	select ID,
			EntryID,
			IsARN,
			ARN_Number,
			FirstName,
			MiddleName,
			LastName,
			UploadFiles,
			Exam_tentative_FromDate,
			Exam_tentative_ToDate,
			AddedOn,
			ModifiedOn,
			ARN_FromDate,
			ARN_ToDate,
			EUINumber,
			GETDATE() from TBL_MF_ARNDETAILS WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_PaymentDetails_Archival
	(
		PaymentId,
		EntryID,
		Amount,
		Instrument_No,
		DATE,
		PaymentMode,
		AddedOn,
		ModifiedOn,
		ArchivalDate
	)	
	select Id,
			EntryID,
			Amount,
			Instrument_No,
			DATE,
			PaymentMode,
			AddedOn,
			ModifiedOn,
			GETDATE() from TBL_MF_PaymentDetails WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_DOCUMENTSUPLOAD_ARCHIVAL
	(
		DocumentID,
		ENTRYID,
		FILENAME,
		PATH,
		ISDELETE,
		DOCTYPE,
		EXCHANGE,
		AddedOn,
		modifiedOn,
		ArchivalDate
	)
	select ID,
			ENTRYID,
			FILENAME,
			PATH,
			ISDELETE,
			DOCTYPE,
			EXCHANGE,
			AddedOn,
			modifiedOn,
			GETDATE() from TBL_MF_DOCUMENTSUPLOAD WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_DOCUMENTSUPLOAD_PDF_ARCHIVAL
	(
		DocumentID,
		ENTRYID,
		FILENAME,
		PATH,
		ISDELETE,
		DOCTYPE,
		EXCHANGE,
		AddedOn,
		modifiedOn,
		ArchivalDate
	)	
	select ID,
			ENTRYID,
			FILENAME,
			PATH,
			ISDELETE,
			DOCTYPE,
			EXCHANGE,
			AddedOn,
			modifiedOn,
			GETDATE() from TBL_MF_DOCUMENTSUPLOAD_PDF WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_INFRASTRUCTURE_ARCHIVAL
	(
		INFRASTRUCTUREID,
		ENTRYID,
		MAINOFFICE,
		INCOMERANGE,
		OFFICEFRONTFACING,
		OFFICEGROUNDFLOOR,
		SOCIALNETWORKING,
		AddedOn,
		modifiedOn,
		ArchivalDate
	)
	select ID,
			ENTRYID,
			MAINOFFICE,
			INCOMERANGE,
			OFFICEFRONTFACING,
			OFFICEGROUNDFLOOR,
			SOCIALNETWORKING,
			AddedOn,
			modifiedOn,
			GETDATE() from TBL_MF_INFRASTRUCTURE WITH(NOLOCK) where ENTRYID=@EntryId	
		
	INSERT INTO TBL_MF_ESIGNDOCUMENTS_ARCHIVAL
	(
		ESIGNDOCUMENTSID,
		ENTRYID,
		FILENAME,
		PATH,
		ISDELETE,
		DOCTYPE,
		EXCHANGE,
		SOURCE,
		isEsign,
		rm,
		sourceid,
		Addedon,
		addedby,
		Modifiedon,
		modifiedby,
		NewFileName,
		ESIGNNAME,
		ESIGNNAMECSO,
		ArchivalDate
	)
	select ID,
			ENTRYID,
			FILENAME,
			PATH,
			ISDELETE,
			DOCTYPE,
			EXCHANGE,
			SOURCE,
			isEsign,
			rm,
			sourceid,
			Addedon,
			addedby,
			Modifiedon,
			modifiedby,
			NewFileName,
			ESIGNNAME,
			ESIGNNAMECSO,
			GETDATE() from TBL_MF_ESIGNDOCUMENTS WITH(NOLOCK) where ENTRYID=@EntryId
	
	INSERT INTO tbl_sbapplicationlog_archival
	(
		sbapplicationlogid,
		entryid,
		operation,
		time,
		employee_code,
		ipAddress,
		archivaldate
	)
	select id,
			entryid,
			operation,
			time,
			employee_code,
			ipAddress,
			GETDATE() from tbl_sbapplicationlog WITH(NOLOCK) where ENTRYID=@EntryId
	
	INSERT INTO tbl_MF_sbapplicationlog_archival
	(
		sbapplicationlogid,
		entryid,
		operation,
		time,
		employee_code,
		ipAddress,
		archivaldate
	)
	select id,
			entryid,
			operation,
			time,
			employee_code,
			ipAddress,
			GETDATE() from tbl_MF_sbapplicationlog WITH(NOLOCK) where ENTRYID=@EntryId	
		
	DELETE from TBL_MFSB_Registration where ENTRYID=@EntryId
	DELETE from TBL_MF_IDENTITYDETAILS where ENTRYID=@EntryId
	DELETE from TBL_MF_BASICDETAILS where ENTRYID=@EntryId
	DELETE from TBL_MF_ADDRESS where ENTRYID=@EntryId
	DELETE from TBL_MF_BANKDETAILS where ENTRYID=@EntryId
	DELETE from TBL_MF_NomineeDetails where ENTRYID=@EntryId
	DELETE from TBL_MF_ARNDETAILS where ENTRYID=@EntryId
	DELETE from TBL_MF_PaymentDetails where ENTRYID=@EntryId
	DELETE from TBL_MF_DOCUMENTSUPLOAD where ENTRYID=@EntryId
	DELETE from TBL_MF_DOCUMENTSUPLOAD_PDF where ENTRYID=@EntryId
	DELETE from TBL_MF_INFRASTRUCTURE where ENTRYID=@EntryId
	DELETE from TBL_MF_ESIGNDOCUMENTS where ENTRYID=@EntryId
	DELETE from tbl_sbapplicationlog where ENTRYID=@EntryId
	DELETE from tbl_MF_sbapplicationlog where ENTRYID=@EntryId	
	
	SET @IsValid = 1
	SET @Message = 'Record successfully deleted for entryId : ' + @EntryId + '!'
END	
ELSE
BEGIN
	SET @IsValid = 0
	SET @Message = 'Record not found!'
END

		
	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Delete application',@Message,''
	--Region for Save log
	
SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ApplicationDetail_Get
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 15th Sept 2020
-- Description:	<Get all data>
-- =============================================


--EXEC USP_MFSB_ApplicationDetail_Get '20148','1233'
CREATE PROCEDURE [dbo].[USP_MFSB_ApplicationDetail_Get]
@EntryId VARCHAR(50)='',  
@IPAddress VARCHAR(50)=''
AS  
BEGIN  

SELECT B.ID,
B.ENTRYID 'entryId',
B.Salutation,
B.FIRSTNAME 'firstName',
B.MIDDLENAME 'middleName',
B.LASTNAME 'lastName',
B.MobileNO 'mobile',
B.EmailID 'emailId',
B.OrganizationType 'organizationType',
B.TradeName 'tradeName',
B.Photo,
B.AddedOn,
B.ModifiedOn,
B.martialStatus 'maritalStatus',
B.Gender 'gender',
BranchTag 'branchTag',
I.DOB 'dob',
ISNULL(I.IsAadhaar, 0) 'isAadhar'  FROM TBL_MF_BASICDETAILS B With(Nolock) 
INNER JOIN TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) ON I.ENTRYID = B.ENTRYID
WHERE B.ENTRYID=CAST(@EntryId AS INT)    

SELECT B.ID,
B.ENTRYID 'entryID',
B.ACCOUNTNO 'accountNo',
ACCOUNTTYPE 'accountType',
ADDRESS 'address',
BANKNAME 'bankName',
BRANCH 'branch',
IFSCRGTS 'ifscRgts',
MICR 'micr',
NAMEINBANK 'nameInBank',
ISNULL(I.IsImps, 0) 'isImps',
ISNULL(I.BeneficiaryName, '') 'beneficiaryName',
AddedOn,
modifiedOn FROM TBL_MF_BANKDETAILS B
LEFT JOIN tbl_MFSB_ImpsDetail I ON I.EntryId = B.ENTRYID
WHERE B.ENTRYID=CAST(@EntryId AS INT)    

SELECT ID,
ENTRYID 'entryID',
ADDRESS1 'address1',
ADDRESS2 'address2',
ADDRESS3 'address3',
AREA 'area',
CITY 'city',
EMAIL,
MOBILE,
PHONE,
IsSameAsAadhaar,
IsSameAsPermanent,
PIN 'pin',
STATE 'state',
STD,
ISPERMANENT 'isPermanent',
AddedOn,
modifiedOn FROM TBL_MF_ADDRESS WHERE ENTRYID=@EntryId        

SELECT ID 'id',
ENTRYID 'entryId',
FILENAME 'fileName',
PATH 'path',
ISDELETE,
DOCTYPE 'docType',
EXCHANGE 'exchange',
AddedOn,
modifiedOn FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@EntryId AND ISDELETE =0 and PATH not like 'FTP://%'       

SELECT
EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,EUINumber 'euiNo',
CASE Exam_tentative_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_FromDate, 120),1,10) End As 'Exam_tentative_FromDate',  
CASE Exam_tentative_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_ToDate, 120),1,10)  End As 'Exam_tentative_ToDate',  
CASE ARN_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE CAST(ARN_FromDate as varchar(15))  End As 'ARN_FromDate',  
CASE ARN_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE CAST(ARN_ToDate as varchar(15))  End As 'ARN_ToDate'  
from tbl_MF_ARNDETAILS  
WHERE ENTRYID=@EntryId   
  
SELECT ID,
EntryId 'entryID',
FirstName 'FirstName',
MiddleName 'MiddleName',
LastName 'LastName',
DOB 'dob',
PanNumber 'PanNumber',
AddressLine1,
AddressLine2,
AddressLine3,
State,
City,
Pincode,
RelationShip 'RelationShip',
GuardianFname,
GuardianMname,
GuardianLname,
GuardianDOB,
GuardianPAN,
GuardianAddressLine1,
GuardianAddressLine2,
GuardianAddressLine3,
GuardianState,
GuardianCity,
GuardianPincode,
AddedOn,
ModifiedOn FROM TBL_MF_NomineeDetails WHERE ENTRYID=@EntryId   
SELECT 
TOP 1 EntryId 'entryId',
StepId 'stepId',
CASE WHEN (SELECT TOP 1 ISAPPROVED FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE ENTRYID = @EntryId) = 2 THEN 0 ELSE Status END 'status',
SM.StepName 'activeStatusName',
SD.InsertedDate 'insertedDate',
UpdationDate 'updationDate'
FROM TBL_MFSB_StepDetail SD WITH(NOLOCK) 
INNER JOIN TBL_MFSB_StepMaster SM WITH(NOLOCK) ON SM.Id = SD.StepId
WHERE SD.EntryId = @EntryId AND Status=1 ORDER BY SM.OrderBy DESC

SELECT StepName,
CASE WHEN (SELECT TOP 1 ISAPPROVED FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE ENTRYID = @EntryId) = 2 THEN 0 ELSE Status END 'Status',
SM.OrderBy 
FROM TBL_MFSB_StepDetail SD WITH(NOLOCK) 
INNER JOIN TBL_MFSB_StepMaster SM WITH(NOLOCK) ON SM.Id = SD.StepId
WHERE EntryId = @EntryId order by OrderBy

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Get data','Data fetch for MFSB',@IPAddress
	--Region for Save log
	
--UPDATE  TBL_SENDREQUEST  
--SET flag=1  
-- WHERE USERID=@EntryId  
SELECT 1   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ApplicationLog_Save
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar Ghule
-- Create date: 08th Sept 2020
-- Description:	Maintain Log
-- =============================================    
CREATE proc [dbo].[USP_MFSB_ApplicationLog_Save]    
@entryid int ,        
@operation varchar(500) ,  
@message varchar(500),           
@ipAddress varchar(100)=''        
as        
begin          
	insert into TBL_MFSB_Applicationlog(entryid,operation,message,ipAddress,time)        
	values(@entryid,@operation,@message,@ipAddress,GETDATE())               
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ArnDetail_Get
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 01st Oct 2020
-- Description:	<Get arn data>
-- =============================================


--EXEC USP_MFSB_DocumentDetail_Get '20071','1233'
CREATE PROCEDURE [dbo].[USP_MFSB_ArnDetail_Get]
@EntryId VARCHAR(50)='',  
@IPAddress VARCHAR(50)=''
AS  
BEGIN  

SELECT 
IsARN 'ISARN',
ARN_Number 'ARN_Number',
FirstName 'FirstName',
MiddleName 'MiddleName',
LastName 'LastName',
CASE Exam_tentative_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_FromDate, 120),1,10) End As 'Exam_tentative_FromDate',  
CASE Exam_tentative_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE SUBSTRING(convert(varchar, Exam_tentative_ToDate, 120),1,10)  End As 'Exam_tentative_ToDate',  
CASE ARN_FromDate  
        WHEN '1900-01-01' THEN null  
        ELSE CAST(ARN_FromDate as varchar(15))  End As 'ARN_FromDate',  
CASE ARN_ToDate  
        WHEN '1900-01-01' THEN null  
        ELSE CAST(ARN_ToDate as varchar(15))  End As 'ARN_ToDate',
EUINumber 'euiNo' FROM TBL_MF_ARNDetails WHERE ENTRYID=@EntryId 

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Get Arn data','ARN detail for MFSB',@IPAddress
	--Region for Save log
	
--UPDATE  TBL_SENDREQUEST  
--SET flag=1  
-- WHERE USERID=@EntryId  
SELECT 1   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ARNDetails_Save
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar G
-- Create date: 04TH Sept 2020
-- Description:	<Save and Update arn Details>
-- =============================================

CREATE PROCEDURE [dbo].[USP_MFSB_ARNDetails_Save] 
@EntryID INT =0 ,
@IsARN bit =0,
@ARN_Number VARCHAR(200)='',
@EUI_Number VARCHAR(200)='',
@FirstName VARCHAR(100)='',
@MiddleName VARCHAR(100)='',
@LastName VARCHAR(100)='',
@UploadFiles  VARCHAR(max)='',
@ARN_FromDate VARCHAR(100)='',
@ARN_ToDate VARCHAR(100)='',

@Exam_tentative_FromDate VARCHAR(100)='',
@Exam_tentative_ToDate VARCHAR(100)='',
@operation varchar(500)='' ,
@ipAddress varchar(100)='',
@IsServiceRequest bit = 0
AS
BEGIN

	DECLARE @IsValid bit = 0
	DECLARE @Message varchar(50)	

    If (@IsARN = 1)
		begin
		set @Exam_tentative_FromDate = null;
		set @Exam_tentative_ToDate = null;
		End
	else
		begin
		set @ARN_FromDate = null;
		set @ARN_ToDate = null;
		End
	



	IF NOT EXISTS(SELECT 1 FROM TBL_MF_ARNDETAILS WHERE EntryID=@EntryID)
	BEGIN
		INSERT INTO TBL_MF_ARNDETAILS(EntryID,IsARN,ARN_Number,FirstName,MiddleName,LastName,UploadFiles,Exam_tentative_FromDate,
										Exam_tentative_ToDate,AddedOn,ARN_FromDate,ARN_ToDate,EUINumber) 
		VALUES(@EntryID,@IsARN,@ARN_Number,@FirstName,@MiddleName,@LastName,@UploadFiles,
		ISNULL(@Exam_tentative_FromDate, null),
		ISNULL(@Exam_tentative_ToDate, null),		
		GETDATE(),
		--CAST(@ARN_FromDate AS DATETIME),
		--CAST(@ARN_ToDate AS DATETIME)
		ISNULL(@ARN_FromDate, null),
		ISNULL(@ARN_ToDate, null),
		ISNULL(@EUI_Number,null)
		)
		
		-- Step Updation
		IF(ISNULL(@IsServiceRequest,0) = 0)
		BEGIN
			UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=7
		END		
		-- Step Updation

								
		SET @IsValid = 1
		SET @Message = 'Arn details successfully save!' 
	END
	ELSE
	BEGIN
		UPDATE TBL_MF_ARNDETAILS SET IsARN=@IsARN,
								ARN_Number=@ARN_Number,
								FirstName=@FirstName,
								MiddleName=@MiddleName,
								LastName=@LastName,
								UploadFiles=@UploadFiles,
								--ARN_From_Date=CAST(@ARN_From_Date AS DATETIME),
								--ARN_To_Date=CAST(@ARN_To_Date AS DATETIME),
								Exam_tentative_FromDate=CAST(@Exam_tentative_FromDate AS DATETIME),
								Exam_tentative_ToDate=CAST(@Exam_tentative_ToDate AS DATETIME),
								ModifiedON=GETDATE(),
								ARN_FromDate=CONVERT(VarChar(50), @ARN_FromDate, 101),
								ARN_ToDate=CONVERT(VarChar(50), @ARN_ToDate, 101),
								EUINumber=@EUI_Number
								WHERE EntryID=@EntryID --AND ARN_Number=@ARN_Number
								
		-- Step Updation
		UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=7
		-- Step Updation
	
		SET @IsValid = 1
		SET @Message = 'Arn details successfully updated!'  								
	END
	
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,@operation,@Message,@ipAddress
	--Region for Save log
	SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_BankDetail_Save
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 02nd Sept 2020
-- Description:	<Save and Update BANK Details>
-- =============================================

CREATE PROC [dbo].[USP_MFSB_BankDetail_Save]
@ENTRYID  INT=0,
@ACCOUNTNO VARCHAR(50)='',
@ACCOUNTTYPE VARCHAR(10)='',
@ADDRESS VARCHAR(500)='',
@BANKNAME VARCHAR(100)='',
@BRANCH VARCHAR(50)='',
@IFSCRGTS VARCHAR(50)='',
@MICR VARCHAR(50)='',
@NAMEINBANK VARCHAR(100)='',
@operation varchar(500)='',
@ipAddress varchar(100)=''
AS BEGIN

BEGIN TRY
DECLARE @IsValid bit = 0, @IsImps bit = 0
DECLARE @Message varchar(50)
IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_BANKDETAILS WHERE ENTRYID=@ENTRYID)
BEGIN
		INSERT INTO TBL_MF_BANKDETAILS(ENTRYID,ACCOUNTNO,ACCOUNTTYPE,[ADDRESS],BANKNAME,BRANCH,IFSCRGTS,MICR,NAMEINBANK,AddedOn)
		VALUES (@ENTRYID,@ACCOUNTNO,@ACCOUNTTYPE,@ADDRESS,@BANKNAME,@BRANCH,@IFSCRGTS,@MICR,@NAMEINBANK,GETDATE())
		
		-- Step Updation
		UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=6
		-- Step Updation
		
		SELECT @IsImps = ISNULL(@IsImps, 0) FROM tbl_MFSB_ImpsDetail I WITH(NOLOCK) WHERE I.EntryId = @ENTRYID
		
		IF ISNULL(@IsImps, 0) = 0
		BEGIN
			EXEC USP_MFSB_Step_Update @EntryId,'DOCUMENT UPLOAD','Document step update from IPMS false!',@ipAddress,0
		END

		SET @IsValid = 1
		SET @Message = 'Bank details successfully save!' 

END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SET @IsValid = 1
			SET @Message = 'Entry is in 1,4 status!!'  

END
ELSE
BEGIN 
		
        UPDATE TBL_MF_BANKDETAILS 
				SET 
				ACCOUNTNO=@ACCOUNTNO  ,
				ACCOUNTTYPE=@ACCOUNTTYPE  ,
				[ADDRESS]=@ADDRESS , 
				BANKNAME=@BANKNAME  ,
				BRANCH=@BRANCH  ,
				IFSCRGTS=@IFSCRGTS  ,
				MICR =@MICR  ,
				NAMEINBANK=@NAMEINBANK  ,
				modifiedOn= GETDATE()
				WHERE ENTRYID=@ENTRYID 
				
				-- Step Updation
				UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=6
				-- Step Updation
				
				SELECT @IsImps = ISNULL(@IsImps, 0) FROM tbl_MFSB_ImpsDetail I WITH(NOLOCK) WHERE I.EntryId = @ENTRYID
				
				IF ISNULL(@IsImps, 0) = 0
				BEGIN
					EXEC USP_MFSB_Step_Update @EntryId,'DOCUMENT UPLOAD','Document step update from IPMS false!',@ipAddress,0
				END

				SET @IsValid = 1
				SET @Message = 'Bank details successfully updated!' 
END
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,@Message,@ipAddress
	--Region for Save log

END TRY
		BEGIN CATCH
		         SET @IsValid = 0
				 SET @Message = 'Fail!' 
		END CATCH
END

SELECT @IsValid 'IsValid', @Message 'Message'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_Basic_AddressDetail_Get
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 26th Nov 2020
-- Description:	<Get address data>
-- =============================================


--EXEC USP_MFSB_Basic_AddressDetail_Get '20180','1233'
create PROCEDURE [dbo].[USP_MFSB_Basic_AddressDetail_Get]
@EntryId VARCHAR(50)='',  
@IPAddress VARCHAR(50)=''
AS  
BEGIN  

SELECT B.ID,
B.ENTRYID 'entryId',
B.Salutation,
B.FIRSTNAME 'firstName',
B.MIDDLENAME 'middleName',
B.LASTNAME 'lastName',
B.MobileNO 'mobile',
B.EmailID 'emailId',
B.OrganizationType 'organizationType',
B.TradeName 'tradeName',
B.Photo,
B.AddedOn,
B.ModifiedOn,
B.martialStatus 'maritalStatus',
B.Gender 'gender',
BranchTag 'branchTag',
I.DOB 'dob',
ISNULL(I.IsAadhaar, 0) 'isAadhar'  FROM TBL_MF_BASICDETAILS B With(Nolock) 
INNER JOIN TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) ON I.ENTRYID = B.ENTRYID
WHERE B.ENTRYID=CAST(@EntryId AS INT)  

SELECT ID,
ENTRYID 'entryID',
ADDRESS1 'address1',
ADDRESS2 'address2',
ADDRESS3 'address3',
AREA 'area',
CITY 'city',
EMAIL,
MOBILE,
PHONE,
IsSameAsAadhaar,
IsSameAsPermanent,
PIN 'pin',
STATE 'state',
STD,
ISPERMANENT 'isPermanent',
AddedOn,
modifiedOn FROM TBL_MF_ADDRESS WHERE ENTRYID=@EntryId        

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Get data','Address detail fetch for MFSB',@IPAddress
	--Region for Save log
	
--UPDATE  TBL_SENDREQUEST  
--SET flag=1  
-- WHERE USERID=@EntryId  
SELECT 1   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_BasicDetail_Save
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 31st Aug 2020
-- Description:	Save basic details
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_BasicDetail_Save]
	@ENTRYID INT=0,
	@DOB VARCHAR(50)='',
	@BranchTag varchar(20)='',
	@EmailID varchar(200)='',
	@MobileNO VARCHAR(20)='',
	@OrganizationType varchar(500)='',  
	@FIRSTNAME  AS VARCHAR(100)='',  
	@LASTNAME  AS VARCHAR(100)='',  
	@MIDDLENAME  AS VARCHAR(100)='',
	@TRADENAME  AS VARCHAR(100)='',
	@maritalStatus varchar(50) ='',  
	@gender varchar(50) ='',
	@ENTRY_BY VARCHAR(50)='MFSB',
	@SBTag VARCHAR(50)='',
	@operation varchar(500)='' ,
	@userType varchar(20)='',
	@employee_code varchar(50) ='',
	@ipAddress varchar(100)=''	  		
AS
BEGIN

declare @EmployeeCode varchar(50)=''
DECLARE @Msg varchar(50),@IsSucces bit = 0
-- Added by aslam on 12 June 2019
--SET @ENTRY_BY  = (select distinct emp_no from  [RISK].[dbo].[emp_info] where email like @ENTRY_BY + '@angelbroking.com' and Status = 'A')
--SET @EmployeeCode  = (select distinct emp_no from  [RISK].[dbo].[emp_info] where email like @ENTRY_BY + '@angelbroking.com' and Status = 'A')
-- Added by Shekhar on 14thJan 2020
--if ISNULL(@EmployeeCode,'') = ''
--begin
--	SET @ENTRY_BY  = (select distinct Emp_no from [172.31.12.73].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) Where Email_Add like @ENTRY_BY + '@angelbroking.com')
--end
--else
--begin
--	SET @ENTRY_BY=@EmployeeCode
--end

		IF(ISNULL(@TRADENAME, '') = '')
		BEGIN
			SELECT TOP 1 @TRADENAME=PANName FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE I.ENTRYID = @ENTRYID	
		END
		IF(ISNULL(@OrganizationType, '') = '')
		BEGIN
			SET @OrganizationType = 'Individual'
		END
		
		IF EXISTS(SELECT 1 FROM TBL_MF_IDENTITYDETAILS I WITH(NOLOCK) WHERE I.ENTRYID = @ENTRYID)
		BEGIN
			UPDATE TBL_MF_IDENTITYDETAILS
			SET 
			DOB = @DOB
			WHERE  ENTRYID=@ENTRYID	
			SET @IsSucces = 1
			SET @Msg = 'Record successfully updated!'		
		END
		ELSE
		BEGIN
			DECLARE @PanNo varchar(12)
			DECLARE @PanName varchar(100)
			SELECT TOP 1 @PanNo = R.Pan FROM TBL_MFSB_Registration R WITH(NOLOCK) WHERE R.EntryID = @ENTRYID
			INSERT INTO TBL_MF_IDENTITYDETAILS
			(
				PAN,
				ENTRY_DATE,
				ISAPPROVED
			)
			VALUES
			(
				@PanNo,
				GETDATE(),
				0
			)
			SET @IsSucces = 1
			SET @Msg = 'Record successfully save!'
		END	
		IF EXISTS(SELECT 1 FROM TBL_MF_BASICDETAILS B WITH(NOLOCK) WHERE B.ENTRYID = @ENTRYID)
		BEGIN
			UPDATE TBL_MF_BASICDETAILS   
			SET    
			FIRSTNAME=@FIRSTNAME  ,  
			LASTNAME=@LASTNAME  ,  
			MIDDLENAME=@MIDDLENAME  ,  
			MobileNO=@MobileNO,  
			EmailID=@EmailID,  
			--OrganizationType=@OrganizationType,   
			--TRADENAME=@TRADENAME  ,  
			modifiedOn =GETDATE(),  
			martialStatus = @maritalStatus,
			gender=@gender
			--BranchTag =@BranchTag

			WHERE ENTRYID=@ENTRYID
			
			-- Step Updation
			UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=2
			-- Step Updation
			
			SET @IsSucces = 1
			SET @Msg = 'Record successfully updated!'
						
		END
		ELSE
		BEGIN

			INSERT INTO TBL_MF_BASICDETAILS(ENTRYID,FIRSTNAME,LASTNAME,MIDDLENAME,MobileNO,EmailID,OrganizationType,TRADENAME,AddedOn,martialStatus,gender,BranchTag)  
			VALUES (@ENTRYID,@FIRSTNAME,@LASTNAME,@MIDDLENAME,@MobileNO ,@EmailID,@OrganizationType,@TRADENAME,GETDATE(),@maritalStatus,@gender,@BranchTag)  
			
			-- Step Updation
			UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=2
			-- Step Updation
			
			SET @IsSucces = 1
			SET @Msg = 'Record successfully save!'
		END

--SET @employee_code = 'MFSB'
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 		

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,@Msg,@ipAddress
	--Region for Save log

SELECT @Msg 'Message',@IsSucces 'IsValid'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_DocumentDetail_Get
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 24th Sept 2020
-- Description:	<Get document data>
-- =============================================


--EXEC USP_MFSB_DocumentDetail_Get '20071','1233'
CREATE PROCEDURE [dbo].[USP_MFSB_DocumentDetail_Get]
@EntryId VARCHAR(50)='',  
@IPAddress VARCHAR(50)=''
AS  
BEGIN  

SELECT ID 'id',
ENTRYID 'entryId',
FILENAME 'fileName',
PATH 'path',
ISDELETE,
DOCTYPE 'docType',
EXCHANGE 'exchange'
FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@EntryId AND ISDELETE =0 and PATH not like 'FTP://%'       

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Get document data','Document fetch for MFSB',@IPAddress
	--Region for Save log
	
--UPDATE  TBL_SENDREQUEST  
--SET flag=1  
-- WHERE USERID=@EntryId  
SELECT 1   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_DocumentRemove_Delete
-- --------------------------------------------------

-- =============================================
-- Author:		Shekhar G
-- Create date: 16TH Sept 2020
-- Description:	<REMOVE DOCUMENT>
-- =============================================

CREATE PROCEDURE [dbo].[USP_MFSB_DocumentRemove_Delete] 
@EntryID INT =0 ,
@Id int =0,
@DocType VARCHAR(200)='',
@operation varchar(500)='' ,
@ipAddress varchar(100)=''
AS
BEGIN

	DECLARE @IsValid bit = 0
	DECLARE @Message varchar(50)	
	
	IF EXISTS(SELECT 1 FROM TBL_MF_DOCUMENTSUPLOAD WHERE ID = @Id and EntryID=@EntryID and DOCTYPE = @DocType)
	BEGIN
		
		UPDATE TBL_MF_DOCUMENTSUPLOAD SET ISDELETE = 1 WHERE ID = @Id and EntryID=@EntryID and DOCTYPE = @DocType
		--UPDATE TBL_MF_DOCUMENTSUPLOAD_PDF SET ISDELETE = 1 WHERE ID = @Id and EntryID=@EntryID and DOCTYPE = @DocType
		
		UPDATE TBL_MFSB_StepDetail SET Status = 0, UpdationDate = GETDATE()
		WHERE EntryId  = @EntryID AND StepId = 8
				
		SET @IsValid = 1
		SET @Message = 'Document successfully deleted!' 
	END
	ELSE
	BEGIN
		
		SET @IsValid = 0
		SET @Message = 'Document not found!'  								
	END	
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,@operation,@Message,@ipAddress
	--Region for Save log
	SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_DocumentUpload_Save
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 07th Sept 2020
-- Description:	replica of existing USP_MFSB_DOCUMENTSUPLOAD
-- =============================================

CREATE PROC [dbo].[USP_MFSB_DocumentUpload_Save]
@PROCESS AS VARCHAR(50)='',
@ID AS INT=0,
@ENTRYID INT =0,
@FILENAME AS VARCHAR(100)='',
@PATH AS VARCHAR(200)='',
@ISDELETE AS INT=0,
@DOCTYPE AS VARCHAR(50)='',
@EXCHANGE AS VARCHAR(50)='',
@operation varchar(500)='',
@ipAddress varchar(100)='',
@Photo VARCHAR(MAX)=''
AS BEGIN

BEGIN TRY

   IF @PROCESS ='DELETE'
	BEGIN
	
	        UPDATE TBL_MF_DOCUMENTSUPLOAD
			SET ISDELETE=1 ,modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]

			UPDATE A
			SET A.ISDELETE =1
			FROM  TBL_MF_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND ID =@ID)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE

	END

	 IF @PROCESS ='DELETE PDF'
	BEGIN
	        UPDATE tbl_MF_DOCUMENTSUPLOAD_PDF
			SET ISDELETE=1 ,modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			SELECT @ENTRYID  AS ENTRYID, 'FILE DELETEED SUCCESSFULLY.' AS [MESSAGE]
	END

	IF @PROCESS='ADD'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN


	IF @EXCHANGE= 'Individual'
	BEGIN

	DELETE FROM tbl_MF_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Proprietor' AND ENTRYID=@ENTRYID

	END

	ELSE IF(@EXCHANGE= 'Proprietor')
	BEGIN

	DELETE FROM tbl_MF_DOCUMENTSUPLOAD
	WHERE EXCHANGE= 'Individual' AND ENTRYID=@ENTRYID

	END

	--added on 24 Oct 2018 by aslam
	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END 

	INSERT INTO tbl_MF_DOCUMENTSUPLOAD
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE,GETDATE(),NULL

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	END
	ELSE
	BEGIN


	        DECLARE @IDS AS INT =0

			SELECT @IDS =ID FROM tbl_MF_DOCUMENTSUPLOAD 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

	        UPDATE tbl_MF_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
			modifiedOn =GETDATE()
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			--added on 24 Oct 2018 by aslam
			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END

	END


	IF @PROCESS='ADD PDF'
	BEGIN
	IF NOT EXISTS (SELECT ENTRYID FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE)
	BEGIN

	IF (@DOCTYPE = 'Photo')
	BEGIN
		UPDATE TBL_MF_BASICDETAILS   
		SET   
			Photo=@Photo 
		WHERE ENTRYID=@ENTRYID   
	END

	INSERT INTO TBL_MF_DOCUMENTSUPLOAD_PDF
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE,GETDATE(),NULL
	
	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 

	END
	ELSE
	BEGIN
	SELECT @IDS =ID FROM TBL_MF_DOCUMENTSUPLOAD_PDF 
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

	        UPDATE TBL_MF_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
			modifiedOn =GETDATE()
			WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND  ISDELETE=0 and DOCTYPE = @DOCTYPE

			SELECT @IDS AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE ,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END
	END



	IF @PROCESS='UPDATE'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_MF_DOCUMENTSUPLOAD
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
		    modifiedOn =GETDATE()
		    
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END   

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


		IF @PROCESS='UPDATE PDF'
	BEGIN

	IF NOT EXISTS (SELECT ENTRYID FROM tbl_MF_DOCUMENTSUPLOAD_PDF WHERE [FILENAME]=@FILENAME AND ENTRYID=@ENTRYID AND DOCTYPE = @DOCTYPE AND  ISDELETE=0 AND ID <> @ID)
	BEGIN
			UPDATE tbl_MF_DOCUMENTSUPLOAD_PDF
			SET [FILENAME]=@FILENAME,
			[PATH]=@PATH,
			DOCTYPE=@DOCTYPE,
			EXCHANGE=@EXCHANGE,
		    modifiedOn =GETDATE()
			WHERE ENTRYID=@ENTRYID AND ID=@ID

			IF (@DOCTYPE = 'Photo')
			BEGIN
				UPDATE TBL_MF_BASICDETAILS   
				SET   
					Photo=@Photo 
				WHERE ENTRYID=@ENTRYID   
			END

			SELECT @ID AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE 
	END
	ELSE 
	BEGIN
	        SELECT 0  AS ENTRYID, 'SAME FILE ALREADY EXIST' AS [MESSAGE]
	END

	

	

	END


	IF @PROCESS='GET PDF FILE'
	BEGIN
	SELECT * FROM (SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND DOCTYPE NOT IN ('AFFIDAVIT','MOU') ) A
			WHERE A.DOCTYPE NOT LIKE '%AGREEMENT'

	END


	IF @PROCESS='GET AFTER ESIGN PDF FILE'
	BEGIN
	--SELECT * FROM TBL_MF_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@ENTRYID  AND ISDELETE=0 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )

	        SELECT * 
            FROM  TBL_MF_DOCUMENTSUPLOAD_PDF A JOIN 
			(SELECT DOCTYPE,SUBSTRING( FILENAME,1,CHARINDEX('.',FILENAME)-1 )+'.PDF' AS FILENAME FROM TBL_MF_DOCUMENTSUPLOAD WHERE ENTRYID=@ENTRYID AND (DOCTYPE IN ('AFFIDAVIT','MOU') OR DOCTYPE LIKE '%AGREEMENT' ) AND ISDELETE =0)B
			ON A.FILENAME=B.FILENAME AND A.DOCTYPE=B.DOCTYPE
			WHERE A.ISDELETE =0 and A.ENTRYID=@ENTRYID
	END


    IF @PROCESS='ADD COMBINE FILE'
	BEGIN

	UPDATE TBL_MF_DOCUMENTSUPLOADFINAL_PDF
	SET ISDELETE=1
	WHERE ENTRYID =@ENTRYID AND DOCTYPE=@DOCTYPE

	INSERT INTO TBL_MF_DOCUMENTSUPLOADFINAL_PDF
	SELECT @ENTRYID, @FILENAME,@PATH,0,@DOCTYPE,@EXCHANGE

	SELECT SCOPE_IDENTITY() AS ID,@FILENAME AS [FILENAME],@PATH AS [PATH],@DOCTYPE AS DOCTYPE, @ENTRYID  AS ENTRYID,@EXCHANGE AS EXCHANGE,'FILE UPLOAD SUCCESFULLY' AS [MESSAGE] 
	END

--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 
	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,'',@ipAddress
	--Region for Save log

END TRY

		BEGIN CATCH

		SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_Employeed_Assign
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 25st Sept 2020
-- Description:	Auto assign process
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_Employeed_Assign]
@EntryID bigint	= 0
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM TBL_MFSB_AssignedEmployeeDetail D WITH(NOLOCK) WHERE CAST(D.AssignedDate AS DATE) = CAST(GETDATE() AS DATE))
	BEGIN
	DECLARE @EmployeeCode VARCHAR(15)
		INSERT INTO TBL_MFSB_AssignedEmployeeDetail
		(
			EmployeeCode,
			AssignedDate,
			LastAssignedDate,
			ApplicationCount
		)
		SELECT EmployeeCode,
		GETDATE(),
		NULL,
		0 FROM TBL_MFSB_AssignedEmployeeMst M WITH(NOLOCK) WHERE ISNULL(IsActive, 0) = 1
	END
	
	IF(@EntryID > 0)
	BEGIN
		SELECT TOP 1 @EmployeeCode=D.EmployeeCode FROM TBL_MFSB_AssignedEmployeeDetail D WITH(NOLOCK)
		WHERE CAST(D.AssignedDate AS DATE) = CAST(GETDATE() AS DATE)
		ORDER BY ApplicationCount
		
		IF(ISNULL(@EmployeeCode, '') <> '')
		BEGIN
			UPDATE TBL_MF_IDENTITYDETAILS SET ENTRYBY = @EmployeeCode WHERE ENTRYID = @EntryID
			UPDATE TBL_MFSB_AssignedEmployeeDetail SET ApplicationCount = ApplicationCount + 1,LastAssignedDate = GETDATE() WHERE EmployeeCode = @EmployeeCode and CAST(AssignedDate AS DATE) = CAST(GETDATE() AS DATE)
		END
	END
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ErrorLog_Save
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 26st sept 2020
-- Description:	Save error log
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_ErrorLog_Save]
	@Module varchar(50) = '',
	@Method varchar(50) = '',
	@Description varchar(MAX) = '',
	@Parameter varchar(MAX) = '',
	@Line varchar(10) = ''	  		
AS
BEGIN
	INSERT INTO TBL_MFSB_ErrorLog
	(
		Module,
		Method,
		Description,
		Parameter,
		Line,
		InsertedDate
	)
	VALUES
	(
		@Module,
		@Method,
		@Description,
		@Parameter,
		@Line,
		GETDATE()
	)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_ImpsDetail_Save
-- --------------------------------------------------
-- =============================================
-- Author:		Shekhar G
-- Create date: 02nd Sept 2020
-- Description:	<Save and Update Imps Details>
-- =============================================

CREATE PROC [dbo].[USP_MFSB_ImpsDetail_Save]
@EntryId  INT=0,
@AccountNo VARCHAR(50)='',
@IfscCode VARCHAR(10)='',
@IsImps bit = 0,
@BeneficiaryName varchar(500),
@ClientName varchar(500),
@operation varchar(500)='',
@ipAddress varchar(100)=''
AS BEGIN

BEGIN TRY
DECLARE @IsValid bit = 0
DECLARE @Message varchar(50)

DECLARE @IsNameMatch BIT = 0
		IF ISNULL(@IsImps, 0) = 1
		BEGIN		 
			Declare @First_Name VARCHAR(150),@Middle_Name VARCHAR(150),@Last_Name VARCHAR(150),@First_Name1 VARCHAR(150),
					@Middle_Name1 VARCHAR(150),@Last_Name1 VARCHAR(150)
					
			Create Table #TempName (Id int Not NULL Identity(1,1),First_Name VARCHAR(150),Middle_Name VARCHAR(150),Last_Name VARCHAR(150))
			Insert into #TempName
						Select * From dbo.Fn_Split_Name_3part(@ClientName,' ')
			
			Insert into #TempName
						Select * From dbo.Fn_Split_Name_3part(@BeneficiaryName,' ')
			
			Select @First_Name=First_Name,@Middle_Name=Middle_Name,@Last_Name=Last_Name From #TempName Where Id=1
			Select @First_Name1=First_Name,@Middle_Name1=Middle_Name,@Last_Name1=Last_Name From #TempName Where Id=2
			
			Set @IsNameMatch=dbo.Fn_CheckNames(@First_Name,@Middle_Name,@Last_Name,@First_Name1,@Middle_Name1,@Last_Name1)			
		END
				
		IF NOT EXISTS (SELECT EntryId FROM tbl_MFSB_ImpsDetail WHERE EntryId=@ENTRYID)
		BEGIN
				
			INSERT INTO tbl_MFSB_ImpsDetail(EntryId,AccountNo,IfscCode,IsImps,BeneficiaryName,IsNameMatch,CreatedDate)
			VALUES (@EntryId,@AccountNo,@IfscCode,@IsImps,@BeneficiaryName,@IsNameMatch,GETDATE())
				
			SET @IsValid = 1
			SET @Message = 'Imps details successfully save!' 

		END
		ELSE
		BEGIN		
				
			UPDATE tbl_MFSB_ImpsDetail 
			SET 
			AccountNo=@AccountNo,
			IfscCode=@IfscCode,
			IsImps=@IsImps, 
			BeneficiaryName=@BeneficiaryName,
			IsNameMatch=@IsNameMatch,
			ModifiedDate= GETDATE()
			WHERE EntryId=@EntryId 
						

			SET @IsValid = 1
			SET @Message = 'Imps details successfully updated!' 
		END
		
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @ENTRYID,@operation,@userType,@employee_code,@ipAddress
-- END Code 

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,@Message,@ipAddress
	--Region for Save log

END TRY
		BEGIN CATCH
		         SET @IsValid = 0
				 SET @Message = 'Fail!' 
		END CATCH
END

SELECT @IsValid 'IsValid', @Message 'Message'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_NomineeDetails_Save
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 02nd Sept 2020
-- Description:	<Save and Update nominee Details>
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_NomineeDetails_Save]
@EntryID INT=0 ,
@FirstName VARCHAR(100)='',
@MiddleName VARCHAR(100)='',
@LastName VARCHAR(100)='',
@DOB varchar(20) = '',
@PanNumber VARCHAR(100)='',
@RelationShip VARCHAR(100)='',
@operation varchar(500)='',
@ipAddress varchar(100)=''
AS
BEGIN
DECLARE @IsValid bit = 0
DECLARE @Message varchar(50)
	IF NOT EXISTS(SELECT 1 FROM TBL_MF_NomineeDetails WHERE EntryId =@EntryID )
	BEGIN
		INSERT INTO TBL_MF_NomineeDetails(EntryId,FirstName,MiddleName,LastName,DOB,PanNumber,
		                    RelationShip,AddedOn)
		                   VALUES (@EntryID,
							@FirstName,
							@MiddleName,
							@LastName,
							@DOB,
							@PanNumber,							
							@RelationShip,							
							GETDATE()
							)
		
			-- Step Updation
			UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=5
			-- Step Updation					
		
		SET @IsValid = 1
		SET @Message = 'Nominee details successfully save!' 
									
	END
	ELSE 
	BEGIN
		UPDATE TBL_MF_NomineeDetails SET 
							FirstName=@FirstName,
							MiddleName=@MiddleName,
							LastName=@LastName,
							DOB=@DOB,
							PanNumber=@PanNumber,
							RelationShip=@RelationShip,							
							ModifiedOn =GETDATE()						
							WHERE EntryId = @EntryID
							
			-- Step Updation
			UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=5
			-- Step Updation					
     
		SET @IsValid = 1
		SET @Message = 'Nominee details successfully updated!' 
     							
	END
--select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID	
-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018
--EXEC usp_mfapplicationlog @EntryID,@operation,@userType,@employee_code,@ipAddress
-- END Code 	
	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,@operation,@Message,@ipAddress
	--Region for Save log
	
SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_Step_Update
-- --------------------------------------------------


-- =============================================
-- Author:		Shekhar G
-- Create date: 21st Sept 2020
-- Description:	Update Step Details
-- =============================================
CREATE PROCEDURE [dbo].[USP_MFSB_Step_Update]
	@ENTRYID INT=0,
	@Step VARCHAR(50)='',
	@operation varchar(500)='' ,
	@ipAddress varchar(100)='',
	@Status BIT = 1 	  		
AS
BEGIN

declare @EmployeeCode varchar(50)=''
DECLARE @Msg varchar(50),@IsSucces bit = 0, @StepId int

	IF(@Step = 'DOCUMENT UPLOAD')
	BEGIN
		SET @StepId = (SELECT TOP 1 Id FROM TBL_MFSB_StepMaster S WITH(NOLOCK) WHERE StepName = 'Document Upload Info')
	END
	ELSE IF(@Step = 'NOMINEE')
	BEGIN
		SET @StepId = (SELECT TOP 1 Id FROM TBL_MFSB_StepMaster S WITH(NOLOCK) WHERE StepName = 'Nominee Info')
	END
	
	IF(@StepId > 0)
	BEGIN
		UPDATE TBL_MFSB_StepDetail SET Status = @Status, UpdationDate = GETDATE()
		WHERE EntryId  = @ENTRYID AND StepId = @StepId
		
		SET @IsSucces = 1
		SET @Msg = 'Record successfully update!!'
	END
	ELSE
	BEGIN
		SET @IsSucces = 0
		SET @Msg = 'Please provide valid step!!'
	END

	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @ENTRYID,@operation,@Msg,@ipAddress
	--Region for Save log

SELECT @Msg 'Message',@IsSucces 'IsValid',@StepId 'StepId'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MFSB_SubmitForm_Save
-- --------------------------------------------------

CREATE  PROC [dbo].[USP_MFSB_SubmitForm_Save]  

@ENTRYID INT=0,  
@ipAddress varchar(50),
@TYPE_ESIGNDOC  TYPE_MF_ESIGNDOC READONLY  

AS BEGIN   
	DECLARE @IsValid bit = 0
	DECLARE @Message varchar(50)
 
    UPDATE  [TBL_MF_ESIGNDOCUMENTS]  
    SET ISDELETE=1   
    WHERE ENTRYID=@ENTRYID  

    INSERT INTO TBL_MF_ESIGNDOCUMENTS(ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,ESIGNNAME,SOURCE)  
    SELECT ENTRYID,FILENAME,FILEPATH,0,DOCTYPE,ESIGNNAME,'SBESIGN' FROM @TYPE_ESIGNDOC  

     UPDATE TBL_MF_IDENTITYDETAILS  
     SET ISAPPROVED=1  
     WHERE  ENTRYID=@ENTRYID  
     
     -- Step Updation
	 UPDATE TBL_MFSB_StepDetail SET Status = 1, UpdationDate = GETDATE() WHERE EntryId = @EntryId AND StepId=9
	 -- Step Updation
     
	SET @IsValid = 1
	SET @Message = 'Form successfully submitted!' 

     --SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE],replace(PATH,'\\172.31.16.209','http://sbregUAT.angelbroking.com/sb_registration_files') as PATH from TBL_MF_ESIGNDOCUMENTS where ENTRYID = @ENTRYID  

 

  --declare @employee_code varchar(50)

   --select @employee_code=ENTRYBY from TBL_MF_IDENTITYDETAILS where entryid=@ENTRYID	

-- Start Code ,Added by Narendra for Log Application  on 15th feb 2018

--EXEC usp_mfapplicationlog @EntryID,'Final Form Submit','',@employee_code,''
	--Region for Save log	
	EXEC USP_MFSB_ApplicationLog_Save @EntryID,'Final Form Submit',@Message,@ipAddress
	--Region for Save log


SELECT @IsValid 'IsValid', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NONCASHDEPOSIT
-- --------------------------------------------------

CREATE PROC [dbo].[USP_NONCASHDEPOSIT]

 @ENTRYID INT =0,
 @AMOUNT VARCHAR(50),
 @BROKERDEMATACC VARCHAR(50),
 @DATE VARCHAR(50),
 @DEPOSITTRANSACTIONSTATUS VARCHAR(50),
 @FORMOFDEPOSIT VARCHAR(50),
 @INTERMCLIENTID VARCHAR(50),
 @INTERMDPID VARCHAR(50),
 @INTERMEDIARY VARCHAR(50),
 @ISIN VARCHAR(50),
 @QUANTITY VARCHAR(50),
 @REMARKS VARCHAR(50),
 @SEGMENT VARCHAR(50),
 @VERTICAL VARCHAR(50),
 @VOUCHERTYPE VARCHAR(50),
 @TYPE VARCHAR(50)
 AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@ENTRYID )
BEGIN
		INSERT INTO TBL_NONCASHDEPOSIT(ENTRYID,AMOUNT,BROKERDEMATACC,DATE,DEPOSITTRANSACTIONSTATUS,FORMOFDEPOSIT,INTERMCLIENTID,INTERMDPID,INTERMEDIARY,ISIN,QUANTITY,REMARKS,SEGMENT,VERTICAL,VOUCHERTYPE,TYPE)
		VALUES (@ENTRYID,@AMOUNT,@BROKERDEMATACC,@DATE,@DEPOSITTRANSACTIONSTATUS,@FORMOFDEPOSIT,@INTERMCLIENTID,@INTERMDPID,@INTERMEDIARY,@ISIN,@QUANTITY,@REMARKS,@SEGMENT,@VERTICAL,@VOUCHERTYPE,@TYPE)

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END

ELSE
BEGIN 
                UPDATE TBL_NONCASHDEPOSIT 
				SET 
				AMOUNT=@AMOUNT,
				BROKERDEMATACC=@BROKERDEMATACC,
				DATE=@DATE,
				DEPOSITTRANSACTIONSTATUS=@DEPOSITTRANSACTIONSTATUS,
				FORMOFDEPOSIT=@FORMOFDEPOSIT,
				INTERMCLIENTID=@INTERMCLIENTID,
				INTERMDPID=@INTERMDPID,
				INTERMEDIARY=@INTERMEDIARY,
				ISIN=@ISIN,
				QUANTITY=@QUANTITY,
				REMARKS=@REMARKS,
				SEGMENT=@SEGMENT,
				VERTICAL=@VERTICAL,
				VOUCHERTYPE=@VOUCHERTYPE,
				TYPE=@TYPE

				WHERE ENTRYID=@ENTRYID  

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH

 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_REGISTRATIONRELATED
-- --------------------------------------------------

CREATE PROC  [dbo].[USP_REGISTRATIONRELATED]

	@ID int  =0,
	@ENTRYID int  =0,
	@AADHAARNO varchar (50) ='',
	@EDUQUALI varchar (200) ='',
	@OTHERQUALI varchar (200) ='',
	@OCCUPATION varchar (200) ='',
	@NATUREOFOCCUPATION varchar (200) ='',
	@OTHEROCCUPATION varchar (200) ='',
	@CAPITALMARKET varchar (200) ='',
	@OTHEREXPERIENCE varchar (200) ='',
	@PREBROKER varchar (200) ='',
	@AUTHPERSON varchar (50) ='',
	@WHETHERANY varchar (50) ='',
	@MEMBERSHIPDETAILS varchar (200) ='',
	@TRADINGACC varchar (50) ='',
	@FATHERHUSBAND varchar (50) ='',
	@contactPerson varchar (50) ='',
	@contactPersonOccupation varchar (50) ='',
	@contractSignatory varchar(200)=''


	AS BEGIN

BEGIN TRY

IF NOT EXISTS (SELECT ENTRYID FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@ENTRYID )
BEGIN
		INSERT INTO TBL_REGISTRATIONRELATED(ENTRYID,AADHAARNO,EDUQUALI,OTHERQUALI,OCCUPATION,NATUREOFOCCUPATION,OTHEROCCUPATION,CAPITALMARKET,OTHEREXPERIENCE,PREBROKER,AUTHPERSON,WHETHERANY,MEMBERSHIPDETAILS,TRADINGACC,FATHERHUSBAND,contactPerson,contactPersonOccupation,contractSignatory)
		VALUES (@ENTRYID,@AADHAARNO,@EDUQUALI,@OTHERQUALI,@OCCUPATION,@NATUREOFOCCUPATION,@OTHEROCCUPATION,@CAPITALMARKET,@OTHEREXPERIENCE,@PREBROKER,@AUTHPERSON,@WHETHERANY,@MEMBERSHIPDETAILS,@TRADINGACC,@FATHERHUSBAND,@contactPerson,@contactPersonOccupation,@contractSignatory)

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

END
ELSE
BEGIN 
        UPDATE TBL_REGISTRATIONRELATED 
				SET 
	            AADHAARNO=@AADHAARNO  ,
				EDUQUALI=@EDUQUALI  ,
				OTHERQUALI=@OTHERQUALI , 
				OCCUPATION=@OCCUPATION  ,
				NATUREOFOCCUPATION=@NATUREOFOCCUPATION  ,
				OTHEROCCUPATION=@OTHEROCCUPATION  ,
				CAPITALMARKET=@CAPITALMARKET , 
				OTHEREXPERIENCE=@OTHEREXPERIENCE  ,
				PREBROKER=@PREBROKER  ,
				AUTHPERSON=@AUTHPERSON  ,
				WHETHERANY=@WHETHERANY , 
				MEMBERSHIPDETAILS=@MEMBERSHIPDETAILS  ,
				TRADINGACC=@TRADINGACC  ,
				FATHERHUSBAND=@FATHERHUSBAND,
				contactPerson =@contactPerson ,
				contactPersonOccupation = @contactPersonOccupation,
				contractSignatory=@contractSignatory
				
				WHERE ENTRYID=@ENTRYID 

				SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 
END

END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, ERROR_MESSAGE() AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SAVE_FORM
-- --------------------------------------------------
create PROC [dbo].[USP_SAVE_FORM]
@ENTRYID INT=0,
@TYPE_ESIGNDOC  TYPE_ESIGNDOC READONLY
AS BEGIN 



		           UPDATE  [TBL_ESIGNDOCUMENTS]
				   SET ISDELETE=1 
				   WHERE ENTRYID=@ENTRYID
			 
			       INSERT INTO TBL_ESIGNDOCUMENTS(ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,SOURCE)
				   SELECT ENTRYID,FILENAME,FILEPATH,0,DOCTYPE,'SBESIGN' FROM @TYPE_ESIGNDOC


					UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=1
					WHERE  ENTRYID=@ENTRYID

					SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE]


	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SB_REGISTRATION
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SB_REGISTRATION]  

 @PROCESS AS VARCHAR(100),    

 @DATA1 AS VARCHAR(1000)='',    

 @DATA2 AS VARCHAR(1000)='',    

 @DATA3 AS VARCHAR(1000)='',    

 @DATA4 AS VARCHAR(1000)='',    

 @DATA5 AS VARCHAR(1000)='',    

 @DATA6 AS VARCHAR(1000)='',    

 @DATA7 AS VARCHAR(1000)='',    

 @DATA8 AS VARCHAR(1000)='',    

 @DATA9 AS VARCHAR(1000)='',    

 @DATA10 AS VARCHAR(1000)='',    

 @DATA11 AS VARCHAR(100)='',    

 @DATA12 AS VARCHAR(100)='',    

 @DATA13 AS VARCHAR(100)='',    

 @DATA14 AS VARCHAR(100)='',    

 @DATA15 AS VARCHAR(100)='',    

 @DATA16 AS VARCHAR(100)='',    

 @DATA17 AS VARCHAR(100)='',    

 @DATA18 AS VARCHAR(100)='',    

 @DATA19 AS VARCHAR(100)='',    

 @DATA20 AS VARCHAR(100)='',    

 @DATA21 AS VARCHAR(1000)='',    

 @DATA22 AS VARCHAR(1000)='',    

 @DATA23 AS VARCHAR(1000)='',    

 @DATA24 AS VARCHAR(1000)='',    

 @DATA25 AS VARCHAR(100)='',    

 @DATA26 AS VARCHAR(100)='', -- MIS    

 @DATA27 AS VARCHAR(100)='',--Auth    

 @DATA28 AS VARCHAR(100)='',--Edituser    

 @DATA29 AS VARCHAR(100)='',    

 @AccessType AS VARCHAR(100)=''

 

AS    

BEGIN    

     

 IF @PROCESS ='GET ALL MENULIST'

 BEGIN

    Select ID,Menu,Handler,ParentID,Seq_no from TBL_MENUDETAILS Where Active=1

 END    

 IF @PROCESS = 'GET USER COUNT'    

 BEGIN    

  SELECT * FROM TBL_IDENTITYDETAILS WHERE ISAPPROVED in(0,1) AND PAN =@DATA3     

 END    

     

 IF @PROCESS = 'GET USER'    

 BEGIN    

 --select a.USERID,a.id,b.Emp_name,a.aadhaar from     

 -- (SELECT * FROM tbl_accesscontrol   WHERE IsActive = 1) a    

 -- join(select emp_no,Emp_name from [196.1.115.132].risk.dbo.emp_info with (nolock))b    

 -- on a.userid = b.emp_no   



  select a.USERID,a.id,b.Emp_name,a.aadharVaultKey, a.referenceKey from     

  (SELECT * FROM tbl_accesscontrol   WHERE IsActive = 1) a    

  join(select emp_no,Emp_name from [INTRANET].risk.dbo.emp_info with (nolock))b    

  on a.userid = b.emp_no   





 END 

    

 IF @PROCESS = 'update USER'    

 BEGIN    

 if(@DATA26 !='')

 begin

 

 --UPDATE tbl_accesscontrol SET USERID = @DATA1,modifydate = GETDATE(),

 --modifyby = @data5,MenuAccess=@AccessType,aadharVaultKey=@DATA26 where ID = @DATA4  

-- aslam Added on 21 Aug 2018 

UPDATE tbl_accesscontrol 

SET 

	USERID = @DATA1,modifydate = GETDATE(),

	modifyby = @data5,

	MenuAccess=@AccessType,

	aadharVaultKey=@DATA26,

	referenceKey=@DATA27

WHERE ID = @DATA4  

AND isactive = 1

    

 --modifyby = @data5,MenuAccess=@AccessType where ID = @DATA4  

  select 1

  end

  else

  Begin

   UPDATE tbl_accesscontrol SET USERID = @DATA1,modifydate = GETDATE(),

 --modifyby = @data5,MenuAccess=@AccessType,aadharVaultKey=@DATA26 where ID = @DATA4  

 modifyby = @data5,MenuAccess=@AccessType Where ID = @DATA4  AND isactive = 1

  select 1

  End    

 END    



 IF @PROCESS = 'DELETE USER'    

 BEGIN    

  update tbl_accesscontrol    

  set isactive =0,    

  modifydate = GETDATE(),    

  modifyby = @data5    

  where  ID = @DATA4    

  select 1    

 END    

     

 IF @PROCESS = 'VALIDATE USER'    

 BEGIN    

  declare @cntVuser as int =0    

  select @cntVuser  = COUNT(1) from tbl_accesscontrol where USERID = @DATA1 and ISActive  = 1   

      

  if (@cntVuser =0)    

  begin    

   set @cntVuser = 0    

     select @cntVuser  = COUNT(1) from [INTRANET].risk.dbo.emp_info with (nolock) where emp_no = @DATA1     

        

     if (@cntVuser =1)    

     begin    

       select 1    

     end     

     else    

     begin     

      select -1    

     end    

  end    

  else    

  begin     

   select -1    

  end    

 END    

     

     

     

 IF @PROCESS = 'Add USER'    

 BEGIN    

  declare @cntuser as int =0  

  --select id from tbl_accesscontrol where USERID = 'E68402' and ISActive  = 1     

  select @cntuser = COUNT(1) from tbl_accesscontrol where USERID = @DATA1 and ISActive  = 1   

      

  IF (@cntuser=0)    

  --Aslam Commented on 23 Aug 2018 

 -- begin    



 -- -- Checking whether that perticular Aadhar or VID is inserted or not 

 -- declare @cntAadhaar as int = 0;

 -- select @cntAadhaar = Count(1) from tbl_accesscontrol where AadharVaultKey= @DATA3 and isactive=1





 --   begin



	--if(@cntAadhaar=0)

	--begin

	--  Select Distinct Item Into #t From dbo.SplitString(@AccessType,',')

	--   	  SET @AccessType=(Select Distinct STUFF(( SELECT ',' + Item

 --         FROM #t

 --         FOR XML PATH('')),1,1,'' ) AS MenuIds from #t)

    

	--	 --INSERT INTO tbl_accesscontrol(USERID,ModifyDate,ModifyBy,AddedBy,AddedOn,IsActive,MenuAccess,aadharVaultKey)

 --  --  VALUES(@DATA1,GETDATE(),@DATA5,@DATA5,GETDATE(),1,@AccessType,@DATA26)



	-- INSERT INTO tbl_accesscontrol(USERID,ModifyDate,ModifyBy,AddedBy,AddedOn,IsActive,MenuAccess,aadharVaultKey)

 --    VALUES(@DATA1,GETDATE(),@DATA5,@DATA5,GETDATE(),1,@AccessType,@DATA3)

	





	-- DROP Table #t

	--  --insert into TBL_SB_ACCESSCONTROL(USERID,USERTYPE,isdelete,AddedBy,addedon,aadhaar,MIS,Authorizationn,EditUser,AppType)    

	--  --values(@DATA1,@DATA2,0,@DATA5,GETDATE(),@DATA3,@DATA26,@DATA27,@DATA28,@DATA29)    

	--  select 1    

	--  end 

	--end



 -- end    



 --Aslam Commented on 23 Aug 201

	BEGIN    

	  Select Distinct Item Into #t From dbo.SplitString(@AccessType,',')

	   	  SET @AccessType=(Select Distinct STUFF(( SELECT ',' + Item

          FROM #t

          FOR XML PATH('')),1,1,'' ) AS MenuIds from #t)

    

		 --INSERT INTO tbl_accesscontrol(USERID,ModifyDate,ModifyBy,AddedBy,AddedOn,IsActive,MenuAccess,aadharVaultKey)

   --  VALUES(@DATA1,GETDATE(),@DATA5,@DATA5,GETDATE(),1,@AccessType,@DATA26)



	 INSERT INTO tbl_accesscontrol(USERID,ModifyDate,ModifyBy,AddedBy,AddedOn,IsActive,MenuAccess,aadharVaultKey)

     VALUES(@DATA1,GETDATE(),@DATA5,@DATA5,GETDATE(),1,@AccessType,@DATA3)

	



	 DROP Table #t

	  --insert into TBL_SB_ACCESSCONTROL(USERID,USERTYPE,isdelete,AddedBy,addedon,aadhaar,MIS,Authorizationn,EditUser,AppType)    

	  --values(@DATA1,@DATA2,0,@DATA5,GETDATE(),@DATA3,@DATA26,@DATA27,@DATA28,@DATA29)    

	  SELECT 1    



  END  

  ELSE    

	  BEGIN     

			SELECT -1    

	  END    

 END    

     

     

 IF @PROCESS = 'APPROVE'    

 BEGIN    

  UPDATE TBL_SBREGISTRATION    

  SET ISAPPROVED=@DATA25    

  WHERE ID =@DATA23    

      

 END    

      

 IF @PROCESS = 'AddFiles'    

 BEGIN    

  declare @cnt as int     

  set @cnt =0    

  select @cnt =COUNT(1) from TBL_SBUPLOADDOC where TRNID = @DATA3 and FILENAME= @DATA1    

  if @cnt = 0    

  begin    

   insert into  TBL_SBUPLOADDOC(FILENAME,FILETYPE,TRNID,LOCATION)    

   values(@DATA1,@DATA2,@DATA3,@DATA4)    

   select 0    

  end    

  else    

  begin    

   update TBL_SBUPLOADDOC    

   set FILENAME = @DATA1,FILETYPE=@DATA2,LOCATION=@DATA4    

   where TRNID=@DATA3    

   select 1    

  end    

      

 END    

     

 IF @PROCESS = 'AADHARVERIFY'    

 BEGIN    

  UPDATE TBL_SBREGISTRATION    

  SET isaadhaarverified=@DATA2    

  WHERE ID =@DATA1    

 END    

     

 IF @PROCESS = 'GetFilePath'    

 BEGIN    

  select finalfilepath from TBL_SBREGISTRATION    

  WHERE ID =@DATA23    

 END    

     

 IF @PROCESS = 'UpdateFilePath'    

 BEGIN    

  update TBL_SBREGISTRATION    

  set finalfilepath=@DATA24    

  WHERE ID =@DATA23    

 END    

     





 if @PROCESS ='Update ReferenceKey'

 Begin

   

   Update tbl_accesscontrol

   set aadharVaultKey = @DATA26

   where USERID = @DATA1 ;



 End



 IF @PROCESS = 'GET BANK DETAILS'    

 BEGIN    

  SELECT top 1 BANK as BANKNAME,[IFSC CODE] AS IFSCCODE ,MICRCODE,[BRANCH NAME] AS BRANCHNAME,ADDRESS    

  FROM TBL_BANKBRANCHMASTER WHERE ([IFSC CODE] =@DATA1 OR MICRCODE = CAST(@DATA2 AS FLOAT))    

 END    

    

 IF @PROCESS = 'GET STATE'    

 BEGIN    

  select	state_name 
  from		[abvskycmis].KYC_Ci.dbo.VI_getStateMasterFromEKyc With(NoLock)
  where		KRA_code = @DATA1     

 END    

     

 

 IF @PROCESS = 'GET USER TYPE'    

 BEGIN    

 

DECLARE @Ids varchar(100),@Usernumber varchar(10),@AadharVaultKey varchar(500), @referenceKey varchar(500)





-- Aslam 21 Aug 2018

--Select @Ids=MenuAccess,@Usernumber = id,@AadharVaultKey = AadharVaultKey from tbl_accesscontrol where UserId=@DATA22 AND Isactive=1



Select @Ids=MenuAccess,@Usernumber = id,@AadharVaultKey = AadharVaultKey, @referenceKey=  referenceKey from tbl_accesscontrol where UserId=@DATA22 AND Isactive=1

print @Ids



Select ID,Menu,Handler,ParentID,Seq_no,@Usernumber as Usernumber,@AadharVaultKey as AadharVaultKey, @referenceKey AS referenceKey from TBL_MENUDETAILS where  Active=1 AND CAST(ID AS  VARCHAR(100)) IN(SELECT Item

FROM dbo.SplitString(@Ids, ',')) order by Seq_no

 

 END  







END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SB_REGISTRATION_30_aug_2018
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SB_REGISTRATION_30_aug_2018]  
  @PROCESS AS VARCHAR(100),    
 @DATA1 AS VARCHAR(1000)='',    
 @DATA2 AS VARCHAR(1000)='',    
 @DATA3 AS VARCHAR(1000)='',    
 @DATA4 AS VARCHAR(1000)='',    
 @DATA5 AS VARCHAR(1000)='',    
 @DATA6 AS VARCHAR(1000)='',    
 @DATA7 AS VARCHAR(1000)='',    
 @DATA8 AS VARCHAR(1000)='',    
 @DATA9 AS VARCHAR(1000)='',    
 @DATA10 AS VARCHAR(1000)='',    
 @DATA11 AS VARCHAR(100)='',    
 @DATA12 AS VARCHAR(100)='',    
 @DATA13 AS VARCHAR(100)='',    
 @DATA14 AS VARCHAR(100)='',    
 @DATA15 AS VARCHAR(100)='',    
 @DATA16 AS VARCHAR(100)='',    
 @DATA17 AS VARCHAR(100)='',    
 @DATA18 AS VARCHAR(100)='',    
 @DATA19 AS VARCHAR(100)='',    
 @DATA20 AS VARCHAR(100)='',    
 @DATA21 AS VARCHAR(1000)='',    
 @DATA22 AS VARCHAR(1000)='',    
 @DATA23 AS VARCHAR(1000)='',    
 @DATA24 AS VARCHAR(1000)='',    
 @DATA25 AS VARCHAR(100)='',    
 @DATA26 AS VARCHAR(100)='', -- MIS    
 @DATA27 AS VARCHAR(100)='',--Auth    
 @DATA28 AS VARCHAR(100)='',--Edituser    
 @DATA29 AS VARCHAR(100)='',    
 @AccessType AS VARCHAR(100)=''
 
AS    
BEGIN    
     
 IF @PROCESS ='GET ALL MENULIST'
 BEGIN
    Select ID,Menu,Handler,ParentID,Seq_no from TBL_MENUDETAILS Where Active=1
 END    
 IF @PROCESS = 'GET USER COUNT'    
 BEGIN    
  SELECT * FROM TBL_IDENTITYDETAILS WHERE ISAPPROVED in(0,1) AND PAN =@DATA3     
 END    
     
 IF @PROCESS = 'GET USER'    
 BEGIN    
 --select a.USERID,a.id,b.Emp_name,a.aadhaar from     
 -- (SELECT * FROM tbl_accesscontrol   WHERE IsActive = 1) a    
 -- join(select emp_no,Emp_name from [196.1.115.132].risk.dbo.emp_info with (nolock))b    
 -- on a.userid = b.emp_no   

  select a.USERID,a.id,b.Emp_name,a.aadharVaultKey from     
  (SELECT * FROM tbl_accesscontrol   WHERE IsActive = 1) a    
  join(select emp_no,Emp_name from [196.1.115.132].risk.dbo.emp_info with (nolock))b    
  on a.userid = b.emp_no   


 END    
 IF @PROCESS = 'update USER'    
 --BEGIN    
 --UPDATE tbl_accesscontrol SET USERID = @DATA1,modifydate = GETDATE(),
 --modifyby = @data5,MenuAccess=@AccessType where ID = @DATA4  

 --if (@DATA26 is not null)
 -- UPDATE tbl_accesscontrol SET aadharVaultKey=@DATA26
 -- where USERID = @DATA1


 -- select 1    
 --END   
  
   BEGIN    
 if(@DATA26 !='')
 begin
 UPDATE tbl_accesscontrol SET USERID = @DATA1,modifydate = GETDATE(),
 modifyby = @data5,MenuAccess=@AccessType,aadharVaultKey=@DATA26 where ID = @DATA4  
 --modifyby = @data5,MenuAccess=@AccessType where ID = @DATA4  
  select 1
  end
  else
  Begin
   UPDATE tbl_accesscontrol SET USERID = @DATA1,modifydate = GETDATE(),
 --modifyby = @data5,MenuAccess=@AccessType,aadharVaultKey=@DATA26 where ID = @DATA4  
 modifyby = @data5,MenuAccess=@AccessType where ID = @DATA4  
  select 1
  End    
 END

 IF @PROCESS = 'DELETE USER'    
 BEGIN    
  update tbl_accesscontrol    
  set isactive =0,    
  modifydate = GETDATE(),    
  modifyby = @data5    
  where  ID = @DATA4    
  select 1    
 END    
     
 IF @PROCESS = 'VALIDATE USER'    
 BEGIN    
  declare @cntVuser as int =0    
  select @cntVuser  = COUNT(1) from tbl_accesscontrol where USERID = @DATA1 and ISActive  = 1   
      
  if (@cntVuser =0)    
  begin    
   set @cntVuser = 0    
     select @cntVuser  = COUNT(1) from [196.1.115.132].risk.dbo.emp_info with (nolock) where emp_no = @DATA1     
        
     if (@cntVuser =1)    
     begin    
       select 1    
     end     
     else    
     begin     
      select -1    
     end    
  end    
  else    
  begin     
   select -1    
  end    
 END    
     
     
     
 IF @PROCESS = 'Add USER'    
 BEGIN    
  declare @cntuser as int =0  
  --select id from tbl_accesscontrol where USERID = 'E68402' and ISActive  = 1     
  select @cntuser = COUNT(1) from tbl_accesscontrol where USERID = @DATA1 and ISActive  = 1   
     
      
  if (@cntuser=0)    
  begin    
 
  Select Distinct Item Into #t From dbo.SplitString(@AccessType,',')
  SET @AccessType=(Select Distinct STUFF(( SELECT ',' + Item
      FROM #t
      FOR XML PATH('')),1,1,'' ) AS MenuIds from #t)
    
  INSERT INTO tbl_accesscontrol (USERID,ModifyDate,ModifyBy,AddedBy,AddedOn,IsActive,MenuAccess,aadharVaultKey)
  VALUES(@DATA1,GETDATE(),@DATA5,@DATA5,GETDATE(),1,@AccessType,@DATA26)
  DROP Table #t
  --insert into TBL_SB_ACCESSCONTROL(USERID,USERTYPE,isdelete,AddedBy,addedon,aadhaar,MIS,Authorizationn,EditUser,AppType)    
  --values(@DATA1,@DATA2,0,@DATA5,GETDATE(),@DATA3,@DATA26,@DATA27,@DATA28,@DATA29)    
  select 1     
  end    
  else    
  begin     
  select -1    
  end    
      
      
 END    
     
     
 IF @PROCESS = 'APPROVE'    
 BEGIN    
  UPDATE TBL_SBREGISTRATION    
  SET ISAPPROVED=@DATA25    
  WHERE ID =@DATA23    
      
 END    
      
 IF @PROCESS = 'AddFiles'    
 BEGIN    
  declare @cnt as int     
  set @cnt =0    
  select @cnt =COUNT(1) from TBL_SBUPLOADDOC where TRNID = @DATA3 and FILENAME= @DATA1    
  if @cnt = 0    
  begin    
   insert into  TBL_SBUPLOADDOC(FILENAME,FILETYPE,TRNID,LOCATION)    
   values(@DATA1,@DATA2,@DATA3,@DATA4)    
   select 0    
  end    
  else    
  begin    
   update TBL_SBUPLOADDOC    
   set FILENAME = @DATA1,FILETYPE=@DATA2,LOCATION=@DATA4    
   where TRNID=@DATA3    
   select 1    
  end    
      
 END    
     
 IF @PROCESS = 'AADHARVERIFY'    
 BEGIN    
  UPDATE TBL_SBREGISTRATION    
  SET isaadhaarverified=@DATA2    
  WHERE ID =@DATA1    
 END    
     
 IF @PROCESS = 'GetFilePath'    
 BEGIN    
  select finalfilepath from TBL_SBREGISTRATION    
  WHERE ID =@DATA23    
 END    
     
 IF @PROCESS = 'UpdateFilePath'    
 BEGIN    
  update TBL_SBREGISTRATION    
  set finalfilepath=@DATA24    
  WHERE ID =@DATA23    
 END    
     


 if @PROCESS ='Update ReferenceKey'
 Begin
   
   Update tbl_accesscontrol
   set aadharVaultKey = @DATA26
   where USERID = @DATA1 ;

 End

 IF @PROCESS = 'GET BANK DETAILS'    
 BEGIN    
  SELECT top 1 BANK as BANKNAME,[IFSC CODE] AS IFSCCODE ,MICRCODE,[BRANCH NAME] AS BRANCHNAME,ADDRESS    
  FROM TBL_BANKBRANCHMASTER WHERE ([IFSC CODE] =@DATA1 OR MICRCODE = CAST(@DATA2 AS FLOAT))    
 END    
    
 IF @PROCESS = 'GET STATE'    
 BEGIN    
  select state_name from [196.1.115.167].KYC_Ci.dbo.VI_getStateMasterFromEKyc where KRA_code = @DATA1     
 END    
     
     
 IF @PROCESS = 'GET USER TYPE'    
 BEGIN    
 
DECLARE @Ids varchar(100),@Usernumber varchar(10),@AadharVaultKey varchar(500)

Select @Ids=MenuAccess,@Usernumber = id,@AadharVaultKey = AadharVaultKey from tbl_accesscontrol where UserId=@DATA22 AND Isactive=1
print @Ids
Select ID,Menu,Handler,ParentID,Seq_no,@Usernumber as Usernumber,@AadharVaultKey as AadharVaultKey from TBL_MENUDETAILS where  Active=1 AND CAST(ID AS  VARCHAR(100)) IN(SELECT Item
FROM dbo.SplitString(@Ids, ',')) order by Seq_no
 
 END  



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_sbapplicationlog
-- --------------------------------------------------

create proc [dbo].[usp_sbapplicationlog]
(

@entryid int ,
@operation varchar(500) ,
@userType varchar(20),
@employee_code varchar(50) ='',
@ipAddress varchar(100)=''
)
as
begin 

	if(@userType = 'BDO')
	begin
	select @employee_code = ENTRYBY from TBL_IDENTITYDETAILS
		insert into tbl_sbapplicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
	end
	else
	begin
		insert into tbl_sbapplicationlog(entryid,operation,employee_code,ipAddress)
		values(@entryid,@operation,@employee_code,@ipAddress)
	end

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA
-- --------------------------------------------------
  
  
  
  
---- USP_SBGETDATA  'GET EMP NAME','ABHISHEK.SINGH'  
  
----	USP_SBGETDATA  'GET ALL APP OBJECTS','LATIKA.KATKAM'  
---		USP_SBGETDATA  'GET ALL APP OBJECTS','E69370'
  
CREATE PROC [dbo].[USP_SBGETDATA]  
  
@PROCESS VARCHAR(50)='',  
  
@FILTER1 VARCHAR(50)=''  
  
  
  
AS BEGIN  


insert into tbl_temp_2024_03_15
(txt1,txt2,create_ts)
values 
(@PROCESS,@FILTER1,getdate())




  
  
  
IF @PROCESS ='GET APP LIST'  
  
BEGIN  
  
  
  
SELECT * FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
  
  
  
END  
  
  
  
IF @PROCESS ='GET EMP NAME'  
  
BEGIN  
  
  
  
 --select Emp_name     
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like @FILTER1 + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
  
  
  
  
select distinct Emp_name from [ABVSHRMS].Darwinboxmiddleware.dbo.vw_DrawinBox_EmployeeMaster With(NOlock) where Email_Add like @FILTER1 + '@angelbroking.com'   
  
   
  
 --select *      
  
 --from  [INTRANET].[RISK].[dbo].[emp_info]       
  
 --where email like 'ABHISHEK.SINGH' + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
  
  
--SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO = @FILTER1  
  
  
  
END  
  
  
  
IF @PROCESS ='GET MASTER DATA'  
  
BEGIN  
  
  
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,  
  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,  
  
--RTRIM (LTRIM (ZONE)) AS ZONE,  
  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,  
  
--RTRIM (LTRIM (REGION)) AS REGION,  
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL   
  
  
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A  
  
--JOIN (SELECT   
  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B  
  
--ON A.BR_CODE=B.BR_CODE   
  
  
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION    
  
FROM [CSOKYC-6].GENERAL.DBO.BO_REGION  
  
  
  
  
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL  
  
  
  
SELECT ISIN,SCRIPNAME FROM [CSOKYC-6].GENERAL.DBO.SCRIP_MASTER WHERE 1=2  
  
  
  
SELECT * FROM TBL_CONTRACTOR_SIGN  
  
  
  
END  
  
  
  
IF @PROCESS ='GET APP'  
  
BEGIN  
  
  
  
  
  
  
  
SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'  
  
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
  
  
  
SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1  
  
END  
  
  
  
IF @PROCESS ='GET APP ADMIN'  
  
BEGIN  
  
  
  
  
  
  
  
SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
  
  
  
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0  
  
UNION   
  
SELECT * from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0  
  
UNION  
  
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://10.253.6.118:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE    
  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
  
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
--JOIN  
  
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
  
--ON A.ID =B.ID   
  
  
  
SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
  
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
  
  
JOIN  
  
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
  
ON A.ID =B.ID   
  
  
  
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
  
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
  
END  
  
  
  
IF @PROCESS ='GET ALL APP OBJECTS'  
  
BEGIN  
  
  
  
  
  
  
  
--DECLARE @SQL AS VARCHAR(MAX)  
  
--DECLARE @STR AS VARCHAR(50)=''  
  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
  
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))  
  
  
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0  
  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')  
  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'  
  
  
  
--EXEC  (@SQL)  
  
  
  
declare @Emp_No varchar(50)  
  
  
  
 select @Emp_No = emp_no      
  
 from  [RISK].[dbo].[emp_info]       
  
 where email like @FILTER1 + '@angelbroking.com'   
  
 and SeparationDate is null  
  
  
  
  
  
 -- select emp_no     
  
 --from  [RISK].[dbo].[emp_info]       
  
 --where email like 'Mohit.mishra' + '@angelbroking.com'   
  
 --and SeparationDate is null  
  
  
  
  
  
  
  
 --select ENTRYBY from  TBL_IDENTITYDETAILS where = @FILTER1;  
  
  
  
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No  
  
  
  
 select * from TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No  
  
  
  
END  
  
  
  
IF @PROCESS ='GET FILES'  
  
BEGIN  
  
  
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0  
  
  
  
END  
  
  
  
IF @PROCESS ='ADD REQUEST'  
  
BEGIN  
  
  
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)  
  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))  
  
  
  
END  
  
  
  
  
  
IF @PROCESS ='CHECK PAN'  
  
BEGIN  
  
  
  
  
  
  
  
  
  
SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1  
  
  
  
  
  
  
  
END  
  
  
  
  
  
--IF @PROCESS ='GET EMP'  
  
--BEGIN  
  
  
  
--declare @partycode as varchar(500)=''  
  
--declare @CLIENTNAME as varchar(500)=''  
  
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C  
  
--JOIN   
  
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A  
  
--JOIN   
  
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B  
  
--ON A.ID=B.ID)D  
  
--ON C.PHONE=D.MOBILE  
  
  
  
--set @partycode= substring( @partycode,2,len(@partycode))  
  
  
  
--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME  
  
  
  
  
  
  
  
--END  
  
  
  
  
  
IF @PROCESS ='GET EMP'  
  
BEGIN  
  
  
  
declare @partycode as varchar(500)=''  
  
declare @CLIENTNAME as varchar(500)=''  
  
 SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [INTRANET].RISK.DBO.client_details with(nolock))C  
  
JOIN   
  
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID=@FILTER1 ) A  
  
JOIN   
  
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B  
  
ON A.ID=B.ID)D  
  
ON C.PHONE=D.MOBILE  
  
  
  
set @partycode= substring( @partycode,2,len(@partycode))  
  
  
  
select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME  
  
  
  
UPDATE TBL_SENDREQUEST  
  
set FLAG=1  
  
where USERID=@FILTER1  
  
  
  
  
  
  
  
END  
  
  
  
IF @PROCESS ='GETREJECTION'  
  
BEGIN  
  
  
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION   
  
  
  
END  
  
  
  
IF @PROCESS ='GETREJECTIONREASON'  
  
BEGIN  
  
  
  
SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1  
  
  
  
END  
  
  
  
  
  
IF @PROCESS ='DELETE CALL LOG'  
  
BEGIN  
  
  
  
UPDATE  TBL_SENDREQUEST  
  
SET flag=1  
  
 WHERE USERID=@FILTER1  
  
  
  
SELECT 1   
  
END  
  
  
  
  
  
IF @PROCESS ='GET QR CODE'  
  
BEGIN  
  
  
  
--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'  
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1  
  
  
  
END  
  
  
  
  
  
IF @PROCESS ='CHECK AADHAR'  
  
BEGIN  
  
DECLARE @CNTER AS INT =0  
  
  
  
SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1  
  
  
  
SELECT @CNTER AS CNT   
  
  
  
END  
  
  
  
IF @PROCESS ='GET FEFMEMBER DETAILS'  
  
BEGIN  
  
  
  
  
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1  
  
  
  
END  
  
  
  
  
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'  
  
BEGIN  
  
  
  
  
  
 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers   
  
  
  
END  
  
  
  
IF @PROCESS ='FINALSUBMIT'  
  
BEGIN  
  
  
  
  
  
                    UPDATE TBL_IDENTITYDETAILS  
  
     SET ISAPPROVED=4  
  
     WHERE  ENTRYID=@FILTER1  
  
  
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
  
  
END  
  
  
  
IF @PROCESS ='GET ESIGN DOCUMENTS'  
  
BEGIN  
  
  
  
SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\10.253.6.118\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE    
  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE   
  
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\10.253.6.118\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A  
  
  
  
JOIN  
  
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B  
  
ON A.ID =B.ID   
  
  
  
END  
  
  
  
IF @PROCESS ='VALIDATE USER'  
  
BEGIN  
  
  
  
            DECLARE @CNT  AS INT =0  
  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))  
  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))  
  
  
  
    
  
  
  
  
  
            SELECT @CNT= COUNT(1) FROM  [INTRANET].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD  
  
  
  
   IF(@CNT>0)  
  
   BEGIN  
  
   SELECT 'true' as result  
  
  
  
   END  
  
   ELSE  
  
   BEGIN  
  
   SELECT 'false' as result  
  
  
  
   END  
  
  
  
END  
  
  
  
  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3
-- --------------------------------------------------


















--EXEC USP_SBGETDATA__GETEMPV3 

--@PROCESS='GET EMP V3',

--@FILTER1='HOCBHO',

--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',

--@FILTER3='911599201647426',

--@FILTER4='',

--@FILTER5 =''







CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3]

(

		@PROCESS VARCHAR(50)='',

		@FILTER1 VARCHAR(MAX)='',

		@FILTER2 VARCHAR(MAX)='',

		@FILTER3 VARCHAR(MAX)='',

		@FILTER4 VARCHAR(MAX)='',

		@FILTER5 VARCHAR(MAX)=''



)



/*



EXEC USP_SBGETDATA__GETEMPV3 

@PROCESS='GET EMP V3',

@FILTER1='HOCBHO',

@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',

@FILTER3='911599201647426',

@FILTER4='',

@FILTER5 =''







*/





as

begin







--Declare 

--@PROCESS VARCHAR(50)='',

--@FILTER1 VARCHAR(MAX)='',

--@FILTER2 VARCHAR(MAX)='',

--@FILTER3 VARCHAR(MAX)='',

--@FILTER4 VARCHAR(MAX)='',

--@FILTER5 VARCHAR(MAX)=''





Declare @SbCodeV3 varchar(100)

Declare @Mobile varchar(100)

declare @partycodeV3 as varchar(500)=''



--select @PROCESS='GET EMP V3',

--@FILTER1='HOCBHO',

--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',

--@FILTER3='911599201647426',

--@FILTER4='',

--@FILTER5 =''







--select @Mobile=mobile from [196.1.115.219].SB_Registration.dbo.TBL_SENDREQUEST_v2 

select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 with(nolock)

WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc



--select @Mobile='2240003600' from TBL_SENDREQUEST_v2 

--WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3





print @Mobile+@FILTER1

print @FILTER1

print 'naiwar'





select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1

print @SbCodeV3

if(isnull(@SbCodeV3,'')='')

begin

print @SbCodeV3+'gyty'

select @SbCodeV3=Sb_Tag from [INTRANET].Mimansa.dbo.tbl_Emp_Master where USER_ID=@FILTER1

print 'check'

print @SbCodeV3

end

--select @SbCodeV3,@Mobile





IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL

    DROP TABLE #Party_Code







Create table #Party_Code

(

Party_code varchar(100)



)





insert into #Party_Code

select Party_Code from [INTRANET].RISK.DBO.client_details with(nolock) 

			where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

			and mobile_pager=@Mobile







If 	(select count(*) 

					from [INTRANET].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					and mobile_pager=@Mobile

			)=0

Begin

print 'hi'

		If (select count(*) 

					from [10.253.78.155].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 

					where 

					--last_inactive_date>GETDATE() 

					 sub_broker=@SbCodeV3

					and 

					NewMobileNo=@Mobile

			)=0

		Begin

		print 'hello'

	



			if @Mobile is not null

				Begin

				print 'save'

					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 

				end

			else

				begin

				print 'not save'

				SELECT  '' partycode,'' CLIENTNAME 

				end

			--FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3

	END

	--select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME

END













/*Mobile no exists in client details and 95 Table */

If 	(select count(*) 

					from [INTRANET].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					and mobile_pager=@Mobile

			)>0

Begin

					

	print 'client'				

IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL

    DROP TABLE #Party_Code1



					--DROP TABLE #Party_Code1



					select 

					

					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 

						[INTRANET].RISK.DBO.client_details CD with(nolock) 

					inner join 

					#Party_Code B On Cd.party_code=B.party_code

					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3



					UNION

					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [10.253.78.155].NXT.DBO.NXT_CustomerMobileNoEntry Cust 

					LEFT JOIN [INTRANET].RISK.DBO.client_details CD with(nolock) 

					On Cust.partycode=cd.party_code

					WHERE NewMobileNo=@Mobile





					if (select count(*) from #Party_Code1)>1

					begin

					print @partycodeV3

					print 'nn'



							--select '1',* from #Party_Code1



							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1



							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))



							select @partycodeV3 partycode,'' CLIENTNAME



					END



					ELSe 

					BEGIN

					print 'neha'

							select * from #Party_Code1



					END







EnD

ELSE 

Begin



/*Mobile exists only in 95 Table */

If exists (

					select * 

					from [10.253.78.155].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 

					where 

					--last_inactive_date>GETDATE() and 

					sub_broker=@SbCodeV3

					and 

					NewMobileNo=@Mobile

			)

Begin

					

					--Drop table #Party_Code2

print 'new'

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL

    DROP TABLE #Party_Code2



					--select 

					

					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 

					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 

					--inner join 

					--#Party_Code B On Cd.party_code=B.party_code

					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3



					--UNION

					SELECT DISTINCT PARTYCODE partycode,short_name AS CLIENTNAME  

					Into #Party_Code2

					FROM [10.253.78.155].NXT.DBO.NXT_CustomerMobileNoEntry Cust 

					LEFT JOIN [INTRANET].RISK.DBO.client_details CD with(nolock) 

					On Cust.partycode=cd.party_code

					WHERE NewMobileNo=@Mobile

						and cd.sub_broker=@SbCodeV3





					if (select count(*) from #Party_Code2)>1

					begin

					print 'der'



							--select * from #Party_Code2



							SELECT @partycodeV3=@partycodeV3+','+  partycode   from #Party_Code2



							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))



							select @partycodeV3 partycode,'' CLIENTNAME



					END



					ELSe 

					BEGIN

						print 'hshhhj'

							select * from #Party_Code2



					END



END



--[10.253.78.155].NXT.DBO.NXT_CustomerMobileNoEntry Cust 

EnD



END









	UPDATE [risk].dbo.TBL_SENDREQUEST_V2

	set FLAG=1

	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile









--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_23Jun2020
-- --------------------------------------------------










--EXEC USP_SBGETDATA__GETEMPV3 
--@PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3_23Jun2020]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



--Declare 
--@PROCESS VARCHAR(50)='',
--@FILTER1 VARCHAR(MAX)='',
--@FILTER2 VARCHAR(MAX)='',
--@FILTER3 VARCHAR(MAX)='',
--@FILTER4 VARCHAR(MAX)='',
--@FILTER5 VARCHAR(MAX)=''


Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''

--select @PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



--select @Mobile=mobile from [196.1.115.219].SB_Registration.dbo.TBL_SENDREQUEST_v2 
select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 with(nolock)
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc

--select @Mobile='2240003600' from TBL_SENDREQUEST_v2 
--WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3





select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


--select @SbCodeV3,@Mobile


IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from [196.1.115.132].RISK.DBO.client_details with(nolock) 
			where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
			and mobile_pager=@Mobile



If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
			--FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
	END
	--select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
    DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE partycode,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile
						and cd.sub_broker=@SbCodeV3


					if (select count(*) from #Party_Code2)>1
					begin


							--select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  partycode   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END




	UPDATE [risk].dbo.TBL_SENDREQUEST_V2
	set FLAG=1
	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile




--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_27022019
-- --------------------------------------------------





--EXEC USP_SBGETDATA__GETEMPV3 
--@PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3_27022019]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



--Declare 
--@PROCESS VARCHAR(50)='',
--@FILTER1 VARCHAR(MAX)='',
--@FILTER2 VARCHAR(MAX)='',
--@FILTER3 VARCHAR(MAX)='',
--@FILTER4 VARCHAR(MAX)='',
--@FILTER5 VARCHAR(MAX)=''


Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''

--select @PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



--select @Mobile=mobile from [196.1.115.219].SB_Registration.dbo.TBL_SENDREQUEST_v2 
select @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3

--select @Mobile='2240003600' from TBL_SENDREQUEST_v2 
--WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3





select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


--select @SbCodeV3,@Mobile


IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from [196.1.115.132].RISK.DBO.client_details with(nolock) 
			where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
			and mobile_pager=@Mobile



If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
			--FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
	END
	--select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 party_code,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
    DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE party_code,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code2)>1
					begin


							select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 party_code,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END





--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_Bkp03Apr2019
-- --------------------------------------------------








--EXEC USP_SBGETDATA__GETEMPV3 
--@PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3_Bkp03Apr2019]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



--Declare 
--@PROCESS VARCHAR(50)='',
--@FILTER1 VARCHAR(MAX)='',
--@FILTER2 VARCHAR(MAX)='',
--@FILTER3 VARCHAR(MAX)='',
--@FILTER4 VARCHAR(MAX)='',
--@FILTER5 VARCHAR(MAX)=''


Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''

--select @PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



--select @Mobile=mobile from [196.1.115.219].SB_Registration.dbo.TBL_SENDREQUEST_v2 
select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 with(nolock)
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc

--select @Mobile='2240003600' from TBL_SENDREQUEST_v2 
--WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3





select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


--select @SbCodeV3,@Mobile


IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from [196.1.115.132].RISK.DBO.client_details with(nolock) 
			where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
			and mobile_pager=@Mobile



If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
			--FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
	END
	--select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
    DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE partycode,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile
						and cd.sub_broker=@SbCodeV3


					if (select count(*) from #Party_Code2)>1
					begin


							--select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  partycode   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END




	UPDATE [risk].dbo.TBL_SENDREQUEST_V2
	set FLAG=1
	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile




--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_Bkp05Apr2019
-- --------------------------------------------------





CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3_Bkp05Apr2019]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''



IF OBJECT_ID('tempdb..#client_details') IS NOT NULL
    DROP TABLE #client_details


select * into #client_details From 
[196.1.115.132].RISK.DBO.client_details with(nolock) 
where last_inactive_date>GETDATE() and  status=1 and sub_broker=@SbCodeV3


select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 with(nolock)
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc

select @SbCodeV3=access_code from rolemgm.dbo.user_login with(nolock) where username=@FILTER1

IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from #client_details 
			where 
			--last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
			mobile_pager=@Mobile



If 	(select count(*) 
					from 
					#client_details
					where 
					--last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
					mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
		END
	
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from #client_details
					where --last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
					mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						#client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN #client_details CD 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
					DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE partycode,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					LEFT JOIN #client_details CD 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile
						and cd.sub_broker=@SbCodeV3


					if (select count(*) from #Party_Code2)>1
					begin


							--select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  partycode   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END




	UPDATE [risk].dbo.TBL_SENDREQUEST_V2
	set FLAG=1
	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile


Drop table #client_details
Drop table #Party_Code
Drop table #Party_Code2


--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_New
-- --------------------------------------------------




Create procedure [dbo].[USP_SBGETDATA__GETEMPV3_New]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''



IF OBJECT_ID('tempdb..#client_details') IS NOT NULL
    DROP TABLE #client_details


select * into #client_details From 
[196.1.115.132].RISK.DBO.client_details with(nolock) 
where last_inactive_date>GETDATE() and  status=1 and sub_broker=@SbCodeV3


select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 with(nolock)
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc

select @SbCodeV3=access_code from rolemgm.dbo.user_login with(nolock) where username=@FILTER1

IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from #client_details 
			where 
			--last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
			mobile_pager=@Mobile



If 	(select count(*) 
					from 
					#client_details
					where 
					--last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
					mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
		END
	
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from #client_details
					where --last_inactive_date>GETDATE() and sub_broker=@SbCodeV3 and 
					mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						#client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN #client_details CD 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
					DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE partycode,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					LEFT JOIN #client_details CD 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile
						and cd.sub_broker=@SbCodeV3


					if (select count(*) from #Party_Code2)>1
					begin


							--select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  partycode   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END




	UPDATE [risk].dbo.TBL_SENDREQUEST_V2
	set FLAG=1
	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile


Drop table #client_details
Drop table #Party_Code
Drop table #Party_Code2


--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA__GETEMPV3_Temp
-- --------------------------------------------------








--EXEC USP_SBGETDATA__GETEMPV3 
--@PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



CREATE procedure [dbo].[USP_SBGETDATA__GETEMPV3_Temp]
(
		@PROCESS VARCHAR(50)='',
		@FILTER1 VARCHAR(MAX)='',
		@FILTER2 VARCHAR(MAX)='',
		@FILTER3 VARCHAR(MAX)='',
		@FILTER4 VARCHAR(MAX)='',
		@FILTER5 VARCHAR(MAX)=''

)

/*

EXEC USP_SBGETDATA__GETEMPV3 
@PROCESS='GET EMP V3',
@FILTER1='HOCBHO',
@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
@FILTER3='911599201647426',
@FILTER4='',
@FILTER5 =''



*/


as
begin



--Declare 
--@PROCESS VARCHAR(50)='',
--@FILTER1 VARCHAR(MAX)='',
--@FILTER2 VARCHAR(MAX)='',
--@FILTER3 VARCHAR(MAX)='',
--@FILTER4 VARCHAR(MAX)='',
--@FILTER5 VARCHAR(MAX)=''


Declare @SbCodeV3 varchar(100)
Declare @Mobile varchar(100)
declare @partycodeV3 as varchar(500)=''

--select @PROCESS='GET EMP V3',
--@FILTER1='HOCBHO',
--@FILTER2='eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc',
--@FILTER3='911599201647426',
--@FILTER4='',
--@FILTER5 =''



--select @Mobile=mobile from [196.1.115.219].SB_Registration.dbo.TBL_SENDREQUEST_v2 
select top 1 @Mobile=mobile from [risk].dbo.TBL_SENDREQUEST_v2 
WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3 order by LOGDATE desc

--select @Mobile='2240003600' from TBL_SENDREQUEST_v2 
--WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3





select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


--select @SbCodeV3,@Mobile


IF OBJECT_ID('tempdb..#Party_Code') IS NOT NULL
    DROP TABLE #Party_Code



Create table #Party_Code
(
Party_code varchar(100)

)


insert into #Party_Code
select Party_Code from [196.1.115.132].RISK.DBO.client_details with(nolock) 
			where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
			and mobile_pager=@Mobile



If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)=0
Begin
		If (select count(*) 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() 
					 sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)=0
		Begin
	

			if @Mobile is not null
				Begin
					SELECT  'SaveNumber' partycode,@Mobile CLIENTNAME 
				end
			else
				begin
				SELECT  '' partycode,'' CLIENTNAME 
				end
			--FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
	END
	--select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
END






/*Mobile no exists in client details and 95 Table */
If 	(select count(*) 
					from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3
					and mobile_pager=@Mobile
			)>0
Begin
					
					
IF OBJECT_ID('tempdb..#Party_Code1') IS NOT NULL
    DROP TABLE #Party_Code1

					--DROP TABLE #Party_Code1

					select 
					
					CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
						[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					inner join 
					#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					UNION
					SELECT DISTINCT PARTYCODE,short_name AS CLIENTNAME  FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code1)>1
					begin


							--select '1',* from #Party_Code1

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code1

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code1

					END



EnD
ELSE 
Begin

/*Mobile exists only in 95 Table */
If exists (
					select * 
					from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust with(nolock) 
					where 
					--last_inactive_date>GETDATE() and 
					sub_broker=@SbCodeV3
					and 
					NewMobileNo=@Mobile
			)
Begin
					
					--Drop table #Party_Code2

					IF OBJECT_ID('tempdb..#Party_Code2') IS NOT NULL
    DROP TABLE #Party_Code2

					--select 
					
					--CD.party_code,short_name AS CLIENTNAME Into #Party_Code1 from 
					--	[196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					--inner join 
					--#Party_Code B On Cd.party_code=B.party_code
					--where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3

					--UNION
					SELECT DISTINCT PARTYCODE party_code,short_name AS CLIENTNAME  
					Into #Party_Code2
					FROM [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
					LEFT JOIN [196.1.115.132].RISK.DBO.client_details CD with(nolock) 
					On Cust.partycode=cd.party_code
					WHERE NewMobileNo=@Mobile


					if (select count(*) from #Party_Code2)>1
					begin


							select * from #Party_Code2

							SELECT @partycodeV3=@partycodeV3+','+  party_code   from #Party_Code2

							set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

							select @partycodeV3 partycode,'' CLIENTNAME

					END

					ELSe 
					BEGIN

							select * from #Party_Code2

					END

END

--[172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust 
EnD

END




	UPDATE [risk].dbo.TBL_SENDREQUEST_V2
	set FLAG=1
	where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3 and MOBILE=@Mobile




--Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_06Feb2019
-- --------------------------------------------------

--USP_SBGETDATA
--process='InsertMobileNo'
--filter1='partycode'
--FILTER2='MobileNo'



/*
----
Begin tran
Exec  [USP_SBGETDATA_06Feb2019] 'GET EMP V3','HOCBHO','eZG6mmULkYQ:APA91bGLjwQVMpKRs4keLgDUKVvArrxiDWvlfN0_k4JNQevkYjQ8wXL7IImQ7G6Pf88TbFRQcSzV_t8uUsX4kFCzhg4ae2TRxMNqrlnF4Cl3f3Co_kGRwu87iTkT_I-4gnOyEUuSCOGc','911599201647426','',''
Rollback tran

*/

---- EXEC USP_SBGETDATA  'GET APP LIST','e58488'
CREATE PROC [dbo].[USP_SBGETDATA_06Feb2019]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

--commented on 23 July 2018
--SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
--FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1
--UNION ALL
--SELECT ENTRYID,, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
--FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

--Added on 23 July 2018
SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1
UNION ALL
SELECT ENTRYID,'' as aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1


END

IF @PROCESS ='GET EMP NAME'
BEGIN

SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE 
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [INTRANET].[RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null
 
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No



END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

		declare @partycode as varchar(500)=''
		declare @CLIENTNAME as varchar(500)='',@SbCode varchar(50)

		select @SbCode=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


		SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) where last_inactive_date>GETDATE() and sub_broker



=@SbCode)C
		JOIN 
		(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID like @FILTER1 ) A
		JOIN 
		(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
		ON A.ID=B.ID)D
		ON C.PHONE=D.MOBILE

		set @partycode= substring( @partycode,2,len(@partycode))

		select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

		UPDATE TBL_SENDREQUEST
		set FLAG=1
		where USERID=@FILTER1
END


		IF @PROCESS ='GET EMP V2'
		BEGIN

				declare @partycodeV2 as varchar(500)=''
				declare @CLIENTNAMEV2 as varchar(500)='',
				@SbCodeV2 varchar(50)

				select @SbCodeV2=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				SELECT  @partycodeV2=@partycodeV2+','+  C.party_code,@CLIENTNAMEV2=C.CLIENTNAME FROM 
					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV2)C
				JOIN 
					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 
						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A
				JOIN 
				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B
				ON A.ID=B.ID)D
				ON C.PHONE=D.MOBILE

				set @partycodeV2= substring( @partycodeV2,2,len(@partycodeV2))

				select @partycodeV2 AS partycode ,@CLIENTNAMEV2 AS CLIENTNAME

				UPDATE TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
				
		END
		IF @PROCESS ='InsertMobileNo'
		BEGIN

		INSERT into [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo,Sub_Broker)
		values (@FILTER1,@FILTER2,@FILTER3)

		END

	    IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END

		IF @PROCESS ='GET EMP V3'
		BEGIN

			
				EXEC USP_SBGETDATA__GETEMPV3 
					@PROCESS=@PROCESS,
					@FILTER1=@FILTER1,
					@FILTER2=@FILTER2,
					@FILTER3=@FILTER3,
					@FILTER4=@FILTER4,
					@FILTER5 =@FILTER5 





		/*

				declare @partycodeV3 as varchar(500)=''

				declare @CLIENTNAMEV3 as varchar(500)=null,

				@SbCodeV3 varchar(50)



				select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				

				--Declare @PartyClientName Varchar (100)
				--select @PartyClientName = long_name from [172.31.16.38].Ipartner.Dbo.Sb_Client_Details where party_code =@SbCodeV3 
				--SELECT  @partycodeV3=@partycodeV3+','+  Isnull(C.party_code,@SbCodeV3),@CLIENTNAMEV3= Isnull(C.CLIENTNAME,@PartyClientName) FROM 
				
				IF exists (
					
				--select 1,@CLIENTNAMEV3
				SELECT  C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				
				
				)

				Begin
				SELECT  @partycodeV3=@partycodeV3+','+  C.party_code,@CLIENTNAMEV3= C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				END

				Else

				Begin
				
				Select  @partycodeV3=@partycodeV3+','+  Cust.partycode,@CLIENTNAMEV3= Sb.long_name from (SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				INNER join [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry Cust on CUst.NewMobileNo = D.MOBILE
				INNER join [172.31.16.95].NXT.Dbo.Sb_Client_Details SB on  SB.party_Code = Cust.partycode
				
				End
				


				set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

				--select @CLIENTNAMEV3 as clientname
				IF (@CLIENTNAMEV3 is not null)
				
				
				BEGIN
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				ELSE
				BEGIN
				SELECT  @partycodeV3='SaveNumber',@CLIENTNAMEV3=MOBILE FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				--UPDATE TBL_SENDREQUEST_V2

				--set FLAG=1

				--where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3

				*/

				UPDATE TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3

		END



		
IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1

END

IF @PROCESS ='GET QR CODE V2'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM TBL_USER_QRCODE_v2 WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_admin
-- --------------------------------------------------
  
  
---- USP_SBGETDATA  'GET FEFMEMBER DETAILS','21822'  
CREATE PROC [dbo].[USP_SBGETDATA_admin]  
@PROCESS VARCHAR(50)='',  
@FILTER1 VARCHAR(50)=''  
  
AS BEGIN  
  
IF @PROCESS ='GET APP LIST'  
BEGIN  
  
SELECT * FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1  
  
END  

IF @PROCESS ='PREESINGUPDATE'  
BEGIN  
  
UPDATE TBL_ESIGNDOCUMENTS
SET ISDELETE = 1
 WHERE SOURCE = 'SBADMIN' AND ENTRYID = @FILTER1
  
END  


IF @PROCESS ='GET EMP NAME'  
BEGIN  
  
SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1  
  
END  
  
IF @PROCESS ='GET MASTER DATA'  
BEGIN  
  
--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,  
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,  
--RTRIM (LTRIM (ZONE)) AS ZONE,  
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,  
--RTRIM (LTRIM (REGION)) AS REGION,  
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL   
  
--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A  
--JOIN (SELECT   
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,  
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B  
--ON A.BR_CODE=B.BR_CODE   
  
SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION    
FROM [196.1.115.182].GENERAL.DBO.BO_REGION  
  
SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL  
  
SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2  
  
END  
  
IF @PROCESS ='GET APP'  
BEGIN  
  
  
  
SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1  
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
UNION 
SELECT * FROM [DBO].[TBL_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
UNION
select * from TBL_DOCUMENTSUPLOAD_PDF where ENTRYID =@FILTER1 and DOCTYPE='Affidavit' and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://172.31.16.251:23/','HTTP://172.31.16.251:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1  
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
END  


IF @PROCESS ='GET APP ADMIN'
BEGIN


SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 AND DOCTYPE LIKE '%SBDOC%' AND ISDELETE =0
UNION 

SELECT * FROM [DBO].[TBL_DOCUMENTSUPLOADFINAL_PDF] WHERE ENTRYID=@FILTER1 AND ISDELETE =0
--UNION

--SELECT * FROM TBL_DOCUMENTSUPLOAD_PDF WHERE ENTRYID =@FILTER1 AND (DOCTYPE in ('AFFIDAVIT','MOU') or DOCTYPE like '%Agreement' )  AND ISDELETE =0

UNION
--SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://196.1.115.136:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
--FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

SELECT A.ID,ENTRYID,B.FILENAME
,CASE WHEN CHARINDEX('\\172.31.16.251\APPLICATIONPDF\',PATH) >0 THEN  REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') 
ELSE REPLACE(PATH,'FTP://196.1.115.136:23/','HTTP://SBREG.ANGELBROKING.COM/SB_REGISTRATION_FILES/APPLICATIONESIGN/') END AS PATH  ,ISDELETE,REPLACE(REPLACE(A.FILENAME,SUBSTRING(A.FILENAME,1,10),''),'.PDF','')  AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE (PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' OR PATH LIKE 'FTP://196.1.115.136:23/%') AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1 AND ISDEPOSIT = 0  
END
  
IF @PROCESS ='GET ALL APP OBJECTS'  
BEGIN  
  
  
  
--DECLARE @SQL AS VARCHAR(MAX)  
--DECLARE @STR AS VARCHAR(50)=''  
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))  
  
--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0  
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')  
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'  
  
--EXEC  (@SQL)  
  
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1  
  
  
  
END  
  
IF @PROCESS ='GET FILES'  
BEGIN  
  
SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0  
  
END  
  
IF @PROCESS ='ADD REQUEST'  
BEGIN  
  
INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)  
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))  
  
END  
  
  
IF @PROCESS ='CHECK PAN'  
BEGIN  
  
SELECT * FROM TBL_IDENTITYDETAILS WHERE ISAPPROVED  IN(1,0,4) AND PAN=@FILTER1  
  
END  
  
  
IF @PROCESS ='GET EMP'  
BEGIN  
  
DECLARE @PARTYCODE AS VARCHAR(500)=''  
DECLARE @CLIENTNAME AS VARCHAR(500)=''  
 SELECT  @PARTYCODE=@PARTYCODE+','+  C.PARTY_CODE,@CLIENTNAME=C.CLIENTNAME FROM (SELECT PARTY_CODE,MOBILE_PAGER AS PHONE,SHORT_NAME AS CLIENTNAME FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK))C  
JOIN   
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A  
JOIN   
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B  
ON A.ID=B.ID)D  
ON C.PHONE=D.MOBILE  
  
SET @PARTYCODE= SUBSTRING( @PARTYCODE,2,LEN(@PARTYCODE))  
  
SELECT @PARTYCODE AS PARTYCODE ,@CLIENTNAME AS CLIENTNAME  
  
--UPDATE TBL_SENDREQUEST  
--SET FLAG=1  
--WHERE ID IN (SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1)   
  
  
END  
  
IF @PROCESS ='GETREJECTION'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REJECTION AS VALUENAME  FROM TBL_REJECTION   
  
END  
  
IF @PROCESS ='GETREJECTIONREASON'  
BEGIN  
  
SELECT CAST (ID AS VARCHAR(50)) AS KEYNAME , REASON AS VALUENAME FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1  
  
END  
  
  
IF @PROCESS ='DELETE CALL LOG'  
BEGIN  
  
UPDATE  TBL_SENDREQUEST  
SET FLAG=1  
 WHERE USERID=@FILTER1  
  
SELECT 1   
END  
  
  
IF @PROCESS ='GET QR CODE'  
BEGIN  
  
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@FILTER1  
  
END  
  
  
IF @PROCESS ='CHECK AADHAR'  
BEGIN  
DECLARE @CNTER AS INT =0  
  
SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1  
  
SELECT @CNTER AS CNT   
  
END  
  
IF @PROCESS ='GET FEFMEMBER DETAILS'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1  
  
END  
  
  
IF @PROCESS ='GETFEFTRAINERDETAILS LIST'  
BEGIN  
  
  
 EXEC INTRANET.MISC.DBO.FEE_GETALLTRAINERS   
  
END  
  
IF @PROCESS ='FINALSUBMIT'  
BEGIN  
  
  
                    UPDATE TBL_IDENTITYDETAILS  
     SET ISAPPROVED=4  
     WHERE  ENTRYID=@FILTER1  
  
     SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]  
  
END  
  
  
  
IF @PROCESS ='VALIDATE USER'  
BEGIN  
  
            DECLARE @CNT  AS INT =0  
   DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))  
   DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))  
  
    
  
  
            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.DBO.USER_LOGIN   WHERE USERNAME=@USERID AND USERPASSWORD=@PWD  
  
   IF(@CNT>0)  
   BEGIN  
   SELECT 'TRUE' AS RESULT  
  
   END  
   ELSE  
   BEGIN  
   SELECT 'FALSE' AS RESULT  
  
   END  
  
END  
  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_Bkp06Feb2019
-- --------------------------------------------------


---- USP_SBGETDATA  'GET EMP NAME','ABHISHEK.SINGH'
---- USP_SBGETDATA  'GET FEFMEMBER DETAILS','21822'
CREATE PROC [dbo].[USP_SBGETDATA_Bkp06Feb2019]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(50)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

SELECT * FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

END

IF @PROCESS ='GET EMP NAME'
BEGIN

 select Emp_name   
 from  [RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null


 
 --select *    
 --from  [INTRANET].[RISK].[dbo].[emp_info]     
 --where email like 'ABHISHEK.SINGH' + '@angelbroking.com' 
 --and SeparationDate is null

--SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO = @FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT * from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null


 -- select emp_no   
 --from  [RISK].[dbo].[emp_info]     
 --where email like 'Mohit.mishra' + '@angelbroking.com' 
 --and SeparationDate is null



 --select ENTRYBY from  TBL_IDENTITYDETAILS where = @FILTER1;

 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No

 select * from TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No

END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

declare @partycode as varchar(500)=''
declare @CLIENTNAME as varchar(500)=''
 SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
JOIN 
(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID=@FILTER1 ) A
JOIN 
(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
ON A.ID=B.ID)D
ON C.PHONE=D.MOBILE

set @partycode= substring( @partycode,2,len(@partycode))

select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

UPDATE TBL_SENDREQUEST
set FLAG=1
where USERID=@FILTER1



END

IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_Ipartner
-- --------------------------------------------------




/*
----
Begin tran
Exec  USP_SBGETDATA_1  'GET EMP V3','alwarajyc','eTFGxE4eVBk:APA91bFbW9f_oTnGkHnybF9ok7TaMy66PbfSUxLgRZx_AS5l-HWHUfW9ybFlHze1g1IT7MsJtJKFWGhwaR5xig91oY_Psp4UuMvb6yG7vKNwptdeXrmVc9WmVQMB91LbFrC_Kkp9QVwy','358953061225932','',''
Rollback tran

*/

---- USP_SBGETDATA  'GET APP LIST','e58488'
CREATE PROC [dbo].[USP_SBGETDATA_Ipartner]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

--commented on 23 July 2018
--SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
--FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1
--UNION ALL
--SELECT ENTRYID,, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
--FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

--Added on 23 July 2018
SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1
UNION ALL
SELECT ENTRYID,'' as aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1


END

IF @PROCESS ='GET EMP NAME'
BEGIN

SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE 
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [INTRANET].[RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null
 
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No



END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

		declare @partycode as varchar(500)=''
		declare @CLIENTNAME as varchar(500)='',@SbCode varchar(50)

		select @SbCode=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


		SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) where last_inactive_date>GETDATE() and sub_broker
=@SbCode)C
		JOIN 
		(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID like @FILTER1 ) A
		JOIN 
		(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
		ON A.ID=B.ID)D
		ON C.PHONE=D.MOBILE

		set @partycode= substring( @partycode,2,len(@partycode))

		select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

		UPDATE TBL_SENDREQUEST
		set FLAG=1
		where USERID=@FILTER1
END


		IF @PROCESS ='GET EMP V2'
		BEGIN

				declare @partycodeV2 as varchar(500)=''
				declare @CLIENTNAMEV2 as varchar(500)='',
				@SbCodeV2 varchar(50)

				select @SbCodeV2=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				SELECT  @partycodeV2=@partycodeV2+','+  C.party_code,@CLIENTNAMEV2=C.CLIENTNAME FROM 
					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV2)C
				JOIN 
					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 
						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A
				JOIN 
				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B
				ON A.ID=B.ID)D
				ON C.PHONE=D.MOBILE

				set @partycodeV2= substring( @partycodeV2,2,len(@partycodeV2))

				select @partycodeV2 AS partycode ,@CLIENTNAMEV2 AS CLIENTNAME

				UPDATE TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
				
		END
		IF @PROCESS ='InsertMobileNo'
		BEGIN

		INSERT into [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo)
		values (@FILTER1,@FILTER2)

		END

	    IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END

		IF @PROCESS ='GET EMP V3'
		BEGIN



				declare @partycodeV3 as varchar(500)=''

				declare @CLIENTNAMEV3 as varchar(500)=null,

				@SbCodeV3 varchar(50)



				select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				

				--Declare @PartyClientName Varchar (100)
				--select @PartyClientName = long_name from [172.31.16.38].Ipartner.Dbo.Sb_Client_Details where party_code =@SbCodeV3 
				--SELECT  @partycodeV3=@partycodeV3+','+  Isnull(C.party_code,@SbCodeV3),@CLIENTNAMEV3= Isnull(C.CLIENTNAME,@PartyClientName) FROM 
				
				IF exists (
					
				--select 1,@CLIENTNAMEV3
				SELECT  C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				
				
				)

				Begin
				SELECT  @partycodeV3=@partycodeV3+','+  C.party_code,@CLIENTNAMEV3= C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				END

				Else

				Begin
				
				Select  @partycodeV3=@partycodeV3+','+  Cust.partycode,@CLIENTNAMEV3= Sb.long_name from (SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				INNER join [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry Cust on CUst.NewMobileNo = D.MOBILE
				INNER join [172.31.16.38].Ipartner.Dbo.Sb_Client_Details SB on  SB.party_Code = Cust.partycode
				
				End
				


				set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

				--select @CLIENTNAMEV3 as clientname
				IF (@CLIENTNAMEV3 is not null)
				
				
				BEGIN
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				ELSE
				BEGIN
				SELECT  @partycodeV3='SaveNumber',@CLIENTNAMEV3=MOBILE FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				UPDATE TBL_SENDREQUEST_V2

				set FLAG=1

				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3

				

		END



		
IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE=@filter1

END

IF @PROCESS ='GET QR CODE V2'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM TBL_USER_QRCODE_v2 WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_NXT
-- --------------------------------------------------
CREATE PROC [dbo].[USP_SBGETDATA_NXT]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

--return 0




		IF @PROCESS ='GET EMP V3'
		BEGIN
		
			EXEC USP_SBGETDATA__GETEMPV3 
					@PROCESS=@PROCESS,
					@FILTER1=@FILTER1,
					@FILTER2=@FILTER2,
					@FILTER3=@FILTER3,
					@FILTER4=@FILTER4,
					@FILTER5 =@FILTER5 

		END


		IF @PROCESS ='InsertMobileNo'
		BEGIN

		declare @mobCount int
		

		if exists(select * from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry with(nolock) where PartyCode = @FILTER1 and NewMobileNo = @FILTER2)
			BEGIN
				select msg=3
			END
		else
			BEGIN 
			--select @mobCount= COUNT(newmobileno) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry nolock where newmobileno = @FILTER2 and Sub_Broker=@FILTER3  group by newmobileno
			select @mobCount= COUNT(newmobileno) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry  with(nolock)  where newmobileno = @FILTER2 group by newmobileno
			if (isnull(@mobCount,0) < 3)
				begin
					INSERT into [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo,Sub_Broker)
					values (@FILTER1,@FILTER2,@FILTER3)

					select msg = 1 --'Mobile No Save Successfully.'
				end
				else
				begin
					select msg = 2 --'You can not save same numbers more than 3 client'
				end
			END

		END


		  IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry with(nolock) where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END


IF @PROCESS ='GET QR CODE V2'
BEGIN

SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM [risk].dbo.TBL_USER_QRCODE_v2 with (nolock) WHERE QRCODE=@filter1

END




END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_NXT_11032019
-- --------------------------------------------------




/*
----
Begin tran
Exec  USP_SBGETDATA_1  'GET EMP V3','alwarajyc','eTFGxE4eVBk:APA91bFbW9f_oTnGkHnybF9ok7TaMy66PbfSUxLgRZx_AS5l-HWHUfW9ybFlHze1g1IT7MsJtJKFWGhwaR5xig91oY_Psp4UuMvb6yG7vKNwptdeXrmVc9WmVQMB91LbFrC_Kkp9QVwy','358953061225932','',''
Rollback tran

*/

---- USP_SBGETDATA  'GET APP LIST','e58488'
CREATE PROC [dbo].[USP_SBGETDATA_NXT_11032019]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

--commented on 23 July 2018
--SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
--FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1
--UNION ALL
--SELECT ENTRYID,, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
--FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

--Added on 23 July 2018
SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1
UNION ALL
SELECT ENTRYID,'' as aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1


END

IF @PROCESS ='GET EMP NAME'
BEGIN

SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE 
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [INTRANET].[RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null
 
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No



END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

		declare @partycode as varchar(500)=''
		declare @CLIENTNAME as varchar(500)='',@SbCode varchar(50)

		select @SbCode=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


		SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) where last_inactive_date>GETDATE() and sub_broker
=@SbCode)C
		JOIN 
		(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID like @FILTER1 ) A
		JOIN 
		(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
		ON A.ID=B.ID)D
		ON C.PHONE=D.MOBILE

		set @partycode= substring( @partycode,2,len(@partycode))

		select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

		UPDATE TBL_SENDREQUEST
		set FLAG=1
		where USERID=@FILTER1
END


		IF @PROCESS ='GET EMP V2'
		BEGIN

				declare @partycodeV2 as varchar(500)=''
				declare @CLIENTNAMEV2 as varchar(500)='',
				@SbCodeV2 varchar(50)

				select @SbCodeV2=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				SELECT  @partycodeV2=@partycodeV2+','+  C.party_code,@CLIENTNAMEV2=C.CLIENTNAME FROM 
					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV2)C
				JOIN 
					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 
						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM [risk].dbo.TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A
				JOIN 
				(SELECT ID AS ID FROM [risk].dbo.TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B
				ON A.ID=B.ID)D
				ON C.PHONE=D.MOBILE

				set @partycodeV2= substring( @partycodeV2,2,len(@partycodeV2))

				select @partycodeV2 AS partycode ,@CLIENTNAMEV2 AS CLIENTNAME

				UPDATE [risk].dbo.TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
				
		END
		IF @PROCESS ='InsertMobileNo'
		BEGIN

		declare @mobCount int
		

		if exists(select * from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry where PartyCode = @FILTER1 and NewMobileNo = @FILTER2)
			BEGIN
				select msg=3
			END
		else
			BEGIN 
			select @mobCount= COUNT(newmobileno) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry nolock where newmobileno = @FILTER2 and Sub_Broker=@FILTER3  group by newmobileno
			if @mobCount < 3
				begin
					INSERT into [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo,Sub_Broker)
					values (@FILTER1,@FILTER2,@FILTER3)

					select msg = 1 --'Mobile No Save Successfully.'
				end
				else
				begin
					select msg = 2 --'You can not save same numbers more than 3 client'
				end
			END

		END

	    IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END

		IF @PROCESS ='GET EMP V3'
		BEGIN



			EXEC USP_SBGETDATA__GETEMPV3 
					@PROCESS=@PROCESS,
					@FILTER1=@FILTER1,
					@FILTER2=@FILTER2,
					@FILTER3=@FILTER3,
					@FILTER4=@FILTER4,
					@FILTER5 =@FILTER5 


/*
				declare @partycodeV3 as varchar(500)=''

				declare @CLIENTNAMEV3 as varchar(500)=null,

				@SbCodeV3 varchar(50)



				select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				

				--Declare @PartyClientName Varchar (100)
				--select @PartyClientName = long_name from [172.31.16.38].Ipartner.Dbo.Sb_Client_Details where party_code =@SbCodeV3 
				--SELECT  @partycodeV3=@partycodeV3+','+  Isnull(C.party_code,@SbCodeV3),@CLIENTNAMEV3= Isnull(C.CLIENTNAME,@PartyClientName) FROM 
				
				IF exists (
					
				--select 1,@CLIENTNAMEV3
				SELECT  C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				
				
				)

				Begin
				SELECT  @partycodeV3=@partycodeV3+','+  C.party_code,@CLIENTNAMEV3= C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				END

				Else

				Begin
				
				Select  @partycodeV3=@partycodeV3+','+  Cust.partycode,@CLIENTNAMEV3= Sb.long_name from (SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				INNER join [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry Cust on CUst.NewMobileNo = D.MOBILE
				INNER join [172.31.16.38].Ipartner.Dbo.Sb_Client_Details SB on  SB.party_Code = Cust.partycode
				
				End
				


				set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

				--select @CLIENTNAMEV3 as clientname
				IF (@CLIENTNAMEV3 is not null)
				
				
				BEGIN
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				ELSE
				BEGIN
				SELECT  @partycodeV3='SaveNumber',@CLIENTNAMEV3=MOBILE FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END

				*/


			/*	UPDATE [risk].dbo.TBL_SENDREQUEST_V2

				set FLAG=1

				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
			*/
				

		END



		
IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM [risk].dbo.TBL_USER_QRCODE WHERE QRCODE=@filter1

END

IF @PROCESS ='GET QR CODE V2'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM [risk].dbo.TBL_USER_QRCODE_v2 WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_NXT_26022019
-- --------------------------------------------------







/*
----
Begin tran
Exec  USP_SBGETDATA_1  'GET EMP V3','alwarajyc','eTFGxE4eVBk:APA91bFbW9f_oTnGkHnybF9ok7TaMy66PbfSUxLgRZx_AS5l-HWHUfW9ybFlHze1g1IT7MsJtJKFWGhwaR5xig91oY_Psp4UuMvb6yG7vKNwptdeXrmVc9WmVQMB91LbFrC_Kkp9QVwy','358953061225932','',''
Rollback tran

*/

---- USP_SBGETDATA  'GET APP LIST','e58488'
CREATE PROC [dbo].[USP_SBGETDATA_NXT_26022019]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

--commented on 23 July 2018
--SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
--FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1
--UNION ALL
--SELECT ENTRYID,, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
--FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

--Added on 23 July 2018
SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1
UNION ALL
SELECT ENTRYID,'' as aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1


END

IF @PROCESS ='GET EMP NAME'
BEGIN

SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE 
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [INTRANET].[RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null
 
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No



END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

		declare @partycode as varchar(500)=''
		declare @CLIENTNAME as varchar(500)='',@SbCode varchar(50)

		select @SbCode=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


		SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) where last_inactive_date>GETDATE() and sub_broker
=@SbCode)C
		JOIN 
		(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID like @FILTER1 ) A
		JOIN 
		(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
		ON A.ID=B.ID)D
		ON C.PHONE=D.MOBILE

		set @partycode= substring( @partycode,2,len(@partycode))

		select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

		UPDATE TBL_SENDREQUEST
		set FLAG=1
		where USERID=@FILTER1
END


		IF @PROCESS ='GET EMP V2'
		BEGIN

				declare @partycodeV2 as varchar(500)=''
				declare @CLIENTNAMEV2 as varchar(500)='',
				@SbCodeV2 varchar(50)

				select @SbCodeV2=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				SELECT  @partycodeV2=@partycodeV2+','+  C.party_code,@CLIENTNAMEV2=C.CLIENTNAME FROM 
					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV2)C
				JOIN 
					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 
						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A
				JOIN 
				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B
				ON A.ID=B.ID)D
				ON C.PHONE=D.MOBILE

				set @partycodeV2= substring( @partycodeV2,2,len(@partycodeV2))

				select @partycodeV2 AS partycode ,@CLIENTNAMEV2 AS CLIENTNAME

				UPDATE TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
				
		END
		IF @PROCESS ='InsertMobileNo'
		BEGIN

		INSERT into [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo)
		values (@FILTER1,@FILTER2)

		END

	    IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END

		IF @PROCESS ='GET EMP V3'
		BEGIN



			EXEC USP_SBGETDATA__GETEMPV3 
					@PROCESS=@PROCESS,
					@FILTER1=@FILTER1,
					@FILTER2=@FILTER2,
					@FILTER3=@FILTER3,
					@FILTER4=@FILTER4,
					@FILTER5 =@FILTER5 


/*
				declare @partycodeV3 as varchar(500)=''

				declare @CLIENTNAMEV3 as varchar(500)=null,

				@SbCodeV3 varchar(50)



				select @SbCodeV3=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				

				--Declare @PartyClientName Varchar (100)
				--select @PartyClientName = long_name from [172.31.16.38].Ipartner.Dbo.Sb_Client_Details where party_code =@SbCodeV3 
				--SELECT  @partycodeV3=@partycodeV3+','+  Isnull(C.party_code,@SbCodeV3),@CLIENTNAMEV3= Isnull(C.CLIENTNAME,@PartyClientName) FROM 
				
				IF exists (
					
				--select 1,@CLIENTNAMEV3
				SELECT  C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				
				
				)

				Begin
				SELECT  @partycodeV3=@partycodeV3+','+  C.party_code,@CLIENTNAMEV3= C.CLIENTNAME FROM 

					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 

					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV3)C

				JOIN 

					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				ON C.PHONE=D.MOBILE
				END

				Else

				Begin
				
				Select  @partycodeV3=@partycodeV3+','+  Cust.partycode,@CLIENTNAMEV3= Sb.long_name from (SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 

						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A

				JOIN 

				(SELECT ID AS ID FROM TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B

				ON A.ID=B.ID)D

				INNER join [172.31.16.38].Ipartner.DBO.NXT_CustomerMobileNoEntry Cust on CUst.NewMobileNo = D.MOBILE
				INNER join [172.31.16.38].Ipartner.Dbo.Sb_Client_Details SB on  SB.party_Code = Cust.partycode
				
				End
				


				set @partycodeV3= substring( @partycodeV3,2,len(@partycodeV3))

				--select @CLIENTNAMEV3 as clientname
				IF (@CLIENTNAMEV3 is not null)
				
				
				BEGIN
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END
				ELSE
				BEGIN
				SELECT  @partycodeV3='SaveNumber',@CLIENTNAMEV3=MOBILE FROM TBL_SENDREQUEST_v2  with(nolock) WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3
				select @partycodeV3 AS partycode ,@CLIENTNAMEV3 AS CLIENTNAME
				END

				*/
				UPDATE TBL_SENDREQUEST_V2

				set FLAG=1

				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3

				

		END



		
IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM [risk].dbo.TBL_USER_QRCODE WHERE QRCODE=@filter1

END

IF @PROCESS ='GET QR CODE V2'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM [risk].dbo.TBL_USER_QRCODE_v2 WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBGETDATA_NXT_Bkp03Apr2019
-- --------------------------------------------------
/*
----
Begin tran
Exec  USP_SBGETDATA_1  'GET EMP V3','alwarajyc','eTFGxE4eVBk:APA91bFbW9f_oTnGkHnybF9ok7TaMy66PbfSUxLgRZx_AS5l-HWHUfW9ybFlHze1g1IT7MsJtJKFWGhwaR5xig91oY_Psp4UuMvb6yG7vKNwptdeXrmVc9WmVQMB91LbFrC_Kkp9QVwy','358953061225932','',''
Rollback tran

*/

---- USP_SBGETDATA  'GET APP LIST','e58488'
CREATE PROC [dbo].[USP_SBGETDATA_NXT_Bkp03Apr2019]
@PROCESS VARCHAR(50)='',
@FILTER1 VARCHAR(MAX)='',
@FILTER2 VARCHAR(MAX)='',
@FILTER3 VARCHAR(MAX)='',
@FILTER4 VARCHAR(MAX)='',
@FILTER5 VARCHAR(MAX)=''

AS BEGIN

IF @PROCESS ='GET APP LIST'
BEGIN

--commented on 23 July 2018
--SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
--FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1
--UNION ALL
--SELECT ENTRYID,, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
--FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY=@FILTER1

--Added on 23 July 2018
SELECT ENTRYID,aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo, 0 as ISMF 
FROM  [DBO].[TBL_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1
UNION ALL
SELECT ENTRYID,'' as aadhaarNo, DOB,PAN,ISAPPROVED,ENTRY_DATE,ENTRYBY,MODIFY_DATE,MODIFY_BY,APPROVE_DATE,APPROVE_BY,Remark,IsInhouseIntegrated,RefNo,1 as ISMF 
FROM  [DBO].[TBL_MF_IDENTITYDETAILS] WHERE ENTRYBY= @FILTER1


END

IF @PROCESS ='GET EMP NAME'
BEGIN

SELECT EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL AND  EMP_NO=@FILTER1

END

IF @PROCESS ='GET MASTER DATA'
BEGIN

--SELECT RTRIM (LTRIM (REGIONCODE)) AS REGIONCODE,
--RTRIM (LTRIM (NBRANCHCODE)) AS NBRANCHCODE,
--RTRIM (LTRIM (ZONE)) AS ZONE,
--RTRIM (LTRIM (REG_CODE)) AS REG_CODE,
--RTRIM (LTRIM (REGION)) AS REGION,
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL 

--SELECT   A.*,B.BRANCHNAME,B.REGION FROM (SELECT DISTINCT ZONE,REGION AS REG_CODE ,BRANCH AS BR_CODE,REGION AS REGIONCODE, BRANCH AS NBRANCHCODE  FROM [196.1.115.182].GENERAL.DBO.VW_RMS_SB_VERTICAL ) A
--JOIN (SELECT 
--RTRIM (LTRIM (BR_CODE)) AS BR_CODE,
--RTRIM (LTRIM (BRANCHNAME)) AS BRANCHNAME,REGION FROM [INTRANET].RISK.DBO.ZONE_REGION_BRANCH WHERE REGION IS NOT NULL AND ZONE IS NOT NULL )B
--ON A.BR_CODE=B.BR_CODE 

SELECT   DUMMY1 AS ZONE,REGIONCODE AS REG_CODE,BRANCH_CODE AS  BR_CODE,REGIONCODE, BRANCH_CODE AS NBRANCHCODE,BRANCH_CODE AS BRANCHNAME,REGIONCODE AS REGION  
FROM [196.1.115.182].GENERAL.DBO.BO_REGION


SELECT EMP_NO,EMP_NAME FROM [INTRANET].RISK.DBO.EMP_INFO WHERE SEPARATIONDATE IS NULL

SELECT ISIN,SCRIPNAME FROM [196.1.115.182].GENERAL.DBO.SCRIP_MASTER WHERE 1=2

SELECT * FROM TBL_CONTRACTOR_SIGN

END

IF @PROCESS ='GET APP'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and PATH not like 'FTP://%'
SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1

SELECT * FROM TBL_UPDATEPROFILEPIC WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET APP ADMIN'
BEGIN



SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_ADDRESS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID=@FILTER1

SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0 and DOCTYPE like '%SBDOC%' and ISDELETE =0
UNION 
SELECT ID,ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE from [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF] where ENTRYID=@FILTER1 and ISDELETE =0
UNION
--SELECT A.ID,ENTRYID,A.FILENAME, replace(PATH,'ftp://172.31.16.251:23/','http://52.66.168.154:8989/ApplicationPDFs/eSignedPDFs/') AS PATH ,ISDELETE,B.DOCTYPE,A.EXCHANGE  
-- FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
--FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE 'FTP://%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A
--JOIN
--( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
--ON A.ID =B.ID 

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE 
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_SEGMENTS WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID=@FILTER1
SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@FILTER1
END

IF @PROCESS ='GET ALL APP OBJECTS'
BEGIN



--DECLARE @SQL AS VARCHAR(MAX)
--DECLARE @STR AS VARCHAR(50)=''
--SELECT @STR =@STR+','+ CAST(ENTRYID AS VARCHAR(50))  FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @FILTER1

--SELECT @STR=SUBSTRING (@STR ,2,LEN(@STR))

--SET @SQL ='SELECT * FROM TBL_BASICDETAILS  WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_BANKDETAILS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_CASHDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_ADDRESS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_INFRASTRUCTURE WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_REGISTRATIONRELATED WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID IN ('+@STR+') AND ISDELETE =0
--SELECT * FROM TBL_AGREEDDEPOSITS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_SEGMENTS WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_NONCASHDEPOSIT WHERE ENTRYID IN ('+@STR+')
--SELECT * FROM TBL_IDENTITYDETAILS WHERE ENTRYID IN ('+@STR+')'

--EXEC  (@SQL)

declare @Emp_No varchar(50)

 select @Emp_No = emp_no    
 from  [INTRANET].[RISK].[dbo].[emp_info]     
 where email like @FILTER1 + '@angelbroking.com' 
 and SeparationDate is null
 
 SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYBY = @Emp_No



END

IF @PROCESS ='GET FILES'
BEGIN

SELECT ID, CAST (ENTRYID AS VARCHAR(50)) AS ENTRYID,FILENAME,PATH,ISDELETE,DOCTYPE,EXCHANGE FROM TBL_DOCUMENTSUPLOAD WHERE ENTRYID=@FILTER1 AND ISDELETE =0

END

IF @PROCESS ='ADD REQUEST'
BEGIN

INSERT INTO [TBL_SENDREQUEST] (MOBILE,FLAG,USERID)
SELECT SUBSTRING (@FILTER1,CHARINDEX (',',@FILTER1)+1,LEN(@FILTER1)),0,SUBSTRING (@FILTER1,0,CHARINDEX (',',@FILTER1))

END


IF @PROCESS ='CHECK PAN'
BEGIN




SELECT COUNT(1) AS CNT  FROM TBL_IDENTITYDETAILS WHERE PAN=@FILTER1



END


--IF @PROCESS ='GET EMP'
--BEGIN

--declare @partycode as varchar(500)=''
--declare @CLIENTNAME as varchar(500)=''
-- SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock))C
--JOIN 
--(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0) A
--JOIN 
--(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1 AND FLAG=0)B
--ON A.ID=B.ID)D
--ON C.PHONE=D.MOBILE

--set @partycode= substring( @partycode,2,len(@partycode))

--select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME



--END


IF @PROCESS ='GET EMP'
BEGIN

		declare @partycode as varchar(500)=''
		declare @CLIENTNAME as varchar(500)='',@SbCode varchar(50)

		select @SbCode=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


		SELECT  @partycode=@partycode+','+  C.party_code,@CLIENTNAME=C.CLIENTNAME FROM (select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) where last_inactive_date>GETDATE() and sub_broker

=@SbCode)C
		JOIN 
		(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM (SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM TBL_SENDREQUEST WHERE FLAG=0 and USERID like @FILTER1 ) A
		JOIN 
		(SELECT MAX(ID) AS ID FROM TBL_SENDREQUEST WHERE  USERID=@FILTER1  AND FLAG=0)B
		ON A.ID=B.ID)D
		ON C.PHONE=D.MOBILE

		set @partycode= substring( @partycode,2,len(@partycode))

		select @partycode AS partycode ,@CLIENTNAME AS CLIENTNAME

		UPDATE TBL_SENDREQUEST
		set FLAG=1
		where USERID=@FILTER1
END


		IF @PROCESS ='GET EMP V2'
		BEGIN

				declare @partycodeV2 as varchar(500)=''
				declare @CLIENTNAMEV2 as varchar(500)='',
				@SbCodeV2 varchar(50)

				select @SbCodeV2=access_code from intranet.rolemgm.dbo.user_login with(nolock) where username=@FILTER1


				SELECT  @partycodeV2=@partycodeV2+','+  C.party_code,@CLIENTNAMEV2=C.CLIENTNAME FROM 
					(select party_code,mobile_pager as PHONE,short_name AS CLIENTNAME from [196.1.115.132].RISK.DBO.client_details with(nolock) 
					where last_inactive_date>GETDATE() and sub_broker=@SbCodeV2)C
				JOIN 
					(SELECT CASE WHEN LEN( MOBILE)=12 THEN SUBSTRING(MOBILE,3,LEN(MOBILE)) ELSE  MOBILE END AS MOBILE FROM 
						(SELECT RTRIM( LTRIM (MOBILE)) AS MOBILE,ID FROM [risk].dbo.TBL_SENDREQUEST_v2 WHERE FLAG=0 and USERID like @FILTER1 and NotificationID=@FILTER2 and IMEI = @FILTER3) A
				JOIN 
				(SELECT ID AS ID FROM [risk].dbo.TBL_SENDREQUEST_v2 WHERE  USERID=@FILTER1  AND FLAG=0 and NotificationID =@FILTER2 and IMEI = @FILTER3)B
				ON A.ID=B.ID)D
				ON C.PHONE=D.MOBILE

				set @partycodeV2= substring( @partycodeV2,2,len(@partycodeV2))

				select @partycodeV2 AS partycode ,@CLIENTNAMEV2 AS CLIENTNAME

				UPDATE [risk].dbo.TBL_SENDREQUEST_V2
				set FLAG=1
				where USERID=@FILTER1 and NotificationID =@FILTER2 and IMEI = @FILTER3
				
		END
		IF @PROCESS ='InsertMobileNo'
		BEGIN

		declare @mobCount int
		

		if exists(select * from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry with(nolock) where PartyCode = @FILTER1 and NewMobileNo = @FILTER2)
			BEGIN
				select msg=3
			END
		else
			BEGIN 
			--select @mobCount= COUNT(newmobileno) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry nolock where newmobileno = @FILTER2 and Sub_Broker=@FILTER3  group by newmobileno
			select @mobCount= COUNT(newmobileno) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry nolock where newmobileno = @FILTER2 group by newmobileno
			if (isnull(@mobCount,0) < 3)
				begin
					INSERT into [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry (Partycode , NewMobileNo,Sub_Broker)
					values (@FILTER1,@FILTER2,@FILTER3)

					select msg = 1 --'Mobile No Save Successfully.'
				end
				else
				begin
					select msg = 2 --'You can not save same numbers more than 3 client'
				end
			END

		END

	    IF @PROCESS ='CkeckMobileNumberCount'
		BEGIN

		if (Select count(1) from [172.31.16.95].NXT.DBO.NXT_CustomerMobileNoEntry with(nolock) where partycode = @FILTER1 ) >= 6 
		Begin

		Select 'NO'

		End
		Else

		Begin
		Select 'Yes'
		END

		END

		IF @PROCESS ='GET EMP V3'
		BEGIN



			EXEC USP_SBGETDATA__GETEMPV3 
					@PROCESS=@PROCESS,
					@FILTER1=@FILTER1,
					@FILTER2=@FILTER2,
					@FILTER3=@FILTER3,
					@FILTER4=@FILTER4,
					@FILTER5 =@FILTER5 



		END



		
IF @PROCESS ='GETREJECTION'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REJECTION AS ValueName  FROM TBL_REJECTION 

END

IF @PROCESS ='GETREJECTIONREASON'
BEGIN

SELECT CAST (ID AS VARCHAR(50)) AS KeyName , REASON AS ValueName FROM TBL_REJECTION_REASON WHERE REJID= @FILTER1

END


IF @PROCESS ='DELETE CALL LOG'
BEGIN

UPDATE  TBL_SENDREQUEST
SET flag=1
 WHERE USERID=@FILTER1

SELECT 1 
END


IF @PROCESS ='GET QR CODE'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID FROM [risk].dbo.TBL_USER_QRCODE with(nolock) WHERE QRCODE=@filter1

END

IF @PROCESS ='GET QR CODE V2'
BEGIN

--SELECT USERID FROM TBL_USER_QRCODE WHERE QRCODE='4bc66bef-8938-4d8d-b82d-cb7ecc3a6a01'
SELECT USERID,QRCODE,NotificationID,IMEI,DeviceType,timestamp FROM [risk].dbo.TBL_USER_QRCODE_v2 WHERE QRCODE=@filter1

END


IF @PROCESS ='CHECK AADHAR'
BEGIN
DECLARE @CNTER AS INT =0

SELECT @CNTER=COUNT(1) FROM TBL_IDENTITYDETAILS WHERE AADHAARNO=@FILTER1

SELECT @CNTER AS CNT 

END

IF @PROCESS ='GET FEFMEMBER DETAILS'
BEGIN


 EXEC INTRANET.MISC.DBO.FEF_GET_MEMBERALLDETAILS_WCF @FILTER1

END


IF @PROCESS ='GETFEFTRAINERDETAILS LIST'
BEGIN


 EXEC INTRANET.MISC.DBO.FEE_GetAllTrainers 

END

IF @PROCESS ='FINALSUBMIT'
BEGIN


                    UPDATE TBL_IDENTITYDETAILS
					SET ISAPPROVED=4
					WHERE  ENTRYID=@FILTER1

					SELECT @FILTER1  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

END

IF @PROCESS ='GET ESIGN DOCUMENTS'
BEGIN

SELECT A.ID,ENTRYID,B.FILENAME, REPLACE(PATH,'\\172.31.16.251\APPLICATIONPDF\','HTTP://SB.ANGELBACKOFFICE.COM:8088/SB_REGISTRATION_FILES/APPLICATIONESIGN/') AS PATH ,ISDELETE,A.FILENAME AS DOCTYPE,A.EXCHANGE  
FROM (SELECT FILENAME ,PATH ,DOCTYPE,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID  ,ISDELETE ,ENTRYID,EXCHANGE 
FROM TBL_DOCUMENTSUPLOAD WHERE PATH LIKE '\\172.31.16.251\APPLICATIONPDF\%' AND ENTRYID =@FILTER1 AND ISDELETE =0)A

JOIN
( SELECT FILENAME ,ROW_NUMBER ()OVER(ORDER BY (SELECT 1)) AS ID,DOCTYPE   FROM TBL_ESIGNDOCUMENTS WHERE ENTRYID=@FILTER1 AND ISDELETE =0)B
ON A.ID =B.ID 

END

IF @PROCESS ='VALIDATE USER'
BEGIN

            DECLARE @CNT  AS INT =0
			DECLARE @USERID AS VARCHAR(50)=SUBSTRING(@FILTER1,0, CHARINDEX( ',',@FILTER1))
			DECLARE @PWD AS VARCHAR(50)=SUBSTRING(@FILTER1,CHARINDEX( ',',@FILTER1)+1, LEN(@FILTER1))

		


            SELECT @CNT= COUNT(1) FROM  [196.1.115.132].ROLEMGM.dbo.user_login   WHERE username=@USERID AND userpassword=@PWD

			IF(@CNT>0)
			BEGIN
			SELECT 'true' as result

			END
			ELSE
			BEGIN
			SELECT 'false' as result

			END

END



END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEGMENTS
-- --------------------------------------------------



CREATE PROC [dbo].[USP_SEGMENTS]
@ENTRYID INT=0,
@BSECASH BIT=0,
@NSECASH BIT =0,
@NSEFNO BIT =0,
@NSECURRENCY BIT=0,
@MCX BIT=0,
@NCDEX BIT =0

AS BEGIN 

		BEGIN TRY

		IF NOT EXISTS (SELECT ENTRYID FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID )
		BEGIN

		INSERT INTO TBL_SEGMENTS
		SELECT @ENTRYID,@BSECASH,@NSECASH,@NSEFNO,@NSECURRENCY,@MCX,@NCDEX

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
		BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		ELSE 
		BEGIN

		UPDATE TBL_SEGMENTS
		SET BSECASH=@BSECASH,
		NSECASH=@NSECASH,
		NSEFNO=@NSEFNO,
		NSECURRENCY=@NSECURRENCY,
		MCX=@MCX,
		NCDEX=@NCDEX
		WHERE ENTRYID=@ENTRYID

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		

		END TRY
		BEGIN CATCH

		 SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SEGMENTS_30102017
-- --------------------------------------------------



create PROC [dbo].[USP_SEGMENTS_30102017]
@ENTRYID INT=0,
@BSECASH BIT=0,
@NSECASH BIT =0,
@NSEFNO BIT =0,
@NSECURRENCY BIT=0,
@MCX BIT=0

AS BEGIN 

		BEGIN TRY

		IF NOT EXISTS (SELECT ENTRYID FROM TBL_SEGMENTS WHERE ENTRYID=@ENTRYID )
		BEGIN

		INSERT INTO TBL_SEGMENTS
		SELECT @ENTRYID,@BSECASH,@NSECASH,@NSEFNO,@NSECURRENCY,@MCX

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		ELSE IF EXISTS (SELECT ENTRYID FROM TBL_IDENTITYDETAILS WHERE ENTRYID=@ENTRYID AND ISAPPROVED  IN (1,4))
		BEGIN

			SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		ELSE 
		BEGIN

		UPDATE TBL_SEGMENTS
		SET BSECASH=@BSECASH,
		NSECASH=@NSECASH,
		NSEFNO=@NSEFNO,
		NSECURRENCY=@NSECURRENCY,
		MCX=@MCX
		WHERE ENTRYID=@ENTRYID

		SELECT @ENTRYID  AS ENTRYID, 'SUCCESS' AS [MESSAGE] 

		END
		

		END TRY
		BEGIN CATCH

		 SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 

		END CATCH


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SENDBULKSMS
-- --------------------------------------------------
CREATE PROC [dbo].[USP_SENDBULKSMS]
@SMSDATA AS TB_BULKSMS READONLY
AS BEGIN

DELETE FROM [INTRANET].MISC.DBO.TBL_BULKSMS 

INSERT INTO [INTRANET].MISC.DBO.TBL_BULKSMS(MOBILENO,MESSAGE)
SELECT MOBILENO,MESSAGE FROM @SMSDATA

INSERT INTO SMS.DBO.SMS(to_no,message,date,time,flag,ampm,purpose)
SELECT MOBILENO,MESSAGE,Convert(varchar,getdate(),103),CONVERT(VARCHAR(5), GETDATE(), 108),'P',RIGHT(CONVERT(VARCHAR(30), GETDATE(), 9),2),'WellnessPromo' FROM [INTRANET].MISC.DBO.TBL_BULKSMS

SELECT 'SUCCESS' as RESULT

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UI_GET_DEFAULT_WATCHLIST
-- --------------------------------------------------
CREATE PROC [dbo].[USP_UI_GET_DEFAULT_WATCHLIST]
AS BEGIN

SELECT * FROM [dbo].[tbl_defaultScript]

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Update_EsignDeleted
-- --------------------------------------------------

CREATE PROCEDURE USP_Update_EsignDeleted
	@EntryID varchar(50)
AS
BEGIN
	
	Update TBL_MF_ESIGNDOCUMENTS
set ISPHYSICALLYDELETED = 1
where ENTRYID = @EntryID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateEsignDetails
-- --------------------------------------------------
    
-- =============================================    

-- Create date: <09 April 2018>    
-- Description: <After Esign Update The details>    
-- =============================================    
CREATE PROCEDURE [dbo].[USP_UpdateEsignDetails]     
@EntryID INT,    
@OldFileName varchar(200)='',    
@NewFileName varchar(200)='',    
@SourceID varchar(50)='',     
@employee_code varchar(50)='',     
@ipAddress varchar(50)='',     
@rm varchar(500)='',
@eSignNameCSO varchar(200)=''       
AS    
BEGIN    
		UPDATE TBL_MF_ESIGNDOCUMENTS SET isEsign=1,rm=@rm,sourceid=@SourceID,Modifiedon=GETDATE(),    
		modifiedby=@EntryID,NewFileName=@NewFileName 
		,eSignNameCSO = @eSignNameCSO
		where EntryID=@EntryID AND FILENAME=@OldFileName    
		    
		DECLARE @TotalFileCount INT,@TotalEsignFileCount INT     
		SET @TotalFileCount=(Select Count(1) from TBL_MF_ESIGNDOCUMENTS where EntryID=@EntryID)    
		SET @TotalEsignFileCount=(Select Count(1) from TBL_MF_ESIGNDOCUMENTS where EntryID=@EntryID AND isEsign=1)    
		    
		IF @TotalFileCount=@TotalEsignFileCount    
		BEGIN    
		UPDATE TBL_MF_IDENTITYDETAILS SET ISAPPROVED = 4 WHERE  EntryID=@EntryID    
		END    
		    
		Select @EntryID    
		
		EXEC usp_mfapplicationlog @ENTRYID,'MF CSO ESIGN COMPLETED','CSO',@employee_code,@ipAddress  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPDATEPROFILEPIC
-- --------------------------------------------------
CREATE PROC [dbo].[USP_UPDATEPROFILEPIC]
@ENTRYID INT =0,
@ID INT =0,
@PIC VARCHAR(100)=''
AS BEGIN

BEGIN TRY


		IF EXISTS (SELECT ENTRYID FROM TBL_UPDATEPROFILEPIC WHERE  ENTRYID=@ENTRYID)
		BEGIN

					UPDATE TBL_UPDATEPROFILEPIC
					SET PIC=@PIC
					WHERE  ENTRYID=@ENTRYID

			        SELECT ENTRYID,'SUCCESS'  AS [MESSAGE] FROM TBL_IDENTITYDETAILS WHERE  ENTRYID=@ENTRYID

		END

		ELSE
		BEGIN

		--INSERT

		INSERT INTO TBL_UPDATEPROFILEPIC(ENTRYID,PIC)
		VALUES(@ENTRYID,@PIC)

		SELECT SCOPE_IDENTITY()  AS ENTRYID, 'SUCCESS' AS [MESSAGE]

		END

		END TRY
		BEGIN CATCH
		         SELECT -1  AS ENTRYID, 'FAILED' AS [MESSAGE] 
		END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateSbTag
-- --------------------------------------------------
    
-- =============================================    

-- Create date: <09 April 2018>    
-- Description: <After Esign Update The details>    
-- =============================================    
Create PROCEDURE [dbo].[USP_UpdateSbTag]     
@EntryID INT  
AS    
BEGIN    
  
  
UPDATE TBL_MF_IDENTITYDETAILS SET ISAPPROVED = 6 WHERE  EntryID=@EntryID    
  
Select 1    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOADRECORDS
-- --------------------------------------------------
CREATE PROC [dbo].[USP_UPLOADRECORDS]
@PROCESS AS VARCHAR(50)='',
@FILENAME AS VARCHAR(50)='',
@MOB AS VARCHAR(50)='',
@STATUS AS VARCHAR(25)='',
@USERID AS VARCHAR(50)='',
@RECORDING AS VARCHAR(200)=''
AS BEGIN

IF(@PROCESS='ADD RECORD')
BEGIN



INSERT INTO TBL_RECORDING(MOBILE,FLAG,USERID,CALLSTATUS,RECORDING)
SELECT @MOB,0,@USERID,@STATUS,@RECORDING

SELECT 'SUCCESS'

END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateEmployee
-- --------------------------------------------------
-- =============================================

-- Author:		Suraj PAtil

-- Create date: 11 Jan 2018

-- Description:	To validate user from harmoney database

-- =============================================

CREATE PROCEDURE [dbo].[USP_ValidateEmployee]

	@username as  varchar(100),

	@password as  varchar(100)

	

AS

BEGIN

	

 exec [196.1.115.237].angelbroking.dbo.[ValidateUser] @username,@password --'E62250','1q2w3' 

 

 	

END

GO

-- --------------------------------------------------
-- TABLE dbo.ChatUsers
-- --------------------------------------------------
CREATE TABLE [dbo].[ChatUsers]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [username] VARCHAR(100) NULL,
    [userid] VARCHAR(100) NULL,
    [connectionid] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DiyKyc_KRAResponse
-- --------------------------------------------------
CREATE TABLE [dbo].[DiyKyc_KRAResponse]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [DiyKycId] BIGINT NULL,
    [PANNO] VARCHAR(50) NULL,
    [DOB] VARCHAR(15) NULL,
    [StatusCode] VARCHAR(10) NULL,
    [CreatedDate] DATETIME NULL,
    [AgenCyName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FEF_ServiceLog
-- --------------------------------------------------
CREATE TABLE [dbo].[FEF_ServiceLog]
(
    [membercode] VARCHAR(20) NULL,
    [SP_Name] VARCHAR(100) NULL,
    [SP_Calling] DATETIME NULL,
    [SP_Response] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_broker
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_broker]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [SBTAG] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_accesscontrol
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_accesscontrol]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [USERID] VARCHAR(30) NULL,
    [modifydate] DATETIME NULL,
    [modifyby] VARCHAR(50) NULL,
    [AddedBy] VARCHAR(50) NULL,
    [addedon] DATETIME NULL DEFAULT (getdate()),
    [isactive] INT NULL DEFAULT ((0)),
    [MenuAccess] VARCHAR(50) NULL,
    [AadharVaultKey] VARCHAR(500) NULL,
    [referenceKey] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_accesscontrol_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_accesscontrol_log]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [USERID] VARCHAR(30) NULL,
    [modifydate] DATETIME NULL,
    [modifyby] VARCHAR(50) NULL,
    [AddedBy] VARCHAR(50) NULL,
    [addedon] DATETIME NULL DEFAULT (getdate()),
    [isactive] INT NULL DEFAULT ((0)),
    [MenuAccess] VARCHAR(50) NULL,
    [operation] VARCHAR(100) NULL,
    [Logdate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ADDRESS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ADDRESS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [ADDRESS1] VARCHAR(200) NULL,
    [ADDRESS2] VARCHAR(200) NULL,
    [ADDRESS3] VARCHAR(200) NULL,
    [AREA] VARCHAR(50) NULL,
    [CITY] VARCHAR(50) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [MOBILE] VARCHAR(50) NULL,
    [PHONE] VARCHAR(50) NULL,
    [PIN] VARCHAR(50) NULL,
    [STATE] VARCHAR(50) NULL,
    [STD] VARCHAR(50) NULL,
    [ISPERMANENT] BIT NULL,
    [SAMEASCORR] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_AGREEDDEPOSITS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_AGREEDDEPOSITS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [CASHAGREEDDEPOSIT] VARCHAR(50) NULL,
    [INTERMEDIARY] VARCHAR(50) NULL,
    [NONCASHAGREEDDEPOSIT] VARCHAR(50) NULL,
    [NOTES] VARCHAR(200) NULL,
    [VERTICAL] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_APPLICATIONSTATUSMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_APPLICATIONSTATUSMASTER]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [STATUS_CODE] INT NULL,
    [STATUS] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BANKDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BANKDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [ACCOUNTNO] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(10) NULL,
    [ADDRESS] VARCHAR(500) NULL,
    [BANKNAME] VARCHAR(100) NULL,
    [BRANCH] VARCHAR(50) NULL,
    [IFSCRGTS] VARCHAR(50) NULL,
    [MICR] VARCHAR(50) NULL,
    [NAMEINBANK] VARCHAR(100) NULL,
    [ISCOMMODITY] BIT NULL,
    [sameAs] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_BASICDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_BASICDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FATHERFIRSTNAME] VARCHAR(100) NULL,
    [FATHERLASTNAME] VARCHAR(100) NULL,
    [FATHERMIDDLENAME] VARCHAR(100) NULL,
    [FIRSTNAME] VARCHAR(100) NULL,
    [GENDER] VARCHAR(10) NULL,
    [HUSBANDFIRSTNAME] VARCHAR(100) NULL,
    [HUSBANDLASTNAME] VARCHAR(100) NULL,
    [HUSBANDMIDDLENAME] VARCHAR(100) NULL,
    [INCORPORATIONDATE] VARCHAR(100) NULL,
    [INTERMEDIARYBRANCH] VARCHAR(100) NULL,
    [INTERMEDIARYCODE] VARCHAR(100) NULL,
    [INTERMEDIARYEMPLOYEE] VARCHAR(100) NULL,
    [INTERMEDIARYNAME] VARCHAR(100) NULL,
    [INTERMEDIARYTYPE] VARCHAR(100) NULL,
    [LASTNAME] VARCHAR(100) NULL,
    [MARTIALSTATUS] VARCHAR(100) NULL,
    [MIDDLENAME] VARCHAR(100) NULL,
    [PARENT] VARCHAR(100) NULL,
    [REGION] VARCHAR(100) NULL,
    [RELATIONSHIPMGR] VARCHAR(100) NULL,
    [TRADENAME] VARCHAR(100) NULL,
    [TRADENAMECOMM] VARCHAR(100) NULL,
    [ZONE] VARCHAR(100) NULL,
    [sbtag] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CASHDEPOSITS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CASHDEPOSITS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [ACCOUNTNO] VARCHAR(50) NULL,
    [AMOUNT] VARCHAR(100) NULL,
    [BROKERBANKACC] VARCHAR(100) NULL,
    [DATE] VARCHAR(50) NULL,
    [DEPOSITMODE] VARCHAR(50) NULL,
    [DEPOSITTRANSACTIONSTATUS] VARCHAR(50) NULL,
    [FORMOFDEPOSIT] VARCHAR(50) NULL,
    [INSTRUMENTNO] VARCHAR(50) NULL,
    [INTERMBANKACC] VARCHAR(50) NULL,
    [INTERMEDIARY] VARCHAR(50) NULL,
    [REMARKS] VARCHAR(200) NULL,
    [SEGMENT] VARCHAR(50) NULL,
    [TYPE] VARCHAR(50) NULL,
    [VERTICAL] VARCHAR(50) NULL,
    [VOUCHERNO] VARCHAR(50) NULL,
    [VOUCHERTYPE] VARCHAR(50) NULL,
    [ISNONCASH] BIT NULL,
    [isDeposit] BIT NULL,
    [sameAs] BIT NULL,
    [SEGMENTADD] VARCHAR(100) NULL,
    [DEPOSITMODEADD] VARCHAR(100) NULL,
    [DEPOSITTRNSTATUSADD] VARCHAR(100) NULL,
    [AMOUNTADD] VARCHAR(100) NULL,
    [INSTRUMENTNOADD] VARCHAR(100) NULL,
    [DATEADD] VARCHAR(100) NULL,
    [REMARKSADD] VARCHAR(100) NULL,
    [SEGMENTNSE] VARCHAR(100) NULL,
    [DEPOSITMODENSE] VARCHAR(100) NULL,
    [DEPOSITTRNSTATUSNSE] VARCHAR(100) NULL,
    [AMOUNTNSE] VARCHAR(100) NULL,
    [INSTRUMENTNONSE] VARCHAR(100) NULL,
    [DATENSE] VARCHAR(100) NULL,
    [REMARKSNSE] VARCHAR(100) NULL,
    [SEGMENTMCX] VARCHAR(100) NULL,
    [DEPOSITMODEMCX] VARCHAR(100) NULL,
    [DEPOSITTRNSTATUSMCX] VARCHAR(100) NULL,
    [AMOUNTMCX] VARCHAR(100) NULL,
    [INSTRUMENTNOMCX] VARCHAR(100) NULL,
    [DATEMCX] VARCHAR(100) NULL,
    [REMARKSMCX] VARCHAR(100) NULL,
    [SAMEASABOVE] BIT NULL,
    [SEGMENTNCDEX] VARCHAR(100) NULL,
    [DEPOSITMODENCDEX] VARCHAR(100) NULL,
    [DEPOSITTRNSTATUSNCDEX] VARCHAR(100) NULL,
    [AMOUNTNCDEX] VARCHAR(100) NULL,
    [INSTRUMENTNONCDEX] VARCHAR(100) NULL,
    [DATENCDEX] VARCHAR(100) NULL,
    [REMARKSNCDEX] VARCHAR(100) NULL,
    [SAMEASMCX] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ChatHistroy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ChatHistroy]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [SupportUserId] INT NOT NULL,
    [UserName] VARCHAR(100) NULL,
    [UserUniqueId] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_CONTRACTOR_SIGN
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_CONTRACTOR_SIGN]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [STATE] VARCHAR(50) NULL,
    [AUTH] VARCHAR(100) NULL,
    [ECODE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DOCUMENTSUPLOAD
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DOCUMENTSUPLOAD]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DOCUMENTSUPLOAD_PDF
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DOCUMENTSUPLOAD_PDF]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DOCUMENTSUPLOADFINAL_PDF
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DOCUMENTSUPLOADFINAL_PDF]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_EsignDocNumber
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_EsignDocNumber]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [DocType] VARCHAR(50) NOT NULL,
    [DocNo] VARCHAR(50) NOT NULL,
    [addedon] DATETIME NULL DEFAULT (getdate()),
    [UserType] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_ESIGNDOCUMENTS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_ESIGNDOCUMENTS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SOURCE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Exception_log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Exception_log]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Source] VARCHAR(30) NULL,
    [Message] VARCHAR(300) NULL,
    [StackTrace] VARCHAR(1000) NULL,
    [UserId] VARCHAR(50) NULL,
    [OccuredOn] DATETIME NULL,
    [Isresolved] BIT NULL,
    [ResolvedBy] VARCHAR(50) NULL,
    [ResolvedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_IDENTITYDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_IDENTITYDETAILS]
(
    [ENTRYID] INT IDENTITY(1,1) NOT NULL,
    [AADHAARNO] VARCHAR(50) NULL,
    [DOB] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [ISAPPROVED] INT NULL,
    [ENTRY_DATE] DATETIME NULL,
    [ENTRYBY] VARCHAR(50) NULL,
    [MODIFY_DATE] DATETIME NULL,
    [MODIFY_BY] VARCHAR(50) NULL,
    [APPROVE_DATE] DATETIME NULL,
    [APPROVE_BY] VARCHAR(50) NULL,
    [Remark] VARCHAR(5000) NULL,
    [IsInhouseIntegrated] INT NULL DEFAULT ((0)),
    [RefNo] NUMERIC(18, 0) NULL,
    [U_ID] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_INFRASTRUCTURE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_INFRASTRUCTURE]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [MAINOFFICE] VARCHAR(50) NULL,
    [INCOMERANGE] VARCHAR(50) NULL,
    [OFFICEFRONTFACING] VARCHAR(5) NULL,
    [OFFICEGROUNDFLOOR] VARCHAR(5) NULL,
    [SOCIALNETWORKING] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Menudetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Menudetails]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Menu] VARCHAR(50) NULL,
    [Handler] VARCHAR(250) NULL,
    [ParentId] INT NOT NULL,
    [seq_no] INT NULL,
    [active] VARCHAR(1) NULL,
    [menu_desc] VARCHAR(250) NULL,
    [CreatedBy] VARCHAR(20) NULL,
    [CreatedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(20) NULL,
    [ModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ADDRESS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ADDRESS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [ADDRESS1] VARCHAR(200) NULL,
    [ADDRESS2] VARCHAR(200) NULL,
    [ADDRESS3] VARCHAR(200) NULL,
    [AREA] VARCHAR(50) NULL,
    [CITY] VARCHAR(50) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [MOBILE] VARCHAR(50) NULL,
    [PHONE] VARCHAR(50) NULL,
    [PIN] VARCHAR(50) NULL,
    [STATE] VARCHAR(50) NULL,
    [STD] VARCHAR(50) NULL,
    [ISPERMANENT] BIT NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [IsSameAsAadhaar] BIT NULL,
    [IsSameAsPermanent] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ADDRESS_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ADDRESS_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ADDRESSID] INT NOT NULL,
    [ENTRYID] INT NOT NULL,
    [ADDRESS1] VARCHAR(200) NULL,
    [ADDRESS2] VARCHAR(200) NULL,
    [ADDRESS3] VARCHAR(200) NULL,
    [AREA] VARCHAR(50) NULL,
    [CITY] VARCHAR(50) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [MOBILE] VARCHAR(50) NULL,
    [PHONE] VARCHAR(50) NULL,
    [PIN] VARCHAR(50) NULL,
    [STATE] VARCHAR(50) NULL,
    [STD] VARCHAR(50) NULL,
    [ISPERMANENT] BIT NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [IsSameAsAadhaar] BIT NULL,
    [IsSameAsPermanent] BIT NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_Applicationlog
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_Applicationlog]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL DEFAULT (getdate()),
    [employee_code] VARCHAR(50) NOT NULL DEFAULT '',
    [ipAddress] VARCHAR(100) NOT NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_Applicationlog_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_Applicationlog_19_Aug_2019]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL,
    [employee_code] VARCHAR(50) NOT NULL,
    [ipAddress] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ARNDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ARNDetails]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [EntryID] INT NULL,
    [IsARN] BIT NULL,
    [ARN_Number] VARCHAR(200) NULL,
    [FirstName] VARCHAR(100) NULL,
    [MiddleName] VARCHAR(100) NULL,
    [LastName] VARCHAR(100) NULL,
    [UploadFiles] VARCHAR(MAX) NULL,
    [Exam_tentative_FromDate] DATE NULL,
    [Exam_tentative_ToDate] DATE NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [ARN_FromDate] DATE NULL,
    [ARN_ToDate] DATE NULL,
    [EUINumber] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ARNDetails_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ARNDetails_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [EntryID] INT NULL,
    [IsARN] BIT NULL,
    [ARN_Number] VARCHAR(200) NULL,
    [FirstName] VARCHAR(100) NULL,
    [MiddleName] VARCHAR(100) NULL,
    [LastName] VARCHAR(100) NULL,
    [UploadFiles] VARCHAR(MAX) NULL,
    [Exam_tentative_FromDate] DATE NULL,
    [Exam_tentative_ToDate] DATE NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [ARN_FromDate] DATE NULL,
    [ARN_ToDate] DATE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ARNDetails_Archival
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ARNDetails_Archival]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ARNID] INT NOT NULL,
    [EntryID] INT NULL,
    [IsARN] BIT NULL,
    [ARN_Number] VARCHAR(200) NULL,
    [FirstName] VARCHAR(100) NULL,
    [MiddleName] VARCHAR(100) NULL,
    [LastName] VARCHAR(100) NULL,
    [UploadFiles] VARCHAR(MAX) NULL,
    [Exam_tentative_FromDate] DATE NULL,
    [Exam_tentative_ToDate] DATE NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [ARN_FromDate] DATE NULL,
    [ARN_ToDate] DATE NULL,
    [EUINumber] VARCHAR(100) NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_BANKDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_BANKDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [ACCOUNTNO] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(10) NULL,
    [ADDRESS] VARCHAR(500) NULL,
    [BANKNAME] VARCHAR(100) NULL,
    [BRANCH] VARCHAR(50) NULL,
    [IFSCRGTS] VARCHAR(50) NULL,
    [MICR] VARCHAR(50) NULL,
    [NAMEINBANK] VARCHAR(100) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_BANKDETAILS_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_BANKDETAILS_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [BANKID] INT NOT NULL,
    [ENTRYID] INT NULL,
    [ACCOUNTNO] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(10) NULL,
    [ADDRESS] VARCHAR(500) NULL,
    [BANKNAME] VARCHAR(100) NULL,
    [BRANCH] VARCHAR(50) NULL,
    [IFSCRGTS] VARCHAR(50) NULL,
    [MICR] VARCHAR(50) NULL,
    [NAMEINBANK] VARCHAR(100) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_BASICDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_BASICDETAILS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [Salutation] VARCHAR(20) NULL,
    [FIRSTNAME] VARCHAR(100) NULL,
    [MIDDLENAME] VARCHAR(100) NULL,
    [LASTNAME] VARCHAR(100) NULL,
    [MobileNO] VARCHAR(20) NULL,
    [EmailID] VARCHAR(100) NULL,
    [OrganizationType] VARCHAR(100) NULL,
    [TradeName] VARCHAR(500) NULL,
    [Photo] VARCHAR(MAX) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [martialStatus] VARCHAR(50) NULL,
    [Gender] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_BASICDETAILS_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_BASICDETAILS_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [BASICID] INT NOT NULL,
    [ENTRYID] INT NULL,
    [Salutation] VARCHAR(20) NULL,
    [FIRSTNAME] VARCHAR(100) NULL,
    [MIDDLENAME] VARCHAR(100) NULL,
    [LASTNAME] VARCHAR(100) NULL,
    [MobileNO] VARCHAR(20) NULL,
    [EmailID] VARCHAR(100) NULL,
    [OrganizationType] VARCHAR(100) NULL,
    [TradeName] VARCHAR(500) NULL,
    [Photo] VARCHAR(MAX) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [martialStatus] VARCHAR(50) NULL,
    [Gender] VARCHAR(50) NULL,
    [BranchTag] VARCHAR(20) NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [DocumentID] INT NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD_PDF
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD_PDF_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOAD_PDF_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOAD_PDF_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [DocumentID] INT NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOADFINAL_PDF
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_DOCUMENTSUPLOADFINAL_PDF_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_DOCUMENTSUPLOADFINAL_PDF_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ESIGNDOCUMENTS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ESIGNDOCUMENTS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SOURCE] VARCHAR(50) NULL,
    [isEsign] INT NULL DEFAULT ((0)),
    [rm] VARCHAR(1000) NULL,
    [sourceid] VARCHAR(50) NULL,
    [Addedon] DATETIME NULL,
    [addedby] VARCHAR(50) NULL,
    [Modifiedon] DATETIME NULL,
    [modifiedby] VARCHAR(50) NULL,
    [NewFileName] VARCHAR(200) NULL,
    [ISPHYSICALLYDELETED] INT NULL DEFAULT ((0)),
    [ESIGNNAME] VARCHAR(200) NULL,
    [ESIGNNAMECSO] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ESIGNDOCUMENTS_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ESIGNDOCUMENTS_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SOURCE] VARCHAR(50) NULL,
    [isEsign] INT NULL,
    [rm] VARCHAR(1000) NULL,
    [sourceid] VARCHAR(50) NULL,
    [Addedon] DATETIME NULL,
    [addedby] VARCHAR(50) NULL,
    [Modifiedon] DATETIME NULL,
    [modifiedby] VARCHAR(50) NULL,
    [NewFileName] VARCHAR(200) NULL,
    [ISPHYSICALLYDELETED] INT NULL,
    [ESIGNNAME] VARCHAR(200) NULL,
    [ESIGNNAMECSO] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_ESIGNDOCUMENTS_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_ESIGNDOCUMENTS_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ESIGNDOCUMENTSID] INT NOT NULL,
    [ENTRYID] INT NULL,
    [FILENAME] VARCHAR(100) NULL,
    [PATH] VARCHAR(200) NULL,
    [ISDELETE] INT NULL,
    [DOCTYPE] VARCHAR(50) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SOURCE] VARCHAR(50) NULL,
    [isEsign] INT NULL,
    [rm] VARCHAR(1000) NULL,
    [sourceid] VARCHAR(50) NULL,
    [Addedon] DATETIME NULL,
    [addedby] VARCHAR(50) NULL,
    [Modifiedon] DATETIME NULL,
    [modifiedby] VARCHAR(50) NULL,
    [NewFileName] VARCHAR(200) NULL,
    [ESIGNNAME] VARCHAR(200) NULL,
    [ESIGNNAMECSO] VARCHAR(200) NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_IDENTITYDETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_IDENTITYDETAILS]
(
    [ENTRYID] INT IDENTITY(1,1) NOT NULL,
    [DOB] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [ISAPPROVED] INT NULL,
    [ENTRY_DATE] DATETIME NULL,
    [ENTRYBY] VARCHAR(50) NULL,
    [MODIFY_DATE] DATETIME NULL,
    [MODIFY_BY] VARCHAR(50) NULL,
    [APPROVE_DATE] DATETIME NULL,
    [APPROVE_BY] VARCHAR(50) NULL,
    [Remark] VARCHAR(5000) NULL,
    [IsInhouseIntegrated] INT NULL,
    [RefNo] NUMERIC(18, 0) NULL,
    [SBTag] VARCHAR(100) NULL,
    [AadharVaultKey] VARCHAR(500) NULL,
    [U_ID] VARCHAR(15) NULL,
    [PANName] VARCHAR(500) NULL,
    [IsOnlineEntry] BIT NULL DEFAULT ((0)),
    [AadharName] VARCHAR(250) NULL,
    [IsAadhaar] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_IDENTITYDETAILS_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_IDENTITYDETAILS_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [DOB] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [ISAPPROVED] INT NULL,
    [ENTRY_DATE] DATETIME NULL,
    [ENTRYBY] VARCHAR(50) NULL,
    [MODIFY_DATE] DATETIME NULL,
    [MODIFY_BY] VARCHAR(50) NULL,
    [APPROVE_DATE] DATETIME NULL,
    [APPROVE_BY] VARCHAR(50) NULL,
    [Remark] VARCHAR(5000) NULL,
    [IsInhouseIntegrated] INT NULL,
    [RefNo] NUMERIC(18, 0) NULL,
    [SBTag] VARCHAR(100) NULL,
    [AadharVaultKey] VARCHAR(500) NULL,
    [U_ID] VARCHAR(15) NULL,
    [PANName] VARCHAR(500) NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_IDENTITYDETAILS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_IDENTITYDETAILS_LOG]
(
    [ENTRYID] INT NULL,
    [DOB] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [ISAPPROVED] INT NULL,
    [ENTRY_DATE] DATETIME NULL,
    [ENTRYBY] VARCHAR(50) NULL,
    [MODIFY_DATE] DATETIME NULL,
    [MODIFY_BY] VARCHAR(50) NULL,
    [APPROVE_DATE] DATETIME NULL,
    [APPROVE_BY] VARCHAR(50) NULL,
    [Remark] VARCHAR(5000) NULL,
    [IsInhouseIntegrated] INT NULL,
    [RefNo] NUMERIC(18, 0) NULL,
    [SBTag] VARCHAR(100) NULL,
    [AadharVaultKey] VARCHAR(500) NULL,
    [U_ID] VARCHAR(15) NULL,
    [PANName] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_INFRASTRUCTURE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_INFRASTRUCTURE]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [MAINOFFICE] VARCHAR(50) NULL,
    [INCOMERANGE] VARCHAR(50) NULL,
    [OFFICEFRONTFACING] VARCHAR(5) NULL,
    [OFFICEGROUNDFLOOR] VARCHAR(5) NULL,
    [SOCIALNETWORKING] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_INFRASTRUCTURE_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_INFRASTRUCTURE_19_Aug_2019]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NOT NULL,
    [MAINOFFICE] VARCHAR(50) NULL,
    [INCOMERANGE] VARCHAR(50) NULL,
    [OFFICEFRONTFACING] VARCHAR(5) NULL,
    [OFFICEGROUNDFLOOR] VARCHAR(5) NULL,
    [SOCIALNETWORKING] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_INFRASTRUCTURE_ARCHIVAL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_INFRASTRUCTURE_ARCHIVAL]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [INFRASTRUCTUREID] INT NOT NULL,
    [ENTRYID] INT NOT NULL,
    [MAINOFFICE] VARCHAR(50) NULL,
    [INCOMERANGE] VARCHAR(50) NULL,
    [OFFICEFRONTFACING] VARCHAR(5) NULL,
    [OFFICEGROUNDFLOOR] VARCHAR(5) NULL,
    [SOCIALNETWORKING] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_NomineeDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_NomineeDetails]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [EntryId] INT NULL,
    [FirstName] VARCHAR(100) NULL,
    [MiddleName] VARCHAR(100) NULL,
    [LastName] VARCHAR(100) NULL,
    [DOB] VARCHAR(100) NULL,
    [PanNumber] VARCHAR(100) NULL,
    [AddressLine1] VARCHAR(700) NULL,
    [AddressLine2] VARCHAR(700) NULL,
    [AddressLine3] VARCHAR(700) NULL,
    [State] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [Pincode] VARCHAR(100) NULL,
    [RelationShip] VARCHAR(100) NULL,
    [GuardianFname] VARCHAR(100) NULL,
    [GuardianMname] VARCHAR(100) NULL,
    [GuardianLname] VARCHAR(100) NULL,
    [GuardianDOB] VARCHAR(100) NULL,
    [GuardianPAN] VARCHAR(100) NULL,
    [GuardianAddressLine1] VARCHAR(700) NULL,
    [GuardianAddressLine2] VARCHAR(700) NULL,
    [GuardianAddressLine3] VARCHAR(700) NULL,
    [GuardianState] VARCHAR(200) NULL,
    [GuardianCity] VARCHAR(200) NULL,
    [GuardianPincode] VARCHAR(100) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_NomineeDetails_Archival
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_NomineeDetails_Archival]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [NomineeID] INT NOT NULL,
    [EntryId] INT NULL,
    [FirstName] VARCHAR(100) NULL,
    [MiddleName] VARCHAR(100) NULL,
    [LastName] VARCHAR(100) NULL,
    [DOB] VARCHAR(100) NULL,
    [PanNumber] VARCHAR(100) NULL,
    [AddressLine1] VARCHAR(700) NULL,
    [AddressLine2] VARCHAR(700) NULL,
    [AddressLine3] VARCHAR(700) NULL,
    [State] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [Pincode] VARCHAR(100) NULL,
    [RelationShip] VARCHAR(100) NULL,
    [GuardianFname] VARCHAR(100) NULL,
    [GuardianMname] VARCHAR(100) NULL,
    [GuardianLname] VARCHAR(100) NULL,
    [GuardianDOB] VARCHAR(100) NULL,
    [GuardianPAN] VARCHAR(100) NULL,
    [GuardianAddressLine1] VARCHAR(700) NULL,
    [GuardianAddressLine2] VARCHAR(700) NULL,
    [GuardianAddressLine3] VARCHAR(700) NULL,
    [GuardianState] VARCHAR(200) NULL,
    [GuardianCity] VARCHAR(200) NULL,
    [GuardianPincode] VARCHAR(100) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_PaymentDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_PaymentDetails]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [EntryID] INT NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [Instrument_No] BIGINT NULL,
    [DATE] DATETIME NULL,
    [PaymentMode] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_PaymentDetails_19_Aug_2019
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_PaymentDetails_19_Aug_2019]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [EntryID] INT NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [Instrument_No] BIGINT NULL,
    [DATE] DATETIME NULL,
    [PaymentMode] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_PaymentDetails_Archival
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_PaymentDetails_Archival]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PaymentId] INT NOT NULL,
    [EntryID] INT NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [Instrument_No] BIGINT NULL,
    [DATE] DATETIME NULL,
    [PaymentMode] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [ModifiedOn] DATETIME NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_REGISTRATIONRELATED
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_REGISTRATIONRELATED]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [AADHAARNO] VARCHAR(50) NULL,
    [EDUQUALI] VARCHAR(200) NULL,
    [OTHERQUALI] VARCHAR(200) NULL,
    [OCCUPATION] VARCHAR(200) NULL,
    [NATUREOFOCCUPATION] VARCHAR(200) NULL,
    [OTHEROCCUPATION] VARCHAR(200) NULL,
    [CAPITALMARKET] VARCHAR(200) NULL,
    [OTHEREXPERIENCE] VARCHAR(200) NULL,
    [PREBROKER] VARCHAR(200) NULL,
    [AUTHPERSON] VARCHAR(50) NULL,
    [WHETHERANY] VARCHAR(50) NULL,
    [MEMBERSHIPDETAILS] VARCHAR(200) NULL,
    [TRADINGACC] VARCHAR(50) NULL,
    [FATHERHUSBAND] VARCHAR(50) NULL,
    [contactPerson] VARCHAR(200) NULL,
    [contactPersonOccupation] VARCHAR(200) NULL,
    [CONTRACTSIGNATORY] VARCHAR(200) NULL,
    [AddedOn] DATETIME NULL,
    [modifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MF_sbapplicationlog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MF_sbapplicationlog]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL DEFAULT (getdate()),
    [employee_code] VARCHAR(50) NOT NULL DEFAULT '',
    [ipAddress] VARCHAR(100) NOT NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MF_sbapplicationlog_archival
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MF_sbapplicationlog_archival]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [sbapplicationlogid] INT NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL,
    [employee_code] VARCHAR(50) NOT NULL,
    [ipAddress] VARCHAR(100) NOT NULL,
    [archivaldate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_SBTAGOPTION
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_SBTAGOPTION]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [SBTag] VARCHAR(100) NULL,
    [PAN] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MF_UPDATEPROFILEPIC
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MF_UPDATEPROFILEPIC]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [PIC] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MFSB_AadharData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MFSB_AadharData]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [EntryId] BIGINT NULL,
    [IpAddress] VARCHAR(50) NULL,
    [AuthType] VARCHAR(15) NULL,
    [Name] VARCHAR(150) NULL,
    [FirstName] VARCHAR(50) NULL,
    [MiddleName] VARCHAR(50) NULL,
    [LastName] VARCHAR(50) NULL,
    [Address] VARCHAR(550) NULL,
    [AddressLine1] VARCHAR(150) NULL,
    [AddressLine2] VARCHAR(150) NULL,
    [AddressLine3] VARCHAR(250) NULL,
    [State] VARCHAR(50) NULL,
    [City] VARCHAR(50) NULL,
    [PinCode] VARCHAR(12) NULL,
    [Dob] VARCHAR(15) NULL,
    [Gender] VARCHAR(15) NULL,
    [Photo] VARCHAR(MAX) NULL,
    [CreateDate] DATETIME NULL,
    [ModifiedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_Applicationlog
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_Applicationlog]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [message] VARCHAR(500) NULL,
    [time] DATETIME NULL DEFAULT (getdate()),
    [ipAddress] VARCHAR(100) NOT NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_AssignedEmployeeDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_AssignedEmployeeDetail]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [EmployeeCode] VARCHAR(10) NULL,
    [AssignedDate] DATETIME NULL,
    [LastAssignedDate] DATETIME NULL,
    [ApplicationCount] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_AssignedEmployeeMst
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_AssignedEmployeeMst]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [EmployeeCode] VARCHAR(10) NULL,
    [Region] VARCHAR(50) NULL,
    [InsertedOn] DATETIME NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_ErrorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_ErrorLog]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [Module] VARCHAR(50) NULL,
    [Method] VARCHAR(50) NULL,
    [Description] VARCHAR(MAX) NULL,
    [Parameter] VARCHAR(MAX) NULL,
    [Line] VARCHAR(10) NULL,
    [InsertedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MFSB_ImpsDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MFSB_ImpsDetail]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [EntryId] BIGINT NULL,
    [AccountNo] VARCHAR(30) NULL,
    [IfscCode] VARCHAR(15) NULL,
    [IsImps] BIT NULL,
    [BeneficiaryName] VARCHAR(500) NULL,
    [IsNameMatch] BIT NULL,
    [CreatedDate] DATETIME NULL,
    [ModifiedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_NonARNClient
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_NonARNClient]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Mobile] VARCHAR(15) NULL,
    [ARNName] VARCHAR(150) NULL,
    [DeviceId] VARCHAR(50) NULL,
    [InsertedOn] DATETIME NULL,
    [IsARN] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_Otp
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_Otp]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [Mobile] VARCHAR(15) NULL,
    [Otp] VARCHAR(10) NULL,
    [Source] VARCHAR(30) NULL,
    [CreatedAt] DATETIME NULL,
    [UpdatedAt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_PanResultFromUTI_IncomeTax
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_PanResultFromUTI_IncomeTax]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [PanNo] VARCHAR(15) NULL,
    [result] NVARCHAR(200) NULL,
    [FirstName] VARCHAR(500) NULL,
    [MiddleName] VARCHAR(500) NULL,
    [LastName] VARCHAR(500) NULL,
    [PanCreationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_POSPClient
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_POSPClient]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Mobile] VARCHAR(15) NULL,
    [ARNName] VARCHAR(150) NULL,
    [DeviceId] VARCHAR(50) NULL,
    [InsertedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_Registration
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_Registration]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [Pan] VARCHAR(10) NULL,
    [Mobile] VARCHAR(12) NULL,
    [IsARN] VARCHAR(1) NULL,
    [ARNName] VARCHAR(100) NULL,
    [DeviceId] VARCHAR(25) NULL,
    [ReferralTag] VARCHAR(12) NULL,
    [SbTag] VARCHAR(12) NULL,
    [Url] VARCHAR(12) NULL,
    [SessionKey] VARCHAR(500) NULL,
    [CreatedDate] DATETIME NULL,
    [ModifyDate] DATETIME NULL,
    [EntryID] INT NULL,
    [ReferralSource] VARCHAR(50) NULL,
    [Version] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_Registration_Archival
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_Registration_Archival]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [RegistrationId] BIGINT NOT NULL,
    [Pan] VARCHAR(10) NULL,
    [Mobile] VARCHAR(12) NULL,
    [IsARN] VARCHAR(1) NULL,
    [ARNName] VARCHAR(100) NULL,
    [DeviceId] VARCHAR(25) NULL,
    [ReferralTag] VARCHAR(12) NULL,
    [SbTag] VARCHAR(12) NULL,
    [Url] VARCHAR(12) NULL,
    [SessionKey] VARCHAR(500) NULL,
    [CreatedDate] DATETIME NULL,
    [ModifyDate] DATETIME NULL,
    [EntryID] INT NULL,
    [ArchivalDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_StepDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_StepDetail]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [EntryId] BIGINT NULL,
    [StepId] INT NULL,
    [Status] BIT NULL,
    [IpAddress] VARCHAR(50) NULL,
    [InsertedDate] DATETIME NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MFSB_StepMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MFSB_StepMaster]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [StepName] VARCHAR(100) NULL,
    [Description] VARCHAR(800) NULL,
    [OrderBy] INT NULL,
    [IsActive] BIT NULL,
    [InsertedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NONCASHDEPOSIT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NONCASHDEPOSIT]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [AMOUNT] VARCHAR(50) NULL,
    [BROKERDEMATACC] VARCHAR(50) NULL,
    [DATE] VARCHAR(50) NULL,
    [DEPOSITTRANSACTIONSTATUS] VARCHAR(50) NULL,
    [FORMOFDEPOSIT] VARCHAR(50) NULL,
    [INTERMCLIENTID] VARCHAR(50) NULL,
    [INTERMDPID] VARCHAR(50) NULL,
    [INTERMEDIARY] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [QUANTITY] VARCHAR(50) NULL,
    [REMARKS] VARCHAR(50) NULL,
    [SEGMENT] VARCHAR(50) NULL,
    [VERTICAL] VARCHAR(50) NULL,
    [VOUCHERTYPE] VARCHAR(50) NULL,
    [TYPE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_REGISTRATIONRELATED
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_REGISTRATIONRELATED]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [AADHAARNO] VARCHAR(50) NULL,
    [EDUQUALI] VARCHAR(200) NULL,
    [OTHERQUALI] VARCHAR(200) NULL,
    [OCCUPATION] VARCHAR(200) NULL,
    [NATUREOFOCCUPATION] VARCHAR(200) NULL,
    [OTHEROCCUPATION] VARCHAR(200) NULL,
    [CAPITALMARKET] VARCHAR(200) NULL,
    [OTHEREXPERIENCE] VARCHAR(200) NULL,
    [PREBROKER] VARCHAR(200) NULL,
    [AUTHPERSON] VARCHAR(50) NULL,
    [WHETHERANY] VARCHAR(50) NULL,
    [MEMBERSHIPDETAILS] VARCHAR(200) NULL,
    [TRADINGACC] VARCHAR(50) NULL,
    [FATHERHUSBAND] VARCHAR(50) NULL,
    [contactPerson] VARCHAR(200) NULL,
    [contactPersonOccupation] VARCHAR(200) NULL,
    [CONTRACTSIGNATORY] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_REJECTION
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_REJECTION]
(
    [ID] INT NULL,
    [REJECTION] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_REJECTION_REASON
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_REJECTION_REASON]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [REASON] VARCHAR(100) NULL,
    [REJID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SB_ACCESSCONTROL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SB_ACCESSCONTROL]
(
    [USERID] VARCHAR(30) NULL,
    [USERTYPE] VARCHAR(30) NULL,
    [isdelete] INT NULL,
    [modifydate] DATETIME NULL,
    [modifyby] VARCHAR(50) NULL,
    [AddedBy] VARCHAR(50) NULL,
    [addedon] DATETIME NULL,
    [id] INT IDENTITY(1,1) NOT NULL,
    [aadhaar] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sbapplicationlog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sbapplicationlog]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL DEFAULT (getdate()),
    [employee_code] VARCHAR(50) NOT NULL DEFAULT '',
    [ipAddress] VARCHAR(100) NOT NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sbapplicationlog_archival
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sbapplicationlog_archival]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [sbapplicationlogid] INT NOT NULL,
    [entryid] INT NOT NULL,
    [operation] VARCHAR(500) NOT NULL,
    [time] DATETIME NULL,
    [employee_code] VARCHAR(50) NOT NULL,
    [ipAddress] VARCHAR(100) NOT NULL,
    [archivaldate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SEGMENTS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SEGMENTS]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [BSECASH] BIT NULL,
    [NSECASH] BIT NULL,
    [NSEFNO] BIT NULL,
    [NSECURRENCY] BIT NULL,
    [MCX] BIT NULL,
    [NCDEX] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SENDREQUEST_v2
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SENDREQUEST_v2]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [MOBILE] VARCHAR(50) NULL,
    [FLAG] INT NULL,
    [USERID] VARCHAR(50) NULL,
    [CALLSTATUS] VARCHAR(50) NULL,
    [NotificationID] VARCHAR(MAX) NULL,
    [IMEI] VARCHAR(100) NULL,
    [LOGDATE] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_temp_2024_03_15
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_temp_2024_03_15]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [txt1] VARCHAR(500) NULL,
    [txt2] VARCHAR(500) NULL,
    [txt3] VARCHAR(500) NULL,
    [txt4] VARCHAR(500) NULL,
    [txt5] VARCHAR(500) NULL,
    [create_ts] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_temp_2024_05_15
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_temp_2024_05_15]
(
    [id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_UPDATEPROFILEPIC
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_UPDATEPROFILEPIC]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ENTRYID] INT NULL,
    [PIC] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Users
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Users]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [UserName] VARCHAR(100) NULL,
    [Email] VARCHAR(100) NULL,
    [Password] VARCHAR(100) NULL,
    [Photo] NVARCHAR(MAX) NULL,
    [Status] VARCHAR(100) NULL DEFAULT 'Available',
    [UserUiniqueId] VARCHAR(500) NULL,
    [UserType] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todeletefortest
-- --------------------------------------------------
CREATE TABLE [dbo].[todeletefortest]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_AccessControl_delete
-- --------------------------------------------------



CREATE TRIGGER [dbo].[tr_AccessControl_delete]
   ON  [dbo].[tbl_accesscontrol]
   AFTER delete
AS 
BEGIN
	
INSERT into tbl_accesscontrol_Log(USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,operation,Logdate)
   SELECT USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,'Insert',GETDATE() FROM deleted;
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_AccessControl_Insert
-- --------------------------------------------------


-- =============================================
-- Author:		Narendra/Suraj
-- Create date: 28/03/2018
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tr_AccessControl_Insert]
   ON  [dbo].[tbl_accesscontrol]
   AFTER Insert
AS 
BEGIN
	
INSERT into tbl_accesscontrol_Log(USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,operation,Logdate)
   SELECT USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,'Insert',GETDATE() FROM inserted;
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_AccessControl_Update
-- --------------------------------------------------



CREATE TRIGGER [dbo].[tr_AccessControl_Update]
   ON  [dbo].[tbl_accesscontrol]
   AFTER update
AS 
BEGIN
	
INSERT into tbl_accesscontrol_Log(USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,operation,Logdate)
   SELECT USERID,modifydate,modifyby,AddedBy,addedon,isactive,MenuAccess,'Update',GETDATE() FROM deleted;
END

GO

-- --------------------------------------------------
-- VIEW dbo.MFSBDetails
-- --------------------------------------------------
 CREATE View MFSBDetails
  as
 
  SELECT B.SBTAG,A.TRADENAME AS TRADENAME,
    d.firstName+' '+d.MiddleName+' '+d.LastName as ARN_Name,    
      
CASE WHEN D.IsARN =1 THEN D.ARN_Number ELSE NULL END SEBIRegNo,
ARN_FromDate,ARN_ToDate   ,
t.mf_reg_date 
    --INTO TBL_TEST        
    FROM TBL_MF_BASICDETAILS A        
    JOIN TBL_MF_IDENTITYDETAILS B        
    ON A.ENTRYID = B.ENTRYID         
    JOIN TBL_MF_ARNDetails D        
    ON A.ENTRYID = D.ENTRYID      
    join TBL_MF_BANKDETAILS P
    on p.ENTRYID=a.ENTRYID  
   left join MIS.SB_COMP.DBO.sb_broker t on b.SBTag=t.sbtag 
   where b.SBTag!=''

GO

-- --------------------------------------------------
-- VIEW dbo.vw_GeneratedSBTag
-- --------------------------------------------------
CREATE VIEW vw_GeneratedSBTag
AS 
	select tr.ENTRYID,id.ENTRYBY as Ecode 
		,bd.sbtag,ISNULL(bd.FIRSTNAME,'')+' '+ISNULL(bd.MIDDLENAME,'')+' '+ISNULL(bd.LASTNAME,'') as Name
		,bd.PARENT as Branch,bd.REGION,bd.INTERMEDIARYEMPLOYEE as Introdername
		,tr.Time AS TagGenerationTime
		,am.STATUS
	from tbl_sbapplicationlog tr
	LEFT JOIN TBL_IDENTITYDETAILS  id
	ON tr.ENTRYID=id.ENTRYID
	LEFT JOIN TBL_BASICDETAILS bd
	ON tr.ENTRYID=bd.ENTRYID
	LEFT JOIN TBL_APPLICATIONSTATUSMASTER am
	ON id.ISAPPROVED=am.STATUS_CODE
	where  operation = 'SB-TAG Generated'
			AND Time>='2018-01-25'

GO

-- --------------------------------------------------
-- VIEW dbo.vw_GetARNDetails
-- --------------------------------------------------


CREATE VIEW [dbo].[vw_GetARNDetails]

AS 

	



SELECT        A.SBTag, B.ARN_Number, B.FirstName, B.MiddleName, B.LastName

FROM            TBL_MF_IDENTITYDETAILS A INNER JOIN

                         TBL_MF_ARNDetails B ON A.ENTRYID = B.EntryID

WHERE        (A.ISAPPROVED = 6)

GO

-- --------------------------------------------------
-- VIEW dbo.vw_GetARNDetails_NXT
-- --------------------------------------------------


Create view vw_GetARNDetails_NXT
as
SELECT        A.SBTag, B.ARN_Number, B.FirstName, B.MiddleName, B.LastName,
ARN_FromDate,	ARN_ToDate

FROM            TBL_MF_IDENTITYDETAILS A INNER JOIN

                         TBL_MF_ARNDetails B ON A.ENTRYID = B.EntryID

WHERE        (A.ISAPPROVED = 6)

GO

-- --------------------------------------------------
-- VIEW dbo.VW_GETRANDVALUE
-- --------------------------------------------------
CREATE VIEW VW_GETRANDVALUE
AS
SELECT RAND() AS VALUE

GO

