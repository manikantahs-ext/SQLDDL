-- DDL Export
-- Server: 10.253.78.163
-- Database: Survey
-- Exported: 2026-02-05T12:32:31.526909

USE Survey;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_AnswerMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_AnswerMaster] ADD CONSTRAINT [FK_tbl_AnswerMaster_tbl_QuestionMaster] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[tbl_QuestionMaster] ([Id])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_QuestionMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_QuestionMaster] ADD CONSTRAINT [FK_tbl_QuestionMaster_tbl_CampaignMaster] FOREIGN KEY ([CampaignId]) REFERENCES [dbo].[tbl_CampaignMaster] ([Id])

GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_REMOVE_SPECIAL_CHARACTER
-- --------------------------------------------------
CREATE FUNCTION [dbo].[FN_REMOVE_SPECIAL_CHARACTER] (                  
 @INPUT_STRING varchar(500))                
RETURNS VARCHAR(500)                
AS                 
BEGIN                
                 
DECLARE @NEWSTRING VARCHAR(500)                 
SET @NEWSTRING = @INPUT_STRING ;                 
With SPECIAL_CHARACTER as                
(                
SELECT '>' as item                
UNION ALL        
SELECT '>' as item                
UNION ALL                 
SELECT '#' as item                
UNION ALL                 
SELECT '(' as item                
UNION ALL                 
SELECT ')' as item                
UNION ALL                 
SELECT '!' as item                
UNION ALL                 
SELECT '?' as item                
UNION ALL                 
SELECT '@' as item                
UNION ALL                 
SELECT '*' as item                
UNION ALL                 
SELECT '%' as item                
UNION ALL                 
SELECT '$' as item                
UNION ALL                 
SELECT '|' as item                
UNION ALL                 
SELECT ',' as item              
UNION ALL            
SELECT '_' as item                   
UNION ALL                 
SELECT ':' as item                
UNION ALL                 
SELECT '' as item                  
UNION ALL                 
SELECT ';' as item             
UNION ALL                 
SELECT '-' as item           
UNION ALL                 
SELECT '}' as item           
UNION ALL                 
SELECT '{' as item           
UNION ALL                 
SELECT '/' as item           
UNION ALL                 
SELECT '\' as item           
UNION ALL                 
SELECT '.' as item           
UNION ALL                 
SELECT '''' as item        
UNION ALL                 
SELECT '&' as item        
UNION ALL                 
SELECT '-' as item       
UNION ALL                 
SELECT '[' as item     
UNION ALL                 
SELECT ']' as item  
UNION ALL                 
SELECT '`' as item 
UNION ALL                 
SELECT '=' as item       
 )                
SELECT @NEWSTRING = Replace(@NEWSTRING, ITEM, '') FROM SPECIAL_CHARACTER 

SELECT @NEWSTRING = REPLACE(REPLACE(REPLACE(@NEWSTRING,CHAR(13),'#'),CHAR(10),'$'),'#$',' ')

return @NEWSTRING                 
END

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_AnswerMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_AnswerMaster] ADD CONSTRAINT [PK_tbl_AnswerMaster] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_CampaignMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_CampaignMaster] ADD CONSTRAINT [PK_tbl_CampaignMaster] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ErrorLogs
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ErrorLogs] ADD CONSTRAINT [PK_tbl_ErrorLogs] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_QuestionMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_QuestionMaster] ADD CONSTRAINT [PK_tbl_QuestionMaster] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Survey
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Survey] ADD CONSTRAINT [PK_tbl_Survey] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.getQuestionMaster
-- --------------------------------------------------
/*
getQuestionMaster 'GetAnswer',1

*/
CREATE PROCEDURE getQuestionMaster
	@process varchar(50),
	@campainID int
	
AS
BEGIN
	if(@process = 'Getquestion')
	begin
		select * from tbl_QuestionMaster Where CampaignId =@campainID and IsActive = 1
	end
	
	
	if(@process = 'GetAnswer')
	begin
		--select * from tbl_QuestionMaster Where CampaignId =@campainID and IsActive = 1
		select a.Id,a.QuestionId,a.Answer,a.UserSpecificationRequired,a.DtCreated,a.IsActive from  tbl_AnswerMaster a
                              join tbl_QuestionMaster q on a.QuestionId = q.Id
                              join tbl_CampaignMaster c on q.CampaignId = c.Id
                              where q.CampaignId = @campainID and a.IsActive = 1
	end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Nps_clientdetails
-- --------------------------------------------------
/* 
Created on :: Dec 29 2016 
Created By :: Renil Pillai 
Requested By :: Nandkishore
Purpose  :: Fetching NPS data for processing   
*/ 

CREATE PROCEDURE [dbo].[Nps_clientdetails] 
AS 
    SET nocount ON 
    SET TRANSACTION isolation level READ uncommitted 

  BEGIN 
   
   return 0


   -- as the job getting failed everyday we are marking return 0

  BEGIN try
  /*Fetching b2c active clients*/ 
      --drop table #clientdetails 
      SELECT  party_code, 
             first_active_date, 
             ClientAge=Datediff(dd, first_active_date, Getdate()) 
      INTO   #clientdetails 
      FROM   intranet.risk.dbo.client_details WITH(nolock) 
      WHERE  last_inactive_date > Getdate() 
             AND Isnumeric(party_code) = 0 
      
         

      /*Calculating Client Age*/ 
      SELECT party_code, 
             first_active_date, 
             clientage, 
             NPStype=CASE 
                       WHEN x.clientage BETWEEN nps_startday AND Isnull( 
                                                nps_endday 
                                                                 , 
                                                                 999999999 
                                                                 ) THEN 
                       nps_type 
                       ELSE 'Not Eligible' 
                     END 
      INTO   #npsclientbase  
      FROM   #clientdetails x 
             FULL JOIN (SELECT * 
                        FROM   nps_type y WITH (nolock) 
                        WHERE  active = 'Y') y 
                    ON ( CASE 
                           WHEN x.clientage BETWEEN 
                                y.nps_startday AND y.nps_endday 
                         THEN 
                           y.nps_startday 
                           ELSE 180 
                         END ) = y.nps_startday 
      ORDER  BY first_active_date DESC 
      
--      drop table #npsclientbase

			


      delete from #npsclientbase where ClientAge<15 and NPStype='NPS1' 
      
      delete from #npsclientbase where ClientAge>15 and ClientAge<90 and NPStype='NPS2' 
      
      delete from #npsclientbase where ClientAge>90 and ClientAge<180 and NPStype='NPS3' 
      
      delete from #npsclientbase where ClientAge>180 and ClientAge<360 and NPStype='NPS4' 
      
      --delete from #npsclientbase where ClientAge>180 and ClientAge<360 and NPStype='NPS4'
      
      --delete from #npsclientbase where ClientAge>360 and NPStype='NPS4' and (ClientAge%180)=0
      
      -- do comment post live dump
      
     -- Update  #npsclientbase set NPStype='NPS3' WHERE  npstype = 'Not Eligible' 
        
          -- select * from #npsclientbase where NPStype='Not Eligible'
        
      --select * from #npsclientbase where NPStype='NPS1' order by ClientAge asc
      --select * from #npsclientbase where NPStype='NPS2' order by ClientAge asc
      --select * from #npsclientbase where NPStype='NPS3' order by ClientAge asc
      --select * from #npsclientbase where NPStype='NPS4' order by ClientAge asc


      
      /*1-14 day client to be deleted*/ 
      DELETE FROM #npsclientbase 
      WHERE  npstype = 'Not Eligible' 

      /*Client with same NPS type to be deleted of on boarding and 90 day client*/ 
      DELETE x FROM   #npsclientbase x 
             INNER JOIN (SELECT clientcode, 
                                nps_type, 
                                triggerdate 
                         FROM   nps_survey x WITH (nolock) 
                         WHERE  EXISTS 
                        (SELECT clientcode, 
                                lasttriggerdate 
                         FROM   nps_clientwise_surverydate y with (nolock)
                         WHERE  x.clientcode = y.clientcode 
                                AND x.triggerdate = lasttriggerdate)
								AND x.NPS_Type in (select NPS_Type from  nps_type y WITH (nolock) 
                        WHERE  active = 'Y' and srno<>4))y 
                     ON x.party_code = y.clientcode 
                        AND x.npstype = y.nps_type 


	/*Delete NPS3 client who have not completed 180 days  */
      DELETE x  FROM   #npsclientbase x 
             INNER JOIN (SELECT clientcode, 
                                nps_type, 
                                triggerdate,
								Lastsentage=Datediff(dd, triggerdate, Getdate())  
                         FROM   nps_survey x WITH (nolock) 
                         WHERE  EXISTS 
                        (SELECT clientcode, 
                                lasttriggerdate 
                         FROM   nps_clientwise_surverydate y 
                         WHERE  x.clientcode = y.clientcode 
                                AND x.triggerdate = lasttriggerdate)
								AND x.NPS_Type in (select NPS_Type from  nps_type y WITH (nolock) 
                        WHERE  active = 'Y' and srno=4))y 
                     ON x.party_code = y.clientcode 
                        AND x.npstype = y.nps_type where y.Lastsentage<180

					/*to remove duplicate entries*/
					delete a from  #npsclientbase a
					inner join nps_surveylog b 
					on a.party_code = b.ClientCode and a.NPStype = b.NPS_Srno



      /*Holidays and Saturday Sunday to be Excluded*/ 
      --IF ( Datename(dw, Getdate()) IN ( 'Saturday', 'Sunday' ) ) 
      --    OR EXISTS (SELECT * 
      --               FROM   [196.1.115.239].harmony.dbo.holimst WITH (nolock) 
      --               WHERE  hdate = CONVERT(VARCHAR(11), Getdate(), 121)) 
      --  BEGIN 
      --      PRINT 'Holiday' 
      --  END 
      --ELSE 
      --  BEGIN 
      
      
    
      
      update A
      set A.NPStype  =   REPLACE(a.NPStype, 'NPS', 'NPSW') 
      from      
      (select * from #npsclientbase) A
      join intranet.risk.dbo.client_details B
      on A.party_code  = B.party_code  
      where B.Branch_cd = 'WEALTH'
      
      
      
            INSERT INTO nps_surveylog 
                        (clientcode, 
                         nps_srno, 
                         nps_campaignid, 
                         kycactivationdate, 
                         triggerdate) 
            SELECT party_code, 
                   y.srno, 
                   campaignid, 
                   first_active_date,                                        
                   TriggerDate=Getdate() 
            FROM   #npsclientbase x 
                   INNER JOIN nps_type y WITH (nolock) 
                           ON x.npstype = y.nps_type 
                           
                           
                           
         --added by suraj to add test clients on 09/05/2017 start
         
         --INSERT INTO nps_surveylog 
         --               (clientcode, 
         --                nps_srno, 
         --                nps_campaignid, 
         --                kycactivationdate, 
         --                triggerdate) 
         --values ('A111959',4,1,GETDATE()-13,GETDATE())                  
         
         --INSERT INTO nps_surveylog 
         --               (clientcode, 
         --                nps_srno, 
         --                nps_campaignid, 
         --                kycactivationdate, 
         --                triggerdate) 
         --values ('V66248',4,1,GETDATE()-18,GETDATE())                  
         --added by suraj to add test clients on 09/05/2017 end                  
        --END 
/*
select * from nps_surveylog where  clientcode = 'R106249'
*/

       --- Update URL
       
       
        OPEN SYMMETRIC KEY SurveyEncrypt DECRYPTION BY CERTIFICATE SurveyCert;        
 
        Update nps_surveylog set EncId=EncryptByKey(Key_GUID('SurveyEncrypt'),cast(Id as CHAR)) where EncId is null

        Update nps_surveylog set URL='http://mf.angelmf.com/NPS/UserSurvey/Index?Id='+master.dbo.fn_varbintohexstr(ENCID) where URl is null 
        
        
--        select * into #data from
--(
--select top 2 * from NPS_SurveyLog where Nps_Srno=1
--union
--select top 2 *  from NPS_SurveyLog where Nps_Srno=2
--union
--select top 2 * from NPS_SurveyLog where Nps_Srno=3
--union
--select top 2 *  from NPS_SurveyLog where Nps_Srno=4
--) f 

--drop table #data
 
 select Id,ClientCode,Nps_Type,URL into #data from NPS_SurveyLog a  With(nolock)
 inner join NPS_Type b With(Nolock) on a.Nps_SrNo=b.SrNo
 where Day(TriggerDate)=Day(Getdate()) and Month(TriggerDate)=Month(Getdate())
 and Year(TriggerDate)=Year(Getdate())


select a.id,a.ClientCode,cd.long_name,cd.email,cd.Mobile_pager,a.Nps_Type,a.URL into #final from #data a inner merge join 
Anand1.msajag.Dbo.client_Details cd with(Nolock)
on a.clientcode=cd.cl_code
    
    drop table #data   
    
    delete from #final where isnull(email,'')=''

	truncate table temp_NPS_Surveydata

   insert into temp_NPS_Surveydata
    select * from #final     


	exec Nps_SurveyDataMail
--exec intranet.risk.dbo.NPS_MISMail


    --Select * from #final where id<=100000 order by 1 
    --Select * from #final where id>100000 and id<=200000 order by 1 
    --Select * from #final where id>200000 and id<=300000 order by 1 
    --Select * from #final where id>300000 order by 1 
    
      END try 

      BEGIN catch 
          INSERT INTO survey_error 
                      (errtime, 
                       errobject, 
                       errline, 
                       errmessage) 
          SELECT Getdate(), 
                 'Nps_clientdetails', 
                 Error_line(), 
                 Error_message() 

          DECLARE @ErrorMessage NVARCHAR(4000); 

          SELECT @ErrorMessage = Error_message() 
                                 + CONVERT(VARCHAR(10), Error_line()); 

          RAISERROR (@ErrorMessage,16,1); 
      END catch 


	  END

    SET nocount OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Nps_clientscore
-- --------------------------------------------------
/*  
Created on :: Dec 29 2016  
Created By :: Renil Pillai  
Requested By :: Nandkishore 
Purpose  :: To update Client Score 
*/ 
CREATE PROCEDURE [dbo].[Nps_clientscore] 
AS 
    SET nocount ON 
    SET TRANSACTION isolation level READ uncommitted 

  BEGIN 
      BEGIN try 

          UPDATE a 
          SET    a.rating = b.answer, 
                 FilledDate = b.dtcreated 
          FROM   nps_surveylog a 
                 INNER JOIN (SELECT x.clientcode, 
                                    x.nps_srno, 
                                    y.dtcreated, 
                                    answer, 
                                    x.nps_campaignid 
                             FROM   (SELECT * 
                                     FROM   nps_survey WITH (nolock) 
                                     WHERE  rating IS NULL 
                                            AND filleddate IS NULL)x 
                                    INNER JOIN (SELECT * 
                                                FROM   survey WITH (nolock) 
                                                WHERE  questiontype = 'Master')y 
                                            ON x.clientcode = y.partycode 
                                               AND x.nps_type = y.npstype 
                                               AND 
                                    x.nps_campaignid = y.campaignid 
                            )b 
                         ON a.clientcode = b.clientcode 
                            AND a.nps_srno = b.nps_srno 
                            AND a.nps_campaignid = b.nps_campaignid 
          WHERE  a.rating IS NULL 
                 AND a.filleddate IS NULL 
      END try 

      BEGIN catch 
          INSERT INTO survey_error 
                      (errtime, 
                       errobject, 
                       errline, 
                       errmessage) 
          SELECT Getdate(), 
                 'Nps_clientscore', 
                 Error_line(), 
                 Error_message() 

          DECLARE @ErrorMessage NVARCHAR(4000); 

          SELECT @ErrorMessage = Error_message() 
                                 + CONVERT(VARCHAR(10), Error_line()); 

          RAISERROR (@ErrorMessage,16,1); 
      END catch 
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NPS_MISMail
-- --------------------------------------------------
CREATE Procedure [dbo].[NPS_MISMail]
as
set nocount on

declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(4000),@name as varchar(100)

set @email='suraj.patil@angelbroking.com'

set @mess=''
set @mess='Dear Vinay,<br><br>                                                 

Please find the attached NPS Data .      

<br>      


<br><br><br><br>      


<br><br>      


<br><br>      
This is a system generated mail do not reply.

<br>'  


DECLARE

    @tab11 char(1) = CHAR(9)

    Declare @file_name1 as varchar(100)

    set @file_name1='NPS.csv'


EXEC intranet.msdb.dbo.sp_send_dbmail

    @profile_name = 'Intranet',

    @recipients = @email,

    @copy_recipients =  '',    

	@blind_copy_recipients='suraj.patil@angelbroking.com',    

    @query = 'SET NOCOUNT ON 

              
        select    REPLACE(REPLACE(replace(ClientCode, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') as ClientCode,
                    REPLACE(REPLACE(replace(Region, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') as Region,
                    REPLACE(REPLACE(replace(BranchCode, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') as BranchCode, 
                    REPLACE(REPLACE(replace(Sub_broker, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') as Sub_broker, 
                    REPLACE(REPLACE(replace(UserType, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS UserType,
                    REPLACE(REPLACE(replace(SurveyDate, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS SurveyDate,
                    REPLACE(REPLACE(replace(Response_Date, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS Response_Date,
                    REPLACE(REPLACE(replace(Rating, '','', '' ''), CHAR(13), ''''), CHAR(10), '''')AS Rating,
                    REPLACE(REPLACE(replace(Suggestion, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS Suggestion,
                    REPLACE(REPLACE(replace(Suggestion_Type, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS Suggestion_Type,
                    REPLACE(REPLACE(replace(Remarks, '','', '' ''), ''.'', ''''), CHAR(10), '''') AS Remarks,
                    REPLACE(REPLACE(replace(ActivationDate, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS ActivationDate,
                    REPLACE(REPLACE(replace(Persona, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS Persona,
                    REPLACE(REPLACE(replace(OnBoardingPersona, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS OnBoardingPersona,
                    REPLACE(REPLACE(replace(gender, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS gender,
                    REPLACE(REPLACE(replace(Age, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS Age,
                    REPLACE(REPLACE(replace(b2c, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS b2c,
                    REPLACE(REPLACE(replace([Online], '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS [Online],
                    REPLACE(REPLACE(replace(mobile_pager, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS mobile_pager,
					REPLACE(REPLACE(replace(short_name, '','', '' ''), CHAR(13), ''''), CHAR(10), '''') AS short_name
                    from MIS.Survey.dbo.NPS_MIS where clientcode =''A105377''
              
              
              ' ,

    @subject = 'NPS MIS Data',

    @attach_query_result_as_file = 1,

    @query_result_header = 1,

    @query_attachment_filename=@file_name1,

    @query_result_separator=@tab11,

    @body_format='HTML',

    @query_result_no_padding=1 ,

	@body =@mess 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NPS_MISMail25042017
-- --------------------------------------------------
create Procedure [dbo].[NPS_MISMail25042017]
as
set nocount on

declare @tag varchar(12),@email varchar(200),@remail varchar(200),@rec int,@mess as varchar(4000),@name as varchar(100)

set @email='vinay.dalvi@angelbroking.com'

set @mess=''
set @mess='Dear Vinay,<br><br>                                                 

Please find the attached NPS Data .      

<br>      


<br><br><br><br>      


<br><br>      


<br><br>      
This is a system generated mail do not reply.

<br>'  


DECLARE

    @tab11 char(1) = CHAR(9)

    Declare @file_name1 as varchar(100)

    set @file_name1='NPS.csv'


EXEC intranet.msdb.dbo.sp_send_dbmail

    @profile_name = 'Intranet',

    @recipients = @email,

    @copy_recipients =  '',    

	@blind_copy_recipients='renil.pillai@angelbroking.com',    

    @query = 'SET NOCOUNT ON 

              SELECT * from MIS.Survey.dbo.NPS_MIS' ,

    @subject = 'NPS MIS Data',

    @attach_query_result_as_file = 1,

    @query_result_header = 1,

    @query_attachment_filename=@file_name1,

    @query_result_separator=@tab11,

    @body_format='HTML',

    @query_result_no_padding=1 ,

	@body =@mess 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Nps_SurveyDataMail
-- --------------------------------------------------
    
/*     
Created on :: Dec 29 2016     
Created By :: Renil Pillai     
Requested By :: Nandkishore    
Purpose  :: To Mail the Survery Data to Digital Marketing Team       
*/     
CREATE PROCEDURE [dbo].[Nps_SurveyDataMail]     
AS     
    SET nocount ON     
    SET TRANSACTION isolation level READ uncommitted     
BEGIN     
    
    
  BEGIN try    
    
 DECLARE @strAttach VARCHAR(500),@msgbody VARCHAR(5000),@Sub VARCHAR(500)        
 DECLARE @file VARCHAR(MAX)                     
 DECLARE @file1 VARCHAR(MAX)                     
 DECLARE @path VARCHAR(MAX)        
    
 Set @Sub='NPS Survey Client Data for : '+Convert(varchar(11),getdate(),103)    
 Set @msgbody='Hi Digital Marketing Team,'    
 Set @msgbody=@msgbody+'<br/><br/>Herewith attached the NPS Survey Client Base dated '+Convert(varchar(11),getdate(),103)+'. Request to proceed with the Email/SMS campaign.'    
 Set @msgbody=@msgbody+'<br/><br/><br/>This is system generated mail. Do not reply. '    
 Set @msgbody=@msgbody+'<br/><br/><br/><br/><br/><br/><br/>Thanks and Regards -Technology Team '    
    
 --SET @path = '\\196.1.115.152\public\MGS\Swapnil\'                    
 SET @path = '\\196.1.115.167\d$\NPSSurvey\'                  
 SET @file = @path + 'NPS_ClientData.xls'                    
 --SET @file1 = @path + 'PoolMismatch.xls'      
    
 exec MASTER.dbo.xp_cmdshell ' bcp "select * from [MIS].survey.dbo.temp_NPS_Surveydata d with(nolock) " queryout d:\NPSSurvey\NPS_ClientData.xls -c -SABVSMIS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                    
    
 declare @s varchar(500)                
 set @s=@file    
 --set @s=@file+ ';' +@file1                
                
 EXEC intranet.msdb.dbo.sp_send_dbmail                                        
 @profile_name ='intranet',                                        
 @recipients = 'abhay.shah@angelbroking.com;kavita.agrawal@angelbroking.com;digital.servicing@angelbroking.com;vinay.dalvi@angelbroking.com',                  
 --abhay.shah@angelbroking.com;kavita.agrawal@angelbroking.com;digital.servicing@angelbroking.com    
 --@recipients = 'sandeep.rai@angelbroking.com',                  
 --@copy_recipients= @CC_ADD,                    
 --shruti.shah@angelbroking.com;renil.pillai@angelbroking.com;amit.s@angelbroking.com;NandKishore.Purohit@angelbroking.com    
 @copy_recipients='shruti.shah@angelbroking.com;renil.pillai@angelbroking.com;amit.s@angelbroking.com;NandKishore.Purohit@angelbroking.com;suraj.patil@angelbroking.com',                  
 --@copy_recipients='renil.pillai@angelbroking.com',                  
 @file_attachments= @s,                                       
 @body = @msgbody,                                       
 @body_format ='HTML',                                        
 @subject =@Sub    
    
   END try     
    
      BEGIN catch     
          INSERT INTO survey_error     
                      (errtime,     
                       errobject,     
                       errline,     
                       errmessage)     
          SELECT Getdate(),     
                 'Nps_SurveyDataMail',     
                 Error_line(),     
                 Error_message()     
    
          DECLARE @ErrorMessage NVARCHAR(4000);     
    
          SELECT @ErrorMessage = Error_message()     
                                 + CONVERT(VARCHAR(10), Error_line());     
    
          RAISERROR (@ErrorMessage,16,1);     
      END catch     
    
    
    
End

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
-- PROCEDURE dbo.Spx_GetDecryptValueParty_Code_Survey
-- --------------------------------------------------
--  exec[Spx_GetDecryptValueParty_Code_Survey] '0x00fffe82a2a3f044b464d2841861ccee0100000035f5fd6b4674f469b976a6cc6ac7bd0b307248e160870ab21bd8404376b30c7c42ec0cea442fe253830414f88f6ceaf4'
CREATE proc [dbo].[Spx_GetDecryptValueParty_Code_Survey]    
    
(    
 @Id nvarchar(Max)    
)    
    
as    
Declare @Count int    
declare @Decparty_Code varchar(12)    
  
OPEN SYMMETRIC KEY SurveyEncrypt DECRYPTION BY CERTIFICATE SurveyCert;   
Create Table #tempEnUser(Party_Code varchar(12))    
  
declare @Q varchar(max)              
set @Q='insert into #tempEnUser select  CONVERT(varchar(10), DecryptByKey('+@Id+')) as Party_Code'              
print @Q              
exec(@Q)              
              
  select @Decparty_Code=Party_Code from #tempEnUser     
  
  Declare @CountRating int
  declare @Party_Code varchar(12)
  declare @Nps_SrNo int
  
  select ID,ClientCode,Nps_SrNo into #tempNpsLog from nps_surveylog  With(Nolock) where ID=@Decparty_Code --and Rating is not null
  
  select @Party_Code=ClientCode,@Nps_SrNo=Nps_SrNo from #tempNpsLog
  
  Select  @CountRating=COUNT(0) from tbl_Survey With(Nolock) where partyCode=@Decparty_Code 
  
  select @Decparty_Code As Id,@Party_Code as Party_Code,@Nps_SrNo as NpsId,Case When @CountRating>0 then 'Y' else 'N' end As IsExist

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_getmisdeatils_nps_survey
-- --------------------------------------------------


--select * from tbl_Survey where partycode=100407

-- select * from NPS_SurveyLog where id=100407

--select * from tbl_QuestionMaster
--select * from tbl_AnswerMaster
--select top 100 * from Intranet.Risk.Dbo.Client_Details cd with(Nolock)

CREATE proc [dbo].[spx_getmisdeatils_nps_survey]

as
SELECT   
A.PARTYCODE as Id,B.CLIENTCODE,B.Nps_Srno,B.TriggerDate As SurveyDate,A.QuestionId,A.AnswerId,Remarks,  
A.DtCreated,NPSType,Question,ANSWER,Convert (varchar(12),KYCActivationDate,101) as ActivationDate  
into #Final  
FROM tbl_Survey A WITH(NOLOCK) INNER JOIN NPS_SurveyLog B WITH(NOLOCK)  
ON A.PARTYCODE=B.ID  
INNER JOIN tbl_QuestionMaster C WITH(NOLOCK) ON A.QuestionId=C.ID  
inner JOIN tbl_AnswerMaster D WITH(NOLOCK) ON a.ANSWERID=D.ID --and C.Id=D.QuestionId  
  
order by dtCreated desc  
  
  
Create Table #FInalData(Id int,ClientCode varchar(12),UserType varchar(20),NPSType varchar(20),    
SurveyDate datetime,Response_Date datetime,Rating Int,Suggestion varchar(500),Answer varchar(500),Remarks varchar(max),ActivationDate datetime)  
  
Insert into #FInalData(Id,ClientCode,UserType,SurveyDate,Rating,Response_Date,ActivationDate,NPSType)  
  
Select Id,ClientCode,case when Nps_Srno=1 then 'In-experienced' else 'Experienced' end as UserType,  
SurveyDate,Answer,DtCreated,ActivationDate,Nps_Srno from #Final Where isnumeric(Answer)=1  
  
Update A set  A.Response_Date=B.DtCreated,A.Suggestion=B.Question,A.Remarks=B.Remarks,A.Answer=B.Answer  
from #FInalData A inner join #final B on A.id=B.Id Where isnumeric(B.Answer)=0  
  
truncate table NPS_MIS  
  
insert into NPS_MIS  
 select ClientCode,Region,Branch_Cd as BranchCode,Sub_broker,UserType,SurveyDate,Response_Date,Rating,Suggestion,  
 Answer as Suggestion_Type,Remarks,ActivationDate ,p.Persona,p.OnBoardingPersona,gender=sex,Age=datediff(yy,dob,getdate()),
 cd.b2c,[Online]=case when ebroking='Y' then 'Yes' else 'No' end,mobile_pager,short_name ,NPSType as Nps_Srno
 from #FInalData a With(Nolock)  
 inner merge join Intranet.Risk.Dbo.Client_Details cd with(Nolock) on a.ClientCode=cd.cl_code  
 Left outer join [Mimansa].CRm.dbo.Vw_ClientPersonaDetails P with(Nolock) on a.clientcode=p.Party_Code  
   
  --where Question is null  
   
--select * from #final where id=100407  
--select * from #finalData where id=100407  
  
--select * from #final where id=14356  
--select * from #finalData --where id=14356  
  
  
drop table #FInalData  
drop table #FInal  
  
--replaced by suraj and renil on 26-04-2017  
--exec NPS_MISMail  
  
exec intranet.risk.dbo.NPS_MISMail

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_getmisdeatils_nps_survey_dashBoard
-- --------------------------------------------------


--select * from tbl_Survey where partycode=100407

-- select * from NPS_SurveyLog where id=100407

--select * from tbl_QuestionMaster
--select * from tbl_AnswerMaster
--select top 100 * from Intranet.Risk.Dbo.Client_Details cd with(Nolock)

CREATE proc [dbo].[spx_getmisdeatils_nps_survey_dashBoard]

as

SELECT 
A.PARTYCODE as Id,B.CLIENTCODE,B.Nps_Srno,B.TriggerDate As SurveyDate,A.QuestionId,A.AnswerId,Remarks,
A.DtCreated,NPSType,Question,ANSWER,Convert (varchar(12),KYCActivationDate,101) as ActivationDate
into #Final
FROM tbl_Survey A WITH(NOLOCK) INNER JOIN NPS_SurveyLog B WITH(NOLOCK)
ON A.PARTYCODE=B.ID
INNER JOIN tbl_QuestionMaster C WITH(NOLOCK) ON A.QuestionId=C.ID
inner JOIN tbl_AnswerMaster D WITH(NOLOCK) ON a.ANSWERID=D.ID --and C.Id=D.QuestionId

order by dtCreated desc


Create Table #FInalData(Id int,ClientCode varchar(12),UserType varchar(20),
SurveyDate datetime,Response_Date datetime,Rating Int,Suggestion varchar(500),Answer varchar(500),Remarks varchar(max),ActivationDate datetime)

Insert into #FInalData(Id,ClientCode,UserType,SurveyDate,Rating,Response_Date,ActivationDate)

Select Id,ClientCode,case when Nps_Srno=1 then 'In-experienced' else 'Experienced' end as UserType,
SurveyDate,Answer,DtCreated,ActivationDate from #Final Where isnumeric(Answer)=1

Update A set  A.Response_Date=B.DtCreated,A.Suggestion=B.Question,A.Remarks=B.Remarks,A.Answer=B.Answer
from #FInalData A inner join #final B on A.id=B.Id Where isnumeric(B.Answer)=0


 select ClientCode,Region,Branch_Cd as BranchCode,Sub_broker,UserType,SurveyDate,Response_Date,Rating,Suggestion,
 Answer as Suggestion_Type,Remarks,ActivationDate	,p.Persona,p.OnBoardingPersona,gender=sex,Age=datediff(yy,dob,getdate()),cd.b2c,[Online]=case when ebroking='Y' then 'Yes' else 'No' end,mobile_pager,short_name 
 from #FInalData a With(Nolock)
 left outer  join INTRANET.Risk.Dbo.Client_Details cd with(Nolock) on a.ClientCode=cd.cl_code
 Left outer join [Mimansa].CRm.dbo.Vw_ClientPersonaDetails P with(Nolock) on a.clientcode=p.Party_Code
 


drop table #FInalData
drop table #FInal

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_NPS_PushDataFromBo
-- --------------------------------------------------
CREATE proc [dbo].[Spx_NPS_PushDataFromBo]
As

Begin

Select Cl_Code,MIN(Active_Date) as ActivationDate into #Active_Date
from Anand1.MSajag.dbo.client_Brok_Details With(Nolock)
where Inactive_From>GETDATE() 
and Active_Date >= convert(varchar(11),getdate()-1) and Active_Date <= convert(varchar(11),getdate() + ' 23:59:59')                    
 group by cl_code

delete from #Active_Date where cl_code like '98%'
delete from #Active_Date where cl_code like '88%'


--select * from #Active_Date order by 1 desc


select cd.cl_code,cd.Long_Name,cd.Mobile_Pager,cd.Email,a.ActivationDate
into #finalData
from #Active_Date a  inner merge join Anand1.MSajag.dbo.client_Details cd With(Nolock)
on a.cl_code=cd.cl_code

 Alter table #finalData add EncryptedValue varbinary(150)

 OPEN SYMMETRIC KEY SurveyEncrypt DECRYPTION BY CERTIFICATE SurveyCert;        
 
 Update #finalData set EncryptedValue=EncryptByKey(Key_GUID('SurveyEncrypt'),Cl_Code)

 select * from #finalData



select Cl_Code as client_code,long_name,Email,Mobile_Pager as Mobile,master.dbo.fn_varbintohexstr(EncryptedValue) as EncRyptedPartyCode,
'Test.angelbroking.com/User/Common?party_code='+master.dbo.fn_varbintohexstr(EncryptedValue) as URL
from #finalData   where isnull(email,'')<>''

--drop table #finalData


End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.use_Insert_answer
-- --------------------------------------------------

CREATE PROCEDURE use_Insert_answer
@PartyCode varchar(50),
@CampaignId int,
@QuestionId bigint,
@AnswerId bigint,
@Remarks varchar(500),
@ActiveBeyondThirtyDays bit,
@URL varchar(500),
@RefURL varchar(500),
@IPAddress varchar(30),
@Device varchar(50),
@Browser varchar(50),
@OS varchar(50),
--@DtCreated varchar(50) = getdate(),
@NPSType varchar(15)
AS
BEGIN
							INSERT INTO [tbl_Survey_test] ( 
							[PartyCode],[CampaignId],[QuestionId],[AnswerId],
							[Remarks],[ActiveBeyondThirtyDays],[URL],[RefURL],
							[IPAddress],[Device],[Browser],[OS],[DtCreated],[NPSType])
							VALUES(
							@PartyCode,@CampaignId,@QuestionId,@AnswerId,@Remarks,@ActiveBeyondThirtyDays,
							@URL,@RefURL,@IPAddress,@Device,@Browser,@OS,cast(GETDATE() as smalldatetime),@NPSType
							)
							select 1
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_NPS_CLIENT_DATA
-- --------------------------------------------------
-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 04-07-2017
-- DESCRIPTION:	TO GET USER NPS DATA
/*
USP_GET_NPS_CLIENT_DATA 'P74798'
*/

-- =============================================
CREATE PROCEDURE [dbo].[USP_GET_NPS_CLIENT_DATA]
	@ClientCode VARCHAR(50)
	
AS
BEGIN


		Declare @CountRating int
		declare @Party_Code varchar(12)
		declare @Nps_SrNo int
		declare @Decparty_Code int
		
		

		select ID,ClientCode,Nps_SrNo into #tempNpsLog from nps_surveylog  With(Nolock) where ClientCode=@ClientCode --and Rating is not null

		select @Party_Code=ClientCode,@Nps_SrNo=Nps_SrNo,@Decparty_Code = id from #tempNpsLog

		Select  @CountRating=COUNT(0) from tbl_Survey With(Nolock) where partyCode=@ClientCode 

		select @Decparty_Code As Id,@Party_Code as Party_Code,@Nps_SrNo as NpsId,Case When @CountRating>0 then 'Y' else 'N' end As IsExist
/*
		into #temp
		
		select * from #temp





select '1'

select top 10 ID,ClientCode,Nps_SrNo from nps_surveylog  where ClientCode=@ClientCode
*/


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_NPS_CLIENT_DATA_TEST
-- --------------------------------------------------


-- =============================================
-- AUTHOR:		SURAJ PATIL
-- CREATE DATE: 04-07-2017
-- DESCRIPTION:	TO GET USER NPS DATA
/*
USP_GET_NPS_CLIENT_DATA 'P74798'
*/

-- =============================================
CREATE PROCEDURE USP_GET_NPS_CLIENT_DATA_TEST
	@ClientCode VARCHAR(50)
	
AS
BEGIN


		Declare @CountRating int
		declare @Party_Code varchar(12)
		declare @Nps_SrNo int
		declare @Decparty_Code int
		
		
/*
		select ID,ClientCode,Nps_SrNo into #tempNpsLog from nps_surveylog  With(Nolock) where ClientCode=@ClientCode --and Rating is not null

		select @Party_Code=ClientCode,@Nps_SrNo=Nps_SrNo,@Decparty_Code = id from #tempNpsLog

		Select  @CountRating=COUNT(0) from tbl_Survey With(Nolock) where partyCode=@ClientCode 

		select @Decparty_Code As Id,@Party_Code as Party_Code,@Nps_SrNo as NpsId,Case When @CountRating>0 then 'Y' else 'N' end As IsExist
		into #temp
		
		select * from #temp






select '1'
*/

select top 10 ID,ClientCode,Nps_SrNo from nps_surveylog  where ClientCode=@ClientCode


END

GO

-- --------------------------------------------------
-- TABLE dbo.NPS_MIS
-- --------------------------------------------------
CREATE TABLE [dbo].[NPS_MIS]
(
    [ClientCode] VARCHAR(12) NULL,
    [Region] VARCHAR(50) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NOT NULL,
    [UserType] VARCHAR(20) NULL,
    [SurveyDate] DATETIME NULL,
    [Response_Date] DATETIME NULL,
    [Rating] INT NULL,
    [Suggestion] VARCHAR(500) NULL,
    [Suggestion_Type] VARCHAR(500) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [ActivationDate] DATETIME NULL,
    [Persona] VARCHAR(8000) NULL,
    [OnBoardingPersona] VARCHAR(10) NULL,
    [gender] CHAR(1) NULL,
    [Age] INT NULL,
    [b2c] VARCHAR(1) NULL,
    [Online] VARCHAR(3) NOT NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [Nps_Srno] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPS_MIS_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[NPS_MIS_temp]
(
    [ClientCode] VARCHAR(12) NULL,
    [Region] VARCHAR(50) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NOT NULL,
    [UserType] VARCHAR(20) NULL,
    [SurveyDate] DATETIME NULL,
    [Response_Date] DATETIME NULL,
    [Rating] INT NULL,
    [Suggestion] VARCHAR(500) NULL,
    [Suggestion_Type] VARCHAR(500) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [ActivationDate] DATETIME NULL,
    [Persona] VARCHAR(8000) NULL,
    [OnBoardingPersona] VARCHAR(10) NULL,
    [gender] CHAR(1) NULL,
    [Age] INT NULL,
    [b2c] VARCHAR(1) NULL,
    [Online] VARCHAR(3) NOT NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [short_name] VARCHAR(21) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPS_SurveyLog
-- --------------------------------------------------
CREATE TABLE [dbo].[NPS_SurveyLog]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ClientCode] VARCHAR(20) NULL,
    [NPS_Srno] VARCHAR(5) NULL,
    [NPS_Campaignid] INT NULL,
    [KYCActivationDate] DATETIME NULL,
    [TriggerDate] DATETIME NULL,
    [FilledDate] DATETIME NULL,
    [Rating] INT NULL,
    [Channel] VARCHAR(50) NULL,
    [URL] VARCHAR(250) NULL,
    [EncId] VARBINARY(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NPS_Type
-- --------------------------------------------------
CREATE TABLE [dbo].[NPS_Type]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [NPS_Type] VARCHAR(5) NULL,
    [NPS_Startday] INT NULL,
    [NPS_EndDay] INT NULL,
    [Active] CHAR(1) NULL,
    [Campaignid] INT NULL,
    [Addedby] VARCHAR(20) NULL,
    [Addedon] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.re
-- --------------------------------------------------
CREATE TABLE [dbo].[re]
(
    [ClientCode] VARCHAR(12) NULL,
    [Region] VARCHAR(50) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NOT NULL,
    [UserType] VARCHAR(20) NULL,
    [SurveyDate] DATETIME NULL,
    [Response_Date] DATETIME NULL,
    [Rating] INT NULL,
    [Suggestion] VARCHAR(500) NULL,
    [Suggestion_Type] VARCHAR(500) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [ActivationDate] DATETIME NULL,
    [Persona] VARCHAR(8000) NULL,
    [OnBoardingPersona] VARCHAR(10) NULL,
    [gender] CHAR(1) NULL,
    [Age] INT NULL,
    [b2c] VARCHAR(1) NULL,
    [Online] VARCHAR(3) NOT NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [short_name] VARCHAR(21) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Survey_ERROR
-- --------------------------------------------------
CREATE TABLE [dbo].[Survey_ERROR]
(
    [ErrID] INT NOT NULL,
    [ErrTime] DATETIME NULL,
    [ErrObject] VARCHAR(8000) NULL,
    [ErrLine] INT NULL,
    [ErrMessage] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AnswerMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AnswerMaster]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [QuestionId] BIGINT NOT NULL,
    [Answer] VARCHAR(500) NOT NULL,
    [IsActive] BIT NOT NULL DEFAULT ((1)),
    [DtCreated] SMALLDATETIME NULL DEFAULT (getdate()),
    [UserSpecificationRequired] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CampaignMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CampaignMaster]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [CampaignName] VARCHAR(500) NOT NULL,
    [FromDate] SMALLDATETIME NULL,
    [ToDate] SMALLDATETIME NULL,
    [IsActive] BIT NULL DEFAULT ((1)),
    [DtCreated] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ErrorLogs
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ErrorLogs]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [RequestPage] VARCHAR(500) NOT NULL,
    [ErrorMessage] VARCHAR(MAX) NOT NULL,
    [StackTrace] VARCHAR(MAX) NOT NULL,
    [DtCreated] SMALLDATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_QuestionMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_QuestionMaster]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [CampaignId] INT NOT NULL,
    [Question] VARCHAR(500) NOT NULL,
    [IsActive] BIT NOT NULL DEFAULT ((1)),
    [DtCreated] SMALLDATETIME NOT NULL DEFAULT (getdate()),
    [QuestionType] VARCHAR(50) NULL,
    [IsExperiencedUser] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Survey
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Survey]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [PartyCode] VARCHAR(10) NOT NULL,
    [CampaignId] INT NOT NULL,
    [QuestionId] BIGINT NOT NULL,
    [AnswerId] BIGINT NOT NULL,
    [Remarks] VARCHAR(500) NULL,
    [ActiveBeyondThirtyDays] BIT NOT NULL DEFAULT ((0)),
    [URL] VARCHAR(500) NULL,
    [RefURL] VARCHAR(500) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [Device] VARCHAR(50) NULL,
    [Browser] VARCHAR(50) NULL,
    [OS] VARCHAR(50) NULL,
    [DtCreated] SMALLDATETIME NULL DEFAULT (getdate()),
    [NPSType] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Survey_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Survey_test]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [PartyCode] VARCHAR(10) NOT NULL,
    [CampaignId] INT NOT NULL,
    [QuestionId] BIGINT NOT NULL,
    [AnswerId] BIGINT NOT NULL,
    [Remarks] VARCHAR(500) NULL,
    [ActiveBeyondThirtyDays] BIT NOT NULL,
    [URL] VARCHAR(500) NULL,
    [RefURL] VARCHAR(500) NULL,
    [IPAddress] VARCHAR(30) NULL,
    [Device] VARCHAR(50) NULL,
    [Browser] VARCHAR(50) NULL,
    [OS] VARCHAR(50) NULL,
    [DtCreated] SMALLDATETIME NULL,
    [NPSType] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_NPS_Surveydata
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_NPS_Surveydata]
(
    [id] INT NOT NULL,
    [ClientCode] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [email] VARCHAR(50) NULL,
    [Mobile_pager] VARCHAR(40) NULL,
    [Nps_Type] VARCHAR(5) NULL,
    [URL] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.NPS_ClientWise_SurveryDate
-- --------------------------------------------------
Create View [dbo].[NPS_ClientWise_SurveryDate]
as
select ClientCode,FirstTriggerDate=Min(TriggerDate),LastTriggerDate=max(TriggerDate) from NPS_Survey with (nolock)
group by ClientCode

GO

-- --------------------------------------------------
-- VIEW dbo.NPS_Survey
-- --------------------------------------------------
CREATE View [dbo].[NPS_Survey]
as
select ClientCode,y.NPS_Type,NPS_Campaignid,KYCActivationDate,TriggerDate,FilledDate,Rating,Channel,NPS_Srno from NPS_SurveyLog x inner join 
(select * from NPS_Type where Active='Y')y on x.NPS_Srno=y.Srno

GO

-- --------------------------------------------------
-- VIEW dbo.Survey
-- --------------------------------------------------
CREATE View [dbo].[Survey]







  as







  select partycode,x.CampaignId,x.Questionid,x.Answerid,Question,Answer,NPSType,x.DtCreated,y.QuestionType from [tbl_Survey] x 







  inner join (select * from tbl_QuestionMaster where IsActive=1) y on x.Questionid=y.Id







  inner join (select * from tbl_AnswerMaster where IsActive=1) z on x.Answerid=z.id

GO

-- --------------------------------------------------
-- VIEW dbo.Vi_NpsRating
-- --------------------------------------------------

--Select * from Vi_NpsRating
CREATE View Vi_NpsRating
As

select a.ClientCode as Party_Code,Answer from NPS_SurveyLog  a inner join 
tbl_Survey b on a.Id=b.PartyCode
inner join tbl_QuestionMaster C With(Nolock) on c.Id=b.QuestionId
inner join tbl_AnswerMaster An With(Nolock) on b.Answerid=An.Id

where b.QuestionId=1 and Answer in ('9','10')

GO

