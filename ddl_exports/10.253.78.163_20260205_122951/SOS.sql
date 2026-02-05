-- DDL Export
-- Server: 10.253.78.163
-- Database: SOS
-- Exported: 2026-02-05T12:32:31.024072

USE SOS;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLAClientDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAClientDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLAClientDetail_SOS_Stgtbl_PMLABusinessNature] FOREIGN KEY ([ICBusinessId]) REFERENCES [dbo].[SOS_Stgtbl_PMLABusinessNature] ([IBusinessId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLAClientDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAClientDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLAClientDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([ICFrmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLADepositoryAccountDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLADepositoryAccountDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLADepositoryAccountDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([IDAFirmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLADirectorDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLADirectorDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLADirectorDetail_SOS_Stgtbl_PMLABusinessNature] FOREIGN KEY ([IDBusinessId]) REFERENCES [dbo].[SOS_Stgtbl_PMLABusinessNature] ([IBusinessId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLADirectorDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLADirectorDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLADirectorDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([IDFirmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLAJointAccountDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAJointAccountDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLAJointAccountDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([IJointAccFirmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLAPEPDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAPEPDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLAPEPDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([IPEPFirmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLAPEPDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAPEPDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLAPEPDetail_SOS_Stgtbl_PMLARelationship] FOREIGN KEY ([IPEPRelationId]) REFERENCES [dbo].[SOS_Stgtbl_PMLARelationship] ([IRelationId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLARelationDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLARelationDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLARelationDetail_SOS_Stgtbl_PMLAFirmDetail] FOREIGN KEY ([IRelFirmSOSId]) REFERENCES [dbo].[SOS_Stgtbl_PMLAFirmDetail] ([IFirmSOSId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SOS_Stgtbl_PMLARelationDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLARelationDetail] ADD CONSTRAINT [FK_SOS_Stgtbl_PMLARelationDetail_SOS_Stgtbl_PMLARelationship] FOREIGN KEY ([IRelRelationId]) REFERENCES [dbo].[SOS_Stgtbl_PMLARelationship] ([IRelationId])

GO

-- --------------------------------------------------
-- FUNCTION dbo.CLIENT_SEGMENTDATEWISE
-- --------------------------------------------------
--select dbo.CLIENT_SEGMENTDATEWISE('8-Apr-2013')

CREATE FUNCTION [dbo].[CLIENT_SEGMENTDATEWISE] ( @DATE DATETIME,@DATE2 DATETIME )
RETURNS TABLE
AS
RETURN
(
 
SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                  
 FROM  [196.1.115.196].MSAJAG.DBO.CmBillValan WITH (NOLOCK)
WHERE  --PARTY_CODE='FRD491' AND       
 SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121))AND
SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'
AND  CONTRACTNO<>'0'   
 
 UNION
 SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                  
 FROM ANAND.BSEDB_AB.DBO.CmBillValan WITH (NOLOCK)
WHERE -- PARTY_CODE='FRD491' AND       
 SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121)) AND
   SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'
AND  CONTRACTNO<>'0'
 UNION
 SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                  
 FROM [196.1.115.200].nsefo.dbo.FoBillValan WITH (NOLOCK)
WHERE --PARTY_CODE='FRD491' AND       
 SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121)) AND
SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'
AND  CONTRACTNO<>'0'   
 
 UNION 
 
  
 
SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                  
 FROM ANGELCOMMODITY.mcdx.dbo.FoBillValan WITH (NOLOCK)   
 WHERE --PARTY_CODE='FRD491' AND       
 SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121)) AND
  SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'
AND  CONTRACTNO<>'0'  
 
 UNION     
     
 SELECT EXCHANGE,A.PARTY_CODE AS [CLIENT CODE],A.Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,A.SAUDA_DATE,103)                                  
 FROM ANGELCOMMODITY.ncdx.dbo.FoBillValan A WITH (NOLOCK) 
                INNER JOIN 
                ANGELCOMMODITY.NCDX.DBO.FOSETTLEMENT B WITH (NOLOCK) 
    ON A.CONTRACTNO = B.CONTRACTNO AND A.PARTY_CODE = B.PARTY_CODE 
    where --A.party_code='FRD491'  and 
                 B.Sauda_date>= convert(datetime,convert(varchar(11),@DATE,121)) AND
      B.SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'    
    AND  A.CONTRACTNO<>'0'   
 UNION    
 
   
 SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                   
 from ANGELCOMMODITY.mcdxcds.dbo.FoBillValan WITH (NOLOCK)   
 WHERE --PARTY_CODE='FRD491' AND       
 SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121)) AND 
 SAUDA_DATE< convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000' 
 AND  CONTRACTNO<>'0'    
     
 UNION    
                                    
 SELECT EXCHANGE,PARTY_CODE AS [CLIENT CODE],Sub_Broker AS SUBBROKER,SAUDA_DATE =convert(varchar,SAUDA_DATE,103)                                   
 from angelfo.nsecurfo.DBO.FoBillValan WITH (NOLOCK)                                
 WHERE --PARTY_CODE='FRD491' AND       
   SAUDA_DATE >= convert(datetime,convert(varchar(11),@DATE,121)) AND
   SAUDA_DATE<= convert(datetime,convert(varchar(11),@DATE2,121))+'23:59:59.000'
AND  CONTRACTNO<>'0'        
)

GO

-- --------------------------------------------------
-- INDEX dbo.Stgtbl_ClientDetails_Broking
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_Stgtbl_ClientDetails_Broking] ON [dbo].[Stgtbl_ClientDetails_Broking] ([PAN])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLAAffClientDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAAffClientDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLAAffClientDetail] PRIMARY KEY ([IAffClientId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLABusinessNature
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLABusinessNature] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLABusinessNature] PRIMARY KEY ([IBusinessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLAClientDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAClientDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLAClientDetail] PRIMARY KEY ([IClientId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLADepositoryAccountDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLADepositoryAccountDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLADepositoryAccountDetail] PRIMARY KEY ([IDPAccId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLADirectorDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLADirectorDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLADirectorDetail] PRIMARY KEY ([IDirectorId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLAFirmDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAFirmDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLAFirmDetail] PRIMARY KEY ([IFirmSOSId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLAJointAccountDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAJointAccountDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLAJointAccountDetail] PRIMARY KEY ([IJointAccId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLAPEPDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLAPEPDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLAPEPDetail] PRIMARY KEY ([IPEPId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLARelationDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLARelationDetail] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLARelationDetail] PRIMARY KEY ([IRelationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SOS_Stgtbl_PMLARelationship
-- --------------------------------------------------
ALTER TABLE [dbo].[SOS_Stgtbl_PMLARelationship] ADD CONSTRAINT [PK_SOS_Stgtbl_PMLARelationship] PRIMARY KEY ([IRelationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBL_SOSJOBLOG
-- --------------------------------------------------
ALTER TABLE [dbo].[TBL_SOSJOBLOG] ADD CONSTRAINT [PK__TBL_SOSJ__3214EC271B0907CE] PRIMARY KEY ([ID])

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
-- PROCEDURE dbo.SPX_BINDGRID
-- --------------------------------------------------
          
          
  CREATE PROCEDURE SPX_BINDGRID          
            
  AS          
      
  SELECT REG_CODE , RMEMPNO,  RMEMPNO+' : '+ VE.EMP_Name AS  RM_EMPNO, EMAIL , CREATED_BY ,      
  CONVERT(VARCHAR(12),CREATION_DATE,103) AS CREATION_DATE, UPDATED_BY+' : '+ AVE.EMP_Name AS  UPDATED_BY, 
  CONVERT(VARCHAR(12),UPDATION_DATE,103) AS  UPDATION_DATE      
  FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)    
  LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)        
  ON TS.RMEMPNO = VE.EMP_NO       
  LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL AVE WITH(NOLOCK)        
  ON TS.UPDATED_BY = AVE.EMP_NO    ORDER BY REG_CODE    
      
      
  --SELECT distinct TS.*, VE.EMP_Name, REG.REGIONCODE FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)        
--LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)        
--ON TS.RMEMPNO = VE.EMP_NO        
--LEFT OUTER JOIN ANAND1.MSAJAG.DBO.REGION REG WITH(NOLOCK)        
--ON TS.REG_CODE = REG.REGIONCODE        
--WHERE RMEMPNO = @RMCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_BindRegionCode
-- --------------------------------------------------
  
  
  CREATE procedure Spx_BindRegionCode  
    
  as  
  select distinct RegionCode from anand1.msajag.dbo.region with(Nolock)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_BINDREGIONNAME
-- --------------------------------------------------
    
-- EXEC SPX_BINDREGIONNAME 'A P'    
    
CREATE PROCEDURE SPX_BINDREGIONNAME    
(    
@REGIONCODE VARCHAR(30)    
)    
    
AS    

DECLARE @COUNT AS INT 

SELECT @COUNT = COUNT(*) FROM TBL_SOSRMDETAILS WHERE Reg_Code = @REGIONCODE

IF (@COUNT>0)
BEGIN

SELECT DISTINCT TS.REG_CODE AS REGIONCODE, TS.RMEMPNO AS RMEMPNO, TS.EMAIL AS MAILID,  
 VE.EMP_NAME AS NAME, REG.DESCRIPTION AS REGIONNAME FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)    
LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)    
ON TS.RMEMPNO = VE.EMP_NO    
LEFT OUTER JOIN ANAND1.MSAJAG.DBO.REGION REG WITH(NOLOCK)    
ON TS.REG_CODE = REG.REGIONCODE    
WHERE REG_CODE = @REGIONCODE  --RMEMPNO = @RMEMPNO AND 

END

ELSE
    
BEGIN

SELECT DISTINCT[DESCRIPTION] AS REGIONNAME FROM anand1.msajag.dbo.region WITH(NOLOCK)    
WHERE REGIONCODE=@REGIONCODE 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_deleteSOSFirmRelationRecordById
-- --------------------------------------------------
CREATE PROC Spx_deleteSOSFirmRelationRecordById
@SOSFirmId int
AS
UPDATE dbo.SOS_Stgtbl_PMLAFirmDetail
SET BFirmIsActive=0
WHERE IFirmSOSId=@SOSFirmId

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_getBaneOnClientCode
-- --------------------------------------------------
  
  
CREATE proc Spx_getBaneOnClientCode  
(  
  @Cl_Code varchar(12)  
)  
  
as  
  
Select long_name,(CASE
        WHEN cl_status ='IND' THEN 'I'
        ELSE 'NI'
        END) as [Type],cl_code as partycode
 from Anand1.Msajag.dbo.client_details with(nolock)  
where cl_code=@Cl_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_GETCLIENTRISKCATEGORYDETAILS
-- --------------------------------------------------

-- exec SPX_GETCLIENTRISKCATEGORYDETAILS 'B13282'
CREATE PROC SPX_GETCLIENTRISKCATEGORYDETAILS
(
 @PARTY_CODE VARCHAR(12)
)
AS

DECLARE @PARTY_CODE1 VARCHAR(12)
SET @PARTY_CODE1=LTRIM(RTRIM(@PARTY_CODE))

SELECT CLIENTCODE,RISKTYPE FROM STGTBL_CLIENTRISKCATEGORY WITH(NOLOCK)
 WHERE CLIENTCODE=@PARTY_CODE1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_getDPNameOnDPId
-- --------------------------------------------------

--IN300280
--IN300484
Create Proc Spx_getDPNameOnDPId
(
 @DpId varchar(16)
)

as

SELECT BankId,BankName from [196.1.115.201].bsedb_AB.dbo.bANK WITH(NOLOCK)
where bankid=@DpId

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_GETEMPANDREGIONCODE
-- --------------------------------------------------

--SELECT * FROM ANAND1.MSAJAG.DBO.REGION  ORDER BY REGIONCODE
-- EXEC SPX_GETEMPANDREGIONCODE 'E00526', 'ANDHRA PRADESH'

CREATE PROCEDURE SPX_GETEMPANDREGIONCODE
(
@RMEMPNO VARCHAR(20),
@REGIONCODE VARCHAR(50)
)

AS


SELECT DISTINCT TS.REG_CODE AS REGIONCODE, TS.RMEMPNO AS RMEMPNO, TS.EMAIL AS MAILID,
 VE.EMP_NAME AS NAME, REG.DESCRIPTION AS REGIONNAME FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)  
LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)  
ON TS.RMEMPNO = VE.EMP_NO  
LEFT OUTER JOIN ANAND1.MSAJAG.DBO.REGION REG WITH(NOLOCK)  
ON TS.REG_CODE = REG.REGIONCODE  
WHERE RMEMPNO = @RMEMPNO AND REG_CODE = @REGIONCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_GETEMPNAME
-- --------------------------------------------------
    
-- EXEC SPX_GETEMPNAME 'E43455'   
    
CREATE PROCEDURE SPX_GETEMPNAME    
(    
@EMPCODE VARCHAR(6)    
)    
    
AS    
    
SELECT EMP_NAME, EMAILADD FROM [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL WITH(NOLOCK)    
WHERE EMP_NO=@EMPCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_getPartyCodeDetail
-- --------------------------------------------------
      
      
CREATE proc Spx_getPartyCodeDetail  
(      
  @Cl_Code varchar(12)      
)      
      
as      
 IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLAFirmDetail WHERE SFirmPartyCode=@Cl_Code and BFirmIsActive=1)  
 BEGIN  
 Select long_name,(CASE    
        WHEN cl_status ='IND' THEN 'I'    
        ELSE 'NI'    
        END) as [Type],cl_code as partycode    
 from Anand1.Msajag.dbo.client_details with(nolock)      
where cl_code=@Cl_Code     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetRelationRecordByFirmId
-- --------------------------------------------------
CREATE PROC Spx_GetRelationRecordByFirmId 
 @SOSFirmID INT    
 AS    
--SET @SOSFirmID=2    
    
    
SELECT SF.IFirmSOSId,SF.SFirmPartyCode,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)        
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,SF.CFirmType,SF.IFirmKRA,(CASE SF.DFirmKRAdate WHEN NULL THEN ''     
ELSE CONVERT(VARCHAR(13),SF.DFirmKRAdate,103) END) AS KRADATE,  
SF.IResidentialDetailId,  
SO.IOccupationId,SO.SOccEmployerName,SO.SOccAddress,SO.SOccDesignation,SO.IOccBussinessNatureId,SO.SOccBusinessNature,    
SA.IAffClientId,SA.IAffRelationName,SA.IAffRelationId,SA.IAffBussinessNatureId,SA.IAffBusinessNature,SA.IAffEntityType,SA.SAffRelRelationName,    
JA.IJointAccId,JA.SJointAccSecondHolderName,JA.SJointAccThirdHolderName,    
SP.IPEPId,SP.SPEPName,SP.IPEPRelationId,SP.SPEPPANNumber,SPEPRelationName,    
SC.IClientId,SC.SCFormerName,SC.ICBusinessId,SC.ICBusinessNature,SC.ICCountryId,SC.ICCountry,SC.ICMajorCountryId,SC.ICMajorCountry    
 FROM SOS_Stgtbl_PMLAFirmDetail SF  with(Nolock)  
LEFT JOIN SOS_Stgtbl_PMLAOccupationDetail SO with(Nolock) ON SO.IOccIFirmSOSId=SF.IFirmSOSId    
LEFT JOIN  SOS_Stgtbl_PMLAAffClientDetail SA with(Nolock) ON SA.IAffFirmSOSId=SF.IFirmSOSId    
LEFT JOIN   dbo.SOS_Stgtbl_PMLAJointAccountDetail JA with(Nolock) ON JA.IJointAccFirmSOSId=SF.IFirmSOSId    
LEFT JOIN   dbo.SOS_Stgtbl_PMLAPEPDetail SP with(Nolock) ON  SP.IPEPFirmSOSId=SF.IFirmSOSId    
LEFT JOIN  dbo.SOS_Stgtbl_PMLAClientDetail SC with(Nolock) ON SC.ICFrmSOSId=SF.IFirmSOSId    
    
WHERE sf.IFirmSOSId=@SOSFirmID    
    
 SELECT  IRelationId,SRelUCC,    
 (SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)        
WHERE CL_CODE=SRelUCC )  AS UCCNAme,IRelRelationId,SRelRelationName 
FROM SOS_Stgtbl_PMLARelationDetail WHERE IRelFirmSOSId=@SOSFirmID    
 SELECT IDPAccId,SDADepository,SDADPId,(SELECT BankName from [196.1.115.201].bsedb_AB.dbo.bANK WITH(NOLOCK)      
where bankid=SDADPId) as DPNAme,    
 (CASE SDADepository when 'CDSL' THEN SUBSTRING(SDAClientId,9,16)    
 ELSE                    
  SDAClientId    
  END)AS ClientID,SDAHolderName FROM SOS_Stgtbl_PMLADepositoryAccountDetail with(Nolock)
   WHERE IDAFirmSOSId=@SOSFirmID    
 SELECT IDirectorId,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDRelationName FROM 
 SOS_Stgtbl_PMLADirectorDetail with(Nolock) WHERE IDFirmSOSId=@SOSFirmID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetRelationRecordByPartyCode
-- --------------------------------------------------

   CREATE PROC Spx_GetRelationRecordByPartyCode -- 2      
 @Party_Code varchar(15)      
 AS      
--SET @SOSFirmID=2      
      
      
SELECT SF.IFirmSOSId,SF.SFirmPartyCode,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)          
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,SF.CFirmType,SF.IFirmKRA,(CASE SF.DFirmKRAdate WHEN NULL THEN ''       
ELSE CONVERT(VARCHAR(13),SF.DFirmKRAdate,103) END) AS KRADATE,    
SF.IResidentialDetailId,    
SO.IOccupationId,SO.SOccEmployerName,SO.SOccAddress,SO.SOccDesignation,SO.IOccBussinessNatureId,SO.SOccBusinessNature,      
SA.IAffClientId,SA.IAffRelationName,SA.IAffRelationId,SA.IAffBussinessNatureId,SA.IAffBusinessNature,SA.IAffEntityType,SA.SAffRelRelationName,      
JA.IJointAccId,JA.SJointAccSecondHolderName,JA.SJointAccThirdHolderName,      
SP.IPEPId,SP.SPEPName,SP.IPEPRelationId,SP.SPEPPANNumber,SPEPRelationName,      
SC.IClientId,SC.SCFormerName,SC.ICBusinessId,SC.ICBusinessNature,SC.ICCountryId,SC.ICCountry,SC.ICMajorCountryId,SC.ICMajorCountry      
 FROM SOS_Stgtbl_PMLAFirmDetail SF      
LEFT JOIN SOS_Stgtbl_PMLAOccupationDetail SO ON SO.IOccPartyCode=SF.SFirmPartyCode      
LEFT JOIN  SOS_Stgtbl_PMLAAffClientDetail SA ON SA.IAffPartyCode=SF.SFirmPartyCode      
LEFT JOIN   dbo.SOS_Stgtbl_PMLAJointAccountDetail JA ON JA.SJointAccPartyCode=SF.SFirmPartyCode      
LEFT JOIN   dbo.SOS_Stgtbl_PMLAPEPDetail SP ON SP.SPEPPartyCode=SF.SFirmPartyCode      
LEFT JOIN  dbo.SOS_Stgtbl_PMLAClientDetail SC ON SC.SCPartyCode=SF.SFirmPartyCode      
      
WHERE sf.SFirmPartyCode=@Party_Code      
      
 SELECT  IRelationId,SRelUCC,      
 (SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)          
WHERE CL_CODE=SRelUCC )  AS UCCNAme,IRelRelationId,SRelRelationName FROM SOS_Stgtbl_PMLARelationDetail WHERE SRelPartyCode=@Party_Code 
     
 SELECT IDPAccId,SDADepository,SDADPId,(SELECT BankName from [196.1.115.201].bsedb_AB.dbo.bANK WITH(NOLOCK)        
where bankid=SDADPId) as DPNAme,      
 (CASE SDADepository when 'CDSL' THEN SUBSTRING(SDAClientId,9,16)      
 ELSE                      
  SDAClientId      
  END)AS ClientID,SDAHolderName FROM SOS_Stgtbl_PMLADepositoryAccountDetail WHERE IDAPartyCode=@Party_Code      
 SELECT IDirectorId,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDRelationName FROM SOS_Stgtbl_PMLADirectorDetail WHERE IDPartyCode=@Party_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_getSOSBusinessNature
-- --------------------------------------------------
CREATE PROC [dbo].[Spx_getSOSBusinessNature]
AS
SELECT IBusinessId as BusinessId,UPPER(SBusinessName) as BusinessName FROM dbo.SOS_Stgtbl_PMLABusinessNature WHERE BIsActive=1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_GETSOSID
-- --------------------------------------------------


 CREATE PROC SPX_GETSOSID
 @PARTYCODE VARCHAR(20)
 
 AS 
 SELECT IFIRMSOSID FROM SOS_STGTBL_PMLAFIRMDETAIL WHERE SFIRMPARTYCODE = @PARTYCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_getSOSRelationOnTypeId
-- --------------------------------------------------
CREATE PROC Spx_getSOSRelationOnTypeId  
@TypeId CHAR(5)  
  
AS  
  
SELECT IRelationId AS RELATIONID,SRelationName AS RELATIONAME,CType AS [TYPE] FROM dbo.SOS_Stgtbl_PMLARelationship WHERE CType=@TypeId AND BIsActive=1  
ORDER BY IRelationId ASC

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetSOSRelationShipRecord
-- --------------------------------------------------
CREATE PROC [dbo].[Spx_GetSOSRelationShipRecord]-- nuul,'04/02/2013' ,'04/02/2013'   
@PARTYCODE VARCHAR(50),  
@FromDate Datetime,  
@ToDate Datetime        
--@TYPE CHAR(5),          
--@KRA INT,          
--@KRADATE DATETIME          
          
AS          
          
--SET @PARTYCODE=null       
--SET @FromDate ='05/07/2013'  
--SET @ToDate  ='05/07/2013'            
----SET @KRADATE=NULL          
          
BEGIN     
DECLARE @StartDate VARCHAR(50)
DECLARE @EndDate VARCHAR(50)

IF  @PARTYCODE IS NOT NULL
BEGIN
SELECT SF.IFIRMSOSID,SF.SFIRMPARTYCODE,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)              
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,(CASE SF.CFIRMTYPE WHEN 'I' THEN'INDIVIDUAL'          
ELSE 'NON-INDIVIDUAL' END) AS [TYPE],          
(CASE SF.IFIRMKRA WHEN 1 THEN'YES'          
ELSE 'NO' END) AS [KRA],          
CONVERT(varchar(13),SF.DFIRMKRADATE,103) AS KRADATE,
CONVERT(varchar(13),DFirmCreatedDate,103) AS CreateDate          
  FROM SOS_STGTBL_PMLAFIRMDETAIL SF          
WHERE           
SF.BFIRMISACTIVE=1          
AND SFIRMPARTYCODE = @PARTYCODE         
   order by CLIENTNAME asc       
END

IF  @FromDate IS NOT NULL  
BEGIN
SET @StartDate=CONVERT(DATETIME,@FromDate,103)
SET @EndDate=CONVERT(DATETIME,@ToDate,103)+ '23:59:59'
SELECT SF.IFIRMSOSID,SF.SFIRMPARTYCODE,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)              
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,(CASE SF.CFIRMTYPE WHEN 'I' THEN'INDIVIDUAL'          
ELSE 'NON-INDIVIDUAL' END) AS [TYPE],          
(CASE SF.IFIRMKRA WHEN 1 THEN'YES'          
ELSE 'NO' END) AS [KRA],          
CONVERT(varchar(13),SF.DFIRMKRADATE,103) AS KRADATE  ,
CONVERT(varchar(13),DFirmCreatedDate,103) AS CreateDate        
  FROM SOS_STGTBL_PMLAFIRMDETAIL SF          
        
WHERE           
SF.BFIRMISACTIVE=1          
AND DFirmCreatedDate>=@StartDate AND DFirmCreatedDate<=@EndDate       

   order by CLIENTNAME asc       
END

IF  @FromDate IS NOT NULL AND @PARTYCODE IS NOT NULL
BEGIN
SET @StartDate=CONVERT(DATETIME,@FromDate,103)
SET @EndDate=CONVERT(DATETIME,@ToDate,103) + '23:59:59'
SELECT SF.IFIRMSOSID,SF.SFIRMPARTYCODE,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)              
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,(CASE SF.CFIRMTYPE WHEN 'I' THEN'INDIVIDUAL'          
ELSE 'NON-INDIVIDUAL' END) AS [TYPE],          
(CASE SF.IFIRMKRA WHEN 1 THEN'YES'          
ELSE 'NO' END) AS [KRA],          
CONVERT(varchar(13),SF.DFIRMKRADATE,103) AS KRADATE,
CONVERT(varchar(13),DFirmCreatedDate,103) AS CreateDate       
  FROM SOS_STGTBL_PMLAFIRMDETAIL SF          
        
WHERE           
SF.BFIRMISACTIVE=1          
AND DFirmCreatedDate>=@StartDate AND DFirmCreatedDate<=@EndDate       
AND (SFIRMPARTYCODE = @PARTYCODE)   
   order by CLIENTNAME asc       
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_GetSOSRelationShipRecord_1
-- --------------------------------------------------
CREATE PROC [dbo].[Spx_GetSOSRelationShipRecord_1] --null,'04/02/2013' ,'04/03/2013' 
@PARTYCODE VARCHAR(50),
@FromDate Datetime,
@ToDate Datetime      
--@TYPE CHAR(5),        
--@KRA INT,        
--@KRADATE DATETIME        
        
AS        
        
--SET @PARTYCODE=NULL        
--SET @TYPE=NULL        
--SET @KRA=NULL        
--SET @KRADATE=NULL        
        
BEGIN        
SELECT SF.IFIRMSOSID,SF.SFIRMPARTYCODE,(SELECT LONG_NAME FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)            
WHERE CL_CODE=SF.SFIRMPARTYCODE )  AS CLIENTNAME,(CASE SF.CFIRMTYPE WHEN 'I' THEN'INDIVIDUAL'        
ELSE 'NON-INDIVIDUAL' END) AS [TYPE],        
(CASE SF.IFIRMKRA WHEN 1 THEN'YES'        
ELSE 'NO' END) AS [KRA],        
CONVERT(varchar(13),SF.DFIRMKRADATE,103) AS KRADATE        
  FROM SOS_STGTBL_PMLAFIRMDETAIL SF        
      
WHERE         
SF.BFIRMISACTIVE=1        
AND ((SFIRMPARTYCODE = @PARTYCODE OR @PARTYCODE IS NULL)       
--AND (SF.CFIRMTYPE = @TYPE OR @TYPE IS NULL)        
--AND (SF.IFIRMKRA = @KRA OR @KRA IS NULL)     
 AND SF.DFirmCreatedDate BETWEEN ISNULL(@FromDate, SF.DFirmCreatedDate) AND ISNULL(@ToDate, SF.DFirmCreatedDate))

   
-- AND (SF.DFirmCreatedDate>= @FromDate OR @FromDate IS NULL)        
--AND (SF.DFirmCreatedDate<= @ToDate OR @ToDate IS NULL))
   order by CLIENTNAME asc     
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_INSERTAND_UPDATESOSMASTER
-- --------------------------------------------------
        
        
CREATE  PROCEDURE SPX_INSERTAND_UPDATESOSMASTER        
(        
@REGIONCODE VARCHAR(30),        
@REGIONNAME VARCHAR(30),        
@RMCODE VARCHAR(10),        
@EMPNAME VARCHAR(100),        
@EMAILID VARCHAR(100),        
@CREATEDBY VARCHAR(10)        
)        
        
AS        
  
  set @REGIONCODE=LTRIM(rtrim(@REGIONCODE))      
DECLARE @COUNT AS INT        
        
SELECT @COUNT = COUNT(*) FROM TBL_SOSRMDETAILS WHERE Reg_Code = @REGIONCODE        
        
IF(@COUNT > 0)        
BEGIN        
      
INSERT INTO TBL_SOSRMDETAILS_HISTORY (REG_CODE,RMEMPNO,EMAIL,CREATED_BY,CREATION_DATE,UPDATED_BY,UPDATION_DATE, EDIT_BY, EDIT_DATE)      
      
SELECT REG_CODE,RMEMPNO,EMAIL,CREATED_BY,CREATION_DATE,UPDATED_BY,UPDATION_DATE, @CREATEDBY, GETDATE()       
FROM TBL_SOSRMDETAILS WHERE REG_CODE=@REGIONCODE      
      
UPDATE TBL_SOSRMDETAILS SET RMEMPNO = @RMCODE, EMAIL = @EMAILID, UPDATED_BY = @CREATEDBY,        
UPDATION_DATE = GETDATE()        
 WHERE REG_CODE=@REGIONCODE        
       
 SELECT 'DATA UPDATED SUCCESSFULLY..'      
       
END        
        
ELSE        
        
BEGIN        
INSERT INTO TBL_SOSRMDETAILS (REG_CODE, RMEMPNO, EMAIL, CREATED_BY, CREATION_DATE)        
VALUES (@REGIONCODE, @RMCODE, @EMAILID, @CREATEDBY, GETDATE())        
      
SELECT 'DATA INSERTED SUCCESSFULLY..'      
      
END        
        
--SELECT distinct TS.*, VE.EMP_Name, REG.REGIONCODE FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)        
--LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)        
--ON TS.RMEMPNO = VE.EMP_NO        
--LEFT OUTER JOIN ANAND1.MSAJAG.DBO.REGION REG WITH(NOLOCK)        
--ON TS.REG_CODE = REG.REGIONCODE        
--WHERE RMEMPNO = @RMCODE      
   -- DECLARE @NAME VARCHAR(50)  
   -- DECLARE @UPDATED_BY VARCHAR(20)  
     
   --SELECT @UPDATED_BY=UPDATED_BY FROM  TBL_SOSRMDETAILS WHERE REG_CODE=@REGIONCODE  
   -- SELECT @NAME=EMP_NAME FROM [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)   
   -- WHERE @UPDATED_BY =EMP_NO   
      
  SELECT REG_CODE ,RMEMPNO,  RMEMPNO+' : '+ VE.EMP_NAME AS  RM_EMPNO, EMAIL , CREATED_BY ,      
   CONVERT(VARCHAR(12),CREATION_DATE,103) AS CREATION_DATE, UPDATED_BY +' : '+ AVE.EMP_Name AS  UPDATED_BY,     
   CONVERT(VARCHAR(12),UPDATION_DATE,103)  AS UPDATION_DATE     
  FROM TBL_SOSRMDETAILS TS WITH(NOLOCK)     
    LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL VE WITH(NOLOCK)          
  ON TS.RMEMPNO = VE.EMP_NO    --ORDER BY REG_CODE      
    LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL AVE WITH(NOLOCK)          
  ON TS.UPDATED_BY = AVE.EMP_NO    ORDER BY REG_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_SOS_PMLA_FirmRelationInsertUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[Spx_SOS_PMLA_FirmRelationInsertUpdate]        
@FirmSOSId int,        
@PartyCode varchar(50),        
@Type char(5),        
@KRA int,        
@KRADate datetime,        
@OccEmployeName varchar(50),        
@OccAddress varchar(500),        
@OccDesignation varchar(50),        
@AffRelationName varchar(50),        
@AffRelationId int,        
@BussinessId int,        
@BusinessName varchar(50),        
@EntityType VARCHAR(50),        
@PEPName varchar(50),        
@PEPRelationId int,        
@PEPPANNo varchar(50),        
@JASecondHolder varchar(50),        
@JAThirdHolder varchar(50),        
@RelationDetail varchar(2000),        
@DPDetail varchar(2000),        
@ClientFormerName varchar(50),        
@ClientBusinessId int,        
@ClientBusineesName varchar(50),        
@ClientCountryId int,        
@ClientCountryName varchar(50),        
@ClientMajorBCountryId int,        
@ClientMajorBCountryName varchar(50),        
@DirectorDetail varchar(2000),     
@UpdatedBY varchar(50),    
@AffRelRelationName varchar(50),  
@PEPRelationName varchar(50),  
@ResidentialId int,
@OccBussinesId int, 
@OccBusinessNature varchar(50), 
@returnVal int output        
        
As        
        
--SET @FirmSOSId =0        
--SET @PartyCode ='RP61'        
--SET @Type ='I'        
--SET @KRA =1        
--SET @KRADate ='4/2/2013'        
--SET @OccEmployeName =''        
--SET @OccAddress ='POWAI'        
--SET @OccDesignation ='SR.EXE'        
--SET @AffRelationName='CHANDA'        
--SET @AffRelationId=1        
--SET @BussinessId =1        
--SET @BusinessName='CONSULTANCY'        
--SET @EntityType='TRUST'        
--SET @PEPName=NULL        
--SET @PEPRelationId=''        
--SET @PEPPANNo =''        
--SET @JASecondHolder='SONI'        
--SET @JAThirdHolder=NULL        
--SET @RelationDetail='0~RP61~1,0~01307~2,0~0559~3,'        
--SET @DPDetail ='0~CDSL~IN300476~12123232~SHREYA,0~NSDL~IN300450~21234566~ADIT,0~CDSL~IN300484~31289453~NANDINI,'        
--SET @ClientFormerName ='SURAJ'        
--SET @ClientBusinessId =2        
--SET @ClientBusineesName='MANUFACTURING'        
--SET @ClientCountryId =1        
--SET @ClientCountryName ='INDIA'        
--SET @ClientMajorBCountryId ='2'        
--SET @ClientMajorBCountryName ='USA'        
--SET @DirectorDetail='0~KAMLA~PARTNER~1~1~CONSULTANCY,0~SAVITA~TRUST~2~3~SERVICE,'        
        
BEGIN TRAN T1           
IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLAFirmDetail WHERE IFirmSOSId=@FirmSOSId)        
BEGIN        
 INSERT INTO SOS_Stgtbl_PMLAFirmDetail(SFirmPartyCode,CFirmType,IFirmKRA,DFirmKRAdate,DFirmCreatedDate,BFirmIsActive,SFirmCreatedBy,SFirmUpdatedBy,DFirmUpdatedDate,IResidentialDetailId)        
 VALUES(@PartyCode,@Type,@KRA,@KRADate,GETDATE(),1,@UpdatedBY,@UpdatedBY,GETDATE(),@ResidentialId)        
 --SELECT * FROM SOS_Stgtbl_PMLAFirmDetail        
 SET @FirmSOSId=@@IDENTITY        
        
---------------------PEP DETAIL----------------------------------------------------------------------------------        
 IF(@PEPName <> '' AND @PEPName IS NOT NULL)        
  BEGIN        
   INSERT INTO SOS_Stgtbl_PMLAPEPDetail(IPEPFirmSOSId,SPEPPartyCode,CPEPType,SPEPName,IPEPRelationId,SPEPPANNumber,SPEPCreatedBy,DPEPCreatedDate,SPEPRelationName)        
   VALUES(@FirmSOSId,@PartyCode,@Type,@PEPName, @PEPRelationId,@PEPPANNo,@UpdatedBY,GETDATE(),@PEPRelationName)          
  END        
 --SELECT * FROM SOS_Stgtbl_PMLAPEPDetail        
         
--------------------------------------INDIVIDUAL DETAIL FOR NEW ENTRY-----------------------------------------------------        
         
 IF(@Type='I')        
 BEGIN        
         
--------------------------------------OCCUPATION DETAIL-----------------------------------------------------        
  IF (@OccEmployeName <> '' AND @OccEmployeName IS NOT NULL)        
   BEGIN        
    INSERT INTO SOS_Stgtbl_PMLAOccupationDetail(IOccIFirmSOSId,IOccPartyCode,SOccEmployerName,SOccAddress,SOccDesignation,SOccCreatedBy,DOccCreatedDate,IOccBussinessNatureId,SOccBusinessNature)        
    VALUES(@FirmSOSId,@PartyCode,@OccEmployeName,@OccAddress,@OccDesignation,@UpdatedBY,GETDATE(),@OccBussinesId,@OccBusinessNature)        
   END        
  --SELECT * FROM SOS_Stgtbl_PMLAOccupationDetail        
        
---------------------------------AFFILIATED CLIENT DETAIL-------------------------------------------------------------        
  IF(@AffRelationName <> '' AND @AffRelationName IS NOT NULL)        
   BEGIN        
    INSERT INTO SOS_Stgtbl_PMLAAffClientDetail(IAffFirmSOSId,IAffPartyCode,IAffRelationName,IAffRelationId,IAffBussinessNatureId,IAffBusinessNature,IAffEntityType,SAffCreatedBy,DAffCreatedDate,SAffRelRelationName)        
    VALUES(@FirmSOSId,@PartyCode,@AffRelationName,@AffRelationId, @BussinessId,@BusinessName,@EntityType,@UpdatedBY,GETDATE(),@AffRelRelationName)        
   END        
  --SELECT * FROM SOS_Stgtbl_PMLAAffClientDetail        
        
----------------------------------------------JOINT ACCOUNT DETAIL---------------------------------------------------------        
  IF(@JASecondHolder <> '' AND @JASecondHolder IS NOT NULL)        
   BEGIN        
    INSERT INTO SOS_Stgtbl_PMLAJointAccountDetail(IJointAccFirmSOSId,SJointAccPartyCode,SJointAccSecondHolderName,SJointAccThirdHolderName,SJointAccCreatedBy,DJointAccCreatedDate)        
    VALUES(@FirmSOSId,@PartyCode,@JASecondHolder,@JAThirdHolder,@UpdatedBY,GETDATE())         
    END        
  --SELECT * FROM SOS_Stgtbl_PMLAJointAccountDetail        
        
----------------------------------------------RELATION DETAIL------------------------------------------------------------------------        
  IF(@RelationDetail <> '' AND @RelationDetail IS NOT NULL)        
  BEGIN        
   DECLARE @IRelationId INT,@UCC varchar(50),@RelationId int,@SRelRelationName varchar(50)        
   CREATE TABLE #TempB(IRelationId int,SFirmSOSID INT, SPartycode VARCHAR(50),SRelUCC varchar(50),IRelRelationId int,SRelCreatedBY varchar(50),SRelUpdatedBY varchar(50),DRelCreatedDate datetime,DRelUpdateDate datetime,SRelRelationName varchar(50))        
 
   SELECT @IRelationId = charindex(',',@RelationDetail)         
                  
   while (charindex(',',@RelationDetail) > 0 )                 
    BEGIN                
    --PRINT CONVERT(varchar(10),substring(@Sno,1,charindex(',',@Sno)-1))         
     SET @IRelationId=CONVERT(INT,substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
     SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))                 
     SET @UCC=CONVERT(varchar(10),substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
     SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))          
     SET @SRelRelationName=CONVERT(varchar(10),substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
     SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))          
     SET @RelationId=CONVERT(int,substring(@RelationDetail,1,charindex(',',@RelationDetail)-1))           
     SET @RelationDetail = substring(@RelationDetail,charindex(',',@RelationDetail)+1,len(@RelationDetail))          
        
     INSERT INTO #TempB(IRelationId,SFirmSOSID,SPartycode,SRelUCC,IRelRelationId,SRelCreatedBY,SRelUpdatedBY,DRelCreatedDate,DRelUpdateDate,SRelRelationName)    
     VALUES (@IRelationId,@FirmSOSId,@PartyCode,@UCC,@RelationId,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE(),@SRelRelationName)                
    END            
   SELECT SFirmSOSID,SPartycode,SRELUCC,IRELRELATIONID FROM #TEMPB            
        
   INSERT INTO SOS_Stgtbl_PMLARelationDetail(IRelFirmSOSId,SRelPartyCode,SRelUCC,IRelRelationId,SRelCreatedBy,SRelUpdatedBy,DRelCreatedDate,DRelUpdatedDate,SRelRelationName)        
   SELECT SFirmSOSID,SPartycode,SRELUCC,IRELRELATIONID,SRelCreatedBY,SRelUpdatedBY,DRelCreatedDate,DRelUpdateDate,SRelRelationName FROM #TEMPB        
        
   --SELECT * FROM SOS_Stgtbl_PMLARelationDetail        
        
  END        
        
----------------------------------------DEPOSITORY DETAIL-------------------------------------------------------------        
  IF(@DPDetail <> '' AND @DPDetail IS NOT NULL)        
  BEGIN        
        
   DECLARE @IDPAccId INT,@SDADepository varchar(50),@SDADPId VARCHAR(50),@SDAClientId VARCHAR(50),@SDAHolderName VARCHAR(50)        
                 
   CREATE TABLE #TempC(IDPAccId INT,SFirmSOSID INT, SPartycode VARCHAR(50),SDADepository varchar(50),SDADPId varchar(50),SDAClientId varchar(50),SDAHolderName varchar(50),SDACreatedBY varchar(50),SDAUpdatedBY varchar(50),DDACreatedDate datetime,DDAUpdateDate datetime)              
        
   SELECT @IDPAccId = charindex(',',@DPDetail)         
                  
   WHILE (charindex(',',@DPDetail) > 0 )                 
    BEGIN                
     --PRINT CONVERT(varchar(10),substring(@Sno,1,charindex(',',@Sno)-1))             
     SET @IDPAccId=CONVERT(int,substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
     SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))             
     SET @SDADepository=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
     SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
     SET @SDADPId=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
     SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
     SET @SDAClientId=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
     SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
     SET @SDAHolderName=CONVERT(varchar(50),substring(@DPDetail,1,charindex(',',@DPDetail)-1))           
     SET @DPDetail = substring(@DPDetail,charindex(',',@DPDetail)+1,len(@DPDetail))          
        
     IF @SDADepository='CDSL'        
      BEGIN        
       SET @SDAClientId=@SDADPId+@SDAClientId        
      END        
        
     INSERT INTO #TempC(IDPAccId,SFirmSOSID, SPartycode,SDADepository ,SDADPId,SDAClientId,SDAHolderName,SDACreatedBY,SDAUpdatedBY,DDACreatedDate,DDAUpdateDate)              
      VALUES (@IDPAccId,@FirmSOSId,@PartyCode,@SDADepository,@SDADPId,@SDAClientId,@SDAHolderName,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE())                
    END            
   SELECT SFirmSOSID, SPartycode,SDADEPOSITORY,SDADPID,SDACLIENTID,SDAHOLDERNAME  FROM #TempC            
        
   INSERT INTO SOS_Stgtbl_PMLADepositoryAccountDetail(IDAFirmSOSId,IDAPartyCode,SDADepository,SDADPId,SDAClientId,SDAHolderName)        
   SELECT SFirmSOSID, SPartycode,SDADEPOSITORY,SDADPID,SDACLIENTID,SDAHOLDERNAME  FROM #TempC          
        
        
   --SELECT * FROM SOS_Stgtbl_PMLADepositoryAccountDetail        
  END        
        
 END        
---------------------------------------------NON-INDIVIDUAL FOR NEW ENTRY--------------------------------------------------------------------        
 ELSE        
 BEGIN        
--------------------------------------NON INDIVIDUAL CLIENT DETAIL-------------------------------------------------------        
  IF(@ClientFormerName <> '' AND @ClientFormerName IS NOT NULL)        
   BEGIN        
    INSERT INTO SOS_Stgtbl_PMLAClientDetail(ICFrmSOSId,SCPartyCode,SCFormerName,ICBusinessId,ICBusinessNature,ICCountryId,ICCountry,ICMajorCountryId,ICMajorCountry,SCCreatedBy,DCCreatedDate)        
    VALUES(@FirmSOSId,@PartyCode,@ClientFormerName,@ClientBusinessId, @ClientBusineesName,@ClientCountryId,@ClientCountryName,@ClientMajorBCountryId,@ClientMajorBCountryName,@UpdatedBY,GETDATE())      
   END        
   --SELECT * FROM SOS_Stgtbl_PMLAClientDetail        
  END        
----------------------------------------------DIRECTOR DETAIL------------------------------------------------------        
  IF(@DirectorDetail <> '' AND @DirectorDetail IS NOT NULL)        
  BEGIN        
   DECLARE @IDirectorId INT,@IDDirectorName varchar(50),@IDEntityName VARCHAR(50),@IDRelationID INT,@IDBusinessId INT,@IDBusinessNature VARCHAR(50),@SDRelationName varchar(50)        
   CREATE TABLE #TempA(IDirectorId INT,SFirmSOSID INT, SPartycode VARCHAR(50),IDDirectorName varchar(50),IDEntityName VARCHAR(50),IDRelationID INT,IDBusinessId INT,IDBusinessNature VARCHAR(50),SDCreatedBY varchar(50),SUpdatedBY varchar(50),DDCreatedDate datetime,DDUpdatedDate datetime,SDRelationName varchar(50))                 
   SELECT @IDirectorId = charindex(',',@DirectorDetail)         
                  
   WHILE (charindex(',',@DirectorDetail) > 0 )                 
    BEGIN                
     SET @IDirectorId=CONVERT(int,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))         
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))             
     SET @IDDirectorName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))         
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))          
     SET @IDEntityName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))          
     SET @IDRelationID=CONVERT(INT,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))  
     SET @SDRelationName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))              
     SET @IDBusinessId=CONVERT(INT,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))           
     SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))        
     SET @IDBusinessNature=CONVERT(VARCHAR(50),substring(@DirectorDetail,1,charindex(',',@DirectorDetail)-1))           
     SET @DirectorDetail = substring(@DirectorDetail,charindex(',',@DirectorDetail)+1,len(@DirectorDetail))          
            
     INSERT INTO #TempA(IDirectorId,SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SUpdatedBY,DDCreatedDate,DDUpdatedDate,SDRelationName)        
     VALUES(@IDirectorId,@FirmSOSId,@PartyCode,@IDDirectorName,@IDEntityName,@IDRelationID,@IDBusinessId,@IDBusinessNature,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE(),@SDRelationName)                
    END            
    --SELECT SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature FROM #TempA            
        
    INSERT INTO SOS_Stgtbl_PMLADirectorDetail(IDFirmSOSId,IDPartyCode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SDUpdatedBy,DDCreatedDate,DDUpdatedDate,SDRelationName)             
    SELECT SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SUpdatedBY,DDCreatedDate,DDUpdatedDate,SDRelationName FROM #TempA         
    --SELECT * FROM SOS_Stgtbl_PMLADirectorDetail        
  END        
 END        
------------------------------------------------------------UPDATE FOR EXISTING RECORD--------------------------------------------        
ELSE        
BEGIN         
  UPDATE SOS_Stgtbl_PMLAFirmDetail SET SFirmPartyCode=@PartyCode,        
  CFirmType=@Type,        
  IFirmKRA=@KRA,        
  DFirmKRAdate=@KRADate,        
  DFirmUpdatedDate=GETDATE(),    
  SFirmUpdatedBy=@UpdatedBY,        
  BFirmIsActive=1,
  IResidentialDetailId=@ResidentialId       
  WHERE IFirmSOSId=@FirmSOSId        
---------------------------------------------------PEP RECORD------------------------------------------------------------------        
  IF (@PEPName <> '' AND @PEPName IS NOT NULL)        
   BEGIN        
    IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLAPEPDetail WHERE IPEPFirmSOSId=@FirmSOSId)        
    BEGIN      
        INSERT INTO SOS_Stgtbl_PMLAPEPDetail(IPEPFirmSOSId,SPEPPartyCode,CPEPType,SPEPName,IPEPRelationId,SPEPPANNumber,SPEPCreatedBy,DPEPCreatedDate,SPEPRelationName)        
   VALUES(@FirmSOSId,@PartyCode,@Type,@PEPName, @PEPRelationId,@PEPPANNo,@UpdatedBY,GETDATE(),@PEPRelationName)      
    END      
  ELSE      
    BEGIN       
   UPDATE SOS_Stgtbl_PMLAPEPDetail SET SPEPPartyCode=@PartyCode,        
   CPEPType=@Type,SPEPName=@PEPName,IPEPRelationId=@PEPRelationId,        
   SPEPPANNumber=@PEPPANNo,        
   SPEPUpdatedBy=@UpdatedBY,    
   DPEPUpdatedDate= Getdate(),  
   SPEPRelationName=@PEPRelationName    
   WHERE IPEPFirmSOSId=@FirmSOSId        
     END        
 END      
  ELSE        
  DELETE FROM SOS_Stgtbl_PMLAPEPDetail WHERE IPEPFirmSOSId=@FirmSOSId        
---------------------------------------------------------------UPDATE INDIVIDUAL RECORD---------------------------        
  IF(@Type ='I')        
   BEGIN        
-----------------------------------------------------------OCCUPATION DETAIL-------------------------------------------        
  IF (@OccEmployeName <> '' AND @OccEmployeName IS NOT NULL)        
    BEGIN        
    IF NOT EXISTS(SELECT * FROM  SOS_Stgtbl_PMLAOccupationDetail WHERE IOccIFirmSOSId=@FirmSOSId )      
    BEGIN      
         INSERT INTO SOS_Stgtbl_PMLAOccupationDetail(IOccIFirmSOSId,IOccPartyCode,SOccEmployerName,SOccAddress,SOccDesignation,SOccCreatedBy,DOccCreatedDate,IOccBussinessNatureId,SOccBusinessNature)        
    VALUES(@FirmSOSId,@PartyCode,@OccEmployeName,@OccAddress,@OccDesignation,@UpdatedBY,GETDATE(),@OccBussinesId,@OccBusinessNature)        
    END      
  ELSE      
    BEGIN       
    UPDATE SOS_Stgtbl_PMLAOccupationDetail        
    SET IOccPartyCode=@PartyCode,        
    SOccEmployerName=@OccEmployeName,        
    SOccAddress=@OccAddress,        
    SOccDesignation=@OccDesignation ,    
    SOccUpdatedBy=@UpdatedBY,    
   DOccUpdatedDate= Getdate(),
   IOccBussinessNatureId=@OccBussinesId,
   SOccBusinessNature =@OccBusinessNature      
    WHERE IOccIFirmSOSId=@FirmSOSId        
     END        
 END      
  ELSE        
    DELETE FROM SOS_Stgtbl_PMLAOccupationDetail WHERE IOccIFirmSOSId=@FirmSOSId        
         
      
        
--------------------------------------------------------AFFILIATED CLIENT DETAIL---------------------------------------------        
    IF(@AffRelationName <> '' AND @AffRelationName IS NOT NULL)        
      BEGIN       
       IF NOT EXISTS(SELECT * FROM  SOS_Stgtbl_PMLAAffClientDetail WHERE IAffFirmSOSId=@FirmSOSId  )      
    BEGIN      
    INSERT INTO SOS_Stgtbl_PMLAAffClientDetail(IAffFirmSOSId,IAffPartyCode,IAffRelationName,IAffRelationId,IAffBussinessNatureId,IAffBusinessNature,IAffEntityType,SAffCreatedBy,DAffCreatedDate,SAffRelRelationName)        
    VALUES(@FirmSOSId,@PartyCode,@AffRelationName,@AffRelationId, @BussinessId,@BusinessName,@EntityType,@UpdatedBY,GETDATE(),@AffRelRelationName)        
   END      
  ELSE      
  BEGIN      
     UPDATE SOS_Stgtbl_PMLAAffClientDetail        
     SET IAffPartyCode=@PartyCode,        
     IAffRelationName=@AffRelationName,        
     IAffRelationId=@AffRelationId,        
     IAffBussinessNatureId=@BussinessId,        
     IAffBusinessNature=@BusinessName,        
     IAffEntityType=@EntityType,    
     SAffUpdatedBy=@UpdatedBY,    
     DAffUpdatedDate= Getdate(),  
     SAffRelRelationName=@AffRelRelationName           
     WHERE IAffFirmSOSId=@FirmSOSId        
  END       
 END       
    ELSE        
      DELETE FROM SOS_Stgtbl_PMLAAffClientDetail WHERE IAffFirmSOSId=@FirmSOSId        
        
-------------------------------JOINT ACCOUNT DETAIL--------------------------------------------------------------        
  IF(@JASecondHolder <> '' AND @JASecondHolder IS NOT NULL)         
    BEGIN       
       IF NOT EXISTS(SELECT * FROM  SOS_Stgtbl_PMLAJointAccountDetail WHERE IJointAccFirmSOSId=@FirmSOSId  )      
    BEGIN      
     INSERT INTO SOS_Stgtbl_PMLAJointAccountDetail(IJointAccFirmSOSId,SJointAccPartyCode,SJointAccSecondHolderName,SJointAccThirdHolderName,SJointAccCreatedBy,DJointAccCreatedDate)        
    VALUES(@FirmSOSId,@PartyCode,@JASecondHolder,@JAThirdHolder,@UpdatedBY,GETDATE())      
    END      
  ELSE      
  BEGIN      
    UPDATE SOS_Stgtbl_PMLAJointAccountDetail        
    SET SJointAccPartyCode=@PartyCode,        
    SJointAccSecondHolderName=@JASecondHolder,SJointAccThirdHolderName=@JAThirdHolder,    
     SJointAccUpdatedBy=@UpdatedBY,    
     DJointAccUpdatedDate= Getdate()           
    WHERE IJointAccFirmSOSId=@FirmSOSId         
  END       
 END       
    ELSE        
        DELETE FROM SOS_Stgtbl_PMLAJointAccountDetail WHERE IJointAccFirmSOSId=@FirmSOSId        
     --SELECT * FROM SOS_Stgtbl_PMLAJointAccountDetail        
             
----------------------------------------------------RELATION DETAIL-----------------------------------------------------------        
    IF(@RelationDetail <> '' AND @RelationDetail IS NOT NULL)        
     BEGIN        
      CREATE TABLE #TempD(IRelationId int,SFirmSOSID INT, SPartycode VARCHAR(50),SRelUCC varchar(50),IRelRelationId int,SRelCreatedBY varchar(50),SRelUpdatedBY varchar(50),DRelCreatedDate datetime,DRelUpdateDate datetime,SRelRelationName varchar(50))     
       
      SELECT @IRelationId = charindex(',',@RelationDetail)         
      WHILE (charindex(',',@RelationDetail) > 0 )                 
       BEGIN                
       --PRINT CONVERT(varchar(10),substring(@Sno,1,charindex(',',@Sno)-1))         
        SET @IRelationId=CONVERT(INT,substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
        SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))                 
        SET @UCC=CONVERT(varchar(10),substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
        SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))          
        SET @SRelRelationName=CONVERT(varchar(10),substring(@RelationDetail,1,charindex('~',@RelationDetail)-1))            
        SET @RelationDetail = substring(@RelationDetail,charindex('~',@RelationDetail)+1,len(@RelationDetail))          
        SET @RelationId=CONVERT(int,substring(@RelationDetail,1,charindex(',',@RelationDetail)-1))         
        SET @RelationDetail = substring(@RelationDetail,charindex(',',@RelationDetail)+1,len(@RelationDetail))          
        
        DELETE FROM SOS_Stgtbl_PMLARelationDetail WHERE IRelFirmSOSId=@FirmSOSId        
        
         INSERT INTO #TempD(IRelationId,SFirmSOSID,SPartycode,SRelUCC,IRelRelationId,SRelCreatedBY,SRelUpdatedBY,DRelCreatedDate,DRelUpdateDate,SRelRelationName) VALUES (@IRelationId,@FirmSOSId,@PartyCode,@UCC,@RelationId,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE(),@SRelRelationName)         
        --IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLARelationDetail WHERE IRelationId=@IRelationId)        
        -- BEGIN        
          --INSERT INTO SOS_Stgtbl_PMLARelationDetail(IRelFirmSOSId,SRelPartyCode,SRelUCC,IRelRelationId)        
          -- VALUES (@FirmSOSId,@PartyCode,@UCC,@RelationId)                
        -- END        
        --ELSE        
        -- BEGIN        
        --  UPDATE SOS_Stgtbl_PMLARelationDetail        
        --  SET SRelPartyCode=@PartyCode,        
        --  SRelUCC=@UCC,        
        --  IRelRelationId=@RelationId        
        --  WHERE IRelRelationId=@IRelationId        
        -- END          
       END          
       --SELECT SFirmSOSID,SPartycode,SRELUCC,IRELRELATIONID FROM #TempD            
        
       INSERT INTO SOS_Stgtbl_PMLARelationDetail(IRelFirmSOSId,SRelPartyCode,SRelUCC,IRelRelationId,SRelCreatedBy,SRelUpdatedBy,DRelCreatedDate,DRelUpdatedDate,SRelRelationName)        
       SELECT SFirmSOSID,SPartycode,SRELUCC,IRELRELATIONID,SRelCreatedBy,SRelUpdatedBy,DRelCreatedDate,DRelUpdateDate,SRelRelationName FROM #TempD        
        
       --SELECT * FROM SOS_Stgtbl_PMLARelationDetail        
     END        
     ELSE        
      DELETE FROM SOS_Stgtbl_PMLARelationDetail WHERE IRelFirmSOSId=@FirmSOSId        
        
--------------------------------------------------------DEPOSITORY DETAIL--------------------------------------------------------        
    IF(@DPDetail <> '' AND @DPDetail IS NOT NULL)        
     BEGIN        
     CREATE TABLE #TempE(IDPAccId INT,SFirmSOSID INT, SPartycode VARCHAR(50),SDADepository varchar(50),SDADPId varchar(50),SDAClientId varchar(50),SDAHolderName varchar(50),SDACreatedBY varchar(50),SDAUpdatedBY varchar(50),DDACreatedDate datetime,DDAUpdateDate datetime)                  
      SELECT @IDPAccId = charindex(',',@DPDetail)         
       WHILE (charindex(',',@DPDetail) > 0 )                 
        BEGIN                
         --PRINT CONVERT(varchar(10),substring(@Sno,1,charindex(',',@Sno)-1))             
         SET @IDPAccId=CONVERT(int,substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
         SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))             
         SET @SDADepository=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
         SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
         SET @SDADPId=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
         SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
         SET @SDAClientId=CONVERT(varchar(50),substring(@DPDetail,1,charindex('~',@DPDetail)-1))            
         SET @DPDetail = substring(@DPDetail,charindex('~',@DPDetail)+1,len(@DPDetail))          
         SET @SDAHolderName=CONVERT(varchar(50),substring(@DPDetail,1,charindex(',',@DPDetail)-1))           
         SET @DPDetail = substring(@DPDetail,charindex(',',@DPDetail)+1,len(@DPDetail))          
                 
         DELETE FROM SOS_Stgtbl_PMLADepositoryAccountDetail WHERE IDAFirmSOSId=@FirmSOSId        
          IF @SDADepository='CDSL'        
           SET @SDAClientId=@SDADPId+@SDAClientId        
                  
          --IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLADepositoryAccountDetail WHERE IDPAccId=@IDPAccId)        
          -- BEGIN        
          --  INSERT INTO SOS_Stgtbl_PMLADepositoryAccountDetail(IDAFirmSOSId,IDAPartyCode,SDADepository ,SDADPId,SDAClientId,SDAHolderName)         
          --  VALUES (@FirmSOSId,@PartyCode,@SDADepository,@SDADPId,@SDAClientId,@SDAHolderName)            
          -- END        
          --ELSE        
          -- BEGIN        
          --  UPDATE SOS_Stgtbl_PMLADepositoryAccountDetail        
          --  SET IDAPartyCode=@PartyCode,        
          --  SDADepository=@SDADepository,        
          --  SDADPId=@SDADPId,        
          --  SDAClientId=@SDAClientId,        
          --  SDAHolderName=@SDAHolderName        
          --  WHERE IDPAccId=@IDPAccId        
          -- END          
          INSERT INTO #TempE(IDPAccId,SFirmSOSID, SPartycode,SDADepository ,SDADPId,SDAClientId,SDAHolderName,SDACreatedBY,SDAUpdatedBY,DDACreatedDate,DDAUpdateDate)  VALUES         
          (@IDPAccId,@FirmSOSId,@PartyCode,@SDADepository,@SDADPId,@SDAClientId,@SDAHolderName,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE())                
         END            
          --SELECT SFirmSOSID, SPartycode,SDADEPOSITORY,SDADPID,SDACLIENTID,SDAHOLDERNAME  FROM #TempE            
        
          INSERT INTO SOS_Stgtbl_PMLADepositoryAccountDetail(IDAFirmSOSId,IDAPartyCode,SDADepository,SDADPId,SDAClientId,SDAHolderName,SDACreatedBY,SDAUpdatedBY,DDACreatedDate,DDAUpdatedDate)        
          SELECT SFirmSOSID, SPartycode,SDADEPOSITORY,SDADPID,SDACLIENTID,SDAHOLDERNAME,SDACreatedBY,SDAUpdatedBY,DDACreatedDate,DDAUpdateDate  FROM #TempE          
             --SELECT * FROM SOS_Stgtbl_PMLADepositoryAccountDetail        
        END        
      ELSE        
      DELETE FROM SOS_Stgtbl_PMLADepositoryAccountDetail WHERE IDAFirmSOSId=@FirmSOSId        
        
    END        
---------------------------------------------------------NON INDIVIDUAL-----------------------------------------------------        
 ELSE        
  BEGIN        
 -------------------------------------NON INDIVIDUAL CLIENT DETAIL------------------------------------------------------        
    IF(@ClientFormerName <> '' AND @ClientFormerName IS NOT NULL)       
    BEGIN       
       IF NOT EXISTS(SELECT * FROM  SOS_Stgtbl_PMLAClientDetail WHERE ICFrmSOSId=@FirmSOSId)      
    BEGIN      
    INSERT INTO SOS_Stgtbl_PMLAClientDetail(ICFrmSOSId,SCPartyCode,SCFormerName,ICBusinessId,ICBusinessNature,ICCountryId,ICCountry,ICMajorCountryId,ICMajorCountry,SCCreatedBy,DCCreatedDate)        
    VALUES(@FirmSOSId,@PartyCode,@ClientFormerName,@ClientBusinessId, @ClientBusineesName,@ClientCountryId,@ClientCountryName,@ClientMajorBCountryId,@ClientMajorBCountryName,@UpdatedBY,GETDATE())        
    END      
  ELSE      
  BEGIN      
   UPDATE SOS_Stgtbl_PMLAClientDetail        
    SET SCPartyCode=@PartyCode,        
    SCFormerName=@ClientFormerName,        
    ICBusinessId=@ClientBusinessId,        
    ICBusinessNature=@ClientBusineesName,        
    ICCountryId=@ClientCountryId,        
    ICCountry=@ClientCountryName,        
    ICMajorCountryId=@ClientMajorBCountryId,        
    ICMajorCountry=@ClientMajorBCountryName,    
    SCUpdatedBy=@UpdatedBY,    
    DCUpdatedDate=GETDATE()       
     WHERE ICFrmSOSId=@FirmSOSId        
  END       
 END       
    ELSE        
       DELETE FROM SOS_Stgtbl_PMLAClientDetail WHERE ICFrmSOSId=@FirmSOSId        
       
      
        
 --------------------------------------------------------DIRECTOR DETAIL-----------------------------------------------------        
   IF(@DirectorDetail <> '' AND @DirectorDetail IS NOT NULL)        
    BEGIN        
     CREATE TABLE #TempF(IDirectorId INT,SFirmSOSID INT, SPartycode VARCHAR(50),IDDirectorName varchar(50),IDEntityName VARCHAR(50),IDRelationID INT,IDBusinessId INT,IDBusinessNature VARCHAR(50),SDCreatedBY varchar(50),SUpdatedBY varchar(50),DDCreatedDate
 datetime,DDUpdatedDate datetime,SDRelationName varchar(50))                 
     SELECT @IDirectorId = charindex(',',@DirectorDetail)         
     WHILE (charindex(',',@DirectorDetail) > 0 )                 
      BEGIN                
       SET @IDirectorId=CONVERT(int,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))         
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))             
       SET @IDDirectorName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))        
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))          
       SET @IDEntityName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))          
       SET @IDRelationID=CONVERT(INT,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))         
       SET @SDRelationName=CONVERT(varchar(50),substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))          
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))         
       SET @IDBusinessId=CONVERT(INT,substring(@DirectorDetail,1,charindex('~',@DirectorDetail)-1))           
       SET @DirectorDetail = substring(@DirectorDetail,charindex('~',@DirectorDetail)+1,len(@DirectorDetail))        
       SET @IDBusinessNature=CONVERT(VARCHAR(50),substring(@DirectorDetail,1,charindex(',',@DirectorDetail)-1))           
       SET @DirectorDetail = substring(@DirectorDetail,charindex(',',@DirectorDetail)+1,len(@DirectorDetail))          
               
       DELETE FROM SOS_Stgtbl_PMLADirectorDetail WHERE IDFirmSOSId=@FirmSOSId        
        --IF NOT EXISTS(SELECT * FROM SOS_Stgtbl_PMLADirectorDetail WHERE IDirectorId=@IDirectorId)        
        -- BEGIN        
        --  INSERT INTO SOS_Stgtbl_PMLADirectorDetail(IDFirmSOSId,IDPartyCode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature)        
        --   VALUES(@FirmSOSId,@PartyCode,@IDDirectorName,@IDEntityName,@IDRelationID,@IDBusinessId,@IDBusinessNature)              
        -- END        
        --ELSE        
        -- BEGIN        
        --  UPDATE SOS_Stgtbl_PMLADirectorDetail        
        --  SET IDPartyCode=@PartyCode,        
        --  IDDirectorName=@IDDirectorName,        
        --  IDEntityName=@IDEntityName,        
        --  IDRelationID=@IDRelationID,        
        --  IDBusinessId=@IDBusinessId,        
        --  IDBusinessNature=@IDBusinessNature        
        --  WHERE IDirectorId=@IDirectorId        
        -- END        
        INSERT INTO #TempF(IDirectorId,SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SUpdatedBY,DDCreatedDate,DDUpdatedDate,SDRelationName)        
       VALUES (@IDirectorId,@FirmSOSId,@PartyCode,@IDDirectorName,@IDEntityName,@IDRelationID,@IDBusinessId,@IDBusinessNature,@UpdatedBY,@UpdatedBY,GETDATE(),GETDATE(),@SDRelationName)                
      END            
      --SELECT SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature FROM #TempF            
      INSERT INTO SOS_Stgtbl_PMLADirectorDetail(IDFirmSOSId,IDPartyCode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SDUpdatedBy,DDCreatedDate,DDUpdatedDate,SDRelationName)            
      SELECT SFirmSOSID, SPartycode,IDDirectorName,IDEntityName,IDRelationID,IDBusinessId,IDBusinessNature,SDCreatedBY,SUpdatedBY,DDCreatedDate,DDUpdatedDate,SDRelationName FROM #TempF         
      --SELECT * FROM SOS_Stgtbl_PMLADirectorDetail        
    END        
   ELSE        
    DELETE FROM SOS_Stgtbl_PMLADirectorDetail WHERE IDFirmSOSId=@FirmSOSId        
  END        
        
END        
--DROP TABLE #TEMPA        
--DROP TABLE #TempB        
--DROP TABLE #TempC        
--DROP TABLE #TempD        
--DROP TABLE #TempE        
--DROP TABLE #TempF        
        
IF @@ERROR <> 0        
BEGIN        
SET @returnVal=-1        
PRINT'ERROR'        
ROLLBACK TRAN T1        
        
END        
ELSE        
BEGIN        
SET @returnVal=@FirmSOSId        
PRINT 'SUCESS'        
COMMIT TRAN T1        
END        
        
        
--dbo.SOS_Stgtbl_PMLAFirmDetail        
--dbo.SOS_Stgtbl_PMLAOccupationDetail        
--dbo.SOS_Stgtbl_PMLAAffClientDetail        
--dbo.SOS_Stgtbl_PMLAPEPDetail        
--dbo.SOS_Stgtbl_PMLAJointAccountDetail        
--dbo.SOS_Stgtbl_PMLARelationDetail        
--dbo.SOS_Stgtbl_PMLADepositoryAccountDetail        
--dbo.SOS_Stgtbl_PMLAClientDetail        
--dbo.SOS_Stgtbl_PMLADirectorDetail

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_SOS_Stgtbl_ClientGroupMapping
-- --------------------------------------------------


CREATE PROC [dbo].[SPX_SOS_Stgtbl_ClientGroupMapping]
AS


SELECT FAMILY INTO #FAMILY
 FROM   
ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK) 
GROUP BY FAMILY
HAVING COUNT(FAMILY)>1

CREATE NONCLUSTERED INDEX IDX_FAMILY ON #FAMILY(FAMILY) 


SELECT DISTINCT CL_CODE AS FAMILY INTO #FAMILYNEW FROM
(
SELECT CL_CODE
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS A with(nolock)
INNER JOIN #FAMILY B  WITH(NOLOCK) ON A.CL_CODE=B.FAMILY
--WHERE INACTIVE_FROM>GETDATE()
) F

SELECT CL_CODE,PAN_GIR_NO,LONG_NAME,C.FAMILY INTO #CLIENTDETAILS
FROM  ANAND1.MSAJAG.DBO.CLIENT_DETAILS C WITH(NOLOCK) 

CREATE NONCLUSTERED INDEX IDX_CLIENTDETAILS ON #CLIENTDETAILS(CL_CODE) 
CREATE NONCLUSTERED INDEX IDX_FAMILYNEW ON #FAMILYNEW(FAMILY) 


SELECT CL_CODE AS ClientCode,LONG_NAME AS ClientName,PAN_GIR_NO AS ClientPAN
,C.FAMILY,'N' AS REGULATORY,'Class Family mapping' AS Reason,
GetDate() AS RECORDDATE
INTO #CLIENTFAMILYDETAILS
FROM  #FAMILYNEW F WITH(NOLOCK)
INNER JOIN #CLIENTDETAILS C WITH(NOLOCK) 
 ON C.FAMILY=F.FAMILY
 WHERE C.CL_CODE=C.CL_CODE AND F.FAMILY=F.FAMILY

CREATE NONCLUSTERED INDEX IDX_CLIENTFAMILYDETAILS ON #CLIENTFAMILYDETAILS(ClientCode) 

UPDATE #CLIENTFAMILYDETAILS SET ClientCode=LEFT(LTRIM(RTRIM(ClientCode)),20) WHERE ClientCode=ClientCode AND  LEN(LTRIM(RTRIM(ClientCode)))>20
UPDATE #CLIENTFAMILYDETAILS SET ClientName=LEFT(LTRIM(RTRIM(ClientName)),100) WHERE ClientCode=ClientCode AND LEN(LTRIM(RTRIM(ClientName)))>100
UPDATE #CLIENTFAMILYDETAILS SET ClientPAN=LEFT(LTRIM(RTRIM(ClientPAN)),10) WHERE ClientCode=ClientCode AND LEN(LTRIM(RTRIM(ClientPAN)))>10
UPDATE #CLIENTFAMILYDETAILS SET FAMILY=LEFT(LTRIM(RTRIM(FAMILY)),50) WHERE ClientCode=ClientCode AND LEN(LTRIM(RTRIM(FAMILY)))>50


TRUNCATE TABLE Stgtbl_ClientGroupMapping
INSERT INTO Stgtbl_ClientGroupMapping
(
ClientCode,
ClientName,
ClientPAN,
GroupName,
GroupShortName,
Regulator,
Reason,
RecordDt
)
SELECT DISTINCT ClientCode,ClientName,ClientPAN,FAMILY,FAMILY AS GROUPSHORTNAME,REGULATORY,Reason,
RECORDDATE FROM #CLIENTFAMILYDETAILS WHERE ClientCode=ClientCode  ORDER BY FAMILY
 
drop table #CLIENTDETAILS
drop table #CLIENTFAMILYDETAILS
drop table #FAMILY
drop table #FAMILYNEW




/* -----------Code for mail alert-------------*/

DECLARE @COUNT INT
DECLARE @COUNT1  varchar(10) 

DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                  
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)   

SELECT @COUNT = COUNT(ClientCode) FROM Stgtbl_ClientGroupMapping with(nolock)

--SELECT @COUNT AS CLIENTCODE
SET @COUNT1 = @COUNT

DECLARE @DATE VARCHAR(12)
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))

              

SET @S1 = 'SOS Alert For process SPX_SOS_Stgtbl_ClientGroupMapping on date '+@DATE+''

set @mess='Dear ALL<br><br>                                    
                                    
 The process SPX_SOS_Stgtbl_ClientGroupMapping has been updated '+@COUNT1+' record into Stgtbl_ClientGroupMapping for date '+@DATE+'                                      
                  
<br> <br>                                
by SOS process.'                                                       
 set @email='manish.shukla@angelbroking.com'                   
 --set @email='amit.s@angelbroking.com'                                                                                                         
exec msdb.dbo.sp_send_dbmail                                                                                                                         
@recipients  = @email,                                                                                                             
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                              
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                             
@profile_name = 'KYC',                                                                                                                                
@body_format ='html',                                                            
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                    
--@file_attachments =@attach,                                                                                                                                                             
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_SOS_stgtbl_ClientIntermediaryMaster
-- --------------------------------------------------
  
CREATE PROC [dbo].[SPX_SOS_stgtbl_ClientIntermediaryMaster]  
AS  
  
CREATE TABLE #CLIENTINTERMEDIATE  
(  
 INTERMEDTYPE VARCHAR(20) NULL,  
 INTERMEDCODE VARCHAR(50) NULL,  
 NAME VARCHAR(500) NULL,  
 PARENTCODE VARCHAR(500) NULL,  
 PAN VARCHAR(100) NULL,  
 ADD1 VARCHAR(500) NULL,  
 ADD2 VARCHAR(500) NULL,  
 ADD3 VARCHAR(500) NULL,  
 CITY VARCHAR(150) NULL,  
 STATE VARCHAR(150) NULL,  
 COUNTRY VARCHAR(50) NULL,  
 PIN VARCHAR(50) NULL,  
 PHONE1 VARCHAR(100 ) NULL,  
 PHONE2 VARCHAR(100) NULL,  
 MOBILE VARCHAR(100) NULL,  
 FAX VARCHAR(100) NULL,  
 EMAIL VARCHAR(500) NULL  
)   
  
  
select distinct *  into #DealerAndRm from  
(  
select  Dealer,Rm,SubBroker from [196.1.115.207].inhouse.[dbo].[V_EquityClients_ForPML] with(Nolock)   
union select  Dealer,Rm,SubBroker from [196.1.115.207].inhouse.[dbo].[V_CommodityClients_ForPML] with(Nolock)  
union select  Dealer,Rm,SubBroker from [196.1.115.207].inhouse.[dbo].[V_CurrencyClients_ForPML] with(Nolock)  
) f  
  
  
  
select Dealer into #Dealer from #DealerAndRm where Dealer<>'Undefined'  
  
SELECT distinct REGIONCODE,DESCRIPTION,BRANCH_CODE INTO #REGIONFROMBO FROM ANAND1.MSAJAG.DBO.REGION WITH(NOLOCK)  

SELECT * INTO #BRANCHFROMBO FROM ANAND1.MSAJAG.DBO.BRANCH WITH(NOLOCK) 

select sub_broker,branch_code into #sb from ANAND1.MSAJAG.DBO.SUBBROKERS with(Nolock)
 
 delete from #BRANCHFROMBO where LTRIM(RTRIM(branch_code)) not in (select LTRIM(RTRIM(BRANCH_CODE)) from #REGIONFROMBO)
--DROP TABLE #RM  
select REG_CODE,RmEmpNo AS RM,EMAIL,BRANCH_CODE into #RM from tbl_SOSRmDetails A INNER JOIN #REGIONFROMBO B   
ON LTRIM(RTRIM(A.REG_CODE))=LTRIM(RTRIM(B.REGIONCODE))  
  
--SELECT * INTO #AREA FROM ANAND1.MSAJAG.DBO.AREA WITH(NOLOCK)  
  
--select * from #SBFromClient  
  
SELECT distinct Sub_Broker,SPACE(50) as Branch_Cd  INTO #SBFromClient FROM ANAND1.MSAJAG.DBO.Client_Details WITH(NOLOCK) 
 
 Update #SBFromClient set Branch_Cd=branch_code from #sb a
 where a.Sub_Broker=#SBFromClient.Sub_Broker
  
select * Into #SbModule from sb_comp.dbo.VW_PR_TAG_DETAILS with(Nolock)  
  
select distinct a.Sub_Broker,a.Branch_Cd,b.* into #SBFinalData from #SBFromClient a  
left outer join #SbModule b on a.Sub_broker=b.SbTag  
  
  
  
SELECT * INTO #HARMONY FROM [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL WITH(NOLOCK)  
  
  Update #HARMONY set COSTCODEDEFINITION='HO' where ltrim(rtrim(isnull(COSTCODEDEFINITION,''))) not in (select ltrim(rtrim(isnull(Branch_code,'')))  from #BRANCHFROMBO)
  
--INTERMEDCODE FOR HO UPDATION  
  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
SELECT   
'Head Office' AS INTERMEDTYPE,  
'HO' AS INTERMEDCODE,  
'ANGEL BROKING LIMITED' AS NAME,  
'0' AS PARENTCODE,  
NULL AS PAN,  
'G-1, AKRUTI TRADE CENTRE' AS ADD1,  
'ROAD NO.-7, MIDC,' AS ADD2,  
'ANDHERI(E)' ADD3,  
'MUMBAI' AS CITY,  
'MAHARASHTRA' AS STATE,  
'INDIA' AS COUNTRY,  
'400093' AS PIN,  
'30837700' AS PHONE1,  
NULL AS PHONE2,  
NULL AS MOBILE,  
'283508811' AS FAX,  
NULL AS EMAIL  
  
  
----INTERMEDCODE FOR ZONE UPDATION  
--INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
--SELECT DISTINCT   
--'ZONE' AS INTERMEDTYPE,  
-- ZONEID AS INTERMEDCODE,  
--ZONEDESC AS NAME,  
--'ZONE' AS PARENTCODE,  
--NULL AS PAN,  
--NULL AS ADD1,  
--NULL AS ADD2,  
--NULL AS  ADD3,  
--NULL AS CITY,  
--NULL AS STATE,  
--NULL AS COUNTRY,  
--NULL AS PIN,  
--NULL AS PHONE1,  
--NULL AS PHONE2,  
--NULL AS MOBILE,  
--NULL AS FAX,  
--NULL AS EMAIL  
-- FROM [196.1.115.237].ANGELBROKING.DBO.RECR_ZONEMASTER  
--WHERE ISNULL(FLGRECRZONEDEL,'0')<>'1'  
  
--INTERMEDCODE FOR REGION UPDATION  
  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
SELECT   
distinct   
'REGION' AS INTERMEDTYPE,  
REGIONCODE AS INTERMEDCODE,  
DESCRIPTION AS NAME,  
'HO' AS PARENTCODE,  
NULL AS PAN,  
NULL AS ADD1,  
NULL AS ADD2,  
NULL AS  ADD3,  
NULL AS CITY,  
NULL AS STATE,  
NULL AS COUNTRY,  
NULL AS PIN,  
NULL AS PHONE1,  
NULL AS PHONE2,  
NULL AS MOBILE,  
NULL AS FAX,  
NULL AS EMAIL  
 FROM #REGIONFROMBO  
  
--INTERMEDCODE FOR BRANCH UPDATION  
  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
SELECT distinct     
'BRANCH' AS INTERMEDTYPE,  
B.BRANCH_CODE AS INTERMEDCODE,  
B.BRANCH AS NAME,  
R.REGIONCODE AS PARENTCODE,  
NULL AS PAN,  
B.ADDRESS1 AS ADD1,  
B.ADDRESS2 AS ADD2,  
NULL AS  ADD3,  
B.CITY AS CITY,  
B.STATE AS STATE,  
B.NATION AS COUNTRY,  
B.ZIP AS PIN,  
B.PHONE1 AS PHONE1,  
B.PHONE2 AS PHONE2,  
NULL AS MOBILE,  
B.FAX AS FAX,  
B.EMAIL AS EMAIL  
 FROM #REGIONFROMBO R WITH(NOLOCK)  
 INNER JOIN #BRANCHFROMBO B WITH(NOLOCK)  
 ON R.BRANCH_CODE=B.BRANCH_CODE  
   
 --INTERMEDCODE FOR AREA UPDATION  
   
  
--INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
  
--SELECT    
--'AREA' AS INTERMEDTYPE,  
--AREACODE AS INTERMEDCODE,  
--DESCRIPTION AS NAME,  
--BRANCH_CODE AS PARENTCODE,  
--NULL AS PAN,  
--NULL AS ADD1,  
--NULL AS ADD2,  
--NULL AS  ADD3,  
--NULL AS CITY,  
--NULL AS STATE,  
--NULL AS COUNTRY,  
--NULL AS PIN,  
--NULL AS PHONE1,  
--NULL AS PHONE2,  
--NULL AS MOBILE,  
--NULL AS FAX,  
--NULL AS EMAIL  
--FROM #AREA R WITH(NOLOCK)  
  
  
--INTERMEDCODE FOR INTRODUCER  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
  
SELECT  distinct   
'INTRODUCER' AS INTERMEDTYPE,  
EMP_NO AS INTERMEDCODE,  
LTRIM(RTRIM(EMP_NAME)) AS NAME,  
COSTCODEDEFINITION AS PARENTCODE,  
PANNO AS PAN,  
LTRIM(RTRIM(ADDRESS1)) AS ADD1,  
LTRIM(RTRIM(ADDRESS2)) AS ADD2,  
NULL AS  ADD3,  
LTRIM(RTRIM(CITY)) AS CITY,  
STATE AS STATE,  
COUNTRY AS COUNTRY,  
LTRIM(RTRIM(PINCODE)) AS PIN,  
NULL AS PHONE1,  
NULL AS PHONE2,  
LTRIM(RTRIM(PHONE)) AS MOBILE,  
LTRIM(RTRIM(FAX)) AS FAX,  
LTRIM(RTRIM(EMAILADD)) AS EMAIL  
FROM #HARMONY R WITH(NOLOCK)  
  
-- Code For Sb Updation  
  
update #SBFinalData set SbName='SB Name'+SPACE(1)+Sub_broker where ISNULL(SbName,'')=''  
  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
SELECT distinct  
'Sub Broker' AS INTERMEDTYPE,  
Sub_broker AS INTERMEDCODE,  
SbName AS NAME,  
Branch_Cd AS PARENTCODE,  
PanNo AS PAN,  
RegOffAdd1 AS ADD1,  
RegOffAdd2 AS ADD2,  
RegOffAdd3 ADD3,  
City AS CITY,  
State AS STATE,  
COUNTRY AS COUNTRY,  
RegOffPin AS PIN,  
RegOffPhone AS PHONE1,  
RegresPhone AS PHONE2,  
MobileNo AS MOBILE,  
AlterNateMobile AS FAX,  
Email AS EMAIL from #SBFinalData  
  
-- Code for Dealer Updation  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
  
SELECT  distinct   
'Dealer' AS INTERMEDTYPE,  
EMP_NO AS INTERMEDCODE,  
LTRIM(RTRIM(EMP_NAME)) AS NAME,  
COSTCODEDEFINITION AS PARENTCODE,  
PANNO AS PAN,  
LTRIM(RTRIM(ADDRESS1)) AS ADD1,  
LTRIM(RTRIM(ADDRESS2)) AS ADD2,  
NULL AS  ADD3,  
LTRIM(RTRIM(CITY)) AS CITY,  
STATE AS STATE,  
COUNTRY AS COUNTRY,  
LTRIM(RTRIM(PINCODE)) AS PIN,  
NULL AS PHONE1,  
NULL AS PHONE2,  
LTRIM(RTRIM(PHONE)) AS MOBILE,  
LTRIM(RTRIM(FAX)) AS FAX,  
LTRIM(RTRIM(EMAILADD)) AS EMAIL  
FROM #HARMONY R WITH(NOLOCK)  
INNER JOIN #Dealer D WITH(NOLOCK)  
ON R.EMP_NO=D.DEALER  
  
-- Code for RM Updation  
INSERT INTO #CLIENTINTERMEDIATE(INTERMEDTYPE,INTERMEDCODE,NAME,PARENTCODE,PAN,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL)  
  
SELECT  distinct   
'RM' AS INTERMEDTYPE,  
EMP_NO AS INTERMEDCODE,  
LTRIM(RTRIM(EMP_NAME)) AS NAME,  
COSTCODEDEFINITION AS PARENTCODE,  
PANNO AS PAN,  
LTRIM(RTRIM(ADDRESS1)) AS ADD1,  
LTRIM(RTRIM(ADDRESS2)) AS ADD2,  
NULL AS  ADD3,  
LTRIM(RTRIM(CITY)) AS CITY,  
STATE AS STATE,  
COUNTRY AS COUNTRY,  
LTRIM(RTRIM(PINCODE)) AS PIN,  
NULL AS PHONE1,  
NULL AS PHONE2,  
LTRIM(RTRIM(PHONE)) AS MOBILE,  
LTRIM(RTRIM(FAX)) AS FAX,  
LTRIM(RTRIM(D.EMAIL)) AS EMAIL  
FROM #HARMONY R WITH(NOLOCK)  
INNER JOIN #RM D WITH(NOLOCK)  
ON LTRIM(RTRIM(R.EMP_NO))=LTRIM(RTRIM(D.RM))  
  
   
UPDATE #CLIENTINTERMEDIATE SET INTERMEDCODE=LEFT(LTRIM(RTRIM(INTERMEDCODE)),15) WHERE LEN(LTRIM(RTRIM(INTERMEDCODE)))>15  
UPDATE #CLIENTINTERMEDIATE SET NAME=LEFT(LTRIM(RTRIM(NAME)),100) WHERE LEN(LTRIM(RTRIM(NAME)))>100  
UPDATE #CLIENTINTERMEDIATE SET PAN=LEFT(LTRIM(RTRIM(PAN)),10) WHERE LEN(LTRIM(RTRIM(PAN)))>10  
UPDATE #CLIENTINTERMEDIATE SET CITY=LEFT(LTRIM(RTRIM(CITY)),50) WHERE LEN(LTRIM(RTRIM(CITY)))>50  
UPDATE #CLIENTINTERMEDIATE SET MOBILE=KYC.dbo.getCorrectMobileNo(MOBILE)   
UPDATE #CLIENTINTERMEDIATE SET MOBILE=0 WHERE ISNUMERIC(MOBILE)=0  
UPDATE #CLIENTINTERMEDIATE SET MOBILE=LEFT(LTRIM(RTRIM(MOBILE)),10) WHERE LEN(LTRIM(RTRIM(MOBILE)))>10  
UPDATE #CLIENTINTERMEDIATE SET ADD1=LEFT(LTRIM(RTRIM(ADD1)),100) WHERE LEN(LTRIM(RTRIM(ADD1)))>100  
UPDATE #CLIENTINTERMEDIATE SET ADD2=LEFT(LTRIM(RTRIM(ADD2)),100) WHERE LEN(LTRIM(RTRIM(ADD2)))>100  
UPDATE #CLIENTINTERMEDIATE SET ADD3=LEFT(LTRIM(RTRIM(ADD3)),100) WHERE LEN(LTRIM(RTRIM(ADD3)))>100  
UPDATE #CLIENTINTERMEDIATE SET PIN=LEFT(LTRIM(RTRIM(PIN)),15) WHERE LEN(LTRIM(RTRIM(PIN)))>15  
UPDATE #CLIENTINTERMEDIATE SET FAX=LEFT(LTRIM(RTRIM(FAX)),15) WHERE LEN(LTRIM(RTRIM(FAX)))>15  
UPDATE #CLIENTINTERMEDIATE SET EMAIL=LEFT(LTRIM(RTRIM(EMAIL)),150) WHERE LEN(LTRIM(RTRIM(EMAIL)))>150  
UPDATE #CLIENTINTERMEDIATE SET Phone1=LEFT(LTRIM(RTRIM(Phone1)),50) WHERE LEN(LTRIM(RTRIM(Phone1)))>50  
UPDATE #CLIENTINTERMEDIATE SET Phone2=LEFT(LTRIM(RTRIM(Phone2)),50) WHERE LEN(LTRIM(RTRIM(Phone2)))>50  
  
  
TRUNCATE TABLE STGTBL_CLIENTINTERMEDIARYMASTER  
  
  
  
INSERT INTO STGTBL_CLIENTINTERMEDIARYMASTER  
(  
INTERMEDTYPE,INTERMEDCODE,NAME,PAN,PARENTCODE,  
ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN,PHONE1,PHONE2,MOBILE,FAX,EMAIL  
)  
  
SELECT distinct INTERMEDTYPE,LTRIM(RTRIM(INTERMEDCODE)) AS INTERMEDCODE,LTRIM(RTRIM(NAME)) AS NAME,LTRIM(RTRIM(PAN)) AS PAN,  
LTRIM(RTRIM(PARENTCODE)) AS PARENTCODE,  
LTRIM(RTRIM(ADD1)) AS ADD1,LTRIM(RTRIM(ADD2)) AS ADD2,LTRIM(RTRIM(ADD3)) AS ADD3,LTRIM(RTRIM(CITY)) AS CITY,  
LTRIM(RTRIM(STATE)) AS STATE,  
LTRIM(RTRIM(COUNTRY)) AS COUNTRY,LTRIM(RTRIM(PIN)) AS PIN,LTRIM(RTRIM(PHONE1)) AS PHONE1,LTRIM(RTRIM(PHONE2)) AS PHONE2,  
LTRIM(RTRIM(MOBILE)) AS MOBILE,LTRIM(RTRIM(FAX)) AS FAX,  
LTRIM(RTRIM(EMAIL)) AS EMAIL  
FROM #CLIENTINTERMEDIATE  
  
  
drop table #BRANCHFROMBO  
drop table #CLIENTINTERMEDIATE  
drop table #Dealer  
drop table #DealerAndRm  
drop table #HARMONY  
drop table #REGIONFROMBO  
drop table #RM  
drop table #SBFinalData  
drop table #SBFromClient  
drop table #SbModule  
  
  
  
  
  
  
/* -----------Code for mail alert-------------*/  
  
DECLARE @COUNT INT  
DECLARE @COUNT1  varchar(10)   
  
DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                    
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)     
  
SELECT @COUNT = COUNT(IntermedCode) FROM STGTBL_CLIENTINTERMEDIARYMASTER with(nolock)  
  
--SELECT @COUNT AS CLIENTCODE  
SET @COUNT1 = @COUNT  
  
DECLARE @DATE VARCHAR(12)  
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))  
  
                
  
SET @S1 = 'SOS Alert For process SPX_SOS_stgtbl_ClientIntermediaryMaster on date '+@DATE+''  
  
set @mess='Dear ALL<br><br>                                      
                                      
 The process SPX_SOS_stgtbl_ClientIntermediaryMaster has been updated '+@COUNT1+' record into STGTBL_CLIENTINTERMEDIARYMASTER for date '+@DATE+'                                        
                    
<br> <br>                                  
by SOS process.'                                                         
 set @email='manish.shukla@angelbroking.com'                     
 --set @email='amit.s@angelbroking.com'                                                                                                           
exec msdb.dbo.sp_send_dbmail                                                                                                                           
@recipients  = @email,                                                                                                               
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                            
@profile_name = 'KYC',                                                                                                                                  
@body_format ='html',                                                              
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                      
--@file_attachments =@attach,                                                                                                                                                               
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sPX_SOS_Stgtbl_ClientRiskCategory
-- --------------------------------------------------
  
  
  
--select * from TBL_TEMP_CLIENTRISK_TEMPDATA   
--SELECT distinct csc FROM TBL_TEMP_CLIENTRISK_TEMPDATA WHERE RISKCATEGORY='HIGH' AND ISNULL(CSC,'')<>''   
    
CREATE PROC [dbo].[sPX_SOS_Stgtbl_ClientRiskCategory]    
AS   
  
   
SELECT CL_CODE INTO #CALNT   
FROM INTRANET.RISK.DBO.CLIENT_DETAILS With(NoLock)  
WHERE BRANCH_CD='CALNT' AND CL_CODE NOT LIKE '98%'  
   
--CODE FOR FETCHING CLIENT DETAILS    
    
     
  SELECT CL_CODE,PAN_GIR_NO,BRANCH_CD,SUB_BROKER,SEX,DOB,L_ADDRESS1,    
  L_ADDRESS2,L_ADDRESS3,L_CITY,L_STATE,L_NATION,L_ZIP,P_ADDRESS1,P_ADDRESS2,P_ADDRESS3,P_CITY,    
  P_STATE,P_NATION,P_ZIP,CL_STATUS INTO #CLIENT    
  FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)    
    
CREATE NONCLUSTERED INDEX IDX_FAMILY ON #CLIENT(CL_CODE)     
    
SELECT DISTINCT CL_CODE,MIN(ACTIVE_DATE) AS ACTIVE_DATE INTO #ACTIVE_CLIENT    
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS WITH(NOLOCK) WHERE INACTIVE_FROM>GETDATE()    
GROUP BY CL_CODE    
    
CREATE NONCLUSTERED INDEX IDX_FAMILY ON #ACTIVE_CLIENT(CL_CODE)     
    
SELECT * INTO #CLIENT_NEW FROM    
(    
 SELECT A.*,B.ACTIVE_DATE,'B2B' AS SBTYPE,0 AS AGE,'COOPERATIVE' AS RTGSOPTED,SPACE(100) AS CAPITALEXP,    
 SPACE(100) AS INCOME,SPACE(100) AS OCCUPATION,SPACE(100) AS EDUCATION,SPACE(10) AS OFFLINEONLINE,'LEASED' AS ADDRESSTYPE,    
 SPACE(100) AS CSC,SPACE(10) AS CALNT    
 FROM #CLIENT A WITH(NOLOCK)    
 INNER JOIN #ACTIVE_CLIENT B WITH(NOLOCK)    
 ON A.CL_CODE=B.CL_CODE    
 WHERE A.CL_CODE=A.CL_CODE AND B.CL_CODE=B.CL_CODE    
) F    
    
    
    
  CREATE NONCLUSTERED INDEX IDX_CLIENTCODE ON #CLIENT_NEW(CL_CODE)    
  DELETE FROM #CLIENT_NEW WHERE CL_CODE LIKE '98%' AND CL_CODE=CL_CODE    
  DELETE FROM #CLIENT_NEW WHERE CL_CODE LIKE '88%' AND CL_CODE=CL_CODE    
      
-- CODE FOR RTGS DETAILS OF CLIENTS    
SELECT DISTINCT A.FLD_PARTY_CODE AS CL_CODE,A.FLD_BANK_ACNO AS ACCNO      
,B.BANK_NAME,B.BRANCH_NAME,B.MICR_CODE INTO #CLIENTRTGSDETAILS      
FROM INTRANET.RISK.DBO.TBL_RTGS_CLIENTS A WITH(NOLOCK)      
INNER JOIN      
INTRANET.RISK.DBO.RTGS_MASTER B WITH(NOLOCK)      
ON A.FLD_RTGS_SR_NO=B.SR_NO      
WHERE A.FLD_STATUS='A'     
  
CREATE NONCLUSTERED INDEX IDX_RTGS ON #CLIENTRTGSDETAILS(CL_CODE)    
    
-- CODE FOR ONLINE OFFLINE DETAILS OF CLIENTS    
SELECT DISTINCT PCODE,BBB,STATUS INTO #ONLINEOFFLINE FROM INTRANET.MIS.DBO.ODINCLIENTINFO WITH(NOLOCK) WHERE STATUS='A'     
  CREATE NONCLUSTERED INDEX IDX_ONLINEOFFLINE ON #ONLINEOFFLINE(PCODE)    
  
--FOR ONLINE CLIENTS: BBB='4'    
--FOR OFFLINE CLIENTS: BBB='2'    
     
--STATUS: 'S' IS FOR SUSPEND    
--STATUS: 'A' IS FOR ACTIVE    
    
-- CODE FOR B2B AND B2C    
SELECT B2C_SB INTO #B2BANDB2C FROM MIS.REMISIOR.DBO.B2C_SB WITH(NOLOCK)   
CREATE NONCLUSTERED INDEX IDX_B2BC ON #B2BANDB2C(B2C_SB)    
  
   
-- CODE FOR KYC DETAILS    
    
SELECT DISTINCT C.PARTY_CODE,LTRIM(RTRIM(T.FLD_INCOME)) AS FLD_INCOME,  
LTRIM(RTRIM(FLD_OCCUPATION)) AS FLD_OCCUPATION,LTRIM(RTRIM(FLD_EDUCATION)) AS FLD_EDUCATION,FLD_PANNO,FLD_BR_ENTRYDATE INTO #KYCDETAILS       
FROM ABVSKYCMIS.KYC.DBO.CLIENT_INWARDREGISTER C WITH(NOLOCK)      
INNER JOIN ABVSKYCMIS.KYC.DBO.TBL_KYC_INWARD T WITH(NOLOCK)      
ON C.BRID=T.FLD_SRNO      
WHERE ISNULL(C.BRID,0)<>0 AND ISNULL(C.PARTY_CODE,'')<>'' AND C.PARTY_CODE NOT LIKE 'OBJ%'      
      
      
CREATE INDEX IDX_KYCDATA ON #KYCDETAILS(PARTY_CODE)     
    
DELETE FROM #KYCDETAILS WHERE ISNULL(FLD_INCOME,'')='' AND ISNULL(FLD_OCCUPATION,'')='' AND ISNULL(FLD_EDUCATION,'')=''    
AND PARTY_CODE=PARTY_CODE    
     
  ;WITH CTE AS      
 (      
  SELECT ROW_NUMBER() OVER (PARTITION BY  PARTY_CODE ORDER BY FLD_BR_ENTRYDATE DESC) AS SNO ,* FROM      
  #KYCDETAILS WHERE PARTY_CODE=PARTY_CODE      
 )       
       
     
 SELECT * INTO #KYCDETAILS_FINAL FROM CTE WHERE SNO=1      
 -- CODE FOR OLD CODE TO NEW CODE    
    SELECT * INTO #OLDCODE FROM    
    (    
    SELECT NEW_KYC_CODE,OLD_KYC_CODE FROM INTRANET.TESTDB.DBO.V_KYC_OLDNEW_SHIFTING V WITH(NOLOCK)                     
    INNER JOIN #CLIENT C ON V.NEW_KYC_CODE=C.CL_CODE               
    UNION               
    SELECT NEW_KYC_CODE,OLD_KYC_CODE FROM INTRANET.TESTDB.DBO.SHIFT V WITH(NOLOCK)                     
    INNER JOIN #CLIENT C ON V.NEW_KYC_CODE=C.CL_CODE     
    ) F     
        
     
SELECT DISTINCT C.PARTY_CODE,LTRIM(RTRIM(T.FLD_INCOME)) AS FLD_INCOME,  
LTRIM(RTRIM(FLD_OCCUPATION)) AS FLD_OCCUPATION,LTRIM(RTRIM(FLD_EDUCATION)) AS FLD_EDUCATION,  
FLD_PANNO,FLD_BR_ENTRYDATE,NEW_KYC_CODE INTO #KYCDETAILSFOROLDCODE      
FROM ABVSKYCMIS.KYC.DBO.CLIENT_INWARDREGISTER C WITH(NOLOCK)      
INNER JOIN ABVSKYCMIS.KYC.DBO.TBL_KYC_INWARD T WITH(NOLOCK)      
ON C.BRID=T.FLD_SRNO    
INNER JOIN #OLDCODE O WITH(NOLOCK) ON O.OLD_KYC_CODE=C.PARTY_CODE    
    
DELETE FROM #KYCDETAILSFOROLDCODE WHERE ISNULL(FLD_INCOME,'')='' AND ISNULL(FLD_OCCUPATION,'')='' AND ISNULL(FLD_EDUCATION,'')=''    
    
 ;WITH CTE AS      
 (      
  SELECT ROW_NUMBER() OVER (PARTITION BY  PARTY_CODE ORDER BY FLD_BR_ENTRYDATE DESC) AS SNO ,* FROM      
  #KYCDETAILSFOROLDCODE     
 )       
       
     
 SELECT * INTO #KYCDETAILSFOROLDCODE_FINAL FROM CTE WHERE SNO=1      
-- CODE FOR FETCH CSC DATA     
    
    
SELECT * INTO #CSC FROM    
(    
SELECT A.IOCCPARTYCODE AS PARTY_CODE,LTRIM(RTRIM(B.SBUSINESSNAME)) AS  SBUSINESSNAME    
FROM SOS_STGTBL_PMLAOCCUPATIONDETAIL A WITH(NOLOCK)    
INNER JOIN     
SOS_STGTBL_PMLABUSINESSNATURE B WITH(NOLOCK)    
ON A.IOCCBUSSINESSNATUREID=B.IBUSINESSID    
WHERE BISACTIVE=1    
) F     
    
 UPDATE #CLIENT_NEW SET CALNT='CALNT'  
 FROM #CALNT A WHERE #CLIENT_NEW.CL_CODE=A.CL_CODE  
    
     
 UPDATE #CLIENT_NEW SET INCOME=FLD_INCOME,OCCUPATION=FLD_OCCUPATION,EDUCATION=FLD_EDUCATION    
 FROM #KYCDETAILS_FINAL A WHERE #CLIENT_NEW.CL_CODE=A.PARTY_CODE    
     
 UPDATE #CLIENT_NEW SET INCOME=FLD_INCOME,OCCUPATION=FLD_OCCUPATION,EDUCATION=FLD_EDUCATION    
 FROM #KYCDETAILSFOROLDCODE A WHERE #CLIENT_NEW.CL_CODE=A.NEW_KYC_CODE    
     
 UPDATE #CLIENT_NEW SET RTGSOPTED='OTHERS'    
 FROM #CLIENTRTGSDETAILS A WHERE #CLIENT_NEW.CL_CODE=A.CL_CODE    
     
 UPDATE #CLIENT_NEW SET SBTYPE='B2C'    
 FROM #B2BANDB2C A WHERE #CLIENT_NEW.SUB_BROKER=A.B2C_SB    
      
 UPDATE #CLIENT_NEW SET AGE=DATEDIFF(DAY, ISNULL(DOB,0), GETDATE())/365    
 UPDATE #CLIENT_NEW SET CAPITALEXP=DATEDIFF(DAY, ISNULL(ACTIVE_DATE,0), GETDATE())/365    
     
 UPDATE #CLIENT_NEW SET OFFLINEONLINE= CASE WHEN ISNULL(BBB,0) in (4,134) THEN 'ONLINE' ELSE 'OFFLINE' END    
 FROM #ONLINEOFFLINE A WHERE #CLIENT_NEW.CL_CODE=A.PCODE    
     
 UPDATE #CLIENT_NEW SET ADDRESSTYPE= 'OWNED'    
     
 WHERE LTRIM(RTRIM(ISNULL(P_ADDRESS1,'')))<>'' AND CL_CODE=CL_CODE  
     
 UPDATE #CLIENT_NEW SET CSC= SBUSINESSNAME    
 FROM #CSC A WHERE #CLIENT_NEW.CL_CODE=A.PARTY_CODE    
     
ALTER TABLE #CLIENT_NEW ADD CSCRISK_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD AGE_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD GENDER_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD INCOME_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD OCCUPATION_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD B2B_B2C_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD CAPITALMARKETEXP_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD RESIDENCETYPE_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD BANKTYPE_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD OFFLINEONLINE_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD EDUCATION_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD TOTAL_POINTS FLOAT    
ALTER TABLE #CLIENT_NEW ADD RISKCATEGORY VARCHAR(10)    
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC=CASE WHEN ISNULL(CL_STATUS,'')='NRE' THEN 'NRE'  
WHEN ISNULL(CL_STATUS,'')='NRI' THEN 'NRI'  
WHEN ISNULL(CL_STATUS,'')='NRO' THEN 'NRO'  
WHEN ISNULL(CL_STATUS,'')='TS' THEN 'TRUST/SOCIETY'  
WHEN ISNULL(CL_STATUS,'')='NOR' THEN 'NOT ORDINARY RESIDENT'  
WHEN ISNULL(CL_STATUS,'')='OCB' THEN 'OVERSEAS CORPORATE BODY'  
END  
  
  
WHERE CL_STATUS IN ('NRE','NRI','NRO','TS','NOR','OCB') AND CL_CODE=CL_CODE  
  
  
  
    
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='FOREX SERVICES COMPANIES'    
WHERE CSC='FOREX SERVICES COMPANIES' AND CL_CODE=CL_CODE    
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='NON RESIDENT CLIENTS'    
WHERE CSC='NON RESIDENT CLIENTS' AND CL_CODE=CL_CODE   
-------------------------------------------------------------  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='HNI'    
WHERE CSC='HNI' AND CL_CODE=CL_CODE  
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='TRUST'    
WHERE CSC='TRUST' AND CL_CODE=CL_CODE  
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='CHARITY'    
WHERE CSC='CHARITY' AND CL_CODE=CL_CODE   
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='NGOS AND ORGANIZATIONS RECEIVING DONATIONS'    
WHERE CSC='NGOS AND ORGANIZATIONS RECEIVING DONATIONS' AND CL_CODE=CL_CODE  
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='COMPANIES HAVING CLOSE FAMILY SHARHOLDING OR BO'    
WHERE CSC='COMPANIES HAVING CLOSE FAMILY SHARHOLDING OR BO' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='PEP OF FOREIGN ORIGIN'    
WHERE CSC='PEP OF FOREIGN ORIGIN' AND CL_CODE=CL_CODE  
   
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='CURRENT/FORMER HEAD OF STATE'    
WHERE CSC='CURRENT/FORMER HEAD OF STATE' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='POLITICIAN AND CONNECTED PERSONS - CURRENT/FORMER'    
WHERE CSC='POLITICIAN AND CONNECTED PERSONS - CURRENT/FORMER' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='HIGH RISK COUNTRY CLIENTS'    
WHERE CSC='HIGH RISK COUNTRY CLIENTS' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='SEBI/EXCHANGE DEBARRED CLIENT'    
WHERE CSC='SEBI/EXCHANGE DEBARRED CLIENT' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='CLIENTS WITH DUBIOUS REPUTATION AS PER PUBLIC INFORMATION'    
WHERE CSC='CLIENTS WITH DUBIOUS REPUTATION AS PER PUBLIC INFORMATION' AND CL_CODE=CL_CODE  
  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='CALNT'    
WHERE ISNULL(CALNT,'')='CALNT' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET RISKCATEGORY='HIGH',CSC='ONLINE'     
WHERE ISNULL(OFFLINEONLINE,'')='ONLINE' AND CL_CODE=CL_CODE  
  
  
    
    
SELECT LTRIM(RTRIM(AGE)) AS AGE,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS AGEPOINT INTO #AGEPOINT FROM TBL_RISKCATEGORIZATION_AGE WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(OCCUPATION)) AS OCCUPATION,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS B2BCPOINT INTO #B2BB2C FROM TBL_RISKCATEGORIZATION_B2B_B2C_CLIENT WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(GENDER)) AS GENDER,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS GENDERPOINT INTO #GENDER FROM TBL_RISKCATEGORIZATION_GENDER WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(ONLINE_OFFLINE)) AS ONLINE_OFFLINE,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS ONLINE_OFFLINEPOINT INTO #OFFLINETOONLINE    
FROM TBL_RISKCATEGORIZATION_ONLINE_OFFLINE_CLIENT WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(BANK_TYPE)) AS BANK_TYPE,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS BANKPOINT INTO #BANK    
FROM TBL_RISKCATEGORIZATION_BANK_TYPE WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(RESIDENCE_TYPE)) AS RESIDENCE_TYPE,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS RESIDENCE_POINT INTO #RESIDENCE_TYPE    
FROM TBL_RISKCATEGORIZATION_RESIDENCE_TYPE WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(CAPITAL_MARKET_EXPERIENCE)) AS CAPITAL_MARKET_EXPERIENCE,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS MARKETEXP_POINT INTO #MARKETEXP    
FROM TBL_RISKCATEGORIZATION_CAPITAL_MARKET_EXPERIENCE WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(INCOME_LEVEL)) AS INCOME_LEVEL,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS INCOME_POINT INTO #INCOME    
FROM TBL_RISKCATEGORIZATION_INCOMELEVEL WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(OCCUPATION)) AS OCCUPATION,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS OCCUPATION_POINT INTO #OCCUPATION    
FROM TBL_RISKCATEGORIZATION_OCCUPATION WITH(NOLOCK)    
    
SELECT LTRIM(RTRIM(EDUCATION)) AS EDUCATION,(CAST(WEIGHT AS FLOAT)*CAST(POINT AS FLOAT))/100 AS EDUCATION_POINT INTO #EDUCATION    
FROM TBL_RISKCATEGORIZATION_EDUCATION WITH(NOLOCK)    
   
 --SELECT * FROM #OCCUPATION   
    
UPDATE #CLIENT_NEW SET INCOME='<10' WHERE INCOME IN    
(    
'0-1',    
'1-2',    
'1-5',    
'5-10'    
)  AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW SET INCOME='>10' WHERE INCOME IN    
(    
'>25',    
'10-25',    
'25'    
)   AND CL_CODE=CL_CODE  
   
   
-- OCCUPATION   
UPDATE #CLIENT_NEW  SET OCCUPATION='BUSINESS' WHERE OCCUPATION IN('BUSSINESS','SELF-EMPLOYED') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET OCCUPATION='PROFESSIONAL' WHERE OCCUPATION IN('PROFESSIONAL') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET OCCUPATION='PUBLIC SECTOR' WHERE OCCUPATION IN('EMPLOYED','EMPLOYEE') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET OCCUPATION='STUDENT' WHERE OCCUPATION IN('STUDENT') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET OCCUPATION='HOUSEWIFE' WHERE OCCUPATION IN('HOUSE-WIFE') AND CL_CODE=CL_CODE  
-- EDUCATION  
UPDATE #CLIENT_NEW  SET EDUCATION='GRADUATE' WHERE EDUCATION IN('ENGINEER','GRADUATE') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET EDUCATION='PG' WHERE EDUCATION IN('CA','DOCTOR','MBA','PHD') AND CL_CODE=CL_CODE  
UPDATE #CLIENT_NEW  SET EDUCATION='HIGH SCHOOL OR BELOW' WHERE EDUCATION IN('NON MATRIC','SSC/HSC') AND CL_CODE=CL_CODE   
   
    
UPDATE #CLIENT_NEW SET AGE_POINTS=AGEPOINT    
FROM #AGEPOINT A WHERE #CLIENT_NEW.AGE=A.AGE    
AND ISNULL(#CLIENT_NEW.AGE,0)<>0 AND ISNULL(RISKCATEGORY,'')<>'HIGH'  AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET B2B_B2C_POINTS=B2BCPOINT    
FROM #B2BB2C A WHERE #CLIENT_NEW.SBTYPE=A.OCCUPATION    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET GENDER_POINTS=GENDERPOINT    
FROM #GENDER A WHERE #CLIENT_NEW.SEX=A.GENDER    
AND ISNULL(SEX,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET OFFLINEONLINE_POINTS=ONLINE_OFFLINEPOINT    
FROM #OFFLINETOONLINE A WHERE #CLIENT_NEW.OFFLINEONLINE=A.ONLINE_OFFLINE    
AND ISNULL(OFFLINEONLINE,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET BANKTYPE_POINTS=BANKPOINT    
FROM #BANK A WHERE #CLIENT_NEW.RTGSOPTED=A.BANK_TYPE    
AND ISNULL(RTGSOPTED,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET RESIDENCETYPE_POINTS=RESIDENCE_POINT    
FROM #RESIDENCE_TYPE A WHERE #CLIENT_NEW.ADDRESSTYPE=A.RESIDENCE_TYPE    
AND ISNULL(RISKCATEGORY,'')<>'HIGH'  AND CL_CODE=CL_CODE  
    
UPDATE #CLIENT_NEW SET CAPITALMARKETEXP_POINTS=MARKETEXP_POINT    
FROM #MARKETEXP A WHERE #CLIENT_NEW.CAPITALEXP=A.CAPITAL_MARKET_EXPERIENCE    
AND ISNULL(CAPITALEXP,0)<>0    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
    
UPDATE #CLIENT_NEW SET INCOME_POINTS=INCOME_POINT    
FROM #INCOME A WHERE #CLIENT_NEW.INCOME=A.INCOME_LEVEL    
AND ISNULL(INCOME,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE   
  
UPDATE #CLIENT_NEW SET OCCUPATION_POINTS=OCCUPATION_POINT    
FROM #OCCUPATION A WHERE #CLIENT_NEW.OCCUPATION=A.OCCUPATION    
AND ISNULL(#CLIENT_NEW.OCCUPATION,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE  
  
UPDATE #CLIENT_NEW SET EDUCATION_POINTS=EDUCATION_POINT    
FROM #EDUCATION A WHERE #CLIENT_NEW.EDUCATION=A.EDUCATION    
AND ISNULL(#CLIENT_NEW.EDUCATION,'')<>''    
AND ISNULL(RISKCATEGORY,'')<>'HIGH'  AND CL_CODE=CL_CODE   
   
  
  
UPDATE #CLIENT_NEW SET TOTAL_POINTS=ISNULL(CSCRISK_POINTS,0)+ISNULL(AGE_POINTS,0)+ISNULL(GENDER_POINTS,0)+  
ISNULL(INCOME_POINTS,0)+ISNULL(OCCUPATION_POINTS,0)+ISNULL(B2B_B2C_POINTS,0)+  
ISNULL(CAPITALMARKETEXP_POINTS,0)+ISNULL(RESIDENCETYPE_POINTS,0)+ISNULL(BANKTYPE_POINTS,0)+ISNULL(OFFLINEONLINE_POINTS,0)+  
ISNULL(EDUCATION_POINTS,0)  
WHERE ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE  
   
UPDATE #CLIENT_NEW SET RISKCATEGORY=CASE WHEN ISNULL(TOTAL_POINTS,0)>60 THEN 'LOW'  
WHEN ISNULL(TOTAL_POINTS,0)>=45 AND ISNULL(TOTAL_POINTS,0)<=60 THEN 'MEDIUM' WHEN ISNULL(TOTAL_POINTS,0)<45 THEN 'HIGH' END  
WHERE ISNULL(RISKCATEGORY,'')<>'HIGH' AND CL_CODE=CL_CODE  
  
  TRUNCATE TABLE TBL_TEMP_CLIENTRISK_TEMPDATA  
  INSERT INTO TBL_TEMP_CLIENTRISK_TEMPDATA  
  (  
CL_CODE,PAN_GIR_NO,BRANCH_CD,SUB_BROKER,SEX,  
DOB,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_STATE,L_NATION,L_ZIP,P_ADDRESS1,P_ADDRESS2,P_ADDRESS3,  
P_CITY,P_STATE,P_NATION,P_ZIP,ACTIVE_DATE,SBTYPE,AGE,RTGSOPTED,CAPITALEXP,INCOME,OCCUPATION,EDUCATION,  
OFFLINEONLINE,ADDRESSTYPE,CSC,CSCRISK_POINTS,AGE_POINTS,GENDER_POINTS,INCOME_POINTS,OCCUPATION_POINTS,  
B2B_B2C_POINTS,CAPITALMARKETEXP_POINTS,RESIDENCETYPE_POINTS,BANKTYPE_POINTS,OFFLINEONLINE_POINTS,EDUCATION_POINTS,  
TOTAL_POINTS,RISKCATEGORY,CALNT  
  )  
  SELECT CL_CODE,PAN_GIR_NO,BRANCH_CD,SUB_BROKER,SEX,  
DOB,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_STATE,L_NATION,L_ZIP,P_ADDRESS1,P_ADDRESS2,P_ADDRESS3,  
P_CITY,P_STATE,P_NATION,P_ZIP,ACTIVE_DATE,SBTYPE,AGE,RTGSOPTED,CAPITALEXP,INCOME,OCCUPATION,EDUCATION,  
OFFLINEONLINE,ADDRESSTYPE,CSC,CSCRISK_POINTS,AGE_POINTS,GENDER_POINTS,INCOME_POINTS,OCCUPATION_POINTS,  
B2B_B2C_POINTS,CAPITALMARKETEXP_POINTS,RESIDENCETYPE_POINTS,BANKTYPE_POINTS,OFFLINEONLINE_POINTS,EDUCATION_POINTS,  
TOTAL_POINTS,RISKCATEGORY,CALNT FROM #CLIENT_NEW WHERE CL_CODE=CL_CODE  
    
  --SELECT COUNT(*) FROM #CLIENT_NEW WHERE RISKCATEGORY='LOW'   
  --SELECT COUNT(*) FROM #CLIENT_NEW WHERE RISKCATEGORY='MEDIUM'  
  --SELECT COUNT(*) FROM #CLIENT_NEW WHERE RISKCATEGORY='HIGH'  
    
TRUNCATE TABLE STGTBL_CLIENTRISKCATEGORY    
INSERT INTO STGTBL_CLIENTRISKCATEGORY    
(    
CLIENTCODE,    
RISKCATTYPE,    
RISKCATEGORY,    
RISKTYPE,  
FROMDT    
)    
    
SELECT DISTINCT CL_CODE,case when isnull(replace(CSC,'OTHERS',''),'')<>'' then 'CSC RISK' else 'BUSINESS RISK' end,  
replace(CSC,'OTHERS',''),RISKCATEGORY,GETDATE() FROM #CLIENT_NEW WHERE CL_CODE=CL_CODE    
    
    
    
DROP TABLE #ACTIVE_CLIENT    
DROP TABLE #CLIENT    
DROP TABLE #CLIENT_NEW    
DROP TABLE #KYCDETAILS_FINAL    
DROP TABLE #B2BANDB2C    
DROP TABLE #CLIENTRTGSDETAILS    
DROP TABLE #CSC    
DROP TABLE #KYCDETAILS    
DROP TABLE #KYCDETAILSFOROLDCODE    
DROP TABLE #KYCDETAILSFOROLDCODE_FINAL    
DROP TABLE #OLDCODE    
DROP TABLE #ONLINEOFFLINE    
DROP TABLE #B2BB2C    
DROP TABLE #BANK    
DROP TABLE #OFFLINETOONLINE    
DROP TABLE #AGEPOINT    
DROP TABLE #GENDER    
DROP TABLE #MARKETEXP    
DROP TABLE #RESIDENCE_TYPE    
DROP TABLE #EDUCATION    
DROP TABLE #INCOME    
DROP TABLE #OCCUPATION   
DROP TABLE #CALNT  
   
    
    
    
/* -----------CODE FOR MAIL ALERT-------------*/    
    
DECLARE @COUNT INT    
DECLARE @COUNT1  VARCHAR(10)     
    
DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                      
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)       
    
SELECT @COUNT = COUNT(CLIENTCODE) FROM STGTBL_CLIENTRISKCATEGORY WITH(NOLOCK)    
    
--SELECT @COUNT AS CLIENTCODE    
SET @COUNT1 = @COUNT    
    
DECLARE @DATE VARCHAR(12)    
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))    
    
                  
    
SET @S1 = 'SOS ALERT FOR PROCESS SPX_SOS_STGTBL_CLIENTRISKCATEGORY ON DATE '+@DATE+''    
    
SET @MESS='DEAR ALL<BR><BR>                                        
                                        
 THE PROCESS SPX_SOS_STGTBL_CLIENTRISKCATEGORY HAS BEEN UPDATED '+@COUNT1+' RECORD INTO STGTBL_CLIENTRISKCATEGORY FOR DATE '+@DATE+'                                          
                      
<BR> <BR>                                    
BY SOS PROCESS.'                                                           
 SET @EMAIL='MANISH.SHUKLA@ANGELBROKING.COM'                       
 --SET @EMAIL='AMIT.S@ANGELBROKING.COM'                                                                                                             
EXEC MSDB.DBO.SP_SEND_DBMAIL                                                                                       
@RECIPIENTS  = @EMAIL,                                                                                                                 
@COPY_RECIPIENTS ='AMIT.S@ANGELBROKING.COM;ARAVIND.SHENOY@ANGELBROKING.COM',                                                                  
--@BLIND_COPY_RECIPIENTS='AMIT.S@ANGELBROKING.COM;ARAVIND.SHENOY@ANGELBROKING.COM',                            
@PROFILE_NAME = 'KYC',                                                                                                                                    
@BODY_FORMAT ='HTML',                                                                
@SUBJECT = @S1, --'ALERT FOR PROCESS ------------ ON DATE '+@DATE+'',                                        
--@FILE_ATTACHMENTS =@ATTACH,                                                                                                                                                                 
@BODY =@MESS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGBL_CLEINTCONTACT_PERSON
-- --------------------------------------------------

  
CREATE PROC [dbo].[SPX_STGBL_CLEINTCONTACT_PERSON]  
AS  
  
--DROP TABLE #TEMPCLIENTCONTACT  
SELECT CL_CODE,CONTACT_NAME,PANNO,DESIGNATION,ADDRESS1,ADDRESS2,ADDRESS3,CITY,STATE,NATION,  
ZIP AS PIN,PHONE_NO,MOBILENO,EMAIL INTO #TEMPCLIENTCONTACT FROM   
[196.1.115.196].MSAJAG.DBO.CLIENT_CONTACT_DETAILS WITH(NOLOCK)  
  
 
SELECT DISTINCT CL_CODE INTO #ACTIVE_CLIENT
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS WITH(NOLOCK) WHERE --INACTIVE_FROM>GETDATE()
--AND 
CL_CODE IN (SELECT CL_CODE FROM #TEMPCLIENTCONTACT)

DELETE FROM #TEMPCLIENTCONTACT WHERE CL_CODE NOT IN (SELECT CL_CODE FROM #ACTIVE_CLIENT) 
  
  
  
  
UPDATE #TEMPCLIENTCONTACT SET  PANNO='NA' WHERE ISNULL(PANNO,'')=''  
UPDATE #TEMPCLIENTCONTACT SET  DESIGNATION='contact person'  WHERE ISNULL(DESIGNATION,'')=''  
UPDATE #TEMPCLIENTCONTACT SET  ADDRESS1=null WHERE ADDRESS1=''  
UPDATE #TEMPCLIENTCONTACT SET  ADDRESS2=null WHERE ADDRESS2=''  
UPDATE #TEMPCLIENTCONTACT SET  ADDRESS3=null WHERE ADDRESS3=''  
UPDATE #TEMPCLIENTCONTACT SET  CITY='city' WHERE CITY=''  
UPDATE #TEMPCLIENTCONTACT SET  STATE='state' WHERE STATE=''  
UPDATE #TEMPCLIENTCONTACT SET  NATION='country' WHERE NATION=''  
UPDATE #TEMPCLIENTCONTACT SET  PIN=null WHERE PIN=''  
UPDATE #TEMPCLIENTCONTACT SET  PHONE_NO=null WHERE PHONE_NO=''  
UPDATE #TEMPCLIENTCONTACT SET  MOBILENO=null WHERE MOBILENO=''  
UPDATE #TEMPCLIENTCONTACT SET  EMAIL=null WHERE EMAIL=''  
  
  
 UPDATE #TEMPCLIENTCONTACT SET CONTACT_NAME=LEFT(LTRIM(RTRIM(CONTACT_NAME)),150) WHERE LEN(LTRIM(RTRIM(CONTACT_NAME)))>150  
  UPDATE #TEMPCLIENTCONTACT SET PANNO=LEFT(LTRIM(RTRIM(PANNO)),10) WHERE LEN(LTRIM(RTRIM(PANNO)))>10  
   UPDATE #TEMPCLIENTCONTACT SET DESIGNATION=LEFT(LTRIM(RTRIM(DESIGNATION)),50) WHERE LEN(LTRIM(RTRIM(DESIGNATION)))>50  
    UPDATE #TEMPCLIENTCONTACT SET ADDRESS1=LEFT(LTRIM(RTRIM(ADDRESS1)),100) WHERE LEN(LTRIM(RTRIM(ADDRESS1)))>100  
     UPDATE #TEMPCLIENTCONTACT SET ADDRESS2=LEFT(LTRIM(RTRIM(ADDRESS2)),100) WHERE LEN(LTRIM(RTRIM(ADDRESS2)))>100  
      UPDATE #TEMPCLIENTCONTACT SET ADDRESS3=LEFT(LTRIM(RTRIM(ADDRESS3)),100) WHERE LEN(LTRIM(RTRIM(ADDRESS3)))>100  
       UPDATE #TEMPCLIENTCONTACT SET CITY=LEFT(LTRIM(RTRIM(CITY)),40) WHERE LEN(LTRIM(RTRIM(CITY)))>40  
        UPDATE #TEMPCLIENTCONTACT SET STATE=LEFT(LTRIM(RTRIM(STATE)),50) WHERE LEN(LTRIM(RTRIM(STATE)))>50  
         UPDATE #TEMPCLIENTCONTACT SET NATION=LEFT(LTRIM(RTRIM(NATION)),50) WHERE LEN(LTRIM(RTRIM(NATION)))>50  
          UPDATE #TEMPCLIENTCONTACT SET PIN=LEFT(LTRIM(RTRIM(PIN)),10) WHERE LEN(LTRIM(RTRIM(PIN)))>10  
           UPDATE #TEMPCLIENTCONTACT SET PHONE_NO=LEFT(LTRIM(RTRIM(PHONE_NO)),50) WHERE LEN(LTRIM(RTRIM(PHONE_NO)))>50  
            UPDATE #TEMPCLIENTCONTACT SET MOBILENO=LEFT(LTRIM(RTRIM(MOBILENO)),10) WHERE LEN(LTRIM(RTRIM(MOBILENO)))>10  
             UPDATE #TEMPCLIENTCONTACT SET EMAIL=LEFT(LTRIM(RTRIM(EMAIL)),200) WHERE LEN(LTRIM(RTRIM(EMAIL)))>200  
  
TRUNCATE TABLE stgtbl_ClientContactPerson  
  
INSERT INTO stgtbl_ClientContactPerson  
(  
ClientCode,ContactName,PAN,Designation,Add1,Add2,Add3,City,State,Country,Pin,Phone1,Mobile,Email  
  
)  
  
SELECT LTRIM(RTRIM(CL_CODE)),LTRIM(RTRIM(CONTACT_NAME)),LTRIM(RTRIM(PANNO)),LTRIM(RTRIM(DESIGNATION)),LTRIM(RTRIM(ADDRESS1)),LTRIM(RTRIM(ADDRESS2)),
LTRIM(RTRIM(ADDRESS3)),LTRIM(RTRIM(CITY)),LTRIM(RTRIM(STATE)),LTRIM(RTRIM(NATION)),  
LTRIM(RTRIM(PIN)),LTRIM(RTRIM(PHONE_NO)),LTRIM(RTRIM(MOBILENO)),LTRIM(RTRIM(EMAIL)) FROM #TEMPCLIENTCONTACT

drop table #ACTIVE_CLIENT
drop table #TEMPCLIENTCONTACT



DECLARE @COUNT INT
DECLARE @COUNT1  varchar(10) 

DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                  
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)   

SELECT @COUNT = COUNT(ClientCode) FROM stgtbl_ClientContactPerson with(nolock)

--SELECT @COUNT AS CLIENTCODE
SET @COUNT1 = @COUNT

DECLARE @DATE VARCHAR(12)
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))

              

SET @S1 = 'SOS Alert For process SPX_STGBL_CLEINTCONTACT_PERSON on date '+@DATE+''

set @mess='Dear ALL<br><br>                                    
                                    
 The process SPX_STGBL_CLEINTCONTACT_PERSON has been updated '+@COUNT1+' record into stgtbl_ClientContactPerson for date '+@DATE+'                                      
                  
<br> <br>                                
by SOS process.'                                                       
 set @email='manish.shukla@angelbroking.com'                   
 --set @email='amit.s@angelbroking.com'                                                                                                         
exec msdb.dbo.sp_send_dbmail                                                                                                                         
@recipients  = @email,                                                                                                             
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                              
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                             
@profile_name = 'KYC',                                                                                                                                
@body_format ='html',                                                            
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                    
--@file_attachments =@attach,                                                                                                                                                             
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGTBL_CLIENTBANKDET
-- --------------------------------------------------
  
  
    
CREATE PROC [dbo].[SPX_STGTBL_CLIENTBANKDET]                
                
AS                
      
 SELECT A.FLD_PARTY_CODE AS CL_CODE,A.FLD_BANK_ACNO AS ACCNO    
,B.BANK_NAME,B.BRANCH_NAME,B.MICR_CODE INTO #CLIENTRTGSDETAILS    
FROM INTRANET.RISK.DBO.tbl_rtgs_clients A WITH(NOLOCK)    
INNER JOIN    
INTRANET.RISK.DBO.RTGS_MASTER B WITH(NOLOCK)    
ON A.FLD_RTGS_SR_NO=B.SR_NO    
WHERE A.FLD_STATUS='A'     
      
          
  
  
  
  
-- NSE  
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #NSEMULTIBANKID FROM [AngelNseCM].ACCOUNT.DBO.MULTIBANKID WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #196NSEPOBANK FROM [AngelNseCM].MSAJAG.DBO.POBANK B WITH(NOLOCK)  
  
  
  CREATE NONCLUSTERED INDEX IDX_NSEMULTIBANKID ON #NSEMULTIBANKID(BANKID)   
  CREATE NONCLUSTERED INDEX IDX_196NSEPOBANK ON #196NSEPOBANK(BANKID)  
  
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #NSE FROM #NSEMULTIBANKID M WITH(NOLOCK)  
INNER JOIN  #196NSEPOBANK B WITH(NOLOCK)  
ON B.BANKID=M.BANKID  
WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID  
       
   DROP TABLE #NSEMULTIBANKID  
DROP TABLE #196NSEPOBANK  
              
   -- BSE        
                
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #BSEMULTIBANKID FROM [AngelBSECM].ACCOUNT_AB.DBO.MULTIBANKID WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #BSEPOBANK FROM [AngelBSECM].BSEDB_AB.DBO.POBANK B WITH(NOLOCK)         
    
  CREATE NONCLUSTERED INDEX IDX_BSEMULTIBANKID ON #BSEMULTIBANKID(BANKID)   
  CREATE NONCLUSTERED INDEX IDX_BSEPOBANK ON #BSEPOBANK(BANKID)  
                  
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #BSE              
FROM              
#BSEMULTIBANKID M WITH(NOLOCK)   
INNER JOIN #BSEPOBANK B WITH(NOLOCK)   
ON B.BANKID=M.BANKID WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID   
    
     DROP TABLE #BSEMULTIBANKID  
DROP TABLE #BSEPOBANK  
    
  -- NSE FO  
    
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #NSEFOMULTIBANKID FROM [AngelFO].ACCOUNTFO.DBO.MULTIBANKID WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #NSEFOPOBANK FROM [AngelFO].NSEFO.DBO.POBANK WITH(NOLOCK)     
   
 CREATE NONCLUSTERED INDEX IDX_NSEFOMULTIBANKID ON #NSEFOMULTIBANKID(BANKID)   
  CREATE NONCLUSTERED INDEX IDX_NSEFOPOBANK ON #NSEFOPOBANK(BANKID)   
                
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #NSEFO              
FROM             
#NSEFOMULTIBANKID M WITH(NOLOCK)               
 INNER JOIN #NSEFOPOBANK B WITH(NOLOCK) ON B.BANKID=M.BANKID  
  WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID  AND ISNUMERIC(M.BANKID)=1    
    
 DROP TABLE #NSEFOMULTIBANKID  
DROP TABLE #NSEFOPOBANK       
   --NSXFO  
       
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #NSXFOMULTIBANKID FROM [AngelFO].ACCOUNTCURFO.DBO.MULTIBANKID  WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #NSXFOPOBANK FROM AngelFO.NSECURFO.DBO.POBANK WITH(NOLOCK)     
   
 CREATE NONCLUSTERED INDEX IDX_NSXFOMULTIBANKID ON #NSXFOMULTIBANKID(BANKID)   
  CREATE NONCLUSTERED INDEX IDX_NSXFOPOBANK ON #NSXFOPOBANK(BANKID)            
                
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #NSXFO              
FROM              
#NSXFOMULTIBANKID M WITH(NOLOCK)  INNER JOIN  
#NSXFOPOBANK B WITH(NOLOCK) ON B.BANKID=M.BANKID           
 WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID   
  DROP TABLE #NSXFOMULTIBANKID  
DROP TABLE #NSXFOPOBANK   
                
 -- MCXFO  
   
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #MCXFOMULTIBANKID FROM [AngelCommodity].ACCOUNTMCDX.DBO.MULTIBANKID  WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #MCXFOPOBANK FROM [AngelCommodity].MCDX.DBO.POBANK  WITH(NOLOCK)     
   
 CREATE NONCLUSTERED INDEX IDX_MCXFOMULTIBANKID ON #MCXFOMULTIBANKID(BANKID)   
 CREATE NONCLUSTERED INDEX IDX_MCXFOPOBANK ON #MCXFOPOBANK(BANKID)      
                 
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO  INTO #MCXFO              
              
FROM #MCXFOMULTIBANKID M WITH(NOLOCK)   
  
INNER JOIN  #MCXFOPOBANK B WITH(NOLOCK)  
ON M.BANKID=B.BANKID  WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID             
                
  DROP TABLE #MCXFOMULTIBANKID  
DROP TABLE #MCXFOPOBANK           
  -- NCXFO  
    
 SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #NCXFOMULTIBANKID FROM [AngelCommodity].ACCOUNTNCDX.DBO.MULTIBANKID  WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #NCXFOPOBANK FROM [AngelCommodity].NCDX.DBO.POBANK WITH(NOLOCK)     
   
 CREATE NONCLUSTERED INDEX IDX_NCXFOMULTIBANKID ON #NCXFOMULTIBANKID(BANKID)   
 CREATE NONCLUSTERED INDEX IDX_NCXFOPOBANK ON #NCXFOPOBANK(BANKID)  
                
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #NCXFO              
FROM #NCXFOMULTIBANKID M WITH(NOLOCK) INNER JOIN  
  #NCXFOPOBANK B WITH(NOLOCK) ON M.BANKID=B.BANKID WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID              
                
    DROP TABLE #NCXFOMULTIBANKID  
DROP TABLE #NCXFOPOBANK                         
  -- MCDFO   
    
SELECT CLTCODE AS CL_CODE,ACCNO,BANKID INTO #MCDFOMULTIBANKID FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.MULTIBANKID WITH(NOLOCK)  
  
SELECT BANKID,BANK_NAME,BRANCH_NAME,MICRNO INTO #MCDFOPOBANK FROM [AngelCommodity].MCDXCDS.DBO.POBANK  WITH(NOLOCK)     
   
 CREATE NONCLUSTERED INDEX IDX_MCDFOMULTIBANKID ON #MCDFOMULTIBANKID(BANKID)   
 CREATE NONCLUSTERED INDEX IDX_MCDFOPOBANK ON #MCDFOPOBANK(BANKID)  
    
               
SELECT CL_CODE,M.ACCNO,B.BANK_NAME,B.BRANCH_NAME,B.MICRNO INTO #MCDFO              
FROM #MCDFOMULTIBANKID M WITH(NOLOCK)   
INNER JOIN #MCDFOPOBANK B WITH(NOLOCK) ON M.BANKID=B.BANKID WHERE B.BANKID=B.BANKID AND M.BANKID=M.BANKID              
   
    DROP TABLE #MCDFOMULTIBANKID  
DROP TABLE #MCDFOPOBANK              
     
  CREATE NONCLUSTERED INDEX IDX_NSE ON #NSE(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_BSE ON #BSE(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_NSEFO ON #NSEFO(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_NSXFO ON #NSXFO(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_MCXFO ON #MCXFO(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_NCXFO ON #NCXFO(CL_CODE)     
  CREATE NONCLUSTERED INDEX IDX_MCDFO ON #MCDFO(CL_CODE)                
  CREATE NONCLUSTERED INDEX IDX_CLIENTRTGSDETAILS ON #CLIENTRTGSDETAILS(CL_CODE)     
      
      
--   DROP TABLE #TEMPMULTIBANKDETAILS             
SELECT * INTO #TEMPMULTIBANKDETAILS  FROM                
(                
 SELECT * FROM #NSE WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #BSE WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #NSEFO WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #NSXFO WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #MCXFO WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #NCXFO WHERE CL_CODE=CL_CODE UNION                
 SELECT * FROM #MCDFO WHERE CL_CODE=CL_CODE UNION    
 SELECT * FROM #CLIENTRTGSDETAILS  WHERE CL_CODE=CL_CODE               
) F1                
      
      
      
SELECT DISTINCT CL_CODE INTO #ACTIVE_CLIENT    
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS WITH(NOLOCK)   
--WHERE INACTIVE_FROM>GETDATE()    
    
CREATE NONCLUSTERED INDEX IDX_ACTIVE_CLIENT ON #ACTIVE_CLIENT(CL_CODE)    
    
  
SELECT A.* INTO #CLIENTRTGSDETAILS_FIN FROM  #CLIENTRTGSDETAILS A  
INNER JOIN #ACTIVE_CLIENT B  
ON A.CL_CODE=B.CL_CODE WHERE A.CL_CODE=A.CL_CODE AND B.CL_CODE=B.CL_CODE  
   
    
 SELECT A.* INTO #TEMPMULTIBANKDETAILS_FIN FROM  #TEMPMULTIBANKDETAILS A  
INNER JOIN #ACTIVE_CLIENT B  
ON A.CL_CODE=B.CL_CODE WHERE A.CL_CODE=A.CL_CODE AND B.CL_CODE=B.CL_CODE  
   
 CREATE NONCLUSTERED INDEX IDX_CLIENTRTGSDETAILS_FIN ON #CLIENTRTGSDETAILS_FIN(CL_CODE)  
  CREATE NONCLUSTERED INDEX IDX_TEMPMULTIBANKDETAILS_FIN ON #TEMPMULTIBANKDETAILS_FIN(CL_CODE)     
  
      
 UPDATE #TEMPMULTIBANKDETAILS_FIN SET ACCNO=LTRIM(RTRIM(ACCNO)),    
 CL_CODE=LTRIM(RTRIM(CL_CODE)),BANK_NAME=LTRIM(RTRIM(BANK_NAME)),BRANCH_NAME=LTRIM(RTRIM(BRANCH_NAME)),MICRNO=LTRIM(RTRIM(MICRNO))     
 WHERE CL_CODE=CL_CODE    
     
 ;WITH CTE AS    
 (    
  SELECT row_number() OVER (PArtition by  CL_CODE,ACCNO ORDER BY CL_CODE ) AS SNO ,* FROM    
  #TEMPMULTIBANKDETAILS_FIN WHERE CL_CODE=CL_CODE    
 )     
     
     
 SELECT * INTO #TEMPMULTIBANKDETAILS_FINAL FROM CTE WHERE SNO=1    
     
 UPDATE #TEMPMULTIBANKDETAILS_FINAL SET BANK_NAME=LEFT(LTRIM(RTRIM(BANK_NAME)),100) WHERE LEN(LTRIM(RTRIM(BANK_NAME)))>100 AND CL_CODE=CL_CODE    
 UPDATE #TEMPMULTIBANKDETAILS_FINAL SET BRANCH_NAME=LEFT(LTRIM(RTRIM(BRANCH_NAME)),50) WHERE LEN(LTRIM(RTRIM(BRANCH_NAME)))>50 AND CL_CODE=CL_CODE    
 UPDATE #TEMPMULTIBANKDETAILS_FINAL SET MICRNo=LEFT(LTRIM(RTRIM(MICRNo)),10) WHERE LEN(LTRIM(RTRIM(MICRNo)))>10 AND CL_CODE=CL_CODE    
 UPDATE #TEMPMULTIBANKDETAILS_FINAL SET ACCNO=LEFT(LTRIM(RTRIM(ACCNO)),20) WHERE LEN(LTRIM(RTRIM(ACCNO)))>20 AND CL_CODE=CL_CODE    
     
TRUNCATE TABLE stgtbl_ClientBankDet    
    
INSERT INTO stgtbl_ClientBankDet    
(    
  ClientCode,BankName,BranchName,MICRNo,AccountNo    
)    
     
 SELECT CL_CODE,BANK_NAME,BRANCH_NAME,MICRNO,ACCNO FROM #TEMPMULTIBANKDETAILS_FINAL WHERE CL_CODE=CL_CODE    
    
DROP TABLE #ACTIVE_CLIENT    
DROP TABLE #BSE    
DROP TABLE #CLIENTRTGSDETAILS    
DROP TABLE #MCDFO    
DROP TABLE #MCXFO    
DROP TABLE #NCXFO    
DROP TABLE #NSE    
DROP TABLE #NSEFO    
DROP TABLE #NSXFO    
DROP TABLE #TEMPMULTIBANKDETAILS    
DROP TABLE #TEMPMULTIBANKDETAILS_FINAL   
DROP TABLE #CLIENTRTGSDETAILS_FIN  
DROP TABLE #TEMPMULTIBANKDETAILS_FIN   
    
--SELECT * FROM [172.31.16.59].LIVEANGEL_FUNDINGSYSTEM_NEW.    
  
  
  
/* -----------Code for mail alert-------------*/  
  
DECLARE @COUNT INT  
DECLARE @COUNT1  varchar(10)   
  
DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                    
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)     
  
SELECT @COUNT = COUNT(ClientCode) FROM stgtbl_ClientBankDet with(nolock)  
  
--SELECT @COUNT AS CLIENTCODE  
SET @COUNT1 = @COUNT  
  
DECLARE @DATE VARCHAR(12)  
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))  
  
                
  
SET @S1 = 'SOS Alert For process SPX_STGTBL_CLIENTBANKDET on date '+@DATE+''  
  
set @mess='Dear ALL<br><br>                                      
                                      
 The process SPX_STGTBL_CLIENTBANKDET has been updated '+@COUNT1+' record into stgtbl_ClientBankDet for date '+@DATE+'                                        
                    
<br> <br>                                  
by SOS process.'                                                         
 set @email='manish.shukla@angelbroking.com'                     
 --set @email='amit.s@angelbroking.com'                                                                                                           
exec msdb.dbo.sp_send_dbmail                                                                                                                           
@recipients  = @email,                                                                                                               
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                               
@profile_name = 'KYC',                                                                                                                                  
@body_format ='html',                                                              
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                      
--@file_attachments =@attach,                                                                                                                                                               
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_Stgtbl_ClientDetails_Broking
-- --------------------------------------------------
  
 -- select * from SOS_STGTBL_CLIENTDETAILS_BROKING        
CREATE PROCEDURE [dbo].[SPX_Stgtbl_ClientDetails_Broking]  
AS  
BEGIN  
  
   select * into #BranchDetails from ANAND1.MSAJAG.DBO.BRANCH b WITH (NOLOCK)  
  
 SELECT CL_CODE, PAN_GIR_NO, c.LONG_NAME, SHORT_NAME, DOB, SEX, CL_STATUS AS UCC_client_category,  
  ISNULL(L_ADDRESS1, 'NA') AS L_ADDRESS1, ISNULL(L_ADDRESS2, 'NA') AS L_ADDRESS2, ISNULL(L_ADDRESS3, 'NA') AS L_ADDRESS3,  
   ISNULL(L_CITY, 'city') AS L_CITY, ISNULL(L_STATE, 'State') AS L_STATE, ISNULL(L_NATION, 'country') AS L_NATION,  
    ISNULL(L_ZIP, 'NA') AS L_ZIP, ISNULL(P_ADDRESS1, 'NA') AS P_ADDRESS1, ISNULL(P_ADDRESS2, 'NA') AS P_ADDRESS2,   
    ISNULL(P_ADDRESS3, 'NA') AS P_ADDRESS3, ISNULL(P_CITY, 'city') AS P_CITY, ISNULL(P_STATE, 'State') AS P_STATE, ISNULL(P_NATION, 'country') AS P_NATION,   
    ISNULL(P_ZIP, 'NA') AS P_ZIP, SPACE(50) AS INCOME, SEBI_REGN_NO, PASSPORT_NO, PASSPORT_ISSUED_AT,   
    PASSPORT_ISSUED_ON, PASSPORT_EXPIRES_ON, FAMILY, BRANCH_CD, b.Branch AS BRANCH_NAME, SUB_BROKER,   
    SPACE(200) AS SBNAME, SPACE(20) AS Sub_PAN, SPACE(200) AS Introducer_Code, SPACE(200) AS Introducer_Name,   
    SPACE(50) AS Introducer_PAN, SPACE(300) AS FirstName, SPACE(300) AS MidName, SPACE(300) AS LastName, SPACE(15) AS Dealer, SPACE(100) AS DealerName, SPACE(50) AS DealerPAN, SPACE(15) AS RMCode, SPACE(150) AS RMName, SPACE(  
   50) AS RMPAN  
 INTO #ClientDetails_Broking  
 FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS c WITH (NOLOCK)  
 LEFT JOIN #BranchDetails b WITH (NOLOCK) ON c.branch_cd = b.BRANCH_CODE  
   
   
 delete from #ClientDetails_Broking where cl_code in ('ERROR','V45580')  
  
 --CREATE INDEX IDX_SOSCLIENT ON #ClientDetails_Broking(CL_CODE)          
 -- insert all data for ETT        
 TRUNCATE TABLE TBL_TEMPCLIENTDETAILSFOR_ETT  
  
 INSERT INTO TBL_TEMPCLIENTDETAILSFOR_ETT (CLIENTID, CLIENTNAME, PAN)  
 SELECT CL_CODE, LEFT(LTRIM(RTRIM(LONG_NAME)), 200), LEFT(LTRIM(RTRIM(PAN_GIR_NO)), 20)  
 FROM #CLIENTDETAILS_BROKING  
  
 ALTER TABLE #ClientDetails_Broking ADD LASTTRADEDDATE DATETIME --01:42     
  
 --CREATE INDEX IDX_SOSCLIENT ON #ClientDetails_Broking_FIN(CL_CODE,BRANCH_CD,SUB_BROKER)        
 UPDATE #ClientDetails_Broking  
 SET FirstName = SUBSTRING(Long_Name, 1, CASE   
    WHEN CHARINDEX(' ', Long_Name) = 0  
     THEN len(Long_Name)  
    ELSE CHARINDEX(' ', Long_Name)  
    END), MidName = REPLACE(SUBSTRING(Long_Name, CASE   
     WHEN CHARINDEX(' ', Long_Name) = 0  
      THEN len(Long_Name)  
     ELSE CHARINDEX(' ', Long_Name)  
     END + 1, LEN(Long_Name)), REVERSE(SUBSTRING(REVERSE(Long_Name), 1, CHARINDEX(' ', REVERSE(Long_Name)))), ''), LastName = REVERSE(SUBSTRING(REVERSE(Long_Name), 1, CHARINDEX(' ', REVERSE(Long_Name)))) --01;00  
  
 UPDATE #ClientDetails_Broking  
 SET MidName = ''  
 WHERE ltrim(rtrim(MidName)) = ltrim(rtrim(LastName)) --    00:57   
  
 --SELECT BRANCH_CODE,BRANCH INTO #BRANCH FROM ANAND1.MSAJAG.DBO.BRANCH WITH(NOLOCK)     --00:57     
 --CREATE INDEX IDX_BRANCH ON #BRANCH(BRANCH_CODE)          
 --UPDATE #ClientDetails_Broking SET BRANCH_NAME=BRANCH FROM #BRANCH where #ClientDetails_Broking.branch_cd=#BRANCH.BRANCH_CODE         
 SELECT SBTAG, SBNAME, left(ltrim(rtrim(PANNO)), 10) AS PanNo  
 INTO #TEMPSBDETAILS  
 FROM SB_COMP.DBO.VW_PR_TAG_DETAILS WITH (NOLOCK)  
  
 UPDATE #ClientDetails_Broking  
 SET SBNAME = #TEMPSBDETAILS.SBNAME, Sub_PAN = PANNO  
 FROM #TEMPSBDETAILS  
 WHERE SUB_BROKER = SBTAG  
      
      
 SELECT DISTINCT C.party_code, Fld_Income, Fld_Introducer  
 INTO #INTROINTRODUCER  
 FROM kyc.dbo.client_inwardregister C WITH (NOLOCK)  
 INNER JOIN kyc.dbo.tbl_kyc_inward T WITH (NOLOCK) ON C.BrId = T.Fld_SrNo  
 WHERE ISNULL(C.BrId, 0) <> 0  
  AND ISNULL(C.party_code, '') <> ''  
  AND C.party_code NOT LIKE 'OBJ%'  
    
    
  --select Party_Code,GrossInCome into #InComeDetails from  Anand1.Msajag.dbo.V_INCOME_SOS with(Nolock)  
    
  --Update #INTROINTRODUCER set Fld_Income= a.GrossInCome from #InComeDetails a  
  --where #INTROINTRODUCER.Party_Code=a.Party_Code  
    
    
    
    
  --drop table #InComeDetails  
    
  
 CREATE INDEX IDX_KYCDATA ON #INTROINTRODUCER (party_code)  
  
 UPDATE #ClientDetails_Broking  
 SET Introducer_Code = Fld_Introducer, INCOME = isnull(Fld_Income, 'NA')  
 FROM #INTROINTRODUCER  
 WHERE CL_CODE = party_code  
  
 SELECT EMP_NO, EMP_NAME, PANNO  
 INTO #HARMONY  
 FROM [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL WITH (NOLOCK)  
  
 CREATE INDEX IDX_HRDATA ON #HARMONY (EMP_NO)  
  
 UPDATE #HARMONY  
 SET PANNO = LEFT(LTRIM(RTRIM(PANNO)), 10)  
 WHERE LEN(LTRIM(RTRIM(PANNO))) > 10  
  
 UPDATE #ClientDetails_Broking  
 SET Introducer_Name = EMP_NAME, Introducer_PAN = PANNO  
 FROM #HARMONY  
 WHERE Introducer_Code = EMP_NO  
  AND isnull(Introducer_Code, '') <> ''  
  AND LEN(PANNO) <= 50  
  
 CREATE TABLE #LASTTRADE (PARTY_CODE VARCHAR(15), LASTTRADE DATETIME)  
   
 SELECT CL_CODE AS PARTY_CODE,COMB_LAST_DATE INTO #LASTDATEFROMRISK  
 FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WITH(NOLOCK)   
  
 INSERT INTO #LASTTRADE(PARTY_CODE,LASTTRADE)  
 SELECT PARTY_CODE,COMB_LAST_DATE FROM #LASTDATEFROMRISK with(Nolock)  
   
 -- code commented and above code added by amit on 22/03/2016 for optimization  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANAND.BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 --INSERT INTO #LASTTRADE  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANAND1.MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 --INSERT INTO #LASTTRADE  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANGELFO.NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 --INSERT INTO #LASTTRADE  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANGELCOMMODITY.BSEFO.DBO.BFOBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 --INSERT INTO #LASTTRADE  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANGELCOMMODITY.MCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 --INSERT INTO #LASTTRADE  
 --SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 --FROM ANGELCOMMODITY.NCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 --GROUP BY PARTY_CODE  
  
 SELECT PARTY_CODE, MAX(LASTTRADE) AS LASTTRADE  
 INTO #LASTTRADE_FINAL  
 FROM #LASTTRADE  
 GROUP BY PARTY_CODE  
  
 CREATE INDEX IDX_LASTTRADE ON #LASTTRADE_FINAL (PARTY_CODE)  
  
    
 UPDATE #ClientDetails_Broking  
 SET LASTTRADEDDATE = LASTTRADE  
 FROM #LASTTRADE_FINAL  
 WHERE #ClientDetails_Broking.Cl_Code = #LASTTRADE_FINAL.PARTY_CODE  
  
 -- code for dealer updation        
 SELECT DISTINCT *  
 INTO #Dealer  
 FROM (  
  SELECT ClientCode, Dealer, DealerName, 'EQ' AS SEGMENT  
  FROM [196.1.115.207].inhouse.dbo.V_EquityClients_ForPML WITH (NOLOCK)  
    
  UNION  
    
  SELECT ClientCode, Dealer, DealerName, 'COM' AS SEGMENT  
  FROM [196.1.115.207].inhouse.dbo.V_CommodityClients_ForPML WITH (NOLOCK)  
    
  UNION  
    
  SELECT ClientCode, Dealer, DealerName, 'CUR' AS SEGMENT  
  FROM [196.1.115.207].inhouse.dbo.V_CurrencyClients_ForPML WITH (NOLOCK)  
  ) f  
  
 CREATE NONCLUSTERED INDEX IDX_Dealer ON #Dealer (ClientCode, Dealer)  
  
 DELETE  
 FROM #Dealer  
 WHERE Dealer = 'UNDEFINED'  
  
 SELECT a.*, b.PanNo  
 INTO #DealerFin  
 FROM #Dealer a WITH (NOLOCK)  
 LEFT JOIN #HARMONY b WITH (NOLOCK) ON a.Dealer = b.Emp_No  
  
 SELECT clientcode  
 INTO #Duplicate  
 FROM #DealerFin  
 GROUP BY clientcode  
 HAVING COUNT(clientcode) > 1  
  
 SELECT *  
 INTO #DealerFinDuplicate  
 FROM #DealerFin  
 WHERE clientcode IN (  
   SELECT clientcode  
   FROM #DealerFin  
   WHERE DEALER = DEALER  
   )  
  
 DELETE  
 FROM #DealerFin  
 WHERE clientcode IN (  
   SELECT clientcode  
   FROM #Duplicate  
   )  
  
 UPDATE #DealerFin  
 SET Dealer = LEFT(LTRIM(RTRIM(Dealer)), 15)  
 WHERE LEN(LTRIM(RTRIM(Dealer))) > 15  
  AND DEALER = DEALER  
  
 UPDATE #DealerFin  
 SET DealerName = LEFT(LTRIM(RTRIM(DealerName)), 100)  
 WHERE LEN(LTRIM(RTRIM(DealerName))) > 100  
  AND DEALER = DEALER  
  
 UPDATE #DealerFin  
 SET PanNo = LEFT(LTRIM(RTRIM(PanNo)), 50)  
 WHERE LEN(LTRIM(RTRIM(PanNo))) > 50  
  AND DEALER = DEALER  
  
 UPDATE #DealerFinDuplicate  
 SET Dealer = LEFT(LTRIM(RTRIM(Dealer)), 15)  
 WHERE LEN(LTRIM(RTRIM(Dealer))) > 15  
  AND DEALER = DEALER  
  
 UPDATE #DealerFinDuplicate  
 SET DealerName = LEFT(LTRIM(RTRIM(DealerName)), 100)  
 WHERE LEN(LTRIM(RTRIM(DealerName))) > 100  
  AND DEALER = DEALER  
  
 UPDATE #DealerFinDuplicate  
 SET PanNo = LEFT(LTRIM(RTRIM(PanNo)), 50)  
 WHERE LEN(LTRIM(RTRIM(PanNo))) > 50  
  AND DEALER = DEALER  
  
 UPDATE #ClientDetails_Broking  
 SET dealer = a.Dealer, DealerName = a.DealerName, DealerPAN = a.PANNo  
 FROM #DealerFin a  
 WHERE clientcode = CL_CODE  
  
 UPDATE #ClientDetails_Broking  
 SET dealer = a.Dealer, DealerName = a.DealerName, DealerPAN = a.PANNo  
 FROM #DealerFinDuplicate a  
 WHERE clientcode = CL_CODE  
  AND SEGMENT = 'EQ'  
  
 UPDATE #ClientDetails_Broking  
 SET dealer = a.Dealer, DealerName = a.DealerName, DealerPAN = a.PANNo  
 FROM #DealerFinDuplicate a  
 WHERE clientcode = CL_CODE  
  AND SEGMENT = 'COM'  
  AND isnull(#ClientDetails_Broking.Dealer, '') = ''  
  
 UPDATE #ClientDetails_Broking  
 SET dealer = a.Dealer, DealerName = a.DealerName, DealerPAN = a.PANNo  
 FROM #DealerFinDuplicate a  
 WHERE clientcode = CL_CODE  
  AND isnull(#ClientDetails_Broking.Dealer, '') = ''  
  
 --drop table #RmDetails     
   
 select * into #Region from Anand1.Msajag.dbo.region With(Nolock)   
      
 SELECT a.reg_code, ltrim(rtrim(b.Branch_code)) AS Branch_code, ltrim(rtrim(RmEmpNo)) AS RmEmpNo, SPACE(100) AS RmName, SPACE(50) AS RmPan  
 INTO #RmDetails  
 FROM tbl_SOSRmDetails a With(Nolock)  
 LEFT JOIN #Region b WITH (NOLOCK) ON ltrim(rtrim(a.Reg_code)) = ltrim(rtrim(b.RegionCode))  
  
 CREATE INDEX IDX_RmDetails ON #RmDetails (Branch_code)  
  
 UPDATE #RmDetails  
 SET RmName = CASE   
   WHEN len(EMP_NAME) > 100  
    THEN left(Emp_Name, 100)  
   ELSE EMP_NAME  
   END, RmPan = CASE   
   WHEN len(PANNO) > 10  
    THEN left(PANNO, 10)  
   ELSE PANNO  
   END  
 FROM #HARMONY a  
 WHERE ltrim(rtrim(a.emp_no)) = ltrim(rtrim(RmEmpNo))  
  
 --select * from  #RmDetails inner join #HARMONY a on a.emp_no=RmEmpNo        
 UPDATE #RmDetails  
 SET RmEmpNo = LEFT(LTRIM(RTRIM(RmEmpNo)), 15)  
 WHERE LEN(LTRIM(RTRIM(RmEmpNo))) > 15  
  
 --UPDATE #RmDetails SET RMName=LEFT(LTRIM(RTRIM(RMName)),100) WHERE LEN(LTRIM(RTRIM(RMName)))>100         
 --UPDATE #RmDetails SET RMPAN=LEFT(LTRIM(RTRIM(RMPAN)),10) WHERE LEN(LTRIM(RTRIM(RMPAN)))>10         
 UPDATE #ClientDetails_Broking  
 SET RMCode = b.RmEmpNo, RmName = b.RmName, RmPan = b.RmPan  
 FROM #RmDetails b  
 WHERE ltrim(rtrim(b.branch_code)) = ltrim(rtrim(#ClientDetails_Broking.BRANCH_CD))  
  
 --SELECT DISTINCT BRANCH_CD FROM #ClientDetails_Broking WHERE RMCODE IS NULL        
 TRUNCATE TABLE Stgtbl_ClientDetails_Broking  
  
 INSERT INTO Stgtbl_ClientDetails_Broking (CashUCC, FNOUcc, CashBO, PAN, UID, NAME, FirstName, MiddleName, LastName, DOB, Gender,
  UCCCategory, C_Add1, C_Add2, C_Add3, C_Town, C_City, C_State, C_Country, C_Pin, P_Add1, P_Add2, P_Add3, P_Town, P_City, P_State,
   P_Country, P_Pin, IncomeRange, SEBIRegnNo, PassportNo, PassportCountry, IssueDate, ExpiryDate, FamilyCode, BranchCode, BranchName, 
   SubBrokerCode, SubBrokerName, SubBrokerPAN, IntroducerCode, IntroducerName, IntroducerPAN, LstTradeDt, DealerCode, DealerName,
    DealerPAN, RMCode, RMName, RMPAN)  
    
 SELECT left(CL_CODE, 12), left(CL_CODE, 12), left(CL_CODE, 12), left(PAN_GIR_NO, 10), NULL, left(LONG_NAME, 100), left(FirstName, 50), left(MidName, 50), 
 left(LastName, 50), DOB, left(SEX, 10), left(UCC_CLIENT_CATEGORY, 10), left(L_ADDRESS1, 100), left(L_ADDRESS2, 100),
  left(L_ADDRESS3, 100), left(L_CITY, 50), left(L_CITY, 50), left(L_STATE, 50),
 left(L_NATION, 50), left(L_ZIP, 15), left(P_ADDRESS1, 100), left(P_ADDRESS2, 100), left(P_ADDRESS3, 100), left(P_CITY, 50), 
 left(P_CITY, 50), left(P_STATE, 50),
 left(P_NATION, 50), left(P_ZIP, 15), left(INCOME, 50), left(SEBI_REGN_NO, 25), left(PASSPORT_NO, 25), left(PASSPORT_ISSUED_AT, 25),
  PASSPORT_ISSUED_ON, PASSPORT_EXPIRES_ON, left(FAMILY, 15), left(BRANCH_CD, 15), left(BRANCH_NAME, 100), left(SUB_BROKER, 15), 
  left(SBNAME, 100), left(Sub_PAN, 10), left(Introducer_Code, 15), left(Introducer_Name, 100), left(Introducer_PAN, 10),LASTTRADEDDATE,
 dealer, DealerName, DealerPAN, RMCode, RMName, RMPAN  
 FROM #ClientDetails_Broking  
  
 SELECT Party_Code,NET_WORTH as allexch_final_limitvalue  
 INTO #limitvalue  
    -- Dat sourece has beben changed from inhouse to BO as rewquested by Fareed on 29/02/2016  
 from [196.1.115.196].MSAJAG.dbo.Client_master_ucc_data with(Nolock)  
    --FROM [196.1.115.239].inhouse.dbo.Clientwise_Limit b  
  
 UPDATE Stgtbl_ClientDetails_Broking  
 SET NetworthRange = cast(allexch_final_limitvalue AS CHAR)  
 FROM #limitvalue b  
 WHERE Stgtbl_ClientDetails_Broking.cashucc = b.party_code  
  
 DROP TABLE #limitvalue  
  
 --- Data Updation Of ETT Server for client details        
 EXEC [172.31.16.28].AngelInhouse.dbo.Spx_GetDumpForClientDetailsFromSOS  
  
 --- Data Updation Of ETT Server for Employee details        
 EXEC [172.31.16.28].AngelInhouse.dbo.Spx_GetDumpForEmployeeDetailsFrom_Middleware  
  
 -- update Sebi Banned Details        
 EXEC Spx_UpdateSebibannedDetails  
  
 DROP TABLE #ClientDetails_Broking  
  
 DROP TABLE #DealerFinDuplicate  
  
 DROP TABLE #Dealer  
  
 DROP TABLE #DealerFin  
  
 DROP TABLE #Duplicate  
  
 DROP TABLE #HARMONY  
  
 DROP TABLE #INTROINTRODUCER  
  
 DROP TABLE #LASTTRADE  
 drop table #LASTDATEFROMRISK  
  
 DROP TABLE #LASTTRADE_FINAL  
  
 DROP TABLE #TEMPSBDETAILS  
  
 /* -----------Code for mail alert-------------*/  
 DECLARE @COUNT INT  
 DECLARE @COUNT1 VARCHAR(10)  
 DECLARE @S AS VARCHAR(1000), @S1 AS VARCHAR(1000)  
 DECLARE @EMAIL VARCHAR(2000), @MESS AS VARCHAR(4000)  
  
 SELECT @COUNT = COUNT(CashUCC)  
 FROM Stgtbl_ClientDetails_Broking WITH (NOLOCK)  
  
 --SELECT @COUNT AS CLIENTCODE        
 SET @COUNT1 = @COUNT  
  
 DECLARE @DATE VARCHAR(12)  
  
 SET @DATE = (  
   SELECT CONVERT(VARCHAR(12), GETDATE(), 103)  
   )  
 SET @S1 = 'SOS Alert For process SPX_Stgtbl_ClientDetails_Broking on date ' + @DATE + ''  
 SET @mess = 'Dear ALL<br><br>                                            
                                            
 The process SPX_Stgtbl_ClientDetails_Broking has been updated ' + @COUNT1 + ' record into Stgtbl_ClientDetails_Broking for date ' + @DATE + '                                              
                          
<br> <br>                                        
by SOS process.'  
 SET @email = 'amit.s@angelbroking.com'  
  
 --set @email='amit.s@angelbroking.com'                                                                                                                 
 EXEC msdb.dbo.sp_send_dbmail @recipients = @email, @copy_recipients = 'amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',  
  --@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                  
  @profile_name = 'KYC', @body_format = 'html', @subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                            
  --@file_attachments =@attach,                                                                                                                                                                     
  @body = @mess  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_stgtbl_ClientDPDet
-- --------------------------------------------------
  
 ---select * from  stgtbl_ClientDPDet where DPName like '%Unknown%'  
    
        
    
--SELECT * FROM stgtbl_ClientDPDet WHERE DPID<>'12033200'    
CREATE proc [dbo].[SPX_stgtbl_ClientDPDet]    
    
as    
    
SELECT * INTO #NSEBANK from [196.1.115.196].msajag.dbo.bANK WITH(NOLOCK)  
    
SELECT * INTO #BSEBANK from [196.1.115.201].bsedb_AB.dbo.bANK WITH(NOLOCK)   
    
SELECT CL_CODE,BRANCH_CD INTO #CLIENTDETAILS FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)    
    
    
select PARTY_code,cltdpNo as DPID,DpId as DpId1,DpType as Depository1    
into #NSEDPDETAILS       
from [196.1.115.197].msajag.dbo.multicltid WITH(NOLOCK)    
where cltdpNo<>'16921208' and dpid<>'IN301549'  
and DPTYPE IN ('CDSL','NSDL') and ISNULL(party_code,'')<>'' and cltdpno<>'12033200'   
  
    
SELECT A.*,BANKNAME INTO #NSEDP FROM #NSEDPDETAILS A LEFT OUTER JOIN     
#NSEBANK B WITH(NOLOCK)    
ON A.DPID1=B.BANKID    
       
select PARTY_code,cltdpNo as DPID,DpId as DpId1,DpType as Depository1    
INTO #BSEDPDETAILS         
from [196.1.115.197].bsedb.dbo.multicltid WITH(NOLOCK)    
where cltdpNo<>'16921208' and dpid<>'IN301549'  and DPTYPE IN ('CDSL','NSDL') and ISNULL(party_code,'')<>''  and cltdpno<>'12033200'  
    
SELECT A.*,BANKNAME INTO #BSEDP FROM #NSEDPDETAILS A LEFT OUTER JOIN     
#BSEBANK B WITH(NOLOCK)    
ON A.DPID1=B.BANKID    
     
     
CREATE NONCLUSTERED INDEX IDX_BSEDP ON #BSEDP(PARTY_code)     
CREATE NONCLUSTERED INDEX IDX_NSEDP ON #NSEDP(PARTY_code)     
    
SELECT *,SPACE(50) AS BRANCH INTO #FINAL FROM    
(    
 SELECT * FROM #BSEDP WHERE PARTY_CODE=PARTY_CODE    
UNION    
 SELECT * FROM  #NSEDP WHERE PARTY_CODE=PARTY_CODE    
) F    
    

  delete from #FINAL where BankName ='UNKNOWN'  
    
    
SELECT DISTINCT CL_CODE INTO #ACTIVE_CLIENT    
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS WITH(NOLOCK)     
--WHERE INACTIVE_FROM>GETDATE()    
    
CREATE NONCLUSTERED INDEX IDX_ACTIVE_CLIENT ON #ACTIVE_CLIENT(CL_CODE)    
    
DELETE FROM #FINAL WHERE PARTY_CODE NOT IN (SELECT CL_CODE FROM #ACTIVE_CLIENT)    
    
    
 ;WITH CTE AS    
 (    
  SELECT row_number() OVER (PArtition by  PARTY_CODE,DPID,DPID1 ORDER BY PARTY_CODE ) AS SNO ,* FROM    
  #FINAL    
 )     
     
     
 SELECT * INTO #TEMPDP_FINAL FROM CTE WHERE SNO=1    
    
DELETE FROM #TEMPDP_FINAL WHERE SNO>1    
DELETE FROM #TEMPDP_FINAL WHERE LEN(PARTY_CODE)<3    
    
   UPDATE #TEMPDP_FINAL SET BRANCH=BRANCH_CD    
   FROM #CLIENTDETAILS C WHERE C.CL_CODE=#TEMPDP_FINAL.PARTY_CODE    
    
    
UPDATE #TEMPDP_FINAL SET BANKNAME=LEFT(LTRIM(RTRIM(BANKNAME)),100) WHERE LEN(LTRIM(RTRIM(BANKNAME)))>100    
    
    
Update #TEMPDP_FINAL set #TEMPDP_FINAL.BANKNAME=a.BankName    
    
from #NSEBANK a where a.BankId=DpId1 and ISNULL(#TEMPDP_FINAL.BANKNAME,'')=''    
    
Update #TEMPDP_FINAL set #TEMPDP_FINAL.BANKNAME=a.BankName    
    
from #BSEBANK a where a.BankId=DpId1 and ISNULL(#TEMPDP_FINAL.BANKNAME,'')=''    
    
  -- record delete as requested by fareed on 22/01/2016  
    
--Update #TEMPDP_FINAL set #TEMPDP_FINAL.BANKNAME='DP Name'+space(1)+ltrim(rtrim(DPID1))+SPACE(1)    
--where ISNULL(BANKNAME,'')=''    
delete from #TEMPDP_FINAL where ISNULL(BANKNAME,'')=''   
    
    
TRUNCATE TABLE stgtbl_ClientDPDet    
    
INSERT INTO stgtbl_ClientDPDet(    
ClientCode,    
Depository,    
DPName,    
DPID,    
BranchName,    
DPClientID)    
    
    
SELECT LTRIM(RTRIM(PARTY_CODE)),LTRIM(RTRIM(Depository1)),LTRIM(RTRIM(BANKNAME)),    
LTRIM(RTRIM(DpId1)),LTRIM(RTRIM(BRANCH)),LTRIM(RTRIM(DPID)) FROM #TEMPDP_FINAL    
    
DROP TABLE #ACTIVE_CLIENT    
DROP TABLE #BSEBANK    
DROP TABLE #BSEDP    
DROP TABLE #BSEDPDETAILS    
DROP TABLE #CLIENTDETAILS    
DROP TABLE #FINAL    
DROP TABLE #NSEBANK    
DROP TABLE #NSEDP    
DROP TABLE #NSEDPDETAILS    
DROP TABLE #TEMPDP_FINAL    
    
-- dump data into ETT database  

   
    
Select NISE_Party_Code,Client_code into #Syenrgymaster 
from [172.31.16.108].DMAT.dbo.tbl_client_master with(Nolock)    
where isnull(NISE_Party_Code,'')<>'' and isnull(Client_code,'')<>'' and len(Nise_party_code)>2    
AND ISNULL(branch_code,'')<>'pms' and status='Active'    
    
select client_code into #poa from [172.31.16.108].DMAT.dbo.tbl_client_poa with(Nolock)     
where holder_indi='1' and master_poa='2203320000000014'    
    
select a.NISE_Party_Code,a.Client_code into #Dpfinal from  #Syenrgymaster a inner join     
#poa b on a.client_code=b.client_code    
    
delete from #Dpfinal where nise_party_code in('A12200','AL5003','A12345','AL57627','AE16725','A51417')    
    
 DELETE FROM #Dpfinal WHERE NISE_PARTY_CODE IN('A12200','AL5003','A12345','AL57627','AE16725','A51417')        
         
     
 delete from #Dpfinal where ltrim(rtrim(NISE_PARTY_CODE))+ltrim(rtrim(CLIENT_CODE)) in        
(Select                        
              
ltrim(rtrim(v.Party_code))+LTRIM(RTRIM(Dp_Id))+LTRIM(RTRIM(AccountNo))                            
from [196.1.115.218].INTEGRA.dbo.vwclientdetails v with(nolock)                           
                        
where Accountno Not in ('04619583','00551327','00510609','05370789','00481184','7447075')                          
and isnull(v.Party_code,'')<>''          
)       
    
truncate table tbl_tempDpDetailFor_ETT    
    
insert into tbl_tempDpDetailFor_ETT (clientcode,DpClientId)    
    
select distinct Nise_Party_Code,Client_Code from #Dpfinal    
    
    
EXEC [172.31.16.28].ANGELINHOUSE.DBO.Spx_StagingClientDematAccount_Refresh    
    
/* -----------Code for mail alert-------------*/    
    
DECLARE @COUNT INT    
DECLARE @COUNT1  varchar(10)     
    
DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                      
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)       
    
SELECT @COUNT = COUNT(ClientCode) FROM stgtbl_ClientDPDet with(nolock)    
    
--SELECT @COUNT AS CLIENTCODE    
SET @COUNT1 = @COUNT    
    
DECLARE @DATE VARCHAR(12)    
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))    
    
                  
    
SET @S1 = 'SOS Alert For process SPX_stgtbl_ClientDPDet on date '+@DATE+''    
    
set @mess='Dear ALL<br><br>                                        
                                        
 The process SPX_stgtbl_ClientDPDet has been updated '+@COUNT1+' record into stgtbl_ClientDPDet for date '+@DATE+'                                          
                      
<br> <br>                                    
by SOS process.'                                                           
 set @email='manish.shukla@angelbroking.com'                       
 --set @email='amit.s@angelbroking.com'                                                                                                             
exec msdb.dbo.sp_send_dbmail                                                                                                                             
@recipients  = @email,                                                                                                                 
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                  
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                                 
@profile_name = 'KYC',                                                                                                                                    
@body_format ='html',                                                                
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                        
--@file_attachments =@attach,                                                                                                                                                                 
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_stgtbl_ClientMultiCategory
-- --------------------------------------------------


CREATE PROC [dbo].[Spx_stgtbl_ClientMultiCategory]
AS

SELECT CL_CODE,CL_TYPE,CL_STATUS INTO #NRI FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK) WHERE CL_STATUS='NRI'

SELECT  CL_CODE,CL_TYPE,CL_STATUS INTO #NBFC FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)
WHERE CL_TYPE IN ('NBF','SMF','TMF','DMF')  



SELECT CL_CODE INTO #ONLINE FROM INTRANET.RISK.DBO.CLIENT_DETAILS WITH(NOLOCK) WHERE ISNULL(EBROKING,'N')='Y'

TRUNCATE TABLE STGTBL_CLIENTMULTICATEGORY
INSERT INTO STGTBL_CLIENTMULTICATEGORY
(
CLIENTCODE,
CATEGORYMAINTYPE,
CATEGORYSUBTYPE
)

SELECT CL_CODE,'NBFC','NBFC' FROM #NBFC
UNION SELECT CL_CODE,'NRI','NRI' FROM #NRI
UNION SELECT CL_CODE,'ONLINE','ONLINE' FROM #ONLINE 

/* -----------Code for mail alert-------------*/

DECLARE @COUNT INT
DECLARE @COUNT1  varchar(10) 

DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                  
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)   

SELECT @COUNT = COUNT(ClientCode) FROM STGTBL_CLIENTMULTICATEGORY with(nolock)

--SELECT @COUNT AS CLIENTCODE
SET @COUNT1 = @COUNT

DECLARE @DATE VARCHAR(12)
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))

              

SET @S1 = 'SOS Alert For process Spx_stgtbl_ClientMultiCategory on date '+@DATE+''

set @mess='Dear ALL<br><br>                                    
                                    
 The process Spx_stgtbl_ClientMultiCategory has been updated '+@COUNT1+' record into STGTBL_CLIENTMULTICATEGORY for date '+@DATE+'                                      
                  
<br> <br>                                
by SOS process.'                                                       
 set @email='manish.shukla@angelbroking.com'                   
 --set @email='amit.s@angelbroking.com'                                                                                                         
exec msdb.dbo.sp_send_dbmail                                                                                                                         
@recipients  = @email,                                                                                                             
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                              
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                             
@profile_name = 'KYC',                                                                                                                                
@body_format ='html',                                                            
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                    
--@file_attachments =@attach,                                                                                                                                                             
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGTBL_CLIENTSEGMENTSTATUS
-- --------------------------------------------------
  
CREATE PROC [dbo].[SPX_STGTBL_CLIENTSEGMENTSTATUS]  
AS  
BEGIN   

	SET NOCOUNT ON
   
 CREATE TABLE #CLSGDETAILS  
 (  
  CL_CODE VARCHAR(10),  
  SEGMENT VARCHAR(7),  
  EXCHANGE VARCHAR(10),  
  ACTIVE_DATE DATETIME,  
  INACTIVE_FROM DATETIME,  
  IMP_STATUS TINYINT,  
  STATUS VARCHAR(20),  
  STATUSDATE DATETIME,  
  LstTradeDt DATETIME,
  INDEX IDX_SOSCLIENTSEG clustered (CL_CODE)  
 )   
   
 INSERT INTO #CLSGDETAILS(CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS, [STATUS], STATUSDATE)
  SELECT * FROM OPENQUERY (ANAND1, '
 SELECT CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS  
		,[STATUS] = (  
   CASE   
    WHEN (INACTIVE_FROM > GETDATE())  
     THEN ''Active''  
    ELSE ''Inactive''  
    END  
   ) ,[STATUSDATE] = (  
   CASE   
    WHEN STATUS = ''Active''  
     THEN ACTIVE_DATE  
    ELSE INACTIVE_FROM  
    END  
   )    
 FROM MSAJAG.DBO.CLIENT_BROK_DETAILS A WITH (NOLOCK)');     
  
 CREATE TABLE #LASTTRADE_rev (PARTY_CODE VARCHAR(10), LASTTRADE DATETIME)  
 INSERT INTO #LASTTRADE_rev
 SELECT * FROM OPENQUERY (ANAND, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANAND1, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELFO, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev  
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM BSEFO.DBO.BFOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM MCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM NCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE ');
  
 SELECT PARTY_CODE, MAX(LASTTRADE) AS LASTTRADE  
 INTO #LASTTRADE_FINAL_rev  
 FROM #LASTTRADE_rev  
 where ISNULL(PARTY_CODE, '') <> ''
 GROUP BY PARTY_CODE  
  
 ALTER TABLE #LASTTRADE_FINAL_rev alter column PARTY_CODE varchar(50) NOT NULL
 alter table #LASTTRADE_FINAL_rev add constraint IDX_LASTTRADE primary key clustered (PARTY_CODE) 
   
 UPDATE B  
 SET LstTradeDt = LASTTRADE  
 FROM #CLSGDETAILS B inner join #LASTTRADE_FINAL_rev A  
 on  B.CL_CODE = A.PARTY_CODE  

 UPDATE tmp
 SET --SELECT 
 		SEGMENT = CASE	WHEN (SEGMENT = 'CAPITAL' AND EXCHANGE IN ('BSE', 'NSE') /* Update 01 */ ) THEN 'CASH' 
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('BSE', 'NSE') /* Update 02 */ ) THEN 'FNO'
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('MCD', 'NSX') /* Update 03 = CURRENCY */ ) THEN 'CDS'
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('NCX', 'MCX') /* Update 04 = COMMODITY */ ) THEN 'CMD'
 						ELSE SEGMENT 
 						END
 FROM #CLSGDETAILS tmp
 WHERE (SEGMENT = 'CAPITAL' AND EXCHANGE IN ('BSE', 'NSE') /* Update 01 */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('BSE', 'NSE') /* Update 02 */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('MCD', 'NSX') /* Update 03 = CURRENCY */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('NCX', 'MCX') /* Update 04 = COMMODITY */ )
  
 TRUNCATE TABLE stgtbl_ClientSegmentStatus  
  
 INSERT INTO stgtbl_ClientSegmentStatus (ClientCode, Exchange, Segment, STATUS, StatusDt, LstTradeDt)  
 SELECT CL_CODE, 
		EXCHANGE = CASE WHEN EXCHANGE = 'NSX' THEN 'NSE'
						WHEN EXCHANGE = 'NCX' THEN 'NCDEX'
						WHEN EXCHANGE = 'MCD' THEN 'MCX-SX'
						ELSE EXCHANGE
						END, 
		SEGMENT, STATUS, STATUSDATE, LstTradeDt  
 FROM #CLSGDETAILS  
  
 DROP TABLE #CLSGDETAILS  
  
 DROP TABLE #LASTTRADE_rev  
  
 DROP TABLE #LASTTRADE_FINAL_rev  
  
 /* -----------Code for mail alert-------------*/  
 DECLARE @COUNT INT  
 DECLARE @COUNT1 VARCHAR(10)  
 DECLARE @S AS VARCHAR(1000), @S1 AS VARCHAR(1000)  
 DECLARE @EMAIL VARCHAR(2000), @MESS AS VARCHAR(4000)  
  
 SELECT @COUNT = COUNT(ClientCode)  
 FROM stgtbl_ClientSegmentStatus WITH (NOLOCK)  
  
 --SELECT @COUNT AS CLIENTCODE    
 SET @COUNT1 = @COUNT  
  
 DECLARE @DATE VARCHAR(12)  
  
 SET @DATE = (  
   SELECT CONVERT(VARCHAR(12), GETDATE(), 103)  
   )  
 SET @S1 = 'SOS Alert For process SPX_STGTBL_CLIENTSEGMENTSTATUS on date ' + @DATE + ''  
 SET @mess = 'Dear ALL<br><br>                                        
                                         
  The process SPX_STGTBL_CLIENTSEGMENTSTATUS has been updated ' + @COUNT1 + ' record into stgtbl_ClientSegmentStatus for date ' + @DATE + '                                          
                       
 <br> <br>                           
 by SOS process.'  
 SET @email = 'manish.shukla@angelbroking.com'  
  
 --set @email='amit.s@angelbroking.com'                                                                                                             
 EXEC msdb.dbo.sp_send_dbmail @recipients = @email, @copy_recipients = 'amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',  
  --@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                                 
  @profile_name = 'KYC', @body_format = 'html', @subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                        
  --@file_attachments =@attach,                                                                                                                                                                 
  @body = @mess  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGTBL_CLIENTSEGMENTSTATUS_bk_30May2022
-- --------------------------------------------------

  
  
CREATE PROC [dbo].[SPX_STGTBL_CLIENTSEGMENTSTATUS_bk_30May2022]  
AS  
BEGIN   
   
 CREATE TABLE #CLSGDETAILS  
 (  
  CL_CODE VARCHAR(10),  
  SEGMENT VARCHAR(7),  
  EXCHANGE VARCHAR(10),  
  ACTIVE_DATE DATETIME,  
  INACTIVE_FROM DATETIME,  
  IMP_STATUS TINYINT,  
  STATUS VARCHAR(20),  
  STATUSDATE DATETIME,  
  LstTradeDt DATETIME  
 )   
   
 INSERT INTO #CLSGDETAILS(CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS)  
 SELECT CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS  
 FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS A WITH (NOLOCK)  
   
 CREATE clustered INDEX IDX_SOSCLIENTSEG ON #CLSGDETAILS (CL_CODE)  
  
 UPDATE #CLSGDETAILS  
 SET STATUS = (  
   CASE   
    WHEN (INACTIVE_FROM > GETDATE())  
     THEN 'Active'  
    ELSE 'Inactive'  
    END  
   ) ,STATUSDATE = (  
   CASE   
    WHEN STATUS = 'Active'  
     THEN ACTIVE_DATE  
    ELSE INACTIVE_FROM  
    END  
   )   
     
     
  
   
  
 CREATE TABLE #LASTTRADE_rev (PARTY_CODE VARCHAR(10), LASTTRADE DATETIME)  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANAND.BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANAND1.MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANGELFO.NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANGELCOMMODITY.BSEFO.DBO.BFOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANGELCOMMODITY.MCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 INSERT INTO #LASTTRADE_rev  
 SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM ANGELCOMMODITY.NCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE  
  
 SELECT PARTY_CODE, MAX(LASTTRADE) AS LASTTRADE  
 INTO #LASTTRADE_FINAL_rev  
 FROM #LASTTRADE_rev  
 GROUP BY PARTY_CODE  
  
      
 CREATE Clustered INDEX IDX_LASTTRADE ON #LASTTRADE_FINAL_rev (PARTY_CODE)  
  
 --UPDATE #CLSGDETAILS  
 --SET LstTradeDt = LASTTRADE  
 --FROM #LASTTRADE_FINAL_rev  
 --WHERE CL_CODE = PARTY_CODE  
   
 UPDATE B  
 SET LstTradeDt = LASTTRADE  
 FROM #CLSGDETAILS B inner join #LASTTRADE_FINAL_rev A  
 on  B.CL_CODE = A.PARTY_CODE  
  
 UPDATE #CLSGDETAILS  
 SET SEGMENT = 'CASH'  
 WHERE SEGMENT = 'CAPITAL'  
  AND EXCHANGE IN ('BSE', 'NSE')  
  
 UPDATE #CLSGDETAILS  
 SET SEGMENT = 'FNO'  
 WHERE SEGMENT = 'FUTURES'  
  AND EXCHANGE IN ('BSE', 'NSE')  
  
 -- CURRENCY     
 UPDATE #CLSGDETAILS  
 SET SEGMENT = 'CDS'  
 WHERE SEGMENT = 'FUTURES'  
  AND EXCHANGE IN ('MCD', 'NSX')  
  
 -- COMMODITY    
 UPDATE #CLSGDETAILS  
 SET SEGMENT = 'CMD'  
 WHERE SEGMENT = 'FUTURES'  
  AND EXCHANGE IN ('NCX', 'MCX')  
  
 UPDATE #CLSGDETAILS  
 SET EXCHANGE = 'NSE'  
 WHERE EXCHANGE = 'NSX'  
  
 UPDATE #CLSGDETAILS  
 SET EXCHANGE = 'NCDEX'  
 WHERE EXCHANGE = 'NCX'  
  
 UPDATE #CLSGDETAILS  
 SET EXCHANGE = 'MCX-SX'  
 WHERE EXCHANGE = 'MCD'  
  
 TRUNCATE TABLE stgtbl_ClientSegmentStatus  
  
 INSERT INTO stgtbl_ClientSegmentStatus (ClientCode, Exchange, Segment, STATUS, StatusDt, LstTradeDt)  
 SELECT CL_CODE, EXCHANGE, SEGMENT, STATUS, STATUSDATE, LstTradeDt  
 FROM #CLSGDETAILS  
  
 DROP TABLE #CLSGDETAILS  
  
 DROP TABLE #LASTTRADE_rev  
  
 DROP TABLE #LASTTRADE_FINAL_rev  
  
 /* -----------Code for mail alert-------------*/  
 DECLARE @COUNT INT  
 DECLARE @COUNT1 VARCHAR(10)  
 DECLARE @S AS VARCHAR(1000), @S1 AS VARCHAR(1000)  
 DECLARE @EMAIL VARCHAR(2000), @MESS AS VARCHAR(4000)  
  
 SELECT @COUNT = COUNT(ClientCode)  
 FROM stgtbl_ClientSegmentStatus WITH (NOLOCK)  
  
 --SELECT @COUNT AS CLIENTCODE    
 SET @COUNT1 = @COUNT  
  
 DECLARE @DATE VARCHAR(12)  
  
 SET @DATE = (  
   SELECT CONVERT(VARCHAR(12), GETDATE(), 103)  
   )  
 SET @S1 = 'SOS Alert For process SPX_STGTBL_CLIENTSEGMENTSTATUS on date ' + @DATE + ''  
 SET @mess = 'Dear ALL<br><br>                                        
                                         
  The process SPX_STGTBL_CLIENTSEGMENTSTATUS has been updated ' + @COUNT1 + ' record into stgtbl_ClientSegmentStatus for date ' + @DATE + '                                          
                       
 <br> <br>                           
 by SOS process.'  
 SET @email = 'manish.shukla@angelbroking.com'  
  
 --set @email='amit.s@angelbroking.com'                                                                                                             
 EXEC msdb.dbo.sp_send_dbmail @recipients = @email, @copy_recipients = 'amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',  
  --@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                                 
  @profile_name = 'KYC', @body_format = 'html', @subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                        
  --@file_attachments =@attach,                                                                                                                                                                 
  @body = @mess  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGTBL_CLIENTSEGMENTSTATUS_TempNew
-- --------------------------------------------------
  
CREATE PROC [dbo].[SPX_STGTBL_CLIENTSEGMENTSTATUS_TempNew]  
AS  
BEGIN   
   
 CREATE TABLE #CLSGDETAILS  
 (  
  CL_CODE VARCHAR(10),  
  SEGMENT VARCHAR(7),  
  EXCHANGE VARCHAR(10),  
  ACTIVE_DATE DATETIME,  
  INACTIVE_FROM DATETIME,  
  IMP_STATUS TINYINT,  
  STATUS VARCHAR(20),  
  STATUSDATE DATETIME,  
  LstTradeDt DATETIME,
  INDEX IDX_SOSCLIENTSEG clustered (CL_CODE)  
 )   
   
 INSERT INTO #CLSGDETAILS(CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS, [STATUS], STATUSDATE)
  SELECT * FROM OPENQUERY (ANAND1, '
 SELECT CL_CODE, SEGMENT, EXCHANGE, ACTIVE_DATE, INACTIVE_FROM, IMP_STATUS  
		,[STATUS] = (  
   CASE   
    WHEN (INACTIVE_FROM > GETDATE())  
     THEN ''Active''  
    ELSE ''Inactive''  
    END  
   ) ,[STATUSDATE] = (  
   CASE   
    WHEN STATUS = ''Active''  
     THEN ACTIVE_DATE  
    ELSE INACTIVE_FROM  
    END  
   )    
 FROM MSAJAG.DBO.CLIENT_BROK_DETAILS A WITH (NOLOCK)');     
  
 CREATE TABLE #LASTTRADE_rev (PARTY_CODE VARCHAR(10), LASTTRADE DATETIME)  
 INSERT INTO #LASTTRADE_rev
 SELECT * FROM OPENQUERY (ANAND, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANAND1, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELFO, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev  
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM BSEFO.DBO.BFOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM MCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE');
  
 INSERT INTO #LASTTRADE_rev 
 SELECT * FROM OPENQUERY (ANGELCOMMODITY, 'SELECT PARTY_CODE, MAX(SAUDA_DATE)  
 FROM NCDX.DBO.FOBILLVALAN WITH (NOLOCK)  
 GROUP BY PARTY_CODE ');
  
 SELECT PARTY_CODE, MAX(LASTTRADE) AS LASTTRADE  
 INTO #LASTTRADE_FINAL_rev  
 FROM #LASTTRADE_rev  
 GROUP BY PARTY_CODE  


 
 ALTER TABLE #LASTTRADE_FINAL_rev alter column PARTY_CODE varchar(50) NOT NULL
 ALTER table #LASTTRADE_FINAL_rev add constraint IDX_LASTTRADE primary key clustered (PARTY_CODE) 
   
 UPDATE B  
 SET LstTradeDt = LASTTRADE  
 FROM #CLSGDETAILS B inner join #LASTTRADE_FINAL_rev A  
 on  B.CL_CODE = A.PARTY_CODE  

 UPDATE tmp
 SET --SELECT 
 		SEGMENT = CASE	WHEN (SEGMENT = 'CAPITAL' AND EXCHANGE IN ('BSE', 'NSE') /* Update 01 */ ) THEN 'CASH' 
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('BSE', 'NSE') /* Update 02 */ ) THEN 'FNO'
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('MCD', 'NSX') /* Update 03 = CURRENCY */ ) THEN 'CDS'
 						WHEN (SEGMENT = 'FUTURES' AND EXCHANGE IN ('NCX', 'MCX') /* Update 04 = COMMODITY */ ) THEN 'CMD'
 						ELSE SEGMENT 
 						END
 FROM #CLSGDETAILS tmp
 WHERE (SEGMENT = 'CAPITAL' AND EXCHANGE IN ('BSE', 'NSE') /* Update 01 */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('BSE', 'NSE') /* Update 02 */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('MCD', 'NSX') /* Update 03 = CURRENCY */ )
 OR (SEGMENT = 'FUTURES' AND EXCHANGE IN ('NCX', 'MCX') /* Update 04 = COMMODITY */ )
 
 --TRUNCATE TABLE stgtbl_ClientSegmentStatus  
  
 --INSERT INTO stgtbl_ClientSegmentStatus (ClientCode, Exchange, Segment, STATUS, StatusDt, LstTradeDt)  
 --SELECT CL_CODE, 
	--	EXCHANGE = CASE WHEN EXCHANGE = 'NSX' THEN 'NSE'
	--					WHEN EXCHANGE = 'NCX' THEN 'NCDEX'
	--					WHEN EXCHANGE = 'MCD' THEN 'MCX-SX'
	--					ELSE EXCHANGE
	--					END, 
	--	SEGMENT, STATUS, STATUSDATE, LstTradeDt  
 --FROM #CLSGDETAILS  
  
 DROP TABLE #CLSGDETAILS  
  
 DROP TABLE #LASTTRADE_rev  
  
 DROP TABLE #LASTTRADE_FINAL_rev  
  
 --/* -----------Code for mail alert-------------*/  
 --DECLARE @COUNT INT  
 --DECLARE @COUNT1 VARCHAR(10)  
 --DECLARE @S AS VARCHAR(1000), @S1 AS VARCHAR(1000)  
 --DECLARE @EMAIL VARCHAR(2000), @MESS AS VARCHAR(4000)  
  
 --SELECT @COUNT = COUNT(ClientCode)  
 --FROM stgtbl_ClientSegmentStatus WITH (NOLOCK)  
  
 ----SELECT @COUNT AS CLIENTCODE    
 --SET @COUNT1 = @COUNT  
  
 --DECLARE @DATE VARCHAR(12)  
  
 --SET @DATE = (  
 --  SELECT CONVERT(VARCHAR(12), GETDATE(), 103)  
 --  )  
 --SET @S1 = 'SOS Alert For process SPX_STGTBL_CLIENTSEGMENTSTATUS on date ' + @DATE + ''  
 --SET @mess = 'Dear ALL<br><br>                                        
                                         
 -- The process SPX_STGTBL_CLIENTSEGMENTSTATUS has been updated ' + @COUNT1 + ' record into stgtbl_ClientSegmentStatus for date ' + @DATE + '                                          
                       
 --<br> <br>                           
 --by SOS process.'  
 --SET @email = 'manish.shukla@angelbroking.com'  
  
 ----set @email='amit.s@angelbroking.com'                                                                                                             
 --EXEC msdb.dbo.sp_send_dbmail @recipients = @email, @copy_recipients = 'amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',  
 -- --@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                                 
 -- @profile_name = 'KYC', @body_format = 'html', @subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                        
 -- --@file_attachments =@attach,                                                                                                                                                                 
 -- @body = @mess  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_STGTBL_EMPLOYEES
-- --------------------------------------------------

CREATE PROC [dbo].[SPX_STGTBL_EMPLOYEES]
AS


SELECT * INTO #HREMPLOYEE FROM
(
SELECT DISTINCT
EC.EMP_NO,EC.EMP_NAME,EC.PANNO,EC.JOINDATE,EC.BIRTH_DT,EC.RELIEVEDATE,ED.DESIGNATION,ED.[NEW DEPARTMENT - BROKING] AS DEPARTMENT,
EC.CostCodeDefinition 

 FROM [196.1.115.237].ANGELBROKING.DBO.VU_EMPCONTACTDETAIL EC WITH(NOLOCK)
 LEFT OUTER JOIN [196.1.115.237].ANGELBROKING.DBO.VMISJOINEEEXIT_NEW ED WITH(NOLOCK)
 ON EC.EMP_NO=ED.[EMP NO]
 ) F 
 
   CREATE NONCLUSTERED INDEX IDX_HREMPLOYEE ON #HREMPLOYEE(EMP_NO) 
    
  UPDATE #HREMPLOYEE SET PANNO=LEFT(LTRIM(RTRIM(PANNO)),10) WHERE EMP_NO=EMP_NO AND LEN(LTRIM(RTRIM(PANNO)))>10
  
  UPDATE #HREMPLOYEE SET EMP_NAME=LEFT(LTRIM(RTRIM(EMP_NAME)),100) WHERE EMP_NO=EMP_NO AND LEN(LTRIM(RTRIM(EMP_NAME)))>100  
  

  UPDATE #HREMPLOYEE SET Designation=LEFT(LTRIM(RTRIM(Designation)),50) WHERE EMP_NO=EMP_NO AND LEN(LTRIM(RTRIM(Designation)))>50  
  UPDATE #HREMPLOYEE SET Department=LEFT(LTRIM(RTRIM(Department)),50) WHERE EMP_NO=EMP_NO AND LEN(LTRIM(RTRIM(Department)))>50  
  UPDATE #HREMPLOYEE SET CostCodeDefinition=LEFT(LTRIM(RTRIM(CostCodeDefinition)),20) WHERE EMP_NO=EMP_NO AND LEN(LTRIM(RTRIM(CostCodeDefinition)))>20  
    
  Update #HREMPLOYEE set Designation='Designation' where EMP_NO=EMP_NO AND isnull(Designation,'')='' 
  Update #HREMPLOYEE set DEPARTMENT='Department' where EMP_NO=EMP_NO AND isnull(DEPARTMENT,'')=''
  Update #HREMPLOYEE set PANNO='Pan' where EMP_NO=EMP_NO AND isnull(PanNo,'')=''
 
 
 TRUNCATE TABLE stgtbl_Employees
 
 
INSERT INTO stgtbl_Employees
 (
 
  EmpName,EmpPAN,EmpUID,EmpCode,EmpDOB,Designation,Department,JoinDate,RelevDate,AssociateType,AssociateCode
 
 )
 
 SELECT LTRIM(RTRIM(EMP_NAME)),LTRIM(RTRIM(PANNO)),null,LTRIM(RTRIM(EMP_NO)),
 BIRTH_DT,LTRIM(RTRIM(DESIGNATION)),LTRIM(RTRIM(DEPARTMENT)),JOINDATE,RELIEVEDATE,'BRANCH' AS ASSOCIATETYPE,
 LTRIM(RTRIM(CostCodeDefinition)) AS ASSOCITAECODE
 
 
  FROM #HREMPLOYEE
  
  DROP TABLE #HREMPLOYEE
  
  
  
  
  /* -----------Code for mail alert-------------*/

DECLARE @COUNT INT
DECLARE @COUNT1  varchar(10) 

DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                  
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)   

SELECT @COUNT = COUNT(EmpName) FROM stgtbl_Employees with(nolock)

--SELECT @COUNT AS CLIENTCODE
SET @COUNT1 = @COUNT

DECLARE @DATE VARCHAR(12)
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))

              

SET @S1 = 'SOS Alert For process SPX_STGTBL_EMPLOYEES on date '+@DATE+''

set @mess='Dear ALL<br><br>                                    
                                    
 The process SPX_STGTBL_EMPLOYEES has been updated '+@COUNT1+' record into stgtbl_Employees for date '+@DATE+'                                      
                  
<br> <br>                                
by SOS process.'                                                       
 set @email='manish.shukla@angelbroking.com'                   
 --set @email='amit.s@angelbroking.com'                                                                                                         
exec msdb.dbo.sp_send_dbmail                                                                                                                         
@recipients  = @email,                                                                                                             
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                              
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                             
@profile_name = 'KYC',                                                                                                                                
@body_format ='html',                                                            
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                    
--@file_attachments =@attach,                                                                                                                                                             
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPX_UPDATE_STGTBL_CLIENTADDRESSWITHCONTACT
-- --------------------------------------------------
  
    
--SELECT * FROM SOS_STGTBL_CLIENTADDRESS  ORDER BY [Client Code]  
    
CREATE PROC [dbo].[SPX_UPDATE_STGTBL_CLIENTADDRESSWITHCONTACT]    
AS    
    
    
    
 SELECT CL_CODE,L_ADDRESS1,  
 L_ADDRESS2,  
 L_ADDRESS3,  
  L_CITY,  
  L_STATE,  
  L_NATION,  
  L_ZIP,    
   P_ADDRESS1,  
 P_ADDRESS2,  
 P_ADDRESS3,  
 P_CITY,  
  P_STATE,  
  P_NATION,  
 P_ZIP,   
    
 RES_PHONE1,RES_PHONE2,OFF_PHONE1,OFF_PHONE2,MOBILE_PAGER,FAX,EMAIL    
 INTO #TEMPCLIENTADDRESSWITHCONTACT FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WITH(NOLOCK)    
   
  CREATE NONCLUSTERED INDEX IDX_TEMPCLIENTADDRESSWITHCONTACT ON #TEMPCLIENTADDRESSWITHCONTACT(CL_CODE)  
    
SELECT DISTINCT CL_CODE INTO #ACTIVE_CLIENT  
FROM ANAND1.MSAJAG.DBO.CLIENT_BROK_DETAILS WITH(NOLOCK)   
--WHERE INACTIVE_FROM>GETDATE()  
  
CREATE NONCLUSTERED INDEX IDX_ACTIVE_CLIENT ON #ACTIVE_CLIENT(CL_CODE)  
  
SELECT A.* INTO #TEMPCLIENTADDRESSWITHCONTACT_FIN  
 FROM #TEMPCLIENTADDRESSWITHCONTACT A   
inner join  #ACTIVE_CLIENT B ON A.CL_CODE=B.CL_CODE WHERE A.CL_CODE=A.CL_CODE AND B.CL_CODE=B.CL_CODE  
  
  CREATE NONCLUSTERED INDEX IDX_TEMPCLIENTADDRESSWITHCONTACT_FIN ON #TEMPCLIENTADDRESSWITHCONTACT_FIN(CL_CODE)  
    
    
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_ADDRESS1='NA' WHERE CL_CODE=CL_CODE AND ISNULL(L_ADDRESS1,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_ADDRESS2='NA' WHERE CL_CODE=CL_CODE AND ISNULL(L_ADDRESS2,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_ADDRESS3='NA' WHERE CL_CODE=CL_CODE AND ISNULL(L_ADDRESS3,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_CITY='city' WHERE CL_CODE=CL_CODE AND ISNULL(L_CITY,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_STATE='state' WHERE CL_CODE=CL_CODE AND ISNULL(L_STATE,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_NATION='country' WHERE CL_CODE=CL_CODE AND ISNULL(L_NATION,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET L_ZIP='NA' WHERE CL_CODE=CL_CODE AND ISNULL(L_ZIP,'')=''    
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_ADDRESS1='NA' WHERE CL_CODE=CL_CODE AND ISNULL(P_ADDRESS1,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_ADDRESS2='NA' WHERE CL_CODE=CL_CODE AND ISNULL(P_ADDRESS2,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_ADDRESS3='NA' WHERE CL_CODE=CL_CODE AND ISNULL(P_ADDRESS3,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_CITY='city' WHERE CL_CODE=CL_CODE AND ISNULL(P_CITY,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_STATE='state' WHERE CL_CODE=CL_CODE AND ISNULL(P_STATE,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_NATION='country' WHERE CL_CODE=CL_CODE AND ISNULL(P_NATION,'')=''  
 UPDATE #TEMPCLIENTADDRESSWITHCONTACT_FIN SET P_ZIP='NA' WHERE CL_CODE=CL_CODE AND ISNULL(P_ZIP,'')=''  
    
    
    
  SELECT * INTO #TEMPADDRESS FROM    
  (    
  SELECT CL_CODE as ClientCode,'Residence' AS ADDTYPE,L_ADDRESS1 AS ADD1,L_ADDRESS2 AS ADD2,L_ADDRESS3 AS ADD3  
  ,L_CITY AS TOWN,L_CITY AS CITY,L_STATE AS STATE,L_NATION AS COUNTRY,L_ZIP AS PIN   
  FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE    
  UNION     
  SELECT CL_CODE as ClientCode,'Permanent' AS ADDTYPE,P_ADDRESS1 AS ADD1,P_ADDRESS2 AS ADD2,P_ADDRESS3 AS ADD3,P_CITY AS TOWN,P_CITY AS CITY,P_STATE AS STATE,P_NATION AS COUNTRY,P_ZIP AS PIN     
  FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN  WHERE CL_CODE=CL_CODE  
  ) F     
      
  
      
        
      
  SELECT * INTO #TEMPCONTACT FROM    
  (    
   SELECT CL_CODE,'Email ID' AS CONTACT_TYPE,EMAIL FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(EMAIL,'')<>''     
   UNION     
   SELECT CL_CODE,'Fax No' AS CONTACT_TYPE,FAX FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(FAX,'')<>''    
   UNION    
   SELECT CL_CODE,'Mobile No' AS CONTACT_TYPE,MOBILE_PAGER FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(MOBILE_PAGER,'')<>''    
   UNION    
   SELECT CL_CODE,'Office Phone' AS CONTACT_TYPE,OFF_PHONE1 FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(OFF_PHONE1,'')<>''    
   UNION    
   SELECT CL_CODE,'Office Phone' AS CONTACT_TYPE,OFF_PHONE2 FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(OFF_PHONE2,'')<>''    
   UNION    
   SELECT CL_CODE,'Home Phone' AS CONTACT_TYPE,RES_PHONE1 FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(RES_PHONE1,'')<>''    
   UNION    
   SELECT CL_CODE,'Home Phone' AS CONTACT_TYPE,RES_PHONE2 FROM #TEMPCLIENTADDRESSWITHCONTACT_FIN WHERE CL_CODE=CL_CODE AND ISNULL(RES_PHONE2,'')<>''    
       
       
  ) F1  
  
  DELETE FROM #TEMPCONTACT  WHERE EMAIL='NULL'
      
    UPDATE #TEMPADDRESS SET ClientCode=LEFT(LTRIM(RTRIM(ClientCode)),20) WHERE LEN(LTRIM(RTRIM(ClientCode)))>20  
 UPDATE #TEMPADDRESS SET Add1=LEFT(LTRIM(RTRIM(Add1)),300) WHERE LEN(LTRIM(RTRIM(Add1)))>300  
 UPDATE #TEMPADDRESS SET Add2=LEFT(LTRIM(RTRIM(Add2)),100) WHERE LEN(LTRIM(RTRIM(Add2)))>100  
 UPDATE #TEMPADDRESS SET Add3=LEFT(LTRIM(RTRIM(Add3)),100) WHERE LEN(LTRIM(RTRIM(Add3)))>100  
 UPDATE #TEMPADDRESS SET TOWN=LEFT(LTRIM(RTRIM(TOWN)),50) WHERE LEN(LTRIM(RTRIM(TOWN)))>50  
  UPDATE #TEMPADDRESS SET CITY=LEFT(LTRIM(RTRIM(CITY)),50) WHERE LEN(LTRIM(RTRIM(CITY)))>50  
  UPDATE #TEMPADDRESS SET PIN=LEFT(LTRIM(RTRIM(PIN)),15) WHERE LEN(LTRIM(RTRIM(PIN)))>15  
  UPDATE #TEMPADDRESS SET COUNTRY=LEFT(LTRIM(RTRIM(COUNTRY)),50) WHERE LEN(LTRIM(RTRIM(COUNTRY)))>50  
   UPDATE #TEMPADDRESS SET STATE=LEFT(LTRIM(RTRIM(STATE)),50) WHERE LEN(LTRIM(RTRIM(STATE)))>50  
     
    TRUNCATE TABLE  Stgtbl_ClientAddress    
   INSERT INTO Stgtbl_ClientAddress  
   (  
   ClientCode,AddType,Add1,Add2,Add3,Town,City,State,Country,Pin  
 )    
  SELECT ClientCode,AddType,Add1,Add2,Add3,Town,City,State,Country,Pin FROM #TEMPADDRESS ORDER BY ClientCode    
      
  TRUNCATE TABLE Stgtbl_ClientContactDet    
      
  INSERT INTO Stgtbl_ClientContactDet  
  (  
   ClientCode,ContactType,ContactDet,DefaultCon  
  
  )    
  SELECT *,0 FROM #TEMPCONTACT    
       
    
  DROP TABLE #ACTIVE_CLIENT  
  DROP TABLE #TEMPADDRESS  
  DROP TABLE #TEMPCLIENTADDRESSWITHCONTACT  
  DROP TABLE #TEMPCONTACT  
    
    
    
  /* -----------Code for mail alert-------------*/  
  
DECLARE @COUNT INT  
DECLARE @COUNT1  varchar(10)   
  
DECLARE @COUNT_1 INT  
DECLARE @COUNT_2  varchar(10)   
  
DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)                    
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)     
  
SELECT @COUNT = COUNT(ClientCode) FROM Stgtbl_ClientAddress with(nolock)  
  
--SELECT @COUNT AS CLIENTCODE  
SET @COUNT1 = @COUNT  
  
SELECT @COUNT_1 = COUNT(ClientCode) FROM Stgtbl_ClientContactDet with(nolock)  
SET @COUNT_2 = @COUNT_1  
  
DECLARE @TOTALCOUNT VARCHAR(20)  
SET @TOTALCOUNT = @COUNT + @COUNT_1  
  
DECLARE @DATE VARCHAR(12)  
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))  
  
                
  
SET @S1 = 'SOS Alert For process SPX_UPDATE_STGTBL_CLIENTADDRESSWITHCONTACT on date '+@DATE+''  
  
set @mess='Dear ALL<br><br>                                      
                                      
 The process SPX_UPDATE_STGTBL_CLIENTADDRESSWITHCONTACT has been updated '+@COUNT1+' record into Stgtbl_ClientAddress, <BR>  
 '+@COUNT_2+' record into Stgtbl_ClientContactDet <br> and total number of records updated '+@TOTALCOUNT+' for date '+@DATE+'                                        
                    
<br> <br>                                  
by SOS process.'                                                         
 set @email='manish.shukla@angelbroking.com'                     
 --set @email='amit.s@angelbroking.com'                                                                                                           
exec msdb.dbo.sp_send_dbmail                                                                                                                           
@recipients  = @email,                                                                                                               
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',                                                                                                               
@profile_name = 'KYC',                                                                                                                                  
@body_format ='html',                                                              
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',                                      
--@file_attachments =@attach,                                                                                                                                                               
@body =@mess

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_UpdateHoldingForDp_Synergy
-- --------------------------------------------------

CREATE proc [dbo].[Spx_UpdateHoldingForDp_Synergy]
as

Select Nise_Party_Code,Client_Code,First_Hold_Name into #Client_Master 
from ABCSOORACLEMDLW.Synergy.Dbo.tbl_client_master M WITH(NOLOCK)
where isnull(M.NISE_PARTY_CODE ,'')<>''

Select Hld_IsIn_Code,HLD_AC_POS,Hld_Ac_Code into #Holding from ABCSOORACLEMDLW.Synergy.Dbo.holding H WITH(NOLOCK)

select Close_price,Isin,Exch_Code,Rate_Date into #IsIn from ABCSOORACLEMDLW.Synergy.Dbo.Vw_ISIN_Rate_Master with(Nolock) 

truncate table tbl_HoldingForDp_Synergy 

Insert into tbl_HoldingForDp_Synergy
(
 Party_Code,Client_Code,Client_Name ,Holding_Value
)

SELECT Party_code=ISNULL(M.Nise_Party_Code,''),Client_code=M.Client_Code,Client_Name=M.First_Hold_Name,

Holding_Value=SUM(H.HLD_AC_POS*V.Close_price)
FROM #Holding H WITH(NOLOCK) 
INNER JOIN #Client_Master M WITH(NOLOCK) ON M.Client_Code = H.Hld_Ac_Code
INNER JOIN #IsIn V WITH (NOLOCK) ON H.Hld_Isin_Code = V.Isin
WHERE V.Rate_Date IN (SELECT MAX(RATE_DATE) FROM #IsIn VRM WITH (NOLOCK)
						WHERE V.Isin = VRM.Isin AND V.Exch_Code = VRM.Exch_Code)
  AND isnull(M.NISE_PARTY_CODE ,'')<>'' AND V.Exch_Code = 'BSEEQ'
GROUP BY M.Nise_Party_Code,M.Client_Code,M.First_Hold_Name

drop table #Client_Master
drop table #Holding
drop table #IsIn

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_UpdateSebibannedDetails
-- --------------------------------------------------

CREATE Proc Spx_UpdateSebibannedDetails
as

select * into #SebiBaneedDetails from INTRANET.TESTDB.DBO.SEBI_BANNED WITH(NOLOCK)

update #SebiBaneedDetails set Name=left(name,100) where len(Name)>100
update #SebiBaneedDetails set Pan_No=left(Pan_No,10) where len(Pan_No)>10
update #SebiBaneedDetails set Order_No=left(Order_No,100) where len(Order_No)>100

truncate table Stgtbl_ClientDebar_List

Insert into Stgtbl_ClientDebar_List
(
ClientName,PANNo,OrderNo,OrderDate,Details,DebarmentUptoDt,RecordDate
)


select Name,Pan_No,order_no,dt_sebi_order,Brief_particulars,'12/01/2049',dt_sebi_order from #SebiBaneedDetails

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Update_SOS_DP_stgtbl
-- --------------------------------------------------
CREATE PROC [dbo].[usp_Update_SOS_DP_stgtbl]
AS

BEGIN

-- updation for holding
exec Spx_UpdateHoldingForDp_Synergy
SELECT *, HLD_FLAG = 'FH' INTO #TBL_CLIENT_MASTER
FROM [AngelDP4].DMAT.dbo.Tbl_CLIENT_MASTER WITH(NOLOCK)

 -- As requested by Fareed on 25/01/2016 to remove those code which is mnot exist in Bo
 select cl_code into #Bo from Anand1.Msajag.dbo.client_details with(Nolock)
 
 delete from #TBL_CLIENT_MASTER where Nise_Party_Code not in (Select cl_code from #Bo)

SELECT * INTO #TYPE_MASTER
FROM  [AngelDP4].DMAT.dbo.TYPE_MASTER WITH (NOLOCK)



SELECT * INTO #SYNERGY_BRANCH_MASTER
FROM ABCSOORACLEMDLW.SYNERGY.DBO.SYNERGY_BRANCH_MASTER WITH (NOLOCK)

/*
ALTER TABLE #TBL_CLIENT_MASTER ADD HLD_FLAG VARCHAR(2)
UPDATE #TBL_CLIENT_MASTER SET HLD_FLAG = 'FH'
*/

/**************************** DP CLIENT DETAILS *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTDETAILS_BOTH

INSERT INTO SOS_STGTBL_DPCLIENTDETAILS_BOTH
SELECT
DEPOSITORY='CDSL',
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
FH_NAME=FIRST_HOLD_NAME,
FH_FNAME = LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(FIRST_HOLD_NAME, 0, CHARINDEX(' ', FIRST_HOLD_NAME)) ELSE Null END))),
FH_MNAME = LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(FIRST_HOLD_NAME, CHARINDEX(' ', FIRST_HOLD_NAME) + 1, CHARINDEX(' ', SUBSTRING(FIRST_HOLD_NAME, CHARINDEX(' ', FIRST_HOLD_NAME) + 1, LEN(FIRST_HOLD_NAME)))) ELSE Null END))),
FH_LNAME = LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(FIRST_HOLD_NAME, CHARINDEX(' ', FIRST_HOLD_NAME) + CHARINDEX(' ', SUBSTRING(FIRST_HOLD_NAME, CHARINDEX(' ', FIRST_HOLD_NAME) + 1, LEN(FIRST_HOLD_NAME))) + 1, 50) ELSE Null END))),
SH_NAME=SECOND_HOLD_NAME,
SH_FNAME = (CASE WHEN ISNULL(SECOND_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(SECOND_HOLD_NAME, 0, CHARINDEX(' ', SECOND_HOLD_NAME)) ELSE Null END))) ELSE Null END),
SH_MNAME = (CASE WHEN ISNULL(SECOND_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(SECOND_HOLD_NAME, CHARINDEX(' ', SECOND_HOLD_NAME) + 1, CHARINDEX(' ', SUBSTRING(SECOND_HOLD_NAME, CHARINDEX(' ', SECOND_HOLD_NAME) + 1, LEN(SECOND_HOLD_NAME)))) ELSE Null END))) ELSE Null END),
SH_LNAME = (CASE WHEN ISNULL(SECOND_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(SECOND_HOLD_NAME, CHARINDEX(' ', SECOND_HOLD_NAME) + CHARINDEX(' ', SUBSTRING(SECOND_HOLD_NAME, CHARINDEX(' ', SECOND_HOLD_NAME) + 1, LEN(SECOND_HOLD_NAME))) + 1, 50) ELSE Null END))) ELSE Null END),
TH_NAME=THIRD_HOLD_NAME,
TH_FNAME =(CASE WHEN ISNULL(THIRD_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(THIRD_HOLD_NAME, 0, CHARINDEX(' ', THIRD_HOLD_NAME)) ELSE Null END))) ELSE Null END),
TH_MNAME=(CASE WHEN ISNULL(THIRD_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(THIRD_HOLD_NAME, CHARINDEX(' ', THIRD_HOLD_NAME) + 1, CHARINDEX(' ', SUBSTRING(THIRD_HOLD_NAME, CHARINDEX(' ', THIRD_HOLD_NAME) + 1, LEN(THIRD_HOLD_NAME)))) ELSE Null END))) ELSE Null END),
TH_LNAME=(CASE WHEN ISNULL(THIRD_HOLD_NAME, '') <> '' THEN LTRIM(RTRIM((CASE WHEN TYPE = 'Individual' THEN SUBSTRING(THIRD_HOLD_NAME, CHARINDEX(' ', THIRD_HOLD_NAME) + CHARINDEX(' ', SUBSTRING(THIRD_HOLD_NAME, CHARINDEX(' ', THIRD_HOLD_NAME) + 1, LEN(THIRD_HOLD_NAME))) + 1, 50) ELSE Null END))) ELSE Null END),
FG_NAME='',
FG_FNAME='',
FG_MNAME='',
FG_LNAME='',
SG_NAME='',
SG_FNAME='',
SG_MNAME='',
SG_LNAME='',
TG_NAME='',
TG_FNAME='',
TG_MNAME='',
TG_LNAME='',
NM_NAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') = '' THEN ISNULL(NOMI_GUARD_NAME, '') ELSE '' END),
NM_FNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') = '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, 0, CHARINDEX(' ', NOMI_GUARD_NAME)))) ELSE '' END),
NM_MNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') = '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, CHARINDEX(' ', SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, LEN(NOMI_GUARD_NAME)))))) ELSE '' END),
NM_LNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') = '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + CHARINDEX(' ', SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, LEN(NOMI_GUARD_NAME))) + 1, 50))) ELSE '' END),
NG_NAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') <> '' THEN ISNULL(NOMI_GUARD_NAME, '') ELSE '' END),
NG_FNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, 0, CHARINDEX(' ', NOMI_GUARD_NAME)))) ELSE '' END),
NG_MNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, CHARINDEX(' ', SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, LEN(NOMI_GUARD_NAME)))))) ELSE '' END),
NG_LNAME=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + CHARINDEX(' ', SUBSTRING(NOMI_GUARD_NAME, CHARINDEX(' ', NOMI_GUARD_NAME) + 1, LEN(NOMI_GUARD_NAME))) + 1, 50))) ELSE '' END),
POA_NAME=ISNULL(POA_NAME, ''),
POA_FNAME=(CASE WHEN ISNULL(POA_NAME, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(POA_NAME, 0, CHARINDEX(' ', POA_NAME)))) ELSE '' END),
POA_MNAME=(CASE WHEN ISNULL(POA_NAME, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(POA_NAME, CHARINDEX(' ', POA_NAME) + 1, CHARINDEX(' ', SUBSTRING(POA_NAME, CHARINDEX(' ', POA_NAME) + 1, LEN(POA_NAME)))))) ELSE '' END),
POA_LNAME=(CASE WHEN ISNULL(POA_NAME, '') <> '' THEN LTRIM(RTRIM(SUBSTRING(POA_NAME, CHARINDEX(' ', POA_NAME) + CHARINDEX(' ', SUBSTRING(POA_NAME, CHARINDEX(' ', POA_NAME) + 1, LEN(POA_NAME))) + 1, 50))) ELSE '' END),
POATYPE=(CASE WHEN POA_TYPE = 'B' THEN 'Internal' WHEN POA_TYPE = 'G' THEN 'External' ELSE POA_TYPE END),
FH_PAN=(CASE WHEN LEN(ITPAN) = 10 THEN ITPAN ELSE '' END), --FIRST_HOLD_PAN, AS EMAIL ADDRESS IS THERE IN DB
SH_PAN=(CASE WHEN LEN(SECOND_HOLD_ITPAN) = 10 THEN SECOND_HOLD_ITPAN ELSE '' END), -- 11 CAHR IN PAN NO LTRIM(RTRIM(SECOND_HOLD_ITPAN)),
TH_PAN=(CASE WHEN LEN(THIRD_HOLD_ITPAN) = 10 THEN THIRD_HOLD_ITPAN ELSE '' END),
FG_PAN='',
SG_PAN='',
TG_PAN='',
NM_PAN='',
NG_PAN='',
POA_PAN='',
FH_CATEGORY=ISNULL((CASE WHEN TYPE = 'FOREIGN NATIONAL' THEN 'FII' ELSE LEFT(TYPE, 3) END), ''),
SH_CATEGORY=(CASE WHEN ISNULL(SECOND_HOLD_NAME, '') <> '' THEN 'Ind' END),
TH_CATEGORY=(CASE WHEN ISNULL(THIRD_HOLD_NAME, '') <> '' THEN 'Ind' END),
FG_CATEGORY='',
SG_CATEGORY='',
TG_CATEGORY='',
NM_CATEGORY=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') = '' THEN 'Ind' ELSE '' END),
NG_CATEGORY=(CASE WHEN ISNULL(MINOR_BIRTH_DATE, '') <> '' THEN 'Ind' ELSE '' END),
POA_CATEGORY='',
FH_DOB=CONVERT(DATETIME, CASE WHEN ISDATE(ISNULL(BO_DOB, '')) = 1 THEN ISNULL(BO_DOB, '') ELSE '' END),
SH_DOB='',
TH_DOB='',
FG_DOB='',
SG_DOB='',
TG_DOB='',
NM_DOB='',
NG_DOB=ISNULL(MINOR_BIRTH_DATE, ''),
POA_DOB='',
FH_SEX=ISNULL(BO_SEX, ''),
SH_SEX='',
TH_SEX='',
FG_SEX='',
SG_SEX='',
TG_SEX='',
NM_SEX='',
NG_SEX='',
POA_SEX='',
ACCTOPENDT=ACTIVE_DATE,
ACCOUNTSTATUS=(CASE WHEN STATUS = 'ACTIVE' THEN UPPER(STATUS) ELSE 'INACTIVE' END),
STATUSDT=(CASE WHEN STATUS = 'ACTIVE' THEN ACTIVE_DATE ELSE ISNULL(CLOSE_REQ_DATE, '') END),
CLIENTUCC=ISNULL(NISE_PARTY_CODE, '')
FROM #TBL_CLIENT_MASTER

/*
/**************************** DP CLIENT DETAILS *******************************************************/
TRUNCATE TABLE SOS_STGTBL_CLIENTDPDET

INSERT INTO SOS_STGTBL_CLIENTDPDET
SELECT
[CLIENTCODE]=CLIENT_CODE,
[DEPOSITORY]='CDSL',
[DP NAME]='ANGEL BROKING LIMITED',
[DP ID]=LEFT(CLIENT_CODE, 8),
[BRANCH]=ISNULL(BRANCH_NAME, ''),
[DP ACCOUNT NUMBER]=CLIENT_CODE,
[FIRST HOLDER NAME]=LEFT(FIRST_HOLD_NAME, 50),
[FIRST HOLDER NAMEPAN]=(CASE WHEN LEN(ITPAN) = 10 THEN ITPAN ELSE '' END),
[SECOND HOLDER NAME]=ISNULL(SECOND_HOLD_NAME, ''),
[SECOND HOLDER NAMEPAN]=(CASE WHEN LEN(SECOND_HOLD_ITPAN) = 10 THEN SECOND_HOLD_ITPAN ELSE '' END),
[THIRD HOLDER NAME]=ISNULL(THIRD_HOLD_NAME, ''),
[THIRD HOLDER NAMEPAN]=(CASE WHEN LEN(THIRD_HOLD_ITPAN) = 10 THEN THIRD_HOLD_ITPAN ELSE '' END),
[POA HOLDER]='',
[POA PAN]='',
[FIRST HOLDER GUARDIAN]='',
[FIRST HOLDER GUARDIAN PAN]='',
[SECOND HOLDER GUARDIAN]='',
[SECOND HOLDER GUARDIAN PAN]='',
[THIRD HOLDER GUARDIAN]='',
[THIRD HOLDER GUARDIAN PAN]='',
[NOMINEE]='',
[NOMINEE PAN]='',
[NOMINEE GUARDIAN ]=LEFT(ISNULL(NOMI_GUARD_NAME, ''), 50),
[NOMINEE GUARDIAN PAN]=''
FROM #TBL_CLIENT_MASTER C
LEFT OUTER JOIN #SYNERGY_BRANCH_MASTER B ON (C.BRANCH_CODE = B.BRANCH_CODE)
*/

/**************************** DP CLIENT ADDRESS *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTADDRESS_BOTH

INSERT INTO SOS_STGTBL_DPCLIENTADDRESS_BOTH
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
ADD1=FIRST_HOLD_ADD1,
ADD2=FIRST_HOLD_ADD2,
ADD3=ISNULL(FIRST_HOLD_ADD3, ''),
CITY=FIRST_HOLD_ADD4,
STATE=FIRST_HOLD_STATE,
PIN=FIRST_HOLD_PIN,
COUNTRY=FIRST_HOLD_CNTRY
FROM #TBL_CLIENT_MASTER
/*
UNION
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG='NG',
ADD1=NOMI_GUARD_ADD1,
ADD2=NOMI_GUARD_ADD2,
ADD3='',
CITY='',
STATE='',
PIN='',
COUNTRY=''
FROM #TBL_CLIENT_MASTER WHERE ISNULL(NOMI_GUARD_NAME, '') <> ''
*/

/**************************** DP CLIENT BANK DETAILS *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTBANKDET_BOTH

INSERT INTO SOS_STGTBL_DPCLIENTBANKDET_BOTH
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
BANKNAME=ISNULL(BANK_NAME, ''),
BRANCHNAME=ISNULL(BANK_ADD4, ''),
MICR=(CASE WHEN LEN(BANK_MICR) = 10 THEN BANK_MICR ELSE '' END),-- AS HAVING 11 MAX CHAR
ACCOUNTNO=ISNULL(BANK_ACCNO, ''),
FIRSTHOLDER=Null, --LEFT(FIRST_HOLD_NAME, 50),-- AS HAVING MAX SIZE 78
FSTHOLDPAN=Null, --(CASE WHEN LEN(ITPAN) = 10 THEN ITPAN ELSE '' END),--AS FRST HOLD PAN AS EMAIL ADDRESS,
SECONDHOLDER=Null, --ISNULL(SECOND_HOLD_NAME, ''),
SECHOLDPAN=Null, --(CASE WHEN LEN(SECOND_HOLD_ITPAN) = 10 THEN SECOND_HOLD_ITPAN ELSE '' END),
THIRDHOLDER=Null, --ISNULL(THIRD_HOLD_NAME, ''),
TRDHOLDERPAN=Null, --(CASE WHEN LEN(THIRD_HOLD_ITPAN) = 10 THEN THIRD_HOLD_ITPAN ELSE '' END),
POAHOLDER=Null,
POAPAN=Null,
RELATIONPERIOD=Null
FROM #TBL_CLIENT_MASTER


/**************************** DP CLIENT CONTACT DETAILS *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTCONTACTDET_BOTH

INSERT INTO SOS_STGTBL_DPCLIENTCONTACTDET_BOTH
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
CONTACTTYPE='Home Phone',--TYPE AS THEY HAVE MORE CHAR
CONTACTDET=FIRST_HOLD_PHONE,
DEFAULTCON=0
FROM #TBL_CLIENT_MASTER WHERE ISNULL(FIRST_HOLD_PHONE, '') <> ''
UNION
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
CONTACTTYPE= 'Mobile',--TYPE AS THEY HAVE MORE CHAR
CONTACTDET=FIRST_HOLD_MOBILE,
DEFAULTCON=0
FROM #TBL_CLIENT_MASTER WHERE ISNULL(FIRST_HOLD_MOBILE, '') <> ''
UNION
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
CONTACTTYPE= 'Email Id',--TYPE AS THEY HAVE MORE CHAR
CONTACTDET=EMAIL_ADD,
DEFAULTCON=0
FROM #TBL_CLIENT_MASTER WHERE ISNULL(EMAIL_ADD, '') <> ''
UNION
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
CONTACTTYPE= 'Fax No',--TYPE AS THEY HAVE MORE CHAR
CONTACTDET=FIRST_HOLD_FAX,
DEFAULTCON=0
FROM #TBL_CLIENT_MASTER WHERE ISNULL(FIRST_HOLD_FAX, '') <> ''

/*
UPDATE SOS_STGTBL_DPCLIENTCONTACTDET_BOTH
SET CONTACTTYPE =
(CASE WHEN CONTACTTYPE = 1 THEN 'Home Phone'
WHEN CONTACTTYPE = 2 THEN 'Office Phone'
WHEN CONTACTTYPE = 3 THEN 'Email Id'
WHEN CONTACTTYPE = 4 THEN 'Fax No'
WHEN CONTACTTYPE = 5 THEN 'Mobile'
WHEN CONTACTTYPE = 6 THEN 'C/o.'
ELSE '' END)
*/


/**************************** DP CLIENT CONTACT PERSON *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTCONTACTPERSON

INSERT INTO SOS_STGTBL_DPCLIENTCONTACTPERSON
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
CONTACTNAME=ISNULL(CONTACT_PERSON, ''),
DESIGNATION='',
PAN='',----AS FRST HOLD PAN AS EMAIL ADDRESS,
ADD1='', ADD2='',
ADD3='',
CITY='',
STATE='',
COUNTRY='',
PIN='',
PHONE1='',
PHONE2='',
MOBILE='',
FAX='',
EMAIL='',
RELATIONPERD='',
FROMDATE='',
TILLDATE=''
FROM #TBL_CLIENT_MASTER


/**************************** DP CLIENT INCOME *******************************************************/
TRUNCATE TABLE SOS_STGTBL_DPCLIENTNETWORTHINCOME

INSERT INTO SOS_STGTBL_DPCLIENTNETWORTHINCOME
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
INCOMERANGE=ISNULL(DESCRIPTION, ''),
NETWORTHRANGE='',
NETWORTHASRM='',
NETWORTHVALUE=0.00
FROM #TBL_CLIENT_MASTER C
LEFT OUTER JOIN #TYPE_MASTER T
ON (C.INCOME_CODE = T.CODE AND T.TYPE = 'INCOME')


/**************************** DP RISK CATEGORY *******************************************************/
TRUNCATE TABLE STGTBL_DPCLIENTRISKCATEGORY

INSERT INTO STGTBL_DPCLIENTRISKCATEGORY
SELECT
DPID=LEFT(CLIENT_CODE, 8),
BOID=CLIENT_CODE,
HLDFLAG=HLD_FLAG,
RISKCATTYPE='CSC Risk',
RISKCATEGORY='L3',
RISKTYPE='Low',
FROMDT=GETDATE()
FROM #TBL_CLIENT_MASTER C
WHERE NOT EXISTS (SELECT * FROM STGTBL_DPCLIENTRISKCATEGORY S WHERE C.CLIENT_CODE = S.BOID)



/**************************** DP SOT TRANSACTIONS DATA ************************************************/

SELECT * INTO #TRXN_DETAILS FROM ABCSOORACLEMDLW.SYNERGY.DBO.TRXN_DETAILS WITH (NOLOCK)
WHERE TD_CURDATE >= CONVERT(VARCHAR(11), GETDATE()-7)

SELECT * INTO #ISIN_MASTER
FROM ABCSOORACLEMDLW.SYNERGY.DBO.VW_ISIN_MASTER WITH (NOLOCK)

SELECT * INTO #ISIN_RATE
FROM ABCSOORACLEMDLW.SYNERGY.DBO.VW_ISIN_RATE_MASTER WITH (NOLOCK)
WHERE RATE_DATE >= CONVERT(VARCHAR(11), GETDATE()-7)

SELECT * INTO #TrxnTypes FROM ABCSOORACLEMDLW.SYNERGY.DBO.TrxnTypes WITH (NOLOCK)
SELECT * INTO #Angel_DPID_Master FROM ABCSOORACLEMDLW.SYNERGY.DBO.Angel_DPID_Master WITH (NOLOCK)

DELETE #TRXN_DETAILS FROM #TRXN_DETAILS T, #ANGEL_DPID_MASTER A
WHERE T.TD_AC_CODE = A.BOID

DELETE #TRXN_DETAILS FROM #TRXN_DETAILS T, #ANGEL_DPID_MASTER A
WHERE (CASE WHEN TD_COUNTERDP = '' THEN LEFT(TD_BENEFICIERY, 8) ELSE TD_COUNTERDP END) = A.DPID
AND (CASE WHEN LEFT(TD_BENEFICIERY, 2) = 'IN' THEN RIGHT(TD_BENEFICIERY, 8) ELSE TD_BENEFICIERY END) = A.BOID

DELETE FROM #TRXN_DETAILS WHERE TD_DESCRIPTION IN ('DEMAT', 'Demat Confirmation', 'Demat Rejection')
DELETE FROM #TRXN_DETAILS WHERE TD_DESCRIPTION IN ('PLEDGE ACCEPT', 'PLEDGE DELETE', 'PLEDGE REJECT', 'Pledge Reject:')

DELETE FROM SOS_STGTBL_DP_SOT WHERE TRNDATE >= CONVERT(VARCHAR(11), GETDATE()-7)

INSERT INTO SOS_STGTBL_DP_SOT
SELECT
Depository='CDSL',
DPID=LEFT(TD_AC_CODE, 8),
BOID=TD_AC_CODE,
ISINCode=TD_ISIN_CODE,
Qty=TD_QTY,
ClearingCorp=TD_CLEAR_CORPN,
CounterDPID=(CASE WHEN TD_COUNTERDP = '' THEN LEFT(TD_BENEFICIERY, 8) ELSE TD_COUNTERDP END),
CounterDPName='',
CounterBOID=(CASE WHEN LEFT(TD_BENEFICIERY, 2) = 'IN' THEN RIGHT(TD_BENEFICIERY, 8) ELSE TD_BENEFICIERY END),
TransactionRef=TD_REFERENCE,
Description=TD_TRXNO,
Category=CONVERT(VARBINARY, TD_CATEGORY),
ACTypeCode=CONVERT(VARBINARY, TD_AC_TYPE),
BalanceType='',
BookingCode=REPLACE(STR(TrxnCode, 4, 0), ' ', '0'),
--BookingCode=TD_TRXNO,--Mandatory
BookingDesc=TD_DESCRIPTION,--Mandatory
BookingType=TD_BOOKING_TYPE,
MarketType=TD_MARKET_TYPE,
SettlementNo=TD_SETTLEMENT,
Blocked=TD_BLOCKED,
BlockedCode=TD_BLOCKEDCD,
ReleaseDate=CONVERT(DATETIME, TD_RDATE),
TrnDate=CONVERT(DATETIME, TD_TRXDATE),
TrnTime=(CASE WHEN TD_TRXTIME <> 0 THEN CONVERT(DATETIME, TD_TRXTIME) ELSE '' END),
DebitCredit=TD_DEBIT_CREDIT,
CounterCMPBID=TD_COUNTERCMBPID,
Remarks=TD_REMARKS,
DisSlipNo='',--Mandatory where applicable
DISReason='',--Mandatory where applicable
ClosingRt=ISNULL(IR.CLOSE_PRICE,0),
ScripName=ISNULL(IM.COMP_NAME,'')
FROM #TRXN_DETAILS TD
INNER JOIN #TrxnTypes TT
ON (TD.TD_DESCRIPTION = TT.TrxnDescription)
INNER JOIN #ISIN_MASTER IM
ON (TD.TD_ISIN_CODE = IM.ISIN)
LEFT OUTER JOIN #ISIN_RATE IR
ON (TD.TD_CURDATE = IR.RATE_DATE AND TD.TD_ISIN_CODE = IR.ISIN)


CREATE TABLE #ISIN_LAST_CLOSE_PRICE
(
ISIN VARCHAR(16),
COMP_NAME VARCHAR(50),
RATE_DATE DATETIME,
CLOSE_PRICE MONEY
)

DECLARE @TODAYDATE VARCHAR(11)
SET @TODAYDATE = CONVERT(VARCHAR(11), GETDATE())

INSERT INTO #ISIN_LAST_CLOSE_PRICE
EXEC ABCSOORACLEMDLW.SYNERGY.DBO.USP_ISIN_CLOSEPRICE @TODAYDATE

DELETE FROM #ISIN_LAST_CLOSE_PRICE WHERE RATE_DATE >= CONVERT(VARCHAR(11), GETDATE()-7)

UPDATE SOS_STGTBL_DP_SOT SET CLOSINGRT = R.CLOSE_PRICE
FROM SOS_STGTBL_DP_SOT S WITH (NOLOCK), #ISIN_LAST_CLOSE_PRICE R
WHERE S.ISINCODE = R.ISIN AND TRNDATE >= CONVERT(VARCHAR(11), GETDATE()-7)
AND CLOSINGRT = 0



/******************************************************************************************************/
DROP TABLE #TBL_CLIENT_MASTER
DROP TABLE #TYPE_MASTER
DROP TABLE #SYNERGY_BRANCH_MASTER
drop table #Bo
DROP TABLE #TRXN_DETAILS





/* -----------Code for mail alert-------------*/

DECLARE @COUNT INT
DECLARE @COUNT1 varchar(10)

DECLARE @S AS VARCHAR(1000),@S1 AS VARCHAR(1000)
DECLARE @EMAIL VARCHAR(2000),@MESS AS VARCHAR(4000)

SELECT @COUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTDETAILS_BOTH WITH(NOLOCK)
SET @COUNT1 = @COUNT

DECLARE @DPCLIADDCOUNT INT
DECLARE @DPCLIADDCOUNT1 VARCHAR(10)

SELECT @DPCLIADDCOUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTADDRESS_BOTH WITH(NOLOCK)
SET @DPCLIADDCOUNT1 = @DPCLIADDCOUNT

DECLARE @DPCLIBANKDETCOUNT INT
DECLARE @DPCLIBANKDETCOUNT1 VARCHAR(10)

SELECT @DPCLIBANKDETCOUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTBANKDET_BOTH WITH(NOLOCK)
SET @DPCLIBANKDETCOUNT1 = @DPCLIBANKDETCOUNT
DECLARE @DPCLICONCTKDETCOUNT INT
DECLARE @DPCLICONCTKDETCOUNT1 VARCHAR(10)

SELECT @DPCLICONCTKDETCOUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTCONTACTDET_BOTH WITH(NOLOCK)
SET @DPCLICONCTKDETCOUNT1 = @DPCLICONCTKDETCOUNT

DECLARE @DPCLICONCTPRSNCOUNT INT
DECLARE @DPCLICONCTPRSNCOUNT1 VARCHAR(10)

SELECT @DPCLICONCTPRSNCOUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTCONTACTPERSON WITH(NOLOCK)
SET @DPCLICONCTPRSNCOUNT1 = @DPCLICONCTPRSNCOUNT

DECLARE @DPCLICONCTWINCMCOUNT INT DECLARE @DPCLICONCTWINCMCOUNT1 VARCHAR(10)

SELECT @DPCLICONCTWINCMCOUNT = COUNT(BOID) FROM SOS_STGTBL_DPCLIENTNETWORTHINCOME WITH(NOLOCK)
SET @DPCLICONCTWINCMCOUNT1 = @DPCLICONCTWINCMCOUNT

DECLARE @DPCLICONCTRCATCOUNT INT
DECLARE @DPCLICONCTRCATCOUNT1 VARCHAR(10)

SELECT @DPCLICONCTRCATCOUNT = COUNT(BOID) FROM STGTBL_DPCLIENTRISKCATEGORY WITH(NOLOCK)
SET @DPCLICONCTRCATCOUNT1 = @DPCLICONCTRCATCOUNT

DECLARE @DPSOTCOUNT INT
DECLARE @DPSOTCOUNT1 VARCHAR(10)

SELECT @DPSOTCOUNT = COUNT(BOID) FROM SOS_STGTBL_DP_SOT WITH(NOLOCK)
SET @DPSOTCOUNT1 = @DPSOTCOUNT

--DECLARE @TOTALCOUNT VARCHAR(50)
--SET @TOTALCOUNT = @COUNT1 + @DPCLIADDCOUNT1 + @DPCLIBANKDETCOUNT1 + @DPCLICONCTKDETCOUNT1 + @DPCLICONCTPRSNCOUNT1 + @DPCLICONCTWINCMCOUNT1 + @DPCLICONCTRCATCOUNT1 + @DPSOTCOUNT1


DECLARE @DATE VARCHAR(12)
SET @DATE = (SELECT CONVERT(VARCHAR(12), GETDATE(),103))



SET @S1 = 'SOS Alert For process usp_Update_SOS_DP_stgtbl on date '+@DATE+''

set @mess='Dear ALL<br><br>

The process usp_Update_SOS_DP_stgtbl has been updated below data for date '+@DATE+' <br>
'+@COUNT1+' record into SOS_STGTBL_DPCLIENTDETAILS_BOTH,
'+@DPCLIADDCOUNT1+' record into SOS_STGTBL_DPCLIENTADDRESS_BOTH, <br>
'+@DPCLIBANKDETCOUNT1+' record into SOS_STGTBL_DPCLIENTBANKDET_BOTH, <br>
'+@DPCLICONCTKDETCOUNT1+' record into SOS_STGTBL_DPCLIENTCONTACTDET_BOTH, <br>
'+@DPCLICONCTPRSNCOUNT1+' record into SOS_STGTBL_DPCLIENTCONTACTPERSON, <br>
'+@DPCLICONCTWINCMCOUNT1+' record into SOS_STGTBL_DPCLIENTNETWORTHINCOME, <br>
'+@DPCLICONCTRCATCOUNT1+' record into STGTBL_DPCLIENTRISKCATEGORY, <br>
'+@DPSOTCOUNT1+' record into SOS_STGTBL_DP_SOT

<br> <br>
by SOS process.'
set @email='paras.sankdecha@angelbroking.com'
--set @email='amit.s@angelbroking.com'
exec msdb.dbo.sp_send_dbmail
@recipients = @email,
@copy_recipients ='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com;manish.shukla@angelbroking.com',
--@blind_copy_recipients='amit.s@angelbroking.com;aravind.shenoy@angelbroking.com',
@profile_name = 'KYC',
@body_format ='html',
@subject = @S1, --'Alert For process ------------ on date '+@DATE+'',
--@file_attachments =@attach,
@body =@mess


END

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_ClientIPVDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_ClientIPVDetails]
(
    [Client Code] VARCHAR(16) NULL,
    [IPV Person Name] VARCHAR(100) NULL,
    [IPV Person PAN] VARCHAR(10) NULL,
    [Employee Code] VARCHAR(12) NULL,
    [Designation] VARCHAR(25) NULL,
    [Department] VARCHAR(25) NULL,
    [Exchange] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [IPV Date] DATETIME NULL,
    [Remarks] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_ClientPEPExposure
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_ClientPEPExposure]
(
    [Client Code] VARCHAR(16) NULL,
    [Political Person Name] VARCHAR(100) NULL,
    [Political Person PAN] VARCHAR(10) NULL,
    [PEP Relation With] VARCHAR(50) NULL,
    [Country] VARCHAR(20) NULL,
    [Relation] VARCHAR(50) NULL,
    [Relation Period] VARCHAR(15) NULL,
    [From Date] DATETIME NULL,
    [Till Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_ClientTradingPOA
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_ClientTradingPOA]
(
    [ClientCode] VARCHAR(20) NULL,
    [TradingPOAName] VARCHAR(150) NULL,
    [TradingPOAPAN] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_STGTBL_DP_SOT
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_STGTBL_DP_SOT]
(
    [Depository] VARCHAR(4) NULL,
    [DPID] VARCHAR(8) NULL,
    [BOID] VARCHAR(16) NULL,
    [ISINCode] VARCHAR(12) NULL,
    [Qty] NUMERIC(18, 4) NULL,
    [ClearingCorp] VARCHAR(8) NULL,
    [CounterDPID] VARCHAR(8) NULL,
    [CounterDPName] VARCHAR(150) NULL,
    [CounterBOID] VARCHAR(16) NULL,
    [TransactionRef] VARCHAR(20) NULL,
    [Description] VARCHAR(500) NULL,
    [Category] VARBINARY(4) NULL,
    [ACTypeCode] VARBINARY(3) NULL,
    [BalanceType] VARCHAR(80) NULL,
    [BookingCode] VARCHAR(5) NULL,
    [BookingDesc] VARCHAR(100) NULL,
    [BookingType] VARCHAR(2) NULL,
    [MarketType] VARCHAR(3) NULL,
    [SettlementNo] VARCHAR(13) NULL,
    [Blocked] VARCHAR(1) NULL,
    [BlockedCode] VARCHAR(2) NULL,
    [ReleaseDate] DATETIME NULL,
    [TrnDate] DATETIME NULL,
    [TrnTime] DATETIME NULL,
    [DebitCredit] VARCHAR(1) NULL,
    [CounterCMPBID] VARCHAR(8) NULL,
    [Remarks] VARCHAR(100) NULL,
    [DisSlipNo] VARCHAR(25) NULL,
    [DISReason] VARCHAR(100) NULL,
    [ClosingRt] NUMERIC(18, 2) NULL,
    [ScripName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_STGTBL_DPCLIENTCONTACTPERSON
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_STGTBL_DPCLIENTCONTACTPERSON]
(
    [DPID] VARCHAR(8) NULL,
    [BOID] VARCHAR(16) NULL,
    [ContactName] VARCHAR(150) NULL,
    [Designation] VARCHAR(50) NULL,
    [PAN] VARCHAR(10) NULL,
    [Add1] VARCHAR(50) NULL,
    [Add2] VARCHAR(50) NULL,
    [Add3] VARCHAR(50) NULL,
    [City] VARCHAR(40) NULL,
    [State] VARCHAR(50) NULL,
    [Country] VARCHAR(50) NULL,
    [Pin] VARCHAR(10) NULL,
    [Phone1] VARCHAR(50) NULL,
    [Phone2] VARCHAR(50) NULL,
    [Mobile] VARCHAR(10) NULL,
    [Fax] VARCHAR(50) NULL,
    [Email] VARCHAR(200) NULL,
    [RelationPerd] VARCHAR(50) NULL,
    [FromDate] DATETIME NULL,
    [TillDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_STGTBL_DPCLIENTNETWORTHINCOME
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_STGTBL_DPCLIENTNETWORTHINCOME]
(
    [DPID] VARCHAR(8) NULL,
    [BOID] VARCHAR(16) NULL,
    [HldFlag] VARCHAR(2) NULL,
    [IncomeRange] VARCHAR(50) NULL,
    [NetworthRange] VARCHAR(50) NULL,
    [NetworthasRM] VARCHAR(50) NULL,
    [NetWorthValue] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_NetworthCalculation
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_NetworthCalculation]
(
    [ClientCode] VARCHAR(20) NULL,
    [ClientName] VARCHAR(100) NULL,
    [NetworthCategory] VARCHAR(50) NULL,
    [CategoryType] VARCHAR(50) NULL,
    [Value] DECIMAL(18, 2) NULL,
    [Holding Period] VARCHAR(50) NULL,
    [Reason] VARCHAR(50) NULL,
    [DocProofRecd] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLAAffClientDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLAAffClientDetail]
(
    [IAffClientId] INT IDENTITY(1,1) NOT NULL,
    [IAffFirmSOSId] INT NOT NULL,
    [IAffPartyCode] VARCHAR(50) NOT NULL,
    [IAffRelationName] VARCHAR(50) NULL,
    [IAffRelationId] INT NULL,
    [IAffBussinessNatureId] INT NULL,
    [IAffBusinessNature] VARCHAR(50) NULL,
    [IAffEntityType] VARCHAR(50) NULL,
    [SAffCreatedBy] VARCHAR(50) NULL,
    [DAffCreatedDate] DATETIME NULL,
    [SAffUpdatedBy] VARCHAR(50) NULL,
    [DAffUpdatedDate] DATETIME NULL DEFAULT (getdate()),
    [SAffRelRelationName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLABusinessNature
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLABusinessNature]
(
    [IBusinessId] INT NOT NULL,
    [SBusinessName] VARCHAR(500) NULL,
    [DLastModifiedDate] DATETIME NULL DEFAULT (getdate()),
    [BIsActive] BIT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLAClientDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLAClientDetail]
(
    [IClientId] INT IDENTITY(1,1) NOT NULL,
    [ICFrmSOSId] INT NOT NULL,
    [SCPartyCode] VARCHAR(50) NULL,
    [SCFormerName] VARCHAR(50) NULL,
    [ICBusinessId] INT NULL,
    [ICBusinessNature] VARCHAR(50) NULL,
    [ICCountryId] INT NULL,
    [ICCountry] VARCHAR(50) NULL,
    [ICMajorCountryId] INT NULL,
    [ICMajorCountry] VARCHAR(50) NULL,
    [SCCreatedBy] VARCHAR(50) NULL,
    [DCCreatedDate] DATETIME NULL,
    [SCUpdatedBy] VARCHAR(50) NULL,
    [DCUpdatedDate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLADepositoryAccountDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLADepositoryAccountDetail]
(
    [IDPAccId] INT IDENTITY(1,1) NOT NULL,
    [IDAFirmSOSId] INT NOT NULL,
    [IDAPartyCode] VARCHAR(50) NOT NULL,
    [SDADepository] VARCHAR(50) NULL,
    [SDADPId] VARCHAR(50) NULL,
    [SDAClientId] VARCHAR(50) NULL,
    [SDAHolderName] VARCHAR(50) NULL,
    [SDACreatedBy] VARCHAR(50) NULL,
    [DDACreatedDate] DATETIME NULL,
    [SDAUpdatedBy] VARCHAR(50) NULL,
    [DDAUpdatedDate] DATETIME NOT NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLADirectorDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLADirectorDetail]
(
    [IDirectorId] INT IDENTITY(1,1) NOT NULL,
    [IDFirmSOSId] INT NOT NULL,
    [IDPartyCode] VARCHAR(50) NOT NULL,
    [IDDirectorName] VARCHAR(50) NULL,
    [IDEntityName] VARCHAR(50) NULL,
    [IDRelationID] INT NULL,
    [IDBusinessId] INT NULL,
    [IDBusinessNature] VARCHAR(50) NULL,
    [SDCreatedBy] VARCHAR(50) NULL,
    [DDCreatedDate] DATETIME NULL,
    [SDUpdatedBy] VARCHAR(50) NULL,
    [DDUpdatedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [SDRelationName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLAFirmDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLAFirmDetail]
(
    [IFirmSOSId] INT IDENTITY(1,1) NOT NULL,
    [SFirmPartyCode] VARCHAR(50) NOT NULL,
    [CFirmType] CHAR(5) NOT NULL,
    [IFirmKRA] INT NOT NULL,
    [DFirmKRAdate] DATETIME NULL,
    [DFirmUpdatedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [BFirmIsActive] BIT NOT NULL DEFAULT ((1)),
    [SFirmCreatedBy] VARCHAR(50) NULL,
    [DFirmCreatedDate] DATETIME NULL,
    [SFirmUpdatedBy] VARCHAR(50) NULL,
    [IResidentialDetailId] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLAJointAccountDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLAJointAccountDetail]
(
    [IJointAccId] INT IDENTITY(1,1) NOT NULL,
    [IJointAccFirmSOSId] INT NOT NULL,
    [SJointAccPartyCode] VARCHAR(50) NOT NULL,
    [SJointAccSecondHolderName] VARCHAR(50) NULL,
    [SJointAccThirdHolderName] VARCHAR(50) NULL,
    [SJointAccCreatedBy] VARCHAR(50) NULL,
    [DJointAccCreatedDate] DATETIME NULL,
    [SJointAccUpdatedBy] VARCHAR(50) NULL,
    [DJointAccUpdatedDate] DATETIME NOT NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLAPEPDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLAPEPDetail]
(
    [IPEPId] INT IDENTITY(1,1) NOT NULL,
    [IPEPFirmSOSId] INT NOT NULL,
    [SPEPPartyCode] VARCHAR(50) NOT NULL,
    [CPEPType] CHAR(5) NOT NULL,
    [SPEPName] VARCHAR(50) NULL,
    [IPEPRelationId] INT NULL,
    [SPEPPANNumber] VARCHAR(50) NULL,
    [SPEPCreatedBy] VARCHAR(50) NULL,
    [DPEPCreatedDate] DATETIME NULL,
    [SPEPUpdatedBy] VARCHAR(50) NULL,
    [DPEPUpdatedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [SPEPRelationName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLARelationDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLARelationDetail]
(
    [IRelationId] INT IDENTITY(1,1) NOT NULL,
    [IRelFirmSOSId] INT NOT NULL,
    [SRelPartyCode] VARCHAR(50) NOT NULL,
    [SRelUCC] VARCHAR(50) NULL,
    [IRelRelationId] INT NULL,
    [SRelCreatedBy] VARCHAR(50) NULL,
    [DRelCreatedDate] DATETIME NULL,
    [SRelUpdatedBy] VARCHAR(50) NULL,
    [DRelUpdatedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [SRelRelationName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SOS_Stgtbl_PMLARelationship
-- --------------------------------------------------
CREATE TABLE [dbo].[SOS_Stgtbl_PMLARelationship]
(
    [IRelationId] INT IDENTITY(1,1) NOT NULL,
    [SRelationName] VARCHAR(50) NOT NULL,
    [CType] CHAR(5) NOT NULL,
    [DLastModifiedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [BIsActive] BIT NOT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.Stgtbl_ClientDetails_Broking
-- --------------------------------------------------
CREATE TABLE [dbo].[Stgtbl_ClientDetails_Broking]
(
    [CashUCC] VARCHAR(12) NOT NULL,
    [FNOUcc] VARCHAR(12) NULL,
    [CashBO] VARCHAR(12) NULL,
    [PAN] VARCHAR(10) NULL,
    [UID] VARCHAR(12) NULL,
    [Name] VARCHAR(100) NULL,
    [FirstName] VARCHAR(50) NULL,
    [MiddleName] VARCHAR(50) NULL,
    [LastName] VARCHAR(50) NULL,
    [DOB] DATETIME NULL,
    [Gender] VARCHAR(10) NULL,
    [UCCCategory] VARCHAR(10) NULL,
    [C_Add1] VARCHAR(100) NULL,
    [C_Add2] VARCHAR(100) NULL,
    [C_Add3] VARCHAR(100) NULL,
    [C_Town] VARCHAR(50) NULL,
    [C_City] VARCHAR(50) NULL,
    [C_State] VARCHAR(50) NULL,
    [C_Country] VARCHAR(50) NULL,
    [C_Pin] VARCHAR(15) NULL,
    [P_Add1] VARCHAR(100) NULL,
    [P_Add2] VARCHAR(100) NULL,
    [P_Add3] VARCHAR(100) NULL,
    [P_Town] VARCHAR(50) NULL,
    [P_City] VARCHAR(50) NULL,
    [P_State] VARCHAR(50) NULL,
    [P_Country] VARCHAR(50) NULL,
    [P_Pin] VARCHAR(15) NULL,
    [IncomeRange] VARCHAR(50) NULL,
    [NetworthRange] VARCHAR(50) NULL,
    [NetworthasRM] VARCHAR(50) NULL,
    [SEBIRegnNo] VARCHAR(25) NULL,
    [PassportNo] VARCHAR(25) NULL,
    [PassportCountry] VARCHAR(25) NULL,
    [IssueDate] DATETIME NULL,
    [ExpiryDate] DATETIME NULL,
    [FamilyCode] VARCHAR(15) NULL,
    [BranchCode] VARCHAR(15) NULL,
    [BranchName] VARCHAR(100) NULL,
    [SubBrokerCode] VARCHAR(15) NULL,
    [SubBrokerName] VARCHAR(100) NULL,
    [SubBrokerPAN] VARCHAR(50) NULL,
    [IntroducerCode] VARCHAR(15) NULL,
    [IntroducerName] VARCHAR(100) NULL,
    [IntroducerPAN] VARCHAR(10) NULL,
    [DealerCode] VARCHAR(15) NULL,
    [DealerName] VARCHAR(100) NULL,
    [DealerPAN] VARCHAR(50) NULL,
    [RMCode] VARCHAR(15) NULL,
    [RMName] VARCHAR(100) NULL,
    [RMPAN] VARCHAR(50) NULL,
    [Status] VARCHAR(15) NULL,
    [LstTradeDt] DATETIME NULL,
    [NetWorthValue] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_ClientDPDet
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_ClientDPDet]
(
    [ClientCode] VARCHAR(16) NOT NULL,
    [Depository] VARCHAR(4) NULL,
    [DPName] VARCHAR(100) NULL,
    [DPID] VARCHAR(8) NULL,
    [BranchName] VARCHAR(100) NULL,
    [DPClientID] VARCHAR(16) NULL,
    [FirstHolder] VARCHAR(100) NULL,
    [FstHoldPAN] VARCHAR(10) NULL,
    [SecondHolder] VARCHAR(100) NULL,
    [SecHoldPAN] VARCHAR(10) NULL,
    [ThirdHolder] VARCHAR(100) NULL,
    [TrdHolderPAN] VARCHAR(10) NULL,
    [POAHolder] VARCHAR(100) NULL,
    [POAPAN] VARCHAR(10) NULL,
    [RelationPeriod] VARCHAR(50) NULL,
    [ThirdPartyAcct] VARCHAR(10) NULL,
    [NomineeName] VARCHAR(100) NULL,
    [NomineePAN] VARCHAR(10) NULL,
    [FHoldGuardian] VARCHAR(100) NULL,
    [FHoldGuardianPAN] VARCHAR(10) NULL,
    [SHoldGuardian] VARCHAR(100) NULL,
    [SHoldGuardianPAN] VARCHAR(10) NULL,
    [THoldGuardian] VARCHAR(100) NULL,
    [THoldGuardianPAN] VARCHAR(10) NULL,
    [NomineeGuardian] VARCHAR(100) NULL,
    [NomineeGuardianPAN] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Stgtbl_ClientGroupMapping28032013
-- --------------------------------------------------
CREATE TABLE [dbo].[Stgtbl_ClientGroupMapping28032013]
(
    [ClientCode] VARCHAR(20) NULL,
    [ClientName] VARCHAR(100) NULL,
    [ClientPAN] VARCHAR(10) NULL,
    [GroupName] VARCHAR(50) NULL,
    [GroupShortName] VARCHAR(50) NULL,
    [Regulator] VARCHAR(1) NULL,
    [Reason] VARCHAR(100) NULL,
    [RecordDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STGTBL_CLIENTINTERMEDIARYMASTER28032013
-- --------------------------------------------------
CREATE TABLE [dbo].[STGTBL_CLIENTINTERMEDIARYMASTER28032013]
(
    [IntermedType] VARCHAR(20) NOT NULL,
    [IntermedCode] VARCHAR(15) NULL,
    [Name] VARCHAR(100) NULL,
    [PAN] VARCHAR(10) NULL,
    [ParentCode] VARCHAR(15) NULL,
    [Add1] VARCHAR(100) NULL,
    [Add2] VARCHAR(100) NULL,
    [Add3] VARCHAR(100) NULL,
    [City] VARCHAR(50) NULL,
    [State] VARCHAR(50) NULL,
    [Country] VARCHAR(50) NULL,
    [Pin] VARCHAR(15) NULL,
    [Phone1] VARCHAR(50) NULL,
    [Phone2] VARCHAR(50) NULL,
    [Mobile] VARCHAR(10) NULL,
    [Fax] VARCHAR(15) NULL,
    [Email] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_ClientMultiCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_ClientMultiCategory]
(
    [ClientCode] VARCHAR(16) NULL,
    [CategoryMainType] VARCHAR(50) NULL,
    [CategorySubType] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STGTBL_CLIENTMULTICATEGORY28032013
-- --------------------------------------------------
CREATE TABLE [dbo].[STGTBL_CLIENTMULTICATEGORY28032013]
(
    [ClientCode] VARCHAR(16) NULL,
    [CategoryMainType] VARCHAR(50) NULL,
    [CategorySubType] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_ClientRiskCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_ClientRiskCategory]
(
    [ClientCode] VARCHAR(15) NOT NULL,
    [RiskCatType] VARCHAR(25) NOT NULL,
    [RiskCategory] VARCHAR(50) NOT NULL,
    [RiskType] VARCHAR(10) NOT NULL,
    [FromDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_ClientRiskCategory28032013
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_ClientRiskCategory28032013]
(
    [ClientCode] VARCHAR(15) NOT NULL,
    [RiskCatType] VARCHAR(25) NOT NULL,
    [RiskCategory] VARCHAR(50) NOT NULL,
    [RiskType] VARCHAR(10) NOT NULL,
    [FromDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_ClientSegmentStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_ClientSegmentStatus]
(
    [ClientCode] VARCHAR(20) NOT NULL,
    [Exchange] VARCHAR(10) NULL,
    [Segment] VARCHAR(15) NULL,
    [Status] VARCHAR(20) NULL,
    [StatusDt] DATETIME NULL,
    [LstTradeDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_DPClientRiskCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_DPClientRiskCategory]
(
    [DPID] VARCHAR(8) NULL,
    [BOID] VARCHAR(16) NULL,
    [HldFlag] VARCHAR(2) NULL,
    [RiskCatType] VARCHAR(25) NOT NULL,
    [RiskCategory] VARCHAR(50) NOT NULL,
    [RiskType] VARCHAR(10) NOT NULL,
    [FromDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.stgtbl_Employees_renamed_to_PII
-- --------------------------------------------------
CREATE TABLE [dbo].[stgtbl_Employees_renamed_to_PII]
(
    [EmpName] VARCHAR(100) NULL,
    [EmpPAN] VARCHAR(10) NULL,
    [EmpUID] VARCHAR(12) NULL,
    [EmpDOB] DATETIME NULL,
    [EmpCode] VARCHAR(12) NULL,
    [Designation] VARCHAR(50) NULL,
    [Department] VARCHAR(50) NULL,
    [JoinDate] DATETIME NULL,
    [RelevDate] DATETIME NULL,
    [AssociateType] VARCHAR(15) NULL,
    [AssociateCode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HoldingForDp_Synergy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HoldingForDp_Synergy]
(
    [Party_Code] VARCHAR(25) NULL,
    [Client_Code] VARCHAR(20) NULL,
    [Client_Name] VARCHAR(200) NULL,
    [Holding_Value] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Age
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Age]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Age] VARCHAR(3) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_B2B_B2C_Client
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_B2B_B2C_Client]
(
    [Occupation] VARCHAR(50) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Bank_Type
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Bank_Type]
(
    [Bank_Type] VARCHAR(20) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Capital_Market_Experience
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Capital_Market_Experience]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Capital_Market_Experience] VARCHAR(10) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Education
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Education]
(
    [Education] VARCHAR(40) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Gender
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Gender]
(
    [Gender] VARCHAR(2) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_IncomeLevel
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_IncomeLevel]
(
    [Income_Level] VARCHAR(10) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Occupation
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Occupation]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Occupation] VARCHAR(50) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Online_Offline_Client
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Online_Offline_Client]
(
    [Online_Offline] VARCHAR(20) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RiskCategorization_Residence_Type
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RiskCategorization_Residence_Type]
(
    [Residence_Type] VARCHAR(20) NULL,
    [Weight] VARCHAR(3) NULL,
    [Point] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SOSJOBLOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SOSJOBLOG]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [PROCESSNAME] VARCHAR(100) NULL,
    [PROCESSDATE] DATETIME NULL,
    [STARTTIME] DATETIME NULL,
    [ENDTIME] DATETIME NULL,
    [STATUS] VARCHAR(1) NULL,
    [ERROR] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SOSRmDetails_History
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SOSRmDetails_History]
(
    [Reg_Code] VARCHAR(50) NULL,
    [RmEmpNo] VARCHAR(50) NULL,
    [Email] VARCHAR(150) NULL,
    [Created_By] VARCHAR(50) NULL,
    [Creation_date] DATETIME NULL,
    [Updated_By] VARCHAR(50) NULL,
    [Updation_date] DATETIME NULL,
    [Edit_By] VARCHAR(20) NULL,
    [Edit_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_tempDpDetailFor_ETT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_tempDpDetailFor_ETT]
(
    [clientcode] VARCHAR(20) NULL,
    [DpClientId] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ecn_08042013
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ecn_08042013]
(
    [cl_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vi_Dp_HoldingFromSynergy
-- --------------------------------------------------



--select * from Vi_Dp_HoldingFromSynergy where party_code='Rp61'
CREATE View [dbo].[Vi_Dp_HoldingFromSynergy]

as

SELECT Party_Code,Client_Code,Client_Name ,Holding_Value from tbl_HoldingForDp_Synergy with(Nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vi_GetInterMediatoryMAster
-- --------------------------------------------------



Create View Vi_GetInterMediatoryMAster
As


select * from 
 stgtbl_ClientIntermediaryMaster with(Nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vi_GetRiskDetails
-- --------------------------------------------------

CREATE View Vi_GetRiskDetails
as

Select ClientCode as Party_Code,RiskCatType,RiskCategory,RiskType from stgtbl_ClientRiskCategory with(Nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vi_IncomeDetails
-- --------------------------------------------------



CREATE View Vi_IncomeDetails

as

Select CashUCC  as Party_Code,IncomeRange from Stgtbl_ClientDetails_Broking with(Nolock)

GO

